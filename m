Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111917E
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657832137; x=1689368137;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=swszMnV7Y4NSj3i6ytzn7A7El1oq/azRuAO/A9xPuhQ=;
  b=IGcCv5VyafhYcjL2W6qChtShzPHLx9gVhvj/gMXlEj8B136mldSnJe4q
   EvY/Kgvxn7U6rv9R3RKXtOKZrCTYI9mFsxEa+3FMaWGQxMQ4mM+Zc5rha
   DLd1S3pW819oPuh6BgzM8bSQ9FMAvIY6qmgT7oGxkHuU2OkJ5EnUVWKAg
   EnorWX4oimZQbVbt7KF6hRydzPwKc0SFdwMWFSAlN2CmdB1PU00bVh1Qq
   s7uhh7NPmb6f0Jc/S3zdoI6Z4iZOhpsgLpO6KQ1D6UJOQ6QH5Wt8pCIUx
   l3gLg4KV6qPTrC5yxD01OH5KU1KnNIrXruXj5SPf24rCA/OJ1550zPU8p
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="284383636"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="284383636"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 13:55:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="654034873"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jul 2022 13:55:36 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 13:55:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Jul 2022 13:55:36 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Jul 2022 13:55:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOhuKbMQKfn3353g/vaWH225WrM4/IRBTiD3vSps9tpKUSbby+kOHsPpWK6Uvh/ybNM0MSCzGNV8GQiCF96gOO4PyrGSYVh0NwHc2NFnVubMfXtX99kP9zIqcZtLnq7gmdS5sBwv5vcXp8eaWikzrd10ZbfNl278A175FkQe0sT0y9FegHnxmUpTxYs4lIWpxOHHfXHa/IXzlt/doKb4/Im9cdvijEsiie4ueO8CrrG7IocX87u1+wHAyzS9j8xwkDYxNrq9B9+AFGCW9DMStWcu5CZZVXee0M9Ff/f6H0f99myVHAGVO0LMyD3WXwwB04/O9PIJDiHIoX7HD3COFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swszMnV7Y4NSj3i6ytzn7A7El1oq/azRuAO/A9xPuhQ=;
 b=GPHrNAc9zKl96mQUGzNpCE0mED5I/Mcqgvcj2ILtOipdVgz6+r3S0BFpQNY+IJeKRWEO60Uj7muwO0PIXndJmxcGZjPcAjJWMEWI7r2DJ8WYtF4eRxEV5bftNe7tJrH8CN9L5ImO962A/r/VsaCyOq0fBNT7GMbHjf8+ClAc3uFOZAxUbx/w4w6irCRXlQihVpbjeEh037jBRVziDk/W24D0FtMFHL76FDdySZeqpyHpkYN+WF4OuMUyP7d4soR7IvKq39mxXymumzaexfJOS6u8N71ZTOlL/XmPGgdieJZOUCCmqoh0/quwCjKxEGDnlCaduQ6nXdrwbemuqUEYkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SN6PR11MB2669.namprd11.prod.outlook.com (2603:10b6:805:56::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Thu, 14 Jul
 2022 20:55:32 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17%5]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 20:55:32 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 12/12] cxl/test: Checkout region setup/teardown
Thread-Topic: [ndctl PATCH v2 12/12] cxl/test: Checkout region setup/teardown
Thread-Index: AQHYl6OW3WC/cACDGk64hZ3vjjgGka1+WNSA
Date: Thu, 14 Jul 2022 20:55:32 +0000
Message-ID: <43e12941e3ca6310f18ce8c336a7ad038a1a0a5e.camel@intel.com>
References: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
	 <165781817516.1555691.3557156570639615515.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165781817516.1555691.3557156570639615515.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 923a5b46-6f26-447c-caae-08da65db3111
