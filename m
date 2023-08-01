Received: from mgamail.intel.com (unknown [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433027E
	for <nvdimm@lists.linux.dev>; Tue,  1 Aug 2023 00:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690849912; x=1722385912;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=J7jvq4UC8HWD9/Hduohk1ovOiPDfZJDVpyX9Pa/6e6k=;
  b=gvfFuohZjLxatCx/qAeI9+MDZ1uuzmEm5LCT6vqaWd5J0oUFFLb/B+1b
   +nZx4B9uUFU/UJZTeqAoj136iI/k20+X6C+Gj5a0tY9wWS82lNBGH6FmE
   7jGSr9ZTqp3cbQBfiKyRw2YNiKtDMEeUVThU8fHDhlBvXBaVZD07fXI9/
   Q/7CUZWVlFO+4rjQ6T5qgioRB7vJk9+TQOZO1LkshiHfPBfjJbscjIda1
   tiN6i7uV5yk0zC3fUKsm2DgaTWw9uWM2f/jahoZ09IpK8dSdZ4k+mfSUK
   W5EBA4BLodNmlUZLCbNSZ3FNMgSpFScqy/m/7jNNBir8WBi58ngAq+cWi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="349457836"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="349457836"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 17:31:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="722292599"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="722292599"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2023 17:31:50 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 17:31:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 17:31:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 17:31:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKEW4TVECZE1y97i75rv5BUexEfTsV5rFhBYLGIZI1Rex67vtIUTftrXTy0bDOZv8SscqKNG+Vzw0wRGa1Y21NaG2InIH07eYvICtIXOZoVmBJhc+o9FvVplV9VVOBkoBdHSU0XXAGXLR1MgRd41GqUV3LtxCN1h3gYtl1LUifl5oTaJ5mHsrJKv+ax6wUDg+k8zgSvrmmYignUocfKpKZLkQyEjvXOu+t+VJY9nu+BfnzVFo3W7mdrKxKkNF7SrauujQX9fwl3nO09yfWGZS9O79eJIeWIGhVYNLwQJUVhheBy4gF/HxAI0bGi3SMda9i8ymkLXDnHJXlMvckghHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7jvq4UC8HWD9/Hduohk1ovOiPDfZJDVpyX9Pa/6e6k=;
 b=mczFKL3RqHz45W81sb4toabAYctbO87y18OyomIIIhRMFZLur3BdF+22Tng12ODIY06WpuG5cGXL2xu8RWDZRfC+z2JbfYIbwzngo2YGa0jcrDudYC3EOg+URQOlbzZtPPnqmT+uzYc0x1lGvM4vLQQFRlrRsw5DOMrrDwUMvo36Ri5ecSKb0GmN73gWMshhiKsW5RpuDpwHdcIIrqOk6paEJJoVket0FUI0RkrYlD6eAYyfnLtiX7Ue4XK7kIrR3DiY5GmB0QYzCmL2gmlKlZMYykqKtQWTiOt+tXqk8EU5sJ4tn91ARvHw4RHgAET7UQfzNy0hKYoZrCDOabp4HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SJ2PR11MB8450.namprd11.prod.outlook.com (2603:10b6:a03:578::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Tue, 1 Aug
 2023 00:31:48 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370%2]) with mapi id 15.20.6631.026; Tue, 1 Aug 2023
 00:31:47 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Weiny, Ira" <ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl v2] ndctl/cxl/test: Add CXL event test
Thread-Topic: [PATCH ndctl v2] ndctl/cxl/test: Add CXL event test
Thread-Index: AQHZxApU0ywwBfuTTk6MLx6WBLAj8a/UlwYA
Date: Tue, 1 Aug 2023 00:31:47 +0000
Message-ID: <f65ef4e6cf9c93513ee6395c835553142db602eb.camel@intel.com>
References: <20230726-cxl-event-v2-1-550f5625d22f@intel.com>
In-Reply-To: <20230726-cxl-event-v2-1-550f5625d22f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SJ2PR11MB8450:EE_
x-ms-office365-filtering-correlation-id: d751c9c2-49ee-42ba-a82d-08db9226b0ee
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z0d4F/jzA8Lj67pfoG1hH9dRrnC4oZE5YWpoVBr9bURvI2glGvq09gkPPLPTe6Ur1CcsT8NJZq10sAYUEjl6ADjwU+xLX/7gh2jP6x/UqQ6hP0hxn7puxrOQ1fqd2IkLAX+1Jiqyn2B6TbdZN10gCDHJf6SmO+pj0URSkqd5VpvOogGUtVOlfq7m4eqbLYM4G6XOZoEPe7x2WQ6C5FdKVQZjivGyWQXZ4L5lUCV5/Ndxz308s8MYRTJhdwvAsekJBnlMkKvpvVXWmi1TFta8Qk18qEebnCzG/s+7gmAnnJQg/asmPxcNoeTBXRYNY5xMpHb7lyMMxIcWh1+tebmLZNdPXNCarfbGk/AC1HKxAN37Ek8oSwQAxgEiJXJFG4MBBYENksKOKkoipusKCF8x/GgpzDoBtkGpd80cQXpdhB+7uLGqTLNjvRpc9hKvu/j3Wf4/8yINEeoymE0j0I5msqblmK5eSM3nd9LMixDpolaTTFIHBL9tenu9DgZ5WdKofxxmfD7Z3NG7b4rQgcstetwVI3IkKrSgN9es6wGiOAC7zNwyYHBzaTOF/dXgPuImxcNZtVpz6cHw6vSZRfHRs1P151/WftKAXlFehqdTmmc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(66476007)(54906003)(478600001)(186003)(6506007)(82960400001)(37006003)(966005)(26005)(6512007)(122000001)(6486002)(71200400001)(66556008)(4326008)(6636002)(64756008)(66446008)(66946007)(2616005)(38100700002)(76116006)(5660300002)(41300700001)(38070700005)(2906002)(316002)(8936002)(8676002)(6862004)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UG9YWmQ2YUV1SllkTlRIdUQ5bGxqdU1aWlRNMGYzbVBKRTRkNnJqaDg5WEVP?=
 =?utf-8?B?UTYzQzVzd0xOUVNSM1NLOU80T2VISHU0a2IzRVpPTUtzckN2QmRZQ3VSZVkx?=
 =?utf-8?B?N2FOaTY5OEFZUmRWTElBQkJudWxPMVVWOHYwVWw0RXVPd2t3SVQ2dm42Y0kx?=
 =?utf-8?B?b3A2elJ1aDhDZjFIclErK3hMUG9DN0NGN2lkN1h2UFBHeWJzNUErYnNTRVRh?=
 =?utf-8?B?UTJnenpkTkNJdzdKeUdycS93R2FVRjBHYVBiRDJ3V2JrRVhPaWZGSk9BUGZ6?=
 =?utf-8?B?UVhaR1pmTCtiZ25pTmdpVWlPaTM5S1pQaTR5RUt1emVKMUdPY2YrcXQ2aXI3?=
 =?utf-8?B?WXlYOFhiYTdvLzFXaEVTRTRnZjRqRzZ2Ky9scjYzcWUvSzU4WFYvcHM5SVA5?=
 =?utf-8?B?UExVWW96VUVBOGlrbXpjTXFxdGRWYTJ3ODk2cXg2Q3pHSVk4VFg1TGw2UEVu?=
 =?utf-8?B?K0JieE5aMnRPdlJmYUgyOEdSdzFSd013M0tZRnZzTW5aOEJXS3BSd1luZmV0?=
 =?utf-8?B?bElwZjczUFZlSGo3TkJoUWxKNjFhdWQ0N25LZjdjMk9VcDlCbDV1VXRmSmhE?=
 =?utf-8?B?aVo4WHpsS09QMU4weDViUGFvTjNXbXVLTVpaVlZwRHpTMXV6THFVOXdNKzg1?=
 =?utf-8?B?d3htbU5Xd0R4QTdJSXNRNXBMUEZ5eGFzSGt0TUV3MEV1azlvbWVGYUEvRkhx?=
 =?utf-8?B?S3p6TGFtdlR1R0VLT2d5M2FldWhrTy8vOWRrN09tQjAxVTRzQysxb3Bua0Q2?=
 =?utf-8?B?L2dkejZvZHpLc2dwT2VuUVZ0bFBtNnFJMEU0MmR0d25CczNHMXN6R1JBNU1W?=
 =?utf-8?B?bFNwdmFaT1lBRWxJWDZpMVFYUGhxbGs4NVhleHV4aGFmWDNNN2Jua2N5M3hC?=
 =?utf-8?B?a0t4WE56NHdRK3M1SmlGVW1rWTlFRWY4SU1FWlFMYWp4QkpRdUNvQkZ0bC9a?=
 =?utf-8?B?bnVqanV5NW9Cc0lwNmlJbEFHcFFmMHF4NG41WWo3Q2ExSWlBSFVRLy9YZDdR?=
 =?utf-8?B?Y3BjZ2hDRjJvT2Y0VnFvYVYyRzdTb05TMFFKai9VQWV0Qk9OWXptRnNvYTNW?=
 =?utf-8?B?QXZsUmN6UnJjSTliQ05jdXBvVEVOQ1V1Q3VSS2lBM1NIZVBiR29lbXRuS3g1?=
 =?utf-8?B?WUIrdUsrMVdyRGFkYXVnS1hra25xM0N3YzJLS2pONjdzbmhZNzF2NUZUdjU2?=
 =?utf-8?B?cHJXdVZpUzNyb3g3TFg5d3pRczluOW5XSkRzQituZ0dMNXVIWmk3TmZiQ2Nk?=
 =?utf-8?B?S3hITkVQTSt5NW1BY2QyMWhuak94aXNHcWhza1dvLzZVRlhQTFhxTlhkTHZG?=
 =?utf-8?B?Nlp0YmI2R3dnTXVOS29lQlJUc3M5NDV1OTJFNERGVmZuNzdMckVlR3lVOGhU?=
 =?utf-8?B?QkhQeHc1QUdKWm8vMDlZZ0tNU2ZRWmIzdGl0QUhJTit2ZHRVRVlsRlg5dzND?=
 =?utf-8?B?bU1VTklRUmRNbEFQTzZtN1I0ZXdFQTFBSFd6UzNxcHZZOFRVRmg2aU5EYzBp?=
 =?utf-8?B?ekE5eEF5dzRpQ0J6ZzN1WE9IamlaNkdaMU51VFlwbC84aXZ3VjFJRFNvYlRy?=
 =?utf-8?B?SlNRc1I5MHJLQnExWXVqV01jN2UzNVNydlFVcmZIdDMzSjVyam1GbDZBYVg1?=
 =?utf-8?B?NzZ0ZEpiREg5T25WNnV0eGtmdE54WXhMVko2NlhGaFJoZG5TaVNpd08yL3hz?=
 =?utf-8?B?c0I2U1pJN2dHQitQeTFTdk9YN2ZtUmdtdjZJQWd0S29iejFNdFlmUExBZlE1?=
 =?utf-8?B?NEMva0NWZkd0WWtmQ0JhV0QxckszTkh4b0FMMmF2ZW5DdXY4d05URmJuT3pO?=
 =?utf-8?B?L2pWQW5MSDY2cHpCSkNvaUJrcGRWQklTV25PbWNhdDkzcWpCOTFCajR4VmFQ?=
 =?utf-8?B?bEdPTVdKOUM1dUd6L1JaN2w0SDRYdVkySVBJRVNhYXRKRk1ibHN6a1k3dDlS?=
 =?utf-8?B?eGhFZmdoN2phd0Nvc3pLVmV1UlFQVTRkMisxVjJwQ3ExTis0Vi9Wc243THJF?=
 =?utf-8?B?eTd0ZFBGQ3B4VElDbVE5NjYvZXNWMTZqcWlhY0wxSmVEbkRzMGo0TVJ3UHV5?=
 =?utf-8?B?NjFxeVRtRnI5ZE40bnJSRzhrZEw5dWFYYVgyYlh1NllyWmxqYjRzb0FLWHlz?=
 =?utf-8?B?dzh0R0JXblhRMzdiVDB3L3cwMXNEMmxiSGxEdC9pR2RMcVJRWWtnQmx4bUFj?=
 =?utf-8?B?Y3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <83C417296E05D641B5E23D5DFAB03241@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d751c9c2-49ee-42ba-a82d-08db9226b0ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2023 00:31:47.7826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2/nMv7GUpkqrF/WWB0Pb6LgZwxKn0VC0Do8TkIycgiC/5Xe4rtagFerDqP+EyoNCdujKGyVzXXmhZ7qhNpKWn4tq1DcIRyorHA90DdIejCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8450
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTA3LTMxIGF0IDE2OjUzIC0wNzAwLCBJcmEgV2Vpbnkgd3JvdGU6Cj4gUHJl
dmlvdXNseSBDWEwgZXZlbnQgdGVzdGluZyB3YXMgcnVuIGJ5IGhhbmQuwqAgVGhpcyByZWR1Y2Vz
IHRlc3RpbmcKClJlZHVjZXMgb3IgaW5jcmVhc2VzIC8gaW1wcm92ZXM/IE9yIGRpZCB5b3UgbWVh
biBydW5uaW5nIGJ5IGhhbmQKcmVkdWNlZCBjb3ZlcmFnZS4KCk1heWJlIHRoaXMgY2FuIHJlYWQg
IkltcHJvdmUgdGVzdGluZyBjb3ZlcmFnZSBhbmQgYWRkcmVzcyBhIGxhY2sgb2YKYXV0b21hdGVk
IHJlZ3Jlc3Npb24gdGVzdGluZyBieSBhZGRpbmcgYSB1bml0IHRlc3QgZm9yIHRoaXMiCgoobm8g
bmVlZCB0byByZXNwaW4sIEkgY2FuIGZpeHVwIHdoZW4gYXBwbHlpbmcsIGp1c3QgbWFraW5nIHN1
cmUgSSdtIG5vdAptaXNpbnRlcnByZXRpbmcgd2hhdCB5b3UgbWVhbnQgdG8gc2F5KS4KCj4gY292
ZXJhZ2UgaW5jbHVkaW5nIGEgbGFjayBvZiByZWdyZXNzaW9uIHRlc3RpbmcuCj4gCj4gQWRkIGEg
Q1hMIGV2ZW50IHRlc3QgYXMgcGFydCBvZiB0aGUgbWVzb24gdGVzdCBpbmZyYXN0cnVjdHVyZS7C
oCBQYXNzaW5nCj4gaXMgcHJlZGljYXRlZCBvbiByZWNlaXZpbmcgdGhlIGFwcHJvcHJpYXRlIG51
bWJlciBvZiBlcnJvcnMgaW4gZWFjaCBsb2cuCj4gSW5kaXZpZHVhbCBldmVudCB2YWx1ZXMgYXJl
IG5vdCBjaGVja2VkLgo+IAo+IFNpZ25lZC1vZmYtYnk6IElyYSBXZWlueSA8aXJhLndlaW55QGlu
dGVsLmNvbT4KPiAtLS0KPiBDaGFuZ2VzIGluIHYyOgo+IFtkamlhbmddIHJ1biBzaGVsbGNoZWNr
IGFuZCBmaXggYXMgbmVlZGVkwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Cj4gW3Zpc2hhbF0gcXVvdGUgdmFyaWFibGVzwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+IFt2aXNoYWxdIHNr
aXAgdGVzdCBpZiBldmVudF90cmlnZ2VyIGlzIG5vdCBhdmFpbGFibGXCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IAo+IFt2aXNoYWxdIHJlbW92ZSBkZWFkIGNvZGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+IFt2aXNoYWxdIGV4
cGxpY2l0bHkgdXNlIHRoZSBmaXJzdCBtZW1kZXYgcmV0dXJuZWQgZnJvbSBjeGwtY2xpwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gW3Zpc2hh
bF0gc3RvcmUgdHJhY2Ugb3V0cHV0IGluIGEgdmFyaWFibGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAKPiBbdmlzaGFsXSBzaW1wbGlmeSBncmVwIHN0YXRlbWVudCBsb29r
aW5nIGZvciByZXN1bHRzwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAKPiBbdmlzaGFsXSB1c2UgdmFyaWFibGVz
IGZvciBleHBlY3RlZCB2YWx1ZXPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Cj4gLSBMaW5rIHRvIHYxOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjMwNzI2LWN4bC1l
dmVudC12MS0xLTFjZjhjYjAyYjIxMUBpbnRlbC5jb20KPiAtLS0KPiDCoHRlc3QvY3hsLWV2ZW50
cy5zaCB8IDc2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKwo+IMKgdGVzdC9tZXNvbi5idWlsZMKgwqAgfMKgIDIgKysKPiDCoDIgZmlsZXMgY2hh
bmdlZCwgNzggaW5zZXJ0aW9ucygrKQo+IApUaGFua3MgZm9yIHRoZSByZXYsIGV2ZXJ5dGhpbmcg
ZWxzZSBsb29rcyBnb29kLgo=
