package com.game.common
{
	
	/**
	 * @author Adhi
	 */
	public class Setting{
		public static var gameSpeed:int		= 30;
		public static var defaultLevel:int	= 1;
		public static var maxLevel:int		= 10;
		public static var removeClone:int	= 5000 / gameSpeed;
		
		public static var playerMove:Number = 4;
		public static var enemyMove:Number	= 5;
		public static var cloneMove:Number	= 8;
		
		public static var playerStep:uint	= 6;
		public static var enemyStep:uint	= 1;
		public static var cloneStep:uint	= 17;
		
		public static var goBackDelay:int	= 1000 / gameSpeed;
		public static var deadRemove:int	= 2000 / gameSpeed;
		public static var enemy1Dist:uint	= 5;
		
		public static var LEFT:uint			= 0;
		public static var UP:uint			= 1;
		public static var RIGHT:uint		= 2;
		public static var DOWN:uint			= 3;
		
		public static var STATE_LOAD:int			= 0;
		public static var STATE_TITLE:int			= 1;
		public static var STATE_CHOOSE_STAGE:int	= 2;
		public static var STATE_INTRO:int 			= 3;
		public static var STATE_START:int			= 4;
		public static var STATE_RESULT:int			= 5;
		
		public static var RESULT_WIN:int			= 0;
		public static var RESULT_LOSE:int			= 1;
		
	}
	
}