package com.print.io
{
	import com.print.action.UpOrDownLoad;
	import com.print.bean.shape.BaseShape;
	import com.print.bean.shape.ShapeCompFactory;
	import com.print.bean.shape.ShapeTypeHelper;
	import com.print.bean.shape.contr.BaseContrShape;
	import com.print.bean.shape.datashape.BaseDataShape;
	import com.print.bean.shape.datashape.line.BaseLineShape;
	import com.print.bean.shape.datashape.state.LaneShape;
	import com.print.util.AlertUtil;
	
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * xml操作类
	 * @author 唐植超
	 *
	 */
	public class XMLOperate
	{
		
		public function XMLOperate(obj:Singleton)
		{
		}
		
		private static var instance:XMLOperate;
		
		public static function getInstance():XMLOperate
		{
			if (instance == null)
			{
				instance=new XMLOperate(new Singleton());
			}
			return instance;
		}
		
		/**
		 * vkd解析
		 * @return
		 *
		 */
		public function vkdToShapes(data:Object, model:String):ArrayCollection
		{
			var shapeList:ArrayCollection=new ArrayCollection();
			var xml:XML=XML(data);
			var xmlList:XMLList;
			var type:int;
			var shape:BaseDataShape;
			var childList:XMLList;
			try
			{
				if (xml == null)
				{
					return shapeList;
				}
				xmlList=xml.child("IShape");
				for each(var item:XML in xmlList)
				{
					shape=ShapeCompFactory.getInstance().createShape(Number(item.attribute("type")));
					shape.timeId=item.child("shape_id").text();
					shape.text=item.child("shape_text").text();
					childList=item.child("mainShape");
					if (shape is BaseLineShape)
					{
						var line:BaseLineShape=BaseLineShape(shape);
						
						childList=childList.child("mline");
						line.startX=childList.attribute("line_x1");
						line.startY=childList.attribute("line_y1");
						line.endX=Number(childList.attribute("line_x2"));
						line.endY=Number(childList.attribute("line_y2"));
						shape=line;
					}
					else
					{
						shape.x=childList.child("mainShape_x").text();
						shape.y=childList.child("mainShape_y").text();
						shape.width=childList.child("mainShape_width").text();
						shape.height=childList.child("mainShape_height").text();
					}
					if (shape.width > 0)
					{
						shape.x-=2;
						shape.width+=BaseContrShape.DEFAULT_WIDTH;
					}
					else
					{
						shape.x+=2;
						shape.width-=BaseContrShape.DEFAULT_WIDTH;
					}
					
					if (shape.height > 0)
					{
						shape.y-=2;
						shape.height+=BaseContrShape.DEFAULT_HEIGHT;
					}
					else
					{
						shape.y+=2;
						shape.height-=BaseContrShape.DEFAULT_HEIGHT;
					}
					shape.model=model;
					shapeList.addItem(shape);
				}
				return shapeList;
			}
			catch(error:Error)
			{
				AlertUtil.showInfo(error.message + "");
			}
			return shapeList;
		}
		
		/**
		 * 将图转成vkd
		 * @param shapes
		 *
		 */
		public function shapeToVkd(shapes:ArrayCollection):String
		{
			try
			{
				var len:int=shapes.length;
				var i:int;
				var shape:BaseDataShape;
				var xmlDoc:XMLDocument=new XMLDocument();
				var xmlContent:String=new String();
				var sx:int, sy:int, sw:int, sh:int;
				xmlContent=xmlContent.concat("<IShapeXMLData");
				xmlContent=xmlContent.concat(" version = '1.0.0.0'")
				xmlContent=xmlContent.concat(" resolution = '" + Capabilities.screenDPI);
				xmlContent=xmlContent.concat("'>");
				for(i=0; i < len; i++)
				{
					shape=shapes.getItemAt(i)as BaseDataShape;
					xmlContent=xmlContent.concat("\r\n\t");
					//单个图形节点
					xmlContent=xmlContent.concat("<IShape type = '" + shape.type + "'>");
					xmlContent=xmlContent.concat("\r\n\t\t");
					xmlContent=xmlContent.concat("<shape_id>" + shape.timeId + "</shape_id>");
					xmlContent=xmlContent.concat("\r\n\t\t");
					xmlContent=xmlContent.concat("<shape_text>" + shape.text + "</shape_text>");
					xmlContent=xmlContent.concat("\r\n\t\t");
					xmlContent=xmlContent.concat("<mainShape>");
					xmlContent=xmlContent.concat("\r\n\t\t\t");
					var x:int, y:int, w:int, h:int;
					if (shape.width > 0)
					{
						x=shape.x + 2;
						w=shape.width - 4;
					}
					else
					{
						x=shape.x - 2;
						w=shape.width + 4;
					}
					
					if (shape.height > 0)
					{
						y=shape.y + 2;
						h=shape.height - 4;
					}
					else
					{
						y=shape.y - 2;
						h=shape.height + 4;
					}
					if (shape is BaseLineShape)
					{
						var line:BaseLineShape=BaseLineShape(shape);
						x=line.startX;
						y=line.startY;
						
						w=line.endX;
						h=line.endY;
						
						xmlContent=xmlContent.concat("<mline ");
						xmlContent=xmlContent.concat("line_x1='" + x + "' ");
						xmlContent=xmlContent.concat("line_x2='" + w + "' ");
						xmlContent=xmlContent.concat("line_y1='" + y + "' ");
						xmlContent=xmlContent.concat("line_y2='" + h + "'>");
						xmlContent=xmlContent.concat("</mline>");
					}
					else
					{
						xmlContent=xmlContent.concat("<mainShape_x>" + x + "</mainShape_x>");
						xmlContent=xmlContent.concat("\r\n\t\t\t");
						xmlContent=xmlContent.concat("<mainShape_y>" + y + "</mainShape_y>");
						xmlContent=xmlContent.concat("\r\n\t\t\t");
						xmlContent=xmlContent.concat("<mainShape_width>" + w + "</mainShape_width>");
						xmlContent=xmlContent.concat("\r\n\t\t\t");
						var height:Number=shape.height;
						if (shape is LaneShape)
						{
							height=LaneShape.DEFAULT_HEIGHT;
						}
						h=height;
						xmlContent=xmlContent.concat("<mainShape_height>" + h + "</mainShape_height>");
					}
					xmlContent=xmlContent.concat("\r\n\t\t");
					xmlContent=xmlContent.concat("</mainShape>");
					xmlContent=xmlContent.concat("\r\n\t");
					xmlContent=xmlContent.concat("</IShape>");
				}
				xmlContent=xmlContent.concat("\r\n");
				xmlContent=xmlContent.concat("</IShapeXMLData>");
				xmlDoc.parseXML(xmlContent);
				
				var outputString:String="<?xml version='1.0' encoding='utf-8'?>\r\n"
				
				return outputString + xmlDoc.toString();
			}
			catch(error:Error)
			{
				AlertUtil.showInfo(error.message + "");
			}
			return "";
		}
	}
}

class Singleton
{
}

