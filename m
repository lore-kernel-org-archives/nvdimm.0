Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBD746AF
	for <nvdimm@lists.linux.dev>; Thu,  7 Mar 2024 00:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709772653; cv=fail; b=aAARdbIG7bXduF/rXUq/yOXkEeKUq4ZPoKjwB3thupUYmvc01C7x8UFmkS/FKtv6ntFf5Rmx2qrNNzKB+OnHswhDkAqzEJnzohpG4qFEPnq4HybhHcTPRQQsqXLX8S5Ze8RcSUVXlKM9M4i79eOuPLdo5hD9IcOKC5ng9YMs8eA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709772653; c=relaxed/simple;
	bh=/AXOnWbStYdpYff7vTonZjjSvJKS38So9mM8LeyCSo0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JJkeUlTdbI2TUvM1oZLJaEI8wVhDQP3Uo8+KNbwjNUG+z/TlMMrYujqEuN+kFcoli09elhI+32jk4hY2UmH5bFHH+gNX10QDiGznGlcBwrTKpH0oEf0PLX61TknMywN87PiGUJutT74AyMi6T3usZcXCi59GDLKtuVDaZYkM4WU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bf8PdexX; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bf8PdexX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709772652; x=1741308652;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/AXOnWbStYdpYff7vTonZjjSvJKS38So9mM8LeyCSo0=;
  b=bf8PdexXUqArWzKYJFA+ddr5hb3UEfAMZwDzfcYuvJuQRUg0na3dbMLW
   B7Nr5lzbED4v+/YwXwrUIaImo7+7nVyazB+8+Ql5rrbfDCwM4/6jue+yJ
   I/BHoGIiKrTCFOJk1iQijXgVhf8APbBB9OgS3N28QzMFvpjZ+EZGZbGQp
   QI2Slt0zgNheomPKsRehnN2bNMNBTWPSa0b3wgfHX/fLrX5nJFDnmcyWp
   mbRRLx2nCrWOkXw13WTNb+vzxofl0BKYGpwsUpxqImBe43w/zGE6ukw+m
   1KSBcPm4O6+SQQ77RC6wJOlvT3uUYhYt7vfDlpypmSidwNgs7tydTLEc/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4267393"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="4267393"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 16:50:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9825152"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 16:50:51 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:50:50 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:50:50 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 16:50:50 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 16:50:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcrM8TA12GhbflrY2g+I7hGLi2YL1VTsiDGqczm+946XyspshpzUq90JI5z83OoGx4Pjog1z5bF1IHv9obuJc59aWKXkt5adsNaBMNT3s29CaijtGEXPg4xWYaB/LRAEMoy9T9TUIsY2jHMCqHpqusb4Ph94/OJGDiHW2qv80LlbSA6PoD7RuK7qsTebelsoZotQVdUS/jqt/Sxmvn/SyJ9YIUhjchgsDftEuCf9LRIxxFo5Is/rWweL1oKGAQ8GVFXBaCBNdGBseW/cluJcw7hS45gzG+bX7NQ2cEzi1V4VtJwSBNtp/KTmbDIJi2umKUJIp/HziKSembNNyH1MKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5d0NrfXUJGDmihZOHMA+kqOiKPQ05jYrGNRs7kjnR80=;
 b=fc97avWs1M/8G0SzrDnxTVY/e6v8eE9d9K8lTC6ISf+dVMzHXn7Gpk/LXtVdYBgqzOOrU0Qu8aVO/NQyHH4PDHcGt+u0IIS5QyrEH0EZgSeljDem+caxnaQcPvcgfyDR9L1sWKU9QPRAIr6Ogp9lR5o7RHf+nR/YH7XKNMaaXSdEzP5n/uFK1lCJOK3ngTmeN8+a9xJtQfEmALgFlHZpryz6k0HgWLNfXWM//ZXrilVh+b1jYiPb2TtFCe/yxNKtSgio507W3zKOo8OrQf+DCpRvavj3p9283xcwefT9uR1895u/gULURy7Sy0NPp9SsJQmMtzw0mjjtPzQV1QSV2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB7585.namprd11.prod.outlook.com (2603:10b6:510:28f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.21; Thu, 7 Mar
 2024 00:50:45 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 00:50:45 +0000
