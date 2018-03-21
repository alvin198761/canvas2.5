package com.print.bean.shape.contr
{
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.datashape.line.BaseLineShape;
	import com.print.util.ArrayCollectionUtil;
	
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.utils.Base64Decoder;
	
	/**
	 *鼠标进入该区域，变红色
	 */
	public class LineConnectionContrBox extends BaseContrShape
	{
		//当前控制图形的当前的这个方位的所有线条
		protected var lines:ArrayCollection=new ArrayCollection();
		
		public function LineConnectionContrBox(way:String, shape:BaseDataShape)
		{
			super(way, shape);
			
			bgColor=0x999999;
			selectColor=0xff0000;
			borderStyle=1;
			width=DEFAULT_WIDTH;
			height=DEFAULT_HEIGHT;
		}
		
		override protected function paintComponent():void
		{
			graphics.clear();
			if (this.select)
			{
				setStyle("borderColor", selectColor);
				graphics.lineStyle(borderStyle, borderColor);
			}
			else
			{
				graphics.lineStyle(borderStyle, bgColor);
				setStyle("borderColor", bgColor);
			}
			if (_lineCursor)
			{
				setStyle("borderColor", selectColor);
				graphics.lineStyle(2, selectColor);
			}
			graphics.moveTo(0, 0);
			graphics.lineTo(width, height);
			graphics.moveTo(width, 0);
			graphics.lineTo(0, height);
			graphics.endFill();
		}
		
		/**
		 * 添加一条线
		 * @param line
		 *
		 */
		public function addLine(line:BaseLineShape):void
		{
			this.lines.addItem(line);
			changeLinePoint(line);
		}
		
		private function changeLinePoint(line:BaseLineShape):void
		{
			var mp:Point=getMiddlePoint();
			if (contrlShape.equals(line.startShape))
			{
				line.startX=mp.x;
				line.startY=mp.y;
			}
			else if (contrlShape.equals(line.endShape))
			{
				line.endX=mp.x;
				line.endY=mp.y;
			}
			line.repaint();
		}
		
		/**
		 * 删除一条线
		 * @param line
		 *
		 */
		public function removeLine(line:BaseLineShape):void
		{
			ArrayCollectionUtil.remove(line, this.lines);
		}
		
		/**
		 * 启用控制
		 */
		public function doContrl():void
		{
			var mp:Point=getMiddlePoint();
			for each(var line:BaseLineShape in lines)
			{
				changeLinePoint(line);
				line.moveStartShape()
				line.moveEndShape();
			}
		}
		
		public function getMiddlePoint():Point
		{
			var p:Point=new Point();
			var x:Number=this.width >> 1;
			var y:Number=this.height >> 1;
			
			x=x + contrlShape.x + this.x;
			y=y + contrlShape.y + this.y;
			
			p.x=x;
			p.y=y;
			return p;
		}
		
		/**
		 * 拿到所有的线条
		 * @return
		 *
		 */
		public function getAllLines():ArrayCollection
		{
			return lines;
		}
	}
}

