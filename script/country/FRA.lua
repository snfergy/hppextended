-----------------------------------------------------------
-- France
-----------------------------------------------------------

local P = {}
AI_FRA = P

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(minister)

	-- SSmith (23/07/2013)
	-- Changed to new format
	-- Early shift from air to naval techs

	local laTechWeights

	-- SSmith (16/09/2014)
	-- Amended for efficiency

	local liYear = CCurrentGameState.GetCurrentDate():GetYear()

	if liYear < 1938 then

		laTechWeights = {
			0.25, -- Land
			0.30, -- Air
			0.25, -- Naval
			0.20}; -- Other
	elseif liYear < 1940 then
		laTechWeights = {
			0.30, -- Land
			0.40, -- Air
			0.15, -- Naval
			0.15}; -- Other
	else
		laTechWeights = {
			0.35, -- Land
			0.35, -- Air
			0.15, -- Naval
			0.15}; -- Other
	end
	
	return laTechWeights
end

function P.Get_TechParams(minister)

	-- SSmith (21/08/2013)
	-- This is a new function to return a table of country-specific research config

	local laTechParams = {

		desert_warfare_equipment 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		jungle_warfare_equipment 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		mechanised_infantry 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

		super_heavy_tank_brigade 	= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.40, EndYear = 1999, Attribute = "InfantryTank" },
		super_heavy_tank_gun 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "InfantryTank" },
		super_heavy_tank_armour 	= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.40, EndYear = 1999, Attribute = "InfantryTank" },
		tank_brigade 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_gun 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_armour 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		heavy_tank_brigade 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_gun 			= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_armour 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		sloped_armor 			= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

		battlecruiser_technology 	= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1938, Attribute = "" },
		battleship_technology 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1939, Attribute = "" },
		capital_ship_armor 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		capital_ship_engine 		= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		capitalship_armament 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },

		air_launched_torpedo 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "Naval" },
		nav_development 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		medium_navagation_radar 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
		basic_strategic_bomber 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		four_engine_airframe 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		large_fueltank 			= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		strategic_bomber_armament 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
		large_bomb 			= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

		supply_production 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		supply_transportation 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		supply_organisation 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		capital_ship_crew_training 	= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_crew_training 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sealane_control 		= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleship_taskforce_doctrine 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleline_cruiser_doctrine 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		cag_pilot_training 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		strategic_airforce_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
		strategic_bombardment_tactics 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		strategic_air_command 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		naval_aviation_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "Naval" },
		portstrike_tactics 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		navalstrike_tactics 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		naval_tactics 			= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" }
	}

	return laTechParams
end


-- SSmith (11/11/2017)
-- TechSliders function replaced with GetOfficerRatio

function P.GetOfficerRatio(ministerCountry, target_ratio)

	-- France needs a custom officer ratio to reflect historical deficiencies
	-- I will allow France to put things right from 1941

	if CCurrentGameState.GetCurrentDate():GetYear() < 1941 then
		target_ratio = 1.00
	end

	return target_ratio
end

-- END OF TECH RESEARCH OVERIDES
-- #######################################


