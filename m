Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787193D76
	for <nvdimm@lists.linux.dev>; Mon, 10 Nov 2025 01:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762739207; cv=fail; b=MO5yZo5+ijfho0QbATyCWZkXPxxsqd7B8N+sKmrjSsxAQmv09m5uOzid1zfYnVC546BUzJlCL3qObOSBtuEgPYUb6CttYvolI1PhPernLIaGXXlKUBdo3gfbfYcJd+h9wLbpbrR0tsZyTI80Zc2fYF4XY3F7YPOQB1R7+cqfF6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762739207; c=relaxed/simple;
	bh=mOEhXDvF8U6+s9dMItnnXAX/D8Eyoze0U5kdkFRunGU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IjwbEr+lDZ3MT9b7b8yflts/w5LGG4BZOLS3x/xdg81eIqPdyDpc+WnM7AbQflicTDVIARkIQQLRnat7Cwfrl8eb1sZEMpOOgAS5R6R4dWpC1ImVPm/2gwSdowUJP46OHwVjGok6L23mf14lalNf2tl/A2c5eptYr/mDXS68lqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fr00egbG; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fr00egbG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762739206; x=1794275206;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mOEhXDvF8U6+s9dMItnnXAX/D8Eyoze0U5kdkFRunGU=;
  b=fr00egbGVikoDlz+wnBQsRM5Bx+XVb1/o03xPLyPYhwIeH8uol9M86+T
   WNon0Jc4EvYtdguYlpH+IXAhorji+tWXDkoQgX1ukiJFx/sTD0XGMZeJO
   FO/dRKlPwmrxY/uNy1bwPSbm+Zw1lggulW+B6ev9LIAy1W+hr8w+9fJZ5
   mQOR6tKM5eJajzOGl5QeaQPDrR3k5gjQbSdlzsZ52IOzxGVaaBNvWY01E
   jmAW72OdV7S3iOHB33RgCyi748qFDoBwYIUwpwQs9OMTFa6qNbKpCLhWw
   21QQhU1KXBYysyT6KUtnn/b+QeBDJL10UY6TRIEugPmht/B+G2+4A1Xz/
   Q==;
X-CSE-ConnectionGUID: K3IeS/4ZQmWdcWfibi5F/A==
X-CSE-MsgGUID: vwNYa3URQ5yheUPt9ehXAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="90259759"
X-IronPort-AV: E=Sophos;i="6.19,292,1754982000"; 
   d="scan'208";a="90259759"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 17:46:45 -0800
X-CSE-ConnectionGUID: 78IbVCrFRJmrtb0swnL5dQ==
X-CSE-MsgGUID: dAkmLj2JSNapfwrXH9LM4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,292,1754982000"; 
   d="scan'208";a="188193008"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 17:46:44 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 9 Nov 2025 17:46:44 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 9 Nov 2025 17:46:44 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.36)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 9 Nov 2025 17:46:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EakngD6pWMW9CsPDQBRpHKrSfv76NKDl4GxlcBU3bhdb3/fdOTTC9aKTSmhsARNubkm9bPRdSYdi4RoxY8eoEg9zQ4DSfwU0UyieEXherOpn0751dLKtfqrv35bVZlPorjBst/+M/yng2nGH19A8QiG6KiKXAPg53e/XXM16CEfYSEpo17gR+bMEArvvsABn79f54F/fY3PFsobzUP91rl0uCqSSSIkh9H0bISGRMKC4q/jTq6vh+Cx6RHL/MYKawz2PJ7xRPhg/wEok+/9JHOz0BIOzSzKjeMqaOCkx056ccLrBfjbJlHv1vpWCMa5xAU2lm38LzocBE0PfMKmkOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/CkdFK9MKyBITaEpTHKvVWyvl6uWcX4fbrUT959H9Os=;
 b=j7yPEeIJEkchigJqHn/ScxUPenLlwYLG2oSIVch2NPiaDfCYSg66plTE+QA4vI5oblX52mXLS/Zups5A3xjJWOg6cqyVhJxoQQLaa7+3sxQFu86Plx6G1gwVni9uhGh+7Fai1SKAEuZ9KNoIt3KpdoGOWJ5XFJVQoBiiF9w5E+3IfIaUOk/3G+wLqd2xr6oIZsnmhor4hLwk43rj1BQXRL+tTmTNktz8qbYNYJERi/XQrerB0DsWqJsvtLO/2WeiZo4aQWUPuHEE5YRlvB1bh2AP7KnC3eRi2f4YqxUwA187WFhsaKaLrLc9VQ8LRFhhJwEacqwJLANAVZ4SsjGHiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB6498.namprd11.prod.outlook.com (2603:10b6:510:1f1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.9; Mon, 10 Nov
 2025 01:46:42 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%6]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 01:46:42 +0000
