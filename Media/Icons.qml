pragma Singleton

import QtQuick

import MMaterial.Media as Media

QtObject{
    id: _root

	readonly property Media.IconSet heavy: Media.IconSet {
        id: _heavyRoot

		readonly property string iconBasePath: "qrc:/MMaterial/Media/assets/svg/"

		logo: Media.IconData { path: _heavyRoot.iconBasePath + "logo.svg"; type: Media.IconData.Heavy }
    }

	readonly property Media.IconSet light: Media.IconSet {
		colorize: Media.IconData { path: '\uea02'; type: IconData.Light }
		inventory2: Media.IconData { path: '\ue913'; type: IconData.Light }
		keyboardArrowDown: Media.IconData { path: '\ue914'; type: IconData.Light }
		keyboardArrowLeft: Media.IconData { path: '\ue915'; type: IconData.Light }
		keyboardArrowRight: Media.IconData { path: '\ue916'; type: IconData.Light }
		keyboardArrowUp: Media.IconData { path: '\ue917'; type: IconData.Light }
		label: Media.IconData { path: '\ue918'; type: IconData.Light }
		landscape: Media.IconData { path: '\ue919'; type: IconData.Light }
		language: Media.IconData { path: '\ue91a'; type: IconData.Light }
		leaderboard: Media.IconData { path: '\ue91b'; type: IconData.Light }
		lightMode: Media.IconData { path: '\ue91c'; type: IconData.Light }
		lightbulb: Media.IconData { path: '\ue91d'; type: IconData.Light }
		link: Media.IconData { path: '\ue91e'; type: IconData.Light }
		list: Media.IconData { path: '\ue91f'; type: IconData.Light }
		localCafe: Media.IconData { path: '\ue920'; type: IconData.Light }
		localMall: Media.IconData { path: '\ue921'; type: IconData.Light }
		locationOn: Media.IconData { path: '\ue922'; type: IconData.Light }
		lock: Media.IconData { path: '\ue923'; type: IconData.Light }
		lockOpen: Media.IconData { path: '\ue924'; type: IconData.Light }
		login: Media.IconData { path: '\ue925'; type: IconData.Light }
		logout: Media.IconData { path: '\ue926'; type: IconData.Light }
		loyalty: Media.IconData { path: '\ue927'; type: IconData.Light }
		mail: Media.IconData { path: '\ue928'; type: IconData.Light }
		manageAccounts: Media.IconData { path: '\ue929'; type: IconData.Light }
		map: Media.IconData { path: '\ue92a'; type: IconData.Light }
		menu: Media.IconData { path: '\ue92b'; type: IconData.Light }
		mic: Media.IconData { path: '\ue92c'; type: IconData.Light }
		modeComment: Media.IconData { path: '\ue92d'; type: IconData.Light }
		monitoring: Media.IconData { path: '\ue92e'; type: IconData.Light }
		moreHoriz: Media.IconData { path: '\ue92f'; type: IconData.Light }
		moreVert: Media.IconData { path: '\ue930'; type: IconData.Light }
		movie: Media.IconData { path: '\ue931'; type: IconData.Light }
		musicNote: Media.IconData { path: '\ue932'; type: IconData.Light }
		myLocation: Media.IconData { path: '\ue933'; type: IconData.Light }
		navigation: Media.IconData { path: '\ue934'; type: IconData.Light }
		nearMe: Media.IconData { path: '\ue935'; type: IconData.Light }
		nestEcoLeaf: Media.IconData { path: '\ue936'; type: IconData.Light }
		nestRemoteComfortSensor: Media.IconData { path: '\ue937'; type: IconData.Light }
		nightlight: Media.IconData { path: '\ue938'; type: IconData.Light }
		notifications: Media.IconData { path: '\ue939'; type: IconData.Light }
		openInNew: Media.IconData { path: '\ue93a'; type: IconData.Light }
		paid: Media.IconData { path: '\ue93b'; type: IconData.Light }
		palette: Media.IconData { path: '\ue93c'; type: IconData.Light }
		pause: Media.IconData { path: '\ue93d'; type: IconData.Light }
		pauseCircle: Media.IconData { path: '\ue93e'; type: IconData.Light }
		person: Media.IconData { path: '\ue93f'; type: IconData.Light }
		personAdd: Media.IconData { path: '\ue940'; type: IconData.Light }
		personPin: Media.IconData { path: '\ue941'; type: IconData.Light }
		pets: Media.IconData { path: '\ue942'; type: IconData.Light }
		phoneIphone: Media.IconData { path: '\ue943'; type: IconData.Light }
		photoCamera: Media.IconData { path: '\ue944'; type: IconData.Light }
		photoLibrary: Media.IconData { path: '\ue945'; type: IconData.Light }
		pictureAsPdf: Media.IconData { path: '\ue946'; type: IconData.Light }
		pinDrop: Media.IconData { path: '\ue947'; type: IconData.Light }
		playArrow: Media.IconData { path: '\ue948'; type: IconData.Light }
		playCircle: Media.IconData { path: '\ue949'; type: IconData.Light }
		power: Media.IconData { path: '\ue94a'; type: IconData.Light }
		printElement: Media.IconData { path: '\ue94b'; type: IconData.Light }
		priorityHigh: Media.IconData { path: '\ue94c'; type: IconData.Light }
		publicElement: Media.IconData { path: '\ue94d'; type: IconData.Light }
		qrCode: Media.IconData { path: '\ue94e'; type: IconData.Light }
		qrCode2: Media.IconData { path: '\ue94f'; type: IconData.Light }
		qrCodeScanner: Media.IconData { path: '\ue950'; type: IconData.Light }
		queryStats: Media.IconData { path: '\ue951'; type: IconData.Light }
		questionMark: Media.IconData { path: '\ue952'; type: IconData.Light }
		radar: Media.IconData { path: '\ue953'; type: IconData.Light }
		refresh: Media.IconData { path: '\ue954'; type: IconData.Light }
		remove: Media.IconData { path: '\ue955'; type: IconData.Light }
		repeat: Media.IconData { path: '\ue956'; type: IconData.Light }
		replay: Media.IconData { path: '\ue957'; type: IconData.Light }
		report: Media.IconData { path: '\ue958'; type: IconData.Light }
		restartAlt: Media.IconData { path: '\ue959'; type: IconData.Light }
		restaurant: Media.IconData { path: '\ue95a'; type: IconData.Light }
		restaurantMenu: Media.IconData { path: '\ue95b'; type: IconData.Light }
		rocketLaunch: Media.IconData { path: '\ue95c'; type: IconData.Light }
		rssFeed: Media.IconData { path: '\ue95d'; type: IconData.Light }
		save: Media.IconData { path: '\ue95e'; type: IconData.Light }
		savings: Media.IconData { path: '\ue95f'; type: IconData.Light }
		schedule: Media.IconData { path: '\ue960'; type: IconData.Light }
		school: Media.IconData { path: '\ue961'; type: IconData.Light }
		science: Media.IconData { path: '\ue962'; type: IconData.Light }
		search: Media.IconData { path: '\ue963'; type: IconData.Light }
		security: Media.IconData { path: '\ue964'; type: IconData.Light }
		sell: Media.IconData { path: '\ue965'; type: IconData.Light }
		send: Media.IconData { path: '\ue966'; type: IconData.Light }
		settings: Media.IconData { path: '\ue967'; type: IconData.Light }
		share: Media.IconData { path: '\ue968'; type: IconData.Light }
		shoppingBag: Media.IconData { path: '\ue969'; type: IconData.Light }
		shoppingCart: Media.IconData { path: '\ue96a'; type: IconData.Light }
		shuffle: Media.IconData { path: '\ue96b'; type: IconData.Light }
		signalCellularAlt: Media.IconData { path: '\ue96c'; type: IconData.Light }
		skipNext: Media.IconData { path: '\ue96d'; type: IconData.Light }
		skipPrevious: Media.IconData { path: '\ue96e'; type: IconData.Light }
		smartphone: Media.IconData { path: '\ue96f'; type: IconData.Light }
		sort: Media.IconData { path: '\ue970'; type: IconData.Light }
		sportsEsports: Media.IconData { path: '\ue971'; type: IconData.Light }
		sportsSoccer: Media.IconData { path: '\ue972'; type: IconData.Light }
		stadiaController: Media.IconData { path: '\ue973'; type: IconData.Light }
		star: Media.IconData { path: '\ue974'; type: IconData.Light }
		stop: Media.IconData { path: '\ue975'; type: IconData.Light }
		stopCircle: Media.IconData { path: '\ue976'; type: IconData.Light }
		storage: Media.IconData { path: '\ue977'; type: IconData.Light }
		store: Media.IconData { path: '\ue978'; type: IconData.Light }
		storefront: Media.IconData { path: '\ue979'; type: IconData.Light }
		subscriptions: Media.IconData { path: '\ue97a'; type: IconData.Light }
		sync: Media.IconData { path: '\ue97b'; type: IconData.Light }
		taskAlt: Media.IconData { path: '\ue97c'; type: IconData.Light }
		theaters: Media.IconData { path: '\ue97d'; type: IconData.Light }
		thumbUp: Media.IconData { path: '\ue97e'; type: IconData.Light }
		timeline: Media.IconData { path: '\ue97f'; type: IconData.Light }
		timer: Media.IconData { path: '\ue980'; type: IconData.Light }
		touchApp: Media.IconData { path: '\ue981'; type: IconData.Light }
		trendingDown: Media.IconData { path: '\ue982'; type: IconData.Light }
		trendingUp: Media.IconData { path: '\ue983'; type: IconData.Light }
		tune: Media.IconData { path: '\ue984'; type: IconData.Light }
		undo: Media.IconData { path: '\ue985'; type: IconData.Light }
		update: Media.IconData { path: '\ue986'; type: IconData.Light }
		uploadFile: Media.IconData { path: '\ue987'; type: IconData.Light }
		usb: Media.IconData { path: '\ue988'; type: IconData.Light }
		verified: Media.IconData { path: '\ue989'; type: IconData.Light }
		verifiedUser: Media.IconData { path: '\ue98a'; type: IconData.Light }
		videoLibrary: Media.IconData { path: '\ue98b'; type: IconData.Light }
		videocam: Media.IconData { path: '\ue98c'; type: IconData.Light }
		visibility: Media.IconData { path: '\ue98d'; type: IconData.Light }
		visibilityOff: Media.IconData { path: '\ue98e'; type: IconData.Light }
		volumeOff: Media.IconData { path: '\ue98f'; type: IconData.Light }
		volumeUp: Media.IconData { path: '\ue990'; type: IconData.Light }
		wallet: Media.IconData { path: '\ue991'; type: IconData.Light }
		wallpaper: Media.IconData { path: '\ue992'; type: IconData.Light }
		warning: Media.IconData { path: '\ue993'; type: IconData.Light }
		wbSunny: Media.IconData { path: '\ue994'; type: IconData.Light }
		whereToVote: Media.IconData { path: '\ue995'; type: IconData.Light }
		widgets: Media.IconData { path: '\ue996'; type: IconData.Light }
		wifi: Media.IconData { path: '\ue997'; type: IconData.Light }
		wifiOff: Media.IconData { path: '\ue998'; type: IconData.Light }
		work: Media.IconData { path: '\ue999'; type: IconData.Light }
		accountBalance: Media.IconData { path: '\ue99a'; type: IconData.Light }
		accountBox: Media.IconData { path: '\ue99b'; type: IconData.Light }
		accountCircle: Media.IconData { path: '\ue99c'; type: IconData.Light }
		adb: Media.IconData { path: '\ue99d'; type: IconData.Light }
		add: Media.IconData { path: '\ue99e'; type: IconData.Light }
		addAPhoto: Media.IconData { path: '\ue99f'; type: IconData.Light }
		addBox: Media.IconData { path: '\ue9a0'; type: IconData.Light }
		addBusiness: Media.IconData { path: '\ue9a1'; type: IconData.Light }
		addCard: Media.IconData { path: '\ue9a2'; type: IconData.Light }
		addCircle: Media.IconData { path: '\ue9a3'; type: IconData.Light }
		addPhotoAlternate: Media.IconData { path: '\ue9a4'; type: IconData.Light }
		addShoppingCart: Media.IconData { path: '\ue9a5'; type: IconData.Light }
		air: Media.IconData { path: '\ue9a6'; type: IconData.Light }
		alarm: Media.IconData { path: '\ue9a7'; type: IconData.Light }
		analytics: Media.IconData { path: '\ue9a8'; type: IconData.Light }
		android: Media.IconData { path: '\ue9a9'; type: IconData.Light }
		apps: Media.IconData { path: '\ue9aa'; type: IconData.Light }
		arrowBack: Media.IconData { path: '\ue9ab'; type: IconData.Light }
		arrowDownward: Media.IconData { path: '\ue9ac'; type: IconData.Light }
		arrowDropDown: Media.IconData { path: '\ue9ad'; type: IconData.Light }
		arrowDropUp: Media.IconData { path: '\ue9ae'; type: IconData.Light }
		arrowForward: Media.IconData { path: '\ue9af'; type: IconData.Light }
		arrowRight: Media.IconData { path: '\ue9b0'; type: IconData.Light }
		atr: Media.IconData { path: '\ue9b1'; type: IconData.Light }
		attachMoney: Media.IconData { path: '\ue9b2'; type: IconData.Light }
		autorenew: Media.IconData { path: '\ue9b3'; type: IconData.Light }
		backspace: Media.IconData { path: '\ue9b4'; type: IconData.Light }
		badge: Media.IconData { path: '\ue9b5'; type: IconData.Light }
		barChart: Media.IconData { path: '\ue9b6'; type: IconData.Light }
		barcodeScanner: Media.IconData { path: '\ue9b7'; type: IconData.Light }
		batteryChargingFull: Media.IconData { path: '\ue9b8'; type: IconData.Light }
		batteryFull: Media.IconData { path: '\ue9b9'; type: IconData.Light }
		batteryFullAlt: Media.IconData { path: '\ue9ba'; type: IconData.Light }
		bluetooth: Media.IconData { path: '\ue9bb'; type: IconData.Light }
		bookmark: Media.IconData { path: '\ue9bc'; type: IconData.Light }
		brush: Media.IconData { path: '\ue9bd'; type: IconData.Light }
		build: Media.IconData { path: '\ue9be'; type: IconData.Light }
		cable: Media.IconData { path: '\ue9bf'; type: IconData.Light }
		cake: Media.IconData { path: '\ue9c0'; type: IconData.Light }
		calculate: Media.IconData { path: '\ue9c1'; type: IconData.Light }
		calendarMonth: Media.IconData { path: '\ue9c2'; type: IconData.Light }
		calendarToday: Media.IconData { path: '\ue9c3'; type: IconData.Light }
		call: Media.IconData { path: '\ue9c4'; type: IconData.Light }
		camera: Media.IconData { path: '\ue9c5'; type: IconData.Light }
		campaign: Media.IconData { path: '\ue9c6'; type: IconData.Light }
		cancel: Media.IconData { path: '\ue9c7'; type: IconData.Light }
		cast: Media.IconData { path: '\ue9c8'; type: IconData.Light }
		category: Media.IconData { path: '\ue9c9'; type: IconData.Light }
		celebration: Media.IconData { path: '\ue9ca'; type: IconData.Light }
		chat: Media.IconData { path: '\ue9cb'; type: IconData.Light }
		chatBubble: Media.IconData { path: '\ue9cc'; type: IconData.Light }
		check: Media.IconData { path: '\ue9cd'; type: IconData.Light }
		checkBox: Media.IconData { path: '\ue9ce'; type: IconData.Light }
		checkBoxOutlineBlank: Media.IconData { path: '\ue9cf'; type: IconData.Light }
		checkCircle: Media.IconData { path: '\ue9d0'; type: IconData.Light }
		chevronLeft: Media.IconData { path: '\ue9d1'; type: IconData.Light }
		chevronRight: Media.IconData { path: '\ue9d2'; type: IconData.Light }
		circle: Media.IconData { path: '\ue9d3'; type: IconData.Light }
		close: Media.IconData { path: '\ue9d4'; type: IconData.Light }
		code: Media.IconData { path: '\ue9d5'; type: IconData.Light }
		computer: Media.IconData { path: '\ue9d6'; type: IconData.Light }
		construction: Media.IconData { path: '\ue9d7'; type: IconData.Light }
		contactSupport: Media.IconData { path: '\ue9d8'; type: IconData.Light }
		contentCopy: Media.IconData { path: '\ue9d9'; type: IconData.Light }
		creditCard: Media.IconData { path: '\ue9da'; type: IconData.Light }
		cropFree: Media.IconData { path: '\ue9db'; type: IconData.Light }
		currencyBitcoin: Media.IconData { path: '\ue9dc'; type: IconData.Light }
		darkMode: Media.IconData { path: '\ue9dd'; type: IconData.Light }
		dashboard: Media.IconData { path: '\ue9de'; type: IconData.Light }
		database: Media.IconData { path: '\ue9df'; type: IconData.Light }
		deleteElement: Media.IconData { path: '\ue9e0'; type: IconData.Light }
		deleteForever: Media.IconData { path: '\ue9e1'; type: IconData.Light }
		description: Media.IconData { path: '\ue9e2'; type: IconData.Light }
		devices: Media.IconData { path: '\ue9e3'; type: IconData.Light }
		directionsCar: Media.IconData { path: '\ue9e4'; type: IconData.Light }
		domain: Media.IconData { path: '\ue9e5'; type: IconData.Light }
		doneAll: Media.IconData { path: '\ue9e6'; type: IconData.Light }
		download: Media.IconData { path: '\ue9e7'; type: IconData.Light }
		downloadForOffline: Media.IconData { path: '\ue9e8'; type: IconData.Light }
		draw: Media.IconData { path: '\ue9e9'; type: IconData.Light }
		eco: Media.IconData { path: '\ue9ea'; type: IconData.Light }
		edit: Media.IconData { path: '\ue9eb'; type: IconData.Light }
		editNote: Media.IconData { path: '\ue9ec'; type: IconData.Light }
		electricBolt: Media.IconData { path: '\ue9ed'; type: IconData.Light }
		emojiObjects: Media.IconData { path: '\ue9ee'; type: IconData.Light }
		engineering: Media.IconData { path: '\ue9ef'; type: IconData.Light }
		error: Media.IconData { path: '\ue9f0'; type: IconData.Light }
		euro: Media.IconData { path: '\ue9f1'; type: IconData.Light }
		event: Media.IconData { path: '\ue9f2'; type: IconData.Light }
		explore: Media.IconData { path: '\ue9f3'; type: IconData.Light }
		extension: Media.IconData { path: '\ue9f4'; type: IconData.Light }
		familiarFaceAndZone: Media.IconData { path: '\ue9f5'; type: IconData.Light }
		fastForward: Media.IconData { path: '\ue9f6'; type: IconData.Light }
		fastRewind: Media.IconData { path: '\ue9f7'; type: IconData.Light }
		favorite: Media.IconData { path: '\ue9f8'; type: IconData.Light }
		fileCopy: Media.IconData { path: '\ue9f9'; type: IconData.Light }
		filterAlt: Media.IconData { path: '\ue9fa'; type: IconData.Light }
		filterList: Media.IconData { path: '\ue9fb'; type: IconData.Light }
		finance: Media.IconData { path: '\ue9fc'; type: IconData.Light }
		fingerprint: Media.IconData { path: '\ue9fd'; type: IconData.Light }
		flag: Media.IconData { path: '\ue9fe'; type: IconData.Light }
		flashOn: Media.IconData { path: '\ue9ff'; type: IconData.Light }
		flashlightOn: Media.IconData { path: '\uea00'; type: IconData.Light }
		flight: Media.IconData { path: '\uea01'; type: IconData.Light }
		folder: Media.IconData { path: '\uea03'; type: IconData.Light }
		folderOpen: Media.IconData { path: '\uea04'; type: IconData.Light }
		forum: Media.IconData { path: '\uea05'; type: IconData.Light }
		gridOn: Media.IconData { path: '\uea06'; type: IconData.Light }
		gridView: Media.IconData { path: '\uea07'; type: IconData.Light }
		group: Media.IconData { path: '\uea08'; type: IconData.Light }
		groupAdd: Media.IconData { path: '\uea09'; type: IconData.Light }
		groups: Media.IconData { path: '\uea0a'; type: IconData.Light }
		handyman: Media.IconData { path: '\uea0b'; type: IconData.Light }
		headphones: Media.IconData { path: '\uea0c'; type: IconData.Light }
		hearing: Media.IconData { path: '\uea0d'; type: IconData.Light }
		help: Media.IconData { path: '\uea0e'; type: IconData.Light }
		history: Media.IconData { path: '\uea0f'; type: IconData.Light }
		home: Media.IconData { path: '\uea10'; type: IconData.Light }
		homePin: Media.IconData { path: '\uea11'; type: IconData.Light }
		image: Media.IconData { path: '\uea12'; type: IconData.Light }
		imagesmode: Media.IconData { path: '\uea13'; type: IconData.Light }
		info: Media.IconData { path: '\uea14'; type: IconData.Light }
		inventory: Media.IconData { path: '\uea15'; type: IconData.Light }
		waterDrop: Media.IconData { path: '\ue900'; type: IconData.Light }
		cafe: Media.IconData { path: '\ue901'; type: IconData.Light }
		fastfood: Media.IconData { path: '\ue902'; type: IconData.Light }
		coffee: Media.IconData { path: '\ue903'; type: IconData.Light }
		cocktail: Media.IconData { path: '\ue904'; type: IconData.Light }
		liquor: Media.IconData { path: '\ue905'; type: IconData.Light }
		beer: Media.IconData { path: '\ue906'; type: IconData.Light }
		tee: Media.IconData { path: '\ue907'; type: IconData.Light }
		drink: Media.IconData { path: '\ue908'; type: IconData.Light }
		wine: Media.IconData { path: '\ue909'; type: IconData.Light }
		noCocktail: Media.IconData { path: '\ue90a'; type: IconData.Light }
		juice: Media.IconData { path: '\ue90b'; type: IconData.Light }
		waterFull: Media.IconData { path: '\ue90c'; type: IconData.Light }
		blender: Media.IconData { path: '\ue90d'; type: IconData.Light }
		waterDropFilled: Media.IconData { path: '\ue90e'; type: IconData.Light }
		coldTemp: Media.IconData { path: '\ue90f'; type: IconData.Light }
		hotTemp: Media.IconData { path: '\ue910'; type: IconData.Light }
		fire: Media.IconData { path: '\ue911'; type: IconData.Light }
		ice: IconData { path: '\ue912'; type: IconData.Light }
    }

    function getAll() : list<string> {
        let heavyList = _root.heavy.getAll();
        let lightList = _root.light.getAll();

        let combinedList = heavyList.slice();
        for (let i = 0; i < lightList.length; i++) {
           if (combinedList.indexOf(lightList[i]) === -1) {
                combinedList.push(lightList[i]);
            }
        }
        return combinedList;
    }
}
