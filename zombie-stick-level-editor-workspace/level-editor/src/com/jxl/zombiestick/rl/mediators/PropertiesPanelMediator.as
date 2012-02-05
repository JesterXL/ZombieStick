package com.jxl.zombiestick.rl.mediators
{
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
			onSelectionsChanged();
		}
		
		private function onSelectionsChanged(event:Event=null):void
		{
			view.selections = model.selections;
		}
	}
}