package com.jxl.zombiestick.vo
{
	import flash.debugger.enterDebugger;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class LevelVO extends EventDispatcher
	{
		
		private var _backgroundImage:String;
		private var _levelDirectory:String;
		
		[Bindable(event="backgroundImageChanged")]
		public function get backgroundImage():String { return _backgroundImage; }
		public function set backgroundImage(value:String):void
		{
			_backgroundImage = value;
			dispatchEvent(new Event("backgroundImageChanged"));
		}
		
		public var events:ArrayCollection = new ArrayCollection();
		
		
		public function LevelVO()
		{
		}

		public function get levelDirectory():String
		{
			return _levelDirectory;
		}

		[Bindable(event="levelDirectoryChanged")]
		public function set levelDirectory(value:String):void
		{
			_levelDirectory = value;
			dispatchEvent(new Event("levelDirectoryChanged"));
		}
		
		public function toObject():Object
		{
			try
			{
				var obj:Object = {};
				obj.classType = "level";
				obj.backgroundImage = _backgroundImage;
				obj.backgroundImageShort = _backgroundImage.substring(_backgroundImage.lastIndexOf("/") + 1, _backgroundImage.length);
				obj.levelDirectory = _levelDirectory;
				obj.events			= [];
				if(events && events.length > 0)
				{
					var len:int = events.length;
					for(var index:int = 0; index < len; index++)
					{
						var event:Object = events[index];
						if(event == null)
						{
							flash.debugger.enterDebugger();
						}
						var eventObject:Object = event.toObject();
						if(eventObject == null)
						{
							flash.debugger.enterDebugger();
						}
						obj.events[index] = eventObject;
					}
					obj.events.sortOn("when", Array.NUMERIC);
				}

				return obj;
			}
			catch(err:Error)
			{
				trace("LevelVO::toObject, err: " + err);
			}
			return null;
		}
		
		public function buildFromObject(object:Object):void
		{
			backgroundImage			= object.backgroundImage;
			levelDirectory			= object.levelDirectory;
			events					= new ArrayCollection();
			var len:int;
			var movie:MovieVO;
			var gameObject:GameObjectVO;
			if(object.events && object.events.length > 0)
			{
				len = object.events.length;
				for(var index:int = 0; index < len; index++)
				{
					var eventObject:Object = object.events[index];
					switch(eventObject.classType)
					{
						case "movie":
							movie = new MovieVO();
							movie.buildFromObject(eventObject);
							events.addItem(movie);
							break;
						
						case "gameObject":
							gameObject = new GameObjectVO();
							gameObject.buildFromObject(eventObject);
							events.addItem(gameObject);
							break;
						
						default:
							throw new Error("Uknown type!");
							break;
							
					}
				}
			}
		}
	}
}