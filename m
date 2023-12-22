Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561772C1B5
	for <nvdimm@lists.linux.dev>; Fri, 22 Dec 2023 19:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D4P2jRYa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703271707; x=1734807707;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=owAzIhzeqW/0FKUdfShQNlWkoXh5rFZUA/7c/yiM4oM=;
  b=D4P2jRYaK22Gn6AdVfro/66Plf/rhitzwCxynpFS2HiiVvMi0AOtiLZS
   8f6iMdm1n3zelcYGrcBhtwoWxLXp97E2nRZX7nTVpgXveK/URqxii2NUs
   1jTpYYdT4Xg9YtyM35rWUaxKxCORMEnWbx9cJQNqPwkPhU2YXQpbdy82A
   clykmbpSBOppyFPozr7h3FsoAYxba/4GzcEi9gpCDtJpSTgScmPRFDfkf
   2DUL8ovmzcmqX/A2pZNLiP1zDzcMeITEn+aAhUNMB/yCyOmNiPfS+hdV5
   oiesmiArPc7D4AIXCeNFM0oNpVFLQCzmEofSYrIzfu8w7HOQuIG2w0t2e
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10932"; a="482327711"
X-IronPort-AV: E=Sophos;i="6.04,297,1695711600"; 
   d="scan'208";a="482327711"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2023 11:01:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10932"; a="1108533785"
X-IronPort-AV: E=Sophos;i="6.04,297,1695711600"; 
   d="scan'208";a="1108533785"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Dec 2023 11:01:46 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Dec 2023 11:01:46 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Dec 2023 11:01:45 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 22 Dec 2023 11:01:45 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 22 Dec 2023 11:01:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNbDrjzbwjpM3yakCjchrNJ/E+6PRjTYmb86IA5Sih+t8oeZmtAbd5oDcM9qkLn0SntbEaTmFneC8xy7CUEJkMYzRH3YpuFLHu9M4rU6jQtySNqv6j1kCV9AC9/lYuEooTWEU7xAuw2BplCxoL8EwPfUVBaDL7sa+2xhbn+qxyU1EKJpN1khsB092UdHeboHfv73ouke809uVd+LMTA+MY5GhJIPD+btmSAafPyJVq4rel7OQiIFn+3rAamnxRvD9y3WSp4f3VSHMdMtVR9DCWpRVQQu4C3OQdqQng69Pec0BTl+b2Cv0A/dT/a2EgHkhy6BHQbYKs/0zGnQI1A99w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtbaaMSLZirtwA04iMZ+VXCu+v7IPUpEfkaMJjEMiSg=;
 b=RzAv+FVrCd9vhE5ELLEtwWaQRapoRBkuvu3u0B2pCYmRVXZZ35kQhNKjR2EJm2hES/c9P1JBjXBiKPalICXE8k6F8T9mzaE/l8HYnn3F+guUbJduXYcufhBtxh2Kh7i65+KE7xOL8vkk4VAJiDisZOleIdj7G3RLHYL1XVowc1He1pi9yI0WwP86sR00GavVelvTQ/oAyG45NmL8p3tGGz6ig0j0ZwoO8zDCl4jxo6117uFBkziBdU37MJCXb5xqJ3ntnC/uNkKqRgPV3fs476rcwdi90zfUa39yxCFce9vsVmyYJyKt5iemW/Z45yC4+3ZibNuKcLQ7SoXmkX/ZCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MW4PR11MB6934.namprd11.prod.outlook.com (2603:10b6:303:229::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.21; Fri, 22 Dec
 2023 19:01:42 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::da91:dbe5:857c:fa9c]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::da91:dbe5:857c:fa9c%4]) with mapi id 15.20.7113.016; Fri, 22 Dec 2023
 19:01:42 +0000
Date: Fri, 22 Dec 2023 11:01:38 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Coly Li <colyli@suse.de>, <linux-raid@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-block@vger.kernel.org>
CC: Coly Li <colyli@suse.de>, Dan Williams <dan.j.williams@intel.com>, Geliang
 Tang <geliang.tang@suse.com>, Hannes Reinecke <hare@suse.de>, "Jens Axboe"
	<axboe@kernel.dk>, NeilBrown <neilb@suse.de>, Richard Fan
	<richard.fan@suse.com>, Vishal L Verma <vishal.l.verma@intel.com>, Wols Lists
	<antlists@youngman.org.uk>, Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH v7 0/6] badblocks improvement for multiple bad block
 ranges
Message-ID: <6585dd1299942_ab808294c4@iweiny-mobl.notmuch>
References: <20230811170513.2300-1-colyli@suse.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230811170513.2300-1-colyli@suse.de>
X-ClientProxiedBy: BYAPR01CA0023.prod.exchangelabs.com (2603:10b6:a02:80::36)
 To SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MW4PR11MB6934:EE_