-- #######################################
-- Production Overides the main LUA with country specific ones

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(minister)
	local rValue
	
	-- SSmith (12/05/2013)
	-- Shift a bit more to air and naval production

	-- SSmith (03/05/2015)
	-- Put a bit more into land production pre-war
	
	-- Slendermang (09/12/19(
	-- Weigh France to construct more forts if they abandon the Benelux countries.
	if CCurrentGameState.IsGlobalFlagSet(CString("AbandonBenelux")) then
		local laArray = {
			0.05, -- Land
			0.00, -- Air
			0.00, -- Sea
			0.95}; -- Other
			
		rValue = laArray	
	elseif minister:GetCountry():IsAtWar() then
		local laArray = {
			0.65, -- Land
			0.20, -- Air
			0.10, -- Sea
			0.05}; -- Other
		
		rValue = laArray	
	else
		local laArray = {
			0.55, -- Land
			0.20, -- Air
			0.20, -- Sea
			0.05}; -- Other
		
		rValue = laArray
	end
	
	return rValue
end
-- Land ratio distribution
function P.LandRatio(minister)

	-- SSmith (12/05/2013)
	-- Make sure that France can build motorized units
	-- So we will shift a bit from armour to infantry

	local laArray = {
		3, -- Garrison
		12, -- Infantry
		3, -- Motorized
		2, -- Mechanized
		4, -- Armor
		0, -- Militia
		1}; -- Cavalry
	
	return laArray
end
-- Special Forces ratio distribution
function P.SpecialForcesRatio(minister)

	-- SSmith (20/06/2013)
	-- This will now return separate ratios for mountain, marine and airborne brigades
	-- France should train mountain brigades (and other special forces when at war)

	-- SSmith (16/09/2014)
	-- Amended for efficiency

	if minister:GetCountry():IsAtWar() then
		local laArray = {
			12, -- Mountain
			25, -- Marine
			30}; -- Airborne
		return laArray
	else
		local laArray = {
			12, -- Mountain
			40, -- Marine
			50}; -- Airborne
		return laArray
	end

end
-- Air ratio distribution
function P.AirRatio(minister)

	-- SSmith (12/05/2013)
	-- Allow for a range of air assets

	local laArray = {
		13, -- Fighter
		4, -- CAS
		5, -- Tactical
		2, -- Naval Bomber
		1}; -- Strategic
	
	return laArray
end
-- Naval ratio distribution
function P.NavalRatio(minister)

	-- SSmith (12/05/2013)
	-- Allow for a range of naval assets

	local laArray = {
		7.5, -- Destroyers
		3, -- Submarines
		8, -- Cruisers
		4.5, -- Capital
		1, -- Escort Carrier
		1}; -- Carrier
	
	return laArray
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)

	-- SSmith (12/05/2013)
	-- Make sure France has some transports (was 1:80)

	local laArray = {
		35, -- Land
		1}; -- Transport
	
	return laArray
end


-- SSmith (23/11/2017)
-- Removed division template overrides

	
-- Do not build coastal forts
function P.Build_CoastalFort(ic, minister, vbGoOver)
	return ic
end

-- We don't want to spend too much on Upgrades in the beginning.
function P.MaxUpgrade( ministerTag )

	-- SSmith (21/06/2013)
	-- This player-specific stuff could be useful but it could also unbalance France
	-- Needs checking!!

	-- SSmith (16/09/2014)
	-- Amended for efficiency

	local playerTag = CCurrentGameState.GetPlayer()

	if CCountryDataBase.GetTag('GER') == playerTag
	or CCountryDataBase.GetTag('ITA') == playerTag
	then
		-- If Germany or Italy is not AI, then don't put a limit on upgrades!
		return 1.0
	end

	-- SSmith (28/05/2013)
	-- France should start upgrading when at war!
	-- But we will shift a bit of production to upgrades anyway
	
	if CCurrentGameState.GetCurrentDate():GetYear() < 1939 and not ministerTag:GetCountry():IsAtWar() then
		-- Before '40, don't bother with that at all. This is basically an artificial restriction for France.
		return 0.25
	end
	-- Still don't spend more than half though.
	return 0.5
end

-- END OF PRODUTION OVERIDES
-- #######################################

-- #######################################
-- Intelligence Hooks

-- Home_Spies(minister)
-- #######################################

function P.PickBestMission(ministerTag, ministerCountry, TargetCountry, TargetCountryTag)

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) ) 
	or ( not Utils.ASSERT( TargetCountry ) )
	or ( not Utils.ASSERT( TargetCountryTag ) )
	then
		return nil
	end
	
	local sameIdeology = Utils.SameIdeology(ministerCountry, TargetCountry, nil)
	local CountryScriptMission = nil
	
	-- We want to have the USA as a friend!
	if tostring(TargetCountryTag) == "USA" and not TargetCountry:HasFaction() then
		if sameIdeology == true then
			CountryScriptMission = "BoostRulingParty"
		else
			CountryScriptMission = "BoostOurParty"
		end
	
	-- This is to avoid and early war caused by France increasing threat
	elseif tostring(TargetCountryTag) == "GER" and CCurrentGameState.GetCurrentDate():GetYear() <= 1940 then
		CountryScriptMission = "LowerNationalUnity"
	end
	
	return CountryScriptMission	
