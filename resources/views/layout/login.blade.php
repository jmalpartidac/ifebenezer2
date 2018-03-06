
<link rel="stylesheet" type="text/css" href="css/login.css">
<script type="js/login.js"></script>
<div class="login-page">
  <div class="form">
    <form class="login-form" method="POST" action="{{ url('/') }}/login">
      <input name="email" type="text" placeholder="Email"/>
      <input name="password" type="password" placeholder="password"/>
      <button>login</button>
      {{ csrf_field() }}
    </form>
  </div>
  <div class="login-logo">
  	<img src="img/logo.png" alt="">
  </div>
</div>

<!-- {{ bcrypt('password') }}  -->