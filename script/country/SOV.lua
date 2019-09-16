-----------------------------------------------------------
-- Soviet Union
-----------------------------------------------------------

local P = {}
AI_SOV = P

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(minister)
	local laTechWeights

	-- SSmith (23/07/2013)
	-- Changed to new format
	-- Early shift from air to naval techs

	local laTechWeights

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local leadership = minister:GetCountry():GetTotalLeadership():Get()

	if CCurrentGameState.GetCurrentDate():GetYear() < 1938 then

		laTechWeights = {
			0.30, -- Land
			0.25, -- Air
			0.25, -- Naval
			0.20}; -- Other

	elseif leadership < 15 then

		laTechWeights = {
			0.50, -- Land
			0.30, -- Air
			0.05, -- Naval
			0.15}; -- Other

	elseif leadership < 30 then

		laTechWeights = {
			0.40, -- Land
			0.35, -- Air
			0.10, -- Naval
			0.15}; -- Other
	else
		laTechWeights = {
			0.35, -- Land
			0.30, -- Air
			0.20, -- Naval
			0.15}; -- Other
	end
	
	return laTechWeights
end

function P.Get_TechParams(minister)

	-- SSmith (21/08/2013)
	-- This is a new function to return a table of country-specific research config

	local laTechParams = {

		engineer_bridging_equipment	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		engineer_assault_equipment  	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		weapon_salt_water_proofing 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		artic_warfare_equipment 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		amphibious_warfare_equipment 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		mechanised_infantry 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		anti_tank 			= { Leadership =  7, Priority = 1.50, EarlyOffset = 0.50, LateOffset = 0.75, EndYear = 1999, Attribute = "" },
		rocket_artillery_activation 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		rocket_artillery 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		tank_brigade 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_gun 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_armour 			= { Leadership = 12, Priority = 1.10, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_engine 			= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "MediumTank" },
		tank_reliability 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "MediumTank" },
		heavy_tank_brigade 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_gun 			= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_armour 		= { Leadership = 18, Priority = 1.10, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		sloped_armor 			= { Leadership = 12, Priority = 1.50, EarlyOffset = 0.00, LateOffset = 0.75, EndYear = 1999, Attribute = "" },
		self_propelled_support_brigade_tech = { Leadership = 30, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_artillery_activation 	= { Leadership = 30, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_artillery 			= { Leadership = 30, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_rocket_artillery_activation 	= { Leadership = 30, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_rocket_artillery 		= { Leadership = 30, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_destroyer_activation 	= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_destroyer 			= { Leadership = 18, Priority = 1.40, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		sp_anti_air_activation 		= { Leadership = 30, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_anti_air 			= { Leadership = 30, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		destroyer_technology 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1999, Attribute = "ShipBuilding" },
		destroyer_engine 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		multi_purpose_guns 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		smallwarship_asw 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		heavycruiser_technology 	= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1999, Attribute = "ShipBuilding" },
		heavycruiser_armament 		= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		lightcruiser_technology 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1999, Attribute = "ShipBuilding" },
		lightcruiser_armament 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cruiser_engine 			= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cruiser_armor 			= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		submarine_technology 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "ShipBuilding" },
		submarine_engine 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		torpedoes 			= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		battleship_technology 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1942, Attribute = "" },
		capital_ship_armor 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		capital_ship_engine 		= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		capitalship_armament 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		fast_battleship 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },

		escort_fighter_development 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		escort_fighter_armament		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		escort_fighter_drop_tanks 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		supply_production 		= { Leadership =  5, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		supply_transportation 		= { Leadership =  3, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		supply_organisation 		= { Leadership =  3, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		tank_crew_training 		= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		special_forces_training 	= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		capital_ship_crew_training 	= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		night_equipment_training 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleship_taskforce_doctrine 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleline_cruiser_doctrine 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		asw_tactics 			= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		cas_pilot_training 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cas_groundcrew_training 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		night_mission_training 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		airborne_assault_tactics 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" }
	}

	return laTechParams
end


-- SSmith (11/11/2017)
-- TechSliders function replaced with GetOfficerRatio

function P.GetOfficerRatio(ministerCountry, target_ratio)

	-- The Soviet Union shouldn't invest in officers early to reflect the purges
	-- The Soviets will need to get their act together later though

	local year = CCurrentGameState.GetCurrentDate():GetYear()
	local gerTag = CCountryDataBase.GetTag('GER')
	local gerRelation = ministerCountry:GetRelation(gerTag)

	target_ratio = 1.00

	if year > 1940 or ministerCountry:IsAtWar() then	-- 1941 or at war
		target_ratio = 1.10
	elseif year > 1939 then					-- 1940
		target_ratio = 1.05
	end

	if year > 1939 and (not gerRelation:HasNap()) then	-- Afraid of Germany
		target_ratio = 1.15
	end

	if year > 1942 then					-- 1943
		target_ratio = 1.20
	elseif year > 1941 then					-- 1942
		target_ratio = 1.15
	end

	if gerRelation:HasWar() then				-- War with Germany!
		target_ratio = 1.20
		if year > 1943 then				-- 1944
			target_ratio = 1.35
		elseif year > 1942 then				-- 1943
			target_ratio = 1.30
		elseif year > 1941 then				-- 1942
			target_ratio = 1.25
		end
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
	local laArray
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local gerTag = CCountryDataBase.GetTag('GER')
	local engTag = CCountryDataBase.GetTag('ENG')
	local usaTag = CCountryDataBase.GetTag('USA')

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local year = CCurrentGameState.GetCurrentDate():GetYear()

	-- SSmith (20/06/2013)
	-- We should also check if we are at war with the Allies
	-- We also need to decide how to react to the Bitter Peace
	-- I've removed the miscellaneous "at war" condition because I don't want early skirmishes to stop the IC build!
	-- The CalcDesperation method is an unknown quantity so we will use surrender progress

	-- SSmith (29/10/2014)
	-- Reduced naval build in favour of land forces pre-war

	-- SSmith (06/05/2015)
	-- Build land units only at the start of Barbarossa

	if ministerCountry:GetRelation(gerTag):HasWar() then				-- War with Germany

		if ministerCountry:GetSurrenderLevel():Get() > 0.01
		and CCurrentGameState.GetProvince(1409):GetOwner() == ministerTag
		and ministerCountry:GetOfficerRatio():Get() > 0.80
		and ministerCountry:GetUnits():GetTotalNumOfRegiments() < 1200 then	-- Build only land forces until we have enough!
			laArray = {
				1.00, 	-- Land
				0.00, 	-- Air
				0.00, 	-- Sea
				0.00}; 	-- Other
		elseif ministerCountry:GetSurrenderLevel():Get() > 0.25 then	-- Concentrate on land forces if we are losing badly!
			laArray = {
				0.85, 	-- Land
				0.15, 	-- Air
				0.00, 	-- Sea
				0.00}; 	-- Other
		else						-- Diversify a bit if we are doing okay
			laArray = {
				0.70, 	-- Land
				0.20, 	-- Air
				0.05, 	-- Sea
				0.05}; 	-- Other
		end
	elseif ministerCountry:GetRelation(engTag):HasWar()
	or ministerCountry:GetRelation(usaTag):HasWar() then	-- War with Britain or the USA...
		laArray = {
			0.60, 	-- Land
			0.20, 	-- Air
			0.15, 	-- Sea
			0.05}; 	-- Other
	elseif Support.IsDefeated(ministerTag, gerTag) then	-- Germany is defeated!
		laArray = {
			0.45, 	-- Land
			0.20, 	-- Air
			0.25, 	-- Sea
			0.10}; 	-- Other
	elseif Support.IsDefeated(gerTag, ministerTag) then	-- We are defeated by Germany!
		laArray = {
			0.70, 	-- Land
			0.15, 	-- Air
			0.10, 	-- Sea
			0.05}; 	-- Other
	elseif year > 1939 then
		laArray = {
			0.60, 	-- Land				-- The year is at least 1940 so get ready for war!
			0.25, 	-- Air
			0.05, 	-- Sea
			0.10}; 	-- Other
	elseif year > 1938
	or ministerCountry:IsAtWar() then
		laArray = {					-- The year is at least 1939 or we're at war (perhaps with Japan)
			0.50, 	-- Land				-- Start building some units but don't give up on IC just yet!
			0.25, 	-- Air
			0.05, 	-- Sea
			0.20}; 	-- Other
	elseif year > 1937 then
		laArray = {					-- The year is at least 1938 so start switching to military production
			0.25, 	-- Land
			0.15, 	-- Air
			0.05, 	-- Sea
			0.55}; 	-- Other
	else							-- In 1936-37 we should stick to the Five Year Plan!
		laArray = {					-- We're going to throw everything at IC now!
			0.00, 	-- Land
			0.00, 	-- Air
			0.00, 	-- Sea
			1.00}; 	-- Other
	end
	
	return laArray
end
-- Land ratio distribution
function P.LandRatio(minister)
	local laArray
	
	-- SSmith (20/06/2013)
	-- I have increased the number of sections to get a better balance of forces
	-- The aim is to get enough armour and mechanized units but not to go over the top
	-- We are going to set the armour and mobile targets higher from 1939

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local year = CCurrentGameState.GetCurrentDate():GetYear()

	if year > 1942 then
		laArray = {
			1, -- Garrison
			13, -- Infantry
			4, -- Motorized
			3, -- Mechanized
			3, -- Armor
			0, -- Militia
			1}; -- Cavalry
	elseif year > 1941 then
		laArray = {
			1, -- Garrison
			13, -- Infantry
			4, -- Motorized
			2, -- Mechanized
			3, -- Armor
			0, -- Militia
			2}; -- Cavalry
	elseif year > 1939 then
		laArray = {
			1, -- Garrison
			14, -- Infantry
			4, -- Motorized
			1, -- Mechanized
			4, -- Armor
			0, -- Militia
			1}; -- Cavalry
	else
		laArray = {
			2, -- Garrison
			13, -- Infantry
			4, -- Motorized
			0, -- Mechanized
			4, -- Armor
			0, -- Militia
			2}; -- Cavalry
	end

	return laArray
end
-- Special Forces ratio distribution
function P.SpecialForcesRatio(minister)

	-- SSmith (08/06/2013)
	-- This will now return separate ratios for mountain, marine and airborne brigades
	-- The USSR should have a lot of airborne troops

	local laArray = {
		25, -- Mountain
		50, -- Marine
		25}; -- Airborne
	
	return laArray
end
-- Air ratio distribution
function P.AirRatio(minister)
	local ministerTag = minister:GetCountry():GetCountryTag()
	local gerTag = CCountryDataBase.GetTag('GER')

	-- SSmith (13/05/2013)
	-- Added a new section for when Germany is defeated

	if Support.IsDefeated(ministerTag, gerTag) then
		laArray = {
			10, -- Fighter
			4, -- CAS
			5, -- Tactical
			3, -- Naval Bomber
			3}; -- Strategic
	else
		laArray = {
			14, -- Fighter
			5, -- CAS
			5, -- Tactical
			1, -- Naval Bomber
			0}; -- Strategic
	end

	return laArray
end
-- Naval ratio distribution
function P.NavalRatio(minister)
	local laArray
	local ministerTag = minister:GetCountry():GetCountryTag()
	local gerTag = CCountryDataBase.GetTag('GER')
	
	-- SSmith (13/05/2013)
	-- Thanks to the production logic this can be simplified if Germany is beaten

	if Support.IsDefeated(ministerTag, gerTag) then
		laArray = {
			7, -- Destroyers	
			6, -- Submarines
			8, -- Cruisers
			0, -- Capital		<- Battleships are outdated, so we should build Carriers!
			2, -- Escort Carrier
			2}; -- Carrier
	else
		laArray = {
			6, -- Destroyers
			10, -- Submarines
			6, -- Cruisers
			3, -- Capital		<- We still have Battleships.
			0, -- Escort Carrier
			0}; -- Carrier
	end
	
	return laArray
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)
	local laArray
	local ministerTag = minister:GetCountry():GetCountryTag()
	local gerTag = CCountryDataBase.GetTag('GER')

	-- SSmith (13/05/2013)
	-- Fewer transports unless Germany is defeated
	
	if Support.IsDefeated(ministerTag, gerTag) then
		laArray = {
		40, -- Land
		1}; -- Transport
	else
		laArray = {
		180, -- Land
		1}; -- Transport
	end
	
	return laArray
end

-- SSmith (23/11/2017)
-- Removed division template overrides



-- Build lots of factories!
function P.Build_Industry( ic, minister, vbGoOver )

	-- Build five factories at a time!
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local industry = CBuildingDataBase.GetBuilding("industry" )
	local industryCost = ministerCountry:GetBuildCost(industry):Get()
	local laCorePrv = {}
	local loTechStatus = ministerCountry:GetTechnologyStatus()
	
	laCorePrv = CoreProvincesLoop( ministerCountry, loTechStatus, 1, 1 )
	
	local maxIndustry
	if minister:GetOwnerAI():GetCurrentDate():GetYear() >= 1940 then
		maxIndustry = 5
	else
		maxIndustry = 15
	end
	
	-- Don't build too many factories at once!
	local nTotalFactoryBuilds = 0
	for provinceID in ministerCountry:GetCoreProvinces() do
		nTotalFactoryBuilds = nTotalFactoryBuilds + CCurrentGameState.GetProvince( provinceID ):GetCurrentConstructionLevel(industry)
	end
	
	while nTotalFactoryBuilds < maxIndustry do
		if ( ic - industryCost ) >= 0 or vbGoOver then
			if table.getn( laCorePrv[ 6 ] ) > 0 then
				-- Only use provinces from Asia!
				local usableProvinceList = Support.ProvincesOnContient( laCorePrv[ 6 ], 'asia' )
				local industryProvinceID
				if table.getn( usableProvinceList ) > 0 then
					industryProvinceID = usableProvinceList[ math.random( table.getn( usableProvinceList ) ) ]
				else
					industryProvinceID = laCorePrv[6][ math.random( table.getn( laCorePrv[ 6 ] ) ) ]
				end
				local constructCommand = CConstructBuildingCommand( ministerTag, industry, industryProvinceID, 1 )

				if constructCommand:IsValid() then
					ai:Post( constructCommand )
					ic = ic - industryCost		-- Upodate IC total	
				end
			end
		end
		nTotalFactoryBuilds = nTotalFactoryBuilds + 1
	end
	return ic
end

-- We don't want to build any other building than Industry for the first four years.
function P.DontBuildBuilding( minister, building )

	-- SSmith (13/05/2013)
	-- For now we won't allow effort to be wasted on nuclear/rocket research

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local buildingName = building:GetName()

	if minister:GetOwnerAI():GetCurrentDate():GetYear() < 1940
	and tostring(buildingName) ~= "industry"
	then
		return true
	elseif tostring(buildingName) == "Nuclear Research Lab" or tostring(buildingName) == "Rocket Test Site" then
		return true
	else
		return false
	end
end

-- We don't want to spend too much on Upgrades in the beginning.
function P.MaxUpgrade( ministerTag )

	-- SSmith (11/04/20154)
	-- We will always allow the Soviets to upgrade if they're at war

	local year = CCurrentGameState.GetCurrentDate():GetYear()
	local isAtWar = ministerTag:GetCountry():IsAtWar()

	if year < 1940 and not isAtWar then
		-- Before '40, don't bother with that at all. We want to build LOTS of factories instead.
		return 0.0
	elseif year < 1941 and not isAtWar then
		-- In '40, we can start working on it. But still don't overdo it.
		return 0.25
	end
	-- Never spend more than half though.
	return 0.5
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

	local sameIdeology = Utils.SameIdeology(ministerCountry, TargetCountry, nil)
	
	-- SSmith (11/05/2013)
	-- Fixed a syntax error that caused the Soviets to give maximum spy priority to half the countries in the world!

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local targetHasFaction = TargetCountry:HasFaction()

	-- bring Spanish republic into the party
	if tostring(TargetCountryTag) == "SPR" and not targetHasFaction then
		return 3
		
	-- support the communists
	elseif not targetHasFaction and sameIdeology == true then
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

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local targetHasFaction = TargetCountry:HasFaction()

	-- bring Spanish republic into the fold
	if tostring(TargetCountryTag) == "SPR" and not targetHasFaction then
		CountryScriptMission = "BoostOurParty"
	
	elseif sameIdeology == true and not targetHasFaction then	
		CountryScriptMission = "BoostRulingParty"
	end
	
	return CountryScriptMission
end

-- End of Intelligence Hooks
-- #######################################

function P.ProposeDeclareWar( minister )
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local gerTag = CCountryDataBase.GetTag('GER')
	local gerCountry = gerTag:GetCountry()
	
	local axisFaction = CCurrentGameState.GetFaction("axis")
	local alliesFaction = CCurrentGameState.GetFaction("allies")
	local comminternFaction = CCurrentGameState.GetFaction("commintern")
	
	local loStrategy = ministerCountry:GetStrategy()
	local ai = minister:GetOwnerAI()
	local date = ai:GetCurrentDate()
	local year = date:GetYear()
	local month = date:GetMonthOfYear()

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	-- Do the Russians control Moscow?
	if CCurrentGameState.GetProvince(1409):GetOwner() == ministerTag then
		if gerCountry:IsAtWar() and not(ministerCountry:IsAtWar()) then
			local fraTag = CCountryDataBase.GetTag('FRA')
			local polTag = CCountryDataBase.GetTag('POL')
			local loRelation = ai:GetRelation(ministerTag, gerTag)
			
			-- SSmith (17/01/2016)
			-- Add check that Germany is our neighbour

			if ministerCountry:IsNeighbour(gerTag)		-- Germany is our neighbour
			and gerCountry:GetRelation(fraTag):HasWar()	-- France is at war with Germany
			and not(loRelation:HasNap())			-- We don't have a NAP
			then
				-- SSmith (22/06/2013)
				-- The CalcDesperation method is an unknown quantity we will use surrender progress instead

				-- SSmith (17/01/2016)
				-- Check French surrender progress

				if fraTag:GetCountry():GetSurrenderLevel():Get() > 0.15		-- France is losing
				or gerCountry:GetSurrenderLevel():Get() > 0.15			-- or Germany is losing
				then
					Support.PrepareForWar( ministerTag, gerTag, 100 )
				end

			elseif year >= 1942 							-- From '42, let's prepare!
			and not Support.IsDefeated(ministerTag, gerTag)				-- Germany is still standing
			and ministerCountry:IsNeighbour(gerTag)					-- and is our neighbour
			and not(loRelation:HasNap()) then

				Support.PrepareForWar( ministerTag, gerTag, 100 )

			elseif year >= 1942
			and not Support.IsDefeated(ministerTag, gerTag)				-- Germany is still standing
			and not Support.IsDefeated(ministerTag, polTag)				-- Poland still exists
			and ministerCountry:IsNeighbour(polTag) then				-- and is our neighbour

				Support.PrepareForWar( ministerTag, polTag, 100 )
			end
		end
		
		if ministerCountry:GetFaction() == comminternFaction
		and not(loStrategy:IsPreparingWar()) then		
			-- Generic DOW for countries not part of the same faction
			local currentNeutrality = ministerCountry:GetNeutrality():Get()

			local ministerFaction = ministerCountry:GetFaction()
			local ministerManpower = ministerCountry:GetManpower():Get()
			local ministerIdeologyGroup = ministerCountry:GetRulingIdeology():GetGroup()
			local ministerMobilized = ministerCountry:IsMobilized()
			local gerDefeated = Support.IsDefeated(ministerTag, gerTag)

			for loTargetCountry in CCurrentGameState.GetCountries() do
				local loTargetTag = loTargetCountry:GetCountryTag()
				local targetFaction = loTargetCountry:GetFaction()
				local targetIsNeighbour = ministerCountry:IsNeighbour(loTargetTag)
				
				local fnParams = {
					MinisterTag = ministerTag,
					TargetTag = loTargetTag
				}
				if not(targetFaction == ministerFaction) then
					local targetCountryCapitalContinentString = tostring(loTargetCountry:GetCapitalLocation():GetContinent())
					if ( targetCountryCapitalContinentString == "europe"	-- European,
					or targetCountryCapitalContinentString == "asia" 	-- Asian
					or targetIsNeighbour )					-- or at least a neighbor.
					and Support.CompareEstimatedMilitaryStrength(fnParams) > 1.5
					and ministerManpower > 500
					then
						local currentThreat = ministerCountry:GetRelation(loTargetTag):GetThreat():Get()
						local canAttack = ( gerDefeated or ( not loTargetCountry:HasFaction() ) or targetFaction == axisFaction )
						
						if gerDefeated then		-- Germany is no longer a threat, so let's start the Revolution!
							local targetIdeologyGroup = loTargetCountry:GetRulingIdeology():GetGroup()
							if not ( targetIdeologyGroup == ministerIdeologyGroup ) and targetIsNeighbour then
								Support.PrepareForWar( ministerTag, loTargetTag, 100 )	-- Let's start with neighbours!
							end
						elseif canAttack and currentThreat > currentNeutrality + 20 and ministerMobilized then
							Support.PrepareForWar( ministerTag, loTargetTag, 100 )
						elseif currentThreat > currentNeutrality + 10 then
							local command = CToggleMobilizationCommand( ministerTag, true )
							ai:Post( command )
						end
					end
				end
			end
		end

		-- SSmith (26/09/2014)
		-- Add a new section to go to war with Japan

		if year > 1942
		and month > 3 and month < 9
		and math.mod( CCurrentGameState.GetAIRand(), 8) == 1 then

			local engTag = CCountryDataBase.GetTag('ENG')
			local usaTag = CCountryDataBase.GetTag('USA')
			local japTag = CCountryDataBase.GetTag('JAP')
			local japCountry = japTag:GetCountry()

			if not ministerCountry:IsSubject()							-- Not if we've been puppeted!
			and not ministerCountry:IsGovernmentInExile()						-- Not if we are in exile!
			and ministerCountry:GetSurrenderLevel():Get() < 0.01					-- We aren't losing!
			and (not gerCountry:Exists() or gerCountry:IsGovernmentInExile())			-- Germany is defeated!
			and not ministerCountry:GetRelation(engTag):HasWar()					-- We're not at war with the British!
			and not ministerCountry:GetRelation(usaTag):HasWar()					-- We're not at war with the Americans!
			and japCountry:GetFaction() == axisFaction						-- Japan is in the Axis!
			and not Support.IsDefeated(ministerTag, japTag)						-- Japan is not defeated!
			and not ministerCountry:GetRelation(japTag):HasWar()					-- We're not yet at war with Japan!
			and not loStrategy:IsPreparingWarWith(japTag)						-- We're not preparing yet!
			and (
				(japCountry:GetRelation(engTag):HasWar() and not Support.IsDefeated(japTag, engTag))	-- Japan is fighting the British!
				or (japCountry:GetRelation(usaTag):HasWar()and not Support.IsDefeated(japTag, usaTag))	-- Or Japan is fighting the Americans!
			)
			then
				Support.PrepareForWar( ministerTag, japTag, 100 )
			end
		end
	else
		-- Moscow is taken. Let's plan taking it back!

		-- SSmith (22/06/2013)
		-- The CalcDesperation method is an unknown quantity so we will use surrender progress instead

		local moscowOwnerTag = CCurrentGameState.GetProvince(1409):GetOwner()
		if moscowOwnerTag:GetCountry():GetSurrenderLevel():Get() > 0.25 then		-- The current controller of Moscow is getting beaten!
			local command = CToggleMobilizationCommand( ministerTag, true )
			ai:Post( command )
			Support.PrepareForWar( ministerTag, moscowOwnerTag, 100 )
		end
	end
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)

	local ministerCountry = agent:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local strategy = ministerCountry:GetStrategy()
	local finTag = CCountryDataBase.GetTag('FIN')
	local gerTag = CCountryDataBase.GetTag('GER')
	local fraTag = CCountryDataBase.GetTag('FRA')
	local engTag = CCountryDataBase.GetTag('ENG')
	local usaTag = CCountryDataBase.GetTag('USA')

	-- SSmith (28/08/2013)
	-- Add random chances to make decisions plausible

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local lsDecision = decision:GetKey():GetString()
	
	if lsDecision == 'finnish_winter_war' then
		local finCountry = finTag:GetCountry()
		local finRelationGer = finCountry:GetRelation(gerTag)
		local finRelationFra = finCountry:GetRelation(fraTag)
		local finRelationEng = finCountry:GetRelation(engTag)
		local finRelationUSA = finCountry:GetRelation(usaTag)
		if ( not finRelationGer:IsGuaranteed() or finRelationGer:HasWar() )
		and ( not finRelationFra:IsGuaranteed() or finRelationFra:HasWar() )
		and ( not finRelationEng:IsGuaranteed() or finRelationEng:HasWar() )
		and ( not finRelationUSA:IsGuaranteed() or finRelationUSA:HasWar() )
		and math.mod( CCurrentGameState.GetAIRand(), 10) == 1
		then
			return Support.PrepareForWarDecision( ministerTag, finTag, decision, 5.0 )	-- Should prepare, because they already have serious penalties!
		end
		score = 0
	elseif lsDecision == 'great_officer_purge' then
		if ministerCountry:GetNationalUnity():Get() > 65 then			-- Only make the Purge, if we have low Unity!
			score = 0
		elseif math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'attack_on_poland'
	or lsDecision == 'attack_on_poland_no_guarantee'
	then
		local polTag = CCountryDataBase.GetTag('POL')
		if polTag:GetCountry():GetSurrenderLevel():Get() > 0.25 then
			score = 100		-- There really shouldn't be any need to prepare by then, so don't waste any time!
		else
			score = 0
		end
	elseif lsDecision == 'industry_moved_to_siberia_v1' then	-- Only make this decision, if the provinces are threatened!
		if CCurrentGameState.GetProvince(989):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1534):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1694):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2222):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2279):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(3244):IsFrontProvince(true)
		then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'industry_moved_to_siberia_v2' then	-- Only make this decision, if the provinces are threatened!
		if CCurrentGameState.GetProvince(909):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1536):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1696):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1819):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1991):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2049):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2517):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2976):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2911):IsFrontProvince(true)
		then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'industry_moved_to_siberia_v3' then	-- Only make this decision, if the provinces are threatened!
		if CCurrentGameState.GetProvince(782):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1231):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1072):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1037):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1409):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1235):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1278):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1589):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1501):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2233):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2401):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2651):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1201):IsFrontProvince(true)
		then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'spanish_civil_war_russian_intervention' then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'sino_soviet_non_aggression_pact' then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'operation_zet' then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'claim_bessarabia' then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'operation_countenance' then
		if math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'ultimatum_to_the_baltic_states' or lsDecision == 'ultimatum_to_the_baltic_states_v2'
	or lsDecision == 'ultimatum_to_the_baltic_states_v3' then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'demand_eastern_poland' then
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'end_of_tannu_tuva' then
		if math.mod( CCurrentGameState.GetAIRand(), 250) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'molotov_line_1' or lsDecision == 'molotov_line_2'
	or lsDecision == 'molotov_line_3' or lsDecision == 'molotov_line_4'
	or lsDecision == 'molotov_line_5' then

		-- SSmith (17/09/2014)
		-- Don't move the fortifications if we're at war with Germany

		if not ministerCountry:GetRelation(gerTag):HasWar() and math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == 'bitter_peace' then

		-- SSmith (28/11/2013)
		-- We will handle acceptance of the Bitter Peace by checking a country variable calculated in the Foreign Minister script

		if ministerCountry:GetVariables():GetVariable(CString("ai_bitter_peace")):Get() > 99 then
			score = 100
		else
			score = 0
		end
	end
	
	return score
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	local actorIdeologyGroup = actor:GetCountry():GetRulingIdeology():GetGroup()
	local recipientIdeologyGroup = recipient:GetCountry():GetRulingIdeology():GetGroup()
	
	if lsActorTag == "GER" then
		score = score + 20
	elseif actorIdeologyGroup == recipientIdeologyGroup then
		score = score + 50
	end
	
	return score
