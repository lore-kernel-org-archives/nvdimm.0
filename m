Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BE526D4CA
	for <nvdimm@lists.linux.dev>; Mon,  1 Jun 2026 22:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780353402; cv=fail; b=a3ER55G8qMVxiPpfpSiH35L/n/M6Fbaujrgnvu8cya6mdO/50Et8Wf++M9JeU8RAqSp4ewVUxXX35JF5YzJejb9tjSnfO3eRQYRttlPuZIFT8p3lKi49BeUVGdDxKTFJkxizzTOnDgcfU/89UH+uGEKWc2cszzfq71HSkuuiUu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780353402; c=relaxed/simple;
	bh=8yPW3Kle+YEv57nvUWW1yT6sOdSxTIwvXQjUhG+BJf4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jG9vgiO4ZiNt0qcoT3tRoWxHMUIfREsMSD0w4NAZm/eWuZneX1trKTL+86jaqcCP/wwN2aqHWPWDHGv/veonMim1z9s04ZXovvVRSgcXTjF+O8hp0qBJrEISVsmlC4c3Zo0pbpbouFGJf+duYhuYJMWdcE+IA8+TOcpVU6Wm/5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GWpIWAlA; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GWpIWAlA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780353401; x=1811889401;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8yPW3Kle+YEv57nvUWW1yT6sOdSxTIwvXQjUhG+BJf4=;
  b=GWpIWAlAadP2N41iSkFTUuxerfR5OMVs1H050Nh/nv200feOIzVlgTFF
   J0bD7jqqoZQh3q+QqR7PvWI15kX0mlgZAJcD9l4LlEgmqRF26JjcIfyw0
   6AlB0fWeDOOBYaEmkfxHkPf5FBJFjkADI3yOtGqTW/ssZu5nFg+ftVZ9T
   9omKsaO/4YPq0D6zeCQ+6u5eJ8EJhznl97/SV2K5HsaPYiJd27evAmBol
   54HqiADgy98EOglzeaDRCcgr4MoIGUT7ZfSjXvIElqt9N0qGQDtZMgD6F
   j5mvjqyBW1kP0f1NeM4Wp5yUi/O/ckAGU4cMzXwQgCOcHsHQhIr7Oztg/
   A==;
