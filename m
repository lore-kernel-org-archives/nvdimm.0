Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DFB639
	for <nvdimm@lists.linux.dev>; Fri, 22 Aug 2025 00:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755821450; cv=fail; b=MmR8/ogIkHbJv+y7Idmjuji+NJB+qr492CfmHe6IPeoYiQ5CooYuz1WBhl5Hg+k9dDKMzBOFW0LFpWWRNyqVkhWX6nfFUHqiZ7vr9tX2xs3ppaJFmLvRICDtHstRxiuxbMTi9TGWYFonnjp69XDWXZ53jQaFnPY++njJ+tdaL6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755821450; c=relaxed/simple;
	bh=dW0WV7DNBuOOl6hw1iWA5pFmaWcdy2L9cXdMlxOroBk=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DGrYn9pxE2dbNE8EnF9pdnk2XgmbT5rf/9XV6uqW/GmX/46ihXxur1Sn/eteX1fIDu/zNYyMnxcOWz3m8dVSiqsaFvP0TNGciaESvkIq9l3kyxe7pn7Tcro4mv/IPO/3I9SWgHK79uFgIVtAu4NBse2EA0bfMt6yxyBsOfY4e+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iWp3OQRG; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iWp3OQRG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755821449; x=1787357449;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=dW0WV7DNBuOOl6hw1iWA5pFmaWcdy2L9cXdMlxOroBk=;
  b=iWp3OQRGxD31Dmzz5RtzBTy5aXegn1/PgQAT0C1y6NfbIgdmg9fZZJ+7
   BBwu5Qj8nHslskHO5uNS+Dq7ZQh2fORFGsJQeSHouDIsaTVHSsrrNoO37
   bWLCBCgLCDQLxQwQVxxULnsxCR+2s9r2fkydYoXX7r4ihZa/p1a4rsJw3
   ALaJ/jaxJQMlFfQL4mqau8CUBcH3aMXqoFZTwIiqGKvElgeKZvcXhfmnT
   DmLosf5FsJFJX1VHinCpAeMzyY6/fS5UrH3RYAJurH5VkjJ8JJIAFACrH
   MlxsRL0/aaTD5bx9IEgakZxlvaz0K4m1XDUziZ4Y9fA0Hhpk+d1IiobjV
   Q==;
X-CSE-ConnectionGUID: RxLMQwprSsq75hJIOKbffg==
X-CSE-MsgGUID: D6TiPLmTRFGRM7KQg8ko3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="57147623"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="57147623"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 17:10:44 -0700
X-CSE-ConnectionGUID: AIr+qvdHSCGcTBif3Yml0w==
X-CSE-MsgGUID: UWekcTciTSmsj9kyBGOjPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="172962340"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 17:10:44 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 17:10:43 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 21 Aug 2025 17:10:43 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.58)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 17:10:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aT75pzo5pqI9g2fqm6PUv+pa8iqhk9OH+R0WEhZRQWYu+8/82dMn8kwDD2ao0WHPwDj5yK8W8wLvnX36xRABp1WdRJfBxsnHnlhX8Bd77OiCaI9eClVKY6oqf50PDgmaf3wscAjh7q19Dj7LwpJdVPYpXMCYYe6DPExM7bMNA7pGMXrUVYNt/7cx6z+JAS9RDdMaQr8It2XlOLyESfiVh+jIMzDO40ozrR0Ic8OtqnucGHfYI1Ph8bKyLBG5vs5CIY0zSukN+eq6W5qWWaEcMaocn/LNFhP5XDzRrobd0nAqtN7x03f2fw+8utfJbw9IBZwcl8jUMzL17ZZ3ayxOpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tT7wbkk06oxSEES41xZrJB0aS/HAVnXFNF6O8PNCF48=;
 b=jvaOURX7brJq3XhyxPlgnM6qhDbhQ6ZdOjh2XSMpeo+xME3hJ5gofOL0lOP7dTxOGdLw3mmeD8tiXoUWBXUUza5Mg6P9651lSlk60JAJhV9b3wbPwYcd/f7lVLMDHUi1NNKSxKTrvBrV91pAxwSTPcAfztrNAz4l//Hg2gdJ46zd9VkXtZHpkYsy0W3Qi9mAU12PLRg/lpfBAUW3hv+aJOdvm+Ytl5dlhhiIS9mB4gVVaVJigcFE6uX0goIfXe7H7WxGJLwIn2ajAOOwpLZJKETuXwHiwvSFCmFt2QPDE8fBM7mg/NxdtI4z305o3w3GrP+j2T6hnCya8M5Z9JZtIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by PH8PR11MB6731.namprd11.prod.outlook.com
 (2603:10b6:510:1c7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Fri, 22 Aug
 2025 00:10:41 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%7]) with mapi id 15.20.9052.013; Fri, 22 Aug 2025
 00:10:41 +0000