Date: Sun, 9 Nov 2025 17:46:34 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <marc.herbert@linux.intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v3] cxl: Add cxl-translate.sh unit test
Message-ID: <aRFD-iJbAxz10aS_@aschofie-mobl2.lan>
References: <20250918003457.4111254-1-alison.schofield@intel.com>
 <m2bjlhtd27.fsf@C02X38VBJHD2mac.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <m2bjlhtd27.fsf@C02X38VBJHD2mac.jf.intel.com>
X-ClientProxiedBy: SJ0PR03CA0277.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB6498:EE_
X-MS-Office365-Filtering-Correlation-Id: 91e66447-6c52-4574-16b3-08de1ffaff51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zv4V8pu11/ATlaIA3wsGFv+54x1kwk2f9pD66UcK9DRS/hrBNOCRT6y09Rih?=
 =?us-ascii?Q?aray4wD2H9U7TZ8BwCWVb2x3FLiKNlyd89imACPPxbYOG+xLuqXpzFzOq/u9?=
 =?us-ascii?Q?AcwtXc2CZmOiqNQYzNh+XZ/CpXXkYrbb4ylzLiFFHFgJCzk54nTvKAo4TeTU?=
 =?us-ascii?Q?96aRhAQbryfonOuwreuFke/dKkmRwTfDfCBHKn7YpigzTMJtQa38WCmivg+H?=
 =?us-ascii?Q?zviGLgiWDbP1bu5Udo0YUV0qcG8F3Qa2bzlDoCrMKAm0PHoDlFIpduCfGQID?=
 =?us-ascii?Q?aOdHOKSdUX7yZ7FLiOFX2mmrw+i07U59/SjgmOBpSQn2csIDF0PYj4iIgOxr?=
 =?us-ascii?Q?6fptLHcsRL2YI387bMYS1BNXJrb00rBIBCq6siqVNWll8dy87dd7Mj/ly8dp?=
 =?us-ascii?Q?D63hQCGvlt4B6VLSC88JX9tqrqpmTyfwqCFbaEiEmqPwuH8chAL/LG1ClF85?=
 =?us-ascii?Q?RuWaH6E7YFOkT2EuJ1KCD2ykXibgrxVviYADKyBWB9v29hzu2y+rm+Mez5px?=
 =?us-ascii?Q?KVtsLFjJ0NLAYE3IuF6w3MVz3bAWJbdzjerkUAFmz73VW2bPI56v2TiZBw4X?=
 =?us-ascii?Q?uYrar1iSxOdzbFc0UiVfXACcbcBkzYRNfYR2tI1kwElAThc7/oLRoO5qndIH?=
 =?us-ascii?Q?JpOH/m07+c2cqP3EA+p7Xa2fANb3VzeUO35vP9JMHJ+8xoaXPsUtkpCgA0vX?=
 =?us-ascii?Q?IkAPUcnlHTKs8RqEBojRn584soAs6cstNXqaRW3KzhvZrfdUipn1QP+UAJHO?=
 =?us-ascii?Q?BU36xpuTVUVGEuXuOjp0FYQHel9+Ycn3/68OIsnV4ZoQw0ZNeTeVVHuC1VR8?=
 =?us-ascii?Q?xR7xHefk4wJK205V/v2ZYG0rwjxFNUR0sl2hButs/JX+0NGycN4CDiq4TamN?=
 =?us-ascii?Q?c86241UbOgzloWEZ+z64ltNYH2RiMJU+DyTG/M771HTP1zo6MjuPG1sLMK5a?=
 =?us-ascii?Q?Jx6lSHZaSsEyxNwrWNERSVfg6iPKc6SqAPh2pwuGvVpiugYpPo1VDIOzjm8d?=
 =?us-ascii?Q?J6f2zyOuSZHYRyUCJCZiE0siicqorrvW9iK/X/o7d96UphPk0BNdhyOmzapS?=
 =?us-ascii?Q?X2Y4bBpKG14DjAj9EFBOiGWJoEC8wycMQ2xnDSV5liXzKJOUefZ0HchTq0Dr?=
 =?us-ascii?Q?aVlNG9Cyx6VOLjM25s3wSHAbS07YMUS/ezOQdxy52fgV66rdtX2/63cb0/5D?=
 =?us-ascii?Q?AtjV7z67FuywvkgqX8amOZnzjiSVTT/BiEqDvz2tf5Jck5tt+IAkGgLv8/LG?=
 =?us-ascii?Q?gxon/H03/Ndms7kd7RVPF0EbIaJ3F82FZVJkI9W/fI/S/9RFpZCzzdAWqpCA?=
 =?us-ascii?Q?gckv1nI5YGeHEA7dCpdHALmVeUzyTf53SzHAK4b+E+5tHOIGoPVWQG8ACSZC?=
 =?us-ascii?Q?gie04pLVuWFxL7HsFCTGhioPmQ4iqkTwMUdRSzt3oV8SzZhhmWBAxlvZdG5B?=
 =?us-ascii?Q?UVGZfr/dCBpGEPN4SZGjAYe12jdEbP8C?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6oUDmJeWAfHPceVjhizwYEvvy7ZEdhdq08bUtm3HLyKwikS0ySSUQgU8lcry?=
 =?us-ascii?Q?whDevJCiZRIeGZnc91ZvHdLP7o8wTw/PC3iK+lTBqxljfc2ZFpwjb7+on3YJ?=
 =?us-ascii?Q?ZZsV2wy8BG2pQYtOw1IWqhWOrEeJ/TW9ZqlslcH6TT/rMrszHYVUAhb7ZnpK?=
 =?us-ascii?Q?md1o01BWZ6m+KdkFKeBRLgHfoWVAsp2BwDFv+GEsDSpQDsRDZa8nmSheVdjm?=
 =?us-ascii?Q?YmmmLDmaD40iOrgwaS+A9gm96Jxk+gSWX7mFWcuU6pFPMxTc7eSmUF2c9QSP?=
 =?us-ascii?Q?OxNpp0GXyz/FOknTNjzuLppFF9q2a/B71YDhoHZRM/aN9LlcBsxO2GywdNHM?=
 =?us-ascii?Q?NynzaB/oiNUeA/UzrF5oD37c5+rKVei7zAjL9xL4NDCN6DGpN01h2b0J13mZ?=
 =?us-ascii?Q?Ml6BZ1uTJGEJ2T1h+jo0zZiRJnvcL+vTqOfPeqLADjoL0yo8rScOePgN3Oa6?=
 =?us-ascii?Q?hHAHFHz+OozmRxpWvYDSzYBy/2RLzbW8kVSrlZstOjgsytD5O9D/+9WYpBQ6?=
 =?us-ascii?Q?290qN5tjm9Cc7gYsJh4kflZmEi+TN26Q2y81YDnJD3W3ePpAI6ljINS3OZQ5?=
 =?us-ascii?Q?WwySXpvyShFFiDa01DDAmNuuaJSVHc443JY76+TlX6TDPTRASBc/27atnFEP?=
 =?us-ascii?Q?SKGlwN2PBoPX+wRA0lqJqcVuYtqceFKSsB+w2EaUscK8d+hUDPlZrfAwIhLS?=
 =?us-ascii?Q?A83vzzX8YUXSZV+NiwLLDL1Tp90zk4a2mgn0wCS0piXwf1H6rTbIa0DOr0SV?=
 =?us-ascii?Q?kaMUEW6AHaDbg22KL+jjzaLHfg+jcMmVmFUhDpsUEkyxhG6gGcH8nWhiim+O?=
 =?us-ascii?Q?Kyx7SX8ZpOp6U34WbUq8N9oL4jpSNin1YdR3yHM5pzn/UbghzcRNds02ruSp?=
 =?us-ascii?Q?B8SldmLy5twzRpci3Etlp8aKnaKWO7oHqaggRYavgkqMK/hwAwNIHoVD51La?=
 =?us-ascii?Q?LGE4x/ARaNW0DhrYjsR75w3k15Kbwo6XZVLXHlAlL8Omc6tft7z1yN0Hqe8F?=
 =?us-ascii?Q?js2Bkeh+tDEPC2DGOpYHiQlRIJXD2dVnMFPcl3/NSB7CTTXTjlush7Bcnnbs?=
 =?us-ascii?Q?PbgSP5Fd2MoQaklJA8t4EhG/J7JyGVQaq5W5esuRk+89usbl+/9szCracfhm?=
 =?us-ascii?Q?8AxqjZLNLXP1Hb2AM+RTF2bR5rvvB5vBtFGXpu+hFQaVRZt6xMsVzU11QWrI?=
 =?us-ascii?Q?GIOft0imWyQLHSFSYthjq6qM8MBSUP7GIe0pFV/xslv33MP8EjLD18B6uPJ2?=
 =?us-ascii?Q?MAs/XQFWQ2thzyJZkCUbmHYgQrlYyvEXJQFE4vuhRpQZV4L0IH8Qwmp0w7wq?=
 =?us-ascii?Q?1nsZCAlJ7nKdzawyKmlpEru0lC/GchvAPgUQCBPVeBAfd/FalEjEriXzRUfc?=
 =?us-ascii?Q?s3rBYwp9AAk3Ceg5traOom5KTGgnQDrcAdquh3noFlW9IAtDgGIbY/SXGaf6?=
 =?us-ascii?Q?zTf/j9J17R2V1L6BnzM1f0HItj7P+yibPPkHoYIiqOyzG+qruPHdiFOAp1WY?=
 =?us-ascii?Q?owK42DYmPVo99rhECwy+OeuyVkx0Kugcgg/FPLbiALmBQBmujHDRSDwXHhI/?=
 =?us-ascii?Q?OfGa18LhkMACpaJaPvZF567P/h+s9byOERV3rj4mFNNG0T2zuSKhFXsZ/ieR?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e66447-6c52-4574-16b3-08de1ffaff51
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 01:46:42.3704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQj3uRi7IhtGApGZ7WGvCm9x7LiWYU7rp55bYPgawXeN/lxE2oBLDzVMzXvyQthjEn/BcaGkQAJOirEKraW7+506gba6/wI1k7Lcv58MIhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6498
X-OriginatorOrg: intel.com

On Tue, Nov 04, 2025 at 06:42:40PM -0800, Marc Herbert wrote:

Marc,
Thanks for the review. I applied all your suggestions in v4.

> 
> >    [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
> >    [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
> > +  [ 'cxl-translate.sh',       cxl_translate,      'cxl'   ],
> >  ]
> 
> Just FYI: this now conflicts with b26e9ae3b1dc. I got very confused
> because I was missing a commit and kept looking for the correct
> "pending" branch when in fact it's v3 missing a commit, not me.
> Also, I forgot how clueless "git am" is. Even "patch" is better.
>

Sorry for not including a base-commit in that patch.

> These lists are a regular source of conflicts when all the activity
> always happens at the end. Defining some sort of order (alphabetical or
> whatever) reduces the frequency of conflicts considerably.

I've started mulling this over. Alphabetical caught my attention
because as our list of tests grows :) :) :) scanning the results
in order appeals to me. The part that is not so obvious is that the
execution list is not built strictly from one list. And, off course,
when there is a conflict because more than one test was recently added,
it's usually a simple and nice conflict to resolve.
