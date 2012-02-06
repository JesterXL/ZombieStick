package com.jxl.zombiestick.rl.mediators
{
	import com.jxl.zombiestick.events.view.LayersPanelEvent;
	import com.jxl.zombiestick.rl.models.LevelModel;
	import com.jxl.zombiestick.views.levelviews.LayersPanel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LayersPanelMediator extends Mediator
	{
		
		[Inject]
		public var view:LayersPanel;
		
		[Inject]
		public var model:LevelModel;
		
		public function LayersPanelMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			addContextListener("levelChanged", onLevelChanged);
			addContextListener("selectionsChanged", onSelectionsChanged);
			
			addViewListener(LayersPanelEvent.SELECTIONS_CHANGED, onUserSelectionsChanged, LayersPanelEvent); 
			
			onLevelChanged();
			onSelectionsChanged();
		}
		
		private function onLevelChanged(event:Event=null):void
		{
			view.level = model.level;
		}
		
		private function onSelectionsChanged(event:Event=null):void
		{
			view.selections = model.selections;
		}
		
		private function onUserSelectionsChanged(event:LayersPanelEvent):void
		{
			model.setSelectedIndices(event.indices);
		}
	}
}