X-CSE-ConnectionGUID: gC2SZnI2T/W80KVe46iktw==
X-CSE-MsgGUID: Ed5mU9XoQjyV5H4sWbVaiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="98690987"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="98690987"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 15:36:40 -0700
X-CSE-ConnectionGUID: HATCd4s0TFCGWYfm+s3ybQ==
X-CSE-MsgGUID: XqlFExlhR9++CnwIP+oEnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="273981418"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 15:36:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 15:36:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 1 Jun 2026 15:36:39 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 15:36:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I4hfmAyKoVAa1jFL2OpUQj7B6FHAGLJjKVFGbto8fzY7GH+tNeJNoT5qiJwan23lgRh7V2zGBZBpS9g5NIdhqQ5c68k0pLpanNHuVDODVO4CDGQBu9bwjfS1JvHpkT+fsl6s5T4JnYWpLmglz2vpZg8yyEA/MOM+CySG0KW3oNUXpYAuhh1WABXQfxG0x0JTV/MjA872JYHGfEzhg9sUNuetymZEyH+WnRbJ1dU1Qs/KJ7Nn7mlqWNIPT1flrrP/b/9CqhFzltWvT1DiZukbOu0hHD5ihjPcbVOE2OLJs9kBoQlOy1p1bV1bOuB7puIu07CurvNnssZsSGvUU+8I2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MV3LEl46bcvKhsAQ0qHrbq4xl9nmrM1smsTMLnNBeoE=;
 b=KOxYThvsjBGtkcEj++r/LsVq8gZ92WmDCOglqe1AewuHfHTJkzAMT6s8s3fqzPh296DcXby+afAXLk1wfH7N3gZpIqibxHFHNezm9MU/2QlHCiIfiHhWANc2JthCFyP6j9fbCqjNUGcwLvDtYgcLliMC+q2nhmMago3z4hu/51U0P8JhTol1VMkx5xloeOjlzfc0BmGEK9wL94cAS1eYuOaXV3/wDWSmx79zIxhQqagmqsEZhQQQ8yaUPMFQltmZ/BzNRiIBv6Lgzr8PV/6dcpVmQX9jMcucxzVu3oQOP0VL8gxuCGll85m35dTKigFocQjzVCg9OkkMoVtDUv2YVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ0PR11MB4877.namprd11.prod.outlook.com (2603:10b6:a03:2d9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 22:36:37 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0071.010; Mon, 1 Jun 2026
 22:36:36 +0000
Date: Mon, 1 Jun 2026 15:36:32 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>, "Aboorva
 Devarajan" <aboorvad@linux.ibm.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6] nvdimm/btt: Handle preemption in BTT lane acquisition
Message-ID: <ah4JcESLn5nshQsA@aschofie-mobl2.lan>
References: <20260528021625.618462-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260528021625.618462-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::30) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ0PR11MB4877:EE_
X-MS-Office365-Filtering-Correlation-Id: 60df261f-9768-48af-d136-08dec02e3d18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: +xupsGW8iIc4w9l7VZopUdkDaxwx5ehVAsyNzEc1Q8bgzE2Zap34VyFooV2IW9Qr6JvlF+X85gu2BK5Kj5N+HOa0So3LM0OQeZsJbqWWRX6ZFzcyJP+grJHEAgDe/f2KqXfLQ2ciE8iQKn6Q9BlWmE4OhSrEhZBIWY0qp6gzLggSm3rtxO8Npb7i/GH50gRnmSycyY13FmPjqbQ8icltYnpI6NTs363kz8f5hmqnW6RJOlZG9B18oSSbhRNPVH7YwR5xqAE+sMlcHbsQJNB4wrW7gHH8AO0mHcqx5tuPGqiq4zm0TOeSyrpZfnNIvIJGpLwLeTmRcdbuN2tRwxHvpwkvUaCYkY96cJHVnaUAd7tArUWg0u8QszGgLVWIHyt+Ogf8EJJE1V14rWAAKRCPCTzbX3kyxuIGROKWz9HcxEP9BTFVUUrTJq7KkDflHKEsvVDmm5aGmjDOLAmUN6eiIuK4YQ5epEVhHi9llrPynJ4GfMmUKYsoSvuC3fY+VdbXR0WIAxMkDxeowPOuZwEIAhF6vSFk5oGS1N/oyOxRKiqCC7nog8Zx4qylL9iqVZMF1PQCTjXx+JyVyoFkavKrKsd4UhXyijwm3+cOyfVAXXBZb97+IEv8ht2Uc+cN0RFj/oaLv2kUEyNWLUZjaEu5/wNWXX347NOckh0p4BkN+qHnfnAjqGyliS/ugVnem3Bw+0Tf5LJAOth+UdukHhKZeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rZeQf+J25qFF8k/xV5xItPUuJESIIgKptpnYuftZPajjdDDDFzYmK9Ts/qfo?=
 =?us-ascii?Q?KHRMvFnYHet+Ko5xzvwP8YmVwdxBRvjVBt8bJ+fMPYeyyJZOnAaxDZ1pShx0?=
 =?us-ascii?Q?Z6TkVjBhzSS+6xsf+RkTmkbM68sSPW7pIbF23ND6Jphd8ZJvuF0bYIzZdNeV?=
 =?us-ascii?Q?vW2RCUvFJB+jAn+CY5J9plYX2FZQninFU7B/qevmWAB1GLPpqrCC73iwIpMP?=
 =?us-ascii?Q?FXThNKY+Zg3YvKEEnBu8mN8FpzeV3hq02vXGNz6lScaBmN4W+WGKjsi3oO6E?=
 =?us-ascii?Q?Z8ZgFWxVUYffAFPjukjB3FrWCTMUOtRRUE3DJVN+ss4gDShwfVCCZVtIk+3f?=
 =?us-ascii?Q?8ILOZlG96+l6bD+4VXTrVJrKKM9u+nhmkjh3Qkc+oHIkq6MlVH1tAF/UPsgP?=
 =?us-ascii?Q?CSZs5VeQdUip3YNO/kJ12w/EqikI9XL/4urGu4mGy4OerN8ICNWSSAmIQPLj?=
 =?us-ascii?Q?41rS0RBZo3XtxWyXehJe9LZn62RJhgiTqQMIFO1nHKXs6LbUJ63EZoUGHC3I?=
 =?us-ascii?Q?NTg9lzE7Kcw3t+oL37cZ21XqhtEGeyyQPLw+2Oolvzx922G7K9tIxAmkaa98?=
 =?us-ascii?Q?fwRnySFb53qvGKjENxvgQUT66bHUe7+8hghBL+hkUA6CKahRI7ghLIetm6Hi?=
 =?us-ascii?Q?t1Fl9XEOCItIDR+XaylqdkyPFqmiGU2O6vBR/lomUQgkYuhD4gHRlDjOky6J?=
 =?us-ascii?Q?HFG2LIUTkEw2n9rN5KgXbG8uZ6h0fJBbXLSjHHoBdWzC/Ribuci8hKx3npcW?=
 =?us-ascii?Q?KmYnfbwZXrWZRtNpf0gL+BXQ8tMFFgASNxEuqlIDqzxAZ0HeB8oQDYBOIrQH?=
 =?us-ascii?Q?l56ZXg/6xq0lH6NaeIJRjDvju9BGX0EvT17lF0eQ2PEW+TzCwNKUHI0gsfnN?=
 =?us-ascii?Q?uhU82cbM/iCRMSZD6yiu9Hn0w0msAg6vpgyop52XWV46oeCd/OcQh25V+pkE?=
 =?us-ascii?Q?87CpSa3RSmUVjPMLeh1wj4zKUJwEonHtpqIxXemTsyyUYwN0Y90c5AVOzgR+?=
 =?us-ascii?Q?2Kz6BCcFvYNkJhxGzokSQv16r3fMJESfGPwHbJrRD5T64Sqqh6P9wfPu4eI3?=
 =?us-ascii?Q?1u/rFRwpfrACUZw3WvZsQqeX5btx654ayllIoaM3hnAmOidPUbZvXFgE28sk?=
 =?us-ascii?Q?kYg6hoZ7zhnVZsC61BQJ6BOFfP6B3T4euxSuxA37ogj7qVw7EuP9TtoOilJR?=
 =?us-ascii?Q?ypdOi6PjmjJo7Zo8lBwNtDeSMhUn/qs4FBbh+8u6sJt8JizHEvStT3BI3qQj?=
 =?us-ascii?Q?dEt7/dbsPZGi8KPMQmZfBnXXqyivsFDsvozMXYQ8R4Af91bBFiYcpKYPEdgV?=
 =?us-ascii?Q?TabVloRe6GzyUfnUSbynwnPCTQrEzGyfOu9XezDPBTbUjROLRyHUaO4L1eQQ?=
 =?us-ascii?Q?WqtMTav1pOC8+OuO9C2RcNyWbX40ysS5TaP8mwpVZFfaVc4pkOVMgR9TqUmm?=
 =?us-ascii?Q?XXZ2y1LL7GaDwRBgv6BmJIUNAAPz3fisa9WZlRxoB22EFPmlS5d/Jfw/0NU/?=
 =?us-ascii?Q?uAdHNsyGpKb1+GWG/LifVeT47xHTAfyHm4y97eQg8bP/6UeNUOmuvV6Qe9Ch?=
 =?us-ascii?Q?rcsiZ2xz72URhc5KSCpxvAee2wUzi0gp9PGpvppq1ay2rACOGgkwMfNrSyPU?=
 =?us-ascii?Q?fh7/NNutn6bGtll5khyWn5MGiI0yJiOZhhUUPt92rnUtRrg1+SSvT/QwyU4k?=
 =?us-ascii?Q?ZtF+Q48b/HTJ6qGZjBHWBgzkZ9EdS/cmqxN5wGJl2dwPBodeL5lx9/NHCtTE?=
 =?us-ascii?Q?WB1poAgO8MktMaY/iaKhSec9m9rJCiE=3D?=
