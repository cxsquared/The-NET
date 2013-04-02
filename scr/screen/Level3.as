﻿package screen {		//Flash imports	import flash.display.MovieClip;	import flash.events.Event;	import flash.display.Stage;	import flash.events.KeyboardEvent;		//Tweening	import com.greensock.TweenLite;	import com.greensock.easing.*;		//Game imports	import char.Player;	import char.EnemyFactory;		public class Level3 extends MovieClip {		//Consts		private const ENEMY_CHANCE:Number = 0.03;				//Vars		private var _player:Player;		private var _enemyBudget:Number;		private static var _bullets:Array = [];		private static var _enemies:Array = [];		private var _stage:Stage;		private var _previousHealth:Number;		private var _paused:Boolean;		private var _pPressed:Boolean;		private var _previousScore:Number;		private var _dead:Boolean;		private var _playerDead:Boolean;		private var _playerDeadTimer:Number;		public function Level3() {			init();		}				private function init():void {			//Vars			this.alpha = 0;			_stage = Main.getStage();			_enemyBudget = 20;			_paused = false;			_pPressed = false;			_previousScore = Main.getScore();			_dead = false;			_playerDead = false;			_playerDeadTimer = 0;						paused_txt.visible = false;						//Setting health			_previousHealth = Main.getPlayerHealth();			Main.setPlayerHealth(_previousHealth + 25);			if(Main.getPlayerHealth() > 100){				Main.setPlayerHealth(-Main.getPlayerHealth()+100);			}						//Setting level			Main.setLevel(3);			Main.lvlRunning(true);						//Event listeners			addEventListener(Event.ENTER_FRAME, levelLoop);			addEventListener(Event.ADDED_TO_STAGE, onAdded);			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);			Main.getStage().addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);						//Add This			Main.getInstance().addChild(this);		}				private function onAdded(event:Event):void {			TweenLite.to(this, 0.5, {alpha:1});			_player = new Player();			trace("Level 3 reaady");		}				private function levelLoop(event:Event):void{			//Check for paused			if(_pPressed == true){				_pPressed = false;				//if not paused				if(_paused == false){					_paused = true;					_stage.frameRate = 0;					paused_txt.visible = true;				}			}						if( _dead == false){				//Creates enemies as long as enemyBudget is inbetween 10 and 20				if(_enemyBudget <= 20 && _enemyBudget > 10){					//Randomly creates enemies					if (ENEMY_CHANCE > Math.random()){						//Ranomd number to choose what enemy is created						var randomEnemy:Number = Math.random()* 1;						//trace(randomEnemy);												//Create enemy						if(randomEnemy <= 0.5){							//trace("Enemy 1");							//Calls enemy factor to make weak enemy							var enemy1:MovieClip = char.EnemyFactory.makeEnemy("weak");														//Adds enemy							if(enemy1.stage == null){								Main.getInstance().addChild(enemy1);								_enemyBudget -= 1;								//trace("Enemy created");								//trace("Enemy budget is now " + _enemyBudget);							}												}						//Create enemy						else if(randomEnemy > 0.5 && randomEnemy <= 0.8){						//trace("Enemy 2");						var enemy2:MovieClip = char.EnemyFactory.makeEnemy("quick");							if(enemy2.stage == null){								Main.getInstance().addChild(enemy2);								_enemyBudget -= 3;								//trace("Enemy created");								//trace("Enemy budget is now " + _enemyBudget);							}							}						//Create enemy						else if(randomEnemy > 0.8 && randomEnemy <= 1){							//trace("Enemy 3");							var enemy3:MovieClip = char.EnemyFactory.makeEnemy("strong");							if(enemy3.stage == null){								Main.getInstance().addChild(enemy3);								_enemyBudget -= 3;								//trace("Enemy created");								//trace("Enemy budget is now " + _enemyBudget);							}						}						//Create enemy						else if(randomEnemy > 1 && randomEnemy <= 1.2){							//trace("Enemy 4");							var enemy4:MovieClip = char.EnemyFactory.makeEnemy("power");							if (enemy4.stage == null){							Main.getInstance().addChild(enemy4);								_enemyBudget -= 4;								//trace("Enemy created");								//trace("Enemy budget is now " + _enemyBudget);							}						}					}				} //End of enemy creation for 10 to 20 budget								//Creates enemy if budget is less than 10				//Same as above				else if (_enemyBudget <= 10 && _enemyBudget >0){					if (ENEMY_CHANCE > Math.random()){						var randomEnemy:Number = Math.random() * 1;						if(randomEnemy <= 0.5){							//trace("Enemy 1");							var enemy1:MovieClip = char.EnemyFactory.makeEnemy("weak");							if(enemy1.stage == null){								Main.getInstance().addChild(enemy1);								_enemyBudget -= 1;								//trace("Enemy created");								//trace("Enemy budget is now " + _enemyBudget);							}						}												else if(randomEnemy > 0.5 && randomEnemy <= 0.8){							//trace("Enemy 2");							var enemy2:MovieClip = char.EnemyFactory.makeEnemy("quick");							if(enemy2.stage == null){								Main.getInstance().addChild(enemy2);								_enemyBudget -= 3;								//trace("Enemy created");								//trace("Enemy budget is now " + _enemyBudget);							}						}												else if(randomEnemy > 0.8 && randomEnemy <= 1){							//trace("Enemy 3");							var enemy3:MovieClip = char.EnemyFactory.makeEnemy("strong");							if(enemy3.stage == null){								Main.getInstance().addChild(enemy3);								_enemyBudget -= 3;								//trace("Enemy created");								//trace("Enemy budget is now " + _enemyBudget);							}						}					}				}//End of enemy creation								//Loop for collision detection				for (var i:int = _enemies.length - 1; i >= 0; i--){					for(var j:int = _bullets.length - 1; j >= 0; j--){						//Check if bullet and enemy exsists						if(_bullets[j] != null && _enemies[i] != null){							if(_bullets[j].stage != null && _enemies[i].stage != null){								//Check if bullet hits enemy								if(_bullets[j].hitTestObject(_enemies[i])){									//Tells enemy he's hit									_enemies[i].isHit(_bullets[j].getType());									//trace(_enemies[i] + "" + i + " is hit and now has " + _enemies[i].getHealth())																	//Check if enemy is dead or not on stage									if(_enemies[i].getHealth() <= 0 || _enemies[i].stage == null){										_enemies.splice(i, 1);									}																		//Remove bullet and remove from array									if (_bullets[j].parent) {										_bullets[j].parent.removeChild(_bullets[j]);										_bullets.splice( i, 1);									}																		//Set score +1 for each hit									Main.setScore(1);								}							}													//Check if bullet leaves screen							if(_bullets[j] != null){								if(_bullets[j].stage == null){									//Removes bullet									if (_bullets[j].parent) {										_bullets[j].parent.removeChild(_bullets[j]);									}																_bullets.splice( j, 1);								}							}													//trace(_bullets.length);						}					}									//If enemy and player exist, check if they hit					if(_enemies[i] != null && _player != null){						//Hit check						if(_enemies[i].hitTestObject(_player)){							//Set player health							Main.setPlayerHealth(-25);														//Enemy hit							_enemies[i].isHit("player");														//Enemy health check							if(_enemies[i].getHealth() <= 0){								_enemies.splice(i, 1);							}							}					}										//Check if enemy leaves stage					if(_enemies[i] != null){						if (_enemies[i].stage == null){							_enemies.splice(i, 1);						}					}										//trace("Number of Enemies " + _enemies.length);									}//End of hit tests			}						//Check for end game			if(_enemyBudget <= 0){				//trace(_enemies.length);				if(_enemies.length == 0){					//Fade out					TweenLite.to(this, 1, {alpha: 0});					TweenLite.to(_player, 1, {alpha: 0});					//End level					if( this.alpha <= 0){						if(_player.parent){							_player.parent.removeChild(_player);						}						if(this.parent){							this.parent.removeChild(this);						}												_stage.dispatchEvent( new Event("levelComplete", true));						trace("Level 3 end");					}				}			}						//Check for player has 0 hp			if( Main.getPlayerHealth() <= 0){				//Fade player out				TweenLite.to(_player, 0.5, {alpha: 0});								//Var to set score				var score:Number = Main.getScore();				//Remove one life				Main.setLives(-1);				//Reset score				Main.setScore(-score + _previousScore);				//Reset budget				_enemyBudget = 20;								//Reset Player life				Main.setPlayerHealth(100);				//Check if health over 100				if(Main.getPlayerHealth() > 100){					Main.setPlayerHealth(-Main.getPlayerHealth()+100);				}								//Stop game				_dead = true;			}						//When dead			if( _dead == true ){				//Empty arrays				for( var x:int = 0; x < _enemies.length; x++){					TweenLite.to(_enemies[x], 1, {alpha: 0});					_enemies.splice( x, 1);				}				_bullets = [];								//When faded out				if(_player.alpha == 0){					//remove player					if(_player.parent){						_player.parent.removeChild(_player);						_playerDead = true;						trace("player removed");					}				}				//Add 1 to timer				_playerDeadTimer++;								//When all enmies gone				if( _playerDead == true && _playerDeadTimer >= 60){					//New player					_player = new Player();					_playerDead = false;					_dead = false;					_playerDeadTimer = 0;										trace("player alive again");				}			}						//Check for player has no lives			if( Main.getLives() <= 0){													_bullets = [];				_enemies = [];								TweenLite.to(this, 1, {alpha: 0});				TweenLite.to(_player, 1, {alpha: 0});				if( this.alpha <= 0){					if(_player.parent){						_player.parent.removeChild(_player);					}					if(this.parent){						this.parent.removeChild(this);					}										_stage.dispatchEvent( new Event("levelComplete", true));					trace("Level 1 end");				}			}						//Update health bar			healthHolder.healthBar.scaleX = Main.getPlayerHealth() / 100;						//Update lives			lives_txt.text = Main.getLives().toString();		} //End game loop				private function onRemoved(event:Event):void{			removeEventListener(Event.ENTER_FRAME, levelLoop);			removeEventListener(Event.ADDED_TO_STAGE, onAdded);			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);			Main.getStage().removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);			Main.lvlRunning(false);		}				//Key handler		private function keyDownHandler(event:KeyboardEvent):void{			//If p pressed			if (event.keyCode == 80 && _pPressed == false){				//if not paused, pause				if(_paused == false){					_pPressed = true;				}								//if paused, un pause				else if(_paused == true){					_paused = false;					_stage.frameRate = 30;					paused_txt.visible = false;				}			}		}				//Get instance		public static function addBullet(bullet:MovieClip):void {			_bullets.push(MovieClip(bullet));		}				public static function addEnemy(enemy:MovieClip):void{			_enemies.push(MovieClip(enemy));			//trace(enemy + " was added to enemy array.");		}	}	}