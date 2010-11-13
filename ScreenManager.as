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
	import fl.data.DataProvider;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.text.TextFormat;
	import flash.media.SoundMixer;	
	import flash.media.SoundTransform;
	
	/*
	This class helps in navigating between different menus
	There are totally 5 frames labelled:
	1. Menu
	2. Instruction
	3. HallOfFame
	4. Credits
	5. Game
	All the frames have required controls to navigate to other screens
	
	This class registers event listeners for navigation controls and
	changes the game screen when appropriate controls are clicked.
	*/
	public class ScreenManager extends EventDispatcher
	{
		private var myStage:MovieClip;				//reference to AdraAdra
		private var myPreviousScreen:String;		//previous screen
		private var myCurrentScreen:String;			//current screen
		private var myDataProvider:DataProvider;	//to hold data to display in Hall of Fame
		
		private var mySound:Boolean;				//Music - ON / OFF
		
		//Construtor
		//show the Menu screen and registers necessary event handlers
		public function ScreenManager(tStage:MovieClip)
		{
			trace("[AdraAdra.ScreenManager] Construction");
			myStage = tStage;
			
			myCurrentScreen = "Menu";
			myPreviousScreen = "Menu";
			myStage.btnStart.addEventListener(MouseEvent.CLICK, btnStart_Click);
			myStage.btnInstructions.addEventListener(MouseEvent.CLICK, btnInstructions_Click);
			myStage.btnHOF.addEventListener(MouseEvent.CLICK, btnHOF_Click);			
			myStage.btnCredits.addEventListener(MouseEvent.CLICK, btnCredits_Click);
			myStage.btnSound.addEventListener(MouseEvent.CLICK, btnSound_Click);
			myStage.btnPause.addEventListener(MouseEvent.CLICK, btnPause_Click);
			myStage.btnSound.visible = false;
			
			mySound = true;
		}
		
		//UnMute sound when pressed
		private function btnSound_Click(e:MouseEvent):void
		{
			SoundMixer.soundTransform = new SoundTransform(1);
			myStage.btnSound.visible = false;
			myStage.btnPause.visible = true;
			mySound = true;
		}
		
		//Mute sound when pressed
		private function btnPause_Click(e:MouseEvent):void
		{
			SoundMixer.soundTransform = new SoundTransform(0);
			myStage.btnSound.visible = true;
			myStage.btnPause.visible = false;
			mySound = false;
		}
		
		//move to game screen and dispatch 'GameStarted' event
		private function btnStart_Click(e:MouseEvent):void
		{
			myCurrentScreen = "Game";
			myPreviousScreen = "Menu";
			myStage.gotoAndStop(myCurrentScreen);	
			dispatchEvent(new Event("GameStarted"));
			myStage.btnGameClose.addEventListener(MouseEvent.CLICK, btnGameClose_Click);			
		}
		
		//move to instruction screen
		private function btnInstructions_Click(e:MouseEvent):void 
		{
			myCurrentScreen = "Instructions";
			myPreviousScreen = "Menu";
			myStage.gotoAndStop(myCurrentScreen);
			myStage.btnInstructionsClose.addEventListener(MouseEvent.CLICK, btnInstructionsClose_Click);
		}
		
		//close instruction screen and move back to main menu
		private function btnInstructionsClose_Click(e:Event):void 
		{
			myCurrentScreen = myPreviousScreen;
			myPreviousScreen = "Instructions";
			myStage.gotoAndStop(myCurrentScreen);
			
			myStage.btnStart.addEventListener(MouseEvent.CLICK, btnStart_Click);
			myStage.btnInstructions.addEventListener(MouseEvent.CLICK, btnInstructions_Click);
			myStage.btnHOF.addEventListener(MouseEvent.CLICK, btnHOF_Click);			
			myStage.btnCredits.addEventListener(MouseEvent.CLICK, btnCredits_Click);
			myStage.btnSound.addEventListener(MouseEvent.CLICK, btnSound_Click);
			myStage.btnPause.addEventListener(MouseEvent.CLICK, btnPause_Click);
			if(mySound)
			{
				myStage.btnPause.visible = true;
				myStage.btnSound.visible = false;
			}
			else
			{
				myStage.btnPause.visible = false;
				myStage.btnSound.visible = true;
			}			
		}
		
		//move to Hall of Fame frame and shows the current score list
		private function btnHOF_Click(e:MouseEvent):void 
		{
			var i:Number;
			var dp:DataProvider = new DataProvider();
			myCurrentScreen = "HallOfFame";
			myPreviousScreen = "Menu";
			myStage.gotoAndStop(myCurrentScreen);
			myStage.btnHallOfFameClose.addEventListener(MouseEvent.CLICK, btnHallOfFameClose_Click);				
			
			//sort and retrieve users list from GameEngine
			var tmpEngine:AdraAdra = myStage as AdraAdra;
			tmpEngine.SortFriends();
			var tmpFriends:Array = tmpEngine.myUsers;
			
			var tf:TextFormat = new TextFormat();
			tf.color = 0x000000;
			tf.font = "Courier";
			tf.size = 12;
			tmpEngine.myScoreList.setRendererStyle('textFormat',tf);		
			
			//Add Name and Score of all players to the dataprovider
			for(i = 0; i < tmpFriends.length; i++)
			{
				var strItem:String = tmpFriends[i].Name;
				var len:Number = 45 - strItem.length
				for(var j:int = 0; j < len; j++)
					strItem = strItem.concat(" ");
				strItem = strItem.concat(tmpFriends[i].Score);
				dp.addItem({label:strItem, data:tmpFriends[i].Score});
			}
			
			tmpEngine.myScoreList.dataProvider = dp;

		}
		
		//move to Credits screen
		private function btnCredits_Click(e:MouseEvent):void 
		{
			myCurrentScreen = "Credits";
			myPreviousScreen = "Menu";
			myStage.gotoAndStop(myCurrentScreen);
			myStage.btnCreditsClose.addEventListener(MouseEvent.CLICK, btnCreditsClose_Click);
		}
		
		//quit game and move to main menu
		private function btnGameClose_Click(e:MouseEvent):void 
		{
			myCurrentScreen = "Menu";
			myPreviousScreen = "Menu";
			myStage.gotoAndStop("Menu");
			myStage.btnStart.addEventListener(MouseEvent.CLICK, btnStart_Click);
			myStage.btnInstructions.addEventListener(MouseEvent.CLICK, btnInstructions_Click);
			myStage.btnHOF.addEventListener(MouseEvent.CLICK, btnHOF_Click);			
			myStage.btnCredits.addEventListener(MouseEvent.CLICK, btnCredits_Click);
			myStage.btnSound.addEventListener(MouseEvent.CLICK, btnSound_Click);
			myStage.btnPause.addEventListener(MouseEvent.CLICK, btnPause_Click);
			if(mySound)
			{
				myStage.btnPause.visible = true;
				myStage.btnSound.visible = false;
			}
			else
			{
				myStage.btnPause.visible = false;
				myStage.btnSound.visible = true;
			}				
		}
		
		//closes credits screen and move to menu
		private function btnCreditsClose_Click(e:Event):void 
		{
			myCurrentScreen = myPreviousScreen;
			myPreviousScreen = "Credits";
			myStage.gotoAndStop(myCurrentScreen);
			
			myStage.btnStart.addEventListener(MouseEvent.CLICK, btnStart_Click);
			myStage.btnInstructions.addEventListener(MouseEvent.CLICK, btnInstructions_Click);
			myStage.btnHOF.addEventListener(MouseEvent.CLICK, btnHOF_Click);			
			myStage.btnCredits.addEventListener(MouseEvent.CLICK, btnCredits_Click);
			myStage.btnSound.addEventListener(MouseEvent.CLICK, btnSound_Click);
			myStage.btnPause.addEventListener(MouseEvent.CLICK, btnPause_Click);
			if(mySound)
			{
				myStage.btnPause.visible = true;
				myStage.btnSound.visible = false;
			}
			else
			{
				myStage.btnPause.visible = false;
				myStage.btnSound.visible = true;
			}				
		}
		
		//close Hall of Fame and move to menu
		private function btnHallOfFameClose_Click(e:Event):void 
		{
			myCurrentScreen = "Menu";
			myPreviousScreen = "Instructions";
			myStage.gotoAndStop(myCurrentScreen);
			
			myStage.btnStart.addEventListener(MouseEvent.CLICK, btnStart_Click);
			myStage.btnInstructions.addEventListener(MouseEvent.CLICK, btnInstructions_Click);
			myStage.btnHOF.addEventListener(MouseEvent.CLICK, btnHOF_Click);			
			myStage.btnCredits.addEventListener(MouseEvent.CLICK, btnCredits_Click);
			myStage.btnSound.addEventListener(MouseEvent.CLICK, btnSound_Click);
			myStage.btnPause.addEventListener(MouseEvent.CLICK, btnPause_Click);
			if(mySound)
			{
				myStage.btnPause.visible = true;
				myStage.btnSound.visible = false;
			}
			else
			{
				myStage.btnPause.visible = false;
				myStage.btnSound.visible = true;
			}				
		}
	}	
}
