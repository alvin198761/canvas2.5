package com.print.bean.shape.datashape.line
{
	import com.print.bean.shape.contr.BaseContrShape;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * 直线
	 * @author 唐植超
	 *
	 */
	public class LineShape extends BaseLineShape
	{
		
		public function LineShape()
		{
		}
		
		override protected function paintComponent():void
		{
			super.paintComponent();
			//文字位置
			var w:Number=_endX - _startX;
			var h:Number=_endY - _startY;
			
			edtor.x=_startX;
			edtor.y=_startY;
			edtor.width=w;
			edtor.height=h;
			if (w < 0)
			{
				edtor.x=_endX;
				edtor.width=Math.abs(w);
			}
			
			
			if (this.height < 0)
			{
				edtor.y=_endX;
				edtor.height=Math.abs(h);
			}
			this.graphics.clear();
			var currentColor:uint;
			if (select)
			{
				currentColor=selectColor;
			}
			else
			{
				currentColor=bgColor;
			}
			
			// draw Anchor
			if (_hasAnchor)
			{
				this.graphics.lineStyle(2, currentColor, 0.30);
				this.graphics.beginFill(currentColor, 0.30);
				this.graphics.drawCircle(_startX, _startY, 4);
				this.graphics.endFill();
				
				this.graphics.lineStyle(2, currentColor, 0.7);
				this.graphics.beginFill(currentColor, 0.7);
				this.graphics.drawCircle(_startX, _startY, 3);
				this.graphics.endFill();
			}
			// draw line
			this.graphics.lineStyle(borderStyle, currentColor);
			this.graphics.moveTo(_startX, _startY);
			this.graphics.lineTo(_endX, _endY);
			
			// draw arrow
			drawArrow();
		}
		
		/**
		 * get the angle of the arrow
		 * */
		private function getAngle():Number
		{
			var tmpx:Number=_endX - _startX;
			var tmpy:Number=_startY - _endY;
			var angle:Number=Math.atan2(tmpy, tmpx) * (180 / Math.PI);
			return angle;
		}
		
		/**
		 *画箭头
		 */
		override protected function drawArrow(sp:Point=null, ep:Point=null):void
		{
			var angle:Number=this.getAngle();
			var centerX:Number=_endX - radius * Math.cos(angle * (Math.PI / 180));
			var centerY:Number=_endY + radius * Math.sin(angle * (Math.PI / 180));
			var topX:Number=_endX;
			var topY:Number=_endY;
			var leftX:Number=centerX + radius * Math.cos((angle + 120) * (Math.PI / 180));
			var leftY:Number=centerY - radius * Math.sin((angle + 120) * (Math.PI / 180));
			var rightX:Number=centerX + radius * Math.cos((angle + 240) * (Math.PI / 180));
			var rightY:Number=centerY - radius * Math.sin((angle + 240) * (Math.PI / 180));
			
			var currentColor:uint;
			if (select)
			{
				currentColor=selectColor;
			}
			else
			{
				currentColor=bgColor;
			}
			this.graphics.beginFill(currentColor, 1);
			this.graphics.lineStyle(borderStyle, currentColor);
			this.graphics.moveTo(topX, topY);
			this.graphics.lineTo(leftX, leftY);
			this.graphics.lineTo(centerX, centerY);
			this.graphics.lineTo(rightX, rightY);
			this.graphics.lineTo(topX, topY);
			this.graphics.endFill();
		}
		
		override public function containsPoint():Boolean
		{
			var px:Number=mouseX;
			var py:Number=mouseY;
			var w:Number=_endX - _startX;
			var h:Number=_endY - _startY;
			var rx:Number;
			var ry:Number;
			var rw:Number;
			var rh:Number;
			
			var a:Point=new Point();
			var b:Point=new Point();
			var c:Point=new Point();
			var rect:Rectangle=new Rectangle();
			
			var result:Boolean=false;
			//如果不在当前图形中
			rect=getBox();
			if (Math.abs(rect.width) < 5 && Math.abs(rect.width) > -5)
			{
				rect.x-=2.5;
				rect.width=5;
				
				return rect.contains(px, py);
			}
			if (Math.abs(rect.height) < 5 && Math.abs(rect.height) > -5)
			{
				rect.y-=2.5;
				rect.height=5;
				return rect.contains(px, py);
			}
			if (!rect.contains(px, py))
			{
				return false;
			}
			//
			if (Math.abs(w) <= 5 || Math.abs(h) <= 5)
			{
				return true;
			}
			//创建两个三角形，如果这两个三角形中有一个存在鼠标的位置，那么久代表没有选中
			//宽度小于 -5的情况
			rw=rect.width;
			rh=rect.height;
			rx=rect.x;
			ry=rect.y;
			if (w < -5)
			{
				//高度小于 -5
				if (h < -5)
				{
					a.x=rx + 5;
					a.y=ry;
					
					b.x=rx + rw;
					b.y=ry + rh - 5;
					
					c.x=rx + rw;
					c.y=ry;
					
					result=inTriangle(new Point(px, py), a, b, c);
					if (result)
					{
						return false;
					}
					
					a.x=rx;
					a.y=ry + 5;
					
					b.x=rx;
					b.y=ry + rh;
					
					c.x=rx + rw - 5;
					c.y=ry + rh;
					
					result=inTriangle(new Point(px, py), a, b, c);
					if (result)
					{
						return false;
					}
					return true;
				}
				//高度大于5
				a.x=rx;
				a.y=ry;
				
				b.x=rx + rw - 5;
				b.y=ry;
				
				c.x=rx;
				c.y=ry + rh - 5;
				result=inTriangle(new Point(px, py), a, b, c);
				if (result)
				{
					return false;
				}
				
				a.x=rx + 5;
				a.y=ry + rh;
				
				b.x=rx + rw;
				b.y=ry + rh;
				
				c.x=rx + rw;
				c.y=ry + 5;
				
				result=inTriangle(new Point(px, py), a, b, c);
				if (result)
				{
					return false;
				}
				return true;
			}
			//宽度大于5 的情况
			//高度小于 -5
			if (h < -5)
			{
				a.x=rx;
				a.y=ry + rh - 5;
				
				b.x=rx;
				b.y=ry;
				
				c.x=rx + rw - 5;
				c.y=ry;
				
				result=inTriangle(new Point(px, py), a, b, c);
				if (result)
				{
					return false;
				}
				
				a.x=rx + 5;
				a.y=ry + rh;
				
				b.x=rx + rw;
				b.y=ry + 5;
				
				c.x=rx + rw;
				c.y=ry + rh;
				result=inTriangle(new Point(px, py), a, b, c);
				if (result)
				{
					return false;
				}
				return true;
			}
			//高度大于5
			if (h > 5)
			{
				a.x=rx;
				a.y=ry + 5;
				
				b.x=rx;
				b.y=ry + rh;
				
				c.x=rx + rw - 5;
				c.y=ry + rh;
				
				result=inTriangle(new Point(px, py), a, b, c);
				if (result)
				{
					return false;
				}
				
				a.x=rx + 5;
				a.y=ry;
				
				b.x=rx + rw;
				b.y=ry;
				
				c.x=rx + rw;
				c.y=ry + rh - 5;
				result=inTriangle(new Point(px, py), a, b, c);
				if (result)
				{
					return false;
				}
				return true;
			}
			return true;
		}
	}
}

