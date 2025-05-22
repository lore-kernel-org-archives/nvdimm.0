Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62622A50
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 00:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747873149; cv=fail; b=hJT/eR1463rF44fRe0djoV7vIfoeLoLDiE4NRGLZCRWwlUGe0eWOTBnfEJFm6lB4jvUVOvsKzssLn1HE6LmiiwzJtZ+AiZ0XYq4RViOc1Jw2k7xUNaGCYjm8KbmUJwcAGc5TTOXR0cfcnMaBA/Y3Gmi6ZY0IvkdlB5qzz0LRf/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747873149; c=relaxed/simple;
	bh=UPdahB6RwqIZn34LypEv/B97jdLrsba/7cLe6uYCzto=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aEV9tzlaG8UXZ3CSwiUsFDihVll4GTWOE5bX0QKQHJzTkgH3Gv7zT/rqGGFY+YBXvXcQVFcowfgE03Ct0MmjsdRmQmRYpq8XCfDYw3n8wH9hvs34X5tvOXQpbi891ON2LnDFkAfDZ+IcDa7lP1ejZZ8kZIJ/Oo65iU+5bWnzsIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PsexVMUa; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PsexVMUa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747873147; x=1779409147;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UPdahB6RwqIZn34LypEv/B97jdLrsba/7cLe6uYCzto=;
  b=PsexVMUakFVZMl+RmnrY08Ledr5hl+raU76XyfjTb5IjTHgqg/foutDL
   RS2Q0Df2pBmBP9m2+NX0JX/AfVAupyL86YpkpSzA3UXh+3sa6hXU9wyp5
   k9R6+9lRHUwnyYfPuDBJvAj8OXYNC0Nhb3wU4ycDWy8KaEWEgdnLyDMo3
   risD4HSgDuK6LxN2KgNFFkR/wF+F6gqhZNUyHZWLs5i4LBo+xo/h23JIW
   N8c6XtpeHnmCZDn/5Qq7MhgXVWnZp1zutc5NoRaz9EofWlyKUGJ8IZR4V
   zbvOe/iBHAQyu0uMbnq8Ks9UucFJPnIELhGw4DFAVkOn5i/vokJ8faiSi
   Q==;
X-CSE-ConnectionGUID: 4RccI1bpSsC2MU+2o9AGCQ==
X-CSE-MsgGUID: dd3B6QgVQQKfrifaK+iBMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="49134738"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="49134738"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 17:19:07 -0700
X-CSE-ConnectionGUID: xt/9TpdiSrW37EM+/8Rlwg==
X-CSE-MsgGUID: n3mFKom+SimFmhXlKynRZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141381249"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 17:19:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 17:19:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 17:19:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 17:19:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jwiQK9B2qmINACffpF8Z9vScB0nNSFQ2fWmlnwrvCMO/Owd8cKAtoH6Nlo1bM0wRkWJfJ/HLjCmNeNy2C61oUq9bf+s1MH+20nPDWpKSZPF6eIp3znAWcC0AyTAb6wPOQt9hnrXlGnyVLSrcQJH65WYoQe9ZZRuzkc2xbwd4oNqq6afeWXjxt89xOhPYxzKL3ZhCQn7dDjClDl5r+FtgkvFyG/DDeJGKdZvVt7pn/hV27f9qzEXzuHJuwwCcGZ/enLraZn7wsojrrNqkIsyX0Lkvwul6644j5ZOouhNwRn3sHj3gbCTBL/KIbmZtvEBBlkJLdIgpdywIouSbEDUnaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEGxqd4vGHVD7b2SC36BXW+oR20eiUDVEAdOMAH+Pvs=;
 b=mfgRkyxc7zxWTicw/c9wbVPVRWu0D7q6YQ2FGIJrbOhmIe4/fCQU0/ZwEazQ+19qIyK7pbDeDYiulQR99RHXHSM5owSlx3wIuxImnpsETEyOCkFJTLy8UHsORWfyLwpTZaEMhfD9C3pQGnvGjK3ZTY7vzgRBFysoqzrThJ3JPiFWZLUCUPhLvbFYy1FtuFoblUfJFNvI64Ei1d6oKg3z0QN07yWIdrumB6mah7c2h765PIFWIjObhRqTsrmNiJdyA9PROa8KQzyejvgImZ8XqYwTmamxVAkDa5cNuymdFZ/6hIjUCY1O0SdReXherM39r8wKsYSizH18qnp32CVzmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by CYXPR11MB8689.namprd11.prod.outlook.com (2603:10b6:930:d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Thu, 22 May
 2025 00:18:31 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 00:18:31 +0000
Date: Wed, 21 May 2025 17:18:28 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH v7 4/4] cxl/test: Add test for cxl features device
Message-ID: <aC5tVGaqOTfxy2o_@aschofie-mobl2.lan>
References: <20250519200056.3901498-1-dave.jiang@intel.com>
 <20250519200056.3901498-5-dave.jiang@intel.com>
 <aCzXG9IwG6Xr-ssY@aschofie-mobl2.lan>
 <592a6a36-8e3e-4808-94a4-2070335f701a@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <592a6a36-8e3e-4808-94a4-2070335f701a@intel.com>
