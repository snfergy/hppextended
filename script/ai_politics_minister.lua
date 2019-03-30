--Reference for the index numbers of laws
--
local _OPEN_SOCIETY_ = 1
local _LIMITED_RESTRICTIONS_ = 2
local _LEGALISTIC_RESTRICTIONS_ = 3
local _REPRESSION_ = 4
local _TOTALITARIAN_SYSTEM_ = 5

local _FREE_PRESS_ = 6
local _CENSORED_PRESS_ = 7
local _STATE_PRESS_ = 8
local _PROPAGANDA_PRESS_ = 9

local _FULL_CIVILIAN_ECONOMY_ = 10
local _BASIC_MOBILISATION_ = 11
local _FULL_MOBILISATION_ = 12
local _WAR_ECONOMY_ = 13
local _TOTAL_ECONOMIC_MOBILISATION_ = 14

local _CONSUMER_PRODUCT_ORIENTATION_ = 15
local _MIXED_INDUSTRY_ = 16
local _HEAVY_INDUSTRY_EMPHASIS_ = 17

local _NEGLIGIBLE_TAXES_ = 18
local _SMALL_TAXES_ = 19
local _ACCEPTABLE_TAXES_ = 20
local _HIGH_TAXES_ = 21
local _EXPLOITIVE_TAXES_ = 22

local _VOLUNTEER_ARMY_ = 23
local _ONE_YEAR_DRAFT_ = 24
local _TWO_YEAR_DRAFT_ = 25
local _THREE_YEAR_DRAFT_ = 26
local _SERVICE_BY_REQUIREMENT_ = 27

local _MINIMAL_TRAINING_ = 28
local _BASIC_TRAINING_ = 29
local _ADVANCED_TRAINING_ = 30
local _SPECIALIST_TRAINING_ = 31

-- SSmith (13/04/2014)
-- Add global parameters for new international status laws

local _UNDEVELOPED_MINOR_ = 32
local _DEVELOPED_MEDIUM_ = 33
local _INDUSTRIAL_MEDIUM_ = 34
local _REGIONAL_POWER_ = 35
local _INTERMEDIATE_POWER_ = 36
local _MAJOR_POWER_ = 37
local _GREAT_POWER_ = 38
local _SUPERPOWER_ = 39

local _HEAD_OF_STATE_ = 1
local _HEAD_OF_GOVERNMENT_ = 2
local _FOREIGN_MINISTER_ = 3
local _ARMAMENT_MINISTER_ = 4
local _MINISTER_OF_SECURITY_ = 5
local _MINISTER_OF_INTELLIGENCE_ = 6
local _CHIEF_OF_STAFF_ = 7
local _CHIEF_OF_ARMY_ = 8
local _CHIEF_OF_NAVY_ = 9
local _CHIEF_OF_AIR_ = 10

local _PRODUCTION_CONSUMER_ = CDistributionSetting._PRODUCTION_CONSUMER_
local _PRODUCTION_SUPPLY_ = CDistributionSetting._PRODUCTION_SUPPLY_
local _PRODUCTION_REINFORCEMENT_ = CDistributionSetting._PRODUCTION_REINFORCEMENT_

local _SPYMISSION_BOOST_RULING_PARTY_ = SpyMission.SPYMISSION_BOOST_RULING_PARTY
local _SPYMISSION_RAISE_NATIONAL_UNITY_ = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY

local _METAL_ = CGoodsPool._METAL_
local _ENERGY_ = CGoodsPool._ENERGY_
local _RARE_MATERIALS_ = CGoodsPool._RARE_MATERIALS_
local _MONEY_ = CGoodsPool._MONEY_


-- SSmith (18/04/2014)
-- New global config tables for minister appointments

local p_IdeologyConfig = {
	national_socialist  = { IdeologyRight = "", 		       IdeologyLeft = "fascistic" },
	fascistic 	    = { IdeologyRight = "national_socialist",  IdeologyLeft = "paternal_autocrat" },
	paternal_autocrat   = { IdeologyRight = "fascistic",           IdeologyLeft = "social_conservative" },
	social_conservative = { IdeologyRight = "paternal_autocrat",   IdeologyLeft = "market_liberal" },
	market_liberal 	    = { IdeologyRight = "social_conservative", IdeologyLeft = "social_liberal" },
	social_liberal 	    = { IdeologyRight = "market_liberal",      IdeologyLeft = "social_democrat" },
	social_democrat     = { IdeologyRight = "social_liberal",      IdeologyLeft = "left_wing_radical" },
	left_wing_radical   = { IdeologyRight = "social_democrat",     IdeologyLeft = "leninist" },
	leninist 	    = { IdeologyRight = "left_wing_radical",   IdeologyLeft = "stalinist" },
	stalinist 	    = { IdeologyRight = "leninist",            IdeologyLeft = "" }
}

local p_IdeologyGroupConfig = {
	fascism   = { Ideology1 = "national_socialist",  Ideology2 = "fascistic",      Ideology3 = "paternal_autocrat", Ideology4 = "" },
	democracy = { Ideology1 = "social_conservative", Ideology2 = "market_liberal", Ideology3 = "social_liberal", 	Ideology4 = "social_democrat" },
	communism = { Ideology1 = "left_wing_radical",   Ideology2 = "leninist",       Ideology3 = "stalinist", 	Ideology4 = "" }
}


-- ###################################
-- # Main Method called by the EXE
-- ###################################

function PoliticsMinister_Tick( minister )
	
	if not ( Utils.ASSERT( minister ) )
	then
		return
	end

	-- SSmith (29/04/2014)
	-- Check laws and ministers every two weeks (was daily!)

	if math.mod( CCurrentGameState.GetAIRand(), 14) == 0 then
		HPP_Laws( minister )
	end
	if math.mod( CCurrentGameState.GetAIRand(), 14) == 0 then
		OfficeManagement( minister )
	end

	-- SSmith (21/11/2013)
	-- Puppets and liberations don't need to be checked so often

	if math.mod( CCurrentGameState.GetAIRand(), 7) == 0 then
		Mobilization( minister )
	elseif math.mod( CCurrentGameState.GetAIRand(), 14) == 0 then
		local ministerTag = minister:GetCountryTag()
		local ministerCountry = minister:GetCountry()
		Puppets( minister, ministerTag, ministerCountry )
		Liberation( minister:GetOwnerAI(), minister, ministerTag, ministerCountry )
	end
end

-- #####################
-- # Puppets
-- #####################

function Puppets(minister, ministerTag, ministerCountry)
	
	if not ( Utils.ASSERT( minister ) )
	or not ( Utils.ASSERT( ministerTag ) )
	or not ( Utils.ASSERT( ministerCountry ) )
	then
		return
	end
	
	-- SSmith (21/11/2013)
	-- Re-written to allow puppets to be created more freely by democratic/communist governments
	-- At this point I'm still not allowing fascist regimes to release puppets

	if ministerCountry:CanCreatePuppet() and not ministerCountry:IsSubject() then

		-- Certain unlikely countries could cause problems if they started releasing puppets!
		-- So we will just exit the function now and ignore them!

		local ministerTagString = tostring(ministerTag)
		local laIgnoreList = { "DDR", "DFR", "RUS", "RSI", "IND", "KOR", "PRK", "SER", "SPR", "SPA" }
		local lbIgnore = false

		local tagString = "XXX"
		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("")
			Utils.LUA_DEBUGOUT("Checking puppets: " .. tagString)
		end

		for i = 1, table.getn(laIgnoreList) do
			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("Ignoring: " .. laIgnoreList[i])
			end
			if laIgnoreList[i] == ministerTagString then
				lbIgnore = true
				break
			end
		end
		if lbIgnore then
			return
		end

		-- These countries will never be released as puppets
		local laGlobalExceptions = { "ICL", "SCO", "SLO", "ISR", "CGX", "CSX", "CXB", "CYN", "MAN", "MEN", "SIK",
			"CRO", "SER", "BOS", "MAC", "MTN", "SLV", "CAL", "CSA", "SIU", "SIB" }

		-- These countries will not be released by incompatible ideologies
		local laIdeologyExceptions = { }
		local ministerIdeologyGroup = ministerCountry:GetRulingIdeology():GetGroup():GetKey():GetString()
		if ministerIdeologyGroup == "democracy" then
			laIdeologyExceptions = { "GER", "DDR", "SOV", "ITA", "VIC", "SPA", "PRK", "CHC", "NJG" }
		elseif ministerIdeologyGroup == "communism" then
			laIdeologyExceptions = { "GER", "DFR", "ITA", "VIC", "SPA", "KOR", "CHI", "NJG" }
		elseif ministerIdeologyGroup == "fascism" then
			laIdeologyExceptions = { "DDR", "DFR", "SOV", "FRA", "RSI", "SPR", "PRK", "CHC", "NJG" }
			-- For now the fascist ideology group will not release puppets
			return
		end

		-- Call the country-specific AI function for any custom exceptions
		local laCountryExceptions = { }
		if Utils.HasCountryAIFunction( ministerTag, 'HandlePuppets' ) then
			-- Note the called function must return at least 2 elements to be recognised as a list!
			laCountryExceptions = Utils.CallCountryAI( ministerTag, "HandlePuppets", minister )
		end

		local ai = minister:GetOwnerAI()
		for puppetTag in ministerCountry:GetPossiblePuppets() do

			-- Check this puppet is not listed as an exception

			local puppetTagString = tostring(puppetTag)
			local lbOK = true

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("Puppeting: " .. puppetTagString)
			end

			-- Check global exceptions
			for i = 1, table.getn(laGlobalExceptions) do
				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("Global exceptions: " .. laGlobalExceptions[i])
				end
				if laGlobalExceptions[i] == puppetTagString then
					lbOK = false
					break
				end
			end

			if lbOK then
				-- Check ideology exceptions
				for i = 1, table.getn(laIdeologyExceptions) do
					if ministerTagString == tagString then
						Utils.LUA_DEBUGOUT("Ideology exceptions: " .. laIdeologyExceptions[i])
					end
					if laIdeologyExceptions[i] == puppetTagString then
						lbOK = false
						break
					end
				end

				if lbOK then
					-- Check country exceptions
					for i = 1, table.getn(laCountryExceptions) do
						if ministerTagString == tagString then
							Utils.LUA_DEBUGOUT("Country exceptions: " .. laCountryExceptions[i])
						end
						if laCountryExceptions[i] == puppetTagString then
							lbOK = false
							break
						end
					end

					if lbOK then

						-- SSmith (20/11/2013)
						-- Reversed the order of the tags!

						local command = CCreateVassalCommand( puppetTag, ministerTag )
						ai:Post( command)
					end
				end
			end
		end
	end
end

-- #####################
-- # Liberation
-- #####################

function Liberation( ai, minister, ministerTag, ministerCountry )
	
	if not ( Utils.ASSERT( ai ) )
	or not ( Utils.ASSERT( minister ) )
	or not ( Utils.ASSERT( ministerTag ) )
	or not ( Utils.ASSERT( ministerCountry ) )
	then
		return
	end
	
	-- liberate countries if we can
    	if ministerCountry:MayLiberateCountries() then
        	for loMember in ministerCountry:GetPossibleLiberations() do

			-- SSmith (22/09/2013)
			-- The "is capital safe" check doesn't always work for countries with overseas territories
			-- So we will rely on the support function only

	            	--if minister:IsCapitalSafeToLiberate( loMember ) and 
		 	if Support.ShouldLiberateCountry( ministerTag, loMember ) then
               			ai:Post( CLiberateCountryCommand( loMember, ministerTag ) )
            		end
        	end
	end	
end

-- #####################
-- # Mobilization
-- #####################

