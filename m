Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C68B23F296
	for <nvdimm@lists.linux.dev>; Tue, 15 Apr 2025 20:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744748381; cv=fail; b=FNjiqS2nldB5W8CQiPrhdwYMTjRrCrvY6mGRmE2F865sVOAoXJGBEoc4TZ/mDsci8sbDGN1MEcfBpQx+4p6AIUPKoVK1UACYI86lPm/xMRuFYo5jeRZ5kDu7kd7n2rtfW4oTww+v1I5k0GWWFe+qAJurzvfxM+Gs5RCnyepOBbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744748381; c=relaxed/simple;
	bh=tigXjfjyfAMVpNLjDiHwV4xwINBs3Lw0B2LST+wqVUY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JOVCgBsd+XglXUjwNV6ybyIFOcLj+yexvA2nW7mtf3SjFct27eKcU0eT6Nljd8JTn64CsNMLab4zUwEdbi60DD06ETpV8zoRMupLPXaipWmvZ4grTVSa6riNqz9MSGAjw34QbYFpm7YZVJVGZQE/BReztoMo1oQJuKgZ6tOjKLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O+scihuh; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O+scihuh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744748379; x=1776284379;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tigXjfjyfAMVpNLjDiHwV4xwINBs3Lw0B2LST+wqVUY=;
  b=O+scihuhPfAHfVRL2+CgDX1tURCZYMF0FnkrI3EnK1eIUQd1nZffuoDb
   rjtBhnf92gbChp6V+TjusY1/gVp8shSRbdY59tbUy2fzM/Vbi5WaJ1tY8
   ejcN80dkd+lYOWTN917AFuHHHXyf3LEMGhTZ58VNiSrh04FpZ14xPmsnd
   vPlsfQ9Ab2BDiD+i/GLhxs0jp/UxUBKBkr4FfeEM9ei7+mT6MYKDDiR46
   +TZv1mCVllxM35pB8CiOl07uRaz3phbCpXD81g0PEYhlfh4Xn0amDbtpL
   UbX9f3fCCBCH/Dvg7lqXIDB/pHq5VEjFwRb3QAH8VPnvVAO/UVuq32XZS
   w==;
X-CSE-ConnectionGUID: n1/osZ/iTrqs72+EpjrJDA==
X-CSE-MsgGUID: OsHcY9kFScmqZUImBz2e3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="45412428"
X-IronPort-AV: E=Sophos;i="6.15,214,1739865600"; 
   d="scan'208";a="45412428"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 13:19:38 -0700
X-CSE-ConnectionGUID: h9TjCKLySnOGW9Qu+ivjcA==
X-CSE-MsgGUID: SRol3HBOQcGQSgKi0gcEKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,214,1739865600"; 
   d="scan'208";a="135214219"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 13:19:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 15 Apr 2025 13:19:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 15 Apr 2025 13:19:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 15 Apr 2025 13:19:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQmn0+0NfzKOysJpurdXIZecf9j9kXKD4r55qI/Wcc/YqBaCm5CjmH4KmqTs+46Behmuu+bOQngeGmtIkARvUcoFDKVAH86PxPp5XeqsbZTJ3oOwuu+UHNH7ZAWV3QCwJ2vze0IH1/LIgCzkGmxaYgtOPutvG5skWd9ucW/qE8uY8+ekqnKbDQNs1A4mPxrFvhuxRQVe2vxIDPYP0l+pEkA90ToAPqGALwOCMBGHDATbfUK9yhD8lII2Y5577CdugITEZJdOg4g9TfwMeBPGKTaugnZHRk73/SvZsgKy3IOghQ7DzkKS8yoYptffYutnd79sVp1z5ej8AnrwUW8hcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hfIjqChDcpTUXVEGf/gZo9mFtjHgLm6HuRcIU+4T8Bk=;
 b=tGXsMxSg6xfixSioRRPC+jy2RdROoKrV4q4d+vqHGmoQYDfiplStGGY9m66Gxz85qJj0VkTVy3Heb9DUG9+ygo/GQBr14QtMVAPioiccMOAxM6nPGNl5uA1ptLC3yx+y2ZdXlTeuelTtqnMeJA6gOKNRPmyUN6+QHAD7gos5bZ5MDKtZAuGjE4uKqONYszjM+9SMWdGqbhVmOzLmEyqAQ4pn/L3GwP5eP72RX8CtsTC0g4L2IEZ5VvxkthTQ7prMaBcv8jrXm+jYN6M6lm0S/zW27jshFlNGHRNzrPQ9jgCXlOsmnuqX51ulioeECBCrD285zz1LyvQ6k7cGBGenGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by LV1PR11MB8843.namprd11.prod.outlook.com (2603:10b6:408:2b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Tue, 15 Apr
 2025 20:19:34 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 20:19:34 +0000
Date: Tue, 15 Apr 2025 13:19:31 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v5 0/3] ndctl: Add support and test for CXL
 Features support
