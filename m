Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4EC1DAC9A
	for <nvdimm@lists.linux.dev>; Wed, 15 Jan 2025 20:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736974114; cv=fail; b=bMiBAE4zEQ3jlwiYNjJBjNUPYdyC/iXuGDAX+Kan/wnt8L6f+auLhTIpHSREA6qlfnVYfLp0XmrYrKcX7dygE9fiF74kEITiNfAXJVy79liLgVTya+7myU1kdgdecN+Uax6rHsC+ATQM6dFAS6IPYviNf6tUTVgJ9q57lR/U0PU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736974114; c=relaxed/simple;
	bh=lyfvVW8VUbD6xJ1On+CIWYb+bAMniDNQIA3wHMD/vPE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RRJw2H/jV0EMaycZMOK836I2KlrZ075A+lSQ4I889/eeL5+NAPLkconSMAbfp1qkDdT1O/+TuIGEA64I9yCLcSg5KNLL28oxRqE+BrSQ0HpyGGu8IB+R/+9skAtXURH3GpsVT5rmhFLmZJ3yiXcCH5tHzKlq6DEi/tX/49D2R4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FfMysPr2; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FfMysPr2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736974112; x=1768510112;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lyfvVW8VUbD6xJ1On+CIWYb+bAMniDNQIA3wHMD/vPE=;
  b=FfMysPr2KjoQInLCiE38s61FGZjXOpq0i26+uymb9ws88jacDvgqXI1y
   XVmGFUs8paW4v6/CUMkhhxNy0lQ2ORxqQshmjkEeO/dU0B+tkx29UAw0r
   SOmIJ3ISkYqyLzmn6fb9PjJXdIOERtLdsfh5LEvvlmEy4IxbbxwTsMBmF
   4rQ4AhNliEBN9ZLienNBBBF6ReHvE+3bz1ALrwowzFQoQcsXlIbRDT9R/
   dGK8KwMgsJxw4Gi+NgJu2FF3pHrGeHKdCnvwlKT9xMl86+h1jvU65YIez
   ylTAxt+cPqsGcfyxF798GiqiRu3RjRV6Ef11x+B4BkDvUYAnAasGiEpUO
   w==;
X-CSE-ConnectionGUID: DiLDMgBQTkyW9XsPyIReAA==
X-CSE-MsgGUID: se/j2GFSRLGLJxq+kKTTmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="37443225"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="37443225"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 12:48:29 -0800
X-CSE-ConnectionGUID: 4D1NxCg6Rh+mcpEql9WhvA==
X-CSE-MsgGUID: EWzVBn6rTCaBxlgNDW5ZtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,207,1732608000"; 
   d="scan'208";a="105024465"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 12:48:25 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 12:48:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 12:48:24 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 12:48:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QcbF4QFNF/SKz1s7l49rjxDUFkk7KMmDQ9fGlmb9s3rZ2lN3k9Rv8oY+gXIHupHbzMO46NRJAZBw031z3zbUsHb4dnufLuf6ml+SsS8jVimr0AMDcrIHbpnU+ruUkPwm8gs4/uT7AS2zc0zBGzDXf9lc8aBPzT7G/8iPMJYsZ6QH1GPMCsiwXg/Syvan8rtSuFjLaUJAArrTDJcQdqxsgjChzqWp7vFF6FZ8jPggoR+zx9QAAlo6yQtMD3SEmm/I1RdAB13RFqbQd8P7UjYAdIaotDYlTrDTYpTuvs7Wm3u85dQ97o9XfRcfSf/diC5apiuZAHxlb8pKbibrPOD/tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBPDwzdy+WnZv5fNvuiUwiu39NofjjPQNTnlqlqsljY=;
 b=FLD2GREF8PoBJeHeVLhZOjreJ3BgvlvJdSDfkVFtqaokviN5EoIOSORRNwJFMRlo5VLrJT2RxnCBTlFqiN6MMQ0pdoiFBVaPTWDZqVWyfHRITIxkR++Lt2eM07Bc0IMa/q44D3sYL9WQimFoH+FxJ+LB23gxPO1UM7T/AfeOKXZwC801lA/8T07DUsZL+jp+h0xQmbKjx5sOq82PxoItzwATUYUbDHP9jPxxutm7vE79FzIdPb6gCelCh1p4GdtM/3drNzepwRoumT8eKmHPTkapJNGgKKO8+vuDpGv+QP9NDylbe1OAXWCNREwhn4tq5weNfYcwD94OLRS4vRDj6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CO1PR11MB4772.namprd11.prod.outlook.com (2603:10b6:303:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Wed, 15 Jan
 2025 20:48:09 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 20:48:09 +0000
Date: Wed, 15 Jan 2025 14:48:03 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Alejandro Lucero Palau <alucerop@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, "Gustavo A.
 R. Silva" <gustavoars@kernel.org>
CC: Davidlohr Bueso <dave@stgolabs.net>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v8 02/21] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <67881f03e607b_1aa45f29430@iweiny-mobl.notmuch>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
 <20241210-dcd-type2-upstream-v8-2-812852504400@intel.com>
 <67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
 <469ac491-8733-986a-aaae-768ec28ebbec@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <469ac491-8733-986a-aaae-768ec28ebbec@amd.com>
