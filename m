Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C335D310651
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 03:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782273070; cv=fail; b=thg2oDcZfyDU1tvyAW8j8a7UQE16XAoCe2bWZNecMLCKd1WVWi3zF+xUY0wxfXlJHZqN9dVTkkZFysRTcdDrLTpo2doxQlPNNJ4hXEQcC9DXrmdLSQpvrayjX8l4Vage5wxWcKBHqEDtoB1VdR55Cj+UTFEdBcs79OcuDsl0sf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782273070; c=relaxed/simple;
	bh=J2O/fEX6ATPGseik5bCStm2RUaGf1ebYcMmS0XS4DJ8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jOwlZ+MJxrkQnMev9KscrxyElI4/A40ImgqlFxF7C9M6p74NXHEKBMQhYk9+xoZaoSsMiO9NTZVdGpuZg43NRrHL8qYFuZWLJS50EO+OsHCPdzX/OXugznJ5XrvChV+2bOHh0S/2A/X7nkxG1N0dPlj9W9zz65VkuO4iXcwheh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=My+r2sDG; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="My+r2sDG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782273069; x=1813809069;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=J2O/fEX6ATPGseik5bCStm2RUaGf1ebYcMmS0XS4DJ8=;
  b=My+r2sDGEofm9s1X8dC8JMpQegxtUF+6imXmdFs7Fc0CVrpAwDUyErlr
   mSHlrmXyJW+w4RDeoT1xyyOZJgSXhfo+vrHrXrVbYVr2BlyDvdjLgEs7R
   lPpQqXtUWkk7YMpaSnK3dlzxQOJe0B179813rxari5WG9ewmeIwnEx0wf
   pSYbAhkwV8YWC5v4hC1hsc02/hfUEusFbq7MlEaka6mQ2nzBRyT+2FfWh
   lQdqaJvRPMaVxlEKR1j+hsx2YS/dxaQNjX70NQa4YgBrkZICQJj+Mk4Yv
   xi+6Plyy6aJ1Rc7Z93dfPCDOfo7dqR3mTb8ZEh4sJARqBCyM/1V5zPOK+
   w==;
X-CSE-ConnectionGUID: my8vfpfRS9iYQ0gL4AUntw==
X-CSE-MsgGUID: muf8dszqSY+F+sSx4rzKeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="94416267"
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="94416267"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 20:51:08 -0700
X-CSE-ConnectionGUID: IBcNALFoSaS04MJOrjTXEw==
X-CSE-MsgGUID: ePxPMKnoT9WsV4eqP7oIjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="287832071"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 20:51:05 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 20:50:57 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 23 Jun 2026 20:50:57 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.71) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 20:50:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P+UhTELYscxfFXJD65Gj23R9drN6eExnv4Lh3M0FjMN8Vbn7XzHkYIQHHTf8LYsD1/6UlsR8bISTrojKUO9hMXNRx7CacquS5U0/MkBKr3XKtjuZWA63NHlWBt687dTnfpOPuJZoIj905EPgvI8Bdm2rm1RkxjWfian9qCukjFP1a+D705fSyR4B22nuKfQG8Av2l6MR+iZxCR8EF7WO8HXQQAHeQ/pPqb2BZhaV9zbLaN71FyqH/OPODoxg9nOlaGP/EL32qnT0ClqlF1+0ZOBk0wEeP9FRwbbmVNb3k6Npfcbhlxbh5CwnCjqw4iepLd2TkX7k9GJ3kj32oaNVYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLDuK1Rq3H5YEysJno1KKSYdXwA1+DxZQBJyVPDUehM=;
 b=pGpq7mo2SgKScYO4WIyKqPsojHYyrtA+isdMWwLgjMopfXM9xfGMQFK7DX19dESkz5Ta65VngmIcGgJ69zS63/RUjXHP89c61MBd59S5AmEBPCJSu38oiVbQh1jsY+FtNR5s7XCQdNEHyoVc5ZbTS2BZOwo3KW/M8go9wKd7z4nBgTBquH4XUk+esv9RK4KneG6R3QfROUFX9SpxZIkHwzIBZ/jmZ9fFskdh9HUnTt9eEsvDkVhenz8gN4sc4Ubplh+R8ONsY9IRAhhF9DDPerG4wk7WUOt0qMzuHhOrNELZ7S+U1rJFx/GuSK9dWvM1LlGB8DoCAPjPQ13w5Rh2EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB8025.namprd11.prod.outlook.com (2603:10b6:806:2dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Wed, 24 Jun
 2026 03:50:26 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0139.009; Wed, 24 Jun 2026
 03:50:26 +0000
Date: Tue, 23 Jun 2026 20:50:18 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <hexlabsecurity@proton.me>
CC: Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] nvdimm/btt: reject an arena whose nfree is below the
 lane count
