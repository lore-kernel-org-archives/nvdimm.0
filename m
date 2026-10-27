Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793123975;
	b=ZfiW134SoifMWU8qWzz4CSPfivkzkXH1HIpldHdLtjDHDCOVbUB8kfHtWtnbjQoIZL0Q
	 1ElXUF+fgjR18cxI6DDCJ/y/EZztZIsnZXQRTZWjBtm4iavMgrAwPtOd9xQZ4GrgI3llh
	 Wyapzz5b9K0eM5Gf/xQAop2HnBWoiS+spGWT2WAvIZgrjenQss3RPxGwv4e/ty7I81Ys4
	 iPkIhHJKl0RIbmyOC18aGUs8L8YrW+6/Y5BuxWzmwGDarYU0iMh+HOtKkSdt/+Yv9PU7B
	 iCZbz1comptntOeStI8WDOzRBT1ycm1LdPC2ojb+49vYamx44xm+PDxjdUwK8GGNE5g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793123975;
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
	bh=jcooMX0qAeUWp5RrMsTqPbGi4tL2Ii2Tmuvx/i73DIw=;
	b=HSwwUyKyQjx+ja98Lgr0drndJxRMWiA/fvCvGx326Mi9tmDUggAHT9mZcjtSHPUP8mCH
	 sLIHkEIAmAwSQdTIDB8D7GzH40Vo50yHR4oQnnNEYEKZ/T1nqt67Bu000FlaKijGaaPoo
	 8SlubeCN2J2iA9i+ZbmKZLlMXsFPso9x3Xs6xEJrTODvkvY14JdOgkugR6tgj2VEZn7Lx
	 RwzJwqhpUkZl9ezqLyHRqXP9zf3SnL4nz6aFR73XskvuC09p3Htb3WEcImyv6EiaD/Jo8
	 ZtFZp4PdTv+RWJiZ5DTUn5mQhL81qj7ey04kncqd+uaI4qWZPziKk5xZnW13JY7ozSA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Tgz3YbRU;
	arc=fail smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E7E606A31A
	for <nvdimm@lists.linux.dev>; Tue, 27 Oct 2026 17:59:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70E7E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Tgz3YbRU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793123974; x=1824659974;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qYg6h2PGjKY6rt2TGJ2bqinDeCes7eJ1mQpH7soj+XY=;
  b=Tgz3YbRUDxVT3PuXtn1x8qyehwleVS1azKmVcPhABQL7n8o95H19LZ6s
   YVPRCnp4lCl149v+8H5TIgodkYMVwPj+jow19+wW7LR1WaA3KXQkGNNo5
   lU7Kwr4XorkbCnhig0DGcvymH/XpR1LW3mvn3G4ab0uICuMid3AHt3jXW
   wvBqjoSViWvHDUxWJckfmRMDqdTHdXPaLibd0d4tQzz9OlH8BRiXWNae8
   xWc7bYrRP4EV4upCiDk6VPpZFOWtZbqp3iHHf+vYGgpax/8YVTGakxAKm
   bv+4IEZ9+BMSNiuPWn5nh9haUKlvUdqsMCCTelAxSK1CsjBdf1x8tGAKz
   w==;
