Received: from esa12.fujitsucc.c3s2.iphmx.com (esa12.fujitsucc.c3s2.iphmx.com [216.71.156.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1BB1FA8
	for <nvdimm@lists.linux.dev>; Thu, 23 Feb 2023 06:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1677133557; x=1708669557;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=04bWy8xH07PiYjanTCPm5KmlL9GIruu8ex+32uX0JxA=;
  b=t8f7IQbcFvPbd7puKH2GxXLdpIPi+XLOV+TWoQDro/XxQGzDh2qQoIMR
   FPw0ZRYjkK1QK3Hb7+1SaeeIeYfEqk7plkFE76mE53mbcyciyU8nxdTCJ
   WvO30J7KR5bLZgsRlEsYFGH0SZV/fLFjYfgAIDAscNwEXxHS+it8uVB9B
   ocKMga9RPxgSlY6pojgqvL8aBPpwPp3FmUI/k81qS/sl77xFszP3Fu0NZ
   DV/cULe/cxbF1/INBw7tWUp3zXbcDxXpPUxcjsUskKLTlWw9JJeO21N+f
   ZwmKkERnhJXnYZ3pZ1Jt6DpzWMjpJQmpfubeG7oMbyZnyDN0JXKheiobo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="77860480"
X-IronPort-AV: E=Sophos;i="5.97,320,1669042800"; 
   d="scan'208";a="77860480"
Received: from mail-os0jpn01lp2105.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.105])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 15:24:42 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvBEACAjansLQpip6o7zgyodUG7bCyYpPpXioS7XpJ/tEQKQPMp0m6/QQpfjkk0TT17M0qinXwsTqmIQh5ncdgqoZCEcbiWr25uK3taKrN9AXq63cXVN7LzdrlaRZt0PNCITNhbmatgooziuJJFBN/mTw9zNOQXxgKv/KpGNSVG710Em2bffR8OfnQTnujA9DNQzNUpp8mkp6mw5CiLPKikTCYEEnNpRgoly32TxqrnhJDsjp6z3EiA8NTTENtRhQ1boA+qwUaAWSd2OrMrGH3TBwKzNFxJPrrU3OGwN1SfbsIA1Ud3aRJyqjXnnXrK5JuvRDpbAttdkoqW0ao2UOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04bWy8xH07PiYjanTCPm5KmlL9GIruu8ex+32uX0JxA=;
 b=XDruD9sJteWYby5IhFMLpT2NgEf6PLz9+jAToRu/ZxsN8w3VeSn0oEajI+0+2FHSm8wCDOYQwYds+RlMu2PjmYrpYtLDYGUqx3TFKCkRuAC58/6OUrbtX0CuZ/BofazKuUl1M9kjiGw6NTsi79RQNGZFAlOLSJ+NispgBUhS8+aMZ39YHHSYaKzSBoyqKyrsR9f6BUV/mxzHq5VHsvBH+vR7kTL+TFxTGCzwlWrSw0eTf9wufeSst4Lf0IPorJSqukruqwgLtx12OLD5iKb5H43ArYDXpdA3RA+3Qv6i/0kJHAf8n6vDxsfXxQwHG6iZ2ni3tZD0682KLjxxQcGafw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 (2603:1096:604:1fb::14) by TY3PR01MB11475.jpnprd01.prod.outlook.com
 (2603:1096:400:40d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 06:24:38 +0000
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::2381:b0a1:7818:ce58]) by OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::2381:b0a1:7818:ce58%8]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 06:24:38 +0000
From: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
To: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>
CC: Baoquan He <bhe@redhat.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>,
	"dyoung@redhat.com" <dyoung@redhat.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>,
	"horms@verge.net.au" <horms@verge.net.au>, "k-hagio-ab@nec.com"
	<k-hagio-ab@nec.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>, "ruansy.fnst@fujitsu.com"
	<ruansy.fnst@fujitsu.com>
