# Passyriot.js

Passyriot.js — jQuery плагин, позволяющий показывать и скрывать пароль за звёздочками.

Работает только с `<input type="password" />`. Это позволяет откатиться к обычному полю с паролем, если в браузере отключен JavaScript.

## Особенности
- Работает напрямую с инпутом, не плодя прозрачные маски поверх него.  Благодаря этому никакое оформление у поля не может сломаться.
- Сохраняет все аттрибуты поля, включая измененные динамически.
- Сохраняет фокус при переключении.
- Сохраняет каретку и выделенные участки. **(Исправить)**
- По сути, меняется `type="password"` на `type="text"` и обратно.


## Базовое использование
1. Подключите jQuery, passyriot.js и passyriot.css
2. Добавьте к вашему полю с паролем класс `passyriot`

	    <head>
    	    <script src="jquery-1.10.2.min.js"></script>
			<link rel="stylesheet" href="passyriot.css" />
			<script src="passyriot.js">
		</head>
		<body>
			<input type="password" class="passyriot" />
		</body>
		
## Инициализация
У Passyriot.js есть два способа инициализации:

1. Автоматический: плагин сам начинает работать на инпутах с классом `passyriot`.
2. Привычный для jQuery: `$('.some-class').passyriot()`. В этом случае можно использовать любой айди, или класс, кроме зарезирвированного `.passyriot`.


## Опции
- `defaulttype`: `"password"` / `"text"` — показывать или скрывать символы по-умолчанию
- `titleofshow`: `"Show simbols"` — всплывающая подсказка на глазике (атрибут `title` у псевдоссылки)
- `titleofhide`: `"Hide simbold"`
- `hashonhover`: `"Passyriot"` — атрибут `href` у псевдоссылки
- `tabindex`: `false` / `true` — можно ли табом перейти на глазик
- `auto`: `true` / `false` — автоматическая инициализация

Опции можно прописывать как в data-атрибутах, так и в массиве, передающимся плагину. У data-атрибутов приоритет будет выше.

Пример с data-атрибутами:

	<input type="password" class="passyriot" data-titleofshow="Показать символы" data-defaulttype="password" />

Пример с привычной передачей массива:

	<script>
	  $(function() {
    	$('input[type="password"]').passyriot({
    		defaulttype: "password",
    		titleofshow: "Показать символы"
    	});
	  });
	</script>
	

## АПИ
	input.passyriot('type', 'toggle')
	input.passyriot('type', 'password')
	input.passyriot('type', 'text')
	input.passyriot('destroy')