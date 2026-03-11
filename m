Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B416A175A73
	for <nvdimm@lists.linux.dev>; Wed, 11 Mar 2026 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773265082; cv=fail; b=Bp4OkCJdJZbwBq9AYgJb+T6wj4JwT6LipLYZCXmi8Jbim3AqOZttPWNySLMwv7KtLpDAzWb8tZiyom9ittUF0HqPxKGQ74qe50iKxBSvfBZScUSuMBafEd1N5OLcaOlVlGc/CbCqopasM0ENix0xj4mlF1q/4xBavc3bjVkEpFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773265082; c=relaxed/simple;
	bh=WqqclvgbgmBqrEcds3TrlYQH5TW7xt8X7CgLdOQzpsw=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=bgA3pGfa2f8VXsD3u12+bNOCz/HaIQ/djPPM4bwk8WcZRSZBAh2ipbjmRrdT9lYjhfm2AEZuFIuarfj/xCHcQhFFelpRKq8Pkh7s76gPGZT/vZauhr8Ob4PziwMdsG2UO2ZkYnPvGzr2RWrQRoqlAVsaK4FokKxav5VlRC253Yg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jBc5dvCT; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jBc5dvCT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773265080; x=1804801080;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=WqqclvgbgmBqrEcds3TrlYQH5TW7xt8X7CgLdOQzpsw=;
  b=jBc5dvCTC2vdtwwcpuPCuK4FPLkBpddLwXVZ+iGfiLjp7UPVM5IjEcXF
   m7QGcwOHDKCG/3UHiuCCK9jsa3qnrvh2cUs+/bhf6bpUjRLBepF39sOgm
   WJkKU1kZ9Ms/LqJZf19N42kbIXQFHyEgbQtAWitjC/yv16Y5pp98Rc6cF
   8YGg2NT3BgrvW/9Jk1DJYn+VI53UOF5YCI2/Iio2NSgSU9MCFRjarMvVP
   OwIcWIsDGBP2ikdMB3h8J8QqndQEM8aLCIjc5f6UUy5u299f1pasClNIR
   3DH+pwG/xK0A1llo1Ujw0X1Ov2JfNI7fgkGXIrLEKt8krZH9ms7ZgdWJR
   w==;
