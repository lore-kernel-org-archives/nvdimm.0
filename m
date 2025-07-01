Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD86D1CAB3
	for <nvdimm@lists.linux.dev>; Tue,  1 Jul 2025 00:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751331106; cv=fail; b=i5AmOxHyT3wGYlOOnOwsFpwsIGUc0yUb4YUziTJZ+j5IVjssOrZGQT/KrbuAIAnfqi5pDBrsjbt0r0WhtUvtEE6+qNuBkHMtVtDW/RtNkb0UX1QHt1+gj4Qauwd6bJiOi2rXmQkohN3KVZGB6MHMsINVYSJZ5fUZbT7K8afKdxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751331106; c=relaxed/simple;
	bh=4flWdIIlzh/4xYRSCqZw1W517ONPGnUpmMuvvDy12pg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jg1UZ2YIzmYnmoqlMw42zm0+oygdJQ61Psm6fOs2db6coCPBgvXvPrrXMYA18FPi/BZtX97N1bEpgx8sswXR6QlHB0kA/zb9z/JeW/oa2kqax0+H5kVjllvBtDVfNyU7U4dnjd7r2G9pTt6vTvz8AyyqMsosDyA9BUPA56yDfbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DlddDMzm; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DlddDMzm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751331103; x=1782867103;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4flWdIIlzh/4xYRSCqZw1W517ONPGnUpmMuvvDy12pg=;
  b=DlddDMzmydsVIoJ5W3JRtn+7vaus8WQYOh5BPt1j/vgkDSHM66y4IsSJ
   MTAnX0M6bbCRXSec5kLPHlJg0xEPhxS9r6dEiV5bZ9cqVLeY4G/i1D3Wf
   kpljo9oe3pSC17VIaqZJE7mYvbex2OdEEerrpf74wmbghAlixzi5FKOJL
   wz2nwyZoyqHBE9W+hpkW+iWwIeOeeekYoAzBaNFgoxHWTwgc91epwbphj
   YArugwXYM7tQmy1UKLFRXZgdAuiJXLGaTvW01LD8y4Whxs3DsSvHZxpjM
   C/8s6huWjlF6T5uMdvo4KQZP7H4qKy8BK2X9NCXZbFSX+uZAwe/0iWPma
   w==;
X-CSE-ConnectionGUID: U67cwf5kS6CnxFwsTnL2EQ==
X-CSE-MsgGUID: 7bceJ868RHenTLHx5tZfdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53296899"
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="53296899"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 17:51:39 -0700
X-CSE-ConnectionGUID: VT3h7U0aTGSTJ8RfS0MHqg==
X-CSE-MsgGUID: luGCpMadSeiY+UuJUvpJVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="158149269"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 17:51:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 17:51:38 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 17:51:38 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.87) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 17:51:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IkEnNqfQnZZkI9/QFNtpjcFP8NAjxWWTDMbmZysYeC2ysFj+zEj8xNh2sUqPN56pfTPIIkgL7FeibfrKDGT/BbHZKTm/Au4Dh7PS/grayIMjiH45fuzByCcednw8roq/MioEUD/BilpT77M3oKInJANWuIsrnVHeOoYglMlXnu5jTgsHS9dwTl70KUTTV38RpkGo5bFWJqBpKP+Ib+W9rhAvcKCA3tL2z3DhT5fhr55milb/kMgJkIOz/03fRoWhrqSHK3JQxxFvzxU53VrBao3D7fswHLQQRFf7jCgqrTV4hvecDDs9D8afayQf3XcBEIVuifoOVd3vdXM8yZjnEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U54cy0OnPPRIaFTOHsz9F0WXqZj7LrW6UJNlXqy0Hb0=;
 b=RkCu9eto5WKl7c+Rsn/RUw7cMnt6Aj/lRheFpo/5qC49aHaMcdl0krLldonXYi5N/MPwjkYW4Xew/q6NmHdSUhqec8Njsl1e8/3/8QsPUhZoAi28m8l5KARDyV43FFcBq58PO2GDam4IPTKO+NJ9bmvHTrVXWHN2UKbyp8BZW13oDRYXbW06rqELe1Rd+7bKfAUw8klyqko+j1OLBi5ZAg6+XzfwlqexAlvxoXJagts6D4IJ91XvgNJnR1mWvtjd3A17CbClkeq90r5INunI/cQrXU1/OW7+1e6voLJAlxFxvOji+ZnJdon1WYRM409q+x/UskbCjSCeiSSsoDgntg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB7199.namprd11.prod.outlook.com (2603:10b6:208:418::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Tue, 1 Jul
 2025 00:51:04 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb%7]) with mapi id 15.20.8769.022; Tue, 1 Jul 2025
 00:51:04 +0000
