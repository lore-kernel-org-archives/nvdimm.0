Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com [68.232.159.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F5B10F9
	for <nvdimm@lists.linux.dev>; Tue, 27 Jun 2023 10:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1687861116; x=1719397116;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vtto/2UwwZOiNco6j+Iga+P/V+YSE9vPJTxMopq1sK4=;
  b=g0fcEcy7ORjin+Dl417ptcQgeRGQiy5eBOc3eIo/RF1qzvVnz15AMbyw
   85A72LLnooYsAh3IbkEO73ijopOapHoozqDwGWwbq4mIS1LHzmNOUiLWT
   Y3KxyGMcNy7XUgNOqWFnRmbIn8VLIlbRSaVJl051GyJmjDwEDIc96ihOG
   T9FZpvbszZc4zSajvR2hOlY1cHS1P+EyZFzilnwk10mc6y+Dsm9QwfAfz
   8Xt8yXn50m4muAWFQh8gCvuS5aaopXcyoFxqT1aKt+VapyVt6WSvEviM5
   FDJpFKq/jeod5dNxr6ycSOH1SaXy4EC2uxt5XSmw8nrq878kHMM1Qt+up
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="88306912"
X-IronPort-AV: E=Sophos;i="6.01,162,1684767600"; 
   d="scan'208";a="88306912"
Received: from mail-os0jpn01lp2112.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.112])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 19:17:24 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auEMCZRMrozKwuvl48bjYMobedSWEesI4k1w5KEFwyI4/tiTvKveWBisK+DOz9k5xnktOecM2NYDGEWPxnPdHf7YVWbI8DKcs/XTDUjKp6ERoY33tfkEnjmqYAIxaVggWsPIxqMEv8Ttb6s96xKFGOOpYK+6pBQo5e0Dew2M3Znpynr5Sl1I+ETcfMlgP6vsW2tiBRjq0HqLSIr4uDJ0jK7kCE+QvriVoO8diEf6obmmU9f3oioNDWXh9DPJlEdtliGI1OnXugqI+KwPXd7HdbvaTogauLM/jYEC9aIHkSjBoCZtuGVmLT4VPmfv8CsgD7TiP/4HlAB/AcbxQKkOgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtto/2UwwZOiNco6j+Iga+P/V+YSE9vPJTxMopq1sK4=;
 b=XuuHpkn9OL1xZB/5gKj4lKaWMP3KDUaCGP9+0lxvpEaQpI4c6M2hxbXPQvriRINFdAVaESdFSO9zZcU/0ksyIBJKEyiR1dtlOcXxIaqB+4RsWdZO7NwdHgBHK2lNYjnq60Ugloa+H3EhUdzdEDfa20PQiMkpg4sQ8sJ6Du4vk/tE2XyMlPsdBu/iBCpIJbspPv5XGShG5nor4foaKlhcLFJTjym7wgCFs0GX6sn+/cVffq18qMB0ywZXwPpntCliOI5OU89/w+f3xuMfRMoPkDtG5OQQVKy0ru0kiuF/XIGBwnXoa6uGjGlWXePL5EDCQQJqFjTWP62BgapKHkjlfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by OS3PR01MB9992.jpnprd01.prod.outlook.com (2603:1096:604:1df::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Tue, 27 Jun
 2023 10:17:20 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::6d6e:460b:60f2:8d91]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::6d6e:460b:60f2:8d91%7]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 10:17:20 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>, "alison.schofield@intel.com"
	<alison.schofield@intel.com>
