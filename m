Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F97933D6FA
	for <nvdimm@lists.linux.dev>; Wed,  1 Apr 2026 19:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775071783; cv=fail; b=joR3gKMbbkngxbCUp0m9X+2VGvZOcKqs4xm52+RR0XyGIvCVr1pBT+xBz3v/C3doPmFFZITReMgM15c1DSi4rliknbFfW1RWIdQ4I/8T5ua5fXlUxwRwQYjt8m7iqkH6NGuyZd8PMG2Pa7g5nLPzjOwGuM2vQGPrkOxmKGQhD5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775071783; c=relaxed/simple;
	bh=Bb9FFoDkW4cF+UJ9kqAQGS8U549J9wQJ1mmMWqOiWbE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KdmLBv4I9fenaRe9SNu9PqmmA9loKbs3U0ZLGigGDdjqTiwDiaKeaHcjVetxH/lrOZRlgUTyXBrsE97MUVx0tAT01aCQTvTivpJYHJP2IrS3vNAkkCpxnKU9yuA6s6IWCNw1Aaado0LbMcgDrV4tGXX4Zg/vA/6CZ3TthDai3Yc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SkgGqQYk; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SkgGqQYk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775071780; x=1806607780;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Bb9FFoDkW4cF+UJ9kqAQGS8U549J9wQJ1mmMWqOiWbE=;
  b=SkgGqQYkMYP0JyTmD7hO8MZ1lPtmCVwPadWiGCsG9JlR/Alftq7bfNTR
   YvfocH1X6Pd+Sdu5MVUttWRoSxpG5+UiAyVtKvfDwpr/3efaklQ/X+AUd
   TmtvDBJXWQ5jF4jDzscmQqESYqTehX5OHZ4OHRxrVgnvRT2WZFVDpo6U+
   +LVX9OnPkfVeV1ShMIEfNW4IhppS7zV6D59wf2/HuorGD4yhKuMakPtuO
   Crm1W1sCD4ERiOeETTPk0TpYDb146FFasisPiSyuLCfxg40VfuiCgeGnR
   JGpGRVAx/MdKdMN+qOJTXM2Q8Awbdud4yus7x3/6OxgswUaN8K62MNM+v
   w==;
X-CSE-ConnectionGUID: QnMusw7nTM6iiAPnx25HoQ==
X-CSE-MsgGUID: +g6whs+EQFanll4OzV6qpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="76087720"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="76087720"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 12:29:40 -0700
X-CSE-ConnectionGUID: 9pH8f/oiQsmtJfdPlkrQHQ==
X-CSE-MsgGUID: Yn4jt5evRMuQks48Vggt2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="225757014"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 12:29:40 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 1 Apr 2026 12:29:39 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 1 Apr 2026 12:29:39 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.7) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 1 Apr 2026 12:29:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jysnXkXFFY95+DA9W7ws0DNJtGyquiPanKge6zFmsM2JBFdVppEugj+2X/btXFl6M9L/Z1sVj9eyuEBzsvLXI+wXNTUQ0OJIFG8kOynW4XfNXe6FfLCMgAxyaxtjbyf+bsgv/zxabXEH8vz2coZ0Nv4/V6/ZMfZuyI5aw4Rco5Ctgj779P9hpgRfGOjCuWgBO3yQ3v1ykpPvafrBeRs0uWZSjmOaAeQ2Iy+yM5qsfUxaotqOOabnjv08Pxh5JHtG7AsEpKYLrOM56tu9djXM/k8kCKn94HCoaxj/0fRgMk6DytJczIfjIlX9HzH+I8PJUMDSu78OHz1lQ8CqdDrcQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WavBaBN4cnHmbKbmo8GSrm9G7fCHSxj/vckgmacS99Y=;
 b=l57TQ43IN+xnzm6r9PP5Nw/vXcJu0ulaenSw6B4avLNG5U1Aj6gtKZVa+45frlccF+0bDazCPU/I17KWY0GFgBN6XAzZCn7q2lDbewVNHGo/W5ux+g2pymy3aNhimDgjiAZApoD5kpouD/yfV7KikagBTfGeo/BE9H/flLKlxpny5pfUxpAz3LnxfJSIW3uEDFMDpvxcbA4gXodWPrVKCbIvh4K3R9WLfa10ia1+/yLsF9TPAiV1p8zWnawayMngfbiE4LdqdRGt1CmFuBbY04Ppz9R6r6+UEpAP1wPLRZEB9KLrYfRn+bapfytgH2qfkW+I75v4/PW9q114Qd0v5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA3PR11MB9136.namprd11.prod.outlook.com (2603:10b6:208:574::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.12; Wed, 1 Apr
 2026 19:29:36 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%6]) with mapi id 15.20.9769.014; Wed, 1 Apr 2026
 19:29:36 +0000
