-- bootstrap.lua

lued.html = lued.html or {}


function lued.html.bootstrap_navbar(dd)
local str = [[
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <a class="navbar-brand" href="#">CompanyName</a>

  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav ml-auto">
      <li class="nav-item">
        <a class="nav-link" href="#">Home</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">About</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">Products</a>

      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" data-toggle="dropdown">
          Products
        </a>
        <div class="dropdown-menu">
          <a class="dropdown-item" href="#">Product 1</a>
          <a class="dropdown-item" href="#">Product 2</a>
          <div class="dropdown-divider"></div>
          <a class="dropdown-item" href="#">Another Product</a>
        </div>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">Contact</a>
      </li>
    </ul>
  </div>
</nav>

]]
if dd then return str end
lued.ins_str_after(str, "CompanyName" , 0, 1)
end -- lued.html.bootstrap_navbar


function lued.html.bootstrap_jumbotron(dd)
str = [[
<div class="jumbotron">
    <h1 class="display-4">Nice Title</h1>
    <p class="lead">Lorem ipsum dolor sit amet, consectetur adipiscing elit, 
      sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut 
      enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut 
      aliquip ex ea commodo consequat.
    </p>
    <p class="lead">
      <a class="btn btn-primary btn-lg" href="#" role="button">Learn more</a>
    </p>
</div>

]]
if dd then return str end
lued.ins_str_after(str, "Nice Title" , 0, 1)
end


function lued.html.bootstrap_3col(dd)
str = [[
<div class="row">
    <div class="col-sm-12 col-md-4 mb-4">
        <div class="card">
            <div class="card-body text-center">
                <h5 class="card-title">Card title</h5>
                <p class="card-text">Some quick example text to build on the card title</p>
                <a href="#" class="card-link">Another link</a>
            </div>
        </div>
    </div>
    <div class="col-sm-12 col-md-4 mb-4">
        <div class="card">
            <div class="card-body text-center">
                <h5 class="card-title">Card title</h5>
                <p class="card-text">Some quick example text to build on the card title</p>
                <a href="#" class="card-link">Another link</a>
            </div>
        </div>
    </div>
    <div class="col-sm-12 col-md-4 mb-4">
        <div class="card">
            <div class="card-body text-center">
                <h5 class="card-title">Card title</h5>
                <p class="card-text">Some quick example text to build on the card title</p>
                <a href="#" class="card-link">Another link</a>
            </div>
        </div>
    </div>
</div>

]]
if dd then return str end
lued.ins_str_after(str, "Card title" , 0, 1)
end


function lued.html.bootstrap_1col1side(dd)
local str = [[
<div class="row mt-sm-4 mt-md-0">
    <div class="col-sm-12 col-md-8 text-sm-center text-md-left">
        <h3>An important heading</h3>
        <p class="lead">A subheading can go here, which is larger and gray.</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
          eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim 
          ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut 
          aliquip ex ea commodo consequat. Duis aute irure dolor in 
          reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
          pariatur.
        </p>
        <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris 
          nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in 
          reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
          pariatur.
        </p>
    </div>

    <div class="col-sm-12 col-md-4">
    <div class="col-sm-12 col-md-4">
        <h3 class="mb-4">Secondary Menu</h3>

        <ul class="nav flex-column nav-pills">
            <li class="nav-item">
                <a class="nav-link active" href="#">Active</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#">Link</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#">Link</a>
            </li>
            <li class="nav-item">
                <a class="nav-link disabled" href="#">Disabled</a>
            </li>
        </ul>
    </div>
</div>

]]
if dd then return str end
lued.ins_str_after(str, "Card title" , 0, 1)
end


function lued.html.bootstrap_container(dd)
local str = [[
  <div class="container">
]] ..
lued.html.bootstrap_navbar(true) .. 
lued.html.bootstrap_jumbotron(true) ..
lued.html.bootstrap_3col(true) ..
lued.html.bootstrap_1col1side(true) ..
[[
  </div>
]]
if dd then return str end
lued.ins_str_after(str, "container" , 0, 1)
end


function lued.html.bootstrap_cdn()
local str = [[
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

    <title>TITLE OF PAGE</title>
  </head>
  <body>
]] .. lued.html.bootstrap_container(true) .. [[
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
  </body>
</html>
]]


lued.ins_str_after(str, "TITLE OF PAGE" , 0, 1)

end -- lued.html.bootstrap_cdn


function lued.html.bootstrap_local()
local str = [[
<!DOCTYPE html>
<html class="no-js" lang="en">
    <head>
        <title>Bootstrap 4 Layout</title>
        <meta http-equiv="x-ua-compatible" content="ie=edge">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway:400,800">
        <link rel='stylesheet' href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="/css/bootstrap.css">
        <link rel="stylesheet" href="/css/styles.css">
    </head>

    <body>
]] .. lued.html.bootstrap_container(true) .. [[
        <script src="/js/jquery.min.js"></script>
        <script src="/js/popper.min.js"></script>
        <script src="/js/bootstrap.min.js"></script>
    </body>
</html>
]]
lued.ins_str_after(str, "TITLE OF PAGE" , 0, 1)
end -- lued.html.boot_local


function bootstrap_gulpfile()
str = [[
var gulp        = require('gulp');
var browserSync = require('browser-sync').create();
var sass        = require('gulp-sass');

// Compile sass into CSS & auto-inject into browsers
gulp.task('sass', function() {
    return gulp.src(['node_modules/bootstrap/scss/bootstrap.scss', 'src/scss/*.scss'])
        .pipe(sass())
        .pipe(gulp.dest("src/css"))
        .pipe(browserSync.stream());
});

// Move the javascript files into our /src/js folder
gulp.task('js', function() {
    return gulp.src(['node_modules/bootstrap/dist/js/bootstrap.min.js', 'node_modules/jquery/dist/jquery.min.js', 'node_modules/popper.js/dist/umd/popper.min.js'])
        .pipe(gulp.dest("src/js"))
        .pipe(browserSync.stream());
});

// Static Server + watching scss/html files
gulp.task('serve', ['sass'], function() {

    browserSync.init({
        server: "./src"  
    });

    gulp.watch(['node_modules/bootstrap/scss/bootstrap.scss', 'src/scss/*.scss'], ['sass']);
    gulp.watch("src/*.html").on('change', browserSync.reload);
});

gulp.task('default', ['js','serve']);
]]
lued.ins_str_after(str, "TITLE OF PAGE" , 0, 1)
end


function lued.html.self_closing(tag)
  lued.ins_str('<'..tag.."/>")  
end

function lued.html.anchor(tag)
  local link = "#"
  if tag == "ah" then
    link = "http://"
  elseif tag == "as" or tag == "ahs" then
    link = "https://"
  end
  lued.ins_str_after('<a href="' .. link .. '">hi</a>', link)
end

function lued.html.tag(t)
  lued.ins_str_after('<'..t..">TEXT</"..t..">", "TEXT")
end


-- ============================================================================

lued.snippets.html = lued.snippets.html or {}
lued.def_snippet(lued.snippets.html, "boot bcdn"     , lued.html.bootstrap_cdn)
lued.def_snippet(lued.snippets.html, "boot2 blocal"  , lued.html.bootstrap_local)
lued.def_snippet(lued.snippets.html, "bootg"         , lued.html.boot_gulpfile)

