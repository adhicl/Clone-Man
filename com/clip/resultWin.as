package com.clip
{
	import com.game.common.App;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Adhi
	 */
	public class resultWin extends MovieClip {
		public function resultWin():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		protected function onRemoved(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this["btn_next"].removeEventListener(MouseEvent.CLICK, onNextClick);
			this["btn_retry"].removeEventListener(MouseEvent.CLICK, onRetryClick);
			this["btn_quit"].removeEventListener(MouseEvent.CLICK, onQuitClick);
		}
		
		protected function onAdded(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this["btn_next"].addEventListener(MouseEvent.CLICK, onNextClick);
			this["btn_retry"].addEventListener(MouseEvent.CLICK, onRetryClick);
			this["btn_quit"].addEventListener(MouseEvent.CLICK, onQuitClick);
		}
		
		protected function onNextClick(e:MouseEvent):void {
			App.GetInstance().mMain.NextLevel();
		}
		
		protected function onRetryClick(e:MouseEvent):void {
			App.GetInstance().mMain.RetryLevel();
		}
		
		protected function onQuitClick(e:MouseEvent):void {
			App.GetInstance().mMain.QuitLevel();
		}
	}
	
}