X-ClientProxiedBy: SJ2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:a03:505::17) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|CYXPR11MB8689:EE_
X-MS-Office365-Filtering-Correlation-Id: bc6157df-30ca-49da-4108-08dd98c62ea5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?49pXxS88D29vMe41rVWq149GWT5btqI/nevwnQeyEW/UgH0TBZyKNxltrB03?=
 =?us-ascii?Q?H7cKO6ShBL0RTyHHZ5Sjfse0Mkwwm+3m2Fv7R48asPlRKytUJgxjRQ1ypnhH?=
 =?us-ascii?Q?LcltuKzbTBiCSYHIRUUk8zPpEo9/un8UtBDWqLjUuPlZUgQZR31/P4jZ056M?=
 =?us-ascii?Q?JzNIYIMdoco6oJ8pAljkus79VyMnKgXHyiZNXW36+T/jsNx6q4XFjb7N9ACm?=
 =?us-ascii?Q?UKJHhcNuQ4Fd7sw6S7BnlT/S/ZC3Jjvsc6VHdAQGQqbiRFGTTj5ufhcDfyV5?=
 =?us-ascii?Q?lKpWhmQElN+uA7VMqMDkUpEINB3SzdCKCwLHbX60ZiZrfL9jZ2BXv3OIRQ2C?=
 =?us-ascii?Q?5ZAtp8dGoyL20MI9FyaTibsNbhMiZl5QoPojtKzWz4KzeN6aDm8UReJTCKGn?=
 =?us-ascii?Q?USZWY69RZVqzmtHY3t+ckinak14NF6AEfo3v77rO6zoQh8Fipub5v1W0I3HF?=
 =?us-ascii?Q?Ub455SS/DkJjbIg2Wo0+751B/nnNpmZ7ARUJgAeLhICILaEqwcGxZDfGGOTI?=
 =?us-ascii?Q?6Zllu5TLw+dD/C/wKunr+YfeSmNrkehhRqU//5VRI5tElMtfrYBe7yVyveid?=
 =?us-ascii?Q?OB2HWnSK84myVUmUtMx5ZfLCJlmD3LRn8BQgItSxv4d9wFbKmzSH8OVTI6tI?=
 =?us-ascii?Q?nUG/tq6YQpq9of8TdpkTAnyQBQLUmZFp9kCN6y3vshY7rXbLvag7t6p9f/zQ?=
 =?us-ascii?Q?2qnRepV7pBhrAOF5ZrggIcs5uv9agwH2llt1FJwq0+NhUyeOOktXYvWy+nPx?=
 =?us-ascii?Q?B1parCMMTVUcSsl9nDdmaL1HNy8oskHe60Pxzr/s6zSiZbXgQHiq/eUGn8d2?=
 =?us-ascii?Q?RRb3tvSs8KVzpPogzXA0i47PJRtiypWQHTew0O130NzQfI9DEcx2gKTT4xZ/?=
 =?us-ascii?Q?nV0iIrpVk0IOfIRc4x1GJOkxo1xMajMDq9odFuJR9KVllILKfdp7NGCRXnGo?=
 =?us-ascii?Q?O2cY+0qPnshvG5PMFUwRnFGHoogSJJyBvAaNKDZA1wUXofAion9bF7nwzW/e?=
 =?us-ascii?Q?MIUfG7vu8bug1IEYOSx81pWsjs3kuJNziEyYlQp0aid02B0V/HW32NNm5w9E?=
 =?us-ascii?Q?/Zhk5XcOKztyg7HN68S7NOLuNkmTQyc+czjqxIZh907PCT7BhJKjRXc2yvMe?=
 =?us-ascii?Q?QMLauXgsIIu6DEXRxlXVnmHgYZBMswMyn8Xg3hkGqH3EeIyCyYSgINIOjABa?=
 =?us-ascii?Q?TpLW6QCjsXa/d0GzbfL1C5xo0fWcze/Ar2Xyor32LHxQ18EnpsKBjehu5Q7h?=
 =?us-ascii?Q?ofyli665c67BNZbXvsaqukZd+37f7J+REeUwklFyN2SwAsx1BnsVOLl/gmpX?=
 =?us-ascii?Q?U0mDM4q3yX5gT/AKj6U6gd03EZIu/SjBO7Ik+Tp2ieouQWvYIve8U0PbLGiF?=
 =?us-ascii?Q?Fc/qu9iGN0gTwCIy68GNVIxJpKYyE6e8/8i/TfChrpeRgMMdnHxrkfdBfAg8?=
 =?us-ascii?Q?vA8KOCRZo/Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F1eQzagPl+0JvQKCUDtDOoO828SY7k0YA2UzFMU0o44y9vgg+qEd90Sc+mdO?=
 =?us-ascii?Q?RGqeSvdF+FdAyOvpJVt6dBehbXe5pOKesdxpa+IvS143lKPPafgeFaq9TiWj?=
 =?us-ascii?Q?bHdW6f0evBI6O1UpQIx66Z9MkF1ePivHiiU67rom7PWL30ntBjF3z0gTgiv8?=
 =?us-ascii?Q?K9jjY2EhTyBaWGknK5zXPhMWgKxEsiUn2QSjU7Ey5HnOOPKwyAPzodZXWwQn?=
 =?us-ascii?Q?8vmSWWtve2n5IWJ2rYvQbMPX1bIBZYaSjIDOQS+t4VUCF47LqD0kdRNWIw1u?=
 =?us-ascii?Q?JKE7A/ytjASPkfHMEo2ue5cM0CaaNmcKiKtyhsqXj+N9NPl5iQh9F0LOAkqI?=
 =?us-ascii?Q?gGti7qqWStVz0Ezh9KyH5SkJ6hRwpEp+GAgHMiLj8oFxXqhPmWnpXoLQJigg?=
 =?us-ascii?Q?1DYrARBVVycckHZ1UzTFa/2HOMlncef3nk4MKx9t2uXx64XC9CwcfshYKMHT?=
 =?us-ascii?Q?bsVO85MEKuDtbfVjeZIa5FdwX0d0S3HU91scN8uhLY52awrNLU460nWTk4NW?=
 =?us-ascii?Q?jJEZ1VU5xZU7HsJyQJwJAh+O6+rMuqQ8lcveKvLO43oaetXe8Flhv2AgRb5n?=
 =?us-ascii?Q?gOTdWtRaMQlLQBd0s+LnW7PiePJ+ixMRjV10rWBmMaC0QMu9tFisSjcr/IAa?=
 =?us-ascii?Q?qjgyGPJ1T+uwBP9Dc5wvsRjjpoHGdC6k2IkLKxxasmjWrX1dYNsKb1ELVWq2?=
 =?us-ascii?Q?6syi/bxdIDBfPiXB4pR3kZ/wqJPCCkaWfFze+4MPMUdsJ8TNHEhpNoSYvXw/?=
 =?us-ascii?Q?da8a49FvtQAJHAbZsGNqlPhnUO3SZubQ8RLLaV/IW1P0b7tJcRoEuBXBXOMh?=
 =?us-ascii?Q?7LPg4cXrdPVntsAh6KyvCL5x5IiUZUWShopktaTssoUT9YFmxbQKJqVR6KS0?=
 =?us-ascii?Q?g/CKg7hrh+QcRtC+hDadcKqKoS1deLl9g57cMR4hO3w+DZoZ+ZMA861a4HAZ?=
 =?us-ascii?Q?M8nRc8oJPRruGZXkHJXr4KrIBHp1T0B6zuQxZr1SzfTOTaZSVcaKvl3i7bBg?=
 =?us-ascii?Q?++FWoeGExG8jwZgE/UxasBUMGS1okjjhC8n5sZpRWGUHGZhyWDnHtrZTh2tL?=
 =?us-ascii?Q?GD/vpG2wNJrqujU/XAxnQtfzy3dWrkpU/Y0G9adPt3o+5v3oXsoU7T+s60R7?=
 =?us-ascii?Q?ONK/ROgnH7rXntKKctayY+bCffuU48YdJ3BIgzQ7CuKZ2LA+bbX/T9uQQyxg?=
 =?us-ascii?Q?eli7+A//gmOWJHVvcI00d43CMGTUrbljVtuHmcKNP7wZHTDjFzNnC4TRTR/f?=
 =?us-ascii?Q?QeN0qWH45YlokJPbKuRz1/jw2Hi3Hs2iLXRruRXLvn7AE2wrQQdfYkORuopA?=
 =?us-ascii?Q?MfnVz87pLKxyiztrvvHg59rcBGJLM9SGfd1fzR0RTZiUZ40AMlngV4RjacMv?=
 =?us-ascii?Q?42dK8ScK8y46v69iq649M+Vm9SptUCH7YKbxS+pVVyNUdMrwQ5VKb5xXdpYL?=
 =?us-ascii?Q?Zh1fozvGEMRiHX4QAz3NF+GL3Vo5VbUX9ypNUHTzQo/mlqfBOuhagyX1nq7L?=
 =?us-ascii?Q?UQZrkLwZrq5ZxyS1M5X15NC2G3o6fpBgSVM0AEqz4Thnl0jbJ+Yir9bntgl4?=
 =?us-ascii?Q?y4R7zLYkLssKOrbEMa1iySoHfRPqMQ9s4MIAIY7XskoRCHyjRiTdqaPXELXz?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6157df-30ca-49da-4108-08dd98c62ea5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 00:18:31.3703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FaqibeVoNLkiW/SLDKsy9FHNVtKnJGvLV9AE4QqfJf8cvfsgJiW+jSbmAW8PPFA4DmO1i0pfMQAWwT7kT6bDxC7hBImG/eoBb9DzN6LOO1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8689