Message-ID: <Z_6_U_jHHARgD6yr@aschofie-mobl2.lan>
References: <20250411184831.2367464-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250411184831.2367464-1-dave.jiang@intel.com>
X-ClientProxiedBy: MW3PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:303:2b::25) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|LV1PR11MB8843:EE_
X-MS-Office365-Filtering-Correlation-Id: 84a2642b-1e17-430b-3f4d-08dd7c5ad643
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?acSm94AXqNEyDlNk25PXWmP7Zhgy6xjlg77xXXHpRTLMQdI4cAsw425295Kd?=
 =?us-ascii?Q?0qQpFqP42auZulip2yntLySeDaBQmT0ALT62w3T5lO3OBHFj6MPQGsL5ryED?=
 =?us-ascii?Q?w3RmdJ0D6VA+hQ7+7/nP6wTyLlTpmPwvrJFJtUX3eWbePa4ANdO/cMZ70vdM?=
 =?us-ascii?Q?yjxTFwZW9jrGpgNLw9NhGA8Gfa0ZYfad0dgYogoTRL48kOXCyszzOy3EXsrB?=
 =?us-ascii?Q?9592wg1X771ZGCNGNC83STQyGj/7qbWjKz+4vDanargldfnHxqeO3iHXCJCY?=
 =?us-ascii?Q?LxFkANerzL/yAXnJs9/+Bpuexl3KoqzqvhPRiF6oNN7SnMGGFx/WBtxmHZgK?=
 =?us-ascii?Q?+eX8orDlJduTJeDvM4xwj2k850s1gtDBT2HOV03mZSpQ85hhV7dYXPlISl/G?=
 =?us-ascii?Q?z1xKFk8eW1LihvyRExsAweqk/enoQZqbv1p5UNoiqzrzp+SxMIsuMQ6pppC7?=
 =?us-ascii?Q?Irn1734PYLkWh9pFPod6+UStR1sfHEweZYXo6wIrdNqmTSW0YlryJXMBPcTe?=
 =?us-ascii?Q?vSvepreiVyDjgxEZ7K63DpZuaHv1dO4mOgFmHti4vodLfG8jYUtj0vRdqJ7X?=
 =?us-ascii?Q?kfN8b0QsE366gZj1QhEV2xWmAJoC0RRo1JQo7UGxG63YcrTpEZqOLI2T5uO7?=
 =?us-ascii?Q?WZcm2b7K6iiPaqScgswYfwjkRAmcy7g0ZpWEpzdbv4t3BcTAC3g2QY7+6fsh?=
 =?us-ascii?Q?91EJYEwFX4OdWm+BgDAb2rr+wwQmaYf3hY4VVBKukPDwrcUkoR4LWsuh4fuQ?=
 =?us-ascii?Q?I0dooS+2+C+okLalxKcIYPAjGLdbgWPPBcXGbTxoNmli2L53xYX0OkKvBw5n?=
 =?us-ascii?Q?TvyHLkA9G4d7OcDxJiLeYIabf2sF1JCg8HCJfmr3Ge4fOVIDpr8UHZmeKptE?=
 =?us-ascii?Q?Ze5rHiHCFykrj93ccSjj74e9smIjlfpnOfWBHSwPNOKpP6swaMVXsvUQkUiE?=
 =?us-ascii?Q?6Tsry+YLIH9izrHyMpE512UT5p+FMVRNFxCKBIbF4DuwrGsCcw3wx7+vxTKd?=
 =?us-ascii?Q?t4nLLiTwFd40G6jdETCd1AJSJsI3+z3mP5EBOj0hBcSYhafwkuNXP6eyXxc3?=
 =?us-ascii?Q?k6HacNoCIWW1Q0SW7/XWvFvDqeO/gPGXRV99C2e6OaChcVF/iHP3F3VisfUD?=
 =?us-ascii?Q?fr/YHFyOKBEaH++fGhzhh6XyCYWJ/ogX1vE+5jWUmp7X3gB6Au8kXvM0eRy6?=
 =?us-ascii?Q?bKciP8kym3JePbHuCZUtlYie+QwLOXMXruTlnY8Mz6Sq9RlL6gHUE6ftKkza?=
 =?us-ascii?Q?bC/ozeim4WIyq3RI2Rqko2uSkQ4Chn40NenJzkjpcFJlzSNbeDJnyfhpDekI?=
 =?us-ascii?Q?Qy6v2sRPVROY9QfXsvGQrXbtWSvbMaT2M/7aQ43Z+8ets5NfULduCrp73zQZ?=
 =?us-ascii?Q?hpemeN1YTd+9DOhLEznLKckBUUFB?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xlau0sPS3nnwdHeSebKON1BVwsTQuGJnPLcVawnMBJXPl1BprVJ1b8nNC/OR?=
 =?us-ascii?Q?pIuvlhpNiLN3Zzp0TlieJfb3OBAEJZYqJsX5ha0RnJ93nC0Q4naQ3VwgeQ7g?=
 =?us-ascii?Q?g2gX8AelQ4nqQkS9vFSIZREFh7ldT+JpRIjUCMH2MC33Wj2PXsteBUVCE9qq?=
 =?us-ascii?Q?R7S5XJaoT9MSFeTuSZ2ZIfxNk3w7dwbYBTSCmI5E3KM86E3lKLYTBNMAV0P4?=
 =?us-ascii?Q?+yTmUSiCCUOveKnQ+lqIDc8O5mex4KHb1d93lkaTQotKhz9TPkH4hxMzWlqa?=
 =?us-ascii?Q?qsfLFbmmmtw+RyIC4Gy46coEkSpp4kp9UgBtDddAPVQH9dBDioxBfzO1OnLs?=
 =?us-ascii?Q?5XtgmJBteVfeYs7gIuaKAI3p0xW9xNP2q9GI9xHcpV2aUrrCSlLTxo5GQYdD?=
 =?us-ascii?Q?GSS3QcJEBN0olJXJ4VSU86IXPMTUibBP22DnIIPvgqyHIDPSMJRpRbvXAVPp?=
 =?us-ascii?Q?d6G/aHUPI3cOS1Ncpc+yU+e0e5g/4Oqu2JQicfkvIYQC99XQrL7ux9NnFePK?=
 =?us-ascii?Q?NbOfXP1a+X7wk/DbzcRA/VbyCsgkRjCDqjqXzJ0TO3t16/jY1J5AxTrr6Cue?=
 =?us-ascii?Q?YdEQRqf/5GoBMsH6M2zlzlPPR5CSD4o6K4k6S86n1HcesUtvP6+dmylSC+m6?=
 =?us-ascii?Q?tup7X/SfotfG5oXCts0sTipOHnT0LLIrHX2U56wS4eOofnk1WjtFuTZWrK6Y?=
 =?us-ascii?Q?lhfDlY2QAKQ9EPp8cNMrIvp3YjCwbCCuqJ5W/kSO/51yxNA6fKsYRRJwOwl8?=
 =?us-ascii?Q?sHQspQf1obxM+hfmYdWXtxeMYwoY1MBDJLtPvCnWRxu6VoqirkPrGLBgAJOr?=
 =?us-ascii?Q?NcjQP/Hsk1FLvnsfWPRgKI0SsKjBfNL8p4tkN3F6YZsPsikP6dLO8+RLsghs?=
 =?us-ascii?Q?40AOLdm3baywP/AImdaVMh7+Gr10PzXnoTCxyjipzLBTx37YgvsNWjLT1amX?=
 =?us-ascii?Q?5lmRKq+xQ2Tk1NOLhdhf3X53/HH5iH+bBm6yNQVoATUboFZwmn7yALIq7Y2B?=
 =?us-ascii?Q?JgwzwRR5NMHgvBE2OepaJyvtLXtlF4sCJPwcL0bYOo1ygNzj4YBnTye2f7fn?=
 =?us-ascii?Q?Fyjig6D0J6Ir5xekmFKa08NBPdKskUqqbKB/zaaGjvIRaY1j88RQVVRywaCi?=
 =?us-ascii?Q?CvIerQcmWgsXBwYgozKQzYSlDGcfB6qT/78VbJhKyx3/QJ3KcU8/fcLjxNtu?=
 =?us-ascii?Q?bJ4cBfECyXFi0yLIkAMuAvfBclLZ013yiNI+UeMe3950VCCiBMzwhFrjvJmc?=
 =?us-ascii?Q?42HQtowIyyja+CxdGf3MC2G4JqFa64uERDHHNyWCKZDVA4t6FE59f5/B/F3n?=
 =?us-ascii?Q?LEJlHYdkJJr0sXOgXNxv+b9yOhKSKvnHnwBuz/8kb3+bM0GdVDZdzhbktZeu?=
 =?us-ascii?Q?zvaZS9o0ucgl4qv9Ekj2Ov3rux7uzDiKqi42rlG4RISHaiiA1/bpJS5IimrB?=
 =?us-ascii?Q?w/RkGPmGvCHCSPS4spceyFHf+8h51+VMr0OOD8Q6t4zK4I9YKnzJHzsxYLtR?=
 =?us-ascii?Q?uk2F726ESAxJPRL4tsOxMLfVphCTETUKp16EdeAw2QmJJMPcc5akEaAilsHI?=
 =?us-ascii?Q?pSYypF8PwTONvUPT2osUNIANmq4Z1vIhBQcUZ0vjKqusqwJ4qDBIu+VP3gbh?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a2642b-1e17-430b-3f4d-08dd7c5ad643
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 20:19:34.2201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNybC799v2BaWfdxzUazy4yxThhLaqNvQogj8DiYcuyfRi44ZW8i4ZDyMXCHPFV6LyFrQbOVo0I5PYds8JbwCM6YOP8/O+VVAmZn/0U/PWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8843
X-OriginatorOrg: intel.com

