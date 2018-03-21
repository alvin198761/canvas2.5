package com.print.bean.shape.datashape
{
	import com.print.bean.shape.BaseShape;
	import com.print.bean.shape.ShapeCompFactory;
	import com.print.bean.shape.contr.BaseContrShape;
	import com.print.bean.shape.contr.LineConnectionContrBox;
	import com.print.bean.shape.datashape.line.BaseLineShape;
	import com.print.comp.editor.TextEdtor;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	
	/**
	 *带数据的图形的父类
	 *
	 */
	public class BaseDataShape extends BaseShape
	{
		/**分辨率*/
		public var resolution:Number=Capabilities.screenDPI;
		//预览
		public static const MODEL_PREVIEW:String="preview";
		//画图
		public static const MODEL_DRAW:String="draw";
		
		//最小的宽度和高度
		public static const MIX_WIDHT:Number=20;
		public static const MIX_HEIGHT:Number=15;
		
		protected var edtor:TextEdtor;
		//显示文本的编辑框
		protected var _model:String=MODEL_DRAW;
		//预览模式 还是编辑模式
		protected var _changeSize:Boolean=true;
		//是否可以改变大小
		protected var _editabel:Boolean;
		//是否可编辑
		protected var _contrl:Boolean;
		//是否可以控制
		protected var _connection:Boolean;
		//是否能够连线
		protected var _drag:Boolean;
		//是否可以拖动
		//线的控制点
		public var leftLineConnection:LineConnectionContrBox;
		public var rightLineConnection:LineConnectionContrBox;
		public var topLineConnection:LineConnectionContrBox;
		public var bottomLineConnection:LineConnectionContrBox;
		//保存改变大小的控制点的Map集合
		protected var changeSizeMap:Object=new Object();
		//保存连线的Map集合
		protected var lineConnectionMap:Object=new Object();
		
		public function BaseDataShape()
		{
			edtor=new TextEdtor();
			this.rawChildren.addChild(edtor);
			
		}
		
		/**
		 *初始化控制器
		 *
		 */
		protected function initContrBox():void
		{
			//如果是预览模式 则不需要控制点和连线的指示点
			if (model == MODEL_PREVIEW)
			{
				
				if (connection)
				{
					if (leftLineConnection != null)
					{
						this.rawChildren.removeChild(leftLineConnection);
					}
					if (rightLineConnection != null)
					{
						this.rawChildren.removeChild(rightLineConnection);
					}
					if (topLineConnection != null)
					{
						this.rawChildren.removeChild(topLineConnection);
					}
					if (bottomLineConnection != null)
					{
						this.rawChildren.removeChild(bottomLineConnection);
					}
					
					lineConnectionMap[BaseContrShape.WAY_LEFT]=null;
					lineConnectionMap[BaseContrShape.WAY_RIGHT]=null;
					lineConnectionMap[BaseContrShape.WAY_TOP]=null;
					lineConnectionMap[BaseContrShape.WAY_BOTTOM]=null;
					
					leftLineConnection=null;
					rightLineConnection=null;
					topLineConnection=null;
					bottomLineConnection=null;
				}
				return ;
			}
			
			if (connection)
			{
				leftLineConnection=new LineConnectionContrBox(BaseContrShape.WAY_LEFT, this);
				rightLineConnection=new LineConnectionContrBox(BaseContrShape.WAY_RIGHT, this);
				topLineConnection=new LineConnectionContrBox(BaseContrShape.WAY_TOP, this);
				bottomLineConnection=new LineConnectionContrBox(BaseContrShape.WAY_BOTTOM, this);
				
				lineConnectionMap[BaseContrShape.WAY_LEFT]=leftLineConnection;
				lineConnectionMap[BaseContrShape.WAY_RIGHT]=rightLineConnection;
				lineConnectionMap[BaseContrShape.WAY_TOP]=topLineConnection;
				lineConnectionMap[BaseContrShape.WAY_BOTTOM]=bottomLineConnection;
				
				this.rawChildren.addChild(leftLineConnection);
				this.rawChildren.addChild(rightLineConnection);
				this.rawChildren.addChild(topLineConnection);
				this.rawChildren.addChild(bottomLineConnection);
			}
			
			
			repaint();
		}
		
		/**
		 * 根据控制点的方位 返回控制点的坐标点
		 * @param way
		 * @return
		 *
		 */
		public function getPositionByWay(way:String):Point
		{
			var p:Point=null;
			switch(way)
			{
				case BaseContrShape.WAY_LEFT:
				{
					p=getLeftPoint();
					break;
				}
				case BaseContrShape.WAY_RIGHT:
				{
					p=getRightPoint();
					break;
				}
				case BaseContrShape.WAY_TOP:
				{
					p=getTopPoint();
					break;
				}
				case BaseContrShape.WAY_BOTTOM:
				{
					p=getBottomPoint();
					break;
				}
				default:
				{
					trace("方向不明");
					break;
				}
			}
			return p;
		}
		
		public function get drag():Boolean
		{
			return _drag;
		}
		
		public function set drag(value:Boolean):void
		{
			_drag=value;
		}
		
		public function get connection():Boolean
		{
			return _connection;
		}
		
		public function set connection(value:Boolean):void
		{
			_connection=value;
		}
		
		public function get contrl():Boolean
		{
			return _contrl;
		}
		
		public function set contrl(value:Boolean):void
		{
			_contrl=value;
		}
		
		public function get editabel():Boolean
		{
			return _editabel;
		}
		
		public function set editabel(value:Boolean):void
		{
			_editabel=value;
		}
		
		public function get model():String
		{
			return _model;
		}
		
		public function set model(value:String):void
		{
			_model=value;
			initContrBox();
		}
		
		public function get text():String
		{
			return edtor.text;
		}
		
		public function set text(value:String):void
		{
			edtor.text=value;
			edtor.toolTip=value;
		}
		
		/**
		 * toString 方法
		 * @return
		 *
		 */
		override public function toString():String
		{
			return this.text + "(" + this.timeId + ")";
		}
		
		/**
		 * 克隆对象
		 * @param source
		 * @return
		 *
		 */ 
		//简单克隆图形的属性
		public static function cloneShape(shape:BaseDataShape):BaseDataShape
		{
			var factory:ShapeCompFactory=ShapeCompFactory.getInstance();
			var newShape:BaseDataShape=factory.createShape(shape.type);
			newShape.x=shape.x;
			newShape.y=shape.y;
			newShape.width=shape.width;
			newShape.height=shape.height;
			newShape.text=shape.text;
			return newShape;
		}
		
		/**
		 * 清空连线管理器的选中
		 */
		public function clearLineControlSelect():void
		{
			if (!connection)
			{
				return ;
			}
			leftLineConnection.select=false;
			rightLineConnection.select=false;
			topLineConnection.select=false;
			bottomLineConnection.select=false;
		}
		
		//控制左边
		public function contrlLeft(event:MouseEvent, subX:Number, subY:Number):void
		{
			if (!_changeSize)
			{
				return ;
			}
			var x2:Number=this.x + this.width;
			var x3:Number=this.parent.mouseX;
			if (x2 - x3 > MIX_WIDHT)
			{
				this.x+=subX;
				this.width=x2 - this.x;
				repaint();
			}
		}
		
		//控制右边
		public function contrlRight(event:MouseEvent, subX:int, subY:int):void
		{
			if (!_changeSize)
			{
				return ;
			}
			this.width+=subX;
			repaint();
		}
		
		//控制顶部
		public function controlTop(event:MouseEvent, subX:int, subY:int):void
		{
			if (!_changeSize)
			{
				return ;
			}
			var y2:Number=this.y + this.height;
			var y3:Number=this.parent.mouseY;
			if (y2 - y3 > MIX_HEIGHT)
			{
				this.y+=subY;
				this.height=y2 - this.y;
				repaint();
			}
		}
		
		//控制底部
		public function controlBottom(event:MouseEvent, subX:int, subY:int):void
		{
			if (!_changeSize)
			{
				return ;
			}
			this.height+=subY;
			repaint();
		}
		
		/**
		 * 线条的管理和控制
		 */
		public function contrlLines():void
		{
			if (!connection)
			{
				return ;
			}
			leftLineConnection.doContrl();
			rightLineConnection.doContrl();
			topLineConnection.doContrl();
			bottomLineConnection.doContrl();
		}
		
		/**
		 * 添加线条
		 * @param line
		 *
		 */
		public function addLine(line:BaseLineShape):void
		{
			if (leftLineConnection.select)
			{
				leftLineConnection.addLine(line);
			}
			else if (rightLineConnection.select)
			{
				rightLineConnection.addLine(line);
			}
			else if (topLineConnection.select)
			{
				topLineConnection.addLine(line);
			}
			else
			{
				bottomLineConnection.addLine(line);
			}
		}
		
		public function addLineAt(way:String, line:BaseLineShape):void
		{
			LineConnectionContrBox(lineConnectionMap[way]).addLine(line);
		}
		
		/**
		 *删除线条
		 * @param line
		 *
		 */
		public function removeLine(line:BaseLineShape):void
		{
			leftLineConnection.removeLine(line);
			rightLineConnection.removeLine(line);
			topLineConnection.removeLine(line);
			bottomLineConnection.removeLine(line);
		}
		
		/*
		*triangleArea1 和  inTriangle 方法主要是将图形分成4个区域，用来控制连线后的位置
		*/
		private function triangleArea1(pos1:Point, pos2:Point, pos3:Point):Number
		{
			var result:Number=Math.abs((pos1.x * pos2.y + pos2.x * pos3.y + pos3.x * pos1.y - pos2.x * pos1.y - pos3.x * pos2.y - pos1.x * pos3.y) >> 1);
			return result;
		}
		
		/**
		 * 判断鼠标点击pos的位置是否在一个三角形中
		 * @param pos
		 * @param posA
		 * @param posB
		 * @param posC
		 * @return
		 *
		 */
		protected function inTriangle(pos:Point, posA:Point, posB:Point, posC:Point):Boolean
		{
			var triangleArea:Number=triangleArea1(posA, posB, posC);
			var area:Number=triangleArea1(pos, posA, posB);
			area+=triangleArea1(pos, posA, posC);
			area+=triangleArea1(pos, posB, posC);
			var epsilon:Number=0.0001;
			// 由于浮点数的计算存在着误差，故指定一个足够小的数，用于判定两个面积是否(近似)相等。
			return Math.abs(triangleArea - area) < epsilon;
		}
		
		/**
		 * 是否已到了该图形的某个方位
		 * @return
		 *
		 */
		public function containerPosition():LineConnectionContrBox
		{
			if (!connection)
			{
				return null;
			}
			leftLineConnection.select=false;
			rightLineConnection.select=false;
			topLineConnection.select=false;
			bottomLineConnection.select=false;
			
			var pos:Point=new Point(mouseX, mouseY);
			var pc:Point=getMiddlePoint();
			var pa:Point=new Point();
			var pb:Point=new Point();
			//left
			pa.x=0;
			pa.y=0;
			
			pb.x=0;
			pb.y=height;
			
			if (inTriangle(pos, pa, pb, pc))
			{
				leftLineConnection.select=true;
				return leftLineConnection;
			}
			
			//right
			pa.x=width;
			pa.y=0;
			
			pb.x=width;
			pb.y=height;
			
			if (inTriangle(pos, pa, pb, pc))
			{
				rightLineConnection.select=true;
				return rightLineConnection;
			}
			//top
			pa.x=0;
			pa.y=0;
			
			pb.x=width;
			pb.y=0;
			
			if (inTriangle(pos, pa, pb, pc))
			{
				topLineConnection.select=true;
				return topLineConnection;
			}
			
			bottomLineConnection.select=true;
			return bottomLineConnection;
		}
		
		
		/**
		 *释放内存
		 */
		public function dispose():void
		{
			
			rawChildren.removeChild(edtor);
			
			if (connection)
			{
				this.rawChildren.removeChild(leftLineConnection);
				this.rawChildren.removeChild(rightLineConnection);
				this.rawChildren.removeChild(topLineConnection);
				this.rawChildren.removeChild(bottomLineConnection);
			}
			
			removeAllChildren();
			
			changeSizeMap=null;
			lineConnectionMap=null;
			
			leftLineConnection=null;
			rightLineConnection=null;
			topLineConnection=null;
			bottomLineConnection=null;
			
			edtor=null;
		}
		
		
		public function getMiddlePoint():Point
		{
			return new Point(width >> 1, height >> 1);
		}
		
		override public function set height(value:Number):void
		{
			if (value < MIX_HEIGHT)
			{
				value=MIX_HEIGHT;
			}
			edtor.height=value;
			super.height=value;
		}
		
		override public function set width(value:Number):void
		{
			if (value < MIX_WIDHT)
			{
				value=MIX_WIDHT;
			}
			edtor.width=value;
			super.width=value;
		}
		
		public function get changeSize():Boolean
		{
			return _changeSize;
		}
		
		public function set changeSize(value:Boolean):void
		{
			_changeSize=value;
		}
		
	}
}

