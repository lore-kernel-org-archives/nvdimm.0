Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE3D80607
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 20:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717185798; cv=fail; b=evsqQjh+Vhe9pX+LFx0VTu3o/Wy86rG8PiHuDCR8nmsmAKnCrXCQyzd8qAPahmxwf5ghMMOAxdCkfIR2h6i285tgOYAegjm/jmUo722B5GIjstdKLyMB/zwf3JnKRtSnMQ47KsSDgho2iwhjG5qX06D5er+3MjRQVu2CVUG4aPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717185798; c=relaxed/simple;
	bh=HBQRTHtOXbvPWjbUN8YE1J0y6apE6A1z4Qz7op+1gy0=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BqKelYZZXZ3X5qqS7l8l7wfYJf3hNYxHPjYs34S9pG4IQHLIo9tqqZYNZ3a0+U5B0WsHLijKveDXGbCswvOFFyEKqAtwLChK26cJouoNZHGBCOArjue2IwNic/USY+CH2zgog9MOBF9+zv94dvgHIBMEZ742qBG7MCAYislc7Mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m1RhyZyp; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m1RhyZyp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717185796; x=1748721796;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=HBQRTHtOXbvPWjbUN8YE1J0y6apE6A1z4Qz7op+1gy0=;
  b=m1RhyZypW8/VG/NuOnlKXJQoRHidWo7Drtb0P13EvG2K7a4+YkY2Pv2j
   hFvfxNHHXv9xF4m3/GHo/t5GO0CRvaL8Woz5Ev3IIHJ0ngjeSUQsDNh0g
   YHg1iRVc5CBOlpqZ137cjtII9F+iPyNXtOSyyQs6ZmemcrcqVjbMbrHRK
   SahaRUK3QRDE7IHh4K/RiTrAhNrSY1iZU7YPF2Ufgyeoj6iJXFCnjOcA9
   rMOARXqt6XzM4D5avWR7Ki2uwcGi+4RUuBFQG8mUkJJxU7FOvK/jP3yXF
   XyJfanYN/xlrT3YncN+yJGrm6ZFDqFWpipc9E7QqyzkMk78OZFVmWwnA4
   g==;
X-CSE-ConnectionGUID: VHmrIAsOSwCBY5Va1lKh5A==
X-CSE-MsgGUID: AknEzNMMRzuKpLLiQIT0Mg==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="39146612"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="39146612"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:03:16 -0700
X-CSE-ConnectionGUID: CaQY4pc5SbaIh9pux/FOYw==
X-CSE-MsgGUID: MmbbJpVeTSGv0fp8tAEiiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="67456156"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 13:03:16 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 13:03:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 13:03:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 13:03:15 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 13:03:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtaesL/WGzKuAJ7LDlYKgT4XrHUjBDDCO24BCIq8ypCxVzpBbcGAbr0NWWrsjz9il6FpGxDbhvrCIbDLwzVkd00VfYEGS3sY9Motr6WbcRLlNAtM2nP25ThF2Pkoe7cKXli8qrW/p84vJ34nWceM+uZEvMIufdEUaPWZ7or+0anqtRP9A0WH85i1RiJqj+pyn/xhP4c1k3yD9PZnq/nAbuqdBjt7hrmzSYDQLpZlq6eQNZ2yILo2lS0UQPRH2VHi3AuL7DVqdPKSbcfz+KKgzQjdKmAbHXZiRsVqy4gIpADQmMAC+xL3IHfyWK2g4vWSlH+6QJoa17DxwrClCmkDWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBQRTHtOXbvPWjbUN8YE1J0y6apE6A1z4Qz7op+1gy0=;
 b=C2ONsX5zEPL8Q3G08Cs04ZQ83WXLesKfWKBOK3HgibLnLYDina/qxNuHSwgUfalFrrM/gXxQVJ+dwsXbUbR6rsroc5/rDXFl5jlCOuZa/BmyJbJwjGg9eqS0gxHSaEjTaCXWHFeWTgHh7j5uh+IBe1R6WTx1jIzc2ar6NrDsTtw+eK1MqfwxhL3UUt6xIzNAplekZD/NcSvigAlVa3F8vkJu46YGLIqOQSIocvEGggUUK8DZ76GMKO4H2ATHatGBq/+g+HiPqTaxmkaS4Jio7gqTambghPjJxB430lRqFPWaLG7SfH5FsUbizWvFa1O6tF+s2vmMjLzySCmcnN2FSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 20:03:13 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%6]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 20:03:13 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 2/2] daxctl: Remove unimplemented create-device
 options
