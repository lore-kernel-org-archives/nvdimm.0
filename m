Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795546583;
	b=Ig+rORIZ4i5IYLOPcaAcIliUWjNGDOYcLXUjK6zbklsKYfuoVs0pRZa7UdHYoGLHR2Xw
	 2VdhJZxXSR+LOIKhaB7wUXdNWgJPza8JTPYkr/BbfN23zOI1zYLifN3NSSoer9DnuAVSM
	 1Yp+cSsVC8ToBwwHMYnDE+mAI3DbDyLVNevz3LRtzmrZOdgKF9zPE9/jsD+4DvAKUjIdI
	 13o7xWTU6luURcPggmSG0rdeyv9A8I9U7Wo6rB9nKGTkiGThsNucWsqPfuGD7bWv3TjGF
	 FWT5kmJoBtoSX6MLrgHiK9oUmmJeI114bEDD984xa9NZE3kkDANqcWpGaJs+pTnVFNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795546583;
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
	bh=0HWdBOBg9fOoOa57f6RfNv/7AbTzIPKABRksV98dPkk=;
	b=a8mjc9PixR+vrzOAd7CtpNtc6WuxXKjMHyET4r1O7g8vPZ3hGLPip6TldAZU79FmcwkE
	 CuCVawbbwu6TBNr3D43AdoqHpL8toGKRi0WijPw85sm5yjM6yXyOfuDulj4FG8aMhHhEl
	 eYcfi3kQ5C7jbO9lQEKs633gRn1y4FJeonACj8kj3wjZsuHFqIjTFGTCM+JZgqGhNU5rs
	 4gtic0EK82sjWdzmICVVir08sWf+GXCcDPX1mbVunsthzw0cjDOLFxPdtXIAY4dUn9VPV
	 8NTJHA5eegmsH7lBewwBfXmNEk6eR+7DmpSIkuwRu6j+oT8PBpkO/tpClgQwCNumpJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fJb13dwX;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=hQTpAaBM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDE2606A31E
	for <nvdimm@lists.linux.dev>; Tue, 24 Nov 2026 18:56:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DDE2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fJb13dwX;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=hQTpAaBM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795546583; x=1827082583;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oHYrXMAfYwjLYUUrz/1zzV9x8SEyXGGioyzA0vi8sAI=;
  b=fJb13dwXmVizvKQEFMCSI99buwDGROZP+wH+6+pNF+Fjg1rPRoHmSWoT
   Py67E9a/i8gD3cJgilmZL4iupLgp5a1nm//a/5TE1wSubt7RbcXTdUPDI
   m07aO+uJyh9jFvmYXidlIIKFdoM3/U/77PUIF1Odz4bi9t7qFuNBjy4OC
   gq9w+WJcu9o8OspXK22uohK8cXqgzlDWrhURVAQ7rF3+SScH4A6MpdWVk
   nfUu1ts4TLiZWe6onqSRZXMglTb06V+lQFCmgA+IJ2QRbzhEaaU9EYqte
   qwtP4+WprzJLW49/jFBlkzPF3sJMxiVicMsFRcGWLsDzLAYGxEcHmZ2R9
   Q==;
