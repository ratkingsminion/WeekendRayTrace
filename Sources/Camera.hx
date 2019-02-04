package;

class Camera {
	public var origin = Vec3.zero();
	public var lowerLeftCorner = Vec3.zero();
	public var horizontal = Vec3.zero();
	public var vertical = Vec3.zero();
	//
	var halfHeight:Float;
	var halfWidth:Float;
	var lookat = Vec3.zero();
	var vup = Vec3.zero();
	var lensRadius:Float;
	var addFocusDist:Float;
	var u = Vec3.zero();
	var v = Vec3.zero();
	var w = Vec3.zero();

	//

	public function new(vfov:Float, aspect:Float, aperture:Float, addFocusDist:Float) {
		this.lensRadius = aperture / 2.0;
		this.addFocusDist = addFocusDist;
		var theta = vfov * Math.PI / 180.0;
		halfHeight = Math.tan(theta / 2.0);
		halfWidth = aspect * halfHeight;
		setVectors(Vec3.create(0.0, 0.0, 0.0), Vec3.create(0.0, 0.0, -1.0), Vec3.create(0.0, 1.0, 0.0));
	}

	public inline function setAperture(aperture:Float) {
		this.lensRadius = aperture / 2.0;
	}

	public inline function setLookFrom(lookfrom:Vec3) {
		setVectors(lookfrom, this.lookat, this.vup);
	}

	public inline function setLookAt(lookat:Vec3) {
		setVectors(this.origin, lookat, this.vup);
	}

	public inline function setUp(vup:Vec3) {
		setVectors(this.origin, this.lookat, vup);
	}

	public function setVectors(lookfrom:Vec3, lookat:Vec3, vup:Vec3) {
		this.origin.set(lookfrom);
		this.lookat.set(lookat);
		this.vup.set(vup);
		w.set(lookfrom - lookat).normalize();
		u.set(Vec3.crossNew(vup, w)).normalize();
		v.set(Vec3.crossNew(w, u));
		var focusDist = (lookfrom - lookat).length() + addFocusDist;
		lowerLeftCorner.set(origin - focusDist * (halfWidth * u + halfHeight * v + w));
		horizontal.set(2.0 * halfWidth * focusDist * u);
		vertical.set(2.0 * halfHeight * focusDist * v);
	}

	public inline function getRay(s:Float, t:Float):Ray {
		var rd = lensRadius * Project.randomInUnitDisc();
		var offset = u * rd.x() + v * rd.y();
		return new Ray(origin + offset, lowerLeftCorner + s * horizontal + t * vertical - origin - offset, false);
	}
}