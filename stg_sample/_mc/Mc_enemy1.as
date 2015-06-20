package _mc 
{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Mc_enemy1 extends MovieClip 
	{
		
		//出現位置（あくまでテスト中のみ）
		private const pt:Point = new Point(130,100);

		//ヒットポイント
		public static var hitPoint:int = 10;

		public function Mc_enemy1() 
		{
			// constructor code
		}

		public function getPoint():Point
		{
			return pt;
		}
		
		public function setEnemyHP(HP:int):void
		{
			hitPoint = HP;
		}
		
		public function getEnemyHP():int
		{
			return hitPoint;
		}
	}
	
}
