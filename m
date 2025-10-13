Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252E42C08DF
	for <nvdimm@lists.linux.dev>; Mon, 13 Oct 2025 18:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760380122; cv=fail; b=FH2/cjwC2NBJt2193Pti4QwbsGYd3eni1ULjm6jehwjtnRozjYFyuI5PrGGYxQsIDxdARt6+kHVNWnQfk8DuIXY1//GlA7bwtBKvZMZ0juOqOkj1o7vDXzqPdS9oLpNFn1/96iz7HORfz33A5RxVe1hcSQHh338x4NeeW/f9L6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760380122; c=relaxed/simple;
	bh=H/bVzGSj+41nm7ZZXKEoCEH6jOcbwZkC/9DRmOOX7Is=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j/lTVBesP3CnlYxpylA4MbLqu/fMAPNcd0I7P1+7jpbVjJPgNie2+fqyXQWJlq00533kD0ANi2ZFEo8ltaQm61lUSq+t2o7eW1JwoUPaElZMSNPSXodFb3W2VAdNZBhwoV61g9ZEf3q6LAMezOl1pYCAxW9IDE7Ojd6Ue68wR7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YCOCBJRu; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YCOCBJRu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760380121; x=1791916121;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=H/bVzGSj+41nm7ZZXKEoCEH6jOcbwZkC/9DRmOOX7Is=;
  b=YCOCBJRuMQDFmnE8pf70n1of+Z3v6eq4cl9S8gttEbGcTF7TBRIHInOS
   vMDXZtvAi5wJtvegNVAKJFX9KjqcC5xoXIsh8zrkkv+pMgaJCDdhpcvg+
   iEteehKAKungsDf6o7sOufY3rswjxldyDp55zKLe9IrK2jcDT1+Oio572
   H2Eo2aU03a9/JSvGr88AIfMez/IOtYALHUDvCbpPaH8BlmTPGPUZC3/Fr
   FmbjWQK8B8XqNGOranR252BGywVUpKs+c89nlf84a8RsHH0o68sXdjgTw
   F9cAag9xvRwG6QvvDb0qU4+J6XrZ1waZ6cSlaoLXqRM9GE/1xJaFjGAMu
   g==;
X-CSE-ConnectionGUID: fxaBuVTFTW2Wn8nJVEbe8A==
X-CSE-MsgGUID: eEnc3+x6SXG8cIBKSjH70A==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="87987400"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="87987400"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 11:28:40 -0700
X-CSE-ConnectionGUID: N7t6iyRVTYWad3RH0BeN2g==
X-CSE-MsgGUID: L9LB2YT7RfmqU+RCoMa5rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182437764"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 11:28:40 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 11:28:39 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 11:28:39 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 11:28:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eukX6Is7zbtJw1ezbfxV3TWqp5i7kfUyXTDiwmRp04YzoPC90tW7g3ZNWqsrM5w2yZY/S7AZRmLojAGNNWxdLXRAd25K8fnXN1R+V17aLq01IkYU5CVMRmAe6tavYcdSdcVWiFO5wepzdg28QG+rlE/pucbHFoj5tQ7AyXZKfX8Enb9JPj0dsw33h1Mbji1XYKc20wm7StShRnfhHszXb/BWKlwF1IgQvsZZ+XGwDPuYyoTRfK4aWqO3uaPZKDcR9YTOrsIbqTjPNYYpCJa+PiNW/rc/8bahiQWPoNC13NRjNKQ+JhIIk6DSx8NTh/FV6EboUO1U3J+SZr/VllXcxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3rSOi41WF3l1f6XmbGcGJO9pO2XCE2Lt6XcM6NClm4=;
 b=WvYSfg/UiySWskda4ijZ3tK/PScPQWdYkp7BjWOTUnb1xMpUlpavwAxkiS9Wt+G2j5E8+/IhUulK6RGakIQCTmXAq5V5zjm6nogxrtCVz0Q7xcG0wQhVCGoovWEliw1CfUEFlG51pWLusRlx+fnkNBxIR7oi7S1HEsUmpjZYXQ4pMyr+RSZpINvpqjNrEp5l+ZXNdbKXkxlQTQYW4vXWBfvGkd+dfFY6ps1up1LhRKq4kvIESczAfmTtc7UVCU6LzoXpJkesaNCo9b3c6XRzmXI1vHAN4C+GXQRtN+H8i40AzjLbO2BY3TtHEedTyQ+GMa1twW4Tj6Dkv79EvQdiCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA4PR11MB8915.namprd11.prod.outlook.com (2603:10b6:208:560::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 18:28:37 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%7]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 18:28:37 +0000
