package com.print.comp
{
	import mx.containers.VBox;
	
	public class OperateBoxAs extends VBox
	{
		
		public function OperateBoxAs()
		{
			super();
		}
		
		protected function init(win:OperateBox):void
		{
			win.mainBox.getDividerAt(0).visible=false;
		}
		
	}
}

