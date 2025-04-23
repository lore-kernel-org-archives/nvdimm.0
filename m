Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CBE1F16B
	for <nvdimm@lists.linux.dev>; Wed, 23 Apr 2025 03:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745379640; cv=fail; b=CEhNE7Y25y0dJoF0OHjXT5Xq+VoMF8f/3dtnKZL8mfaNHQK+E4fMuRNTLxcJ4R2PfLaGvHTlDJvjyMu/dGAZ/ckQ2MMTD+E/1u1Hl+ZRjv2IBlzmyWmhzVaxkBhHXlnA2jeqMgyrnoGBodg3szp7+a7wORbpfFU256JQy20m47Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745379640; c=relaxed/simple;
	bh=AU4beEhfveVcKcGDvVKbJeDobv5sCtKAZB0s/vw6ROY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TLMss61D16cLsIJXEp/j2NOAzioSUQPRE/jvDL9Cj8/PCco6m6iN/pCAtY1nbxDZRdKQvVzgWYwKGWVERdj0tHZeuVnjQLW9UlvWYPrL2cbLs2ZDOXBOcOYF1c9D+8ylaI1RQ4IBB1510vA4veXEKKzp+bG3FrHyKaU2GC3CMFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bForcXRv; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bForcXRv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745379638; x=1776915638;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AU4beEhfveVcKcGDvVKbJeDobv5sCtKAZB0s/vw6ROY=;
  b=bForcXRv21anWLZm4Btyl0x1LmuQw+AN1OrWXdSCN/2RogwxhrIQYjT/
   rrbng7496aMD+mW+2C+5uUOBXWJFGGH7HJvKOwKmKhxy+mJYkeVPG7emE
   amMEnU3UFFZwUWo5F32i3sFGEvdttVKLCbLCgqTOs3isd4TY0DVJipzDq
   L+kD4BS+KQPByAsslYPTkCaQuD9SyDZKopu0VZNg78JvQiis8og7HE8YZ
   GC3+Pada+nhQd+sQfkiXBY1MUJcEdfvPuxs3Za/uH7nYlcBq2m74jMUzd
   tzBzJLLQlgXT/LKfMP9rmn5f+z8GgY2mW1grwa2iaDEmowx8UsCkSnD+D
   g==;
