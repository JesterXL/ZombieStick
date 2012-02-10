package com.jxl.zombiestick.events.view
{
	import flash.events.Event;
	
	public class PropertiesPanelEvent extends Event
	{
		
		public static const MOVE_GAME_OBJECTS:String = "moveGameObjects";
		public static const RESIZE_GAME_OBJECTS:String = "resizeGameObjects";
		
		public var xAmount:Number;
		public var yAmount:Number;
		public var widthAmount:Number;
		public var heightAmount:Number;
		
		public function PropertiesPanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}