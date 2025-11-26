Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB3230C353
	for <nvdimm@lists.linux.dev>; Wed, 26 Nov 2025 16:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764176235; cv=fail; b=EE5v/h78W7pbqextdDoqoeveCk6t6Edsd0CnbHkYQ/L7vDxy8IRoY0zhyLTIpEX4xYslwXqzMX8Qrw9IxxXhFx65YKukHC90sJ26dmJAuVTjk9heBftcKww8ZCZJwZLkMY+o/tDCW/zBMY8di5nqbfy06/1Ro5GZzXvDH1KPYF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764176235; c=relaxed/simple;
	bh=/RErcFwqRmF1jpV1Hemp7hDsvsxNPVIZ0d2z+T/gnxM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Sf+Q/fQuysvKiHp7uir/9A5aZgIdRlu7A1NRa8R4ZlWKKjgLJ3mbL0OYtQXbwQ+5vgl2i8dgQv0lCKzi7jrmQrlStP0kmD1PPucUlLF+26ruNvj6ty4OjcFcR2q0UwiMtcyben1gY3GvUFekgW2ef4d7v7AonRhRpRUdY/QpTOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A+XUqvHp; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A+XUqvHp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764176234; x=1795712234;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/RErcFwqRmF1jpV1Hemp7hDsvsxNPVIZ0d2z+T/gnxM=;
  b=A+XUqvHpG6fnbhrWBsXDSS9rhKbJS+4mIkGpn9D26gt0La2W9U/tLxqu
   yWONh4Shr5vlyAuLguBXQXM0/aYBx2eH4LtjrjDsEsagkQWWgd9wP68AY
   6OT7FpwpSj6OzvbEzQf7Q8BeGinQYqd76exz9YsMAXEZmqvshK8OL64dg
   xw0M9GRViUSNoisvjL5Y3YNasMZkYZhguEbQWAWWUzdGSIeMHJsq/VPzd
   T8f4M+r6e0AIRkdyzYC+zvVdU6WEb3/qTIXyRjTXApmAwt1WqFYo4gYtz
   k2gOaJm/4jGGEPuNmgmgtt0WFwIVzPe+VmLQhaG7NRc7qMVyhbOlVXIPZ
   w==;
X-CSE-ConnectionGUID: sGXh59UdSeq4Dpu7Im21Hg==
X-CSE-MsgGUID: v/Tbv/VeTkKLjM+N69ex5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="53786674"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="53786674"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 08:56:53 -0800
X-CSE-ConnectionGUID: 0DcFR1EsRvK5MaMdabcXIw==
X-CSE-MsgGUID: AwTJFIYbRmeYYPOBqbkrzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="197930962"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 08:56:52 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 08:56:51 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 08:56:51 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.51)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 08:56:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p8Ete0amBjxenmb6WuwjEPLqKpNfn4F0IGd77iEx+ZKZYtOylbmL2gqc+Qzmoz2lb8ocgRCtLhFrVieFqI9doe/OAY6Ym2Rzjx8K0tQEcTOmoAB9Ia+6OEtdDT6iVtbcSQ1unwvr9TNhwYS3OUUEkUiFGbD3NHk9bUdwXuVARoTGTnadSVKOBdEdkW4z5X67sDi+8iuRQ25Uz3sWW1bMZHNznggj0cMGmZciOY+S5kA9PM22od/8RDymdADs2u+GB0fviQEflPVKBjU1ekDGetVvychiVJaTHtzRb1YiamqYmcW4XnJTsgdZK3bV27yrt0z4w4xM+JBGX2+XttQafA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8C/oAjr7k0znzGIobqXoJfdU+lVsUdG8jRybwyfsjJ4=;
 b=c7CiE4+vUMgObU2tBRbySRcL3JhOtXKdsrwwfAbQ4GFsUaHvD69HwwXwu3WsE1yDs7W6TWgb8rG2gz+wad1zaZd1CrNyvp3Ra9HNRaWWELJy/dxGqo87+ug+TOHC9PexxzouFEEZLizuXdQ8/l2xWsnfn7SueA4AqORCrDxodGx/qxArd/MRw1+TWWI8l5ZpFWUm1lhCbyuTe5iIgxUfv4l3rNJgEaTkPDAzxgBQ3T+mv319NZ3gYr0eyeTbQP5DzRaumxpEbGxIP+m89QliqEZxyDvcAlVl/lOEngknSmzRCWEekKer2YdXNwEgdUrnQSb+VvscUVkBJTXssk9RsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CO1PR11MB5156.namprd11.prod.outlook.com
 (2603:10b6:303:94::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 16:56:44 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 16:56:44 +0000
Date: Wed, 26 Nov 2025 10:59:18 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Carpenter <dan.carpenter@linaro.org>, Mike Rapoport <rppt@kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH next v2] nvdimm: Prevent integer overflow in
 ramdax_get_config_data()
