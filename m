Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005EB356770
	for <nvdimm@lists.linux.dev>; Mon,  3 Aug 2026 23:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798106; cv=fail; b=qBmam0YDAqjtdo3vaBDaCzMNI3iYsAmKxirawLDKrwI2707S5x0oRAU3T9/o21o/WW+pWCjq05i+l63Uex/AFUqLzRkU6evaHJsTec6jmz42Y8vgs4Gvk6GRY9kytaDYGDNhjewM3yWQHAIz/bg+t7AA2n5jHbwvdI/TLF8Phdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798106; c=relaxed/simple;
	bh=YXOste4/WM5jRtMvcdENPUlGX8qT5On4ccw6p4Cs17c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YucicLu9aaruQeFZE/gCr4DA8lcj/GZaJVj7Hh6kRa7fv6k+upk8zyHFDj5mWJlE88hMNdw+Y620bzekMQJzNL4dwrl22sTj72yayFMHR2ji5nxNAAzh5HdmqbyqLGCgvbPMKXbgnSwXg1Yj5GbtZI7IeUjWrs48B0atqWLAZe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MOI5MLrv; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MOI5MLrv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785798103; x=1817334103;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YXOste4/WM5jRtMvcdENPUlGX8qT5On4ccw6p4Cs17c=;
  b=MOI5MLrvg68NYw2uQRL5TOOmvHpDKivOQB1VNr34Fd4lQH8l91x63Mwb
   wGB+4zPNzQNNQN77Eu/AJtToECNE4nEDafN9i7ELLDnEQJIMa7GrOXKUI
   Z9At19bXT0XOdMY1cNXQ3g4Ri/o3WJ13NtwzdUqy17O/ViJ8Ml1ThpBwf
   EHON0gIg+OmExdGMEIxfxdz6j31C9xzXcuk1kQ6m+lhfgHZlP5tFLv+Hv
   O9sHs5qHkp4C6SKj0hZUjnQIPRhN2Oxz/bJ5/jd07LiNh/emFXUsPSXbg
   jQV10CTwAx/3nxk/CCc5M/XXEpC90HtD1M4a6hUpqBBO9Cf4NR3Gb156Q
   A==;
