Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43D7367B93
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 18:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782844272; cv=fail; b=QEt854QcM2/B3f4LyedioiB7rAWTUuQp2AIDwVkEtlghUtFZH9zt5Hy3yK1J78TJJ6bZFgDUVtJGeGvKqlLV7B1hmhlT6w/ATQefZkU3CywETkR7dSEm8DiG0Y29/39nXWcb/fcPw9K0LHpzFrAMeSF2ZSLeQ3W0Pm+im3/1hwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782844272; c=relaxed/simple;
	bh=b4YXJ8Kj80YmIeVxj+dr5Opyeo2/7ZQAfY+v7EJ7Smw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UWbnasMW5Q7lSrOmdU36GuY6on/pHDP2xTbjWHC9VOAjZi4+cYHTDpcxL4VCO7+3Wt0I4/iAnl3eVPticKh0pcvA0orZ239QEOHY3AuTizrEcU3D3ri/u/0qXWS3AzXQ36rnv5+G672rklgIleELB5q4YFe+G/AfshXc3apkx/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kD8SGs4Q; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kD8SGs4Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782844271; x=1814380271;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=b4YXJ8Kj80YmIeVxj+dr5Opyeo2/7ZQAfY+v7EJ7Smw=;
  b=kD8SGs4QgKeD172XLHdjq3tFBw2kcGv+uF6Ctjnl9MWOEE1/jY8B0vPT
   6LzKvor6ihr+EhGAoYk0nsSJEn8wLO4IY0X9IWTv6KnQiz4WncrivpUl4
   uyPJMv6VJ3vIqAuzjWKyuOP955QLZqjKJuLo88sfGJiH8K1paihTs6kLO
   jOT+vccYU1ow8uDubeevXq3xJuNVZ8qMBT/qzM2WhcZMiw5o2rNCQiRj+
   GjeopOWK7uWcjZaPhSxqS5eVo9WvATbhhyCvXav6Z2fIPR5NptJWyyXJI
   /7lS4sGGa7xUsHliJ0QBmPzUfK0mp+IWPx/M67qhr21NfuyDkveKRtNsb
   A==;
