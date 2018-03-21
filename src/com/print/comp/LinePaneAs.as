package com.print.comp
{
	import com.print.bean.shape.shapepane.DrawPane;
	import com.print.event.LineShapeButtonEvent;
	import com.print.util.ResourceUtil;
	
	import flash.events.Event;
	
	import mx.containers.Panel;
	import mx.managers.CursorManager;
	
	public class LinePaneAs extends Panel
	{
		private var _drawPane:DrawPane;
		
		public function LinePaneAs()
		{
			super();
		}
		
		//创建线条的事件处理
		
		public function get drawPane():DrawPane
		{
			return _drawPane;
		}
		
		public function set drawPane(value:DrawPane):void
		{
			_drawPane=value;
		}
		
		protected function createLineAction(event:Event, type:String, shapeType:Number):void
		{
			var action:LineShapeButtonEvent=new LineShapeButtonEvent(type, shapeType);
			_drawPane.createLineShapeAction(action);
			
			CursorManager.setCursor(ResourceUtil.CURSORLINE_ICON);
			CursorManager.showCursor();
		}
	}
}

