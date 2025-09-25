Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6B42DE710
	for <nvdimm@lists.linux.dev>; Thu, 25 Sep 2025 16:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758818356; cv=fail; b=TWWgUyrxf76PtFbvzAkNURv65TeUu4XsIKINcYkR1Yu/xxurNq3OXc5AhsLFeNCEQLRqWGOzQQlAlGC2fG4f4lrrZBZ2XPxmSTZNes+zagEldCQIXVVnfEsf0+b7Wz6EhJMNtZB5LBQhxF2+YyxJGEw0i6Z2j1JoBHWj1DKWqSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758818356; c=relaxed/simple;
	bh=QQzjt1Osd6GGEbzCpgSw/Ta+VFUdwgI6NC7HDqNUT5c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Y9hPQ4MZmsYuMID+Hhve5dPgrVL4LC3gnQXBVoC1EEpYe5v1LDJD/m+GfZq/NrPb7ugMwrCVm+QE5Kci9QbC3dyfm0s9NEs9atxmPaosdn5GtyFldL7pKrzeL8yjIBySMbWgeP4MYTsrmAzeu79vP4ns+zDlSrbGyOLldS4Dga8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IK8x2uCH; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IK8x2uCH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758818353; x=1790354353;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QQzjt1Osd6GGEbzCpgSw/Ta+VFUdwgI6NC7HDqNUT5c=;
  b=IK8x2uCHQB7RHGhxunnsN7G6gfRx0gZrlEMjC56lK+CufSAbftraki5s
   fQ7TkVeqrNjERLF8nqlWxju3Yyqp07sLYs9XWHTyeJtbqtf5C83zK/+/2
   rCWMbN0V8Emhk/qHrzox26n/SIoT8BcGO+0NLAeM2m9kvJdyNe/0949wU
   PX3D4GuhMZG8PNzPWGDVlw7mr/uETe5PAisMeViBVFUeUsgBcWgKmRV+p
   92DoDTyS2dnr+g0jc8tBydvihAUoT26Zo3ceh3iPTyxKSxrdaMLIGWA+G
   FHxq8RwrKiQ5/Yf59nT/UbmRmtj2+y7++zPrJF2t3PYbLXlJ8IQPtQh2g
   A==;
X-CSE-ConnectionGUID: bWKGH355RumBbIwFWk4mwA==
X-CSE-MsgGUID: 3LfQA1kaSMCh4tDJnCIjEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="71765985"
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="71765985"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 09:39:12 -0700
X-CSE-ConnectionGUID: bODWakE/Si6gUAv9Sc1ivA==
X-CSE-MsgGUID: jJ1zpBPBSEStdCybR+D3Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="177828540"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 09:39:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 09:39:11 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 09:39:11 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.67) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 09:39:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tzv6vXZAo+q4y+fSxsHXYdDjF6CZpd8/TBOpHpM360flq4omLlyBmmbtzPj+frU4cOao9/VCJIUX6Jan5sD1Pj0AijZd/qJ0+Gne/oFEkxMJEBBwTk0FTVeh7Q8CnGFpatyzU5CF9sz0zG2FDgKsMgLory31vTA5+AOzEd/9CK28fDKU1AAo8KGTGz3gK0zMti9xiHA8hcqvMA48ESH7mhsYoVDdJGT3GelJX/HV8nTaeg3K6njbTn06cU70nDUEh8CN5kKx8Wjds2RXtsjVpVeJJbg+ej02vA7KH/A9Lboy4ckoFKNCfzq/9p7TKl6j+z9CjgwxQm+mGXd9wr0gcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pnGBt+q/GYy9jmFsiG9/3qLL2gQAUR6kzTiZdqZJqUQ=;
 b=YdZNBjMsIaadCiu9kqpH0GHmDaOcJwJXovDTKQ5SD1P6+dOQ9CQiFoyNmxd8+1eStIVgz7WRbxF7EJ6Hoe8BA1+S2DpkKSwY45XAni1toj7pjcLGh4zmY86fpz+HtQVYHkV1VvMIsjUH8J2P83jHceqpdtC6HxcU1lfZxcjaH+jxgbBBk53PzaVlGotUmSe0K6oJxQHQH7CO77hv62MQ1t7U/Qm3JFNX6aZRK6hcWHyqVG/YjG8NQ8rgvxETZAPBcEWQ2sZITi8t4rV2zN36BniMempWD92s/kYnL5NzBfX+fH2EDq3lubHC/GwnrL/gjvNzY6+/zaqIZqbegrydEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by CY8PR11MB7009.namprd11.prod.outlook.com
 (2603:10b6:930:57::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 16:39:09 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 16:39:09 +0000
Date: Thu, 25 Sep 2025 09:39:06 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Guangshuo Li <lgs201920130244@gmail.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Santosh Sivaraj <santosh@fossix.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH v3] nvdimm: ndtest: Return -ENOMEM if devm_kcalloc()
 fails in ndtest_probe()
