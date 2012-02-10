package com.jxl.zombiestick.rl.mediators
{
	import com.jxl.zombiestick.LevelCanvas;
	import com.jxl.zombiestick.events.LevelCanvasEvent;
	import com.jxl.zombiestick.rl.models.LevelModel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LevelCanvasMediator extends Mediator
	{
		[Inject]
		public var view:LevelCanvas;
		
		[Inject]
		public var model:LevelModel;
		
		public function LevelCanvasMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			addViewListener(LevelCanvasEvent.ADD_SELECTION, onAddSelection, LevelCanvasEvent);
			addViewListener(LevelCanvasEvent.CLEAR_ALL_SELECTIONS, onClearAllSelections, LevelCanvasEvent);
			addViewListener(LevelCanvasEvent.SET_SELECTION, onSetSelection, LevelCanvasEvent);
			addViewListener(LevelCanvasEvent.DELETE_SELECTED, onDeleteSelected, LevelCanvasEvent);
			addViewListener(LevelCanvasEvent.START_MOVE_SELECTIONS, onStartMoveSelections, LevelCanvasEvent);
			addViewListener(LevelCanvasEvent.DRAG_GAME_OBJECTS, onDrag, LevelCanvasEvent);
			addViewListener(LevelCanvasEvent.MOVE_GAME_OBJECTS, onMove, LevelCanvasEvent);
			addViewListener(LevelCanvasEvent.DUPLICATE_OBJECTS, onDuplicateObjects, LevelCanvasEvent);
			
			addContextListener("levelChanged", onLevelChanged);
			
			onLevelChanged();
		}
		
		public override function onRemove():void
		{
			view.level = null;
		}
		
		private function onLevelChanged(event:Event=null):void
		{
			view.level = model.level;
		}
		
		private function onSetSelection(event:LevelCanvasEvent):void
		{
			model.setSelection(event.gameObject);
		}
		
		private function onClearAllSelections(event:LevelCanvasEvent):void
		{
			model.clearAllSelections();
		}
		
		private function onAddSelection(event:LevelCanvasEvent):void
		{
			model.addSelection(event.gameObject);
		}
		
		private function onDeleteSelected(event:LevelCanvasEvent):void
		{
			model.deleteSelected();
		}
		
		private function onStartMoveSelections(event:LevelCanvasEvent):void
		{
			model.resetOriginalPoint();
		}
		
		private function onDrag(event:LevelCanvasEvent):void
		{
			model.onDrag(event.offsetX, event.offsetY);
		}
		
		private function onMove(event:LevelCanvasEvent):void
		{
			model.onMove(event.x, event.y);
		}
		
		private function onDuplicateObjects(event:LevelCanvasEvent):void
		{
			model.duplicateSelectedObjects();
		}
	}
}