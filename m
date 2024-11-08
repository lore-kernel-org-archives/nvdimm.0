Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BB4199FBF
	for <nvdimm@lists.linux.dev>; Fri,  8 Nov 2024 20:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731097027; cv=fail; b=hGIz2/iDKX7836bVqiZn3+RTCoEbginppbi57fl5RNX7/YQrrADhOvBPMZY+KaTRrzMtzkdg9pyH4mqSU1Khil8h8bdAKwUPZhXAcWPtAk4jLLMjvYgcLyl7CFelTSv5tdIN0pN28QFTBxQpQjcpOcSGa21xklRv2fZrWfXRnk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731097027; c=relaxed/simple;
	bh=hP2t4CBoo6G9nU6Q9IWkltJXnVYS1QrMe302sEcyVdA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Oj2Yt34cHLzAkcIHS/zcjUBigtwXN2rtAdmGS5nfTiL6kcHYT7IcmErWk8yPWD2PlbMltDHQVNBDgAKwgw/a9hhJk2yfqvfFqEkTkemekTE71buUA5lSMTKihagJxUBsGOu1g3+kSabwXjyjjoB1F+0A0Q+7IhlA2iHNCOC+alg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nNa4/jGo; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nNa4/jGo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731097026; x=1762633026;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hP2t4CBoo6G9nU6Q9IWkltJXnVYS1QrMe302sEcyVdA=;
  b=nNa4/jGor7yMdI5+U2fBW4bLBwZS+qUMICvWvq4kDX4OE5PeBe6TX3fU
   PsBwxBbHlD7led872T+jmFX3mW9Y41nQLTWXo1CNKuck+3aqT8tz+TLOy
   nIt4sfbCbcW+hL9Ldvzy+d28CMWKxcJQGElETXlyprEBcqeQdDdUq8v09
   HUy2LV+UZURb414KUcn8rz8aSHcHt9sJk1StmOMnTZJFslEPw5dO83pWZ
   N/fFFcYn/8OksINs5O0FZyMC6MdofcSl5kBuRh8R8R8AUQR58nFF+Ez26
   W++SiUrqYZy9eFEIxxXlZou6cAGNuVlZgJ+J4nCTN9Jo7bhIRn4vvQGoJ
   Q==;
X-CSE-ConnectionGUID: mSnTqKZgTZOOPqzBA9Q00g==
X-CSE-MsgGUID: WChdBQkfQG6lHt4+9ricpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48448535"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48448535"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 12:17:05 -0800
X-CSE-ConnectionGUID: y7sA1J1WRke2lfaPeQRGrg==
X-CSE-MsgGUID: UEH+z/CKTLWcWiO/A+dQzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,138,1728975600"; 
   d="scan'208";a="86086228"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Nov 2024 12:17:05 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 8 Nov 2024 12:17:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 8 Nov 2024 12:17:04 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 8 Nov 2024 12:17:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hw2cMX522PytGbzLQNno2ViDIkV1ZQmHjSZvr5CC2rfWzvhlKYXF8NYRjSTNO90kvY+bTskdR/3qS3Voudy2UgvCGg8/K8y1wWjC0Ndbt4WfELH++ydcomNGNPSC/CkSEZjhUcO/VGb+HGwtUYyU9N/8/ztb5gp90hStDsUFyVFAzuW7wIzHWxtF4zee2e9bub5lFzVaUuGVRf6+a5e/RlCDfe/3+1E94rXoQlJwXLMFx5A8oZw1oXZqn4MRBkefvoYb9PhBb5T7AHK+tOcxkEPRNmHdXYrJx9uFU4OIBJU63K7NPIACuHvzztUs/3KzA1UU3ARBDNzaRq+TO2TPfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlsEIDFwsUUeC09V4CLeDXckPucaoS4qlxV2C9te9Kc=;
 b=m9ICA7hsLAMNMyBLi8mhYWNKrB7IP/ngxiRNcOmgW1JpOKyaTe+zQOm67KzOjgVSYx/f5v3y3q/fi11BeAssLKrHgjE1hzn/n/6nF+ulUa+k5cVbzUcs01HafvF9AreDdWwKlHKw9pqsp9JmJ4LGoaGYO+V8bN+GvF4CRr3R/7Nt0o5+ZwkoLC+P3yLVHX+d/YQoUYF9SjE3+ziX/pjg3oXa+5+iyA0NPZA5DLByaWiX8Mjx6XhcoR0RjHKNNnXzl33g+R3NeXZJwtt6AGvcb7ngvl8VmcogRftX4McgszZZM3qchEeLuJE7+m0e5rhx9/FxZVo4pXXz/RpQB0OnHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by BL3PR11MB6316.namprd11.prod.outlook.com (2603:10b6:208:3b3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Fri, 8 Nov
 2024 20:17:01 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%2]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 20:17:00 +0000
