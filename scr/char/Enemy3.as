﻿package char {		import flash.display.MovieClip;	import flash.events.Event;	import flash.display.Stage;		public class Enemy3 extends MovieClip {				private var _type:String;		private var _health:Number;		private var _vx:Number;		private var _vy:Number;		private var _stage:Stage;		private var _isDead:Boolean;				private var _instance:Enemy3;				public function Enemy3() {			init();		}				private function init():void {			//Vars			_vx = -5;			_vy = Math.random()*5;			_health = 4;			_stage = Main.getStage();			_isDead = false;			_instance = this;						//Listeners			addEventListener(Event.ADDED_TO_STAGE, onAdded);			addEventListener(Event.ENTER_FRAME, enemyLoop);			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);		}				//When Added		private function onAdded(event:Event):void{			//Set position			this.x = _stage.stageWidth;			this.y = Math.random() * _stage.stageHeight;			//trace("Enemy created");						dispatchEvent(new Event("enemyCreated", true));		}				//Loop		private function enemyLoop(event:Event):void {			//Move			x += _vx;			y += _vy;						//Boundaries			if ( this.y <= 0 + this.height/2){				this.y = this.height/2;				_vy *= -1;			}			if ( this.y >= _stage.stageHeight - this.width/2){				this.y = _stage.stageHeight - this.width/2;				_vy *= -1;			}						//Health cheack			if ( _health <= 0){				if (this.parent) {					this.parent.removeChild(this);				}				_isDead = true;			}			//Leaves screen			if (this.x <= -this.width){				if (this.parent) {					this.parent.removeChild(this);				}				_isDead = true;			}		}				public function isHit(type:String):void{			//trace(this + " is hit by " + type);			if(type == "power"){				_health -= 2;				if( _health <= 0){					Main.setScore(10);				}				return;			}		 	else if(type == "quick"){				_health -= 1;				if( _health <= 0){					Main.setScore(10);				}				return;			}			else if(type == "strong"){				_health -= 4;				if( _health <= 0){					Main.setScore(25);				}				return;			}			else if(type == "player"){				_health -= 5;				return;			}		}				public function getHealth():Number{			return _health;		}				public function getInstance():Enemy3{			return _instance;		}				public function isDead():Boolean {			return _isDead;		}				//When Removed		private function onRemoved(event:Event):void {			removeEventListener(Event.ADDED_TO_STAGE, onAdded);			removeEventListener(Event.ENTER_FRAME, enemyLoop);			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);			//trace("enemy removed");		}	}	}