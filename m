Received: from esa5.fujitsucc.c3s2.iphmx.com (esa5.fujitsucc.c3s2.iphmx.com [68.232.159.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEE21104
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 06:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1684735943; x=1716271943;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Mb4dXOSlZvSRV25VDgpgbNrvIfkiCJCyqCELQ/cjOJk=;
  b=e8XTGFgzt/vJgKn9FaLH5uuZIeJEb9MOvF2XRGm4Nu8dlXR4MT6jAZ04
   ow0Q4Gw/JtkyQrVkuVXFrus3knk4cxh9thXCfZOfYWvcjctNS+aZZIxpH
   wj9rW3DLINZ8xlifX2nd4ucPY8dS2eqNfI4ijTzuo12Sr8PYFInmdw7iw
   T3Cwz02/4AiMNQ1EbtH/t6WHL+sVj698zeNQhX64E/SAuuctZpizQKrtB
   65R83+3YAVEQgS+z4vKFGj6s8MPkhrcPQKshvNg+96NJD+jp0SVXPHP/W
   RO5FFo6IUN7YVWxmDZZvUgfGxBT89QkoHc//17JubkgVVOlxrTC4lml6k
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="85236119"
X-IronPort-AV: E=Sophos;i="6.00,183,1681138800"; 
   d="scan'208";a="85236119"
Received: from mail-tycjpn01lp2175.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.175])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 15:11:12 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEbCDCpUzyl8hq7tuBylE5mPFyuEop5Mf8fUg5D3KVk/26Vzfb3gqyL/Ru7fiHqslXwzfG6pm6H2C4t/nwGBRfxTM/jKQUPTULEavIa2NcraIBsUiysr2E3QTwnC8LmzWRg/RCZUJtU+coPcI2wgThsr795n+e31/BPn4pdNdRFlELmv9aLF4E9hLAQWWqD1+DjafcCzcKZ5+5KSjT/9iVoVH1bHo1/I5V7JgIQrzSNDV3pdOrHjUpzgOLqblh8V84gWmGYJyjCn6WhLD59wZaP6f8JH4AaTgHp8mbNt7N6vmFWVhkp+xtn8fmFIi4SrLz66a9zm6A8HGhvCKdJ7vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mb4dXOSlZvSRV25VDgpgbNrvIfkiCJCyqCELQ/cjOJk=;
 b=fGFmc1NTsTqWiD4N1b0gycUVVqWKB8sLCrjYxoo6rbt9dzgXMt4NUKP60f4E90FwJdWIleC0EHPPIfxN00d21Xe/7CM56VwUH3KkE7+pUExXfOSLtwr+xXttM5pAdY89ASH6E08Az/TvdyV5iNFdrenDu1BnryavX1YEVTXrS/zoc/WOA3/gL+YaI8DDExAKfYbeOa3xwSGK5DXaX4IEV4HmPV0IGJYzbidM6rwwLBMFx2rC7CwKKoKZSFt7WkOAsH3O0rIGtIQcUwn5A2Cy+/6lBMDd7suDgXGLLFkMRnib1h+plTkHc1VUPGWP9WhOAZtwy2twXf5AUCHknTabUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TYVPR01MB11212.jpnprd01.prod.outlook.com (2603:1096:400:36b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 06:11:09 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835%7]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 06:11:09 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 3/6] cxl/monitor: Enable default_log and refactor
 sanity check
Thread-Topic: [ndctl PATCH 3/6] cxl/monitor: Enable default_log and refactor
 sanity check
Thread-Index: AQHZhaYeSw/a8bxJ2kmDdfKDQikuB69lPdGAgACfSAA=
Date: Mon, 22 May 2023 06:11:09 +0000
Message-ID: <81f1a876-1c71-b04b-14bf-12d79b164015@fujitsu.com>
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-4-lizhijian@fujitsu.com>
 <ZGqB38I7hLvX+xCG@aschofie-mobl2>
