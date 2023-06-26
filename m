Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0432B4C7F
	for <nvdimm@lists.linux.dev>; Mon, 26 Jun 2023 08:40:27 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ix/Pk1kRGMY96Cu+ZSNyTsdgDA7s+0FEx9c1r1nG5jVxqnXoKy3jWRKwKQx/wFVXpp097fU/0okfjKYCN1ONL5NIpIZJQucw1v+It6zEMquDOl+uJbijgKNIiX3VlrDT/ADudMjc9FRwa2yCJIaWfU/4EdP6o+BzwdGtVUTlcgudjYlMK5L6B/p8KoYmtPh4n3PGl2nTuMpL+0h3yok0W92dZ/Ulbq6OhEHOjYA9fQ6ibECg7nPcfH2iTtB81S8ZlmpBQsialTUV0cSuwCSoP6nY6lzkEdX9n2c+lUqHxLTQCizEOYOoqljw0N/n8i9Ys/8uBenN9R68gm19hTIU2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZusXbTbG/C2X5lUWBOgXHPdyk492nwmA0CBQ3uHIVs=;
 b=aF8aYSiq5ayKj69mqYJ7puatIDZFsasp0aQRZBpotiV1XdT5hCX7bR1PbAn+xSTfQSQXs6ZXbbewggo8xQqIgRIeeAtIq2nf4Y8xW8HKQkiFxJFifBTluLMgGhTM3A9GT+NGWaLyhtwmiHFyl+kluX1k79ldfO/PGLQJk801jS1DFLzoogbSqOVpqCkm2MKfbJDgx8ING+2rYyuRcSSjIXZoALYwoFemaBfz6ezV98Roig7bDLKnQNKZ3dEwri8HloNVaz2IHiRjoyd8SttK+T973yok5MuUzTplbrKUQT5LgErp4cKFtLp9WkQY6V6A+1U53h7RYusRuJCDlzR7ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZusXbTbG/C2X5lUWBOgXHPdyk492nwmA0CBQ3uHIVs=;
 b=EdNVqRRscQV8SCISg/cpTLNH8mABjq0z7qNxwIUlsUhSyqdjSagawqTwk9i9H8jYuWvtyem7AYuk52wKyRg28ukrqtgm6pLbGqybXq+IaAsMr0p+LdLt14rGogJRvg92NKPpxHBED73TJNSj0q2WAX+noJ6eZItvEWrzhodr4Pm7GMwEDayxmZ0h50guTQoFm8cS5S0ViWta1UPlTppRqTlwjgzn/jUO+mRPXEd7bHu1YZm2z5xBsR8HY4qCZhR9C3G1WyemlwE0WBj1ltoDf50SrMWNxWdFjK8DJo50AMbnKvahMXRrzwwe9YFYuHC/YbInX/KVkZD51L1bJ7JKcA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DS0PR12MB8564.namprd12.prod.outlook.com (2603:10b6:8:167::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Mon, 26 Jun
 2023 08:40:25 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc%4]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 08:40:25 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Hou Tao <houtao@huaweicloud.com>, Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Pankaj
 Gupta <pankaj.gupta.linux@gmail.com>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "houtao1@huawei.com"
	<houtao1@huawei.com>
Subject: Re: [PATCH v3] virtio_pmem: add the missing REQ_OP_WRITE for flush
 bio
Thread-Topic: [PATCH v3] virtio_pmem: add the missing REQ_OP_WRITE for flush
 bio
Thread-Index: AQHZpwf9+aTL0rQr30yNFL5aTrgXPK+cxaUA
Date: Mon, 26 Jun 2023 08:40:25 +0000
Message-ID: <7f49a5ad-8b34-c00c-9270-8d782200c78c@nvidia.com>
References: <ZJL3+E5P+Yw5jDKy@infradead.org>
 <20230625022633.2753877-1-houtao@huaweicloud.com>
