Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11olkn2074.outbound.protection.outlook.com [40.92.19.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887CE621
	for <nvdimm@lists.linux.dev>; Wed, 27 Apr 2022 00:31:29 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkMbzVBUq3zYqg0EUDDOZc32H3gC1apZyjYwGHZEYRC1uOPygl5UNUM+fnvwt5W79KautuJEo4KeZTyBZk7nsvvpUwS6Ak4j3MW7FGo9axfI9fr/eaLClP2spc1UPK6VqeOqMXSpxQ8PI5OJBCACW7pe6vOta+bYXdblTuMDjs/8I6y088yQa9+4wK+f6WjsG2gpFAQQ8lZpbI4kocYQEmmc1yycgRy2AIPgnHkuND7lcfLSY2CivJHOYLO59m+6kNI83KfW9Y6wauFP340VjEVZOZ44pX1kpXQbO4YeOenjZL3vedVnWyqrGbEnkT0YhpsRoWT8DvrTgHmI+Z3BdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5T4d6NzCw8yzP0xA0qwoI0JkYBUQ61mTabyjVBO5F5Y=;
 b=gYpmYRdbrgIBFTyk4vdEW+uST+I+ReLdcMCnszLAuiQ+TR7H+Xsza7sPDjAFb5sJicMCHq9mCYYF7VNI+9Ad61vu4qJISJ//AWRGfhCUxfPEdEEa2gfLJx8+BgbxK1kvOeViW30mHm99O+gvAMM7z+oZepb6qvwOoA4Tmuhq529R12RB0TE4ZgnQQ1YVef4LO1NVDIDMDL9PvPrv6Me0uGrvNkYOUgbSl/ge2cYACO6HlXpSQu8aRXQyixbo2FD4lYGqAypIp4Iw/qFLLarqls8KIqExOG7Y0cuRxAw0tIBH/BWTxOmk6jLoYKUvCmy7alKFFzOTxarEZboVmM9d4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5T4d6NzCw8yzP0xA0qwoI0JkYBUQ61mTabyjVBO5F5Y=;
 b=V1sa1tYSot7Xhm10icmL7HyYjnVQFEZBPLww42kAZefNvvleqzm/+NhmnetC4zXTWD3LKuvuz7yWQ5bu4ab4wBh2fHHNjS0Jd6O6sSCoCRaS45bOJJJgT5T87xBSk0ovP9XsDV1k+45VtO8kCxc68urcPf9sVKYndkEK1bLoQSS2Ztn3Mg3YUbypsJi/Y3VtSWusfNuPV2J6XoPlczek9rdliPcaVa02QOZw045SiOiyEees702sjyV02oVWtAZqKwt2vnb5kwFyLiDCJFZUH1N9X5jn1gwB9k7wZ+CkiYdCD2RxUUBeukCjdwlKi465rNlpTaCECPXgdNWNac4lKg==
Received: from PH0PR18MB5071.namprd18.prod.outlook.com (2603:10b6:510:16b::15)
 by BYAPR18MB2615.namprd18.prod.outlook.com (2603:10b6:a03:139::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Wed, 27 Apr
 2022 00:31:27 +0000
Received: from PH0PR18MB5071.namprd18.prod.outlook.com
 ([fe80::cc99:a515:38e8:2f9e]) by PH0PR18MB5071.namprd18.prod.outlook.com
 ([fe80::cc99:a515:38e8:2f9e%5]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 00:31:27 +0000
From: An Sarpal <ansrk2001@hotmail.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: RE: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
Thread-Topic: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
Thread-Index: AdhZr3Dz3peOUCWVT+66vwkDKQ0fFwABHpmAAAZzxpA=
Date: Wed, 27 Apr 2022 00:31:27 +0000
Message-ID:
 <PH0PR18MB50716D0F3A25CD25F8ED463BA9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
References:
 <PH0PR18MB50713BB676BBFCBAD8C1C05BA9FB9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4hGWAHBth+yF4DoEuyZN-O3-Tsfy4BU9PCyoTwaY-kKWw@mail.gmail.com>
In-Reply-To:
 <CAPcyv4hGWAHBth+yF4DoEuyZN-O3-Tsfy4BU9PCyoTwaY-kKWw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [zJEpbZ8HII1ia1LgYBhyW4lDQVCfv23O]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 656952d5-a608-4d83-7f27-08da27e54461
x-ms-traffictypediagnostic: BYAPR18MB2615:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 B75Tnj59tD7JGoEK4N2mdKsdZWtAo5MYespeMd2kvEoiMdc3Bc3aav9jOVKxwqW53G9579/QRe78N2W1RLlpNiguj5SFY53iCWJH0fde0npOMwlYQzBLEh2r0Pf62QTMYLbUYAokkO4OL+KMv5OCC09axvo65ZQRPqMOhYEzyYC2x0XdjjMxGrv0Wm9xQ8vP3Wce22go5lO8B1S7tarB0nXp/hTYEkhg+zOH/HChiD7pT6XocXvqkX+KcEirZFeXSskn7nVFanX5y8yVyPxsbDnGxx4fXT3V9xgI3GloJd4o+UEn7oynkIiXezMLDMQOkiyfGUriZya81MhRKGbug1sYnJzNkLhJkM+vLgpknCMYzi3zt2jd7mDmnwH3vOZLMzkzJD9WlJbHRhi61befqLwVmrebUXm9gxg7XHkxrSm1OTH/zrjjP/any9pnwA9WSUR1mnIMi6LUmqtVrD2+cuIoqw76JEdmX97VgXrhS5VnNNBld3icyrxehwH8URYVawi0ckf8RABw8Tm6UeBZ3jfHml72e29egE5rM4a36jqpA3dsx03m7sytguRInb++unswN54VXahdCvsDcmiauA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?blExS0pQbHAvL0t1S2lnN1U2a2JubnJLSU5DM3J6ZjBHa21MS1oya2lUemkr?=
 =?utf-8?B?ck5WT0hlMG1JZmxvdWFXRDlhQnlxM1VmRkVHOStvZmJaczRvMWV2RXJSWjND?=
 =?utf-8?B?bzgrSVJXcFFhME5NKzBUaTVrYS8wVFFmOXk0TGhTbGxseldFNW5JVmdsRDhQ?=
 =?utf-8?B?R3N0SGNpalU0bnlJTUZkQUxuWmRwYUs4K2RiazZhdmRuUG5LTUV3SGZwamRM?=
 =?utf-8?B?RDEzMDEzdmwvb0VtM29hT2Z0Y2lBZC9UVEt4WDVURGE3QytnbE1PZlRmdHhl?=
 =?utf-8?B?OC9KdHhXMG51Y3JEZUNTSUxtNHlDNDUvcDd2RDkwaXhyN09oMlJ4SDdrWWN1?=
 =?utf-8?B?QUhudjU2UkszK1RDSnJHTEs1RlZlOVE2ZDA5QWNUdjVHYllLZVg0dm01WE1z?=
 =?utf-8?B?ZDlOZUJWTUZhek1iQldMYzBuWlVVb3NpUlZJakxxb3hJV3NUTmo5WUdOcWZG?=
 =?utf-8?B?b0prUDNUcTJkSWFxMzN2MVBsUzZTdUNKOHIxWm5NYzBzRC9VbUE1MThQVjJn?=
 =?utf-8?B?a1NkbU90emR3VVRWTzh6TXhRd21lL2xZL2tXL0pDQXVtV2ZFaGVyZmIveFhW?=
 =?utf-8?B?bXdVN21BUGpVVGh6b0dxMjM1TW5wVXIwakE5S25ZTFRUandTWm90ZW1NVmZH?=
 =?utf-8?B?SEx2WHIyT2tBZDIzTmhlUERQMXkvZ0dRRUlkdGttZDhScWI0a2ErK1Z5UXJ4?=
 =?utf-8?B?VXh6VEVQNnVWYndpN1NsMDQvRXpFVkJUS01nbWlYOXRWVk11L0RFNGhxeWlv?=
 =?utf-8?B?Q0prSFdQVDg4a2RwYitZTjR5dlVrTE5odkRlZlVrakZKTFlHQ0U4L3M2U3Ro?=
 =?utf-8?B?RXRiMHFQYWlGSFdFMTczVitseVhqZy9mZ3VhdEdWNDZPNVJkOFVlRFl0TlJP?=
 =?utf-8?B?TXVBQXlVd3lzZWhyVDZPcENwM2pVbTdQS3ZwT1NEQ1I1SW1menB6bVNxS0xB?=
 =?utf-8?B?cE1McEFiZXZDWmxUTXZiOGFabVc1U2V4NjY4MjBHUktVODVPL1ZGTDlFV1E2?=
 =?utf-8?B?TFdMMkQ2ZGsxOGpMWFFDWTFldlowUmdkM0ZJZThDNlIxMk1Sb1ZRamdndml5?=
 =?utf-8?B?cmRJTGM1U1h4Ni9rRUx6NVdFcDVLdklBRFVNd3RnTERDdnBSdXlQNkRkRHVz?=
 =?utf-8?B?U0g3M25Gdm5sWVp3TkhJc3d5MUFWQmdDeDVVd3JvZmxURVkvOEhHL3hJQ3R3?=
 =?utf-8?B?QzUwbVEzV28veXExaTQ0cyt0Sjd6S20yVlJ3dnFLUVpFK3NGZXA3T0gwM3JG?=
 =?utf-8?B?Z3dTSkROV0hZeXlydXRnbzV3OUk5a0l1Wit0M3pWRFYwdGd0eVdldXBxNFlN?=
 =?utf-8?B?RHRwZnRiK2IrTDZQelI3OXJPQVVXMVR0bllwdDViRlM3RWNsZyt1aTYrYUFL?=
 =?utf-8?B?aGE3dllJQktPbVVjN2ROOHV5VFhzREpaT3h2OGtVeld2VDlmako1RHVWbUp0?=
 =?utf-8?B?Y21WM1RkZHNMV2I2RXpSRVNHWXlZbGYyeUo0MDh5WVlrS1o1cGNKWDdOYVJr?=
 =?utf-8?B?WE5JMU0xVjA4dnhDYzg0dnkzZmFzZ1NTRG9FUHJHekg0U3RyNVhYOUsxMitU?=
 =?utf-8?B?Mmt0M1Q1S1UyUzNsekN3T3E2blZiWnA5MGVjN1NGUUUydGMwUnAzTzJqTkhs?=
 =?utf-8?B?T2w1THZicVMyTFBkSHNTSXpBK0ZyTU1hSWdWY2VDczNxS2VhWEJLcENMdW5E?=
 =?utf-8?B?N0tRZStCalkwcVZNMHp3K1ZBWEwrcU8xdVpjd2ErT2dYTUJVeXNIVE9ld2Np?=
 =?utf-8?B?dkJaZVRuSTVSQlc4eU5XNERCaExtVFQ3ejJ3TVFsWmpvSnJEaGx4K1RSdXRO?=
 =?utf-8?B?c0RLSFdqMjkrZ0tPNDNlR1VoWFluM3Y2Vk1WVTN6K1ZqdVNlWUlueDNNVzhV?=
 =?utf-8?B?RnhBNzR1eTdQUnEzMXRPOTJXZEhqZytySmplbHo5cUhsdzFKUmczZ3lCb0hy?=
 =?utf-8?Q?u1JE44h7wFU=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 656952d5-a608-4d83-7f27-08da27e54461
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 00:31:27.4112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2615

RGFuLCB0aGFuayB5b3UuDQoNClllcyB0aGF0IGlzIHRydWUgYnV0IFBDSWUgbWVtb3J5IChhc3N1
bWluZyBhIFBDSWUgQkFSIGlzIGJhY2tlZCBieSByZWFsIG1lbW9yeSBhbmQgbm90IGp1c3QgcmVn
aXN0ZXJzKSBuZXZlciBwYXJ0aWNpcGF0ZWQgaW4gY2FjaGUgY29oZXJlbmNlIGFueXdheXMuDQpT
byBhc3N1bWluZyBteSBhcHBsaWNhdGlvbnMgdXNpbmcgL2Rldi9kYXgwLjAgY2hhcmFjdGVyIGRl
dmljZSB3ZXJlIGF3YXJlIG9mIHRoaXMgZmVhdHVyZSAob3IgbGFjayBvZiBpdCksIHdvdWxkIHRo
aXMgaW1wbGVtZW50YXRpb24gYmUgdGhlIGNvcnJlY3Qgd2F5IHRvIGRvIGl0Pw0KDQpUaGFua3Ms
DQpBbmVlc2hTDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBEYW4gV2lsbGlh
bXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4gDQpTZW50OiBUdWVzZGF5LCBBcHJpbCAyNiwg
MjAyMiA0OjI0IFBNDQpUbzogQW4gU2FycGFsIDxhbnNyazIwMDFAaG90bWFpbC5jb20+DQpDYzog
bnZkaW1tQGxpc3RzLmxpbnV4LmRldg0KU3ViamVjdDogUmU6IEhvdyB0byBtYXAgbXkgUENJZSBt
ZW1vcnkgYXMgYSBkZXZkYXggZGV2aWNlICgvZGV2L2RheFguWSkNCg0KT24gVHVlLCBBcHIgMjYs
IDIwMjIgYXQgMTo1OCBQTSBBbiBTYXJwYWwgPGFuc3JrMjAwMUBob3RtYWlsLmNvbT4gd3JvdGU6
DQo+DQo+IEkgaGF2ZSBhIFBDSWUgRlBHQSBkZXZpY2UgKHNpbmdsZSBmdW5jdGlvbikgdGhhdCBo
YXMgYSAyR0IgUkFNIG1hcHBlZCB2aWEgYSBzaW5nbGUgNjQtYml0IFBDSWUgQkFSIG9mIGxlbmd0
aCAyR0IuDQo+DQo+IEkgd291bGQgbGlrZSB0byBtYWtlIHRoaXMgbWVtb3J5IGF2YWlsYWJsZSBh
cyAvZGV2L2RheFguWSBjaGFyYWN0ZXIgZGV2aWNlIHNvIHNvbWUgYXBwbGljYXRpb25zIHRoYXQg
SSBhbHJlYWR5IGhhdmUgdGhhdCB3b3JrIHdpdGggdGhlc2UgY2hhcmFjdGVyIGRldmljZXMgY2Fu
IGJlIHVzZWQuDQo+DQo+IEkgYW0gdGhpbmtpbmcgb2YgbW9kaWZ5aW5nIGRyaXZlcnMvZGF4L2Rl
dmljZS5jIGZvciBteSBpbXBsZW1lbnRhdGlvbi4NCj4NCj4gVG8gdGVzdCBkcml2ZXJzL2RheC9k
ZXZpY2UuYywgSSBhZGRlZCBtZW1tYXAgdG8gbXkga2VybmVsIGNvbW1hbmQgbGluZSBhbmQgcmVi
b290ZWQuIEkgbm90aWNlZCBJIGhhdmUgL2Rldi9wbWVtMCBvZiB0aGUgc2FtZSBsZW5ndGggc2hv
dyB1cC4gbmRjdGwgc2hvd3MgdGhpcyBkZXZpY2UuIFRoaXMgaXMgb2J2aW91c2x5IG9mIHR5cGUg
ZnNkYXguDQo+IEkgdGhlbiByYW4gbmRjdGwgY3JlYXRlLW5hbWVzcGFjZSAtbWVtPWRldmRheCBv
biB0aGlzIGRldmljZSB3aGljaCBjb252ZXJ0ZWQgaXQgdG8gL2Rldi9kYXhYLlkuDQo+DQo+IFdo
ZW4gSSByYW4gbmRjdGwgdGhhdCBjb252ZXJ0ZWQgZnJvbSBmc2RheCB0byBkZXZkYXgsIEkgbm90
aWNlZCB0aGF0IHRoZSBwcm9iZSByb3V0aW5lIHdhcyBjYWxsZWQgd2l0aCB0aGUgYmFzZSBhbmQg
bGVuZ3RoIGFzIGV4cGVjdGVkLg0KPg0KPiBTbyBJIGFtIGhvcGluZyB1c2luZyBkcml2ZXJzL2Rh
eC9kZXZpY2UuYyBpcyB0aGUgYmVzdCB3YXkgdG8gZ28gdG8gZXhwb3NlIG15IFBDSWUgbWVtb3J5
IGFzIC9kZXYvZGF4WC5ZLg0KDQpUaGF0IHdpbGwgZ2l2ZSB0aGUgKmFwcGVhcmFuY2UqIHRoYXQg
YSBQQ0kgQkFSIGlzIGFjdGluZyBhcyBtZW1vcnksIGJ1dCBpdCB3aWxsIGJyZWFrIGluIHN1YnRs
ZSBhbmQgdW5wcmVkaWN0YWJsZSB3YXlzIGR1ZSB0byB0aGUgbGFjayBvZiBjYWNoZSBjb2hlcmVu
Y2UgZm9yIFBDSSBtZW1vcnkuIFNvIHRoZXJlIGlzIG5vIHdheSB0byBzYWZlbHkgZXhwb3NlIFBD
SWUgbWVtb3J5IGFzIGdlbmVyYWwgIlN5c3RlbSBSQU0iIGxpa2Ugb3RoZXIgRERSLg0K
