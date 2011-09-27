package com.jxl.zombiestick.events
{
	import flash.events.Event;
	
	public class SaveLevelServiceEvent extends Event
	{
		
		public static const SUCCESS:String = "success";
		
		public function SaveLevelServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}