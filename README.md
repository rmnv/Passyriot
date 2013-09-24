# Passyriot.js

Passyriot.js — jQuery плагин, позволяющий показывать и скрывать пароль за звёздочками.

Работает только с `<input type="password" />`. Это позволяет откатиться к обычному полю с паролем, если в браузере отключен JavaScript.

## Особенности
- Работает напрямую с инпутом, не плодя прозрачные маски поверх него.  Благодаря этому никакое оформление у поля не может сломаться.
- Сохраняет все аттрибуты поля, включая измененные динамически.
- Сохраняет фокус при переключении.
- Сохраняет каретку и выделенные участки. **(Исправить)**
- По сути, меняется `type="password"` на `type="text"` и обратно.


## Использование
1. Подключите jQuery, passyriot.js и passyriot.css
2. Добавьте на страницу поле ввода с типом `password`

	    <head>
    	    <script src="jquery-1.10.2.min.js"></script>
			<link rel="stylesheet" href="passyriot.css" />
			<script src="passyriot.js">
			<script>
				$(document).ready(function(){
					$('input[type="password"]').passyriot()
				});		
			</script>
		</head>
		<body>
			<input type="password" />
		</body>


## Опции
	
	var defaultOptions = {
		defaultType: 'password', // or text
		titleOfShow: 'Show simbols',
		titleOfHide: 'Hide simbold',
		hashOnHover: 'passyriot', // хэш-адрес для глазика
		tabindex: false // Можно ли табом перейти на глазик
	};


## АПИ
	input.passyriot('type', 'toggle')
	input.passyriot('type', 'password')
	input.passyriot('type', 'text')
	input.passyriot('destroy')