end

-- End of Intelligence Hooks
-- #######################################

function P.ProposeDeclareWar(minister)
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local year = ai:GetCurrentDate():GetYear()
	
	local axisFaction = CCurrentGameState.GetFaction("axis")
	local alliesFaction = CCurrentGameState.GetFaction("allies")
	local comminternFaction = CCurrentGameState.GetFaction("commintern")
	local axisLeaderTag = axisFaction:GetFactionLeader()
	
	local loStrategy = ministerCountry:GetStrategy()

	-- SSmith (16/09/2014)
	-- Amended for efficiency
	-- Use the estimated military strength function
	
	-- Make sure France is part of the allies
	if ministerCountry:GetFaction() == alliesFaction
	and not ministerCountry:IsGovernmentInExile()
	and not(loStrategy:IsPreparingWar()) then
		local loMinisterCapital = ministerCountry:GetCapitalLocation():GetContinent()
	
		-- SSmith (08/10/2014)
		-- Allow France to DOW Germany at 25% relative strength provided Germany is at war

		-- Pay extra attention to the leader of the Axis, regardless of Neutrality and Threat!
		local fnParams = {
			MinisterTag = ministerTag,
			TargetTag = axisLeaderTag
		}
		if Support.CompareEstimatedMilitaryStrength( fnParams ) < 2.0 and axisLeaderTag:GetCountry():IsAtWar() then
			-- France starts with a fairly strong army and this function includes the UK as well, so this normally shouldn't happen until mid-'38.
			Support.PrepareForWar( ministerTag, axisLeaderTag, 200 ) -- Without enough threat they still won't be able to declare war, but they should prioritize Germany as their main enemy.
		end
	
		-- Generic DOW for countries not part of the same faction

		local currentNeutrality = ministerCountry:GetNeutrality():Get()
		local ministerFaction = ministerCountry:GetFaction()
		local ministerManpower = ministerCountry:GetManpower():Get()
		local ministerIsAtWar = ministerCountry:IsAtWar()
		local ministerIsMobilized = ministerCountry:IsMobilized()
		local gerTag = CCountryDataBase.GetTag('GER')
		local gerIsDefeated = Support.IsDefeated(ministerTag, gerTag)

		for loTargetCountry in CCurrentGameState.GetCountries() do
			local loTargetTag = loTargetCountry:GetCountryTag()
			
			fnParams = {
				MinisterTag = ministerTag,
				TargetTag = loTargetTag
			}
			if not(loTargetCountry:GetFaction() == ministerFaction) then
				if ( loTargetCountry:GetCapitalLocation():GetContinent() == loMinisterCapital	-- Same continent
				or ministerCountry:IsNeighbour(loTargetTag) )					-- or at least a neighbor.
				and Support.CompareEstimatedMilitaryStrength(fnParams) > 1.5
				and ministerManpower > 200
				then
					local currentThreat = ministerCountry:GetRelation(loTargetTag):GetThreat():Get()
					local canAttack = ( gerIsDefeated or ( not loTargetCountry:HasFaction() ) or loTargetCountry:GetFaction() == axisFaction or ( not ministerIsAtWar and year > 1940 ) )
					
					if canAttack and currentThreat > currentNeutrality + 20 and ministerIsMobilized then
						Support.PrepareForWar( ministerTag, loTargetTag, 100 )
					elseif currentThreat > currentNeutrality + 10 then
						local command = CToggleMobilizationCommand( ministerTag, true )
						ai:Post( command )
					end
				end
			end
		end
	end
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	
	if lsActorTag == "AST" 
	or lsActorTag == "CAN" 
	or lsActorTag == "SAF" 
	or lsActorTag == "NZL" 
	or lsActorTag == "ENG" 
	or lsActorTag == "USA" then
		score = score + 20
	end
	
	return score