In-Reply-To: <20230625022633.2753877-1-houtao@huaweicloud.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|DS0PR12MB8564:EE_
x-ms-office365-filtering-correlation-id: fada3fb3-e875-4df6-8436-08db7620fcad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 +i7rUpmIdOTShlpU1RrBwdQp4AAL1pgy193VprR3w2SntcG5yXYoUP36T0p7qcWi/+S2WJIo38gV71mk5v6vIV93iCGk0sUGG43nCO6heTJhq2+h4iB4oGArLyDGOqh/4Xj4NhIgTAQ7VoNN9/n8w18YoN2TSFTWhN2DRkWBVBp0CWETd1rBp4FOGlr+oNbJk2sqT3NhLcrCOhPBPTmsIDT3G45BXATjoEMEMutHNcDJ+HSnNYfC96r6wc7rwp3D9ovj2Nrto0fN1g0c+6EEf2T9JP7BBKmTTPxCu1klG+5BTMOzMUCyj5ioYMRd4YmwrsQIcjfWvLG9oRPWxNvPDuJx6XCrFGL+f2z8DzhXPiRfVerAZw7pLn+5ZaaY3jtmjhF3lVO81mGvBcPIH7Rt+UeShFTXNSx9hoHpwDKKO4QE0Up+OIrFd9aGOu7I2zD4AvyHgY7W3zb5sxvzTh/GDSXtoxT3l5o8WQ0HrdYtGHrPHIHKotbAaA0YVCw9AVwlsDlSrt2Ti/bNR0NZpRUDw8zwiuGmrMRjWDEsWxqsTDpH4EhdufUHDDnSgj9z5qBzmDsE46Ok4pUzvqAsr52ruQKjQUevZGDk3CVl1ZfFdhrCdLNtrZhbXhw1UYFLe3UuUttZ/CHar2688x2mZhP+w026gIiMkoUYFqWdxhfBzYCEMFcYsKbivACpwRSlj5uelmRa4WTzwfmUukpdDh/y4VrCcwhGlg1HhCo4NoaZid6ErbDFihKTmKKXJ492dQ6Q
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(2906002)(6486002)(45080400002)(71200400001)(38100700002)(122000001)(2616005)(83380400001)(6512007)(6506007)(26005)(53546011)(186003)(966005)(41300700001)(110136005)(54906003)(31696002)(86362001)(38070700005)(478600001)(316002)(36756003)(91956017)(66556008)(4326008)(76116006)(66946007)(66446008)(64756008)(66476007)(31686004)(5660300002)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OFcvb3BNYkFjandDSDVvL2xzYWhPcnhoOXVRa1ZabjhaRGh6bjhRR0xIanhT?=
 =?utf-8?B?V05KakdVM0t1V1RRNUd1LzlncWNKRjVZK1V5TmVjUitjZlVvWFRBcE5HWWw3?=
 =?utf-8?B?NGtQUVZDY05tNDRhZWVTbmFZYXJJazQ4Z1RuaHNXS2dwRkpnaHNqa1NnQVMy?=
 =?utf-8?B?VDNZemVaM1JqT050Qi9VQXBLNHl2L2ovYWxQRW1WTWdLOVllbUMzUUg5bHpK?=
 =?utf-8?B?eWlGUm9rYndpUlhPTytkdVhEcitFMGlEZGs2c3FNalFrS294N1l1NUphenlE?=
 =?utf-8?B?L2VMSDhsZ1BZd0wrUkFTUGMzVDRydnVFQmtPY09HOXN5VEZsZUFxZkJ2VklC?=
 =?utf-8?B?Z0pmcFU0SWpkNG1QUlFodkhpYkI0KzBzZ2l2QUpHL241VXE3YThyem1BVnlU?=
 =?utf-8?B?NHRXMm01eGdTZFZXRm9Zb2dlRFBoaUdycnIyRGpFVDFrbldkMERtT3h5Qysv?=
 =?utf-8?B?ZWVZR3FTcDFSWlc4cGlTbi9CVlAyYkhNWTFRdWQxREZqR0w5YnVZYmtGYnli?=
 =?utf-8?B?aHAyWEg3a3dqUWYwVk8xaXcycXVDdXBoOTNsa1gvcTZqcE1MeUhRTVFrN0ow?=
 =?utf-8?B?Rm9ya2Q0SHpTVHg0aEtrT3NGSWhsSEltbUJsdkd1UVZVbFNSYkI0R3dGUzZm?=
 =?utf-8?B?Mm1GMERkRk45dmcyTFJFTzVTejZ4ZjNhU1FUQU1EWUlYUVBHWWpzeFpvd2Q4?=
 =?utf-8?B?NG5zSmxxSGtuMW4zTlRVOWxUVmZSZHNyVm1ScTk0TUw3cm5nNTdQZmJTOTVr?=
 =?utf-8?B?Y1FJQ1VEeENtczM4VVBQcEFmd0hWV1hrMzVyVi9Cb1NvcHlRREVVUXowbVBz?=
 =?utf-8?B?bUJGZDVSWGowdEtteC96SndWNDhzZ2R1Yjc2QWt6VWFtMDIvVFFHQTdwNTFF?=
 =?utf-8?B?WlBtSDM2UWRQQVNBbjhFeHovQTRpa0lBNGFxcXNMMTk3WkhtTjhYdG92TmZL?=
 =?utf-8?B?VlpMR2o5TjJZMVFoMXJ5SmtQRmNXbWc4K1VHU2VUeTdjb3AvRXF1Q1VxOHRq?=
 =?utf-8?B?VXpJT3A3WGNJV2dzRGExY2JyUTVFT25aa2U0TENzTTI1N3FETTBHeVFGNnpB?=
 =?utf-8?B?elhtS3kxZU81eW1ybmNKRTZMbzRVRjhzSjUyRFhnMDVUdnczMThTUEtHaU03?=
 =?utf-8?B?d2Vsa3ZIYklrLyszR3hEKzg2SzFzRFVuckk3QWRTQ3RZdEJnQ1I1M2s1ajNU?=
 =?utf-8?B?bG9zUWdIcmRHZWJUWVNZdGxTWWYvc25KNW95ZGdDaCtMeEZ6YWVhaGFmRTNn?=
 =?utf-8?B?TlBTWnRyZjJPVmVxU3Fjd01FSWZHTnlYazlnblNxd0thOUpscUxxdGJsbk9L?=
 =?utf-8?B?U2FJNDVsRVltWWVod3RUcmhCT0pXcTBKVTNnS0NLUXN4Z2JVWUU5UjFGS1Rq?=
 =?utf-8?B?Qkg2aFZ2OWVSZVFHMzVQYWI3N3Nwd1RTTXFPN0hkeFBrbmc0MXhQb3FtN0ln?=
 =?utf-8?B?Z0hTbXVLK3N5TXh2bHRJNHJxeFkyTXFCSG9UTUUzYWJ5cXlaWXJWSzRLR095?=
 =?utf-8?B?VE9PMnA3V2grZEI1ZFN2RlpIcUNibWdsQ2VpaFViU2QxRkthWWJrMDY0ZGt4?=
 =?utf-8?B?aDMwNGNKSTNEQVVsWUcxeXJIRVRsVjVmMUJtc3Bad0dqaGZMZmZVdkZkVkMy?=
 =?utf-8?B?M0krWVAyalhrVUlRZ05YTlRDUENmYkZJNHI5eko2UjF4cllSNzQzYXUwb0lD?=
 =?utf-8?B?WTNtYzA4WHZEbHZraG9MNVVVZndKMGJOSXJpUEQxSXk4bHo3VXlES2RaNXlw?=
 =?utf-8?B?bnZCZmcyK0FnY2pSVGNRbTdGQzh5MVAzVExsTlBKMmdNdTZIU1FkRkVRZmFR?=
 =?utf-8?B?RHJNNktnNHo3SlQ3VVRxL0VtcUFNN1Q2dGtuK1NuK2dWY1JRZHB5RHkwTVJx?=
 =?utf-8?B?VUx1NG4zTDJnV3FHbnVhSHV1Z1lnUWVoaDRoejRHQ3ZvWGZtRmVZTVBTN056?=
 =?utf-8?B?eTQvQVc5V0l6TW1obFVwMzU4MG5jZXBCQ0hveVJyZDhZMkNyYjBEeHMwU0hw?=
 =?utf-8?B?ZWFiVElsd3cyQmVRaWd5TjRHbkkzYW0xTysyREFZM3FFa1pBVkhObVB2eGdy?=
 =?utf-8?B?bTZGQ2owMDkySmloVXdUdmpVMldWUHdJSUEwVFdvanN2QjJTMXpFekFmNWpG?=
 =?utf-8?Q?YhuJ/TXkwbrOY/2KMLgUUHWMz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9660007B69045A40AB99AE6DDCB13615@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fada3fb3-e875-4df6-8436-08db7620fcad
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2023 08:40:25.2759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: te730PdFTQ6ZVWe1KL6wSzRHyoOmwkZ17xccntg+AxO1uavdUS2HKfwqgVClf8Izyn6ARjgZ38pjqICsy6ArhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8564

