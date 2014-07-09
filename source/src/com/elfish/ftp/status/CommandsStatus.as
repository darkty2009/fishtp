package com.elfish.ftp.status
{
	////////////////////////////////////////////////////////////////////////////////
	//
	//  Copyright (C) 2009-2010 www.elfish.com.cn
	//  The following is Source Code about CommandsStatus.as
	//	Bug and advice to darkty2009@gmail.com
	//
	////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * 命令配置
	 */
	public class CommandsStatus
	{
		include "../../Version.as";
		
		/**
		 * stor command, upload file
		 */
		public static const STOR:String		= "stor";
		
		/**
		 * type i, binary transform
		 */
		public static const BINARY:String	= "type i";
		
		/**
		 * type A, ascii transform
		 */
		public static const ASCII:String	= "type A";
		
		/**
		 * user, login(username)
		 */
		public static const USER:String		= "user";
		
		/**
		 * pass, login(password)
		 */
		public static const PASS:String		= "pass";
		
		/**
		 * quit, close connection and exit
		 */
		public static const QUIT:String		= "quit";
		
		/**
		 * cwd, set the current work directory
		 */
		public static const CWD:String		= "cwd";
		
		/**
		 * pwd, show the current work directory
		 */
		public static const PWD:String		= "pwd";
		
		/**
		 * list, get the special directory's file list
		 */
		public static const LIST:String		= "list";
		
		/**
		 * pasv, pasv model to transform
		 */
		public static const PASV:String		= "pasv";
		
		/**
		 * retr, download file
		 */
		public static const RETR:String		= "retr";
		
		/**
		 * mkd, create new directory
		 */
		public static const MKD:String 		= "mkd";
		
		/**
		 * dele, delete directory on server
		 */
		public static const RMD:String		= "rmd";
		
		/**
		 * dele, delete file on server
		 */
		public static const DELE:String		= "dele";
	}
}