end

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local axisFaction = CCurrentGameState.GetFaction('axis')
	local alliesFaction = CCurrentGameState.GetFaction('allies')
	local recipientIdeologyGroup = recipient:GetCountry():GetRulingIdeology():GetGroup()
	local actorIdeologyGroup = actor:GetCountry():GetRulingIdeology():GetGroup()

	if axisFaction:GetNumberOfMembers() > 0						-- Until one of the other factions are down, we only want to worry about
	and alliesFaction:GetNumberOfMembers() > 0					-- our ideological friends!
	and not ( actorIdeologyGroup == recipientIdeologyGroup )
	then
		return 0
	else
		return score
	end
end

function P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer)

	-- SSmith (10/11/2013)
	-- Don't let Xinjiang join Comintern

	local japTag = CCountryDataBase.GetTag('JAP')
	local chcTag = CCountryDataBase.GetTag('CHC')
	local sikTag = CCountryDataBase.GetTag('SIK')

	local recipientTagString = tostring(recipient)
	local actorIdeologyGroup = actor:GetCountry():GetRulingIdeology():GetGroup()
	local recipientIdeologyGroup = recipient:GetCountry():GetRulingIdeology():GetGroup()

	if actorIdeologyGroup == recipientIdeologyGroup then
		score = score + 50
	else
		score = score - 25
	end
	
	if (recipient == chcTag or recipient == sikTag) and not Support.IsDefeated(actor, japTag) then
		score = 0
	end
	
	return score
