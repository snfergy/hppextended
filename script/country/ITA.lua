-----------------------------------------------------------
-- Italy
-----------------------------------------------------------

local P = {}
AI_ITA = P

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(minister)

	-- SSmith (23/07/2013)
	-- Changed to new format
	-- Early shift from air to naval techs

	local laTechWeights

	if CCurrentGameState.GetCurrentDate():GetYear() < 1938 then

		laTechWeights = {
			0.30, -- Land
			0.15, -- Air
			0.35, -- Naval
			0.20}; -- Other
	else
		laTechWeights = {
			0.30, -- Land
			0.30, -- Air
			0.25, -- Naval
			0.15}; -- Other
	end
	
	return laTechWeights
end

function P.Get_TechParams(minister)

	-- SSmith (21/08/2013)
	-- This is a new function to return a table of country-specific research config

	-- SSmith (26/04/2015)
	-- Italy should research the cargo hold

	local laTechParams = {

		desert_warfare_equipment 	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		battleship_technology 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1940, Attribute = "" },
		capital_ship_armor 		= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1940, Attribute = "" },
		capital_ship_engine 		= { Leadership = 12, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1940, Attribute = "" },
		capitalship_armament 		= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1940, Attribute = "" },

		air_launched_torpedo 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		cargo_hold 			= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

		medium_navagation_radar 	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

		capital_ship_crew_training 	= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleship_taskforce_doctrine 	= { Leadership = 12, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleline_cruiser_doctrine 	= { Leadership = 12, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		naval_aviation_doctrine 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		portstrike_tactics 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		navalstrike_tactics 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		naval_tactics 			= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" }
	}

	return laTechParams
end


-- SSmith (11/11/2017)
-- TechSliders function replaced with GetOfficerRatio

function P.GetOfficerRatio(ministerCountry, target_ratio)

	-- Italy needs a custom officer ratio to reflect historical deficiencies

	target_ratio = 1.00

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
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local engTag = CCountryDataBase.GetTag('ENG')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local gerTag = CCountryDataBase.GetTag('GER')

	-- SSmith (12/05/2013)
	-- Italy also needs more land forces if at war with Germany or the Soviets

	if ministerCountry:GetRelation(gerTag):HasWar() then
		local laArray = {		-- We are fighting Germany! We will need more ground forces!
			0.65, -- Land
			0.15, -- Air
			0.15, -- Sea
			0.05}; -- Other
		
		rValue = laArray
	elseif ministerCountry:GetRelation(engTag):HasWar() or ministerCountry:GetRelation(sovTag):HasWar() then
		local laArray = {		-- The Great War has started! We will need more ground forces!
			0.50, -- Land
			0.15, -- Air
			0.30, -- Sea
			0.05}; -- Other
		
		rValue = laArray	
	else
		local laArray = {		-- Otherwise build up our Navy, Air Force and Industry!
			0.45, -- Land
			0.20, -- Air
			0.30, -- Sea
			0.05}; -- Other
		
		rValue = laArray
	end
	
	return rValue
end
-- Land ratio distribution
function P.LandRatio(minister)
	local rValue
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local engTag = CCountryDataBase.GetTag('ENG')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local gerTag = CCountryDataBase.GetTag('GER')

	-- SSmith (12/05/2013)
	-- Also switch the build if we are at war with Germany or the Soviets
	-- And we will allow for a small amount of armour to be built

	if ministerCountry:GetRelation(engTag):HasWar() or ministerCountry:GetRelation(sovTag):HasWar()
	or ministerCountry:GetRelation(gerTag):HasWar() then
		local laArray = {		-- We need actual Soldiers now!
			2, -- Garrison
			16, -- Infantry
			2, -- Motorized
			1, -- Mechanized
			2, -- Armor
			0, -- Militia
			2}; -- Cavalry
		rValue = laArray
	else
		local laArray = {		-- We need Garrisons to protect our long shore!
			5, -- Garrison
			13, -- Infantry
			2, -- Motorized
			1, -- Mechanized
			2, -- Armor
			0, -- Militia
			2}; -- Cavalry
		rValue = laArray
	end
	return rValue
end
-- Special Forces ratio distribution
function P.SpecialForcesRatio(minister)

	-- SSmith (08/06/2013)
	-- This will now return separate ratios for mountain, marine and airborne brigades
	-- Italy should train mountain brigades

	local laArray = {
		12, -- Mountain
		25, -- Marine
		30}; -- Airborne
	return laArray
end
-- Air ratio distribution
function P.AirRatio(minister)

	-- SSmith (12/05/2013)
	-- We will build a balanced array of aircraft

	local laArray = {
		10, -- Fighter
		4, -- CAS
		6, -- Tactical
		4, -- Naval Bomber
		1}; -- Strategic
	
	return laArray
end
-- Naval ratio distribution
function P.NavalRatio(minister)
	local rValue
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local engTag = CCountryDataBase.GetTag('ENG')
	
	-- SSmith (12/05/2013)
	-- When we are at war with Britain we will build more escorts

	if ministerCountry:GetRelation(engTag):HasWar() then
		local laArray = {		-- More Destroyers and Submarines.
			8, -- Destroyers
			4, -- Submarines
			8, -- Cruisers
			3.5, -- Capital
			1, -- Escort Carrier
			0.5}; -- Carrier
		rValue = laArray
	else
		local laArray = {		-- Balanced Navy with capitals and few Submarines.
			8, -- Destroyers
			4, -- Submarines
			9, -- Cruisers
			3.75, -- Capital
			0.25, -- Escort Carrier
			0}; -- Carrier
		rValue = laArray
	end
	
	return rValue
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)

	-- SSmith (20/06/2013)
	-- More transport ships should help promote AI amphibious operations (was 30)
	-- But let's cut the ratio when the big wars start because we should have more forces by then

	local ministerCountry = minister:GetCountry()
	local engTag = CCountryDataBase.GetTag('ENG')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local gerTag = CCountryDataBase.GetTag('GER')
	if ministerCountry:GetRelation(engTag):HasWar() or ministerCountry:GetRelation(sovTag):HasWar()
	or ministerCountry:GetRelation(gerTag):HasWar() then
		local  laArray = {
			25, -- Land
			1}; -- Transport
		return laArray
	else
		local  laArray = {
			20, -- Land
			1}; -- Transport
		return laArray
	end
	