Date: Wed, 1 Apr 2026 12:29:32 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] test/cxl-topology.sh: verify dax device creation
 for auto region
Message-ID: <ac1yHMXwW7YSUn1P@aschofie-mobl2.lan>
References: <20260323220148.2620066-1-alison.schofield@intel.com>
 <9ce7c8ba-eb09-4569-b39b-147815b0e15d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9ce7c8ba-eb09-4569-b39b-147815b0e15d@intel.com>
X-ClientProxiedBy: BYAPR21CA0023.namprd21.prod.outlook.com
 (2603:10b6:a03:114::33) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA3PR11MB9136:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aaac431-4de5-451f-47e3-08de9025022d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: zibeHbg3gjTEkBnHG47Vk/yaBKYPy9bcKF3HcKSSU81fXJLBz2I8/5pl1BjOa/QWVhp4pXlMeiLOxwD1GcecFvmwHD3yiGQxDEhwQOU4Su5h+7+XZEE8SflwTAIZwuGlZNrGHGNEwDjADNgeOLJr6Z2x8N0//KtgWCIm39gV+CuSbWWm33rcngXRC5IvMI0OSYaaPXoDvRNl6F859ojS6PZCqtG7XPEyLj6gMsaKcHHZR0Tjgmhkg1+qzY0B7MyoxFeVHQV0MGWhXj0WEOWc8+CkL7rDLs+vcPlhnxL/QBpTWiAi5SmC/LMLuJ+noJ2Y/yoHqMQHaXq3xraYopYjxgbltBdQqy/ZyoNEWSxFzGceO31C1BGx3BiutSy15cY6+8WjiVXrlh3HEwK5nHM3vVtgPF5xqGFxgkT9HHfWi4Kj22qb+U1/8xg8hT2aGsVRmZpxuoSghf71UCsxvjJKAzjbp9sbn44F4gW+hsT4R00dFUKwHzT1vVpdXhl5Ule5MYMjmlhVQf39hU7zYn5QF9Jh9At+KUTJ4BvRIn0xmGFQ1tdZrwSSP4Qmxm0f15MyzFG+qWbELU10iG9DBdOEAsHAYi5mC7tl9M5hsrycmEdVElWA7MsE2yKPVAfwwwCW9U+ldAKMSBcCOTGxcJ/qUGr0ysw5dqsQOloZdD/6MwHam0ePPaOKBCnoLbkqvFnZ+yrnf03xyj9urJBsmTUHyVt+iobCBgmky7z++oIC1hQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?es6rhaK3Qj9aRXp+K/f7SqLkzKOPeyR9Kb16/KpWold54DpUMgqAvnZsstgs?=
 =?us-ascii?Q?zkIbSd8AvoviRsjLj0x5zEFscLISRBgVgBSTBRMahuRRw9mMMDCi0J3TP1fw?=
 =?us-ascii?Q?hhwj6l36cat5jJlnVoDU+lymuCL6YR/7KYRDLJGpqjq97UMvRTC5hxmKEx0o?=
 =?us-ascii?Q?Sk0TSREJTMBwKlom8nraOilJ81csdFzJEGcVxoD/12dxQektQfMbmso6gFKn?=
 =?us-ascii?Q?zKQht8XqIRIfw7fH+T5t/ba4/2hxpO26txvfkaDqzSUjKpQdniDixJ5ZJuEf?=
 =?us-ascii?Q?Wijc6TOviBUyejBLQSuznyp3doCBmEpwOMmVwxODCegM0y/EZZABQ7Sd32aq?=
 =?us-ascii?Q?v7opXBs4DBvO+9u8JPL8X/VsNJOI6T7xoQtn6QWSE4+CJ0ISatMP1uI1/DmA?=
 =?us-ascii?Q?lZCdpsbBTIk9qopVTRZlaPO6bySKgKtjT7pvmpp9kFnL2Qz/Z7jRKFMfCdHZ?=
 =?us-ascii?Q?JNvyxM3q8sc/+JOHTrufZSSnUExttFDaI5gqj9+ho4+P09IlEN5ZmjZWRNMo?=
 =?us-ascii?Q?w6kgxy3Ycta1BsvzxkzCSujScAzG4NpBLjkSz6A+tieTyO2QfvHOkZ7hs61Q?=
 =?us-ascii?Q?YmcJeZ4rI1jYr2MVEeXUxCXqokdXDcby3Lo+c7L8WT9J9bUjgIGPgFQYW4aq?=
 =?us-ascii?Q?CLoBPq/r6eEucD500xtL2C1A5X/UXn+68p0c9qF021hLKyqZ5YDIuikAZlU6?=
 =?us-ascii?Q?9F8gNK/03ATsXNpRRT24CEoqjPosO3EQLkKJkUHJ+Lbcm41tMUGeCsEz+jjt?=
 =?us-ascii?Q?wFsoM/FhjX+U7QkrFbbG+9r2H2uNmJtp3Z4dAQFbSmZjNnHZwsrNTTGpdYuP?=
 =?us-ascii?Q?xGXY00ZAASF3w+jAxfChJvk6I+beeQDrpds9E8mZ8SqaDDUP01cujvBxZa1n?=
 =?us-ascii?Q?8VFmR8ZItTQ8FtWyuYw7QpjWWkXUYgdibXzugb56yxcS5ew+3BH93bJvHJRN?=
 =?us-ascii?Q?nqco4pUTcbJrc2P7NrE18EXTt+nHpaQmXtO7+FICi9AClgz/Ut1VcsPJQxEf?=
 =?us-ascii?Q?M67O//SrtProtR+gDVPwRBxK42T5GPuNp0iC23Nj3RnCTBXW7QwAeGqKwv7o?=
 =?us-ascii?Q?E8IvDs2KcBeWWQZPwkJr85FWle4gKnrHWvbDxSSRNBMYFrnmNOpaoKgzFQDw?=
 =?us-ascii?Q?Bg2V/g9l1GNgKX+GnCcXkuxfQVbGDWC6SzWtkZ8JbO4UNYzW7WCFyWK79VN0?=
 =?us-ascii?Q?s6wDCarWGE/o6rmNwhAbPtjrVLyLTeXe54I/ADsY7JnGgpwSAk8hg9eTED6t?=
 =?us-ascii?Q?ITPqiE+PSCCaffwBPHnlATL65UEiCELHvcS8c4byQnCYIwBSFlSWmNx4ZK/h?=
 =?us-ascii?Q?ainnsTT48+L8NtbCzV972p6c2XpllB+rw4nuA0xvw+rIJ4xhjJoXjeb9Fl1Z?=
 =?us-ascii?Q?yygUi+QB8MqL4d764bVLJMNpb45EG1zUUybLwnjXeAzuY7vE80TUIzoZOyYe?=
 =?us-ascii?Q?B3IdrCARcWydMHvD7ShbRHGlJQnVM2vNDEzElj79BUiwVfGonBPqw2+ubExj?=
 =?us-ascii?Q?FOuX1wVUx5iXHqQpVuc5A41U3MOEgGjnvfoCemKJXFtKmTu1zvBrtjpdIB1n?=
 =?us-ascii?Q?y8WVq7cEWN0Utnffh1mT+DkKzWoccACmPf7rby9OQ/4cs1etbT0u/drHnwWZ?=
 =?us-ascii?Q?OL+kBLEqu/qf6pd/xH76/kTIF/5u21ZqQcARA0pk2+VWWKfUcSh9cImnV0Qf?=
 =?us-ascii?Q?6Oa5vkqcO0UDbNcEp2b6WTEDIvdbTU+AhVNl5jHya8hwWYu0Fg0ys2tcB9PG?=
 =?us-ascii?Q?X5pikPQIEd232+N+ADd7GHbsDcfSEVQ=3D?=
