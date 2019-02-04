package;

abstract Vec3(Array<Float>) from Array<Float> {
	function new() { this = [0.0, 0.0, 0.0]; }

	public inline static function zero() { return new Vec3(); }
	public inline static function one() { return create(1.0, 1.0, 1.0); }
	public inline static function create(e0, e1, e2) { var v = new Vec3(); v[0] = e0; v[1] = e1; v[2] = e2; return v; }

	public inline function x() { return this[0]; }
	public inline function y() { return this[1]; }
	public inline function z() { return this[2]; }
	public inline function r() { return this[0]; }
	public inline function g() { return this[1]; }
	public inline function b() { return this[2]; }

	public inline function clone():Vec3 {
		return create(this[0], this[1], this[2]);
	}

	public inline function set(other:Vec3):Vec3 {
		this[0] = other[0];
		this[1] = other[1];
		this[2] = other[2];
		return this;
	}

	public inline function setElems(e0:Float, e1:Float, e2:Float):Vec3 {
		this[0] = e0;
		this[1] = e1;
		this[2] = e2;
		return this;
	}

	@:arrayAccess
	public inline function getElem(index:Int):Float {
		return this[index];
	}

	@:arrayAccess
	public inline function setElem(index:Int, value:Float):Float {
		this[index] = value;
		return value;
	}

	@:op(-A)
	public inline function negateNew():Vec3 {
		return create(-this[0], -this[1], -this[2]);
	}
	public inline function negate():Vec3 {
		this[0] = -this[0];
		this[1] = -this[1];
		this[2] = -this[2];
		return this;
	}

	@:op(A + B)
	public static function addNew(a:Vec3, b:Vec3):Vec3 {
		return create(a.x() + b.x(), a.y() + b.y(), a.z() + b.z());
	}

	@:op(A - B)
	public static function subNew(a:Vec3, b:Vec3):Vec3 {
		return create(a.x() - b.x(), a.y() - b.y(), a.z() - b.z());
	}

	@:op(A * B)
	public static function mulNew(a:Vec3, b:Vec3):Vec3 {
		return create(a.x() * b.x(), a.y() * b.y(), a.z() * b.z());
	}

	@:op(A / B)
	public static function divNew(a:Vec3, b:Vec3):Vec3 {
		return create(a.x() / b.x(), a.y() / b.y(), a.z() / b.z());
	}

	@:op(A * B)
	public static function scalarMulNew(a:Float, b:Vec3):Vec3 {
		return create(a * b.x(), a * b.y(), a * b.z());
	}

	@:op(A * B)
	public static function mulScalarNew(a:Vec3, b:Float):Vec3 {
		return create(a.x() * b, a.y() * b, a.z() * b);
	}

	@:op(A / B)
	public static function divScalarNew(a:Vec3, b:Float):Vec3 {
		return create(a.x() / b, a.y() / b, a.z() / b);
	}

	//public inline static function dotStatic(a:Vec3, b:Vec3):Float {
	//	return a.x() * b.x() + a.y() * b.y() + a.z() * b.z();
	//}

	public inline static function crossNew(a:Vec3, b:Vec3):Vec3 {
		return create(a.y() * b.z() - a.z() * b.y(),
					-(a.x() * b.z() - a.z() * b.x()),
					  a.x() * b.y() - a.y() * b.x());
	}

	public inline static function reflectNew(v:Vec3, n:Vec3):Vec3 {
		return v - 2.0 * v.dot(n) * n;
	}

	public static function refract(v:Vec3, n:Vec3, niOverNt:Float, refracted:Vec3):Bool {
		var uv = v.normalizeNew();
		var dt = uv.dot(n);
		var discriminant = 1.0 - niOverNt * niOverNt * (1.0 - dt * dt);
		if (discriminant > 0.0) {
			refracted.set(niOverNt * (uv - n * dt) - n * Math.sqrt(discriminant));
			return true;
		}
		return false;
	}

	@:op(A += B)
	public inline function add(other:Vec3):Vec3 {
		this[0] += other[0];
		this[1] += other[1];
		this[2] += other[2];
		return this;
	}

	@:op(A -= B)
	public inline function sub(other:Vec3):Vec3 {
		this[0] -= other[0];
		this[1] -= other[1];
		this[2] -= other[2];
		return this;
	}

	@:op(A *= B)
	public inline function mul(other:Vec3):Vec3 {
		this[0] *= other[0];
		this[1] *= other[1];
		this[2] *= other[2];
		return this;
	}

	@:op(A /= B)
	public inline function div(other:Vec3):Vec3 {
		this[0] /= other[0];
		this[1] /= other[1];
		this[2] /= other[2];
		return this;
	}

	@:op(A *= B)
	public inline function mulScalar(scalar:Float):Vec3 {
		this[0] *= scalar;
		this[1] *= scalar;
		this[2] *= scalar;
		return this;
	}

	@:op(A /= B)
	public inline function divScalar(scalar:Float):Vec3 {
		this[0] /= scalar;
		this[1] /= scalar;
		this[2] /= scalar;
		return this;
	}

	public inline function dot(other:Vec3):Float {
		return x() * other.x() + y() * other.y() + z() * other.z();
	}

	public inline function cross(other:Vec3):Vec3 {
		return create(y() * other.z() - z() * other.y(),
					-(x() * other.z() - z() * other.x()),
					  x() * other.y() - y() * other.x());
	}

	public inline function length():Float {
		return Math.sqrt(this[0] * this[0] + this[1] * this[1] + this[2] * this[2]);
	}

	public inline function sqrLength():Float {
		return this[0] * this[0] + this[1] * this[1] + this[2] * this[2];
	}

	public inline function normalize():Vec3 {
		var il = 1.0 / length();
		this[0] *= il; this[1] *= il; this[2] *= il;
		return this;
	}

	public inline function normalizeNew():Vec3 {
		var il = 1.0 / length();
		return create(this[0] * il, this[1] * il, this[2] * il);
	}

	public function toString():String {
		return '(${this[0]}, ${this[1]}, ${this[2]})';
	}
}