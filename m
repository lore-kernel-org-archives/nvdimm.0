Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF48D846A
	for <nvdimm@lists.linux.dev>; Thu,  3 Aug 2023 03:24:39 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCBjpB2lLe4+D7M8kZUwB9u84OK2TGRWYwZXIcsXcDQc0E0RLlPBjqeLBd/x9SrjKelfCMaY0+FJroM7xq5ZZNNrDpXqWvDv8iSf2QxsWMh7aHdeKonZXP1X/yxdixfRm3WBpT1wZqrrqEPE+xCQ07UXayhXmG6agtN3/1ZdE2qh5y6NJ3J9k5plYUJ9FBcv5tsWOtIxONDo02z3DJBTPZsjNDmjSpKY16CsQ2KHbhwvbwsC0JBAvg68NmWwj1xnnV8PbaR8Xb2rDZO19/67NIh2O2OLiUDCHEauulLVpsCSBA+zI9B8mFiNIGJWAsyQnQ6qzoY7JS97roRc4k+UIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFNlFij2HT0XtUuB5yHM6Fy0yATdW8XEpQFwtoDE9JE=;
 b=ljDUoO8SbYLje8FI9+fNB3zzT9D4XrdKmjVhnXJyBq5h7LAHaigr+af6COdqq1wJFApH0C7ZeaiW7Q+M7iBp/Cwe8R18Mtw87DbV5C5GoWiXTjflM9NbSHOe0pL56Wdrdqkk6/A92r068cYhh9E+mZ3N2ch3WmnyRDaEcE7QnroNOuWcB+wDwHqYr5wM9mkntjhAwp73QaS711BectL3/VCVAGqnv6Uz59s6u5ZLw+Jy6zTnT8EE0MlAdkFyRL0pf8jZig+89mIsVzTpTOr85ik+7HfmYz9goUIAM8KBDhwilqMgWOL8AOOi2QXP3ppLx1b5olsXS+StagWKvjh7aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFNlFij2HT0XtUuB5yHM6Fy0yATdW8XEpQFwtoDE9JE=;
 b=X9ZKhp++iXByi9dHjZySyrdnmLp2sq07ueM4PA4HwerKLhlbWKUu1RJdonfb2lXT4et+fJf4gnrcB0tXldnF8rwJHsJ8Btc7a6OD+Y+hx3HeYBrM8Bf06HtwfIqOLFbmYpANVDSnAFXK9tZh5UbRv3p6wubdEmE5KdmXLu69biomP5hm+LuVTO0T59b4O4msG62+7ZGEysJ+Ykh7kUlBhKbdMa1qYoGNPJU2FQ1+Fwlbq8UiL0quM7OuEDb1PkCfVgzjjJswFSqMHRWo5fBb239Ah5RJq0VyPkwgqC0Pk3zrbyr7dZ0EKFF+WYGQNG9d7NEL9YDzOU+nQVe8zhxw2w==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4903.namprd12.prod.outlook.com (2603:10b6:a03:1d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Thu, 3 Aug
 2023 03:24:36 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c3cf:2236:234b:b664]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c3cf:2236:234b:b664%4]) with mapi id 15.20.6631.046; Thu, 3 Aug 2023
 03:24:36 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, "dave.jiang@intel.com"
	<dave.jiang@intel.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
Subject: Re: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Thread-Topic: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Thread-Index:
 AQHZxADrXE+/yvq5u06qlYmjeW0Jd6/Vjqw1gAALsYCAAB0cXoAAgQeAgAC5pQCAAC/hhoAAygWA
Date: Thu, 3 Aug 2023 03:24:36 +0000
Message-ID: <2466cca2-4cc6-9ac2-d6cd-cded843c44be@nvidia.com>
References: <20230731224617.8665-1-kch@nvidia.com>
 <20230731224617.8665-2-kch@nvidia.com>
 <x491qgmwzuv.fsf@segfault.boston.devel.redhat.com>
 <20230801155943.GA13111@lst.de>
 <x49wmyevej2.fsf@segfault.boston.devel.redhat.com>
 <0a2d86d6-34a1-0c8d-389c-1dc2f886f108@nvidia.com>
 <20230802123010.GB30792@lst.de>
 <x49o7jpv50v.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49o7jpv50v.fsf@segfault.boston.devel.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4903:EE_