X-CSE-ConnectionGUID: tWbwevHmQIW14pIKx5pYbQ==
X-CSE-MsgGUID: mLSndOv9RmOVggcSzFZfDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4441124"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4441124"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 10:55:47 -0800
X-CSE-ConnectionGUID: TzuHqwM6Rl6zHEO0icMvJw==
X-CSE-MsgGUID: Qpqeguo7TOespQQnQmeYWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11962529"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 10:55:47 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 24 Nov 2026 10:55:45 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Tue, 24 Nov 2026 10:55:45 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.17)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 24 Nov 2026 10:55:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mMDcqBFYTQ5XENvv+GuNVnJG6DpR/Y5dK71BpQgGYaQfiyh/o3018ch3SwC4BZXAaKuLfWRGYTMiltAptLh7ALUV/8pNCt72MwtC/OQ/Lso6jGVCq1iYhBRsCW8CCIllG8HD70OPqPlyEOpLUx8Tm0mF6OSzJ1mHss7tnmPCeWxbFAqJwRF2MfWvPRvWRnEoMPE6ijsonP3AjXuR/iYli5JrEFWs/We05YkwPjbWLXU3VAOp7uxGiMy6iZGWzmkdX0jRHGIp0VTbLWPvg/4Vozc1+2z6m9iPfAm7fsD6QBahd4/PCvf1w1eukjFH8kLVG/WCso4MD4w7m2yh+SeB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HWdBOBg9fOoOa57f6RfNv/7AbTzIPKABRksV98dPkk=;
 b=MZBA6lVdgRi4QomO4kloPqcmus6YzWvwXoYMZ3PikZqFZULMNzKy9dPVu+0WEbkcVgIGER0mMcAHQhAQJBFpd0JrzQqO3nWFhVW7J22xur6QRErKPWqRDWhr/CpDc2YbvIAYsuYXu0FeLuaNbKJcLD5MLWEl3TsEkc0mKWI6YOiFG84KA1kcBDEylEj8nYr6ypmUk1MBidkkZbhxKjOleQhaZCOCR9pkAj+zM94K7U8527QWIGlh3dYCM/B0pp3ZrxsUnYgU22jd1a9zBFQPstPSw+VE+TqZH0NbC7MLmA3xQpM5xuCd0CDhGlZhFhEHTYo8dqgHd4S5rHf/tBBvHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HWdBOBg9fOoOa57f6RfNv/7AbTzIPKABRksV98dPkk=;
 b=hQTpAaBMFTWv+ReQRobFWTC0U90pX5HeakJJW0MeadfI8ggCua0bhKFBGKHVCLSEQvzfrft5ApzvCPtB2zbv5+2PxwsoYA+bvwskjVu7SeuM9YPXznBAvC5wX6odlAjq2rSeiV3649iumTbYqku9HNI4acxMkU7Te350XgbU1Z0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CH4PR11MB508343.namprd11.prod.outlook.com (2603:10b6:610:523::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 18:55:43 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a1fc:97e0:329a:4aa7]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a1fc:97e0:329a:4aa7%6]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 18:55:43 +0000
Date: Tue, 24 Nov 2026 10:55:33 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny
	<iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Fan Ni
	<nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Gregory Price <gourry@gourry.net>, Richard Cheng
	<icheng@nvidia.com>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v1 03/14] cxl/region: Add dynamic DAX region support
Message-ID: <awXdpbmU0HSXK_uB@aschofie-mobl2.lan>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-4-anisa.su@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104230445.66625-4-anisa.su@samsung.com>
X-ClientProxiedBy: MW4PR04CA0074.namprd04.prod.outlook.com
 (2603:10b6:303:6b::19) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CH4PR11MB508343:EE_
