Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F0E3D81
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 20:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730840002; cv=fail; b=m4JwVMoE26W0roKRT90BSozJMOCtv9SK9uC5PIJN3r7aDhLSKMjn9nnFej2OoYDWLFQgi8CIUqUeQowZM92bSezy4u1eCEmWWqWLNPBBiRQiGJwn/I+ZZu7Klf67pCmO4U2G2klUKT41twX1hGeSGHR2Zy1uZocznYz9oDleMf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730840002; c=relaxed/simple;
	bh=JkQugRFAPrNvsFwXAMNBBKGWu5F+7+CcCFSaajgvdjU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JCNQE6vB5oTHsApH3ErCOVX+PTybiWkoa6tdMoTaMQL5Xm9tz/+uxgy/O6Ij3ZkkN5f6Yc7rO32MhVqvaSrNebID8mKGec9fy1yMyfjY2ijZx/RhmeGN/oXhPMdu6AiGNelzGoK3dofsOh/IrvYVSpvNikvw8r1xWzySRSuaKnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ky3oLLxl; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ky3oLLxl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730840001; x=1762376001;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JkQugRFAPrNvsFwXAMNBBKGWu5F+7+CcCFSaajgvdjU=;
  b=Ky3oLLxloEh2XsaS43tBSiPIiOyVuZgk1fSB+x2AcwuZUJgSqvkYeutu
   p8eRCJCf/x/8uJ+wvfqKisqWmSk7Lsz7mUgPax1Fif31spvTRR6+CWue6
   eO59tHoDLTCx+U8a19iHYH/2mBxFoOkcQIIjopoPGOEBLOEz9RachhXvY
   34KbZSuo7N2b6vWdbYzzmQ6a4wGk8c8zz5stFKDXw12X8s4ZvSLNeQysR
   iTg+71VsD1Mge80EsSEmRuceM+TtTHlQQA+w1gz7hfHujb57Hj6/D2NKK
   XhYqZi4kO3MrN8YElK9OHbaw6TYgoCuGW5vCt1sjKNchLNeZgSdvJof24
   w==;
X-CSE-ConnectionGUID: zfFywasGQDK5elw8B8vtpg==
X-CSE-MsgGUID: 9a8r2y20Ti+g2i2ufaU1Dg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="41239229"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="41239229"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 12:53:16 -0800
X-CSE-ConnectionGUID: Q+qsCZPASUS29t8aTmbVbg==
X-CSE-MsgGUID: Cay4RadLSamhh7+jjGUzdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="84257481"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 12:53:16 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 12:53:15 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 12:53:15 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 12:53:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XfzHLQOz4BFP4Z3cFGW5dKI690+puYxHR4jhip3cTqNM7a5G8HZamZsJ5SNU68HqCcOiIgmT9pCExE43ECXnDWWQG+Of/hc3T5ou4o//GGcE5I9SJYioJpo1TF/o5F3KO0o35M0X69RjQapK0MipO1j5zoIE9dxdrQGe4SKb8cYauUTDw5s7pVeTgxRaosyNc9p+eG4fWH8ZlyPy1XXb+anZ4lUnSXrqTGTABBRH5Cag9fen/97m9Ddktr/tm4WdbYvCF7wOlG/mf17NGkEjehFTiZgRanMmR9D243Tvz0rX9l2dop7FC3ZQzgGSJ5rsW5suEDb7A1ms9LPJlD6mFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SS1eqViernaFR0Xy5QiJ3lImFw5XcRJDlos+o7bTQKM=;
 b=BXaBZwRRjp3LpUSOs2U28dm/i7mz36PAtw+/uKJSdU/H+VGj+flQhqGiy4hyNOKpwPgzYY+VIezZvYKCW2y0DW/3O0tKnqtBXt9rc+sUKqCDIDl8cN5OxsjEb03+nPW2mjJHgV2qWdkqBnnpHbNVB325jdbetctFU8VprF9kXrt7BZ7S8RcPPlPnCQswTgsItb2a/QAG2AHbTcFuTDRtnx/QLnNec0JhoT+jKB3sEg9JaGZfI9zoiiBv1TU/q59T3JdADdZ2PbXQx0kz6ScaCUZMcEOJ/1vLMD01K2FJPLhWfLk8gvBA5aEu2sVsPeZZApynhHy0CS5gv4kMJjTqnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by LV3PR11MB8768.namprd11.prod.outlook.com (2603:10b6:408:211::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Tue, 5 Nov
 2024 20:53:13 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 20:53:13 +0000
Date: Tue, 5 Nov 2024 14:53:09 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Alison Schofield" <alison.schofield@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>, Navneet Singh
	<navneet.singh@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 5/6] ndctl/cxl: Add extent output to region query
