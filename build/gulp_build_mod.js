// example https://pastebin.com/embed_iframe/faVj8bXA

var gulp     = require("gulp");
var fs = require("fs");

let modName, modVersion;


gulp.task('log1', () => {
  console.log("== My First Log Task ==");

  return new Promise(function(resolve, reject) {
    resolve();
  });

});



gulp.task("build_modinfo", () => {
  console.log("\n== Extracting mod info ==");

  let modInfo
  try {
    fs.accessSync("../info.json", fs.constants.R_OK | fs.constants.W_OK);
    modInfo = JSON.parse(fs.readFileSync("../info.json").toString());
  } catch (e) {
    throw new Error("The file [info.json] was not readable/writable or may not exist at all please run a map for more than 2 seconds after tab or create the file manually");
  }

  modName    = modInfo.name;
  modVersion = modInfo.version
    .split(".")
    .map(function(v) {return parseInt(v);})
    .join(".");

  return new Promise(function(resolve, reject) {
    console.log("   Name    : " + modName    );
    console.log("   Version : " + modVersion );

    resolve();
  });
});

gulp.task('log2', () => {
  console.log("== My Second Log Task ==");

  return new Promise(function(resolve, reject) {
    resolve();
  });
});




// Task building the zip file
gulp.task("build_process", gulp.series(
  "build_modinfo",
  "log1"
));



// Main program
gulp.task("main", gulp.series(
  "build_process",
  "log2"
));
