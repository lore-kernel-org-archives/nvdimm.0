Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C87E224887
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 23:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745277704; cv=fail; b=E6bS9j+iKJzyHyL5Zsiw0jfpc9d3ORLtl4LeLt/TkuAVDHzgMpmMrGv3igtxDcP9p2ppv56j8rimLACt9dR9Ias+JU5LyydLtFgyQP3IBq1bHzu3Pp18Tzzom/M9MMpa37H6LainiIeoRgZElW4mseYkcnT2VFz0dWjVO7zBD7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745277704; c=relaxed/simple;
	bh=X8ODr9yjmjen+/H2N1cTaDJnsfF9/6p7VVgm+NQ5dnc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Iz8xJ5Jh6b+mSO3bHLAeaALYESjNqVhzp5DFRE7dRXlSEqu9MrbcO/HI+u0fIuUcfTARj4oAZjo+goZlIw/90ZrTLew567GjrNKBIbLlRM3g16rvDQz89Wo0YshVmBl80wfG/2Km4Im0mOX5K4N6rqV8sv8XzAk2Hyzy72LwxHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZWnduDac; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZWnduDac"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745277702; x=1776813702;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=X8ODr9yjmjen+/H2N1cTaDJnsfF9/6p7VVgm+NQ5dnc=;
  b=ZWnduDacMKXhlCK73gOVl15HSLf/G49fj6ffBIUMf2kTaXCuGIkQb6tR
   K4klM77cadkG7mdaDUsz1alZKIZMyY1XYpn89oqnqi+8NPDZdXx0DoUgG
   9zzGf3AEL/a61FtDsI8s6ymuMWogrqT8VwHT+KeHamaj0JvuTVhJPGteD
   QOsI0Q4KFPuIJRDkz4FDMXD9SZapFeaxop22vfBP2ag7PstwdtvHKbBPD
   eZQJ8tyUloTHd5lvdmi+b2MiqHgcEfGquNUifLUMaNNYn2jcMKLMxJW83
   sCIVVhs+KqcuSrqSgrR17cAEtWCBnk0PZGChTxsLX9MMkhjVBUM2NIuNQ
   g==;
