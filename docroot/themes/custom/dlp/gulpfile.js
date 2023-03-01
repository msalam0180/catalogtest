var gulp = require('gulp');
var postcss = require('gulp-postcss');
var sass = require('gulp-sass');

var autoprefixer = require('autoprefixer');
var sourcemaps = require('gulp-sourcemaps');

//var wc = require('gulp-wc');

var paths = {
  sass: 'assets/sass',
  buildCss: 'css'
};

//compile sass
gulp.task('sass', function () {
    var processors = [
        autoprefixer
    ];
    return gulp.src(paths.sass  + '/**/*.scss')
    	.pipe(sourcemaps.init())
        .pipe(sass().on('error', sass.logError))
        .pipe(postcss(processors))
        .pipe(sourcemaps.write('./maps'))
        .pipe(gulp.dest(paths.buildCss));
});

//Count Lines in css files
// gulp.task('count', async function() {
//   return gulp.src([paths.buildCss + '/*.css'])
//   .pipe(wc());
// });

//TODO: add image optimization

//TODO: add JS optimization and concatenation

// Watch Files For Changes, and reloads browser window or SCSS change.
gulp.task('watch', function() {
  gulp.watch(paths.sass  + '/**/*.scss', gulp.series('sass'));
});
