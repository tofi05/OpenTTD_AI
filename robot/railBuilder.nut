


// Metody AI modulu (zapisuji se mimo tøídu!)

// g() funkce A* algoritmu
function Robot::_cost(/* Katureel */ self,
		/* Aystar.Path */ oldPath,
		/* TileIndex */ newTile,
		/* integer */ newDirection)
{
	if (oldPath != null) {
		return oldPath.GetLength() + 1;
	} else {
		return 1;
	}
}

// h() funkce A* algoritmu
function Robot::_estimate(/* Katureel */ self,
		/* tileindex */ tile,
		/* integer */ direction,
		/* array[tileindex, direction] */ goalNodes)
{
	// políèko, kterým algoritmus prošel oznaèíme cedulkou
	local result = AIMap.DistanceManhattan(tile, goalNodes[0][0]);
//	AISign.BuildSign(tile, result);
	return result;
}

// funkce pro generování stavu
function Robot::_neighbours(/* Katureel */ self,
		/* Aystar.Path */ currentPath,
		/* tileindex */ node)
{
	// posuny ve smìru X, Y
	local offsets = [1, // posun na ose X doleva
		-1, // posun na ose X doprava
		AIMap.GetMapSizeX(), // posun na ose Y dolù
		-AIMap.GetMapSizeX() // posun na ose Y nahoru
		];
	local newTile;
	local result = [];

	// každý posun pøièteme k aktuálnímu TileIndexu
	// a dostaneme tak sousedy
	foreach (offset in offsets) {
		newTile = node + offset;
		// políèko není na svahu a je na nìm možné stavìt
		if ((AITile.GetSlope(newTile) == AITile.SLOPE_FLAT)
				&& AITile.IsBuildable(newTile)) {
			result.push([newTile, 1]);
		}
	}
	return result;
}

function Robot::_directions(self,
		tile,
		existingDirection,
		newDirection)
{
	return false;
}