In-Reply-To: <ZGqB38I7hLvX+xCG@aschofie-mobl2>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TYVPR01MB11212:EE_
x-ms-office365-filtering-correlation-id: 93002a9e-3b8b-4937-1138-08db5a8b562a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 RqKb7oQHtyjyacPPMt47XBXWkAOmExJSdNCNSS1wvOUyX/9IjtHs0hkJpdKxnvyvLxiQpWPBFul9YuyPDGVI1F/pEsyzR/WgyKxyTrE5jX346woVhmIjVkuYcRV5YLZlNTTuBz8G2lp/cXXU9+a3PKCzxPbT/CisZ8cM2Rg7vanqlUFYX9mjuZ8AZPkznwITavEjQ5k3oZMcLkU1TFQErSCi/B5N9vH5GNWo2hjrrRYkhbzB0C6ZmLXWjkiHnv50nKslbIBpCFHWGEJ3U3ZSKF1vJfJ/8fbvq7Comj6HI9nETulsAB3zUGB/e4Ibt2bYBaP1LD89w0NbM/FmzONVfPacHdquJMUwnRETepKlbbWknxws15ke4DrgE4Ae/r3kgMmUUwqBgQPIb7I40K92R6A61f33sJGqfmcwP3RRAVj3nbWx+hU7SlMFdikxtJcUnHVfS9/bvi8Z3UM38fRDUqh5eegTbWNFOMqcYf9mZBPu96ZGhCnZiP0fTldhRgIEi9YxYxLNw/gkw0pBee+sMj/mQmuuBdOjl1uFFBB0jxLufV/bxrPa8sj0ZKzy12LG2OJbLGYGnL2jmMChFibM2+bBLciW58AiOdmug+v1EKr1LFUCaaH8tmyibci8DSzcKTqPjcqz7L8/ChVxWVIGgjjacu/TL4PiGvzAogO/6hf8uE/o0nKl1BMAztJbOUr0UXDRQfz891Wru/2PPYZVBg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199021)(1590799018)(8936002)(8676002)(5660300002)(83380400001)(53546011)(186003)(6512007)(6506007)(26005)(2616005)(31696002)(86362001)(122000001)(82960400001)(38100700002)(38070700005)(41300700001)(71200400001)(6486002)(478600001)(6916009)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(91956017)(4326008)(85182001)(316002)(36756003)(54906003)(2906002)(31686004)(1580799015)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ejJrUFNXeW9rd0lvQ0ZBeFlsd29uNWJvd1c5bmMvOVRSRVI2Z3Nhd3U4Z0dB?=
 =?utf-8?B?SExrV3drVUhmamVOdDhwZmNpWkNINE5NbUxXK2RSOTRtbGg3WUhEU2YvTldL?=
 =?utf-8?B?ajFYbXBUYVllYVpIQm1rcHFyekxDQTd4Ri80cXUyL01HSS9kOEduSE5vMEpn?=
 =?utf-8?B?Y0tnMFBpODV1SU5RRzcvZ1JtT1kxcitxZ084LzJwS0VxcVlGeWZLUk9NMUpE?=
 =?utf-8?B?QWpjNmdUZVFvelByeVZqTCs5amZzS2tZaENybjk0cVp3OU03VjZmRE80Sk5t?=
 =?utf-8?B?UnJFeXJJdFFqN3RMckZ1ZTJuVnhKSkFQRzgxbGZjWG9kYmVYdzNuazNDL3Js?=
 =?utf-8?B?SkFQUTVXWFlyTUxLWmJhTHViNUFkR2czU000U0pGZ1lsUHRaQzZQWUYrY2pP?=
 =?utf-8?B?eVBwWXlyNndQUWZ5V1B2eFJwUndrS1hPeElMdTBudFVQRHBsOXlxN3I3YXpI?=
 =?utf-8?B?YUlFdXJrSlRYRVZQRWdwUm9rakQzWVdSQ2ZMcHBtcEYrNU8zNXZCNTdpR0cv?=
 =?utf-8?B?MVpWRGF6cnEzQzBWejBhWUFwNEhYUjQzcDZwbEdadXUrekNOTXMvMXZBbVlt?=
 =?utf-8?B?WVllUkVvMW1uV0s2a0NRUHF0aWtZMlZ1Y1RuOE1EV2pCdW81S3paTlVvZ3pH?=
 =?utf-8?B?YjdQRlJIYk9taC95THRIN0JMVy9KMGt6a1ErVWMxM29GaHlIRDFkK3dKQXBP?=
 =?utf-8?B?Mkk1cnpXT2FMSHJlTW9PMlBURzdrY0s2Nzk1OGdaYlNWNWFlSTJ2OHdwak04?=
 =?utf-8?B?VGFwL1owS0pITWg4SnBLM0JCNEpoOG9kU0pDWnBuaEdzT1V2QVJkdmxNRHFN?=
 =?utf-8?B?THdWYWRHQ09aZkNsYWhpTFd1ZGs1b1dOQXFML3BEZmxPbGVZbUZKalBQQndx?=
 =?utf-8?B?MWZIWTZYMk5YU3JvYUhHaEF5WldWREppNGU1QktydmZJb1JqcDhpTnhWblRI?=
 =?utf-8?B?ZGg3WndTaEUvOFFhOC9PWUNnWENoNzNsYWZKU0dyalZ3U3EwNkV1RGltVU9G?=
 =?utf-8?B?eFR2M2ttRUs0OEIyZmJoWXM1dXNWTXpJdGdQTmd4SkJ2SDZtZU9NRDROUEsr?=
 =?utf-8?B?bmNvYzFuSmNvVlZFelJtYXlGWjVELzNxeTBKWENMNDNvb0VLMzFOUzlpVWlJ?=
 =?utf-8?B?OXJmMlR5UUY3T0lNaDNlU05FbkhYSUlhc1BWU2pJR0RibUhKbkpEcElodzZs?=
 =?utf-8?B?bXl4VHE3ZWRmL2tPQkJpR1Z6OTE5SnhjOEZSYWhHV1lXTjc2U1ZRRlR6Nito?=
 =?utf-8?B?cDRPa082NVdCdDF0WG1DWkxSdGs0azJWRXJlNHU2clVpNkdKQXd0WExDbFFw?=
 =?utf-8?B?alVENi90aEd6V2lEM0F3T3Z1bHk0WHk2TUFlblB2eHFuWVRXWkNJRnFlUTRZ?=
 =?utf-8?B?UmxISXFXWGVNR0VPNG9iZkMwdnBDenNIbmpGNFg0Nm55cGx2QS9JcUkvQk0w?=
 =?utf-8?B?TG9WUmhiQlp2UHVkSWkySzkzdithLy8zQjE1Y3JXYXJ0UEo5aDNld2dkcWpZ?=
 =?utf-8?B?akxZKy9WU01Dd3AxL0QxU2dQL3M5WWVLTC9OVXlkT0MyTjJJMHQ3ZHljVFBF?=
 =?utf-8?B?Mk5ZWmJGcWlqa3NTQ29ZWDZCd3h5SlNFWHdrQmp2VklmZUxudWdqclV0Q0Zp?=
 =?utf-8?B?R0pOS0U4WmxSWllkMFUyOGF0Tzgwa25lM0phV2h4WllBNGdoS3Z2enNROE1E?=
 =?utf-8?B?M05oR0hPSktpbnhHNGp3RmZJZlo4L3BLdmxCTHh2WHRZZks1Z1R1L1p4WEZV?=
 =?utf-8?B?a244ZXJyVnNpN3VYYjZYcVp1blhYSllVVDRBSFpGVXMxS0t4dkFYVnhKTnlJ?=
 =?utf-8?B?RHN0RWczSlVONGJXZlFPbFB3OTlha29JRS9YclVKQ2w2M1hORDY2OUJBTktO?=
 =?utf-8?B?VE5tTCtINTROaHh5OEpYeDd5djJZV2Fqejk3cmFJYS9IWEVzUTJqY21oYVNT?=
 =?utf-8?B?UGVhZWFxalpNVEJSQTlHODlWWVd3SUdqaTViZG42Y1hMNTFobyswR1dSMVlI?=
 =?utf-8?B?RUhxb0VVc3pJTlQ4Rm5IR3FpWFp4SmhGMEdpRDdUYW5mNzltdWxpUFBXVmx0?=
 =?utf-8?B?aVJHMWtWREdqc3NlYWg2YzMrSVZ2YjdZSndVR1llMmJUb01IZ09Dc3REMXFy?=
 =?utf-8?B?Vm5yREVSU1ZMVHVacjZ0a1JuWnNmbzhCVE9MRUVld1M2ZHYzTFdYeXFGNG9y?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCBD1512CCA3EC46A417CF7746FCC0E6@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RM315gk934He+nsxygQNHkImNzzuLmU+7v3ptULz662kRGSYmv38p5X6Y5Eb7GklCjLJAJOhRXDrMVFknVU40/gElOXXV3/t6YuJ6b2HikJi1TPSxCKXVhY+oX23z7445jLhDpn7DcRo6gIXeK3gMPG5J4Ia1PaO0ojSFcfhojwkqPOXwlXIdnY/NJoPO7lbWkTE87E3u7fT6eltmW24OgCU98kbQvtUxnzO+Fjgs6E3H680Uav9zpn5EDTBlSE9MH6seZubei+4vzML2x9x47dx2AVg7+ZbJKepLsw60HGuIyiTC8AHSePTkILeaAorrxonH5n/xOumPZ0vGYPmoEbB+xXb0+4/CvkOpsbm8kyhaUW+v7UhI0dhxoA8hZ8oj9kDycRD9k5YKtfWbSjd7NIoB2FtWxbgAcjV8ys6sD8ZakJWVPTJsoVPQbmXQI4y0lqQK6FLmz9IDL/BUy814nSIusaZwzDP6/mfWpw9dZ1jL0nHVpy9VNkrhRgIwY2u0p7d2bMrlOhpEe0tGgDEvKzwYs5Bb07oiJ7RzKwPBpCDkplt+CQJbGD5WkmfeJgdlyuS+qC7yedrxt05pdW1Djp1M4WG37SKsIP0uVB8La02ycOAWPwXDnyJCZH/9zc4P6hCWgFGT+lVcKmCSY7G/2uworNEQa/Z12csBCSLEHTbYP9NdJwfEEIHjHAXUX+XwAdjcW8uqSjnFUbfaiSKGcN8T0f0vHx34X76uMfWly4h73NN2vwWTfjnos3sGlU571wCajk2oQbaP36lUGMa+DB2868X/IcM+sdyTLeD47Pvf2NPj1RVML/uhBOZSpGvHQwBxt/zCmu5JUshQ5Zopg==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93002a9e-3b8b-4937-1138-08db5a8b562a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 06:11:09.5050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ijM5A8OT5/a1kfznyI1mmPkLvQz0xQujLnOlJrN7f8YSvzfAXcv9H1oO2ippa/sREND+9T3Sd26BoTO+MVC+rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB11212

