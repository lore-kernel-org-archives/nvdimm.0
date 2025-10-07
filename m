Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CD51F873B
	for <nvdimm@lists.linux.dev>; Tue,  7 Oct 2025 16:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759852973; cv=fail; b=u2WdUO7ocTVax3Nl4/hl9xqqWQHhIIHW7+anxWBzggLPDHbHMsDf5r52ojWNfVY7lyPXEvrfMHpJ1US9nwcKsQhjSf2USwKJQVAtuqNSwQvS7w7GMY465V+dYijjm3/oDS6gRYxHFhT+g1RJV6O5ooC/PTaQp3ey8oJlzKOqpzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759852973; c=relaxed/simple;
	bh=tB2jw1emC5gGIE3uumx0CL7fLUhghJ/7vO1X7dRNqEE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V8dhfegqv0/4g+yqkEcEspHaW3+bAqw8aKLSGuNAePEphppj0qssF3IYS4GBthjSUkA7g27Q/cwzJHN4F4Vd1KL0/5tseYH5CXRp0SpecOl0bq0vLCoRNaPWQaZtNNnF53H4L5VuoLUPfGmgm0Y/J7Ug7eEzD8X0iPqMOsAIMuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XlrYha1t; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XlrYha1t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759852973; x=1791388973;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tB2jw1emC5gGIE3uumx0CL7fLUhghJ/7vO1X7dRNqEE=;
  b=XlrYha1tlit7MFzBsiZ5iM8fOULO2Xsy/sJj6+erTwT6fuoa2WG/6Caz
   oxua99IqiOZyIC5Pv6oIMbbQpts17okoz0hcAMzdphwQ5I3lXB4bG7DO4
   nF7M8xGrEc40pdIBL9YMYh7zrOhvuJWMYbSNbm+DgWps3rSRzfwiVb9rz
   YgzmRSz7fEu6JFnyihj5c7Mwx8biYndECrpd/HEduB0BcJ6POWLv1F0Ym
   hYqxoWva2sQL3PHXjWw+VDI+GuR69kLSWHRbdhQ0/bwIs+gw9OR2qkL90
   Vi53gCJaSGoX62B2CU/gCE8hAX7hCzsTTAzK4I6JC6iyLqsNr+v/hpfCB
   Q==;
X-CSE-ConnectionGUID: wlGBoawQR2CY4jrA6bfD4w==
X-CSE-MsgGUID: A0L7vyoaQkWrwqOIPWm5nw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65869763"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65869763"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2025 09:02:51 -0700
X-CSE-ConnectionGUID: CmD94RiiS56MHkJ3yCAExg==
X-CSE-MsgGUID: 44oY1lVVT3WcW0mhE4PKJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,321,1751266800"; 
   d="scan'208";a="184557971"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2025 09:02:50 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 7 Oct 2025 09:02:49 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 7 Oct 2025 09:02:49 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.32) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 7 Oct 2025 09:02:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=II8BBpSS0h/DLaIl0AXsnPV9RGKcq+z3ZLerLjimTzITgXMm/SNOnwI4mphUSTeUgrBNyJvPWh7c7QNbw3xlMdvfep6xfWhtpj44YkOerFM5aAXMA5485zmPX38vZ1pIbmC/ImtLiAx9qx3d1Ug9g9Z9/uCMrkW4yZSYOlaLaO9YIk1pPqlEyAHj4W0MbkCfvqfXq1y1fP3FzORarI3qAU1tkeTdCvJBggvMiE27rwHOMAFe+07bUv2LsxU9oiLZThIvNFz+rARNaZj4rZ3Dwi25sWLYw8flra7e42a10goSmVqCegMMoMLsLUEdsw4HPiOudwblNiZBlKJNs1x+ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGu1Er06GBGzLw1UBKQS4Dzg4uU8ZpjcMV2V2wz1nmY=;
 b=ZtR8hPtx8jGnkuLrVUTui1Nbp9AeOhOpeDUPbiNE0m7o6ACUQSlHPT4fZKpFapBZpt7G3+qC66Pi8V2ZV1K/GJhKYX8hcWe1roWsQqhY9032EFH6Kfj1n/iymkgfXAxyL85yDr+hcEXSeIO57gqc8cEQwShL23L3A21wRhC2ng0rPbFGPwZuXoMG10H5RhEW9R+PKxkCJDHQzuVzA4vajpSP36odiOk59pM3+k6ggSUOvVYLK0GrAnP/jsc5bCmIvcJGPWi3+CwuYDlV7lzWnm+4/BLXIQfwz8ocUBX+7IBDUoccZAW2EQwuDJJoIzoAfFQu/aUzMxnDS3oPCgy5ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF1C61BB986.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::71) by SJ0PR11MB5055.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 16:02:43 +0000