X-Exchange-RoutingPolicyChecked: JDUAlSkEPITjFQkyLA1k2eFqNAO+ymJgCHWDoCez3PF9h77U33e/EJ9AAJ8549+dsuBWdaC5DXfTal2GQKfv4VisQhe666rwnzjsyHZE7bfNsj5wtldfihC5TdecvD5FAHnEGsQUnDkp77LG4AJb8+6O2wYwB7YG1VgsUaZj0Ox0iJ1ndooYwIwJI1+6tfvvvQJdC/1LuCh60IozpTk0lWZTxoR/xHju2992kwwxgTxdX0zC1YD9iLeYcJgqqqTdGMhg263zOSZaCI53oWXDmy5GrDaMQKUpW739uY61HZn7LuEpsRRWuNcIr+8N1cKPcL/SMyiOpFIv1cBkbSvwzw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aaac431-4de5-451f-47e3-08de9025022d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 19:29:35.9492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZNlUperCT1w4qbwaLGZEeLrTibo0hyNCsbkaAjhyJCXNjeKyp1dP6PX9FXzaa4NI47u2EdAqlKXLv0e4lv4MLR2uP6el+fcjrdJvqK08Znk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9136
X-OriginatorOrg: intel.com

On Mon, Mar 23, 2026 at 03:25:48PM -0700, Dave Jiang wrote:
> 
> 
> On 3/23/26 3:01 PM, Alison Schofield wrote:
> > The auto-discovered CXL region should create a dax device with
> > matching size and resource mapping. A recent regression in the
> > no-soft-reserved case broke this behavior without test coverage.
> > 
> > Expand the existing auto-region check to validate the dax device.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> I'm terrible with Bash and jq. AFAICT LGTM.
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks! Applied to pending:
https://github.com/pmem/ndctl/commit/38068a574696