X-MS-Office365-Filtering-Correlation-Id: ac5bffa2-2372-4c24-de1e-08df4a5c8a6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|22082099003|18002099003|6133799003|261009223027099003|261021123027099003|261021121427099003|261026121527099003|261026140227099003|261022105027099003|261022075727099003|261102123227099003|261028144727099003|56012099006|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info: nUJqUh3xIwGRopqIATIhYVAkvxsCHdm46qPoWN9Z16zpJtyA1OrtdSQc/Vl7Tqlnh5O784EqIQA1+kzZkgKpol3YTvNz9MmJTONosVattO5YtA97ySarkpjd4lCi7hDcoFfdVZ+85Uab6fbSYSsM4sSEqpSSV2uOYHtZnOLYyBNnAfUns7eMGKmc5SLKoJISuyA6DiOxoCmqef8Ux7D0VDrzBYcthyATcR3K6yKDaaEaZhZ08EEL5gFTsFUxnPl35uEBl1rvSFSrXMJLYKEzugWnw8Ub/CoHiL1wyDTBSRzN4sl6xEb7LhwrObYNHoiVUW4HkMnjqfXBT3ba8mu69U4IDSOjNMyvpze1RN9qMfUvws0nyqbH3MR+3dl8ksFcJdPrL8xhMNDTWwY0CjsACYjK03n4z+mw4TRsxe8L8I8T+xz/BxA4E7NoUc5HROp7BOEd5Ei6vam6GCmhh1E49+m35FBKUWr+IMvIjrNL20XspUjA9o7w5Z5eI1tU3RDj3dM3QAvnfaewHcNRavV9WhXlps+vEFQm/rljp6+wPa4e7unNnQWUUIi1nIV+Mj4v9OGTGsNyyxMtXObEJibfO1bPQY02Z8dfpTQ6+Pcftib23O9+Hs1hv8+7qRE+4mypTmBtLveHvWNRCovvn/+vlZ86S0T/c4EznOt/vo1C6lU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(22082099003)(18002099003)(6133799003)(261009223027099003)(261021123027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261022105027099003)(261022075727099003)(261102123227099003)(261028144727099003)(56012099006)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C7PvM/97Jb5ep/zjtkAtWkqPkfPQ2S/2kgduDG/kjtNmsv2RC5p7NVIDn9p5?=
 =?us-ascii?Q?5t73Ro7RwmcKlT6nOF7J3w6sgHv2HBYQ4n4eb/RwWjXjfMzykj4fsZSHedjM?=
 =?us-ascii?Q?E0SD3os5oWKh0zyTew8uiyDFHPaGNHB1526R/xH0Oo+Si98p0ZyXwmlOt7gR?=
 =?us-ascii?Q?4QN7pWDQoI2UEZnYMXX13YmsgStbecqVOalnF7Su3mTpZgNhgjli6mojxuBi?=
 =?us-ascii?Q?uAEMdDtlNpCXCu51qjGGaUKQbLzQF+3ivtE+YmLY/8ed21fgCLzJp7letd/i?=
 =?us-ascii?Q?7YOQJv1k0NschvZ4IziIlOtcQyQGsWmS2qQgXdHKjKfGl4eeq+5k481H1a2+?=
 =?us-ascii?Q?jhA1XFKont4CEXk8JamU6QS4FncjdOHPf0/FfR4AkZ9ZBj7C5sowz890MFGF?=
 =?us-ascii?Q?TuhqR/VFyRjcgDTdB9Vtc/CLOYeh92EYoGcb4evBTQHk+VMnXltWOp9Uxfw6?=
 =?us-ascii?Q?Lj7HW2hdg5XzoHKL9E4PFmkzFSY65qtDzAvfI3z/zDWRzkDq+eFDl9oh5BMI?=
 =?us-ascii?Q?nYnpTN1IF0nEAOEy/vQeAybauMvDc7uJawh7Ocggd6dSkd98JQhgYf3sAr4Y?=
 =?us-ascii?Q?fvhkFuO4nJ8up5hhyAZMURT/4aMWKURfrShcoXtmcuikTsyJzvKLZTf4CSLn?=
 =?us-ascii?Q?USI06QWppIFxUtEf2syUQQQRCZxphB2lO0tDetcK27s4WUVtR57R8iSAEtLS?=
 =?us-ascii?Q?/TfvPOS0wBMpLbv4iJ/Dd73P9mhjdx3hYtbupkAGJw9aAuSUd1vkHj+vceJ8?=
 =?us-ascii?Q?3SWJzp4mLhy+nXLSbeUVwWeFpicSkMaornoWCLKiaGKQXM0JOjqa/mv6/H4G?=
 =?us-ascii?Q?sb9kTAGrpeEKFEGWauCQsd3sQv+BkfGWPq56fRVO+EilJddEAG6kP32CNUZ4?=
 =?us-ascii?Q?oAy/TVE9KZUwNiMUaA52dKczXpVzRHrr+/5nZDNrIjkcHsP1D71MbxTmiBsh?=
 =?us-ascii?Q?bI1vw5TgRJfdyKM/Vd8PePdOfVQiX+cFddIwtEbYEVUtZsvbgW5s/8it7fIj?=
 =?us-ascii?Q?vttZe09dhkgY6Tz3ZrSAChiM/Skz43u5xYnkfEGcc3npOvkT5x1wzR3E/utN?=
 =?us-ascii?Q?mJVH7E4qVGvUwy12DIgAcoktEWk7vqjQoBNDwHtFWAuwVryc5skKb4kbiXMa?=
 =?us-ascii?Q?OltAPrv/2jJ7wXmj1f04nr5fP2oms5CPkLsKwDOxVZM0eY01qPx1HQWzk5hX?=
 =?us-ascii?Q?dTjIyT4g8R0YfVrbxcuZ4/k/MkTYaLf6+3H+xco8rhcBAlsPg2+P2YxUg2xI?=
 =?us-ascii?Q?bmQ0ka04848Za/+xDakCN489j+xMXhnh9LPYH5CB8dunfe2ZWLJRaGWyBoAV?=
 =?us-ascii?Q?2AEkVTDcmFQCVIcvtcndjTiQZ7A15JK0+qGEC54z6WhswFR4YPRVuLBn5jHY?=
 =?us-ascii?Q?K27Qsh3VhseqH8ncu9y9Gu0WtHxJa7j+54q0tnCSCMciN2qQZ6qzlGcliTLI?=
 =?us-ascii?Q?IHsWnP3lsW8lmbvWxQcKSTMYbFo6y/kgM5eKDHfaHHZLYaXv+1YPXxpUMVtp?=
 =?us-ascii?Q?YMlBy2TqurbsesNqq1aGUw6NeIxKgXYSUbhII/MoFOFIcoSsSTUpAC7mwAWy?=
 =?us-ascii?Q?qWowBBaK1/i+9G4FmwuuCy9gcu3Oq/oI1CMWmLUn2nxNMdYMUMBvPxcUuTFX?=
 =?us-ascii?Q?bkoQPrOLT4et2AdNSKYxfH0blZW81SQiahsDwt4nOqa/MElW+CtVFFFE+Oc/?=
 =?us-ascii?Q?nowVf1baOJXusz0IXzO5krPWdkXMwur6AP0Brqlu9XS+AsMar+GsW78KipvM?=
 =?us-ascii?Q?0mA9olmzS4/9QAOBLbFQNnp6F2Ii9BM=3D?=
