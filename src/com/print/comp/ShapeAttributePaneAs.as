package com.print.comp
{
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.shapepane.DrawPane;
	
	import flash.events.Event;
	
	import mx.containers.Panel;
	
	public class ShapeAttributePaneAs extends Panel
	{
		private var _currentShape:BaseDataShape=null;
		private var currentWin:ShapeAttributePane=null;
		private var _drawPane:DrawPane=null;
		
		public function ShapeAttributePaneAs()
		{
			super();
		}
		
		public function set drawPane(value:DrawPane):void
		{
			_drawPane=value;
		}
		
		protected function init(win:ShapeAttributePane):void
		{
			this.currentWin=win;
			_drawPane.shapeAttribte=currentWin;
		}
		
		public function get currentShape():BaseDataShape
		{
			return _currentShape;
		}
		
		public function set currentShape(value:BaseDataShape):void
		{
			_currentShape=value;
			if (value == null)
			{
				this.hide(false);
				return ;
			}
			this.hide(value.editabel);
			currentWin.shapeText.text=_currentShape.text;
		}
		
		public function hide(value:Boolean):void
		{
			currentWin.attForm.visible=value;
		}
		
		protected function keyAction(event:Event):void
		{
			if (_currentShape != null)
			{
				_currentShape.text=currentWin.shapeText.text;
			}
		}
		
	}
}

