Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793309915;
	b=tDMgfY3iTPZWXAPeTWU2H9Ay4/dFWA7q+NgfK5h0tGNr5hJjyZzMxYLSB4jpLZKyZIZY
	 ZUOF++I67YWV5vV5Upp/ULW09aSGak9UPITBUOoIil29CdfdPHXQ71daXH0liTq6Td9WX
	 mI1F6Eak4y+ZBk9WiNpJ48beM6bu/OctbSTRUKf0KUmTkZ5Zcby9wlKxLBpK5KSZAGWpL
	 GBaw2JSkPwHiKYEJl96gRy9slz1dHq2eixB/PzwIo3D40XYUGmaEWx2O/JY3r9rsNq50t
	 LtLdtA5eoZWg8X6ojMwSH9WROY22E7WRS1l6yMWvr9hOLC3uhpG9pc/ezLRFGV1OkKA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793309915;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
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
	bh=9KKubcI1LM23RdOHIApDfzbSxBaVQRzVK8Gkh9JtHeE=;
	b=W++WM4lL0wFMR7p8rtGqm5OJjF+Pu27+baThH7HqYBawy9IdznFfi1VtUg4PSkeIDaNx
	 4TTGFbMlEXjZOWtCMc4Xc1k8DDFJQh22QYPdFECiOrwANQmPilc2gvPgraWzsbcVNXkdg
	 MZ3bVdhVJGmxD9wO951+520jqjsTtKQ5UAmcL+2tbK/9fKwYKgjVOYvA/ern3i91qP4/p
	 ZeHyq/nhtzCWRSzV8u1zpPh6deAtkf3S0XL49gKr4FLuI834CjRO4GbI6Znk2TyyXpH5p
	 ej5eVVcS6PJqOSgT5Jf/KUDmoy2gFJ7lWa6FK+QWCJBf+mX2Jf/iotXpAS7Ds1h0roQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kO3t2y0N;
	arc=fail smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78944606A31D
	for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 21:38:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78944606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kO3t2y0N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793309912; x=1824845912;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=34BPeNNsaQ8uTN7ZyRpr0YtBPl1LgmQp8KMAA8n7dBk=;
  b=kO3t2y0NhNsNNxOJFL9Sz7cVh+YOaU7vtG4FhvEcANgGfFonEvCFyTPL
   FkEuqipRm5z6Mbf9AntZQh2GMjPtRZICd9FDCa4K3TF68+d3N5jmLZs9v
   j+2bykt3kq4s/Ahxl3Fyrz1KU3qHknRPCCwCAd8yxWujqoJcWbLyRLlYX
   Scz99gfqwdgvKHE6KlPvj0MOCk0AxNf+L84fpHgqNi9Ej7LE8UjJIlOIh
   7KZBjuSPvlXyEVZDbsq997yXX8YQApbLuu0KiSDTWHlCgkZWsrnlLweiq
   PxpOkCcW0HGpc9DaqBDyvVWHPLMXwL24pIQ6nZRo+L7PI7SE+YDO2Jmy3
   w==;
