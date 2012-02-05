package com.jxl.zombiestick.controls
{
	import com.jxl.zombiestick.events.GameObjectViewEvent;
	import com.jxl.zombiestick.vo.GameObjectVO;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	
	import spark.components.Image;

	[Event(name="delete", type="com.jxl.zombiestick.events.GameObjectViewEvent")]
    public class GameObjectView extends UIComponent
	{

        private var _gameObject:GameObjectVO;
        private var gameObjectDirty:Boolean = false;
        private var selectedDirty:Boolean = false;
        public var dragging:Boolean = false;

        private var backgroundShape:Shape;
        private var borderShape:Shape;
        private var imageView:Image;
		private var over:Boolean = false;
		
		public function GameObjectView()
		{
			super();
            init();
		}

        private function init():void
        {
            mouseChildren = false;
            mouseEnabled = true;
            tabChildren = false;
            tabEnabled = false;

            //addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
        }

        public function get gameObject():GameObjectVO {
            return _gameObject;
        }

        public function set gameObject(value:GameObjectVO):void
        {
            if(_gameObject)
            {
                _gameObject.removeEventListener("xChanged", onGameObjectChanged);
                _gameObject.removeEventListener("yChanged", onGameObjectChanged);
                _gameObject.removeEventListener("widthChanged", onGameObjectChanged);
                _gameObject.removeEventListener("heightChanged", onGameObjectChanged);
                _gameObject.removeEventListener("imageChanged", onGameObjectChanged);
				_gameObject.removeEventListener("selectedChanged", onGameObjectChanged);
            }
            _gameObject = value;
            if(_gameObject)
            {
                _gameObject.addEventListener("xChanged", onGameObjectChanged);
                _gameObject.addEventListener("yChanged", onGameObjectChanged);
                _gameObject.addEventListener("widthChanged", onGameObjectChanged);
                _gameObject.addEventListener("heightChanged", onGameObjectChanged);
                _gameObject.addEventListener("imageChanged", onGameObjectChanged);
				_gameObject.addEventListener("selectedChanged", onGameObjectChanged);
            }
            gameObjectDirty = true;
            invalidateProperties();
        }

        public function get selected():Boolean
		{
           	if(gameObject)
			{
				return gameObject.selected;
			}
			else
			{
				return false;
			}
        }

        protected override function createChildren():void
        {
            super.createChildren();

            backgroundShape = new Shape();
            addChild(backgroundShape);

            borderShape = new Shape();
            addChild(borderShape);

            imageView = new Image();
            addChild(imageView);
            imageView.addEventListener(Event.COMPLETE, onImageLoaded);
        }

        protected override function commitProperties():void
        {
            super.commitProperties();

            if(selectedDirty)
            {
                selectedDirty = false;
                drawSelected();
            }

            if(gameObjectDirty)
            {
                gameObjectDirty = false;
                if(gameObject)
                {
                    move(gameObject.x, gameObject.y);
                    setActualSize(gameObject.width, gameObject.height);
					imageView.source = gameObject.image;
					invalidateDisplayList();
                }
            }
        }

        protected override function updateDisplayList(w:Number, h:Number):void
        {
            super.updateDisplayList(w, h);

            var g:Graphics;

            g = backgroundShape.graphics;
            g.clear();
            if(gameObject.image == null)
            {
				g.beginFill(0x666666, .5);
                g.drawRect(0, 0, width, height);
            }
            g.endFill();

            drawSelected();

            imageView.setActualSize(width,  height);
			
			
        }

        private function drawSelected():void
        {
            var g:Graphics = borderShape.graphics;
            g.clear();
			var MARGIN:Number = 2;
			var MARGIN2:Number = MARGIN * 2;
            if(selected)
            {
                g.lineStyle(0, 0x990000, 1, true);
            }
			else if(over)
			{
				g.lineStyle(0, 0xFFFF00, 1, true);
			}
			else if(over == false)
			{
				g.lineStyle(0, 0xFFFF00, .1, true);
			}
			
			g.drawRect(MARGIN, MARGIN, width - MARGIN2, height - MARGIN2);
            g.endFill();
        }

        private function onGameObjectChanged(event:Event):void
        {
            if(dragging)
                return;

            var gameObject:GameObjectVO = event.target as GameObjectVO;
            switch(event.type)
            {
                case "xChanged":
                    x = gameObject.x;
                break;

                case "yChanged":
                    y = gameObject.y;
                break;

                case "widthChanged":
                    width = gameObject.width;
                break;

                case "heightChanged":
                    height = gameObject.height;
                break;

                case "imageChanged":
                    imageView.source = gameObject.image;
					break;
				
				case "selectedChanged":
					onSelectionChanged();
                break;
            }
			dispatchEvent(new Event("childSizeChanged"));
        }
		
		private function onSelectionChanged():void
		{
			selectedDirty = true;
			invalidateProperties();
		}

		/*
        private function onMouseDown(event:MouseEvent):void
        {
            if(dragging == false)
            {
                dragging = true;
                startDrag(false);
                addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
                addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            }
        }
		*/
		
		private function onRollOver(event:MouseEvent):void
		{
			over = true;
			invalidateDisplayList();
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			over = false;
			invalidateDisplayList();
		}

		/*
        private function onMouseMove(event:MouseEvent):void
        {
            gameObject.x = x;
            gameObject.y = y;
            event.updateAfterEvent();
        }

        private function onMouseUp(event:MouseEvent):void
        {
            if(dragging)
            {
                dragging = false;
                removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                stopDrag();
				gameObject.x = x;
				gameObject.y = y;
            }
        }
		*/

        private function onImageLoaded(event:Event):void
        {
			gameObject.width = imageView.sourceWidth;
			gameObject.height = imageView.sourceHeight;
            setActualSize(imageView.sourceWidth, imageView.sourceHeight);
        }


    }
}