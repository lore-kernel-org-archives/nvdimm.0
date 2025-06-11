Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD38189BB5
	for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 14:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749652351; cv=fail; b=lAQpiyQFDgFi2jofIvA4Me250yE8yRjCXPfxv5+Dum7J1u/ljniqS46TQF6tQC9MOaCDokViAC+A1+dTmy1Yg6tN4QEJIepZmSueLqykOMwQJC5TW93C0Ckz6caPee+Rdo3SLGdanf73+dw5H8VbkLRI5gl/V96LYWI4QhOhDls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749652351; c=relaxed/simple;
	bh=etgpiaQI6N7Qw/lysgdFd9XVvTVGZ8yn6fKLUimzNy0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JdJDf4kLLwQ0eAJhpt4JcI3zihxH+b9acHl3NyH7N2Uo5PrI0nEwb5YCH9/KQHjovE/cF3W+bpMTIMXtOoocSBZ+Cljb1A9AsMi3RKktl4rK0EoqGj69MIdSyodtDHo0uBX4sWn3b35wjGw/XibDPJDbxElC4Zo+3uxbLbrkWV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bQwPBfWa; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bQwPBfWa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749652350; x=1781188350;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=etgpiaQI6N7Qw/lysgdFd9XVvTVGZ8yn6fKLUimzNy0=;
  b=bQwPBfWah31sRqWH+zcWpTeXLen7Uo/BgnVXQ+1XUyOvpvubdh0VM1by
   4WfbMtM9rsnBlFtBHblu1fER/gmaW+4r2mq+X7MzEsB18sq6f4jH7YZPZ
   CEfdeK+tjfL+0mSD0MvKQX1WjY0iVm6pu/w0G0JHhKMT4agmXgue1ONbl
   DA/0cV3NMjmOhLccALFMHgpwaMoAS5RCZbXB8Ekgl4TOBo4COL6lp3QOC
   dSV1y8pfgOc4mJkiuhHo01nRMpTp6RRB/OX0OqtKC/Mn4m/Rz/8SkOb4B
   /ezaR6zVAmOR2qMktT7onEd5PeMDKui/X1qzUSPA1QAQbu3QLSvsZI7u7
   g==;
X-CSE-ConnectionGUID: ri5Q8AQsRoCrk0MZYTow/Q==
X-CSE-MsgGUID: 7FW6m7JsRnKisYVRnAtLwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="62409365"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="62409365"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:32:29 -0700
X-CSE-ConnectionGUID: 4mB8E5YGTNOIRCbyUdkHXg==
X-CSE-MsgGUID: xKopCyxXRsmXE8gmDZf5zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="147095251"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:32:12 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:32:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 07:32:11 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.76)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:32:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eTSGZxg2VoliYQeODtaoyCrERmUIKM7NqeMI+uwVMZ55LqjPhzn3iyAUbEfHyxr7s++tam6iwSM9l+XOJumnrYapFUZkuucAwyCJd1sK4L7mJNwNEf+x4K8Zua1pjAp7mCq+ggx5Rc5FBK8y3x+LC8be0pqQsj9pZz/1N0fy0jzf7U+c5RpCHd+QIIpaTxda31F8TuEqVJrO0TFhfSA6vPoKdGDG50PauQx5KnfJG8u5oHKgTGbtFGK9HNBOl/9rey7KZiwsmhza/+ajADLPIFAKMtezzMD+3tidKV2c/fr67Hlk6m0mmbIMfkCLSu74ThzLWQmVeVfy3ahx5b89Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AdncaAFuMKMg/1OJK9BpBzkAjfkQaUdxXJ4waZnq0IA=;
 b=PvFn0cwHTQojEO7p725xBlNE71HHdbD9WLy+7/pKjoha4wxwhab/SkWabLQoEYxZOMPis2EmH0xNkebIxpPop+IgjLIOcC3rw3KUzQHrl5ioZUFFOeB8oNuWXyvZ0MydVCECQ2nEeRcbFd0fmHlMg3+i241OxR2SuUB8+H4SzP0+yFdcm6nSIOiW0AGcGnBFfwVtmfrOf4bfMJ1svpH+wVsMgweW9mxPdvztefSuhdgPJU26H111g1G4cVb47No6T1rfqdtCSnDccVvSdJAKjH7ntHBkgiEU+ZzILviYCHB9TRElobiT61FIlacPAAdui8SpNzQ8q913tE3kKuzbDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by MW4PR11MB7125.namprd11.prod.outlook.com
 (2603:10b6:303:219::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Wed, 11 Jun
 2025 14:32:08 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%4]) with mapi id 15.20.8835.018; Wed, 11 Jun 2025
 14:32:08 +0000
