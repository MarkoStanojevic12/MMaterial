pragma Singleton

import QtQuick
import MMaterial.UI as UI
import MMaterial.Media as Media

Item{
	id: root

	property string appLogoPath: ""

	readonly property url defaultLightPackConfig: "qrc:/MMaterial/assets/light-icons.default.json"
	readonly property url effectiveLightPackConfig: {
		if (UI.Theme.settings && UI.Theme.settings.lightIconPackConfig !== "")
			return UI.Theme.settings.lightIconPackConfig
		else
			return defaultLightPackConfig
	}

	readonly property Media.LightIconMap light: Media.LightIconMap {
		configUrl: root.effectiveLightPackConfig
		onFontUrlChanged: {
			if (fontUrl && fontUrl.toString() !== "")
				Media.IconFont.source = fontUrl
			else
				Media.IconFont.source = "qrc:/MMaterial/assets/icomoon.ttf"
		}
		Component.onCompleted: {
			if (fontUrl && fontUrl.toString() !== "")
				Media.IconFont.source = fontUrl
		}
	}

	readonly property Media.IconSet heavy: Media.IconSet {
		id: heavyRoot

		readonly property string iconBasePath: "qrc:/MMaterial/Media/assets/svg/"

		logo: Media.IconData { path: root.appLogoPath ? root.appLogoPath : heavyRoot.iconBasePath + "logo.svg"; type: Media.IconData.Heavy }
		accountBalance: Media.IconData { path: heavyRoot.iconBasePath + "account_balance.svg"; type: Media.IconData.Heavy }
		accountBox: Media.IconData { path: heavyRoot.iconBasePath + "account_box.svg"; type: Media.IconData.Heavy }
		accountCircle: Media.IconData { path: heavyRoot.iconBasePath + "account_circle.svg"; type: Media.IconData.Heavy }
		adb: Media.IconData { path: heavyRoot.iconBasePath + "adb.svg"; type: Media.IconData.Heavy }
		add: Media.IconData { path: heavyRoot.iconBasePath + "add.svg"; type: Media.IconData.Heavy }
		addAPhoto: Media.IconData { path: heavyRoot.iconBasePath + "add_a_photo.svg"; type: Media.IconData.Heavy }
		addBox: Media.IconData { path: heavyRoot.iconBasePath + "add_box.svg"; type: Media.IconData.Heavy }
		addBusiness: Media.IconData { path: heavyRoot.iconBasePath + "add_business.svg"; type: Media.IconData.Heavy }
		addCard: Media.IconData { path: heavyRoot.iconBasePath + "add_card.svg"; type: Media.IconData.Heavy }
		addCircle: Media.IconData { path: heavyRoot.iconBasePath + "add_circle.svg"; type: Media.IconData.Heavy }
		addPhotoAlternate: Media.IconData { path: heavyRoot.iconBasePath + "add_photo_alternate.svg"; type: Media.IconData.Heavy }
		addShoppingCart: Media.IconData { path: heavyRoot.iconBasePath + "add_shopping_cart.svg"; type: Media.IconData.Heavy }
		air: Media.IconData { path: heavyRoot.iconBasePath + "air.svg"; type: Media.IconData.Heavy }
		alarm: Media.IconData { path: heavyRoot.iconBasePath + "alarm.svg"; type: Media.IconData.Heavy }
		analytics: Media.IconData { path: heavyRoot.iconBasePath + "analytics.svg"; type: Media.IconData.Heavy }
		android: Media.IconData { path: heavyRoot.iconBasePath + "android.svg"; type: Media.IconData.Heavy }
		apps: Media.IconData { path: heavyRoot.iconBasePath + "apps.svg"; type: Media.IconData.Heavy }
		arrowBack: Media.IconData { path: heavyRoot.iconBasePath + "arrow_back.svg"; type: Media.IconData.Heavy }
		arrowDownward: Media.IconData { path: heavyRoot.iconBasePath + "arrow_downward.svg"; type: Media.IconData.Heavy }
		arrowDropDown: Media.IconData { path: heavyRoot.iconBasePath + "arrow_drop_down.svg"; type: Media.IconData.Heavy }
		arrowDropUp: Media.IconData { path: heavyRoot.iconBasePath + "arrow_drop_up.svg"; type: Media.IconData.Heavy }
		arrowForward: Media.IconData { path: heavyRoot.iconBasePath + "arrow_forward.svg"; type: Media.IconData.Heavy }
		arrowRight: Media.IconData { path: heavyRoot.iconBasePath + "arrow_right.svg"; type: Media.IconData.Heavy }
		atr: Media.IconData { path: heavyRoot.iconBasePath + "atr.svg"; type: Media.IconData.Heavy }
		attachMoney: Media.IconData { path: heavyRoot.iconBasePath + "attach_money.svg"; type: Media.IconData.Heavy }
		autorenew: Media.IconData { path: heavyRoot.iconBasePath + "autorenew.svg"; type: Media.IconData.Heavy }
		backspace: Media.IconData { path: heavyRoot.iconBasePath + "backspace.svg"; type: Media.IconData.Heavy }
		badge: Media.IconData { path: heavyRoot.iconBasePath + "badge.svg"; type: Media.IconData.Heavy }
		barChart: Media.IconData { path: heavyRoot.iconBasePath + "bar_chart.svg"; type: Media.IconData.Heavy }
		barcodeScanner: Media.IconData { path: heavyRoot.iconBasePath + "barcode_scanner.svg"; type: Media.IconData.Heavy }
		batteryChargingFull: Media.IconData { path: heavyRoot.iconBasePath + "battery_charging_full.svg"; type: Media.IconData.Heavy }
		batteryFull: Media.IconData { path: heavyRoot.iconBasePath + "battery_full.svg"; type: Media.IconData.Heavy }
		batteryFullAlt: Media.IconData { path: heavyRoot.iconBasePath + "battery_full_alt.svg"; type: Media.IconData.Heavy }
		bluetooth: Media.IconData { path: heavyRoot.iconBasePath + "bluetooth.svg"; type: Media.IconData.Heavy }
		bookmark: Media.IconData { path: heavyRoot.iconBasePath + "bookmark.svg"; type: Media.IconData.Heavy }
		brush: Media.IconData { path: heavyRoot.iconBasePath + "brush.svg"; type: Media.IconData.Heavy }
		build: Media.IconData { path: heavyRoot.iconBasePath + "build.svg"; type: Media.IconData.Heavy }
		cable: Media.IconData { path: heavyRoot.iconBasePath + "cable.svg"; type: Media.IconData.Heavy }
		cake: Media.IconData { path: heavyRoot.iconBasePath + "cake.svg"; type: Media.IconData.Heavy }
		calculate: Media.IconData { path: heavyRoot.iconBasePath + "calculate.svg"; type: Media.IconData.Heavy }
		calendarMonth: Media.IconData { path: heavyRoot.iconBasePath + "calendar_month.svg"; type: Media.IconData.Heavy }
		calendarToday: Media.IconData { path: heavyRoot.iconBasePath + "calendar_today.svg"; type: Media.IconData.Heavy }
		call: Media.IconData { path: heavyRoot.iconBasePath + "call.svg"; type: Media.IconData.Heavy }
		camera: Media.IconData { path: heavyRoot.iconBasePath + "camera.svg"; type: Media.IconData.Heavy }
		campaign: Media.IconData { path: heavyRoot.iconBasePath + "campaign.svg"; type: Media.IconData.Heavy }
		cancel: Media.IconData { path: heavyRoot.iconBasePath + "cancel.svg"; type: Media.IconData.Heavy }
		cast: Media.IconData { path: heavyRoot.iconBasePath + "cast.svg"; type: Media.IconData.Heavy }
		category: Media.IconData { path: heavyRoot.iconBasePath + "category.svg"; type: Media.IconData.Heavy }
		celebration: Media.IconData { path: heavyRoot.iconBasePath + "celebration.svg"; type: Media.IconData.Heavy }
		chat: Media.IconData { path: heavyRoot.iconBasePath + "chat.svg"; type: Media.IconData.Heavy }
		chatBubble: Media.IconData { path: heavyRoot.iconBasePath + "chat_bubble.svg"; type: Media.IconData.Heavy }
		check: Media.IconData { path: heavyRoot.iconBasePath + "check.svg"; type: Media.IconData.Heavy }
		checkBox: Media.IconData { path: heavyRoot.iconBasePath + "check_box.svg"; type: Media.IconData.Heavy }
		checkBoxOutlineBlank: Media.IconData { path: heavyRoot.iconBasePath + "check_box_outline_blank.svg"; type: Media.IconData.Heavy }
		checkCircle: Media.IconData { path: heavyRoot.iconBasePath + "check_circle.svg"; type: Media.IconData.Heavy }
		chevronLeft: Media.IconData { path: heavyRoot.iconBasePath + "chevron_left.svg"; type: Media.IconData.Heavy }
		chevronRight: Media.IconData { path: heavyRoot.iconBasePath + "chevron_right.svg"; type: Media.IconData.Heavy }
		circle: Media.IconData { path: heavyRoot.iconBasePath + "circle.svg"; type: Media.IconData.Heavy }
		close: Media.IconData { path: heavyRoot.iconBasePath + "close.svg"; type: Media.IconData.Heavy }
		code: Media.IconData { path: heavyRoot.iconBasePath + "code.svg"; type: Media.IconData.Heavy }
		computer: Media.IconData { path: heavyRoot.iconBasePath + "computer.svg"; type: Media.IconData.Heavy }
		construction: Media.IconData { path: heavyRoot.iconBasePath + "construction.svg"; type: Media.IconData.Heavy }
		contactSupport: Media.IconData { path: heavyRoot.iconBasePath + "contact_support.svg"; type: Media.IconData.Heavy }
		contentCopy: Media.IconData { path: heavyRoot.iconBasePath + "content_copy.svg"; type: Media.IconData.Heavy }
		creditCard: Media.IconData { path: heavyRoot.iconBasePath + "credit_card.svg"; type: Media.IconData.Heavy }
		cropFree: Media.IconData { path: heavyRoot.iconBasePath + "crop_free.svg"; type: Media.IconData.Heavy }
		currencyBitcoin: Media.IconData { path: heavyRoot.iconBasePath + "currency_bitcoin.svg"; type: Media.IconData.Heavy }
		darkMode: Media.IconData { path: heavyRoot.iconBasePath + "dark_mode.svg"; type: Media.IconData.Heavy }
		dashboard: Media.IconData { path: heavyRoot.iconBasePath + "dashboard.svg"; type: Media.IconData.Heavy }
		database: Media.IconData { path: heavyRoot.iconBasePath + "database.svg"; type: Media.IconData.Heavy }
		deleteElement: Media.IconData { path: heavyRoot.iconBasePath + "delete.svg"; type: Media.IconData.Heavy }
		deleteForever: Media.IconData { path: heavyRoot.iconBasePath + "delete_forever.svg"; type: Media.IconData.Heavy }
		description: Media.IconData { path: heavyRoot.iconBasePath + "description.svg"; type: Media.IconData.Heavy }
		devices: Media.IconData { path: heavyRoot.iconBasePath + "devices.svg"; type: Media.IconData.Heavy }
		directionsCar: Media.IconData { path: heavyRoot.iconBasePath + "directions_car.svg"; type: Media.IconData.Heavy }
		domain: Media.IconData { path: heavyRoot.iconBasePath + "domain.svg"; type: Media.IconData.Heavy }
		doneAll: Media.IconData { path: heavyRoot.iconBasePath + "done_all.svg"; type: Media.IconData.Heavy }
		download: Media.IconData { path: heavyRoot.iconBasePath + "download.svg"; type: Media.IconData.Heavy }
		downloadForOffline: Media.IconData { path: heavyRoot.iconBasePath + "download_for_offline.svg"; type: Media.IconData.Heavy }
		draw: Media.IconData { path: heavyRoot.iconBasePath + "draw.svg"; type: Media.IconData.Heavy }
		eco: Media.IconData { path: heavyRoot.iconBasePath + "eco.svg"; type: Media.IconData.Heavy }
		edit: Media.IconData { path: heavyRoot.iconBasePath + "edit.svg"; type: Media.IconData.Heavy }
		editNote: Media.IconData { path: heavyRoot.iconBasePath + "edit_note.svg"; type: Media.IconData.Heavy }
		electricBolt: Media.IconData { path: heavyRoot.iconBasePath + "electric_bolt.svg"; type: Media.IconData.Heavy }
		emojiObjects: Media.IconData { path: heavyRoot.iconBasePath + "emoji_objects.svg"; type: Media.IconData.Heavy }
		engineering: Media.IconData { path: heavyRoot.iconBasePath + "engineering.svg"; type: Media.IconData.Heavy }
		error: Media.IconData { path: heavyRoot.iconBasePath + "error.svg"; type: Media.IconData.Heavy }
		euro: Media.IconData { path: heavyRoot.iconBasePath + "euro.svg"; type: Media.IconData.Heavy }
		event: Media.IconData { path: heavyRoot.iconBasePath + "event.svg"; type: Media.IconData.Heavy }
		explore: Media.IconData { path: heavyRoot.iconBasePath + "explore.svg"; type: Media.IconData.Heavy }
		extension: Media.IconData { path: heavyRoot.iconBasePath + "extension.svg"; type: Media.IconData.Heavy }
		familiarFaceAndZone: Media.IconData { path: heavyRoot.iconBasePath + "familiar_face_and_zone.svg"; type: Media.IconData.Heavy }
		fastForward: Media.IconData { path: heavyRoot.iconBasePath + "fast_forward.svg"; type: Media.IconData.Heavy }
		fastRewind: Media.IconData { path: heavyRoot.iconBasePath + "fast_rewind.svg"; type: Media.IconData.Heavy }
		favorite: Media.IconData { path: heavyRoot.iconBasePath + "favorite.svg"; type: Media.IconData.Heavy }
		fileCopy: Media.IconData { path: heavyRoot.iconBasePath + "file_copy.svg"; type: Media.IconData.Heavy }
		filterAlt: Media.IconData { path: heavyRoot.iconBasePath + "filter_alt.svg"; type: Media.IconData.Heavy }
		filterList: Media.IconData { path: heavyRoot.iconBasePath + "filter_list.svg"; type: Media.IconData.Heavy }
		finance: Media.IconData { path: heavyRoot.iconBasePath + "finance.svg"; type: Media.IconData.Heavy }
		fingerprint: Media.IconData { path: heavyRoot.iconBasePath + "fingerprint.svg"; type: Media.IconData.Heavy }
		flag: Media.IconData { path: heavyRoot.iconBasePath + "flag.svg"; type: Media.IconData.Heavy }
		flashOn: Media.IconData { path: heavyRoot.iconBasePath + "flash_on.svg"; type: Media.IconData.Heavy }
		flashlightOn: Media.IconData { path: heavyRoot.iconBasePath + "flashlight_on.svg"; type: Media.IconData.Heavy }
		flight: Media.IconData { path: heavyRoot.iconBasePath + "flight.svg"; type: Media.IconData.Heavy }
		folder: Media.IconData { path: heavyRoot.iconBasePath + "folder.svg"; type: Media.IconData.Heavy }
		folderOpen: Media.IconData { path: heavyRoot.iconBasePath + "folder_open.svg"; type: Media.IconData.Heavy }
		forum: Media.IconData { path: heavyRoot.iconBasePath + "forum.svg"; type: Media.IconData.Heavy }
		gridOn: Media.IconData { path: heavyRoot.iconBasePath + "grid_on.svg"; type: Media.IconData.Heavy }
		gridView: Media.IconData { path: heavyRoot.iconBasePath + "grid_view.svg"; type: Media.IconData.Heavy }
		group: Media.IconData { path: heavyRoot.iconBasePath + "group.svg"; type: Media.IconData.Heavy }
		groupAdd: Media.IconData { path: heavyRoot.iconBasePath + "group_add.svg"; type: Media.IconData.Heavy }
		groups: Media.IconData { path: heavyRoot.iconBasePath + "groups.svg"; type: Media.IconData.Heavy }
		handyman: Media.IconData { path: heavyRoot.iconBasePath + "handyman.svg"; type: Media.IconData.Heavy }
		headphones: Media.IconData { path: heavyRoot.iconBasePath + "headphones.svg"; type: Media.IconData.Heavy }
		hearing: Media.IconData { path: heavyRoot.iconBasePath + "hearing.svg"; type: Media.IconData.Heavy }
		help: Media.IconData { path: heavyRoot.iconBasePath + "help.svg"; type: Media.IconData.Heavy }
		history: Media.IconData { path: heavyRoot.iconBasePath + "history.svg"; type: Media.IconData.Heavy }
		home: Media.IconData { path: heavyRoot.iconBasePath + "home.svg"; type: Media.IconData.Heavy }
		homePin: Media.IconData { path: heavyRoot.iconBasePath + "home_pin.svg"; type: Media.IconData.Heavy }
		image: Media.IconData { path: heavyRoot.iconBasePath + "image.svg"; type: Media.IconData.Heavy }
		imagesmode: Media.IconData { path: heavyRoot.iconBasePath + "imagesmode.svg"; type: Media.IconData.Heavy }
		info: Media.IconData { path: heavyRoot.iconBasePath + "info.svg"; type: Media.IconData.Heavy }
		inventory: Media.IconData { path: heavyRoot.iconBasePath + "inventory.svg"; type: Media.IconData.Heavy }
		inventory2: Media.IconData { path: heavyRoot.iconBasePath + "inventory_2.svg"; type: Media.IconData.Heavy }
		keyboardArrowDown: Media.IconData { path: heavyRoot.iconBasePath + "keyboard_arrow_down.svg"; type: Media.IconData.Heavy }
		keyboardArrowLeft: Media.IconData { path: heavyRoot.iconBasePath + "keyboard_arrow_left.svg"; type: Media.IconData.Heavy }
		keyboardArrowRight: Media.IconData { path: heavyRoot.iconBasePath + "keyboard_arrow_right.svg"; type: Media.IconData.Heavy }
		keyboardArrowUp: Media.IconData { path: heavyRoot.iconBasePath + "keyboard_arrow_up.svg"; type: Media.IconData.Heavy }
		label: Media.IconData { path: heavyRoot.iconBasePath + "label.svg"; type: Media.IconData.Heavy }
		landscape: Media.IconData { path: heavyRoot.iconBasePath + "landscape.svg"; type: Media.IconData.Heavy }
		language: Media.IconData { path: heavyRoot.iconBasePath + "language.svg"; type: Media.IconData.Heavy }
		leaderboard: Media.IconData { path: heavyRoot.iconBasePath + "leaderboard.svg"; type: Media.IconData.Heavy }
		lightMode: Media.IconData { path: heavyRoot.iconBasePath + "light_mode.svg"; type: Media.IconData.Heavy }
		lightbulb: Media.IconData { path: heavyRoot.iconBasePath + "lightbulb.svg"; type: Media.IconData.Heavy }
		link: Media.IconData { path: heavyRoot.iconBasePath + "link.svg"; type: Media.IconData.Heavy }
		list: Media.IconData { path: heavyRoot.iconBasePath + "list.svg"; type: Media.IconData.Heavy }
		localCafe: Media.IconData { path: heavyRoot.iconBasePath + "local_cafe.svg"; type: Media.IconData.Heavy }
		localMall: Media.IconData { path: heavyRoot.iconBasePath + "local_mall.svg"; type: Media.IconData.Heavy }
		locationOn: Media.IconData { path: heavyRoot.iconBasePath + "location_on.svg"; type: Media.IconData.Heavy }
		lock: Media.IconData { path: heavyRoot.iconBasePath + "lock.svg"; type: Media.IconData.Heavy }
		lockOpen: Media.IconData { path: heavyRoot.iconBasePath + "lock_open.svg"; type: Media.IconData.Heavy }
		login: Media.IconData { path: heavyRoot.iconBasePath + "login.svg"; type: Media.IconData.Heavy }
		logout: Media.IconData { path: heavyRoot.iconBasePath + "logout.svg"; type: Media.IconData.Heavy }
		loyalty: Media.IconData { path: heavyRoot.iconBasePath + "loyalty.svg"; type: Media.IconData.Heavy }
		mail: Media.IconData { path: heavyRoot.iconBasePath + "mail.svg"; type: Media.IconData.Heavy }
		manageAccounts: Media.IconData { path: heavyRoot.iconBasePath + "manage_accounts.svg"; type: Media.IconData.Heavy }
		map: Media.IconData { path: heavyRoot.iconBasePath + "map.svg"; type: Media.IconData.Heavy }
		menu: Media.IconData { path: heavyRoot.iconBasePath + "menu.svg"; type: Media.IconData.Heavy }
		mic: Media.IconData { path: heavyRoot.iconBasePath + "mic.svg"; type: Media.IconData.Heavy }
		modeComment: Media.IconData { path: heavyRoot.iconBasePath + "mode_comment.svg"; type: Media.IconData.Heavy }
		monitoring: Media.IconData { path: heavyRoot.iconBasePath + "monitoring.svg"; type: Media.IconData.Heavy }
		moreHoriz: Media.IconData { path: heavyRoot.iconBasePath + "more_horiz.svg"; type: Media.IconData.Heavy }
		moreVert: Media.IconData { path: heavyRoot.iconBasePath + "more_vert.svg"; type: Media.IconData.Heavy }
		movie: Media.IconData { path: heavyRoot.iconBasePath + "movie.svg"; type: Media.IconData.Heavy }
		musicNote: Media.IconData { path: heavyRoot.iconBasePath + "music_note.svg"; type: Media.IconData.Heavy }
		myLocation: Media.IconData { path: heavyRoot.iconBasePath + "my_location.svg"; type: Media.IconData.Heavy }
		navigation: Media.IconData { path: heavyRoot.iconBasePath + "navigation.svg"; type: Media.IconData.Heavy }
		nearMe: Media.IconData { path: heavyRoot.iconBasePath + "near_me.svg"; type: Media.IconData.Heavy }
		nestEcoLeaf: Media.IconData { path: heavyRoot.iconBasePath + "nest_eco_leaf.svg"; type: Media.IconData.Heavy }
		nestRemoteComfortSensor: Media.IconData { path: heavyRoot.iconBasePath + "nest_remote_comfort_sensor.svg"; type: Media.IconData.Heavy }
		nightlight: Media.IconData { path: heavyRoot.iconBasePath + "nightlight.svg"; type: Media.IconData.Heavy }
		notifications: Media.IconData { path: heavyRoot.iconBasePath + "notifications.svg"; type: Media.IconData.Heavy }
		openInNew: Media.IconData { path: heavyRoot.iconBasePath + "open_in_new.svg"; type: Media.IconData.Heavy }
		paid: Media.IconData { path: heavyRoot.iconBasePath + "paid.svg"; type: Media.IconData.Heavy }
		palette: Media.IconData { path: heavyRoot.iconBasePath + "palette.svg"; type: Media.IconData.Heavy }
		pause: Media.IconData { path: heavyRoot.iconBasePath + "pause.svg"; type: Media.IconData.Heavy }
		pauseCircle: Media.IconData { path: heavyRoot.iconBasePath + "pause_circle.svg"; type: Media.IconData.Heavy }
		person: Media.IconData { path: heavyRoot.iconBasePath + "person.svg"; type: Media.IconData.Heavy }
		personAdd: Media.IconData { path: heavyRoot.iconBasePath + "person_add.svg"; type: Media.IconData.Heavy }
		personPin: Media.IconData { path: heavyRoot.iconBasePath + "person_pin.svg"; type: Media.IconData.Heavy }
		pets: Media.IconData { path: heavyRoot.iconBasePath + "pets.svg"; type: Media.IconData.Heavy }
		phoneIphone: Media.IconData { path: heavyRoot.iconBasePath + "phone_iphone.svg"; type: Media.IconData.Heavy }
		photoCamera: Media.IconData { path: heavyRoot.iconBasePath + "photo_camera.svg"; type: Media.IconData.Heavy }
		photoLibrary: Media.IconData { path: heavyRoot.iconBasePath + "photo_library.svg"; type: Media.IconData.Heavy }
		pictureAsPdf: Media.IconData { path: heavyRoot.iconBasePath + "picture_as_pdf.svg"; type: Media.IconData.Heavy }
		pinDrop: Media.IconData { path: heavyRoot.iconBasePath + "pin_drop.svg"; type: Media.IconData.Heavy }
		playArrow: Media.IconData { path: heavyRoot.iconBasePath + "play_arrow.svg"; type: Media.IconData.Heavy }
		playCircle: Media.IconData { path: heavyRoot.iconBasePath + "play_circle.svg"; type: Media.IconData.Heavy }
		power: Media.IconData { path: heavyRoot.iconBasePath + "power.svg"; type: Media.IconData.Heavy }
		printElement: Media.IconData { path: heavyRoot.iconBasePath + "print.svg"; type: Media.IconData.Heavy }
		priorityHigh: Media.IconData { path: heavyRoot.iconBasePath + "priority_high.svg"; type: Media.IconData.Heavy }
		publicElement: Media.IconData { path: heavyRoot.iconBasePath + "public.svg"; type: Media.IconData.Heavy }
		qrCode: Media.IconData { path: heavyRoot.iconBasePath + "qr_code.svg"; type: Media.IconData.Heavy }
		qrCode2: Media.IconData { path: heavyRoot.iconBasePath + "qr_code_2.svg"; type: Media.IconData.Heavy }
		qrCodeScanner: Media.IconData { path: heavyRoot.iconBasePath + "qr_code_scanner.svg"; type: Media.IconData.Heavy }
		queryStats: Media.IconData { path: heavyRoot.iconBasePath + "query_stats.svg"; type: Media.IconData.Heavy }
		questionMark: Media.IconData { path: heavyRoot.iconBasePath + "question_mark.svg"; type: Media.IconData.Heavy }
		radar: Media.IconData { path: heavyRoot.iconBasePath + "radar.svg"; type: Media.IconData.Heavy }
		refresh: Media.IconData { path: heavyRoot.iconBasePath + "refresh.svg"; type: Media.IconData.Heavy }
		remove: Media.IconData { path: heavyRoot.iconBasePath + "remove.svg"; type: Media.IconData.Heavy }
		repeat: Media.IconData { path: heavyRoot.iconBasePath + "repeat.svg"; type: Media.IconData.Heavy }
		replay: Media.IconData { path: heavyRoot.iconBasePath + "replay.svg"; type: Media.IconData.Heavy }
		report: Media.IconData { path: heavyRoot.iconBasePath + "report.svg"; type: Media.IconData.Heavy }
		restartAlt: Media.IconData { path: heavyRoot.iconBasePath + "restart_alt.svg"; type: Media.IconData.Heavy }
		restaurant: Media.IconData { path: heavyRoot.iconBasePath + "restaurant.svg"; type: Media.IconData.Heavy }
		restaurantMenu: Media.IconData { path: heavyRoot.iconBasePath + "restaurant_menu.svg"; type: Media.IconData.Heavy }
		rocketLaunch: Media.IconData { path: heavyRoot.iconBasePath + "rocket_launch.svg"; type: Media.IconData.Heavy }
		rssFeed: Media.IconData { path: heavyRoot.iconBasePath + "rss_feed.svg"; type: Media.IconData.Heavy }
		save: Media.IconData { path: heavyRoot.iconBasePath + "save.svg"; type: Media.IconData.Heavy }
		savings: Media.IconData { path: heavyRoot.iconBasePath + "savings.svg"; type: Media.IconData.Heavy }
		schedule: Media.IconData { path: heavyRoot.iconBasePath + "schedule.svg"; type: Media.IconData.Heavy }
		school: Media.IconData { path: heavyRoot.iconBasePath + "school.svg"; type: Media.IconData.Heavy }
		science: Media.IconData { path: heavyRoot.iconBasePath + "science.svg"; type: Media.IconData.Heavy }
		search: Media.IconData { path: heavyRoot.iconBasePath + "search.svg"; type: Media.IconData.Heavy }
		security: Media.IconData { path: heavyRoot.iconBasePath + "security.svg"; type: Media.IconData.Heavy }
		sell: Media.IconData { path: heavyRoot.iconBasePath + "sell.svg"; type: Media.IconData.Heavy }
		send: Media.IconData { path: heavyRoot.iconBasePath + "send.svg"; type: Media.IconData.Heavy }
		settings: Media.IconData { path: heavyRoot.iconBasePath + "settings.svg"; type: Media.IconData.Heavy }
		share: Media.IconData { path: heavyRoot.iconBasePath + "share.svg"; type: Media.IconData.Heavy }
		shoppingBag: Media.IconData { path: heavyRoot.iconBasePath + "shopping_bag.svg"; type: Media.IconData.Heavy }
		shoppingCart: Media.IconData { path: heavyRoot.iconBasePath + "shopping_cart.svg"; type: Media.IconData.Heavy }
		shuffle: Media.IconData { path: heavyRoot.iconBasePath + "shuffle.svg"; type: Media.IconData.Heavy }
		signalCellularAlt: Media.IconData { path: heavyRoot.iconBasePath + "signal_cellular_alt.svg"; type: Media.IconData.Heavy }
		skipNext: Media.IconData { path: heavyRoot.iconBasePath + "skip_next.svg"; type: Media.IconData.Heavy }
		skipPrevious: Media.IconData { path: heavyRoot.iconBasePath + "skip_previous.svg"; type: Media.IconData.Heavy }
		smartphone: Media.IconData { path: heavyRoot.iconBasePath + "smartphone.svg"; type: Media.IconData.Heavy }
		sort: Media.IconData { path: heavyRoot.iconBasePath + "sort.svg"; type: Media.IconData.Heavy }
		sportsEsports: Media.IconData { path: heavyRoot.iconBasePath + "sports_esports.svg"; type: Media.IconData.Heavy }
		sportsSoccer: Media.IconData { path: heavyRoot.iconBasePath + "sports_soccer.svg"; type: Media.IconData.Heavy }
		stadiaController: Media.IconData { path: heavyRoot.iconBasePath + "stadia_controller.svg"; type: Media.IconData.Heavy }
		star: Media.IconData { path: heavyRoot.iconBasePath + "star.svg"; type: Media.IconData.Heavy }
		stop: Media.IconData { path: heavyRoot.iconBasePath + "stop.svg"; type: Media.IconData.Heavy }
		stopCircle: Media.IconData { path: heavyRoot.iconBasePath + "stop_circle.svg"; type: Media.IconData.Heavy }
		storage: Media.IconData { path: heavyRoot.iconBasePath + "storage.svg"; type: Media.IconData.Heavy }
		store: Media.IconData { path: heavyRoot.iconBasePath + "store.svg"; type: Media.IconData.Heavy }
		storefront: Media.IconData { path: heavyRoot.iconBasePath + "storefront.svg"; type: Media.IconData.Heavy }
		subscriptions: Media.IconData { path: heavyRoot.iconBasePath + "subscriptions.svg"; type: Media.IconData.Heavy }
		sync: Media.IconData { path: heavyRoot.iconBasePath + "sync.svg"; type: Media.IconData.Heavy }
		taskAlt: Media.IconData { path: heavyRoot.iconBasePath + "task_alt.svg"; type: Media.IconData.Heavy }
		theaters: Media.IconData { path: heavyRoot.iconBasePath + "theaters.svg"; type: Media.IconData.Heavy }
		thumbUp: Media.IconData { path: heavyRoot.iconBasePath + "thumb_up.svg"; type: Media.IconData.Heavy }
		timeline: Media.IconData { path: heavyRoot.iconBasePath + "timeline.svg"; type: Media.IconData.Heavy }
		timer: Media.IconData { path: heavyRoot.iconBasePath + "timer.svg"; type: Media.IconData.Heavy }
		touchApp: Media.IconData { path: heavyRoot.iconBasePath + "touch_app.svg"; type: Media.IconData.Heavy }
		trendingDown: Media.IconData { path: heavyRoot.iconBasePath + "trending_down.svg"; type: Media.IconData.Heavy }
		trendingUp: Media.IconData { path: heavyRoot.iconBasePath + "trending_up.svg"; type: Media.IconData.Heavy }
		tune: Media.IconData { path: heavyRoot.iconBasePath + "tune.svg"; type: Media.IconData.Heavy }
		undo: Media.IconData { path: heavyRoot.iconBasePath + "undo.svg"; type: Media.IconData.Heavy }
		update: Media.IconData { path: heavyRoot.iconBasePath + "update.svg"; type: Media.IconData.Heavy }
		uploadFile: Media.IconData { path: heavyRoot.iconBasePath + "upload_file.svg"; type: Media.IconData.Heavy }
		usb: Media.IconData { path: heavyRoot.iconBasePath + "usb.svg"; type: Media.IconData.Heavy }
		verified: Media.IconData { path: heavyRoot.iconBasePath + "verified.svg"; type: Media.IconData.Heavy }
		verifiedUser: Media.IconData { path: heavyRoot.iconBasePath + "verified_user.svg"; type: Media.IconData.Heavy }
		videoLibrary: Media.IconData { path: heavyRoot.iconBasePath + "video_library.svg"; type: Media.IconData.Heavy }
		videocam: Media.IconData { path: heavyRoot.iconBasePath + "videocam.svg"; type: Media.IconData.Heavy }
		visibility: Media.IconData { path: heavyRoot.iconBasePath + "visibility.svg"; type: Media.IconData.Heavy }
		visibilityOff: Media.IconData { path: heavyRoot.iconBasePath + "visibility_off.svg"; type: Media.IconData.Heavy }
		volumeOff: Media.IconData { path: heavyRoot.iconBasePath + "volume_off.svg"; type: Media.IconData.Heavy }
		volumeUp: Media.IconData { path: heavyRoot.iconBasePath + "volume_up.svg"; type: Media.IconData.Heavy }
		wallet: Media.IconData { path: heavyRoot.iconBasePath + "wallet.svg"; type: Media.IconData.Heavy }
		wallpaper: Media.IconData { path: heavyRoot.iconBasePath + "wallpaper.svg"; type: Media.IconData.Heavy }
		warning: Media.IconData { path: heavyRoot.iconBasePath + "warning.svg"; type: Media.IconData.Heavy }
		wbSunny: Media.IconData { path: heavyRoot.iconBasePath + "wb_sunny.svg"; type: Media.IconData.Heavy }
		whereToVote: Media.IconData { path: heavyRoot.iconBasePath + "where_to_vote.svg"; type: Media.IconData.Heavy }
		widgets: Media.IconData { path: heavyRoot.iconBasePath + "widgets.svg"; type: Media.IconData.Heavy }
		wifi: Media.IconData { path: heavyRoot.iconBasePath + "wifi.svg"; type: Media.IconData.Heavy }
		wifiOff: Media.IconData { path: heavyRoot.iconBasePath + "wifi_off.svg"; type: Media.IconData.Heavy }
		work: Media.IconData { path: heavyRoot.iconBasePath + "work.svg"; type: Media.IconData.Heavy }
		dashedCircle: Media.IconData { path: heavyRoot.iconBasePath + "dashedCircle.svg"; type: Media.IconData.Heavy }
		colorize: Media.IconData { path: heavyRoot.iconBasePath + "colorize.svg"; type: Media.IconData.Heavy }
    }

	function getAll() : list<string> {
		let heavyList = root.heavy.getAll();
		let lightList = root.light.getAll();

		let combinedList = heavyList.slice();
		for (let i = 0; i < lightList.length; i++) {
		   if (combinedList.indexOf(lightList[i]) === -1) {
				combinedList.push(lightList[i]);
			}
		}
		return combinedList;
	}

	QtObject{
		id: d

		readonly property Media.TextFileReader reader: Media.TextFileReader {}

		function applyFontFromConfig() : void {
			// Read config and set IconFont.source (LightIconMap only parses CSS).
			const txt = reader.readText(root.effectiveLightPackConfig);
			let cfg = null;
			try { cfg = JSON.parse(txt); } catch (e) { cfg = null; }

			if (!cfg && root.effectiveLightPackConfig !== root.defaultLightPackConfig) {
				const defTxt = reader.readText(root.defaultLightPackConfig);
				try { cfg = JSON.parse(defTxt); } catch (e2) { cfg = null; }
			}

			if (cfg && cfg.font)
				Media.IconFont.source = cfg.font;
			else
				Media.IconFont.source = "qrc:/MMaterial/assets/icomoon.ttf";
		}
	}
}