X-MS-Office365-Filtering-Correlation-Id: 30d2dc72-1a96-4e38-5a25-08dc03206f30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ByvaMJexblN1BhU37jeL1P1PovsweMnhb9Q9M8sznYb8TViRecJtQLmdWKXaQqAZ2InFB1mxDqom2Uav4Gjs+KCfwiRgWRKVAme5SqpuXcgF4PfAPzkfZ0NGPu49MbCy9dU5+vKfn/5L/LJ0hP1MLDn44JaagH7rWdzIYNNKM7Fcf2KXBtoejTl83gy43s3M86ssD/Nn8BkAEOTI+CrxXgJh7UsmKwcDq35mqClAhFYkBXaxra5oLkbJhhrlwLfMq7+5THMx3zXqVInnJFnc17ykcpzvJB5IQdx+owkBhnVc66rF7k9Tim3rXl4oGGviewk6Gz3oPFPobB4Ei13npsfaT4/obTHSX47Re3wSQJKADlAGKwAQgcqwCMszNPC+BMi70z9eREbLShTWy220YLNzajGywNz1Nag08Dw98QJUng8K8t8DlwvfX33Yl4j/z/zG1WozMsRnZRjwrMBjrtqIsemveLkJslKXEazzrvHMQP6gTJgmj2gj7qIXK/wpCDtv/4TPqaJtblfgH5LwWdrygKO0F1omS+uTo1dewx4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(396003)(136003)(346002)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(8936002)(66476007)(54906003)(44832011)(5660300002)(8676002)(316002)(66556008)(66946007)(26005)(83380400001)(4326008)(966005)(38100700002)(478600001)(6486002)(9686003)(82960400001)(86362001)(2906002)(7416002)(6506007)(6512007)(6666004)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DYVxx+MIaaftJSsUNgNq/DGlBD+1Kww3iGJZnxZTDsXpGdhDyJPY/mtTrr1I?=
 =?us-ascii?Q?nHtseMK3yisFePnQi/sVBQ8ikQH8OyEVBl/9JA0Fzv3v0vMkje0UiFpnl7o1?=
 =?us-ascii?Q?n+HMKKiPfhO9vRWXkq6Q7Gqro0BsM97uWXHBgQeuwVyzO2yNnrEH+O3gvedb?=
 =?us-ascii?Q?CDrl9G8o2V2mPd57epYCs8fSxnSydIJsvPifc1nld0mTkaVrsDT1hw9zJuu4?=
 =?us-ascii?Q?IfMkWzEO2HcDgyOfVoaLkV4TtDV17NaGzFuqck5racwFNFpKvjRWGthGvBgp?=
 =?us-ascii?Q?q53EDH/DSs/7TQGKsIaxhLU2GAWNAdMoTAtvInMsJqldMNKgu/6SfLfzvl2l?=
 =?us-ascii?Q?ZbTkxH5HbRr0LghzPCPqHiVG9yE4ReiDbz+Cu80/fMAVFc484t9hRjxt6LqP?=
 =?us-ascii?Q?3RXdbMZq9qKgiTVcNWLd+9S1yVumpIYm2jpwzk+2GzXFIseWwnjBuEoQXoyJ?=
 =?us-ascii?Q?99ZqyvdZV0fLJs30D8zUYyawaYYAoDAtVZi1u/3g7QNyFYe75Pq2vAPuzI3x?=
 =?us-ascii?Q?venFp2eHHo1NpKKLDGgPKuLL//YmahxrSqkqyJ3lyy1LmUw+F/Og5jSSjqdy?=
 =?us-ascii?Q?b0MGryiJyYYXtUtFMc/sFbfhvPpiha5X98RLw/6L7rocWVlJkU6ls0LB6Ece?=
 =?us-ascii?Q?20IZnSvUmTBckoOdWmkAZBMW3wxuG/8y4zJBkZjnndbCWselTC2CbKgqHXpX?=
 =?us-ascii?Q?d22Q36Ne+UN2iNH5r+kUi8p6rT531NqOr+BBDvhGvJ/oRZRizhV+FAlnSlH6?=
 =?us-ascii?Q?bX9b4deqCrOxYM+0WKHUFzTVppZFtrnS5QytSgZvIEbhmVFY656bihVKP2e8?=
 =?us-ascii?Q?48JJb++tyEL0V+iwJ4KghcRIeGfDgwm7oVTFWx6oKcYuZJkO5rk6m/ndxdXq?=
 =?us-ascii?Q?bTD5Vy2DTO52tMUD4XPkmsGwFLL0DZBIGRgDXvJQ8iwgO80S8XgFCSwphpXb?=
 =?us-ascii?Q?rV2CxCG7m3SqOW+tinLfZnL+vyPcX3Gwg7V9Ih79vMM/BrfULoOn3rbZaSwj?=
 =?us-ascii?Q?Vuyjf7UJ1Bu77rqTCImHibMmANV9BEBXFB7iBwKB9AuW58XPgJ2fk5MLU7dM?=
 =?us-ascii?Q?HwKOiUPXW1QeGDq4wY5HbdfST/OKLITgOUa4nHqP/0W+aBTqLTOgkXbNxQAR?=
 =?us-ascii?Q?BlRJIW5xPXVI+QI3Ly6dc/4p+tQ0hInHi1xPXe+cKz+vJeoV6R7FZ7omWFjs?=
 =?us-ascii?Q?3ud57+iMox4PY3wdKBJ1WXjLa+SePxDntc2f4OQz4w7RWssduas40MHpirLt?=
 =?us-ascii?Q?bMsZelGML6EVdZMEK013ZhJRrr1Oqe+7nz6MGY/utZWeg46xsVLPb65p0kig?=
 =?us-ascii?Q?bsdHGGTEJ3uqEwiNA463oEFW3R+Veel84ACpwYE38X4AJHHKR5IymfPQhq2E?=
 =?us-ascii?Q?gbaokx9p8bVVULk+DFtmDZlT20A4dJIJ0ACMzXwWHKK9mHT1mhD1ETipxuhY?=
 =?us-ascii?Q?tVoqkCABIu9fZWL65SneGzfrthm+dHz42HQJFYQ4npRcAXkdYFbcbMGmwBEo?=
 =?us-ascii?Q?Ax/EPQoD3D6/6iXg8WqxC5Fw8Kt0OULUsuqp1LDAqUx9/MeD6pn6BvVVRyDk?=
 =?us-ascii?Q?OWLht3Cm1R2e4NgOUUnunVITAnEWGaJVchwYGrQ8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d2dc72-1a96-4e38-5a25-08dc03206f30
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2023 19:01:42.1555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lGBuxUShJl7oxdJ0V+FM0sPvTrQNXX7HegE67pku68VgaED7Elaqo07vs7hhsEldylDZ4kw4Ri+aylMkp8PgDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6934
X-OriginatorOrg: intel.com

