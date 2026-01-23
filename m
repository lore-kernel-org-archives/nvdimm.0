Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09DC14B08A
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 21:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769202979; cv=fail; b=m4PSAzwMy+Px7emzCT8LiF09o16VzCcil+XWk7ZVcg92up9gqN0bv5ZpnwogwsgaaBgeMzRU4Tx2AGLurtwY8fV8O1q0rNljNrGmRXIDryO2uM6M1RBUYffT29eAhioD8FXtTAQwLfacvy8ankWJOZg6CyudNuPIJ2bou7UWaAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769202979; c=relaxed/simple;
	bh=t44gRx9Hu4XPKFo8EIb9IDxJXpupCSgSFTAYKgpqS5w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kuo8GcTFGT1aFKDqTcOSMW41cyvLwAV0rvt+QfC3ur9g9CTOFOI/Hd2rcZzDQWzKo3MQNN64fd1xbYIAaJEc7+EPn8vN+2UOa5hEOcvbGXVMsBl8QV8YlUZXA2xnEqUhfxHnZIitFHZmQ6yLHh2aGBMPGvSftMDRCKhj9KGg5f8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WzyuNA7Y; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WzyuNA7Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769202978; x=1800738978;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=t44gRx9Hu4XPKFo8EIb9IDxJXpupCSgSFTAYKgpqS5w=;
  b=WzyuNA7YuvsX0wt2AmjkCTTTGIa+1G3qfP37WsH7wJqXVCVWFazrXMlK
   EPBP2Xl4m8t0y69CRiMRFguR3Gz+6/hFxsHIdZ2Wlrw3ZsMAuq6tVJA16
   +rR9yiu0kY1ziGDPHnR+QSHx6mWrOO1IvPSHhyoZxeOOZbGFPjsluWc79
   WALe1vWRnJXkVARRv5wtlsIzv/PVdV32rQBrAaaYBXWwLCuL9qs4nNpdQ
   1FYlKf8XjV/F6LeBihDJjFe74A3X2vXyjia384sj6xQz7PWiVv4j9tAHF
   n45767V8fS9gibMgOUV8zCug3EsXqRvH95F4Nb2OqD3cgmhv8aF+ZNuu7
   A==;
X-CSE-ConnectionGUID: /AWdy/HsSZCvThGvj/okog==
X-CSE-MsgGUID: mT9AzM4QT/KPzE5uy0KZeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70368005"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70368005"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 13:16:18 -0800
X-CSE-ConnectionGUID: k89fArGRSM+aN9s0RRndag==
X-CSE-MsgGUID: H7+vAgjkRgGqKKlnNOY7pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="207544353"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 13:16:17 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 23 Jan 2026 13:16:15 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 23 Jan 2026 13:16:15 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.48) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 23 Jan 2026 13:16:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iH+YYdvTWLPy65dfL/ai0mg4ctIEmx0j5BHRWLD6VOAXu04ryVd1obEX5HjnrGmRvia7311QRPJouYmz3cQR85alDLUcyjHHCxVU78Yd5g4wZIXF58jjAEfawI0BxrLg24wNqf1L+DXKMFCpcZMq8IDdtJ0hr1jBcn3bpzd1Qca0whm+Vv2U8aOsOiHeav7nEPk7OJIn1C3FU0XbHjfJEo7LGscct5vYQHB8gnh3NIYA+p1FdlRcNObXbkSsNsSzrxNdygWwFhrhSJXuHDxVOtcLc4W5nk9C7j7rhMj6sStZF0vtQNeDUoRhJ+p3kYSnbbpyYuu2mdgxrdu//gxswg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ouP5uTSEQyzGJANihVVoNNV4MBoCMZxwx2JO37wk9Q=;
 b=DW2sGK+u1Vtl82dAfO/SfHo5URpenBiY+kqE93FLoHARKuZ3emOWzXhpWSR/UO4qqHHiwfp8DFwU49khUJ+90TEz59idvRZRmCdkgqZFWTA8Q35AE0j6+wmnBrTluNLGegj0ouvAPOM5//Ap2F39ygws+yNhl13E1rigpMy7VzNjrDhb0yT9/aNtWADd8Z7RJjHTL7ZtXdCqaJ9oGko0PmMQYnUTOA4SBJDLuHa+YCAmqbj8FW60HeV/kNlZty2e6gaRI6T79TCEKOuT6dJI5WaaaBnI+z4aQcPH1+i7/5oBwsTvpsGGeLOw1nF30s0mh7CUIYiZ+pffgJfeUtwIoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB8319.namprd11.prod.outlook.com (2603:10b6:806:38c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 21:16:13 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9542.008; Fri, 23 Jan 2026
 21:16:13 +0000
