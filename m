Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F3C27FD6F
	for <nvdimm@lists.linux.dev>; Tue,  6 May 2025 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746547722; cv=fail; b=Lyop1MxxM1s4CSznIpuU0sVQUqIBIbDGBjTe5VpAw/klZQQvFvsgemQT2eA5VX0Ajj2uVhsvL6WVX3i1lnsjlpna2rsnaqnUC3uJyVTPc/+IAOhsyl7/cyaugB1Ic5Hnw5qGvpGJL6K/TyYO9t1socJCTmrJdfY7TeULiGbr8Tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746547722; c=relaxed/simple;
	bh=R72rtuzlG3tJLv4mSrsW3ZiYNT4ZbeWyHerHHVB00YU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GnLMRVyLTqaufbjfZzKh7j7zOBjJaa4cRJickoiIP83pT++JAh9+kr9iL1tymBiAfRLrj1B+HLc2+FiFGl4BbYsU9HAsH7iLTYbYe2nN/rDEvPb2gtze7JKmN37K3xZNd4nC8d/RbvwMDkFbRyPzsc2QXQXZyiJAXrs0LZbNSz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SIDTaxsc; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SIDTaxsc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746547722; x=1778083722;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=R72rtuzlG3tJLv4mSrsW3ZiYNT4ZbeWyHerHHVB00YU=;
  b=SIDTaxsc26ZBBgFigCze0pxLeqCcGqITcBbWnwDz0G5I2aG+cgBpkZx1
   t5SfbW8v8PX1nRpsCgM3DcUy6KGk0ZPZNjAhDb/k0HCAszDwxhKiZx/k9
   4eq8Fr+L5CPG6t9nqNSjw4OVQ+woBzEtxZl1lnOzUEcUtKZ9BzCGjSSx2
   dBPEA9BlGdN75/1j0a8FlGiA9w8ooFFNZn+R1sDXThUazAsr+pLLAsZHj
   D/JxTr8ej/WNwqtEH4dmH9Klv8LvUFErPJBILR+6+ImrX+UWVlY/U3mQ+
   Bek9fl2yNcDtP7cIF7THtUQ4UDWzOxJtLet/xnrDokc2ut2E2X2sfvt7S
   A==;