function Mobilization( minister )
	
	if not ( Utils.ASSERT( minister ) )
	then
		return
	end
	
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local ai = minister:GetOwnerAI()
	
	if ministerCountry:IsAtWar() then
		-- No need to consider anything, we can't demobilize anyway.
		return
	end

	local tagstring = "XXX"
	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Mobilization: " .. tostring(ministerTag))
		Utils.LUA_DEBUGOUT("IC: " .. tostring(ministerCountry:GetTotalIC() * 0.25))
		Utils.LUA_DEBUGOUT("CG: " .. tostring(ministerCountry:GetProductionDistributionAt( _PRODUCTION_CONSUMER_ ):GetNeeded():Get()))
	end

	-- SSmith (27/04/2013)
	-- The check for high consumer goods demand has been moved further down this function
	-- It no longer exits the function because it shouldn't!  The code must continue or it won't be able to de-mobilize!
	-- For the sake of efficiency calculate some values here that will be re-used

	-- SSmith (07/09/2014)
	-- Amended for efficiency
	
	local need_mobilization = false
	local isMobilized = ministerCountry:IsMobilized()
	local totalIC = ministerCountry:GetTotalIC()
	local dissent = ministerCountry:GetDissent():Get()
	local hasFaction = ministerCountry:HasFaction()
	
	if hasFaction or ministerCountry:GetNumOfAllies() > 0 then
	-- We have allies who may be at war. If so, then we can be called in at any moment, so let's mobilize!
		local hasFightingAlly = false

		for allyTag in ministerCountry:GetAllies() do
			local allyCountry = allyTag:GetCountry()
			if allyCountry:IsAtWar() then
				for enemyTag in allyCountry:GetCurrentAtWarWith() do
					if enemyTag:GetCountry():GetTotalIC() > totalIC then
						hasFightingAlly = true
						break
					end
				end
			end
		end
		if hasFaction then	-- Only check the faction if we have one!
			for factionBuddyTag in ministerCountry:GetFaction():GetMembers() do
				local factionBuddyCountry = factionBuddyTag:GetCountry()
				if factionBuddyCountry:IsAtWar() then
					for enemyTag in factionBuddyCountry:GetCurrentAtWarWith() do
						if enemyTag:GetCountry():GetTotalIC() > totalIC then
							hasFightingAlly = true
							break
						end
					end
				end
			end
		end
		
		if hasFightingAlly then	-- If one of our buddies is fighting someone stronger than us, then we should mobilize!
			need_mobilization = true
		end
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Allies: " .. tostring(need_mobilization))
	end

	-- Note: we are automatically mobilized when war breaks out, so this is for kicking off mobilization early.
	if ministerCountry:GetStrategy():IsPreparingWar() then
		need_mobilization = true

		if tostring(ministerTag) == tagstring then
			Utils.LUA_DEBUGOUT("Preparing for war")
		end

	elseif not need_mobilization then

		-- SSmith (27/04/2013)
		-- For efficiency we will only run this code if we haven't yet decided to mobilize
		-- Strength will now be calculated using a new support function so we get sensible and consistent results

		-- check if a neighbor is starting to look threatening
		local neutrality = ministerCountry:GetNeutrality():Get()
		for neighborTag in ministerCountry:GetNeighbours() do
			local threat = ministerCountry:GetRelation( neighborTag ):GetThreat():Get()
			local laParams = {
				MinisterTag = ministerTag,
				TargetTag = neighborTag
			}
			local strength = Support.CompareEstimatedMilitaryStrength( laParams )

			if tostring(ministerTag) == tagstring then
				Utils.LUA_DEBUGOUT("Threat: " .. tostring(neighborTag) .. ": " .. tostring(threat))
				Utils.LUA_DEBUGOUT("Strength: " .. tostring(neighborTag) .. ": " .. tostring(strength))
			end

			-- SSmith (27/04/2013)
			-- This used to dismiss threat if we think we are 1.5 times as strong as the other country
			-- Now it will scale our reponse according to our relative strength
			-- It will also increase threat a little if we are mobilized to discourage us from de-mobilizing arbitrarily

			-- We should play it safer and consider if the threat is mobilized or not
			-- Then again mobilizing can really cripple the economy!!
			--if neighborTag:GetCountry():IsMobilized() or neighborTag:GetCountry():IsAtWar() then
			--	threat = threat + 20
			--end
			if strength > 5 then
				threat = threat - 20
			elseif strength > 3 then
				threat = threat - 15
			elseif strength > 2 then
				threat = threat - 10
			elseif strength > 1.5 then
				threat = threat - 5
			end
			if isMobilized then
				threat = threat + 5
			end

			local ministerRelation = ministerCountry:GetRelation( neighborTag )

			if ( neutrality < threat or neighborTag:GetCountry():GetNeutrality():Get() < threat )
			and ( not ministerRelation:HasTruce() )	-- Don't worry if we have a truce or NAP
			and ( not ministerRelation:HasNap() )
			and ( not ministerCountry:CalculateIsAllied( neighborTag ) )
			then

				if tostring(ministerTag) == tagstring then
					Utils.LUA_DEBUGOUT("Threat: " .. tostring(neighborTag) .. ": " .. tostring(threat))
					Utils.LUA_DEBUGOUT("Strength: " .. tostring(strength))
					Utils.LUA_DEBUGOUT("Our Neutrality: " .. tostring(neutrality))
					Utils.LUA_DEBUGOUT("Their Neutrality: " .. tostring(neighborTag:GetCountry():GetNeutrality():Get()))
				end

				need_mobilization = true
			end
		end
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Threat: " .. tostring(need_mobilization))
	end

	-- SSmith (26/04/2013)
	-- I thought about removing this but on second thoughts it may help prevent unwise mobilizations!

	if need_mobilization and not isMobilized then
		local currentNeutrality = ministerCountry:GetNeutrality():Get() * 0.01
		currentNeutrality = currentNeutrality * currentNeutrality		-- The square of a number lower than 1 is lower than the number.
		-- Check for Neutrality! If it is too high, then maybe we shouldn't do this, because Mobilization is very costly!
		local random_factor = ( math.random() * 0.5 ) + 0.5				-- Random real number between 0.5 and 1.
		if random_factor * currentNeutrality > 0.5 then
			need_mobilization = false
		end
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Neutrality: " .. tostring(need_mobilization))
	end

	-- SSmith (25/04/2013)
	-- It seems that the consumer goods check is of paramount importance
	-- So the country-specific check is being moved here to be evaluated first

	if Utils.HasCountryAIFunction( ministerTag, 'HandleMobilization' ) then

		if tostring(ministerTag) == tagstring then
			Utils.LUA_DEBUGOUT("Calling AI...")
		end

		need_mobilization = Utils.CallCountryAI( ministerTag, "HandleMobilization", minister, need_mobilization )
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Country: " .. tostring(need_mobilization))
	end

	-- SSmith (23/04/2013)
	-- The consumer goods check has been moved here
	-- It will reset the mobilization flag to false unless we are already mobilized
	-- I want this to persuade us against mobilizing but not to de-mobilize us!

	if totalIC * 0.25 < ministerCountry:GetProductionDistributionAt( _PRODUCTION_CONSUMER_ ):GetNeeded():Get()
	and not isMobilized then
		-- We are spending at least 25% of our IC on Consumer Goods and we are not mobilized
		need_mobilization = false
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Consumer: " .. tostring(need_mobilization))
	end
	
	-- SSmith (15/06/2013)
	-- These is a new safeguard to check for dissent
	-- If dissent is high then the mobilization flag will be cleared so that we can deal with the dissent
	-- If any dissent exists then the mobilization flag will be cleared unless we are already mobilized
	
	if dissent > 10 then
		need_mobilization = false
	elseif dissent > 0.01 and not isMobilized then
		need_mobilization = false
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Dissent: " .. tostring(dissent))
		Utils.LUA_DEBUGOUT("Dissent: " .. tostring(need_mobilization))
	end

	-- SSmith (23/04/2013)
	-- I am putting some longer term debugging in here so I can check how the AI is using this function

	if need_mobilization and not isMobilized then

		--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. " has mobilized")

		local command = CToggleMobilizationCommand( ministerTag, true )
		ai:Post( command )
	elseif not need_mobilization and isMobilized then

		--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. " has de-mobilized")

		local command = CToggleMobilizationCommand( ministerTag, false )
		ai:Post( command )
	end
end

-- #####################
-- # Laws
-- #####################

function Laws( minister )
	return
end

function HPP_Laws( minister )
	
	if not ( Utils.ASSERT( minister ) )
	then
		return
	end
	
	-- SSmith (02/05/2014)
	-- Amended to check every law on each pass

	-- SSmith (24/03/2015)
	-- Remove country-specific AI calls

	local Work = {
		MinisterCountry = minister:GetCountry(),
		MinisterTag = minister:GetCountryTag(),
		AI = minister:GetOwnerAI()
	}
	
	for loGroup in CLawDataBase.GetGroups() do

		local Law = {
			GroupName = tostring(loGroup:GetKey()),
			CurrentLaw = Work.MinisterCountry:GetLaw(loGroup),
			NewLaw = nil
		}

		local fnParams = {
			MinisterTag = Work.MinisterTag,
			MinisterCountry = Work.MinisterCountry,
			CurrentLaw = Law.CurrentLaw
		}

	--	local lsMethodCall = "CallLaw_" .. Law.GroupName	
	--	if Utils.HasCountryAIFunction( Work.MinisterTag, lsMethodCall) then
	--		Law.NewLaw = Utils.CallCountryAI( Work.MinisterTag, lsMethodCall, minister, Law.CurrentLaw )

		if Law.GroupName == "civil_law" then

			Law.NewLaw = CivilLaw( fnParams )

		elseif Law.GroupName == "press_laws" then

			Law.NewLaw = PressLaws( fnParams )

		elseif Law.GroupName == "economic_law" then

			Law.NewLaw = EconomicLaw( fnParams )

		elseif Law.GroupName == "industrial_policy_laws" then

			Law.NewLaw = IndustrialPolicies( fnParams )

		elseif Law.GroupName == "taxation_law" then

			Law.NewLaw = TaxationLaw( fnParams )

		elseif Law.GroupName == "conscription_law" then

			Law.NewLaw = ConscriptionLaw( fnParams )

		elseif Law.GroupName == "training_laws" then

			Law.NewLaw = TrainingLaws( fnParams )

		elseif Law.GroupName == "international_status" then

			Law.NewLaw = InternationalStatus( fnParams )
		end

		-- SSmith (24/03/2014)
		-- The law should already be checked for validity

		-- Execute the new law
		if not( Law.NewLaw == nil ) then
		--	local tagstring = tostring(Work.MinisterTag)
		--	if tagstring == "ENG" or tagstring == "FRA" or tagstring == "GER" or tagstring == "ITA" or tagstring == "USA"
		--	or tagstring == "JAP" or tagstring == "SOV" or tagstring == "CHI" or tagstring == "VIC" or tagstring == "CHC"
		--	or tagstring == "CGX" or tagstring == "SPR" or tagstring == "SPA" or tagstring == "BRA" or tagstring == "ARG"
		--	or tagstring == "MEX" or tagstring == "CAN" or tagstring == "AST" or tagstring == "IND" or tagstring == "MAN"
		--	or tagstring == "NJG" or tagstring == "HOL" or tagstring == "ROM" or tagstring == "HUN" or tagstring == "POL"
		--	or tagstring == "CZE" or tagstring == "FIN" or tagstring == "TUR" or tagstring == "YUG"
		--	then
		--		Utils.LUA_DEBUGOUT(tagstring .. ": " .. Law.GroupName .. ": " .. Law.NewLaw:GetKey():GetString())
		--	end
			Work.AI:Post( CChangeLawCommand( Work.MinisterTag, Law.NewLaw, loGroup ) )
		end

	--	-- Execute the new law
	--	if not( Law.NewLaw == nil ) then
	--		if not( Law.NewLaw:GetIndex() == Law.CurrentLaw:GetIndex() ) then
	--			if Law.NewLaw:ValidFor( Work.MinisterTag ) then
	--				Work.AI:Post( CChangeLawCommand( Work.MinisterTag, Law.NewLaw, loGroup ) )
	--			end
	--		end
	--	end
	end
end

-- ####################
-- # Law sub-methods
-- ####################

