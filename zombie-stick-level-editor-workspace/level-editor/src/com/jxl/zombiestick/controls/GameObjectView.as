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
        private var _selected:Boolean = false;
        private var selectedDirty:Boolean = false;
        private var dragging:Boolean = false;

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

            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
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
            }
            _gameObject = value;
            if(_gameObject)
            {
                _gameObject.addEventListener("xChanged", onGameObjectChanged);
                _gameObject.addEventListener("yChanged", onGameObjectChanged);
                _gameObject.addEventListener("widthChanged", onGameObjectChanged);
                _gameObject.addEventListener("heightChanged", onGameObjectChanged);
                _gameObject.addEventListener("imageChanged", onGameObjectChanged);
            }
            gameObjectDirty = true;
            invalidateProperties();
        }

        public function get selected():Boolean {
            return _selected;
        }

        public function set selected(value:Boolean):void {
            _selected = value;
            selectedDirty = true;
            if(_selected == true)
            {
                stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            }
            else
            {
                stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            }
            invalidateProperties();
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
            if(selected)
            {
                g.lineStyle(3, 0x990000, 1, true);
                g.drawRect(-3, -3, width + 6, height + 6);
            }
			else if(over)
			{
				g.lineStyle(1, 0xFFFF00, 1, true);
				g.drawRect(-3, -3, width + 6, height + 6);
			}
			else if(over == false)
			{
				g.lineStyle(0, 0xFFFF00, .1, true);
				g.drawRect(-3, -3, width + 6, height + 6);
			}
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

            }
        }

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
            }
        }

        private function onImageLoaded(event:Event):void
        {
            setActualSize(imageView.sourceWidth, imageView.sourceHeight);
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
                    gameObject.y += amount;
                break;

                case Keyboard.RIGHT:
                    gameObject.x += amount;
                break;

                case Keyboard.UP:
                    gameObject.y -= amount;
                break;

                case Keyboard.LEFT:
                    gameObject.x -= amount;
                break;

				case Keyboard.DELETE:
					Alert.yesLabel = "Delete";
					Alert.show("Are you sure you wish to delete?", "Confirm Delete", Alert.YES | Alert.CANCEL, this, onConfirm, null, Alert.CANCEL);
				break;
            }
        }

		private function onConfirm(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				 dispatchEvent(new GameObjectViewEvent(GameObjectViewEvent.DELETE));
			}
		}

    }
}