include('shared.lua')

function ENT:Draw()

-- Actually draw the model
self.Entity:DrawModel()

-- Draw tooltip with networked information if close to view
local squad = self:GetNetworkedString( 12 )
if ( LocalPlayer():GetEyeTrace().Entity == self.Entity and EyePos():Distance( self.Entity:GetPos() ) < 256 ) then
AddWorldTip( self.Entity:EntIndex(), ( "Nuclear Siren" ), 0.5, self.Entity:GetPos(), self.Entity  )
end
end

language.Add( 'nuclear_siren', 'nuclear siren' )