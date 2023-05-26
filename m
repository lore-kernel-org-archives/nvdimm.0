Received: from esa17.fujitsucc.c3s2.iphmx.com (esa17.fujitsucc.c3s2.iphmx.com [216.71.158.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663001FC6
	for <nvdimm@lists.linux.dev>; Fri, 26 May 2023 04:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1685073781; x=1716609781;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pDdRuRMLz2+lwaPW9XeMjXqcFntnKcJMBzSx/TslVtE=;
  b=Cj7Te/YWfusr6Ht5PiPihtdf8sBdjfdGPUrh5O2+0wiSa0R7QG5uVSyM
   SMUTMRgKOLmfDWgzR4zhwm9QBNSGI/AjsgXW06BwLK1OgFeWAxb5CaB0T
   h5F2wAHqdWvmj7iWyWiS1Yd4KXo/MNR5Rfa7vcW9/qZgSbCiWvvYOElfp
   ior1M9M09XSrZ0j7jVqVHlNx07H6JNqzVOzCQFJ1USsAUeRrvdwxkRSV8
   h1BBgDkc2L/wwNV5EnIaI7iUIx03jSe8GWahs6113Ik5Pmvh6TJGylIGI
   voLAG5WE0A+4H+u3bNjJ/A3BE8HwicVyx/O9oqFeJE1Ayv/p+l8TF/AFq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="85313235"
X-IronPort-AV: E=Sophos;i="6.00,193,1681138800"; 
   d="scan'208";a="85313235"
Received: from mail-os0jpn01lp2112.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.112])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 13:01:48 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGCsg4ySUy+QH55YgvKHYfJ09HLg+EBy0IOii444Q9DFTWUWcgfCt6iUhB3Nt7j3pwKxoL1KSwTRziOokFDI7T0tfDIS3IINoKRUXKmvz0v0fkDSMbPr4QDFfPeYgTsSEM6ADfczNxbZbjCrzcYHYtZIwdpp8sjGT42kO+T0rWdQg3jmCV1DPJYe9KfmSKvP7TuKi5zGGiPmXUBe0ZSVrvQXLCuPfNLTh1MEiUxy5DF4qnQ9Ee6hXfgiYoLKcgubPEArmW5Ts6Wr281DGYLXbmSNwpVqd9OqddwrdnPGmzDDt+Ok6mQ15pxI9JKb2vxfWaY164Ysx0ig5NWA5QG3cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDdRuRMLz2+lwaPW9XeMjXqcFntnKcJMBzSx/TslVtE=;
 b=VFhCqQB17AvaG+WUrVuDCqeUxbU9yyYzOLjzW+22fMv+EmY0iMIOe582DUo/QDkiloPgwwsSX0v3YZYViLvjzXkvMBE1QXwAjsms0X87SqAfJxUPMYDQGU85vXhqGNjdjgpLbXLbRsObjN+bFQ+0AXkjwdGqrcuCGeYDE/9kaK/lqPT8F1qSqu3qnYwBk8wRO8wZNCa6X7/f/kvwd9Tau8O2MoFMUq6riuEQV5HHoQiLnN9/uHHd+8K54VsB0IgMKmrX72/ITlkOhaap83PudsSma2iX4x63rkjAJ9f/IzQiMpAdpVTOzb7nWSLjPXEC0IF03JkOft6NM2OpktF77Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TY3PR01MB10930.jpnprd01.prod.outlook.com (2603:1096:400:3af::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Fri, 26 May
 2023 04:01:45 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835%7]) with mapi id 15.20.6433.016; Fri, 26 May 2023
 04:01:45 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dave Jiang <dave.jiang@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 2/2] README.md: document CXL unit tests
Thread-Topic: [ndctl PATCH 2/2] README.md: document CXL unit tests
Thread-Index: AQHZjSqqspIpLQ5sj0min3HqTE0Gha9rIMEAgADSeYA=
Date: Fri, 26 May 2023 04:01:44 +0000
Message-ID: <d77dbd2e-452e-ab91-d045-e89fd7a7a9f9@fujitsu.com>
References: <20230523035704.826188-1-lizhijian@fujitsu.com>
 <20230523035704.826188-2-lizhijian@fujitsu.com>
 <43b38130-19fa-26b5-f7b3-8429c5230c66@intel.com>
