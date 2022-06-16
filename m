Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321036AA6
	for <nvdimm@lists.linux.dev>; Thu, 16 Jun 2022 22:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655418274; x=1686954274;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XqDdpHRr8Eiw/e1dE+q+hRbTwvN1T7bvvkIfr1V7nic=;
  b=oJoHKOEVjhxtjGmy8Y+sEnyPSiNmWG9JUevVQKLORecESvo9HlfBypWh
   BVUnj+YwnMhtcNLbsbVIiiaTaIqVEK8VioN2/MapbAvUokN1Jd/YO0mP4
   1DMSfW9OkIQwozEqONMW3GA9Dysf+VKXFbsqZm7OIvutt1iD4Ug68D9Dj
   V38JduYC8XOC5cNtYqyCjipsYdgPFn0XrNX0OMUamr2E5ec+hSQiyLUwr
   yptu23naGZTI4akFXtqsWxTfXh2hM65FD27bgjELqRBc+vsnpKyzXS/o1
   v9ZGG7jWrZfrjbYIRNvIcir7f8wX561TPkX2a2Y/E/QIQIIbye+2voXvV
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="276939335"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="276939335"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 15:24:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="589840396"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2022 15:24:04 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 15:23:13 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 15:23:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 16 Jun 2022 15:23:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 16 Jun 2022 15:23:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIThu2a4J4/2iGXqkQr0q82ejUPYxnfulzZDgkOzkoZByl0y+C3zpKcZnbmTWVFvoDg5j4cfQpIO65mUMiebAnoUSSUhWn4RDCFrRp1S7zhNbAlL6O0eAYlQbp+ZsZK+/1xvur8/C+rIuTELJaPCiXPGGE4pObBY/TCjDy3av4XRDXc7bK6wagKO/k4PQpn5RfChaM6j/2/Ecdi4pp8z/G+FPbg/WSMnYLpXQ+vQccmCfBW4IaGoMrnIf+j3rdkhWTJfqlpoHjUbO6ngUFqQI2JjZLrPfDBVDDMrA+MjnCZcixVJH5/69Z8qlClOIVgerwgu04t5ZQA/RmObr2bRcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XqDdpHRr8Eiw/e1dE+q+hRbTwvN1T7bvvkIfr1V7nic=;
 b=YmYJZr9668Q08uLUWOTUjBLT3sLaQriLPr9ak9xOeXEzUMkHwDvO/7kBgsbwUcaS8c8ewn5LLY/1HCiDOCcsN28MoL4d/hku+YrV5w+izVJgIFyJKwGBQoD9fO2AlWtvndjtOgU8yyXso9kehlokHnb8/8fSRRrv90+bpZZC6knTGgR8A3gNYvm5LnIoVO+95e3XzTevfhWKD7n2OugzqVu1kMcaKSAbL3kAE7REWzlDTA2CwnlOzboNLC4QE7n6t1F8jwZgbeZVN8blItng42ivEj7vwcIHaSElOyWGBBrZswXLe+kmE4L95rwPlZh4/SJBdqeHdXPRlbEF8L51Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BYAPR11MB2822.namprd11.prod.outlook.com
 (2603:10b6:a02:c8::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Thu, 16 Jun
 2022 22:23:11 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5332.023; Thu, 16 Jun 2022
 22:23:11 +0000
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "david@fromorbit.com" <david@fromorbit.com>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
CC: "jack@suse.cz" <jack@suse.cz>, "djwong@kernel.org" <djwong@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Gomatam, Sravani"
	<sravani.gomatam@intel.com>
Subject: Re: [PATCH 8/8] xfs: drop async cache flushes from CIL commits.
Thread-Topic: [PATCH 8/8] xfs: drop async cache flushes from CIL commits.
Thread-Index: AQHYgc+pXbJiH0USrkWALNp+gwY0+w==
Date: Thu, 16 Jun 2022 22:23:10 +0000
Message-ID: <2820766805073c176e1a65a61fad2ef8ad0f9766.camel@intel.com>
References: <20220330011048.1311625-1-david@fromorbit.com>
	 <20220330011048.1311625-9-david@fromorbit.com>
In-Reply-To: <20220330011048.1311625-9-david@fromorbit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.4 (3.42.4-2.module_f35+14217+587aad52) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05ccd4ee-5c66-4076-5260-08da4fe6cc02
x-ms-traffictypediagnostic: BYAPR11MB2822:EE_
x-microsoft-antispam-prvs: <BYAPR11MB28229A528ACB1CC6C9F45A1FC6AC9@BYAPR11MB2822.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m8iiUQPLd2Ln/wycNPHrzC8pbZoaMVp66nW3ag43nDlOPPvsT5iDG3mTHhPGU9gzDxOTipycoEJPkOdJdTu5hTJbcbDTyumt5wxcvJXEUY2E7BQuIfswHk0wlDgH2pnEoMR8GC87DcLEjOxWiby2XBGUkfOsGm0zDluWls1fktEn8ppUEPaRYXouPq7T/Oxiqp4ls2bnpINOItowBN9i3n98qUOHn+KD24fbjzs5EMepUQqfo9nz6cEEfC0/8NElWrBCnRng9GGdwGDngCb0TpSUz9/9FCv8hI42kC+AbbNckRWZDdNEX7FbeUSGTPyogJmWbo3v6REbz8jL41s/2xlDTzQ9q2wc0vuQd/3xKrrJJ2wO3iFg/3cSdsPOgCuFmfdcuIE5eKFEZhNHP5uz9psr8SrgL5DI/WgOEq7nHpjhDnPJjxJhCJZGLQELnsVQeDlUXPErYhuo+rp3xjfNIC3XrNRJWvZW6ua/llFclNz6sp/wRlV9tcXhk7/QyvF8XfpMo5qRe2s93U6kLRkMSAGd4EB4pNXriupmEVENz5oBRlTqZZ51SPZLtwnANoKGJ5IO0gXgeXOhzQHsaV3gDdIXHR7rquU18Ri83598Mv+B577u2XZRCn2T2whjVx6bv3LzPp6yvG4vn+sUy5Y+6YoRhtN8GcXNyh2dix0n8RQyUIfwWL8PfNy5Pp6HVorD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(8676002)(26005)(64756008)(40140700001)(36756003)(4326008)(82960400001)(122000001)(2616005)(86362001)(66446008)(6506007)(5660300002)(66946007)(76116006)(110136005)(6486002)(316002)(8936002)(66556008)(2906002)(71200400001)(66476007)(186003)(107886003)(38100700002)(38070700005)(83380400001)(6512007)(54906003)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDVjN240RFN5UyszNFZWN1pTeW0zZU9CZ0xUSDlJSE82enVNRGR2ajBwMVd1?=
 =?utf-8?B?NVhiZVlucjM5NXV6TDdVdEFmaTFHK0hheWxBaHBneHZ0L25abUtmeWhyUnpB?=
 =?utf-8?B?aks4UjM4T2Z0Wk1YUlJnN0ZvcUlkNFQxTFVvWnQ3RTdzb3NGSVlvdXA5a2Rm?=
 =?utf-8?B?TEJvc0tjcjc3MkdGblArUDBSb2JMeGUyVVZZOW16QVhneHpGSVVneFArUUdC?=
 =?utf-8?B?cW93ODI5TTRvT1JJQzd0NEc0QTdrcnpqcGN2SE5CVERhempMcktHZTdMSTRw?=
 =?utf-8?B?VWNYTHQ5dEtLUGRJZFBnc3JCUG9RY2NlbGJRWWlvNFNoNnRsaUkyUm9FWjBI?=
 =?utf-8?B?ZXJ0ak8ybWk5QjNMVG9Ja3FLQWlnNmFURFRyYmdQYmxMYS9QMUIybFhpOGIz?=
 =?utf-8?B?Wmk4NDJpc044dXFtUTlaQU4ySW5UdWJnSFVVdlU0KzRLYnhEZ3ladURucFgz?=
 =?utf-8?B?UFBzZnljUkQyL1plVXo1cVpGaWpTR2ZEaElQNnoydEJ0eGJIdHhObjBnaldl?=
 =?utf-8?B?S2hFd3lvVTZoOFFyZHlBaEdBYW43VEV0TnZ5S0xRUXl5NkV0S0E3U3BPQU5n?=
 =?utf-8?B?ejhNTGVqNXNBOHBraFVFNEtsK28vSEw3ZnZKRzhJM2RsUVBOYWpTR0U2TmQy?=
 =?utf-8?B?NFR3bHhkQVJiRXAwSzQ2czFTWXJzQjBwUmhiM1BodnZ3QjlQR3MySTBLS0hj?=
 =?utf-8?B?bW1YQS9NVkt0eCsvVDNOZUdvOTVFaEZUOWdJT0hUbkVNQzl0Uzg0a2FCajFU?=
 =?utf-8?B?MWJOQ1pGRGFqYm9Qc3h5V3l3M0o4R1ozcXpRWUtVN0w3djdudThhS2oxdTdW?=
 =?utf-8?B?VHV5WVJ0MkpldkRkVXVmMFpaRlBtSlFvWmNDS1UybU1ZS214b1ZXTWRpNVF1?=
 =?utf-8?B?c25aTzNvaGRlTlorZjZleEllQ0VZeUxpQUh4NW5JeDY1eHFOczJXNUIwY3JC?=
 =?utf-8?B?aEp5MnRiSiswUzYyQjljQVEvR3J3c2FwTW5BK1JuLzkzTkh4aWJqeWJZUkUy?=
 =?utf-8?B?WUFhUWNBUmhyZ1hBclRPRFNEWDM2OTVlVENkVUpZbGUzZ2d4SjJkYVErOWEz?=
 =?utf-8?B?RklOcys0cktXKzZUWmdlWEJOR1ZaZjVDYWZUaGViZiswaUJ4REhaN0crN01H?=
 =?utf-8?B?NjBWRFBkaStUMy9rMDQ0Q0FidHlRZUR6K3ltTXJXTlVsSTNwcWpieVV4RGFG?=
 =?utf-8?B?MWxXaUJwMDJ5MmgxQ1BwTVN1UDZLRWRJWGVOcnRaZjZEd3ZQN2hVRFZNNW91?=
 =?utf-8?B?aGxpWVZ1TTl6RGlGdFkzcEVhU0RBYVVncE9iNlllL0ZQZllHNTVCeFlXMkpk?=
 =?utf-8?B?ZkJkY3BvSWNmOGZiekNpbEo4VTdtVlp4ZXQvS2orSmM5b2xQc3lvb0YrRVUr?=
 =?utf-8?B?TUc5SHE4SXBPZnZ3S2VUdGNXa0pUTzYzSlplOC94TVI0aVIrNGJvYUpZVzZP?=
 =?utf-8?B?ZDh5RmNNTW9tYTByazNMUXE2VytVQWw5MWlmN3d2dTFxL2xjSjRnWnBXbkQy?=
 =?utf-8?B?NVM2TGpsdFRONDI4bXpIT2NheUxnWnQ3WElyWjRrSE1KWHQ4cERYOEVmVTFz?=
 =?utf-8?B?MkhZeE1ueEF5ODBzWFZEcWFLZHdCZ0NFVXhoeFliUGNONnBydXJWMlhZWUtC?=
 =?utf-8?B?bllsczlZd3NvTG1BSWN5NXFoNUtCT3dxN0taNWdnMTN1eC9QcFNiY2t1b00y?=
 =?utf-8?B?RUw4dXpjWVYxRFFycys0OW9Yc3VrdnA5RXpvZTJUclBvekpwbVVSTjl5L0lZ?=
 =?utf-8?B?L1B2M0tBTXNPZWNyOEVzZm1TaHg0RWVRZVFZNUdETjBGbWtRbUdDZlR0ZTNQ?=
 =?utf-8?B?ZmVQbUlaMDFTdytPQmdGc0hUVVBadDRoNFdZdGIveTB2eW42MDNLTmJGZHZq?=
 =?utf-8?B?eVFxdjNiK3NzOTgrbFBOK3pFS2p2bFBaY0dvRkU4eklWeDAyMlRud1JsV21u?=
 =?utf-8?B?STNyOTBHWGdPVW4zMmhVQmNRLzBUdW9lYUZSNEZXc1FWcC9IancvTC9SK2lq?=
 =?utf-8?B?OUZUd0hWMDdnbHFhNU5KemNoR1NGZ3V1c3lKQXFrNHRZc0NPajFKaEF1YXI1?=
 =?utf-8?B?S05Cc2xEemI1ZFZydFRvS3Q1YTU4L1lsZ1F4RFJRUktCTTBacWpzQ1cvSDJN?=
 =?utf-8?B?bU9raktvSzFCYlpSVU1Say9qZjIrL1h5dy91ZTNmamRxM1plTnBjMmZrYmo2?=
 =?utf-8?B?MTZ0ODlJNm9TZUhiY1N0Q3c3bGJjNndTYitnSE1zZTR1SWp4SEpSNDZSRnhz?=
 =?utf-8?B?cUZJeExrREFrYjV1OTRZbmFlaDVtNUoxWkJJRnM1NWZwUnp0YVUzckx2czRs?=
 =?utf-8?B?QVhjbnhUK3owaTZYL3poUjQ3VE51Y1g2cDk4NGhTL1hZbDE4OFVVMDlqRGtB?=
 =?utf-8?Q?kDShrfIF1q00/hFI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <550CFDA9D7A5F944A6F0B431E9FC9580@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ccd4ee-5c66-4076-5260-08da4fe6cc02
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2022 22:23:10.9810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UPyt/SFM5fAusipUqouE4NqU/q7UKFzESVLBd0xL/uZ2Kf1yBT0DLyVmEnGxyccYJOD7e5Wxm1C6tu45XS/7yMiXNk78sjzQu/Tt6fCxJe0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2822
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTAzLTMwIGF0IDEyOjEwICsxMTAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IAo+IEphbiBLYXJhIHJl
cG9ydGVkIGEgcGVyZm9ybWFuY2UgcmVncmVzc2lvbiBpbiBkYmVuY2ggdGhhdCBoZQo+IGJpc2Vj
dGVkIGRvd24gdG8gY29tbWl0IGJhZDc3YzM3NWU4ZCAoInhmczogQ0lMIGNoZWNrcG9pbnQKPiBm
bHVzaGVzIGNhY2hlcyB1bmNvbmRpdGlvbmFsbHkiKS4KPiAKPiBXaGlsc3QgZGV2ZWxvcGluZyB0
aGUgam91cm5hbCBmbHVzaC9mdWEgb3B0aW1pc2F0aW9ucyB0aGlzIGNhY2hlIHdhcwo+IHBhcnQg
b2YsIGl0IGFwcGVhcmVkIHRvIG1hZGUgYSBzaWduaWZpY2FudCBkaWZmZXJlbmNlIHRvCj4gcGVy
Zm9ybWFuY2UuIEhvd2V2ZXIsIG5vdyB0aGF0IHRoaXMgcGF0Y2hzZXQgaGFzIHNldHRsZWQgYW5k
IGFsbCB0aGUKPiBjb3JyZWN0bmVzcyBpc3N1ZXMgZml4ZWQsIHRoZXJlIGRvZXMgbm90IGFwcGVh
ciB0byBiZSBhbnkKPiBzaWduaWZpY2FudCBwZXJmb3JtYW5jZSBiZW5lZml0IHRvIGFzeW5jaHJv
bm91cyBjYWNoZSBmbHVzaGVzLgo+IAo+IEluIGZhY3QsIHRoZSBvcHBvc2l0ZSBpcyB0cnVlIG9u
IHNvbWUgc3RvcmFnZSB0eXBlcyBhbmQgd29ya2xvYWRzLAo+IHdoZXJlIGFkZGl0aW9uYWwgY2Fj
aGUgZmx1c2hlcyB0aGF0IGNhbiBvY2N1ciBmcm9tIGZzeW5jIGhlYXZ5Cj4gd29ya2xvYWRzIGhh
dmUgbWVhc3VyYWJsZSBhbmQgc2lnbmlmaWNhbnQgaW1wYWN0IG9uIG92ZXJhbGwKPiB0aHJvdWdo
cHV0Lgo+IAo+IExvY2FsIGRiZW5jaCB0ZXN0aW5nIHNob3dzIGxpdHRsZSBkaWZmZXJlbmNlIG9u
IGRiZW5jaCBydW5zIHdpdGgKPiBzeW5jIHZzIGFzeW5jIGNhY2hlIGZsdXNoZXMgb24gZWl0aGVy
IGZhc3Qgb3Igc2xvdyBTU0Qgc3RvcmFnZSwgYW5kCj4gbm8gZGlmZmVyZW5jZSBpbiBzdHJlYW1p
bmcgY29uY3VycmVudCBhc3luYyB0cmFuc2FjdGlvbiB3b3JrbG9hZHMKPiBsaWtlIGZzLW1hcmsu
Cj4gCj4gRmFzdCBOVk1FIHN0b3JhZ2UuCj4gCj4gPiBGcm9tIGBkYmVuY2ggLXQgMzBgLCBDSUwg
c2NhbGU6Cj4gCj4gY2xpZW50c8KgwqDCoMKgwqDCoMKgwqDCoGFzeW5jwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzeW5jCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBCV8KgwqDCoMKgwqDCoExhdGVuY3nCoMKgwqDCoMKgwqDCoMKgwqBCV8KgwqDCoMKgwqDC
oExhdGVuY3kKPiAxwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDkzNS4xOMKgwqAgMC44
NTXCoMKgwqDCoMKgwqDCoMKgwqAgOTE1LjY0wqDCoCAwLjkwMwo+IDjCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAyNDA0LjUxwqDCoCA2Ljg3M8KgwqDCoMKgwqDCoMKgwqDCoDIzNDEuNzfC
oMKgIDYuNTExCj4gMTbCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMzAwMy40MsKgwqAgNi40
NjDCoMKgwqDCoMKgwqDCoMKgwqAyOTMxLjU3wqDCoCA2LjUyOQo+IDMywqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoDM2OTcuMjPCoMKgIDcuOTM5wqDCoMKgwqDCoMKgwqDCoMKgMzU5Ni4yOMKg
wqAgNy44OTQKPiAxMjjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDcyMzcuNDPCoCAxNS40OTXC
oMKgwqDCoMKgwqDCoMKgwqA3MjE3Ljc0wqAgMTEuNTg4Cj4gNTEywqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqA1MDc5LjI0wqAgOTAuNTg3wqDCoMKgwqDCoMKgwqDCoMKgNTE2Ny4wOMKgIDk1Ljgy
Mgo+IAo+IGZzbWFyaywgMzIgdGhyZWFkcywgY3JlYXRlIHcvIDY0IGJ5dGUgeGF0dHIgdy8zMmsg
bG9nYnNpemUKPiAKPiDCoMKgwqDCoMKgwqDCoMKgY3JlYXRlwqDCoMKgwqDCoMKgwqDCoMKgwqBj
aG93bsKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1bmxpbmsKPiBhc3luY8KgwqAgMW00MXPCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgMW0xNnPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMm0wM3MKPiBzeW5jwqDC
oMKgwqAxbTQwc8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAxbTE5c8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqAxbTU0cwo+IAo+IFNsb3dlciBTQVRBIFNTRCBzdG9yYWdlOgo+IAo+ID4gRnJvbSBgZGJlbmNo
IC10IDMwYCwgQ0lMIHNjYWxlOgo+IAo+IGNsaWVudHPCoMKgwqDCoMKgwqDCoMKgwqBhc3luY8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3luYwo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgQlfCoMKgwqDCoMKgwqBMYXRlbmN5wqDCoMKgwqDCoMKgwqDCoMKg
QlfCoMKgwqDCoMKgwqBMYXRlbmN5Cj4gMcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IDc4LjU5wqAgMTUuNzkywqDCoMKgwqDCoMKgwqDCoMKgwqAgODMuNzjCoCAxMC43MjkKPiA4wqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDM2Ny44OMKgIDkyLjA2N8KgwqDCoMKgwqDCoMKg
wqDCoCA0MDQuNjPCoCA1OS45NDMKPiAxNsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgNTY0
LjUxwqAgNzIuNTI0wqDCoMKgwqDCoMKgwqDCoMKgIDYwMi43McKgIDc2LjA4OQo+IDMywqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA4MzEuNjYgMTA1Ljk4NMKgwqDCoMKgwqDCoMKgwqDCoCA4
NzAuMjYgMTEwLjQ4Mgo+IDEyOMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMTY1OS43NiAxMDIu
OTY5wqDCoMKgwqDCoMKgwqDCoMKgMTYyNC43M8KgIDkxLjM1Ngo+IDUxMsKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgMjEzNS45MSAyMjMuMDU0wqDCoMKgwqDCoMKgwqDCoMKgMjYwMy4wNyAxNjEu
MTYwCj4gCj4gZnNtYXJrLCAxNiB0aHJlYWRzLCBjcmVhdGUgdy8zMmsgbG9nYnNpemUKPiAKPiDC
oMKgwqDCoMKgwqDCoMKgY3JlYXRlwqDCoMKgwqDCoMKgwqDCoMKgwqB1bmxpbmsKPiBhc3luY8Kg
wqAgNW0wNnPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgNG0xNXMKPiBzeW5jwqDCoMKgwqA1bTAwc8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqA0bTIycwo+IAo+IEFuZCBvbiBKYW4ncyB0ZXN0IG1hY2hpbmU6
Cj4gCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDUuMTgtcmM4LXZhbmls
bGHCoMKgwqDCoMKgwqAgNS4xOC1yYzgtcGF0Y2hlZAo+IEFtZWFuwqDCoMKgwqAgMcKgwqDCoMKg
wqDCoMKgIDcxLjIyICjCoMKgIDAuMDAlKcKgwqDCoMKgwqDCoCA2NC45NCAqwqDCoCA4LjgxJSoK
PiBBbWVhbsKgwqDCoMKgIDLCoMKgwqDCoMKgwqDCoCA5My4wMyAowqDCoCAwLjAwJSnCoMKgwqDC
oMKgwqAgODQuODAgKsKgwqAgOC44NSUqCj4gQW1lYW7CoMKgwqDCoCA0wqDCoMKgwqDCoMKgIDE1
MC41NCAowqDCoCAwLjAwJSnCoMKgwqDCoMKgIDEzNy41MSAqwqDCoCA4LjY2JSoKPiBBbWVhbsKg
wqDCoMKgIDjCoMKgwqDCoMKgwqAgMjUyLjUzICjCoMKgIDAuMDAlKcKgwqDCoMKgwqAgMjQyLjI0
ICrCoMKgIDQuMDglKgo+IEFtZWFuwqDCoMKgwqAgMTbCoMKgwqDCoMKgIDQ1NC4xMyAowqDCoCAw
LjAwJSnCoMKgwqDCoMKgIDQzOS4wOCAqwqDCoCAzLjMxJSoKPiBBbWVhbsKgwqDCoMKgIDMywqDC
oMKgwqDCoCA4MzUuMjQgKMKgwqAgMC4wMCUpwqDCoMKgwqDCoCA4MjkuNzQgKsKgwqAgMC42NiUq
Cj4gQW1lYW7CoMKgwqDCoCA2NMKgwqDCoMKgIDE3NDAuNTkgKMKgwqAgMC4wMCUpwqDCoMKgwqAg
MTY4Ni43MyAqwqDCoCAzLjA5JSoKPiAKPiBQZXJmb3JtYW5jZSBhbmQgY2FjaGUgZmx1c2ggYmVo
YXZpb3VyIGlzIHJlc3RvcmVkIHRvIHByZS1yZWdyZXNzaW9uCj4gbGV2ZWxzLgo+IAo+IEFzIHN1
Y2gsIHdlIGNhbiBub3cgY29uc2lkZXIgdGhlIGFzeW5jIGNhY2hlIGZsdXNoIG1lY2hhbmlzbSBh
bgo+IHVubmVjZXNzYXJ5IGV4ZXJjaXNlIGluIHByZW1hdHVyZSBvcHRpbWlzYXRpb24gYW5kIGhl
bmNlIHdlIGNhbgo+IG5vdyByZW1vdmUgaXQgYW5kIHRoZSBpbmZyYXN0cnVjdHVyZSBpdCByZXF1
aXJlcyBjb21wbGV0ZWx5LgoKSXQgdHVybnMgb3V0IHRoaXMgcmVncmVzc2VzIHVtb3VudCBsYXRl
bmN5IG9uIERBWCBmaWxlc3lzdGVtcy4gU3JhdmFuaQpyZWFjaGVkIG91dCB0byBtZSBhZnRlciBu
b3RpY2luZyB0aGF0IHY1LjE4IHRha2VzIHVwIHRvIDEwIG1pbnV0ZXMgdG8KY29tcGxldGUgdW1v
dW50LiBPbiBhIHdoaW0gSSBndWVzc2VkIHRoaXMgcGF0Y2ggYW5kIHVwb24gcmV2ZXJ0IG9mCmNv
bW1pdCA5MTllZGJhZGViZTEgKCJ4ZnM6IGRyb3AgYXN5bmMgY2FjaGUgZmx1c2hlcyBmcm9tIENJ
TCBjb21taXRzIikKb24gdG9wIG9mIHY1LjE4IHVtb3VudCB0aW1lIGdvZXMgYmFjayBkb3duIHRv
IHY1LjE3IGxldmVscy4KClBlcmYgY29uZmlybXMgdGhhdCBhbGwgb2YgdGhhdCBDUFUgdGltZSBp
cyBiZWluZyBzcGVudCBpbgphcmNoX3diX2NhY2hlX3BtZW0oKS4gSXQgbGlrZWx5IG1lYW5zIHRo
YXQgcmF0aGVyIHRoYW4gYW1vcnRpemluZyB0aGF0CnNhbWUgbGF0ZW5jeSBwZXJpb2RpY2FsbHkg
dGhyb3VnaG91dCB0aGUgd29ya2xvYWQgcnVuLCBpdCBpcyBhbGwgYmVpbmcKZGVsYXllZCB1bnRp
bCB1bW91bnQuCgpJIGFzc3VtZSB0aGlzIGxhdGVuY3kgd291bGQgYWxzbyBzaG93IHVwIHdpdGhv
dXQgREFYIGlmIHBhZ2UtY2FjaGUgaXMKbm93IGFsbG93ZWQgdG8gY29udGludWUgZ3Jvd2luZywg
b3IgaXMgdGhlcmUgc29tZSBvdGhlciBzaWduYWwgdGhhdAp0cmlnZ2VycyBhc3luYyBmbHVzaGVz
IGluIHRoYXQgY2FzZT8KCk9uIHRoZSBvbmUgaGFuZCBpdCBtYWtlcyBzZW5zZSB0aGF0IGlmIGEg
d29ya2xvYWQgZGlydGllcyBkYXRhIGFuZApkZWxheXMgc3luY2luZywgaXQgaXMgZXhwbGljaXRs
eSBhc2tpbmcgdG8gcGF5IHRoYXQgY29zdCBsYXRlci4gRm9yIERBWAppdCBpcyB1bmZvcnR1bmF0
ZSB0aGF0IGxpa2VseSBieSB0aGUgdGltZSB0aGlzIGxhdGUgZmx1c2ggY29tZXMgYXJvdW5kCnRo
ZSBkaXJ0eSBkYXRhIGhhcyBsb25nIHNpbmNlIGxlZnQgdGhlIENQVSBjYWNoZSwgd29yc2UgaWYg
dGhlIHdvcmtsb2FkCmhhZCBiZWVuIGRpbGlnZW50bHkgY2xlYW5pbmcgY2FjaGVzIGl0c2VsZiwg
YnV0IHRoZSBmcyBjYW4gbm90IHRydXN0CnRoYXQgdXNlcnNwYWNlIGlzIGRvaW5nIHRoYXQgY29y
cmVjdGx5LgoK
