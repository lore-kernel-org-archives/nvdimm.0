Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8633D2D5926
	for <nvdimm@lists.linux.dev>; Mon, 26 Jan 2026 20:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769459062; cv=fail; b=WyAj/VozT5StcN2W9xaPn9jkt7PsRZpIQQI2CpPkEsRWWXxRKomhQpp/Jpj+MaqtxbIR5At8TTJoGI6OEFzEapy8OxLY9CThFLovhtuXXSZS8XPof4+3HvFWUDDgPpdybBIKhoxT3pQYLkf1REeqkPckr330wwyWdVoGj+Hq34s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769459062; c=relaxed/simple;
	bh=p+j3ehhBkyuPn4P15kW3iX846u52u4VEoD0c80L1QQw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C4YXZyhA2C01SZ2z1KBJBVdBZ6MBPHS1GMXXwK9Ri1lmH/tf0eZAJ0l+F4opuSbRrV/NbT4sw8XVogrfIAR1WZk27TaMskyAJjTx+vIy8ReVmxeCdsZQjh1d3JSMM3TTjwZhlq2g99DizgWXWPm4h/vGzOP4PcS4fExeJSIv/fM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CbC/Otkp; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CbC/Otkp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769459060; x=1800995060;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=p+j3ehhBkyuPn4P15kW3iX846u52u4VEoD0c80L1QQw=;
  b=CbC/OtkpuuP8JgnRcZjzrEjJEOfhbpwXOilaAVS5AfIwzxwXUoKa3QEO
   pUykrivh17dFttgjSTdDKFnEAfECtuvMLCJFO8xRPe+4NzNc3/DiCloFe
   Q8yavFJLAkrvVNNchoRLFaHD9N0Vqp/dhK4KDuPr9UEEc/OLibYwy1kG9
   2wC3qHTsDQEAiv86DuzgzbnvS+l6rs4kCuDDig7372/aGx3/A5J9UjmkO
   YCt7eZqxPGyutrBXFRndkHgr+l1zE2TromYxtTrGNwgzmYLr38meLDUpH
   u4LTdx/ygEYITgCUlRXPtnzy9jlUo9ml0v+NwcVmnV4ljxv6949p0H4CA
   Q==;
X-CSE-ConnectionGUID: kweb5VDkRKClMuZJK2fVrg==
X-CSE-MsgGUID: Zr48ChnkTEmBE9nJjJKo6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="70540354"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="70540354"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 12:24:20 -0800
X-CSE-ConnectionGUID: a6QUj/rfQpauf4HsAR/x9A==
X-CSE-MsgGUID: kukXhukVRa6QfkSEW6h7mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="208123005"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 12:24:19 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 12:24:19 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 12:24:19 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.46) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 12:24:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V95yh+8PqSGT+yjxikYRvIgDUFuEhQo1ADTWFrKopd9BxQRGycZgIxWzFqSdpNHw38QOUg2JGCxqaqnrWx6Ma8knIsySyh4j9yrBA/y+CQfhPcF9Ic1OlM+nEnSwSSnPyLdIhtnBFf0BEwtvTA5o1+EAURICUpJ2xtFkJjbA9NIHLv1mdtDEOtQCakclpsCvAyrMshgWSsxlVeGDLr7D87SwELN37AojvX4+E8iYpb6xypiIowE/2/riZNxXZGsmhnMUeUQA83pRf/ig2MhKtKqcW1A/lEfeqeAI6k6xzrscbv8EpZ5wh9I2x8Y/Odmo6TmCNdqJzdNx8bMtQeTbxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wiM0RpEJn0LJREsHLvztT6oGTfyiKfOcRygWiXXM+MY=;
 b=RUlon/85Dut5d4qXF7EF12gxx2fNf+JtOKEMSm0bgtDsurA6zWlVBqHuqJIRBwEumrkziUr1q1/WqiO4JLtGlsG2n8qlGiKSpPHMEPSDfqR9u4AJABVWClLWx8uG4riBYwOFbXLkWcNIOci2iLefdPEqnHyuTDCQka5Ml9ZQyLyDOW3nr2YMdRvhWefuRKiH5SzrzNQ0bmRuQr2ZwLPoCYw7gFczcsRmE4RNGpXGTR4Qo8S/lt9VwCXlZGbHp8Lhz8Jbu9adXGQ31CsSFj4UfwzFbmn2ITj8XqAghc9N9usqv7LFn5pzF4MhG/YW4EvbT1KFQvee4XoC+7SnMKHldw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH7PR11MB6029.namprd11.prod.outlook.com
 (2603:10b6:510:1d0::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Mon, 26 Jan
 2026 20:24:17 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2%2]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 20:24:17 +0000
