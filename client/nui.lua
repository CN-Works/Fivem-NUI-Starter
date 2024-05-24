function CloseUi()
    SendNUIMessage({
        type = "close"
    })
end

-- Close the menu
RegisterNUICallback("close", function(data, cb)
    SetNuiFocus(false, false)

    PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET")

    cb("ok")
end)