Received: from esa2.fujitsucc.c3s2.iphmx.com (esa2.fujitsucc.c3s2.iphmx.com [68.232.152.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2722A10F6
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 09:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1669887852; x=1701423852;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=d5PSXsl200/dHzDmgT/UsdbkeKZBkei7R/enszfhInU=;
  b=Zcs9ay/lEDqUtU+/dgp7F76cCZVv6nUjpFDCbF2JMH71Qu0kZHe4GgdJ
   mW7MbKnJ8yqj/wilA3v8NN6nUYaXrQIzqKH4pUxYGkwhEG+inlWzLtxVA
   NdwAqKRVOhMv5qp23nqHZ6aX0s4oLuWkAA4ZdaPmx1gpoht74T6E+R+dX
   6Gh6P5+99XJ8zGFdz0slpiVslUqVyMsEEqCftgOWy/EaTB68lD6+il5iC
   GvHpyICZsuHZm+msEtXYLCtZcmnhpTufDuOnLQiEHS/x9arIUjN5M/Bw9
   O7uele0AlorTEpJf+5Og6Vdn2kW33yEnn7bbgYA4uoZjyEDqTmlZrtNTX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="79653618"
X-IronPort-AV: E=Sophos;i="5.96,209,1665414000"; 
   d="scan'208";a="79653618"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 18:42:59 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JdNeDysdkASRwF4GSLY1LigjwuL429gr2KXwTr5p578rc9oinJoc3keA2TdNE18JuGBSlIypoh7EpJtbi1KQ9ghFjq+NXYtZTGDskuqH6Oi6jv2i4R6m3cQ2c/XP+OVYDUJmm+SLC7ctlMG47yiPoAAyBs+yZTNxB7NMDaBCn2klYXBSaCARQU/xBC0SIOq/YHsOkMC4oz0KncMjtUwQf7FtryokzNeWZpOQzt1Z1KIuTmlyNe6rU6J4dbxL5ZtU7CKTWeZFdrj3rEmFkYiiBfPnP9Fz4OFnX5yoiX7gehdwMACH23KHyBkhZstMwBvF40Hycu+QPEULK5yeX5ADOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5PSXsl200/dHzDmgT/UsdbkeKZBkei7R/enszfhInU=;
 b=C3lqZIID7apUTmW5EuOxVXh+fa04P9a6kruYAVQoxG4MlpQ2STqvLES7ba9DGiWCqXyX7YVBnY+Wbz8Ynzs0hNcx+ZhEr8hm9N5yCay4k0fUqxSetB6bMxNw3O+l1sBQDnw9pWV985ewh9W84CliiQ4a7Gu26fCri3ZcW3zKWnAEWTI9vifClppPDADSTTWSRb4ZfZfC5wOGHXEnIl794F3XNav1fJ7Fn1218lTF23bC0zmGGAxLnvBCm8MtHdrUB2OinIrN6ouTFybbdSOA7UUz5etH1LMdESF3MW/ud7ZYrKG7lMWrvp805AyQofj6cb+76EFBfD8bFWTNngrX0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 (2603:1096:604:1fb::14) by TYYPR01MB7997.jpnprd01.prod.outlook.com
 (2603:1096:400:fc::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 09:42:55 +0000
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::b01a:186c:94a7:acc9]) by OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::b01a:186c:94a7:acc9%8]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 09:42:55 +0000
From: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
To: Dan Williams <dan.j.williams@intel.com>, "kexec@lists.infradead.org"
	<kexec@lists.infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: nvdimm,pmem: makedumpfile: __vtop4_x86_64: Can't get a valid pte.
Thread-Topic: nvdimm,pmem: makedumpfile: __vtop4_x86_64: Can't get a valid
 pte.
Thread-Index: AQHZAyGAOITJM2u3P0G+LOV0TMT94K5X5+qAgADkYYA=
Date: Thu, 1 Dec 2022 09:42:55 +0000
Message-ID: <87494bc8-5eae-f3c7-dce9-22e2390193d2@fujitsu.com>
References: <ac8d815b-b5ca-4c4f-4955-ba9adbce8678@fujitsu.com>
 <6387b787364f9_3cbe02947b@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <6387b787364f9_3cbe02947b@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB10390:EE_|TYYPR01MB7997:EE_
