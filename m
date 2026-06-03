Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D5C257825
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 00:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780445771; cv=fail; b=knoyq/oS+Fu50GjJfl+BZOkKTmAt/rXGc9dLMXMcyaXITUSq9ZMKUKAlQ5/Q2BF5D4TA28HR+xh1DMgOAHXfhqmoGVQeis22eK8g5ZvKG7sT/0C77dFXzPcYMDiO2337/Ndgx94+Z414Fq8zqsaH9xRCPU0cinZZHYV/M3sJ0Cc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780445771; c=relaxed/simple;
	bh=nJfsztF/jUerqN/znE7ytwF0m9ryS862i2TaCc9VJjg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cfU/mdy979S8kxl5KANsBSMDgOVuykzMASnYRO8EZX1gsEAasAxbsgjMSsXeDAbdpiLIa8d1pclJ8YAKP99DOpkKWRdf3qqdZNIeqmVHhTsGHpDiDu84556I6qUqdYsDWB3z/IlqeSLVbVK9TEsfttfC2vfEX74XPCeK/oHDmZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m0TVkGYa; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m0TVkGYa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780445768; x=1811981768;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nJfsztF/jUerqN/znE7ytwF0m9ryS862i2TaCc9VJjg=;
  b=m0TVkGYadBGYXih+zDrV1gM8g1CfyO1kFSillhevDPjo+3sO8SZKgk2C
   BjIoKwGrStbjRGCnxZkXKLpvZpZM4D2w52c3DfoGd6TnMFKhZap8VTClH
   f5NlxNn/gc2ZtkaFcHmrcbzGO3+UiiiSanyD5ijmXZ8Re8bbduktX+26V
   0t8iPFe4pr821JA2W66485vAlv0t6LMN8cxessqxJ9OmY/gbTD2Og4F/S
   sdGeifAUajuB/sxxUZnohkstHZ5/ClOOvabU5TAUayYDiNVeZRt9bkg8m
   GtvIts1M+mockjf1Has5JWVUkzr2GclAO4HGnLArgDmjUHRhg20RuoLMo
   g==;
X-CSE-ConnectionGUID: ScH2SXkrS7KtkHV/NcVa2g==
X-CSE-MsgGUID: 4gAGCeRASy6il9javCA2ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="81304905"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="81304905"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:16:05 -0700
X-CSE-ConnectionGUID: vBxjwFXrSXqMytNEiJ+dVQ==
X-CSE-MsgGUID: DSQ5c4SJS++eT5bpQEqjJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="267689786"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:16:05 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:16:04 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 17:16:04 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.51) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:16:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PPuDEebSlFKo5nQa7mjoEnn37A+jXUYUAIVte3ank16RQTgT7GD+x76cD5USqb+PtRfE+pzxnSWGsz3rhPeoWeguXkfNCHgzgKa7jHqgZoo3OVH3XpP8N0N9DaeRpORhbersN5DoVTxtKt43dkA6uGrBL6z2LwAyRGAonIxBMcenSkNsNwbfY+EuNltIfEBrmkwKF3ecQFF996S2WF8kxFwlQyKZ7bBtAsjdPmYA1T1j4TmuRsR2XvFCFo6PDqRwbg0vmQIsyMPtDl90B2PT8QL73xKHUpIk79fbHfBgpC6RzKackZr+PqsfQQPhj0XY0FzF6W3TTOyhThUBX0pJKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UaTjXvcA3RJm1OjtlJFP9fjPflmLFtGuELtdBJXZLUo=;
 b=yUAnNOAGy3ON7/ECA8L2C3OBl1F6TlIInoZBoJWNzibNmsRj7RyriNqbJbmVvAKO7C5HVPqSJIVTidD23xNDjMRBXuJN2vMlAILAOF7Q208g1vLxcfacoBbkYNoqIPhNKkrXWwr7nVT/BNm3TYW3i6FtA7swnshBS4nKtXukqSru+dcsiv93I4WLJMhiXjvnKfiJtIbtGvCsv5tu2k4GmFVwizwwUHi9bliWVFWZg0T+1eaNELF0XFP/o8STYHivVxMLEY5fHkKdPhVLXAGphkevRMOP6vUvZIlIVzIJk9mR0rmmoz26hH+vneiYUU9mIyf3VvcDNtjN4FJ7BT0ktw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB9511.namprd11.prod.outlook.com (2603:10b6:806:47e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 3 Jun 2026
 00:16:00 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 00:16:00 +0000
Date: Tue, 2 Jun 2026 17:15:56 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, John Groves
	<jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Ira Weiny
	<iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V3 8/9] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
