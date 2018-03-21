package com.print.event
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 拖动图形的按钮 的监听
	 * @author 唐植超
	 *
	 */
	public class LineShapeButtonEvent extends MouseEvent
	{
		public static const LINESHAPE:String="lineShape";
		public static const HLINESHAPE:String="hLineShape";
		public static const VLINEHAPE:String="vLineShape";
		
		public var shapeType:Number;
		
		public function LineShapeButtonEvent(type:String, shapeType:Number, bubbles:Boolean=true, cancelable:Boolean=false, localX:Number=0, localY:Number=0, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0)
		{
			super("mouseMove", bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
			this.shapeType=shapeType;
		}
	}
}

