Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11olkn2092.outbound.protection.outlook.com [40.92.20.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0860E2F4D
	for <nvdimm@lists.linux.dev>; Wed, 27 Apr 2022 21:34:31 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXJ/LAF0KF1GQpkmDiTNyRRo5TvpzY4QGNo/mvJo8ioGUxsSRqnh4nfiAKgXRMuHhH1MTkIXPbDHYg/LQPu50e46ebGAnAZsOdssv9IL8wf7uiKmGFxEGxKgWq9WnW3bFIoMmZD1hcOyXAEtUwnRgOYxgtwxD+7sEdw016J5a1MwNvNpsVP0oU7DnMStTSTvC6h7FgR0hoMwOXI+vAMsoVKSQd0nz+3FVIkXwqDeMAZ9JsFsjqXW4QhHj9+dav2YEdE0z2lS+vXsYCafh41kZArRwa6meUVCTsBVba6do2cB0/dkNv4yuoMJ76ePAPD/DK7dtin7b9fxVdFBwFgD8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJ8UFJu6Fl9QiKa9928xfb4KBwSqg1CxPX2LP3jUiko=;
 b=hC3TJje21U2YHNemXMO/NOnNVjPdPcUv8NF0q6ZQ1LHhRbYdvAWSHQO1JYR7PDR2TcoLYkM8QPhjW+4fNZSrvNXkuQARSF/3KyzcTbp9h8GkiqhZ9Km8ofm0q3YO6EXTmfh2jgJDBkO2PlyEkkzheZTYNzxyRcGgKa+No6hm+TVv5pe+pdVt/nGEbiQvjwWelhiOUfIQdCs5aVypfO9kDLJRVjANk1n0+7rYUsbft0A4uWiJ3KuIWfziv0FbfccObezAsNupnDIk+OHYVAhL1yav5SuuLpoc5cSXvgL53kSmfvArt/zxPQOHxd+QFwI9ReOPz2EfRzv14A4XCFQjsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJ8UFJu6Fl9QiKa9928xfb4KBwSqg1CxPX2LP3jUiko=;
 b=bS1CWoDnPexzXYXBVUKX4WkG4DNWgMknRlBjH2ZvNaziFU2zOz8Eec4yNsdsJfcF/d2cjC+AlVwXM0xlUeHw2AXkSuZlfdE/ICEm1GvCiO6P1DEHC/C+V7quDYL/hWqZQrmQAOS/VKDjKWxWL6umCYgIBTpaJdoteq7AKW8EqYqFaa60ikgquqmyj6kkMqbBNMT0L3P1u+wMtxVCNIPgFov1jnlWJHCtgwULzXlKltM00fyekImUOowlz0oCjAt/qeqrpHpf+7/V4MeDy2H7gLueA41Ta5GfoUmbQ5SQ7GHNJxXa2cpBqmJ72WnArnb49nru/pkj7dKqMue20zIm4w==
Received: from PH0PR18MB5071.namprd18.prod.outlook.com (2603:10b6:510:16b::15)
 by DM6PR18MB3099.namprd18.prod.outlook.com (2603:10b6:5:1ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Wed, 27 Apr
 2022 21:34:29 +0000
Received: from PH0PR18MB5071.namprd18.prod.outlook.com
 ([fe80::cc99:a515:38e8:2f9e]) by PH0PR18MB5071.namprd18.prod.outlook.com
 ([fe80::cc99:a515:38e8:2f9e%5]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 21:34:29 +0000
From: An Sarpal <ansrk2001@hotmail.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: RE: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
Thread-Topic: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
Thread-Index: AdhZr3Dz3peOUCWVT+66vwkDKQ0fFwABHpmAAAZzxpAAAwB5gAAo539g
Date: Wed, 27 Apr 2022 21:34:29 +0000
Message-ID:
 <PH0PR18MB507124A7660C21A147B30AE1A9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
References:
 <PH0PR18MB50713BB676BBFCBAD8C1C05BA9FB9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4hGWAHBth+yF4DoEuyZN-O3-Tsfy4BU9PCyoTwaY-kKWw@mail.gmail.com>
 <PH0PR18MB50716D0F3A25CD25F8ED463BA9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4hnj8zeLqZWXRkhVUovFKR-sj5X=P5WM=vwXxjc7qL64w@mail.gmail.com>
In-Reply-To:
 <CAPcyv4hnj8zeLqZWXRkhVUovFKR-sj5X=P5WM=vwXxjc7qL64w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [Rid4Hpeej40hgbYYY0ljsfR+EDMfxOjq]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5af69fdb-7041-452f-3cb0-08da2895b62f
x-ms-traffictypediagnostic: DM6PR18MB3099:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 wTI5B/9IyuDdfa0azhxdBp5D+L+8sxAY2AFQeVfTe7vOYUKZ6l7qV0Bl62O1dnYHKjPB7JdkpS/kiirPNFzrNUtyz93xATxDrIAvJTdzn+DcalyZ+jV+9qo+eKhmHnHGqDQMLwL4XtBlftQrsh7spClKQqGcYwF08m8zV3e+gB6J9quCiEdG2H8umV34UwN+fN+dyelHuuApUcz6eanZdVPkin/CYcZLpKU174CCgj1YBIkXeWfyd30Lz25dnND6x5DyGZT/ROALhEhY46+4mRD5MGEz0XcWYTunLGjSu/0gq4du4XmVRqJfdD7YcovWCBAl81Ms5HLDxU+qjrH6kS9BcudAfPJusAyYeqLMV8MZl1ubnHCCiPLjFuF6jrXerliy3UTZBegnJfNmh/0D+6RvVi+D8wCeIkjYRkP7IHtuC0kQVBRsHK3oqgxW3T9wMuvpZWaTlDV1vMV0IrY0hiZMgCrkFgc4madg3qiRYnOn9lZdg6HpclVRFHlilH3Qb173n9KxHofWFAFk1F5jyqAcFNpGRaPWZokwki3JvKveHq3CysUmZmeeCHogG++cYsPS6feARU5PLxIWR2++xA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cnhtUFZWbUlxdmkyWFpXdzlKSlk4aUhFTlA5OFZlT3p1R3QxVEFwTGpqZ1dK?=
 =?utf-8?B?bGVMT1dDWXRFSXlteEZPc3NTcmQ1SWsxeWYzclhDbEpWQ3lsaHpwTlAzcVZw?=
 =?utf-8?B?b0xIVTVkMkplTHpydTJ0bHV3R0JBVHV6K1Yxbm8rT3BCRmZSdEozekVtMldi?=
 =?utf-8?B?dFk1TDVQUTlZL1o4Y0FyUVo5ekdIa1R1R25ZZzd5SThsK09kTkliK0FFMWpH?=
 =?utf-8?B?cWZDUE10bm4rVUJSL25XWjJoc1NUWUlpZ3F4VWxGQk82K2MydmxuQXpNUGNB?=
 =?utf-8?B?VllRY01SS3ZsTHdOVUY1U1FhTzZQMml4YWN6dlNZdm5aUnZ0Y2NDT1orMitX?=
 =?utf-8?B?b0FzRTBCMjloODFmWmhyZ2pCK0NycU0ySzJKODFvK1hlZmMwWXQxdmJvRUE3?=
 =?utf-8?B?a2JydURSb3ZvSTg4ZC9tK1pLTVduZjI0RUtDbDZDRlBXUHhGQ0h4aXFJSkt4?=
 =?utf-8?B?TzBWcDd3YXhwYUZ1anVzT1R5UVBidUtTSUxJRmJCemdnREJDdGM5cTh3Y3Ji?=
 =?utf-8?B?K1duRG51UTBSYVY4Z2xqS1ZFV1NaQ2J5ck5OUW1jSTNqNVQ0RENaa3hxd1dN?=
 =?utf-8?B?eDdTVS85QndYNGlHVTJvWEVBV0JxY0duMXNwM3kxS3ZsV0tmYnlPUFBHaDQw?=
 =?utf-8?B?NUk0YmdUSW5Gd1JKaFVZRzlnK1ZWWTdLc2x0eFJyN1dCS014K3BWdUM1eHRr?=
 =?utf-8?B?MzFVcXc3bDZkU0RyOUE5MzZ0TExaU1ZCZytHZXp2WHhoQlNjNHhrZU9MNGdr?=
 =?utf-8?B?elltQWpVSFpwdVNtN1d6MExxUHVoZktxb1pVUHV5d1d1RGsvcGhhdHRrM296?=
 =?utf-8?B?QlBFQlE5NkY5OEUzZVhxRHpBSThnRDVFVWxIb0NNTmlELzNXUnd2b1hCa0JL?=
 =?utf-8?B?MFIyQkV2TzRuVHRFeXA1cW5Hd25UZDhUSUVLNUNySGRyVEYxYU5ORnlxSDdV?=
 =?utf-8?B?OTJYOUcza2I4UG5wUVQ1K05yd2hkbE1pcWRUSmlVVHRoKzRMN2xNR0E3RHhv?=
 =?utf-8?B?TmNiSEFEZ2Z4Uk9pUU5YdDJ2NFNxL0xzNU9KL2VoRHdZaDRINHlLTVd3U2Va?=
 =?utf-8?B?TzBkZDU5ZlVGUXlhQUJsZE9VeXY5YkY1Z0VWOUJpOENDaWpnU0ptSVVOZDB1?=
 =?utf-8?B?RlVUVEtuaHVqZFdSR0xXUzNWZlZTa20rUElZRlBSU0JObVlNNHBYOFc4S1NF?=
 =?utf-8?B?RHNJTUh5SU56ZWt2YXptQmZEZUVBNnJGdU5qSE8yeHBvVEhLVkVkYjJuVU5v?=
 =?utf-8?B?dS9OTzNOYXNKeDB3OU4xNHVwTTByZmwrQ1ozclhuWTI2NzFmV3NmbWVUaUpj?=
 =?utf-8?B?Q0VSRzJ4bzl5a0o2Ump3VFd5UVRhMkRaSlRLMmZ0TCtiYU5nVFBEN0VDS1I2?=
 =?utf-8?B?dXhBbEZ1NktxbGYxR3cyd1ZmSDMyZStuUWNWdHJ3WHN0Y1RUVXVXQVVObWF1?=
 =?utf-8?B?SWtJeDBzaUhiK204QW9Nc2dZKzhUdXA1Y0U0OUtTNzAyVDF2d2hTYnNnUFhh?=
 =?utf-8?B?cFdVeXZVNzZBWi9tKzJvcnVZQ2F0aS9oVktYbC9ZUWRRSTBibnRVaGxkemEx?=
 =?utf-8?B?a2lGT1FiendBdTBLdDdLb1JsNmpHSStGWWxKQ2JTT3hUUnlWaGo2SFdnb3pO?=
 =?utf-8?B?THNvRkhobzBnbDRnc1NIL0h5ajJ3L1ZhVWVJR3JZWnRkTkFJWmNMVFA2NVZh?=
 =?utf-8?B?ODR1by9aSDYxdm44VW9zQW5aSkMyNUF0U0lmSUJTOHRCUW5PR2tFTE1HS2sv?=
 =?utf-8?B?WEZaaHFQdGNOMWd3bjFwaTRoU2hQMmkvSXN6WUxUS1lLQ3RvNTVnRG1hcnlj?=
 =?utf-8?B?eFAyRk5uMUptVDlBV0xUN0lwbWxsbkZMYUpHZTdHS25ZK1FDYXRxLzczcHh1?=
 =?utf-8?B?N1FjR2lvKzJENUFNUTZkLzZmUmduZzJyNERRNS9xZnZFMUszdlV0ZVhBbkwx?=
 =?utf-8?Q?/6O6+xCWTRA=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af69fdb-7041-452f-3cb0-08da2895b62f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 21:34:29.7821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3099

RGFuLCB0aGFuayB5b3UgdmVyeSBtdWNoIGZvciB0aGUgcmVwbHkuIEkgYXBwcmVjaWF0ZSB5b3Vy
IHRpbWUgb24gdGhpcy4NCg0KSSB0YWxrZWQgdG8gbXkgYXBwbGljYXRpb24gZGV2ZWxvcGVyIGFu
ZCBoZSBzYWlkIHRoYXQgaGUgY2FuIHdvcmsgYXJvdW5kIHRoZSBsYWNrIG9mIGNvaGVyZW5jeSB0
aGF0IHlvdSBpZGVudGlmaWVkLg0KDQpJIHdhcyB1bmRlciB0aGUgaW1wcmVzc2lvbiB0aGF0IFBD
SWUgbWVtb3J5IHBoeXNpY2FsIHJhbmdlcyB3ZXJlIGFsd2F5cyBtYXBwZWQgYXMgVUMgd2hpY2gg
b2J2aW91c2x5IGltcGxpZXMgdGhhdCB0aGV5IGFyZSBub3QgY2FjaGVhYmxlIGJ1dCBJIGd1ZXNz
IEkgYW0gd3JvbmcgdGhlcmUuDQoNCldpdGggdGhhdCBzYWlkLCBJIHN0aWxsIHdvdWxkIGxpa2Ug
dG8gY3JlYXRlIGEgL2Rldi9kYXhYLlkgY2hhcmFjdGVyIGRldmljZSB0aGF0IHdvdWxkIG1hcCB0
byB0aGUgUENJZSBCQVIgcmFuZ2UuDQoNCkkgYW0gdXNpbmcgZHJpdmVyL2RheC9kZXZpY2UuYyBh
cyBteSBwcm90b3R5cGUuDQphKSBJIGFkZGVkIG1lbW1hcD1YQFkgdG8gdGhlIGtlcm5lbCBjb21t
YW5kIGxpbmUuIFdoZW4gSSByZWJvb3RlZCB0aGUga2VybmVsLCBJIHNlZSAvZGV2L3BtZW0wLiBT
byBmYXIgc28gZ29vZC4NCiAgICAgICAgICAgICAgTmRjdGwgbGlzdCBzaG93cyB0aGlzIG1lbW9y
eSB3aXRoIG5hbWVzcGFjZTAuMA0KYikgSSB0aGVuIHJhbiBuZGN0bCBjcmVhdGUgbmFtZXNwYWNl
IHdpdGggLS1tb2RlPWRldmRheCB0byBjb252ZXJ0IGZyb20gZnNkYXggdG8gZGV2ZGF4IGFuZCBu
b3RpY2VkIHRoYXQgdGhlIHByb2JlKCkgcm91dGluZSBpbiBkZXZpY2UuYyB3YXMgaW52b2tlZCBh
cyBJIGV4cGVjdGVkLg0KDQpOb3cgaW4gbXkgZHJpdmVyLCBJIG9ubHkgaGF2ZSBteSBQQ0llIGZ1
bmN0aW9uIHByb2JlKCkgcm91dGluZS4gSSB3YXMgd29uZGVyaW5nIGlmIHRoZXJlIGlzIGFuIG9i
dmlvdXMgd2F5IGZvciBtZSB0byBtYWtlIHRoaXMgd29yayBqdXN0IGxpa2UgUE1FTSAobWVtbWFw
KS4NCg0KVGhlcmUgaXMgYSBsb3Qgb2YgZnVuY3Rpb25hbGl0eSBwcm92aWRlZCBpbiBvdGhlciBz
b3VyY2UgZmlsZXMgb2YgZHJpdmVycy9kYXggYW5kIGl0IGFsbCBzZWVtcyB0byBkZXBlbmQgb24g
aGF2aW5nIHRoYXQgbmFtZXNwYWNlIGNyZWF0ZWQgYW5kIGxvdHMgb2YgaW5pdGlhbGl6YXRpb24g
YmVpbmcgZG9uZS4NCg0KSSB3YXMgd29uZGVyaW5nIGlmIHRoZXJlIGlzIGFuIGVhc2llciB3YXkg
Zm9yIG1lIHRvIGF0dGFjaCBhIHN0cnVjdCBkZXZfZGF4IHRvIG15IG93biBwY2llIGZ1bmN0aW9u
YWxpdHkuIEl0IGRvZXMgbm90IGxvb2sgbGlrZSB0aGVyZSBpcyBhbiBlYXN5IHdheSBidXQgd2Fu
dGVkIHRvIGNoZWNrIHdpdGggeW91DQoNCg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
RnJvbTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+IA0KU2VudDogVHVl
c2RheSwgQXByaWwgMjYsIDIwMjIgODo1NSBQTQ0KVG86IEFuIFNhcnBhbCA8YW5zcmsyMDAxQGhv
dG1haWwuY29tPg0KQ2M6IG52ZGltbUBsaXN0cy5saW51eC5kZXYNClN1YmplY3Q6IFJlOiBIb3cg
dG8gbWFwIG15IFBDSWUgbWVtb3J5IGFzIGEgZGV2ZGF4IGRldmljZSAoL2Rldi9kYXhYLlkpDQoN
Ck9uIFR1ZSwgQXByIDI2LCAyMDIyIGF0IDU6MzEgUE0gQW4gU2FycGFsIDxhbnNyazIwMDFAaG90
bWFpbC5jb20+IHdyb3RlOg0KPg0KPiBEYW4sIHRoYW5rIHlvdS4NCj4NCj4gWWVzIHRoYXQgaXMg
dHJ1ZSBidXQgUENJZSBtZW1vcnkgKGFzc3VtaW5nIGEgUENJZSBCQVIgaXMgYmFja2VkIGJ5IHJl
YWwgbWVtb3J5IGFuZCBub3QganVzdCByZWdpc3RlcnMpIG5ldmVyIHBhcnRpY2lwYXRlZCBpbiBj
YWNoZSBjb2hlcmVuY2UgYW55d2F5cy4NCj4gU28gYXNzdW1pbmcgbXkgYXBwbGljYXRpb25zIHVz
aW5nIC9kZXYvZGF4MC4wIGNoYXJhY3RlciBkZXZpY2Ugd2VyZSBhd2FyZSBvZiB0aGlzIGZlYXR1
cmUgKG9yIGxhY2sgb2YgaXQpLCB3b3VsZCB0aGlzIGltcGxlbWVudGF0aW9uIGJlIHRoZSBjb3Jy
ZWN0IHdheSB0byBkbyBpdD8NCg0KSXQgZG9lcyBub3QgbWF0dGVyIGlmIHRoZSBCQVIgaXMgYmFj
a2VkIGJ5IHJlYWwgbWVtb3J5LiBJdCBpcyBpbmNvaGVyZW50IHdpdGggb3RoZXIgaW5pdGlhdG9y
cyBvbiB0aGUgYnVzLCBzbyBpdCBjYW4gY3JlYXRlIGNhc2VzIHdoZXJlIGRpcnR5IGRhdGEgaXMg
c3RyYW5kZWQgaW4gQ1BVIGNhY2hlcyB3aGlsZSBhIGFub3RoZXIgYnVzIGluaXRpYXRvciB0cmll
cyBhY2Nlc3MgdGhlIHNhbWUgcGh5c2ljYWwgYWRkcmVzcy4NCg==
