Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165C37A
	for <nvdimm@lists.linux.dev>; Tue,  5 Apr 2022 14:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649170341; x=1680706341;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sKfsu7fdzTTrl9egbINH9bBU0XBID9I/VNXXYeJ0qGE=;
  b=OY0rVeAStoQZTRAtdOfssAPD+nA3C4FAXOqGjw7hFcXIW+r0h0iHlbq1
   EDHg6O2TEeXZF1ITchshjkw9qzgLMSYEqzn5F+41/+rN6QfTDecsHx1HT
   tL1Y6NxcDkk4UkB5wRQDzepxsTwjcUwPpWiWbRmcfBO3AWWjXthUyDDI2
   CNKAz8PH2kssOFL2SxIa52Raqt1o/9hGJkCouBRD6Ry/7twajYNowRq/6
   Rmwpxb4zozF1dR2Dvb2YK1hWgbbxdQ06qvMp0cYLQfz1uzpCjdLqAWYSd
   TQ4txHH5NuvhjRMOJXR71+wSS1QvWHE8t7pxG1IA5GNYLMj1t/sLd7V0+
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="240702094"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="240702094"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 07:52:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="524024031"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga006.jf.intel.com with ESMTP; 05 Apr 2022 07:52:19 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 07:52:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 5 Apr 2022 07:52:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 5 Apr 2022 07:52:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxZrzIFUcNz+BVRQBx8p8mB2YYMn89xIWIbAlDK2VYsRTRMj6kMGRXo9w1nchFaeniZHuKLLvl4mej57lst7MeOe80gP/itifDoapCtD8mY7QlAs7xHab+RAlVV7zFS26DxZet6iOvudctSJym8wR1Nw9wjPw3jN/9Tf8AuO4iuFRSniJ9kulPNOSANFa1fOhFwkELttNDaj7W4gH/4rVSeylqg24OvFF2V5kU3/PvZ3mF+C5Ns+NTl46yF13uP7zPN0i2p+soA6Api9lijp7oNa3KE3UyBwjbgWjFoeNnIvhhAUSe+NsaTRQVWy9uH/FRy+42vIybtznS68cuO+zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sKfsu7fdzTTrl9egbINH9bBU0XBID9I/VNXXYeJ0qGE=;
 b=QawvcfIuD2Npitp3wc9NDw2meqg16hUIZVIMBT0Et4mTlfS6Y4eQopVXNT2JTDJvIoUc/q0FAcbEPqX8FKcFR+NReHtDatqPhhOwDLJ3yT5cjtNfk5Pfv5mif416aRXAEuNiCn0wA70owrltMJqjNdF1LoAIQdPjcvKOHuIr5rFXZeZtpafbnw+NRBgb4wYzJJLA+40R6x29Z4adVc0u7+L8IMcr8UEGx8suetJUvGkx8e2RlLbEcd0OMPrzXqZbpilEw/V9V2YoUyfRhCql3rnhIjksKLUSukFTeYpI1q6llvgSbBpVArI8HuqM1FzGEwvPu5g5aPdZnwY///GOwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by CH2PR11MB4453.namprd11.prod.outlook.com (2603:10b6:610:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 14:52:16 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::41a:5dd4:f4b3:33cb]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::41a:5dd4:f4b3:33cb%7]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 14:52:16 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "kjain@linux.ibm.com" <kjain@linux.ibm.com>
Subject: Re: [PATCH] tools/testing/nvdimm: Fix security_init() symbol
 collision
Thread-Topic: [PATCH] tools/testing/nvdimm: Fix security_init() symbol
 collision
