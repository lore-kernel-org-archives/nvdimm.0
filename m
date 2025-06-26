Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F682EF9B1
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 19:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750965603; cv=fail; b=UPDphxFLfm+1Vy6Rgck1QFYZC04afVwdMw4vdoilFuD1Yv59muAeL2qHn67vjKfuKSbq37CvmXqiq79XwcKxg07wJxFtmqolmVXYkqRJasiehty/vFKRCDuuruO+XM+JUC7r9l8cebt6zHcETZnyLBt+Vv5yqTNM4r5mw28Wplc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750965603; c=relaxed/simple;
	bh=WSaa1CTLMhWqfAajq5caUohdZYPx2JONazVZQn1NCAQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Cwt9Wjto8Eja6DrISBKVCK9RRHLp7OXjmrY9uVc/L5nTufqXubyjnsZiiuSGfnmrgcnV1jxXLz3pv8Tz7esdVzAuYsGE1fbdrWmzPSl+CUUBq/PidTi10lIQeqforAoTQ1xgzuX6uYQHYKxHsOlXvnZCAIXKDHnD0jhaw0HmG6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=co2oKaua; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="co2oKaua"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750965601; x=1782501601;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WSaa1CTLMhWqfAajq5caUohdZYPx2JONazVZQn1NCAQ=;
  b=co2oKauaDvXKQUmEfJNxU+TyA3MwOyFL/LRiAzFgWuPNHltZcnCNRNB8
   mnkTX97YIhCfIGBGuv4kwLIU8yM0s4J4ZgLOmt3TEyZs88B2T9mnFfGXy
   O9vV/oJWlOU3Zm4yM4XFvx49+dSW9I83WA+o4xw89+I/HwvmQHrk4LUq5
   GcFI1kIJwJMeH4916mavXRxEotlzqDBWh4ukl1ypf1Oqu8sFmtGZV0sNE
   /urKM8EHa+RzU3ER/muZxQ9eq2KUqrYOJStxKOpOD8ZWS5ORX2/UPrN6O
   UFZggJ6+1XeOfNtrp6/1Jzg8010yoZFLACKzsTondYbXoa4vxGptAV+sB
   Q==;
X-CSE-ConnectionGUID: Jn+ZMr7YQi2NKbpFGhvk5Q==
X-CSE-MsgGUID: 1aIv9VWdQGKHcVSQex7XpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53240044"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53240044"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 12:20:01 -0700
X-CSE-ConnectionGUID: C/SKGhg9Qd6w3Prn3XM1vA==
X-CSE-MsgGUID: 5wgoqunxSB+qBZrtw1ANMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="156631098"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 12:20:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 12:19:59 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 12:19:59 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.42) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 12:19:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQZ6neBbm70bgsSaHzj+c5R15ex/BSA6W3emiF1S80391WGtv3PGGRQItg7odGblY4EUf0Cs+bDaH5cPsKim5Uvw2r2Up+d4cBeUNOcsGwhHgzPPnCTzgYxSqXnxBRWlzxk0nf6epJpSjTJXNMd1iiALg3bu39Ridxvic93EzQ55TAlelZLPVsqfuuZ/LnjK7S69H+o5mI5bea+vuQwgKWfm+qqKzuGvhgw70le2xFfM85s3TDcwJahQH6LIMx29S6qEcpe4vm5vs3bkbU6v0olteXq/x6d0YQjxbU38WDmb8Z60IW5sx0CvqRp+aO+9CMHN3iPS+sVLnzReHrIBvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/IdORhHLBydu4ss2c32VIWGDIE1LoSHYeCMtz0m1vc4=;
 b=fLBFJ7Yr0Nr7bqnoqwpINMkblqUBNQsImiGQfRsNCFQe44kgxIvq5A2bOMwR0rDa+H2MLzP8wjLwRl34tv0N8UEeMHSAYnBZp2PCSsX3FeCZRbSsPQWWGcZHidKzvbYR8XG7NB1v9HqSMaNYjVT9IGmVlYywDggXucWWlvGp9lRdMxGyPi9+WBeQnUn2Sl6PSw0Vdj+7obvus5UDIN4viLu+g9izp/YPysELFAfa9tGlxdLZQuRBKraKx9aBXw2cZaDJLmXyyNQaM68kJ8UWp4VWMXNftH79pjOMSjI6DcaN/ZyPknl6rtbeXJXfTjqQSmeVD/lbb9VF+Obtb/XdOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS4PPF7CCC4B437.namprd11.prod.outlook.com (2603:10b6:f:fc02::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Thu, 26 Jun
 2025 19:19:55 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb%7]) with mapi id 15.20.8769.022; Thu, 26 Jun 2025
 19:19:55 +0000