end


-- SSmith (23/11/2017)
-- Removed division template overrides



function P.MaxUpgrade( ministerTag )

	-- SSmith (16/09/2014)
	-- Amended for efficiency

	local playerTag = CCurrentGameState.GetPlayer()

	if CCountryDataBase.GetTag('ENG') == playerTag
	or CCountryDataBase.GetTag('FRA') == playerTag
	or CCountryDataBase.GetTag('USA') == playerTag
	or CCountryDataBase.GetTag('SOV') == playerTag
	then
		-- If the UK, USA, USSR or France is not AI, then don't put a limit on upgrades!
		return 1.0
	end
	
	-- Don't bother too much with upgrading. An artificial restriction for flavour...
	return 0.25
end

-- END OF PRODUTION OVERIDES
-- #######################################

-- #######################################
-- Intelligence Hooks

-- Home_Spies(minister)
-- #######################################

function P.SpyPriority(ministerTag, ministerCountry, TargetCountry, TargetCountryTag)

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) ) 
	or ( not Utils.ASSERT( TargetCountry ) )
	or ( not Utils.ASSERT( TargetCountryTag ) )
	then
		return nil
	end
	
	-- SSmith (03/07/2013)
	-- Getting Italy into the Axis is proving difficult
	-- Let's try raising threat on the Soviets

	-- this is a bit of a cheat to get Italy into the Axis (and then let it calm down)
	if CCurrentGameState.GetCurrentDate():GetYear() < 1941 and not ministerCountry:HasFaction() then
		if tostring(TargetCountryTag) == "SOV" then
			return 3
		end
	
	-- court Nationalist Spain		
	elseif tostring(TargetCountryTag) == "SPA" and not TargetCountry:HasFaction() then
		return 2
	else
		return nil
	end