Subject: [RFC][nvdimm][crash] pmem memmap dump support
Thread-Topic: [RFC][nvdimm][crash] pmem memmap dump support
Thread-Index: AQHZR0+Bi1lA/ErA5EK0zxLjybbH0A==
Date: Thu, 23 Feb 2023 06:24:38 +0000
Message-ID: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB10390:EE_|TY3PR01MB11475:EE_
x-ms-office365-filtering-correlation-id: 73895ec0-38ed-4cec-7a09-08db1566a3c2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 wEi0vo+9/9eHHTrO999VVaBcLoTnVDWr5nsDkJiheZ78eQbK97Je6dbN0TW+XFzc07PjDYu4yhLxQFXURJGuytI69WVakPO5tL4FOah2chuiDOssRLK/vLaALlbQCy0aXhbUuOpa1JCMmBl79Emuhwkv+AY66mX91hmccMfVeyGcaz9GelEGcUVR2U7GDQB+4i71QBLbtnRqIgmaFy8oHVmsZUuN7srR6ruj9kFZmMiMbJoEbjxL2LovvDxy4H+yLwp52gqZ0V2nA+l15cHCFR8Cg/ZBjhecM3+5xJ/m0XjQ5llnQqlhMw/ZbxXZFqf8dGSNbg9f9TNqaogDdGXk1qiJwJD59O6BmKFouHuDUrOFRcGoI/MkUp4FCDklWpHe8wkU+mp01yrDW27SusYMuwcfGyjvo6DPxSEITbDHed180+1+T/uTwkHZgkuB/3RxI87Cnb3Ow+89XbVkOo0c9zedePR4jVFvpnRFNGDPnEH3zJVLR8TSnq24gfPB5QptQy05UBmL/HRhVHaAkcKGfZYGmKfRBuJhrF1XihSjZb15TBNhONj8X+lMEiSLLOhc9i/o/9F+wu+cGpj4Xb20or+EhHZdiS9aXUKSNktDlzOfMLuv07Jc77RnHnE+TXZGHSlgTsJqYvqZeW5JfuMLODrz4aDQC0yOqwdu0WtOJ9F0a1xRRcCEeJKpFiovZFYsvV+BfeOqXBECIDahwFGep45N8RlPw7+WwosWrWp91l6qXp/IRam0onc2UXGiAlT4RzeE9Hf9WGGokkNQa0zbx7lgQQVmfsRFZcQet1IO0bA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB10390.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(1590799015)(451199018)(478600001)(85182001)(71200400001)(54906003)(31696002)(82960400001)(38100700002)(122000001)(86362001)(2906002)(38070700005)(110136005)(316002)(41300700001)(7416002)(83380400001)(5660300002)(66556008)(8936002)(76116006)(8676002)(66476007)(66446008)(4326008)(64756008)(66946007)(91956017)(6486002)(26005)(966005)(66899018)(186003)(31686004)(6506007)(6512007)(107886003)(2616005)(36756003)(1580799012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SFJYS0VVQXczV0RsWW9FSDh3azVjbklvRlMzQWFXcnloSi9zYmZlc2Y2bTh0?=
 =?utf-8?B?ZUQyenZYYTF3aWRwaC9TNWEzYU05QVVMU3JVaU4zSTR4Rk5PZjF1YnhKSmVB?=
 =?utf-8?B?Ym5Fa0lWM3VLeUNaSzZBaVc1RCtML2oyVHRjUzFodEgrOHRFV3lxN0ZGWWpT?=
 =?utf-8?B?cU43TjFqVllMUlEydXVmME1ITzJEMnFuV2FrY0NYQkpJa1hjRy8zK3VBSjFN?=
 =?utf-8?B?NlhIcGp3cGJGalBZQlZrTjgrWFBZNGhBa05xcGx0K3g1KzlYaVpoaTRQSmV1?=
 =?utf-8?B?dUxTalg5TWNpZDBrT3RPWUlENjVkKzN5eFYvMVVoTVhhdFdaWWFPR1pYbEdU?=
 =?utf-8?B?NFE0bGV2N1A1eXVOdzZlVUwvaUdQU05jN3VtRHhMWUVZNzI1YVJreldodHJQ?=
 =?utf-8?B?YkJFV0p2R0tHSWYvM21DNU15WlV1RFo1KzgwMEJWRDN2QVI1b0R4WXFiQmdN?=
 =?utf-8?B?a25NQXJtelRwa3Q3OG90Mnc3bzAxSmtaQUU5QXNBUE5qa3NHRUJnekJ5UUht?=
 =?utf-8?B?bVFUR1hwNmtkMmsxZ29leGoyNzNSYXJuL3hZbzVuNjZzRTdVM1plWXBvL1Fp?=
 =?utf-8?B?ZWw2TUdDVzJvWU1iWVVZSlFJK0hxK0dEeERiSVN5ZnFEYy9xVkVMMzZKRGJI?=
 =?utf-8?B?MnM2VWJQZFA3S1ZRcUdRSE9qRityTGlGK1BHWlg1bk9qMjI3YTBJaTd5NlJN?=
 =?utf-8?B?RjFKRDZQelFOcTBKcHBucGU3d1R2OHdQNk5kMDUwZ1RKWkFpZnl4YktmNWdT?=
 =?utf-8?B?NXNKbzVjV2tneExHbnpzZkI1dlVhRklWWUpkNlhDaE04Q2M1T3FSanF2Tkdq?=
 =?utf-8?B?dnh5RmZkS2kzc0F5bi9yaEZLMitzVEpMOW1Id1ViL3NWZWtkNHRBc284YXll?=
 =?utf-8?B?QUZLOHJHSDRwYkJXclB4WlN2K2JETStEbmhnMDIxTlQxbWdJZGZFeUc2WENN?=
 =?utf-8?B?akZObnZDSll1Zmx5M3V3MHprYTVLaWU2cFh4Q2VEV3BJdmxqaFFqZGkweisy?=
 =?utf-8?B?YWxqVjRlUTIyZU9UOHo5V3dPeDJMaUFKNmJyL0M3dHJLMVAxU2Z5ODVjSncr?=
 =?utf-8?B?YWllYkxkRVlmQ1ltMTFaRXJybGRkTEZIWncwWVoyazRvTTNXWG5jUmVqWE5J?=
 =?utf-8?B?Q0RwcDhYcXhydGE2SENmbUVYZzdWQmNQV2dFVHFGZ3A1QXFDNXhUVmJaazF0?=
 =?utf-8?B?VlV4dGJtYnRLdVdZdE9mRkRTQ1EzOHNhNWhJaURaMXZDTzRmSkdEVEQza3JZ?=
 =?utf-8?B?NWJhbVQvZXJCMlA4M2RKZEY5NFJoVTRGRFEvc1ZIeVp3dVJrK1VudmNPQUVn?=
 =?utf-8?B?UUlBdVlFWFROT25YazBhUjFHR0hZRzk1L2ZZMmtFTjg4dWZPeVNGYmkyUUFZ?=
 =?utf-8?B?cXFOZ3dzd3hOaE11R3poOUhacUYyM0JnSHJCZXFTNEo4MmVYbTl5OGtsTnhC?=
 =?utf-8?B?OXpQQVlCQmxkY3VpSW1kRytVZkpiSlIrNGxpdkdYeEo5dG9XN0ZHdG5VM1N2?=
 =?utf-8?B?dkpIZTZqS1M5TzRaOXpFYVlTa0duRU5KU01nMHZWS2VQT3VYQUJzbzVLWERO?=
 =?utf-8?B?QjltQSs2NHk5aDRWODFrRFMxMGdId1V5L294WGtKeHIyV1hRaGtLdEJRUlJx?=
 =?utf-8?B?UTFYd1ZaQlB6SW9MUmlOZEVTbUNPY3FXVHVEN3BSZmNiVThaTEhmM3A2U25y?=
 =?utf-8?B?cHI4UTBVTnE2SXJpRSthdnVJRW1qWTE4eGZEell4VGFBVGJCUDNLNkg5Yktl?=
 =?utf-8?B?QU9lcGgwcmJPY1VIMm5nTjIvVWI5SlcyTVVYWHVBamlWcU4yK2d6WDUyemNR?=
 =?utf-8?B?M09mbHdrL3BkeHVwWFB3VFNBK3VKT3BRa1B2d2RXMUlEMTNjbWs3TW94RmFV?=
 =?utf-8?B?SkNwYnNGVEYweFBXZ3hTekxFcUxadVQ4Sjl1MU9ZajdLOXBvQWx3R2VJVnFu?=
 =?utf-8?B?MFpvYUVpa1g1VUNrZHhGZkE1ODk1Sm55ZVdQSWljZnR6N3krczN2Q1Ewazdq?=
 =?utf-8?B?b2F0aDU2MkR5ekl2dlZSOU1UeStpNnNtWWNXendSOUhjYjB2NmRkSGlKeG8r?=
 =?utf-8?B?bll2QjJZVm4xRWh2OFhOajZBTVlDSWdPMTlwckIrUSsraTAxcTRLanZoNldD?=
 =?utf-8?B?cFh1WUNWVVg3UHVqVzcxalFiQ2NuQ2YwejNrcThZQkFEQ2x2M1dGaEhrZDVD?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08D8DFDF3F5C9F469E1B5ADEB8FACA5F@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	=?utf-8?B?Z0ErSVZyMDZDY3UzZkZZdDJVWG04RHQ0VnZQak5yRTQramRpdkVOTlRXdEFa?=
 =?utf-8?B?V21SZituQUJhb2UwZjFlRDEycHdWSE1iWUhQdTNqQnIrc0FMZVlhT2wxeDZr?=
 =?utf-8?B?MmJ2K2o1SGdiTEcvTmxoYmU3UFFXYVc2QWJuNFpGN1A4cUgvZDZrVEs5N2tz?=
 =?utf-8?B?bzVtYzdrOHhRRGw0L1RVbDNVeVlSV0dKb1cwLzFieDZDUlNzVWY1UXc3Uldp?=
 =?utf-8?B?YzhCYWJXakZ0UTlzRit4RHpnNjFUaXl1VHFua28weTBCbnJvMkJFeFpWdk53?=
 =?utf-8?B?ZFM4V1JNcjcvVndBcVNRV1VvdytHWHRVSmVpaFJoTVlpTUZoSm15SHpUbVZ1?=
 =?utf-8?B?elBqcXU2ZytuL3gzVHZPM2UrbDVGNTRWanlsb0d2cm9INERxdVpBTmNBUGUw?=
 =?utf-8?B?WmtaUFp5L1gzTGFkSURqVndlbDZQcHBXSG0vVXRuODNmUXJkbDNYQnQxZDlP?=
 =?utf-8?B?dklkK1VBRTFhWTYrWkNjREhOUCtvd3hPV2hyaURQbEtoZElHRnJSNGM3emEz?=
 =?utf-8?B?Y0xySFpIT2c4eUpnQnlMRWo2YXJiYXRxdGR0SERYVHNVSHZ5NUhQdkFjMnY1?=
 =?utf-8?B?c1dLU3NkbXpKUmRIUGxwWE9BRmRvRGJQSm1qZ0oydXNHdUxsSWJMaitFTHpD?=
 =?utf-8?B?SXpuTEU2RVQwWTdtbDlQZ21BZWNGektpMDczbEVQeXFBUmlZMUpBMHdMZ2Vv?=
 =?utf-8?B?bEl6Ym8vd1hqMHk0MURZeXlKb3p2ZGpSUllmMmZXL3dhOC9XWm5NVDEyUW8w?=
 =?utf-8?B?RGlvVFlwejFaSjBpRWpkdklGVjhPVmxYamF2NDJicHloR1ZZRmhiOVRBOHBE?=
 =?utf-8?B?ZmcvSTMvWVlCWXZBSW1SeU1sZ2dqZTNkOG1hNW40OUl2ZXlucGpDSC9lYkhw?=
 =?utf-8?B?Z3AwamlGWDhwemwvaVVWZTFFciszeXhETU5TL0RkUkFMYkJMUWlxaDE3MXRk?=
 =?utf-8?B?cU1aYkFhNG1jNEVzRXNCaEdibXIxYlNEeGNYZ1ZndkZiOHpEa2IydEpkZWlQ?=
 =?utf-8?B?bTBuMzF0RUdFNFdORjBwUEhObmpnbThnVHlPQ2tMRFV5Z0kxTEg5Y0w3WmJa?=
 =?utf-8?B?Tm5VWEJWaWE3Rnd4L2QwZjFiU25pYmtNaS9BSkswcVlNQ04yV3loMG9lZE82?=
 =?utf-8?B?dXdmTTRLWU9iOTFUVmJnVFJMV1FQSlUrbGxnTmJ2UGR0YzY5MldoQzBTU3VH?=
 =?utf-8?B?NVBsWHZtOWVDSjU3eVlpUmd0QWpjUDdKYlQ5dDhkeURibW8zZHl2aU9lNkVK?=
 =?utf-8?B?bHpZUnFFRmFLR05UNnpPM1NGcFgvakZ0UWFZUGRlZ2o1Qk9mRkl5L0R4aFRZ?=
 =?utf-8?B?N1VFbFpoOXZtQXRTZ1Q0Rk82MVppU2RTbGZ0dHVxKzMwUU9PUWdpS2xBaFpt?=
 =?utf-8?B?eDJWR29BT0lUbHc9PQ==?=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB10390.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73895ec0-38ed-4cec-7a09-08db1566a3c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 06:24:38.1024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x9r7bUu2v1qHXOOmetq5/LG8d2UR3afR8ctIlvShdeplouSxxoaVshAAq8j5ox+EKSmg0SayLW/fTR0HFoAhYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB11475

SGVsbG8gZm9sa3MsDQoNClRoaXMgbWFpbCByYWlzZXMgYSBwbWVtIG1lbW1hcCBkdW1wIHJlcXVp
cmVtZW50IGFuZCBwb3NzaWJsZSBzb2x1dGlvbnMsIGJ1dCB0aGV5IGFyZSBhbGwgc3RpbGwgcHJl
bWF0dXJlLg0KSSByZWFsbHkgaG9wZSB5b3UgY2FuIHByb3ZpZGUgc29tZSBmZWVkYmFjay4NCg0K
cG1lbSBtZW1tYXAgY2FuIGFsc28gYmUgY2FsbGVkIHBtZW0gbWV0YWRhdGEgaGVyZS4NCg0KIyMj
IEJhY2tncm91bmQgYW5kIG1vdGl2YXRlIG92ZXJ2aWV3ICMjIw0KLS0tDQpDcmFzaCBkdW1wIGlz
IGFuIGltcG9ydGFudCBmZWF0dXJlIGZvciB0cm91YmxlIHNob290aW5nIG9mIGtlcm5lbC4gSXQg
aXMgdGhlIGZpbmFsIHdheSB0byBjaGFzZSB3aGF0DQpoYXBwZW5lZCBhdCB0aGUga2VybmVsIHBh
bmljLCBzbG93ZG93biwgYW5kIHNvIG9uLiBJdCBpcyB0aGUgbW9zdCBpbXBvcnRhbnQgdG9vbCBm
b3IgY3VzdG9tZXIgc3VwcG9ydC4NCkhvd2V2ZXIsIGEgcGFydCBvZiBkYXRhIG9uIHBtZW0gaXMg
bm90IGluY2x1ZGVkIGluIGNyYXNoIGR1bXAsIGl0IG1heSBjYXVzZSBkaWZmaWN1bHR5IHRvIGFu
YWx5emUNCnRyb3VibGUgYXJvdW5kIHBtZW0gKGVzcGVjaWFsbHkgRmlsZXN5c3RlbS1EQVgpLg0K
DQoNCkEgcG1lbSBuYW1lc3BhY2UgaW4gImZzZGF4IiBvciAiZGV2ZGF4IiBtb2RlIHJlcXVpcmVz
IGFsbG9jYXRpb24gb2YgcGVyLXBhZ2UgbWV0YWRhdGFbMV0uIFRoZSBhbGxvY2F0aW9uDQpjYW4g
YmUgZHJhd24gZnJvbSBlaXRoZXIgbWVtKHN5c3RlbSBtZW1vcnkpIG9yIGRldihwbWVtIGRldmlj
ZSksIHNlZSBgbmRjdGwgaGVscCBjcmVhdGUtbmFtZXNwYWNlYCBmb3INCm1vcmUgZGV0YWlscy4g
SW4gZnNkYXgsIHN0cnVjdCBwYWdlIGFycmF5IGJlY29tZXMgdmVyeSBpbXBvcnRhbnQsIGl0IGlz
IG9uZSBvZiB0aGUga2V5IGRhdGEgdG8gZmluZA0Kc3RhdHVzIG9mIHJldmVyc2UgbWFwLg0KDQpT
bywgd2hlbiBtZXRhZGF0YSB3YXMgc3RvcmVkIGluIHBtZW0sIGV2ZW4gcG1lbSdzIHBlci1wYWdl
IG1ldGFkYXRhIHdpbGwgbm90IGJlIGR1bXBlZC4gVGhhdCBtZWFucw0KdHJvdWJsZXNob290ZXJz
IGFyZSB1bmFibGUgdG8gY2hlY2sgbW9yZSBkZXRhaWxzIGFib3V0IHBtZW0gZnJvbSB0aGUgZHVt
cGZpbGUuDQoNCiMjIyBNYWtlIHBtZW0gbWVtbWFwIGR1bXAgc3VwcG9ydCAjIyMNCi0tLQ0KT3Vy
IGdvYWwgaXMgdGhhdCB3aGV0aGVyIG1ldGFkYXRhIGlzIHN0b3JlZCBvbiBtZW0gb3IgcG1lbSwg
aXRzIG1ldGFkYXRhIGNhbiBiZSBkdW1wZWQgYW5kIHRoZW4gdGhlDQpjcmFzaC11dGlsaXRpZXMg
Y2FuIHJlYWQgbW9yZSBkZXRhaWxzIGFib3V0IHRoZSBwbWVtLiBPZiBjb3Vyc2UsIHRoaXMgZmVh
dHVyZSBjYW4gYmUgZW5hYmxlZC9kaXNhYmxlZC4NCg0KRmlyc3QsIGJhc2VkIG9uIG91ciBwcmV2
aW91cyBpbnZlc3RpZ2F0aW9uLCBhY2NvcmRpbmcgdG8gdGhlIGxvY2F0aW9uIG9mIG1ldGFkYXRh
IGFuZCB0aGUgc2NvcGUgb2YNCmR1bXAsIHdlIGNhbiBkaXZpZGUgaXQgaW50byB0aGUgZm9sbG93
aW5nIGZvdXIgY2FzZXM6IEEsIEIsIEMsIEQuDQpJdCBzaG91bGQgYmUgbm90ZWQgdGhhdCBhbHRo
b3VnaCB3ZSBtZW50aW9uZWQgY2FzZSBBJkIgYmVsb3csIHdlIGRvIG5vdCB3YW50IHRoZXNlIHR3
byBjYXNlcyB0byBiZQ0KcGFydCBvZiB0aGlzIGZlYXR1cmUsIGJlY2F1c2UgZHVtcGluZyB0aGUg
ZW50aXJlIHBtZW0gd2lsbCBjb25zdW1lIGEgbG90IG9mIHNwYWNlLCBhbmQgbW9yZSBpbXBvcnRh
bnRseSwNCml0IG1heSBjb250YWluIHVzZXIgc2Vuc2l0aXZlIGRhdGEuDQoNCistLS0tLS0tLS0t
LS0tKy0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tKw0KfFwrLS0tLS0tLS0rXCAgICAgbWV0YWRhdGEg
bG9jYXRpb24gICB8DQp8ICAgICAgICAgICAgKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsNCnwg
ZHVtcCBzY29wZSAgfCAgbWVtICAgICB8ICAgUE1FTSAgICAgfA0KKy0tLS0tLS0tLS0tLS0rLS0t
LS0tLS0tLSstLS0tLS0tLS0tLS0rDQp8IGVudGlyZSBwbWVtIHwgICAgIEEgICAgfCAgICAgQiAg
ICAgIHwNCistLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tKw0KfCBtZXRhZGF0
YSAgICB8ICAgICBDICAgIHwgICAgIEQgICAgICB8DQorLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0t
Ky0tLS0tLS0tLS0tLSsNCg0KQ2FzZSBBJkI6IHVuc3VwcG9ydGVkDQotIE9ubHkgdGhlIHJlZ2lv
bnMgbGlzdGVkIGluIFBUX0xPQUQgaW4gdm1jb3JlIGFyZSBkdW1wYWJsZS4gVGhpcyBjYW4gYmUg
cmVzb2x2ZWQgYnkgYWRkaW5nIHRoZSBwbWVtDQpyZWdpb24gaW50byB2bWNvcmUncyBQVF9MT0FE
cyBpbiBrZXhlYy10b29scy4NCi0gRm9yIG1ha2VkdW1wZmlsZSB3aGljaCB3aWxsIGFzc3VtZSB0
aGF0IGFsbCBwYWdlIG9iamVjdHMgb2YgdGhlIGVudGlyZSByZWdpb24gZGVzY3JpYmVkIGluIFBU
X0xPQURzDQphcmUgcmVhZGFibGUsIGFuZCB0aGVuIHNraXBzL2V4Y2x1ZGVzIHRoZSBzcGVjaWZp
YyBwYWdlIGFjY29yZGluZyB0byBpdHMgYXR0cmlidXRlcy4gQnV0IGluIHRoZSBjYXNlDQpvZiBw
bWVtLCAxc3Qga2VybmVsIG9ubHkgYWxsb2NhdGVzIHBhZ2Ugb2JqZWN0cyBmb3IgdGhlIG5hbWVz
cGFjZXMgb2YgcG1lbSwgc28gbWFrZWR1bXBmaWxlIHdpbGwgdGhyb3cNCmVycm9yc1syXSB3aGVu
IHNwZWNpZmljIC1kIG9wdGlvbnMgYXJlIHNwZWNpZmllZC4NCkFjY29yZGluZ2x5LCB3ZSBzaG91
bGQgbWFrZSBtYWtlZHVtcGZpbGUgdG8gaWdub3JlIHRoZXNlIGVycm9ycyBpZiBpdCdzIHBtZW0g
cmVnaW9uLg0KDQpCZWNhdXNlIHRoZXNlIGFib3ZlIGNhc2VzIGFyZSBub3QgaW4gb3VyIGdvYWws
IHdlIG11c3QgY29uc2lkZXIgaG93IHRvIHByZXZlbnQgdGhlIGRhdGEgcGFydCBvZiBwbWVtDQpm
cm9tIHJlYWRpbmcgYnkgdGhlIGR1bXAgYXBwbGljYXRpb24obWFrZWR1bXBmaWxlKS4NCg0KQ2Fz
ZSBDOiBuYXRpdmUgc3VwcG9ydGVkDQptZXRhZGF0YSBpcyBzdG9yZWQgaW4gbWVtLCBhbmQgdGhl
IGVudGlyZSBtZW0vcmFtIGlzIGR1bXBhYmxlLg0KDQpDYXNlIEQ6IHVuc3VwcG9ydGVkICYmIG5l
ZWQgeW91ciBpbnB1dA0KVG8gc3VwcG9ydCB0aGlzIHNpdHVhdGlvbiwgdGhlIG1ha2VkdW1wZmls
ZSBuZWVkcyB0byBrbm93IHRoZSBsb2NhdGlvbiBvZiBtZXRhZGF0YSBmb3IgZWFjaCBwbWVtDQpu
YW1lc3BhY2UgYW5kIHRoZSBhZGRyZXNzIGFuZCBzaXplIG9mIG1ldGFkYXRhIGluIHRoZSBwbWVt
IFtzdGFydCwgZW5kKQ0KDQpXZSBoYXZlIHRob3VnaHQgb2YgYSBmZXcgcG9zc2libGUgb3B0aW9u
czoNCg0KMSkgSW4gdGhlIDJuZCBrZXJuZWwsIHdpdGggdGhlIGhlbHAgb2YgdGhlIGluZm9ybWF0
aW9uIGZyb20gL3N5cy9idXMvbmQvZGV2aWNlcy97bmFtZXNwYWNlWC5ZLCBkYXhYLlksIHBmblgu
WX0NCmV4cG9ydGVkIGJ5IHBtZW0gZHJpdmVycywgbWFrZWR1bXBmaWxlIGlzIGFibGUgdG8gY2Fs
Y3VsYXRlIHRoZSBhZGRyZXNzIGFuZCBzaXplIG9mIG1ldGFkYXRhDQoyKSBJbiB0aGUgMXN0IGtl
cm5lbCwgYWRkIGEgbmV3IHN5bWJvbCB0byB0aGUgdm1jb3JlLiBUaGUgc3ltYm9sIGlzIGFzc29j
aWF0ZWQgd2l0aCB0aGUgbGF5b3V0IG9mDQplYWNoIG5hbWVzcGFjZS4gVGhlIG1ha2VkdW1wZmls
ZSByZWFkcyB0aGUgc3ltYm9sIGFuZCBmaWd1cmVzIG91dCB0aGUgYWRkcmVzcyBhbmQgc2l6ZSBv
ZiB0aGUgbWV0YWRhdGEuDQozKSBvdGhlcnMgPw0KDQpCdXQgdGhlbiB3ZSBmb3VuZCB0aGF0IHdl
IGhhdmUgYWx3YXlzIGlnbm9yZWQgYSB1c2VyIGNhc2UsIHRoYXQgaXMsIHRoZSB1c2VyIGNvdWxk
IHNhdmUgdGhlIGR1bXBmaWxlDQp0byB0aGUgcG1lbS4gTmVpdGhlciBvZiB0aGVzZSB0d28gb3B0
aW9ucyBjYW4gc29sdmUgdGhpcyBwcm9ibGVtLCBiZWNhdXNlIHRoZSBwbWVtIGRyaXZlcnMgd2ls
bA0KcmUtaW5pdGlhbGl6ZSB0aGUgbWV0YWRhdGEgZHVyaW5nIHRoZSBwbWVtIGRyaXZlcnMgbG9h
ZGluZyBwcm9jZXNzLCB3aGljaCBsZWFkcyB0byB0aGUgbWV0YWRhdGENCndlIGR1bXBlZCBpcyBp
bmNvbnNpc3RlbnQgd2l0aCB0aGUgbWV0YWRhdGEgYXQgdGhlIG1vbWVudCBvZiB0aGUgY3Jhc2gg
aGFwcGVuaW5nLg0KU2ltcGx5LCBjYW4gd2UganVzdCBkaXNhYmxlIHRoZSBwbWVtIGRpcmVjdGx5
IGluIDJuZCBrZXJuZWwgc28gdGhhdCBwcmV2aW91cyBtZXRhZGF0YSB3aWxsIG5vdCBiZQ0KZGVz
dHJveWVkPyBCdXQgdGhpcyBvcGVyYXRpb24gd2lsbCBicmluZyB1cyBpbmNvbnZlbmllbmNlIHRo
YXQgMm5kIGtlcm5lbCBkb2VzbuKAmXQgYWxsb3cgdXNlciBzdG9yaW5nDQpkdW1wZmlsZSBvbiB0
aGUgZmlsZXN5c3RlbS9wYXJ0aXRpb24gYmFzZWQgb24gcG1lbS4NCg0KU28gaGVyZSBJIGhvcGUg
eW91IGNhbiBwcm92aWRlIHNvbWUgaWRlYXMgYWJvdXQgdGhpcyBmZWF0dXJlL3JlcXVpcmVtZW50
IGFuZCBvbiB0aGUgcG9zc2libGUgc29sdXRpb24NCmZvciB0aGUgY2FzZXMgQSZCJkQgbWVudGlv
bmVkIGFib3ZlLCBpdCB3b3VsZCBiZSBncmVhdGx5IGFwcHJlY2lhdGVkLg0KDQpJZiBJ4oCZbSBt
aXNzaW5nIHNvbWV0aGluZywgZmVlbCBmcmVlIHRvIGxldCBtZSBrbm93LiBBbnkgZmVlZGJhY2sg
JiBjb21tZW50IGFyZSB2ZXJ5IHdlbGNvbWUuDQoNCg0KWzFdIFBtZW0gcmVnaW9uIGxheW91dDoN
CiAgIF48LS1uYW1lc3BhY2UwLjAtLS0tPl48LS1uYW1lc3BhY2UwLjEtLS0tLS0+Xg0KICAgfCAg
ICAgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICAgICAgICB8DQogICArLS0rbS0tLS0t
LS0tLS0tLS0tLS0rLS0rbS0tLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLS0tLS0r
LSthDQogICB8Kyt8ZSAgICAgICAgICAgICAgICB8Kyt8ZSAgICAgICAgICAgICAgICAgIHwgICAg
ICAgICAgICAgICAgICAgICB8K3xsDQogICB8Kyt8dCAgICAgICAgICAgICAgICB8Kyt8dCAgICAg
ICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgICAgICB8K3xpDQogICB8Kyt8YSAgICAgICAg
ICAgICAgICB8Kyt8YSAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgICAgICB8K3xn
DQogICB8Kyt8ZCAgbmFtZXNwYWNlMC4wICB8Kyt8ZCAgbmFtZXNwYWNlMC4xICAgIHwgICAgIHVu
LWFsbG9jYXRlZCAgICB8K3xuDQogICB8Kyt8YSAgICBmc2RheCAgICAgICB8Kyt8YSAgICAgZGV2
ZGF4ICAgICAgIHwgICAgICAgICAgICAgICAgICAgICB8K3xtDQogICB8Kyt8dCAgICAgICAgICAg
ICAgICB8Kyt8dCAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgICAgICB8K3xlDQog
ICArLS0rYS0tLS0tLS0tLS0tLS0tLS0rLS0rYS0tLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0t
LS0tLS0tLS0tLS0rLStuDQogICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHx0DQogICB2PC0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tcG1lbSByZWdpb24tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tPnYNCg0KWzJd
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tLzcwRjk3MUNGLTFBOTYtNEQ4Ny1CNzBD
LUI5NzFDMkExNzQ3Q0Byb2MuY3MudW1hc3MuZWR1L1QvDQoNCg0KVGhhbmtzDQpaaGlqaWFu
