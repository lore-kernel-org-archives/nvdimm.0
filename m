Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520DC3F44DC
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 18:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779907473; cv=fail; b=s5wE1ZVLi1KOGK70L8AQv5qC0E8T7r41WhcVZ0desRJ0BzkSPFBY+49BM+1YEmIHnnm5PxuGq3bVDD2JWDQsLdwEzGy7/NNBDF4MnUzAVZ2222NQW+R8j3TbFnJeQ0uzAMIooP1TOf7YBTZaOlCY1kVC1POLwMVkdIz2JmMiH4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779907473; c=relaxed/simple;
	bh=r3lQrr8F77qy7Vbqigw3fu6XiTe0t2B0GawLfyA1vaQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nOF067t7iN7Yv59XbY8kyPDNYIhJQ0RTBB20YzeslPr1zTst1T5DUdgMsiyDaNTnHz3XA7bbSqkvtDLywqz4S9ve14riGCJ7YZzxZOQGqnkxsLFGoDCh0SYwq8wjN1L4E2bY8elyPran57dMKWo0NSldQZPz+dOQnFHot8QwhTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kGFe+VXh; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kGFe+VXh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779907472; x=1811443472;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=r3lQrr8F77qy7Vbqigw3fu6XiTe0t2B0GawLfyA1vaQ=;
  b=kGFe+VXh4UCbmZ+83HEPbdvI4lBNo13tJxMoFwFmQ85/gMKWIMo4OTY3
   tVGE12n/4j9w9hI+pgds62MImVhLJ6DqLKzDmLgDfQU0KiBoDx4tbiOfJ
   EUKoMq34UOr5SNPe6WytwqAdGCd1yCT9VUeIJCS8tZdBDu3polwzTU/mS
   qj0gRvskkOXPwjGW9Xmu5ejatRLedIUjJ8uvaWwM2LNlNEsgof7yiXLot
   so+bSAtj72yBgchvXKccOVgybND9PLGNVs9k79oenX/nREqbOt/wkZvK0
   UbbM+k6sSCW1R+RYiEgKKWJPN2YZW93hilaE6F1/naDnzq3Ctcu6Svo66
   Q==;
