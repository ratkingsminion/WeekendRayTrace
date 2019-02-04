package;

interface Hitable {
	public function hit(r:Ray, tMin:Float, tMax:Float, rec:HitRecord):Bool;
}