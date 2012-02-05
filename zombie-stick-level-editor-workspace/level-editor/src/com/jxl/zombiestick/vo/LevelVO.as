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
		
		[Bindable]
		public var events:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var movies:ArrayCollection = new ArrayCollection();
		
		
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
				if(_backgroundImage)
				{
					obj.backgroundImage = _backgroundImage;
					obj.backgroundImageShort = _backgroundImage.substring(_backgroundImage.lastIndexOf("/") + 1, _backgroundImage.length);
				}
				obj.levelDirectory = _levelDirectory;
				obj.events			= [];
				obj.movies 			= [];
				var len:int;
				var index:int;
				if(events && events.length > 0)
				{
					len = events.length;
					for(index = 0; index < len; index++)
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
				
				if(movies && movies.length > 0)
				{
					len = movies.length;
					for(index = 0; index < len; index++)
					{
						var movie:MovieVO = movies[index];
						var movieObject:Object = movie.toObject();
						obj.movies[index] = movieObject;
					}
					obj.movies.sortOn("when", Array.NUMERIC);
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
							flash.debugger.enterDebugger();
							throw new Error("Uknown type!");
							break;
							
					}
				}
			}
		}
	}
}