X-ClientProxiedBy: MW4P223CA0019.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::24) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CO1PR11MB4772:EE_
X-MS-Office365-Filtering-Correlation-Id: 2468995f-9d23-4c45-139c-08dd35a5eb3d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nw72UZdoO35ZhKhqk1qjtMWn7qAgsT4+90r5rHFZj0JPU1sh/6L6Zs1MY088?=
 =?us-ascii?Q?+4Hol/Ddnw9wL0YOdsiPOYZ4QQMiu4U/oty2qpXc5QkEbkWkrKILFXDiqnYD?=
 =?us-ascii?Q?gPU9Bhl7HwPt6spLlar+EuiZgCB/iquqvSf1JaaxhTIlvL8q9DpTVPbJcd6w?=
 =?us-ascii?Q?uHbiePNw9M6XRkMT1cIxm/EoFoDcxoCvjOesN+anv10g6vBo4ABTeDzwnbwJ?=
 =?us-ascii?Q?vN/gDIHe8uuNhJitqlAFcVKGWCqlrdD0ZcdDZs3chA/Ej+DBBUTvbSVJjU8v?=
 =?us-ascii?Q?nKocskZI/6O59Hais18XJsnULBE/RmtMg+SkAKBYPh127pznl4W38K/S3xGa?=
 =?us-ascii?Q?GmGSkcw4PsJl2j+rikxlZE0CRbv8nhSizviHETEtP4zmr3ISyC3KyIhExG4z?=
 =?us-ascii?Q?bzg51LegLZpcKJdiLDVGOz6w5fnkOl6GF6JN+eNf3Fp7d61xThtCIeAf6RUu?=
 =?us-ascii?Q?76xJLn/DwYcfHlCI933yRBg7PCYS7B2AFwjNSL2bgwNYRANYm9KY1g6MWphU?=
 =?us-ascii?Q?1UJunIGXv6FqU+TtcTNDM2RLdmJcMi8fVvjBSzfH04rXavgOZiJZIavqZSVX?=
 =?us-ascii?Q?Z7Up95+G2P94Kg//iSlxAuI1PT4hEm038f6ZGCWY0pPKRUuqPM1TT08zQQIm?=
 =?us-ascii?Q?UmPwF+qJvLYROiVMU1Qfa2xOXJFstGJ8sLj6w2Vs9wmEIfYBB0LzFdcDukNH?=
 =?us-ascii?Q?6Jv2eHLyquPv4w0nfcO1qK+LeO99afHs48mFMGkM7WJKmWaeX28N+O/b9oyV?=
 =?us-ascii?Q?T+ktIfxSyNbAHCV/LuqqJol1sEF0tVEP80qtMtIJVa+MnZSfeWWHcGXAI7n+?=
 =?us-ascii?Q?o0lKcjDZayEzcSxWIibgV1A76KgacvjkhQVr6bBlupbRsDiwryy6+/W7ETfI?=
 =?us-ascii?Q?PYbizn0P+OcwPGN3DEaPlV4y/iDEndOMpse6QDjVTzvQ4GdO1iIMnoi7eOF9?=
 =?us-ascii?Q?Yp7p6c+qsGFbpriujKcWwbu1dmpQSRBBHeKipdG4FvXX4wvIx/m/IMkXI9UI?=
 =?us-ascii?Q?eNol4dI/usq0wSiYj1xJTbH4CrANNYaK9Y6bs2tl8rKpfplPdrU6Oidj4p1c?=
 =?us-ascii?Q?czmjRzr9UxMV/kCwbMxC3bAzuZ6v1MSaoKLgDW99CfTtFOyE8E0c+UQa1cKM?=
 =?us-ascii?Q?rCa/2531ynLnGdVsXiHKXvng5K84LBNunyGkAJy21gEbuyUhdnSIq9FwZviA?=
 =?us-ascii?Q?Ccs1MwAOmnQ+21nmC+JPjEaPaAuLxuStegGn2z7tBU/44B2zdJsqB3j6xzzy?=
 =?us-ascii?Q?+zaS9+LN7oXQdGGuSOHgte659ZfKNBe/8bniXXlvExmFE1GFiYnH+TQQay+D?=
 =?us-ascii?Q?7lNGNGkf4nr/5L6rwAELHvddD9AfmSmz3gybTLz61aWUvA5fQ8faYcBejN8C?=
 =?us-ascii?Q?kWUq+RX9N+BXMYfybQ9u938a1EGnQhanMAc+Fh3HWJH1nASpjGjJdkEhKn7S?=
 =?us-ascii?Q?nGotiXs2en4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uZGWa4cP+sootY3JzjQF8Kf+N3UyTZYypMwZ925tEmbwOtRg5hIZPRaqD2Ft?=
 =?us-ascii?Q?FqTvueyRQTN5hnGZQJv6oWjvbp0LtkO+CG2ELSEoB4jEYa9gozuR0k/d8+hb?=
 =?us-ascii?Q?Orx4SsQfdmAnAwxADGKKGW/9Q0i9DMh+dFkypfCqBo2HTup70iMU0oy5g2Q4?=
 =?us-ascii?Q?Af7H/pNhMEXiqPoVN5Z2YTaAV47w5F56+T8ZiI2OgWh0Wscl7cCB+7ytmya4?=
 =?us-ascii?Q?Lv00DvL4/7k6L+1mjsgR6U5ukOz2t2ridzd5cnceKEh6xKAzbqWh5FicygZA?=
 =?us-ascii?Q?hdpzmyISyAyxr0aHQZk43+gCUWGuJwCT0UkK9/OZ4Xt3qOz9HivqhYwSm3BD?=
 =?us-ascii?Q?1aRPLHVx3ted53OoZkqkLJ0ahm5DfxMN5RMvuQnxWOOanuKqiLpnA6kVDDjR?=
 =?us-ascii?Q?SGslqB0FApP0jX2e0DoW8Rxe0hIPDr7ZLi/bmgucE/BdNNtHKLLLw5EZvNZW?=
 =?us-ascii?Q?R2O0xzahVfhVT0A8zTn2tkC6fkRLkc/F5vtjVFZ65gQdzvUWvhgh1jpDgAHd?=
 =?us-ascii?Q?7YDw51UFtA/oU50mXNzUH8P4kyVqP+fjiT/Ww0Ps1OrHq8jjOoJnc0Juqqw7?=
 =?us-ascii?Q?0K7d/tQ9JTv9k7iPWxmq915BXOINzN1Ugz/PHlXh7ZbShCiDzI7MeExNiOvd?=
 =?us-ascii?Q?E5zNXhlGahnfQavJDSUvv50jpsinTWN1CeKX3luU1WHeUbgkvQDGf9jmbof+?=
 =?us-ascii?Q?z6fv22UcJIGBDjNNPOyG9XKcKmEM/yOnQvSqyXPzB80DdyoW59tLykbopEnV?=
 =?us-ascii?Q?LF5VluK/WiMxm6tsF2kcJrUrEI08qs6OOCIdPkQ8YQIU2I3FCsIAErdGpNG1?=
 =?us-ascii?Q?11ul66aKCmWvQhmaNrkgLjPFrI37dZc+sILf/3cLYcSTPM3lKYl5K33D/TJa?=
 =?us-ascii?Q?tmytm2Kb/XJO+wlVW/pY6j5z2+BY7Hh2OtCtU3GJoTfQEKjkSjRfuy1gRGxB?=
 =?us-ascii?Q?0nauhQx9digaClCpyvkwHXuOSF46lPIMy3tD6TfOfOUtF9Lzft/GxBPhDq6n?=
 =?us-ascii?Q?FwPu2wN9hIpZevW5R11yPTPsFz2VbUuZirlTWwHoqvKH4wH7HcJaWX3vpABZ?=
 =?us-ascii?Q?4CnxUq5ESAGpvmeVlqLUoD/3G3Q8xFMxdrzXlXx+OIuQTyT6ubAsR11yuvMk?=
 =?us-ascii?Q?cqiXYRY0L5ff/EqgnNgWwdlTCwE8sVVuuzWyp1DbDQGXrWfCrrgaxzzWwFOe?=
 =?us-ascii?Q?u/4rar5c5GjRWcX1k87MMhaO/0x60D3bE+NWyLjcYRpSgKYesTwn4azKhA63?=
 =?us-ascii?Q?x6bSw/8cPTE0REXHINAAHybuS2JFI2DfpmhywNd9JSEoL7lnlCcNKJaw7jvB?=
 =?us-ascii?Q?TVIpuOmJ9sric05cWHlVDSlwVJHzbEy455dRJ1wtwxRPACLAa2Zh3CeCaMqO?=
 =?us-ascii?Q?w+vTkFjnL0MZTSjYLuUtFIoQHYvyoElMyylTF6YHPVUNFk8a1o3nFZFZ9+Tf?=
 =?us-ascii?Q?yH2S5CrOPSRJnU52aQWTBazh32EixNsHeBDMdr0gTmkH3NFgntQE6FoXPmka?=
 =?us-ascii?Q?GX6Is5wu2Ot5qhcTx5/nisjsnRsI/HJ6gb3EUdwE7qOxvaJyX7Rd5j8jh+Oi?=
 =?us-ascii?Q?rufqDA9YI20VOlFuY9sMVvqhXbvjg7U/fnXfqJ1S?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2468995f-9d23-4c45-139c-08dd35a5eb3d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 20:48:09.0650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6L5UYah6ZV+TdezyJdMQh4vQ7gkSRGp+8Oe1/F6ROMVgIIla+m54Nb5QaEbnMsaDWLAyLh5IkWlyaqVe51hE0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4772
