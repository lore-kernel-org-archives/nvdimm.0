Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D00F223336
	for <nvdimm@lists.linux.dev>; Mon, 12 Jan 2026 23:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768259260; cv=fail; b=stEz5Zwp8QBTSi2sIbE47oORPCeuXw+Fy6joLv5MVIb3NuJQsxBsWE7lmVn8jXq6aC3+VvkY4PcXA3JFEmnF0Zc77j27nT8MFnL+cEvKw4CmTJEMkE1RDQJay17wqyHFzOP4qzuUDW0lCs1tKFdHdv6emaRVw6hRe54/RYvPFdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768259260; c=relaxed/simple;
	bh=EXrRWXDdGpHJ4t3hMUx51ri0uSIgnhRwuXLPLyUa07A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OFITYPEZqoQ3HfjyxyH4egj++RYdLCINlhCYKClqFIxdCFPMQJ4r12oJ5fH5CJ6hsypMJA0cZb5KkAVwrMB0gb086+Be6pkB2C4ZeYo5YY7uLZojkerd8Fmat7kdr9mG9CdFj5uqRg+uWqL4fwwAk6PoAn9aKV5/VYDmIScvc3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E8jMonho; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E8jMonho"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768259259; x=1799795259;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EXrRWXDdGpHJ4t3hMUx51ri0uSIgnhRwuXLPLyUa07A=;
  b=E8jMonhotx3NAwqqn4Lcbf3Zkf9tKRsXAFT8Fbz6Mqa90+NzsoOkBfH3
   ry3gvAc6IpQgUU975yG16lO4G/YuqR5wod2+VQvxbhCVi+sZoUWZ7zkhP
   XYgM+75wNi14R40DWfV1fIBTVQ6NQOvD8XwWqDq5uWYa3+8to/oI1w+lk
   5yp/oyYM4RhBRbrWvRZhA+Z0Ce4I+tvKzjsxVr/Sgn09I2yWxKiqWVSVH
   SFWqnmA2TZ4frVD4UgBqldmFIaGjpXchd3z7L73fXZ1ipn7CZ4uh6gjqz
   yOAQMsTybg/qQRJwxeF87uLO48hb4YfPpV4yNgpWjVQKgZCS6elHmln4M
   Q==;
