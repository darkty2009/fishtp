package com.elfish.ftp.worker
{
	import com.elfish.ftp.event.FTPEvent;
	import com.elfish.ftp.model.Command;
	import com.elfish.ftp.model.Config;
	import com.elfish.ftp.model.ControlSocket;
	import com.elfish.ftp.model.DataSocket;
	import com.elfish.ftp.model.Response;
	import com.elfish.ftp.status.CommandsStatus;
	import com.elfish.ftp.status.ResponseStatus;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	////////////////////////////////////////////////////////////////////////////////
	//
	//  Copyright (C) 2009-2010 www.elfish.com.cn
	//  The following is Source Code about UploadWorker.as
	//	Bug and advice to darkty2009@gmail.com
	//
	////////////////////////////////////////////////////////////////////////////////
	
	[Event(name="ftp_workfinish", type="com.elfish.ftp.event.FTPEvent")]
	
	public class UploadWorker extends EventDispatcher implements IWorker
	{
		include "../../Version.as";
		
		private var list:Array;
		private var name:String;
		private var fileData:*;
		private var control:ControlSocket;
		private var data:DataSocket;
		
		private static const MEM_SIZE:Number = 1024 * 32 * 1024;
		
		public function UploadWorker(control:ControlSocket, name:String, fileData:*)
		{
			this.control = control;
			this.name = name;
			this.fileData = fileData;
			
			list = new Array();
			list.push(new Command(CommandsStatus.PASV));
			list.push(new Command(CommandsStatus.STOR, name));
			
			list = list.reverse();
			
			this.control.responseCall = response;
		}
		
		public function set commandList(list:Array):void
		{
			this.list = list;
		}
		
		public function get commandList():Array
		{
			return this.list;
		}
		
		public function executeCommand():void
		{
			if(list.length > 0) {
				control.send(list[list.length-1] as Command);
				list.pop();
			}
		}
		
		public function response(rsp:Response):void
		{
			if(rsp.code == ResponseStatus.PASV.SUCCESS) {
				data = new DataSocket();
//				data.progressHandler = progressResponse;
				data.connect(rsp.data as Config);
				executeCommand();
			}
			else if(ResponseStatus.STOR.START.indexOf(rsp.code) >= 0) {
				upload();
			}
			else if(rsp.code == ResponseStatus.STOR.END) {
				rsp.code = 999;
				var event:FTPEvent = new FTPEvent(FTPEvent.FTP_WORLFINISH, rsp);
				dispatchEvent(event);
			}
		}
		
		/**
		 * 代码较多，单拿出来
		 */
		private var _timer:Timer;
		private var _position:Number;
		private var _bytes:ByteArray;
		private var _stream:FileStream;
		protected function upload():void
		{
			_stream = new FileStream();
			_stream.open(fileData, FileMode.READ);
			_bytes = new ByteArray();
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.start();
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			if(data.pending == 0) {
				_bytes.clear();
				
				trace(_stream.bytesAvailable);
				if(_stream.bytesAvailable > MEM_SIZE) {
					_stream.readBytes(_bytes, _position, MEM_SIZE);
					
					data.write(_bytes);
				}else {
					_stream.readBytes(_bytes, _position);
					_stream.close();
					
					data.write(_bytes);
					data.close();
					_timer.stop();
				}
				
				_position += MEM_SIZE;
			}
		}
		
		/**
		 * 输出上传进度
		 */
		protected function progressResponse(total:Number, wait:Number):void
		{
			var rsp:Response = new Response(888, "", {
				total:total,
				wait:wait
			});
			var event:FTPEvent = new FTPEvent(FTPEvent.FTP_PROGRESS, rsp);
			dispatchEvent(event);
		}
	}
}