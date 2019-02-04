package;

class HitableList implements Hitable {
	public var list:Array<Hitable>;
	public var listSize:Int;
	//

	public function new (l:Array<Hitable>) {
		this.list = l;
		this.listSize = l.length;
	}

	public function hit(r:Ray, tMin:Float, tMax:Float, rec:HitRecord):Bool {
		var hitAnything = false;
		var closestSoFar = tMax;
		for (i in 0...listSize) {
			if (list[i].hit(r, tMin, closestSoFar, rec)) {
				hitAnything = true;
				closestSoFar = rec.t;
			}
		}
		return hitAnything;
	}
}