X-Exchange-RoutingPolicyChecked: aoPEWRbA/YACe5189gRCCzwW9ZIMWn+wW7EA25+KYh0mEtv/eDBy9M/i0+c1heTUXOgMWutNgg6XOHxuJUZWigmp7PyP+hwdCg8B4MbKOTz77EH+2eis91dYZvuaIhYSU8odvYWiOkWdZ1/2D7R6Q1a2mjmDMd3ZTqEjkhizXZDacSHysl2TKv97F6gPDf2CszGbdNKvgDcm2G5NUNVjCWXNSS45g81uK6aNCZ2fzZZxh9S51SMxhVkjQt6pB2V6cYnIt5OyOB6/uXZhnI0mMCnByW/exus5ZF01efIY2irnbywYjAZIYyNaU5eFXMhrWL8CX7LymQxRadsiUsBOXA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5bffa2-2372-4c24-de1e-08df4a5c8a6f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 18:55:43.1658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fAho4b0DC7og1IEZ2fOaVI5R1JcGdev8dlcXy26RrbXsGKg0/Fk8gqCrqobenfpjjlh53jb+d4hYdWUR5GUW4jk+LAgGnG/AVOHFdJqAd5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR11MB508343
X-OriginatorOrg: intel.com

On Thu, Nov 05, 2026 at 08:02:27AM +0900, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> CXL DAX regions must allow memory to be added or removed dynamically
> to support DCD. In addition to the quantity of memory available, the
> location of the memory within a DC partition is dynamic, based on the
> extents offered by a device.  CXL DAX regions must accommodate the
> dynamic movement of this memory in the management of DAX regions and
> devices.
> 
> Introduce the concept of a dynamic DAX region. A dynamic region
> carries the shareable and read-only properties of the partitions it
> decodes, fixed when the region is created: every endpoint decoder
> attached to it must point at a partition with exactly those
> properties, and the region's 'mode' reports the matching selector.
> 
> A dynamic region has no capacity when it is created, so the DAX device
> that cxl_dax_region_probe() creates for every region gets size 0
> instead of the region size: a seed that claims no capacity the device
> has not offered yet.  Its dax_region is created with IORESOURCE_DAX_DCD
> rather than IORESOURCE_DAX_KMEM, so the DAX devices on it bind to
> device_dax and not to kmem.
> 
> Indicate 0 byte available capacity until such time that capacity is
> added.

