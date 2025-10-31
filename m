Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B269C25C802
	for <nvdimm@lists.linux.dev>; Fri, 31 Oct 2025 17:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761931343; cv=fail; b=FBLwY6N2nAn4EK6YDezQk4zz5+lDh++rKZ0MnVfd50dx6q0d1goCBzZE0xbVr9CARRDhrD7dPiVNb/9KSjDxQ71wo5CnPPc6emiZ30T/7WG0fnUv0jNbAkwptAnm+TyDHatYaMLlkE1/h/yg4tGiS0DzqqLUgY4akLHrbo0ojUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761931343; c=relaxed/simple;
	bh=LeHAB9LgymUyHkBB/e9gP6JnVdZ71djZ8J407XroSKc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lOwtvD0R4zmlgLiiYtNpKqvZYELK431NK0yty7zFmxNRLf18ksCPZ/V6b7OMKQXm16gemwdmsbyhWGAWMKJvHnoJPwLdOpvuPHJ95pH5lB7s9t3HiOWoHCLA+wxmTMiiKZeNFbINeW+gjHdlyzapQ83eYqtOpBHtzTjrAQULrhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L1N7WvSV; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L1N7WvSV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761931342; x=1793467342;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LeHAB9LgymUyHkBB/e9gP6JnVdZ71djZ8J407XroSKc=;
  b=L1N7WvSVZod6tQCediYg7fQt7Nm/QQd8baXW5qzgQtzmO8B/N7XYidJk
   a8ATCO91b9Rs2KryjDx4Wc0LcuNi9g1GF0h/xfrNt9kLPqrsEq03S+bV4
   dcm6YoXsfww2AUd46vxfUce/AnwUP1SLayz90JdCub5ninc3YASMMhsaE
   r+T56SBs5GP05ELVEVOrA2mxBOPJlzH2ZAtDACaSwW4UkkkkuJbr0Mv45
   F7Ft3mfPA0sBKJMOsuj34rdZwJxxlNyR9HCp+EVqrm3VYLLWeXci8pNtv
   fCVbiIxj2sNkvw05any7Kw4XQBNZy7hFfU6MfX5aMb6CgY06Lte9fMEks
   g==;
X-CSE-ConnectionGUID: 9LGhE6oDTXmB5c40nCpPsw==
X-CSE-MsgGUID: hkhBH+o4Q8OUaGNL4fyQLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="64248453"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="64248453"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 10:22:21 -0700
X-CSE-ConnectionGUID: tMK6YdlFRPWFnHMBwbCZ1w==
X-CSE-MsgGUID: fDn02KjhSzGIWGaDhvIB6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="191431923"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 10:22:21 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 10:22:20 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 31 Oct 2025 10:22:20 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.36)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 10:22:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ywQEjfRK1jJbj9ktjxWkZE0JlI6hBpNpSkyYmku+lKbuKab3tilQ77RkBXArT1HsyXvvIxDcil7ZZBGb9WLpKSvHS05HygACFfPUyJI679mt9xVEZn3PoagW4zBMkIpytO9T8WAdRJKoiM3LrCjDQceW7vvYar6IvMVj9z8kc+fdZMUFA94dpFI1BTI1+QxQXApsgNyxesbGDYXnxco2IimTG+idPjnr/gGn0hqb4jW1ECI8z5BOnN/yRCcqKb18cKkC6uSdAmbFQHcRvxGvfBH/tvjD1UOt6L6OdWVHpQk5YmxI25i/HgW4CRt2okEcbJF17iOk8HhISl1Zi9x8fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygnjNwICvL8/jc25MAUmyry5/WqO/L5XsNOMasEQVhE=;
 b=lHls64c9f+AVXc/vURbrQyJZQ9GHonLYSYT6PbuhdVQ6v6Muft9Efrr9mj+WRNY9B8VXzCC2n/s2OHWzw6dcecBIvXri9Om2ElW0kI/3yTkOv6E7rj06glqIVv7Kd84iRUj935Mwe3u//h+eadDYdg7pbVvB+LEZnr77cyHNi+6JjtXv85/5DoaZ1YwxdhB/e01Or5YGGBik82XqP636Hg1NzznSCuVL0qhlMsWZeFNMDmpEvXLAXgl9PRpN5RyeLhZkDlF761cjz+nKBM9Tk4iK9bfPcPiekq+fmyjPyAZ/Cv7XaZOjGCycrhIu+RFxK80bwojsQrqmfdG/CDvF9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA0PR11MB4525.namprd11.prod.outlook.com (2603:10b6:806:9d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Fri, 31 Oct
 2025 17:22:18 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 17:22:18 +0000
