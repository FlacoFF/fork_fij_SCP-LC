SWEP.Base 			= "item_slc_base"
SWEP.Language  		= "GASMASK"

SWEP.WorldModel		= "models/mishka/models/gasmask.mdl"

SWEP.ShouldDrawViewModel = false

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/gas_mask.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

SWEP.Toggleable = true
SWEP.Selectable = false

SWEP.Group 		= "gasmask"

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "Upgraded", "Bool" )
end

function SWEP:HandleUpgrade( mode, num_mode, pos )
	self:SetPos( pos )
	
	if mode == UPGRADE_MODE.VERY_FINE then
		if math.random( 100 ) <= 33 then
			self:SetUpgraded( true )
		end
	end
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()
end

function SWEP:DrawWorldModel()
	if !IsValid( self.Owner ) then
		self:DrawModel()
	end
end

function SWEP:OnDrop()
	self:SetEnabled( false )
end

/*function SWEP:OwnerChanged()
	self:SetEnabled( false )
end*/

function SWEP:OnSelect()
	self:SetEnabled( !self:GetEnabled() )
end

if CLIENT then
	local overlay = GetMaterial( "slc/misc/gasmask.png" )
	hook.Add( "SLCScreenMod", "GasMask", function( clr )
		local ply = LocalPlayer()
		local wep = ply:GetWeapon( "item_slc_gasmask" )

		if IsValid( wep ) and wep:GetEnabled() then
			render.SetMaterial( overlay )
			render.DrawScreenQuad()
		end
	end )
end