Received: from DS4PPF1C61BB986.namprd11.prod.outlook.com
 ([fe80::32d2:f7f:239c:178d]) by DS4PPF1C61BB986.namprd11.prod.outlook.com
 ([fe80::32d2:f7f:239c:178d%5]) with mapi id 15.20.9182.015; Tue, 7 Oct 2025
 16:02:43 +0000
Date: Tue, 7 Oct 2025 11:04:53 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH] dax/hmem: Fix lockdep warning for
 hmem_register_resource()
Message-ID: <68e53a2536b5_2ca8982945d@iweiny-mobl.notmuch>
References: <20251007001252.2710860-1-dave.jiang@intel.com>
 <68e46a09c2a07_2980100f3@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <68e46a09c2a07_2980100f3@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: SJ0PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::11) To DS4PPF1C61BB986.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::71)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF1C61BB986:EE_|SJ0PR11MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: db99b40b-7ffc-4ec6-1453-08de05baf2aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4knGmcIsNhb0klv4hNyL9VwTITSnCTOtQ4kYxCldck6+I9/EqmclU6n6hOvl?=
 =?us-ascii?Q?/+Hatju6+dtvWk4Ua16x+tACYNh5KdH1ad/LXScM69Dovg7CNYuFSDjgY/4X?=
 =?us-ascii?Q?Rjh432EeoyAElJcC4ozMwpg5lSVP3rygu3Wso2D1ktAYE+eG0qWhkOa/RCp1?=
 =?us-ascii?Q?GYE34WZvVFwX9Z0r9CMQV6mmWk6llThvdNhzLMOq6TPdiW2zzrMrE/OQQw5o?=
 =?us-ascii?Q?oI6Hzy2FPFZHZe4nLqZymBm2otdp9m9EwNtJfFhJro7nxA7n1x4t7N4TnWpO?=
 =?us-ascii?Q?zTgb2XR6w6sK4vsBur9hEtuAf+KD/c7ksH8LbVh7ITc4ENh/1PFZsL//JcQj?=
 =?us-ascii?Q?Uy84eNvPr2UHnViol9sT1/OVs1bU4led3TYZiKR3JJJzzTVd8Gpf/x3gUxKY?=
 =?us-ascii?Q?rdb79IiDUcN55z3JnNWum//cCerPLAzd7nmiLpZDe6kbGwyCjwjBsUP29wTC?=
 =?us-ascii?Q?HgggZTSFzhn6MVZ9JFstRX9i+USQowlDWV2CwQBrmKlnQCSMtgwN4sT99bDI?=
 =?us-ascii?Q?njlrfaU29cDKFX0v908PnQaNGdfqVQFQJSHzTGwjx7JPPEZj3DDV0OY93gW4?=
 =?us-ascii?Q?aHbS09rNH2frUuED6S6HJ5mIzQpsgsdcTLJpAxfCy0xSVplUSD6BAebVg6ka?=
 =?us-ascii?Q?cXup0lE+cA91IJ+MDpJv+/0wGdfVq+/9kptqwDPTXIIVA+S6MGT+aYdL9L3D?=
 =?us-ascii?Q?Fk3dBFWHbEh6c86zMHnROlk04VApPAh7VYoRaEAynPmYI78U4GCFdcvB+oyO?=
 =?us-ascii?Q?0YsjLWj47TwaegBIIhp7l289cW7++gpyDYxybXoGQ35Xs67J8qscgk3L2/qg?=
 =?us-ascii?Q?gJL+hbjhOOirZPfDEiYZ45VTAVwnwMaZqBCCgFSA3As9JaeGQ3Vi7RVDK/Z+?=
 =?us-ascii?Q?w9bgdlZjB2Gw6OAStYP3VpmJrhjJIGlgnG7kxbTOAL9Ou9tne3Z/tNJV2PzX?=
 =?us-ascii?Q?N09vAEmJ3HUj0uivLChBN5nEDgmW0n3CZHSnZLQl6164gAmgn7j/FFydGvfT?=
 =?us-ascii?Q?CSSwvwAVSNbnWNG+O+hwwG2xnTGEH5/agQcvNoP8uAcCPRYp5qB7RdNQDl1s?=
 =?us-ascii?Q?EjISyqpKq6FI9rU2eCc5E5bD+ZJOmrVGYxkGtr3ZvN61+GUFK9oKMX6y9yTx?=
 =?us-ascii?Q?M5Yy7W/ANjmVAJFCWimcFffMfy/1/puJ7OdYYDBH+KmVe1tHXdW7xAl1pBFB?=
 =?us-ascii?Q?mG0AWpJNM22JCCCGCH/wq3OqVOZK1LS3YX3bAxVhAsdTZoOGrJteePXUFBJy?=
 =?us-ascii?Q?+T4mzfoUGOevKOvUhHOap3KQM2UspHS/98lYtUmxUJTV+gOQQTvfgP2/pKEw?=
 =?us-ascii?Q?caxRKirqQXckYDF0LHOrVCmnDwb/HGtEmDBB4O4KQ8R9DSQbLBydcyzeWBI6?=
 =?us-ascii?Q?mho6KFHMWKDLXAxvpzI7fee1dAfcjNwqeSpSpYNUOOPTpysSrMZVcNDE5wPX?=
 =?us-ascii?Q?FThYLRc2Mghmzi1IER0Uq5uFQtroU07c?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF1C61BB986.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7zxx43iOMm88RKMGxfXQLeCGkL+O7ukhV7J3KicVfMPj+k+nTXAN0whMGSI+?=
 =?us-ascii?Q?Buq0qQudx/uoiKIKNDrhvCtXTPmZXoaFYwhBGTRwwd6CxvMHo2T4zrNfC2Pq?=
 =?us-ascii?Q?CpxYb8UupPLmtQD2/6ZL18ddlBSYlUhNUW+GvuIIInQwujxVyIGdydwolLmI?=
 =?us-ascii?Q?h2jyybzohQmjRPffbCMADF75WUvTI8QXz53dcsq10+QXvPLkJyj1kQDQgz9u?=
 =?us-ascii?Q?978VhQmR4CBcY4sVO8zo4N/0z+wNxNigd9wQg3kPlVrV45ckKSIdpMY7JwDu?=
 =?us-ascii?Q?WRgD0NCQgvloAjLiDvlII8rP6b3WWL7C/yx9IDzU5qoXV/sUSKV8cVHkOZse?=
 =?us-ascii?Q?Cj0se3R5kff/0LBPq4UP5FahtyTBeGf5t5K0yPLhM0cUv3esuQHJ0zdELTIx?=
 =?us-ascii?Q?NTetlxj18+dCDEm05IPhdxiLF5t8tLbuFsY0rYIXP/LpKFpMwE4wyHvDV9Cy?=
 =?us-ascii?Q?1KtAwhF7aq+jlq3BNzzR2farq9M8lMmbtNdtMUpTaC4TIzaKjSfyl6On4H91?=
 =?us-ascii?Q?8KpyUlIssASYU24jXCOjGjdltE7am104hhZkC2lPEBZZRGv9M0PG+hAyXEA3?=
 =?us-ascii?Q?Y4VKHyTWSw3rFc7pICkRJIMIb8IxZEzz97Y8z3Zv+kPCjV0v1QgDfiXNgQ9O?=
 =?us-ascii?Q?sgqzquShRbsHPiyyeNwMRJwE84iMlyNMMl7ym0WDxXBdteaQyAWQOQSzAKeb?=
 =?us-ascii?Q?IHwffGu/94aquaEOlkTBYCJTgFZQzNBqpz5XxW4Km1zSj5xqNMQjqjYlZ91b?=
 =?us-ascii?Q?UdqHcfHaGz/ybb75HCMJuuNOBYGLVzrJ1zy1lO/JX0woDdDMZyZu8Z4srnSE?=
 =?us-ascii?Q?UGwiWnuZ3EWyvQgqKG2YWuF1S0foZVf6mdogWN2WZj0ywUIZLYh4qshN8rjT?=
 =?us-ascii?Q?hgvW7gsXaQ6YmJULuK3Fx11iKwh4Avuv6gb9NNrETSc2UJ3UR0GLVr0IGWsJ?=
 =?us-ascii?Q?rgQ4cPWDPgqVCWc6j94dtj7E+ciHPt84SViI/s6KpiLz+Ee5sJr8U5TfUUmF?=
 =?us-ascii?Q?M8Lzfb6MoINcBIOHMuTlOWiSAEpg148dcKBrM5IKi1cEiaJIYM7YNosPwUDi?=
 =?us-ascii?Q?uAcpwr7dnHikWYbHbOnywQ57rESvFW+foHADdbD18BPKGJ744RhOZEF99Amz?=
 =?us-ascii?Q?ro/La/bb6ERXHL3tXQFJ6xDRLpGfVoIuzh99XWbRur26QIp1+uANwet+8zXD?=
 =?us-ascii?Q?rVKVh6wKr9/t7cZMXgknX2pl2QF5US6jgh+HQt0PazbvNffPcOgHIGyD/fyQ?=
 =?us-ascii?Q?uWFMvg6TZDRta81/L0KCUL85sPgjaLJm1Kkou92DIkLJEpxzdQDMtRW0bBMU?=
 =?us-ascii?Q?V7yxiyiaGXZG4Im3sexfkvMzxXkYjQMdUt1qv5JAdkowq88cxygkN42VIDzZ?=
 =?us-ascii?Q?BhaFruIu3QXOsf8ca1xGwNxy+yhtUCLxT+/t/uIfn5+DZA2luo5qDCbncRdi?=
 =?us-ascii?Q?p6pMONtUJDw9Uxy05ZQ9AGVTBIzTb/as4GGzX+8eT5aOFaI5kc4pHiRqDNlc?=
 =?us-ascii?Q?MdwcqsJj+hfTHusWWOgqbkIUzE0ZtbWYdCZE0h+qYs5mud0CrzHdc0+m8svr?=
 =?us-ascii?Q?OtvS1xHEr1v5BtE+jY4UBFXcBz3BnohOuv+qHNP5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db99b40b-7ffc-4ec6-1453-08de05baf2aa
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF1C61BB986.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 16:02:42.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aYMkREpudbKIV98+hGeG4X9CBr8EN3sJAOS9QAL0+oWCFfyfCnlOnjjH01fE56dvAzFnx6dXSXXKpFOg0GSRYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5055
X-OriginatorOrg: intel.com

