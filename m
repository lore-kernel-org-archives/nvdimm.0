Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAE62DFA4F
	for <nvdimm@lists.linux.dev>; Tue, 15 Apr 2025 02:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744684601; cv=fail; b=tAujuOYx9M3NqL/V0oAtWamidwR5t36P5G/Df12a1qip3UASAEgw4MCTxXpfa5wm0w8FmHGt3nxadpuPJd2CYdQCPTRZeMM6bWxzSWZEm5YlXEaXgdfvd+fjhTDLT4Tz0qpEE1bJRmhxg/bpmE517sKXAuGSiemu4QBVdY0KSZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744684601; c=relaxed/simple;
	bh=cV0fVd5TM4RCLV4+UmRxVXVILaXOFR6Ii3gkaUzKT3M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LpLWGvzHYiinigTgNfirLvufvPfwWcN7+0riMNYdbcfT+eDk4gTem6dhe82tTwwnatXJnoTB2Y6wKnUfOhMLzWzm9xxuHpg1Z6X4k6tb1JlX2NvICxV08+z0dc/0OpcFGoLjPXg8Oc9flDQnHmR4lfNU6cEvvjXuDUhkn2D/ZCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gY3d2aUb; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gY3d2aUb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744684598; x=1776220598;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cV0fVd5TM4RCLV4+UmRxVXVILaXOFR6Ii3gkaUzKT3M=;
  b=gY3d2aUbUL9UZQFi1Rmoqz1Xl6fuH2cVEvJdPbsP4+yANlFp5fhd0PzS
   fuB2Ds7YBIr4OvYCvM/ziQhyU6TebLYl4RQYteDL/MQEDtbfRCocpn5jh
   DlpaMDtYsMdOp37p/bzmSAiuZ0Y1imGrwfUliFoNaIRWEf13knjBjTBO3
   hsV5aMELXRYdHkYdHrk6xR1zhT4exJeNXU9od3bovhhcrUUjc1SnNJgsk
   XwHb9G+HOFDzdisFeulM4yT57jkjN+NCpl9v4D4latTcsxpBlYUmUlHEH
   a+TxGGphmEZLPE2RbVdQ23LM9nARy3wCfynErnsmXU0AI3WPEzP1lgDHG
   Q==;
