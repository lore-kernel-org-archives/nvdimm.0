Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62190145B3F
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 00:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780445686; cv=fail; b=hc1BDh4kEQ3RmeWFIRl7tlY9kBe1lHcT19lZAztX+WYXhr88lKP7s7zeKtOOHjFobz2OKeqE31r71fLnElng9C4kI3n0JYifqRVTCv5mgJ0zvxEbr8PcXDVNwD1Vjr9jYWpYlSD82yYfjWAA6l4i2pov+Zwx5OH5hlfmhZYlzFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780445686; c=relaxed/simple;
	bh=aCIDNPuyBL68PH09d8L+N4EJ/xfQMkTD+NsZYRnD5WE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=otJG86aBoWnXBYBmHKndfSsjrXtGdI+D0GYZGgdAl7pMEUxYdGvRuJMcJ8R6s/FtdBb0Txs+foY0BdE77haic3+2l6fa2jKtKvKdpbKDmAUuPj2FpWNq8h7BNw3HyGDpuOkQnm1PqMa6rb6FpSTTGC81HwUTfA9aL0lD7r3ynHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YxDmcGib; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YxDmcGib"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780445685; x=1811981685;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aCIDNPuyBL68PH09d8L+N4EJ/xfQMkTD+NsZYRnD5WE=;
  b=YxDmcGiboya5/Da4XkqnUOtarnLZzSCW0mGsAu7ia+q1a4FbCyaVODNm
   R1TCFINkUStzrhVgyx3gW6/K5zIWWAOqwtRv7lNeEOY0fWlQLal6VCCXW
   xW7rUgAQR2aD6FisVo2Qq1Uw/AzzVHv7jufl98Ne2BUmP6agRiBSNId6n
   r5Zpf154izvk4aw0F4Q1FH0mFn6GQ0fUddVdxD2XdK48YR7FEGbXZuWX1
   +IS61Am0FVtBwzm5qV6hvqRlJLbYvYhE6iAeHPzvbLR6EVNV/i2kiYqvT
   yNsLjzCmivQKnu9XRFxoGHrqt7a1vtCEEH4ZOk8XX7Irx8ugptUKh0lN6
   A==;
