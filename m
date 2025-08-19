Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19E8242D7D
	for <nvdimm@lists.linux.dev>; Tue, 19 Aug 2025 15:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755617838; cv=fail; b=APHioLIbJLVYjOurdt3nAxxwO2YhczEvp5BVU1DV2qFxg5XdnIPg7O7oYpUulWmtIf//vccjnltxq6j1+3gxs47/RX+oofPytquA1r7Jfa11C1LwKowK+UYvxm7Z22OuPE/e3HSZ9evAKO9AyMOABm5n41Fn91mNbcwKCKVtOqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755617838; c=relaxed/simple;
	bh=Mxmkr4VfzIyyid7aRKrqzo5lZpWx1z1+yy7JSZdrKT8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LWImLEuVd5yaAk8LgHPx+20NlUHDeYYRuLpX0b/0UQKzMkT+0+eUNFu+2Jc955bjPa0kxubeBvVWNFrnYdnwUZFZB4YzjpV4HVHbYqgZLHQfzEcbxdhBODCdIxQC28zzd9KOvBMc35x+vCXfDP1Fr1ICXMWZaZDlVf8vg3r+mgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fifzg5xz; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fifzg5xz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755617836; x=1787153836;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Mxmkr4VfzIyyid7aRKrqzo5lZpWx1z1+yy7JSZdrKT8=;
  b=fifzg5xzQFDia1zL8g6MHROmxAYPdlMWTuAYhgZ5gZwz5N/XwXFNBq0R
   OdYRBN3GsSLbT3GZrPKXcnr7/x10m/MKNqGDVaDDWnaV6HyLJHtn+YDPG
   3/Pzfh/PdPQPEM1ASQHCKpsLKhaKcEdmOQN8J2/GJKDbCsp/r9iSBZ7Gt
   9J8xlJgLXBdxGpIjkMr3pDc0+p0LpcRPxhjzUeJAHiat9XhLVCay0rag4
   ZvbbOMpekj+ZT3Y0oBJ8FTlXHbH1/dd/fmQIUltgMZlyb/oqCKN/WNBbA
   f0fbZvwkDgonKuVr4JHpRuqv8L8SVsDwlcFBkh4Wfb8UM+Qz5dgfGgHMp
   w==;
X-CSE-ConnectionGUID: SYjLnsqbRuONEhx37jJZ4A==
X-CSE-MsgGUID: Y7WsM5iRQtmJpVqp17Q5HA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="58013864"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="58013864"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:37:16 -0700
X-CSE-ConnectionGUID: D27xTSx9Ram378Z9+Syn2Q==
X-CSE-MsgGUID: m4Hjg5rDTbOjFRpsMuT+7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="198884871"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:37:16 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 08:37:15 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 08:37:15 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.47)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 08:37:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ev2e9ya6Mp647fsPutu4Iox0VdcEyqpGiZ+tNH7n05TEVVtB/PN0zWDTF/wvrT4cLY6wFOfUqL4eSNcLVZRGSevV+NkmZ4MLVRvc2jj71NZB0r7kSwWW5g29VQ7qPj1/pUsEej5MPQtsyCGXeLW1ch6tPNSbF/tF5YBJgCIRJcz5q2Yk4OW48hVAgFoWV3ddEQE3jYI7a0WdR2pLZ7LOJ8fARNh4CHBak/bJbT//vcyN4kLqUX/63viF10q7x5nLwmTSo01i3ylu3YoZfYpXwG9NLVxdE/LUbkBEMswEFKAG8QbTNOw/g9r4OPRMWdAO13sTZECnncSt/v3gp7Bzfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtfeJvKy0p5MKmqHVX6ArL6BYgUX2Jo+g+D0Y7DW5q4=;
 b=MMvO2QBSNwOLyPkgGMYw+UXI1O95VTA4NkHrN7ucT8DYQ2e/iZH/+vPA3/D1vmXh/gWid2F3voR8af7dJeWKJMC9Avo4BJiya2GIUX/l/Mghd6J8tjt9zd+1xUL1HTySrs2tlCq3EQzJIynzzIpNLBTSQQhbseaySXpdF38MQda93bRVC3RLuVAnufmhkVHM33aQXEtA5/IFV3/tp+gqq/P/PHwaXlKFbYqOHYzkmAH5BSJe8vtJvVFNVhef7bcFZzl+EuJ8V8Dgd+/BsoRHt77DpD1gPDoGlGtiL2uhbAyNPM8TkCWOj42wgYzgtCe3uQVTs6KNpG5aC1tLQXqXsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH7PR11MB6675.namprd11.prod.outlook.com
 (2603:10b6:510:1ad::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 15:37:13 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 15:37:13 +0000
Date: Tue, 19 Aug 2025 10:38:56 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V2 02/20] nvdimm/label: Prep patch to accommodate cxl lsa
 2.1 support