Date: Mon, 30 Jun 2025 17:51:00 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Rong Tao <rtoax@foxmail.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Rong Tao
	<rongtao@cestc.cn>
Subject: Re: [ndctl PATCH] Documentation: cxl,daxctl,ndctl add --list-cmds
 info
Message-ID: <aGMw9JLysjOf2KWY@aschofie-mobl2.lan>
References: <tencent_9A6812E28AC195905396EEE5A8CAD2ABD306@qq.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tencent_9A6812E28AC195905396EEE5A8CAD2ABD306@qq.com>
X-ClientProxiedBy: SJ0PR05CA0162.namprd05.prod.outlook.com
 (2603:10b6:a03:339::17) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB7199:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b6c95ee-3723-469c-9379-08ddb8395b0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?niUoIVE3bEVikhGrAivaFayu46/KzCNcSJqmYGozZRXDwjRXx/UfMHEmu3yk?=
 =?us-ascii?Q?8GPMS/YlfjeExchB+hvH1e9hDBVErtFd6xXJFSAGtV9/KlZ10vcRRBDVeqfA?=
 =?us-ascii?Q?f7GTv6sxeLHEt0RRyDR34RqxMyapBa99TORIfzR+9/Wwf5nKOdyr2cWyPYiq?=
 =?us-ascii?Q?EQSkTRoKaoCP0+WGVAF+B3yvA7sHt2e7eqffufT+q6Ty18hhj78XpYmnK6/D?=
 =?us-ascii?Q?tetv9h/Lijb471kWA9MfrGDQKpxLBgaOCjH0JLXkRpE0YmheqAcBFV8LpDUS?=
 =?us-ascii?Q?kkTnlG3izNoI7v7GphjJdwNZwVrvGBBOrv4FN7YflUGLTf+MNJS3GYzt9KA5?=
 =?us-ascii?Q?K/O+0oP6DnFOQ9kFAb5KFNuExlFs0kPqFt/zUdkbub6zZjEQKhGjda4aBPfx?=
 =?us-ascii?Q?u8+Efd159qF3lSbdLH35wZ9qU3oY12UB6S2pTTD6eKde0rCpUz2R+uITOlPz?=
 =?us-ascii?Q?ugko1qWAGt2dPL4idGvOTJSIAF+WuX7qIJWsYTrLIlttm7vLpbhWKJ/Jnch8?=
 =?us-ascii?Q?eHev0XERYh79hSEW1kfOdDR7NgR6Dzy7pR7Y8o02TLHBl6oO7qSnxZTWaRv+?=
 =?us-ascii?Q?qgxTzLQeRFjBfGNZRMTyTMR47I1VjuSV1GAD9ER3IRN9xqMiXN+EAkWd2t1L?=
 =?us-ascii?Q?Mzh8gDF9zOw9U/ZTxs3x8PrxzOj3jE6d9mvVztJyc66o4TI3MWpKJSEYMUS5?=
 =?us-ascii?Q?80EDT3NnU0eGP8htx9HtOa3eX0K4jX+5XKzCwV7sWBzINpMTpnhYd8uswKo7?=
 =?us-ascii?Q?yrqfKNeD6ioFAseyELglJFeY1TYP6ORsjUJzf23CJJ8NHwPBhEaZ8EoBYOBB?=
 =?us-ascii?Q?IUX3F++7uTq7SoVboesuY1sROLvW5DIx7yHx3Qp4k3snIkbHocuBwbQyYEwH?=
 =?us-ascii?Q?bMjzcwU/eZlq96QnLMc+iVgcQ4ZNPAaWCOGbOr6MwXoqzM6eNnjl68YOW3Xp?=
 =?us-ascii?Q?q8uIIi3K37NzFLSKTsUIyhZBYqL5pVsM9gpc1PGnC8Eyr49cK2zSdF+AUfdj?=
 =?us-ascii?Q?crzFQMm5CvGrAk1Sv3LF6Yg6eWSOBBDwCc5OYs9LeHAqX/LtNCUoQtNdJeMi?=
 =?us-ascii?Q?ICoiHfhe3PtuTxIX2gWEHi/GXi7VTXN8/U3KHKfTF10fFV82TjjQO7qTjVE7?=
 =?us-ascii?Q?Y7HPVRhcrGMlBZPUpPMLXt2ne38MSkLcqu7DzNQ4VVf0bp2rkpf/48Ye2lqs?=
 =?us-ascii?Q?0jLCU09sSC6BOAjiN1VdWcQ+i0yCUB4qOdN4L3FRQA1szgQfbejFScY78m4p?=
 =?us-ascii?Q?78S5TOTHMe8fNZd/2X4ZAb57USzwndjWI7UUNiEMwoK0VulPifrSey7/Aw4w?=
 =?us-ascii?Q?WxRO2CLUwgPNBDNomuoRVbM+GcUEonWtKtnhc6ArAVuGr8g4T4KVrNNwsuG/?=
 =?us-ascii?Q?Wl8rqI3VdqthV2fidzOYPL5wLjm7xeJGxrWl2AJjzaI+YNkL0hNSwBhF95KJ?=
 =?us-ascii?Q?zNKJjN9ZFHM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tPjefyWVjZmDVIclzW5czvjq/78Gt9qU1MbMaN7O/ul9FWjzKRYhJ8TsEtIm?=
 =?us-ascii?Q?T0Ot2q4+tNhB8Vr2KJMkQdf6UHDuMnGdioqjy073OvWgMBNpF4c0iCsFKpSb?=
 =?us-ascii?Q?JSLZik2PODHqk4fiqskmb9Dq8TmpIEJspVqHyERqjEoi/jVcGTtc9jwOLVut?=
 =?us-ascii?Q?Ssnn/6xa/1s5ojJrHb49QfWYt/kNJ0E7Axt6schpr/FzdWvML9Utb8VIsLK2?=
 =?us-ascii?Q?BYr+Kk6MEvAGXuE1XOGlwBx0Qg+nzAb0MmUE9/Fs3yXhbWlmxywyv6L3eHRD?=
 =?us-ascii?Q?pElZNPa7zOk1T+b+7SXxAxNSDwfxaUGrBZHBpgkF/KoI2ETmQyoDAxafnxNg?=
 =?us-ascii?Q?97vAJd29VVgWfw9X0Fc5+SPeOlcN/FL9WQcfnQRA+zGxgsnbNoStv1BlqGHh?=
 =?us-ascii?Q?A2JQjca7PVRFf3mbOntqBZQs9Zy22Ak/KiNSaCgTe+TsJq2WQXjyibOT7dj8?=
 =?us-ascii?Q?hrOjm3QsGOFQQx9tZlbHyLG0t4SsPGUC+AswlBYCBg4Y12JiY5ktiaxVUL/v?=
 =?us-ascii?Q?2ujTyYCGjax0mU0wnu2YY7Lli5CU0jONYUS5pKW961RBn6h8FflpOuLukkI9?=
 =?us-ascii?Q?0FamIcsoQQ37tfnKbL1YCMJtfG0ZhqveoMtwbrkcoVFaKgcDUHvCaSNVF1YF?=
 =?us-ascii?Q?I9rLZ/2sNZLTr12w8SDH07hwCEXjAXgr1gQOu383UZ4Dmz3z7oniFnxQPOf5?=
 =?us-ascii?Q?Jo54O0iy+tdaCTLf10xajDqc9S0Z5N6Y9+fIh3luqfjSOXQYJxQoCEXFv37/?=
 =?us-ascii?Q?LrcT41kZtkzsCug78BlFyLFi5mOlK39C5j2s0kwK9eMNFFe779H6MLYDc8Pe?=
 =?us-ascii?Q?3WGfRk6KDKZGgMrIHDxb02ff+hTnzUbhWC+7wnqLCoE5Mr+V1D7cOyJpJrjK?=
 =?us-ascii?Q?5xbfcMGigK5q6LpSvIp3DoQIe5OVLDo0Bg46f42Xq8WDTNo4OWgBkDmdOKVR?=
 =?us-ascii?Q?FQ7lacZ2kQLTRAVQA7I3kIap0XyDM5Ycs1ND68WBP3E+75GZh9KRuLZeH86X?=
 =?us-ascii?Q?3GnwESz9ltm9hl4fGViZOwnTyf7FWy4jyg9q4EKxBgYg03DF90AxnfXdps/L?=
 =?us-ascii?Q?L9cGvH/biGQn0QAz7vpY/DCcRA1aNstaCqKfGk1klbYAnEguTb82GjV9V85P?=
 =?us-ascii?Q?31eSGx8ZqSYmS0tIhpSSgGBImXzdf0ClFDJinIhJurb2gRCU5h9LDdmQ3S9E?=
 =?us-ascii?Q?096eIuwlQQTaXxvr0HE9hD2hoBFKpWDldfn54oj8UEEnbmv1HFAUiuRCWkzR?=
 =?us-ascii?Q?fN1HB+UYtWAUfCdBjXrsXN0TLWHXLV97lnSjGc1q7awWQEMshnbDZ5l84iG/?=
 =?us-ascii?Q?U6Ae+MjNqpcoG5qDMCKKkLx1puIuy0Z3uNYMCfNJibr7Pg/nFZooWk9Lz56i?=
 =?us-ascii?Q?LCMFVmPQsNt8XlFwSj+yWh7YZClrATfl+v9xs3udQZMNp2Nb/pdQiVCIQjXG?=
 =?us-ascii?Q?YmwIJbvzqXoRNEGi5PxLU02+R1ShHH0HERE5T4B13GzB3dcG3Pf3tdkRv/7H?=
 =?us-ascii?Q?RoOngPthIyv5lxq8drc9yf6BnzVrL/nxajPOaI3gogZOT5fAxKgrvA/w5A0o?=
 =?us-ascii?Q?gEpfwxzT7QxU6HAHeJRrnWjx4iO03NMGBFMEFVMxWuigARa/j1xFPO1Dr2oC?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6c95ee-3723-469c-9379-08ddb8395b0e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 00:51:03.9412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M2tAGaeJeXtZDEgaySkuCLBscWUIi36L93WLP5InK/N3xQbzo8tfEgk06RIjhP3tv+Ld+6bu6CS5BEYYoiac5xmx/8G/E93/7EJhhesRwnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7199
