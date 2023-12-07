Received: from esa16.fujitsucc.c3s2.iphmx.com (esa16.fujitsucc.c3s2.iphmx.com [216.71.158.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B1F13AD6
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 09:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="X0fNL2sc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1701939701; x=1733475701;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=K6HHMMar7bwa/5HmNF81yYaQ7Cse18T+T02+pM78C50=;
  b=X0fNL2scFlXxONkxwtpypFagAkcdZef9pJWgSVfsPNnjIHC1D6oQ0p/m
   qAkiMUQjrYT7+WDwrjxhKLS0m1DG0zwmO1pG3SGpvfM/8CQSvPlJCSblt
   E+HvsK8MlaZ+d/UoLUFY0o15VR/BQoVd5ahzl80MJAGpp02sAQ9mqEYZP
   0vmtffKlpUSH7o9KsuhvQPRUtS+SCl/nslwcfuISTDwn6wSB31asndnOL
   4pEdi9NMjPH6vN1VTZ1JNq4E/i/TNJtJ2YTBqWWIsjNuE1NY6fFzYx5XQ
   weDO8Hit7YNnSRzRy2I742YVEqvr5sF4fvOoyC1CQQ+X36yBaLDC/GHLy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="104957366"
X-IronPort-AV: E=Sophos;i="6.03,238,1694703600"; 
   d="scan'208";a="104957366"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 18:00:27 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQTjSekWhfq25+DRP1rI1F6FAnjLIuCnsy5cBKQHx7w6fYBkAIhf/v0vH4z9WV6O5pIIcojYYwyldy/JEuoSZ6ZzQ0kjcCJP1nKprMfmniwkyTBzA60/QXY/5FjJvpPHLWy/k4NyhNVq16+jPwIV6V6Y8tMC++lwJB3wjMZgDfGMGo/gJiTG02XPSZn6Rgjz/D0Mdb16mok1h/nFcsUkWy7l3y7skIE7gyFKCGrIWq6rEdNkg/GSKPiVMo57hNCA6SeZmO30Kc2mUW1wzy2ylaqNApi36VfeVrni0sldADfFKFS3VZDTxdVcQk/JzZKKIZlI6rxBNWYtlyvha4wmnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6HHMMar7bwa/5HmNF81yYaQ7Cse18T+T02+pM78C50=;
 b=XuqIEBG9sPq8ncIBe7kkpreVOZLgR+7t3lt+/HxHBjTY7KrzatfVokhyiIteAKyiEGDBM/c3jYsfvtHZX+o9ERffuwwguqEQ1mnOK7yjs2SFSG0C59fU8UxWnG0WLcHnTm9rzJH3UhWepmkXtZbsd/tC4pgeoDKRXWPIXbppENxKAvw8lE7ydiw8JAXE51NJOxtKwFOxGfW9bRXhfv22kwEFfoHwFP8dSnBY864gdhCtuw6WZ3fkpQ3ggIrBgNNJTB4cGyRkrfWRuSrvOe9LU5FI5k6UC2ZEAykmrifiZMNc1vEllWeY4YEDAlouOX6Ulkcf4cfeOO8MY1DPIY2TXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com (2603:1096:604:a6::10)
 by TYCPR01MB9323.jpnprd01.prod.outlook.com (2603:1096:400:199::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 09:00:23 +0000
Received: from OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50]) by OS0PR01MB5442.jpnprd01.prod.outlook.com
 ([fe80::c96f:52b0:dd4e:8d50%6]) with mapi id 15.20.7046.034; Thu, 7 Dec 2023
 09:00:23 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dan Williams <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 2/3] test/cxl-region-sysfs.sh: use operator '!=' to
 compare hexadecimal value
Thread-Topic: [ndctl PATCH 2/3] test/cxl-region-sysfs.sh: use operator '!=' to
 compare hexadecimal value
Thread-Index: AQHaHbUkVH/gex/saUKoNLEFdh2f/7Cc3PiAgAC/OQA=
Date: Thu, 7 Dec 2023 09:00:23 +0000
Message-ID: <8c94d1b6-1dd6-465b-906d-4f65cd992619@fujitsu.com>
References: <20231123023058.2963551-1-lizhijian@fujitsu.com>
 <20231123023058.2963551-2-lizhijian@fujitsu.com>
 <6570e93b1dd74_45e0129427@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <6570e93b1dd74_45e0129427@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5442:EE_|TYCPR01MB9323:EE_
