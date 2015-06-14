package  {
	
	import _mc.Mc_player;
	import _mc.Mc_player_bullet1;
	import _mc.Mc_player_bullet2;
	import _mc.Mc_enemy1;
	import _mc.Mc_enemy2;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class Main extends MovieClip {
		
		//キャラクター
		private var Player:Mc_player;
		
		private var Enemy:Mc_enemy1;
		//移動速度
		private var Spead:int;
		
		//弾
		private var Bullets:Array = [];
		//弾速
		private var BulletSpead:int;
		//最大弾数
		private var MaxBullet:int;
		//弾のウェイト
		private var BulletWait:int;
		//現在のカウント
		//private var BulletWait_Count:int ;
		//弾の許可
		private var ArrowShotBullet:Boolean;
		//キーコード
		private var keyBuf:/*uint*/Array = [];
		
		//ショット許可タイマ
		private var ShotArrowTimer:Timer;
		
		public function Main() 
		{
			// constructor code
			
			//初期化
			init();
			
			//キーボード操作
			addEventListener(KeyboardEvent.KEY_UP, Keyboard_KEY_UP_EventListener);
			addEventListener(KeyboardEvent.KEY_DOWN, Keyboard_KEY_DONW_EventListener);

			//まわすとこ
			addEventListener(Event.ENTER_FRAME, ENTER_FRAME_EventHandler);
			
			//弾を出す許可を管理するタイマイベント
			ShotArrowTimer.addEventListener(TimerEvent.TIMER, TIMEREvent_Handler);
		}
		
		//初期化
		private function init():void 
		{
			//プレイヤーのインスタンスを作成
			Player = new Mc_player();

			Enemy = new Mc_enemy1();

			//プレイヤーの座標の取得
			var pt:Point = Player.getPoint();

			//（プレイヤー）初期位置の反映
			Player.x = pt.x;
			Player.y = pt.y;
			
			//エネミーの座標位置の取得（暫定）
			pt = Enemy.getPoint();

			//（エネミー）初期位置の反映
			Enemy.x = pt.x;
			Enemy.y = pt.y;

			//プレイヤー関連の設定
			//移動速度
			Spead = Player.getSpead();
			
			//弾の移動速度
			BulletSpead = Player.getBulletSpead();
			
			//最大弾数
			MaxBullet = Player.getMaxBullet();
			
			//弾のウェイト
			BulletWait = Player.getBulletWait();
			//BulletWait_Count = BulletWait;
			//ショット許可タイマを設定
			ShotArrowTimer = new Timer(BulletWait);
			ArrowShotBullet = true;
			ShotArrowTimer.start();
			
			//プレイヤーを表示させる
			this.addChild(Player);
			
			//敵の表示
			this.addChild(Enemy);

			//自身をstageにフォーカスする
			focusRect = false;
			stage.focus = this;
			
		}
		
		//メイン
		private function ENTER_FRAME_EventHandler(e:Event):void 
		{
			MovePlayer();
			Shot();
			ShotMove();
		}
		
		//弾のショット許可
		private function TIMEREvent_Handler(e:TimerEvent):void 
		{
			ArrowShotBullet = true;
		}
		
		//カラーチェンジ
		private function Keyboard_KEY_UP_EventListener(e:KeyboardEvent):void 
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
				Player.colorChange();
			}
			keyBuf[e.keyCode] = false;
		}
		
		private function Keyboard_KEY_DONW_EventListener(e:KeyboardEvent):void 
		{
			keyBuf[e.keyCode] = true;
		}
		
		//ショット
		private function Shot():void
		{
			if (keyBuf[Keyboard.Z] == true)
			{
				trace(Bullets);
				trace(Player.PlayerColor);
				if ((!Player.PlayerColor) && (Bullets.length < MaxBullet) && 
				(ArrowShotBullet == true))
				{
					//弾（黒）
					var BulletBlack:Mc_player_bullet1 = new Mc_player_bullet1();
					BulletBlack.x = Player.x + Player.width / 2 - BulletBlack.width / 2;
					BulletBlack.y = Player.y - Player.height / 2;
					Bullets.push(BulletBlack);
					this.addChild(BulletBlack);
					ArrowShotBullet = false;
				}
				else if ((Player.PlayerColor)  && (Bullets.length < MaxBullet)&& 
				(ArrowShotBullet == true))
				{
					//弾（白）
					var BulletWhite:Mc_player_bullet2 = new Mc_player_bullet2();
					BulletWhite.x = Player.x + Player.width / 2 - BulletWhite.width / 2;
					BulletWhite.y = Player.y - Player.height / 2;
					Bullets.push(BulletWhite);
					this.addChild(BulletWhite);
					ArrowShotBullet = false;
				}
			}
		}
		
		//ショットの移動
		private function ShotMove():void
		{
			for (var i:int = 0; i < Bullets.length; i++ )
			{
				trace(Bullets[i].y);
				trace("弾速 : " + BulletSpead);
				trace("弾数 : " + Bullets.length);
				Bullets[i].y -=  BulletSpead;
				//ショットと敵がヒットしたら
				if(Bullets[i].hitTestObject(Enemy))
				{
					//trace(Enemy.hitpoint);
					/*
					Enemy.hitpoint--;
					if(Enemy.hitpoint <= 0)
					{
						Enemy.removeChild(this);
					}
					*/
				}
				if (Bullets[i].y <= 0 - Bullets[i].height)
				{
					Bullets.shift();
				}
			}
		}
		
		//プレイヤーの移動
		private function MovePlayer():void
		{
			if (keyBuf[Keyboard.SHIFT] == true)
			{
				Spead = Player.getSpead() / 2;
				trace(Spead);
			}
			else if (keyBuf[Keyboard.SHIFT] == false)
			{
				Spead = Player.getSpead();
			}
			if (keyBuf[Keyboard.LEFT] == true)
			{
				Player.x -= Spead;
			}
			if (keyBuf[Keyboard.UP] == true)
			{
				Player.y -= Spead;
			}
			if (keyBuf[Keyboard.RIGHT] == true)
			{
				Player.x += Spead;
			}
			if (keyBuf[Keyboard.DOWN] == true)
			{
				Player.y += Spead;
			}
		}
	}
	
}