X-CSE-ConnectionGUID: DP7kofxEQceM527p1RPUgA==
X-CSE-MsgGUID: KMTbqKDXRpyYVSYyssU+kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="83565334"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="83565334"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 11:31:06 -0700
X-CSE-ConnectionGUID: Kz7Ep69QQJqOqYStB93MTw==
X-CSE-MsgGUID: RsQc+y/CQTS8PqWtWlxlAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="275565876"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 11:31:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 30 Jun 2026 11:31:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 30 Jun 2026 11:31:05 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.18) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 30 Jun 2026 11:31:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YWxoh9AtMa9Dap8ldEf6Dl1vgSewf1cwqc57y6cU7TTLMjPiGbOSZ6nvz9J3ygDqkGRNy0+s+4YiOrUTc+idd6Nw3B6ouLD+0itTgIcMATbdTQgQGUnFTE+KbuZL+bhhlqCShaRWd7v5CfoTbuNEumU07FyDyuZzYk9eEWF8JJvRCFpwX+UdlwV8g07cvpddyk8Ig5fK/MSqwU8wR3iqBWnECxUAeh4yojuiDZfOUCdIhGN4zp6DrP32ieRTe4QR626kpHH7so+Es8cZBmyijPGzUeM5RCKK5VPKCt5yMjv1dnsU86knVSMkOLoK1ci5Mozp8txzuY1bZD0aCB//aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMVt219R8N2769wnbWQh4HTp4BFO516dL2QvtlF/W/w=;
 b=bhV0z5JA9Cs+7te8VLYeiT/wx02tIyp6+IGob29eMLb4BXn79+ofy8gUEOZjCjSxgw2SJprBUwn7pPBq/UnX7WoHOVQghFkGOL8aoSzFQ2GukDrM5UezK8YwhlWyAz+GoTOa8jeLAZ3FJgDEXm6TJiFtIkgzhHVy2ql2KtaWIz5LNyChdmUo23qXj1QsmqWd1YnnOG88CUcnhEQiJVRMTkwTA0ki0eFpkXb+QdyZCBr0Kb7rr/4+uTHW0E5NsL02vDdY7XfSyWjLrYpD6ZN0P0MaWApbOAVENiydaPdbHI7K9jHwPqFd8Fuj8d9NU5ddCadSl8g4aW26vG0zJ1+pXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB5767.namprd11.prod.outlook.com (2603:10b6:510:13a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Tue, 30 Jun
 2026 18:31:00 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0181.008; Tue, 30 Jun 2026
 18:31:00 +0000
Date: Tue, 30 Jun 2026 11:30:54 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Richard Cheng <icheng@nvidia.com>
CC: <dave@stgolabs.net>, <jic23@kernel.org>, <dave.jiang@intel.com>,
	<vishal.l.verma@intel.com>, <djbw@kernel.org>, <danwilliams@nvidia.com>,
	<nvdimm@lists.linux.dev>, <iweiny@kernel.org>, <ming.li@zohomail.com>,
	<kobak@nvidia.com>, <kaihengf@nvidia.com>, <kees@kernel.org>,
	<newtonl@nvidia.com>, <kristinc@nvidia.com>, <mochs@nvidia.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [ndctl PATCH] test/fwctl: Add Get Feature OOB rejection
 regression test
Message-ID: <akQLXl7UUQg5rizX@aschofie-mobl2.lan>
References: <20260624140006.50773-1-icheng@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260624140006.50773-1-icheng@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0213.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::8) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB5767:EE_
X-MS-Office365-Filtering-Correlation-Id: 62ff337c-7106-4aa6-509f-08ded6d5bbd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: 8r/cawf/JtjTi6fZ95J+f0QkAhR047R08AeJPs4jujfw0tODLNgFUB87iadnP1A8gv6bUoOyEM7acB0bu71wOhllAAp1bQjV+6A2MupyN9NfbuISb3w6bjRDSF8vtkB8q1IU4oNNTwl7nZR7RWyc5/RCNGQL/LeTh8Z3MB5VrbF4paeBXDfGzvM0cDoIp3ZU5qyBgIRXuAqyJEkiPcXFmSRwlvHHMwFfXz1N9KEZ7xGbo42cDf7rlIHiJX9+YAWNIQLIpwa1VKMqxMS2Vp+PBMFBqHNpcRSLmxBvprO7tFunXurcs4yeVYvmRiBmHHCXfzBhu4fyI76owB4j3y0/jI7xKWyAMb055heUfXjvPiqac0TYWAu68e8iimLRt1xmB0fbq/C77XIQhggtseiw2zfgDiEOAqMKQRpp0E7M6i8E/6TT3KXJqjZyW7KU4LLspSsiffgax5J0MUORctPLN5YFw73pB5yhF8LEHGsi2C2NHiGbitBwsu6L1jhxCAuFcu+9gY31WBRmSdtffq+vwGc8XlxDRtQuZ+m57vBcloPw/QumNQLwkS2jZhSw/kB05Aup50u3za3Tq34MjQg4zT1BbCdvbm2+bRevHQwvcrnXJtkql1u/p8yidE5UmWSj0TmlxMxI6QEg7ce827MyNsS47D9lAdJf+yps8IG+mq4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WZ+FyPUf+k+eApiE5F4tx9vzdL2dIcd4EbsmOf5iaGeAckKtdud6Il7z7iW7?=
 =?us-ascii?Q?2r5/P7390YprdGzq+N3K47g7qVHw5YUIXswlirPZugbF/wCvtemMsamoG6mV?=
 =?us-ascii?Q?eeIRSR+P1LXpWaVgMGKR+SOPr8JSbh2rC8+qVXzdrieCMyQaV2WIFUYHABrh?=
 =?us-ascii?Q?6hRVM4PtmFxVMOC1XPm72shs7qF495tmL9a2EzRoxoN7JX0E79lPa7wAfoM9?=
 =?us-ascii?Q?xHhaseAew+PMjsVfkwY3bBqkn4W/vG5acEv+6tnsX4BFNWyKdoLXAFBowWwL?=
 =?us-ascii?Q?4jg47xxWf20A1YyX0n4tHpD3JwrTOLl2dKqyuYepGbr6s2dqtLySmGoQt8zh?=
 =?us-ascii?Q?wjV6E41eqW/6HQdfhV4Ot+/bVJ44BzFUTHlUnarWqkPJVS5pkzUhFWKhWIP4?=
 =?us-ascii?Q?7fXY2dwUr2h+0BhZ/BeaYNaHzgVV99YArmaspgmrXRt9iKp6zVO0bs7YxQEA?=
 =?us-ascii?Q?mLz2idkgTfutC3ZlkeSdyYtZL5ZE+aAYvmIJZyT+od2DH6HOh+DKUAcQNQan?=
 =?us-ascii?Q?qm+xtX45an0ciDv592moSK3jPn3KMauu/JDKy0VMAYf3PBX7L5vTyJscpTOb?=
 =?us-ascii?Q?LQDR+cfZ+tKG4SiNcfhqiMOYMxcx9KThxi3heSWefKm65FfG7xTwLdFaSh/o?=
 =?us-ascii?Q?U6raG71KhDpJcwW24boC6a4WYiXSbR0Sv4G+3ZGpCfbveNKy0V1Bc/fgOyNs?=
 =?us-ascii?Q?yv2yt0US6ulPnmxHCTPowWwTTq2Kb3PvIzeaLs5RhQkfTHTN5dyuHmKoKp5h?=
 =?us-ascii?Q?0K0saCj177UHLEyopoPU8G9xDQhqrRMr0jogn6ZA/qaWo6w5G3LAdVtTtD7a?=
 =?us-ascii?Q?bdEU8HscXcd1rDr+KU8gvED8CcfrZbQUEzU/iFP0YMcShKC9oyZHmVKWpH78?=
 =?us-ascii?Q?Ems9nDRtIprhfJfxL4IRHL1REe9O43RRVH7/JUiTa7F+xFDXqJI13zBCBfyl?=
 =?us-ascii?Q?fRYH4DUQHMOx2x45UmnESQVVSxLkjANC6g8KySdHbPw98JGBqpKnX26tI8li?=
 =?us-ascii?Q?UEIZhs5KbS/+kd1dmPwC+sVBNzWyeQaYr22JkA6i8E4eLpyVGKAXRcVjui2Y?=
 =?us-ascii?Q?UKE8hZ8U9BtGEvvX8dPP7yUvDYCk0GP/bPz4NX+Z8nV5/lTHyqHeEA/LfaaM?=
 =?us-ascii?Q?UzNoI/jkjhNVW4YEcJDJQzuADbum54o0B28nHZmqfA91NNK2biHt9S77Yofx?=
 =?us-ascii?Q?U9EKMiYTeaRKYENC3mhp0KHH1f6+QO0RcYSwA1EQribHsGGxRJ9+qTg8pfIg?=
 =?us-ascii?Q?g7YdtZzAPflnWO2GOHmhCdAOS6lP/rerxlvUsPWg06N+JQ3JBQSYhWHrhtOP?=
 =?us-ascii?Q?rih+8AeHV12AbLkhb36F2DoCLGgLgWa48rnT2qI/UQY36kSJQTY4IdUuLDdP?=
 =?us-ascii?Q?Rl8gA8w6HVN9z1q/tmXEGPfagypgSjJwRvinSxmUnx6wcrjbKq2nzMEPHlIs?=
 =?us-ascii?Q?fwHF7hR2wLTo6L39kv1qweT36o5ax3sR+XIc9ir/i9bi1GuvWaXVGMm630iy?=
 =?us-ascii?Q?CDnrEpGuTmYqMrU3tFCwBar5S+F5Y9hdySo22VHkJNpPYHciFKdrigT9LMIe?=
 =?us-ascii?Q?gU++JU1jM6r0T7lO21JRZVOThSDaEPbnOYAXB/zVLgZW9FXGieIEMMh5ecls?=
 =?us-ascii?Q?MBcuans15YlFYPKKBacrC/zRHBTP2gzi2ih9B1pbf1W0hHDt8DN9ZuNM9L7W?=
 =?us-ascii?Q?MzG4W1sItIfWT2rJD0ePHpbmQ1H9E9P4ya4hrz7ONrE3/RYvxHwQzoGe2D1t?=
 =?us-ascii?Q?dHM22MrblTr7+QsGBKVsSFn8G3JFVes=3D?=
