import("pathfinder.road", "RoadPathFinder", 3);
import("pathfinder.rail", "RailPathFinder", 1);
import("graph.aystar", "AyStar", 6);


class Robot extends AIController {
		function Start();
		function getTownListSorteBy(order);
		function postavCestu(townid_a, townid_b);
		function postavKoleje(townid_a, townid_b);
		function postavZaleznicniStanici(twonId);
		function getClosesTown(townSite, newTown);
		function _cost(self, oldPath, newTile, newDirection);
		function _estimate(self, tile, direction, goalNodes);
		function _neighbours( self,	currentPath, node);
		function _directions(self, tile, existingDirection, newDirection);
//		function Save();
//		function Load(version, data);


	aystar = null;

	// constructor AI Modulu (zapisuje se dovnitø tøídy)
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
	

	
	
	
	
	
	
	local townSite = AITownList();
	townSite.Clear();
	local sortedTownList = getTownListSorteBy(AITown.GetPopulation);
	
	local mestoA = sortedTownList.Begin();
	
	while(!sortedTownList.IsEnd()){
		townSite.AddItem(mestoA, sortedTownList.GetValue(mestoA))
		mestoA = sortedTownList.Next();
		local mestoB = getClosesTown(townSite, mestoA);
		postavZaleznicniStanici(mestoA);
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