x-ms-office365-filtering-correlation-id: a57ca032-1e0b-4432-2ffb-08db93d129f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ADdDZrQz6AoQ7RWgofs9n6Uh5Y7cjLVVKto3aoKe3YM4WU1v6o7WY+9coRSAy6iAhkiaeZvjoN43XJxPQAGP+Bt4pl26s/NmiO+WCud9eeMCeaSEaviK1kwzOzLr84XQgUngPyDXyshkzSi6N3qV/EtBWjZYk79ptZsfLm8LempezJdqmcM/r9ZfdnOrdM5L64huCcuLQcKGXRIAsUct3gLbuy7nPCyye8vrmWZ/GguaonFd/SOgBV0tlHw6XUSNOroSi3aPSYeCxodz4mU2ZweV4k+qQjpZLyBTBAthudsgvuHASEC5G0J2qzstRRTAyXBei2vJk1LbsmaUwTpITqmYrgcXo7cGEy2cFWW+WycJEaIUMzm3vzJONA6Zm93dw7sU2Rhirkn5zDGGa2RzJWTIYyM4csVNycq4M/bt+fHw2B0DQIyicnPdoQ6U/f/AFg6aJityQMhem6Vq/d9XVJC/49gEmNeuS8DNyoqv9U84qh9jn2BuqZJihslX6yAk0OtKjjdFC8se0ovRHGaHkQTNz4t4OHsNREYFKu/puPoKGbGaTqXrPwhqkebErLkkvJTyd0sPiAn/8We/EcBSCXFSy+kxcQBzzS06fnhj4vaSXcFXny7BfnDRgY3KizD2rL8Eo+VrqJ41xOGmi1S2bQythBdtnBUclGFEGErTf5/4VER5mgIoNsl3TGwB7Mly
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199021)(2616005)(186003)(6512007)(316002)(86362001)(478600001)(54906003)(122000001)(38100700002)(110136005)(66556008)(66476007)(91956017)(66446008)(66946007)(6486002)(71200400001)(76116006)(31696002)(4326008)(64756008)(53546011)(6506007)(36756003)(41300700001)(26005)(5660300002)(8676002)(8936002)(2906002)(66899021)(38070700005)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RmkrWkkxRTBSd3FzTi9qamZPSUVCSFQzOGhNOUd0clNiRyt0Z0pzSnl3bkh1?=
 =?utf-8?B?SWZjOVRHb0s0UHhvcHpQYXZTV3Nmc0hZdDlHUUc0VUY1eWY1L2praGlQSDQy?=
 =?utf-8?B?WG16OW9YaVBZWnJZKy9nMWRTckxzazhEZW0yanFDNEtLMXFnVElxSGxib0c0?=
 =?utf-8?B?OWlrbm9sMXkrVSsvMWRxVGZTbXJobW5vZDk1WDU5OFZXY2JVK1VYb2IyZW84?=
 =?utf-8?B?VWtsRlNBWnhBL01PRlRJU3UxY1JvS1d3VEdHMTVucUJwVEU4YmIxbGNmTi9v?=
 =?utf-8?B?Z3pWL0MvejNuL1BFOUtrM1ZnenJ5ekhQV0QraTJLNm5EZjRLcmM1LytSWDNR?=
 =?utf-8?B?N2l3YzdBbitDcWo4dmlvMjNNZ1VZeE56ekloeWV0cTNicGoya2dGRmQzQWwr?=
 =?utf-8?B?blUzVHh0VlZCRHg2WnhHQm1JWmV4VFVGemwyc0ZYU0FBOGtTenYwNlF2anRU?=
 =?utf-8?B?amdhSnJqcjZBTXFCN3kxSGMyUVZ0eTNrallTdTFNSlJDZC9yRVAyMTJtdThE?=
 =?utf-8?B?WE5YckNUNVFmb0k4M0kyTVVsQ0NONjRhSHlKdi8ySjdlUnpzWHd1ZGNZY0c2?=
 =?utf-8?B?L1krVTNONjhsYi81NjJvajd3WUFybENvQUh5ZGpwTENuS3dXQ3RUbkM5emd5?=
 =?utf-8?B?S2lsRDJmRHk3cFhtZXZNYlZnM1F1ck05a2VEY3M4ZitpSTVSM0h6dGJWSWR0?=
 =?utf-8?B?d0Y0UStFUjBESDlZdk9KY1RWSkQ3VWlpN0NLYWhwSjVPblAxQUdwZUhsWjFx?=
 =?utf-8?B?d2FtVVRaa0V4amVYSTFLWVE3WTgxUUpYbVRIY0VuUWJGWlo0cjVHYUcwZVlL?=
 =?utf-8?B?UlVFVGlNdVpDRFRKd3FubnllU2Fyd2xkZmI1bU1wQWlneERNRUZCVy9jRU93?=
 =?utf-8?B?S3NLTERJRXZQN1o4dWEvOFRiOURad2MzRis4WTFYTGQ1dHREd2xpbkJaQ043?=
 =?utf-8?B?Vy93Rk92Z0N4MUNCVzAvRGFORlFGWnV5VUlTOHRibzlsWEN2OFNneWlLUURt?=
 =?utf-8?B?Ukh5RE53ZUpPay9uN2FDU0ZZcTFxZGtSTmYwNXFCT2lpRTZ1Wi9zY0tuRlEy?=
 =?utf-8?B?c3FUZ0F1M2E3YVh1eWFTdGorUXRoZWFVYmo0VDVHOFpuK1JoUjk4ajlyVVNz?=
 =?utf-8?B?eG56ajdTZUpvMTlVdlRaMmJ3bDJOcHZyU01RbXhUS3FHTVdRMm1RVFZPcW1r?=
 =?utf-8?B?Q2RTS0l0YlFocTNDMktOSW4xMzA5RmtkWVUva1p5OU8zdURVdTh0bUdWYzEy?=
 =?utf-8?B?VDZZd1lUVzQ4WTlraERTWmNJbGdFSzBWTzRMMnU1dnFYWnFqUnZBQm9XRjI0?=
 =?utf-8?B?bWoyNndGM0ZYQTNIUnY4RUlSdWNqV0djdGVMWUlndkF2Rk11NStPbnR1VDZM?=
 =?utf-8?B?VnZLelJZRVZ4dE00S3BPZUhsNmtlWklZUlFGaGhtWTQ2dDRaSUdiWC9UWnFJ?=
 =?utf-8?B?dHNrUFVjQUpwRGFLMzFsSHc0aFpTYVFiYlNZdnM2bnF0UXUwaDRpVEFxNHlk?=
 =?utf-8?B?TlNUbVdLV3VOS3V3U0tzTzczSmptbEdkOUE3cVhSZ3BKRHFYWklCNnc0aFNr?=
 =?utf-8?B?SVdzbG5kdEtDL09FVms5VlBCdi95SGpXT1puTVZPczJZV3orUmxnbzZZY2Ix?=
 =?utf-8?B?RXh1QVkrMmFrNlNuVEhyVlhvdGpOd25HaHhKdjdEWXY4NHF1aWpPSjdkYU1F?=
 =?utf-8?B?bFdzUDNuY2I5a2VvVVFmSzVpaFdrazVLMGg3dWRDZEw0NHhOSGMycWJzUEY3?=
 =?utf-8?B?UmJ2ZDNNQ1FPRWZsQy9GeCtaMi8rNkdlc2ZJanVvTDdCVlREeG0zTDF6Yyt4?=
 =?utf-8?B?Sy92NEZBYWNsWjE3ZkRMSlhPcHVScUZWcGZEOWh0R2ordEpzd1EzWWxoVlox?=
 =?utf-8?B?QTZQTGZPZ0ZwWUVpSDE1UW8rTmZWcEtNTTNNMDZwSTVLaE1qTjdJWmJWTkln?=
 =?utf-8?B?cyt0Y29QWmJXOThuQXd0amRUUWJNMGlKL2NmeTJ6MEpJaStkdzF3THlIWmVL?=
 =?utf-8?B?THhpSWUyK1VJQlUzT2I5N3BWanFsV0FwclJNYmZ6VVhGb3NNc3JDN3pFU1Fh?=
 =?utf-8?B?dWJpUUMrZXoyUG1jb0d1UForNTg0aEc0UFl0QWZWeVZzMkRnR0FaWVBCaWMv?=
 =?utf-8?Q?ONK0QAdbOnBxiilE5g9SLVFRt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26476AD20A7315408E8EA0EAB3CF5D85@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a57ca032-1e0b-4432-2ffb-08db93d129f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 03:24:36.3896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y0uQYxb20TmTqCtkLsQlfKihK1/nvOo0fcbeCuV+9tnGvnBbFv0QqqZPJ+p+ryPWYCtlhXOtpLPU/51M0OGZvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4903

