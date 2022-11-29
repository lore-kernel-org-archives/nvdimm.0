Received: from esa4.fujitsucc.c3s2.iphmx.com (esa4.fujitsucc.c3s2.iphmx.com [68.232.151.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381B5639
	for <nvdimm@lists.linux.dev>; Tue, 29 Nov 2022 05:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1669699053; x=1701235053;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ly8uoFP4E9+UxNLsZn85zTtPUSXOhYVjMBPDBXxlKp8=;
  b=MJzqZOp/xWL4Bia4ZLcbpkw6uaNWpS8Q8E1PRx69MLlnEnmgJWHhAELI
   oIJPk9ar3sOqg7/YtjFn2H4yM0w+BKjv19NL1Y8bodnq75WQi9BinH6/q
   OOaO/Y0XfItzgAKj2Gf+R4McqCFrv0F16j2OZKejjj1llR3FXm0zEZuGY
   A1y4BhQswR8PeCDAsBd3zzQjQni7mYWoXMT+jCFeiBRonfQkj0GgmxxPb
   xfkTBASs6irFIhDh9WtRbme/lbn/mT0cEl4r5kLTLmLmB2DVuY0SlVh/L
   ArFm5jWFiqpP0YqSo2fc+MIhbKgC6pyrwYyyHqYyQlW3noGJwGAv6fu+j
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="78967548"
X-IronPort-AV: E=Sophos;i="5.96,202,1665414000"; 
   d="scan'208";a="78967548"
Received: from mail-os0jpn01lp2105.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.105])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 14:16:18 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQH8+gs2aw+JU6kkSmV4T8m8PF4zMKWkXycps+o7HecyM67bk3DIScHuK4Z6gBAimJzQaSXGjBnfn6D9XIzcq9B4csffdUY4eFpr7vK/vpWgQuhlQfOQoDv5m2s0XWJuh4DU2J94KoEvDXOp9cWj4I2D9oIBP849N2hSXoOoOg7Vz8kwQimacOk+2BuI5HiU56+W0k9Sb0oXJHb000b3nXT6+M++Vlcezpkck1cxf3HYT3gIPIousfyt+O2zjIXt42km/NWPmYCeAUhhzlnXakctefw5A6riI46pXE109SMGNUcf4akyTeAfikhWbrUZ3awY3xqOtHpBbYrG3HTOMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ly8uoFP4E9+UxNLsZn85zTtPUSXOhYVjMBPDBXxlKp8=;
 b=g9P/IQDZZfloLMgDhgpR3F5Cb6HyxzUHXCRl3sHyVekV9RXl+QJABRW25Y58+F6SvuzTlUHT7uORJEuRty83ZM/V+hv3BvZ6mQA8KarwfMJ9XOUOJvRSSKCXh1Qj6VT/Z2qv0RByzC/zcjlmAe1Yk08Dd3lFOnEf6o8xTVj8l+AI58ENkQeDlvpQmnrKwGVOFq6OT8FsfDKEogmURDOq5l0+jR6aFXyysKap77NrtSkU3M8adC/hINIrAq1OEguAN62r+gLFFjym5C8GO+65/tTuTDUM0/DVI2SPpJW6tx1W4WQkqDt+H+28JD6UI693SvcTHbX5rVXB59CeMJV9PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 (2603:1096:604:1fb::14) by OSYPR01MB5447.jpnprd01.prod.outlook.com
 (2603:1096:604:8f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 05:16:14 +0000
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::b01a:186c:94a7:acc9]) by OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::b01a:186c:94a7:acc9%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 05:16:14 +0000
From: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
To: "moss@cs.umass.edu" <moss@cs.umass.edu>, "kexec@lists.infradead.org"
	<kexec@lists.infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: Re: nvdimm,pmem: makedumpfile: __vtop4_x86_64: Can't get a valid pte.
Thread-Topic: nvdimm,pmem: makedumpfile: __vtop4_x86_64: Can't get a valid
 pte.
Thread-Index: AQHZAyGAOITJM2u3P0G+LOV0TMT94K5USqsAgAAfYwCAAATbgIAA7jYA
Date: Tue, 29 Nov 2022 05:16:14 +0000
Message-ID: <bd310eeb-7da1-ffe5-a25e-b4871ff3485d@fujitsu.com>
References: <ac8d815b-b5ca-4c4f-4955-ba9adbce8678@fujitsu.com>
 <103666d5-3dcf-074c-0057-76b865f012a6@cs.umass.edu>
 <35997834-f6d2-0fc6-94a1-a7a25559d5ef@fujitsu.com>
 <ab073836-4131-357c-ba50-0ed6ac4f6775@cs.umass.edu>
