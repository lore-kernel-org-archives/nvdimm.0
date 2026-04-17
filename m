Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE8F14D719
	for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 19:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776455958; cv=fail; b=TUMS94rkkFZ1HqSCH70TZzueuDUIuMBVw4EEDYJikqiLuupzpCnZBsXI48xdSCwmbhBbdmJJMgxvxtVGOnbl+IFfIIrP+nyx+0/Ms/k4FYkAeVh9kUw2Q7N2iE/JnN6o87ONyjdif0xsB7D/wUxTTjXXJ39E9/HRapH7a+fDAw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776455958; c=relaxed/simple;
	bh=TtxESAjv5KfLDOzs43GDF6OfdTo9QjOHCUAFsZe/O44=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hTtcPqk6rzxG1CzYMLPLddcvRiMsC7DHlziGS3c269sthqNFp/OTWtb4blRMskwu2nQAoqkEu/Kjvi1ISZE2HH7aV+hW3OwzCq9QXDpCTKA3v4kPs60HDetgjhrA/BLyfUkg3WRYhbQG8eM1cK5C7jWemiioTavgYRil4tm1CaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=azVtkF0C; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="azVtkF0C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776455956; x=1807991956;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TtxESAjv5KfLDOzs43GDF6OfdTo9QjOHCUAFsZe/O44=;
  b=azVtkF0C5S1f0jgUVvw8UI4emfJTF9evMcEVcoOL1y2QGqFVY/uxvVFQ
   v/oZoC4RSgqcu/B15QzK+KX+x58KqafIe6Bi8dQpTl3MbNpcXmCY2BIJL
   zj9DjLSoOKuacjkcj/XdUvWnirLPX+xxzk+mtXHuvVMBnqzMHgCE5UZaj
   jFGJOwdFmeeXmMYcxFCZWMU8pDYDwkMAimaSW8oVxE3gOWpNAujPcxGbC
   eW+0beCKZOoE5ZHtj2X2Pw9WnlyNwVzidRy8scDEnVk+QXoVGQOfEnuKT
   bLlCiGycjA76mEZj2lRLHo2sK6ejW0fOkLEODQ3CMK+dHkFHX0zrOiQ1k
   w==;
