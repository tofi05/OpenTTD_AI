
class Robot extends AIInfo {	
	function GetAuthor() 	  { return "Newbie AI Writer"; }
	function GetName()        { return "Robot"; }
	function GetDescription() { return "An example AI by following the tutorial at http://wiki.openttd.org/"; }
  	function GetVersion()     { return 1; }
  	function GetDate()        { return "2017-02-13"; }
  	function CreateInstance() { return "Robot"; }
  	function GetShortName()   { return "TOFI"; }
  	function GetAPIVersion()  { return "1.0"; }
}

/* Tell the core we are an AI */
RegisterAI(Robot());