X-CSE-ConnectionGUID: 5e9CC7vrTk2axSQdqA9Nbg==
X-CSE-MsgGUID: oGFNRoCeSJCasGClKDbk+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="83826271"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="83826271"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:14:45 -0700
X-CSE-ConnectionGUID: RuxDIzsjQiC2LM8cZ7rU1w==
X-CSE-MsgGUID: kaBQMqBqSnOcCkINSRulQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="243009265"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:14:44 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:14:44 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 17:14:44 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.11) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:14:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wzcNmet2YcE46enMgysBcWMt2xoa+qmE2CH5nOQT06Nl6TFSxr0wW7QKT8k8n2b7vH/EqdgZ0dM5SRC3C3UUE+hthYQZnA8zWLNV8ACHu/CxxUal9ag+64ZtU5wIZ4MUG0In8Gv8PmjDCCjUDE8ztNHIRlGOg3RbjUIJSFO8mcOl66IeZJok6rVwEMk6jGXldMcv8JGleb+qDs5p4E0QxWGuaV32ZlbknUDqNlIuVvXSQIAbsNRwcrSF8n/zAQjlsgWVgrrizMcKS6JDkytag93FStEJ0G1MdB09QoQy4RgtWa5FKA80Rr+ilrGKM0XCnL75bBtLlwzPWc5wD6IbRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlUdVNkkdiDMn5ESrBwmogoTr2+N4RvFUdJPzl52fjY=;
 b=jf2Lw9kAALeY/SY2O4F9F1Do9azkMd7Tr017gYnb+d8oob274NLz0FZPTyAxwHr0jrUqEV98tw3emMw7iBGE4uleSejF+ZELeM1OlFX9yqRGFTkEXgRgKc2XQzesDgb5VknbMaIaTjk/JZQtg4p0tkVJZf2Bx2uq54HTmVgZkUnxItkjV8DOl2XQ2/SerYeLcoQ1VsujBMQVYEBGPALlrd/QTX+Uidj6o9hKW2TV3zLSvaKlZLrtEgtekC2Lkn9ubWFn8M8ScKCterZ+Ma9eTgMcVgs8WUFTUZxY9jydycmyhpGo5zUPYqZCz62zCjSo8DN2oA5JL7rXWL1KSPw/3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB9511.namprd11.prod.outlook.com (2603:10b6:806:47e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 3 Jun 2026
 00:14:40 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 00:14:40 +0000
Date: Tue, 2 Jun 2026 17:14:36 -0700
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
Subject: Re: [PATCH V3 5/9] dax/fsdev: use __va(phys) for kaddr in
 direct_access
Message-ID: <ah9x7FHl_f9v3Vsy@aschofie-mobl2.lan>
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165100.6670-1-john@jagalactic.com>
 <0100019e79cbe087-d11f77a7-379f-4355-b65c-52b3090e9ddd-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019e79cbe087-d11f77a7-379f-4355-b65c-52b3090e9ddd-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0PR03CA0053.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::28) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 992435f6-fcc5-4547-f958-08dec1051af7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 6sErCOHq3+MkXTuwpPzNNhQpiKFIHFXfmRhm3k/lJcubLfWfwfbDQqas9c9OTFttbbpCdPu67cHYmCUvCiFwa2g3uHnQ2oyqGd9XTLZAszDtXIjvURGLsVahfnZBAd8ZBLsQnUJmnx3fnLXjWrf8v/2asw/bs9CaQFlgdUZWNxzOhWBLdlVx+9f8yDPlcvZf+ojOaVZo0N5KDCbv++kE3b3WqVJQh1Prx5THycblHAPmSFu121sRtpm7zEcLKKPN9AGlCenX7qZ7CiQTWkTIpRLAKJ1S5M3wyfNwW5Fi9vTZzrcWLtFxjbWOP5ehf2HycMcDMFOfrj8Cl1rWfE+tXQbSdG4xTcCDsSWNd13FelAr4A2f1Tto8yzC3r2KVQdRatfOhVJcPcX0LTh5IEfPgSkUx6aWo0TeCknWi0HGxGM66Y+038zgibkLEw19LLQmyuT0jkK4tkSEU1vMj0+T8Bs+ObmvRoGR2zYgM/3BhTXAmWwPkrSd6oDPcNwv4A45y4bom/VC/0J1FpxiXnqPFBL6M+jWiwJUUXk5hGlXBFs+ZIsL1jhqN/oxKBrTECh6+80jO/yoRft4G/Ru0c9sAc6u5YTruAbEQTb0j6Ez4/g02zGbGJvacMmy3Ywnqxud8ho8f7yFgnWIOe8cE67PtUMxVYC94cGGGqXXbFwqDOv2ya/eF0Pv0WPYsrzung/M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EHssW0PyvLdnjCdW83qqtcw48SGcFcLMzm09Cz//0EZweWvX6ClPpvOHa29u?=
 =?us-ascii?Q?WiMkBShWhf9vq41S4wXsuphaTsbhHC6U4NfBMZzkm3qcP9LioSwB6wLeOPKB?=
 =?us-ascii?Q?nHTmHSP3Ow0+CUQlxASo3VG84QkeUyf4FmUQxWXIs3h9+ZUwGjyTNJXLbd2c?=
 =?us-ascii?Q?H9wgBYl+BI6wTHQlTTa4qWYzhKKrac8AQAUsfjkWDIz5M0nRUvoIm4b/VezF?=
 =?us-ascii?Q?GpLSBWYxYJrA3mC9u64svi2ulURLDGpJ8OjCGVVR1jVQwMMAh668dWFNGCvB?=
 =?us-ascii?Q?6OxPOlwrCFiTpttwnaiu50/b+ozXvxwDODFoqC65RqmzCPWt39bMtnTepOy6?=
 =?us-ascii?Q?ROm3SkbE9WX3q7GwWUeuCRnjn8IOEYyqyaAln3V0Oh5KAH4SZnk9AMdVoNO4?=
 =?us-ascii?Q?wLQpUWxRjr/7ncc+iwvBTvpmXIjeq52IOuB6l8brjeiwwYw7TB7Bji/LJ8/b?=
 =?us-ascii?Q?AT2kcuX5QZOklbLbSJ0Xuu6hhrBT9AwYhF37d4cq2jzBWKzgyDpcgBhwvw+y?=
 =?us-ascii?Q?P/OV0Wf1rt7u4cp1Cn5qQ/TV9+FY+3PG7fcZdeHoe/9NKFeJuvxmDyjBYPxy?=
 =?us-ascii?Q?TuMi6vp2GX75ugRr/9XH8Z28jUEo6QemSiT2f5f8SpWiuZw6wh4KNOwO2Bch?=
 =?us-ascii?Q?km69+jncB0BTNSwQVHGxuYaVDcWyD4xUKI1IH4gWcs4JHGFyF+RL1f1HP2yL?=
 =?us-ascii?Q?P/W3rO6bOyQlsCvd63Qjj0/teS0vsuN2of6djKalj6W634llUY+aTaZvYeqQ?=
 =?us-ascii?Q?Mp+H94zQjt1ugY/PzMUEM912P6poV1Wk7raHtsqE5lYZ/FSHTyIMWdpInTXA?=
 =?us-ascii?Q?ri0tXwGLI1T+M8iTnS6Yq9ITt2ZBrBLZYjLXv5jfRvAzbp3iLOq3TPHN6H8v?=
 =?us-ascii?Q?JG1JMvfs7sN1V/BLDbD+Nn+IWernpTxrNxutMJd2gobdIBO3rqpa3OiARhBz?=
 =?us-ascii?Q?EWE0c5fbvhjnso3hmkhFUb1rq9NV2p/tTs2jW86gxRzSwzuXPtKPo+HSo5el?=
 =?us-ascii?Q?iv7tqCV2davYAIE7EItdDAB95U+vWx0TRYBu7wb4Yc7e2uyDEpV0JKvLSdBW?=
 =?us-ascii?Q?Gm4XMdaRkKr/IwJiaUVcYCEYwCIeKt+smotcZyh1LStBMc5zI1x4e23lEbXp?=
 =?us-ascii?Q?QZ5PoB4gu4LgDa+FCyDo5EBEEbbsBH1bsVx+NwEsZHDLFAfyht2YZmZDBPy0?=
 =?us-ascii?Q?rdypD5ahOEIPWi0qqgrq8kpB3TJYMfgT41WwaTbLMFLdTZ+1Je9uygAtu6wX?=
 =?us-ascii?Q?0NEDLbOi4EtexNSu16kNpJ+tV+3FN2XFebh0WYrqmA6TcWj84A9gsj94n4gm?=
 =?us-ascii?Q?KiDrQFDWkGBqamVxXGTDhHPTeoBX6H0/CoWOtEhgW7JZL6BSQNNRL+Zcgo3G?=
 =?us-ascii?Q?8MyOuqH3xaoWRKqk/wtgivGOuJ+A1Fh42LtN0E9jYP/PUT6CxhtiiTTzfeK4?=
 =?us-ascii?Q?72q3jMZjQf/XQvMAAA5qYpl2IWIzt02xYUfn+VnzlM5gWHB1wN1N94kucJgu?=
 =?us-ascii?Q?cuI4J8piN0HX7WvN6bQgWDLU10MvHqVLhMg0yZPfaZrDi/+mWMCWv6dP92+N?=
 =?us-ascii?Q?B1VSPybV/yvhV8IburOdYz04Js8Z1NNYQ8hENSHXjpbwUfAHFtEpsC4NgiQt?=
 =?us-ascii?Q?mbhCjb+LPXRhqL0dMQeXpP/+cIRAX/Lk3pwFkj4AiBxth6gysDmAfr8HFont?=
 =?us-ascii?Q?s9kH0gNqe21vxksNlq1fkCPjmVcp0KZS9go1XlppkWJ2OSh8sHQ8RZ/SLi5M?=
 =?us-ascii?Q?VCyzO6fw/TvSvVyugJN2v7KxGXrg8ho=3D?=