X-Exchange-RoutingPolicyChecked: m50SsojgXB/POZkRfCq1Eoltrp0A3Zd1+yUTA9QofSXxnz91wMgwzuecwWvNEjrK/cdSWCIBcB9jo1Dc4XoekMDpG4HM3ycz7oZtmYayTC2NeLooz9FmYaPNaffTziaUddWBYPAbI7dPNwVQh4Wl1cqVIZeJnXXRKY53n/AtFkrPpifcBCPSw4OsYCDtAgoqXDATND+zVcufAFaHZBSVVcAOYDjNmna4ng+7+jHNSZ346TuR7fz2Y8xhx7mrlMSiRYTKEcfywzXyN9rkW9r/KasV5dtRJbPQAddYLmx8p5SAS8kgkLPvIhQgdxclqRMY9CUWPm4/BTaTV0lhNIQxAw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ff337c-7106-4aa6-509f-08ded6d5bbd1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 18:31:00.3757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/N++6pafJ0ukdOeSxIgSGvEI8pz0tl636023NZfEultB3y7nXm6COZyEUNSXJf/cr0/IOxrKEmdPzJhI+/6VcPd73Bdrgj4HQOHphoWvqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5767
X-OriginatorOrg: intel.com

On Wed, Jun 24, 2026 at 10:00:06PM +0800, Richard Cheng wrote:
> Add a negative case to the CXL fwctl test that issues a Get Feature
> FWCTL_RPC with out_len == offset(struct fwctl_rpc_cxl_out, payload) and
> a non-zero count. The kernel must reject this with -EINVAL instead of
> writing the feature payload past the rpc_out buffer.
> 
> This is the userspace regression test for corresponding kernel fix [1].
> 
> [1]: https://lore.kernel.org/all/20260624134737.49166-1-icheng@nvidia.com/
> Signed-off-by: Richard Cheng <icheng@nvidia.com>

