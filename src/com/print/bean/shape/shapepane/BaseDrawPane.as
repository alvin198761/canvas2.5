package com.print.bean.shape.shapepane
{
	import com.print.bean.shape.gui.BaseGUI;
	
	import mx.collections.ArrayCollection;
	
	public class BaseDrawPane extends BaseGUI
	{
		
		public function BaseDrawPane()
		{
			super();
		}
		//界面中所有的要操作的图形
		protected var _shapes:ArrayCollection=new ArrayCollection();
		
		public function get shapes():ArrayCollection
		{
			return _shapes;
		}
		
		public function set shapes(value:ArrayCollection):void
		{
			_shapes=value;
		}
		
	}
}