Date: Wed, 11 Jun 2025 09:33:17 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Drew Fustini <drew@pdp7.com>, Rob Herring <robh@kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>, Oliver O'Halloran <oohall@gmail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Conor Dooley
	<conor.dooley@microchip.com>
Subject: Re: [PATCH v3] dt-bindings: pmem: Convert binding to YAML
Message-ID: <684993ad31c3_1e0a5129482@iweiny-mobl.notmuch>
References: <20250606184405.359812-4-drew@pdp7.com>
 <20250609133241.GA1855507-robh@kernel.org>
 <aEh17S0VPqakdsEg@x1>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aEh17S0VPqakdsEg@x1>
X-ClientProxiedBy: MW4PR04CA0342.namprd04.prod.outlook.com
 (2603:10b6:303:8a::17) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|MW4PR11MB7125:EE_
X-MS-Office365-Filtering-Correlation-Id: a5b6dd23-2572-41bd-3cb2-08dda8f4beb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YsKGG/FGt/dTjebsxOPpjh66e8z1EELbl81xFa/OJlHZYiAQffZai0qNzCPR?=
 =?us-ascii?Q?gONhzO+l8vzZqjE9ciKai4i5qYi5MKxSAYBnmEKOwxw/NuMLak0QUE1FGm8R?=
 =?us-ascii?Q?5JPOQIoNUyKTaY2nLGWLP6b7jTSutob98JkbCsiNokKJO2dF6eWQpxI1HBBa?=
 =?us-ascii?Q?BNP3NSeh0IFmA5jooZx3pZBBqOaO2ltrQd544A7gbXgB80cbER/oHpUV58dI?=
 =?us-ascii?Q?y2W9EiHwEhEVCUgawDb5140D5vNGlK9n1cJxSx3NiyCEnhdfFduqJ2nmXPf5?=
 =?us-ascii?Q?87MVTicVwpFSuY4U4Knh6hRkMOlibdlTkvLq7k6dyGSABRcmHIYInTtrOyKQ?=
 =?us-ascii?Q?lrmFvVyzfF2fj2aeBPH5lafdOPS9LqpgFgo/tlZgRSJbo+QnqtMqVuD/tj7l?=
 =?us-ascii?Q?aqjhYF15Hal2knOBKQlMalYM1gEpQ/3GpkJhZ0eqKN8XQedxwXSHaQ6bPjsG?=
 =?us-ascii?Q?2y9f726bd156V3k5y2isk7WLam9aA7iFDZFl059G8O/Cx4T088CoXsQCMUmQ?=
 =?us-ascii?Q?eNhqMeP+Ms3Txho0Xvd+MK5o+6lkHJJphrL9KHzMGoqHD4dHBXtJQC/xTwKJ?=
 =?us-ascii?Q?braCBpdxESqRxpo5pG7RIPd0YsLYCXkr6lNQRYjty6UVAcf/wjuQSKVQwuaj?=
 =?us-ascii?Q?vg7ls80+OIpKNF2uRsPLUxZeLkduJf97I3iIF44mCnnsih3rdOIXTl0ice9H?=
 =?us-ascii?Q?T+X/TbplIOBHQHcnGdruX2fArWidRQlf8689bKJCiHBuuPg+xMDBFQFCzZBE?=
 =?us-ascii?Q?sffcuxjz5DFbH7PfSO7KWOAXBNCPwfYcLXX3sfmShjDOBKlXPHAndieMgsMy?=
 =?us-ascii?Q?6clfm2WPNeCE25mCfaiDSEKw6ch3A9vGbePwvdAI/uTaF7RYCMCwvAEYos+E?=
 =?us-ascii?Q?0mnqmUYqZb/P9iICG5BLNB9WNNivpHKq0+8EAyx+iKralUCylSyK/K/NMe8m?=
 =?us-ascii?Q?ky2HP9gBzN2FibZRtrcJvvJ9bcvklgWKN8n3PPXY8qPbadX5IGwL4yc6Bn+q?=
 =?us-ascii?Q?W+4lhH2ageXjem59r2UTiprJQEpXUd3NEbR6k4Ubb0Sg6IVkENzkf6SB86L3?=
 =?us-ascii?Q?MuIgJlt0en+yQDSz9JxCV7d2I+u0ZDQZIGlrlrlE2iqzXemU6yntWtVuvz8+?=
 =?us-ascii?Q?CQ+NHrJBTGFznAWkQEiJVd+v786B0kcx/hy9rCcyAbxTbVUnfHVLQCgpn9Po?=
 =?us-ascii?Q?IJm0sxS+Hg1+hnhfj7ekFg2TB9BuxyA5KKIwRJw7BVSYLyj7SeDFq5HbBR1f?=
 =?us-ascii?Q?c38Hvdmeq8+G5tI2/f7IWfw07/VQYtCFkcpP4Xt3fbMJnU5oFXOKOTWeZhLC?=
 =?us-ascii?Q?4f/amr9EkV5tm/Bpd3mBHF9AYTRSX4O5IxlcCfebKHr2tC66BSRxXYiEHdXB?=
 =?us-ascii?Q?+DAsBK7QXAj1wgZ4HKqq/6iuKiTJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m+n2v83tfn49M8ZwbcHaS1Hr7Z97S5DGoC1evPXD5JvlYCT97keeWRh+C8so?=
 =?us-ascii?Q?YiwnABd5u504kwgd3GTwVpQLtyCECzFAYiucfxgXYAv0urwq3PvNv6etx38C?=
 =?us-ascii?Q?K8Frun4/aQIGxy7/KdvE1cUeN3prw2JV5GIq3+LNe2ygzJVewEV8QXEJH5oD?=
 =?us-ascii?Q?Vn3Rx5uCaI7+wkC5ft3oFDrYsu/i3GQE1VHBaqoraW94HZ6jChg3OrZ9YyoG?=
 =?us-ascii?Q?hjKXVjdUJ7DE6Q7TnRJsHLtpW0sjJT1O/ZsyeRIu+ooFizho0TInKLAXSSLj?=
 =?us-ascii?Q?j1UIuxmibDnRCW3otjj6XbY7dgUfwooJdEaWDnTivfEwUxqZ4FRCg2suiazf?=
 =?us-ascii?Q?otGuXRdt5lbbfyUxGG0DcNtrpsS0hFivBKC3LKg8z6giyJg08xjBRyMfntpH?=
 =?us-ascii?Q?ZSD+UMp7zkZ+DfR2yY31UdfbNFJL+b8ArIqtuKqkuMKRK5H1nv2YRuq/gkQd?=
 =?us-ascii?Q?ovNMXVItKp6cPTXxOs1oPsvefTZY3m75h0ucq3zzDMFknDDqBI2U+az2Odif?=
 =?us-ascii?Q?P0AA5PKuX/o9hIcVgPz+Tf/A+yeEgqxe/k3+lnRIkciJH+Si4pBiOc+0APJr?=
 =?us-ascii?Q?yC/kGYQTuEEHJbrYYplguvtaJJUSofHtFE6tVo3vqnjs9AkZr3CEOTPUQe8K?=
 =?us-ascii?Q?r9zCPsku1HYrzTgxMnt5GwHEqaT0r6t2SNqb/gDbtoiVqMUiHKZg5yFYd2fb?=
 =?us-ascii?Q?fN8PzHncwW/o+bTs5dhi+xqC2rqC7+of8bVr38PxQVF9rs1EEmqew2c6/gV7?=
 =?us-ascii?Q?XfiAjbaRHRmiMMhIO+ZWZm2ILwpLBjPkdDZssztAgVM3vt00F/2EbeUkVrmW?=
 =?us-ascii?Q?wmTkI8FfXf9eh/j1eFdezhWGeUPnRsXO7mVQFyD/U8fJtwBwQCVLU5oLd9d7?=
 =?us-ascii?Q?J7k0VTJzjMNIOixPmCtw3kKevNAyXAL6TWf5a3JNniyq62NWAI96TBMEHzwh?=
 =?us-ascii?Q?r6VW0NceexlQAXZwORCKWQZ6VjHfpkKfEIS5aZBmTOuPYwo/u1lNzsylQgz+?=
 =?us-ascii?Q?WntL+OZJi/4vUneTpFNvckwwZajfYFVPvojsEucztYV8czeO5C2iTZRK+KOI?=
 =?us-ascii?Q?VSrbMU55l4eQoF4t/6aVpjxAa1X6WOiNnNlHHtCZ/qQE0PIN9tKiPm4qaAdJ?=
 =?us-ascii?Q?25hfF4I/KKJuKGV1KHNnnZqtFLC1001IewUKyeBGp8lP2qnQHZ8ZSxJOEZjh?=
 =?us-ascii?Q?VEN4ENlLVCvpiMk867DLhdTdq4EY9neUIx65A2Hc/TkHO8/TN3P5/dbPLCnH?=
 =?us-ascii?Q?LZTCmXxa+TZ/ey6P+Tz7wTtj1Oo+Lhm6MFox+IN4zAlEJ4IwdzBOmtOYbdp7?=
 =?us-ascii?Q?PAgSGPgZTTSiaV15JftqR/CN637w9m01NTjccsLAhf+/7NLZBfHx9f7SZVNa?=
 =?us-ascii?Q?yTrpDsGZrDyGcZesQJFBWBpRH1bq/Ar9SjaVy0+ss2cyCLh1roG2nSuaoED0?=
 =?us-ascii?Q?CO+35v39oVptGINciAmw4wDej4vLmiE2Bp4+Fn9eizn67724n4lhj4npxVAz?=
 =?us-ascii?Q?8PlbB5DaERAbtrrQYoJkn72mgSdB+t8aQNLQuM8w2T1TeWMKD8l2/d5ve7Aa?=
 =?us-ascii?Q?g0hbV5uFsahvMf4zIdHqyabZDFmS6S2daKXXSVY7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b6dd23-2572-41bd-3cb2-08dda8f4beb1
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 14:32:08.2705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6vSTKb5Dv4fVomq81wcj+JNFrq/b1gFywP43f0TMEiT8Onn/LKk7mSRmFWKvumT+Cl1g5Ava75QlojZaZjVkxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7125
X-OriginatorOrg: intel.com

