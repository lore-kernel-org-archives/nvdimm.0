Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795118134;
	b=pkTKnh1GOXcGPJZJaQBsFdEfhOZsyBU4Ilgvxg7hdt8qjP6javwyrmB2Goh+s8LdnCzq
	 1t83RlvlukP6T6FbofPndFlkwG39isafN3fucFwyJuXh5nQ6IzRmk9JFbrWKitSahqmGW
	 AiSP3sSLvm4Xc8IdxwaX22BDrpAFOJWIhewoYxpKWULHA48/9viP9Vngx64OEHYBpPaLI
	 LFhaV9J1mwNZmKrbc/RntK01o9CXZpP1tXJEYIw9rYnCXlF9B5NeNPW+Vy7iE/MscAKwT
	 avHv3BZ32oaa7cf+bKhHOJ1j9zo1fJTztA5IqcVgOZ95Lfe1Ol00f6zpYLY9gG1RRww==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118134;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=yzXvogt89Mtk9Ix8jkn0S1eEhobGdyrLxPgRAoA+Z7w=;
	b=fFarAI8m5clM9AG8dupqZ4enZm1M2ahEMCvz6Z/Q42Qw6Ylj8JnXHKffLi8oOiLwz+eg
	 5ZOq74aoZRJlnvPcUEvdrheTAa+uAtul21AZvZ1AGxLKheE7S4neibDshzY63mqN3BBdG
	 cOUfTwjPh+/p3h0N+YJh03E21WTFVouJSzE2R0f9lGcj8vXuPKZsRmLDMF+TrHNeNnAyF
	 fI98rLp+Z9WYqdZi2W4w9KwKKN5BfTjRYVVIMTAN/XnG4GbJs+iLzpsJ2QBv/PkKdwCUV
	 LL5C8eWNiAPzY22HnwCRXCyNhMhOdCrhJ2NaEeNGp4sHgBqUAGcExNc+cqjlHjpHE7w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=B5hVPxg2;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=X2BHjSdi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA02606A330
	for <nvdimm@lists.linux.dev>; Thu, 19 Nov 2026 19:55:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FA02606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=B5hVPxg2;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=X2BHjSdi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795118133; x=1826654133;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ARhIZnlhq9UnTZl9IJ+pxsSBb0KMMUazn6Im34wDzdc=;
  b=B5hVPxg2scY5Ca0SGuxuQnqPsKkx3vyoZwf4FFB+c59PZL0/mOLWIA+f
   Kw3J/nqMXMDghXjpDkaMk9VdtuuPUl5te67ochh94r3jGZhwg9g8642Qi
   0R9nbm1ZGZeFkOWLzWjhRiOcUDiYM+5ovGWJvcaEmP8Js0wGZqshbgte9
   G+eDLtrW7RvZX4ROyCJnbwE/b46Jc1jXWDzn88ezFpkbjJJ3gOZR56Er1
   FzRdueOIH64OQz2Wrn1N9xeC+qgA2YE1y3qU4XYWjc658kbUl8QtCr2yK
   4uMm1vtNI6lPRtuSyUe0IWK2UXCOJ0lDESMMbcBQpN1/QR+CoO+GtbPJb
   g==;
