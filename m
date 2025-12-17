Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D8226ED4A
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 04:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765945588; cv=fail; b=V384jdGp2vFlBkQG1jkhHjvlxDDT7UUbe/0h96HgJQZGkxaLlaG/eqnLOG0WZPVfH96e+1Ku2HDPISFlqgdpGEk4cK6jpJoIzdRXJWfca85Nskz+6mxJzuvJYAXfHZDc1wfB5ORtufFLUpGSd+hZ+sj+uyOkZxLRaP5OpBR2urg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765945588; c=relaxed/simple;
	bh=Ui3pV0DLCkqR/sYOVnO6hsE3UNs+FvAUgJdKetDKKCQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CZ8vV3VGDnCPFqPjVBKMbMb9QKDFBYICLqtzzNA9h8CCCYnevpkkJIXL8+KUkSglHiNqEjdRoxxuvbgKlKqnS7AuOqFFp87+/k7TNXhnyy0TYtODe/7uGbq0nz0SGminmBYwLJOCpmQkRLtBHfs+3LOy33CkcE2eFC9jPIyDSoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NMQs0hjy; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NMQs0hjy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765945587; x=1797481587;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Ui3pV0DLCkqR/sYOVnO6hsE3UNs+FvAUgJdKetDKKCQ=;
  b=NMQs0hjyTNNuxKVCHXJBzGF+oJ/9yBtMPXGvSQiDjxr7NJCUloMypThV
   toWwoINYprBisKrLnQDoibJFWFoJF9t12ahtJ9FuRsWP7EXkfT0Fd7kGu
   YL39ZtZSjERYm9LMjll6v3MB2KMbIUJv55bmb7fZ9V0p5fahSycYPTnKS
   0BwZ85gQMJRS/k6tua8CI7Cij20rJFZuhGCzRYHhZ39MXYR2Ty1nqX21J
   WrEbRQJ1Zl8N6Dpw5lVmiWnn/BE4ZECA9YWnY2tQN/edKtwwlCBEouMZp
   Uy1DljvVIbw9LeKnNRblttaw785kIDBBhjAKmQ8TyFfl2CARrqGFB0a+7
   w==;