Message-ID: <672a85b55559_166959294db@iweiny-mobl.notmuch>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-5-be057b479eeb@intel.com>
 <4dccf252-8827-4d5e-9417-8b52dbed132d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4dccf252-8827-4d5e-9417-8b52dbed132d@intel.com>
X-ClientProxiedBy: MW4PR03CA0116.namprd03.prod.outlook.com
 (2603:10b6:303:b7::31) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|LV3PR11MB8768:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f9a6632-d265-4a77-c453-08dcfddbdd29
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3W0U0e0neGbKQ63dcHfKHPWYQe3LPYOLiMiuxJOfB7DGD33uoX3CO/VZtdfq?=
 =?us-ascii?Q?pPdOV8hfWUdl5GFQt9bqBsektNjqrps7QkaJ0lgPG5XgD7Zk7VcYEKBOb7Ml?=
 =?us-ascii?Q?y58PhFzsgUh3dR3t2eXyoucSewlkVRamwchXTW8SE343iYyRo5/7S46CyoJ6?=
 =?us-ascii?Q?22CfxWjdk2Jm2W5I+lPoq3sQ61CchMqkB6rDgZPlX7Y7oXOumdCcyIGMRjr5?=
 =?us-ascii?Q?D/znT4Kn56qKhFQRF2AzQdDVlKL+Z49UePZnM3oeAQObW+gKbNz0ZYvjYpoK?=
 =?us-ascii?Q?aofrgCokYRxgS/4LUB/YNmoxjHNCGtrF9nrpkGTlGHtiPoaGKWfBm143IrQZ?=
 =?us-ascii?Q?hs0q8VdSzTFimrABb5KafdcdqUdPHstRKyEdsfRirJg1VjkjILnLuqNIFsdv?=
 =?us-ascii?Q?GbmCVBkJEAg2yuvgLShKwipDCvuCGJ2LbOGOcZQ6kNoEeqy+KuOlwRTLyV2/?=
 =?us-ascii?Q?INgJTOGnKEtVMRaWy+GbcICHxo1oi4wZcfGVPWGrmRz//FybdweWX6hiLxYv?=
 =?us-ascii?Q?u766afwJd2XaxHGudjkYy5eRDVwjVlbhwYl8jUT/4RlnfFIQ8A0HE0wnnX6Y?=
 =?us-ascii?Q?MuqpxroS8Vp6YPAlg+dDNLf8F9JArTUSYGynbNEOWw/thKS4gLPnpBcTLyP+?=
 =?us-ascii?Q?h8yiEWrluWH0VyEq0ipBABo0w+C0m1okov9Gxvtwvz1QRu34e7QocJMXOPYo?=
 =?us-ascii?Q?FarV7rZSAF5Wp5NdiBhETN3SA0+pdhCh5jjKtm/95KwVItRf2miW43zMOr/b?=
 =?us-ascii?Q?OANW4jCSOlx0eP5Bk+gwtIAKxRRPB0d8f5L01QovOa3AmwMKm9gptsv5C1Qz?=
 =?us-ascii?Q?BpVGSeaVKp7yDNG2CkVHR6EKgbA5Uhl+O4NmEJkLWl/QroD+63c0tL8wTvOQ?=
 =?us-ascii?Q?8XgK+CX48rCAhU9Hw2hI7zBKgWw/S5pIUQXy5345mG2HBG9QfmSm7ZcyMdJ7?=
 =?us-ascii?Q?Z+XSil6nwOBYU6PDamz9Cdf5AI3hcIXx8tslpMCt8oOyvxk93Qezrjr1B2GS?=
 =?us-ascii?Q?kKtujGtf7nZA10sbhtVPzOlLWHhEXwfk1q1aDFEQLxnK4+9NWp+NjuzaQCFB?=
 =?us-ascii?Q?jnNyBaG+7K4eVPXoAXTJJ1/qtypq6sbX04OnWz1szvBx8UuaXTrFQd7Fh3GU?=
 =?us-ascii?Q?sGFnCUyTq3lkJc5S2G/TLpWW+8/GPebt03NTWu8ZOTqiiaJ9CSHu7qdL6ztk?=
 =?us-ascii?Q?KsIDPpt3nNqbm/+mksFg1pSxLyd56poX4VC7+EuOYqviPN0vxaFk4LfR4zMc?=
 =?us-ascii?Q?n3MaEx48x1PqUFPAXg3+/QDg/TMsnAZqu8PpaZFLsgORb9B9/1/F1McNBFmR?=
 =?us-ascii?Q?5RE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x8/gna+6kGiIP+bD+3CABBAWXM8AUmkc6piQJ7M2pC1Z8kGYLPR4PelpeLT5?=
 =?us-ascii?Q?oAW+yd2SvY1G3Td0rAWRh5EUa5fv8L14BklvMhmqItl1edeyqoMPehypON0o?=
 =?us-ascii?Q?pYv1A7kHqARoVMDDiboTV+03x/7yGAaykK0sfqPWSrzlpGz7Bh46W0QSEZRD?=
 =?us-ascii?Q?y9w8XSdd+HuBglR/wygcscUOgmbIixfObs6yYMLn6qm6YjlyP3DhpNSEjmrS?=
 =?us-ascii?Q?E6Mbw6KHxpXZCONpnRDaxkAabGeDjVypLd3mcgMmXO+hoN5/Q4rUuJoSh8Fl?=
 =?us-ascii?Q?TVSjJt122XeouFce0moN3l8mWLmvqcD1D75jKNqe/lGGoH+V6mcqQNi4HojH?=
 =?us-ascii?Q?YlrGuDXZNEt+IPmofsH5HnyU+VN3sfcv91dHKAGoz84x49EilpKUT5p0z+cP?=
 =?us-ascii?Q?CHmfZ0eeCn6unz+tmLP2NVt3se5ClqVkIKSnTqMaTwawql+uWoBO3bsAXqTd?=
 =?us-ascii?Q?0GTOrpjWXRydp/LRA0nUN3iTzoC73an0m18gqcN1XYhSR47U1T+ULHXiPWfa?=
 =?us-ascii?Q?c2d2PbURbiLtMlYxA0tVyResm+/kGFP0ECwcIRQtqNEjBI8xgxyNn+OghE7W?=
 =?us-ascii?Q?9jaxgE11GbVM3xM/XI9VtPL7KN1HmeQ2B7XzVN1sLz9XaeWlGZtAtzumQDgd?=
 =?us-ascii?Q?4swHNNTmMHknVk9/Gx89xHlqc8CwA+p4z2B+VYIVnwwux/5R7+Fiz1+WR1zT?=
 =?us-ascii?Q?LBFHO/utV2AyGoIaOhdhbr8/W9+ZAlEV841Oa9hRxfY0rtiFUk4t6+Mz/gUB?=
 =?us-ascii?Q?28511r4SNBmCp37+uGvsMFGC43LukvQqNRXtCLTwqzWpt/1i3egqiv5OQP7f?=
 =?us-ascii?Q?1zJWMOYKOIY+fmRFDjUVyEvrusAXK2Hj3mjqKIvScQBh1/lc8MVCej7FYT/w?=
 =?us-ascii?Q?dGZ7DRZdIGa+z/DJinPM8+yLOJl0s4Mp5Vs4sBpr9ZP+taVs8DvyXgrDvf7E?=
 =?us-ascii?Q?pKVcY5gszmpbx6Qf/C8zzRlJmxC2oNItod8LSVmgW5dV5crzaitgbfz5KOcW?=
 =?us-ascii?Q?7tIqHeW0xev53UDY4IJnXdAU9JCaa27iMxX9mvXkMQwbin2YZK2/9oj8ITP3?=
 =?us-ascii?Q?w8lwoWSnYX3oak51p/ri6PmEF3hfKc8YCjHpe6Lgay5T0DDLJJ+02UoNRLOe?=
 =?us-ascii?Q?RZsfBExigDySN2WIXBhjUwo8AHUTPxKB/bNZ3X1xC4L6dLnm1RTrF6AMmb6g?=
 =?us-ascii?Q?V8NYwh0c8Y6cbjp1EB27gScNbMng0W85MvwKvlHDdJOGjNqFng8TGQaGXPbO?=
 =?us-ascii?Q?UYSGAu8Bq7xZ4PYn5QsOwNvBJqdUC63vY1ToODmGuIIud9QFlNHIVyedKooJ?=
 =?us-ascii?Q?JKuU1n1CgcdUroApIy/MLx9muvXfQ/V8UiXqCuJJzoVnd6NVcTv3uAjvya0H?=
 =?us-ascii?Q?pq/7k+NJy62BRPEy+uZFLgR1Xwmu3lhVJv4GqXDroKIZhGTDIudjAB3V6E8b?=
 =?us-ascii?Q?yEp5AuYQfOsOEsme5gzF/icKgGoJJKIwnGtCcPqGqBEGE39CKPdMuT7r/zxf?=
 =?us-ascii?Q?rq/hhNsEXGZq32hupr77MPE+vQHU+pbcSz9/31VYHv1X49xIKT6oHA8q7EUs?=
 =?us-ascii?Q?DT/zXVjEiofMJaMYLK3LW+xPjQi4302v1MgNOZ1F?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f9a6632-d265-4a77-c453-08dcfddbdd29
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 20:53:13.1763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqCMYt6YDGbYtVXc8DJ0hjkyBOs4lkFpZb+M28Y+Q62bp70Uwd3vq7ibX3ets/fhLh8yPU5Y1fUyXKXknpENVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8768
X-OriginatorOrg: intel.com

