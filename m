Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B093233E8
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 01:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780363394; cv=fail; b=It3cUcKIyn9+mlngpsuWjImb4WI/7NbzqgW/2huJzpqHLfu2yOQNdlSMKJN+W+9xPwh4L4t+cYp+IEnQbgBa3FW600D7yLA+GZ6DD4uwSEAKZQGVjWo8+tVYQFWswjeMcgtxRrKeVhOtFN1Nv445NWsw0UKNS7EW8KMqaXQJRGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780363394; c=relaxed/simple;
	bh=Ua8Of8v+gL32RyvT7UjZmZXVMnXlczcg3im005N7xV4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k0dFwHxd5aPUtcxl+MYcQhZmFlHgyeUnQgrfw7I8zof8VqMashH9sS24dCe9J2wKDfe5v14XjnXQvReWfOmWRZAiz6f4u81q9ta+/LWKggpO/gw0zYbJMfRGAa92XbM7uMIoqSSnznl3821B37TeVVaL3+JD9YOdzB0o0ynlbfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VbyjYIMS; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VbyjYIMS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780363393; x=1811899393;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Ua8Of8v+gL32RyvT7UjZmZXVMnXlczcg3im005N7xV4=;
  b=VbyjYIMSXPfzfFZBCKbW6i1oTKEOT4yC4TL+rTE+8y2zhKVYnAC4AaTJ
   FY4Ab5/NVyf+FPzYYSQCAynUFypb3KFsh1gdKykst1NtFO4sX6UyN4MLC
   qZBi17t83+odn602SabO6c3U3T5y1BOFOH1zO6PwudDqvOG8o7iB1NAKz
   6zNAyn3USm979SP5fWBBu1nvjC6sWnaP3l+8ech1Ztjuw6uv34/e4dH9J
   at7UaLI5vVLlQXJWRfHhVTAebd1r6lAC6hEVXYreDxoBB9TYXvy+hsKgj
   n6Ww0c4At0FobdJ0JFfOdlXC54VAg8ME/aMeBEj8Jqww0NLWSJXoA/zIU
   g==;
