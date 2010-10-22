package 
{
	import fl.data.DataProvider;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.text.TextFormat;
	import flash.media.SoundMixer;	
	import flash.media.SoundTransform;	
	
	public class ScreenManager  extends EventDispatcher
	{
		private var myStage:MovieClip;
		private var myPreviousScreen:String;
		private var myCurrentScreen:String;
		private var myDataProvider:DataProvider;
		
		private var mySound:Boolean;
		
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
		
		private function btnSound_Click(e:MouseEvent):void
		{
			SoundMixer.soundTransform = new SoundTransform(1);
			myStage.btnSound.visible = false;
			myStage.btnPause.visible = true;
			mySound = true;
		}
		
		private function btnPause_Click(e:MouseEvent):void
		{
			SoundMixer.soundTransform = new SoundTransform(0);
			myStage.btnSound.visible = true;
			myStage.btnPause.visible = false;
			mySound = false;
		}
		
		private function btnStart_Click(e:MouseEvent):void
		{
			myCurrentScreen = "Game";
			myPreviousScreen = "Menu";
			myStage.gotoAndStop(myCurrentScreen);	
			dispatchEvent(new Event("GameStarted"));
			myStage.btnGameClose.addEventListener(MouseEvent.CLICK, btnGameClose_Click);			
		}
		
		private function btnInstructions_Click(e:MouseEvent):void 
		{
			myCurrentScreen = "Instructions";
			myPreviousScreen = "Menu";
			myStage.gotoAndStop(myCurrentScreen);
			myStage.btnInstructionsClose.addEventListener(MouseEvent.CLICK, btnInstructionsClose_Click);
		}
		
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
		
		private function btnHOF_Click(e:MouseEvent):void 
		{
			var i:Number;
			var dp:DataProvider = new DataProvider();
			myCurrentScreen = "HallOfFame";
			myPreviousScreen = "Menu";
			myStage.gotoAndStop(myCurrentScreen);
			myStage.btnHallOfFameClose.addEventListener(MouseEvent.CLICK, btnHallOfFameClose_Click);				
				
			var tmpEngine:AdraAdra = myStage as AdraAdra;
			tmpEngine.SortFriends();
			var tmpFriends:Array = tmpEngine.myUsers;
			
			var tf:TextFormat = new TextFormat();
			tf.color = 0x000000;
			tf.font = "Courier";
			tf.size = 12;
			tmpEngine.myScoreList.setRendererStyle('textFormat',tf);		
			
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
		
		private function btnCredits_Click(e:MouseEvent):void 
		{
			myCurrentScreen = "Credits";
			myPreviousScreen = "Menu";
			myStage.gotoAndStop(myCurrentScreen);
			myStage.btnCreditsClose.addEventListener(MouseEvent.CLICK, btnCreditsClose_Click);
		}
		
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
