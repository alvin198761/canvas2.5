package com.print.bean.shape.datashape.state
{
	import com.print.bean.shape.BaseShape;
	import com.print.bean.shape.contr.BaseContrShape;
	import com.print.bean.shape.contr.LineConnectionContrBox;
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.datashape.line.BaseLineShape;
	import com.print.bean.shape.datashape.line.LineShape;
	import com.print.util.ArrayCollectionUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 非连线的图形
	 * @author 唐植超
	 *
	 */
	public class BaseStateShape extends BaseDataShape
	{
		//默认宽
		public static const defaultWidth:int=60;
		//默认高
		public static const defaultHeight:int=30;
		
		public function BaseStateShape()
		{
			super();
			width=defaultWidth;
			height=defaultHeight;
			drag=true;
			_connection=true;
		}
		
		protected function resetChildren():void
		{
			if (model == MODEL_PREVIEW)
			{
				return ;
			}
			
			var lineBox:LineConnectionContrBox;
			var p:Point;
			
			if (connection)
			{
				
				p=getLeftPoint();
				
				leftLineConnection.x=p.x;
				leftLineConnection.y=p.y;
				leftLineConnection.repaint();
				
				p=getRightPoint();
				rightLineConnection.x=p.x;
				rightLineConnection.y=p.y;
				rightLineConnection.repaint();
				
				p=getTopPoint();
				
				topLineConnection.x=p.x;
				topLineConnection.y=p.y;
				topLineConnection.repaint();
				
				p=getBottomPoint();
				
				bottomLineConnection.x=p.x;
				bottomLineConnection.y=p.y;
				bottomLineConnection.repaint();
			}
		}
		
		override protected function paintComponent():void
		{
			if (this.width < 0)
			{
				edtor.x=width;
				edtor.width=0 - width;
			}
			else
			{
				edtor.x=0;
				edtor.width=this.width;
			}
			
			if (this.height < 0)
			{
				edtor.y=height;
				edtor.height=0 - height;
			}
			else
			{
				edtor.y=0;
				edtor.height=this.height;
			}
			super.paintComponent();
			resetChildren();
		}
		
		/**
		 * 拿到所有的线条
		 */
		public function getAllLine():ArrayCollection
		{
			var list:ArrayCollection=new ArrayCollection();
			var box:LineConnectionContrBox=null;
			if (!connection)
			{
				return list;
			}
			box=lineConnectionMap[BaseContrShape.WAY_LEFT]as LineConnectionContrBox;
			if (box != null)
			{
				ArrayCollectionUtil.addAllData(list, box.getAllLines());
			}
			
			box=lineConnectionMap[BaseContrShape.WAY_RIGHT]as LineConnectionContrBox;
			if (box != null)
			{
				ArrayCollectionUtil.addAllData(list, box.getAllLines());
			}
			
			box=lineConnectionMap[BaseContrShape.WAY_TOP]as LineConnectionContrBox;
			if (box != null)
			{
				ArrayCollectionUtil.addAllData(list, box.getAllLines());
			}
			
			box=lineConnectionMap[BaseContrShape.WAY_BOTTOM]as LineConnectionContrBox;
			if (box != null)
			{
				ArrayCollectionUtil.addAllData(list, box.getAllLines());
			}
			return list;
		}
		
		//V2.3上面的添加的方法
		
		/**
		 * 给控制点添加鼠标事件
		 * @param mouseOverFunction
		 * @param mouseOutFunction
		 *
		 */
		public function addConnectionBoxLisenner(mouseOverFunction:Function, mouseOutFunction:Function):void
		{
			if (!_connection)
			{
				return ;
			}
			
			leftLineConnection.addEventListener(MouseEvent.MOUSE_MOVE, mouseOverFunction);
			leftLineConnection.addEventListener(MouseEvent.MOUSE_OUT, mouseOutFunction);
			
			rightLineConnection.addEventListener(MouseEvent.MOUSE_MOVE, mouseOverFunction);
			rightLineConnection.addEventListener(MouseEvent.MOUSE_OUT, mouseOutFunction);
			
			topLineConnection.addEventListener(MouseEvent.MOUSE_MOVE, mouseOverFunction);
			topLineConnection.addEventListener(MouseEvent.MOUSE_OUT, mouseOutFunction);
			
			bottomLineConnection.addEventListener(MouseEvent.MOUSE_MOVE, mouseOverFunction);
			bottomLineConnection.addEventListener(MouseEvent.MOUSE_OUT, mouseOutFunction);
		}
		
		
		/**
		 * 鼠标是否到了控件的中心
		 * @return
		 *
		 */
		public function containCenter():Boolean
		{
			var x:Number;
			var y:Number;
			var s:Number=15;
			var rect:Rectangle;
			x=(width - s) >> 1;
			y=(height - s) >> 1;
			rect=new Rectangle(x, y, s, s);
			if (rect.contains(mouseX, mouseY))
			{
				return true;
			}
			return false;
		}
		
		override public function cloneShape():BaseShape
		{
			var shape:BaseStateShape=new BaseStateShape();
			shape.model=this.model;
			shape.x=this.x;
			shape.y=this.y;
			shape.width=this.width;
			shape.height=this.height;
			shape.text=this.text;
			shape.select=this.select;
			
			var list:ArrayCollection=this.leftLineConnection.getAllLines();
			var cloneLine:BaseLineShape;
			var line:BaseLineShape;
			for each(line in list)
			{
				cloneLine=BaseLineShape(line.cloneShape());
				shape.leftLineConnection.addLine(cloneLine);
				if (line.startShape == this)
				{
					cloneLine.startShape=shape;
					continue;
				}
				if (line.endShape == this)
				{
					cloneLine.endShape=shape;
					continue;
				}
			}
			cloneLine=null;
			list=this.rightLineConnection.getAllLines();
			for each(line in list)
			{
				cloneLine=BaseLineShape(line.cloneShape());
				shape.rightLineConnection.addLine(cloneLine);
				if (line.startShape == this)
				{
					cloneLine.startShape=shape;
					continue;
				}
				if (line.endShape == this)
				{
					cloneLine.endShape=shape;
					continue;
				}
			}
			
			cloneLine=null;
			list=this.topLineConnection.getAllLines();
			for each(line in list)
			{
				cloneLine=BaseLineShape(line.cloneShape());
				shape.topLineConnection.addLine(cloneLine);
				if (line.startShape == this)
				{
					cloneLine.startShape=shape;
					continue;
				}
				if (line.endShape == this)
				{
					cloneLine.endShape=shape;
					continue;
				}
			}
			
			
			cloneLine=null;
			list=this.bottomLineConnection.getAllLines();
			for each(line in list)
			{
				cloneLine=BaseLineShape(line.cloneShape());
				shape.bottomLineConnection.addLine(cloneLine);
				if (line.startShape == this)
				{
					cloneLine.startShape=shape;
					continue;
				}
				if (line.endShape == this)
				{
					cloneLine.endShape=shape;
					continue;
				}
			}
			
			leftLineConnection.doContrl();
			rightLineConnection.doContrl();
			topLineConnection.doContrl();
			bottomLineConnection.doContrl();
			return shape;
		}
	}
}

