package com.print.util
{
	import mx.core.Singleton;
	
	/**
	 * 对外接口
	 * @author 唐植超
	 *
	 */
	public class InterfaceUtil
	{
		
		public function InterfaceUtil(single:Singleton)
		{
		}
		
		private static var instance:InterfaceUtil;
		
		public var mainFrame:Object=null;
		
		public var stateStr:String=null;
		
		/**
		 * 单例对象
		 */
		public static function getInstance():InterfaceUtil
		{
			if (instance == null)
			{
				instance=new InterfaceUtil(new Singleton())
			}
			return instance;
		}
	}
}

class Singleton
{
}

