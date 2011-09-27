package com.jxl.zombiestick.services
{
	import com.adobe.serialization.json.JSON;
	import com.jxl.zombiestick.events.OpenLevelServiceEvent;
	import com.jxl.zombiestick.vo.LevelVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	
	public class OpenLevelService extends EventDispatcher
	{
		private var file:File;
		
		public var level:LevelVO;
		
		public function OpenLevelService()
		{
			super();
		}
		
		public function openLevel():void
		{
			level = null;
			
			if(file == null)
			{
				file = new File();
				file.addEventListener(IOErrorEvent.IO_ERROR, onFileError);
				file.addEventListener(Event.SELECT, onFileSelected);
			}
			try
			{
				file.browseForOpen("Level JSON", [new FileFilter("Level JSON", ".json", "JSON")]);
			}
			catch(err:Error)
			{
				trace("OpenLevelService::openLevel, error on browseForOpen: " + err);
				//dispatchEvent(new OpenLevelServiceEvent(OpenLevelServiceEvent.OPEN_ERROR));
				return;
			}
		}
		
		private function onFileError(event:IOErrorEvent):void
		{
			trace("OpenLevelService::onFileError: " + event);
			//dispatchEvent(new OpenLevelServiceEvent(OpenLevelServiceEvent.OPEN_ERROR));
		}
		
		private function onFileSelected(event:Event):void
		{
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var jsonString:String = stream.readUTFBytes(stream.bytesAvailable);
			var jsonObject:Object;
			try
			{
				jsonObject = JSON.decode(jsonString);
				if(jsonObject == null)
				{
					trace("OpenLevelService::onFileSelected, error parsing JSON String, it was null after parsing, jsonString: " + jsonString);
					//dispatchEvent(new OpenLevelServiceEvent(OpenLevelServiceEvent.OPEN_ERROR));
					return;
				}
			}
			catch(err:Error)
			{
				trace("OpenLevelService::onFileSelected, error parsing JSON String: " + err);
				//dispatchEvent(new OpenLevelServiceEvent(OpenLevelServiceEvent.OPEN_ERROR));
				return;
			}
			
			try
			{
				level = new LevelVO();
				level.buildFromObject(jsonObject);
				dispatchEvent(new OpenLevelServiceEvent(OpenLevelServiceEvent.SUCCESS));
				
			}
			catch(err:Error)
			{
				trace("OpenLevelService::onFileSelected, error building Level from JSON Object: " + err);
				//dispatchEvent(new OpenLevelServiceEvent(OpenLevelServiceEvent.OPEN_ERROR));
				return;
			}
		}
		
		
	}
}