Subject: Re: [ndctl PATCH v3 0/6] cxl/monitor and ndctl/monitor fixes
Thread-Topic: [ndctl PATCH v3 0/6] cxl/monitor and ndctl/monitor fixes
Thread-Index: AQHZk2ZevVkcGUpVn0aSoZllGqanDa+emk6A
Date: Tue, 27 Jun 2023 10:17:20 +0000
Message-ID: <f83e918e-ae85-cbfd-dd3a-0ef3f1519cd7@fujitsu.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
In-Reply-To: <20230531021936.7366-1-lizhijian@fujitsu.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|OS3PR01MB9992:EE_
x-ms-office365-filtering-correlation-id: 19291e8c-c27a-4c63-ac54-08db76f7b133
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 h8AEK/iQDerhHM9hxGJe9KCGsjZugWp/4OEIVYhFI1v4lLVOeggf1mtJvXx1yjsKFM3Sc5rv0+POO2wfjKQIHxKruCE/PYuIFkmjdNfm9W1SLadajRswCqkVy1cOi3WTjUhbEtOamwlUwlhgAG64S/6sGPB5xZi6M/SIN2j7QI8uvBdSMTGzZvbthYqiZX9R1qtVXrpQLGYwNp751247kOeJH8biJAJzNV2Akr4wGC8XrGxyL+4Q0i9N5g3P4ga2rIuPcx5ZpnC8jT09X3OWmGTtv8Wcie1o5o/I47UTM1QLVMqWTqx0Zym6dc1Cxhhuz7NpEPX2EWFI3STruWPpJde+RhBHJ2aZqx9W4wYiRnjQt8WgTrqRtWuLMABaSGmvQqtd/mNLUz9TtFkxmAQvHV+KBJkqSqM9CFqzGm0C9yubKW5kyG8HsckRiCUMNX712Frh/C/B0L+B0sdNBRKLJdStGypPG+k9+PeNi/ijfcxPIYc0pqt3aZfGn6utQZcQdGOyrVOdLpW5+iVhe3dxjiwXS7tsYKQmHOMIT6OweHJSO+CrC7AfFi1WPs1mUNAcoGbxNhVnk5G/sTkh3dZc2Xg8Io/GrfhBsqJrqc+ZrKkTk8RTDPQfGfMsT6+JqfZywyUM3+hk6jXIQeL1SzJNNZBMinrWv7RBV38ocuA4rx/44Jyp1tbORJQ2nBBIwVdSbu1IhFEogd+fUKaba7ckrw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199021)(1590799018)(316002)(76116006)(66556008)(66946007)(66446008)(64756008)(6916009)(66476007)(38070700005)(85182001)(478600001)(4326008)(36756003)(8936002)(8676002)(91956017)(5660300002)(1580799015)(31686004)(31696002)(86362001)(54906003)(41300700001)(6486002)(2906002)(53546011)(186003)(6506007)(6512007)(82960400001)(26005)(83380400001)(38100700002)(122000001)(2616005)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QXVBNUw2cFZXbG5mMDIvdmRvbkpCYjVtb0lIN3Q5aDhMZU1pbjkyTjJzdFZC?=
 =?utf-8?B?UHhqeVE3cmo0VUNUbG1LM3NvL1E4YUsvdmMxTGdqbkFuSTk0UnJYQ1liS1Uz?=
 =?utf-8?B?enMwQnFTL3BYRE5rMWV0UzhFbGdIanBxOWlzUGxkREFRS3o3V21rdUpXSHZ3?=
 =?utf-8?B?MUFyMVhZQk9EaVY5Q28xMVlJMDcwYnpmb05oTXJFQVJ3S0h0UlUrQS9SQldS?=
 =?utf-8?B?aDBvU3o5N2JIN2pPWUxWNTdaeElsNXdHazdRN29UQ0N3Z0gwWi9pRTJadWpL?=
 =?utf-8?B?dHhjTEFTanJWOFdOT0xWV2FTbTFQZEpqWkFJUE41elV3U1BRbzlvZ0tnbTJY?=
 =?utf-8?B?cFU3b00zZTBtVDJ2SHFiVFRsQVFobEVNVjcrUnhJd1VKUGFkSmtkcXQyNnk1?=
 =?utf-8?B?MVVNR0ZPZjFNTW1yKzhQTDc2SGxQYm9UT1RVVWsrSDdId0lEUFlOeXBNYVAv?=
 =?utf-8?B?RFVzTjdLR3IxRklxRENteEJtc3pRMHJ2dUY4dFVvUXZRZ2E2UUx2ZmUyZWxt?=
 =?utf-8?B?TytPYmJwV3FLZHM0UElMSTNEemM1M3k5V29zTVdDbWIrR0hmN2NDcE9HU2xa?=
 =?utf-8?B?eVk5b3FWczVlWnJXVWZ4WDRKNTlqZnRKc2h5d1RpRG1ubDE4WW5tNXQ0KzBQ?=
 =?utf-8?B?bVNqN0VsNk1zd0RVMFREL2hFWEhrV2IxTittZjMyai9DUFlaOVA4dHI1ZjVI?=
 =?utf-8?B?R1hNZVFTb1BzTGlaaEp0b1RUNHo2cEFNV0lrN2VMQ0tLMkVFRGNKa1A5UTh3?=
 =?utf-8?B?a1lZNE82Ym1XNzdIUTFrTDJmb2NudGtTRWEyZUdOTUdHSTlTY3AvVTVMZFRK?=
 =?utf-8?B?dXJpSnFkUE02UjVwa3hrZEtVakFDcWsrdGtvNW5rUmw0c2dFd1MrcDlicld0?=
 =?utf-8?B?bnJqMlFZNGFZWWRidStqZ0o3ZDRrd0NiNmNOYm1rZ3lHM0lGelZINUlESmpv?=
 =?utf-8?B?TjFESVZZZFRsaTBEK1ZRU3NvK2xSbFJyWnJYNmUxckNHZkVoc1pqV0dBSVA2?=
 =?utf-8?B?dElPOUVVVGRtdUlTUWxqYlpLSlZLTkpjSkV2ZVBUY0Fsd1crenAvMWpRTlQ0?=
 =?utf-8?B?NmZUNmdkdkRRVnZLUDU4YmhpWkFla2FWYThJR3pNakU2aUFPUE1XTDBXL2lN?=
 =?utf-8?B?M1NheUxQNFpQV1ExckV3MVIvUVkyeTdhVld5ZUNjY1ZMMHJxOXZCVFNSdjRu?=
 =?utf-8?B?elJZclFoSUR2bmRtYjM0NHNQNFVoN29HYm1tcHRhVFpuMURRS2FhY3AzZjMx?=
 =?utf-8?B?c2Nsd2x2OG1IbHdYbWZEbkl4UVFkQVlVOXdCSVJQMFFjLy9CcExBays2RTMx?=
 =?utf-8?B?aHdZd25lUWF5bXI5bmZVRDUrNGRWYlZjVjFkWVBRc3F0SkdxS1ltNjhGV2My?=
 =?utf-8?B?YXdoTWZHREd3VE9rK3FDNFg4bWdpcGwyODJMY0U1ZVFkdHJaSnA4YXFsM3Fn?=
 =?utf-8?B?aUd5Q2ROaVVJTm1PTWpyTkNkYmZHYkpSVUd3OUV1QlljYTJhWEk4UXA4YW53?=
 =?utf-8?B?eUdaTHlmVTVWMGVpS2lDQXhwMEJRdXY2S0s1U2QyWmhRY3VRQmIyYVFIQ1Bx?=
 =?utf-8?B?Z1NaaWYzUjE0ZUxxNGl2Z3Bnem56V0RpSjBsS2podFhZVGhWNHVBaWlNNEcy?=
 =?utf-8?B?YjRHQVlLWkxGQUR6clVVaHg2Z2RnRm91V0I0ZDlhaXBydjkxa0ZPaHJERWxP?=
 =?utf-8?B?bVZzTytDZWtaQzFhTkY2aWl3Y2VlMGF5Q3FyZGpzRUdncHhZdUhtRGpTZElE?=
 =?utf-8?B?Yk53RDgvYUxqb1JNb21yQWc5c1VjMVhlNldoQzFTNjk0a0ZlbUVPWDhEWUx3?=
 =?utf-8?B?blR5NVJJb3p4N0JmRWZMTnFOWWJJa3VFaHpiUDY5WGdiQW1hS24yRm8rb1ZU?=
 =?utf-8?B?NmJ4R2dIZ1d2bVp1MldTdnYrNm85K3FpUVRia3gyZVpSYmVETis0eE8rdkhs?=
 =?utf-8?B?aUV0bjlrTFdJZkd1ODAvbXJRVGgra0phc2RMejliWDlYdkViRW1Kb2hvbENh?=
 =?utf-8?B?VHUvaGRVenZMcjJKdXNvVDNHN1k2bGZsanliWWNyUFA5Yjl4eDJTN09mcHRm?=
 =?utf-8?B?c2JhaHJxcTNQUVhRMXdjanRmbXRyMjYzZjF0QXU5SDZuc2JqVjM0UjFyWXBv?=
 =?utf-8?B?UU5WREJKZk9EdFQ2d0t0TXplOXR3bUdKaHFsek8vZllDZldJU3g4RHVZR1FN?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <231C5FE79234674FA7675C2A37F14A1A@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vjo1C+G6tFh40fVVSYK/o6o/7Ntn3fwH3AKdGEct/FuXbioppE8X5rcGwUNHbaz+34NqGGxEl8jVCw4pED5F/In3QoMCynmwoHC53rTosGTy8+ftGxucEw9UDEzTFsLzWV2VowQlSaWTjBKt49Y+plMJvhBwPc+OV5Gd/Ds9DRuDjhTBFkV0UIIj/ymnaQAs3et6SylMU2/7QlkyWfqJ7zaXjuJKKEVPEztAy1hnp53KutNQS+Fugb9YjgQtur0ENfTIFg4Ffr1RWVV6qyWs6Wtqdl3/ILSQBi4WyxVb50qjUfuzW9xcL7QWXU7+DhPoLu+Riz5OwwOhRpZey5eQoA7DWKZc9WwepqAe3hm8U+izfy6FNdtFWouuyPsOLWcHQ0iHLfNU6TQzt/TzY+JiQk+N+fpPUWsW1gzQj95XDInc0gwWnLX0j1XEcXIPwP47528hzdxP/VtKE2sqmNogBp1QaB3aQXzlaP/h/GHktaj3xUq82lzyIt9uUNR5aB/8IAqKMXUIxI57LzxNGuSMTJec6lEWDmiRMxT/rzoxuiCkDSrQdHzdWaIJEXfqW0SpOBUhviD7ciOOcCdpfZvfZYbDaN+JSE/a8T0n1oxk2Mm0JYcIFmf5sMbOpURleQApvluQVbPcGoU62FEdT7Kt0K+mhjcGxu9tVAQFYWkmBplHLWqNMgvEtleeVXbpz9JnDJwrUCyxtC9+JSCOHO9MvNpPOaNYqxiHQO3ePERlVlSVhRcGJjpWmFoSAzt/vXDaWAKcPqJQOC/azdbciTqtqKh/54i0zVwMmF/3W2VTOloR10wC+tvPtJCOIXy80k/H6qC+82TppaBdAeQpWXvR0A==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19291e8c-c27a-4c63-ac54-08db76f7b133
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 10:17:20.4648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fKK6xCTUAtHEgaBsyZ7FBX6hJrwJICyWdtxTtWWd2haYs51P0O8TlELI8PplTymzqlJwxvTpNUbO6AdoksgrHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB9992