Thanks Richard! 

In the unit tests when we have cases that depend on a specific 
kernel fix landing we prefer to gate on that kver. This is a
first though, because the gate needs to be within the C program
not simply using the check_min_kver helper as is done for the
test shell scripts.

I think something like appended would be useful here. See if that
works for you.

I only tested without the fix to confirm it fails the entire fwctl
test. I also stopped short of testing with the fix because I see
another patchset in flight grouping bounds checks and figure you
will come back around and update this test patch similarly.


diff --git a/test/fwctl.c b/test/fwctl.c
index 69d0048c09df..b18a4f10717b 100644
--- a/test/fwctl.c
+++ b/test/fwctl.c
@@ -6,10 +6,12 @@
 #include <endian.h>
 #include <stdint.h>
 #include <stddef.h>
+#include <stdbool.h>
 #include <stdlib.h>
 #include <syslog.h>
 #include <string.h>
 #include <unistd.h>
+#include <sys/utsname.h>
 #include <sys/ioctl.h>
 #include <cxl/libcxl.h>
 #include <linux/uuid.h>
@@ -21,6 +23,37 @@

 static const char provider[] = "cxl_test";

+/* Running kernel version parsed once in main(). */
+static unsigned int kver_major;
+static unsigned int kver_minor;
+
+/*
+ * kver_ge - is the running kernel at least major.minor?
+ *
+ * The C version of the shell suite's check_min_kver helper.
+ * Test cases for fixes tied to a specific kver, gate here so that test
+ * cases quietly skip rather than fail on kernels that predate the fix.
+ * Acknowledging that doesn't help testing of backports.
+ */
+static bool kver_ge(unsigned int major, unsigned int minor)
+{
+       if (kver_major != major)
+               return kver_major > major;
+       return kver_minor >= minor;
+}
+
+static void parse_kver(void)
+{
+       struct utsname uts;
+
+       if (uname(&uts) == 0 &&
+           sscanf(uts.release, "%u.%u", &kver_major, &kver_minor) == 2)
+               return;
+
+       kver_major = 0;
+       kver_minor = 0;
+}
+
 UUID_DEFINE(test_uuid,
            0xff, 0xff, 0xff, 0xff,
            0xff, 0xff,
@@ -208,6 +241,10 @@ out:
        return rc;
 }

+/* First kernel release with the Get Feature OOB rejection fix */
+#define GET_FEAT_OOB_FIX_MAJOR 7
+#define GET_FEAT_OOB_FIX_MINOR 3
+
 static int cxl_fwctl_rpc_get_feature_oob(int fd, struct test_feature *feat_ctx)
 {
        struct cxl_mbox_get_feat_in *feat_in;
@@ -217,6 +254,13 @@ static int cxl_fwctl_rpc_get_feature_oob(int fd, struct test_feature *feat_ctx)
        struct fwctl_rpc *rpc;
        int rc;

+       if (!kver_ge(GET_FEAT_OOB_FIX_MAJOR, GET_FEAT_OOB_FIX_MINOR)) {
+               fprintf(stderr,
+                       "skip: Get Feature OOB rejection test needs kernel >= %u.%u\n",
+                       GET_FEAT_OOB_FIX_MAJOR, GET_FEAT_OOB_FIX_MINOR);
+               return 0;
+       }
+
        in_size = sizeof(*in) + sizeof(*feat_in);
        /* header only => zero payload room */
        out_size = offsetof(struct fwctl_rpc_cxl_out, payload);
@@ -463,6 +507,8 @@ int main(int argc, char *argv[])
        struct cxl_bus *bus;
        int rc;

+       parse_kver();
+
        rc = cxl_new(&ctx);
        if (rc < 0)
                return rc;