Date: Thu, 21 Aug 2025 17:10:38 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <marc.herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH 3/3] test/common: stop relying on bash $SECONDS in
 check_dmesg()
Message-ID: <aKe1ficItvMkeV0I@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250724221323.365191-4-marc.herbert@linux.intel.com>
X-ClientProxiedBy: BY5PR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::29) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|PH8PR11MB6731:EE_
X-MS-Office365-Filtering-Correlation-Id: 032de51e-2e22-4155-9b46-08dde110540c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FOYLt28aX2VfYLMNtHWS9hROwfdxfxDjwdSnvdsbx4TKaZLkRzmIOSvhkF9i?=
 =?us-ascii?Q?MgzMgPVvSwq3WJGQhsfWVN4S//FbQNESTFxQd1H9jK5EAFt/7BZCBXWmOqK0?=
 =?us-ascii?Q?Xj5JlMSHMyThcjWWyo43sBLzMmuO9cccSk6XVq5dHd6K0FyiDjA34W8Sys/c?=
 =?us-ascii?Q?Hw5vp3ij2/xrK1JM3g7GOeomtdiMxtQg9MU4rLU7i2kysDJ80q6i4Yv8sN9d?=
 =?us-ascii?Q?Ibep0ifralVAVEM/AKM1htE4Bovp3gmYiM5uQhqp7iEirr7MTbD/XtOQhIHo?=
 =?us-ascii?Q?1lK90CoKZGZBSmdw/GZ8P+XSGL/6MzZ0n9f1ojlc2qT0Ce3d4q340eUyuJrs?=
 =?us-ascii?Q?KknhyryRVBgvjs1L8vJW0orS78NcUarmpjmXCUT1h2GbZBhqh8zpZHZx2Ksk?=
 =?us-ascii?Q?P64PVjCa5uNONRKKv0AlqXzq1VY0guXxRlLoFRCOtVAu/IrhrAcDjVYG6Tkm?=
 =?us-ascii?Q?cTWGrq83thvtijySqgtEreC01jtjUMZEICGMLftKXTxrrQSy4W5I2kOinioc?=
 =?us-ascii?Q?oBIchP1PwRpPDrmYhkOmPapQQKj4YYrceOEAlSu0uMmI9LfR2SM+xLMfoG3x?=
 =?us-ascii?Q?4o6mBPAgerLbVRiaFQe4igaWmHzOFReEcK6v8XOGiKnCQCf/iXSoFHvcJd3e?=
 =?us-ascii?Q?YFC00YSanN9bOsxO+bJjTj+BkMzsxv0vGjBAwUSqlLXfjuu7Dh8PhlGlCWet?=
 =?us-ascii?Q?MyuCpKlPRs7MREreGhnrI1h/0M8shj1gba985+hf+Q3RFtBrnOvkly3qND/Y?=
 =?us-ascii?Q?JhjKKqpKcGbNnNf2rYGo9PPE/+3nm1bQPl7Kfnc3w19JHiBxzTK6UFj7mgJJ?=
 =?us-ascii?Q?oS49Ze/pXiMfcrA9zyYuXqtgTwQjVs412vQzoLK9B/b5q8sJVDIDL+Bqd20P?=
 =?us-ascii?Q?fhJpxXizGQV0VfGngTgXMiXNliqkY8aQcsoT740hXfnGnKqnEkWqgZ8ENbyD?=
 =?us-ascii?Q?FtiuRNdWebHA6A+V9FzA3UG0cI1Q9MW0eKDoktyWIkptl2h9KF/erC8F1XIg?=
 =?us-ascii?Q?hFAvQF+gwYh5D5RLl0IXKfSxt6Mh9UQvG7e++9X8VGivbqY3pGAfemKdVqTB?=
 =?us-ascii?Q?H+qybIZyuv2lzfaHPo60d2IWGae1Puvnpf9m0PQjgYaYOLHRtLCgsPoz+pRI?=
 =?us-ascii?Q?f6Ztb3+VDo2zfZLNgoM9Go8BG7ag7qACYYBsRDnWqB7JXKdjv1ysS4xVDsiD?=
 =?us-ascii?Q?q1aPytyjJ3ZL2J53ZyYHH+oIZLF+gfI3ZuN2HJg06wy0AA4UVQ+nWgH7FaXa?=
 =?us-ascii?Q?9tGsnFAUKZYwE5H8PIB1c+/5JiUwdBqIF6HMlBSZNLKU2Eg8ETSGPGR+N6Kj?=
 =?us-ascii?Q?+A/GeIragNlH7rcY9irbVUf4KQE0cd1NQvRJOFiXYHWL5H7hQms8eLQ+K/OL?=
 =?us-ascii?Q?2jN3jEO3eRL8GDcPN6fhjoOicSnQmBUNUTusw3u8w/9HxQG5QSyzxplfUfXp?=
 =?us-ascii?Q?4Oc3GgyV/ec=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9D7efEMw37969WdI/TRf98zkpLMlvIpRxt9Yv6MiLC8P1an7gMvHqzaOULNX?=
 =?us-ascii?Q?LmT2Uwc8Vo3XPlMn7RHE9gzAwVf5+HYJq86OfsHHsRbPVBiL7kBBLYHLjyvf?=
 =?us-ascii?Q?HvfJ6S0RjzqEP/sk2U8VPpuhxlEiptOjVOkxLcam1O152pCtHED9PikYyjED?=
 =?us-ascii?Q?L433eCPmWdG5ci7Wa8FVkejw5Xz0lntmc7CFW8NRClDNnpF1jictNqVUmICo?=
 =?us-ascii?Q?sv0ZCtksnhhcGANcfXut+1lOI0Yl6cC6NOBRMliVQGN+Whfa8V7yyArP75aq?=
 =?us-ascii?Q?2jbMka7s4x7P8ALilU7s4yPLJ+iaX2/iygP5m32eHMohDGvJguxHeVcR1eDF?=
 =?us-ascii?Q?KqL/VkY+4Bm12uF/j3xmWcI/iI2C/DIT3LKWKGAWf3Xnlg0vWWQLaCU03hMF?=
 =?us-ascii?Q?jJhi5bKN+xiWXQJjjj+Kev4JY1YWyl5qkQ4WLRc6btLOvTuyLnfWKlo/A2MZ?=
 =?us-ascii?Q?15kblhMzfWy2vcX9q5QcRR6xoePghvWTiRKerC42Jc6KkkmwMFJLHN7XRJc+?=
 =?us-ascii?Q?dkbc1sI7m5YfQJ21MNJbRkwnFDHfjtxo57wwDpBu9gpRwSI0cwTimTsWRZuY?=
 =?us-ascii?Q?tigMy0ctZmfVa4tgdCFxQ0fYaqvGePjbZFrIDk0ulLTBTnAycUgpFar2HGO/?=
 =?us-ascii?Q?xZcm91x48IDv+U67izqwh1pq/OLR3f3ve0ibJz6v655w2rLeK4ylLeKIf29e?=
 =?us-ascii?Q?X7uWRQkomrVErMjHqtl328+j/8Mri3cnXZdCaghh/Y/PqJMT57bGMm4IzuVd?=
 =?us-ascii?Q?btL6JlMhtS46Bc/CAuG6ufl4R/xoaarZnKZigqY9MKl4V0Wnsez4XUVXBT+r?=
 =?us-ascii?Q?j7bLe1llUEJGlKaPDoSlnMrH9k0fBmKm1tHhyw+qJsddi53ZWd1oASxgfOYj?=
 =?us-ascii?Q?92lEMmqHt/zcCJFlIfJXJWNbQ4jVS73AATrIfk3RdN4oaYuSjuC2aczdWprw?=
 =?us-ascii?Q?sXTg+3kR3/EVBbb2sAKr2TySyG5ScnSJmh6f/80AnFeT/T1GnXd/PTIYjdTj?=
 =?us-ascii?Q?EWdZaQRWudCzJwuGbeCim89Y253FYi3w/H+OtgNZD0o7MIZ0Wuh6dEx92t0M?=
 =?us-ascii?Q?qwSavpczJZBREgkbn/37ena7/F68AB7CaOM6pC/2KpGyCY9o9Ag2sEdJnb3n?=
 =?us-ascii?Q?BWCkG3j9JQmGTiWBsPks5F6T8tlpOU8ECdqu7nW2yX5aUR52FfmYfMkGC9bD?=
 =?us-ascii?Q?Yciiz4f6oTKKygpaq3M0h7O9tQ6cvuGbYB5lx90tyDd9qyrP+3oZ4wnJ4Lfb?=
 =?us-ascii?Q?Zou5AuQJfgj65ZvuvW1on8W/d7a4PwofIhXgvA6/GoL7JPqP9kMfE7CYE1fF?=
 =?us-ascii?Q?uleth8ukzXZl/yZ4FfTup1mFbtRf21zjvmlTtz2yf2i6tYKe7qtwnIoYmnak?=
 =?us-ascii?Q?603DjBy64OEJYWuFnBOoaqumz9w7fUy+u0hxIn0YnB3DrZyWDv6JB9BqaZD+?=
 =?us-ascii?Q?TnVQqZm8mjCbI5eUIj+JS3pIlMBSTojXwLEwOoQGy0Rdl8OoJ4YUOjGtmft1?=
 =?us-ascii?Q?ck2saFtExDgm9OyiBEHMegPjcCsqbQncAUiJDb082KKw0HaDFO5/bf4aeqrn?=
 =?us-ascii?Q?7hHwwAjXlZ6i3qXF15+9L7H4+F5j0qKqJZycaPbASsWbBkGUr+XBC7VecZcj?=
 =?us-ascii?Q?GA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 032de51e-2e22-4155-9b46-08dde110540c
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 00:10:40.9006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3AJRRvBWCdB/zfybXqddC9pwydU7JgYx7OI0vK6UyYMt6vXgLMs4CpVdP1JeeiuTasRPJiQqtoY7K3BEvCOPEz4GnMqAenk56tCjxEj3LIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6731
X-OriginatorOrg: intel.com