X-CSE-ConnectionGUID: K3o8I/KySJC3aErcb46ZUA==
X-CSE-MsgGUID: H++VMX7dTh2Pmba5EHp7/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1735912"
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="1735912"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 10:59:33 -0700
X-CSE-ConnectionGUID: Tr0QD7BOQweGx+RRt0x3Gw==
X-CSE-MsgGUID: cOJjvP1ITqOytMjYS02HsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="5004220"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 10:59:32 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 10:59:32 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 27 Oct 2026 10:59:32 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.42) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 10:59:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J23D14yxylmcE5vE/hQDzPnCjbTYn1Y+SU2paorDNTLyGh7Ntv5IQIntcHA3htKBsxSf9bj8EA/hICod4W00fZNkePPGomLmbucsTBhJ4eBSxyPG0F0ARsv/4B4Qyt04e9fiI3PuPfQQoovdp7hCJ8uvTokVn13BXHYo7KdImNRMRew025Fsp84POXMvEd0m+d4NO/OwLflHQPF4lgGcdZ2kPT5Pq7MV4iW5G/tuzLYtWwjhY7bfB6XjBYRD69b7xZrIoTLOKwZkHJILFjnbSaXFjDd8kNbEQA2iuRZFSVMtxIul3YNjnDJLzRbtcbFYldvju5TGjqSnjBP6llDbUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcooMX0qAeUWp5RrMsTqPbGi4tL2Ii2Tmuvx/i73DIw=;
 b=aGZypua1pT59CF5JzMxuJBMkWcsiclCT+mmK1Mjp/JFvULy99FRxzd+Q7cPysPuC/8QEgTh3updHF9lG9XDb59YhuODvGgEZqKnTdwJ2qd+1MJNjg+OxjXU/WXF9N7kQeybk9ePfR3cP7CN36Y2bDwRqP7uBtvPoK+7FUBjIu73hgnxOYO7Dfkj4tO6x+eo0twCrRAaYAHGo3gLgbPa8WNhSImeKkZQC/Tg8pMAvBUEJWFwFgrAgH+ApUw16674qY9XJjgMpqv3/gVgnlRlv/Y8FAGBxQ+puYlIZyusV79Ssb5UDINMSmt7zB7+YMC/y4F3HReNZnDGrRDO8mElhyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB7728.namprd11.prod.outlook.com (2603:10b6:208:3f0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 17:59:30 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 17:59:30 +0000
Date: Tue, 27 Oct 2026 10:59:17 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Shyam Saini <shyamsaini@linux.microsoft.com>
CC: <bboscaccy@linux.microsoft.com>, <dave.jiang@intel.com>,
	<iweiny@kernel.org>, <nvdimm@lists.linux.dev>, <srivatsa@csail.mit.edu>,
	<tgopinath@linux.microsoft.com>, <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH] drivers: nvdimm: validate dataoffset
Message-ID: <auDmdbE3NXRos1_X@aschofie-mobl2.lan>
References: <20261014020430.295282-1-shyamsaini@linux.microsoft.com>
 <20261027124121.794856-1-shyamsaini@linux.microsoft.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261027124121.794856-1-shyamsaini@linux.microsoft.com>
