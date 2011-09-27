package com.jxl.zombiestick.services
{
	import com.adobe.serialization.json.JSON;
	import com.jxl.zombiestick.events.SaveLevelServiceEvent;
	import com.jxl.zombiestick.vo.GameObjectVO;
	import com.jxl.zombiestick.vo.LevelVO;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class SaveLevelService extends EventDispatcher
	{
		private var str:String;
		private var file:File;
		private var stream:FileStream;
		private var level:LevelVO;
		
		public function SaveLevelService()
		{
			super();
		}
		
		public function saveLevel(level:LevelVO):void
		{
			this.level = level;
			
			if(file == null)
			{
				file = new File();
				file.addEventListener(IOErrorEvent.IO_ERROR, onFileError);
				file.addEventListener(Event.SELECT, onFileSelect);
			}
			
			try
			{
				file.browseForSave("Save");
			}
			catch(err:Error)
			{
				trace("SaveLevelService::file error: " + err);
			}
		}
		
		private function onFileError(event:IOErrorEvent):void
		{
			trace("SaveLevelService::onFileError: " + event);
		}
		
		private function onFileSelect(event:Event):void
		{
			copyImages();
			
			var obj:Object;
			try
			{
				obj = level.toObject();
			}
			catch(err:Error)
			{
				trace("SaveLevelService::object parsing error: " + err);
				return;
			}
			
			try
			{
				str = JSON.encode(obj);
			}
			catch(err:Error)
			{
				trace("SaveLevelService::JSON encoding error: " + err);
				return;
			}
			
			if(stream == null)
			{
				stream = new FileStream();
			}
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(str);
			stream.close();
			dispatchEvent(new SaveLevelServiceEvent(SaveLevelServiceEvent.SUCCESS));
		}
		
		private function copyImages():void
		{
			level.levelDirectory = file.url;
			var len:int = level.events.length;
			var imageFile:File;
			var newImageFile:File;
			while(len--)
			{
				var obj:Object = level.events[len];
				if(obj is GameObjectVO)
				{
					var gameObject:GameObjectVO = obj as GameObjectVO;
					if(gameObject.image != null && gameObject.image.length > 0 && gameObject.imageRelativeToLevelPath == false)
					{
						imageFile = new File();
						imageFile.url = gameObject.image;
						
						newImageFile = new File();
						newImageFile.url = file.url.substring(0, file.url.lastIndexOf("/")) + "/";
						newImageFile = newImageFile.resolvePath(imageFile.name);
						
						try
						{
							if(newImageFile.exists == false)
							{
								imageFile.copyTo(newImageFile, false);
							}
							gameObject.image = newImageFile.url;
						}
						catch(err:Error)
						{
							trace("SaveLevelService::copyImages, copying GameObjectVO image: " + err);
						}
					}
				}
			}
			
			if(level.backgroundImage)
			{
				imageFile = new File();
				imageFile.url = level.backgroundImage;
				
				newImageFile = new File();
				newImageFile.url = file.url.substring(0, file.url.lastIndexOf("/")) + "/";
				newImageFile = newImageFile.resolvePath(imageFile.name);
				
				try
				{
					if(newImageFile.exists == false)
					{
						imageFile.copyTo(newImageFile, false);
					}
					level.backgroundImage = newImageFile.url;
				}
				catch(err:Error)
				{
					trace("SaveLevelService::copyImages, copying Level's backgroundImage: " + err);
				}
			}
		}
	}
}