Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642A84681
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 15:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657725325; x=1689261325;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6qsklBKjJfEhMjGwbOu8kFUI6g8UeYW9Jrk71+bcTFA=;
  b=dvNkLK2n0NL7K76cq1N2d7NMBlAxwahqUdeto3bK+CGrABgB9+I7VlBR
   Bl9xNNg+LJ2oA20Qp+R+J9pcd9/ZIpBqsehGT9mkqjR2eI6D8sFDHNxsw
   u2S5FhreE4C4NWV+RzsaqZG25tfEeGjgjtZm+Mk4zNiwSAH75CsuXXz/Q
   7JtdnYv/Epwe4V62pxVsmsDtyPG1PQ/JklHZ/xniDuyluB2R6Kcf8E5f2
   E2SxE1WcMRKrbWFvVlMgN5kYGrDBRp4ta4o9tLtgRKtpQSGTKxh9lmsLF
   refV6ZGgoVZixZSLsi9sudzmbQaFOgG2n/iokVOGSaGDtsvGJDXHH8pQh
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="283994136"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="283994136"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 08:15:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="622985856"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 13 Jul 2022 08:15:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 08:15:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 08:15:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 08:15:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFXm8jLau1drMbqEiu9b0WVoYG8y5NNmqPU/7IX6/Gkqf5yApto3UZUxADWagZosjt38sGppvFZo8uF99QqQBrZ9xwms8X8UFMzumz5Z22ZzXEkfbSg2QQ5RaDbpqL7bZXJCWDjmtfAcjcGB0BEQRslMehQa4sMVbGBLx7FLcgfcWNHq9RIjv6zV1B11iP10bMRtg5Z7pBAUkee5XnHjNVds3h6jaJ1EgfQTLEty4520vW50VRm6Q3MWUiH1MnsGR+HG6cUDCn7YPXugxT/N2q6LLtUIYESl/NSMboR/R2ya2bmF/moMqQ0FWZ1XumTKSWBf4M3i4GMxraGE7/Qc1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qsklBKjJfEhMjGwbOu8kFUI6g8UeYW9Jrk71+bcTFA=;
 b=gPTiSJ9qy/Siqc7ZBsjxRP1aV6L77T8/UswjX+FsluHtBcD+3vDRO7lnSIjFi9zbKHmrS0DRTqBMCq5CBEh9rttDp+1twYemvLtxBjvcHL1RnKjSGG9pCAc/dnfW63HqsHwuVTH/ToJK+60eg7WrbVmEPN4NwPDb/o1sObkVk5xFWm361taRqLrwcpPPtZGaDiXY/yMBpv25XHQv5QHT5FTrAUHOooVfHtUxoUV3v/GlIZGxFTDlYrZv0B1+GAXdiB39/bBn2K8zHwTCWHdKo7VMMLs1Gyhuw0hgi99RoX9T/qqrLrRHK13rX9AOPC7CB5+e4mFUMADYE+H6S3NaVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MWHPR11MB1806.namprd11.prod.outlook.com (2603:10b6:300:10e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Wed, 13 Jul
 2022 15:15:14 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17%5]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 15:15:13 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 11/11] cxl/test: Checkout region setup/teardown
Thread-Topic: [ndctl PATCH 11/11] cxl/test: Checkout region setup/teardown
Thread-Index: AQHYliLJusWL0T7kEkWsmynRroPu0q177WOAgAB1aACAAAefgA==
Date: Wed, 13 Jul 2022 15:15:13 +0000
Message-ID: <78497219caf627714d2ee1b553ff3f78474508eb.camel@intel.com>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
	 <165765290724.435671.2335548848278684605.stgit@dwillia2-xfh>
	 <4c3074a5393a5d3758ac58028e047edf43f84115.camel@intel.com>
	 <62cedb1ad2457_6070c29451@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <62cedb1ad2457_6070c29451@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02ce2f29-f9f4-4353-3df1-08da64e27c20
