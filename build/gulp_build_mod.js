// example https://pastebin.com/embed_iframe/faVj8bXA

var gulp        = require("gulp");
var gulpClean   = require("gulp-clean");
var gulpDebug   = require("gulp-debug");

var fs          = require("fs");

let factorioFolder = process.env.APPDATA + "\\" + fs.readdirSync(process.env.APPDATA).filter(function(d) {return d.indexOf('Factorio') > -1}).join("/");
let modName, modVersion;

gulp.task('log1', () => {
  console.log("\n== Launching Factorio.exe ==");
  console.log("todo\n");

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
    .map((v) => {return parseInt(v);})
    .join(".");

  return new Promise(function(resolve, reject) {
    console.log("   Name    : " + modName    );
    console.log("   Version : " + modVersion );

    resolve();
  });
});



gulp.task("build_remove_old_build", () => {
  console.log("\n== Removing old builds ==");

  return gulp.src(factorioFolder+"\\mods\\"+modName+"_*.zip", {read:false})
             .pipe(gulpDebug())
             .pipe(gulpClean({force:true}));
});



gulp.task("build_create_directory", () => {
  console.log("\n== Build directory ==")

  return gulp.src(["../**/*",
                   "!../**/.*",
                   "!../{build,build/**}",
    ],  {base: '..'})
    .pipe(gulpDebug())
    .pipe(gulp.dest("tmp/" + modName + "_" + modVersion));
});



// Task building the zip file
gulp.task("build_process", gulp.series(
  "build_modinfo",
  "build_remove_old_build",
  "build_create_directory"
));



// Main program
gulp.task("main", gulp.series(
  "build_process",
  "log1"
));
