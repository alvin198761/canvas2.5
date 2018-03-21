package com.print.bean.shape.datashape.line
{
	import com.print.bean.shape.BaseShape;
	import com.print.bean.shape.ShapeTypeHelper;
	import com.print.bean.shape.contr.BaseContrShape;
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.datashape.state.BaseStateShape;
	
	import mx.collections.ArrayCollection;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 连线的基类
	 * @author 唐植超
	 *
	 */
	public class BaseLineShape extends BaseDataShape
	{
		//arrow
		public static const radius:Number=6;
		//开始和结束的图形
		protected var _startShape:BaseStateShape;
		protected var _endShape:BaseStateShape;
		//线条属性
		protected var _startX:Number;
		protected var _startY:Number;
		protected var _endX:Number;
		protected var _endY:Number;
		//是否有锚点
		protected var _hasAnchor:Boolean;
		
		public function BaseLineShape()
		{
			super();
			
			text="";
			contrl=false;
			
			type=ShapeTypeHelper.TYPE_LINE;
			
			selectColor=0xff0000;
			bgColor=0x999999;
			
			connection=false;
			editabel=true;
			
			drag=false;
			
			initContrBox();
		}
		
		public function get hasAnchor():Boolean
		{
			return _hasAnchor;
		}
		
		public function set hasAnchor(value:Boolean):void
		{
			_hasAnchor=value;
		}
		
		public function get endShape():BaseStateShape
		{
			return _endShape;
		}
		
		public function set endShape(value:BaseStateShape):void
		{
			_endShape=value;
			value.addLine(this);
		}
		
		public function get startShape():BaseStateShape
		{
			return _startShape;
		}
		
		public function set startShape(value:BaseStateShape):void
		{
			_startShape=value;
			value.addLine(this);
		}
		
		public function get endY():Number
		{
			return _endY;
		}
		
		public function set endY(value:Number):void
		{
			_endY=value;
		}
		
		public function get endX():Number
		{
			return _endX;
		}
		
		public function set endX(value:Number):void
		{
			_endX=value;
		}
		
		public function get startY():Number
		{
			return _startY;
		}
		
		public function set startY(value:Number):void
		{
			_startY=value;
		}
		
		public function get startX():Number
		{
			return _startX;
		}
		
		public function set startX(value:Number):void
		{
			_startX=value;
		}
		 
		/**
		 *画箭头
		 */
		protected function drawArrow(sp:Point=null, ep:Point=null):void
		{
			
		}
		
		protected function changePoint():void
		{
			if (startShape == null || endShape == null)
			{
				return ;
			}
			var sP:Point=new Point(startShape.x + startShape.width / 2, startShape.y + startShape.height / 2);
			var eP:Point=new Point(endShape.x + endShape.width / 2, endShape.y + endShape.height / 2);
			var tempP:Point;
			if ((eP.x > sP.x) && (Math.abs(eP.x - sP.x) > Math.abs(eP.y - sP.y)))
			{
				// -45°< p < 45°
				startShape.removeLine(this);
				startShape.addLineAt(BaseContrShape.WAY_RIGHT, this);
				
				endShape.removeLine(this);
				endShape.addLineAt(BaseContrShape.WAY_LEFT, this);
				
			}
			else if ((eP.x < sP.x) && (Math.abs(eP.x - sP.x) > Math.abs(eP.y - sP.y)))
			{
				// 135°< p <225°
				startShape.removeLine(this);
				startShape.addLineAt(BaseContrShape.WAY_LEFT, this);
				
				endShape.removeLine(this);
				endShape.addLineAt(BaseContrShape.WAY_RIGHT, this);
			}
			else if ((eP.y > sP.y) && (Math.abs(eP.x - sP.x) < Math.abs(eP.y - sP.y)))
			{
				// 225°< p <315°
				startShape.removeLine(this);
				startShape.addLineAt(BaseContrShape.WAY_BOTTOM, this);
				
				endShape.removeLine(this);
				endShape.addLineAt(BaseContrShape.WAY_TOP, this);
			}
			else if ((eP.y < sP.y) && (Math.abs(eP.x - sP.x) < Math.abs(eP.y - sP.y)))
			{
				// 45°< p <135°
				startShape.removeLine(this);
				startShape.addLineAt(BaseContrShape.WAY_TOP, this);
				
				endShape.removeLine(this);
				endShape.addLineAt(BaseContrShape.WAY_BOTTOM, this);
			}
			else
			{
			}
		}
		
		override public function getMiddlePoint():Point
		{
			var rp:Point=new Point;
			rp.x=startX + ((endX - startX) >> 1);
			rp.y=startY + ((endY - startY) >> 1);
			return rp;
		}
		
		/**
		 *移动开始的图形
		 */
		public function moveStartShape():void
		{
			changePoint();
			invalidateDisplayList();
			repaint();
		}
		
		/**
		 *移动开始的图形
		 */
		public function moveEndShape():void
		{
			changePoint();
			invalidateDisplayList();
			repaint();
		}
		
		/**
		 * 释放内存
		 */
		override public function dispose():void
		{
			startShape.removeLine(this);
			endShape.removeLine(this);
		}
		
		override public function getBox():Rectangle
		{
			var bx:Number;
			var by:Number;
			var bw:Number;
			var bh:Number;
			
			bx=Math.min(_startX, _endX);
			by=Math.min(_startY, _endY);
			bw=Math.abs(_endX - _startX);
			bh=Math.abs(_endY - _startY);
			return new Rectangle(bx, by, bw, bh);
		}
		
		/**
		 * 有没有连接错误
		 * @return
		 *
		 */
		public function isErrorConnection():Boolean
		{
			var error:Boolean=(startShape == null || endShape == null);
			if (!error)
			{
				return error;
			}
			
			if (startShape != null)
			{
				startShape.removeLine(this);
				return error;
			}
			
			if (endShape != null)
			{
				endShape.removeLine(this);
				return error;
			}
			
			return error;
		}
		
		/**
		 * 是否选中了线条
		 * @return
		 *
		 */
		public function containsPoint():Boolean
		{
			return false;
		}
		
		//V2.3新方法
		
		//鼠标划线的时候已过控件
		override protected function paintSelectBorder():void
		{
			if (_lineCursor)
			{
				this.graphics.lineStyle(borderStyle << 1, 0xff0000);
				this.graphics.drawRect(0, 0, width, height);
			}
		}
		
		override public function cloneShape():BaseShape
		{
			var shape:BaseLineShape=new BaseLineShape();
			shape.model=this.model;
			shape.x=this.x;
			shape.y=this.y;
			shape.width=this.width;
			shape.height=this.height;
			shape.text=this.text;
			shape.select=this.select;
			return shape;
		}
		
		/**
		 *连线自动和组件相连
		 * @param shapes
		 *
		 */
		public function autoRelation(shapes:ArrayCollection):void
		{
			for each(var shape:BaseDataShape in shapes)
			{
				if (shape is BaseLineShape)
				{
					continue;
				}
				if (shape.equals(this))
				{
					continue;
				}
				if (!shape.connection)
				{
					continue;
				}
				if (this.startShape == null)
				{
					if (shape.getBox().contains(startX, startY))
					{
						if (!(shape.equals(this.endShape)))
						{
							this._startShape=BaseStateShape(shape);
							shape.addLine(this);
							shape.contrlLines();
							continue;
						}
					}
				}
				
				if (this.endShape == null)
				{
					if (shape.getBox().contains(endX, endY))
					{
						if (!(shape.equals(this.startShape)))
						{
							this.endShape=BaseStateShape(shape);
							shape.addLine(this);
							shape.contrlLines();
							continue;
						}
					}
				}
			}
		}
		
	}
}

