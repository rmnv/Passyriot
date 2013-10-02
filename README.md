# Passyriot.js

Passyriot.js — jQuery плагин, позволяющий показывать и скрывать пароль за звёздочками.

Работает только с `<input type="password" />`, это позволяет откатиться к обычному полю с паролем, если в браузере отключен JavaScript.

## Особенности
- Работает напрямую с инпутом, не создавая маски поверх него: оформление у поля не может сломаться.
- Сохраняет все аттрибуты поля, включая измененные динамически.
- Сохраняет фокус при переключении.
- Сохраняет каретку и выделенные участки.
- Может прятать пароль при потере фокуса.
- По сути, `type="password"` меняется на `type="text"` и обратно.
- Автоматически инициализируется, собирая опции из data-атрибутов.

## Базовое использование
1. Подключите jQuery (1.7.2 и новее), passyriot.js и passyriot.css
2. Добавьте к полю с паролем класс `passyriot`

	    <head>
    	    <script src="jquery.js"></script>
			<link rel="stylesheet" href="passyriot.css" />
			<script src="passyriot.js">
		</head>
		<body>
			<input type="password" class="passyriot" />
		</body>
		
## Инициализация
У Passyriot.js есть два способа инициализации:

1. Автоматический: плагин сам начинает работать на нужных полях с классом `passyriot`.
2. Привычный для jQuery: `$('.some-class').passyriot()`. В этом случае можно использовать любой айди, или класс, кроме зарезервированного `.passyriot`.


## Опции
- `defaulttype`: `"password"` / `"text"` — показывать или скрывать символы по-умолчанию
- `titleofshow`: `"Show simbols"` — подсказка на глазике
- `titleofhide`: `"Hide simbold"`
- `iconclass`: `passy__icon` — класс иконки
- `iconopenedclass`: `passy__icon_opened`
- `iconclosedclass`: `passy__icon_closed`
- `hideonblur`: `false` / `true` — прятать символы при потере фокуса (приоритет над defaulttype)
- `auto`: `true` / `false` — автоматическая инициализация

Опции можно прописывать как в data-атрибутах, так и в массиве, передающимся плагину. У data-атрибутов приоритет будет выше.

Пример с data-атрибутами:

	<input type="password" class="passyriot" data-titleofshow="Показать символы" data-defaulttype="password" />

Пример с передачей массива:

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