Thread-Topic: [ndctl PATCH v2 2/2] daxctl: Remove unimplemented create-device
 options
Thread-Index: AQHasyQxtonsdwrlI0W6i3IoT6PZT7GxxNeA
Date: Fri, 31 May 2024 20:03:13 +0000
Message-ID: <c450f0cfc3c7a42862154b07c3f6adadc9dabbd0.camel@intel.com>
References: <20240531062959.881772-1-lizhijian@fujitsu.com>
	 <20240531062959.881772-2-lizhijian@fujitsu.com>
In-Reply-To: <20240531062959.881772-2-lizhijian@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.1 (3.52.1-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MW5PR11MB5764:EE_
x-ms-office365-filtering-correlation-id: c9fea370-87dc-4ae6-03a6-08dc81acb3f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?dWkzSkVpaXhTV0xwZ0NyTXBoM1llVkZNTi9oay85MUdHV2dsM2d1c01tMENT?=
 =?utf-8?B?UzY5UlBGaWVHLzI5bVF4d1JnRnNmS1FtOG9hbWpLeGJFR2cvTWo2eTZSNkNn?=
 =?utf-8?B?bVRMdTYzN2JDNGcxYmVJQTBKTG9DZzN3cnFNOC9BZmFlTGdhUUFhbWJzT2h1?=
 =?utf-8?B?WlJpRnA0VUtBdFBvWmdhdGJ0ak9vSEduckJmaEtpcHFEQjE1NXM0amU1QkhW?=
 =?utf-8?B?eXh2UVpUWDl2emlNT2x5YWlSYWJRRXpzZ1dkNExndGs3dHVxOEFGdTBwMnFB?=
 =?utf-8?B?d3pXSXF1bjltWVZlaW52ZTRwRzIxdnJ1QW90S1U2WTF5QVJpbkt1TVh1YkRQ?=
 =?utf-8?B?ZkxGNVFRWmlTSTJ5OFJDZVBsMEs2UTVPOXVoMGhoeVFLNnNQemMxMDRXbW1R?=
 =?utf-8?B?NDRvek5LYmFSbkZ5QnZ1cEo4YXc1bW9uOWw5L253L1dlQ3lYRVEvbVRCOXFH?=
 =?utf-8?B?SEo1VTRBVDhRd05RSnh3b3VJWVhScUFoV2NJc2JIcGdtYStCeDJVa3MvS1gw?=
 =?utf-8?B?T3pxcHMxNVZ3U1A1RkIxNi9FZXFFVFhYQVBzWXBzTmxDejFZZE03dTAydFVH?=
 =?utf-8?B?UEdWRFNvNG1mSXNkci9BSkdDR2FaOHZTUGlSd3BGVU1MMmwzamc5bGFyeDVa?=
 =?utf-8?B?U1ZEdWxVb29Dc0RFS1FsQkR2VUYxREhwRWx1SEhEQXlWNmlrRHpKOHRHMG0v?=
 =?utf-8?B?U3VjdHQ1bW5kckY4NzloaXlCS0M0a1hKamQ5bk01TUcxSElXNHc0bS91NklG?=
 =?utf-8?B?STdUWjNsYzV4aEI3alJhWmczcjE2UE12ZnRUZGJXVm52RkNKUnFPUzlzZ00v?=
 =?utf-8?B?MUdSRUNPa1RYTkZZSWNIRjJPSHN3UXBYcm94VGg0YjRZN2hUaE9STHRyYW9F?=
 =?utf-8?B?L3VOUy8wZ0lQSkkxN0I3OGFOcmZDdXJ0SllJU2hDcUJicDNOSVFzeU5ZS0pS?=
 =?utf-8?B?dUU5b29Dc3lDWXdLY3gwdWRrSGdxMWVxOWdHSHN6WE1naFMrVkdEcnU1ejNj?=
 =?utf-8?B?Qi9qNkJOMCtxTmhxN2tRRmZwemlraGFOTThKRXlZZ1Y1MEFNek8xdjROQURx?=
 =?utf-8?B?cWMrOEhNVFh5aURlODVxd0FHUDNHY1JlZmdESTI1NGZjclJVL2JLYkU0OW5L?=
 =?utf-8?B?SXcyMlJ1ckc4TlBDMmM3TTFVZnFTYUVQTUF2TThhZS9zbkwwenlWa2J4MzBL?=
 =?utf-8?B?WFg5OW14YXlNeTFIZzIvdVp0dGQxR1B2WUR1MHY4eWlxR3g1ME5sbDl5cjdZ?=
 =?utf-8?B?TjBnKzI4NVlYT2RmSjAzdWdFL3REYm5nbU93TjRKcXNBTDd3aUVSZXpseEJi?=
 =?utf-8?B?UW03aURGVlpFVXhFU2JJYmQ4U2xTUm1iN1ROTmxtODlHZ1FUL3dKL0JDbTA5?=
 =?utf-8?B?QlEwcC95cG1CaVhEVG9YbjJGU2MzMktRZU9VaGdVVGlkeVhCVTd5T3kycjBj?=
 =?utf-8?B?cG4xRy9FUkpNc0IyREFMRG1scUhOZjF0RE5oVXZtQnJFM24xaVBuZW1mV3o3?=
 =?utf-8?B?anYwTDZNNFFGbTVtdkV3eWFOSUthWnBpS3QvR0tvcDhENkhWNE9CY3NPQS9Q?=
 =?utf-8?B?N09UK1hkRUpVM3dURTRvSHUyQkhLc01aYzVDWmFoTWJ4SVMxS0xKbEEza05N?=
 =?utf-8?B?cnFzT1R3OUFndVk1YitWVmJGL2tCZFFVdEs2aVM5a3lMRmxncGNtZk9hZEJZ?=
 =?utf-8?B?Mzl5RnBBb3kzS3JZK3Y3Sko5UWxEWFZsRXYxdHZ4aHVuZUdMYWlSbThwR0Zv?=
 =?utf-8?B?ZFd0Ykdlcm9MU2gram51d1ZycVd0VGJ3U2lOVTYxaG1XdDFMMUNLY1RNOGdY?=
 =?utf-8?B?TnBDdlR0K2VBblhIRy9Fdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2ZBNXJoM21RYlVGK2lUbFFrcU9YTmZhdTVUMC84L3RXTE45emdtRnJTM2ps?=
 =?utf-8?B?Ykx6RkpJK1ZPYkZRNEtPNlk4VzNOeEZsbldCYkNTejdBaURKK3JVNVFiaGVa?=
 =?utf-8?B?MjM5SW1LbDYzZE9idFlnQlhqTi9SMHNxS1pHSU1QVVBKQTJZQ1FieHdWRFdx?=
 =?utf-8?B?MWkxRmtEQVlMSzUyKzE5ejB1ZHhqVHpPeTk0aFRZT09qckU1NTl6RWM1VWJ3?=
 =?utf-8?B?WXhmUE9zTW5XYXF1T1NNUlJielJTeldicGdVTDZaYVJ1WW9vdTlOR0YrZUNF?=
 =?utf-8?B?a2Z1NW1XNVNlbnRZUi9tbFlMdkFNSDRkc0NVc3kzMml3N1EwcWhESUd4U3NW?=
 =?utf-8?B?UFVqSVhWRU1MYVBibGFzS2pXdWdPell2QmpDejFCYlFKa0o5TTBId05SOTZ5?=
 =?utf-8?B?YW1GV0tZQ1hCT2VDK2pYeWYydGVxZFdUS1R0MlBrcFl0UnNINDE4d1dVRmVC?=
 =?utf-8?B?Q1daNnFZOGw4bGZpdzdiRit1cFpGT2hGeXQ5VlRiV21JR2RKR1phdmhaYWly?=
 =?utf-8?B?WERwRG1vVDRBRm1tRldWVGFhNHFYN1ZzQThmT1dtVkpadk1xZjk4ZkxYTU8r?=
 =?utf-8?B?MFhCZlhJdWw0LzAzR3lLdWY1aTI0eXdrRnlYOTZtTTlKUHdSWFJsTWxZcE8z?=
 =?utf-8?B?VlgrcTBIVlJPSDJreFMyNzFwSGpKVjMzR1BEN0NEQUlqU3dYeGgyaHRMaEQ4?=
 =?utf-8?B?ZEtPbmhSWFNXckFPc084dzFQOUpTWXVlZXROcUdKTVBnbGtCcGtiT1pBWDEw?=
 =?utf-8?B?VWU2T3RnWHYrKzVMV2RBWVBxUUdRM2RnaUNDYnh5RGlGbE1sQy92NEF4VVZP?=
 =?utf-8?B?ckRvRlE2YWRyaHk5QWdIQ2cyR3JtS2ttRTFJMTZiN2tWc0xjMDA3Sm1qenQ2?=
 =?utf-8?B?Mm15Rll0ZnpCL1YyQ0JUcWNMelNqRkdFbE9rUnFlZkE5Nlk3SG5PcHkyN2RR?=
 =?utf-8?B?NElBdW1ueE5LMVQrTHpnWFJCVktMZDlDUEtaYXE1VjRUNmdYZkxubnNQRTI4?=
 =?utf-8?B?V3FWS21qZkg1OWV2Nll0Q2NxMk1uTDVPUzdaanVpYldwcU9CQktzVC9FWjVp?=
 =?utf-8?B?Wkc1YS84ZGVFajBkaXFiUlAvUGo5NnZtcm5ad1ZYT1h3MzZMeHFSTlprM3l3?=
 =?utf-8?B?VHJhclNpWkJjMkNoYWthY3RjSndvWC9JVUk2d1Z0S3pQUytoYlVCZXJaMjVq?=
 =?utf-8?B?YktPWWNLZGdkV2lvVGJmWm1MQllPeUJVM0JvdElmMFNjZzdNYVRZNGVhS3Jp?=
 =?utf-8?B?cC9tRmtnMmN2M0ZOUEg0b0piTFJZU3ZjRDlwa05jYm40amFPVXBtL3ZXWDFr?=
 =?utf-8?B?RFdxZndWZGx6cG1UbjJNdDhNUk9qY3dVT0l3Wkd4WEs1M1RjNXYyeklQNi9w?=
 =?utf-8?B?NENvTkplbDdvNCtZN3ZlaENIVDhVekdRU2RDSWpyZ3ZJVk04d2dWcFU0WDF6?=
 =?utf-8?B?ZCtwTDA1eDZtSC84dHBFdVpPZzNoeUJKVlBFRkc1ZFBrQ2E3ZHZuV0pzSnpq?=
 =?utf-8?B?WGlzVnhRcW1ZeUROdmtaU1VJR1pqL1ZVUjdmRVR6RTJzREZDc2phbUx2VU9R?=
 =?utf-8?B?bEFKcUpHbTVmdVFCekNKeGRZMWdoNThSTVpBKzVkV3hKcXBzUDJIdmVNZEN3?=
 =?utf-8?B?UEpNenBpMnhqTEdBNlZwRkU5ZzNkQWlMTGpZb1IwS1VlNTBuNkVQdy85NVUr?=
 =?utf-8?B?Y1plTnlsUk1UK1JXUEhyVXFvS09EQUhoLytJSXRKNW8rZXdBTHd1SVN6WlJH?=
 =?utf-8?B?anU0bGxsbWQwc1RodTdHZjJ0eXd1Rm9aUXAra0d1eE5xaVJOV2R6dkp3TVBZ?=
 =?utf-8?B?MWRrRVg3ekRWYVdaUzlSL2xPUGEwUkt6WVJnajJINVh4TG5Sck1vQVNsaFpQ?=
 =?utf-8?B?ZzRkWGxIU0hRL0Y0RE8xeStNdHBaVU5kMDRkd0pQelc0dUxDdkRXR1prd2Nz?=
 =?utf-8?B?cHI5K2QrY1JsNmdLQ241QmoxeGloVUJBWllHVVpsU3lIU093ZWZXVnNrMGRq?=
 =?utf-8?B?Y1gxT1Q1T3pJVWxscnNUYUhWQ3hZbGpvaHdtYUFGdTFLMjhFeW5JK0c2Rkx6?=
 =?utf-8?B?VWxBNWU2VkhzVEc1YzNjTTFTOTl6UEZaNERXVjNUc2lUZlZGS3ZmMlhhOTIw?=
 =?utf-8?B?NTF5ek5FL0RrbHI4M1lGR1BNVjRJV05pTlJMQnkzMkI2YlVQcWtja2tCdzIv?=
 =?utf-8?B?OWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BCAFE21098CF440B88F0C0EAC3BFCB2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9fea370-87dc-4ae6-03a6-08dc81acb3f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 20:03:13.2414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2HPaaxGu3FkXGY954HMTaBYWTIffFVJVH66Jkw6XuZHyUgthjkfVFexww+ojH5Km/460+10Nu3yy5R/9e5DjNdTi/zOh7LhDtV07xVx4jds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5764
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTMxIGF0IDE0OjI5ICswODAwLCBMaSBaaGlqaWFuIHdyb3RlOg0KPiBS
RUNPTkZJR19PUFRJT05TIGFuZCBaT05FX09QVElPTlMgYXJlIG5vdCBpbXBsZW1lbnRlZCBmb3Ig
Y3JlYXRlLQ0KPiBkZXZpY2UNCj4gYW5kIHRoZXkgd2lsbCBiZSBpZ25vcmVkIGJ5IGNyZWF0ZS1k
ZXZpY2UuIFJlbW92ZSB0aGVtIHNvIHRoYXQgdGhlDQo+IHVzYWdlDQo+IG1lc3NhZ2UgaXMgaWRl
bnRpY2FsIHRvIHRoZSBtYW51YWwuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMaSBaaGlqaWFuIDxs
aXpoaWppYW5AZnVqaXRzdS5jb20+DQoNClJldmlld2VkLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hh
bC5sLnZlcm1hQGludGVsLmNvbT4NCg0KPiAtLS0NCj4gVjI6IG1ha2UgdGhlIHVzYWdlIG1hdGNo
IHRoZSBtYW51YWwgYmVjYXVzZSB0aGUgdXNhZ2UgaXMgd3JvbmcuDQo+IC0tLQ0KPiDCoGRheGN0
bC9kZXZpY2UuYyB8IDIgLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kYXhjdGwvZGV2aWNlLmMgYi9kYXhjdGwvZGV2aWNlLmMNCj4gaW5k
ZXggZmZhYmQ2Y2Y1NzA3Li43ODFkYzQwMDdmODMgMTAwNjQ0DQo+IC0tLSBhL2RheGN0bC9kZXZp
Y2UuYw0KPiArKysgYi9kYXhjdGwvZGV2aWNlLmMNCj4gQEAgLTk4LDggKzk4LDYgQEAgT1BUX0JP
T0xFQU4oJ1wwJywgIm5vLW1vdmFibGUiLCAmcGFyYW0ubm9fbW92YWJsZSwNCj4gXA0KPiDCoHN0
YXRpYyBjb25zdCBzdHJ1Y3Qgb3B0aW9uIGNyZWF0ZV9vcHRpb25zW10gPSB7DQo+IMKgCUJBU0Vf
T1BUSU9OUygpLA0KPiDCoAlDUkVBVEVfT1BUSU9OUygpLA0KPiAtCVJFQ09ORklHX09QVElPTlMo
KSwNCj4gLQlaT05FX09QVElPTlMoKSwNCj4gwqAJT1BUX0VORCgpLA0KPiDCoH07DQo+IMKgDQoN
Cg==
