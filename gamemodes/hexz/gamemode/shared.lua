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

--- cleanup.Register( "props" )
--- cleanup.Register( "ragdolls" )
--- cleanup.Register( "effects" )
--- cleanup.Register( "npcs" )
--- cleanup.Register( "constraints" )
--- cleanup.Register( "ropeconstraints" )
--- cleanup.Register( "sents" )
--- cleanup.Register( "vehicles" )


--- local physgun_limited = CreateConVar( "physgun_limited", "0", FCVAR_REPLICATED )

--[[---------------------------------------------------------
   Name: gamemode:EntityKeyValue( ent, key, value )
   Desc: Called when an entity has a keyvalue set
	      Returning a string it will override the value
-----------------------------------------------------------]]
function GM:EntityKeyValue( ent, key, value )

	-- Physgun not allowed on this prop..
	if ( key == "gmod_allowphysgun" && value == '0' ) then
		ent.PhysgunDisabled = true
	end

	-- Prop has a list of tools that are allowed on it.
	if ( key == "gmod_allowtools" ) then
		ent.m_tblToolsAllowed = string.Explode( " ", value )
	end

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerNoClip( player, bool )
   Desc: Player pressed the noclip key, return true if
		  the player is allowed to noclip, false to block
-----------------------------------------------------------]]
function GM:PlayerNoClip( pl, on )

	-- Don't allow if player is in vehicle
	if ( !IsValid( pl ) || pl:InVehicle() || !pl:Alive() ) then return false end

	-- Always allow to turn off noclip, and in single player
	if ( !on || game.SinglePlayer() ) then return true end

	return GetConVarNumber( "sbox_noclip" ) > 0

end

--[[---------------------------------------------------------
   Name: gamemode:CanProperty( pl, property, ent )
   Desc: Can the player do this property, to this entity?
-----------------------------------------------------------]]
function GM:CanProperty( pl, property, ent )

	--
	-- Always a chance some bastard got through
	--
	if ( !IsValid( ent ) ) then return false end


	--
	-- If we have a toolsallowed table, check to make sure the toolmode is in it
	-- This is used by things like map entities
	--
	if ( ent.m_tblToolsAllowed ) then

		local vFound = false
		for k, v in pairs( ent.m_tblToolsAllowed ) do
			if ( property == v ) then vFound = true end
		end

		if ( !vFound ) then return false end

	end

	--
	-- Who can who bone manipulate?
	--
	if ( property == "bonemanipulate" ) then

		if ( game.SinglePlayer() ) then return true end

		if ( ent:IsNPC() ) then return GetConVarNumber( "sbox_bonemanip_npc" ) != 0 end
		if ( ent:IsPlayer() ) then return GetConVarNumber( "sbox_bonemanip_player" ) != 0 end

		return GetConVarNumber( "sbox_bonemanip_misc" ) != 0

	end

	--
	-- Weapons can only be property'd if nobody is holding them
	--
	if ( ent:IsWeapon() and IsValid( ent:GetOwner() ) ) then
		return false
	end

	-- Give the entity a chance to decide
	if ( ent.CanProperty ) then
		return ent:CanProperty( pl, property )
	end

	return true

end