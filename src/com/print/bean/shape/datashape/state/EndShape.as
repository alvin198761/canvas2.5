package com.print.bean.shape.datashape.state
{
	import com.print.bean.shape.ShapeTypeHelper;
	
	
	/**
	 *结束
	 * @author 唐植超
	 */
	public class EndShape extends BaseStateShape
	{
		private static const endWidth:int=33;
		private static const rwidth:int=4;
		
		public function EndShape()
		{
			super();
			text="结束";
			type=ShapeTypeHelper.TYPE_END;
			_changeSize=false;
			_contrl=false;
			_editabel=false;
			
			bgColor=0x666666;
			
			this.width=endWidth;
			this.height=endWidth;
		}
		
		override protected function paintComponent():void
		{
			graphics.clear();
			graphics.lineStyle(borderStyle, borderColor)
			graphics.drawEllipse(0, 0, endWidth, endWidth);
			graphics.lineStyle(borderStyle, borderColor)
			if (select)
			{
				graphics.beginFill(selectColor);
			}
			else
			{
				graphics.beginFill(bgColor);
			}
			graphics.drawEllipse(rwidth, rwidth, endWidth - (rwidth << 1), endWidth - (rwidth << 1));
			graphics.endFill();
			resetChildren();
		}
		
		override public function get width():Number
		{
			return endWidth;
		}
		
		override public function set width(value:Number):void
		{
			super.width=endWidth;
		}
		
		override public function get height():Number
		{
			return endWidth;
		}
		
		override public function set height(value:Number):void
		{
			super.height=endWidth;
		}
		
		override public function set text(value:String):void
		{
			
		}
	}
}

