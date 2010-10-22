package 
{
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class Pump extends MovieClip 
	{
		var myRate:Number;
		
		public function Pump()
		{
			myRate = 0;
			WaterFlow.visible = false;
		}
		public function Update():void
		{
			if(myRate > 0)
			{
				WaterFlow.visible = true;
				myRate -= 0.15;
			}
			else
			{
				WaterFlow.visible = false;				
			}
			
			for(var i:Number=0; i< Math.min(3,myRate); i++)
			{
				if(currentFrame == totalFrames)
					gotoAndStop(1);
				this.nextFrame();
			}
		
		}
		
		public function doPump():void
		{
			myRate += 1;
		}
	}
}