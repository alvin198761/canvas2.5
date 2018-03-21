package com.print.action
{
	
	import com.print.bean.shape.ShapeCompFactory;
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.datashape.line.BaseLineShape;
	import com.print.bean.shape.datashape.state.BaseStateShape;
	import com.print.bean.shape.shapepane.DrawPane;
	import com.print.comp.TCDToolBar;
	import com.print.util.ArrayCollectionUtil;
	import com.print.util.DrawBoardUtil;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 图形剪贴板
	 * @author 唐植超
	 *
	 */
	public class ShapeClipBoard
	{
		
		public function ShapeClipBoard(single:Singleton)
		{
		}
		
		private var _drawPane:DrawPane;
		//剪贴板数据存储
		private var clipMap:Object=new Object();
		//工具条
		private var _toolBar:TCDToolBar=null;
		
		private static var instance:ShapeClipBoard;
		
		
		public function get toolBar():TCDToolBar
		{
			return _toolBar;
		}
		
		public function set toolBar(value:TCDToolBar):void
		{
			_toolBar=value;
		}
		
		/**
		 *画图板
		 */
		public function get drawPane():DrawPane
		{
			return this._drawPane;
		}
		
		/**
		 * @private
		 */
		public function set drawPane(value:DrawPane):void
		{
			this._drawPane=value;
		}
		
		public static function getInstance():ShapeClipBoard
		{
			if (instance == null)
			{
				instance=new ShapeClipBoard(new Singleton())
			}
			return instance;
		}
		
		/**
		 * 复制
		 *
		 */
		public function copy():void
		{
			if (!canCopy())
			{
				return ;
			}
			var len:int=drawPane.shapes.length;
			var i:int;
			var copyShape:BaseDataShape;
			var shape:BaseDataShape;
			var copyData:ArrayCollection=new ArrayCollection();
			for(i=0; i < len; i++)
			{
				shape=drawPane.shapes.getItemAt(i)as BaseDataShape;
				if (!shape.select)
				{
					continue;
				}
				copyShape=ShapeCompFactory.getInstance().createShape(shape.type);
				if (copyShape == null)
				{
					return ;
				}
				
				if (copyShape is BaseLineShape)
				{
					copyShape.x=shape.x;
					copyShape.y=shape.y;
					copyShape.width=shape.width;
					copyShape.height=shape.height;
					
					copyShape.text=shape.text;
					copyShape.timeId=DrawBoardUtil.getLongId();
					copyShape.type=shape.type;
					copyShape.model=shape.model;
					
					var line:BaseLineShape=BaseLineShape(shape);
					var copyLine:BaseLineShape=BaseLineShape(copyShape);
					
					copyLine.startX=line.startX + 10;
					copyLine.startY=line.startY + 10;
					copyLine.endX=line.endX + 10;
					copyLine.endY=line.endY + 10;
					copyLine.select=true;
					copyData.addItem(copyLine);
				}
				else
				{
					copyShape.x=shape.x + 10;
					copyShape.y=shape.y + 10;
					
					copyShape.width=shape.width;
					copyShape.height=shape.height;
					
					copyShape.model=shape.model;
					copyShape.select=true;
					copyShape.text=shape.text;
					copyShape.type=shape.type;
					copyShape.timeId=DrawBoardUtil.getLongId();
					copyData.addItem(copyShape);
				}
			}
			clipMap["copy"]=copyData;
			toolBar.firePropertiChange();
		}
		
		/**
		 * 剪贴
		 *
		 */
		public function cut():void
		{
			if (!canCut())
			{
				return ;
			}
			var len:int=drawPane.shapes.length;
			var i:int;
			var copyShape:BaseDataShape;
			var copyData:ArrayCollection=new ArrayCollection();
			var shape:BaseDataShape;
			for(i=len - 1; i >= 0; i--)
			{
				shape=drawPane.shapes.getItemAt(i)as BaseDataShape;
				if (!shape.select)
				{
					continue;
				}
				copyShape=ShapeCompFactory.getInstance().createShape(shape.type);
				if (copyShape is BaseLineShape)
				{
					copyShape.x=shape.x;
					copyShape.y=shape.y;
					copyShape.width=shape.width;
					copyShape.height=shape.height;
					
					copyShape.model=shape.model;
					copyShape.select=true;
					copyShape.text=shape.text;
					copyShape.type=shape.type;
					copyShape.timeId=DrawBoardUtil.getLongId();
					
					var copyLine:BaseLineShape=BaseLineShape(copyShape);
					var line:BaseLineShape=BaseLineShape(shape);
					
					copyLine.startX=line.startX;
					copyLine.startY=line.startY;
					copyLine.endX=line.endX;
					copyLine.endY=line.endY;
					copyData.addItem(copyLine);
				}
				else
				{
					
					copyShape.x=shape.x;
					copyShape.y=shape.y;
					
					copyShape.model=shape.model;
					copyShape.select=true;
					copyShape.width=shape.width;
					copyShape.height=shape.height;
					copyShape.text=shape.text;
					copyShape.type=shape.type;
					copyShape.timeId=DrawBoardUtil.getLongId();
					copyData.addItem(copyShape);
				}
				copyData.addItem(copyShape);
				
			}
			drawPane.undoManager.addCmd(drawPane.shapes);
			//删除选中项
			drawPane.deleteSelectShape(null);
			
			clipMap["copy"]=copyData;
			toolBar.firePropertiChange();
		}
		
		/**
		 * 粘贴
		 *
		 */
		public function paste():void
		{
			if (!canPaste())
			{
				return ;
			}
			var shapes:ArrayCollection=ArrayCollection(clipMap["copy"]);
			if (shapes == null)
			{
				return ;
			}
			drawPane.clearSelect();
			var len:int=shapes.length;
			var shape:BaseDataShape;
			var line:BaseLineShape;
			var i:int;
			var lx:Number;
			var ly:Number;
			var lw:Number;
			var lh:Number;
			//添加图形
			for(i=0; i < len; i++)
			{
				shape=BaseDataShape(shapes.getItemAt(i));
				if (shape is BaseStateShape)
				{
					drawPane.updateUI(shape);
				}
			}
			
			for(i=0; i < len; i++)
			{
				shape=BaseDataShape(shapes.getItemAt(i));
				if (shape is BaseLineShape)
				{
					drawPane.updateUI(shape);
				}
			}
			//维护图形位置 和属性
			for(i=0; i < len; i++)
			{
				shape=BaseDataShape(shapes.getItemAt(i));
				shape.select=true;
				
				if (shape is BaseLineShape)
				{
					BaseLineShape(shape).autoRelation(shapes);
				}
			}
			
			//选中所有图形
			for(i=0; i < len; i++)
			{
				shape=BaseDataShape(shapes.getItemAt(i));
				if (shape is BaseLineShape)
				{
					line=BaseLineShape(shape);
					if (line.isErrorConnection())
					{
						drawPane.removeChild(line);
						ArrayCollectionUtil.remove(line, drawPane.shapes);
					}
				}
				shape.select=true;
				if (shape is BaseStateShape)
				{
					shape.contrlLines();
				}
			}
			
			drawPane.undoManager.addCmd(drawPane.shapes);
			copy();
		}
		
		/**
		 * 能否复制
		 * @return
		 *
		 */
		public function canCopy():Boolean
		{
			return isSelectShapes();
		}
		
		/**
		 * 释放选中了图形
		 * @return
		 *
		 */
		private function isSelectShapes():Boolean
		{
			var shapes:ArrayCollection=drawPane.shapes;
			var len:int=shapes.length;
			var i:int;
			var shape:BaseDataShape;
			for(i=0; i < len; i++)
			{
				shape=shapes.getItemAt(i)as BaseDataShape;
				if (shape.select)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 能否剪切
		 * @return
		 *
		 */
		public function canCut():Boolean
		{
			return canCopy();
		}
		
		/**
		 * 能否粘贴
		 * @return
		 *
		 */
		public function canPaste():Boolean
		{
			var shapes:ArrayCollection=ArrayCollection(clipMap["copy"]);
			return shapes != null && shapes.length > 0;
		}
		
	}
}

class Singleton
{
}

