Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D71217BA5
	for <nvdimm@lists.linux.dev>; Thu, 22 Feb 2024 08:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708589090; cv=fail; b=OulM0Jo/8vaH19bExVNCLtUpCYcrOLNg0BMy1ZLqQ4c01qtIM+tBBAmnHIS4Etng3uc/sw9o1hUB2fmietPLHQV57J29G8NuUDygWq+Fr5BKmdeHvs3S3tB5BXf2uuNPP+RvSIaSsDlZbZBtRQKEITYU2vuGXVN+HY7VTosuSgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708589090; c=relaxed/simple;
	bh=TKio3Er8rHfrjvpmEwY55iFCuvRYn/gctHoY43VeG2g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jSkEOlWzrb7Wq+Mq5q8m8ZaiKfOnkCo0wt5JLsD9NaQpIoA7yuaNYJ2Qab8S6K9iz9R9aWXBqtKPahqYfH/+r6195Azj7qWnSWKXNm9Ww5eVM1/fRCIcecxDZrtWtvCsjQOyoDQqRLXSAyaAaJCV1itXbL8qHMEb5ieTzEEvphs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j7jWWzyF; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j7jWWzyF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708589089; x=1740125089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TKio3Er8rHfrjvpmEwY55iFCuvRYn/gctHoY43VeG2g=;
  b=j7jWWzyFEOWIj8pF3dFD6Jp17uGYwkPeq99bK01Bct7m/M0K2XVgVqBn
   5r6F/Xdk1YynBepTdvOy8DJijTzxgHUJZDzB/p7JWBOjF1YZEKEjg7V1d
   SMBDhCscZgySK/Fvt4Yrax4MRVzy5s+kwrenWUUjP3LNEh6u7ceCWTc03
   MvMPr5d209r3r6HV2thTzTRfx4tjQQwHn7ZayxloBj4OcEXmF5vGoC7TW
   MKunANT3xo9/uola0y/QtV76pll+VVb28zcQLGQ23Y32vHlwnn8aRuW7o
   k+OeyDBZKXVUxhhhXxYtmUPHPWw9bp6bE2FbJUE5ZXPuqA8h758CrYEei
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="2947664"
X-IronPort-AV: E=Sophos;i="6.06,177,1705392000"; 
   d="scan'208";a="2947664"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 00:04:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="913476188"
X-IronPort-AV: E=Sophos;i="6.06,177,1705392000"; 
   d="scan'208";a="913476188"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Feb 2024 00:04:47 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 22 Feb 2024 00:04:46 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 22 Feb 2024 00:04:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 22 Feb 2024 00:04:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNeFBeFyKfUnZnGsWf0K4n163GBVyEPTktz5Ga05y4dUFusILUOJNdPJA2/aIaFVY5y0jALFatFGboI9XSqprqj2Ew/RNnOwbF5Hr7r+X8YqxWrFKO6XHuZZ4gBP3ezYcyhBS/DLcRjSYqIYI/TWXpr6X6vcFiLbLYJ6WKrHjMWn2Kr0D8ou6w+RnUmjBwQDFzll0DtP1losvTmmbxwrZoRX5nPSyCDXc65RaPCcUYfYjze06By7WZVR1BXPyLGzBLFa8HiHQfWr8bx5RgloAZzF5GIM2t/IPtn6q3sXVJr+DGyESXhGDiUxPMw/d8Z38M2RrN9v95usk+coDhrK/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TKio3Er8rHfrjvpmEwY55iFCuvRYn/gctHoY43VeG2g=;
 b=DN8bSpBc20fpoqHJWx+XBRfKviliEKk+CzLj/xZ2lpOCqUkuS2K5xPP7vWHJk9cWeOZpy6SkBNNxJODrN2PcyK0dkRb/bg09PZG4+JqxcA00DStbLdGkAJlvgc4IX5USXAxcqz6rnZlC3+a9tlT282lpxr4jpFifxlhQ+9vMKIfxIUcUUezTnQmv7Pkc7y83ltzfcPhSeQD+rLDW6w+eNwnlOwQwC3c3S9H0UV2SOUjQw6LsOfaqcbeqCRVLMoH1qb0qqR4+y3r/dlmS3Fy9+inWcT/y5R83/PKy29L6oS8HAVTQJ93Vs96HIJI9Kmb/VpBgy0WwtgxtnfSFCkqivA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SA2PR11MB4858.namprd11.prod.outlook.com (2603:10b6:806:f9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Thu, 22 Feb
 2024 08:04:44 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0%5]) with mapi id 15.20.7316.018; Thu, 22 Feb 2024
 08:04:44 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v7 7/7] cxl/test: add cxl-poison.sh unit test
