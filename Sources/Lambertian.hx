package;

class Lambertian implements Material {
	public var albedo:Vec3;

	//

	public function new(a:Vec3) {
		this.albedo = a;
	}

	public function scatter(rIn:Ray, rec:HitRecord, attenuation:Vec3, scattered:Ray):Bool {
		var target = rec.p + rec.normal + Project.randomInUnitSphere();
		scattered.set(rec.p, target - rec.p, true);
		attenuation.set(albedo);
		return true;
	}
}