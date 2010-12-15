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