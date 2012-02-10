package com.jxl.zombiestick.rl.models
{
	import com.jxl.zombiestick.vo.GameObjectVO;
	import com.jxl.zombiestick.vo.LevelVO;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	public class LevelModel extends Actor
	{
		
		private var _level:LevelVO;
		private var _selections:ArrayCollection;
		private var _lastSelected:GameObjectVO;
		
		public function get level():LevelVO { return _level; }
		public function set level(value:LevelVO):void
		{
			if(value !== _level)
			{
				_level = value;
				dispatch(new Event("levelChanged"));
			}
		}
		
		public function get selections():ArrayCollection { return _selections; }
		public function set selections(value:ArrayCollection):void
		{
			if(_selections !== value)
			{
				var len:int;
				var gameObject:GameObjectVO;
				if(_selections)
				{
					len = _selections.length;
					while(len--)
					{
						gameObject = _selections[len] as GameObjectVO;
						gameObject.selected = false;
					}
				}
				_selections = value;
				if(_selections)
				{
					len = _selections.length;
					while(len--)
					{
						gameObject = _selections[len] as GameObjectVO;
						gameObject.selected = true;
					}
				}
				dispatch(new Event("selectionsChanged"));
			}
		}
		
		public function get lastSelected():GameObjectVO { return _lastSelected; }
		public function set lastSelected(value:GameObjectVO):void
		{
			if(value !== _lastSelected)
			{
				if(_lastSelected)
					_lastSelected.selected = false;
				
				_lastSelected = value;
				
				if(_lastSelected)
					_lastSelected.selected = true;
				
				dispatch(new Event("lastSelectedChanged"));
			}
		}
		
		public function LevelModel()
		{
			super();
		}
		
		
		public function setSelection(gameObject:GameObjectVO):void
		{
			lastSelected = gameObject;
			selections = new ArrayCollection([gameObject]);
		}
		
		public function clearAllSelections():void
		{
			selections = null;
		}
		
		public function addSelection(gameObject:GameObjectVO):void
		{
			if(selections)
			{
				if(selections.contains(gameObject) == false)
				{
					gameObject.selected = true;
					selections.addItem(gameObject);
				}
			}
			else
			{
				lastSelected = gameObject;
				selections = new ArrayCollection([gameObject]);
			}
		}
		
		public function setSelectedIndices(indices:Vector.<int>):void
		{
			lastSelected = null;
			if(level && level.events)
			{
				var newSelections:ArrayCollection = new ArrayCollection();
				var len:int = indices.length;
				while(len--)
				{
					var index:int = indices[len];
					var go:GameObjectVO = level.events[index];
					newSelections.addItem(go);
				}
				selections = newSelections;
			}
		}
		
		public function deleteSelected():void
		{
			if(selections)
			{
				var len:int = selections.length;
				while(len--)
				{
					var gameObject:GameObjectVO = selections[len] as GameObjectVO;
					var index:int = level.events.getItemIndex(gameObject);
					level.events.removeItemAt(index);
				}
			}
			lastSelected = null;
		}
		
		public function resetOriginalPoint():void
		{
			// NOTE: this was done to allow the objects to know where they should move in relation
			// to where you're draging + in relation to eachother.
			if(selections == null)
				return;
			
			var len:int = selections.length;
			while(len--)
			{
				var gameObject:GameObjectVO = selections[len] as GameObjectVO;
				gameObject.originalPoint = new Point(gameObject.x, gameObject.y);
			}
		}
		
		public function onDrag(offsetX:Number, offsetY:Number):void
		{
			if(selections == null)
				return;
			
			var len:int = _selections.length;
			while(len--)
			{
				var gameObject:GameObjectVO = selections[len] as GameObjectVO;
				gameObject.x = gameObject.originalPoint.x - offsetX;
				gameObject.y = gameObject.originalPoint.y - offsetY;
			}	
		}
		
		public function onMove(x:Number, y:Number):void
		{
			if(selections)
			{
				var len:int = selections.length;
				while(len--)
				{
					var gameObject:GameObjectVO = selections[len] as GameObjectVO;
					gameObject.x += x;
					gameObject.y += y;
				}
			}
		}
		
		public function onResize(width:Number, height:Number):void
		{
			if(selections)
			{
				var len:int = selections.length;
				while(len--)
				{
					var gameObject:GameObjectVO = selections[len] as GameObjectVO;
					gameObject.width += width;
					gameObject.height += height;
				}
			}
		}
		
		public function duplicateSelectedObjects():void
		{
			if(selections == null || level == null || level.events == null)
				return;
			
			var len:int = selections.length;
			var newSelections:ArrayCollection = new ArrayCollection();
			for(var index:int = 0; index < len; index++)
			{
				var go:GameObjectVO = selections[index];
				var cloned:GameObjectVO = go.clone();
				level.events.addItem(cloned);
				newSelections.addItem(cloned);
			}
			selections = newSelections;
		}
	}
}