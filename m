Received: from esa22.fujitsucc.c3s2.iphmx.com (esa22.fujitsucc.c3s2.iphmx.com [68.232.150.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D3680C
	for <nvdimm@lists.linux.dev>; Mon, 10 Jul 2023 12:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1688993711; x=1720529711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7l3/R/AxvqnF02hRI7CHNWwT+09dzAz/uxHwAJ+G6IA=;
  b=IedYH3OnyHTJ0wlG87VofpZABPB0u5vzp8umdWM8LIOhKx3kyAI1iq+E
   t8I4GnFf+ZZLcf9hVIqwJT4Ni2UX95C21XPUxDomsakwZpjdxYb7IWC/f
   fd2WcQ3upqW4ljdV3yCBEavp8T21Jgek67VpWwODt6u8ktiSzb/+K4UNC
   iZ+gfDl6EKJRPauTZoktUxiyUIebLsMWcMUuKm2AyXUMHVJ0SkhUJV6WB
   TmC14KFXVASt6Lv4gJ0HGuYPrDS2pcymHPh76HUxt+nI0s6Fa1RBvmj+0
   KSPr08E9zYd1wVgJnBX/XKUqi/NmBrbzII0M3veHaz2r5Jf4Ddg/7pJYN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="97555116"
X-IronPort-AV: E=Sophos;i="6.01,194,1684767600"; 
   d="scan'208";a="97555116"
Received: from mail-os0jpn01lp2110.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.110])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 21:53:57 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYe0T11yANrh3K1vrwBZxFn6w4Bj7FBq9czuq5MxJTM9OhVlVVemM+FZKF4QmgjBtRUtnfCTYFPGTGw9guJB4dGY1Pc3RAvcGPpbgSBCij6Rsh3kBs/ZG/vVTq5vlgNTNJwCRDrvCdyDoSpmTGg3eysP91I0ebNl7jU3Sk84CwrRev/sa1cpR0M3Nj/uv6s+VP8M+H+jspldtpcmSf/U8ahkOTLIfaOUaJnCflEDc2kKEtYbbIeZZTKrmrN/nTdUIjeN5hMwztZZMIEIh6eZ5wgNeEHz/Ir/tIoLKgPbHxMJBx7uqSog3aa5TB/0TLYXgM7qb720Dh+0mPlwc9vX0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7l3/R/AxvqnF02hRI7CHNWwT+09dzAz/uxHwAJ+G6IA=;
 b=NcXDe7NjMltVHev2iVIzYdLgojje30BBQqpNNl9LipD00a6JSV2rtTwHLs4GUTloRoOgkiFBAoyPqCPL6Jx+iGXYnZm+l3bhaEkkKudP5ogGzxXE6K+xU7l8fhfraoWSJLVa0B93UoNORuk4KrRBvpMyQUX8FtRllmMX5LGL2rKjtrn2gCKoPFBgyrxbrPGVtf08KrXVS+uAvBQpp9p0RhE7wsX6wvdPrbZcVJimSi0hNCQkqqvUqLPiGXDACsLA9XbHwRc+7SZNAkQoewPx11P/3RruDh+pTvIZ9Vaqq/S54U8+6e/+e3w75NmlB3krq2FG2ydbA61Uc6SmzpYZag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TYCPR01MB10007.jpnprd01.prod.outlook.com (2603:1096:400:1eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Mon, 10 Jul
 2023 12:53:54 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::6d6e:460b:60f2:8d91]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::6d6e:460b:60f2:8d91%7]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 12:53:53 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Schofield, Alison" <alison.schofield@intel.com>
Subject: Re: [ndctl PATCH v3 3/6] cxl/monitor: use strcmp to compare the
 reserved word
Thread-Topic: [ndctl PATCH v3 3/6] cxl/monitor: use strcmp to compare the
 reserved word
Thread-Index: AQHZk2ZfZ5KZ3UvaakyWJD+jik70oa+r4WKAgAdS+QA=
Date: Mon, 10 Jul 2023 12:53:53 +0000
Message-ID: <03e93966-cb4e-060c-efab-ddb2eaf8d876@fujitsu.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
 <20230531021936.7366-4-lizhijian@fujitsu.com>
 <d0378a7f915b2f9ef793214a366b5466c68d3204.camel@intel.com>
