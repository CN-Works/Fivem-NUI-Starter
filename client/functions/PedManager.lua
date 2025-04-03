local PedManager = {
    config = {
        frozen = true,
        invincible = true,
        stoic = true,
        fade = true,
        distanceLabel = 5.0,
    },
    peds = {},
}

function GetPedManager()
    return PedManager
end

local exemple = {
    model = "s_m_m_security_01",
    coords = vec3(15.0, 30.0, 45.0),
    heading = 180.0,
    gender = "male",
    --animDict = "",
    --animName = "",
    pedLabel = "Morgan",
    pedLabelOffset = 1.0,
}

PedManager.nearby = function(model, coords, heading, gender, animDict, animName, scenario)
	local genderNum = 0
    local ped = nil

	RequestModel(GetHashKey(model))

	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(50)
	end
	
	-- Convert plain language genders into what fivem uses for ped types.
	if gender == "male" then
		genderNum = 4
	end

    if gender == "female" then 
		genderNum = 5
	end	

    -- Create the ped
    ped = CreatePed(genderNum, GetHashKey(model), vec3(coords.x, coords.y, coords.z-0.95), heading, false, true)
	
	SetEntityAlpha(ped, 0, false)
	
	if PedManager.config.frozen then
		FreezeEntityPosition(ped, true) --Don't let the ped move.
	end
	
	if PedManager.config.invincible then
		SetEntityInvincible(ped, true) --Don't let the ped die.
	end

	if PedManager.config.stoic then
		SetBlockingOfNonTemporaryEvents(ped, true) --Don't let the ped react to his surroundings.
	end
	
	--Add an animation to the ped, if one exists.
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(10)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end

	if scenario then
		TaskStartScenarioInPlace(ped, scenario, 0, true) -- begins peds animation
	end
	
	if PedManager.config.fade then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(ped, i, false)
		end
	end

	return ped
end

PedManager.Create = function(data)
    if data == nil or type(data) ~= "table" then
        return "data is not a table"
    end

    -- model
    if data.model == nil or type(data.model) ~= "string" then
        return "model is invalid"
    end

    if data.coords == nil then
        return "coords are invalid"
    end

    if data.heading == nil or type(data.heading) ~= "number" then
        return "heading is invalid"
    end

    if data.distance == nil or type(data.distance) ~= "number" then
        return "distance is invalid"
    end

    -- Init
    local pedData = {
        distance = data.distance,
        model = data.model,
        coords = data.coords,
        heading = data.heading,
        gender = data.gender,
    }
    
    -- Animation (optional)
    if data.animDict ~= nil then
        if type(data.animDict) ~= "string" then
            return "animDict is invalid"
        end

        pedData.animDict = data.animDict

        if data.animName ~= nil then
            if type(data.animName) ~= "string" then
                return "animName is invalid"
            end
            pedData.animName = data.animName
        end
    end

    -- Label (optional)
    if data.pedLabel ~= nil then
        if type(data.pedLabel) ~= "string" then
            return "pedLabel is invalid"
        end

        pedData.pedLabel = data.pedLabel

        -- Offset
        if data.pedLabelOffset ~= nil and type(data.pedLabelOffset) == "number" then
            pedData.pedLabelOffset = data.pedLabelOffset
        else
            -- default value
            pedData.pedLabelOffset = 1.0
        end
    end

    -- points
    pedData.point = lib.points.new({
        coords = vec3(pedData.coords.x, pedData.coords.y, pedData.coords.z),
        distance = pedData.distance,
        isRendered = false,
        ped = nil,
    })

    function pedData.point:onEnter()
		if self.isRendered == false then
            self.ped = nil

			self.ped = PedManager.nearby(pedData.model, pedData.coords, pedData.heading, pedData.gender, pedData.animDict, pedData.animName, pedData.scenario)

            pedData.ped = self.ped
    
            if self.ped ~= nil then
                self.isRendered = true
            end
		end
	end
	
	function pedData.point:onExit()
		if self.isRendered then
			if PedManager.config.fade then
				for i = 255, 0, -51 do
					Citizen.Wait(50)
					SetEntityAlpha(self.ped, i, false)
				end
			end

            if DoesEntityExist(self.ped) then
                DeletePed(self.ped)
                
                pedData.ped = nil
                self.ped = nil
                self.isRendered = false
            end
		end
	end

	if pedData.pedLabel ~= nil then
		function pedData.point:nearby()
			if self.currentDistance < 2.0 then
				exports["cn_core"]:ShowTextOnCoords(pedData.pedLabel, pedData.coords.x, pedData.coords.y, (pedData.coords.z + pedData.pedLabelOffset), 0.5)
			end
		end
	end

    table.insert(PedManager.peds, pedData)

    return true
end


-- Ressource stops
AddEventHandler("onClientResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for pedKey,pedData in pairs(PedManager.peds) do
            if DoesEntityExist(pedData.ped) then
                DeletePed(pedData.ped)
            end

            -- Removing lib point
            if pedData.point ~= nil then
                pedData.point:remove()
            end
		end
    end
end)