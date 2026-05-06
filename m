Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27072E8897
	for <nvdimm@lists.linux.dev>; Wed,  6 May 2026 04:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778040855; cv=fail; b=SFBPvEjpRfkIwXAt5CjAb9zX6JDP2nt18UyF6bd4UpiBiqd+D/jYUVyDyzrkEbNmZaE2PDb72Ai+9GsecZOAkMWrRqoW8ntZgtFNaMSlK1nOUEMyvS5783kDCY+w3Jbri0a4PDYx8ehD1/Vi4gGmhoF5b5UrMP1NJC9zRmawtCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778040855; c=relaxed/simple;
	bh=DUQXgZoNeuwQ0qMDY9jHWKWBwI5KR8nY2umiWTV8Pko=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tjlpMJUKFewZL1GaEW7CZEqHfwJ7WeqsAYiA075AA+0/v2t+pllA3RZhfSqmdltEPv4NvH91nsBcrj4SBjaK+ORjGGDl2yhV251tVH4VNMUeHJN9+ZSDwxSQx7ZpGCNICx7chbdR8aXzycKSmzWxGKzXOL729/TMYFT5/rEAsjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GnhaYl9y; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GnhaYl9y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778040854; x=1809576854;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DUQXgZoNeuwQ0qMDY9jHWKWBwI5KR8nY2umiWTV8Pko=;
  b=GnhaYl9ybysqNtk6Ywi6xho0FsLr1tqSUCt3ndJwb/r9AOIr0G2UF/ob
   rqROcPgU4+tv5VhTo/p6lwutmRjeLATY2026LXKZLBm9DnfZEOvju++T/
   MFtzYXZ/7POW8dNHFucF27UqxE2MJnFr4lqtcZkS7Zw4ykVvhp3n/68l7
   9nmkfs0VjovLLNpJkw0452x/r395fLJOZaBA4/9K8WI7HJoBZ36uNnf2q
   sWu4eIoOT819S2SvfKdGnIFlggCaT7feba1p6VSeVTLkQPyZXZ5Ko2P3G
   ZzQHQvhV6fPTsXMK4Kd7uzzphgITieHTagGkI5PZUVUErcKmCTQVjql7l
   w==;