X-ClientProxiedBy: MW4P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB7728:EE_
X-MS-Office365-Filtering-Correlation-Id: cc32e6d6-2002-48c3-3069-08df34540c46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|261022075727099003|261022105027099003|261021121427099003|10067099003|56012099006|6133799003|22082099003|18002099003|4143699003|11063799006|261026140227099003;
X-Microsoft-Antispam-Message-Info: Gtc/xwVCnKMu61gmhihFJ0t4O1+ZNPSUNEbIkSa6gv1WqCkl/iSuV/EMk8JdK6tJzKvJL/6iRGAk3WOwPWCGeAWLWRMXRUhbOFeLhx8VoBk16eAl0PPga47p3y+rC6Yf3PPvxIY4Hktb3XY1beWx6kQEzK6drlujP2cm40mV++CiUEuzpXB9mSH0w303XoOEEkmG9s222X4FHhaLioornldgTAkonAydiw2mTNnoFhf/eDS2HEg8UDYv2M0H6JsGkvmpoujoLz5TOgU5vOixOO+KyX94ftlZkbZJe03C6Sn8zxWUHDFa14EI+orrjirI7U55/oLhCOYOLwtsBgZss+SkzlTW+R9MirQBHzn37O2bPSafSxRTjvGcVVJXEXhaJRIZX8tkCxjd6VxSL+8ZTCGRkXX/TarBXKoSxu7Vdacv7BZUWaj/sLAGZG2GhirAIz5DCbis7Nid9FSelKNciFADTaxutCyhYsEwD5LXI79q19qnRIpGwPJ9tY91oJIKS/+j5O9ZZJnFxRNx4r5cNgs/RxjX3/rMdXxDh1cJbMYm3Z3I8nz34hxsxYnw8NWYfCEe23962dV5Amff09/0SQS3R21dj3MlQU6+WO/2mSCxgzFgxDuMAhEgWBQdbO685yduK5KhzM3MFxJBkbPFxpoAhExUMwzkPFq3uMXHCiw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(261022075727099003)(261022105027099003)(261021121427099003)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003)(4143699003)(11063799006)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MyAyuNkrNBh64LpkSUazAtVgfsasaPwGDIMykQ6d0GOQWceLMas2JJ925k62?=
 =?us-ascii?Q?Bc2xI3QfeASgS7Tn8nTqGic/Cr2+72zS6bV5dB4g3hqK6VGCk2IgN25Ga7e+?=
 =?us-ascii?Q?KRjxDi8VvZMBkPfIlr3+x47899GajbPpkM7d6vjzFKaI/KENrJjnoS5abpKR?=
 =?us-ascii?Q?/QuPqrwpw+A11W49UmlzAq+0rLsDdhtI5Eb1lRXXGso64OX++uyDUeFAjSN4?=
 =?us-ascii?Q?mDps+I8nsDYZa7EFQzSJ9dP4DRSqGwIUdqlubMdv8xtYCGPiOQUKYGFWS+WW?=
 =?us-ascii?Q?QEeVOtDF8LqKr5+o1nNwF5aFly6Jwj7tLLIhBJ3lw76llCLl370Dec4J63e5?=
 =?us-ascii?Q?Zrj/p0xSJ2zkOpwG4KKuv4agBTwf8g9TK40d8cwL8GusY3nn78u0bM/WNku9?=
 =?us-ascii?Q?mf0m3/koENvXrz3pMCC1Yw3n1RwFSJEdj6i85kSxzG5pvVmj4T8NRA0ktGYg?=
 =?us-ascii?Q?ex9lCGpV6kckwVeXGItUe6bD6OyRfU0zWpd4ZhpNZYURnsO6b8kqvjB9N0EM?=
 =?us-ascii?Q?Gw3yArlTlKG/lUVWhFsfpdTtyg6mjBTJ6nc71FUUatmYe9X76sVsiKfRzk9+?=
 =?us-ascii?Q?3sm/bwTkLQMNXFxA6jHGnfPIoHRz+UyMplgPGgxirnigpMJSc59Cc9VQncE8?=
 =?us-ascii?Q?MF+BMLMCdVbORzN43rvLgh9+h1VevTipmsRoAEI8xxquU7UO06nOm7nY2xB8?=
 =?us-ascii?Q?CTqiQzOCib5afSyC79uxIdfD8mlIeoIT/PD6eGJLUxKdJOmM9jULB/pKMwoV?=
 =?us-ascii?Q?k57fGAPTSq8rpjAMjEZrx2WLJ6gE/Y9i3Ghqsvi6jnB1G9/f2BeQcbcIhfXu?=
 =?us-ascii?Q?Cqhx8BIvGCC1QeehWLZprk28+Dl+NT0l5DWlfIfSjPvah7TZTUDglraXAE9n?=
 =?us-ascii?Q?DUEs4J5TY1qjWC3wIAf/6TstuYG61NXSk8uHHFXtFTZSjkGp8nNHENCn5mvB?=
 =?us-ascii?Q?JBeachJqCqnffcOh+8bfYpzj0LbwYoEloEG59SI/aprI86S5nhzxy8Uozy+C?=
 =?us-ascii?Q?TGv978j2BD5KHJk85NVME44mM9IuqZigUye48Tbk8sWMomuy6u9iZqsxXDAH?=
 =?us-ascii?Q?jSvoRB5hs1v6hxGBTX1Bx1CDswCP70XgkQBUqLt6Y8wflrc2g0RPlOOSFjaQ?=
 =?us-ascii?Q?yik4it4ICBuqCN9pJ6vOiByi4zCbR6Oj0yYqnQfwSbTFAo9u6GvcJ8Er6m0f?=
 =?us-ascii?Q?4Z5SsoQHhnXeFeByKM+6lcisEM7+54v3ZnPOLkU/otV8G3HTKk/AgpUwj/a9?=
 =?us-ascii?Q?rYancOFHPBgbJmAfmKf6k4sXKfovCjjOmJIufjlcxjXxPZmL0AL2CsUzbtJf?=
 =?us-ascii?Q?bC951iyqu3gkXwrVZZIaVr6bZuCXkemfg8DVQTAozN+lmbXAkUZDcS6RkeA7?=
 =?us-ascii?Q?cmjgH3gNo7ku+n2mAJ3aAiV3yMNydi1EpOzQMoLxAKDsNG2DctDquCJgnWzb?=
 =?us-ascii?Q?lhRVq2cnyOcAG1sS+5nmcjVS9NZ3i5BKtALKfiu3DWsiLa+W/C7LT/10WoUn?=
 =?us-ascii?Q?CIQDrAu1aH5Jvg2jS8TwAAkiUPj+GmZXJW8lnqO7EoRi00r/a2I6veDuO/Xa?=
 =?us-ascii?Q?X8vmKbzMFQkkhPm2wyTspIovUQUjc9kt9m/Wv5/5e+YeKTUEA+rxEQOl9idt?=
 =?us-ascii?Q?KZWyo0vbdhrY+8lrq4Zo/9FzMe1rwrqaBELykkWLQIrQPB7MUvS6c0MTayVZ?=
 =?us-ascii?Q?m3c3ghbV/fPUneM5WHvmgjl9DIATBHcHuK9NvaXTKolmEYz0Cnjl81w5zOUR?=
 =?us-ascii?Q?Mwn3mqvNnSBkcgZDFHtogFSDe16f4oM=3D?=
