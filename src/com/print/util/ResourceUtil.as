package com.print.util
{
	
	public class ResourceUtil
	{
		
		public function ResourceUtil()
		{
		}
		
		[Bindable]
		[Embed('images/zoomback.png')]
		public static var ZOOMBACK_ICON:Class;
		//预览图刷新
		[Bindable]
		[Embed('images/zoomin.png')]
		public static var ZOOMIN_ICON:Class;
		//缩小
		[Bindable]
		[Embed('images/zoomout.png')]
		public static var ZOOMOUT_ICON:Class;
		//放大 
		[Bindable]
		[Embed('images/cursorLine.gif')]
		public static var CURSORLINE_ICON:Class;
		//线的鼠标
	}
}

