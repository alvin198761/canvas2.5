package com.print.bean.shape.datashape.state
{
	import com.print.bean.shape.ShapeTypeHelper;
	
	/**
	 *条件图形
	 * @author 唐植超
	 *
	 */
	public class ConditionShape extends BaseStateShape
	{
		
		public function ConditionShape()
		{
			super();
			
			text="条件";
			type=ShapeTypeHelper.TYPE_CONDITION;
			_contrl=false;
			_connection=true;
			_editabel=true;
			_changeSize=false;
		}
		
		override protected function paintComponent():void
		{
			super.paintComponent();
			
			this.graphics.lineStyle(borderStyle, borderColor)
			this.graphics.moveTo(this.width >> 1, 0);
			this.graphics.lineTo(0, this.height >> 1);
			this.graphics.lineTo(this.width >> 1, this.height);
			this.graphics.lineTo(this.width, this.height >> 1);
			this.graphics.endFill();
		}
	}
}

