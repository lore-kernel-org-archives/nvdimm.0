Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472F630F92D
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 00:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784679775; cv=fail; b=XG9gUtOpL3Na1AZjqSmTXBsMAKWvn93KHsnrdRIzkkY0WgmiOD8SuNjsinJQEKRh4a6p6JE1tMpkI6wQnsFOJGS7Jr5JaoYHA08egCGW8nwmJglgd+ZOQJh07ZEf/83gpZBHXzG62ivlUZXj7bLzSavWZJGvjGkHj7odjlbomM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784679775; c=relaxed/simple;
	bh=KbOSE/gKsdysHU7asWB9htOlC/vvoBxEr5PeadKLttQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BRWKaTLJJcxsHfxsDSuFGEJc5yz1H60u5ADixoBh0l3utdtD7cWdsL1tgGt/Immal2qF/qEhdhypfkYl9n9Xg5gWesIh5Gs/WsuwJJ06sRsqse4abSK521EBjyV6cEJVMAFdOjUpSpqpsmxd7mUgMG8R9w3m3BHHdejl8zzg1X8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wb+EmjDv; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wb+EmjDv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784679772; x=1816215772;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KbOSE/gKsdysHU7asWB9htOlC/vvoBxEr5PeadKLttQ=;
  b=Wb+EmjDvBzUW1MG9OrUu7gDZkuZqoe1gdunafeVCPz7+lYJV+qilRj1x
   AuC7PlIQJHP3gsDiAOSKlkq6c3XgL3p1nVtl04yziUU44w1/FaQloCOId
   Y5Ok3+kI+q1+4wejhswyW14n54edGNO923WbCuJfrbsVLjJ8sZfW+ka+6
   G34KVcKSrkW4EnAjrfeXDa+d2RkqxIJI+s0B28sGUYQ98woha//ukAUNl
   0LWPCi7jXkA1GqDqMPAdUKpdAkLohCpH7dcFrxKPls3eVEr+14TV7rJKv
   Hz7J0I5yxyA2JyMDtIzpoSqdJqEhsiU5PSCvkSGw+k4zR2JRq+vAlnuaO
   g==;
X-CSE-ConnectionGUID: 4BYzzbQBTDibREh5I7VEkg==
X-CSE-MsgGUID: mnY6k1d2Qk+nXfZqwkohAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="95667808"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="95667808"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 17:22:51 -0700
X-CSE-ConnectionGUID: OrjMr0C8SBSDpFXQeZ2NPw==
X-CSE-MsgGUID: h9vqC5bHR+mFRcarNJCOZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="255271590"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 17:22:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 17:22:50 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 21 Jul 2026 17:22:50 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.63) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 17:22:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LERFDUFnMDzofGJieC58Mv3euwGqz1O+r7r3D7Z4W5gFO8EhiN5Auf2luAkY6ydcJNTXNXwpxLbhCXVQzpMEpf3BBxVij7382AwKv6vkWq/674xWfx4GnTsfekQJXlFR4a4tAKEZfgD3CuPiHJiuhN1Rlp7I/dy/5SpP1iOX40+M9fk8GDTV430ZDy09kgzhdL7orWheH/4aCdG8xn9ic7Q6QYiOuq625Au3oO8LBGnRqw8ef+6nFY2tfI8uhufSqKgRh9s9mSNAOhvA41sG07MKZYOqLwIX8X4VeGpzhQw9gcUXKxOb9dfILsrcH6kE8s2kVbptNcSmhge0a2+R2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxQAyrqh3vjnJdDj77ZcBvvUvigvwp9dR3vGx7E9dMM=;
 b=rDjR5hdUC+4Gqwu4YHFlllMRgOcuvMcs8ICfkhLHkpd4VHXoI1oUvYHSwhEqoMbONwwUC+s8m+YheqdKD/siAX6Qus3WO12vHGWeUwIQGeP4UAif1KLZaTpVMIop0DFexA8Bxt2ZbjEImvSi/V4AxBzX8m2AFN5ezaTUCgMi94d3M8ebwicvMwW9kHS72O++ImVRiyWiUJrqw3JvOdqRlTWau43g7aWYbGcWroIhoF+OTBBMKwwY0uaimou/E6Xk/AyESyHe8WQvIONrgyd9WuU7I89a3l12cxCdiRY33qFzvoNunyZ1GjX1Rp2b/rQTAN5nLGm//hVusCuWEc7XLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB7998.namprd11.prod.outlook.com (2603:10b6:8:126::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 00:22:46 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0223.017; Wed, 22 Jul 2026
 00:22:46 +0000
