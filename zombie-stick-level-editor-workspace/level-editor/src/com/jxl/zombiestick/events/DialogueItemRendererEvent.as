package com.jxl.zombiestick.events
{
	import com.jxl.zombiestick.vo.DialogueVO;
	
	import flash.events.Event;
	
	public class DialogueItemRendererEvent extends Event
	{
		
		public static const DELETE_DIALOGUE:String = "deleteDialogue";
		
		public var dialogue:DialogueVO;
		
		public function DialogueItemRendererEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}