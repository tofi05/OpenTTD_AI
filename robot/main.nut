import("pathfinder.road", "RoadPathFinder", 3);
import("pathfinder.rail", "RailPathFinder", 1);
import("graph.aystar", "AyStar", 6);


class Robot extends AIController {
		function Start();
		function getTownListSorteBy(order);
		function postavCestu(townid_a, townid_b);
		function postavKoleje(townid_a, townid_b);
		function getClosesTown(townSite, newTown);
		function _cost(self, oldPath, newTile, newDirection);
		function _estimate(self, tile, direction, goalNodes);
		function _neighbours( self,	currentPath, node);
		function _directions(self, tile, existingDirection, newDirection);
//		function Save();
//		function Load(version, data);


	aystar = null;

	// constructor AI Modulu (zapisuje se dovnit� t��dy)
	constructor()
	{
		// vytvoreni instance A*
		this.aystar = AyStar(this,
				this._cost,
				this._estimate,
				this._neighbours,
				this._directions
		);
	}
	
}

require("roudBuilder.nut");
require("railBuilder.nut");




function Robot::Start() {
	local i = 1;
	while (!AICompany.SetName("Roboticka spolecnost " + i)){
		i = i + 1;
	}
	AILog.Info("Vznikla Roboticka spolecnost #" + i);
	
	
	//// staveni koleji aystar
	
	
local sources = [];
local goals = [];

// vlo�en� prvku do pole
sources.push([0xA810, 1]);
goals.push([0xF212, 0xF211]);

// v�b�r typu kolej� - bez tohoto kroku nelze stav�t!
AIRail.SetCurrentRailType(AIRailTypeList().Begin());

// postav�me zast�vky - orientace vodorovn�, d�lka 4, v��ka 1,
// parametry jsou: pozice, orientace, svisl� rozm�r, vodorovn� rozm�r, nov� stanice
AIRail.BuildRailStation(sources[0][0] - 4,
	AIRail.RAILTRACK_NE_SW, 1, 4, AIStation.STATION_NEW);
AIRail.BuildRailStation(goals[0][0] - 5,
	AIRail.RAILTRACK_NE_SW, 1, 4, AIStation.STATION_NEW);

this.aystar.InitializePath(sources, goals, []);
local path = false;
AILog.Info("Hledam cestu");
while (path == false) {
	path = this.aystar.FindPath(100);
	AILog.Info("Porad jeste hledam cestu");
}
if (path != null) {
	AILog.Info("Cesta nalezena, delka: " + path.GetLength());

	// odstran�me cedulky um�st�n� p�i prohled�v�n� A*
	foreach (idx, dSign in AISignList()) {
		AISign.RemoveSign(idx);
	}

	// projdeme spojov� seznam cesty
	// proch�zen� za��n� od konce cesty
	local current = path.GetParent().GetParent();
	local prev = path.GetParent().GetTile();
	local prevprev = path.GetTile();

	// napojeni zast�vky v c�li
	AIRail.BuildRail(goals[0][0],
		goals[0][0] - 1, goals[0][0] - 2);
	AIRail.BuildRail(prev, goals[0][0], goals[0][0] - 1);

	while (current != null) {
		// BuildRail ma parametr From, Tile, To
		// stav� se na pol��ku Tile, pol��ka From a To
		// ur�uj� sm�r koleji na pol��ku Tile
		local ret = AIRail.BuildRail(prevprev,
			prev, current.GetTile());
		prevprev = prev;
		prev = current.GetTile();
		// posun o jeden prvek cesty
		current = current.GetParent();
	}

	// napojen� zast�vky na za��tku
	AIRail.BuildRail(prevprev, prev, sources[0][0] - 1);

	// postaven� depa
	AIRail.BuildRailDepot(goals[0][0] - AIMap.GetMapSizeX(),
		goals[0][0]);

	// koleje k depu
	AIRail.BuildRailTrack(goals[0][0], AIRail.RAILTRACK_NE_SW);
	AIRail.BuildRailTrack(goals[0][0], AIRail.RAILTRACK_NW_NE);
	AIRail.BuildRailTrack(goals[0][0], AIRail.RAILTRACK_NW_SW);
	local depot = goals[0][0] - AIMap.GetMapSizeX();

	// seznam v�ech kolejov�ch vozidel
	local engList = AIEngineList(AIVehicle.VT_RAIL);

	// vybereme vozidla, kter� um� p�ev�et uhli (ma ID = 1)
	engList.Valuate(AIEngine.CanRefitCargo, 1);
	engList.KeepValue(1);

	// vybereme vozidla, kter� jsou vag�ny
	engList.Valuate(AIEngine.IsWagon);
	engList.KeepValue(1);
	local wagonType = engList.Begin();

	// seznam v�ech kolejov�ch vozidel
	engList = AIEngineList(AIVehicle.VT_RAIL);

	// vybereme v�echno, co nen� vag�n
	engList.Valuate(AIEngine.IsWagon);
	engList.KeepValue(0);

	local engineType = engList.Begin();
	// postav�me 5 vag�n�
	for (local i = 0; i < 5; i++) {
		AIVehicle.BuildVehicle(depot, wagonType);
	}

	// postav�me lokomotivu
	local train = AIVehicle.BuildVehicle(depot, engineType);

	// j�zdn� ��d
	AIOrder.AppendOrder(train, goals[0][0] - 2,
		AIOrder.AIOF_FULL_LOAD_ANY);
	AIOrder.AppendOrder(train, sources[0][0] - 1,
		AIOrder.AIOF_NONE);

	// spu�t�n� vlaku
	AIVehicle.StartStopVehicle(train);
}
	
	/// konec staven koleji aystar
	
	
	
	
	
	
	local townSite = AITownList();
	townSite.Clear();
	local sortedTownList = getTownListSorteBy(AITown.GetPopulation);
	
	local mestoA = sortedTownList.Begin();
	
	while(!sortedTownList.IsEnd()){
		townSite.AddItem(mestoA, sortedTownList.GetValue(mestoA))
		mestoA = sortedTownList.Next();
		local mestoB = getClosesTown(townSite, mestoA);
		postavCestu(mestoA, mestoB);
//		AILog.Info("Vypisuju tiky " + this.GetTick());
//		this.Sleep(50);
	} 
	
	
	
	//postavCestu(mesta[0], mesta[1]);
	
	
	
	
	
	
	while (true) {
			AILog.Info("Vypisuju tiky " + this.GetTick());
			this.Sleep(50);
		}
}

function Robot::getClosesTown(townSite, newTown){
	local townX = townSite.Begin();
	local actualTown = townX;
	local distance = 100000; 
	local townlist = AITownList();
	while(!townSite.IsEnd()){
		local name = AITown.GetName(actualTown);
		local aktualDistance = AIMap.DistanceManhattan(AITown.GetLocation(actualTown), AITown.GetLocation(newTown));
		AILog.Info(aktualDistance);
		if(distance>aktualDistance){
			townX = actualTown;
			distance = aktualDistance;
			AILog.Info("vylepsena vzdalenost " + distance);
		}
		actualTown = townSite.Next();
	}
	AILog.Info("nalezena vzdalenost " + distance);
	return townX;	
}

function Robot::getTownListSorteBy(order){
	
	/* Get a list of all towns on the map. */
	local townlist = AITownList();

	/* Sort the list by population, highest population first. */
	townlist.Valuate(order);
	townlist.Sort(AIAbstractList.SORT_BY_VALUE, false);
	
	return townlist;
}





/*
function Robot::Save()
{
	 //This function is outside the class declaration and requires the name of the class so squirrel can assign it to the right place.
}

function Robot::Load(version, data)
{

}
*/