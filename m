Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F49640
	for <nvdimm@lists.linux.dev>; Fri, 13 Jan 2023 05:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673586732; x=1705122732;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=p3BGEsUE5zyyTAYDqoIY3pqtlp9YghaFAXXdCjwzyeM=;
  b=Nre4PiE0xdOIOIaUuLB7oFsEy2ZhucLXtpgKvRzHgpewxzkH+Wj876/g
   bMxnVSiTt4WPRHbHAlwm2kExjGCZtuLFxyE5wGWmwe+M2b9pcQNMIWSEO
   exKpoM3tL/sLRZM2qtP7qibExNOI7/naZIp/CKcq0Q9N8NK11nhJQCu6H
   tty+eLeyZEaioKNpBoPgGH32Mg/cLH1WOjatZM2wA2nsmHxULkCj/ChA5
   ifjh3j3Y5/WgXW1EDB/XNbBqC+gULp6AFsu53rAiLm81gd3HF7vFLLBs2
   cY+8d/hAa6nKI4xrx7V8rL2VcKlPBYRdBjwFeniBsFtZiBoktubOnDqUy
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="325177700"
X-IronPort-AV: E=Sophos;i="5.97,213,1669104000"; 
   d="scan'208";a="325177700"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 21:12:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986863892"
X-IronPort-AV: E=Sophos;i="5.97,213,1669104000"; 
   d="scan'208";a="986863892"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 12 Jan 2023 21:12:11 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 21:12:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 21:12:10 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 12 Jan 2023 21:12:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9leMc3AyhvxjxwAb24D9mD1m5UZi8l7x1++br9VoeObasP3qK7n583Mr3k1cuqPMX5+NX1QK1qQX4BzbjmRj+gk76J+armXwb8fDDw6pnwlKva6GyH7v9UTMNAa6PLWlHGrhhZubOdy6luYng+T0p0gNmSOOmbDnkRWl9y0EPSwQaSNz6BveIcV7sRWVA9AUFNHtaCELAjYVsDd0pMS5FMbha6/2Spy9+ZPCAztsgns5JoO2jkgf1UyLOedKDTheLadQ5wjumRhGFcMu0axB2OKQ9CYuk59I90EDjzy3PQlOJxRyJYx107gfPtpYgsXpB2JsZej1Y8pIkR9INC6+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p3BGEsUE5zyyTAYDqoIY3pqtlp9YghaFAXXdCjwzyeM=;
 b=k45KUc06rSiqOmA3iL4fqBqd62vX4WcSLYtXXTHOaCrePynasBG+gTlged0+5tC8d6jz75po5wX2CUu/cooecF44SDY1/FXCD6BujZAiPqZVyODWrfez4eJiaTx70AXkB/wTJBlBaUuTQa2jRkeOre6u2cNOlfxtIVoxFWtAWhrSABsRArfIq+9fzSB1YcpF1niTO9kfSlzC8ljduWyGsFw3AP0GWIWCHZjawW12XmGdQNgz+G8cNfSAB3eVNvRnKRka72Jg9ZpRmaC66yFCEASJD0JT73ZIYbTfZmpd4qESeuu7ppqJKhsOR0vX6ktdqT7m/7jL0Pi0CS4Y0vshJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SN7PR11MB6702.namprd11.prod.outlook.com (2603:10b6:806:269::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 05:12:07 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1ad0:a5dd:2fec:399c]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1ad0:a5dd:2fec:399c%5]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 05:12:07 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [ANNOUNCE] ndctl v75
