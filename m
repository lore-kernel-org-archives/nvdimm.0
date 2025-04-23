Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4B02AE68
	for <nvdimm@lists.linux.dev>; Wed, 23 Apr 2025 03:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745379132; cv=fail; b=VMNMrR10oO9dYqusLbyNDKz7MxbVBJl4ztq+mDAxvfsLV4/OFr5YuKMeyrILBq8D05NUEhQp6mf25s6l8TAyN4akI/tEwNTEFhW25h6MDtEUJnT7gjfroMjM2iurHLUhQHtlqZ5+z7w48Vw0wEpCHW+kXNGa4SZWiYCwZY3k6HA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745379132; c=relaxed/simple;
	bh=FnEkoDJssiOQU42n/pGUl/aTVjlO8aLMEZIfUN6oNX8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UUDE2eJL+1Rt1czyKOUnmuGnRcvnIs1lBLB/OEK7ftR5E8g+4NmCWBm7DKbLK9d47V5DY4tMaM+yQazkXJlS3H8TqnRkaNdeHi0DWl3aV7Sczrr7Wqo4Oc8+GtpXsXpVC5aeZgmqFAbL2pEi450qV54jBWg1f/RE1peCgLXKgiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O3PoKMdI; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O3PoKMdI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745379130; x=1776915130;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=FnEkoDJssiOQU42n/pGUl/aTVjlO8aLMEZIfUN6oNX8=;
  b=O3PoKMdI4Dgl1Q9fnoyqveZsQpkSCbjafhR3GpOxUaOdsJe9nZjz+2un
   AneFSjJOgQ2CYvi69jmjXl+ga270MEIE77/WjhplsiE6U5s2dqOr83+tN
   eiVG4W1jBPIrUcFovMoOVdPriGioZtdxEOSptLEf7gvvhinXO5admtoLA
   KcNSMHgOEVgCS3HDP1kBap+vzmtnGHXGnY6GLOR4j259u5hUPuEblJYik
   wdrZ6c1/jn/tvaahjoDEjsLYh/ej5Xb8y34X1bR8AaCvx34IG7wzD8qi2
   +P47xYc+hhm16h9g7cZl17I2CCgK7obcf5+BwTEyPDIEp/mmCNHc/QMIm
   Q==;
X-CSE-ConnectionGUID: q2LY3JE0Q3+rey+X/6tWlw==
X-CSE-MsgGUID: Zi/A5SuuQOCevAPkbVQ9Gg==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="57939611"
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="57939611"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 20:32:10 -0700
X-CSE-ConnectionGUID: UbXNhypFSCahw2L91API1Q==
X-CSE-MsgGUID: b89lxP3BQ+a3m6ByncRXkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="133070251"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 20:32:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 20:32:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 20:32:08 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 20:32:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f94zJrQl0zKMsR57M2nun2sykxH0n3Q6oMKTkOPVhWw3rIseyoiumcZWz7jPkAPt9v08Ww1gWqwZ/e32+VnuCQQvQJWYrYfTEBX67fbhjY1M+HfhD7inSoi0I/fG/nieZPV+bQV5YbS5e1TjMZjiP/P9Kn5sNwX38YJve9UEm7D3H/pRd8YDiro3avsN5QR/eilesG0AnkFGBPLq0Id1bL7YBdi5Xitm6CDq905ymP3eNmAOKYxQil24d6T5DOGAp26sgURhA8i0bTDjneT+GWq/hjhfWEf23Uc3KCBSvWkWLpx+yk4ke4Pe+Mo7jZsyFNVO2yQx6+XKx4A6eK8qMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VayJvd3R5ShZqUPnS/2w/8yrNNvFdbnVobqyiw5WMyA=;
 b=f0yBkT8Py6Uh5Evyg6nDKSkgdyzLUgYc0bPnNk+6GosPY0xKc1hRHBhw6ZR+S//Ok1/vtns5n8mxyPV0U5l/ETfpRtfT6hQM6qzcxfy47s3r8u96Y6ahvBcb7BhX9b9hNMOQivCq0GCN0YmE4US1eh6u2IB0a35xaaG/ggwEj3sJNRzFL6ZQO7fB4SqW2oZsAM5pqYzU1iU1fLprHcxD82Zx55bnD0ZhtD9A68jGhHRpOiIYMs73fIy9lS2UCts+2Uhb9BPOsyfuqp5FUZL0Pdo0CCHsXQ/laOffLfopr4b5d2Ug1J8ROpbWqbcl2EuzccHuhwnqSeeu1F5O6iAgSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA2PR11MB4923.namprd11.prod.outlook.com (2603:10b6:806:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Wed, 23 Apr
 2025 03:32:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8655.031; Wed, 23 Apr 2025
 03:32:00 +0000
