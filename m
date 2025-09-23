Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4642FD7BD
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 23:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758668706; cv=fail; b=f2zAD1xthjiD/PrfoB2hvlRFGLLsSTyq40SSePhuxdlEEhCzSTsiqduGlG6RhzqH5LellCmFwPMJcJGQmnmweVmiQPgxOW6F48TxXTQm/bgSRQvrrN8TFPwNlHdYszujFWNWubLa/C2w+eJv+97Bo9CGRteBABdrVYrCKiZi5Og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758668706; c=relaxed/simple;
	bh=yZxQCuhy4gwXUNAIvUgu2S9im+JccCfTgAEdTGgDLbc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Nqfcj+9wgkl6aIlzEH1V/MqoMtD31zthd74q/qtwc6R7uj7/wfKrnL6caY0sEXrXCRUZsj7whUPsmNzvIZioe4UtTt6clwnuNncjc+MvMdgOp7H2USqkVOmeRanthG9QThJs0o18SSSBBk0vtNzGTVCYW4Z8rU9tNa3eWrxtE1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AEnhaXep; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AEnhaXep"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758668704; x=1790204704;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yZxQCuhy4gwXUNAIvUgu2S9im+JccCfTgAEdTGgDLbc=;
  b=AEnhaXepJgJ0h29tJZpqf3SoN6wfJ7o6tFcp9R5hGhqLlWcXgjsH86G1
   VB8QU8NZEY47A65h/Dlrxh9Tp3+tz3lRLMZmFSybqSFZLMPj3TdSM45q3
   PSqVLvcniyeo1cFhw9nQNmufVdgRMHN+HKWnzTpcV4JfVdTqVdH0gxeqh
   5m17oWf5GUpagS9mVInHn9U4y3qG7so1WwTcEZfKxy5Heq1U+gRYTf4q/
   UIe0fqvuqAqs967ILiS5bTb8YAquvtUnnTKzgnR7aBbet8OS4Y0jWf+5t
   ej6Y+MY+pnyfUHJKx7qSGoA0CCdxRKWenK12F07X6wsT50YlJyY1bcleO
   Q==;