X-CSE-ConnectionGUID: rzrAU6mZR2u6nzPX0xUYAQ==
X-CSE-MsgGUID: 8OHrkkW6R6C0MHdzvZ6Vxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="91443299"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="91443299"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 18:23:12 -0700
X-CSE-ConnectionGUID: GP2YtVZSRhW7Rpw9dgz88g==
X-CSE-MsgGUID: FOvNjtw8QFyQzWvXxT6tTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="248010907"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 18:23:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 18:23:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 1 Jun 2026 18:23:11 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.41) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 18:23:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mWGtRysNQsf9/5FVXCLcoNdPLkwvOlzD+f4J+aqJIde/8LkIuU/0UejYjBamz/2tJRyLYwoBaG679fca5GXuekihqPcS/VwjEu5GNX4r5Up4XU71RXj8/8xWkgmhCf02kZG+4yp8PoJe8ee3DkZtuzI5BEqFYYgcM1Llvwx80sDTYbobK1JfAUPPpC54cgrYDC5WBgAKMoIh9VXkPIswH4r/HmMhqj41XbwKp8PA5ag6rdKdlCeouglHH01rXdi1/WJNNW2AUWZbGKPeJjbPjXpqiF0TsTHkYJwB6AzV1GACmlX8Lry/r2Aejjo1jVfAoS8eQurmFANELvUBbF0iOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyjNnGvKODet5mjQ1P7USmOJEjM3aqntkB31Soy0s0o=;
 b=SgTZIYRMFjDREUFviUSOtNGITSUBXJgV2XfRngiNahXMKKTqQj7mee/MizeJJK4UBXqCT1paWJnzU8Rq98ZtXMLv8RwXe55KSrTr/FuDfwC5v7XOy+JcON0N+IuA6Kolzyb+RxAK7ewcHFoMdzeVn5/0fDAjMZ9z3uLlX4ptznLwJc1g3SsyXX3O6QHSrqj5vk+TYQX8rGZ/cnPfr050jNi1WzQXu91hSUAuYejZBNdyAPyiyJ3u4ro5h8N42lBpunWt008/KdPjj/S+KwUM/bDeN7+m0XSJSNdA2j2TuZO+PnoehISeMVwmHjZh136IfLnCt5fRAApd3HeB1jDR1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM4PR11MB7256.namprd11.prod.outlook.com (2603:10b6:8:10c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 01:23:09 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0071.010; Tue, 2 Jun 2026
 01:23:09 +0000
Date: Mon, 1 Jun 2026 18:23:06 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <ira.weiny@intel.com>, <djbw@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Add maintainer info for libnvdimm and DAX
Message-ID: <ah4wei7vcRP_ucL_@aschofie-mobl2.lan>
References: <20260423001003.2887295-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260423001003.2887295-1-dave.jiang@intel.com>
X-ClientProxiedBy: MW4PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:303:83::16) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM4PR11MB7256:EE_
X-MS-Office365-Filtering-Correlation-Id: c0c567c4-7cea-4c58-fb2f-08dec04581ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: 3XYafKIKcKmqI/fGeeo3+OUGf4+TlaZfQ+SwrdjAY53RwH1SSwacOAItHb7B/RYSzqjqypBah53qwUkoQi2VBSTbe3rVLw6D/5jsaU31M/iUgsnFADxGXyKhqsCKcji5ahbyH7yYwkIoHXmJNhE2asyMWp2gsvWEr9Hr2oDLXOezA9ooTPpozSNMnnOrHq6cQagKK0FaR2FPzmfHPy0qrHsXwyidXrOpbgB+QYOPHnLjTfMXrD5dLVf9ohul5SGCRNRrZ/UZL6BCx0L+vOGK2O26wFVXf3K/UCPvRwLCeU0pS/KlZK4ytl7o4pkhLyAifj1gku6JDRn3VX6pkXX2xVTg6xBXqy0j6t3jFXb4l0u32HNFY+Jf6cI4bFtw67Ox8J1l4vD/o43B42zGtqERwGY270izk5lRivuLVcYuqydz0st0XSBACdqd2lQ4XchvMsCAu+vIV0nnnHcaPJLcSjHktSdgD7k/OacE4COwMMeqqEYFrNuMOQNA/VlEp5UopDM1nRnSquibw7sJJyqbXQ9M00H/Ijo1x9IWNmfOUAW/sv+C+KbmivR+TgSHD/b2UxY8rjCSfH+3iubU2MHu+MilHvUyv3umn4pypSsjsjd6JSUKx/J3UZofe+n6N8Se4vbyUSTQ1E34DaDk/miExzfe86SQYNQiSsU1LiZU2E7RLOvv0R6hGUTvxqzRaA3keunlZ+iYbgHidf/0irDfUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uRzce0hlZX0G2AD51oP/MVkytCiSUAG3WJhQMSQZ+I7WSkoV3LBZ5pLCZCfJ?=
 =?us-ascii?Q?cp4PgFtKrvMBG1P4kf2Ybcl0hNkno3EwbRJJNKFMqBmY0ZhE0ZOW8mr2pi/Z?=
 =?us-ascii?Q?3om/nNiC3VEBlBANHzhfhZ+OGSUqykYbLVCgykEWpAp3TJn+Nj1QzxDv0LaF?=
 =?us-ascii?Q?h/BMllGONgs1KCSoRQ36PoFW5FMuVJOXr6X2t7Pv3w7fzuRGRR3DoWxWnpN5?=
 =?us-ascii?Q?K5FArtwiGwpafLo92q+Erfw6XtOhVa/JmuvYfoM4t19hpdyVhf/q7M/zacTE?=
 =?us-ascii?Q?7h/lg/uRRbk5YK+l8EBhSgW2X+ASUE4bCb30xBmuvW3zT5HdZQTfVN+7A60p?=
 =?us-ascii?Q?00lfpNrbghwjzluY5DBnZAbSgFf/2ReS5cQkisUnKuCIQPX+Cs8Vi/iyBvci?=
 =?us-ascii?Q?D+dw6rpMJJVEeJdbWu+i34iffqRvFuawZD4k/mCLEs3MHheVH5uG2fwn6M+U?=
 =?us-ascii?Q?ReWJVwd1zBpPbEQgcn8XclOXvX/VOC6E9CyoKkFPLNJ0ADLG0VSRyL6pIElk?=
 =?us-ascii?Q?RhKOsF7FbsiXSxGknpZ7pl/3s/+zSWTw64rsAzCwooz8d6Ai82zCH+dpHibN?=
 =?us-ascii?Q?hNDvTlwwO/axvc6536AJDAdFWZMn6ilEQlgsBsU6d9fxLW2BQBa9H4fV8G42?=
 =?us-ascii?Q?brp9EVKHhjXhKDqbRSrrNdn9/9SukodP0JddRXf0Cjc2simjFwj/GITy1HSN?=
 =?us-ascii?Q?29wtpT02dkYo0GWxSYzTz3eS+ub1cOsbVs/sXhaH7Uv1YhqX0srQ11gKXcaN?=
 =?us-ascii?Q?ruHY7qputppRhtYrxuDxbo7oh5E6INpVvU2IPRGtLewIBlFZJYyppBRwVT5T?=
 =?us-ascii?Q?MgWM6cCrQKiwPNGE20YUG4ZyiFaDPvq0OlENUDCSgPC/Hx41CnfHg/AVXmGg?=
 =?us-ascii?Q?ARGfDC0NRQKxNoWq8ppUpfT47GKT/fC8QbNsEbyZ7mZAS4GaSr+m6xJTlWY/?=
 =?us-ascii?Q?Y43234NaAKDjMPljxHCokiaVB2cU5AKcK8fBSNuSpy42jALu4NrMLxUWUwsc?=
 =?us-ascii?Q?2hqrZ9TzNBkR7JZhWbYAwFgBdf+HrSts02vF/IjNqs3jqDZdqWthZ7j2SBmV?=
 =?us-ascii?Q?3UfmIXCqJvn/PvGKZO+5zwxh370qMLMTyXdpEq84MaMjabE6OEY1LmXOuOUN?=
 =?us-ascii?Q?Z9449nGw9+3kHBdvSw8UdDli9buJnvMSV88tdx65PRXjt/48HAXLArij9izU?=
 =?us-ascii?Q?Spdf8DLKfNMzkDgO5B2lPdl1/dB7FsT+qKvCp286Sm47ZRdLwKz54i9cltjB?=
 =?us-ascii?Q?xZh2gIYL/2suYawU4xQo7GUWF0DqZyXiotoq92WABGRLVc0cqYZoGaXbjEXl?=
 =?us-ascii?Q?pEFTG7Pv9dJNRm7QWbOGY2PJX1SnXA7KRvMR1r8wK92jhe0GZ6mvs4RISE8+?=
 =?us-ascii?Q?1HLn/mDMV/A6okQAwnCl5riz2a4I1HlLTxdI/wtBeXtgyV8n8EY7KUvjhcUM?=
 =?us-ascii?Q?+o8u8+epMt1dquyEFJuXM+33ogHFqUaN/rpZmqI/LY8eWlQM4ZYOP2jvBOLK?=
 =?us-ascii?Q?YilZMZvpaxzAGtFEZQ2/Sl7W4jbZCWSmV1FQ4em1K1t7eHMzv7O55lOs3aI7?=
 =?us-ascii?Q?oR2i48KnXbcN2HMt91vzFTokaxX8DXTxJt5XQZwaynSSgLgIngSx/WhujW1U?=
 =?us-ascii?Q?ga7Si3qoyBYBHzFvXlydjfkHWkk1YGqi+/k9Q6EoRH1ZEHSJ84PKefLSoW2T?=
 =?us-ascii?Q?RLqVsNuBBCZuH16tixTcsEt4iEXqKTLBL7FMVcsmCA/In+9zI0aa/5HHuLVc?=
 =?us-ascii?Q?sWoodABzjQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: WQm4w1hlzB20ErI0sf8Wsmmi8+M4C25adKhS6cxP20P3LtoECOA5XElQZIQGXhJUWO5tklZRmP7sYn6iEYX2QgvmZ0ztsXH8YfEv+iPedTdj1PnpJDKSGkhPOYq3rWMMAN2dSJtmYsIht3k6HTYhrjzazRgFduWvNkXI/pp9CCBA+v+GFu8AjVet6U+TykG57DzpWBIGsNrEoFV2609pa01+ByRYNcDUiflowXMXMDyYrfLS+fezBohhEr+dareatmp8sKGjIbaMjnTV7VkA4KpZNb/Hggn4FlhvxuJnWERWSJnVKmhbwNzf1yqMeMM+pMix94Q/S6vwC+KiNcwUFw==
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c567c4-7cea-4c58-fb2f-08dec04581ac
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:23:09.6885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePjsnP53tBBgmQv7Eo0s736uVqA+dVeYKX21vVad1iv7FvuVVLInA3nEneNDsgpox12DSDKb/cBm1upSrm8jg6lL0u016prlk8DD4qbJ30w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7256
X-OriginatorOrg: intel.com

On Wed, Apr 22, 2026 at 05:10:03PM -0700, Dave Jiang wrote:
> Add Alison Schofield to libnvdimm and DAX maintainer.
> 
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Ira Ira Weiny <ira.weiny@intel.com>
> Cc: Dan Williams <djbw@kernel.org>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Applied to nvdimm/nvdimm.git (libnvdimm-for-next)
https://git.kernel.org/nvdimm/nvdimm/c/e3fc08f4ab66

