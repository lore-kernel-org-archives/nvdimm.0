Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D531618CC18
	for <nvdimm@lists.linux.dev>; Fri, 18 Oct 2024 20:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729284631; cv=fail; b=Yhm1BNhrEYQrN4c9SKE4p33+IznDZcRMoCpcS3LPhrlAEW2Q+qG5imBPjTxFXJeF0g3R0ZmEda6Bc8dh0gppkHe2K4Uw+Jrxs/+rr3bHIEK9HmsF3LbD2Z0xrc722ItSIl8N91kqPD7zDKz1gRM6awRx2J1QcmB26tU/nuf+iXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729284631; c=relaxed/simple;
	bh=BIX6tdU1tpfBeIQlvVhT1zTjhBKotJDvM8ZpfU/v2Qs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DSwDHKUOJahG9EJ/sDrYGEgqSgIJTgcwm+hfnIQKdiqrIA9zq5BALQk9CdA3cLg9bEeuBSpdVgz+kucTV7npCUDhB5Dq6D7Q53itCrL4HjwxeATU5YCzkM67C35HRoj8bSiEqnllGb7keYVIMF7Y16OubT/w1VFA7XiJa2sw/EE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g3iI9BlM; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g3iI9BlM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729284630; x=1760820630;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BIX6tdU1tpfBeIQlvVhT1zTjhBKotJDvM8ZpfU/v2Qs=;
  b=g3iI9BlMd+BcZzUj000tbMHC8LELmfrLQnChKXAwHM5tzcfc6Msgfbul
   8LO7OprLyQkWrXZOsfVtOCwAo6PLPLMY/f/y36KSqVMrB6wQL16yi+W6s
   Q36GWPeAFdduAuKAPJ6xcD16Kp2elPudPCEaIXa8gMgCxfvdHAgw/5dCU
   4uhZilTF6uafXy8EpLKU+5R3nmJIEl+kqfTLZNdc097IuHqQ/qQLwkjPD
   3h26bN5837u3u9Pe22IrVbusXc5/1PnOLSHHI4tP6/PNqPRGv60XtSToT
   /qCIelo9QrbDEd7ShkTkMtzSJ1s/a/wi4jvg9cjkcjnPNIdOP8+PUzE3P
   g==;
X-CSE-ConnectionGUID: TCoBfMZvTbiWayVhVvlfJg==
X-CSE-MsgGUID: b4BmktwBQBeuiuzEvazxdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11229"; a="28922050"
X-IronPort-AV: E=Sophos;i="6.11,214,1725346800"; 
   d="scan'208";a="28922050"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 13:50:29 -0700
X-CSE-ConnectionGUID: beiTS3HtSJOz9I4b0H+MKQ==
X-CSE-MsgGUID: p57rDBh5SWOQm7zE1vWRjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="83797604"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2024 13:50:28 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 18 Oct 2024 13:50:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 18 Oct 2024 13:50:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 18 Oct 2024 13:50:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EJO6jR/HgtxahuL/G1AaHmm6eTE89iMXMvj8iqa7JtVNAIpEDfQPCKBS4d2fSx5tQu84UTjT/jDtQyZDzQZ3Gw9M5Qna1zViGhDiHmEBcRKt5nws4dWbZdtN0KuPHH30JENVv+DXQGyS/m9Wj+LDAfkZLevGVk73wYtOwHEJQWDU8A/Yip8M2a7K8h8e7uT5OStqImHO/6X3E3FqemAQO6rGl2SNRSGsSO7NjkNc7xtbE75lO4OjhjV5uySpAUB4cGRD1IRpVIkVW1XTdI2x5gtN9VfN83r3hpkIRg/4QglqWwOCm2/OmcAbivikQtVnU6c1pmaHPTUnqlTcevBtUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGhFLQ9guYsxrL+XsFfWrvU5Q5sXxpclqbSGnlP+rv0=;
 b=IqbyBQfplUenf0Rh5ncSbn2Ag73m15UMz5LakxFGEZBf8zl1gI+mtZGjra3E8O3Cv1R184gCWCdEwTnAD8VM/AELsDe6tboA5uoUPF23kmR3JpTGOgNJer5ydniOcIzO/MaxomumHoPi0yJ7YSGb77zeeh+J/g6IhmjGwgTO+S68/Ne4IkKqU3RdIiwGNWkYlDqImZJQbRt2pBs28USwVPlIgxmNgUAkVfvl5N3YXHMOZRcaLojqmRJpPQzUcqOBIGJ3gDZ8tJ04ePtGgBw0u1KZGmm/xYRcXBe9XJM//2rM1LGOaNJZpgdF5pbKxbsfjVfP3+NMgIgzIEQXVBUwLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA0PR11MB4623.namprd11.prod.outlook.com (2603:10b6:806:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.24; Fri, 18 Oct
 2024 20:50:24 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8048.020; Fri, 18 Oct 2024
 20:50:24 +0000
