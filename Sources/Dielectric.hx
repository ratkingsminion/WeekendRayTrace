package;

class Dielectric implements  Material {
	public var refIdx:Float;

	//

	public function new(ri:Float) { refIdx = ri; }

	public function scatter(rIn:Ray, rec:HitRecord, attenuation:Vec3, scattered:Ray):Bool {
		var outwardNormal = rec.normal.clone();
		var reflected = Vec3.reflectNew(rIn.direction(), rec.normal);
		var niOverNt:Float;
		attenuation.setElems(1.0, 1.0, 1.0);
		var reflectProb:Float;
		var cosine:Float;
		if (rIn.direction().dot(rec.normal) > 0.0) {
			outwardNormal.negate();
			niOverNt = refIdx;
			cosine = refIdx * rIn.direction().dot(rec.normal) / rIn.direction().length();
		}
		else {
			niOverNt = 1.0 / refIdx;
			cosine = -rIn.direction().dot(rec.normal) / rIn.direction().length();
		}
		var refracted = Vec3.zero();
		if (Vec3.refract(rIn.direction(), outwardNormal, niOverNt, refracted)) {
			reflectProb = Project.schlick(cosine, refIdx);
		}
		else {
			reflectProb = 1.0;
		}
		if (Math.random() < reflectProb) {
			scattered.set(rec.p, reflected);
		}
		else {
			scattered.set(rec.p, refracted);
		}
		return true;
	}
}