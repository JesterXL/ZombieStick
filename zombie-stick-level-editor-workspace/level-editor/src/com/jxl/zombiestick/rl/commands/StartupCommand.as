package com.jxl.zombiestick.rl.commands
{
	import com.jxl.zombiestick.events.controller.StartupEvent;
	import com.jxl.zombiestick.rl.models.LevelModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class StartupCommand extends Command
	{
		
		[Inject]
		public var event:StartupEvent;
		
		[Inject]
		public var model:LevelModel;
		
		public function StartupCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			model.level = event.level;
		}
			
	}
}