end

function P.PickBestMission(ministerTag, ministerCountry, TargetCountry, TargetCountryTag)

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) ) 
	or ( not Utils.ASSERT( TargetCountry ) )
	or ( not Utils.ASSERT( TargetCountryTag ) )
	then
		return nil
	end
	
	local CountryScriptMission = nil
	local sameIdeology = Utils.SameIdeology(ministerCountry, TargetCountry, nil)
	local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	local axisFaction = CCurrentGameState.GetFaction("axis")

	-- SSmith (03/07/2013)
	-- Getting Italy into the Axis is proving difficult
	-- Let's try raising threat on the Soviets
	-- SSmith (16/09/2014)
	-- Amended for efficiency
	-- Slendermang (13/09/19) 
	-- Independent Italy global flag/LUA added
	

	-- SSmith
	-- this is a bit of a cheat to get Italy into the Axis (and then let it calm down)
	-- Slendermang - (13/09/19)
	-- They're primarily concerned with their backyard, and not the NSDAP's vernichtungskrieg.
	if not CCurrentGameState.IsGlobalFlagSet(CString("IndependentItaly")) and liYear > 1937 and liYear < 1941 and not ministerCountry:HasFaction() then
		if tostring(TargetCountryTag) == "SOV" then
			CountryScriptMission = "IncreaseThreat"
		end
	elseif tostring(TargetCountryTag) == "SPA" and not TargetCountry:HasFaction() then
		CountryScriptMission = "BoostOurParty"
	elseif CCurrentGameState.IsGlobalFlagSet(CString("IndependentItaly")) and tostring(TargetCountryTag) == "AUS" and not TargetCountry:GetFaction() == axisFaction then
		if sameIdeology == true then
			CountryScriptMission = "BoostRulingParty"
		else
			CountryScriptMission = "BoostOurParty"
		end
	elseif CCurrentGameState.IsGlobalFlagSet(CString("IndependentItaly")) and tostring(TargetCountryTag) == "POR" and not TargetCountry:HasFaction() then
		if sameIdeology == true then
			CountryScriptMission = "BoostRulingParty"
		else
			CountryScriptMission = "BoostOurParty"
		end

	end
	
	return CountryScriptMission
end

-- End of Intelligence Hooks
-- #######################################

