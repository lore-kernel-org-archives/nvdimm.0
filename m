Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F68156F35
	for <nvdimm@lists.linux.dev>; Thu, 25 Apr 2024 21:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714081152; cv=fail; b=P5Z4xlVZDixVmCGIWPa1mQnL6dzmpAP8WjMDXvo5Y8Cn9pTa2Oz2EauhYzIwwlgvm8cddH9t9D2nKlEdLtRVlur4yyLLujwCYHxyGkd/R5lOdkpVM5RwYHTvpbckJwjNC1WoJnn7a/MF6wYYEU13l/b5iSyNXsPldKXZeK8ZOJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714081152; c=relaxed/simple;
	bh=k4lYQmXFEXB93/sdytsgCCU5FNoCX/TNZveAsfr2giQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lsXyTBAVXXdwZlmuF2hcswqiEHExS1p9Oq4EU1n/bMTQ0ui0CAbrDmAjFEEkkpxKV2vCvxkmV08a/jJu+tWTwqemgZl3xDEKIgt1wzZWekVuRVpkAW1eWmOj222BwJlDbiOO+FbC57wXu/rIeawOz4fnu4ohjzVYSSRhGm9jdRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i2Mb8tqO; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i2Mb8tqO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714081151; x=1745617151;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=k4lYQmXFEXB93/sdytsgCCU5FNoCX/TNZveAsfr2giQ=;
  b=i2Mb8tqOAVN/z46CIuI63BDS1jvc3fXW5Mh1GILliw9jEQgBPF7Jv0xW
   zh/41DHErjx3O+DdtIsduZqF1/6V88pSuDiZ2WZ7Jep+4tWGCt9YXMKnE
   rZDzY/8FdinccoJSulw3hlup5CkyE/rkaHITcxyhYTvnGkamqQTjoUE/W
   3nczonoP6aFVzIOlQ6mzhWLZX4PKkta0fsaBIKUUPVlmu4JRpCsexbdl6
   h+/NpHQleUjgn6kYHMkLtyCwuHyx09fCY05A0XcCaK33sgiyusMnnO/ue
   5qhd14/6fKEfme2RrAA1OMc2Gcs+LB7bQ61XLmbTXvO4R6k4Ix4ECXFFj
   A==;
X-CSE-ConnectionGUID: HQzYoA5ZSDWqAJISTpGAwg==
X-CSE-MsgGUID: mdpF+oALSFSY3DE+2CX9qA==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="12737569"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="12737569"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 14:39:10 -0700
X-CSE-ConnectionGUID: I17UEM4QSb+CWTL/Fv0dYg==
X-CSE-MsgGUID: jnrCyeQTR2ySj1Y3v7e0uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="25261762"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 14:39:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 14:39:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 14:39:09 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 14:39:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYu482Rg06S6h14rcaCa6I1QT6B+wxcYaMmEeos2bFjHGn9n7hrHwHk4BWEZZ9KJBmXrxOTk47uzDrJ0PpUgdsn5BRbbXsWVQqRuRj+FPQF057own5GDPwmjmqQz4hUnPeVjGqbJoMFH6TlcZoQ8Pwh8sjrXAJpSasNPLiEiEn1UTuz2kHTrF5uhlZ4x6fg3D+zzQo+QZOuqiF5OmlIvC/I6AjG1qJflmIoNHSZBDFkRg/lg5/bEqhpdBlDpyGqmT/jgRMsoWjLVKTbSh0Lw4pov6kwnAvEP0qiwJReX/MuPSO9UddMEHuivT6vXMogVAcy7AkRdt88iheZNF7q2Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XKLYjzPKYb/HO5gTL03jLAoSP/sR/s4Dt3AaRBzx+h0=;
 b=HAeGlWGhj/a8Dh42HJvWICGp7yl5UMeNBoeXt6WRIWdhCzmiSiQ4so9xL/fYA5tVvvQ/0Dju4crkibYYHMJFh57RedTz7v1xwDKvvm4TzQovhpqTMtcipiLqWNJiD0oXjXQm9U13nHrkM4zp9PyTn0UpTmIdhYfR/O7veplWwCoA7AUuL6UKIk6tiKgZw/f/GNQGX5ikz+8eOrfOUOJEZLtgvkpeAcEr1TN716OdGwvIpl2sCIKtNJRy6IRc7ioEwnWzuQBODZNKF58ayGkyd9iKEzS2WfKdu2d47+OLjmifxcuJ1UDsuwJlR6RMVYG5IL54lptmDUMnIgdWIrvpsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SN7PR11MB7490.namprd11.prod.outlook.com (2603:10b6:806:346::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 21:39:06 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::d543:d6c2:6eee:4ec]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::d543:d6c2:6eee:4ec%4]) with mapi id 15.20.7519.020; Thu, 25 Apr 2024
 21:39:06 +0000
Date: Thu, 25 Apr 2024 14:39:04 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2] cxl/test: use max_available_extent in
 cxl-destroy-region
