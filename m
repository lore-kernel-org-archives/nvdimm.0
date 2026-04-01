Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342B63CE49F
	for <nvdimm@lists.linux.dev>; Wed,  1 Apr 2026 22:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775083006; cv=fail; b=NBWDx2s1yvT1vQfpShFdQFYlRkX+DW2Rz8ghrg5PKkarIcdLr9Xf9iyzyYkCqPLeTvIXbx7So+z+ynQwaLE9DnKE73YPbpgmN9Vxp306Y0ceCUNsl53XRyFfCdJ+X96pDAc2jvEoct2OMFpEbRQnIp4/x3odALARo2AM1jFyIP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775083006; c=relaxed/simple;
	bh=RSOKBa2Oqusz+piXPO7PWI6mGlxIPqMQvidJ6AJwpkg=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=qA7WGRgj41+tGCKf/hkUChEKm7RGhByrnZdsl4xt+wcpXc2CypFXh8KFyvtU80R5MaPMU5BNusv6Bw7wAQWle8lxHNjESvrMAzEQLjYQ1FSuzJPNLriZ2pl32gzo9/NjC0uEzoZ+ADqXgPicXlAUTaflP9HjPXfBr5uTgs2lcps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nNUSISC8; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nNUSISC8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775083000; x=1806619000;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=RSOKBa2Oqusz+piXPO7PWI6mGlxIPqMQvidJ6AJwpkg=;
  b=nNUSISC8MuhJKqtQe8420k4BmW5C1yDw+K+YcMDSfltCiKUXEo++Ucka
   DW/khcI7ef4GcuPmugE7bB86h5UTxyd/BE4kT+WN3gyVGzf3YwahdbdA6
   QQAXA9JzjI46x8W7oZZbeGzd/esYL/iXKDn3bwlJI4LmiefIRzKJ4ksFE
   rdJA1+6P9uwkGxzj2p/Zom3OYneK0A4JJrlGmlXRSD1+ZO35nGtkCnD8Y
   IdQRnJnygeu7Q53p2aJ76EF0fFxHCupvgA6OQ74WZwXpgsioOoYJYc7G2
   a0V1PtTZYVB9ytZ0ZJ22ANr8KJ0SY0daJ9SZFVt6E22Mgx2+3x/iQlXZ6
   A==;
X-CSE-ConnectionGUID: Gj0a+UTyS9CBflY2VCmh5w==
X-CSE-MsgGUID: tOq6wBFrThGZ4Jve7bT1Zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11746"; a="75310541"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="75310541"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 15:36:37 -0700
X-CSE-ConnectionGUID: LTP6L2KaTLSlRUHkYuOaFQ==
X-CSE-MsgGUID: HLdjKfIhS9S7UW+/nUthJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="249854093"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 15:36:38 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 1 Apr 2026 15:36:37 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 1 Apr 2026 15:36:37 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.71) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 1 Apr 2026 15:36:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3ItsloAY6idvB8y8OcBJia8tR7nYTYbHiq7kJPUPVHWn2YcADBAyublUdhyZnh13P1HUC4ZRrUMw3o0K+o/LKJlVwoM8RNkWwMZHebydmZAX7ZtnbBw3CRFlj0cWuY6S8S3KtWUA2y9MkJg6GMA/k1RQcBxpnxEQH3QVtdP7HRcyuYD49SHBzIA+VAoynO/DMZAXubxEv9/ppIx4oMpDTHfE3GdWd5mRvcolPbOPZN7fsf0RVedRM/Td/I+AiDIi8+q5lojvyuc7lvo1wfxH+wp2MrzLHK4DGs/x+aHwk6fJgaKsxd7Qtagt5F8Lf8/lIcWbjXaoZxeQ6YFd+w9EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EE2OM3fq6L7qlRw5n/n2x3VdSqc41dDQ02OytUxYVUM=;
 b=VfFN8Dc+uX67LhjxG8SApQBD5iY8m2jfpnhjvmnkLxVu7nyu2oFMNwuuBwWva+XVOK95MleVVANVwT+Fz4uC4XuA93DDbCJHG/wiFMIVEBcTeJahgyXu12R+9fM/uWkMHYClMaB8chnv4D+A4XhtntxLijML9HLlY3ZbWCxe+yJO8Y/YaIrbUI7LgSAU2ub9vGNJbhCW+UW3sH+EmmAAI5bVFLi/jEtd5n+AA5pAO+xrTuTufWCCONOB7xxvkoOqypF0G5XzdxDQEsRXBr4Fv9EfiH6qB25Yc1+sHb7z0yDFiFs7cH+58NmPHVxMhQAih6NMhFy0jr6gbGmTSKmrgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM3PPFA69606334.namprd11.prod.outlook.com (2603:10b6:f:fc00::f42) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Wed, 1 Apr
 2026 22:36:35 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:36:34 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 1 Apr 2026 15:36:30 -0700