Date: Fri, 23 Jan 2026 13:16:10 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V6 00/18] Add CXL LSA 2.1 format support in nvdimm and
 cxl pmem
Message-ID: <aXPlGrs12BdwgGkG@aschofie-mobl2.lan>
References: <CGME20260123113121epcas5p125bc64b4714525d7bbd489cd9be9ba91@epcas5p1.samsung.com>
 <20260123113112.3488381-1-s.neeraj@samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
X-ClientProxiedBy: BY3PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:217::18) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB8319:EE_
X-MS-Office365-Filtering-Correlation-Id: 932e3774-1ae8-4863-89ec-08de5ac4a392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aFcxRy9ZU2dRUUxLT3YyMFExRkh2TnZ0ZUFGUHFwRmZlcnkzeEVxNjZNUXBk?=
 =?utf-8?B?OWZmbXBJN0NKeUFSelJRVllJb1ZmSklZUURVRm43YjJKY3lIZWhvTGY0cVYy?=
 =?utf-8?B?TjhHelAyZE9XTlVHRXpUMEpmdWZuQkx4c0lGeHI2dThsb0txU2NvNFBtVzMz?=
 =?utf-8?B?YjYrblRFVjcyTkhMS3RSVkVVbWFYaDlRZjBFSCtRNWZ3VnIwa3FOKzRDWXFa?=
 =?utf-8?B?THhpeUhuQXhUYitwdmExMWltc1RDV0J5aU1rSXBER1Fwd3p5VDU3cEhCS1pV?=
 =?utf-8?B?aWRUSkRnQjVnVlQzTUkwcXUyOTBNVTBEb2FJbEprZmpxYmE5SGNQQ01uZ1pS?=
 =?utf-8?B?M05YUlZvQkNDby9vckIxV0Fyc1JROXdEbTlISmJTTG01eWFkRDNiWktwTExP?=
 =?utf-8?B?Qk1KKytmSWtDRDJ4QmVZY3FoenUvRUdna1hFVWJ3aUVmZ1VOc0NaYkRrU09q?=
 =?utf-8?B?eit5NlRJTnlxYnZ0YmNzdElsY285bW5DY0YzU0luNWJjLzFjMUtIbFNsWkVh?=
 =?utf-8?B?MTc4b2lsU0U3dStlUENBRW9uSzVFODVXLzlrVTkyWWlxeDczSWM4LzR3MU9q?=
 =?utf-8?B?UytNNmVCWUZnUE5BOU1xNzBDY0VCdnp6cC9sR2l3ZSs2ekNtYU82d2xtRVRC?=
 =?utf-8?B?QlB3MnV5TStxMlhhY25RVkd4S0tkbXdTWUp2dThBeGtWU0duQTdHTE9LTEdU?=
 =?utf-8?B?QVY1SW5pUnJ5L3lXSFhtdStaOFJIZSs0NEQxeWxQc1dUQjRxdlpSczA0Q0gw?=
 =?utf-8?B?OFI3RzFEbGZUMWJEN1ZSWmR1cXlRekUxMmdRNXJNeGN5a1VEaUduMEFQbmxL?=
 =?utf-8?B?bTQ4T21uQkthUndsVzNzTjZwN1I1bkhYT29QSlZRUFJ6MlVzZVMvQ3pScXl3?=
 =?utf-8?B?MnJ3YmorcUNoYmprUGFla2toUVZ2MXhRYnpWd0dIZzNyR2tTWW1VMGVqSU8w?=
 =?utf-8?B?VnFGQmFFVFJ6S3lNRzZwd3E1a1dxUkxhODk2SWJhdUhRQTlLV3dNcWNGKzlB?=
 =?utf-8?B?ajJZekRHWWR1cXQzK2ZuY0xHOWlFRVFkWUw4NVo5Mms1ZzRROFJWYU90WEg4?=
 =?utf-8?B?OXVtN0xqQ3U0VWJNT21XbGxtdW9qalpIVXVhemxYakoyL1gyMng2WWR1OEg0?=
 =?utf-8?B?UEROVU1zazY3MjErSVZwbjFXSVQ3aFdnNjFQMkJJMVhwMDl2MllGWVdJanBk?=
 =?utf-8?B?V3JQM0pucjhyd2d6RjlyVDVHa09VMk5GdGprYnFEaVl5THFNcDFRS0tPcHZ2?=
 =?utf-8?B?SHhqQm0xLzFWVEI5R01RUzQwNkdxZU9YRWJZUEVsdnVxNEZQaTB4cnVWS2FM?=
 =?utf-8?B?QVRPZ2VBemwwNzJaZjd2eWdCYytDN290N0NoYUFTRFp3YWNITDN4d1VoL0cz?=
 =?utf-8?B?SkFGcC8vZmI2TmxGMEFJTnRKczRJUlh6aDM0RTNMWElaNUppc0VEKzZ6SUNO?=
 =?utf-8?B?RFIrbDRVMmRJdTY4aThTN2ZXU1RNY2JLWityczFpRE9qYXg4VXVnbGRSSE8y?=
 =?utf-8?B?ZzY5ZTgrYlAvVk5tVzRoYldxc1VydzlST1hmMXUrYk85dnFaZ1VPSlBma0FB?=
 =?utf-8?B?aVBvblRSenVnWHh0Q3FyM20rNVJpVGcxZlJNQzk5UmVuRFN1QVEzQ20yQzhF?=
 =?utf-8?B?UmVoOUpUOXREZWFnM2NycHFKeDhRSU1QbmtwWGs2eXN4dHplNkw3clF3WjJC?=
 =?utf-8?B?YzNiZjRCRFpMM0l0OElOZmdTYlNrODExWEI4ZUNUaGZHK05tUmdUTlVMTXc4?=
 =?utf-8?B?NUQxOTFvZ1pIN2pIdUszK3JjTnJrSVFWRTFzNHNmOTA3dnFqN1lJS2kySGhh?=
 =?utf-8?B?aFBqNVprVzJhVzVyc1ZoYlBGTmZvcFA3bjY5U1hONU5Ca21UTXgvQmhiTUZl?=
 =?utf-8?B?dnNPN3U1ZEF3VUpDdXZETU1ObEJ1T0ZoYXc2L1dSTFJuL0c4VDFHT0txak4v?=
 =?utf-8?B?cWZ4RUhlVVpLckdwM3VJOWZnLzUzOVgzMWF3VGtFNUhrcFVxY1hkdmt5ZEhs?=
 =?utf-8?B?VytIcE4ydVZtM0tjR2dpdGFUMlZRQ2xaLzNvNy9xSVNLYldYUW9KSnhoQitJ?=
 =?utf-8?B?N3l0K3hoNk5NaXRYSU4xUVo5eWIrMzc4U0NJNlplSnhpc0J4d1dyNGpYTDh0?=
 =?utf-8?Q?AsXg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eStSK25qQm1WTlBkTUNrTTNGWS9jWTZMbjIvOTdjSmtleWZxUFpGV2kwcDBQ?=
 =?utf-8?B?ZHN6dXNsWVRpbmtPNVFEM3NNSTNXQ1VMN1A5SDRBckxYU2RVMGVlSXZQcmNO?=
 =?utf-8?B?a3JnTUh5VUxsSURNSGJ0UnNTUHpzRjJIdm1oWGxzN3NWVHNEQXhVTHlPR3dN?=
 =?utf-8?B?Q1V6UlB2cjZ3ay9Zb2V3dU1XaWJCakM4VnFobmVjcjZzZEtvTllhZTE5ZnRk?=
 =?utf-8?B?L3A4V2NMSy9SMmNhZ2dPVnhFMEFycjFFdlZYS1JZbzYyRTRxdE9iNVo3eTFs?=
 =?utf-8?B?NkJ5Y2E5VUZ6dm8rc0ZEVXhPeFp6ZFNLenU3SUpiVW52ZXlIRHY1Sm92WFk5?=
 =?utf-8?B?RkxzMlE5dVlLbWthTklOZzVyR2lZSnNUeTA0dDdmcXlBbjJwNVpFWmZUc2Er?=
 =?utf-8?B?aWpvdTBUMnVqL0ZKcmdudEJNMGF1a3J0eEV6SWdHWVZMaTBXVFUzY0ZNMkIw?=
 =?utf-8?B?Mk9ob0N1T1dsZFlvbFZ2Yy9PNmhldlFvR3E0OFlSQ3RXWXB1MmZtM3lxSjN6?=
 =?utf-8?B?ckx4STFDTC9UaHMveS9HTGhEK0xLWlg4WHpxQXNzUWVZOFpDWTVhSVNJSHZz?=
 =?utf-8?B?WFZOUklQbUd2eTIva08vY2Fxd1NGMTdDT05VUjNGTVlOZk5OWXhvOEprTjdV?=
 =?utf-8?B?YjBEazY4ZjRMRkZwczJsY1llNEM5UkRJMVlra3kycHBHL2NQOGwzeE96enRQ?=
 =?utf-8?B?Y1d2dnFHK0xtQURqV1J4eTZpU2FhVVZ4R2hwc3B6SEpKT0hRN3dZM3FMaEIx?=
 =?utf-8?B?TGZLRS9FWFpRWXc5MFRZVmhQV1Y4M0JtS25vNGVxM2thZzM5OEM4NTdkeFpL?=
 =?utf-8?B?bkNwYnNjYm8wMWltTWJqV3hleWU5WGVLUCtsL3lweEplMDIrMDZWMU1KL2RM?=
 =?utf-8?B?dnR1Z3A4cEZERHhvcytac2JpZDJFQjVSTStZaTlndERTdnllRkZJM0I0OUdH?=
 =?utf-8?B?UHBQa1lpYU1GNjJwU2FPQzZqVDlSRDAyZW9NRFlmaDdJdDFvWjNBVmwvVWkx?=
 =?utf-8?B?ZnJqKzY5OHZubWtSTXFRNnNYeGo3THM1enhlVkxNSm9DMUYzZG5ka2VES3NW?=
 =?utf-8?B?REdEbDIwYVlXdlpqK05IcUdGUWNPSEhEL0VXZWdyOFBpcGsvRElaQjZUZlk5?=
 =?utf-8?B?S3NpN05Ya3VSb01malgvY2crQy9RWjBoMTI1UnlhMmE5K0tHaDhSWGtVbnAz?=
 =?utf-8?B?Um4rS2FRUGtTRzZwL2F4NWtrVmhXVW1sUlFyMUk1SHRzV1p0ZE5vbWlkYjk3?=
 =?utf-8?B?VS9kQ2J2NDVrZGcxVStxdk45L1lreEc4dllDZnBRTkN0TTNseTRsa0ZmdnhP?=
 =?utf-8?B?aXRCaVhUZE1Yc00xMms2Tk9PRWUrYXQ0K1ZqWE1yVTRieG1tUnJlaTN2ZURE?=
 =?utf-8?B?bllVVTE0QW5FS0NuNGFEdW1nWTJCSWpFNHI0MTM0cUhnb292ZFRqaG1UR25O?=
 =?utf-8?B?R2xydEVpTjBTU2NvSlN2bEZ0andGRi9BcXV3NkRUYktuQzhmeGdjVEozeFhr?=
 =?utf-8?B?SUJ5OE5oYjlOVFp1RC85VXdoYXNBLzEwM1ZlZm50VStFMjhFVHpHQ1pobTZa?=
 =?utf-8?B?UTNhZTFRTXVrY2c1cXFJcVRnMzhGb2gyaDZ3SmR4MjNJbzRaSzB4V29OYWU0?=
 =?utf-8?B?c1kzWmJRbzNTOWdXRjN1ZXhoNTFiZ0RkcmpXOGJRTDFTWHFzdnVrak15SWJx?=
 =?utf-8?B?b01nN1VTRXEydVd6T1VpbnpIbVI0TVZvbUpGeDRiSXZCaHBtTXhkTHZjTnQ3?=
 =?utf-8?B?YksxYml5clEzM3gvZFNqTExrbmRNQjEydGxJaHdrdmtFYWRCbDVsTHlTeHZ2?=
 =?utf-8?B?NVNmUHpld3RjaHRZdXdYSXNkblNtWWtXL242MGVhNVBnQXdrOW1ibTgxVjdo?=
 =?utf-8?B?Z0p2LzNuMHVrOTVadFF4c1pBaFB4YmdGbXk2TDZpTzRvdWVGdzcvVG5QQnU5?=
 =?utf-8?B?M2gzbDZqVklCQzN5M2RoelR2S0FYRUF6Z3hzMGdzRDhzNWFjL2xEczc3N0Ry?=
 =?utf-8?B?U2hReFNqTi9zWnQvYm51YXFLMWlkbXNhUnBmbC9kN3RwcHhETUh3aS96N2FU?=
 =?utf-8?B?TWpMNXBocGF4NU5RUnpMNDY3eFFWSHBRNnNXYWc0MTUxaTFEaWdPVFVuWmYr?=
 =?utf-8?B?ZXd1OFRvZWNESE5nWDRqSmpkVnEzNFlmMDlxYVRwVXBnNlBDL3g1eW5zczVX?=
 =?utf-8?B?Z2dsZHpZdE9Yb3RaZnlzbTRyZWM0S3NCRlFWU3BEZ292VUJUa1AxaVYyVkk4?=
 =?utf-8?B?VnhqQjJqN2RaeDNSeUtSbGU1OUtmVGpJUlhWdWZjWnBpbGhIVDg5SWFyUTg3?=
 =?utf-8?B?YmhUZk1jdWVlL0FiVWg0SWszSERkZmV2T1ExS1BvRGpRTytBSnlCNXNDMTh3?=
 =?utf-8?Q?gJjjAqHh85UT8oOc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 932e3774-1ae8-4863-89ec-08de5ac4a392
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 21:16:13.8736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KorkwyyOQqKi6RO5A7L6FxHwdS0FKmy1IdAHAFgog10E3h58YnweiDqF2LQwZAJPgPR7VkqlQ1ava+jKsmGcFGtdgYXTVOr5s6zAEAQQOsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8319
X-OriginatorOrg: intel.com

On Fri, Jan 23, 2026 at 05:00:54PM +0530, Neeraj Kumar wrote:

snip

> 
> Testing:
> ========
> In order to test this patchset, I also added the support of LSA v2.1 format
> in ndctl. ndctl changes are available at [2]. After review, I’ll push in
> ndctl repo for community review.

Please post the ndctl changes for review. Thanks!

