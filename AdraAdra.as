package {
	import fl.data.DataProvider;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.external.ExternalInterface;

	public class AdraAdra extends MovieClip
	{
		var myScreenManager:ScreenManager;		//Handles all the Game Screens
		var myWorldManager:WorldManager;		//Handles Game Screen and Game Logic
		//var mySoundManager:SoundManager;		//Handles Game BGs and other Sounds
		public var myServerConnect:ServerConnect;		//Connects with server to retrieve Score
		public var myPlayer:User;				//Player's Details
		public var myUsers:Array;
		public var IsPlaying;
							
		public function SetValues(tUID:String, tName:String, tFriendsName:String, tFriendsUID:String)
		{
			trace("[AdraAdra] Construction");		
			
			myScreenManager = new ScreenManager(this);
			myWorldManager = new WorldManager(this);
			myServerConnect = new ServerConnect(this);
			
			//mySoundManager = new SoundManager();
			
			InitializeFriends(tUID, tName, tFriendsUID, tFriendsName);			
			Initialize(tUID, tFriendsUID);
			
			//mySoundManager.BGMPlayback("play");
		}
		
		private function Initialize(tUID:String, tFriendsUID:String):void
		{
			myServerConnect.addEventListener("OnServerData", onServerData);			
			myScreenManager.addEventListener("GameStarted", onGameStart);
			myWorldManager.addEventListener("GameOver", onGameOver);
			myWorldManager.addEventListener("GameWin", onGameWin);	
			this.addEventListener(Event.ENTER_FRAME, Update);
			
			var	tmpArray:Array = new Array();
			tmpArray.push(tUID);
			tmpArray.push(tFriendsUID.split(','));
			myServerConnect.RetrieveUsers(tmpArray);
			
			IsPlaying = false;
		}
		
		private function onGameStart(e:Event):void
		{
			IsPlaying = true;
			myWorldManager.prepareStage();
		}
		
		private function onGameOver(e:Event):void
		{
			IsPlaying = false;
		}
		
		private function onGameWin(e:Event):void
		{
			SortFriends();
		}
		
		private function InitializeFriends(tUID:String, tName:String, tFriendsUID:String, tFriendsName:String):void
		{
			var tmpUID:Array = tFriendsUID.split(',');
			var tmpName:Array = tFriendsName.split(',');
			var i:Number;
			
			myPlayer = new User();
			myUsers = new Array();
			
			myPlayer.UID = tUID;
			myPlayer.Name = tName;
			myPlayer.Score = 0;
			myUsers.push(myPlayer);
			
			for(i = 0; i<tmpUID.length; i++)
			{
				var tmpUser:User = new User();
				tmpUser.UID = tmpUID[i];
				tmpUser.Name = tmpName[i];
				tmpUser.Score = 0;
				myUsers.push(tmpUser);
			}
		}
		
		private function onServerData(e:Event):void
		{
			var tmpData:XML;
			tmpData = myServerConnect.RetrievedUsers;
			
			p("Got Server Data...");
			
			var XMLUsers:XMLList = tmpData.user;
			
			for (var i:int = 0; i < XMLUsers.length(); i++)
			{
				for(var j:int = 0; j < myUsers.length; j++)
				{
					if(XMLUsers[i].@id == myUsers[j].UID)
					{
						myUsers[j].Score = XMLUsers[i].@score;
						p(myUsers[j].Name);
						p(myUsers[j].Score);
						break;
					}
				}
			}
		}
		
		public function SortFriends():void
		{
			for(var i:int = 0; i < myUsers.length - 1; i++)
			{
				for(var j:int = i + 1; j < myUsers.length; j++)
				{
					if(myUsers[i].Score < myUsers[j].Score)
					{
						var tmpUser:User;
						tmpUser = new User();
						tmpUser.UID = myUsers[i].UID;
						tmpUser.Name = myUsers[i].Name;
						tmpUser.Score = myUsers[i].Score;
						
						myUsers[i].UID = myUsers[j].UID;
						myUsers[i].Name = myUsers[j].Name;
						myUsers[i].Score = myUsers[j].Score;

						myUsers[j].UID = tmpUser.UID;
						myUsers[j].Name = tmpUser.Name;
						myUsers[j].Score = tmpUser.Score;
					}
				}
				//this.txtDebug.appendText(myUsers[i].Score + "\n");
			}
		}
		
		private function Update(e:Event):void
		{
			if(IsPlaying)
			{
				myWorldManager.Update();
			}
		}
		
		public function Publish():void
		{
			
			p("publishing/./");
		}
		
		private function p(o:Object):void
		{
			this.txtDebug.appendText(o.toString() + "\n");
		}
	}
}