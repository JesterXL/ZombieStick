package com.jxl.zombiestick.events
{
	import com.jxl.zombiestick.vo.GameObjectVO;
	
	import flash.events.Event;
	
	public class LayerItemRendererEvent extends Event
	{
		public static const DELETE_GAME_OBJECT:String = "deleteGameObject";
		
		public var gameObject:GameObjectVO;
		
		
		public function LayerItemRendererEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}