In-Reply-To: <43b38130-19fa-26b5-f7b3-8429c5230c66@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TY3PR01MB10930:EE_
x-ms-office365-filtering-correlation-id: 8afc18e6-1ef1-45b0-b746-08db5d9debb8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 7VEzEDHQIFksRBtWeC/E/6whc+R0WAUkFsWErp8Jtzikl9xyZSg080l3EGTQMd+Rc0VxlfZUi4Ps4veMEc762YrI5/u4QolqmtZ1pygRaNJsN8Yvf0m+LfSbCvKj/RWooS7cFDs+nF4XMdhz2ODc97hZHpG95RNaeGSJw6Ah7CY/AgDvL1IptG+J+KrfD/x5B1Akvnls7xHnKBAZ/abmADyBcTyQUm1A/fnIrQv8tCmE5WzWZjuYPvxp21wxf4zzMdzoO00tNUhiLQ+GMxSROgxtpVh47d82GocsD6QzAed4QQOLq7ygnYKb543fx4w77HO6bdbjHNyP+0kunjRKPGvkq4Z8MWVrquCw3BkGv6o/MYa4fzuZwe4Y9bLT9vzMvqtzTxg+2YciWvZHRSokYJy+QpoCwTJeJPh4e+CiNizBMymDUgHKiZi4Qzh8Voegjun26S/aEVhf3xwVTABKWbT+vxDTXDEGXcXX4pWe4Ezj6wYSgbmmqKuALgal8/HCQt+8mh0LuN3JmBOL3Ba4podsLclwHzJW930ezFhtNNxWYxqfwSu6mM48sU8rhMu21R5tN0vIi2LutCEOrhfNEvb6Qx6TsG/xfm9V7bzwmYMuwuQlq+LWgfvyW4WQwjELpH01JsnLNPCRpGpfygygb2eJgbUxQVNuLf/bxzi6vhnTyzmxUsGEhWMu74/lmmks
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(1590799018)(451199021)(36756003)(85182001)(110136005)(966005)(86362001)(31696002)(6486002)(66556008)(8936002)(66446008)(4326008)(8676002)(64756008)(66946007)(76116006)(66476007)(91956017)(5660300002)(316002)(31686004)(1580799015)(41300700001)(478600001)(2906002)(71200400001)(82960400001)(186003)(6512007)(38070700005)(122000001)(53546011)(38100700002)(2616005)(83380400001)(6506007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WCtJa2ZPWDRTRUl5bUlVM0x2c2E5Z0F0c2g0YzVCeThGY1QvdnFWM0lWREVr?=
 =?utf-8?B?cTZ3SmdqTThYZG5wZFh0YzlEeEFiNHVra21CaHc3aU52UkZXREdNYzgrVGts?=
 =?utf-8?B?K040a1k3cGZRVGhBYXdadms4azhLUW5WdjhUcUlXeDBCTEo4SVZlVjNnVU5E?=
 =?utf-8?B?TUQvOGRKV21iUG1Ld3BYYkVUSGlFaUtBWEhkMUl0Z01aekNIMjBUcWZoSk1r?=
 =?utf-8?B?TUxCcW4wTDBwZGc4QXlHRVR3eDZtaTUxc3I2WExCWTJmYlVkV015RG1yZTl1?=
 =?utf-8?B?S3hCM2ttcFJQSGhIYkZRQUVRamlIT2RNQ2ZYaEpHNWlINkNOdXJSRlBJNGdL?=
 =?utf-8?B?ZlRYOHFFSkhXdGhJUHd6cUwvUnN0UzdPSERHdGZMb2NyQlZFWnI3RUZabnJK?=
 =?utf-8?B?VmNjMm44MzlQNmUyUWV4dG41bE9hUmQrSStLRmNOUS91Ky9FellwVnhoL3da?=
 =?utf-8?B?d3dDL1I4S3E4dDJDU0k3SGtXU1lNdVNIR3RSZXFQdWRoTXpxWS9GUmpsNmpj?=
 =?utf-8?B?dnkrMFJ3ajkvT1gyN1BaTWhaeDNxaExzbDd0aE1VWmhPRGRjbjFOME52K0d4?=
 =?utf-8?B?alpyWEVLUFRHcWgybFJ6Sk9wbE1uNEJOMGFIUTk3QWFBV0NPK3pjS0RUempU?=
 =?utf-8?B?WllEa1NoY29CZHlZTGhkS3JhV0wwRTM3UnJlTndxY2NLYTkxVEludFkrV3Bi?=
 =?utf-8?B?RCtiZ2gxZDRSYzgvWERrdWlqUkt0bEx5WVhJdUt5RFc5a2ZmWGl0V3JLUkhU?=
 =?utf-8?B?WXE3eGNLNVFTdzJZbW5YVElZNHdYU1FGeWJkZ3p5L0RNcUxpa2xiWkpEclN3?=
 =?utf-8?B?bkdmZXh2VHA5VGpjVmhGWmNDTVE1aVplUk1YaDUyK0hCOVRoVkZ5YTBOaG5R?=
 =?utf-8?B?blVTaHFGRk9ESytKcFUyeGR0Ung0UWFDYVkzWFMzem5jZmNUQXl2dS9xR20r?=
 =?utf-8?B?SnRLbFIrWWIybEZ5cDVTY0Mzc1pvb0tzWkpaUmFKK1hTMGRmb1ZNOFpHZU56?=
 =?utf-8?B?RHJhT2Z1b3hyVS9VL2VRQzlUQ2hjK1U4VUpINjgxR2VSbjMyWGJCUHNKUWw1?=
 =?utf-8?B?NitJT1d2MklDdndSUUVVQXlHMzdabkpxMDJucFFyazlHSDJBcmkyNGlTcVVK?=
 =?utf-8?B?TnorOWVVWVAvTFRrMXM4QzB2b3NJVXdFQWFVZE01VDBSSmw4V3dDWW9qdFc3?=
 =?utf-8?B?dktMTmYzalFPV3M0TWhEcjdLN0xiM0E0cUUzRkdseFcwUUM1TGE5S1I3MTZz?=
 =?utf-8?B?b2tZVjdQZUN2OWlCeWlsLy9yWENIS2dka05TWmg0UFBWRlp2TXhjdXlLQ0Nw?=
 =?utf-8?B?ZENJbmdkb0RSSmpKdnN4N200Y0JYWEkxL3lGbzRDNVowTGxtNlhiVG1vQ29D?=
 =?utf-8?B?dHZnK05rMDFLTnlqb0RGcWg1QnFHYWY1YzYvMDhwVm5DWURjZ1NxVUJVYkhh?=
 =?utf-8?B?bkVINkZiR01zdnc3N0FQc1JnbzR2R3ZwVlpOV05vK2RiMGxTZDZDdVhLTFpp?=
 =?utf-8?B?ak1POGlmUjB2bkQyOU9TYUVkU0U0eit6TDVqeVc5T3ZWSDBiUnR2Zk9Wdnhj?=
 =?utf-8?B?Z0ViV0VENDVkYytOekx2V0ExMkRQRk5JbFRRTm8wbTFWUEV1T1h3SEZ5VEN1?=
 =?utf-8?B?SEZqaTBVelBLUEcrZGVBcEEzR0hLbzJwb0w3ak1GZVBMaHJJOHJPUFhPUW9n?=
 =?utf-8?B?S2NlK0Z4T2E1OW8wU01aTWhTUGtSODlVanorUGx6c3BLMGJrMnFtalpKaTJ4?=
 =?utf-8?B?WHAwK3htYWR3MVlhUHFpWldYWWNITC9HS010cFgzcHdhY3FNMGxjUmFwNGg2?=
 =?utf-8?B?bUZsY1NQa1B2NUNrdXBNM0pYeFdxN214OWIxL3prSmVkOGZKb3F3YkFNbFRk?=
 =?utf-8?B?M01oNW5xMVJOSDdmZ3gvTDdvWTF6Y1Q5YVlHTGprdmp3Ykd3OUQxZzlpTGJ4?=
 =?utf-8?B?T0RKK282eUtsWjRQWGx4akcvYmxzM1h6My92SXhjd2IvUUZXM01NOUU2ZzVG?=
 =?utf-8?B?ak85dDE0UFZjZ2N0Zjl3NTF6TEJTeFRtcFZtcmNuMVRDUzJMVVVUcDZlVytl?=
 =?utf-8?B?ZytsNFhNTktwZmtybWNqWHBZZFlYdkxTK2J6SU5DSFlWeXNvbCs1NEdtbVU2?=
 =?utf-8?B?eitqSkpTcHhTUUdNZVIzeTdka1NuNk1QSTdrRzNFOXFHSFB1NUdlN20wd0Fm?=
 =?utf-8?B?OHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A22A8CFBE032F24293BAE6DA07C73EFA@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MkGPsRDZaqgpxslA3QV1sC8ir19KVykAKSHmcdVS3ydPeUZ403P89tpnMYR4uDoHiq8gSrXESoOX1zhY3N61hdloerS12iuiujLDoQdnqKjuNsLwt1hKsysquMwxD+Ni9Yk8AZOkcHSIHX/mRjTKZc0rf1T+ipvtHgPe4nPv/syfiK3erjLbEPzsGpQyiOGqzqVUvLHaf/MD9v4rIfHai1k4cX+34+s7pJr0X+GbmcALkajBSehB3OroU40usENw3foYHQtggx5tn9+lxA7EjYxUl14facNh4BmndddAnEQGhEciZKoM+2rYh+/7LzyO++OqwGkcma9aHxHbLf5b3lzX/nKkwifJ82o2z4NSl+KYoJOM/+E3WOwK7UqGUj5J8L2f4/wgQyA2oiTK8773Xkpz/rpg8ILEXiJc/NoBJo9tfeiNNaJUdOAcnTSu7gg4SmAb4wBZLxcTJQ9Y8FWbFUDOZWiXhAcwzad2LIVCa8t1Ei70XXSZCXaYya/WE7iOId9eAcevcxnCfY9s8HrHfItBSdKScYjbuEks5Cas69mxvnCCp5Q7r6CWCm4xv/7j/mgZcLQIoMFTuKg+B3kqNGqFOdy3d3A6zezIrYoFc1Q1C3aXLPpKO2TWSBbI+AjE0LqaTbtiRrsKOW+uKoMnmUwAk/1dkrfq2ak/Z21UiUGvV/83PoWkO8j93ElrtDIxE/qyQyqPHSWsY5zYzOc3rYyc/dEV0cfNkUUrb0ZToWK5PmBXvmvKy1RmvIzcthsN+/CkjFBNg8vZK2jlJp68RDRWsCEIyHA1HkykASX/AfA+EYX0TeAB7MBjHg8qFURWkZjpB0Ovd2ckn6F9d+Wupw==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8afc18e6-1ef1-45b0-b746-08db5d9debb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 04:01:44.8513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xYm7OpntdmqZ1o9pJ9z1JjurMwlWIkS228QREMED2GBpS4Fd9wjHrk9RUAohr37Mgj/QE5juxwIfqPwvBBtO3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB10930

DQoNCk9uIDI1LzA1LzIwMjMgMjM6MjgsIERhdmUgSmlhbmcgd3JvdGU6DQo+IA0KPiBPbiA1LzIy
LzIzIDIwOjU3LCBMaSBaaGlqaWFuIHdyb3RlOg0KPj4gSXQgcmVxdWlyZXMgc29tZSBDTFggc3Bl
Y2lmaWMga2NvbmZpZ3MgYW5kIHRlc3RpbmcgcHVycG9zZSBtb2R1bGUNCj4+DQo+PiBTaWduZWQt
b2ZmLWJ5OiBMaSBaaGlqaWFuIDxsaXpoaWppYW5AZnVqaXRzdS5jb20+DQo+PiAtLS0NCj4+IMKg
IFJFQURNRS5tZCB8IDE3ICsrKysrKysrKysrKysrKy0tDQo+PiDCoCAxIGZpbGUgY2hhbmdlZCwg
MTUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvUkVB
RE1FLm1kIGIvUkVBRE1FLm1kDQo+PiBpbmRleCA3YzdjZjBkZDA2NWQuLjUyMWUyNTgyZmIwNSAx
MDA2NDQNCj4+IC0tLSBhL1JFQURNRS5tZA0KPj4gKysrIGIvUkVBRE1FLm1kDQo+PiBAQCAtMzks
OCArMzksOCBAQCBodHRwczovL252ZGltbS53aWtpLmtlcm5lbC5vcmcvc3RhcnQNCj4+IMKgIFVu
aXQgVGVzdHMNCj4+IMKgID09PT09PT09PT0NCj4+IC1UaGUgdW5pdCB0ZXN0cyBydW4gYnkgYG1l
c29uIHRlc3RgIHJlcXVpcmUgdGhlIG5maXRfdGVzdC5rbyBtb2R1bGUgdG8gYmUNCj4+IC1sb2Fk
ZWQuwqAgVG8gYnVpbGQgYW5kIGluc3RhbGwgbmZpdF90ZXN0LmtvOg0KPj4gK1RoZSB1bml0IHRl
c3RzIHJ1biBieSBgbWVzb24gdGVzdGAgcmVxdWlyZSB0aGUgbmZpdF90ZXN0LmtvIGFuZCBjeGxf
dGVzdC5rbyBtb2R1bGVzIHRvIGJlDQo+PiArbG9hZGVkLsKgIFRvIGJ1aWxkIGFuZCBpbnN0YWxs
IG5maXRfdGVzdC5rbyBhbmQgY3hsX3Rlc3Qua286DQo+PiDCoCAxLiBPYnRhaW4gdGhlIGtlcm5l
bCBzb3VyY2UuwqAgRm9yIGV4YW1wbGUsDQo+PiDCoMKgwqDCoCBgZ2l0IGNsb25lIC1iIGxpYm52
ZGltbS1mb3ItbmV4dCBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvbnZkaW1tL252ZGltbS5naXRgDQo+PiBAQCAtNzAsNiArNzAsMTMgQEAgbG9hZGVkLsKgIFRv
IGJ1aWxkIGFuZCBpbnN0YWxsIG5maXRfdGVzdC5rbzoNCj4+IMKgwqDCoMKgIENPTkZJR19OVkRJ
TU1fREFYPXkNCj4+IMKgwqDCoMKgIENPTkZJR19ERVZfREFYX1BNRU09bQ0KPj4gwqDCoMKgwqAg
Q09ORklHX0VOQ1JZUFRFRF9LRVlTPXkNCj4+ICvCoMKgIENPTkZJR19DWExfQlVTPW0NCj4+ICvC
oMKgIENPTkZJR19DWExfUENJPW0NCj4+ICvCoMKgIENPTkZJR19DWExfQUNQST1tDQo+PiArwqDC
oCBDT05GSUdfQ1hMX1BNRU09bQ0KPj4gK8KgwqAgQ09ORklHX0NYTF9NRU09bQ0KPj4gK8KgwqAg
Q09ORklHX0NYTF9QT1JUPW0NCj4+ICvCoMKgIENPTkZJR19ERVZfREFYX0NYTD1tDQo+IA0KPiBQ
cm9iYWJseSBzaG91bGQgaGF2ZSBhIHNlcGFyYXRlIGVudHJ5IGZvciBDWEwgY29uZmlncyBmb3Ig
dGVzdGluZy4gVGhlcmUncyBhIGN4bC5naXQgYXQga2VybmVsLm9yZyBhcyB3ZWxsLg0KPiANCj4g
QWxzbyB3aWxsIG5lZWQ6DQo+IA0KPiBDT05GSUdfTlZESU1NX1NFQ1VSSVRZX1RFU1Q9eQ0KPiAN
Cg0KSSBhbHNvIG5vdGljZWQgdGhhdCBZaSBoYXZlIHNlbnQgYSBwYXRjaCB0byBhZGQgdGhpcyBh
bmQgc29tZSBvdGhlciBrY29uZmlncw0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbnZkaW1tLzIw
MjMwNTE2MTIxNzMwLjI1NjE2MDUtMS15aS56aGFuZ0ByZWRoYXQuY29tL1QvI3UNCg0KPiBDT05G
SUdfQ1hMX1JFR0lPTl9JTlZBTElEQVRJT05fVEVTVD15DQoNClllcywgaSBpbmRlZWQgbWlzc2Vk
IGl0Lg0KDQpJIGluc2VydCBhIHNlY3Rpb24gYmVmb3JlICpydW4gdGhlIHRlc3QqIGFzIGJlbG93
LiBBIG1hcmtkb3duIHByZXZpZXcgb2YgUkVBRE1FLm1kDQpQbGVhc2UgdGFrZSBhbm90aGVyIGxv
b2suDQoNCmRpZmYgLS1naXQgYS9SRUFETUUubWQgYi9SRUFETUUubWQNCmluZGV4IDdjN2NmMGRk
MDY1ZC4uMzI0ZDE3OWFjNGVhIDEwMDY0NA0KLS0tIGEvUkVBRE1FLm1kDQorKysgYi9SRUFETUUu
bWQNCkBAIC04Miw2ICs4MiwzMiBAQCBsb2FkZWQuICBUbyBidWlsZCBhbmQgaW5zdGFsbCBuZml0
X3Rlc3Qua286DQogICAgIHN1ZG8gbWFrZSBtb2R1bGVzX2luc3RhbGwNCiAgICAgYGBgDQogIA0K
KzEuIENYTCB0ZXN0DQorDQorICAgVGhlIHVuaXQgdGVzdHMgd2lsbCBhbHNvIHJ1biBDWEwgdGVz
dCBieSBkZWZhdWx0LiBJbiBvcmRlciB0byBtYWtlIHRoZQ0KKyAgIENYTCB0ZXN0IHdvcmsgcHJv
cGVybHksIHdlIG5lZWQgdG8gaW5zdGFsbCB0aGUgY3hsX3Rlc3Qua28gYXMgd2VsbC4NCisNCisg
ICBPYnRhaW4gdGhlIENYTCBrZXJuZWwgc291cmNlKG9wdGlvbmFsKS4gIEZvciBleGFtcGxlLA0K
KyAgIGBnaXQgY2xvbmUgLWIgcGVuZGluZyBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvY3hsL2N4bC5naXRgDQorDQorICAgRW5hYmxlIENYTCBzcGVjaWZpYyBr
ZXJuZWwgY29uZmlndXJhdGlvbnMNCisgICBgYGANCisgICBDT05GSUdfQ1hMX0JVUz1tDQorICAg
Q09ORklHX0NYTF9QQ0k9bQ0KKyAgIENPTkZJR19DWExfQUNQST1tDQorICAgQ09ORklHX0NYTF9Q
TUVNPW0NCisgICBDT05GSUdfQ1hMX01FTT1tDQorICAgQ09ORklHX0NYTF9QT1JUPW0NCisgICBD
T05GSUdfQ1hMX1JFR0lPTj15DQorICAgQ09ORklHX0NYTF9SRUdJT05fSU5WQUxJREFUSU9OX1RF
U1Q9eQ0KKyAgIENPTkZJR19ERVZfREFYX0NYTD1tDQorICAgYGBgDQorICAgSW5zdGFsbCBjeGxf
dGVzdC5rbw0KKyAgIGBgYEZvciBjeGxfdGVzdC5rbw0KKyAgIG1ha2UgTT10b29scy90ZXN0aW5n
L2N4bA0KKyAgIHN1ZG8gbWFrZSBNPXRvb2xzL3Rlc3RpbmcvY3hsIG1vZHVsZXNfaW5zdGFsbA0K
KyAgIHN1ZG8gbWFrZSBtb2R1bGVzX2luc3RhbGwNCisgICBgYGANCiAgMS4gTm93IHJ1biBgbWVz
b24gdGVzdCAtQyBidWlsZGAgaW4gdGhlIG5kY3RsIHNvdXJjZSBkaXJlY3RvcnksIG9yIGBuZGN0
bCB0ZXN0YCwNCiAgICAgaWYgbmRjdGwgd2FzIGJ1aWx0IHdpdGggYC1EdGVzdD1lbmFibGVkYCBh
cyBhIGNvbmZpZ3VyYXRpb24gb3B0aW9uIHRvIG1lc29uLg0KDQoNCj4gDQo+IA0KPiANCj4+IMKg
wqDCoMKgIGBgYA0KPj4gwqAgMS4gQnVpbGQgYW5kIGluc3RhbGwgdGhlIHVuaXQgdGVzdCBlbmFi
bGVkIGxpYm52ZGltbSBtb2R1bGVzIGluIHRoZQ0KPj4gQEAgLTc3LDggKzg0LDE0IEBAIGxvYWRl
ZC7CoCBUbyBidWlsZCBhbmQgaW5zdGFsbCBuZml0X3Rlc3Qua286DQo+PiDCoMKgwqDCoCB0aGUg
YGRlcG1vZGAgdGhhdCBydW5zIGR1cmluZyB0aGUgZmluYWwgYG1vZHVsZXNfaW5zdGFsbGANCj4+
IMKgwqDCoMKgIGBgYA0KPj4gK8KgwqAgIyBGb3IgbmZpdF90ZXN0LmtvDQo+PiDCoMKgwqDCoCBt
YWtlIE09dG9vbHMvdGVzdGluZy9udmRpbW0NCj4+IMKgwqDCoMKgIHN1ZG8gbWFrZSBNPXRvb2xz
L3Rlc3RpbmcvbnZkaW1tIG1vZHVsZXNfaW5zdGFsbA0KPj4gKw0KPj4gK8KgwqAgIyBGb3IgY3hs
X3Rlc3Qua28NCj4+ICvCoMKgIG1ha2UgTT10b29scy90ZXN0aW5nL2N4bA0KPj4gK8KgwqAgc3Vk
byBtYWtlIE09dG9vbHMvdGVzdGluZy9jeGwgbW9kdWxlc19pbnN0YWxsDQo+PiArDQo+PiDCoMKg
wqDCoCBzdWRvIG1ha2UgbW9kdWxlc19pbnN0YWxsDQo+PiDCoMKgwqDCoCBgYGA=
