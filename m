Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F67E376F5
	for <nvdimm@lists.linux.dev>; Wed, 15 May 2024 16:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715791315; cv=fail; b=LnyXOBMnmErjMdG5jhTXApmZ4H+cW/NEWVhDY/dD3n3HHkZfP7++iq5DdJlAHs5XNwuYALpSA+oEzOOS1QA8+G3gNLvEPx6thOhSFD1GJT4Mve8nkb6JClalVOiOJ90yVjTlxmy/O77h0lznw0fBltxI0T4okSbilFMP/VXElSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715791315; c=relaxed/simple;
	bh=ZrgNTtntLHhvtwkzWZFy2FIlHDZ6UZFwMa9m3uQIC94=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=Lpg3lc6T9hbU5KH2S8eB/6TLGbOSj4TsU3siUI63sfqnMFzBk0UJFaITe1ZDzyVQw5XQAMLoia5CtvTMffWR9AbfQ8waG6MJfN4HOcMC1GFdvNHlq90a9Oc+ee7+olM7leOmBqrGr/q/VDHPJ7LV9PO996QtaMa4+5XGpabMprE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L4AQT9DK; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L4AQT9DK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715791313; x=1747327313;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=ZrgNTtntLHhvtwkzWZFy2FIlHDZ6UZFwMa9m3uQIC94=;
  b=L4AQT9DKtynncwl0ccS+NE/41DeJpSAhOhxC4VGNjMdTkSJR0d0DBJA/
   8N9cwNJ9aXPainxFoCGZRnR5qSUwrmE7YTpLUR+NCpcfZr+37+ZwCuND9
   3f70cquOVPXIyycE7rJYeV1UdEDT+wDo9b+GBVcbtccAGBhd+V8mdWSy8
   6feeUZ61+GLh/iy6rOtHhAdZBg9u1Aq+aLJkY+iPQ8b0bVrI/2AvC7BEU
   WHOI5xTgOC8fTv2HE8E8U0Ss6xzQ+2NI4pOyjiydcOt6LYq0Skjii/Mk6
   xRdK6vi9HmKY2zlQFQk/y2uGpuqK3eH2NHsXioQOYWvDC2yEbVG8d3RhQ
   w==;
X-CSE-ConnectionGUID: 5nmqYArpTQK1ahbc8Bmc0Q==
X-CSE-MsgGUID: eZYpNIU4SEmgmh5jos8CtA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="29345161"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="29345161"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 09:41:52 -0700
X-CSE-ConnectionGUID: EKy1I4y4S9+kDpM3bIjbzQ==
X-CSE-MsgGUID: qajxe2awTHGovCiBsUN/BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31546098"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 09:41:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 09:41:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 09:41:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 09:41:51 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 09:41:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQc1N8V+7tTXQGGiUik3B6g2KLEIsP/68XwW5ZqEpnb/aSuo26Ef/1KDr5UTuFpKKVFqEZIUdblf95yKOt4ZgfX+jf6FYjw9Hkc+5+WGWPyfJ1mSEC7QAS4tGDxclSaAHQXDyUYppbEG0n3iPLT/jF3YMmxKHwW2ZJDNpS4VOOsPUOOXTOOaATUnx64R5bqdXukKKQwI7BZN2z660SzBZORa9Kfims82Ls+G2/gyrdSYcAJ7czLvAIuvrqmyCJ6kiU7nEyuBMkqIrAtvd6+NiTajFYzpmlQeWQ/omTMq2eIbj1TfVZxk8TMeo0i0lyDHTbjoGZHZxYvxIMNvS90svQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYsSQtlLxAcdrcCuaUqvTtAXZerFHTmH3L4jE1TRM4A=;
 b=jsX+Z7NXtUKK5MCHGfHQyW2e+EZWgDBIIm/tWW+Jzyh9gq8Kfk6+Mh1IlHg3kRvN6SByA3/TfOMC8gMSNjiCCl+x9At9ZcskUAnRPBadxpz+tfQ3hDDNYMDiVRFCtkvYFm73AbqaBnzLXaAlkn15JBzJSdio4l57p9uBYBQHA3EJhFOIG25qGmo6QMr4deSCV6JBKtUWJ1sZlwNkbMa4P5vyRF/hO+LN8Y1v0M5SMVANLfOGC1iAzmPH3cPnlCOG/zFtWGB/ywqnZuL6T6rXTQKBWvFZKcHmEDsh+jhfgUkeAIJw63McTXLprpyeoN6HIxSCNNLOMLFVb9ItFgCveA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 16:41:49 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 16:41:49 +0000
