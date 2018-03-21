package com.print.bean.shape.shapepane
{
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.gui.BaseGUI;
	
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	/**
	 *TCD要调用的画图板
	 */
	public class TCDPreviewPaneAS extends BaseGUI
	{
		
		public function TCDPreviewPaneAS()
		{
			super();
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandle);
		}
		private var win:TCDPreviewPane;
		private var backUpData:ByteArray=null;
		
		private var backUpShapes:ArrayCollection=new ArrayCollection();
		
		protected function init(win:TCDPreviewPane):void
		{
			this.win=win;
			win.slider.value=1;
		}
		
		private function mouseWheelHandle(event:MouseEvent):void
		{
			var value:Number=event.delta;
			if (value > 0)
			{
				value=1;
			}
			else if (value > 0)
			{
				value=-1;
			}
			value*=.1;
			value=win.slider.value - value;
			if (value < win.slider.minimum)
			{
				value=win.slider.minimum;
			}
			if (value > win.slider.maximum)
			{
				value=win.slider.maximum;
			}
			win.slider.value=value;
		}
		
		/**
		 * 改变数据 （传入xml文件流）
		 * @param data
		 *
		 */
		public function changeData(data:ByteArray):void
		{
			this.backUpData=data;
			win.previewPanel.setData(clone(data)as ByteArray);
		}
		
		/**
		 * 改变数据 （传入图形集合）
		 * @param shapes
		 *
		 */
		public function changeShape(shapes:ArrayCollection):void
		{
			this.backUpShapes=shapes;
			var list:ArrayCollection=new ArrayCollection();
			for each(var shape:BaseDataShape in shapes)
			{
				list.addItem(BaseDataShape.cloneShape(shape));
			}
			win.previewPanel.shapes=list;
		}
		
		/**
		 * 将当前选中的组件的居中
		 * @param timeId
		 *
		 */
		public function setCurrentShape(timeId:String):void
		{
			win.previewPanel.setCurrentShape(timeId);
		}
		
		/**
		 * 将场景的路径颜色改为选中
		 * @param timeIds
		 * @param lineIds
		 *
		 */
		public function setCurrentShapes(timeIds:ArrayCollection, lineIds:ArrayCollection):void
		{
			win.previewPanel.setCurrentShapes(timeIds, lineIds);
		}
		
		/**
		 * 清空选中项
		 */
		public function cleanSelect():void
		{
			win.previewPanel.cleanSelect();
		}
		
		protected function zoomBackHandle():void
		{
			win.slider.value=1;
			win.previewPanel.setData(clone(backUpData)as ByteArray);
		}
		
		/**
		 * 克隆对象
		 * @param source
		 * @return
		 *
		 */
		private static function clone(source:Object):*
		{
			var myBA:ByteArray=new ByteArray();
			myBA.writeObject(source);
			myBA.position=0;
			return (myBA.readObject());
		}
	}
}

