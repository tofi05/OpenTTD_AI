

class Robot extends AIController {
  	function Start();
  	function Save();
  	function Load(version, data);
}

function Robot::Start() {
	while (true) {
    	AILog.Info("I am a very new AI with a ticker called MyNewAI and I am at tick " + this.GetTick());
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