package com.jxl.zombiestick.rl.mediators
{
	import com.jxl.zombiestick.rl.models.LevelModel;
	import com.jxl.zombiestick.views.levelviews.MoviePanel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MoviePanelMediator extends Mediator
	{
		[Inject]
		public var model:LevelModel;
		
		[Inject]
		public var view:MoviePanel;
		
		public function MoviePanelMediator()
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
			if(model.level)
				view.movies = model.level.movies;
		}
	}
}