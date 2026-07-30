Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EA43E63BE
	for <nvdimm@lists.linux.dev>; Thu, 30 Jul 2026 22:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452332; cv=fail; b=cizTsNtm6edOcwHhc5Nrd1KOwPGcO+nlBD2llDEmXqKZwIhspcrf2o/stpdhFoQ0pgOKjr6APJE/6UEtyjdGw9ICG+KckkwFQJgQl68fac/nxECArnkA0O+H0ETV5wXLZvnvmod4Tk350NoTnlSJU7yUtD3wSpxWvSULLXBRmz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452332; c=relaxed/simple;
	bh=ArJZ2Qi+m/bHlNZlldP+YLRM86xW1Xiw8iPE/x98M38=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XfJVK06aOvBKG6OG4bex4pd8C4Cnil/iZ3Rex91Z6ETDJ2t0jt7GqvxvLJ1F5peix9vDTmMhP+VCkD5ebj4i6YZbmNdQTvHOLwoOSaPlxJngPuIewuh2FnghECNC/ZBo7ufYUpwOcS/mldb577bFegh40NPzGxaWFv4itKOzPAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kxhtqO7h; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kxhtqO7h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785452331; x=1816988331;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ArJZ2Qi+m/bHlNZlldP+YLRM86xW1Xiw8iPE/x98M38=;
  b=kxhtqO7hVDq9MBttcBmV32268YdVcpx5ZkSCYBGhrKWaTebd8ZZLCgfv
   8lvSXBkHvmHfiTLMx+/7o5SP156yqCfgduI1bO0SBVrHAL/mVSBhlnITI
   aoC20MYIvJ6xm0fjkBNFIjNXsiuTUsi3JyuGRUB+pSLTN+bRz22H1WRHt
   0lXi0epFNXp16sjcJfriWqon9Y1E5dgLEi+0KJMju2MPfNh6pJXLHvAmm
   +YO5Lbm988VVX98wGjexjCW+M7ZIg8TupcQljvoaaumL7FplaHo1x/Qxg
   18QvZT/Q6FROjvvwnx+muUA9aH8913II9vmV7nJIr1wmrCCwgRBAcdOco
   A==;
