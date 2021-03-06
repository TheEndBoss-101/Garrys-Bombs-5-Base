AddCSLuaFile()

DEFINE_BASECLASS( "gb5_nuclear_fission_rad_base" )

if (SERVER) then
	util.AddNetworkString( "gb5_net_tvirus" )
end

ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false     

ENT.PrintName		                 =  "T-Virus"        
ENT.Author			                 =  ""      
ENT.Contact			                 =  ""      

sound.Add( {
	name = "tvirus",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = {100, 100},
	sound = "gbombs_5/tvirus_infection/ply_infection.mp3"
} )
sound.Add( {
	name = "tvirus_symptom",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = {100, 100},
	sound = "gbombs_5/tvirus_infection/ply_intro_infection.mp3"
} )

ZombieList={}
ZombieList[1]="npc_zombie"
ZombieList[2]="npc_fastzombie"
ZombieList[3]="npc_poisonzombie"

ZombieList2={}
ZombieList2[1]="npc_vj_nmrih_walkmalez"
ZombieList2[2]="npc_vj_nmrih_walkfemalez"
ZombieList2[3]="npc_vj_nmrih_runmalez"
ZombieList2[4]="npc_vj_nmrih_runfemalez"

function ENT:Initialize()
	 if (SERVER) then
		 self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
		 self:SetSolid( SOLID_NONE )
		 self:SetMoveType( MOVETYPE_NONE )
		 self:SetUseType( ONOFF_USE ) 
		 self.Seconds=0



	 end
end

