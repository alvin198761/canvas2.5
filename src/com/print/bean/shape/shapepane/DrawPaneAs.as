package com.print.bean.shape.shapepane
{
	
	import com.print.action.ShapeClipBoard;
	import com.print.action.UndoManager;
	import com.print.bean.shape.BaseShape;
	import com.print.bean.shape.ShapeCompFactory;
	import com.print.bean.shape.contr.ChangeSizeContrlBox;
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.datashape.line.BaseLineShape;
	import com.print.bean.shape.datashape.state.BaseStateShape;
	import com.print.bean.shape.datashape.state.LaneShape;
	import com.print.bean.shape.gui.ChangeSizeBox;
	import com.print.bean.shape.gui.MainBackGroudGridPane;
	import com.print.bean.shape.gui.SelectBox;
	import com.print.comp.ShapeAttributePane;
	import com.print.event.LineShapeButtonEvent;
	import com.print.util.ArrayCollectionUtil;
	
/* 	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle; */
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.core.DragSource;
	import mx.events.DragEvent;
	import mx.events.ScrollEvent;
	import mx.managers.CursorManager;
	import mx.managers.DragManager;
	
	/**
	 * 画图板
	 * @author 唐植超
	 *
	 */
	public class DrawPaneAs extends BaseDrawPane
	{
		public static const OPERATE_STATE_ADD:String="addShape";
		public static const OPERATE_STATE_DRAG:String="dragShape";
		public static const OPERATE_STATE_DRAWLINE:String="drawLineShape";
		public static const OPERATE_STATE_SELECTALL:String="selectAll";
		public static const OPERATE_STATE_CHANGESIZE:String="changeSize";
		public static const OPERATE_STATE_DRAWSELECTBOX:String="drawSelectBox";
		public static const OPERATE_STATE_SELECTMORESHAPES:String="selectMoreShapes";
		public static const OPERATE_STATE_MOVESELECTSHAPES:String="moveSelectShape";
		public static const OPERATE_STATE_MORESHAPES_CLICK:String="moreShapes_click";
		public static const OPERATE_STATE_NONE:String="none";
		
		public static const OPERATE_STATE_CHANGESELECTEDSIZE:String="changeSelectedSize";
		//选择图形框
		public var selectBox:SelectBox;
		//当前的比例索引
		public var currentScaleIndex:Number;
		//网格
		protected var mainGUI:MainBackGroudGridPane;
		//操作状态 不同的状态有不同的操作， 如添加 ，拖动 ……
		private var operateState:String;
		//当前窗体
		private var currentWin:DrawPane;
		//是否全选
		private var _selectAll:Boolean=false;
		//当前拖入的新图形
		private var currentNewShape:BaseDataShape=null;
		//当前选择的图形
		private var _currentSelectShape:BaseDataShape=null;
		//记录鼠标的坐标
		private var startPoint:Point=new Point();
		//图形点击时候的坐标
		private var shapeClickPoint:Point=new Point();
		//是否保存
		private var _save:Boolean=true;
		//是否一起移动
		private var _selectAllShape:Boolean=false;
		//是否点击了图形 没有点击到 为false 用来画选择框
		private var isExistsPoint:Boolean=false;
		//是否是控制图形
		private var isControl:Boolean=false;
		//拖动图形
		private var _isDrag:Boolean=false;
		//当前选中的控制点
		private var currentSelectedControlCompShape:ChangeSizeContrlBox;
		//当前产生的线条
		private var currentLine:BaseLineShape;
		//当前产生的线条的类型
		private var currentLineType:Number;
		//剪贴板
		private var clip:ShapeClipBoard=ShapeClipBoard.getInstance();
		//属性面板
		private var _shapeAttribte:ShapeAttributePane;
		//开始拖拽的位置 用于放下是计算坐标
		private var _startDragPoint:Point;
		//撤销恢复
		public var undoManager:UndoManager;
		
		//V2.3添加的属性
		public var changeBox:ChangeSizeBox;
		
		public function DrawPaneAs()
		{
			super();
		}
		
		public function get shapeAttribte():ShapeAttributePane
		{
			return _shapeAttribte;
		}
		
		public function set shapeAttribte(value:ShapeAttributePane):void
		{
			_shapeAttribte=value;
		}
		
		public function get currentSelectShape():BaseDataShape
		{
			return _currentSelectShape;
		}
		
		public function set currentSelectShape(value:BaseDataShape):void
		{
			_currentSelectShape=value;
			_shapeAttribte.currentShape=value;
		}
		
		protected function init(win:DrawPane):void
		{
			this.currentWin=win;
			
			this.undoManager=new UndoManager(win)
			//support.drawPane = win;
			clip.drawPane=win;
			//初始化
			selectBox=new SelectBox();
			win.addChild(selectBox);
			//网格
			mainGUI=new MainBackGroudGridPane();
			win.addChild(mainGUI);
			//大小控制器
			changeBox=new ChangeSizeBox();
			win.addChild(changeBox);
			//初始化网格
			mainGUI.init();
			//初始化action
			initAction(win);
			/*之处撤销恢复  但是一定要在本类的事件添加完成之后在执行下面的代码
			因为事件的添加有先后顺序 执行的时候也有先后顺序 切记
			*/
		}
		
		//初始化action
		private function initAction(win:DrawPane):void
		{
			//拖拽用的事件，可以不用管了
			win.addEventListener(DragEvent.DRAG_ENTER, dragEndterHandle);
			win.addEventListener(DragEvent.DRAG_DROP, dragAndDropHandle);
			
			//鼠标事件 ，重新写
			win.addEventListener(MouseEvent.MOUSE_DOWN, shapeMouseDownHandle);
			win.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandle);
			win.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandle);
			//滚动条的问题
			win.addEventListener(ScrollEvent.SCROLL, scollHandle);
			//鼠标滚动 + ctrl
			win.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandle);
			win.addEventListener(MouseEvent.CLICK, mouseClickHandle);
		}
		
		//鼠标按下
		private function shapeMouseDownHandle(event:MouseEvent):void
		{
			currentSelectedControlCompShape=null;
			currentNewShape=null;
			selectBox.hide();
			
			startPoint.x=mouseX;
			startPoint.y=mouseY;
			
			//如果是全选 不做处理
			if (operateState == OPERATE_STATE_SELECTALL)
			{
				return ;
			}
			//如果不是全选
			//1.将图形的关系重新整理
			trimShapes();
			//V2.3下面要重写很多东西 复杂的呢
			//如果当前是改变图形大小的状态
			trace("111");
			if (changeBox.visible)
			{
				trace("222");
				//要看看有没有点击选择框
				currentSelectedControlCompShape=changeBox.containsContrl();
				if (currentSelectedControlCompShape != null)
				{
					operateState=OPERATE_STATE_CHANGESIZE;
					trace("333");
					return ;
				}
			}
			
			//3.是否点到了图形
			currentSelectShape=isContainerShape();
			//如果选择框选择了多个图形
			if (operateState == OPERATE_STATE_SELECTMORESHAPES)
			{
				if (changeBox.visible)
				{
					operateState=OPERATE_STATE_NONE;
					trace("!!!!");
					changeBox.visible=false;
				}
				trace("444");
				if (currentSelectShape == null)
				{
					trace("555");
					//清空所有的选中的图形
					selectBox.cleanSelectShapes();
					//不选择所有的图形
					clearSelect();
					//重新进入绘图的节目
					selectBox.x=mouseX;
					selectBox.y=mouseY;
					operateState=OPERATE_STATE_DRAWSELECTBOX;
					return ;
				}
				else
				{
					trace("666");
					if (selectBox.indexOf(currentSelectShape) == -1)
					{
						trace("777");
						//这是一个特殊的状态 当前已经选中了很多的图形， 但我点击了一个没有选中的图形
						operateState=OPERATE_STATE_MORESHAPES_CLICK;
						clickShapes();
						return ;
					}
					//改变为移动选中的图形
					operateState=OPERATE_STATE_MOVESELECTSHAPES;
					return ;
				}
				return ;
			}
			
			if (currentSelectShape != null)
			{
				trace("888");
				clickShapes();
				//如果是划线的状态，则和选择框冲突
				if (operateState == OPERATE_STATE_DRAWLINE)
				{
					trace("999");
					changeBox.visible=false;
					return ;
				}
				return ;
			}
			
			//如果是划线的状态，则和选择框冲突
			if (operateState == OPERATE_STATE_DRAWLINE)
			{
				trace("999");
				changeBox.visible=false;
				return ;
			}
			
			
			//4.都没有选中 那么点到了空的地方
			
			//清空所有的选中
			clearSelect();
			operateState=OPERATE_STATE_DRAWSELECTBOX;
			selectBox.x=mouseX;
			selectBox.y=mouseY;
			selectBox.cleanSelectShapes();
			trace("000");
		}
		
		/**
		 * 点击图形后的操作
		 */
		private function clickShapes():void
		{
			//划线
			if (operateState == OPERATE_STATE_DRAWLINE)
			{
				if (!currentSelectShape.connection)
				{
					return ;
				}
				//创建一个线条
				currentLine=BaseLineShape(ShapeCompFactory.getInstance().createShape(currentLineType));
				//清空其他图形
				clearSelect();
				
				currentLine.select=true;
				//维护连线的属性
				
				currentLine.hasAnchor=true;
				
				currentLine.startShape=BaseStateShape(currentSelectShape);
				
				var mp:Point=currentSelectShape.getMiddlePoint();
				
				currentLine.startX=currentSelectShape.x + mp.x;
				currentLine.endX=currentSelectShape.x + mp.x;
				
				currentLine.startY=currentSelectShape.y + mp.y;
				currentLine.endY=currentSelectShape.y + mp.y;
				currentLine.select=true;
				updateUI(currentLine);
				undoManager.toolBar.firePropertiChange();
				return ;
			}
			else
			{
				//清空其他图形
				clearSelect();
				//3.1将图形选中
				currentSelectShape.select=true;
				undoManager.toolBar.firePropertiChange();
				//3.2将图形维护到最上层
				currentWin.removeChild(selectBox);
				if (currentSelectShape.parent != this)
				{
					currentSelectShape.repaint();
					currentWin.addChild(currentSelectShape);
				}
				else
				{
					currentWin.removeChild(currentSelectShape);
					currentWin.addChild(currentSelectShape);
				}
				currentWin.addChild(selectBox);
				//3.3将操作状态改到拖动状态
				operateState=OPERATE_STATE_DRAG;
				//隐藏选择框
				changeBox.visible=false;
				return ;
			}
		}
		
		/**
		 * 是否有选中图形
		 * @return
		 *
		 */
		private function isContainerShape():BaseDataShape
		{
			var shape:BaseDataShape=null;
			if (currentSelectShape != null && !(currentSelectShape is BaseLineShape))
			{
				if (currentSelectShape.getBox().contains(mouseX, mouseY))
				{
					shapeClickPoint.x=currentSelectShape.mouseX;
					shapeClickPoint.y=currentSelectShape.mouseY;
					return currentSelectShape;
				}
			}
			for(var i:Number=shapes.length - 1; i >= 0; i--)
			{
				shape=shapes.getItemAt(i)as BaseDataShape;
				if (shape is BaseLineShape)
				{
					if (this.operateState == OPERATE_STATE_DRAWLINE)
					{
						continue;
					}
					if (BaseLineShape(shape).containsPoint())
					{
						return shape;
					}
					continue;
				}
				if (shape.getBox().contains(mouseX, mouseY))
				{
					return shape;
				}
			}
			return null;
		}
		
		//鼠标放开
		private function mouseUpHandle(event:MouseEvent):void
		{
			trace("qqq");
			switch(operateState)
			{
				case OPERATE_STATE_ADD:
					trace("wwww");
					this.addNewShape();
					break;
				case OPERATE_STATE_DRAG:
					trace("eeee");
					this.dragShapeAction();
					break;
				case OPERATE_STATE_DRAWLINE:
					trace("rrrr");
					changeBox.visible=false;
					this.drawLineAction();
					break;
				case OPERATE_STATE_CHANGESIZE:
				{
					trace("tttt");
					operateState=OPERATE_STATE_NONE;
					break;
				}
				case OPERATE_STATE_DRAWSELECTBOX:
				{
					trace("yyyy");
					if (changeBox.visible)
					{
						changeBox.visible=false;
						trace("zzz");
					}
						//大小控制器
					else if (selectBox.shapes.length > 0)
					{
						trace("uuuu");
						currentWin.removeChild(changeBox);
						changeBox.changeSize(selectBox);
						currentWin.addChild(changeBox);
						operateState=OPERATE_STATE_CHANGESELECTEDSIZE;
					}
					
					selectBox.hide();
					if (selectBox.shapeSize() > 1)
					{
						trace("ïiii");
						operateState=OPERATE_STATE_SELECTMORESHAPES;
					}
					else
					{
						trace("oooo");
						undoManager.toolBar.firePropertiChange();
						operateState=OPERATE_STATE_NONE;
					}
					break;
				}
				case OPERATE_STATE_MOVESELECTSHAPES:
				{
					trace("pppp");
					operateState=OPERATE_STATE_SELECTMORESHAPES;
					break;
				}
				case OPERATE_STATE_NONE:
					trace("默认状态");
					break;
				default:
					trace("未知状态");
					break;
			}
		}
		
		/**
		 * 拖动线条 放开鼠标后的操作
		 */
		private function dragShapeAction():void
		{
			//移动线条
			for each(var shape:BaseDataShape in shapes)
			{
				shape.contrlLines();
			}
			_save=false;
			
			currentWin.removeChild(changeBox);
			changeBox.changeSize(currentSelectShape);
			currentWin.addChild(changeBox);
		}
		
		//添加新的图形
		private function addNewShape():void
		{
			if (currentNewShape == null)
			{
				return ;
			}
			currentNewShape.x=mouseX - 1;
			currentNewShape.y=mouseY - 1;
			updateUI(currentNewShape);
			
			undoManager.addCmd(shapes);
			//
			currentSelectShape=currentNewShape;
			currentNewShape=null;
			
			currentWin.removeChild(changeBox);
			changeBox.changeSize(currentSelectShape);
			currentWin.addChild(changeBox);
		}
		
		/**
		 * 鼠标移动
		 * @param event
		 *
		 */
		private function mouseMoveHandle(event:MouseEvent):void
		{
			var shape:BaseDataShape=null;
			
			//全选
			if (operateState == OPERATE_STATE_SELECTALL)
			{
				if (!event.buttonDown)
				{
					return ;
				}
				for each(shape in shapes)
				{
					if (!(shape is BaseStateShape))
					{
						continue;
					}
					if (!shape.select)
					{
						continue;
					}
					shape.x+=mouseX - startPoint.x;
					shape.y+=mouseY - startPoint.y;
					
					shape.contrlLines();
				}
				
				startPoint.x=mouseX;
				startPoint.y=mouseY;
				return ;
			}
			if (operateState == OPERATE_STATE_CHANGESIZE)
			{
				if (!event.buttonDown)
				{
					return ;
				}
				//改变图形大小
				if (currentSelectedControlCompShape == null)
				{
					return ;
				}
				currentSelectedControlCompShape.contrShape(event, mouseX - startPoint.x, mouseY - startPoint.y);
				startPoint.x=mouseX;
				startPoint.y=mouseY;
				
				operateState=OPERATE_STATE_CHANGESIZE;
				
				_save=false;
				return ;
			}
			
			//划线
			if (operateState == OPERATE_STATE_DRAWLINE)
			{
				if (currentLine == null)
				{
					return ;
				}
				
				selectLineCursor();
				currentLine.select=true;
				currentLine.endX=mouseX;
				currentLine.endY=mouseY;
				currentLine.repaint();
				event.stopPropagation();
				return ;
			}
			
			//画选择框
			if (operateState == OPERATE_STATE_DRAWSELECTBOX)
			{
				changeBox.visible=false;
				selectBox.width=mouseX - selectBox.x;
				selectBox.height=mouseY - selectBox.y;
				
				var box:Rectangle=selectBox.getBox();
				for each(shape in shapes)
				{
					if (box.containsRect(shape.getBox()))
					{
						shape.select=true;
						selectBox.addShape(shape);
					}
					else
					{
						shape.select=false;
						selectBox.removeShape(shape);
					}
				}
			}
			//拖动选择的图形
			if (operateState == OPERATE_STATE_MOVESELECTSHAPES)
			{
				for each(shape in shapes)
				{
					if (!(shape is BaseStateShape))
					{
						continue;
					}
					if (!shape.select)
					{
						continue;
					}
					shape.x+=mouseX - startPoint.x;
					shape.y+=mouseY - startPoint.y;
					
					shape.contrlLines();
				}
				
				startPoint.x=mouseX;
				startPoint.y=mouseY;
				
				_save=false;
				return ;
			}
		}
		
		/**
		 * 滚动事件
		 * @param event
		 *
		 */
		private function scollHandle(event:ScrollEvent):void
		{
			
		}
		
		/**
		 * 鼠标滚动
		 * @param event
		 *
		 */
		private function mouseWheelHandle(event:MouseEvent):void
		{
			
		}
		
		/**
		 * 鼠标点击
		 * @param event
		 *
		 */
		private function mouseClickHandle(event:MouseEvent):void
		{
			
		}
		
		/**
		 * 鼠标放开
		 * @param event
		 *
		 */
		public function shapeMouseUpHandle(event:MouseEvent):void
		{
			
		}
		
		/**
		 *鼠标离开图形
		 * @param event
		 *
		 */
		public function shapeMouseOutHandle(event:MouseEvent):void
		{
		}
		
		/**
		 * 拖动图片
		 * @param event
		 *
		 */
		public function shapeDragMove(event:MouseEvent):void
		{
			if (!event.buttonDown)
			{
				return ;
			}
			if (operateState == OPERATE_STATE_DRAWLINE)
			{
				if (currentLine == null)
				{
					return ;
				}
				currentLine.select=true;
				currentLine.endX=mouseX;
				currentLine.endY=mouseY;
				currentLine.repaint();
				return ;
			}
			if (operateState != OPERATE_STATE_DRAG)
			{
				if (operateState == OPERATE_STATE_SELECTALL)
				{
					return ;
				}
				
				if (selectBox.width > 0)
				{
					return ;
				}
				
				if (selectBox.shapeSize() > 0)
				{
					return ;
				}
				
				if (operateState == OPERATE_STATE_DRAWLINE)
				{
					return ;
				}
				
				if (operateState == OPERATE_STATE_SELECTMORESHAPES)
				{
					return ;
				}
				return ;
			}
			if (currentSelectedControlCompShape != null)
			{
				currentSelectedControlCompShape.contrShape(event, mouseX - startPoint.x, mouseY - startPoint.y);
				startPoint.x=mouseX;
				startPoint.y=mouseY;
				
				operateState=OPERATE_STATE_CHANGESIZE;
				return ;
			}
			
			if (currentSelectShape != null)
			{
				//拖动的状态
				operateState=OPERATE_STATE_DRAG;
				var ds:DragSource=new DragSource();
				ds.addData(currentSelectShape, "dragShape");
				
				var showIcon:BaseDataShape=BaseDataShape.cloneShape(currentSelectShape);
				showIcon.x=0;
				showIcon.y=0;
				BaseDataShape(showIcon).model=BaseDataShape.MODEL_PREVIEW;
				showIcon.select=false;
				showIcon.repaint();
				DragManager.doDrag(currentSelectShape, ds, event, showIcon);
				
				return ;
			}
		}
		
		/**
		 * 拖着组件进入画图板
		 * @param event
		 *
		 */
		public function dragEndterHandle(event:DragEvent):void
		{
			if (event.dragSource.hasFormat("shape"))
			{
				DragManager.showFeedback(DragManager.COPY);
				DragManager.acceptDragDrop(BaseShape(event.currentTarget));
				var shape:BaseDataShape=event.dragSource.dataForFormat("shape")as BaseDataShape;
				var newShape:BaseDataShape=BaseDataShape.cloneShape(shape);
				newShape.x=mouseX + 1;
				newShape.y=mouseY + 1;
				newShape.model=BaseDataShape.MODEL_DRAW;
				
				//保存当前的图形
				currentNewShape=newShape;
				currentNewShape.select=true;
				operateState=OPERATE_STATE_ADD;
				//当前状态为添加图形
				_save=false;
				return ;
			}
			
			if (event.dragSource.hasFormat("dragShape"))
			{
				DragManager.acceptDragDrop(BaseShape(event.currentTarget));
				undoManager.addCmd(this.shapes);
				return ;
			}
		}
		
		/**
		 * 在放入图形
		 * @param event
		 *
		 */
		public function dragAndDropHandle(event:DragEvent):void
		{
			if (!(event.dragInitiator is BaseDataShape))
			{
				return ;
			}
			var dragShape:BaseDataShape=BaseDataShape(event.dragInitiator);
			dragShape.x=mouseX - shapeClickPoint.x;
			dragShape.y=mouseY - shapeClickPoint.y;
			//移动线条
			for each(var shape:BaseDataShape in shapes)
			{
				if (shape is BaseStateShape)
				{
					shape.contrlLines();
				}
			}
			
			switch(operateState)
			{
				case OPERATE_STATE_DRAG:
				{
					currentWin.removeChild(changeBox);
					changeBox.changeSize(dragShape);
					currentWin.addChild(changeBox);
					break;
				}
				case OPERATE_STATE_NONE:
				{
					break;
				}
				default:
					break;
				
			}
		}
		
		//整理图形关系
		public function trimShapes():void
		{
			var len:Number;
			var i:Number;
			var tempShape:BaseShape;
			//整理图形顺序
			var copyShape:ArrayCollection=new ArrayCollection();
			len=this.shapes.length;
			
			//连线
			for(i=0; i < len; i++)
			{
				tempShape=shapes.getItemAt(i)as BaseShape;
				if (tempShape is BaseLineShape)
				{
					copyShape.addItem(tempShape);
				}
			}
			//泳道放到
			for(i=0; i < len; i++)
			{
				tempShape=shapes.getItemAt(i)as BaseShape;
				if (tempShape is LaneShape)
				{
					copyShape.addItem(tempShape);
				}
			}
			
			//图形保存在最上面
			for(i=0; i < len; i++)
			{
				tempShape=shapes.getItemAt(i)as BaseShape;
				if (!(tempShape is LaneShape) && !(tempShape is BaseLineShape))
				{
					copyShape.addItem(tempShape);
				}
			}
			
			this.shapes=copyShape;
		}
		
		/**
		 * 重新组织当前的界面
		 */
		public function updateUI(shape:BaseDataShape):void
		{
			if (shape == null)
			{
				return ;
			}
			var sh:BaseShape=null;
			for(var i:Number=0; i < shapes.length; i++)
			{
				sh=shapes.getItemAt(i)as BaseShape;
				if (sh.equals(shape))
				{
					currentWin.removeChild(sh);
					shapes.removeItemAt(i);
					break;
				}
			}
			updateContrl(shape);
		}
		
		/**
		 * 更新界面控件信息
		 */
		private function updateContrl(shape:BaseDataShape):void
		{
			currentWin.removeChild(selectBox);
			var sh:BaseShape;
			for each(sh in shapes)
			{
				if (!currentWin.contains(sh))
				{
					continue;
				}
				currentWin.removeChild(sh);
			}
			//整理图形
			trimShapes();
			//重新
			for each(sh in shapes)
			{
				currentWin.addChild(sh);
			}
			//添加新建的图形
			shapes.addItem(shape);
			currentWin.addChild(shape);
			//选择框
			currentWin.addChild(selectBox);
			
			shape.repaint();
			if (shape.drag)
			{
				//初始化
				shape.addEventListener(MouseEvent.MOUSE_MOVE, shapeDragMove);
				shape.addEventListener(MouseEvent.MOUSE_UP, shapeMouseUpHandle);
				shape.addEventListener(MouseEvent.MOUSE_OUT, shapeMouseOutHandle);
				
				shape.addEventListener(MouseEvent.MOUSE_MOVE, drawLineMouseOverShape);
				shape.addEventListener(MouseEvent.MOUSE_OUT, drawLineMouseLeavelShape);
				//控制点
				BaseStateShape(shape).addConnectionBoxLisenner(drawLineMouseOverShape, drawLineMouseLeavelShape);
			}
		}
		
		/**
		 * 清空所有的选中
		 */
		public function clearSelect():void
		{
			for each(var shape:BaseDataShape in shapes)
			{
				if (!shape.select)
				{
					continue;
				}
				shape.select=false;
			}
			
			if (currentSelectedControlCompShape != null)
			{
				currentSelectedControlCompShape.select=false;
			}
		}
		
		
		/**
		 * 创建线条的action
		 * @param event
		 *
		 */
		public function createLineShapeAction(event:LineShapeButtonEvent):void
		{
			//改变鼠标的样式
			
			
			//改变划线类型
			currentLineType=event.shapeType;
			//将当前操作的状态改为划线
			operateState=OPERATE_STATE_DRAWLINE;
		}
		
		/**
		 * 创建图形
		 * @param event
		 *
		 */
		public function createShape(event:MouseEvent, type:String, shapeType:Number):void
		{
			if (!event.buttonDown)
			{
				return ;
			}
			
			CursorManager.removeAllCursors();
			CursorManager.showCursor();
			DragManager.showFeedback(DragManager.COPY);
			
			var ds:DragSource=new DragSource();
			var factory:ShapeCompFactory=ShapeCompFactory.getInstance();
			var shape:BaseStateShape=BaseStateShape(factory.createShape(shapeType));
			
			shape.x=mouseX + 1;
			shape.y=mouseY + 1;
			shape.model=BaseDataShape.MODEL_PREVIEW;
			shape.select=false;
			shape.repaint();
			
			operateState=OPERATE_STATE_ADD;
			ds.addData(shape, "shape");
			DragManager.doDrag(this, ds, event, shape);
			
			//
			clearSelect();
		}
		
		
		/**
		 * 画线
		 */
		private function drawLineAction():void
		{
			var shape:BaseDataShape=isContainerShape();
			if (currentLine == null)
			{
				return ;
			}
			if (shape == null)
			{
				removeErrorLine();
				return ;
			}
			
			if (!shape.connection)
			{
				removeErrorLine();
				return ;
			}
			
			if (shape.equals(currentLine.startShape))
			{
				removeErrorLine();
				return ;
			}
			
			currentLine.endShape=BaseStateShape(shape);
			
			currentLine.startShape.contrlLines();
			currentLine.endShape.contrlLines();
			
			if (!shapes.contains(currentLine))
			{
				shapes.addItem(currentLine);
			}
			
			undoManager.addCmd(shapes);
			currentLine=null;
		}
		
		/**
		 * 移除没有连接的线条
		 */
		private function removeErrorLine():void
		{
			if (currentWin.contains(currentLine))
			{
				currentWin.removeChild(currentLine);
			}
			ArrayCollectionUtil.remove(currentLine, shapes);
			
			if (currentLine.startShape != null)
			{
				currentLine.startShape.removeLine(currentLine);
			}
			
			if (currentLine.endShape != null)
			{
				currentLine.endShape.removeLine(currentLine);
			}
		}
		
		/**
		 * 恢复默认鼠标
		 */
		public function resetDefaultOperate():void
		{
			operateState=OPERATE_STATE_NONE;
		}
		
		public function get selectAll():Boolean
		{
			return _selectAll;
		}
		
		/**
		 * 全选和全不选
		 * @param value
		 *
		 */
		public function set selectAll(value:Boolean):void
		{
			_selectAll=value;
			
			if (value)
			{
				operateState=OPERATE_STATE_SELECTALL;
			}
			else
			{
				operateState=OPERATE_STATE_NONE;
			}
			
			for each(var shape:BaseDataShape in shapes)
			{
				shape.select=value;
			}
		}
		
		
		/**
		 * 删除选中状态的图形
		 * @param event
		 *
		 */
		public function deleteSelectShape(event:Event):void
		{
			//整理图形顺序
			trimShapes();
			var shape:BaseDataShape=null;
			var shapeLines:ArrayCollection=null;
			var i:Number;
			var size:Number=shapes.length;
			while(true)
			{
				i=size - 1;
				if (size <= 0)
				{
					break;
				}
				shape=shapes.getItemAt(i)as BaseDataShape;
				if (!shape.select)
				{
					size--;
					continue;
				}
				//线条不能现在删除 在图形后面删除
				if (shape is BaseLineShape)
				{
					(BaseLineShape(shape)).startShape.removeLine(BaseLineShape(shape));
					(BaseLineShape(shape)).endShape.removeLine(BaseLineShape(shape));
					removeChild(shape);
					shapes.removeItemAt(i);
					selectBox.removeShape(shape);
					
					shape=null;
					break;
				}
				//删除图形
				removeChild(shape);
				shapes.removeItemAt(i);
				selectBox.removeShape(shape);
				//删除图形的连线
				shapeLines=BaseStateShape(shape).getAllLine();
				for each(var line:BaseLineShape in shapeLines)
				{
					if (contains(line))
					{
						removeChild(line);
					}
					selectBox.removeShape(line);
					ArrayCollectionUtil.remove(line, shapes);
				}
				
				//重新获取长度
				size=shapes.length;
			}
			undoManager.addCmd(shapes);
			currentSelectShape=null;
		}
		
		public function get save():Boolean
		{
			return _save;
		}
		
		public function set save(value:Boolean):void
		{
			_save=value;
		}
		
		override public function set shapes(value:ArrayCollection):void
		{
			super.shapes=value;
		}
		
		public function resetShape(resetShape:ArrayCollection):void
		{
			/*
			首先销毁所有以前的图形，然后重新添加新的图形
			*/
			var shape:BaseDataShape;
			for each(shape in shapes)
			{
				removeChild(shape);
			}
			
			shapes.removeAll();
			invalidateDisplayList();
			
			if (resetShape == null)
			{
				save=false;
				return ;
			} 
			var obj:Object=null; 
			//添加
			for each(obj in resetShape)
			{
				trace(obj);
				shape=BaseDataShape(obj);
				updateUI(shape);
			}
			//重新建立关系
			for(var i:int = shapes.length - 1 ; i >=0 ; i--) 
			{
				shape = shapes.getItemAt(i) as BaseDataShape;
				if (!(shape is BaseLineShape))
				{
					shape.select = true;
					continue;
				}
				BaseLineShape(shape).autoRelation(shapes);
				if(BaseLineShape(shape).startShape != null && BaseLineShape(shape).endShape != null){
					shape.select = true;
					continue;	
				}
			}
			save=false;
			invalidateDisplayList();
		}
		
		//V.2.3 添加的内容
		
		//当操作状态为划线的时候，鼠标划过图形
		private function drawLineMouseOverShape(event:MouseEvent):void
		{
			trace("]]]]]]]]]]]]]]]]]]]");
			if (operateState != OPERATE_STATE_DRAWLINE)
			{
				return ;
			}
			var shape:BaseShape=event.currentTarget as BaseShape;
			if (!(shape is BaseStateShape))
			{
				shape.lineCursor=true;
				event.stopPropagation();
				return ;
			}
			
			//如果是要操作的图形
			shape.lineCursor=BaseStateShape(shape).containCenter();
			event.stopPropagation();
			selectLineCursor();
		}
		
		//当操作状态为划线的时候，鼠标离开图形
		private function drawLineMouseLeavelShape(event:MouseEvent):void
		{
			trace("....////////");
			if (operateState != OPERATE_STATE_DRAWLINE)
			{
				return ;
			}
			var shape:BaseShape=event.currentTarget as BaseShape;
			shape.lineCursor=false;
			event.stopPropagation();
			selectLineCursor();
		}
		
		private function clearLineCursor(shape:BaseDataShape):void
		{
			for each(var s:BaseDataShape in shapes)
			{
				if (s is BaseLineShape)
				{
					continue;
				}
				if (s.equals(shape))
				{
					s.lineCursor=true;
					continue;
				}
				if (s.lineCursor)
				{
					s.lineCursor=false;
				}
			}
		}
		
		private function selectLineCursor():void
		{
			if (operateState != OPERATE_STATE_DRAWLINE)
			{
				return ;
			}
			for each(var s:BaseDataShape in shapes)
			{
				if (s is BaseLineShape)
				{
					continue;
				}
				if (new Rectangle(0, 0, s.width, s.height).contains(s.mouseX, s.mouseY))
				{
					s.lineCursor=true;
					continue;
				}
				if (s.lineCursor)
				{
					s.lineCursor=false;
				}
			}
		}
		
	}
}

