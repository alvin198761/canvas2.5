package com.print.comp
{
	import com.print.event.LineShapeButtonEvent;
	
	import mx.containers.VBox;
	
	public class WorkNavigationAs extends VBox
	{
		[Bindable]
		protected var _operateBox:OperateBox;
		//当前窗体
		private var _currentWin:WorkNavigation;
		
		public function WorkNavigationAs()
		{
			super();
		}
		
		protected function init(win:WorkNavigation):void
		{
			this._currentWin=win;
		}
		
		public function set operateBox(value:OperateBox):void
		{
			_operateBox=value;
		}
		
		/**
		 * 创建连线
		 * @param event
		 *
		 */
		protected function createLineShape(event:LineShapeButtonEvent):void
		{
			_operateBox.drawPane.createLineShapeAction(event);
		}
	}
}

