package com.jxl.zombiestick
{
	import com.jxl.zombiestick.vo.LevelVO;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.graphics.BitmapScaleMode;
	
	import spark.components.Image;
	
	public class LevelCanvas extends UIComponent
	{
		
		private var _level:LevelVO;
		private var levelDirty:Boolean = false;
		
		private var backgroundImage:Image;
		
		public function get level():LevelVO { return _level; }
		public function set level(value:LevelVO):void
		{
			if(_level)
			{
				_level.removeEventListener("backgroundImageChanged", onBackgroundImageChanged);
			}
			_level = value;
			if(_level)
			{
				_level.addEventListener("backgroundImageChanged", onBackgroundImageChanged);
			}
			levelDirty = true;
			invalidateProperties();
		}
		
		public function LevelCanvas()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			backgroundImage = new Image();
			addChild(backgroundImage);
			backgroundImage.scaleMode = BitmapScaleMode.LETTERBOX;
			backgroundImage.addEventListener(Event.COMPLETE, onImageLoadComplete);
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(levelDirty)
			{
				levelDirty = false;
				if(_level)
				{
					updateImage();
				}
				else
				{
					backgroundImage.source = null;
				}
			}
		}
		
		protected override function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			backgroundImage.setActualSize(backgroundImage.sourceWidth, backgroundImage.sourceHeight);
		}
		
		private function updateImage():void
		{
			trace("LevelCanvas::updateImage, _level.backgroundImage: " + _level.backgroundImage);
			backgroundImage.source = _level.backgroundImage;
		}
		
		
		private function onBackgroundImageChanged(event:Event):void
		{
			updateImage();
		}
		
		private function onImageLoadComplete(event:Event):void
		{
			invalidateDisplayList();
		}
		
	}
}