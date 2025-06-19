Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8EF2BB15
	for <nvdimm@lists.linux.dev>; Thu, 19 Jun 2025 01:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750295383; cv=fail; b=Q1+yIGRGs10aLJfGKmObdjOOCn91wGowmkaH6dBbxV+ilX3BXnxMg3eikYBr2bP+JLVs2xO3q95/WAPWzDTvKVn0n1SPcmADjZLU9M01rrcJ5aaqAYGNvjVXMRYJh0VwdlVkNwtH8otaTgBloS6Jc7L9EBtPSnKz+pYdsHHdJHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750295383; c=relaxed/simple;
	bh=Pbv7gSSi/pbywEs1KezxCrnQKqPzKU/QEc7Y1WamSp4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XZTv1Hl6u3XlBHaA5/uoGFgnZubPaI/DSWkbjiHcLsXVz3mtFdsbnInReljK5d1FFfp+ze3OSHQqrWfVoAJb9GxtqR00Vu1cpKGAvLVWABv7QU3hUc1Zt9hzPZaA6k3HZ6dKxdndRihATiMBspbR0ZowH++/dC04FJllJZIikc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E+RecsJh; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E+RecsJh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750295382; x=1781831382;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Pbv7gSSi/pbywEs1KezxCrnQKqPzKU/QEc7Y1WamSp4=;
  b=E+RecsJh/O3A9Xiwy6ucoPM675ubZPnid0ImHwX+Oip5o2A3T8i8Shbj
   f1Msf3yONwyGSoBDFt1/72XcSbMipt9ljiMK21e0I2G8Jw40Tu8irHx6K
   BMATjNTyx8Hi5rEg1RuCPygmB9Un04a90PSaajj41OYNMmgrJ1WhEMV4k
   jf1bZNYthrIwL+UIrZ0g6ojA6QKNJfpskbZG/kaRyRTOXAsnb2N53ZtEH
   rha4/+Ccv1dSzqeA1eY8dUsAghzl0dVwQ1Wk7HqVdK7nTjalioU4GujKj
   bUJK4UCZNYuw/8HlQhwmvOFCJl8UvNEE19NQWlK6c3HjWbfIo19N75cuQ
   A==;
X-CSE-ConnectionGUID: AtTlxNX7Sp+7ZucpouqvRw==
X-CSE-MsgGUID: GGkDQR8mSZOYs0QxYycNkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="63145350"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="63145350"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 18:09:41 -0700
X-CSE-ConnectionGUID: d2rXTOtyQq6M4Ni2fy7FzA==
X-CSE-MsgGUID: L4byTTWnToeOPayJ6Ft9sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="150012741"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 18:09:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 18:09:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 18:09:40 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.46) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 18:09:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hIeSYgqWLL6ULkL4yxlnXkI9Zb7RKVnHwjltPOcqYcwDf9e+vc39d9BX6tEporN9CmYQjbrQ3OCFztg1ECocPiQPgMLZU1EHf31qwQ2DMm08LEbW9Q/dBQArOxen36JfeXLZm6JAZvwJaSHXm4K5MbPZ7PxWDioiEJA1SWNMXsmfR2BuhbBsgJGjsqHXXMjNzyYW3aDl3TzMhPqvDv47KmVcknDmQIvSJ30BXBQTWTXNWXmUtIAXxBYfuorIdUgAWclyiob2kp+mdNxMSY5aOciPPe4INBn4ZytAihy33bwOjkHQlu8r+IP1CTxyQ1CAZWCBRHTEqygTMENc0nb86g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVkDZow2KEqEYVt1He23PZS8DqY4wMfGqxuljgsBlcg=;
 b=NbASaaCEdBCDrVbwVWlDOQFRtBsh3mP3/Vn7innjHx02i5bBTf0mzmEXO9g0vtvAtNtbrOOCc7BPZVjuSxsV89nxPC9lrkXh+CLoS95GP6IUkXgKjZLbEWiH8o8JgJuXWh3paIMFjHvQiCxXZwvQfu8KC+NWPSxlIYeRJiTDpmgB/Y/2gRBD0FzCUqtAqjmqPayNYGVDM3NOAyp5eu2HURZJs9de2e+073QyD4/GiACbZNEYqMF9ncv8tqmIy7x9JhSZR2miKxIxmmDLIwV1/dLKMfZHYFtCgw975ey0R3hVE10CpCILia8z+nSKKIjRt2VJ8j4V/jk9HhGliBZvjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB6710.namprd11.prod.outlook.com (2603:10b6:806:25a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.19; Thu, 19 Jun
 2025 01:09:38 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 01:09:38 +0000
Date: Wed, 18 Jun 2025 18:09:34 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 3/5] test: Fix dax.sh expectations
Message-ID: <6853634ee5664_1f9e100d9@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250618222130.672621-1-dan.j.williams@intel.com>
 <20250618222130.672621-4-dan.j.williams@intel.com>
 <aFNimwh65aJIg-BF@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aFNimwh65aJIg-BF@aschofie-mobl2.lan>
