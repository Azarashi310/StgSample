package  {
	
	import _mc.Mc_player;
	import _mc.Mc_player_bullet1;
	import _mc.Mc_player_bullet2;
	import _mc.Mc_enemy1;
	import _mc.Mc_enemy2;
	import flash.display.MovieClip;
	import flash.events.ContextMenuEvent;
	import flash.geom.Point;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import Layer.EnemyLayer;
	
	public class Main extends MovieClip {
		
		//キャラクター
		private var player:Mc_player;
		//敵
		private var enemy:Mc_enemy1;
		
		//デバック用
		private var HP:int;
		
		//敵格納用
		private var enemy_Array:Array = [];
		
		//移動速度
		private var speed:int;
		
		//弾
		private var bullets:Array = [];
		//弾速
		private var bulletSpead:int;
		//最大弾数
		private var maxBullet:int;
		//弾のウェイト
		private var bulletWait:int;
		//現在のカウント
		//private var BulletWait_Count:int ;
		//弾の許可
		private var arrowShotBullet:Boolean;
		//キーコード
		private var keyBuf:/*uint*/Array = [];
		
		//ショット許可タイマ
		private var shotArrowTimer:Timer;
		
		public function Main() 
		{
			// constructor code
			
			//初期化
			init();
			
			//キーボード操作
			addEventListener(KeyboardEvent.KEY_UP, keyboard_KEY_UP_EventListener);
			addEventListener(KeyboardEvent.KEY_DOWN, keyboard_KEY_DONW_EventListener);

			//まわすとこ
			addEventListener(Event.ENTER_FRAME, enter_FRAME_EventHandler);
			
			//弾を出す許可を管理するタイマイベント
			shotArrowTimer.addEventListener(TimerEvent.TIMER, timerEvent_Handler);
		}
		
		//初期化
		private function init():void 
		{
			//プレイヤーのインスタンスを作成
			player = new Mc_player();

			enemy = new Mc_enemy1();

			//プレイヤーの座標の取得
			var pt:Point = player.getPoint();

			//（プレイヤー）初期位置の反映
			player.x = pt.x;
			player.y = pt.y;
			
			//エネミーの座標位置の取得（暫定）
			pt = enemy.getPoint();

			//（エネミー）初期位置の反映
			enemy.x = pt.x;
			enemy.y = pt.y;

			//プレイヤー関連の設定
			//移動速度
			speed = player.getSpead();
			
			//弾の移動速度
			bulletSpead = player.getBulletSpead();
			
			//最大弾数
			maxBullet = player.getMaxBullet();
			
			//弾のウェイト
			bulletWait = player.getBulletWait();
			//BulletWait_Count = BulletWait;
			//ショット許可タイマを設定
			shotArrowTimer = new Timer(bulletWait);
			arrowShotBullet = true;
			shotArrowTimer.start();
			
			//プレイヤーを表示させる
			P_Layer.addChild(player);
			
			//敵の表示
			enemy_Array.push(enemy);
			E_Layer.addChild(enemy_Array[0]);

			//自身をstageにフォーカスする
			focusRect = false;
			stage.focus = this;
			
		}
		
		//メイン
		private function enter_FRAME_EventHandler(e:Event):void 
		{
			movePlayer();
			shotMethod();
			shotMove();
			trace("敵のインスタンス : " + this.enemy );
			trace("弾のインスタンス数 : " + B_Layer.numChildren);
			trace("敵のHP : " + HP);
		}
		
		//弾のショット許可
		private function timerEvent_Handler(e:TimerEvent):void 
		{
			arrowShotBullet = true;
		}
		
		//カラーチェンジ
		private function keyboard_KEY_UP_EventListener(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.C)
			{
				/*
				if (Player.currentLabel == "black")
				{
					Player.gotoAndStop("white");
				}
				else
				{
					Player.gotoAndStop("black");
				}
				*/
				player.colorChange();
			}
			keyBuf[e.keyCode] = false;
		}
		
		private function keyboard_KEY_DONW_EventListener(e:KeyboardEvent):void 
		{
			keyBuf[e.keyCode] = true;
		}
		
		//ショット
		private function shotMethod():void
		{
			if (keyBuf[Keyboard.Z] == true)
			{
				trace(bullets);
				trace(player.PlayerColor);
				if ((!player.PlayerColor) && (bullets.length < maxBullet) && 
				(arrowShotBullet == true))
				{
					//弾（黒）
					var BulletBlack:Mc_player_bullet1 = new Mc_player_bullet1();
					BulletBlack.x = player.x + player.width / 2 - BulletBlack.width / 2;
					BulletBlack.y = player.y - player.height / 2;
					bullets.push(BulletBlack);
					B_Layer.addChild(BulletBlack);
					arrowShotBullet = false;
				}
				else if ((player.PlayerColor)  && (bullets.length < maxBullet)&& 
				(arrowShotBullet == true))
				{
					//弾（白）
					var BulletWhite:Mc_player_bullet2 = new Mc_player_bullet2();
					BulletWhite.x = player.x + player.width / 2 - BulletWhite.width / 2;
					BulletWhite.y = player.y - player.height / 2;
					bullets.push(BulletWhite);
					B_Layer.addChild(BulletWhite);
					arrowShotBullet = false;
				}
			}
		}
		
		//ショットの移動
		private function shotMove():void
		{
				var len:int = bullets.length;
				for (var i:int = 0; i < len; i++ )
				{
					trace(bullets[i].y);
					//trace("弾速 : " + BulletSpead);
					trace("弾数 : " + bullets.length);
					bullets[i].y -=  bulletSpead;
					//ショットと敵がヒットしたら
					if (enemy_Array.length != 0)
					{
						if(enemy_Array[0].hitTestObject(bullets[i]))
						{
							//var HP:int = Enemy.getEnemyHP();
							HP = enemy.getEnemyHP();
							HP--;
							if(HP <= 0)
							{
								E_Layer.removeChildAt(0);
								enemy_Array.splice(0, 1);
								//E_Layer.removeChild(Enemy);
							}
							enemy.setEnemyHP(HP);
							B_Layer.removeChildAt(0);
							bullets.splice(i, 1);
						}
					}
					//弾の削除（配列）
					if (bullets[i].y <= 0 - bullets[i].height)
					{
						B_Layer.removeChildAt(0);
						bullets.shift();
					}
				}
		}
		
		//プレイヤーの移動
		private function movePlayer():void
		{
			if (keyBuf[Keyboard.SHIFT] )
			{
				speed = player.getSpead() / 2;
				trace(speed);
			}
			else if (keyBuf[Keyboard.SHIFT] )
			{
				speed = player.getSpead();
			}
			if (keyBuf[Keyboard.LEFT] )
			{
				player.x -= speed;
			}
			if (keyBuf[Keyboard.UP] )
			{
				player.y -= speed;
			}
			if (keyBuf[Keyboard.RIGHT] )
			{
				player.x += speed;
			}
			if (keyBuf[Keyboard.DOWN] )
			{
				player.y += speed;
			}
		}
	}
	
}