Message-ID: <ah9yPOE_za0Mo4X7@aschofie-mobl2.lan>
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165126.6721-1-john@jagalactic.com>
 <0100019e79cc4e0f-26041b0e-3c38-4641-9e36-c8964a7f0e89-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019e79cc4e0f-26041b0e-3c38-4641-9e36-c8964a7f0e89-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::16) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b2c36c0-62b9-4614-5392-08dec1054aca
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: gSy44xigBGhwMGGd/vMVZkM8wWfZlZK1pFJopecZOFSVA89hx2QskFoBJZ3fuCxzgO0eNyaoGbBlx75iI45yJmBFGIKbCEMNswBTRpYW9Ve3CNKcdBhZUhkwR6t0C9jUoZ5/forOH00TmVKMeTxk3QGOmhbVwsG6IXexA11D4gUMSnD8pyN6YLU2zrSroNLRUO7inCTF1ATJi70kATpeUnuYKsOxSSM9StIRKWIf190F00AUsh70kTmI1/t9SgZ6a55DWfVZTbnJ6pM8Ir1NJHYkvPmu4RTlRaWEbrPxclQ5ywOQE4Tq9D5am/3h++/lkZdLlCGfI085o1OJSln0aDL6yGJ0ufSQDLW98wrU6ngO64n64nhs+eZl/KMj7BBgbAxRwqSQQfgeJYqmAqF2emSFLTgESIkvnDtSmontJT+aruMP70ykNsWShDRcHde6sjifziykBCEfQO3V8UJnK5yEbhzHa18kY5OTvWtoLuC8CXPokVr+vNJ0Vp8yxnpubNjDu4d3RVVq0v5g+cTbCFdO1SDZgaGCHSizMj12U7QqHG7Fn+4I6QXYUtgiT7uarXHlQuvnvKLvoejO1e0g3pY7VPS8cto2WiQVMwBrMZ/yBOCvbEHK7RPM25vrRM3CDkdzSxGkcwT1LBeLgS1IYXtF24GCchzJmxhhCXl1NbcLjszgco7h4TuL9d3qJVIc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?das/BQ3YWgrU4oJhfl6zDz8ET4y5dHsoiPhOpPOiQJL/8gXrej/MwjD7hW02?=
 =?us-ascii?Q?a4IbWmyyGt+Y8oQUPXYhZmakOKh8bFDLv8u7CIzUOTUILeriNGo0Z3v+TKOi?=
 =?us-ascii?Q?xjUIV3P6Nj2ScijBeVuJSPHiV2v8oIn+MtzU30abOMRtHmQeQFtZsipABSuk?=
 =?us-ascii?Q?cvS9CXazTLiIfeQugiC0ghOvBhEhjB22o1pEm2vXRrrxZ9Kuu70qcbm5B1uB?=
 =?us-ascii?Q?CSrCdimEUCyHGmtEThsIXaLW4v6WDMHEhr2hSIke9vehzyEmFedZU6Gvys9r?=
 =?us-ascii?Q?n8ZGi7mo5aeuqdzfcx6CqqEOcy4eNqmO1JWqHixjNOE6AdGUmAjmSJ/48PbQ?=
 =?us-ascii?Q?a2zelKmNWiLl28o4i/9TVUESCqV9p/edhJ+z2K7qeEyQkU/G6H3fSJgInObv?=
 =?us-ascii?Q?102D8Ob6zoD75JqSd8nja128B2L8ubUCGBmehRisCFoWTHBVlcMpib/ioc87?=
 =?us-ascii?Q?gsDEfCvuzriy6HDrR9l7YDk9ctqamYBIs4dOKd/rMYx0ilZSGWOteL+yl5+z?=
 =?us-ascii?Q?0SriL6hyOG5IyqbVl9fPrui8Ey03kg2ImavGlvaYxnnoRmRK1sf1pvC5As3Z?=
 =?us-ascii?Q?PicKuexCowlmiVhW1caWkjkdJRPaaeEv9M+kSf8K5C349P18CeSHMhsml1TW?=
 =?us-ascii?Q?4u2zvkFTY8LPTQ0F1izg0FUwj2bAm/+jow46yjfgWV3WWUx0Nc8JUW09/dyb?=
 =?us-ascii?Q?mqfnBWaMwKZ8QzUm3vRlFF1J2DnwC2FTk/zuIVosKKi8QU8/5NezkhlcrFye?=
 =?us-ascii?Q?txCFnarNmnnFC61q0Yc5BW79jYBVSnxCRkZQAzc1BYLC/cnVGJ8sq7uJMQ4+?=
 =?us-ascii?Q?XxYMHny/yn6dlnET07ffTiGts+RpWAhiEa2l46ng+8YxVJjenyvIM2cfdXy5?=
 =?us-ascii?Q?7AnvGCgAXHDd5mNmFXaFakNH+uplKkGqeBm1RgbgZhXEaRNGPxQqkP0sp8oA?=
 =?us-ascii?Q?ovrFq7Re48cvluoteHm+qpGSNuZYFdLAnLBOF+xuwM/k1t87jj0FFm7Vx1Lz?=
 =?us-ascii?Q?KAmRZ7v29Fzhng7AGi1kSfpB1DNx/iduGNqMd2ZeL92i92UqkS/ofXEDBCA6?=
 =?us-ascii?Q?nTaAQLepWLtVETvADISp/Les1uT9WzvtwA73GAxvp/nUzZBUj92jN0hqvQoN?=
 =?us-ascii?Q?XE8BmaKerGkTtCcoPQoxF1lr4uC7rpbTTE1r1h9a8vuQkFxMrCvJ0DO7vats?=
 =?us-ascii?Q?fWVHKSUrkXnzfQjqHAs3gmr16LWesXiIng/gO52iFVapiPcJKcA6FOsEHlxQ?=
 =?us-ascii?Q?UeQRCT3x6+cwVByG6HJIQtpM+rcMf2x7LiM+Nfb27TE4FqCKF0bCJaUCUWk+?=
 =?us-ascii?Q?bLAzDk70p7T1im57EkZPkceM2ZfmUHtefLrSbEbapdC4aKjc+uFgtyvt20k5?=
 =?us-ascii?Q?3cpA91BH4jWdW0KwBFKgm7DBHanqYeEhbZAE/IKDcPue0IDtou9+rFf7XMea?=
 =?us-ascii?Q?qFO/rsR7uXy0C47/eLhqqSUJjPKpeEurzXZ1ds1zMvfJrGT7rSYOdN3GBOSb?=
 =?us-ascii?Q?wh54jnE/fiS1TIJxkcKLBHNlbxqykOroRA3rMQx/aWXbm7ggtEj7qEBn2N8O?=
 =?us-ascii?Q?NA/p7moCSl76nemdnRD98EXJwFeJEbPqgdkW4iOXqUAMPJduGjCt/bQ7t5Er?=
 =?us-ascii?Q?puvZTuNvnaGl964CKDv63Mc/8+70P6yoiso8+oHw2GZUEEbT/TFr72rUlxIT?=
 =?us-ascii?Q?BO+kF6pE+mLDE0yi5ZUacEN37Xaf4NYcJ4JxATkHVhqgr0kwMQwaXZQxW7nL?=
 =?us-ascii?Q?MhLczeaiE+xkNVIi1QwmCEMAq/XkxmM=3D?=
