package com.print.bean.shape.datashape.state
{
	import com.print.bean.shape.ShapeTypeHelper;
	
	/**
	 * 接口
	 * @author 唐植超
	 *
	 */
	public class InterfaceShape extends BaseStateShape
	{
		public static const interfaceWidth:Number=60;
		public static const interfaceHeight:Number=50;
		public static const scale:Number=2;
		
		public function InterfaceShape()
		{
			super();
			
			text="接口";
			
			type=ShapeTypeHelper.TYPE_INTERFACE;
			
			_contrl=true;
			_connection=true;
			_editabel=true;
			
			this.width=interfaceWidth;
			this.height=interfaceHeight;
		}
		
		override protected function paintComponent():void
		{
			super.paintComponent();
			
			var titleHeight:int=this.height / scale;
			graphics.lineStyle(borderStyle, borderColor);
			graphics.drawRect(0, 0, this.width, titleHeight);
			graphics.endFill();
			graphics.drawRect(0, titleHeight, this.width, titleHeight);
			//设置文字显示的框的高度
			edtor.height=titleHeight;
		}
		
		override public function set height(height:Number):void
		{
			super.height=interfaceHeight;
		}
	}
}

