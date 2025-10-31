Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B93A22B8B0
	for <nvdimm@lists.linux.dev>; Fri, 31 Oct 2025 20:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943347; cv=fail; b=DhGfp/Bmnhc+CQVDKpZDizKKuesSUnrS3x3NWfypX+dxK4Arr+bQEwZupOKQOEaRTTUf6N3Hbkl/1HzAXc+w1HfFkmMv06p0S6QxD0a2icQvZ6H7QiVEx3+WGzCeYAz3ypcjpA6kn54RIW2x0iQRWWBVIqm55VWwe5+gY7fyW70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943347; c=relaxed/simple;
	bh=kJ5shn6LqD+IeRYhoTD35y8zpbq4NEPPiO6dlDmwVPE=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=r6wrK+/16xSC6KqCirF+DUy2UoiHeCmtDlvLpazo8+FrdpSOyh48mS5z8tjS+ZWNJylGs14hgMkqNycPpnjGV2p2v7YAlGrTRc2pwC3DYcsH82bfFzc/mR+2YncRsnSs6r6j790ufrHKZy4EdbWT6cP66+Uehu3XMX/hGcbIyps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XSwn9wTM; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XSwn9wTM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761943345; x=1793479345;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=kJ5shn6LqD+IeRYhoTD35y8zpbq4NEPPiO6dlDmwVPE=;
  b=XSwn9wTM4pmO2wopPfoBhUCDuVxBcbvm17o9CLaRDm3qzEpbCMszOuPc
   uwTGIA5+T60H6oi3WvIpvGJF9Uo4FdpV3zrnQ1hguSoRetnxxFdQONBw8
   A62hnTUDG3y32yzchzrFBFBMm6bjqwpM45N/l25ztRHEFH/6yiT0OYNAo
   /m61JF+RB8wGTpBY2gR9DkGIfxKOyd+a5xp8N0wuvXA2C+p8i1uQ0e6B7
   SWL41R/PmeolmEtuRiq6hNjMq+46KwN3MRRvP4NQ9Th6rLX0KJVRf1qhy
   AC0WTtCI5aJLabQ58/lmdsZM6H/xszkqYFZqHBuh8qt07Yg8n8tld7/CS
   w==;