Coly Li wrote:
> This is the v7 version of the badblocks improvement series, which makes
> badblocks APIs to handle multiple ranges in bad block table.

Just in case I missed anyone on this original thread I've found issues
with this series which I emailed Coly about here:

https://lore.kernel.org/all/6585d5fda5183_9f731294b9@iweiny-mobl.notmuch/

Ira

> 
> The change comparing to previous v6 version is the modifications
> enlightened by the code review comments from Xiao Ni,
> - Typo fixes in code comments and commit logs.
> - Tiny but useful optimzation in prev_badblocks(), front_overwrite(),
>   _badblocks_clear().
> 
> There is NO in-memory or on-disk format change in the whole series, all
> existing API and data structures are consistent. This series just only
> improve the code algorithm to handle more corner cases, the interfaces
> are same and consistency to all existing callers (md raid and nvdimm
> drivers).
> 
> The original motivation of the change is from the requirement from our
> customer, that current badblocks routines don't handle multiple ranges.
> For example if the bad block setting range covers multiple ranges from
> bad block table, only the first two bad block ranges merged and rested
> ranges are intact. The expected behavior should be all the covered
> ranges to be handled.
> 
> All the patches are tested by modified user space code and the code
> logic works as expected. The modified user space testing code is
> provided in the last patch, which is not listed in the cover letter. The
> testing code is an example how the improved code is tested.
> 
> The whole change is divided into 6 patches to make the code review more
> clear and easier. If people prefer, I'd like to post a single large
> patch finally after the code review accomplished.
> 
> Please review the code and response. Thank you all in advance.
> 
> Coly Li
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Geliang Tang <geliang.tang@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Richard Fan <richard.fan@suse.com>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> Cc: Wols Lists <antlists@youngman.org.uk>
> Cc: Xiao Ni <xni@redhat.com>
> ---
> 
> Coly Li (6):
>   badblocks: add more helper structure and routines in badblocks.h
>   badblocks: add helper routines for badblock ranges handling
>   badblocks: improve badblocks_set() for multiple ranges handling
>   badblocks: improve badblocks_clear() for multiple ranges handling
>   badblocks: improve badblocks_check() for multiple ranges handling
>   badblocks: switch to the improved badblock handling code
> 
>  block/badblocks.c         | 1618 ++++++++++++++++++++++++++++++-------
>  include/linux/badblocks.h |   30 +
>  2 files changed, 1354 insertions(+), 294 deletions(-)
> 
> -- 
> 2.35.3
> 
> 
