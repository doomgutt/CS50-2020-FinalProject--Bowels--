local X = 2
local _ = 1

MAP_TEMPLATE = {
X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X
}


MAP_1 = {
X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, X, X, X, X, X, X, X, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, X, _, _, _, _, _, _, X, X, X, X, X, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, X, X, X, _, _, _, _, X,
X, _, X, _, _, _, _, _, _, _, _, _, _, _, X, X, X, X, X, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, X,
X, _, X, X, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, X,
X, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, X,
X, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, X,
X, _, X, _, X, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, X, X, _, _, X, X, X, X, X, X, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, X, _, X, X, X, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, X, X, X, X, X, _, X, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, X, _, _, _, X, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, X, X, X, _, X, _, X, _, X, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, X,
X, _, _, _, _, _, X, _, X, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, X, _, X,
X, _, _, _, _, _, X, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, X, X, X, X, X, X, _, X, _, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X
}


MAP_2 = {
X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, _, X, X, X, X, X, X, X, X,
X, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, X, _, _, _, X,
X, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, X, X, X, X, _, X, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, X, _, _, _, _, _, X, _, _, _, X,
X, _, _, _, _, _, _, _, X, X, X, X, _, _, X, X, X, X, _, _, _, X, _, _, _, X, X, X, X, X, X, X, _, _, _, X, _, _, _, X,
X, _, _, X, X, X, _, _, _, _, _, X, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, X, X, X, _, _, _, X,
X, _, _, _, _, X, _, _, _, _, _, X, _, _, X, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, X, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, X, X, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, X, X, X, X, _, _, X, X, X, X, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, X, X, X, X, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, X, _, _, _, _, _, _, X, _, _, X,
X, X, X, X, X, X, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, X, _, _, _, X, _, _, _, _, _, _, X, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, X, X, X, _, _, X, _, _, _, X, X, X, X, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, X, _, _, _, _, _, X,
X, _, _, X, X, X, X, _, _, _, _, X, X, X, X, X, X, X, X, X, X, X, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, X,
X, _, _, X, _, _, X, _, _, _, _, X, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, X, _, _, _, X, _, _, _, _, _, X,
X, _, _, X, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, X, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X,
X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, _, _, _, _, _, X, _, _, _, X, _, _, _, _, _, _, _, _, _, X,
X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X
}