x-ms-office365-filtering-correlation-id: 930db74c-ff54-4517-6ff1-08dbf702f27b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 /USjbB9bYThENx1Kt2GPdk2iY/uf0o9te0+Ojrnd5zSXISn0A2c8RYlCv+zI5wiM9qlYaI/NfnxwPApAtrkJNrup4PNSf+Lmesj8or6JYoIYM+QDoG6LvAauWbjzjxsu4i9yTENDQGOasrw91Or2z7gLmwNaZlYSlgb6nBWHoyZJ1cyIrJSZuMCDcWLYjSmgdSwurgP06gXRCLSFQwHg2GCIjwJR5Qrh1iQ9lbpMtGDuweZfyUA99nLgBirF6WthfZx2Kf3Cx0d1Z10jdRweLgTVWf0BERxKZ6XNMcblYpeJpOOMVxzOjg3xTsNqTULotq8UtVkeD+YngUi0NapufPiyMIB+1/RQMkqnQQCE4URUvAIVPl5jSSp8QciFLWbr76RiDGoht71ATDk3YYi6l7x+la8YDioITSFCHcdGAzxxR1J6zBQ6zy7yYNdMWNflejLZwBzRxEdbav1bEoEnA4qeyYAmbH+jcfSjOn5XApJnyKm2OEh4kJX96Z9F5Eu00osRakutgLJp/IyQClv9dxXHQKx1FR2sFR+6iUAW5In7YXiq4KMXHfsAbOW43QelHDGLguydNuQLITdBkyfVi95mmYGJMTwx94jd0H2GZwcrzciYMYY/9/h8X+3lOpzu+sjMDm94vmZ3sunJaiV50oLydhTqrMMEx/2+A6rCTW/MGl4jfPkgb2A+4XqVTcoj7uetZaa7mvwF8yvhgVhgzQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5442.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(39860400002)(366004)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(1590799021)(6512007)(82960400001)(38100700002)(83380400001)(26005)(31686004)(6506007)(2616005)(53546011)(122000001)(71200400001)(478600001)(6486002)(4326008)(85182001)(66946007)(66556008)(64756008)(76116006)(66476007)(91956017)(316002)(110136005)(1580799018)(8676002)(66446008)(8936002)(31696002)(2906002)(38070700009)(36756003)(41300700001)(86362001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TjIzRkFWYVFFbGY5c3FSZDhST3lVaXB4RDEvN2xUVlpDYzZKb25TMWRBc2o4?=
 =?utf-8?B?NHJ1cGNORktUT3JhUE5qMVJQNmYwU1U2dlN4RVAyc05BNHRsR3QrWlU1ZDd3?=
 =?utf-8?B?UEZJZVJjNGtkRTVDNlA5SlFvQlhtVlpSOU1GSmFzMjlPZXVjQk5iOUpJYTR2?=
 =?utf-8?B?dXRmUG0wQ3l6enR0K1VjYkhVTUpsMzFrMlRsdVZYdnVqdkdESXJzTlVNMnZ5?=
 =?utf-8?B?SnRQYkRSYzJCbTlnakpYSW54ZU85a2g2MHBsZUFET2g4QitvNkVMZ3ZsbzIr?=
 =?utf-8?B?N0E0S0VoTmZhQ2hHYmUva3ZGYmNVMGU1WC9ZSnBCNGI5SHlMV012Q3VXNCtL?=
 =?utf-8?B?RHB2enBkQXYwcUVEVVUvY1EwaGZlWGwyU1h5MXMweXRieVVLZTRjdzlyK1cx?=
 =?utf-8?B?ZUdXZkNFWnNPUFJaR0E2azIzYnZ4cFZUWkRBaVpYNEFMQ3pSQmZ6TU5BK2hH?=
 =?utf-8?B?RHhWblpLREZ4NytXdjUxOHZmSTd3ajVNVUxzaitJcWhvd0F6ck1vV2oyaGpz?=
 =?utf-8?B?YXdIY1ptRS93amFQZXBiL1ZtMTAraW9ITWtpOXlaQzBvTmJ3YTNEVkYxVksx?=
 =?utf-8?B?cWVpc2w0YkttcU5oWkkvUnJvYllLZ25Kd0VkNy9LS09pQUZZZXNUalRtY3Ev?=
 =?utf-8?B?SVlWVWZ3ZitmdE5sK3RjTCtkLzQ3NjEyajUzZmFlTkNZWkc3NkROTFNJU3JK?=
 =?utf-8?B?U0VveUc1UkxHVjZKRi9mV3NGa2NuazBRT1VKd2xheTR4RFJyRmIxeWhBdEs1?=
 =?utf-8?B?RWZqeVBFSEIyTDdpUlUxYWNpVm55UDFwaGtrUmF5SkpxVFhWaExmQUFZbXNI?=
 =?utf-8?B?cDFjanFJNUxDK2ZDV2E0STU2bUlOa041cE9jS2tnbzg4bGpyM1ozVGpJMlc5?=
 =?utf-8?B?RDRkNURJc0xNSy9SZS80OFpZdXgxQ2gvTEI0OWJZbDhNbVlHRHE2QmNHNW51?=
 =?utf-8?B?RWRUalhGSlFKTWs2dnpwdTZ0Z3FhdE92UFJ3a3hKdGZhY2pnczhjUlZKZWIy?=
 =?utf-8?B?Z0N1T1BFbUNXaXZrMWk1QVpQVm5wdVZOM3RuYmEyQ3JEUEc2UERySE05U2k2?=
 =?utf-8?B?VWxGTk1Qdmt3S2RHcHROWDhEV25rbERpeC92c0Z5a0N3UHhKMnI3T2haMWJh?=
 =?utf-8?B?blBSMG94Y25qRmI2eWhsaFZqb2s1YWQxNzlvc2MwanREcCtEU05mbUt1UXRJ?=
 =?utf-8?B?MUxvRlgvdFFFempkcUh5eGJXaG55VHBJWTFiU3dPem0xdDhlZVViWm1MR1JF?=
 =?utf-8?B?V0pleE1ia0RDZjZxNldZN2dlaWlnRG41U2ZKdEZzRGhsUlF5a3M2cGFmSC9v?=
 =?utf-8?B?ckhKZW55R3NZNU9pcUtUdFd5Qkg1Q2NuQ0tZTkFLMXJLODdwcVRiaVN6K1BI?=
 =?utf-8?B?K0tsaE1janROYjRJSyttS3BHL3RieUxvaHlSRmlsZ0lya0NCV0pJYitoY0xp?=
 =?utf-8?B?cTZETDZQWTJWZHQzTGxERENWZkIxMkVuSGQ4T2pnZGFXMXgxUGE2THc3SEpH?=
 =?utf-8?B?VUJHMk9GQVlMR3NKNThIRVYyRG9FTFRNdlRWNmFVQ0lzdFE3SkQxUFpDUnVG?=
 =?utf-8?B?RVNTNFhmMWszR2NPYlRpM0hnY25xdEdEanJKaU9ENG45Z2NPQlVubGxDZzla?=
 =?utf-8?B?MnA4Slc1NWJXcC8ra2I5ZnlsMVdwS1BvRWNFL01HVU81MXh1TW00bk5TT1d2?=
 =?utf-8?B?YzVXR0pvaTVraGVyK3R6NGZkb1hiOWcxOC83K0RsQXRmenVib2QyWnBsQ0k3?=
 =?utf-8?B?akw4OXZZNnNwRVVkeUlTQ1RsU1lpY0dXeDRCVXNUMFBhNGd3cTdyUFIxZEVp?=
 =?utf-8?B?UUVrYlI3Y09oMFl6MkVKM0U3TGh4YlZic0IvSUQvUm54MUZPekRXOEtRc3JL?=
 =?utf-8?B?UVRxSTFIOXBQVGl0SDFGWFpBRzYxUGJBNC8yUzZ1bFhFd0FyQmF4a1JzeG1D?=
 =?utf-8?B?SmFCMDQ2Z2tyeTNiUlhETllhdmlOQWFCakpRWHRUMWdHMTlaUERrdEhOMTk3?=
 =?utf-8?B?ZWFPR1FUQzJQaTdXMzlLSUVtbThOOE1BWm9ld2NvM1BpazhCWGdsZk8xeVph?=
 =?utf-8?B?MjlnZXhrOVhHQVhXZ1ZzUFJpbXJBS0tXRDc0MkNyNkhRdzNGSU1TaEpjSGo2?=
 =?utf-8?B?cW9weThqUkl3K1lKbm9xYjFFdll4a0h2SElJR2JYV052dE9POTVPSWFqazNx?=
 =?utf-8?B?bUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D74ACA2FE131D4BAC4511B5A2B567E7@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bc71BB8UC0tI6pmZiyoXfgizrm+3d+drY3qtv0CkB/6BeupPdKV/FVxoD97MaI0MfDdyVHQvNYs69HTcdfiqWQKoMKYoEhQs46t9NPIHf4i66p3wTTZWhimQuz/jI9fgx1PsPBgaKZHHE8Z4N9jc1KoBMtyBnZxrZqwppPbQz32BLjJUCer9Y9Iu2rFSwK97a2a9fpvQzm1Bnq+HN4n2Id4BaGP6UYjLDbkNq/Y/If13vBImi1D6Sl6b5eYdfvWM8m4Fb2Xvp7I1UFe0Hn/W7EZhcoV7jw5nbUZEI5k0gBfBHGEUNaCW71x36Ajl+K/pOcxZPeeVFH+JPdei8HMLWvL+GkFsXnc00bmho/up1mnlDnzMGPsHRfHKn6n+L+It9ZIDlRxjPcGZPfiX1Ksa86po641oasdySS7GWH5UOv3ECvBWj9OgJ2iAtqL5TVVT0nAoWNWfPSxkT267bidhfr9euo+5pvdZzOU2jPOGH8qLUo6JqiBWGsTATDe1ikdzp6UFwQQEhEEkTdaIRCWVSlUBrZqfiPae2r6i7LuBWOFuvrPqCRDZui+Ux38X5N+M3nh5LWwafZhQco/9zTIav8AWzP5lxv3u6KucBziR1P9gZEJamEfl79hY/lV4vUyZCZHJkIYm9I6qNkqvGlX1aRuzi7dCIG/4muoIbM+pGXbl5cdG3jk5fitQ10rWvP0U9w2FShCuV78LwHRJdHmQCBwdZT/du4mVn19BWcgQWRM5k4EDyXgQ50G4ZuOITmWGd4/Po7jlerm2ycEySbJt2khK/hhdhOo2gldpiXdclMA9AZ15DZhfHV4WK2uosg2l4WxtOOpUA/8cpX649lEriA==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5442.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 930db74c-ff54-4517-6ff1-08dbf702f27b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 09:00:23.2970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +AxPg/PkLE+ebDVTkPCKl87i5WIumv74El6sA6sEovBp4R04XnMcBVVdxhjLIOXUd7EXqNMBGWA/8h7xyPLcmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9323

DQoNCk9uIDA3LzEyLzIwMjMgMDU6MzUsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gTGkgWmhpamlh
biB3cm90ZToNCj4+IEZpeCBlcnJvcnM6DQo+PiBsaW5lIDExMTogWzogMHg4MDAwMDAwMDogaW50
ZWdlciBleHByZXNzaW9uIGV4cGVjdGVkDQo+PiBsaW5lIDExMjogWzogMHgzZmYxMTAwMDAwMDA6
IGludGVnZXIgZXhwcmVzc2lvbiBleHBlY3RlZA0KPj4gbGluZSAxNDE6IFs6IDB4ODAwMDAwMDA6
IGludGVnZXIgZXhwcmVzc2lvbiBleHBlY3RlZA0KPj4gbGluZSAxNDM6IFs6IDB4M2ZmMTEwMDAw
MDAwOiBpbnRlZ2VyIGV4cHJlc3Npb24gZXhwZWN0ZWQNCj4gDQo+IFNpbWlsYXIgY29tbWVudGFy
eSBvbiBob3cgZm91bmQgYW5kIGhvdyBzb21lb25lIGtub3dzIHRoYXQgdGhleSBuZWVkDQo+IHRo
aXMgcGF0Y2gsIGFuZCBtYXliZSBhIG5vdGUgYWJvdXQgd2hpY2ggdmVyc2lvbiBvZiBiYXNoIGlz
IHVwc2V0IGFib3V0DQo+IHRoaXMgZ2l2ZW4gdGhpcyBwcm9ibGVtIGhhcyBiZWVuIHByZXNlbnQg
Zm9yIGEgbG9uZyB0aW1lIHdpdGhvdXQgaXNzdWUuDQoNCkkgdGhpbmsgaXQgaW1wYWN0ZWQgYWxs
IHZlcnNpb24gb2YgQkFTSCAodGVzdGVkIG9uIGJhc2ggNC4xLCA0LjIsIDUuMCwgNS4xKQ0KDQoN
Cj4gDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogTGkgWmhpamlhbiA8bGl6aGlqaWFuQGZ1aml0c3Uu
Y29tPg0KPj4gLS0tDQo+PiAgIHRlc3QvY3hsLXJlZ2lvbi1zeXNmcy5zaCB8IDggKysrKy0tLS0N
Cj4+ICAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4+
DQo+PiBkaWZmIC0tZ2l0IGEvdGVzdC9jeGwtcmVnaW9uLXN5c2ZzLnNoIGIvdGVzdC9jeGwtcmVn
aW9uLXN5c2ZzLnNoDQo+PiBpbmRleCBkZWQ3YWExLi44OWYyMWEzIDEwMDY0NA0KPj4gLS0tIGEv
dGVzdC9jeGwtcmVnaW9uLXN5c2ZzLnNoDQo+PiArKysgYi90ZXN0L2N4bC1yZWdpb24tc3lzZnMu
c2gNCj4+IEBAIC0xMDgsOCArMTA4LDggQEAgZG8NCj4+ICAgDQo+PiAgIAlzej0kKGNhdCAvc3lz
L2J1cy9jeGwvZGV2aWNlcy8kaS9zaXplKQ0KPj4gICAJcmVzPSQoY2F0IC9zeXMvYnVzL2N4bC9k
ZXZpY2VzLyRpL3N0YXJ0KQ0KPj4gLQlbICRzeiAtbmUgJHJlZ2lvbl9zaXplIF0gJiYgZXJyICIk
TElORU5POiBkZWNvZGVyOiAkaSBzejogJHN6IHJlZ2lvbl9zaXplOiAkcmVnaW9uX3NpemUiDQo+
PiAtCVsgJHJlcyAtbmUgJHJlZ2lvbl9iYXNlIF0gJiYgZXJyICIkTElORU5POiBkZWNvZGVyOiAk
aSBiYXNlOiAkcmVzIHJlZ2lvbl9iYXNlOiAkcmVnaW9uX2Jhc2UiDQo+PiArCVsgIiRzeiIgIT0g
IiRyZWdpb25fc2l6ZSIgXSAmJiBlcnIgIiRMSU5FTk86IGRlY29kZXI6ICRpIHN6OiAkc3ogcmVn
aW9uX3NpemU6ICRyZWdpb25fc2l6ZSINCj4+ICsJWyAiJHJlcyIgIT0gIiRyZWdpb25fYmFzZSIg
XSAmJiBlcnIgIiRMSU5FTk86IGRlY29kZXI6ICRpIGJhc2U6ICRyZXMgcmVnaW9uX2Jhc2U6ICRy
ZWdpb25fYmFzZSINCj4gDQo+IG1heWJlIHVzZSAoKHN6ICE9IHJlZ2lvbl9zaXplKSkgdG8gbWFr
ZSBpdCBleHBsaWNpdCB0aGF0IHRoaXMgaXMgYW4NCj4gYXJpdGhtZXRpYyBjb21wYXJpc29uPyBJ
IHdvdWxkIGRlZmVyIHRvIFZpc2hhbCdzIHByZWZlcmVuY2UgaGVyZS4NCg0KUGVyIGJhc2ggbWFu
IHBhZ2UsIHdlIGNhbiBhbHNvIHVzZSBbWyBdXSBpbnN0ZWFkIG9mIFsgXSwgc28gdGhhdCB3ZSBh
cmUgYWJsZSB0byBnZXQgcmlkIG9mIHBhdGNoMQ0KDQogICAgICAgIGFyZzEgT1AgYXJnMg0KICAg
ICAgICAgICAgICAgT1AgaXMgb25lIG9mIC1lcSwgLW5lLCAtbHQsIC1sZSwgLWd0LCBvciAtZ2Uu
ICBUaGVzZSBhcml0aG1ldGljIGJpbmFyeSBvcGVyYXRvcnMgcmV0dXJuIHRydWUgaWYgYXJnMSBp
cyBlcXVhbCB0bywgbm90IGVxdWFsIHRvLCBsZXNzIHRoYW4sIGxlc3MgdGhhbiBvciBlcXVhbCB0
bywgZ3JlYXRlciB0aGFuLCBvciBncmVhdGVyIHRoYW4gb3IgZXF1YWwgIHRvICBhcmcyLA0KICAg
ICAgICAgICAgICAgcmVzcGVjdGl2ZWx5LiAgQXJnMSBhbmQgYXJnMiBtYXkgYmUgcG9zaXRpdmUg
b3IgbmVnYXRpdmUgaW50ZWdlcnMuICBXaGVuIHVzZWQgd2l0aCB0aGUgW1sgY29tbWFuZCwgQXJn
MSBhbmQgQXJnMiBhcmUgZXZhbHVhdGVkIGFzIGFyaXRobWV0aWMgZXhwcmVzc2lvbnMgIChzZWUg
QVJJVEhNRVRJQyBFVkFMVUFUSU9OIGFib3ZlKS4NCg0K
