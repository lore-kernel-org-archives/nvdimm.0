Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC1435EFB
	for <nvdimm@lists.linux.dev>; Mon,  4 Dec 2023 20:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bVrR1dQz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701722575; x=1733258575;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F0l3fJZ2TqMWbtVnn3h9D1Ajr3UTuehiECN3+ikzu6U=;
  b=bVrR1dQzYrT8fVJ3QDvAlfTP8YVCBopP/1eJB4lJySNqadgV51QLFVuI
   oFy2aj5RQwXKMCza7jxkW4DgsJdJdwlK57NXvovIMtwybRJhArl4lZ71k
   XQBvFAsujxnGvKbHkPzseOabn02+grCol16ty3m5ByRv4Z+LiIz5QS/ma
   BXksJkKBEAjwNv5gNiGJYqg0tUXYoyrvM1/gsp+890sMg7Wg234b69zzp
   bkEl52W83al5vfmd0sgNwILhNF2uErZc8aE4pnXxUyKU9yIRM3PjJBJFV
   cC/p2ZeZqbGgUczYhTwnscubIOh/v0A3Dq8lW6BHwe1gUQjr14Q/VlOG5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="851827"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="851827"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 12:42:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="799710252"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="799710252"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 12:42:54 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 12:42:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 4 Dec 2023 12:42:53 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 12:42:53 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 12:42:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYq1xmrB4iJlTTIclClYsg0pueHfCc5fc98Ytf+JgUmVi5F+46uwrqGUjk2NHmQXevmrNTZgmOWomBTMfACGO7NinP7DVup9zMeHbcllytCXKAQXRn4HLcBds6O3PBE5mt2DcZorWHKnj3ye6S26wWuAeMz9KxljUiAwdfqdE6A9/p2n8HstEu4nWF/1RBUZlFWFU5fgM0vVjOBXJcZc1wcdBA37dy3wY8lMVueYw4K7ul8k3bunzqYVMkGf8jFgmDIMoIfgtInGpOSoSM6gWm/eZ+uq9FXcDxDEEJmeaa6qINQlEktzuxrXYeDYZCH8Cu0g/TnyKcFzXCvseQFphw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0l3fJZ2TqMWbtVnn3h9D1Ajr3UTuehiECN3+ikzu6U=;
 b=L4RV+FJmBw1szDqYgGXZgqPcXjEIpZ6JPV28NWjupeRiHDIwyOp4npDEz9GZlaagm3dQnJNRBvOSy4uv7MyfdGeYqEH02AcNhjj4Vyhz8jHtQPg8SiuVnMehAG0j9Exh9dPaiWELZUBGmo4nNADccegO5dd1+0ZBE0WoeV9PQPZOrM1Bey1WdPXeFqvAr2jKc68MSWO+SvQ249AUlYLzuz0PQmdKWO0mbi7CE0JwNj9qZrs7J3RbZSNevn8mp3hGITGtscCKh2VcBbCMALgTZupDy7KmT1K0eX9ZbxkxukYIa+GVm5CgBxOFa/fFvPxH4ym76TPKF1FGMjV7qTJ50A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SJ0PR11MB5629.namprd11.prod.outlook.com (2603:10b6:a03:3ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 20:42:39 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694%7]) with mapi id 15.20.7025.022; Mon, 4 Dec 2023
 20:42:39 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl RESEND 1/2] ndctl/test: Add destroy region test
Thread-Topic: [PATCH ndctl RESEND 1/2] ndctl/test: Add destroy region test
Thread-Index: AQHaJAu/YxXs4aYmgECKHsrWa5h+gbCU1CuAgASclwCAACv7gA==
Date: Mon, 4 Dec 2023 20:42:38 +0000
Message-ID: <000bba54c1a3cde1aa63bc8052c01e745835468d.camel@intel.com>
References: <20231130-fix-region-destroy-v1-0-7f916d2bd379@intel.com>
	 <20231130-fix-region-destroy-v1-1-7f916d2bd379@intel.com>
	 <ZWo2f2eWVtsJrYD9@aschofie-mobl2>
	 <656e14d8285f7_16287c29422@iweiny-mobl.notmuch>