net.Receive( "gb5_net_tvirus", function( len, pl )
	local tickrate   = 1/engine.TickInterval()
	local data_table = net.ReadTable()
	
	local seconds = math.Round(data_table["Seconds"],2)
	local ply  = data_table["Infected"]
	local isdead = data_table["IsDead"]
	-- Carefully timed events
	if (isdead) then	
		ply:StopSound("tvirus")
		ply:StopSound("tvirus_symptom")
		hook.Remove("RenderScreenspaceEffects", "T-Virus")
		hook.Remove("RenderScreenspaceEffects", "T-Virus_Phase_2")
		timepassed=0
	end
	
	local function Events(seconds)
		-- Event Random 
		if (seconds) > 10 and (seconds<110) then
			if math.random(1, 2500)==2500 then	
				LocalPlayer():EmitSound(table.Random({"ambient/voices/citizen_beaten3.wav","ambient/voices/playground_memory.wav","ambient/voices/m_scream1.wav","npc/zombie/zombie_voice_idle12.wav"}),100,100)

				hook.Add( "RenderScreenspaceEffects", "T-Virus", function()
					if scary_time == nil then 
						scary_time=0
					end
					
					scary_time=scary_time+1/(1/RealFrameTime()) -- making time a constant
					
					local tab = {}
					tab[ "$pp_colour_addr" ] = 0
					tab[ "$pp_colour_addg" ] = -1+((1/6)*scary_time)
					tab[ "$pp_colour_addb" ] = -1+((1/6)*scary_time)
					tab[ "$pp_colour_brightness" ] = 0
					tab[ "$pp_colour_contrast" ] = 0+((1/6)*scary_time)
					tab[ "$pp_colour_colour" ] = 1
					tab[ "$pp_colour_mulr" ] = 0
					tab[ "$pp_colour_mulg" ] = 0
					tab[ "$pp_colousr_mulb" ] = 0 
					DrawColorModify( tab )			

					DrawMotionBlur( 0.09, 1-((1/6)*scary_time), 0)
					
	
					if scary_time>=6 then
						scary_time=nil
						hook.Remove("RenderScreenspaceEffects", "T-Virus")
					end
					
					
				end )
			end
		end

		if seconds==0.02 then
			return 1
		elseif seconds==10 then
			return 2
		elseif seconds==216 then
			return 3
		end
	end
	local function EventHandler(event)
		if event == 1 then -- If Initial 
			ply:ChatPrint("You feel a sudden surge of nausea...")
			
			ply:EmitSound("tvirus_symptom")
			
			
			hook.Add( "RenderScreenspaceEffects", "T-Virus", function()
				if timepassed == nil then 
					timepassed=0
					
				end
				
				timepassed=timepassed+1/(1/RealFrameTime()) -- making time a constant
				
				local tab = {}
				tab[ "$pp_colour_addr" ] = 0
				tab[ "$pp_colour_addg" ] = 0
				tab[ "$pp_colour_addb" ] = 0
				tab[ "$pp_colour_brightness" ] = 0
				tab[ "$pp_colour_contrast" ] = math.Clamp(3-(2*(timepassed/10)),0,3)
				tab[ "$pp_colour_colour" ] = math.Clamp(0+(timepassed/10),0,1)
				tab[ "$pp_colour_mulr" ] = 0
				tab[ "$pp_colour_mulg" ] = 0
				tab[ "$pp_colousr_mulb" ] = 0 
				DrawColorModify( tab )			
				
				DrawMotionBlur( 0.09, 1.5-(2*(timepassed/10)), 0)
				
				
				if timepassed>=9.9 then
					timepassed=nil
					hook.Remove("RenderScreenspaceEffects", "T-Virus")
				end
				
				
			end )

		elseif event == 2 then 
			ply:EmitSound("tvirus")
			hook.Add( "RenderScreenspaceEffects", "T-Virus_Phase_2", function()
			
				if timepassed == nil then 
					timepassed=0
				end
				
				timepassed=timepassed+1/(1/RealFrameTime()) -- making time the constant for everything drawn
				-- Draw Veins and shit




				
				-- Colormods
				local tab = {}
				tab[ "$pp_colour_addr" ] = 0
				tab[ "$pp_colour_addg" ] = 0
				tab[ "$pp_colour_addb" ] = 0
				tab[ "$pp_colour_brightness" ] = 0
				tab[ "$pp_colour_contrast" ] = math.Clamp(1-((1/120)*(timepassed-10))*1.1,0,1)
				tab[ "$pp_colour_colour" ] = math.Clamp(1+((timepassed/217)*-8),0,1)
				tab[ "$pp_colour_mulr" ] = 0
				tab[ "$pp_colour_mulg" ] = 0
				tab[ "$pp_colousr_mulb" ] = 0 
				DrawColorModify( tab )			
				-- End
		
				local tex = surface.GetTextureID("hud/infection")
				surface.SetTexture(tex)
				surface.SetDrawColor( 255, 255, 255,(timepassed/255)*255 )
				surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
				
				DrawMotionBlur( 0.09, (  (1/137)*timepassed     ), 0)

				
				if timepassed>=207 then

					timepassed=nil
					hook.Remove("RenderScreenspaceEffects", "T-Virus_Phase_2")
				end
						
						
			end )
		end
	end
	
	EventHandler(Events(seconds))
	

	

	
	
end )

function ENT:MovePlayerSpeed()
	if not self.infected:Alive() then return end
	self.infected:SetRunSpeed( math.Clamp((500/137) * (137-self.Seconds),0,500))
	self.infected:SetWalkSpeed( math.Clamp((250/137) * (137-self.Seconds),0,250))
end

function ENT:FollowInfected()
	self:SetPos(self.infected:GetPos())
end