X-Exchange-RoutingPolicyChecked: bBuzS7C962/RyuPsgeDNNo65jxeDLX0mGZYJ/5qJb2OU4l3eWE2Hu60nMaJ9enMkSnftYcoNM72jDH/WqztxT6hr4HHEuaW6AI28WLuSOcXEVv41hKFeC7LVCADT2SwLE9r+KGTwF5kg/+72UlNfwiL4rEO8BMfE3mvhYdptu/DPmEv1tkBf0ewZkBoYAPWJek/ifui9G4eB/JWPYbfvb4hKjL71JanGceg6KETULBxagTIrdtIcKeOxuvS823K/cKMlxV7dN+7a9kezT7YCIZ3DWePljRwR71LvB30QcFjHdTkn6dlYQLRJ9j1g6P9V1i0KqdykPP5vXVv5srpblg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b2c36c0-62b9-4614-5392-08dec1054aca
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 00:16:00.8162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o3Z94KgRxvu0n5IrLQ/sMyK0Ab88Bd0EsJ6O2qmH5X6ajxeBzmjcU5GVCHO9EFb9qBhG888VaXderBdArhQN68OW0tCWf8Pt0r+bCkktfk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9511
X-OriginatorOrg: intel.com

On Sat, May 30, 2026 at 04:51:33PM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> This fix is in response to a Sashiko review, and some subsequent
> analysis.
> 
> dax_dev_get() uses iget5_locked() which creates a new inode if no
> matching one exists. This is correct for the internal caller
> (alloc_dax), but dangerous for external callers that look up devices
> from user-supplied or metadata-supplied dev_t values:
> 
> 1. A new inode is created with DAXDEV_ALIVE set but no backing driver,
>    no ops, and no IDA-allocated minor number.
> 
> 2. On teardown, dax_destroy_inode() warns because kill_dax() was never
>    called, and dax_free_inode() calls ida_free() for a minor that was
>    never ida_alloc'd -- potentially freeing the minor of a real device.
> 
> Add dax_dev_find() which uses ilookup5() for lookup-only semantics:
> it returns an existing dax_device with an elevated inode reference, or
> NULL if no device with the given dev_t exists. It never creates inodes.
> A dax_alive() check under dax_read_lock() guards against returning a
> device that is concurrently being torn down by kill_dax().
> 
> Make dax_dev_get() static again (internal to super.c for alloc_dax),
> export dax_dev_find() instead, and update the two external callers
> (famfs_inode.c, famfs.c). Also add the missing CONFIG_DAX=n stub.
> 
> Fixes: 2ae624d5a555d ("dax: export dax_dev_get()")
> Signed-off-by: John Groves <john@groves.net>
> ---

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