Date: Thu, 26 Jun 2025 12:19:46 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <dan.j.williams@intel.com>, <dave@stgolabs.net>,
	<jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<a.manzanares@samsung.com>, <nifan.cxl@gmail.com>, <anisa.su@samsung.com>,
	<vishak.g@samsung.com>, <krish.reddy@samsung.com>, <arun.george@samsung.com>,
	<alok.rathore@samsung.com>, <neeraj.kernel@gmail.com>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <gost.dev@samsung.com>, <cpgs@samsung.com>
Subject: Re: [RFC PATCH 15/20] cxl: Add a routine to find cxl root decoder on
 cxl bus
Message-ID: <aF2dUqGKcu8-rwaV@aschofie-mobl2.lan>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
 <CGME20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8@epcas5p1.samsung.com>
 <1295226194.21750165382072.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1295226194.21750165382072.JavaMail.epsvc@epcpadp2new>
X-ClientProxiedBy: MN2PR14CA0007.namprd14.prod.outlook.com
 (2603:10b6:208:23e::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS4PPF7CCC4B437:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b701e8b-2631-41b4-f872-08ddb4e66eeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ef+BRO82bL7/iQFA3R2bNp0gbJ6Rj9cnb4C5Wx2B7WKPeDbHVJIHqDUtpZTS?=
 =?us-ascii?Q?+jUPNz3mh9dHVeR34F0axmv/wPZ3bpMGSIsHH5lr7p+1dJYOTQoBULnQPAu2?=
 =?us-ascii?Q?hoxXQKmlbFPZXh4B0OBt3/bdTF9c+ip2Vh/4+xkVyUI3iH5ORiTnzrmtjxj9?=
 =?us-ascii?Q?16G4YGjXSIYTDP2Otgk1615DnXQSqD44rkxdJLZ8bnq+onLIVbvjjTG6YuFJ?=
 =?us-ascii?Q?EU2Y5CSjwgV5xZd9Qx7LYZlAO61NzhY2ZFcEjRC32gfVUvEHHS1oQpSCoYLH?=
 =?us-ascii?Q?3u+QLb4d7TmoIZ7wrMTbUbDY7ELZmX9ocicwgfktid34fngEiXFOQ7Angc9C?=
 =?us-ascii?Q?JKUUATq0/jBwSscCZkC1ffR43o+mPX5lDaRQZL+FvUYgq7dPiGYBd4nlZd/I?=
 =?us-ascii?Q?pEGYqRrsdl3i18gnbgiuvLSWKifKBa87cSxbiKkdusooxiagorVBp4NqavOb?=
 =?us-ascii?Q?R8MRw5ZoicPT3JsneAIseG4bxzMpKkTa1a+O9UQTvhl/2vBACaJWVBD398aa?=
 =?us-ascii?Q?ZAXKRIlX25b0ZtvvKM4WPKZ6s59j6goe+Y5/nCHqzJNJOQlPUOMXYRKfaeev?=
 =?us-ascii?Q?rFCZROl2rC9TzDgthIPB8WRqnFZAikmcobm17GQqtxxwoVd/6HqmLq2W6WAF?=
 =?us-ascii?Q?jXhT3apmoQSMe4zBixIE+bVaQedKMtdMkUYJmeePyYCA5LJgqi7aFLZ7j+fH?=
 =?us-ascii?Q?eSzOozbNX02fq0bhclE1Ga1C1kBfeHe4Ol+JHQFsIS4sIJmXAvBSijT+W5yJ?=
 =?us-ascii?Q?CeO8oNysX6GgvauIiV8p0NitfawCQuAXVXrCLf+OGKI8PlY94EYT2GpZM6c/?=
 =?us-ascii?Q?Zn1a81o+OWYcBMqQBjaLI4opE9wl0nj/vk6h3m3NTETS4TkFkQggWYrzG96O?=
 =?us-ascii?Q?/krPUvCnOHKsn+amiNc8T8JsNR7CzctzKkFsMlKDQbUK4PvHQMYfkOX/9X2g?=
 =?us-ascii?Q?Y7oQmho51J/OsR+ur/eoSBoLzTVlPLv9K0Ac3pReduZo2ZuunkqbLrNF+8kC?=
 =?us-ascii?Q?Zb7ui+NPdOxJUaVJj1PSyAf8StOtoXdXP5ZzM1xf5dnVraNDFYkHfvpJ9Qyt?=
 =?us-ascii?Q?QK4oeQVPB+HRnf/JEE4C2w9ji8qIk7BV5gPJH9rBgj/pwKTbNtRB9o/tXt+q?=
 =?us-ascii?Q?iI4rB/dmpWWS+JJwXZsMw7QQFkZ8i+mEl3RvO14OYNdnEgFleGLlMFHCV6yF?=
 =?us-ascii?Q?mSmgmGUoQj82G02BxrCiCU3fqLdDP0ilcUSo2fFtrIIeAXu/EY4tzUMYy+TD?=
 =?us-ascii?Q?ms1D1QLTpf4ibQslJQw7EIaNfyWD1IVwpthBNE4dtcmodsmxUuMMIBt6Gxq/?=
 =?us-ascii?Q?cDEVy1LU2i62dtuiNYYPDl9X6UjWb0IeCb6Bm2kM6gMS30cM7xtzERe+cnkw?=
 =?us-ascii?Q?xYMMu+aTTRwSnoJXm9y2V70HT0tJxAq/knk42vaxFTKA/QBVBQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mk+DDpgpjBoifNffmj0/wNFgZt4opLvBxFow748x45kJm1xOZ9EfLPktAcjc?=
 =?us-ascii?Q?N5Sp69ua4qPd9D1UJ2ms6O3GSJ+NWH3QUUE0gbve2pvFP3Z9rNp8LVLAACI4?=
 =?us-ascii?Q?+JbbRFSsJbJmsMmkllLe8TUcfy/kZ98U9qJfElEAqEg0SvLM8tC5k/QpozxB?=
 =?us-ascii?Q?8Ewu/b2dUPbdPNx7ZrZoTRpn75OAsj01pen4X4tuXFvYH0c/9iiFGm8TyFgF?=
 =?us-ascii?Q?cTB7I4c9s6tHZatf0sadJ0F2OxF9f9Ccwt5yi0bvW+7e3kaj5RtShMaL1JEu?=
 =?us-ascii?Q?+X0z0rFtcG0fY6sZtL2AyNWjOwuoLLlBo8fQE/nAAcIt+iCWAUEKihFuK6Zm?=
 =?us-ascii?Q?7Z5GdtP0j8kf0e8B2nvtNMhJs+wtVMOuDGbhN3j63eiv4Ly6rzATs6c8RCVs?=
 =?us-ascii?Q?AKbSBGopSWHkNEjstPrQ//c2UXzZkHNZ/vjuH8cHCeUndStdTtyRTLA30xT7?=
 =?us-ascii?Q?6Tg+XbOv7/wkXs4i9c0LowbpKJY3UIqL/E/0lkPBlv8ngqrbAYTqimOKE9AE?=
 =?us-ascii?Q?LoOmdbRWHl9NbAzamjxwORA9om5+wIR/kSS5MO1PxmZViHBPjkYylr5xHbZ4?=
 =?us-ascii?Q?SxFjascCL5m7oTcvTvsAb6u7/DnuC0etXKMlRIFTEPwCDiU38JmzitZWXKaQ?=
 =?us-ascii?Q?1cg5PAr+IqJO3AxKn5v6scJ2zHbyS87W7mnq/YLMTm0QPeFGw/VeftAd+yz3?=
 =?us-ascii?Q?ftHPAy9yVTs2gTz2emcdu52AK2GDNpNLoysnIgvoHhV/cp+cqpbXqbT3nkG6?=
 =?us-ascii?Q?A/zctvcjWa9uKqB7p25GaOTl2tviWa4H/pErtuWg4pyd+Th2C6oYMeSXVg+k?=
 =?us-ascii?Q?5wDYAtH3evt5POhoFtuIC3V6tqzzxfa8gbNcQ8p41YMx6nCrUNRjHRqNSl3V?=
 =?us-ascii?Q?YguezElUPwlvCcAl4Ls8ZoYC0i1hT4VP9eYAkVjSqg5d6p1C/lwSsO7VUkIy?=
 =?us-ascii?Q?pdyj1r+D8mFQB+JGkrOd/1+I1Q0Xf/Yt31mxmCGGe6Iqc4NN8pIrMDvDPB83?=
 =?us-ascii?Q?TxfXILL4s1clN44OAgwzL9nQn0hYZZIgI2TBpkbP/S3JtOWnOll9YqwNuDpu?=
 =?us-ascii?Q?1FXn0d9gxFa+hu7Er7tQfSTNagRQc9Lz0IA/4c0Tiso3wGTtKTIl0epIViaU?=
 =?us-ascii?Q?6Pbgyglu1Omd7rIe+t6qwvL4YaCInI5uVX1vXrxlplfhG8S91gLQvjilXpfv?=
 =?us-ascii?Q?ny2cUG4gv7Lhz21n3MAIJICmx48wVT00Vl6F7MSWjf4q0GfFUfWWyr4FFVOT?=
 =?us-ascii?Q?kGTaZ1dALAcyOZVoM0UejffG0jsnnlZIZKF/AMTLA+Fn0yv1zqpIrmxBnEUD?=
 =?us-ascii?Q?CV2IdUHCHYbTKdts4EwD2fo1M2uO7AkHuu4vGC4kGZkTiRrFGdrD6ysg+PU+?=
 =?us-ascii?Q?+xLyLdjzxei3JigQUSZl0vDmL+5BUNZB1Qxee1p80/e7KjqVLagViVYz742G?=
 =?us-ascii?Q?mpTJSwM2yiRyrRVNu2ZaXhxBF12oL2sDcRZ4Ut/gPeDg+Oxy+o8qMakCOFPV?=
 =?us-ascii?Q?rnUgMmsAIJa/udj8sc2fqsNXK5YqKOg1w+yrQhsAXfqcqrGb0XzxGsDLOMfv?=
 =?us-ascii?Q?nwpFBzXJ8fgoNt8DJlQXVTE58X2UNzv3rHnVBfG99HH9CeVthgMWfXCz1FLQ?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b701e8b-2631-41b4-f872-08ddb4e66eeb
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 19:19:55.5059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94ysATHH3pWCt8pEeorP/qD7ReXtMuE+YXxQ9G7rfdvR6hQ/05fvo8PRj8uhuvNhvnu2RDSxWlX1NUmo4Ww3Eg1c/TfEYFhLPg5ICAYAb/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF7CCC4B437
X-OriginatorOrg: intel.com

On Tue, Jun 17, 2025 at 06:09:39PM +0530, Neeraj Kumar wrote:
> Add cxl_find_root_decoder to find root decoder on cxl bus. It is used to
> find root decoder during region creation

Does the existing to_cxl_root_decoder() provide what you need here?

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/port.c | 26 ++++++++++++++++++++++++++
>  drivers/cxl/cxl.h       |  1 +
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 2452f7c15b2d..94d9322b8e38 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -513,6 +513,32 @@ struct cxl_switch_decoder *to_cxl_switch_decoder(struct device *dev)
>  }
>  EXPORT_SYMBOL_NS_GPL(to_cxl_switch_decoder, "CXL");
>  
> +static int match_root_decoder(struct device *dev, void *data)
> +{
> +	return is_root_decoder(dev);
> +}
> +
> +/**
> + * cxl_find_root_decoder() - find a cxl root decoder on cxl bus
> + * @port: any descendant port in root-cxl-port topology
> + */
> +struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port)
> +{
> +	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
> +	struct device *dev;
> +
> +	if (!cxl_root)
> +		return NULL;
> +
> +	dev = device_find_child(&cxl_root->port.dev, NULL, match_root_decoder);
> +
> +	if (!dev)
> +		return NULL;
> +
> +	return to_cxl_root_decoder(dev);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_find_root_decoder, "CXL");
> +
>  static void cxl_ep_release(struct cxl_ep *ep)
>  {
>  	put_device(ep->ep);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 30c80e04cb27..2c6a782d0941 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -871,6 +871,7 @@ bool is_cxl_nvdimm_bridge(struct device *dev);
>  int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
>  struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
>  void cxl_region_discovery(struct cxl_port *port);
> +struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port);
>  
>  #ifdef CONFIG_CXL_REGION
>  bool is_cxl_pmem_region(struct device *dev);
> -- 
> 2.34.1
> 
> 
