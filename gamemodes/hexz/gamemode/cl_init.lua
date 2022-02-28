
--[[---------------------------------------------------------

	HexZ Gamemode

-----------------------------------------------------------]]

include( 'shared.lua' )
include( 'cl_notice.lua' )
include( 'cl_hints.lua' )
include( 'cl_worldtips.lua' )

include( "shared_hexz_custom.lua" )

DEFINE_BASECLASS( "gamemode_base" )


function GM:Initialize()

	BaseClass.Initialize( self )

end

function GM:LimitHit( name )

	self:AddNotify( "#SBoxLimit_" .. name, NOTIFY_ERROR, 6 )

	surface.PlaySound( "buttons/button10.wav" )

end

function GM:OnUndo( name, strCustomString )

	if ( !strCustomString ) then
		self:AddNotify( "undo what", NOTIFY_UNDO, 2 )
	else
		self:AddNotify( strCustomString, NOTIFY_UNDO, 2 )
	end

	-- Find a better sound :X
	surface.PlaySound( "buttons/button15.wav" )

end

function GM:OnCleanup( name )

	surface.PlaySound( "buttons/button15.wav" )

end

function GM:UnfrozeObjects( num )

	surface.PlaySound( "npc/roller/mine/rmine_chirp_answer1.wav" )

end

function GM:HexZDist( point )
	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return 300.0 end

	local view = ply:GetViewEntity()
	local dist = 256

	dist = dist * dist

	local pos = view:GetPos()

	return pos:DistToSqr( self:GetPos() )

end

function HexZFindTips()

	--[[
	electricity box
	]]--
	local nearby = GM.HexZDist(Vector( 135, 194, 34 )) <= 256

	--if (GM.HexZDist(Vector( 135, 194, 34 )) <= 256 ) then
--		AddWorldTip( nil, "Electric Box", 1.5, Vector( 135, 194, 34 ), nil )
	--end
	
end

function GM:HUDPaint()
	
	Hexz_Paint_Tips()

	self:PaintWorldTips()

	-- Draw all of the default stuff
	BaseClass.HUDPaint( self )

	self:PaintNotes()

end

function GM:PostRenderVGUI()

	BaseClass.PostRenderVGUI( self )

end

function GM:NetworkEntityCreated( ent )

	if ( ent:GetSpawnEffect() && ent:GetCreationTime() > ( CurTime() - 1.0 ) ) then

		local ed = EffectData()
			ed:SetOrigin( ent:GetPos() )
			ed:SetEntity( ent )
		util.Effect( "propspawn", ed, true, true )

	end

end