Message-ID: <aNVwKq6qkuQCrGNQ@aschofie-mobl2.lan>
References: <20250925064448.1908583-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250925064448.1908583-1-lgs201920130244@gmail.com>
X-ClientProxiedBy: SJ0PR05CA0183.namprd05.prod.outlook.com
 (2603:10b6:a03:330::8) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|CY8PR11MB7009:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e6bbd6e-4db2-4a0c-5f81-08ddfc520ce8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Wcrg8a8lkTgABy672Sy1ysO5qNGMPY0jM756g/5LIT+C1pNo4DbbiwrqQkS2?=
 =?us-ascii?Q?UeHfU7NTO5EREe9IaMlSk+Vb7ogWXoVk1TWpCbOP5oeSSozOE7uspsxKcgNe?=
 =?us-ascii?Q?/z2T2Ynzm6DPZNcJfoTWTFL1gaVf/+IITbRWWGe7rCjyJqtSnkoHpjCzjKdn?=
 =?us-ascii?Q?uE51w0e/b5aY7uMLv/tSD9lSjzHJIsvVPRHvjWuBL6QwEKUrv2RtjKS0S/28?=
 =?us-ascii?Q?W/iMlxvtgrVkgaVr/xt9XYlOIuZQbnwPV6Qg+qtGjBy+UqqEUztvQ3zIA5lB?=
 =?us-ascii?Q?ow3+iwVjHMUYEkWwID8+mHu13vs/gx1xjGSd3QEyO2lZRqBXL40CuU2jCGVS?=
 =?us-ascii?Q?bbE/2YtJelfOEU3nKcwwd9ZGOc8WDqoLHmFsFCjnYsjAj857FlGTmP1SbduN?=
 =?us-ascii?Q?QEMsqdDuQfs62Z36AhuZ4vUn01RnrwmHib/orIWnEj2V0dE2JsAThJx1PkqA?=
 =?us-ascii?Q?vYAb7m7TodGs+0SD+KT6oxfgfR4SN7JrRp0Cwv/pvnF/yE6SsUL1BH2TFuhG?=
 =?us-ascii?Q?w97IO/9kANjGV+lbuDB7LO5ug1CQU64ZJsEYl676PxhCQLuwiv1DDIoqoqym?=
 =?us-ascii?Q?HRuk4PzG+VzboEceMRuglXX84V8UXHhkjmNzfy9TMfjozVUxBjEZd/YpAVSu?=
 =?us-ascii?Q?wKeWWDcr9syVu/GEu7rfAaa1vwnJKDtKddFp9TlaBN8BkTJSFZWK6hYVY6zW?=
 =?us-ascii?Q?pzU2yhwWTljKhVelakZ4K0B+FotyW8QLnQTDJ87/3QG6E3sIPw/NXOuCokuG?=
 =?us-ascii?Q?pF3gQifDDVe1QiwhvTFRfNL5BoCJiwL401/bDCAKbodpsgVd4uDzSmGVRYLy?=
 =?us-ascii?Q?9VHGrlqi1/j7FwfzvBbN7IJ7iolu57psnpvfnmSzJCtVNUnjQMVfMJn9b+IG?=
 =?us-ascii?Q?HVj89rK9UmpqXDP3lNQyB0+kr7JPNftA4fbX7IoHKp7LDItb7MiyCDUdn55T?=
 =?us-ascii?Q?AFgvS0unEpymSqvI+uQtIvrHnuO+JJ1rHf+LBzA0KvKp8degqYbkx8Gf56ej?=
 =?us-ascii?Q?y/VufZiUOGjZ1/kAbIYD71LJ8y4gEV5afSEBDx9cEsl/L5407msj6rBFJggN?=
 =?us-ascii?Q?jSngYwf0YTunH85yTt5D2ly+FJThXXydPIX1o0yrg1EQk/GS9K0P29rJIy8r?=
 =?us-ascii?Q?A8ROoqhG8l8F0OKKYxlLEcGEC3BeoGd5QgMPUA6djeIfPFVMQk+IeVfWnr43?=
 =?us-ascii?Q?Clt7VpvxCOrksE2Qqvq9bQZIed/0R9Z0pDyPiyyK1OjqPoNRSTGsQ6b9jVCQ?=
 =?us-ascii?Q?Q2lFYDxRpse5C1WmzAwlCyTUIytClSV/h76u4R0QkF239CEySS2Vfr/pxgyh?=
 =?us-ascii?Q?4MowAoLpPxbLK5tHidOgFeNAHq1OXCnVnS9CxhD5RI/Zs2Zbj4uxMLOBAiKJ?=
 =?us-ascii?Q?KoTBsu4C0AbXKEYwNdkuddQjQE53m80BEO0jDrnJFnrBWkhHBgcV6qUoBxlh?=
 =?us-ascii?Q?2HHiuA6WNgk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wLZDlRBLKZfMiMOKpwXumBCtakkiO8sfJL9moxcGILEKptcaoH2JrxEtq/Be?=
 =?us-ascii?Q?czFL4NkbjHlfyyEexs2+TphqnX6dIvK1Cw3TImzbIyoIZhU6cFzvvwINVxTy?=
 =?us-ascii?Q?4Mu+0Rw5R0XdDwuKPZHVYG1N/gJgVQ7GhuhsEfY3pbzSfqWYPaPhelJUWJFU?=
 =?us-ascii?Q?/IoqNE6RsCdh9Nh5kb3Ee3++c7NUVTcLh4nf5BfPQxE0jrlv3/z6UWCAkZU4?=
 =?us-ascii?Q?tlsKI7MSDik1UPfsEvWPS3QMzDKKQF9cRDTgEGNE6s5NLMtMdB2sWkwSX+gt?=
 =?us-ascii?Q?+UfgrAXS3VKXlRvYgbaxgLqYwbbMsToBw7c402kZ4HgxTmRTgexPead+97FD?=
 =?us-ascii?Q?/BvakT5YBgbqOAQA7+aYGG391ZHlmvIrGCq92ISPmdnm3SQkqG2Dld9XieT/?=
 =?us-ascii?Q?YtGO4UeBpn7ACA/Y3zXUKCvuMGHsymVfNSFCV8asR7dQgaRVXiw1RhgN6ZSq?=
 =?us-ascii?Q?lEIL2rcpvu9wo/TBu9X6b/Mc4Wh9hduA9lKrzlumpE3Pdl4XoXgBQNpY+20z?=
 =?us-ascii?Q?ozE1fnaetBx1k+a79B4g7tcymVvdm3TY8H4a84v55QlQA1iEo2G4NCwa1h/Q?=
 =?us-ascii?Q?ZBGB8ba7xwTNkeMrsnUpyIjO5a4ffEtpvXK2axST87u4BRArLh4yWby7VugA?=
 =?us-ascii?Q?P7eHSc8HNzs/CB9y7tHP/Aa6QVgkgpM8BOUlcMc/p49rcNDQfUy+mwookjKE?=
 =?us-ascii?Q?LUukXGxReD7ePdyTu9N0NuJWkFEzy3wuL4/nUR9dnsM5zyFLjvmjDMn3FAYp?=
 =?us-ascii?Q?cbmgfdziQJovJjDveODuMDVJldXd7+p5fQM67605AMBrMFtFRqHZQketIC/H?=
 =?us-ascii?Q?I9JnGMw4yqzA0dzTQAgAV0yBSCXaGyBMAEh+79Wqz3vXJ8/X86DVkUW1OvPT?=
 =?us-ascii?Q?iqvKvVHNJEYlWhVD8T67eMD95stcvxSvlvBQ3EHb6PQ7jxNCpU9+/Or4E5L9?=
 =?us-ascii?Q?lMheRYYwrqqggZOJv2XoBwFYafwvwSrBd8pYAm+8su11daeCz6Oq6Qbp5KV+?=
 =?us-ascii?Q?LNrP9gENIZ4RDbV780+4K6P3+HPoUTyjpSy3eZZ5B/p72TqdLKpNwcO+R8lj?=
 =?us-ascii?Q?jZ4qEDJXNY6S0Ik4AXKGqI4pDyAyJIlFqtbi4ghbR+2upf8UFzFr8rVCAJfn?=
 =?us-ascii?Q?nofm7w0iWspvbZrw6lcKxEv0kBtI8oVzvSNs8NdBWdW3IjNSy4CszKvoVCeb?=
 =?us-ascii?Q?mTKb5hDwUSxFLlr43UwFSXqkHYu/x8uFKeoMAVKGAS4sDPtOpKSpaTdmxBCE?=
 =?us-ascii?Q?JvmiyAA959EpSS+Dv0OHQENH0PpFYRJ/2Ex1v7F6sKmdG/RIyW2ykh6M4zEa?=
 =?us-ascii?Q?dOaKOeUVoXsmVG5v8KGb2O6ZQS62fZI6u7yGVKPe4IToRfuYjYLSyAvdjaSJ?=
 =?us-ascii?Q?BhxEVMjOC8uv65zN0Q4Y9yuIKwnxIgtUHopDdJv2VSEHYNb2zNO4IB3gQj/7?=
 =?us-ascii?Q?IsrSqcwNdkUJTRmjbqy/cXrcK72VEH/Mau/WgALL7rK9AhGyVKLdVyPnmFAD?=
 =?us-ascii?Q?JT/+E7g77LOkrWZ5kqwG8imuUEbjMRL7FNInDyVlGs6jsr/xRFhU7ORr3M8P?=
 =?us-ascii?Q?ayZeaCfVL8vpZkU24LdRPHDif/DwKGz83m8LeuDl9FrzgL7ngu2YjEZwHmtD?=
 =?us-ascii?Q?Fg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e6bbd6e-4db2-4a0c-5f81-08ddfc520ce8
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 16:39:09.2115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zxRHUL02GbX06zouGlGVQqYZvWY7s6rb+DZa/HZ4q3I1NnD8OpOtvzH16emuxDSEt0Xmx7m/UpY+yvQgIbPYuiG1f7aoL66BQ7dJq1lsPmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7009
X-OriginatorOrg: intel.com