x-ms-office365-filtering-correlation-id: 5476e527-12f9-4267-cb17-08dad3806c94
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 RdEHu/CZpjRTkb9d4ekOmwWE+giHUfqVyHIwHLW7t3cuZriFucSxbj1gvYYUr97NB+w65ByuGRHUyCOkWWJRdPekZzmQlV07HqYpuDvyzj6K0Pb7aUC9KtaRZ0/QHho66DHND6D1JZSIB40TC49pz936QfsIC4RskgiYknB8JU5f8Y/3K0tsjn7Xrdch0ig5lm6fC/QObRxMvYazlOClKcAs+x1IqF/f1LgPW+lTnLAf4AUJDzedjBvUjMDqEJtsLbX8ccdy34UokwnO79tmaltmN9tgtCMDD+MrtvkdbphOoSMj4M5/rupCLylCzO13RgNZ22XaQPuFXPJUpwqYLt1mxfTw3MuWTLeMoaeelzCCVL3rV9RMTeJgKe8sqYQI0Ju6ZfSMHEZ7QayaImuZMPUXnLi2Pc035hUMYDnzvy+mPV+2SzNrx+UVE6aSmGkrTe82MlGjnMnL8UlGTJ9AJbJ3edYbGXDC7GUjQCsm/RqgmJEXDWDe0ktxZPQ5T0AIJLW4f0/gpOeEnm7Z0ASQmUZenxSCKI8N1k3b5kj1WUg0NvWtk69D5rl/rXaKqiN+UwviPq+7sa/coGvoCS/sfF6hIL7HRZZPpxNQsC5mLtzuZU4tbQrhPQo5Bh1sHq4QhRwwgQBxLefnhinquEvOkMvPXCbyuHyj5hPzZ/4SVjjc5yFJsj9o/lM3NSJAtc5+I9CYlBq0wpk5ipYPNBC2Ip4unJ/AXObx+wuJOIT1tmFLfYpVfa2cGXSThPGNOqopWr+dWje8yaplkTBfTL9uglrXRkwpon9QYqDEGHQ1rTZDyMu2UZm3KmYRPzs76vVn/j4fiNsJ/H4ciZ86V/RmUw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB10390.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(1590799012)(6486002)(82960400001)(31686004)(36756003)(85182001)(1580799009)(66899015)(110136005)(38100700002)(38070700005)(122000001)(8676002)(86362001)(31696002)(8936002)(478600001)(6512007)(64756008)(91956017)(66556008)(66946007)(316002)(76116006)(966005)(186003)(2906002)(71200400001)(41300700001)(66446008)(66476007)(2616005)(26005)(5660300002)(53546011)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VDJWb3ZBRG9NSlc5eHJ2R2NNVW9PMXpHZHowdElhc0gyK0xWR0NseDhvQ1Fs?=
 =?utf-8?B?NjVBU3hTc1dseGVaby9KV1F1R2ZNMnBnVkc4RUZvUUpTRGpUOXg3TWdMaTBH?=
 =?utf-8?B?cjY0ajZ0L2hTWVN6RnIxdWQrY28weUZFR2JLdm0xbzY4Znlkc0RDZmp4ZC82?=
 =?utf-8?B?eDdRUmZtblRpN01QUDE0aHc2SEthVmFLSkZPSjVhVWduS09HUWppbHB3Ujha?=
 =?utf-8?B?VXg1OGd4UEdNWkluaTNFU0Rna0RwVS8zWm1MejdycWcxb2o0N2xqZEVBdmRj?=
 =?utf-8?B?cmZJQk5qQzUzNVJjZDhpODdKblMwY29LdUdDNCtpYlQvZFFsemRsSE9sd01j?=
 =?utf-8?B?WTE4MmpUOWt0eWpNbnkwKzVKMDVxMmgxOTg0RGpIWDF4ZU54cE40TDBobTR4?=
 =?utf-8?B?N0NGVnluYXFlWHlyVVVkYnptQno3VkRVMm56anF1TldTaXZVWk1kMWxEOWZJ?=
 =?utf-8?B?ZW0xaDh0bDVLbkdMMlhuV0x3WkY2cWpSVnkxcG0rdEVtL2M1OFp1alhtVDNp?=
 =?utf-8?B?V3ZON0xyMWMvcjZKTXM1emI4TGsybmsvand0dlFyL3JIYkUraG0xNVhjcXVD?=
 =?utf-8?B?RkJib0U3T2E5akI3Z0xWWHdKUjVlWmg2RFl3WVVWTXhTMUhDcWtqUUNHb0ls?=
 =?utf-8?B?Q1N0MmdBdmQzZDYwMkY4NkpTZ3hpSTc3cWo4bGN0a2N6Yy9UbXBHcko4R08y?=
 =?utf-8?B?WVVVYmRXZWtYTkp1VG82Qmpld3R1Nk1oMWJJcWtDbi9zcWpaTmVVSDVjQkU4?=
 =?utf-8?B?UlBXMDVwVTNZd1RuSjltMXVrVmJXWlVwUDExc2R3TkZxUmZYT0U2Wk91SUhI?=
 =?utf-8?B?N3pJNmNxSnBXU3FpUmt1T2xzd2ZXSnp6MVlGN2RrOHNxay9PWVJUMGk2WllD?=
 =?utf-8?B?SmY0T3psSHJUamY0SzN3K0dBdW43alFxYmVaTGJmVXg2dFEwUm01WWlwK2N3?=
 =?utf-8?B?RHAvaFN0STV2TGw5WnpkaTkrNGdCVmZNb2ZyeVIvb2hJczdHUGY0NXlqUFZY?=
 =?utf-8?B?SXdJSElZcnVwbnljcmYwdDlBYU5XODEydjJ4MTN0V2tlR011d2VHMWtuRnF2?=
 =?utf-8?B?cFJwcVlYQWRwWUI3dHdZTTRxOXhiT1NYdGd6Zitrd1k1OUVoYW1POUpUb2Z0?=
 =?utf-8?B?RUViK0NodUlDaXFaVkR3Q0tNeWhEb3JVTGhRZThTTVQxOU1uOTJYcXllZGdZ?=
 =?utf-8?B?cERGaHNVNEc1MS9xcC9uOVB1Y2dra1hvc1E0aHlFWXJhVFlnK2QxTHJEZ05P?=
 =?utf-8?B?VFJtTHpvNW41em9SU1l5bXB1OU04WVFkZjlzWjFseEM4OThMWURzQnpSTE5i?=
 =?utf-8?B?Z21tSmlab1ZteGE4RDVmbDFGcURpSVYwNi92VXNrTS9CRnBkcUI2bVNnUUdy?=
 =?utf-8?B?a2xzdGd5d21BMld6VG5RbjZJekorUW5tNDFJM3V6eHBlZWI0Qnp3TDNsUmlv?=
 =?utf-8?B?REl5eWppZ2xwMFRBdmVobEpYTUc3L1B5TDdjQS9uMSttZTFNeWYwVDZiSksr?=
 =?utf-8?B?b0VicFlvWEZkVGwweGdTV1hmeW5iS3RlS0NnMkZiOUJNRUgvZUlITlR0aVhF?=
 =?utf-8?B?SUlNS203UWRhbkN2Z0JPZGx5L1VLNk9weGt2bllRcWF5REJaV1hoZ295SkZV?=
 =?utf-8?B?MHVYSTM0RElsKy8rSjFuM2VhdHRUZm9oelk4a0x5VFIzTjJTQ2YyWHAxMjVx?=
 =?utf-8?B?Y2ZTVlk1OUFGbUJSZ3lkb3k2Qkc4WWJOTWdybzdCcG1VSUdEUVBXQmV0YU9Y?=
 =?utf-8?B?S2tZcFg4bHgvcU83TDdkV0ZWTGFDZlMySDdjMlh2ZWhLamt6T3lNallKNjV6?=
 =?utf-8?B?Uk9GYWgrMzcvcHJQY2QwTk12VVlOK3Bxblk0QWdhQTlFQysrNm4xQmhLaXJ5?=
 =?utf-8?B?VCs5VTRkNC9mR2hnS1lpbk81ckxHMjBMSnFPemdlZEhxWWJaaEVYcDZqeUt2?=
 =?utf-8?B?TFk1RTZPZUhJVThuQVVhOTNXM1o4NG5ZV250MGJpNUhUVWhRdWovWXNneGRU?=
 =?utf-8?B?Sy9XZXF6TWlxZ3plREFVZTNVdVlJOG5YMEpab0xDOFIvTGVsQlZmWFJsc2Vv?=
 =?utf-8?B?b0xoOGJMSHJHS21jdFhKL3Vqb2xxTDU3bi95U0Fzenh1L0oweGZrek93SEt1?=
 =?utf-8?B?QW9ucXc1dWFhWnRSSGM4QU9SQit4Z3dwczBycStZMUljOCs4Z0tMQzBSMjRz?=
 =?utf-8?B?RUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C0540B23D10E8488321D7D7F272209F@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1EkVF7dG4lGvPpTWmx2vE8bNQQUzj3lV0sZY23Y9JH4aoRYHc3yzH+aiJS4rl8ECeQWVpo8duQMHn/Y6rNbx8VL+RGCVGqIaJQiDg4y8UseDMMcoWwTu/wX5X9LRgiuZvUfBpJ57FXLCfdYfyHABzoKqkuHePvuUGJZrKjPIh8RDb/GZX9jG+w4xUfz6Bjhxti2SNHDqTRW3csY2Za+XMak/QkhRy80T4m57YBnbTWzyWMZXD6R468LJXIy4CwSM2+/arBKEBWZwjSd0vcBMsKBuVicNgmOHgel57CqxQ9cOyr+zHEwtikNtpM8TQNh8EaeyP9qYCvy330EJZveRRnAjVz+kgi00LF0shC4D0csstqS9pT8KO4PIWgXioccNB4qBXEZZBca/x0h5yLozP8y0CQDclr5bSaKCxOFtAMnQlNHlGOykdDUeJd5FHcletdf4nkl8k7J9uH9l5N0OkE79wLmzkXz4bU0X3PbG1HaM7k9lkwTGPolnqLa7egQoGl5Jvvckivj7m16vCwtgS7AyApnW+Ylo6dr9xkgbsurzxXAsCE4jmtGTD5MIZQPykOsls7TSMxUU+4P05gkm3KOt6II0qEEYKpQeJNF6fZOA26AR22GtrSor3Mnn7pfFfwgpcnIl0k6gf6Nnc8UEnMTaVTHVItrccpEC/SLD/lgeuGIA1SDfY11oEsDMYJdOSKwPrm6Q3A7lrTPX0RtqihvkQVGk9lei4fmF3LtMP/VtdpGpo377ylmbLBDM/3zFpd605pCe4s9JyONJqaF9Bq1w9N9/lU4ReMr4cBQ8iF2yUS/FMaqHRyMMP27bN7GCNZkJJ4XWduufgsljJ3726OD+OSZwrJepqKiSbRhs96hLnElrXJvYc2sXaSkUSSVh
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB10390.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5476e527-12f9-4267-cb17-08dad3806c94
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 09:42:55.7155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nfKspiWIew4CDvdYL4CjnSQTC00aEyGYLKx8W6vD90niqAp9y35twwUxW82aWXxImn9hscEi5a8hLMUWCoPTVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB7997