X-OriginatorOrg: intel.com

On Mon, Jun 30, 2025 at 03:28:25PM +0800, Rong Tao wrote:
> From: Rong Tao <rongtao@cestc.cn>
> 
> Such as daxctl(1) manual.

What does the 'Such as ...' mean?  I thought that it meant you saw
the --list-cmds as an option in another of our family of commands,
but I don't see it.

For these, the --list-cmds, is a suggestion in the --help option,
like this:

$ ndctl -h

 usage: ndctl [--version] [--help] COMMAND [ARGS]

 See 'ndctl help COMMAND' for more information on a specific command.
 ndctl --list-cmds to see all available commands



> 
> Signed-off-by: Rong Tao <rongtao@cestc.cn>
> ---
>  Documentation/cxl/cxl.txt       | 3 +++
>  Documentation/daxctl/daxctl.txt | 3 +++
>  Documentation/ndctl/ndctl.txt   | 3 +++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/Documentation/cxl/cxl.txt b/Documentation/cxl/cxl.txt
> index 41a51c7d3892..546207d885eb 100644
> --- a/Documentation/cxl/cxl.txt
> +++ b/Documentation/cxl/cxl.txt
> @@ -14,6 +14,9 @@ SYNOPSIS
>  
>  OPTIONS
>  -------
> +--list-cmds::
> +  Display all available commands.
> +
>  -v::
>  --version::
>    Display the version of the 'cxl' utility.
> diff --git a/Documentation/daxctl/daxctl.txt b/Documentation/daxctl/daxctl.txt
> index f81b161c9771..606abc3e9635 100644
> --- a/Documentation/daxctl/daxctl.txt
> +++ b/Documentation/daxctl/daxctl.txt
> @@ -14,6 +14,9 @@ SYNOPSIS
>  
>  OPTIONS
>  -------
> +--list-cmds::
> +  Display all available commands.
> +
>  -v::
>  --version::
>    Display daxctl version.
> diff --git a/Documentation/ndctl/ndctl.txt b/Documentation/ndctl/ndctl.txt
> index c2919de4692d..08c3e949418a 100644
> --- a/Documentation/ndctl/ndctl.txt
> +++ b/Documentation/ndctl/ndctl.txt
> @@ -14,6 +14,9 @@ SYNOPSIS
>  
>  OPTIONS
>  -------
> +--list-cmds::
> +  Display all available commands.
> +
>  -v::
>  --version::
>    Display ndctl version.
> -- 
> 2.50.0
> 
> 
