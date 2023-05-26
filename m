Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com [68.232.159.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDE01C26
	for <nvdimm@lists.linux.dev>; Fri, 26 May 2023 04:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1685074945; x=1716610945;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xGSel25a2aI/uHyo484lID1Qvw2JDFZ7IArhr1Az0SE=;
  b=f6pmX6/YjqbGvqlyQFa+pjizyheJCziuHqVag4GCkO+TFXSNyrVIewCu
   00qYpsD3mExKVJdBt1STTWaqFEx5x9Ypt7a+1FyfXan4tHz2Meo3teWOn
   OjJvZ04F4SGW4haAyoVBMGGOxsbSq6quEckblPv2zTsPQy5K2gTdPgrUv
   uZetRDTQ+iVDk/2jeUcGlKrqRtV2XqPrKFUZK7MqoaxEAK0sn0v2qDvZA
   1ZqO7yNEyfg+ygTKkCnNX7NHE8bDK2IAeXvowjqE1l3N+m17Pg1jxq4MF
   poRe/uKxws0GgQRVPCwAZR2Z3ZsgrX5gEIlZwjAKFJtHwJeoNHjKiPLR/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="85527457"
X-IronPort-AV: E=Sophos;i="6.00,193,1681138800"; 
   d="scan'208";a="85527457"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 13:21:13 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KeuwRFBmtHJJWbE9SrpXiF9yyIezrvjMf+NeE3SVtNSQD2HgxQrvIF9NuDO0HSiUoBEa+eACwG5lgUsu2SvwdGCkBWsrZhjhbClFWpgqugu+LYO4Sq6kq/48+XSisEdnKAZ6Kye2z5OxVNMQxuYMRW9EcYUjYabLH7lkrScxbUTL430cx/u3BgMbbevOj0Yj2E9JWcXQjnLZ2V2UJjRwv6UwTjlqOeeJrkhE1H1WDg1a6Lqyu8hifvMHk40wRVwqroWkgW3vYPM8qCsRg4i5qiVpUWFs4Tv8sDbl1YhRZtW1RXke39ZGsMZtCx1oltGfx4kWIEhRJFpNn3MAlrJcPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGSel25a2aI/uHyo484lID1Qvw2JDFZ7IArhr1Az0SE=;
 b=IRrgLreDMoqV35Bd/pebjP+E0LuVOGdozLNIkjjstAFTppGAP9c/c3pXIVgqq6U9Ww+MDeJyRUhjMewpD0IvPjy9Qu7VWFYAh/nqcn8haGLgn1T9JUXQBn2iz+ltQkCMfLAqu126qpdeNIWwPuU+eUOXySrFmFCu0rNFAI4hVMOYwa7x+26a1ZYteWXQoNJI2VvKRsBFzxzW4B1QqYNhFJG5yx43Em5ycv9Z37VDlOqhDMQt78KNaSjUHBbTWK5v10YvuD3mIQLx7+B6fG6gNIWQp0eQ1uHp3LLx3lL9trF4rLzRkF3jsVkAcQJ5NVYKvqSXICkx7YYAAoobbGFMUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TYWPR01MB9692.jpnprd01.prod.outlook.com (2603:1096:400:232::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Fri, 26 May
 2023 04:21:09 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835%7]) with mapi id 15.20.6433.016; Fri, 26 May 2023
 04:21:09 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dave Jiang <dave.jiang@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 2/2] README.md: document CXL unit tests
Thread-Topic: [ndctl PATCH 2/2] README.md: document CXL unit tests
Thread-Index: AQHZjSqqspIpLQ5sj0min3HqTE0Gha9rIMEAgADSeYCAAAVsgA==
Date: Fri, 26 May 2023 04:21:08 +0000
Message-ID: <d02e59c0-2036-aae0-f77d-17833be6def0@fujitsu.com>
References: <20230523035704.826188-1-lizhijian@fujitsu.com>
 <20230523035704.826188-2-lizhijian@fujitsu.com>
 <43b38130-19fa-26b5-f7b3-8429c5230c66@intel.com>
 <d77dbd2e-452e-ab91-d045-e89fd7a7a9f9@fujitsu.com>