Date: Wed, 15 May 2024 09:41:46 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>, Dan Williams
	<dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: [GIT PULL] NVDIMM and DAX for 6.10
Message-ID: <6644e5ca3a1a7_7467294a@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0125.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::10) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA0PR11MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b63bc8d-5cf3-4a6e-16d1-08dc74fdea9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?Gn9w3KIQewHgQ0KwlF/gNkDck0VBfhM7qiZKPd0oXdgnjg02panmmramei?=
 =?iso-8859-1?Q?+NWOwNIMuHshlbxCVb3ISw/aPl9NZsCcSmUgElfrC7AV8piLTT7Na7CIlY?=
 =?iso-8859-1?Q?1/lpDSF42eRtx/hK6l72MAngKiNtFvC3OKU4bTpC0C17tJlrykKkpIIgGV?=
 =?iso-8859-1?Q?mK2bT2C+3t6t+XdHuczn6LEo6uG2HtOqm/eIaYeMM2gSbg4ARNfy9l2qMW?=
 =?iso-8859-1?Q?fxdOi5F1RwQU4JeXrki1EmT5KNvRHO8IX71CIOyqkIjZcldGIlV3B5+nyu?=
 =?iso-8859-1?Q?9Eo1VXhsO+TlJHEj2lon8VIkdLHPCZBMkpeATcg3XyHKcC7AJHo59C7Px0?=
 =?iso-8859-1?Q?1s6zk4jUULxPMbKoPZvSGMLXL1CRdeMqvESIsnUQAOdiGlOiKxjirb7dPA?=
 =?iso-8859-1?Q?PyGEQ3b6+4jPQJTdN4FbJ2ZHUEsFL55WmV0dGwJnl5RWp0f87AW2pOVtw+?=
 =?iso-8859-1?Q?Oe9xA0HvXodvzGHx/xKQftEA7OLDMit83eFtLMcx+i88WR/xxfrPq+hQCk?=
 =?iso-8859-1?Q?+UrjXhrzdhy7vNkDQpRR0ZcSLDcnkAej65uMws4dmaFMD36aYGZ9DL1a/S?=
 =?iso-8859-1?Q?tQotHosPT3tuZLtcRYbXtbn2eIsOVO/pl/6Z42SFlPde2o469Kf0VAuHqs?=
 =?iso-8859-1?Q?25kHPwjCBscyR+R3DfwsZPtX2O0aC/Y9fusdeVZTHAaI2znBSyyhmC33Re?=
 =?iso-8859-1?Q?AjJdI5qzDGatlu+yhc0QkaGzjIkTtwjwTjKuE6GeaeE0DT6PdvbQqPc0UQ?=
 =?iso-8859-1?Q?Q9XNYRUExv9tDWbQMEF+MNdRRF7NnKnaBNIiw7HYhc4PxVWcCUn9w9Jkji?=
 =?iso-8859-1?Q?wCJM/4DOEpQb18OWYjag39ny4zfDn7zaqilcM1nVQAeB2ruvfgmkrSodA0?=
 =?iso-8859-1?Q?QGjq08Hu2JKFTDYcVVjdftKun5+YQXGqUQBfNi+N5XCwT1YLvJqVM11ytX?=
 =?iso-8859-1?Q?BbRFvvLIKWpyvp9yT0clJ6TAG6h+vJif7y2QPo+XGBUIfhZpUrh3PuE0hu?=
 =?iso-8859-1?Q?UU4wbOThw+X9DyB56NQnlrw0oogTncP8i4SYseDfE81UHxPj7faiR4M1UD?=
 =?iso-8859-1?Q?a84CrNzPx9adIWWlmWlcXuV3Fzc0/U7o/u5FjRo6i6m3wk4abI4agLjU6L?=
 =?iso-8859-1?Q?ombIOPJk+PXoPhRi/T7DxR3Bw4CDcpLqkC6mOlyj0BM6c7KV6Gwwx1MCE+?=
 =?iso-8859-1?Q?nnTg6N6+qJ90rxrAeUL6d2uAlwu41CtMEPsCUYw32n+ZhmvPNH9p3zF17i?=
 =?iso-8859-1?Q?ZrMuUBOeWNpJ3OZIOYe7U5MMrP8WBNT6qFrXP7tKpfjbdptakP7BgxOl8S?=
 =?iso-8859-1?Q?euT4n5u4MLiK6u2MA9NBNezaYg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?V1mFpGGDW8Pf7qqPlxOLK757ZfvFCDdw1otsbNYWcF+byMf/4tF9+C+qz9?=
 =?iso-8859-1?Q?DHss+fBCkRDy51lJfhMaRBwBS1WVlL7e8/hGvrhilH4nnU7D4JhBNFO/MM?=
 =?iso-8859-1?Q?EhSyhfCvNeRKUgkxKpLh4qCEADnKrYQ6v9Bkg49HU8/8vRlwUmHkzeK3fq?=
 =?iso-8859-1?Q?ES6wlCmg5sXT60xQq5zuc1tauztuSsR5U9rFKtnVvV5V7y1N+zkUMp/w64?=
 =?iso-8859-1?Q?ofvYlCCHeM2cISRnQ3L4exqjoKPiUZaJTzXczxzjoxGdiwrbd7L29phYyI?=
 =?iso-8859-1?Q?itgIdTdlU++6LzAdn8sBbskvRpwimlDN/QSB5xsz6C/CYmj3fM9YFbmJN7?=
 =?iso-8859-1?Q?2jO7sDFMaVWtAkwHRpfi3jxVFrSYeNB55enL/XgwEHVSA4ftwfkEpJUNhD?=
 =?iso-8859-1?Q?V0cndlUtyli8aC/j+zilLPG+fDqbIQTvqy1rE+VIWlKLmjOgcvbvzDDjv2?=
 =?iso-8859-1?Q?uawnUIfnIOQWaQYwAZereVne9dYoGGWvlz1Vi/RBej40pttkwmafeGVNlb?=
 =?iso-8859-1?Q?mDFwp4Z6bl0+N2kUslLGxEiDgsomJ359S97FI4cnIkqMNw8efM+rashAJm?=
 =?iso-8859-1?Q?XD3FSHrCQZ/e7DcAEHD9ffmKc4bNfIlxf7TPRrbaHND2XBPZJNQHsccBSa?=
 =?iso-8859-1?Q?v/RzpoHjAHvQKpprH2ZVbYu7vX9Yyc34xICWR4rB4bkVg6YtfOfYj2uf2t?=
 =?iso-8859-1?Q?m9WMke75t8utYenvRFipAADgBS4bH/1YmQCsurhAJVmjwtOGRLl+arPSYC?=
 =?iso-8859-1?Q?t3Z5R9+9fWV3Jm4X0ixRah9iy7+t++xLfUFeuK/sP3pxYR0RgTcRxwfc93?=
 =?iso-8859-1?Q?YW5XGeH6h1+YtpUV54ZeOk8p1INEfnQLCBBzpVzh8zZVJTUMM6wcr1SChm?=
 =?iso-8859-1?Q?OSDx1WhN1+/Z355lQQjN6aZD4vvcMY/t0h7+ysd0/qJj2wDIqWDDOV/RRJ?=
 =?iso-8859-1?Q?22NSnfbsw9ExTdv4ISe8e7Q7jCxM2HaKVU/8lBbYriVRikVUJSo7QQowUo?=
 =?iso-8859-1?Q?IvbeJ9lCTxFJhpVKMeh6voPpzBMn3JkPERZka0mrWeKPoiLSlG2aGPUn6V?=
 =?iso-8859-1?Q?asUV4IZeXfLKo/bnb4Nx4TkdrFRi6D9pqv8tFGxXkshJu7Vvn5quPX0NNm?=
 =?iso-8859-1?Q?JMWZIAyfklqzOqnHu/WumJXYrtetkFKJgjWtwOCRX+t8/jvk3Kphill/W6?=
 =?iso-8859-1?Q?z0WkblCKDCqnwgZShVO8IfQ8CPP0aWBXcps/klyTNLPo8Puwmjx8C79KZH?=
 =?iso-8859-1?Q?JuOZeuEZ6aQQFAPh2qI9W3SMIi4uJmxAsy7zk+Kauniil3IomSSaZU9mGe?=
 =?iso-8859-1?Q?wDzaPokbBQeQ1h5orrz81DWlWwB6P6my4At5CALarQO1m9lJvtdVNFwi4w?=
 =?iso-8859-1?Q?YsOMKTjbgUeRmHVyK7kTgBNL2PTGdxDBvesXpNqcU/ufzRrNos6C7RrN5a?=
 =?iso-8859-1?Q?gWpTWrB0RnJpUZYn296LrRKIv7J5sc2yEuRyHarMP2+r45CdQPgsuALz7z?=
 =?iso-8859-1?Q?bn20+AsEBVv9YrvDkdwKbKlIpaxZqLNiuDuqIpwt58UYeQU+X5YQjKhi+Q?=
 =?iso-8859-1?Q?Ic8pcwxFmk7YNDRjBiRZ3BfTsRIgneMfrTH7s9pIQaLqPZa467qiFG5dq3?=
 =?iso-8859-1?Q?ILloJQ/k1hcQ15DMW57n0F8gNexDhVwULNeyq3rgLfQcuWkjZpb1Nz1XH3?=
 =?iso-8859-1?Q?IeUP6Noa1OhKsZYPpPE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b63bc8d-5cf3-4a6e-16d1-08dc74fdea9d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 16:41:49.3634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJyuRiK6DqIltsxvV0oXSUYMkFmge3bYvetvMCV1M35FouMYASSpcEytLwFlSDrYhAYbUep0Ktp2zScWgvgNvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
