Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941C6397321
	for <nvdimm@lists.linux.dev>; Thu, 21 May 2026 19:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779391846; cv=fail; b=Ff6cHwLVXA4IrVe4w9jCPrYAB6YUWl16JevOP3a8dJQoXo3rKgIYwLd22GB2vhBexGkkpTbSJjl/rdzg/bjyj2eiwMzxzskkvZ6LBp8K2Y2pXDruPA35LhuJRb/6ndaVSbcXRZa0xOxd1Wrw3ticL42TKLvleqSPTm8Njh2Ek+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779391846; c=relaxed/simple;
	bh=UwsVLY3BDhoT9YDi/ivAW9u//rIPalajtbee4AB8Jjs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kYawXtf/2P1eEuPky9acWrC9LQgOx15cD+vg07WO9WDvWyv0Hs8V1O93x73r4WpmhPPNp5Fm57QyJYLhGvnqjZDcNqeD2rZ98QesHv6+6llHyENnr22MgoYxU90S4JhlUpflBSpB7miZEfRU8h5H+KogS+I/wd7c0wnatBQDgV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LHs1EJQG; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LHs1EJQG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779391846; x=1810927846;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UwsVLY3BDhoT9YDi/ivAW9u//rIPalajtbee4AB8Jjs=;
  b=LHs1EJQGYUeEvy0XDYUvt6jUrEii8L9uruOADdBRkbC33jr75AP2FRNK
   S62KT7AsFCgkrx5eLK9Oo/JnFgrFhMxGRVhKaplLnAjFDpjP3p6xuD2wW
   Y+21F+HXTWZQXm97cvvQfsl7/ryJ0TG2RoboblR0RRnPGqvqRLB+wU1AM
   q6cAphTh9N2ff3DNh1jeJvOZ5+FQrr1tZp1J3Uuq8Gnaw5iDVdOmSft+Q
   +g62Th5jxn+wGak3tQ+9A5fliPZIJC2bQk69hVPnUYh1E6mHQ0xKV/Fel
   Liy34bX1jrVZNWtuAClDM1Qb3EQvxDkwMvl2ufmPTuRoWmOQdjgIrbxec
   Q==;
X-CSE-ConnectionGUID: 1JNGW95NQn6T++A0zOR9pA==
X-CSE-MsgGUID: 7SMbyc/KSuCM63KRLUt1Dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11793"; a="82897705"
X-IronPort-AV: E=Sophos;i="6.24,161,1774335600"; 
   d="scan'208";a="82897705"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 12:30:45 -0700
