package _mc {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class Mc_player extends MovieClip {
		
		//初期位置
		private const point_x:int = 260;
		private const point_y:int = 720;
		
		//ムーブスピード
		private const spead:int = 8;
		
		//弾速
		private const bulletSpead:int = 10;
		
		//最大弾数
		private const MaxBullet:int = 20;
		
		//弾のウェイト
		private const BulletWait:int = 300;
		public function Mc_player() {
			// constructor code
		}
		
		//初期位置
		public function getPoint():Point
		{
			var pt:Point = new Point(point_x, point_y);
			return pt;
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
			return MaxBullet;
		}
		
		//弾のウェイト
		public function getBulletWait():int
		{
			return BulletWait;
		}
	}
	
}