X-CSE-ConnectionGUID: 3HSD9tMPSxmaRvj+IyQYZQ==
X-CSE-MsgGUID: z6zc8g9tTPC3eGVBUOTYbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="91921465"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="91921465"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 14:37:59 -0700
X-CSE-ConnectionGUID: DS+ewBYnS3KpJF05D1ibPA==
X-CSE-MsgGUID: 4caIDgK9QfKwe1wqs4JP6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="220562827"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 14:37:58 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 14:37:57 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 14:37:57 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.33) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 14:37:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z+E6xMHZk1a2lHF7N44OT0h7TIecYLJXF71quF0uZ58BJ9KDG9d7ntWz4C6HWktABeXzWCBK25hxMkSo5G8UzNJ11lcjqXiAdMQuWqZIx1uC2AACYEjUopyKdnd+jkPWlaLyf+d5+4o4Y1gh7ExrB9STmmwvjKszhVyXVCHsC2tQWuzOo0oRdBdC9nu1O5LxZEsNDrj7cJ04c6TkwxHYmr5P7Moci6Pe3AzpAwwlBuSe6V5sEN7tuHnrROY8NCWb5/zSk3ky5FYbWQ54i8u4cFCUjjn4RWFOL8pnmlHbKmeA2MeMXCPk3eywZMc+NicXdSj8I47RplMFO/jsMvpFfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QfkE0EfvrU+z+TQAggPG7iS+7VTwB5/dQsUziPM/+U=;
 b=VeLaWQTO6fiMF/+05tIDvp4MmDAj3E8L65fbupK52otXY9VjwPfF9eArbyjf4izL1NdJssvu8mrrMXAFGv5MgwziHT+z+RCh4dGLrkX/jGPK/B8JIbGLOtLbN/Ckczci/ISDPcw+ABWIo7tBX9J6lO5HwdCAuNC1TA4Ksz2+2Taq+nE7XIBX4cb2GlT1KndqAnIApAis9r63x2q0yOfGVYc1Kr/lL9sNT6u9FTboXVg8RzxNejI5iUujnFnyJ7by5n14/hy97dNogys6OhDt2zEcXIz6otOaDrJuzvwTm4aX0upf0WkYR9znFYhuaQAgzK8ElfmHy4JQ7Yb+5pbFFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN2PR11MB4760.namprd11.prod.outlook.com (2603:10b6:208:266::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Wed, 11 Mar
 2026 21:37:48 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 21:37:48 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Mar 2026 14:37:46 -0700
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Message-ID: <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
In-Reply-To: <20260210064501.157591-4-Smita.KoralahalliChannabasappa@amd.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-4-Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH v6 3/9] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0011.namprd21.prod.outlook.com
 (2603:10b6:a03:114::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN2PR11MB4760:EE_
X-MS-Office365-Filtering-Correlation-Id: 536644e4-8268-4735-487f-08de7fb67098
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: zDdb5f5uhG6TAiJ7bt/4vvxq9AmZab3VpO3oOqvzqnbfsR7q5zgNG41Js4G7ODHFuF+r1iiUHUf7bX/CvLvo1jAn66QhdqBl2/9iyxxELtg0NP3Q4InVUcFdK4KeLnTG1eK7Swue6MUrKCZYJO1psV3sDJL15qNxUApSvE5zVYDRMn5Eym+fz9qagNmXqh6yRhnB+CBgFsuUm5I4GHCZVl5LwfC7eCq+YmszFWdgczEuIXh90kKF7ejTRuuRHVyoi9jE+KjszGZ4tjc7MOgrn7E6E+NiB6xr63qdXhMv88MHcm/sMyhNBl26Kc6UZJi5HUVrWGplfmOgDlZOaFyUUcyrPDqDCCVMaEgcd7AeTmEZvYYgo0JGBK6zuRu2BPH3fH7+Nb4LBzywlbww8WYMxxXA9C1QKvzCY4Cgmybz45/+NnMTSBgq4IUjwwQAAc6JaRtDnGsBVAbrfwq/wxgkr71eCOBZdAFli0/bt+0sHaWHtzkuG9WAJzX+4h56V0C/icp4jWLg+ZnCMZ99/F6bl6teLPXeEMAtk6Qoo8cAQ5h/mPgRXhGFI8z0lntwJAhKXwc6eOmNyIJSdg535gpOX37KKYTYFXhKNM6XmLgP2c0ypzyRMVMZqeYz/EqsDsnaOY+mrU93PiADuEXok3fqoJ1+kgssXllQHRxaVuFfbNTuWklD7dXfOsGbLFfAga/Bn7Y82ngOMP/riOt5S6SBe3Emj60CoIiEK7Hwcfh41Rk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmsxMU5qK2RUbmtUMUJkdS9MTmM0VVpyUU1hNzIwWlFIaHJSbEpjRFB2aFRV?=
 =?utf-8?B?QXYvak54N29CUHRZQ0l2MnF4b0laR0JpSytuS1VzdTZicmRzUDZVTk1aOE1K?=
 =?utf-8?B?S3FlV0k1eDBOSStDKzlPQkE4MkNBRndnbndMdWlsMFNITnlzZFdwYUt5ZE8v?=
 =?utf-8?B?V1p3cGsrc0Q1ZGpjREZKMmpwRG1KUHEybm1PclYwTWVTbDRiVUQvNGpmcjNj?=
 =?utf-8?B?RDczNG5WRmt5MEk5VU5rVTc4WmRRV1pTK3IzSTU4ak5QVmNoQXZtc1BtcWht?=
 =?utf-8?B?Z2NOaE9BZi9NL2pGdnhQNzcyQnJZTVN2RkZDcnFvRVB4YllIWnA0QVF1TXY3?=
 =?utf-8?B?aGJ5NkJ3VzBvVHZTUVBjSHQ4dTY1Z0EzNFpPdTZoZFVlVUZZTjY5T3VIUmdx?=
 =?utf-8?B?bXBMTXk5RmJCQysxM2RXS04wUW5vK1JYSXk0VVZ4RkZPVW5MUkp0cWJMUjht?=
 =?utf-8?B?M2tMR25TQTFnSDhIOTFpMnFGU0sxUlJ3SUlsUkVRcnRtTzdudHpIUHdBTi9C?=
 =?utf-8?B?S21rc3E4SjJVbnE3VmR2U05iWUNxTjY0ekZCc3JaNE5OeVBxdUF6ZC8vRzh3?=
 =?utf-8?B?OStheXFGbzJDZGtsTmRrdkYyTktSM1VSa1FXdW00a29oaUZjOE52VUIrczBk?=
 =?utf-8?B?aDVyUTEzZGxXTGs2ZStDelAyWG9wNDU3eU1WcVlpMjFWZU55Nk1MelNEZHlq?=
 =?utf-8?B?NnZIVDdBMnFMMFh6UW55cUowLzdhZkpDY2F3UkxGR1FWNWh3K2s3YmgwM0x0?=
 =?utf-8?B?MzlCWk5NK1YvUFd1N3IzNElVbFVTU2k5QklmZEpDTm10MzV3eU5QeDU2ODk2?=
 =?utf-8?B?RkRveGVsMFVPc3Z4OUNMVDNnR0NYSnIyK1dhUGN1R0NPdjdnMTIzYW9KYkpK?=
 =?utf-8?B?c25PclB0bzJSVWtkUnQxZ1BlMm11ZGRYTVBOeUZOd3dkM0k5VmFwMDdwUnFi?=
 =?utf-8?B?QkRUOTVsSTlMY2ZPNVR3dlZsUEk5TWUxLzBqZ2lSOTFqV3N1MEh0WWN6WERI?=
 =?utf-8?B?K29QNEdNV09BUDhBWUxCb0NGWUpUY1g1YUlNeXV6SERXMXZUNDA1b1UySjNm?=
 =?utf-8?B?M2JoaGwwZmE0VEdIcHdldXRPNmxVM1lxSzdKUlhTZUhHY0xuOUlmM2hQOFll?=
 =?utf-8?B?cXM1eG9vTFNWOHFVTWo1NTFoMW9Yc2p0U2VIUVAramY2ak5kdHJLV0RtQkFZ?=
 =?utf-8?B?NDRacUkyanUvRjZ6NmxOWWVlQ2dCbWtBYlRCMnp6QmdqQzZsSkkra2xuemJ3?=
 =?utf-8?B?ejRNcW5sYmFDKzkzNGtPSlpLWE9DR1VUQllCcVVJUW9lenBBU0VuODBnN0xn?=
 =?utf-8?B?Ulh2NlNQelRpS1lWQU4zSnRtZlVHYWlRUTdtMGFMYlFab2U3aTBISnVEa2Qr?=
 =?utf-8?B?THJMdUdkZXZFM3BJcGZYV21PenRNejFBQnNxZkZsWDJqUGtmaXpmVWVwZlFI?=
 =?utf-8?B?NXBwNnUzc1FGWUVpd1dUT1ZSMWFKNjlWcXpaTEFMT2JVZkdFR0pUUmwxbTBQ?=
 =?utf-8?B?a21KRDk0YSswQ3JnMGY0Uy9HQThCcjczME1OZFlTOGxSWks2TGg1Q0FMVTZ1?=
 =?utf-8?B?UjJpcVo3M3FmM29FUzVuTXBzd05zWHZRT3Zkd3FLZVJqYVZuUUJvMDRvZXF2?=
 =?utf-8?B?N1FCeFpsMUowazRhSnFacE9LVmlXWlBaUTRHYXl2czNaZjdDYTJBeUdhZDJu?=
 =?utf-8?B?SFhiVU1xZ0RDUU9KaFBjY2ZST21oVHhtT2x1RW8xT21IUHc0RzNvNk9LMEFr?=
 =?utf-8?B?NkJRWVA0THJ4QTEyTFZJKzdHT3NMREhTRGpsSlkzb1R4TWpWenBLZFlBMkVK?=
 =?utf-8?B?QVJxMUloMnRFci9qMUgxbHVTQ29vRFJWUXIzdUdwb2ZPNTc2ODlkTVpnSUQ3?=
 =?utf-8?B?M2tlb3FHVys4YjNBRStuTk5pYlEvQkJ1TnRNTitHZk9PendMbzB6YS9pWGh0?=
 =?utf-8?B?K2thTmNHdFJaNVBkS2VEZ281T2M5UnhpMGgrcGRXLzZ4dFJGMTNUQmNNb0Uy?=
 =?utf-8?B?NURDZCtlYmhPTjVPaUFUUlZReHdEQ0wvOHozRDRpL3c0Znh2Y0VkeW9vcENl?=
 =?utf-8?B?MHVSdFQ2YmNqT3FmbTYvU3Y5QXRwbTRKYllweUg2VWIzRVVNMVhoS3YvQjZS?=
 =?utf-8?B?Z3cyc1llc2kwK0lCb0VjdUtYL2ZmVS9LWUsvc0Vqb1hKQUxVdysrdGk4RS9V?=
 =?utf-8?B?L1hHT1hSVVV1WUcxS3ZKNk9LN2xxR3kvNzU4MUQ0VzFFSmppNXIrUFdvZTlE?=
 =?utf-8?B?QWdQNjdMOFJMYlAzN2JBVWppemFnWVlYQWNZcW9sbFlpTjhWWTRLR2dsUzYx?=
 =?utf-8?B?RDBPTGdNOFRJeUFlUmgvaG5nTitlMjlDMzhRMGRIU05GOHJhQ2dReTVSMmlF?=
 =?utf-8?Q?FZ2RJ4EmXOxRaGBg=3D?=
X-Exchange-RoutingPolicyChecked: UqrtQCz6UMXN6RCGrhG9CXJ4Yw++feSCMrVgtplZSAfQQ/0F+zc5E3uBeuYsFJcP5dJjukqOeD2uYbbPHsUEbCSlBg72lfjL5rQboXgEoadFBObwvBKxEi/TyR8ycFSF9JmvlrB1a5+N6+BK5JcvG7Ekz+ExMfs1qCHm1TGQyFQc6rnVDOlnO+4O4Kt1LF96zuKga7a9kEzZYFXR+Pjz7gEAR+3Wj+xMa/vX0/8Bjp3FvbqlCrdU77+JKn66aEz7TkiUuaYqrrTO9/bP5uKIZiYrKDXaKR1A2f26lCMPpu+xCxWOKBM36bH1qeMX0PP09t+Nq0QW9rFvGw8fC0Im2w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 536644e4-8268-4735-487f-08de7fb67098
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 21:37:48.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjZFv2BKDEuT431Z/VcR3ruo48B4gG0qHQFYeX/ROrP3IMOmMAeGp61lYNNZLVeXxMW/yorpbmr2cQ/95Uj21XjS5IUPJVqsKk8ywIExubI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4760
X-OriginatorOrg: intel.com

Smita Koralahalli wrote:
> __cxl_decoder_detach() currently resets decoder programming whenever a
> region is detached if cxl_config_state is beyond CXL_CONFIG_ACTIVE. For
> autodiscovered regions, this can incorrectly tear down decoder state
> that may be relied upon by other consumers or by subsequent ownership
> decisions.
> 
> Skip cxl_region_decode_reset() during detach when CXL_REGION_F_AUTO is
> set.
> 
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Alejandro Lucero <alucerop@amd.com>
> ---
>  drivers/cxl/core/region.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index ae899f68551f..45ee598daf95 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2178,7 +2178,9 @@ __cxl_decoder_detach(struct cxl_region *cxlr,
>  		cxled->part = -1;
>  
>  	if (p->state > CXL_CONFIG_ACTIVE) {
> -		cxl_region_decode_reset(cxlr, p->interleave_ways);
> +		if (!test_bit(CXL_REGION_F_AUTO, &cxlr->flags))
> +			cxl_region_decode_reset(cxlr, p->interleave_ways);
> +
>  		p->state = CXL_CONFIG_ACTIVE;

tl;dr: I do not think we need this, I do think we need to clarify to
users what enable/disable and/or hot remove violence is handled and not
handled by the CXL core.

So this looks deceptively simple, but I think it is incomplete or at
least adds to the current confusion. A couple points to consider:

1/ There is no corresponding clear_bit(CXL_REGION_F_AUTO, ...) anywhere in
the driver. Yes, admin can still force cxl_region_decode_reset() via
commit_store() path, but admin can not force
cxl_region_teardown_targets() in the __cxl_decoder_detach() path. I do
not like that this causes us to end up with 2 separate considerations
for when __cxl_decoder_detach() skips cleanup actions
(cxl_region_teardown_targets() and cxl_region_decode_reset()). See
below, I think the cxl_region_teardown_targets() check is probably
bogus.

At a minimum I think commit_store() should clear CXL_REGION_F_AUTO on
decommit such that cleaning up decoders and targets later proceeds as
expected.

2/ The hard part about CXL region cleanup is that it needs to be prepared
for:

 a/ user manually removes the region via sysfs

 b/ user manually disables cxl_port, cxl_mem, or cxl_acpi causing the
    endpoint port to be removed

 c/ user physically removes the memdev causing the endpoint port to be
    removed (CXL core can not tell the difference with 2b/ it just sees
    cxl_mem_driver::remove() operation invocation)

 d/ setup action fails and region setup is unwound
 
The cxl_region_decode_reset() is in __cxl_decoder_detach() because of
2b/ and 2c/. No other chance to cleanup the decode topology once the
endpoint decoders are on their way out of the system.

In this case though the patch was generated back when we were committed
to cleaning up failed to assemble regions, a new 2d/ case, right?
However, in that case the decoder is not leaving the system. The
questions that arrive from that analysis are:

* Is this patch still needed now that there is no auto-cleanup?

* If this patch is still needed is it better to skip
  cxl_region_decode_reset() based on the 'enum cxl_detach_mode' rather
  than the CXL_REGION_F_AUTO flag? I.e. skip reset in the 2d/ case, or
  some other new general flag that says "please preserve hardware
  configuration".

* Should cxl_region_teardown_targets() also be caring about the
  cxl_detach_mode rather than the auto flag? I actually think the
  CXL_REGION_F_AUTO check in cxl_region_teardown_targets() is misplaced
  and it was confusing "teardown targets" with "decode reset".

All of this wants some documentation to tell users that the rule is
"Hey, after any endpoint decoder has been seen by the CXL core, if you
remove that endpoint decoder by removing or disabling any of cxl_acpi,
cxl_mem, or cxl_port the CXL core *will* violently destroy the decode
configuration". Then think about whether this needs a way to specify
"skip decoder teardown" to disambiguate "the decoder is disappearing
logically, but not physically, keep its configuration". That allows
turning any manual configuration into an auto-configuration and has an
explicit rule for all regions rather than the current "auto regions are
special" policy.

It is helpful that violence has been the default so far. So it allows to
introduce a decoder shutdown policy toggle where CXL_REGION_F_AUTO flags
decoders as "preserve" by default. Region decommit clears that flag,
and/or userspace can toggle that per endpoint decoder flag to determine
what happens when decoders leave the system. That probably also wants
some lockdown interaction such that root can not force unplug memory by
unbinding a driver.
