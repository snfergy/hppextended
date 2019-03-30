-----------------------------------------------------------
-- Japan
-----------------------------------------------------------

local P = {}
AI_JAP = P

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
			0.20, -- Air
			0.30, -- Naval
			0.20}; -- Other
	else
		laTechWeights = {
			0.30, -- Land
			0.30, -- Air
			0.20, -- Naval
			0.20}; -- Other
	end
		
	if CCurrentGameState.IsGlobalFlagSet( CString( "strong_jap_navy_influence" ) ) then
		-- Lower Land investment
		laTechWeights[ 1 ] = laTechWeights[ 1 ] - 0.04
		-- Higher Naval investment
		laTechWeights[ 3 ] = laTechWeights[ 3 ] + 0.04
	elseif CCurrentGameState.IsGlobalFlagSet( CString( "jap_navy_influence" ) ) then
		-- Lower Land investment
		laTechWeights[ 1 ] = laTechWeights[ 1 ] - 0.02
		-- Higher Naval investment
		laTechWeights[ 3 ] = laTechWeights[ 3 ] + 0.02
	elseif CCurrentGameState.IsGlobalFlagSet( CString( "jap_army_influence" ) ) then
		-- Higher Land investment
		laTechWeights[ 1 ] = laTechWeights[ 1 ] + 0.02
		-- Lower Naval investment
		laTechWeights[ 3 ] = laTechWeights[ 3 ] - 0.02
	elseif CCurrentGameState.IsGlobalFlagSet( CString( "strong_jap_army_influence" ) ) then
		-- Higher Land investment
		laTechWeights[ 1 ] = laTechWeights[ 1 ] + 0.04
		-- Lower Naval investment
		laTechWeights[ 3 ] = laTechWeights[ 3 ] - 0.04
	end
	
	return laTechWeights
end

