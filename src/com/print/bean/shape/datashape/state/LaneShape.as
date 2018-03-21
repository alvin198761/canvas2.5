package com.print.bean.shape.datashape.state
{
	import com.print.bean.shape.ShapeTypeHelper;
	import com.print.bean.shape.contr.BaseContrShape;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *泳道图形
	 * @author 唐植超
	 *
	 */
	public class LaneShape extends BaseStateShape
	{
		public static const titleHeight:int=45;
		public static const DEFAULT_HEIGHT:Number=1000;
		
		public function LaneShape()
		{
			super();
			
			text="泳道";
			_contrl=true;
			_connection=false;
			_editabel=true;
			
			type=ShapeTypeHelper.TYPE_SWINLANE;
			this.width=200;
			
			lineCursor=false;
			
		}
		
		override protected function paintComponent():void
		{
			super.paintComponent();
			
			edtor.height=titleHeight;
			graphics.lineStyle(borderStyle, borderColor);
			graphics.drawRect(0, 0, this.width, titleHeight);
			graphics.endFill();
			graphics.drawRect(0, titleHeight, this.width, DEFAULT_HEIGHT - titleHeight);
		}
		
		override public function set y(value:Number):void
		{
			if (model == MODEL_PREVIEW)
			{
				super.y=value;
				return ;
			}
			super.y=0;
		}
		
		override public function set height(value:Number):void
		{
			super.height=DEFAULT_HEIGHT;
		}
		
		override public function getBox():Rectangle
		{
			return new Rectangle(this.x, this.y, this.width, titleHeight);
		}
		
		/**
		 * 得到左边的控制点的位置
		 * @return
		 *
		 */
		override public function getLeftPoint():Point
		{
			var p:Point=new Point();
			p.x= 0 - (BaseContrShape.DEFAULT_WIDTH >> 1);
			p.y=(titleHeight - BaseContrShape.DEFAULT_HEIGHT) >> 1;
			return p;
		}
		
		/**
		 *  得到右边的控制点的位置
		 * @return
		 *
		 */
		override public function getRightPoint():Point
		{
			var p:Point=new Point();
			p.x=width - (BaseContrShape.DEFAULT_WIDTH >> 1);
			p.y=(titleHeight - BaseContrShape.DEFAULT_HEIGHT) >> 1;
			return p;
		}
		
		override public function set lineCursor(value:Boolean):void
		{
			super.lineCursor=false;
		}
		
		override public function get lineCursor():Boolean
		{
			return false;
		}
	}
}

