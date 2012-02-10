package com.jxl.zombiestick.events.view
{
	import flash.events.Event;
	
	public class LayersPanelEvent extends Event
	{
		public static const SELECTIONS_CHANGED:String = "selectionsChanged";
		public static const DELETE_SELECTED:String = "deleteSelected";
		
		public var indices:Vector.<int>;
		
		public function LayersPanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}