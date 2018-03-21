package com.print.comp.editor
{
	import mx.controls.Label;
	import mx.controls.TextArea;
	
	/**
	 * 图形的文本显示对象
	 * @author 唐植超
	 *
	 */
	public class TextEdtor extends Label
	{
		
		public function TextEdtor()
		{
			selectable=false;
			x=0;
			y=0;
			setStyle("textAlign", "center");
			setStyle("fontSize", "13");
		}
		
		override public function set height(value:Number):void
		{
			super.height=value;
			setStyle("paddingTop", (value - 13.0) / 2.0);
		}
		
	}
}

