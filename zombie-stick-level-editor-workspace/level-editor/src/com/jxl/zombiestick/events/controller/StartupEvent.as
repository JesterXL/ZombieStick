package com.jxl.zombiestick.events.controller
{
	import com.jxl.zombiestick.vo.LevelVO;
	
	import flash.events.Event;
	
	public class StartupEvent extends Event
	{
		public static const STARTUP:String = "startup";
		
		public var level:LevelVO;
		
		public function StartupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}