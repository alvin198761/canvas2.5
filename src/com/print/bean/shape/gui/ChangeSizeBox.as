package com.print.bean.shape.gui
{	
	import com.print.bean.shape.BaseShape;
	import com.print.bean.shape.contr.BaseContrShape;
	import com.print.bean.shape.contr.ChangeSizeContrlBox;
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.datashape.line.BaseLineShape;
	import com.print.bean.shape.datashape.state.InterfaceShape;
	import com.print.bean.shape.datashape.state.LaneShape;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.containers.DividedBox;
	
	/**
	 * 图形大小控制器
	 * @author 唐植超
	 *
	 */
	public class ChangeSizeBox extends BaseGUI
	{
		private var shape:BaseShape;
		//大小控制点
		protected var leftChangeSizeBox:ChangeSizeContrlBox;
		protected var rightChangeSizeBox:ChangeSizeContrlBox;
		protected var topChangeSizeBox:ChangeSizeContrlBox;
		protected var bottomChangeSizeBox:ChangeSizeContrlBox;
		//保存改变大小的控制点的Map集合
		protected var changeSizeMap:Object=new Object();
		//最小的宽度和高度
		public static const MIX_WIDHT:Number=30;
		public static const MIX_HEIGHT:Number=30;
		private var canReSize:Boolean=true;
		
		public function ChangeSizeBox()
		{
			super();
			
			leftChangeSizeBox=new ChangeSizeContrlBox(BaseContrShape.WAY_LEFT, this);
			rightChangeSizeBox=new ChangeSizeContrlBox(BaseContrShape.WAY_RIGHT, this);
			topChangeSizeBox=new ChangeSizeContrlBox(BaseContrShape.WAY_TOP, this);
			bottomChangeSizeBox=new ChangeSizeContrlBox(BaseContrShape.WAY_BOTTOM, this);
			
			changeSizeMap[BaseContrShape.WAY_LEFT]=leftChangeSizeBox;
			changeSizeMap[BaseContrShape.WAY_RIGHT]=rightChangeSizeBox;
			changeSizeMap[BaseContrShape.WAY_TOP]=topChangeSizeBox;
			changeSizeMap[BaseContrShape.WAY_BOTTOM]=bottomChangeSizeBox;
			
			this.rawChildren.addChild(leftChangeSizeBox);
			this.rawChildren.addChild(rightChangeSizeBox);
			this.rawChildren.addChild(topChangeSizeBox);
			this.rawChildren.addChild(bottomChangeSizeBox);
			
			leftChangeSizeBox.select=true;
			rightChangeSizeBox.select=true;
			topChangeSizeBox.select=true;
			bottomChangeSizeBox.select=true;
			
			
			selectColor=0xffffff;
			bgColor=0xffffff;
			borderColor=0xff0000;
			borderStyle=.01;
			
			changeControl();
			visible=false;
			
		}
		
		public function changeSize(shape:BaseShape):void
		{
			this.shape=shape;
			if (shape is BaseLineShape)
			{
				//还不知道怎么处理
				visible=false;
				return ;
			}
			super.x=Math.min(shape.x, shape.x + shape.width);
			super.y=Math.min(shape.y, shape.y + shape.height);
			super.width=Math.abs(shape.width);
			if(shape is LaneShape){
				super.height=Math.abs(LaneShape.titleHeight);
			}else{
				super.height=Math.abs(shape.height);
			}
			if (shape is BaseDataShape)
			{
				canReSize=(shape as BaseDataShape).changeSize;
			}
			else
			{
				canReSize=true;
			}
			changeControl();
			visible=true;
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible=value;
			if (!value)
			{
				super.x=0;
				super.y=0;
				super.width=0;
				super.height=0;
			}
			repaint();
		}
		
		//控制左边
		public function contrlLeft(event:MouseEvent, subX:Number, subY:Number):void
		{
			if (!leftChangeSizeBox.select)
			{
				return ;
			}
			if (shape is SelectBox)
			{
				var dataShape:BaseShape;
				for each(dataShape in SelectBox(shape).shapes)
				{
					if (dataShape is BaseLineShape)
					{
						continue;
					}
					dataShape.x+=subX;
					(BaseDataShape(dataShape)).contrlLeft(event, subX >> 2, subY);
					if (dataShape.x + dataShape.width >= this.x + this.width)
					{
						dataShape.x=this.x + this.width - dataShape.width;
					}
					else if (dataShape.x <= this.x)
					{
						dataShape.x=this.x;
					}
					dataShape.repaint();
					(BaseDataShape(dataShape)).contrlLines();
				}
				var x2:Number=this.x + this.width;
				var x3:Number=this.parent.mouseX;
				if (x2 - x3 > MIX_WIDHT)
				{
					this.x=this.parent.mouseX;
					this.width=x2 - this.x;
				}
				
				repaint();
				changeControl();
				return ;
			}
			if (canReSize)
			{
				(BaseDataShape(shape)).contrlLeft(event, subX, subY);
				(BaseDataShape(shape)).contrlLines();
				changeSize(shape);
				repaint();
				changeControl();
			}
		}
		
		//控制右边
		public function contrlRight(event:MouseEvent, subX:int, subY:int):void
		{
			if (!rightChangeSizeBox.select)
			{
				return ;
			}
			if (shape is SelectBox)
			{
				var dataShape:BaseShape;
				for each(dataShape in SelectBox(shape).shapes)
				{
					if (dataShape is BaseLineShape)
					{
						continue;
					}
					(BaseDataShape(dataShape)).contrlRight(event, subX, subY);
					if (dataShape.x + dataShape.width >= this.x + this.width)
					{
						dataShape.x=this.x + this.width - dataShape.width;
					}
					else if (dataShape.x <= this.x)
					{
						dataShape.x=this.x;
					}
					dataShape.repaint();
					(BaseDataShape(dataShape)).contrlLines();
				}
				
				this.width+=subX;
				if (this.width < minWidth)
				{
					this.width=minWidth;
				}
				repaint();
				changeControl();
				return ;
			}
			if (canReSize)
			{
				(BaseDataShape(shape)).contrlRight(event, subX, subY);
				(BaseDataShape(shape)).contrlLines();
				changeSize(shape);
				repaint();
				changeControl();
			}
		}
		
		
		
		//控制顶部
		public function controlTop(event:MouseEvent, subX:int, subY:int):void
		{
			if (!topChangeSizeBox.select)
			{
				return ;
			}
			if (shape is SelectBox)
			{
				var dataShape:BaseShape;
				for each(dataShape in SelectBox(shape).shapes)
				{
					if (dataShape is BaseLineShape)
					{
						continue;
					}
					
					(BaseDataShape(dataShape)).controlTop(event, subX, subY);
					if (dataShape.y + dataShape.height >= this.y + this.height)
					{
						dataShape.y=this.y + this.height - dataShape.height;
					}
					else if (dataShape.y <= this.y)
					{
						dataShape.y=this.y;
					}
					dataShape.y+=subY;
					dataShape.repaint();
					(BaseDataShape(dataShape)).contrlLines();
				}
				var y2:Number=this.y + this.height;
				var y3:Number=this.parent.mouseY;
				if (y2 - y3 > MIX_HEIGHT)
				{
					this.y=this.parent.mouseY;
					this.height=y2 - this.y;
				}
				repaint();
				changeControl();
				return ;
			}
			if (canReSize)
			{
				(BaseDataShape(shape)).controlTop(event, subX, subY);
				(BaseDataShape(shape)).contrlLines();
				changeSize(shape);
				repaint();
				changeControl();
			}
		}
		
		//控制底部
		public function controlBottom(event:MouseEvent, subX:int, subY:int):void
		{
			if (!bottomChangeSizeBox.select)
			{
				return ;
			}
			if (shape is SelectBox)
			{
				var dataShape:BaseShape;
				for each(dataShape in SelectBox(shape).shapes)
				{
					if (dataShape is BaseLineShape)
					{
						continue;
					}
					(BaseDataShape(dataShape)).controlBottom(event, subX, subY);
					if (dataShape.y + dataShape.height >= this.y + this.height)
					{
						dataShape.y=this.y + this.height - dataShape.height;
					}
					else if (dataShape.y <= this.y)
					{
						dataShape.y=this.y;
					}
					dataShape.repaint();
					(BaseDataShape(dataShape)).contrlLines();
				}
				this.height+=subY;
				repaint();
				changeControl();
				return ;
			}
			if (canReSize)
			{
				(BaseDataShape(shape)).controlBottom(event, subX, subY);
				(BaseDataShape(shape)).contrlLines();
				changeSize(shape);
				repaint();
				changeControl();
			}
		}
		
		
		override protected function paintComponent():void
		{
			if (!visible)
			{
				graphics.clear();
				leftChangeSizeBox.graphics.clear();
				rightChangeSizeBox.graphics.clear();
				topChangeSizeBox.graphics.clear();
				bottomChangeSizeBox.graphics.clear();
				return ;
			}
			graphics.clear();
			graphics.lineStyle(borderStyle, borderColor)
			
			drawDottenRect(graphics, 0, 0, this.width, this.height);
			
			leftChangeSizeBox.repaint();
			rightChangeSizeBox.repaint();
			topChangeSizeBox.repaint();
			bottomChangeSizeBox.repaint();
		}
		
		//控制点的位置
		protected function changeControl():void
		{
			trace(this.height);
			var p:Point=getLeftPoint();
			leftChangeSizeBox.x=p.x;
			leftChangeSizeBox.y=p.y;
			leftChangeSizeBox.select=canReSize;
			
			p=getRightPoint();
			rightChangeSizeBox.x=p.x;
			rightChangeSizeBox.y=p.y;
			rightChangeSizeBox.select=canReSize;
			
			p=getTopPoint();
			topChangeSizeBox.x=p.x;
			topChangeSizeBox.y=p.y;
			topChangeSizeBox.select=canReSize;
			
			p=getBottomPoint();
			bottomChangeSizeBox.x=p.x;
			bottomChangeSizeBox.y=p.y;
			bottomChangeSizeBox.select=canReSize;
			
			if (shape is InterfaceShape || shape is LaneShape)
			{
				topChangeSizeBox.select=false;
				bottomChangeSizeBox.select=false;
			}
		}
		
		//画虚线框
		private static function drawDottenRect(g:Graphics, x0:Number, y0:Number, x1:Number, y1:Number):void
		{
			drawDottedHorizontalLineTo(g, y0, x0, x1);
			drawDottedVerticalLineTo(g, x0, y0, y1);
			drawDottedHorizontalLineTo(g, y1, x1, x0);
			drawDottedVerticalLineTo(g, x1, y0, y1);
			
		}
		
		private static function drawDottedHorizontalLineTo(g:Graphics, y:Number, x0:Number, x1:Number):void
		{
			var dotLength:Number=5;
			var gap:Number=2;
			if (x0 < x1)
			{
				g.moveTo(x0, y);
				for(var x:Number=x0; x < x1; x+=dotLength + gap)
				{
					if (x + dotLength + gap <= x1)
					{
						g.lineTo(x + dotLength, y);
						g.moveTo(x + dotLength + gap, y);
					}
					else
					{
						if (x + dotLength > x1)
						{
							g.lineTo(x1, y);
						}
						else
						{
							g.lineTo(x + dotLength, y);
							
						}
					}
					
				}
			}
			else
			{
				g.moveTo(x0, y);
				for(var xSecond:Number=x0; xSecond > x1; xSecond-=dotLength + gap)
				{
					
					if (xSecond - (dotLength + gap) >= x1)
					{
						g.lineTo(xSecond - dotLength, y);
						g.moveTo(xSecond - dotLength - gap, y);
					}
					else
					{
						if (xSecond - dotLength < x1)
						{
							g.lineTo(x1, y);
						}
						else
						{
							g.lineTo(xSecond - dotLength, y);
						}
					}
					
				}
			}
			
		}
		
		private static function drawDottedVerticalLineTo(g:Graphics, x:Number, y0:Number, y1:Number):void
		{
			var dotLength:Number=5;
			var gap:Number=2;
			if (y0 <= y1)
			{
				g.moveTo(x, y0);
				for(var y:Number=y0; y <= y1; y+=dotLength + gap)
				{
					if (y + dotLength + gap <= y1)
					{
						g.lineTo(x, y + dotLength);
						g.moveTo(x, y + dotLength + gap);
					}
					else
					{
						if (y + dotLength > y1)
						{
							g.lineTo(x, y1);
						}
						else
						{
							g.lineTo(x, y + dotLength);
						}
					}
					
				}
			}
			else
			{
				g.moveTo(x, y1);
				for(var ySecond:Number=y0; ySecond >= y1; ySecond-=dotLength + gap)
				{
					if (ySecond - dotLength - gap >= y1)
					{
						g.lineTo(x, ySecond - dotLength);
						g.moveTo(x, ySecond - dotLength - gap);
					}
					else
					{
						if (ySecond - dotLength < y1)
						{
							g.lineTo(x, y1);
						}
						else
						{
							g.lineTo(x, ySecond - dotLength);
						}
					}
					
				}
			}
		}
		
		/**
		 * 是否点击控制点
		 * @return
		 *
		 */
		public function containsContrl():ChangeSizeContrlBox
		{
			if (leftChangeSizeBox.containsMouse())
			{
				return leftChangeSizeBox;
			}
			if (rightChangeSizeBox.containsMouse())
			{
				return rightChangeSizeBox;
			}
			if (topChangeSizeBox.containsMouse())
			{
				return topChangeSizeBox;
			}
			if (bottomChangeSizeBox.containsMouse())
			{
				return bottomChangeSizeBox;
			}
			return null;
		}
		
	}
}