T24gNi8yNC8yMDIzIDc6MjYgUE0sIEhvdSBUYW8gd3JvdGU6DQo+IEZyb206IEhvdSBUYW8gPGhv
dXRhbzFAaHVhd2VpLmNvbT4NCj4gDQo+IFdoZW4gZG9pbmcgbWtmcy54ZnMgb24gYSBwbWVtIGRl
dmljZSwgdGhlIGZvbGxvd2luZyB3YXJuaW5nIHdhcw0KPiByZXBvcnRlZCBhbmQgOg0KPiANCj4g
ICAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0NCj4gICBXQVJOSU5HOiBDUFU6
IDIgUElEOiAzODQgYXQgYmxvY2svYmxrLWNvcmUuYzo3NTEgc3VibWl0X2Jpb19ub2FjY3QNCj4g
ICBNb2R1bGVzIGxpbmtlZCBpbjoNCj4gICBDUFU6IDIgUElEOiAzODQgQ29tbTogbWtmcy54ZnMg
Tm90IHRhaW50ZWQgNi40LjAtcmM3KyAjMTU0DQo+ICAgSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFu
ZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NikNCj4gICBSSVA6IDAwMTA6c3VibWl0X2Jpb19u
b2FjY3QrMHgzNDAvMHg1MjANCj4gICAuLi4uLi4NCj4gICBDYWxsIFRyYWNlOg0KPiAgICA8VEFT
Sz4NCj4gICAgPyBhc21fZXhjX2ludmFsaWRfb3ArMHgxYi8weDIwDQo+ICAgID8gc3VibWl0X2Jp
b19ub2FjY3QrMHgzNDAvMHg1MjANCj4gICAgPyBzdWJtaXRfYmlvX25vYWNjdCsweGQ1LzB4NTIw
DQo+ICAgIHN1Ym1pdF9iaW8rMHgzNy8weDYwDQo+ICAgIGFzeW5jX3BtZW1fZmx1c2grMHg3OS8w
eGEwDQo+ICAgIG52ZGltbV9mbHVzaCsweDE3LzB4NDANCj4gICAgcG1lbV9zdWJtaXRfYmlvKzB4
MzcwLzB4MzkwDQo+ICAgIF9fc3VibWl0X2JpbysweGJjLzB4MTkwDQo+ICAgIHN1Ym1pdF9iaW9f
bm9hY2N0X25vY2hlY2srMHgxNGQvMHgzNzANCj4gICAgc3VibWl0X2Jpb19ub2FjY3QrMHgxZWYv
MHg1MjANCj4gICAgc3VibWl0X2JpbysweDU1LzB4NjANCj4gICAgc3VibWl0X2Jpb193YWl0KzB4
NWEvMHhjMA0KPiAgICBibGtkZXZfaXNzdWVfZmx1c2grMHg0NC8weDYwDQo+IA0KPiBUaGUgcm9v
dCBjYXVzZSBpcyB0aGF0IHN1Ym1pdF9iaW9fbm9hY2N0KCkgbmVlZHMgYmlvX29wKCkgaXMgZWl0
aGVyDQo+IFdSSVRFIG9yIFpPTkVfQVBQRU5EIGZvciBmbHVzaCBiaW8gYW5kIGFzeW5jX3BtZW1f
Zmx1c2goKSBkb2Vzbid0IGFzc2lnbg0KPiBSRVFfT1BfV1JJVEUgd2hlbiBhbGxvY2F0aW5nIGZs
dXNoIGJpbywgc28gc3VibWl0X2Jpb19ub2FjY3QganVzdCBmYWlsDQo+IHRoZSBmbHVzaCBiaW8u
DQo+IA0KPiBTaW1wbHkgZml4IGl0IGJ5IGFkZGluZyB0aGUgbWlzc2luZyBSRVFfT1BfV1JJVEUg
Zm9yIGZsdXNoIGJpby4gQW5kIHdlDQo+IGNvdWxkIGZpeCB0aGUgZmx1c2ggb3JkZXIgaXNzdWUg
YW5kIGRvIGZsdXNoIG9wdGltaXphdGlvbiBsYXRlci4NCj4gDQo+IEZpeGVzOiBiNGE2YmIzYTY3
YWEgKCJibG9jazogYWRkIGEgc2FuaXR5IGNoZWNrIGZvciBub24td3JpdGUgZmx1c2gvZnVhIGJp
b3MiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBIb3UgVGFvIDxob3V0YW8xQGh1YXdlaS5jb20+DQo+IC0t
LQ0KPiB2MzoNCj4gICAqIGFkanVzdCB0aGUgb3Zlcmx5IGxvbmcgbGluZXMgaW4gYm90aCBjb21t
aXQgbWVzc2FnZSBhbmQgY29kZQ0KPiANCj4gdjI6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xp
bnV4LWJsb2NrLzIwMjMwNjIxMTM0MzQwLjg3ODQ2MS0xLWhvdXRhb0BodWF3ZWljbG91ZC5jb20N
Cj4gICAqIGRvIGEgbWluaW1hbCBmaXggZmlyc3QgKFN1Z2dlc3RlZCBieSBDaHJpc3RvcGgpDQo+
IA0KPiB2MTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtYmxvY2svWkpMcFlNQzhGZ3Ra
MGsya0BpbmZyYWRlYWQub3JnL1QvI3QNCj4gDQo+IEhpIEplbnMgJiBEYW4sDQo+IA0KPiBJIGZv
dW5kIFBhbmthaiB3YXMgd29ya2luZyBvbiB0aGUgb3B0aW1pemF0aW9uIG9mIHZpcnRpby1wbWVt
IGZsdXNoIGJpbw0KPiBbMF0sIGJ1dCBjb25zaWRlcmluZyB0aGUgbGFzdCBzdGF0dXMgdXBkYXRl
IHdhcyAxLzEyLzIwMjIsIHNvIGNvdWxkIHlvdQ0KPiBwbGVhc2UgcGljayB0aGUgcGF0Y2ggdXAg
Zm9yIHY2LjQgYW5kIHdlIGNhbiBkbyB0aGUgZmx1c2ggb3B0aW1pemF0aW9uDQo+IGxhdGVyID8N
Cj4gDQo+IFswXTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIyMDExMTE2MTkzNy41
NjI3Mi0xLXBhbmthai5ndXB0YS5saW51eEBnbWFpbC5jb20vVC8NCj4gDQoNCkkndmUgZmFpbGVk
IHRvIHVuZGVyc3RhbmQgd2h5IHdlIHNob3VsZCB3YWl0IGZvciBbMF0gLi4uDQoNClJldmlld2Vk
LWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