X-OriginatorOrg: intel.com

Alejandro Lucero Palau wrote:
> 
> On 1/15/25 02:35, Dan Williams wrote:
> > Ira Weiny wrote:

[snip]

> >> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> >> index e8907c403edbd83c8a36b8d013c6bc3391207ee6..05a0718aea73b3b2a02c608bae198eac7c462523 100644
> >> --- a/drivers/cxl/cxlmem.h
> >> +++ b/drivers/cxl/cxlmem.h
> >> @@ -403,6 +403,7 @@ enum cxl_devtype {
> >>   	CXL_DEVTYPE_CLASSMEM,
> >>   };
> >>   
> >> +#define CXL_MAX_DC_REGION 8
> > Please no, lets not sign up to have the "which cxl 'region' concept are
> > you referring to?" debate in perpetuity. "DPA partition", "DPA
> > resource", "DPA capacity" anything but "region".
> >
> >
> 
> This next comment is not my main point to discuss in this email 
> (resources initialization is), but I seize it for giving my view in this 
> one.
> 
> Dan, you say later we (Linux) are not obligated to use "questionable 
> naming decisions of specifications", but we should not confuse people 
> either.
> 
> Maybe CXL_MAX_DC_HW_REGION would help here, for differentiating it from 
> the kernel software cxl region construct. I think we will need a CXL 
> kernel dictionary sooner or later ...

