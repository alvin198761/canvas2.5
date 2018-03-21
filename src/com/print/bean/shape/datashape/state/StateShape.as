package com.print.bean.shape.datashape.state
{
	import com.print.bean.shape.ShapeTypeHelper;
	
	/**
	 *	状态图形
	 * @author 唐植超
	 *
	 */
	public class StateShape extends BaseStateShape
	{
		
		public function StateShape()
		{
			super();
			
			text="状态";
			type=ShapeTypeHelper.TYPE_STATE;
			_contrl=true;
			_connection=true;
			_editabel=true;
		}
		
		override protected function paintComponent():void
		{
			super.paintComponent();
			graphics.lineStyle(borderStyle, borderColor)
			graphics.drawEllipse(0, 0, this.width, this.height);
			graphics.endFill();
		}
	}
}

