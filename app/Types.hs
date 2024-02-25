module Types where

data PlayerChoice = PlayerChoice
  { choiceDescription :: [Char],    -- description of choice
    logicalNextOutcomeIds :: [[Char]], --- list of next logical choices (more probable)
    awardedPoints :: Int            -- number of points given to player when this choice is chosen
  }

data ScenarioOutcome = ScenarioOutcome
  { scenarioDescription :: [Char], -- description of the scenario
    choices :: [PlayerChoice]      -- Player can choose from these choices to proceed
  }

data StartWorld = StartWorld
  { startDescription :: [Char], -- desctiption of story world
    results :: [[Char]], -- size 3, [good outcome, neutral outcome, bad outcome]
    probabilitiesByUserChoice :: [Float] -- probabilities of each story world based on
  }

data Player = Player
  { startWorldKey :: [Char], -- key of inital world
    storyWorldKey :: [Char], 
    inventory :: [[Char]] -- for future extensions, not currently in use
  }

data Results = Results
  {
    points :: Int, -- number of points
    endKey :: String --which ending scenario
  }