X-CSE-ConnectionGUID: GY3iUQgaQui+mleShsBLCw==
X-CSE-MsgGUID: 5dP0vTpVSDar/EZGdPF7dg==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="46304753"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46304753"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 19:36:37 -0700
X-CSE-ConnectionGUID: 58Uep0PdQzOUypAGjVyotw==
X-CSE-MsgGUID: +Fijsz0ZSg+Iw8y04ekzkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="160949593"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 19:36:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 14 Apr 2025 19:36:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 14 Apr 2025 19:36:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 14 Apr 2025 19:36:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VAdYMMOWP89yghErG7Mw7WEH5cTCFRiRWT+m/eaAX0JF6UbXo0DQVRTJtJqWhI+3phgX2Ey+h6xssKpgJzpvyFWe5UypIYNe3One1tCxqTFwxV2zqIt3qa/oe3EdoyQh+9Awte9MLcC9LhRgnszYzrce9nRe5rH5IYUYu83NLozOnqW3iWc3AuWdrV4PpzAFtzz1C7dFTiwkdpTDJVNpOnAHIidaWfw9yLltI5tIVf+iezVi8n0lWG0c7i/BF/0mE1QGztWg6I4uidOGjrwwtrhoF+hvk0lwkcevx+BPmJgCgTXAUYsS7I9CKcxeR0k7oksjtmQNzrtzewQhJb1DUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGpDDYbNQJhKlOMJhsS4vxB0bR0Z5RCeEqOAknD/Frw=;
 b=SMwawwcMTQmTy2oYxR/Qbi3vpyQ3M9R2LdgYfiyG7yTu3ROOhw3ubn4G4OdDEy3n0ZLwet5rErq7ei7dt/FyBw52orLBYx9N0lm/RA2lgOeJf7HaNZEtW5x6csDW0tIH8QZG22sj73AW1s+hh7Rdq+mZ8JokOLQ1jWdo+zucHNSbh/5PfrzGftvOw8e99K0QRdDPiatwn+20dHMmRAJNbJloE0qLFgnSLqNO/hqeQxeY9SRJCEsG21rIg62Tvy8CTDpM8Gx+dKbMZmzpdNVtuBZgBvb+b1JNIxxURGIK8wHhLGcWWckyldfECw3y82JVykz5IgonKkjnlIOkJQ50KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DS0PR11MB6352.namprd11.prod.outlook.com (2603:10b6:8:cb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.34; Tue, 15 Apr 2025 02:36:32 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 02:36:32 +0000
Date: Mon, 14 Apr 2025 21:37:02 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fan Ni <nifan.cxl@gmail.com>, Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <67fdc64e3fa03_15df832946e@iweiny-mobl.notmuch>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <Z_0v-iFQpWlgG7oT@debian>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z_0v-iFQpWlgG7oT@debian>
X-ClientProxiedBy: MW4PR04CA0150.namprd04.prod.outlook.com
 (2603:10b6:303:84::35) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DS0PR11MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: afaab804-fd0a-4734-6b7d-08dd7bc65565
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LTL6SzVpEzFx9/Oie6ESHQplbLVeyww7+lEidDo6HRbIYjDWDnsGv234ayAD?=
 =?us-ascii?Q?QtwuliySHhXFqgmvphjMDX6fs0P6uYCUaTz4VoLvirlm7xMadM3nYacHBpDL?=
 =?us-ascii?Q?cgAlPcrx1gkHWZDZElna0xiQSt08MhjM+hsKXRLIK9xY4eQKD3dc03u+KSp3?=
 =?us-ascii?Q?T1Omb729lnHE52HSa0oqFst/kByMAw7O5UD9zZ7r0e968eicXkmJF87jRagg?=
 =?us-ascii?Q?LSubJgOGXHOfTemVzsYWZh4JMRP1ZvPbueqQYb3mXHlVZz5Xi9kkV8ybTUzE?=
 =?us-ascii?Q?AoMh0FnioPq8cg03+Dn8tsbML+i9moGFMyKaTnIcHBXuARA0MLZfREHl3WPL?=
 =?us-ascii?Q?JTY3SCWfV7IUxiOgqs/gjNkwzOfQjOHZN5EhmTvgJ4JCaWhe/QyfqXG2kseW?=
 =?us-ascii?Q?KK1c74cXZtmywKEYFDzi14jlAIMIeXDr5aiv8eFSuBGFS1sqK5zSk/6dKwM3?=
 =?us-ascii?Q?NPV1x7ZWQJP5YMSpRUz31HIh/kot5y0GJ+DBys+bzPFhKXOy3aPfa8o9QPVc?=
 =?us-ascii?Q?oIhEwg9Kujm214Ubp3NF6tDg3CbZU6lXTgSDnLsZdwylhA0FZDjV+agNsYmR?=
 =?us-ascii?Q?ukCychfbyzS9fqVbPUkCUFEUNUkSRF895ycDYPn8RLYXsN1ZdQnfFFg0ykjj?=
 =?us-ascii?Q?TN65YH+SV7nBXsyaljcGR8nkbg9kBQGZZZQf25qMDtKfVarcCI3rhGKg2GEW?=
 =?us-ascii?Q?oz8UM6ojHClZbrJv8GlSyw9MeoxNFPX54MYPMxHTeJdnLOnBZ+JtnCbMA9Je?=
 =?us-ascii?Q?l7yiGxu542nzDOlQ8B2RGgEliZzZJYCwnTBE6lj0TaGS8xwvpMaISJqkURSo?=
 =?us-ascii?Q?G+l2lxDaAQRXExjOtPPAuVfAvXCu2WElojkWtSpA7POlAW7goSD8CRX2SvP0?=
 =?us-ascii?Q?59bQ4ZH6Wqp8bSKWSHpYIVPyyohRkS3moX/ou/KoLgGNnOuR60ro/F1JuhXi?=
 =?us-ascii?Q?MavwWsQpCOQk/aE70trTOYJA87cXkAov3JRmgvBJuyOLgzVcLyY9Q+TTIAEb?=
 =?us-ascii?Q?kRpR+Mzjpn+/F1HWoXdL1hdtWD4CSviGQkMfReMSbDyhZ6BJwYoCur0DQ5Gl?=
 =?us-ascii?Q?AlNSKYlXJnIoJbZOhuqC3Z98Xs4t97p7RtjMPdR4X24mjJKAVJcPyyEGDTZs?=
 =?us-ascii?Q?M4J7XhZAy5FLaHCjzPSgCZTED6J2+52PUpResnGW03T89pYBoAgiZtg7GUqJ?=
 =?us-ascii?Q?hiLP1nnWz/zfyCVMdNs1VijA3YO416+nmVTXtZDqubIAzn/nzir4QDXk5ZmY?=
 =?us-ascii?Q?f62WRE4OJAsEdP74qV7zwQnUqF7vBlw9j/C+5h56bhQxN65teXM1yR0X/K2M?=
 =?us-ascii?Q?WNZD57X8YznWidAOcVrF2UtgwpjwpFBgmTpPbYKxohjZfB4C6NSzohXYNwn7?=
 =?us-ascii?Q?7JhnupdpsJU2IbWRrTSn9zHx9w9v8p62NBA3w1KCxX3v4SRr0MByaAK/QLCI?=
 =?us-ascii?Q?dpcYUfAY95s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jk/0zaN/YDbSRr0u4+QRXV83jtD60jYiSy8qM2q5t1w+kCuWSyoaq81lLK2S?=
 =?us-ascii?Q?5hrEIoxD8quxZIHEeyjzcUm+kkywmKFZPNCZxoxcaFfCj74ftzfeSBAWbCit?=
 =?us-ascii?Q?CVdx3PpjoqcHU7Mo59reBKc2SDSePq3f4MutJTPUoQHiZsAJGptrOiwxE3ng?=
 =?us-ascii?Q?drOO7t67Dkr4Y+gU24IRqYI2STcHH6iVmreOV5URYPwMGDLyeC2LbvHlySh/?=
 =?us-ascii?Q?RrPeTV0prgXdWFps5V/C9V77X7iUfA1xmvzbcCCrVvbcf2nYj7oNTZ+go4y0?=
 =?us-ascii?Q?Rrxg2Q3pSjuNk4n4yQYx+aeO8gG9hnjZjYoNU1AXL1hBi5KJAoPRA+TrXFvk?=
 =?us-ascii?Q?Jhxu7fUek8c/zwDKmuoUJZJWqIvVa/N2m0RfE33TTxk/RjWCjc+bLZTOBfUX?=
 =?us-ascii?Q?giXWALtLdex3S456GBi50yoxHiux19GGSB+LUF1PqNuZftMKckwrQW3q6rpG?=
 =?us-ascii?Q?GL5Wxz3U3EsdChLlHXrRKoxrKN6nioQPQTa/3EyXUKYxAxMVe/lCQBQ+Zdp6?=
 =?us-ascii?Q?DAb31P+UmsYIm0kzKRzIJl525fxvzDXHt1ZH1QSchECTXKcjrunhLGfVYuTs?=
 =?us-ascii?Q?GX7Hjepa9mMQKFfL00Ym3CWpnDCf/QYaOGyQNfh1nyAx1ATy5TpSovLsybOI?=
 =?us-ascii?Q?RxQJugBJxRCaHrEiOv5zpnvExRYTCIhkkFeOOV7uKfOELq/R4osr1qJkGoZ9?=
 =?us-ascii?Q?/jn4xpNa5OXY4RoidBoTH+LnPfVXeOTEWgGJTFPTNkEHQ3iQ5BOw8UFGJt7o?=
 =?us-ascii?Q?LNUjAjj6MNC2LlZ4Igo5WTi554U8HxJocWgWRooAPPt/WmXo7TBw6CZI5UrU?=
 =?us-ascii?Q?EcB7EiKbBzZ0j39icxlnaYLIPCC4kSUgbu/9GFxzv+BJQI1e8DPXkudcnirj?=
 =?us-ascii?Q?B8Iv7D/kp5q83MhPLLx0jN/G0AXdSOZi+WGewkGwvCuY1ou6NXYTcHkZNnHy?=
 =?us-ascii?Q?NdTtSkQY8FcG6jbrvt16ScQjHXy6fx7K593ogNpyODD2g9XG+tDN0+tEvcXr?=
 =?us-ascii?Q?RLwuawhi9q9w2pnYEbYG/4PzgjNMzz4CJqk2h2TLkCMqYvgTKcKLjRi/aTwK?=
 =?us-ascii?Q?HAFMc4nJoxNEMUw863IlnD47UurzCObuBCBe50DRWN1jZOTEEuJJpqTtMSIV?=
 =?us-ascii?Q?vteRCRRPnNkVZBdhzKdKeknlGyBa64xOQrVsQSgPI7dZzT3TfE/NbEJny7Tp?=
 =?us-ascii?Q?kEntsHOZ7LmRLPkJA64oSEAzDCmgnRr4r6HYUuGZSbLnBORRtalF81MYlV+x?=
 =?us-ascii?Q?MGU4cPvZBp1hTYwZqiv9DQt5it4qtX41wgtVR5wc/fzrIiRQ1tEJ31mljM1J?=
 =?us-ascii?Q?NtB0pcWX/kQrkrqC6GFCt7vXvESr3MpD8PvJl4gxxj4xWzuSGeAUPUq0XGda?=
 =?us-ascii?Q?upNTwjOFVJ+lzG6QsBsdUFBUPNTBawG+oBWuNbTbA6q+AzRTHjREjnVrfx+b?=
 =?us-ascii?Q?uW/QDRHHCx1LLiB8w+IYzO7/XJlNznnCrtsfEthUTrMeX09uTkt78yVvDc6A?=
 =?us-ascii?Q?457bgU3qkNKkKwy7jcQGTcT0LxCWAGZ0XVa55Istq0iJ0Dmwp9I5WK7n1F4/?=
 =?us-ascii?Q?kuK25ekkJVhbhK6J3MUeMIY3XwmfM7uHV/XRSY1K?=
X-MS-Exchange-CrossTenant-Network-Message-Id: afaab804-fd0a-4734-6b7d-08dd7bc65565
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 02:36:32.3941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szu1Rhr5IaoVecsCm8pwRvIb49d1L6TR2Rffi9bVf1rcqhux7V0e5VmNLluAHgb3hstY0tOkQ7CV9+lrjyncAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6352
X-OriginatorOrg: intel.com

Fan Ni wrote:
> On Sun, Apr 13, 2025 at 05:52:08PM -0500, Ira Weiny wrote:
> > A git tree of this series can be found here:
> > 
> > 	https://github.com/weiny2/linux-kernel/tree/dcd-v6-2025-04-13
> > 
> > This is now based on 6.15-rc2.
> > 
> > Due to the stagnation of solid requirements for users of DCD I do not
> > plan to rev this work in Q2 of 2025 and possibly beyond.
> > 
> > It is anticipated that this will support at least the initial
> > implementation of DCD devices, if and when they appear in the ecosystem.
> > The patch set should be reviewed with the limited set of functionality in
> > mind.  Additional functionality can be added as devices support them.
> > 
> > It is strongly encouraged for individuals or companies wishing to bring
> > DCD devices to market review this set with the customer use cases they
> > have in mind.
> 
> Hi Ira,
> thanks for sending it out.
> 
> I have not got a chance to check the code or test it extensively.
> 
> I tried to test one specific case and hit issue.
> 
> I tried to add some DC extents to the extent list on the device when the
> VM is launched by hacking qemu like below,
> 
> diff --git a/hw/mem/cxl_type3.c b/hw/mem/cxl_type3.c
> index 87fa308495..4049fc8dd9 100644
> --- a/hw/mem/cxl_type3.c
> +++ b/hw/mem/cxl_type3.c
> @@ -826,6 +826,11 @@ static bool cxl_create_dc_regions(CXLType3Dev *ct3d, Error **errp)
>      QTAILQ_INIT(&ct3d->dc.extents);
>      QTAILQ_INIT(&ct3d->dc.extents_pending);
>  
> +    cxl_insert_extent_to_extent_list(&ct3d->dc.extents, 0,
> +                                     CXL_CAPACITY_MULTIPLIER, NULL, 0);
> +    ct3d->dc.total_extent_count = 1;
> +    ct3_set_region_block_backed(ct3d, 0, CXL_CAPACITY_MULTIPLIER);
> +
>      return true;
>  }
> 
> 
> Then after the VM is launched, I tried to create a DC region with
> commmand: cxl create-region -m mem0 -d decoder0.0 -s 1G -t
> dynamic_ram_a.
> 
> It works fine. As you can see below, the region is created and the
> extent is showing correctly.
> 
> root@debian:~# cxl list -r region0 -N
> [
>   {
>     "region":"region0",
>     "resource":79725330432,
>     "size":1073741824,
>     "interleave_ways":1,
>     "interleave_granularity":256,
>     "decode_state":"commit",
>     "extents":[
>       {
>         "offset":0,
>         "length":268435456,
>         "uuid":"00000000-0000-0000-0000-000000000000"
>       }
>     ]
>   }
> ]
> 
> 
> However, after that, I tried to create a dax device as below, it failed.
> 
> root@debian:~# daxctl create-device -r region0 -v
> libdaxctl: __dax_regions_init: no dax regions found via: /sys/class/dax
> error creating devices: No such device or address
> created 0 devices
> root@debian:~# 
> 
> root@debian:~# ls /sys/class/dax 
> ls: cannot access '/sys/class/dax': No such file or directory

