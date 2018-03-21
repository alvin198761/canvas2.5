package com.print.bean.entity
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 显示比率的实体类
	 */
	public class ScaleItemBean extends BaseObject
	{
		private var _label:String;
		private var _value:Number;
		
		public function ScaleItemBean()
		{
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(value:Number):void
		{
			_value=value;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label=value;
		}
		
		/**
		 * 默认集合
		 * @return
		 *
		 */
		public static function getDefaultList():ArrayCollection
		{
			var list:ArrayCollection=new ArrayCollection();
			var bean:ScaleItemBean=null;
			
			bean=new ScaleItemBean();
			bean._label="50%";
			bean._value=.5;
			list.addItem(bean);
			
			bean=new ScaleItemBean();
			bean._label="75%";
			bean._value=.75;
			list.addItem(bean);
			
			bean=new ScaleItemBean();
			bean._label="100%";
			bean._value=1;
			list.addItem(bean);
			
			bean=new ScaleItemBean();
			bean._label="200%";
			bean._value=2;
			list.addItem(bean);
			
			bean=new ScaleItemBean();
			bean._label="400%";
			bean._value=4;
			list.addItem(bean);
			
			return list;
		}
		
	}
}

