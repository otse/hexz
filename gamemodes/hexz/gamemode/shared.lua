--[[---------------------------------------------------------

  Sandbox Gamemode

  This is GMod's default gamemode

-----------------------------------------------------------]]

--- include( "player_extension.lua" )
--- include( "persistence.lua" )
--- include( "save_load.lua" )
include( "player_class/player_hexz.lua" )
--- include( "drive/drive_sandbox.lua" )
--- include( "editor_player.lua" )

--
-- Make BaseClass available
--
DEFINE_BASECLASS( "gamemode_base" )

GM.Name 	= "HexZ"
GM.Author 	= "Peru"
GM.Email 	= "teamgarry@garrysmod.com"
GM.Website 	= "www.garrysmod.com"

--[[
 Note: This is so that in addons you can do stuff like

 if ( !GAMEMODE.IsSandboxDerived ) then return end

--]]

GM.IsSandboxDerived = true

-- HexZ:Boo = false