dan.j.williams@ wrote:
> Dave Jiang wrote:

[snip]

> 
> > The lock ordering can cause potential deadlock. There are instances
> > where hmem_resource_lock is taken after (node_chain).rwsem, and vice
> > versa. Narrow the scope of hmem_resource_lock in hmem_register_resource()
> > to avoid the circular locking dependency. The locking is only needed when
> > hmem_active needs to be protected.
> 
> It is only strictly necessary for hmem_active, but it happened to be
> protecting theoretical concurrent callers of hmat_register_resource().

Are you saying hmem_resource_lock was also protecting
platform_initialized?

> I
> do not think it can happen in practice, but it is called by both initial
> init and runtime notifier. The notifier path does:
> 
> hmat_callback() -> hmat_register_target()
> 
> That path seems impossible to add new hmem devices, but it is burning
> cycles walking through all the memory ranges associated with a target
> only to find that they are already registered. I think that can be
> cleaned up with an unlocked check of target->registered.
> 
> If that loses some theoretical race then your new
> hmem_request_resource() will pick a race winner for that target.
> 
> Otherwise, the code *looks* like it has a TOCTOU race with
> platform_initialized.

Yea, I had the same concern; but it's not WRT hmem_active.

> So feels like some comments and cleanups to make
> that clear are needed.
> 
> Really I think hmat_callback() path should not be doing *any*
> registration work, only update work.

I think this makes sense to me but what about:

hmat_init() -> hmat_register_targets() -> hmat_register_target()

Does that still need to register the device?

Ira

[snip]
