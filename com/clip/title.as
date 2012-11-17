package com.clip
{	
	import com.game.common.App;
	import com.game.common.Setting;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author Adhi
	 */
	public class title extends MovieClip{
		public function title():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		protected function onAdded(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this["btn_start"].addEventListener(MouseEvent.CLICK, onStartClick);
		}
		
		protected function onRemoved(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this["btn_start"].removeEventListener(MouseEvent.CLICK, onStartClick);
		}
		
		protected function onStartClick(e:MouseEvent):void {
			App.GetInstance().mMain.EnterStage(Setting.defaultLevel);
		}
		
	}
	
}