X-ClientProxiedBy: BYAPR11CA0041.namprd11.prod.outlook.com
 (2603:10b6:a03:80::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB6710:EE_
X-MS-Office365-Filtering-Correlation-Id: f89ee978-a1c5-4c42-cf77-08ddaecdf669
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1QCCSBNwbMHkq117Tv/myCnY6IbqJrbFpkeZ/3LpG46wr44t3OWIokR+IuKs?=
 =?us-ascii?Q?Vr3mbpTcA2e9UU95C6rtaocP7h3IdFZDFFiN6vH7e1sgHpHV+RYD8QO6bobA?=
 =?us-ascii?Q?paZObhHbHR7MZ8wTYBHzvwyvtUJLyV5Ex6wc2CBF3SOsFZvV0Q98yrQTN6Ku?=
 =?us-ascii?Q?6fGuhKSPV+olAy3DQyAS2kqvK7FtXBBr33soBLdviRr38uYDPkxvyLXriAcE?=
 =?us-ascii?Q?HAVavj6V8tmAPLlkty33wsE/npE4k/z9u3xMbu05iAcr+gRYBrD3dYLN9t/g?=
 =?us-ascii?Q?L1JqjpALjENTZYEfoZx6NhvlgWayvh14MAga02C8atr+ptpdapLfONNfs7E5?=
 =?us-ascii?Q?8xbYF2J21k0GqonEJFCZyo8O4S2rGmABmZ/j6kZfy9TkXaVqWCIeR2Ru/Jf3?=
 =?us-ascii?Q?5bXOs7B4yZzep+5eiWqDwUe3drqwCRBZzimwGkTw4MYfU8idNMePq69pmZtV?=
 =?us-ascii?Q?z0IRyjuRsEM6wQVq2+9WJlaPBi0UyXSrK+ntax8lYotqn7BFhpglHrFSJ8KJ?=
 =?us-ascii?Q?4tl7hQMOt9eFEESUrjkHuMUGRixoO/PcJvR1Cd4kbMS1Yuvd7BuXvWv++4HC?=
 =?us-ascii?Q?AH46vPGDN0xOg5FyoxrP0+CPuEiZoApaH0SiJgMrAei6wS/vcQkRE2RI4l3B?=
 =?us-ascii?Q?3kLORwAsLtK46+SxOC91VTHm0utg17e+PYnuqAhHzYrOpcemDFY/v7U+o5/d?=
 =?us-ascii?Q?M2Vrs5TFz+X0nE5AcaCYZcpauGvIZFmKDqT0rTcPUSIlE9cC+M3u4NtcIm7g?=
 =?us-ascii?Q?yYnwaAZjsJ5e80Qb8+mOMZlkmWxX/aRhzYNPsnTBxyelH7c19NEIt2Js5tnE?=
 =?us-ascii?Q?zHrc90uz6KDxEvs8QgasO/byR6Hx5a8WYBBx27ZkTPKCrJLA7JmvIe+DVV2n?=
 =?us-ascii?Q?W94X2FS07n3EMKQtoaX79hoBlSaVFGyS8J3pzwsISXTqDbLKcbt8BEkHmItt?=
 =?us-ascii?Q?JBEIAbqRw++Sz0sJxQ3Mi2Sk9/FwWqejFymWN/ZQKrZy4YUTNdEKxUYS3tWn?=
 =?us-ascii?Q?bbDc3zY/cNIn/IUI5uQ3YIZTzbGbXruMDlTIgKZ7PbdtD4Uw86QEdr3umvvA?=
 =?us-ascii?Q?reo94DwH+75R4i/3CEznQWIiiGqB14EPQwqf3eKXzw1UoULOp3TMiFvAK4kA?=
 =?us-ascii?Q?8nMnHMGu80Vw4x13finP5KdWv51gcK7eqxV0Tc5SUmKSoP5zhiV8jdimsSnV?=
 =?us-ascii?Q?Mi/DXXyj+h/S8MlvddTbf2+InUGU+z8TcqFEDPdQ4A649f8RdzOqJA2o0p6J?=
 =?us-ascii?Q?dpLZ9ge1pZ1VWKWwKp/cTIubym/igfuaBcH5pdtFvE7L7qfsvOihlcbv4hKX?=
 =?us-ascii?Q?86sMEPdB2PgSJtdktv4ElcVrWU34ZHFlcL4/7vQsgyYILTAUwbSaAuu79U/S?=
 =?us-ascii?Q?xG7eZ+2KcV/QKxWiDAf217tAWLSurOuxo/8A5HmVRR4ic7DUv/50QRTbYeuv?=
 =?us-ascii?Q?InKhTAIpVSM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fVI5ViGNi9H0ygj8bV5D1X/u+rInHN55XR8oc8MS2S4Z3sH1fFppqdjleIc7?=
 =?us-ascii?Q?1zszLGVqsxwY0hRW1W2/XrkIqIuros1Oaq1bjWvy2E+WF719aC+8Gxm66duh?=
 =?us-ascii?Q?8p8mSwSXZbog5Lqs9Plyq8c3gNOx7OxF+LSoLGYTfHYngVmZvkPiLBydvjWa?=
 =?us-ascii?Q?zsnuEetQW9xQGy4WNbQ739I5dL9diVfJsLyDqyOkEDUBgxxNQ4F1NPQz1kcC?=
 =?us-ascii?Q?6MArR1OFHp3OvY2g/RcH/Lep6BqVat4UiYSBvAr69LYd2T2Bx6nS69+n6oRA?=
 =?us-ascii?Q?03Wr3CL/m6pS2gZKUnhzldVGiiyLN8tUqb501REdGGNDqLcR/OUJUnUC5Y+U?=
 =?us-ascii?Q?BHiBpTI3XjNwu1cYNQBAqQpZv87yRV9GVJ0r97yuQ38khcBq82iD2/EqbSu1?=
 =?us-ascii?Q?oLfWn4jIXEVefMX//8G7XeLzVo6Rawn4/2ovQSrroRhSw4Nq1Ifsw7ukExnc?=
 =?us-ascii?Q?cEfEN1gfFSenxCQlVa0+vWVLvHdt+a0AwSRsxKtGfPlZDfjLAAZVs+kPlO/x?=
 =?us-ascii?Q?n3AJPzUSSQvjUNT5/ADq9fp8SM3Xt/Z+RHSB0rVFtbjEJZl/kQcAltyiQS1d?=
 =?us-ascii?Q?4d8h5o/9haCX4CTC7dqQ63ShTKcZJbWGoMKT+cQXMSexJ1uYCwA3wfe5WjJ0?=
 =?us-ascii?Q?PB5SqHLhMECIsFhKJZq/1YHCxwo5tLkTWIjo+0h5rsBENKdn4dylV8hMZL+h?=
 =?us-ascii?Q?35qz26MPUHYrzdwRYFbawu2ddv93tJxp9pAbQHQVB6BX555KmbNu5p3m9Qsy?=
 =?us-ascii?Q?U2xlScyJgOYPt2yiunhUH2zbmSxT+L/ZClvlbBO/k1WQq3ia8E3IKnS9wazh?=
 =?us-ascii?Q?0uckcGx9OhfZ0JQvO3D5R5fsBh4UuBoBs67+sIrV7z2M0nUEm2CAxSA/sNGJ?=
 =?us-ascii?Q?of6sMEOoGuYyg94WA4dLXEAnzlAowaOuzV7Z/TlacEgs+VPpc2F4q8ZUmA68?=
 =?us-ascii?Q?U6MeqinxwsKAw625JwjyoElgk9jVqt5yfUM//MFXtN7qnwoJgxaamWIW8zaC?=
 =?us-ascii?Q?jXeFQCqI0zDLEdoeNjRM3Zbxb/u7Yalcb9n2RWxB1Q0fA7vxbznKdMK+WxeT?=
 =?us-ascii?Q?t+1IQHVV/C1NAZ2UBkfzUCMpkbqN5e9ge2ozuzLU2vf6voxrYCvcl1NYvWk1?=
 =?us-ascii?Q?oUz3oMTuio6P4ZEr9jVXNgtMXjg5fjVs+HWtobBCKhwcYc5u8+LWmCm/7Gft?=
 =?us-ascii?Q?e4+0t6+fYAPMhKf8RuKgMnAYEarW+zJWOz2zAAvk0v+iOpv4+2GozaSMSYz4?=
 =?us-ascii?Q?1u8OF1lDRI50c+YnalKfQC+wrBrKGWAikDztlFbPraUo5EpeFjmoHPpcA6VX?=
 =?us-ascii?Q?9ash64rVer+3LDTimBRdR4hexL7gzjd9MLBOLj/mvZJawOz2jnOwrdl9/Ulv?=
 =?us-ascii?Q?jlSU3XLnuuVyBjlnWyT4VGcylZ+60sC42QvNW8/RPuTe3lSb80zuQim+BFfD?=
 =?us-ascii?Q?6oWXA/JctCLvZ9x+Q6MiLYl11E1qgCGGguyJRTnazNfBOSTHAfYwDDVWaum9?=
 =?us-ascii?Q?MLhHpjuP12wTStAXw8+hu2OQjtMc8Gx8cFwuTiLaV97qHAqHLWqqDryRQ+Wq?=
 =?us-ascii?Q?yMYC0byYVcAJbwYW7jmsu4NoVOyWy07d4kClv9qFogDgPW8lstrI0bX0HTup?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f89ee978-a1c5-4c42-cf77-08ddaecdf669
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 01:09:38.4431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IHQtwElJf2dab1wZdkwZfa/9S86FvYVEHHLE42wXS7GBEPu5T0sVsv1aDsaIDfNSKAZYEQICD37oIEhB5rgZdyyZW9gVS+3OHsfkDixJfyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6710
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Wed, Jun 18, 2025 at 03:21:28PM -0700, Dan Williams wrote:
> > With current kernel+tracecmd combinations stdout is no longer purely trace
> > records and column "21" is no longer the vmfault_t result.
> > 
> > Drop, if present, the diagnostic print of how many CPUs are in the trace
> > and use the more universally compatible assumption that the fault result is
> > the last column rather than a specific column.
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  test/dax.sh | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/test/dax.sh b/test/dax.sh
> > index 3ffbc8079eba..98faaf0eb9b2 100755
> > --- a/test/dax.sh
> > +++ b/test/dax.sh
> > @@ -37,13 +37,14 @@ run_test() {
> >  	rc=1
> >  	while read -r p; do
> >  		[[ $p ]] || continue
> > +		[[ $p == cpus=* ]] && continue
> remove above line
> >  		if [ "$count" -lt 10 ]; then
> >  			if [ "$p" != "0x100" ] && [ "$p" != "NOPAGE" ]; then
> >  				cleanup "$1"
> >  			fi
> >  		fi
> >  		count=$((count + 1))
> > -	done < <(trace-cmd report | awk '{ print $21 }')
> > +	done < <(trace-cmd report | awk '{ print $NF }')
> replace above line w
> 	done < <(trace-cmd report | grep dax_pmd_fault_done | awk '{ print $NF }')
> 
> 
> Thanks for all of these Dan!
> 
> For this one, I ran into more metadata in the trace file, other than
> 'cpu=' causing the test to fail. I've tested what I'm showing above,
> which makes it immune to other things in the trace file.
> 
> Tell me you are OK w this and I'll apply this set to pending.

Yup, looks good to me and is even more robust. Thanks for the fixups!
