Received: from esa17.fujitsucc.c3s2.iphmx.com (esa17.fujitsucc.c3s2.iphmx.com [216.71.158.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381FA8C1D
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 14:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1669646851; x=1701182851;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tKW6S7R7Dw7nfqqHWp3nNSfMzhMjd7lFuG3lWhoaIsk=;
  b=ca25UJtDM4QyMXRbTt2ip6NUDV1Ma/6FgV/w7y24CU5fSyfQ7h3pAQf/
   AFLHEkq8CsqLwf2RZPhyNE8RSCyh3+5aWY7hRJMPx+RcOyqIyiPFCO3c3
   KD3z9Dh5ECGvvy3a9RBdbVOwLRkCSw5BBfgtzNUvcPVVBvtRvkvaWwJ3v
   AqlGZ9GrQlytN52zamCemrVI/CfePjbGW6yoAbVlkGskkrQY/8i+VNXNC
   D4fqB5rmVOc7uXAjK3xyD/TMDfEIteh7Z0yzh/YCwKs06nNtf7a2h4T49
   lS2B8Es2YmVQwJXNIhji53rC+YPyvfamgWPGiwaWWihs86aO3doj4wNfN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="70989403"
X-IronPort-AV: E=Sophos;i="5.96,200,1665414000"; 
   d="scan'208";a="70989403"
Received: from mail-tycjpn01lp2168.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.168])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 23:46:18 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8ucm0yAahKyhWEcTmUJa5ytXvb9hIo9AMBt3HBpZBMi9L2xETIaLHERL9t10hc+4hk8oUuaSPT4FdT41usZED7JcyHRdOFLjuv9XU1c0+kZTevp5WNNmTcHYhDtzW+9Zir2usDPlPpnzy2ONxy/ox8Lp/VvNoaRKe5+5xwK2EpGIxT/YEH+KuBiA9CUkYTf74vV4UvTU3CDLjHPhy0/EAV18d98p7tnNMzz2wPSBxGzVc5TF9PgO1QqVstQjfFPlCFr1mKL4h13KtK4LoEYHVJunIqXMlXAfXcFHWUMshib/sn62/WHZ977sx4up9iYjTzTy8ZdSciUFH6r3MuVAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKW6S7R7Dw7nfqqHWp3nNSfMzhMjd7lFuG3lWhoaIsk=;
 b=ehKIMWGN2VMPTDEPbFvoWe1AO+Rj1K0G97W0fDq/DXSkaYpYqT6VqsWhrRYo911VfJSz+1WShkNlDcwb7sVblkp7JopooqudgoYmrcCw54xxLh6I8icBjfJMRvokcDQ4Yv8lb5FmaKRxJtbdwUAMpkeVSE0wcBVnY88Ql4odKCwtSSL30pF5T9bKRRRnfOpqtIyKxSbmc7BqL7JK1ziWsnfu7ZtNWuntK+vGIwk35swF3siRp+x851lMTc4UrFNPTfT/9Xa1YorBoAaEdw66cxO41ab3q7J+rOasKoo7Vd5rCSGeQUoQQu6/07CpKhoAC3wLFmw3P5TPAkXQizC7kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB10399.jpnprd01.prod.outlook.com (2603:1096:400:244::9)
 by OS0PR01MB5362.jpnprd01.prod.outlook.com (2603:1096:604:af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 14:46:15 +0000
Received: from TYCPR01MB10399.jpnprd01.prod.outlook.com
 ([fe80::1bd0:fca4:5c93:3f57]) by TYCPR01MB10399.jpnprd01.prod.outlook.com
 ([fe80::1bd0:fca4:5c93:3f57%3]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 14:46:15 +0000
From: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
To: "moss@cs.umass.edu" <moss@cs.umass.edu>, "kexec@lists.infradead.org"
	<kexec@lists.infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: Re: nvdimm,pmem: makedumpfile: __vtop4_x86_64: Can't get a valid pte.
Thread-Topic: nvdimm,pmem: makedumpfile: __vtop4_x86_64: Can't get a valid
 pte.
Thread-Index: AQHZAyGAOITJM2u3P0G+LOV0TMT94K5USqsAgAAfYwA=
Date: Mon, 28 Nov 2022 14:46:15 +0000
Message-ID: <35997834-f6d2-0fc6-94a1-a7a25559d5ef@fujitsu.com>
References: <ac8d815b-b5ca-4c4f-4955-ba9adbce8678@fujitsu.com>
 <103666d5-3dcf-074c-0057-76b865f012a6@cs.umass.edu>
In-Reply-To: <103666d5-3dcf-074c-0057-76b865f012a6@cs.umass.edu>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10399:EE_|OS0PR01MB5362:EE_
x-ms-office365-filtering-correlation-id: 29567dfc-f180-4129-2a31-08dad14f4d18
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 4kUzW5HLqnTdqahkD3J2lnNpRbDOeapYhtgHJ9ANn5Z7J3jI9zKncrFP+FFu+Akeb/W9ozd9jn92JQ1fDN1ninkWMIsT5jb/OPny2nRR85ZHP80O9xWhWah/ypom2LUDIwdn95zOx/3L+d/EZTkLLOHjsJ8KHCzMGb9AvC3uErf/UW2iepIMj5szvON9oNCEpAuH0XNWYDu+u3VdAOMNJtPL+wFnfCGl4BvhsT5G4JdOX4M9tyfw+RZaoETjNqHTqJQ7tmtSvOpsMlLORiH9bMoZ8m/LbTjIpgYYccYm1xzjbIqnpTysA1uyWUT8lfYa7F+cLZ5aJDXycq9ZRrT/DdXOLPT/z3K18O0VdP3QNdg8VwNvIbGHENpyK8LsFDDeZ7j1gcJBCGjAROxZBsMpOtY/nwzN511LCYeSMZfv/vAIVGaNToW07dy/kQ0eDK/ssYsPMEC5ASQGfDGXTiAKOSfyB6/171IcYfNsFWXWd7zwhod6yhBUxiFb8HUnT/s4dImB1eL42GYWk7ls4eKquiD1+WaGJo9GgikbxVBnRGHxDkDVCGSUmZm8eJgjrh1aPhgp5Pc2EAA34uRj/Rdeo+hum3aAKNdZoC6zIcZPqxl8nsEnd7UZp9+4GYNY6tykX1rldK+bfCDpNZuOY6c7D1onqrHedzmENu+3gPC1kd0Ba20TQ1Pi9kze7eIWrETsMgGvkp/vBj18JQ7VTYFE19wj2XLmaGdbFzuj0N+RdLfeUkKNYSKVaVDx6Hq5LZQVRahJTyPNy1zwGrz8tptGTnUG/Uv9w4GikIuEiv4ueoo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10399.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(451199015)(1590799012)(5660300002)(4744005)(110136005)(6512007)(82960400001)(316002)(2616005)(26005)(41300700001)(186003)(91956017)(66556008)(36756003)(76116006)(66946007)(85182001)(8676002)(66476007)(66446008)(64756008)(4326008)(122000001)(8936002)(2906002)(38070700005)(38100700002)(86362001)(31696002)(71200400001)(6506007)(6486002)(53546011)(31686004)(1580799009)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WUlvVTVEbFpuYkZaU1JFUTZWcEZtT0xGUnVaMmsxc2hIMllpZTMxU3RxdzZ4?=
 =?utf-8?B?UVFEbHlSY1dqR2tBMnVDLzlKZno4NXd4cVRjdkw2bjMvN1lFYWVRbmNsZTVK?=
 =?utf-8?B?WVdWczgwZ2pJKy9YWUQ0Y0hmM1ZWZTFhMkdVTlhnR2IzUjE0Qk4vRjFtc090?=
 =?utf-8?B?a2dZMm54eVRkTTh4N0ZJZU5iekV6RVVPYUNHbUswSjBSMHZLMkFFckxJUlUz?=
 =?utf-8?B?dnRhMHNRYmdqSzB1TENPZDQ1c3FxSHNzbEk1WU8xc2pYbFVxbnlKYURKcHFG?=
 =?utf-8?B?K21FT1NWVVZpR25uYnJCWU9HaVF1R2FBdGkvY3UzYnc3cSs5RzZDcGFSYlB2?=
 =?utf-8?B?VWJhNFR3Y0pHVUR3N3pNWG1qaXZBSElTSllGRGRpSVpTR2lNV3ZoajI1OGNF?=
 =?utf-8?B?NTdNbSt3REtGdklCb1hBMDliYStLMWpHKzlVbklZMWFUakFmZ2xKME5VZm1P?=
 =?utf-8?B?ZVJxSEg3YUJEZzlBY2s5OWJYNjFOM3ZxZkdNamdzd3RPayt5VU01Y2R5RnNR?=
 =?utf-8?B?ZThtN2cxRlNuMjMrNmh4THc3SDViUUU3NkRQSnFMS0tnbVVqOVFTTi96VWlp?=
 =?utf-8?B?bnZuL01iclRSQkwyMG1RVlFLbzVNSWJiVGwwRS9BdW9lZ3VEeHlrSlVLeUV4?=
 =?utf-8?B?bTBDcnY3eTAzcHB5NFdjOTRNUzlMdWl1YWF2dlgvV1lLckFhb0FaVi81djFE?=
 =?utf-8?B?MGp1SThUV21xbGdCVkxhN2JMNE13Y2gxbVY0R3ZpYys1R1Yxd3dySXRVaHli?=
 =?utf-8?B?S1FLNFZEK0dyZ1hEYUJseThRMC9OaitDaGRTYnRHUERDWnJwSDAzQTZELzRv?=
 =?utf-8?B?bXk5TDNwOUJweTFqbExMcW8vNVM4M2VrOHI1U1VvNE0wQ3IyTGplVS9BYTRT?=
 =?utf-8?B?YWVpMkdzM0F0YTJucjlWN3h4a0VJYnpNMVVoTDRRTXhjVEl5aStGQ3BNa1oz?=
 =?utf-8?B?VHBDS1VoUVFlRlRLMWcrT1NBK05kMHZIa0QvcWZEU2VwcnNENzM3eHFweWYz?=
 =?utf-8?B?RWt5VTFySTRSNnRaVDVrZFQ1RiszWFNlb3J0c2lBU1dOQVVxZzBzcHk5dXVy?=
 =?utf-8?B?Q0J3NkprL1Vwempjbko1YmVXUTlJZ210Mi8rdXlGc3U1YXdlb0lYSHI0Mi8x?=
 =?utf-8?B?WUFQZGcvaUYza0lzRDVPWEJzc2hBbnNMZXVycXZENklKeXIzR2JtRTA5UVRH?=
 =?utf-8?B?QXlVaHA1TURDaU1LSkNoU0FLMnNkWFVpOFpGWFNzcU05UWd3YUlPcDZQWE5x?=
 =?utf-8?B?MFU1Z3dIWDArblFZMmkxMFR6NkZFMXVsRm5nNUZuK0t1WEsrSHBadGVJU0FE?=
 =?utf-8?B?blV2MDRCOC9nL3lrcTdYUzA4T00wVHNkM1BzQ2NrYlhNT2h4K3BDdkJNSHpB?=
 =?utf-8?B?QkdhellGLzRmSDhWTHZubWRSSkhWR2Q1L1ZURDBzWERYb0hOYkorMkZxd01t?=
 =?utf-8?B?cUdkazA5ME10bXNNUzdYRnNwOXJPdTB2VENCend5c3ZWb2hna2U3dTR1S0gw?=
 =?utf-8?B?UmFhMDJUUVAyZzNRUjRJTGhVb1RXS3BXczBDNmZCejB1dHVheVNFZmRPVzJ5?=
 =?utf-8?B?S0hycjZRaEk2TkhEMXhwenE0R3RFRG0rYS9lemI0L0ZhZERQMlJkUUNwVVFr?=
 =?utf-8?B?aGtEbjlrdDg1SkRhOEpHSmhVN2dSMDJHUkdJVmFFWFBpVDJTQ2Rtc3o4WWVW?=
 =?utf-8?B?SDZBWnJOU0I3Ym9seHFmUUNldzYyWmhWQUxCcENTN3U1SjJKZ2lQcTlmZDBs?=
 =?utf-8?B?ZlJqZFJFbmZ6Q20wOEJLR2NlVThndVBwSitIUFE3NXRrVm1IcGUwS3FMdHox?=
 =?utf-8?B?UEZTVGkrQ0d0RnNYZktWWVYzWjRta0N6T3M5SGQxMk1rZGNKaEJGM0NlRUJP?=
 =?utf-8?B?NzM1RHpUYi9FZ3BnTmYxZzMwYUx1Q2VEMldUN0ZtaDk5MGFkQXh2bkhPd3Q1?=
 =?utf-8?B?bzBHbDl0TTdYdXBxczRrUjE2NVBObjBxNDJXRWFaS3lWUVhpV3VSaGVuR2ZC?=
 =?utf-8?B?TGwxUGF3V2p3MzFSc0M2dnJlT3FFdmFHM2hiQzFWSXRVUHpVTWFXMTNkNkRt?=
 =?utf-8?B?aUE5SkJjdjF4bXJvK21QY3VjbTJBbE0zaTlreGdBOUtvQnpkVW5hTlFQL0Vv?=
 =?utf-8?B?UGJPWmFBV1I3c1dhYmx3SnNxT1R1WkpPNDBKL2pIcFo2QnhoT3RITTJPa0FS?=
 =?utf-8?B?TkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF85066F58DC534593D16AF116AC1787@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZxS5FeG5mTPuBa7bpuYU/+DXJsawbsxYSNjnitWYLgumqw+XU3JRRxtPPxNPof5gym7BdLU36jYfBEvy3tEt+SXQfXQuWXmbu3OpEBMC84HL1iPZmfx0H8uAfeohHWZidBFjzTD/9+fM3LAvk/me1fQDHi9bP/6W99d03EYpY3Ky1JAW1F4dizMHMr2/XBFiOuliwkS4uKCI0iodUuRv62toeDx2Octzu1RGoEITgWZoQzY+UfnQWxKY7ls+AXFeU7YpWiFaCSrO2mj34yxbno/PrJtFgwE3P9DNOCa70gdjrKHNd+vA5EIlxrekdrS5RyrEtv6yXG/jQMP+WJ++jVj1Cfq5AQqW8+GrJqqjzVgOFvlv6lsTFjn5qjjQ8imEyilirTmcE6YJASXZtqVSp3tEdYAKLxgiG3o5FP8XubmRPT37WXsITyUWDnJsZFQP/8cZ3t82+SoQV7mpEyRZ+tis6tqJeSHiwztGxdyR8uwowUOlnuE4+z+ltYJy/05ueaQvcx8oxKvq+X11h1bJvB4tUZ4jw28K6K/lR0Np0B3UwMMuVQ1TJKBjGb3dFpThXr3IXdDqZTUxPlLbqCiPFMAzFiFISIUsJbAcaLrAkqYYf7mqj8NUNv3Rl3Cdx8u49lEdfMtg7qH+8qHC5p9Ip8aP3vKOJhKHKwx9YwVQJloi6enuGzudUBcHPokKmrOQOE/J+rHwW+MRmGbTyUefQ2Ti8Wl7qlrx7LhjFruOaJU0cNsPrzN1SdP4v9Doe/A3Rteo33rT4KYRCr6sSveQF5NkUIx6rjc8BRAvg3J96hYADEpr/x0HlfsrWYByROoiF+qwKXyMvJYOH6ITgi1ZHWiN4bjzNFflMY5VQxvchrAmSCK9KWNYxAw6XjHuHEWY5/s7GDmo9QgQHa26LGerpphXfCqVMTOzhxlQI3YTl7U=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10399.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29567dfc-f180-4129-2a31-08dad14f4d18
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 14:46:15.1772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3vfQEnLG/DXmy5JaH7E/8gr8W1Vx+27q5DzInEARDdcytwTo+rVxoxtF0EjWEhixHaqTaaefZDtR/ZzIVSfCJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5362

DQoNCk9uIDI4LzExLzIwMjIgMjA6NTMsIEVsaW90IE1vc3Mgd3JvdGU6DQo+IE9uIDExLzI4LzIw
MjIgNzowNCBBTSwgbGl6aGlqaWFuQGZ1aml0c3UuY29tIHdyb3RlOg0KPj4gSGkgZm9sa3MsDQo+
Pg0KPj4gSSdtIGdvaW5nIHRvIG1ha2UgY3Jhc2ggY29yZWR1bXAgc3VwcG9ydCBwbWVtIHJlZ2lv
bi4gU28NCj4+IEkgaGF2ZSBtb2RpZmllZCBrZXhlYy10b29scyB0byBhZGQgcG1lbSByZWdpb24g
dG8gUFRfTE9BRCBvZiB2bWNvcmUuDQo+Pg0KPj4gQnV0IGl0IGZhaWxlZCBhdCBtYWtlZHVtcGZp
bGUsIGxvZyBhcmUgYXMgZm9sbG93aW5nOg0KPj4NCj4+IEluIG15IGVudmlyb25tZW50LCBpIGZv
dW5kIHRoZSBsYXN0IDUxMiBwYWdlcyBpbiBwbWVtIHJlZ2lvbiB3aWxsIGNhdXNlIHRoZSBlcnJv
ci4NCj4gDQo+IEkgd29uZGVyIGlmIGFuIGlzc3VlIEkgcmVwb3J0ZWQgaXMgcmVsYXRlZDogd2hl
biBzZXQgdXAgdG8gbWFwDQo+IDJNYiAoaHVnZSkgcGFnZXMsIHRoZSBsYXN0IDJNYiBvZiBhIGxh
cmdlIHJlZ2lvbiBnb3QgbWFwcGVkIGFzDQo+IDRLYiBwYWdlcywgYW5kIHRoZW4gbGF0ZXIsIGhh
bGYgb2YgYSBsYXJnZSByZWdpb24gd2FzIHRyZWF0ZWQNCj4gdGhhdCB3YXkuDQo+IA0KQ291bGQg
eW91IHNoYXJlIHRoZSB1cmwvbGluayA/IEknZCBsaWtlIHRvIHRha2UgYSBsb29rDQoNCg0KDQo+
IEkndmUgc2VlbiBubyByZXNwb25zZSB0byB0aGUgcmVwb3J0LCBidXQgYXNzdW1lIGZvbGtzIGhh
dmUNCj4gYmVlbiBidXN5IHdpdGggb3RoZXIgdGhpbmdzIG9yIHBlcmhhcHMgZ2l2aW5nIHRoaXMg
bG93ZXINCj4gcHJpb3JpdHkgc2luY2UgaXQgZG9lcyBub3QgZXhhY3RseSAqZmFpbCosIGp1c3Qg
bm90IHdvcmsgYXMNCj4gYSB1c2VyIG1pZ2h0IHRoaW5rIGl0IHNob3VsZC4NCj4gDQo+IFJlZ2Fy
ZHMgLSBFbGlvdCBNb3Nz
