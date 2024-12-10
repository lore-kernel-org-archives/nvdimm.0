Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4EF86323
	for <nvdimm@lists.linux.dev>; Tue, 10 Dec 2024 20:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733862667; cv=fail; b=dlMK7SNW7//00PWi1J101EUR3QDsVk1KIoqOWmloJWbFl/Z1WogVE8bT3GY+mHYY2cQvi0Tu7PbWWC8QfXVQtVDRb2r36We2J4sBTyLhbnqJ15r0is6wH/pTNnWdIr7BLhLQ3F1zAzElsFLCp5pYTww7U+CVim0WIT4lBdXWsmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733862667; c=relaxed/simple;
	bh=qmlqw955LjdIKuMqUtlchcCbTO6Sp5jWpmRTuf8jSWg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bLBaxbOTU9ptumZiqP+2i3qfwjm14Y7MIYxedlY0lIlzIrFrEOuGqhAsOJrI9N+Ffama305aIogIh2UiQXqmVkf+gB66mX+yrO8435sJCsvfR8kTqNQW1pdr9j1GKV6pEBoKF3GifunHlIbP1Bk0+2NV9PrsZ9NfhsrpTsBZmLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R65AJUXG; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R65AJUXG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733862666; x=1765398666;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qmlqw955LjdIKuMqUtlchcCbTO6Sp5jWpmRTuf8jSWg=;
  b=R65AJUXGRDEs0kqKiK2XOphZ3rMxDB7vwin6dDuMvC0QwT1F5AFp+JPY
   9EDIftqDcvKri907KEIFY/D8/EQ6++2unDsNyV1j/OU1CJi2WvSokZ7Lo
   uNqF+7K7eCy28s+0gh9k+hc3KiO2H6NU2iXndSJ0V4ufdpLJxSUXJLC0t
   63dL99r+c3cxPJUoG4nHt3VmEmcBqiecknCCAZxpXrWFhE4k3AIM1TqSQ
   H7G1pRjVXOcisucnxtf2r+fVfrZ8KBLWkzZMoMZYb+EbSgxvDsl3OhwUG
   KYmYvWqaUuKnOZdK47WrvJw48TfPKN5EA38YApGp6BAE+CRI119zcpIw3
   Q==;
X-CSE-ConnectionGUID: L4fisYe4RnixERwCcv+XsQ==
X-CSE-MsgGUID: Qb1D1ZDEQmKmT8TuEx2+kQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="34277853"
X-IronPort-AV: E=Sophos;i="6.12,223,1728975600"; 
   d="scan'208";a="34277853"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 12:31:05 -0800