Thread-Topic: [ndctl PATCH v7 7/7] cxl/test: add cxl-poison.sh unit test
Thread-Index: AQHaWiprz/mkvRuTUEyg90dhTPud2rEWFz8A
Date: Thu, 22 Feb 2024 08:04:44 +0000
Message-ID: <cd21f932aa672a389cf0380ae3cf73bec0087e62.camel@intel.com>
References: <cover.1707351560.git.alison.schofield@intel.com>
	 <855025e88e0c261ae36dd6bd70443ebd9e7e5e6f.1707351560.git.alison.schofield@intel.com>
In-Reply-To: <855025e88e0c261ae36dd6bd70443ebd9e7e5e6f.1707351560.git.alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SA2PR11MB4858:EE_
x-ms-office365-filtering-correlation-id: 7dae617f-60e1-4727-6911-08dc337cee2d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fd1h/q6Jm3SQL8zTJjynjz4skERpnSHcOCxpL4ttTTeewqM7IQzhSk5Rj9e5NUVfUhbzqPPkPZOAlfhEcDrcKL/lYNWXKgd755zLASMdSuaZUK1+Fk/aDn9vq6r10i4yCZUQvgxxX9NU/d4wDjcLQahs2TgrPPEhVI00BM+T7qWHDdrKiHK3Mw6k0HMGYqrhL5E7BtFfmH8AkYwczhljnaTGKdCcrKgw57p67Jgxkv+bbSpPG1W+SdlQ3HxWhTGEtU6tZ6K2W7VdSCDXHDvtOjo7embxqkbwxdTCIW5i9tFrxZMUfwRq43lcAzhUINFmrhfpYRpVWAQ/GQAEKLA3foBA4x+r5168aCFK0wi1eRvSuQyLBpEHj9ymIyG69pIL9MAa8T7HrS/06GYfrMzVW0i+t6NL154u/5TL+ceGpwOcj38OWsudJS//Qgrc6bcfG9fgjL1FKemSE9p1BE8FwIWQUQniqzCqwPjSfOpverUsB0of6aKdJSbzyRk14yFIeXFIsm66y6iMuZp6/S7Tt1RNsdb/wVLfhRS1Yj7QVX11yChO/MoA/fa1UOdFuPRlRDtHVIQUTC7bd6QnwzjRde5NtWLfZuiDnEOs+h/mSLx7nVLxvuxgpKrv0ETamU0z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mlo1eEhtSUtPRDJmTTRtQWhybjRkUU9oOWV2OHhNQzRlZVcwS0x3VmZHc3ZF?=
 =?utf-8?B?cUQ1ZXR1OWQzeU1PVVF2a3RUTVRUQ0t1T0c1ekJpaUdMQlZpVHF3WWMwNFcr?=
 =?utf-8?B?MyswMGxqb2VtMytuY3d2ckNlWndQeG9KRVBrUmVGNmZCYTFxVU5ISFFBNWVO?=
 =?utf-8?B?bExmMHdCbFQ5YWQ2UVlXRFBCZnZyWUlWTVNEbDcvQ05penYvaVhoRHY0bVdE?=
 =?utf-8?B?N2xmMDNBY1c0YkhobEN1WG1CNFRvQnJ0eHd5WExWOEhIV2s4eXEvcGlCYThp?=
 =?utf-8?B?ckhDdjU0R0lxc25GOFdhaVpzZXJReEY3d2tDdTUySHIzWmRTWFdHTmJRSTgw?=
 =?utf-8?B?VHZaaGJJQThudUZpTk1UaE5yelJvcXpLVTBMWnVJV2JQNURyRmRoOEtVMXRU?=
 =?utf-8?B?Uk9Xd2dmREpyZTJjUGd0bEs4aHlIVU9CV0VjZFZVSDZJbTV4MW9hNjFKKy9D?=
 =?utf-8?B?NTdCSFN0QXFpRlBSZkp5MHI4dW5lajlpemVKRGpNQ2tjMGRMQVlnaVczTjBL?=
 =?utf-8?B?Slc0TGxnRjR3VEU0Zm5EL1FBcVpuTkdOWStzMlhvM2pUa0ZUWEk1ellwNUM0?=
 =?utf-8?B?bXBVVGpjaU1NRWo0blYzcFFvRDhQeU1DMG9sWktMMUM1VEZLOG42YmVqeHgv?=
 =?utf-8?B?WDhFU2FlWDhqeENoSURMS0JxcXBwTkNRbmpZT2h5bzBNbU9qL3BWZllYRzNt?=
 =?utf-8?B?b0RqbVFWNmZYSXVjMERkVmk5SmhyR2N1T3gwRWhaZXh2U1NHaktFYnV6em5L?=
 =?utf-8?B?Y01rcS9xUTJoN295Q0hubmZTWkVoR0JSWktWemFHamkyWFpTalFJOVZGaC9q?=
 =?utf-8?B?ZHMrcnhFRWk2bFVqbjRWVHYycmtDK0trYnhTVWZFanh6bWhORkp6U2p4dVli?=
 =?utf-8?B?NGFlaklYYlRXd2Q2THNrVGRjVThOL3g2eTAwRHVJQVFjdGNHU2ZUdTZnUmV2?=
 =?utf-8?B?c1pybVA3T3ZleEk2MTZrdmgrWGtvanZjVjV3THZweEV0YlNRRjBYOEdzTFdy?=
 =?utf-8?B?UWxGM1JIdmZmVWkzZVlnT01VVVkrNDV5L3F4U1Q3UVRmQkpvZDhweVNPSFFk?=
 =?utf-8?B?ck02LzFFVzVpNmF6VE5BMjE3RVN2elVkaXkxTWRtQ241RGdGMXdWN2wwNTBv?=
 =?utf-8?B?MzNKMUdMOEo4VlhFUDBrOXdWK3dqZmNvN1orK3dBdENjcmxkNEJsU3lsN3JM?=
 =?utf-8?B?WE12L1FiY0J1NHJ0T01DaHAwSVI1Q0RCekoxYXF0bHBwc2prUjQ4RzFidVdk?=
 =?utf-8?B?R1ZPWDhBTjhIbXI1ZC9tOW9IT2s1dURwbnR4WjBQT1VMK28yb0FoWEhmWEJX?=
 =?utf-8?B?M2UyajY2VTRLMlhVMldGUmRDbHE3YnhRcUhacFdYY3B5TGgxZzRiQ2htSUhH?=
 =?utf-8?B?eXhsQ0U4MFRKT05KbTdBNHRjTGg1WE93bkJkTDQ2NzFFV3RpVkJLNUFmMVIv?=
 =?utf-8?B?eVJEaVJlWkNHUktYRFNXbm51RGhjdmx0MFI3T2lhZVNBbVBBQ3N6UlhUYU1q?=
 =?utf-8?B?YjNCSkJGY2YrYUwxbThCSDhKSHdHRE1aS2dKcjd0RSt0WFQ3eW1yS0pUWVFt?=
 =?utf-8?B?bklpK2VIM211b3VScWJJOWhqMWwyTzdTc2V5SVhTYmZoVE5ZUEx4MUdFdXdq?=
 =?utf-8?B?ODl5YXhib25ZQjlaMkNPT2d6WW9NZ0h2OGY3OUZIMzc2ODBJTHRraW9HMmE2?=
 =?utf-8?B?RTNHaEd3Sy9Mekp6ZW8wMlZocnE3bWxTVGFFMFFjbFA5MDJxSDZPVDJrUmZy?=
 =?utf-8?B?b1I3U3VpampIMms0T0x3UlRzT2hiNnFyZVUxOSt1dnZ2aU1qQzNBYWVnZ0sr?=
 =?utf-8?B?SnY1ZTh6dUhrV0tPUW83WlBpMStuVlFhN3JYcWdTeHNqbUtiS0NpQXFObTRG?=
 =?utf-8?B?bW5GeGtJZ0hSekZDczhwSHdPbFo5NnZxNzdzRk1HUlZzMXExdHFWN28xSXpX?=
 =?utf-8?B?ZWFGcksvVTJPakxoSitCQ2o5anQ5Q1BYV3p0a1k0K1NNdXNtMEl6cUdtangv?=
 =?utf-8?B?dzZqVDZRQTFWNEFjUWtnekpld2I4cVFseHJMWHJhcHBkUTRHZkd2eGR0WWFB?=
 =?utf-8?B?UEFlTXU1MTBuaXVGWWVWcXp0UWp1aGhlRk5sUHRVeVIrSzc3UXIwL0tzcDZh?=
 =?utf-8?B?dWEzNGRZQnc3UHFERUtlcGczc0RLcnpmL0t3QXJwMC9RdXhBdU5DRkNNczZy?=
 =?utf-8?B?Tnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5AFC14148087A845BF8042F4439D8C30@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dae617f-60e1-4727-6911-08dc337cee2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2024 08:04:44.4230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V5FssKv46+eWW+bg+vPUMXlMAvlP+hlPp0wzjr3nKZXofCq8ES1E2Ex5mHPC69GSEzNaq9ON0C/5b7L+ZC2pNIrZPp8bH+2FrAwCUfcBLU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4858
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAyLTA3IGF0IDE3OjAxIC0wODAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBFeGVyY2lzZSBjeGwgbGlzdCwgbGliY3hsLCBhbmQgZHJpdmVyIHBp
ZWNlcyBvZiB0aGUgZ2V0IHBvaXNvbiBsaXN0DQo+IHBhdGh3YXkuIEluamVjdCBhbmQgY2xlYXIg
cG9pc29uIHVzaW5nIGRlYnVnZnMgYW5kIHVzZSBjeGwtY2xpIHRvDQo+IHJlYWQgdGhlIHBvaXNv
biBsaXN0IGJ5IG1lbWRldiBhbmQgYnkgcmVnaW9uLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxp
c29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoHRl
c3QvY3hsLXBvaXNvbi5zaCB8IDEzNyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gwqB0ZXN0L21lc29uLmJ1aWxkwqDCoCB8wqDCoCAyICsNCj4gwqAyIGZp
bGVzIGNoYW5nZWQsIDEzOSBpbnNlcnRpb25zKCspDQo+IMKgY3JlYXRlIG1vZGUgMTAwNjQ0IHRl
c3QvY3hsLXBvaXNvbi5zaA0KPiANCj4gZGlmZiAtLWdpdCBhL3Rlc3QvY3hsLXBvaXNvbi5zaCBi
L3Rlc3QvY3hsLXBvaXNvbi5zaA0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAw
MDAwMDAwMDAuLjZmY2ViMGYyYzM2MA0KPiAtLS0gL2Rldi9udWxsDQo+ICsrKyBiL3Rlc3QvY3hs
LXBvaXNvbi5zaA0KPiBAQCAtMCwwICsxLDEzNyBAQA0KPiArIyEvYmluL2Jhc2gNCj4gKyMgU1BE
WC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4gKyMgQ29weXJpZ2h0IChDKSAyMDIzIElu
dGVsIENvcnBvcmF0aW9uLiBBbGwgcmlnaHRzIHJlc2VydmVkLg0KPiArDQo+ICsuICIkKGRpcm5h
bWUgIiQwIikiL2NvbW1vbg0KPiArDQo+ICtyYz03Nw0KPiArDQo+ICtzZXQgLWV4DQo+ICsNCj4g
K3RyYXAgJ2VyciAkTElORU5PJyBFUlINCj4gKw0KPiArY2hlY2tfcHJlcmVxICJqcSINCj4gKw0K
PiArbW9kcHJvYmUgLXIgY3hsX3Rlc3QNCj4gK21vZHByb2JlIGN4bF90ZXN0DQo+ICsNCj4gK3Jj
PTENCj4gKw0KPiArIyBUSEVPUlkgT0YgT1BFUkFUSU9OOiBFeGVyY2lzZSBjeGwtY2xpIGFuZCBj
eGwgZHJpdmVyIGFiaWxpdHkgdG8NCj4gKyMgaW5qZWN0LCBjbGVhciwgYW5kIGdldCB0aGUgcG9p
c29uIGxpc3QuIERvIGl0IGJ5IG1lbWRldiBhbmQgYnkgcmVnaW9uLg0KPiArDQo+ICtmaW5kX21l
bWRldigpDQo+ICt7DQo+ICsJcmVhZGFycmF5IC10IGNhcGFibGVfbWVtcyA8IDwoIiRDWEwiIGxp
c3QgLWIgIiRDWExfVEVTVF9CVVMiIC1NIHwNCj4gKwkJanEgLXIgIi5bXSB8IHNlbGVjdCgucG1l
bV9zaXplICE9IG51bGwpIHwNCj4gKwkJc2VsZWN0KC5yYW1fc2l6ZSAhPSBudWxsKSB8IC5tZW1k
ZXYiKQ0KPiArDQo+ICsJaWYgWyAkeyNjYXBhYmxlX21lbXNbQF19ID09IDAgXTsgdGhlbg0KPiAr
CQllY2hvICJubyBtZW1kZXZzIGZvdW5kIGZvciB0ZXN0Ig0KPiArCQllcnIgIiRMSU5FTk8iDQo+
ICsJZmkNCj4gKw0KPiArCW1lbWRldj0ke2NhcGFibGVfbWVtc1swXX0NCj4gK30NCj4gKw0KPiAr
Y3JlYXRlX3gyX3JlZ2lvbigpDQo+ICt7DQo+ICvCoMKgwqDCoMKgwqDCoCAjIEZpbmQgYW4geDIg
ZGVjb2Rlcg0KPiArwqDCoMKgwqDCoMKgwqAgZGVjb2Rlcj0iJCgkQ1hMIGxpc3QgLWIgIiRDWExf
VEVTVF9CVVMiIC1EIC1kIHJvb3QgfCBqcSAtciAiLltdIHwNCj4gKwkJc2VsZWN0KC5wbWVtX2Nh
cGFibGUgPT0gdHJ1ZSkgfA0KPiArCQlzZWxlY3QoLm5yX3RhcmdldHMgPT0gMikgfA0KPiArCQku
ZGVjb2RlciIpIg0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoCAjIEZpbmQgYSBtZW1kZXYgZm9yIGVh
Y2ggaG9zdC1icmlkZ2UgaW50ZXJsZWF2ZSBwb3NpdGlvbg0KPiArwqDCoMKgwqDCoMKgwqAgcG9y
dF9kZXYwPSIkKCRDWEwgbGlzdCAtVCAtZCAiJGRlY29kZXIiIHwganEgLXIgIi5bXSB8DQo+ICsJ
CS50YXJnZXRzIHwgLltdIHwgc2VsZWN0KC5wb3NpdGlvbiA9PSAwKSB8IC50YXJnZXQiKSINCj4g
K8KgwqDCoMKgwqDCoMKgIHBvcnRfZGV2MT0iJCgkQ1hMIGxpc3QgLVQgLWQgIiRkZWNvZGVyIiB8
IGpxIC1yICIuW10gfA0KPiArCQkudGFyZ2V0cyB8IC5bXSB8IHNlbGVjdCgucG9zaXRpb24gPT0g
MSkgfCAudGFyZ2V0IikiDQo+ICvCoMKgwqDCoMKgwqDCoCBtZW0wPSIkKCRDWEwgbGlzdCAtTSAt
cCAiJHBvcnRfZGV2MCIgfCBqcSAtciAiLlswXS5tZW1kZXYiKSINCj4gK8KgwqDCoMKgwqDCoMKg
IG1lbTE9IiQoJENYTCBsaXN0IC1NIC1wICIkcG9ydF9kZXYxIiB8IGpxIC1yICIuWzBdLm1lbWRl
diIpIg0KDQpTcGFjZS90YWIgbWl4aW5nIGhlcmUuIEkgd29uZGVyIGlmIG9uZSBvZiB0aGUgZWFy
bGllciB0ZXN0cyB3aGVyZSBzb21lDQpvZiB0aGlzIGJvaWxlcnBsYXRlIGNvbWVzIGZyb20gaGFz
IHNwYWNlcyBpbnN0ZWFkIG9mIHRhYnMsIGFuZCBoYXMgYmVlbg0KY3JlZXBpbmcgaW50byBuZXcg
dGVzdHMuIFdvdWxkIGJlIG5pY2UgdG8gYXQgbGVhc3QgY2xlYW4gdGhpcyBwYXRjaCB1cCwNCmFu
ZCBJIGNhbiBzZW5kIGEgY2xlYW51cCBmb3Igb2xkZXIgdGVzdHMgb25jZSB0aGUgZHVzdCBzZXR0
bGVzIHdpdGggdGhlDQpjdXJyZW50bHkgaW4tZmx1eCBwYXRjaHNldHMuDQoNCj4gKw0KPiArCXJl
Z2lvbj0iJCgkQ1hMIGNyZWF0ZS1yZWdpb24gLWQgIiRkZWNvZGVyIiAtbSAiJG1lbTAiICIkbWVt
MSIgfA0KPiArCQkganEgLXIgIi5yZWdpb24iKSINCj4gKwlpZiBbWyAhICRyZWdpb24gXV07IHRo
ZW4NCj4gKwkJZWNobyAiY3JlYXRlLXJlZ2lvbiBmYWlsZWQgZm9yICRkZWNvZGVyIg0KPiArCQll
cnIgIiRMSU5FTk8iDQo+ICsJZmkNCj4gKwllY2hvICIkcmVnaW9uIg0KPiArfQ0KPiArDQo+ICsj
IFdoZW4gY3hsLWNsaSBzdXBwb3J0IGZvciBpbmplY3QgYW5kIGNsZWFyIGFycml2ZXMsIHJlcGxh
Y2UNCj4gKyMgdGhlIHdyaXRlcyB0byAvc3lzL2tlcm5lbC9kZWJ1ZyB3aXRoIHRoZSBuZXcgY3hs
IGNvbW1hbmRzLg0KPiArDQo+ICtpbmplY3RfcG9pc29uX3N5c2ZzKCkNCj4gK3sNCj4gKwltZW1k
ZXY9IiQxIg0KPiArCWFkZHI9IiQyIg0KPiArDQo+ICsJZWNobyAiJGFkZHIiID4gL3N5cy9rZXJu
ZWwvZGVidWcvY3hsLyIkbWVtZGV2Ii9pbmplY3RfcG9pc29uDQo+ICt9DQo+ICsNCj4gK2NsZWFy
X3BvaXNvbl9zeXNmcygpDQo+ICt7DQo+ICsJbWVtZGV2PSIkMSINCj4gKwlhZGRyPSIkMiINCj4g
Kw0KPiArCWVjaG8gIiRhZGRyIiA+IC9zeXMva2VybmVsL2RlYnVnL2N4bC8iJG1lbWRldiIvY2xl
YXJfcG9pc29uDQo+ICt9DQo+ICsNCj4gK3ZhbGlkYXRlX3BvaXNvbl9mb3VuZCgpDQo+ICt7DQo+
ICsJbGlzdF9ieT0iJDEiDQo+ICsJbnJfZXhwZWN0PSIkMiINCj4gKw0KPiArCXBvaXNvbl9saXN0
PSIkKCRDWEwgbGlzdCAiJGxpc3RfYnkiIC0tbWVkaWEtZXJyb3JzIHwNCj4gKwkJanEgLXIgJy5b
XS5tZWRpYV9lcnJvcnMnKSINCj4gKwlpZiBbWyAhICRwb2lzb25fbGlzdCBdXTsgdGhlbg0KPiAr
CQlucl9mb3VuZD0wDQo+ICsJZWxzZQ0KPiArCQlucl9mb3VuZD0kKGpxICJsZW5ndGgiIDw8PCAi
JHBvaXNvbl9saXN0IikNCj4gKwlmaQ0KPiArCWlmIFsgIiRucl9mb3VuZCIgLW5lICIkbnJfZXhw
ZWN0IiBdOyB0aGVuDQo+ICsJCWVjaG8gIiRucl9leHBlY3QgcG9pc29uIHJlY29yZHMgZXhwZWN0
ZWQsICRucl9mb3VuZCBmb3VuZCINCj4gKwkJZXJyICIkTElORU5PIg0KPiArCWZpDQo+ICt9DQo+
ICsNCj4gK3Rlc3RfcG9pc29uX2J5X21lbWRldigpDQo+ICt7DQo+ICsJZmluZF9tZW1kZXYNCj4g
KwlpbmplY3RfcG9pc29uX3N5c2ZzICIkbWVtZGV2IiAiMHg0MDAwMDAwMCINCj4gKwlpbmplY3Rf
cG9pc29uX3N5c2ZzICIkbWVtZGV2IiAiMHg0MDAwMTAwMCINCj4gKwlpbmplY3RfcG9pc29uX3N5
c2ZzICIkbWVtZGV2IiAiMHg2MDAiDQo+ICsJaW5qZWN0X3BvaXNvbl9zeXNmcyAiJG1lbWRldiIg
IjB4MCINCj4gKwl2YWxpZGF0ZV9wb2lzb25fZm91bmQgIi1tICRtZW1kZXYiIDQNCj4gKw0KPiAr
CWNsZWFyX3BvaXNvbl9zeXNmcyAiJG1lbWRldiIgIjB4NDAwMDAwMDAiDQo+ICsJY2xlYXJfcG9p
c29uX3N5c2ZzICIkbWVtZGV2IiAiMHg0MDAwMTAwMCINCj4gKwljbGVhcl9wb2lzb25fc3lzZnMg
IiRtZW1kZXYiICIweDYwMCINCj4gKwljbGVhcl9wb2lzb25fc3lzZnMgIiRtZW1kZXYiICIweDAi
DQo+ICsJdmFsaWRhdGVfcG9pc29uX2ZvdW5kICItbSAkbWVtZGV2IiAwDQo+ICt9DQo+ICsNCj4g
K3Rlc3RfcG9pc29uX2J5X3JlZ2lvbigpDQo+ICt7DQo+ICsJY3JlYXRlX3gyX3JlZ2lvbg0KPiAr
CWluamVjdF9wb2lzb25fc3lzZnMgIiRtZW0wIiAiMHg0MDAwMDAwMCINCj4gKwlpbmplY3RfcG9p
c29uX3N5c2ZzICIkbWVtMSIgIjB4NDAwMDAwMDAiDQo+ICsJdmFsaWRhdGVfcG9pc29uX2ZvdW5k
ICItciAkcmVnaW9uIiAyDQo+ICsNCj4gKwljbGVhcl9wb2lzb25fc3lzZnMgIiRtZW0wIiAiMHg0
MDAwMDAwMCINCj4gKwljbGVhcl9wb2lzb25fc3lzZnMgIiRtZW0xIiAiMHg0MDAwMDAwMCINCj4g
Kwl2YWxpZGF0ZV9wb2lzb25fZm91bmQgIi1yICRyZWdpb24iIDANCj4gK30NCj4gKw0KPiArIyBU
dXJuIHRyYWNpbmcgb24uIE5vdGUgdGhhdCAnY3hsIGxpc3QgLS1wb2lzb24nIGRvZXMgdG9nZ2xl
IHRoZSB0cmFjaW5nLg0KPiArIyBUdXJuaW5nIGl0IG9uIGhlcmUgYWxsb3dzIHRoZSB0ZXN0IHVz
ZXIgdG8gYWxzbyB2aWV3IGluamVjdCBhbmQgY2xlYXINCj4gKyMgdHJhY2UgZXZlbnRzLg0KPiAr
ZWNobyAxID4gL3N5cy9rZXJuZWwvdHJhY2luZy9ldmVudHMvY3hsL2N4bF9wb2lzb24vZW5hYmxl
DQo+ICsNCj4gK3Rlc3RfcG9pc29uX2J5X21lbWRldg0KPiArdGVzdF9wb2lzb25fYnlfcmVnaW9u
DQo+ICsNCj4gK2NoZWNrX2RtZXNnICIkTElORU5PIg0KPiArDQo+ICttb2Rwcm9iZSAtciBjeGwt
dGVzdA0KPiBkaWZmIC0tZ2l0IGEvdGVzdC9tZXNvbi5idWlsZCBiL3Rlc3QvbWVzb24uYnVpbGQN
Cj4gaW5kZXggMjI0YWRhZjQxZmNjLi4yNzA2ZmE1ZDYzM2MgMTAwNjQ0DQo+IC0tLSBhL3Rlc3Qv
bWVzb24uYnVpbGQNCj4gKysrIGIvdGVzdC9tZXNvbi5idWlsZA0KPiBAQCAtMTU3LDYgKzE1Nyw3
IEBAIGN4bF9jcmVhdGVfcmVnaW9uID0gZmluZF9wcm9ncmFtKCdjeGwtY3JlYXRlLXJlZ2lvbi5z
aCcpDQo+IMKgY3hsX3hvcl9yZWdpb24gPSBmaW5kX3Byb2dyYW0oJ2N4bC14b3ItcmVnaW9uLnNo
JykNCj4gwqBjeGxfdXBkYXRlX2Zpcm13YXJlID0gZmluZF9wcm9ncmFtKCdjeGwtdXBkYXRlLWZp
cm13YXJlLnNoJykNCj4gwqBjeGxfZXZlbnRzID0gZmluZF9wcm9ncmFtKCdjeGwtZXZlbnRzLnNo
JykNCj4gK2N4bF9wb2lzb24gPSBmaW5kX3Byb2dyYW0oJ2N4bC1wb2lzb24uc2gnKQ0KPiDCoA0K
PiDCoHRlc3RzID0gWw0KPiDCoMKgIFsgJ2xpYm5kY3RsJyzCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGxpYm5kY3RsLAkJwqAgJ25kY3RsJyBdLA0KPiBAQCAtMTg2LDYgKzE4Nyw3IEBAIHRl
c3RzID0gWw0KPiDCoMKgIFsgJ2N4bC1jcmVhdGUtcmVnaW9uLnNoJyzCoMKgIGN4bF9jcmVhdGVf
cmVnaW9uLMKgICdjeGwnwqDCoCBdLA0KPiDCoMKgIFsgJ2N4bC14b3ItcmVnaW9uLnNoJyzCoMKg
wqDCoMKgIGN4bF94b3JfcmVnaW9uLMKgwqDCoMKgICdjeGwnwqDCoCBdLA0KPiDCoMKgIFsgJ2N4
bC1ldmVudHMuc2gnLMKgwqDCoMKgwqDCoMKgwqDCoCBjeGxfZXZlbnRzLMKgwqDCoMKgwqDCoMKg
wqAgJ2N4bCfCoMKgIF0sDQo+ICvCoCBbICdjeGwtcG9pc29uLnNoJyzCoMKgwqDCoMKgwqDCoMKg
wqAgY3hsX3BvaXNvbizCoMKgwqDCoMKgwqDCoMKgICdjeGwnwqDCoCBdLA0KPiDCoF0NCj4gwqAN
Cj4gwqBpZiBnZXRfb3B0aW9uKCdkZXN0cnVjdGl2ZScpLmVuYWJsZWQoKQ0KDQo=