Thread-Topic: [ANNOUNCE] ndctl v75
Thread-Index: AQHZJw2U5f4Fo/pmg0+aIMsb03polg==
Date: Fri, 13 Jan 2023 05:12:06 +0000
Message-ID: <a0c4ec06cdc157a4ea4afe084795a8c28fab4084.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.2 (3.46.2-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|SN7PR11MB6702:EE_
x-ms-office365-filtering-correlation-id: f4eb2c86-584f-4f1b-b55f-08daf524b75b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kl2qzf6T4MlrMAYq2NRBuGIkDkla5QSGsUguUYHQn7Io0Kf6JukGjQGMH7bUzu9z81pavsZovvHNQIi+W/Vvumh6EOZImLm3WY5uFjmE0fiWUroPslOWZjIgWMer7uSnzp43xyhv2oQCld3Kdk0K78HzMHNEisX/dUu4dtYU5mfedvD/Bf1Cfnn3GazbPoyHcBFFM5uI4gSt7c5135Av0RpQeefhr6lyq8Sq7vHX4r3lNeqQLp5m+6D/K4SCnh9Zfywsof9jGInB1YIGlSA6ed5G1vfSaA8BuZd2+XiSMFL8x9y875yAAIi3cFouWeCeq6FHqSrkQWtilkYwYyBiH0hycx9p15FT+Vd5ivsXIq8YpHdBBR58ytcXCT/kQ0wAxy80Wh6u0KtMOm7/g2n3KyouTEkUGL++qRaTbDJCixhbKzCnKscX2x/+HTxexuQtPil57BK33nghqN3ggGknr9cHqUcaJ3LyW7zNvtgrDzPvWVUHgJYoWDHJlBY6ff4VhHJNTTevrBe4rUJayRCni852n5yIWJX8Oc738Vusu+wZbexMR50MS3Z4ZUub1ePoEXu5te1gcn51R4Gpf78rTsSby7LvEgX/FNjiidyS9U7JwPTCUbiCqaJXvLRMGG+jaHXClfb2CdJrgEGxn/IDUtSZo5O4Tb1bIbeFuWtnh2Jn+czwE3UUS/7rZ3C3xGyAQq2KFA7FOz119VNknliimz9YSS5x8o/ZCDQPB/GsSxQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(39860400002)(346002)(376002)(366004)(451199015)(26005)(36756003)(186003)(122000001)(8936002)(107886003)(6512007)(6486002)(2616005)(6506007)(66446008)(478600001)(66946007)(5660300002)(66556008)(64756008)(66476007)(316002)(4326008)(91956017)(71200400001)(966005)(38070700005)(41300700001)(38100700002)(82960400001)(110136005)(86362001)(76116006)(8676002)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3FucVRtWjN0NHRwU001ZUUvbW9pNzV4NWwzelRIaGFYUjFKaFlyK0EzdWR4?=
 =?utf-8?B?VzhuRlJGR1I5QTUvZ0FLNGEralh5RzQzNEZGZVdWVGRHbEZ5NkM4T2tDWmJ3?=
 =?utf-8?B?dkN6M3YyNGJRWG82azBkcGo2ZFF3WHhmbXdSLzBEYzVDQkVhWm5JV0haSGRJ?=
 =?utf-8?B?V1N1S3ZyeWxaVTYwWGVUQ1RrYWxlT0wvNWwxb2pzdTAwSm5RT01XcC96dFNH?=
 =?utf-8?B?OEh0cXBpajR2R21ncTJUUmZYWWFUbVpDNThMYjR3bzZvQTZLRjFBNnRoVjNS?=
 =?utf-8?B?TXhOK2pUNTFQQ3R1Tmc5bXNaQjl2V29obGdJWVdmTHpzZzhvbHF2WkRHT1Ba?=
 =?utf-8?B?blZsdGk4SnROYlZUdnUxTVYramZUclArVGFBSmw0L2lqRlpobWx2dlBIOTdH?=
 =?utf-8?B?RnV2eCs3eG93dXBlZysyRGVsQ1o1S25uaFpjcng2UmdCNUJhZmZYY3NvV3hI?=
 =?utf-8?B?d2JlZHA2UCtPOEVVb3N6TEN1T2xjOVZHRFhRalkwZUpiZlFtdmtVcmJjSzAx?=
 =?utf-8?B?eGh5eHowSVphbGk1a01TaXpsSW50c2lJcWZkMTBkQ3BEbGNpN0tZZDEvL1Yr?=
 =?utf-8?B?M01tcFUvSUl1QkdXc0lwZllQcHRtbHFrVTFTNVhhTWFpRzAzVEE0YTdYVERW?=
 =?utf-8?B?TEpWQm01UEVvMnV3bm5TQzBEUi9WaDVpZUIyU2VsS0VKSHU1RW45bDB1WTh3?=
 =?utf-8?B?Sy8yT2NhYk1sdklIMHVKTU91YWEvczJwbG9tSVY4b3lCS3QzdzVKa0gyK3Zt?=
 =?utf-8?B?K3doOXMyekR3UUhXNE9IMGlBTlRHc1E3NDVnYjZJK2d1MWxVU0JhREJ2T285?=
 =?utf-8?B?RHNzSGJSSEZiNVlXTk1zWXlJMGtJTUhBaTlEaUVEVXB5c09McnZFbGVHaUdx?=
 =?utf-8?B?WFN5dnA0d2taUE93R2hUZjFncmVtaCtzTFQ1dnV1akFwalhuT1NJVzR3czV0?=
 =?utf-8?B?VC9MamFEcU5jUmFsWGVJTm9iWVhMYUZZeU05SFVFdy96clB0bHlDZ2pNL29V?=
 =?utf-8?B?a21iTmx2c1NtV2JWVXgvY05PcFFkQ2s4ZThGT200QmFlVjFWdllyUmpwdEZp?=
 =?utf-8?B?TzZ1WWdtdFhib2daUVZkbjdqU1V6QlpPR3JQUSt1UlJkWFZRa1JQdzEzcUU2?=
 =?utf-8?B?d1cyaUFFZ08yL2VhVnVSRXdpWnprMU05MzJNVnB1R01KVXlWblF5QVV1UUE0?=
 =?utf-8?B?S3AwWWsxYis4M1Y4dTBXbXFQRXZZTTBXeVVGelFMZFlsOUgvcWlBQUllTnMv?=
 =?utf-8?B?cGFBeTB6VlN0ZU5CWk0zZXNqWkM2WlZFRWg1T3greW9SWERZdndqdThVUXI4?=
 =?utf-8?B?SkJtL0JxWTZmM25INjEzWjRQMHJsTU1xNTUzWGwzcEZsbXA0ZkVFSStKS0x5?=
 =?utf-8?B?OGZ2KzlIcG1OV2R5Yjd4MHdFU2d5dVlYRHdZakJ6Vkk4RGV0ekV6MnhLS1Jz?=
 =?utf-8?B?M2g0Y1pHK3cxYUtKSkNIVnZiWlR1SWVWRHhOZmRBQWpoTEJ3ZXR6eG1NUmJj?=
 =?utf-8?B?dkhUQ3ZLVGpPK3Fwd3FQKy93ekxpNTI5a3gyUGFiMGRHcVRIOVFnYktrbnJ1?=
 =?utf-8?B?VU53VlludE9CRkR1NEtUWHQ2cDlKQkRCVnFEMjRlUjhxQUowM1dRYXF0UWk2?=
 =?utf-8?B?ZGd6MWwwNGR4SS9LMTIxSTZzMEtRai9XamlWZnI2djNCV0ZoU0JCZXh4UFV1?=
 =?utf-8?B?VTdGWlZ0MHJaUzBhTEloZkxtSnNCZzZvbjBSRDhWTW5ERHNCTFFiWW5BdG03?=
 =?utf-8?B?dmZkcFh5L1kwaVNsMjdtOWh1MXppd2tnTkNQTmtQWnNQQXViQTA1cHQzNzZh?=
 =?utf-8?B?dzNqSzFrZUN4aFNTelR6VGh5Z25CTEZWNHlzT0xMVU1NZkRXRmdYSXJLNHVo?=
 =?utf-8?B?VWRMM1pVM1cwVUI5V2MwR1ZqSWRvOTVPZzhZejhRL2NBTzNxNitoN0x2N05M?=
 =?utf-8?B?c1FXeHVreVpwM3ZaZ05heHAyMW8yT3JmNEZNczliY2ZxWG9MWnRMU3RQRlVO?=
 =?utf-8?B?bGR1ZlBjK1kvYVhpYlU5dHB1OXg1MVlIVW5ZMG9BOVpNeDlhc2hNZnJaTEUy?=
 =?utf-8?B?RzQxMGMzaW5LVUR5QUFrUnhkRmdscUdpRFE2UmJ4MVJBRHBFVVhEc3pnbFJw?=
 =?utf-8?B?ejJ5ZGx5N1V3NTJENmwvZzVXS3pteWpkMWpQbXMzczRmMGE2Um9PNjYvZWFE?=
 =?utf-8?B?OWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7411D9F5000E4499DAEBD4D9FAC23FB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4eb2c86-584f-4f1b-b55f-08daf524b75b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2023 05:12:06.9902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vxUeSjVUfAWCAuvplv+BYvTtHiIE280hmOcFXEvQbeN68YJPD7ee+p1jgE5nk0YYXQgZN2utVIfIbKmL5gYpihcsnNSHztHrsnGl9AjGGps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6702
X-OriginatorOrg: intel.com

QSBuZXcgbmRjdGwgcmVsZWFzZSBpcyBhdmFpbGFibGVbMV0uDQoNCkhpZ2hsaWdodHMgaW5jbHVk
ZSBjeGwgcmVnaW9uIG1hbmFnZW1lbnQgdXNhYmlsaXR5IGltcHJvdmVtZW50cywgZnVydGhlcg0K
Y3hsLWxpc3QgcmV3b3JrcyBhbmQgZW5oYW5jZW1lbnRzLCBzdXBwb3J0IGZvciBSQ0ggdG9wb2xv
Z2llcywgYSB1bml0IHRlc3QNCmZvciBYT1IgYXJpdGhtZXRpYyBiYXNlZCByZWdpb25zLCBhIG5l
dyBjeGwtc2VjdXJpdHkgdW5pdCB0ZXN0LCBzdXBwb3J0IGZvcg0KbWFzdGVyLXBhc3NwaHJhc2Ug
cmVtb3ZhbCwgcmV0cmlldmFsIGFuZCBkaXNwbGF5IG9mIENYTCBkZXZpY2UncyBhbGVydA0KY29u
ZmlndXJhdGlvbiwgYW5kIG1pc2MgdGVzdCB1cGRhdGVzIGFuZCBidWdmaXhlcy4NCg0KQSBzaG9y
dGxvZyBpcyBhcHBlbmRlZCBiZWxvdy4NCg0KWzFdOiBodHRwczovL2dpdGh1Yi5jb20vcG1lbS9u
ZGN0bC9yZWxlYXNlcy90YWcvdjc1DQoNCg0KQWxpc29uIFNjaG9maWVsZCAoMSk6DQogICAgICBj
eGwvdGVzdDogYWRkIGN4bF94b3JfcmVnaW9uIHRlc3QNCg0KRGFuIFdpbGxpYW1zICgyNSk6DQog
ICAgICBjeGwvdGVzdDogU2tpcCB0ZXN0cyBpbiB0aGUgYWJzZW5jZSBvZiB0aGUgY3hsX3Rlc3Qg
bW9kdWxlDQogICAgICBuZGN0bC90ZXN0OiBNb3ZlIGZpcm13YXJlLXVwZGF0ZS5zaCB0byB0aGUg
J2Rlc3RydWN0aXZlJyBzZXQNCiAgICAgIG5kY3RsL3Rlc3Q6IEFkZCBrZXJuZWwgYmFja3RyYWNl
IGRldGVjdGlvbiB0byBzb21lIGRheCB0ZXN0cw0KICAgICAgbmRjdGwvY2xhbmctZm9ybWF0OiBN
b3ZlIG1pbmltdW0gdmVyc2lvbiB0byA2DQogICAgICBuZGN0bC9jbGFuZy1mb3JtYXQ6IEZpeCBz
cGFjZSBhZnRlciBmb3JfZWFjaCBtYWNyb3MNCiAgICAgIGN4bC9saXN0OiBBbHdheXMgYXR0ZW1w
dCB0byBjb2xsZWN0IGNoaWxkIG9iamVjdHMNCiAgICAgIGN4bC9saXN0OiBBZGQgYSAnZmlybXdh
cmVfbm9kZScgYWxpYXMNCiAgICAgIGN4bC9saXN0OiBBZGQgcGFyZW50X2Rwb3J0IGF0dHJpYnV0
ZSB0byBwb3J0IGxpc3RpbmdzDQogICAgICBjeGwvbGlzdDogU2tpcCBlbWl0dGluZyBwbWVtX3Np
emUgd2hlbiBpdCBpcyB6ZXJvDQogICAgICBjeGwvZmlsdGVyOiBSZXR1cm4ganNvbi1jIHRvcG9s
b2d5DQogICAgICBjeGwvbGlzdDogUmVjb3JkIGN4bCBvYmplY3RzIGluIGpzb24gb2JqZWN0cw0K
ICAgICAgY3hsL3JlZ2lvbjogTWFrZSB3YXlzIGFuIGludGVnZXIgYXJndW1lbnQNCiAgICAgIGN4
bC9yZWdpb246IE1ha2UgZ3JhbnVsYXJpdHkgYW4gaW50ZWdlciBhcmd1bWVudA0KICAgICAgY3hs
L3JlZ2lvbjogVXNlIGN4bF9maWx0ZXJfd2FsaygpIHRvIGdhdGhlciBjcmVhdGUtcmVnaW9uIHRh
cmdldHMNCiAgICAgIGN4bC9yZWdpb246IFRyaW0gcmVnaW9uIHNpemUgYnkgbWF4IGF2YWlsYWJs
ZSBleHRlbnQNCiAgICAgIGN4bC9Eb2N1bWVudGF0aW9uOiBGaXggd2hpdGVzcGFjZSB0eXBvcyBp
biBjcmVhdGUtcmVnaW9uIG1hbiBwYWdlDQogICAgICBjeGwvcmVnaW9uOiBBdXRvc2VsZWN0IG1l
bWRldnMgZm9yIGNyZWF0ZS1yZWdpb24NCiAgICAgIGN4bC90ZXN0OiBFeHRlbmQgY3hsLXRvcG9s
b2d5LnNoIGZvciBhIHNpbmdsZSByb290LXBvcnQgaG9zdC1icmlkZ2UNCiAgICAgIGN4bC90ZXN0
OiBUZXN0IHNpbmdsZS1wb3J0IGhvc3QtYnJpZGdlIHJlZ2lvbiBjcmVhdGlvbg0KICAgICAgY3hs
L2xpYjogQWRkIGN4bF93YWl0X3Byb2JlKCkNCiAgICAgIGN4bC90ZXN0OiBGaXggY3hsLXRvcG9s
b2d5LnNoIGV4cGVjdGF0aW9ucw0KICAgICAgY3hsL3Rlc3Q6IE1vcmUgYmFja3RyYWNlIGRldGVj
dGlvbg0KICAgICAgY3hsL3JlZ2lvbjogRml4IG1lbWRldl9maWx0ZXJfcG9zKCkgbWVtb3J5IGxl
YWsNCiAgICAgIGN4bC9yZWdpb246IEZpeCBtZW1kZXZfZmlsdGVyX3BvcygpIHNlcGFyYXRvciBk
ZXRlY3Rpb24NCiAgICAgIGN4bC9Eb2N1bWVudGF0aW9uOiBVcGRhdGUgbWFuIHBhZ2UgZm9yIHVz
aW5nICdob3N0JyBuYW1lcyBpbiAnY3hsIGxpc3QnIGZpbHRlcnMNCg0KRGF2ZSBKaWFuZyAoNSk6
DQogICAgICBuZGN0bDogQWRkICBtYXN0ZXItcGFzc3BocmFzZSByZW1vdmFsIHN1cHBvcnQNCiAg
ICAgIG5kY3RsOiBhZGQgQ1hMIGJ1cyBkZXRlY3Rpb24NCiAgICAgIG5kY3RsL2xpYm5kY3RsOiBB
ZGQgYnVzX3ByZWZpeCBmb3IgQ1hMDQogICAgICBuZGN0bC9saWJuZGN0bDogQWxsb3cgcmV0cmll
dm5nIG9mIHVuaXF1ZV9pZCBmb3IgQ1hMIG1lbSBkZXYNCiAgICAgIG5kY3RsL3Rlc3Q6IEFkZCBD
WEwgdGVzdCBmb3Igc2VjdXJpdHkNCg0KRmFuIE5pICgyKToNCiAgICAgIGxpYmN4bDogQWRkIGN4
bF9tZW1kZXZfZ2V0X2Zpcm13YXJlX3ZlcnNpb24NCiAgICAgIERvY3VtZW50YXRpb24vbGliY3hs
OiBGaXggdHlwb3MNCg0KSGVsbXV0IEdyb2huZSAoMSk6DQogICAgICBtZXNvbjogQXZvaWQgYW4g
dW5uZWNlc3NhcnkgY29tcGlsZXIgcnVuIHRlc3QuDQoNCkplZmYgTW95ZXIgKDEpOg0KICAgICAg
c2VjdXJpdHkuc2g6IGVuc3VyZSBhIHVzZXIga2V5cmluZyBpcyBsaW5rZWQgaW50byB0aGUgc2Vz
c2lvbiBrZXlyaW5nDQoNCkpvbmF0aGFuIFpoYW5nICgyKToNCiAgICAgIGxpYmN4bDogYWRkIGFj
Y2Vzc29ycyBmb3IgR2V0IEFsZXJ0IENvbmZpZ3VyYXRpb24gQ0NJIG91dHB1dA0KICAgICAgY3hs
L2xpc3Q6IGRpc3BsYXkgYWxlcnQgY29uZmlndXJhdGlvbiBmaWVsZHMNCg0KTGkgWmhpamlhbiAo
MSk6DQogICAgICBSRUFETUUubWQ6IFJlbW92ZSBkZXByZWNhdGVkIE5EX0JMSw0KDQpTaGl2YXBy
YXNhZCBHIEJoYXQgKDEpOg0KICAgICAgbmRjdGw6IEZpeCB0aGUgTkRDVExfVElNRU9VVCBlbnZp
cm9ubWVudCB2YXJpYWJsZSBwYXJzaW5nDQoNClZpc2hhbCBWZXJtYSAoMTIpOg0KICAgICAgbmRj
dGwuc3BlYy5pbjogQWRkcmVzcyBtaXNjLiBwYWNrYWdpbmcgYnVncyAoUkhCWiMyMTAwMTU3KQ0K
ICAgICAgc2NyaXB0czogdXBkYXRlIHJlbGVhc2Ugc2NyaXB0cyBmb3IgbWVzb24NCiAgICAgIG5k
Y3RsOiByZW1vdmUgdHJhdmlzLWNpDQogICAgICBjbGFuZy1mb3JtYXQ6IEFsaWduIGNvbnNlY3V0
aXZlIG1hY3JvcyBhbmQgI2RlZmluZXMNCiAgICAgIG1lc29uLmJ1aWxkOiBhZGQgYSBjaGVjayBh
cmd1bWVudCB0byBydW5fY29tbWFuZA0KICAgICAgY3hsL2xpc3Q6IGluY2x1ZGUgLS1lbmRwb2lu
dHMgaW4gLXYgbGlzdGluZ3MNCiAgICAgIGN4bC9maWx0ZXI6IGVudW1lcmF0ZSBlbmRwb2ludHMg
YW5kIG1lbWRldnMgaW4gYW4gUkNIDQogICAgICBSZXZlcnQgImN4bC9saXN0OiBBZGQgcGFyZW50
X2Rwb3J0IGF0dHJpYnV0ZSB0byBwb3J0IGxpc3RpbmdzIg0KICAgICAgbmRjdGwvbGliOiBmaXgg
dXNhZ2Ugb2YgYSBub24gTlVMLXRlcm1pbmF0ZWQgc3RyaW5nDQogICAgICBjeGwvcmVnaW9uOiBm
aXggYSByZXNvdXJjZSBsZWFrIGluIHRvX2NzdigpDQogICAgICBjeGwvcmVnaW9uOiBmaXggYW4g
b3V0IG9mIGJvdW5kcyBhY2Nlc3MgaW4gdG9fY3N2KCkNCiAgICAgIGN4bC9yZWdpb246IGZpeCBh
IGNvbW1lbnQgdHlwbw0KDQo=
