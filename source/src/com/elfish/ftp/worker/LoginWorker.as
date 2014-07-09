package com.elfish.ftp.worker
{
	import com.elfish.ftp.event.FTPEvent;
	import com.elfish.ftp.model.Command;
	import com.elfish.ftp.model.Config;
	import com.elfish.ftp.model.ControlSocket;
	import com.elfish.ftp.model.Response;
	import com.elfish.ftp.status.CommandsStatus;
	import com.elfish.ftp.status.ResponseStatus;
	
	import flash.events.EventDispatcher;
	
	////////////////////////////////////////////////////////////////////////////////
	//
	//  Copyright (C) 2009-2010 www.elfish.com.cn
	//  The following is Source Code about LoginWorker.as
	//	Bug and advice to darkty2009@gmail.com
	//
	////////////////////////////////////////////////////////////////////////////////
	
	[Event(name="ftp_workfinish", type="com.elfish.ftp.event.FTPEvent")]
	
	public class LoginWorker extends EventDispatcher implements IWorker
	{
		include "../../Version.as";
		
		private var list:Array;
		private var config:Config;
		private var control:ControlSocket;
		
		public function LoginWorker(control:ControlSocket, config:Config)
		{
			this.control = control;
			this.config = config;
			
			list = new Array();
			list.push(new Command(CommandsStatus.USER, config.user));
			list.push(new Command(CommandsStatus.PASS, config.pass));
			
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
			if(rsp.code == ResponseStatus.LOGIN.NEED_PASS) {
				executeCommand();
			}else if(rsp.code == ResponseStatus.LOGIN.SUCCESS) {
				var event:FTPEvent = new FTPEvent(FTPEvent.FTP_WORLFINISH, rsp);
				dispatchEvent(event);
			}
		}
	}
}