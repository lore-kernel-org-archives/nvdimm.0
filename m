Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234EC208AD
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 04:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747887654; cv=fail; b=AaZdei81Bk2/smytH7iXTv4uj2PWvY9Y1FFYKWVSqVdLvY27j4tcJYQdBNkfQx6INrVwN75OTh4axB6A7XZLO7Lk97G5s0mWySIyVdC5qh0QHH66J54ucBWFMv8+LqDZAmBTxh6awliJVK6KuN5ZH2uhmJU7MNhLvnAfmNo6cLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747887654; c=relaxed/simple;
	bh=dM53Qfc4JcR4zQqq/KP2fVs9/KXwOPdVQLExj/JObss=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f0i5s3LGUhoitzg3piK9BkuK3sMI/O7UDysQHaMhlvblw/SCdAm2nR9LsiQJhJHpq9NmUQ/qEKtdXcB8ALBMIBj6UMK44kEX0HCdf1GuZvBg9kVf+UTdb5JlE24iwZm0fCffpvZgTdpb/GawmX9AXyvtXMMHLaq8j/1y5XP/4ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iyVesaX8; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iyVesaX8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747887652; x=1779423652;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dM53Qfc4JcR4zQqq/KP2fVs9/KXwOPdVQLExj/JObss=;
  b=iyVesaX8uz7CzXxxU5qszguRV7CYGL2JO/rUYa3L8ygZjKyDN3pZ6Jve
   ZramIRl83SSBJmKm7rXXn6AO6MnohCoWySi0BGgGRmDcTAewBbIAtiPHo
   0fEQNRtRfhxtISqG0OjQkKFWOsmfopLkhUmhQWdlVvBMjJo//4hS+0mqE
   IInztBSlPPpJGZJTGZOPFdsGoe3h/swtfZcO1XRAE9ms0w8o4x4m1VRMu
   hW0dtSrCNx4iJlRdD65j3x2mUGIqBIxz1jDM6uD/kyftzStNIHOJ/GX7W
   1Pl0xw940Y79igBg0DWacELss9RERT9CPD6P+9+/nR1D1cxfJqie1aQLH
   w==;
X-CSE-ConnectionGUID: rRnccPqDQ8ORhEuFNfMStg==
X-CSE-MsgGUID: M+e9XH6nTJu+0kD/Njh2TQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="75290960"
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="75290960"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 21:20:51 -0700
X-CSE-ConnectionGUID: XJCI7w2iTYOTY5DBbeQLOw==
X-CSE-MsgGUID: KVkmUvMbTMar282NXIQw0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="145641806"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 21:20:51 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 21:20:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 21:20:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 21:20:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Boo7azAg3jpe6RLOiMnDgz4o1BeIPu1PF6FNkN582K7qzXKjUufXsAVli8Vdi68qok4uXROI0abh4lnD1zO5FnL7UTOeC3OjwUKZH2I41jMatNt8zEiEnaRajDStZLFscTNS7inr04TnbHKALSG99cEPt52HiYa0AC5dQxg+aVuA3UPl5uZKquv0alleeeHa/ZeflPN1kVKEol3T7CvVbriQH+QcuYMlIjHSkZnXFOdovXTkLKiWrMwse6J0lNjcsuzeSld04Nh8UWPW294W9IWzEIzIVlO89G4qO9AMXaIfrGls13/moI5EZt5c+mmk3yrMZo6heZNpaY3QOX/tJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCY8VFsmcdMVNXUMdefKfrMfN5hB62sfzymt4ryPsCg=;
 b=nqSkqO2IICjsU+k/rFeHCaa7qJn//6qXzIWGb1OYxs19XqqNc/70/24FePNSq6xfrH+mymiuR2WE8CJkKeZ6KnJlxk/OEgkt0devqzzy39kLv5oTQYuxgf+++uGsLJAMe17tv8ugYi9T+dKUHyzNwiy31QnjSCZICUv7DzwePJhWni98tIdMcu9sOCpbYoKjyqBgnphJP901S1W+XTRR4Tf189g2/Diz+wDpNDKSH/plSroNnn/vJj2EccmFR6b8xT0S9S2R+wD7fPPX80Jlmx7Ilcdpg6q8CCvgwlXWCV6j78Jn3EX5j6fWBpTRO35K4eD5ntanK8ySDJTLTnJFcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DS0PR11MB6495.namprd11.prod.outlook.com (2603:10b6:8:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Thu, 22 May
 2025 04:20:47 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 04:20:46 +0000