X-CSE-ConnectionGUID: SSPSYiKBT6eFVH2pJsTwOg==
X-CSE-MsgGUID: VtzuZVwBThqTcRhp/042UA==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="77385011"
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="77385011"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 12:59:15 -0700
X-CSE-ConnectionGUID: mCAM9MkHQ/K0pUenRmUYNA==
X-CSE-MsgGUID: E0VKmQBOQhK+HSJLCHqCYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="235489217"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 12:59:15 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 17 Apr 2026 12:59:15 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 17 Apr 2026 12:59:15 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.25) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 17 Apr 2026 12:59:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ebtF6HvzKuRUVXM/c8vKfBd4NGfHioHQfE5ubbZuNcef4Uu6Iac27RD4Jj+Cxwkz1aoJUwZSUMgj5kGpy+vZn7ngZc1XWUkCyHmQ1AqhndwEx7zy+nH3S6jSg9BRzbZGDoAMcO9hz+38fqKcmeiBXf0y32XUXNWEAdfc6bMC++FJXkP/HJedjkOaJ207ZgZuTyN3oIxaQlTj8M2vRi/hRCNF4wxTKWEKBuZaS2ko8MDjYIlnZKmo1eSgIa2SQan+1pgtM0rDfoeVQ/XIKcmEkQZD7/xOxY+p1TUHwpxKPggLZszBhHLMIa4ac3iKVOcWqt545qz3MQnq+SmNryKEmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9Lji1qQJTYktcSZpE0bJLjkXWLqVGFefT7JtgmA+wM=;
 b=P0cU9G6c8UXt6iuPSeYLspgPM4c/8EUKDUb69TXEVAG2TWrMkDESrH8pBkM+FOv3VROJda5BeU/1n4rlzWnIMT68p2CQqRg8Hr2FxGc3073flwpXKwXwrWsiDlEXbCFZTv4z0PKqfNb/3TemLw/RJq7F/sfe0BnFlhGkfkRhthudn2b0x+z54do/yir9UaEFVL5cZkzQUUDRNUk7jDVr4NZSsDHNB+MU4kkL2kM3ReTcXME9Kbi3odnUWUQt/Cx5O3AZH2HZ0go+kovtGX3LH2Cdrn8d7e+YvUc3ZYcSe/YR5XV3gWMKoVe3k2jqIEEnPq08DdvamxBCxQdisP2Gcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by MW3PR11MB4572.namprd11.prod.outlook.com (2603:10b6:303:5e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Fri, 17 Apr
 2026 19:59:12 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 19:59:12 +0000
Date: Fri, 17 Apr 2026 12:59:09 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
CC: Dave Jiang <dave.jiang@intel.com>, "Fabio M. De Francesco"
	<fabio.m.de.francesco@linux.intel.com>
Subject: Re: [ndctl PATCH v2 1/2] test/common: add helpers for CXL region
 replay testing
Message-ID: <aeKRDSn1GZc1hJng@aschofie-mobl2.lan>
References: <ccc1955b697f7b74e16924bff1b1e262eb52fba0.1776454849.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ccc1955b697f7b74e16924bff1b1e262eb52fba0.1776454849.git.alison.schofield@intel.com>
X-ClientProxiedBy: BY3PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|MW3PR11MB4572:EE_
X-MS-Office365-Filtering-Correlation-Id: a429503a-37d9-4a4d-abf5-08de9cbbcba1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: ghDd+2UEJX10rHZXjMB7wMZjD7BX4yEshDK9dAMVQVEhRHuN0lvsHeXzdRgSQa1YKxpulKXhITPVEYRhAVorjO3XjzNTHd7hlZ7HYB+jiA6mrunfEoho0JMw8V9T6tR2a6mrBqN5sHlK5DktReqdQSyC8CgCMJOt5VChFpPSLryBrfdFVBYCtzqw+dc+KjxqYWx4SOFiWLCZ2CciiWYNPC6ygm+PYtq/0KWqRDS3y/MZpS/23l/nWO59/fHukOqFtDBH1LRXckfrwgnA/74kWE6zcslWbj4FSe4ZJucTAKVwEbEuiqueQ8ji9SZn84Md6E6X/BTpWzIqMx/dB5pVgEi0iLC2jTA2pIbm1jRCz0yuyVLgkel7HeBOWHAhbg1LyQkMMIc7ITf7xEx6URLqrdn3SQl+RI1oKScnuDEWnv3lYN6QvLyiGbrbvWO3G53jB+sIiN09amlKQ6UjVorx3dxi7JvWU2GEZdTw7+y+lmjhC0/qKsRnMJjPsNeZLnwzzXs1RiAMUJC54Tv9CvxfLZVfBRX4bBlY/qkQ76qA9H+eBUYSzt3t2CxtnRoV4vz1KCfVqV9NBogz81NAB+oU1cBiYy2Vtp7n86Y0bhqbDtziOZ62XtYT1zpXZEAi2unthK57PAYTfDCl5yMMJ8j2VNu5Cx8+zqDF24t9ccHCUj9+R+NH5xMC82g2FxwnnIU8ZWj8LR486v28lVoRbOlMyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XRx/sBaOyDKBoA+n+LnQQi0pg+71w2BlpBffn5Udo+qGAfH1wAtMAtKTkT8/?=
 =?us-ascii?Q?wIjdEjFO8o1x+Gn8ZTNV5vNhP8XffwE7RT0qsWAPO17fF2SUL6jSVC5YgG4o?=
 =?us-ascii?Q?lKXS36cOOg7VwruZTkRs91qoAqoj7cbZA3bzGbj0k0awrGspRePqOXBTUHR3?=
 =?us-ascii?Q?VEjmN8N7rUjeY5LhbW4Tk3yjY0Ba1uuF5hDvfeZR1pDG/6fSYxzvz7TRdwrx?=
 =?us-ascii?Q?LavsIzMQZXcLf1vuxI0F4E1/jXFK48jmatJ9XycAPp3X7zRrDtWkh7G/V/+/?=
 =?us-ascii?Q?OpT1xexkageELHbaXWZDCANRODSnQuEcw4ob91Te40G71bbey9s1fS+bvbxF?=
 =?us-ascii?Q?Cvt8fdeE+Don9lNaqQzKJ4369KuiaSQviGP/9Mxivw5rT4A9NJ64BTAWgpBv?=
 =?us-ascii?Q?O6PXRCfOtxDuvVUET3fJ2oohpG9+QRgs2jrvxwDevgpJo4YSO1lZSQOKvTts?=
 =?us-ascii?Q?7EQosQRuF6vOZSm8Vi7kJFiZn1tKqh8sNtmkAvQ6a5daMVNoSexBiWCZ7Grp?=
 =?us-ascii?Q?UVNU6MnMYLxk3G6PZx8nOZOzCv53UtCgvlWZw0uMIyOxRSM4UeXciNc+XV24?=
 =?us-ascii?Q?wxf6iabB5DZgW88d4uOwCveL+xVHPQAcZs1nJ9yqI15woNe5gURv6toZS+gL?=
 =?us-ascii?Q?a3+0Z5H76L4wjqwDR65SQB5Hbr4kmReKtDljjj+TSE98+4BCopTXQiLh72k7?=
 =?us-ascii?Q?i5cOvRVBk1a22K/lvh0E9rQQUGr5g4PKGR2aZP37RBGS3oyenCnmqmBl0CJQ?=
 =?us-ascii?Q?Ik+Q2OcYt75ubl73sTHyvCoCCJp3/np/cElzG5hwDrtyHDw8gsi/0+48kuID?=
 =?us-ascii?Q?Gs+p68ClgUbPK+I/MYZVEKsqGfjSKbrIhwCY1cO+qPJIoOZqxKlFZ42XAi5Q?=
 =?us-ascii?Q?57f3135RF9HyNK2PDPIQEe3NxWoobLypsa4cCJN/KZr57xvVrxebjhTTPH+q?=
 =?us-ascii?Q?WL/STNliR+FnOVkKgggIvDQ03Z2oZBTU7LmoTxWoplTVKA1qVl0CMBa60EDo?=
 =?us-ascii?Q?1cqW/oyzEAJ0CrfhlqgH5StwvBnFDPvmCkHJQij2ehNqooqB5t4RV+HzCau6?=
 =?us-ascii?Q?MbO0HCZcgCVTf7/HOSAy/dq6EOAyjH6SBE5EjQh6E1TIZhK571F26+5W6ul0?=
 =?us-ascii?Q?Q3s/V8CXTNYfdHFU4iQ/6tyvXv19jOJLUSvhgSspj3Yw67iyWCq753bs+rRy?=
 =?us-ascii?Q?Cg3D2CbincDJv6OsZJvF5zCp3b3s7PTljOglRLi9WtDYXy3KRn1DFWqQMpIs?=
 =?us-ascii?Q?32sVV+XONW9F2Ng76Y1Pc79nhEKW8GxDmR5nL653RXr0IU/P0byr8xcF9TOU?=
 =?us-ascii?Q?8zYxGux2GTjMzp8YpjNRqBxNumZh/F6QERqrLpV6Z8FL62+Rmp/nWIkE2D+5?=
 =?us-ascii?Q?qa4C8Fo3Saf6ZnYpG4qtvpc0uv9ON+fSUviQGc+RsxqHKI3ROfjhpKQKcnWq?=
 =?us-ascii?Q?6YQ80Q0eg/bWSkqSkM0pmM6K87qEdC1vFVwl663vXogpiaRlp71f5pYp5Cn+?=
 =?us-ascii?Q?mVQsHHHZ1WUZnNEx0Zi/HUR/85UeNx1N+dl4RLAgyw/49duussmqEqPRY1Wt?=
 =?us-ascii?Q?JARdY5XakJglGADtX+E4WNoOB1+7PFh3TWRTWnpk5N4hSdmuJISuHGRjxWxW?=
 =?us-ascii?Q?BxudwoEOl1w3zDHl0xIkAZFBzO6sXj0v9lUdkmZwMCyRnmPPOXcy/eqtRzWI?=
 =?us-ascii?Q?1a3A/fIqtP2rnzdN7YZeQzM/J8KtshhWTLlbtA1tg4yeljs3B8m17AU//zpF?=
 =?us-ascii?Q?peZbL16HxJzEq8Ifkcz3DYDDC0tsdB8=3D?=
X-Exchange-RoutingPolicyChecked: oZrnptDugLUuKVfle4mZMS79UxHUCJTIzNJpmkmaYl32OY5nKlVliKEbn1zpvumme5OwnJHDEsieAjpISkHSzkQ2yKLNeFL9cmfIm8PawbdfVieViUavghTfcLMVDVPcfqwI1rhAjyQEOWtvNg/+YmyVJPn7owe+1Zg9dRkq/oQBjiRzmuI50uAjzBhOHnkE1P1eMH8J+qO4O4PqbIPp5EaSyTd+6Oft7sShB7cca8BJD+mRpMmg2ZcK6WI3WdV5Pz96lq2OkMLbU3ijKB4F0fXtiDyldJRkuFdKI5HKIlvk5dGZvZDwchTftctJ7NSTRfY/ZdXIhWD1tEzEY5/nGw==
X-MS-Exchange-CrossTenant-Network-Message-Id: a429503a-37d9-4a4d-abf5-08de9cbbcba1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 19:59:12.4748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qw7x+H0MtsuX8vLEO8ImP0dea7klVBRsKV19x/H4G2v9how9HDHL9vTDoiGexMvwUGsv8BhytytJaKOD+GV9cLWNmRlhVuyfk0bJMHgHkHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4572
X-OriginatorOrg: intel.com

On Fri, Apr 17, 2026 at 12:56:23PM -0700, Alison Schofield wrote:
> Add replay_regions() and supporting helpers to the CXL test common
> library. The helpers capture the current region configuration, trigger
> a region replay by unbinding and rebinding the cxl_acpi driver, and
> verify that the regions reconstructed during enumeration match the
> original configuration.
> 
> Replay is enabled by instructing the cxl_test module to preserve its
> decoder registry across the driver unbind/bind cycle. This allows the
> decoder programming associated with user-created regions to survive
> topology teardown so that the regions are reconstructed during driver
> initialization as auto-discovered regions.
> 
> Region signatures are derived from region attributes and memdev serial
> numbers so that the replayed configuration can be compared independent
> of topology enumeration order and device numbering.
> 
> These helpers provide a reusable mechanism for CXL tests that need to
> exercise region replay behavior. A unit test, cxl-region-replay.sh, is
> posted in a follow-on patch and demonstrates the workflow.
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
> Tested-by: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
> Link: https://lore.kernel.org/r/8646e0b11697e3adb4fc9a83fa486e68a4b9b5c5.1773466514.git.alison.schofield@intel.com
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---

Series applied to ndctl/pending:
https://github.com/pmem/ndctl/tree/pending


