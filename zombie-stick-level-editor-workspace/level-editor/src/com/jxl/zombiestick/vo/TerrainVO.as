package com.jxl.zombiestick.vo
{
	import mx.collections.ArrayCollection;

	public class TerrainVO
	{
		public var image:String;
		public var type:String;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var polygons:ArrayCollection;
		public var rotation:Number;
		public var density:Number;
		public var friction:Number;
		public var bounce:Number;
		public var physicsType:String;
		
		public function TerrainVO()
		{
		}
	}
}