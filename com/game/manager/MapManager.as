package com.game.manager
{
	import com.game.common.App;
	import com.game.common.Setting;

	import com.clip.cloneman;
	import com.clip.enemy;
	import com.clip.enemy1;
	import com.clip.moveableBox;
	import com.clip.trap1;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author ACL
	 */
	public class MapManager{
		
		protected var cGround:MovieClip;
		protected var cObject:MovieClip;
		
		protected var cTimer:Timer;
		protected var enemyArr:Array;
		protected var objectArr:Array;
		
		public function startUpdater():void {
			cTimer = new Timer(Setting.gameSpeed*(40/Setting.playerMove));
			cTimer.addEventListener(TimerEvent.TIMER, onTimer);
			cTimer.start();
		}
		
		public function stopUpdater():void {
			cTimer.stop();
			cTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			cTimer = null;
		}
		
		protected function onTimer(e:TimerEvent):void {
			UpdatePlayerMovement();
		}
		
		protected function getObject(code:String,cRow:int,cCol:int):void {
			switch(code) {
				case "1":
					var sb:Bitmap = new Bitmap(new box1());
					sb.x = cCol * 40;
					sb.y = cRow * 40;
					cGround.addChild(sb);
					break;
				case "2":
					var sb2:Bitmap = new Bitmap(new box2());
					sb2.x = cCol * 40;
					sb2.y = cRow * 40;
					cGround.addChild(sb2);
					break;
				case "3":
					var bx:moveableBox = new moveableBox();
					bx.InitBox(cCol, cRow);
					cGround.addChild(bx);
					objectArr.push(bx);
					break;
				case "F":
					var fn:MovieClip = new finish();
					fn.x = cCol * 40;
					fn.y = cRow * 40;
					cGround.addChild(fn);
					break;
				case "E":
					var en:enemy = new enemy1();
					en.initEnemy(cCol,cRow);
					cObject.addChild(en);
					enemyArr.push(en);
					break;
				case "P":
					var mc:cloneman = new cloneman();
					mc.initCloneMan();
					mc.x = cCol * 40;
					mc.y = cRow * 40;
					App.GetInstance().mCloneman = mc;
					cObject.addChildAt(mc,0);
					break;
				case "t":
					var thorn:trap1 = new trap1();
					thorn.InitTrap(cCol, cRow);
					cGround.addChild(thorn);
					objectArr.push(thorn);
					break;
			}
		}
		
		public function CreateMap(batchMap:String):MovieClip {
			enemyArr = new Array();
			objectArr = new Array();
			
			var mStage:MovieClip = new MovieClip();
			var mGround:MovieClip = new MovieClip();
			var mObject:MovieClip = new MovieClip();
			mStage.addChild(mGround);
			mStage.addChild(mObject);

			cGround = mGround;
			cObject	= mObject;

			var mapArray:Array 	= batchMap.split("\n");
			var height:int		= mapArray.length;
			var width:int		= mapArray[0].split(",").length;

			App.GetInstance().mCodeArray 	= new Array();
			App.GetInstance().mWidth		= width;
			App.GetInstance().mHeight		= height;
			App.GetInstance().mPlayerMove	= new Array();
			
			for (var i:int = 0; i < height; i++) {
				var mapCode:Array = mapArray[i].split(",");
				var row:Array = new Array();
				App.GetInstance().mCodeArray.push(mapCode);
				
				for (var j:int = 0; j < width; j++) {
					row.push(0);
					var code:String = mapCode[j];
					var ob:DisplayObject = null;

					getObject(code,i,j);

				}
				
				App.GetInstance().mPlayerMove.push(row);
			}
			
			mStage.x -= 2;
			mStage.y = -2;
			
			return mStage;
		}
		
		public function UpdatePlayerMovement():void {
			for (var i:int = 0; i < App.GetInstance().mHeight; i++) {
				for (var j:int = 0; j < App.GetInstance().mWidth; j++) {
					if (App.GetInstance().mPlayerMove[i][j] > 0) {
						App.GetInstance().mPlayerMove[i][j] --;
						if (App.GetInstance().mPlayerMove[i][j] == 0 || App.GetInstance().mPlayerMove[i][j] == 10) {
							App.GetInstance().mPlayerMove[i][j] = 0;
							/*
							var r:MovieClip = MovieClip(cGround.getChildByName("box_" + i + "_" + j));
							if (r != null) {
								cGround.removeChild(r);
							}
							*/
						}/*else {
							
							if (cGround.getChildByName("box_" + i + "_" + j) == null) {
								var c:MovieClip = new box_pos();
								c.name = "box_" + i + "_" + j;
								c.x = j * 40;
								c.y = i * 40;
								cGround.addChild(c);
							}
						}
						*/
					}
				}
			}
		}
		
		public function DoAddObject(ob:MovieClip):void {
			cObject.addChild(ob);
		}
		
		public function DoRemoveObject(ob:MovieClip):void {
			cObject.removeChild(ob);
		}
		
		public function DoCleanUpClone():void {
			for (var i:int = 0; i < App.GetInstance().mHeight; i++) {
				for (var j:int = 0; j < App.GetInstance().mWidth; j++) {
					if (App.GetInstance().mPlayerMove[i][j] > 10) {
						App.GetInstance().mPlayerMove[i][j] = 0;
						//var r:MovieClip = MovieClip(cGround.getChildByName("box_" + i + "_" + j));
						//if (r != null) cGround.removeChild(r);
					}					
				}
			}
		}
		
		public function DoCleanUpAll():void {
			for (var i:int = 0; i < App.GetInstance().mHeight; i++) {
				for (var j:int = 0; j < App.GetInstance().mWidth; j++) {
					if (App.GetInstance().mPlayerMove[i][j] > 0) {
						App.GetInstance().mPlayerMove[i][j] = 0;
						//var r:MovieClip = MovieClip(cGround.getChildByName("box_" + i + "_" + j));
						//if (r != null) cGround.removeChild(r);
					}					
				}
			}
		}
		
		public function CheckHitPlayerAndClone(posX:int,posY:int):Boolean {
			if (App.GetInstance().mCloneman.PlayerHit(posX,posY)) {
				App.GetInstance().mCloneman.DoDie();
				DoCleanUpAll();
				return true;
			}else if (App.GetInstance().mCloneman.CloneHit(posX, posY)) {
				App.GetInstance().mCloneman.removeClone();
				return true;
			}
			return false;
		}
		
		public function CheckHitWinning(posX:int, posY:int):Boolean {
			if (App.GetInstance().mCodeArray[posY][posX] == "F")
				return true;
			return false;
		}
		
		public function DoEnd():void {
			for (var i:int = 0; i < enemyArr.length; i++) {
				(enemyArr[i] as enemy).uninitEnemy();
			}
		}
		
		public function PushBox(posX:int, posY:int, pd:int):void {
			for (var i:int = 0; i < objectArr.length; i++) {
				if (objectArr[i].PushMe(posX, posY)) {
					objectArr[i].PushBox(pd);
					return;
				}
			}
		}
		
		public function CheckHitTrap(posX:int, posY:int):Boolean {
			//trace("check hit trap " + posX + " " + posY);
			for (var i:int = 0; i < objectArr.length; i++) {
				if (objectArr[i].ActivateMe(posX, posY)) {
					objectArr[i].ActivateTrap();
					return true;
				}
			}
			return false;
		}
		
	}
	
}