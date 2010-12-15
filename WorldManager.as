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

package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.external.ExternalInterface;

	/*
	This is main game engine, where the actual gameplay is taken care of.
	*/
	public class  WorldManager extends EventDispatcher
	{
		var myTimer:Timer;				//timer to keep track of game time
		var topper:Boolean;				//whether the user is the top scorer, used after the game is over
		public var myTimeRemaining:Number;		//holds the remaining time at any given time
		private const TimeGiven:Number = 1500;		//total time given, 15 seconds
		
		private var myStage:MovieClip;			//reference to current stage
				
		public var myState:String;			//holds current state of the game like READY, PLAY
		
		//Constructor
		public function WorldManager(tStage:MovieClip)
		{
			trace("[AdraAdra.WorldManager] Construction");
			myStage = tStage;
			myTimer = new Timer(10);
			resetWorld();
			myState = GameState.LOADED;
		}

		//resets the game world
		public function resetWorld():void {
			myTimeRemaining = 0;
			myState = GameState.READY;
		}
		
		//real reset function
		public function prepareStage():void
		{
			resetWorld();
			myTimer.addEventListener(TimerEvent.TIMER,myTimerTick);
			myStage.myPump.addEventListener(MouseEvent.CLICK, OnClickPump);
			myStage.myPot.Reset();
			myStage.GameOverStatusBG.visible = false;
			myStage.GameOverStatusText.visible = false;
			myStage.GameOverStatusTryAgain.visible = false;
			myStage.GameOverStatusPublish.visible = false;			
			myTimeRemaining = TimeGiven;
			myStage.myTimeBar.width = myTimeRemaining / TimeGiven * 100;
			myStage.txtTime.text = myTimeRemaining;
		}

		//decrements time remaining as the timer ticks
		public function myTimerTick(e:TimerEvent)
		{
			if (myState == GameState.PLAY)
			{
				myTimeRemaining--;
			}
		}

		//fills the pot when the pump is clicked
		public function OnClickPump(e:MouseEvent):void
		{
			//starts the game, if its not yet started
			if(myState == GameState.READY)
			{
				myState = GameState.PLAY;
				myTimer.start();
				trace("[AdraAdra.WorldManager] Main Game Initiated");
			}
			myStage.myPot.Fill();
			myStage.myPump.doPump();
		}
		
		//game loop
		public function Update():void
		{
			if (myState == GameState.PLAY)
			{
				//game over if time remaining < 0
				if(myTimeRemaining <= 0)
				{
					myStage.GameOverStatusBG.visible = true;
					myStage.GameOverStatusText.visible = true;
					myStage.GameOverStatusTryAgain.visible = true;
					myStage.GameOverStatusText.text = "Sorry!!! You lose.";
					myStage.GameOverStatusTryAgain.addEventListener(MouseEvent.CLICK, OnTryAgain);
					myState = GameState.LOSE;
					trace("[AdraAdra.WorldManager] Lose Game");					
				}
				myStage.myPump.Update();

				//pot.Update returns true if the pot is filled,
				if(myStage.myPot.Update())
				{
					topper = false;
					//updates myPlayer object of the stage with the current score
					if(myStage.myPlayer.Score < myTimeRemaining * 10)
					{
						myStage.myPlayer.Score = myTimeRemaining * 10;
						topper = true;
					}

					//checks with all other player's score to see, if the current score is the top score
					for(var i:int = 0; i < myStage.myUsers.length; i++)
					{
						//if any other player's score is higher than current player's score, then set topper as false and exit loop
						if(myStage.myUsers[i].UID != myStage.myPlayer.UID)
						{
							if(myStage.myUsers[i].Score > myStage.myPlayer.UID)
							{
								topper = false;
								break;
							}
						}
						else
						{
							//update the current score in myUsers array (remember current user data is store twice, once in myPlayer and other in myUsers)
							myStage.myUsers[i].Score = myStage.myPlayer.Score;
							//update the current score in database
							myStage.myServerConnect.UpdateUser(myStage.myPlayer.UID, String(myStage.myPlayer.Score));
						}
					}
					
					myState = GameState.WIN;
					myStage.GameOverStatusBG.visible = true;
					myStage.GameOverStatusText.visible = true;
					myStage.GameOverStatusPublish.visible = true;			
					myStage.GameOverStatusText.text = "Congratulation!!! You filled the pot within time\n";
					if(topper)
					{
						myStage.GameOverStatusText.appendText = "and you are the BEST among your friends";
					}
					myStage.GameOverStatusPublish.addEventListener(MouseEvent.CLICK, OnPublish);					
					dispatchEvent(new Event("GameWin"));
					trace("[AdraAdra.WorldManager] Won Game");
				}
				myStage.myTimeBar.width = myTimeRemaining / TimeGiven * 100;
				myStage.txtTime.text = myTimeRemaining / 100;
			}
		}	
		
		public function OnTryAgain(e:MouseEvent):void
		{
			prepareStage();
		}
		
		//calls the saysomething javascript function, that displays the FB post dialog box, with the player name and currentscore
		private function OnPublish(e:Event):void
		{
			ExternalInterface.call("saysomething", "", myStage.myPlayer.Name, myTimeRemaining / 100.0, topper);
		}
	}
}