Dave Jiang wrote:

[snip]

> > +static void cxl_extents_init(struct cxl_region *region)
> > +{
> > +	const char *devname = cxl_region_get_devname(region);
> > +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> > +	char *extent_path, *dax_region_path;
> > +	struct dirent *de;
> > +	DIR *dir = NULL;
> > +
> > +	if (region->extents_init)
> > +		return;
> > +	region->extents_init = 1;
> > +
> > +	dbg(ctx, "Checking extents: %s\n", region->dev_path);
> > +
> > +	dax_region_path = calloc(1, strlen(region->dev_path) + 64);
> > +	if (!dax_region_path) {
> > +		err(ctx, "%s: allocation failure\n", devname);
> > +		return;
> > +	}
> > +
> > +	extent_path = calloc(1, strlen(region->dev_path) + 100);
> > +	if (!extent_path) {
> > +		err(ctx, "%s: allocation failure\n", devname);
> > +		free(dax_region_path);
> > +		return;
> > +	}
> > +
> > +	sprintf(dax_region_path, "%s/dax_region%d",
> > +		region->dev_path, region->id);
> > +	dir = opendir(dax_region_path);
> > +	if (!dir) {
> > +		err(ctx, "no extents found: %s\n", dax_region_path);
> 
> Also printing the errno may be helpful

Yea. strerror()

> 
> > +		free(extent_path);
> > +		free(dax_region_path);
> > +		return;
> > +	}
> > +
> > +	while ((de = readdir(dir)) != NULL) {
> > +		struct cxl_region_extent *extent;
> > +		char buf[SYSFS_ATTR_SIZE];
> > +		u64 offset, length;
> > +		int id, region_id;
> > +
> > +		if (sscanf(de->d_name, "extent%d.%d", &region_id, &id) != 2)
> > +			continue;
> > +
> > +		sprintf(extent_path, "%s/extent%d.%d/offset",
> > +			dax_region_path, region_id, id);
> > +		if (sysfs_read_attr(ctx, extent_path, buf) < 0) {
> > +			err(ctx, "%s: failed to read extent%d.%d/offset\n",
> > +				devname, region_id, id);
> > +			continue;
> > +		}
> > +
> > +		offset = strtoull(buf, NULL, 0);
> > +		if (offset == ERANGE) {
> 
> I think it needs to be coded like:
> if (offset == ULLONG_MAX) {

Yep...  I fell in the habit of the error being returned...

> 
> Not sure why specifically checking for ERANGE, but should be checking against errno for that if needed.

Because I was thinking about strtoull() having odd error handling and was
stupid and did not look at the man page.  If you look closely at the man page
full error coverage needs to be.

	errno = 0;
	offset = strtoull(...);
	if ((offset == ULLONG_MAX) || (offset == 0 && errno == EINVAL)) {
		...
	}

But sysfs is not going to return an invalid value...  So ULLONG_MAX is all we
need to check for.

Thanks!
Ira

> 
> DJ
