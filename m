Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647D8481BD
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 22:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gdDsAxix"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701209524; x=1732745524;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ifRounq5jZfsuxRxj8KHQLIbWsoLsKqK+7oWeWH0slQ=;
  b=gdDsAxix5yZop3z67joP6pgFp0F/xXA92+4wkVFqeb6ImHXOK6I7iT94
   NAq5VzlBqUKe+s6CYJMx1cGpLj9D/UdAH/jfmHqbfXbyY9mgNw7sPEozm
   MkPwlOxL1FTg6ZDj8ZF8BhiHClFJIzNjvbxaI7vQ9BALMoJKHEoVJ53Mz
   gzQxPuWz88csiUCj1yUgi/3pAJIVQe93f28hHYGxQJsSXKyQjflQYRtDb
   eh1nV0grZ3k1tBJboVTlQ6+aYxfHZ8bCWBkGegdNDlEVPQoLtT7xEE9j8
   DHnBJfzbLheM9/NlerGM1FivnreLgAZ5m5JwNMCiwDx1SILl6qCHvv450
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="392790829"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="392790829"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 14:11:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="834791336"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="834791336"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 14:11:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 14:11:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 14:11:54 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 14:11:54 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 14:11:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLma7Ao2drszg3RTJ/apBzCUKs7yHUZz9uZhPA/3MGSf4dbr0tr3Mt4rkdHR0YkDi8ujL1d6Er9ds9x7r2f022ft3a7rIY3ph1CBNGcustf1axqTFObtUWddwZJwOQQ9tVXBRWBNrz6xgGWsSU6u0FkwPMDgnEHtpV/r0t8QXEfYf7LZzOMlMIeZFBdgHnmgF49Mn+CMXOdSIbWmwkXaKJGsMGundQWV0raQgfJ3dXsvVcoRXlt7nqhdRnOe2+LlGuwYbFy2vwBUhEYOebnaQ9j9LByxk3eRvYbzTj3tEz22LX0N9JRmMV13sEEpZuNMIxPgb4LJmHe8ZmUj5nHVwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifRounq5jZfsuxRxj8KHQLIbWsoLsKqK+7oWeWH0slQ=;
 b=EYyb/nOoa5ecQySeu9chdlj9BNVAgOLfFKxqZH1L46jSebY87JCvEDvuss82Ps3gYj/9WDjy4WphIxqfnBsPlYMtTj5bgNTfNlB0e82gDXYDGZ+mk31q00/qnCDqhIqRvc9nFFPIM8yhARJVFdNo94uQ6wiOZIksuKZGcgwJQE0XWezqLiJZGIwcB/XhPLruZ7pybR4PJE7/eWlHoS+CfzWRZXb8kao+rXcPolAVYidsunxDIZmyj5bPQQ7nP/lzuXR/79ChSO4WLo6FVG6rCeJTajwIbd8Gqa/xD0HlewIGZWYlQhUZ8Mm0owzRGJM5g6zxjL0r40OaI6qpMLSc9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DS7PR11MB7836.namprd11.prod.outlook.com (2603:10b6:8:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22; Tue, 28 Nov
 2023 22:11:50 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694%7]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 22:11:50 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 2/3] cxl/test: add a cxl_ derivative of
 check_dmesg()
Thread-Topic: [ndctl PATCH 2/3] cxl/test: add a cxl_ derivative of
 check_dmesg()
Thread-Index: AQHaIbEE/jmjKBXjX02G6QRyQu11Q7CQTGGA
Date: Tue, 28 Nov 2023 22:11:50 +0000
Message-ID: <3ecd689239aace48707499eb21362d8b29a428cc.camel@intel.com>
References: <cover.1701143039.git.alison.schofield@intel.com>
	 <39c11efdefeb12c3c928f36e9c59eeb40a841e72.1701143039.git.alison.schofield@intel.com>