> 
> On 7/24/25 3:00 PM, marc.herbert@linux.intel.com wrote:
> > From: Marc Herbert <marc.herbert@linux.intel.com>
> > 
> > Stop relying on the imprecise bash $SECONDS variable as a test start
> > timestamp when scanning the logs for issues.
> > 
> > $SECONDS was convenient because it came "for free" and did not require
> > any time_init(). But it was not fine-grained enough and its rounding
> > process is not even documented. Keep using $SECONDS in log messages
> > where it is easy to use and more user-friendly than bare timestamps, but
> > switch the critical journalctl scan to a new, absolute NDTEST_START
> > timestamp initialized when test/common is sourced. Use a SECONDS-based,
> > rough sanity check in time_init() to make sure test/common is always
> > sourced early.

This patch has one fix, plus 4 while-we-are-at-it's, with only one of the
latter mentioned in the commit message. 

Limit this patch to fixing the known problem - replacing $SECONDS with an
initialized NDTEST_START for accurate log scanning. You could reasonably
include the log anchor additions since those help folks who view the dmesg
log in one go and tie directly to the timing fix. Then, if there is still
justification for the other debug functionality after we've tightened up
the timing, add them in a separate patch with proper explanation of what
problem they solve.

The commit message is explaining the drawbacks of seconds, but not
mentioning why that is a problem for ndctl. This previous text, captured
the issue:

