Received: from esa13.fujitsucc.c3s2.iphmx.com (esa13.fujitsucc.c3s2.iphmx.com [68.232.156.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C887187C
	for <nvdimm@lists.linux.dev>; Mon, 15 May 2023 10:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1684147220; x=1715683220;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=Dz+9xF737aJtyqGP1b0wxvz6YEXYta4LcLejQqLBWgs=;
  b=QItiAmxcgKgPi29oyAiapn4W935Jr6jx7QmJkLcvspONPpD+GbFmbSwg
   1LXiLyuVmrvwa6Id0wszi20yzEacKZGpPRo8fniNf7tPd8p6ACZbYAUOU
   xTZcWkevDQWm6a1o5wupPQI0gUUwe3/RBfThjCBVWNcoEHMS1Ytgo7Tx+
   pkFZHE+DP7ZVTyZQVrtAFooJsHUx9qS3uxYDSyxNY8PvpXh6ppRU/EY53
   14m4vFRMDP8w4vY6hXP2Yb/nJ2MRce21PpTgedhLnXwuudo0ylCAnmUmm
   5McpsBp/OTA4PiG6WLKlHEzNIrPlfI6UKYyu/ZaR5Lb2LieY84U9JabTo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="84079320"
X-IronPort-AV: E=Sophos;i="5.99,276,1677510000"; 
   d="scan'208";a="84079320"
Received: from mail-tycjpn01lp2171.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.171])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 19:39:08 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EntX5zYbYC6k4oaMfn8hfZA3aMhbbRZn+1PNHxyA4I3RunrNALKvNwXmZhgH8akavqh6QZ9LgKJJ0bn4N5R4QPzebLTryMAe44gRcQcvJdVMdsKfiOeHmpPfNgLRgkL4ZKMpHuhCYjmJdddImjHzqprsL06D0fHfq/Nvc+qsgfuFVMChToeUIfGGmPE+Zg24CChdsIq1udmvwgCUk36n4g4VxCOH6Z9TP9lLtd/6btAcEvNYzuekVQ1MhY2CZdmVVmqUi7BXwjxSPok/yaVXjtuZRpXzhG30mAGngx/sQvaOkZKtpUwYuY+HCa+/qiU2AAf8ksyH2M2iXH7IzoTeRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dz+9xF737aJtyqGP1b0wxvz6YEXYta4LcLejQqLBWgs=;
 b=SA3vZkyX7iUu6b/lrIE7Wle6h0S3ZnQBmcrdWon8s3AfLn30jw+3Po2alzKyDs8h1P4gWDzwQ2kizU1Na5Mug4yCCeMpjmNwje5Bs0TsrVQA0yrz9/wNKzFKQDJsvMdegLjFBxJoz4c767EjbFNMBi2mO5+xkuCKbGHT5pQHosmMRaQzpboKHmGVBgz/FNNLKNpRQ5A/L5a1TE2DXFHp9/QLm4qBsbrinwHMvLmXhqrAaN8lU/vqlSEiq1BhkCJi83aF2Yuc90LOBhqq7Ecs9uTD6eAbf4/NfKSXLKNP2sUbSuQ4mQufiHfIR5y5yOZqHDDBS6aX53RqmUQoUGNrGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TYWPR01MB11831.jpnprd01.prod.outlook.com (2603:1096:400:3fa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 10:39:05 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::687d:4884:ec0b:8835%7]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 10:39:05 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: "Xiao Yang (Fujitsu)" <yangx.jy@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 1/6] cxl/monitor: Fix monitor not working
Thread-Topic: [ndctl PATCH 1/6] cxl/monitor: Fix monitor not working
Thread-Index: AQHZhaYdpG/dfpnqX0y9dCmHe4zVna9a70gAgAA4WwA=
Date: Mon, 15 May 2023 10:39:05 +0000
Message-ID: <fd591708-9e73-288a-addc-63e6a050b24f@fujitsu.com>
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-2-lizhijian@fujitsu.com>
 <c7927406-35e1-ab2f-a4f1-6d46309d06e8@fujitsu.com>