X-OriginatorOrg: intel.com

On Wed, May 21, 2025 at 04:22:19PM -0700, Dave Jiang wrote:
> 
> 
> On 5/20/25 12:25 PM, Alison Schofield wrote:
> > On Mon, May 19, 2025 at 01:00:54PM -0700, Dave Jiang wrote:
> >> Add a unit test to verify the features ioctl commands. Test support added
> >> for locating a features device, retrieve and verify the supported features
> >> commands, retrieve specific feature command data, retrieve test feature
> >> data, and write and verify test feature data.
> >>
> >> Acked-by: Dan Williams <dan.j.williams@intel.com>
> >> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >> ---
> >>  cxl/fwctl/cxl.h      |   2 +-
> >>  test/cxl-features.sh |  31 +++
> >>  test/fwctl.c         | 439 +++++++++++++++++++++++++++++++++++++++++++
> >>  test/meson.build     |  19 ++
> >>  4 files changed, 490 insertions(+), 1 deletion(-)
> >>  create mode 100755 test/cxl-features.sh
> >>  create mode 100644 test/fwctl.c
> >>
> >> diff --git a/cxl/fwctl/cxl.h b/cxl/fwctl/cxl.h
> >> index 43f522f0cdcd..c560b2a1181d 100644
> >> --- a/cxl/fwctl/cxl.h
> >> +++ b/cxl/fwctl/cxl.h
> >> @@ -9,7 +9,7 @@
> >>  
> >>  #include <linux/types.h>
> >>  #include <linux/stddef.h>
> >> -#include <cxl/features.h>
> >> +#include "features.h"
> >>  
> >>  /**
> >>   * struct fwctl_rpc_cxl - ioctl(FWCTL_RPC) input for CXL
> >> diff --git a/test/cxl-features.sh b/test/cxl-features.sh
> >> new file mode 100755
> >> index 000000000000..3498fa08be53
> >> --- /dev/null
> >> +++ b/test/cxl-features.sh
> >> @@ -0,0 +1,31 @@
> >> +#!/bin/bash -Ex
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (C) 2025 Intel Corporation. All rights reserved.
> >> +
> >> +rc=77
> >> +# 237 is -ENODEV
> >> +ERR_NODEV=237
> >> +
> >> +. $(dirname $0)/common
> >> +FEATURES="$TEST_PATH"/fwctl
> >> +
> >> +trap 'err $LINENO' ERR
> >> +
> >> +modprobe cxl_test
> >> +
> >> +test -x "$FEATURES" || do_skip "no CXL Features Contrl"
> > 
> > Seems like a comment to help understand skip - 
> > 
> > # fwctl test is omitted when ndctl is built with -Dfwctl=disabled
> > # or the kernel is built without CONFIG_CXL_FEATURES enabled.
> > 
> > Now the above is assuming the .sh got in the test list and is 
> > not left out completely with -Dfwctl=disabled. Going to look.
> 
> It's excluded. So comment probably not needed. We skip if there's no fwctl device later, which points to no kernel config enabled.

OK. I've come around to agree on this one. My concern was folks running
the unit test foolishly thinking they had tested everything while this
test was silently skipped. But that's an unlikely because doing the
-Dfwctl=disable is a pretty intentional act. Also folks trying to run
complete suites are aware of the enables/disables because they use
them to turn on the destructive tests. I'll be quiet on this one now.

Thanks!

> 
> DJ
> 
> > 
> > 
> >> +# disable trap
> >> +trap - $(compgen -A signal)
> >> +"$FEATURES"
> >> +rc=$?
> >> +
> >> +echo "error: $rc"
> >> +if [ "$rc" -eq "$ERR_NODEV" ]; then
> >> +	do_skip "no CXL FWCTL char dev"
> >> +elif [ "$rc" -ne 0 ]; then
> >> +	echo "fail: $LINENO" && exit 1
> >> +fi
> >> +
> >> +trap 'err $LINENO' ERR
> >> +
> >> +_cxl_cleanup
> >> diff --git a/test/fwctl.c b/test/fwctl.c
> >> new file mode 100644
> >> index 000000000000..7a780e718872
> >> --- /dev/null
> >> +++ b/test/fwctl.c
> >> @@ -0,0 +1,439 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +// Copyright (C) 2024-2025 Intel Corporation. All rights reserved.
> >> +#include <errno.h>
> >> +#include <fcntl.h>
> >> +#include <stdio.h>
> >> +#include <endian.h>
> >> +#include <stdint.h>
> >> +#include <stdlib.h>
> >> +#include <syslog.h>
> >> +#include <string.h>
> >> +#include <unistd.h>
> >> +#include <sys/ioctl.h>
> >> +#include <cxl/libcxl.h>
> >> +#include <linux/uuid.h>
> >> +#include <uuid/uuid.h>
> >> +#include <util/bitmap.h>
> >> +#include <cxl/fwctl/features.h>
> >> +#include <cxl/fwctl/fwctl.h>
> >> +#include <cxl/fwctl/cxl.h>
> >> +
> >> +static const char provider[] = "cxl_test";
> >> +
> >> +UUID_DEFINE(test_uuid,
> >> +	    0xff, 0xff, 0xff, 0xff,
> >> +	    0xff, 0xff,
> >> +	    0xff, 0xff,
> >> +	    0xff, 0xff,
> >> +	    0xff, 0xff, 0xff, 0xff, 0xff, 0xff
> >> +);
> >> +
> >> +#define CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES	0x0500
> >> +#define CXL_MBOX_OPCODE_GET_FEATURE		0x0501
> >> +#define CXL_MBOX_OPCODE_SET_FEATURE		0x0502
> >> +
> >> +#define GET_FEAT_SIZE	4
> >> +#define SET_FEAT_SIZE	4
> >> +#define EFFECTS_MASK	(BIT(0) | BIT(9))
> >> +
> >> +#define MAX_TEST_FEATURES	1
> >> +#define DEFAULT_TEST_DATA	0xdeadbeef
> >> +#define DEFAULT_TEST_DATA2	0xabcdabcd
> >> +
> >> +struct test_feature {
> >> +	uuid_t uuid;
> >> +	size_t get_size;
> >> +	size_t set_size;
> >> +};
> >> +
> >> +static int send_command(int fd, struct fwctl_rpc *rpc, struct fwctl_rpc_cxl_out *out)
> >> +{
> >> +	if (ioctl(fd, FWCTL_RPC, rpc) == -1) {
> >> +		fprintf(stderr, "RPC ioctl error: %s\n", strerror(errno));
> >> +		return -errno;
> >> +	}
> >> +
> >> +	if (out->retval) {
> >> +		fprintf(stderr, "operation returned failure: %d\n", out->retval);
> >> +		return -ENXIO;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int get_scope(u16 opcode)
> >> +{
> >> +	switch (opcode) {
> >> +	case CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES:
> >> +	case CXL_MBOX_OPCODE_GET_FEATURE:
> >> +		return FWCTL_RPC_CONFIGURATION;
> >> +	case CXL_MBOX_OPCODE_SET_FEATURE:
> >> +		return FWCTL_RPC_DEBUG_WRITE_FULL;
> >> +	default:
> >> +		return -EINVAL;
> >> +	}
> >> +}
> >> +
> >> +static size_t hw_op_size(u16 opcode)
> >> +{
> >> +	switch (opcode) {
> >> +	case CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES:
> >> +		return sizeof(struct cxl_mbox_get_sup_feats_in);
> >> +	case CXL_MBOX_OPCODE_GET_FEATURE:
> >> +		return sizeof(struct cxl_mbox_get_feat_in);
> >> +	case CXL_MBOX_OPCODE_SET_FEATURE:
> >> +		return sizeof(struct cxl_mbox_set_feat_in) + sizeof(u32);
> >> +	default:
> >> +		return SIZE_MAX;
> >> +	}
> >> +}
> >> +
> >> +static void free_rpc(struct fwctl_rpc *rpc)
> >> +{
> >> +	void *in, *out;
> >> +
> >> +	in = (void *)rpc->in;
> >> +	out = (void *)rpc->out;
> >> +	free(in);
> >> +	free(out);
> >> +	free(rpc);
> >> +}
> >> +
> >> +static void *zmalloc_aligned(size_t align, size_t size)
> >> +{
> >> +	void *ptr;
> >> +	int rc;
> >> +
> >> +	rc = posix_memalign((void **)&ptr, align, size);
> >> +	if (rc)
> >> +		return NULL;
> >> +	memset(ptr, 0, size);
> >> +
> >> +	return ptr;
> >> +}
> >> +
> >> +static struct fwctl_rpc *get_prepped_command(size_t in_size, size_t out_size,
> >> +					     u16 opcode)
> >> +{
> >> +	struct fwctl_rpc_cxl_out *out;
> >> +	struct fwctl_rpc_cxl *in;
> >> +	struct fwctl_rpc *rpc;
> >> +	size_t op_size;
> >> +	int scope;
> >> +
> >> +	rpc = zmalloc_aligned(16, sizeof(*rpc));
> >> +	if (!rpc)
> >> +		return NULL;
> >> +
> >> +	in = zmalloc_aligned(16, in_size);
> >> +	if (!in)
> >> +		goto free_rpc;
> >> +
> >> +	out = zmalloc_aligned(16, out_size);
> >> +	if (!out)
> >> +		goto free_in;
> >> +
> >> +	in->opcode = opcode;
> >> +
> >> +	op_size = hw_op_size(opcode);
> >> +	if (op_size == SIZE_MAX)
> >> +		goto free_in;
> >> +
> >> +	in->op_size = op_size;
> >> +
> >> +	rpc->size = sizeof(*rpc);
> >> +	scope = get_scope(opcode);
> >> +	if (scope < 0)
> >> +		goto free_all;
> >> +
> >> +	rpc->scope = scope;
> >> +
> >> +	rpc->in_len = in_size;
> >> +	rpc->out_len = out_size;
> >> +	rpc->in = (uint64_t)(uint64_t *)in;
> >> +	rpc->out = (uint64_t)(uint64_t *)out;
> >> +
> >> +	return rpc;
> >> +
> >> +free_all:
> >> +	free(out);
> >> +free_in:
> >> +	free(in);
> >> +free_rpc:
> >> +	free(rpc);
> >> +	return NULL;
> >> +}
> >> +
> >> +static int cxl_fwctl_rpc_get_test_feature(int fd, struct test_feature *feat_ctx,
> >> +					  const uint32_t expected_data)
> >> +{
> >> +	struct cxl_mbox_get_feat_in *feat_in;
> >> +	struct fwctl_rpc_cxl_out *out;
> >> +	size_t out_size, in_size;
> >> +	struct fwctl_rpc_cxl *in;
> >> +	struct fwctl_rpc *rpc;
> >> +	uint32_t val;
> >> +	void *data;
> >> +	int rc;
> >> +
> >> +	in_size = sizeof(*in) + sizeof(*feat_in);
> >> +	out_size = sizeof(*out) + feat_ctx->get_size;
> >> +
> >> +	rpc = get_prepped_command(in_size, out_size,
> >> +				  CXL_MBOX_OPCODE_GET_FEATURE);
> >> +	if (!rpc)
> >> +		return -ENXIO;
> >> +
> >> +	in = (struct fwctl_rpc_cxl *)rpc->in;
> >> +	out = (struct fwctl_rpc_cxl_out *)rpc->out;
> >> +
> >> +	feat_in = &in->get_feat_in;
> >> +	uuid_copy(feat_in->uuid, feat_ctx->uuid);
> >> +	feat_in->count = feat_ctx->get_size;
> >> +
> >> +	rc = send_command(fd, rpc, out);
> >> +	if (rc)
> >> +		goto out;
> >> +
> >> +	data = out->payload;
> >> +	val = le32toh(*(__le32 *)data);
> >> +	if (memcmp(&val, &expected_data, sizeof(val)) != 0) {
> >> +		rc = -ENXIO;
> >> +		goto out;
> >> +	}
> >> +
> >> +out:
> >> +	free_rpc(rpc);
> >> +	return rc;
> >> +}
> >> +
> >> +static int cxl_fwctl_rpc_set_test_feature(int fd, struct test_feature *feat_ctx)
> >> +{
> >> +	struct cxl_mbox_set_feat_in *feat_in;
> >> +	struct fwctl_rpc_cxl_out *out;
> >> +	size_t in_size, out_size;
> >> +	struct fwctl_rpc_cxl *in;
> >> +	struct fwctl_rpc *rpc;
> >> +	uint32_t val;
> >> +	void *data;
> >> +	int rc;
> >> +
> >> +	in_size = sizeof(*in) + sizeof(*feat_in) + sizeof(val);
> >> +	out_size = sizeof(*out) + sizeof(val);
> >> +	rpc = get_prepped_command(in_size, out_size,
> >> +				  CXL_MBOX_OPCODE_SET_FEATURE);
> >> +	if (!rpc)
> >> +		return -ENXIO;
> >> +
> >> +	in = (struct fwctl_rpc_cxl *)rpc->in;
> >> +	out = (struct fwctl_rpc_cxl_out *)rpc->out;
> >> +	feat_in = &in->set_feat_in;
> >> +	uuid_copy(feat_in->uuid, feat_ctx->uuid);
> >> +	data = feat_in->feat_data;
> >> +	val = DEFAULT_TEST_DATA2;
> >> +	*(uint32_t *)data = htole32(val);
> >> +	feat_in->flags = CXL_SET_FEAT_FLAG_FULL_DATA_TRANSFER;
> >> +
> >> +	rc = send_command(fd, rpc, out);
> >> +	if (rc)
> >> +		goto out;
> >> +
> >> +	rc = cxl_fwctl_rpc_get_test_feature(fd, feat_ctx, DEFAULT_TEST_DATA2);
> >> +	if (rc) {
> >> +		fprintf(stderr, "Failed ioctl to get feature verify: %d\n", rc);
> >> +		goto out;
> >> +	}
> >> +
> >> +out:
> >> +	free_rpc(rpc);
> >> +	return rc;
> >> +}
> >> +
> >> +static int cxl_fwctl_rpc_get_supported_features(int fd, struct test_feature *feat_ctx)
> >> +{
> >> +	struct cxl_mbox_get_sup_feats_out *feat_out;
> >> +	struct cxl_mbox_get_sup_feats_in *feat_in;
> >> +	struct fwctl_rpc_cxl_out *out;
> >> +	struct cxl_feat_entry *entry;
> >> +	size_t out_size, in_size;
> >> +	struct fwctl_rpc_cxl *in;
> >> +	struct fwctl_rpc *rpc;
> >> +	int feats, rc;
> >> +
> >> +	in_size = sizeof(*in) + sizeof(*feat_in);
> >> +	out_size = sizeof(*out) + sizeof(*feat_out);
> >> +	/* First query, to get number of features w/o per feature data */
> >> +	rpc = get_prepped_command(in_size, out_size,
> >> +				  CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES);
> >> +	if (!rpc)
> >> +		return -ENXIO;
> >> +
> >> +	/* No need to fill in feat_in first go as we are passing in all 0's */
> >> +
> >> +	out = (struct fwctl_rpc_cxl_out *)rpc->out;
> >> +	rc = send_command(fd, rpc, out);
> >> +	if (rc)
> >> +		goto out;
> >> +
> >> +	feat_out = &out->get_sup_feats_out;
> >> +	feats = le16toh(feat_out->supported_feats);
> >> +	if (feats != MAX_TEST_FEATURES) {
> >> +		fprintf(stderr, "Test device has greater than %d test features.\n",
> >> +			MAX_TEST_FEATURES);
> >> +		rc = -ENXIO;
> >> +		goto out;
> >> +	}
> >> +
> >> +	free_rpc(rpc);
> >> +
> >> +	/* Going second round to retrieve each feature details */
> >> +	in_size = sizeof(*in) + sizeof(*feat_in);
> >> +	out_size = sizeof(*out) + sizeof(*feat_out);
> >> +	out_size += feats * sizeof(*entry);
> >> +	rpc = get_prepped_command(in_size, out_size,
> >> +				  CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES);
> >> +	if (!rpc)
> >> +		return -ENXIO;
> >> +
> >> +	in = (struct fwctl_rpc_cxl *)rpc->in;
> >> +	out = (struct fwctl_rpc_cxl_out *)rpc->out;
> >> +	feat_in = &in->get_sup_feats_in;
> >> +	feat_in->count = htole32(feats * sizeof(*entry));
> >> +
> >> +	rc = send_command(fd, rpc, out);
> >> +	if (rc)
> >> +		goto out;
> >> +
> >> +	feat_out = &out->get_sup_feats_out;
> >> +	feats = le16toh(feat_out->supported_feats);
> >> +	if (feats != MAX_TEST_FEATURES) {
> >> +		fprintf(stderr, "Test device has greater than %u test features.\n",
> >> +			MAX_TEST_FEATURES);
> >> +		rc = -ENXIO;
> >> +		goto out;
> >> +	}
> >> +
> >> +	if (le16toh(feat_out->num_entries) != MAX_TEST_FEATURES) {
> >> +		fprintf(stderr, "Test device did not return expected entries. %u\n",
> >> +			le16toh(feat_out->num_entries));
> >> +		rc = -ENXIO;
> >> +		goto out;
> >> +	}
> >> +
> >> +	entry = &feat_out->ents[0];
> >> +	if (uuid_compare(test_uuid, entry->uuid) != 0) {
> >> +		fprintf(stderr, "Test device did not export expected test feature.\n");
> >> +		rc = -ENXIO;
> >> +		goto out;
> >> +	}
> >> +
> >> +	if (le16toh(entry->get_feat_size) != GET_FEAT_SIZE ||
> >> +	    le16toh(entry->set_feat_size) != SET_FEAT_SIZE) {
> >> +		fprintf(stderr, "Test device feature in/out size incorrect.\n");
> >> +		rc = -ENXIO;
> >> +		goto out;
> >> +	}
> >> +
> >> +	if (le16toh(entry->effects) != EFFECTS_MASK) {
> >> +		fprintf(stderr, "Test device set effects incorrect\n");
> >> +		rc = -ENXIO;
> >> +		goto out;
> >> +	}
> >> +
> >> +	uuid_copy(feat_ctx->uuid, entry->uuid);
> >> +	feat_ctx->get_size = le16toh(entry->get_feat_size);
> >> +	feat_ctx->set_size = le16toh(entry->set_feat_size);
> >> +
> >> +out:
> >> +	free_rpc(rpc);
> >> +	return rc;
> >> +}
> >> +
> >> +static int test_fwctl_features(struct cxl_memdev *memdev)
> >> +{
> >> +	struct test_feature feat_ctx;
> >> +	unsigned int major, minor;
> >> +	struct cxl_fwctl *fwctl;
> >> +	int fd, rc;
> >> +	char path[256];
> >> +
> >> +	fwctl = cxl_memdev_get_fwctl(memdev);
> >> +	if (!fwctl)
> >> +		return -ENODEV;
> >> +
> >> +	major = cxl_fwctl_get_major(fwctl);
> >> +	minor = cxl_fwctl_get_minor(fwctl);
> >> +
> >> +	if (!major && !minor)
> >> +		return -ENODEV;
> >> +
> >> +	sprintf(path, "/dev/char/%d:%d", major, minor);
> >> +
> >> +	fd = open(path, O_RDONLY, 0644);
> >> +	if (fd < 0) {
> >> +		fprintf(stderr, "Failed to open: %d\n", -errno);
> >> +		return -errno;
> >> +	}
> >> +
> >> +	rc = cxl_fwctl_rpc_get_supported_features(fd, &feat_ctx);
> >> +	if (rc) {
> >> +		fprintf(stderr, "Failed ioctl to get supported features: %d\n", rc);
> >> +		goto out;
> >> +	}
> >> +
> >> +	rc = cxl_fwctl_rpc_get_test_feature(fd, &feat_ctx, DEFAULT_TEST_DATA);
> >> +	if (rc) {
> >> +		fprintf(stderr, "Failed ioctl to get feature: %d\n", rc);
> >> +		goto out;
> >> +	}
> >> +
> >> +	rc = cxl_fwctl_rpc_set_test_feature(fd, &feat_ctx);
> >> +	if (rc) {
> >> +		fprintf(stderr, "Failed ioctl to set feature: %d\n", rc);
> >> +		goto out;
> >> +	}
> >> +
> >> +out:
> >> +	close(fd);
> >> +	return rc;
> >> +}
> >> +
> >> +static int test_fwctl(struct cxl_ctx *ctx, struct cxl_bus *bus)
> >> +{
> >> +	struct cxl_memdev *memdev;
> >> +
> >> +	cxl_memdev_foreach(ctx, memdev) {
> >> +		if (cxl_memdev_get_bus(memdev) != bus)
> >> +			continue;
> >> +		return test_fwctl_features(memdev);
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +int main(int argc, char *argv[])
> >> +{
> >> +	struct cxl_ctx *ctx;
> >> +	struct cxl_bus *bus;
> >> +	int rc;
> >> +
> >> +	rc = cxl_new(&ctx);
> >> +	if (rc < 0)
> >> +		return rc;
> >> +
> >> +	cxl_set_log_priority(ctx, LOG_DEBUG);
> >> +
> >> +	bus = cxl_bus_get_by_provider(ctx, provider);
> >> +	if (!bus) {
> >> +		fprintf(stderr, "%s: unable to find bus (%s)\n",
> >> +			argv[0], provider);
> >> +		rc = -EINVAL;
> >> +		goto out;
> >> +	}
> >> +
> >> +	rc = test_fwctl(ctx, bus);
> >> +
> >> +out:
> >> +	cxl_unref(ctx);
> >> +	return rc;
> >> +}
> >> diff --git a/test/meson.build b/test/meson.build
> >> index 2fd7df5211dd..93b1d78671ef 100644
> >> --- a/test/meson.build
> >> +++ b/test/meson.build
> >> @@ -17,6 +17,13 @@ ndctl_deps = libndctl_deps + [
> >>    versiondep,
> >>  ]
> >>  
> >> +libcxl_deps = [
> >> +  cxl_dep,
> >> +  ndctl_dep,
> >> +  uuid,
> >> +  kmod,
> >> +]
> >> +
> >>  libndctl = executable('libndctl', testcore + [ 'libndctl.c'],
> >>    dependencies : libndctl_deps,
> >>    include_directories : root_inc,
> >> @@ -235,6 +242,18 @@ if get_option('keyutils').enabled()
> >>    ]
> >>  endif
> >>  
> >> +uuid_dep = dependency('uuid', required: false)
> >> +if get_option('fwctl').enabled() and uuid_dep.found()
> >> +  fwctl = executable('fwctl', 'fwctl.c',
> >> +    dependencies : libcxl_deps,
> >> +    include_directories : root_inc,
> >> +  )
> >> +  cxl_features = find_program('cxl-features.sh')
> >> +  tests += [
> >> +    [ 'cxl-features.sh',        cxl_features,       'cxl'   ],
> >> +  ]
> >> +endif
> >> +
> >>  foreach t : tests
> >>    test(t[0], t[1],
> >>      is_parallel : false,
> >> -- 
> >> 2.49.0
> >>
> >>
> 
> 