Date: Fri, 8 Nov 2024 14:16:56 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>, Navneet Singh
	<navneet.singh@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 5/6] ndctl/cxl: Add extent output to region query
Message-ID: <672e71b8ce70_1b17eb2947b@iweiny-mobl.notmuch>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-5-be057b479eeb@intel.com>
 <Zy0DQJK8opX4K16p@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zy0DQJK8opX4K16p@aschofie-mobl2.lan>
X-ClientProxiedBy: MW4PR03CA0321.namprd03.prod.outlook.com
 (2603:10b6:303:dd::26) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|BL3PR11MB6316:EE_
X-MS-Office365-Filtering-Correlation-Id: bf2da568-7507-4d94-b987-08dd00324d84
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Xkv5qUM44uTL4aNMb3n5e20/QYYIDi8U0iOy7oywflff+Psj6vurCT+T3PhC?=
 =?us-ascii?Q?h1NDCQOrNS6/J6Q000BVPr4j0HnPC2Cfj1PofY7mWjxZczo8roj6dg5RSXcj?=
 =?us-ascii?Q?ZkeiTsiS/BAn4oKISBfvwb2s+cMqDnj1Pqj+2kmRoT2qJ+e5SIp4qH1YHpgN?=
 =?us-ascii?Q?fdjbx/nSR260O1FRY8hl3Pzex1v55DRbZ2d+vBd4Y+ObyqqAxR3cqup3hMWW?=
 =?us-ascii?Q?MgHnAifC/KiF8whrew1M1lP+i7WsqvyUHZA78tgQAbQ9Ej2VsD4YT4IjV2R4?=
 =?us-ascii?Q?DbXUCSSDZqk/zmvk9uXIxirfWenNF+3yQ09mrNcsor5eu0lzXFZXzedAygwA?=
 =?us-ascii?Q?OKDNgQQDgPEt89u20gjS0sCVz/GtTp1jqINkoHqkLkd8wQqhOTP6OFLhWewf?=
 =?us-ascii?Q?JGz2+h3kCv+2XfhJG0zxmVzeU0ozYboeeZFjzmY5Z+XaWJMEz4E66nuYqfg6?=
 =?us-ascii?Q?WgThJ1WksM8/YQyKq9n9xSHyswuxB7tM/k6ZrKNto4VxR3oW7ExCQabVdjah?=
 =?us-ascii?Q?aTWzt/a53zb7lks156yxq7LtK+0zQA20pVI27oYAtDprM8y5/DqDD/MTvEj4?=
 =?us-ascii?Q?E0BcljbOyzhXR5dO1Ygl//BebQ0qN/padKXzfbYW4BnnVTXbAESTiR0cRuxd?=
 =?us-ascii?Q?dhR0OKZsQfvnIR4p9DHJnXO1UEkV0aPJBBvZ8Ar8kU4FFaTchKMLSwRZXYqd?=
 =?us-ascii?Q?7SVCVQpmtnwxV7Ha+a/MDTsrp5gZbZzj+IJZUiUTp93a9ssm+RiYJel1C32o?=
 =?us-ascii?Q?vwM/kihIL57h3vIWyB8ZSQDt8csbi06JGR7xQQVj2lXQqhKgFFHtsej/MVJ0?=
 =?us-ascii?Q?n3V/6lYTglNqpNJYKus7LfZVouQjtRnNutORRB1hiSJPSR0XZ+wlvhlBNke+?=
 =?us-ascii?Q?PYiMMzUz0nfRA6JMsuF/7b9az/PFI0k5Q29t+0LElr0FTOuAS/iOv7g6P738?=
 =?us-ascii?Q?rX7ys62ViKVl5L61stloFPoVzzzBLD1vRa2HduvqJUSAzdoOTjp6cXL/VclQ?=
 =?us-ascii?Q?lUOu5OeCcP+vewGaqzbsVoX+z31qrD9I/FPFRclkChyVPdU7vtWl+el8yzBD?=
 =?us-ascii?Q?iPblovhtKKyATFdJ7OQdaTl06jAcMhbOZ/unaRf3P97Ka+YakfjBnph37fNk?=
 =?us-ascii?Q?txkZucDSqsN50XG6bt4HObIXKgi9rvcCs/vTizskzGisy4fyAZ41Op9D3t3w?=
 =?us-ascii?Q?RT2NH+ftVSEUgcxkBMvp5TykzyI+ovqdJWJ1jIzfNeg6mRkdtUmL4sl1J90b?=
 =?us-ascii?Q?S1gjwzeieoM5G5/i9TsVL2Q1aOafqZHKV6QTBwRIWsAec1IGB9Y5fuSWhuku?=
 =?us-ascii?Q?Omk5Z76OJW/TbiBOJ2VGROQg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cryQfGBtw7f57viazR2FJdOQxZmmAmdR/NOL0bPdLAUn9W2YQWoE/R4zjMPY?=
 =?us-ascii?Q?dDUc0HlXO/I7eGV8XH6HNTjfXKECRyrAdT7Syjb4JAsE1jmwqZBskAKAiGw8?=
 =?us-ascii?Q?umpOCEDNQAiGGpJPercfTDkMGQlfFL05DnH4mAQLdCfyiTRPtnlOi7KtK5Uz?=
 =?us-ascii?Q?T+ZA2l8x+bJouoU3RwmYFKp52SxNReqEWNDiRTmCGkgxT/GVxKKXBzhgNKHL?=
 =?us-ascii?Q?QNQ+zJNlhT2SB+TomeXeOrOc4m3Xyi7pK2tmHVKbNTG0rB0f+2TCNHWmv+ub?=
 =?us-ascii?Q?oY/F6nkx0Q3BiPnTIixRYN49ny3YNlKXiJH3mS4amH96E+4piWpxq4Tq8yUX?=
 =?us-ascii?Q?LKOj/GNUOYnFuI7lzjUysdULaWCF30mcboDJAbmDAUE4cvrHNppk2hM+E/A6?=
 =?us-ascii?Q?gfivUhOFBx5FWG34nspsSjKNcBEZOIIjpD7uy1ELJsNpuPdf57Gty3ae8tjV?=
 =?us-ascii?Q?kVgCTennty4RapchBe77/94VPxMtcPBQxcag2yATC/ZON6Nk9pIwiSePAjav?=
 =?us-ascii?Q?CMV5oNJhH50Aj6iOuMMi2ucRCFhCex9vSsOlnrQ3+R4UgpQf9TpbZ+naE9gd?=
 =?us-ascii?Q?qGzwENtD5pLbdR7VUrp8HArRnD5vdmRwx1lBFYedNig+36UsqHzs4qRzj2au?=
 =?us-ascii?Q?4683WQItrWiSbCNdlj3hp6IakOFbgUCL+jYsUAlThnQIRhENAdMH6MiX5NBJ?=
 =?us-ascii?Q?uXbtJ868p+M+NQPh2z73O3oc8TtQBTMMIDaH+vAm4HCs82rXza4yEOerjlJk?=
 =?us-ascii?Q?IJY5CmbXRfIfM8w28qM/4B1/HEIi/ado65MePXHqVq9bjSbh3jvRVHZyT8a4?=
 =?us-ascii?Q?BB1ogS1/DjuzoBFr+yTPWDKdD5KmZypMQdYo94F8O7oc05JZXo3UIP0hY50m?=
 =?us-ascii?Q?nb0ZWHpOA2+LDrfbPzehfwVHjj0Vt3tu9exBh1NKmHvGX2V44Uf9Jlvgw5Aj?=
 =?us-ascii?Q?4F4vyX/PL1ZoNvygiHSHw4QuQyGvoISygPOrXZbyRMH2NO8IAK8hs1bclA25?=
 =?us-ascii?Q?dj550tMj0TMOcaSqNWdAwSbgIw5U5JzxLs0qWVABseQaxhq6/lS6PU+IOlSZ?=
 =?us-ascii?Q?PylRzMX0Gi9O+Jct8zeUTblPgVQ5O2J33QHGpwskULUox290zkVz4xFYbgls?=
 =?us-ascii?Q?cPt63U5mjxxWz8PIqtkmbT/YB+nI7yQhRiTkJHWtwbSvqlkk6uicdyvntNDm?=
 =?us-ascii?Q?3KZrkPnrwZtN7ZPubEo1ycXHKj8bwkpX9JrQQa1SPZAZlve3qEkiXC0A7x+S?=
 =?us-ascii?Q?l3KZPdpnw5wh0iARo2rZlMw/fq3GBX/Svevu9fuQoagFaL1hkZkhEKbT9yrd?=
 =?us-ascii?Q?bgNrj8P+Mc2Hqd33umfkILdIRAtUHeJj948vuktmbwc7owdZrHawJEmdZ5F3?=
 =?us-ascii?Q?7ljKZ6BNpFXhikRYLtWsIDNaGMlArwFnDkNllADIBE+FUv7ChOPAXl6fLf5/?=
 =?us-ascii?Q?dA3jY95U3kI2ABHxX7R5EvWzN1iPuJmCdzTWRcr0z6jqkuXtj3CLf2cH5GOh?=
 =?us-ascii?Q?wPz+ewjdZ8jF8Xq/R/DD7r+Tz2hrIsBUJfxD73OG7TrZjFI+zAo5LSZjE6F5?=
 =?us-ascii?Q?8lNotruy6bMJMyqKWhv6dw/pXOyMGhl70q68UCpb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf2da568-7507-4d94-b987-08dd00324d84
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 20:17:00.7690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/Su8ZaFkzPg3A8wyJSUAuubMQUc16E0FHKxvZ/+6hFIYzF5cl0vwFW7GdFhBmk3ah9v5Db8ILLPINnOW/Anig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6316
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Mon, Nov 04, 2024 at 08:10:49PM -0600, Ira Weiny wrote:
> > DCD regions have 0 or more extents.  The ability to list those and their
> > properties is useful to end users.
> > 
> 
> Should we describe those new useful properties in the man page...see
> below...
> 
> > Add extent output to region queries.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > ---
> >  Documentation/cxl/cxl-list.txt |   4 ++
> >  cxl/filter.h                   |   3 +
> >  cxl/json.c                     |  47 ++++++++++++++
> >  cxl/json.h                     |   3 +
> >  cxl/lib/libcxl.c               | 138 +++++++++++++++++++++++++++++++++++++++++
> >  cxl/lib/libcxl.sym             |   5 ++
> >  cxl/lib/private.h              |  11 ++++
> >  cxl/libcxl.h                   |  11 ++++
> >  cxl/list.c                     |   3 +
> >  util/json.h                    |   1 +
> >  10 files changed, 226 insertions(+)
> > 
> > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > index 9a9911e7dd9bba561c6202784017db1bb4b9f4bd..71fd313cfec2509c79f8ad1e0f64857d0d804c13 100644
> > --- a/Documentation/cxl/cxl-list.txt
> > +++ b/Documentation/cxl/cxl-list.txt
> > @@ -411,6 +411,10 @@ OPTIONS
> >  }
> >  ----
> >  
> > +-N::
> > +--extents::
> > +	Extend Dynamic Capacity region listings extent information.
> > +
> 
> a sample perhaps?  or some verbage on  what to expect.

Good idea I've added an example.

> 
> 
> snip
> 
> >  
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
> 
> Rather than emit the above which makes me assume success if
> no err message follows, how about emitting the success debug
> msg when all is done below.

Fair enough.


[snip]

> > +
> > +	while ((de = readdir(dir)) != NULL) {
> > +		struct cxl_region_extent *extent;

[snip]

> > +
> > +		list_node_init(&extent->list);
> > +		list_add(&region->extents, &extent->list);
> > +	}
> 
> 	Here - dbg the success message

Actually after moving the simple message here I feel it is not really
helping much.  I think it best to report via debug each extent as it is
added.  So I've changed the above to:

	while (...) {
	...
		dbg(ctx, "%s added extent%d.%d\n", devname, region_id, id);
	}

This gives more information on what might be going wrong if debug is
required.

Ira

[snip]
