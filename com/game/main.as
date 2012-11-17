package com.game {
	
	import com.game.common.App;
	import com.game.common.Setting;
	import com.game.common.Levels;
	
	import com.clip.title;
	import com.clip.intro;
	import com.clip.resultFail;
	import com.clip.resultWin;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class main extends MovieClip {		
		public function main() {
			App.GetInstance().mMain = this;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedListener);
		}
		
		protected function onAddedListener(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedListener);
			init();
		}
		
		protected function init():void {
			App.GetInstance().InitManager();
			CreateTitlePage();
		}
		
		public function CreateTitlePage():void {
			ClearStage();
			App.GetInstance().curLevel = Setting.defaultLevel;
			App.GetInstance().gameState = Setting.STATE_TITLE;
			var titlePage:title = new title();
			this.addChild(titlePage);
		}
		
		protected function ClearStage():void {
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
				
		public function EnterStage(stage:int):void {
			App.GetInstance().curLevel = stage;
			initLevel();
		}
		
		protected function initLevel():void {
			ClearStage();
			
			var batchMap:String = App.GetInstance().mLevel.stageMap[App.GetInstance().curLevel];
			this.addChild(App.GetInstance().mMap.CreateMap(batchMap));

			var mIntro:intro = new intro();
			this.addChild(mIntro);
			
			App.GetInstance().gameState = Setting.STATE_INTRO;			
		}
		
		public function StartStage(mcIntro:intro = null):void {
			try {
				this.removeChild(mcIntro);
			}catch (e:Error) { }
			
			App.GetInstance().mInput.initKeyboardListener();
			App.GetInstance().mMap.startUpdater();
			
			stage.focus = this;
			
			App.GetInstance().gameState = Setting.STATE_START;			
		}
		
		public function ShowResult(result:int):void {
			App.GetInstance().gameState = Setting.STATE_RESULT;
			switch(result) {
				case Setting.RESULT_WIN:
					this.addChild(new resultWin());
					break;
				case Setting.RESULT_LOSE:
					this.addChild(new resultFail());
					break;
			}
		}
		
		public function EndTheStage():void {
			App.GetInstance().mMap.stopUpdater();
			App.GetInstance().mMap.DoEnd();
			App.GetInstance().mInput.uninitKeyboardListener();
			App.GetInstance().gameState = Setting.STATE_RESULT;
		}
		
		public function NextLevel():void {
			if (App.GetInstance().curLevel < Setting.maxLevel) {
				App.GetInstance().curLevel++;
				initLevel();
			}
		}
		
		public function RetryLevel():void {
			initLevel();
		}
		
		public function QuitLevel():void {
			CreateTitlePage();
		}
	}
	
}
