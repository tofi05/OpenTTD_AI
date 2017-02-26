


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


function Robot::postavKoleje(townid_a, townid_b){
	local pathfinder = RailPathFinder();
	
}


function Robot::postavZaleznicniStanici(twonId){

	local loc = AITown.GetLocation(twonId);
	local jeMoznaPostavit = false;
	local locaX = AIMap.GetTileX(loc);
	local locaY = AIMap.GetTileY(loc);
	while(!jeMoznaPostavit){
		AILog.Info("hledam misto pro zeleznicni stanici");
		local postavit = true;
		for(local x=locaX;x<locaX+8;x+=1){
			AILog.Info(x + " a " + locaY);
			local tileIndex = AIMap.GetTileIndex(x, locaY);
			if(!AITile.IsBuildable(tileIndex)){
				AILog.Info("stavitelny");
				postavit = false;
			}
		}
		if(postavit == true)
			jeMoznaPostavit = true;
		else
			locaX = locaX + 1;
	}
	// v�b�r typu kolej� - bez tohoto kroku nelze stav�t!
	AIRail.SetCurrentRailType(AIRailTypeList().Begin());

	// postav�me zast�vky - orientace vodorovn�, d�lka 4, v��ka 1,
	// parametry jsou: pozice, orientace, svisl� rozm�r, vodorovn� rozm�r, nov� stanice
	AIRail.BuildRailStation(AIMap.GetTileIndex(locaX, locaY), AIRail.RAILTRACK_NE_SW, 1, 7, AIStation.STATION_NEW);

}
