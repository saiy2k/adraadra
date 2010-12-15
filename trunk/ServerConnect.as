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
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	
	public class ServerConnect extends EventDispatcher
	{
		private const myURLRetrieveUsers:String = "http://aagntzee.facebook.joyent.us/RetrieveUsers.php";
		private const myURLUpdateUser:String = "http://aagntzee.facebook.joyent.us/UpdateUser.php";
		private const myURLAddNewUser:String = "http://aagntzee.facebook.joyent.us/AddNewUser.php";
		
		public var RetrievedUsers:XML;
		
		var myStage:MovieClip;
		
		public function ServerConnect(tStage:MovieClip)
		{
			myStage = tStage;
		}
		
		public function RetrieveUsers(tUIDs:Array):void
		{
			var tmpLoader:URLLoader = new URLLoader();
			var tmpRequest:URLRequest = new URLRequest(myURLRetrieveUsers);
			var tmpVariable:URLVariables = new URLVariables();
			
			tmpVariable.dataFormat = URLLoaderDataFormat.VARIABLES;
			tmpVariable.decode("uids=" + tUIDs.join(","));
			tmpRequest.method = URLRequestMethod.POST;
			tmpRequest.data = tmpVariable;
			tmpLoader.load(tmpRequest);
			tmpLoader.addEventListener(Event.COMPLETE, onRetrieveUsersHL);	
		}
			
		private function onRetrieveUsersHL(e:Event):void
		{
			var tmpLoader:URLLoader = URLLoader(e.target);
			RetrievedUsers = XML(tmpLoader.data);
			//myStage.txtDebug.appendText("Dispatching OnServerData...\n" + RetrievedUsers + "\n");
			dispatchEvent(new Event("OnServerData"));
		}
		
		public function UpdateUser(tUID:String, tData:String):void
		{
			var tmpLoader:URLLoader = new URLLoader();
			var tmpRequest:URLRequest = new URLRequest(myURLUpdateUser);
			var tmpVariable:URLVariables = new URLVariables();
			
			tmpVariable.dataFormat = URLLoaderDataFormat.VARIABLES;		
			tmpVariable.decode("uid=" + tUID + "&score=" + tData);
			tmpRequest.method = URLRequestMethod.POST;
			tmpRequest.data = tmpVariable;
			tmpLoader.load(tmpRequest);
			tmpLoader.addEventListener(Event.COMPLETE, onUpdateUsersHL);				
		}
		private function onUpdateUsersHL(e:Event):void
		{
			var tmpLoader:URLLoader = URLLoader(e.target);
			p(tmpLoader.data);
		}
		
		public function AddNewUser(tUID:Number, tData:Number):void
		{			
			var tmpLoader:URLLoader = new URLLoader();
			var tmpRequest:URLRequest = new URLRequest(myURLAddNewUser);
			var tmpVariable:URLVariables = new URLVariables();
			
			tmpVariable.dataFormat = URLLoaderDataFormat.VARIABLES;		
			tmpVariable.decode("uid=" + tUID + "&score=" + tData);
			tmpRequest.method = URLRequestMethod.POST;
			tmpRequest.data = tmpVariable;
			tmpLoader.load(tmpRequest);
		}
		
		private function p(o:Object):void
		{
			myStage.txtDebug.appendText(String(o));
		}
	}
}