X-CSE-ConnectionGUID: oN7Qwu5YQ7uc3Zdi3DdgrQ==
X-CSE-MsgGUID: wXzbHyA8SQy6r2I8FQx2BA==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3835121"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3835121"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:55:32 -0800
X-CSE-ConnectionGUID: jTX5pvs6RS6Rwb5Pzvh1/Q==
X-CSE-MsgGUID: IZq2e6toSEG0GMeeihGelw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10737943"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:55:32 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:55:31 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 19 Nov 2026 11:55:31 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.36) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:55:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g2UYhcsvrpr8q2mKy68NhkEidxC6owjsjUtF47A4hirTU3BKnnAMJf5UHLGfawsw9G64kU0gFhiIUxhw3G+qT3K3BeadkNvFvo0qnporgYeYnlZc8daNPyJZyPKY978uE9IS9N6fUSlxo5kBVIwCuduM1R5Mi9mEdHjv83+Fl+FDAzZiUOdBY6qzvLJJY6FozNzyKirT7hx/Mbq4o1djDAdhpUbKTu4tOY7eJ0Aai5Y4sEgSDFohbm0cdU6glCtKBnqMiDYqxNyw+DFdJLzF5SAmponKlGis5OpAUalgV02VfvOgavP+Ul9LS2bOMKjz0EXkZkgG4QuUUY08KxoxEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yzXvogt89Mtk9Ix8jkn0S1eEhobGdyrLxPgRAoA+Z7w=;
 b=jwqicCxbh2rRS0Mtk7zBxC1ACBd+0nSm4lcBnE/EsLMnXP/kPCKHtqRNROlXJTajxeR4MJ3IDTxhpjwO0pmbfIIqiyCFWz0QL2liXgIIRieMn8Xy5qCf2mL1x/zcGAGbRTobmtXsTWlZpH83MfYRk9Nc8lDPXbQkhiOpai1lCMD4tizEuM7Eexylq+JuqEqPHMD4L/9/Er9l7kypKcDJxgMvmCz2sqbWOUBmB4u4eI8gNZBz9qOqrsLRnaOj8U26b9cqt9ZxyEtvdtaLjFZQEmN73Tjg2n9kMmQUuZC6yXe/MSzz/9DEDv+/rvjWjCQ3tPUnJwRPvxGZg2OfA9gEKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzXvogt89Mtk9Ix8jkn0S1eEhobGdyrLxPgRAoA+Z7w=;
 b=X2BHjSdiXnW4vPM0MR0zTlHS7T7/sWaudinHHic4jmJlNgG2VA/4vMEpryFV8flQGa/zh+P2k2oGM8DBSXWDRtdnsp3UYwAmiewQ5Pl9szkXC5SRI+boBc9pQb+CNDMChVlnrI6UknUqDDeTBgrdxoypy5iBaCfcfmLb7qumbGc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH8PR11MB6855.namprd11.prod.outlook.com (2603:10b6:510:22c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 19:53:47 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 19:53:46 +0000
Date: Thu, 19 Nov 2026 11:53:42 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2] test/cxl-region-sysfs.sh: test a repeat write
 of a region target