Date: Mon, 26 Jan 2026 14:27:30 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Zhaoyang Yu <2426767509@qq.com>, <dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gszhai@bjtu.edu.cn>, Zhaoyang Yu <2426767509@qq.com>
Subject: Re: [PATCH] nvdimm: Add check for devm_kmalloc() and fix NULL
 pointer dereference in nd_pfn_probe() and nd_dax_probe()
Message-ID: <6977ce32695df_2c39100a7@iweiny-mobl.notmuch>
References: <tencent_A06C2B14D0B5B3FEF2379914F5EF8AD61D07@qq.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tencent_A06C2B14D0B5B3FEF2379914F5EF8AD61D07@qq.com>
X-ClientProxiedBy: BYAPR01CA0055.prod.exchangelabs.com (2603:10b6:a03:94::32)
 To PH3PPF9E162731D.namprd11.prod.outlook.com (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH7PR11MB6029:EE_
X-MS-Office365-Filtering-Correlation-Id: bf13555e-9c80-4648-0bc1-08de5d18e104
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8qJwT+0M20LB1wqx3D34qtKiCPAoXcvlbggvC/9QV2YplEHpmODUdQWoRKkh?=
 =?us-ascii?Q?SFEI2SKURwpUVKu8ZGPROX5iwH0ynrNHJBsNIfrqkh58Xmyw6+teTJoYUpDp?=
 =?us-ascii?Q?0ZheEP/4HWlc8AjLPa1VBV8nfq7UD+PUUloGYloIJqrRARWnq2vPbkiyppIC?=
 =?us-ascii?Q?UL0nHhFmiUvgqArk5coeHRs4cWPHQc2rDix2aJ9P+pELMEv/mCSpITRffrdx?=
 =?us-ascii?Q?Ygg9qLBl+T1q+4oVsAjF3U5lwvjUXDHMt2gLd5eZHAf6GTqL5IXhbnYeoLCK?=
 =?us-ascii?Q?W367tIf4IZZSmlcODNxKtQ+EPsGAj8RNsGbV1b8eLCKKz6QMgxoCtzkygs9s?=
 =?us-ascii?Q?8ICHhz8B9+6utY7fwulZwocMak5GSWFgq/fmRRYe7Be39cbE68lYSQ2qZeX5?=
 =?us-ascii?Q?38/PpCHwXbv2b5Ql1tFJMXABfduDDACsOKf6QW3Y2LqAWhrzUjqELI4bBOfb?=
 =?us-ascii?Q?b35h+W63N6zhEAtTBe+18JJ+tOBBNRL91xKFwMwu7E1AIDvqX5ZOpZScoQKb?=
 =?us-ascii?Q?WaABSAAeLwD2bHXXyjDHyPaq/tIctuyyKV45G8plZS9FkW6FW3RYuLKazys9?=
 =?us-ascii?Q?QXT99S79rzyTpstgymtZBdy7stOkRXMtlOnWKm8g0D2mte4wiyttVR8nWhO3?=
 =?us-ascii?Q?Pl6jjfc7si0u0SbCq7pLM0cv1ALq7daqTpXmw0k3VAO2MjxC+1YGZB+GXTEK?=
 =?us-ascii?Q?f7r5D9A/EkI5528oo3Ue0P9MTtcgE/X+wmhxarCfWuPnSw3b8RUOpojYhMbW?=
 =?us-ascii?Q?DFUQjj0ElAkXdEmvjzqIgGR0oDa1w8HfVrXSdXiW3t9aoHSRgiEq5PJG8PV/?=
 =?us-ascii?Q?RuVTSIOMB9z/4ZEC1vsx2VjSV/oE6zP+CSLc6TOaKS3MdyYyWweuNlRjQ2w/?=
 =?us-ascii?Q?ulL1mWvmG8S+p41QYlqmGC9A2TMlrIML7s0Ah+rawjXqmq/qFe1epXMeVCAS?=
 =?us-ascii?Q?019N1yOGPK0F5c5J0QsohvVCg6aGzjPA0bUbdOIZeUloHL49Kj+vppAGm7fz?=
 =?us-ascii?Q?MEG4HnHhlZT81fKbZ8VM1MCq4xxmnVBvkfdaXJ8nydFSZCaWQZURCJ9sxqJ6?=
 =?us-ascii?Q?7QumIXGCoUJgHrLGSs3bDN8XZgK9RIgfaFgoLEZ/dAusVAfvgqg4PxoE0UVm?=
 =?us-ascii?Q?3LyecUAc/8U5luu7fadfUSIciON/BmSOS96mgIoULC8Ahplh9gzDPkLQY2XY?=
 =?us-ascii?Q?S+NmUKm3Bw1+kfx2oa/U/X+EUyGDO/5l8Al8Vl2+67UaSr0vtgBipu361fZL?=
 =?us-ascii?Q?uFIzipVNaegKTc8cOQNfMne2X3oTDyAU0jyhuAo4rlwRZ3nIK2xNPXztVJfw?=
 =?us-ascii?Q?OUtR2xCYDUfsM8skvn5yC+YdxuiBtk2Tvl+sX2FFPx/n1xnZeVkxD5upyCPK?=
 =?us-ascii?Q?zv1zXIIiQ5axcmhkBH6qwvhJGqNEJcKb2auGQH1TxbU8+/UD78aHQXC8EpaR?=
 =?us-ascii?Q?/eU/rjzBcCZEfKhQZ+dODgU55wt1cfB9bIIIvOUjjgjNmY4wyEWeSdpdp1Jk?=
 =?us-ascii?Q?MI2ShP++g8h9v7xHtD5qV369MdT0iPK8Q1y+zhDN9B1bgnczwXs0H/MPKii7?=
 =?us-ascii?Q?d0RYrZqKOwc/OQqbpCg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4w5zmpSrzuXXJbmQ4KZunL8jO3sqzM7iTt2Yfbwbajb7B1KQX8Xytjnk80fQ?=
 =?us-ascii?Q?Z1LRJMclFJkUDvwayGMVaZfqb1krGXwOLi1PyXMv28g1xzVjvhVhTs6EnZc1?=
 =?us-ascii?Q?DsadwZ0G2p+S/yipQ2jCsNMzG6xY4jDmERupVGnTzTJnV0O92t7pY7VpcZJ1?=
 =?us-ascii?Q?YYK65vQr73fQM6egGlzbGCi4JtFyw2XysDWRJd7tfyuwTqzHFghC/9Tp3ouv?=
 =?us-ascii?Q?GaSqLFhO8r8dxuIAyH5SvtSeMY9bTbXtO0WXfQwfD2PL8WVUii+/dHy/RjhL?=
 =?us-ascii?Q?i+TN7duXif86VqyJ1ICYhTejWTnQ4w21+/NjJwdB1N4sy+3Oxa7w+6R00wtV?=
 =?us-ascii?Q?xBFfY2d8gOB4QfTD89lfIv+8ExSq+1PMOg5kbRcjnQcBtywQzi7/F2BulsfJ?=
 =?us-ascii?Q?CdwFcqIBx4e6ThDNdbOCYdIaAiU03sB8RXBN+Dcm2UY90mNnyj3Q5KA3MnWy?=
 =?us-ascii?Q?tAd9kJoGEmEEpuPczEenJmidqwIaBUvbDaOZOzGW7YeA7cv4o+f1dBhjVY0e?=
 =?us-ascii?Q?kVAqFpM2Srzy+yK8ZR1Uc4xlIADEcNEh+x0+2/gTL5HZrl790BNqfc0JcWdK?=
 =?us-ascii?Q?m+XS6mBV8tN0gAn3QDf7fBUy13myYKalRiandJr/NHcC6OSSpIma1fg+EsKB?=
 =?us-ascii?Q?VvGO98Kgzzs7uscpTpeC77pHrVwztJvIqRIWlQDhkxtbhhT0E2s8ZEGzW9vG?=
 =?us-ascii?Q?E/GEoi+vZD+gP4xYovA83GwhOtS4NKVHxA2QGuScj6T+bQVV1HWNqo5wxZkI?=
 =?us-ascii?Q?2ZLAuU0S7XZJOFrQ1X+myA9LTGlQFuJY/XuYnJkhceIqpRf8b8N8+zHUsmmC?=
 =?us-ascii?Q?o7zisizbgI/T2dR5N1VRp8IKAoh8ns2kWkrZmuBBsGM792VYgmV+1OL/JD/h?=
 =?us-ascii?Q?foq2JypcXPavFpRxRWjqRRm6K9Aodch3qKuISEJhjzCRlTHNDNLEAmTobOiC?=
 =?us-ascii?Q?8E672dAh27SGKG0n0C3UKvP6yp2lgWZgJSM4EFDdolIwdEILybnrz3SQyXIf?=
 =?us-ascii?Q?aL7uYl2vkg5R3CVG/DJ89GsEFXTJhOI0xgH9RHQrLSpPlvozAvBUTaUe4T4g?=
 =?us-ascii?Q?t0OhR7JIJKLNbTVna/5IFEjENSta2aPje1sMvMb2u44wo0oc5/xW0PCQucLB?=
 =?us-ascii?Q?7pOrtyhy6iQg8BUWqsjWKdS2VxGpuFCI1cY7Li2u/yCC8JmjyjgRSbY2kQWf?=
 =?us-ascii?Q?eUMGA9d5m7AJIY5c1CH/8MZX0l/Hu/8uOkfTlj+p6RJCD6YCJlogAx+iyW5z?=
 =?us-ascii?Q?Z4In8mc+QeuAMeJcF5KKHPaFTxV1xpV0gK8I51BrDPBAhWZRE9xjcNoj2K2B?=
 =?us-ascii?Q?nBKGKQMbw7Y8UeJZN8q58RMWk1qkZ1aMPD1paFTksqLiBDk728DGgioeLVqw?=
 =?us-ascii?Q?OviADLqtU2TDhGTZZeapgVg0IDWvy//7N43GV/xLc423r4+xZDutXBqVnWK7?=
 =?us-ascii?Q?7Fi+ZPbQWYb5+XSiEjHi5KuiBbcQfpjCJyxz/CLod4hsKdBElU+QnM7oCXmz?=
 =?us-ascii?Q?lit22Xmvgp01O2ECb4UBJjbSgqPyw4SPM/fdHPeuM5RQtszLPIUYDyi+c6CM?=
 =?us-ascii?Q?i3AKbekLSG0/R5aITsJEa1O8IOmLGAp2e7Me78rI2XibtWvaqvzIn/A54rMO?=
 =?us-ascii?Q?26Is3CmiVVidiXV7fuEoQQzvR9tUynS57tiygxZQ4polHc5jQDl7oWjd7WWX?=
 =?us-ascii?Q?leHhNGDAGW+MKoUBGW1h8DnhNWk2EMh2UjQ3cu23iDGM7CK6buWaSVDn8t7O?=
 =?us-ascii?Q?JNR/qzow8w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf13555e-9c80-4648-0bc1-08de5d18e104
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 20:24:17.0352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a04D5qpc9DWNSFLFqhmq3B8PylzxlpXKe8Cc2PPQFbxJaNW6UtMIsrEAz6uiKDTxBHZHrCaczh2KjIuuAaLcrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6029
X-OriginatorOrg: intel.com

Zhaoyang Yu wrote:
> The devm_kmalloc() function may return NULL when memory allocation fails.
> In nd_pfn_probe() and nd_dax_probe(), the return values of devm_kmalloc()
> are not checked. If pfn_sb is NULL, it will cause a NULL pointer
> dereference in the subsequent calls to nd_pfn_validate().
> 
> Additionally, if the allocation fails, the devices initialized by
> nd_pfn_devinit() or nd_dax_devinit() are not properly released, leading
> to memory leaks.
> 
> Fix this by checking the return value of devm_kmalloc() in both functions.
> If the allocation fails, use put_device() to release the initialized device
> and return -ENOMEM.
> 
> Signed-off-by: Zhaoyang Yu <2426767509@qq.com>
> ---
>  drivers/nvdimm/dax_devs.c | 4 ++++
>  drivers/nvdimm/pfn_devs.c | 4 ++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
> index ba4c409ede65..aa51a9022d12 100644
> --- a/drivers/nvdimm/dax_devs.c
> +++ b/drivers/nvdimm/dax_devs.c
> @@ -111,6 +111,10 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
>  			return -ENOMEM;
>  	}
>  	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
> +	if (!pfn_sb) {
> +		put_device(dax_dev);
> +		return -ENOMEM;
> +	}

Sorry this is a NAK.

While I don't like the implicit nature of the check...  This is not
needed.

The validity of pfn_sb is checked in nd_pfn_validate()

It is unfortunate that the errno reported in that case is ENODEV rather
than ENOMEM...  But I would not change that now.

>  	nd_pfn = &nd_dax->nd_pfn;
>  	nd_pfn->pfn_sb = pfn_sb;
>  	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 42b172fc5576..6a69d8bfeb7c 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -635,6 +635,10 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
>  	if (!pfn_dev)
>  		return -ENOMEM;
>  	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
> +	if (!pfn_sb) {
> +		put_device(pfn_dev);
> +		return -ENOMEM;
> +	}
>  	nd_pfn = to_nd_pfn(pfn_dev);
>  	nd_pfn->pfn_sb = pfn_sb;
>  	rc = nd_pfn_validate(nd_pfn, PFN_SIG);

Same issue here.

Ira
