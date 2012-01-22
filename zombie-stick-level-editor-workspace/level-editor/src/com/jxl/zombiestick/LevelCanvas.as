package com.jxl.zombiestick
{
import com.jxl.zombiestick.controls.GameObjectView;
import com.jxl.zombiestick.events.GameObjectViewEvent;
import com.jxl.zombiestick.vo.GameObjectVO;
import com.jxl.zombiestick.vo.LevelVO;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import mx.core.UIComponent;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.graphics.BitmapScaleMode;

import spark.components.Image;
import spark.primitives.Rect;
	
	public class LevelCanvas extends UIComponent
	{
		
		private var _level:LevelVO;
		private var levelDirty:Boolean = false;
        private var _selected:GameObjectVO;

        [Bindable(event="selectedChanged")]
        public function get selected():GameObjectVO {
            return _selected;
        }

        public function set selected(value:GameObjectVO):void {
            _selected = value;
            dispatchEvent(new Event("selectedChanged"))
        }

        private var backgroundImage:Image;
        private var gameObjects:UIComponent;
        private var lastSelected:GameObjectView;
		
		public function get level():LevelVO { return _level; }
		public function set level(value:LevelVO):void
		{
			if(_level)
			{
				_level.removeEventListener("backgroundImageChanged", onBackgroundImageChanged);
				_level.events.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onEventsChanged);
			}
			_level = value;
			if(_level)
			{
				_level.addEventListener("backgroundImageChanged", onBackgroundImageChanged);
				_level.events.addEventListener(CollectionEvent.COLLECTION_CHANGE, onEventsChanged);
			}
			levelDirty = true;
			invalidateProperties();
		}
		
		public function LevelCanvas()
		{
			super();
		}

        public function newGameObject():void
        {
            var gameObject:GameObjectVO = new GameObjectVO();
            _level.events.addItem(gameObject);
        }

		protected override function createChildren():void
		{
			super.createChildren();

			backgroundImage = new Image();
			addChild(backgroundImage);
			backgroundImage.scaleMode = BitmapScaleMode.LETTERBOX;
			backgroundImage.addEventListener(Event.COMPLETE, onImageLoadComplete);
			backgroundImage.mouseChildren = false;
			backgroundImage.mouseEnabled = false;
			backgroundImage.tabChildren = false;
			backgroundImage.tabEnabled = false;

            gameObjects = new UIComponent();
            addChild(gameObjects);
            gameObjects.mouseEnabled = false;
            gameObjects.tabEnabled = false;
            gameObjects.tabChildren = false;
            gameObjects.mouseChildren = true;
            gameObjects.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

            addEventListener(MouseEvent.MOUSE_DOWN, onLevelCanvasMouseDown);
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
					var len:int = _level.events.length;
					for(var index:int = 0; index < len; index++)
					{
						var obj:Object = _level.events[index];
						if(obj is GameObjectVO)
						{
							addNewGameObject(obj as GameObjectVO);
						}
					}
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

            var g:Graphics = graphics;
            g.clear();
            g.beginFill(0xFFFFFF);
			g.lineStyle(0, 0x000000);
            g.drawRect(0, 0, width, height);
            g.endFill();
			
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
			invalidateSize();
		}
		
		protected override function measure():void
		{
			var rect:Rectangle = new Rectangle();
			
			var len:int = gameObjects.numChildren;
			while(len--)
			{
				var child:DisplayObject = gameObjects.getChildAt(len);
				rect.x = Math.min(child.x, rect.x);
				rect.y = Math.min(child.y, rect.y);
				rect.width = Math.max(child.width, rect.width);
				rect.height = Math.max(child.height, rect.height);
			}
			
			if(isNaN(backgroundImage.sourceWidth) == false)
			{
				rect.width = Math.max(backgroundImage.sourceWidth, rect.width);
				rect.height = Math.max(backgroundImage.sourceHeight, rect.height);
			}
			
			width = measuredWidth = rect.width;
			height = measuredHeight = rect.height;
		}

        private function onMouseDown(event:MouseEvent):void
        {
            trace("LevelCanvas::onMouseDown, target: " + event.target);
            setSelected(event.target as GameObjectView);
        }

        private function setSelected(view:GameObjectView):void
        {
            if(lastSelected)
                lastSelected.selected = false;

            lastSelected = view;
            if(lastSelected)
            {
                lastSelected.selected = true;
                selected = lastSelected.gameObject;
            }
            else
            {
                selected = null;
            }
        }

        private function onLevelCanvasMouseDown(event:MouseEvent):void
        {
            if(event.target == this)
            {
                setSelected(null)
            }
        }

		private function onEventsChanged(event:CollectionEvent):void
		{
			switch(event.kind)
			{
				case CollectionEventKind.ADD:
					addNewGameObject(event.items[0] as GameObjectVO);
					break;
			}
		}
		
		private function addNewGameObject(gameObject:GameObjectVO):void
		{
			var view:GameObjectView 	= new GameObjectView();
			view.addEventListener(GameObjectViewEvent.DELETE, onDelete);
			view.gameObject 			= gameObject;
			gameObjects.addChild(view);
		}

		private function onDelete(event:GameObjectViewEvent):void
		{
			lastSelected 				= null;
			var view:GameObjectView		= event.target as GameObjectView;
			view.removeEventListener(GameObjectViewEvent.DELETE, onDelete);
			var go:GameObjectVO			= view.gameObject;
			view.gameObject 			= null;
			gameObjects.removeChild(view);
			level.events.removeItemAt(level.events.getItemIndex(go));
		}

	}
}