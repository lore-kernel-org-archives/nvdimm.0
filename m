Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B89D144D2D
	for <nvdimm@lists.linux.dev>; Tue, 25 Jun 2024 21:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719351384; cv=fail; b=dgHWu3wAZQ386PtESfq+yM8mXHxcTBFiAd+N/UXag+K3xWHeYONoWZ2h5kS8AxLQ8nXDfF1GeqAKJTWiBYHO38hE8j56mCN9eSrwsJeaRRJJXVMUVCrPvDae6I5JHrl4UH+Mf+jB+LSCtIXqWNb6n/fZRheEaH858IOqB9D3sVU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719351384; c=relaxed/simple;
	bh=6oKdCRbXXnPUsIIPHCr+edvflw2zd08Fpwbdp0rhstg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bZFFs9Q/F8Bx+pe58CEOz88WgWd2I0ScRDQzJdKJvy96TNQq9LQ3RtXoCjBHg1wXCzgP3DOvg2tRpaZYQzVmEL783lxgCXdF1GopjriBzTL73wbUcC2E92b9W/1XYZDh4OQ3SaCUgX06en27DVn1ne2Pnfz12ofKLXp02g0snEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VrYGpm6n; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VrYGpm6n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719351382; x=1750887382;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6oKdCRbXXnPUsIIPHCr+edvflw2zd08Fpwbdp0rhstg=;
  b=VrYGpm6nMW9heeefEWt4CE7AK2x54XOaMstIQscfsMGhU5ZgZs3K3yvN
   yoqmdZrLM9xKQPEyUfUGF8TUoCv11w4w9BlTmAAeYnU5GNEqq4mUxXTnP
   rg6HXlK7SC5L2ApXCnwPxg0EstEABOlfgeA5O1PPgTpOapa0l0dXV8ErO
   Mc+caOPiONiSz+BAHt0Y/CkF5FVM8rp7Fg8QhKBB09WXa/trgAnhrlrns
   yFognkcjXh4RySmojOhuWXErchm5UFt0LJkScxCcknRXCMp7nr2vS9GKD
   9F+o0xcTJmmSyYVDz2r9P5iCo5RuxjZMROg/ehS+GYrO2N2cd5m3hxIaW
   g==;
X-CSE-ConnectionGUID: vTOl2YguRjO+3CPMQUp4lw==
X-CSE-MsgGUID: /ihcy5oXQR2XdJBngNm4JQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16273427"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="16273427"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 14:36:22 -0700
X-CSE-ConnectionGUID: urdCZvl8R6umtYZjNtofSw==
X-CSE-MsgGUID: msos1xQLQqezeO63YBqDwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="44499593"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 14:36:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 14:36:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 14:36:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 14:36:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUcWSq/yKiUaAMweTzVwGGMXGf1KSu3IbtUazE8+cQfpP49LPnGrmW5OUKNftxqQWMeqCNajzWpKtswC8W6PNRrgZYtVk1s6Twy1MW5Z8I/fO97QArQ9N0D/Wfzx4ChFObS9bwlxR5nny8v2v5zVtgIHRxwjNG0ft5sC1HBGzb98voIYyxBoz5ARzHjNhNR6APSqGmDzbhJhdiA6OYOlHM+bUPpAprsU8wTcHHdty7x9FyU40B6e+qFeLDy86rl7idmfcch2k8oMMKVpI0mbFrkYz4FKbUeP0plro7iNWT4yhJmXrxy5JQIf3iSLAbxMST6qbXqXc6ahAwuUoCCJkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nB9er8bc/S4ojlBmBqhVAGrwjADad4+QvGT3q9v//Go=;
 b=avvSLjueQous+VkXO+xhmxGTi5qBp92+V2n1p/ocPyzsli2OZpE9lvHaruDjqJV849ws7qvstZmpYsPw8/sdgF4Tab3WKh2zd3XkZMEzrqiO3/fEwAAV2yOj5uMDIbRfJ1PeNB5III/dFwxbCNnzM9GDZYLxhU26OhAW2X6EYWJXwt4ba68Kf9mNSbWRuqWaHr1kLJ7LxYFDE4XoPu3ohVy4B6bumMKxUBJxZ+QthaaCO9nDI1hd7hFiU98qDlSGimPcdNay4lMQL+Hx/hoPad1kSMJI8RqYtFMTPr/YbBfMxV3s8bByC8TLmRUhaIVRBystwozG23cdDFC/IffTrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by LV3PR11MB8725.namprd11.prod.outlook.com (2603:10b6:408:21e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 21:36:19 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 21:36:19 +0000
Date: Tue, 25 Jun 2024 16:36:15 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] cxl/test: Add test case for region info to
 cxl-events.sh
