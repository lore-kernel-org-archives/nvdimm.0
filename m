Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB6E172BD5
	for <nvdimm@lists.linux.dev>; Wed, 17 Apr 2024 18:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713377692; cv=fail; b=IFnvKk5RIN92+X/03yTI63zGi13WsiLWoosCRQbh9RhKwfqI7CI0nHftYRJim6TXau1Z/h/7KyTK2pgt0UE2Ia903T6RJoAGGsA86ZqS27FBGR4rKgalq9dwFw2RgdAnDCp407n+Weri1UcHiuWlRp1adGjA+T1jG0MzS2nMVC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713377692; c=relaxed/simple;
	bh=grINUycUEFct0HDT7aK73y+p435JyUqImmsood1NJnQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JYpQtr7jpPCP2K41126Lzc3s+evxJ2joBzFIWoFpdDPYlLKPFRNfJnQaVvDNh3xJlkkjf1XzSHlyue4/AxJZx1z0A9i5EBH8+umYtF03wPiVzrF7MvwIq/HAiFRaKF4OUXY774UmCakoefG7C2GjBSEA2NTALfEmJPEEeOxooWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TebJcOQB; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TebJcOQB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713377690; x=1744913690;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=grINUycUEFct0HDT7aK73y+p435JyUqImmsood1NJnQ=;
  b=TebJcOQBkzSz6IMseLyv09JKN/ob77MqTWqrupzhq4mzFGdkyLrWYgYE
   2x5mYYDVII3qLpVjtUobivFUYcIpQ2ZUvBv9/EArv4G9zAUzomzvpvons
   ezrdyp+KdVWA8MUrVhxIXf/XT8TNNpNukLr3kK9bRF/OJuBT1q6C6HyW/
   OGr01zKa7dn46FHjiFBLOm8MNb26fOVCT+qTHBgKnytIYzs5P3YsjY/fn
   IOVnMdLNDVyZW9HqlM8PrF88LcEXOwWG42qc1uvZ3KGdswMKQnNRADpUh
   VC2QKy/mL4rTFEXkUsGgOz33ZmhKteD+SS9v5fy3uA2ZxTp4x8XcmXOgh
   A==;
X-CSE-ConnectionGUID: vlG6I/iVQHeCySfDqea+gg==
X-CSE-MsgGUID: mdRTgAtWQFS34JAXN8+dqA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="12667011"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="12667011"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 11:14:38 -0700
X-CSE-ConnectionGUID: oS4wU+JbTlaqjY80dSBC7g==
X-CSE-MsgGUID: +8uCfvTBSmSbsApxF44TPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="23201520"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 11:14:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 11:14:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 11:14:36 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 11:14:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoWLSrKZTVVLPKqHaWYh3WCUfGzaRQ/7x5qGQR8h1ON2L9Rr0zlLzd4twLkpiUjyMeb5bIQVzhgN2GPIB5t7lS0p6AfRI6T7RIGENKNK3S9aIWzKJF4/g1HdNEHqB3x8IxGdjY+n/wSC3sl55as3Emw12TGxug0JqanpidfKkuI9JfTxgxlJDbCNmzWRWH1Qh8bPt8VPnjvreslrYQrYX18UQr3VNrDZkyzW5sc1U2FBtI/ifjTf02+7DkUtcNh2cJTOLrlQA2QV/Cn/Pg/y7enKog6/I1GYSlhq4hYt/quNtn33lypLLYyrvKoUMKjySIyYlRyxYkS6Wl+eSxTA+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grINUycUEFct0HDT7aK73y+p435JyUqImmsood1NJnQ=;
 b=hCT+XaOkc5lDrfEk/ZoduQPx7VD0Gy4+xShDEz6p8ZJt5UJQPU4BXkvzGvVSYLsDEhbbYQKsPmI39S3Kz9J6iRMkoa2Q2Msvgg7Bbh8T6D/7V450qC34SMaJO75+N/dDnNUkMBlxhV9W7uNUjK0M4TI9KVmw2K2HME2q5NQgxNt+RC1H0BqEx0qKT477bHFZZupYh2W5FG+0bm/crFqAK5vgPMVDTTPAN3WJ5WIXK7fA5O0K4K8790dFfl6pSFfs2onvPZTYZrQcEjdSXXA98pSMxPtSwx4YKZlooepidmL7ID4Fu4iG7xFP0ZunQMgHqYjOqv6XtYSzTZKaUvSO2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SJ2PR11MB7518.namprd11.prod.outlook.com (2603:10b6:a03:4c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Wed, 17 Apr
 2024 18:14:05 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034%4]) with mapi id 15.20.7472.037; Wed, 17 Apr 2024
 18:14:05 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "yaoxt.fnst@fujitsu.com"
	<yaoxt.fnst@fujitsu.com>