X-CSE-ConnectionGUID: S6XU6sABRDaCYD4EX+VZEg==
X-CSE-MsgGUID: MdKhTZD9SOmKTBRQ78IFsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="96492441"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="96492441"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 21:14:13 -0700
X-CSE-ConnectionGUID: 2cZh+Y5BREWdCn2ofyf9bA==
X-CSE-MsgGUID: Nw96viiPTdelgkNixPfiMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="236254675"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 21:14:14 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 21:14:12 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 5 May 2026 21:14:12 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.46) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 21:14:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kJ3RGoogsm2cbN3FHg58qfjz3nJNKkn9iXh8LHsyZedJH6dtUSTlx7SSB2PRHbj0vVxFdPj5+I9WwfeLQFJDn5kPfKicG721TVUBeqx8XZPCtxIb/hksVi//u+OaEhgC1uThKQH8qN1ubFtJO/CO90+AzCZiHCWklroZscG0nyVa/mZ0hPcMmLT34K/gvn3bpHHF5VvzdGf/7cbag9Fj0BDW6oa/mTMv3RvUYqb8z+cvSeH4S9LWnoiNT0/pBttwHjEgiJkzYWoO/v/CZE1EwyiBK/h6SzhpFkImCFrv2Mn9agcWlTSTKzLIqpch9EsuOv95LlzwBAgZvbj2+OhAhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZKcQhEV1ONfMw+aTOXEweSAph4CqReuyNgCpiLTNFQ=;
 b=EMPftnAM7c9wAzif73b/PVw2jxjknMmrswyKa9+6RqyvVA7Yw6hYzgkNU8BRKPG3qthjiF+1j4cFSL8zoIgwRU979PadS6Gr7p2V/CJG2Iy9nsZmGFZukve5Mx8Kzu1GtfQjDZDuq17b0f1vmo4jeOScqpn+QVATIqZjuuZFMVH1jbcFGNAZMTuhpyZpx5cAoeEoT09ruFSTwFc2Uz5WWMpoTUtkEp6JXARb5b0cvj6bPRhFsyEFFZgqmCQsnTXx9i2bsqKrZPnOHa235PJvigJIo2RQ0rwF2wnFe8jOkIVPCS9M47I0uHSJGGnhz5xqQhpjT57JUrDgPWKC/1NFLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by LV8PR11MB8509.namprd11.prod.outlook.com (2603:10b6:408:1e6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 04:14:10 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9870.023; Wed, 6 May 2026
 04:14:10 +0000
Date: Tue, 5 May 2026 21:14:01 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH] cxl: Add CXL type2 accelerator unit test
Message-ID: <afrACW-GUhsIs0cQ@aschofie-mobl2.lan>
References: <20260422230833.2622279-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260422230833.2622279-1-dave.jiang@intel.com>
X-ClientProxiedBy: BY5PR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::34) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|LV8PR11MB8509:EE_
X-MS-Office365-Filtering-Correlation-Id: 67fc965b-4b68-4b8a-8fb2-08deab25ec2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: eOQH+tVMuNjVcfObaTNQzesxrKt5DmU+oBuhHJNC4VOlktV8PRn9+0dirw0lNKv0poCm2CojdJXRjfobtEXLrDzRWOBpznWqkagDoJaA5+zt1tHAjvT4meyos5RbLdqV4tlLNavgOOzL22IKyV5TLKnqP36Wp/ne73mDtoQ5uWEMHHs8ODjyXaxR0BS0Cvq+q0enXy+FHk2O/MSm3ttu/GmdEPwmcrmFrGxf7WSSOCoqtlLPdmQY5OyHVzCO2nwrzlsaA+M5GwUUEjZ6FuxCgNenrp4R5nQaE/EcIGZHI3Ia8oUQ+YLY8lXc4icat16TpLiH1XGd3vNzI5FtsPL2DzrpjsnN6ruQL/QIcTr1KKSTr/V2avvFpY1XYPl1H3rGbN4/99H2Z5lB6cb5eEX8MMMOWCJQ8OGktLpmITdP7+gBh2k5jyoeyMPnAAwhm0DPzO8AqPkepT+5V9T6rnworgmHabDKaKrDqexBD2PDn1biaQnmBeH+XdPWWPORDf3bE0pmfVIVrbmEDb0cIo4Is9OmsqAbR/lyheBWqrff3d8AbLV8BUIK1GqrB4W7MTAycZZGwFI2I07OsriW+5rqnRIuNutBLqrstloLIoaF8cvkA2vLDdgJWWp5RoHdC4tefneCY7wvP2xfJNaYfAyar+tQKWyxPNj9tDgPTmbjCiQUAzSR1xjqGta6fst9g4AO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SBR431dDvQsfSIDsTANhqcJnKEahmeKiLO+USvQ0mTAH/ZQZZ7eH6vZdAOZh?=
 =?us-ascii?Q?2DJdBtTkcl1U1EmY+c5CglOoNlFSUOrccveaBt7McJt4aShp4WFIZmkoyNw1?=
 =?us-ascii?Q?V5pudgQwmq9On51u93P8HOPfDLTlY/O8Mep+rPZzG6k5gL1IaStaG26xYZrk?=
 =?us-ascii?Q?ZiDQmmnWUvVbqlprhaVE6pTXWSdk4rWVCFymUTwvJAV9cUyHWB+yMCEJKQR3?=
 =?us-ascii?Q?Colv2AdAy+C1EbWqkj1/00JG1KnRVb6KBXCeu7f8v7DjmRhhLQxB1wWbExMR?=
 =?us-ascii?Q?ATMehIon9JSMwfGK2uOrU47zwEIVbYtGOfsyasJY08zAb9Mh9zWZbIBlrv/0?=
 =?us-ascii?Q?TFU+D5g2OQEln4l4Usrbs4C7ulBmABO9FcRSv/0imh13NLxFozpGOZ7Gk7IW?=
 =?us-ascii?Q?BMo8XZb6RdL3VDmlmvux2rFxk1q69HggSWd1QIfWo2dcHKe2WMj8Jp/jxFsb?=
 =?us-ascii?Q?q/bAI++ipX0tOTJmp/AMR1vBQaqhY0OVBDRqBhz6UREd1wO/E7fPjqIsHIIW?=
 =?us-ascii?Q?ZcJMje6fa04Lu6bPUBhDuKaHGDZuMuBgT7u0ja5Q1wlSbTyuDLswJKXbWYZn?=
 =?us-ascii?Q?S4V7K/Y+DKpaMD0XsPXVr3J6D8crb/GsnYsDUSwDq/p4vjGlgZ9rP3+s/aZf?=
 =?us-ascii?Q?xVt2Vrj34tNQPB/KzMEm06UWdPKZVMLDbU6Mmoy4w+zfq+VR8zFHmTlIduNr?=
 =?us-ascii?Q?rT27Qv5doFdVqwWDXHtNzwz4AarE+sP1io4VYn09aodpWLB9KSdgO/YDnFF4?=
 =?us-ascii?Q?ymY1V+a6+QCk5o18nfhnvnsVQAigC2lhPTgHTnKMBQlkq4ShxyZfMu2hFR67?=
 =?us-ascii?Q?l4D4llF+Gptmcdj1f6VTkfX1hqaEaxEtTBPwpI82Hj7HNMhwgha9xw+BmUnW?=
 =?us-ascii?Q?q51+VBHrkLZ3+mjUn1NCtYioVM+L5MjqFhDbP1hcpI7rae53BbbkvNfYKdYG?=
 =?us-ascii?Q?RmqUBU83GKT186ibahx9fjUdbk194MWk0xva6dFzw47itFQxvVAdXWqyUhGj?=
 =?us-ascii?Q?WaiEZvYL/kCXGG6zzVnA+51V2zwYQuH9HHvVReT2rqaeQ6NP5e7XHEl4cwl0?=
 =?us-ascii?Q?knRiA0mgjR1Yt4lWmEkM7+JZFnqoAsf3eYmXREqVQ18+DFBxaxMUAMsTk6x8?=
 =?us-ascii?Q?D749z3pg7TaD686Mww2Dr3CZGMlQuzO+UCT8nDIdtnZRT8ehMsUxg/bUZfib?=
 =?us-ascii?Q?3C325QFwAc9uO0uUyvLkYO8r7ABMfgozXh3B0oqtQKPhnt1TBF08RTQuWP9n?=
 =?us-ascii?Q?D0xQIurNhaGg5V3lPldWzZozepYovb0VkjwKLQw2qzeyYJ820S17js4qah12?=
 =?us-ascii?Q?6JfE7/n3sJF2ASqKxY5AKJ65KrFeMrdOGRVEd7Z69E31l58+aTxMT+RaFueO?=
 =?us-ascii?Q?oUy9TMrJYW1tMz8orWwcW5rxG5Sx10a61Hu8MiS18ps7NwjXjSavTKzO/pdX?=
 =?us-ascii?Q?080npWrhD2kqqYooX4gLC4jwqm43b6CQS9D4NhhOZjv+0aEIhGy1LwN0pZzV?=
 =?us-ascii?Q?ef/4PKTSDrNoi40ZDvt2CPR/VhPC/HR6qANIjVeygYqkhDyspRO5jIJoc46Z?=
 =?us-ascii?Q?jZJpv3V3RFP0PBhWSql3nWVrw4B+XheqG6PxZ4AFlgIGl2XeUaPeYRRYEa/k?=
 =?us-ascii?Q?DNFgvi++PinVO5Y6s0ydXf58Gk89lqg5RbsbO2LpOP1Z/fLbI4Ry/7/V4LnE?=
 =?us-ascii?Q?8kUyqyIku85uMhHd6JJrc/oaJj9IUaCfeay70X+TuMUSbWNW3q/1duozWJ9h?=
 =?us-ascii?Q?jf6js9YpVfFIgMgaV6ni0bgxDj5yzeo=3D?=
