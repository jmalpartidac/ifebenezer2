<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Auth;
use Illuminate\Http\Request;
use File;
use Session;

class LoginController extends Controller
{
    use AuthenticatesUsers;

    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    protected $redirectTo = '/home';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }

    public function mostrarLogin(Request $request){

        if ($request->isMethod('get')) {
            return view('layout.login');
        }else{
            $credenciales = [
                'email' => $request->input('email'),
                'password' => $request->input('password')
            ];

            if (Auth::attempt($credenciales)) {

                $path = storage_path('app/'.Auth::user()->imagen);
                $type = File::mimeType($path);
                $data = file_get_contents($path);
                $base64 = 'data:image/' . $type . ';base64,' . base64_encode($data);

                $this->pedidosPendientes();
                $this->ventasPorConfirmar();

                Session::put('imagen', $base64);
                
                Session::put('flg_msj','Usted Inicio Sesion Correctamente');
                Session::put('flg_tipo','1');
                return redirect('home');

            }else{
                
                Session::put('flg_msj','Email ó Password Incorrecto.');
                Session::put('flg_tipo','2');
                return redirect('/login');
            }

        }
        
    }

    public function logout(Request $request) { 
        Auth::logout(); 
        return redirect('/login'); 
    }

}
