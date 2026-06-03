Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2BC168BD
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 00:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780445492; cv=fail; b=bWU6xxzceT62onB8KAPX29o2EDfkLm9jErGaj1b57ktZan27SFHLpsB1RvHraMXM1qxpJYPxsnVfQSuAFWagFmAU8Bk5KR3dyAEHXzO3jvBdETjNktaL3xM9rLzcLbeyQtkz2Wl5VlydzZBzBrAp5Mcv91jUCSg59lo8EjFIL4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780445492; c=relaxed/simple;
	bh=qj6w77ORQlZ1KMvRkifk/S/qzBpe48ypwaxHg4we2Ig=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CJ1H0b1m7HN7ht4KQByYncKG+k+gtASUF6ZisCUXXn0gmZb7arx+ymHwrlIs2uMMCWB3vjCX9TcrsleOitNQ1pK6mwMWNKxgro0bPIx800YKD7MqqIVjUbfDssT7+g/hzA9mnA3LT8uQPzf5U/N2PREMYD5n+scRABULpnI6dfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MtzNUEjf; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MtzNUEjf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780445491; x=1811981491;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qj6w77ORQlZ1KMvRkifk/S/qzBpe48ypwaxHg4we2Ig=;
  b=MtzNUEjf6aXZF8cUYvsgaxnONt5ifzwtGfAym8VWre7tREDofcsoS8h1
   241YumthlTGBAtm+8pO9HgSEHqAQYX8Ngvbu+Bsx4K8fn5ACcly1CgAho
   v0gOK4pD3sOnCdiAkmgJTr3rC9NH6RlEjHOYxReVDSnchHrXYe2FS+3xE
   FNUT9zdmukFjXwJTK9zrSsDAPgeUbzE+VXLaeaqPDqjipdRlhza7E0gxF
   uXXlSdLGRmt/D2fd0C0ivgl6Kkzmp7gYss/UgOIx3IsyJtyc/kwpFJIHW
   nitl5hl1yjBYFXMByMm4rPus2OCcl08TeK4FluARD6yYbEcIjdEkOiZwZ
   w==;
X-CSE-ConnectionGUID: aQ1ImLQTTSKVfKuNDe1Arw==
X-CSE-MsgGUID: 6oVEm5IWTXa4Ecy+Ib8t9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="80274466"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="80274466"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:11:30 -0700
X-CSE-ConnectionGUID: pf0Ub1SQS9uyfUHJUcO3cg==
X-CSE-MsgGUID: qPMkQ+BuQWqtdg1nPj/nrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="282168306"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:11:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:11:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 17:11:29 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.31) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:11:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lsQuntkYY0HOEIghnOG+h6808hJRsJCoJrHaBUOaIl4lCjyI0JAwXjyBVQxdveVanP+SHz+nKBQhU4fjGxivSFjKdonZzwltcA3SdrvpFyDaQvk6Tf7ss0ljzfvCpaLf0jyHVgHDow04kVAt10BpxrA5kGu9C9tDy+GSeHi5oD3/nWvGEhI8ptWTp2n4R1HHWPJ5+yBioGuaemojzSReDtyG7755djIiXJvv+Xc3ze12dt0zS+H8EhFzZ0mOx1092aTD+5KacoSs1iLjUlPoYwLIdbzOmYS50E8AzrhulaOuCYxlPxV1gjD0drQdRga6qkA80re8N6pQb+8XSQ/HVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ic45Yqh1SBPtD+jR4ERbdRLS3Ywv+fI81ZQTGrkl2Q8=;
 b=iz22bfZsVy045gKVjHQuLAfMIyji7f9FCKymRB4cmcR8fTJOqOytGvC1WVRAccnWW+vj30z/CkYvUiW392G6MwPxNY9pqQsWkzMfP/XK/wajAadqFZBEIuShR0b1Tvo8srIZ1IkWELi5MxEVNDQknPR9KoiDUcP3J/TMwANsE9RvRoiW6RvgX7nO+Yjx3k0I3KOFS8NAJyDmAtkwWFw+QTEgykd9kzwNG8Ca6wjQINkOVlMyfU0nDOc40e5TknJGDXW7xO7BIJXEMoxopzma79YaOHvyMowwMO9N3+BA4qsVRUibwkpxSuB+q61oXBL+VaA/lIzt9auTWiJNJjxlDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB9511.namprd11.prod.outlook.com (2603:10b6:806:47e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 3 Jun 2026
 00:11:25 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 00:11:25 +0000
Date: Tue, 2 Jun 2026 17:11:16 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, John Groves
	<jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Ira Weiny
	<iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V3 0/9] Fixes to the previously-merged drivers/dax/fsdev
 series