X-Exchange-RoutingPolicyChecked: k8d9enQ60H8BQkW3dHehzXHXDvqyw3IrLj47vpmBXyoG4G/YApo+XVy0SfHqi2/bKLs+bHYHzOXK9IvjwsI8dCO+vldVZmlyu+7FgEN/A9DpByz/SUDeX+WIX/aUi0nVtfQ2gKRM9Ayn2jhOA5PtsKypWwSeC5cGVuAziK9oeTVQyCWq+3MatGc/YsObbimk2QziUCPFrvaqTewpORt4eEEo7OH2AMvNB2xTDZw410HpoqhiY3jDI9T/Ll9wjkhCNhNiEKZt8H3c28nXY0ofQ9UHetnFZi+Crsz5h+8xfogoJmxSVS1qcz92LLeDQZ2KzandgvttZcZ04KUJiFMTdg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 67fc965b-4b68-4b8a-8fb2-08deab25ec2e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 04:14:10.0203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AP9OLXIPFwjP1cmWf7GHQpfbjWpo/kcwKzFLWweSdcIqPkbTsn6sbz3fDG7z4jnNsE974yEpUx19BHlxAmHmcoc2KX2SYBHooL4+6OztrAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8509
X-OriginatorOrg: intel.com

On Wed, Apr 22, 2026 at 04:08:33PM -0700, Dave Jiang wrote:
> CXL type2 hierachy can be setup via the cxl_test. Add a regression test
> unit to CXL CLI to verify the type2 loading/unloading. Test include
> removing the root port and bringing it back as well as unbinding the
> type2 mock device driver and bringing it back. The expectation is that
> the auto region should return.