>> Using the bash variable 'SECONDS' plus 1 for searching the
>> dmesg log sometimes led to one test picking up error messages
>> from the previous test when run as a suite. SECONDS alone may
>> miss some logs, but SECONDS + 1 is just as often too great.

Then state what the patch does to resolve it.
Initialize and use a timestamp with ms granularity with journalctl.

a few comments on the implementation...

> > 
> > Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
> > ---
> >  test/common | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 50 insertions(+), 2 deletions(-)
> > 
> > diff --git a/test/common b/test/common
> > index 2d076402ef7c..0214c6aaed5f 100644
> > --- a/test/common
> > +++ b/test/common
> > @@ -15,6 +15,25 @@ err()
> >  	exit "$rc"
> >  }
> >  
> > +# Initialize the NDTEST_START timestamp used to scan the logs.
> > +# Insert an anchor/bookmark in the logs to quickly locate the start of any test.
> > +time_init()
> > +{
> > +	# Refuse to run if anything lasted for too long before this point
> > +	# because that would make NDTEST_START incorrect.
> > +	test "$SECONDS" -le 1 || err 'test/common must be included first!'

Agree w previous reviewer comments, this is not needed.

> > +
> > +	NDTEST_START=$(LC_TIME=C date '+%F %T.%3N')
> > +
> > +	# Log anchor, especially useful when running tests back to back
> > +	printf "<5>%s@%ds: sourcing test/common: NDTEST_START=%s\n" \
> > +		"$test_basename" "$SECONDS" "$NDTEST_START" > /dev/kmsg
> > +
> > +	# Default value, can be overridden by the environment
> > +	: "${NDTEST_LOG_DBG:=false}"
> > +}
> > +time_init
> > +
> >  # Global variables
> >  
> >  # NDCTL
> > @@ -147,11 +166,40 @@ json2var()
> >  # $1: line number where this is called
> >  check_dmesg()
> >  {
> > +	if "$NDTEST_LOG_DBG"; then
> > +		# Keep a record of which log lines we scanned
> > +		journalctl -q -b --since "$NDTEST_START" \
> > +			-o short-precise > journal-"$(basename "$0")".log
> > +	fi
> > +	# After enabling with `NDTEST_LOG_DBG=true meson test`, inspect with:
> > +	#    head -n 7 $(ls -1t build/journal-*.log | tac)
> > +	#    journalctl --since='- 5 min' -o short-precise -g 'test/common'
> > +
> >  	# validate no WARN or lockdep report during the run
> > -	sleep 1
> > -	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
> > +	log=$(journalctl -r -k --since "$NDTEST_START")
> >  	grep -q "Call Trace" <<< "$log" && err "$1"
> >  	true
> > +
> > +	# Log anchor, especially useful when running tests back to back
> > +	printf "<5>%s@%ds: test/common: check_dmesg() OK\n" "$test_basename" "$SECONDS" > /dev/kmsg
> > +
> > +	if "$NDTEST_LOG_DBG"; then
> > +	    log_stress from_check_dmesg
> > +	fi
> > +}
> > +
> > +# While they should, many tests don't use check_dmesg().

I suspect we get more value by directly going after the outliers like
scripts not checking dmesg, or unit tests not wrapped in scripts.
(wrapping unit tests in scripts would be a new requirement)

Although not clear what the below code has to do with tests that
don't check_dmesg().

> > So double down here. Also, this
> > +# runs later which is better.
> > +# Before enabling NDTEST_LOG_DBG=true, make sure no test started defining its own
> > +# EXIT trap.
> > +if "$NDTEST_LOG_DBG"; then
> > +    trap 'log_stress from_trap' EXIT
> > +fi
> > +
> > +log_stress()
> > +{
> > +	printf '<3>%s@%ds: NDTEST_LOG_DBG Call Trace; trying to break the next check_dmesg() %s\n' \
> > +		"$test_basename" "$SECONDS" "$1" > /dev/kmsg
> >  }
> >  
> >  # CXL COMMON
> 
