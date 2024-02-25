module Utils where
import Text.Read (readMaybe)

-- Modify a list at a given index
modifyListAtIndex :: [a] -> Int -> (a -> a) -> [a]
modifyListAtIndex xs idx f = map (\(x, i) -> if i == idx then f x else x) (zip xs [0 ..])

-- Remove the first element of a list
removeFirst :: [a] -> [a]
removeFirst [] = []
removeFirst (_ : t) = t

-- Normalize a list of numbers to sum to 1
normalize :: (Fractional a) => [a] -> [a]
normalize [] = []
normalize lst = [(y / total) | (y) <- lst]
  where
    total = sum lst

-- Ask for an integer input, and repeat until a valid integer is given
askIntInRange :: (Int, Int) -> IO Int
askIntInRange (min, max) =
  do
    input <- getLine
    case readMaybe input of
      Just ans -> do
        if ans < min || ans > max
          then do
            putStrLn "Invalid input, try again."
            askIntInRange (min, max)
          else return ans
      Nothing -> do
        putStrLn "That's not an integer. Please try again."
        askIntInRange (min, max)

-- Allow deleting characters in the terminal
fixdel :: String -> String
fixdel "" = ""
fixdel word = foldl (\x y -> (if [y] == "\DEL" then (init x) else x ++ [y])) "" word