Date: Tue, 21 Jul 2026 17:22:43 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Chen Pei <cp0613@linux.alibaba.com>
CC: <dave.jiang@intel.com>, <jic23@kernel.org>, <nvdimm@lists.linux.dev>,
	<guoren@kernel.org>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v3 0/2] daxctl, util/sysfs: fix builtin-driver
 false failure on enable
Message-ID: <amANU0ZiheWLng9l@aschofie-mobl2.lan>
References: <20260618090653.8983-1-cp0613@linux.alibaba.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260618090653.8983-1-cp0613@linux.alibaba.com>
X-ClientProxiedBy: SJ0PR13CA0166.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::21) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB7998:EE_
X-MS-Office365-Filtering-Correlation-Id: fabdd7f3-59fb-464c-0899-08dee7875ad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|11063799006|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: UtZuwR6Gqbq55wYaSg6j1bhdEV/1OdRZh/i/sJ6Bv0R7hrWzy/N2pp0V2g0g9xIeJ2Z4QaO+TeAS90CAi+p7w7AllEmN8J/0uuWyNf8tmjfvWJL1DSWfkqcAHVJrNV3FeWfDXbFUtEjuVhNZvCS14xo64c+0LNp5/ILiJfgPartaIxd3i8Xg7wy3bvL310ISHgx+SSDeWzrQQIGOfoQ+7Qu6qPxGIu/oUzw/0XKCIGMBWK3H2tgYZttvrMu5V4JCfcIEe12+uQihDFyfitjHkAbT9apSssCozey1HHjMt3yKjUVIoD7vhYb0gKhJchTfzoygvEKyHtnCXPFoC7q3hLMXmyKRJVRRnZHt1TkV8z9znSAtOOuLYRvhX1DxlLkaWpdYA9fLdjPU/u9FBeI1+M2QL/K+0WKo03/6+7Sc70VDv9Lvo0Pw4fmrgVdkgA1NX6w5j+zxmZbvfDr36O192HtRWJpfS1rluby+fKuCIpCXVB2yotFmZ17hJvrHr8ZjxlNYHEHJpRTf1/yhmVVPlfrqyxPjyCxQlDadXWr5PaHDpq/a301H+aUjbVW3NJZ7KT7KyrNeT2fb40KGUSuKPevcpgBOu51ADg4vryAYf4F/JN3ueWjhdhYOfiK7Zop/io6SX8noohXNcAbc3Xgc7OYX9QixwUr0A1HOikMBKb0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(11063799006)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jYjhKPpTibuMqYEFo0qNXFWeanFHOlgx6+ObssPoEm4BxolNtpqueecq7Cpn?=
 =?us-ascii?Q?6PscKCDPgK039yNEqHftU9QeFvLBtWR2tlKm4lVMUaSuu3n0ZikJuz88ulMa?=
 =?us-ascii?Q?30tSA2FgSUZgUKXnSJHrArAKqykKXr4rKIk25iuylVwxkPtiCnfcwv2berRk?=
 =?us-ascii?Q?hFx/G3NwZar3O0lMKxiKu5023SmKTyXUggb3doqaAIGf+5wq+gQYvZmv3VtS?=
 =?us-ascii?Q?G2iglzARmNmd3nY7830dELX5fDkNIz3QgCCmkyGZXxXebwypnUmWLdf44nq7?=
 =?us-ascii?Q?wfuFf1c9pAZPCy/FMo4sDzKP0bNCnyEaDmMnF4l3a75csP9aTejZvcwsa6dB?=
 =?us-ascii?Q?Akqt6QIIqFCeBLff4552EgobYFkx8y/AZW3HCPCGU/1m1FA8aty2PfDi2ZWC?=
 =?us-ascii?Q?zThTl+md+rUyjQAVm8X7FoK8vv8OebBLBBoFBzt0MLSl/oKgTFC85tXTiu1i?=
 =?us-ascii?Q?5wR0f9y1WX8A37qm0CWD51kKyk8zRbFwWBPLK8I1Tr2LWFApIMUGElqQqFNP?=
 =?us-ascii?Q?UwKfzZLsVL9FDUvxaKim2NcDoOe+jeAU/+j9G40LeO8qUvlD7NzBkl/GNjzo?=
 =?us-ascii?Q?isCASWw+BDlb1Wb4guCR+s9lb+Awh2lfnoptJOmsGFz14m+M6oDbFAXjkAkr?=
 =?us-ascii?Q?EpxUn1RS7Rv1rZm/sIuUUdItAy3uNKjTN7wg8uUFIoEdM8rvwVlWUTrUC7/5?=
 =?us-ascii?Q?ZJmu3pshBMpMAGd02D2mnmkoWymEvneWo+YxOJ4G3JYFQD1LOcNkJVSoqHgu?=
 =?us-ascii?Q?hAucjm23fw8t6d60gTb5pOZbmU7ox72aQInak3+uS6+Xd4TpsvB+QAbeJYlI?=
 =?us-ascii?Q?jL6ECoKM4k8ZoG2lcuNq/WD1qE5AEcNVC3GYQJYn7GNBn+fuiDBjSLk17Bvh?=
 =?us-ascii?Q?eyJsj+HeZs8pEMK+Cymu549AZFM6fG5hLvvCev6dfLyUio+QKHbVR24TU6oc?=
 =?us-ascii?Q?IT/Y2W8mYIUie0ZzH0nwp7MyC0O9AXPV3M6aONzIlzxR5UE/1yzmNZrL3Mri?=
 =?us-ascii?Q?yKAJdEKgFQXRne1Sf5m6tVk4eE9cmasmdB2Z26SXIX2p8JWSLEZOLo41PFbL?=
 =?us-ascii?Q?Tp+7ylfZc+ssJV4m3ILou7fTbNaUkbWcVkgovpDCdjVdMBs6bKf09HBJUpx1?=
 =?us-ascii?Q?pd60UhxqoDdmEUvowUVl5YqumXIuLrsItSfrYqwzuulxlKQaRRaKcvFHv30T?=
 =?us-ascii?Q?jMelita5lHvxccvqWlQEsIheTV+63Dwa48q5PJxRtob0w+wEaCE4NVSqi/w+?=
 =?us-ascii?Q?XsVwTuUxnotjzZvU7Sz1Qkv+l23yaKYFHcNjJ1s4mKcUNtwKS/yXeemqzhIF?=
 =?us-ascii?Q?RT6UA0h/zWXc8PxuNroWUOJzuvow3lC2LAt9DEGOrn25h7r8c9OzHxIqDoGq?=
 =?us-ascii?Q?u7sw9qM4D0oNTAANdwW1Afl7Kr96Y06RmzzzcAonfqIHID9lzJDA4se7D0Pn?=
 =?us-ascii?Q?Ah6h+sMP84H4z/MVVrtIbsao//5cFPntZtC9IVTUScn1E2iPOhVa+/7nVHhx?=
 =?us-ascii?Q?pqIl1UOvk2UGKpRo1UwyHwu2vcBfVYKDnJIxmYyxQA2CEuZCPay9KznvjwoQ?=
 =?us-ascii?Q?zQ6iNi7MIhIqb24uGIFQP0NUhjxyrCfDXgORQvm1z/70mWmvb7GjTFTF4t+A?=
 =?us-ascii?Q?IAoGuagEX6h1bY4l8bQ6nvoi7dRCVdKOu2x/IZV1fdQ4y7Z7XihM+xDfMQQI?=
 =?us-ascii?Q?ryxwKaXgE9Iot50/QfiUzt4ldKnbGgtaNhUBajaGcgAtjy8/BTvY/ReGclV0?=
 =?us-ascii?Q?B/MCdBgUxEpGDM8icYc58fi4FtG4hYk=3D?=
