{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
module Game where
import Utils (normalize, askIntInRange, modifyListAtIndex)
import Random (chooseFromWeightedList)
import Story
import Types (PlayerChoice (PlayerChoice), ScenarioOutcome (ScenarioOutcome), StartWorld (StartWorld), Player (Player), Results(Results))
import Control.Monad.Random (randomRIO)
import Data.Map qualified as Map (fromList, lookup, keys)
import Data.Map.Internal as Internal (Map)
import System.IO
import Prelude hiding (lookup)
-- import qualified Data.List.NonEmpty as Map

allScenarioKeys :: [String]
allScenarioKeys = Map.keys scenariosDict

allStartWorld :: [String]
allStartWorld = Map.keys startWorldsDict

allEndScenarios :: [String]
allEndScenarios = Map.keys endScenariosDict

getScenario :: String -> ScenarioOutcome
getScenario key = case Map.lookup key scenariosDict of
  Just scenario -> scenario
  Nothing -> endScenario

getEndScenario :: String -> ScenarioOutcome
getEndScenario key = case Map.lookup key endScenariosDict of
  Just scenario -> scenario
  Nothing -> endScenario

getStartWorld :: String -> StartWorld
getStartWorld key = case Map.lookup key startWorldsDict of
  Just scenario -> scenario
  Nothing -> studioStartWorld -- should never happen

displayChoices :: [PlayerChoice] -> IO ()
displayChoices choices = do
  putStrLn "Choices: "
  mapM_ (\(PlayerChoice desc _ _, i) -> putStrLn ("(" ++ show (i + 1) ++ ") " ++ desc)) (zip choices [0 :: Int ..])

-- given a list of scenario keys, create a list of weights for each scenario in allScenarioKeys, where the weight of scenarios in the given list is larger
createScenarioWeights :: [[Char]] -> [Rational]
createScenarioWeights [] = []
createScenarioWeights lst = normalize [if h `elem` lst then (2 * fromIntegral (length allScenarioKeys) / fromIntegral (length lst)) else 1 | h <- allScenarioKeys]

-- given a list of probabilities and an index, increase the probability at the given index, then normalize so it still sums to 1
increaseProbOfIndex :: [Float] -> Int -> [Float]
increaseProbOfIndex probs idx = normalize (modifyListAtIndex probs idx (* 2))

-- given a PlayerChoice, choose the next scenario
chooseNext :: PlayerChoice -> IO String
chooseNext (PlayerChoice _ logicalNexts _) = chooseFromWeightedList allScenarioKeys (createScenarioWeights logicalNexts)

-- putStrLn, but requires the user to press enter to continue
askWithWaitNext :: String -> IO ()
askWithWaitNext desc =
  do
    putStrLn desc
    _ <- getLine
    -- line <- getLine
    -- let cont' = fixdel line
    return ()

-- given a ScenarioOutcome, ask the user to select an option out of given choices, then return the index of the choice
askScenario :: ScenarioOutcome -> IO Int
askScenario (ScenarioOutcome desc choices) =
  do
    -- askWithWaitNext desc
    putStrLn desc
    displayChoices choices
    ans <- askIntInRange (1, length choices)
    let idx = ans - 1
    let (PlayerChoice desc2 _ _) = choices !! idx
    putStrLn ("You choose: " ++ desc2 ++ "\n")
    return idx

-- given the number points, the key of the startWorld, and the key of the ending, end the game, show the ending corresponding to number of points and startWorld of the player
showEnd :: Int -> String -> String -> IO ()
showEnd points startWorldKey endKey =
  do
    let (StartWorld _ results _) = getStartWorld startWorldKey
    if (endKey == "*")
      then do
        showStayEnd
    else if (points >= 70)
      then do
        putStrLn("With this valient effort, your story in the land of butterflies has come to an end, and as a reward the butterflies have decided to send you back to your own world. \nDisoriented and bewildered, you wake up in your own bed, wondering if what you experienced was just a dream. However, the butterflies' last words ring in your ears, \"Depending on your effort, we will bestow upon you an equivalent reward.\" \nWith a mix of anticipation and fear, you find that...")
        putStrLn (results !! 0)
    else if (points < 25)
      then do
        putStrLn("What happened? The butterflies have begun to doubt your loyalty. From the corner of your eye, you see the frog monarch begin to move. All of a sudden, you are swept up and blown away by a strong gust of wind. When you open your eyes, you find yourself sitting in the real world, with an uneasy feeling...")
        putStrLn (results !! 2)
    else
      do
        putStrLn("With this valient effort, your story in the land of butterflies has come to an end, and as a reward the butterflies have decided to send you back to your own world. \nDisoriented and bewildered, you wake up in your own bed, wondering if what you experienced was just a dream. However, the butterflies' last words ring in your ears, \"Depending on your effort, we will bestow upon you an equivalent reward.\" \nWith a mix of anticipation and fear, you find that...")
        putStrLn (results !! 1)
    return ()

-- end game (when player chooses to 'stay')
showStayEnd :: IO ()
showStayEnd =
  do
    putStrLn("You've successfully avoided job search. You spend your days frolicking around with butterflies. But when will you get back to reality?")
    return ()

-- choose random startWorld (then give user initial scenario), then return player with key of startWorld and key of storyWorld and empty inventory (for future use)
chooseStartWorld :: IO Player
chooseStartWorld =
  do
    startWorldIndex <- randomRIO (0, length allStartWorld - 1)
    let startWorldKey = allStartWorld !! startWorldIndex
    let (StartWorld sdesc _ probs) = getStartWorld startWorldKey
    askWithWaitNext sdesc
    idx <- askScenario startScenario
    let nprobs = increaseProbOfIndex probs idx
    storyWorldKey <- chooseFromWeightedList allStoryWorldKeys nprobs
    return (Player startWorldKey storyWorldKey [])

-- given a scenario key and a player, generate next scenario
go :: String -> Player -> IO Results
go key player =
  do
    let (Player startWorldKey storyWorldKey inventory) = player
    let (ScenarioOutcome desc choices) = getScenario key
    idx <- askScenario (ScenarioOutcome desc choices)
    let (PlayerChoice _ _ points) = choices !! idx
    nextScenarioKey <- chooseNext (choices !! idx)
    -- if the next scenario has the key "end" or "*" then return results, with the (end) total number of points 
    if (nextScenarioKey == "end" || nextScenarioKey == "*") 
      then do
        return (Results points nextScenarioKey)
    --   else show the player choices corresponding to the scenario, initialize next scenario, returning results adding the number of points from each choice recursively 
      else do
        (Results addPoints rEndKey) <- go nextScenarioKey player
        let totalPoints = points + addPoints
        return (Results totalPoints rEndKey)

-- Start the game, with a random startWorld, initializing the player's points, then printing points once the game ends
startGame :: IO ()
startGame = do
  askWithWaitNext "Welcome to Randomized Choose your Own Adventure.\nPress enter to continue whenever there is a pause (like now)."
  askWithWaitNext "Disclaimer: story might not make sense. Welcome to the world of randomness!"
  player <- chooseStartWorld
  let (Player startWorldKey _ _) = player
  (Results points endKey) <- go "1" player
  showEnd points startWorldKey endKey
  putStrLn $ "Points: " ++ show points
  putStrLn ("Thanks for playing!")