Message-ID: <692731e69409a_8252d10055@iweiny-mobl.notmuch>
References: <aSbuiYCznEIZDa02@stanley.mountain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aSbuiYCznEIZDa02@stanley.mountain>
X-ClientProxiedBy: SJ0PR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:a03:332::30) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CO1PR11MB5156:EE_
X-MS-Office365-Filtering-Correlation-Id: 95f77154-e3c5-467c-6090-08de2d0cc748
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xfkc8x7uZI34sh6pl2sjUu+iRaXOC/ZT/vhKqqH5C6V3GbzI7UVGtrBF8DNs?=
 =?us-ascii?Q?Hni0KDRZTKBl832XOMeOiHkQ0VM8QXrlRJEYBI525cstC8ePBcGhdAremX/d?=
 =?us-ascii?Q?FPmemy8WY99zxrxrvn5lTiwRZn3VihJbqayIZMJ2Wtpb0uERI5jkcjarUs38?=
 =?us-ascii?Q?mCm0xZRaflhtNNUu5fGAuYMkb9oGQuz1fg2Ci1LjKzhVhZvA3hf+0Z4MGYkM?=
 =?us-ascii?Q?adXJtlGRzuBzZAOFqkxKZEQPbzUi+JQXESEySavhDKCPOTwFkWFH7T17myvm?=
 =?us-ascii?Q?x3IcQaj2PNdCcKnHaUYuJA6g4kK8oIJYEM0ZcQY+3Guagh1sxpGIADepGJsK?=
 =?us-ascii?Q?uACYhRy7zR5XpTk29y7acELVKW5VeyFFYXFMVbP/KXhhjQktq/ZRageYz1mf?=
 =?us-ascii?Q?C2+E7rlO7Wn5a3ex4EVHTvqUChj92IfDMrL9GzFs7w4SXV8Dng5m7gLRTIBS?=
 =?us-ascii?Q?z7UjGYEQzD0Ty8w7BVrT0uKMqaMtEh7tPU0PIPfLhPRG5wazWWUY1lhpwfZZ?=
 =?us-ascii?Q?QvOpNA57U4/SsmCO8MYqe7Jvdo8SYwfYRqsRciX/ldPxF0q0nRVwpN6wLLeM?=
 =?us-ascii?Q?OgB0JnL5fFeF9nf7LXt2OuTPvCfgVP/G2bhZsp7KAsG/i6mVbZ2WrOoxWzeA?=
 =?us-ascii?Q?DjlSaNpGRAAQKurg86julLBkZHTMCxN7xDYdjfvN0mGH/ZwIbkzyOdNIY3Xi?=
 =?us-ascii?Q?uHUGncHSn3iglPAO+Vnd8/QhVxFgO2zAcW66RHutY8Id0i+2SGK8nZ5Ub7NW?=
 =?us-ascii?Q?EoNWmS7dL0AE0AOonHTJre7CnOmwuG6m0e6v8OpAHBO5tVPdHzgoYmmcS+sR?=
 =?us-ascii?Q?iEurgM4S6/sTh8vK805WMvDfonMDvHjohSoBzsfqDQtUgMcDBrEwvS7eY4LD?=
 =?us-ascii?Q?BwoixlABNG3LJVevwXbYrrYaXy4WbUapnYQKpF0VtLJxmuyZ6rSDIi+S3PgL?=
 =?us-ascii?Q?i/8yXqWBAvhg9ci947brIKqD4mpStynM4F6ehuCYzYNhjKgIAGzA7RMQFfP8?=
 =?us-ascii?Q?ZqcVGO2KB2/QTvuMoJ8IbQYSyBSdjI2J6Jz7VUtOsk0tbiozM7g8AYf5dZVM?=
 =?us-ascii?Q?isP5rGYjT+ctNIxHZ2rb+982qpjLnYBzpsa8qo8u2A7bN16WeEaVWp2p1HMl?=
 =?us-ascii?Q?bXFOXDAICV/6jL+pd+tqEWOHrPXD9ESUzxKfH2GSfqQhwO0qxLU0154GPp7W?=
 =?us-ascii?Q?8+1A1QZvjqYp7X7gunlWs9F8zm0JagfPfuxn24iztM3j5q5zlEXgQb0/0P79?=
 =?us-ascii?Q?Jfvc6IxZ67dgA8nD2Wy4rmx30lj/kPEHAQ+AMGOPGJiEoOcTcc6dclvCWq8M?=
 =?us-ascii?Q?gVEax5XSr8TXe2VbYBi+gnVJti77HiSiijb+0Moow+ebx7gfiBkjDv3i+nXm?=
 =?us-ascii?Q?s8T/h+iVENy9R/PkyI33yDrPIiKYMq4gw32BERU3XLs0NXiKiYxIaK2z3bdj?=
 =?us-ascii?Q?kXz6znn1XHRBO6Wp1SC441i69aHc/DiR?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R/2mDX/UZwyhybkkrw/GkgHYYYx6kr8duI2gVgoC3WsPAPIC0NQwoAde32Ad?=
 =?us-ascii?Q?ci28L9AZRLcQ253Xe5fD5ySQhxKhEvv3VEEggwciHRONMsUar2zJZV9OoC6t?=
 =?us-ascii?Q?6ncYoCeDxQvuhJ4np+6PXp34z+jX7YDAroOt13nRdj1YT2vQpF4Mj/xEcGPO?=
 =?us-ascii?Q?ae4mdX9tdJja7lTp95qH5WcgrChRFaYFTvzMlH5Q/6FPbzLFgYnXYkaooRFX?=
 =?us-ascii?Q?TgWIwAo84GA53M0Ju8ZrhnQKOUpaVPQl2hqtXQhSWJBk3PMaCW2rdLW3iCd5?=
 =?us-ascii?Q?kxBaELKhYa5o7yoXFlqzvsZDt4JtsqdwWvtx46ms6PsUC+HdT6tsqQBzQjPp?=
 =?us-ascii?Q?kaMFKhq82IzEN3lTRWVLo4tJkdCUXrEFR9g5uHcUOOZ0cmst4whA/NTbPulv?=
 =?us-ascii?Q?PlbxFsdys84bf7s27bvldzCrUjl2wqUnAkQ3Nu0ZUElutAW5N5Q9w6/e+2YH?=
 =?us-ascii?Q?zCdbaKBd+CNAwPMg5FLdvEIEaWawLGsF/+kCEKObwjAW1Rc+y0keuwi2d0kQ?=
 =?us-ascii?Q?+5EkP3f1CKWLz4POObEDAjTKfkG9xbeoYFhYGBZooLLLkYjQ2i3lIN+45Oxy?=
 =?us-ascii?Q?6UYgtWA35vF7yCLXzvde2DHzTBuI+PNW9T/qcrXc4rF6ITK6cQDnM9rao304?=
 =?us-ascii?Q?VLQ4pSC322wR17ZHk7wy9pIwt0BceX6NWGf0/cQC9XXcQfqgyk30tJrdsELo?=
 =?us-ascii?Q?Riz2kBHwdTOf66Uh9UIFqrEDFlmWulL7QxI3mcDQsv91Klul8NpjDN3QOqez?=
 =?us-ascii?Q?iH8oGLmeGBaEgKyxa15B7pQMnKyLuppPOTYHFHuOeOcfgCDhwy09R9IqwlKd?=
 =?us-ascii?Q?Jp1ilDFDqv/ipfBBrTpfVp9L1jA8X54fhum2tCo/iGQsbJ+/HEQzFlmCgNYg?=
 =?us-ascii?Q?+JWoH20d2OB8ViCpvH0LSwnLcLVlRU0VcjEUYL0lPe2tTp8fw96+z7xVbc3E?=
 =?us-ascii?Q?+v2sJ19/pP7STQYJtI3/mb/mE1oTTtuS3ew7QqsJJRAeaJ9zi5PsmaqGWca1?=
 =?us-ascii?Q?GRMprNQEcbBgAH0MoAExoghEnxBEM/P65GA1Vr+GXO8Xf4bQeVeH6l/+vKjA?=
 =?us-ascii?Q?VoSTzaI+iUt79SBnXcrZr3PJOe/U9cIdu0T91GTeAGC/8llnvapuNf45WkiW?=
 =?us-ascii?Q?0Bat5kIbw2uvrZqQWDgOHbgHiB6oJTh7t1RR4L1by/ffHIaowJsr2Xt9xcbe?=
 =?us-ascii?Q?JiqiW9B/EwNJz+5uKFaVYUvM9HfoVJxL2yPuObKhZGxeUMo2MaTA4KJTs2pq?=
 =?us-ascii?Q?wzXIA+ABerviZBJ4IdHOwZsujGEpiG31mPIeS3wIN9SIWE9bj2l2U4SiYH/R?=
 =?us-ascii?Q?4mkLPVOMFk/eZ74DW33xgehxQzTSI52XfsVaehYMemtViPiHgITvLp80DYjV?=
 =?us-ascii?Q?F47bgnRrQQmlBaKowtElyJahr9XBA9GpPi0LEgUiQH0v2LqOmMat3+Lk71dt?=
 =?us-ascii?Q?0RtbQgILBBwEl4PdFDl3rAa9ig0AmMTpIaIj2jEd+aUUsAa+8/bBVC3V/ESI?=
 =?us-ascii?Q?Lmb0yWBDVJTtETa4rtVkl/m0eGy7QIcoV0gaHbClgY8PUQ1/iheqSE1Ki1Y5?=
 =?us-ascii?Q?6tgxi+IhkzA29xWfmMBxrvqQdohOyqWAsfzzkb7F?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f77154-e3c5-467c-6090-08de2d0cc748
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 16:56:44.1141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWkryhnY+O2XSf0Cwu36fRYE7Avf2QCdcqyIj7eUm2QIOP/8Tu6WXw6EdEXfeDf6QBsKP6v0h5dTzOi1xGOsCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5156
X-OriginatorOrg: intel.com

Dan Carpenter wrote:
> The "cmd->in_offset" variable comes from the user via the __nd_ioctl()
> function.  The problem is that the "cmd->in_offset + cmd->in_length"
> addition could have an integer wrapping issue if cmd->in_offset is close
> to UINT_MAX .  Both "cmd->in_offset" and "cmd->in_length" are u32
> variables.
> 
> Fixes: 43bc0aa19a21 ("nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Staged.

Thanks!
Ira

[snip]