function CivilLaw( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.MinisterCountry ) )
	or ( not Utils.ASSERT( Params.CurrentLaw ) )
	then
		return nil
	end

	-- SSmith (24/03/2015)
	-- Re-write to use new functions

	local Work = {
		CurrentIndex = Params.CurrentLaw:GetIndex(),
		Ideology = Params.MinisterCountry:GetRulingIdeology(),
		IdeologyString,
		IdeologyGroup,
		IsAtWar = Params.MinisterCountry:IsAtWar()
	}
	Work.IdeologyGroup = Work.Ideology:GetGroup():GetKey():GetString()

	local fnParams = {
		MinisterTag = Params.MinisterTag,
		StartIndex,
		EndIndex,
		CurrentIndex = Work.CurrentIndex
	}

	if Work.IdeologyGroup == "democracy" then

		if Work.IsAtWar then

			-- Democracies at war aim for Legalistic Restrictions

			fnParams.StartIndex = _LEGALISTIC_RESTRICTIONS_
			fnParams.EndIndex = _OPEN_SOCIETY_

			if Work.CurrentIndex > fnParams.StartIndex then
				fnParams.CurrentIndex = 0
			end

			return GetHighestLaw( fnParams )
		else
			-- Democracies at peace switch back to Open Society

			fnParams.StartIndex = _OPEN_SOCIETY_
			fnParams.EndIndex = _LEGALISTIC_RESTRICTIONS_

			return GetLowestLaw( fnParams )
		end
	else
		-- Autocracies always aim for the highest laws

		fnParams.StartIndex = _TOTALITARIAN_SYSTEM_
		fnParams.EndIndex = _LIMITED_RESTRICTIONS_

		Work.IdeologyString = Work.Ideology:GetKey():GetString()

		if (Work.IdeologyString == "paternal_autocrat" or Work.IdeologyString == "left_wing_radical")
		and not Work.IsAtWar then
		
			-- Moderate autocracies at peace pull back from Totalitarian System

			fnParams.StartIndex = _REPRESSION_

			if Work.CurrentIndex > fnParams.StartIndex then
				fnParams.CurrentIndex = 0
			end
		end

		return GetHighestLaw( fnParams )
	end
end

function PressLaws( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.MinisterCountry ) )
	or ( not Utils.ASSERT( Params.CurrentLaw ) )
	then
		return nil
	end

	-- SSmith (26/03/2015)
	-- Re-write to use new functions

	local Work = {
		CurrentIndex = Params.CurrentLaw:GetIndex(),
		IdeologyGroup = Params.MinisterCountry:GetRulingIdeology():GetGroup():GetKey():GetString(),
		IsAtWar = Params.MinisterCountry:IsAtWar()
	}

	local fnParams = {
		MinisterTag = Params.MinisterTag,
		StartIndex,
		EndIndex,
		CurrentIndex = Work.CurrentIndex
	}

	if Work.IdeologyGroup == "democracy" then

		if Work.IsAtWar then

			-- Democracies at war aim for Censored Press

			fnParams.StartIndex = _CENSORED_PRESS_
			fnParams.EndIndex = _FREE_PRESS_

			if Work.CurrentIndex > fnParams.StartIndex then
				fnParams.CurrentIndex = 0
			end

			return GetHighestLaw( fnParams )
		else
			-- Democracies at peace switch back to Free Press

			fnParams.StartIndex = _FREE_PRESS_
			fnParams.EndIndex = _CENSORED_PRESS_

			return GetLowestLaw( fnParams )
		end
	else
		-- Autocracies always aim for the highest laws

		fnParams.StartIndex = _PROPAGANDA_PRESS_
		fnParams.EndIndex = _CENSORED_PRESS_

		return GetHighestLaw( fnParams )
	end
end

function EconomicLaw( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.MinisterCountry ) )
	or ( not Utils.ASSERT( Params.CurrentLaw ) )
	then
		return nil
	end

	-- SSmith (26/03/2015)
	-- Re-write to use new functions

	local Work = {
		CurrentIndex = Params.CurrentLaw:GetIndex(),
		NewLaw = nil,
		NewIndex = 0,
		IdeologyGroup = Params.MinisterCountry:GetRulingIdeology():GetGroup():GetKey():GetString(),
		IsAtWar = Params.MinisterCountry:IsAtWar()
	}

	local fnParams = {
		MinisterTag = Params.MinisterTag,
		StartIndex = _TOTAL_ECONOMIC_MOBILISATION_,
		EndIndex = _FULL_CIVILIAN_ECONOMY_,
		CurrentIndex = Work.CurrentIndex
	}

	-- Find the highest possible economic law we can use

	if not Work.IsAtWar then
		if Work.IdeologyGroup == "democracy" then
			fnParams.StartIndex = _FULL_MOBILISATION_
		else
			fnParams.StartIndex = _WAR_ECONOMY_
		end
	end

	Work.NewLaw = GetHighestLaw( fnParams )
	if Work.NewLaw == nil then
		Work.NewLaw = Params.CurrentLaw
		Work.NewIndex = Work.CurrentIndex
	else
		Work.NewIndex = Work.NewLaw:GetIndex()
		if Work.NewIndex < Work.CurrentIndex and not Work.CurrentIndex > fnParams.StartIndex then
			Work.NewLaw = Params.CurrentLaw
			Work.NewIndex = Work.CurrentIndex
		end
	end

	if Work.NewIndex > _FULL_MOBILISATION_ then

		-- SSmith (27/03/2015)
		-- We will calculate our resource requirements based on our current stockpiles
		-- We need to know when we can expand our production and when we must cut back to conserve resources
		-- The AI will now be allowed to use Total Economic Mobilisation

		local Temp = {
			GoodsPool = Params.MinisterCountry:GetPool(),
			CurrentStockpile = 0,
			IdealStockpile = 0,
			Ratio = 1,
			MaxResources = true,
			AvgResources = true,
			MinResources = true
		}

		-- Energy

		Temp.CurrentStockpile = Temp.GoodsPool:Get(_ENERGY_):Get()
		Temp.IdealStockpile = Support.GetEffectiveResourceLimit(Params.MinisterCountry, _ENERGY_)
		Temp.Ratio = Temp.CurrentStockpile / Temp.IdealStockpile

		if Temp.Ratio < 0.40 then
			Temp.MaxResources = false
		end
		if Temp.Ratio < 0.25 then
			Temp.AvgResources = false
		end
		if Temp.Ratio < 0.10 then
			Temp.MinResources = false
		end

		-- Metals

		Temp.CurrentStockpile = Temp.GoodsPool:Get(_METAL_):Get()
		Temp.IdealStockpile = Support.GetEffectiveResourceLimit(Params.MinisterCountry, _METAL_)
		Temp.Ratio = Temp.CurrentStockpile / Temp.IdealStockpile

		if Temp.Ratio < 0.40 then
			Temp.MaxResources = false
		end
		if Temp.Ratio < 0.25 then
			Temp.AvgResources = false
		end
		if Temp.Ratio < 0.10 then
			Temp.MinResources = false
		end

		-- Rares

		Temp.CurrentStockpile = Temp.GoodsPool:Get(_RARE_MATERIALS_):Get()
		Temp.IdealStockpile = Support.GetEffectiveResourceLimit(Params.MinisterCountry, _RARE_MATERIALS_)
		Temp.Ratio = Temp.CurrentStockpile / Temp.IdealStockpile

		if Temp.Ratio < 0.40 then
			Temp.MaxResources = false
		end
		if Temp.Ratio < 0.25 then
			Temp.AvgResources = false
		end
		if Temp.Ratio < 0.10 then
			Temp.MinResources = false
		end

		-- Select the new law based on resource availability

		if Work.CurrentIndex < _WAR_ECONOMY_ then

			if Temp.AvgResources then		-- War Economy

				Work.NewLaw = CLawDataBase.GetLaw( _WAR_ECONOMY_ )
				Work.NewIndex = _WAR_ECONOMY_

			else					-- Full Mobilisation

				Work.NewLaw = CLawDataBase.GetLaw( _FULL_MOBILISATION_ )
				Work.NewIndex = _FULL_MOBILISATION_
			end

		elseif Work.CurrentIndex == _WAR_ECONOMY_ then

			if not Temp.MinResources then 		-- Full Mobilisation

				Work.NewLaw = CLawDataBase.GetLaw( _FULL_MOBILISATION_ )
				Work.NewIndex = _FULL_MOBILISATION_

			elseif not Temp.MaxResources then	-- War Economy

				Work.NewLaw = Params.CurrentLaw
				Work.NewIndex = Work.CurrentIndex
			end

		elseif Work.CurrentIndex == _TOTAL_ECONOMIC_MOBILISATION_ then

			if not Temp.AvgResources then		-- War Economy

				Work.NewLaw = CLawDataBase.GetLaw( _WAR_ECONOMY_ )
				Work.NewIndex = _WAR_ECONOMY_
			end
		end

		if tostring(Params.MinisterTag) == "GER" then

			-- Reduce output to conserve rares if Germany is fighting the Soviets

			local sovTag = CCountryDataBase.GetTag('SOV')
			if Params.MinisterCountry:GetRelation(sovTag):HasWar()
			and Temp.CurrentStockpile < 20000 then

				Work.NewLaw = CLawDataBase.GetLaw( _FULL_MOBILISATION_ )
				Work.NewIndex = _FULL_MOBILISATION_
			end
		end
	end

	if Work.NewIndex ~= Work.CurrentIndex then
		return Work.NewLaw
	else
		return nil
	end
end

function IndustrialPolicies( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.MinisterCountry ) )
	or ( not Utils.ASSERT( Params.CurrentLaw ) )
	then
		return nil
	end

	-- SSmith (31/03/2015)
	-- Re-write to use new functions

	local Work = {
		CurrentIndex = Params.CurrentLaw:GetIndex(),
		Ideology = Params.MinisterCountry:GetRulingIdeology(),
		IdeologyString,
		IdeologyGroup,
		IsAtWar = Params.MinisterCountry:IsAtWar()
	}
	Work.IdeologyString = Work.Ideology:GetKey():GetString()
	Work.IdeologyGroup = Work.Ideology:GetGroup():GetKey():GetString()

	local fnParams = {
		MinisterTag = Params.MinisterTag,
		StartIndex,
		EndIndex,
		CurrentIndex = Work.CurrentIndex
	}

	if Work.IsAtWar then

		-- When at war use the highest law available

		fnParams.StartIndex = _HEAVY_INDUSTRY_EMPHASIS_
		fnParams.EndIndex = _MIXED_INDUSTRY_
		return GetHighestLaw( fnParams )

	elseif Work.IdeologyGroup == "democracy"
	and not Work.Ideology == "social_democrat" then

		-- Democratic ideologies except for social democrats aim for consumer focus

		fnParams.StartIndex = _CONSUMER_PRODUCT_ORIENTATION_
		fnParams.EndIndex = _MIXED_INDUSTRY_
		return GetLowestLaw( fnParams )

	elseif not Work.IdeologyGroup == "communism" then

		-- Fascist ideologies and social democrats aim for mixed industry

		fnParams.StartIndex = _MIXED_INDUSTRY_
		fnParams.EndIndex = _CONSUMER_PRODUCT_ORIENTATION_

		if Work.CurrentIndex > fnParams.StartIndex then
			fnParams.CurrentIndex = 0
		end

		return GetHighestLaw( fnParams )
	else
		-- Communist ideologies will aim for heavy industry if they have 150 IC

		fnParams.StartIndex = _MIXED_INDUSTRY_
		if Params.MinisterCountry:GetTotalIC() > 150 then
			fnParams.StartIndex = _HEAVY_INDUSTRY_EMPHASIS_
		end
		fnParams.EndIndex = _MIXED_INDUSTRY_
		return GetHighestLaw( fnParams )
	end
end