X-CSE-ConnectionGUID: HU/fHQawTayUILxTXMrDfg==
X-CSE-MsgGUID: /JjMG8Q4RfmtAxRKtU1Oug==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="68749101"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="68749101"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 15:07:39 -0800
X-CSE-ConnectionGUID: s0c8E7LCQxWgoVWoPTSIWw==
X-CSE-MsgGUID: STHRoS1ESOao43bVmAxCyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="208371374"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 15:07:39 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 15:07:38 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 15:07:38 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.64) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 15:07:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w1Kk3l400O4HpE18sVmbA+wLqC0yqpUlk/e6uUSKnkLJfezFuBKOp1os8UpbCKYrXNaXJcfNYFNfb5PUjiKtaQFKzHJjR2jWDxHBY5BxP5fpHHngcpM8Fe9vYn5CRtZbmrwbb2CsGFAhBRfp8C66Q/hSYNCiAfA3MO8mFb2dCX3JYDirvQbF+Uu1WWbcrDqAOaFr0uSPMIgzSPmtWSYg1kjbZyNPgQVAThx+qY1ndQjIPFzcuSaHkv84fN9W3AbZw7i8ATnTFbZy0m/d2K+ihe8GJ+USrW/1iM4o5vEv1W64OU6uQjud/VlOC7KmcMXkjHrWprOzn7ugL1KQU5WowQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6nE3UjQhdPJTWM43Dq2FOYQMH5H68Z9NuATO/nAF19o=;
 b=EBcuYvwWAYgvSYbPH0MQN9wJmwCgNb1yMBdnoJ7M0iDgs6gt20IVVabYuDbbRifcP2ccvK8fjIhmauGzs/p6aR4nVm6DmQJC4zpcG86XRPBVqcydwWd3ICxqvjbSWhIvfab7TaomEc6Jb8Ib6YPUQEMGMgQcTopoAN0X3c1q0Yz1p3YPtcPxrYadQai5hH8hVmKTjh2AXm5ueyV0E96o1zDaksvD8/Wyc4cEwhaGuk+uhCc9F9N9J8Rv0seV74j238/zRP9M5nmDsQAFcyChExpBf4XApopdQfRJ8x4vdDC7GDXu13WDCaXzhPURxgIFrPShgaC7HHeJ7MCfw4iBgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by SN7PR11MB7973.namprd11.prod.outlook.com (2603:10b6:806:2e6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 23:07:32 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 23:07:30 +0000
Date: Mon, 12 Jan 2026 17:10:35 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>, <vishal.l.verma@intel.com>,
	<dan.j.williams@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>
Subject: Re: [PATCH] drivers/nvdimm: Use local kmaps
Message-ID: <69657f6b74508_f1ef61007a@iweiny-mobl.notmuch>
References: <20251128212303.2170933-1-dave@stgolabs.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251128212303.2170933-1-dave@stgolabs.net>
X-ClientProxiedBy: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|SN7PR11MB7973:EE_
X-MS-Office365-Filtering-Correlation-Id: fbde71b0-8338-49f5-0227-08de522f5c65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Pl0OFGU8/qjVUJV2hG2OOkH3vqaYhJYJ8jHWzKwLUdBA3jesR3GQxgn2MhWF?=
 =?us-ascii?Q?HdSWEdXuobq8S7sorYjxBVuV+LS0lrwtxk17NswTce8CKbZBWqiGj6KAF1J6?=
 =?us-ascii?Q?o51qHf1UH/bjNehSKF6zFGO1jJ2J0CgVLRmvW5kTPB6yCRWqUkRVZR1xkEQH?=
 =?us-ascii?Q?yoLYEyyxv9cZwNMzaS9hej30ctvPc7ypO8iPEoW0lgXdMObSpA+aCgLexPFi?=
 =?us-ascii?Q?uQtfUHdPgCiF1x4ZrukMcdxN+wrLOTttQRJFUeFktIlvFYO2OG7xPse5XotY?=
 =?us-ascii?Q?MEQsylgLUCcBCQVQU+f9KzjBeDtzTqJTHCYkcJezxYgIGHPDQx+5Vlbg7kNa?=
 =?us-ascii?Q?JMwBm9BUeId0HjTvKpU+zec8aHj8/dUc7SncdWjtQLSrUdYGZd974Emuissr?=
 =?us-ascii?Q?T//wbiThed4fFhim1wYOp/cJb/WbU4BRxInwZW1tqH6syGNjn8e+GEKptYbq?=
 =?us-ascii?Q?Onhm09FlssjtJEWTOb+sSPdpxiRWMXOicnOnw7iYooVKSCVJAGuaHIy66FZw?=
 =?us-ascii?Q?NetkxU/NABw0OVFuXyCBUGn1mFkR6DJKM0TKpHwUBSMEDenlT9hezbCrWpUA?=
 =?us-ascii?Q?pTLI1bE4FgmilTObJOw2B0DmRzbeqsQh486JMeMwXMDdHHgjajYjnxdskUKF?=
 =?us-ascii?Q?UyhjWPM43i+H5FsVSxu2r4nrIqPDjnicrwSbO1e/Iyg9jKYmRIwPn38blnR2?=
 =?us-ascii?Q?eeP482pTQB0I6p7AZG8iotaC7HA6VgVwEW94wrCqF6HcGp7LUCKu1rXu6eX4?=
 =?us-ascii?Q?GYVyhsbK6loN9kGu5IjPZ/L6l129ffT9Heo9HpUI7faChvy1umPGmF1FQ9QR?=
 =?us-ascii?Q?0dydeKGQQHzzcnQMBUdq1lVezH2+gelAx3m+hh2PVZLghjUQ3bVAqIwSmU+C?=
 =?us-ascii?Q?LL0Rzy/Ua3oJwf0jdsKaGBAD8mfCtv/49+ZRO3tmOD+NxuX8SFpLRbCNoIYQ?=
 =?us-ascii?Q?yvL4+i5XcYcGy+AiRBbkOnjt+twhQonAM3mx0unzIPhppNIlnM8dZRf12uat?=
 =?us-ascii?Q?+nK191pIOqAbUZj/2UJopGAAXdJbfbOobCNSGoRCcWXRhriVkJ9ySky9Tj9w?=
 =?us-ascii?Q?oriuVOxa9Hd0qcbd3XofwT6xAAVx8vzva6QIlz++n836fGjQzhBk29F1FoyJ?=
 =?us-ascii?Q?sQ3dRZ6rWw3feQzyJR1DynkMd+fnWFCzFx+X0PEy+Oti4pAFO/hN4TF1lqus?=
 =?us-ascii?Q?J0eB1l/Z68Ijr6TIZ2GcYIy0DW9vuU+LXeWg6N2d0Xnmgx96vpnk815IIyfT?=
 =?us-ascii?Q?SnZMAHCB2lgnOjkDtD03jOImxerCN4ICm+nmjt0hpZMw3aJjmybkXgKMSDvu?=
 =?us-ascii?Q?h5hYZ0e2MMnXmxrUG/fYEoiaC/zxDp6LOl8CuUPa8VeDjoNUrZ+zxtd6xYaW?=
 =?us-ascii?Q?WO4iqBrkNk/LtseFMkoPIaB3pgaKV974PemH7wHxLaOCWgd2c03uxeQwawl5?=
 =?us-ascii?Q?+HsLXya7Mz9qS7pq/GyFyLbk8qXo9I2g?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C5bfV+M2mNdi1//nOJrw+Ue/xpuPBSdX+VoavoYhv07ogMJt7yCBxn983F4P?=
 =?us-ascii?Q?DXy8KRZCM593G1gF80TdOq7xOe0Oj+W+u9CZ7YUazjDBQAALSa4Jz7TBge58?=
 =?us-ascii?Q?vndNSEn7BAU7yIvr/Rpyg5+H7g9Pp75vZJ+p6U3fs+ZdTfAy09JAqgR3nTJw?=
 =?us-ascii?Q?KyZR7PUodaWvDKu43m4N4dTzpvGX0sbkDPbX7HwU/QJ1tOs6sWv9dIhp4OTT?=
 =?us-ascii?Q?5tJuEGJ9hV70mCTmYw7pJoMybBDFPx5YcqAWUf1vIgT5nco7/4LRdV3YiOnV?=
 =?us-ascii?Q?yiyVMdGU+1rw+BOOp6iqk2dANB1SFWlva47Y5uuLSqpLdQSLfktIsI+t1iyR?=
 =?us-ascii?Q?maOvJQ5rRIlzqyBTjDFe87s+4XY2H+yI0/glDDIVCesIyB4Pa6vkK9lp1OEv?=
 =?us-ascii?Q?tK1e3mC4M9dAYpMNYRFWzVo9OOf0amACWkiE9yXrojcTV5E4i/AuI7e04VIj?=
 =?us-ascii?Q?xyZrNTajjb32fpUtjuOjZ02lggzyOzZ9BvIl7yKH82bQPhB3a+xuGghQ+B9C?=
 =?us-ascii?Q?mEWb7ItzWa+0fdwQ+3EDuo5IujDIPO95pA/GAsmjeg4lCbZRabljUyODcKkc?=
 =?us-ascii?Q?2WV7IZysyBIoy8q2sIzq6CQYv/cGqGJ+Ja1t5MQ092SYV9B/mJ5wtiNzcSlF?=
 =?us-ascii?Q?E7iYfKGhsiP5uj6YCYZleKxsi5pUCcjf70y7q5KsrkSeRGnpnqys8adCT5b7?=
 =?us-ascii?Q?0VLrZ4gVhPT+wHYO8r3Y6q/Bfq7JtxlbKJv+FjAr5+yEcfLe5juaPryfZqhU?=
 =?us-ascii?Q?/TXKrkIOmQV5F0jKnrrL8edNYsyaEf5XpYaTOucxydeEdMXV1mOeL64R1S11?=
 =?us-ascii?Q?8JsqN+pjvG4xDhDSRG5CLtZS2imEn47aX1XnmSJFcABXWb5+MW7QgcHKs9F9?=
 =?us-ascii?Q?s04ftfUkv+NRRfVorSHsfaxqgaarLrYblRK1K6xjsacR7COEVPJkymKGYKoC?=
 =?us-ascii?Q?+vuXi35EmhFmsRxnWWLnGvOReBfdM9Zh9xxBfc3CvLp4bV7+9WYtXriDMORB?=
 =?us-ascii?Q?+Mcd+2o1RgugqHsKK0qi7bgFF6Mt4eQIr78yFy5QmVeBTx5TEu8gBqf3kETg?=
 =?us-ascii?Q?1rwI+TLsw4lxR/Ct2Lo4VaWfLuuok+9QjMoUEDOAJB9pPz3dSAZn5UgP4E0a?=
 =?us-ascii?Q?1zydnu6aDYpgVOXBr7VhUClswwcEZ0+xne6ASPT+mzwUJEgUeRJLJdd14JAg?=
 =?us-ascii?Q?/IPVM/wpI9ICD2QKKxwQpxW9WNrTUo4rOEmRxuASaNcA4w032hXkmz4TlLaP?=
 =?us-ascii?Q?R00CGJY0yZMuat/2Uy4lR5BrdpYXalNm9OJsEKhSh2qm7pwqVGLCZ/XvGqgM?=
 =?us-ascii?Q?S1QwK/50ueCqxIjLfikjerHpD/v4xdjMwavonfYBYW5KegnY39x1tzSVIR9+?=
 =?us-ascii?Q?QTYoJ8AN9wrTuS/pXspYoNTKKRZlH1tH+x8lKWI2Fh3b7e++dVjmF6gtwR/B?=
 =?us-ascii?Q?UPM2oEH9eBblUo1iIzAo8/uV2QHAZs44IDcJ++3gAjYzR0DLDNa+TiT2jVYz?=
 =?us-ascii?Q?NOE79xCnD0Xvkjslw3x3V/cFxCGsbEc3mnCTb26aQ2kOgCqLxulwetOn4OiC?=
 =?us-ascii?Q?TFm5dRcq8CjUVuFRkURrqiqSosQ0M0Y/5JHi6uDDWOPiy2ho9Z89zfxTZojR?=
 =?us-ascii?Q?+7pL0nKWWQhoNrcZVqx6E0gz6LWvnNwwpl8wfpK65NyaCMYfQI1c8E/ytl5d?=
 =?us-ascii?Q?5AoTyUGC+2qDyZDHP1C9O5o+/eiSIYODp1c1BpkjqgkWq89Da/qVz5994Gl+?=
 =?us-ascii?Q?hHU25gNAHQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fbde71b0-8338-49f5-0227-08de522f5c65
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 23:07:30.2731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEWZBsueY3QL0xvug2+gylLOMZyZKqQa3LkswnofFpWTooohzLJUwZQsSRScH5nvPD2Dj0SHWiQ/FScFNFE/qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7973
X-OriginatorOrg: intel.com

Davidlohr Bueso wrote:
> Replace the now deprecated kmap_atomic() with kmap_local_page().
> 
> Optimizing nvdimm/pmem for highmem makes no sense as this is always
> 64bit, and the mapped regions for both btt and pmem do not require
> disabling preemption and pagefaults. Specifically, kmap does not care
> about the caller's atomic context (such as reads holding the btt arena
> spinlock) or NVDIMM_IO_ATOMIC semantics to avoid error handling when
> accessing the btt arena in general. Same for the memcpy cases. kmap
> local temporary mappings will hold valid across any context switches.
> 
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>