function ENT:Think()	

	if (SERVER) then
	if not self:IsValid() then return end
	if not self.infected:IsValid() then -- doesnt fucking work
		self:Remove()
	end
	
	self.Seconds = self.Seconds+1/(1/engine.TickInterval())
	
	self:MovePlayerSpeed()
	self:FollowInfected()
	
	net.Start("gb5_net_tvirus")
		net.WriteTable({["IsDead"]=false,["Seconds"]=self.Seconds,["Infected"]=self.infected,["IsDead"]=false})
	net.Send(self.infected)
	
	for k, v in pairs(ents.FindInSphere(self:GetPos(),100)) do
		if v:IsPlayer() and v:Alive() and not v.isinfected then
			local ent = ents.Create("gb5_chemical_tvirus_entity")
			ent:SetVar("infected", v)
			ent:SetPos( self:GetPos() ) 
			ent:Spawn()
			ent:Activate()
			v.isinfected = true
			ParticleEffectAttach("zombie_blood",PATTACH_ABSORIGIN_FOLLOW,v, 1) 
		end
		if (v:IsNPC() and table.HasValue(npc_tvirus,v:GetClass()) and not v.isinfected) or (v.IsVJHuman==true and not v.isinfected) then
			if v.gasmasked==false and v.hazsuited==false then
				local ent = ents.Create("gb5_chemical_tvirus_entity_npc")
				ent:SetVar("infected", v)
				ent:SetPos( self:GetPos() ) 
				ent:Spawn()
				ent:Activate()
				v.isinfected = true
				ParticleEffectAttach("zombie_blood",PATTACH_ABSORIGIN_FOLLOW,v, 1) 
			end
		end	
	end
	if (self.Seconds >= 123) and (self.playsound==1) then 
		self.infected:EmitSound("gbombs_5/tvirus_infection/ply_infection_final.mp3")
	end
	if (self.Seconds >= 130) then -- Zombie time hehe
		if not self:IsValid() then return end
		if (file.Exists( "lua/autorun/vj_nmrih_autorun.lua", "GAME" )) and GetConVar("gb5_nmrih_zombies"):GetInt()== 1 then
			local ent = ents.Create(table.Random(ZombieList2)) -- This creates our zombie entity
			ent:SetPos(self.infected:GetPos())
			ent:Spawn() 
			if GetConVar("gb5_zombie_strength"):GetInt() == 0 then
				ent:SetHealth(500)
			elseif GetConVar("gb5_zombie_strength"):GetInt() == 1 then
				ent:SetHealth(1000)
			elseif GetConVar("gb5_zombie_strength"):GetInt() == 2 then
				ent:SetHealth(2000)
			elseif GetConVar("gb5_zombie_strength"):GetInt() == -1 then
				ent:SetHealth(250)
			elseif GetConVar("gb5_zombie_strength"):GetInt() == -2 then
				ent:SetHealth(175)
			else
				ent:SetHealth(500)
			end
			local z_ent = ents.Create("gb5_chemical_tvirus_entity_z")
			z_ent:SetVar("zombie", ent)
			z_ent:SetPos( ent:GetPos() ) 
			z_ent:Spawn()
			z_ent:Activate()
			

			self.infected:Kill()
			self:Remove()
		else
			if math.random(1,100)~=100 then
				local ent = ents.Create(table.Random(ZombieList)) -- This creates our zombie entity
				ent:SetPos(self.infected:GetPos())
				ent:Spawn() 
				if GetConVar("gb5_zombie_strength"):GetInt() == 0 then
					ent:SetHealth(500)
				elseif GetConVar("gb5_zombie_strength"):GetInt() == 1 then
					ent:SetHealth(1000)
				elseif GetConVar("gb5_zombie_strength"):GetInt() == 2 then
					ent:SetHealth(2000)
				elseif GetConVar("gb5_zombie_strength"):GetInt() == -1 then
					ent:SetHealth(250)
				elseif GetConVar("gb5_zombie_strength"):GetInt() == -2 then
					ent:SetHealth(175)
				else
					ent:SetHealth(500)
				end
				local z_ent = ents.Create("gb5_chemical_tvirus_entity_z")
				z_ent:SetVar("zombie", ent)
				z_ent:SetPos( ent:GetPos() ) 
				z_ent:Spawn()
				z_ent:Activate()
				
				

				self.infected:Kill()
				self:Remove()
				
			else

			
				local ent = ents.Create(table.Random(ZombieList)) -- This creates our zombie entity
				ent:SetPos(self.infected:GetPos())
				ent:Spawn() 
				ent:SetHealth(10000)
				ent:SetModelScale(ent:GetModelScale()*4)
				local z_ent = ents.Create("gb5_chemical_tvirus_entity_z")
				z_ent:SetVar("zombie", ent)
				z_ent:SetPos( ent:GetPos() ) 
				z_ent:Spawn()
				z_ent:Activate()
				
				
	
				self.infected:Kill()
				self:Remove()			
			end
		end
    end		
		
	if not self.infected:Alive() or not self.infected:IsValid() then

		if (file.Exists( "lua/autorun/vj_nmrih_autorun.lua", "GAME" )) and GetConVar("gb5_nmrih_zombies"):GetInt()== 1 then
			local ent = ents.Create(table.Random(ZombieList2)) -- This creates our zombie entity
			ent:SetPos(self.infected:GetPos())
			ent:Spawn() 
			if GetConVar("gb5_zombie_strength"):GetInt() == 0 then
				ent:SetHealth(500)
			elseif GetConVar("gb5_zombie_strength"):GetInt() == 1 then
				ent:SetHealth(1000)
			elseif GetConVar("gb5_zombie_strength"):GetInt() == 2 then
				ent:SetHealth(2000)
			elseif GetConVar("gb5_zombie_strength"):GetInt() == -1 then
				ent:SetHealth(250)
			elseif GetConVar("gb5_zombie_strength"):GetInt() == -2 then
				ent:SetHealth(175)
			else
				ent:SetHealth(500)
			end
			local z_ent = ents.Create("gb5_chemical_tvirus_entity_z")
			z_ent:SetVar("zombie", ent)
			z_ent:SetPos( ent:GetPos() ) 
			z_ent:Spawn()
			z_ent:Activate()
			

			self.infected:Kill()
			self:Remove()
		else
			if math.random(1,25)~=25 then
			
				local ent = ents.Create(table.Random(ZombieList)) -- This creates our zombie entity
				ent:SetPos(self.infected:GetPos())
				ent:Spawn() 
				if GetConVar("gb5_zombie_strength"):GetInt() == 0 then
					ent:SetHealth(500)
				elseif GetConVar("gb5_zombie_strength"):GetInt() == 1 then
					ent:SetHealth(1000)
				elseif GetConVar("gb5_zombie_strength"):GetInt() == 2 then
					ent:SetHealth(2000)
				elseif GetConVar("gb5_zombie_strength"):GetInt() == -1 then
					ent:SetHealth(250)
				elseif GetConVar("gb5_zombie_strength"):GetInt() == -2 then
					ent:SetHealth(175)
				else
					ent:SetHealth(500)
				end
				local z_ent = ents.Create("gb5_chemical_tvirus_entity_z")
				z_ent:SetVar("zombie", ent)
				z_ent:SetPos( ent:GetPos() ) 
				z_ent:Spawn()
				z_ent:Activate()
				
				

				self.infected:Kill()
				self:Remove()
				
			else

				for k, v in pairs(player.GetAll()) do
					v:ChatPrint("Zombie boss has spawnednot ")
				end
				local ent = ents.Create(table.Random(ZombieList)) -- This creates our zombie entity
				ent:SetPos(self.infected:GetPos())
				ent:Spawn() 
				ent:SetHealth(10000)
				ent:SetModelScale(ent:GetModelScale()*2)
				ent.IsBoss=true
				
				local z_ent = ents.Create("gb5_chemical_tvirus_entity_z")
				z_ent:SetVar("zombie", ent)
				z_ent:SetPos( ent:GetPos() ) 
				z_ent:Spawn()
				z_ent:Activate()
				
				

				self.infected:Kill()
				self:Remove()			
			end
		end
	end
	
	self:NextThink(CurTime() + 0.01)
	return true
	end
end

if (SERVER) then
	function ENT:OnRemove()
		if not self.infected:IsValid() then return end
		local infected_player = self.infected
		infected_player.isinfected = false

		self.infected:SetRunSpeed(500)
		self.infected:SetWalkSpeed(250)
		infected_player:StopParticles()
		infected_player:SetColor(Color(255,255,255))
		
		net.Start("gb5_net_tvirus")
			net.WriteTable({["IsDead"]=false,["Seconds"]=self.Seconds,["Infected"]=self.infected,["IsDead"]=true})
		net.Send(self.infected)
	end
end


if (CLIENT) then
	function ENT:OnRemove()
	end
end

function ENT:Draw()
     return false
end