function TaxationLaw( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.MinisterCountry ) )
	or ( not Utils.ASSERT( Params.CurrentLaw ) )
	then
		return nil
	end

	-- SSmith (02/04/2015)
	-- Re-write to use new functions

	local Work = {
		CurrentIndex = Params.CurrentLaw:GetIndex(),
		Ideology = Params.MinisterCountry:GetRulingIdeology(),
		IdeologyString,
		IdeologyGroup,
		NewIndex = 0,
		NewLaw = nil
	}
	Work.IdeologyString = Work.Ideology:GetKey():GetString()
	Work.IdeologyGroup = Work.Ideology:GetGroup():GetKey():GetString()

	local fnParams = {
		MinisterTag = Params.MinisterTag,
		StartIndex,
		EndIndex,
		CurrentIndex = Work.CurrentIndex
	}

	-- SSmith (02/04/2015)
	-- We will calculate our financial situation based on our current stockpiles

	local Temp = {
		GoodsPool = Params.MinisterCountry:GetPool(),
		CurrentStockpile = 0,
		IdealStockpile = 0,
		Ratio = 1		
	}

	Temp.CurrentStockpile = Temp.GoodsPool:Get(_MONEY_):Get()
	Temp.IdealStockpile = Support.GetEffectiveResourceLimit(Params.MinisterCountry, _MONEY_)
	Temp.Ratio = Temp.CurrentStockpile / Temp.IdealStockpile

	-- We can now adjust our preferred tax law based on our financial circumstances

	Work.NewIndex = Work.CurrentIndex

	if Temp.Ratio < 0.25 and Work.CurrentIndex < _EXPLOITIVE_TAXES_ then
		Work.NewIndex = _EXPLOITIVE_TAXES_
	elseif Temp.Ratio < 0.50 and Work.CurrentIndex < _HIGH_TAXES_ then
		Work.NewIndex = _HIGH_TAXES_
	elseif Temp.Ratio < 1.50 and Work.CurrentIndex < _ACCEPTABLE_TAXES_ then
		Work.NewIndex = _ACCEPTABLE_TAXES_
	elseif Temp.Ratio < 2.50 and Work.CurrentIndex < _SMALL_TAXES_ then
		Work.NewIndex = _SMALL_TAXES_
	end

	if Temp.Ratio > 3.00 and Work.CurrentIndex > _NEGLIGIBLE_TAXES_ then
		Work.NewIndex = _NEGLIGIBLE_TAXES_
	elseif Temp.Ratio > 1.75 and Work.CurrentIndex > _SMALL_TAXES_ then
		Work.NewIndex = _SMALL_TAXES_
	elseif Temp.Ratio > 0.65 and Work.CurrentIndex > _ACCEPTABLE_TAXES_ then
		Work.NewIndex = _ACCEPTABLE_TAXES_
	elseif Temp.Ratio > 0.35 and Work.CurrentIndex > _HIGH_TAXES_ then
		Work.NewIndex = _HIGH_TAXES_
	end

	-- Now we reconcile our financial preferences with our ideology

	local fnParams = {
		MinisterTag = Params.MinisterTag,
		StartIndex,
		EndIndex,
		CurrentIndex = Work.CurrentIndex
	}

	if Work.IdeologyGroup == "democracy"
	and Work.IdeologyString ~= "social_democrat" then

		-- Social conservatives and liberals

		if Work.NewIndex < _ACCEPTABLE_TAXES_ then

			Work.NewLaw = CLawDataBase.GetLaw( Work.NewIndex )

		elseif Work.NewIndex == _ACCEPTABLE_TAXES_ then

			fnParams.StartIndex = _ACCEPTABLE_TAXES_
			fnParams.EndIndex = _SMALL_TAXES_

			if Work.CurrentIndex > fnParams.StartIndex then
				fnParams.CurrentIndex = 0
			end

			return GetHighestLaw( fnParams )

		elseif Work.NewIndex > _ACCEPTABLE_TAXES_ then

			fnParams.StartIndex = _HIGH_TAXES_
			fnParams.EndIndex = _SMALL_TAXES_

			if Work.CurrentIndex > fnParams.StartIndex then
				fnParams.CurrentIndex = 0
			end

			return GetHighestLaw( fnParams )
		end
	else
		-- Autocrats and social democrats

		if Work.NewIndex < _ACCEPTABLE_TAXES_ then

			fnParams.StartIndex = _SMALL_TAXES_
			fnParams.EndIndex = _HIGH_TAXES_

			if Work.CurrentIndex < fnParams.StartIndex then
				fnParams.CurrentIndex = 99
			end

			return GetLowestLaw( fnParams )

		elseif Work.NewIndex == _ACCEPTABLE_TAXES_ then

			fnParams.StartIndex = _ACCEPTABLE_TAXES_
			fnParams.EndIndex = _HIGH_TAXES_

			if Work.CurrentIndex < fnParams.StartIndex then
				fnParams.CurrentIndex = 99
			end

			return GetLowestLaw( fnParams )

		elseif Work.NewIndex == _HIGH_TAXES_ then

			fnParams.StartIndex = _HIGH_TAXES_
			fnParams.EndIndex = _ACCEPTABLE_TAXES_

			if Work.CurrentIndex > fnParams.StartIndex then
				fnParams.CurrentIndex = 0
			end

			return GetHighestLaw( fnParams )

		elseif Work.NewIndex == _EXPLOITIVE_TAXES_ then

			fnParams.StartIndex = _EXPLOITIVE_TAXES_
			fnParams.EndIndex = _ACCEPTABLE_TAXES_
			return GetHighestLaw( fnParams )
		end
	end

	if Work.NewIndex ~= Work.CurrentIndex then
		return Work.NewLaw
	else
		return nil
	end
end

function ConscriptionLaw( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.MinisterCountry ) )
	or ( not Utils.ASSERT( Params.CurrentLaw ) )
	then
		return nil
	end

	local Work = {
		CurrentIndex = Params.CurrentLaw:GetIndex(),
		NewLaw = nil,
		NewIndex = 0
	}

	-- SSmith (03/05/2014)
	-- The manpower check now returns a table of values

	-- SSmith (07/09/2014)
	-- Amended for efficiency
	
	if Work.CurrentIndex == _VOLUNTEER_ARMY_				-- Standing Army
	then
		if Support.HasEnoughManpower(Params.MinisterTag).MobilizeForWar	-- We need more men
		then
			Work.NewIndex = _ONE_YEAR_DRAFT_			-- Mobilize for War!
		end

	elseif Work.CurrentIndex == _ONE_YEAR_DRAFT_				-- Mobilized Standing Army or
	or Work.CurrentIndex == _TWO_YEAR_DRAFT_				-- Drafted Army
	then
		-- SSmith (03/05/2014)
		-- Changes to the manpower check should mean we don't need AI flags

		if Support.HasEnoughManpower(Params.MinisterTag).ExtendDraft
		then
			Work.NewIndex = _THREE_YEAR_DRAFT_			-- Enact the Extended Draft!
		end

	elseif Work.CurrentIndex == _THREE_YEAR_DRAFT_				-- Extended Draft
	then
		-- SSmith (03/05/2014)
		-- Changes to the manpower check should mean we don't need AI flags

		if Support.HasEnoughManpower(Params.MinisterTag).EmergencyDraft
		then
			Work.NewIndex = _SERVICE_BY_REQUIREMENT_		-- Enact the Emergency Draft!
		end
	end
	
	-- SSmith (24/03/2015)
	-- These checks should be unnecessary!

	--if Work.Index < CLawDataBase.GetNumberOfLaws() then
	--	Work.NewLaw = CLawDataBase.GetLaw(Work.Index)
	--	if not ( Params.CurrentLaw:GetGroup():GetIndex() == Work.NewLaw:GetGroup():GetIndex() ) then 
	--		return nil
	--	end
	--end

	if Work.NewIndex > 0 then
		Work.NewLaw = CLawDataBase.GetLaw( Work.NewIndex )
		if Work.NewLaw:ValidFor( Params.MinisterTag ) then
			return Work.NewLaw
		end
	end

	return nil
end

function TrainingLaws( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.MinisterCountry ) )
	or ( not Utils.ASSERT( Params.CurrentLaw ) )
	then
		return nil
	end

	-- SSmith (03/04/2015)
	-- Re-written to use new functions

	local Work = {
		CurrentIndex = Params.CurrentLaw:GetIndex(),
		Flags = Params.MinisterCountry:GetFlags(),
		Years = { "46", "45", "43", "42", "40", "37", "30" },
		DoctrinePath = "",
		TotalIC = Params.MinisterCountry:GetTotalIC(),
		ReinforceIC = Params.MinisterCountry:GetProductionDistributionAt(_PRODUCTION_REINFORCEMENT_):GetNeeded():Get(),
		ReinforceFactor = Params.MinisterCountry:CalculateReinforcementMultiplier():Get(),
		IsAtWar = Params.MinisterCountry:IsAtWar(),
		IncreaseTraining = false,
		CutTraining = false
	}

	-- We will check the IC required for reinforcements against our total IC
	-- If the cost is too high we should cut training
	-- If it's low enough we can increase training
	-- Otherwise we just leave this law alone!

	if Work.ReinforceIC > (Work.TotalIC * 0.5) and Work.IsAtWar and Work.ReinforceFactor < 1.5 then
		Work.CutTraining = true
	elseif Work.ReinforceIC < (Work.TotalIC * 0.35) then
		Work.IncreaseTraining = true
	else
		return nil
	end


	-- The AI will now determine the current operational doctrine and act accordingly

	for i = 1, table.getn(Work.Years) do
		if Work.DoctrinePath == "" then
			if Work.Flags:IsFlagSet("grand_battle_plan_" .. Work.Years[i]) then
				Work.DoctrinePath = "grand_battle_plan"
			elseif Work.Flags:IsFlagSet("superior_firepower_" .. Work.Years[i]) then
				Work.DoctrinePath = "superior_firepower"
			elseif Work.Flags:IsFlagSet("blitzkrieg_" .. Work.Years[i]) then
				Work.DoctrinePath = "blitzkrieg"
			elseif Work.Flags:IsFlagSet("human_wave_" .. Work.Years[i]) or Work.Flags:IsFlagSet("mechanized_wave_" .. Work.Years[i]) then
				Work.DoctrinePath = "human_wave"
			end
		end
	end

	--if tostring(Params.MinisterTag) == "GER" then
	--	Utils.LUA_DEBUGOUT("")
	--	Utils.LUA_DEBUGOUT("Doctrine Path:     " .. Work.DoctrinePath)
	--	Utils.LUA_DEBUGOUT("Reinforce Factor:  " .. tostring(Work.ReinforceFactor))
	--	Utils.LUA_DEBUGOUT("Reinforce IC:      " .. tostring(Work.ReinforceIC))
	--	Utils.LUA_DEBUGOUT("Total IC:          " .. tostring(Work.TotalIC))
	--	Utils.LUA_DEBUGOUT("Increase Training: " .. tostring(Work.IncreaseTraining))
	--	Utils.LUA_DEBUGOUT("Cut Training:      " .. tostring(Work.CutTraining))
	--	Utils.LUA_DEBUGOUT("")
	--end

	local fnParams = {
		MinisterTag = Params.MinisterTag,
		StartIndex,
		EndIndex,
		CurrentIndex = Work.CurrentIndex
	}

	if Work.DoctrinePath == "grand_battle_plan"
	or Work.DoctrinePath == "superior_firepower"
	or Work.DoctrinePath == "blitzkrieg" then

		-- Advanced doctrines require the best training

		if Work.IncreaseTraining then

			-- Increase our training law if we can

			fnParams.StartIndex = _SPECIALIST_TRAINING_

			if Work.CurrentIndex < _SPECIALIST_TRAINING_ then
				fnParams.StartIndex = Work.CurrentIndex + 1
			end

			fnParams.EndIndex = _MINIMAL_TRAINING_
			return GetHighestLaw( fnParams )

		elseif Work.CutTraining then

			-- Cut our training law if we have to

			fnParams.StartIndex = _MINIMAL_TRAINING_

			if Work.CurrentIndex > _MINIMAL_TRAINING_ then
				fnParams.StartIndex = Work.CurrentIndex - 1
			end

			fnParams.EndIndex = _SPECIALIST_TRAINING_
			return GetLowestLaw( fnParams )

		end

	elseif Work.DoctrinePath == "human_wave" then

		-- Human Wave requires the least training to get the most units

		if tostring(Params.MinisterTag) == "SOV" and Work.IncreaseTraining then

			-- Increase Soviet training to recruit more officers once we're strong enough

			if Work.Flags:IsFlagSet("mechanized_wave_42")
			and Params.MinisterCountry:GetUnits():GetTotalNumOfRegiments() > 900 then

				fnParams.StartIndex = _BASIC_TRAINING_
				fnParams.EndIndex = _MINIMAL_TRAINING_

				if Work.CurrentIndex > fnParams.StartIndex then
					fnParams.CurrentIndex = 0
				end

				return GetHighestLaw( fnParams )

			end
		end

		fnParams.StartIndex = _MINIMAL_TRAINING_
		fnParams.EndIndex = _BASIC_TRAINING_
		return GetLowestLaw( fnParams )

	else
		-- By default go for basic training if possible

		if Work.IncreaseTraining then

			fnParams.StartIndex = _BASIC_TRAINING_
			fnParams.EndIndex = _MINIMAL_TRAINING_
		
			if Work.CurrentIndex > fnParams.StartIndex then
				fnParams.CurrentIndex = 0
			end

			return GetHighestLaw( fnParams )

		elseif Work.CutTraining then

			fnParams.StartIndex = _MINIMAL_TRAINING_
			fnParams.EndIndex = _BASIC_TRAINING_

			return GetLowestLaw( fnParams )
		end
	end
