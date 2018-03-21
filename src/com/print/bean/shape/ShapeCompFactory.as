package com.print.bean.shape
{
	import com.print.bean.shape.ShapeTypeHelper;
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.datashape.line.HorizontalLineShape3;
	import com.print.bean.shape.datashape.line.LineShape;
	import com.print.bean.shape.datashape.line.VerticalLineShape3;
	import com.print.bean.shape.datashape.state.BaseStateShape;
	import com.print.bean.shape.datashape.state.BeginShape;
	import com.print.bean.shape.datashape.state.ConditionShape;
	import com.print.bean.shape.datashape.state.EndShape;
	import com.print.bean.shape.datashape.state.InterfaceShape;
	import com.print.bean.shape.datashape.state.LaneShape;
	import com.print.bean.shape.datashape.state.StateShape;
	
	
	public class ShapeCompFactory
	{
		
		public function ShapeCompFactory(single:Singleton)
		{
		}
		
		private static var instance:ShapeCompFactory;
		
		public static function getInstance():ShapeCompFactory
		{
			if (instance == null)
			{
				instance=new ShapeCompFactory(new Singleton());
			}
			return instance;
		}
		
		/**
		 * 图形创建工厂
		 * @param type
		 * @return
		 *
		 */
		public function createShape(type:Number):BaseDataShape
		{
			var shape:BaseDataShape=null;
			switch(type)
			{
				case ShapeTypeHelper.TYPE_LINE:
					shape=new LineShape();
					break;
				case ShapeTypeHelper.TYPE_BEGIN:
					shape=new BeginShape();
					break;
				case ShapeTypeHelper.TYPE_END:
					shape=new EndShape();
					break;
				case ShapeTypeHelper.TYPE_SWINLANE:
					shape=new LaneShape();
					break;
				case ShapeTypeHelper.TYPE_STATE:
					shape=new StateShape();
					break;
				case ShapeTypeHelper.TYPE_INTERFACE:
					shape=new InterfaceShape();
					break;
				case ShapeTypeHelper.TYPE_CONDITION:
					shape=new ConditionShape();
					break;
				case ShapeTypeHelper.TYPE_HFOLDLINE:
					shape=new HorizontalLineShape3();
					break;
				case ShapeTypeHelper.TYPE_VFOLDLINE:
					shape=new VerticalLineShape3();
					break;
				default:
					trace("不知道的图形");
					break;
			}
			return shape;
		}
		
	}
}

class Singleton
{
}