X-CSE-ConnectionGUID: oi+X5kQ/SHqNwvZ0IYVg2A==
X-CSE-MsgGUID: bY5a9W9lQ36gOlMEel8Csg==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2079729"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="2079729"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 14:38:31 -0700
X-CSE-ConnectionGUID: uAZ2zys4S7uZAO23nnmKdQ==
X-CSE-MsgGUID: bLUmo4tjSICYqz0BR3qTpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="5347571"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 14:38:32 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 29 Oct 2026 14:38:31 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 29 Oct 2026 14:38:31 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.33) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 29 Oct 2026 14:38:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FW0irEN/f7GkArWIQLDlvFC4HJbCKhB9+mPTLyHwScHz/4iWZTcuJ3GcpTsz2fWZ6FOQT0aaL9I213xqDFx5xjvuDeStbmXG4LKqASCKgJ8IDT5cVNivUFBGQpjH4UghsCNgRglhTqhV7m5/5zBPSYU0g1MvAvVWr/OUsX8pheyrfWEbPJ6pF0Aw75AMfSTT0S5tcDQVaSvaUEWrqNTYwJUWVm+1YHWp/YDuqxUaqr1eZkdBckjMoOYdKgCPWp6ARsriI3qvIOxt0iRKN8m+vcdzmm9WOCno8MnO+dX1BWD3llCrJGY5BO+TVZeRMfz+K82f7F53aVINnkRUs3GtcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9KKubcI1LM23RdOHIApDfzbSxBaVQRzVK8Gkh9JtHeE=;
 b=wk1Zk2403r5jjIBbMTyHK/vt1bB4CKHeeUaL04O5abikoUxaaXB7HfPS9HxSFMjFycHxr2oPXmE+lnx5fZX4uLdPx3kuUZnqc66JlsUS8PENZ0fRSpgRldQCmKa/ZFq6/fxyZTC2dT5ru6KfG4KCKzujAg3Sq60EZ0ulT8eWsNIXRUKPD6LU8cHtY/quKZ0AbfCP1bJZ5V0KyPKvDbgzdJxUmoziEa6OByTq2wkdL6egybFvucu/Zv0J0/RJ5q+YN8qwN49BqBB9GgKbRmJqakZKSXm9PtOUJqMd2CWXnPZxlR1zGukgTt1LhNxOFB63oGlZLbQt1i/Vume2wvfztA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ2PR11MB8347.namprd11.prod.outlook.com (2603:10b6:a03:544::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Thu, 29 Oct
 2026 21:38:27 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.021; Thu, 29 Oct 2026
 21:38:27 +0000
Date: Thu, 29 Oct 2026 14:38:24 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 6/6] test/daxctl-devices.sh: cycle offline/online to
 cover unplug and replug
Message-ID: <auO80LQITDHcPGUW@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-7-gourry@gourry.net>
 <atl2HyXaNB6-6j8f@aschofie-mobl2.lan>
 <179268775162.4072493.12508126317533540624.b4-reply@b4>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <179268775162.4072493.12508126317533540624.b4-reply@b4>
