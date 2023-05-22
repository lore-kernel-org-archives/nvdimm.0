Received: from esa2.fujitsucc.c3s2.iphmx.com (esa2.fujitsucc.c3s2.iphmx.com [68.232.152.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E614A23
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 06:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1684736824; x=1716272824;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XdCvKOr2pp9JQA9E6mbscSL2U3RATAB+1gV8H57gVa4=;
  b=sxqpb6aV0KgpYwnUEtRo94E8aqYoPPvNqtiLwQSSTBsNhBCFt1ksm4Jr
   wMm9EJP+7OciucUKAEsunewy4exd3OcjHn3VSHNg6TMHdK1rncxEDmvuC
   XbcSAs/dH4LDJiv9RblddMVFQXImyi7SzfN5qJ9/Csm4Cb/khhFI6Tyrp
   lPktcHlkQjY0QlXPM3U/4y5kD23qop7Jn1A64mUPeWxODdxOCvSiIGDaC
   JPvcZNMc+uyuOBEGW2XXe8PCuxmODXGVHKg/lzBe+P/yPmsgjfDI8K8K5
   1cGvHukstTfOvsbGN9zOst+yXjnGHrHl8McH5RCFStaXnZMQXqnvP5C9H
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="93215767"
X-IronPort-AV: E=Sophos;i="6.00,183,1681138800"; 
   d="scan'208";a="93215767"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 15:25:51 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoQiM+k2AMgAYvxj+jPvcoy7+BB0+wNkUag66q/Dmhr2hfPJA1dBsBQeXoMpzP8MDUX2+UvJE24JIVk/CjVaPPWrYPBTBoOsy0AwlQQF/S2XIJWIOAO0rvcj1QmIkCvwDgXX7+B9xOo8eAOo/vZ1SQonxDsPSTamtcxfeEhxfzFMMJMuT4zwRB5JDhgcIem2IHIr4X5AYnpQjUVvcXBULEnVcmgTVg7/c75ZOZAHvuElQTqjsRoXTxf3EcPw3i1MKqGqF3P6ZohvOHDX6Bd6ieWMMfYyJeowhNtDtpa6q3NALtVbAdiiYhHUjy6/mkhwJ5NyLi+ZThgHxfQxx6kEpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XdCvKOr2pp9JQA9E6mbscSL2U3RATAB+1gV8H57gVa4=;
 b=f/l6zXm2wriP+6mbpsiLIBZn1xJMaOrUUzazo8/JwPpuqJyz2haydo8MucNuFAMNcwNuX8yvRi9zQfaobUdwsv4oK9wUAO+JJAC4Dwm0+6H6nclRB5ZGfkPQApEwPPxwuSNbmH/URpW0mr41HzweyVwL6YQ9uvNoeKHP0HX8T9VDeteeTIsyXKbhGw6pJJ24t2UvnqHfHOWfyoJwivj97XmILHMlr8gH7bz4xqS6hS3Cl2iAhkNfJUp0aZ89yjLVax7+S4GGa6YA02XBVYE/z1pn7DceHr3a44SW7p+Fcfr15CHt2Gf1IXHP7kysNYDFLc5DLL17X56FB+Yn6fhKGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TYWPR01MB9295.jpnprd01.prod.outlook.com (2603:1096:400:1a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 06:25:47 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835%7]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 06:25:47 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dave Jiang <dave.jiang@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 0/6] cxl/monitor and ndctl/monitor fixes
Thread-Topic: [ndctl PATCH 0/6] cxl/monitor and ndctl/monitor fixes
Thread-Index: AQHZhaYdf+jS7VauDU6bory+c1//Z69h6MuAgAP4ZAA=
Date: Mon, 22 May 2023 06:25:47 +0000
Message-ID: <29c0e53f-689e-62d3-dcf7-bcf0ca88d919@fujitsu.com>
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <931ad127-4ff5-20b3-d551-9a144b3cd7c8@intel.com>
In-Reply-To: <931ad127-4ff5-20b3-d551-9a144b3cd7c8@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TYWPR01MB9295:EE_
x-ms-office365-filtering-correlation-id: b64c773a-e5fb-4e1b-1e32-08db5a8d617a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 eUMR98OMfzexHMFgQa2m97KM49fHtYnGhpwnGXgxjy3wbjxRSBdxuzL+izETlijr4K2S9F1wywhXD721YOqhFzfLkEQeAcmQHaeJYiW5y1riOwRCKM4ehhAGOcD3S5pTJqz1KCwofn20BCEQn38ikg50ExygIDsaKMcZuC0ovoU/LyFqg/XE1lW6R9O7LrJpqnq6UE7LZTpFeZrX9pdn0YbPpX9SHgdUyiWjM6BlAsjXC8mQ3VpW75Bt9K9Mor8wjO0171OYn9mu67Fmr0yD4XZO3q1TR5COOCTXizqbKi31A8jH50co0LJLbgX+0MonifSh2g5L04VEl0rJ4+DR9nSsxqsbfnIqpIz5BYhkFkF0OYgfGnO4gspMmOXFdLYdAjTecIzjnpKGjs5aQ6mo0yBX1PCNZr3Ei+kQZtrBVyBjsTsD7wiV3vXb1lKSt0HNYMfor8rxg6LYrGcgCdjfIlG0vKKIcCeibv1uKM/48vT6tShaH8JmzbL19vMbyK492wZP/PYqQw+OPIyndko/+Y/aAepC6b4B01L06uiw2COjS2ZcaHg/4igqxjhd9vaULz3q1cvc86EpA6pwDIgMQBBcj3PWw2P7TRVpj+F5nUcx2BrUR2tdNZAmwfxGCnWF6lhHY5FjZ2ehJi5e6Yit4TetwCixFLLsPRRtIo02BZ0UuZsnVlZwFpZoNNu33yTnvM8h5TUVGbjG3j5t3Pva6A==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(1590799018)(451199021)(2906002)(71200400001)(38100700002)(122000001)(2616005)(53546011)(6506007)(83380400001)(26005)(186003)(6512007)(8676002)(8936002)(85182001)(36756003)(86362001)(316002)(4326008)(41300700001)(5660300002)(6486002)(82960400001)(38070700005)(91956017)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(110136005)(478600001)(31696002)(31686004)(1580799015)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bXQxSGEraFZRc0FEWXI0RURmYTFIMzVwV1NTYlNieVlCd3VaU01YSFpKNjBL?=
 =?utf-8?B?WkFyY2k0ZXJNemJtOVc1b1ZFbTk3dXBGWXVNU3h3UDBqM3RFN3AzYW1aWGV4?=
 =?utf-8?B?VmwwcW50d2Z0a09XUHphWk9YWTdPOGk1T0tvTHVMcXdPa2tBc3BnZURxTVk0?=
 =?utf-8?B?VlB5Wm1Pc0ZJK3JKaHVJTitIaE9OOVBkSFVvUTU5N3haVFBTQmZaVFZzTEhB?=
 =?utf-8?B?cWdZZUk4TSs1RWo2QllKWG9ldDU4M1VvdmJQRkpnMDRyUEt5L2xZc2Qxc0ww?=
 =?utf-8?B?NnEyUjRwUHozejVGNlhqWWE0a3pwbFR1M2RmSGgvbUcvenBRRmU1bDVSQ0p3?=
 =?utf-8?B?akN5ZWFFUkRUNCszN3V6RnhxL2dYN2pzWHBwcWZRMlN1S1BkTlpRblIydUxI?=
 =?utf-8?B?VDd0UER5Zzd5bFlRQnZ6TExTanV1T1RHZzJ4c1IzdmZrL2YwOEMrRWNHUjJM?=
 =?utf-8?B?YTc3REFsaWJabnJ2bFRPOVd4S251Q2hnVkNWaW1uOEVtWVRTWWhNRFhDdjJF?=
 =?utf-8?B?ZVlMbVRuQ2xIY1BTSUhHOUxjSjZoVTBVM3FWMzNxTGVVamFQYTR2RFpZR01w?=
 =?utf-8?B?WWtqRTFITGdtcUF4bHFCNVpTMzhVaGcrSmQ0b2k1Ym1oa2dRV1dOUEYveHZk?=
 =?utf-8?B?azNXYU1PdnNNckljdzVqL2tQWHlqWDZqalJacHVQQ05BOHpvOVVneUtBZGRM?=
 =?utf-8?B?Y3dnQlBnZ1dXVjZEbFNQYm8rRnNmeTJqKzNlRTFBVG9sUGNZWWpUOWNLU2E3?=
 =?utf-8?B?OS9WK2dzMEFyMENxSy9oaCtXTldrR2E2ZEFxSkZ4ODRQS1ppRjk1cUFNelU3?=
 =?utf-8?B?R2c3RUh0LzI3Wk5PZVU2OG5KWU9jTmdSajFJTTlQZi9VYXFVMFhrY1RUZHA3?=
 =?utf-8?B?RmtIKzBvL25EL1ltN3NhNHNwUGF4UHhudnpMZnBPR0xQV2VuUWVDZnlsa1ZD?=
 =?utf-8?B?bitSMjlmZ2EyL0NtSlZhTHNlODlTdEgydlY0SzJKOUtHdVhmaUFTUXhCdUdu?=
 =?utf-8?B?SGxROC9LREtxUkRaUVg4S0lWd1BITDVQU0I2emVobW5QcGc1OE9pLzV0M3VY?=
 =?utf-8?B?T003Z1V5OGlGTW9oVnZBbXc4ZVFUNmFwTCt0aVhyREhCRW5LSC9DRDJTVC9H?=
 =?utf-8?B?MmkwTFBTRnNxMGFPdEdrVkttSk94MkF0bDBqZHF4UzFRd2tDdmF2YXE1a3J5?=
 =?utf-8?B?TmVYQ2p6RVRlU0ttLzRtVHV5MkRydnJsQ2VBak9ZSzNsTWtVT2M3RUVwS0Vj?=
 =?utf-8?B?T2lmTUxtOWEyOEczNWJsNVZOakpPRmxVQjdpcFd2K0laVHdTclRvendlc2lF?=
 =?utf-8?B?c3pLS1BBcTVPNVptZmpMTTBtMUswWlRZUUhiNk5DNnFwSDU4QjhJWFgvLzJi?=
 =?utf-8?B?Nm56Q0ZFQnNaT1k5RHI2cnJ5QWhSWURHczh4T25Ic1RGYXhGM2Vzdm5VOURQ?=
 =?utf-8?B?enM4Z1RTSm9zWktVS2YyVnNjcC9JMmp4MGpjMHdkYjNCUGhsaUlCT2VZR1V5?=
 =?utf-8?B?T2t4MnI4Tm9PcTNjVm4yTC8ySnUvSmpvUGVLQWVRVG85S2RkcStBNnYxQTcy?=
 =?utf-8?B?OUsvemwweUhGVitiU0xlUi9EaEpWUE05dFZrcklGQnRKWldOUUxJQndubEdi?=
 =?utf-8?B?MHdGNjBGK29BYlg5MjArc0tHOEhaNklhdEZvU0lkUGdPRW0zeC84VmxtUVEw?=
 =?utf-8?B?R2tKT2kveW1FRmYvKzM4T1dFbGVWVWt3TjhqYmtsNWkvUnJUdGF5YmpSZTBD?=
 =?utf-8?B?TzhiRExUQVUvendqbXRxSjhvUFBHc05obkFYZmt5TG1kZ3QwOWNDam1yU0RU?=
 =?utf-8?B?akcxdlYzZmRvdGxXZStWVDRlVjNra3NmSzJvUjFreGlBQm1WUmFRb2pSV0Rt?=
 =?utf-8?B?MDNva2R5bWw2U2pTelkzS3Q2K2xqNzJXaXRNNEh4YnhYenhRWGx2VVA2S3ZX?=
 =?utf-8?B?dmkwME1YclFjNTltb29rbVBUQ1pmRXA3WDE1R1BZa1dHWW9qeHJ6MFk5WGU0?=
 =?utf-8?B?M3ZxMWJkMWhjOEp1NkdzciswTSsrREZTVE9JYlVKMWM4Y3MvZU9WUEtUWUhE?=
 =?utf-8?B?cHBxTmFTVll2bW5ESm40NkFwUjRtMFRzcmw2VHFoemtyaU1EQ29rUmhkbWcz?=
 =?utf-8?B?VTQrOERQbWNac29tcVV4U3VSREJ1SEJxSW5xQ2J3SndCWUVaOHVvcGVLQTkw?=
 =?utf-8?B?QWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <358F36E4A8AFD44E8CEB64312AEEC2C7@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NxH66VLpB5wwKlHUz+P/OgYqbZHXoo8jRs3gSEbUd6Ba6rKsOCihKfZ7bqGPEhRLYL3yzn9TQ7e2hAU0n5PG4UoQOof0tsR4XaW/Khdir/PM1lUUaJa3GL3y6JAyhh05YkmUQ6E0mVrXmGlf/5pEnDHvTvfevbYhW47SSd3OQwhBUSo0fo11PojCz7YpZ3TMWuqamJXKjPsbBEukWRCc12WM3XwC3zBR5mH7+I9C+UpSH8dh22RRxDo5UkcmgHwOFJltzb9icC4UTvcIDUrWQ0IHGvQafCW8oeSlbaIDGcKB4xOVx1o4uOgE9BazfyXuitVx8MphETQPKxPppIjefYy+v45OrRKMuFCVLPMTvmcDo+cRobc6s72zr7Ets0IEECctQUy2Ff1BAUq0g2ysuymV0BJg4/lSpB0eA+gEfGasvviA6dupksnGz9Pp02aEZGeFF8Vvnkyz2L8n5+/sxecCWcezdSwGEW55Kbw3LMv4TnY1xBTG30K8oavjO+YUJ6dVVqJ+dELQiswNvPDpRxprZgfJc0RfYcSXvVFLafCxQOGO9mYDKpdh44TsRjVp81v3jUReIjGOZU1j30p3oXKYySI2jZSOB78v0iGoDLumdCdgjJmQ0KzFwBsUzysTMl5Yfydvh5ZFwxBgxkuM1pTZBVdCYzELHh/0LuNVqWwllcHC/2MyVF2+7OAT2eyz/70H3FVSWmXbSL3N9Ch/9InMGT0+kOECXiqSlvta4uT8qweDn8nZcryV5Oxuo1pjt09HIqbGEKHFnvacC3ezKr6RB+xLIAUxurYO9trTdp3Ve09IR/u/PWH1Q06iNAcQvNMgww9FjpnBGqwn6HI7mA==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64c773a-e5fb-4e1b-1e32-08db5a8d617a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 06:25:47.4875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mj8RgD0blOgG4Gl4wHHgas9CnCmWszwXMqoK7sICvwsFCGjLVrQgLeSvAhBqIIBaK+nU40CyZB2njUiuN7ukTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9295

DQoNCk9uIDIwLzA1LzIwMjMgMDE6NDcsIERhdmUgSmlhbmcgd3JvdGU6DQo+IA0KPiANCj4gT24g
NS8xMy8yMyA3OjIwIEFNLCBMaSBaaGlqaWFuIHdyb3RlOg0KPj4gSXQgbWFpbmx5IGZpeCBtb25p
dG9yIG5vdCB3b3JraW5nIHdoZW4gbG9nIGZpbGUgaXMgc3BlY2lmaWVkLiBGb3INCj4+IGV4YW1w
bGUNCj4+ICQgY3hsIG1vbml0b3IgLWwgLi9jeGwtbW9uaXRvci5sb2cNCj4+IEl0IHNlZW1zIHRo
YXQgc29tZW9uZSBtaXNzZWQgc29tZXRoaW5nIGF0IHRoZSBiZWdpbmluZy4NCj4+DQo+PiBGdXJ0
dXJlLCBpdCBjb21wYXJlcyB0aGUgZmlsZW5hbWUgd2l0aCByZXNlcnZlZCB3b3JrcyBtb3JlIGFj
Y3VyYXRlbHkNCj4+DQo+PiBMaSBaaGlqaWFuICg2KToNCj4+IMKgwqAgY3hsL21vbml0b3I6IEZp
eCBtb25pdG9yIG5vdCB3b3JraW5nDQo+PiDCoMKgIGN4bC9tb25pdG9yOiBjb21wYXJlIHRoZSB3
aG9sZSBmaWxlbmFtZSB3aXRoIHJlc2VydmVkIHdvcmRzDQo+PiDCoMKgIGN4bC9tb25pdG9yOiBF
bmFibGUgZGVmYXVsdF9sb2cgYW5kIHJlZmFjdG9yIHNhbml0eSBjaGVjaw0KPj4gwqDCoCBjeGwv
bW9uaXRvcjogYWx3YXlzIGxvZyBzdGFydGVkIG1lc3NhZ2UNCj4+IMKgwqAgRG9jdW1lbnRhdGlv
bi9jeGwvY3hsLW1vbml0b3IudHh0OiBGaXggaW5hY2N1cmF0ZSBkZXNjcmlwdGlvbg0KPj4gwqDC
oCBuZGN0bC9tb25pdG9yOiBjb21wYXJlIHRoZSB3aG9sZSBmaWxlbmFtZSB3aXRoIHJlc2VydmVk
IHdvcmRzDQo+Pg0KPj4gwqAgRG9jdW1lbnRhdGlvbi9jeGwvY3hsLW1vbml0b3IudHh0IHzCoCAz
ICstDQo+PiDCoCBjeGwvbW9uaXRvci5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB8IDQ3ICsrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0NCj4+IMKgIG5kY3Rs
L21vbml0b3IuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgNCArLS0N
Cj4+IMKgIDMgZmlsZXMgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRpb25zKC0p
DQo+Pg0KPiANCj4gUGxlYXNlIGNjIGxpbnV4LWN4bEB2Z2VyLmtlcm5lbC5vcmcgYXMgd2VsbCBm
b3IgZnV0dXJlIHJldnMgc2luY2UgdGhpcyBpbXBhY3RzIENYTCBDTEkuDQpZZWFoDQoNCkkgaGF2
ZSBkb3VibGUgY29uZmlybWVkIHJlY2lwaWVudCBpbiB0aGlzIHJlcG8gYnkgJ2dpdCBncmVwIEAn
LCBsb29rIHdlIGhhdmUgdG8gZG9jdW1lbnQgaXQNCmluIHRoZSBDT05UUklCVVRJTkcubWQgYXMg
d2VsbCA6KQ0K
