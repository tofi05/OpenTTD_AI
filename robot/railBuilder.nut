


// Metody AI modulu (zapisuji se mimo t��du!)

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
	// pol��ko, kter�m algoritmus pro�el ozna��me cedulkou
	local result = AIMap.DistanceManhattan(tile, goalNodes[0][0]);
//	AISign.BuildSign(tile, result);
	return result;
}

// funkce pro generov�n� stavu
function Robot::_neighbours(/* Katureel */ self,
		/* Aystar.Path */ currentPath,
		/* tileindex */ node)
{
	// posuny ve sm�ru X, Y
	local offsets = [1, // posun na ose X doleva
		-1, // posun na ose X doprava
		AIMap.GetMapSizeX(), // posun na ose Y dol�
		-AIMap.GetMapSizeX() // posun na ose Y nahoru
		];
	local newTile;
	local result = [];

	// ka�d� posun p�i�teme k aktu�ln�mu TileIndexu
	// a dostaneme tak sousedy
	foreach (offset in offsets) {
		newTile = node + offset;
		// pol��ko nen� na svahu a je na n�m mo�n� stav�t
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