Drew Fustini wrote:
> On Mon, Jun 09, 2025 at 08:32:41AM -0500, Rob Herring wrote:
> > On Fri, Jun 06, 2025 at 11:11:17AM -0700, Drew Fustini wrote:
> > > Convert the PMEM device tree binding from text to YAML. This will allow
> > > device trees with pmem-region nodes to pass dtbs_check.
> > > 
> > > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> > > Acked-by: Oliver O'Halloran <oohall@gmail.com>
> > > Signed-off-by: Drew Fustini <drew@pdp7.com>
> > > ---
> > > Dan/Dave/Vishal: does it make sense for this pmem binding patch to go
> > > through the nvdimm tree?
> > > 
> > > Note: checkpatch complains about "DT binding docs and includes should
> > > be a separate patch". Rob told me that this a false positive. I'm hoping
> > > that I can fix the false positive at some point if I can remember enough
> > > perl :)
> > > 
> > > v3:
> > >  - no functional changes
> > >  - add Oliver's Acked-by
> > >  - bump version to avoid duplicate message-id mess in v2 and v2 resend:
> > >    https://lore.kernel.org/all/20250520021440.24324-1-drew@pdp7.com/
> > > 
> > > v2 resend:
> > >  - actually put v2 in the Subject
> > >  - add Conor's Acked-by
> > >    - https://lore.kernel.org/all/20250520-refract-fling-d064e11ddbdf@spud/
> > > 
> > > v2:
> > >  - remove the txt file to make the conversion complete
> > >  - https://lore.kernel.org/all/20250520021440.24324-1-drew@pdp7.com/
> > > 
> > > v1:
> > >  - https://lore.kernel.org/all/20250518035539.7961-1-drew@pdp7.com/
> > > 
> > >  .../devicetree/bindings/pmem/pmem-region.txt  | 65 -------------------
> > >  .../devicetree/bindings/pmem/pmem-region.yaml | 49 ++++++++++++++
> > >  MAINTAINERS                                   |  2 +-
> > >  3 files changed, 50 insertions(+), 66 deletions(-)
> > >  delete mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.txt
> > >  create mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.yaml
> > > 
> > > diff --git a/Documentation/devicetree/bindings/pmem/pmem-region.txt b/Documentation/devicetree/bindings/pmem/pmem-region.txt
> > > deleted file mode 100644
> > > index cd79975e85ec..000000000000
> > > --- a/Documentation/devicetree/bindings/pmem/pmem-region.txt
> > > +++ /dev/null
> > > @@ -1,65 +0,0 @@
> > > -Device-tree bindings for persistent memory regions
> > > ------------------------------------------------------
> > > -
> > > -Persistent memory refers to a class of memory devices that are:
> > > -
> > > -	a) Usable as main system memory (i.e. cacheable), and
> > > -	b) Retain their contents across power failure.
> > > -
> > > -Given b) it is best to think of persistent memory as a kind of memory mapped
> > > -storage device. To ensure data integrity the operating system needs to manage
> > > -persistent regions separately to the normal memory pool. To aid with that this
> > > -binding provides a standardised interface for discovering where persistent
> > > -memory regions exist inside the physical address space.
> > > -
> > > -Bindings for the region nodes:
> > > ------------------------------
> > > -
> > > -Required properties:
> > > -	- compatible = "pmem-region"
> > > -
> > > -	- reg = <base, size>;
> > > -		The reg property should specify an address range that is
> > > -		translatable to a system physical address range. This address
> > > -		range should be mappable as normal system memory would be
> > > -		(i.e cacheable).
> > > -
> > > -		If the reg property contains multiple address ranges
> > > -		each address range will be treated as though it was specified
> > > -		in a separate device node. Having multiple address ranges in a
> > > -		node implies no special relationship between the two ranges.
> > > -
> > > -Optional properties:
> > > -	- Any relevant NUMA associativity properties for the target platform.
> > > -
> > > -	- volatile; This property indicates that this region is actually
> > > -	  backed by non-persistent memory. This lets the OS know that it
> > > -	  may skip the cache flushes required to ensure data is made
> > > -	  persistent after a write.
> > > -
> > > -	  If this property is absent then the OS must assume that the region
> > > -	  is backed by non-volatile memory.
> > > -
> > > -Examples:
> > > ---------------------
> > > -
> > > -	/*
> > > -	 * This node specifies one 4KB region spanning from
> > > -	 * 0x5000 to 0x5fff that is backed by non-volatile memory.
> > > -	 */
> > > -	pmem@5000 {
> > > -		compatible = "pmem-region";
> > > -		reg = <0x00005000 0x00001000>;
> > > -	};
> > > -
> > > -	/*
> > > -	 * This node specifies two 4KB regions that are backed by
> > > -	 * volatile (normal) memory.
> > > -	 */
> > > -	pmem@6000 {
> > > -		compatible = "pmem-region";
> > > -		reg = < 0x00006000 0x00001000
> > > -			0x00008000 0x00001000 >;
> > > -		volatile;
> > > -	};
> > > -
> > > diff --git a/Documentation/devicetree/bindings/pmem/pmem-region.yaml b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
> > > new file mode 100644
> > > index 000000000000..a4aa4ce3318b
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
> > > @@ -0,0 +1,49 @@
> > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/pmem-region.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +maintainers:
> > > +  - Bjorn Helgaas <bhelgaas@google.com>
> > 
> > Drop Bjorn. He only did typo fixes on this.
> > 
> > > +  - Oliver O'Halloran <oohall@gmail.com>
> > > +
> > > +title: Persistent Memory Regions
> > > +
> > > +description: |
> > > +  Persistent memory refers to a class of memory devices that are:
> > > +
> > > +    a) Usable as main system memory (i.e. cacheable), and
> > > +    b) Retain their contents across power failure.
> > > +
> > > +  Given b) it is best to think of persistent memory as a kind of memory mapped
> > > +  storage device. To ensure data integrity the operating system needs to manage
> > > +  persistent regions separately to the normal memory pool. To aid with that this
> > > +  binding provides a standardised interface for discovering where persistent
> > > +  memory regions exist inside the physical address space.
> > > +
> > > +properties:
> > > +  compatible:
> > > +    const: pmem-region
> > > +
> > > +  reg:
> > > +    maxItems: 1
> > > +
> > > +  volatile:
> > > +    description: |
> > 
> > Don't need '|' here.
> 
> Rob - Thanks for the feedback. Should I send a new revision with these
> two changes?

I can do a clean up as I have not sent to Linus yet.

Here are the changes if you approve I'll change it and push to linux-next.

Ira

diff --git a/Documentation/devicetree/bindings/pmem/pmem-region.yaml b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
index a4aa4ce3318b..bd0f0c793f03 100644
--- a/Documentation/devicetree/bindings/pmem/pmem-region.yaml
+++ b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
@@ -5,7 +5,6 @@ $id: http://devicetree.org/schemas/pmem-region.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 maintainers:
-  - Bjorn Helgaas <bhelgaas@google.com>
   - Oliver O'Halloran <oohall@gmail.com>
 
 title: Persistent Memory Regions
@@ -30,7 +29,7 @@ properties:
     maxItems: 1
 
   volatile:
-    description: |
+    description:
       Indicates the region is volatile (non-persistent) and the OS can skip
       cache flushes for writes
     type: boolean
