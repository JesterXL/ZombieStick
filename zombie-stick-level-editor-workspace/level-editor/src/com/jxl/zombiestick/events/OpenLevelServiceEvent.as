package com.jxl.zombiestick.events
{
	import flash.events.Event;
	
	public class OpenLevelServiceEvent extends Event
	{
		public static const SUCCESS:String = "success";
		
		public function OpenLevelServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}