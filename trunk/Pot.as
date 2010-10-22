package {
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public class Pot extends MovieClip {
		var myCapacity:Number;
		var myFilled:Number;
		var myOutRate:Dictionary;
		var myGameEndState:Boolean;

		public function Pot() {
			myOutRate=new Dictionary(false);
			myOutRate[40]=0;
			myOutRate[80]=0.07;
			myOutRate[100]=0.15;
			myCapacity=100;
			
		}
		
		public function Reset(): void
		{
			myFilled=0;
			Update();
		}
		
		public function Update():Boolean {
			if (myFilled>0.0&&myFilled<=100.0) {
				for (var key:Object in myOutRate) {
					if (myFilled<int(key)) {
						myFilled-=Number(myOutRate[key]);
						break;
					}
				}
			} else if (myFilled>100) {
				return true;
			}
			gotoAndStop(int(myFilled));
			return false;
		}
		
		public function Fill():void {
			myFilled += 2;
		}
	}
}