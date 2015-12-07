window.onload = function() {

  var loginButton = document.getElementById('login_btn');
  loginButton.addEventListener('click', function() {
    window.location.href = "/login";
  });

  var logoutButton = document.getElementById('logout_btn');
  logoutButton.addEventListener('click', function() {
    window.location.href = "/logout";
  });


}
