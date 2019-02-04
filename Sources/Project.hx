package;

import kha.Scaler;
import kha.Image;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Project {
	var scale = 5.0;
	var nx = 150; // picture size
	var ny = 75;
	var ns = 15; // samples
	var md = 30; // max depth

	//

	var aperture:Float;
	var img:Image;
	var time:Float;
	var lastTime:Float;
	var dt:Float;
	var cam:Camera;
	var world:HitableList;

	//

	public static function randomInUnitSphere():Vec3 {
		var p = Vec3.zero();
		do {
			p.setElems(2.0 * Math.random() - 1.0, 2.0 * Math.random() - 1.0, 2.0 * Math.random() - 1.0);
		} while (p.sqrLength() >= 1.0);
		return p;
	}

	public static function randomInUnitDisc():Vec3 {
		var p = Vec3.zero();
		do {
			p.setElems(2.0 * Math.random() - 1.0, 2.0 * Math.random() - 1.0, 0.0);
		} while (p.sqrLength() >= 1.0);
		return p;
	}

	public static function schlick(cosine:Float, refIdx:Float):Float {
		var r0 = (1.0 - refIdx) / (1.0 + refIdx);
		r0 *= r0;
		return r0 + (1.0 - r0) * Math.pow(1.0 - cosine, 5.0);
	}

	//

	public function new() {
		kha.Assets.loadEverything(function() {
			aperture = 0.5;
			cam = new Camera(30.0, nx / ny, aperture, 0.0);

			world = new HitableList([
					new Sphere(Vec3.create(0.0, 0.0, -1.0), 0.5, new Lambertian(Vec3.create(0.8, 0.3, 0.3))),
					new Sphere(Vec3.create(0.0, -100.5, -1.0), 100.0, new Lambertian(Vec3.create(0.8, 0.8, 0.0))),
					new Sphere(Vec3.create(1.0, 0.0, -1.0), 0.5, new Metal(Vec3.create(0.8, 0.6, 0.2), 0.3)),
					new Sphere(Vec3.create(-1.0, 0.0, -1.0), 0.5, new Dielectric(1.5)), // (Vec3.create(0.8, 0.8, 0.8), 0.9))
					new Sphere(Vec3.create(-1.0, 0.0, -1.0), -0.45, new Dielectric(1.5))
				]);

			img = Image.createRenderTarget(Std.int(kha.System.windowWidth() / scale), Std.int(kha.System.windowHeight() / scale));

			System.notifyOnFrames(render);
			Scheduler.addTimeTask(update, 0, 1/60.0);
			kha.input.Mouse.get().notify(mouseDown, null, null, null, null);
		});
	}

	function update() {
		time = kha.Scheduler.time();
		dt = time - lastTime;
		lastTime = time;

		cam.setLookFrom(Vec3.create(
			Math.sin(time * 0.75) * 4.0,
			Math.sin(time * 0.33) * 0.5 + 1.5,
			Math.cos(time * 0.75) * 4.0
		));
	}

	function color(r:Ray, world:Hitable, depth:Int):Vec3 {
		var scattered = new Ray(Vec3.zero(), Vec3.zero(), false);
		var attenuation = Vec3.zero();
		var rec = { t:0.0, p:Vec3.zero(), normal:Vec3.zero(), material:null };
		if (world.hit(r, 0.001, 100000000.0, rec)) {
			if (depth < md && rec.material.scatter(r, rec, attenuation, scattered)) {
				return attenuation * color(scattered, world, depth + 1);
			}
			return Vec3.zero();
		}
		// sky in the back
		var unitDir = r.direction().normalize();
		var t = 0.5 * (unitDir.y() + 1.0);
		return (1.0 - t) * Vec3.one() + t * Vec3.create(0.5, 0.7, 1.0);
	}

	function render(fb: Array<Framebuffer>) {
		var g1 = img.g1;
		var sw = img.width;
		var sh = img.height;
		var pwx = Std.int((sw - nx) * 0.5);
		var pwy = Std.int((sh - ny) * 0.5) + ny;

		g1.begin();
		for (y in 0...ny) {
			for (x in 0...nx) {
				var col = Vec3.zero();
				for (s in 0...ns) {
					var u = (x + Math.random()) / nx;
					var v = (y + Math.random()) / ny;
					var r = cam.getRay(u, v);
					col += color(r, world, 0);
				}
				col /= ns;
				col.setElems(Math.sqrt(col.x()), Math.sqrt(col.y()), Math.sqrt(col.z())); // "gamma correction"
				g1.setPixel(pwx + x, pwy - y, Color.fromFloats(col[0], col[1], col[2]));
			}
		}
		g1.end();

		var framebuffer = fb[0];
		framebuffer.g2.begin();
		Scaler.scale(img, framebuffer, System.screenRotation);
		framebuffer.g2.end();
	}

	//

	function mouseDown(btn:Int, x:Int, y:Int) {
		aperture = 0.5 - aperture;
		cam.setAperture(aperture);
	}
}
