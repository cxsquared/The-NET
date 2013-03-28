package char {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import obj.BulletFactory;
	
	public class Player extends MovieClip {
		
		//Constants
		private const FRICTION:Number = 0.85; 
		private const SPEED_LIMIT:int = 10; 
		private const ACCELERATION:Number = 3;
		
		//Variables
		private var _vx:Number;
		private var _vy:Number;
		private var _accelerationX:Number;
		private var _accelerationY:Number;
		private var _frictionX:Number;
		private var _frictionY:Number;
		private var _stage:Stage;
		
		//Attack Vars
		private var _quickAttack:Boolean;
		private var _strongAttack:Boolean;
		
		//Timer
		private var _attackTimer:Timer;
		
		//Direction Vars
		private var _left:Boolean;
		private var _right:Boolean;
		private var _up:Boolean;
		private var _down:Boolean;
		
		public function Player() {
			init();
		}
		
		//Initialize character
		private function init():void{
			//Initialize variables
			_vx = 0;
			_vy = 0;
			_accelerationX = 0;
			_accelerationY = 0;
			_frictionX = FRICTION;
			_frictionY = FRICTION;
			_left = false;
			_right = false;
			_up = false;
			_down = false;
			_quickAttack = false;
			_strongAttack = false;
			_stage = Main.getStage();
			
			//Attack Timer
			_attackTimer = new Timer(250, 1);
			_attackTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){}, false, 0, true);
			
			//Event Handlers
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			//Add to stage
			this.alpha = 0;
			Main.getStage().addChild(this);
			this.x = 100;
			this.y = 200;
			//trace("Player ready");
		}
		
		//When added to stage
		private function onAdded(event:Event):void {
			//Event Handerls
			this.addEventListener(Event.ENTER_FRAME, playerLoop);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			//Fade in
			TweenLite.to(this, 0.25, {alpha: 1});
		}
		
		//Player Loop
		private function playerLoop(event:Event):void{
			//Button Checks
			if (_left == true){
				_frictionX = 1;
				_accelerationX = -ACCELERATION;
			}
			if (_right){
				_frictionX = 1;
				_accelerationX = ACCELERATION;
			}
			if (_right == false && _left == false){
				_accelerationX = 0;
				_frictionX = FRICTION;
			}
			//Up and Down
			if (_up){
				_frictionY = 1;
				_accelerationY = -ACCELERATION;
				this.gotoAndStop(2);
			}
			if (_down){
				_frictionY = 1;
				_accelerationY = ACCELERATION;
				this.gotoAndStop(3);
			}
			if (_down == false && _up == false){
				_accelerationY = 0;
				_frictionY = FRICTION;
				this.gotoAndStop(1);
			}
			
			//Apply acceleration
			_vx += _accelerationX;
			_vy += _accelerationY;
			
			//Apply friction
			_vx *= _frictionX;
			_vy *= _frictionY;
			
			//Speed Limit
			if (_vx > SPEED_LIMIT)
			{
				_vx = SPEED_LIMIT;
			}
			if (_vx < -SPEED_LIMIT)
			{
				_vx = -SPEED_LIMIT;
			}
			if (_vy > SPEED_LIMIT)
			{
				_vy = SPEED_LIMIT;
			}
			if (_vy < -SPEED_LIMIT)
			{
				_vy = -SPEED_LIMIT;
			}
			
			//Move Player
			x += _vx;
			y += _vy;
			
			//Boundaries
			if (this.x <= this.width){
				_vx = 0;
				this.x = this.width + 1;
			}
			if (this.x >= _stage.stageWidth){
				_vx = 0;
				this.x = _stage.stageWidth - 1;
			}
			if (this.y <= 0 + this.height/2){
				_vy = 0;
				this.y = this.height/2 + 1;
			}
			if (this.y >= _stage.stageHeight - this.height/2){
				_vy = 0;
				this.y = _stage.stageHeight - this.height/2 - 1;
			}
			
			//Attacks
			if(!_attackTimer.running){
				if(_quickAttack == true || _strongAttack == true){
					if(_quickAttack == true && _strongAttack == true){
						var powerBullet:MovieClip = obj.BulletFactory.makeBullet("powerAttack", this.x, this.y);
						_quickAttack = false;
						_strongAttack = false;
						_attackTimer.start();
					}
					else if(_quickAttack == true && _strongAttack == false){
						var quickBullet:MovieClip = obj.BulletFactory.makeBullet("quickAttack", this.x, this.y);
						_quickAttack = false;
						_attackTimer.start();
					}
					else if(_quickAttack == false && _strongAttack == true){
						var strongBullet:MovieClip = obj.BulletFactory.makeBullet("strongAttack", this.x, this.y);
						_strongAttack = false;
						_attackTimer.start();
					}
				}
			}
		}

		//key Down Listener
		private function keyDownHandler(event:KeyboardEvent):void{
			//Left and Right
			if (event.keyCode == 65){
				_left = true;
			}
			if (event.keyCode == 68){
				_right = true;
			}
			//Up and Down
			if (event.keyCode == 87){
				_up = true;
			}
			if (event.keyCode == 83){
				_down = true;
			}
			//Attack buttons
			if (event.keyCode == 74 && _quickAttack == false){
				_quickAttack = true;
			}
			if (event.keyCode == 75 && _strongAttack == false){
				_strongAttack = true;
			}
		}
		
		//Key Up Listener
		private function keyUpHandler(event:KeyboardEvent):void{
			//Left or Right
			if (event.keyCode == 65){
				_left = false;
			}
			if (event.keyCode == 68){
				_right = false;
			}
			//Up or Down
			if (event.keyCode == 87){
				_up = false;
			}
			if (event.keyCode == 83){
				_down = false;
			}
			//Attack buttons
			if (event.keyCode == 74){
				_quickAttack = false;
			}
			if (event.keyCode == 75){
				_strongAttack = false;
			}
		}
		
		private function onRemoved(event:Event):void{
			this.removeEventListener(Event.ENTER_FRAME, playerLoop);
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
	}
	
}
