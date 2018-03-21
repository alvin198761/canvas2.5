package com.print.action
{
	import com.print.bean.shape.shapepane.DrawPane;
	import com.print.comp.TCDToolBar;
	
	import mx.collections.ArrayCollection;
	
	public class UndoManager
	{
		
		public function UndoManager(drawPane:DrawPane)
		{
			_undoList.addItem(new CommandBase(drawPane, new ArrayCollection()));
			this._drawPane=drawPane;
		}
		
		private var _undoList:ArrayCollection=new ArrayCollection();
		private var _redoList:ArrayCollection=new ArrayCollection();
		private var _drawPane:DrawPane;
		//工具条
		private var _toolBar:TCDToolBar=null;
		
		public function get toolBar():TCDToolBar
		{
			return _toolBar;
		}
		
		public function set toolBar(value:TCDToolBar):void
		{
			_toolBar=value;
		}
		
		public function get CanRedo():Boolean
		{
			return _redoList.length > 0;
		}
		
		public function get CanUndo():Boolean
		{
			return _undoList.length > 0;
		}
		
		public function redo():void
		{
			if (!CanRedo)
				return ;
			var command:CommandBase=_redoList.removeItemAt(_redoList.length - 1)as CommandBase;
			command.unExecute();
			_undoList.addItem(command);
			toolBar.firePropertiChange();
		}
		
		public function undo():void
		{
			if (!CanUndo)
				return ;
			var command:CommandBase=_undoList.removeItemAt(_undoList.length - 1)as CommandBase;
			_redoList.addItem(command);
			command.unExecute();
			toolBar.firePropertiChange();
		}
		
		private function executeCommand(command:CommandBase):void
		{
			command.execute();
			appendCommand(command);
		}
		
		private function appendCommand(command:CommandBase):void
		{
			//有新命令添加时清空RedoList， 
			_redoList.removeAll();
			if(_undoList.length == 0){
				_undoList.addItem(new CommandBase(_drawPane, new ArrayCollection()));
			}
			_undoList.addItem(command);
		}
		
		//添加对象
		public function addCmd(shapes:ArrayCollection):void
		{
			var command:CommandBase=new CommandBase(_drawPane, shapes);
			executeCommand(command);
			toolBar.firePropertiChange();
		}
		
		//清空数据
		public function clear():void{
			_undoList.removeAll();
			_redoList.removeAll();
			toolBar.firePropertiChange();
		}
	}
}
import com.print.bean.shape.datashape.BaseDataShape;
import com.print.bean.shape.shapepane.DrawPane;
import com.print.io.XMLOperate;

import mx.collections.ArrayCollection;

class CommandBase
{
	protected var _shapes:ArrayCollection;
	protected var _drawPane:DrawPane;
	protected var _dataStr:String;
	
	public function CommandBase(drawPane:DrawPane, shapes:ArrayCollection)
	{
		this._drawPane=drawPane;
		this._shapes=shapes;
	}
	
	public function execute():void
	{
		this._dataStr=XMLOperate.getInstance().shapeToVkd(this._shapes);
	}
	
	public function unExecute():void
	{
		this._drawPane.resetShape(XMLOperate.getInstance().vkdToShapes(this._dataStr, BaseDataShape.MODEL_DRAW));
		this._drawPane.clearSelect();
	}
}



