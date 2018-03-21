package com.print.event
{
	import flash.events.Event;
	
	/**
	 * 工具条上面的按钮事件
	 * @author 唐植超
	 *
	 */
	public class ToolbarEvent extends Event
	{
		public static const OPEN:String="open";
		public static const SAVE:String="save";
		public static const COPY:String="copy";
		public static const PASTE:String="paste";
		public static const CUT:String="cut";
		public static const UNDO:String="undo";
		public static const REDO:String="redo";
		public static const SELECTALL:String="selectAll";
		public static const EXIT:String="exit";
		
		public function ToolbarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}

