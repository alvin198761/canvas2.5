package com.print.action
{
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.comp.TCDToolBar;
	import com.print.io.XMLOperate;
	import com.print.util.AlertUtil;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 文件上传和下载的类
	 * @author 唐植超
	 *
	 */
	public class UpOrDownLoad
	{
		private var win:TCDToolBar;
		private var content:String;
		//文件内容
		private var bitMap:BitmapData;
		//截图
		private var file:FileReference;
		private var imageFile:FileReference;
		//截图
		private var isOperOrSave:Boolean;
		//xml操作类
		private var xmlOperate:XMLOperate=XMLOperate.getInstance();
		
		public function UpOrDownLoad(win:TCDToolBar)
		{
			file=new FileReference()
			file.addEventListener(Event.SELECT, selectFileHandler);
			file.addEventListener(Event.COMPLETE, completeHandler);
			
			imageFile=new FileReference();
			imageFile.addEventListener(Event.SELECT, selectImageSaveHandler);
			
			this.win=win;
		}
		
		/**
		 * 文件过滤
		 * @return
		 *
		 */
		private function getFilter():Array
		{
			return new Array(new FileFilter("File(*.vkd)", "*.vkd"));
		}
		
		/**
		 * 打开文件
		 * @param win
		 *
		 */
		public function openFile():void
		{
			isOperOrSave=true;
			file.browse(getFilter());
		}
		
		/**
		 * 保存文件
		 * @param shapes
		 *
		 */
		public function saveFile(shapes:ArrayCollection):void
		{
			var content:String=xmlOperate.shapeToVkd(shapes);
			if (content == "")
			{
				return ;
			}
			isOperOrSave=false;
			this.content=content;
			this.bitMap=bitMap;
			file.save(content, "新建活动图.vkd");
		}
		
		public function saveImageFile(bitMap:BitmapData):void
		{
			this.bitMap=bitMap;
			splitImage();
		}
		
		private function cancelHandler(event:Event):void
		{
			
		}
		
		private function completeHandler(event:Event):void
		{
			if (isOperOrSave)
			{
				win.drawPane.resetShape(xmlOperate.vkdToShapes(event.target.data, BaseDataShape.MODEL_DRAW));
				win.drawPane.undoManager.addCmd(win.drawPane.shapes);
				win.firePropertiChange();
			}
			event.stopPropagation();
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			
		}
		
		private function openHandler(event:Event):void
		{
			event.stopPropagation();
		}
		
		private function progressHandler(event:ProgressEvent):void
		{
			
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			
		}
		
		private function selectFileHandler(event:Event):void
		{
			//选择了文件
			if (event.target.type.toLowerCase() != ".vkd".toString().toLowerCase())
			{
				AlertUtil.showInfo("文件类型错误!");
				return ;
			}
			if (isOperOrSave)
			{
				//保存文件
				event.target.load();
			}
		}
		
		
		private function splitImage():void
		{
			if (bitMap == null)
			{
				return ;
			}
			/*var w:int=DrawBoardManager.getInstance().drawPane.width;
			var h:int=DrawBoardManager.getInstance().drawPane.height;
			var rect:Rectangle=new Rectangle(0, 0, w, h);
			var pngEncoder:PNGEncoder=new PNGEncoder();
			var bytes:ByteArray=pngEncoder.encodeByteArray(this.bitMap.getPixels(rect), w, h);
			imageFile.save(bytes, "新建活动图.png");*/
		}
		
		/**
		 * 保存图片
		 * @param event
		 *
		 */
		private function selectImageSaveHandler(event:Event):void
		{
			//选择了文件
			if (event.target.type.toLowerCase() == ".png".toString().toLowerCase())
			{
				return ;
			}
			AlertUtil.showInfo("文件类型错误!");
		}
	}
}

