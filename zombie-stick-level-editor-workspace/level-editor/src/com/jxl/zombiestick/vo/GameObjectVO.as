package com.jxl.zombiestick.vo
{
    import com.jxl.zombiestick.constants.GameObjectTypes;
    import com.jxl.zombiestick.constants.PhysicTypes;
	import com.jxl.zombiestick.constants.subtypes.TerrainTypes;

	import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    
    import mx.collections.ArrayCollection;

	public class GameObjectVO extends EventDispatcher
	{
		[Bindable(event="xChanged")]
		public function get x():Number {
			return _x;
		}
		
		public function set x(value:Number):void {
			_x = value;
			dispatchEvent(new Event("xChanged"));
		}
		
		[Bindable(event="yChanged")]
		public function get y():Number {
			return _y;
		}
		
		public function set y(value:Number):void {
			_y = value;
			dispatchEvent(new Event("yChanged"));
		}
		
		[Bindable(event="widthChanged")]
		public function get width():Number {
			return _width;
		}
		
		public function set width(value:Number):void {
			_width = value;
			dispatchEvent(new Event("widthChanged"));
		}
		
		[Bindable(event="heightChanged")]
		public function get height():Number {
			return _height;
		}
		
		public function set height(value:Number):void {
			_height = value;
			dispatchEvent(new Event("heightChanged"));
		}
		
		[Bindable(event="typeChanged")]
		public function get type():String {
			return _type;
		}
		
		public function set type(value:String):void {
			_type = value;
			dispatchEvent(new Event("typeChanged"));
		}
		
		[Bindable(event="subTypeChanged")]
		public function get subType():String {
			return _subType;
		}
		
		public function set subType(value:String):void {
			_subType = value;
			dispatchEvent(new Event("subTypeChanged"));
		}
		
		[Bindable(event="imageChanged")]
		public function get image():String {
			return _image;
		}
		
		public function set image(value:String):void {
			_image = value;
			dispatchEvent(new Event("imageChanged"))
		}
		
		[Bindable(event="imageRelativeToLevelPathChanged")]
		public function get imageRelativeToLevelPath():Boolean {
			return _imageRelativeToLevelPath;
		}
		
		public function set imageRelativeToLevelPath(value:Boolean):void {
			_imageRelativeToLevelPath = value;
			dispatchEvent(new Event("imageRelativeToLevelPathChanged"))
		}

		[Bindable(event="densityChanged")]
		public function get density():Number
		{
			return _density;
		}

		public function set density(value:Number):void
		{
			_density = value;
			dispatchEvent(new Event("densityChanged"));
		}

		[Bindable(event="frictionChanged")]
		public function get friction():Number
		{
			return _friction;
		}

		public function set friction(value:Number):void
		{
			_friction = value;
			dispatchEvent(new Event("frictionChanged"));
		}

		[Bindable(event="bounceChanged")]
		public function get bounce():Number
		{
			return _bounce;
		}

		public function set bounce(value:Number):void
		{
			_bounce = value;
			dispatchEvent(new Event("bounceChanged"));
		}
		
		private var _image:String;	
		private var _type:String                 		= GameObjectTypes.TERRAIN;
		private var _subType:String						= TerrainTypes.CRATE;
		private var _x:Number                     		= 0;
		private var _y:Number                    		= 0;
		private var _width:Number                		= 35;
		private var _height:Number                		= 35;
		
		public var polygons:ArrayCollection;
		public var rotation:Number              		= 0;
		private var _density:Number						= 1; // wood = .3, water = 1, stone = 2
		private var _friction:Number					= .3; // ice = 0, velcro = 1
		private var _bounce:Number						= .2;
		public var physicsType:String					= PhysicTypes.DYNAMIC;
        private var _imageRelativeToLevelPath:Boolean 	= false;
		public var when:int 							= -1;
		public var pause:Boolean 						= false;
		
		public function GameObjectVO()
		{
		}
		
		public function toObject():Object
		{
			try
			{
				var obj:Object 					= {};
				obj.classType 					= "gameObject";
				// TODO: fix this to be relative
				if(_image && _image.length > 0)
				{
					obj.image						= _image;
					obj.imageShort					= _image.substring(_image.lastIndexOf("/") + 1, _image.length);
				}
				obj.type 						= _type;
				obj.subType						= _subType;
				obj.x 							= _x;
				obj.y							= _y;
				obj.width 						= _width;
				obj.height 						= _height;
				var len:int;
				if(polygons && polygons.length > 0)
				{
					obj.polygons 				= [];
					len 						= polygons.length;
					for(var index:int = 0; index < len; index++)
					{
						var point:Point 		= polygons[index] as Point;
						obj.polygons[index] = {x: point.x, y: point.y};
					}
				}
				obj.rotation					= rotation;
				obj.density 					= _density;
				obj.friction					= _friction;
				obj.bounce						= _bounce;
				obj.physicsType					= physicsType;
				obj.when						= when;
				obj.pause						= pause;
				return obj;
			}
			catch(err:Error)
			{
				trace("GameObjectVO::toObject, err: " + err);
			}
			return null;
		}
		
		public function buildFromObject(object:Object):void
		{
			image							= object.image;
			type 							= object.type;
			subType							= object.subType;
			x 								= object.x;
			y								= object.y;
			width 							= object.width;
			height 							= object.height;
			polygons						= new ArrayCollection();
			if(object.polygons && object.polygons.length > 0)
			{
				var len:int = object.polygons.length;
				for(var index:int = 0; index < len; index++)
				{
					var polyObject:Object 	= object.polygons[index];
					var point:Point 		= new Point(polyObject.x, polyObject.y);
					polygons.addItem(point);
				}
			}
			rotation						= object.rotation;
			density 						= isNaN(object.density) == true ? 1 : object.density;
			friction						= isNaN(object.friction) == true ? .3 : object.friction;
			bounce							= isNaN(object.bounce) == true ? .2 : object.bounce;
			physicsType						= object.physicsType;
			when							= object.when;
			pause							= object.pause;
		}



	}
}