Thread-Index: AQHYR9LeDxr9csP6yUWLgnM9gnxan6zhadSA
Date: Tue, 5 Apr 2022 14:52:16 +0000
Message-ID: <a633334e7c4d3ef175f793ad88e75d9b5fbce927.camel@intel.com>
References: <164904238610.1330275.1889212115373993727.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164904238610.1330275.1889212115373993727.stgit@dwillia2-desk3.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.4 (3.42.4-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d449066-4924-4868-cf6e-08da1713e092
x-ms-traffictypediagnostic: CH2PR11MB4453:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <CH2PR11MB445328D017AD4B47DD270111C7E49@CH2PR11MB4453.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KcTK5du+FZUm3dSUhkS6M8Vpkz97o9320UI/h9yeNJ6lz3tmuo7jfYYtYvaScCOufdYLRyFcLWf417kEjM49xtbPTSBA0qFc0QF++05eYleeA9YvNem31RftrzGfSRdsRGWI62f1N3CF4WaO0PnRVwDEKCasRlLXnTLWnxGSbAJydmtGKwatuzZpwJRHYHahUvQe96bB+rkZEGcTH2WMtGFQrMV1rlYpotTA3PINpqu+1zt+jnd3kp/+4rVt6TAhWGvIj9D9amW2U7XlFG9VW1o8JBn3BlVDJ54pCpGbvPblkD680iSOrdaRTkNV1fA+wER3MjmwhLCY3SyRILcZuDc146JDw5wEW/6vRbGCmRWkhQ5AEhjFKB6D9qRalFtsESfM2KHTxOmKVTPw2UTx1L9/sF7AhFG2YtAaBwXeAk3sNnNpmufoxMznZqOPe24TNIMP+DEOqtLJTxImJf097Vzb0BIKlWVH0IIT9lVPvd8hRMRAhc2QZOJEqm8DKkyD8T7XNVStECezFpPhejRiAb7ffQFaKz+tWVn9q2nT8FX9eC8j1mfUny+Tehi7nE0mlLXlJeqybQXDfGLiZ5/5fWwCBpxlF7WzLuo2ix1D3XhgoFSkKkAju02Ce6fCu3aeeaHGG0WD70jVQo11lNE7L9bfrDfFBxZ3VTECExowbkWte1bL0LC+Uu5z300q7rFRE5nHCOZ7kG+7nFXtj6at8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(86362001)(15650500001)(5660300002)(38070700005)(2616005)(8936002)(122000001)(82960400001)(2906002)(186003)(6486002)(508600001)(6506007)(66946007)(66556008)(66476007)(66446008)(64756008)(71200400001)(110136005)(4326008)(8676002)(91956017)(6512007)(316002)(76116006)(83380400001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0hVTmdObkMzRWtTc2pOcHQxWlBNMmNweUFWSlVnWUhabFR4TjJvT0FjVEZY?=
 =?utf-8?B?K2xORmpFUUxKVUJoTUEzVFFyK05QcDVFbng0TkRvQWgxUlFZQjRJWHRGcENT?=
 =?utf-8?B?RnBIVkZyS2FqNVBSL3JzeWZyRTltVFc1c1gzK1d1UlowU20zcGhPOUtFZVQ2?=
 =?utf-8?B?eTk3K0ZPQnlBNDhzWlEyekVzTTJtbU0zV0J0TlYxQThxTVRiZEVZakJmUnh0?=
 =?utf-8?B?TEM3TmFRZ2tiRE1VM2E2eW1PQlFiaHh5Zy93cDRCQ2pOMlYvN1BuV2ZDZGpV?=
 =?utf-8?B?dnpob1dxNDNGOC9PLzBFUzRIeFRVVVNSZFJsQzlwaEIyb202MXNIeVJTRnhO?=
 =?utf-8?B?d1BpVFpHOWVPd1AwcUpQY2cyQUsvaUFYZTIyYTRjenU4ODlGVVZrTVQ2V1JF?=
 =?utf-8?B?NUtvY01KM0dGcngrRHhYK2pCS1VRUjRPRDVmemt5Y3k2STJncEZodG9hM0JX?=
 =?utf-8?B?YzJtVWFwMjdsdzJlTk9OcGl3LzBRMWtNVnJrWlFMbzRKVWorNUhaU2Fjc09G?=
 =?utf-8?B?UWlpckdVcHQrT3ZveThFTEsvMmVaSHlIM2JtMThsY2NmZzJYK2JyU01sMHgy?=
 =?utf-8?B?K29sODlSWmNQeUcwei9yOWNuY2w4L2lsRXZhdVlUdFYwT3FyZHltS2Yrd0Jn?=
 =?utf-8?B?cGF5ajF3clJyMnkyRVZHbmgwYmtRV1JyWWYxSTB6bDF6R2FFbUtCODQ4RW5P?=
 =?utf-8?B?VHVDSkdzL2VUblY0b2xXclVBN2VPU1VHdnpFc3FvYXpKd3ltTThBVkp3aUcw?=
 =?utf-8?B?Z1ZOVjdDb2hNVXRFZHQ5VEYrRWhjOXNUR2ZtZ2ViNDd2VWJETXluMUkzalhN?=
 =?utf-8?B?cS9CQ3d5RW82enlhUzR3NjQ2QktPVExFT0U5UElFby9laXNqcEQyeEgxcnZG?=
 =?utf-8?B?M2RNbUtHVE41RWpjd3pZUm55Q0NabnRLbDlrTUNLd3FtSENUandNY2hCTkwv?=
 =?utf-8?B?OTN2bUNkZjM3NUppTTRYYWRnRi9mWHI4ZldXa21hWWhXbk5VQkJtRnY1TkVw?=
 =?utf-8?B?SnN1ZFcya0ZQTzdUQmhybTZqTThPbUFnZ3Z1OHZYV3NyWDFKQmk0anMxSjIy?=
 =?utf-8?B?RXVrNHN1TVFRU2hKNUh1Uk1nQmJTUEpUeVArYUZrU3oycHBoUytuRzBvaGJ4?=
 =?utf-8?B?OHVlejBxWWNkTEdyR2NvTVFlbTQ2OUl0ejg4ZTFhS0V1am9rL2JiRkJEbFNZ?=
 =?utf-8?B?ZUtmL2pncDJFeEw4cWJUS1NtK0gwWm1JMnhDUmRKVUhGdEsyRUZSbXhPSXZJ?=
 =?utf-8?B?bW5jWW90UVZoMkRyMVQ0elkwR1hXdDlRdHRKSnY5QzhBOWE4M2pHRHdUTzdW?=
 =?utf-8?B?UXAzZjVFaGg3c3d5UWVuWlk0ZG0xeTlRRXNGbm1EWERabnFvUE5ua3FMVk9R?=
 =?utf-8?B?U0x4NzQ0dk1qY2hRN2E0RndlUUtESUxDcGRCOWpCYWprVHJ2ekNMOE9KcXV1?=
 =?utf-8?B?em1BeDJOeUdGWFlWY3NYdmVjSE0wS1hselZmMCswT1luZ1hEenkxemdtZUVt?=
 =?utf-8?B?VWhoMEdmbXMxdTlHejNidjZnOWJCMWhBdVpCRlF5UkVnMkhuZ0daOXpXMzJF?=
 =?utf-8?B?bk9ISUkzbW9tcW01Ym9qZ2p1cFc0UEdtQmJKTGdFUXRrYncvWUpVb0JkbFB3?=
 =?utf-8?B?bXpsQU05T0dsUE1BYmNpMFdxWTBPOWd5Z0pJNXVpVG5XdTBQOGtCN3d1OWpY?=
 =?utf-8?B?UTEyU1N4NFg2T3VMNVVPNHMxbTJ3WmRtRFZVdXdQNlVKR3lFMXRDY2dsWFJX?=
 =?utf-8?B?by9RbEtjZ1N1N3k3VnJJN1dQZnZzNEFHSTNscnl3bllocGU3TFpqSGYvVjZ0?=
 =?utf-8?B?NDRSZStCUFpObjRTclpjVytOU1hNLzhnWitHU084dUNlVXdxMVRZbHgwdFRR?=
 =?utf-8?B?TlJBRGJuNnovUmZNcGVLWlNISENsVlZLcW43RFlIVzhpRXYvQ2hKMU5EbVkz?=
 =?utf-8?B?THpJMkczWFh5Z2V2OGxwQUl1RjN6RnFPQXBkU25LVjYrRVJmTTR2ay9meW1P?=
 =?utf-8?B?Mmx5VnV3ZnBicm5xMlhrZHVVbVdQUGhyTGFlRkVRV1BheFRtWHg4T3l6SlVw?=
 =?utf-8?B?QTBwYmpIV2dBa3BrS0RzaDFCVldmcHh0YmhBUExXbGtiZ3IxemhuL0FrVTdh?=
 =?utf-8?B?US81aHVLWlJwZmx5ZTlvQ0RhdnFGYkYxOFZWdVdwRGY2eW4rb21sQkNtbnB4?=
 =?utf-8?B?RlZYVktoVG52YnByNnZvNnhwc0JaZTZ0eUJFWUJSazBjVkpDZVRua0lkS3pF?=
 =?utf-8?B?VldDM25ZK2F0MXFKZ2JrMFhvYVBmWXlub0FLM0VIdE1rRytGMDViUFF4d3dr?=
 =?utf-8?B?enhxM2d3TDk4NnBoa2xBdDBYakFkdWdVVGdkNElHZlpObDkyeWxsMStRdWFz?=
 =?utf-8?Q?pbQ027pEfKXT0Z5uxH2tpHA/OuSkWCGysrqAz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <13C231A58DCF094391BFC015A75B64E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d449066-4924-4868-cf6e-08da1713e092
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 14:52:16.5412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ux9hrMbIVZHu9YxdpEvB8BSOoDPzKtTErW0FTu/Dsb0DschkAq5FguCZ8gBVWjXE0pdpBWHwNPV+1C9MMVW03jkcf7PbHqqDhBL1D86yRSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4453
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDIyLTA0LTAzIGF0IDIwOjE5IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFN0YXJ0aW5nIHdpdGggdGhlIG5ldyBwZXJmLWV2ZW50IHN1cHBvcnQgaW4gdGhlIG52ZGltbSBj
b3JlLCB0aGUNCj4gbmZpdF90ZXN0IG1vY2sgbW9kdWxlIHN0b3BzIGNvbXBpbGluZy4gUmVuYW1l
IGl0cyBzZWN1cml0eV9pbml0KCkgdG8NCj4gbmZpdF9zZWN1cml0eV9pbml0KCkuDQo+IA0KPiB0
b29scy90ZXN0aW5nL252ZGltbS90ZXN0L25maXQuYzoxODQ1OjEzOiBlcnJvcjogY29uZmxpY3Rp
bmcgdHlwZXMgZm9yIOKAmHNlY3VyaXR5X2luaXTigJk7IGhhdmUg4oCYdm9pZChzdHJ1Y3QgbmZp
dF90ZXN0ICop4oCZDQo+IMKgMTg0NSB8IHN0YXRpYyB2b2lkIHNlY3VyaXR5X2luaXQoc3RydWN0
IG5maXRfdGVzdCAqdCkNCj4gwqDCoMKgwqDCoCB8wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF5+
fn5+fn5+fn5+fn4NCj4gSW4gZmlsZSBpbmNsdWRlZCBmcm9tIC4vaW5jbHVkZS9saW51eC9wZXJm
X2V2ZW50Lmg6NjEsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZyb20gLi9p
bmNsdWRlL2xpbnV4L25kLmg6MTEsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGZyb20gLi9kcml2ZXJzL252ZGltbS9uZC1jb3JlLmg6MTEsDQo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGZyb20gdG9vbHMvdGVzdGluZy9udmRpbW0vdGVzdC9uZml0LmM6MTk6
DQo+IA0KPiBGaXhlczogOWE2MWQwODM4Y2QwICgiZHJpdmVycy9udmRpbW06IEFkZCBudmRpbW0g
cG11IHN0cnVjdHVyZSIpDQo+IENjOiBLYWpvbCBKYWluIDxramFpbkBsaW51eC5pYm0uY29tPg0K
PiBTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4N
Cg0KTG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVy
bWFAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiDCoHRvb2xzL3Rlc3RpbmcvbnZkaW1tL3Rlc3QvbmZp
dC5jIHzCoMKgwqAgNCArKy0tDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL252ZGltbS90
ZXN0L25maXQuYyBiL3Rvb2xzL3Rlc3RpbmcvbnZkaW1tL3Rlc3QvbmZpdC5jDQo+IGluZGV4IDY1
ZGJkZGEzYTA1NC4uMWRhNzZjY2RlNDQ4IDEwMDY0NA0KPiAtLS0gYS90b29scy90ZXN0aW5nL252
ZGltbS90ZXN0L25maXQuYw0KPiArKysgYi90b29scy90ZXN0aW5nL252ZGltbS90ZXN0L25maXQu
Yw0KPiBAQCAtMTg0Miw3ICsxODQyLDcgQEAgc3RhdGljIGludCBuZml0X3Rlc3RfZGltbV9pbml0
KHN0cnVjdCBuZml0X3Rlc3QgKnQpDQo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsNCj4gwqB9
DQo+IMKgDQo+IC1zdGF0aWMgdm9pZCBzZWN1cml0eV9pbml0KHN0cnVjdCBuZml0X3Rlc3QgKnQp
DQo+ICtzdGF0aWMgdm9pZCBuZml0X3NlY3VyaXR5X2luaXQoc3RydWN0IG5maXRfdGVzdCAqdCkN
Cj4gwqB7DQo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgaTsNCj4gwqANCj4gQEAgLTE5MzgsNyArMTkz
OCw3IEBAIHN0YXRpYyBpbnQgbmZpdF90ZXN0MF9hbGxvYyhzdHJ1Y3QgbmZpdF90ZXN0ICp0KQ0K
PiDCoMKgwqDCoMKgwqDCoMKgaWYgKG5maXRfdGVzdF9kaW1tX2luaXQodCkpDQo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FTk9NRU07DQo+IMKgwqDCoMKgwqDCoMKg
wqBzbWFydF9pbml0KHQpOw0KPiAtwqDCoMKgwqDCoMKgwqBzZWN1cml0eV9pbml0KHQpOw0KPiAr
wqDCoMKgwqDCoMKgwqBuZml0X3NlY3VyaXR5X2luaXQodCk7DQo+IMKgwqDCoMKgwqDCoMKgwqBy
ZXR1cm4gYXJzX3N0YXRlX2luaXQoJnQtPnBkZXYuZGV2LCAmdC0+YXJzX3N0YXRlKTsNCj4gwqB9
DQo+IMKgDQo+IA0KPiANCg0K