In-Reply-To: <c7927406-35e1-ab2f-a4f1-6d46309d06e8@fujitsu.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TYWPR01MB11831:EE_
x-ms-office365-filtering-correlation-id: c77e38df-b33c-4406-b09c-08db55309b36
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 eiXIYBNApfikjbpc6hTklMNim8xKb+eprVQqIFKSJOBzhwln+Z9lm/NkPzHiBnoUarKtGVbPPF7Ll5P1ZArQAmOi1JUmBWwzmfQKsRQRn5lqBUAwaOT41viPYupAXWT5Q9dTqHPoYHmsLQFjQQnQgI94LqvRNp7vSbrSiBOeX1Cii1ZN0g5TV+6pQfA7k29e/KIlniBlubLhcTPZon+nGAJNMaYDF1SrZQTQNqg/6bCFXZNLbBOCYqVKw37lP4URGfzgxd8F7ClcvmVreOn7L6Kbf13x/Aln2VOgN9m84cBu25CWSSf/X7fkguFkxWUJFWuZxq+HyoSdlwSd1uAK3YZZru5ekpYUZKg+N0hSiuwAlF5o1HK/gmz2rUFXxtoMoPV2M06Gy9giNpkPrBNtU+x4MQxt6rB+OcaAD1SzBkHFwcIzk+7MlKLrhnF3apx3Csya+yVV99BFBx1NDLZALDSgdFQKVSgTwGPjnfH+zmyTAGGDNXKi8Z2Jgj1buQ2k3W8+se2raGISbN0nphtci5n44DHLDNzfwgS5WGMBR29Gef2y+Tkclxt4OduvpdGMUc1ErylVHl+KP9tZhSysOFkSBKF9NpmjMv6mbfxCuB4ElRuYJUHgJiqk7rnidwhMfke7t6qKJ915KKQXkOIToMFb7+sIMqqSRjvvJFBS7LAtZqC8H6BvI4q3S8cVh8zp6ggwlUGujLDv4Py5gzBqvA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(1590799018)(451199021)(66556008)(110136005)(478600001)(64756008)(66446008)(66476007)(66946007)(76116006)(91956017)(71200400001)(316002)(6486002)(2906002)(8936002)(8676002)(41300700001)(5660300002)(4744005)(26005)(122000001)(82960400001)(31696002)(86362001)(85182001)(38070700005)(38100700002)(2616005)(83380400001)(53546011)(6512007)(186003)(6506007)(36756003)(31686004)(1580799015)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cC9ENE9tRHZocDVKaHg1L0kvM2lKaFV1ZUk5MWVLcmNueDY0WGN6MTZDczJI?=
 =?utf-8?B?MXlMbk1rUndZWkQwd2oyV2h4ejRXRVQra2wyQlpvclVYK0J6aTNrVnUyUjl6?=
 =?utf-8?B?czl2b3Z2S0g0Q3AyN3VlK1Z1QjY1dXc5cUZ4SUNtbFovdGJ4UzUzdkVZZmYz?=
 =?utf-8?B?NlR5MUVhSWlHK2F6cFN6anQ1dzhWcjNFbTRoamRGNktvd3pzdmdTM09mbSta?=
 =?utf-8?B?UUlyOTVrdHdLbEtDeFZvM2JBaUJqSkdEQnhaRUVUSGNtT0MycXdSbW1qYUVN?=
 =?utf-8?B?djhQc1lXTEtBbmZhV2x4QnNXN2dnVXhRSnlQTThBMHFJZ1VCY1FvWG5lSWVF?=
 =?utf-8?B?c0xOQUxIaTNGa2ErKzRhYVNYMkFwelUxQXRLUFpXQWd2dmdDYWphbkdCZnVT?=
 =?utf-8?B?QmtITUo4MnpNS0NZN1lWc2ZBaUR0VlhjMjJpRlJvRW5qUit5dEJWaUZ4SzF5?=
 =?utf-8?B?UnRZZXM0N2E3akVVTFhMOXlKeFFtUS9xaFVTL0d3bEFYaFc3cWNiWkhXbFE4?=
 =?utf-8?B?RGdYMDdibkZwOVpYaHIvdTdpWXVQekRpQjdnZU9DVktGVVdDbXFYeWJwRmhu?=
 =?utf-8?B?c1E1UFlpMTJEbklBcStxamRpdmdpOGc4WjNOY3M1R0JINytDL2xxbVpqUzFC?=
 =?utf-8?B?anV4MUk0clpLbE0xT1ZseHZJODB1Ym9xOVJ0TXpHUzdrR2wyR1cwL3hPQkZP?=
 =?utf-8?B?SkdQdHRpMEdHSkU1RkZHTFFrdWNqMk54dTg5aC9YcWZaRUlLNnd5c1l1NlBs?=
 =?utf-8?B?YVVPQW5YZW1jQktsZU5rYWthZHVmZkxkSzRSZTNsNDJBMUJpdy93V0xaK2pN?=
 =?utf-8?B?cVl4NTNGQUpRbi9PZDh6Y2Vvbk1NYTVwL3l1SHB1VkZUWm82WWltaEo3TXVW?=
 =?utf-8?B?cmpqMnFYK25nT2pGZHFQVkwwaXYybGsrVTF0S0dJODRYNGhDYlNTckVRdERs?=
 =?utf-8?B?VU9vYVYvRWVueGtDMTAxOStnU0VhTk41ZGxja2dnaDlYR2svRkNsNnN5TDJu?=
 =?utf-8?B?cUlDcEg3RzJBQ1I0d1Y1MGZ1eEVTSGREUURWRWFCNThaT242cE1sdlZGZTM2?=
 =?utf-8?B?YzI5VllVVExnVFdzQXV0QmhaamVMV2U2b3AyU1BPTmFTMnliOGZqYzNMMmNU?=
 =?utf-8?B?ZFF2cDl5VjllYzNlZmJoWU1WSkFNdm9pVmZZdDBVaHNaS1JrTlQ2bmRkRDFq?=
 =?utf-8?B?SlVaNDlTVE9ISzZYcDJLU2VTZ0FjNGEvNzJ0YWpwRk93VDYxYUZ6cDZCWkJU?=
 =?utf-8?B?dXhXY3pwNTlhald0YVdjMjVaSm04eEdxZGVTUGdxR3MwVkJDbUE5K1J0OGlK?=
 =?utf-8?B?RTNyZFZCd0FUc05JZXNpbVNzTE9JRlRhYUFNcmhjcktwdEh1Tlp4U05YVEVE?=
 =?utf-8?B?VjZHUFdjaXd2bkNTQTZYeEs2SHRvRGNGdk9tKzFOcHZoZjVsb3Zpa3ZKSk90?=
 =?utf-8?B?SHJDc1JHd3J6OEFFQ2hQVlpaK0lDVGYxY25zN3NkNUpHc1hvMmVsaWpzNUgx?=
 =?utf-8?B?V2FwVzNMY2ZSdEpnYUhsNFV6TXlwelQxeGVVcTJ2ZVViUE5TQWNLaFhwbXE0?=
 =?utf-8?B?d1FvTE92aEFKYWtiZGpUdElJRE9TZ2ZvNUhUT1NhcWZlN0Fzai83TmYzSUxz?=
 =?utf-8?B?ZjZ4UTJRWkJXTE90VDF3RWVHbko1NUNQb3JrdndLN3JhdW5mMks3Y3pmN3Vy?=
 =?utf-8?B?RHo5VWFqa1M4Z3BLeVlZd0dON1FlR1ZPQ0pLZi9WLzhxZGNJSFFFWVVsQzRG?=
 =?utf-8?B?Q3FPaEFHd0U2c2w4NWl3bnF1MWc1RVNwSVd5eHp2OUl5SDdWR0VPNmdYTDlE?=
 =?utf-8?B?K3Q1QlFHWkp2d0JiWVhXbEM1VjRYaFdWUmt0RXFtZnRGNG5TTWsyMjI5Rk85?=
 =?utf-8?B?THN4OFFtS1NXaUF4V3U5VXZtQ1k2K2tXYlhCMEswRnh6MlBrUmZ2SUFnQmFR?=
 =?utf-8?B?L0lEQklIOHBoeDBlT2lBVmhWSmNrNWJMOEZmVk91R2R2a1ZXWXZHbWFlRXc4?=
 =?utf-8?B?YWFNOXl2OXE5cDlvZXJLL0ljcUprSGJkbS9yakt3R1hqRERNa3Y4QVJvNWhC?=
 =?utf-8?B?ajhEZDNtQlVFUkt6N05HN2E5SWtxWmhIcHJxdE1BWTc4Vm95THNYTDlReGdS?=
 =?utf-8?B?Q2ptSWNsWlRmRCtjbTN1Z1dhQ21jcG8zRUtqUWdodjl4RVU1N1RFYi84K3lv?=
 =?utf-8?B?ZXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F89FB779EE938340878A186D79886219@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MtFar5fhXi3pt5BQVPaBjqXqvrAWAXraWSa2ICU6NLhHUAioO4E757cUFkyLEszn5y0W8utdeqrotiLaegYi//I8XczQ/TqmoyG+6X5KILCNc4W5kK88Pgdcs2s9IvTXNBmJ2LPtFMw5ZFn7diQkvGElrCAaq8QMILM6DvBbVPT/nMjbNAVxIjA6iQNuAnDKYpyMTwpiNxL+E2XWk4+wpPPW8Y4sKjiUaNDnCtt5FHbCqA3g7faV3c3EqTvZ9sBU1MtqICkAcnFs0u0sJtyiO9oJzz8dJn/SLKLKBaNrL7ZDS29qdQB3fLmSAG7R99YMd7nW3FEWYGhMeL8yMD7M9cBEyKEtke25SmyV6p0xE0teL59nT+gm/MoJn1mu/ZKsCPhdV/kQ2PhP+/fLavC5eIavkHHeR5rIJkRLpYHLPE4IkrQvkUoPdm7uzgl9J1MO1YWCVJCUxpVIHFeVrBIGmVALw5Sn/pVy3GA1zWVSxJtMgn6cLiW2vhg+i7Fsyxr6vixZwRrAAfWJqxsOE3ZCBu1vkKIvuezXFF51YbJQNUf/coNB6B7D2b8Rf07l+xWIJSDNECtJeUJORhmsnpXk8/hcREF6cQ3yAMP9GEJs1nCemvGZc1p9vcClohsL+rO7C5qcm1Ony4wTa/TQreGYwBqBDmt4XrtjkTExs/wXuSBr3bviPXQwAdetDH9Bnjsg1/so1samXjIU53YRRSpTr4DnXVmKkOOdJr3jxix6C79Gm8MSh+NgcNDnJtks+Ia6TExo60zrDEJa1P9wo6nDfA==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c77e38df-b33c-4406-b09c-08db55309b36
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 10:39:05.3603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sxqyj4TKYh/6i+PDw/WftHEHdIL+r41yhSfzamOILvJlM1CWPNi2nbatciEfDs/SbVT6yP19CSZ4bce/jLemMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB11831

