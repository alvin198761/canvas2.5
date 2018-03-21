package com.print.util
{
	
	/**
	 * 画图插件工具类
	 * @author 唐植超
	 *
	 */
	public class DrawBoardUtil
	{
		
		public function DrawBoardUtil()
		{
		}
		private static var randomId:int=0;
		public static var model:DrawModle=null;
		
		private static function init():void
		{
			randomId=Math.abs(-new Date().getTime());
		}
		
		/**
		 * 唯一标号
		 */
		public static function getLongId():String
		{
			if (randomId == 0)
			{
				init();
			}
			return (++randomId).toString();
		}
		
	}
}