X-CSE-ConnectionGUID: Ht4RVFvPQ7yxR9cQrStNjg==
X-CSE-MsgGUID: pjaeTYlNQ5e5GK8oTOsfwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,161,1774335600"; 
   d="scan'208";a="245670182"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 12:30:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 21 May 2026 12:30:44 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 21 May 2026 12:30:44 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.21) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 21 May 2026 12:30:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DX21VbY1f+q8qlQwkinHkvcYVBdWUrx1rhsUGYPcinbNjxCE4ywzqrZFpIiDoQVj0WFhgUXd62DvsiGk1Tpx05r2IH7EPkTQn+97yKgJsSwoz1uztMriklBcyPW7JQlH4NCFBJd607U4EmBI0bz+X6SeLDk55SgvM/gE5cmksEWDXlzEepJkwBf9nHBp0JYJGqbU7gfQoLLuR5d4ifWySFz9+ZAZRap03aPjS+Wk+Ljc/Enulby9+biMM+lun63lmXkwOnJrZkEfz/TI+L8dpMkGxdkMrLDHVwYtArwxQEbL/crKcXHOOqKIUmMFWvDHJ6F7GPLlH5tm88evKWSG6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSvu4Wk/zf6WqPTRNo+UqV2vGaE2oIXfxnv3T3FndMI=;
 b=jgNmawWADQMhpD3AS+eVDWHMME6t9QiS4s48/Fx9qfhZbdNq951EajG17+PmP+OmhcB25hV2cU4WKs01aM5YRoZs6l904laZmBEHMOfTqghm+adPZmkrDa1ETqIRsKm+YkReA9LtUv4DTjBJmN3fk9QnVfLNFCDOfYKY1tdxCq+7eUuRHNXGYI2vlXkyKIOqD1WGy8gDTz9xC4p7kfH4b/SB9sevdam7L3VQhOvWXjeTIXPPWTvW7a7wIUDKC03YU2TaM7eDIDj6Xb93t6ZlxNLkA0D/u4YB8STWGeirwHdGtM3o1IkgDOPWLXqSxFLZre6Txd+5Tg+XwVb846KoLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB4918.namprd11.prod.outlook.com (2603:10b6:510:31::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 19:30:42 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0048.016; Thu, 21 May 2026
 19:30:42 +0000
Date: Thu, 21 May 2026 12:30:33 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v2] cxl: Add CXL type2 accelerator unit test
Message-ID: <ag9dWW0VAjp6-0AL@aschofie-mobl2.lan>
References: <20260515001203.2628149-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260515001203.2628149-1-dave.jiang@intel.com>
X-ClientProxiedBy: SJ2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:a03:505::17) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB4918:EE_
X-MS-Office365-Filtering-Correlation-Id: 44a0a5b2-c06c-4e5b-e25e-08deb76f7270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info: xkFMjKtVCHb9JPsnO2WEo+9j5Na/ymJEuWlDAspfwL1N7WLOe1ncFmqnhXbt4DDy4SnDOFnNhdxnW/6PawpCq/Emnh9O7FUHyY9bUvTGJXVYCCWFqfJLWA6P8KZHUMJFyt/sTuJzP/9TTOdvAKuPr6kg09Wunk0KVt7cCqKdHaT1JFWOl33G6idKt/YojO5N9mCT4KSmrv42DCCXyiVqc7O8ZDf+bo0BG5/XzulwCYpMJokF8+yVd8BD3beMvpTgjzO9QcUuyjrHTRSPVjcFSq2M7gTSkUgyu5PIdk1eAbat8CBh1THyIhIXGFVDa5LLnQrINKvHwcQH3xXEVRKcqZkeu7BvJ1kHtzjTs9aWK1YWJuAOPEQCac5qInrEVqFndFRi4B0oiMh7sA4oepbFpCsTU6ZDf7lyTCOfykLqyu2q4YGl5ORkLy8eyUZ7el5nxDhbRGoKpFRXYTuiUqW8EB32Y+5paYoYQn4xomAGqjpG3E/s5AQRgzkzgBsKs3P1Jptlbh7rA0wFjUFitV6bUdK8wBD+4XStZW+xGUC4rlnlGKP9XVorg0jJ0P9mOb8jVCUKRIV0K970aMMuz6eGQ3D1s9hKUY8071vw58V06sDbI+uhCBEh8otknVWNEXg47k9nnGLei3lfB1LhSouQS6hJJKIie1j4Sy8ybf8LYC7bgTTz9Ex0W1saF7kKUdgN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(3023799007)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?43N2asBJrKl3Cin7P2tYb3juf2JJ/Z8ZmsfVqGHu+kuGUOXxKZ6pf5vWoBnE?=
 =?us-ascii?Q?B/6GD+84P/Xgh1mGG7Dp909gYUyjmRyOqraY+r1+f3ln6sOP++dGE6HYjDgp?=
 =?us-ascii?Q?mXk1ZRjCDpPp3Oz/+G/scCuFPLsfXb83h6R6qDHnhMVtRnmf8p7z/k7DBD9X?=
 =?us-ascii?Q?4zmIrRyL/P1cZAaIoQ8rWX2seU7frTFEW7b5W85I35Tr2qpFXeYh3S/NF5Gh?=
 =?us-ascii?Q?XmxZ7tNHNameK88ZNA04WSD9PxWZq8qceP/39SrFMhYfXsuZLC5VCqzfwj5e?=
 =?us-ascii?Q?xgzeK1srNKB1rn0In2Co52K+h8u6eb95EVkqICWdTkzkUt+9a1szAvx98f7k?=
 =?us-ascii?Q?gsfW3iV4lUe1/lRauynLp4AgUMhjIdGHisdNskWOn5oEBg5oLJQcT1gEJfPZ?=
 =?us-ascii?Q?ahsbtM3PtxY9ZIBENt5TrfrX1hpfOJha1GKegnVh1itCrVybKVck5beZ3efc?=
 =?us-ascii?Q?u1MmBioBGyMyMkyS+ZirvisUijgGRp7+hx+hgUy05K7XuOV+wizw52HgCvlV?=
 =?us-ascii?Q?qHgA5ohdc4AIUbzgO6vmm1VpDGxJStoXYMnrRVgS7pgtHFbyEh0Y19byktg1?=
 =?us-ascii?Q?NFAe3zmgTj244Reu8gX81MA6scnxkiG2TzaF2AHHQ58oeQOi3g2HGAKB0eQ1?=
 =?us-ascii?Q?a6TlD8SiQRrR+QoylPrhbNszl7nV/a61GjU9LI2oitKyAdQgWsveRldQEVdw?=
 =?us-ascii?Q?LGXQTXPr766+K9PBy1N29YhQrGMEEfC1yvYIcKQcJYB/URaWyBmYUSQ6bW6y?=
 =?us-ascii?Q?ILCBO9eUl3xxZgwfYDbldjFesLdgFzKgPcnfRt7VM03TdNvuzbzpLYWUmlvx?=
 =?us-ascii?Q?NxK1XC2eudUbUWogmiZmaleZd/im3uD/MjGDS36483Bp6yKlRQuo4cFKFtkO?=
 =?us-ascii?Q?ouMMhzVmExYXDqraGtIyfXj/dwoonDcDHQ+7m3w53g6u9zhzlHj54NWi9VQF?=
 =?us-ascii?Q?/ciHozFRRwiHTz7XlU7bGh5nH30vdQlFJlJup8DxvpJS0a4OzFb2RN7P41ll?=
 =?us-ascii?Q?5afjDY65zd+vKbBjXJlmiN0kSwfNh/bjel7o88ISleNQJWiytegAoy7eeIk+?=
 =?us-ascii?Q?ZZla5xOfJ1bP7vy1XgVOaVtKtbXJxIFw/6G674lpm2r1z2zt5zDYoSzdqCdR?=
 =?us-ascii?Q?V2e2MeNyirNGkGcHpYathN8wYPEMyQEVIuD1HZhhRizmn1Hmeu3TdBjzWijs?=
 =?us-ascii?Q?uI1GWTQMHTxocwAKD6EO7oTJ+5ncEWIouFdXDF55wovYyIg+zhL9/2lx+7JT?=
 =?us-ascii?Q?Bvb6wCIfVL3CWaxziYJLLO3zVeZy4a4XUij5ClRBYLGRyq/FrLg8BtydZZbX?=
 =?us-ascii?Q?MEnPNRziGZt7BJDnT/PkjRabq1Y/Y9OKqkb6Om47gkesXSxC8rFss8qIXQrC?=
 =?us-ascii?Q?pfJ71NhYTTev835taGULninvmIY7vHrZEAWQD4/d9YNDYX5XSaui3yO5Euu0?=
 =?us-ascii?Q?d65AdWrQ5xUZEsOpwuD59G82ncpFd4dykuOGqDRZD+Vgs9a5r3zJQ4cIYmsO?=
 =?us-ascii?Q?HgTwviApboF8fNGA1+FRShYxsrnEO0CrsfPghoj00Tgtd2Zirj5WysDr7KhF?=
 =?us-ascii?Q?jrSqwKkA68u1u64cfSm7MtdBbamsZkORLJDDfK70kQRL8/MZnFJegHn0gpqt?=
 =?us-ascii?Q?0lRFy6VyyXwOETKtnpfN4gFEa0DvlsIVWJmUj6BdbVIthM2L3FSjpFM13brs?=
 =?us-ascii?Q?k1ajzIoVd14fyglPknl4PHglbbyAq0AD0CoYPU1yRLOBAO/xkiaDyCfgcRPU?=
 =?us-ascii?Q?4bewcWlDFweE6B2bCcWEV5GZFKmnKck=3D?=
