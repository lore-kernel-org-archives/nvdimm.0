Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090B726FA53
	for <nvdimm@lists.linux.dev>; Tue,  1 Jul 2025 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751386599; cv=fail; b=bRs6NfMlwYPGbIYmFaAN3m/sYAd6cvyWPsmk1OPVO+j/HZmRoJU9yWbbJ05Eoge1M8ga8zBAcnVmYqxoAeRA1AfX0VmTXfI1R0nS7G6J3JK2EpbinXIOpFgVGkoFrVLjPja7RK/mSnKj6eW2y7hTXx/xNyvDTmG3cU37i9KupSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751386599; c=relaxed/simple;
	bh=A2DiQZnOuhejP5dgz8xGzzgZU/7whV9z4ChwVeSiojU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZNOUeIcsWmZEKChneP64ldC4nUw086MsFc1VyXIr3iz8399MknwbUqn8XM/iJsRweIvi2GoAf3BSHZ+/dJ1iCr6Xzl0dzlFiC/5R1ZGX+bZEd+LkilUq7ffyDQOtIoBvwFKNaGj5secNqpyNvp6shF36eVNKOw4CMA6fRqEW4Z4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K2s2McGa; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K2s2McGa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751386598; x=1782922598;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=A2DiQZnOuhejP5dgz8xGzzgZU/7whV9z4ChwVeSiojU=;
  b=K2s2McGa6IDvnGQ8RS7NewSk//kotJaF6OvUo6hwydxTOOHXzj3L2Qk3
   1tWk1x5oPWgni4z4V222AhfPD1WaNPGdT3qBpoLsyQZscss2x7g+mMQ0C
   oAR6k7RGyIHT+kRXCOlfC21HfuE0r3/R5kbgIwtAmnUhoU4xPQhC7629P
   pdsowT/RUT3FmoDNtbHfop3c2M7r52XhzBzlqXSQulSTXkiZ5A1tXTOnx
   gjghsRvzY8IWWWw6iLg/0sjy6lN+OC+AhPyMxpo7HHqlKdTfeyGa2rgTc
   xAOFidnEz6qp3vhdNfnM1kC1lqLUpDoGH9cNyPc1VHtUrjm6TcwL/Mp9s
   Q==;
X-CSE-ConnectionGUID: xPDWm7YxRhigxcTGKNDCXg==
X-CSE-MsgGUID: 1UOzvW80QIGal2eCMYY5zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="52775333"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="52775333"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 09:16:37 -0700
X-CSE-ConnectionGUID: Vvi+2vGmRJmQlB/yk1+wzw==
X-CSE-MsgGUID: +WOGYb/OQAOoXYeXnJykjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="157850151"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 09:16:37 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 09:16:36 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 09:16:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.78)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 09:16:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zP+7qJGmjTY7HpzNRHWYqzxbdmuYKGCE5p5kiU41nxKbCBv+YTrp0lDsinnVJdvKPMZ08oBXoR223uagFnxveodmb2MDsOO2BqIKw3xU9IyfhwLZ5VW5dA1b5bBf4YYw97xmfIuMSgLOlMaYIDj/VkTn4KbDvqaZwuuuWTYHxQ/65hUDrfgLH+MiY5AgqusZzb+A4OsADurS875NMBMqtIF1mkBc8QAdhZCE07zZHd9f1t2PundU/2np5AwXpG3feeE3h0Ze37++DS517H1iRVHS6AaqPAiZtdX+t/viJvfoAP/0Exip1erb3bCXsOSKX1q7p5JOmHksEOXe18NAQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnavLTf3GXANfpcu0+1NNZgdxyFhlrzLgiOYOMRhLK0=;
 b=yiyhHsSeMFRxFGVjwR9BHpyAmP8Ft3egkgZbrE0v6zFtdflewZuCm8CPtFar3k3I7g6uSx9zeNwoqrikegtoOrdXOOxd2xlNg1n6zdrkMjZoW1LYUQq3gXOcvg8Z8GbOMMWq88GmQugCoDW2mUIdJHzqo+q9ZIkzNEd+rCAlc4ajQZWcJUWmJHjH/OermroTxaSj2yDJVTCDTg1iUcKdM4xMxtQfyd2I+JT4nXtYF070xCrwRoMSVLupDtbyoLmAvOOC0WGUUfrY8fketU/9ApgekNwJFrNyn34tJ8WI8NMbe8oenvALXL8pPOuGHHGZ2edQY8k8E7ITXdjnmCYoBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by IA1PR11MB6196.namprd11.prod.outlook.com
 (2603:10b6:208:3e8::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.32; Tue, 1 Jul
 2025 16:16:15 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%4]) with mapi id 15.20.8835.018; Tue, 1 Jul 2025
 16:16:14 +0000
