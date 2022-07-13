Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA264A0A
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 20:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657743840; x=1689279840;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=a2K8EVrHjTrX27Lb7n7mICK/HGSFW12h6cXmIpi30ug=;
  b=PwWm2t7B7B43Ikf/cu4V7nWgX8kd/ooY5CxHRiFKA5Y0ahZxwW6lKV47
   pUHpP4oDmSE0NLn5h2WZa1y/6rZxvtLscjo/V3v11+tzpNNiEz53XpEtx
   6tQmaj6pEYrVinD10euM4dWDDDvynaxGKKZzsKP2c8OLqIS/GGV7OfWjQ
   PIyrBmkIuSMrm0UYyoSEGltSAakxbs66xyme4V/cNwEGmQUT91y8XH4bp
   HWO9d+E58Tdqlo4SDb2EPOskUlaxFjVdPjO/6ft1l0Ki7PirDJ4ZO/GNT
   vI95rMl6ra6LhS9hiqKEp3/aqa+lhPOFFyJCMGTufZApbnuNPQ1zegUXW
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="310982630"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="310982630"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 13:23:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="663508126"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jul 2022 13:23:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 13:23:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 13:23:59 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 13:23:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODqAdF9LkkUYsh7P3I7iOrwdsnwsdv3EgDaTvOwYOLWUPJ9OWKrRvVWM9xNSNLp9jyjlQQIc2dReVG2xQTof8k88Y4+KjMI+sUEFswPwBur3gHf2reYKwihceabvo2ChJXQdxpqCy91u6Yet7K/VKlg+3q5sDA9fKOvgknO8nvj3m9nCgH758ZUqBwkdUqsg7b6/M8Ecr87VfNdUemTuusFKQRUA/41MO/RQxT9BrqTwMw14J59BRPQiWDDLX/1aQP6hqq0kxZ7hI/6BYiPNsMLUjfWmn53x3xL00+8kpfRpJgk9FBBOii6ZIFl420QfwBlgxewC69c7pDqARm09nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2K8EVrHjTrX27Lb7n7mICK/HGSFW12h6cXmIpi30ug=;
 b=Rg8y1eIDMYqil09gTbXK1x2it3Dd07WwM36ofAhMpcnJdLca0HxEcjCBQfveRvoSsQ17o5ffK26BHKzqablf8r+j1vjSUKZDgMam2zKWQHkAP+PrjH2DTYC8vjDCj69kIQLJ4ZDY+3qxzZkJyj9N70k6R6aMxAFhZsLoUVOvO0nl1NZN/KaxCffUux3DA6wZWmarNySuy+6YSj9vrbVodRlmuQc/0mzEqgtdwxljm9sYs+OoSuTvXRo4kG5V+tjyJE/6uyjLTSM26vqcZnkwmB9MqEDg4KljK4UZiFY9+M2uJHHdnpp/Q5Fvo1fsbEi43sV4TTyR8N8qMGkInCT02g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BYAPR11MB3192.namprd11.prod.outlook.com (2603:10b6:a03:7a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Wed, 13 Jul
 2022 20:23:56 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17%5]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 20:23:56 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "dave@stgolabs.net"
	<dave@stgolabs.net>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "a.manzanares@samsung.com"
	<a.manzanares@samsung.com>
Subject: Re: [ndctl PATCH] cxl/test: add a test to {read,write,zero}-labels
Thread-Topic: [ndctl PATCH] cxl/test: add a test to {read,write,zero}-labels
Thread-Index: AQHYlo1zzd06jDszzUK5emGxgQJJ+q18pa8AgAACwYCAAA1dgIAACgkA
Date: Wed, 13 Jul 2022 20:23:56 +0000
Message-ID: <7a9108e322676fb950cde3b7ebdaacb1556aa1d2.camel@intel.com>
References: <20220713075157.411479-1-vishal.l.verma@intel.com>
	 <20220713185018.lfrq6uunaigpc6u2@offworld>
	 <bc5a8df2dc71ce95c852c64f0323f2f79cba1d29.camel@intel.com>
	 <62cf216eec5d2_156c6529447@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <62cf216eec5d2_156c6529447@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c39b82c8-0476-484d-1e07-08da650d9c80
