package com.print.bean.shape.datashape.state
{
	import com.print.bean.shape.ShapeTypeHelper;
	
	
	/**
	 *开始图形
	 * @author 唐植超
	 */
	public class BeginShape extends BaseStateShape
	{
		
		private static const startWidht:int=33;
		
		public function BeginShape()
		{
			super();
			
			bgColor=0x666666;
			
			text="开始";
			type=ShapeTypeHelper.TYPE_BEGIN;
			this.width=startWidht;
			this.height=startWidht;
			
			_contrl=false;
			_editabel=false;
			_changeSize=false;
			edtor.visible=false;
		}
		
		override protected function paintComponent():void
		{
			
			super.paintComponent();
			graphics.lineStyle(borderStyle, borderColor)
			graphics.drawEllipse(0, 0, startWidht, startWidht);
			graphics.endFill();
		}
		
		override public function get width():Number
		{
			return startWidht;
		}
		
		override public function set width(value:Number):void
		{
			super.width=startWidht;
		}
		
		override public function get height():Number
		{
			return startWidht;
		}
		
		override public function set height(value:Number):void
		{
			super.height=startWidht;
		}
		
		override public function set text(value:String):void
		{
			
		}
		
	}
}