end

function P.DiploScore_CallAlly(liScore, ai, actor, recipient, observer)

	-- SSmith (02/06/2013)
	-- The USSR is getting called against Japan by Xinjiang
	-- We will say no unless we have defeated Germany

	if observer == recipient then

		local gerTag = CCountryDataBase.GetTag('GER')
		local japTag = CCountryDataBase.GetTag('JAP')

		-- SSmith (17/09/2014)
		-- Amended for efficiency

		local actorCountry = actor:GetCountry()
		local recipientCountry = recipient:GetCountry()

		if actorCountry:GetRelation(japTag):HasWar()
		and not recipientCountry:GetRelation(japTag):HasWar()
		and not Support.IsDefeated(recipient, gerTag) then
			liScore = 0
		end

		-- SSmith (10/11/2013)
		-- Check that we don't get called against Germany after Bitter Peace

		if actorCountry:GetRelation(gerTag):HasWar()
		and recipientCountry:GetFlags():IsFlagSet("bitter_peace")
		and not recipientCountry:GetRelation(gerTag):HasWar() then
			liScore = 0
		end
	end
	
	return liScore
end

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for Soviet Republics and Baltic States

	local laCountryExceptions = { "RUS", "ARM", "AZB", "BLR", "GEO", "UKR", "KAZ", "KYG", "TRK", "TAJ", "UZB", "EST", "LAT", "LIT", "TAN" }
	return laCountryExceptions
