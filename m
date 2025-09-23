Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9A072628
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 22:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758667445; cv=fail; b=oQ1jALi+HU3886+korGCyM97hxgItNnuiklQbsgI6W0H0ipp7vEBCPJ3HJuWoWppxXUw8+7Oce/dqQURJhmSDu9me8rqIZFe4J9+LVo2aXQJR62/mW67/A09aR7qAgqbUcc5ZwtshpS8ILBp+NyhY6BPRcGqvtUZEghoTWNEoDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758667445; c=relaxed/simple;
	bh=1ADW3Kr7FoBMGAKHJHI6wcYwijNsyPzS5MIdbDfFod8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SEsXZQVhcVjTW6iqY8uYqVr21jXRTuVdxfYvKTwIumtKwzs1QeOROcnMVqWy0yzFa2uZjdURGPoAU5XVl4wmwU0OnCSQ63clD0uyN8bcQL5Glm2r7PjQcUHmD3ssPKJy8VcDUIGQryeM/8L/37GeyMb5TW3XDJk5QCeF8Pn4Gr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KTWRzyoo; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KTWRzyoo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758667444; x=1790203444;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1ADW3Kr7FoBMGAKHJHI6wcYwijNsyPzS5MIdbDfFod8=;
  b=KTWRzyooTm58mv3b7IlUFg3bTjdJIv40qTnVHGZy8CzRY34aCel5Wh1d
   wxzgyDGPiBWsWFiCH36cUY3CWThqGk68fKupmZIfafULwe6j5zSiVJfxE
   DzW2Rpto5whb2C2I02DhXp1sbUUU1LdCT8wRSvw5mZzTer3yP+0JmlrLQ
   YsNn5WOrwQsEMfIWkOPXqXME4j9RytOM9YZgDCz43bqilKr92xYvmQWSY
   Y8JW2SLwPnqStJkeeCEPIoJmKFDkcWBPXzyFNLDFehgam3Yxluw83136x
   7w3YGJsZfJrG17vtSDbHIeGuojFGDIi6mPCW4Jk3Lmlf9lGtvCwBPVJGc
   w==;
X-CSE-ConnectionGUID: Ws6/1uo5Tj+nZlveDJCo/A==
X-CSE-MsgGUID: Pdte/bk2Q5ql+E1/boCvWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="59998312"
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="59998312"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 15:44:02 -0700
X-CSE-ConnectionGUID: W4t+qoYkQ6CRAr8dyYKCiQ==
X-CSE-MsgGUID: 6+q9S39QRTaXa+7c2LkzYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="176705102"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 15:44:01 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 15:44:01 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 15:44:01 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.47) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 15:44:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KDtNGjDvWwyWHpiry0IsfmQ2SOotqdXRi3XsL7hR5roDjbAyMkdcibZJxzaBVzFUxZkRqpZ32e8hDfF7Eo7BGnEYDZgwVxSCvI1m6+ztDQ0hNaeKgQ19O5Q7L9FvVPTDEf2WgPFc0M6GlripTfNs+ZA9KeKFBAAYZCs7yNFDb+OJfgUYzZ7tz198KC4mwMD046bECAyFfH7Z7PNI340JC8aNt1ufuTa4Ft9Tw9gfFntpnz4bCcafjSZYqWZU9ORlfCcCmOn5G6jRsDJHFw5Ujk8Ts1gDqo1hGXGZ3Audiwai5NNRAfVRWmgQN0zYtI29Dqi4MULBUqDp9dD17Nw6bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhUrODzCNYrfjvZheLAMIkJoEw+tBZZcAWqGmBNKus0=;
 b=I9znxFZbO8UG5V2tDBXa8o8gM8NWzxyL3bPrBA9jRAaJpUXrZzpLoh2Ne0zQGXeh+Jxlh6OpFpSYGL5O44hwqRIOjZ3ueqMRhZvEJy+tyc3gEqJW5QACVSmsC6hJ1qXAptkebtCA00T1ra460fBgeeNR7gNvWuL4wzBNJ5sBth7l2jupTQXhrJLsKlDemyWe7xrTgMo/ZyNtRvkbhnNYZjDV6qTswEuen6M0uHAyUXaqsw73rffjfOSXU/wfRnQ29Z67SxwbnriKjUqJ5ALoOPiK1yl8g7nPdGEgIB8yYDnaTXWUWMw2mL0ep+CMzDL/bgxCYRnieQUsW7Te57TSWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by CH3PR11MB7370.namprd11.prod.outlook.com
 (2603:10b6:610:14e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Tue, 23 Sep
 2025 22:43:58 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9137.012; Tue, 23 Sep 2025
 22:43:57 +0000
Date: Tue, 23 Sep 2025 15:43:54 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH] cxl: Add man page documentation to note the change
 to disable-port
