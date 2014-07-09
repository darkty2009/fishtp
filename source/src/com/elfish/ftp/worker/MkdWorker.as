package com.elfish.ftp.worker
{
	import com.elfish.ftp.event.FTPEvent;
	import com.elfish.ftp.model.Command;
	import com.elfish.ftp.model.ControlSocket;
	import com.elfish.ftp.model.Response;
	import com.elfish.ftp.status.CommandsStatus;
	import com.elfish.ftp.status.ResponseStatus;
	
	import flash.events.EventDispatcher;
	
	////////////////////////////////////////////////////////////////////////////////
	//
	//  Copyright (C) 2009-2010 www.elfish.com.cn
	//  The following is Source Code about MkdWorker.as
	//	Bug and advice to darkty2009@gmail.com
	//
	////////////////////////////////////////////////////////////////////////////////
	
	[Event(name="ftp_workfinish", type="com.elfish.ftp.event.FTPEvent")]
	
	public class MkdWorker extends EventDispatcher implements IWorker
	{
		include "../../Version.as";
		
		private var list:Array;
		private var name:String;
		private var control:ControlSocket;
		
		public function MkdWorker(control:ControlSocket, name:String)
		{
			this.control = control;
			this.name = name;
			
			list = new Array();
			
			var names:Array = name.split(",");
			for(var i:int=0;i<names.length;i++)
				list.push(new Command(CommandsStatus.MKD, names[i]));
			
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