Date: Fri, 18 Oct 2024 15:50:20 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Jane Chu <jane.chu@oracle.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
CC: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH] dax: delete a stale directory pmem
Message-ID: <6712ca0c1447d_44de62943b@iweiny-mobl.notmuch>
References: <20241017101144.1654085-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241017101144.1654085-1-harshit.m.mogalapalli@oracle.com>
X-ClientProxiedBy: MW4PR04CA0338.namprd04.prod.outlook.com
 (2603:10b6:303:8a::13) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA0PR11MB4623:EE_
X-MS-Office365-Filtering-Correlation-Id: 1decc14f-d127-4110-3350-08dcefb67cf1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?z4u0nHntgJi72KDMyv3wtKPg+yHyCIUMPvynUA8oJUJ5KhomxHbcLuhE8BvO?=
 =?us-ascii?Q?z79knk/kYoAWpDC5+ne/Ug30iIelD3pfsQ1xk1VumhXuM7kyO7R9DVXjASCd?=
 =?us-ascii?Q?Fvaqs4GvKlDtf8WjMTz80aligKZXTkSVw0vFNTIVvvbg46r4n8L0nJn2RGT6?=
 =?us-ascii?Q?WpQYTMieuSQD1/hUNT+Qt3t3NqQRK8+1/wjldohO47xDwYe8wWO+wsa/j+7B?=
 =?us-ascii?Q?U3JABd2FqQoQrg0BdVpLdj5iw4qxfR/bwZDYw6IBdU44D20fvpeC7hOdn9F9?=
 =?us-ascii?Q?bm5TNanHuluYXWqMW8SbK1tx4xcnWXScUQINpIcj3NRrMJiQjQd5UoF9fnCN?=
 =?us-ascii?Q?0x11UwkqMr2Tz19k8alepadRVe/3JDwFwHBh4ENuO4xUsaw8xnN3f1/t8CGy?=
 =?us-ascii?Q?qwrS/am7saIJvpHJ6NnRxBHrWcLjAwAH52PshdkJv+ZM5r8Qq6R1uLa39J1x?=
 =?us-ascii?Q?c8JwKnPytZOiUHtw8I9aQp1q+yk10iPP5KrGKxZi9aG9R5iuUtOo7d/0KmDi?=
 =?us-ascii?Q?5nuUPeErr4pkf0ZjodpO7aWzZR1PmzDKjDwyUId7BMVXCoovNXsrKDkjPb9Y?=
 =?us-ascii?Q?G3zHK15R9788FxG8sq27ANg03ctXUXZqt/Stjv2Qz/R4YWQBu9UT8Ne5csDU?=
 =?us-ascii?Q?YatYTNDNpaHGVyHfatt9zvVvd2zSTqhao+Zy1LhwmNrO6KUKhrX3U4X2IQAK?=
 =?us-ascii?Q?v47HeQ6zS3aE6oF2AoTNF2bsZA+/9ThDPOsijrZa9h+MnvmRfSX4wdMF7tZu?=
 =?us-ascii?Q?UfZGSQYTwWX9OdePwOwHimVykYANXbTKDnPRau33/g2WJJ5CxALFq5n/UkGM?=
 =?us-ascii?Q?w/t+CnH7VRgM0/DvFLt2NCPkuPgDVFGoIMuan6R99NlR4vmn6YINfcJw0inz?=
 =?us-ascii?Q?CNtBoMJrZINQD3eqxS2cPnS/hmwWImrSixreMBloNZxW3Prd0E+ImKxn5GSR?=
 =?us-ascii?Q?81KBxZNCob2+YgbN59SfvMVnsGvvQgKt4oDoYz3bAMBM3aNQqkEaGQM8+KhC?=
 =?us-ascii?Q?wDj6TRuxhfbAgorN2twYfJwMvfPKzdLY6O9FJFnTIzHmX8iWjR+oXvxK2t33?=
 =?us-ascii?Q?rhvkqznQjfTrg+7kJdgv4iEjf0h0Q9MqfZVEud4RPscx7k6+08ifd2AJBpTK?=
 =?us-ascii?Q?UuBUOS7JBgUwUJGlGD6/aB4FdM9AQH9BwGToJSfufrSsC4ka4SI+9CrhRAmE?=
 =?us-ascii?Q?r7WKTYYZ2BVgsFu+RLXFJ/Z2zfNi7zIKH1tWfepi2k3lyQk6HrkvZkFTR5K4?=
 =?us-ascii?Q?Twiza9L46LItV4FLmGyctg4qLi+zOI53spsUaXkYVpkZlwaZo3GpdO5ywlFT?=
 =?us-ascii?Q?EHaBr5P3Ud1qcCsgqNTWIqMt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5+wKZfXEYoISXoXDk1mexbF0eyCB1qozjgaY/thQ7q0TTTWztr65scbHdKJa?=
 =?us-ascii?Q?IZsdSVh6g1t3IWNGS3GY1auDsAmus01uPig289NWAP+EFfHJRSykyurL2qXs?=
 =?us-ascii?Q?4+yvzZcfKEls8QYxqoheopdIVRqZiqhhPCnNoYlZfhZ4ljc+DFIZ4EOWeLXb?=
 =?us-ascii?Q?h1FmLkcAEvK17UN6/u1Xdoz4lml0JIgw9++dID5AXQx0SQqVTA9smhW8Fpjr?=
 =?us-ascii?Q?gNGsVwW8R+PFbCC2JDgpChuMpqBb3OIeUuSH5IXWSPlqzhAeb9wf/1wm5HkR?=
 =?us-ascii?Q?MrnIWFYFNjq1VN7Ym9RKUeQaYtvFHqPMc9VeIIb7Ba1saIxrmb7J8NwMBDKS?=
 =?us-ascii?Q?9isQIUSqnfFFVdYSDorrEOLyD+rj1LhBaN5V3CyJEdoA2BcpP6XbR2eF2KqV?=
 =?us-ascii?Q?TKfzVQCbGwEQsPly63fLQHwfWI7v9PxITVG6SKuh96G/KUTl3cRdObe377zf?=
 =?us-ascii?Q?Gz2z1zX+32/qEpqLAvrEfDOt8RC2lJkkA/JETF+G4rf7ixWCWVHe+c0hzMGC?=
 =?us-ascii?Q?Bp9CzHUig79PmRSaEe4BQ29FGUcCdCKDm8Xf9zkqAWRmRFvsjOAOUCqQGf8R?=
 =?us-ascii?Q?q2icGvGiC1i9L+4m5u7h/cU7ZrM125EXzK9tOfu+kxWQgQzZHjA7OaLYcRDG?=
 =?us-ascii?Q?11DsD12DFrbAi4CrCZW8wlEWYNL6rixefEUrLWppgAK57hh9IRwXLrrRDHBO?=
 =?us-ascii?Q?7hKXW6NUhdWR/TY0TAsa82RulpuiJnKF8dpo3GPz5CUNDswIkW8ex5awpR99?=
 =?us-ascii?Q?jVDp8VzGPz7ulwnMCY9Tlp7+XUTM1Cd3JTj8bN65GxbeX4m40SYn6KK/g4ur?=
 =?us-ascii?Q?bhpwpJxOjmBQRiufGzqZoiJGcWLVVYu5NDTeWa49Bahjf7V7o1jOS2K4cIQC?=
 =?us-ascii?Q?tjSDnYKjnpcBmuZ0r23TE+6WBQo3n5H+WIo2hZaeTC2iKi/SO98h4iOT5U+a?=
 =?us-ascii?Q?dg70QfBN4k/lsp8WhUF5lUZ7IbAVEU/AS7uFTzLu43Il3pRMJIi1OWrAlCPz?=
 =?us-ascii?Q?NfHkH0JyQrDlx+iJwvvOFKNq2fuhBXDt03/uMPfi5FbUAfGE0KkdE0Z/s1jF?=
 =?us-ascii?Q?mUy3aLhw/xd+Zn3/pBmThC+eFFpTPfkak69WPxCDPOOBQPHWu3xqQeNq5++b?=
 =?us-ascii?Q?PwkfiaB9/Y2T6A7Ho2lB1RLv8njpXGSWQxxzWO2wqjDvjxStkXpy7wokDwmI?=
 =?us-ascii?Q?OlX30J1jeZwK6Rc6WtchDbuSOYBuFgmaJ+Y+CwNYVQTtpGrKum9xgSAl16NG?=
 =?us-ascii?Q?RqK+wUWo9vX33/K8lv4aSjWgPAJ7/q6gWrHN2hFWWDmsHPq3wVef0GcgmN8x?=
 =?us-ascii?Q?Mn3+4KIzzgmio/9NIrlb9Jd//H6zHeUZ8SVI+vF6zwhgXHD8jkxEkh+xyeiy?=
 =?us-ascii?Q?NdIEzAgdkUGOm2xd8dsJok6n2CKbxw6fFR/o4vyMeuqfyeGk1CosjqmNUG3b?=
 =?us-ascii?Q?2bdAQwViNWgAXxA3+AOGBX7gGZgr3WL0Fkm7zG7W1yK8QamPprtZVcX286p7?=
 =?us-ascii?Q?IjSAE6wiHpevTr4nLL6MEJ2Afpta1ShYIOYPZzU5OCh8/86I8pJLdlzfxCy/?=
 =?us-ascii?Q?/Gs9oeXft7As+gY4fOZoEZZABOpXzA+jwQDzAQsg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1decc14f-d127-4110-3350-08dcefb67cf1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 20:50:24.0860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8vEOkznGsk9jww6HAUkB4gRrjpMW2GwoNcFQL6YdwzAmdWR9suf3plCVLrb7LbTdXj+1BOF6OucVB3eyuSkhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4623
