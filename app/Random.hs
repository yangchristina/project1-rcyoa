module Random where
import System.Random (randomIO)
import Utils (normalize, removeFirst)

-- Generate a random continuous number between 0 and 1
randomContinuousZeroToOne :: IO Float
randomContinuousZeroToOne = randomIO

-- return a list where each element is the sum of itself and all elements with a lower index than itself in the original input list
convertToCDF :: (Num a) => [a] -> [a]
convertToCDF [] = []
convertToCDF lst = removeFirst (scanr (\x y -> y - x) 1 lst)

-- given a summed list, a list index, and a number, num, between 0 and 1, return the index of the first element in the summed list that is greater than or equal to num
chooseCDFListIndex :: (Ord b, Fractional b) => [b] -> Int -> Float -> Int
chooseCDFListIndex [] _ _ = error "Empty list"
chooseCDFListIndex (h : t) idx num = if realToFrac num <= h then idx else chooseCDFListIndex t (idx + 1) num

-- given a list of elements and a list of weights, return a random element from the list, where the probability of each element being chosen is proportional to its weight
chooseFromWeightedList :: (Fractional b1, Ord b1, Show b1) => [b2] -> [b1] -> IO b2
chooseFromWeightedList lst probs =
  do
    num <- randomContinuousZeroToOne
    let nprobs = normalize probs
    let cdf = convertToCDF nprobs
    -- putStrLn ("Num: " ++ show num)
    -- print nprobs
    let idx = chooseCDFListIndex cdf 0 num
    let val = lst !! idx
    return val