package com.jxl.zombiestick
{
import com.jxl.zombiestick.controls.GameObjectView;
import com.jxl.zombiestick.events.LevelCanvasEvent;
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
		private var dragging:Boolean = false;
		private var startClick:Point;
		
        private var backgroundImage:Image;
        private var gameObjects:UIComponent;
        //private var lastSelected:GameObjectView;
		
		
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
			var selectionEvent:LevelCanvasEvent;
			if(event.shiftKey == false)
			{
				selectionEvent = new LevelCanvasEvent(LevelCanvasEvent.SET_SELECTION);
				selectionEvent.gameObject = GameObjectView(event.target).gameObject;
				dispatchEvent(selectionEvent);
            	//setSelected(event.target as GameObjectView);
			}
			else
			{
				selectionEvent = new LevelCanvasEvent(LevelCanvasEvent.ADD_SELECTION);
				selectionEvent.gameObject = GameObjectView(event.target).gameObject;
				dispatchEvent(selectionEvent);
				//addSelected(event.target as GameObjectView);
			}
			
			if(dragging == false)
			{
				startClick = new Point(mouseX, mouseY);
				addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveInitial);
				
				dispatchEvent(new LevelCanvasEvent(LevelCanvasEvent.START_MOVE_SELECTIONS));
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
			/*
			var len:int = _selections.length;
			while(len--)
			{
				var gameObject:GameObjectVO = _selections[len] as GameObjectVO;
				gameObject.x = gameObject.originalPoint.x - (startClick.x - mouseX);
				gameObject.y = gameObject.originalPoint.y - (startClick.y - mouseY);
			}
			*/
			var dragEvent:LevelCanvasEvent = new LevelCanvasEvent(LevelCanvasEvent.DRAG_GAME_OBJECTS);
			dragEvent.offsetX = startClick.x - mouseX;
			dragEvent.offsetY = startClick.y - mouseY;
			dispatchEvent(dragEvent);
			
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
				dispatchEvent(new LevelCanvasEvent(LevelCanvasEvent.CLEAR_ALL_SELECTIONS));
				//setSelected(null);
			}
		}
		
		private function onEventsChanged(event:CollectionEvent):void
		{
			switch(event.kind)
			{
				case CollectionEventKind.ADD:
					addNewGameObject(event.items[0] as GameObjectVO);
					break;
				
				case CollectionEventKind.REMOVE:
					var len:int = event.items.length;
					while(len--)
					{
						removeGameObject(event.items[len]);
					}
					break;
			}
			invalidateSize();
		}
		
		private function addNewGameObject(gameObject:GameObjectVO):void
		{
			var view:GameObjectView 	= new GameObjectView();
			view.gameObject 			= gameObject;
			view.addEventListener("childSizeChanged", onChildSizeChanged, false, 0, true);
			gameObjects.addChild(view);
		}
		
		private function removeGameObject(gameObject:GameObjectVO):void
		{
			var len:int = gameObjects.numChildren;
			while(len--)
			{
				var view:GameObjectView = gameObjects.getChildAt(len) as GameObjectView;
				if(view.gameObject == gameObject)
				{
					view.gameObject = null;
					view.removeEventListener("childSizeChanged", onChildSizeChanged);
					gameObjects.removeChildAt(len);
					return;
				}
			}
		}

		// TODO: 2.5.2011, I don't like this guy just manually deleting his crap; he should be listening to the
		// level's events chanigng, and act accordingly.
		private function onDelete():void
		{
			dispatchEvent(new LevelCanvasEvent(LevelCanvasEvent.DELETE_SELECTED));
		}
		
		private function onChildSizeChanged(event:Event):void
		{
			//invalidateSize();
			measure();
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
				
				case Keyboard.D:
					if(event.commandKey)
					{
						duplicateObjects();
					}
					break;
			}
		}
		
		private function moveGameObjects(xAmount:Number, yAmount:Number):void
		{
			
			var moveEvent:LevelCanvasEvent = new LevelCanvasEvent(LevelCanvasEvent.MOVE_GAME_OBJECTS);
			moveEvent.x = xAmount;
			moveEvent.y = yAmount;
			dispatchEvent(moveEvent);
			/*
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
			*/
		}
		
		private function duplicateObjects():void
		{
			dispatchEvent(new LevelCanvasEvent(LevelCanvasEvent.DUPLICATE_OBJECTS));
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