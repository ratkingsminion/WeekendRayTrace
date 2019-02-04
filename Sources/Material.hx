package;

interface Material {
	public function scatter(rIn:Ray, rec:HitRecord, attenuation:Vec3, scattered:Ray):Bool;
}