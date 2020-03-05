VERSION = "0.0.1"

local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")
local buffer = import("micro/buffer")

-- outside init because we want these options to take effect before
-- buffers are initialized
config.RegisterCommonOption("elm", "elmformat", true)

function init()
    config.MakeCommand("elmformat", elmformat, config.NoComplete)
end

function onSave(bp)
    if bp.Buf:FileType() == "elm" then
        if bp.Buf.Settings["elm.elmformat"] then
            elmformat(bp)
        end
    end
    return true
end

function elmformat(bp)
    bp:Save()
    local _, err = shell.RunCommand("elm-format --yes " .. bp.Buf.Path)
    if err ~= nil then
        micro.InfoBar():Error(err)
        return
    end

    bp.Buf:ReOpen()
end