X-CSE-ConnectionGUID: l8k4Jc/sTx6O94yFzA5acQ==
X-CSE-MsgGUID: k7NzAu6JTPumO7tskyCcMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="79329310"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="79329310"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:26:26 -0800
X-CSE-ConnectionGUID: q07RWQQUQ6mQu5E9+yQq1A==
X-CSE-MsgGUID: wjOB8shFRnGyRFLR/ELYBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="221581117"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:26:26 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:26:25 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 20:26:25 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.16) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:26:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epr8NQvcJfcDuc91NDQaLBUza+RdyPBEAMdkZi+XUeus58Kl9jxi28qDYUG6V0xMshsBx7/U459j9HbJ2u8658EniSbH4Vg7Wv9HUJezqkuDdg+7Mu/UFaz7V8YEum0ZzvSVKpGi97YMc3lHUfDXe8FpW8bIJvX8mA7rdg3bUBgFPvkbvfTNhoaSRqBcFCF2YmFZcV4Nc6P0PqaukL9P615vno4861b8m8mlJAfDyhKxewUl/Fi38ne8kqaKxsbph4fIn61Hrb+4NkH4rnFnRMa/5myDmiVX5q2kFJH58UsamsS1In1DnXN1rcdeQOeUDKNKmvBp5sRksO3y3nMPWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNZbd8oZgcsLhk3VluGxVZtngco/6fesVLKAMJ4TGto=;
 b=DYuAYPxBikBJw0b+W756LAUgp8pTKlxVSqplLPmiIASC4a0/Svl1qg35dZNjd+wd/s0G+rsnD9ucUmd/AaXOPHgWlWEiB/ikq5w63zSMv38bpsqvujfzopvEFFzl6S6kKP674e1XM974RCeaAsK/y0gD7m9a+LM87r7fOY8hBxoeOikN8gFPTjl+JRj6S0Dc/80OidFbqsuwd2wAHS08G+EH8JRKBnZNf0TU1mC+46MQ3SjPGuPbAsXdQ/NbOE2P68wMGUK16sWnNzpp39lv8PxbMXjYxQZap5rNCrxZgUh3MII5cUZE2qXBFdpFWwiC0Ba/rYVin91ZWagpFSacKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB5048.namprd11.prod.outlook.com (2603:10b6:510:3d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 04:26:17 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 04:26:17 +0000
Date: Tue, 16 Dec 2025 20:26:14 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [PATCH v5 1/7] libcxl: Add debugfs path to CXL context
Message-ID: <aUIw5jxb0JHNubOD@aschofie-mobl2.lan>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-2-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251215213630.8983-2-Benjamin.Cheatham@amd.com>
X-ClientProxiedBy: SJ0PR13CA0084.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::29) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB5048:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d0e3380-dde1-4fc1-ab81-08de3d246bf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HIGXiNw4bODcNxXL2wWaFGNSY1hv/jTHEFrI7bMJoPzbUtYG9DsIJfU2IVJ+?=
 =?us-ascii?Q?O41SrD12kCUkQE6hJR3+h9ky6AJ4whqE5/6DF+abcfZBWbjVYDRM1q85yyAQ?=
 =?us-ascii?Q?qdeRZfUTXY8OC38uf8+fnnhQuIQQU5dGwV7DWQdUQsFDluCvUiXdXiDddHaL?=
 =?us-ascii?Q?wlvqQrlUt5cN5kgWJ+29TgynaGqDCVB8EkafbRugIoncmjZMKFwUFKB4CUYV?=
 =?us-ascii?Q?4Exk1JFOl8+tfbOiGGNtZ4T1GB4CsyRwvIo8xYo9yMgQNU+3C6xLUgkNnkm7?=
 =?us-ascii?Q?vPryo1HB5EIJR7/99xQthBzHPLnJUOSxHyd4TxZULvAnamTwIZM6ptLP6E6f?=
 =?us-ascii?Q?I3UxztZn+EEnVTMbZ5e5krqcsmWeoWg+6yS3cO/V4qwHXvVMmoSbV0jeumgH?=
 =?us-ascii?Q?ftiuH6s9ztZ8nNaG/7zJvHYEyPKjuSZoziWtr0fXpU2wTSupYiIAU0MTYLMz?=
 =?us-ascii?Q?Tl5cAH90JFX/eUi9mvkqhTHmDK2Biq1aqV6RQNAbaSOapsfj07TjYNvWt5L7?=
 =?us-ascii?Q?xYC8WAWZgwqDTlrqJ9oetwHvuaovpJfd+liBN8nsF6nOOK+Gbuz0RsD2uAiu?=
 =?us-ascii?Q?ROTFe/TgRQPtjOcnuJWFVkoILByoxXdYD1s6/oS9txAWjaENNmO8YoCEqhGQ?=
 =?us-ascii?Q?jZGSky1ZeapQ5C6qgsPumbh9/RAEqEUtXi8b2GlFJIuNmaATjhxRsRtP6q/T?=
 =?us-ascii?Q?Na/34GrXaEmZEYWlOfPzyn+TQtvwM8uIfbVrvyF/vb8Ea60ux84RL/9HI0VH?=
 =?us-ascii?Q?1/iQPZqJgC9cn95igXZfXez3d/7Gh0fad9E4SStDiPKr7y0cZWgf9SdO/ONr?=
 =?us-ascii?Q?Q56s1+NzLLWukXsbDAXdPWb44prwB9FnMqsXyl2pH/+tJ28h3+YDd8nd+F0E?=
 =?us-ascii?Q?gst+4hTQqwSTFkyXuKtgiMJVX2miksFfqbQaoLb8tiUawRBSL5XJz1IBrrQW?=
 =?us-ascii?Q?Od1GKuqD50TS9H3MQdcw66lDjzLIZp880OPWbCvSE7tJUHndP6cLjfGhOXqj?=
 =?us-ascii?Q?oG94MSswqcexmM8M8NtVZp3ESqRI8XEZW9q0EgmxFATvF+pLyynoHj/f5FZu?=
 =?us-ascii?Q?XI0fbXw6+BDP3GFgusX5yHGahT+cz5nb3CJmNFUn+TC8I2tM3lcKFfeIF4+/?=
 =?us-ascii?Q?FBONH0o6TrCfjkostCsu1zcCb+bGo4ETycRljdsp8vYZZuIcgTmDtO14L9Lg?=
 =?us-ascii?Q?cDTEaDI2WOGVKyJqOJ9TT6/HmFbXMD8D0sS2rDVv4ZZ3H3t79pcSQDvonT+I?=
 =?us-ascii?Q?ER80kOLOgR3D7BqzFpfABZcEapoaEzexO6gJeMCd4XNNY+uQUP7zynJ5ASoD?=
 =?us-ascii?Q?Aarp7svGYuBTwAGPu/aq6nTFoNWhTb6IODHJIyZmoFzo92627DXROQ+/NYFT?=
 =?us-ascii?Q?ANu0Kg+ttu8BE38xc211w94nbCK7l170fQbykkKH7dKQzRNlT9vu1DdMeM+5?=
 =?us-ascii?Q?wvgJIDwCNyIQSorCx+AgoWrKwjbBrYRk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CyH+HbmZw2gz/n02MUODz5LMgrSY5YVqA8CSN6Km0B4fLzC4u5qhjFRv7Cd4?=
 =?us-ascii?Q?PSmu0+YEtrzOEaDY5Rza04EykxQRHk4MY9Zcbo1Wx8rnJF/cp/3+xHlf7B6l?=
 =?us-ascii?Q?66f4Uvkdm/hcwYlcIxaAfIH4yUI5LaO/6B5yQxqPANcI1TkzvlLXzQMgz1Xr?=
 =?us-ascii?Q?5x+WfiFtJbaYCc0uirUF1VUd0HppC2ZeVM/Gp5MvSNoLY9aOMTI5MIz7iL57?=
 =?us-ascii?Q?9I8RQ2JYBM1zOC7LvN/FZGJx8qG5rGyCPYDyZvYg+5mCNwFxOSR+QLrf2IiS?=
 =?us-ascii?Q?GMEToTChEfRXnmR1ckIeH0govfaMXlimEoqZWBUIj78CEkhiwUgIomsGCPH/?=
 =?us-ascii?Q?6E94WZ4UWinzCRQ7JJgU3RXilCRHbWcYYVXjYTTi9ZXkoXYUPJyX/EMMSlIR?=
 =?us-ascii?Q?SyN7oxhR1r1G3YrOzb/9OncXKOxUrQRxkf2cvH6jA/5Fhvwz8tyK1q+xLSAf?=
 =?us-ascii?Q?WRkkghCf0bcsaxRrEBnjmfp4qDPg5zLJuqp3Oml1PDHWlZrkTsv8mfc3xoJO?=
 =?us-ascii?Q?2J7eBzgZyApzzsdqtV50lNz5IFs7JoxcOC2TNW77flF4c5jNcwmxuYJJ9lrQ?=
 =?us-ascii?Q?25SXE877IwXbZrQR0nawB3Fex/a7noVuCitcKr9oKjl3mOwvk/zYTiQp0Bhg?=
 =?us-ascii?Q?9O7sAYsWsNkMTuL8OabqSHKGMPu4ai2tKBTGAOpzi0NW3WAdLf77K2gK/wVo?=
 =?us-ascii?Q?u6EyicWQnok/UGputsG0DzTg/xP6I0C1k8T/3OgzxnDz/DysRiehCd7NkSC1?=
 =?us-ascii?Q?z2omxzWkOr1JI0NQedzYIZVr6Y38XJiDXBD6KJwJ5G71QGepvUn5mGmJBUx0?=
 =?us-ascii?Q?m1toW4OJrY3i4PYJ9B+guRq+bKeeQN/NjJxZXoP9/a6FA+UmpKMWO0T/VFee?=
 =?us-ascii?Q?BXcAdOwyDGoQXGnn8+VeWYRzh4cLsCOT3acZt+wD+wzDV582BPZaPDZna7Cj?=
 =?us-ascii?Q?nU16lbgRdZCIjE9VlmXBSXDFbIw7QtrbdecCO+C/gWGdxZN5AVYg1s+U5iOG?=
 =?us-ascii?Q?9p+cywMBCZU5r8LpeLbMktOqjOo2LpOnzMu6JosUEYKaAhiawrenslHn3wPV?=
 =?us-ascii?Q?ROb8L+0oD65TWZq7shC2rWiB+WrinunSv0G2zCdho8VgHF+RWOFPh0EyOCE2?=
 =?us-ascii?Q?OMj7ZeAFchj9OMCcHaPHhTM98hsfiyMuDi7biErIm4SmK9/zzKbpOliubhnd?=
 =?us-ascii?Q?8PVoWEiITtTHaQETQmG+6Eir1pLQxKaOqqL9NmCluNmuQdOclbdEJsyS3WkZ?=
 =?us-ascii?Q?NmlCrrEwGbAClAs6kRviW9AjcjQY5NtDCKwHsInLITdYBRP8z8xBuL3/xuvM?=
 =?us-ascii?Q?Oo/rvZMkP0cbjZc1DSfuSEf+Ksw5YjoBVGoLc9dolBSJUWh2ARyvBX09AWDC?=
 =?us-ascii?Q?2wB5W3HHmgTOF4RE5tnnuoN+Sfw7VinkSkqMpsHGgzVaugu4dQ7Sd8wqGfq5?=
 =?us-ascii?Q?hVmcaTVrGJs+Ra8EAz73Cl04rQMrqLIc2nylAHj5DB4x2hFRexhaySlX2pFW?=
 =?us-ascii?Q?ImMc/nR8YxAL2OojBqMuyvF2NqmRs6D0YvKNuLZt6xqGemA3DcuOuopuUUXP?=
 =?us-ascii?Q?rRpTsUSyzzwzbtjE9QhZgeVZu1PN+9A5jzGzfGkRjUBJTMPv0ogui+hZEobt?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0e3380-dde1-4fc1-ab81-08de3d246bf9
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 04:26:17.5167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nusgpb6vbF0zTHPk1HnUtJj/VjPIARkH5Jd+ReFMcpo9U0BlF9WIBvRdzhDaB+gNnIlQFZRrR7BqrKmvj9Iawr0yu5++UPPNw5q/KgX9CZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5048
X-OriginatorOrg: intel.com