I guess I'd like some words here about what is important to test, and
how much type2 we can test with the accel mock driver. This topology is
limited to an auto region with a single device which I believe matches
our kernel implementation.  BTW, is that spec limit or linux implementation
limit?

How about checking that it cannot be destroyed? That's one we've been
discussing for the kernel.

How about disable/enable memdev?

I'd like to see replay_region run here too. You've already set this up
as an autoregion, but running the replay_region means we've kept the
topology rebuild in tact.

I did run this test with your kernel branch.

More below...

> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/cxl-type2.sh | 71 +++++++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build  |  2 ++
>  2 files changed, 73 insertions(+)
>  create mode 100644 test/cxl-type2.sh
> 
> diff --git a/test/cxl-type2.sh b/test/cxl-type2.sh
> new file mode 100644
> index 000000000000..0ece0c4f6ddb
> --- /dev/null
> +++ b/test/cxl-type2.sh
> @@ -0,0 +1,71 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 Intel Corporation. All rights reserved.
> +
> +. "$(dirname "$0")"/common
> +
> +rc=77
> +
> +set -ex
> +
> +trap 'err $LINENO' ERR
> +
> +check_prereq "jq"
> +
> +remove_kmod() {
> +	modprobe -r cxl_test
> +}
> +
> +load_kmod() {
> +	modprobe cxl_test type2_test=1
> +}
> +
> +init_check() {
> +	load_kmod
> +	[ -f /sys/module/cxl_test/parameters/type2_test ] || \
> +		do_skip "cxl_test type2_test module param not available"
> +	region=$("$CXL" list -b cxl_test -R | jq -r '.[0].region')
> +	[ -n "$region" ] || err "$LINENO"
> +	check_dmesg "$LINENO"
> +	remove_kmod
> +}

This is different than other scripts, including the 3x load/unload
cycles and 3x the check_dmesg surface area. Unless you are looking
for something special in kernel log, and in that case we can look
for that specifically.

Suggest following the typical test pattern of:

check_prereq like you have, then:

unload
load
check for skip
rc=1  /* rc=1 after we pass the skip test meaning failures are real */

...do testing...


check_dmesg
unload


> +
> +# Test rootport disable/enable case
> +cycle_root_port() {
> +	load_kmod
> +	port=$("$CXL" list -b cxl_test -P | jq -r '.[0].port')
> +	[ -n "$port" ] || err "$LINENO"
> +
> +	"$CXL" disable-port "$port" -f
> +	region=$(cxl list -b cxl_test -R | jq -r '.[0].region // empty')

s/cxl/"$CXL"
s/cxl_test/"$CXL_TEST_BUS"
more of those need fixup below

> +	[ -z "$region" ] || err "$LINENO"
> +
> +	"$CXL" enable-port "$port"
> +	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/bind
> +	region=$(cxl list -b cxl_test -R | jq -r '.[0].region')
> +	[ -n "$region" ] || err "$LINENO"
> +	check_dmesg "$LINENO"
> +	remove_kmod
> +}
> +
> +# Test reload firmware case

firmware

> +cycle_pdev_driver() {
> +	load_kmod
> +	region=$("$CXL" list -b cxl_test -R | jq -r '.[0].region')
> +	[ -n "$region" ] || err "$LINENO"
> +	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/unbind
> +	region=$("$CXL" list -b cxl_test -R | jq -r '.[0].region // empty')
> +	[ -z "$region" ] || err "$LINENO"
> +	echo cxl_type2_accel.0 > /sys/bus/platform/drivers/cxl_mock_accel/bind
> +	region=$("$CXL" list -b cxl_test -R | jq -r '.[0].region')
> +	[ -n "$region" ] || err "$LINENO"
> +	check_dmesg "$LINENO"
> +	remove_kmod
> +}
> +
> +remove_kmod
> +rc=1
> +
> +init_check
> +cycle_root_port
> +cycle_pdev_driver
> diff --git a/test/meson.build b/test/meson.build
> index e0e2193bfd51..567347b655d2 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -171,6 +171,7 @@ cxl_translate = find_program('cxl-translate.sh')
>  cxl_elc = find_program('cxl-elc.sh')
>  cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
>  cxl_region_replay = find_program('cxl-region-replay.sh')
> +cxl_type2 = find_program('cxl-type2.sh')
>  
>  tests = [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -207,6 +208,7 @@ tests = [
>    [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
>    [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
>    [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
> +  [ 'cxl-type2.sh',           cxl_type2,          'cxl'   ],
>  ]
>  
>  if get_option('destructive').enabled()
> 
> base-commit: 81c7cdd6cbcb4f1f77870ff02d8dd86298036f58
> -- 
> 2.53.0
> 
