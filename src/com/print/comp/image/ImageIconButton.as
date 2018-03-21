package com.print.comp.image
{
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import com.print.util.DrawBoardUtil;
	import flash.events.Event;
	import mx.controls.Image;
	
	public class ImageIconButton extends Image
	{
		private var _enableIcon:String;
		private var _disAbleIcon:String;
		private var _hasStyle:Boolean = true;
		
		public function ImageIconButton()
		{
			super();
			useHandCursor=false;
			addEventListener(MouseEvent.MOUSE_OVER, playEffect);
			addEventListener(MouseEvent.MOUSE_OUT, stopEffect);
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled=value;
			useHandCursor=value;
			if (enableIcon == null)
			{
				return ;
			}
			if (value)
			{
				source=disAbleIcon;
				return ;
			}
			source=enableIcon;
		}
		
		/**
		 * play effect
		 * */
		protected function playEffect(event:MouseEvent):void
		{
			var img:Image=event.currentTarget as Image;
			if (img.enabled)
			{
				highlightImage(img);
			}
		}
		
		/**
		 * high light image
		 * */
		private function highlightImage(img:Image):void
		{
			img.filters=[getBitmapFilter()];
			img.x-=1;
			img.y-=1;
		}
		
		/**
		 * get filter
		 * */
		private function getBitmapFilter():BitmapFilter
		{
			var color:Number=0x000000;
			var angle:Number=45;
			var alpha:Number=0.8;
			var blurX:Number=2;
			var blurY:Number=2;
			var distance:Number=2;
			var strength:Number=0.65;
			var inner:Boolean=false;
			var knockout:Boolean=false;
			var quality:Number=BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		/**
		 * stop effect
		 * */
		protected function stopEffect(event:MouseEvent):void
		{
			var img:Image=event.currentTarget as Image;
			if (img.enabled)
			{
				img.filters=[];
				img.x+=1;
				img.y+=1;
			}
		}
		
		public function get disAbleIcon():String
		{
			return _disAbleIcon;
		}
		
		public function set disAbleIcon(value:String):void
		{
			_disAbleIcon=value;
			if (enabled)
			{
				source=value;
			}
		}
		
		public function get enableIcon():String
		{
			return _enableIcon;
		}
		
		public function set enableIcon(value:String):void
		{
			_enableIcon=value;
			if (!enabled)
			{
				source=value;
			}
		}
	}
}

