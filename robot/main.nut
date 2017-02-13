

class Robot extends AIController {
  	function Start();
  	function Save();
  	function Load(version, data);
}

function Robot::Start() {
	local i = 1;
	while (!AICompany.SetName("Roboticka spolecnost " + i)){
		i = i + 1;
	}
	AILog.Info("Vznikla Roboticka spolecnost #" + i);
	while (true) {
    	AILog.Info("Vypisuju tiky " + this.GetTick());
    	this.Sleep(50);
  	}
}

function Robot::Save()
{
   //This function is outside the class declaration and requires the name of the class so squirrel can assign it to the right place.
}

function Robot::Load(version, data)
{
}