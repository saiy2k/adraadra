/*
	Adra Adra - A simple flash facebook game based on OpenGraph API
    Copyright (C) 2010 Author: Saiyasodharan, JyothiSwaroop

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package {
	import fl.data.DataProvider;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.external.ExternalInterface;

	/*
	This is the main game engine. It controls all other parts of the game
	by passing control to them.
	
	This is the place where the user and their friends data are stored.
	Part of the data UserName and FB UID are passed from the PHP file
	The Score is retrieved based on the FB UID with the help of ServerConnect
	class.
	*/
	public class AdraAdra extends MovieClip
	{
		var myScreenManager:ScreenManager;		//Handles all the Game Screens
		var myWorldManager:WorldManager;		//Handles Game Screen and Game Logic
		public var myServerConnect:ServerConnect;//Connects with server to retrieve Score
		public var myPlayer:User;				//Player's Details
		public var myUsers:Array;				//Array of User objects to store friend's data
		public var IsPlaying;					//Boolean variable to indicate whether the user is in game screen or not
		
		//Player's UID, Name and Friend's UID, Name are passed
		//by calling this function after preloading is over.
		//Parameters:
		//tUID - UID of player
		//tName - Name of player
		//tFriendsName - Name of all friends separated by ','
		//tFriendsUID - UID's of all friends separated by ','
		public function SetValues(tUID:String, tName:String, tFriendsName:String, tFriendsUID:String)
		{
			trace("[AdraAdra] Construction");		
			
			//Initializing all the game objects
			myScreenManager = new ScreenManager(this);
			myWorldManager = new WorldManager(this);
			myServerConnect = new ServerConnect(this);
			
			//This function will populate the myPlayer object and myUsers array
			InitializeFriends(tUID, tName, tFriendsUID, tFriendsName);			
			
			//This function will setup the even handlers for all the game objects
			Initialize(tUID, tFriendsUID);
		}
		
		//Event listeners for all game objects are setup
		//Parameters:
		//tUID - UID of Player
		//tFriendsUID - UID of Friends
		private function Initialize(tUID:String, tFriendsUID:String):void
		{
			//setting up event listeners
			myServerConnect.addEventListener("OnServerData", onServerData);			
			myScreenManager.addEventListener("GameStarted", onGameStart);
			myWorldManager.addEventListener("GameWin", onGameWin);	
			this.addEventListener(Event.ENTER_FRAME, Update);
			
			//passing all the UID's to ServerConnect to retrieve the score
			var	tmpArray:Array = new Array();
			tmpArray.push(tUID);
			tmpArray.push(tFriendsUID.split(','));
			myServerConnect.RetrieveUsers(tmpArray);
			
			//Game not yet started
			IsPlaying = false;
		}
		
		//This is a event listener for 'GameStarted' event of
		//Screen Manager. It will be invoked whenever the game
		//screen is shown. But the real game is not started until
		//the user presses the pump for the first time.		
		private function onGameStart(e:Event):void
		{
			//making IsPlaying to true, so as to update the World Manager
			IsPlaying = true;
			//preparing the GameWorld for the player to start play
			myWorldManager.prepareStage();
		}
		
		//This is a event listener for 'GameWin' event of
		//World Manager. It will be invoked whenever the user
		//finishes the game.
		private function onGameWin(e:Event):void
		{
			//making IsPlaying to false, so as to stop updating World Manager
			IsPlaying = false;
			//Sort the players list again, as the new score might affect the rank
			SortFriends();
		}
		
		//populate the myPlayer and myUsers objects
		private function InitializeFriends(tUID:String, tName:String, tFriendsUID:String, tFriendsName:String):void
		{
			//splits the ',' separated data and creates an array for
			//both UID and Name
			var tmpUID:Array = tFriendsUID.split(',');
			var tmpName:Array = tFriendsName.split(',');
			var i:Number;
			
			myPlayer = new User();
			myUsers = new Array();
			
			//Set the values for myPlayer
			myPlayer.UID = tUID;
			myPlayer.Name = tName;
			myPlayer.Score = 0;
			myUsers.push(myPlayer);
			
			//Setting the values for all other players
			for(i = 0; i<tmpUID.length; i++)
			{
				var tmpUser:User = new User();
				tmpUser.UID = tmpUID[i];
				tmpUser.Name = tmpName[i];
				tmpUser.Score = 0;
				myUsers.push(tmpUser);
			}
		}
		
		//Update the myUsers array with the score data (which is in XML)
		//returned by ServerConnect
		private function onServerData(e:Event):void
		{
			//read retrieved data from ServerConnect
			var tmpData:XML;
			tmpData = myServerConnect.RetrievedUsers;
			
			var XMLUsers:XMLList = tmpData.user;
			
			//for each tag in XMLUsers repeat
			for (var i:int = 0; i < XMLUsers.length(); i++)
			{
				//for each users in myUsers repeat
				for(var j:int = 0; j < myUsers.length; j++)
				{
					//if the UID matches, set the score
					if(XMLUsers[i].@id == myUsers[j].UID)
					{
						//set the score for the user
						myUsers[j].Score = XMLUsers[i].@score;
						break;
					}
				}
			}
		}
		
		//Sort the myUsers array based on Score using Bubble Sort
		public function SortFriends():void
		{
			//I think no need for explaining bubble sort
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
			}
		}
		
		//Game Loop. Listener for ENTER_FRAME
		private function Update(e:Event):void
		{
			if(IsPlaying)
			{
				//Update World Manager if the game is running
				myWorldManager.Update();
			}
		}
		
		//helper function to display temporary messages in a textbox
		//will be removed in the future
		private function p(o:Object):void
		{
			this.txtDebug.appendText(o.toString() + "\n");
		}
	}
}