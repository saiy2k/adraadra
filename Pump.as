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