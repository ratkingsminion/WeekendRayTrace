package;

class Metal implements Material {
	public var albedo:Vec3;
	public var fuzz:Float;

	//

	public function new(a:Vec3, f:Float) {
		this.albedo = a;
		this.fuzz = f < 1.0 ? f : 1.0;
	}

	public function scatter(rIn:Ray, rec:HitRecord, attenuation:Vec3, scattered:Ray):Bool {
		var reflected = Vec3.reflectNew(rIn.direction().normalizeNew(), rec.normal);
		scattered.set(rec.p, reflected + fuzz * Project.randomInUnitSphere(), false);
		attenuation.set(albedo);
		return scattered.direction().dot(rec.normal) > 0.0;
	}
}