Queue'd for 7.0

Thanks!
Ira Weiny

> ---
>  drivers/nvdimm/btt.c  | 12 ++++++------
>  drivers/nvdimm/pmem.c |  8 ++++----
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index a933db961ed7..237edfa1c624 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1104,10 +1104,10 @@ static int btt_data_read(struct arena_info *arena, struct page *page,
>  {
>  	int ret;
>  	u64 nsoff = to_namespace_offset(arena, lba);
> -	void *mem = kmap_atomic(page);
> +	void *mem = kmap_local_page(page);
>  
>  	ret = arena_read_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
> -	kunmap_atomic(mem);
> +	kunmap_local(mem);
>  
>  	return ret;
>  }
> @@ -1117,20 +1117,20 @@ static int btt_data_write(struct arena_info *arena, u32 lba,
>  {
>  	int ret;
>  	u64 nsoff = to_namespace_offset(arena, lba);
> -	void *mem = kmap_atomic(page);
> +	void *mem = kmap_local_page(page);
>  
>  	ret = arena_write_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
> -	kunmap_atomic(mem);
> +	kunmap_local(mem);
>  
>  	return ret;
>  }
>  
>  static void zero_fill_data(struct page *page, unsigned int off, u32 len)
>  {
> -	void *mem = kmap_atomic(page);
> +	void *mem = kmap_local_page(page);
>  
>  	memset(mem + off, 0, len);
> -	kunmap_atomic(mem);
> +	kunmap_local(mem);
>  }
>  
>  #ifdef CONFIG_BLK_DEV_INTEGRITY
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 05785ff21a8b..92c67fbbc1c8 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -128,10 +128,10 @@ static void write_pmem(void *pmem_addr, struct page *page,
>  	void *mem;
>  
>  	while (len) {
> -		mem = kmap_atomic(page);
> +		mem = kmap_local_page(page);
>  		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
>  		memcpy_flushcache(pmem_addr, mem + off, chunk);
> -		kunmap_atomic(mem);
> +		kunmap_local(mem);
>  		len -= chunk;
>  		off = 0;
>  		page++;
> @@ -147,10 +147,10 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
>  	void *mem;
>  
>  	while (len) {
> -		mem = kmap_atomic(page);
> +		mem = kmap_local_page(page);
>  		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
>  		rem = copy_mc_to_kernel(mem + off, pmem_addr, chunk);
> -		kunmap_atomic(mem);
> +		kunmap_local(mem);
>  		if (rem)
>  			return BLK_STS_IOERR;
>  		len -= chunk;
> -- 
> 2.39.5
> 