X-Exchange-RoutingPolicyChecked: gFtBdqDiOuiUt7WoliPEfEvAV/p3/u2dPFKwlL7BkgxYZl2rlq2AOtwFO9ewXBvPpNwlYtOxPwg++yc4ROj3dddjyKNNtTTXPyG2bmDdPXQTQWtSd1ii2ziM6lm5W/Xxh4BISLsMWEBNnv2SH62jB8qodqQU0O6yjcUW/7Tf/2Z4J0hwQXJqY7gQP5bDv7RbmAhRm4rRJiy9W8PKva4JkzU7bn/8nNmRzVuLoZfOjqzipQLQmD78FD9vhiBRqzOQHHuQzd6LWKQ3u6G/ivlUvZQ0QYeMk01Rif/dXdQwBfYmY2Y4BSm8HoChQMBUkedVrfeg7f8NTet1D6VRmVC7Kg==
X-MS-Exchange-CrossTenant-Network-Message-Id: fabdd7f3-59fb-464c-0899-08dee7875ad8
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 00:22:46.6058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BfOt/RreRQu/9dl2mpN1nRyJ3QVQzGLJqmT8O0pSmJ6cB9lQMZsjlG0APrgK7Js7e+Os4DOMFoPtWBn2YbIqZp5D88EVMhkCvFuO5vCyAHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7998
X-OriginatorOrg: intel.com

