Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F65F1CF28E
	for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 22:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412679; cv=fail; b=Fj639WgTTfM5VmNyqIlDdVfU1BQySNYNBdW18+LNRZMMATlQGRklEQ8FU8fDpr2nOBkg8EEqWiWPq6wMxWMGEFIMCP2r/W5ocGwQ0dXbRBlDvCpgqIX+55vNO1ILQBacQ1Ror/2179appNCwitI/dM70dtA4HD5Ukor9k49w2TQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412679; c=relaxed/simple;
	bh=n0/RG2i8Eb2+DKXMv5Nh6G7l89vvFDbfrbgpjfnPyk0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZxVMdk8IIK2pui8fO4Mf6aCaEMeNHoEoaQTFvmkhUZa78/8lDND3jHsyl16UNUwPpOo/D8OMX46oQPEDpkdumZImb8uI7ELx7LgoAwSmvy0Xur9p7eYoPTXNkITFDfV3CGDia3rPooa1hYKPQ4ceaJIjHuCsZe48yAVXhwAvbN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XQWqtRhp; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XQWqtRhp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730412673; x=1761948673;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=n0/RG2i8Eb2+DKXMv5Nh6G7l89vvFDbfrbgpjfnPyk0=;
  b=XQWqtRhptus/tkfYgjtFwTI+LNqsnnFr+m+GHuTRwlAXtwU1jo7F+4IV
   U4L0vq+Fd2Rd9wkrFKETWtAQNXhaBm/Q9REJVp2SbSWb2TExCwNLMC5iF
   5R1xMZUauelvO6TkMXjHmeJGC6ILtIeiKwDbKUmQzkUGJvvY33CORk1/7
   vUJ6B4sv6OKvdhWySycBg8PoPr2JYtzS3sSamfK8E/ejl/e9FxiKMlplS
   0aojj16eb5iB78QDdIXW2gWM7ac75zNvITKjDyErWJu/OWCT/QIqpvVtU
   +vLQq/yEpN10Qg1dPZo1ueA+RGjK7OWHqj42JKX5OvlJRUZsF0fjASAto
   Q==;