Message-ID: <662acd783091d_10b56a2941@iweiny-mobl.notmuch>
References: <20240424025404.2343942-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240424025404.2343942-1-alison.schofield@intel.com>
X-ClientProxiedBy: BYAPR07CA0063.namprd07.prod.outlook.com
 (2603:10b6:a03:60::40) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SN7PR11MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: 85fbe116-61ee-4a40-62ef-08dc6570224e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oX/05TP8QWafswqpM8MkcFBkCUvdwtK55j4DRij2qiSI7mLsJ5QKU23Yo878?=
 =?us-ascii?Q?aAxZ25HmkTISLYunAfwYjkEK4LB0MiSLCVw6rgNCEBFntRdeBZiJK2R6xOvX?=
 =?us-ascii?Q?rR0NlMfM/S+MbWa2jwNRqz7TS836qRzknBEZJEyCI+iQg/6M6vpCyc8jtjgI?=
 =?us-ascii?Q?nAKIHtfpfw5wgI/pEjfsAe6EnUOdlKTiK3qZGV9Gb3Q2OQPxBWAQwgO3H2ff?=
 =?us-ascii?Q?5YE+CebywfYnJak8bT1bDwvMU/gDipWZ6gB7naYRQqcQQ/6k2zLr8rgDJ4xi?=
 =?us-ascii?Q?BioxROa3ssfj08esJjDGmfCwNwL0uSXiYGatt9wH9Bjo+DBPOruQUDDIw+gl?=
 =?us-ascii?Q?udsJrTcVMY8p0wB5uI0O/Y9LESYyLztWbNzvgkCH0BpRNoBVT0L2hkowWQdi?=
 =?us-ascii?Q?5CmHaMeuAGD91mOyrnn8btOqVf59/lv3yqIN7BnZh96FhTLUtxyIOKOyLfJR?=
 =?us-ascii?Q?snHzlL5f2sDT8TLJlB07sPBxCiEvljHgUoLPbaOTAlcTA/coW/Ihrwn9FMew?=
 =?us-ascii?Q?AlMWIL11ExEJo9hrHTQDT7M28kKi2b6KTkJ4Isp3hx7JvP4Ly/AUJtul90ue?=
 =?us-ascii?Q?h8L9JQCa8iBCnkS1DUftYj8z7+vvuG3oxZRakeir33V5vmqsrupAYhvvw/Ud?=
 =?us-ascii?Q?1MtmfMWgbjCgK3scu+VMEGsPftg/D75W1XheC3oTADXKzRzIpwjg11Adv+w4?=
 =?us-ascii?Q?rJA9J0JVfYS5gTaVCR5RVD/W51jO0AGlVrG/bSGo4Wx5EGfyOUlORNRnj/jG?=
 =?us-ascii?Q?l0I2X0Fe+EFk9GPuQvMHaNQzuLOqYQNtMlp7vJ1AxmYGINBFI8tiimM2m5uA?=
 =?us-ascii?Q?ld05UARMr4zl6QwDdlIZlLuFCXv4LBLHteLkkl9KLbddlTlQhKnlYTg2060E?=
 =?us-ascii?Q?Lj18kFzSScpF5aZHzR1VIIvdW7D9C/17yDJeprbvt4HbpKxubKtJB7ynKIs9?=
 =?us-ascii?Q?dSNsV6PDAm5xHZbjIzntwaKPmPPYDYxqYiTpPVbx66VhbB+LD2nML6zI8oKh?=
 =?us-ascii?Q?fR9zH8YvK1ijLKYHIp22boH03MICnIQQj9U/NA95S/E7Gq7/p36XQUYz9vFN?=
 =?us-ascii?Q?wnc/98dRS3whUnq2MbWmNgZZXIDATxF4ejU6UikzFGJZPKTSCUUjNsmTuQQp?=
 =?us-ascii?Q?8Aw190pdjZlynSwLpj75GcOmeAXvMhQ82DEZH4rRvbWbBTzD4h1YBR6XtSDH?=
 =?us-ascii?Q?auFrvQd7vE0wnKSqe2OyuWe0gc0P3DcQfquGFDfO7/EQy/RDHL4lIomcH4yZ?=
 =?us-ascii?Q?F1SQs92FRvn3+mbf/0pccIz4150/j86bCa+ACMbz1w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n1l84IhwdPM5ASCT0zEiVpQaNaSOOmHNfphrMisV1IT+yiIhRtqT0gAbDDiN?=
 =?us-ascii?Q?Vv4kt1d745Q5VUk4RpeeNqgIryXR8U0ZqeqyemljUlpSpDVmBxK+kUtPCaZ+?=
 =?us-ascii?Q?FjN0Ud5+cNSzXqa93bWclIhBo0wLur4y2djLwUKHvk0sefPvDp1unGpAPYVQ?=
 =?us-ascii?Q?wrzl4C+8NKVdJQ1IHLYdMdFV8r6w1y+udSCLHbslMotqbL+DDL0I29stM3dn?=
 =?us-ascii?Q?LWUy6Bjbuai9Ox66nmSn7MrPCiitzIrXQFXlzfBNewBJkLv1bEqN90ODRXFr?=
 =?us-ascii?Q?RWuW3I4x8ZRVUm5klXoVrQ4e0ABYbxBZMeSvgfEe36SI+gg5lFPT+UBq4IEH?=
 =?us-ascii?Q?O5AgWsmODkzmBWlV/3QUbeeN9xhWWM+KK/KDAEWcNw+7NZ53hqYmxHw9MVOW?=
 =?us-ascii?Q?gRqmUpjDnENbCkWQ157mD+3IvYB2UTrVAgZbiP6HSs5pc+3Z64qX72aQKl3w?=
 =?us-ascii?Q?FGQq3FWkrAybX4b5J3E1aoKcrh9tJrKfxsyfBb8kQ0S8bIoFSpR4cZRBbm9S?=
 =?us-ascii?Q?PnBHX0gxh1wNBdBHA1sQc7dVRLzITOtpcTBk+U0h4BO8dRP2XmyDMHWCgtgE?=
 =?us-ascii?Q?QHdPCTR02O8qKBubggdbPbo29uzOlzGWjksVi3kUPabbzB2hggPpAbbm6k/K?=
 =?us-ascii?Q?I1joyMlc1zJe1PjMX4xDjbcapLBzfhOSPeDlrlmgQ/A0QjdMIpOocB3QcMuR?=
 =?us-ascii?Q?ebu/rsaDnviUMd6/FdH3xroy+MQ45jaa1kPsBAqtzfLhEC5GSOmbQbfIzFxt?=
 =?us-ascii?Q?93DFZjfZ8zcuYbXWg3btVHTYUkPNgy6zbDs/p95VVkk0S2QoY1IKic7a92iW?=
 =?us-ascii?Q?zT0tBM3aoMUa1ebIh5F8botFNhWlR76/shOMLUvZPJ/OWW6ITkEejwjYKTSE?=
 =?us-ascii?Q?U3yd5pADkwU2jvYRxGS/g2ueqySoN4xGBTMp5xv3jko3mxp5yDPqGXX+QDLy?=
 =?us-ascii?Q?mmDChonNsR3boOWosADAIYKnzaY2z6buCrGp1TUnZ8MQO4yaKmT9nCcvpCAf?=
 =?us-ascii?Q?DZrkjP2C7opkdw03aCozxrzfEft9vlxnY+LpYHjxvtf+NXzIlR9FWW2tvZzc?=
 =?us-ascii?Q?iTcqtFDD652YPkqOmzn2Dp/shhixtCscvWrLpV5myD+ycDZg/R+zJBX7OU7R?=
 =?us-ascii?Q?wfqQwXDULlteKEiJbPBgDKKCHmoPF0nXZnzGUog31Il9ovHUyfe2x5maoADY?=
 =?us-ascii?Q?rc5+ywxwIoPNXyB+B7WpG5Z6ZIiISpk7urlQ+Gg7e2qvqkrwTK6c18FiRAAT?=
 =?us-ascii?Q?jflBCXV3+QBlLhHB4CZmxHDtPcIL/AM2cUlpI4qql5vswGtBbtGqKCDEsueu?=
 =?us-ascii?Q?Xbge3z2E/EozEz+l5EJI82ykXqLBoGjT0VdFknsweuMMWGwq2fATZVSNIV8z?=
 =?us-ascii?Q?Cp8RvGZcSrxApz1QeQjJLx1Ba6cGxmcaoMyFHwhAcE7E5mSqP7U3mySB5Vpm?=
 =?us-ascii?Q?2803gFMhIPuTrFtMb1orvoocwOVW5nmA3WVgXHPPHS+bGbdd4Nk8EMdlp/lc?=
 =?us-ascii?Q?G4cmoaI7OX0D0aSvG97/gDB5QIoXRm8Us2qIfiEWKSS2sftkEVpfjbPxsqa0?=
 =?us-ascii?Q?0JGogbELdZV9SIE+VVDJW0+PVXaD8prbK2KfOkqg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 85fbe116-61ee-4a40-62ef-08dc6570224e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 21:39:06.7766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDVoYzc515dH882I50oAKABPAtvDeD9AP28wFTwi8sUZbHYRqx5YajvFTjfMubkd/6W8ePNf9dGVlev6iB78kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7490
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Using .size in decoder selection can lead to a set_size failure with
> these error messages:
> 
> cxl region: create_region: region8: set_size failed: Numerical result out of range
> 
> [] cxl_core:alloc_hpa:555: cxl region8: HPA allocation error (-34) for size:0x0000000020000000 in CXL Window 0 [mem 0xf010000000-0xf04fffffff flags 0x200]
> 
> Use max_available_extent for decoder selection instead.
> 
> The test overlooked the region creation failure because the not 'null'
> comparison succeeds when cxl create-region command emits nothing.
> Use the ! comparator when checking the create-region result.
> 
> When checking the ram_size output of cxl-list add a check for empty.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