In-Reply-To: <ab073836-4131-357c-ba50-0ed6ac4f6775@cs.umass.edu>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB10390:EE_|OSYPR01MB5447:EE_
x-ms-office365-filtering-correlation-id: b72f9eed-c6e7-409c-d9ad-08dad1c8d655
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 RjfMFt6RCmi/sNtdX3ovNMiEbr5kW6QEV3mrFUs9MFJ7AdOYqJV+hDt2hr9//NF0qEVUREDE/n7AdrHGiVCHHyH4AVUHc47ks6jrrtrQOPNsCp7a8+klN1N33k0JaszgKYUoPjvzCB30zNak2hTWYDrZCAWinbd6aOXbVAbuUbwMf8I6G2QZk1bYvJ3UTSh7qZcg4DcCqL2DIgG/IzQxhbPMEROSKk/Qbltd8HN+yqFnB7rsBojXW3FYlfTj5cZ5nnZlCh5eURTVv8aWNF4TgYFpYH3cakvNnmtj7wlgPsT+s3PtBZIzv3A7OMU5zrvCpFCAuSPgO3SE3wzMl7Uo4y4FwKLXIKmt2bTtjd7URu3XZa2Gb2/93rMqyE3ELUtW+k21mM/G+iZUTekQuY1IDnYyr0NWNaeCPB+aIIC9r5Oyd7/of8dICTLXgZiRCRnBu+qfztjgy57TsBAUSJASb3haAsWy3/pQmqEWDFJJBhfFFMXbWeOX09yhE8SeRjcp/RiAQ4UdyQFynAnaDMbYA9lbasqC3JhZ3kFq7XtVUm77niQYncX3Cte5nftZsuzWSnQ1q6rrE/FUOnBDBHQquG5u9wXm3eVj3kGewUaWRX8QMW/nm7KXkWnKGaFs7FeyE5FNVrPHvZ0J/7Y7+ce0YWvlwSM/k+hCS1DjJQsydH0xoLmszuVtcz1sSlQNhMuSihoJCKsWpKl3TznM5agqp70Fl+dnsDwyT7Yr6qluG11aOVbEXBNGbC0fDyYfrA2qzgbAwuPrqae3vqvV2r3KLSMn8iuhKtuwNaa7N2QC879u3seqdP5r9O1rnQUdDOTB
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB10390.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(1590799012)(451199015)(64756008)(83380400001)(31696002)(86362001)(38070700005)(38100700002)(82960400001)(2906002)(41300700001)(66556008)(5660300002)(4326008)(8936002)(6506007)(6512007)(53546011)(186003)(26005)(66476007)(316002)(6486002)(2616005)(110136005)(91956017)(66446008)(966005)(66946007)(8676002)(478600001)(71200400001)(76116006)(85182001)(36756003)(31686004)(122000001)(1580799009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VXNMV2N6NEg0S1E0WCsxMFFTbVNiNlJSaFd4SDBMRmNqQVVMWnVZckYrMTRt?=
 =?utf-8?B?MThFZkpDRFdsQzdpczkvZ1U0Wm9LRlFFZTVmbnJXMmlQbUZQRVc4ek55OEwr?=
 =?utf-8?B?VnNGd1RKd3lPQTg0SWFDRUlQbWVMMGR1MVg2aGk1cEg0UGQxQ2dSeXZJSi9s?=
 =?utf-8?B?YVNzVFVkelZCZXplSnpmaXZ6OGVDL005Qi91SlJvR1RGZTFCSFJXdlBPM01y?=
 =?utf-8?B?MDdGdCtneng1QW5CWVZuemsyTDR2bUZLQ1ZrY0RCQVc5RnowZUFnTUp1WFpY?=
 =?utf-8?B?cElJNS9JR0p1ZkNBZ1pFc2lJWGJRbjhWZFFIdDFCM29mYWZUaW1xMDRQVzRz?=
 =?utf-8?B?NERpTVpJTGdyRlVrZmdTSTZQUU5GY1A5OVRjRTdtNWlmR2pRYW9kWldRVkxt?=
 =?utf-8?B?SWZHYW5GZXAwQ2F0eE9kem1VSkw2Z3RFSnN6YUNGQ24zelU3aXVCazFKWFA1?=
 =?utf-8?B?MkdPclAvTjFsUFIwZFZEdjJzdVVxeURuK1FRNkRWT0E0N3hmdVlhZzExb1ZW?=
 =?utf-8?B?QUdjWFVaS3FmRHNDSXBqTWJ4NnlFK0FCTVd0NXZWUDE5MCtOWGIzRmFKbXh3?=
 =?utf-8?B?a2xPQ3VBNzdGR2o4QTZMMU8rdDE3eFMwWEQyNWx3Sncyek41MkQ3b2ZtT3RC?=
 =?utf-8?B?bWhRUVRpaHJ4R2k5ZjFBSmhXMExBWnQ0NkhmaThDS29NWFJVVUVPSHI2d1FD?=
 =?utf-8?B?ZTJVQ1MvakRIODZpNzdtN3Rvcmo1cDEvRHRQWEg2UWtyYWk3M0thZ0ZZb1Jt?=
 =?utf-8?B?RmRrc3dXa05najg0RW04SHlOeUxzR29KSzhKMk5JVzFzb245ZWJpMEIrWWM3?=
 =?utf-8?B?NVpQNEF4M1VkRFZ6NDIvRVVXd1hsaHNYQU1IcGNMVzl1RU1JekZXYWloUkNM?=
 =?utf-8?B?NlBMWk1DR05vcDlVTzBiTGZ2Tit0VzhLdDJuK3REU1V3b1hJMFlYdW8zQTJt?=
 =?utf-8?B?Z09BVnV3SlpQelNBdmQ5MFJZZDd1WXNDMHRGNkNQMW45aEVGNHIxKzVQZFFT?=
 =?utf-8?B?V0F0dXRKVzd5Y1IzZG5mMVZWVTRlWFRjaVdsTS9Vb0pBckw1Q25GeEhaMTZw?=
 =?utf-8?B?eUkxVk9hcXQ0eVNKajdKVW9sdzJ2b1NUWS9mNjQ1NUo3c21ubXA4SUFjV1p0?=
 =?utf-8?B?SzhVVDhjU3lpWUtaQlJ4dlZZRkxUNXAvS0p0V3B3UElxSW1KMExuK2o0NlpW?=
 =?utf-8?B?UHNGd1BWRVdEYlJjZThlcjBaZE0rZFhNZ1M3aWNjWW9qRkJ1MVNEUmpKK3Vi?=
 =?utf-8?B?YkRsT1RJU3Y4bzdCS1dQNFdrVmQ1ZWR6cktTYjMzMDFUblJuSTFUWXFsaUlL?=
 =?utf-8?B?cG5FQStQemZER1Q4czZwWTFwc2I3dXVNTkx3dTEyQmttNGw2OXZucnA0RElq?=
 =?utf-8?B?YjB0Nm5EVnVzTEhlQytKOTFaczU0Zll6Q1NGb3JhRzRkeUlRSmRxenMvTUJl?=
 =?utf-8?B?WGdHNXhDSHQwY2NjdGpHYk5HZUdoYURKOWJ4SGJpbmNFcW9pdHJjVjd6WHcr?=
 =?utf-8?B?RU9tQTNPREhsRWZPRG94MlFENnZpWFgzVUZodEZTaS8xU0JaVWVFWWRlTHY1?=
 =?utf-8?B?d1hSRUtMc0JQZEYvNEl1Um1ibFkvb25wWHJrTHoyZDlQa3lQWGxwSE9VUkYx?=
 =?utf-8?B?UzZ5d2tPck8vSzd3TllNc24rL3RCdkFjZDVnRHFLYmpSc3hRbnFua0hCSGpw?=
 =?utf-8?B?TzRET0phMWJKUmdRbC9yNmJEaGFsbVdkVExIVHozb0NCYUpRYnJKaWFPd1pS?=
 =?utf-8?B?MjVtdHp6dHZpbDZEZFF1V1R5Y3pnNm8zcUhFODFjUDJqS1pJb2tLdk1EN2NB?=
 =?utf-8?B?cGNrVlVGRXhqY0x6NzVKcDNqVE5ZVTQ4YVFhYkd1Slh4WFZReVdaeEpML3hG?=
 =?utf-8?B?QXJER01xdWlDOGd6UjZsNURxWlYvK0lRU0FzenFZdE5lRThYMExpR0lTWlJn?=
 =?utf-8?B?SVpGK2FTc3M0cFJCOWE3ZG0rT1RtVXBBREUzTXdLbzJhbEF6T1VaQnpYUjE0?=
 =?utf-8?B?N3U1R1BZWGRNVVRDYUZMUGpaYmFUUUFxQ3BnNmtaM2Y5SFdQRHI4ZjlRV24z?=
 =?utf-8?B?NFNtMnl6eDAxVTlXRmkxdW1SVzJoNy9lSmlVUE9ldUZDT3MvZVNZUHZQbDk3?=
 =?utf-8?B?UWc3Um5hcVlzZGpvNDZtWWxZbGQ1RFFtWnBNUVBNc1RxcWxuTitBU2pZY05K?=
 =?utf-8?B?dHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D13E760271F344CB57D195665C50C3C@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mhW3JGZ3TQ0lSewbI4PBHGAq8ikyy1QZTzVVe3itux5U1PevLyda7VDw2cdlkf4YQmiU8q/K1z/cIGSQfkqrWCyb/9ohYLHnWI5cL3VCiu1kZZWYE/J/2rElmlh62Dw+RKrsKWPlAvjfHZFLLNBCErFR1FK9EMbuZ7MRX/jW57yFz/hby0NnHiIgiZgHb9lk8Haho9eorn9IBcWlhBVjsH4Kz63Dkx/mLGb3R/oxvy04BjltRgXDqMovIB79WewAmYs24DV8fSTvqdsQZ7+I1sTpX44kLlB9shI0h3+WHO4vkwP540LqjQU9KTeFBD5eTCjrfnhAIIC87wnf9TPGHNIRNXT2Tl3ufb0tUyrHJsTx4oSUqyu7gyH2bV//f5aOrZLcUTsN/A4Iv4h7Qra7zJy6QtnsDpFGD5Up3syONdacjmqmwPEHDAmLmNzJXG3v83FD19qVDiyE3p050bV06cTwJCKh9jQZqWbK+2+clkMh7wZTIlKtdbsZQSpRuMiUQnN+nbkAUmcdkTUwJ7fNDFiRUIqR9WmaGZgtLn4SP2hpRJViJXX23y9kr/h9gyYZgWSUNI2xQrX+PGmn8F0c3GOdg5v4WYjUW8pA4JjuQqahFiPFuQ1jw/jg3P0EIBbtbSkqXJrgnViIE2Q5L3E5Lak1Bsh+u1I0JiN68CvagtWLOv+FHoY4IE7oNbhVUVW1wQo21V2YKNaq+DAAVUurU+kGoLdo5DxdNXFuh2BGuEGUtMplqMLqF3iqJx8Ls3tk7c4Kdb5Wo/smNn/XOjwJAUVOVWujxr3gb+N5+6wnTBPJGbw/UCaCo/Xkk2vHsTR7/KLQU+TWKI6YXVbkxoM+Du6vRDLwzgTv8fyKYFq5mMNoUPajiXLFerghAN2T6i3xndKBxLREm/8e17aC5izEmQVCoYt3lgoAJRVOlkI2Hpc=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB10390.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b72f9eed-c6e7-409c-d9ad-08dad1c8d655
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 05:16:14.5805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 245mxKEe5d4hg6iq8erALrpbBmJTpIvMP/GTkhgkqg9CtNqYIZpRo0OW1WUjDAGANJx+vseI93xsVvsVcbXBOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSYPR01MB5447

DQoNCk9uIDI4LzExLzIwMjIgMjM6MDMsIEVsaW90IE1vc3Mgd3JvdGU6DQo+IE9uIDExLzI4LzIw
MjIgOTo0NiBBTSwgbGl6aGlqaWFuQGZ1aml0c3UuY29tIHdyb3RlOg0KPj4NCj4+DQo+PiBPbiAy
OC8xMS8yMDIyIDIwOjUzLCBFbGlvdCBNb3NzIHdyb3RlOg0KPj4+IE9uIDExLzI4LzIwMjIgNzow
NCBBTSwgbGl6aGlqaWFuQGZ1aml0c3UuY29tIHdyb3RlOg0KPj4+PiBIaSBmb2xrcywNCj4+Pj4N
Cj4+Pj4gSSdtIGdvaW5nIHRvIG1ha2UgY3Jhc2ggY29yZWR1bXAgc3VwcG9ydCBwbWVtIHJlZ2lv
bi4gU28NCj4+Pj4gSSBoYXZlIG1vZGlmaWVkIGtleGVjLXRvb2xzIHRvIGFkZCBwbWVtIHJlZ2lv
biB0byBQVF9MT0FEIG9mIHZtY29yZS4NCj4+Pj4NCj4+Pj4gQnV0IGl0IGZhaWxlZCBhdCBtYWtl
ZHVtcGZpbGUsIGxvZyBhcmUgYXMgZm9sbG93aW5nOg0KPj4+Pg0KPj4+PiBJbiBteSBlbnZpcm9u
bWVudCwgaSBmb3VuZCB0aGUgbGFzdCA1MTIgcGFnZXMgaW4gcG1lbSByZWdpb24gd2lsbCBjYXVz
ZSB0aGUgZXJyb3IuDQo+Pj4NCj4+PiBJIHdvbmRlciBpZiBhbiBpc3N1ZSBJIHJlcG9ydGVkIGlz
IHJlbGF0ZWQ6IHdoZW4gc2V0IHVwIHRvIG1hcA0KPj4+IDJNYiAoaHVnZSkgcGFnZXMsIHRoZSBs
YXN0IDJNYiBvZiBhIGxhcmdlIHJlZ2lvbiBnb3QgbWFwcGVkIGFzDQo+Pj4gNEtiIHBhZ2VzLCBh
bmQgdGhlbiBsYXRlciwgaGFsZiBvZiBhIGxhcmdlIHJlZ2lvbiB3YXMgdHJlYXRlZA0KPj4+IHRo
YXQgd2F5Lg0KPj4+DQo+PiBDb3VsZCB5b3Ugc2hhcmUgdGhlIHVybC9saW5rID8gSSdkIGxpa2Ug
dG8gdGFrZSBhIGxvb2sNCj4gDQo+IEl0IHdhcyBpbiBhIHByZXZpb3VzIGVtYWlsIHRvIHRoZSBu
dmRpbW0gbGlzdC7CoCB0aGUgdGl0bGUgd2FzOg0KPiANCj4gIlBvc3NpYmxlIFBNRCAoaHVnZSBw
YWdlcykgYnVnIGluIGZzIGRheCINCj4gDQo+IEFuZCBoZXJlIGlzIHRoZSBib2R5LsKgIEkganVz
dCBzZW50IGRpcmVjdGx5IHRvIHRoZSBsaXN0IHNvIHRoZXJlDQo+IGlzIG5vIFVSTCAoaWYgSSBz
aG91bGQgYmUgZW5nYWdpbmcgaW4gYSBkaWZmZXJlbnQgd2F5LCBwbGVhc2UgbGV0IG1lIGtub3cp
Og0KDQpJIGZvdW5kIGl0IDopIGF0DQpodHRwczovL3d3dy5tYWlsLWFyY2hpdmUuY29tL252ZGlt
bUBsaXN0cy5saW51eC5kZXYvbXNnMDI3NDMuaHRtbA0KDQoNCj4gPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0NCj4gRm9sa3MgLSBJIHBvc3RlZCBhbHJlYWR5IG9uIG52ZGltbSwgYnV0IHBlcmhhcHMg
dGhlIHRvcGljIGRpZCBub3QgcXVpdGUgZ3JhYg0KPiBhbnlvbmUncyBhdHRlbnRpb24uwqAgSSBo
YWQgaGFkIHNvbWUgdHJvdWJsZSBmaWd1cmluZyBhbGwgdGhlIGRldGFpbHMgdG8gZ2V0DQo+IGRh
eCBtYXBwaW5nIG9mIGZpbGVzIGZyb20gYW4geGZzIGZpbGUgc3lzdGVtIHdpdGggdW5kZXJseWlu
ZyBPcHRhbmUgREMgbWVtb3J5DQo+IGdvaW5nLCBidXQgbm93IGhhdmUgdGhhdCB3b3JraW5nIHJl
bGlhYmx5LsKgIEJ1dCB0aGVyZSBpcyBhbiBvZGQgYmVoYXZpb3I6DQo+IA0KPiBXaGVuIGZpcnN0
IG1hcHBpbmcgYSBmaWxlLCBJIHJlcXVlc3QgbWFwcGluZyBhIDMyIEdiIHJhbmdlLCBhbGlnbmVk
IG9uIGEgMSBHYg0KPiAoYW5kIHRodXMgY2xlYXJseSBvbiBhIDIgTWIpIGJvdW5kYXJ5Lg0KPiAN
Cj4gRm9yIGVhY2ggZ3JvdXAgb2YgOCBHYiwgdGhlIGZpcnN0IDQwOTUgZW50cmllcyBtYXAgd2l0
aCBhIDIgTWIgaHVnZSAoUE1EKQ0KPiBwYWdlLsKgIFRoZSA0MDk2dGggb25lIGRvZXMgRkFMTEJB
Q0suwqAgSSBzdXNwZWN0IHNvbWUgcHJvYmxlbSBpbg0KPiBkYXguYzpncmFiX21hcHBpbmdfZW50
cnkgb3IgaXRzIGNhbGxlZXMsIGJ1dCBhbSBub3QgcGVyc29uYWxseSB3ZWxsIGVub3VnaA0KPiB2
ZXJzZWQgaW4gZWl0aGVyIHRoZSBkYXggY29kZSBvciB0aGUgeGFycmF5IGltcGxlbWVudGF0aW9u
IHRvIGRpZyBmdXJ0aGVyLg0KPiANCj4gDQo+IElmIHlvdSdkIGxpa2UgYSBzZWNvbmQgcHV6emxl
IPCfmIQgLi4uIGFmdGVyIGNvbXBsZXRpbmcgdGhpcyBtYXBwaW5nLCBhbm90aGVyDQo+IHRocmVh
ZCBhY2Nlc3NlcyB0aGUgd2hvbGUgcmFuZ2Ugc2VxdWVudGlhbGx5LsKgIFRoaXMgcmVzdWx0cyBp
biBOT1BBR0UgZmF1bHQNCj4gaGFuZGxpbmcgZm9yIHRoZSBmaXJzdCA0MDk1KzQwOTUgMk0gcmVn
aW9ucyB0aGF0IHByZXZpb3VzbHkgcmVzdWx0ZWQgaW4NCj4gTk9QQUdFIC0tIHNvIGZhciBzbyBn
b29kLsKgIEJ1dCBpdCBnaXZlcyBGQUxMQkFDSyBmb3IgdGhlIHVwcGVyIDE2IEdiIChleGNlcHQN
Cj4gdGhlIHR3byBQTUQgcmVnaW9ucyBpdCBhbHJhZHkgZ2F2ZSBGQUxMQkFDSyBmb3IpLg0KPiAN
Cj4gDQo+IEkgY2FuIHByb3ZpZGUgdHJhY2Ugb3V0cHV0IGZyb20gYSBydW4gaWYgeW91J2QgbGlr
ZSBhbmQgYWxsIHRoZSBuZGN0bCwgZ2Rpc2sNCj4gLWwsIGZkaXNrIC1sLCBhbmQgeGZzX2luZm8g
ZGV0YWlscyBpZiB5b3UgbGlrZS4NCj4gDQo+IA0KPiBJbiBteSBhcHBsaWNhdGlvbiwgaXQgd291
bGQgYmUgbmljZSBpZiBkYXguYyBjb3VsZCBkZWxpdmVyIDEgR2IgUFVEIHNpemUNCj4gbWFwcGlu
Z3MgYXMgd2VsbCwgdGhvdWdoIGl0IHdvdWxkIGFwcGVhciB0aGF0IHRoYXQgd291bGQgcmVxdWly
ZSBtb3JlIHN1cmdlcnkNCj4gb24gZGF4LmMuwqAgSXQgd291bGQgYmUgc29tZXdoYXQgYW5hbG9n
b3VzIHRvIHdoYXQncyBhbHJlYWR5IHRoZXJlLCBvZiBjb3Vyc2UsDQo+IGJ1dCBJIGRvbid0IG1l
YW4gdG8gbWluaW1pemUgdGhlIHBvc3NpYmxlIHRyaWNraW5lc3Mgb2YgaXQuwqAgSSByZWFsaXpl
IEkNCj4gc2hvdWxkIHN1Ym1pdCB0aGF0IHJlcXVlc3QgYXMgYSBzZXBhcmF0ZSB0aHJlYWQg8J+Y
hCB3aGljaCBJIGludGVuZCB0byBkbw0KPiBsYXRlci4NCj4gPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0NCj4gDQo+IFJlZ2FyZHMgLSBFbGlvdCBNb3Nz