X-CSE-ConnectionGUID: j4WoWfHmRAaZxC/ToN9hDg==
X-CSE-MsgGUID: GbMftsouSD6SCdhbmAvBlw==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="50621885"
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="50621885"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 16:21:42 -0700
X-CSE-ConnectionGUID: ZmKdDpdhSn6X9CwKmHItEw==
X-CSE-MsgGUID: 9hovG0COST6lKOSJaO4KGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="132804951"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 16:21:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 21 Apr 2025 16:21:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 21 Apr 2025 16:21:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 21 Apr 2025 16:21:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BRSAJG36BavCf5gdJVInJEuroew01rufY9tlzW+k6Eko6FTi0CpVeCie84B4j71SJkj2lcjSaQ0CXcJH2PW9CeT5lPP9LtnCxW/tcOamMbMIOjxfPwt2Mi8Q5l4luigzqATo8/J948dKamc/SEF++d4eT1y6hH76axxd0PixM1zoXFWhaP2fvHbA8ye6CeAINRpjQg7o9n5tze36U2z88vEeox7HawpYjQVMfieuUOJx6OwHOvCmXOPoZ2LQw+CbIluoCkcf+Ai+isUT2o9XOcJdd8mu7Bz+ynAe34Wpw0fs+QPkaEbJZGLNOLG2StlZ8/9TrLpgBgNkyA82qFNWCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3+lzcBGktDynO3eZX315oiVKoQ0PtBI3xYFVbW4hrk=;
 b=NIh8/YYiIAzkwaOOWaU9YJqJ4NWmsGVu4hc/NzNQK7tV0Z8Ez3QEG5BvPwQDtHif/Bn6iOqEIsakAhNF6v0nThAql4LoKItVQLmRNKcgXi+EJHRhGV9C+owd2rbm91IQqOsyA+TUEux+mO7kRjvCUf16lzyVHD+NN8MU+kS04z7U3EhgqtySGzNJQWNy7Ad3SFRdx4q02f4Z9yqzDnqGU/Ak1iozw/U9ByPcOJqKJkiQUUo+c4saFr+mNusax3SedYls8t3V1/E6LoJl0nlLi0RE/vJLgNs/8Kh++leERwo3KVA7N8gseZC7Fe5KBOA88NvWtHS3koSIBHMd4Viksw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ2PR11MB7545.namprd11.prod.outlook.com (2603:10b6:a03:4cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Mon, 21 Apr
 2025 23:20:58 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8655.031; Mon, 21 Apr 2025
 23:20:58 +0000
Date: Mon, 21 Apr 2025 16:20:55 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Michal Clapinski <mclapinski@google.com>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Dan Williams <dan.j.williams@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Jonathan Corbet <corbet@lwn.net>
CC: <nvdimm@lists.linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michal Clapinski <mclapinski@google.com>
Subject: Re: [PATCH v2 1/1] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
Message-ID: <6806d2d6f2aed_71fe294ed@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250417142525.78088-1-mclapinski@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250417142525.78088-1-mclapinski@google.com>
X-ClientProxiedBy: MW4PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:303:8f::9) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ2PR11MB7545:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a57867-5699-43ad-e771-08dd812b2c30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ihfxFP3eH4eSJfwIbNx+3ixnEcflwLFUhuhR01UxKdsKGmkH7GYaCzjVBGgQ?=
 =?us-ascii?Q?txMMFKWe/EubdPKCJrzj3kgziVtWruUg7drWWwFMmcwyP9SFugW+eOEzvxjI?=
 =?us-ascii?Q?3vX0I/rT50j6mg6Nl3zKnzJyksI4en3GwKrbz7jzggOdzTWqdirXT+F+Wbwb?=
 =?us-ascii?Q?DlS5Kf4+nUgtjpk9ViHyWSYZhUCHuLPBXcFEUIk35vUrpuNqzWjBz4gF1qGj?=
 =?us-ascii?Q?0XTrFX2VLT7LNuVlTiL513cYGQ7fHhq5qkx+1POWRxIi8n1AfBq8w6UfUxKH?=
 =?us-ascii?Q?6b6DRPaN1PiBF9MXUdd1kqBVZtfLWXNtwN2qiNSXZvV96aU1yioizpxUAgYr?=
 =?us-ascii?Q?Nz1kTl3MvTf00hou7m4LX7+V5HwokIexfUr5JqhMbKWB1s3f2aUyL6L8xTi1?=
 =?us-ascii?Q?VUBIcJWh3/DVkoMDJtwSQaBHCbsTGKxqpM2krqu3WaVnodKh8fZ1C+CXVL/B?=
 =?us-ascii?Q?tJvRpEBpfExOzD2styM6VHLumrCPBBCHutPFVd/HYTdLKduzFSOXON6XAeFI?=
 =?us-ascii?Q?9DRcudVAlI0hEcGizgJR7IM6HBceQ7LcecGh3FxBTrbqLMYjvPwHwfbGI+CS?=
 =?us-ascii?Q?ZsQGtZ+fpNrGA1P0SKSesmvbb09GpelstJIni4lNJxGA5KpnSgH+0l1O+MDq?=
 =?us-ascii?Q?JVhIoy0zySfTY9XJeupFQXPjFFsBjjLLYorvP+6Lo7HWUZLBlS1faEM37ZF8?=
 =?us-ascii?Q?zrU+JBq/I9kRI87iUx4MxX6o+GZbnaxPGZ0sjEZHZ9qRwJeR17iHVVTIQ3yf?=
 =?us-ascii?Q?VItlJ/PGxGPuS8fUcD7CXfUU8rRF1AnPI8xCOuZZ0G1rC8z0c0PNW3SfcB1v?=
 =?us-ascii?Q?23r2kc8s9kHXFbfFouLQ43tbJZNe89M7iMR5M6R0FyR5yhRWXUVJzqEwRV8X?=
 =?us-ascii?Q?M4Ra9aD2wwZ7LmS3dBz/HO+X5eOniHx7YomNOrdem3N8lePKtRz1iNB6H9yX?=
 =?us-ascii?Q?IR3acdURaYeYVV+FwFFyT+6FmnlCbOlsMN0MomLhrNFHk/lyoMD03LGlHg7c?=
 =?us-ascii?Q?FQDbweLWw1q+rB1zQG/oBWWMpKZJLGOj1XjKYicf/D+kZD6hvp8GGHrCEgvR?=
 =?us-ascii?Q?wpxKD2EYSpvfsGQ2wTPfPE+42nucQMTAiTQU0OcQf5rZzT1iBLOwWy9fJ2E+?=
 =?us-ascii?Q?uASsSzLOrfD6OZH16EluOMVYIc+QJdXIwpacL0kaAfbteSB0l29GTIz8z10L?=
 =?us-ascii?Q?LVD4F56x49gEhG7qTNsIKL4d230UAnuvQJu6v33HFxhhxWe7MCc9HYhCFExw?=
 =?us-ascii?Q?+GFIhocc+1aDObtB/FMapI1i+ONfFMuZ+MONqAAWi2rP33wj2TggAuQyTwsN?=
 =?us-ascii?Q?mK3IvAk5mEBiqAH02yULqg7mm1R0ejKcB+/jbN28I4uCUKSh28aUVgqDL8uq?=
 =?us-ascii?Q?/KzJGP7MCiIblGrCCnjSlaT48uMLTICNee6U0avvEnk+M65q3w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wA8Ih4L+C8S+hAmhrW+I2E8DCtRWFYKupN6VzxOJByVd7kGsTOVUR9Zy149o?=
 =?us-ascii?Q?HNoJCmgKaJ5idEw3L6kdpj7Ljq6uU12AN22d0ccVESxl14TFL2on3l8aO+Lp?=
 =?us-ascii?Q?4W5isB0wN8KgFRvZVt8ALXfeklTTIaM8xrPQzvzva/VWhPdKAcuO2fgV8Uux?=
 =?us-ascii?Q?3/ntETRhLhPjOPSJj/qLMY6mNbRdmqWWdN4tWWg8fpyGF/IKy3hdytHR7Kgq?=
 =?us-ascii?Q?EZGnSmDHEIt5xA2QgroDL4e5UZefsIwAMLj2Hmp8S9+oui9u+Cg2A0T3cibm?=
 =?us-ascii?Q?ihd2uhhj0EimzOO/roMksnoN/TfUwzhXAkmVKoXF/la2wIBEZ5jnpZNN3Xd7?=
 =?us-ascii?Q?vY1b2m/o8XxEjuDs7J0GCoW+G8ZSkIp8BlEUA+9xCw4eHUZ0X8ejSOmaBAbh?=
 =?us-ascii?Q?cTCrxLJdzS1pCdglHzJCkJy9zw+5v3lxUBY4Ra6ep8Mx5ryzgXF6EYAz/+VK?=
 =?us-ascii?Q?VKMioUfHIfPo0/wh4osX7Jz1StTQBQsxDBDI/R7C8VFHwEYpDsBWy0Z7/HOJ?=
 =?us-ascii?Q?q3gFYvcwd69pmpInHKK00tAE7XE5pegtV/7TTTET95zw42pe57uAJPF6N9Wx?=
 =?us-ascii?Q?5Bhe/km/+JK+W4SJ6EOys37jwhat8hAAyOEH6JljM+D1t1j+2sJVGuClWvlu?=
 =?us-ascii?Q?BKEZwioxKphidRlJMGecmbbggJjSgViV/KeY4rhaJarY8MiiZ7yeJ4Df4imu?=
 =?us-ascii?Q?46GVTN8TOdM5wAwK8lyeRrQgSVY2lpCOMmfE58oUJ8GAbHSKMqAz+ZbN47Bl?=
 =?us-ascii?Q?5JPMCr+LnzKSHYRsHJY076XSNQjvDUMZuY+deEWJDyES/UvzmIil7wBh/79l?=
 =?us-ascii?Q?gBgjvhKO/4GlSh/RS1aNVrmy7y3x1kKO7cAl02zjhljWV5zrgx4k9slj4LnE?=
 =?us-ascii?Q?qjuZ38joCAPHCBuZXsYa0i0QygNbwphrdOTzhbgcDboDiEwMy3JQISUrEVzN?=
 =?us-ascii?Q?Yb3mXgd1q9tYXIWOXbpF8UNbpcQRUhRWmcHkTo8Wms3SFzc5mO4bit8AzmPZ?=
 =?us-ascii?Q?kAPSdn22qiOajoVElgge7RDzMoGssfPOPg3DXz33/DwledJ0PZrfvGymAKo1?=
 =?us-ascii?Q?RUSozUMQ8x0+bTcUTKADoHLl5/5h48i9BYA6jYa7ZrPLndhdsKXaGOAjxjl0?=
 =?us-ascii?Q?VseZOehrG7b62pPzeIY1faXZL+qJLJSUe9JUEnT4fIJKXExPO6oavIU/+c01?=
 =?us-ascii?Q?NLtwBzIe3OKQclGogHK9eL+bKcZPfd3ftv6W1TwCv9maPykRcTRvyKptCFU7?=
 =?us-ascii?Q?KHOxgR6xBfJFAubJsJrgv1EGImUw1lmSoo+qdTs8Zxbp/rET1eWw3k5ZX6P2?=
 =?us-ascii?Q?zfjFfS2vC9W+qeezDX3nrWSCPh/W/BFANMxiObCKhawCcBcZCCnFlIoZp6uZ?=
 =?us-ascii?Q?YpAa5Y7xnmHswfzvqZc2j+jnCobuNszpgP2WP1t7g5ctqILDxCzLuHe4PCEs?=
 =?us-ascii?Q?7FwYVVI2Ax6yAByBEPw3irFpc/YaPaH07SWLNsGPCzIqRjgHaXPvN7GOipTA?=
 =?us-ascii?Q?w/uf7BIT3xaVWb9EnAAAfjk9oKk6mrqH9FZlpyYINaoYLJnINlCW/uEFahNd?=
 =?us-ascii?Q?+yH04pGsUvKUJ2boq7YhLadTxBxt16JYIRu57W6itFvPCGVxRR+RI86rywim?=
 =?us-ascii?Q?ew=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a57867-5699-43ad-e771-08dd812b2c30
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 23:20:58.3271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UocFCCDaaA3QqK4Tx0W51VALomgczr/FouXabTg0Y6WJSHIyn2k5M42tte45FCiyHxYtDrs22dKvir6dWToJ52E1SI2BPiguPGz/jR74hIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7545
X-OriginatorOrg: intel.com

