package;

class Sphere implements Hitable {
	public var center:Vec3;
	public var radius:Float;
	public var material:Material;

	//

	public function new(center:Vec3, radius:Float, material:Material) {
		this.center = center;
		this.radius = radius;
		this.material = material;
	}

	public function hit(r:Ray, tMin:Float, tMax:Float, rec:HitRecord):Bool {
		var oc = r.origin() - center;
		var a = r.direction().dot(r.direction());
		var b = oc.dot(r.direction());
		var c = oc.dot(oc) - radius * radius;
		var discriminant = b * b - a * c;
		if (discriminant > 0.0) {
			var temp = (-b - Math.sqrt(discriminant)) / a;
			if (temp < tMax && temp > tMin) {
				rec.t = temp;
				rec.p.set(r.pointAtParameter(rec.t));
				rec.normal.set((rec.p - center) / radius);
				rec.material = material;
				return true;
			}
			temp = (-b + Math.sqrt(discriminant)) / a;
			if (temp < tMax && temp > tMin) {
				rec.t = temp;
				rec.p.set(r.pointAtParameter(rec.t));
				rec.normal.set((rec.p - center) / radius);
				rec.material = material;
				return true;
			}
		}
		return false;
	}
}