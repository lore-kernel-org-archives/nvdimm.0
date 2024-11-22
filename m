Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB0DAD2F
	for <nvdimm@lists.linux.dev>; Fri, 22 Nov 2024 20:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732305704; cv=fail; b=IGyBfdfpoz4UsS/z4Q3+/LuRxxxkdj7DdtmFYdK9p4w9lgyhJyd/JPuVMe8ZuSgi88XAlrPN8++gH/ae9WadL4C6EWGLTGmveB1SdteOLQGYvMDoztJy42z4KiG5IilaQu0tRfDr4tt2dlijbBMOpyxaZCl+Gy46ecbyZ+GFocU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732305704; c=relaxed/simple;
	bh=fke7vyVjUQaNK2dGsRk7BGog7FU5OSsluCSa9tUNYgY=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=IJBZLZariFQgcrdNXJ0wdncU+UoqDcVTD4hPXjSjxEytifc8G18TDQuI2351egFHj2GrCRSmVB+S/j20kquBgDrkSgtpHVIdgh7CnWRuoQAVR/JSEezkafTjuzDbL7cXu1MTq1ZsOWwBsDLTG4gaxYU1DEtdvjopZjCvymj74TE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d8eAzSTe; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d8eAzSTe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732305703; x=1763841703;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=fke7vyVjUQaNK2dGsRk7BGog7FU5OSsluCSa9tUNYgY=;
  b=d8eAzSTeNP0ANV1EmSWD8r4GpNn+zIXe7+QTCKEFd3GsT2bzpPP64Ydj
   5yHWygUtWBkHjRzYUFXmH3WcZC4a6W8ER3HW1zrP6rUv9b2kCnsii+UTv
   Hc6z+7DUWgf7RvALDTAvYwjSQRuPIsOlBqiTZZHN80R70VdxYLI8wmAaR
   B3CDXw1PdVVO1FaN3686gK1TZaW2V0+V2lHMq16evZzHlyQL/kV+74CqQ
   zfrTRluYE8vp1ScVhO6o0mEnltWWJOmnGCshbKtnWWxBVnLdhwq/bMnZW
   yMF/jkViVCEv2ZXQDVchFjkE045xj7nIJmsMkHr5TNWPfYNDoCX8qHZtr
   A==;
X-CSE-ConnectionGUID: Jd/q3+j/S4atEugE/mBwFw==
X-CSE-MsgGUID: X/Y2z8brSzKWKNAfuqAnrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32339027"
X-IronPort-AV: E=Sophos;i="6.12,176,1728975600"; 
   d="scan'208";a="32339027"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 12:01:43 -0800