On Fri, Apr 11, 2025 at 11:47:34AM -0700, Dave Jiang wrote:
> v5:
> - Add documentation for exported symbols. (Alison)
> - Create 'struct cxl_fwctl' as object under cxl_memdev. (Dan)
> - Make command prep common code. (Alison)
> - Rename fwctl.c to cxl-features-control.c. (Alison)
> - See individual commits for specific changes from v4.

Thanks for the updates Dave!

For the series:
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>

and now I will see if my b4-shazam-ness waterfalls my tags.


> 
> v4:
> - Adjust to kernel changes of input/output structs
> - Fixup skip/pass/fail logic
> - Added new kernel headers detection and dependency in meson.build
> 
> v3:
> - Update test to use opcode instead of command id.
> 
> v2:
> - Drop features device enumeration
> - Add discovery of char device under memdev
> 
> The series provides support of libcxl enumerating FWCTL character device
> under the cxl_memdev device. It discovers the char device major
> and minor numbers for the CXL features device in order to allow issuing
> of ioctls to the device. 
> 
> A unit test is added to locate cxl_memdev exported by the cxl_test
> kernel module and issue all the supported ioctls to the associated
> FWCTL char device to verify that all the ioctl paths are working as expected.
> 
> Kernel series: https://lore.kernel.org/linux-cxl/20250207233914.2375110-1-dave.jiang@intel.com/T/#t
> 
> Dave Jiang (3):
>       cxl: Add cxl_bus_get_by_provider()
>       cxl: Enumerate major/minor of FWCTL char device
>       cxl/test: Add test for cxl features device
> 
>  Documentation/cxl/lib/libcxl.txt |  23 ++++
>  cxl/lib/libcxl.c                 |  89 ++++++++++++
>  cxl/lib/libcxl.sym               |   8 ++
>  cxl/lib/private.h                |   8 ++
>  cxl/libcxl.h                     |   7 +
>  test/cxl-features-control.c      | 439 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  test/cxl-features.sh             |  31 +++++
>  test/cxl-topology.sh             |   4 +
>  test/meson.build                 |  45 ++++++
>  9 files changed, 654 insertions(+)
> 
> 