Message-ID: <667b384fd15e_32bf79294bc@iweiny-mobl.notmuch>
References: <20240328043727.2186722-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240328043727.2186722-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:a03:338::22) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|LV3PR11MB8725:EE_
X-MS-Office365-Filtering-Correlation-Id: da6805e6-e32d-48b2-4130-08dc955ed944
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|1800799022|366014|376012;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bIPuk36K89L5RjtEQ0veHMb72BoNHCAdstqep+13QUpT0daTrBEN3MaLu5S1?=
 =?us-ascii?Q?w1TxkXx6AFgu1Mq9y4POXmMBtGkavelvGPcqtXl4n/cptZE8hthB1NkL/XpV?=
 =?us-ascii?Q?9r3FGPf1J9kwXzGuMo4JAPd5gDI8gbBOeqSHpXS4kRH+rKqFZH3/A6pxSrHD?=
 =?us-ascii?Q?Jwxkni/gLJRpl1ii+4dBp3Aa0h5Df3EtWKztvpwHBB7cQvPlDL3lmdS8M6vC?=
 =?us-ascii?Q?Wy0FnIS5N9aE3AK/EvdeTJMDhLpQKYq/jl4CgeUWmT4w+ijFWQHqK8FgCEoo?=
 =?us-ascii?Q?e/Lj5tPTyCsUWK/jB0L6vqla5a2/xvjT0uVy7WbJlAxY4kSjXAJDVMls0mv9?=
 =?us-ascii?Q?IeRtY6GfUtOxZnPr8fYGDIhBWoPaeEa75p8sSKckXfRaB6iPYresIIxuenvp?=
 =?us-ascii?Q?W+iWvZ+pOajcIUJtB423+6YA+7cfNeMbsra+FYS4zUGMX24ZoRsV/4r9ruUr?=
 =?us-ascii?Q?bdfcf780ckI90zklk3ubigApG2/6kWrRI0eq6CtsPZoAKgTPh9FuBiMopqAf?=
 =?us-ascii?Q?AV+mlO/jFKqLYcEbTg+9OANLBVCeiE8EUBlPhyv9c6FC+1gBeTVF4tslBu7e?=
 =?us-ascii?Q?9RPONZtJxxbR+4GwJFyQi0raOVa4iclt7jtwUOLUQMxf43LaUY9rppFFCqGd?=
 =?us-ascii?Q?sZJJ2JdYGVp3J+TMYwVabB8TYgydgRNUSOYn3d4H4Waq3cB6rzXKK8vqp0Da?=
 =?us-ascii?Q?RCS2VAMNoIgjTBq1PHwpzrlRffFOI1UnGbiHnWycnXLL/fUpoN9aJy+D7yM8?=
 =?us-ascii?Q?ssjOZW6kttBsdh3dhMTYEyEjoYByQQ+7oYsyRb8wBsCkYutCKPFxnVsikYxF?=
 =?us-ascii?Q?ZxW7+ywFeYWvDFpA2/Su7KrUXW+Q7VmytRMO2/+OnEPY5eo7FZ1u4F8EE++e?=
 =?us-ascii?Q?Riof3cPETNlRzU1XODLsdnPTmZkbrqpuGGWzIgh/CdiOWb0RT/xYCTM02i9g?=
 =?us-ascii?Q?bKViDxVMEZkxSI7U7AIgfyDuJNWbxHmgIPtJopuHNIDjStCaUBlNT6sajai6?=
 =?us-ascii?Q?o2QLoAqxdULES7O1q9ZAIOn9QHQwr/DQjfgRLVqX2eGuQGDyVEev+z5i0X06?=
 =?us-ascii?Q?MLqIUWLhztcsjmAIv6sMA0LpnXWh2Gfha6ANCb3XUGygDHxYd9vTt5ryKqy7?=
 =?us-ascii?Q?OtWby3h1Bq4ONnSNwP7QJ4a4GBi7BHW0NnQ6lhq+yfGAXs3ePztar9JJLcL2?=
 =?us-ascii?Q?ZQOTg1f5jUeKZ6nYfuGLJdFlhm8PwZQyAssZ9fBiohcXrSmgwYGhKy6Nsigs?=
 =?us-ascii?Q?IGfKNfccj3zmAKYtYNnDNrjSGFMLgaF9uPa+uRZHij4q/ZBi0O1TM74L/2IK?=
 =?us-ascii?Q?6DfHwQgiQ/DljcuNui5LZ82cXMEJYfMNSIKGonegFeh88A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(1800799022)(366014)(376012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O/GagVtJT52Xb1n73RCNbtXUhpTluyUcOzfYf0y3pULKMZb38P/OjlMDEItg?=
 =?us-ascii?Q?GcoAmM00+LPeBT9G4dK/Y+DlEEbriM9rs/O9wCWANFLkpXa04Fep5MW5TiRo?=
 =?us-ascii?Q?FJ8LQ4VTaG7U/H/pLQgp7wUmH+0mYiw8piucgHa/Y0hEl+aRrG6PUkDLQBIe?=
 =?us-ascii?Q?zzvNnGjRQrl+7zG0KCaiZVVKHCwWIrIj5cEZcyNLhbLhDdbtA4Wv3+ulKpG0?=
 =?us-ascii?Q?wQL5xsFPrkNUqvCcwgaMGwoz7XXmZgOxqt9rhy1wkdgVZAEOm8bW1WapaXb9?=
 =?us-ascii?Q?bz/tRZCN9Ha7fb0pXMcHq8GjNoiCE7/K4M3CaorVgh8JmleFEp+7C/Q0KpU0?=
 =?us-ascii?Q?ZxExNA6E99rqXXMShj7NXiJHVZCxxCWV/1taNqWM8k6hLoFfsCzsMJ/GPIV5?=
 =?us-ascii?Q?CMzxsbjpEDbXdB9MFjZcOk3KDOdPAeknVAmR33iHUwexNxbI9O04h8+uhGkJ?=
 =?us-ascii?Q?UPvxwpOkKDFk2INrgdkFI3KOSuzeW9r1hEsL+U7Q96VPHEC4Tivcp95v3Wec?=
 =?us-ascii?Q?jTzRBn19echwWNL8625jxg9TiFUl3k4FZwXCF5Tm/2ZwPee0hPfidkcYIsoO?=
 =?us-ascii?Q?+mxg1ecDWRytjNnM6NtfkZVPLJIo+HFGReH7QbVwUxCWNkZWVtpR+ZUEV+6J?=
 =?us-ascii?Q?8eeqOaPD3unxc0r8op1GtEn4te+1mFMi6TVAyqNsz6BFZjxraEP8q/mCyx35?=
 =?us-ascii?Q?DW337lLvhCSI3O0RhqoIJ7Xu/pFUy5ZV3NbryW+MR+mP7d3+Eh/UDQjE5Soh?=
 =?us-ascii?Q?dTz48DeW2m7oaojtr6dSDwflnx8AtFfhclFLDbmjpTwund5re7gKH8N1DZMi?=
 =?us-ascii?Q?c8vj69bqASh8EX00bslLZtXGZ11iIEdBl4o7kWyRoxI5pyG1ISyArYxk6kab?=
 =?us-ascii?Q?9chuay72BnnsLomlfiTOjq+h3XYJdFykhrpaSjt6xSSXBqM6692qgQVF1Sm+?=
 =?us-ascii?Q?d4a1HwgQuUMK8o2Cr0+NVn+oQgigHlpfFDH2aQYwtJp4yl6fHcL7kP81QeaK?=
 =?us-ascii?Q?XTIPQ8mARIhpfLoPf9o+wP2rxWj/gZOEH9KqRtrvmBQfV5MV2SwidTt6ALVu?=
 =?us-ascii?Q?i7p2pQQ0nGt67r+FajSqTEO1RUlcyfE5I4kNORBY1kCWL9kc9Pdy3OLgTa+b?=
 =?us-ascii?Q?pCeTQxefTW2gkP2ah68NawB2PPVsTQDF6zJ24O8dPXteb/UgsffS6UKdhhR4?=
 =?us-ascii?Q?RvrezhJXTO0PELdFkTzqSdUv3FbmA33kFwIygV4Z2RfH7ddAZkZyaoUfTw1G?=
 =?us-ascii?Q?ejQ6cKFqBAnZrG9uahXZXXlsl2YMvlUuDGaUr94XQswoE+Qrh0cC0lkSa4nQ?=
 =?us-ascii?Q?Kux5EHi3Ina/8/IkFnImWViz4OOO9225ECZq64dw7EoJmQK3efsngFJ8TWet?=
 =?us-ascii?Q?Xl6onJOnf4HO7+ltsXvyqlDsSbg1dmvaHL8A9VrDKgKWQhJQjXfB/43d8R3y?=
 =?us-ascii?Q?uOYgy/qetdczLtUKXvD441YFNx/8NyZFshIUjiZCTUKf069Zcu8WWJs7txlR?=
 =?us-ascii?Q?xy3sqNsdRr1VDFfG8gA/99//zv3p1Tcr44HgsWdlUGRsv2K0RBog5TIK58fK?=
 =?us-ascii?Q?GixPW6e/9u5OsSWO8NcP92MAAeQPYsAaKql2pb1Y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da6805e6-e32d-48b2-4130-08dc955ed944
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 21:36:18.9289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R5+sPGohVSNEAWeaJDGP54QsT0zeKUnBQIG/wvEK/1OVauUGytP6FaUEQ5y2LMWviZp32OHvEmc+Qs2sDZahNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8725
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Events cxl_general_media and cxl_dram both report DPAs that may
> be mapped in a region. If the DPA is mapped, the trace event will
> include the HPA translation, region name and region uuid in the
> trace event.
> 
> Add a test case that triggers these events with DPAs that map
> into a region. Verify the region is included in the trace event.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
