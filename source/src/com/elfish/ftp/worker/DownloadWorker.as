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
	import flash.utils.ByteArray;
	
	////////////////////////////////////////////////////////////////////////////////
	//
	//  Copyright (C) 2009-2010 www.elfish.com.cn
	//  The following is Source Code about DownloadWorker.as
	//	Bug and advice to darkty2009@gmail.com
	//
	////////////////////////////////////////////////////////////////////////////////

	public class DownloadWorker extends EventDispatcher implements IWorker
	{
		include "../../Version.as";
		
		private var list:Array;
		private var target:String;
		private var control:ControlSocket;
		private var data:DataSocket;
		
		public function DownloadWorker(control:ControlSocket, target:String)
		{
			this.control = control;
			this.target = target;
			
			list = new Array();
			list.push(new Command(CommandsStatus.PASV));
			list.push(new Command(CommandsStatus.RETR, target));
			
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
				data.connect(rsp.data as Config);
				executeCommand();
			}
			else if(rsp.code == ResponseStatus.RETR.END) {
				var bytes:ByteArray = data.read();
				rsp.data = bytes;
				var event:FTPEvent = new FTPEvent(FTPEvent.FTP_WORLFINISH, rsp);
				dispatchEvent(event);
			}
		}
	}
}