Message-ID: <ah9xJPEnNCkmzk-w@aschofie-mobl2.lan>
References: <20260530164953.6578-1-john@jagalactic.com>
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0PR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:a03:333::35) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 365d77ff-afde-424e-c9d7-08dec104a69a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: phxQMwCTRj4IpYIE2bs5IO0E3v1pPJJyfaddMYT6LtZ1o/vONtLUKvUTpvrd07wr4Pf05AE2AOVfLRE1D5Dk1jbCHayMCwnCHcsJkuHH6jKtHyafWby4eNaKkPwQzvbZ41tu8uSSgF7p6zwtHhckJzPLhSC17ngV3Iv6NkrsKU/9YcX7PkKBZGLKZC1EfyGRKM+yrnUaGvUgnZpPTOeP98aNO6p/7jx1pEUd2Q4h3z6rSvekbzyvwNlLZNaT9Kc+UiEbciOwMd48mO7KqnYL6od5WSK2FmBwchhej5Jv9dPOJT9hpO57LML/YBQA2QUpYfCvvK1CRgp7Y1+sGUT+qfICp6PdGbCrf+PtEHKJKmwsAM9XqtGDNgRGVROoozmt6hpvCbkAs7hduqCwxe85hMTKyZoB+IZpYw8RAfHnqZN4U3yxsocrGCVsO4hBt31GTJa+aW8Wb7U7ufN0xkBzreaSmfwHD4plO0ZPO6Ui65iEgB7gV+32ZBEeo5arhvxP6beAC4e82dslc8m9HsEl2IQQxuxHe+kXvYZe/VO4n0Q9LRIyfdfBayrQipK/TihPkZsT20nZ7mETZpFsbNaQMRISC1vTDWTpEazC0md4dYrXdE0ILYl387IpWKDOSNT7f1IzqtMF4jMt+5Zz8i1UNPgvA5rnQVIZA3RkUrO2rDKywu2W5gQ+u+GnINBLrHWu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jghOUChhVc8rOBd+NqxK/9sKZ6kOgElectuBKkwcg5V6Pok/aymd3KJjzl8G?=
 =?us-ascii?Q?kIC7UJ6J9HlhjkQX1vWsK5M6BANKc4BUnVbsolP2uYxnhopa8Nt6XpliIVD3?=
 =?us-ascii?Q?cnX/su0vPtrrdjsTSAOr92uLP3Qn1fGXqV2A4+uPwz4uBuspK7ta5JYwTKq8?=
 =?us-ascii?Q?35iGk4Zxe3o/gu3rqCwAukg0vuErwUe8+XKsPd0kYWwAMe4Jes1ZPli5Vp1V?=
 =?us-ascii?Q?kBYpwdp39a/XQ1YQlp6nw7U7g0OZWPAYXRybk/+0y0bWCOkWYo3Huybmm60L?=
 =?us-ascii?Q?fJ7qgmzltqlkPBx4P9/N2+Xi9DUC34blg2HqN70RO/pkTiDvkRhfPd0Smqyd?=
 =?us-ascii?Q?uTjcgfibLijXp7WIOf9gOF0bOXHak/H9GqFfolv7hYd+spDS3dPhwIe7iOyF?=
 =?us-ascii?Q?y78Z+Qya03aNu77MLQEsjw0OllJ9FwIziotvrumpjbKa4PJr0Z5F3bcv7wj5?=
 =?us-ascii?Q?6s3zzr6tsjkWBvArb/b7CdC0kJqLC9Cr4BVV+6MMSZSAm5fqGVI0/4ysObKB?=
 =?us-ascii?Q?BC9RQ2FG+8IR5tgPnahX5rwYF8dwgbP8ZaGP0htZyH6/yMOo2O5iZIN/qgNu?=
 =?us-ascii?Q?WTj2a/mlbAsRg+Jx1cjF8KlGaONf97sWVtPam1uDxuHPQA+R4i8ijiD1RNkb?=
 =?us-ascii?Q?+UPsxEC9+EdVOuf5VUqIWDUqxIUzKiEFjCsnzGigsi5eMuvwZrFjf6bprNGV?=
 =?us-ascii?Q?6QPD4wbYH665XaE7t/zEMSuyFHdgFNC1m8205PnHm31HuZFWHKFPp3jcFkFE?=
 =?us-ascii?Q?RULZsF5Qgly7io6I1vkMQDBshSE/+DZDB3AHRJaN0m3lR7aIyM7CybNbjDN0?=
 =?us-ascii?Q?YqZ7qH/InGqhE9wPP/kWxEnb2mwa63DiJyAm9jHeF0jzIi8Wsl006ShudFFW?=
 =?us-ascii?Q?ou17FZELws5goxZ8RM265G6aOffQHgZ/Y2Ij1oiaoR4c5973h4SzjbddELLc?=
 =?us-ascii?Q?AOORO7A+ptJfKbb/vJFks+Yjeb4G1m4c8dJi5WTs7mgo6+kCZze7sKQ9FFD0?=
 =?us-ascii?Q?dArNPywAkG9hzttgz1wGr2ThGDeWuAvjK4AAaZ61pLlEUuRJW8WY0Smj6TZ5?=
 =?us-ascii?Q?sDwEs+jYWuYaOgie/TT4Sxvic7eJFp0Zjq8BUdqQALfM2iprwKduSj19pGR2?=
 =?us-ascii?Q?MBXr25nugXs4TG4571n8qe0V+XtWXbSpGFUZgGB2X1ayJpxO4fKM6mMgwJic?=
 =?us-ascii?Q?iZU5HTW8pEOxuZowe8HAxifAmjTdMD3y97w9Vf5IB7yynQIN1YCSOi3KU0ZC?=
 =?us-ascii?Q?cf3enfEW57PpM6ijIpbme1QTOWA4U2gNN/xOuPMzplzlxE88mDPhxqx6s/Vs?=
 =?us-ascii?Q?25oDMOx13t0do+joYAZWc7j/YZUTciL+AbByL3Tr2DS1gX/RQIMf3ZxfLehD?=
 =?us-ascii?Q?bUu231mQTnrtNDSTv6FP4yp5BVsveLNldl006ALn066KW4xUtAY4e3mC3hyK?=
 =?us-ascii?Q?Ul9ASfO+8mrDmEagq3IL7qEZbeJVP9AFhun6B3v9aHghi60OgV1JMwi1qokI?=
 =?us-ascii?Q?ICU+XTuNegWNxqXxpNvJ9VywsL62B7+zNUd2Ppw1ABu/AfZpWPfsKC9WJppu?=
 =?us-ascii?Q?S44YBULj8fTx0vPo0tFRBOuKMGlkx8hl3Usa5uHMwURWpws84ojQF+3ks/pg?=
 =?us-ascii?Q?qoDAXDsmyUwOO6tVWSupeB//uOU6P6nDaThPp3K06Xssp8at1Arke41uo691?=
 =?us-ascii?Q?W+AGdXzx14XjDbXRAO0KIvjUQxYkGFk1zB1AMAC8curDB8o0eACmSVBFW4KT?=
 =?us-ascii?Q?bv6zcGe3X5pldfIUVBTFI5gA/DDCPmw=3D?=