X-Exchange-RoutingPolicyChecked: MtbV7KQNWmB6UvuPTDbo3+7/dYSj5FsfxqW9JmTdi6UXlqMX7b1RxzOCYdk37X0B1bVcdFW5YH6b4vLqit5IR0oBKnEk1HgoXHjE5vvUCrgRToHkqP8pLS5TGP3B7NzzZzVVnyVkMzsFE4kEk4zm7vhbZqaPFBpIKKZuTahR/pPGp15vwJucBI8o394xYY6PwwmqwpHjuCd2hPpcD8UTFklj2Ci2q/oEOhypSCMM/eB1ydgmhb8ePT5Fg8l02uzO5Ds8RIseUDrlxMc95ySLobGJxgX8CIcf9o2EvkmJ6VOH3MHKEo7t/gG74JXxKUKmFpunFzftIpuWNtjMD60noA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 60df261f-9768-48af-d136-08dec02e3d18
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 22:36:36.0665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JgjadD5CeZhfctPvXuC5OJX0Hh+2Xgux2IzLfEUqoPZv+skm/jCNsOtOqq2gpXqcqXOO0Zth6iz/oHTmdCRmsFHKfmSiNWEOerL0yWYkV0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4877
X-OriginatorOrg: intel.com

On Wed, May 27, 2026 at 07:16:22PM -0700, Alison Schofield wrote:
> BTT lanes serialize access to per-lane metadata and workspace state
> during BTT I/O. The btt-check unit test reports data mismatches during
> BTT writes due to a race in lane acquisition that can lead to silent
> data corruption.
> 
> The existing lane model uses a spinlock together with a per-CPU
> recursion count. That recursion model stopped being valid after BTT
> lanes became preemptible: another task can run on the same CPU,
> observe a non-zero recursion count, bypass locking, and use the same
> lane concurrently.
> 
> BTT lanes are also held across arena_write_bytes() calls. That path
> reaches nsio_rw_bytes(), which flushes writes with nvdimm_flush().
> Some provider flush callbacks can sleep, making a spinlock the wrong
> primitive for the lane lifetime.
> 
> Replace the spinlock-based recursion model with a dynamically
> allocated per-lane mutex array and take the lane lock
> unconditionally.
> 
> Add might_sleep() to catch any future atomic-context caller.
> 
> Found with the ndctl unit test btt-check.sh.
> 
> Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
> Assisted-by: Claude Sonnet 4.5
> Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---

Applied to nvdimm/nvdimm.git (libnvdimm-for-next)
https://git.kernel.org/nvdimm/nvdimm/c/8d4b989d9c9a