function P.ProposeDeclareWar( minister )
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	
	-- SSmith (16/09/2014)
	-- Amended for efficiency

	local ministerTag = ministerCountry:GetCountryTag()
	local strategy = ministerCountry:GetStrategy()
	local date = ai:GetCurrentDate()
	local year = date:GetYear()
	local month = date:GetMonthOfYear()
	
	local sovTag = CCountryDataBase.GetTag('SOV')
	local usaTag = CCountryDataBase.GetTag('USA')
	local gerTag = CCountryDataBase.GetTag('GER')
	local engTag = CCountryDataBase.GetTag('ENG')
	
	-- SSmith (13/11/2013)
	-- I am adding some checks to keep Italy's aggression in context
	-- I will also code for the AI to take Albania because the strategy depends on it

	-- Early check to see if we are involved in a war we can't really win.
	-- If so, then we should not start new minor wars.
	if ministerCountry:GetRelation(sovTag):HasWar()
	or ministerCountry:GetRelation(usaTag):HasWar()
	or ministerCountry:GetRelation(gerTag):HasWar()						-- It's also possible!
	or ministerCountry:GetRulingIdeology():GetGroup():GetKey():GetString() ~= "fascism"	-- Only if we are in the fascist ideology group!
	or ministerCountry:IsSubject()								-- Not if we've been puppeted!
	or ministerCountry:IsGovernmentInExile()						-- Not if we are in exile!
	or ministerCountry:GetRelation(engTag):HasAlliance()					-- Not if we are allied with the British!
	or tostring(ministerCountry:GetFaction():GetTag()) == "allies"				-- Not if we are in the Allies!
	or ministerCountry:GetSurrenderLevel():Get() > 0.20					-- Not if we are losing! 
	or year < 1940										-- Don't start a-historical wars too early!
	or month < 2										-- Don't start campaigns until at least March!
	or month > 9										-- Don't start campaigns later than October!
	then
		return
	end
	
	local albTag = CCountryDataBase.GetTag('ALB')
	local ausTag = CCountryDataBase.GetTag('AUS')
	local albDefeated = Support.IsDefeated(ministerTag, albTag)
	local gerWarWithEng = gerTag:GetCountry():GetRelation(engTag):HasWar()

	-- Albania. Should be done by decision, but if not, we will declare war manually!
	if not albDefeated						-- Let's subjugate them!
	and not strategy:IsPreparingWarWith(albTag)
	and not ministerCountry:GetRelation(albTag):HasWar()
	and not ministerCountry:GetRelation(ausTag):IsGuaranting()	-- Not if we guarantee Austria because that means Rome-Berlin Axis was rejected
	and gerWarWithEng						-- Only if Europe is already at war
	and ( not Support.GuaranteedByMajor(ministerTag, albTag) )	-- But only if they are not guaranteed.
	then
		Support.PrepareForWar( ministerTag, albTag, 100 )
	end

	if year < 1941 then				-- We won't go any further before 1941
		return
	end

	local greTag = CCountryDataBase.GetTag('GRE')
	local yugTag = CCountryDataBase.GetTag('YUG')
	local greDefeated = Support.IsDefeated(ministerTag, greTag)
	local greAtWar = ministerCountry:GetRelation(greTag):HasWar()
	local yugDefeated = Support.IsDefeated(ministerTag, yugTag)

	-- Greece. Should be done by decision, but if not, we will declare war manually!
	if albDefeated
	and not greDefeated						-- we shall take Greece.
	and not strategy:IsPreparingWarWith(greTag)
	and not greAtWar
	and gerWarWithEng						-- Only if Europe is already at war
	and ( not Support.GuaranteedByMajor(ministerTag, greTag) )	-- But only if they are not guaranteed.
	then
		Support.PrepareForWar( ministerTag, greTag, 100 )
	end

	-- Yugoslavia. If we have Greece or we are fighting them.
	if ( greDefeated or greAtWar )					-- War with Greece or have them already
	and not yugDefeated						-- then get Yugoslavia, too!
	and not strategy:IsPreparingWarWith(yugTag)
	and not ministerCountry:GetRelation(yugTag):HasWar()
	and ( not Support.GuaranteedByMajor(ministerTag, yugTag) )	-- But only if they are not guaranteed.
	then
		Support.PrepareForWar( ministerTag, yugTag, 100 )
	end

	if year < 1942 then				-- We won't go any further before 1942
		return
	end

	local bulTag = CCountryDataBase.GetTag('BUL')
	local hunTag = CCountryDataBase.GetTag('HUN')
	local turTag = CCountryDataBase.GetTag('TUR')
	
	local fraTag = CCountryDataBase.GetTag('FRA')
	local vicTag = CCountryDataBase.GetTag('VIC')
	local lebTag = CCountryDataBase.GetTag('LEB')
	local syrTag = CCountryDataBase.GetTag('SYR')
	local tunTag = CCountryDataBase.GetTag('TUN')
	local algTag = CCountryDataBase.GetTag('ALG')
	
	-- Plans after Yugoslavia:
	P.PlanWarWithMinor(ministerTag, bulTag, yugTag)	-- If Yugoslavia is done, plan for Bulgaria!
	P.PlanWarWithMinor(ministerTag, hunTag, yugTag)	-- If Yugoslavia is done, plan for Hungary!
	
	-- Turkey. Once Greece, Yugoslavia and Bulgaria are all down, we can march on to take the rest of the Mediterranean coast!
	if greDefeated
	and yugDefeated
	and Support.IsDefeated(ministerTag, bulTag)
	and not Support.IsDefeated(ministerTag, turTag)
	and not strategy:IsPreparingWarWith(turTag)
	and not ministerCountry:GetRelation(turTag):HasWar()
	and ( not Support.GuaranteedByMajor(ministerTag, turTag) )	-- But only if they are not guaranteed.
	then
		Support.PrepareForWar( ministerTag, turTag, 100 )
	end
	
	-- SSmith (12/11/2013)
	-- Add a check in case France is still guaranteed by the USSR!

	if gerTag:GetCountry():GetRelation(fraTag):HasWar() 		-- Germany is at war with France
	and Support.IsDefeated(ministerTag, gerTag)			-- This function is not originally made for this, but it also checks alliances and factions just fine
	and not ( ministerCountry:GetRelation(fraTag):HasWar() )	-- Not at war with France yet
	and fraTag:GetCountry():GetSurrenderLevel():Get() > 0.5		-- And they are about to fall
	and ( not Support.GuaranteedByMajor(ministerTag, fraTag) )	-- But only if they are not guaranteed
	then
		Support.PrepareForWar( ministerTag, fraTag, 100 )
	end

	if ministerCountry:GetSurrenderLevel():Get() > 0.00 then	-- Don't start wars outside Europe if we've lost territory
		return
	end

	local lbyTag = CCountryDataBase.GetTag('LBY')
	local ethTag = CCountryDataBase.GetTag('ETH')

	-- Libya. They should belong to us, so if not, let's make them!
	if not Support.IsDefeated(ministerTag, lbyTag)															-- Let's subjugate them!
	and not strategy:IsPreparingWarWith(lbyTag)
	and not ministerCountry:GetRelation(lbyTag):HasWar()
	and ( not Support.GuaranteedByMajor(ministerTag, lbyTag) )	-- But only if they are not guaranteed.
	then
		Support.PrepareForWar( ministerTag, lbyTag, 100 )
	end
	
	-- Ethiopia. They should belong to us, so if not, let's make them!
	if not Support.IsDefeated(ministerTag, ethTag)															-- Let's subjugate them!
	and not strategy:IsPreparingWarWith(ethTag)
	and not ministerCountry:GetRelation(ethTag):HasWar()
	and ( not Support.GuaranteedByMajor(ministerTag, ethTag) )	-- But only if they are not guaranteed.
	then
		Support.PrepareForWar( ministerTag, ethTag, 100 )
	end
	
	-- Plans after the UK is down:

	local egyTag = CCountryDataBase.GetTag('EGY')
	local palTag = CCountryDataBase.GetTag('PAL')
	local jorTag = CCountryDataBase.GetTag('JOR')
	local irqTag = CCountryDataBase.GetTag('IRQ')
	local isrTag = CCountryDataBase.GetTag('ISR')
	local kwtTag = CCountryDataBase.GetTag('KWT')

	P.PlanWarWithMinor(ministerTag, egyTag, engTag)	-- If the UK is gone, plan for Egypt!
	P.PlanWarWithMinor(ministerTag, palTag, engTag)	-- If the UK is gone, plan for Palestine!
	P.PlanWarWithMinor(ministerTag, irqTag, engTag)	-- If the UK is gone, plan for Iraq!
	P.PlanWarWithMinor(ministerTag, jorTag, engTag)	-- If the UK is gone, plan for Transjordan!
	P.PlanWarWithMinor(ministerTag, isrTag, engTag)	-- If the UK is gone, plan for Israel!
	P.PlanWarWithMinor(ministerTag, kwtTag, engTag)	-- If the UK is gone, plan for Kuwait!
	
