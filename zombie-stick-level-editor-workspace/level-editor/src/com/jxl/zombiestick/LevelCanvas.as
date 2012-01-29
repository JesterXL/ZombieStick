package com.jxl.zombiestick
{
import com.jxl.zombiestick.controls.GameObjectView;
import com.jxl.zombiestick.events.GameObjectViewEvent;
import com.jxl.zombiestick.vo.GameObjectVO;
import com.jxl.zombiestick.vo.LevelVO;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.graphics.BitmapScaleMode;

import spark.components.Image;
import spark.layouts.BasicLayout;
import spark.primitives.Rect;
	
	public class LevelCanvas extends UIComponent
	{
		
		private var _level:LevelVO;
		private var levelDirty:Boolean = false;
		private var _selections:ArrayCollection;
		private var dragging:Boolean = false;
		private var startClick:Point;
		
        [Bindable(event="selectionsChanged")]
        public function get selections():ArrayCollection
		{
            return _selections;
        }

        public function set selections(value:ArrayCollection):void
		{
			if(_selections !== value)
			{
				if(_selections)
				{
					_selections.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onSelectionsChanged);
				}
	            _selections = value;
				if(_selections)
				{
					_selections.addEventListener(CollectionEvent.COLLECTION_CHANGE, onSelectionsChanged);
				}
	            dispatchEvent(new Event("selectionsChanged"));
			}
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
			init();
		}
		
		private function init():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}

        public function newGameObject(x:Number=0, y:Number=0):void
        {
            var gameObject:GameObjectVO = new GameObjectVO();
            _level.events.addItem(gameObject);
			gameObject.x = x;
			gameObject.y = y;
        }
		
		public function newTable():void
		{
			var gameObject:GameObjectVO = new GameObjectVO();
			gameObject.image = "assets/images/game/table.png";
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
			gameObjects.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
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
				rect.width = Math.max(child.x + child.width, rect.width);
				rect.height = Math.max(child.y + child.height, rect.height);
			}
			
			if(isNaN(backgroundImage.sourceWidth) == false)
			{
				rect.width = Math.max(backgroundImage.sourceWidth, rect.width);
				rect.height = Math.max(backgroundImage.sourceHeight, rect.height);
			}
			
			width = explicitWidth = measuredWidth = rect.width;
			height = explicitHeight = measuredHeight = rect.height;
		}

        private function onMouseDown(event:MouseEvent):void
        {
			if(event.shiftKey == false)
			{
            	setSelected(event.target as GameObjectView);
			}
			else
			{
				addSelected(event.target as GameObjectView);
			}
			
			if(dragging == false)
			{
				startClick = new Point(mouseX, mouseY);
				addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveInitial);
				var len:int = selections.length;
				while(len--)
				{
					var gameObject:GameObjectVO = selections[len] as GameObjectVO;
					gameObject.originalPoint = new Point(gameObject.x, gameObject.y);
				}
			}
			
			event.stopImmediatePropagation();
        }
		
		private function onMouseUp(event:MouseEvent):void
		{
		}
		
		private function onMouseMoveInitial(event:MouseEvent):void
		{
			var deltaX:Number = mouseX - startClick.x;
			var deltaY:Number = mouseY - startClick.y;
			var dist:Number = Math.sqrt((deltaX * deltaX) + (deltaY * deltaY));
			if(dist > 4)
			{
				removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveInitial);
				dragging = true;
				stage.addEventListener(MouseEvent.MOUSE_UP, onDragMouseUp, true, 10);
				addEventListener(MouseEvent.MOUSE_MOVE, onDragMouseMove);
			}
		}
		
		private function onDragMouseMove(event:MouseEvent):void
		{
			var len:int = _selections.length;
			while(len--)
			{
				var gameObject:GameObjectVO = _selections[len] as GameObjectVO;
				gameObject.x = gameObject.originalPoint.x - (startClick.x - mouseX);
				gameObject.y = gameObject.originalPoint.y - (startClick.y - mouseY);
			}
			event.updateAfterEvent();
			event.stopImmediatePropagation();
		}
		
		private function onDragMouseUp(event:MouseEvent):void
		{
			trace("LevelCanvas::onDragMouseUp, dragging: " + dragging);
			dragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDragMouseUp, true);
			removeEventListener(MouseEvent.MOUSE_MOVE, onDragMouseMove);
			startClick = null;
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveInitial);
			event.stopImmediatePropagation();
		}
		
		private function onStageMouseUp(event:MouseEvent):void
		{
			trace("onStageMouseUp, target: " + event.target + ", dragging: " + dragging);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveInitial);
			if(event.target == this || event.target == gameObjects)
			{
				setSelected(null);
			}
		}

        private function setSelected(view:GameObjectView):void
        {
            if(lastSelected)
                lastSelected.gameObject.selected = false;

            lastSelected = view;
            if(lastSelected)
            {
                lastSelected.gameObject.selected = true;
				selections = new ArrayCollection([lastSelected.gameObject]);
            }
            else
            {
				if(selections)
				{
					var len:int = selections.length;
					while(len--)
					{
						var gameObject:GameObjectVO = selections[len] as GameObjectVO;
						gameObject.selected = false;
					}
					selections = null;
				}
            }
        }
		
		private function addSelected(view:GameObjectView):void
		{
			if(selections.contains(view.gameObject) == false)
				selections.addItem(view.gameObject);
		}
		
		private function onEventsChanged(event:CollectionEvent):void
		{
			switch(event.kind)
			{
				case CollectionEventKind.ADD:
					addNewGameObject(event.items[0] as GameObjectVO);
					break;
			}
			invalidateSize();
		}
		
		private function addNewGameObject(gameObject:GameObjectVO):void
		{
			var view:GameObjectView 	= new GameObjectView();
			view.addEventListener(GameObjectViewEvent.DELETE, onDelete);
			view.gameObject 			= gameObject;
			view.addEventListener("childSizeChanged", onChildSizeChanged, false, 0, true);
			gameObjects.addChild(view);
		}

		private function onDelete():void
		{
			
			var len:int = gameObjects.numChildren;
			while(len--)
			{
				var view:GameObjectView		= gameObjects.getChildAt(len) as GameObjectView;
				var go:GameObjectVO			= view.gameObject;
				if(go.selected)
				{
					view.gameObject 			= null;
					view.removeEventListener("childSizeChanged", onChildSizeChanged);
					gameObjects.removeChildAt(len);
					level.events.removeItemAt(level.events.getItemIndex(go));	
				}
			}
			lastSelected = null;
		}
		
		private function onChildSizeChanged(event:Event):void
		{
			//invalidateSize();
			measure();
		}
		
		private function onSelectionsChanged(event:CollectionEvent):void
		{
			var len:int = _selections.length;
			while(len--)
			{
				var gameObject:GameObjectVO = _selections[len] as GameObjectVO;
				gameObject.selected = true;
			}
		}
		
		
		
		
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			var amount:Number;
			if(event.shiftKey)
			{
				amount = 10;
			}
			else
			{
				amount = 1;
			}
			
			switch(event.keyCode)
			{
				case Keyboard.DOWN:
					moveGameObjects(0, amount);
					break;
				
				case Keyboard.RIGHT:
					moveGameObjects(amount, 0);
					break;
				
				case Keyboard.UP:
					moveGameObjects(0, -amount);
					break;
				
				case Keyboard.LEFT:
					moveGameObjects(-amount, 0);
					break;
				
				case Keyboard.DELETE:
					Alert.yesLabel = "Delete";
					Alert.show("Are you sure you wish to delete?", "Confirm Delete", Alert.YES | Alert.CANCEL, this, onConfirm, null, Alert.CANCEL);
					break;
			}
		}
		
		private function moveGameObjects(xAmount:Number, yAmount:Number):void
		{
			if(_selections)
			{
				var len:int = _selections.length;
				while(len--)
				{
					var gameObject:GameObjectVO = _selections[len] as GameObjectVO;
					gameObject.x += xAmount;
					gameObject.y += yAmount;
				}
			}
		}
		
		private function onConfirm(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				//dispatchEvent(new GameObjectViewEvent(GameObjectViewEvent.DELETE));
				onDelete();
			}
		}

	}
}