X-Exchange-RoutingPolicyChecked: O65O9oCnq5oeWxkjUiyKcNwAj1iNAwFQAysHHsWKtNlnalVT7wxiqjnIOZYIj15Lg+vTBnOaDaIJO4HVpSREtqvUC68BsiulvxlFL2ROEJ6MzccZLKp0IT3RUTNq0VH/lxutZqzMgVSL4kmJ+4tUvRmNT9ThkdQsuPMIMWTJBvpjaLffliWekoJD137rnvGkHBfgci2QtyOUq99O9Cl3JheJifjZ9DOebY3l/iw/nQuqvBqbY6bTo53WDWMk84najZigWMyOt+9jF73ZUFbQPJmUUzgQXiU/IQGstL3Vu+iLGcqgSclAlwbyfaDSFOpit05d5Ec9wZPYnbkl4E1JcQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 44a0a5b2-c06c-4e5b-e25e-08deb76f7270
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 19:30:42.4458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5HThux/xC7aANN0c5sv72wZVy0rFNb2YOVT+4TE8YeyX2euVWJk0dZUnvW5F4wwmsF7BRquIQ1q9Y5fEVmlWAo5hawREPh0lIGtosXKA+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4918
X-OriginatorOrg: intel.com

On Thu, May 14, 2026 at 05:12:03PM -0700, Dave Jiang wrote:
> CXL type2 hierachy can be setup via the cxl_test. Add a regression test
hierarchy

> unit to CXL CLI to verify the type2 loading/unloading. Test include
Tests

> removing the root port and bringing it back, unbinding the type2 mock
> device driver and bringing it back, and checking to see if a region
> can be destroyed and a memdev can be disabled.
> 

Hi Dave,
FWIW I tested this v2 using v1 of the kernel cxl-test patchset.
Doubtful, but possible, I may have more comments when I sync
up with v2 of the kernel set.


snip
> +
> +init_check() {
> +	load_kmod
> +	[ -f /sys/module/cxl_test/parameters/type2_test ] || \
> +		do_skip "cxl_test type2_test module param not available"
> +	region=$("$CXL" list -b "$CXL_TEST_BUS" -R | jq -r '.[0].region')
> +	[ -n "$region" ] || err "$LINENO"

This needs the //empty treatment so that if the cxl-test module doesn't
provide the autoregion upon load, we fail right here.

It looks like //empty is used to verify removal or disappearance
cases, but not in the positive discovery checks where we depend
on cxl-test topology to provide a valid object. Everywhere that
jq result is treated as a shell string testing for existence,
it needs the check. That keeps the failure messages 'on point'.

snip