X-CSE-ConnectionGUID: I9ya/mhSSIqlKeuZG0Yj+w==
X-CSE-MsgGUID: toDsLZm9Rc+56cGJj8AHDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,176,1728975600"; 
   d="scan'208";a="95608589"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Nov 2024 12:01:42 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 22 Nov 2024 12:01:41 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 22 Nov 2024 12:01:41 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 22 Nov 2024 12:01:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IWCWnC9f8ExMZ+3Q8JcxgVkwSg1BCN0LJV3vIEio8pHJLK+6Ix9UYfDlF0eYtiURn2XUHxOvSbw0MjHthxc7y4VsZJgaimbLQQLkzuSKNrdzjcLaq7QCwdI4V4qCJm3Msi2qtUsbA82WvlN8OUj0l0NyH1yODaBc9sGetiVnky06SewYFjwX8nEYwKEoVcnQARSgSFbvLCsn9Zq+qK4xhyfPFvVY21ikFk6oFkyBEc4PRdoWglg2mYAZKhGFpY44rEarBWlppooBW6cVnNikKMRQ5GICssP6q9LmZmFgwHJnag01IZbr5PS0Fw2zGWYwuPh81BBfasWo/ryPuYQQAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+UffEpwuvDRkzmq3VtZRtv2c7PtFeSnHXowugyuFp4=;
 b=iZA7aFk90furn4Zw1qXeqqJnHjZQ55oJKrtqP/OrtXzNQ7OktHDwRUEVX0IAzyX09xxuC5FoKPDQLRoqXcZtkO8d3tk5JQ3wiwZiV6Pkgupv8mbYjDc/ZN9iqS1XYgV8b/bzvQnEieZsV12vYh265wt/dlCmCN30mwi0Wx3JebpyWhDGP6NTrTq3RhHM6sn+iVHj8XUGRUOz+rsOsAYO+UJI1zmYb2vVhKTX99qraBu+yYq84r1b+1GsMzdKKTnYi7nyuXClP81KVvDeO++huz6TGXEG5alLOTpokgpxWVAKJEHeWb0qukaMoHO0yP41ZYuE6RBvbC/IZeJPup0GiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MW4PR11MB5870.namprd11.prod.outlook.com (2603:10b6:303:187::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15; Fri, 22 Nov
 2024 20:01:31 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8158.023; Fri, 22 Nov 2024
 20:01:31 +0000
Date: Fri, 22 Nov 2024 14:01:25 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Shen Lichuan <shenlichuan@vivo.com>, Yi Yang <yiyang13@huawei.com>,
	"Vegard Nossum" <vegard.nossum@oracle.com>, Harshit Mogalapalli
	<harshit.m.mogalapalli@oracle.com>, Christophe JAILLET
	<christophe.jaillet@wanadoo.fr>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: [GIT PULL] NVDIMM and DAX for 6.13
Message-ID: <6740e31574b0e_2de57f294c9@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MW2PR16CA0008.namprd16.prod.outlook.com (2603:10b6:907::21)
 To SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MW4PR11MB5870:EE_
X-MS-Office365-Filtering-Correlation-Id: cb37bd4b-d158-45bf-ceb6-08dd0b3074ff
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?AobS13W+L98olKWCTLLS7nXHJonhscGTgAprr1d8JpDzge9Lwxp+P0AlGd12?=
 =?us-ascii?Q?53micokIoqGaQ5fkGE67jWnqdO+SL+hPKNg2nRsY9ZhNDsC/58ffFekQDv5s?=
 =?us-ascii?Q?hkgwMhqlS6w6q5rnzviia3u1hQdY2s0XRDePXs7Cpx0ehoMbVKNsAMnZwnea?=
 =?us-ascii?Q?/F1NxuFD7GVPZ+H7TjW4E9xjmJKC1hgd1XYV5/ukR8W6IbPdCZLKUek9dcNR?=
 =?us-ascii?Q?DoywLz8qgsjCPDf2TWj292A/DbQ+acy5MrPfYN+/vvmfEaAND8yLwjphPzzc?=
 =?us-ascii?Q?FB2saOcv/q5DDlMDOFPeMe3rMoXD5msUOLzOMXIX8+ZgqBIyKrq9MiLb7UFU?=
 =?us-ascii?Q?4D+0llzoK0t6fZSwNiP5d3iIazvsDMTTvn77wdCvqG5y5J9Y1CHJb+WMP+LP?=
 =?us-ascii?Q?Igk3wTIfWTpUopGZ1WVamkuNEqBAumjtIOI+AO3GPRKJBHtc8NiHTV8ovme2?=
 =?us-ascii?Q?1dUlh5ZKXABnOPKKyE0+/NI+h0L1b0/FiNs/P5OR2NBfiYDUEFHC1kMw1+bD?=
 =?us-ascii?Q?DgJkQ3ZmQr7akpVQEoqzCnqqp1S1Z1t7ErnCUdBcHkthx7JPYbFIZ5yaJWp4?=
 =?us-ascii?Q?8os6PtesTyR49mNZ+M+T3i8rR/TZWM0fQ9l6cnkHvT79NdbCsMUX0eCDDaPo?=
 =?us-ascii?Q?bq81SpBYHtcMCYdn7/vurUrOXJhPTG6U6I0RmE+1DXeeTEUzIgsAV9ChXBXl?=
 =?us-ascii?Q?nNWDPI31lSxOFu4ssRnl0He4OPiLsQCmTzuH3Tn8SVf2sBNFrDNNKyMm/LlS?=
 =?us-ascii?Q?+gUwXcJ1fvTaOq+G8JkXLewm6HVQtKyzvWo3fLMhFLgYBpvGGNJCnSViHBCk?=
 =?us-ascii?Q?qB5MOeCJsq5cuF2bC54FntZ8EOgSxBDtHV4SZMCTtGYpfEQUXE8h0SKSAfqx?=
 =?us-ascii?Q?nrt9Dtmpy/JCC92ryCVx1krXq82pcb+6jzQIyXFCwnlld2I3Vmm5QrdBGXIS?=
 =?us-ascii?Q?nqtslsIQ2J5johhDHwL/enenYLmhHA8qJJvU/vs2Uou6POYZ8AjyZ5ZT0sVA?=
 =?us-ascii?Q?ekfwuyLP/hhgLO1s1q9K0gtac72hf09gndooAHv+MtDfBVNK/InskXzlrNLc?=
 =?us-ascii?Q?j/623iioV+lB+q8u9rPWdNGLTZvNrOzJdbGOE4AV68LxeB5l+GrxXLhko0xs?=
 =?us-ascii?Q?P2YUbwQFR9JrsNMZJbOz4mGXSx3oapQGzbz02aBgbQ09jdIbXA00D8C0vwJh?=
 =?us-ascii?Q?o7RvYZrucdIWc9T9CGQKxAga+kRYt1VbCNDu5puV9gjegwfkhnaBX3ltN98p?=
 =?us-ascii?Q?skbtM+MmysAire1Q8rq2RH0QhqU8TSwl3moMHlYI780kW0dfGSrPi6rndqLg?=
 =?us-ascii?Q?gBAU27kQ3LVdrvHgOi6Chmsw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VPPQ9xTxRpfaCGoy9cqkHbjqX2D0MUMz/NkQm4UDVu937o6nOk+5MyoUjf/a?=
 =?us-ascii?Q?HJLU5wE0C5SXER7aQWQ/LH07FJQILDsooKucEZ0k+dIzk6ETaWD9jaHA2BwH?=
 =?us-ascii?Q?pcaaEDb3l7EinzMU3yoZfappG2YvmjwuWxEm4kf7tUtWtLsrv3DmUWtmkbbl?=
 =?us-ascii?Q?CRBr/PtT9BvcOJ4VgcCJy81txsjdQi8tQ9dTONfKD1vTzHhAKKHxf96XWeOX?=
 =?us-ascii?Q?ZBrhlQipAAxETLpadcH0jJj8YRgDZQOOuikjbpEs5rgV8hBp59g9yc+XzlkS?=
 =?us-ascii?Q?BCLM5TcbwCZhL+x3sSEfASBErgzrFdwZsvxJKexnZwTNvH7sG7vAcDyUbBPx?=
 =?us-ascii?Q?S/u14W0m8pnVRmxejUTWwk2xJ0PkSPuBdUoZtDes9hNnyj8P24hoJB8Esvet?=
 =?us-ascii?Q?TdmzDbU5MjRyNkUfX1BYoMn3qvFb8mgz1vkEV3Oe1XNqkjlR9LetL18cb5/d?=
 =?us-ascii?Q?3rA0A1aZcBem20/1wYt40AYLqz/SsZiAWuAm3uMIjw1H0ytcs5DeLIp9w1SA?=
 =?us-ascii?Q?1dVoM3KCtvasK67Mgo27JYBtZ3xQus7IICmyGIV4AsXakGUEjDU2uPO9uayE?=
 =?us-ascii?Q?3J+4COu+aXLTPhWeOAHQqjhL/DfwAp/m5M34GUuVZjmkPQuzOW8krsvoaqMj?=
 =?us-ascii?Q?UcOQKxWJG5Co6bM+h8GA0QkTTASKbwvdppO/+NUduwBTfdD4yk6ey4iuphRk?=
 =?us-ascii?Q?F3oEQvb5DLsJtooKW0vI1xLEPv/IyJ3l+3EK5rBEVgs3OUG7pcxlU6kOzu4a?=
 =?us-ascii?Q?Y37a0KtskiH0kIdtdoLkPqnKPuf3FmhKusYYJGOl6LlLDDf81OyNwsRhWbSZ?=
 =?us-ascii?Q?MKpSGS+GTY/fgJ0g0jBe8/HxlKnYMlUXWKTDs/YQTFFrhyLsr0B7FBW5Wwxu?=
 =?us-ascii?Q?ZkTXpaU/97yDgf1mmM0dzcG0fxl/0QTF4DpD38LN/NtgDr/uQWxxSEhnX0V3?=
 =?us-ascii?Q?pMRUTB300SfO1dubtYvsVD1iA+O/6W48z2ikoL4caO4ual+o21R6lLu0aqkK?=
 =?us-ascii?Q?pFYmQdi0bxFxZcRDK7x8aylPHNzRwzkqNwhnmI9bsuhVUFU6H0uWksybOvWd?=
 =?us-ascii?Q?cWlRNduFw9xT3OWF9d055ZGvoLb93g1qOrkJIj5+R51lP23eXui75XG5kus8?=
 =?us-ascii?Q?TFUscqRKKBh9j/+q+cBZ9y2OvvNsdBwsDzNWH4DH838tM2zYJKxKqd8lgHHl?=
 =?us-ascii?Q?KfjZWBx4Y7XbvEykSXrNMOsKesHUNdQDvBC6smRENZ2HtIgO6CG6x5np9yZm?=
 =?us-ascii?Q?KMpJQqxiZIKVDgVyV9thYCKSTLgIr9fRvo35wIpimuOXOLqTZMltHjU77Q81?=
 =?us-ascii?Q?HRnAG6+IPE+u6xlQbNpfUXIiZVaTTsiC5GTc4lL5kG5Udr8SaY1b33rS/OZF?=
 =?us-ascii?Q?Mh+wexW7uISoNEeh+wUJsGd77gZiqpF8TdiBfOSD7mGDd5jMJds+tFrZvWeu?=
 =?us-ascii?Q?VDur+mq3KaBb5seSLhLDs6SJUOJU53GRcoawNHjtgmxi2wgASdZ3ewMuntXu?=
 =?us-ascii?Q?2QG131aY3ABspFhsZr/CiFxR2WYTgpPITY0g4m42wUeinsFX+Jb2+VrUoS7q?=
 =?us-ascii?Q?d28blXh5oE4Vctiwexfu59iuVUfkTxVueQ48lODe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb37bd4b-d158-45bf-ceb6-08dd0b3074ff
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 20:01:30.9809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6YrE3xL2nQLpbnzPepgGKy9sAUepXUx/4CHtQj9rZ8G9Yp/FdE3dYt4yGuQUpu6bFsOUoCymi7wJjesHPn84uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5870
X-OriginatorOrg: intel.com

Hi Linus, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.13

Changes for the nvdimm tree.

Most represent minor cleanups and code removals.  One patch fixes potential
NULL pointer arithmetic which was benign because the offset of the member was
0.  Never the less it should be cleaned up.

These have soaked in linux-next since Nov 15th without issues.

Thank you,
Ira

---

The following changes since commit 50643bbc9eb697636d08ccabb54f1b7d57941910:

  Merge tag 'sound-6.12-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2024-11-08 07:44:28 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.13

for you to fetch changes up to f3dd9ae7f03aefa5bb12a4606f3d6cca87863622:

  dax: Remove an unused field in struct dax_operations (2024-11-13 13:00:35 -0600)

----------------------------------------------------------------
libnvdimm additions for 6.13

	- typo fixes
	- Clarify logic to remove potential NULL pointer math
	- Remove dead code

----------------------------------------------------------------
Christophe JAILLET (1):
      dax: Remove an unused field in struct dax_operations

Harshit Mogalapalli (1):
      dax: delete a stale directory pmem

Shen Lichuan (1):
      nvdimm: Correct some typos in comments

Yi Yang (1):
      nvdimm: rectify the illogical code within nd_dax_probe()

 drivers/dax/pmem/Makefile  |  7 -------
 drivers/dax/pmem/pmem.c    | 10 ----------
 drivers/nvdimm/dax_devs.c  |  4 ++--
 drivers/nvdimm/nd.h        |  7 +++++++
 drivers/nvdimm/nd_virtio.c |  2 +-
 drivers/nvdimm/pfn_devs.c  |  2 +-
 drivers/nvdimm/pmem.c      |  2 +-
 include/linux/dax.h        |  6 ------
 8 files changed, 12 insertions(+), 28 deletions(-)
 delete mode 100644 drivers/dax/pmem/Makefile
 delete mode 100644 drivers/dax/pmem/pmem.c