X-Exchange-RoutingPolicyChecked: Q5OZbm1OtJj+NaumgVn09+EG+c+GxW5yvNYizpdCp9x6FbHWLlCzd+dtlVynoj1dTfMjRpUrGZFZBDkDiJ9+1+tYN5620FtXpHic03b3bjafUVux3TBzMLnVAUGfKQ2D3YAssatnvsU5s5LUtkLKFmPFdO8FTXGAYbnbveRVyw8inmdQEJliB0AZuODTleEN/GccGcLUXj4PSX3FCwmQCWtTgTqR6s3NxDr+lLqTX1f3mQYeoFfssey5uvsFWIOl8d03kqMyxKck9B+7QJISOzLRHhjhf/DpOPdFJHaEcpk22V49nJ6BUnbaTGI7gPzEklEEgzJVMlVUNUL/tEZcFg==
X-MS-Exchange-CrossTenant-Network-Message-Id: cc32e6d6-2002-48c3-3069-08df34540c46
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 17:59:29.9925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: No99d90wfghnXa9o86y3R6Q0CzuL8m0fk6oy9QuzKm+HOuWBXtEQ/iw7zA35SCkWYlrl2RwGKxFUibxmAJAavTUYk0+Dwkh57fLojQb9Ii0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7728
X-OriginatorOrg: intel.com

On Tue, Oct 27, 2026 at 05:41:21AM -0700, Shyam Saini wrote:
> Hi,
> 
> Any comments/feedback on this patch?
> 
> Would it be better to discard all PMEM regions if a size mismatch is
> detected for any PMEM partition, rather than validating the data
> offset as proposed in this patch?

Hi Shyam,

Before considering changes to the validation or discarding PMEM regions,
we need a better understanding of the problem.

For v2, please expand the commit message to describe the failure and how
to reproduce it. Include the platform, how PMEM is exposed, the namespace
configuration, and what changes across reboots.

The explanation about DRAM not being zeroed is also confusing. PMEM
metadata is expected to persist across reboots, so why is the existing
superblock considered stale? What makes it invalid?

Also, please address the serious correctness concerns raised by Sashiko.

With that info, we can begin to evaluate the proposed fix.

Thanks,
Alison

> 
> Thanks,
> Shyam
