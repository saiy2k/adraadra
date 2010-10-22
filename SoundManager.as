package 
{
	import flash.media.*;
	import flash.net.*;
	
	public class  SoundManager 
	{
		var BGMsound:String;
		var Auxsound:String;
		
		var mySoundBGM:Sound;
		var mySoundAux:Sound;
		
		var myBGMChannel:SoundChannel;
		
		public function SoundManager()
		{
			mySoundAux = new Sound();
			mySoundBGM = new AdraAdraBGM();
			
		}
		
		public function BGMPlayback(Command:String)
		{
			switch(Command)
			{
				case "play":
				myBGMChannel=mySoundBGM.play();
				break;
				case "pause":
				break;
				case "stop":
				myBGMChannel.stop();
				break;
				case "mute":
				break;
				case "change":
				break;
			}
		}
		public function AuxPlayback(AuxKey:Number,Command:String)
		{
			switch(Command)
			{
				case "play":
				break;
				case "pause":
				break;
				case "stop":
				break;
				case "mute":
				break;
			}
		}
	}
	
}