In-Reply-To: <39c11efdefeb12c3c928f36e9c59eeb40a841e72.1701143039.git.alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DS7PR11MB7836:EE_
x-ms-office365-filtering-correlation-id: 321fc677-02c7-4bf5-c98f-08dbf05f0556
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: daTngareLExN6eOzZ29muRYYV0skLHd0GuhOvD9MuiDkxYS5HXpX3pX/rGjZqN3TEaG9RQY/p5n5LL8l9cAnPxiTvJ+4sanhiK8U+urAFdJHGjalFNqaQiQBFSUq7gjPvw4FKWM367PYLm/tlVgmR5oGyQ4eeINjoHBuVJ+wBLe68LHui2hEJa59/MncRgGggvO5ZhiNL6FgwJJqLkS98uroZ3qpW5WhCIZHcJXPzPkfoa9EtpeBfYRFQauYs6uC5kF9la/DtwGNUfdjDyyT2khFvf8ove5qQ93ilhVR6DCWehUzl8Xjkz1UcV7AWtgsUoMtaryX3kzeceg2XstG1jnZfvc1GxcmGoiBj2lsfM5cYPoBbRbZzYjprSF17zSY6ezAr2g0at9xI/OiT9DcBa+pr+OQuL8CyHR77sojYu/GYYiCoYvtVE7kAEH0fPk5LpN6wwJINc+ZZqadaceN90pXPe0pVC7ac9cdbx5cTIOXnFIypo1fzR1khmZXwY+BdoWsS1RLrjzG1rX0d4U+TxcBvHSDMu7xpTMh43Vtbe3IlniWKNUfATIqW3BXZfVo9Woi4X75whi/iRJIpSawBfWiL+EruOOwFMxzCkx0f9Wwirnl7thtLp3F0mZXRzcV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(39860400002)(396003)(136003)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(6512007)(2616005)(71200400001)(26005)(478600001)(6506007)(83380400001)(5660300002)(2906002)(4001150100001)(41300700001)(8676002)(76116006)(66946007)(6486002)(8936002)(4326008)(6862004)(316002)(37006003)(54906003)(64756008)(66446008)(66476007)(66556008)(6636002)(122000001)(82960400001)(38100700002)(38070700009)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFNYMUVPYy9HWVBMRmRTaHRIVllta0h5ajFTUWlBMjlSaGc0VjRlRklTZW00?=
 =?utf-8?B?ZDhHd1VqUFlVMkhqaHEzVWpGZGIzYUMrUlVsbmFmblIxak84K3kyTTJBbDQ3?=
 =?utf-8?B?OVRZek5KZFFjb2RScHc2UmV4bGcvWm90aEoxQ0xVVWUrTUxNMWRPYTZkRjlx?=
 =?utf-8?B?SkZyTkUyWUd6M0xQT0VteHJUUXVINnZaQVBScEZIVWdaajI0bUpwREFwK3hW?=
 =?utf-8?B?NS8wUmRTSU9mdmp0YUtJb0JSLzRvclVwd29VYkM4dG5RaHhscitjN0xwdkc0?=
 =?utf-8?B?c1crRUc3RXlMNFErSE1hZ3ZpTVZMVlYxWXdPTUF3NWp5YTk0TW9sS2dwY3lG?=
 =?utf-8?B?Z1pKSXpIK1ViQnNZa3FwQ1RPRyt0U1NmeG8rS1FwVlJOMVdoK1NXTzRXdlFX?=
 =?utf-8?B?ZUtKRlRFaHJFMFd5QlBzSXFJK1dRSUgzcGtjUzJDVWlkRkhhSnRWeFZpQmgw?=
 =?utf-8?B?T1huRHd1Ylh5WTQ1S2NoL1pNTTl0VVo3N1duOW9kZUFzQll5bm1Vcm44a3Yr?=
 =?utf-8?B?UkhNZC9TUzUvUlNMZjEwRHVxaUNKcW13VTBRNWZuYkF2OHZDa1Btc3R4czVh?=
 =?utf-8?B?TVN6R0g4OHRoZmEwdkt5c2pVY21XRDFPQXlWZUZoZUxWaEsvUW9iN2VyVzNY?=
 =?utf-8?B?ZUdpbnJXd2NjTDdIYjVDOGw4NW9wNGQxcEl5R3ZiZ0xENWpLcmFrUkFsWGVz?=
 =?utf-8?B?WXF4RldtS2haWFdWYWV4UUMyZEFOMWk3d0NPRUlKdlN1VHBZSmtZek5YS0VQ?=
 =?utf-8?B?VXFOZytrLzIrcldGTERjbHZ4OTVHenFZZjBVODJRWS9VeTJkaWE1ZHFVbGd4?=
 =?utf-8?B?bEZoNUc0bHVaQXFkWjd2dU9UZExWWm5Tbm1ZSnAyT3ZQeVFrbWFrdlgzbDhM?=
 =?utf-8?B?UWRmZ1QwcTk5dVUyZGRuU09PdmpwZlVydGhMbWFvMlNQckk2ZG9uQndtSW50?=
 =?utf-8?B?RkpUVllVUHR6T3dkaDV1aXM2cWdxVHFpN1orVStOeEtwV0NuM0pjQ2lBeElU?=
 =?utf-8?B?dnFUWXBPcWl3d25uNDdJL2xQSTl6R1dEaGw2dXM1bmRSOGFmYzZCTFVpZXRi?=
 =?utf-8?B?alZvbERDMXlvS2xmRjdGWDBaSzgzVFBtL0VUVHVVbkJQelprczhtVEk5NDNm?=
 =?utf-8?B?Mk5VQ1ZVWUpOVW40eWtBYlBIOGlGSi9sUzNpZy9rbnljSXBFR081Q2hBRy9R?=
 =?utf-8?B?QVlHQXRabm94VkFEOUxPVE0yVEtzeFV1UjF4YU9VTUR0QTZsRkNYSXVZSXRM?=
 =?utf-8?B?cFJqVmQ0TWVadXBsa3lGcXhFWEZIYU9wcXV1WGlpRTRUWHEyelY2TFM3aHps?=
 =?utf-8?B?MUZMcnJWbXRaakQzbHhzeW1aKzlCcjdRejlISzBnZExweVBtZjZNeFhaUXQ0?=
 =?utf-8?B?YlJjc2M0d2ZTa010MFgybVB3SWdjdUpGdTlla0NSTElMVFdacW1vVk5MOWs1?=
 =?utf-8?B?MmRhWTM3dmMrRHVXU25nSHlzaFIzR3ZRQmpRbERkcVpVd2FJMk1IU0xpRDl2?=
 =?utf-8?B?MFpXbGVJWFYvVjE3dVNDbDJvK2ErWTBRU3pXQTNsRGd6b2tldVVEQ242czQz?=
 =?utf-8?B?eXhxWWh1d3prOVNRVlhydHVreFpJMzdmWWFnSUFmNEpWaHMvTzY5bjlZaXdi?=
 =?utf-8?B?bmtMMVltajFrN0Y1MVNtTW9BRHNPZlBYZ0IzSDlYclRibXpIb09EZEROTHd3?=
 =?utf-8?B?Q2FURkNveWxUTy8zVU0vazNhd1F3UlBhNkh0S293Lzc4Z01TL3lTN09ZYlU4?=
 =?utf-8?B?SW9pajdOaGNWODVaSHNyMjVRNkxNNjdPYUJZQVNTdG5saDQ0L0R5bENyMGx4?=
 =?utf-8?B?Q1kzUVJ0RVZBMTVacDhoU3ViaVZVUlVKKy9XR09ZQUZQOTBEbUc0NVRja1Z5?=
 =?utf-8?B?Vy9KSEZTRVEzdlQ0eHpZdlJqQXdWTVRmZGJrUHdKUlkxckkwa0tOY1F6Z1Ur?=
 =?utf-8?B?eHlLU1ZxNkFsZ1JRRzFuTVNHZHhXbEpNUnRoMkxkVmJZTTkwVURJVkVwM2FE?=
 =?utf-8?B?TW9IaU1zNGJoMmFSTmttcktSUGo4SDJ6ZjZXbzdhU3Z0UWVyeitGYW5jM28w?=
 =?utf-8?B?QzVpcC9jckdlejdPeHZRZUhoYUVLQnpWQ1VZbmF1L3czN21xWUFYd2p1NE9P?=
 =?utf-8?B?RThESlJHdEpLcGpZQzdwWWM3bzltd25GU3VaUXp5b2FhbFBsaEtLN3QwS0FW?=
 =?utf-8?B?emc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <89137219E7EF2F498070F867BC714A2A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 321fc677-02c7-4bf5-c98f-08dbf05f0556
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 22:11:50.4705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6hDUN8tizpokDuPFLA27imeDCn4egSZmLU98IrQm2h7AIagbvewXX7CFEdGKAZxq2fh4KSoJj8P8zqa0u5RyvEmUVoRRnod4jG3VJN5ENBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7836
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTExLTI3IGF0IDIwOjExIC0wODAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBjaGVja19kbWVzZygpIGlzIHVzZWQgYnkgQ1hMIHVuaXQgdGVzdHMg
YXMgd2VsbCBhcyBieSBhIGZldw0KPiBEQVggdW5pdCB0ZXN0cy4gQWRkIGEgY3hsX2NoZWNrX2Rt
ZXNnKCkgdmVyc2lvbiB0aGF0IGNhbiBiZQ0KPiBleHBhbmRlZCBmb3IgQ1hMIHNwZWNpYWwgY2hl
Y2tzIGxpa2UgdGhpczoNCj4gDQo+IEFkZCBhIGNoZWNrIGZvciBhbiBpbnRlcmxlYXZlIGNhbGN1
bGF0aW9uIGZhaWx1cmUuIFRoaXMgaXMNCj4gYSBkZXZfZGJnKCkgbWVzc2FnZSB0aGF0IHNwZXdz
IChzdWNjZXNzIG9yIGZhaWx1cmUpIHdoZW5ldmVyDQo+IGEgdXNlciBjcmVhdGVzIGEgcmVnaW9u
LiBJdCBpcyB1c2VmdWwgYXMgYSByZWdyZXNzaW9uIGNoZWNrDQo+IGFjcm9zcyB0aGUgZW50aXJl
IENYTCBzdWl0ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFsaXNvbiBTY2hvZmllbGQgPGFsaXNv
bi5zY2hvZmllbGRAaW50ZWwuY29tPg0KPiAtLS0NCj4gwqB0ZXN0L2NvbW1vbiB8IDE1ICsrKysr
KysrKysrKysrLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGVzdC9jb21tb24gYi90ZXN0L2NvbW1vbg0KPiBp
bmRleCA3YTQ3MTE1OTM2MjQuLmMyMGI3ZTQ4YzJiNiAxMDA2NDQNCj4gLS0tIGEvdGVzdC9jb21t
b24NCj4gKysrIGIvdGVzdC9jb21tb24NCj4gQEAgLTE1MSw2ICsxNTEsMTkgQEAgY2hlY2tfZG1l
c2coKQ0KPiDCoMKgwqDCoMKgwqDCoMKgdHJ1ZQ0KPiDCoH0NCj4gwqANCj4gKyMgY3hsX2NoZWNr
X2RtZXNnDQo+ICsjICQxOiBsaW5lIG51bWJlciB3aGVyZSB0aGlzIGlzIGNhbGxlZA0KPiArY3hs
X2NoZWNrX2RtZXNnKCkNCj4gK3sNCj4gK8KgwqDCoMKgwqDCoMKgc2xlZXAgMQ0KPiArwqDCoMKg
wqDCoMKgwqBsb2c9JChqb3VybmFsY3RsIC1yIC1rIC0tc2luY2UgIi0kKChTRUNPTkRTKzEpKXMi
KQ0KPiArwqDCoMKgwqDCoMKgwqAjIHZhbGlkYXRlIG5vIFdBUk4gb3IgbG9ja2RlcCByZXBvcnQg
ZHVyaW5nIHRoZSBydW4NCj4gK8KgwqDCoMKgwqDCoMKgZ3JlcCAtcSAiQ2FsbCBUcmFjZSIgPDw8
ICIkbG9nIiAmJiBlcnIgIiQxIg0KPiArwqDCoMKgwqDCoMKgwqAjIHZhbGlkYXRlIG5vIGZhaWx1
cmVzIG9mIHRoZSBpbnRlcmxlYXZlIGNhbGMgZGV2X2RiZygpIGNoZWNrDQo+ICvCoMKgwqDCoMKg
wqDCoGdyZXAgLXEgIlRlc3QgY3hsX2NhbGNfaW50ZXJsZWF2ZV9wb3MoKTogZmFpbCIgPDw8ICIk
bG9nIiAmJiBlcnIgIiQxIg0KPiArwqDCoMKgwqDCoMKgwqB0cnVlDQo+ICt9DQoNCkkgbGlrZSB0
aGUgaWRlYSBvZiBhZGRpbmcgbmV3IGNoZWNrcyAtIGhvdyBhYm91dCBhIGdlbmVyaWMgaGVscGVy
IHRoYXQNCmdyZXBzIG9uIGEgbGlzdCBvZiBzdHJpbmdzIHBhc3NlZCB0byBpdCwgYW5kIHdyYXBw
ZXJzIG9uIHRvcCBvZiBpdCBjYW4NCmhhdmUgdGhlaXIgb3duIGN1c3RvbSBzZXQgb2Ygc3RyaW5n
cy4NCg0KU29tZXRoaW5nIGxpa2UgdGhpcyAodW50ZXN0ZWQpOg0KDQojIF9fY2hlY2tfZG1lc2cN
CiMgJDE6IGxpbmUgbnVtYmVyIHdoZXJlIHRoaXMgaXMgY2FsbGVkDQojICQyLi4gOiBzdHJpbmdz
IHRvIGNoZWNrIGZvcg0KX19jaGVja19kbWVzZygpDQp7DQoJbGluZT0iJDEiDQoJc2hpZnQNCglz
dHJpbmdzPSggIiRAIiApDQoNCglzbGVlcCAxDQoJbG9nPSQoam91cm5hbGN0bCAtciAtayAtLXNp
bmNlICItJCgoU0VDT05EUysxKSlzIikNCgkJZm9yIHN0cmluZyBpbiAiJHtzdHJpbmdzW0BdfSI7
IGRvDQoJCQlpZiBncmVwIC1xICIkc3RyaW5nIiA8PDwgJGxvZzsgdGhlbg0KCQkJCWVyciAiJGxp
bmUiDQoJCQlmaQ0KCQlkb25lDQoJdHJ1ZQ0KfQ0KDQpjaGVja19kbWVzZygpDQp7DQoJbGluZT0i
JDEiDQoJc2hpZnQNCglzdHJpbmdzPSggIiRAIiApDQoNCglfX2NoZWNrX2RtZXNnICIkbGluZSIg
IkNhbGwgVHJhY2UiICIke3N0cmluZ3NbQF19Ig0KfQ0KDQpjeGxfY2hlY2tfZG1lc2coKQ0Kew0K
CWxpbmU9IiQxIg0KCXNoaWZ0DQoJc3RyaW5ncz0oICIkQCIgKQ0KDQoJY2hlY2tfZG1lc2cgIiRs
aW5lIiBcDQoJCSJUZXN0IGN4bF9jYWxjX2ludGVybGVhdmVfcG9zKCk6IGZhaWwiIFwNCgkJIiR7
c3RyaW5nc1tAXX0iDQp9DQoNClRoaXMgbGV0cyB0ZXN0cyBvcHQgaW4gdG8gYW55ICdsZXZlbCcg
b2YgY2hlY2tzLCBhbmQgbGV0cyB0aGVtIGFkZCBhbnkNCm9mIHRoZWlyIG93biB0ZXN0LXNwZWNp
ZmljIHN0cmluZ3MgdG8gYmUgY2hlY2tlZCBhdCBhbnkgc3RhZ2UgYXMgd2VsbC4NCg0KPiArDQo+
IMKgIyBjeGxfY29tbW9uX3N0YXJ0DQo+IMKgIyAkMTogb3B0aW9uYWwgbW9kdWxlIHBhcmFtZXRl
cihzKSBmb3IgY3hsLXRlc3QNCj4gwqBjeGxfY29tbW9uX3N0YXJ0KCkNCj4gQEAgLTE3MCw2ICsx
ODMsNiBAQCBjeGxfY29tbW9uX3N0YXJ0KCkNCj4gwqAjICQxOiBsaW5lIG51bWJlciB3aGVyZSB0
aGlzIGlzIGNhbGxlZA0KPiDCoGN4bF9jb21tb25fc3RvcCgpDQo+IMKgew0KPiAtwqDCoMKgwqDC
oMKgwqBjaGVja19kbWVzZyAiJDEiDQo+ICvCoMKgwqDCoMKgwqDCoGN4bF9jaGVja19kbWVzZyAi
JDEiDQo+IMKgwqDCoMKgwqDCoMKgwqBtb2Rwcm9iZSAtciBjeGxfdGVzdA0KPiDCoH0NCg0K
