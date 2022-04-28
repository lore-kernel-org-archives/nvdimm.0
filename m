Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11olkn2084.outbound.protection.outlook.com [40.92.20.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1C410E5
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 14:54:38 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUKo5MEMVDs2u43GLFfgaeBginmIsSqzBcQc3paPqFSU3ocekPuCQrEOuHP3ZMB0LJZN7dPibP8vAvWOL/adFL+X4dotpM7qSjj1EumuV7tcwG47H85M+Isfgq6PLK9up93Q+ev/ZNl4A3yzcJIHEBbinFpxMjOxoFkSVmMJsVyVJ54LKrC6kiCn8QjhykeeAgk/eeKvRyd1RnyyHxcd351T0sQlwKji+H5brWLz2DvbysgqHj5KjCFhyEEQQ2i+IjSh2/yl3kTyknZPri4Hanbk5ID5qt2mzdrCB+X8CkjS7DgOJnmVIvSTof0izNi2C2a0P8WVxcoWmJYkUgEovA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3GrSYO/4wjyaEceQTBTv0+Pjq32yu6E19hKM4RucGxA=;
 b=BBsUUuOorPgC+JVHkudWoN4PGOMQW6N49LLdtp7z1mY7xAZlml2cfTqc2LEI8jCMrB8QvLBHImBs490yG0E7Sj1l8Plt8iWGkoQt1LgQCG5fW4SWY6cD4DwJck0mU8duKDpxWhbZfdPG6dSixyU/I2dJDZu7IZqxTSwRQiqObJ5LJaiSNGV45v5qKX50uo1LsUlOGPzJd1/joKGzXUsodU7KYRAlMgoz2QbL3Wt00Cf3Osl2wqdaNX9eQJkkWIF/tLQKzgdHLhwcmrqPFSFYuhC+MoMdzvxeVquf97ZhWNzfsyYLmw4YmkWRF5voTTTRoj5jXEhxuqYpF02VtgF/5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3GrSYO/4wjyaEceQTBTv0+Pjq32yu6E19hKM4RucGxA=;
 b=tI2/KeMcJeEquxH/QF85mPcnqMXJnoY6FiuDhiZqgFHN4HW6AvrcAd6ZS10+ddyizDxZzutTwVczdwU8qY1OIgdmJAqcRRNmgYUmvpr13R348lgNQceSSBCjylqjfjTGkOcG0e0FDEXiMb1qP91lU7iBDfS3O4iU1aAOuEqh7HM8Z2GC7oXNktjgSK1sKuytGPTtKB7kASEXrswI7Ip8O847WfEvpx3fNBz/7iP+xs9imA4BprrwTvTlNfiP+Hu5YgIyCzSYNCeczv/XKO5mat6AehlZx5jXKI+KD+IAMYIUYlJRBFoPaxfRaSawqBQTc7FHP5wfEX5gv+r38+JoZQ==
Received: from PH0PR18MB5071.namprd18.prod.outlook.com (2603:10b6:510:16b::15)
 by BY3PR18MB4643.namprd18.prod.outlook.com (2603:10b6:a03:3c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Thu, 28 Apr
 2022 14:54:36 +0000
Received: from PH0PR18MB5071.namprd18.prod.outlook.com
 ([fe80::cc99:a515:38e8:2f9e]) by PH0PR18MB5071.namprd18.prod.outlook.com
 ([fe80::cc99:a515:38e8:2f9e%5]) with mapi id 15.20.5186.021; Thu, 28 Apr 2022
 14:54:36 +0000
From: An Sarpal <ansrk2001@hotmail.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: RE: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
Thread-Topic: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
Thread-Index:
 AdhZr3Dz3peOUCWVT+66vwkDKQ0fFwABHpmAAAZzxpAAAwB5gAAo539gAAZROYAAHiJSwA==
Date: Thu, 28 Apr 2022 14:54:35 +0000
Message-ID:
 <PH0PR18MB507118DFC0FDE330EA68C677A9FD9@PH0PR18MB5071.namprd18.prod.outlook.com>
References:
 <PH0PR18MB50713BB676BBFCBAD8C1C05BA9FB9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4hGWAHBth+yF4DoEuyZN-O3-Tsfy4BU9PCyoTwaY-kKWw@mail.gmail.com>
 <PH0PR18MB50716D0F3A25CD25F8ED463BA9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4hnj8zeLqZWXRkhVUovFKR-sj5X=P5WM=vwXxjc7qL64w@mail.gmail.com>
 <PH0PR18MB507124A7660C21A147B30AE1A9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4gtnFQd46BH=Ng=3sL-yn9ctXrjwtThCFQ-AAo9DeO93A@mail.gmail.com>
In-Reply-To:
 <CAPcyv4gtnFQd46BH=Ng=3sL-yn9ctXrjwtThCFQ-AAo9DeO93A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [LdKGQ5qDPE1lq2Pe9FDXx8vFNHRpB5GM]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba3b202d-49dc-44bb-e4ee-08da2927032d
x-ms-traffictypediagnostic: BY3PR18MB4643:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 frA1QWYcjOJkpNERYPOeD0DFKQk4g2mqSFdP3iyI/4nLI/oXJ0UX6KpHLqoi0ZgmBpu7iKeDR+PG6AZsVKaG5UmuX2piugsfW+AhMNDbgqOEWcq7HqpzGJ4GzfxGtTVJYPx7RSJ8d/sU66CNQTRIDSnzyb0M9xGccoXSjBik7DvbYnC+/06hdDi7VjtOBFhIQxgtQcx/evV38E/UqoVk4pb/SAXpoEjujm55oCTv2n0GhIUGuC2dpr4sXE75N1cM3HKLWfcv+xAyVKK5ut2iJgl2iSmsTphbVDu5vfpkAUSYTQ7E3AhWkjUQs5PewKV/ubC+36uAh8gnOdQY22CCRmwIDX/OF5P9Xh2zFIm+ZCDegAxNZDGMIB6xe4PMaMhxqz33d+MDrFFS/361383wg+OMr9BGKBz1+3NtvNx/SUfcB9BGBty1WG7XWBh26Y6tfwIi5rrkPFBqH1OXTTH3BZ9Uvwo60YOAUX3E8nBhsVtJCYE9cYjnKZZEdOc65BoVbq8JDEevhyAHKR54gwMHwHXZx/AhuDxpU+mOEMOShsq1/RmSmwjbfrLb0L/h82M02ukC2E4w4z+TjeYy67MIMHG9OCiu6JxtEXO3mTsDtcfI76Lh+reIXGLcRp4kaP60
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?L2VJcTN2VmVldXlYNWdabkF3WUhlajltSUljdEJ5bnFtdXRaSlRRYzJZb3FB?=
 =?utf-8?B?MXdXSSt6L2hBOHArem9RczRrMmRZdHhqN0pRUjhMTHd0QmgvVi9xR1FWcnE3?=
 =?utf-8?B?ZVJoZGcvbloxc3VWallwR1VKUWhmdE5qYVpXZE93SnNlYXh6a2F5aEJTYmNX?=
 =?utf-8?B?eGF4TmwvdTViclQ2UnZvbmlKdC8vWWMxQlZOUVp3UGhtRk9JLzQ3SzR4K043?=
 =?utf-8?B?dmlCMDFJWjlTTWgvZUJvait6MDdMeU5QcXZ2Qm1sc2ZNOXJqR1B4K1QzbjQ2?=
 =?utf-8?B?QitUYUlpU0M4YWNqYm1UTGE3Ni93bnZhZkNxeVhWV1pocDVIdThQUWxpZW92?=
 =?utf-8?B?cHJaS21mS3RURGlJVW1pS1I5VFAycUZYWFRLdkJJazRBcEp4bFQ1bndRY0Y5?=
 =?utf-8?B?Vis3akIxb1F6WVJYVVZ2OXRMbHV0R3JHTFNYblhGbXRvQnc0RWlEU1F2RjVM?=
 =?utf-8?B?VytSS1lrRTlaN1B2djhFaFQwWk55ZWFxWCtIakttbDhoRS9vdG9waEkvcklN?=
 =?utf-8?B?bVVUVXMyYmZmMnMwUmsvUXRJaDZvQ2VWRkJJcFR3bW01bWxRUFBFSEN2cHRk?=
 =?utf-8?B?dW92dHhpWE04ZGlHdE16blhmYVRzTlVMM1kvRHl0N2JBWnViUEw0OU40MjFX?=
 =?utf-8?B?VldKS3Z5cy9SVkRDdFNxaG5RSjFESlFncncrUi9IWkIxaVZLdXEwbmh2ODZL?=
 =?utf-8?B?Z291eVRtVldqVHZ2ZHIxbFc2bDRHdjh4bElZdG5DS3E2U3Bmek5UOTUyRHBJ?=
 =?utf-8?B?bEpycHRTNXg3UytuTjIwTjc0empsRWQ5VkI1UXZFcUtKWVlsZ2VxSFBTVXV4?=
 =?utf-8?B?SHM2MjV1YlNDZllWRy9JbHZ3N1ZkYmQ5dTkzMHR1QTNuVzRIQjFGMzF1NEQy?=
 =?utf-8?B?aWVpczJyRDNhalpJWDc0U3ZldHRLeGZvN25mZXc5Yi9YdnltSUFmMnNIOTJm?=
 =?utf-8?B?Rm0wRVJaNzVDU1h4NzhxVEZnTC9WS3Y0RmRpMFVpQkpLRWFoNm1ZdXJoa0dM?=
 =?utf-8?B?d0RnL1R6WmtTRzJvT21ZcmhmTVBoRE8rczJvcmRKakxhY2UzL0NhSUpPWmtY?=
 =?utf-8?B?Q2RnK3V4VjR2bTdIUnlGSkFwU0pnMmJiT2pzTHZBbE1IT0xBVUxheUFRaEIz?=
 =?utf-8?B?cVVDZGtRRU85Vm93am9NQ3J6ZERKWS9xc2ZuREFBL2M3eGxVemFZR3Y2TkJV?=
 =?utf-8?B?VEJDT09pUUpieFZzVkNsaVU1VlFsbXNBbUl4STFnWk9EV0E5N05YWjhlQzlO?=
 =?utf-8?B?bTlqalhRTm5WZFdEVldEcXowbVZJaHg0L0UrUTZveWJyekx4Rzhpa2w5OG1i?=
 =?utf-8?B?cjVMcS8xQ29YTExmWTRMY2hqcVJoVzZSTW85YlV1UVRrZlpEZU9OcEhCbVBT?=
 =?utf-8?B?UE9Pc01Zb2VEVXlEcWlCOXFrNmg1cjdHNUxzSDV6K0c3OGNZVjVJYVVZMEpF?=
 =?utf-8?B?WXhBdGgxdVNNcVRYdmFaRWlRZEFkRXphU3I2cmV2Rkp0cXhsYW1US0Q5eDR2?=
 =?utf-8?B?dzI0d3Q2V095OWx2Q29MRndTZDdDNElVMFVNQjlzTXFnYXRMdE1uZysxSXZr?=
 =?utf-8?B?WlpOSzFMNzAvMW5PWnZiNmtnWCsvSGpaY1BrWFMrS3puT2JWRm9kRkc0eVVD?=
 =?utf-8?B?bEtOZExlcGdIckUrTWVXbk53TW1IRnBxWG5xeVJiM2F1Z1UvVnMxUEFPRkJ1?=
 =?utf-8?B?N040RUxSZXIrT0s1aU5PQ3ZMOExrUnhNTjAxZVR3ekZhalJma3p3TGJ5bXMz?=
 =?utf-8?B?am1QNjljQ2pyRmQ3ZGlCWUF2eHQ5eGMzc1Bkd09CZnNqbjRxVzNPSVR6Mm5I?=
 =?utf-8?B?TG1SMDBVc1ExSHJoUHJkNDg4cnEvZFpGQlFMeVJMWkxyNm1oemlWUnh5eXZJ?=
 =?utf-8?B?YUExL2ZKa3NvK0hnR0dRUndwVGl2NVRDUUN1ZTV1QUllUk1ZNlFPWXQ4SlRW?=
 =?utf-8?Q?qfoCWMpZbwY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-db494.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB5071.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: ba3b202d-49dc-44bb-e4ee-08da2927032d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 14:54:35.9680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR18MB4643

RGFuLCB0aGFuayB5b3UgZm9yIHRoZSByZXBseS4NCg0KSSBhbSBjdXJpb3VzIGhvdyBQQ0llIGF0
dGFjaGVkIFBNRU0gKEludGVsIE9wdGFuZSBtZW1vcnkgYXR0YWNoZWQgdG8gYSBQQ0llIDQuMCBk
ZXZpY2UpIHN1Y2ggYXMgaHR0cHM6Ly93d3cuc21hcnRtLmNvbS9wcm9kdWN0L2FkdmFuY2VkLW1l
bW9yeS9BSUMgd291bGQgYmUgc3VwcG9ydGVkIGluIHRoZSBMaW51eCBrZXJuZWwuDQpEbyB5b3Ug
a25vdyBpZiB0aGVyZSBpcyBuYXRpdmUgc3VwcG9ydCBpbiB0aGUgTGludXgga2VybmVsIGZvciB0
aGlzIHR5cGUgb2YgZGV2aWNlPy4NCklmIHNvLCB3b3VsZCB5b3UgYmUgYWJsZSB0byBwb2ludCBt
ZSB0byB3aGF0IG1vZHVsZXMgKG5kX3BtZW0ua28sIGNvbXBhdCwgZGV2aWNlX2RheC5rbykgd291
bGQgc3VwcG9ydCB0aGlzIHR5cGUgb2YgbWVtb3J5Py4NCg0KVGhhbmtzLA0KUksNCg0KLS0tLS1P
cmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNA
aW50ZWwuY29tPiANClNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMjcsIDIwMjIgNzoyNyBQTQ0KVG86
IEFuIFNhcnBhbCA8YW5zcmsyMDAxQGhvdG1haWwuY29tPg0KQ2M6IG52ZGltbUBsaXN0cy5saW51
eC5kZXYNClN1YmplY3Q6IFJlOiBIb3cgdG8gbWFwIG15IFBDSWUgbWVtb3J5IGFzIGEgZGV2ZGF4
IGRldmljZSAoL2Rldi9kYXhYLlkpDQoNCk9uIFdlZCwgQXByIDI3LCAyMDIyIGF0IDI6MzQgUE0g
QW4gU2FycGFsIDxhbnNyazIwMDFAaG90bWFpbC5jb20+IHdyb3RlOg0KPg0KPiBEYW4sIHRoYW5r
IHlvdSB2ZXJ5IG11Y2ggZm9yIHRoZSByZXBseS4gSSBhcHByZWNpYXRlIHlvdXIgdGltZSBvbiB0
aGlzLg0KPg0KPiBJIHRhbGtlZCB0byBteSBhcHBsaWNhdGlvbiBkZXZlbG9wZXIgYW5kIGhlIHNh
aWQgdGhhdCBoZSBjYW4gd29yayBhcm91bmQgdGhlIGxhY2sgb2YgY29oZXJlbmN5IHRoYXQgeW91
IGlkZW50aWZpZWQuDQoNCkJlc3Qgb2YgbHVjay4NCg0KPg0KPiBJIHdhcyB1bmRlciB0aGUgaW1w
cmVzc2lvbiB0aGF0IFBDSWUgbWVtb3J5IHBoeXNpY2FsIHJhbmdlcyB3ZXJlIGFsd2F5cyBtYXBw
ZWQgYXMgVUMgd2hpY2ggb2J2aW91c2x5IGltcGxpZXMgdGhhdCB0aGV5IGFyZSBub3QgY2FjaGVh
YmxlIGJ1dCBJIGd1ZXNzIEkgYW0gd3JvbmcgdGhlcmUuDQoNCk5vdCBpZiB5b3UgdXNlIG1lbW1h
cD0gdG8gaGFjayB0aGUgbWVtb3J5IG1hcCwgdGhhdCBpbnRlcmZhY2UgaXMgImdhcmJhZ2UgaW4g
LyBnYXJiYWdlIG91dCIgZnJvbSBhIHNhZmV0eSBwZXJzcGVjdGl2ZS4NCg0KPg0KPiBXaXRoIHRo
YXQgc2FpZCwgSSBzdGlsbCB3b3VsZCBsaWtlIHRvIGNyZWF0ZSBhIC9kZXYvZGF4WC5ZIGNoYXJh
Y3RlciBkZXZpY2UgdGhhdCB3b3VsZCBtYXAgdG8gdGhlIFBDSWUgQkFSIHJhbmdlLg0KPg0KPiBJ
IGFtIHVzaW5nIGRyaXZlci9kYXgvZGV2aWNlLmMgYXMgbXkgcHJvdG90eXBlLg0KPiBhKSBJIGFk
ZGVkIG1lbW1hcD1YQFkgdG8gdGhlIGtlcm5lbCBjb21tYW5kIGxpbmUuIFdoZW4gSSByZWJvb3Rl
ZCB0aGUga2VybmVsLCBJIHNlZSAvZGV2L3BtZW0wLiBTbyBmYXIgc28gZ29vZC4NCj4gICAgICAg
ICAgICAgICBOZGN0bCBsaXN0IHNob3dzIHRoaXMgbWVtb3J5IHdpdGggbmFtZXNwYWNlMC4wDQo+
IGIpIEkgdGhlbiByYW4gbmRjdGwgY3JlYXRlIG5hbWVzcGFjZSB3aXRoIC0tbW9kZT1kZXZkYXgg
dG8gY29udmVydCBmcm9tIGZzZGF4IHRvIGRldmRheCBhbmQgbm90aWNlZCB0aGF0IHRoZSBwcm9i
ZSgpIHJvdXRpbmUgaW4gZGV2aWNlLmMgd2FzIGludm9rZWQgYXMgSSBleHBlY3RlZC4NCj4NCj4g
Tm93IGluIG15IGRyaXZlciwgSSBvbmx5IGhhdmUgbXkgUENJZSBmdW5jdGlvbiBwcm9iZSgpIHJv
dXRpbmUuIEkgd2FzIHdvbmRlcmluZyBpZiB0aGVyZSBpcyBhbiBvYnZpb3VzIHdheSBmb3IgbWUg
dG8gbWFrZSB0aGlzIHdvcmsganVzdCBsaWtlIFBNRU0gKG1lbW1hcCkuDQoNCk5vLCB0aGUgb2Jz
Y3VyaXR5IG9mIEFQSXMgZm9yIHRoaXMgaXMgZGVsaWJlcmF0ZS4gSXQncyBicm9rZW4gb3V0c2lk
ZSBvZiBjb250cm9sbGVkIHNjZW5hcmlvcywgbm90IHNvbWV0aGluZyBMaW51eCB3aWxsIGV2ZXIg
c3VwcG9ydCBpbiB0aGUgZ2VuZXJhbCBjYXNlLiBTZWUgdGhlIENYTCBzcGVjaWZpY2F0aW9uIGZv
ciB0aGUgaGFyZHdhcmUgY2FwYWJpbGl0eSByZXF1aXJlZCB0byBzdXBwb3J0IG1lbW9yeSBvdmVy
IFBDSWUgZWxlY3RyaWNhbHMuDQoNCj4NCj4gVGhlcmUgaXMgYSBsb3Qgb2YgZnVuY3Rpb25hbGl0
eSBwcm92aWRlZCBpbiBvdGhlciBzb3VyY2UgZmlsZXMgb2YgZHJpdmVycy9kYXggYW5kIGl0IGFs
bCBzZWVtcyB0byBkZXBlbmQgb24gaGF2aW5nIHRoYXQgbmFtZXNwYWNlIGNyZWF0ZWQgYW5kIGxv
dHMgb2YgaW5pdGlhbGl6YXRpb24gYmVpbmcgZG9uZS4NCj4NCj4gSSB3YXMgd29uZGVyaW5nIGlm
IHRoZXJlIGlzIGFuIGVhc2llciB3YXkgZm9yIG1lIHRvIGF0dGFjaCBhIHN0cnVjdCANCj4gZGV2
X2RheCB0byBteSBvd24gcGNpZSBmdW5jdGlvbmFsaXR5LiBJdCBkb2VzIG5vdCBsb29rIGxpa2Ug
dGhlcmUgaXMgDQo+IGFuIGVhc3kgd2F5IGJ1dCB3YW50ZWQgdG8gY2hlY2sgd2l0aCB5b3UNCg0K
Q29ycmVjdCwgSSBkbyBub3QgaGF2ZSBhbnkgcmVjb21tZW5kYXRpb25zIHRvIG9mZmVyIGhlcmUu
DQo=
