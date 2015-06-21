package _mc {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class Mc_player extends MovieClip {
		
		//初期位置（あくまでテスト中ののみ）
		//private const point_x:int = 260;
		//private const point_y:int = 720;
		private const player_pt:Point = new Point(260,720);

		//ムーブスピード
		private const spead:int = 8;
		
		//弾速
		private const bulletSpead:int = 10;
		
		//最大弾数
		private const maxBullet:int = 20;
		
		//弾のウェイト
		private const BulletWait:int = 300;
		
		//Playerの状態(True = 白,Flase = 黒)
		public var playerColor:Boolean = false;

		public function Mc_player():void
		{
			// constructor code
		}
		
		//初期位置
		public function getPoint():Point
		{
			//var pt:Point = new Point(point_x, point_y);
			return player_pt;
		}
		
		//移動速度
		public function getSpead():int
		{
			return spead;
		}
		
		//弾速
		public function getBulletSpead():int
		{
			return bulletSpead;
		}
		
		//最大弾数
		public function getMaxBullet():int
		{
			return maxBullet;
		}
		
		//弾のウェイト
		public function getBulletWait():int
		{
			return BulletWait;
		}

		//色の変更
		public function colorChange():void
		{
			if(playerColor)
			{
				playerColor = false;
				this.gotoAndStop("black");
			}
			else
			{
				playerColor = true;
				this.gotoAndStop("white");
			}
		}
	}
	
}