X-ClientProxiedBy: MW4PR04CA0285.namprd04.prod.outlook.com
 (2603:10b6:303:89::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ2PR11MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b6279f9-0432-49ad-56f1-08df3604f789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|18002099003|22082099003|11063799006|56012099006|4143699003|261022105027099003|10067099003|261021121427099003|261021123027099003|261026121527099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info: /zMda2QdaO9QlezuUHSlb9+IlfwMkJr8ewAILZGq8T2ml115za+0+ZYp1qYX4k/jdxv7zgOMamN70frlhWvahqaIH1J4tFtoJaNrMpCaWDTYbk27YcSO4bYK4I1tNVGPqeMmU1ctsT+PP6uY+b4wjtOnmJTrhj7dk6Nt85T1Z/NwavN11fLyUEURASFhEOWsCpELywRJfPTnn1VN558G5Y7w48Ie1uEeCZUL8TbFTO8WKk9aSpJfgFpOQeVQkyHxyQxkg/T2P93tMec+w6d0NsQDrrWfjtnR6HxElVWO2fnyQn04bKma7+KzJDhxbKh/9pVQ6CtvDRjTjAlS924dqYg9M6hEJfZ/ksRhhnUCxr06CjEL1wI7tScsuLEHrNZTKeOveW7oR6bwRlGZrwU6mvqcW2Hzg8QWcKvPVtoKNxJPyhaYV0e9Zahh9Sj9HViyoFY6m8PBAuCTsiUrkHIMhQPKSsCOf+lZgNXvZ8ZXUmZYnyZzjbl8NEBhcfGhbXjQrizD/VxqnzekBhBjnq3HmXnXyecl8fGa/6KBrsqGVnULhcTgWxiLWNLHMyt//reOUo5AF+65NtPj7CvvnlcZAq3z8Ts2hvqMTKdPnsahDa6CC/RticVV8r1O0wmgjTB0S9xpfwq0SWloFY1AOMZFVinSuBW40s04sDBFZZhSUoM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003)(261022105027099003)(10067099003)(261021121427099003)(261021123027099003)(261026121527099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hsQYkVyocFzaGy9VXPGyJPuucGceM8y2tM5TQfDV7Vz2TrTNa7n+MKAMMw6u?=
 =?us-ascii?Q?T3wx/+/6ZatmDOVegpbt9mplWxVuWt/UUFD1UThAdpCBOuWTU0nhvhk3LUAm?=
 =?us-ascii?Q?TrhO5zvyo25V1tzOvCYoF1QA46Zx9HrJkhpNkxvb1htK5pIikgY7S3abTR0B?=
 =?us-ascii?Q?E4DPWRp6Eks/YcvGyJyAIxTPTTZZBsaPSwAFi2ltupiytJzZR3ADbYQ023Cm?=
 =?us-ascii?Q?pc5lNpIzjRUGsV86z0zbo+5jo9QMTkIsCbl8hUyAnJfzJZA/saEHdRSn8ZEv?=
 =?us-ascii?Q?O581tX4vkvs6lG2LZDg5E8PdF85GG4hB4GAnCm8/RCzgeM15jYZWKFDzAEGQ?=
 =?us-ascii?Q?/TZQ2e8yQZE3iIPNyXkrhkQASnGa2L+GoH1jQ1CJ/okV19AKiK6xbyjcW6iG?=
 =?us-ascii?Q?P0HTxJIWjVnt+EFvH64bPAV9q1EiJgiFwvn5YLil9YfPkMBYKKG9aaN70Kv7?=
 =?us-ascii?Q?AfreeW7on2vyliOJEH/0EzsEXGsiCecx34cR4kbkgfdg1PyELcu37jt+fIBh?=
 =?us-ascii?Q?D+o0DzHEHet0S3U0gms3A064RkuXr9TkUOLiG8qUuaNUqLjePUdaCbkZr8u9?=
 =?us-ascii?Q?cPd1G1a/sp674bu6GjZHoEOjMVclYODUUOApTAQY+6DFFfVSJ2IJkWaA3uCM?=
 =?us-ascii?Q?ScoNqtvaCvyEDwosdgQY8mv7KcixVeFDyVNhx+hsIwRntrM3sjOb0FRNdDNG?=
 =?us-ascii?Q?L4kbeu9iCQSHa/jAjF+1gWEZH9ducHLbiEES81fryrgJSSwpowNeTTsvuETl?=
 =?us-ascii?Q?hQ+N+GgX7+0Pwsz6GQEF7a1+lHKLBo2wJZDXuPDh/QAMLMxMf3nZvIg5IOAu?=
 =?us-ascii?Q?Bkvdr/bjnQoBw6qcBDdc7NFhTIAlNwL/MNUEwr5lcVJvTwP7M+6PqMO38EZ3?=
 =?us-ascii?Q?tCIDzsjHBQei1bq9T0dEjBiRJK6NR7IbRacd5uFNZB5fG4Uacx4iLNUl2mqo?=
 =?us-ascii?Q?AQYX7xWyBFzNCuuJP81d9ZrBaHe37RmP4GeEiWq8uJn+JGDp4LvEkLw9x1r4?=
 =?us-ascii?Q?lE6wfwRK7DrfEaKCVYQOZheEOiCHymKi22j7BFv17zaygMWlBj00LW3TTzcP?=
 =?us-ascii?Q?LIqi1ALPKFXgDSuRK1f2CMucuMOnmztvximYG8StTVHAr90XWAFHs0nljyqC?=
 =?us-ascii?Q?xFQeqMsjV6A0em39DFARSoyFCNl9Rj1uNKFE84SjyTZlVH5Sr2Rfld6V6lmk?=
 =?us-ascii?Q?2I8NQaJ5833cANOR8hNzorEGU8GBtkJSvq79sPJlec2KuxlA6uWx6q4g3x22?=
 =?us-ascii?Q?curE4rrd0fQ8awIbC1qZLJYmspH4zUuvbpX8WWyopDt7IKFY7tSJ0JMrOVKF?=
 =?us-ascii?Q?3J1MzehQn5CTAna860KMdmJkT7AEBJ8BCmYgf4fGw4pz4BbNk/jZziL0S8EF?=
 =?us-ascii?Q?rxpvqxC536Ni4djmg/TOxZ05PtewO4ulZYaof3cbLWwUX2FeAo9BOvjzkyg6?=
 =?us-ascii?Q?2jnZrP/1+Sa/hJjuIzgmpkcNZjYdF+NepYPlI9BY3Rl0gm4N413qtCRS+f0g?=
 =?us-ascii?Q?BZjdGJ17AatIMVEOgdoJ0fxoE9OEM9e+4Z7EsR/jBN/7XQ2AfHULxV3VrTiH?=
 =?us-ascii?Q?1sOJdkWkwSqF0QNvzYDwaHWUoqTAtLLTa9fzDZnxxe6By47N4dTp65ILWaFl?=
 =?us-ascii?Q?uU5imFrbMOwQC2uQVb35CUgpm69yLb6XRV9zsNIH/qWWfSlS+N902cg6Y3ju?=
 =?us-ascii?Q?VJsVG+k/tkCM5G7MmSpPpT6PfglYfjq1ymz3HtBfSGRjoeyKgo1R+7W0uySf?=
 =?us-ascii?Q?R1o56cZ3TEcFv+g+1cxy/1lfieKZJJ0=3D?=
X-Exchange-RoutingPolicyChecked: dqNcZcP1J/mXtucwv8t3pI6D5COqIYhviGSEUD0qM4uT9AFXPWYtH/b23RPm+C3WwfcTNQJASUlVVa4PcEKIrhuQu0VbNtfpSyPGSLtep5wJb/CjagnlaGovM+bKlPnlq1BdO1LDdSkQdvqRs/1qXRzPJLxIq9UbH7NP3xocV19dHmcECAYlfahfC6jpyAXxAcI7LB3AUnRW95Xq/eBbeYhGP2Gf9Lsb57x31CZI18cvz5pZjO23+eKM3KR7TXMrm018xCRzv+ORFfbnp8wNM510mvc+JVapQWINHGnxMN8IJsQ3iNuiIZNT1UoUF1PYsetV6GiUM9bMN6+SkaXXoQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6279f9-0432-49ad-56f1-08df3604f789
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 21:38:27.3005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5WeANsh6NqLpwafmkJ2I3xlo83dun8DMhDkbWkwQ+KVg04iAudK0HcyqoHMd/zbA+PdjjcCVpPwY40WTAgGP7/brDvJSgrvhEK4s5fJYtdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8347
X-OriginatorOrg: intel.com

On Thu, Oct 22, 2026 at 12:49:11PM -0400, Gregory Price (Meta) wrote:
> On 2026-10-21 19:34 -0700, Alison Schofield wrote:
> > On Fri, Oct 16, 2026 at 05:42:48PM -0400, Gregory Price (Meta) wrote:
> > > From: Gregory Price <gourry@gourry.net>
> > > 
> > > Repeat the online/offline pair to cover onlining from 'unplugged', and
> > > check that offline-memory unplugs an already offline device. After each
> > > step, check block counts and, where present, daxX.Y/state and the
> > > 'hotplug_state' reported by 'daxctl list'.
> > 
> > Hi Greg,
> > 
> > Please change how the tests handle the absence of the new sysfs attribute.
> > If a test expects the new interface, a missing attribute should cause
> > the test to fail, with a clear error message. We have had problems in
> > the past with tests silently not executing letting defects go undetected.
> > 
> 
> ack
> 
> > Note that we don't require backward compatibility for the unit tests.
> > The utilities must continue working with older kernels, but tests for new
> > functionality should fail loudly when that functionality is missing.
> > (I'm aware that not all tests follow that guideline, and they need fixing.)
> > 
> 
> this is slightly confusing, but noted.  I would have expected the tests
> to test backward compatibility.  But ack.

SKIP if kernel version doesn't support. You'll see this pattern in other
unit tests:

check_min_kver "7.3" || do_skip "kernel may lack ...."

After that, fail if kernel version should support yet the attribute is missing.

-- Alison

snip
