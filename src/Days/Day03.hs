module Days.Day03 (runDay) where

import           Control.Monad        ( liftM2 )
import           Data.Bifunctor       ( bimap )
import           Data.Map.Strict      ( Map )
import qualified Data.Map.Strict      as M

import qualified Program.RunDay       as R (runDay)
import           Data.Attoparsec.Text
import           Util.Util            ( mapParser )

runDay :: Bool -> String -> IO ()
runDay = R.runDay inputParser partA partB

------------ PARSER ------------
inputParser :: Parser Input
inputParser = mapParser charToBlock
  where charToBlock '.' = Open
        charToBlock '#' = Tree
        charToBlock _   = error "Unexpected character"

------------ TYPES ------------
type Input = Map (Int, Int) Block

data Block = Tree | Open
  deriving Show

type OutputA = Maybe Int

type OutputB = OutputA

------------ PART A ------------
countBlock :: Block -> Int
countBlock Tree = 1
countBlock Open = 0

travMap :: Input -> (Int, Int) -> OutputA
travMap i (dx, dy) = do
  let (maxX, maxY) = bimap maximum maximum (unzip (M.keys i))
  let go :: (Int, Int) -> OutputA -> OutputA
      go (x,y) mRes
        | y > maxY = mRes
        | otherwise = do
          res <- mRes
          block <- M.lookup (x `mod` (maxX+1), y) i
          go (x+dx, y+dy) (Just $ res + countBlock block)
  
  go (0,0) (Just 0)

partA :: Input -> OutputA
partA i = travMap i (3, 1)

------------ PART B ------------
partB :: Input -> OutputB
partB i = foldr
  (\d r -> liftM2 (*) r (travMap i d))
  (Just 1)
  [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
