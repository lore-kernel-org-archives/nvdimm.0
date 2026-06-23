Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E35934AB14
	for <nvdimm@lists.linux.dev>; Tue, 23 Jun 2026 23:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782258702; cv=fail; b=itUuaqoiC//Mj43AXuvDByDYu0eFtGwaqWJ69/WuJE9JOtSnYEdMqSlZ9p8uxPMtGXB15Ce+JQmPzMAUihkXHQDZS4cw2E375ZCSVq3FGTzJrrmDzy5Tsd3eaXndbVU+R2TvdKDgZMsSfkGyt6u38j7zCpowsY3Q3MwNJbqy41k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782258702; c=relaxed/simple;
	bh=cMDDNUKYlErYXXBIMRrUpGLSYpPwwQpve7skTd1wjrA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fTWils3BDozAcc74a8ulQY8EXMXiIFSkWKm+wyO4c34NWls/gPE1bdO2iST4bcdBMj1rGmt+IZaDkZMA5fv9QRE4kcCatRERNGb1mgl1tiKU6zsLWqmt9rkGFUV+Spj9GfAhbAKfh8YSGGycFsAIluXicdJHsULAI6EOPV5tylA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P6ybfxLL; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P6ybfxLL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782258701; x=1813794701;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cMDDNUKYlErYXXBIMRrUpGLSYpPwwQpve7skTd1wjrA=;
  b=P6ybfxLLAHvIc1jVAq7kdgw1T7dBflpH2wWxMgmmHil0oTrVC8LKXE4u
   WTz5NNlvKQiYsLPWs2y3qyifNT5UCr45c5O1UKkmKxLfG8dfzs9vhxTAC
   9Xdm0IroLOaiinvZ1dZ0GV8akfizfSTas4jn1MvW43ildvAsyUMWIRImc
   Uc/I0rZd34tsvDroyKL7fIbcAKFJ7Ib4RXJHSatT6WYqKEE2SKQ3DbrZJ
   46rdeikjAkXTTURTRYLvgBjRHw/Ge0/XsJPQRfw1s8qLmq40PzTq9+FIr
   PxNXwf7Zf8ZfeyH7OBAH/U4mJ3y9EQwNsADdkQg5PEThRwK97j9OnheLw
   A==;