To: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Alison Schofield
	<alison.schofield@intel.com>
Message-ID: <69cd9deedca87_1b0cc610036@dwillia2-mobl4.notmuch>
In-Reply-To: <20260401221336.2894052-1-alison.schofield@intel.com>
References: <20260401221336.2894052-1-alison.schofield@intel.com>
Subject: Re: [ndctl PATCH] test/cxl-dax-hmem.sh: validate dax_hmem vs CXL
 collisions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0219.namprd04.prod.outlook.com
 (2603:10b6:303:87::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM3PPFA69606334:EE_
X-MS-Office365-Filtering-Correlation-Id: 39b3ee39-f746-47bb-c1e6-08de903f212c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: NywA1IfS5L9i9j2/qVxhvC5Sd9e802VKLLzh/DcOJkFZepcJC6zIIPWViolHoMR30F6W4v1/wDPPR+gIzMCtsgAVw7b21m23clxxl3+14p7JfAUw5HVbsF9ZywoFWmk2irA/wy4lppP7Gbh6L5H5wXdB4QVckVI9vOqbczPnvH6bdeLvmkVXL9OEnT6IwibRAE4gZNprE88b8E9yPHpy8UvvX4uYSozQj4pBZL+SAcGG7Ats4tyh2gw/snviCVz8rMkFAjs52GraRhTaCvpTiXvCvjwaBkG8EZvNESmyFCK7zGfRvKi99eNtlUTGgipzcev9X3OVPgjSPet7NiX5dSMTosQCnBj33hgE8BffA8BHUJXxk/F9MG3Lko0OJSQFrHp36zJgOhKRhwJ1vhvYOD3ov3i8FtrhWTSNLpbw7ozJhhWjdsMdWT2VUGSanhDZHyEcx8ZEcg8XLPyzvHJyOPYz/gEtzN9oRcdOLXmcr2djMui4leBdSKIeErnyjMxjKGQjzjODKGXAQeaxg0f6B6JCpisO6yfK09m2qzXoI45DOSl7Oj3NezRBnuhD5dXeMGEr7euxe2RpFbmyPVbM7Y/4BmjvLW0lF9xcJcY7OwM5ge3mSrU8hyhwnlhJ+Tk9ixMepqFPqx8VRZ26WVPiwx0QqImhsmkSRf+dd6w1TeWjf8xpL4xFFTtzzUy7hE7G5KeU9ghVCeiGXEtbsbvwWBzCPowRb73605OWLSMDR3U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjRZTVd5QlZvYmk5YW1FQ0tQdkg3RS91N1dwVzJXVUU4RkJ2U0FuVDVlSk5m?=
 =?utf-8?B?QUtSa1J4NXJ5R0c1VllKckpBQ2NXQm5MbzNVQ09YOXZ1UFVpSE9vcVRVL0g5?=
 =?utf-8?B?QTBDdktOMzNrWCtMbTZBSnJ2NXpheHAxd3JLWS9oeFdlQTl0WmJsRkZWN0hC?=
 =?utf-8?B?WjVmcjZFc3RUMW55V2FqSGdjc04vTUpBYWd2Rm40TWxVaU5YTVRPcmhBSTVH?=
 =?utf-8?B?OUNIQTFXODVWVUl2eitzb0hLT3FzdmtWMWpIdlRrRlZ4NWNGbjNxb3NSbjNR?=
 =?utf-8?B?L1o0Mm5pMGhVRnVhZEdZcDNDRjBBUHVJeEtqRjNqNEZrWE9hS2JIOWlhdngr?=
 =?utf-8?B?SnpDeTYwcWtaT01kaEdPN1FlU0xaa1ArRldjbmx6ZWxHSjBudkNEcHFxUHdB?=
 =?utf-8?B?UWVmQ0pHQmlYL1E4T295KzB4VzUxZ21PYjRxbkUwZmZOTVdLbFlUS0p3dVZt?=
 =?utf-8?B?SklyTTZlR1YrUUhRbWxnQUZKNk8wU0FrY1M2cElRNzVBWHNQMnluQ0l5MTNX?=
 =?utf-8?B?VVIraGllaEE1a0NyZ3pHdXhZMWJMb2NLdXN5clNGN25YbjI0THZXOE4zd2o0?=
 =?utf-8?B?VmJZS2krKzJBSWJxM0xnRHBCZ056SG9hcUxjcEk1R0t3bUQ1L1RjRXlLeE9P?=
 =?utf-8?B?emFjS2JjTE1TZnA3dlByQVVwN0xFcUxDZERBSzlDc3FYN1QybFYvWXMxdTcy?=
 =?utf-8?B?ekJlc2RSZDFRRExRN0FVN0hTSW5sWkkzZTg1M1V0aDZ4ckpwUjFzRHJwNDdY?=
 =?utf-8?B?UjRwRHNOcEJpSm56dFF4Q3ZkUmgyOGJOdzlENE1GRDJWbUhDc09XdDU5YlRp?=
 =?utf-8?B?Z2VyUnZrSDZEcnNkM0xQdC9SKzluNEpzRUpoS1dmTVB4bG1QazFGSFlxN3FB?=
 =?utf-8?B?ZkJuVUN6Q25EciszaXdHeTVuREpUNTFjVGVvb0kyZ1UzcytXSFJobkZkdlZp?=
 =?utf-8?B?MFQzeXE3QzlZVSttSytreXBBZ29wckVpd0hEZXc3M1FEUmVwZllyUmpKdUhI?=
 =?utf-8?B?YWhqZjd6bmwxOE1rTnROQWlVQnltcmdXSmpXVE4zZklVWG51aEVIdGpLQUlj?=
 =?utf-8?B?aFZYSzNhN3VXREVTQ05Zdyt5UjRPYUFEYlkvKzd4VW1ZcDI0ZXFiQUhoVCtT?=
 =?utf-8?B?N2Izb25XTGhaSi8wVldMcHhWUTFDb1N3OExiVno0cHlRL2JDeTBPaDF1ZjV6?=
 =?utf-8?B?MGlIKzJDTkNTS3NYVTROZ3cvRlZoOXFDbFd0YzgxdnliNGVMSVpRTFAzTTF4?=
 =?utf-8?B?QXhsd0dSRlRyNXREb25QWXI2TlNieVVpaWtaSVg3MG5Wc3d4NHhBZGRaVkxX?=
 =?utf-8?B?aDB3RnFYOUtVNXlvSUJaeG5CdlR0WmtGOUNieW5PMGJteXZqNndkbXR1Zk8w?=
 =?utf-8?B?a3RsZEkvblpVekZVazhHMWdwOHZ6V1ladm9MN3Z1QnZhZHNyU2JPdzhmUW5w?=
 =?utf-8?B?ZzRqRkd2TVVDOG1WQ1p1dzNKekt2V0NSdS9mSzFrNzNpMXdCVVVpakRac3Q0?=
 =?utf-8?B?T1BmcElGSThyVTNhcHQ2UVl3SzljV1JBeW42ZkVzMVMwV05XOUQzZXUramZw?=
 =?utf-8?B?NzFtdkM1VEMyVW5yQ3NrekU4U3p6aW5yMGsyaEdVS0tkZzg4Q1BuTGwzVm41?=
 =?utf-8?B?di9pd0Z3alBPTEVTUXlWSytIajVnTzFrVVh0eTN0ZUx2Y3ZyTmRQSGt3YThY?=
 =?utf-8?B?eWVNVlVLeFdEV3hYcmNZb3dMTm01QTFKYTMwS2d0NGVtS0s5M2NjSnYzY0Y2?=
 =?utf-8?B?MnpWcGRVajUwYVRrTHJmVnl4aFgxSkZOK0J0VkFLbkMvQkxsOFlWNFVNeUJy?=
 =?utf-8?B?VUxMRGZXMXVQYTBnZGJnSUtGMUZCVjBzRVY4SkNJbjNSVDNjSjZxeitoWlEv?=
 =?utf-8?B?Um8rbExlbTZza3hSNG5yWCsvT1AvUGIraG4vaXBqRG1DNFU0TktmVDF6VWJU?=
 =?utf-8?B?Vk1pekhUQWpHSEp0czVyU0tPWHhqWmJDblZpMFVLQ3NzRTJianZ2Vk1PNGlD?=
 =?utf-8?B?c0diUDhteWlYNko2Skw0TkZRQ3dJbDhpQWFqSnNVcWIwcFN1RUFkY0t4NTJY?=
 =?utf-8?B?emJuTCs5MkZIYUVaVDhKUW5iMnVBTkZOTnJ4bGk0cWpjRDB2QU9TSVNsaVRU?=
 =?utf-8?B?SGl0ZW1wOEJCVkNLVm5GSnhRbldFU05OQndBTDVTNENtZ0xKSVo3amVuSkFU?=
 =?utf-8?B?bHlVNUh6NnFrdmt0WjZ4TjlLay9CbU9ZeXJqRzNKMzNxSzRYbldvcGVieEVG?=
 =?utf-8?B?WDdNTDBGajVLZElBelAyMkpBNURxYm1yVWlDZzByS3VlRGU4RERwNm83bWRY?=
 =?utf-8?B?bkJKTENvTmU5NUQ5bkVUVWx4ckx5ODI0T0FEVytQa2J2RGd3VHBzeXFOTnVW?=
 =?utf-8?Q?GwKANC0d8RcCTVrg=3D?=
X-Exchange-RoutingPolicyChecked: H2rEYtyWv9mpQcys7pE1uqqgKwfJ8z+1glHY8IRt6SWdhLUF8No7AmIibcADLpqdMRPpKJBb2um0HXYJ6dX95b+i+G5e0nsSZTZosUAhAy/NGFSWI9PHaOpT9FiTM96IhMXztLkdoNT4J0dMIboADsI3g4EiniTjvAe8dJ0GK1zSDBkJL/xuEbOFnfEdJfoazH5lgW2H4mJ5zgZJn50swhYmyaqLPHLQ+/Vi4F7nGut7LceQsfdPOEKPphQ1qgmglT9jAtvisX5ad/mJNNErAG5ZQ3L7pVsQsKO9/Xnxo2qMtbsHn5FmmvtV7O/nMdUK/uu/XIqTq10lXJ4vWYEnoQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b3ee39-f746-47bb-c1e6-08de903f212c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:36:34.8643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4w0vwYoUTTgw1+Ahv9ARC7BYXPAKb5l3B3ppOYzPZAChFqQqGPITQrwXKozy+YLcBA0S5Wp6jY+ETcPkE7GGoLoGggLpPfC+kfAaDQOh6xk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFA69606334
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Use the new "cxl_test.hmem_test" and "cxl_test.fail_autoassemble"
> module options to implement a new cxl-dax-hmem.sh test. The test
> checks dax_hmem takeover of Soft Reserve ranges that collide with
> autoassembled CXL regions. It depends on the cxl_mock_mem driver
> to launch multiple async probes before the dax_hmem driver attaches.
> 
> [as: do_skip on missing params, explicit param usage, robust unload,
> check_dmesg, misc style]

Thanks! Looks good.
