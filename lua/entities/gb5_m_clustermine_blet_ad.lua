AddCSLuaFile()

DEFINE_BASECLASS( "gb5_base_dumb" )

local ExploSnds = {}
ExploSnds[1]                         =  "ambient/explosions/explode_1.wav"
ExploSnds[2]                         =  "ambient/explosions/explode_2.wav"
ExploSnds[3]                         =  "ambient/explosions/explode_3.wav"
ExploSnds[4]                         =  "ambient/explosions/explode_4.wav"
ExploSnds[5]                         =  "ambient/explosions/explode_5.wav"
ExploSnds[6]                         =  "npc/env_headcrabcanister/explosion.wav"

ENT.Spawnable		            	 =  false        
ENT.AdminSpawnable		             =  false

ENT.PrintName		                 =  "Clustermine Bomblet"
ENT.Author			                 =  ""
ENT.Contact		                     =  "baldursgate3@gmail.com"
ENT.Category                         =  "Garry's Bombs 5"

ENT.Model                            =  "models/thedoctor/pellet.mdl"                      
ENT.Effect                           =  "50lb_main"                  
ENT.EffectAir                        =  "50lb_air"                   
ENT.EffectWater                      =  "water_medium"
ENT.ExplosionSound                   =  "gbombs_5/explosions/light_bomb/mine_explosion.mp3"     

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  false
ENT.UseRandomSounds                  =  false
ENT.UseRandomModels                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  99
ENT.PhysForce                        =  600
ENT.ExplosionRadius                  =  300
ENT.SpecialRadius                    =  575
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  980                                 
ENT.MaxDelay                         =  2                                 
ENT.TraceLength                      =  100
ENT.ImpactSpeed                      =  1100
ENT.Mass                             =  90
ENT.ArmDelay                         =  2   
ENT.Timer                            =  0

ENT.Shocktime                        = 1
ENT.GBOWNER                          =  nil 

ENT.DEFAULT_PHYSFORCE                = 195
ENT.DEFAULT_PHYSFORCE_PLYAIR         = 20
ENT.DEFAULT_PHYSFORCE_PLYGROUND      = 1000 
ENT.Decal                            = "scorch_small"

function ENT:SpawnFunction( ply, tr )
     if ( not tr.Hit ) then return end
     self.GBOWNER = ply
     local ent = ents.Create( self.ClassName )
     ent:SetPhysicsAttacker(ply)
     ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
     ent:Spawn()
     ent:Activate()
     return ent
end

function ENT:Initialize()
	if (SERVER) then
		self:LoadModel()
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetUseType( ONOFF_USE ) -- doesen't fucking work
		local phys = self:GetPhysicsObject()
		local skincount = self:SkinCount()
		if (phys:IsValid()) then
			phys:SetMass(self.Mass)
			phys:Wake()
		end
		if (skincount > 0) then
			self:SetSkin(math.random(0,skincount))
		end
		self.Exploded = false
		timer.Simple(math.random(50,100)/10, function() 
			if not self:IsValid() then return end
			self.Exploded=true
			self:Explode()
		end)
	end
