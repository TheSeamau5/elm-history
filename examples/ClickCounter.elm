import History
import Graphics.Element exposing (Element, show)
import Mouse
import Signal exposing (Signal)
import Task exposing (Task)

makeTitle n = "n = " ++ toString n

port title : Signal String
port title = Signal.map makeTitle counts

makeHash n = "#" ++ toString n

port runTask : Signal (Task error ())
port runTask = Signal.map History.setPath (Signal.map makeHash counts)

update : () -> Int -> Int
update () n = n + 1

counts : Signal Int
counts = Signal.foldp update 0 Mouse.clicks

main : Signal Element
main = Signal.map show counts