On Mon, Dec 15, 2025 at 03:36:24PM -0600, Ben Cheatham wrote:
> Find the CXL debugfs mount point and add it to the CXL library context.
> This will be used by poison and procotol error library functions to
> access the information presented by the filesystem.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
> ---
>  cxl/lib/libcxl.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index cafde1c..71eff6d 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -8,6 +8,7 @@
>  #include <stdlib.h>
>  #include <dirent.h>
>  #include <unistd.h>
> +#include <mntent.h>
>  #include <sys/mman.h>
>  #include <sys/stat.h>
>  #include <sys/types.h>
> @@ -54,6 +55,7 @@ struct cxl_ctx {
>  	struct kmod_ctx *kmod_ctx;
>  	struct daxctl_ctx *daxctl_ctx;
>  	void *private_data;
> +	const char *debugfs;

Do you want this const?  Later we alloc and eventually free it.


>  };
>  
>  static void free_pmem(struct cxl_pmem *pmem)
> @@ -240,6 +242,28 @@ CXL_EXPORT void *cxl_get_private_data(struct cxl_ctx *ctx)
>  	return ctx->private_data;
>  }
>  
> +static const char* get_debugfs_dir(void)

drop const above?



> +{
> +	char *debugfs_dir = NULL;
> +	struct mntent *ent;
> +	FILE *mntf;
> +
> +	mntf = setmntent("/proc/mounts", "r");
> +	if (!mntf)
> +		return NULL;
> +
> +	while ((ent = getmntent(mntf)) != NULL) {
> +		if (!strcmp(ent->mnt_type, "debugfs")) {

include <string.h>


> +			debugfs_dir = calloc(strlen(ent->mnt_dir) + 1, 1);
> +			strcpy(debugfs_dir, ent->mnt_dir);

perhaps -
        debugfs_dir = strdup(ent->mnt_dir);




> +			break;
> +		}
> +	}
> +
> +	endmntent(mntf);
> +	return debugfs_dir;
> +}

snip

