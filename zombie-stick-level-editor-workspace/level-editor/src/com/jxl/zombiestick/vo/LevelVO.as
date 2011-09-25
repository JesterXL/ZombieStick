package com.jxl.zombiestick.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class LevelVO extends EventDispatcher
	{
		
		private var _backgroundImage:String;
		
		public function get backgroundImage():String { return _backgroundImage; }
		public function set backgroundImage(value:String):void
		{
			_backgroundImage = value;
			dispatchEvent(new Event("backgroundImageChanged"));
		}
		
		public var terrain:ArrayCollection;
		public var events:ArrayCollection;
		
		public function LevelVO()
		{
		}
	}
}