X-CSE-ConnectionGUID: iOcgO4ElSJmsFXryX+07cg==
X-CSE-MsgGUID: IFjShZFWTrivTH+B7QRHDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="89893583"
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="89893583"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 15:58:50 -0700
X-CSE-ConnectionGUID: BHQ8iPyoQZulue/JrV1Agw==
X-CSE-MsgGUID: Om0tL732RLWJW7TAFZANkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="285024139"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 15:58:50 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 15:58:49 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 30 Jul 2026 15:58:49 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.4) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 15:58:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qpAVcvME67ypVp15jhwPPZSQQ59UlAl2q/wl/dl88C2fdb3HeB3dj51I54Sd8J/7PMeRF3mS/E64tTzh8gIQXXZZ0G1D99cUpWKgsNADNokfkH5/7RpTrYxJgp78RB+izfETPmgHKbn6NLK+ZXZjGtMzDfiSDOz6hqHSQIlEc2gdoNiqN5F+BcI07XU2pLSA3yL/crZajWsXA3eWhqyEKILjJ2cd95IULNQd9y0apkNH4k78JymPu48RH9D1bljg82rmjiaUq45G72F34aNEi8VHjOAjYhqxpnYpoAPPmNR/D6AUzDVYJknZPISPWwqt/jFMARYD1wtUu7E5xiyniA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtvjQUPiSbFcgZ0bCYU/F2Qep6F2RDCxA9S4Em1RFCA=;
 b=f8pKOREXZaWYE/aJ61uwYxpPm+PmGGCekRepqNjEU2AYpIBm9yS6ufvWdTuYIMSWYRg84gX+BsDch5u4U/HLa02BWRvMdsJQQpex2GHMbNYJUt7GJtveCsRJ63nag2Maw6RZ8OXy5I12Hn+wRGHVqQ24MQ3HoACqtuc+kZuhMrrB6hKjalW6skZzbIoXBTxvRqOSEV06U4elGyUWvgfP4fr1vGDaAgkBITvFnzzdgNSchsfnYNdyfJQmX7Fy4GWK7WTULoLNc+O5xAmYERHqXnEx7/veKXKzuTvhnXbsuapeTlA7K44gyVJwZcWvx9MFK/ROg2WNgedytgBSxB7RVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA3PR11MB8896.namprd11.prod.outlook.com (2603:10b6:208:57d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Thu, 30 Jul
 2026 22:58:45 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 22:58:45 +0000
Date: Thu, 30 Jul 2026 15:58:40 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, Dan Williams <djbw@kernel.org>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Ira
 Weiny" <iweiny@kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 1/2] libnvdimm: nd.h: clean up kernel-doc warnings
Message-ID: <amvXIHZ4VvuhuNVr@aschofie-mobl2.lan>
References: <20260721172132.3718892-1-rdunlap@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260721172132.3718892-1-rdunlap@infradead.org>
X-ClientProxiedBy: SJ0PR03CA0337.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA3PR11MB8896:EE_
X-MS-Office365-Filtering-Correlation-Id: a3f1bfad-939f-42d2-a548-08deee8e1bda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|56012099006|10067099003|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: RkL9wR/JvEDawLU7dAjAkfFbcU0i/dCKMX0anKue2bm4RdPrsE8IU7bKtgREJ/k6qZQ+VzmXCd6gTiQUdirjLiRF1gSIOdNeK1Cz/1/HbOy9zoQ3GGuJG3fXn17tgCvz2MVi34y62bdQJdgSxioQGEQ5oATfMDht0VZfa0r1ut0zPEEfptbkbhz8K3d/6jH2lex8Mia4V0+I3+cSrJXQTSe3BlMWNDKNtH/qY6Rvx2ye8JCB4vgCM3UAujb319PgSwzcj2u5X/BHZJCvtBS5P3WEBMLrwRXjv1z4fr4809At6BYDVquaG32d/0qli+NWJvLcQmxaFbM4sDgQ7TWoRxER55g1YITzDnyk5u8OKP4vKI8XIkYNZ92/KcmvGEY5j+YTp4W37zYC91+NUAc6gPxB0tdnnc/ynQR51VUDgDvRQotgSjx3yVBg0IgOWvtNG6jhFHV2FV01NfY4aYDmowjq6vNx1yykxOVH3RDZN66rNH/DWiFRwOWOomWZ/tAupStupEyIRAGY8f8AGb4oQ7p8RXEQ+RT4kbawpC+4DzI1+FVtjRmV377lzAQ63rA1QwmH7QsS4E3znfTKrVisNV/AV90iEDNGX24ENet1/sd6y8WN27AoS/11DgTe1s6R/sRQkZmTt1z4lNg888QSZFxzZAA0HaYnbgezLTn9o10=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GRC4rE2wr8QCrw7Qc6rE5xwJtyj/W43zFnLW4D3vD+J4+f7AD630Nm/bx/zA?=
 =?us-ascii?Q?Y/cUxkReJ8nk3dM+f69PtQgzlO3c20KfSH9EUtuKQ6vXA1eEzejO0yx4uOXU?=
 =?us-ascii?Q?pocMN4c/v4Qv8LaZq9aJm1mXrhsVE0yMLHxqzMThuXQZyy++RO1uXTF5Incq?=
 =?us-ascii?Q?a5XUUMZ9hjP0jSRg/ELMF1WdREEybso0onreHeEjms2NELsPpY1okMb8S+z1?=
 =?us-ascii?Q?uY4HADuFP1DJJxFYJU+npYaM4nydwHCeU/wF0uIsvjrY08xzbf35ePtovCPz?=
 =?us-ascii?Q?43ICopCoI9IKRfy8oV/MBdPkJYrhGNuEn3D6nMiV/XYZtBkh+tWuszsKBVKH?=
 =?us-ascii?Q?fEGEcu5P9rUbXYGaMwxvw3BQsjDYZDBALR5El6mwtIkvqeGMrXsX5mrdRnIr?=
 =?us-ascii?Q?iDvB5R1x4ojqH26SoHwj7sLKwsTUb3rs+EUTI2PifE6ie50CnO06Ka/kaazP?=
 =?us-ascii?Q?funNjfiiQEl2SbneZXI0TfcpKHrqcEPoc/rCL8OmJ+Eg2yXpJmHDenD/dfno?=
 =?us-ascii?Q?vaLV1RiJBgmsD8tTIBqRaBS9vyUhUXltpYSXwTLL0GuSagwv3igm5BODbWWK?=
 =?us-ascii?Q?fzrwhW3rN8bLyoNTQCY942y7xvBvEMyUMu6fqDgRsrpoNS3+6TmsfHhc1bwI?=
 =?us-ascii?Q?zVtHAstEqAnDLh1Ebqf5sujRZqcNfUSJjwed4YRxujpfYYVN/SR1pjham0k4?=
 =?us-ascii?Q?gHrZRVfUpmMQMXJI4HTtfa77Rz1UoOi9Y1b/8jDyynsD+1bzDsYRJo9NvDDa?=
 =?us-ascii?Q?pJkIzRaGhscvY5rGO8bLKJScPMiLGHXwI2RnXANO11Y1bVs/pvmpyth1an5S?=
 =?us-ascii?Q?eRuH2aZdeItkJzkVdNhxfC/WaeXbg9NayBdVH+ju6xZedlMM5WhXBO8jXeWp?=
 =?us-ascii?Q?kBMwaZKmvp1erpDtLBMKwMSvp90XaKBAfsydKJuRbrlC07Ci1Y0ZofP9LIwv?=
 =?us-ascii?Q?sOtUiwGpMb4Iq/UHM39yeIV1tQPiRZuN1lg9QhTXxXNjGEpzUzszcVJKcC7A?=
 =?us-ascii?Q?UtLwpYgvajUNO8llepk/C8XPjFByEs4ODe50l/RK191icsa9skd6orjoKd+O?=
 =?us-ascii?Q?hFQJEX2//hH8ShW4EmWIRKqUGyfg+L5kPqI/Qe8RLA9JZV3VRNzzGw+26jYp?=
 =?us-ascii?Q?ix9dyi5hfzAArvuD9EjSYtlAFHCWJrgY6842syu1XIUZXmmAiXsTsljbuDGE?=
 =?us-ascii?Q?zTWGluloduWZ2GZAWQ0METE6eEjTnjz/FON+QvHdokTZo01QzsvM11i/DABK?=
 =?us-ascii?Q?a60Q6n7fkGGlncn+Ze55h6S9TegH1UaYh1PsI7CeQlJxrfTCIlXywdc5RXzV?=
 =?us-ascii?Q?Wdr7Rju9XDA71hmbDVf5yHDtjztuD22IFXxUgrBNmhbgAm5b9opeFutZqpNz?=
 =?us-ascii?Q?C6lHn06P2DXf8zKmgFAfe5uQwqHdJzk1iFpCDMmJ5cZSbLcnMN3Hk/rLzY/t?=
 =?us-ascii?Q?Fse24s4A1uO3CbGnjrSnXOZg44CFYm2EGrucbytMOhvsvJpUlE5VZ3j2S0B+?=
 =?us-ascii?Q?SBHwTvvgMMkct1AUcOazq5DM2Hhxz1PfnYmTwqPADcJToXHg+JUs8kHmfwLV?=
 =?us-ascii?Q?PlXIIPTxa53CctXGeq1XzWLSqefY42KGhcE+uQYtRT7uKz8LJY+F0aWlTR3r?=
 =?us-ascii?Q?dzGn0T96Bt1AhvjZBOJ3vT5BuWoS53kq/pAMqzWznLxa6ot/iIyKek5NKCEZ?=
 =?us-ascii?Q?0NAqKh9coqhlG7fRrXEoe7zxrph8onIklf3+hO6HuK6VXkj+XhTkRT1fFMVQ?=
 =?us-ascii?Q?ZDA4UsQlsalXUjd6oq/WFh/O82mPQEI=3D?=
X-Exchange-RoutingPolicyChecked: Vijxk9rBkn9SokxmJOi1TZPjBuNv+BK+J+XlNpd+03ipnbIlQSSryKy1kNgU5Aj0Hh0x3ubRY/U8D5NDqQfv9wbdrd56csOAOYheIJWXpW1LCqhADeN6HIAqLMkF9+j4oFxHYiXsP/6Cl5Czs33JoA2rDfsihGdN/oiVbPbaHVsOU6lbkAy1wt4IChO+cZLqXUIlQN7hTWOsWCbXaK/eJbCbSpNQcqYkgX4b90TjQuBbbMxXNzibSUOzpl7UxdRIdtDV4QYwa8kc6LA/DR8OZZX0oYRg7M0kfXe8E7iUdQMOaq0dLS5aWWmrX3szkz+Pv0KVBf3jaT4lh+txOp10XA==
X-MS-Exchange-CrossTenant-Network-Message-Id: a3f1bfad-939f-42d2-a548-08deee8e1bda
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 22:58:45.4900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TVYIHFMTBxEt+rRB6dOUr28GMgoZFsKpODhs9Zm6gJhfYWzyFQCUPJZ/0HcjWZhG5tHtonp9B1xOpDTb8WvgHfFvjQNj/TEEj8+7tOB93qM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8896
X-OriginatorOrg: intel.com

On Tue, Jul 21, 2026 at 10:21:31AM -0700, Randy Dunlap wrote:
> Add missing struct member, function parameters, and function return
> values to eliminate all kernel-doc warnings:
> 
> Warning: include/linux/nd.h:124 struct member 'common' not described in 'nd_namespace_io'
> Warning: include/linux/nd.h:124 Excess struct member 'dev' description in 'nd_namespace_io'
> Warning: include/linux/nd.h:166 function parameter 'flags' not described in 'nvdimm_read_bytes'
> Warning: include/linux/nd.h:166 No description found for return value of 'nvdimm_read_bytes'
> Warning: include/linux/nd.h:185 function parameter 'flags' not described in 'nvdimm_write_bytes'
> Warning: include/linux/nd.h:185 No description found for return value of 'nvdimm_write_bytes'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Thanks, applied:
https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/patch/?id=1c454cec28d6ef9f04c32b10d268e699e09573a4