Have you update daxctl with cxl-cli?

I was confused by this lack of /sys/class/dax and checked with Vishal.  He
says this is legacy.

I have /sys/bus/dax and that works fine for me with the latest daxctl
built from the ndctl code I sent out:

https://github.com/weiny2/ndctl/tree/dcd-region3-2025-04-13

Could you build and use the executables from that version?

Ira

> 
> The dmesg shows the really_probe function returns early as resource
> presents before probe as below,
> 
> [ 1745.505068] cxl_core:devm_cxl_add_dax_region:3251: cxl_region region0: region0: register dax_region0
> [ 1745.506063] cxl_pci:__cxl_pci_mbox_send_cmd:263: cxl_pci 0000:0d:00.0: Sending command: 0x4801
> [ 1745.506953] cxl_pci:cxl_pci_mbox_wait_for_doorbell:74: cxl_pci 0000:0d:00.0: Doorbell wait took 0ms
> [ 1745.507911] cxl_core:__cxl_process_extent_list:1802: cxl_pci 0000:0d:00.0: Got extent list 0-0 of 1 generation Num:0
> [ 1745.508958] cxl_core:__cxl_process_extent_list:1815: cxl_pci 0000:0d:00.0: Processing extent 0/1
> [ 1745.509843] cxl_core:cxl_validate_extent:975: cxl_pci 0000:0d:00.0: DC extent DPA [range 0x0000000000000000-0x000000000fffffff] (DCR:[range 0x0000000000000000-0x000000007fffffff])(00000000-0000-0000-0000-000000000000)
> [ 1745.511748] cxl_core:__cxl_dpa_to_region:2869: cxl decoder2.0: dpa:0x0 mapped in region:region0
> [ 1745.512626] cxl_core:cxl_add_extent:460: cxl decoder2.0: Checking ED ([mem 0x00000000-0x3fffffff flags 0x80000200]) for extent [range 0x0000000000000000-0x000000000fffffff]
> [ 1745.514143] cxl_core:cxl_add_extent:492: cxl decoder2.0: Add extent [range 0x0000000000000000-0x000000000fffffff] (00000000-0000-0000-0000-000000000000)
> [ 1745.515485] cxl_core:online_region_extent:176:  extent0.0: region extent HPA [range 0x0000000000000000-0x000000000fffffff]
> [ 1745.516576] cxl_core:cxlr_notify_extent:285: cxl dax_region0: Trying notify: type 0 HPA [range 0x0000000000000000-0x000000000fffffff]
> [ 1745.517768] cxl_core:cxl_bus_probe:2087: cxl_region region0: probe: 0
> [ 1745.524984] cxl dax_region0: Resources present before probing
> 
> 
> btw, I hit the same issue with the previous verson also.
> 
> Fan

[snip]