DQoNCk9uIDE1LzA1LzIwMjMgMTU6MTcsIFlhbmcsIFhpYW8v5p2oIOaZkyB3cm90ZToNCj4gT24g
MjAyMy81LzEzIDIyOjIwLCBMaSBaaGlqaWFuIHdyb3RlOg0KPj4gSXQgbG9va3MgdGhhdCBzb21l
b25lIGZvcmdvdCB0byByZXdyaXRlIHRoaXMgcGFydCBhZnRlcg0KPj4gYmE1ODI1YjBiN2UwICgi
bmRjdGwvbW9uaXRvcjogbW92ZSBjb21tb24gbG9nZ2luZyBmdW5jdGlvbnMgdG8gdXRpbC9sb2cu
YyIpDQo+IEhpIHpoaWppYW4sDQo+IA0KPiBJdCdzIGZpbmUgdG8gdXBkYXRlIHRoaXMgcGFydC4N
Cj4gDQo+Pg0KPj4gICAgIyBidWlsZC9jeGwvY3hsIG1vbml0b3IgLWwgLi9tb25pdG9yLmxvZw0K
Pj4gU2VnbWVudGF0aW9uIGZhdWx0IChjb3JlIGR1bXBlZCkNCj4gSSBjYW5ub3QgcmVwcm9kdWNl
IHRoZSBpc3N1ZSBhbmQgY3VycmVudCBjb2RlIGxvb2tzIGdvb2QuDQo+IERpZCBJIG1pc3Mgc29t
ZXRoaW5nPw0KDQpNYXliZSB5b3VyIG1vbml0b3IgaGF2ZW4ndCByZWNlaXZlZCBhbnkgZXZlbnRz
LCBzbyBubyBtZXNzYWdlcyBhcmUgcmVhbGx5IGxvZ2dlZCB0byA8ZmlsZT4uDQoNCg0KDQo+IA0K
PiBCZXN0IFJlZ2FyZA0KPiBYaWFvIFlhbmcNCj4+DQo+PiBGaXhlczogMjk5ZjY5Zjk3NGE2ICgi
Y3hsL21vbml0b3I6IGFkZCBhIG5ldyBtb25pdG9yIGNvbW1hbmQgZm9yIENYTCB0cmFjZSBldmVu
dHMiKQ0KPj4gU2lnbmVkLW9mZi1ieTogTGkgWmhpamlhbjxsaXpoaWppYW5AZnVqaXRzdS5jb20+
