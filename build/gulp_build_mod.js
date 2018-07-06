var gulp     = require('gulp')
var gulpUtil = require('gulp-util')

gulp.task('log1', () => {
  return new Promise(function(resolve, reject) {
    gulpUtil.log("== My First Log Task ==");
    resolve();
  });

});

gulp.task('log2', () => {
  return new Promise(function(resolve, reject) {
    gulpUtil.log("== My Second Log Task ==");
    resolve();
  });
});

gulp.task("main", gulp.series(
  'log1',
  'log2'
));
