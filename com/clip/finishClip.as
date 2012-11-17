package com.clip
{
	import com.game.common.App;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ACL
	 */
	public class finishClip extends MovieClip{
		public function finishClip():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onRemoved(e:Event):void {
			this.buttonMode = false;
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this.removeEventListener(MouseEvent.CLICK, onClicked);
		}
		
		protected function onAdded(e:Event):void {
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, onClicked);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onClicked(e:MouseEvent):void {
			App.GetInstance().mMain.QuitLevel();
		}
		
	}
	
}