end

function InternationalStatus( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.MinisterCountry ) )
	or ( not Utils.ASSERT( Params.CurrentLaw ) )
	then
		return nil
	end

	local Work = {
		CurrentIndex = Params.CurrentLaw:GetIndex(),
		NewLaw = nil,
		NewIndex = 0
	}

	-- SSmith (24/03/2015)
	-- Always try to pick the next one!

	if Work.CurrentIndex < _SUPERPOWER_ then
		Work.NewIndex = Work.CurrentIndex + 1
		Work.NewLaw = CLawDataBase.GetLaw( Work.NewIndex )
		if Work.NewLaw:ValidFor( Params.MinisterTag ) then
			return Work.NewLaw
		end
	end

	return nil
end

-- SSmith (24/03/2015
-- Generic functions to find the lowest or highest valid laws

function GetLowestLaw( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.StartIndex ) )
	or ( not Utils.ASSERT( Params.EndIndex ) )
	or ( not Utils.ASSERT( Params.CurrentIndex ) )
	then
		return nil
	end

	local index = Params.StartIndex

	while index <= Params.EndIndex and index < Params.CurrentIndex do

		local law = CLawDataBase.GetLaw( index )
		if law:ValidFor( Params.MinisterTag ) then
			return law
		end

		index = index + 1
	end

	return nil
end

function GetHighestLaw( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.StartIndex ) )
	or ( not Utils.ASSERT( Params.EndIndex ) )
	or ( not Utils.ASSERT( Params.CurrentIndex ) )
	then
		return nil
	end

	local index = Params.StartIndex

	while index >= Params.EndIndex and index > Params.CurrentIndex do

		local law = CLawDataBase.GetLaw( index )
		if law:ValidFor( Params.MinisterTag ) then
			return law
		end

		index = index - 1
	end

	return nil
end

-- #####################
-- # Office Management
-- #####################

