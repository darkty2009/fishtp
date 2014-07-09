package com.elfish.ftp.worker
{
	import com.elfish.ftp.event.FTPEvent;
	import com.elfish.ftp.model.Command;
	import com.elfish.ftp.model.ControlSocket;
	import com.elfish.ftp.model.Response;
	import com.elfish.ftp.status.CommandsStatus;
	
	import flash.events.EventDispatcher;
	
	////////////////////////////////////////////////////////////////////////////////
	//
	//  Copyright (C) 2009-2010 www.elfish.com.cn
	//  The following is Source Code about DeleWorker.as
	//	Bug and advice to darkty2009@gmail.com
	//
	////////////////////////////////////////////////////////////////////////////////
	
	[Event(name="ftp_workfinish", type="com.elfish.ftp.event.FTPEvent")]
	
	public class DeleWorker extends EventDispatcher implements IWorker
	{
		include "../../Version.as";
		
		private var list:Array;
		private var name:String;
		private var isFile:Boolean;
		private var control:ControlSocket;
		
		public function DeleWorker(control:ControlSocket, name:String, isFile:Boolean)
		{
			this.control = control;
			this.name = name;
			this.isFile = isFile;
			
			list = new Array();
			
			var names:Array = name.split(",");
			for(var i:int=0;i<names.length;i++) {
				if(isFile)
					list.push(new Command(CommandsStatus.DELE, names[i]));
				else
					list.push(new Command(CommandsStatus.RMD, names[i]));
			}
			
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
			if(list.length == 0) {
				var event:FTPEvent = new FTPEvent(FTPEvent.FTP_WORLFINISH, rsp);
				dispatchEvent(event);
			}
			else
				executeCommand();
		}
	}
}