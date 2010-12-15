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