function OfficeManagement( minister )
	
	if not ( Utils.ASSERT( minister ) )
	then
		return
	end

	-- SSmith (17/04/2014)
	-- Re-written to fix bugs and improve efficiency

	local Work = {
		MinisterCountry = minister:GetCountry(),
		MinisterTag = minister:GetCountryTag(),
		RulingIdeology,
		SpyPresence
	}
	Work.RulingIdeology = Work.MinisterCountry:GetRulingIdeology()
	Work.SpyPresence = Work.MinisterCountry:GetSpyPresence(Work.MinisterTag)

	local Ministers = {}
	local CabinetPosts = {}
	for i = _FOREIGN_MINISTER_, _CHIEF_OF_AIR_ do
		Ministers[i] = {}
		CabinetPosts[i] = CGovernmentPositionDataBase.GetGovernmentPositionByIndex(i)
	end
	
	local day = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	local tagString = "XXX"
	--if day == 1 then tagString = "FRA"
	--elseif day == 2 then tagString = "GER"
	--elseif day == 3 then tagString = "ITA"
	--elseif day == 4 then tagString = "SOV"
	--elseif day == 5 then tagString = "USA"
	--elseif day == 6 then tagString = "JAP"
	--end
	if tostring(Work.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Ministers...")
	end

	-- Find the ideologies acceptable to our ruling party

	local fnParams = {
		MinisterCountry = Work.MinisterCountry
	}
	local Ideologies = GetAcceptedIdeologies( fnParams )

	-- Store the ministers available for each cabinet position

	fnParams = {
		MinisterCountry = Work.MinisterCountry,
		RulingIdeologyString = tostring(Work.RulingIdeology:GetKey()),
		MinisterIdeology,
		Ideologies
	}

	for loMinister in Work.MinisterCountry:GetPossibleMinisters() do

		-- Check the minister has a suitable ideology

		fnParams.MinisterIdeology = loMinister:GetIdeology()
		local ideology = tostring(fnParams.MinisterIdeology:GetKey())

		-- Store valid candidates for political positions

		if Ideologies[ideology].MinisterValid then

			-- Get the ideology modifier if we haven't got it already

			if Ideologies[ideology].Modifier < 1 then
				fnParams.Ideologies = Ideologies
				Ideologies = GetIdeologyModifiers( fnParams )
			end

			-- Store the minister for each suitable position

			for i = _FOREIGN_MINISTER_, _MINISTER_OF_INTELLIGENCE_ do	
				if loMinister:CanTakePosition( CabinetPosts[i] ) then
					table.insert( Ministers[i], loMinister )
				end
			end
		end

		-- Store valid candidates for military staff positions

		if Ideologies[ideology].StaffValid then

			-- Get the ideology modifier if we haven't got it already

			if Ideologies[ideology].Modifier < 1 then
				fnParams.Ideologies = Ideologies
				Ideologies = GetIdeologyModifiers( fnParams )
			end

			-- Store the minister for each suitable position

			for i = _CHIEF_OF_STAFF_, _CHIEF_OF_AIR_ do
				if loMinister:CanTakePosition( CabinetPosts[i] ) then
					table.insert( Ministers[i], loMinister )
				end
			end
		end
	end

	if tostring(Work.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Totals...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Air:      " .. tostring(table.getn( Ministers[_CHIEF_OF_AIR_] )))
		Utils.LUA_DEBUGOUT("Navy:     " .. tostring(table.getn( Ministers[_CHIEF_OF_NAVY_] )))
		Utils.LUA_DEBUGOUT("Army:     " .. tostring(table.getn( Ministers[_CHIEF_OF_ARMY_] )))
		Utils.LUA_DEBUGOUT("Staff:    " .. tostring(table.getn( Ministers[_CHIEF_OF_STAFF_] )))
		Utils.LUA_DEBUGOUT("Intel:    " .. tostring(table.getn( Ministers[_MINISTER_OF_INTELLIGENCE_] )))
		Utils.LUA_DEBUGOUT("Security: " .. tostring(table.getn( Ministers[_MINISTER_OF_SECURITY_] )))
		Utils.LUA_DEBUGOUT("Armament: " .. tostring(table.getn( Ministers[_ARMAMENT_MINISTER_] )))
		Utils.LUA_DEBUGOUT("Foreign:  " .. tostring(table.getn( Ministers[_FOREIGN_MINISTER_] )))
	end

	-- Now we can appoint the minister to each cabinet post
	-- First we need some tables to hold the names of the sub-methods we are going to call
	-- And also the minister traits that will need evaluating

	local Functions = {}
	Functions[_FOREIGN_MINISTER_] 	      = { Function = Score_ForeignMinister }
	Functions[_ARMAMENT_MINISTER_] 	      = { Function = Score_ArmamentMinister }
	Functions[_MINISTER_OF_SECURITY_]     = { Function = Score_MinisterOfSecurity }
	Functions[_MINISTER_OF_INTELLIGENCE_] = { Function = Score_MinisterOfIntelligence }
	Functions[_CHIEF_OF_STAFF_] 	      = { Function = Score_ChiefOfStaff }
	Functions[_CHIEF_OF_ARMY_] 	      = { Function = Score_ChiefOfArmy }
	Functions[_CHIEF_OF_NAVY_] 	      = { Function = Score_ChiefOfNavy }
	Functions[_CHIEF_OF_AIR_] 	      = { Function = Score_ChiefOfAir }

	local Traits = {}
	Traits[_FOREIGN_MINISTER_] = {
		biased_intellectual = { Score = 0 },
		ideological_crusader = { Score = 0 },
		apologetic_clerk = { Score = 0 },
		iron_fisted_brute = { Score = 0 },
		great_compromiser = { Score = 0 },
		the_cloak_n_dagger_schemer = { Score = 0 },
		general_staffer = { Score = 0 }
	}
	Traits[_ARMAMENT_MINISTER_] = {
		corrupt_kleptocrat = { Score = 0 },
		administrative_genius = { Score = 0 },
		resource_industrialist = { Score = 0 },
		laissez_faires_capitalist = { Score = 0 },
		theoretical_scientist = { Score = 0 },
		military_entrepreneur = { Score = 0 },
		battle_fleet_proponent = { Score = 0 },
		submarine_proponent = { Score = 0 },
		tank_proponent = { Score = 0 },
		infantry_proponent = { Score = 0 },
		air_to_ground_proponent = { Score = 0 },
		air_superiority_proponent = { Score = 0 },
		air_to_sea_proponent = { Score = 0 },
		strategic_air_proponent = { Score = 0 }
	}
	Traits[_MINISTER_OF_SECURITY_] = {
		crooked_kleptocrat = { Score = 0 },
		silent_lawyer = { Score = 0 },
		compassionate_gentleman = { Score = 0 },
		crime_fighter = { Score = 0 },
		prince_of_terror = { Score = 0 },
		back_stabber = { Score = 0 },
		man_of_the_people = { Score = 0 },
		efficient_sociopath = { Score = 0 }
	}
	Traits[_MINISTER_OF_INTELLIGENCE_] = {
		technical_specialist = { Score = 0 },
		research_specialist = { Score = 0 },
		political_specialist = { Score = 0 },
		dismal_enigma = { Score = 0 },
		industrial_specialist = { Score = 0 },
		naval_intelligence_specialist = { Score = 0 }
	}
	Traits[_CHIEF_OF_STAFF_] = {
		school_of_manoeuvre = { Score = 0 },
		school_of_fire_support = { Score = 0 },
		school_of_mass_combat = { Score = 0 },
		school_of_psychology = { Score = 0 },
		school_of_defence = { Score = 0 },
		logistics_specialist = { Score = 0 }
	}
	Traits[_CHIEF_OF_ARMY_] = {
		elastic_defence_doctrine = { Score = 0 },
		static_defence_doctrine = { Score = 0 },
		decisive_battle_doctrine = { Score = 0 },
		armoured_spearhead_doctrine = { Score = 0 },
		guns_and_butter_doctrine = { Score = 0 }
	}
	Traits[_CHIEF_OF_NAVY_] = {
		decisive_naval_battle_doctrine = { Score = 0 },
		power_projection_doctrine = { Score = 0 },
		indirect_approach_doctrine = { Score = 0 },
		base_control_doctrine = { Score = 0 }
	}
	Traits[_CHIEF_OF_AIR_] = {
		air_superiority_doctrine = { Score = 0 },
		naval_aviation_doctrine = { Score = 0 },
		army_aviation_doctrine = { Score = 0 },
		carpet_bombing_doctrine = { Score = 0 },
		vertical_envelopment_doctrine = { Score = 0 }
	}

	-- Before continuing we also need a table of information about our country so the functions can make decisions

	local CountryInfo = {
		MinisterCountry = Work.MinisterCountry,
		MinisterTag = Work.MinisterTag,
		Year = CCurrentGameState.GetCurrentDate():GetYear(),
		TotalIC = Work.MinisterCountry:GetTotalIC(),
		Leadership = Work.MinisterCountry:GetTotalLeadership():Get(),
		HasFaction = Work.MinisterCountry:HasFaction(),
	--	Faction = Work.MinisterCountry:GetFaction():GetIdeologyGroup(),
	--	RulingIdeology = Work.RulingIdeology,
		RulingIdeologyGroup = Work.RulingIdeology:GetGroup(),
		Popularity = Work.MinisterCountry:AccessIdeologyPopularity():GetValue( Work.RulingIdeology ):Get(),
	--	Organization = Work.MinisterCountry:AccessIdeologyOrganization():GetValue( Work.RulingIdeology ):Get(),
		DomesticSpies = Work.SpyPresence:GetLevel():Get(),
		RulingPartyPriority = Work.SpyPresence:GetMissionPriority(_SPYMISSION_BOOST_RULING_PARTY_),
		RaiseUnityPriority = Work.SpyPresence:GetMissionPriority(_SPYMISSION_RAISE_NATIONAL_UNITY_),
		EnemySpies = Support.GetEnemySpyPresence(Work.MinisterTag, Work.MinisterCountry).EnemySpies,
	--	StrategicWarfare = Work.MinisterCountry:GetStrategicWarfare(),
		Neutrality = Work.MinisterCountry:GetNeutrality():Get(),
	--	EftvNeutrality = Work.MinisterCountry:GetEffectiveNeutrality():Get(),
		NationalUnity = Work.MinisterCountry:GetNationalUnity():Get(),
		SurrenderLevel = Work.MinisterCountry:GetSurrenderLevel():Get(),
		IsAtWar = Work.MinisterCountry:IsAtWar(),
		GovernmentInExile = Work.MinisterCountry:IsGovernmentInExile(),
	--	ConsumerIC = Work.MinisterCountry:GetICPart(_PRODUCTION_CONSUMER_):Get(),
	--	SupplyIC = Work.MinisterCountry:GetICPart(_PRODUCTION_SUPPLY_):Get(),
	--	Flags = Work.MinisterCountry:GetFlags(),
		ResourceRatio = 1
	}

	-- SSmith (13/04/2015)
	-- To appoint the armaments minister we need to calculate our resource situation

	local Temp = {
		GoodsPool = Work.MinisterCountry:GetPool(),
		CurrentStockpile = 0,
		IdealStockpile = 0
	}

	-- Energy

	Temp.CurrentStockpile = Temp.GoodsPool:Get(_ENERGY_):Get()
	Temp.IdealStockpile = Support.GetEffectiveResourceLimit(Work.MinisterCountry, _ENERGY_)
	Temp.Ratio = Temp.CurrentStockpile / Temp.IdealStockpile

	if Temp.Ratio < CountryInfo.ResourceRatio then
		CountryInfo.ResourceRatio = Temp.Ratio
	end

	-- Metals

	Temp.CurrentStockpile = Temp.GoodsPool:Get(_METAL_):Get()
	Temp.IdealStockpile = Support.GetEffectiveResourceLimit(Work.MinisterCountry, _METAL_)
	Temp.Ratio = Temp.CurrentStockpile / Temp.IdealStockpile

	if Temp.Ratio < CountryInfo.ResourceRatio then
		CountryInfo.ResourceRatio = Temp.Ratio
	end

	-- Rares

	Temp.CurrentStockpile = Temp.GoodsPool:Get(_RARE_MATERIALS_):Get()
	Temp.IdealStockpile = Support.GetEffectiveResourceLimit(Work.MinisterCountry, _RARE_MATERIALS_)
	Temp.Ratio = Temp.CurrentStockpile / Temp.IdealStockpile

	if Temp.Ratio < CountryInfo.ResourceRatio then
		CountryInfo.ResourceRatio = Temp.Ratio
	end	

	if tostring(Work.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Country...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("TotalIC:        " .. tostring(CountryInfo.TotalIC))
		Utils.LUA_DEBUGOUT("Leadership:     " .. tostring(CountryInfo.Leadership))
		Utils.LUA_DEBUGOUT("HasFaction:     " .. tostring(CountryInfo.HasFaction))
	--	Utils.LUA_DEBUGOUT("Faction:        " .. tostring(CountryInfo.Faction:GetKey()))
	--	Utils.LUA_DEBUGOUT("Ideology:       " .. tostring(CountryInfo.RulingIdeology:GetKey()))
		Utils.LUA_DEBUGOUT("IdeologyGroup:  " .. tostring(CountryInfo.RulingIdeologyGroup:GetKey()))
		Utils.LUA_DEBUGOUT("Popularity:     " .. tostring(CountryInfo.Popularity))
	--	Utils.LUA_DEBUGOUT("Organization:   " .. tostring(CountryInfo.Organization))
		Utils.LUA_DEBUGOUT("OurSpies:       " .. tostring(CountryInfo.DomesticSpies))
		Utils.LUA_DEBUGOUT("RulingParty:    " .. tostring(CountryInfo.RulingPartyPriority))
		Utils.LUA_DEBUGOUT("RaisingUnity:   " .. tostring(CountryInfo.RaiseUnityPriority))
		Utils.LUA_DEBUGOUT("EnemySpies:     " .. tostring(CountryInfo.EnemySpies))
		Utils.LUA_DEBUGOUT("Neutrality:     " .. tostring(CountryInfo.Neutrality))
	--	Utils.LUA_DEBUGOUT("EftvNeutrality: " .. tostring(CountryInfo.EftvNeutrality))
		Utils.LUA_DEBUGOUT("Unity:          " .. tostring(CountryInfo.NationalUnity))
		Utils.LUA_DEBUGOUT("Surrender:      " .. tostring(CountryInfo.SurrenderLevel))
		Utils.LUA_DEBUGOUT("War:            " .. tostring(CountryInfo.IsAtWar))
		Utils.LUA_DEBUGOUT("Exile:          " .. tostring(CountryInfo.GovernmentInExile))
	--	Utils.LUA_DEBUGOUT("ConsumerIC:     " .. tostring(CountryInfo.ConsumerIC))
	--	Utils.LUA_DEBUGOUT("SupplyIC:       " .. tostring(CountryInfo.SupplyIC))
		--Utils.LUA_DEBUGOUT("" )
		--Utils.LUA_DEBUGOUT("SpyMission.SPYMISSION_COUNTER_ESPIONAGE " .. tostring(SpyMission.SPYMISSION_COUNTER_ESPIONAGE))
		--Utils.LUA_DEBUGOUT("SpyMission.SPYMISSION_MILITARY " .. tostring(SpyMission.SPYMISSION_MILITARY))
		--Utils.LUA_DEBUGOUT("SpyMission.SPYMISSION_TECH " .. tostring(SpyMission.SPYMISSION_TECH))
		--Utils.LUA_DEBUGOUT("SpyMission.SPYMISSION_BOOST_RULING_PARTY " .. tostring(SpyMission.SPYMISSION_BOOST_RULING_PARTY))
		--Utils.LUA_DEBUGOUT("SpyMission.SPYMISSION_BOOST_OUR_PARTY " .. tostring(SpyMission.SPYMISSION_BOOST_OUR_PARTY))
		--Utils.LUA_DEBUGOUT("SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY " .. tostring(SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY))
		--Utils.LUA_DEBUGOUT("SpyMission.SPYMISSION_INCREASE_THREAT " .. tostring(SpyMission.SPYMISSION_INCREASE_THREAT))
		--Utils.LUA_DEBUGOUT("SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY " .. tostring(SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY))
		--Utils.LUA_DEBUGOUT("SpyMission.SPYMISSION_COVERT_OPS " .. tostring(SpyMission.SPYMISSION_COVERT_OPS))
		--Utils.LUA_DEBUGOUT("SpyMission.SPYMISSION_MAX " .. tostring(SpyMission.SPYMISSION_MAX))
	end

	-- Now we can actually call the functions!

	fnParams = {
		AI = minister:GetOwnerAI(),
		MinisterCountry = Work.MinisterCountry,
		MinisterTag = Work.MinisterTag,
		Ideologies = Ideologies,
		Index = 0,
		Ministers,
		CabinetPost,
		Function,
		Traits = Traits,
		CountryInfo = CountryInfo
	}

	for i = _FOREIGN_MINISTER_, _CHIEF_OF_AIR_ do
		fnParams.Index = i
		fnParams.Ministers = Ministers[i]
		fnParams.CabinetPost = CabinetPosts[i]
		fnParams.Function = Functions[i].Function
		AppointMinister(fnParams)
	end
end

-- Performs all the logic to replace the holder of any cabinet post

function AppointMinister( Params )

	if ( not Utils.ASSERT( Params.AI ) )
	or ( not Utils.ASSERT( Params.MinisterCountry ) )
	or ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.Ideologies ) )
	or ( not Utils.ASSERT( Params.Index ) )
	or ( not Utils.ASSERT( Params.Ministers ) )
	or ( not Utils.ASSERT( Params.CabinetPost ) )
	or ( not Utils.ASSERT( Params.Function ) )
	or ( not Utils.ASSERT( Params.Traits ) )
	or ( not Utils.ASSERT( Params.CountryInfo ) )
	then
		return
	end

	-- SSmith (16/04/2014)
	-- Re-written for efficiency
	-- Only change the minister if the incumbent is no longer valid or the replacement has a different trait
	-- Note if there is no minister the object still exists and returns 'noIdeology' and 'noMinisterType'

	local day = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	local tagString = "XXX"
	local postString = "minister_of_security"
	--if day == 1 then tagString = "FRA"
	--elseif day == 2 then tagString = "GER"
	--elseif day == 3 then tagString = "ITA"
	--elseif day == 4 then tagString = "SOV"
	--elseif day == 5 then tagString = "USA"
	--elseif day == 6 then tagString = "JAP"
	--end
	if tostring(Params.MinisterTag) == tagString and tostring(Params.CabinetPost:GetKey()) == postString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Appointing...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Post:  " .. tostring(Params.CabinetPost:GetKey()))
	end

	-- Set up a table of working data

	local Work = {
		CurrentMinister = Params.MinisterCountry:GetMinister( Params.CabinetPost ),
		CurrentTrait = "",
		CurrentScore = 0,
		NewMinister = nil,
		NewTrait = "",
		NewScore = 0
	}
	Work.CurrentTrait = tostring(Work.CurrentMinister:GetPersonality( Params.CabinetPost ):GetKey())

	if tostring(Params.MinisterTag) == tagString and tostring(Params.CabinetPost:GetKey()) == postString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Type:  " .. Work.CurrentTrait)
		Utils.LUA_DEBUGOUT("Idlgy: " .. tostring(Work.CurrentMinister:GetIdeology():GetKey()))
		Utils.LUA_DEBUGOUT("Valid: " .. tostring(Work.CurrentMinister:IsValid()))
		Utils.LUA_DEBUGOUT("")
	end

	-- Consider each potential minister
	
	if table.getn( Params.Ministers ) > 0 then
		for i = 1, table.getn( Params.Ministers ) do

			-- Find the minister's trait and set the default score

			fnParams = {
				Trait = tostring(Params.Ministers[i]:GetPersonality( Params.CabinetPost ):GetKey()),
				Score = 10,
				CountryInfo = Params.CountryInfo
			}

			-- If the trait is valid for this cabinet post call the relevant function to evaluate it

			if not (Params.Traits[Params.Index][fnParams.Trait] == nil) then
				if Params.Traits[Params.Index][fnParams.Trait].Score < 1 then
					Params.Traits[Params.Index][fnParams.Trait].Score = Params.Function(fnParams)
				end
				fnParams.Score = Params.Traits[Params.Index][fnParams.Trait].Score
			end

			-- Apply the political ideology modifier
			
			fnParams.Score = fnParams.Score + Params.Ideologies[tostring(Params.Ministers[i]:GetIdeology():GetKey())].Modifier

			if Params.Ministers[i] == Work.CurrentMinister then

				-- Store the incumbent minister's score

				Work.CurrentScore = fnParams.Score

			elseif fnParams.Score > Work.NewScore then

				-- Store the highest scoring replacement

				Work.NewMinister = Params.Ministers[i]
				Work.NewTrait = fnParams.Trait
				Work.NewScore = fnParams.Score
			end

			if tostring(Params.MinisterTag) == tagString and tostring(Params.CabinetPost:GetKey()) == postString then
				Utils.LUA_DEBUGOUT("Type:  " .. fnParams.Trait)
				Utils.LUA_DEBUGOUT("Idlgy: " .. tostring(Params.Ministers[i]:GetIdeology():GetKey()))
				Utils.LUA_DEBUGOUT("Score: " .. tostring(fnParams.Score))
				Utils.LUA_DEBUGOUT("Old:   " .. tostring(Work.CurrentScore))
				Utils.LUA_DEBUGOUT("New:   " .. tostring(Work.NewScore))
				Utils.LUA_DEBUGOUT("")
			end
		end
	end

	-- Only change the minister if the incumbent is no longer valid or the replacement has a different trait
	-- And provided the replacement scores at least 2 points higher

	if not( Work.NewMinister == nil ) then
		if Work.NewScore > (Work.CurrentScore + 1) then
			if Work.NewTrait ~= Work.CurrentTrait then
				Params.AI:Post( CChangeMinisterCommand( Params.MinisterTag, Work.NewMinister, Params.CabinetPost ) )
			end
		end
	end
end

function Score_ForeignMinister( Params )

	if ( not Utils.ASSERT( Params.Trait ) )
	or ( not Utils.ASSERT( Params.Score ) )
	or ( not Utils.ASSERT( Params.CountryInfo ) )
	then
		return
	end

	if Params.CountryInfo.HasFaction then			-- The drifting ministers are less useful.
		if Params.Trait == "biased_intellectual" then
			Params.Score = 50 - Params.CountryInfo.NationalUnity / 2	-- The lower our National Unity is, the more we want him!
		elseif Params.Trait == "apologetic_clerk" then
			Params.Score = Params.CountryInfo.NationalUnity / 2		-- The higher our National Unity is, the more we want him!
		elseif Params.Trait == "the_cloak_n_dagger_schemer" then
			Params.Score = 100 - Params.CountryInfo.Neutrality		-- The lower our Neutrality is, the more we want him!
		elseif Params.Trait == "great_compromiser" then
			Params.Score = Params.CountryInfo.Neutrality / 2		-- The lower our Neutrality is, the less we want him!
		elseif Params.Trait == "ideological_crusader" then
			Params.Score = 30
		elseif Params.Trait == "general_staffer"
		or Params.Trait == "iron_fisted_brute" then
			if not Params.CountryInfo.IsAtWar then				-- They are more useful at peace.
				Params.Score = 30
			else
				Params.Score = 20
			end
		elseif Params.Trait == "mostly_harmless" then
			Params.Score = 5
		end
					
	else
		local ideologygroup = tostring(Params.CountryInfo.RulingIdeologyGroup:GetKey())
		if ideologygroup == "communism"
		and Params.Trait == "biased_intellectual" then
			Params.Score = 50
		elseif ideologygroup == "fascism" 
		and Params.Trait == "the_cloak_n_dagger_schemer" then
			Params.Score = 50
		elseif ideologygroup == "democracy"
		and Params.Trait == "great_compromiser" then				-- Only good if we have low Neutrality!
			Params.Score = 75 - Params.CountryInfo.Neutrality
		elseif Params.Trait == "ideological_crusader" then
			Params.Score = 40
		elseif Params.Trait == "apologetic_clerk" then
			Params.Score = 30
		elseif Params.Trait == "general_staffer"
		or Params.Trait == "iron_fisted_brute" then
			if not Params.CountryInfo.IsAtWar then				-- They are more useful at peace.
				Params.Score = 20
			else
				Params.Score = 15
			end
		elseif Params.Trait == "mostly_harmless" then
			Params.Score = 5
		end
	end

	return Params.Score
end

function Score_ArmamentMinister( Params )

	if ( not Utils.ASSERT( Params.Trait ) )
	or ( not Utils.ASSERT( Params.Score ) )
	or ( not Utils.ASSERT( Params.CountryInfo ) )
	then
		return
	end

	-- Calculate the modifier for appointing a resource industrialist
	-- Increases at the resource ratio falls below 75%
	-- Equal priority with administrative genius if resources fall to 50%

	local Work = {
		ResourceModifier = math.max((0.5 - Params.CountryInfo.ResourceRatio), 0) * 60
	}

	if tostring(Params.CountryInfo.MinisterTag) == "GER" then

		-- If Germany is at war with the USSR we need a big stockpile of rares

		local sovTag = CCountryDataBase.GetTag('SOV')
		if Params.CountryInfo.MinisterCountry:GetRelation(sovTag):HasWar() then

			local stockpile = Params.CountryInfo.MinisterCountry:GetPool():Get(_RARE_MATERIALS_):Get()
			if stockpile < 15000 then
				Work.ResourceModifier = 20
			end
		end
	end

	if Params.Trait == "administrative_genius" then
		Params.Score = 150
	elseif Params.Trait == "resource_industrialist" then

		Params.Score = 140 + Work.ResourceModifier

	elseif Params.Trait == "laissez_faires_capitalist" then
		Params.Score = 130
	elseif Params.Trait == "military_entrepreneu" then
		Params.Score = 120
	elseif Params.Trait == "theoretical_scientist" then
		Params.Score = 110
	elseif Params.Trait == "infantry_proponent" then
		Params.Score = 100
	elseif Params.Trait == "air_to_ground_proponent" then
		Params.Score = 90
	elseif Params.Trait == "air_superiority_proponent" then
		Params.Score = 80
	elseif Params.Trait == "battle_fleet_proponent" then
		Params.Score = 70
	elseif Params.Trait == "air_to_sea_proponent" then
		Params.Score = 60
	elseif Params.Trait == "strategic_air_proponent" then
		Params.Score = 50
	elseif Params.Trait == "submarine_proponent" then
		Params.Score = 40
	elseif Params.Trait == "tank_proponent" then
		Params.Score = 30
	elseif Params.Trait == "corrupt_kleptocrat" then
		Params.Score = 20
	elseif Params.Trait == "crooked_kleptocrat" then
		Params.Score = 10
	elseif Params.Trait == "mostly_harmless" then
		Params.Score = 5
	end

	return Params.Score
end

-- Calculates the value of Minister of Security traits
-- Note traits should be scored once only when they are required

function Score_MinisterOfSecurity( Params )

	if ( not Utils.ASSERT( Params.Trait ) )
	or ( not Utils.ASSERT( Params.Score ) )
	or ( not Utils.ASSERT( Params.CountryInfo ) )
	then
		return
	end

	if Params.Trait == "crooked_kleptocrat" then

		-- Gives a bonus to party support at the expense of IC
		-- Score from 20 upwards depending on the weakness of the ruling party

		Params.Score = 20 + math.min(math.max(35 - Params.CountryInfo.Popularity, 0), 20) * 3

	elseif Params.Trait == "prince_of_terror" then

		-- Gives a bonus to party support at the expense of partisan strength
		-- Use the same calculation as the crooked kleptocrat
		-- For role-play penalise this for democracies

		Params.Score = Params.Score + math.min(math.max(35 - Params.CountryInfo.Popularity, 0), 20) * 3
		if tostring(Params.CountryInfo.RulingIdeologyGroup:GetKey()) == "democracy" then
			Params.Score = Params.Score - 10
		end

	elseif Params.Trait == "silent_lawyer" then

		-- Reduces the threat we generate
		-- Score from 20 upwards depending on enemy spy presence
		-- Add more if we are in a faction and if we are a large country

		local work = math.min(Params.CountryInfo.EnemySpies / 2, 25)
		Params.Score = 20 + work
		if Params.CountryInfo.HasFaction then
			Params.Score = Params.Score + (work / 2)
			Params.Score = Params.Score + (math.min(Params.CountryInfo.TotalIC / 200, 0.5) * work)
		end

	elseif Params.Trait == "compassionate_gentleman" then

		-- Gives a bonus to NU changes but also strategic warfare effects
		-- We only know he's useful if we have a mission to raise unity
		-- Range 20-50 depending on our effort to raise unity
		-- Increase further if NU is low or we have surrender progress

		Params.Score = 20
		if Params.CountryInfo.RaiseUnityPriority > 0 then
			local work = Params.CountryInfo.RaiseUnityPriority / (Params.CountryInfo.RaiseUnityPriority + Params.CountryInfo.RulingPartyPriority)
			work = Params.CountryInfo.DomesticSpies * Params.CountryInfo.RaiseUnityPriority * work
			Params.Score = Params.Score + work
			if not Params.CountryInfo.GovernmentInExile then
				Params.Score = Params.Score + (math.min((100 - Params.CountryInfo.NationalUnity) / 50, 1) * work)
				if Params.CountryInfo.IsAtWar then
					Params.Score = Params.Score + (Params.CountryInfo.SurrenderLevel * work)
				end
			end
		end

		-- Don't let the Soviets select this minister until they've got past the internal turmoil modifiers

		if tostring(Params.CountryInfo.MinisterTag) == "SOV" then
			if Params.CountryInfo.Year < 1938 then
				Params.Score = 10
			end
		end

	elseif Params.Trait == "crime_fighter" then

		-- Gives a bonus to counter-espionage
		-- Range from 20 upwards depending on enemy spy activity
		-- Add more if NU is low or we have surrender progress
		-- Also more likely if we are actually doing counter-espionage

		Params.Score = 20 + Params.CountryInfo.EnemySpies
		if not Params.CountryInfo.GovernmentInExile then
			Params.Score = Params.Score + math.min((100 - Params.CountryInfo.NationalUnity) / 2.5, 20)
			if Params.CountryInfo.IsAtWar then
				Params.Score = Params.Score + math.max((Params.CountryInfo.SurrenderLevel - 0.8) * 100, 0)
			end
		end
		if Params.CountryInfo.RulingPartyPriority < 1 and Params.CountryInfo.RaiseUnityPriority < 1 then
			Params.Score = Params.Score + 10
		end

	elseif Params.Trait == "back_stabber" then

		-- Gives a bonus to counter-espionage but also increases dissent
		-- Use the same logic as the crime fighter but start from a lower base so that minister will be preferred

		Params.Score = 10 + Params.CountryInfo.EnemySpies
		if not Params.CountryInfo.GovernmentInExile then
			Params.Score = Params.Score + math.min((100 - Params.CountryInfo.NationalUnity) / 2.5, 20)
			if Params.CountryInfo.IsAtWar then
				Params.Score = Params.Score + math.max((Params.CountryInfo.SurrenderLevel - 0.8) * 100, 0)
			end
		end
		if Params.CountryInfo.RulingPartyPriority < 1 and Params.CountryInfo.RaiseUnityPriority < 1 then
			Params.Score = Params.Score + 10
		end

	elseif Params.Trait == "man_of_the_people" then

		-- Gives a bonus to leadership
		-- Range 30 and upwards depending on base leadership

		Params.Score = 30 + Params.CountryInfo.Leadership

	elseif Params.Trait == "efficient_sociopath" then

		-- Prevents enemy's seeing information on the intelligence tab
		-- Range 20-40 depending on enemy spy activity

		Params.Score = 20 + math.min((Params.CountryInfo.EnemySpies / 2), 20)
	end

	return Params.Score
end

function Score_MinisterOfIntelligence( Params )

	if ( not Utils.ASSERT( Params.Trait ) )
	or ( not Utils.ASSERT( Params.Score ) )
	or ( not Utils.ASSERT( Params.CountryInfo ) )
	then
		return
	end

	if Params.Trait == "dismal_enigma" then
		Params.Score = 60
	elseif Params.Trait == "research_specialist" then
		Params.Score = 50
	elseif Params.Trait == "naval_intelligence_specialist" then
		Params.Score = 40
	elseif Params.Trait == "technical_specialist" then
		Params.Score = 30
	elseif Params.Trait == "industrial_specialist" then
		Params.Score = 20
	elseif Params.Trait == "political_specialist" then
		Params.Score = 10
	elseif Params.Trait == "mostly_harmless" then
		Params.Score = 5
	end

	return Params.Score
end

function Score_ChiefOfStaff( Params )

	if ( not Utils.ASSERT( Params.Trait ) )
	or ( not Utils.ASSERT( Params.Score ) )
	or ( not Utils.ASSERT( Params.CountryInfo ) )
	then
		return
	end

	if Params.Trait == "school_of_mass_combat" then
		Params.Score = 60
	elseif Params.Trait == "school_of_psychology" then
		Params.Score = 50
	elseif Params.Trait == "logistics_specialist" then
		Params.Score = 40
	elseif Params.Trait == "school_of_fire_support" then
		Params.Score = 30
	elseif Params.Trait == "school_of_defence" then
		Params.Score = 20
	elseif Params.Trait == "school_of_manoeuvre" then
		Params.Score = 10
	elseif Params.Trait == "mostly_harmless" then
		Params.Score = 5
	end

	return Params.Score
end

function Score_ChiefOfArmy( Params )

	if ( not Utils.ASSERT( Params.Trait ) )
	or ( not Utils.ASSERT( Params.Score ) )
	or ( not Utils.ASSERT( Params.CountryInfo ) )
	then
		return
	end

	if Params.Trait == "guns_and_butter_doctrine" then
		Params.Score = 50
	elseif Params.Trait == "static_defence_doctrine" then
		Params.Score = 40
	elseif Params.Trait == "decisive_battle_doctrine" then
		Params.Score = 30
	elseif Params.Trait == "elastic_defence_doctrine" then
		Params.Score = 20
	elseif Params.Trait == "armoured_spearhead_doctrine" then
		Params.Score = 10
	elseif Params.Trait == "mostly_harmless" then
		Params.Score = 5
	end

	return Params.Score
end

function Score_ChiefOfNavy( Params )

	if ( not Utils.ASSERT( Params.Trait ) )
	or ( not Utils.ASSERT( Params.Score ) )
	or ( not Utils.ASSERT( Params.CountryInfo ) )
	then
		return
	end

	if Params.Trait == "decisive_naval_battle_doctrine" then
		Params.Score = 50
	elseif Params.Trait == "indirect_approach_doctrine" then
		Params.Score = 40
	elseif Params.Trait == "open_seas_doctrine" then
		Params.Score = 30
	elseif Params.Trait == "base_control_doctrine" then
		Params.Score = 20
	elseif Params.Trait == "power_projection_doctrine" then
		Params.Score = 10
	elseif Params.Trait == "mostly_harmless" then
		Params.Score = 5
	end

	return Params.Score
end

function Score_ChiefOfAir( Params )

	if ( not Utils.ASSERT( Params.Trait ) )
	or ( not Utils.ASSERT( Params.Score ) )
	or ( not Utils.ASSERT( Params.CountryInfo ) )
	then
		return
	end

	if Params.Trait == "air_superiority_doctrine" then
		Params.Score = 50
	elseif Params.Trait == "army_aviation_doctrine" then
		Params.Score = 40
	elseif Params.Trait == "naval_aviation_doctrine" then
		Params.Score = 30
	elseif Params.Trait == "carpet_bombing_doctrine" then
		Params.Score = 20
	elseif Params.Trait == "vertical_envelopment_doctrine" then
		Params.Score = 10
	elseif Params.Trait == "mostly_harmless" then
		Params.Score = 5
	end

	return Params.Score
end

-- ########################
-- # Minister sub-methods
-- ########################

-- This function will be called once to determine the accepted ideologies

function GetAcceptedIdeologies( Params )

	if not (Utils.ASSERT( Params.MinisterCountry ) )
	then
		return {}
	end

	local Work = {
		MinisterTagString = tostring(Params.MinisterCountry:GetCountryTag()),
		RulingIdeology = tostring(Params.MinisterCountry:GetRulingIdeology():GetKey()),
		RulingIdeologyGroup = tostring(Params.MinisterCountry:GetRulingIdeology():GetGroup():GetKey())
	}

	-- Create the output table

	local Ideologies = {
		national_socialist  = { MinisterValid = false, StaffValid = false, Modifier = 0 },
		fascistic 	    = { MinisterValid = false, StaffValid = false, Modifier = 0 },
		paternal_autocrat   = { MinisterValid = false, StaffValid = false, Modifier = 0 },
		social_conservative = { MinisterValid = false, StaffValid = false, Modifier = 0 },
		market_liberal 	    = { MinisterValid = false, StaffValid = false, Modifier = 0 },
		social_liberal 	    = { MinisterValid = false, StaffValid = false, Modifier = 0 },
		social_democrat     = { MinisterValid = false, StaffValid = false, Modifier = 0 },
		left_wing_radical   = { MinisterValid = false, StaffValid = false, Modifier = 0 },
		leninist 	    = { MinisterValid = false, StaffValid = false, Modifier = 0 },
		stalinist 	    = { MinisterValid = false, StaffValid = false, Modifier = 0 }
	}

	-- The ruling ideology is always valid

	Ideologies[Work.RulingIdeology].MinisterValid = true
	Ideologies[Work.RulingIdeology].StaffValid = true

	-- By default adjacent ideologies are acceptable

	if p_IdeologyConfig[Work.RulingIdeology].IdeologyRight ~= "" then
		Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyRight].MinisterValid = true
		Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyRight].StaffValid = true
	end
	if p_IdeologyConfig[Work.RulingIdeology].IdeologyLeft ~= "" then
		Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyLeft].MinisterValid = true
		Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyLeft].StaffValid = true
	end

	-- By default staff officers of the ruling ideology group will be accepted

	Ideologies[p_IdeologyGroupConfig[Work.RulingIdeologyGroup].Ideology1].StaffValid = true
	Ideologies[p_IdeologyGroupConfig[Work.RulingIdeologyGroup].Ideology2].StaffValid = true
	Ideologies[p_IdeologyGroupConfig[Work.RulingIdeologyGroup].Ideology3].StaffValid = true
	if p_IdeologyGroupConfig[Work.RulingIdeologyGroup].Ideology4 ~= "" then
		Ideologies[p_IdeologyGroupConfig[Work.RulingIdeologyGroup].Ideology4].StaffValid = true
	end

	-- Any country-specific overrides can be declared here

	if Work.MinisterTagString == "ENG" then

		if Params.MinisterCountry:IsAtWar() and Params.MinisterCountry:GetFlags():IsFlagSet("end_of_appeasement") then

			-- The British war cabinet allows politicans of the same ideology group to be accepted

			Ideologies[p_IdeologyGroupConfig[Work.RulingIdeologyGroup].Ideology1].MinisterValid = true
			Ideologies[p_IdeologyGroupConfig[Work.RulingIdeologyGroup].Ideology2].MinisterValid = true
			Ideologies[p_IdeologyGroupConfig[Work.RulingIdeologyGroup].Ideology3].MinisterValid = true
			if p_IdeologyGroupConfig[Work.RulingIdeologyGroup].Ideology4 ~= "" then
				Ideologies[p_IdeologyGroupConfig[Work.RulingIdeologyGroup].Ideology4].MinisterValid = true
			end

		elseif Work.RulingIdeology == "social_conservative" and CCurrentGameState.GetCurrentDate():GetYear() < 1941 then

			-- SSmith (13/04/2015)
			-- The pre-war National Government should allow the Conservatives to work with the National Liberals

			Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyRight].MinisterValid = false

		elseif Work.RulingIdeology == "social_conservative" or Work.RulingIdeology == "social_democrat" then

			-- Otherwise the British parliament tends to produce single-party majorities
			-- If the Conservatives or Labour are in power then all political appointments should be members of the ruling party

			Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyRight].MinisterValid = false
			Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyLeft].MinisterValid = false
		end

	elseif Work.MinisterTagString == "USA" then

		-- Keep the USA strictly Democrat or Republican until the war starts

		if not Params.MinisterCountry:IsAtWar() then
			if Work.RulingIdeology == "social_conservative" or Work.RulingIdeology == "social_liberal" then
				Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyRight].MinisterValid = false
				Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyLeft].MinisterValid = false
			end
		end

	elseif Work.MinisterTagString == "AST" then

		-- Australian governments of the time were UAP/Country coalitions or Labor

		if Work.RulingIdeology == "social_conservative" then
			Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyRight].MinisterValid = false
		elseif Work.RulingIdeology == "market_liberal" then
			Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyLeft].MinisterValid = false
		elseif Work.RulingIdeoloy == "social_democrat" then
			Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyRight].MinisterValid = false
			Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyLeft].MinisterValid = false
		end

	elseif Work.MinisterTagString == "CAN" then

		-- In this era Canada was governed by the Liberals
		-- We shouldn't have a coalition between Liberals and Conservatives

		if Work.RulingIdeology == "market_liberal" then
			Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyRight].MinisterValid = false
			Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyLeft].MinisterValid = false
		elseif Work.RulingIdeology == "social_conservative" then
			Ideologies[p_IdeologyConfig[Work.RulingIdeology].IdeologyLeft].MinisterValid = false
		end
	end

	local tagString = "XXX"
	if Work.MinisterTagString == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Ideologies...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("NS " .. tostring(Ideologies["national_socialist"].MinisterValid) .. " " .. tostring(Ideologies["national_socialist"].StaffValid))
		Utils.LUA_DEBUGOUT("FS " .. tostring(Ideologies["fascistic"].MinisterValid) .. " " .. tostring(Ideologies["fascistic"].StaffValid))
		Utils.LUA_DEBUGOUT("PA " .. tostring(Ideologies["paternal_autocrat"].MinisterValid) .. " " .. tostring(Ideologies["paternal_autocrat"].StaffValid))
		Utils.LUA_DEBUGOUT("SC " .. tostring(Ideologies["social_conservative"].MinisterValid) .. " " .. tostring(Ideologies["social_conservative"].StaffValid))
		Utils.LUA_DEBUGOUT("ML " .. tostring(Ideologies["market_liberal"].MinisterValid) .. " " .. tostring(Ideologies["market_liberal"].StaffValid))
		Utils.LUA_DEBUGOUT("SL " .. tostring(Ideologies["social_liberal"].MinisterValid) .. " " .. tostring(Ideologies["social_liberal"].StaffValid))
		Utils.LUA_DEBUGOUT("SD " .. tostring(Ideologies["social_democrat"].MinisterValid) .. " " .. tostring(Ideologies["social_democrat"].StaffValid))
		Utils.LUA_DEBUGOUT("LR " .. tostring(Ideologies["left_wing_radical"].MinisterValid) .. " " .. tostring(Ideologies["left_wing_radical"].StaffValid))
		Utils.LUA_DEBUGOUT("LE " .. tostring(Ideologies["leninist"].MinisterValid) .. " " .. tostring(Ideologies["leninist"].StaffValid))
		Utils.LUA_DEBUGOUT("ST " .. tostring(Ideologies["stalinist"].MinisterValid) .. " " .. tostring(Ideologies["stalinist"].StaffValid))
	end

	return Ideologies