x-ms-traffictypediagnostic: SN6PR11MB2669:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7O0WNyVqS8h2mLbSXLDx/c+yfXE5DrQiGAZGyG2flpPnjeINN1G/MNouRgbSuzsL1P3XgQ/Y7QK1u/GbdzWnMfsLoe+vTpeYRwDW3T5jjDosRroMXS5EffDw9Njyq0XUHA8Uzwc99SKofe/1ULPsKz5kjXIzwmdBXjt19I6YHoGXEDbbUsnmhlPynBRyQM7bppKtplHlQ9PlhIkPbtpk/MfGF5S8WBhosXDo3sZApYLZULROGdtvVac2Hss5kv1YFuAc94OvulRPaSU/7CHV2qvWHmeubTE6DDGHsb9KBfscPRTWRaiHEo499kTAopCqUwqHggS4weYYURhSKAajltjOpXdybuF8ELCX7hCRvPRnIqD8vqmEz7tSNCavV+WxlrJpe//P0ocOv6vBt/k9MM8QS/3GVs0FpWA4U6VFawUo0XMe/2aQxBQJBIYaHRZo4Q2Rry9p+oPCCwDrpukFmPJ8z0dFB5Lg0AePEFmdonUePmb6s7AuK+6hbVkliEZrBtNuFVp6zbtdkSe/TQtg5mu82YG9hAugU4xgyGYT8/iimydx0VeXinULLt/nFbvhEOC0e1vIFl4mUbyhAMoRxKuyNRME+AGkdsy+pgR/iliV/PJrNeG8T8ZpRFUtVnNa6sxvRCoFklAqfKWtg8o3mLCjgm85J+L4aB4SO2TzZJXe0t5C8fFGL73SCx+89ie9TrOHqQ1zb/tGeBi0A0/GliUlqW/gqOe4VO7Fyxt83Z+Yg5cBj7UpZXYtjy24r2mgl600rwFOzXCe7YV5F4IyOKYE6M1YDSW5v4hILHGbt2RWptplbgEt4MWhmwxWW9fs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(396003)(39860400002)(346002)(376002)(38100700002)(38070700005)(6636002)(36756003)(2616005)(6506007)(66556008)(122000001)(8676002)(64756008)(66446008)(66476007)(76116006)(86362001)(54906003)(316002)(82960400001)(71200400001)(37006003)(66946007)(2906002)(6486002)(478600001)(26005)(91956017)(186003)(8936002)(6862004)(5660300002)(4326008)(41300700001)(83380400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnNNamJaUElkOG9WRS9CRHVDR3RxZDBKTU5zdjVpeExaOGZKN1BHUDdDajV2?=
 =?utf-8?B?ajMramsrbEwvYmxHbzd2bHZqOU9jTFE2dXhJNkpmbGFxMzdHOTBPS1RMbWJI?=
 =?utf-8?B?d1l1MmxUUkMzSHBJWUxqcXZCTXBwNHB1ZE4zbzdmMnU2UDVkSVFINnhjTERZ?=
 =?utf-8?B?R1RKbGJWZFgrSXVXajd1eTc5YzEwRXlqVE1UVVZ3d2ZlQ3gxOSt0Uk9GSVZD?=
 =?utf-8?B?N0NCSjVickJJOFQzdm5QN2lHMmU3QmNuQ1RCTE5DQy9iSTFUMSsyUmRlT092?=
 =?utf-8?B?cWQvTVVaa1hIUlFYYXJDSlFlY0JqR3BlYmFXUUg2RjBQTmNoQ09VL0FCQlBS?=
 =?utf-8?B?blBUMm5ZYVRVckgrdE1uTnVMTWFLWVJIb0pLZzMwL1Y3dVk4RnJCYzFjNk5I?=
 =?utf-8?B?Ukg4NC9QOE05TW5lazN0RWlYVFpVVE1jV2RGV1NlR1puQ3JxZUhuaG1OMmhj?=
 =?utf-8?B?MnhpNjlRMUg1a1d0cUQvb2lVOFpPMDFRL0NMTmNhQktVU0ZsYUZDYmg2RjR5?=
 =?utf-8?B?ZVNRUDNFSXNlYXRDaDZwSjJRSDVzVU1GRngyY3RWdExBVUZIQm01VTZMVUJZ?=
 =?utf-8?B?NWp1ZzBucWVCYlhMNFF6dEdwTys5SDVRUUJvQ201UWhsZG42VCtsZytZbE9I?=
 =?utf-8?B?ZCtrb0VDWTQyRkExeUhwczY0MnRQQlMzVnFObjljVnJta3BveHE5RnNOSXlu?=
 =?utf-8?B?MVRURFkwTFJlS1Z0bE1UekZ1KzFtMDhycHVQWkxBUkh5L3FmeUZwV3V0SElM?=
 =?utf-8?B?dGpWMmVlR3J4KzU5VlBNQUpHZ2RWVXJjcm9QY2xkYkU2c3BpaTRuSUZmRzVi?=
 =?utf-8?B?clR2V09ucVlkeXNRUHN3WFBnWUNKbjR5SVZ5bXhaSjh2L2c2NmVCT2QxWVkr?=
 =?utf-8?B?Uy9oUGNLTGhiWG9wakNWR0dSR1lHSlBGRi9pcjZNRkNMY0tXVWlVTXRsRXUv?=
 =?utf-8?B?cktSUXVHNVNIaFlsZGFVdjJ4bGUrWDgwaVJHaDQ3djdyd3k0VjBkUHFJVlFo?=
 =?utf-8?B?aVpiekc0TG4waXNwbCt3T2xZWVZaUkVwZVZGSjJBS3FFaXRKVHkvY1hTNjNW?=
 =?utf-8?B?Q0RBdG9DK24xSVhzWkJSeVoyeFFHZW9CcnY3YXNyTnp3ck1Pa3IvZDkrMDht?=
 =?utf-8?B?N24wTFFtNGtUdTdITUJCQTU0Y3FlL2d6Y09zUnNiUkZTdW0vUXlTUFc4VzJh?=
 =?utf-8?B?NUVualFVb3pURlBDNTdtdFpWRitiYlptMXo4RlBSZ3QvWVJzWXEydklIdjhK?=
 =?utf-8?B?VzhNbEdPZFkwNkFMTWFxdFJZTFA3MkVkOS80dVM5RC9Nd0JmKzl5Z1pRdjVE?=
 =?utf-8?B?VUtJVG5UeEVxdjRxeVAwdDNuK3RCZFRYc0VwUmtCM1QyRzA2ejV2ZmRyd3Mz?=
 =?utf-8?B?R2xpODUrYUVaR0UyWnQxZVlGQzgrUlRpYS9wcDdsNW5VRFprQW84MWViTFdi?=
 =?utf-8?B?djRDVmpkYy9mdkNpVWFURXZsck15eTVXY2VzVWFXZjNqbUVURDhvNm5ZMU1H?=
 =?utf-8?B?QjFLM1FSUG1mZ0w5OFc2ZnlRdnpSbE1KbStNZzc1SUlyVUdSbFZqY09mRVhR?=
 =?utf-8?B?YWpJMSs1NllMRW16SjVFVGFrQnRkdndKVHBOSkhVb2JuTFBPTGJPSld3Zmpi?=
 =?utf-8?B?M3RiTkk4T24wSjFibkhLQ3pOVlJDWHgzMjZUZkxBN3cwWFJ5clNFVm9SMTBE?=
 =?utf-8?B?ZzVrVFpJcWdISk1mRFJGZncxSU5EaU1KN2VjV1M0ZTN3dUMyK0NMbDd6Z0d2?=
 =?utf-8?B?ajJhQ0xteUVMUjlzd1ErZmtnRFV4Q0M2MXNjbXA0bEtFd0FQSnBZbWs1SU1o?=
 =?utf-8?B?NmUydStLaUppeUUyRzVIaDV4alFxTWxaYS94Y2JMSmgrTHBLU1FZbm1TUC91?=
 =?utf-8?B?TEV2NnBGRGYwbTZ1QUVySlJ5U2hBeXhTbWludDNjYjRKUVd3Z3FuWkFueFpT?=
 =?utf-8?B?NWhZSzJOS0d0MlBlMms3K2FGSnZFWXcxWVcrU2w4RXd3NGtrSTN2dkFhNE9s?=
 =?utf-8?B?VmE2U2ZxcWp2YUxUUFhUMDZuYjZYVlBjenptN3VaQWZZM1ltOFN6Y1daYTVM?=
 =?utf-8?B?ZTNFYW9ZR09NODdkdEphVEtyYkJWMm03ZFlHdmVabHE5aUF0K0QycWZad3VR?=
 =?utf-8?B?VmdacW5HL1RHR1ZlbFlReDBidEViVXBjb3pzV1hkWlNmTDlZYXVkcnZscTcv?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAF277BEA47D7349BC48DC78DB669D8C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 923a5b46-6f26-447c-caae-08da65db3111
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 20:55:32.1683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /LxLjQO26/Lue3gTDaEqcXAUOwqX6mSeIlVaML6e6wBGfEE1jBYlZRU99O+AmFud34ggSI4KlakqvcpZZUBj9H0Gy2GAyC2h+L/KacdDApg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2669
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIyLTA3LTE0IGF0IDEwOjAyIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEV4ZXJjaXNlIHRoZSBmdW5kYW1lbnRhbCByZWdpb24gcHJvdmlzaW9uaW5nIHN5c2ZzIG1lY2hh
bmlzbXMgb2YgZGlzY292ZXJpbmcNCj4gYXZhaWxhYmxlIERQQSBjYXBhY2l0eSwgYWxsb2NhdGlu
ZyBEUEEgdG8gYSByZWdpb24sIGFuZCBwcm9ncmFtbWluZyBIRE0NCj4gZGVjb2RlcnMuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4N
Cj4gLS0tDQo+IMKgdGVzdC9jeGwtcmVnaW9uLXN5c2ZzLnNoIHzCoCAxMjIgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiDCoHRlc3QvbWVzb24uYnVpbGTC
oMKgwqDCoMKgwqDCoMKgIHzCoMKgwqAgMiArDQo+IMKgMiBmaWxlcyBjaGFuZ2VkLCAxMjQgaW5z
ZXJ0aW9ucygrKQ0KPiDCoGNyZWF0ZSBtb2RlIDEwMDY0NCB0ZXN0L2N4bC1yZWdpb24tc3lzZnMu
c2gNCg0KSGkgRGFuLA0KDQpUaGlzIGlzIG1vc3RseSBsb29raW5nIGdvb2QgLSBqdXN0IG9uZSBu
b3RlIGJlbG93IGZvdW5kIGluIHRlc3Rpbmc6DQoNCj4gDQo+IGRpZmYgLS1naXQgYS90ZXN0L2N4
bC1yZWdpb24tc3lzZnMuc2ggYi90ZXN0L2N4bC1yZWdpb24tc3lzZnMuc2gNCj4gbmV3IGZpbGUg
bW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwLi4yNTgyZWRiM2YzMDYNCj4gLS0tIC9k
ZXYvbnVsbA0KPiArKysgYi90ZXN0L2N4bC1yZWdpb24tc3lzZnMuc2gNCj4gQEAgLTAsMCArMSwx
MjIgQEANCj4gKyMhL2Jpbi9iYXNoDQo+ICsjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwt
Mi4wDQo+ICsjIENvcHlyaWdodCAoQykgMjAyMiBJbnRlbCBDb3Jwb3JhdGlvbi4gQWxsIHJpZ2h0
cyByZXNlcnZlZC4NCj4gKw0KPiArLiAkKGRpcm5hbWUgJDApL2NvbW1vbg0KPiArDQo+ICtyYz0x
DQo+ICsNCj4gK3NldCAtZXgNCj4gKw0KPiArdHJhcCAnZXJyICRMSU5FTk8nIEVSUg0KPiArDQo+
ICtjaGVja19wcmVyZXEgImpxIg0KPiArDQo+ICttb2Rwcm9iZSAtciBjeGxfdGVzdA0KPiArbW9k
cHJvYmUgY3hsX3Rlc3QNCj4gK3VkZXZhZG0gc2V0dGxlDQo+ICsNCj4gKyMgVEhFT1JZIE9GIE9Q
RVJBVElPTjogQ3JlYXRlIGEgeDggaW50ZXJsZWF2ZSBhY3Jvc3MgdGhlIHBtZW0gY2FwYWNpdHkN
Cj4gKyMgb2YgdGhlIDggZW5kcG9pbnRzIGRlZmluZWQgYnkgY3hsX3Rlc3QsIGNvbW1pdCB0aGUg
ZGVjb2RlcnMgKHdoaWNoDQo+ICsjIGp1c3Qgc3R1YnMgb3V0IHRoZSBhY3R1YWwgaGFyZHdhcmUg
cHJvZ3JhbW1pbmcgYXNwZWN0LCBidXQgdXBkYXRlcyB0aGUNCj4gKyMgZHJpdmVyIHN0YXRlKSwg
YW5kIHRoZW4gdGVhciBpdCBhbGwgZG93biBhZ2Fpbi4gQXMgd2l0aCBvdGhlciBjeGxfdGVzdA0K
PiArIyB0ZXN0cyBpZiB0aGUgQ1hMIHRvcG9sb2d5IGluIHRvb2xzL3Rlc3RpbmcvY3hsL3Rlc3Qv
Y3hsLmMgZXZlciBjaGFuZ2VzDQo+ICsjIHRoZW4gdGhlIHBhaXJlZCB1cGRhdGUgbXVzdCBiZSBt
YWRlIHRvIHRoaXMgdGVzdC4NCj4gKw0KPiArIyBmaW5kIHRoZSByb290IGRlY29kZXIgdGhhdCBz
cGFucyBib3RoIHRlc3QgaG9zdC1icmlkZ2VzIGFuZCBzdXBwb3J0IHBtZW0NCj4gK2RlY29kZXI9
JCgkQ1hMIGxpc3QgLWIgY3hsX3Rlc3QgLUQgLWQgcm9vdCB8IGpxIC1yICIuW10gfA0KPiArwqDC
oMKgwqDCoMKgwqDCoCBzZWxlY3QoLnBtZW1fY2FwYWJsZSA9PSB0cnVlKSB8DQo+ICvCoMKgwqDC
oMKgwqDCoMKgIHNlbGVjdCgubnJfdGFyZ2V0cyA9PSAyKSB8DQo+ICvCoMKgwqDCoMKgwqDCoMKg
IC5kZWNvZGVyIikNCj4gKw0KPiArIyBmaW5kIHRoZSBtZW1kZXZzIG1hcHBlZCBieSB0aGF0IGRl
Y29kZXINCj4gK3JlYWRhcnJheSAtdCBtZW0gPCA8KCRDWEwgbGlzdCAtTSAtZCAkZGVjb2RlciB8
IGpxIC1yICIuW10ubWVtZGV2IikNCj4gKw0KPiArIyBhc2sgY3hsIHJlc2VydmUtZHBhIHRvIGFs
bG9jYXRlIHBtZW0gY2FwYWNpdHkgZnJvbSBlYWNoIG9mIHRob3NlIG1lbWRldnMNCj4gK3JlYWRh
cnJheSAtdCBlbmRwb2ludCA8IDwoJENYTCByZXNlcnZlLWRwYSAtdCBwbWVtICR7bWVtWypdfSAt
cyAkKCgyNTY8PDIwKSkgfA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGpxIC1yICIuW10gfCAuZGVjb2Rlci5kZWNvZGVyIikNCj4gKw0KPiArIyBp
bnN0YW50aWF0ZSBhbiBlbXB0eSByZWdpb24NCj4gK3JlZ2lvbj0kKGNhdCAvc3lzL2J1cy9jeGwv
ZGV2aWNlcy8kZGVjb2Rlci9jcmVhdGVfcG1lbV9yZWdpb24pDQo+ICtlY2hvICRyZWdpb24gPiAv
c3lzL2J1cy9jeGwvZGV2aWNlcy8kZGVjb2Rlci9jcmVhdGVfcG1lbV9yZWdpb24NCj4gK3V1aWRn
ZW4gPiAvc3lzL2J1cy9jeGwvZGV2aWNlcy8kcmVnaW9uL3V1aWQNCj4gKw0KPiArIyBzZXR1cCBp
bnRlcmxlYXZlIGdlb21ldHJ5DQo+ICtucl90YXJnZXRzPSR7I2VuZHBvaW50W0BdfQ0KPiArZWNo
byAkbnJfdGFyZ2V0cyA+IC9zeXMvYnVzL2N4bC9kZXZpY2VzLyRyZWdpb24vaW50ZXJsZWF2ZV93
YXlzDQo+ICtnPSQoY2F0IC9zeXMvYnVzL2N4bC9kZXZpY2VzLyRkZWNvZGVyL2ludGVybGVhdmVf
Z3JhbnVsYXJpdHkpDQo+ICtlY2hvICRnID4gL3N5cy9idXMvY3hsL2RldmljZXMvJHJlZ2lvbi9p
bnRlcmxlYXZlX2dyYW51bGFyaXR5DQo+ICtlY2hvICQoKG5yX3RhcmdldHMgKiAoMjU2PDwyMCkp
KSA+IC9zeXMvYnVzL2N4bC9kZXZpY2VzLyRyZWdpb24vc2l6ZQ0KPiArDQo+ICsjIGdyYWIgdGhl
IGxpc3Qgb2YgbWVtZGV2cyBncm91cGVkIGJ5IGhvc3QtYnJpZGdlIGludGVybGVhdmUgcG9zaXRp
b24NCj4gK3BvcnRfZGV2MD0kKCRDWEwgbGlzdCAtVCAtZCAkZGVjb2RlciB8IGpxIC1yICIuW10g
fA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqAgLnRhcmdldHMgfCAuW10gfCBzZWxlY3QoLnBvc2l0
aW9uID09IDApIHwgLnRhcmdldCIpDQo+ICtwb3J0X2RldjE9JCgkQ1hMIGxpc3QgLVQgLWQgJGRl
Y29kZXIgfCBqcSAtciAiLltdIHwNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgIC50YXJnZXRzIHwg
LltdIHwgc2VsZWN0KC5wb3NpdGlvbiA9PSAxKSB8IC50YXJnZXQiKQ0KDQpXaXRoIG15IHBlbmRp
bmcgdXBkYXRlIHRvIG1ha2UgbWVtZGV2cyBhbmQgcmVnaW9ucyB0aGUgZGVmYXVsdCBsaXN0aW5n
DQppZiBubyBvdGhlciB0b3AgbGV2ZWwgb2JqZWN0IHNwZWNpZmllZCwgdGhlIGFib3ZlIGxpc3Rp
bmcgYnJlYWtzIGFzIGl0DQpjYW4ndCBkZWFsIHdpdGggdGhlIGV4dHJhIG1lbWRldnMgbm93IGxp
c3RlZC4NCg0KSSB0aGluayBpdCBtYXkgbWFrZSBzZW5zZSB0byBmaW5lIHR1bmUgdGhlIGRlZmF1
bHRzIGEgYml0IC0gaS5lLiBpZg0KYSAtZCBpcyBzdXBwbGllZCwgYXNzdW1lIC1ELCBidXQgbm8g
b3RoZXIgZGVmYXVsdCB0b3AtbGV2ZWwgb2JqZWN0cy4NCg0KSG93ZXZlciBJIHRoaW5rIHRoaXMg
d291bGQgYmUgbW9yZSByZXNpbGllbnQgcmVnYXJkbGVzcywgaWYgaXQNCmV4cGxpY2l0bHkgc3Bl
Y2lmaWVkIGEgLUQ6DQoNCi0tLQ0KDQpkaWZmIC0tZ2l0IGEvdGVzdC9jeGwtcmVnaW9uLXN5c2Zz
LnNoIGIvdGVzdC9jeGwtcmVnaW9uLXN5c2ZzLnNoDQppbmRleCAyNTgyZWRiLi5lYjI4MTg0IDEw
MDY0NA0KLS0tIGEvdGVzdC9jeGwtcmVnaW9uLXN5c2ZzLnNoDQorKysgYi90ZXN0L2N4bC1yZWdp
b24tc3lzZnMuc2gNCkBAIC00OSw5ICs0OSw5IEBAIGVjaG8gJGcgPiAvc3lzL2J1cy9jeGwvZGV2
aWNlcy8kcmVnaW9uL2ludGVybGVhdmVfZ3JhbnVsYXJpdHkNCiBlY2hvICQoKG5yX3RhcmdldHMg
KiAoMjU2PDwyMCkpKSA+IC9zeXMvYnVzL2N4bC9kZXZpY2VzLyRyZWdpb24vc2l6ZQ0KIA0KICMg
Z3JhYiB0aGUgbGlzdCBvZiBtZW1kZXZzIGdyb3VwZWQgYnkgaG9zdC1icmlkZ2UgaW50ZXJsZWF2
ZSBwb3NpdGlvbg0KLXBvcnRfZGV2MD0kKCRDWEwgbGlzdCAtVCAtZCAkZGVjb2RlciB8IGpxIC1y
ICIuW10gfA0KK3BvcnRfZGV2MD0kKCRDWEwgbGlzdCAtRFQgLWQgJGRlY29kZXIgfCBqcSAtciAi
LltdIHwNCiAgICAgICAgICAgIC50YXJnZXRzIHwgLltdIHwgc2VsZWN0KC5wb3NpdGlvbiA9PSAw
KSB8IC50YXJnZXQiKQ0KLXBvcnRfZGV2MT0kKCRDWEwgbGlzdCAtVCAtZCAkZGVjb2RlciB8IGpx
IC1yICIuW10gfA0KK3BvcnRfZGV2MT0kKCRDWEwgbGlzdCAtRFQgLWQgJGRlY29kZXIgfCBqcSAt
ciAiLltdIHwNCiAgICAgICAgICAgIC50YXJnZXRzIHwgLltdIHwgc2VsZWN0KC5wb3NpdGlvbiA9
PSAxKSB8IC50YXJnZXQiKQ0KIHJlYWRhcnJheSAtdCBtZW1fc29ydDAgPCA8KCRDWEwgbGlzdCAt
TSAtcCAkcG9ydF9kZXYwIHwganEgLXIgIi5bXSB8IC5tZW1kZXYiKQ0KIHJlYWRhcnJheSAtdCBt
ZW1fc29ydDEgPCA8KCRDWEwgbGlzdCAtTSAtcCAkcG9ydF9kZXYxIHwganEgLXIgIi5bXSB8IC5t
ZW1kZXYiKQ0KDQo=
