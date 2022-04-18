Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2EEA41
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 19:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650311284; x=1681847284;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=q8LdDpJ+oPobZ8+DzKC753QPiaYkRt++h3bJKuTGOSs=;
  b=D7fSir1HFnhBuFKQ6v3mCwU2z+PRYUgBMVRcfiG0iMaF2g9AH74W8bAX
   BME44UcM17d+L3UqpfPlkuHnW2EgCiIyzWcZqDRQ7noXfvYwhHtzX2kCo
   EFr8k6hitH/XAJjR80hxJyPs3z2iGU8zEJdpYKGqbhmFz6BnCFCihsbhz
   a1oOy9iKIWP6XoeSJiwXWNNmMERw7uaIJYIbWq+JDE2SIj2PRr09zWRL7
   LCIAw/wR0QQ4CEAcIkIFldQFqsOdYW76uj5XcKnXs273Hyuc4ah/B8DGv
   EJdoQC1wS4NqQHrYZr13Fjio0GTVQQLsq+vy2sOLTaQhpPB8VQ0r/8E0B
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="263772809"
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="263772809"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 12:48:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="665407144"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga004.jf.intel.com with ESMTP; 18 Apr 2022 12:48:03 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Apr 2022 12:48:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 18 Apr 2022 12:48:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Apr 2022 12:48:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGveZ70NPVKhLDHSsy30PR3PDLEOcsFQxX2i4yBlx87Qk9Zp+kvOo1EdH050b3VWppFJ62z9Rlie1R45QWlaymT+IzbZgHQ98sPddbUP+zGYKdPls/FAwRwhZ/rSbjAqiugfP3vJNaV/zhMVJLsVYtxTziIIjjrNLKTH/K6T9CpfJn88qKUXtlTHxLDss2r8mOVATgL5AvTUbq83vD3fsC1m7hw33dm6afFU1kRz7NHlR/TjGCEYGiO9JheIogKCkaisufulxFaaB4K8ywS6qqwQkZzD5w9a46YIikxaT8NbyUsbhOQe6f5Iw8XK29G2f+aPscOmNdJQcdeSr0YUbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8LdDpJ+oPobZ8+DzKC753QPiaYkRt++h3bJKuTGOSs=;
 b=kIJWvuudlu8WzKRqZaEV/MPlwTfcUICB79mLfcEidT9gPt8kSUTkkC9Qjp4g1jOwM6j3p4FueX5pX9Ahk9s2C6NSZezhIzHk7m0x7guAGKtKf7YT1nxSuCbNf/1+/4kEV1vdm6nLm+130ywpn95JLfPJ8m6jdFJSIdjLH81xJV8QmGusRQLIEqhkglV8x6mNQCf6PpnLkj5GTFl8tdPqUX1mLcdDTcerFQ89e62nleQsBbGY19Ja2eUPpX9U0szGxh5AJlFttIAOGfXW+mA/nGLoeN+DauVpj/rwpmGkmbRfHxCKdOZeC0YkXad1GM6VMQN9geShO+SvvgeJ75NWtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BYAPR11MB3144.namprd11.prod.outlook.com (2603:10b6:a03:8f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 19:47:59 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::41a:5dd4:f4b3:33cb]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::41a:5dd4:f4b3:33cb%7]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 19:47:58 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Mao, Chunhong"
	<chunhong.mao@intel.com>
Subject: Re: [ndctl PATCH] daxctl: fix systemd escaping for
 90-daxctl-device.rules
Thread-Topic: [ndctl PATCH] daxctl: fix systemd escaping for
 90-daxctl-device.rules
Thread-Index: AQHYU1WoFzbjvzi8ZUmVKB0B7gRc0qz2CpcAgAAJJIA=
Date: Mon, 18 Apr 2022 19:47:58 +0000
Message-ID: <ba4de425d48d36b9bb116e0ff0c30e9fc1b70d69.camel@intel.com>
References: <20220418185336.1192330-1-vishal.l.verma@intel.com>
	 <CAPcyv4h+r4Oq=y+B9H+E6AASbj8=V+NcdU+5S88-i-yfOUy8_g@mail.gmail.com>
