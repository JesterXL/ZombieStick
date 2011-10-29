package com.jxl.zombiestick.events
{
	import com.jxl.zombiestick.vo.MovieVO;
	
	import flash.events.Event;
	
	public class MovieItemRendererEvent extends Event
	{
		
		public static const EDIT_MOVIE:String = "editMovie";
		public static const DELETE_MOVIE:String = "deleteMovie";
		
		public var movie:MovieVO;
		
		public function MovieItemRendererEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}