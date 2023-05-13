Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62518A2C
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 00:58:20 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+UQV4KD/DjW8lfLWIcC0Wx54EGRe2DySvCB+uMs/WMawxTd2gaKZRTdlMjP1LVDhCkBR2K5JThWv3NTxYxzBJNVU3/evbz+yPM81A8Hn0szIB60yEDs/e+5vFSnNgnzmSYbAlWg2kMEA5hS7oyQtXSLskItdXvYaFW5IclmmBYpK+4EbAVUKrEK+SavCHP9XG2d0bG7REslN4/6+sObu+11/yELz/udtXFIdWnsteGI49xlaRCOHdAjYQdBMUJ8lhrFkGUgZjmoE+uO4TRlIwl3gacrTv9LmT5LLEumLo+jrjzMbJfqMVNDrwkm5QeNuXoZgjD92gRgGkE8Lvl9Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r68kPxCHL07by4celwj6Suh7ecDBRYWndxd5XyWdTtE=;
 b=g1mmUWlnTvfV20yYuyw2epf3o8wG8FhnhmQP11q8jdLTNjUeqY6z8g2UemtOPX9mNSMjCxguLGrAL5BKw2uUNRlpYTGLTiZBpRE49/uL/YqGWZm77SJ29bUVGIZa6eqTGibH7nZe9+IvDeBoBdjBPNcQnXnGEsHkEd5goG7NoHlgSTi8GnEfiWMou1A3uJJIEvLZFvVZN67cstzCKVBvctjvbgvlv1mramChXUd+YGZV1Ak9PHJIwrgWfseviwz+N2/CbdBtsrq0MIy9imBjB0q+S5i3MjN/3MH0FGUYrh5NJPuXL08qrrx8wME3UBfrlD3s1p0pBOk5foHHnYiM3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r68kPxCHL07by4celwj6Suh7ecDBRYWndxd5XyWdTtE=;
 b=QtDX53buNjTDlyiuATYfbzs4YtgkBM4bQPb5XSNkDIDb4NTgkbsScohoQerFJLCCSElM7y6ZgwFSGTP/PZPLXGaVUm6PMsTmmLDl5CweUJrsg+Dd5gtd7Guq5lsLmrrGzHSUA1N1tMNpzGmOMlJ8VeGv9K5WE5Obym/FwzSLBh4pi+LryVCpB5CAvv83P/qalRW0X8sCOMxsAzBXVKoVMpocsYu/CYqr2G+wFqaA+XnfiHfhbJbUVOhNNr2dw/Hizo9a7MqNeHgrOfjYLbiO1Or9jbzOTYoshioH2W2b5Q1kmwEGIWiA8domJwpCzK3bI0Qcnqz2VZ5QpytN9gBzSQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24; Sat, 13 May
 2023 00:58:17 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc%4]) with mapi id 15.20.6387.021; Sat, 13 May 2023
 00:58:17 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Dan Williams <dan.j.williams@intel.com>, Chaitanya Kulkarni
	<chaitanyak@nvidia.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 1/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Thread-Topic: [PATCH 1/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Thread-Index: AQHZhL6ceVIzisv4Ykq1nZJcI0+iua9W/L2AgABlxIA=
Date: Sat, 13 May 2023 00:58:16 +0000
Message-ID: <77b44173-d5dc-94a0-e9fd-58afd3cc7fe3@nvidia.com>
References: <20230512104302.8527-1-kch@nvidia.com>
 <20230512104302.8527-2-kch@nvidia.com>
 <645e8b49ca74f_1e6f29437@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <645e8b49ca74f_1e6f29437@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|CY8PR12MB7433:EE_
x-ms-office365-filtering-correlation-id: f4ebe577-e865-4369-c5f0-08db534d230a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 PqWBFHWe4L7yvhXw10msWnljPSgrl4ww5c7BaeyJfKFAYh1eDqv15eSgRn5xEKzCBX/KIYyJ5c/IhqoA+w6xFYui7GXbjHI4OOh1/MyEhOQE5qEKlBg6mie7P4/JKUSMnfKVqEEm1WzmjJLEKOUHNGPqt+B1eGvLF+TmcsNUfLB6qW5fuJUdNhyf5ZcSE1IOY3B03BMYrGBI/umHd7PPgGJlIx80QWZrTtejuenPXYJpU0IF04WqSIyo4OCbDr3THqpT+pkMJC0G54ib10uTx+GzRctzdquhCPlnpu5HUmyPZE1p4LeDo5I/wstD6cT8kU/yrwz0uWPGckkXBpgJTAD8WgfCgJuZ4B+xoX+yLuk6cZCZkYgUVfEOlrzeKsS+NL/1JN+5jUBiykZ3SLcbUJKKUnAqi3/t7H60uLuZ3tGJMXzrWrgCwW12X0WIhvnyi5EJtCtmWzwmatV4dqtmJuxeFRnbtkP6szV6qtdeP0nZslFit2jQ8XWpAClh777WuGuVqJzF0gQNaXTL6zLDH2IWiIUDlw24x8108qeLcAaMnVRgBM662o6DbiUNUmi2RFMESceo+zjzORRqKHMvaNOOeJGrf3eGGV0RxxyN/FjQk4rvC/dzMvRq2KAUT5fDzmohB1Mpqq1juXT9gGIFh2lGCF/DIENUe5VskrJFTP1FNY3PeuZvdOPxyPWIoJ9f
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199021)(122000001)(38100700002)(36756003)(38070700005)(31696002)(86362001)(5660300002)(6486002)(316002)(8936002)(8676002)(2616005)(6506007)(6512007)(53546011)(2906002)(66476007)(91956017)(66946007)(66556008)(66446008)(64756008)(76116006)(478600001)(110136005)(41300700001)(31686004)(4326008)(71200400001)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZEdWcjNZb1p5aW1UcEJHMTIzQzBOSE9tay9NSDRZVjgzejBaY0VjWXRoZm1V?=
 =?utf-8?B?d1J2WUdUQUpIeHplTmZGVXVleUR4a1RFaUlYam1RNlFCTmZsNDJzc29uUFdZ?=
 =?utf-8?B?cFdtL09JL3dweFBCOFdmME5PbmhKMGc5T3VRelJUM3ZSSW5nTXk3UzBUMzJT?=
 =?utf-8?B?MUw0Qkc3K1BDYlpSMENQdlhSNGswQlpMajdqd1kydVptaHFpV21hY0o3SlNF?=
 =?utf-8?B?eXJKSE1hZVJDRGl6cW9SYWRSZDlWa1FBdFFIaW5mY3NQZEQyVE5yTnBoek9p?=
 =?utf-8?B?OUo2VEErU3k2MEtzNFVTaDAvdlJiRjJSNkNYWlNaUmV2Qk04RWlmYWdlRm91?=
 =?utf-8?B?S0pyU3FQVDU1dldycVdyS3lGT1d5bWhCb3I4Wi9HUEYrOGdKeENvY0Jqekc5?=
 =?utf-8?B?QXhYRVUzaTNPT1JKbTZJb2NWNDFSazlDUjNiODViYVN5M1cwK29BVTNZMStC?=
 =?utf-8?B?c1pwQ0RqRlExM3dZREJpdFRaRUg1S2tVTUtYb0hrU2txRXdxdDJpempjRkNi?=
 =?utf-8?B?cGE0SFIxbzVETHZadHg4cmhLQ1F1Qm5YNFN2Z1ZiajYxMUh2b21YOUU3RjUx?=
 =?utf-8?B?MUFQUThsYnhaekxSc1IxcHk0VS94K2c1YVAwZTNRNmY1eE5DT2I5aytvVWVE?=
 =?utf-8?B?dExjZVU5aHY3bkxUVHIzMmEyNXI2aUhzK29LVkx2M3pndDdCc1MwMjVXUExC?=
 =?utf-8?B?aWhNMlZUSFg0MXUzZkFxWHdUSHo1NjQrWk9YNWhCTHdXLzROY3JxcEhoL0lk?=
 =?utf-8?B?R1F2Um04VHZKWDFlNzVNTUFtekxmV01pdnZBcWNGMlRxbVFDdU5xT0ZTTm1B?=
 =?utf-8?B?emhQai9JeHBNUnI2ZUVrNmZLRHdjQ2NxYityZ2RoVmxMSk01a1l0aGJOWTZz?=
 =?utf-8?B?RE5hd0RnMTdKQWRacWNNdjVUL3RYNFN3VEh2WGIvbDdsS1ZBOHlXT2RUZ3l3?=
 =?utf-8?B?VG5qK1o1WU51ZnJ1QWh6aVo0Zi94K0hGUmdYRHpPZ2ZsdU5QczJub001RCtN?=
 =?utf-8?B?UU90WWpTYU96RFJjVHBzRzJWOXFVY29ZcWtjaGxVV3FIRnRCUkJmcmwzMlF3?=
 =?utf-8?B?Sno3UU1oL1VqbVBoV21zTDEzUG1ZaGE0UU1jdmRia05Lc1BkZEM3RjdHay9X?=
 =?utf-8?B?YytiaUpSQktBd2I5dGZES2JNT1o1OU5IdXhqTFhaVjRqRXhIOU9kcW9JREFH?=
 =?utf-8?B?Y0prbWM3Rzg5NXkrY1RyTktUY0J1NGhObEU3dGJnV0xxQmdKVWpVamc3VU13?=
 =?utf-8?B?OXdabnpSL256amhuVElTQk81YVdKQ282QVVhbExwNkgzOHpoNW5WY2wrdkpY?=
 =?utf-8?B?OWlrYTJYWVEzNHRrSkhFOUFHL3RjQWhuV0xEOFFDMDM0Z1BEQmQ5T2JoTFJF?=
 =?utf-8?B?VHdFUkJKVjlQVEJHSDd3Uy9VLzFUWnlUVXpReXZpL3V1aEpyNC8vaFEzQ2Fk?=
 =?utf-8?B?NFVXbVIrYlZVQTk0Y0hrODBEalFkbVQ2L1o0MnA1QlI2RVgzdmhKYkd6VUFw?=
 =?utf-8?B?VjZ4QUJFZk9ZeStzdDB4UDlFdVpuK3VMYXUzT3UrZ1NxemhDQUxrSDVMVXNH?=
 =?utf-8?B?cnFCQitPZmJjUzVkNjM0bmdWcVBSR21ucjJyc3JpY21FbTlFWWZRV1F6NC9t?=
 =?utf-8?B?STY3V01rcmhBYm1kcFd0R1QyVzBVazlLYUY5d2c3NG1aZTd0NmFnR0M4N0ZC?=
 =?utf-8?B?eWtXUzY4eE5ia1hFejBCVUFncDJQVk9peXpXRHB1eHhVZlZBODhDc00rbTZx?=
 =?utf-8?B?MmhZM3NUbW9ZTTY3VW9IL1VrQ0tpR1FNQ3ZJSHBiNzNLL0lrMVVXbURha1JU?=
 =?utf-8?B?WUY4TVpHQnNiOXJCNkNPODdsNEtEZFlHS2x4a3JLSWFDTHJycFg3ckx4L2JN?=
 =?utf-8?B?QXhGNnA4SlNZYUVaLzRJL2RjL0tQeE5RdDRLWCsvekV3SXNwYUg4Z1haV1RX?=
 =?utf-8?B?c2k4YktXTUtaVjZzS1Z0VWNiMFlWSWh0KzRnSm8vYXlRMjFPczBXVmZ0TlMz?=
 =?utf-8?B?WGhVUEk3TWpVRmluYWlxRk5LVWhYT2xRdDNtblVVNmkyelpQbFQvemZxbnV4?=
 =?utf-8?B?eDJVUDY0SjMxYjMrKzNFNFhPSklvZnVNemJRMDVsS2hCeUc2RFJNUE4yazB6?=
 =?utf-8?B?RitpWXc2YlpmVlhzWnlsT0diRnRzUmhYd2xNanBkQ0QxWUtyeFBsbkxmVTBF?=
 =?utf-8?Q?DNS65d+Qkopn8mrbEK0Mf79AxlLriCnMAehQb3fdBrjY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <036FC3098F5A21468F32BB111A2E6C47@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f4ebe577-e865-4369-c5f0-08db534d230a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2023 00:58:16.8356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /P0kTXeKOfSWLvfHKw1ZVVQdCksJKUIBIOG7yWz+Ktd+9es/winrWyvtcs4goD/SmziZ4leLceIaL5ykeswlhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7433

