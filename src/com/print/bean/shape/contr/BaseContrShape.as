package com.print.bean.shape.contr
{
	import com.print.bean.shape.BaseShape;
	import com.print.bean.shape.datashape.BaseDataShape;
	
	/**
	 *控制图形的组件的父类
	 */
	public class BaseContrShape extends BaseShape
	{
		public static const DEFAULT_WIDTH:Number=8;
		public static const DEFAULT_HEIGHT:Number=8;
		
		public static const WAY_TOP:String="TOP";
		public static const WAY_BOTTOM:String="BOTTOM";
		public static const WAY_LEFT:String="LEFT";
		public static const WAY_RIGHT:String="RIGHT";
		//控制图形的方向
		private var _way:String;
		//被控制的图形
		private var _contrlShape:BaseShape;
		
		public function BaseContrShape(way:String, shape:BaseShape)
		{
			super();
			width=DEFAULT_WIDTH;
			height=DEFAULT_HEIGHT;
			this._way=way;
			this._contrlShape=shape;
		}
		
		public function get contrlShape():BaseShape
		{
			return _contrlShape;
		}
		
		public function get way():String
		{
			return _way;
		}
		
	}
}

