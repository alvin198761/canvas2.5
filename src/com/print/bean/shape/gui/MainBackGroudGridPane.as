package com.print.bean.shape.gui
{
	
	/**
	 * 绘图界面的网格
	 * @author 唐植超
	 *
	 */
	public class MainBackGroudGridPane extends BaseGUI
	{
		
		public function MainBackGroudGridPane()
		{
			super();
			
		}
		
		public function init():void
		{
			x=0;
			y=0;
			width=parent.width;
			height=parent.height;
			graphics.clear();
			graphics.beginFill(0xffffff);
			graphics.lineStyle(1, 0xeeeeee);
			graphics.endFill();
			var gw:int=10;
			var numw:int=parent.width / gw;
			var numh:int=parent.height / gw;
			var i:int;
			for(i=0; i < numw; i++)
			{
				graphics.moveTo(gw * i, 0);
				graphics.lineTo(gw * i, parent.height);
			}
			
			for(i=0; i < numh; i++)
			{
				graphics.moveTo(0, gw * i);
				graphics.lineTo(parent.width, gw * i);
			}
		}
	}
}

