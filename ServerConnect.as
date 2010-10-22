package {
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	
	public class ServerConnect extends EventDispatcher
	{
		private const myURLRetrieveUsers:String = "http://aagntzee.facebook.joyent.us/RetrieveUsers.php";
		private const myURLUpdateUser:String = "http://aagntzee.facebook.joyent.us/UpdateUser.php";
		private const myURLAddNewUser:String = "http://aagntzee.facebook.joyent.us/AddNewUser.php";
		
		public var RetrievedUsers:XML;
		
		var myStage:MovieClip;
		
		public function ServerConnect(tStage:MovieClip)
		{
			myStage = tStage;
		}
		
		public function RetrieveUsers(tUIDs:Array):void
		{
			var tmpLoader:URLLoader = new URLLoader();
			var tmpRequest:URLRequest = new URLRequest(myURLRetrieveUsers);
			var tmpVariable:URLVariables = new URLVariables();
			
			tmpVariable.dataFormat = URLLoaderDataFormat.VARIABLES;
			tmpVariable.decode("uids=" + tUIDs.join(","));
			tmpRequest.method = URLRequestMethod.POST;
			tmpRequest.data = tmpVariable;
			tmpLoader.load(tmpRequest);
			tmpLoader.addEventListener(Event.COMPLETE, onRetrieveUsersHL);	
		}
			
		private function onRetrieveUsersHL(e:Event):void
		{
			var tmpLoader:URLLoader = URLLoader(e.target);
			RetrievedUsers = XML(tmpLoader.data);
			//myStage.txtDebug.appendText("Dispatching OnServerData...\n" + RetrievedUsers + "\n");
			dispatchEvent(new Event("OnServerData"));
		}
		
		public function UpdateUser(tUID:String, tData:String):void
		{
			var tmpLoader:URLLoader = new URLLoader();
			var tmpRequest:URLRequest = new URLRequest(myURLUpdateUser);
			var tmpVariable:URLVariables = new URLVariables();
			
			tmpVariable.dataFormat = URLLoaderDataFormat.VARIABLES;		
			tmpVariable.decode("uid=" + tUID + "&score=" + tData);
			tmpRequest.method = URLRequestMethod.POST;
			tmpRequest.data = tmpVariable;
			tmpLoader.load(tmpRequest);
			tmpLoader.addEventListener(Event.COMPLETE, onUpdateUsersHL);				
		}
		private function onUpdateUsersHL(e:Event):void
		{
			var tmpLoader:URLLoader = URLLoader(e.target);
			p(tmpLoader.data);
		}
		
		public function AddNewUser(tUID:Number, tData:Number):void
		{			
			var tmpLoader:URLLoader = new URLLoader();
			var tmpRequest:URLRequest = new URLRequest(myURLAddNewUser);
			var tmpVariable:URLVariables = new URLVariables();
			
			tmpVariable.dataFormat = URLLoaderDataFormat.VARIABLES;		
			tmpVariable.decode("uid=" + tUID + "&score=" + tData);
			tmpRequest.method = URLRequestMethod.POST;
			tmpRequest.data = tmpVariable;
			tmpLoader.load(tmpRequest);
		}
		
		private function p(o:Object):void
		{
			myStage.txtDebug.appendText(String(o));
		}
	}
}