Date: Wed, 21 May 2025 21:20:38 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <marc.herbert@linux.intel.com>
CC: <nvdimm@lists.linux.dev>, Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [ndctl PATCH v3] test/monitor.sh: replace sleep with event
 driven wait
Message-ID: <aC6mFsr2UqBzWm83@aschofie-mobl2.lan>
References: <20250519192858.1611104-1-alison.schofield@intel.com>
 <f15e4a85-cdb0-4243-bd82-28f09710bb7c@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f15e4a85-cdb0-4243-bd82-28f09710bb7c@linux.intel.com>
X-ClientProxiedBy: SJ0PR13CA0221.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::16) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DS0PR11MB6495:EE_
X-MS-Office365-Filtering-Correlation-Id: 1de743f5-f3d4-4c34-ee28-08dd98e8069d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GOQpdrlT2WNHQgeTaRVmcPNsIj7a6MWycKwEhHAVUevHbVWOtEnQjeDVV7h0?=
 =?us-ascii?Q?FhcyFouZfJpMXUFO+aUvsCXKJ/R4VsCrgBb6K45PebsVwu/nK88rHwJ7BgzG?=
 =?us-ascii?Q?kAzvpIz1VV0WJ1pnHhlO4npxyW9qf2SKcf/tx+Wr24l1tFWcRtj+2sCYdYrj?=
 =?us-ascii?Q?TRBK0jOM/BpQBl/nUlTUDiIejqMbM3DeEhfXVw+aTc9k7SRzYmMmHPaeUvmD?=
 =?us-ascii?Q?mkCZwc8WcpjUzlDG/NUd9Cl90/FZnFSsuSzqmAGIlhlh+DpD4Q221KBFHCKM?=
 =?us-ascii?Q?SSiKfoeGQ2woFU5Wc0kACyRMJKV/0J18XBrpbI8K0jmgeTOmc1IgKyuAL9e7?=
 =?us-ascii?Q?2rZiRFE3ya4+fnlMxp3C35BnmPpR3s/owMBS+j2NGr3Fd0So2bXLiqlQik+q?=
 =?us-ascii?Q?Ug+wLGOHZL2F4bPmQrBepOA+b/lEP//j7l5neXkQ1lcFtM2rvx0IXIr24FQs?=
 =?us-ascii?Q?MeLyOSA8/nJ0oWvLXZB3lHKdC5DQxCrJMXe0GX5eOIFjtkZyGxv0sU3us3rA?=
 =?us-ascii?Q?ExGzCtEanlUcg1avqpVX7I6tQKzf7IRrCRsMwksgddhq75ICLClD0+23aQpJ?=
 =?us-ascii?Q?eUvf9pnd7AiS8msrwcrFity/AjXQXgY7UdMM17v+PD5nqYFANk5nuacPkGht?=
 =?us-ascii?Q?azUzK8HuPHVTUzVBIxtao8VJgvs/+hsFgmm9h5aWkMWdshCwNnSuNBftXpwH?=
 =?us-ascii?Q?GHL+xyp9wOE8BDI//p/y6K4Eh8I0+/GatY91yIIPVlbWlANxilUyPCyMyM5T?=
 =?us-ascii?Q?6CyusXI/+uE7gmRReZ9DbEPOoHCMwIgMlXQGkO9tnFk1kd8ChH2q3Hc4K5GZ?=
 =?us-ascii?Q?mMXW0KqqiSjRvTa5aI8c71Ip0S4FTs2RUQ1PT++yudKLx66iIE9PlqTT5+Dc?=
 =?us-ascii?Q?/jI4mm6PXiVdILznWGywN+eVpjNS3AskVrnGMNCN8aGt3r4l4I7YSanAVrzD?=
 =?us-ascii?Q?e4VOCibDEOHkYlI23vUijq7h4iUdnX/aU3g1l5RTY2aQAb4thDXxCH6zoV6X?=
 =?us-ascii?Q?+JFD9KfJRcNHEmIJCBISLGfkYgrLC6NauYOX4eYffURvZSrKUMcsf2kch19r?=
 =?us-ascii?Q?1kTcxpQTEB2CPRZnKhCsS4zOMCCFeGHfU6A3dFhYdQdLeYkwtuxjMjyCw4qI?=
 =?us-ascii?Q?ylNXFDXwpcKkf2mbGY0rTbOeO5yj9nZfr0M6P+azUASgGYhG7DqIsmMFgjdc?=
 =?us-ascii?Q?o89sFRfFKc8LV0J/a3FfYmMX2/tDgjA0PP7DeAeQjaMnCwUcSSUuMSg8iQxE?=
 =?us-ascii?Q?S8ZRULyY4YRl74bz6T5CiQkSavAtna6/FdeBdzVGOtxpuoLj0q2an9zHN5co?=
 =?us-ascii?Q?jjUV4kb+R3HkCOwLkv1Qz1kDES4bZFLRbmZ3tt2qu5z1xQglYs7+8ByK6QBz?=
 =?us-ascii?Q?kQMr8x6dlqa1BqyIeXsTzBSjqIVWMlBWGjqxTa5qIDU8ddo7rg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hpHtxkNYU7e94vNbDlBmMs4qdfdxMXOiBkhOC/hPBCSDyLQc2tlrRjmbK5cg?=
 =?us-ascii?Q?WgN4zB85gLZussvHBx5jVSFVwxhCGxsYs7sRZteHeL/PuSbDcY1e2t4qrpcw?=
 =?us-ascii?Q?TK6n+rwB5zXD6QeOp92mvYX9kHf0O9hOMN2UCaDn0wzHlPXMOfvvwAwpoI5B?=
 =?us-ascii?Q?6gr7VdsRsoCIKuzyHE47m3vqjWCi+K9/tA2q/fQUjKok9/Y09/p0LzvKqBgE?=
 =?us-ascii?Q?R77mgwkLnUnQEEBrMufDFr4iYXM9lgKb2BZG2vIuM/QY3QinmSplnNlTC4C1?=
 =?us-ascii?Q?Lw2HyL/wRxHste3VMe6sGFPJROT5m9m6qExjqw7zW+yHSdWg19X2eTn+b0uu?=
 =?us-ascii?Q?zhbMIre4rgFDTcdryFSYWoImOCMLtwaHIa0OFIv78vo406bR29L2uQccCgtL?=
 =?us-ascii?Q?0uhELr39G0oF9IIyne1slRNjc/IZ4W/TTB96roCFJQc89g2oGVbiCdqZ9L+p?=
 =?us-ascii?Q?LHq8EjH2pWKikWjyCR0ZyDS8ajS5gdcL5TzQzUlJafch0J9CUcbFrKl0uEqU?=
 =?us-ascii?Q?1LuY9ARy0L6o454HF0jWfDSjUFP32ywnuqgMHDL+vlkq2JcR8ky6b0DJRPj8?=
 =?us-ascii?Q?z+I7tnxfezUOINpQgyTZZ8hv5d747Nqv0Vu9eZR4SpxJbxTGIJoaNLHx9sEN?=
 =?us-ascii?Q?R6jRlUmj5X8ah0GcUL9PlCsTZELm3x2czZPB8QYN2wmeqWFWxH1jdbdBq0Mg?=
 =?us-ascii?Q?zjaML5ZQC+3NSzc6Q/j/ivyMxFedIGRnlood+9lr5iQDW2Lr/W4UvjkllIbz?=
 =?us-ascii?Q?BuLZk9UG72y6BLf70//SJnc7lnMzFV3N6zmu75/MuWEVGzYU/z+5JFynpMAU?=
 =?us-ascii?Q?RLYT3PPxPlB22Eh2nO+9gl+HgJNjnIZjLB0VH+gy78miImw1RDbxsiwZO889?=
 =?us-ascii?Q?lW+OkOM0nHaHgitBfiGmnt1mq+APxNB1TuWuYreQ8dc6YLay9ds6PCKG8pvU?=
 =?us-ascii?Q?6LMVvKV7LFAxKaE9PK+ggs1SS8L2yetximOncfd0x05+vB79sXpftdQyecBD?=
 =?us-ascii?Q?krDVYFI8aZoeB7BD8AEPIyVwnZVHRR9k1EkaDzqma95znT5uqt9HtPg+4QmC?=
 =?us-ascii?Q?K8otxB+/28Ql7OCO/EWdhQzbwRtIab28MH0ox7PElAk/TfA16SjlJS6XVO7I?=
 =?us-ascii?Q?l6CnztAycnOwKU995PcguX5ablEU41NQJht91rfzuFWrk3fcNZKTnhhbRGdS?=
 =?us-ascii?Q?pMgvyo2e9+G/XHhCAN2EcULVrpoe0I38sl8ZwpdQjQpT/S62o563SsKV0U8J?=
 =?us-ascii?Q?t993kHNMqqpt4GNbEh6qKfS1TjOafI1CNLIK4MQKHA5hhtM8Ij6JUbuQU/xD?=
 =?us-ascii?Q?pZch+H3PYO8LE6Y3hJsbb9gewG451m1BqVZuSDTHuJFAxL9AHy8zE4MDGyn+?=
 =?us-ascii?Q?68A3y7arHuggB/wyidrJ5X2aRHs0QfBeDDp6l0bHA0qKYmgrTAHh278LUU0X?=
 =?us-ascii?Q?6mKHhM3w8TrFKTqKrZBDZwciJYpmm0KN8QgznyyeviJdLphOB7Hf2CLEqPwp?=
 =?us-ascii?Q?rfTiYKckF/YGMwaVv+me85YMqo/Ge8ezrJzUamn2Jj5BlhqbL5+r/2bV6zyF?=
 =?us-ascii?Q?49HnfQz94zXyKohFP2tV0v8XrMpfWQx7LXxRIpjQ3NWEB1YkI06awBZuLPl4?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de743f5-f3d4-4c34-ee28-08dd98e8069d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 04:20:46.8964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omePBK1TZM/AO7yFPOLA5RkZxJFqhYXxErXPBi4dSaZQp6VOKbaoc/mtxKn8c/CXTzv7f3o1WLmwx75xRPE04Qk7Hje0DbEu+/ykkAzykSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6495
