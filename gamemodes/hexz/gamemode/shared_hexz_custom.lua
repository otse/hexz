--- file is based on gamemodes/sandbox/entities/entities/base_gmodentity.lua

AddCSLuaFile()
DEFINE_BASECLASS( "base_brush" )

-- ENT.Spawnable = false

print("run the shared_hexz_custom")

if ( CLIENT ) then


	-- ENT.MaxWorldTipDistance = 256

	--[[
	function ENT:BeingLookedAtByLocalPlayer()

		local ply = LocalPlayer()
		if ( !IsValid( ply ) ) then return false end

		local view = ply:GetViewEntity()
		local dist = self.MaxWorldTipDistance
		dist = dist * dist

		local pos = view:GetPos()

		if ( pos:DistToSqr( self:GetPos() ) <= dist ) then
			return util.TraceLine( {
				start = pos,
				endpos = pos + ( view:GetAngles():Forward() * dist ),
				filter = view
			} ).Entity == self
		end

		return false
	end

	function ENT:Think()
		
	end
	--]]

end