end

-- Soviets want more troops, let them learn on the battlefield.
--   helps them produce troops faster
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _MINIMAL_TRAINING_ = 28
	return CLawDataBase.GetLaw(_MINIMAL_TRAINING_)
end

function P.HandleMobilization( minister, needsMobilization )

	-- SSmith (02/05/2014)
	-- Re-written rules so USSR doesn't suffer the cost of premature and repeated mobilizations

	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local gerTag = CCountryDataBase.GetTag('GER')
	local gerCountry = gerTag:GetCountry()
	local polTag = CCountryDataBase.GetTag('POL')
	local fraTag = CCountryDataBase.GetTag('FRA')

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local polDefeated = Support.IsDefeated(gerTag, polTag)

	if gerCountry:GetRelation(polTag):HasWar()
	and not polDefeated then

		-- Germany at war with Poland (we plan to invade as well or Germany is threatening our sphere of interest)

		needsMobilization = true

	elseif polDefeated
	and not ministerCountry:GetRelation(gerTag):HasNap() then

		-- Germany has defeated Poland and we don't have a NAP (so no MRP was signed)

		needsMobilization = true

	elseif Support.IsDefeated(gerTag, fraTag)
	and polDefeated then

		-- Germany has defeated France and Poland
		-- Stay mobilized if we are already
		-- Otherwise don't bother during the winter

		local month = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
		if ministerCountry:IsMobilized() or (month > 1 and month < 9) then
			needsMobilization = true
		end

	elseif CCurrentGameState.GetCurrentDate():GetYear() < 1940 then

		-- Otherwise don't mobilize before 1940

		needsMobilization = false
	end

	-- SSmith (17/04/2013)
	-- Added a mobilization function to prevent premature mobilization due to Japanese threat
	-- We will only mobilize if Germany is at war or has defeated Poland
	-- And we will demobilize otherwise if it's before 1940

--	local ministerTag = minister:GetCountryTag()
--	local ministerCountry = minister:GetCountry()
--	local gerTag = CCountryDataBase.GetTag('GER')
--	local polTag = CCountryDataBase.GetTag('POL')

--	if gerTag:GetCountry():IsAtWar() or Support.IsDefeated(gerTag, polTag) then
--		needsMobilization = true
--	elseif minister:GetOwnerAI():GetCurrentDate():GetYear() < 1940 then
--		needsMobilization = false
--	end

	return needsMobilization
end

return AI_SOV