X-Exchange-RoutingPolicyChecked: WPpS0cI5Qsz3uiLsek9xlT4QWTZnxvjwBWVXMypFFwgAsBxWX2i/ihprBBeVNc7pQgOiOhQ++7js6Y1XZg/ZO+e/r8KGbEV0uKElO7qVBmw9iEHi8f4wVj8EAmTZ6J6pe10JaDnnoJh93HAkMoD5hPCpVgtZ92/81krFxbIL5/5Ji+DivPo/HeX65HQ25gXKjRVcVNLFlm9whAwDdHsWCN706U9TyP99yTJtGzwdJanHTaGMbNA+kzRWfnrMk70lPzZORn6pRuMuW5GEDjX+oTIb8eksdlNbJmtwpMgNec2vZpuxwQDes2u3jhQpecdkCozkagF0y/ozV8oRPMxBjw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 365d77ff-afde-424e-c9d7-08dec104a69a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 00:11:25.4857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0sk5TZafHkLiIRvtFFsx1sa2unHB464Dwv4iRvpdpMSuTd/kkGk84rE4Lo67JB8pf74S8hdrouaPJyfv1drcg7ukysDIQ+oGacfCIh+Npc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9511
X-OriginatorOrg: intel.com

On Sat, May 30, 2026 at 04:50:02PM +0000, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> This series applies bug fixes (mostly found via sashiko) to the dax/fsdev 
> series. This has been soaking in the famfs CI pipeline for 2+ weeks and
> 1) won't affect anything that doesn't use drivers/dax/fsdev.c, and 2)
> doesn't affect any known workloads - although the bugs would have 
> manifested when multi-range DCD dax devices are a thing (soon-ish).