X-CSE-ConnectionGUID: s3MGIOtyQ6S5QAOSb9PHwA==
X-CSE-MsgGUID: 5HKP9S7ETEiWGPmcjIbwLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="85475702"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="85475702"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 16:01:42 -0700
X-CSE-ConnectionGUID: 4HEhaoylSM2Q+fCdjnn3Mw==
X-CSE-MsgGUID: 8m6YAsJiTc2SyVi37VSCjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="263330766"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 16:01:42 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 16:01:41 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 16:01:41 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.21) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 16:01:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XuAQrpkbTz5h8r5lC2qju7dEh11BYYvmIrVnr71iaymTeP5CZBUmYPH+O1yLjVINpc6JXpxR8SvQLZZL33FsDhE7OEdZJ4ZFAk6i8m07jWxmvWjXRoUP1odcRm+LYko42MyEZwBzkaFFsj7uLLjZUUtXXWH3qVM09isrvo7nqZ+NkU5AQFfoK7De4e9E6bsTQzj/CNTc+05qs9qFUH7oM1c7e6gl5MqrwkQWE09p9aYllhxtpEDdePVeeih79SlFRR9lnw3Vrq89YLm7pMGXOSNNoKjb1r3l1U/M4Enu/24qsDM9+SA3BksNW+SQuisKwiLDIFqO4IGS0awsbC6Fjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IgJGCG5h+jOKA1sDG0m2j7Xw2V9+j2ha8ErNWXEY+3w=;
 b=ItIupwZqOI/Wu7iFO46IPB01NqjRBFvHGs5Wpd2C6aLzOxZlIXvZjVQsHkTJ19Q2wCmSTnzOQnjX8ZXOYa0wwmmj+B1kPBm1sCgj14MqWWE+iGxPmbCaOYXUCcMGB/b+Z2nfobIKMGij4ZU2wQMSuaLViKGF4x87SJPxND4XPyY2c3Jf4ABB73KEnLXVU91Sb+nVJeG/NtIOWpE1VnkNumDiZej48pRBNgP3CBtTgtDpSPh8otrFHwdGxqFzruOlRS1FzVjbost6XJBYI7OzFpEozZXZ0lI0QCbgxrAXkvlmZj9XL1+cow7U16d8g3oj1V/2Wd1w9dtwyfACeV+Tug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CYXPR11MB8691.namprd11.prod.outlook.com (2603:10b6:930:d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 23:01:33 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 23:01:33 +0000
Date: Mon, 3 Aug 2026 16:01:28 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
	<ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Wonjae Lee <wj28.lee@samsung.com>, Junhee Park
	<jh9934.park@samsung.com>, Heesoo Kim <habil.kim@samsung.com>, Anisa Su
	<anisa.su@samsung.com>
Subject: Re: [PATCH v12 4/8] cxl/events: Split event msgnum configuration
 from irq setup
Message-ID: <anEdyNcRaUiFFSHH@aschofie-mobl2.lan>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-5-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260731084901.1512819-5-anisa.su@samsung.com>
X-ClientProxiedBy: SJ0PR03CA0099.namprd03.prod.outlook.com
 (2603:10b6:a03:333::14) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CYXPR11MB8691:EE_
X-MS-Office365-Filtering-Correlation-Id: 746ac86b-c0e5-47fc-b793-08def1b329b7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|11063799006|56012099006|4143699003|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: OaEixNqdy7xm3pbDoAQubAlEr/RFVI1t2Y0BL1qXz3IbxLJyo1hGLDpy7aVAhv6NUBc3JKPNdAHBTZWNJ6wEOhrBJ9UOFKG2cnEVWWnxKV7EQ+QOvVKDhEu+Mukg236uW54qCG5ejulerzshnWYBUnATuh4AjzYAxi5V9p5ubwEjute9MMjqy08k4G9kzABjzbCLOjDeHbPnXhK2IS46t0DUJFw16BvlZORKw05h7v20RE/CiKwXo12pSjFztgfb+ztke6egMKJRZd9eCwA4CurfUDWzshvxclZ9SiL3hpZEIwRjoyUpi28hKXIByhgpEMwVY9aM2zNO9X3cDtpl69oJ4T7imTZ2Pl+gsafEAbUCgi9cUfAgQ1aNIUWRHVRREpAKvBUjlBUq3Syabm7TBez772b20MsPrPKgH/Pg/Lfpp6OF/Dqoa0kAD6SqPXrjKpkHQE/Rz86QuloZbuKjgh0Ob1PEyWuYKxWzdWAgO8rvD08w2gqL1jf+2hgEfUOHSIjrlvOOo2Uz1a71yvzW5nqsBQWELbvh+5xsy4b5+YFRjaif39id5GXnb2u51KGd6ZQJMu45JYSnJjLuYBbip751ShZwtpuA2m04uBxrgqsv8YhLobKp2vbuuo1qh1pCoP41d7yNvtfrMzlryAtVCPfmLoIu9Xk66OTWS1cVluc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(11063799006)(56012099006)(4143699003)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lsn0o2FQuXSjM/3RIXdE8WTjEgGWVVBxx+KcR5V8ptAgbkVZarNM7YYNLZw5?=
 =?us-ascii?Q?ovaRljriSVyo0gZM/ZDtFZykuza1FkBSRXOzHEFGkMjKhfM+V32joWCfgW4D?=
 =?us-ascii?Q?Lw+eOksoiav/VOoLgj8IMmoCmr9CGD5XzeyHv3xj3LhZeCKeDFu00j07/T95?=
 =?us-ascii?Q?L3gcqocBxEdObRPFrBLyB9lKNhEGOZU0zn/BxZU68ZXFVjYrSrhKyNx0nH+x?=
 =?us-ascii?Q?72N9NuK5e6BJ0X2G35oLeMrtmLSZjiC59tbM+8LvgCes93JPIyfJjbKjuSyG?=
 =?us-ascii?Q?y2lminLobfvPlsE1lGBeP9eAuk0LEKeoigJDFpIex0er6R+S68+t4AroBAjz?=
 =?us-ascii?Q?s2FUgwE1tZiiWUWh9LhtbrJYWuBSUgKyIhJ+Kt3rl3CV5OdwQOHKELd2n1oI?=
 =?us-ascii?Q?xJBjf6+dj6bcNUj0rFSvlvLZ5Ssw3FiSgiXOir1Q89qv4jzM74S3qgsslh+3?=
 =?us-ascii?Q?89Dx/2YjHw5R4jpXXZiD+KJ9uXSkvs6CqKDNeKr2wOhp4B9EkgDOJ5Hdl7ve?=
 =?us-ascii?Q?HiVym3mmsg/hVgZhHeVDB4g9PfGzIdMQl92ZerESDzE784NcbgFCPiQRQa9E?=
 =?us-ascii?Q?Md4A9ZFpljP7NY4iQJsbkJUEL74zTGSmnfAIOy2uF4SfzSsFhphP0Kw+67aH?=
 =?us-ascii?Q?ScGg9vLlsyvq1OvXMsbeh8qxt59+IzqGDLgkLSRZ8xKajHX468U2Wi+AjwPM?=
 =?us-ascii?Q?MRv1btEyVxrHN13Z//rjormHGoNkCgDn1PMzL8QxM07yvZkIjCLvLkUSLkGR?=
 =?us-ascii?Q?zCtY3hJwM+w4Kg1Ly8h8NNK//+0+OmsloCsBh6mu1pyzT+V4RmdOBt007lZ6?=
 =?us-ascii?Q?f/uNM7Zjf26XV1J9cZiehx6ooLfPM9RJGjDdNKel+TsQyk151Cy4dDPSx33I?=
 =?us-ascii?Q?NMjwMM2gGEiFpY0dq0FzM2riAzQfPT1vnqvO1ASEtHiBJ164i/nPnYGYMmaH?=
 =?us-ascii?Q?sbxtjE4t+/HYeEaxFg5qpy+xLW5ldQUGc26P/jUE7zH1ejWCyZuZPUnpqERw?=
 =?us-ascii?Q?0sn2A4AFFaPqSHXEacpkzDPSxWPaPlKCvAoJ2mnw4an6bhqzdzXNt6ZKf+Fy?=
 =?us-ascii?Q?R9757f7Cf7Hxv3rp2RFlgDaRECPVQxsVvAKqUcOpxbfqYCN48wQY4YsbMEcP?=
 =?us-ascii?Q?WfJbCACs06xk5gVmtt3x9boOMm1/ecBWvCj9zhCZC447q++OncVX6SppATwS?=
 =?us-ascii?Q?nif0nND663+04j7D99pCUh383BI6BNoDzAzEo97M4gPmEKmc43XpaXhW0KGD?=
 =?us-ascii?Q?DCltMiVi7q/wZURdHBSsfVBFdPfo75ffOATqCGEWf6sXT/Bo+kXzs56POu+m?=
 =?us-ascii?Q?dG1rB5gzgEUvYNfjyUVklwDT4kD11BoznGYHljsjNLSmZQUCOMtcswFjh7uQ?=
 =?us-ascii?Q?8Um17l0rU8UjhPjSB7uQUVelApNoYXeDYBY7+CXYdt/INEEcgGZL5P5yBONa?=
 =?us-ascii?Q?9ZG+DmWseicS8n/2Nr/IjkztAqlpOd5Ucsu2XO4CUDGc8vuds5MBsc+oDM5g?=
 =?us-ascii?Q?NYRnHqqdb2w3xAn1yDYc7l+2BwUDzA/h+HACSmx/O2k75VHPqf7OhoK6WrNz?=
 =?us-ascii?Q?BpC9C9l4y66NJ2Hr+g6txmcCtEuKWyAHNbLMrH5iwhVgRRRP3pqPE7hNbGaq?=
 =?us-ascii?Q?Artl1icTf5OKl+U3Bb8UiE66YYoHkQfTh1QVDkZ0MDNMeyKJrdOQ3y5slcct?=
 =?us-ascii?Q?o25SFXRsxrFA+x1k9S7r3qcVnmixPKoCA5vf6dZl07z67ev5NZS/cAxrBpPk?=
 =?us-ascii?Q?RBzdr+7GlJQBG7uSk93m3KmpQWO76bY=3D?=
X-Exchange-RoutingPolicyChecked: Gz6wv+uKAETxJ/XuTHSoaauOGPL4RvJlOY/4VSx4ffk87qoejWcVQiP9aLTLD0brUTJOhpmq7eKXWaLbbYDPovIkWDzqqqbuvLM25eW3ipXHJVNixHavn9EDtjsk+np/mlrh+0sxEuY+KWc+nu5OBGyMglpqkNNg2uiSsZKi781pbe6ZOf7Yo1mBSfo2x1k4OVqgixndr2nE7Nqw9LIXZgm+wsdoLrpWSAHtRBa1zWUCXDqN8V2kgKyuck5wggymsBIjexpFokNu9pafv+aom80Mygsc+kkj1qirPGtaA6xWbk2W29tjL2DN2HzS/7ZId8huvrxYyqceSkLqssXXLg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 746ac86b-c0e5-47fc-b793-08def1b329b7
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 23:01:33.6411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: meCPVVdV1oOVIW2cxd9nOj4dHH0BO1F8wiJxQ8a+KIxvAlOrsiYiHEhZ/KwhIvm9bk9ooZ94cbOBJ1ZwNjW4UcGBVd1pfwg9OaByMquCJyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8691
X-OriginatorOrg: intel.com

On Fri, Jul 31, 2026 at 01:48:09AM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Dynamic Capacity Devices (DCD) require event interrupts to process
> memory addition or removal.  BIOS may have control over non-DCD event
> processing.  DCD interrupt configuration needs to be separate from
> memory event interrupt configuration.
> 
> Split cxl_event_config_msgnums() from irq setup in preparation for
> separate DCD interrupts configuration.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