end

function P.PlanWarWithMinor(ministerTag, minorTag, protectorTag)
	local ministerCountry = ministerTag:GetCountry()
	local minorCountry = minorTag:GetCountry()
	local strategy = ministerCountry:GetStrategy()

	if Support.IsDefeated(ministerTag, protectorTag)			-- If their protector is down
	and not Support.IsDefeated(ministerTag, minorTag)			-- and they are still around, then attack them!
	and not ministerCountry:GetRelation(minorTag):HasWar()
	and not Support.GuaranteedByMajor(ministerTag, minorTag)		-- But only if they are not guaranteed!
	and ( ministerCountry:HasFaction() or not minorCountry:HasFaction() )	-- Don't attack if they are in a faction and we are not!
	then
		Support.PrepareForWar( ministerTag, minorTag, 100 )
	end
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local ministerCountry = agent:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local lsDecision = decision:GetKey():GetString()
	local greTag = CCountryDataBase.GetTag('GRE')
	local albTag = CCountryDataBase.GetTag('ALB')
	local gerTag = CCountryDataBase.GetTag('GER')
	local engTag = CCountryDataBase.GetTag('ENG')
	
	-- SSmith (26/08/2013)
	-- Add random chances so that decisions are taken more realistically

	if lsDecision == "annexation_of_albania" then
		if math.mod( CCurrentGameState.GetAIRand(), 20) == 1 then
			return Support.PrepareForWarDecision( ministerTag, albTag, decision, 5.0 )
		else
			return 0
		end
		
	elseif lsDecision == "the_future_of_greece" then
		if gerTag:GetCountry():GetRelation(engTag):HasWar() 
		and math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			Support.PrepareForWarDecision( ministerTag, greTag, decision, 2.0 )
		else
			score = 0
		end
	
	elseif lsDecision == "berlin_rome_axis" then
		if math.mod( CCurrentGameState.GetAIRand(), 25) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "reconstruct_andrea_doria" or lsDecision == "reconstruct_caio_duilio" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "spanish_civil_war_italian_intervention" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "mobilize_for_war" then

		-- SSmith (15/04/2014)
		-- We should mobilize for war as soon as we can (after the war in Ethiopia)

		if CCurrentGameState.GetCurrentDate():GetYear() > 1936 and math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "give_back_territory_to_ETH" then
		score = 0
	end
	
	return score
