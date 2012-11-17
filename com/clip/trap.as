package com.clip
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author Adhi
	 */
	public class trap extends mapObject	{
		protected var mTimer:Timer;

		public function trap():void {
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);		

			mTimer = new Timer(2000, 1);
			mTimer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function InitTrap(posX:int,posY:int):void {
			this.gotoAndStop("disarm");
			x = posX * 40;
			y = posY * 40;
		}
		
		protected function onRemoved(e:Event):void {
			mTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		protected function onTimer(e:TimerEvent):void {
			mTimer.reset();
			this.gotoAndPlay("deactivate");
		}
		
		public override function ActivateMe(posX:int,posY:int):Boolean {
			var px:int = Math.floor(this.x / 40);
			var py:int = Math.floor(this.y / 40);
			//trace(posX + "," + posY + " " + px + "," + py);
			return (posX == px && posY == py);
		}
		
		public function ActivateTrap():void {
			this.gotoAndPlay("activate");
			mTimer.start();
		}
		
	}	
}