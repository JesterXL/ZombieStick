package com.jxl.zombiestick.rl.mediators
{
	import com.jxl.zombiestick.rl.models.LevelModel;
	import com.jxl.zombiestick.views.LevelWindow;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LevelWindowMediator extends Mediator
	{
		[Inject]
		public var view:LevelWindow;
		
		[Inject]
		public var model:LevelModel;
		
		
		public function LevelWindowMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			addContextListener("levelChanged", onLevelChanged);
			
			onLevelChanged();
		}
		
		private function onLevelChanged(event:Event=null):void
		{
			view.level = model.level;
		}
	}
}