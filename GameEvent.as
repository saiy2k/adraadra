package 
{
	import flash.events.Event;
	
	public class GameEvent extends Event 
	{
		public static const  REQUEST_COMPLETE:String = "Request_Complete";
		
		public var ID:String;
		public var Data:String;
		public function GameEvent(EventID:String, EventData:String)//Previously XML
		{
			super(EventID);			
			ID = EventID;
			Data = EventData;
		}
	}
	
}