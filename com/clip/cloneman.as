package com.clip {
	
	import com.game.common.App;
	import com.game.common.Setting;
	import com.clip.clone;
	
	import flash.events.Event;	
	import flash.display.MovieClip;	
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	public class cloneman extends MovieClip {
		protected var isRunning:Boolean = false;
		protected var isDead:Boolean	= false;
		protected var newMove:uint		= 0;
		protected var curMove:uint		= 0;
		protected var destX:int			= 0;
		protected var destY:int			= 0;
		protected var mTimer:Timer;
		
		protected var speed:uint		= Setting.gameSpeed;
		protected var moveStep:Number	= Setting.playerMove;
		protected var lastMove:int 	 	= -1;
		protected var myClone:clone;
		
		public function cloneman() {
			mTimer = new Timer(speed);
		}
		
		public function initCloneMan():void {
			isDead = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			mTimer.addEventListener(TimerEvent.TIMER, onTimer);
			mTimer.start();
		}
		
		protected function onAddedToStage(e:Event):void {
			destX = x;
			destY = y;
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function uninitCloneMan():void {
			mTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			mTimer.stop();
		}
		
		protected function onTimer(e:TimerEvent):void {
			DoMove();
		}
		
		protected function DoMove():void {
			if (App.GetInstance().gameState != Setting.STATE_START) return;
			if (isDead) return;
			var posX:int = Math.floor(this.x / 40);
			var posY:int = Math.floor(this.y / 40);
			if (destX != x || destY != y) {
				if (curMove != 0) {
					switch(curMove) {
						case Keyboard.UP:						
							if (currentLabel != "up") gotoAndStop("up");
							this.y -= moveStep; 
						break;
						case Keyboard.DOWN:
							if (currentLabel != "down") gotoAndStop("down");
							this.y += moveStep; 
						break;
						case Keyboard.LEFT:	
							if (currentLabel != "left") gotoAndStop("left");
							this.x -= moveStep; 
						break;
						case Keyboard.RIGHT:
							if (currentLabel != "right") gotoAndStop("right");
							this.x += moveStep; 
						break;
					}
				}
				posX = Math.floor(this.x / 40);
				posY = Math.floor(this.y / 40);
				App.GetInstance().mPlayerMove[posY][posX] = Setting.playerStep;
			}else {
				App.GetInstance().mPlayerMove[posY][posX] = Setting.playerStep;
				
				if (App.GetInstance().mMap.CheckHitWinning(posX, posY)) {
					DoWin();
					return;
				}
				if (App.GetInstance().mMap.CheckHitTrap(posX, posY)) {
					DoDie();
					return;
				}
				
				if (newMove != 0) {
					curMove = newMove;
					switch(curMove) {
						case Keyboard.UP:	cekUp(posX,posY); break;
						case Keyboard.DOWN:	cekDown(posX,posY); break;
						case Keyboard.LEFT:	cekLeft(posX,posY); break;
						case Keyboard.RIGHT:cekRight(posX,posY); break;
					}
				}else if(isRunning) {
					StopMoving();
				}
			}
		}
		
		protected function cekUp(posX:int, posY:int):void {
			if (posY <= 0) return;
			var code:int = parseInt(App.GetInstance().mCodeArray[posY-1][posX]);
			if (isNaN(code)) code = 0;
			if (code == 0) {
				destX = posX * 40;
				destY = (posY-1) * 40;
			}else if (code == 3) {
				App.GetInstance().mMap.PushBox(posX, posY - 1, Setting.UP);
				code = parseInt(App.GetInstance().mCodeArray[posY - 1][posX]);
				if (code == 0) cekUp(posX, posY);
			}else{
				x = posX * 40;
				y = posY * 40;
				destX = x;
				destY = y;
			}
		}
		
		protected function cekDown(posX:int, posY:int):void {
			if (posY >= App.GetInstance().mHeight-1) return;
			var code:int = parseInt(App.GetInstance().mCodeArray[posY + 1][posX]);
			if (isNaN(code)) code = 0;
			if (code == 0) {
				destX = posX * 40;
				destY = (posY+1) * 40;
			}else if (code == 3) {
				App.GetInstance().mMap.PushBox(posX, posY + 1, Setting.DOWN);
				code = parseInt(App.GetInstance().mCodeArray[posY + 1][posX]);
				if (code == 0) cekDown(posX, posY);
			}else{
				x = posX * 40;
				y = posY * 40;
				destX = x;
				destY = y;
			}
		}
		
		protected function cekLeft(posX:int, posY:int):void {
			if (posX <= 0) return;
			var code:int = parseInt(App.GetInstance().mCodeArray[posY][posX-1]);
			if (isNaN(code)) code = 0;
			if (code == 0) {
				destX = (posX-1) * 40;
				destY = posY * 40;
			}else if (code == 3) {
				App.GetInstance().mMap.PushBox(posX - 1, posY, Setting.LEFT);
				code = parseInt(App.GetInstance().mCodeArray[posY][posX - 1]);
				if (code == 0) cekLeft(posX, posY);
			}else{
				x = posX * 40;
				y = posY * 40;
				destX = x;
				destY = y;
			}
		}
		
		protected function cekRight(posX:int, posY:int):void {
			if (posX >= App.GetInstance().mWidth-1) return;
			var code:int = parseInt(App.GetInstance().mCodeArray[posY][posX+1]);
			if (isNaN(code)) code = 0;
			if (code == 0) {
				destX = (posX+1) * 40;
				destY = posY * 40;
			}else if (code == 3) {
				App.GetInstance().mMap.PushBox(posX + 1, posY, Setting.RIGHT);
				code = parseInt(App.GetInstance().mCodeArray[posY][posX + 1]);
				if (code == 0) cekRight(posX, posY);
			}else{
				x = posX * 40;
				y = posY * 40;
				destX = x;
				destY = y;
			}
		}
		
		public function Move(code:uint):void {
			if (newMove == code) return;
			if (isDead) return;
			newMove = code;
			switch(code) {
				case Keyboard.UP:
					lastMove = Setting.UP;
					isRunning = true;
					break;
				case Keyboard.DOWN:
					lastMove = Setting.DOWN;
					isRunning = true;
					break;
				case Keyboard.LEFT:
					lastMove = Setting.LEFT;
					isRunning = true;
					break;
				case Keyboard.RIGHT:
					lastMove = Setting.RIGHT;
					isRunning = true;
					break;
				case Keyboard.SPACE:
					DoClone();
				default:
					newMove = 0;
					break;
			}
			DoMove();
		}
		
		protected function DoClone():void {
			removeClone();
			
			var posX:int = Math.floor(this.x / 40) * 40;
			var posY:int = Math.floor(this.y / 40) * 40;
			myClone = new clone();
			myClone.initClone(posX, posY, lastMove);
			App.GetInstance().mMap.DoAddObject(myClone);
		}
		
		public function removeClone():void {
			if (myClone != null) {
				myClone.RemoveClone();
			}
		}
		
		public function NullifiedClone():void {
			myClone = null;
		}
		
		public function StopMoving():void {
			newMove = 0;
			if (destX != x || destY != y) return;
			if (!isRunning) return;
			isRunning = false;
			curMove = 0;
			gotoAndStop("idle");
		}
		
		public function CloneHit(posX:int, posY:int):Boolean {
			if (myClone == null) return false;
			return myClone.CloneHit(posX,posY);
		}
		
		public function PlayerHit(posX:int,posY:int):Boolean {
			var mPosX:int = Math.round(this.x / 40);
			var mPosY:int = Math.round(this.y / 40);
			if (mPosX == posX && mPosY == posY) return true;
			return false;
		}
		
		public function DoDie():void {
			isDead = true;
			isRunning = false;
			newMove = 0;
			destX = x;
			destY = y;
			curMove = 0;
			uninitCloneMan();
			removeClone();
			if (currentLabel != "dead") gotoAndStop("dead");
			App.GetInstance().mMain.EndTheStage();
			App.GetInstance().mMain.ShowResult(Setting.RESULT_LOSE);
		}
		
		public function DoWin():void {
			isDead = true;
			isRunning = false;
			newMove = 0;
			destX = x;
			destY = y;
			curMove = 0;
			uninitCloneMan();
			removeClone();
			if (currentLabel != "win") gotoAndStop("win");
			App.GetInstance().mMain.EndTheStage();
			App.GetInstance().mMain.ShowResult(Setting.RESULT_WIN);
		}
	}
	
}
