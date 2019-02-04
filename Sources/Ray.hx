package;

class Ray {
	var A:Vec3;
	var B:Vec3;

	//

	public function new(A:Vec3, B:Vec3, copyVectors = true) {
		this.A = copyVectors ? A.clone() : A;
		this.B = copyVectors ? B.clone() : B;
	}

	public inline function origin():Vec3 { return A; }
	public inline function direction():Vec3 { return B; }

	public inline function set(A:Vec3, B:Vec3, copyVectors = true) {
		this.A = copyVectors ? A.clone() : A;
		this.B = copyVectors ? B.clone() : B;
	}

	public function pointAtParameter(t:Float):Vec3 { return A + (B * t); }
}