X-CSE-ConnectionGUID: yts1zXvKScCVeuBMpshEJw==
X-CSE-MsgGUID: BOlYJqu0QdaBH8AAaONMuQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="34111241"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="34111241"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 15:11:13 -0700
X-CSE-ConnectionGUID: v+I/ZYF2QySqPXjljMBXCA==
X-CSE-MsgGUID: YRDqvmzCTiC7lJ3aolsk9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="82875243"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2024 15:11:12 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 31 Oct 2024 15:11:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 31 Oct 2024 15:11:12 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 31 Oct 2024 15:11:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EQ/rhIADJOl6wwJZBnSfqtlgK4Te7TZAOm3Ya/ONiTTYK++7nOiYhwkEc9BjD4LHFftguyho9NQlgX3lyCaYEh5sei8vuIHO2buRBoPEj/NlRisvRyvGoX+MYYKs2YBksw9ZN+5u0yqAcWcBjIcd+KAHExOfo2GT425BhVqIQxbFHLD7w8mlDlGXedOCn80qYPSkdT+UHtkj4DjNMDfdHSMYzG67I0EKGNUdUPPF0M1PzcNj8UKcwTjjmH7PUzSU8NrtO5yDh0t+PYJy/5RJMtNJYp57hxdqLOLstk2w5aZLYfKz9NFuAdjbrjsNDiCZ257JY/OJx/nxRr5QRXuiyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbM3d9/pj6wbYDK97T7wIsFybx3nzrd2+ZxKrl3qHTQ=;
 b=mfNysBYX1y7RoqCpTeBwvD6desEVy4ZbIsyQixkCqFe06uu4lJOP8u4peYRfxCHJaF2WiDa35zRB0QteX9YEsgiLEhia+wGbqDqLBiwo8YFrr9WEYnCTSoxo2u3mRb+vHGFZoVojbb4xwmOfVntJFQPCeobH8O8zZ5eHnknQzkg0j+y51gsqm8ugEMD6iiWDmNCMhboSQdMpWKNGyPuvIgOxhwYpgDXm/7Gi0AK0ExyQzGPPlCz3scVg+JUDeBiFDXbU65R4fRtcYDxGn80V18Zr90TSTK+ogoklXhA/D/ld/Q/5N7P/m+7QG3oEzNOIaJS679rjsKl7DM0gcLoS3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DS7PR11MB7805.namprd11.prod.outlook.com (2603:10b6:8:ea::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Thu, 31 Oct
 2024 22:11:08 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 22:11:08 +0000
Date: Thu, 31 Oct 2024 17:11:04 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fan Ni <nifan.cxl@gmail.com>, <ira.weiny@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Sushant1 Kumar
	<sushant1.kumar@intel.com>
Subject: Re: [ndctl PATCH 4/6] cxl/region: Add creation of Dynamic capacity
 regions
Message-ID: <6724007843a17_8a67029496@iweiny-mobl.notmuch>
References: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
 <20241030-dcd-region2-v1-4-04600ba2b48e@intel.com>
 <ZyPPPycLXADj2Lvb@fan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZyPPPycLXADj2Lvb@fan>
X-ClientProxiedBy: MW3PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:303:2b::33) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DS7PR11MB7805:EE_
X-MS-Office365-Filtering-Correlation-Id: c559b0dc-927b-4f6d-d331-08dcf9f8ebec
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Sl2Im4fD4CfbRzOtTnNYjrIJ4Sszs4Sw54+U4i1I7FeFm+D9n27dU3/3KFec?=
 =?us-ascii?Q?IU4tPGhttAvKU3hoX5dOC9jenzMn8wH4/XzlL8SgNSc4a4kuIFujrXJKJMhK?=
 =?us-ascii?Q?y0L7RP+LrzBbyIjhwuw/hKt+Un9skcSMDdOyr7mnXh+TQLMPVss+M4mMMpYU?=
 =?us-ascii?Q?OGrk/SbB2LTFTPqar3PkzyqAf/fpefOuAXSustr6F+JGtDxAKuTdaW5vAayP?=
 =?us-ascii?Q?IcrpUxlHkl5Uok6rqkPiKZ8vc5qqVoyyqGYwiDq8RHxFofYUlpS094EO8/b2?=
 =?us-ascii?Q?jj/Qrs3hPZCEwdXISbnI72/a2dYKXJKw3Q2ZseNPAsFoT7A8JdeyLDoSCU5F?=
 =?us-ascii?Q?ILUQ3PIeeSNOAyKUjBsDxJMKujXZ8of1jLZgQy6CkuFjDTU2P1rcyy7qv4g5?=
 =?us-ascii?Q?+sCAcrkr/V1W/Yc2yeSZRAfrHa/R+XaV+Z5w9ShvJBolO1o2AxGoxTNn5DNd?=
 =?us-ascii?Q?I5dnTCaBXEMO9H75UBL1TS+jtIfrX7IG3Lng60bGxQ40oBX+sRQpPWbkXXmU?=
 =?us-ascii?Q?dViZaSYQ1RvvTsdO7/IGTfF4/UmRQ/mkmOfLtP2LVXtwZcQLzgQm4tjOCWTj?=
 =?us-ascii?Q?s0BOmXBNs08jVZMXwRbC8xwXag2Wwt6EpOvEFaRC86bEnZjdjfv1C7tcmJ74?=
 =?us-ascii?Q?StXp/J6Ig5UsZ2l9JexSz7D87L5tOGt7EFSImzh0tOE81Ksd+ZmH4ZjNLsY6?=
 =?us-ascii?Q?qRJXzj2D2UZnuKGjMsHkiogfJ3FIg56xY5IJtz0aHbDG9srf/1joWKmM61pn?=
 =?us-ascii?Q?xjXhPSzPApiVMQ5BQnUMrCaQKXabNPoLxmr9hhWEBA3Qj4+HduVQ6xqTBv6C?=
 =?us-ascii?Q?l6aSG4tEbb6/h2Wlr5DDT2H7EXjlynKBzbFfJD7e+PXctdvNv9pW/CistnZS?=
 =?us-ascii?Q?UW8HKhsKjzDmVfYJ2seTEfGGj/JRa9UEwfn+T85Ma4kRHvVW6t7YHfe8HTsB?=
 =?us-ascii?Q?IpDsAZNJw1vK2T/Js3wzKQsz36Lvswnm+t1qceOnj6U2YX4svKYdZzUKmQuO?=
 =?us-ascii?Q?ld5UezdM7ek7rLL11N1+ZdXMCrzIAEINuKZAjGV+9qxZ6DgVp8PSeGejk69T?=
 =?us-ascii?Q?mG+tnFHhiMQHlp93957tGGOQBT5jlkOLAmLsd9wODg+nl3IwaIYiLV4Vhnlj?=
 =?us-ascii?Q?EIPafprh5W5xUtos5nHhI3DhxjCLfzUayQKvdV+FD9W+rj3dnxy9XmQI9B0q?=
 =?us-ascii?Q?3riO29e3qApTjEo8tR2+riAB6wW4Mk/g1JMM2IWc7ffvQNAtZ/StSztAH8ot?=
 =?us-ascii?Q?ymmNbb+87+oOPu59O23KRCe4A11JLM6dUNkglTeC+OwS0mFDEv3n4aZDaR3s?=
 =?us-ascii?Q?qbU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XmOUQ16YJyIABeKTwbKnMpQWkwDZXbG0DdlCGX9yuI+nU2ErEZ9sKI15JhaE?=
 =?us-ascii?Q?8K3me1ey2KSQaOBooRht6noDz8+AwjUUYQyFIJRvBmmcSapBD43UXUfX1D4b?=
 =?us-ascii?Q?1RYeWoTyRBBFqqT8PZ5sRiG0Xkp1LUzjkMTDAghPJSaAT1zng3gej3gcbVQC?=
 =?us-ascii?Q?yf3PW3OcvZ0Hu8YfA7NoEEMk26KsMc9FR2M6BN16oZWpiyzQ90Y9//V2lRQF?=
 =?us-ascii?Q?qfjl/e8TUdFjlWIZMAoQoDmrZRbKaBhd6Z1x/QuAmcjeHSMNvmQQ1qPKfDuE?=
 =?us-ascii?Q?wk2QpBURV9woM79u+4fVE9m+7AaJerJomFmTbflu+bZYx/dcPN4ThAnbF4nC?=
 =?us-ascii?Q?+0DnYXFr/gRpn5AC95/QK31eLj4Jlpo26CTplYjeYT4vyLVmTJFgq81beYFV?=
 =?us-ascii?Q?cctfvj4zbgdnO3AMT0Z3a7uJn6/YRGMuEqnPYp/rLpOKuIF8iMcJAbag050z?=
 =?us-ascii?Q?zLo47nYPKlxe4l96gbyvS/oOoj0AxF+pvb1rJZ1uhQH4IHuS9iKK7O+OwTW5?=
 =?us-ascii?Q?sl9uEdfEEJ13bGFbRkzY28jGBPUQcWk5aBj6tO4hJT42Q0tc5J1lVtVEwG+b?=
 =?us-ascii?Q?835qei2Vr/On1cql/vzDCnvttlA8FH0F87eji38QMEbgJtNT+Gr3FssKGtpD?=
 =?us-ascii?Q?RYMPQFylDNXu/UcdHytlISJKj9D9lWHllvMkXlDEVsl9NBz4VL+388xkb8hs?=
 =?us-ascii?Q?A8Or/oxkrex8BKA/1xjV67WJyRQBOpqz/qLqGXnxkL3xYgd5+J2PfKss8yNL?=
 =?us-ascii?Q?b484c6YM16AuOPzn53/2OG0qJ4gv08ZWYkG1dl939v+d4PyAydA0IGUia7nq?=
 =?us-ascii?Q?peBHFOPXWHRZe+AAtBoFl2b4ZGFBJXRc7f4O5yKDA1jnypoKe2Sv6viLFYfU?=
 =?us-ascii?Q?stR5XKPbrmSBWFWb7HNgSrJvPyOYQSTAfhUEUL4/aDLdyQ/hPMy9qTUC1FH1?=
 =?us-ascii?Q?m56CMTzVAfxZQGGosmrU/QBG13mNMfOEDkg7+PqdThBT0OHRajP9GyLcVMCB?=
 =?us-ascii?Q?DxD1j1bNxhtSlMv1RNB6sxGEqd9rwzAI+Xuo0pBI++jNZ9NDxZMsIWPI12OX?=
 =?us-ascii?Q?oPEcspQFrRLpwmX0rEN2K4agUujfMcpwPpWgJdJ8nvZl3mxF6U0GFl7GS7jN?=
 =?us-ascii?Q?jEyhesWHsricZkdJdb9q+1iN3XPAK+o+j/1Dn/QgBmwE0AgEFk2hzIRbvfgl?=
 =?us-ascii?Q?CC2xkvburVdrlMP1nnu9XW9EDkEqKN4FlJPWDTP+r9N7HzQgcXpEbN7reC4+?=
 =?us-ascii?Q?rDXw609l6pt2ZZONZsZC+GF/v+FGzBJJ6mindghR6ubQKG+9uwkmCfaqNmrb?=
 =?us-ascii?Q?DPoJijjtaAzHuztMR1fGvvPU1LiBhf/H5Poo+9YAQlTswn/HL6qOzehFlPWq?=
 =?us-ascii?Q?yujKlol/+q5IzrF6dn7I6TMmD3tQNOtgEvifPeGgNL+wD69xn8Sf4YJurkQt?=
 =?us-ascii?Q?wKEdoHt1BBdJTf+IuZXDuBZd/LANIAWyUVyB3c8x44QFztcJ4QIGZ5W0XrsS?=
 =?us-ascii?Q?tt0d3fghC/yojXrvEJ0vfjBASctHmHTh8lWYZzqvngvQ+vmGgazUxVAYwM2m?=
 =?us-ascii?Q?vHEvm7yG73MKULvBhFOngyTooJj9tMIWksTiMMd6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c559b0dc-927b-4f6d-d331-08dcf9f8ebec
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 22:11:08.6968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQp7RI14FdPq0j5UJTXJWFlL+rzZqSIr1j3yN4wt5SLnkifKmJmJ/b7on2ZN4ry1VKvizF3kWHCp6UYwb33asA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7805
X-OriginatorOrg: intel.com