Date: Fri, 31 Oct 2025 10:22:10 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
CC: Marc Herbert <marc.herbert@intel.com>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v2] ndctl/test: fully reset nfit_test in pmem-ns
 unit test
Message-ID: <aQTwQs56GMXow2Im@aschofie-mobl2.lan>
References: <20251029032937.1211857-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251029032937.1211857-1-alison.schofield@intel.com>
X-ClientProxiedBy: BY5PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:a03:180::18) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA0PR11MB4525:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c985d99-05d5-4a5d-1c13-08de18a20b08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tLqlfYTo0k7y0qjIC3qfvl8cS9qcgRppyoUkeBLoA8vhkpb/USy0DFQsu7lf?=
 =?us-ascii?Q?3msd2Nyv1oac5+vLirBw/VL2KNxUoW6+SsZx+wDc5tpesFfIWfOT/emDRzQU?=
 =?us-ascii?Q?YCYMWcmYNIwqsK4lDQ2JBYlpOlHaK65koqhmDfcAC44LoePCZ9q06YDyw5k4?=
 =?us-ascii?Q?LuHrFYOEh/MGJfpz57GVbcTbnmxRO5wEH0b2l7PL/ZAYJn5wZO9KIyAeGLf1?=
 =?us-ascii?Q?BoP6uXG4QJTYBvPzMEfya5Z0CSXDEaQTegeUPblrW1Uu/12GnNbAwQokC+E1?=
 =?us-ascii?Q?lk53emgSBZufWHUPxDSa7jsSaf/f1/NdoT4f0CoWNPz1Mp8+wViuCZGfNvCV?=
 =?us-ascii?Q?x8aFCnTnJ9LVXn+zNVRgxbL9eMIYNlIlWTx0Rzd5789hGsMYJunKPXdQoEDu?=
 =?us-ascii?Q?uuk08EEPuK6YedCREaUO+L6h88OJKSV4shee53Ey1pguuiyLAoFT0P2/hWi9?=
 =?us-ascii?Q?HWY7IpcsXf9017stA+Obq43PrZbAF57M3N064dlVniCkLvnc62HBEdq+YI0S?=
 =?us-ascii?Q?vsfoJQZRvtd5ixicv/3vsK7L51ken956/X0v2dOeWYZCqmMDM/w852HvbAZa?=
 =?us-ascii?Q?Fr3xMdLOi4gSx4et+NiyQnqxBua1jD9QS2CmpyvMMaxeAfxKgAQHW5rksvUi?=
 =?us-ascii?Q?UH/NENCHi7h/1f3aIJNZfj/uyxMWRHn/J3vUDArGKFFIXHu3Zy8LoYzO2oFc?=
 =?us-ascii?Q?0KQ6T3uBdCGygbJOdTxLuyPj7sLrpIjonfgAk+iomC+se6QzsF3mVR0QPyBl?=
 =?us-ascii?Q?Tclh/y7H6+ALY+VUnvD1oTXuZuVVot/E9g7C04naRIw+l6t3FaFOCUIykqh8?=
 =?us-ascii?Q?GoHGW8oGnGiHZV5N+tpj2Drp6EmwCosp8hR22qlKJ99f9LlCfC0I0CrdvQ9x?=
 =?us-ascii?Q?CFGwK7spa9rB1EPiHskb8ckIJ+7wUdaxATz56q/X32rgic2BVlhcaQrLEVid?=
 =?us-ascii?Q?uGYyN4ZtVspLcvJS2Z4aiHMWPFAkvCU4o+tqgmJgkWPkV1dX+tRrk7DFU8eh?=
 =?us-ascii?Q?HyukhuxoB1bHZA9rrFINjJpmv/lxrU3Rk7zaE0XpmZsMN1+dGlYUU6ycwcTX?=
 =?us-ascii?Q?7jQsVA/5/GgpL/xki+BZlvPtLocCIgxvUwOP7BLjUC9Qz+/d+1O2s4eDOorH?=
 =?us-ascii?Q?ode/iNXTGCXEnAlAx7E7tG9WEgtXR3XwvbT2zwEpQCvzYKnjoIomQYFmecZt?=
 =?us-ascii?Q?AbNbzw9L5BBtZThkYcaBvnYNqu4212Je9JzNgSDnIqFfgT+1k+vOvHQSL95J?=
 =?us-ascii?Q?ghAD9kJ/J6w9+qusOBu5mzFE2BL6xVcn4CreUjD4cZa29BKpCv9YR60u7WNH?=
 =?us-ascii?Q?ZBAwo/3XViK0pi8Qk+qp/c1LGStjwk68UrhGtDF2TJ7pKjXxcr4hxocVkq45?=
 =?us-ascii?Q?S1FMJhGbRIATrObQ404VHDRmfSECTLC0odzV9L4rs5kYUazsilBuhA8i6igk?=
 =?us-ascii?Q?TuqpmhlaszpoCTqm6YlRLOnz1uQoQjqnjCBuatSJJGFk7Z5UHLqx9g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/4aIg3O14RZdAZu7YI+khE1M8fHtXLZbN1eCYiWOBLJLEOggfLlUnGhajKk1?=
 =?us-ascii?Q?xInz3WwR5Q3M/eVq5Pl0S9od7L4GVS5eqYZcAsV22I0wK5vNhpG9hVAVTm1e?=
 =?us-ascii?Q?NG1Y3rDcf1f2jJ30b1L2SLR9WIGevOuu0laypkAKZSvK45aSKmVrMW5+tP3i?=
 =?us-ascii?Q?r9LGTK45wJZEhcN6Qa7HGjKToWZL4Hu15Zzrg862/UzSgyXyseCT5Z33HGng?=
 =?us-ascii?Q?Br76IzIytbt7qH/v3H7tImM0HSIarYoPI6TKZPBy/p7RepNE3QT60vM00A8F?=
 =?us-ascii?Q?KyVCETBPgzSOjcjqSEOw7jhsTBkWTHJqT+/WS2EPL8RflV6lxmaKzGLcFACR?=
 =?us-ascii?Q?VK3d9L/Yo1TNO/R1i0DnsNld73LEEJd4CR9FBXeqRgi+w0lrgZbcq+kbruyC?=
 =?us-ascii?Q?9xx3nHzc1rsDOFE/E8S/22Qf23gK+YIAJWJbfTH/GLWAA+2qOtAPlIkQNKd9?=
 =?us-ascii?Q?txEpwAefLE9fxw6FLLtYCObw3XWkNR1hJ9jC1Zqfw8Jp2Y51TYcXq+b+Tiip?=
 =?us-ascii?Q?Vj4FqNmuZZ6ZiwdfBqhksGMpNnJ1+ITLuekWLC7Z6uaRsa/YxhL2xu6h6DIB?=
 =?us-ascii?Q?+EW94TTk1ZhPHUBE3UQMKD/mgXfdIYj9IMzUlZtywCS0wbclH7+343y98L2Z?=
 =?us-ascii?Q?E9qHGuQ9M+KZov8swMOzFdmie2xB1PlJsB2GjNoFlI384ZGK65x3K2wa4SAa?=
 =?us-ascii?Q?Yju/6DNRYf6bCRXOuMDjPlpA01wAnY3Dp+fq0tV4B/5gYVgakR7X6fVXBzs6?=
 =?us-ascii?Q?+XUHvzG4NCaB4E1i96/UvwXw8/PyCr36ENq4ZxqhvWLhdR7wdhYQVv9D/6Sn?=
 =?us-ascii?Q?vyeJCcPgGzDasqfE6EETCQuI4Wl+Xcnvb31PJH3B8hZUcXkuzfjnS73Yqpp7?=
 =?us-ascii?Q?YTjRkIxKhQiLM1RPCt7vg4eahLjNNqNBxW4ztqY4hBb+a9dITGBWXJ5F8XxD?=
 =?us-ascii?Q?P6YCI6mmwbGuRNxC9w2RjxvavdvIKiY22Vpp3JRuzniyz0FDqXiEyI4SLmY7?=
 =?us-ascii?Q?Ei9p6H66JR4TqkdAkLTLsPmSHAqTB2kvJrROL77Va9AWwMnC0WWHmYGfWRPY?=
 =?us-ascii?Q?FSsIEf5IW51ZEmi9C8XsvO/6XHTwLmoeLWistYkITRq5nr893vnNGlAYFQYQ?=
 =?us-ascii?Q?Vi2EfRZbXtstwSHMEMpOjBqiuf8933XHqld4UVaFJg4BqdKNfju+IHPNHuWz?=
 =?us-ascii?Q?6uLdvaTI/FW5j7iN0xfFf7jZ9ouf4c0fz7WyJCv2Dsw6NYSOXCk3GXBSr58b?=
 =?us-ascii?Q?N+1UbTTZn6YyABTYEe3MDIU8lDLpFaVddHq0DbanHBUCn0ymanSaiLVevDvH?=
 =?us-ascii?Q?F0Ea18lxLxE4zAC0ElXJGfMyWkEQ0Q/Sw9U7dAdBL5jdZjfLVb9bDlJZdhPC?=
 =?us-ascii?Q?tBIxN0+Xwe4VPstPHZK74ycs9dWpQKBDLL29t4uh+i4XCGPiPf5sCpZglMDd?=
 =?us-ascii?Q?iM+kT3KSfiE5IBn/B2T+jUamvOVvbt59dHrv195nsPtA6olyEwW/5lixaKjF?=
 =?us-ascii?Q?N6u/YsC5rNWn23Soh6X7V+sWacGTT1ODqFBiTJV+W5tfjBPtJ++f0wpVzPuY?=
 =?us-ascii?Q?/IGl1dO1JJqGQrcpYcZvp9jy216Vkjfa9lah6Hgvsq7cgO6iAx0ZW+YEv5jj?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c985d99-05d5-4a5d-1c13-08de18a20b08
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 17:22:18.6226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRDycyI0XdHsvKrxl5rm8EVVbEMHZ8CZFgwL8yDgc2IjKwTbvR0RXRL9VaOncDukj2lCGlYclvGW/pJOfbNAftRXHcAMWwHEZRZUF7GK/mQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4525
X-OriginatorOrg: intel.com