end

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local lsRepTag = tostring(recipient)
	
	-- SSmith (16/09/2014)
	-- Bug fix

	if lsRepTag == "AUS" or lsRepTag == "CZE" or lsRepTag == "SCH" or lsRepTag == "SWE"		-- Shouldn't bother
	or lsRepTag == "AST" or lsRepTag == "CAN" or lsRepTag == "SAF" or lsRepTag == "NZL"		-- We get them for free
	then
		return 0
	elseif lsRepTag == "HUN" or lsRepTag == "ROM" or lsRepTag == "BUL" or lsRepTag == "FIN" then
		score = score - 50
	elseif lsRepTag == "ITA" and Support.IsDefeated( CCountryDataBase.GetTag('ITA'), CCountryDataBase.GetTag('ETH') ) then
		-- Don't influence Italy after the Italo-Abyssinian war
		score = 0
	elseif lsRepTag == "JAP" and CCountryDataBase.GetTag('JAP'):GetCountry():GetRelation( CCountryDataBase.GetTag('CHI') ):HasWar() then
		-- Don't influence Japan if they are at war with China
		score = 0
	elseif lsRepTag == "USA" then
		score = score + 70
	end

	return score
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = tostring(decision:GetKey())
	local country = agent:GetCountry()
	local countryTag = country:GetCountryTag()
	
	-- SSmith (28/08/2013)
	-- Added random chances to make decisions more realistic

	if lsDecision == "spanish_civil_war_french_intervention_spr" or lsDecision == "spanish_civil_war_french_intervention_full_spr" then
		if country:GetRulingIdeology():GetGroup():GetKey() == 'communism'		-- Only intervene in the SCW if we are not a democracy!
		and math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "spanish_civil_war_french_intervention_spa" or lsDecision == "spanish_civil_war_french_intervention_full_spa" then
		if country:GetRulingIdeology():GetGroup():GetKey() == 'fascism'		-- Only intervene in the SCW if we are not a democracy!
		and math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "vichy_armistice" then

		-- SSmith (02/11/2017)
		-- Added Vichy armistice as decision

		if math.mod( CCurrentGameState.GetAIRand(), 4) == 1 then
			score = 100
		else
			score = 0
		end
	end
	
	return score
end

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for Vichy and our colonies

	local laCountryExceptions = { "VIC", "ALG", "TUN", "MOR", "MAD" }
	return laCountryExceptions
end

function P.HandleMobilization( minister, needsMobilization )

	--local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	--local gerTag = CCountryDataBase.GetTag('GER')
	--local czeTag = CCountryDataBase.GetTag('CZE')
	--local polTag = CCountryDataBase.GetTag('POL')

	-- SSmith (03/05/2015)
	-- France mobilizing is just a bad idea!
	-- Only do so if we are preparing for war ourselves

	--if gerTag:GetCountry():IsAtWar()
	--or Support.IsDefeated( gerTag, czeTag )
	--or Support.IsDefeated( gerTag, polTag )
	--or ministerCountry:GetStrategy():IsPreparingWar() then
	--	needsMobilization = true
	--elseif CCurrentGameState.GetCurrentDate():GetYear() < 1940 then
	--	needsMobilization = false
	--end

	if ministerCountry:GetStrategy():IsPreparingWar() then
		needsMobilization = true
	else
		needsMobilization = false
	end

	return needsMobilization
	
end

function P.AbandonBenelux(ic, minister, vbGoOver)

	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local year = ai:GetCurrentDate():GetYear()
	
	if CCurrentGameState.IsGlobalFlagSet(CString("AbandonBenelux"))
		ic = Support.Build_Fort(ic, minister, 45, 1, vbGoOver) -- ic, minister, prov id, fort level, vbGoOver

	end

end

return AI_FRA

