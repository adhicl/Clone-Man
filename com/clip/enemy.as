package com.clip
{
	import com.game.common.App;
	import com.game.common.Setting;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author Adhi
	 */
	public class enemy extends MovieClip {
		protected var dist:int			= Setting.enemy1Dist;
		protected var destX:int			= 0;
		protected var destY:int			= 0;
		protected var dir:int			= -1;
		protected var fRow:int			= 0;
		protected var fCol:int			= 0;
		
		protected var mTimer:Timer;
		
		protected var speed:int			= Setting.gameSpeed;
		protected var turn:int			= 0;
		protected var moveStep:Number	= Setting.enemyMove;
		protected var isDead:Boolean	= false;
		protected var deadCount:int		= 0;
		
		public function initEnemy(px:int, py:int):void {
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			dir = -1;
			
			fRow 	= py;
			fCol 	= px;
			x = px * 40;
			y = py * 40;
			destX 	= x;
			destY 	= y;
			
			mTimer = new Timer(speed);
			mTimer.addEventListener(TimerEvent.TIMER, onTimer);
			mTimer.start();
		}
		
		protected function onRemoved(e:Event):void {
			uninitEnemy();
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		public function uninitEnemy():void {
			isDead = false;
			mTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			mTimer.stop();
		}
		
		protected function onTimer(e:TimerEvent):void {
			DoMove();
		}

		/**************************** WILL DETERMINE HOW ENEMY WILL MOVE *******************************/
		
		protected function DoMove():void {
		}
		
		protected function doCekMove():void {
		}

		protected function changeDirection(posX:int,posY:int): void {			
		}
		
		protected function DoDie():void {
			
		}
		
		/******************************** TRACK PLAYER/CLONE LOCATION **********************************/
		
		protected function cekUp(posX:int, posY:int, far:int):int {
			for (var i:int = 1; i <= far; i++) {
				if ((posY - i) < 0) break;
				var code:int = parseInt(App.GetInstance().mCodeArray[posY - i][posX]);
				if (isNaN(code)) code = 0;
				if (code == 0) {
					code = parseInt(App.GetInstance().mPlayerMove[posY - i][posX]);
					if (code > 0) {
						turn = 0;
						dir = Setting.UP;
						destX = posX * 40;
						destY = (posY - i) * 40;
						return code;
					}
				}else {
					break;
				}
			}
			return 0;
		}
		
		protected function cekDown(posX:int, posY:int, far:int):int {
			for (var i:int = 1; i <= far; i++) {
				if ((posY + i) >= App.GetInstance().mHeight) break;
				var code:int = parseInt(App.GetInstance().mCodeArray[posY + i][posX]);
				if (isNaN(code)) code = 0;
				if (code == 0) {
					code = parseInt(App.GetInstance().mPlayerMove[posY + i][posX]);
					if (code > 0) {
						turn = 0;
						dir = Setting.DOWN;
						destX = posX * 40;
						destY = (posY + i) * 40;
						return code;
					}
				}else {
					break;
				}
			}
			return 0;
		}
		
		protected function cekLeft(posX:int, posY:int, far:int):int {
			for (var i:int = 1; i <= far; i++) {
				if ((posX - i) < 0) break;
				var code:int = parseInt(App.GetInstance().mCodeArray[posY][posX-i]);
				if (isNaN(code)) code = 0;
				if (code == 0) {
					code = parseInt(App.GetInstance().mPlayerMove[posY][posX-i]);
					if (code > 0) {
						turn = 0;
						dir = Setting.LEFT;
						destX = (posX-i) * 40;
						destY = posY * 40;
						return code;
					}
				}else {
					break;
				}
			}
			return 0;
		}
		
		protected function cekRight(posX:int, posY:int, far:int):int {
			for (var i:int = 1; i <= far; i++) {
				if ((posX + i) >= App.GetInstance().mWidth) break;
				var code:int = parseInt(App.GetInstance().mCodeArray[posY][posX + i]);
				if (isNaN(code)) code = 0;
				if (code == 0) {
					code = parseInt(App.GetInstance().mPlayerMove[posY][posX+i]);
					if (code > 0) {
						turn = 0;
						dir = Setting.RIGHT;
						destX = (posX+i) * 40;
						destY = posY * 40;
						return code;
					}
				}else {
					break;
				}
			}
			return 0;
		}
		
	}
	
}