T24gNS8xMi8yMyAxMTo1NCwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPiBDaGFpdGFueWEgS3Vsa2Fy
bmkgd3JvdGU6DQo+PiBBbGxvdyB1c2VyIHRvIHNldCB0aGUgUVVFVUVfRkxBR19OT1dBSVQgb3B0
aW9uYWxseSB1c2luZyBtb2R1bGUNCj4+IHBhcmFtZXRlciB0byByZXRhaW4gdGhlIGRlZmF1bHQg
YmVoYXZpb3VyLiBBbHNvLCB1cGRhdGUgcmVzcGVjdGl2ZQ0KPj4gYWxsb2NhdGlvbiBmbGFncyBp
biB0aGUgd3JpdGUgcGF0aC4gRm9sbG93aW5nIGFyZSB0aGUgcGVyZm9ybWFuY2UNCj4+IG51bWJl
cnMgd2l0aCBpb191cmluZyBmaW8gZW5naW5lIGZvciByYW5kb20gcmVhZCwgbm90ZSB0aGF0IGRl
dmljZSBoYXMNCj4+IGJlZW4gcG9wdWxhdGVkIGZ1bGx5IHdpdGggcmFuZHdyaXRlIHdvcmtsb2Fk
IGJlZm9yZSB0YWtpbmcgdGhlc2UNCj4+IG51bWJlcnMgOi0NCj4gTnVtYmVycyBsb29rIGdvb2Qu
IEkgc2VlIG5vIHJlYXNvbiBmb3IgdGhpcyB0byBiZSBvcHRpb25hbC4gSnVzdCBsaWtlDQo+IHRo
ZSBicmQgZHJpdmVyIGFsd2F5cyBzZXRzIE5PV0FJVCwgc28gc2hvdWxkIHBtZW0uDQoNCnllcywg
c2VuZGluZyBvdXQgdjIgd2l0aG91dCBtb2QgcGFyYW0uDQoNCj4NCj4+ICogbGludXgtYmxvY2sg
KGZvci1uZXh0KSAjIGdyZXAgSU9QUyAgcG1lbSpmaW8gfCBjb2x1bW4gLXQNCj4+DQo+PiBub3dh
aXQtb2ZmLTEuZmlvOiAgcmVhZDogIElPUFM9Mzk2OGssICBCVz0xNS4xR2lCL3MNCj4+IG5vd2Fp
dC1vZmYtMi5maW86ICByZWFkOiAgSU9QUz00MDg0aywgIEJXPTE1LjZHaUIvcw0KPj4gbm93YWl0
LW9mZi0zLmZpbzogIHJlYWQ6ICBJT1BTPTM5OTVrLCAgQlc9MTUuMkdpQi9zDQo+Pg0KPj4gbm93
YWl0LW9uLTEuZmlvOiAgIHJlYWQ6ICBJT1BTPTU5MDlrLCAgQlc9MjIuNUdpQi9zDQo+PiBub3dh
aXQtb24tMi5maW86ICAgcmVhZDogIElPUFM9NTk5N2ssICBCVz0yMi45R2lCL3MNCj4+IG5vd2Fp
dC1vbi0zLmZpbzogICByZWFkOiAgSU9QUz02MDA2aywgIEJXPTIyLjlHaUIvcw0KPj4NCj4+ICog
bGludXgtYmxvY2sgKGZvci1uZXh0KSAjIGdyZXAgY3B1ICBwbWVtKmZpbyB8IGNvbHVtbiAtdA0K
Pj4NCj4+IG5vd2FpdC1vZmYtMS5maW86ICBjcHUgIDogIHVzcj02LjM4JSwgICBzeXM9MzEuMzcl
LCAgY3R4PTIyMDQyNzY1OQ0KPj4gbm93YWl0LW9mZi0yLmZpbzogIGNwdSAgOiAgdXNyPTYuMTkl
LCAgIHN5cz0zMS40NSUsICBjdHg9MjI5ODI1NjM1DQo+PiBub3dhaXQtb2ZmLTMuZmlvOiAgY3B1
ICA6ICB1c3I9Ni4xNyUsICAgc3lzPTMxLjIyJSwgIGN0eD0yMjE4OTYxNTgNCj4+DQo+PiBub3dh
aXQtb24tMS5maW86ICBjcHUgIDogIHVzcj0xMC41NiUsICBzeXM9ODcuODIlLCAgY3R4PTI0NzMw
DQo+PiBub3dhaXQtb24tMi5maW86ICBjcHUgIDogIHVzcj05LjkyJSwgICBzeXM9ODguMzYlLCAg
Y3R4PTIzNDI3DQo+PiBub3dhaXQtb24tMy5maW86ICBjcHUgIDogIHVzcj05Ljg1JSwgICBzeXM9
ODkuMDQlLCAgY3R4PTIzMjM3DQo+Pg0KPj4gKiBsaW51eC1ibG9jayAoZm9yLW5leHQpICMgZ3Jl
cCBzbGF0ICBwbWVtKmZpbyB8IGNvbHVtbiAtdA0KPj4gbm93YWl0LW9mZi0xLmZpbzogIHNsYXQg
IChuc2VjKTogIG1pbj00MzEsICAgbWF4PTUwNDIzaywgIGF2Zz05NDI0LjA2DQo+PiBub3dhaXQt
b2ZmLTIuZmlvOiAgc2xhdCAgKG5zZWMpOiAgbWluPTQyMCwgICBtYXg9MzU5OTJrLCAgYXZnPTkx
OTMuOTQNCj4+IG5vd2FpdC1vZmYtMy5maW86ICBzbGF0ICAobnNlYyk6ICBtaW49NDMwLCAgIG1h
eD00MDczN2ssICBhdmc9OTI0NC4yNA0KPj4NCj4+IG5vd2FpdC1vbi0xLmZpbzogICBzbGF0ICAo
bnNlYyk6ICBtaW49MTIzMiwgIG1heD00MDA5OGssICBhdmc9NzUxOC42MA0KPj4gbm93YWl0LW9u
LTIuZmlvOiAgIHNsYXQgIChuc2VjKTogIG1pbj0xMzAzLCAgbWF4PTUyMTA3aywgIGF2Zz03NDIz
LjM3DQo+PiBub3dhaXQtb24tMy5maW86ICAgc2xhdCAgKG5zZWMpOiAgbWluPTExMjMsICBtYXg9
NDAxOTNrLCAgYXZnPTc0MDkuMDgNCj4gQW55IHRob3VnaHRzIG9uIHdoeSBtaW4gbGF0ZW5jeSB3
ZW50IHVwPw0KDQpyZWFsbHkgbm90IHN1cmUgd2h5LCB3aWxsIG5lZWQgc29tZSBtb3JlIHRpbWUg
dG8gaW52ZXN0aWdhdGUgdGhhdCAuLg0KDQotY2sNCg0KDQo=