X-CSE-ConnectionGUID: GnZX3/LWT2GxpGmNg0dO4Q==
X-CSE-MsgGUID: KlhmHSnkR2WErJ24xAfobw==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="52044790"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="52044790"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 09:08:41 -0700
X-CSE-ConnectionGUID: MBgbxP91S82S+X/uhe8Q7g==
X-CSE-MsgGUID: DHRCJrmPRfaztPyZAtkDjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="166589083"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 09:08:40 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 6 May 2025 09:08:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 6 May 2025 09:08:39 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 6 May 2025 09:08:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BPhL8dOdoKzwaVPPHH65PKmbjg/os0d+zUJK/9Xr9t5SI4mzJMylc0LeCElHt3KQzDbZFC0qENvxbe8hMUjSbvodsfv3GxXM2tGerwIUBZiIQV7KRr2CUmFXhXzlk0Ci4sRE4bICD+JdOpWtGRa3tEeJoAFdi9lgyquLkExpHs7K3sQEFEUzE5NWoamWeKeYIE1tpr/UtsWli4dq2OsxLfGx7vGf9vTNWPT0V9CuaF0NWiOZCH9wcwlZO/l5Yn1o5sCro8hHT9MYS15OVq3J2nZ8eNIapiDy1dUvYGq1/zSdK2mofDrZKgJOvqePternfISXDWHspXs3zxH1CcsSpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJQx0FyBq/nMlUsd/vJXQbYgM7p5i071o10Oe9HfxDY=;
 b=HpH1PM4iID+TzazElJ3MZ5HZHSVBe2vhf/5LcNiGJcV+AwG4USwruPoOeH9MfKhjnEW3xKDqPzKz3FtFkxr/o9zcOst3m7phvxnxYEWY4Ze6qQKsMAk36Mv5XylZVoCyy60lvAAAosJkhgROQpWIt05c/4NEJRonKb+CtoIbhGE/r/m4zxAvqb72YEqybQx1/xrkrrXYey26+AN/usS+pa2+aW2t0MXu0Q0hH6VCWmL/WAHNhclx32x8sfqdJGRRSOzk0dflEctKWqHQuQe24wdT3DNWixklzYKy+4Vn4WIWgHO+vEG0KAo5xIKuYVV90RtU5FWIZwoh0ujfaRoalg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SJ2PR11MB8324.namprd11.prod.outlook.com (2603:10b6:a03:538::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.22; Tue, 6 May
 2025 16:08:25 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8699.026; Tue, 6 May 2025
 16:08:25 +0000
Date: Tue, 6 May 2025 11:09:09 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fan Ni <nifan.cxl@gmail.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>
CC: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Dan
 Williams" <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 01/19] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
Message-ID: <681a34255194d_2b95d1294af@iweiny-mobl.notmuch>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-1-1d4911a0b365@intel.com>
 <20250414151950.00001823@huawei.com>
 <aBkn813skYvTv7QC@lg>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aBkn813skYvTv7QC@lg>
X-ClientProxiedBy: MW4PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:303:b8::23) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SJ2PR11MB8324:EE_
X-MS-Office365-Filtering-Correlation-Id: e9246bec-53da-4c11-67de-08dd8cb83b18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?P37F7k/UpW2cZ7TQbiKKC2XRMsgH82saF+Drnx6wbyI6uGheQlUK7CT3VzZ4?=
 =?us-ascii?Q?oinSx/dxSei4ctF739jqm+9JXjb3mZTybnW7zEYqCTOgnRrcfsSjko7Z3YN2?=
 =?us-ascii?Q?Y/OXbHzIGO4LX0Gk2yyxl8eBDW9ic6g223542VfIEZbSMcud27n9+iC2/R3J?=
 =?us-ascii?Q?kKjyifhqyKPya6a6awUh5OvESOKL+H8buS25Eb1IG4yPqPsjGI6e3zTmyKoO?=
 =?us-ascii?Q?hBQcfX+sSs7U2ilyK17HY8wmEibSVNBepSrIgGZEnpURwWcj9WUsONq1NlRt?=
 =?us-ascii?Q?fyc0GzpWbtAmezNcuDHXCpFH0rDNUfgEPiUYy6vdcwtJGJ7Mtkfl/VKPIjlY?=
 =?us-ascii?Q?vy1af6k+6Z2TjZ1r4iUKaxdqkZvTBhhbjwu5ETmsNH18OhwoS1JfcMnWDKO6?=
 =?us-ascii?Q?j/jTHL9h4kWBhLTqrw2wq6tflfcMyJMPqyJw4PFBfCECtYWppfH4BFAJ5GsY?=
 =?us-ascii?Q?1Sg+4MF4qm+TkxkMx0wAdm2GASSruLnlKzHsG9rpBSaMFWDR3klV8bAW4ouC?=
 =?us-ascii?Q?f/6YYqtrrHYjbK75TwRZwsVg+vGaAb2KPEZEJMdWXQk4fLlVcU9M4ThTJkS6?=
 =?us-ascii?Q?/tEbLW9tTr9UZZMn85ukN+2yFkBcyL51BZJRWbzK7gNcWTwR8Q9hMNxCBl5E?=
 =?us-ascii?Q?QcrSZR2D6ldzwJM7l229GfUw2qVUXYmvKJJLz28S189UnJooPCEZmuucuO8a?=
 =?us-ascii?Q?JVrU/sCvg2YUuw9P2yG4XSWsvZWMwXq/jO18zm+RbfNYMeZ6rxwPQXTNZTqd?=
 =?us-ascii?Q?oQG4TUx5ybNTnHxVxZT7UHmPdBJWeCZTpUbFupIxs8d6Gi6V6/WXz9pxVpZG?=
 =?us-ascii?Q?/U/8gDVPbSwXopKBNS3R/V1O70IpO0JWQhw1scPkFc/GN0SnUzm8sXn1KnZ6?=
 =?us-ascii?Q?1BbrXNzV3TYrb5KuEKmdGFTLhT7f8+nbH6XAXN/Y/7mTBvQf+GDANUBkA+t8?=
 =?us-ascii?Q?mInJjQcSTSUKvYgJ53R1Nl6MaDRDrMszj9oRi8BjHfN57DQyXsyh37f26ixT?=
 =?us-ascii?Q?0/xbB2Zo39gxIr2vRONwJXnqWd+4lS3TD0uoKhFS1Bc0VNJO8AerLHBjElQS?=
 =?us-ascii?Q?OU7yNQvJ5Yn2RIBJHb8wWAyhJin/5LwxiauFLL4uzaQwp8IzZXkBolf5P6Rv?=
 =?us-ascii?Q?Om7cTwmHOFrvH5okZhHNdfQffF1SWNf8/GkWtsh7tDCN/KLS9JYK7txcT5R7?=
 =?us-ascii?Q?M00y6+VWy8vlQkk9O8eVpRbRD+cpdK9lCjChU9DPJwaeArUqODbaovMAAlqm?=
 =?us-ascii?Q?2ou2cg4SaO0MVdWIEnfVjzD+aQ5XiuKiAIsy/8f0pTcl0NCWivC9RS6Y+udQ?=
 =?us-ascii?Q?NGUaw7Dfc2oTruWcJVbs+0zA81lfcD14vZjpvf/3c5qcc3e/Hu2xLsgbZXds?=
 =?us-ascii?Q?N8zm4CeSbwqFy3uHEApVk/82FZjVQjrdcbZIO9hTGwnfeJjQYyWHmn6Yn6PW?=
 =?us-ascii?Q?hPnpPBYBUzE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?poWQDOHZ0QOO35N9qMN28MJ9AlRy/617YVaXlv8aLeqIyVvdyD4vttATS/vI?=
 =?us-ascii?Q?wB1/ohkSxTOK6uY6XUZfD1RSa15b+xwfaDi/8mwvkxL3yCftFE83pDezwK80?=
 =?us-ascii?Q?nidTpNk/pYp9+lYYBNyFAl4WGKEezF2i54XO13vsP5pMFloFlywmCfkAOXRH?=
 =?us-ascii?Q?TO5UJQZvMkYn35Lpyc75QQGDYiv8ZIPio7aYZ6CuEbqv7KzdIqQ6KKGdJ463?=
 =?us-ascii?Q?Db4X4cMr4MsJj18CWBRe6oexu5lxKluYv0YiZDEXRPNO0ZZ3qHbjyOPcvOdR?=
 =?us-ascii?Q?TnfhrDbf/GG3I2xSEC/tTS4ntBB+9M22HLfkjQbyHm6ZmcZOlLJ3WuIqcv4H?=
 =?us-ascii?Q?rteYYI647qYrt5VS2fOwq0InEuBQ4dXJePVu44BF2ZfxrxIlRmLqYyidJ+O6?=
 =?us-ascii?Q?6hbq6D4Cwx18YORzwZJT4pg9KsuIbs88Nabnh/ajbzy21b2G91jYC7U0aHr8?=
 =?us-ascii?Q?2H0BontGTkUu5duoLL+hf2dbuWh835jN5VDTIsA6Nn2pUhljw5gw06ZD3N8D?=
 =?us-ascii?Q?iQQT9hLCa+tVHH/w8V4nE+ceShMuh77NdBLa0nvCCLR1rcDn2yJzbZ3C0zak?=
 =?us-ascii?Q?zUcL6FuscROcXXIId1qg67UhCrRw/EJu0vy3Weas9uMgE70HJSzfIMaWGvwy?=
 =?us-ascii?Q?v24rlPwD66O3uAbjzHl47Ok/r+fxby8TBG3Qg4MPa/Ph1NWB+ENYloi92qG5?=
 =?us-ascii?Q?4238IVzRoQ0I/BzMIlE+x7WDn5kbAZn3Z63h3Y4OQVZomVlmi571NpGyO2++?=
 =?us-ascii?Q?T6eXZvEt9Ks1/gyRS0kZ4yQdkde1PCAvI5WyUR6dvsmgNjaX64N/RLm0pd/e?=
 =?us-ascii?Q?/7UZK31jaMOIB4TyphFhQvHHqc1Zl7Eq87p0h8CAvPV2bGA6Ma5umhSxu9oh?=
 =?us-ascii?Q?QKHsX1xqrrnH1F2AI1K3uHPq9ONV0pziIY52HbqKtb4Cx+HAf6FecaYX1WUV?=
 =?us-ascii?Q?iLkTzX4n95tUf/MvcyN6Ep+8j3U46xSo2KuJ+pPAQTlVd94wOfi5s1ZMI7J4?=
 =?us-ascii?Q?+YavVGPdHLtkl19j8Av9tYvEzGMVT/1y0+KyOz8NgnC0fzIaahZ2s2Yl+i2r?=
 =?us-ascii?Q?hpvgqgoKtekO7/AkFwBSOYO3/d1SD8RSQgHWj/9rJtKHoyEctIpKZlNt1EFG?=
 =?us-ascii?Q?UH+kbsTEEavTMQpgG17sR8sQBpV918h5dlBxFg3PqJ5n4flcWVGm7wbkO4jA?=
 =?us-ascii?Q?7T8csDgls+aZHmLohN/yN7qsBh1/ULhQ2xbkLLxIPdOVvjWT56i747/bLheZ?=
 =?us-ascii?Q?78PbwJJirolFyl9zI0cQNlfFBueokc4HR9HmQvTOEKKH83R0WatPcy4JeR55?=
 =?us-ascii?Q?tBSuzO+m9w6vXqu7BcHbAHz4pPPokYS/nx8sKpmSWl77jDgkAf8My2EN2qN9?=
 =?us-ascii?Q?TdGWnRM0/oVy8ZGuW3FCPADxD1DrgWJTF5bqBrDYuLspRIPVFprsuGPrpI74?=
 =?us-ascii?Q?KBG03QYCZ73Cjv1z957dt7lSv/eauhnQG8gl1peCoQMJPTJqA6i/tx1CLzzk?=
 =?us-ascii?Q?N4g5GalbsXPMdo2rykWfQkrw+jVwz3KJf4MAHWs3svImo3ayW0xUA5tbe2il?=
 =?us-ascii?Q?SbwTbvGLK/1oi3dYCKMFVVUwexEQzfg/VAGZM4EF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9246bec-53da-4c11-67de-08dd8cb83b18
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 16:08:25.1900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKtiQWeuyrShCln3q+cIHh1Jq2FROSr+S+aGEJCSNmF+0OxWi4fAFt/V3x5gIiuRU7Xkxexkcj1oYnz0DeOEqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8324
X-OriginatorOrg: intel.com

