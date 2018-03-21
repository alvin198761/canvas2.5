package com.print.bean.shape.shapepane
{
	import com.print.bean.shape.ShapeCompFactory;
	import com.print.bean.shape.ShapeTypeHelper;
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.datashape.line.BaseLineShape;
	import com.print.bean.shape.datashape.state.BeginShape;
	import com.print.bean.shape.datashape.state.ConditionShape;
	import com.print.bean.shape.datashape.state.EndShape;
	import com.print.bean.shape.datashape.state.InterfaceShape;
	import com.print.bean.shape.datashape.state.LaneShape;
	import com.print.bean.shape.datashape.state.StateShape;
	import com.print.io.XMLOperate;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	
	/**
	 *	预览面板
	 */
	public class PreviewPaneAs extends BaseDrawPane
	{
		
		public function PreviewPaneAs()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, moseMove)
			addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		private var startPoint:Point=new Point();
		
		/**
		 * 传输二进制数据 解析成图
		 * @param data
		 *
		 */
		public function setData(byteData:ByteArray):void
		{
			if (byteData == null)
			{
				this.shapes=new ArrayCollection();
			}
			var dataShapes:ArrayCollection=null;
			dataShapes=XMLOperate.getInstance().vkdToShapes(byteData, BaseDataShape.MODEL_PREVIEW);
			this.shapes=dataShapes;
		}
		
		/**
		 * 当前要选中的TimeId
		 * @param timeId
		 *
		 */
		public function setCurrentShape(timeId:String):void
		{
			var shape:BaseDataShape=null;
			var len:Number=_shapes.length;
			var i:Number;
			cleanSelect();
			for(i=0; i < len; i++)
			{
				shape=_shapes.getItemAt(i)as BaseDataShape;
				if (shape.timeId == timeId)
				{
					break;
				}
			}
			if (shape == null)
			{
				return ;
			}
			var finalX:Number=100;
			var finalY:Number=100;
			var xdiffer:Number=finalX - shape.x;
			var ydiffer:Number=finalY - shape.y;
			shape.select=true;
			
			for each(shape in _shapes)
			{
				shape.x+=xdiffer;
				shape.y+=ydiffer;
			}
		}
		
		/**
		 * 选中一条路径
		 * @param shapeIds
		 * @param lineIds
		 *
		 */
		public function setCurrentShapes(shapeIds:ArrayCollection, lineIds:ArrayCollection):void
		{
			var shape:BaseDataShape=null;
			var len:Number=_shapes.length;
			var i:Number;
			cleanSelect();
			for(i=0; i < len; i++)
			{
				shape=_shapes.getItemAt(i)as BaseDataShape;
				if (shapeIds.contains(shape.timeId))
				{
					shape.select=true;
					continue;
				}
				if (lineIds.contains(shape.timeId))
				{
					shape.select=true;
				}
			}
		}
		
		/**
		 *清空选中
		 *
		 */
		public function cleanSelect():void
		{
			for each(var shape:BaseDataShape in _shapes)
			{
				if (shape.select)
				{
					shape.select=false;
				}
			}
		}
		
		override public function set shapes(value:ArrayCollection):void
		{
			_shapes=value;
			var shape:BaseDataShape;
			for each(shape in _shapes)
			{
				shape.model=BaseDataShape.MODEL_PREVIEW;
			}
			//先放泳道
			for each(shape in _shapes)
			{
				if (shape is LaneShape)
				{
					updataUI(shape);
					continue;
				}
			}
			//再放状态和
			for each(shape in _shapes)
			{
				if (shape is BeginShape)
				{
					updataUI(shape);
					continue;
				}
				if (shape is EndShape)
				{
					updataUI(shape);
					continue;
				}
				if (shape is ConditionShape)
				{
					updataUI(shape);
					continue;
				}
				if (shape is StateShape)
				{
					updataUI(shape);
					continue;
				}
				if (shape is InterfaceShape)
				{
					updataUI(shape);
					continue;
				}
			}
			//放连线
			for each(shape in _shapes)
			{
				if (shape is BaseLineShape)
				{
					updataUI(shape);
					continue;
				}
			}
			
		}
		
		//更新界面信息
		private function updataUI(shape:BaseDataShape):void
		{
			shape.select=true;
			addChild(shape);
			shape.select=false;
		}
		
		private function mouseDown(event:MouseEvent):void
		{
			startPoint.x=mouseX;
			startPoint.y=mouseY;
		}
		
		private function moseMove(event:MouseEvent):void
		{
			if (!event.buttonDown)
			{
				return ;
			}
			var suby:Number=mouseY - startPoint.y;
			var subx:Number=mouseX - startPoint.x;
			for each(var shape:BaseDataShape in _shapes)
			{
				shape.x+=subx;
				shape.y+=suby;
			}
			
			startPoint.x=mouseX;
			startPoint.y=mouseY;
		}
		
		/**
		 * 按下鼠标事件
		 * @param event
		 *
		 */
		public function keyDown(event:KeyboardEvent):void
		{
			var keyStr:String=event.keyCode.toString();
			switch(keyStr)
			{
				case "37":
					moveUpOrDwon(-1, 0);
					break;
				case "38":
					moveUpOrDwon(0, -1);
					break;
				case "39":
					moveUpOrDwon(1, 0);
					break;
				case "40":
					moveUpOrDwon(0, 1);
					break;
			}
		}
		
		public function mouseClick(event:MouseEvent):void
		{
			setFocus();
		}
		
		/**
		 * 移动图片
		 * @param subx
		 * @param subY
		 *
		 */
		public function moveUpOrDwon(subx:int, subY:int):void
		{
			var len:int=_shapes.length;
			var shape:BaseDataShape;
			for(var i:int=0; i < len; i++)
			{
				shape=_shapes.getItemAt(i)as BaseDataShape;
				shape.x+=subx;
				shape.y+=subY;
			}
		}
	}
}

