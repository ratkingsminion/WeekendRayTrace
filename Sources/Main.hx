package;

import kha.System;

class Main {
	public static function main() {
		System.start({title: "Project", width: 1024, height: 768}, function (win:kha.Window) {
			new Project();
		});
	}
}