Message-ID: <aNMiqrHLu4WDECkE@aschofie-mobl2.lan>
References: <20250917235056.427188-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250917235056.427188-1-dave.jiang@intel.com>
X-ClientProxiedBy: SJ0PR03CA0096.namprd03.prod.outlook.com
 (2603:10b6:a03:333::11) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|CH3PR11MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: 896111a5-7761-4566-3e06-08ddfaf2ae45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bojqGMNjtVa5B888FW9RTwliKB44EtsE8EBtAauLAFuxCa+gXDLJwEWHx9c+?=
 =?us-ascii?Q?2BGrv7zbTk/hvOL7lTBNydrcYU9mUa9O5J/daoU1++Su9ZBlTfcG5ren5oQi?=
 =?us-ascii?Q?YSbCPUSwfP/wcyLNUrk2W01FVS5H1QWF5D3ZHUTzM1XCWyP4XpRiAYsWAm9y?=
 =?us-ascii?Q?8d55s9Bn21DJZRjEikdCBC3QyzeTYmjGUov4mthsaVvrNiqIvGXAnzoS1aW/?=
 =?us-ascii?Q?njr6RpGPtpjjGEtX1CETC1s/ZrZyCWupW/Ax6kCudQSsSww3yGAO1G4RcFRT?=
 =?us-ascii?Q?zpuGyKvV5SFSKL6fEka5JTC7sB/Guxlt18EA5xMGhgirfODJmQwiDW9j6GV+?=
 =?us-ascii?Q?3MVymNuSzJkuWug4gxXB2btSbrpW5TIDKXPmBO5lyXNpKRRs09oKtCuzjtS9?=
 =?us-ascii?Q?PK6eU7Keo6As1x5EUOHCllXEkJz6UqqCpqxSigghRUMa5tMFxBWJtw/rAxfe?=
 =?us-ascii?Q?rtDGcdsk565qpfyq8dAbRyG7lZuNF8I05oE+xjnfLpb2QakvwxXVnvq14QMI?=
 =?us-ascii?Q?hKOhQS6GE1e2BIO4yqC/Pn0x2+a3TEVxTPf0DlhGqOMFtxoAmMrnZ3S32PY2?=
 =?us-ascii?Q?nUU5R5T3YWpu05SJ50jidLxQL9h6Am+qTYRpGAXr2HTrbgGSdtVe4AihlmRO?=
 =?us-ascii?Q?rqlBWCdjmjm2fxiazqawIACbuHVXECSQ2d8u5uDiqXwgsev8lVowypi8Mvzt?=
 =?us-ascii?Q?VDHy5WzVjWyjn5FQsKY/M7cdGeVKGdGKasxzBH01HyLcg8GHNUSGeQK+Aggd?=
 =?us-ascii?Q?Q1B6W/WwkRJ853/PeSrJEUgiPvFyIwWQMhPXEy8lQbvHY1QmmWol/+SF8oWT?=
 =?us-ascii?Q?5FIoru7bnnfB/x6FvRgBMtBkxLZSlsBEOJiPDWrAwmelN7NZIWluRo8Sk/k6?=
 =?us-ascii?Q?5ZY0RxpxRVShD4x8RoI5J4P40r6zWnCgEyx/KuEZtjnegS0RngFAP/SgCNZP?=
 =?us-ascii?Q?QdTaQbe2nV1OZg3ZLBLADrga7+JmSy/B+P7CYAFTAfTLUgQYx8xVPkGCqku5?=
 =?us-ascii?Q?AmsSsZaqT1d5ismRA6dBZ/U0y7BodETUdCulEq08duyxAa9lvzTxh4CmWT21?=
 =?us-ascii?Q?K+PSNe+Adp2Rq4D+Fv+jW6ze7pOIoJutlHX+sNtg/FCpjtjGcZPyD/9YIEyX?=
 =?us-ascii?Q?CIQBTyUSD7W0i9y+BT7k97Uo/Ywp1UpfGIIkaSKvQ2nHQr3KsKS6rMEjZgvh?=
 =?us-ascii?Q?eJ9m6F9RK6UnSx6FPqAI+0HYHSOlTsKfepPeqSbQWLP6lu9+XubeP422RzAV?=
 =?us-ascii?Q?O7LSdAGclONGVqx8Ht3rVpme1Pm5naMcriOz9Ne+2/JVJNH/aqScTkKkH1BS?=
 =?us-ascii?Q?0i9HihVFmH5PwyYO5Co04NKoyNnpsitKf0GrU2wNcOFO3fCaifMYNC4Y9CVp?=
 =?us-ascii?Q?Pnq/KH21J8N1Sqho+/1TE0B7mKJu+mmFOSjognbxUZRTF30Oy8o3EQ5Z77NE?=
 =?us-ascii?Q?3ZStdtejTcc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aE3LUvcwO6cTmpEsS7t+jMEpDMqYp4rBGywffU6x0K0j/RRVPSvOY7mle4S5?=
 =?us-ascii?Q?9kNQhPEjHVHyyHTuHuZOci07qwEGh/rwJ3Op2Xye3WNnOvvUuXwJzkIN2hr2?=
 =?us-ascii?Q?gzQoKND7BcvijPuDREwpYqcFtFRtR2J94DJttZDTAIfFUj4bKvowHANmSGJa?=
 =?us-ascii?Q?u1LwAGlG/kdFm7N28/UzoQv9zHGBw1k8UMjradKVXLCR8pJDttMEKYLePXBC?=
 =?us-ascii?Q?7wFC4HeN6GBxwrYER6WFwclN7ZTVPamnBWKz4hGwVPjoJQzdvP6EEO/s2jLN?=
 =?us-ascii?Q?C5BmkXsD/IRyQZ0PE8B1LfOBiScc5WowhqxgRDIWKN2Qh0ncWJvnefXLmnw/?=
 =?us-ascii?Q?HUySmktA1wg6Bs3I3gjOFc6zc2G5NEHR6veeq5u7RK3/Po9A6svtYDrp2SN+?=
 =?us-ascii?Q?WeFIi9pv41s9KUsIt3qiEG7EeCFSv/4gERJtmKj9Wvr9Xe53WPBibiX3hLGU?=
 =?us-ascii?Q?rBlEysRA8IeRjSm3DPrF7VQnNDFEcXJMiE/7rvS4Uol709maPUl/7m68ryAr?=
 =?us-ascii?Q?hp9EDOcRbwB7BJGTBim7VqOKI8WtW4PZC24SAwBBrq+h3p25AJKPsUXgQZH6?=
 =?us-ascii?Q?gWiGtxx6dVp0m+doBC/7Ot+VCjQ9w2vh6OZgFZKoia3qfo5rWlZd6r/RNvz8?=
 =?us-ascii?Q?PuU8fL4EJa/0Qnw7qC10j7Bm6+AlI2m0zwJBnevQp+bmHR/YiM8LXk7TWX2v?=
 =?us-ascii?Q?fdt+5CnujR6IzePRj1fCtTJHZUsZO05aqvDyCLIjQJ2YnCGfaZdwaDbZHho6?=
 =?us-ascii?Q?xouRlTHs/P540gxcmMpNZQrwWJ1fMzUPjSV/Y8oATpB0HPNU5Jqyt7Owzf9n?=
 =?us-ascii?Q?djo8BCdOaCaH6Ipew/hrfO+ssVJGS74YoE6KOp+wMtV5INoTyeXtKxRhxyhq?=
 =?us-ascii?Q?8PJ2092GxWZefBdNmj0TuPKetf9A0HqIY8xfb3YPBsUjePKaxmo5W2sJ4QqQ?=
 =?us-ascii?Q?nsc1xx5OZmnJd3h+x/VZQUp2d04UGS7F4YVrEZq/2Vbu2Xja+CUJED8NYyMj?=
 =?us-ascii?Q?sFwmieI1kMJjN3LrrzxNJH+lonsOUgYX6u2Vwlh44ON8dgkdSmajpC4Au802?=
 =?us-ascii?Q?Pjk/cOq6UoOd8CHdSJoCuaoaXwtu6439d99PRZRLWZYKllH5vHuIodv15JUo?=
 =?us-ascii?Q?j04H/Dz01ib//ae47xs5TYEEJ5UO4EIsc10cZkjaG29bWKEQLs5rFtANrPhQ?=
 =?us-ascii?Q?vDVES5mybmKZLAlSlEltxFUxk3pUYyJyAMwtGKdwP6hgXHK0G/9hRPo7ZHS9?=
 =?us-ascii?Q?Urqb9toyEphaWa6XWsjzZM3Yb2bexekXKCLJaSAVK3Qa1SF+qEP3PHpmhUY2?=
 =?us-ascii?Q?2kGBqZdHd5ZTya4dCkfKsJX7pGOCBHrDL3vN+cxd/jz4Y9SkvmfvomIC8dSu?=
 =?us-ascii?Q?bI7Nt3qCNkGLi0OcckfBqUAMd9pmJp3JWBo0BY7qOB/JipXPO3WnpLwzfmIz?=
 =?us-ascii?Q?fAaCMJKRxRRgG7VcbvAHzsA+4+ZSX5sUmvJY9OM8m3hlycESoApStpWt0oir?=
 =?us-ascii?Q?BKdeUzygLK8DPKloClf6ZST9w7CQgSOq5UP7hjtbNemeVN1SmAst3C8zU6H3?=
 =?us-ascii?Q?5iEPrykVFQg9EGmXK3vK0T+qZ170+mLxWanQptYCEZGCOk2CjR/1oiG2J5PZ?=
 =?us-ascii?Q?Ww=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 896111a5-7761-4566-3e06-08ddfaf2ae45
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 22:43:57.2087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3+MiNtiG9+P5uoFZEn5LlPAlM8fvB3s74oZGrW8PW4YomtafT8EUE1Zmhx2Y2I65BLjdmDFgV16Purm2MGFMHkFwGM7gYr/ucJM/3yZ2nU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7370
X-OriginatorOrg: intel.com

On Wed, Sep 17, 2025 at 04:50:56PM -0700, Dave Jiang wrote:
> Add a note to warn potential breakage of 'disable-port -m' option
> when using an older CXL CLI with a newer kernel.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Applied w minor edits. Thanks!
https://github.com/pmem/ndctl/commit/fdeb4de