Date: Wed, 6 Mar 2024 16:50:43 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v10 5/7] cxl/list: collect and parse media_error
 records
Message-ID: <65e90f638d20e_1271329495@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1709748564.git.alison.schofield@intel.com>
 <9e3916d77162b4cbf6ee2636f13454f239f979c7.1709748564.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9e3916d77162b4cbf6ee2636f13454f239f979c7.1709748564.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0196.namprd04.prod.outlook.com
 (2603:10b6:303:86::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB7585:EE_
X-MS-Office365-Filtering-Correlation-Id: b09694cf-7fe7-43fb-1a41-08dc3e409f62
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MraRi1W8lGt7Dw47DP7JgHjhFCSYCAuHM1e3I7spMp13YHTnj4xTfKTcoMcefvg66PpcEY7WOlkhXNQ/oAPddiGf6/7UVV4eFMflCWBf8K4WliUIy66e4BjWXSVENsGSxi2roxy0cSbNa0lc2aaFkVgngx/TZIPzuR6flOjU1pEOr7IatMmzgiOOtc8aqEWoZSFL/leMFQ0JGkWHLZNyJISKkqwYO8IQkusEsnyRlTVUr7kGXNY8uvY1WtlClMKZEmKE2pIsa+eOoIVMz5YCqJp/LXxK0p2nG12ARorm8kX50FyqPuzZ7MoTyIKbTreA8ziaCMF8bntfAUhfNRhVAI8CcX2aQEWyuHl/TarhL97i5UsgHO45QHTVMY/Gpae4Kc4ActO0z5HH5mrY3HfFRbHVqOomnAFRVwaemqUcHiT6PqfaR8qhNQ5UU1aOtSiHvaewjKfbnkz6cIwDor/gC/XkaKl8CkXMAXLjjdns4mv/IMOZadzowBRyMBD/z+7Xx1IMY/kbzvalzNRnn1W2Sz6kcmAPJVtl3+erz66HQwy0HVXg5eOZ+N46w9ayXr/ss6Ag0DojgLgCFwxjRSDc2c+xWR40kMo+qmUzGMmfa2/voOiCpU94tnVnRpKM47z2vVFbo2fOu/gY0EEtIfv8wpz1AaWK/rRLJ7Ce0G0xfjk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?opIGQDt6U1fqBO+Of/BNQ+MBK1w4mINJcK9Mt6shObxd2hENbX3ZbRVFsk9R?=
 =?us-ascii?Q?gC6EiXmshAFyFC2RKrsNreJEOI7BcKbr2crIgiZdMLNOnjcsIjAxqfuCNGLn?=
 =?us-ascii?Q?d4bo/g+HlboIUpBgrCuTgnrXFn/jOLZ85ODlQeOWLjhGteEDB5majUcrHZnr?=
 =?us-ascii?Q?JfOH6rFfaXW6IaAs4pgX6z9Zw++svA4yE6CN5xd7kegS34gQo7Fd9iMDpBMc?=
 =?us-ascii?Q?mRTPQkMTDiv2WTd8Gnm58b8mkulHXabJY8ss+WEFBVirkNWjuFwG8IPvFW5M?=
 =?us-ascii?Q?Qk6R2zUi4AGS5L2mvNo+8mmC6ZdbS4QpJlawT5OwXqvCwQrKYn6RnOMhf01x?=
 =?us-ascii?Q?pysz5HC1hGer4EzhNJDGSzZIT1SCvl97L0XDBkx9QvsRGWvt/s1yeHqeoE0w?=
 =?us-ascii?Q?/v3FxKVM0nxEdsXfqSwSB1tr8YnK3bjr5CVlMIBA/xDJP/4xB0tg7Zd/uAsv?=
 =?us-ascii?Q?qABBYFM0LxNMbHVGIsETtdDNcQKsH9fUOfCMXuhNr3DHMEdhIaTFbRHYR98i?=
 =?us-ascii?Q?QZu4zffi2obmEmXwq5aDlK874Ttdr7ZfYTtIKzTvIydI2ONut3fYRkChRbyZ?=
 =?us-ascii?Q?uGUOEJt1I8Tok3l2t0Y5WNM2Ryzsv/YRvyLdqRHTM5Rg1yHUI1FVm4QIDJMO?=
 =?us-ascii?Q?+Wr7JQBvz7PCHTnBvmyCbCDDe1TKW1AxdCCMW0vhJB3IqZ00vkGRW9wCmFJ0?=
 =?us-ascii?Q?/enDAsYQtxlhC7SZYjmR7jO2glQz0qFqIO2n9Ccd6z4u36ZyNwZbTJnZ/bx7?=
 =?us-ascii?Q?bTh7XyYp5h9ax4LC5gCKDWSjmc0GKFiNrQqsNWHAUbgrnjpvevueql4UYWX4?=
 =?us-ascii?Q?MMV5XK0hKWiJyedBVKuE5Rasv2y35+yfrR5JwjyrqbmJH1HX27xVkEEJT8Jz?=
 =?us-ascii?Q?7S2JcoxgabjXGu+3sgnJzBn88wqm0jV1R1jg29cxStsPeIAIoSfE9uGxS55T?=
 =?us-ascii?Q?LuD8ryvIucC/d8dopKz0oF42UnfctVqC5l6OOwQDcW3DpJU9veNkXo1cgp9A?=
 =?us-ascii?Q?i4RF0u7FM5exkSfnKO51u2JqVH6E6bxK6Cdc5TqkNQDdQ6cJu/mz66scAyNR?=
 =?us-ascii?Q?WTSivm+o20DZDaOqbbkuhkgRErgjHf6OxbMneMzdhV5tG/33MzIWjK8IxFWX?=
 =?us-ascii?Q?WbjheHQ8ntZkaL9nHH/D/iHxMtNlVjx3JjWnZ8q2i6+d6pTYXUWISEMhoyTE?=
 =?us-ascii?Q?yKdaKn6Bkis+7wt6Whi9vciVtLs3DsSXQ3FQwzpiu0tfDhT9gir/snTXKR53?=
 =?us-ascii?Q?NesUq5tx+Gtpkiid2nrPtuxo6ifEL6S/WIkhZpm3qq6AWOEXhdCE9QO504cl?=
 =?us-ascii?Q?Y8QlLlebvFYCow3hQtkbDrjC/lXh2LENGRP+fscolK1mqgN75sBJW/8TxBeZ?=
 =?us-ascii?Q?iZreKcUsot1z6gm2uTVR+f9HQJT9VZfiOL+4vPPXrjV56N1t0USxDABYRng3?=
 =?us-ascii?Q?ftgTLNaIUZqPGnTBQR1djk+/ETDEKdwvMUVYhwAjQlU+gjzTpUXju+g2enuD?=
 =?us-ascii?Q?BChSA6xZRnicqrxn4EZQrV+QIu6p2ondLQ9Y75MOYuKqT9SUPIBC9PYNgzTq?=
 =?us-ascii?Q?yvOsuryj8m+ZADblF+ZZXyLI9f0sQjcmZTjooTq8dhqppUsrfv56unsD9ObO?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b09694cf-7fe7-43fb-1a41-08dc3e409f62
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 00:50:45.3811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/TU7wyXOezs7e26PJWJLdwBjvJVoUCB3YF98PVdihkgNEexrvYHy7hSnzEedsyZOrRt3dE98y4pUsdUi7ywNrBawqvSj1pdcgq9QUmCmIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7585
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Media_error records are logged as events in the kernel tracing
> subsystem. To prepare the media_error records for cxl list, enable
> tracing, trigger the poison list read, and parse the generated
> cxl_poison events into a json representation.
> 
> Use the event_trace private parsing option to customize the json
> representation based on cxl-list calling options and event field
> settings.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/json.c | 257 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 257 insertions(+)

This look clean to me, just the comment on translating dpa and hpa to
offset depending on which object the list is being parsed against.

Also the note below about using container_of() in ->parse_event() to get
back to private context data.

> 
> +static struct json_object *
> +util_cxl_poison_events_to_json(struct tracefs_instance *inst,
> +			       struct poison_ctx *p_ctx)
> +{
> +	struct event_ctx ectx = {
> +		.event_name = "cxl_poison",
> +		.event_pid = getpid(),
> +		.system = "cxl",
> +		.private_ctx = p_ctx,
> +		.parse_event = poison_event_to_json,
> +	};

Looks like you could definitely embed an event_ctx in poison_ctx and
skip the need for private_ctx in event_ctx.