Date: Mon, 13 Oct 2025 11:28:33 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <nvdimm@lists.linux.dev>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH] nvdimm/label: Modify nd_label_base() signature
Message-ID: <aO1E0X2a2r8u8eF-@aschofie-mobl2.lan>
References: <CGME20251010115115epcas5p38e28cf5f049b021abaf0b56ffff89788@epcas5p3.samsung.com>
 <20251010114938.3683830-1-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251010114938.3683830-1-s.neeraj@samsung.com>
X-ClientProxiedBy: SJ0PR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:332::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA4PR11MB8915:EE_
X-MS-Office365-Filtering-Correlation-Id: e90323a2-0bcc-430c-8e47-08de0a86530a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/8wWD+927qKWDd/dOmUHAW67l36FByI0cr5aCr2q3cK+cKBPB0t2UKYmFb9f?=
 =?us-ascii?Q?7lhXO9yOfxdKSUnTqOP/sHzH4DIHry7VUciut7PJ2M7IdRhT7LBZZMauaixG?=
 =?us-ascii?Q?xPoIK3lYDxQEw/dtw5PphZha1JZ1P4p/kkffR6kSUP9dyTbIY56YU8EFQ6yn?=
 =?us-ascii?Q?Nb5yOrLehkjqhBguhDFYygebeZjLigl6e/2HKENjLNteY6BCtyxl5bVihAET?=
 =?us-ascii?Q?10Nu0kH+D9aoV0UeFk+SjXyi9nYnyJLAqqJaL6lUVqVhvQuZnO2QfZOCEz8m?=
 =?us-ascii?Q?Zel31xSdfzlWpSM0lW+NuDN/41Ebhtc8bmZJO7BmPY+OkF7TKZFH1EB8AOd3?=
 =?us-ascii?Q?Hob93/s93d6hhFDkIgfNio/xCL+YcJbZSBIGBPFqoCWK+KvkqAv0EaAkikwW?=
 =?us-ascii?Q?iGpvCOWc6jlr+fCNyLK9OzWgLzYQ+rsOyPJeBmhTiR87R6F0Nmn8QAdQ0Z0C?=
 =?us-ascii?Q?ij+CDkumYyzYLUcSIbGaZ/v2jX7isVpDlBTtxPVgNYwZ94lt1z6jnDE/RY4N?=
 =?us-ascii?Q?f/yvYEIOKO4C2rgwQsFBlyl6vG6SIyegwfh32tpEe2vlRw0SpBiC4aL5lnDA?=
 =?us-ascii?Q?PXSPZUhE/+nMB2D/yITEsuxl140NWItx1Vly2RIAWhTDdfOrjzpWg+KvS5pc?=
 =?us-ascii?Q?+fpurwwvVgubSZ7Vf3dWsiUD0FV72tI5ImlAkgi36TWTv/QHIPAKubTxO4Kk?=
 =?us-ascii?Q?D8KytwU+TpEKJ2jTmO98XwXcMRUZiMaMvhYtCVHtpezuWIPsgCiCG4UEppl7?=
 =?us-ascii?Q?MfHJShtPMrj/JrWB4sLaVWyeW5IeZHFpXsp4Q2qxf+BLJ5y8LrO3I3eFhnN4?=
 =?us-ascii?Q?f6x5HtBCOSM5wEFG5bMrB+YDxmjC+CXpUG8nAVvx6S1ureU2eS6K3IM5SHN2?=
 =?us-ascii?Q?2A6+WGX8IdtPQPCdpNKdOrBvb55CSQZMssWrkSPsJN+3HmtuKpGIbKnrs5tO?=
 =?us-ascii?Q?F0+HB6bogSSC9Xn8hsHas5Y3CbRhHWl+QKr7qOGAK0Eut8/VYINzfeHlr/mw?=
 =?us-ascii?Q?uxq7AjnNzIef+aOcCs60HSGCFFo02ziDopYekaK1Cj1cfkQeoLnrv02noXqV?=
 =?us-ascii?Q?XAhYanztUvwAzZdXJLo4wrD0WunVPGt8Rg4FJ962l5PPdwt6fsuarDFLzgNx?=
 =?us-ascii?Q?KVCG3cmbMlDJbJJJpaFL3ezF3jZYYPzjfBV3OdW1qLjKW5m3D82LaQ2TaYcp?=
 =?us-ascii?Q?G4r40S//RoPF++sPGauU+THvElVA+bgh4fG3TnOwuSYdXKY/lS5Q/djkzy7A?=
 =?us-ascii?Q?a3hjCjXOvCTUeoZQKNxSdOclJ1nxiLFdEuTw0T65dkr89YTEwEOAz5tZ4F8d?=
 =?us-ascii?Q?b0JGcLSiXHSYpYkZE4Jg9CkGGfKi7bI3t7iyhbJSisHTa6bz1YIv0ZOyeSRf?=
 =?us-ascii?Q?Bxic15s9CkpcLa0DHcD28YvNH20RmQxlMyoH1cHWN/VJaVIDgE6Pk4R6X6LR?=
 =?us-ascii?Q?XyXK7Wx/+Zr7efISZ974orWfzw38HKLcG75hqJ5grlhJCkUVwFihXA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WiBHe1aACuK2S3fh3CgmSgkG+8XkrldzwomJMnb2JZUf5MiwA2uqdlHLrjJN?=
 =?us-ascii?Q?0SnZLQlM4cYeevx/eNgKnVxLXihMHpF3QovV96Dfmj7ktkOyIWeIKfil/u+P?=
 =?us-ascii?Q?9MsxJAdH6X6rCB4s3wL1B/BS1/Hol1wS/daMwS3aiZf6KbvfJ49AfdU1BsWA?=
 =?us-ascii?Q?u4YU1+fyD3MfMPwR1YyicosGuudl1kJ2qZpmjqBELZx39oqC8ap5e+IosYLf?=
 =?us-ascii?Q?9dvm6HI5mRZkdIYs+jITkMPZaiknPD99DLEkTEPgTFdIw1SyvO28F+OATMZ1?=
 =?us-ascii?Q?WFfCfoWDPz04T3V1PthWjh2NxCzVwW2gMJ1YwTWfdpuniAvgURALd/QRn+fn?=
 =?us-ascii?Q?cN/CbcEOVa8DNX6SNuFa+Uwc0URREvEmcQ3FqL0b5OGvVq2l2mHRpQ0ni8jz?=
 =?us-ascii?Q?V5xAMasLObjvOY0x7qbXNmOr5fBIUTTYQQPODd7OOzVJLO5KeoSf4ZrR+Iwh?=
 =?us-ascii?Q?UiI91eC9Jo5xAIADbkIyuYW4cePVuYeNobylzfGhC5yRg7CnKai5gupCK8MF?=
 =?us-ascii?Q?v1WRgSMZS7IuGfyQvEflE1qot5p6Ki4ipQIoMtptpikfHj/nCxir7v4wCcS1?=
 =?us-ascii?Q?CA1zPO1VRqC3rfQvNEYbmIXDAXtK0Or5xTFawkG16BHz9TL2eBiL18gmjaH/?=
 =?us-ascii?Q?1BrgDA6Se8kVE3StxWwGYSaKGwwc9qBZb/zQ9i5jYNTIGnCetQZqKH2B9vq9?=
 =?us-ascii?Q?eKh2CAokQuAKVUmueBfjLH7Xr/MRf6/HLYefbTpJuxyGX1kplMDv+T1llkRl?=
 =?us-ascii?Q?GY8mHHOsU1zH2u48UDtl9tCYuCIqSWQb3MnxCSH4qjrMrfqFevQ2L3a+IM47?=
 =?us-ascii?Q?rGANjFusObLRNXkV+1m2fruJQ4qLHX1MOyIqY4O27FFJ+mNN/HmvTShxC8yU?=
 =?us-ascii?Q?VL9YSv97gh8lMaskSNVFrjOw8Q+s+fdUbELYzQNezjHG8vxBmy67uWOiz56U?=
 =?us-ascii?Q?tRuVUWk/aERtIsUukaPJXmRlGm9e9ilfgbp6DAG88FN2jjpbBVuwzI+E+iUR?=
 =?us-ascii?Q?G1vbuKylPPgE3+ycqbkoazJV6wRkNBNswEUldK01UBYf+hl60mPNzuIdTU/M?=
 =?us-ascii?Q?mPXob9wSN8Jukqxs88tu+piKA77xKSomNBTTaiJnTohrwd0lsi4xhshgJTJ5?=
 =?us-ascii?Q?ylJuMqBwqtfHsM565RxxI4S+dOTdeJsd23p2QVZ2MSflJ8cxhbKQx03EaIDb?=
 =?us-ascii?Q?brDgXf1H2Q6/0agNTmGYa+xMsc1Yswq+XFVs+A4OHZx3KbV9aqnhw8i+C9I6?=
 =?us-ascii?Q?5A4IyiLs3a6j6y0wmOy5/FZdm6rkthOU7QJbPaDwqdqeoOncLCvkIGlVFw+n?=
 =?us-ascii?Q?28SJdAq8AyE7yX6d8Ue/j2g7i1t1IuSjVHC5tfiuEAhKAWIAnfqL9+ZrzuhI?=
 =?us-ascii?Q?l/oSOYjoxpzIHh5AAcvPH8PR4GMOQHoLuwd4AdFklbd49sgvzYVnpm2psI7s?=
 =?us-ascii?Q?Tr1BiRjpwaKlxI0GtZeiz6ioe8CW0A6SY4qU3IQoiZEfTx7djLyEBIsw4one?=
 =?us-ascii?Q?0Lk59aJZ58Oql9oiPF9im2cY84cTdR75IRVpzUNRRjXC5XzuoVe5ph0F8Re5?=
 =?us-ascii?Q?r7t+9SYerzneEDoqhlZq+CPrzl5HmFoCoPbpsjeb198TA+Hvxb6+NsviFevU?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e90323a2-0bcc-430c-8e47-08de0a86530a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 18:28:37.0649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QVTFDOyiJ/muZ72Vc7phTlRUHwWL8IhRAg44KuJQn8WYZbWnAfRnYT/JFDd1c1M0wUD7I/gzAVaiupdEoVY93uyu+p6R9OM82adAR41dA3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8915
X-OriginatorOrg: intel.com

On Fri, Oct 10, 2025 at 05:19:38PM +0530, Neeraj Kumar wrote:
> nd_label_base() was being used after typecasting with 'unsigned long'. Thus
> modified nd_label_base() to return 'unsigned long' instead of 'struct
> nd_namespace_label *'
> 
> Link: https://lore.kernel.org/linux-cxl/aNRccteuoHH0oPw4@aschofie-mobl2.lan/
> Suggested-by: Alison Schofield <alison.schofield@intel.com>

Ira - Please drop the above Suggested-by and Link when applying.
I only suggested the patch be spun-off from the pmem set, not the
actual change.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> 