Michal Clapinski wrote:
> Currently, the user has to specify each memory region to be used with
> nvdimm via the memmap parameter. Due to the character limit of the
> command line, this makes it impossible to have a lot of pmem devices.
> This new parameter solves this issue by allowing users to divide
> one e820 entry into many nvdimm regions.
> 
> This change is needed for the hypervisor live update. VMs' memory will
> be backed by those emulated pmem devices. To support various VM shapes
> I want to create devdax devices at 1GB granularity similar to hugetlb.

This looks fairly straightforward, but if this moves forward I would
explicitly call the parameter something like "split" instead of "pmem"
to align it better with its usage.

However, while this is expedient I wonder if you would be better
served with ACPI table injection to get more control and configuration
options...

> It's also possible to expand this parameter in the future,
> e.g. to specify the type of the device (fsdax/devdax).

...for example, if you injected or customized your BIOS to supply an
ACPI NFIT table you could get to deeper degrees of customization without
wrestling with command lines. Supply an ACPI NFIT that carves up a large
memory-type range into an aribtrary number of regions. In the NFIT there
is a natural place to specify whether the range gets sent to PMEM. See
call to nvdimm_pmem_region_create() near NFIT_SPA_PM in
acpi_nfit_register_region()", and "simply" pick a new guid to signify
direct routing to device-dax. I say simply, but that implies new ACPI
NFIT driver plumbing for the new mode.

Another overlooked detail about NFIT is that there is an opportunity to
determine cases where the platform might have changed the physical
address map from one boot to the next. In other words, I cringe at the
fragility of memmap=, but I understand that it has the benefit of being
simple. See the "nd_set cookie" concept in
acpi_nfit_init_interleave_set().