X-CSE-ConnectionGUID: NdeySOP+Sx2qA/baKqM6Iw==
X-CSE-MsgGUID: 5o5bt1ZBRUeJ1PN1HFwnVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="63999937"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="63999937"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 13:42:18 -0700
X-CSE-ConnectionGUID: LxZb+52+QSKNAsPnsSkXaQ==
X-CSE-MsgGUID: wnaUA2DaRBKTMpDJQ3KaYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="186659105"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 13:42:18 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 13:42:17 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 31 Oct 2025 13:42:17 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.36) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 13:42:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w9lg9lHTWF6rsZRrGeqQvYZ5+RB8kchERsbzGpbgvbY3A68hpt3vZ+bALwCQCRFT3dHI5MxPO927VHAKIO7x6QZNU/n9Pv70mTHjvwgIZd9fLtHewrNAZPnYZ5DsL0uNXrUl2ngNs1TlNtfr3ZaL7FYPAnxIzoHckOCbIPCZKArNE/GNtIrr/GFZO1tQdLUJ+3kEd2yWODUcGQljGDMCXtdEQItxKcpBWFZ665YMar590XhtpmcPVaykUIrxLkDupMewFSYW21k40kPVEYclnL0bb/F9ewRJ6F74+qFcy7IIGsbBZ0OKoHZ81UeYDit4ExyXUwzhl5ukMmu0A1re4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hYxrQXil8Ms+BHsIiQKPtCkVgsKrNAEUIJc6qS53/j4=;
 b=N277H6+skmnXzXIeMAM9YQqwp0doMiirqbJpphiRuRQaqx3Hcbnznk2l+OUgy/4L1nXeOHku3Z9zGvBRqfnYFhjCqZoV5+1epGu6PRASbuu9eKKDStlg+nVYs9AnCicMeJ+igpcJFruX8XkwgjW+xm1Wkrwk1t1fTOf0iQCp6zVCVzRzfjAatlnXH1hOhtwI1ObLiwNOCxDj5dwo7DojvODxD9fFwxuHUkbSfDjQ35MzKlnwWHX9gpwdt/nRotLSUB7OC2y4iXnOAvYdLIrC7p3xCbveX/Q5kJmpNILK+hnCGqqmlEzoCPeiJr6X0T1gFIOCFBnfLLepLG5qFmEeFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB7340.namprd11.prod.outlook.com (2603:10b6:930:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Fri, 31 Oct
 2025 20:42:14 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 20:42:14 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 31 Oct 2025 13:42:13 -0700
To: Alison Schofield <alison.schofield@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<stable@vger.kernel.org>
Message-ID: <69051f256714_10e910054@dwillia2-mobl4.notmuch>
In-Reply-To: <20251030004222.1245986-1-alison.schofield@intel.com>
References: <20251030004222.1245986-1-alison.schofield@intel.com>
Subject: Re: [PATCH] tools/testing/nvdimm: Stop read past end of global handle
 array
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::23) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB7340:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e020151-29ee-4ecf-ed1c-08de18bdf94a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MHU1eWNQc2puZkxzc2FYV1hxUXNFUmxicEdvVFhNbGIzY1d4Ukh2S3FzalMv?=
 =?utf-8?B?NHFRRjhGa0k1Nm0yZ2hIZjh0cXZSdnRBdHBSOGV4azdDWkhGaVNsUjFYcDNM?=
 =?utf-8?B?VUY2TkVrWFc4VHNiaWhFdmloTURXOGtEd2J1bExnQU16dE9QT0ZMZkszaVNX?=
 =?utf-8?B?SXJTUzFmVHNEWFo3UTFDbks5M1l5MWlKM25HdkJDYU5paGVMKytySEN0OTVQ?=
 =?utf-8?B?V2d1bEhxT0RyK0R4amtDSXBKVC9Vd2tESEI4VS82SHloaUJjV2dFVzVScHMw?=
 =?utf-8?B?bWNNS1JCWGoyUG1xb05RcVRlNGVBWmkxUGs5UzFZWG1ZR0ZuYUZFanBKSE9V?=
 =?utf-8?B?R1VwazhFZFFVZklBamx2YmhsUkVBdmFjMEdtem1nT2VScmVFOUxuNjZHSk8r?=
 =?utf-8?B?bUpYWDllNDRzVWtHb2Z2bDNnU0NRdU9sUkJIRWVFcFJ4SjZpT29haUVlaTJH?=
 =?utf-8?B?KzZRUlhBQ0NkZ3BlQUVOMHczemg3NDJnRDhTM2FWVmlZb3hzOTJuVTQyS1Rm?=
 =?utf-8?B?RzlRQmJ1enJMeUhHNXRaUlgvTVp1OTRxVWxHSTVmWlNCdzFOUGF2NUdXbDc4?=
 =?utf-8?B?Wjg3R0x6akIzZXVmMGFTWGZQbFlheWlPNFErK05MSit1K081a0c0MEJIY0ZS?=
 =?utf-8?B?QUNzVStlZWhxSjN2RGpCSUdzdC9EbFdYQ0IrREd5V1hleTJGN0E1VmxleGFB?=
 =?utf-8?B?cm9VVGNiSHlIbGhkb3AvRlBkMGhLMXhwMVBaSzhNZEpSdUFuNTBxbzZHY0Jm?=
 =?utf-8?B?dy9oeHBLanFncytTTUE0U3RCeGh0NnRtNUE3aTBKSUdBUk9pdm85aHFlRm9a?=
 =?utf-8?B?VHhvWmtjRFJaZXNITzFrQUFjOVc3ZlI3TXpSMy81WDV0bW16dFRoRjhIUENu?=
 =?utf-8?B?c2RwdE5IR0dkbUpJZjZSY2t4WmF4TWw3R3dBaGVPWk9LL2pYajR1QSt5STlw?=
 =?utf-8?B?ai8vUUpUeEZXWGc5azg0MGoxd2piTnNFZ3NhdmNDbUVlc2kyUUI4YzlCZVJa?=
 =?utf-8?B?YTcvUHJCTzF0RWtNdXQrRzFaTHdBa0VRb05hazNQNXlKOGY2SWlEam1sRFBh?=
 =?utf-8?B?MGVmYk1KUVpDTy9oaTVScE9Qd0UyTXN4Zy9qVFdHczZjMUoyYWFiQUFHNWNR?=
 =?utf-8?B?SkxWbHgwOHAyd3R5NzF0ak8vdThsekt0akJQMVBjalJkQW1SK0U4NFRML2I3?=
 =?utf-8?B?MkxHYW15eDg0eFVad2NCZHQ0THM4TGxzRTJhd2FvaHJKQ21ZakVRcUVYMFlr?=
 =?utf-8?B?SWhuQ3hxTjllb2JMVlNrbXVOUVhkOUh2a1pIZHhneDEwYVRKRC9tRE4xeGdl?=
 =?utf-8?B?dmU1V0x5K0pqdEg1UDFGV2JHSTg2YXhIOWZIVEM4WXZOWXJGSWhHRHh1UTRJ?=
 =?utf-8?B?Ti9JR25NTlhrbGxDcUF0VmhXNlptb0Qybld1bzNLUkc1Zmx4Vjg4YXN3MDdY?=
 =?utf-8?B?aUwzd0NlcDBtS1BESG5UK1B1L2JyUUdUejdIcUpkdTByWS9BM080cEppQnFI?=
 =?utf-8?B?NlpXaW5WanRoUllid3dKZ0pvWitWelgrOTN6VG81VzY0NEh2RWZYK0RlTnAx?=
 =?utf-8?B?SmZhMGFEbU91UERXbU4zdWx0Y2dXSTFRSTNRU0JONDZGTkM2Sm1rYWFwV2tO?=
 =?utf-8?B?akQ1aFdHQjB1aXg5OXFIcDNiMjJ1bTA5Y3FJWndLMFFXU2lKaTNpZHlUc1Fq?=
 =?utf-8?B?QVpobnlpcW03bWZneEZvdFdBZGU2WlZDNDZ5Y0FndjV1aWVFb253eXo2UlRF?=
 =?utf-8?B?TzNmaExyOEV2UnN3S1QwRDRqUWdTbFk1d0w2V0txSU9zRFc4ZGtGa3FZMndt?=
 =?utf-8?B?YzIxM1Z6S0FnUncxc0lBanQ4VW9UU3gwZ3RTeUFKNkZTN0dkWTBCdGRNUWhF?=
 =?utf-8?B?YmEyVXJqdXhmMkZ6QnFscmk1K2ZjME8xMVRucVB4T1hCaXFrbnY0LzhBRmlS?=
 =?utf-8?Q?WBingAfvBicphyH0zJN66auw69qO4BfE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVE5U0J1VnZGdS8ycXg1OFM4a0xkWkZDTGpSYjlFOEZPWktkdlBmM3dOMFdw?=
 =?utf-8?B?eE9HOC9jazVzZ0NMckgrb3plNVF1UmpFOWdXS253V28zNFk4bGo1enZNUUUv?=
 =?utf-8?B?Nk16WjNyd2hPejBDMXkxVkFDOTdFYlFybHcvamsvdEY5YXNGZVo2NzFteEhu?=
 =?utf-8?B?NHMxRDcyREtBQnczV001bU9YSmZpdnh2WXFEY2dxY0ZodzVKZXdXVXg3THNV?=
 =?utf-8?B?K0d2N1dFWWZlV1NvRjlsNmFGNEtQNFVDS1VkSEh4VDRGY2ZlWDRTcHRCeDVS?=
 =?utf-8?B?WkhaRWVaWGRRYUVibm5tTndZa0pSblhZOGZKVjNPSzJHbGQ3WnhaMjRnMkRW?=
 =?utf-8?B?L2V0M1pLLzc5TjBqMVcxMHhGSjlCN08yRmFQWWttZUJsZ0RxNlZmMXExM2V0?=
 =?utf-8?B?T29oeEYzWlkrZkZGZ0ZYWVF5M2lmeVBjc25XWVpKOW4rcnMza0s3RUhmY29C?=
 =?utf-8?B?dkVyZk5SVFJtK2RmVmJsMnEzZEpIRnlyVFZoN28xSEJYMFc1VTQremdWSml1?=
 =?utf-8?B?NXdFVWUzMnBYOURES0ZkM1pnSkhRd3EzRCszbjlEMEVkbWwwY1VranVRRUZ3?=
 =?utf-8?B?Wld6MmFEWTc0R1d2d3RKUEhhWDJyTUt6RWRJaUY5ZXZ4RVQ2cmdHMTlaZnZK?=
 =?utf-8?B?ckxlUVJoMnM4bjk3OTFIRk9aaGpkRzR3VWY1NFo0clZXVWxsd3Fod0JDOTNz?=
 =?utf-8?B?L3NKL2pjRjA4NlhxaEJiS1ZzMU1qV1phUVRRdHZ1eUhQWmx4U1ZnR2phUFd4?=
 =?utf-8?B?THNFcjRNVWtLTWE5Y2NndnZFL29McStGdUFJTThNK0tmMWVIWUpYcDlmK3pU?=
 =?utf-8?B?WjdBeHpHY2oxa09VeGpBQkxRWmxYNTNJVE13M2x2eGNxd2NlVlkxT1pYTnRK?=
 =?utf-8?B?TjVPdld6ZlZnMnFpZWh2azB0UDZPQkIrN29GdFlwVnYxbDY1YlMvS3N0QlBP?=
 =?utf-8?B?dzJ1TDJqQXk3VW9GVmplL3NPcW5palRQQ3NjTWFRdmp4VmNJUHE0SkZ0S2Nk?=
 =?utf-8?B?a1VudHJ1alVhV0RodnNLSUs2OEpFNmFjL1JadVNxMVRDejc5MEJKMUc4Y284?=
 =?utf-8?B?N3FKR0N0K3VnQ2RrS0NTa1pQVktlbWdOR2dkZURvVGZCdW54bVdXcGZjQ1d6?=
 =?utf-8?B?Ulo5SC8zOVVvZmhMQk1jTzhyZ3d2TTVoNHNwSjdWUm9BL2llQy84SFhVVGtp?=
 =?utf-8?B?eTNUVDJhZWVCQ1VRZ3lXYzNaM0FacUt1S2pHMEFITlZOR3JsOG1FTkpVVGUz?=
 =?utf-8?B?bXcxbXhxaU9rQkdDdTgvNUFsV2s2V1JZeFJYUjZrbG5HcUNpNERnOGhjMGJ4?=
 =?utf-8?B?cTNKTkJXQ2xPSnpnZytMNXpSd0t0azBZUDVUc2dONjVOc1Mxa1lHK2lhcEx3?=
 =?utf-8?B?cEFETGRIRVp3QWJ1d3pLWGloOTc5Znh1UHFvaWtOMWRnbUJpTTh3YTNSU1NB?=
 =?utf-8?B?c3Y3Tnk1YmlzMUtjbFJpd1RVWitmVU5EWTl5dzdyY3lyRFhOTUxYZXl5UE1i?=
 =?utf-8?B?SmFzUjVTRHFMbmIzbXNoWURYSXZjS2E1T3Izd2J1WER4SlZ2MjdRdUVyRlVp?=
 =?utf-8?B?ZDRCbEx0YUkzV3RPUEx3c1V1eTFYNVhjMmRwWUNESWlnZTdyRHIrZEIvcXln?=
 =?utf-8?B?bG9iOUZDbE54QzFUVEdQRytTTnNRNnBlc2F5OUV0ZElOdEZYRXpDbGJubllt?=
 =?utf-8?B?My8zQ0pQdkorSGlxUXQ5MisrNHl1OUgrYUN6L1NSL2s4a0thUnBCcWpBeHhU?=
 =?utf-8?B?Syt5Skp3MlEwbTl2K1FqQ29wY0lsSHdZeFgxKzN2QUovZGRMcVREdGtac3l1?=
 =?utf-8?B?VG5ZMXBhdjU3MjljanNoTXJacjhLcng4MlBDMGVFVGE3Q01GMEJSOUpKK3NO?=
 =?utf-8?B?QjZOcU5VZ0RES2FhQ0JoeXhPZFYzU3dvSVhEN1BJNFA3VC9mTFBOVUl5WjNj?=
 =?utf-8?B?UkhBYjBCbXM1S1dhN3lSdWR4cEE0dmtSOGVUSlpuaEtXYURBR244c1h3dWw4?=
 =?utf-8?B?WWExQlhZRnNWREtaZUJicURrMit2ekJnUDVKN2RhcTRpdHR3SE1UR0dBMFJ3?=
 =?utf-8?B?WG1TR2FFanloWkVJU2g4WmRJR1dQNktxQk1jRzdiamhGMFMyMGsvOTFlVHVQ?=
 =?utf-8?B?K1M3TDhxLzEvZ1lwVzU3NU5oSWk3bzZFMGZ3cGNLK2UvMUZLeWdPVHZQb3Za?=
 =?utf-8?B?Rmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e020151-29ee-4ecf-ed1c-08de18bdf94a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 20:42:14.6331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEGpGAtcKVtvbK3m34zG0poGyWi3Akj1LVluJCaPvk+aI4O0YPLZPP0OyB7VI39kOjIUi8CgNGZ6VkuWexlK4M5OCbur9rhMJNxbWyS6u4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7340
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> KASAN reports a global-out-of-bounds access when running these nfit
> tests: clear.sh, pmem-errors, pfn-meta-errors.sh, btt-errors.sh,
> daxdev-errors.sh, and inject-error.sh.
> 
> [] BUG: KASAN: global-out-of-bounds in nfit_test_ctl+0x769f/0x7840 [nfit_test]
> [] Read of size 4 at addr ffffffffc03ea01c by task ndctl/1215
> [] The buggy address belongs to the variable:
> [] handle+0x1c/0x1df4 [nfit_test]
> 
> The nfit_test mock platform defines a static table of 7 NFIT DIMM
> handles, but nfit_test.0 builds 8 mock DIMMs total (5 DCR + 3 PM).

