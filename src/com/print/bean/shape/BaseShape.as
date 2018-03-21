package com.print.bean.shape
{
	import com.print.bean.shape.contr.BaseContrShape;
	import com.print.util.DrawBoardUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.Container;
	
	/**
	 *所有图形的父类
	 *
	 */
	public class BaseShape extends Container
	{
		private var _bgColor:uint=0xbbeec2;
		//背景颜色
		private var _selectColor:uint=0xffff00;
		//选中后的颜色
		private var _borderStyle:Number=1;
		//边框样式
		private var _timeId:String;
		//唯一 id
		private var _select:Boolean=false;
		//是否选中
		private var _type:Number
		//所属类型
		private var _borderColor:uint=0x000000;
		//边框颜色
		//V2.3新增属性
		
		//如果当前的鼠标时划线状态，并且正好在当前这个图形上面，则为true，否则为false 默认为false
		protected var _lineCursor:Boolean=false;
		
		public function BaseShape()
		{
			super();
			this._timeId=DrawBoardUtil.getLongId();
		}
		
		public function set timeId(value:String):void
		{
			_timeId=value;
		}
		
		public function set type(value:Number):void
		{
			_type=value;
		}
		
		public function get type():Number
		{
			return _type;
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function set select(value:Boolean):void
		{
			_select=value;
			//重绘当前控件
			repaint();
			
		}
		
		public function get borderStyle():Number
		{
			return _borderStyle;
		}
		
		public function set borderStyle(value:Number):void
		{
			_borderStyle=value;
			repaint();
		}
		
		public function get selectColor():uint
		{
			return _selectColor;
		}
		
		public function set selectColor(value:uint):void
		{
			_selectColor=value;
		}
		
		public function get bgColor():uint
		{
			return _bgColor;
		}
		
		public function set bgColor(value:uint):void
		{
			_bgColor=value;
		}
		
		public function get timeId():String
		{
			return _timeId;
		}
		
		public function get borderColor():uint
		{
			return _borderColor;
		}
		
		public function set borderColor(value:uint):void
		{
			_borderColor=value;
		}
		
		
		/**
		 * 重新绘制图形
		 *
		 */
		public function repaint():void
		{
			paintComponent();
			//画红边框
			paintSelectBorder();
		}
		
		/**
		 * 绘制图形的细节
		 *
		 */
		protected function paintComponent():void
		{
			graphics.clear();
			//根据选中或不选择更改背景颜色
			if (_select)
			{
				graphics.beginFill(_selectColor);
			}
			else
			{
				graphics.beginFill(_bgColor);
			}
		}
		
		//图形的box框属性
		public function getBox():Rectangle
		{
			return new Rectangle(this.x, this.y, this.width, this.height);
		}
		
		
		/**
		 * 比较的方法
		 * @param obj
		 * @return
		 *
		 */
		public function equals(obj:Object):Boolean
		{
			if (obj == null)
			{
				return false;
			}
			if (!(obj is BaseShape))
			{
				return false;
			}
			return BaseShape(obj).timeId == this._timeId;
		}
		
		
		/**
		 * 得到左边的控制点的位置
		 * @return
		 *
		 */
		public function getLeftPoint():Point
		{
			var p:Point=new Point();
			p.x=0 - (BaseContrShape.DEFAULT_WIDTH >> 1) + 1;
			p.y=(this.height - BaseContrShape.DEFAULT_HEIGHT) >> 1;
			return p;
		}
		
		/**
		 *  得到右边的控制点的位置
		 * @return
		 *
		 */
		public function getRightPoint():Point
		{
			var p:Point=new Point();
			p.x=width - (BaseContrShape.DEFAULT_WIDTH >> 1) - 1;
			p.y=(this.height - BaseContrShape.DEFAULT_HEIGHT) >> 1;
			return p;
		}
		
		/**
		 *得到左边的控制点的位置
		 * @return
		 *
		 */
		public function getTopPoint():Point
		{
			var p:Point=new Point();
			p.x=(width - BaseContrShape.DEFAULT_WIDTH) >> 1;
			p.y=-(BaseContrShape.DEFAULT_HEIGHT >> 1) + 1;
			return p;
		}
		
		/**
		 * 得到底部的控制点的位置
		 * @return
		 *
		 */
		public function getBottomPoint():Point
		{
			var p:Point=new Point();
			p.x=(width - BaseContrShape.DEFAULT_WIDTH) >> 1;
			p.y=height - (BaseContrShape.DEFAULT_HEIGHT >> 1) - 1;
			return p;
		}
		
		//V2.3新方法
		
		//鼠标划线的时候已过控件
		protected function paintSelectBorder():void
		{
			if (_lineCursor)
			{
				this.graphics.lineStyle(borderStyle << 1, 0xff0000);
				this.graphics.drawRect(0, 0, width, height);
			}
		}
		
		public function get lineCursor():Boolean
		{
			return _lineCursor;
		}
		
		public function set lineCursor(value:Boolean):void
		{
			_lineCursor=value;
			repaint();
		}
		
		public function containsMouse():Boolean
		{
			return new Rectangle(0, 0, this.width, this.height).contains(mouseX, mouseY);
		}
		
		public function cloneShape():BaseShape
		{
			return null;
		}
		
	}
}