end

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local lsRepTag = tostring(recipient)
	local lsFaction = tostring(actor:GetCountry():GetFaction():GetTag())
	
	if lsFaction == "axis" then
		if lsRepTag == "AUS" or lsRepTag == "CZE" or lsRepTag == "SCH" then
			score = 0 -- we get them anyway
		elseif lsRepTag == "HUN" or lsRepTag == "ROM" or lsRepTag == "BUL" or lsRepTag == "FIN" or lsRepTag == "ITA" or lsRepTag == "JAP" then
			score = score + 70
		elseif lsRepTag == "AST" or lsRepTag == "CAN" or lsRepTag == "SAF" or lsRepTag == "NZL" then
			score = 0
		end
	elseif CCurrentGameState.IsGlobalFlagSet(CString("IndependentItaly"))
		if lsRepTag == "AUS" or lsRepTag == "SPA" or lsRepTag = "POR" then
			score = score + 70
		end
	end

	return score
end

function P.AlignToFaction(minister)
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	
	local axisFaction = CCurrentGameState.GetFaction("axis")
	local axisLeader = axisFaction:GetFactionLeader()
	local alliesFaction = CCurrentGameState.GetFaction("allies")
	local alliesLeader = alliesFaction:GetFactionLeader()
	
	-- SSmith (10/11/2013)
	-- If we are at war with the Axis OR the Allies then we will align to the opposite faction
	-- If the Rome-Berlin Axis hasn't been proposed yet we will align to the Allies
	-- If the pact is rejected we will align to the Allies (do this by checking our guarantee of Austria and our control of the South Tirol)
	-- If the pact is accepted we should align to the Axis

	local ausTag = CCountryDataBase.GetTag('AUS')

	local targetLeader = nil	-- We will try to align towards them
	local stopLeader = nil		-- We will stop aligning towards them if we did previously

	-- SSmith (16/09/2014)
	-- Amended for efficiency

	local axisHasWar = ministerCountry:GetRelation(axisLeader):HasWar()
	local alliesHasWar = ministerCountry:GetRelation(alliesLeader):HasWar()
	
	if axisHasWar and not alliesHasWar
	then
		-- War with the Axis but not with the Allies
		stopLeader = axisLeader
		targetLeader = alliesLeader
	elseif alliesHasWar and not axisHasWar
	then
		-- War with the Allies but not with the Axis
		stopLeader = alliesLeader
		targetLeader = axisLeader
	elseif not ministerCountry:GetFlags():IsFlagSet("berlin_rome_axis")
	then
		-- Rome-Berlin Axis not proposed yet
		stopLeader = axisLeader
		targetLeader = alliesLeader
	elseif (ausTag:GetCountry():Exists() and ministerCountry:GetRelation(ausTag):IsGuaranting() and not ministerCountry:GetRelation(ausTag):HasWar())
 	or CCurrentGameState.GetProvince(3427):GetOwner() ~= ministerTag
	then
		-- we are guaranteeing Austria (so Germany rebuffed us) or we've lost the South Tirol
		stopLeader = axisLeader
		targetLeader = alliesLeader
	elseif not axisHasWar
	then
		-- Let's just check we're not at war with Germany
		stopLeader = alliesLeader
		targetLeader = axisLeader
	end
	
	if stopLeader ~= nil then
		local stopAction = CInfluenceAllianceLeader(ministerTag, stopLeader)
		stopAction:SetValue(false)
		if stopAction:IsSelectable() then
			minister:Propose(stopAction, 1000 )
		end
	end
	if targetLeader ~= nil and ministerCountry:GetRelation(targetLeader):GetValue():Get() > 50 then
		-- Still don't align to people we don't like. It's better to be neutral.
		local startAction = CInfluenceAllianceLeader(ministerTag, targetLeader)
		startAction:SetValue(true)
		if startAction:IsSelectable() then
			minister:Propose(startAction, 1000 )
		end
	end
