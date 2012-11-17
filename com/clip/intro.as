package com.clip
{
	import com.game.common.App;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * @author Adhi
	 */
	public class intro extends MovieClip {
		protected var mTimer:Timer;
		
		public function intro():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			mTimer = new Timer(1000,1);
		}
		
		protected function onAdded(e:Event):void {			
			this["txt_level"].text 	= App.GetInstance().curLevel.toString();
			this["txt_desc"].text 	= App.GetInstance().mLevel.introText[App.GetInstance().curLevel];

			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this.addEventListener(MouseEvent.CLICK, onClicked);

			mTimer.addEventListener(TimerEvent.TIMER, onTimer);
			mTimer.start();
		}
		
		protected function onClicked(e:MouseEvent):void {
			App.GetInstance().mMain.StartStage(this);
		}
		
		protected function onRemoved(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			mTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			this.removeEventListener(MouseEvent.CLICK, onClicked);
		}
		
		protected function onTimer(e:TimerEvent):void {
			App.GetInstance().mMain.StartStage(this);
		}
	}
	
}