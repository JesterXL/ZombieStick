package com.jxl.zombiestick.events
{
	import com.jxl.zombiestick.controls.GameObjectView;
	import com.jxl.zombiestick.vo.GameObjectVO;
	
	import flash.events.Event;
	
	public class LevelCanvasEvent extends Event
	{
		
		public static const SET_SELECTION:String = "setSelection";
		public static const ADD_SELECTION:String = "addSelection";
		public static const CLEAR_ALL_SELECTIONS:String = "clearAllSelections";
		public static const DELETE_SELECTED:String = "deleteSelected";
		public static const START_MOVE_SELECTIONS:String = "startMoveSelections";
		public static const DRAG_GAME_OBJECTS:String = "dragGameObjects";
		public static const MOVE_GAME_OBJECTS:String = "moveGameObjects";
		
		
		public var gameObject:GameObjectVO;
		public var offsetX:Number;
		public var offsetY:Number;
		public var x:Number;
		public var y:Number;
		
		public function LevelCanvasEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}