Date: Tue, 22 Apr 2025 20:31:56 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <alison.schofield@intel.com>
Subject: Re: [NDCTL PATCH v5 2/3] cxl: Enumerate major/minor of FWCTL char
 device
Message-ID: <68085f2cd70da_71fe29420@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250411184831.2367464-1-dave.jiang@intel.com>
 <20250411184831.2367464-3-dave.jiang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250411184831.2367464-3-dave.jiang@intel.com>
X-ClientProxiedBy: MW4PR04CA0274.namprd04.prod.outlook.com
 (2603:10b6:303:89::9) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA2PR11MB4923:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ea49dd0-6eba-43ed-32d7-08dd82176812
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K3EyZkhQUzV0VkoyQ2dsWnpBWk9XdFZodVEzVURSN3VwVGVta1IwWCtsSlM5?=
 =?utf-8?B?UkVTRnl4eW5NWDdoRFNicGFGSGdhTkhKVkxVVTdVRVhpWGFvbWxsaTAwclZW?=
 =?utf-8?B?TzI5ckdmOGZxc3ZZdGt5bkFDbjNRTkV5N2JmcXhlY2o2MW1xVStieTcxejZh?=
 =?utf-8?B?UG5mdmc3QjQ1RUFjclc0UzBlWldTb0lPekRqUU1penZKcGM0NHRwZi9yK3lN?=
 =?utf-8?B?Nnd4TXVWMW5wU1g2YXBlb1F5aHVKTDdVanBrczVoWTJ4VmZ5S244NDlrSUg2?=
 =?utf-8?B?MENyb09pQnlOUzcza0VFTjIrWXZJeWc3SHVZWWhTeWdLa0ZxMEcxOUw4SHl1?=
 =?utf-8?B?WS9FZVE5K0pYZjRFR3REMHAyNGY5Q3RtTU1TQWt6WnRxVCtnN2lEREtxOHRP?=
 =?utf-8?B?YnE2dU8wL2pQaTUzeEUrZnRhOGFHOFkvWlBTSnlkSkNDQW4zRk5xZ3ZzTU5R?=
 =?utf-8?B?eUNxcWZmTXU5L1lrSDUvVEx4b05YbTQ3NTZjTUd0NmlFSExyU3IxMWNQNENr?=
 =?utf-8?B?NzNrY0V0eERQa0xiL1M1OThLOHRNZ3FxUStOcm5rUUt2QndoZTlTUXBhMXVl?=
 =?utf-8?B?VjFIY1EzQkQ4dUl2UUNlOStXeEx2K0pKWGdVVE0rV283VFMvNlY3UVk4cjlM?=
 =?utf-8?B?TlRvTnR1KytJb1ZPU2VPUVh2NnpEaVIzM2JYb0ZwUXEwMHN2M3RSbVBmci9R?=
 =?utf-8?B?VVVkQy9jWUdGUHN0OGI3NWhIQVFiRXlTV3gvdndLWVRvUU93cWljV3l2OVBz?=
 =?utf-8?B?OU10WnFNVURmZnVsbnN4TWQ5dEJlVzRzaVpXbElDOVJXVTlXdlZHTzBYQzVS?=
 =?utf-8?B?NTlPQU5SYnZWRDlIMWlpWVpJaytUNVdIdDdXWGsvS0JrL2tOcDhIRkJOWjJ6?=
 =?utf-8?B?WGFrU1hMcjQ4UWdxTzZ3UlVtTTRmYjNwR0RidWR4eS9yQWRVM2dhVFVOQ20v?=
 =?utf-8?B?Vm9LU1VxYlZJZlJrM1FhaStlTEI0c2QvRGxhWmE1bCtKdFhPcDcwMElYRnRv?=
 =?utf-8?B?cWdzYmtSSGxIcjF4UUpCSWkzNE5IdGJtQkdPL1lxaHB6YzNWMG5yMjhVWmZS?=
 =?utf-8?B?ME4rZkYzWG9qQ3FYeEp5UFlJU1lLVXNuVUZIOWJvT3dRYWNYZGR4MkI5T1Qx?=
 =?utf-8?B?K2pzbk95K2FJelNFbXdsT04xUVcyWlJMSzZwaWs2VUwrblh6ZG84WGNBMC9r?=
 =?utf-8?B?c3I4QTFadTBXdVE0bE5sV2VHS0tlSnhFQnZKK3psNk5ycWc4ZTF2dlg0QkFZ?=
 =?utf-8?B?VWZySFAzaVVNUDA1VW0xYXFvclR3Smx6cFkwcmwySmwwV1VaRkM2eXMvNDNZ?=
 =?utf-8?B?VWZHTFNkdmt5aFVOcm9VSEl0S1pDSTJEeXFsWldxWE1hcnR1NUQxb3dIbWRv?=
 =?utf-8?B?eDhLTnhjZ3k4TzlFMDAwVGo0aWhRTy9HU3ZSNXYvR3o1QTdlU0pvWXVOTXhT?=
 =?utf-8?B?VXdaK01pRVVuUENUZEc1R0JSbUV6bUpjSmVyc09MT05wMVI1RE5KWkQ4VzVt?=
 =?utf-8?B?Zmw0dEtndjZFa0hPVUcrcFdCR0YzOUlTSlpNakVVY0FtWkpEU1F6TWtLUklV?=
 =?utf-8?B?aVd4UktISEhxYlk2WTYxQ1VlejgreU1NRUVDZ0Z0MGxEQ2xTZjhzQ2JXeXF3?=
 =?utf-8?B?QU1FTGIxWTliZFNmNTFOa2pNeE1uK25wMStMYzAxYXNPd0t2L1hhS3R2d2lr?=
 =?utf-8?B?RVk5bWFlREJEaDhBMjNUcksxN0NNNVcvTGZJSlBOc3FQL0F0amE0dURMUVdq?=
 =?utf-8?B?NENQMEtXZ0ZwbmlWaVJaeTlMY0hrRXpVYTZrL3VPKzYvRmoyMTFLMXBqMEFu?=
 =?utf-8?B?dUsvQXlCbWhNTTA5bVEwTDZOYmZ2OUFMQitsR053RTRmcjhSTnZBcHNmYndU?=
 =?utf-8?B?NVVFcVNGT3VUaU5MazZOUk1POUcwZkNkRlBRdmJ3b1dXWVlHNGo1S3Iwa1NK?=
 =?utf-8?Q?kYM3wdfUxoU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGJzZU80b210YXI0RzFCWkNGZlI0eFRkc1dzTUozRVpnQm50Sm9WUW82RkND?=
 =?utf-8?B?Skc3NXU3Y2ltd1BwK0JVSGM5eGhkeFJWV0hkT0VCQW1CZjI4U0dZUGIwdDJk?=
 =?utf-8?B?YXZ1K1orT2tOTXIxeklMVWM5SkNBSkYzdU9PUkkreUlyQk1TUE42U0JRUmZj?=
 =?utf-8?B?N0h4bTJodWpQZDNOcDUzcW13UEh4ZGd2djBCNHlhRGloN0xFdHd1Nkt2Sitr?=
 =?utf-8?B?WHZ1MDVtckZjMGhqYjFpUktoNThUN1N4bisyTmxRRUY3QzlhYWl1cHNCc1Bx?=
 =?utf-8?B?Nmt3MFpTMk53cDBscFJYVmRVVS9nWVlXeWd1eERITEtmalZRMG1oWStWZDYr?=
 =?utf-8?B?RnRVVnBCUlRZYzZrbmd5cERBVlU1ODQ4cndOMHN4bU1Eak9oT0pkK1d5SUdp?=
 =?utf-8?B?R1g4aCtjangwR3kvaFBrRWYyZjFjMk9Kaks5Nzh4NDlsSDExREo4aGVrWDJ2?=
 =?utf-8?B?UEJraElBcFlLd3pNREtwcXBMMEpNSnF6cWIxWUtZUWZ2TUtCM3V5MktqNVBS?=
 =?utf-8?B?ZWFTUlR2bzlQYjlhb1dSQU5MQ0lmcFFnYVpKUnJJbXA4R1RKSFViTEFRR0N6?=
 =?utf-8?B?ZENLelhVTGJhRE9rb1FYTjM3dTZZMmpXWnpEZHNPdER2NlIwMyt0M1JHaVpM?=
 =?utf-8?B?UzRyL05GSEVaMVdXSWR4VEZRaWY0cytaNzZOelAwNkRIenpCK3AybDF5eXVU?=
 =?utf-8?B?KzNoMGtqL0JUaXFTKzBiVEJKZzdhNnU4UFBoMjVDTjVQRk5jV3pIc3lJZm9q?=
 =?utf-8?B?VFovRnpmNmhUa2tnR1llU3EwQzBIV3JZckNvcVhoQWJ3MzBxUStVb2p3RlV3?=
 =?utf-8?B?UXpUUnJ2WTFiY2IzQ29wdzNoNmp6RzBiMllrMW1oTWRyRDk3VndlTFMrTGwy?=
 =?utf-8?B?VEt3WnVxNXdzNFNueE1qZ3FsQmRPVW4yTWxoMS9RWlpVOVFtbldzVTR4YWw2?=
 =?utf-8?B?QWI0ZTJIL1hwRnk5RjM3Qi9SSFpJYm1aTDFrSVZqZ1J1bTRrd25GNmlGTmlX?=
 =?utf-8?B?cnp3YWYybjRVVUtWQkttVE95dzNyUDdvOGMrNlRiK0YzcG84ZWF4WEJBVXpZ?=
 =?utf-8?B?R0p2VXFUT2RveURpMk5yT1YwODRhZzIrMjVDZXNhMFU5UzhGUnhlSUhXeTVq?=
 =?utf-8?B?YTBpbDdIVXVjYVVMYjVzbmFkb2Vvc2ZpUDE5OUJ5dVIrcVZOZm54eEJsVkhW?=
 =?utf-8?B?eml2T1RucHlMcitFRVZkUVpVNE11d2lMTTR1cUR2V3I0ZTdXb0l0STcvOGVS?=
 =?utf-8?B?cmhLdXBtNko5M1YvVzhqUkhOOGdJdVVQM1hHWm96Q0ZKMm15N01UNVdrQUNm?=
 =?utf-8?B?alowRlBPamxzaVdJdzlObEVLUDlRUjdMTURkTEkwU3lkOHM5ejNIcXBQekFR?=
 =?utf-8?B?OHg0aGpCd0lSMS91TU1RTXhjaXlZbitlSzYvQjlmU2dCaFIvTHFycnE3ZUZz?=
 =?utf-8?B?SnYyaXNaNFhnV2FBNkN0clJCVFZyZmVhOUxEUzJmTEQzOGVOT0l4c3BKSnJK?=
 =?utf-8?B?aWFHMllnbHNCc2tXY2Z5Tmo4NTRIMExjSXc2a040bDduWXJFRlFqVFVQZ2E3?=
 =?utf-8?B?NmQxQUovWXJjK1BQbDBEcGF3K0RNU0RsYUVhRjNzdlBnZGtGU0N3Nytnc2Vh?=
 =?utf-8?B?aEIvY3I5cFU1NEtZS2t5M08wemV1T3U2djE1ZExSZGdNdE9wN1ByeTd4OTBm?=
 =?utf-8?B?bmV4dmtpSE1KaGNWWlpjbU1aUWNWOTRTRW1tWjZRc1lLa2dkMjRrWWJSZFBZ?=
 =?utf-8?B?MnFueU01Yi9mM1hNOHFkUGJJWlFYemVsUExHaFRiWWxPT2xQcjlTVXYrUlNQ?=
 =?utf-8?B?eCtVemlQdlo0bi92L0NCUjJWeitTWjhEK3JzNEtlMzVQaGUySjFvWDZPWWxP?=
 =?utf-8?B?ZU1aWFlITXV5b2lxLzc4bVdOQVhOOGkrSWw2VDdUMGVwREgxWno2L3U2SGpx?=
 =?utf-8?B?N09qaU9vaG15VSsrZGdrczlRT3Fkc3JLb0lMVkIxaXFzZE8xMWV0Q210L2Iv?=
 =?utf-8?B?dTM3eFFYRStpQkNnbW81TWx6cE5BU3lkZEN1V0lIUmlTUmdleHhJYnl2MnVh?=
 =?utf-8?B?NXQ5OVVKZHNRTkZRNE80NDlERmNNdmR2TnlWeFBoK05PZXB6MVBDbUF1YU13?=
 =?utf-8?B?RWdDOWJIOWQyVFFwS3NmaWhkSXQ5dk1NblpVenlXUUZSNDIvSnF2elpieE0w?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea49dd0-6eba-43ed-32d7-08dd82176812
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 03:32:00.0940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jw31YQqoU0LFUbUt9n8JYknQkxIaOaCGBOB3ybMK88ZMJmFe1skUpqQe4kofLF5SQvlG/GK4o7dKWR9ZlO19tHL8AVTS64v8h+pUsoyLCHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4923
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Add major/minor discovery for the FWCTL character device that is associated
> with supprting CXL Features under 'struct cxl_fwctl'. A 'struct cxl_fwctl'
> may be installed under cxl_memdev if CXL Features are supported and FWCTL
> is enabled. Add libcxl API functions to retrieve the major and minor of the
> FWCTL character device.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v5:
> - Add documentation. (Alison)
> - Alloc path on stack. (Alison)
> - Deal with out of entry and no match case. (Alison)
> - Make fwctl operations part of 'struct cxl_fwctl' (Dan)
> ---
>  Documentation/cxl/lib/libcxl.txt | 21 +++++++++
>  cxl/lib/libcxl.c                 | 78 ++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym               |  3 ++
>  cxl/lib/private.h                |  8 ++++
>  cxl/libcxl.h                     |  5 ++
>  5 files changed, 115 insertions(+)
> 
> diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> index 25ff406c2920..1e00e2dd1abc 100644
> --- a/Documentation/cxl/lib/libcxl.txt
> +++ b/Documentation/cxl/lib/libcxl.txt
> @@ -42,6 +42,7 @@ struct cxl_memdev *cxl_memdev_get_next(struct cxl_memdev *memdev);
>  struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
>  const char *cxl_memdev_get_host(struct cxl_memdev *memdev)
>  struct cxl_memdev *cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint);
> +struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev);
>  
>  #define cxl_memdev_foreach(ctx, memdev) \
>          for (memdev = cxl_memdev_get_first(ctx); \
> @@ -59,6 +60,9 @@ specific memdev.
>  The host of a memdev is the PCIe Endpoint device that registered its CXL
>  capabilities with the Linux CXL core.
>  
> +A memdev may host a 'struct cxl_fwctl' if CXL Features are supported and
> +Firmware Contrl (FWCTL) is also enabled.

s/Contrl/Control/

Also, do you mean CONFIG_CXL_FEATURES instead of "FWCTL", because
CONFIG_FWCTL is not sufficient.

> +
>  === MEMDEV: Attributes
>  ----
>  int cxl_memdev_get_id(struct cxl_memdev *memdev);
> @@ -185,6 +189,23 @@ device is in use. When CXL_SETPART_NEXTBOOT mode is set, the change
>  in partitioning shall become the “next” configuration, to become
>  active on the next device reset.
>  
> +FWCTL
> +-----
> +The object representing a Firmware Control (FWCTL) device is 'struct cxl_fwctl'.
> +Library interfaces related to these devices have the prefix 'cxl_fwctl_'.
> +These interfaces are associated with retrieving attributes related to the
> +CXL FWCTL character device that is a child of the memdev.

I assume any other fwctl helpers that might get added in the future
would use the object so I would give yourself some wiggle room for
cxl_fwctl to be used for more than just conveying chardev major / minor.

> +
> +=== FWCTL: Attributes
> +----
> +int cxl_fwctl_get_major(struct cxl_memdev *memdev);
> +int cxl_fwctl_get_minor(struct cxl_memdev *memdev);
> +----
> +
> +The character device node for Feature (firmware) control can be found by
> +default at /dev/fwctl/fwctl%d, or created with a major / minor returned
> +from cxl_memdev_get_fwctl_{major,minor}().
> +
>  BUSES
>  -----
>  The CXL Memory space is CPU and Device coherent. The address ranges that
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index bab7343e8a4a..be54db1b9bb9 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -88,6 +88,7 @@ static void free_memdev(struct cxl_memdev *memdev, struct list_head *head)
>  	free(memdev->dev_buf);
>  	free(memdev->dev_path);
>  	free(memdev->host_path);
> +	free(memdev->fwctl);
>  	free(memdev);
>  }
>  
> @@ -1253,6 +1254,64 @@ static int add_cxl_memdev_fwl(struct cxl_memdev *memdev,
>  	return -ENOMEM;
>  }
>  
> +static const char fwctl_prefix[] = "fwctl";
> +static int get_feature_chardev(const char *base, char *chardev_path)
> +{
> +	char path[CXL_PATH_MAX];

This CXL_PATH_MAX approach stands out as different than all the other
path buffer management in the rest of the implementation.

In all other paths ->dev_buf has the scratch space for printing buffers.

It's not broken, but it's also odd for one off functions to switch
schemes.
