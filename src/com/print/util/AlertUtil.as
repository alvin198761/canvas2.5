package com.print.util
{
	import mx.controls.Alert;
	
	public class AlertUtil
	{
		
		/**
		 *
		 */
		public function AlertUtil()
		{
		}
		
		/**
		 * 普通提示框
		 */
		public static function showInfo(value:String):void
		{
			Alert.okLabel="确定";
			Alert.show(value, "提示");
		}
		
		/**
		 * 选择提示框
		 */
		public static function getAlert(message:String, func:Function):void
		{
			Alert.yesLabel="确定";
			Alert.noLabel="取消";
			Alert.show(message, "提示", 3, null, func);
		}
	}
}