In-Reply-To: <d77dbd2e-452e-ab91-d045-e89fd7a7a9f9@fujitsu.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TYWPR01MB9692:EE_
x-ms-office365-filtering-correlation-id: 416916fd-b013-45c5-4cf7-08db5da0a194
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 YF5iwZXggmg5vDqVPD6w+NSzwshvylt+Ne6UScnIs6FpUYNhLe/UyvrFVTFSNbOioPbEiNHpHHnywfUyoHCY+/DibFV9KRAzlY7UqQ1KTBFsYGZKB1VULPE4ZYeJnJj1dIpBrfRUuy2cxj3Gj7tz0mfr4QBUL1ng4F40bS1Yj2u6yrNtzI+5VfOGD49dLV+jVl/uM1ydTbX/5IdIGeFqgGb1zg86sh81EH3RY2nm+bXEbVEaSeJbARbKdRQZu7k41ugXot3z4e9eUAZlW+0eaM5nLI0GrlCoWqGnGafSNejKI0otnS/zav28vAwjTB6CvUkhnxTKoWx1+CqaepGRjpdSmhXaDCplEw19Be3xW974LUI20GVgm3ziBEuxqwH/HbZkgotPjCCqO8maP9WtsCBkFgiRmSlF7uhGcCt5CbZ3SLlaR+6ZzhMnzYig+hvqsogtErE9hDp4ugTTPZgj1IVETLKPuFiyKPYPncL3MnS4PofcodfjRJVG8hl8jnSMUT+3GQSqAWwMlK+9D2Qu5fntBZ4YJ0Cdw+cC7HkrEh5d56TYKN2qnPXQmP9dMkICtsXNr0gOV3z3fSTa4Z7k9ULUvPRmnabeGkbqFElT5oZDxIblWAb5/WIQJTHe+m3iQWMljdIuA87tKPHyLy3URDQ0LtJyNWCh5bEERg8GfW/rV5yu/d4vS+w+1bnjUIeND0AcukUiUAPQnRrnYj/j5w==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(1590799018)(451199021)(38100700002)(53546011)(122000001)(186003)(38070700005)(6512007)(6506007)(83380400001)(2616005)(82960400001)(26005)(478600001)(71200400001)(2906002)(966005)(86362001)(31696002)(6486002)(85182001)(110136005)(91956017)(64756008)(66476007)(66446008)(66556008)(76116006)(66946007)(41300700001)(316002)(31686004)(36756003)(8676002)(8936002)(4326008)(1580799015)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MWxkT1hYWmwwdlJNUFc2cmRmb1MxTG11R3lNZzFtcW1qYkV4MWdLenl3WHo1?=
 =?utf-8?B?eXEvWHE0YnBFbDZZa2svYkYrNlYyQ0xLYm01SEVaWjRTWmNWS3ZFU1QvUDAy?=
 =?utf-8?B?Qno1dHNsclNSdDlLTHd6Z1hOc2ROTTlvL2ttdWx6OHFFVkhZVHZ1emgyYnJu?=
 =?utf-8?B?MHlsdGtQenNhbkZSQ202UUxGYUJZNloxTXpUOXRnS2NseTdEQnEyS2lyblV6?=
 =?utf-8?B?UkFoVmVYREFJbmpLVEZrVk9PQ2xNL3h4NS9ESzZJQ0dXcm1uZ3pwMmZITnIw?=
 =?utf-8?B?Q3VLT0FvTTQ2WkZnOWhrSlBLMEdJa0pYMGphVmo1TVhNcEZWa2lrOERSWXRN?=
 =?utf-8?B?bnYzQS83YlJJaTRLbEd0Z2k4Ukl3ZlFhRUkyY0tFbmdxVm1PS1kwd1FuNkN5?=
 =?utf-8?B?TkU1dFV3WkFrQllsS2ZTRmcydldNSmVOZ1pOcGF4SmlrcSt0azhFOVVzR2ZH?=
 =?utf-8?B?YXZwSnd5SlZkaEFyZXY1NEp4NDdadHg2OWdIWjhRL0JqalZkeU4rTVpacTZN?=
 =?utf-8?B?cWhWT05aSVN6MFZ3WVpzZUJ6WVRMSGxsUFZsMW5QSlBRWlREWThFN2M2ejVr?=
 =?utf-8?B?dTZWR1BuV0dldW44OU9ob3ZYOUUwcUhvaC9DN3RZU0RZM3VqMGhwN3E1YUFW?=
 =?utf-8?B?Ymo0TGZoSFAzbTNFMzVCR3p2aGN5QUJtRXFqN2tZemhiN0FVajIvZE5zNVJF?=
 =?utf-8?B?Y3JjQlNVNEhLb3VDeUppazdJS1VheDExbXBZbFFYd3ZzRWhYeEJyckV4TDFU?=
 =?utf-8?B?YWhjeGFTQWFNU1d1SkM3WHlKR0tCRFNmM1ptdDZ1NXdHc2szYnM4N0M1enBy?=
 =?utf-8?B?NUpZSXNYZ1ZET0F3dW1WcjNLdDJ3M0FadkNibmVlR0pYWm1KM0pUUjVJZUZt?=
 =?utf-8?B?bFNTbnd3VDhsYWpMM0JHRzVqMmpiUXMwc3ptRzh3dUN5a05BeWszVTBVSGpL?=
 =?utf-8?B?Q0xuT0lvOTYwRlpQL0RxTGRzMEg3UHFDMC9zVXpZaGtiZFk3ek9KbWZ3WkhJ?=
 =?utf-8?B?NmMvUFFiSXU1c1BuTHhhMUJBWVhjdE5SbVFFcXEvdHlMMVFUWG5yd05RNFJx?=
 =?utf-8?B?Nk9RRG1mYzVGWkdkREI0L1dlTWJwWWRkRlZyY0VNZVBhL2R4UzRGYk53ZjdX?=
 =?utf-8?B?d2V6VUI1MWZkak5HbDZTeVd5eU1SLzJ3WTFGRlI1cWFheG85aWtZeEhVdDZD?=
 =?utf-8?B?S2tYRUFOTC9RNGdYL1lBZW1kVmJ6V3RqVWFNTHUwWmVLL2lBemVCcjdoR01a?=
 =?utf-8?B?dWZqVmxKNUxsVk1pWTBSRlZBc25xMzk1aVdId2tPSGZ5NStGUGMvQ29mN0dV?=
 =?utf-8?B?RU9EbVI3UzRTNVp2Y0h2MU5lejUzbCsyTm9sWDJVbHE2ZFFuNmVGSXpJMFVz?=
 =?utf-8?B?cWpzMk82Ky9ackJiNnVNanozL2h3a29GVjl0b3NsRVk3SXJRdjgzNjh4UUps?=
 =?utf-8?B?MlZ5cTBwOXFBaFFpUFhKU2NnNjdJY1J6dFd4bWRnVTdtWldhLzBTLzE4dGJS?=
 =?utf-8?B?K2hZSWhVWFRKNTQzcFgrT3AvdmNzTkFhZ0ZlRER3d0lBekhmNVFnRFVRQm1v?=
 =?utf-8?B?cWJFODJlVm9teGU0MklXczlZYTFlU2QzS29FUU5xaGRRNWpjaUhxQU9COGpm?=
 =?utf-8?B?NEdIVlFTKytUMEpKTkVqd1hBbGh4MGlqWGJCRXBxWGlIclJ2b0l2RUdwdXhK?=
 =?utf-8?B?TmRrcFdaeDRMbGpRNUNDMitGbTdGZFRQaGNBa3BFSTlmRi9vZXl2NnR0VTdh?=
 =?utf-8?B?Zm1pUzZDV3V5VEU4TkRzQ3NacWhSL2hhaXZHd243ZGJUY0g2dVQwWEdITjJz?=
 =?utf-8?B?ZHl1ajBwT1B4RXA1SjZoaklRVjhDMGRrYVdDaVZpMmg2bFNXc3ROZHMzcDZG?=
 =?utf-8?B?S2RCN1NYWkNhRkIzNnJJNXlnYlpaVGo4cUIvVmxwMllKclN0MEh0clZyUy9H?=
 =?utf-8?B?UjQ0OFJJR2N5eXNvOVA3NHVNdUYvQlNPbldOY0tSdFA2aVhEVGFBOWxEeFp4?=
 =?utf-8?B?OTNrcW9Tdy92Vld4UEJIblVEQ2FuVGZaNW1sanN2a2s4ZzB3M2ZaL291QzZZ?=
 =?utf-8?B?T282NXVOTWR2NC9KUDk2V1RHcEJFVXZYelZUYU5WVjBwTk1McUNCSzZnZEFM?=
 =?utf-8?B?WklqSVl5Q1ZWVFd3Tkt3ZUo0Z3lwZlNpVlNmbElQYmxISW0xeFV3eEhrOU1O?=
 =?utf-8?B?dUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37D8705867CA884FB6284D95491F5B6D@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Avdw0h6ly7e9cSws4AyWi05V8Rc1wKactjW7fTY9ciYuQfBtqtDnQ4h7lQC6Nk6dr7roWlUiC95jhpmu7xqT7ZeF9fWFVolDmn7Ts7DDrV9uULc5wtibsJEADEgd69+J19xizsLMvL4PBXMOeRe9avR4QaWLuOCJ2SNR5Qy/dGSEcUbnPQdMLZuSO4vOe3+4bAIjygYP0J0hgMJVk+UcmDJx+s8iXT/XZVSuHP+1gWgq9ibbhjugYAgK7NfcWAp/8Y7cf3s22wFoLHlX/KHB0Cj8RXoh4pdxQWI4Pl1gHdmgJvkbWiS2OHInmXJAGFRlSuTGz/rFvt6OKRBiPxZYD7CTQaQdbFEoaNBSi5xG5RAE5xC9bDH5/so+Wj+NU8vZERjzNRZ8MeIvNePVxbC/jGmDN68PNSzisYSYnKD0d6wbpzdHn11AYXaeuFvdsRMO+1bBWweug5Rpmq5WbkZcMASrSjEATVx+4oonryWBGGEOfaT+UcehR3w6wz21KeuaojhiFlEcGKWD75qH2OXulSoIUH9n+F/hY1ku210MV0pkyvZKl2JOGdlNQIpm5dNjXbFYeipba3GbHDXOnSUTyGj8iaRzWLd4+jZLWlOuPhSSojPe7c8dhDxU0/d6mLcW0psGAa2MN1Ks9OH7EJVUvz//ihMAEb1sJVTyGq/VIpefGv3w2HT0S6FBZuSvQyPadcUBi4JaVQKUakgLoXkJsHHnWa73/0UQ442jYYY3Ab0UrBxq6nLT68KB+kP3ERha0rwPWJeZzhFLK36mtVzdIZEFF+XBH+P2CJxsOb/3LYljlujb/vKxBDFYsYMXXXYXhFrMzF02GVpzYQsXYwKhGQ==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 416916fd-b013-45c5-4cf7-08db5da0a194
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 04:21:08.9927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7a7972xBz+LLIMBq1PfMq1vHjUio+Jt/80IyLFtFsbUBAzS8KqF87ssN/PloDBKWeQD+3yS6d8YO+qfiacF+lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9692

