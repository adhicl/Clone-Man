package com.game.manager
{
	import com.game.common.App;
	import com.game.common.Setting;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * @author ACL
	 */
	public class InputManager {
		protected var lastKey:int = -1;
		
		public function initKeyboardListener():void {
			App.GetInstance().mMain.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownListener);
			App.GetInstance().mMain.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpListener);
		}
		
		public function uninitKeyboardListener():void {
			App.GetInstance().mMain.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownListener);
			App.GetInstance().mMain.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpListener);
		}

		protected function onKeyDownListener(e:KeyboardEvent):void {
			lastKey = e.keyCode;
			if (App.GetInstance().gameState != Setting.STATE_START) return;
			switch(e.keyCode) {
				case Keyboard.UP:
				case Keyboard.DOWN:
				case Keyboard.LEFT:
				case Keyboard.RIGHT:
				case Keyboard.SPACE:
					App.GetInstance().mCloneman.Move(e.keyCode); 
					break;
			}
		}
		
		protected function onKeyUpListener(e:KeyboardEvent):void {
			if (App.GetInstance().gameState != Setting.STATE_START) return;
			if (e.keyCode == lastKey) App.GetInstance().mCloneman.StopMoving();
		}
	}
	
}