T24gOC8yLzIzIDA4OjI3LCBKZWZmIE1veWVyIHdyb3RlOg0KPiBDaHJpc3RvcGggSGVsbHdpZyA8
aGNoQGxzdC5kZT4gd3JpdGVzOg0KPg0KPj4gR2l2ZW4gdGhhdCBwbWVtIHNpbXBseSBsb29wcyBv
dmVyIGFuIGFyYml0cmFyaWx5IGxhcmdlIGJpbyBJIHRoaW5rDQo+PiB3ZSBhbHNvIG5lZWQgYSB0
aHJlc2hvbGQgZm9yIHdoaWNoIHRvIGFsbG93IG5vd2FpdCBJL08uICBXaGlsZSBpdA0KPj4gd29u
J3QgYmxvY2sgZm9yIGdpYW50IEkvT3MsIGRvaW5nIGFsbCBvZiB0aGVtIGluIHRoZSBzdWJtaXR0
ZXINCj4+IGNvbnRleHQgaXNuJ3QgZXhhY3RseSB0aGUgaWRlYSBiZWhpbmQgdGhlIG5vd2FpdCBJ
L08uDQo+Pg0KPj4gSSdtIG5vdCByZWFsbHkgc3VyZSB3aGF0IGEgZ29vZCB0aGVzaG9sZCB3b3Vs
ZCBiZSwgdGhvdWdoLg0KPiBUaGVyZSdzIG5vIG1lbnRpb24gb2YgdGhlIGxhdGVuY3kgb2YgdGhl
IHN1Ym1pc3Npb24gc2lkZSBpbiB0aGUNCj4gZG9jdW1lbnRhdGlvbiBmb3IgUldGX05PV0FJVC4g
IFRoZSBtYW4gcGFnZSBzYXlzICJEbyBub3Qgd2FpdCBmb3IgZGF0YQ0KPiB3aGljaCBpcyBub3Qg
aW1tZWRpYXRlbHkgYXZhaWxhYmxlLiIgIERhdGEgaW4gcG1lbSAqaXMqIGltbWVkaWF0ZWx5DQo+
IGF2YWlsYWJsZS4gIElmIHdlIHdhbnRlZCB0byBlbmZvcmNlIGEgbGF0ZW5jeSB0aHJlc2hvbGQg
Zm9yIHN1Ym1pc3Npb24sDQo+IGl0IHdvdWxkIGhhdmUgdG8gYmUgY29uZmlndXJhYmxlIGFuZCwg
aWRlYWxseSwgYSBwYXJ0IG9mIHRoZSBBUEkuICBJDQo+IGRvbid0IHRoaW5rIGl0J3Mgc29tZXRo
aW5nIHdlIHNob3VsZCBldmVuIHRyeSB0byBndWFyYW50ZWUsIHRob3VnaCwNCj4gdW5sZXNzIGFw
cGxpY2F0aW9uIHdyaXRlcnMgYXJlIGFza2luZyBmb3IgaXQuDQoNCkkgbmVlZCB0byBzZWUgdGhl
IHVzZWNhc2UgZnJvbSBhcHBsaWNhdGlvbiB3cml0dGVyIHdobyBjYW5ub3QgY29tZQ0Kd2l0aCBh
IHNvbHV0aW9uIHNvIGtlcm5lbCBoYXZlIHRvIHByb3ZpZGUgdGhpcyBpbnRlcmZhY2UsIEknbGwg
YmUgaGFwcHkNCnRvIGRvIHRoYXQgLi4NCg0KPiBTbywgSSB0aGluayB3aXRoIHRoZSBjaGFuZ2Ug
dG8gcmV0dXJuIC1FQUdBSU4gZm9yIHdyaXRlcyB0byBwb2lzb25lZA0KPiBtZW1vcnksIHRoaXMg
cGF0Y2ggaXMgcHJvYmFibHkgb2suDQoNCkkgYmVsaWV2ZSB5b3UgbWVhbiB0aGUgc2FtZSBvbmUg
SSd2ZcKgIHByb3ZpZGVkIGVhcmxpZXIgaW5jcmVtZW50YWwgLi4NCg0KPiBDaGFpdGFueWEsIGNv
dWxkIHlvdSBzZW5kIGEgdjI/DQoNCnN1cmUgLi4uDQoNCi1jaw0KDQoNCg0KDQo=
