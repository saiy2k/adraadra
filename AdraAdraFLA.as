package 
{
	import flash.display.MovieClip;
	
	public class AdraAdraFLA extends MovieClip 
	{
		var myEngine:AdraAdra;
		public function AdraAdraFLA()
		{
			myEngine = new AdraAdra();
			myEngine.x = 320;// stage.width / 2;
			myEngine.y = 240;// stage.height / 2;
			addChild(myEngine);
		}
	}
}