I agree.  I have had folks confused between spec and code and I'm really trying
to differentiate hardware region vs software partition.

> 
> >>   /**
> >>    * struct cxl_dpa_perf - DPA performance property entry
> >>    * @dpa_range: range for DPA address
> >> @@ -434,6 +435,8 @@ struct cxl_dpa_perf {
> >>    * @dpa_res: Overall DPA resource tree for the device
> >>    * @pmem_res: Active Persistent memory capacity configuration
> >>    * @ram_res: Active Volatile memory capacity configuration
> >> + * @dc_res: Active Dynamic Capacity memory configuration for each possible
> >> + *          region
> >>    * @serial: PCIe Device Serial Number
> >>    * @type: Generic Memory Class device or Vendor Specific Memory device
> >>    * @cxl_mbox: CXL mailbox context
> >> @@ -449,11 +452,23 @@ struct cxl_dev_state {
> >>   	struct resource dpa_res;
> >>   	struct resource pmem_res;
> >>   	struct resource ram_res;
> >> +	struct resource dc_res[CXL_MAX_DC_REGION];
> > This is throwing off cargo-cult alarms. The named pmem_res and ram_res
> > served us well up until the point where DPA partitions grew past 2 types
> > at well defined locations. I like the array of resources idea, but that
> > begs the question why not put all partition information into an array?
> >
> > This would also head off complications later on in this series where the
> > DPA capacity reservation and allocation flows have "dc" sidecars bolted
> > on rather than general semantics like "allocating from partition index N
> > means that all partitions indices less than N need to be skipped and
> > marked reserved".
> 
> 
> I guess this is likely how you want to change the type2 resource 
> initialization issue and where I'm afraid these two patchsets are going 
> to collide at.
> 
> If that is the case, both are going to miss the next kernel cycle since 
> it means major changes, but let's discuss it without further delays for 
> the sake of implementing the accepted changes as soon as possible, and I 
> guess with a close sync between Ira and I.
> 
> BTW, in the case of the Type2, there are more things to discuss which I 
> do there.

I'm looking at your set again because I think I missed this detail.

After looking into this more I think a singular array of resources could be
done without to much major surgery.

The question for type 2 is what interface does the core export for
accelerators to request these resources?  Or do we export a function like
add_dpa_res() and let drivers do that directly?

Dan is concerned about storing duplicate information about the partitions.
For DCD I think it should call add_dpa_res() to create resources on the
fly as I detect partition information from the device.  For type 2 they
can call that however/whenever they want.

We can even make this an xarray for complete flexibility with how many
partitions a device can have.  Although I'm not sure if the spec allows
for that on type 2.  Does it?

Ira

[snip]