X-CSE-ConnectionGUID: n3rJShJoTB2Lan3+tbsU5g==
X-CSE-MsgGUID: q2pv6Sl2TVCqTnzW21eI+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="82896225"
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="82896225"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 16:51:40 -0700
X-CSE-ConnectionGUID: 2rjOalFoRxy7oenKmoaRUg==
X-CSE-MsgGUID: NI62eTQGS3qm0Ke/Dr/qNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="248490854"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 16:51:40 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 16:51:39 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 23 Jun 2026 16:51:39 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.15) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 16:51:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AddjeFBptGMbiiM550J9up+QsDM6GcJAp1D3on9JqM3sQBzk0cqgJntXdBYrXP6w+bxjrWHKo36FdmNVzHeDfFXsFXCHYWcrrM/i+H0wcJ/ZDltYbDgPpVsFKBgzoXokU5nEGixHhX//gwRo5oWHGJZn38ke6EQTWUHSHX/TR+i9owYmAcjBZjixIw5TGVn1+nKiE7Rj+DKHWbeM7moulCCNRYJrOWTDpL3vlv7WqRmS/yxh/2f+hHyyFt0UzYlqGiVy3BjaGYKwusL3mTF1+LL1qXLB6EXE/i2yVTBUdKbc8MemkBpnTi0umduc94Ni2/VFztaNTxMIg0f+uvI0xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpzEu0fBtds8R6bI46H5sgs0Z0wbakaDYgAOUPOpS10=;
 b=yhljtgtgMbrnaKMuikmLAPeFjUoyfjEB/B8jbyyw2gbauFrdcZHDEQE/LL2LhyWz2NtaApolUJ542pqGCjrpAyDRPRYH/vaFOWSecy7L0rqclD2lCIco31Y9sqvZ2r3E6jpqWUmRe8ilAu3WzYR1xxUi86jAVaaI4yTD25+yuXxD+y0RUcyPanDs8/bW1XP6rtDfvPHnQ4kWX9RjsKQy7RjFUggd2rV8TYDNq2RwQstxgp0JDudt8N64LBgvjXxjLfDPIrR1GKIsDDAXYIjN91uyz5rsvlzNMrUvxgb4szkXqfR+tQwcfgPJ/2f7Xs8ImmQrQwXHkqa3GuRN/W4jYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB6947.namprd11.prod.outlook.com (2603:10b6:806:2aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Tue, 23 Jun
 2026 23:51:36 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0139.009; Tue, 23 Jun 2026
 23:51:35 +0000
Date: Tue, 23 Jun 2026 16:51:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm/btt: add endian conversion in dev_err in
 btt_log_read
Message-ID: <ajscAZsK9ulXov8w@aschofie-mobl2.lan>
References: <20260622142011.491522-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260622142011.491522-1-ben.dooks@codethink.co.uk>
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB6947:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b9cba97-c9b2-4dd6-6148-08ded1825c30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|11063799006|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 1WQ5frO5esvyHOVZB0cswfQN/mUXGpRXkdP37sa5duIios5Q4IRQD/99Rf6RvZU4PFN5lxjo2eXWqcfPbSEyZ/BzjSCAXOuBr2zjHoarjKUxh0y1JYz1kz+rWTygtmywEIOx32Qdn6sWUfWK5HY/a77z6aJH+NY/7yHTzsN+PwG/rFrkmC6ZkVYKQBt56dfY17/xjysfzIFxa7cOUlEFmWf9M43yPxN+tWgRmkATKfW54Gm8s/qwu1c5MW+81bYmkJfb3TCWgmXyMxqvNBcNIgnZp7wB75H9iFqoXuLTL8ItFA88VITatFnrUqvLQwaY1Sjcb5A3fOOpA8pxNkHeMssGe1vDS/b2sswpkppys74ce0cT4k1LQKsS18NZwVwm2B6gEUpuh1YyCwjBK5HrcOgoQ0xA08xlHpH22Nijed0zwCbJx+BioNZ8acU+7U4TEwJy+t57ltNOXNszmwPIQ3C+onyH6lSRgLiAykCq+Czulucy5KVDlvZxB1Mnagbckzyc/cFjrMnl02ZySpIIe5s8y6nvMpfAGb4X0rC44IbZKcDGmas57lzMqMtf3wtZEd9IoCVv+Es4f3EmW8mkyMNfMFdRxbwHzdVsXk/woVclYLpdPxLDFbOvlG9P2mtmd9b40xWSjw6UViDxe3BaLlT5Ioy5W3OxB0d9OOLDMV4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(11063799006)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9kya0ondgyy0IrHlC0wFjQCIhcOiq+fT+MwWjIIU5N6DIwspLGLgQwLEttth?=
 =?us-ascii?Q?h7wtRehcjHW0t3BCyPI3OXKRU0tqTTE/c2AcC8wQeSngVEhl10jCeq8kzUax?=
 =?us-ascii?Q?84uFPM/cFlaCeQcLJk1uCR5zU3Ak2aiNIUh9RbYj7QPPShQpvaQdW5GBQSHf?=
 =?us-ascii?Q?FABQSeHpMs5NmZVvqk7EUcanrmhrGo41JnL5BxcpwG6rkg7kts6mH8JIZXtZ?=
 =?us-ascii?Q?XfoALDZc3/qNS03qPwPItU1bq+Z3AwKaJiRYeswPUlMe/SkLzYwdctICX7qk?=
 =?us-ascii?Q?s6g8+DNvOVaJt8V1YcNpg2EazXiw707EH+lGnV7UECuvNuSZDBeBAxNNL/8F?=
 =?us-ascii?Q?9Mj9jhlXKqLxYuNzFHT8yEtVqBZPBdU/oOR+6v14dXB488D85bVnSdBXUyIl?=
 =?us-ascii?Q?En2RfGfI82KfyH16NKDQU0mlfWQ0qV5flolEq2eP/6cVkQfnymeIoTJfLU8o?=
 =?us-ascii?Q?OEiAtbcg4gxM+c+415KKi1SSdGTeVrb6yJDnd6IaO60dbWhyHaji25qe1G+j?=
 =?us-ascii?Q?t1nYnxKu/zs4+HlWwVBDW4slSf16bmpQUrKuWnSEAN234AZbrXiYzEbidaoP?=
 =?us-ascii?Q?lYBqrusd2vdNAg4dASrW6rzlRvuadcF3AO3b1jVq43CN2T7/72U55G4cgE0T?=
 =?us-ascii?Q?o5E4qM3GrEGtEJfqAAk/PlF4U7GV1lDnQfWprNEQ4CruCOSlYPyKn0M5+kYt?=
 =?us-ascii?Q?7RJTTzpIxk1zCRN74fxn3cMw1ABe+dQy1EF5KDdV4Otbj0EjmrNVXsBNqoBC?=
 =?us-ascii?Q?T6YYj012YQ4hNIuXcoDADo3zDigy0Fdyi9mYbNYTPlpSCQ4f7YJhKU4dprLN?=
 =?us-ascii?Q?xghPNWqIP69wtWisznF8h6sumI3rCFZH5ppyM7MEHHZrzzehZdmAoJatUAYn?=
 =?us-ascii?Q?VqtxvmmSsijJKfg37iEig4zwrce8e18E2Ikc+OBqhKVej+f5X2wTZmfuyOt7?=
 =?us-ascii?Q?bUzmRENsbXD+5pFI9G7u3WE2DKAXId8s0ijZ0WASssE0CCqluOpdl6170dhZ?=
 =?us-ascii?Q?Fk3Ui9pG05JFwzrIUhaO/GS60+WGcFEGt1BwBngxqI2nZt6KILO54BJCvVuS?=
 =?us-ascii?Q?OXPjkwZI/ezYBdx+M7wHE8dVYW3sNU0N+Ck5lCQBOJu/Cx7gCB0vzfyjwxp3?=
 =?us-ascii?Q?TFMDVVf5jDkX2w2yDbIIvmZCLQp8BbfxoVmcUDa6jOBHWBaInoFUWFnHPH+Q?=
 =?us-ascii?Q?HwhxoF/9lh+gZ0xdAII8vlauI2LVznKBmtTTn4Gp40wdW2RiO/OzkrxZ3gLD?=
 =?us-ascii?Q?PUTpyWJ6AA9dWkdsHCZLSL1/vZqa9XJOldHb41Ixe2o16cPUj99OqSUa+7QL?=
 =?us-ascii?Q?eA2qTLmr1GuWroKflymMSGNCVz1sLPeE/Um7EFoedWdEugkabWQzfq70x8ML?=
 =?us-ascii?Q?MlrOPShsNZFYlBXHbiSSYN+90D39LGlaMNg8krgDLuWIaoes//TzuiSOTGLm?=
 =?us-ascii?Q?i7J8l7XNbd1bz3rZuT+Km1V4StHKk4UsYhlwVvgM46if5XGYUnX1S533L15x?=
 =?us-ascii?Q?83Yuaowv40G9E3FMmleRmumERbs7nOFwd3xUfhrlcSHAX4azTMeMm/MqCqVq?=
 =?us-ascii?Q?0YjjYXvPpO1xSSQB/7sJYGTX1jSe6pMEU3GQPuESVwPaiY3SxWJJuyjUcLHm?=
 =?us-ascii?Q?t910Jqor3jQHhDslPIDRqaEVvKSrNBHVyEaik4Lxj9ZAEew52y4RLtF6f6cf?=
 =?us-ascii?Q?uu0G6c8kQKnLp3tYJCKIp4OYzXqE99nLXDJYuRPG71SuZ79mEHmu3DKCmLfi?=
 =?us-ascii?Q?YpwJQppyYdCZKieHJi0rMUg6GMsfl3U=3D?=
X-Exchange-RoutingPolicyChecked: Deb1iEX0VL6PI1vIXYAjneJUuGfEeDTB8oIDywbeKyolI4wAS8lbTD3G+1RGoVjmKXPhb6KWMApP2NdjDgtU7Cp5fNGqdvzHfNQvan2SUm3VVVUpNSmYmThyGD0nL8a4Vx6lA23md4uAv88Z0FdxyDz7OR+QIKmY+3YIM+E0MRiRDAH8RtO+z8c7POKSsyII8qQu6xZSYXcGEWkMQdMpgrGXwTvvXwOKcExrHGjDNA393l9uT0qyFAA9+Tjb72U00hRPBLku99qneoz22FpJ/sivS9jAAgFBNkRNOXbVKrY480kDETP/Hlymdv11l1u8Lq1qSV/hyCRb+h/BqulsYA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9cba97-c9b2-4dd6-6148-08ded1825c30
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 23:51:35.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bOkm+9tPnAK3fN/t7MAxikB/ht+QVIFJogpQouOuNSZdvHMdWfKg/1jDQsfvqEqMBA7aLPaEu3LNumjb10yQTUKX6JgGuZFZ9fTMz5A+G7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6947
X-OriginatorOrg: intel.com

On Mon, Jun 22, 2026 at 03:20:11PM +0100, Ben Dooks wrote:
> The dev_err() call in btt_log_read() is passing a seq value
> into dev_err() which is a __le32 without any conversion.
> 
> Fix the following (prototype) sparse warnings:
> drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 5 (different base types)
> drivers/nvdimm/btt.c:342:17:    expected int
> drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq
> drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 6 (different base types)
> drivers/nvdimm/btt.c:342:17:    expected int
> drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq

Hi Ben,

Please revise the commit log.

The commit log is a message to all future readers, not a place to
paste static analysis warnings and leave the user visible impact
assumed, or as an exercise for the reader.

Prefer something like this:

	When BTT log corruption is detected, btt_log_read() reports the
	sequence numbers of the two log entries. Those values are stored
	little-endian, so printing them without conversion can report
	byte-swapped sequence numbers on big-endian systems.

	Convert the sequence numbers to CPU endianness before passing
	them to dev_err().

	Issue reported by sparse.


(There is no need for the sparse pastings.)

-- Alison

> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  drivers/nvdimm/btt.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 7e1112960d7f..e9d548442884 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -341,8 +341,9 @@ static int btt_log_read(struct arena_info *arena, u32 lane,
>  	if (old_ent < 0 || old_ent > 1) {
>  		dev_err(to_dev(arena),
>  				"log corruption (%d): lane %d seq [%d, %d]\n",
> -				old_ent, lane, log.ent[arena->log_index[0]].seq,
> -				log.ent[arena->log_index[1]].seq);
> +				old_ent, lane,
> +				le32_to_cpu(log.ent[arena->log_index[0]].seq),
> +				le32_to_cpu(log.ent[arena->log_index[1]].seq));
>  		/* TODO set error state? */
>  		return -EIO;
>  	}
> -- 
> 2.37.2.352.g3c44437643
> 