end

-- This function will be used to calculate a modifier for each ideology's chance of getting a cabinet position

function GetIdeologyModifiers( Params )

	if not (Utils.ASSERT( Params.MinisterCountry ) )
	or not (Utils.ASSERT( Params.RulingIdeologyString ) )
	or not (Utils.ASSERT( Params.MinisterIdeology ) )
	then
		return Params.Ideologies
	end

	-- Create a table of working data

	local Work = {
		MinisterIdeologyString = tostring(Params.MinisterIdeology:GetKey()),
		Popularity = Params.MinisterCountry:AccessIdeologyPopularity():GetValue( Params.MinisterIdeology ):Get(),
		Organization = Params.MinisterCountry:AccessIdeologyOrganization():GetValue( Params.MinisterIdeology ):Get()
	}

	-- The base modifier will be a factor of the ideology's popularity and organization

	Params.Ideologies[Work.MinisterIdeologyString].Modifier = math.floor((Work.Popularity + Work.Organization) / 10)

	-- The ruling ideology will always get a bonus

	if Work.MinisterIdeologyString == Params.RulingIdeologyString then
		Params.Ideologies[Work.MinisterIdeologyString].Modifier = Params.Ideologies[Work.MinisterIdeologyString].Modifier + 2
	end

	-- The modifier will be returned as a value in the range 1-9

	Params.Ideologies[Work.MinisterIdeologyString].Modifier = math.min(math.max(Params.Ideologies[Work.MinisterIdeologyString].Modifier,1),10)

	local day = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	local tagString = "XXX"
	--if day == 1 then tagString = "FRA"
	--elseif day == 2 then tagString = "GER"
	--elseif day == 3 then tagString = "ITA"
	--elseif day == 4 then tagString = "SOV"
	--elseif day == 5 then tagString = "USA"
	--elseif day == 6 then tagString = "JAP"
	--end
	if tostring(Params.MinisterCountry:GetCountryTag()) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Modifiers...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Ruling:   " .. Params.RulingIdeologyString)
		Utils.LUA_DEBUGOUT("Minister: " .. Work.MinisterIdeologyString)
		Utils.LUA_DEBUGOUT("Modifier: " .. tostring(Params.Ideologies[Work.MinisterIdeologyString].Modifier))
	end

	return Params.Ideologies
end