In-Reply-To: <656e14d8285f7_16287c29422@iweiny-mobl.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SJ0PR11MB5629:EE_
x-ms-office365-filtering-correlation-id: f60494d1-3a3c-4001-d781-08dbf5098e05
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GT+CQy3ihcoHwV5Z209e6+2ZY1NAYQyQE1sJ88FWvYEFD1CdBR1+WutPhEnS51zBz88bOCGsMKpMJnfI8PeEn/YIF9wA1vaF/pg4bc8HtwyWQvvV6J66OHbKdbeEMEn/zhZxwLoPInr5EMZbdKNJdh0n4iz+HNu+FVm+I1DwoxAM9Euy1HV6frA3VBekmvaL5kLJKHVKCUTroQGrbNLRzfLlqEgYKm5hCj28+qzTkkOLKRvh97xWlZRg3qzm7vledd3pGJ7umO/WDMzzQJCNslxsWheT61PeFgqAMC4KgY45qShusa28WMTNE4cu/zgctNKCckfsRVcCJQx2wuY7JN4uZIBZYqlPK8Mb7uj59DV3mzH51m1FLSgu3saqVvLkdhi/nSf3HTIQ8l64mz710haE1RaZluwxsMxGsVbcyABQzoZYaibWX6XNL/U20GXdaIt64h3b7/UM3zgrpO5q7dgsKk31BVYDhOggDH6xBNTFT5EmKo92diM7yom4b3YDzWLhPvNWpHUVZX1CN6GO14Ew05S5/6nPEshGpsgjdYPOi6laD/fbmyM7bZqHtFlMT9I7wPjqLemNZK+htvZIk9EwwhV6g4ThfWVvUhcGYHk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(366004)(396003)(39860400002)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(2906002)(5660300002)(41300700001)(122000001)(38100700002)(76116006)(110136005)(64756008)(66476007)(66946007)(66556008)(66446008)(26005)(86362001)(36756003)(82960400001)(6506007)(2616005)(6512007)(71200400001)(4326008)(478600001)(83380400001)(6486002)(966005)(8676002)(8936002)(316002)(6636002)(38070700009)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkVPcVVKZno0L1dha1hUQUJ1Um4zVnUwKzBRTkpUV05vVW5HREF0bHdqem5l?=
 =?utf-8?B?ajIvM083WTRrRks0S2M4cEcxUUlzcFNKZE9sTTcrN05sTFA2MnF4eHNXd2FG?=
 =?utf-8?B?Q2gyZTd0RUlMVTBBMlRZU2d3VFF6ZmpueW1DRTE3RzllSGw4YUl5dUw3SEtM?=
 =?utf-8?B?YWUxMGxDdVRzVURvODgrUVBGa2J2Mjl2dTNmT3NjYU1wT2hJUUZUU2lYYnBX?=
 =?utf-8?B?Y3BSUU40TXZpVTBZQlZMbFpHY0ZmU1FqUjExNldKdXhMb0tFUnZ0dVR5WnlE?=
 =?utf-8?B?RUhvK1Y5bjQvUGh6dUE2SlIvUWVNbytVSE9yYlptZXgzcVE0ZXFFcm1STGpn?=
 =?utf-8?B?OTcxVkVFZzlIZHA0bXRkdEFleURNMVBNTTF2OExPZjFkdG1RRExTTk9Bdk1D?=
 =?utf-8?B?QzBJS1c0bjd6Ukw4d2FSeHNVcHF4dmpTQ0NoVzRIckNBck5VVk5VQUhtOUNh?=
 =?utf-8?B?cG1vNHlBQ2cyMS9XSE5EblErNkh6Um5mSHpzczllY0pHbjZsQ0VSSlh6WURy?=
 =?utf-8?B?VXdIWGNkTlAyWGg2cXltRkgrVTR3VEsvUDBVNlJQMVhncnNIM1RWTlJKTmMv?=
 =?utf-8?B?SzdSUlhwbmlmMytIelBMUkRLZ1R2Q2dvd2VXd2xlNHJnM1l3WC9vdnpucmRw?=
 =?utf-8?B?bUJjRkY1ZmovTTFpV0x6dzVuVjhhSVZ0WmZDWlR2TmxGeGxyRXRtT1RHRXBU?=
 =?utf-8?B?YlpHTkdDZnNTSVplVFdRNDBnOWhKd1BwcmlhV1JEeVlRa25TaENPalJMVk9q?=
 =?utf-8?B?QVQ3S1A5czFLelF6TnhVbGt3MkpyRlMrMHVMcm45S1VXVWdRODk1RmxsR3Y0?=
 =?utf-8?B?K0FwVENTK0xpdEs2YTFlTTRnZTlFSjY5dlVXb1QxVU1Hdk1pendpTUVyL1Ri?=
 =?utf-8?B?M3UzNVc4NHRNQldnUjJ1T05KeXZuOXpRNWlSd0szQWxJQ1JJQS9Mayt4SXVh?=
 =?utf-8?B?YmpxcGVYc05lQjdZZ2czV0dOb3Vhd1hTdHFweFJNcHpGNmc1Z2c0cS9vL21M?=
 =?utf-8?B?QWJQbTJFL2dxY0t3aTZ4T1J1VFVDenFRV3hGK201SWJrSHNhMkJJTFhRVXFj?=
 =?utf-8?B?aVd1RGEvdFpvcGNDT2pscWVRNlprLzJNMlFWaWZCTjFtNm41WU1pbVl3dE5o?=
 =?utf-8?B?Mm9jelB1Z2RqbmpkNi8yYmdJVlFrTFFRZDZrSm9iSlZlOEZnZ0tseEtSMmh3?=
 =?utf-8?B?aTV5emwrdXY0bWVoU0NHeXlDa2Z0OGphbHY3TFFyL05RUnFMUGQyK0wxODAz?=
 =?utf-8?B?REhsb2FZSW51NzY3YXpnNTgzWTdhSUpKT0tEcG5DVzJVUktwQjVjN2Z1VkdM?=
 =?utf-8?B?VzdBYzl3ZlNFTkl4K05HMCsyYzNMaUJwMnowK1NWdFN6dXhnVWtCN3Z3QW9t?=
 =?utf-8?B?YVlPbGdxbWJrZW8xaGtvL1hwbldhQmZPd0xnODV0cDVXcktBZUZQd05VVlRy?=
 =?utf-8?B?Uk90SXV3TlVteXVaOHYvcURkMEpUZXBsTTVyZzljWWpOZndiSmJxMkEwWHJu?=
 =?utf-8?B?NDRGU1M2Zjhvdml3cE85Sll5TjRseDFaNmFocGI2NlJQTjJSU1F4VEYxQ0gz?=
 =?utf-8?B?alhrN2Yzc0NZdXcydGFvVVJYeE1rQmE2SjgrN08xSEpkTHZIU2pRdHhUUU92?=
 =?utf-8?B?c2xPL1dXWGVCdkdYWmdoRTRBcE91VkJ3QzN4Ym5KY1NKRU5Tc3N5bUFLby8z?=
 =?utf-8?B?WnBiV3JtTkc4R0NQZDZPT2FKemtDajR5cGpMRXRNUERrMTJMWEZVNVFrM3dp?=
 =?utf-8?B?Tng4Z2FWeTR0dDNoSHhzeGFPV2VVQzV0Y2J5TmRLQTFFemZkYzd0am1NMjhw?=
 =?utf-8?B?QUh2VTl2SnVadHJhaXBsSW4zWXlPeEdwaVc1TlpuTnFVOXpUWi9vQ1FHY3NL?=
 =?utf-8?B?UzBIQTN5R3k4ZWswb0NOK2o5S1ZQaVBsZllaalZscmpmSXViV2lsVVNnUTFU?=
 =?utf-8?B?QkhOY1hOa0IyS2hxekIrTnBYMU5zTDR4QmZKWlArTldpbUF3WW5mMVV6VHBq?=
 =?utf-8?B?VnkzODJwYUVidjE3QXlnK3NQdytmY29VdmdBMDdRNk5YRFhCSm9yWlhTR3Jj?=
 =?utf-8?B?TUhKK2I4UjA5RkJWbmdRbnUyc09yQjhzY09kNzNqaVRhQjI5NHBEUTlieTVU?=
 =?utf-8?B?bWZhZlRlUVNWSWR5b2ZmbW9YT3paV0FkbThlU3RZNThieXI5ZWZ6RmthcjFY?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99C0E2FAD635D645A826A3AE7BE5C372@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f60494d1-3a3c-4001-d781-08dbf5098e05
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2023 20:42:38.9121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2XKIRa8p0dCy/PLaAjpNYpkmq0pFzbpY1opn0O1zT8SqVLL/yk/vRhB6jqwrppyP8sOPsULc+tTbTjYXH80zWfhyez4emoIalcXdZ3rI3lk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5629
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTEyLTA0IGF0IDEwOjA1IC0wODAwLCBJcmEgV2Vpbnkgd3JvdGU6Cj4gQWxp
c29uIFNjaG9maWVsZCB3cm90ZToKPiA+IE9uIFRodSwgTm92IDMwLCAyMDIzIGF0IDA4OjA2OjEz
UE0gLTA4MDAsIElyYSBXZWlueSB3cm90ZToKPiAKPiBbc25pcF0KPiAKPiA+ID4gKwo+ID4gPiAr
Y2hlY2tfZGVzdHJveV9kZXZkYXgoKQo+ID4gPiArewo+ID4gPiArwqDCoMKgwqDCoMKgwqBtZW09
JDEKPiA+ID4gK8KgwqDCoMKgwqDCoMKgZGVjb2Rlcj0kMgo+ID4gPiArCj4gPiA+ICvCoMKgwqDC
oMKgwqDCoHJlZ2lvbj0kKCRDWEwgY3JlYXRlLXJlZ2lvbiAtZCAiJGRlY29kZXIiIC1tICIkbWVt
IiB8IGpxIC1yICIucmVnaW9uIikKPiA+ID4gK8KgwqDCoMKgwqDCoMKgaWYgWyAiJHJlZ2lvbiIg
PT0gIm51bGwiIF07IHRoZW4KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVy
ciAiJExJTkVOTyIKPiA+ID4gK8KgwqDCoMKgwqDCoMKgZmkKPiA+ID4gK8KgwqDCoMKgwqDCoMKg
JENYTCBlbmFibGUtcmVnaW9uICIkcmVnaW9uIgo+ID4gPiArCj4gPiA+ICvCoMKgwqDCoMKgwqDC
oGRheD0kKCRDWEwgbGlzdCAtWCAtciAiJHJlZ2lvbiIgfCBqcSAtciAiLltdLmRheHJlZ2lvbi5k
ZXZpY2VzIiB8IGpxIC1yICcuW10uY2hhcmRldicpCj4gPiA+ICsKPiA+ID4gK8KgwqDCoMKgwqDC
oMKgJERBWENUTCByZWNvbmZpZ3VyZS1kZXZpY2UgLW0gZGV2ZGF4ICIkZGF4Igo+ID4gPiArCj4g
PiA+ICvCoMKgwqDCoMKgwqDCoCRDWEwgZGlzYWJsZS1yZWdpb24gJHJlZ2lvbgo+ID4gPiArwqDC
oMKgwqDCoMKgwqAkQ1hMIGRlc3Ryb3ktcmVnaW9uICRyZWdpb24KPiA+ID4gK30KPiA+ID4gKwo+
ID4gPiArIyBGaW5kIGEgbWVtb3J5IGRldmljZSB0byBjcmVhdGUgcmVnaW9ucyBvbiB0byB0ZXN0
IHRoZSBkZXN0cm95Cj4gPiA+ICtyZWFkYXJyYXkgLXQgbWVtcyA8IDwoIiRDWEwiIGxpc3QgLWIg
Y3hsX3Rlc3QgLU0gfCBqcSAtciAnLltdLm1lbWRldicpCj4gPiA+ICtmb3IgbWVtIGluICR7bWVt
c1tAXX07IGRvCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCByYW1zaXplPSQoJENYTCBsaXN0IC1tICRt
ZW0gfCBqcSAtciAnLltdLnJhbV9zaXplJykKPiA+ID4gK8KgwqDCoMKgwqDCoMKgIGlmIFsgIiRy
YW1zaXplIiA9PSAibnVsbCIgXTsgdGhlbgo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGNvbnRpbnVlCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCBmaQo+ID4gPiArwqDCoMKgwqDC
oMKgwqAgZGVjb2Rlcj0kKCRDWEwgbGlzdCAtYiBjeGxfdGVzdCAtRCAtZCByb290IC1tICIkbWVt
IiB8Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGpxIC1yICIuW10g
fAo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZWxlY3QoLnZvbGF0
aWxlX2NhcGFibGUgPT0gdHJ1ZSkgfAo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBzZWxlY3QoLm5yX3RhcmdldHMgPT0gMSkgfAo+ID4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBzZWxlY3QoLnNpemUgPj0gJHtyYW1zaXplfSkgfAo+ID4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAuZGVjb2RlciIpCj4gPiA+ICvCoMKg
wqDCoMKgwqDCoCBpZiBbWyAkZGVjb2RlciBdXTsgdGhlbgo+ID4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgY2hlY2tfZGVzdHJveV9yYW0gJG1lbSAkZGVjb2Rlcgo+ID4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY2hlY2tfZGVzdHJveV9kZXZkYXggJG1lbSAkZGVj
b2Rlcgo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrCj4gPiA+ICvC
oMKgwqDCoMKgwqDCoCBmaQo+ID4gPiArZG9uZQo+ID4gCj4gPiBEb2VzIHRoaXMgbmVlZCB0byBj
aGVjayByZXN1bHRzIG9mIHRoZSByZWdpb24gZGlzYWJsZSAmIGRlc3Ryb3k/Cj4gPiAKPiA+IERp
ZCB0aGUgcmVncmVzc2lvbiB0aGlzIGlzIGFmdGVyIGxlYXZlIGEgdHJhY2UgaW4gdGhlIGRtZXNn
IGxvZywKPiA+IHNvIGNoZWNraW5nIHRoYXQgaXMgYWxsIHRoYXQncyBuZWVkZWQ/Cj4gPiAKPiAK
PiBUaGUgcmVncmVzc2lvbiBjYXVzZXMKPiAKPiDCoMKgwqDCoMKgwqDCoMKgY2hlY2tfZGVzdHJv
eV9kZXZkYXgoKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgJENYTCBkaXNhYmxl
LXJlZ2lvbiAkcmVnaW9uCj4gCj4gdG8gZmFpbC7CoCBUaGF0IGNvbW1hbmQgZmFpbHVyZSB3aWxs
IGV4aXQgd2l0aCBhbiBlcnJvciB3aGljaCBjYXVzZXMgdGhlCj4gdGVzdCBzY3JpcHQgdG8gZXhp
dCB3aXRoIHRoYXQgZXJyb3IgYXMgd2VsbC4KPiAKPiBBdCBsZWFzdCB0aGF0IGlzIHdoYXQgaGFw
cGVuZWQgd2hlbiBJIHVzZWQgdGhpcyB0byB0ZXN0IHRoZSBmaXguwqAgSSdsbAo+IGRlZmVyIHRv
IFZpc2hhbCBpZiB0aGVyZSBpcyBhIG1vcmUgZXhwbGljaXQgb3IgYmV0dGVyIHdheSB0byBjaGVj
ayBmb3IKPiB0aGF0IGN4bC1jbGkgY29tbWFuZCB0byBmYWlsLgo+IApDb3JyZWN0LCB0aGUgc2V0
IC1lIHdpbGwgY2F1c2UgdGhlIHNjcmlwdCB0byBhYm9ydCB3aXRoIGFuIGVycm9yIGV4aXQKY29k
ZSB3aGVuZXZlciBhIGNvbW1hbmQgZmFpbHMuCgpJIGRvIHdvbmRlciBpZiB3ZSBuZWVkIHRoaXMg
bmV3IHRlc3QgLSB3aXRoIERhdmUncyBwYXRjaCBoZXJlWzFdLApkZXN0cm95LXJlZ2lvbiBhbmQg
ZGlzYWJsZS1yZWdpb24gYm90aCB1c2UgdGhlIHNhbWUgaGVscGVyIHRoYXQKcGVyZm9ybXMgdGhl
IGxpYmRheGN0bCBjaGVja3MuCgpjeGwtY3JlYXRlLXJlZ2lvbi5zaCBhbHJlYWR5IGhhcyBmbG93
cyB0aGF0IGNyZWF0ZSBhIHJlZ2lvbiBhbmQgdGhlbgpkZXN0cm95IGl0LiBUaG9zZSBzaG91bGQg
bm93IGNvdmVyIHRoaXMgY2FzZSBhcyB3ZWxsIHllYWg/CgpbMV06IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2FsbC8xNzAxMTI5MjExMDcuMjY4NzQ1Ny4yNzQxMjMxOTk1MTU0NjM5MTk3LnN0Z2l0
QGRqaWFuZzUtbW9ibDMvCg==
