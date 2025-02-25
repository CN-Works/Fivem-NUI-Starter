function CloseUi()
    SendNUIMessage({
        type = "close"
    })
end

function OpenUI()
    SendNUIMessage({
        type = "open",
    })
end

-- Close the menu
RegisterNUICallback("close", function(data, cb)
    SetNuiFocus(false, false)

    PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET")

    cb("ok")
end)