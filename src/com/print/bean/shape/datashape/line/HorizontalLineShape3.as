package com.print.bean.shape.datashape.line
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.print.bean.shape.ShapeTypeHelper;
	public class HorizontalLineShape3 extends BaseLineShape
	{
		/**when the node is dragging, check the distance
		 * between the center point of startShape and the
		 * center point of endShape
		 * */
		private var defaultDistance:Number=30;
		//3个框框管选中
		private var rect1:Rectangle=new Rectangle();
		private var rect2:Rectangle=new Rectangle();
		private var rect3:Rectangle=new Rectangle();
		
		public function HorizontalLineShape3()
		{
			super();
			type = ShapeTypeHelper.TYPE_HFOLDLINE;
		}
		
		/**
		 * |---- 20 ------|
		 * ----------------											------------------------
		 * 				  |						 					|
		 * 				  | 				  or  					|
		 * 				  |						  |----- 20 -------||
		 * 				  ------------------      -------------------
		 * */
		override protected function paintComponent():void
		{
			super.paintComponent();
			var currentColor:uint;
			if (select)
			{
				currentColor=selectColor;
			}
			else
			{
				currentColor=bgColor;
			}
			if ((_startX != 0) && (_startY != 0) && (_endX != 0) && (_endY != 0))
			{
				this.graphics.clear();
				// Add Anchor
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
				
				this.graphics.lineStyle(borderStyle, currentColor);
				this.graphics.moveTo(_startX, _startY);
				var firstTurnPoint:Point=calcFirstPoint();
				this.graphics.lineTo(firstTurnPoint.x, firstTurnPoint.y);
				var secondTurnPoint:Point=calcSecondPoint(firstTurnPoint);
				this.graphics.lineTo(secondTurnPoint.x, secondTurnPoint.y);
				this.graphics.lineTo(_endX, _endY);
				
				//构建3个矩形
				resetLineRange(firstTurnPoint, secondTurnPoint);
				//画箭头
				drawArrow(secondTurnPoint, new Point(_endX, _endY));
				if (rect3.width > 5 || rect3.width < 5)
				{
					edtor.x=rect3.x;
					edtor.y=rect3.y;
					edtor.width=rect3.width;
					edtor.height=25;
				}
				else
				{
					edtor.x=rect3.x - 10;
					edtor.y=rect3.y;
					edtor.width=20;
					edtor.height=25;
				}
			}
		}
		
		// calculate the first turn point
		private function calcFirstPoint():Point
		{
			if (_endX > (_startX + defaultDistance))
				{
					
					return new Point(_startX + defaultDistance, _startY);
					
				}
				else if ((_endX >= _startX) && (_endX - _startX <= defaultDistance))
				{
					
					return new Point(_startX + Math.abs(_endX - _startX) / 2, _startY);
					
				}
				else if ((_endX <= _startX) && (_endX + defaultDistance >= _startX))
				{
					
					return new Point(_startX - Math.abs(_endX - _startX) / 2, _startY);
					
				}
				else if (_endX + defaultDistance < _startX)
				{
					
					return new Point(_startX - defaultDistance, _startY);
				}
				return new Point(0, 0);
		}
		
		// calculate the second turn point
		private function calcSecondPoint(firstPoint:Point):Point
		{
			return new Point(firstPoint.x, _endY);
		}
		
		/**
		 *画箭头
		 */
		override protected function drawArrow(sp:Point=null, ep:Point=null):void
		{
			var tmpx:Number=ep.x - sp.x;
			var tmpy:Number=ep.y - sp.y;
			var angle:Number=Math.atan2(tmpy, tmpx) * (180 / Math.PI);
			
			var centerX:Number=ep.x - radius * Math.cos(angle * (Math.PI / 180));
			var centerY:Number=ep.y + radius * Math.sin(angle * (Math.PI / 180));
			var topX:Number=ep.x;
			var topY:Number=ep.y;
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
			return (rect1.contains(mouseX, mouseY) || rect2.contains(mouseX, mouseY) || rect3.contains(mouseX, mouseY));
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
				rect1.x=_startX;
				rect1.y=_startY - 2.5;
				rect1.width=firstTurnPoint.x - _startX + 2.5;
				rect1.height=5;
				
				rect2.x=firstTurnPoint.x - 2.5;
				rect2.y=firstTurnPoint.y;
				rect2.width=5;
				rect2.height=secondTurnPoint.y - firstTurnPoint.y + 2.5;
				
				rect3.x=rect2.x;
				rect3.y=secondTurnPoint.y - 2.5;
				rect3.width=_endX - secondTurnPoint.x;
				rect3.height=5;
				return ;
			}
			if (w > 0)
			{
				rect1.x=_startX;
				rect1.y=_startY - 2.5;
				rect1.width=firstTurnPoint.x - _startX + 2.5;
				rect1.height=5;
				
				rect2.x=firstTurnPoint.x - 2.5;
				rect2.y=secondTurnPoint.y;
				rect2.width=5;
				rect2.height=firstTurnPoint.y - secondTurnPoint.y + 2.5;
				
				rect3.x=rect2.x;
				rect3.y=secondTurnPoint.y - 2.5;
				rect3.width=_endX - secondTurnPoint.x;
				rect3.height=5;
				return ;
			}
			
			if (h > 0)
			{
				rect1.x=firstTurnPoint.x;
				rect1.y=_startY - 2.5;
				rect1.width=_startX - firstTurnPoint.x + 2.5;
				rect1.height=5;
				
				rect2.x=firstTurnPoint.x - 2.5;
				rect2.y=secondTurnPoint.y;
				rect2.width=5;
				rect2.height=firstTurnPoint.y - secondTurnPoint.y + 2.5;
				
				rect3.x=_endX;
				rect3.y=secondTurnPoint.y - 2.5;
				rect3.width=secondTurnPoint.x - _endX;
				rect3.height=5;
				return ;
			}
			
			if (w <= 0 && h <= 0)
			{
				rect1.x=firstTurnPoint.x;
				rect1.y=_startY - 2.5;
				rect1.width=_startX - firstTurnPoint.x + 2.5;
				rect1.height=5;
				
				rect2.x=firstTurnPoint.x - 2.5;
				rect2.y=secondTurnPoint.y;
				rect2.width=5;
				rect2.height=firstTurnPoint.y - secondTurnPoint.y + 2.5;
				
				rect3.x=_endX;
				rect3.y=secondTurnPoint.y - 2.5;
				rect3.width=secondTurnPoint.x - _endX;
				rect3.height=5;
			}
		}
		
	}
}

