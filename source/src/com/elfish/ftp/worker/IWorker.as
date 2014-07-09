package com.elfish.ftp.worker
{
	import com.elfish.ftp.model.Response;
	
	////////////////////////////////////////////////////////////////////////////////
	//
	//  Copyright (C) 2009-2010 www.elfish.com.cn
	//  The following is Source Code about IWorker.as
	//	Bug and advice to darkty2009@gmail.com
	//
	////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * 流程接口
	 */
	public interface IWorker
	{	
		/**
		 * 设置自定义命令列表
		 */
		function set commandList(list:Array):void;
		/**
		 * 获取自定义命令列表
		 */
		function get commandList():Array;
		/**
		 * 执行命令
		 */
		function executeCommand():void;
		/**
		 * 命令结束后自动执行
		 */
		function response(rsp:Response):void;
	}
}