Hi John,

I'm here to give my Reviewed-by: on all but Patch 7. I'll come back
around after you rev for the Patch 7 feedback from DaveJ. I did a
DaveJ vs Sashiko comparison. (guessing you may have already done that)
DaveJ came out "righter", with a crisper description, suggested fix,
and omits the overstated first issue Sashiko made about the unconditional
write corrupting state.

And since patch 7 shows this set does affect XFS, please update the
above cover letter intro to something like:

"Most of the series is confined to drivers/dax/fsdev.c. Two patches touch
shared DAX core: patch 7 changes fs_put_dax() in drivers/dax/super.c (used
by ext2/ext4/erofs/xfs, though only holder-passing callers, like XFS in-tree,
see a behavior change), and patch 8 adjusts the dax_dev lookup API in
super.c / dax.h."

FWIW I'm overwhelmed with the Sashiko pre-existing defect reports.
I am hoping that patch authors can read thru those and will call out
anything that MUST be fixed for their set, or appear otherwise urgent.

-- Alison


> 
> Changes since V2:
> 
> * Patch 1 (comment fix): No change. Responded to Dave's question about
>   the dropped precondition -- the new comment correctly covers both
>   callers; fsdev_clear_folio_state() does not guarantee share==0 before
>   calling, so the old precondition was no longer universally true.
> * V2 patch 2 (three fixes): Split into three separate patches (patches
>   2-4) per Dave's review.
> * V2 patch 3 (two fixes): Split into two separate patches (patches 5-6)
>   per Dave's review.
> * V2 patch 4 (clamp direct_access / remove cached_size): Dropped.
>   Dave's analysis correctly showed the claimed bug does not exist --
>   dax_pgoff_to_phys() already enforces that the full requested size fits
>   within a single range before returning, making the clamp a no-op in
>   every reachable path.
> * V2 patch 5 (holder_ops race): Use WRITE_ONCE() for the holder_ops
>   store; add WARN_ON() on the cmpxchg result to catch wrong-holder and
>   double-put API contract violations; fix the inline comment, which
>   incorrectly claimed dax_holder_notify_failure() consults holder_ops
>   only when holder_data is non-NULL.
> * V2 patch 6 (dax_dev_find): Add dax_alive() check under dax_read_lock()
>   after ilookup5() to prevent returning a device that is concurrently
>   being torn down by kill_dax().
> * V2 patch 7 (formatting cleanup): Drop incorrect Fixes: tag; add
>   Dave's Reviewed-by.
> * The series grows from 7 to 9 patches.
> 
> Changes since v1:
> * Dropped modes from patch 6 to fs/fuse/famfs.c and 
>   fs/famfs/famfs_inode.c, which are not upstream so it broke
>   attempts to apply the series. Oops...
> * Added patch 7, which addresses a previously-missed review comment
>   from Jonathan - minor cleanup
> 
> John Groves (9):
>   dax: fix misleading comment about share/index union in
>     dax_folio_reset_order()
>   dax/fsdev: fix multi-range offset in memory_failure handler
>   dax/fsdev: clear vmemmap_shift when binding static pgmap
>   dax/fsdev: clear dev_dax->pgmap on probe failure
>   dax/fsdev: use __va(phys) for kaddr in direct_access
>   dax/fsdev: fail probe on invalid pgmap offset
>   dax: fix holder_ops race in fs_put_dax()
>   dax: replace exported dax_dev_get() with non-allocating dax_dev_find()
>   dax: fsdev.c minor formatting cleanup
> 
>  drivers/dax/fsdev.c | 81 +++++++++++++++++++++++++++++++--------------
>  drivers/dax/super.c | 73 +++++++++++++++++++++++++++++++++++++---
>  fs/dax.c            | 12 +++----
>  include/linux/dax.h |  6 +++-
>  4 files changed, 136 insertions(+), 36 deletions(-)
> 
> -- 
> 2.53.0
> 
