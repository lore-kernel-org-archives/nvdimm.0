Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43468176AAE
	for <nvdimm@lists.linux.dev>; Fri, 26 Jul 2024 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722001087; cv=fail; b=uh2wfwlRvVIk6drdjB1yEzafeOejpyvjZ9eGHr5ETIdbfg4IELJfxpQHAMwU/U6dvnsT4UqovmRosc5MVVmSeTQyVfWfgjd/7oAwpAak5ziLIh9MGGD1kZgmRQ951ZaJDKQ2qAHN7Ch/hcLOaskqehHqsDpZ01EHoK4+I1L/RQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722001087; c=relaxed/simple;
	bh=mUj5wOajSF6rS7NzJIS4jpX4YpEA3RYJqtjrjlyohJ0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QVqCta7aqSWh5ANij0feWqCn4W44fJQSOtXLtRqyRuompYd1fWb05Fm0KuFUm2YJRNirTrgboKN7tSwFzGskKJ285SlHZWQ7a6Il+VCR4F5YrLJw3tpRH0Qm6EaHKMJ1w1cK1MliYzPzj4FEJCuq3lZ1DKJJTp810LpLhK1QqW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B08+Az0A; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B08+Az0A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722001085; x=1753537085;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mUj5wOajSF6rS7NzJIS4jpX4YpEA3RYJqtjrjlyohJ0=;
  b=B08+Az0AeA/EzX9ez6GTToqMl5vd9eL6vfAB8y++Izi8J4Ux7yaK3TQj
   OLjAubX5mA6t3NK1WzCiXkgkRnbMX6uA61rqwea4g7dzJkGfeW5wMw/r5
   3cCdaGFsLL2QfAHdesFf2ZEHVvtTKWWcJd5chuCuiT7e31JzsIYhDi2dS
   /TG3Op9NAwgjOzvJxO7bmURGBjIRNsCYLz9+MD6FywM239auzyvKerpeq
   s+Br1gnLCXUwoTOSrJl4T4rAaNJV3GeEac8jY8zEs2oUuy20+6LWjSJWd
   mkPelrpeapcJmclRBhoznaNDtQV9bzu3o7cO+n4HinTN8Qd+m/yDEcfH1
   Q==;
X-CSE-ConnectionGUID: yjJNRioBRsWch+0jfMPJZQ==
X-CSE-MsgGUID: ZawzTqDVQdyaqV+3aRLirQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11144"; a="37308518"
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="37308518"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2024 06:38:04 -0700
X-CSE-ConnectionGUID: RQKSPSkMQSuIAwH1pcATaw==
X-CSE-MsgGUID: g34w/FiQTvOKF0YyIzOg1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="53172681"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jul 2024 06:38:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 26 Jul 2024 06:38:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 26 Jul 2024 06:38:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 26 Jul 2024 06:38:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 26 Jul 2024 06:38:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZwxejU6R+wJNANcQbAQt1VFFsFgflarPu/17bFZX8uvOZZY6ZXOfSxt6Qf4dD48EK+hL3TESYm2t7vB5TU0eE1QyG3PGdzgnpUwcD9VHYaC4T5Oyjt/j3CEVcA1CWPoJCDTxiYmmUID8Kzp+mJj1gsIbQYcS/yMbPfkduR4Dg6xpJP3A6pHB/5/3cRVGjeqINA/dqkhJ+ajtwuf+Vv2LC7xxFp/jmflUGCGd4saIurzGWP9Y4u8qvY76XuW45+0Ow/LAzPP+Rqny5twwm8Lcg8EIqyBzjjduvJzqPo4oG/PMiiFWQueP+Ov1QPVODQFtodXUuQg+g3GH2+NwETT9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyNcpbHxcqeYvn0Hz926LC7+jXkj8GaPSfRZbe/Ec4I=;
 b=lOX38gHOWR4TaTYMQjL9z/wn8l2IYruwLU/PW7FlSmkd4hDPJM/8LYX0euqCUzgUQsKFlnQbVWwaxQe/0n3RIAprUT7Mc3fNSmkTEbqQk8mBhSvM01trvXxA5ElHKkgUHQkJlo1WgaO0eCSLNFCljPt+6wWQDie3MoNQSlRqGsSzNiS6n7vVDsCRn1kxkF8dfJn08DdiWxIzgzaXfNB5lItv8Vp4TtGZuTmLYm/Fkp70wEghxcn8deGAiQ7/du9KP+Zub9Cr20QACSIV6Ev1aGOfE6Sl0n0Iu0iSIy7CSZ93+JHYZr8TaKvd0iL0Tm8k/aqgolAgnfrGcalbuEXzFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DS0PR11MB8687.namprd11.prod.outlook.com (2603:10b6:8:1be::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Fri, 26 Jul
 2024 13:38:00 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.7784.017; Fri, 26 Jul 2024
 13:38:00 +0000
Date: Fri, 26 Jul 2024 08:37:54 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<linux-kernel@vger.kernel.org>, Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH v2 1/2] nvdimm: Fix devs leaks in scan_labels()
Message-ID: <66a3a6b2292cc_1bcf5d29459@iweiny-mobl.notmuch>
References: <20240719015836.1060677-1-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240719015836.1060677-1-lizhijian@fujitsu.com>
X-ClientProxiedBy: MW4PR03CA0098.namprd03.prod.outlook.com
 (2603:10b6:303:b7::13) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DS0PR11MB8687:EE_