X-OriginatorOrg: intel.com

Harshit Mogalapalli wrote:
> After commit: 83762cb5c7c4 ("dax: Kill DEV_DAX_PMEM_COMPAT") the pmem/
> directory is not needed anymore and Makefile changes were made
> accordingly in this commit, but there is a Makefile and pmem.c in pmem/
> which are now stale and pmem.c is empty, remove them.
> 
> Fixes: 83762cb5c7c4 ("dax: Kill DEV_DAX_PMEM_COMPAT")
> Suggested-by: Vegard Nossum <vegard.nossum@oracle.com>
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Marked for nvdimm-next
Thanks!

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/dax/pmem/Makefile |  7 -------
>  drivers/dax/pmem/pmem.c   | 10 ----------
>  2 files changed, 17 deletions(-)
>  delete mode 100644 drivers/dax/pmem/Makefile
>  delete mode 100644 drivers/dax/pmem/pmem.c
> 
> diff --git a/drivers/dax/pmem/Makefile b/drivers/dax/pmem/Makefile
> deleted file mode 100644
> index 191c31f0d4f0..000000000000
> --- a/drivers/dax/pmem/Makefile
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -# SPDX-License-Identifier: GPL-2.0-only
> -obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
> -obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem_core.o
> -
> -dax_pmem-y := pmem.o
> -dax_pmem_core-y := core.o
> -dax_pmem_compat-y := compat.o
> diff --git a/drivers/dax/pmem/pmem.c b/drivers/dax/pmem/pmem.c
> deleted file mode 100644
> index dfe91a2990fe..000000000000
> --- a/drivers/dax/pmem/pmem.c
> +++ /dev/null
> @@ -1,10 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/* Copyright(c) 2016 - 2018 Intel Corporation. All rights reserved. */
> -#include <linux/percpu-refcount.h>
> -#include <linux/memremap.h>
> -#include <linux/module.h>
> -#include <linux/pfn_t.h>
> -#include <linux/nd.h>
> -#include "../bus.h"
> -
> -
> -- 
> 2.46.0
> 
> 