On Thu, Jun 18, 2026 at 05:06:51PM +0800, Chen Pei wrote:
> When a DAX / ndctl driver is builtin (not a loadable module),
> daxctl_insert_kmod_for_mode() and __util_bind() still call
> kmod_module_probe_insert_module() unconditionally. libkmod only
> short-circuits builtin modules when it can find the modules.builtin
> index; otherwise it falls through to init_module() and returns -ENOENT,
> surfacing as a spurious "insert failure".
> 
> Pre-check kmod_module_get_initstate() and skip probe-insert when the
> module is already BUILTIN or LIVE, matching the pattern used by ndctl's
> own test/core.c.
> 
> Changes since v2 [3]:
>   - Patch 2/2: Add a Reviewed-by tag.
> 
> Changes since v1 [1]:
>   - Patch 1/2: unchanged; collected Reviewed-by from Dave and Alison.
>   - Patch 2/2: factored the state check into a new helper
>     util_kmod_skip_probe_insert() in util/sysfs.{c,h} so both
>     daxctl_insert_kmod_for_mode() and __util_bind() share it. The
>     helper also returns the observed libkmod state via an out
>     parameter so the caller does not re-read /sys/module/<name>/
>     initstate to distinguish LIVE from BUILTIN.
>   - Patch 2/2: additionally treat KMOD_MODULE_COMING as builtin when
>     /sys/module/<name>/ exists but the initstate file does not. This
>     is the pattern libkmod's sysfs fallback emits for builtin drivers
>     when the modules.builtin index is missing (e.g. a kernel installed
>     without running modules_install). This was the case Jonathan hit
>     on a builtin DAX VM setup; rather than rely on a libkmod fix, ndctl
>     handles the corner case directly. Suggested by Alison [2].
> 
> [1]: https://lore.kernel.org/nvdimm/20260514063234.86439-1-cp0613@linux.alibaba.com/
> [2]: https://lore.kernel.org/nvdimm/agtf5uwBJOaCDR6l@aschofie-mobl2.lan/
> [3]: https://lore.kernel.org/nvdimm/20260526132251.254476-1-cp0613@linux.alibaba.com/
> 
> Chen Pei (2):
>   daxctl: fix kmod reference leak on probe-insert failure
>   daxctl, util/sysfs: skip module probe-insert when driver is builtin or
>     live

Thanks!

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/