On Tue, Oct 28, 2025 at 08:29:35PM -0700, Alison Schofield wrote:
> The pmem_ns unit test is designed to fallback to using the nfit_test
> bus resource when an ACPI resource is not available. That fallback is
> not as solid as it could be, causing intermittent failures of the unit
> test.
> 
> That nfit_test fallback fails with errors such as:
> path: /sys/devices/platform/nfit_test.0/ndbus2/region7/namespace7.0/uuid
> libndctl: write_attr: failed to open /sys/devices/platform/nfit_test.0/ndbus2/region7/namespace7.0/uuid: No such file or directory
> /root/ndctl/build/test/pmem-ns: failed to create PMEM namespace
> 
> This occurs because calling ndctl_test_init() with a NULL context
> only unloads and reloads the nfit_test module, but does not invalidate
> and reinitialize the libndctl context or its sysfs view from previous
> runs. The resulting stale state prevents the test from creating a new
> namespace cleanly.
> 
> Replace the NULL context parameter when calling ndctl_test_init()
> with the available ndctl_ctx to ensure pmem_ns can find usable PMEM
> regions.
> 
> Add more debug messaging to describe why the nfit_test fallback path
> is taken, ie NULL bus or NULL region.
> 
> 
> Reported-by: Marc Herbert <marc.herbert@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Tested-by: Marc Herbert <marc.herbert@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
> 
> Changes in v2:
> - Clarify which ACPI resource was not found, bus or region (MarcH)
> - Update commit message and log
> - Remove Closes tag (MarcH)