function P.Get_TechParams(minister)

	-- SSmith (21/08/2013)
	-- This is a new function to return a table of country-specific research config

	local laTechParams = {

		artic_warfare_equipment 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		jungle_warfare_equipment 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		super_heavy_tank_brigade 	= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.50, LateOffset = 0.00, EndYear = 1999, Attribute = "InfantryTank" },
		super_heavy_tank_gun 		= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "InfantryTank" },
		super_heavy_tank_armour 	= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.50, LateOffset = 0.00, EndYear = 1999, Attribute = "InfantryTank" },
		lighttank_brigade 		= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.50, LateOffset = 0.00, EndYear = 1999, Attribute = "LightTank" },
		lighttank_gun 			= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.50, LateOffset = 0.00, EndYear = 1999, Attribute = "LightTank" },
		lighttank_armour 		= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.50, LateOffset = 0.00, EndYear = 1999, Attribute = "LightTank" },
		sloped_armor 			= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

		smallwarship_asw 		= { Leadership = 12, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		torpedoes 			= { Leadership =  7, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		battleship_technology 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1942, Attribute = "" },
		capital_ship_armor 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		capital_ship_engine 		= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		capitalship_armament 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		escort_carrier_technology 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_technology 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		deck_armor 			= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cag_naval_focus 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		air_launched_torpedo 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		nav_development 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		medium_navagation_radar 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

		prefab_ports 			= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		supply_production 		= { Leadership =  5, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		supply_transportation 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		supply_organisation 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		artillery_training 		= { Leadership =  5, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		special_forces_training 	= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		officer_training		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		capital_ship_crew_training 	= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_crew_training 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		night_equipment_training 	= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		underway_repleshment 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		base_operations 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleship_taskforce_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleline_cruiser_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_escort_role_doctrine 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		asw_tactics 			= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sealane_interdiction 		= { Leadership = 10, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		trade_interdiction_submarine_doctrine = { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		force_projection 		= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_taskforce_doctrine 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cruiser_escort_doctrine 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		fleet_escort_destroyer_doctrine = { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		fleet_submarine_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		cag_pilot_training 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		night_mission_training 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		naval_aviation_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		portstrike_tactics 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		navalstrike_tactics 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		naval_tactics 			= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" }
	}

	return laTechParams
end


-- SSmith (10/05/2013)
-- I have replaced this with a new function

function P.TechSliders(ministerCountry, techSliderArray)

	local LEADERSHIP_RESEARCH = techSliderArray[1]
	local LEADERSHIP_ESPIONAGE = techSliderArray[2]
	local LEADERSHIP_DIPLOMACY = techSliderArray[3]
	local LEADERSHIP_NCO = techSliderArray[4]

	-- Japan needs a custom officer ratio to make sure it invests in officers

	local officer_ratio = ministerCountry:GetOfficerRatio():Get()

	if officer_ratio < 0.75 then
		LEADERSHIP_NCO = 0.50	-- We can't build new units!
	elseif officer_ratio < 1.00 then
		LEADERSHIP_NCO = 0.35
	elseif officer_ratio < 1.25 then
		LEADERSHIP_NCO = 0.25	-- We need a decent ratio first!
	elseif officer_ratio < 1.50 then
		LEADERSHIP_NCO = 0.15	-- Let's build up our Officer Ratio to max!
	else
		LEADERSHIP_NCO = 0.00
	end

	techSliderArray = {
		LEADERSHIP_RESEARCH,
		LEADERSHIP_ESPIONAGE,
		LEADERSHIP_DIPLOMACY,
		LEADERSHIP_NCO};

	return techSliderArray

end


function P.IsInvaded(ministerTag, ministerCountry)

	-- SSmith (31/10/2014)
	-- New function to evaluate if the Japanese home islands have been invaded

	-- If we haven't lost cores don't check anything else (performance)

	if ministerCountry:GetSurrenderLevel():Get() < 0.01 then

		return false
	end

	-- Otherwise check for the loss of Tokyo or major port cities

	if CCurrentGameState.GetProvince( 5315 ):GetController() ~= ministerTag		-- Tokyo
	or CCurrentGameState.GetProvince( 5543 ):GetController() ~= ministerTag		-- Nagasaki
	or CCurrentGameState.GetProvince( 5520 ):GetController() ~= ministerTag		-- Sasebo
	or CCurrentGameState.GetProvince( 5425 ):GetController() ~= ministerTag		-- Hiroshima
	or CCurrentGameState.GetProvince( 5343 ):GetController() ~= ministerTag		-- Maizuru
	or CCurrentGameState.GetProvince( 5218 ):GetController() ~= ministerTag		-- Kanazawa
	or CCurrentGameState.GetProvince( 4986 ):GetController() ~= ministerTag		-- Akita
	or CCurrentGameState.GetProvince( 7238 ):GetController() ~= ministerTag		-- Sapporo
	or CCurrentGameState.GetProvince( 5348 ):GetController() ~= ministerTag		-- Yokohama
	or CCurrentGameState.GetProvince( 5346 ):GetController() ~= ministerTag		-- Nagoya
	or CCurrentGameState.GetProvince( 5370 ):GetController() ~= ministerTag		-- Osaka
	or CCurrentGameState.GetProvince( 5457 ):GetController() ~= ministerTag		-- Kochi
	then
		--Utils.LUA_DEBUGOUT("JAP invaded: true")
		return true
	else
		--Utils.LUA_DEBUGOUT("JAP invaded: false")
		return false
	end
end


-- #######################################
-- Production Overides the main LUA with country specific ones

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(minister)
	local rValue
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local njgTag = CCountryDataBase.GetTag('NJG')
	local manTag = CCountryDataBase.GetTag('MAN')
	local usaTag = CCountryDataBase.GetTag('USA')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local chiTag = CCountryDataBase.GetTag('CHI')

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local year = CCurrentGameState.GetCurrentDate():GetYear()
	local chiWar = ministerCountry:GetRelation(chiTag):HasWar()
	local beiping = CCurrentGameState.GetProvince(4979):GetController()
	local nanjing = CCurrentGameState.GetProvince(5494):GetController()
	local jinan = CCurrentGameState.GetProvince(5275):GetController()

	-- SSmith (04/05/2013)
	-- Japan is beating China in TFH so this is an opportunity to shift things in favour of the IJN
	-- I will start with a compromise between the existing values and the ones I did for Semper Fi
	-- I am adding a contingency for the Sino-Japanese War depending on whether we've taken Nanjing
	-- I will also prioritize war with the USA before the Soviets

	-- SSmith (12/09/2013)
	-- Move the sections for UsA and USSR above China
	-- For China we will increase land forces unless we have Beiping, Jinan and Nanjing
	-- We will also react if Manchukuo is losing
	-- Finally we will build up for war in the Pacific
	
	-- SSmith (31/10/2014)
	-- New section to handle invasion of the home islands

	if P.IsInvaded(ministerTag, ministerCountry) then
		local laArray = {		-- We've been invaded so build a lot of land forces!
			0.65,	-- Land
			0.15,	-- Air
			0.15,	-- Sea
			0.05};	-- Other
		rValue = laArray
	elseif year < 1939 and not(ministerCountry:IsAtWar()) then
		local laArray = {		-- Before the Sino-Japanese War, build up our naval units!
			0.30,	-- Land
			0.30,	-- Air
			0.30,	-- Sea
			0.10};	-- Other
		rValue = laArray
	elseif ministerCountry:GetRelation(usaTag):HasWar() then
		local laArray = {		-- War with the USA, so we need a good Navy and better Air Cover!
			0.35,	-- Land
			0.25,	-- Air
			0.35,	-- Sea
			0.05};	-- Other
		rValue = laArray
	elseif ministerCountry:GetRelation(sovTag):HasWar() then
		local laArray = {		-- War with the Soviets, so we need more ground forces!
			0.50,	-- Land
			0.20,	-- Air
			0.25,	-- Sea
			0.05};	-- Other
		rValue = laArray
	elseif chiWar								-- We are at war with China and losing badly!
	and ((beiping ~= ministerTag and beiping ~= njgTag)			-- Beiping is lost
	or manTag:GetCountry():GetSurrenderLevel():Get() > 0.10) then		-- Manchukuo is invaded
		local laArray = {
			0.45,	-- Land
			0.25,	-- Air
			0.25,	-- Sea
			0.05};	-- Other
		rValue = laArray
	elseif chiWar							-- We are at war with China and we aren't winning!
	and ((nanjing ~= ministerTag and nanjing ~= njgTag)		-- We haven't got Nanjing
	or (jinan ~= ministerTag and jinan ~= njgTag)) then		-- We haven't got Jinan
		local laArray = {
			0.35,	-- Land
			0.30,	-- Air
			0.30,	-- Sea
			0.05};	-- Other
		rValue = laArray
	elseif year > 1940
	or ministerCountry:GetFlags():IsFlagSet("indochine_to_japan") then
		local laArray = {		-- Build up some land forces in readiness for the Pacific
			0.30,	-- Land
			0.30,	-- Air
			0.35,	-- Sea
			0.05};	-- Other
		rValue = laArray
	else
		local laArray = {		-- We are at peace or winning in China so we can focus on the navy
			0.20,	-- Land
			0.30,	-- Air
			0.40,	-- Sea
			0.10};	-- Other
		rValue = laArray
	end
	
	return rValue
end
-- Land ratio distribution
function P.LandRatio(minister)
	local rValue
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local chiTag = CCountryDataBase.GetTag('CHI')
	local usaTag = CCountryDataBase.GetTag('USA')
	local sovTag = CCountryDataBase.GetTag('SOV')
	
	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local year = CCurrentGameState.GetCurrentDate():GetYear()

	-- SSmith (12/05/2013)
	-- Japan will be allowed to build small amounts of motorized and armour

	-- SSmith (31/10/2014)
	-- New section to handle invasion of the home islands

	if P.IsInvaded(ministerTag, ministerCountry) then
		local laArray = {			-- We've been invaded, build proper ground forces!
			4, -- Garrison
			15, -- Infantry
			1, -- Motorized
			1, -- Mechanized
			1, -- Armor
			0, -- Militia
			3}; -- Cavalry		<- Less Cavalry now!
		rValue = laArray
	elseif year <= 1938 and not(ministerCountry:IsAtWar()) then
		local laArray = {			-- Before the war with China, build proper ground forces!
			6, -- Garrison
			12, -- Infantry
			1, -- Motorized
			0, -- Mechanized
			1, -- Armor
			2, -- Militia
			3}; -- Cavalry		<- They may be usefull in China!
		rValue = laArray
	elseif year <= 1940 and ministerCountry:GetRelation(chiTag):HasWar() then
		local laArray = {			-- War with China. We need some more garrisons to keep order.
			5, -- Garrison
			13, -- Infantry
			1, -- Motorized
			0, -- Mechanized
			1, -- Armor
			2, -- Militia
			3}; -- Cavalry		<- Still use Cavalry!
		rValue = laArray
	elseif ministerCountry:GetRelation(sovTag):HasWar() then
		local laArray = {			-- War with the Soviets. We need more Infantry!
			4, -- Garrison
			15, -- Infantry
			1, -- Motorized
			1, -- Mechanized
			1, -- Armor
			0, -- Militia
			3}; -- Cavalry		<- Less Cavalry now!
		rValue = laArray
	elseif ministerCountry:GetRelation(usaTag):HasWar() then
		local laArray = {			-- War with the USA. We need to defend our Islands!
			4, -- Garrison
			15, -- Infantry
			1, -- Motorized
			1, -- Mechanized
			1, -- Armor
			0, -- Militia
			3}; -- Cavalry
		rValue = laArray
	else
		local laArray = {			-- Otherwise let's be more balanced and even build some tanks.
			4, -- Garrison
			15, -- Infantry
			1, -- Motorized
			1, -- Mechanized
			1, -- Armor
			0, -- Militia
			3}; -- Cavalry
		rValue = laArray
	end
	
	return rValue
end
-- Special Forces ratio distribution
function P.SpecialForcesRatio(minister)

	-- SSmith (08/06/2013)
	-- This will now return separate ratios for mountain, marine and airborne brigades#
	-- Japan should focus on marines

	local laArray = {
		20, -- Mountain
		15, -- Marine
		30}; -- Airborne
	
	return laArray
end
-- Air ratio distribution
function P.AirRatio(minister)

	-- SSmith (12/05/2013)
	-- Make sure we build a balanced range of aircraft

	local laArray = {
		10,	-- Fighter
		4,	-- CAS
		5,	-- Tactical
		5,	-- Naval Bomber
		1};	-- Strategic
	
	return laArray
end
-- Naval ratio distribution
function P.NavalRatio(minister)
	local rValue
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local usaTag = CCountryDataBase.GetTag('USA')
	local engTag = CCountryDataBase.GetTag('ENG')

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local year = CCurrentGameState.GetCurrentDate():GetYear()

	-- SSmith (12/05/2013)
	-- We should also consider war with the Royal Navy
	-- Expand the range of options considerably to provide for a balanced fleet
	-- This becomes much easier with the new production logic!

	-- SSmith (31/10/2014)
	-- New section to handle invasion of the home islands

	if P.IsInvaded(ministerTag, ministerCountry) then

		-- We've been invaded so we can't afford capitals

		local laArray = {		-- We need Destroyers!
			9,	-- Destroyers
			4,	-- Submarines
			9,	-- Cruisers
			1,	-- Capital
			1,	-- Escort Carrier
			1}; 	-- Carrier
		rValue = laArray

	elseif (ministerCountry:GetRelation(usaTag):HasWar() or ministerCountry:GetRelation(engTag):HasWar())
	and year > 1940 then

		-- We are now at war with a major naval power and it's at least 1941
		-- We will build some carriers but concentrate mostly on building escorts

		local laArray = {		-- We need Destroyers!
			7.5,	-- Destroyers
			3,	-- Submarines
			9,	-- Cruisers
			2,	-- Capital
			1.5,	-- Escort Carrier
			2}; 	-- Carrier
		rValue = laArray
	else
		-- We are not at war with a major naval power but it's at least 1943
		-- We can still build some carriers but shift more focus to escorts

		if year > 1942 then
			local laArray = {
				7.5,	-- Destroyers
				3,	-- Submarines
				9,	-- Cruisers
				2,	-- Capital	-- Mostly ignore battleships!
				1.5,	-- Escort Carrier
				2}; 	-- Carrier
			rValue = laArray

		-- We are not at war with a major naval power but it's at least 1940
		-- We can still build some carriers but shift more focus to escorts

		elseif year > 1939 then
			local laArray = {
				7,	-- Destroyers
				3,	-- Submarines
				9,	-- Cruisers
				3,	-- Capital	-- A bit less focus on battleships!
				1,	-- Escort Carrier
				2}; 	-- Carrier
			rValue = laArray

		-- The year is at least 1939
		-- Now is the perfect time to work on the Yamato and Musashi!

		elseif year > 1938 then
			local laArray = {		-- Let's build some battleships!
				7,	-- Destroyers
				2,	-- Submarines
				9,	-- Cruisers 
				4,	-- Capital
				1,	-- Escort Carrier 
				2}; 	-- Carrier
			rValue = laArray

		-- We should start building carriers as soon as we can
		-- It might take a while because of all the reconstructions!

		else
			local laArray = {		-- Let's build some carriers!
				7,	-- Destroyers
				3,	-- Submarines
				9,	-- Cruisers
				3,	-- Capital
				1,	-- Escort Carrier
				2}; 	-- Carrier
			rValue = laArray
		end
	end
	
	return rValue
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)

	-- SSmith (12/05/2013)
	-- Make sure we have enough troop ships (was 1:25)

	local laArray = {
		15, -- Land
		1}; -- Transport
	
	return laArray
end

-- Do not build battle cruisers
function P.Build_Battlecruiser(ic, minister, battlecruiser, vbGoOver)
	-- Replace most Battlecruiser request with a Battleship
	local nRandomFactor = math.random(100)
	if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("battleship")) and nRandomFactor > 25 then
		return Utils.CreateDivision_nominor(minister, "battleship", 0, ic, battlecruiser, 1, vbGoOver)
	else
		return ic, 0
	end
end

-- SSmith (21/06/2013)
-- Redundant functions
-- Only build 5 Mountaineers!
--function P.Build_Mountain(ic, minister, bergsjaeger_brigade, vbGoOver)
--	-- Replace Mountaineers wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt(CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"):GetIndex()) + producedUnits:GetAt(CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"):GetIndex()) < 15 then
--		return Utils.CreateDivision_nominor(minister, "bergsjaeger_brigade", 0, ic, bergsjaeger_brigade, 3, vbGoOver)
--	else
--		return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, bergsjaeger_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
--	end
--end

-- Only build 5 Marines!
--function P.Build_Marine(ic, minister, marine_brigade, vbGoOver)
--	-- Replace Marines wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt(CSubUnitDataBase.GetSubUnit("marine_brigade"):GetIndex()) + producedUnits:GetAt(CSubUnitDataBase.GetSubUnit("marine_brigade"):GetIndex()) < 15 then
--		return Utils.CreateDivision_nominor(minister, "marine_brigade", 0, ic, marine_brigade, 3, vbGoOver)
--	else
--		return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, marine_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
--	end
--end

-- Only build 5 Paratroopers!
--function P.Build_Paratrooper(ic, minister, paratrooper_brigade, vbGoOver)
--	-- Replace Paratroopers wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt(CSubUnitDataBase.GetSubUnit("paratrooper_brigade"):GetIndex()) + producedUnits:GetAt(CSubUnitDataBase.GetSubUnit("paratrooper_brigade"):GetIndex()) < 15 then
--		return Utils.CreateDivision_nominor(minister, "paratrooper_brigade", 0, ic, paratrooper_brigade, 3, vbGoOver)
--	else
--		return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, paratrooper_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
--	end
--end

-- Build less support brigades!
function P.Build_Infantry(ic, minister, infantry_brigade, vbGoOver)
	-- When building Infantry, only attach a support brigade 25% of the time!
	if infantry_brigade >= 3 and ic > 2 then
		if math.random(100) > 75 then
			return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, infantry_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
		else
			return Utils.CreateDivision_nominor(minister, "infantry_brigade", 0, ic, infantry_brigade, 3, vbGoOver)
		end
	else
		return ic, 0
	end
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
	
	local chiTag = CCountryDataBase.GetTag('CHI')

	-- SSmith (03/07/2013)
	-- Getting Japan into the Axis is not reliable enough
	-- Let's also try raising threat on the Soviets

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local year = CCurrentGameState.GetCurrentDate():GetYear()
	
	-- raise threat on USA before war (or before 1942 if no war)
	if tostring(TargetCountryTag) == "USA" and year < 1942
	and not ministerCountry:GetRelation(TargetCountryTag):HasWar() then
		return 2

	elseif tostring(TargetCountryTag) == "SOV" and year < 1942
	and not ministerCountry:HasFaction() then
		return 3

	-- target China up to 1940
	elseif tostring(TargetCountryTag) == "CHI" and year < 1940
	and not Support.IsDefeated(ministerTag, chiTag) then
		return 3	
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

	-- SSmith (03/07/2013)
	-- Getting Japan into the Axis is not reliable enough
	-- Let's also try raising threat on the Soviets

	-- SSmith (17/09/2014)
	-- Amended for efficiency

	local year = CCurrentGameState.GetCurrentDate():GetYear()
	
	-- raise threat on USA before war (or before 1942 if no war)
	if tostring(TargetCountryTag) == "USA" and year < 1942
	and not ministerCountry:GetRelation(TargetCountryTag):HasWar() then
		CountryScriptMission = "IncreaseThreat"

	elseif tostring(TargetCountryTag) == "SOV"
	and year > 1938 and year < 1941
	and not ministerCountry:HasFaction() then
		CountryScriptMission = "IncreaseThreat"
	end
	
	return CountryScriptMission	
end

-- End of Intelligence Hooks
-- #######################################
function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local year = agent:GetOwnerAI():GetCurrentDate():GetYear()
	local month = agent:GetOwnerAI():GetCurrentDate():GetMonthOfYear()
	local day = agent:GetOwnerAI():GetCurrentDate():GetDayOfMonth()
	
	local ministerCountry = agent:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local strategy = ministerCountry:GetStrategy()
	local cgxTag = CCountryDataBase.GetTag('CGX')
	local cynTag = CCountryDataBase.GetTag('CYN')
	local vicTag = CCountryDataBase.GetTag('VIC')
	local csxTag = CCountryDataBase.GetTag('CSX')
	local chiTag = CCountryDataBase.GetTag('CHI')
	local chcTag = CCountryDataBase.GetTag('CHC')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local engTag = CCountryDataBase.GetTag('ENG')
	local usaTag = CCountryDataBase.GetTag('USA')

	local lsDecision = decision:GetKey():GetString()

	-- SSmith (23/03/2014)
	-- Add random chances to make decisions more plausible
	-- Add handling for the Hainan concession

	-- SSmith (17/09/2014)
	-- Amended for efficiency
	
	if lsDecision == "independent_mengkukuo" then
		if ( year == 1936 and month >= 4 )	-- '36 May
		or year >= 1937
		then
			score = day * 4
		else
			score = 0
		end	
	elseif lsDecision == "marco_polo_bridge_incident" then

		-- SSmith (10/12/2013)
		-- We will give a small chance of an early Marco Polo and make sure it's not predictable

		score = 0
		if year > 1937 or month > 5 then 					-- From July 1937
			if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
				score = Support.PrepareForWarDecision( ministerTag, chiTag, decision, 2.0 )
			end
		elseif math.mod( CCurrentGameState.GetAIRand(), 300) == 1 then		-- Earlier
			score = Support.PrepareForWarDecision( ministerTag, chiTag, decision, 2.0 )
		end
	elseif lsDecision == "pearl_harbour" then

		-- SSmith (14/12/2013)
		-- The AI can now initiate an attack against the United Kingdom
		-- The Pearl Harbor decision needs to allow for that

		local japIdeologyGroup = ministerCountry:GetRulingIdeology():GetGroup():GetKey()
		local usaIdeologyGroup = usaTag:GetCountry():GetRulingIdeology():GetGroup():GetKey()
		if tostring(usaIdeologyGroup) ~= tostring(japIdeologyGroup)
		and (CCurrentGameState.IsGlobalFlagSet(CString("east_indies_attacked"))
		    or ministerCountry:GetVariables():GetVariable(CString("ai_east_indies")):Get() > 0.5)
		and math.mod( CCurrentGameState.GetAIRand(), 3) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "east_indies_campaign_v1" then
		if ministerCountry:GetSurrenderLevel():Get() < 0.20			-- We aren't beaten too badly yet (we probably own territory in China, too)
		and not ministerCountry:GetRelation(sovTag):HasWar()			-- Peace with the Soviets
		then
			return Support.PrepareForWarDecision( ministerTag, engTag, decision, 1.0 )
		end
		score = 0
	elseif lsDecision == "east_indies_campaign_v2" then
		if ministerCountry:GetSurrenderLevel():Get() < 0.01			-- We haven't lost any ground yet
		and not ministerCountry:GetRelation(sovTag):HasWar()			-- Peace with the Soviets
		and not ministerCountry:GetRelation(chiTag):HasWar()			-- Peace in China
		and not ministerCountry:GetRelation(csxTag):HasWar()
		and not ministerCountry:GetRelation(cgxTag):HasWar()
		and not ministerCountry:GetRelation(chcTag):HasWar()
		then
			return Support.PrepareForWarDecision( ministerTag, engTag, decision, 5.0 )
		end
		score = 0
	elseif lsDecision == "store_fuel" then
		-- Should store fuel while at peace if stockpile is above 10000. No need to have a lot of them gather dust.
		if ministerCountry:GetPool():GetFloat( CGoodsPool._FUEL_ ) > 10000
		then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "restore_fuel" then
		-- Should restore fuel if at war with naval powers and stockpile is below 5000. Otherwise restore if stockpile is below 2000.

		-- SSmith (28/05/2013)
		-- I am removing the generic check for less than 2000 fuel as it defeats the purpose of the fuel stockpile in the first place!

		-- SSmith (02/10/2013)
		-- We will also allow a gradual release of fuel if we are at war with the USSR or the year is 1942

		if ministerCountry:GetPool():GetFloat( CGoodsPool._FUEL_ ) < 5000 then
			if ministerCountry:GetRelation( usaTag ):HasWar() or ministerCountry:GetRelation( engTag ):HasWar() then
				score = 100
			elseif (ministerCountry:GetRelation(sovTag):HasWar() or year > 1941)
			and math.mod( CCurrentGameState.GetAIRand(), 250) == 1 then
				score = 100
			else
				score = 0
			end
		else
			score = 0
		end
	elseif lsDecision == "reconstruct_hiei" or lsDecision == "reconstruct_mogami" or lsDecision == "reconstruct_mikuma" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "recognition_of_mangukuo" then
		if math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "create_ngoc" then
		if math.mod( CCurrentGameState.GetAIRand(), 100) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "give_chinese_territory_to_Jingwei"
	or lsDecision == "give_chinese_territory_and_manchuria_to_Jingwei" or lsDecision == "expand_ngoc"
	or lsDecision == "expand_mengkukuo" or lsDecision == "give_mongolian_territory_to_mengjiang" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "hainan_concession" then
		if ministerCountry:GetPool():GetFloat( CGoodsPool._MONEY_ ) > 2500 and math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end

	-- SSmith (17/10/2014)
	-- Adjusted the Indochina/Siam decisions so they happen more quickly

	elseif lsDecision == "japan_demands_bases_in_indochine" then
		if math.mod( CCurrentGameState.GetAIRand(), 60) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "japan_puts_pressure_on_siam" then
		if math.mod( CCurrentGameState.GetAIRand(), 90) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "mobilize_for_war" then

		-- SSmith (15/04/2014)
		-- We should mobilize for war as soon as we can

		if year > 1936 and math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	end

	return score
end
function P.ProposeDeclareWar( minister )
	local ai = minister:GetOwnerAI()
	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local strategy = ministerCountry:GetStrategy()
	local year = ai:GetCurrentDate():GetYear()
	-- local month = ai:GetCurrentDate():GetMonthOfYear()
	-- local day = ai:GetCurrentDate():GetDayOfMonth()
	-- local axisFaction = CCurrentGameState.GetFaction('axis')
	-- local alliesFaction = CCurrentGameState.GetFaction('allies')

	-- SSmith (19/09/2014)
	-- Amended for efficiency

	-- SSmith (06/05/2013)
	-- New section to handle escalation of the Sino-Japanese War (replaces Japanese events 2730-36)
	-- Not if we are fighting a major enemy (USSR/UK/USA)
	-- We should be at war with Shanxi, Xibei and the Communists anyway
	-- Guangxi and Yunnan should join the Unified Front later
	-- So really this is about Xinjiang and Tibet
	-- And if we are war-weary we might not escalate at all

	-- SSmith (14/09/2013)
	-- We can escalate against the PRC if we have expanded Mengkukuo or annexed Shanxi

	local chiTag = CCountryDataBase.GetTag('CHI')
	local chcTag = CCountryDataBase.GetTag('CHC')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local engTag = CCountryDataBase.GetTag('ENG')
	local usaTag = CCountryDataBase.GetTag('USA')
	local njgTag = CCountryDataBase.GetTag('NJG')
	local menTag = CCountryDataBase.GetTag('MEN')
	local csxTag = CCountryDataBase.GetTag('CSX')
	local cxbTag = CCountryDataBase.GetTag('CXB')
	local cgxTag = CCountryDataBase.GetTag('CGX')
	local cynTag = CCountryDataBase.GetTag('CYN')
	local sikTag = CCountryDataBase.GetTag('SIK')
	local tibTag = CCountryDataBase.GetTag('TIB')

	local chcCountry = chcTag:GetCountry()
	local menCountry = menTag:GetCountry()
	local njgCountry = njgTag:GetCountry()
	local csxCountry = csxTag:GetCountry()
	local cxbCountry = cxbTag:GetCountry()
	local cgxCountry = cgxTag:GetCountry()
	local cynCountry = cynTag:GetCountry()
	local sikCountry = sikTag:GetCountry()
	local tibCountry = tibTag:GetCountry()

	local Diplomacy = {
		chiRelation = ministerCountry:GetRelation(chiTag),
		chcRelation = ministerCountry:GetRelation(chcTag),
		chcHasWar,
		chcExists,
		chcIsDefeated,
		chcIsPreparingWarWith,
		sovHasWar = ministerCountry:GetRelation(sovTag):HasWar(),
		engHasWar = ministerCountry:GetRelation(engTag):HasWar(),
		usaHasWar = ministerCountry:GetRelation(usaTag):HasWar()
	}
	Diplomacy.chcHasWar = Diplomacy.chcRelation:HasWar()
	Diplomacy.chcExists = chcCountry:Exists()
	Diplomacy.chcIsDefeated = Support.IsDefeated(ministerTag,chcTag)
	Diplomacy.chcIsPreparingWarWith = strategy:IsPreparingWarWith(chcTag)
	
	if Diplomacy.chiRelation:GetThreat():Get() > 50 and year < 1938 then
		Support.PrepareForWar( ministerTag, chiTag, 100 )
	end

	if Diplomacy.chcRelation:GetThreat():Get() > 50 and year < 1938 then
		Support.PrepareForWar( ministerTag, chcTag, 100 )
	end

	if not Diplomacy.sovHasWar
	and not Diplomacy.engHasWar
	and not Diplomacy.usaHasWar then

		if Diplomacy.chcExists
		and chcCountry:IsNeighbour(ministerTag)
		and not Diplomacy.chcHasWar
		and not Diplomacy.chcIsDefeated
		and not Diplomacy.chcIsPreparingWarWith then
			Support.PrepareForWar(ministerTag,chcTag,100)
		end

		if menCountry:Exists()
		and menCountry:GetOverlord() == ministerTag
		and menCountry:IsAtWar() then

			if Diplomacy.chcExists
			and chcCountry:IsNeighbour(menTag)
			and not Diplomacy.chcHasWar
			and not Diplomacy.chcIsDefeated
			and not Diplomacy.chcIsPreparingWarWith then
				Support.PrepareForWar(ministerTag,chcTag,100)
			end
		end

		if njgCountry:Exists()
		and njgCountry:GetOverlord() == ministerTag
		and njgCountry:IsAtWar() then

			if Diplomacy.chcExists
			and chcCountry:IsNeighbour(njgTag)
			and not Diplomacy.chcHasWar
			and not Diplomacy.chcIsDefeated
			and not Diplomacy.chcIsPreparingWarWith then
				Support.PrepareForWar(ministerTag,chcTag,100)
			end

			if csxCountry:Exists()
			and csxCountry:IsNeighbour(njgTag)
			and not ministerCountry:GetRelation(csxTag):HasWar()
			and not Support.IsDefeated(ministerTag,csxTag)
			and not strategy:IsPreparingWarWith(csxTag) then
				Support.PrepareForWar(ministerTag,csxTag,100)
			end

			if cxbCountry:Exists()
			and cxbCountry:IsNeighbour(njgTag)
			and not ministerCountry:GetRelation(cxbTag):HasWar()
			and not Support.IsDefeated(ministerTag,cxbTag)
			and not strategy:IsPreparingWarWith(cxbTag) then
				Support.PrepareForWar(ministerTag,cxbTag,100)
			end

			if cgxCountry:Exists()
			and cgxCountry:IsNeighbour(njgTag)
			and not ministerCountry:GetRelation(cgxTag):HasWar()
			and not Support.IsDefeated(ministerTag,cgxTag)
			and not strategy:IsPreparingWarWith(cgxTag) then
				Support.PrepareForWar(ministerTag,cgxTag,100)
			end

			if cynCountry:Exists()
			and cynCountry:IsNeighbour(njgTag)
			and not ministerCountry:GetRelation(cynTag):HasWar()
			and not Support.IsDefeated(ministerTag,cynTag)
			and not strategy:IsPreparingWarWith(cynTag) then
				Support.PrepareForWar(ministerTag,cynTag,100)
			end

			if sikCountry:Exists()
			and Support.IsDefeated(ministerTag,chiTag)
			and sikCountry:IsNeighbour(njgTag)
			and not ministerCountry:GetRelation(sikTag):HasWar()
			and not Support.IsDefeated(ministerTag,sikTag)
			and not strategy:IsPreparingWarWith(sikTag) then
				Support.PrepareForWar(ministerTag,sikTag,100)
			end

			if tibCountry:Exists()
			and Support.IsDefeated(ministerTag,chiTag)
			and tibCountry:IsNeighbour(njgTag)
			and not ministerCountry:GetRelation(tibTag):HasWar()
			and not Support.IsDefeated(ministerTag,tibTag)
			and not strategy:IsPreparingWarWith(tibTag) then
				Support.PrepareForWar(ministerTag,tibTag,100)
			end
		end
	end

	-- SSmith (13/12/2013)
	-- Add war plans against the Allies

	local gerTag = CCountryDataBase.GetTag('GER')
	local fraTag = CCountryDataBase.GetTag('FRA')
	local gerCountry = gerTag:GetCountry()
	local ministerUnits = ministerCountry:GetUnits()
	local ministerPool = ministerCountry:GetPool()

	if ministerCountry:GetRulingIdeology():GetGroup():GetKey():GetString() == "fascism"		-- Only if we are in the fascist ideology group!
	and not ministerCountry:IsSubject()								-- Not if we've been puppeted!
	and not ministerCountry:IsGovernmentInExile()							-- Not if we are in exile!
	and tostring(ministerCountry:GetFaction():GetTag()) ~= "allies"					-- Not if we are in the Allies!
	and (gerCountry:GetRelation(engTag):HasWar() or Support.IsDefeated(gerTag, engTag))		-- Germany is at war with or has defeated Britain!
	and Support.IsDefeated(gerTag, fraTag)								-- Germany has defeated France!
	and ((gerCountry:GetRelation(sovTag):HasWar() 							-- Germany is at war with the Soviets!
	    and sovTag:GetCountry():GetSurrenderLevel():Get() > 0.25)					-- And is winning!
	    or CCurrentGameState.GetProvince(1409):GetOwner() == gerTag)				-- Or Germany owns Moscow!
	and not Diplomacy.sovHasWar									-- Not if we are fighting the Soviets!
	and tostring(chiTag:GetCountry():GetFaction():GetTag()) ~= "axis"				-- Not if China is in the Axis!
	and (Support.IsDefeated(ministerTag,chiTag)							-- We have defeated China!
	    or not Diplomacy.chiRelation:HasWar()							-- Or we are not at war with China!
	    or ministerPool:GetFloat( CGoodsPool._RARE_MATERIALS_ ) < 3000				-- Or we are short of rares!
	    or ministerPool:GetFloat( CGoodsPool._CRUDE_OIL_ ) < 3000)					-- Or we are short of oil!
	and ministerUnits:GetTotalAmountOfDivisions() > 75						-- We have sufficient strength!
	and ministerUnits:GetTotalNumOfWarShips() > 50
	and ministerUnits:GetTotalNumOfTransports() > 10
	and year > 1941											-- Only from 1942
	and math.mod( CCurrentGameState.GetAIRand(), 20) == 1
	then
		-- United Kingdom

		local engIsDefeated = Support.IsDefeated(ministerTag, engTag)

		if not engIsDefeated									-- We haven't defeated the British
		and not gerCountry:GetRelation(engTag):HasAlliance()					-- Germany isn't allied with the British
		and tostring(engTag:GetCountry():GetFaction():GetTag()) ~= "axis"			-- The UK is not in the Axis
		and not strategy:IsPreparingWarWith(engTag)
		and not Diplomacy.engHasWar
		then
			Support.PrepareForWar( ministerTag, engTag, 100 )
			ai:Post(CSetVariableCommand(ministerTag, CString("ai_east_indies"), CFixedPoint(1)))
			--Utils.LUA_DEBUGOUT("ai_east_indies: 1")
		end

		-- United States

		if engIsDefeated									-- We have defeated the British
		and not Support.IsDefeated(ministerTag, usaTag)						-- But not the United States
		and not gerCountry:GetRelation(usaTag):HasAlliance()					-- Germany isn't allied with the United States
		and tostring(usaTag:GetCountry():GetFaction():GetTag()) ~= "axis"			-- The USA is not in the Axis
		and not strategy:IsPreparingWarWith(usaTag)
		and not Diplomacy.usaHasWar
		then
			Support.PrepareForWar( ministerTag, usaTag, 100 )
		end
	end
end

function P.DiploScore_CallAlly(liScore, ai, actor, recipient, observer)
	if observer == recipient then
		local sovTag = CCountryDataBase.GetTag('SOV')
		local chiTag = CCountryDataBase.GetTag('CHI')
		local usaTag = CCountryDataBase.GetTag('USA')

		-- SSmith (24/11/2013)
		-- Also don't join new wars if we're fighting the Soviets!

		-- SSmith (17/09/2014)
		-- Amended for efficiency

		local recipientCountry = recipient:GetCountry()

		-- Don't join a war against the Soviets unless we are done with China!
		if ( actor:GetCountry():GetRelation(sovTag):HasWar()
		and recipientCountry:GetRelation(chiTag):HasWar()
		and not Support.IsDefeated(recipient, chiTag) )

		-- And especially don't join any new wars if we are at war with the Soviets or USA!
		or recipientCountry:GetRelation(sovTag):HasWar()
		or recipientCountry:GetRelation(usaTag):HasWar()
		then
			liScore = 0
		end
	end
	
	return liScore
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	
	if lsActorTag == "SIA" or lsActorTag == "USA" or lsActorTag == "GER" or lsActorTag == "ITA" then
		score = score + 20
	end
	
	return score
end

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local lsRepTag = tostring(recipient)
	
	if lsRepTag == "AUS" or lsRepTag == "CZE" or lsRepTag == "SCH"
	or lsRepTag == "AST" or lsRepTag == "NZL" or lsRepTag == "CAN" or lsRepTag == "SAF"
	then
		score = 0
	elseif lsRepTag == "SIA" then
		score = score + 70
	elseif lsRepTag == "CHI" then
		score = score - 20
	end

	return score
end

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	local chiTag = CCountryDataBase.GetTag('CHI')
	
	if observer == recipient then	-- We are being invited

		-- SSmith (17/09/2014)
		-- Amended for efficiency

		local chiCountry = chiTag:GetCountry()

		if chiCountry:HasFaction()
		and actor:GetCountry():GetFaction() == chiCountry:GetFaction()	-- Don't join the same faction as China!
		or ministerCountry:GetFlags():IsFlagSet("japanese_armistice") then
		then
			score = 0
		end
	end
	
	return score
end

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for Korea

	local laCountryExceptions = { "KOR", "PRK" }
	return laCountryExceptions
end

return AI_JAP