X-MS-Office365-Filtering-Correlation-Id: 402b0e7f-56e3-4ee5-be45-08dcad782a34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?g1vbizJz/hVQY05xlzrZXcB80jF9dCjt6+RArQD62RZWpkTb6FBVbG08gyGl?=
 =?us-ascii?Q?TxpP1TOhsLQrf3t1ImZksV/zpVc+BAG57yZ5jkfWiDKfeoYnlmbdvayZV5no?=
 =?us-ascii?Q?OIVFr87McEpV0Ig7sqW1I7OOkuAC+cOX9Gnv2uXbo1ty1vPCJdQdb19sLePl?=
 =?us-ascii?Q?f6NxFXVKyOGoQDHBcHzq6diRiJu1ud3dGSekYbrq8zVFzczDPX2CgX+ycYON?=
 =?us-ascii?Q?GcVxAiTnNWRYg5yuF0WrAQ72qEK5vWUpiDHQbihk19St4a+aUmoizhZDi1FQ?=
 =?us-ascii?Q?BUtvR1SrM9EIsdj3Cw/jxLuvNTg4Az5Vrdvn7cLxn3L78+Zg1TLhrBPEb3vt?=
 =?us-ascii?Q?EAq0hs7EM3MerpstalUpLnu50198K4hWVqUg8DqX9/sAkinPa+R/BTzc2MBx?=
 =?us-ascii?Q?JOy/otlExWzI+tUTXFgy0vwd2QIOTm1LaleharTz3j5keUyJjT5EtEMnB7w0?=
 =?us-ascii?Q?pvfQ3/hsLx4MNQ2nqaWfl6x3b4Z+q7YIvWkUBWUV7GVMmzQWo+L31PD91FdY?=
 =?us-ascii?Q?mUYy0ml2jFvwg01AK8Y0j98529hRo9bVtPr86Ki9Gjh19UxqI9CrqaEIDWRQ?=
 =?us-ascii?Q?phOwnYhvs0iJVOgROdfCoKxUjBI7oYDV3/cW7ewO2/oMQJ97ZNiNlGPIyKGm?=
 =?us-ascii?Q?CzKpyBTyEvy0DZG71FfqFFCHG+H9nKyKVLaHb0Q6Wff4bMkHOlw8LpRWuRdH?=
 =?us-ascii?Q?R4Bj4b8S4STYTq9RhNf2v3zv5oIQ/VrrcUPcYKNcaJuzTod1MOJe5U8emSi5?=
 =?us-ascii?Q?P57QiQmtNA9dmymAOKiTo9py2ExcQCT4km57cTU1i1QTtGLXFIplgoEcyil1?=
 =?us-ascii?Q?wuohAhNAlISA+XBm2JJBV/FVfM2nXkO6fllEL9OEYiw5SAzJA5NImAqdXzbR?=
 =?us-ascii?Q?H9U+4xymdNv21csZlXZWR9zHYDSTWTgUCDsVPK1o5u8xFROG3hJVejCCCxHE?=
 =?us-ascii?Q?rGz+Hctgf+2eYcnwgxnPe1+1vh2mn/U3JVYiMDnohFQ0CZa/Xr+oli2ZBT3S?=
 =?us-ascii?Q?c/GOZlFZRLDQIIBB00XsrilzaC5LbHN6WaEJ4U/1MrnjmOszCWyCfblqJLt8?=
 =?us-ascii?Q?sY5GWO8MWbM8VRRrjRDw5BQshu05kPcOAFGZrUNJ2Rz8cSq+IVt+wFTh5qRt?=
 =?us-ascii?Q?uF0URBjI7gyReA73pTOrFUFI+tlRy9k4DKPFVhmwADDbbZvR2h/Ix9ifayPU?=
 =?us-ascii?Q?QF2Uiurrk7VDIjNfXVr0mPmVbHIDuK/0KZu1bUG1hxcb9YMAe92U6HkkxhSV?=
 =?us-ascii?Q?1EjbegCS1Z7BQzreHpEqAfzDPspZG7B+k/gxyocDc1wDuuat6R/+yQdPDrkC?=
 =?us-ascii?Q?Y+8jdQs1P0gnTnPpiUxsQbj4HilA/Ud/2w8JxoGnyuwAzQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j4MUJoRxToynUjTEBX3riHLQmV5flpvc+41tK8ByGuJePt/t5Jn4FXQNyjxt?=
 =?us-ascii?Q?/U16wIdBFFkacjSZPauuruNykd9ljwPzGBqk+PieXn+HC8B0FblkVktO8TLD?=
 =?us-ascii?Q?7C62ps2OMGxgfhmsU3/K6Oke/sF82ceAIWxl9qT1FJDCKawFqZU4WNRrlNmo?=
 =?us-ascii?Q?zrjD7CptSualDyQbm0VlaRNmqOmeyPn3KQ0mlZanLACWzid5xWI+5VHdt5SH?=
 =?us-ascii?Q?vuQgO4f0yRr61oS22Hfq6ayzDuYOV9v82+x0mhbMEV3EwD9F/IHmJXo5hznt?=
 =?us-ascii?Q?Ll/Ard0eC7czHuCYCtoeY9Wc1BO58FsvRqW8NlUqCqcq+ApVX7oIA2foK/D9?=
 =?us-ascii?Q?v1MGfSvG42gB7Kp/lUy5lzGdPKN+sWMDwDF3W5FNrOytPu0f2CONqt6Lw/qE?=
 =?us-ascii?Q?58MQm2fOV4KtcotX7C9MiByWVeWpI/Ce8wmUBNGZsxX0MFGRYRqCQN9BYO0B?=
 =?us-ascii?Q?6Efr+F/udvi8+qeB5lyMWnxFotQ4nEkm4yZAGCtM2KP14rOIy17a4dP5ENjI?=
 =?us-ascii?Q?de7PTBkx6GlcmLGO/NxbLFYCA011oVFB9LDM9fh4TMBwL4c/TxLWpU2Jqmhs?=
 =?us-ascii?Q?jVC0YKIhDFD3kJOhjURHp1zEF01ssHYKPFnEe8NF4KV5MBsiWim+OApORVYc?=
 =?us-ascii?Q?7epx67S/Oy2mZ5ElwzJCfXscSpK5S5rmNyX4fEccpDlUTZlKEwUahdftvZxT?=
 =?us-ascii?Q?adl30KLlaVd5hXlLVqLx3d+m+cwxDLqPjEOG7ewyA7ExCIqtH9LqKBF+5bR7?=
 =?us-ascii?Q?a/dns+FjEX3q61yuZOmZxNJVmMZkDdnnYzbE8iuySlQcc0rLe21pf/2JWxo7?=
 =?us-ascii?Q?Grh+dj1toCIdqboXEqxn4UMogS+RO32zxHR+H3/zuZ7t4f8nBA77P0VNBAEL?=
 =?us-ascii?Q?pOEAqE61ePwvBoDNISPSw9n32nAyZICvd9upe1nueSS5jTdAklfa6QTaex3t?=
 =?us-ascii?Q?z5/+PBdrb1paO2bE3SiwV45Kk9NNp8ju0qaQ1KIdLtlVzhQolw6MWebQeuZC?=
 =?us-ascii?Q?vLHwKWohAn5k79ddmZN3O+k0ZUOo5FnhukOS5TtnRYp4cfrqCZfi3erlZPAa?=
 =?us-ascii?Q?jlPJnXUzP+45mMCX7Kd/zKDrl03/qZF9Fx/Xxx7EhPDmIwEAF3FG5GA7IYKm?=
 =?us-ascii?Q?SLu+t/uGfuu+fpU0jODKx0PAbVWF8KnKoM2OrQELgMxBpgOsbwo2HMEcnkPn?=
 =?us-ascii?Q?SZYqjqAgdYQFk/phIeLBNiGLt5F42Q6dDe3RKUMsQuitmgqYORmiLSuT8URr?=
 =?us-ascii?Q?tluTbTv43vnO3iofr9YmJazyoa97p4rpxfRKahIN5PEE/lLtKwKQQVUP/Lr3?=
 =?us-ascii?Q?Kq7d9HPC/YWFSvcDHRlIuXUA5dgS35YXfpLoUhEyVeEY4lsY8jyPl2DZyEco?=
 =?us-ascii?Q?r1OmtiPJ3qKVoIeucRKfeTQ/oFnWlGxGG6ha1Emji5R4TJMvtw61P80m8xMl?=
 =?us-ascii?Q?OWWTxcQ6+MEOvPubLS3b/zJFinin3dvBUIUADJn/chFj9FaAq4LYtT/8QNPk?=
 =?us-ascii?Q?fZXrcgqhouAIovt315qHHmZcDVQUbPUFs9ZSJWMYqjfckhmrqTUfMgkMawRR?=
 =?us-ascii?Q?vUN7/6FvjfUWb3MTjx/e7RdPDfEcsJIIBdsC2Ebv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 402b0e7f-56e3-4ee5-be45-08dcad782a34
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 13:37:59.9152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJM/hZnGj5ZbZByQQYlhT5riTLh8xqjAbclch6C5gFlfUdkXkSh2/qIjiuvuGx9XxUU9lZSj9IJFCW5HndwtRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8687
X-OriginatorOrg: intel.com