Thanks for the reviews and testing.
Applied to : https://github.com/pmem/ndctl/commits/pending/

Added note to github issue https://github.com/pmem/ndctl/issues/290

"This fixes up the failure of the pmem-ns unit test for nfit_test users.
It also adds debug messaging to help debug of ACPI.NFIT users.
Patches welcome."

> 
> 
>  test/pmem_namespaces.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
> index 4bafff5164c8..6411e58ed5fd 100644
> --- a/test/pmem_namespaces.c
> +++ b/test/pmem_namespaces.c
> @@ -178,20 +178,24 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
>  
>  	ndctl_set_log_priority(ctx, log_level);
>  
> +	/* Try to use ACPI resource first, then nfit_test */
>  	bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
> -	if (bus) {
> -		/* skip this bus if no label-enabled PMEM regions */
> +	if (bus)
>  		ndctl_region_foreach(bus, region)
>  			if (ndctl_region_get_nstype(region)
>  					== ND_DEVICE_NAMESPACE_PMEM)
>  				break;
> -		if (!region)
> -			bus = NULL;
> +
> +	if (!bus)
> +		fprintf(stderr, "ACPI.NFIT: bus not found\n");
> +	else if (!region) {
> +		fprintf(stderr, "ACPI.NFIT: no PMEM region found\n");
> +		bus = NULL;
>  	}
>  
>  	if (!bus) {
>  		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
> -		rc = ndctl_test_init(&kmod_ctx, &mod, NULL, log_level, test);
> +		rc = ndctl_test_init(&kmod_ctx, &mod, ctx, log_level, test);
>  		ndctl_invalidate(ctx);
>  		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
>  		if (rc < 0 || !bus) {
> -- 
> 2.37.3
> 
