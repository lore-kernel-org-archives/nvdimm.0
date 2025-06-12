Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603DA770FE
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 02:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693988; cv=fail; b=OC13ZzzYAnbVMtgqY4F8U4OoDPGKw3OZDSsE08n6OkJ2TDwe+13VW1zjK4mavITSKmp79lWTqJkatVmkQDaPgScZ8WxScU9blk4zp+3cRZuixFtKR9Pzyq1cLPAm1iSm/iIoOdF7yxJkHKXgBJ5qGiqcNCGmspo6lwwGrQ/CWDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693988; c=relaxed/simple;
	bh=/EXi0y45qWBjopdFScHa3f7vNgijbZw4n0x8fHFKjmE=;
	h=Date:From:To:Subject:Message-ID:Content-Type:Content-Disposition:
	 MIME-Version; b=rZUdE3DLl8HldhBeGizkQtCUSVetR6AqkxrSgiP9NTJibyTJOxcJA/E31bCbbJh17P/mhvM77hl4Xbsh606HqBDN6vDfZIEG8VSa/+EqKAT5CnSdMHOghlnd8IKWGApF6kWjp1Lr0JEXNhYjES1zSu7gv8d8tZSMExWscUdxsYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fsy+CGHY; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fsy+CGHY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749693986; x=1781229986;
  h=date:from:to:subject:message-id:mime-version;
  bh=/EXi0y45qWBjopdFScHa3f7vNgijbZw4n0x8fHFKjmE=;
  b=fsy+CGHYjJKzVNInPqeHpQ8ToyNd357bJqx/61OMqnEL17l5a6m2pu7r
   gvJTuB3mBHwuzACVwWIvHceiTMIFBz8craz1UzEJGQlnuigpKF26nNnmo
   hDtT2OwMyhcv5t6Dc1fLuPMhVqs0IblyVRU2MSegO7GUdUCOcFeYuzWx/
   fFwT6FETBSiiCbzXbNIRAJVt0fR+HspDOc6WlOFmTz8+U5HNRMvgRzUBW
   Eyc2uwrQoSJUMFqcN6Cw02kuOcD13cTIxo7LVjA0i6m57nDwvy322j3Q4
   H0HJ0bUAxVDvjTi0nlTYc5/6JuqGcBNbC0FCWtDM56HFeEs42zcbU3jf8
   A==;