X-CSE-ConnectionGUID: Ny0Jrc/YSNWOolpmBe8RAg==
X-CSE-MsgGUID: rMyv2P3ARhqu+ceCpfFm2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="106202084"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="106202084"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 11:44:31 -0700
X-CSE-ConnectionGUID: dbw1ft2US2yD8IWuMeQjzQ==
X-CSE-MsgGUID: f/RP2bZ8SDuPLDMnNM0Bnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="246604289"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 11:44:32 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 27 May 2026 11:44:30 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 27 May 2026 11:44:30 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.32) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 27 May 2026 11:44:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sDoy45dI2z6IyKUYe60TgUACU9ZqxJwZgPbI0bDh/1bFFdQapvzFDGKZ8c+okpaWk6g8SrAHHdrWqsuQi0MD1XQK0avLGF5NEPCft6Cmxr9T1FlDD+eOG5eMAa2jAyQvhivdtqI22Pt99OyASGgMpatu+0KDQAPiILqNYXSHUPOgZg0J73djM+BDeneZG0NyKMq9JaNM2nMmusIeWs04k1Ts0n2/N4LlguiKRw8Yl77HzdupR38ULrfKFJLPA7YPsDcucz5qVNC96G/KJPgMJpAC7l/9G0WiGwJsmfElWyGwnQkq7wlKT2RUDdzg3/tYIdR5sj02QHksmKGjjRk9Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43zQD9mpEXRL8+s8jKmkjmymawNNnGx+h+v7g4lVZ1s=;
 b=ZyUjGSTdeT7w1+tYkoLwDg6HGmmCR4N7t0zenCRuiaIBuGHsTIHfmhHOY6Dn8nLyFa3N965LkM+VxekrobDq+0r/Zchc5pZTu6cnbgZEXB2lFLASf45V8+X8K4v4xTcvh/s9WaKNLOKbJS+dZCAvC3kwdYP/Xx9T+ioVCn+bn1QCR6UVf3Q5oLEBP66XTzAh9ovzcOoZfWUbevXvlZeGxARXjHFj4+Y0+he0vCZFMhlbYjYpIxeNwhcwJvAF4uEwc1ydYoQ5uD/ugvkukSPUAfL4/sw9lyv1gK/rfhUfV34OPcfjgIaa8db6A7aBFjAUNMX5cdiWKo6WYM2yWvfndw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH8PR11MB9829.namprd11.prod.outlook.com (2603:10b6:510:3c3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 27 May
 2026 18:44:28 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0071.010; Wed, 27 May 2026
 18:44:28 +0000
Date: Wed, 27 May 2026 11:44:23 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Tomasz Wolski <tomasz.wolski@fujitsu.com>
CC: <djbw@kernel.org>, <ardb@kernel.org>, <benjamin.cheatham@amd.com>,
	<dan.j.williams@intel.com>, <dave.jiang@intel.com>, <icheng@nvidia.com>,
	<jonathan.cameron@huawei.com>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<smita.koralahallichannabasappa@amd.com>
Subject: Re: [PATCH v2] dax/bus: Upgrade resource conflict message to
 dev_err() in alloc_dax_region()
Message-ID: <ahc7h8zMaTW2XUMU@aschofie-mobl2.lan>
References: <ec26d3de-d556-4ab9-a333-d69d1e6cdda7@app.fastmail.com>
 <20260527080328.12171-1-tomasz.wolski@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260527080328.12171-1-tomasz.wolski@fujitsu.com>
X-ClientProxiedBy: SJ0PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::23) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH8PR11MB9829:EE_
X-MS-Office365-Filtering-Correlation-Id: ac2bb3ae-8ba5-4be6-b9df-08debc1ffbaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info: 5IV9y0Oe8TGLc9rzF4P9A05eLA1SZYcbwQVhm439eYF6hlPVekPQNwuGhXJA/jD4d/788a2yyi3yEa/3xDTSafw9Tspzk3sprmKBUR0sCUSKASTbBGD3d27U3z7o6tK//GsN9emJgifnSRffWD5mh+RjZrPjNKaIV1psXLenw/ywf/lqQUKkeuyM3SvPLZXmRM0reejPA5iV5TPQW7bEO/qzpi9B0sWK523VZ8KVi97GNx4pg6bc2O+6aGdKnK/z9Zqk+zCW8kK9CZR3aoVak5goHjTr1UiJG40EL7zRQSSRTZIGYrQbJRrfOpUQp05rBRKv0V3Bj6CNyq2wgh5D/lhzMj+zJXmv5VJmMblzWih0kJtkCCO5/WJ67GdXKBgxZwIlq2va7Vb9pw2Z1SZMuGCJ+d18CC6uzBsR+wNJJeIGHKZKmwWRE16Edj/V0vAPv4oZgjpHlwMVDR5HxjmIs/9r0t31mUKYhaWg4sfBAVmSHSqKxx20jMKvu6b+GLml880GEyMSnYTk+ms4XOsnHofxtQlCvij8V+R6wQXX4+SCJsKcGB1oRToCIOKKx5H7ZeFzZe4oTI37d1kGu0GLPd/ggLNLIVH4HxOgTSxnVBsPJbCBLLWccoKZ9SXbflN4SMZrKxgSZS0mtPARLGyDcfejQKLeN5AVoIAr080JvlYObucZstpOOjrN4WfCL/9j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R5rNAMPqV57SEKliwDbH7zh+RMQSULlw+8iIGAx4/108jSpCgbp94g6FRJ/9?=
 =?us-ascii?Q?GoFU2+Gb7CMVA1PDy0aOgPRprbeyIGSJGeGl42CWfujulCpvBD+TEMDZ6OHK?=
 =?us-ascii?Q?2NstXjRwEohkCVJpYXXJLBYxYI68rxrOK2e0oYrQ3gDm+YX3dXCDic7ftAIY?=
 =?us-ascii?Q?/hXBC+x86PAZFQnd2J/rhvnZblEEZtCMPJ3yKY5EE1DpUmiDDqwYEJWvvUP3?=
 =?us-ascii?Q?8Ojq+zi7hV1/azILSdA2DUHeO02vGPI47UWCUwtJXrR6o1DVNq1YhVlJqLj9?=
 =?us-ascii?Q?IlYxQ0LZOaykUFu+2N+M17f0T5quPowwL0iBNPEOIuNlC+O+OdbwIoXjFj3a?=
 =?us-ascii?Q?kz3Uud6zSlBpr9PTRYg3qetjZspxmzdqBnHW+0x4g07ci/bJQuhphjHIzvCQ?=
 =?us-ascii?Q?ow3qbFjPbhIqh0qNrZah/k+8RrM/U/ng5+ZlYJQk0CLN/FAgnQbSgcA+4V/a?=
 =?us-ascii?Q?weTOpN+WnNRRW+TWLirlmrSnyJ/2kw5jb2BxcWJNs686+ubwuRXOlTsTlWaP?=
 =?us-ascii?Q?jnqwgl04px5HHea2LGEEpF2RmTlNTc+3y+RkxqRZVng/N1sYU48XLLJsqYx4?=
 =?us-ascii?Q?+hFvXYj+qLiUiWHkd0oK0oLNEKawkJO27zq6O/ViTJIthkwXrr3whuqIKwAN?=
 =?us-ascii?Q?HQ2WNrhRQojfXGS52iLM3WPpDnpILoa1KTBedUGMrxHOlVNl+bv2JeQf2Yn2?=
 =?us-ascii?Q?LPyhK4qEVyL+98nLq/7eV1QQGNgVoDPp+Em/iJblmCibFPbrp3CO1+myQnIV?=
 =?us-ascii?Q?hmjC+uJ4FnIQiAMd4vY/WjPov0RayLFzx7wTnK9SDoakC6JAKo46jhCGeEQd?=
 =?us-ascii?Q?17YqTGnHDe3PuKP6VIXNdbjB3UwLTZ2MdOA7FCAkkXFjpIz0Sm7HNEKu0bZd?=
 =?us-ascii?Q?VytO5oZnicczq1yS0wuogqw4hwdpZJy+YxLb9H1Yhc1fjmmo9bih6ZF+RACU?=
 =?us-ascii?Q?CEZJL7Oaq92Brz2c4P946v+xDu1jEMnSxuy9khZiqChYKWubP8B76vf0r09w?=
 =?us-ascii?Q?jVbiApZJG6KaP6piZrtabih4sTHAMHj3Kmlq9uvOmPb+G9OlZA0Ma1Guidtd?=
 =?us-ascii?Q?ReFl9g1sGqz7jo8EN5vMnuUwKieWQSN0QSxyVdH8B8qy2m3aX/BtZjb4+ZTg?=
 =?us-ascii?Q?ulq6Z9M+OcFxX/iZcv1jP5No401MqpUfna9p1DqMHBvGbVwHcLwQPEi8JV7Y?=
 =?us-ascii?Q?CXTG2PHPHkPeyRsDQJ2IRpjrX+cHUX49X5jA/+cxMZ4wKoJeXH7PItre9ttJ?=
 =?us-ascii?Q?SbFOQ8As33s84kGRsRczySVym+rhAH1rdWAiJRV1WEmJ+vrWQWBe4sj2oUfq?=
 =?us-ascii?Q?DfHh/XbfEJZMi72I+3+FoYIEZL+1czYqvXDuBYRNRZ48O+Ee2Jr14rEbmAtF?=
 =?us-ascii?Q?cqk6aWIczdEyzklpl0y+ksFMFCbLmOjCiNgHbvorimOfYVAP73qepho7KFNs?=
 =?us-ascii?Q?CjImBwWazRq81wPv7Xw3rlKbYV3/R4Z3vlT5xGfY+QcG7jQv4JFjPF4ZcNwj?=
 =?us-ascii?Q?KVdRX5KvsTp0p0iHTl8xPKIkiG6qd3lCrDLUe3aPnFCp/xG64Gx9Z9/OYa9C?=
 =?us-ascii?Q?/txuGSTDRY6mx/ueSXe4g4EAVbDYVAdnY3voqnUzAy0wny1ewewzG+g3Dg5A?=
 =?us-ascii?Q?w+gO39H0V3q/c884yxJXOCA5Xwk5sq0GF4aQQe6gbHpjNFZaOpxlYoPv0Nak?=
 =?us-ascii?Q?qarMZraoZ3jSjQ/I2Igs9kDj+rc0/VobdM66/d6qcbOEcpSjk/wvOyf2mjee?=
 =?us-ascii?Q?HQDkwQp8Mpe42BXWEuji4pBOcm9Kkww=3D?=