CC: "caoqq@fujitsu.com" <caoqq@fujitsu.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re:
Thread-Topic: Re:
Thread-Index: AQHakJL+anHlYPh7b0WUMbDzlAh0abFsxOkA
Date: Wed, 17 Apr 2024 18:14:05 +0000
Message-ID: <9b00e36292b7aa19f68bda6912b04207f43c8dc5.camel@intel.com>
References: <170138109724.2882696.123294980050048623.stgit@djiang5-mobl3>
	 <20240417064622.42596-1-yaoxt.fnst@fujitsu.com>
In-Reply-To: <20240417064622.42596-1-yaoxt.fnst@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.4 (3.50.4-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SJ2PR11MB7518:EE_
x-ms-office365-filtering-correlation-id: 8c6a0dde-971d-4c80-38ed-08dc5f0a2ab5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eE6cDQvtqM8+zMM/I4wxrYvO6V3yn4rSdxpHjLU4yLjGnyBb+C8z671Gc0+50jT5LH38lKawO8XQ46UffYkQ91kxwMbsMH6ZrCwqy3uh8i+uw05GKfDzQOas8qfVcErI+bcrJZLDloUqwbJMy4XtrKp9N0NvG0yVSB7J7d/o0qOeNxLO5lPVR1l5meoDA4vAHxMmKxVycvBMZFKh0QPqNIhO9crwIUPmBed4i1uHx5FXApxdoQ/gmopHssW6T5EvX3gWnRrNymetn+IOHUrFgtJEGKPM2yFIQoCyB7uSQFKtcn3CfYU9sbQpYFW3rkixukAH+PxrfLMWubpXh96CWbC9xAvjIzBsQNuPdYAEvqdX/ofO83YJySNH9ZyWh6CkgPeoHvpYFVKr62/N9FZNDEhZgf8BihN/0PtQiS5fHbOfNlfg0Rx6ZoJ75MacgJiocUuvYaj3EhUO3eirPrCflYwTWkqrzYqVTOf//J7yZF9/HHz8a6gqOe75twzyn6yJOF7dhMxIHZNSSizhHm8Ct0VGJPC1NkYS7nHar89zvZKPk6T0RdDxPshf2lwgRiErwyJgilvZJy0tOpCCp46PlTPQUUoclNJx/NEWMMGMA9l7zDLQQ9PO0lH0lgvGxuijYr4Wqz4BZAm6FC93zy7fAT4zIXkYTRrsuisg6Bg1NM/bCduAaW3oUNbg0ruqq+M+97K3vJUHSnMSaVFcCjzCTOvVzMHa4Gc8k+Pr9PWzHV4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVpQTmwrWUVPQlZMY2JDbStxak5KREk5bFIxbG9OTS82SlZNdDYxZDgwRnMr?=
 =?utf-8?B?Y2hrZUJhZEdiZEVPbnJ3aHFPUTVuZDhMR3Z0MjdKSEdZeWpncWwwTktZM1ZT?=
 =?utf-8?B?Rnh6QUlGVHowblUvMnF5bkZoTGRZL3JvUWlobXJlMjh3MlVGUHRkSDhrN21m?=
 =?utf-8?B?TTFrVnYvTDg2Tk9QRVJ4RlNNZ3h6STFla3lHbnBuQUtzRllBMWd4azNzQ3dm?=
 =?utf-8?B?a3NYejJpRzB3Q2VnTTVLUkFNRXJCeEhWSTZpK2t3WENCZTlnZGZGMmZKbmpa?=
 =?utf-8?B?NHVsMzZXc3R2VXR4U281SjNsVWhLRTM5VnpRb0lSK0tBVllWa09peVhTS00x?=
 =?utf-8?B?b0FPclJUa0FIeVY2alBvSGRHQWVFZzNYalRoakw1TE12VktsTDdkYjZCK013?=
 =?utf-8?B?eEVNYndmeHZ5VnAwYkl1NERvVGRzRzd0am5EQ09MWGtYWW55OG5yZ05BNlpa?=
 =?utf-8?B?a0hoVFRmdktOUmtnS2Ewd1RUa1lGZVZTMWI4REdvaUFXTjhvU3puVmZZTUIv?=
 =?utf-8?B?bVNmZTAzdTRZZnZnZXU1azN2aUR2MGpNTUR3ek41STlhWGwxVm95QjgySjFu?=
 =?utf-8?B?NGhrUzVtdm9aRVo1S25nYlp5YWZtM0wxTmIxUG9qSkNTT0pwaGxhdDVRd2tn?=
 =?utf-8?B?d2NTVWRhM2x4dXlZOC9jMVdLTVp6WEFrbmQya1NLMHFMdVltV0ozRTc0VEE1?=
 =?utf-8?B?TFZQbHltTENIeFFpaHpBZkdkQVRrUGFwMVM0OWlYNHV5UnlvOCticWhJaTYy?=
 =?utf-8?B?Q294V29FNHhwMkg3SWIrLy9Ga0UwSFZkVTZtcEdnTWYySFUwUXVKdHQvQjZE?=
 =?utf-8?B?ZnF1SURJUHIrUmNpUFo5N3prYy85U1RMVmMyeGNNekxMK0xRcE1WeUpYZkdT?=
 =?utf-8?B?TDVEUjcvbGY4K2hVUTBPeGMyeHdHU0hnL29weDJFeU84b29mYy9QNEtJdUJP?=
 =?utf-8?B?b2Z3bHVaNEx0b2JpcDRiV0hqQlFrWFVyVW9RTHdzb0V0eEFISkQ2ZWp6YTFl?=
 =?utf-8?B?Z3BpalZlZk85cm9TZVVpRHJKcmVhOXRObm5CRkozdUJPTEpNRk5jQjJBemhP?=
 =?utf-8?B?MjJmM0tQTGJWdGtxSGh5Sm9lTzZ0RlNaazIraEs0OTFocFc5T2N5cjlEelBQ?=
 =?utf-8?B?a2JNa1pVQjAvbFgwUEdoL0ozQy9HSW9Ua0thMUN5NlI2TmtHcStubTVUOTFL?=
 =?utf-8?B?Zkh3ZllRVk4xNVR4VmJMamhwUitzR3lpNlhHcGFTRFVxdTQ3bEU4ZDJwZnda?=
 =?utf-8?B?SnkrTmFKZTBDOGkvVlpWWlJVbTRNdGEvRDBKT09OdWpxMGpaZ1cxTllWaEcx?=
 =?utf-8?B?SlRiazlhR0dlcGNDL29JK1J5N3I3MG00NnA4VTRhNjFaUUtudUJrbVlyNVB0?=
 =?utf-8?B?aVlHOTJQVWx6bEc1Q3Z2OFl5cXpnSGZWZzhIRERJcGZnbzZMdXVvVG5ONXNl?=
 =?utf-8?B?RXlqMW9ITGN0Y0RNU0VZRkN0QXpudXp0ODV2bG5xNThtLzYranJ4Rld5UDd6?=
 =?utf-8?B?R21PeHJVK2d4d29Va1Q3LzcvWXp4R2M5TXI1dFVUMm5Xc1QzdXVVTUkxbFpL?=
 =?utf-8?B?ZWRjb3IxSDBNNlBmS3laVVMxeGNXSHptYVJDR2F0MUR0azhtQWpjOUdIbEVy?=
 =?utf-8?B?ODRoZnh0eVJiNlRYS3hweXhRTE5saWM4ZGQ5aXFMS2dtd3o4YjZLVEk3UG82?=
 =?utf-8?B?QkN2enU5ZEJJTk5yVHhMV0hmcHhPOXErU0pGUU00aTFMZ3JNYjFNRUVFSlNw?=
 =?utf-8?B?TFdPdHBvanlKTHh0TVlIYUJ6OW5NQWNuNGs5TC81UzRSSi9LNlJ4Wkhua3dP?=
 =?utf-8?B?YTM1NUt2bDF4ZUsyWVZnU0VnWERCUmZFdVhCalhUSWVnT0VHOWFNVDJxbDEx?=
 =?utf-8?B?OFV4SGdjbDJSTDkyMDczSHZiNjVUTkVJWmNzMk1zTVFxeUNHUndCc1JLQ2ty?=
 =?utf-8?B?UzRiOVF4R1dscUFkODcyTnFHdDMxZytjSk1HSjlRVzRkdE91TTRFa2hWcHFu?=
 =?utf-8?B?Wmp2emdhOWk1L2hEQWJZa01iVTcyUS9NZXhuYWY1b0JxZ1ZRcWcwdENIemUy?=
 =?utf-8?B?K2xRSEtwMHJLV3cvb2JjL1NXYjhZRzQ0OTQwVEFoTlJHVGV5bkxBTWd4a2xm?=
 =?utf-8?B?emo2VUZObkE2VmJPZUM5emN5d2NvZEM3SVRZd0VqVGxQYUxyekQ0aDZkem9N?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <195D760DD942774297FB8623963D6C59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c6a0dde-971d-4c80-38ed-08dc5f0a2ab5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 18:14:05.0295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9MSzfPFvZIeNwpJuWVsRcyb6LCojYU6MvUogLh6d0oujXUyUdnNt2JBCm2EVILt87uqtbaRDAXT59C4qVJ0sK9etrae20EvyXBHG9an0C/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7518
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTE3IGF0IDAyOjQ2IC0wNDAwLCBZYW8gWGluZ3RhbyB3cm90ZToNCj4g
DQo+IEhpIERhdmUsDQo+IMKgIEkgaGF2ZSBhcHBsaWVkIHRoaXMgcGF0Y2ggaW4gbXkgZW52LCBh
bmQgZG9uZSBhIGxvdCBvZiB0ZXN0aW5nLA0KPiB0aGlzDQo+IGZlYXR1cmUgaXMgY3VycmVudGx5
IHdvcmtpbmcgZmluZS4gDQo+IMKgIEJ1dCBpdCBpcyBub3QgbWVyZ2VkIGludG8gbWFzdGVyIGJy
YW5jaCB5ZXQsIGFyZSB0aGVyZSBhbnkgdXBkYXRlcw0KPiBvbiB0aGlzIGZlYXR1cmU/DQoNCkhp
IFhpbmd0YW8sDQoNClR1cm5zIG91dCB0aGF0IEkgaGFkIGFwcGxpZWQgdGhpcyB0byBhIGJyYW5j
aCBidXQgZm9yZ290IHRvIG1lcmdlIGFuZA0KcHVzaCBpdC4gVGhhbmtzIGZvciB0aGUgcGluZyAt
IGRvbmUgbm93LCBhbmQgcHVzaGVkIHRvIHBlbmRpbmcuDQoNCj4gDQo+IEFzc29jaWF0ZWQgcGF0
Y2hlczoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3hsLzE3MDExMjkyMTEwNy4y
Njg3NDU3LjI3NDEyMzE5OTUxNTQ2MzkxOTcuc3RnaXRAZGppYW5nNS1tb2JsMy8NCj4gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3hsLzE3MDEyMDQyMzE1OS4yNzI1OTE1LjE0NjcwODMw
MzE1ODI5OTE2ODUwLnN0Z2l0QGRqaWFuZzUtbW9ibDMvDQo+IA0KPiBUaGFua3MNCj4gWGluZ3Rh
bw0KDQo=
