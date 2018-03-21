package com.print.bean.shape.contr
{
	import com.print.bean.shape.BaseShape;
	import com.print.bean.shape.gui.ChangeSizeBox;
	
	import flash.events.MouseEvent;
	
	/**
	 *	用来改变控件的大小
	 */
	public class ChangeSizeContrlBox extends BaseContrShape
	{
		
		public function ChangeSizeContrlBox(way:String, shape:BaseShape)
		{
			super(way, shape);
			selectColor=0xff0000;
			bgColor=0xaaaaaa;
			
			width=DEFAULT_WIDTH;
			height=DEFAULT_HEIGHT;
		}
		
		/**
		 * 控制图形
		 * @param event
		 * @param subX
		 * @param subY
		 *
		 */
		public function contrShape(event:MouseEvent, subX:Number, subY:Number):void
		{
			switch(way)
			{
				case WAY_LEFT:
				{
					ChangeSizeBox(contrlShape).contrlLeft(event, subX, subY);
					break;
				}
				case WAY_RIGHT:
				{
					ChangeSizeBox(contrlShape).contrlRight(event, subX, subY);
					break;
				}
				case WAY_TOP:
				{
					ChangeSizeBox(contrlShape).controlTop(event, subX, subY);
					break;
				}
				case WAY_BOTTOM:
				{
					ChangeSizeBox(contrlShape).controlBottom(event, subX, subY);
					break;
				}
				default:
				{
					trace("不明方向");
					break;
				}
			}
		}
		
		override protected function paintComponent():void
		{
			graphics.clear();
			if (select)
			{
				graphics.beginFill(selectColor);
			}
			else
			{
				graphics.beginFill(bgColor);
			}
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		override public function set select(value:Boolean):void
		{
			super.select=value;
			if (value)
			{
				contrlShape.select=true;
			}
		}
		
	}
}