DQoNCk9uIDI2LzA1LzIwMjMgMTI6MDEsIFpoaWppYW4gTGkgKEZ1aml0c3UpIHdyb3RlOg0KPiAN
Cj4gDQo+IE9uIDI1LzA1LzIwMjMgMjM6MjgsIERhdmUgSmlhbmcgd3JvdGU6DQo+Pg0KPj4gT24g
NS8yMi8yMyAyMDo1NywgTGkgWmhpamlhbiB3cm90ZToNCj4+PiBJdCByZXF1aXJlcyBzb21lIENM
WCBzcGVjaWZpYyBrY29uZmlncyBhbmQgdGVzdGluZyBwdXJwb3NlIG1vZHVsZQ0KPj4+DQo+Pj4g
U2lnbmVkLW9mZi1ieTogTGkgWmhpamlhbiA8bGl6aGlqaWFuQGZ1aml0c3UuY29tPg0KPj4+IC0t
LQ0KPj4+ICDCoCBSRUFETUUubWQgfCAxNyArKysrKysrKysrKysrKystLQ0KPj4+ICDCoCAxIGZp
bGUgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+Pg0KPj4+IGRp
ZmYgLS1naXQgYS9SRUFETUUubWQgYi9SRUFETUUubWQNCj4+PiBpbmRleCA3YzdjZjBkZDA2NWQu
LjUyMWUyNTgyZmIwNSAxMDA2NDQNCj4+PiAtLS0gYS9SRUFETUUubWQNCj4+PiArKysgYi9SRUFE
TUUubWQNCj4+PiBAQCAtMzksOCArMzksOCBAQCBodHRwczovL252ZGltbS53aWtpLmtlcm5lbC5v
cmcvc3RhcnQNCj4+PiAgwqAgVW5pdCBUZXN0cw0KPj4+ICDCoCA9PT09PT09PT09DQo+Pj4gLVRo
ZSB1bml0IHRlc3RzIHJ1biBieSBgbWVzb24gdGVzdGAgcmVxdWlyZSB0aGUgbmZpdF90ZXN0Lmtv
IG1vZHVsZSB0byBiZQ0KPj4+IC1sb2FkZWQuwqAgVG8gYnVpbGQgYW5kIGluc3RhbGwgbmZpdF90
ZXN0LmtvOg0KPj4+ICtUaGUgdW5pdCB0ZXN0cyBydW4gYnkgYG1lc29uIHRlc3RgIHJlcXVpcmUg
dGhlIG5maXRfdGVzdC5rbyBhbmQgY3hsX3Rlc3Qua28gbW9kdWxlcyB0byBiZQ0KPj4+ICtsb2Fk
ZWQuwqAgVG8gYnVpbGQgYW5kIGluc3RhbGwgbmZpdF90ZXN0LmtvIGFuZCBjeGxfdGVzdC5rbzoN
Cj4+PiAgwqAgMS4gT2J0YWluIHRoZSBrZXJuZWwgc291cmNlLsKgIEZvciBleGFtcGxlLA0KPj4+
ICDCoMKgwqDCoCBgZ2l0IGNsb25lIC1iIGxpYm52ZGltbS1mb3ItbmV4dCBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbnZkaW1tL252ZGltbS5naXRgDQo+Pj4g
QEAgLTcwLDYgKzcwLDEzIEBAIGxvYWRlZC7CoCBUbyBidWlsZCBhbmQgaW5zdGFsbCBuZml0X3Rl
c3Qua286DQo+Pj4gIMKgwqDCoMKgIENPTkZJR19OVkRJTU1fREFYPXkNCj4+PiAgwqDCoMKgwqAg
Q09ORklHX0RFVl9EQVhfUE1FTT1tDQo+Pj4gIMKgwqDCoMKgIENPTkZJR19FTkNSWVBURURfS0VZ
Uz15DQo+Pj4gK8KgwqAgQ09ORklHX0NYTF9CVVM9bQ0KPj4+ICvCoMKgIENPTkZJR19DWExfUENJ
PW0NCj4+PiArwqDCoCBDT05GSUdfQ1hMX0FDUEk9bQ0KPj4+ICvCoMKgIENPTkZJR19DWExfUE1F
TT1tDQo+Pj4gK8KgwqAgQ09ORklHX0NYTF9NRU09bQ0KPj4+ICvCoMKgIENPTkZJR19DWExfUE9S
VD1tDQo+Pj4gK8KgwqAgQ09ORklHX0RFVl9EQVhfQ1hMPW0NCj4+DQo+PiBQcm9iYWJseSBzaG91
bGQgaGF2ZSBhIHNlcGFyYXRlIGVudHJ5IGZvciBDWEwgY29uZmlncyBmb3IgdGVzdGluZy4gVGhl
cmUncyBhIGN4bC5naXQgYXQga2VybmVsLm9yZyBhcyB3ZWxsLg0KPj4NCj4+IEFsc28gd2lsbCBu
ZWVkOg0KPj4NCj4+IENPTkZJR19OVkRJTU1fU0VDVVJJVFlfVEVTVD15DQo+Pg0KPiANCj4gSSBh
bHNvIG5vdGljZWQgdGhhdCBZaSBoYXZlIHNlbnQgYSBwYXRjaCB0byBhZGQgdGhpcyBhbmQgc29t
ZSBvdGhlciBrY29uZmlncw0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9udmRpbW0vMjAyMzA1
MTYxMjE3MzAuMjU2MTYwNS0xLXlpLnpoYW5nQHJlZGhhdC5jb20vVC8jdQ0KPiANCj4+IENPTkZJ
R19DWExfUkVHSU9OX0lOVkFMSURBVElPTl9URVNUPXkNCj4gDQo+IFllcywgaSBpbmRlZWQgbWlz
c2VkIGl0Lg0KPiANCj4gSSBpbnNlcnQgYSBzZWN0aW9uIGJlZm9yZSAqcnVuIHRoZSB0ZXN0KiBh
cyBiZWxvdy4gQSBtYXJrZG93biBwcmV2aWV3IG9mIFJFQURNRS5tZCANCg0KDQpBdHRhY2ggdGhl
IFJFQURNRSBwcmV2aWV3IGxpbms6IGh0dHBzOi8vZ2l0aHViLmNvbS96aGlqaWFubGk4OC9uZGN0
bC9ibG9iL2N4bC9SRUFETUUubWQNCg0KDQoNCj4gUGxlYXNlIHRha2UgYW5vdGhlciBsb29rLg0K
PiANCj4gZGlmZiAtLWdpdCBhL1JFQURNRS5tZCBiL1JFQURNRS5tZA0KPiBpbmRleCA3YzdjZjBk
ZDA2NWQuLjMyNGQxNzlhYzRlYSAxMDA2NDQNCj4gLS0tIGEvUkVBRE1FLm1kDQo+ICsrKyBiL1JF
QURNRS5tZA0KPiBAQCAtODIsNiArODIsMzIgQEAgbG9hZGVkLiAgVG8gYnVpbGQgYW5kIGluc3Rh
bGwgbmZpdF90ZXN0LmtvOg0KPiAgICAgICBzdWRvIG1ha2UgbW9kdWxlc19pbnN0YWxsDQo+ICAg
ICAgIGBgYA0KPiAgICANCj4gKzEuIENYTCB0ZXN0DQo+ICsNCj4gKyAgIFRoZSB1bml0IHRlc3Rz
IHdpbGwgYWxzbyBydW4gQ1hMIHRlc3QgYnkgZGVmYXVsdC4gSW4gb3JkZXIgdG8gbWFrZSB0aGUN
Cj4gKyAgIENYTCB0ZXN0IHdvcmsgcHJvcGVybHksIHdlIG5lZWQgdG8gaW5zdGFsbCB0aGUgY3hs
X3Rlc3Qua28gYXMgd2VsbC4NCj4gKw0KPiArICAgT2J0YWluIHRoZSBDWEwga2VybmVsIHNvdXJj
ZShvcHRpb25hbCkuICBGb3IgZXhhbXBsZSwNCj4gKyAgIGBnaXQgY2xvbmUgLWIgcGVuZGluZyBn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvY3hsL2N4bC5naXRg
DQo+ICsNCj4gKyAgIEVuYWJsZSBDWEwgc3BlY2lmaWMga2VybmVsIGNvbmZpZ3VyYXRpb25zDQo+
ICsgICBgYGANCj4gKyAgIENPTkZJR19DWExfQlVTPW0NCj4gKyAgIENPTkZJR19DWExfUENJPW0N
Cj4gKyAgIENPTkZJR19DWExfQUNQST1tDQo+ICsgICBDT05GSUdfQ1hMX1BNRU09bQ0KPiArICAg
Q09ORklHX0NYTF9NRU09bQ0KPiArICAgQ09ORklHX0NYTF9QT1JUPW0NCj4gKyAgIENPTkZJR19D
WExfUkVHSU9OPXkNCj4gKyAgIENPTkZJR19DWExfUkVHSU9OX0lOVkFMSURBVElPTl9URVNUPXkN
Cj4gKyAgIENPTkZJR19ERVZfREFYX0NYTD1tDQo+ICsgICBgYGANCj4gKyAgIEluc3RhbGwgY3hs
X3Rlc3Qua28NCj4gKyAgIGBgYEZvciBjeGxfdGVzdC5rbw0KPiArICAgbWFrZSBNPXRvb2xzL3Rl
c3RpbmcvY3hsDQo+ICsgICBzdWRvIG1ha2UgTT10b29scy90ZXN0aW5nL2N4bCBtb2R1bGVzX2lu
c3RhbGwNCj4gKyAgIHN1ZG8gbWFrZSBtb2R1bGVzX2luc3RhbGwNCj4gKyAgIGBgYA0KPiAgICAx
LiBOb3cgcnVuIGBtZXNvbiB0ZXN0IC1DIGJ1aWxkYCBpbiB0aGUgbmRjdGwgc291cmNlIGRpcmVj
dG9yeSwgb3IgYG5kY3RsIHRlc3RgLA0KPiAgICAgICBpZiBuZGN0bCB3YXMgYnVpbHQgd2l0aCBg
LUR0ZXN0PWVuYWJsZWRgIGFzIGEgY29uZmlndXJhdGlvbiBvcHRpb24gdG8gbWVzb24uDQo+IA0K
PiANCj4+DQo+Pg0KPj4NCj4+PiAgwqDCoMKgwqAgYGBgDQo+Pj4gIMKgIDEuIEJ1aWxkIGFuZCBp
bnN0YWxsIHRoZSB1bml0IHRlc3QgZW5hYmxlZCBsaWJudmRpbW0gbW9kdWxlcyBpbiB0aGUNCj4+
PiBAQCAtNzcsOCArODQsMTQgQEAgbG9hZGVkLsKgIFRvIGJ1aWxkIGFuZCBpbnN0YWxsIG5maXRf
dGVzdC5rbzoNCj4+PiAgwqDCoMKgwqAgdGhlIGBkZXBtb2RgIHRoYXQgcnVucyBkdXJpbmcgdGhl
IGZpbmFsIGBtb2R1bGVzX2luc3RhbGxgDQo+Pj4gIMKgwqDCoMKgIGBgYA0KPj4+ICvCoMKgICMg
Rm9yIG5maXRfdGVzdC5rbw0KPj4+ICDCoMKgwqDCoCBtYWtlIE09dG9vbHMvdGVzdGluZy9udmRp
bW0NCj4+PiAgwqDCoMKgwqAgc3VkbyBtYWtlIE09dG9vbHMvdGVzdGluZy9udmRpbW0gbW9kdWxl
c19pbnN0YWxsDQo+Pj4gKw0KPj4+ICvCoMKgICMgRm9yIGN4bF90ZXN0LmtvDQo+Pj4gK8KgwqAg
bWFrZSBNPXRvb2xzL3Rlc3RpbmcvY3hsDQo+Pj4gK8KgwqAgc3VkbyBtYWtlIE09dG9vbHMvdGVz
dGluZy9jeGwgbW9kdWxlc19pbnN0YWxsDQo+Pj4gKw0KPj4+ICDCoMKgwqDCoCBzdWRvIG1ha2Ug
bW9kdWxlc19pbnN0YWxsDQo+Pj4gIMKgwqDCoMKgIGBgYA==