x-ms-traffictypediagnostic: BYAPR11MB3192:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ibsppCAOelx5EojANmh7r1cIGxm2XNI86NddoFJEIHSRobLDwnwqgCJCPgaI6E70dj7nBO9JXwL9lG3o+1RjCkyOHjGhNO/W4hoDpIy1tAj/Xr91PgmbDn+G1NnP8g7tV8qz0RvBzvk+WuSaP7N8iO7pNrAFKihhKlXIDrKjS0P+kP4LHxDGEpuThhXipdlLPFhfHIlmLLcpb/uJT87n3112XxlN9ft4aDzpUayqUPIQpaqR5KvidHRhyMnP/fHPRMxDvpE/GMoPgFcfpaMqdjbhdwZ+AbMBqf95rBVh1x9ZulpsW+JMJe8KW+54tU1pyPsU/bAASdcC0ptC/KakeEKNWfBEBTOkt24ePkjo7Ha6i+mFAdXlQway4ZZIT1iefrEXBRkaVFIkVGuaYRMVvnK+hu5sjj6Njv4YodmTmombeGo7Fr7YmqOmDxv3GsvwODJgAR+os6bXzvx6HDJK9c5pDMGBa7wPmrM9NopC127gQe1tMIZRtzDya1wvSQ+C9IHnvxIKsyOw1TohBux0Ax18csZ24fwmBoE3RGbvJn9qj4DIz/rv5SQfU5SLapAscvH4OO6ewVgqQctd9w4s3InUoMH7qv4RlkLSLm7APzHjaEOi+TzY8h4mTxTjia8SYr8mwC0r1wRcK37CcV/KESM5MTg9Zgko++0NWA5n3ywctBkcPsffh2bsV2k2r32Umtf45Wv+fkV6g658CL8BvT3ICrrXV4jlmsIKQViO6KFAP6Y2ViZ9x+lv1Ewr/n7tY+kXEggoRfm7W3y7TucJAXsQ0ROx4OD4ARM6qPnu+G06n4GV/UyGmSKisMvbAUy5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(366004)(346002)(39860400002)(136003)(122000001)(38100700002)(83380400001)(5660300002)(316002)(36756003)(8936002)(71200400001)(82960400001)(2906002)(6506007)(91956017)(66946007)(4326008)(8676002)(186003)(86362001)(76116006)(64756008)(38070700005)(54906003)(66446008)(2616005)(41300700001)(110136005)(478600001)(66556008)(66476007)(26005)(6512007)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDU5YWx5dS82VzdaS2c5bDJISzFLRFlYL0djTEJOL1B6MFF6RFoxaHJCcXlj?=
 =?utf-8?B?clVUbEp0YnlxNi9VTnhqVVo2MzN2ZHY3aFBDWmQ4TFR1NTRSMHZhenlEbkt5?=
 =?utf-8?B?SFNuMEdiYnRPRTNCNkhmbUZuaHdpc0ZuaFRYSjdBamF5MDFjUlByQUJEd05N?=
 =?utf-8?B?RjR4cUZ2U2MyVnM5NldZWXNDQTU1ZTV0NmFNa1VMcC9OZzhVQzVwanlKS1Ja?=
 =?utf-8?B?eFEvaU96TFNQTlNUUzQ5emVheU9IaGovMVBMTHVNak5maFR5ZHVFTS9OZ0NS?=
 =?utf-8?B?Uk1EK0JQSlNUdHpwdFFncjgvakhabVRxNHRuZFZmUitmZ25NL2NteXZSdDYv?=
 =?utf-8?B?QkJOem9ORE9vYS9RL3MzRm5XeDhLZzNDWkRlUkw2TDJtM2dyODd1UGs2Y2hK?=
 =?utf-8?B?cEZpNFlFOTdRb2lUMHFvNXFQRmFOclRwc0EybmthaVhMZXUxS3dSL0VzNXZU?=
 =?utf-8?B?YUtOMzZVdVdaRCthVllhT2NVQ2p0dll3d1ZKc0FjSnJ3eE0zNXhDWk1kcFBR?=
 =?utf-8?B?ejZQYWRYZ2tnUDN2dGJORHdNVno3RjlrUDhKZDFWK1p2Z2g4a0JULzc4Ri8z?=
 =?utf-8?B?SU5aQkh5SUFrN0xsdVhqb1Z5dG9xNTRxNU1ucmNMNitpU0lCT3hCYjFDWmVa?=
 =?utf-8?B?QWZiaFdtM0s2eXZkelRLVXQ1cUhMTTF3c1FQMmVMWlExcFhZZVpnckdFYWM3?=
 =?utf-8?B?S1VOdmoremxaSGR6MXY1d2hZSGhaT2piSGNuNDNmUm5PNkpWQXcrMG9Hc2ll?=
 =?utf-8?B?aGdRaXhuUytJai92dmh3QTBJdlRIcTdlUUtPZFA3UUp1QzU0SE5INjZxU1Bh?=
 =?utf-8?B?MjhwcFJkWmFKYzNoOWhubG9NNHJEaU81bEtNRDF4VWlXQWREUTJxaW11blpY?=
 =?utf-8?B?aUhQZ0VncVc1cElxNmRjbldhSElXWktXNjBUSGhsSENLc1hYN0o5UjkyYVZ5?=
 =?utf-8?B?a1BkWk84cDN2L09HRVQ2M0NIdCs1aDBNVW5CMnFEa3pkbEJrN1Z4NFB2cXZI?=
 =?utf-8?B?dm5YSjg0blNzOTEyU0VSR1BDaUd4WGhiajRzdzZtM0hubnBxU0Erd2RCbDZQ?=
 =?utf-8?B?N0h5YndSdFdiT3lOSHFSK1dsM3dlbkJPZTVkQS9lMjRlaGk4VFczeVorYUpO?=
 =?utf-8?B?a1lzdHpxdmkxL2pqQVlzSWZqWVpuVHVPa0JBTERDSFN5WER6ZE4rMDNTeW1F?=
 =?utf-8?B?a1Jwc1U0eHc5aUw0SDd1NVpyNGZhMzBpclhBZ2ZrdSt1ZHVYOFRjRWNjNytL?=
 =?utf-8?B?VEl4ZldMbDdiUjRqVEVmVHU0b05DbXU0SGc5S3NGd0p1bFBQMk1Dd3M3MkVW?=
 =?utf-8?B?ZmtUU3pxaUdNa0dXdXkvdW8wRnVOdWRqRVllU3h6WHZ3S3VDcWNlWk9RSi9i?=
 =?utf-8?B?SS9odGMwV0xWSWdPNWp4TEVvSWtLNXBYRnpZQU9HSnJDUnRYQ0R5YndPQzAw?=
 =?utf-8?B?VGdGRlcxWjdEd1hiclFmbUg1NmEyR0w5Y1ROY0txSW4zeitsN3U2SmQxaHVC?=
 =?utf-8?B?ZVA4cnd2SCtwK0R6U1ZybXNGakRlUXpCQzJ0SFZaUm0xdjIrNnRqQzBuNWsy?=
 =?utf-8?B?SUhoV3dtb0Y2V3FWNUVyeGZJNEVGWFh0SEZUeWJvTk9BK1BlVUJ3VCtTSlZK?=
 =?utf-8?B?aVVFa2NvekUyOVJFSU16eVZyMEdSVHRGWlhnalV6NWdFWkk4dE9NbXIvOGNq?=
 =?utf-8?B?WW5LbW84UFAyWTcyWWh4bnU5UHJkNlZlSm9HYWRpSVRrSjNmejdadE0vWXkw?=
 =?utf-8?B?VW1qdTdPUGdCL2syZEEvQ2JxNDl2N1RHUEphdkR5cXhBQWV1WnIrNTNvanN5?=
 =?utf-8?B?SXYwQ1d1ejFCcGdEMnFzallhTy9JdzNmTjhJME5JL3M2ZWV3SnA2UDEvbkp3?=
 =?utf-8?B?ZnVTTzRaL3BhQmZNeGJzZjdVL21QWHBQNjQxcXkyOUNLcmZKaTBEVDcwWHp2?=
 =?utf-8?B?ek9FcWtMejkyQkFwY0Zyb0JHSEp5T09vc1I2djJzUzExM3ZZcGs5ekpJTk90?=
 =?utf-8?B?OVFzNVhwZExWVWJiNkwyN3FpdUllTW9ydG5YazI4YWVJZ2ZrOW1tZFBnNjIr?=
 =?utf-8?B?WDdGdEdnT3pGUzVSN2xmc05SR2ZrUnk2WW1MRzdMQ2R4MGFHNmw2WStVVUUv?=
 =?utf-8?B?Y2UrVkRzL0FZK2tqVkFKNVY0eTduUFBaRldxaUpVSlJVcEJFekxUeUZ0NDRN?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9755184C1CF6C04D95D0A7F613C13657@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c39b82c8-0476-484d-1e07-08da650d9c80
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 20:23:56.0812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k79QD9qm7+k8aP+lgoVI+Lkx0O23XdjASJNPtPZBqpHfl9lq2B8m7LMeKkytGXVkixECe7HRROnVAqBqQLWoNjalAOinhFQ4EoTTNbyPI7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3192
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTA3LTEzIGF0IDEyOjQ3IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFZlcm1hLCBWaXNoYWwgTCB3cm90ZToNCj4gPiBPbiBXZWQsIDIwMjItMDctMTMgYXQgMTE6NTAg
LTA3MDAsIERhdmlkbG9ociBCdWVzbyB3cm90ZToNCj4gPiA+IE9uIFdlZCwgMTMgSnVsIDIwMjIs
IFZpc2hhbCBWZXJtYSB3cm90ZToNCj4gPiA+IA0KPiA+ID4gPiBBZGQgYSB1bml0IHRlc3QgdG8g
dGVzdCB3cml0aW5nLCByZWFkaW5nLCBhbmQgemVyb2luZyBMU0EgYXJlYWQNCj4gPiA+ID4gZm9y
DQo+ID4gPiA+IGN4bF90ZXN0IGJhc2VkIG1lbWRldnMgdXNpbmcgbmRjdGwgY29tbWFuZHMuDQo+
ID4gPiA+IA0KPiA+ID4gPiBDYzogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5j
b20+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFA
aW50ZWwuY29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+ID4gdGVzdC9jeGwtbGFiZWxzLnNoIHwgNTMN
Cj4gPiA+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0K
PiA+ID4gPiB0ZXN0L21lc29uLmJ1aWxkwqDCoCB8wqAgMiArKw0KPiA+ID4gPiAyIGZpbGVzIGNo
YW5nZWQsIDU1IGluc2VydGlvbnMoKykNCj4gPiA+ID4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRlc3Qv
Y3hsLWxhYmVscy5zaA0KPiA+ID4gPiANCj4gPiA+ID4gZGlmZiAtLWdpdCBhL3Rlc3QvY3hsLWxh
YmVscy5zaCBiL3Rlc3QvY3hsLWxhYmVscy5zaA0KPiA+ID4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0
NA0KPiA+ID4gPiBpbmRleCAwMDAwMDAwLi5jZTczOTYzDQo+ID4gPiA+IC0tLSAvZGV2L251bGwN
Cj4gPiA+ID4gKysrIGIvdGVzdC9jeGwtbGFiZWxzLnNoDQo+ID4gPiA+IEBAIC0wLDAgKzEsNTMg
QEANCj4gPiA+ID4gKyMhL2Jpbi9iYXNoDQo+ID4gPiA+ICsjIFNQRFgtTGljZW5zZS1JZGVudGlm
aWVyOiBHUEwtMi4wDQo+ID4gPiA+ICsjIENvcHlyaWdodCAoQykgMjAyMiBJbnRlbCBDb3Jwb3Jh
dGlvbi4gQWxsIHJpZ2h0cyByZXNlcnZlZC4NCj4gPiA+ID4gKw0KPiA+ID4gPiArLiAkKGRpcm5h
bWUgJDApL2NvbW1vbg0KPiA+ID4gPiArDQo+ID4gPiA+ICtyYz0xDQo+ID4gPiA+ICsNCj4gPiA+
ID4gK3NldCAtZXgNCj4gPiA+ID4gKw0KPiA+ID4gPiArdHJhcCAnZXJyICRMSU5FTk8nIEVSUg0K
PiA+ID4gPiArDQo+ID4gPiA+ICtjaGVja19wcmVyZXEgImpxIg0KPiA+ID4gPiArDQo+ID4gPiA+
ICttb2Rwcm9iZSAtciBjeGxfdGVzdA0KPiA+ID4gPiArbW9kcHJvYmUgY3hsX3Rlc3QNCj4gPiA+
ID4gK3VkZXZhZG0gc2V0dGxlDQo+ID4gPiA+ICsNCj4gPiA+ID4gK3Rlc3RfbGFiZWxfb3BzKCkN
Cj4gPiA+ID4gK3sNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgbm1lbT0iJDEiDQo+ID4gPiA+ICvC
oMKgwqDCoMKgwqDCoGxzYT0kKG1rdGVtcCAvdG1wL2xzYS0kbm1lbS5YWFhYKQ0KPiA+ID4gPiAr
wqDCoMKgwqDCoMKgwqBsc2FfcmVhZD0kKG1rdGVtcCAvdG1wL2xzYS1yZWFkLSRubWVtLlhYWFgp
DQo+ID4gPiA+ICsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgIyBkZXRlcm1pbmUgTFNBIHNpemUN
Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgIiRORENUTCIgcmVhZC1sYWJlbHMgLW8gIiRsc2FfcmVh
ZCIgIiRubWVtIg0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBsc2Ffc2l6ZT0kKHN0YXQgLWMgJXMg
IiRsc2FfcmVhZCIpDQo+ID4gPiA+ICsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgZGQgImlmPS9k
ZXYvdXJhbmRvbSIgIm9mPSRsc2EiICJicz0kbHNhX3NpemUiICJjb3VudD0xIg0KPiA+ID4gPiAr
wqDCoMKgwqDCoMKgwqAiJE5EQ1RMIiB3cml0ZS1sYWJlbHMgLWkgIiRsc2EiICIkbm1lbSINCj4g
PiA+ID4gK8KgwqDCoMKgwqDCoMKgIiRORENUTCIgcmVhZC1sYWJlbHMgLW8gIiRsc2FfcmVhZCIg
IiRubWVtIg0KPiA+ID4gPiArDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoCMgY29tcGFyZSB3aGF0
IHdhcyB3cml0dGVuIHZzIHJlYWQNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgZGlmZiAiJGxzYSIg
IiRsc2FfcmVhZCINCj4gPiA+ID4gKw0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqAjIHplcm8gdGhl
IExTQSBhbmQgdGVzdA0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqAiJE5EQ1RMIiB6ZXJvLWxhYmVs
cyAiJG5tZW0iDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoGRkICJpZj0vZGV2L3plcm8iICJvZj0k
bHNhIiAiYnM9JGxzYV9zaXplIiAiY291bnQ9MSINCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgIiRO
RENUTCIgcmVhZC1sYWJlbHMgLW8gIiRsc2FfcmVhZCIgIiRubWVtIg0KPiA+ID4gPiArwqDCoMKg
wqDCoMKgwqBkaWZmICIkbHNhIiAiJGxzYV9yZWFkIg0KPiA+ID4gPiArDQo+ID4gPiA+ICvCoMKg
wqDCoMKgwqDCoCMgY2xlYW51cA0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBybSAiJGxzYSIgIiRs
c2FfcmVhZCINCj4gPiA+ID4gK30NCj4gPiA+ID4gKw0KPiA+ID4gPiArIyBmaW5kIG5tZW0gZGV2
aWNlcyBjb3JyZXNwb25kaW5nIHRvIGN4bCBtZW1kZXZzDQo+ID4gPiA+ICtyZWFkYXJyYXkgLXQg
bm1lbXMgPCA8KCIkTkRDVEwiIGxpc3QgLWIgY3hsX3Rlc3QgLURpIHwganEgLXINCj4gPiA+ID4g
Jy5bXS5kZXYnKQ0KPiA+ID4gDQo+ID4gPiBzLyRORENUTC8kQ1hMDQo+ID4gPiANCj4gPiA+IEJl
eW9uZCBzaGFyaW5nIGEgcmVwbywgSSB3b3VsZCByZWFsbHkgYXZvaWQgbWl4aW5nIGFuZCBtYXRj
aGluZw0KPiA+ID4gbmRjdGwgYW5kIGN4bA0KPiA+ID4gdG9vbGluZyBhbmQgdGhlcmVieSBrZWVw
IHRoZW0gc2VsZiBzdWZmaWNpZW50LiBJIHVuZGVyc3RhbmQgdGhhdA0KPiA+ID4gdGhlcmUgYXJl
IGNhc2VzDQo+ID4gPiB3aGVyZSBwbWVtIHNwZWNpZmljIG9wZXJhdGlvbnMgY2FuIGNhbiBiZSBk
b25lIHJldXNpbmcgcmVsZXZhbnQNCj4gPiA+IHBtZW0vbnZkaW1tL25kY3RsDQo+ID4gPiBtYWNo
aW5lcnkgYW5kIGludGVyZmFjZXMsIGJ1dCBJIGRvbid0IHNlZSB0aGlzIGFzIHRoZSBjYXNlIGZv
cg0KPiA+ID4gc29tZXRoaW5nIGxpa2UgbHNhDQo+ID4gPiB1bml0IHRlc3RpbmcuDQo+ID4gPiAN
Cj4gPiA+IFRoYW5rcywNCj4gPiA+IERhdmlkbG9ocg0KPiA+ID4gDQo+ID4gSGkgRGF2aWQsDQo+
ID4gDQo+ID4gVGhhbmtzIGZvciB0aGUgcmV2aWV3IC0gaG93ZXZlciB0aGlzIHdhcyBpbnRlbnRp
b25hbC4gY3hsLWNsaSBtYXkNCj4gPiBibG9jaw0KPiA+IExTQSB3cml0ZSBhY2Nlc3MgYmVjYXVz
ZSBsaWJudmRpbW0gY291bGQgJ293bicgdGhlIGxhYmVsIHNwYWNlLg0KPiA+IA0KPiA+IMKgIGN4
bCBtZW1kZXY6IGFjdGlvbl93cml0ZTogbWVtMDogaGFzIGFjdGl2ZSBudmRpbW0gYnJpZGdlLCBh
Ym9ydA0KPiA+IGxhYmVsIHdyaXRlDQo+ID4gDQo+ID4gU28gdGhlIHRlc3QgaGFzIHRvIHVzZSBu
ZGN0bCBmb3IgbGFiZWwgd3JpdGVzLiBSZWFkcyBjb3VsZCBiZSBkb25lDQo+ID4gd2l0aA0KPiA+
ICdjeGwnLCBidXQgZm9yIG5vdyB0aGVyZSBpc24ndCBhIGdvb2QvcHJlZGljdGFibGUgbWFwcGlu
ZyBiZXR3ZWVuDQo+ID4gbmRjdGwNCj4gPiAnbm1lbVgnIGFuZCBjeGwgJ21lbVgnLiBPbmNlIHRo
YXQgaXMgc29sdmVkLCBlaXRoZXIgYnkgYSBzaGFyZWQgaWQNCj4gPiBhbGxvY2F0b3IsIG9yIGJ5
IGxpc3RpbmdzIHNob3dpbmcgdGhlIG5tZW0tPm1lbSBtYXBwaW5nLCBJIHdpbGwgYXQNCj4gPiBs
ZWFzdCBhZGQgYW5vdGhlciBjeGwgcmVhZC1sYWJlbHMgaGVyZSB3aGljaCB3b3VsZCB2YWxpZGF0
ZSB0aGUNCj4gPiBzYW1lDQo+ID4gTFNBIGRhdGEgdGhyb3VnaCBjeGwtY2xpLg0KPiANCj4gSSBk
byB0aGluayB0aGlzIHRlc3Qgc2hvdWxkIGV2ZW50dWFsbHkgZG8gYm90aCB0byB2YWxpZGF0ZSB0
aGF0IHRoZQ0KPiBudmRpbW0gcGFzc3Rocm91Z2ggYW5kIHRoZSBuYXRpdmUgQ1hMIG9wZXJhdGlv
bnMgYXJlIHdvcmtpbmcuDQo+IEhvd2V2ZXIsDQo+IHRoZSBuYXRpdmUgQ1hMIGNhc2UgbmVlZHMg
YSBiaXQgbW9yZSBpbmZyYXN0cnVjdHVyZSB0byBkaXNjb25uZWN0IHRoZQ0KPiBtZW1kZXYgZnJv
bSBudmRpbW0uwqAgU29tZXRoaW5nIGxpa2U6DQo+IA0KPiDCoMKgwqAgY3hsIGRpc2FibGUtcG1l
bSBtZW0wDQo+IMKgwqDCoCBjeGwgd3JpdGUtbGFiZWxzIG1lbTAgLi4uDQo+IA0KPiBZb3UgY2Fu
IGFkZCBhICJjeGwgcmVhZC1sYWJlbHMiIHRlc3QgdGhvdWdoIHNpbmNlIHRoYXQgaXMgbm90IGJs
b2NrZWQNCj4gd2hpbGUgdGhlIG1lbWRldiBpcyBhdHRhY2hlZCB0byBudmRpbW0sIG9ubHkgbGFi
ZWwgd3JpdGVzLg0KDQpBaCAtIHllYWggSSB0aGluayBqdXN0IGdvaW5nIHRocm91Z2ggYWxsIG1l
bWRldnMgYW5kIHJlYWRpbmcgdGhlIExTQSBpcw0KaGFybWxlc3MgZW5vdWdoLCBhbmQgaXQgZXhl
cmNpc2VzIHRoZSBjeGwtY2xpIHBhdGhzLiBJJ2xsIGFkZCBpdCB0byB2Mi4NCg0K
