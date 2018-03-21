package com.print.bean.shape.datashape.line
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.print.bean.shape.ShapeTypeHelper;
	
	public class VerticalLineShape3 extends BaseLineShape
	{
		//3个框框管选中
		private var rect1:Rectangle=new Rectangle();
		private var rect2:Rectangle=new Rectangle();
		private var rect3:Rectangle=new Rectangle();
		
		public function VerticalLineShape3()
		{
			super();
			type = ShapeTypeHelper.TYPE_VFOLDLINE;
		}
		
		/**when the node is dragging, check the distance
		 * between the center point of startShape and the
		 * center point of endShape
		 * */
		private var defaultDistance:Number=20;
		
		
		/**
		 * the VerticalLine example
		 * |							|
		 * |							|
		 * |							|
		 * |							|
		 * |							|
		 * --------|	or		--------|
		 * 		   |			|
		 * 		   |			|
		 * 		   |			|
		 * 		   |			|
		 * 		   |			|
		 * */
		
		override protected function createChildren():void
		{
			super.createChildren();
		}
		
		/**
		 * draw the vertical line
		 * */
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
			var currentColor:uint;
			if (select)
			{
				currentColor=selectColor;
			}
			else
			{
				currentColor=bgColor;
			}
			if ((_startX == 0) || (_startY == 0) || (_endX == 0) || (_endY == 0))
			{
				return ;
			}
			this.graphics.clear();
			// draw anchor
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
			//draw line
			this.graphics.lineStyle(borderStyle, currentColor);
			this.graphics.moveTo(_startX, _startY);
			var firstTurnPoint:Point=calcFirstPoint();
			this.graphics.lineTo(firstTurnPoint.x, firstTurnPoint.y);
			var secondTurnPoint:Point=calcSecondPoint(firstTurnPoint);
			this.graphics.lineTo(secondTurnPoint.x, secondTurnPoint.y);
			this.graphics.lineTo(_endX, _endY);
			
			//构建3个矩形
			resetLineRange(firstTurnPoint, secondTurnPoint);
			if (rect2.width > 5 || rect2.width < 5)
			{
				edtor.x=rect2.x;
				edtor.y=rect2.y;
				edtor.width=rect2.width;
				edtor.height=25;
			}
			else
			{
				edtor.x=rect2.x - 25;
				edtor.y=rect2.y;
				edtor.width=50;
				edtor.height=25;
			}
			//画箭头
			//draw arrow
			drawArrow(secondTurnPoint, new Point(_endX, _endY));
		}
		
		/**
		 * 构建四边形
		 */
		private function resetLineRange(firstTurnPoint:Point, secondTurnPoint:Point):void
		{
			var w:Number=_endX - _startX;
			var h:Number=_endY - _startY;
			if (w > 0 && h > 0)
			{
				rect1.x=_startX - 2.5;
				rect1.y=_startY;
				rect1.width=5;
				rect1.height=firstTurnPoint.y - _startY;
				
				rect2.x=firstTurnPoint.x;
				rect2.y=firstTurnPoint.y - 2.5;
				rect2.width=secondTurnPoint.x - _startX;
				rect2.height=5;
				
				rect3.x=secondTurnPoint.x - 2.5;
				rect3.y=secondTurnPoint.y;
				rect3.width=5;
				rect3.height=_endY - secondTurnPoint.y;
				return ;
			}
			
			if (w > 0)
			{
				rect1.x=_startX - 2.5;
				rect1.y=firstTurnPoint.y;
				rect1.width=5;
				rect1.height=_startY - firstTurnPoint.y;
				
				rect2.x=firstTurnPoint.x;
				rect2.y=firstTurnPoint.y - 2.5;
				rect2.width=secondTurnPoint.x - _startX;
				rect2.height=5;
				
				rect3.x=_endX - 2.5;
				rect3.y=_endY;
				rect3.width=5;
				rect3.height=secondTurnPoint.y - _endY;
				
				return ;
			}
			
			if (h > 0)
			{
				rect1.x=_startX - 2.5;
				rect1.y=_startY;
				rect1.width=5;
				rect1.height=firstTurnPoint.y - _startY;
				
				rect2.x=secondTurnPoint.x;
				rect2.y=secondTurnPoint.y - 2.5;
				rect2.width=firstTurnPoint.x - secondTurnPoint.x;
				rect2.height=5;
				
				rect3.x=secondTurnPoint.x - 2.5;
				rect3.y=secondTurnPoint.y;
				rect3.width=5;
				rect3.height=_endY - secondTurnPoint.y;
				return ;
			}
			
			if (w <= 0 && h <= 0)
			{
				rect1.x=_startX - 2.5;
				rect1.y=firstTurnPoint.y;
				rect1.width=5;
				rect1.height=_startY - firstTurnPoint.y;
				
				rect2.x=secondTurnPoint.x;
				rect2.y=secondTurnPoint.y - 2.5;
				rect2.width=firstTurnPoint.x - secondTurnPoint.x;
				rect2.height=5;
				
				rect3.x=_endX - 2.5;
				rect3.y=_endY;
				rect3.width=5;
				rect3.height=secondTurnPoint.y - _endY;
				return ;
			}
			
		}
		
		/**
		 *  calculate the first inflection point
		 * */
		private function calcFirstPoint():Point
		{
			if (_endY > (_startY + defaultDistance))
				{
					
					return new Point(_startX, _startY + defaultDistance);
					
				}
				else if ((_endY >= _startY) && (_endY - _startY <= defaultDistance))
				{
					
					return new Point(_startX, _startY + Math.abs(_endY - _startY) / 2);
					
				}
				else if ((_endY <= _startY) && (_endY + defaultDistance >= _startY))
				{
					
					return new Point(_startX, _startY - Math.abs(_endY - _startY) / 2);
					
				}
				else if (_endY + defaultDistance < _startY)
				{
					
					return new Point(_startX, _startY - defaultDistance);
					
				}
			
			return new Point(0, 0);
		}
		
		/**
		 *  calculate the second inflection point
		 * */
		private function calcSecondPoint(firstPoint:Point):Point
		{
			return new Point(_endX, firstPoint.y);
		}
		
		/**
		 *  draw the arrow at the end node
		 * */
		override protected function drawArrow(sp:Point=null, ep:Point=null):void
		{
			var tmpx:Number=ep.x - sp.x;
			var tmpy:Number=ep.y - sp.y;
			var angle:Number=Math.atan2(tmpy, tmpx) * (180 / Math.PI);
			
			var centerX:Number=ep.x - radius * Math.cos(angle * (Math.PI / 180));
			var centerY:Number=ep.y - radius * Math.sin(angle * (Math.PI / 180));
			var topX:Number=ep.x;
			var topY:Number=ep.y;
			var leftX:Number=centerX + radius * Math.cos((angle + 120) * (Math.PI / 180));
			var leftY:Number=centerY + radius * Math.sin((angle + 120) * (Math.PI / 180));
			var rightX:Number=centerX + radius * Math.cos((angle + 240) * (Math.PI / 180));
			var rightY:Number=centerY + radius * Math.sin((angle + 240) * (Math.PI / 180));
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
			return rect1.contains(mouseX, mouseY) || rect2.contains(mouseX, mouseY) || rect3.contains(mouseX, mouseY);
		}
		
	}
}

