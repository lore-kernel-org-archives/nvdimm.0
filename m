Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C6A806
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 00:56:47 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIeWob+GOexI4+8tJQdZnOfyxKbuoqiaMe6d6X/3LL8JDfvlJUsAMcoRgHkTU27US+VUW2qe0/8wJPif6Laa86WEkSaBWBe7NNbggKWaiUnI98juGu2g71jsF9CmjncmESEDxqMZprcQSDEVoIx+vi8Nbne9XGIhfxOombX07NQY9dH1slS7BHATBoF9qcXtHKg/tCfCezoG6/PgogfrRCcxM8G3fs1Eqybmekf4Gk2UPeO6ceSU8bM5RMuo58ac8oBtt/YZKG/9Hl9hE8jrStU7offFshjgGN7oNGEpG62OFTSp6K9DHQnbj9fFOTkQxNjPKzi1LD9icUGpKHeHlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0FFlxDGVMe2p/rGBtRCwat6oC8MOigMZU+pCVtTWH4=;
 b=VY37yFY/HKKkMgJw0lrdH2HJE+v+k+E9/Onlq/7S3CxQdb/jcaNwhzuhfaCki5DP3sTGCnPhdOoj0mY36LUO/Woa4SAjDT0LieT9g4Dws1rV+sShiJM3K8CVxpFdGPncZXHpPekqLlWiwkI/w7QN631kHdYkP88XqPkxL2ruWG7Ap9iIfkqvVTri/Geqc4ZtXfNaWWmYYsnzwru0UrBWEVlMv7uiwt7xnJco5HOhBq0d5r33qQBIqrDUBa8R/UPmgufNCdNT8+ucbr4Ng4XTW0GUcuWEqhRbEEgwLYvkSGFajF/kFU0B1R5+TeRVESYXRVruMyQIoaGURSiMeIkPtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0FFlxDGVMe2p/rGBtRCwat6oC8MOigMZU+pCVtTWH4=;
 b=lm82lTAhANr/SMv3cI/35ts/1GXDoiwnqqtC2vO7yPlakmgi4qvXlDk0HZmw4g1RPF1h08LdbxEfZ0DcpJ1LqVFmxFqM+XC4J8K+Wh6fKsE0899Dy5zkb24jVb1ZwABPbJg4VZIleWnlmDnvuIvKd7O6pfAFL4w/30fvi7YZjOE2oNIZKpLgCkEQyz1g9Xz5245Z0siaI1axs81uS9tGWOaI1/H0+CXP/9pH2vq6qjZlriZtZKqzYpP9I8hAaKOgIiiEMmL2dGEkRA1Sy5qhAVAUxs3X2zgT0/hPZPRYtc6PrcqQ0lgKWbLCAgzvXiaBvEWOENfteiyrv2vau+fU/g==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Sat, 13 May
 2023 00:56:45 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc%4]) with mapi id 15.20.6387.021; Sat, 13 May 2023
 00:56:45 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Ira Weiny <ira.weiny@intel.com>, Chaitanya Kulkarni
	<chaitanyak@nvidia.com>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 1/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Thread-Topic: [PATCH 1/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Thread-Index: AQHZhL6ceVIzisv4Ykq1nZJcI0+iua9W4PkAgACBHAA=
Date: Sat, 13 May 2023 00:56:44 +0000
Message-ID: <d5d11033-9d72-15ad-b58f-7e843e8e6d8e@nvidia.com>
References: <20230512104302.8527-1-kch@nvidia.com>
 <20230512104302.8527-2-kch@nvidia.com>
 <645e73feb7ff6_aee562944d@iweiny-mobl.notmuch>
In-Reply-To: <645e73feb7ff6_aee562944d@iweiny-mobl.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|LV2PR12MB5797:EE_
x-ms-office365-filtering-correlation-id: b03be482-49e4-4061-faf5-08db534cec3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 JsGxsuPw9Sh64PoOR05sVP8BPsabTS+7G3ZANzmK/0ygHWKZAik4mjhgjq5aJe7j6QUWlVrHC0fhVMwudDLW2XA6ENzYLjun6AvC5hf2+V70DQKAqQ2T2yBHU1k7D+hD+rp5c3PjrpcEdsWPE3Nf9R8RZmbwPH6aQD9yFGJd3abkqJL6Un1UTIbnm1oksdOgaWLHo0txY0gN2UHwkgFcmHtR0GG+itdGi2cmGqHK6vvDkCgGBdREMwJ3z4r9/St0fqnoTFXpasFlvrStsVlUqrT0HoylttrlX4pvd1jBo/2rA5ykeMrHYb7+eBq05xy7304gmVYXOwwmOM+MInIzz0v41OIIOmjB6Oy11iMLPj/F9MbErsEP5ezZwaSndrPHNaSssFkmKQSycPnzn8bLPM1AJotjcxGjIVEti74TNZj4NFzKAOya1DM62tuP5+O70sRvuB3qOYoHUfC0BDdZ23jx7pyOLBdkgtk/Mhwg8TAI0DDxqLAC9sTZSBktw6SioVQwJHmIpqOJtXWID8mhHAA/BPvamT26Oy3OjhjjLHGsKHg4PapjTCKC5vCM59zseXx/LzFbOHxsaeWzQkSlifxhdhJIcoLhLxe0jhe1hxjYZtMzGi9mFSYwZgBkSe2WqcdIDZ0KO0vP/rfxh286AfYyL1+Yr5qSGRmdCju8EI6ulT8RHC2A20NeaxJyqEyy
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199021)(66556008)(31686004)(66476007)(64756008)(66946007)(91956017)(76116006)(41300700001)(66446008)(4326008)(71200400001)(110136005)(478600001)(316002)(6486002)(6512007)(6506007)(8676002)(8936002)(5660300002)(31696002)(53546011)(86362001)(2906002)(186003)(83380400001)(2616005)(38100700002)(38070700005)(122000001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZFZsWVA3U3BqdTRZZHJWcGNmL2JyNUFWU3UwSnAxQzZBbWY1VHc0VDJKaW1B?=
 =?utf-8?B?VVdla2U1TXQreVNYTmJycEdyQ0Racy95V0xTVDQxY0Jlazh0L3ArWUN6MEd5?=
 =?utf-8?B?MnN2YlpHTEZtd3JJQVNhbk5pd3VHdU96YzZHZWRzbVZSL1VFRE96d0dtV0xV?=
 =?utf-8?B?YnRLaFhCUTZtYzdIaDhBQmx2em9wRVQzQXhGOGMyMWpWZUdudDMvcUZ4QUJi?=
 =?utf-8?B?aHlKdUd4djVjRHV1RzB6cWlGOW9hQVY3Y3hGZ3NUZXBzVEdYYnR3NWJNMC8z?=
 =?utf-8?B?U08xdE5XNk1zcTdNdDZFTjBleEYzcTNnWGRXSWJkYjU2ZlRNb3FXZ3I5SjNh?=
 =?utf-8?B?OEJ3dlhBQWxPc2I3dHcxdjFVSWh3aFRnTEpLRGo3cHZEdDI5VytWSzByaGtw?=
 =?utf-8?B?UEM0bVNDOUpuL3pxOXZybjEvbURsT0lkZjVlM1VMVUZpR1JhYnpxYm1nd1BI?=
 =?utf-8?B?UXdDVlBRQitYR1JLWXhqQS9EZmllVm5pRVZjQUlRciswdVUvYmU1V2hRVEFW?=
 =?utf-8?B?c1h0THVLdHAreTFWcUFiSzJJTlpkQkIxVHN1WTJVdklSaGtYVUpUSlYwRDJL?=
 =?utf-8?B?c1U2NlVzRlIyeFZXV2hHaTJNQ24wYzl0eEkxUTJqMXFnVDlMYlpHcEU3aTIv?=
 =?utf-8?B?V3dPZ2NZQ3dvUjBWOFF4eHk3bXJRbmJ6aVc2RUxYc3FoeXhBMEhGcE1CeWwv?=
 =?utf-8?B?Mk1wa1o5RVFTeU11R3dobm04TDVER1dQSjYxejdDeEVYL0pJenBpb1lkVnNM?=
 =?utf-8?B?Sk4yTDNMa2ZBZWRZRmZUbXhaMTJwd1VkQ2xRWkFYdXJUWUhtREE3U1FUK0Fu?=
 =?utf-8?B?cFMvMnhmcFFiaFhrTTNBdnNyUllkRzVtTHY1b1ZpRHlnQm13UmNMajY1Ym41?=
 =?utf-8?B?WFJ3eStrRllkcEt4QUk2WG5aQ2x4VFlkak9FUnpDOG5jcGJRVzVXVmxBMlpr?=
 =?utf-8?B?cGdrQjRxWENDZ2kzcU5MdTJXdHdieFVYQVNRSEdMcXJodHZ1cGlPdTgyN1BO?=
 =?utf-8?B?MzNSdkhWWFBaNzJCRjBzQ1A0b2RQa1ZaTE5pdngxSzZWMGZuem1vSTEvczMv?=
 =?utf-8?B?a1V1SFZXWXF5ZWF6MHZNQ05CMlJ2WE4zMWlmUDBJTmVyN2hsRXhJRGdyK01i?=
 =?utf-8?B?c2NTdnZiRCtLOEphYnVhcWxkN3ZXZDlsaXU0UHBXaUZMMi8vVzNZczA4YUZX?=
 =?utf-8?B?N29MVkNOUVVTWjdrRVVRUnpFV1RFR0hHdTBvQXNvMXVHcTUxT29hWk5VcFFk?=
 =?utf-8?B?aHJ2b1Nkc29HOG1SRmtDVkNHK21iQlZxa3I0ak9kQnFTVjdRNG5UeXh0ZHJF?=
 =?utf-8?B?WFNVVG5qSXl2Tm9uQWR4YWJ1SW1HTW8vQ2JSSGxLZFJadFQ2dG1FdjlEUit4?=
 =?utf-8?B?TUh2SnJhQ3RLYVp4UWRFMUx4eTdWY3cyRm45eDA3U09PWk9xTVdmS2pRMExB?=
 =?utf-8?B?MVJxOHpoZGJLd1BVUWhPeVRQNk56elVvWW92VzdxNlNrQkMzMncxdnQ0M3Aw?=
 =?utf-8?B?UEdhc3NmNm5xcnJhdjVacE5GeUNzYzVRZ215VWhjcHk0ZG5HUXpOUktDTFM1?=
 =?utf-8?B?TTdjMVIwWTlwOEFScUxPeFVwQU1QMzVnZ0VmZXgwdHlvUHo2ckY5Vlp2TlBM?=
 =?utf-8?B?MnRyMytjOG9CTk1sSzAxQ3J2TGxoYVFsWk0xbk9lWEZmWWpzTUhXT3owV2hq?=
 =?utf-8?B?OVM0ajUxZDhHczRmZlZvUXUwbW1pNlJTNEdrc2ZxdkM1NSthbUs5K1NaeDZD?=
 =?utf-8?B?Y3hFdWZUZkdsamxiRWU5N1FPU29FL2hxOWJTM05oejBSb05zTGFuS054OWpV?=
 =?utf-8?B?dHFpOGh6K3NpV3hSSTZHWk5DN3BiYVNNK3h3MElIVWlqUjdpQnZFUFU4YjlX?=
 =?utf-8?B?TTJoYTBVNytJOW9iZ0ZCSW1tL3hEamJWbjVObTBIR1RDUUtmcTBsd3F2emJM?=
 =?utf-8?B?SXJ2bm1QYkF2YjBVVG9UZEtneUdhNnBEc1R3TnRxeTc2U0tQejVVeFhBemJS?=
 =?utf-8?B?RVN2RC93dVRKVUQvMTQ2bmFtZUxIZVJ3bm82OElYckthUG0wVkdEcDJ4L2pG?=
 =?utf-8?B?emswSkMvTVg1T0ZPcTUyaXVBN2lnakUvM1pPaVdvN1RFQWZib2JtRStUYmZI?=
 =?utf-8?B?OTQ1aHMxQXhra29YUE8vMTF2bXpRd2JBN2JhUk5UYjBWS1llZUcvSWVpVWdC?=
 =?utf-8?Q?Z9ZMcm2cvErQU1Yu5j7JEpIAcgDTvhBPI5BeimM5YRuO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2FA3A5AE066AA448C9CD925536F89DE@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b03be482-49e4-4061-faf5-08db534cec3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2023 00:56:44.8898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 34Q9z1xfgnuMUldS8f3V1snFoJqFpFQEa19gMQm/TxpycrDDDo3m9Nld0MsHSFJEe42rVBzHXTWwXVBXvgKvNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797

T24gNS8xMi8yMyAxMDoxNCwgSXJhIFdlaW55IHdyb3RlOg0KPiBDaGFpdGFueWEgS3Vsa2Fybmkg
d3JvdGU6DQo+PiBBbGxvdyB1c2VyIHRvIHNldCB0aGUgUVVFVUVfRkxBR19OT1dBSVQgb3B0aW9u
YWxseSB1c2luZyBtb2R1bGUNCj4+IHBhcmFtZXRlciB0byByZXRhaW4gdGhlIGRlZmF1bHQgYmVo
YXZpb3VyLiBBbHNvLCB1cGRhdGUgcmVzcGVjdGl2ZQ0KPj4gYWxsb2NhdGlvbiBmbGFncyBpbiB0
aGUgd3JpdGUgcGF0aC4gRm9sbG93aW5nIGFyZSB0aGUgcGVyZm9ybWFuY2UNCj4+IG51bWJlcnMg
d2l0aCBpb191cmluZyBmaW8gZW5naW5lIGZvciByYW5kb20gcmVhZCwgbm90ZSB0aGF0IGRldmlj
ZSBoYXMNCj4+IGJlZW4gcG9wdWxhdGVkIGZ1bGx5IHdpdGggcmFuZHdyaXRlIHdvcmtsb2FkIGJl
Zm9yZSB0YWtpbmcgdGhlc2UNCj4+IG51bWJlcnMgOi0NCj4gSSdtIG5vdCBzZWVpbmcgYW55IGNv
bXBhcmlzb24gd2l0aC93aXRob3V0IHRoZSBvcHRpb24geW91IHByb3Bvc2U/ICBJDQo+IGFzc3Vt
ZSB0aGVyZSBpcyBzb21lIHBlcmZvcm1hbmNlIGltcHJvdmVtZW50IHlvdSBhcmUgdHJ5aW5nIHRv
IHNob3c/DQoNCm5vdCBuZWVkZWQgc2VlIGJlbG93Lg0KDQo+DQo+PiAqIGxpbnV4LWJsb2NrIChm
b3ItbmV4dCkgIyBncmVwIElPUFMgIHBtZW0qZmlvIHwgY29sdW1uIC10DQo+Pg0KPj4gbm93YWl0
LW9mZi0xLmZpbzogIHJlYWQ6ICBJT1BTPTM5NjhrLCAgQlc9MTUuMUdpQi9zDQo+PiBub3dhaXQt
b2ZmLTIuZmlvOiAgcmVhZDogIElPUFM9NDA4NGssICBCVz0xNS42R2lCL3MNCj4+IG5vd2FpdC1v
ZmYtMy5maW86ICByZWFkOiAgSU9QUz0zOTk1aywgIEJXPTE1LjJHaUIvcw0KPj4NCj4+IG5vd2Fp
dC1vbi0xLmZpbzogICByZWFkOiAgSU9QUz01OTA5aywgIEJXPTIyLjVHaUIvcw0KPj4gbm93YWl0
LW9uLTIuZmlvOiAgIHJlYWQ6ICBJT1BTPTU5OTdrLCAgQlc9MjIuOUdpQi9zDQo+PiBub3dhaXQt
b24tMy5maW86ICAgcmVhZDogIElPUFM9NjAwNmssICBCVz0yMi45R2lCL3MNCj4+DQo+PiAqIGxp
bnV4LWJsb2NrIChmb3ItbmV4dCkgIyBncmVwIGNwdSAgcG1lbSpmaW8gfCBjb2x1bW4gLXQNCj4+
DQo+PiBub3dhaXQtb2ZmLTEuZmlvOiAgY3B1ICA6ICB1c3I9Ni4zOCUsICAgc3lzPTMxLjM3JSwg
IGN0eD0yMjA0Mjc2NTkNCj4+IG5vd2FpdC1vZmYtMi5maW86ICBjcHUgIDogIHVzcj02LjE5JSwg
ICBzeXM9MzEuNDUlLCAgY3R4PTIyOTgyNTYzNQ0KPj4gbm93YWl0LW9mZi0zLmZpbzogIGNwdSAg
OiAgdXNyPTYuMTclLCAgIHN5cz0zMS4yMiUsICBjdHg9MjIxODk2MTU4DQo+Pg0KPj4gbm93YWl0
LW9uLTEuZmlvOiAgY3B1ICA6ICB1c3I9MTAuNTYlLCAgc3lzPTg3LjgyJSwgIGN0eD0yNDczMA0K
Pj4gbm93YWl0LW9uLTIuZmlvOiAgY3B1ICA6ICB1c3I9OS45MiUsICAgc3lzPTg4LjM2JSwgIGN0
eD0yMzQyNw0KPj4gbm93YWl0LW9uLTMuZmlvOiAgY3B1ICA6ICB1c3I9OS44NSUsICAgc3lzPTg5
LjA0JSwgIGN0eD0yMzIzNw0KPj4NCj4+ICogbGludXgtYmxvY2sgKGZvci1uZXh0KSAjIGdyZXAg
c2xhdCAgcG1lbSpmaW8gfCBjb2x1bW4gLXQNCj4+IG5vd2FpdC1vZmYtMS5maW86ICBzbGF0ICAo
bnNlYyk6ICBtaW49NDMxLCAgIG1heD01MDQyM2ssICBhdmc9OTQyNC4wNg0KPj4gbm93YWl0LW9m
Zi0yLmZpbzogIHNsYXQgIChuc2VjKTogIG1pbj00MjAsICAgbWF4PTM1OTkyaywgIGF2Zz05MTkz
Ljk0DQo+PiBub3dhaXQtb2ZmLTMuZmlvOiAgc2xhdCAgKG5zZWMpOiAgbWluPTQzMCwgICBtYXg9
NDA3MzdrLCAgYXZnPTkyNDQuMjQNCj4+DQo+PiBub3dhaXQtb24tMS5maW86ICAgc2xhdCAgKG5z
ZWMpOiAgbWluPTEyMzIsICBtYXg9NDAwOThrLCAgYXZnPTc1MTguNjANCj4+IG5vd2FpdC1vbi0y
LmZpbzogICBzbGF0ICAobnNlYyk6ICBtaW49MTMwMywgIG1heD01MjEwN2ssICBhdmc9NzQyMy4z
Nw0KPj4gbm93YWl0LW9uLTMuZmlvOiAgIHNsYXQgIChuc2VjKTogIG1pbj0xMTIzLCAgbWF4PTQw
MTkzaywgIGF2Zz03NDA5LjA4DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQ2hhaXRhbnlhIEt1bGth
cm5pIDxrY2hAbnZpZGlhLmNvbT4NCj4+IC0tLQ0KPj4gICBkcml2ZXJzL252ZGltbS9wbWVtLmMg
fCA2ICsrKysrKw0KPj4gICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspDQo+Pg0KPj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZkaW1tL3BtZW0uYyBiL2RyaXZlcnMvbnZkaW1tL3BtZW0u
Yw0KPj4gaW5kZXggY2VlYTU1ZjYyMWNjLi4zOGRlZmU4NGRlNGMgMTAwNjQ0DQo+PiAtLS0gYS9k
cml2ZXJzL252ZGltbS9wbWVtLmMNCj4+ICsrKyBiL2RyaXZlcnMvbnZkaW1tL3BtZW0uYw0KPj4g
QEAgLTMxLDYgKzMxLDEwIEBADQo+PiAgICNpbmNsdWRlICJwZm4uaCINCj4+ICAgI2luY2x1ZGUg
Im5kLmgiDQo+PiAgIA0KPj4gK3N0YXRpYyBib29sIGdfbm93YWl0Ow0KPj4gK21vZHVsZV9wYXJh
bV9uYW1lZChub3dhaXQsIGdfbm93YWl0LCBib29sLCAwNDQ0KTsNCj4+ICtNT0RVTEVfUEFSTV9E
RVNDKG5vd2FpdCwgInNldCBRVUVVRV9GTEFHX05PV0FJVC4gRGVmYXVsdDogRmFsc2UiKTsNCj4g
TW9kdWxlIHBhcmFtZXRlcnMgc2hvdWxkIGJlIGF2b2lkZWQuICBTaW5jZSBJJ20gbm90IGNsZWFy
IG9uIHRoZQ0KPiBwZXJmb3JtYW5jZSBiZW5lZml0IEkgY2FuJ3QgY29tbWVudCBvbiBhbHRlcm5h
dGl2ZXMuICBCdXQgSSBzdHJvbmdseQ0KPiBzdXNwZWN0IHRoYXQgdGhpcyBjaG9pY2UgaXMgbm90
IGdvaW5nIHRvIGJlIGRlc2lyZWQgZm9yIGFsbCBkZXZpY2VzDQo+IGFsd2F5cy4NCj4NCj4gSXJh
DQoNCm1lIG5laXRoZXIgdGhhdCBpcyB3aHkgSSd2ZSBhZGRlZCBzaW5jZSBJIGRvbid0IGhhdmUg
YWNjZXNzIHRvDQphbGwgdGhlIGRldmljZXMgYW5kIEkgY2Fubm90IGNvdmVyIGFsbCB0aGUgY2Fz
ZXMgdG8gZ2VuZXJhdGUNCnF1YW50aXRhdGl2ZSBkYXRhLCBzZW5kaW5nIG91dCB2MiB3aXRob3V0
IG1vZCBwYXJhbS4NCg0KLWNrDQoNCg0K