Li Zhijian wrote:
> The leakage would happend when create_namespace_pmem() meets an invalid
> label which gets failure in validating isetcookie.
> 
> Try to resuse the devs that may have already been allocated with size
> (2 * sizeof(dev)) previously.
> 
> A kmemleak reports:
> unreferenced object 0xffff88800dda1980 (size 16):
>   comm "kworker/u10:5", pid 69, jiffies 4294671781
>   hex dump (first 16 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace (crc 0):
>     [<00000000c5dea560>] __kmalloc+0x32c/0x470
>     [<000000009ed43c83>] nd_region_register_namespaces+0x6fb/0x1120 [libnvdimm]
>     [<000000000e07a65c>] nd_region_probe+0xfe/0x210 [libnvdimm]
>     [<000000007b79ce5f>] nvdimm_bus_probe+0x7a/0x1e0 [libnvdimm]
>     [<00000000a5f3da2e>] really_probe+0xc6/0x390
>     [<00000000129e2a69>] __driver_probe_device+0x78/0x150
>     [<000000002dfed28b>] driver_probe_device+0x1e/0x90
>     [<00000000e7048de2>] __device_attach_driver+0x85/0x110
>     [<0000000032dca295>] bus_for_each_drv+0x85/0xe0
>     [<00000000391c5a7d>] __device_attach+0xbe/0x1e0
>     [<0000000026dabec0>] bus_probe_device+0x94/0xb0
>     [<00000000c590d936>] device_add+0x656/0x870
>     [<000000003d69bfaa>] nd_async_device_register+0xe/0x50 [libnvdimm]
>     [<000000003f4c52a4>] async_run_entry_fn+0x2e/0x110
>     [<00000000e201f4b0>] process_one_work+0x1ee/0x600
>     [<000000006d90d5a9>] worker_thread+0x183/0x350
> 
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Fixes: 1b40e09a1232 ("libnvdimm: blk labels and namespace instantiation")

What is the bigger effect the user will see?

Does this cause a long term user effect?  For example, if a users system
has a bad label I think this is going to be a pretty minor memory leak
which just hangs around until reboot, correct?

> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
> 
> Cc: Ira Weiny <ira.weiny@intel.com>
> > From what I can tell create_namespace_pmem() must be returning EAGAIN
> > which leaves devs allocated but fails to increment count.  Thus there are
> > no valid labels but devs was not free'ed.
> 
> > Can you trace the error you are seeing a bit more to see if this is the
> > case?
>   Hi Ira, Sorry for the late reply. I have reproduced it these days.
>   Yeah, the LSA is containing a label in which the isetcookie is invalid.

NP, sometimes it takes a while to really debug something.

> 
> V2:
>   update description and comment
> ---
>  drivers/nvdimm/namespace_devs.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index d6d558f94d6b..28c9afc01dca 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1994,7 +1994,13 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  		/* Publish a zero-sized namespace for userspace to configure. */
>  		nd_mapping_free_labels(nd_mapping);
>  
> -		devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
> +		/*
> +		 * Try to use the devs that may have already been allocated
> +		 * above first. This would happend when create_namespace_pmem()
> +		 * meets an invalid label.
> +		 */
> +		if (!devs)
> +			devs = kcalloc(2, sizeof(dev), GFP_KERNEL);

I'm still tempted to try and fix the count but I think this will work.
Let me know about the severity of the issue.

Ira

>  		if (!devs)
>  			goto err;
>  
> -- 
> 2.29.2
> 


