/**
 * Created by IntelliJ IDEA.
 * User: jesterxl
 * Date: 9/25/11
 * Time: 5:01 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.zombiestick.events
{
	import flash.events.Event;

	public class GameObjectViewEvent extends Event
	{
		public static const DELETE:String = "delete";

		public function GameObjectViewEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=true)
		{
			super(type,  bubbles, cancelable);
		}
	}
}
