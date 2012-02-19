package com.jxl.zombiestick.rl
{
	import com.jxl.zombiestick.LevelCanvas;
	import com.jxl.zombiestick.events.controller.StartupEvent;
	import com.jxl.zombiestick.rl.commands.StartupCommand;
	import com.jxl.zombiestick.rl.mediators.LayersPanelMediator;
	import com.jxl.zombiestick.rl.mediators.LevelCanvasMediator;
	import com.jxl.zombiestick.rl.mediators.LevelWindowMediator;
	import com.jxl.zombiestick.rl.mediators.MoviePanelMediator;
	import com.jxl.zombiestick.rl.mediators.PropertiesPanelMediator;
	import com.jxl.zombiestick.rl.models.LevelModel;
	import com.jxl.zombiestick.views.LevelWindow;
	import com.jxl.zombiestick.views.levelviews.LayersPanel;
	import com.jxl.zombiestick.views.levelviews.MoviePanel;
	import com.jxl.zombiestick.views.levelviews.PropertiesPanel;
	import com.jxl.zombiestick.vo.LevelVO;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	public class MainContext extends Context
	{
		public function MainContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		public override function startup():void
		{
			injector.mapSingleton(LevelModel);
			
			mediatorMap.mapView(LevelWindow, LevelWindowMediator);
			mediatorMap.mapView(LevelCanvas, LevelCanvasMediator);
			mediatorMap.mapView(PropertiesPanel, PropertiesPanelMediator);
			mediatorMap.mapView(LayersPanel, LayersPanelMediator);
			mediatorMap.mapView(MoviePanel, MoviePanelMediator);
			
			commandMap.mapEvent(StartupEvent.STARTUP, StartupCommand, StartupEvent, true);
			
			super.startup();
		}
		
		public function initialize(level:LevelVO):void
		{
			var event:StartupEvent = new StartupEvent(StartupEvent.STARTUP);
			event.level = level;
			dispatchEvent(event);
		}
	}
}