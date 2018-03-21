package com.print.util
{
	import mx.collections.ArrayCollection;
	
	public class ArrayCollectionUtil
	{
		
		public function ArrayCollectionUtil()
		{
		}
		
		
		/**
		 * 添加集合
		 * @param oldList
		 * @param addList
		 *
		 */
		public static function addAllData(oldList:mx.collections.ArrayCollection, addList:mx.collections.ArrayCollection):void
		{
			for each(var obj:Object in addList)
			{
				oldList.addItem(obj);
			}
		}
		
		/**
		 * 删除元素
		 * @param item
		 * @param list
		 * @return
		 *
		 */
		public static function remove(item:Object, list:ArrayCollection):Object
		{
			var i:Number;
			var len:Number=list.length;
			for(i=len - 1; i >= 0; i--)
			{
				if (item == list.getItemAt(i))
				{
					list.removeItemAt(i);
					return item;
				}
			}
			return null;
		}
	}
}