X-CSE-ConnectionGUID: RTSFnHV+RdGnJtRRrtZ62g==
X-CSE-MsgGUID: 9qTl4ozCQ0O867I22Qt/uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,223,1728975600"; 
   d="scan'208";a="95586835"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Dec 2024 12:31:06 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Dec 2024 12:31:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Dec 2024 12:31:05 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Dec 2024 12:31:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j1sUdXnI5tO2Gx+euhdT1A7/GCK/ALaAvL6X0Aqpoe+WJNBTi5gRs7dDpR1bn7b7+uD+mEGHSxPmvvA2n9VP2QSUJEs/LwQm8EYiZxjOSDtS8kgRkQ1vFfnLfSwMXnTIV3ZtuO1RnPQe56fzd0YJSN2JicxtEncI0xyxzd5BTS8F0foKfcmd5ZjiOj01eZ3Ed8L4CHuoYi5qtXs9WU7z0/OGLom/CIJ6m0NhL2zEeCZxRj2pcoqgCfyvMUMtToOhnZdL1JwAjHgJhKzE6rJbv5WwlCWvNfvX2jzPcPdAXvydPAwGYnSFfqtF3YP3xwYnkMQ1KI6Vv/oD2F7KX0CQAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/rvES2HflKiGqtpouY51TCBEgprUgEYIU+cl+02GPI=;
 b=qxHRuGgzsxOQ6Q/dOHkwBexKo7fqr6e+IMbwAosGceQzkI/LFMRHT9vk6WGnrR7ACo860UrnAQmZm3weDwb6dD0eMgUcvQVc/TMX9MRB37HNNWanzaJSI6go8pRABSbr9oj0UTIFm0OpesH5wERGYMsao+6Xq6lchLTwQ1TjMd62XXHGxfZGfTkzV590BbFkXr0EzyHoxxfows0IAzHzRYdiXWIzswP6KAhdgH2SQJdcoJSrI91u3rvk5pPQ7R8o+UOrjCDRP7HJ/5hYT71wt6OWewfYn66BOLUbEDwklWmp0JFielc5o9VDP5O0DXov/o6CCCAEGb9mPcnEMEULow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW4PR11MB6885.namprd11.prod.outlook.com (2603:10b6:303:21b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.20; Tue, 10 Dec
 2024 20:31:02 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8230.010; Tue, 10 Dec 2024
 20:31:02 +0000
Date: Tue, 10 Dec 2024 12:30:59 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Li Ming <ming.li@zohomail.com>, Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Coly Li
	<colyli@suse.de>
Subject: Re: Removing a misleading warning message?
Message-ID: <6758a50391a54_10a0832944b@dwillia2-xfh.jf.intel.com.notmuch>
References: <15237B14-B55B-4737-9A98-D76AEDB4AEAD@suse.de>
 <ZxElg0RC_S1TY2cd@aschofie-mobl2.lan>
 <6712b7bf2c1cd_10a03294b3@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <ecccced3-07a1-4b4a-9319-c6d88518e368@zohomail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ecccced3-07a1-4b4a-9319-c6d88518e368@zohomail.com>
X-ClientProxiedBy: MW4PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:303:8e::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW4PR11MB6885:EE_
X-MS-Office365-Filtering-Correlation-Id: 9de7d64c-d10d-42a3-4adf-08dd19599018
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?O2+dNAVdScZMS5I4SYMtEjGBTVD/JK4PJwjOw7QPhRsGLc4LgpG8xY4IBj1y?=
 =?us-ascii?Q?alfkzwc3hDErnm64phGT4RwRGR6G5iVayGGovPdo01YHWJ4HBWRZ5335JfUl?=
 =?us-ascii?Q?Sr8mdhQIQtlKKmaOW5G+OZqy3eDGf7glHd/QaiyDj0N97CTHot7Caj2vG7Mf?=
 =?us-ascii?Q?ePkSucK4ANpY9fR98ZeEsyEx3UdD+Dr9rMx3fm/OKAhpfBJXQxOevXr3QPdM?=
 =?us-ascii?Q?kmRKJk3RmbXNyP0DNTzlPVjVYDdsUg38d19YLBrwJGTKGuDoCfJC5UCuqf3z?=
 =?us-ascii?Q?vbKsvJoALt2GO0jRgy7e4cZOufNUGvF63A4zTA0SSBOH2aFIWcZmkcREs2PQ?=
 =?us-ascii?Q?I035QXfOV0f+QhWCeYk3xZDOjxrDbaV3N4hdbUAj3LaiMVZzjMgeks+c+Eib?=
 =?us-ascii?Q?W6zXGXekTF+QebTyfhNlNytAnZTm4Y/7OzwiU4xkGpMhmxtaE8LUsJsxenan?=
 =?us-ascii?Q?vQ/XvDFEqHDaX1e+QFTTRgUoT+Ez3w1ulqczP3RVGuqJMjVnG2UtF1Bw4PaE?=
 =?us-ascii?Q?cL0ttwsiDwy/nvbhRdn1JWJPVDmx3HXo4GW8tQDaQbLgywnZGeqEnkgvzWwJ?=
 =?us-ascii?Q?j6myYVCk3y9WgIUgRdeZfalSSr+yXis9GehzseyL3ZF2H9v4jIX/F8eCStdW?=
 =?us-ascii?Q?skQNHy+gjYBEZ/zsMsZ16qg0gosGfm3V4NwtgRo4UwmkTVsDOrDWVTjjDd26?=
 =?us-ascii?Q?YlWm67HiQSxQfzesg5lpmiZnyLUKFKC9pFx/mN+mpPpTkz8C9ULzQKoxaLM7?=
 =?us-ascii?Q?frtVNs2CtZHicXxIdF46xs0IgadXxBsVdZaVK11Bw+IcPedw60gzeaNvSEkL?=
 =?us-ascii?Q?BxCQc7oXTDyf/j0yjGM28gDrHpnXXDjvFBgLrZCzEYuJ/XszWutErl6moqkt?=
 =?us-ascii?Q?GvzfEl4OgwqF0/mZQYguBbBM5QcoE8sFKtfJv5xlQjtxFtlQOlTdfIAMaHbb?=
 =?us-ascii?Q?pDelwwSLONjqy3zJq4e746K+ozsktfn70fhXScD8fK1v1ldFF/+epShg2VZd?=
 =?us-ascii?Q?Yul6SvC1hy7ImZesdoIKLFp1ZE6aX/N97ebJ0AgtOXMCR9mr+NxqqJdyM1sO?=
 =?us-ascii?Q?AERe5d2CB3JKRgkFP/gTx7OqymicLFfac5qjknApQMk0oeTg5H9ZOVtolsxp?=
 =?us-ascii?Q?O52oBchIoKcGOSRHNTqv6e3A0HxW2ZT84/6C5CewPwUkyNHELaGKiS0ZDm6D?=
 =?us-ascii?Q?j8Pl3M8BpOOrW1VjBBmDX2KdPV/KIkwAokPdQLHpdLpjnuhw+28Inc/7GdXW?=
 =?us-ascii?Q?T9AUH/+bbUVof88HckjQuBPkTVCjTUSA+Mo1rCiw9oFVP4Y4PH1QcsUbYv1I?=
 =?us-ascii?Q?YcITxmLSaYz4DFz5Ke4ftSb9njxl3TmpVxObpuL+OeGEGg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xx2Qfbc6KDZ7MJo3nRNP5c3TrcjyKjot5K8feRp7bP07KrPRz41XWNmEOFqi?=
 =?us-ascii?Q?LzrXOzvfsMD8JdRQJHoUQAQx4+NSXLXB6jkFPnUGtAccLdjymxk35AgiJEmb?=
 =?us-ascii?Q?hWo14gDhxOkXyaYsWXEL4PRa7U3SbSALztMpbQ7xmqRKxpDgeow2QxiD82yJ?=
 =?us-ascii?Q?+hOXglnTOQMW4c6iwwDbRfpAIdrWmk0D8bDAYbAGCofhh3Qr2d24/uBBMvrO?=
 =?us-ascii?Q?X+mFvCGst5YypJ2i6x/hgU70r/Y5oF429IQOHIGgGY8RJAnzHjT26ch67o/g?=
 =?us-ascii?Q?r0SWIYPJVIaaDrnyS9QhY5dUI6qw8YrGSB+Ii3l40VJxfCZbvxpj+yy2V3sp?=
 =?us-ascii?Q?82UjVZywyjf0tV902Q55N8da6WecFLi+LQEADvh67uQl7ASNMCN5juKdW3Ib?=
 =?us-ascii?Q?xRDBr9n1lzPc0nY7vICDC3CD+we9iW8hjOsEPJZoPc5aZdf/z+rOhrlzlXPQ?=
 =?us-ascii?Q?qzc6DhxyFgoUoIwRzE/rkkL8YYdK3xbwiR3objZ4bbRe/EUbEMQsGt+yRNEW?=
 =?us-ascii?Q?azeONPQWWRLBRJD6APmLblDW7kYo8jZIGqpsukagUWXwuESa6NlYkzngj2Ou?=
 =?us-ascii?Q?3hAxSRIZBXluUJoCYt5CTt3O35WxC+Z0shDNupJbWfPTRBq5VUmZokDoFdpA?=
 =?us-ascii?Q?gozJlSUhXMuRaX2Q/EJb0xM2XE8p+DTfCAUsRLuzT2ckxjJqK2Uin1fvZvRv?=
 =?us-ascii?Q?D5Ap+SuoU983VRdi8Xj9gfyGuSRHxGhRQ2A0ZFvgTQpkNy3grO1lvKdAxSTE?=
 =?us-ascii?Q?PEmvm1rbVvRfFVrwCHzjW8JBBdLBKW4p7Ecm25IxfJnx3sXLPw9jSD98htXY?=
 =?us-ascii?Q?cTJaBxIoWiFzopGeqN2i5252UCRSWar5LdllniOasCq/+ahVrO20uX8ozcdl?=
 =?us-ascii?Q?XNE5QQ2XMal7r5+7C2A6Yep3ptH3KtMtLZJnDLtdV41pNx0FBnn8Lnj6nw2n?=
 =?us-ascii?Q?mxJI/SOgKR+Z6SEnUnLFSvYvFD4cgnGsCUj0N33dWscDBL1LpGx7XGOSkZA5?=
 =?us-ascii?Q?6FFRZ8DfLhgUiicwW5zv0f2nk7s8OG4tyeuSY3xftKJznZFipiJsyLRmNLLI?=
 =?us-ascii?Q?DEsZMPSZpGWvsEbPLGGV3QlNK5r7KNoHE4DzrLRnz2WtmyP0pToZkOCnczZs?=
 =?us-ascii?Q?uCLO+KMkoGXRQrjvtFRiHNRXuKiXucN0uIkxBvZQpExDCEt69GSj1JbS80e3?=
 =?us-ascii?Q?VTa0hwlZY+FXNEbSXFnBM7fVHRY6mI9ZPaKRrJER9MhJ3M14YO94Aey08PDR?=
 =?us-ascii?Q?JYIclb4jIWIwQf2RuChnOe9SErXkdhqY6+5tQqLcObLN6riHIy6Q1SKbAsnr?=
 =?us-ascii?Q?cbpggbIpbvqnc+4iT7sI0H0jfhSCYKIKU2BL7hda3XiG3nx5J0lT66qlwoVd?=
 =?us-ascii?Q?B4E1iw73Ep+HjVMAdJIijRubbdDJS0UK7wUVj505hT10+rLWzfWq9GiIZK8b?=
 =?us-ascii?Q?xHlro+L+1durfBuWpoVe+Sop3N1NwjSJ1G9R9bScqA/6OKm11h/u/OytPQbw?=
 =?us-ascii?Q?Ubn4BIUb7fvJ7RekxZOIjE8SP5wkIJsrVe9U1oyNFeqvPUdhn5hDs0HNxSSB?=
 =?us-ascii?Q?7C4TMn1udfk6wwDCM6MqEGcmVOnFGbO027kLgS74iGSulYdHjjQQXiE8iRrx?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de7d64c-d10d-42a3-4adf-08dd19599018
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 20:31:02.0746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KrrTjep8N/bAfnfpNT2OXWBVGxk6fZDlt9uLm9Ho3S4qkuXDWGy5H0TXIpwsP/rnaJIQIZzMNsW6U+gZ4CKjGAH+/ei2zs6GgPXsdeZaH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6885
X-OriginatorOrg: intel.com

Li Ming wrote:
[..]
> > There is a short term fix and a long term fix. The short term fix could
> > be to just delete the warning message, or downgrade it to dev_dbg(), for
> > now since it is more often a false positive than not. The long term fix,
> > and the logic needed to resolve false-positive reports, is to flip the
> > capability discovery until *after* it is clear that there is a
> > downstream endpoint capable of CXL.cachemem.
> > 
> > Without an endpoint there is no point in reporting that a potentially
> > CXL capable port is missing cachemem registers.
> > 
> > So, if you want to send a patch changing that warning to dev_dbg() for
> > now I would support that.
> > 
> 
> I noticed the short term solution been merged, may I know if anyone is
> working on the long term solution? If not, I can work on it.

Hi Ming,

To my knowledge nobody is working on it, so feel free to take a look.
Just note though that if this gets in someone else's critical path they
could also produce some patches. I.e. typical Linux kernel task
wrangling where the first to post a workable solution usually gets to
drive the discussion.