Fan Ni wrote:
> On Mon, Apr 14, 2025 at 03:19:50PM +0100, Jonathan Cameron wrote:
> > On Sun, 13 Apr 2025 17:52:09 -0500
> > Ira Weiny <ira.weiny@intel.com> wrote:

[snip]

> > 
> > > +
> > > +static bool cxl_verify_dcd_cmds(struct cxl_memdev_state *mds, unsigned long *cmds_seen)
> > 
> > It's not immediately obvious to me what the right behavior
> > from something called cxl_verify_dcd_cmds() is.  A comment might help with that.
> > 
> > I think all it does right now is check if any bits are set. In my head
> > it was going to check that all bits needed for a useful implementation were
> > set. I did have to go check what a 'logical and' of a bitmap was defined as
> > because that bit of the bitmap_and() return value wasn't obvious to me either!
> 
> The code only checks if any DCD command (48xx) is supported, if any is
> set, it will set "dcd_supported".
> As you mentioned, it seems we should check all the related commands are
> supported, otherwise it is not valid implementation.
> 
> Fan
> > 
> > 
> > > +{
> > > +	DECLARE_BITMAP(all_cmds, CXL_DCD_ENABLED_MAX);
> > > +	DECLARE_BITMAP(dst, CXL_DCD_ENABLED_MAX);
> > > +
> > > +	bitmap_fill(all_cmds, CXL_DCD_ENABLED_MAX);
> > > +	return bitmap_and(dst, cmds_seen, all_cmds, CXL_DCD_ENABLED_MAX);

Yea... so this should read:

...
	bitmap_and(dst, cmds_seen, all_cmds, CXL_DCD_ENABLED_MAX);
	return bitmap_equal(dst, all_cmds, CXL_DCD_ENABLED_MAX);
...

Of course if a device has set any of these commands true it better have
set them all.  Otherwise the device is broken and it will fail in bad
ways.

But I agree with both of you that this is much better and explicit that
something went wrong.  A dev_dbg() might be in order to debug such an
issue.

Ira

[snip]