Fan Ni wrote:
> On Wed, Oct 30, 2024 at 04:54:47PM -0500, ira.weiny@intel.com wrote:
> > From: Navneet Singh <navneet.singh@intel.com>
> > 
> > CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
> > with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
> > spare and defined as dynamic capacity (dc).
> > 
> > Add support for DCD devices.  Query for DCD capabilities.  Add the
> > ability to add DC partitions to a CXL DC region.
> > 
> > Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> > Co-authored-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> > Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> > Co-authored-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > ---
> > Changes:
> > [iweiny: adjust to new sysfs interface.]
> > [iweiny: Rebase to latest pending]
> > [iweiny: Adjust DCD region code to new upstream sysfs entries]
> > [iweiny: Ensure backwards compatibility for non-DC kernels]
> > [iweiny: fixup help message to show DC type]
> > [iweiny: don't double declare decoder mode is dc]
> > [iweiny: simplify __reserve_dpa() with decoder mode to index]
> > [iweiny: Adjust to the new region mode]
> > ---
> >  cxl/json.c         | 26 +++++++++++++++
> >  cxl/lib/libcxl.c   | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  cxl/lib/libcxl.sym |  3 ++
> >  cxl/lib/private.h  |  6 +++-
> >  cxl/libcxl.h       | 55 +++++++++++++++++++++++++++++--
> >  cxl/memdev.c       |  7 +++-
> >  cxl/region.c       | 49 ++++++++++++++++++++++++++--
> >  7 files changed, 234 insertions(+), 7 deletions(-)
> > 
> > diff --git a/cxl/json.c b/cxl/json.c
> > index dcd3cc28393faf7e8adf299a857531ecdeaac50a..4276b9678d7e03eaf2aec581a08450f2a0b857f2 100644
> > --- a/cxl/json.c
> > +++ b/cxl/json.c
> > @@ -754,10 +754,12 @@ err_free:
> >  	return jpoison;
> >  }
> >  
> > +#define DC_SIZE_NAME_LEN 64
> >  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
> >  		unsigned long flags)
> >  {
> >  	const char *devname = cxl_memdev_get_devname(memdev);
> > +	char size_name[DC_SIZE_NAME_LEN];
> >  	struct json_object *jdev, *jobj;
> >  	unsigned long long serial, size;
> >  	const char *fw_version;
> > @@ -800,6 +802,17 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
> >  		}
> >  	}
> >  
> > +	for (int index; index < MAX_NUM_DC_REGIONS; index++) {
> 
> index is not initialized.
> Should be index = 0;

Thanks for the review!

Good catch.  I'll fix up.

> 
> Also, the "cxl list" looks like below, the size of each DC region is
> attached to each DCD device, that seems not quite aligned with what
> "_size" means for pmem/ram. Should we have a separate option for "cxl
> list" to show DC region info??

I'm not sure I follow.  The pmem/ram sizes show the size of the partitions on
the memdev.  This is the same for each DC partition.

Are you looking for the available size after some extents are available?

In that case I think you are looking for the dax information details which
comes after creating a region and using the -X option.

17:02:42 > ./build/cxl/cxl list -r 8 -X
[
  {
    "region":"region8",
    "resource":1031597457408,
    "size":536870912,
    "type":"dc",
    "interleave_ways":1,
    "interleave_granularity":256,
    "decode_state":"commit",
    "daxregion":{
      "id":8,
      "size":536870912,
      "available_size":134217728,
      "align":2097152
    }
  }
]


This shows an available size which can further be dissected with the new
--extents (-N) option added in patch 5/6.

17:04:32 > ./build/cxl/cxl list -r 8 -X -N
[
  {
    "region":"region8",
    "resource":1031597457408,
    "size":536870912,
    "type":"dc",
    "interleave_ways":1,
    "interleave_granularity":256,
    "decode_state":"commit",
    "daxregion":{
      "id":8,
      "size":536870912,
      "available_size":134217728,
      "align":2097152
    },
    "extents":[
      {
        "offset":268435456,
        "length":67108864,
        "tag":"00000000-0000-0000-0000-000000000000"
      },
      {
        "offset":134217728,
        "length":67108864,
        "tag":"00000000-0000-0000-0000-000000000000"
      }
    ]
  }
]


Does this give you the information you are looking for?  Or am I missing
something in your question?

Ira

> 
> Fan
> 
> ----------
>   {
>         "memdev":"mem1",
>         "dc0_size":"2.00 GiB (2.15 GB)",
>         "dc1_size":"2.00 GiB (2.15 GB)",
>         "serial":"0xf02",
>         "host":"0000:11:00.0",
>         "firmware_version":"BWFW VERSION 00"
>       },
>       {
>         "memdev":"mem3",
>         "dc0_size":"2.00 GiB (2.15 GB)",
>         "dc1_size":"2.00 GiB (2.15 GB)",
>         "serial":"0xf03",
>         "host":"0000:12:00.0",
>         "firmware_version":"BWFW VERSION 00"
>       },
> ----------
> 

[snip]
