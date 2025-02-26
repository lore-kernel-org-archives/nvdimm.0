Received: from esa6.fujitsucc.c3s2.iphmx.com (esa6.fujitsucc.c3s2.iphmx.com [68.232.159.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E181A38F9
	for <nvdimm@lists.linux.dev>; Wed, 26 Feb 2025 07:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740553308; cv=fail; b=qTsyUO73KJYJ53/nJ2EVxl3tHcxEupm2Z35pPYPwU8BZpK5bdQd5x4Z0T/6ZXxEBNGn5Am3KnWzZqwVopYtq7jYrYKLRR+0zbyLsd19OH36DAHOJyJd/MRe9Q9N+BTUutMxP6cE0YkkqtZnnC0s73uYjpa4k2Ggm2vgUS4DS6bk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740553308; c=relaxed/simple;
	bh=76SfWkyAzIWI8rMfPJzp3a1ic8jo87zzQk+lembCyek=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qCeXCB6h/QmofIrVKrROIgWXxck7stLD1XTa6/K2PqJjzjpREUCYceAxUiO2NNJo+0h9zfVQYxHd23jh3i44rfc9YGg3FIxuSs7Cw6ZxT16dkJ+sNnWzN/ikRqxVdhi1GLjtcLpLIAJ1pLJ7wXLTn0C8gDUktFlUs1VUpsSjkI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=exBGrolA; arc=fail smtp.client-ip=68.232.159.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="exBGrolA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1740553307; x=1772089307;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=76SfWkyAzIWI8rMfPJzp3a1ic8jo87zzQk+lembCyek=;
  b=exBGrolAA++hWHJbpPyaVr/KvCWHBugRy8ffj7Wirqxu8Z+UHjlek/dY
   5X2QdIhJF8NjIve8SKaxDVuiVH/uBp0115rZeio39z+zRU2tqWVpAW6A6
   /Hq52NsAV8YsT2o21ljEpiLU3IvS54dkBc0NGijcF2QXTfI5i/FgcdfKa
   CJ3XkTiPhddlMKBkV1xJK04fMToeSb7MKnJBakPo93+SYmTRb/l+/QsC5
   9kq3Xm37k/A/zYqs+OthPX6GsYvqx6MfEoyCMNMIOgzVqxI2Vw2t+BtEu
   mIRQAqwoAQSOb2Fytx1zwjwAsLf67iVZ9ep3kaU9LehjcRHf+qREKamBb
   g==;
X-CSE-ConnectionGUID: pkfV9vqXT6627s+Gr6rb6Q==
X-CSE-MsgGUID: SKsrt1t+Q4KwwxdYpPx1Sg==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="147604898"
X-IronPort-AV: E=Sophos;i="6.13,316,1732546800"; 
   d="scan'208";a="147604898"
Received: from mail-japaneastazlp17010007.outbound.protection.outlook.com (HELO TY3P286CU002.outbound.protection.outlook.com) ([40.93.73.7])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 16:00:35 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=htUNugxCvtWL8pJHNO3ml5p9t/6iv9sBSEwBGODcLoD0ZDwssnNQoAZGgc7t3G23Rqpu/jiMpgnSu6SmHxEaCtmiIq3cd4x1VnRRSkfbJW9uklpU3cDqszR0X9d6/ESa2h99bQawHuMvT/AXF47kKM/59UHQWeagzTlItaNIQTPaDAcJbGHnLRfiKKOmS/EKD1Ct3D4iJbY//mM6BqhzHU++cRHjNvlYgJn27yhP/yzhR4jL8wpqtQZcOizigEmuNBpJ2UD3ObEjn8Qae0V8FiyOeW4G5oSOyXuozZ9F+tu5bLvu1vnH0yFl+5dzVBrjQZHeIU/4v7wIt590VreyxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76SfWkyAzIWI8rMfPJzp3a1ic8jo87zzQk+lembCyek=;
 b=Cj6f7cuGsZVFZGgMKHFtYqtyaf1/rN2+BF+eiOQ3lW4x121r8mlEQet7cGeECCeoWf+2qoj67qMxA15Iba9WYa/2IVGTgIX8yM+KKh4JZ0vKCE/9UCsjVEmWIxbemwTGwUi6RDMItdYm3Btiy7HbhaG7p5L/3yXhCYZBQDl9yAkbyjndSJ7Js26Y76R7cCaO0VkR1RnnewI72LbeReFjcHsHftAYBPj9XCKiEphJ2fSPp3ckGw4A0+DTn5Bgk5piKxssYRq0guSnVcNrRX76wH+LrXwq37rffw2oBseXtlaXNJGN9H0De9c2s/5zbAgtXjlbWel2M9W6nppRalOCGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TYCPR01MB10277.jpnprd01.prod.outlook.com (2603:1096:400:1d7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Wed, 26 Feb
 2025 07:00:32 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%5]) with mapi id 15.20.8466.016; Wed, 26 Feb 2025
 07:00:32 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Donet Tom <donettom@linux.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Donet
 Tom <donettom@linux.vnet.ibm.com>, Alison Schofield
	<alison.schofield@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Ritesh Harjani
	<ritesh.list@gmail.com>
Subject: Re: [PATCH] [ndctl PATCH v2] ndctl/list: display region caps for any
 of BTT, PFN, DAX
Thread-Topic: [PATCH] [ndctl PATCH v2] ndctl/list: display region caps for any
 of BTT, PFN, DAX
Thread-Index: AQHbg1+ZF2vg7wjuvUeTwE3+Igiy5bNQMgOlgAjvRwCAABAzgA==
Date: Wed, 26 Feb 2025 07:00:31 +0000
Message-ID: <2db38698-dda7-4aa0-b540-44b1c3f7c9df@fujitsu.com>
References: <20250220062029.9789-1-donettom@linux.vnet.ibm.com>
 <x49y0y0oi1g.fsf@segfault.usersys.redhat.com>
 <6f43cf6e-a3b7-4746-be15-d354cc6dd699@linux.ibm.com>
In-Reply-To: <6f43cf6e-a3b7-4746-be15-d354cc6dd699@linux.ibm.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TYCPR01MB10277:EE_
x-ms-office365-filtering-correlation-id: 806d5384-a6ad-4fb7-7b23-08dd563342a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|1580799027|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TC82US9lUkRWekZRbDBqbC8rNSt2MVJQSVpuWTRPRVJVS1pOdmlXaUVtRXYz?=
 =?utf-8?B?MnBoM0NxTlJFNE9HSEFJekFjSFVMMWVvTjYxOFJJOU5TOWp3TlFob2JBYnI0?=
 =?utf-8?B?N0l3VUEzb3YxeFlQRmhFaFNabzFmbG9MSXhNMXI2bUJhNEYxOGZYVUYxWEVx?=
 =?utf-8?B?R1JoOFVxK3JaQU9UWXp6Uml6eVYwZGZqK2lMRi81QXcvNStYRVVSL2g4OW1r?=
 =?utf-8?B?UWdxL1hXWHAyaG5nYlJTR2dYN2NjY1BrZDUwMWJkZFZ1Yk9Vc0pNSEZqcVhV?=
 =?utf-8?B?WEJwYnViUHBrZXI5T1hvZEh0bUVGTGRaSkdRZVdDcURlR1JSNG4zVHM5S25Z?=
 =?utf-8?B?NmFQd1Q3ZUt2a3MvWDNJakxFVnF1YjVPVlI2OUxCai9GbXRwcStNclI5clBh?=
 =?utf-8?B?SnVzYWwwbFZGeTAyRUFGSzNZVHFmNjltQWpZNlR5bGxTRkR0eFFsRlFUZVRR?=
 =?utf-8?B?VE0xVFFrcWxrbUhMVzk1OG1qSkNPTEN1eVBFamd2T3E0Uk1VcnFOVEprT0FO?=
 =?utf-8?B?UjErQTdiYmlzQm9uVVR2M3NNRmhmSnY3VjY5L2FPV1BaZTRnT3BkV2NCeHB3?=
 =?utf-8?B?OCtJamZKOVBNZ1E2eE9NMU0vd3QrN1JnZ0MrbmFUc3NBUTgvM2VvUDczN09K?=
 =?utf-8?B?dTdYQ3dYZ29SaURaODJyZHMrNkhJWFZ5SHRmUGJINVJ0V2lBTmlzcjhod2tV?=
 =?utf-8?B?a2ppc1lmcHU3NFhScTlpV2wwS1l0QXVjOTNmRGhlQ09aS0hSL1FtRmw4dlJG?=
 =?utf-8?B?aUNpRGhhclB2ZnZqeU5qTFRGZ1ZFV2xiT3hpbE5TYXVXM1R6SFpNdTloblEr?=
 =?utf-8?B?VkJkMGJ5clhqVVNkRGxXd09GL1NkNEh0MzN0SVp6aTRPZG41NzQwQkpHVjYr?=
 =?utf-8?B?L3UrRnIxU2dkS3JxTXFUMHZTVjE0bFJRd0p2cnpsVDN2NU9CNzhKNCtpanc5?=
 =?utf-8?B?S0M0OWJKeC84MTZZc2FUYy8veHNNVVRMRCt4YW9YZFd2QjZkeW85QldCb2RY?=
 =?utf-8?B?NEordGJ3S2VKNTFudWpQV21qUW9JUzlka1JmeWtXVlFJMVFNc1FSYUhhdW05?=
 =?utf-8?B?bFJWeEsvM3lncUJOeFYrd2NzeW9wU2pvZHF0UitOZ09aZDR0dCtodzFjeDVu?=
 =?utf-8?B?Q0tvaWg3Z2paNVlBbXRoNFVtR0pQZ25SY1VLb2xpdlhrOG0vZk1wdXA5OVZi?=
 =?utf-8?B?bjloRjNaejFWNjNwdEREYnJrZ0V2OXBNMTdvd2NPM2lGa2t2OEVva0lGMjdB?=
 =?utf-8?B?bVNhajFzaWgrVFR5Uy8rS1R0RlVIN25qRHlka3VGTWdYT29QWmhDODNEZjhU?=
 =?utf-8?B?alBjT0tyMyt4VGp3M3BaU2E4WEEyb2M2RmwvTVBWWEJuclk4aUdzQXQ5VHlk?=
 =?utf-8?B?dE8wNnQ4MzlXWmFSQS8rOXJnY1R1bTlpdFBjN1laRThlVjNMbUUveDdqdjNv?=
 =?utf-8?B?OERiTzNJWm9xU1VGbThRdmZOS1gyV1VXNXBTODVLR2xvdWg0bzdiSkYvTmVq?=
 =?utf-8?B?KzdvYkdjNS96YmtOdEhNbVFHZ2ZkMDczUThRRW1Cem53amFrM1kwaXZyUy9w?=
 =?utf-8?B?dXFlczY5N2Y3T0pZK3ZtQk1IM2pHYzNSTXlBZ09GKzg4MWxHVWZkbXZhY3U0?=
 =?utf-8?B?ZUV1Z2dIZEp6TFpyR2JwRkdibG00eVRoY1hrN3Jqc1d4eElFd0hML2QyZXE5?=
 =?utf-8?B?d0xSWDF2Uk8wNEZZWSs5QW1Sdlh3K3BoTEQ0ZUtHU3RKVGMvSEE5UGIyNXhl?=
 =?utf-8?B?ZDA1QU9IYlBrNTJlUHpsb2NOV3RiK3Z4eWc1SmYwUHdadTNJRHdjcUdBaWMr?=
 =?utf-8?B?Z1NOeHV5dWtCS1VUZEdsUHMxSmlxbnZmVzd4Q3VWUWo2a3JiUTNkU2xsTHZQ?=
 =?utf-8?B?MWtNSHBvcFhnUGVOdXpNYkRPQ1dTN2tWT0ExMnp2aFgzb0hSMmhpQXdkN1J1?=
 =?utf-8?Q?IakK66OiO7g=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(1580799027)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RmdDbzVFSjNGeGdMclZiZUZ1bEY4WDdWaDJJbGkzQlhXTHVSVnhkeU1wdjNh?=
 =?utf-8?B?K2pYL3hCaWIzV3BuZjhGelRGQndodkNsbWtNb0c5Z0xTL2p4T0duV1JsTlls?=
 =?utf-8?B?SlQyK3BhYU15VWpyc3VhR3VkbXN1dVJWY292WkxHOTExdmNQSmVLaEp4Kzlm?=
 =?utf-8?B?MU1hQ2pQL2kzdHBUTEt5K2h6SjIxU0tGbzZodHo5TVZMTEF0VjNWWVNFMUh0?=
 =?utf-8?B?MFlSc053dStZZGpZTFFXcXNHUmtxeTBkQitSWnN3TmMxdlozdU1kME1HdFMv?=
 =?utf-8?B?TXZLT29icjVtT25Sd21zRXVQclAwM2JwYm9VNmpuNC91RDhSaXh6bzFvT3pL?=
 =?utf-8?B?SHBOVTNSQWhTNmpMaUNNU2xwcGtUaGhCU0RDcFBXd2FQL1ltRFJNekFUdEh0?=
 =?utf-8?B?Q284MEh2aU9DN0hnWjdTQ290R1dnSzh6YjRFNXI4T0VwbWxpK05Jd3NiZHpT?=
 =?utf-8?B?Yk4rdk5aS3A4SjFRQXJDblZvOTlGM29lUzRrRUIxeW1IenJNcE1XK1YwZTVa?=
 =?utf-8?B?amh1eU1sczVML1R4K0RmVzdhak5janN3T1hVNnZtVmJmSmpxcmdBbjE2cS9H?=
 =?utf-8?B?d213Si8rbU0zMGE5c3dXeDVzM0pQMWlzb1djVmc4aDcxRWNSOEZ5cVVib1hT?=
 =?utf-8?B?Rk40R3Zvb0wyekpFbnNjY3l3YzRvK2JXMHJZUGdZYjI1elVqRHNrQThIZm1v?=
 =?utf-8?B?MzF1QlN4QmhuUmcxZXJKdkJCSksxYzNHMkpSQ1NocHZUY1RicEJQa0M0eVFK?=
 =?utf-8?B?cGp1MXRkZHJwNVZPQVIxTUJEZUlPMXQxajFyaUVHTHdZV3doejlOR2RNL1dx?=
 =?utf-8?B?MkpEMmhSb3pXWm9McUJxMHdFMEV5OVFFYllrb3NueHdjMGZVK2pQMWRkOFZB?=
 =?utf-8?B?anFHSkdidmYwOE9zNU80NVdyR2l1b01EVGlqVTRtVTlHUGpjcDIwdXFwYW1E?=
 =?utf-8?B?S3U5aVlFYkxMdElrRHl3MEUvT2NFMXBEZVpXWlhPcGtJckphenE0NXcrdXNQ?=
 =?utf-8?B?bEZlQTVCZDlDcTd0TUY4eUdqTDBaVTFXbHF5RTJEd0Z4NUg2aUFiYVozcUZm?=
 =?utf-8?B?bzVJbDJzVGRpSmtWSTErY3ZESGdWTjd1TUhUcUJoZTJCVFEvTlh5YkFvRjhM?=
 =?utf-8?B?cXVVb29GY2FyWUdCdU9ycENBM2YxVzlPeldtUWFuRTFWend5TGVtMDZwK2R2?=
 =?utf-8?B?a2djSGFoRGdHZ0dFWDFSTlBSeitrU2dXeFQrb0FMN3JnQ3lxVnRpLzA2R1Jo?=
 =?utf-8?B?d1lpYVBTT0Exb2pmVXVUMS9yemM4dEQxMG9ydkFVQ05DbWdYUXhSZXJ4cG1U?=
 =?utf-8?B?NndsYndnNHhxbDVaYm93SmZaMUpFb2NOYysxWFZodkxoTG5ncGRGTnlHRFdB?=
 =?utf-8?B?eXdNZWYwdE9mN3VNNHRhZmoxc3VSWkhzakl2OElSelRibkl1ODhpUXF3cDNL?=
 =?utf-8?B?amVoQ3A4dFFPWU9zYmcyOTBaUHNmY3ZYWjRlRldHMFNuR201bmZ4TGtIOFpt?=
 =?utf-8?B?Q3RCU056RmQraGNtTXpiUWFCWlJsL3lZRXhYYjNjd3c5N0xFa1JhR2VXT0Fj?=
 =?utf-8?B?MkJsUEpNQ240ZzNtTnRQb2lFS3JqcnRwZXZyMFkyelhQRjRRNFprNkwvVEdB?=
 =?utf-8?B?WmcwNDBiZnhKc09xNHJyMTZyd3ZwNmtCT3QwM1V3TUc1b3Y0NTZydHYrMDM3?=
 =?utf-8?B?amZiVU5qN25PUGd6UGxBaURGbzVXN1RFeGVlZ2RrSGt4ZU81WlcyUk1adXIw?=
 =?utf-8?B?K0tMQTNlKzJETjJRc3ZvOUhEQitaWjIzR3F3bGNza0V0eVBKbkxsTnpJK25G?=
 =?utf-8?B?TGpRb1g4V2lsT0Ira201Rzc4QTFqc2dxZW1rdVdLcDJPejk3UDB5MHF5Y1NU?=
 =?utf-8?B?SFEyUUsrNnRLdzY2a1F3ak83emdtaVp2TTNIRDdJcXlEQ0Q5SitPMmlFR25q?=
 =?utf-8?B?Sy9OdFlETWs1Y0JWRnFFa3FoVFhPcjQ5ZEFiVmd0SUFpTWRGb2FlK1NEMHN0?=
 =?utf-8?B?N0MvbGE3M0o1TnpjcDRPUUZPT3JSTDRjRThCWER6WkcwZ1NmakpBKzRicFdC?=
 =?utf-8?B?c1plUHUxb0xlNG9SRjBrdUVZWHVZdUpDOVJkYXhWc1VvLzZmbDMrdjYwcW1D?=
 =?utf-8?B?Sk95S3JyNlc4WXNzY1AxTjY3cTIyZXJadzRwNTBuUW5iV3NoOVFvKyt1VnAz?=
 =?utf-8?B?ZWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CECBAFEA35E8F4098153979511D3577@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jgXktixcME9olbMd9riXHMCVRx5NA/XPvEEf2e11U9EpT0CCYxPzMsxIgB/O1XQecazwuauAThB1EJneL8oSAdp4paIpTtUeEkdxNXq5+SqLI/7XQlINGMcNIffz70/8ZHYIumNqFUiBHBoXGt+NEQhZ9cLd9YAHegZJ8Ml5kdjS6xyTcdMOU+HNOpBHZmCVU6Wkjt9zC6g0+vKGWFzp12Irrc5PK89sQfP7t+yGY0/mN1kNyO0FbgcwyJ+ogkfNXcYRTZLWKuBTG6agy3NhMK3PHzx82oMcuNAa+DVf0d/tMNWgJT0bCpA5xfvAvFUQ6/a4wdhhUq5yIFD80vax/FrHQGcB4pGxfylvNcK0hxeMlCGTFa5S33OdsMxMyjj+Gf4xT4fJ3u40IpPm7K/Pi167FPy+jxVmRpHsz4TU3S1KzZmtSTJeMTc0enL4sto82TnsU4iIH6NQtytB25Gvh0rHCFadCivKIbL1fo4xYdLe6yirB7vOhkcVpd4cYNIixIa+cq0FxbI7GqZsaWDsZLQo6s7jI99ORXQlh4BIvLdyKQe7HcmnvwcqFoZG9tIcsswDnuT79ewX+a67yilLQqT6Ob3AdAtvegEE/Q5G8nRM7rvfLJHR82uYAg8/1A+T
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 806d5384-a6ad-4fb7-7b23-08dd563342a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2025 07:00:31.8034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mXIZyT6OuI9uU1RbX11JcCDp3xZvDQw9YG8kdQBSdp+OL3SIdCACqA/L7eJx8oTtY9wcxstvGC3ek/Q1fQSWyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10277

DQoNCk9uIDI2LzAyLzIwMjUgMTQ6MDIsIERvbmV0IFRvbSB3cm90ZToNCj4gDQo+IE9uIDIvMjAv
MjUgMTk6MDUsIEplZmYgTW95ZXIgd3JvdGU6DQo+Pj4gZGlmZiAtLWdpdCBhL25kY3RsL2pzb24u
YyBiL25kY3RsL2pzb24uYw0KPj4+IGluZGV4IDIzYmFkN2YuLjc2NDY4ODIgMTAwNjQ0DQo+Pj4g
LS0tIGEvbmRjdGwvanNvbi5jDQo+Pj4gKysrIGIvbmRjdGwvanNvbi5jDQo+Pj4gQEAgLTM4MSw3
ICszODEsNyBAQCBzdHJ1Y3QganNvbl9vYmplY3QgKnV0aWxfcmVnaW9uX2NhcGFiaWxpdGllc190
b19qc29uKHN0cnVjdCBuZGN0bF9yZWdpb24gKnJlZ2lvbg0KPj4+IMKgwqDCoMKgwqAgc3RydWN0
IG5kY3RsX3BmbiAqcGZuID0gbmRjdGxfcmVnaW9uX2dldF9wZm5fc2VlZChyZWdpb24pOw0KPj4+
IMKgwqDCoMKgwqAgc3RydWN0IG5kY3RsX2RheCAqZGF4ID0gbmRjdGxfcmVnaW9uX2dldF9kYXhf
c2VlZChyZWdpb24pOw0KPj4+IC3CoMKgwqAgaWYgKCFidHQgfHwgIXBmbiB8fCAhZGF4KQ0KPj4+
ICvCoMKgwqAgaWYgKCFidHQgJiYgIXBmbiAmJiAhZGF4KQ0KPj4+IMKgwqDCoMKgwqDCoMKgwqDC
oCByZXR1cm4gTlVMTDsNCj4+PiDCoMKgwqDCoMKgIGpjYXBzID0ganNvbl9vYmplY3RfbmV3X2Fy
cmF5KCk7DQo+PiBSZXZpZXdlZC1ieTogSmVmZiBNb3llciA8am1veWVyQHJlZGhhdC5jb20+DQo+
Pg0KPiBUaGFua3MgSmVmZg0KPiANCj4gDQo+IEhpIEFsaXNvbg0KPiANCj4gU2hvdWxkIEkgc2Vu
ZCBhIHYzIHdpdGggUmV2aWV3ZWQtYnkgdGFnIA0KDQpHZW5lcmFsbHkgc3BlYWtpbmcsIHRoZXJl
IGlzIG5vIG5lZWQgZm9yIHlvdSB0byBkbyB0aGlzLg0KDQpBIHNtYWxsIHRpcCBtaWdodCBiZSBo
ZWxwZnVsIGlmIHlvdSBzZW5kIGEgcGF0Y2ggbmV4dCB0aW1lLg0KDQo+PiANCj4+IHYxIC0+IHYy
Og0KPj4gQWRkcmVzc2VkIHRoZSByZXZpZXcgY29tbWVudHMgZnJvbSBKZWZmIGFuZCBBbGlzb24u
DQo+PiANCj4+IHYxOg0KPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjUwMjE5MDk0
MDQ5LjUxNTYtMS1kb25ldHRvbUBsaW51eC5pYm0uY29tLw0KDQpDb21taXQgbWVzc2FnZXMgdGhh
dCBhcmUgbm90IGludGVuZGVkIHRvIGFwcGVhciBpbiB0aGUgdXBzdHJlYW0gZ2l0IHRyZWUNCnNo
b3VsZCBiZSBwbGFjZWQgYWZ0ZXIgdGhlICctLS0nIG1hcmtlci4gWzBdDQoNClswXSBodHRwczov
L2RvY3Mua2VybmVsLm9yZy9wcm9jZXNzL3N1Ym1pdHRpbmctcGF0Y2hlcy5odG1sI2NvbW1lbnRh
cnkNCg0KVGhhbmtzDQpaaGlqaWFuDQoNCj4gb3Igd2lsbCB5b3UgdGFrZSB0aGUgcGF0Y2ggd2l0
aCB0aGUgdGFnPw0KPiANCj4gVGhhbmtzDQo+IERvbmV0DQo+IA0KPj4NCj4g