DQoNCk9uIDAxLzEyLzIwMjIgMDQ6MDUsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gbGl6aGlqaWFu
QGZ1aml0c3UuY29tIHdyb3RlOg0KPj4gSGkgZm9sa3MsDQo+Pg0KPj4gSSdtIGdvaW5nIHRvIG1h
a2UgY3Jhc2ggY29yZWR1bXAgc3VwcG9ydCBwbWVtIHJlZ2lvbi4gU28NCj4+IEkgaGF2ZSBtb2Rp
ZmllZCBrZXhlYy10b29scyB0byBhZGQgcG1lbSByZWdpb24gdG8gUFRfTE9BRCBvZiB2bWNvcmUu
DQo+Pg0KPj4gQnV0IGl0IGZhaWxlZCBhdCBtYWtlZHVtcGZpbGUsIGxvZyBhcmUgYXMgZm9sbG93
aW5nOg0KPj4NCj4+IEluIG15IGVudmlyb25tZW50LCBpIGZvdW5kIHRoZSBsYXN0IDUxMiBwYWdl
cyBpbiBwbWVtIHJlZ2lvbiB3aWxsIGNhdXNlIHRoZSBlcnJvci4NCj4+DQo+PiBxZW11IGNvbW1h
bmRsaW5lOg0KPj4gICAgLW9iamVjdCBtZW1vcnktYmFja2VuZC1maWxlLGlkPW1lbW52ZGltbTAs
cHJlYWxsb2M9eWVzLG1lbS1wYXRoPS9yb290L3FlbXUtZGF4LmltZyxzaGFyZT15ZXMsc2l6ZT00
MjY3NzA0MzIwLGFsaWduPTIwOTcxNTINCj4+IC1kZXZpY2UgbnZkaW1tLG5vZGU9MCxsYWJlbC1z
aXplPTQxOTQzMDQsbWVtZGV2PW1lbW52ZGltbTAsaWQ9bnZkaW1tMCxzbG90PTANCj4+DQo+PiBu
ZGN0bCBpbmZvOg0KPj4gW3Jvb3RAcmRtYS1zZXJ2ZXIgfl0jIG5kY3RsIGxpc3QNCj4+IFsNCj4+
ICAgICB7DQo+PiAgICAgICAiZGV2IjoibmFtZXNwYWNlMC4wIiwNCj4+ICAgICAgICJtb2RlIjoi
ZGV2ZGF4IiwNCj4+ICAgICAgICJtYXAiOiJkZXYiLA0KPj4gICAgICAgInNpemUiOjQxMjcxOTUx
MzYsDQo+PiAgICAgICAidXVpZCI6ImY2ZmMxZTg2LWFjNWItNDhkOC05Y2RhLTQ4ODhhMzMxNThm
OSIsDQo+PiAgICAgICAiY2hhcmRldiI6ImRheDAuMCIsDQo+PiAgICAgICAiYWxpZ24iOjQwOTYN
Cj4+ICAgICB9DQo+PiBdDQo+PiBbcm9vdEByZG1hLXNlcnZlciB+XSMgbmRjdGwgbGlzdCAtaVJE
DQo+PiB7DQo+PiAgICAgImRpbW1zIjpbDQo+PiAgICAgICB7DQo+PiAgICAgICAgICJkZXYiOiJu
bWVtMCIsDQo+PiAgICAgICAgICJpZCI6Ijg2ODAtNTYzNDEyMDAiLA0KPj4gICAgICAgICAiaGFu
ZGxlIjoxLA0KPj4gICAgICAgICAicGh5c19pZCI6MA0KPj4gICAgICAgfQ0KPj4gICAgIF0sDQo+
PiAgICAgInJlZ2lvbnMiOlsNCj4+ICAgICAgIHsNCj4+ICAgICAgICAgImRldiI6InJlZ2lvbjAi
LA0KPj4gICAgICAgICAic2l6ZSI6NDI2MzUxMDAxNiwNCj4+ICAgICAgICAgImFsaWduIjoxNjc3
NzIxNiwNCj4+ICAgICAgICAgImF2YWlsYWJsZV9zaXplIjowLA0KPj4gICAgICAgICAibWF4X2F2
YWlsYWJsZV9leHRlbnQiOjAsDQo+PiAgICAgICAgICJ0eXBlIjoicG1lbSIsDQo+PiAgICAgICAg
ICJpc2V0X2lkIjoxMDI0ODE4NzEwNjQ0MDI3OCwNCj4+ICAgICAgICAgIm1hcHBpbmdzIjpbDQo+
PiAgICAgICAgICAgew0KPj4gICAgICAgICAgICAgImRpbW0iOiJubWVtMCIsDQo+PiAgICAgICAg
ICAgICAib2Zmc2V0IjowLA0KPj4gICAgICAgICAgICAgImxlbmd0aCI6NDI2MzUxMDAxNiwNCj4+
ICAgICAgICAgICAgICJwb3NpdGlvbiI6MA0KPj4gICAgICAgICAgIH0NCj4+ICAgICAgICAgXSwN
Cj4+ICAgICAgICAgInBlcnNpc3RlbmNlX2RvbWFpbiI6InVua25vd24iDQo+PiAgICAgICB9DQo+
PiAgICAgXQ0KPj4gfQ0KPj4NCj4+IGlvbWVtIGluZm86DQo+PiBbcm9vdEByZG1hLXNlcnZlciB+
XSMgY2F0IC9wcm9jL2lvbWVtICB8IGdyZXAgUGVyc2kNCj4+IDE0MDAwMDAwMC0yM2UxZmZmZmYg
OiBQZXJzaXN0ZW50IE1lbW9yeQ0KPj4NCj4+IG1ha2VkdW1wZmlsZSBpbmZvOg0KPj4gWyAgIDU3
LjIyOTExMF0ga2R1bXAuc2hbMjQwXTogbWVtX21hcFsgIDcxXSBmZmZmZWEwMDA4ZTAwMDAwICAg
ICAgICAgICAyMzgwMDAgICAgICAgICAgIDIzZTIwMA0KPj4NCj4+DQo+PiBGaXJzdGx5LCBpIHdv
bmRlciB0aGF0DQo+PiAxKSBtYWtlZHVtcGZpbGUgcmVhZCB0aGUgd2hvbGUgcmFuZ2Ugb2YgaW9t
ZW0oc2FtZSB3aXRoIHRoZSBQVF9MT0FEIG9mIHBtZW0pDQo+PiAyKSAxc3Qga2VybmVsIHNpZGUg
b25seSBzZXR1cCBtZW1fbWFwKHZtZW1tYXApIGZvciB0aGlzIG5hbWVzcGFjZSwgd2hpY2ggc2l6
ZSBpcyA1MTIgcGFnZXMgc21hbGxlciB0aGFuIGlvbWVtIGZvciBzb21lIHJlYXNvbnMuDQo+PiAz
KSBTaW5jZSB0aGVyZSBpcyBhbiBhbGlnbiBpbiBudmRpbW0gcmVnaW9uKDE2TWlCIGluIGFib3Zl
KSwgaSBhbHNvIGd1ZXNzIHRoZSBtYXhpbXVtIHNpemUgb2YgdGhlIHBtZW0gY2FuIHVzZWQgYnkg
dXNlciBzaG91bGQNCj4+IGJlIEFMSUdOKGlvbWVtLCAxME1pQiksIGFmdGVyIHRoaXMgYWxpZ25t
ZW50LCB0aGUgbGFzdCA1MTIgcGFnZXMgd2lsbCBiZSBkcm9wcGVkLiB0aGVuIGtlcm5lbCBvbmx5
IHNldHVwcyB2bWVtbWFwIGZvciB0aGlzDQo+PiByYW5nZS4gYnV0IGkgZGlkbid0IHNlZSBhbnkg
Y29kZSBkb2luZyBzdWNoIHRoaW5ncyBpbiBrZXJuZWwgc2lkZS4NCj4+DQo+PiBTbyBpZiB5b3Ug
Z3V5IGtub3cgdGhlIHJlYXNvbnMsIHBsZWFzZSBsZXQgbWUga25vdyA6KSwgYW55IGhpbnQvZmVl
ZGJhY2sgaXMgdmVyeSB3ZWxjb21lLg0KPiANCj4gVGhpcyBpcyBkdWUgdG8gdGhlIHJlZ2lvbiBh
bGlnbm1lbnQuDQo+IA0KPiAyNTIyYWZiODZhOGMgbGlibnZkaW1tL3JlZ2lvbjogSW50cm9kdWNl
IGFuICdhbGlnbicgYXR0cmlidXRlDQo+IA0KDQpEYW4sDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2gs
ICBUaGF0J3MgZXhhY3RseSB0aGUgcmVhc29uLg0KDQoNCg0KPiBJZiB5b3Ugd2FudCB0byB1c2Ug
dGhlIGZ1bGwgY2FwYWNpdHkgaXQgd291bGQgYmUgc29tZXRoaW5nIGxpa2UgdGhpcw0KPiAodW50
ZXN0ZWQsIGFuZCBtYXkgZGVzdHJveSBhbnkgZGF0YSBjdXJyZW50bHkgb24gdGhlIG5hbWVzcGFj
ZSk6DQo+IA0KPiBuZGN0bCBkZXN0cm95LW5hbWVzcGFjZSBuYW1lc3BhY2UwLjANCj4gZWNobyAk
KCgyPDwyMCkpID4gL3N5cy9idXMvbmQvZGV2aWNlcy9yZWdpb24wL2FsaWduDQo+IG5kY3RsIGNy
ZWF0ZS1uYW1lc3BhY2UgLW0gZGF4IC1hIDRrIC1NIG1lbQ0KPiANCg0KSXQgd29ya3MgZm9yIG1l
LCBidXQgdGhlIGFsaWdubWVudCB3aWxsIHJlc2V0IHRvIDE2TWlCIGFmdGVyIHJlYm9vdC4gSXMg
dGhpcyBleHBlY3RlZCA/DQoNCg0KVGhhbmtzDQpaaGlqaWFuDQoNCg0KPiBfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBrZXhlYyBtYWlsaW5nIGxpc3QN
Cj4ga2V4ZWNAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2tleGVj