x-ms-traffictypediagnostic: MWHPR11MB1806:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5qgSR3XykYVdyfnmm/ADzGdr7N8fbEtelZ7Knc9go/LLootQl8KXnxwn5+GfwlQwmbRWGfGjxL+ZIt9NVV0CIqWIrRp9ew8ftZeSac2FfU1hm45F3JPrArJJutZmfscCteBlaNF6luNOKICAAIqlyQdJdQVdVElGyjWaTdtMFMkfvo06O6dCtZ2hTuwcaEttozja76kcKrovGYv71gLL6/lfKhQXbVXNU7ttPx2/tC38uD4bviBrbk+g8rwfayqQ8QxQBJKRUpNZveWOo6qaYk3kqFcA1zGoRsV0nY0hy8JEsk68DHYuq61KjJJoqH6iyiGN7PI5liW7iThi+ooNJKPFFjtFKq23+9lY0BcVA2L8AReZhy1dSHwjuz1bRcAQV8TxzX6GN2FamA6fgTESmmJ7XfKpoBA2n+2Jf9SHa3rXuRrJHxYt5u3qsKOaOQxg0Rjhl6y0aOIBVuP1p5XTDGTZvej+1Ekg1BfzWOfwAYWHbIjTZ3tXS5s1sa1BaP9S/1I4kRRzPdPJLHL8bGznf5meGlDB3oGG10gEGmbpYt+SX+p1AjlLPEWhvQjdmcZOzBKYXzGdo9EgH3QD+x4cPXtbtmTeurVGr81kgs1ClEwaxx49a5GAnpLtdL4miSOpZs0JcGSoDwK9nQX+2zmyBOlSOCYPskQMpWdQOo+BJA3RGXrC8e2bOo6gg6t2lCtnfvVZ0MYLsluWGO8IVyULb3PWmNnrJ1z2bVRNfu3gy4yUECtfExDf+4odnLJutg4sAPrEGokMEErk8zwcx/+oocbHMgmbiCotr9mVFByYDrM7aes3xJP2322c4L+o7uDc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(39860400002)(346002)(136003)(396003)(2906002)(5660300002)(36756003)(6486002)(186003)(6506007)(26005)(86362001)(8936002)(478600001)(4326008)(66946007)(8676002)(38100700002)(76116006)(66446008)(66556008)(66476007)(64756008)(91956017)(82960400001)(6862004)(54906003)(2616005)(37006003)(41300700001)(38070700005)(6636002)(316002)(6512007)(71200400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTlzNFlXYmY1dG5WdGp1NGY3bWJpWUR0LzZKNXowbThQZmhkOFMvckxLYjFI?=
 =?utf-8?B?U3JRV096WUJEeG5rczlmVVFQdis0WjkyelFkeTNQWmFoSU9FcnRBdkppZU1W?=
 =?utf-8?B?MnkzaFYwZUgyTGw5eVlXeFRmRmk0WjVxTUF6Tld3ZEl3TCtOQVJGdGNtRnQv?=
 =?utf-8?B?RU45WmZ3ck5mK054ZDMwaVRud25ZYUxTQ3R2NWZxMzROVVZ0bzZWSktoNEU2?=
 =?utf-8?B?cStQcGlraTZwd1d4cWJZYVNNRUdPbWRGK3lOSHBEY3ZkN1BpeG9EekVpSDQx?=
 =?utf-8?B?VUpLTVV4UEVoWnQ1amlUVjVtc3NhU3FtOG9hWUVEYVdCSjFyZEg3WURSZ3Bs?=
 =?utf-8?B?elFZMEd5czBhS3M4V3MrSlhBVWFES1pPVFJRN3N6ekRmcWU1bXNQaW1pS0U0?=
 =?utf-8?B?NFRSczlTUS85ZTBlUTVvcEx5ZkhiR0QzRGJLUjg2ekNYdWVJaUEvdTUzM2xn?=
 =?utf-8?B?TGRSK0EvaENLZTFWVkZJTFV5ajRPNGpZNlg4NWJnczhYWEZXNElMZ3RvclZQ?=
 =?utf-8?B?UWVoc3VlUldnRU9va04zcmpCTW5wTEZiUlR2QXdtQnpuN21LZkVsY1FZT0JI?=
 =?utf-8?B?ZytaK3lCbVpDdytDNGhpekxOR1J6ekFvZHFKZmlTVU5SVkpmWHJZZzNIZXho?=
 =?utf-8?B?YmcwZEw4ZjdhWnlSbVVzZklvVURHVEdLTElFNUdXeXZselZVU0E1N2tKTFFa?=
 =?utf-8?B?aVl6bzJ6ZVNjbzlSSUE3ZTE2ZEhLNGo5ZmpTTENWektVTi9PWXA1QlBCZzVv?=
 =?utf-8?B?bVZLOHRIWFg5VHpuK2xLcFczWE1VWVhLL1Y4azBETHl0OCtaSHRFRmRtV2ty?=
 =?utf-8?B?V2YwcVBYdVI1WmRUVllVV050TUVEZzRYSkZ3Wmw3b2l5MldjVU55cmFoTzJW?=
 =?utf-8?B?K3Nxa2pBdXdiS1FXWlNNQkVkUWVVd0JyNnhwZXN2U1lLSWhxS1o5UEpkTGhG?=
 =?utf-8?B?ZnZQTVU3Z1JzZkdQMWx2dHg3YlE1YnBsc2t5SS9XNE95ZTZQK0c4b2FOUGp5?=
 =?utf-8?B?d2pPL3E2Q2VRMnlBVklmdGNuNjNGMk04d1orOUQveDBUeTVXd09VTVZ5KzNF?=
 =?utf-8?B?WUR2Ly9SdFZWaWdoMklST1g2R0lmOGdiNXVIRFBseEZrZFk1aG1DL1QrenlX?=
 =?utf-8?B?MlBwN1RGU2JhdmV0ZElleHVubmtZSmxDc2lpOVl3a0JKSmRJamlXWHp6b0xH?=
 =?utf-8?B?RG5sQ285eXlHeGNtT04rbXZWSFc0RUJsSENpMWxOajloV2RoZU55eDRzR1lR?=
 =?utf-8?B?czNlVGVyYWI4VmFHWlhveUdwNTl5K0RQTEFIRFFpQTRaSWNKSXBUOGZxOTBJ?=
 =?utf-8?B?U1puUk1ndXBCNnVwd2g5aTJ3QWg5MWZlMjQwL2o3cHVhWTgyaVZtTk1MamZP?=
 =?utf-8?B?c3U3MWR6REpLSVN5WHNTeG5mUk9lTTNMYjNIbk03K0NQenlhemxJQ0JQYXhF?=
 =?utf-8?B?emJlQVM4V2pGeEFxMXR1R2dIenpwenpLemZzMklBdGZGZlg3azd2WFM3Yzk4?=
 =?utf-8?B?VEM3MnBNVTJHOENmYW5lcWQyZ0VodFlMb1E1WHY0NUZ4dHRxTlE5b2cvWGpF?=
 =?utf-8?B?dXJMT25GU0Nad0laRFhXL1cyaUJOTDRXM3BIZnZ6RTV3U2FvTElhWHhqT3hF?=
 =?utf-8?B?NGdocnVQanlyaldaaDdhVmNWTW5wSmxNdWNyN3cyUnVpeC9WMDZCMWZoeXZD?=
 =?utf-8?B?aHMwS2VmdHlYT1pxOWZ0RDkvK3Ara0hUUVpOVVIzK1F5TVV2Mm5iK0kvZ1Ax?=
 =?utf-8?B?c21MZU9WZlp0S2MxMU9VMzlDQVJBT2M5Y0FiYWU4aHNjbE5QdVNkQmR5TTFo?=
 =?utf-8?B?eEZRRW05UXo5ZHIzYkxieDF2YUdVQlR3amY2dTU3dnIvdGEwM09tUFN6SVFK?=
 =?utf-8?B?TmN4YlgrdlBHNTV3T01DSWlSZmxFTll2ZXdKVmhWY2NTNVU1M0Q4bWR5b2lk?=
 =?utf-8?B?ZGMrcXdRQXZoQllpSldQaUtPbkZHZURnUXlMRVJ6bGNXMWt1a2VIckpJQnc2?=
 =?utf-8?B?RjNPdTNEZ2gzUDl4bGtLZEwxaDNoQWlzaitMQWk1MU16d0NIVWdUYitYZmlN?=
 =?utf-8?B?TWFveGF5QmdGdmVGdmo0OTZMdE5hQXpKYnU3VCtqbXQ1L0pYVUhwU2NxMGE1?=
 =?utf-8?B?a05kVjc3dW8rSFd5MUZrL3dEb1VPK1o5emhvL1NacGlIZDBJQ2ZoY3Z3Ly8r?=
 =?utf-8?B?Rmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A58EB778EE9F534E86A503B0279DE125@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ce2f29-f9f4-4353-3df1-08da64e27c20
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 15:15:13.3752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbK2bhnfL0/68NDLseoAIBFv0prVsmejFnbn6zi2ie9hhIuEXTLugs7TY9gg+mn7ryvHYHqT+U7jPj4+26/pq3O+RDMV0CgqP3YrPvJRgTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1806
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTA3LTEzIGF0IDA3OjQ3IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFZlcm1hLCBWaXNoYWwgTCB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMjItMDctMTIgYXQgMTI6MDgg
LTA3MDAsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gPiA+IEV4ZXJjaXNlIHRoZSBmdW5kYW1lbnRh
bCByZWdpb24gcHJvdmlzaW9uaW5nIHN5c2ZzIG1lY2hhbmlzbXMgb2YgZGlzY292ZXJpbmcNCj4g
PiA+IGF2YWlsYWJsZSBEUEEgY2FwYWNpdHksIGFsbG9jYXRpbmcgRFBBIHRvIGEgcmVnaW9uLCBh
bmQgcHJvZ3JhbW1pbmcgSERNDQo+ID4gPiBkZWNvZGVycy4NCj4gPiA+IA0KPiA+ID4gU2lnbmVk
LW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+ID4gPiAt
LS0NCj4gPiA+IMKgdGVzdC9jeGwtcmVnaW9uLWNyZWF0ZS5zaCB8wqAgMTIyICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gwqB0ZXN0L21lc29uLmJ1
aWxkwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgwqAgMiArDQo+ID4gPiDCoDIgZmlsZXMgY2hhbmdl
ZCwgMTI0IGluc2VydGlvbnMoKykNCj4gPiA+IMKgY3JlYXRlIG1vZGUgMTAwNjQ0IHRlc3QvY3hs
LXJlZ2lvbi1jcmVhdGUuc2gNCj4gPiANCj4gPiBTaW5jZSB0aGlzIGlzbid0IGFjdHVhbGx5IGNy
ZWF0aW5nIGEgcmVnaW9uLCBzaG91bGQgdGhpcyBiZSBuYW1lZA0KPiA+IGN4bC1yZXNlcnZlLWRw
YS5zaCA/DQo+IA0KPiBUaGUgdGVzdCBnb2VzIGFsbCB0aGUgd2F5IHRvIHRoZSBwb2ludCBvZiBy
ZWdpc3RlcmluZyBhIG5ldyByZWdpb24gd2l0aA0KPiBsaWJudmRpbW0sIHNvIGl0IGlzIHJlZ2lv
biBjcmVhdGlvbi4NCj4gDQo+ID4gQWx0ZXJuYXRpdmVseSAtIEkgZ3Vlc3MgdGhpcyB0ZXN0IGNv
dWxkIGp1c3QgYmUgZXh0ZW5kZWQgdG8gZG8gYWN0dWFsDQo+ID4gcmVnaW9uIGNyZWF0aW9uIG9u
Y2UgdGhhdCBpcyBhdmFpbGFibGUgaW4gY3hsLWNsaT8NCj4gDQo+IEkgd2FzIHRoaW5raW5nIHRo
YXQncyBhIHNlcGFyYXRlIHRlc3QgdGhhdCBtb3ZlcyBmcm9tIGp1c3Qgb25lIGhhcmRjb2RlZA0K
PiBwbWVtIHJlZ2lvbiB2aWEgc3lzZnMgdG9nZ2xpbmcgdG8gcGVybXV0aW5nIGFsbCB0aGUgcG9z
c2libGUgY3hsX3Rlc3QNCj4gcmVnaW9uIGNvbmZpZ3VyYXRpb25zIGFjcm9zcyBib3RoIG1vZGVz
IHZpYSAnY3hsIGNyZWF0ZS1yZWdpb24nLiBPbmUgaXMNCj4gYSBzeXNmcyBzbW9rZSB0ZXN0IHRo
ZSBvdGhlciBpcyBhIGNyZWF0ZS1yZWdpb24gdW5pdCB0ZXN0Lg0KDQpBaCBva2F5IG1ha2VzIHNl
bnNlIC0gbWF5YmUgdGhpcyBzaG91bGQgYmUgY2FsbGVkIGN4bC1yZWdpb24tc3lzZnMgdG8NCnJl
ZmxlY3QgdGhhdD8NCj4gDQo=