Message-ID: <ajtT-mf3-bQ8texv@aschofie-mobl2.lan>
References: <20260620-b4-disp-88b2514b-v1-1-3834e707d232@proton.me>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260620-b4-disp-88b2514b-v1-1-3834e707d232@proton.me>
X-ClientProxiedBy: SJ2P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5da::13) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB8025:EE_
X-MS-Office365-Filtering-Correlation-Id: ebbab5d2-34f2-494f-2328-08ded1a3ba2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|18002099003|22082099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info: fhRw1tteyUyuYPc9QbuoQR21P8YImd82bQssXytndZEKeMdAhbxTVjBXo8mU7xUnOcFZ+9aqxor+GMSiV7bc4wc7eFrVJPApydeDJOEEim0RMkkrn7ax61/qMeHgh5WhEh/5cOb6HZvwjxcQm0KjtSuVsTbQ8451+grVTkFUJWgITY+Af2VHrCdjQUnD6Gwv80qgUakF9E+Rc+4xq8w6TwOlAD8q4oaJcrcGAP+qad0CkTpMd/vz/wBGrznaY/O1hExkF8B39tftvFZaL/yxxHxPrqatNHgJamnXO0KEgMrib0vTQOWKPvhp3tcb6tzCQ6Vrs7Pyf/YW9PIv75Z94Zlbn0xjJUZm+6OvcgfIIquXWdgHpCsYO3G2UWtXB45yALrx2gzf8J41I6ol5r9CEgeU08H+KhiMq9XOtcyTZ3BCmMs79G5wLm6Seq0JTmfDo/P6KDKgqv7oFBrLQzuUqFJ58UB6U2DfN8YP1jDtPilUxdr/QY7L0rpQR7lb/lH9h6kL7U0mjn8zKj34fcv5Yb1DDYnXg48Y7i55CVA/LZ3TJYkEYddjrkRFTyftG70Lgu2kVlEg0DfLbmr2WStovhBQMPN9YXqlMlsXt62dr6a2A4H9g/HKHiU0ikJ7j0LWc5SWCYAamfmwoh/wykcdHpQnZVkuuAkz4V0SKsU+shc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gNkB8HoLGgSlV3ZG8al/WTq3ujaz8gFaQExEZvPXtISfjlJoRBgy1Oynwaiy?=
 =?us-ascii?Q?2PdEgvDNYQxxI2eUSv/a5fgGMWcwEJdSTi+gS/IIAlscfQIYG8YZgyJ4bsu0?=
 =?us-ascii?Q?/YmmlK6QAysk7OhIvGxydJNqlHVRf7Zq1t3syXIg7WB/qY6Wkz/NiC5/9kHZ?=
 =?us-ascii?Q?7B0Q/jtcs81D5vvEkQK5QtjymtwUelsPiuHsavoKOj8R1JI4OXoLT/Cxk3UX?=
 =?us-ascii?Q?4h1jMURl7YgCrNyNLcgp5nykxchlwtaI3REvprTbYPPDwyhZXwrSrOy/8xxf?=
 =?us-ascii?Q?rKFLYPiBbufyNoxual+h25nNMx8k+nd5GshKVASwgLhKwWb8pUwExciC+oWJ?=
 =?us-ascii?Q?XFt6Vr9P7gtG3HUaIUakGySouUksDIWmZyflyBg9uWtCjxRlltUF2R7vvVR0?=
 =?us-ascii?Q?y6w9kHsKXLYINpqu4q10dslQD6m12IRa7ZnDoIIuQGYworICvUBofB9UJWvc?=
 =?us-ascii?Q?IG5Hi1ucFu5CkkWsL4T6wVK5H5rIk9/R1FOU2BmjC+0kKUo3qq2KiXaaU3jK?=
 =?us-ascii?Q?M1gQ94MLNO8dtHzT45RBNg302MVQ1xQKtbSyKVc1jl+6vYWp9Zq2N0gezvdg?=
 =?us-ascii?Q?D5B6pYwBGJxoX15WlV9AXKS4+ejz/MxskpR9sUQdUD0bL/yZDSE1tfkBivgf?=
 =?us-ascii?Q?ZaDX5yVefk3fAF83Tx/+oTnWSKkjyTYCvy890epusiR0rQiamBol0eouSPpi?=
 =?us-ascii?Q?37VWiKmnnqxaFeUSSBPh0fO3ZmSoSVo0zSmrwBd65FG2PS0dU5gC2jhkrrs+?=
 =?us-ascii?Q?zf+1qat76NAxaG7xhwEwCMZ5bKXKbSztlKfIshJj9vZor35HDFzov/QMyHQM?=
 =?us-ascii?Q?wfochWLHp0RwaM0TK/pV4+tmRIY98mt94Od+/Rk9tgMcKIBUYPDAWu0Ydka6?=
 =?us-ascii?Q?lMrn9uVzOkvkdC0MBLq2sJ6w/BGnc6CW//H+72KdVpb4TVYZ3OCa8+mqqxih?=
 =?us-ascii?Q?f9ALEWYvrZgWpNLcTTyeSU0L1cIVedOGih4V5+qMJqqcRdAqIS86mhMPDWJB?=
 =?us-ascii?Q?pEzVLXK+zMfjnVFMsiej5Gdjq0g/Na+RMTkxN14CgNOJb/GFjjxBNuDm5w02?=
 =?us-ascii?Q?Rsrre2eEOocyMV+Qi9ue+/7V5JhLAwbUvuvXHLo0RnS8uHVLc5fokPXu6b4z?=
 =?us-ascii?Q?YPj5o20kyUVb0jZe3zB4R/OXiAnjRxuc2xaFhBMeAnRI+aKBufWgeTJeQET8?=
 =?us-ascii?Q?ojJ86TvpEI1WNzeGY3vjhvXdRhovmY9RpPajhASg0K8jTqnfis+9RVleXh3L?=
 =?us-ascii?Q?mwl8lKWXpPmSMDUqJfwzxXn0FdjCigiiGXb+eJOyVA462OMohPSHeldxh2Qi?=
 =?us-ascii?Q?p8U3osPVGncSIlrtDLBrYSPZkhS9VlQHYWkVHaXdR+hmehEdA5k2F+5O/8UK?=
 =?us-ascii?Q?wndvhtHZ1HajqrvEPzG5X349xtCFopQOyUWOXC2648kGipdUQMF2m6Af5Ipn?=
 =?us-ascii?Q?i7ZgnH26f25pJVqIR3p1rVPaBjCLgsqXkPX2Sz2fwpxPHTiozp5aHpA65Nlg?=
 =?us-ascii?Q?QzibVWELA83X2erg1CDEHEErw7/OPy5ntKMMjqoFyzz88EFbL85kan1B3+jY?=
 =?us-ascii?Q?Id4aNoMF77MQPdVyFbaLKAmm71lhVgcpjYRcwrmp4gB0cQf9jmWCih1Q9U1W?=
 =?us-ascii?Q?E0otWd+Zxe6SwH7MfyV/4KiM6JUVyKEfQ/7JATI6Zk6IjDGbm4NIKhFmvfH5?=
 =?us-ascii?Q?F/8ff0nEnBaXD1EmCnkIKNGSozV/4w/0P5S5ZsyENzRERixqw3pxIuIuU+Iq?=
 =?us-ascii?Q?LSsLTgt8FNV8Ls13yxYQ5CG4+bBFl/g=3D?=
