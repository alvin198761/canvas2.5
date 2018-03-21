package com.print.comp
{
	import com.print.bean.shape.shapepane.DrawPane;
	import com.print.event.LineShapeButtonEvent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	
	[Event(name="lineShape", type="com.print.event.LineShapeButtonEvent")]
	[Event(name="horizontalLineShape", type="com.print.event.LineShapeButtonEvent")]
	[Event(name="verticalLineShape", type="com.print.event.LineShapeButtonEvent")]
	
	public class ShapePaneAs extends Panel
	{
		private var _drawPane:DrawPane;
		
		public function ShapePaneAs()
		{
			super();
		}
		
		
		public function set drawPane(value:DrawPane):void
		{
			_drawPane=value;
		}
		
		//创建图形事件处理
		protected function createShapeAction(event:MouseEvent, type:String, shapeType:Number):void
		{
			_drawPane.createShape(event, type, shapeType);
		}
		
	}
}