Date: Tue, 1 Jul 2025 11:17:42 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v2 1/1] libnvdimm: Don't use "proxy" headers
Message-ID: <68640a261c7e7_30815d2944@iweiny-mobl.notmuch>
References: <20250627142001.994860-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250627142001.994860-1-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: MW4PR04CA0370.namprd04.prod.outlook.com
 (2603:10b6:303:81::15) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|IA1PR11MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: 485fc87a-158e-4fb6-c112-08ddb8ba99f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?J9a6d2x+FuQwy2jEcH8K13gSvQLeEiQHJrk69YTgsi9y0I/3MdVRopyMkQWD?=
 =?us-ascii?Q?TMd5qNkXE1QVocndf6FN1ybbQM8mBn/wOBePf2r8x64MmRMvDLCWIqy+p2Sd?=
 =?us-ascii?Q?LabDDhgtUs8mOmQ/SqzWzfUwRrhGryP2KmesxPs0/gELL25gHFsjTaEOl6Au?=
 =?us-ascii?Q?2nEUROY5BPXerd7Wc5Ftd+W1Huv+pXpBCCEntVzGATWH1sWd/hgKEVp8/SlX?=
 =?us-ascii?Q?gO9NvOOFkeKvT1AUHjMhlVcDdnsxJyyC1hzlpaeOPq3x+4rjbnAW7t8uWCDG?=
 =?us-ascii?Q?nIzH4lTlj2Sw7FAFMsoR414t3x3EJBZiLnflhE02JFhCosTpWzbNPG5bL4aI?=
 =?us-ascii?Q?bXyxLUaJ3MWGgp83OhYP+1IGmMtvYGMTWm1EluWmksfhtPQcmWN1kLRz6XHf?=
 =?us-ascii?Q?uX9Xfuu7RrY8CqdT74zmjo978E4KpYMmHBV+JVtD1+aPR4UcAJviROSXzyXr?=
 =?us-ascii?Q?Nrg7JDG+WS/LGT262kOMH1SAqI/CyW7gaA22KlB3Dufc2N5PcPlwzXDLinmM?=
 =?us-ascii?Q?kfpg+hiaXkpRSY9Ks/7hpw3duroJxq9KEhIXJm6oLetVmBOlG7pIU1RM1IQv?=
 =?us-ascii?Q?6wnL511dLlYIHmmeejvD8Dak5MpLO8JSAq3d6UsBSAsMT6mGcBMpHghlAFaS?=
 =?us-ascii?Q?qFF+Q7+cLV2sP4H/B1CvKKF4cHGkX9oueIR+CdEnzJMQuT9yMCiLslvbUcuz?=
 =?us-ascii?Q?TJMg5lR67C9ufORK4mRXFHyuqNBMkgjXUfVf6iUwCtv8UsJIMtvJqSawDjWa?=
 =?us-ascii?Q?jc2DxOg8W6sq88CRNK3j3iEnUZP9RlKd4PlDoYW48lHspREyBCV6w8PSmU6Z?=
 =?us-ascii?Q?z4NL1mk8OFeSpL7ZnhAzi9Anoaui2SezzA0NA4xiH3lXyqul9XL5TC+Nt1HM?=
 =?us-ascii?Q?onByFO7AL6mUIBu5YY4rFQ5yBsWrIHW/twG5RGXlCU2U6GPgP9bw2LmxIuiI?=
 =?us-ascii?Q?tuM3UJuxBKZWr4MbJC1CJ6leqPPDumeXfzpB1m4Gfl0I1IX8ypbBiVtcI7ZH?=
 =?us-ascii?Q?6gs0pMvPTPWvhlYEmRsXq7FTQzKnCQa65Uw+nBiT6rzUIcnK85eoDVr3FMC/?=
 =?us-ascii?Q?tEIAoga7JjMLqSVzcEBB4I00kBaMdamzsBFlz+h2i61cHAyF1jdKQKanA8v5?=
 =?us-ascii?Q?7kLd5s5hNFNlbKFrPTq1HjhVkKVRUn8hwdpt8iAnU9B0aVNUV02JB5qYWXhz?=
 =?us-ascii?Q?nPVhzr3th2wz7oA14B99hKzL4BjODJVAPxf/Utc0ErL091/eO3gvVDIgZUd3?=
 =?us-ascii?Q?wctSrouCrTgAXj3cruuQUtk+TG9Fwu+RcyyKvyeP3kBlzqNTRucG9MyuxjB8?=
 =?us-ascii?Q?3mmrFrEduKtOhx4Wo/YBdzXvRYbs7kWXCswKAXqDBc5iJBrv4fcmbTpdYkfW?=
 =?us-ascii?Q?vD5QqpNxoLk/6apmk/AhgQr1uZ3WIg3hWgexbR31tRsIcXRFv+Mqo9b824oh?=
 =?us-ascii?Q?225T61sDuVA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SdsVv60bxCt6D59u1F0O9Cb9lc488ypRuhxs6e1DgHQXV+/M0B/rCRGQ74Bk?=
 =?us-ascii?Q?//78GOfT79qFLxH2OGdpWjinSB+s5h4xzJFNvKpeOgKGTujdxbTilQ9wxXtn?=
 =?us-ascii?Q?9bIFBPNhonLwjydNmp+E4KmucLTJjDym9Wzi9w5kvX3fpWcLcwRY9m0+Bdtn?=
 =?us-ascii?Q?WMTWkwtHUNDRVrXS3cLPRsYI8H0u+SQVeQ5rwh50Ln4xWnxNg3MARNmQq690?=
 =?us-ascii?Q?ueoBp4hpjTblm+4XWTiED/0FFJ1CLx8UNGrkmHl5pJ/h67Hrp4fOJTmxHY9t?=
 =?us-ascii?Q?5aCVxcyQSu6ijxj/pEkALoe5iS6aNNBOJfnqzM4C6MDgtleWCraVlxZS7qOj?=
 =?us-ascii?Q?F733szTvvXA5TN2VAkqqzwOnsLjfLEY19rEVERFFn7mTimO77/HHavlBW88w?=
 =?us-ascii?Q?BeNShn4iOYjhTZibcSMp0xTyUZYBRU8eNQrqvbOVcoB//3YdsNR5/J+4RNsW?=
 =?us-ascii?Q?O2wb7Ywl9YA7UzOsfnmYRGTGXf+0dFKjPz6xjj/qCOq8jcuHA85nsLxHNX9o?=
 =?us-ascii?Q?Lq6F3NCk14nEus9ib10LuMSPPW8S7tl0jRC2gCbxkVjKQYJu/v2pw52HqYS3?=
 =?us-ascii?Q?qz1QVhKIJtGOWST8lUD6Uwki9MpIUDe9w2/RbgOJnKGfF3yDsLX6As8p8HiU?=
 =?us-ascii?Q?/+eD43GxDB2y7IXkK3J+25X4Z7WbYeNHLLCSULI5i1f7SyBSWbNlv85ie7dw?=
 =?us-ascii?Q?ZSKxowd++KCndW3lQs4dxT3TKuarURLegxyGUjrw3nSDFJuB2+fmPOvCXvG/?=
 =?us-ascii?Q?hMWfYgQaq8SzJtWDzRXOe/ZIHA91XvPzSWVyPH1dLuXfNFS1qdcCzAMw24XH?=
 =?us-ascii?Q?PRCtxM6jBfMEeIxx95zYTUTDqWMvXinMV0mmXsB4ERjTh8o+HfGbNtrmU84l?=
 =?us-ascii?Q?SFZWV3zc0EjYUuzP5UtOxqk8sxcjY+2uHx42iS/JTDscYCsNjdNnE4dN1v8j?=
 =?us-ascii?Q?CZVAqYNKpGrdJnUx/DnbboCs/zam5pvbo6wRdHhzoEr+8dkp89in9VEdisMO?=
 =?us-ascii?Q?8LTa0g2ZeqaWu2zex3AAaiShiczbpTJ1MKWALgUiqN4sd6dPqUEOwaKwgHwp?=
 =?us-ascii?Q?+3Ebrc7XLJ1flB5rY/O35nHt9NSjlO3g5ZOQ/F82Eu3kK+3tOg9plXVdQlTR?=
 =?us-ascii?Q?5khB0cPxCh3l81h9AB1zh7NYDn362oHp98FLoyF0COra3YtaXIPEkU+lOn5H?=
 =?us-ascii?Q?t12LxpyNF7SF45wOBLHEWglvUqBNnL9eHESyjMiXlXYwZ81YERm1oNbhIzKQ?=
 =?us-ascii?Q?tinubTx92o5U7feahDo1FPvgR6DrJ/T5ldFsdg9yKrGcAKU6i3nT5rHHUFtx?=
 =?us-ascii?Q?D/4UEGANlC7yyG+3vuIWXnW/tEdlWC7vYv215FoUHrtILWnm3bY3WeJ2S/+t?=
 =?us-ascii?Q?Gjq1aky4o6UIQ9Sy5DPTBKes7ScI6lBfnheSMu3UIWyy07uJLA78uA9j06qu?=
 =?us-ascii?Q?apgLzBx5VZt7Dtvw0B5GbQvgymZQCOAI80yAjZORtDppekURhxsRJGo3e1mp?=
 =?us-ascii?Q?S9QfNHyScWJ9jFYaU8xJV1tnZPyO/TfhzbQC0i/2NE1aGDHg4t3lPLbGLI5q?=
 =?us-ascii?Q?dUe/HHpn0Vh9g6AUt8t0gzDAfe8vAAxfiBEnhIoE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 485fc87a-158e-4fb6-c112-08ddb8ba99f1
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 16:16:14.5628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FI5CnBNhLMJuAkQdh9cs7HD7dcYRj/XsMfwQlWfr/I6MJsFCcIeMxPocTnNcD/multWKSNhWvXTfc9mtWH4U3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6196
X-OriginatorOrg: intel.com


On Fri, 27 Jun 2025 17:19:23 +0300, Andy Shevchenko wrote:
> Update header inclusions to follow IWYU (Include What You Use)
> principle.
> 
> Note that kernel.h is discouraged to be included as it's written
> at the top of that file.
> 
> While doing that, sort headers alphabetically.
> 
> [...]

Applied, thanks!

[1/1] libnvdimm: Don't use "proxy" headers
      commit: 536f5941adde41c99a18a0ba03b457adc9702ab8

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>
