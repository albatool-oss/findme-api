<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| هنا نضع جميع المسارات (routes) الخاصة بالـ API
| هذه المسارات تُحمّل تلقائياً عند استخدام "api.php"
|
*/

// اختبار بسيط للتأكد أن الـ API تعمل
Route::get('/test', function () {
    return response()->json(['message' => 'API تعمل بنجاح ✅']);
});

// مسارات التسجيل وتسجيل الدخول
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);