QWxpc29uDQoNCg0KT24gMjIvMDUvMjAyMyAwNDo0MSwgQWxpc29uIFNjaG9maWVsZCB3cm90ZToN
Cj4gT24gU2F0LCBNYXkgMTMsIDIwMjMgYXQgMTA6MjA6MzVQTSArMDgwMCwgTGkgWmhpamlhbiB3
cm90ZToNCj4+IFRoZSBkZWZhdWx0X2xvZyBpcyBub3Qgd29ya2luZyBhdCBhbGwuIFNpbXBseSB0
aGUgc2FuaXR5IGNoZWNrIGFuZA0KPj4gcmUtZW5hYmxlIGRlZmF1bHQgbG9nIGZpbGUgc28gdGhh
dCBpdCBjYW4gYmUgY29uc2lzdGVudCB3aXRoIHRoZQ0KPj4gZG9jdW1lbnQuDQo+Pg0KPj4gUGxl
YXNlIG5vdGUgdGhhdCBpIGFsc28gcmVtb3ZlZCBmb2xsb3dpbmcgYWRkaXRpb24gc3R1ZmYsIHNp
bmNlIHdlIGhhdmUNCj4+IGFkZGVkIHRoaXMgcHJlZml4IGlmIG5lZWRlZCBkdXJpbmcgcGFyc2lu
ZyB0aGUgRklMRU5BTUUuDQo+PiBpZiAoc3RybmNtcChtb25pdG9yLmxvZywgIi4vIiwgMikgIT0g
MCkNCj4+ICAgICAgZml4X2ZpbGVuYW1lKHByZWZpeCwgKGNvbnN0IGNoYXIgKiopJm1vbml0b3Iu
bG9nKTsNCj4gDQo+IEhpIFpoaWppYW4sDQo+IA0KPiBJIHJldmlld2VkIHRoZSBmaXJzdCBwYXRj
aCwgd2l0aG91dCBsb29raW5nIGF0IGFsbCB0aGUgcGF0Y2hlcyBpbg0KPiB0aGUgc2V0LiBJdCBz
ZWVtcyBsaWtlIHRoZSBzZXQgdG91Y2hlcyBjbWRfbW9uaXRvcigpIGF0IGxlYXN0IDINCj4gdGlt
ZXMsIGFuZCB0aGVuIGRpdmVzIGludG8gcmVmYWN0b3JpbmcgaXQuDQo+IA0KPiBJJ20gY29uZnVz
ZWQuIEkgdGhpbmsgSSBjb3VsZCBiZSBsZXNzIGNvbmZ1c2VkIHdpdGggYSBjb3ZlciBsZXR0ZXIN
Cj4gZXhwbGFpbmluZyB0aGUgZmxvdyBvZiB0aGlzIHNldC4gTWF5YmUgdGhlIGZsb3cgb2YgdGhl
IHNldCBjYW4gYmUNCj4gaW1wcm92ZWQuIEl0IHNlZW1zIHRoZXkgYXJlIHByZXNlbnRlZCBpbiB0
aGUgb3JkZXIgdGhhdCB5b3UgZGlzY292ZXJlZA0KPiBhbiBpc3N1ZSwNCg0KWWVzLCB0aGF0J3Mg
dHJ1ZS4NCg0KICBhbmQgdGhhdCBtYXkgbm90IGJlIHRoZSBjbGVhbmVzdCB3YXkgdG8gcHJlc2Vu
dCB0aGVtIGZvcg0KPiBtZXJnaW5nLg0KPiANCg0KDQpJIHdpbGwgZXhjaGFuZ2UgdGhlIG9yZGVy
IG9mIHByZXZpb3VzIHBhdGNoMSBhbmQgcGF0Y2gyIGluIFYyIGFuZCB1cGRhdGUgdGhlIGNvdmVy
IGxldHRlciBhcyB3ZWxsLg0KDQoNClRoYW5rcw0KWmhpamlhbg0KDQo+IFRoYW5rcywNCj4gQWxp
c29uDQo+IA0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBmdWpp
dHN1LmNvbT4NCj4+IC0tLQ0KPj4gICBjeGwvbW9uaXRvci5jIHwgNDEgKysrKysrKysrKysrKysr
KysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDIxIGluc2Vy
dGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9jeGwvbW9uaXRv
ci5jIGIvY3hsL21vbml0b3IuYw0KPj4gaW5kZXggODQyZTU0YjE4NmFiLi4xMzk1MDZhZWQ4NWEg
MTAwNjQ0DQo+PiAtLS0gYS9jeGwvbW9uaXRvci5jDQo+PiArKysgYi9jeGwvbW9uaXRvci5jDQo+
PiBAQCAtMTYzLDYgKzE2Myw3IEBAIGludCBjbWRfbW9uaXRvcihpbnQgYXJnYywgY29uc3QgY2hh
ciAqKmFyZ3YsIHN0cnVjdCBjeGxfY3R4ICpjdHgpDQo+PiAgIAl9Ow0KPj4gICAJY29uc3QgY2hh
ciAqcHJlZml4ID0iLi8iOw0KPj4gICAJaW50IHJjID0gMCwgaTsNCj4+ICsJY29uc3QgY2hhciAq
bG9nOw0KPj4gICANCj4+ICAgCWFyZ2MgPSBwYXJzZV9vcHRpb25zX3ByZWZpeChhcmdjLCBhcmd2
LCBwcmVmaXgsIG9wdGlvbnMsIHUsIDApOw0KPj4gICAJZm9yIChpID0gMDsgaSA8IGFyZ2M7IGkr
KykNCj4+IEBAIC0xNzAsMzIgKzE3MSwzMiBAQCBpbnQgY21kX21vbml0b3IoaW50IGFyZ2MsIGNv
bnN0IGNoYXIgKiphcmd2LCBzdHJ1Y3QgY3hsX2N0eCAqY3R4KQ0KPj4gICAJaWYgKGFyZ2MpDQo+
PiAgIAkJdXNhZ2Vfd2l0aF9vcHRpb25zKHUsIG9wdGlvbnMpOw0KPj4gICANCj4+IC0JbG9nX2lu
aXQoJm1vbml0b3IuY3R4LCAiY3hsL21vbml0b3IiLCAiQ1hMX01PTklUT1JfTE9HIik7DQo+PiAt
CW1vbml0b3IuY3R4LmxvZ19mbiA9IGxvZ19zdGFuZGFyZDsNCj4+ICsJLy8gc2FuaXR5IGNoZWNr
DQo+PiArCWlmIChtb25pdG9yLmRhZW1vbiAmJiBtb25pdG9yLmxvZyAmJiAhc3RybmNtcChtb25p
dG9yLmxvZywgIi4vIiwgMikpIHsNCj4+ICsJCWVycm9yKCJzdGFuZGFyZCBvciByZWxhdGl2ZSBw
YXRoIGZvciA8ZmlsZT4gd2lsbCBub3Qgd29yayBmb3IgZGFlbW9uIG1vZGVcbiIpOw0KPj4gKwkJ
cmV0dXJuIC1FSU5WQUw7DQo+PiArCX0NCj4+ICsNCj4+ICsJaWYgKG1vbml0b3IubG9nKQ0KPj4g
KwkJbG9nID0gbW9uaXRvci5sb2c7DQo+PiArCWVsc2UNCj4+ICsJCWxvZyA9IG1vbml0b3IuZGFl
bW9uID8gZGVmYXVsdF9sb2cgOiAiLi9zdGFuZGFyZCI7DQo+PiAgIA0KPj4gKwlsb2dfaW5pdCgm
bW9uaXRvci5jdHgsICJjeGwvbW9uaXRvciIsICJDWExfTU9OSVRPUl9MT0ciKTsNCj4+ICAgCWlm
IChtb25pdG9yLnZlcmJvc2UpDQo+PiAgIAkJbW9uaXRvci5jdHgubG9nX3ByaW9yaXR5ID0gTE9H
X0RFQlVHOw0KPj4gICAJZWxzZQ0KPj4gICAJCW1vbml0b3IuY3R4LmxvZ19wcmlvcml0eSA9IExP
R19JTkZPOw0KPj4gICANCj4+IC0JaWYgKG1vbml0b3IubG9nKSB7DQo+PiAtCQlpZiAoc3RybmNt
cChtb25pdG9yLmxvZywgIi4vIiwgMikgIT0gMCkNCj4+IC0JCQlmaXhfZmlsZW5hbWUocHJlZml4
LCAoY29uc3QgY2hhciAqKikmbW9uaXRvci5sb2cpOw0KPj4gLQ0KPj4gLQkJaWYgKHN0cmNtcCht
b25pdG9yLmxvZywgIi4vc3RhbmRhcmQiKSA9PSAwICYmICFtb25pdG9yLmRhZW1vbikgew0KPj4g
LQkJCW1vbml0b3IuY3R4LmxvZ19mbiA9IGxvZ19zdGFuZGFyZDsNCj4+IC0JCX0gZWxzZSB7DQo+
PiAtCQkJY29uc3QgY2hhciAqbG9nID0gbW9uaXRvci5sb2c7DQo+PiAtDQo+PiAtCQkJaWYgKCFt
b25pdG9yLmxvZykNCj4+IC0JCQkJbG9nID0gZGVmYXVsdF9sb2c7DQo+PiAtCQkJbW9uaXRvci5j
dHgubG9nX2ZpbGUgPSBmb3Blbihsb2csICJhKyIpOw0KPj4gLQkJCWlmICghbW9uaXRvci5jdHgu
bG9nX2ZpbGUpIHsNCj4+IC0JCQkJcmMgPSAtZXJybm87DQo+PiAtCQkJCWVycm9yKCJvcGVuICVz
IGZhaWxlZDogJWRcbiIsIG1vbml0b3IubG9nLCByYyk7DQo+PiAtCQkJCWdvdG8gb3V0Ow0KPj4g
LQkJCX0NCj4+IC0JCQltb25pdG9yLmN0eC5sb2dfZm4gPSBsb2dfZmlsZTsNCj4+ICsJaWYgKHN0
cmNtcChsb2csICIuL3N0YW5kYXJkIikgPT0gMCkNCj4+ICsJCW1vbml0b3IuY3R4LmxvZ19mbiA9
IGxvZ19zdGFuZGFyZDsNCj4+ICsJZWxzZSB7DQo+PiArCQltb25pdG9yLmN0eC5sb2dfZm4gPSBs
b2dfZmlsZTsNCj4+ICsJCW1vbml0b3IuY3R4LmxvZ19maWxlID0gZm9wZW4obG9nLCAiYSsiKTsN
Cj4+ICsJCWlmICghbW9uaXRvci5jdHgubG9nX2ZpbGUpIHsNCj4+ICsJCQlyYyA9IC1lcnJubzsN
Cj4+ICsJCQllcnJvcigib3BlbiAlcyBmYWlsZWQ6ICVkXG4iLCBsb2csIHJjKTsNCj4+ICsJCQln
b3RvIG91dDsNCj4+ICAgCQl9DQo+PiAgIAl9DQo+PiAgIA0KPj4gLS0gDQo+PiAyLjI5LjINCj4+
DQo+Pg==