X-CSE-ConnectionGUID: AqoNg4FoR6S068hdeJdexA==
X-CSE-MsgGUID: lE6AszPpQ8K75xBWRlVHIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="62468955"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="62468955"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:06:25 -0700
X-CSE-ConnectionGUID: EQcMIjJxSxqRHsH5fWxcsg==
X-CSE-MsgGUID: /1IZlBl4QWymj9E9cusVLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="147363289"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:06:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:06:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 19:06:24 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:06:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZ5S6mmlwjE1wsPBLqxKt0wFS3WmRyiRyZWsXWoN/sJtmd/rdVeQZZnTIAUC5Vxd6s4eFQFcd8OTWvdpHKQ4zqVundlBRyQMi4YG54EBe/LmZubVir6/uj4cfUOFgXuDAE9dgL+2xrQxMlWcHND4a3Mvyp8+0hY+hWInJHqlOaPw6uMaypSSNW2EyQxruldNUfXVndfSHZKoBXf0ZDnuaDUqPUufz+F9fbv7zV4AtV+TefJ+PPtVM88+6iMT5ZSQUSqcgFihiEs9lENk8TYQkkGxFzrTce/9Yk6dRuzxwWrh92jYWMTZEC/Xc02fPO1HTE11/vqG3AzCPWqvaKwcnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LC9JE+kL1SMkB3VOGMwlqcJ09Qv9J+NNSoCPA7Zw5X8=;
 b=MFuAeVWTU01QdRh34qA19d2E/Ae1XaZAJNryCgyS/xCNxrHIcO79s6omc0shWMh7zip0kBDD8aYoiYTNSz+f5tqfiom6bVQI433ugrNOYUnKovOjcC7q0NlzltgTLaI6T1zs+5iGMqlFOlcoRsP8eKhnis+rov4gWFzT7uV4lzyLiMDsxLhuX9YjEqYo04U29bCbsT2O4JHrFo9YjE9m4rvJXU1vSzW2boRpnsf5O6g6tBh2+B6luRMrblD9wybjG74JC35D3H8/Af2lpb5scRWHbebxrMSrgui3pAVRI8L7xlxVhaSxH+7IuqwZwJyU6hta1HOPXdtM6u5o0XDycQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by CY8PR11MB7059.namprd11.prod.outlook.com (2603:10b6:930:51::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.30; Thu, 12 Jun
 2025 02:06:08 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8835.023; Thu, 12 Jun 2025
 02:06:08 +0000
Date: Wed, 11 Jun 2025 19:05:57 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: [ANNOUNCE] ndctl v82
Message-ID: <aEo2BWA7-BCSx2W4@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: BYAPR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::42) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|CY8PR11MB7059:EE_
X-MS-Office365-Filtering-Correlation-Id: 36f362c5-9482-44b7-0609-08dda955b1a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?M7oURbDkMztGigjmgXOF7N6CQfwHlN7iJl4TjuowCJNgMJg2qJZv1xvYALdY?=
 =?us-ascii?Q?8XbfJQVqOH2BgoK3+4sjL5D7cXANuG6d0+nxyA6e91a5RXhV9JtiremS8FMy?=
 =?us-ascii?Q?codWs0O/GmlO+JKodJV87hbEj38s5yS79mkXDWgL7Zx4A++LmjYPLaUbxh5H?=
 =?us-ascii?Q?9DxqqTOeoF8kInk4SQs2b/vFriClzaPpQEnucl6lDLnFxENej6QvmgCXp+jK?=
 =?us-ascii?Q?caTvSi++iWyNfjB2XeyXR2CmPsbCOhCtbjf/OOD/5wGLmktcqwr9mi7xeKfd?=
 =?us-ascii?Q?U6r5cILAj6hXkGa3AZ7v3VUCNY1X+OmW5J7W/BD+iQzAAr3mdPAZR9g2E8oU?=
 =?us-ascii?Q?WsB8Xwd5hr55sreGqdmiAXWnJnozhzmefcBCvlQjtIjawU28xT4ZHZcupjoF?=
 =?us-ascii?Q?p5aXfSJCanQUJOHfeleOFpcXI1wF512Ueh2q9PH/jmM57q75ba7VPDY6HhBG?=
 =?us-ascii?Q?bfkQY5OL4PacjNy9tjdEO7x07eqFSXQfq6FK2FDHKmMseireYBe62fNcFZQg?=
 =?us-ascii?Q?DFcbzOZYvrHhwMpxZfYiEx6DQE02E/IcVv3LUtbewUv372NHTh0Qyi/Quw6u?=
 =?us-ascii?Q?d1BxfJWQIyyPO/bLLTGp4/QV18D7n/3Xh5meLQH7DkgtHtKbghY33qPjerH8?=
 =?us-ascii?Q?pU+p+Kc60a/wcjnEuoPXrfU7HgevQ7662BBWjHsJQfiAZ6i5mneK8Lwo7u3t?=
 =?us-ascii?Q?Ai368aQYFFSWyovb0DEkJoiw9KKfabo2Ca7clo6shjOBwcOZH8CVA4K5aFKK?=
 =?us-ascii?Q?1TwUV260UGGWEcn/adMg7w1iujUaoHcpfkFtU9HbQUXLQeyqebLJicIqGnyY?=
 =?us-ascii?Q?NUxbnWXN294Y+JBDqTfHikMJkBxr5zS6lrk/an+aWlz+ixSDFL+kilxkb3Mz?=
 =?us-ascii?Q?tju32/YgixeLorgRRneLNOpJfuGpUL4fHb9aYjrbZ6bs8D1/FXvna+P64kLn?=
 =?us-ascii?Q?5dQej05VLyThW+9ZXmhb2yvErCUBvSrEDVz5Pkdml6Z6ykF4WlQZHfhXmK3n?=
 =?us-ascii?Q?xlIWayDJ98QxzwXficw+Uog5XOuT7lE3/o04lJ7hrGay0bd+NS59Y8+kgJt/?=
 =?us-ascii?Q?xvl+mAFncUolQDzRdO5oe1Y1SLzwEm6lEEtn2Rzf+vBfTkhhW1G6bNuwZNIF?=
 =?us-ascii?Q?B0I3iqcFBcnGpnPkl26vHIv1h4p5LnOlWz8JIOpdJk+tYzsUrEwxcpqLhGfL?=
 =?us-ascii?Q?HqW9Qqdg5E4d/PbQyLwQ5Bn7BEsZGeKRbIFqoF/YYJic2dwyCqLWX2NAyUbu?=
 =?us-ascii?Q?339lrPuwj0WuqRV7iWfxTgag8K7PzQdE9n+lIqob5UTtBq87xiMlGJOWDm4H?=
 =?us-ascii?Q?zbE7DVIHyAOaYlX/MTTZCJh0tYDxhiQ3kJiWSva2usdGuIvguII8e+ah1RoU?=
 =?us-ascii?Q?pAfvWA+j21iGZJpscNFwUamFmtrS7JPM/SF7YMSL0xmnMI3G1yb+7KOsB8Ym?=
 =?us-ascii?Q?at6sDqUeyPk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TuDw5bWFxcE1Q/V5iPgfLzudVG7wgQYAWyXLb10ZO+MJnMqQBYs3VkrqFsKp?=
 =?us-ascii?Q?bZ0l8AXu/GVSBY3kxfazp65mRYM4MK/O5fkeUvONdgLY1W72iuK5BRMAxloE?=
 =?us-ascii?Q?GA/hrJcwAfXcSrNZu8A/xqyFhNy6gsnDsTXCIGYnIy209qdPXqEO1uNbgns0?=
 =?us-ascii?Q?LsQBf7a8pWtwHL6+sbQlCyaN33MjsVX8JngJ81TxyKX9ub/jTUKttIHZJDBJ?=
 =?us-ascii?Q?LmKGr8I0mDre+mqjelfupaC2TsDKueXnUupXhwBzOwUHr4Qq7Jd6QSV2fTBe?=
 =?us-ascii?Q?VdG7ZM3XAoxAKon+8PoefOmxRMcugcEYNGS+oj1x5m5VsfLlciWd604H155p?=
 =?us-ascii?Q?gi70nQCMAqzW+cJhSHH7mGnHhKGTzy0aPWbAl2ocJ6Mfkcpl5HtWDe4jwPc3?=
 =?us-ascii?Q?1W0uM8qW1s1V5L3qswKkg6QLsRmS2nC+rAuNaGjUxYw7hUEZMdbmcXsffZRk?=
 =?us-ascii?Q?jLRiCWqflKIfyJjuQHFgCEQDUAWcLgylWTtopknHDggAAZ+7auRuyzHly+6R?=
 =?us-ascii?Q?qo7uVNT3xne6JdmvdqltSfWf1CUL3qTejVuJT5hfP1HF39W5cNTu94VG5BCh?=
 =?us-ascii?Q?spNYiIdyN8Ct00IO/uOE+mnLrpTQUE+wrs7POqDU3u+5V22+ueOdlH2c7UGA?=
 =?us-ascii?Q?tUYJhLxF67ytoMQQ/39A8WHon3ywKAZV6N//QADjP7ttl/QdWvvuRAGVtDKu?=
 =?us-ascii?Q?93Xa+LatWnzx9dL1ItcHrTgvUJzEV27DDjZCFzvZouykdAE7vMapI/E9U6uH?=
 =?us-ascii?Q?Udg5Psga3rmvM/DA3wG/h6CLESCsbsYtemmBs/JUicVp6D3NeYtcYGd+JaqR?=
 =?us-ascii?Q?f4XtU0IxWv7lLdDKdOk5VYf5U1aHtFjapczra087oNIhjzAIDMV05qG6o03i?=
 =?us-ascii?Q?7eyQIkwfTcggu3ymc6CRB/Hwjfjc6O/NGxIce3JN5QB0LKC+ihUjcv3k7Veo?=
 =?us-ascii?Q?dJO17DB02Uyo6yJMWnZIfksO2sqnW5jX+GpK6+pl1Yk/VoK6I9NwuD2yoJJC?=
 =?us-ascii?Q?HI5YQoWT61Z12vcL0D5zcJA0/wPJmqjcmAdBL9xMbc0ou5MUD7zPZm99jSbT?=
 =?us-ascii?Q?qcnDTCusIuwQAwJr/IM+N0Zs3cX6Hgbjue6Wn1fIc/L3fz+P0EgeevR0jJm4?=
 =?us-ascii?Q?0AMLhYTyaO+q1WG6diAHyCFAzBL6jYxytsOcMAT89CybUdOeXDTgWjYE8xwT?=
 =?us-ascii?Q?yGDqqmNx5hUJ7v/3edaTL2vuBzgOLX1N50stsC2LZkemrVpmkXPv2509EzO7?=
 =?us-ascii?Q?64OuXCK/yJ2EbDNGLX6xw7V5IFIjT+Eg2uI+h4eT8ehCFmKgH/4VXZwxyjNs?=
 =?us-ascii?Q?knjd2GDDnkMt9RvUAJDW8rF8Wbmh3POQmJxmyc5cVXtd82b+7MFgoyEiW2T7?=
 =?us-ascii?Q?070d/qkmyK7qGRmAiL1qVhv8xb9EjQCRaviI2lRiTUX7YHa1K7tLHhqq37Ug?=
 =?us-ascii?Q?G0Z/SK8M3/7af+OohAMjQ0V6WVpyONoz9aZtOR4vsfD/i2RWh5zO5lzDja/w?=
 =?us-ascii?Q?aRwbnK7qVq/tbEc0vFRJYbnk7dw58bPvn9oOG8MJk4xW/6bvHgIjupy6sNjc?=
 =?us-ascii?Q?rnUlgoNMFYkg7Gz20iOP9A1MWl8+L0c0Vx1QpdfogBv+XH7sy/bqNaoO/tSe?=
 =?us-ascii?Q?ZA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f362c5-9482-44b7-0609-08dda955b1a6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 02:06:08.0101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MpWFD5k1ao5A7B7IJNrA5FUu6JdyQfw+0cOj6ObV5MQzzEzvc5FALDNRFQSBwcSOjDsaHPQe+u1v/tBtkwyX4TPqcAEXuOe/79gFUg9Crio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7059
X-OriginatorOrg: intel.com

A new ndctl release is available[1].

This release incorporates functionality up through the 6.15 kernel.
    
Aligning with the CXL Features capability introduced in the 6.15
kernel, ndctl adds libcxl enumeration of FWCTL character devices
which enables issuing of the new ioctl's to the device.
    
A new CXL Features unit test is added and it includes a C program
"fwctl.c" that provides an example for users of the new capability.
    
Existing test and infrastructure is updated.

A shortlog is appended below.

[1]: https://github.com/pmem/ndctl/releases/tag/v82


Alison Schofield (2):
      cxl/test: skip, don't fail, when kernel tracing is not enabled
      test/meson.build: use the default POSIX locale for unit tests

Dave Jiang (5):
      test/cxl-topology.sh: change assumption on host bridge validation
      libcxl: add cxl_bus_get_by_provider()
      libcxl: enumerate major/minor of FWCTL char device
      cxl: add features.h from kernel UAPI for CXL Features support
      test/cxl-features.sh: add test for CXL features device

Marc Herbert (2):
      cxl/test: set the $CXL environment variable in meson.build
      README.md: update the kernel config requirement for unit tests

Ruan Shiyang (1):
      test/cxl-xor-region.sh: remove redundant waiting