Is "until such time that capacity is added" describing this series?
dax_region_avail_size() returns 0 for every DCD dax_region.

Maybe just say the available size is always 0 here, and leave the
change to the series that makes extents usable?

This paragraph also seems to repeat the one above it. Maybe drop or 
fold in.

> 
> While DCD is disabled, auto region creation and the region 'target'
> write refuse endpoint decoders on a DC partition with -ENXIO, as the
> decoder 'mode' write already does. The sysfs entries for manual region
> creation follow in a separate patch.

No later patch in this series adds the manual creation files.
Maybe just drop comments about what this phase now doesn't do.

> 
> Additionally, dynamic regions complicate the range mapping of dax
> devices. There is no known use case for range mapping on dynamic
> regions. Avoid the complication by preventing range mapping of dax
> devices on dynamic regions.
> 
> Interleaving is deferred for now.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl |  5 ++-
>  drivers/cxl/core/region.c               | 60 ++++++++++++++++++++++---
>  drivers/cxl/core/region_dax.c           |  6 +++
>  drivers/cxl/cxl.h                       |  4 ++
>  drivers/dax/bus.c                       | 10 +++++
>  drivers/dax/bus.h                       |  1 +
>  drivers/dax/cxl.c                       | 17 ++++++-
>  7 files changed, 93 insertions(+), 10 deletions(-)
> 

snip

> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index f4a9839c73d2..fc9139ce358f 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -495,6 +495,11 @@ static int set_interleave_ways(struct cxl_region *cxlr, int val)
>  	int save, rc;
>  	u8 iw;
>  
> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM && val != 1) {
> +		dev_dbg(&cxlr->dev, "Interleaving and DCD not supported\n");
> +		return -EINVAL;

perhaps sync this msg with devm_cxl_add_dax_region() messaging,
which emits: "Interleaving DC not supported"


snip

> @@ -2737,6 +2765,8 @@ void kill_regions(struct cxl_root_decoder *cxlrd)
>   * @cxlrd: root decoder
>   * @id: memregion id to create, or memregion_free() on failure
>   * @mode: mode for the endpoint decoders of this region
> + * @shareable: dynamic region: its partitions must be shareable
> + * @read_only: dynamic region: its partitions must be read-only
>   * @type: select whether this is an expander or accelerator (type-2 or type-3)
>   *
>   * This is the second step of region initialization. Regions exist within an
> @@ -2748,7 +2778,8 @@ void kill_regions(struct cxl_root_decoder *cxlrd)
>  static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
>  					      int id,
>  					      enum cxl_partition_mode mode,
> -					      enum cxl_decoder_type type)
> +					      enum cxl_decoder_type type,
> +					      bool shareable, bool read_only)

match kernel-doc to this order of params.

snip

> diff --git a/drivers/cxl/core/region_dax.c b/drivers/cxl/core/region_dax.c
> index de04f78f6ad8..47c9c52a3902 100644
> --- a/drivers/cxl/core/region_dax.c
> +++ b/drivers/cxl/core/region_dax.c
> @@ -84,6 +84,12 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr)
>  	struct device *dev;
>  	int rc;
>  
> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM &&
> +	    cxlr->params.interleave_ways != 1) {
> +		dev_dbg(&cxlr->dev, "Interleaving DC not supported\n");
> +		return -EINVAL;
> +	}
> +

Not sure probe is the right place to refuse an interleaved auto region?
Look at if refusing for ways != 1 for a DC partition in construct_region().
IIUC that would refuse before anything is assembled.

snip to end

-- Alison

