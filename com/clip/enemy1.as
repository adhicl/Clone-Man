package com.clip
{
	import adobe.utils.ProductManager;
	import com.clip.enemy;
	import com.game.common.App;
	import com.game.common.Setting;
	import fl.motion.Motion;
	import flash.display.MovieClip;
	
	/**
	 * @author Adhi
	 */
	public class enemy1 extends enemy {
		protected var moveArray:Array;
		protected var goBackCount:int;
		protected var goBack:Boolean	= false;
		protected var moveCount:Number 	= 0;
		
		public override function initEnemy(px:int, py:int):void {
			super.initEnemy(px, py);
			
			moveArray = new Array(App.GetInstance().mHeight);
			for (var i:int = 0; i < moveArray.length; i++) {
				moveArray[i] = new Array(App.GetInstance().mWidth);
				for (var j:int = 0; j < moveArray[i].length; j++) {
					moveArray[i][j] = 0;
				}
			}
			//trace(moveArray[0].length + "," + moveArray.length);
			dist = Setting.enemy1Dist;
		}
		
		protected function CleanMoveArray():void {
			for (var i:int = 0; i < moveArray.length; i++) {
				for (var j:int = 0; j < moveArray.length; j++) {
					moveArray[i][j] = 0;
				}
			}			
		}
		
		protected override function DoMove():void {
			if (App.GetInstance().gameState != Setting.STATE_START) return;
			if (isDead) {
				if (deadCount > 0 ) deadCount--;
				if (deadCount == 0) {
					uninitEnemy();
					App.GetInstance().mMap.DoRemoveObject(this);
				}
				return;
			}
			
			doCheckHit();
			
			if (destX != x || destY != y) {
				switch(dir) {
					case Setting.UP:						
						if (currentLabel != "up") 	gotoAndStop("up");
						this.y -= moveStep; 
					break;
					case Setting.DOWN:
						if (currentLabel != "down") gotoAndStop("down");
						this.y += moveStep; 
					break;
					case Setting.LEFT:	
						if (currentLabel != "left") gotoAndStop("left");
						this.x -= moveStep; 
					break;
					case Setting.RIGHT:
						if (currentLabel != "right") gotoAndStop("right");
						this.x += moveStep;
					break;
				}
			}else {
				doCekMove();
			}
		}
		
		protected function doCheckHit():void {
			var posX:int = Math.round(this.x / 40);
			var posY:int = Math.round(this.y / 40);
			//trace(this.name+" at " + posX + "," + posY + " " + (moveCount) +" "+ moveArray[posY][posX]);
			if (moveArray[posY][posX] == 0 && !goBack) {
				//trace(this.name+" put number at " + posX + "," + posY + " " + (moveCount + 1));
				moveArray[posY][posX] = moveCount++;
			}

			if (App.GetInstance().mMap.CheckHitPlayerAndClone(posX, posY)) {
				x = posX * 40;
				y = posY * 40;
				changeDirection(posX,posY);
			}
			
			if (App.GetInstance().mMap.CheckHitTrap(posX, posY)) {
				DoDie();
				return;
			}
			
		}
		
		protected override function DoDie():void {
			dir = -1;
			CleanMoveArray();
			destX = x;
			destY = y;
			isDead = true;
			if (currentLabel != "dead") this.gotoAndStop("dead");
			deadCount = Setting.deadRemove;
		}
		
		protected override function doCekMove():void {
			var posX:int = Math.floor(this.x / 40);
			var posY:int = Math.floor(this.y / 40);

			var value:int = App.GetInstance().mPlayerMove[posY][posX];
			if (value > 0) {
				App.GetInstance().mPlayerMove[posY][posX] = Setting.enemyStep;
			}
			
			if (!goBack && dir != -1) {
				changeDirection(posX,posY);
			}else {
				if (goBack) {
					if (goBackCount > 0) goBackCount--;
					if (goBackCount <= 0) {
						TraceBack(posX, posY);
					}
				}
				var tmpDir = dir;
				var tmpDX = destX;
				var tmpDY = destY;
				for (var pdir:int = 0; pdir < 4; pdir++) {
					var found = -1;
					switch(pdir) {
						case Setting.UP:	found = cekUp(posX, posY, dist);
						break;
						case Setting.DOWN:	found = cekDown(posX, posY, dist);
						break;
						case Setting.LEFT: 	found = cekLeft(posX, posY, dist);
						break;
						case Setting.RIGHT: found = cekRight(posX, posY, dist);
						break;
					}
					if (found > 0) {
						//trace("Found at " + found +" pdir=" + pdir);
						if (found == Setting.playerStep || found == Setting.cloneStep) {
							var surp:MovieClip = new surprise();
							surp.x = this.x;
							surp.y = this.y;
							App.GetInstance().mMap.DoAddObject(surp);
							goBack = false;
							break;
						}else {
							dir = tmpDir;
							destX = tmpDX;
							destY = tmpDY;
						}
					}
				}
			}
		}

		protected override function changeDirection(posX:int,posY:int): void {			
			dir = -1;
			var upVal:int 		= cekUp(posX, posY, 1);
			var downVal:int 	= cekDown(posX, posY, 1);
			var leftVal:int 	= cekLeft(posX, posY, 1);
			var rightVal:int 	= cekRight(posX, posY, 1);
			var curMaxVal:int	= upVal;
			
			dir = Setting.UP;
			if (downVal > curMaxVal) {
				dir = Setting.DOWN;
				curMaxVal = downVal;
			}
			if (leftVal > curMaxVal) {
				dir = Setting.LEFT;
				curMaxVal = leftVal;
			}
			if (rightVal > curMaxVal) {
				dir = Setting.RIGHT;
				curMaxVal = rightVal;
			}
			
			//trace("change direction dir " + dir+" "+upVal+","+rightVal+","+downVal+","+leftVal);
			
			destX = x;
			destY = y;
			
			if (curMaxVal <= 0) dir = -1;
			if (dir == -1) {
				goBack = true;
				goBackCount = Setting.goBackDelay;
				if (currentLabel != "idle") gotoAndStop("idle");
				return;
			}

			switch(dir) {
				case Setting.RIGHT:		destX = this.x + 40; break;
				case Setting.LEFT:		destX = this.x - 40; break;	
				case Setting.UP:		destY = this.y - 40; break;
				case Setting.DOWN:		destY = this.y + 40; break;
			}
		}
		
		protected function TraceBack(posX:int, posY:int):void {
			goBack = true;
			
			var upVal:int		= moveArray[posY - 1][posX];
			var downVal:int		= moveArray[posY + 1][posX];
			var leftVal:int		= moveArray[posY][posX - 1];
			var rightVal:int	= moveArray[posY][posX + 1];
			
			var minVal:int		= moveArray[posY][posX];
			
			dir = -1;
			if (upVal > 0 && (minVal == -1 || upVal < minVal)){
				dir = Setting.UP;
				minVal = upVal;
			}
			if (rightVal > 0 && (minVal == -1 ||rightVal < minVal)) {
				dir = Setting.RIGHT;
				minVal = rightVal;
			}
			if (downVal > 0 && (minVal == -1 ||downVal < minVal)) {
				dir = Setting.DOWN;
				minVal = downVal;
			}
			if (leftVal > 0 && (minVal == -1 ||leftVal < minVal)) {
				dir = Setting.LEFT;
				minVal = leftVal;
			}
			
			//trace("Trace back " +moveCount+" = "+upVal + "," + rightVal + "," + downVal + "," + leftVal+" "+minVal);
			moveCount = minVal;
			
			if (dir == -1) {
				//trace("Should have already been back yet");
				CleanMoveArray();
				goBack = false;
				if (currentLabel != "idle") gotoAndStop("idle");
				return;
			}
			
			destX = x;
			destY = y;
			
			//trace("Trace back dir "+dir);
			switch(dir) {
				case Setting.RIGHT:		destX = this.x + 40; break;
				case Setting.LEFT:		destX = this.x - 40; break;	
				case Setting.UP:		destY = this.y - 40; break;
				case Setting.DOWN:		destY = this.y + 40; break;
			}
		}
		
	}	
}