package com.jxl.zombiestick.rl.mediators
{
	import com.jxl.zombiestick.events.view.PropertiesPanelEvent;
	import com.jxl.zombiestick.rl.models.LevelModel;
	import com.jxl.zombiestick.views.levelviews.PropertiesPanel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class PropertiesPanelMediator extends Mediator
	{
		
		[Inject]
		public var view:PropertiesPanel;
		
		[Inject]
		public var model:LevelModel;
		
		public function PropertiesPanelMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			addContextListener("selectionsChanged", onSelectionsChanged);
			
			addViewListener(PropertiesPanelEvent.MOVE_GAME_OBJECTS, onMoveGameObjects, PropertiesPanelEvent);
			addViewListener(PropertiesPanelEvent.RESIZE_GAME_OBJECTS, onResizeGameObjects, PropertiesPanelEvent);
			
			onSelectionsChanged();
		}
		
		private function onSelectionsChanged(event:Event=null):void
		{
			view.selections = model.selections;
		}
		
		private function onMoveGameObjects(event:PropertiesPanelEvent):void
		{
			model.onMove(event.xAmount, event.yAmount);
		}
		
		private function onResizeGameObjects(event:PropertiesPanelEvent):void
		{
			model.onResize(event.widthAmount, event.heightAmount);
		}
	}
}