X-CSE-ConnectionGUID: Pu/OG8eRTSaNb4HQ5gYkgQ==
X-CSE-MsgGUID: dOAVs9R+RPeFnPoc6CNIuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="57148066"
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="57148066"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 20:40:38 -0700
X-CSE-ConnectionGUID: mFcrp59TTyWqIwWCnM1mbA==
X-CSE-MsgGUID: nEOTUu9KTPqBtf5LIRsT8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="132186828"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 20:40:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 20:40:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 20:40:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 20:40:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xHIcfHn/kVllrWpFkP1Wcg0pRXD4wjYw1L7+9k/Vh6Fj6Qgm+cYhotX90Vf9WUk1Tcvj10YMwzeQ5HCBVjWdy3WjScGkZyvRAmuUvg32uL548bCHGNSos62VYfi4ROBYkWBVTq1b+5uR/5eI5cLU9CjU87GHLrcKxvcS3/Xe41MRRuEv4erIOoY/Bel9Y2PzfWkeWZl8VPweeEj80BroJzqO9an5D6N+oNx003EHSyDMtIpKmO7M0PHbEL+6DFfSsOVR+9R+exYhEj257+T3bNfKsB61Fitck5j4GCmW0v/HlDSN4Sv5/83acmKMh68/NV7fqflqIr6oBDSUrzuGEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sw83o6jccbP/KBTtflLLfFKyNWy2yB/JuVjsdk0nfSc=;
 b=buhoFbPXV3GcRpQY3hrNkrl5zy0QOmlcyPkGDhXNaLIoIg1B0Iu0L7x9545nd3wbDp3TZQSjDiMmo/bbQ7NdUb7IJzuDEDvvuW5Z6g6TJnnZ+10IKQ+i4EkHcx1BM7ZnZy+RJ/wahnQ9u4a1P/lkFRJKOK2k919/omUsQesVZeEZDq9Z6QRjUfkdBQSwN/JGHeyvJ6ZZ57ChQq8f1w5PvriN4N6I5ZUaWAd2sQcozH8d9YCgUF3jI+dy/gf2Tf6TqnCnc1ZzcIzIZqg0A/VOaQrDAETgn5m8X7r3hk0LHLv+VMWtZBwzEVPJqS1AqIyQntMDp135juAMXYAg9orRXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB5958.namprd11.prod.outlook.com (2603:10b6:510:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.37; Wed, 23 Apr
 2025 03:40:30 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8655.031; Wed, 23 Apr 2025
 03:40:29 +0000
Date: Tue, 22 Apr 2025 20:40:27 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <alison.schofield@intel.com>
Subject: Re: [NDCTL PATCH v5 3/3] cxl/test: Add test for cxl features device
Message-ID: <6808612be8ffa_71fe29469@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250411184831.2367464-1-dave.jiang@intel.com>
 <20250411184831.2367464-4-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250411184831.2367464-4-dave.jiang@intel.com>
X-ClientProxiedBy: MW4PR04CA0194.namprd04.prod.outlook.com
 (2603:10b6:303:86::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB5958:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f67eaf3-46c2-4f67-50a7-08dd821897ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?g479kzmhy/Dv/QlHNEOJkRJLmbdLAz04FbHJDV2vRU3qhxBRp+muvyRADch6?=
 =?us-ascii?Q?txizy7THvLSBivGN/8a4g8d8/xdXjCNgzXUC4x9P1Ht55iiHYUUeR5nn11Tc?=
 =?us-ascii?Q?8Yr0hAyks9vzKagoTZnSdspSUCugYXjGnjdQ1RWRM8hM8Y4wYaryOuYKckR3?=
 =?us-ascii?Q?gd4ZJrXdGBJxYNQj76ff83NmF4LCWA7Qr/ztQVtMEYBNKPD97jCmFB7rx8rx?=
 =?us-ascii?Q?61iQRc9CRRCUL/eJrw5H4Z0QYCCni9Yx5wyrizegTFqw2xmADzIvwtRT28/K?=
 =?us-ascii?Q?vfSZh3sA6/99egPv4e+ZIp9/e4g4U52aAOuLWbRJXaZe9lRMMuwryuekey8C?=
 =?us-ascii?Q?qw/EMHITP+oGsJbPblm7N+9nPWV9ribaE7ktdjCt1pPtlOyE+3k8Ml+NR5QJ?=
 =?us-ascii?Q?0AUjcR73jLXgsQvvraMFTEB3VeujQDCXsFnjGUGJ0J9bZd1cxS+p8NnJ/OEo?=
 =?us-ascii?Q?/fbitvKfiP/eDcCIpmfqj2akfaEP1qcq1jT8RDQbwZMAzSq08VRetI5hSw4Z?=
 =?us-ascii?Q?GwpUgaiZZpc9sdq22KdPpGWrslP2rTdcoKEWc88Ja74kl6ldYZ36i0y+aXM8?=
 =?us-ascii?Q?bAOsNdYg5E2eT/1BQo7rU2ghpZSRMp/MzJYy5zBpTYrhScjiaXPprprJC1q9?=
 =?us-ascii?Q?h9iOPonEDtA7huSmDy6wTbfoRWRIyxbbOz0pvzmsxSfKSjINLJ1phRwSoBOp?=
 =?us-ascii?Q?QJEHyuPFGpPwAk8GNXPifNCuqUW2RUXhLN9SMWjenudZdaluHt7DMWtxLjO2?=
 =?us-ascii?Q?lIQj1v65ZedftjAuo1mOIYFZhdIU2CQfO9Xh8oIzLWkckvl++yZezb5bXluV?=
 =?us-ascii?Q?9d4WYiKQS33B4YlBvO+z8HAC/I0jc4kl12ALNl96HI6iURKsYVatDaNoGJOR?=
 =?us-ascii?Q?GoaDxKY+1Jvm7n1ZPguPCle5DGhajpr4zAlhb/VFJ2aEw7/139wQtb238E+D?=
 =?us-ascii?Q?5EWDxABTN/IJKuBqAP13euwcJZTQTdsYaEPji/Hx+fen5N9qcuQCHL3osdsW?=
 =?us-ascii?Q?4fCP67l7DIuLCQXAoz5BV6SwrqMSQrYi480l8tJkgLkOubNSsGV9s6Gt8sdL?=
 =?us-ascii?Q?AbXp6CrXC8b8YCRogdtM2f/QjYWTpkbr/U/J5cq0u+PLvr2EnxrX2TgvSGyY?=
 =?us-ascii?Q?/m+ywPROd7JcHTm2pfywha4Q8kr9Fsn88tmgZkoDbe+YCXhdUwsS8ot/274f?=
 =?us-ascii?Q?j1nTizgjpqvMzUxZjAu7kdA/qby+x7kVeLCeUzRM9uf6KtAxVdmxxZ9S77eQ?=
 =?us-ascii?Q?CEA0mVfFEDBkeQAwcRtTHgp9nlzaFUqPCI9+hdgn06AxyFUmaKhUdiFUp6dz?=
 =?us-ascii?Q?d+NEv8Ic2qOqmUMWGuo7HjIH7UE3vfFFVeK79/rnTS/4dbrXzrQin5Uq0myO?=
 =?us-ascii?Q?ysP8zByn1hTFnjxqumRlyzeElHfQpgs94zx4IattqgIKu+3UoohepZq7i3l/?=
 =?us-ascii?Q?f7ghsKHcvvM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PzcGN+nOFCi6JqV5LKK16L6H8M7DAlxLEV/oniwnSAxhHCPbV7RebPi/RDAa?=
 =?us-ascii?Q?uQ1mAdMqZzy0sYsvzSRPMTdS+/X4DgTA6tCM4u1AlE5VBkpGlbKlSa26kJb8?=
 =?us-ascii?Q?QHVdw9Wjb9gmwegSUuwZwE5DJVp1RUhDd6p49ea7JxOMV6F2Cjpq6qhSYKA8?=
 =?us-ascii?Q?QWqp0Opia4EIPSob8DbNy7e+Bgmgufe4MNvjx4abm60RZk2rUoIyDaHfPkPI?=
 =?us-ascii?Q?iHSA5Vwk6pTi8kvzlAn0O/tBXTGbPSq+s9W03nxx9O67hHnyH6Gh6jAyLV4F?=
 =?us-ascii?Q?F+EP8WzhAdHoWIdC4rcvYNNmzhTHzYyIauSZ9v2BcqjR1xz8wrYbV59P98Lo?=
 =?us-ascii?Q?M260yl9lzDZmSQJ1LrAMmP+HkRblQTjP5CLqiWvvsr+/xlStDIJURniRs3MS?=
 =?us-ascii?Q?EO4A6t/uBSpXYCwEpFuf0tYPVL1+Yg7l004bf36wKz0w2/sORcrdzaNmtkfU?=
 =?us-ascii?Q?JEK6P1HHaS/y5mk25zOZEIjAiqaIkblLH/lC3lHM8IQaMYG/74YNyS4Z23FA?=
 =?us-ascii?Q?5Ll3hd6mjNNsIYpbS7njDDr9IHdaeR0lRBvd1q+4Nbuf1Z6vq8rK3twzmhTr?=
 =?us-ascii?Q?XViNh+Az0XMkBUUiiP1AJ3vEsWvQSa9UW4N7dcUtQs3wT5C8Ron3siLY6UOY?=
 =?us-ascii?Q?5EKWKkoWdoImA6QAicw9cTYWLaOY9pIdoiZmbusYG7TGz/rNNwHLL6Sgr8TE?=
 =?us-ascii?Q?aeLPNN19Ggv6yKdxaBlwSwdke/MPmOnSO9gpgBF5RtVuHUNKHUAqxto6Fex2?=
 =?us-ascii?Q?12S24Z61MzpKdT161NLrd9LihfkfMaOcZDqE6F8DrpRqaSt3uFNqdCMWXa/u?=
 =?us-ascii?Q?zEkpFrqhjAE2sa5/hCmCv8tvow/PPWeyBUo3D/v1Z9A/CWR0fN02GAwvUyPV?=
 =?us-ascii?Q?Wq5LLq27vI+Cg2nAKbkitpARPSesNFRCOimSNeVjTlMu2k0heM/ayGPyEbQU?=
 =?us-ascii?Q?Pu6lpaymC9CIR/jxE2vqM8Uey89CoRDjeU1YFVHU8r9zFNdIgCIo/d5Hd0Xa?=
 =?us-ascii?Q?QV4f0HnB7arRxkK0Hj5VYKIwpE8jjkc6G0B+Vw4yK8bYE9PWfGYteIEohdPl?=
 =?us-ascii?Q?QA0uKnns/K3vAupMxDUnJDnKq1n7UTRe63UsEBw876iT+P2bCB1mCTPBpnPx?=
 =?us-ascii?Q?CVWONeWOGoVo03MTY6BynzdegaGYkP/WtTkvos1aGC0i9CZo1N17WC+X8PIG?=
 =?us-ascii?Q?vnScLLplztyLinWzfXMYysC43zcf30LzXA+KZdWnb+KY8wuU30hf4Y2+H4my?=
 =?us-ascii?Q?TlMyHWyYLBYWHlay7ROFIhoveRf81jXn5pIq3ydKA+zDrZAcUb+BmVSIwXcd?=
 =?us-ascii?Q?ikAO6Vv/4j2dM5KWhWDRsqPEeB/uFDIDehX0MtzyQw4K67uQX9FfbM7qWTCX?=
 =?us-ascii?Q?QjtejPsUs+7jJgK9j7LfwgjbooyjebY6+2gbswWYSXif5xRamE2tmYJQjalN?=
 =?us-ascii?Q?n72RCrYQjuy4oRixM9XkKAj7fDxqRRBhWB2WhEtAhcgsF97gqZa7bf9Y0Qdh?=
 =?us-ascii?Q?pWjQjYvt6WJl4cIj+VxcAC8e8eDuE0nRhQFjlNyiRh4HBa5ErlK5Zafgvyb2?=
 =?us-ascii?Q?iueCfqR8cRSXcWn2qFyhTZLBpAJUjwTzbdMXNHAImliZaj7IuYO1nH+LfjI6?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f67eaf3-46c2-4f67-50a7-08dd821897ef
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 03:40:29.7853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aO85ZsIb0yJOGEjqz+HVgZfRHdN1K/5zsI6Qa/t0MC4JbShsRoWPNQPE2c1Dh9zVzF4P00Srb1kf3AIWPZE/h/UItTa5fgxlo7vjHFQTRpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5958
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Add a unit test to verify the features ioctl commands. Test support added
> for locating a features device, retrieve and verify the supported features
> commands, retrieve specific feature command data, retrieve test feature
> data, and write and verify test feature data.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v5:
> - Make command prep common. (Alison)
> - Rename fwctl.c to cxl-features-control.c.  (Alison)
> - Update test code to retrieve cxl_fwctl object.
> - Create helper for aligned allocation and zeroing. (Alison)
> - Correct check of open() return value. (Alison)
> ---
>  test/cxl-features-control.c | 439 ++++++++++++++++++++++++++++++++++++
>  test/cxl-features.sh        |  31 +++
>  test/cxl-topology.sh        |   4 +
>  test/meson.build            |  45 ++++
>  4 files changed, 519 insertions(+)
>  create mode 100644 test/cxl-features-control.c
>  create mode 100755 test/cxl-features.sh
> 
> diff --git a/test/cxl-features-control.c b/test/cxl-features-control.c

Not that this filename matters, but if someone was looking for FWCTL
examples with CXL filename does not shout "look here for
fwctl examples".

[..]
> diff --git a/test/cxl-features.sh b/test/cxl-features.sh
> new file mode 100755
> index 000000000000..e648242a4a01
> --- /dev/null
> +++ b/test/cxl-features.sh
> @@ -0,0 +1,31 @@
> +#!/bin/bash -Ex
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2025 Intel Corporation. All rights reserved.
> +
> +rc=77
> +# 237 is -ENODEV
> +ERR_NODEV=237
> +
> +. $(dirname $0)/common
> +FEATURES="$TEST_PATH"/cxl-features-control
> +
> +trap 'err $LINENO' ERR
> +
> +modprobe cxl_test
> +
> +test -x "$FEATURES" || do_skip "no CXL Features Contrl"
> +# disable trap
> +trap - $(compgen -A signal)
> +"$FEATURES"
> +rc=$?
> +
> +echo "error: $rc"
> +if [ "$rc" -eq "$ERR_NODEV" ]; then
> +	do_skip "no CXL FWCTL char dev"
> +elif [ "$rc" -ne 0 ]; then
> +	echo "fail: $LINENO" && exit 1
> +fi
> +
> +trap 'err $LINENO' ERR
> +
> +_cxl_cleanup
> diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
> index e8b9f56543b5..90b9c98273db 100644
> --- a/test/cxl-topology.sh
> +++ b/test/cxl-topology.sh
> @@ -172,11 +172,15 @@ done
>  # validate host bridge tear down for the first 2 bridges
>  for b in ${bridge[0]} ${bridge[1]}
>  do
> +	echo "XXX SHELL disable port $b to validate teardown" > /dev/kmsg
> +
>  	$CXL disable-port $b -f
>  	json=$($CXL list -M -i -p $b)
>  	count=$(jq "map(select(.state == \"disabled\")) | length" <<< $json)
>  	((count == 4)) || err "$LINENO"
>  
> +	echo "XXX SHELL enable port $b to validate teardown" > /dev/kmsg
> +

Are these unrelated changes? I do not see what new cxl-topology.sh print
statements has to do with this new fwctl test?

>  	$CXL enable-port $b -m
>  	json=$($CXL list -M -p $b)
>  	count=$(jq "length" <<< $json)
> diff --git a/test/meson.build b/test/meson.build
> index d871e28e17ce..89e73c2575f6 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -17,6 +17,13 @@ ndctl_deps = libndctl_deps + [
>    versiondep,
>  ]
>  
> +libcxl_deps = [
> +  cxl_dep,
> +  ndctl_dep,
> +  uuid,
> +  kmod,
> +]
> +
>  libndctl = executable('libndctl', testcore + [ 'libndctl.c'],
>    dependencies : libndctl_deps,
>    include_directories : root_inc,
> @@ -130,6 +137,33 @@ revoke_devmem = executable('revoke_devmem', testcore + [
>    include_directories : root_inc,
>  )
>  
> +fs = import('fs')
> +
> +feature_hdrs = [
> +  '/usr/include/cxl/features.h',
> +  '/usr/include/fwctl/cxl.h',
> +  '/usr/include/fwctl/fwctl.h',
> +]
> +
> +feat_hdrs_exist = true
> +foreach file : feature_hdrs
> +  if not fs.exists(file)
> +    feat_hdrs_exist = false
> +    break
> +  endif
> +endforeach
> +
> +if feat_hdrs_exist
> +    features = executable('cxl-features-control', [
> +        'cxl-features-control.c',
> +    ],
> +    include_directories : root_inc,
> +    dependencies : libcxl_deps,
> +    )
> +else
> +    features = []
> +endif

This does not look like typical meson conditional functionality. I would
expect is to match what happens for conditional "keyutils"
functionality.  A new "if get_option('fwctl').enabled()" option that
gates other dependencies.

You can add Acked-by for the series after addressing above comments.
