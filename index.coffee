#On reflection, I don't think users should necessarily be told whether the campaign's passed the threshold to go ahead. If their support is conditional on some feature of the procession of the campaign, let them state that to the system, let them be up-front about it. We want to be able to minimize strategic shirking.

@revolution =
	closingTime: "2017-04-23T18:25:43.511Z"
	ventureName: "The People's Revolution"
	tagline: "We shall march on the imperial palace"
	detail: "It is time for the dictator to be deposed. When we hear of the signal, we, all of us, shall drop what we're doing and assemble under the banner of The People to storm the palace. Our tactitians believe we will need no more than 800 men and women to overcome the imperial guard and hold the palace from within. Only the very brave should agree to march with less than that."
	axes: ['fight']
	minimumForSuccess: ['number', 'fight', '800']

@communityGarden =
	closingTime: "2017-04-23T18:25:43.511Z"
	ventureName: "Roof Garden"
	tagline: "Let's maintain a community garden!"
	detail: "We at appartment building 306-g think that a shared roof garden would be a great way to bring people together and foster goodwill among the community. If we get enough support we're going to build it on the roof, "
	axes: ['build', 'use']
	stretches: ['success', ['all', ['number', 'build', '8'], ['number', 'use', '15']]]
party =
	tagline: "We shall gather and cavort"
	detail: "Russ is back in town. Russ wants to have a party. You will join in working towards the fruition of this noble goal by coming to"
	axes: ['revel']
	stretches: [['success', ['number', 'revel', '15']]]

@intentionalCommunity =
	closingTime: "2020-04-23T18:25:43.511Z"
	ventureName: "Metal Coop"
	tagline: "Move into an apartment building populated entirely by bogans"
	detail: "We all know our loud music, wild parties and our outlandish fashions are not always well received by the more vanilla members of the community. To each their own. This is a proposal to collectively buy out the appartment building on the corner of Westhaven and SunnyDell lane, that we may get our own in magnitude. The value of each apartment in is 411,300$. Part of this is the relocation compensation fees for the pre-existing tennants- one of the unavoidable costs of mass migration- but by and large the cost is little more than what you should expect for such a prime piece of real-estate."
	axes: ['buy in']
	theme: 'dark'
	stretches: [['success', ['number', 'buy in', '20']]]


successAxis = null
campaignState = null
closingTimeMillis = null
setState = (s)->
	campaignState = s

displayTime = (str)->
	document.getElementById('closing_date').textContent = str

timeThinkerInterval = null
thinkAboutTheTime = ->
	if closingTimeMillis != null
		difftill = closingTimeMillis - Date.now()
		if difftill <= 0
			#Campaign over
			displayTime "The Venture is Already Sealed"
			document.body.classList.add 'campaign_over'
			stopThinkingAboutTheTime()
		else
			digit = ['Seconds', 1000]
			digits = [
				['Minutes', 60000]
				['Hours', 3600000]
				['Days', 86400000]
				['Weeks', 604800000]
			]
			for ar, i in digits
				if ar[1] < difftill
					digit = ar
				else
					break
			displayTime Math.floor((difftill/digit[1])*10)/10 +' '+ar[0]
	else
		displayTime "Indefinite campaign"
stopThinkingAboutTheTime = ->
	clearInterval timeThinkerInterval
startThinkingAboutTheTime = ->
	timeThinkerInterval = setInterval thinkAboutTheTime, 120000
	thinkAboutTheTime()


@mkBtn = (text, onClick)->
	textSpan = if text.constructor == String
		tsp = document.createElement 'span'
		tsp.textContent = text
		tsp
	else
		text
	btn = document.createElement 'span'
	btn.classList.add 'btn'
	btn.appendChild textSpan
	btn.addEventListener 'mousedown', -> btn.classList.add 'down'
	btn.addEventListener 'mouseup', ->
		btn.classList.remove 'down'
		onClick() if onClick
	btn.addEventListener 'mouseout', ->
		btn.classList.remove 'down'
	btn


@setData = (campaign, state)->
	displayCampaign campaign
	setState state

@displayCampaign = (c)->
	title = document.getElementById 'title'
	ventureName = document.getElementById 'venture_name'
	content = document.getElementById 'content'
	conditions = document.getElementById 'conditions'
	detail = document.getElementById 'detail'
	while conditions.firstChild
		conditions.removeChild conditions.firstChild
	document.body.className = ''
	document.body.classList.add switch c.theme
		when 'light' then 'light_theme'
		when 'dark' then 'dark_theme'
		else 'light_theme'
	putCondition = (axis, number)->
		d = document.createElement 'div'
		d.classList.add 'condition'
		
		conditionText = document.createElement 'span'
		conditionText.classList.add 'condition_text'
		conditionText.appendChild document.createTextNode('I will ')
		verb = document.createElement('span')
		verb.classList.add "keyword"
		verb.textContent = axis
		conditionText.appendChild verb
		conditionText.appendChild document.createTextNode ' if'
		d.appendChild conditionText
		
		d.appendChild mkBtn('+ add condition')
		
		conditions.appendChild d
	title.textContent = c.tagline
	detail.innerHTML = c.detail
	supportingAction = c.axes[0]
	ventureName.textContent = c.ventureName
	if c.closingTime
		closingTimeMillis = new Date(c.closingTime).getTime()
		thinkAboutTheTime()
	# nRequired = 0
	# for s in stretches
	# 	if s[0] == 'success'
	# 		st = s[1]
	# 		if st[0] == 'number' and st[1] == supportingAction
	# 			nRequired = Number.parseInt st[2]
	putCondition supportingAction

document.addEventListener 'DOMContentLoaded', ->
	displayCampaign intentionalCommunity
	startThinkingAboutTheTime
	
	#project scrolling for mockup release
	i = 0
	campaignArray = [intentionalCommunity, communityGarden, revolution]
	nter = document.getElementById 'nexter'
	nter.addEventListener 'click', ->
		i += 1
		i = 0 if i >= campaignArray.length
		displayCampaign campaignArray[i]