X-Exchange-RoutingPolicyChecked: FUvUWEKFfrYqkMylbTXUHYQp8e1CC4hNPZ3H/NY7irGiXH6rvRHbhZg9WIU8a/bwg2Zw2x/rBb8EO/NCX5uniafvRcfJGXgfL/1/Ihkh+aIj94y+hH/ElbeHUpMD5qp1cGEXe6xmLJWQCdHUucJ23gGs8kT1vdRjoYgjGIsySDVky+j7Tc4+/Lk30WI6P0lnzpqE3iz0DweU6s6ecH+nzi1tbqrJtpImc1GXJtRIhaUoM7JrbWWExD+wro7CbtNbV15W0KwlyN0qLEx3/AifrjJN0ERScvSdwYw+oyimXc8E5cg2MUgKaS/c83A7O/XM6yxL1yPZ6X13psqeBAZiAA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ac2bb3ae-8ba5-4be6-b9df-08debc1ffbaa
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 18:44:28.7624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Upwq+GMKI+A8lz6o7VXbk8Zdo0Jmgz62goU13MmaTu+IEhmiWM5h4mdXe+3Sj1OLQaFi+xo5LewadU5zapUkRxqWL8Jp2cofwiE0Fe32PXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB9829
X-OriginatorOrg: intel.com

On Wed, May 27, 2026 at 10:03:28AM +0200, Tomasz Wolski wrote:
> Hello Dan & Alison,
> 
> Thanks for your remarks
> 
> >> Just report the request_resource() failure. This case does not warrant exporting request_resource _conflict(). Historically one driver can not mess with another driver's resource beyond conflict detection.
> Do you think v1 of the patch is good enough or v3 is needed? (which in fact would be the same as v1)

Hi Tomasz,

As the person who caused the churn, I sympathize w you, but
as the person who will likely merge this, please send a v3 that
removes the Fixes tag, which was the other change in v2.

It'll keep the history cleaner.

Thanks!
Alison

> 
> Best regards,
> Tomasz