X-OriginatorOrg: intel.com

Hi Linus, Please pull from 

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.10

... to get code updates for the nvdimm tree.  These have been in
linux-next for a couple of weeks.  The changes include removing duplicate
code and updating the nvdimm tree to the current kernel interfaces such as
using const for struct device_type and changing the platform remove
callback signature.

Thank you,
Ira Weiny

---

The following changes since commit ed30a4a51bb196781c8058073ea720133a65596f:

  Linux 6.9-rc5 (2024-04-21 12:35:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.10

for you to fetch changes up to 41147b006be2174b825a54b0620ecf4cc7ec5c84:

  dax: remove redundant assignment to variable rc (2024-04-25 14:11:11 -0700)

----------------------------------------------------------------
Updates for nvdimm for 6.10

Code cleanups, remove duplicate code, and updates for current
interfaces.

----------------------------------------------------------------
Christoph Hellwig (2):
      nvdimm: remove nd_integrity_init
      nvdimm/btt: always set max_integrity_segments

Colin Ian King (1):
      dax: remove redundant assignment to variable rc

Ricardo B. Marliere (1):
      dax: constify the struct device_type usage

Shivaprasad G Bhat (1):
      powerpc/papr_scm: Move duplicate definitions to common header files

Uwe Kleine-König (1):
      ndtest: Convert to platform remove callback returning void

 MAINTAINERS                                        |  2 +
 arch/powerpc/platforms/pseries/papr_scm.c          | 43 +------------------
 drivers/dax/bus.c                                  |  3 +-
 drivers/nvdimm/btt.c                               | 12 ++++--
 drivers/nvdimm/core.c                              | 30 -------------
 drivers/nvdimm/nd.h                                |  1 -
 include/linux/papr_scm.h                           | 49 ++++++++++++++++++++++
 .../uapi/asm => include/uapi/linux}/papr_pdsm.h    |  0
 tools/testing/nvdimm/test/ndtest.c                 |  7 ++--
 tools/testing/nvdimm/test/ndtest.h                 | 31 --------------
 10 files changed, 66 insertions(+), 112 deletions(-)
 create mode 100644 include/linux/papr_scm.h
 rename {arch/powerpc/include/uapi/asm => include/uapi/linux}/papr_pdsm.h (100%)