end
function ENT:Explode()
     if not self.Exploded then return end
	 local pos = self:LocalToWorld(self:OBBCenter())
	 if self.Count < 4 then
		 for i=1, 2 do
			 print(self.Count)
			 local ent1 = ents.Create("gb5_m_clustermine_blet_ad") 
			 local phys = ent1:GetPhysicsObject()
			 ent1:SetPos( self:GetPos() ) 
			 ent1:Spawn()
			 ent1:Activate()
			 ent1:SetVar("GBOWNER", self.GBOWNER)
			 ent1:Ignite(1,0)
			 ent1.Count = self.Count + 1 
			 local bphys = ent1:GetPhysicsObject()
			 local phys = self:GetPhysicsObject()
			  if bphys:IsValid() and phys:IsValid() then
				 bphys:ApplyForceCenter(VectorRand() * bphys:GetMass() * 85)
				 bphys:AddVelocity(phys:GetVelocity()/4)
			 end
		 end
	 end
	 local ent1 = ents.Create("gb5_m_clustermine_bomblet") 
	 local phys = ent1:GetPhysicsObject()
	 ent1:SetPos( self:GetPos() ) 
	 ent1:Spawn()
	 ent1:Activate()
	 ent1:SetVar("GBOWNER", self.GBOWNER)
	 
	 
	 local bphys = ent1:GetPhysicsObject()
	 local phys = self:GetPhysicsObject()
	  if bphys:IsValid() and phys:IsValid() then
		 bphys:ApplyForceCenter(VectorRand() * bphys:GetMass() / math.random(10,100) )
		 bphys:AddVelocity(Vector(0,0,100))
		 ent1:Ignite(1)
	 end
 
	 local ent = ents.Create("gb5_shockwave_ent")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("DEFAULT_PHYSFORCE", self.DEFAULT_PHYSFORCE)
	 ent:SetVar("DEFAULT_PHYSFORCE_PLYAIR", self.DEFAULT_PHYSFORCE_PLYAIR)
	 ent:SetVar("DEFAULT_PHYSFORCE_PLYGROUND", self.DEFAULT_PHYSFORCE_PLYGROUND)
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",self.ExplosionRadius)
	 ent:SetVar("SHOCKWAVE_INCREMENT",100)
	 ent:SetVar("DELAY",0.01)
	 ent.trace=self.TraceLength
	 ent.decal=self.Decal
	 
	 local ent = ents.Create("gb5_shockwave_sound_lowsh")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",50000)
	if GetConVar("gb5_sound_speed"):GetInt() == 0 then
		ent:SetVar("SHOCKWAVE_INCREMENT",200)
	elseif GetConVar("gb5_sound_speed"):GetInt()== 1 then
		ent:SetVar("SHOCKWAVE_INCREMENT",300)
	elseif GetConVar("gb5_sound_speed"):GetInt() == 2 then
		ent:SetVar("SHOCKWAVE_INCREMENT",400)
	elseif GetConVar("gb5_sound_speed"):GetInt() == -1 then
		ent:SetVar("SHOCKWAVE_INCREMENT",100)
	elseif GetConVar("gb5_sound_speed"):GetInt() == -2 then
		ent:SetVar("SHOCKWAVE_INCREMENT",50)
	else
		ent:SetVar("SHOCKWAVE_INCREMENT",200)
	end
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("SOUND", self.ExplosionSound)
	 ent:SetVar("Shocktime", self.Shocktime)
	 
	 if(self:WaterLevel() >= 1) then
		 local trdata   = {}
		 local trlength = Vector(0,0,9000)

	     trdata.start   = pos
	     trdata.endpos  = trdata.start + trlength
		 trdata.filter  = self
		 local tr = util.TraceLine(trdata) 

		 local trdat2   = {}
	     trdat2.start   = tr.HitPos
	     trdat2.endpos  = trdata.start - trlength
	     trdat2.filter  = self
		 trdat2.mask    = MASK_WATER + CONTENTS_TRANSLUCENT
			 
		 local tr2 = util.TraceLine(trdat2)
			 
		 if tr2.Hit then
		     ParticleEffect(self.EffectWater, tr2.HitPos, Angle(0,0,0), nil)   
		 end
     else
		 local tracedata    = {}
	     tracedata.start    = pos
		 tracedata.endpos   = tracedata.start - Vector(0, 0, self.TraceLength)
		 tracedata.filter   = self.Entity
				
		 local trace = util.TraceLine(tracedata)
	     
		 if trace.HitWorld then
		     ParticleEffect(self.Effect,pos,Angle(0,0,0),nil)
		 else 
			 ParticleEffect(self.EffectAir,pos,Angle(0,0,0),nil) 
		 end
	 end
	 if self.IsNBC then
	     local nbc = ents.Create(self.NBCEntity)
		 nbc:SetVar("GBOWNER",self.GBOWNER)
		 nbc:SetPos(self:GetPos())
		 nbc:Spawn()
		 nbc:Activate()
	 end
     self:Remove()
end