Message-ID: <av9TxlCYnwvQUlct@aschofie-mobl2.lan>
References: <20261026162419.584201-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026162419.584201-1-alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0291.namprd04.prod.outlook.com
 (2603:10b6:303:89::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH8PR11MB6855:EE_
X-MS-Office365-Filtering-Correlation-Id: 2425cf04-867f-48f7-a1f4-08df4676d23e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|18002099003|22082099003|261009223027099003|260925021911599003|11063799006|261021121427099003|56012099006|260925021311599003|260925022911599003|261028144727099003|261022105027099003|261026140227099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info: 3xZKR3LZHCw1IUePkexR913GHFzEYTjhyzqqdHi0JUvzGfov6JynYRGrZoSo6o3wG/5nP1Rqsc3971EYx9AxDIdLmBqVgxgtqkzNXjKnlM35WWH23jXA04ivLTCe/L6LgXruu/rcK/XpqoLrd/sYlVYp2OkLS0DiINSXNTDgJLNi3ibS7JxdOD0J/rCGoi9HpxzWr34Z0YBe07WhZ4uwgYQlaSotdj/5sMZzzIRF5nxUJUg/AilI9flaqD/q/Q00SDVsRO/X3ueqBc8dm5iFUGP5+JG3p3M87oEoQp+JNvP7A0qqv640B38nlHmR1ZU7ERXKJUExT172SYBRnlPB/XQ0gWJFfjN+q4rI6ZE6zLlsvazbcaTGDr/aCfb02vn42qvgBJWjbVmvgEz8ePr/kGZp6eYgbpt2GJuesSJYd/IjYsm6i5wa+xvGscYUFAmZO+dhToVUF3Tz0+3IQ5pLWqR/WclX16n89hLTDVfgtTUYL/v7ZALRcybHkt1Kxl9lG6vHsaezFUJTXcBjJSIoJUHKyBaNT0x3qMayEdRoM9+8T4PyTgSSoIJiZJ3vLoENtzc8XHFWzVVVfJyCSx3ktaA0M41KKpE2JBpc4yfWnrbwwyo+luUH2c7ojiKLeaAT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(18002099003)(22082099003)(261009223027099003)(260925021911599003)(11063799006)(261021121427099003)(56012099006)(260925021311599003)(260925022911599003)(261028144727099003)(261022105027099003)(261026140227099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qgZXAdYKJkvoYbMiHXxanW6ZVUkCMM1uqB2h+h5xfBD+59mh58n87d1q4TSw?=
 =?us-ascii?Q?FGBMJRM+tqEIfdLGVyjEP3sF/MRQa9Nv0NsOclpmN3fgwkmaq4zqYW2xgwb3?=
 =?us-ascii?Q?hjJ+DUYTn6dbwXDaIhmpfqsuFd8y9ji6rwD8HUJ4+JFVuBsbEG+iZ+CbofN4?=
 =?us-ascii?Q?y0O44Soil8Hf93RMq8zjO8NwF7YoAkfq7KKYCHBSuzoOgMEPClbRkU8+N4Ln?=
 =?us-ascii?Q?hfX5PWngkClgqWzZ/L83XMFCBEDrkJMuNPSUfKNFtM8/RyjGgqA847RMcTIX?=
 =?us-ascii?Q?yGF3ICA+qDSaxzcWf110v8ftz8zidSxcDWdwyT4ua2/yNTGQ4B7UgUFYiv1E?=
 =?us-ascii?Q?4qS0mwnGJdkrKHF8EnoAH9yhLOeJOVMEmQxNnz6DH8jhxG0VmsVsfekk/CkG?=
 =?us-ascii?Q?NM/0AU2b7Oue+T2roAJ4c/UN9LP7WSgk73E0oJlkoMCxZjG/RQLaxiDMrFh/?=
 =?us-ascii?Q?Jdroj95jTFmlyrT7j5u4Lzt3Iwn+1cYdcaSIs1qj6b5LbP2+xvEai/CHKnEM?=
 =?us-ascii?Q?h5TQxaJAuf0inljP/jgkJWkUInlcb7sNEbW4hKANdyIZaVvlu90jTNPvIJGX?=
 =?us-ascii?Q?y/z/YWeg5g6jC8LUA1uWeVO4AnY1qRzV7c79NoKfsMJ8qYSZD6OFaoD6vvdY?=
 =?us-ascii?Q?mvhxMpI4J8VOl5ZBi3gc8ibr77T2AGheuwOA51kHH2sotThLMxE1fjXrOnWb?=
 =?us-ascii?Q?vG17oJcWyeYl3oxhCsCgtTfdrT2wWfLpNrwjiZsG42Nryv3HTEg/+sG8xfsm?=
 =?us-ascii?Q?nwSA+ibbYZ4wGP6EO38y/Kk1TBQ3UPYnKjeILRrk4Ph1XdPrfSDBjFvelhTf?=
 =?us-ascii?Q?KZT/43IdUeMu9C09oaCx8j5WspALWaH7295SUYRfzodF5rXzxtcokRKy9/Ou?=
 =?us-ascii?Q?l2And69Qm8Qa1O2CjI5kCTg7z5lPuXOm58ouv0fE0u+/9t87UBY1oaYn84BT?=
 =?us-ascii?Q?5sLhRswICVwFYIKmGmwo/sknBR6fJyhfZiIcwBGLW4duTiHD8vrhHAgZHowA?=
 =?us-ascii?Q?6Elf6curQ3fyum13qnW7RnrpDvKZaDZ0bnfD2EqjqF2sDSFtogEBOo9iZMvw?=
 =?us-ascii?Q?5UsrdgsiQq2KAivRqxg2/+X+sSw+VxwUqfu+Xm9+Q7eiIqNuPO3MAoUBF1PM?=
 =?us-ascii?Q?Ub+pIA++ejRGL/f/KTurzYNZB1VaKatN3R277fMtay/yEuxs0Nd/cZd0z6PH?=
 =?us-ascii?Q?vkU9K+eCHMouIK0XVDmacKYOaxZMmZbCmX5nHu2nBkcPVRrW1uhGR7Ur93hA?=
 =?us-ascii?Q?WDQG+6MyfZzeU6+140CL0fKxhmUgGz51Ivi5pA5bhaB6U9P81JlZg5kqrHlA?=
 =?us-ascii?Q?iBKIQeAn93sotJnepHw7lyJpP9ieprzj04XCySmaz8fuQx0wALwheJdmLHy8?=
 =?us-ascii?Q?36Pz9+/1TPJ+Brh3NQNoPKKUCoEeQEKe9GMa1m+cbya3j7jSmM6+9u/CiKky?=
 =?us-ascii?Q?7iBG3rb/FjdZcD0OcVwmEEnDEF9U7bSo2aB1+pVhANkwXAJu25rfBbm79CRw?=
 =?us-ascii?Q?0g0jg/rV9JmTl732ZpdGsFd5Rchxzdqdz8FahKfTXapsQIOT+ZyzkmWq+Pp8?=
 =?us-ascii?Q?V85vN4M3G4B//R9a9FICSDPQ6BGq/NPPE/QpYZihAD/cE+3YQn0AAD8QgEEa?=
 =?us-ascii?Q?qDit5+CNmjsI/x4cKFQkzJ+wP557jhYlsT/W3lw/MnLi2BRHp5D2Bh8/ab1p?=
 =?us-ascii?Q?MJCZsXNa7gqXiqBWhTk5IU/uLPMV/P5DLpdLxpSHpoAY9sfs8NzlgkkIUvLL?=
 =?us-ascii?Q?lPI97ILhqw0rMl+3Nq783qfPuh2LHZ4=3D?=
X-Exchange-RoutingPolicyChecked: cc/GrUPTat3YEAdhwJVlHW2tEZhSfLsKTTHUGEjBcE4/QlQekdUvpI18o3i66UuXjdPC4m3MdO0kwRQhzbnHambIbly7dlEoTRKRfQss+GwJI0UpEkOy5JYZvsyXfJI56NifNKH67b6ezKYIuW2qwMHkne7GCfh8ZLeMh29fQPNr85Tr4f+DrQ6Adg2aqA5g1EQPQfIMjmSaS9z7pj67z+kasG6F+YMUBi/jwB5uMCg4MmqVrjdnipYIlWlFHiQ3GKfcWuI6GUZyvbAJVj4ZNguO//fNtLNKUGkYvGyfrjjl5ql7OWPCq3jsgSKQHjYNefoAvsMUJQX9Zgd37afeEA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2425cf04-867f-48f7-a1f4-08df4676d23e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 19:53:46.5306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CmYY5ElKkN5p0PPWvmmBZILdznDtGrnHTBu/wWVoUDba04x2MZgvnVC2baBwKmXqLjGd9hFsh/4LAtomCQPaUXUgwksGFqGYaWmvYFPTChk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6855
X-OriginatorOrg: intel.com

On Mon, Oct 26, 2026 at 09:24:15AM -0700, Alison Schofield wrote:
> A CXL driver fix making its way upstream[1], makes a repeat write of an
> endpoint decoder to the region targetN attribute that already holds it
> succeed without changing the region. Without the fix, that write fails,
> leaves the region half detached from the endpoint's ports, and a later
> write can crash the kernel.
> 
> Add a test case to backstop that fix. Write target0 twice on a partially
> populated region and check that the second write succeeds and leaves the
> region's decoders attached.
> 
> [1] https://lore.kernel.org/linux-cxl/920d80735a449f93a1f17a8bca4c25e4b302cb42.1792989098.git.alison.schofield@intel.com/ 
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/

