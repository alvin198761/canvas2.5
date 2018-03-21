package com.print.bean.shape.gui
{
	import com.print.bean.shape.BaseShape;
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.util.ArrayCollectionUtil;
	
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 选择框
	 */
	public class SelectBox extends BaseGUI
	{
		public static const STATE_DRAW:String="draw";
		public static const STATE_OPER:String="operate";
		private var _shapes:ArrayCollection=new ArrayCollection();
		private var _state:String=STATE_DRAW;
		
		public function SelectBox()
		{
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state=value;
		}
		
		override protected function paintComponent():void
		{
			graphics.clear();
			if (x <= 0 || y <= 0)
			{
				return ;
			}
			graphics.beginFill(0x999999);
			graphics.endFill();
			graphics.lineStyle(2, 0x00ff00);
			graphics.drawRect(0, 0, this.width, this.height);
			if (_state == STATE_DRAW)
			{
				
			}
			else if (_state == STATE_OPER)
			{
				
			}
			
		}
		
		public function hide():void
		{
			this.x=0;
			this.y=0;
			this.width=0;
			this.height=0;
			repaint();
		}
		
		public function addShape(shape:Object):void
		{
			if (_shapes.contains(shape))
			{
				return ;
			}
			this._shapes.addItem(shape);
		}
		
		public function removeShape(shape:Object):void
		{
			ArrayCollectionUtil.remove(shape, _shapes);
		}
		
		public function cleanSelectShapes():void
		{
			var i:int;
			var len:int=_shapes.length;
			var shape:BaseShape;
			for(i=len - 1; i >= 0; i--)
			{
				BaseShape(_shapes.getItemAt(i)).select=false;
			}
			
			_shapes.removeAll();
		}
		
		public function clean():void
		{
			_shapes.removeAll();
		}
		
		public function indexOf(shape:Object):int
		{
			var i:int;
			var len:int=_shapes.length;
			for(i=len - 1; i >= 0; i--)
			{
				if (_shapes.getItemAt(i).equals(shape))
				{
					return i;
				}
			}
			return -1;
		}
		
		public function containsShape(shape:Object):Boolean
		{
			return indexOf(shape) != -1;
		}
		
		public function shapeSize():int
		{
			return _shapes.length;
		}
		
		public function selectAll():void
		{
			var len:int=_shapes.length;
			var i:int;
			for(i=0; i < len; i++)
			{
				_shapes.getItemAt(i).setSelect=true;
			}
		}
		
		public function get shapes():ArrayCollection
		{
			return _shapes;
		}
		
		override public function set height(value:Number):void
		{
			super.height=value;
			repaint();
		}
		
		override public function set width(value:Number):void
		{
			super.width=value;
			repaint();
		}
		
		override public function getBox():Rectangle
		{
			var bx:Number=x;
			;
			var by:Number=y;
			var bw:Number=width;
			var bh:Number=height;
			
			var box:Rectangle=new Rectangle();
			if (bw > 0)
			{
				box.x=bx;
			}
			else
			{
				box.x=bx + bw;
			}
			
			if (bh > 0)
			{
				box.y=by;
			}
			else
			{
				box.y=by + bh;
			}
			
			box.width=Math.abs(bw);
			box.height=Math.abs(bh);
			
			return box;
		}
		
	}
}