In-Reply-To: <d0378a7f915b2f9ef793214a366b5466c68d3204.camel@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TYCPR01MB10007:EE_
x-ms-office365-filtering-correlation-id: a3b94555-8dd7-4b2b-b78a-08db8144b75f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ZcfKCRM/ogYMH59enWogoPIobyky9epjxTZnt8wkG8lNxhl4yx5WTbBTPjwd5r05eguVAc6ON3NcpU+P+Yw8JLWHcYc0gffvTcd6Y4dusP8wik+D99Wifeu7SQJTK20SKQS5nlLYFR5VgvMPTnKuShMKmvs5w4ULzO2oBz0t7aStNFvAM02+uIef+4Db6gr2YjuJIWCNxYqi04u9uAQtmjE3l+xqvm6qbiD86L9/ItxQhr2ZuZbNnIhqSFN0mLpnsjhyAVzneo93z8Daz6h/7qJdLfnLMwlmEMBVFIqM9Nf2muBjh95FOcJw7DZrxlWGS7vHI+PYXEZQIRUP25HpV9bROznjszl+TnoXbL3NXbUwyPxggmgMbbEOqAAd/IQmC5g9V+XAj3lJB4aaIMUqrUgQKm5iLC+fZsh/NOfB+3QRZZ7FjWrkMidJ5cg0I9ZK5rwgeV6vpPrYZ4O+Kg65mXakBbmk22jQATKrc5wPgKsOd9xwRt8ZqgyXfJLVfbVzJEInYO/Yg6+ySymY9P7qZ41/FpfXOGdPb3MmhScJ8njCi12MIjjkuCkjuqWWiutCwyUIwnidCrfQtYUJeHsQe1xPTLORvs0nhp8EsqUyLHGP1rG8hMJGqJ9/4onaEyzV0FzbJ33E92R2js6d/I2QsuMudGEdeXIhQ+YrOnXzL7m1vGgi+9oHXsWkWF9Zlbor64+wsaRpH2Vs5DTfZSsqAd+KRotjX2MGek9WdJec2wQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(1590799018)(451199021)(6512007)(82960400001)(38100700002)(122000001)(26005)(6506007)(83380400001)(186003)(2616005)(2906002)(5660300002)(8676002)(8936002)(85182001)(36756003)(71200400001)(6486002)(478600001)(38070700005)(4326008)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(41300700001)(316002)(54906003)(110136005)(31696002)(91956017)(86362001)(31686004)(1580799015)(40753002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MC9xMExNU0EzVkw2aEZqZU5BNGl5SkRNcU5TTERIdFlRZWFuVEhMd1prSnFr?=
 =?utf-8?B?S2swNitRWUNCeWJXSHNzMklLbTBKQ1J2KzN2QVJkUkpTZUZNWUxFUFEvQmhJ?=
 =?utf-8?B?M3l2NWdiR0pFbmhUU2pEUk1EME5PcDd0MTZoZ1VuMTI2eTNuS3FraWNUU1BW?=
 =?utf-8?B?Y0VITEJOcno2Sm9wK2o0bisvZzJERHlCWEtFOGsrTXhneVlITXRpek50WUxC?=
 =?utf-8?B?L2Z1Kzk1LzZnZHVMSGFSdlp5eWRPZ0pBTy9LVjVqQmJZdjZIaTFPVFBvMXJG?=
 =?utf-8?B?OXVtR1ovS2ZybDVDWWdTbnRrSlNGdjh6UHE1cWdIdzF2SXpWUDRyYUtMZzkx?=
 =?utf-8?B?ZVhhVytuSlZXM1J0WldEL2U3MjJpdmhaMkN4ck10MGxEbjFsZThnRVNLVGRX?=
 =?utf-8?B?dy82RHdUbDBrZmdqNmpDYWd6aXZkY2xYYnVYT3RWbmVsSVJvckc0VzJUWVRJ?=
 =?utf-8?B?eEJXY3VxbDEyMGRjNHlLTVlqSUd3WGlnNkJlUDJMcUZUaXNZU1Q4cEJnbUM2?=
 =?utf-8?B?RnZJbEdUM0sraElsVGJKc1FFcUdROWM2bWVMOUkzc0ExTVI4cE5zTG9lQ3FG?=
 =?utf-8?B?dmxWVGZodVBvdGRidWdORmRjbXZEVDZ2c1g4b2syWHpVWWxVS2M3aW54czRF?=
 =?utf-8?B?Tm1YUHJ3SnF1NVRPMHlvYm9TRENYZmJKN0h4VEtZMGVadlNDYm93M0tPRjZt?=
 =?utf-8?B?K0hnZmFRcjZmZXhPd3hZZHJDK05LWFlXMkNRQ3B1bTkrTFJyQnZYd29rQllj?=
 =?utf-8?B?UVgxY09UZUNFSjR0WFF1U1ZhVTNFakE4NWdJNEZEN2VXbEFFaFFkTldUSWpx?=
 =?utf-8?B?RlBCRWpielpVQ3dzTzRNdTBwbERQZEt4UGVUQVZzRVhSOWZMaVVCNFgyQ2hP?=
 =?utf-8?B?REFrVDlWL1UrZlhYWHBTdHk3OGc4NEVIbGRoSWsvUk5JYXR0TVMzWUc0c3No?=
 =?utf-8?B?SnkzY09kalE0SDhXSm5LaEFSRms2QmVFeE5qeHdyUWdvZUpTbnp0bVYxOUNs?=
 =?utf-8?B?K05sWU5TcmxHOVl6MTNKaE15QTVBbFdDZU9yTnI5cGcxV00vNk5hL2krZ1Rx?=
 =?utf-8?B?cXRVc3ZGdnhERm5VOEk0S1pjWDRtWXVQbWpTU3R5RXRTYm9RUEpSMndwZlRJ?=
 =?utf-8?B?MnIxSnlUWklNN1ZvYmdyb2l5Uk9BNjFxTDRDelNMaGNBUFdBRjcraVVoY3BJ?=
 =?utf-8?B?Q0Z0Z3g4VXZINEhnWE84dzlneTFpU095Uit4aDdVSlFpY1JVQmxWd3ErQWw0?=
 =?utf-8?B?RURKRmxqZS9JRVN6V2xzN2VVWnJoQnhaU0FaeXNyRzN0OXd0RGhoK0J6cENN?=
 =?utf-8?B?SmozUVVHNXZmUGRTeXNUVkVPdHpXNjhVMlQ4VkYwY3U3UExGQlRNbFltNXBF?=
 =?utf-8?B?R1BtMGo4N29LWmFnOGVqVFl4dFpyeDhmTVd2RTJmSk1EeVRKTWRGREZFek9G?=
 =?utf-8?B?Z2djQ092UnFlVGt5eHlYYkFJYXJhUGd4aEdmbUNWZm1USnpBZzVBR0FmcWZk?=
 =?utf-8?B?bnVsS1ltT0pEd3FNbUhKNTMwajdObitORTdJRTZCRGJHRUNPZVZkT2IvcWhY?=
 =?utf-8?B?NGRSYy9OQ3ZRT2Z1eU0yRGh3NWxjRUVwVHRtdm9kV0RRSW9Dc215MldnaDVE?=
 =?utf-8?B?bURLVDdaS01MeDM3M1NXWXBYMHNyK2dTa29SNFFydXNkQXhvdFQvRDhWTUtj?=
 =?utf-8?B?bVZuS284SlE3aGtpcXRrOEppY3NqOVl1ajVwYzNocDZoUjFnbW1YOGZTbkFL?=
 =?utf-8?B?eXpKS21EMm5sQXpXT3R5VDMrUmJaNExIcThJQU5lVXdTRlBmR0g2emtlNnhR?=
 =?utf-8?B?TURGZXJ1MDhUMWF4UGc0SnBKaGVNai9sRkR6V25SMTdtaWZnUmhrN0lBMHpm?=
 =?utf-8?B?Tk1mRkx1bk9xVjVkbXpMRnZDK1YvNHdmTFZkUVg5NHhaM0xvZ09TMzdGdmJw?=
 =?utf-8?B?QzczcUVnZVJSN3hLU2J1MUN5akdaU0s3Wk1sVlh6Y0xMQysvWFNmUjBUNGRx?=
 =?utf-8?B?QlFBWFk2WXZ3cDJXNFVKaTIrdGN5dC9WOFE3Vy9JNS95RGlZc2k2ZExkNmFq?=
 =?utf-8?B?Nk43ZzNvL2c2dEVnTTJDWUwxNE5ndjduZkN0aGsvVEo2R1RzTTY1TVhxZVM2?=
 =?utf-8?B?YnhQOG44NWhoek9yNTJIMGZzdnEzbmRSWUo3N0RjQ2p2SkVpSTY3VkUyVFNw?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1DE4A1BCCDC5E48BE55A823A403AF69@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ISyJaXN3sj6Sjob/Q2PWdCnJ4yvr9VCOv6RCOaed3hrQA4kgctl3SbkGxBngVSED4BZydAsl2IjzmcBMOMUoT6LONC+kgno8uf7aU1/HonHbSE6IOwbvC1MZ2zUGKSDNy8hCJYVSkeJDEj52JekonArklTd1/ILTQxC4U9fEOHXOCoberg6TQNjgvR7LNaVOichetuYuqhiB1qZiKGgq22A4n5CLZ21enc5SFDN9gZfXWW1pzUdg4tl9QAsTlx2Ff5kZQB9/OqB+xndGE/0NNh8amWoQMNtu6d6QX9JTvuS6kzpnz34Th4CpNvbh4mDl8hZDSAJ7ZVkvMgXzCsPLXQSN972h67iZ35eIIvy7v6gZKGuOjywB6x1svmRMs5e60VEzdu4Jh8SGnxG50cd+Zy+GKpCSyFdDkhAXWktdEn8dZg3YVxj+8gOyl7yjR9azNvMcFfLNePv9kXtfQLRKZXE1Z2x2lZg3vyVDch8tsxYtZ3Cyi3lriFRg3RYXZzNc6VlZWwzWHtCutyf2UiYSwb83DCwt0X4ceOCyTSpVcIBU82VQpN4Q46AKAvX0erJ1C7osAYO7L6tfqfGGR6mDT9AQTKPyTdnCrmoH8N0FX+hXjkTMi0MzR4k31ifMRUYywiA+morEArlJT+dOf+ijv7CM6ptZcBl94PHuPapW3Mie1DJ6vKdzwDliWyZpYSAEuYXw/1UaG6cMTWtOETG/QXq5tDnnCUZfCUrCxN3pudsM3rAz0JQKkKU8dogmGv8vKkQWyeoZUfJHkp9dOc80VVPvNhS+LrudAeHi85EssI8gw7IOlSNMwk5nUjwtqWb3Z3vHdLzzHoNL41rp0XIQPw==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b94555-8dd7-4b2b-b78a-08db8144b75f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2023 12:53:53.6914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2jnjWW/Nz+w2Lxou7AlX+7z5sWuCvb16uQCnIggJWAV8M2Eg66Un5D3ljkISd+7jGwdJ4mCe8TOKYNTPJozpow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10007

DQoNCm9uIDcvNi8yMDIzIDU6MDMgQU0sIFZlcm1hLCBWaXNoYWwgTCB3cm90ZToNCj4gT24gV2Vk
LCAyMDIzLTA1LTMxIGF0IDEwOjE5ICswODAwLCBMaSBaaGlqaWFuIHdyb3RlOg0KPj4gQWNjb3Jk
aW5nIHRvIHRoZSB0b29sJ3MgZG9jdW1lbnRhdGlvbiwgd2hlbiAnLWwgc3RhbmRhcmQnIGlzDQo+
PiBzcGVjaWZpZWQsDQo+PiBsb2cgd291bGQgYmUgb3V0cHV0IHRvIHRoZSBzdGRvdXQuIEJ1dCBz
aW5jZSBpdCdzIHVzaW5nIHN0cm5jbXAoYSwgYiwNCj4+IDEwKQ0KPj4gdG8gY29tcGFyZSB0aGUg
Zm9ybWVyIDEwIGNoYXJhY3RlcnMsIGl0IHdpbGwgYWxzbyB3cm9uZ2x5IGRldGVjdCBhDQo+PiBm
aWxlbmFtZQ0KPj4gc3RhcnRpbmcgd2l0aCBhIHN1YnN0cmluZyAnc3RhbmRhcmQnIGFzIHN0ZG91
dC4NCj4+DQo+PiBGb3IgZXhhbXBsZToNCj4+ICQgY3hsIG1vbml0b3IgLWwgc3RhbmRhcmQubG9n
DQo+Pg0KPj4gVXNlciBpcyBtb3N0IGxpa2VseSB3YW50IHRvIHNhdmUgbG9nIHRvIC4vc3RhbmRh
cmQubG9nIGluc3RlYWQgb2YNCj4+IHN0ZG91dC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBMaSBa
aGlqaWFuIDxsaXpoaWppYW5AZnVqaXRzdS5jb20+DQo+PiAtLS0NCj4+IFYzOiBJbXByb3ZlIGNv
bW1pdCBsb2cgIyBEYXZlDQo+PiBWMjogY29tbWl0IGxvZyB1cGRhdGVkICMgRGF2ZQ0KPj4gLS0t
DQo+PiAgwqBjeGwvbW9uaXRvci5jIHwgMiArLQ0KPj4gIMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2N4bC9tb25pdG9y
LmMgYi9jeGwvbW9uaXRvci5jDQo+PiBpbmRleCBmMGUzYzRjM2Y0NWMuLjE3OTY0NjU2MjE4NyAx
MDA2NDQNCj4+IC0tLSBhL2N4bC9tb25pdG9yLmMNCj4+ICsrKyBiL2N4bC9tb25pdG9yLmMNCj4+
IEBAIC0xODgsNyArMTg4LDcgQEAgaW50IGNtZF9tb25pdG9yKGludCBhcmdjLCBjb25zdCBjaGFy
ICoqYXJndiwNCj4+IHN0cnVjdCBjeGxfY3R4ICpjdHgpDQo+PiAgwqDCoMKgwqDCoMKgwqDCoGVs
c2UNCj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG1vbml0b3IuY3R4LmxvZ19w
cmlvcml0eSA9IExPR19JTkZPOw0KPj4gICANCj4+IC3CoMKgwqDCoMKgwqDCoGlmIChzdHJuY21w
KGxvZywgIi4vc3RhbmRhcmQiLCAxMCkgPT0gMCkNCj4+ICvCoMKgwqDCoMKgwqDCoGlmIChzdHJj
bXAobG9nLCAiLi9zdGFuZGFyZCIpID09IDApDQo+IEFzIG5vdGVkIGluIHBhdGNoIDEsIHRoaXMg
c2hvdWxkIGp1c3QgYmUgdXNpbmcgJ3N0YW5kYXJkJywgbm90DQo+ICcuL3N0YW5kYXJkJy4NCj4N
Cj4gV2l0aCB0aGVzZSBwYXRjaGVzIHRoZSBiZWhhdmlvciBiZWNvbWVzOg0KPg0KPiAqIGlmIC1s
IHN0YW5kYXJkIGlzIHVzZWQsIGl0IGNyZWF0ZXMgYSBmaWxlIGNhbGxlZCBzdGFuZGFyZCBpbiB0
aGUgY3dkDQo+ICogaWYgLWwgLi9zdGFuZGFyZCBpcyB1c2VkLCBpdCB1c2VzIHN0ZG91dA0KDQpO
b3QgcmVhbGx5LCAnLi9zdGFuZGFyZCcgd2lsbCBiZWNvbWUgJy4vLi9zdGFuZGFyZCfCoCBieSAN
CnBhcnNlX29wdGlvbnNfcHJlZml4KCkNCg0KVGhhbmtzDQpaaGlqaWFuDQoNCj4NCj4gSXQgc2hv
dWxkIGJlaGF2ZSB0aGUgb3Bwb3NpdGUgd2F5IGZvciBib3RoIG9mIHRob3NlIGNhc2VzLg0KPg0K
Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbW9uaXRvci5jdHgubG9nX2ZuID0g
bG9nX3N0YW5kYXJkOw0KPj4gIMKgwqDCoMKgwqDCoMKgwqBlbHNlIHsNCj4+ICDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoG1vbml0b3IuY3R4LmxvZ19maWxlID0gZm9wZW4obG9nLCAi
YSsiKTsNCg==
