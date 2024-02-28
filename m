Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6846570046
	for <nvdimm@lists.linux.dev>; Wed, 28 Feb 2024 21:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709157139; cv=fail; b=CFvm27yiNUCzCgM7kc+sMLYjcwJSwCFOmhb12mZ0+85de38JnWT93Hki6WkoPj4CzJsvubUvP3PWMRgwXfNRHCaycgcA95poIxHvf5ULomnDUCT705MUHg4Al9FBZjrpOgI7/JbR2oaf4ODkCf8AY4fMNxvsY9cO3dUxkAk598g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709157139; c=relaxed/simple;
	bh=5r7OyUg7Av29SAjd5Qiyc1SeeUfB7iIFePWkxq/TrjE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BxPt68srLWaPjrxyqb7g0yE6BEPQKbCp7BGGS+CKpcpfYN9Mo7DXZdvS9O3PVzyimJExWuCSLhpD9JRsxzN/ASrAnBzun/Fk1C/nv0wXrJipDc8wKoseDGhki4wXLCXfTyZskJUkRmYYWO7ohJ5TN8LHn1Xz7ErBlqUyYSI4vo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T5SnfF32; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T5SnfF32"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709157137; x=1740693137;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5r7OyUg7Av29SAjd5Qiyc1SeeUfB7iIFePWkxq/TrjE=;
  b=T5SnfF32S/itvucY2Ontq+IvW51KaETY/RGuaZnVG1khkzzxbeOQ5IMu
   TXCd13cgJcf38rD0nYP38+22YxnXiOrz4nNqfRq7U0e+uzz6d3JOxzvsU
   nN+unK5soevD5Ep5WMN9phHi9PfET1OHnJJ8vJ6y4qoFQs3g4bciePxB+
   LoZfeMq7AStxcAcFlSKN4261M0buDda7SXQbAwB2AJJYmLNIv04koiyf5
   qnKIOZps9ZDlAffhraPeOhFmMLsI75tvWg4IUfeWLknc5scB5Z7dkXHjw
   wmlLcIrvgzLG9NMffqzKAvrzlU2q9YoYix8rEFYz0Ttkw23ZhnkLsbRwz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="26057645"
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="26057645"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 13:52:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="12192533"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Feb 2024 13:52:15 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 28 Feb 2024 13:52:14 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 28 Feb 2024 13:52:14 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 28 Feb 2024 13:52:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKAYa2Ohb5/Lqi3gH1WrSPO+6vzc7lIlIGzy0OOecyktJatzrg5aBm4k2jRU3CrP5c8ZCvtE5td02GXjzXxl0pRJtEQ7vImGYSCKW1mfMltXkfaeqmDzZiAiCTrtQkEJsGT69GtLzNTVQEZhwDjL60vwfq7P3YjyY+Jcqsk4XDKGsNWd3ahoQesu03AQe1amHzLMS69xx0hrWYx1PBetPWTXsuWBoNPeraXg7n2EWXNMD/pE2guW/4Wl5wAkh7gfPdyhiorp+gc2pBxusNMhEvt83hkTEcg53B+qmy8L++miY5mV3DVnP6pu7LkELjPrXg+0ZGoHGT+SNRkjnQ3lpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5r7OyUg7Av29SAjd5Qiyc1SeeUfB7iIFePWkxq/TrjE=;
 b=JlpkcuXr0NCuyWVYcWVx07kCG05GA2wTTvsmfjQ1eFlRkTfrZ/Coc84mEBSBxE9b6xFAx2/A2AH1oZ1WwciVNIl+JKUObsvbI/jHzVxAU43qV4NixtAfDWMRg2hzIDn+hhwq7CZDutnwYjKrJLOIA0wGDPDEbBnmZb4EoFjPY/tNWdE/rkuxyw7VZq/5ZnLmgaVH1lNNJWBx6hDZgqe1BHCilxbXl12rOeaGtS1a2jkQh29BmLAhdteoTesCOU3lNIDWVS4MITNLdf0XFRQfAqkzd0aEclt8nqC2RwaEGLMByn4QDkX81ZF98njPdiJYJNJm33lG/sXZ7+/EAXUnpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH7PR11MB6499.namprd11.prod.outlook.com (2603:10b6:510:1f0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.10; Wed, 28 Feb
 2024 21:52:11 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::408e:7d88:17d0:d768]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::408e:7d88:17d0:d768%7]) with mapi id 15.20.7339.024; Wed, 28 Feb 2024
 21:52:11 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>
