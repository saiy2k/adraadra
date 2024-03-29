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