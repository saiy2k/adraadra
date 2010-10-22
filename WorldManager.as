package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.external.ExternalInterface;

	public class  WorldManager extends EventDispatcher
	{
		var myTimer:Timer;
		var myTimerTicks:Number;
		var topper:Boolean;		
		public var myTimeRemaining:Number;
		private const TimeGiven:Number = 1500;
		
		private var myStage:MovieClip;
				
		public var myState:String;
		
		public function WorldManager(tStage:MovieClip)
		{
			trace("[AdraAdra.WorldManager] Construction");
			myStage = tStage;
			myTimer = new Timer(10);
			resetWorld();
			myState = GameState.LOADED;
		}
		public function resetWorld():void {
			myTimerTicks = 0;
			myTimeRemaining = 0;
			myState = GameState.READY;
		}
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
		public function myTimerTick(e:TimerEvent)
		{
			if (myState == GameState.PLAY)
			{
				myTimeRemaining--;
			}
		}
		public function OnClickPump(e:MouseEvent):void
		{
			if(myState == GameState.READY)
			{
				myState = GameState.PLAY;
				myTimerTicks = 0;
				myTimer.start();
				trace("[AdraAdra.WorldManager] Main Game Initiated");
			}
			myStage.myPot.Fill();
			myStage.myPump.doPump();
		}
		
		
		public function Update():void
		{
			if (myState == GameState.PLAY)
			{
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
				if(myStage.myPot.Update())
				{
					topper = false;
					if(myStage.myPlayer.Score < myTimeRemaining * 10)
					{
						myStage.myPlayer.Score = myTimeRemaining * 10;
						topper = true;
					}
					for(var i:int = 0; i < myStage.myUsers.length; i++)
					{
						if(myStage.myUsers[i].UID != myStage.myPlayer.UID)
						{
							if(myStage.myUsers[i].Score > myStage.myPlayer.UID)
							{
								topper = false;
							}
						}
						else
						{
							myStage.myUsers[i].Score = myStage.myPlayer.Score;
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
		
		private function OnPublish(e:Event):void
		{
			ExternalInterface.call("saysomething", "", myStage.myPlayer.Name, myTimeRemaining / 100.0, topper);
		}
	}
}