X-CSE-ConnectionGUID: yTFaLYCBQN25GWIGkT1yaw==
X-CSE-MsgGUID: erlq3ypGTKiux0vqHHKVHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="72064998"
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="72064998"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 16:05:04 -0700
X-CSE-ConnectionGUID: 5ywfB/syRl6wjVSK3OYVhA==
X-CSE-MsgGUID: ZkI+JwivRzytf7krtLJuuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="176169852"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 16:05:03 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 16:05:02 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 16:05:02 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.66) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 16:05:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iyjExxzAx8AiIvRY/8IuAo5hbgy5VcOQFJ7B0bFzA5CEpg86QDNbLlsdQ9TWGUHQiZUQmOtLKL7R3Pmvx279N4pQjNVQgCmK69KDOKghClVz6fgvk4z6g8bCnVTg6hB0IvevN4cQWs9k2BgUyFxXuZMRlLmu3LHpOdqAJuk9eAjSlw4rJ0fLqGp414NzAJ/7Vw54AtjUaAw3HW9AA6m2ksdftIDAs80yioqdqEPQN4WxOc6JlJanFKQ+9KWzuXgUC/1dbmnHFuVoDX8h1y/JqO4lrfmDZZH+UuSXZRiMlHmqpa2lBEH3pYB9kIKYfUv6k9pyM78WiWKD+bZWNYQuDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZxQCuhy4gwXUNAIvUgu2S9im+JccCfTgAEdTGgDLbc=;
 b=Ue4DwPnvS5H8FwJkuWL3CpmTBXnkR+smJu+HdSfOyF0SonRh2fBBzKabTh/r5F2gbuoDD8qVoYUiFjTZevt163UHPDze1yP1iUboqXgD7O1I96XWH/Rbs7OPpxmzG7EOqPESPSrgkPbMRXrPgxCoEJLvQdbnsWs7kV8fZ9Lsn4dd5ByU6bV/OrSZZlRFC4KvHLrJWvPaJVN+/x9Der03IduFf782tmS7vYCQNzWGaQ0T4fvK8u5pOT+Dmd7NU7C6qJibpFO9UMnw5XxvTThE+z87IBYU2aPhbXV+wf6QTBVGKnPEC1VoolgzqUFbob4GFSo7DzeiVBwek3bRjgcsBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by SA1PR11MB6919.namprd11.prod.outlook.com
 (2603:10b6:806:2bc::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 23:05:01 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9137.012; Tue, 23 Sep 2025
 23:05:01 +0000
Date: Tue, 23 Sep 2025 16:04:57 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>
Subject: Re: [PATCH V3 00/20] Add CXL LSA 2.1 format support in nvdimm and
 cxl pmem
Message-ID: <aNMnmdOY4g5PRpxY@aschofie-mobl2.lan>
References: <CGME20250917134126epcas5p3e20c773759b91f70a1caa32b9f6f27ff@epcas5p3.samsung.com>
 <20250917134116.1623730-1-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
X-ClientProxiedBy: SJ0PR13CA0109.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::24) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|SA1PR11MB6919:EE_
X-MS-Office365-Filtering-Correlation-Id: 58959c4a-98bd-418d-cd85-08ddfaf59f9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?858ls64aJp0srEs50M4NHNjxYL5UgEFToznKZ8hLhvuCx4pcxI8eGQJ7VURl?=
 =?us-ascii?Q?vwpVHuXYJ2qeujWJj3012gr3WfwVM/lJp7abh1yvO3/HiKWa53mIS6m8iOKL?=
 =?us-ascii?Q?Rkz2zMQYma/MKGB/YSWuTVQ4uMrEWS2uebDcGH8wCVkIkiEDKjNG2EciNKcl?=
 =?us-ascii?Q?mMEOGnZ4DHAejWU3igMsCHLgHWbX9l+5UtkMAZpLMk/HH7pnGzX4kgD4H6E5?=
 =?us-ascii?Q?3LFCgoGjKMddXPDD++ZQPY1sAV5h6t7wHRJRZ1Nxbbtsm5ZLIvnzP6JLiXjA?=
 =?us-ascii?Q?t+dBPZR6VXFs646XEN6q3gYE0dlyRejNie9c7uEJ8vlv6kbvl9nLiIyQ/iZZ?=
 =?us-ascii?Q?YIUgV22o9Oy/P8wq8jeOBpFgOagqSNNfhJTRdP62Hx55KrmvJMqeMvU4MaoR?=
 =?us-ascii?Q?qeI0E63MF6HTf37Y6PRLHnhVOvfeVCiQcZoe5vaznWzwYOJXFsGlIJcOjF5d?=
 =?us-ascii?Q?cMxd5WmQyo7niOHSLBybl0E+DxFLghmewHW6dI06/ezRPgGl0bd3lEQz720F?=
 =?us-ascii?Q?omdy8S2Ndx7bGQrZdRNIkXILpfOT1XjI8dX3h4xQtEJvKKq2fpgfZkdNxXzv?=
 =?us-ascii?Q?PzlFKcO3yw39Y1ywBmWrBpW5aFvTtQO3FkciXfianppLNzY1cdLvbJg5LKgU?=
 =?us-ascii?Q?Rsj7LZm/+AXfD7U/5SVuKS8UCx6idTLXoILP4KPdSVwTCs7aE/MjLwKydaNO?=
 =?us-ascii?Q?NIC24LruEbsi1CvVAO32QnmV5qfaKrNZdh/aPkVj6i1VyoFdolkw6avUVq6D?=
 =?us-ascii?Q?C9/Ryt2MLTKOblHoDyQSEhstLeSYOIaQHCD6IZcGsjSPiMtGHaviVNT/ZP9f?=
 =?us-ascii?Q?45MZhmgmviLifuF5iyZC9tb0BjWWGJzphcU8RqlgsN9ucgTgLBp6kXZ+7gHx?=
 =?us-ascii?Q?tdOtHSsD6F+cehz2k29QsNpQwHadW4MlCFNtslqV5i4t5ZO5khEse1p3TVJ7?=
 =?us-ascii?Q?5GxHiSBt7BIt4vPr61LO0QsnfrAZ7QWAvP6mzEXdxujnLWJyHrgIK61YLNwz?=
 =?us-ascii?Q?Sl//irHXRK8JqeQ9zF7hOONBywb9TUB5gRuWZbymaDYhwCu0rW5wSD4dKy1B?=
 =?us-ascii?Q?JNRFxJJJjNKsjN2Zcjnz6Or5BoOHG7Myk7lYyn8KFIrI8rvDEvm8LI0+okMe?=
 =?us-ascii?Q?v6cC3qLAxqg1Noo65qExJtFcRHbmkz/nNxqgq/M/WhHAb/CInKQ38NXtsI7r?=
 =?us-ascii?Q?MBdSJW3AJrpj6H7neND/poOgTQzzqiPCjMIxELutxKBljMBa25aCA6pGYVdq?=
 =?us-ascii?Q?QJbbha62n98iSWGL3JYKbUxChfoP57vViJs1gake0FU946m+F6WfkYVNHJLr?=
 =?us-ascii?Q?n20m8qQZSOpSd94dk8d/VJDMHzRXt/0Z7RPV46d+r/yWK/eRdPttsj2o1MCp?=
 =?us-ascii?Q?/MtMaaqEud+3pPqa6jEXlmraU1JSU7W68hMft9i50ABV24/j8MYYpmDCZ1Cv?=
 =?us-ascii?Q?vM1sqeh+o8Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vpLgmn9udrrRKI0qGH66pDORSAc6W8lMI/dokklnCDbW5RqhbDoQuJwKldhc?=
 =?us-ascii?Q?1iAJRGIujs+F4XII6CE3B1hGs5+Ul7GRsHO+OTHRKutZpebAHtgDgsPi0f7B?=
 =?us-ascii?Q?t0IpbJ69/h0Q/Rl/nQHZFRoBZ4QWXZ4YgI8TExCckIC1FqQoVNJoNITzaWZi?=
 =?us-ascii?Q?WCIelZSY3LDZCE0fRnv43ajkXEooWJdmun+EPI0SBnnEP0g5VWNzEVCPw3EO?=
 =?us-ascii?Q?M5KlqqXuNj9VgDJ0lCSEukqBM2sC2se7nngD6E5tEC9AJiyJ3uzhG3xoGGqF?=
 =?us-ascii?Q?adBc7iPjOl4r6gIAFRwjAB3M2GD9V2T2/FdwMLJSahBYsUW0DzZ921EPllHS?=
 =?us-ascii?Q?A/Yuo14fOcPX58vI+XgOHyyEkNi96m8CNhBDnnCMnaXpYHldLI2o1FqC7vJu?=
 =?us-ascii?Q?p8/D+JGS/lac/vwrA8eHtuINtbo+IHmPTBTmok+LUqAoN1yGsDLeWn5v5HmQ?=
 =?us-ascii?Q?LbHUDApDIeMOpjpwD5iXtPaAcy4MykAJbxE5q4DpvV+TksSr1JeoRthTJzTa?=
 =?us-ascii?Q?8NWiHVKsFU4s+Ga1qgy+2nRZktXeck8NvuzT1XgX0ZxwcYf0WfogZA2LThdG?=
 =?us-ascii?Q?CTJ0XjZChatHRQ7A17l5fP7kemGfGs1TWJ3ycHpVO1RuAkA68hUnXaSi1tGm?=
 =?us-ascii?Q?OZ3lQQbjGDH7KfRnoEjCI3Ao4ymBfgprMR1MpLOO+Vw8zlH4Q8XSqcg0C8Ep?=
 =?us-ascii?Q?EbArGi+ZeNEuo+n2e6xWunMHfwYVV2FGojJAa3Vm8ZZcQQgm8Zu40aQT+/cK?=
 =?us-ascii?Q?nyHgxu6irdOj7YMfXp3g0BQYYfCKcTbQ4zZCy22q9OPWbw83JCK7GKNZiMaY?=
 =?us-ascii?Q?EqtGd/nSyJLxufwBauTqpQL0r07THnsAu1V044HLz24f08hK5GJ8RC655S9Q?=
 =?us-ascii?Q?CcXVZCplT343EHiNpVDifUe1lDp2XfcqwgNIrS94ytRSr0VUTMhu39D3vJR1?=
 =?us-ascii?Q?nrkPyYRaUKDgzeDXvLqpiaM1edvtpY8eOXJdc/2G4vJ+86Jqu1C6f1nZSVsU?=
 =?us-ascii?Q?tKM8ddnzg+g0LOoknIJaU1U1Mye5ZO35WSN3ZbaigvQccfPypg6h6Kso0Q51?=
 =?us-ascii?Q?rP5Rd237NbJercOiFnWe5wwP5DxcgjZuSxcJ/dmBPvQIYTXPLuIaYx2sJwWC?=
 =?us-ascii?Q?8kOIcxHyxns4CgnaWyF79xhdQJfVoEgmtfTI2oQlAXBQT/huEi8Bh2zTznoa?=
 =?us-ascii?Q?7GhRiD5Fn2gBS849Vl/yGOQHarPJ4VHFSj4MyPUyLmmVO0weZ7tpm5dabPj1?=
 =?us-ascii?Q?TUqWK8etClCBEtEnvgrNqDi2fFlRvKJG5NKFGodS1xoZmnWqHzdKhXYKXbqS?=
 =?us-ascii?Q?B7gW+joVJABFRST5V1lrSzmSruuwY7MYTEjgDIkqwaF7k5T2iWIxPUNMr2YT?=
 =?us-ascii?Q?tN6GFowmTBY6g3Euhuw8YH3BE4BUOKpQQjgGcfpSlHYOhFagkB3/tLhDztFc?=
 =?us-ascii?Q?eEMs85HyglkL6NVXgJRxrBdwCiHIsE9swo555/fsD+WPWi9VGAAkkBvG1pRp?=
 =?us-ascii?Q?kMVsOxoPQii1PBKY0Y/g/o7RApxmdUbTS8vJvpzx2q3X05cWFh3e3jRQONwG?=
 =?us-ascii?Q?89LIv+wbFP3m1l2vKIvtPuFGdHdYNflpJ7hk6m+y+t0zIR5IC2cmp78oCnFV?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58959c4a-98bd-418d-cd85-08ddfaf59f9c
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 23:05:01.0617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O8lXZcwiZem1nnVjC+heKcCKjjw1vt+BVCbdBREqwCtyCvKgEWFQC9L7nBN9qQaPuXS0alFUgcjSBoA/YZ3yePIIDfp0lKG10mTaeVImKvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6919
X-OriginatorOrg: intel.com

On Wed, Sep 17, 2025 at 07:10:56PM +0530, Neeraj Kumar wrote:
> Introduction:
> =============
> CXL Persistent Memory (Pmem) devices region, namespace and content must be
> persistent across system reboot. In order to achieve this persistency, it
> uses Label Storage Area (LSA) to store respective metadata. During system
> reboot, stored metadata in LSA is used to bring back the region, namespace
> and content of CXL device in its previous state.
> CXL specification provides Get_LSA (4102h) and Set_LSA (4103h) mailbox
> commands to access the LSA area. nvdimm driver is using same commands to
> get/set LSA data.

big snip...

> Limitation (TODO):
> ==================
> Current changes only support interleave way == 1

I see your test setup with the one way interleave and read this
limitation. What are your plans regarding this?

ie. Do you see this limitation as something you could merge with
or do you plan to extend this patchset with support for namespaces
build upon region ways > 1.

-- Alison