a2luZGx5IHBpbmcNCg0KSXQgaGFzIGJlZW4gYWxtb3N0IGEgbW9udGgsIGFuZCBpdCdzIGRvaW5n
IHNvbWUgYnVnZml4LiBUaGUgcHJvZ3Jlc3MgaXMgYSBsaXR0bGUgYml0IHNsb3cgYW55d2F5IDop
DQoNCg0KDQpPbiAzMS8wNS8yMDIzIDEwOjE5LCBMaSBaaGlqaWFuIHdyb3RlOg0KPiBWMzoNCj4g
LSB1cGRhdGUgY29taXQgbG9nIG9mIHBhdGNoMyBhbmQgcGF0Y2g2IHBlciBEYXZlJ3MgY29tbWVu
dHMuDQo+IA0KPiBWMjoNCj4gLSBleGNoYW5nZSBvcmRlciBvZiBwcmV2aW91cyBwYXRjaDEgYW5k
IHBhdGNoMg0KPiAtIGFkZCByZXZpZXdlZCB0YWcgaW4gcGF0Y2g1DQo+IC0gY29tbWl0IGxvZyBp
bXByb3ZlbWVudHMNCj4gDQo+IEl0IG1haW5seSBmaXggbW9uaXRvciBub3Qgd29ya2luZyB3aGVu
IGxvZyBmaWxlIGlzIHNwZWNpZmllZC4gRm9yDQo+IGV4YW1wbGUNCj4gJCBjeGwgbW9uaXRvciAt
bCAuL2N4bC1tb25pdG9yLmxvZw0KPiBJdCBzZWVtcyB0aGF0IHNvbWVvbmUgbWlzc2VkIHNvbWV0
aGluZyBhdCB0aGUgYmVnaW5pbmcuDQo+IA0KPiBGdXR1cmUsIGl0IGNvbXBhcmVzIHRoZSBmaWxl
bmFtZSB3aXRoIHJlc2VydmVkIHdvcmQgbW9yZSBhY2N1cmF0ZWx5DQo+IA0KPiBwYXRjaDEtMjog
SXQgcmUtZW5hYmxlcyBsb2dmaWxlKGluY2x1ZGluZyBkZWZhdWx0X2xvZykgZnVuY3Rpb25hbGl0
eQ0KPiBhbmQgc2ltcGxpZnkgdGhlIHNhbml0eSBjaGVjayBpbiB0aGUgY29tYmluYXRpb24gcmVs
YXRpdmUgcGF0aCBmaWxlDQo+IGFuZCBkYWVtb24gbW9kZS4NCj4gDQo+IHBhdGNoMyBhbmQgcGF0
Y2g2IGNoYW5nZSBzdHJuY21wIHRvIHN0cmNtcCB0byBjb21wYXJlIHRoZSBhY3VycmF0ZQ0KPiBy
ZXNlcnZlZCB3b3Jkcy4NCj4gDQo+IExpIFpoaWppYW4gKDYpOg0KPiAgICBjeGwvbW9uaXRvcjog
RW5hYmxlIGRlZmF1bHRfbG9nIGFuZCByZWZhY3RvciBzYW5pdHkgY2hlY2sNCj4gICAgY3hsL21v
bml0b3I6IHJlcGxhY2UgbW9uaXRvci5sb2dfZmlsZSB3aXRoIG1vbml0b3IuY3R4LmxvZ19maWxl
DQo+ICAgIGN4bC9tb25pdG9yOiB1c2Ugc3RyY21wIHRvIGNvbXBhcmUgdGhlIHJlc2VydmVkIHdv
cmQNCj4gICAgY3hsL21vbml0b3I6IGFsd2F5cyBsb2cgc3RhcnRlZCBtZXNzYWdlDQo+ICAgIERv
Y3VtZW50YXRpb24vY3hsL2N4bC1tb25pdG9yLnR4dDogRml4IGluYWNjdXJhdGUgZGVzY3JpcHRp
b24NCj4gICAgbmRjdGwvbW9uaXRvcjogdXNlIHN0cmNtcCB0byBjb21wYXJlIHRoZSByZXNlcnZl
ZCB3b3JkDQo+IA0KPiAgIERvY3VtZW50YXRpb24vY3hsL2N4bC1tb25pdG9yLnR4dCB8ICAzICst
LQ0KPiAgIGN4bC9tb25pdG9yLmMgICAgICAgICAgICAgICAgICAgICB8IDQ1ICsrKysrKysrKysr
KysrKystLS0tLS0tLS0tLS0tLS0NCj4gICBuZGN0bC9tb25pdG9yLmMgICAgICAgICAgICAgICAg
ICAgfCAgNCArLS0NCj4gICAzIGZpbGVzIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyksIDI2IGRl
bGV0aW9ucygtKQ0KPiA=
