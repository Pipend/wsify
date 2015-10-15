require! \gulp
require! \gulp-livescript
require! \gulp-mocha
{instrument, hook-require, write-reports} = (require \gulp-livescript-istanbul)!
require! \gulp-nodemon
require! \livescript

gulp.task \server, ->
    gulp-nodemon do
        exec-map: ls: \lsc
        ext: \ls
        ignore: <[.gitignore gulpfile.ls notes *.sublime-project README.md rough public/*]>
        script: \./server.ls
    
gulp.task \coverage, ->
    gulp.src <[server.ls]>
    .pipe instrument!
    .pipe hook-require!

    gulp.src <[./test/index.ls]>
    .pipe gulp-mocha!
    .pipe write-reports!
    .on \finish, -> process.exit!

gulp.task \default, <[server]>