In-Reply-To: <CAPcyv4h+r4Oq=y+B9H+E6AASbj8=V+NcdU+5S88-i-yfOUy8_g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.4 (3.42.4-2.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7004139f-0e0b-4150-6ef0-08da21745736
x-ms-traffictypediagnostic: BYAPR11MB3144:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <BYAPR11MB3144E3E6523BF44B56CA29A2C7F39@BYAPR11MB3144.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vrCDZv4eNLfStlPbow9Y49ofEhnAxLVLx5Rmb3NKKtTKsC2DGQXg9/+qKaIDQCCVmu4Zhg0JK3A0YEQIP1CGSU4kjEpQOJzOEtlsERKQFc19Tu/qDrHLvG3J+P+Iahje59GReAiC0CJgV/2dh0c961Ohj8o6ZgZhOcdjphq/X5XHzuv8kj7heP+LdAW2Uz3LyAAx26Kp0kzSqGDRgiicb7rc9NS5rZrVKcUsvcV3vrdNEXE3+YRI6bTtI2Z4DeZ4WmKmvtWnzOqRklyPeBQo8CXCpHhjOZkSeiSXDj4tGIn8Raih3W9KFskdGSS8SVISIlnMBA/EzfKLku+3EqoEGUfo4cKrpGYUqHC2T7hcZdus0mPtwhKpsPPun/pYfQYwxA2uVHFHR0dYhge+668AaDiZbuM7IKpIy1bxq0y3A/WEz/uRPJp5oSjXDHb3/E74djKgEff8w/WB4VGJrYz1nEiL5jn6ijXFk8S71Hhqe1sKkqZ0Vpa55RF4gfD8sucwKQQjFVQUr/mAfiCvsmb/SrIs8BLW+7nqaG/rKs4e6NCfZmKRx8a0So0bpFshMzDZh5d8wAmUIypen4oQ/ZzvASiqRrr6twSuz6xKzI+/7/8re7pQHUNEMN6lu+xoKSzJfSjIpneEZSeucoYRhr/CWiqOCgxRwsPpgjJuhZk3nSwvNtSXxsCh8L3UC2seoSESIybVpyjCUqqR1pPwxMUtJCG51/FaDSBJ0n2Fg3ve288u6litT0AAf/Nv1PLPSy9BjtbLECOQyLwWgr0eenCSgTkF4AIVvaINAyMMQOlIfFA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(316002)(83380400001)(86362001)(91956017)(122000001)(82960400001)(508600001)(6486002)(53546011)(966005)(71200400001)(38100700002)(6506007)(6636002)(38070700005)(37006003)(54906003)(36756003)(186003)(2616005)(2906002)(6512007)(26005)(8936002)(6862004)(5660300002)(66946007)(8676002)(66556008)(66446008)(4326008)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTZGUm1MbTM3MVB2YzY5dEZ5dXBQcktYMndZWldLQ3FqVEVRRHpGOXQ0OGN1?=
 =?utf-8?B?d2M0TTd3MGJTNDZieE9ENytYODdHMkE0OE1mTWUzU3pzcTZLZndYczRrV24w?=
 =?utf-8?B?UUJrN1pHdE1HWlRjWmxFZ3dZZ1VtMnAvMG56TW1SUjY4MGh4bmJyNEU4TG9k?=
 =?utf-8?B?WmFFUjVFYmhqVUpNTFBKYWcvYWU2QlFNZWdSQ3lNNEhMaHV4Z1Q2VnpKNXlC?=
 =?utf-8?B?d1BESk1YMVVTMStWT28rb1dGK053eVVIU2pmczc2cW1PSHFUVE1ISlNOdEIw?=
 =?utf-8?B?OUE1eTdUakRDVXNYazlYdWVOd0NQU0oyRGFqR1Q1eTFKZG1IczdtYkJDRUNC?=
 =?utf-8?B?SFlMempYcDhSUmxUOE1XdjR3S2pRL2NKY3F2eHNockVTeFpvcHJEMS9SL3Vm?=
 =?utf-8?B?NWFnSnVTbGs1cGpITm5TQUFHZWFKczl5ZERoNFFaUE4wSjl4VXdQVEExbm1o?=
 =?utf-8?B?M3NFQlN0ak9sNmlMS3J4ZWp5Y3lOeGNyWTVxUElDOTRnV1l0Y3hrc3RlMGhP?=
 =?utf-8?B?b2RwZHdPT0NKZldlNjNyeUR0VUYvT3o2UXI4WFQ5blpMTmRWRy9YUXdXR0tq?=
 =?utf-8?B?U2NXVEQyNXNHZFRiQWhGQnMxcExsV0dFRk5ITkEwNnREODFKR1VUVGsvQ21n?=
 =?utf-8?B?RnFkdVhVSFIrcENuR0Q5blhVYStORFE2V0Nha2RkaE1md1ZwVWM1Z3J0ZHVz?=
 =?utf-8?B?clVhdEIxNWt0V1luTHBjM1FVYzhvWUpqVkk0WTlLSE50ZytveWdGZjFTUVBG?=
 =?utf-8?B?VTBrd1RvZ21DWmdOQTkyTy90eURZUnJIS0I1R0VFTDVNV2hwaHQ5VEIvNlh6?=
 =?utf-8?B?VzdDNXFuTmRZMEVtTkMydmNDLzlJeHVHbUg5a21wdkJLaUlRYzlrQ0JZbCtx?=
 =?utf-8?B?WEhLL2VQNHpHSUFkNEVsdmlGcjZ6K0xCVWNwTEJHTWFwbGRYNUhaTk12SVJv?=
 =?utf-8?B?MHhocXFWek9iOGNNZ3c5WGN4QjRiZU9jMXYrRXpBSkFtRjNBRzVmdlVqVURE?=
 =?utf-8?B?QmM2QWRVVEUyV1BzbzhKOS9qMGVwK2tERCtIb2NucWR1LyswekNRK0xRanJx?=
 =?utf-8?B?QUFlWGlHajExUnViTk1DZGk3cWpRaUdKSW1Bbk9hSklUYVVmNjVlVGpWczdY?=
 =?utf-8?B?SWlONmhJd1d3eVQwUVpBK0gzTlJmT1ppdmZGOFZpcmV1Y0EzUjJXODNYUWlB?=
 =?utf-8?B?dzl3dWpIMzhZSC8yYnF3MWhockNkYzFKcGo5SEQ2RHc5K2pteFJ5c2NtaTFC?=
 =?utf-8?B?QTJMU1VITEpBb0tlZmF4dWthVFB0UlVsekRNSjBVTFRTa3N5QTFtSDlocjg1?=
 =?utf-8?B?dlhiZXFLc2kwRFIyb0pkS3FmYnpqTmVTSW95UVVrN2ZXK3dyRFBvNXkxcU9z?=
 =?utf-8?B?b1lmODJLemlNRFJpeG96SnQzZkN3aHJsVWRwT1pKbE5LMWhzUWkybnNyT3JJ?=
 =?utf-8?B?QnhFSjN1WkVOWnlvREVrNjNFN2RUdHV2SUFmRkYzL20rV2dRaFIzTUJwa0l6?=
 =?utf-8?B?NVFqSnNTRldBZkhRN0w0dXFuRnhCY2JzZWtBMmdPTVpoaUxIWmtYYy9ZOHhT?=
 =?utf-8?B?cDFqcVNNVVZ2SURPSDdORUQ0YzAwZXdDYXpuSkxjcTFXOFRnZjM1UDNxUlNk?=
 =?utf-8?B?ckN0c2dRYllPck5tNlMwSnlwT3BxVCtPdWRuUkZBN1pXMEdyUDNHNlk3aEJL?=
 =?utf-8?B?eEtYV202Q2RnMWY0UVM2b0dSZnMxTzlxQ3ZBTG5jQ01aMkdKRC9BWGt2dmp2?=
 =?utf-8?B?V0ttUlM1VlFkVW1FYVd4aVZ6YjJGcXM1ZkJsUDU0dzhDS1I2MjlIWHd1KzVl?=
 =?utf-8?B?N2dwU1VnTzM4QU9QRmROczRxZWsyd2ErOVZRbkVRNllxVVlydXA2cVZwQXk2?=
 =?utf-8?B?eEdRT0g1bnZ1WDdURnlLN3prYnJaeTJ5Uk5KeXU2L21MeDBMbXIvQUkxWDA4?=
 =?utf-8?B?UzhnbnF3Smp3OXZGTGNxQ1lVdkN6aFdId2RiR1JKQVdLYUVORW0wVUZvVERN?=
 =?utf-8?B?S3RXbEJQSXgxWTRrTDgxNStFempwdWpuanhPNUZwUXpQYVBWc3BJY1Z3QWpF?=
 =?utf-8?B?Z3huQ0RTemlmd0JLWnlHZGpHbjBhZDdOOUVRU2FPS2xHblV5Zkp1KzV6dTZ2?=
 =?utf-8?B?eXliT1RIWlMvazV2bnczOEpjZ2pJUWxJaTdZb2lyVGlTSUQraXUwdUZ4Vm1J?=
 =?utf-8?B?VGRMYWh5eXRza3R4azlVMHUveTYxcmkvQnhRL2d1NU5iWVZGYWZNZWhZVlhs?=
 =?utf-8?B?WjF4TWN2MzhWQ3lUdTRvR05MNzlCRFBjeElPZXJxRWtqdjhNOUhtMlJ0SW52?=
 =?utf-8?B?ZUpKVXdCSFZ4bEhCQ1ZKbVpHSkozcHNDVktEWGxoTy9zZFlwZ1NzQklWZ2Vr?=
 =?utf-8?Q?nviqEzA8vsRep9iY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C29E750B279F2F4FA120109CA7830B1E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7004139f-0e0b-4150-6ef0-08da21745736
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2022 19:47:58.8204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HUMn+6Vfd11fCjx7rFMibtZGe/vOZNfuGQnUZR9LQ1VLaeT7Ntsmww0UkIsdjdnUZ8MGhUA1B8S/SY3jpCw7ASXN10JrW/mb1NFpm7goRxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3144
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIyLTA0LTE4IGF0IDEyOjE1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIE1vbiwgQXByIDE4LCAyMDIyIGF0IDExOjU0IEFNIFZpc2hhbCBWZXJtYQ0KPiA8dmlzaGFs
LmwudmVybWFAaW50ZWwuY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbGRlciBzeXN0ZW1kIHdhcyBt
b3JlIHRvbGVyYW50IG9mIGhvdyB1bml0IG5hbWVzIGFyZSBwYXNzZWQgaW4gZm9yDQo+ID4gaW5z
dGFudGlhdGVkIHNlcnZpY2VzIHZpYSBhIHVkZXYgcnVsZSwgYnV0IG9mIGxhdGUsIHN5c3RlbWQg
ZmxhZ3MNCj4gPiB1bmVzY2FwZWQgdW5pdCBuYW1lcywgd2l0aCBhbiBlcnJvciBzdWNoIGFzOg0K
PiA+IA0KPiA+IMKgIGZlZG9yYSBzeXN0ZW1kWzFdOiBJbnZhbGlkIHVuaXQgbmFtZSAiZGF4ZGV2
LQ0KPiA+IHJlY29uZmlndXJlQC9kZXYvZGF4MC4wLnNlcnZpY2UiDQo+ID4gwqAgZXNjYXBlZCBh
cyAiZGF4ZGV2LXJlY29uZmlndXJlQC1kZXYtZGF4MC4wLnNlcnZpY2UiIChtYXliZSB5b3UNCj4g
PiBzaG91bGQgdXNlDQo+ID4gwqAgc3lzdGVtZC1lc2NhcGU/KS4NCj4gPiANCj4gDQo+IERvZXMg
c3lzdGVtZC1lc2NhcGUgZXhpc3Qgb24gb2xkZXIgc3lzdGVtZCBkZXBsb3ltZW50cz8gSXMgc29t
ZSBuZXcNCj4gc3lzdGVtZCB2ZXJzaW9uIGRldGVjdGlvbiBvciAnc3lzdGVtZC1lc2NhcGUnIGRl
dGVjdGlvbiBuZWVkZWQgaW4gdGhlDQo+IGJ1aWxkIGNvbmZpZ3VyYXRpb24gdG8gc2VsZWN0IHRo
ZSBmb3JtYXQgb2YgOTAtZGF4Y3RsLWRldmljZS5ydWxlcz8NCg0KR29vZCBwb2ludCAtIEkgdGhp
bmsgd2UncmUgb2theS4gc3lzdGVtZC1lc2NhcGUgd2FzIGludHJvZHVjZWQgaW4gdjIxNg0KYmFj
ayBpbiAyMDE0IFsxXSwgYW5kIGZyb20gYSBxdWljayBnbGFuY2UgYXQgcmVwb2xvZ3ksIGV2ZW4g
dGhlIG9sZGVzdA0KZGlzdHJvcyBhcmUgYXQgbGVhc3Qgb24gdjIxOSBbMl0uDQoNClsxXTrCoGh0
dHBzOi8vZ2l0aHViLmNvbS9zeXN0ZW1kL3N5c3RlbWQvYmxvYi9tYWluL05FV1MjTDEwMzcwDQpb
Ml06IGh0dHBzOi8vcmVwb2xvZ3kub3JnL3Byb2plY3Qvc3lzdGVtZC92ZXJzaW9ucw0KDQo+IA0K
PiANCj4gPiBVcGRhdGUgdGhlIHVkZXYgcnVsZSB0byBwYXNzIHRoZSAnREVWTkFNRScgZnJvbSBl
bnYgdGhyb3VnaCBhbg0KPiA+IGFwcHJvcHJpYXRlIHN5c3RlbWQtZXNjYXBlIHRlbXBsYXRlIHNv
IHRoYXQgaXQgZ2VuZXJhdGVzIHRoZQ0KPiA+IGNvcnJlY3RseQ0KPiA+IGVzY2FwZWQgc3RyaW5n
Lg0KPiA+IA0KPiA+IENjOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4N
Cj4gPiBSZXBvcnRlZC1ieTogQ2h1bmhvbmcgTWFvIDxjaHVuaG9uZy5tYW9AaW50ZWwuY29tPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29t
Pg0KPiA+IC0tLQ0KPiA+IMKgZGF4Y3RsLzkwLWRheGN0bC1kZXZpY2UucnVsZXMgfCA0ICsrKy0N
Cj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvZGF4Y3RsLzkwLWRheGN0bC1kZXZpY2UucnVsZXMgYi9kYXhj
dGwvOTAtZGF4Y3RsLQ0KPiA+IGRldmljZS5ydWxlcw0KPiA+IGluZGV4IGVlMDY3MGYuLmUwMmU3
ZWMgMTAwNjQ0DQo+ID4gLS0tIGEvZGF4Y3RsLzkwLWRheGN0bC1kZXZpY2UucnVsZXMNCj4gPiAr
KysgYi9kYXhjdGwvOTAtZGF4Y3RsLWRldmljZS5ydWxlcw0KPiA+IEBAIC0xICsxLDMgQEANCj4g
PiAtQUNUSU9OPT0iYWRkIiwgU1VCU1lTVEVNPT0iZGF4IiwgVEFHKz0ic3lzdGVtZCIsDQo+ID4g
RU5We1NZU1RFTURfV0FOVFN9PSJkYXhkZXYtcmVjb25maWd1cmVAJGVudntERVZOQU1FfS5zZXJ2
aWNlIg0KPiA+ICtBQ1RJT049PSJhZGQiLCBTVUJTWVNURU09PSJkYXgiLCBUQUcrPSJzeXN0ZW1k
IixcDQo+ID4gK8KgIFBST0dSQU09Ii91c3IvYmluL3N5c3RlbWQtZXNjYXBlIC1wIC0tdGVtcGxh
dGU9ZGF4ZGV2LQ0KPiA+IHJlY29uZmlndXJlQC5zZXJ2aWNlICRlbnZ7REVWTkFNRX0iLFwNCj4g
PiArwqAgRU5We1NZU1RFTURfV0FOVFN9PSIlYyINCj4gPiANCj4gPiBiYXNlLWNvbW1pdDogOTcw
MzFkYjkzMDA2NTQyNjBiYzJhZmI0NWIzNjAwYWMwMWJlYWViYQ0KPiA+IC0tDQo+ID4gMi4zNS4x
DQo+ID4gDQoNCg==