That does not sound right. NUM_PM is not adding DIMM devices.

> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index cfd4378e2129..cdbf9e8ee80a 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -129,6 +129,7 @@ static u32 handle[] = {
>  	[4] = NFIT_DIMM_HANDLE(0, 1, 0, 0, 0),
>  	[5] = NFIT_DIMM_HANDLE(1, 0, 0, 0, 0),
>  	[6] = NFIT_DIMM_HANDLE(1, 0, 0, 0, 1),
> +	[7] = NFIT_DIMM_HANDLE(1, 0, 1, 0, 1),
>  };
>  
>  static unsigned long dimm_fail_cmd_flags[ARRAY_SIZE(handle)];
> @@ -688,6 +689,13 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
>  	nd_mapping = &nd_region->mapping[nd_region->ndr_mappings - 1];
>  	nvdimm = nd_mapping->nvdimm;
>  
> +	if (WARN_ON_ONCE(nvdimm->id >= ARRAY_SIZE(handle))) {
> +		dev_err(&bus->dev,
> +			"invalid nvdimm->id %u >= handle array size %zu\n",
> +			nvdimm->id, ARRAY_SIZE(handle));
> +		return -EINVAL;
> +	}

No, I think the bug is assuming that the nvdimm device id is the handle
lookup.

I.e. this looks wrong to me:

	spa->devices[0].nfit_device_handle = handle[nvdimm->id];

...does something like this also fix the warning? (UNTESTED, not even
compiled!):

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index cfd4378e2129..5456f67b7e43 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -688,7 +688,8 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
        nd_mapping = &nd_region->mapping[nd_region->ndr_mappings - 1];
        nvdimm = nd_mapping->nvdimm;
 
-       spa->devices[0].nfit_device_handle = handle[nvdimm->id];
+       nfit_mem = nvdimm_provider_data(nvdimm);
+       spa->devices[0].nfit_device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
        spa->num_nvdimms = 1;
        spa->devices[0].dpa = dpa;
 