X-OriginatorOrg: intel.com

On Mon, May 19, 2025 at 03:42:30PM -0700, Marc Herbert wrote:
> On 2025-05-19 12:28, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > 
> > Again, looking for Tested-by Tags. Thanks!
> 
> Wow, it went so fast I genuinely thought something went terribly wrong
> and it did not test anything anymore. While reporting "Success!" - that
> has happened before.
> 
> But I check the test logs and it does a lot of stuff - in less 2
> seconds! What a difference.
> 
> Tested-by: Marc Herbert <marc.herbert@linux.intel.com>
> 
> I have only concern holding back my Reviewed-by + some minor nits after
> the code. I think the error message for the timeout pipeline is too
> limited, terse and generic; does not say anything about what happened,
> does not make the difference between a timeout and some other, unexpected
> failure, how many occurences were found etc. I think the error clause
> should do at least two things:
> 
> - print the timeout $? exit code.

OK. I'll combine that request with what Vishal suggested
	set -o pipefail
	do my 'do or die' cmd
		check the rc for timeout, grep no match, or other.

> - grep the log file again, either with -c if it's too long, or not.
> - Any other useful information that could be up for grabs at that point.
> 

I can add dump the logfile to the test log before removing it,
everytime. Each test case only puts in 1-4 entries. 

> 
> > +wait_for_logfile_update()
> > +{
> > +	local expect_string="$1"
> > +	local expect_count="$2"
> > +
> > +	# Wait up to 3s for $expect_count occurrences of $expect_string
> > +	# tail -n +1 -F: starts watching the logfile from the first line
> > +
> > +	if ! timeout 3s tail -n +1 -F "$logfile" | grep -m "$expect_count" -q "$expect_string"; then
> > +		echo "logfile not updated in 3 secs"
> > +		err "$LINENO"
> > +	fi
> > +}
> 
> tail -F really does solve the problem with very little code, well
> spotted!
> Nit 1: I did not know that -F option: can you try to sneak the word
> "retry" somewhere in the comments?

will do

> 
> Codestyle Nit 2: to avoid negations I generally prefer:
> 
>   timeout 3s tail -n +1 -F "$logfile" |
>      grep -q -m "$expect_count" -q "$expect_string" || {
>       error ...
>     }
> 
> This also translates to plain English nicely as "wait or fail", "do or
> die", etc.
> 

You prefer do or die style. I can do that.


> Super minor nit 3: "$expect_string" looks like an argument of "-q", can
> you move -q first?

will do.


