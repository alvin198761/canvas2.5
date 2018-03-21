package com.print.comp
{
	import com.print.action.ShapeClipBoard;
	import com.print.action.UpOrDownLoad;
	import com.print.bean.entity.ScaleItemBean;
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.datashape.line.BaseLineShape;
	import com.print.bean.shape.shapepane.DrawPane;
	import com.print.io.XMLOperate;
	import com.print.util.AlertUtil;
	import com.print.util.DrawBoardUtil;
	import com.print.util.InterfaceUtil;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	
	/**
	 *工具条 唐植超
	 */
	public class TCDToolBarAs extends VBox
	{
		private var currentWin:TCDToolBar;
		//画图板
		protected var _drawPane:DrawPane;
		//文件上传和下载
		private var udl:UpOrDownLoad;
		//比率
		public static const scaleList:ArrayCollection=ScaleItemBean.getDefaultList();
		//剪贴板
		private var clip:ShapeClipBoard=ShapeClipBoard.getInstance();
		
		public function TCDToolBarAs()
		{
			super();
		}
		
		/**
		 * 初始化
		 * @param win
		 *
		 */
		protected function init(win:TCDToolBar):void
		{
			this.currentWin=win;
			udl=new UpOrDownLoad(win);
			clip.toolBar=win;
			_drawPane.undoManager.toolBar=currentWin;
			firePropertiChange();
		}
		
		public function get drawPane():DrawPane
		{
			return _drawPane;
		}
		
		public function set drawPane(value:DrawPane):void
		{
			_drawPane=value;
			clip.drawPane=value;
			
		}
		
		
		protected function resetDefaultCursor(event:Event):void
		{
			_drawPane.resetDefaultOperate();
			
			CursorManager.removeAllCursors();
			CursorManager.showCursor();
		}
		
		/**
		 * 新建画图
		 * @param event
		 *
		 */
		protected function newCanvas(event:Event):void
		{
			if (!drawPane.save)
			{
				AlertUtil.getAlert("是否保存当前操作？", doNewCanvas)
				return ;
			}
			//删除图形
			drawPane.resetShape(null);
			drawPane.undoManager.clear()
		}
		
		private function doNewCanvas(event:CloseEvent):void
		{
			if (event.detail == Alert.YES)
			{
				saveFile(null);
			}
			else
			{
				return ;
			}
			drawPane.resetShape(null);
			drawPane.undoManager.clear()
		}
		
		/**
		 * 打开文件
		 * @param event
		 *
		 */
		protected function openFile(event:Event):void
		{
			udl.openFile();
			drawPane.changeBox.visible=false;
		}
		
		/**
		 * 保存文件
		 * @param event
		 *
		 */
		protected function saveFile(event:Event):void
		{
			drawPane.changeBox.visible=false;
			if (validateShapes())
			{
				
			}
			udl.saveFile(drawPane.shapes);
			firePropertiChange();
		}
		
		/**
		 * 保存前的验证
		 * @return
		 *
		 */
		private function validateShapes():Boolean
		{
			var textMap:Object=new Object();
			for each(var shape:BaseDataShape in drawPane.shapes)
			{
				if (shape is BaseLineShape)
				{
					continue;
				}
				shape.contrlLines();
				if (!shape.editabel)
				{
					continue;
				}
				if (textMap[shape.text] != null)
				{
					AlertUtil.showInfo("图形\"" + shape.toString() + "\"有重名的冲突！");
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 复制
		 * @param event
		 *
		 */
		protected function copy(event:Event):void
		{
			drawPane.changeBox.visible=false;
			clip.copy();
			firePropertiChange();
		}
		
		/**
		 * 粘贴
		 * @param event
		 *
		 */
		protected function paste(event:Event):void
		{
			drawPane.changeBox.visible=false;
			clip.paste();
			firePropertiChange();
		}
		
		/**
		 * 剪切
		 * @param event
		 *
		 */
		protected function cut(event:Event):void
		{
			drawPane.changeBox.visible=false;
			AlertUtil.getAlert("如果剪切，可能会导致部分连线在剪切中丢失！", doCut);
		}
		
		private function doCut(event:CloseEvent):void
		{
			if (event.detail == Alert.YES)
			{
				clip.cut();
				firePropertiChange();
			}
		}
		
		/**
		 * 撤销
		 * @param event
		 *
		 */
		protected function undo(event:Event):void
		{
			drawPane.changeBox.visible=false;
			drawPane.undoManager.undo();
			drawPane.save=false;
			firePropertiChange();
		}
		
		/**
		 * 恢复
		 * @param event
		 *
		 */
		protected function redo(event:Event):void
		{
			drawPane.changeBox.visible=false;
			drawPane.undoManager.redo();
			drawPane.save=false;
			firePropertiChange();
		}
		
		/**
		 * 退出
		 * @param event
		 *
		 */
		protected function exit(event:Event):void
		{
			drawPane.changeBox.visible=false;
			AlertUtil.getAlert("当前画图操作正在进行，是否保存？", doExit);
		}
		
		/**
		 * 退出
		 * @param event
		 *
		 */
		private function doExit(event:CloseEvent):void
		{
			if (event.detail == Alert.YES)
			{
				saveFile(null);
			}
			else if (event.detail == Alert.NO)
			{
				var inter:InterfaceUtil=InterfaceUtil.getInstance();
				inter.mainFrame.currentState=inter.stateStr;
			}
		}
		
		/**
		 * 全选
		 * @param event
		 *
		 */
		protected function selectAll(event:Event):void
		{
			drawPane.changeBox.visible=false;
			drawPane.selectAll=!drawPane.selectAll;
			firePropertiChange();
		}
		
		/**
		 * 删除图形
		 * @param event
		 *
		 */
		protected function deleteShape(event:Event):void
		{
			drawPane.changeBox.visible=false;
			drawPane.deleteSelectShape(event);
			firePropertiChange();
		}
		
		
		/**
		 * 更新空间显示
		 */
		public function firePropertiChange():void
		{
			currentWin.openBtn.enabled=true;
			currentWin.newBtn.enabled=true;
			
			currentWin.saveBtn.enabled=!drawPane.save;
			currentWin.undoBtn.enabled=drawPane.undoManager.CanUndo;
			currentWin.redoBtn.enabled=drawPane.undoManager.CanRedo;
			currentWin.copyBtn.enabled=clip.canCopy();
			currentWin.cutBtn.enabled=clip.canCut();
			currentWin.pasteBtn.enabled=clip.canPaste();
			currentWin.selectAllBtn.enabled=drawPane.shapes.length > 0;
			
			currentWin.deleteSelectBtn.enabled=currentWin.copyBtn.enabled;
			currentWin.selectAllBtn.label="全选";
			if (!drawPane.selectAll)
			{
				return ;
			}
			if (drawPane.shapes.length == 0)
			{
				return ;
			}
			currentWin.selectAllBtn.label="全不选";
		}
		
		/**
		 * 按键事件
		 * @param event
		 *
		 */
		public function keyDownAction(event:KeyboardEvent):void
		{
			var keyCode:Number=event.keyCode;
			var ctrlKey:Boolean=event.ctrlKey;
			switch(keyCode)
			{
				case 46:
					deleteShape(event);
					//按delete删除
					break;
				case 67:
					if (ctrlKey)
					{
						copy(event);
						//ctrl + c
					}
					break;
				case 88:
					if (ctrlKey)
					{
						cut(event);
						//ctrl + x
					}
					break;
				case 86:
					if (ctrlKey)
					{
						paste(event);
						//ctrl + v
					}
					break;
				case 90:
					if (ctrlKey)
					{
						undo(event);
						//ctrl + z
					}
					break;
				case 89:
					if (ctrlKey)
					{
						redo(event);
						//ctrl + y
					}
					break;
				case 65:
					if (ctrlKey)
					{
						selectAll(event);
						//ctrl + a
					}
					break;
				case 83:
					if (ctrlKey)
					{
						//保存
						saveFile(event);
					}
					break;
				// 下面是上下左右
				case 37:
					moveUpOrDwon(-10, 0);
					break;
				case 38:
					moveUpOrDwon(0, -10);
					break;
				case 39:
					moveUpOrDwon(10, 0);
					break;
				case 40:
					moveUpOrDwon(0, 10);
					break;
			}
		}
		
		private function moveUpOrDwon(num1:Number, num2:Number):void
		{
			drawPane.changeBox.visible=false;
			for each(var shape:BaseDataShape in drawPane.shapes)
			{
				if (shape is BaseLineShape)
				{
					continue;
				}
				if (!shape.select)
				{
					continue;
				}
				shape.x+=num1;
				shape.y+=num2;
				if (shape.x < 0)
				{
					shape.x=0;
				}
				
				if (shape.y < 0)
				{
					shape.y=0;
				}
				
				if (shape.x + shape.width > (drawPane.width / drawPane.scaleX))
				{
					shape.x=(drawPane.width / drawPane.scaleX) - shape.width;
				}
				
				if (shape.y + shape.height > (drawPane.height / drawPane.scaleY))
				{
					shape.y=(drawPane.height / drawPane.scaleY) - shape.height;
				}
				shape.contrlLines();
			}
		}
		
		
		public function showPreviewPane():void
		{
			drawPane.changeBox.visible=false;
			var child:TestPreview=PopUpManager.createPopUp(DrawBoardUtil.model, TestPreview, true, null)as TestPreview;
			PopUpManager.centerPopUp(child);
			
			var obj:Object=XMLOperate.getInstance().shapeToVkd(drawPane.shapes);
			child.previewPane.previewPanel.shapes=XMLOperate.getInstance().vkdToShapes(obj, BaseDataShape.MODEL_PREVIEW);
		}
		
	}
}