Message-ID: <68a49a905dd78_27db95294b@iweiny-mobl.notmuch>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e@epcas5p3.samsung.com>
 <20250730121209.303202-3-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250730121209.303202-3-s.neeraj@samsung.com>
X-ClientProxiedBy: MW4PR04CA0205.namprd04.prod.outlook.com
 (2603:10b6:303:86::30) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH7PR11MB6675:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bf8b4e3-b89d-47fe-4e9c-08dddf3644c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FhnW5HJICC7XV7GUp03lGUgHIytqBRA/g/2g6MFCRDLSm1hda27WPLxG470t?=
 =?us-ascii?Q?PPQulIdqWvyoJSrXLX5ua+xD2ZY4U2PeiPtPAgoB5WIpgxSW1+88IFfjiAUj?=
 =?us-ascii?Q?ihXpuxYpyEFYv+ktCAynLyUTjpPK2e4g2SfQn3sUosLVACbpNDVlMIMz+80I?=
 =?us-ascii?Q?yj4XELlTw9KpbEAF4+D9e3L6b/+xDDLayX0NXKMtbp4nqGLUvdgcuscdM3DD?=
 =?us-ascii?Q?U2umLgS97qMtRa10XoQm3hZN1g1cstgocrW2gDe/MISJbRAzgatva3yOS1VP?=
 =?us-ascii?Q?vN/he0lzd5hv20oxA0jYDbqfxYwtSLpP2Ee7SQBAhgifeUUNoBlUxpNpHtTb?=
 =?us-ascii?Q?NhUM9L0IeoNDBSkvfE1zbWU0rjcDqApdrKSepnuJ1GP7DIBnLBSizWMMuIl9?=
 =?us-ascii?Q?dravzPAvKBvBw7RItk4LkPe2muQ2+47QaPFAqgt/freBEvOIkmhiQj3JaQtz?=
 =?us-ascii?Q?uGKlSLqc3CF0USu0GCp0VgWzAWO3kbbmVXqgl6Qe0dtpEr0COMkFJrqCPuk3?=
 =?us-ascii?Q?3ZAvTp7VcOhScHvnKoEAk0nfOY867PNZR4Sg4eNTSABGbj4u/VnRdgWEt/r/?=
 =?us-ascii?Q?TbSYUL2xXuddeT5Mo1Bo9jO6BMBkJiDnjxaS7pHY7qNyiDnNmy0eyYY54y8q?=
 =?us-ascii?Q?VKMbK0pbL9VL+EqDq+dpSxDGfkI1Qjxoh5PL5L6H9gzaezI5IHIbAU3nvD3i?=
 =?us-ascii?Q?h5C4Swttjfxr9WIKvL7Ta7k8e4azpKviXeEWAswITYGC3PL+tGN+NXfB0lgH?=
 =?us-ascii?Q?BJ2BcyGvArMl58wBuU2T3TCYmhcm536ca4JT+UH4/nC1+Gaq+7XzPCWaZ76o?=
 =?us-ascii?Q?4te7GpSHnemz2dCNwDIOXPiHNyCTYLLPmETzXFhjdHM3nKOvmMGEfG3HOx8X?=
 =?us-ascii?Q?ZLk8VLK/H05EI1WYw6sSDwvejWLV/B2OSF0s4tinO7c/oI1LqJyEF9zUHjXJ?=
 =?us-ascii?Q?qN0k3fFtWakDvRCbpWBM+v46OKVurCdQ6mFBq7mFUxB6BcX3kBD1W+IuIMNM?=
 =?us-ascii?Q?ZJBNnNxGh22q4kAkERz8QV/nm5hFtxsGvGi+evNN2gayulDKtn6IbToJ0mRU?=
 =?us-ascii?Q?A6Ggdhi6t/v61Z1zCCXF3qgoZlZWMe+vkGuK9cmweM71xp31++caC7DkPkYC?=
 =?us-ascii?Q?ZsYjjd+RE5+EqlexIMB6PfnAsqe9oK0WJ9A43e0oJDMKKIsHHBsczxoUW0N+?=
 =?us-ascii?Q?QaT+MTRMkKrpoWuqOHmOppOTVroVc2U2EWgzPTDfzJlSOM7xMYlubmAH/vlF?=
 =?us-ascii?Q?/tuV0QrdPuZVma5goWrateFNktaXUDbaieRy3uZLxGlnwTxynZZq8GaqxoKO?=
 =?us-ascii?Q?i5sGk8EeBM+oj6smToyU/C65AYuCffuCi1i1TZepO4cN9W0lWb+pRFuNtbpE?=
 =?us-ascii?Q?dpr85nxd+/4pssKBSuxFJxwAYoMJoIDXscR4+pS4WqSyTL5XyH0ISSzcf6l5?=
 =?us-ascii?Q?wS96deRE0jI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?noabMyiA/LxU6lscRrD9VpkFtABXVnM3pa0ABndmwvQV6V12yEKzRAww9Apd?=
 =?us-ascii?Q?b56pKDWOK/UYPPFOTlycFD5D7G3aTFwiN9TpDska1m/fygqJVnkC9vxeN0Z+?=
 =?us-ascii?Q?HcVd6I2NmxHsBlZjRZnaBMeQAf4fI4Nf0z1mhyObqiwOiIqbRcn1ahsXWZ2Y?=
 =?us-ascii?Q?yhXBFxKJGJT+5FR7olPvsQGBaBVuMJN9f+b1/KyN3PlDTIOkB8vRIzpl8QEB?=
 =?us-ascii?Q?p4iV1VBrv/P1DKR1gEn5np5KbtHFRplQYdGyW/XQmHSNDZhkMoEFhp1a/KYc?=
 =?us-ascii?Q?/bfCXpC/R/zuNqrQDKKyBNHw/8ZXuOrSlPpEGExXYeIxMAMM9gxO6BAy0dc3?=
 =?us-ascii?Q?4oICHtqo1Zdu8xh24qHaVjWPBm9OhXgTCSxw3xrCk4drKXps8Ixd6vH1Ht/2?=
 =?us-ascii?Q?jRjzsd+7+DpjpHSFMXQybUA6KF5sJAxqWdxwzsVgsHwHezRW9BfIQy9bAWBN?=
 =?us-ascii?Q?R0EboHdrp0zOkYYNvuetbLYjnRTyPSL+4tgwckYcVlWBDX4xZtn7xv11nGFW?=
 =?us-ascii?Q?mVxwkLeZvoP8wIuLlIK3Mov4zK1tHyvmvYzOQGuWS5rpDQYSg0QUi27OkYO+?=
 =?us-ascii?Q?YZMt969EZ2zsjBrlQX2AYza07/LGAtnZ+8dROyuTsVxHDwMd5ArNmmycsPde?=
 =?us-ascii?Q?fP/1uOJe3XT7E/DO8EYyNdBdmTzXq4FvOKZgHUmMQjR3DjJ0Fsiclmvhbc1Z?=
 =?us-ascii?Q?N6Zsu+xHkBNDinc7xv+T8qS01A5pOr3P2w5n/WLqy86JG7PAre7byCpN2gVY?=
 =?us-ascii?Q?c4norMdGbm0yDzkEgNkvQUlYrjAYUzIcD6j8PQYVmIHlQ0FTK+MkFoHQOZun?=
 =?us-ascii?Q?N64cH/RockIL6U3OEA06AxYfIEwCefdI4jR2ty6u1LcjxWUp3zapTGGSuXLi?=
 =?us-ascii?Q?5AGOeXS6e1qWUFekjkziJWVUOTR24vzrXO5kRrQ7+Cj7PY3/NR8L53bvm04a?=
 =?us-ascii?Q?NbVd26xSNMo9JPY5K2ywnG1gbv2UIGeRHJpdz5XCzaCH+5AfwmlYnc+qY4RV?=
 =?us-ascii?Q?VqJMf6PXLMRLeUOWhhx21XoDTyMRJuTRKuDk8MRL+aF1A5vCi3XB5s+3gTiD?=
 =?us-ascii?Q?jTRHNl5EQfcHLa8/DoMLYoyI09zhbqrU5Cqw2hIjzhU/8xWdvOnpRC8iwgaT?=
 =?us-ascii?Q?ZhodjToXCUPDIs5hEYjsxSj07pe+cogbDVfdRL/iZ+7JV7EoaXdB5FSDeFMo?=
 =?us-ascii?Q?cZSZGeH5wXJv0XbXyb8WOCk08MCBnOCeVujUzzC7y/uj3CW3bYb+z8BSW+q6?=
 =?us-ascii?Q?PKhwQtELLTL/r/aa7X3caKEQH7D8hwLrc5gQfGXaBnZ3VSO+F8VoL3WC0MQ4?=
 =?us-ascii?Q?DcExcWJcDuLMS0IzFSn8CX11JCMtzQvUPn4Tjpvsf5uex4e5WhgpYkWqUjq1?=
 =?us-ascii?Q?ZTTXBiT+z0hUKIwnde9XcMfcoZkvf2Yl/VsU1maMBJAuvaHIVTKXpdd9EfGz?=
 =?us-ascii?Q?RZgMScSr7CrqRtcrSNO7KZF7jCt6nznDi7C1VbaEfCNNV4jUul+53gTR41mO?=
 =?us-ascii?Q?ZRvfJjFMbAI4Fep2ZzjZFJh/L5/dSvDDd9YKz+mmPe9XJOKApX6UdyRI60Yw?=
 =?us-ascii?Q?zqlDIe2iAtYdu6wiMM9kKEsTeQ7kf/Dg0k6nJioU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf8b4e3-b89d-47fe-4e9c-08dddf3644c8
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 15:37:13.3514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KkwpnZWzyyI3D7AxI8cIf6Lu8e4S8WhnBWVZQwr6t78ZpgeYLXJnY5K9WxQo203MYny7Ny7TIHf1ipD+EN01iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6675
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> LSA 2.1 format introduces region label, which can also reside
> into LSA along with only namespace label as per v1.1 and v1.2
> 
> As both namespace and region labels are of same size of 256 bytes.

Soft-NAK

Having 2 data structures of the same size is not a reason to combine their
types.

Please explain how nd_namespace_label is related to the new region label
and why combining them is a net benefit.  This change may need to be made
later in the series if that makes it more understandable.

> Thus renamed "struct nd_namespace_label" to "struct nd_lsa_label",
> where both namespace label and region label can stay as union.

For now I'm naking this patch unless there is some justification for
changing all the names vs just introducing "nd_region_label" or whatever
it might need to be named.

Ira

> 
> No functional change introduced.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

[snip]