Subject: Re: [ndctl PATCH] cxl/event_trace: parse arrays separately from
 strings
Thread-Topic: [ndctl PATCH] cxl/event_trace: parse arrays separately from
 strings
Thread-Index: AQHaYJ5EsVt0fTQcCUSDLDdKzeU1NrEgX4MA
Date: Wed, 28 Feb 2024 21:52:11 +0000
Message-ID: <7871c5c424338b7f7cf766f77a6cb7b21d4c7a10.camel@intel.com>
References: <20240216060610.1951127-1-alison.schofield@intel.com>
In-Reply-To: <20240216060610.1951127-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.4 (3.50.4-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH7PR11MB6499:EE_
x-ms-office365-filtering-correlation-id: 9498844c-f222-488b-1bf6-08dc38a78454
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXn/EG9du/7QRJB8g5+BOQOEr+kTWCu5D8e0nN9xE4p4wJARPu4yb+Bes+mLRuXjsflWRH4z3LQ/MMijybmepzPCJE9HMvU8gyLl+vTYF9t8BpRbKYKNt76DPAgUh8/17bc3G9t5N5IW4JCRZH4K0kuER1gk//gQ9eaZjyPyURevRmpqPW9SfxyiXd5j3IqxFTAYkEyCtfBBCQsskdMhfLTTFgW6QFbONTk/QzS7yuTy5XDfnTOVxJViFXpZ0xOAzONhZzwRfj03Lie/JuaE8jUQl+Sp1zqCtZ5RIb05h6h6HIBiwRNSLi9ULdlFqj3wTPTutscJles+G/wqSOnBHDm5h8efeM0H69e9vZiw4VVGFmLL7QshbMnxyf/pBqKjhHh5ykMWEjgKcuZM3CdUNlcg7SCyB6F5Lj1op/OYuWwoeNcvKd4PZ4xnjdCn2Jczwc+pfiYnYsfXwhtlWrusKfWcL2wJGYuKfKMpWqrnB+bH8SL5K2UCCCxiFkec8qMCSWrLAV73dSPTN3W27sEyu63J1B1DmHiOruIA8rm5eJS4AneqoblcTAhtTxqSkKX1qYBKqec7afH18Gyz1D0NZXLFtUcGt8+1lfO6/snShp0jHgH8bgu9XKI7b7VrzYeTHOz29IYy7VeRo5W9OfiD7Frn0kWmhyqXezLpKSB390pREmQi9D/qUm8VlXsNlkdfHiRjWdbjgWOhxO4pAk+7+kKqxgLZhxRJXF7KeOyrNvI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0ZzTHVxZEVVclY0RVl4VVRWQ3FHaUFka3N4enpaS29PTkRwOHozYXg3cUdX?=
 =?utf-8?B?dUlwcGEvazRKaDZWRzlQUFAwQk1vNU81dmxOS0VGc2pDQWlNeCtaeGx1TUk5?=
 =?utf-8?B?OGxFMTN1dnJZcnJFMlF6cldaZ3JIWDZwRFUrNWFxNHRLZE15eGtUK3doS2hX?=
 =?utf-8?B?YjE1aStiNTlPc2o2bW1Kd2R3S01SRDdFSHRCU1BEVjlQRWJmWDgrdlgrNk9u?=
 =?utf-8?B?ejFyU0hmbkd6dHV2SlQwRVBzbFYrNDhsWGVFZVpSekNJZnBDVm4vQkJhZ2Yx?=
 =?utf-8?B?UnRDbEZaWW4xMDhISzF0Mm84cVlTUnJwRzFSa2duYjNVOEN6VE5zRzFlSldY?=
 =?utf-8?B?M2dzQ3N4YUdpKzMxckFYWjVaalRsU0ljdE1DSWloMGwrbklzSUVQOTNia0lk?=
 =?utf-8?B?Y25LcUhZWm45cjBRUkhyRjJXWVlvSDlaTXk3bStucEp1RHY0QmpoQ0wzNmpK?=
 =?utf-8?B?bUpGR1QxWE5QSGRWaTVhYzZPK3JEaDVjNmluajl1WnhkTlBUb0FQR21iRm1W?=
 =?utf-8?B?ZStCdlZYU2cvaUpYZVhYMmQ4ZGtSNlcvWkhXNkNueUlYTzlSazIwaFJUMFdB?=
 =?utf-8?B?bmRZL1RNUkNUVEh3ZTFUMVo1d1JZWG5XYXNYMzhzSk4zUDB6YllNWnNwM1I3?=
 =?utf-8?B?QjRIV0YxcEMxWm82L3o1WjVuMmlGYXY0aVNwdmdkK1JNcW1aY3h0Zlg1aDh1?=
 =?utf-8?B?L3ljdmkxV1Y2SWJuZHloOEZpZEdPclA5K2k4NUhETVgzaEw2SXVoU2dJSnlG?=
 =?utf-8?B?VTFSQTM5RTJBek9qRWlSaWY5dkJRclhrd0pEVW85bUNRaklQUCt3a1NZTFJn?=
 =?utf-8?B?WnYxbE0zaEFxcGRabzZOZHlWbm9OMldLUmdVMUFvcko1L2ZnYkNsSUpVa1dO?=
 =?utf-8?B?dFZqOHBYWk5sbjFKY2ZVY0I5ckkrZVY2REZqVzdSODUxcjNaYVNqVm96N2tt?=
 =?utf-8?B?NU9CV2t0RzhmUE4xOW94eFFYbkJSUUpKQ2hraGJaYXAxYmRiMGJ1WHFKamJz?=
 =?utf-8?B?QjI5REVpb3FleDFROU5Pa0lHMktqU2lmajVqSGY0TXFLRVdURHdFQ2tGMmhr?=
 =?utf-8?B?SGdFQmJVN01McWRtMkNYOGJid085UnVEZW03MmtKdWNxbnVMTnQzN3RqT3cz?=
 =?utf-8?B?dllJdG42QWZzM3ZmVG4vMTV4S29yK0hKV0pIZCtKM2ZVdW9vVjlGQXI4MWo5?=
 =?utf-8?B?WDI4MWtZQ01xMFhTc0EzYldqR0JRYXN6SHJpQjdzUXI1OFNyVTVPYmNldUtV?=
 =?utf-8?B?NHBZSWJPUXRRYWVqaDhmWGtaMkZUZm9weVRGcXNDeDV0WVg4d2dnNGduVTdv?=
 =?utf-8?B?Q0JqL3lYZUE4THRCOUt3Vzl5cm10aVZXeXBRTGtmUDg3VmRwMDJxbW1uMlA1?=
 =?utf-8?B?RjhzdVpocGVmQk4wMm5tQzhzM1VKN2VjMHArVWZtT3JLZVBXN3ZKNUJLd1RT?=
 =?utf-8?B?V1RHYkJRRzFSbWE0b1pHTlh5emRLZXpLTUt0bFF2UW43Y3ZpRzVmRnIza0VL?=
 =?utf-8?B?aHhiN0xIMFhxSXFtMHlmZUQ2ZndFTGVxd0Q2eC9HTC81anpqTDhLa2lEWGZo?=
 =?utf-8?B?WHpHY2hOMThubmNDWXQzT01ycXZUeDllRWNndlNhcStCb3BPMzRqbXRHbVVk?=
 =?utf-8?B?RW5wNk1lZUdyTWFnWU52YU8rV0pFZ2RkY3pUSWpQWGFZN0ZBdUxDcEZ2UE1y?=
 =?utf-8?B?U3ZKQjU5TTNjQlNXbko2S2FRYmlRVGRYOHF3enJmaGJML0wzdEo3ZjBVSVBt?=
 =?utf-8?B?MkhNejBXUkV6azQvcEhlSEVmMUxQU1JWMXd5OHQwdUx6ZHE2SXdnSUVYYWl4?=
 =?utf-8?B?NHhQRXFFLy9CV2l6SWVKRGVoMTkyTGlnTVF1ZVhJMU5Sb0lWYzlMMnpFUGNn?=
 =?utf-8?B?NVpIMXF5Si8xNVJpZmJzdlU3V092SXlyb0dQUDUwU0p0VDB2MEs0VytCYlVq?=
 =?utf-8?B?R1VUb1dtUk9LYWk4T0ozRUtyS3RwWWFJdXdvdEZBSmRYb0JtOWtKRDJYOFUy?=
 =?utf-8?B?UjRzKzlTdkl1OGg5UCsxV3NLeGtnZzU3a2FvVTJINFZ6YlVQWFRodzZuRmZs?=
 =?utf-8?B?Q3NNNTdlMmZWWUZsR1YwKzZFakhLVTJmd0ZwdWY1NXNYZVRpTGdIOUl3aUxU?=
 =?utf-8?B?TmVXN2VPMldYc0JseFhiSFdLNTNkV2hQY0UxcFI2eEg2c25JVFl0QmJ5RUw5?=
 =?utf-8?B?MGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86FB11DF6A6C024E8BF77AB3E6F14E24@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9498844c-f222-488b-1bf6-08dc38a78454
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2024 21:52:11.0434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NPS8v4EF8kKPHP5O1m2Zsxci1C/+Fvwr7tNyDkboqmHTXgT3kK44EZ860zLPVgfVl0t7fZSYgZaOG2tz9TPL80yRWAVGjsbooaqw+ewRiSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6499
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAyLTE1IGF0IDIyOjA2IC0wODAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBBcnJheXMgYXJlIGJlaW5nIHBhcnNlZCBhcyBzdHJpbmdzIGJhc2Vk
IG9uIGEgZmxhZyB0aGF0IHNlZW1zIGxpa2UNCj4gaXQgd291bGQgYmUgdGhlIGRpZmZlcmVudGlh
dG9yLCBBUlJBWSBhbmQgU1RSSU5HLCBidXQgaXQgaXMgbm90Lg0KPiANCj4gbGlidHJhY2VldmVu
dCBzZXRzIHRoZSBmbGFncyBmb3IgYXJyYXlzIGFuZCBzdHJpbmdzIGxpa2UgdGhpczoNCj4gYXJy
YXk6wqAgVEVQX0ZJRUxEX0lTX1tBUlJBWSB8IFNUUklOR10NCj4gc3RyaW5nOiBURVBfRklFTERf
SVNfW0FSUkFZIHwgU1RSSU5HIHwgRFlOQU1JQ10NCj4gDQo+IFVzZSBURVBfRklFTERfSVNfRFlO
QU1JQyB0byBkaXNjb3ZlciB0aGUgZmllbGQgdHlwZSwgb3RoZXJ3aXNlIGFycmF5cw0KPiBnZXQg
cGFyc2VkIGFzIHN0cmluZ3MgYW5kICdjeGwgbW9uaXRvcicgcmV0dXJucyBnb2JibGVkeWdvb2sg
aW4gdGhlDQo+IGFycmF5IHR5cGUgZmllbGRzLg0KPiANCj4gVGhpcyBmaXhlcyB0aGUgImRhdGEi
IGZpZWxkIG9mIGN4bF9nZW5lcmljX2V2ZW50cyBhbmQgdGhlICJ1dWlkIg0KPiBmaWVsZA0KPiBv
ZiBjeGxfcG9pc29uLg0KPiANCj4gQmVmb3JlOg0KPiB7InN5c3RlbSI6ImN4bCIsImV2ZW50Ijoi
Y3hsX2dlbmVyaWNfZXZlbnQiLCJ0aW1lc3RhbXAiOjM0NjkwNDEzODc0NzANCj4gLCJtZW1kZXYi
OiJtZW0wIiwiaG9zdCI6ImN4bF9tZW0uMCIsImxvZyI6MCwiaGRyX3V1aWQiOiJiYTVlYmExMS0N
Cj4gYWJjZC1lZmViLWE1NWEtDQo+IGE1NWFhNWE1NWFhNSIsInNlcmlhbCI6MCwiaGRyX2ZsYWdz
Ijo4LCJoZHJfaGFuZGxlIjoxLCJoZHJfcmVsYXRlZF9oYQ0KPiBuZGxlIjo0MjQyMiwiaGRyX3Rp
bWVzdGFtcCI6MCwiaGRyX2xlbmd0aCI6MTI4LCJoZHJfbWFpbnRfb3BfY2xhc3MiOjANCj4gLCJk
YXRhIjoiw57CrcK+w68ifQ0KDQpXaGVuIGFwcGx5aW5nLCBiNCBjb21wbGFpbnMgb2YgdGhlc2Ug
aW4gdGhlIGNvbW1pdCBtZXNzYWdlIGFzDQoic3VzcGljaW91cyB1bmljb2RlIGNvbnRyb2wgY2hh
cmFjdGVycyIuIEknbSBhbHNvIG5vdCBhIGh1Z2UgZmFuIG9mIHRoZQ0Kc3VwZXIgbG9uZyBsaW5l
cywgcGVyaGFwcyB3ZSBjYW4ganVzdCBkcm9wIHRoZSBiZWZvcmUvYWZ0ZXIgZXhhbXBsZXM/DQoN
Cj4gDQo+IEFmdGVyOg0KPiB7InN5c3RlbSI6ImN4bCIsImV2ZW50IjoiY3hsX2dlbmVyaWNfZXZl
bnQiLCJ0aW1lc3RhbXAiOjMxMjg1MTY1NzgxMCwNCj4gIm1lbWRldiI6Im1lbTAiLCJob3N0Ijoi
Y3hsX21lbS4wIiwibG9nIjowLCJoZHJfdXVpZCI6ImJhNWViYTExLWFiY2QtDQo+IGVmZWItYTU1
YS0NCj4gYTU1YWE1YTU1YWE1Iiwic2VyaWFsIjowLCJoZHJfZmxhZ3MiOjgsImhkcl9oYW5kbGUi
OjEsImhkcl9yZWxhdGVkX2hhDQo+IG5kbGUiOjQyNDIyLCJoZHJfdGltZXN0YW1wIjowLCJoZHJf
bGVuZ3RoIjoxMjgsImhkcl9tYWludF9vcF9jbGFzcyI6MA0KPiAsImRhdGEiOlsyMjIsMTczLDE5
MCwyMzksMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwNCj4gMCww
LDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAs
MCwwLDAsMCwwDQo+ICwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwLDAsMCwwXX0NCj4g
DQo+IEJlZm9yZToNCj4geyJzeXN0ZW0iOiJjeGwiLCJldmVudCI6ImN4bF9wb2lzb24iLCJ0aW1l
c3RhbXAiOjMyOTI0MTgzMTE2MDksIm1lbWRlDQo+IHYiOiJtZW0xIiwiaG9zdCI6ImN4bF9tZW0u
MSIsInNlcmlhbCI6MSwidHJhY2VfdHlwZSI6MiwicmVnaW9uIjoicmVnaQ0KPiBvbjUiLCJvdmVy
Zmxvd190cyI6MCwiaHBhIjoxMDM1MzU1NTU3ODg4LCJkcGEiOjEwNzM3NDE4MjQsImRwYV9sZW5n
dGgNCj4gIjo2NCwidXVpZCI6Iu+/vUZl77+9Y++/vUNJ77+977+977+977+977+9Mu+/vV0iLCJz
b3VyY2UiOjAsImZsYWdzIjowfQ0KPiANCj4gQWZ0ZXI6DQo+IHsic3lzdGVtIjoiY3hsIiwiZXZl
bnQiOiJjeGxfcG9pc29uIiwidGltZXN0YW1wIjo5NDYwMDUzMTI3MSwibWVtZGV2Ig0KPiA6Im1l
bTEiLCJob3N0IjoiY3hsX21lbS4xIiwic2VyaWFsIjoxLCJ0cmFjZV90eXBlIjoyLCJyZWdpb24i
OiJyZWdpb24NCj4gNSIsIm92ZXJmbG93X3RzIjowLCJocGEiOjEwMzUzNTU1NTc4ODgsImRwYSI6
MTA3Mzc0MTgyNCwiZHBhX2xlbmd0aCI6DQo+IDY0LCJ1dWlkIjpbMTM5LDIwMCwxODQsMjIsMjM2
LDEwMyw3NiwxMjEsMTU3LDI0Myw0NywxMTAsMjQzLDExLDE1OCw2Mg0KPiBdLCJzb3VyY2UiOjAs
ImZsYWdzIjowfQ0KPiANCj4gVGhhdCBjeGxfcG9pc29uIHV1aWQgZm9ybWF0IGNhbiBiZSBmdXJ0
aGVyIGltcHJvdmVkIGJ5IHVzaW5nIHRoZQ0KPiB0cmFjZQ0KPiB0eXBlIChfX2ZpZWxkX3N0cnVj
dCB1dWlkX3QpIGluIHRoZSBDWEwga2VybmVsIGRyaXZlci4gVGhlIHBhcnNlcg0KPiB3aWxsDQo+
IGF1dG9tYXRpY2FsbHkgcGljayB1cCB0aGF0IG5ldyB0eXBlLCBhcyBpbGx1c3RyYXRlZCBpbiB0
aGUgImhkcl91dWlkIg0KPiBvZiBjeGxfZ2VuZXJpY19tZWRpYSBldmVudCB0cmFjZSBhYm92ZS4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFsaXNvbiBTY2hvZmllbGQgPGFsaXNvbi5zY2hvZmllbGRA
aW50ZWwuY29tPg0KPiAtLS0NCj4gwqBjeGwvZXZlbnRfdHJhY2UuYyB8IDggKysrKysrKy0NCj4g
wqAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvY3hsL2V2ZW50X3RyYWNlLmMgYi9jeGwvZXZlbnRfdHJhY2UuYw0KPiBpbmRl
eCBkYjhjYzg1ZjBiNmYuLjFiNWFhMDlkZThiMiAxMDA2NDQNCj4gLS0tIGEvY3hsL2V2ZW50X3Ry
YWNlLmMNCj4gKysrIGIvY3hsL2V2ZW50X3RyYWNlLmMNCj4gQEAgLTEwOSw3ICsxMDksMTMgQEAg
c3RhdGljIGludCBjeGxfZXZlbnRfdG9fanNvbihzdHJ1Y3QgdGVwX2V2ZW50DQo+ICpldmVudCwg
c3RydWN0IHRlcF9yZWNvcmQgKnJlY29yZCwNCj4gwqAJCXN0cnVjdCB0ZXBfZm9ybWF0X2ZpZWxk
ICpmID0gZmllbGRzW2ldOw0KPiDCoAkJaW50IGxlbjsNCj4gwqANCj4gLQkJaWYgKGYtPmZsYWdz
ICYgVEVQX0ZJRUxEX0lTX1NUUklORykgew0KPiArCQkvKg0KPiArCQkgKiBsaWJ0cmFjZWV2ZW50
IGRpZmZlcmVudGlhdGVzIGFycmF5cyBhbmQgc3RyaW5ncw0KPiBsaWtlIHRoaXM6DQo+ICsJCSAq
IGFycmF5OsKgIFRFUF9GSUVMRF9JU19bQVJSQVkgfCBTVFJJTkddDQo+ICsJCSAqIHN0cmluZzog
VEVQX0ZJRUxEX0lTX1tBUlJBWSB8IFNUUklORyB8IERZTkFNSUNdDQo+ICsJCSAqLw0KPiArCQlp
ZiAoKGYtPmZsYWdzICYgVEVQX0ZJRUxEX0lTX1NUUklORykgJiYNCj4gKwkJwqDCoMKgICgoZi0+
ZmxhZ3MgJiBURVBfRklFTERfSVNfRFlOQU1JQykpKSB7DQo+IMKgCQkJY2hhciAqc3RyOw0KPiDC
oA0KPiDCoAkJCXN0ciA9IHRlcF9nZXRfZmllbGRfcmF3KE5VTEwsIGV2ZW50LCBmLQ0KPiA+bmFt
ZSwgcmVjb3JkLCAmbGVuLCAwKTsNCj4gDQo+IGJhc2UtY29tbWl0OiBhODcxZTYxNTNiMTFmZTYz
NzgwYjM3Y2RjYjFlYjM0N2IyOTYwOTVjDQoNCg==