X-Exchange-RoutingPolicyChecked: UfFgITJ5sDzrASzRDA7qH0oisgvSEZs2sZ0UZcDFjLHHpyMAUhp6bDUYHiK2UVLqz8XkVqhhCfkOKafk7Vz2DGaGqFMcF2TMwzz7HnkPTVbQDif1NrPfEoSvq5MgFctJOWwRpXEqDlRUhAHp/q3QkeO/aVloT60s6MLNmM7u19/tEPJduN6Qd06aYeMy3S75KbulK2bQi+dmxw9byX6tySFbroaflvGcnsgji4cuaZQ3gtRz4BrytTE50qRJVuqprssluYd3ngIg35/M0qek0S47bUhONZWfT6uZigtA/7LUsRALu5lykJ6D9bJw/aoX0yaECwrUaZmzVVc2jjf/Dg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 992435f6-fcc5-4547-f958-08dec1051af7
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 00:14:40.5742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tunAbDKffnaVxIV1qLdD3BLQ6YsKAELqAssNQO3WV1P8SY/g78zsD/LceJ18BRXMF9iEeILIDVooIVo4LB+w1aW+YO00u3+TvvSM90SiC8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9511
X-OriginatorOrg: intel.com

On Sat, May 30, 2026 at 04:51:04PM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Use __va(phys) instead of virt_addr + linear_offset for the kaddr
> return in __fsdev_dax_direct_access(). The previous code added a
> device-linear byte offset to virt_addr (which is __va of ranges[0]),
> but for multi-range devices with physical gaps between ranges, this
> linear arithmetic crosses the gap and produces a wrong kernel virtual
> address. Using __va(phys) where phys comes from dax_pgoff_to_phys()
> is correct for any range layout because the direct map translates
> each physical address independently.
> 
> Fixes: 759455848df0b ("dax: Save the kva from memremap")
> Signed-off-by: John Groves <john@groves.net>
> ---

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