X-Exchange-RoutingPolicyChecked: J77DLY3KnBpPqDje70yarinhatTjEBDZit33hOykI5oh7fWuDB+CeDBS6W8YjY+qm8fHEnhV066hGzrca7EI+G1cor8jhfVZZ9xVU5Eo8Vmt+llpmHF8hPoO92q7vRMBn7jPANXqlw0Bg1RQa31yvZKYxSTGG/Pa/M2RfS2Fp8WWguPB0Ed/So0WFXc4ddhKn/5lAcgQjStk5NkG/ZKQ7DktuRnMMZpP1IsYVzwl5zVf7v1YiLWblb0jkYk51e9gpNy4YR7Lpe4Pm5fZbORHkTpl9ehp8/8DmHwc4ZqY+JSV42j84cnLUHoB1+sVXUT3fKw227IfNTb2Bbid1hfDpQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbab5d2-34f2-494f-2328-08ded1a3ba2b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 03:50:26.7952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K0ztHlZqQbPMOeC2Nr+ST/sXflo/p/vKkUQ96ok9AmwzVZvws3sDzL//TyGiz8tud1xlis6Xd4dbvJjcip6BSiaSuUBr8GuRy1FXqSHf9w4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8025
X-OriginatorOrg: intel.com

On Sat, Jun 20, 2026 at 04:41:31PM -0500, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> The BTT info block's nfree field, the number of reserve free blocks, is
> read from the medium without validation.  btt_freelist_init() and
> btt_rtt_init() size the per-lane freelist[] and rtt[] arrays by nfree,
> but the I/O path indexes them by the lane from nd_region_acquire_lane(),
> which is bounded by nd_region->num_lanes (ND_MAX_LANES), not by nfree.
> A crafted or foreign arena whose nfree is below the lane count makes
> freelist[lane]/rtt[lane] run past the allocation: an out-of-bounds write.
> 
> btt.rst documents the nlanes = min(nfree, num_cpus) invariant, which the
> code does not currently honor: num_lanes is ND_MAX_LANES regardless of
> nfree.  Reject an arena whose nfree is below num_lanes at discovery,
> before the per-lane arrays are allocated, enforcing that invariant.
> 
> Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Hi Bryam,

Thanks for the patch. I reviewed and tested this against this branch,
which has a few other BTT fixups that'll land before this patch:
https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/log/?h=libnvdimm-for-next

All merged fine. It did lead me to create a testcase so I won't
ask you for that. I'll copy you when I post the test patch for review.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>

--Alison