On Thu, Sep 25, 2025 at 02:44:48PM +0800, Guangshuo Li wrote:
> devm_kcalloc() may fail. ndtest_probe() allocates three DMA address
> arrays (dcr_dma, label_dma, dimm_dma) and later unconditionally uses
> them in ndtest_nvdimm_init(), which can lead to a NULL pointer
> dereference under low-memory conditions.
> 
> Check all three allocations and return -ENOMEM if any allocation fails,
> jumping to the common error path. Do not emit an extra error message
> since the allocator already warns on allocation failure.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> 
> Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
> changelog:
> v3:
> - Add NULL checks for all three devm_kcalloc() calls and goto the common
>   error label on failure.
> 
> v2:
> - Drop pr_err() on allocation failure; only NULL-check and return -ENOMEM.
> - No other changes.
> ---
>  tools/testing/nvdimm/test/ndtest.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index 68a064ce598c..8e3b6be53839 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -850,11 +850,22 @@ static int ndtest_probe(struct platform_device *pdev)
>  
>  	p->dcr_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
>  				 sizeof(dma_addr_t), GFP_KERNEL);
> +	if (!p->dcr_dma) {
> +		rc = -ENOMEM;
> +		goto err;
> +	}
>  	p->label_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
>  				   sizeof(dma_addr_t), GFP_KERNEL);
> +	if (!p->label_dma) {
> +		rc = -ENOMEM;
> +		goto err;
> +	}
>  	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
>  				  sizeof(dma_addr_t), GFP_KERNEL);
> -
> +	if (!p->dimm_dma) {
> +		rc = -ENOMEM;
> +		goto err;
> +	}
>  	rc = ndtest_nvdimm_init(p);
>  	if (rc)
>  		goto err;
> -- 
> 2.43.0
> 
> 