end

function P.DiploScore_CallAlly(liScore, ai, actor, recipient, observer)

	if observer == recipient then

		-- SSmith (19/11/2013)
		-- We want custom rules to handle a German call-to-arms
		-- Italy should be wary of going to war with France
		-- Otherwise OK

		if tostring(actor) == "GER" then

			-- SSmith (30/04/2013)
			-- Italy wasn't being called to war because the French surrender threshold was set to 75%
			-- The new value should achieve a fairly historical outcome

			local fraTag = CCountryDataBase.GetTag('FRA')
			if actor:GetCountry():GetRelation(fraTag):HasWar()		-- Germany is at war with France
			and not recipient:GetCountry():GetRelation(fraTag):HasWar()	-- and we are not!
			and not Support.IsDefeated(actor, fraTag)			-- France is not defeated
			and fraTag:GetCountry():GetSurrenderLevel():Get() < 0.20	-- and isn't really losing yet!
			then
				liScore = 0
			end
		end
	end
	
	return liScore

end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "GER" or tostring(actor) == "SPA" or tostring(actor) == "JAP" then
		score = score + 15
	end
	
	return score
end

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for Italian Republic and our colonies

	local laCountryExceptions = { "RSI", "LBY", "ETH" }
	return laCountryExceptions
end

return AI_ITA
