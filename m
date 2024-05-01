Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7BEF9EB
	for <nvdimm@lists.linux.dev>; Wed,  1 May 2024 20:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714595330; cv=fail; b=FDTN45lscuUFoIvs3ADB2NRy2uYmvnEkKCntQC0rYdYASn2fQjNnNfqtgu2CVB2LWXxf14LTc8h3wdJwWlKXpZOfBRF7zYwbPi0bTGR4TS12PDJ3HFH0UN7zGUhCg598Kjiz9E5j98d923zQMqqxT9qz/mYmIOm5jFNP9SfTQFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714595330; c=relaxed/simple;
	bh=U8RTWRu7eqQVn4aRxHWhJcPX3OYzmamQ1wwJG9l8ivk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eCpA7TMnhmR77UEs1A662/vInp707B9gInP6v3Cainl4orpvA/ovIdRu1vHxW211BB8zIDVu/8gUbAPMemesnxi7irBG5CmG03PL94Nmi4UIJKiNCIIFKhXlowVN41iItJNPUe1MaJo54VkYyOWU0JBDX9H989bmrzm3okRu6GQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TPz8qA7H; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TPz8qA7H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714595330; x=1746131330;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U8RTWRu7eqQVn4aRxHWhJcPX3OYzmamQ1wwJG9l8ivk=;
  b=TPz8qA7Hvr7fWftmXUVM7dRUQ2SEMy7KhW4A3H9L6aqfnuKCGoPQRRNp
   CwJ7NjjrQZysxXb+ZRbTpSEqpLScurdJW0anrMB4GmCw2lzusrYGdQr95
   E7vcG3OXH9b7RPltbs5N0o/neA1K9K/+aU620bn/KxeFDMiBvUn54UVaW
   lYmZTi6ksv2I0APkIdbj/seiRHJjdIfgOGWVjzy2vC0TiLdoIKPg3643/
   OHdGIb2zE77hBnqJVCJoj0PTWBP0GWk985ul8btzXbzzc3V3wcAwsY2bF
   8e3PnoNiO+aY0qYWcAJy4wwoOR/Uj4ak4NAJwOD7v5A9eX21sk9c8mWre
   A==;
X-CSE-ConnectionGUID: vdoN+JC7TRaUvVVHcYTBBw==
X-CSE-MsgGUID: U3o/MPkEQaeq9Cf5YB6xnA==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="21748001"
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="21748001"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 13:28:49 -0700
X-CSE-ConnectionGUID: 8m93OSB3QwSMFPJQrXLgqw==
X-CSE-MsgGUID: sN8VXzH5TiOKqjj27scnKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="31706730"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 May 2024 13:28:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 1 May 2024 13:28:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 1 May 2024 13:28:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 1 May 2024 13:28:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKkoe/6BxH7QHSlVWyrX9tMvOFWs18+qR/Or3w18jIIiAfsfkujYBmJyaFPCmhixqs0orDFLqQLQOxAYRBncWTKnkR4byJA7rnqL9Y1MTh3w4RXb7McYdbWkTC6alpSTQO994nDbXeprdC8Nz5vGKqx1o0SvY6OURDalO04Jn2gKPHoB6me7N3OqfdLqIGIOx0WJRmvze79bSTEIQ95Xg1AEItwL0VfTC22ozXR8AuCWJkfisMOUvm6wR79rnNt07Q21XjVH0vtoNkG6+hnld/1+Yu1g7fxhlvnhStHe8FJ5eRbFBB2DNKB/+PhvFl+v3UnMMeAA+TaYtc1JLHvACA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXSnaXS4gpvONlZh3/GI1DS5omK5ONMDcLysPQci000=;
 b=PprKYFFuPBOf0gseDF6MWx6MIXfYYl3A6cGWve/S6oZI4PZ/BltS+YMVavD+IVNYOSP7vBXV+AIEfcMJxMN6x6Z3Xs/EKcUpQm5/dmiK3aE7K0ihCMIZqh3BbtkSx1hPPNIL2Q3fm1QZMMoOWBAoX6kUWR9o4YBryM0dHE2IvhYQ1dySEMtR13NCmHdiL9Nc+z+qT0xJ0qmMONQ7t/WF3/uzNT74GW1ivzF+4BLrfSSUYaPc38TEid5Y3Won6HgtLRUW7aKJAMDl6SWyKj+jnz8jEY9XRHI+3H57VfQ6d1OUTDz6VcLfHX4TF2PKQ4Ls5xD21299OdKWLMnvCJ8Jxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CYXPR11MB8664.namprd11.prod.outlook.com (2603:10b6:930:e6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 20:28:45 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.7519.031; Wed, 1 May 2024
 20:28:45 +0000
Date: Wed, 1 May 2024 13:28:43 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH ndctl] Build: Fix deprecated str.format() usage
Message-ID: <6632a5fb47af1_1384629463@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <20240501-vv-build-fix-v1-1-792eecb2183b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240501-vv-build-fix-v1-1-792eecb2183b@intel.com>
X-ClientProxiedBy: MW4PR04CA0163.namprd04.prod.outlook.com
 (2603:10b6:303:85::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CYXPR11MB8664:EE_
X-MS-Office365-Filtering-Correlation-Id: 432b7d63-a7c4-4298-5c78-08dc6a1d4ce3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NWfnAeG2GuLYfalKfK1gM22uusJpFXvpEousQgufaFwRLjsFL0J/q3sLONWA?=
 =?us-ascii?Q?KTLKIpsDKQRVnLIdXAbMmbVysGDF4CSPRvICwqqez6v40T22/IrVujNyqKLB?=
 =?us-ascii?Q?IgzvQRoaR0FzUBmizxZQKLCXkXNjb9pk0pjJTOGHquZtRSf3lj1UadnxoNor?=
 =?us-ascii?Q?nBfuAgQDc5e4TmUKhS30DXf7Hz9vYVcaQyAHBH7cMHFd04p70wb+vxpMqRrS?=
 =?us-ascii?Q?dduPWn317VPYz1VVE1OVUJ4cmRMSxEmBpXGzv67H33uOjrmvjBkdMp6NQIe2?=
 =?us-ascii?Q?JouRNDX6ShKCNbeavqbPw24JVX7gLxjUuqQRUk7ZJnxvWwxY7M01/+HqY4vU?=
 =?us-ascii?Q?ui14YhYYOfxammw/kT63JWul8ADunbXOy6QvuIP+x8s7gzRdoWXFXW29H1W3?=
 =?us-ascii?Q?uMX3SyehWwZz+9R524+oYF8KRLh+3eL6ny4HaBEq7kTWF4lgh3uPXPHak3zb?=
 =?us-ascii?Q?4Wu6ACtdtsH1YzYSLnyFrjHOVuwoKtQm+Hk3IynuhgIj/3SZ/5AcAJ5bmjYy?=
 =?us-ascii?Q?Cb9bE9OxATisow24juo+SM9pz75iO9pV/evxlewSLxOcBHNeGYPrFt52Q2Yh?=
 =?us-ascii?Q?qTBu16wmVJzhtufwMAp14Qe/cf3k0qFzR8Vo7Lwr5u5OWNX5rnAabIQQOGDW?=
 =?us-ascii?Q?Gm0sINZLqagdela5OlNZRtfa/28RSZgfMA2g1WewHDLATIPlUH2fee0lPUgQ?=
 =?us-ascii?Q?HLftFFQlT3nve74xX/2sdSGAfYieB1pD+pJ43xCFimGmQxUuB/AW4KGXjcow?=
 =?us-ascii?Q?eHSsSHmb80ID1lYhh2/8YNzIOJDgkc+HQClWmjuOGrlqdBgO8D/8PP1DisXP?=
 =?us-ascii?Q?A0Svvol3eOXxSDnid9CC8aSJ7dkOVJaCFSlL0xAY27lBDnoWhd9qp4+HzvDb?=
 =?us-ascii?Q?0TB7V03Et0Cxusw43oc8PJNjDq9NqyYJEV2oSbtCFLffEDaa8RKWC3hkhKv4?=
 =?us-ascii?Q?uBQuqOd8o3IE9k21es5PqtRVSPLgagF1ODMq6oWTXWNpiFE9VJ7I4MjqB9nf?=
 =?us-ascii?Q?IfvlxFor2Rv/BhLLl13PD1HvH9j1B9jlPusRDzrI6elHbyD7U3yJUnfBCtRJ?=
 =?us-ascii?Q?dhLfzcrPFZ9slOSOETfdzaNjjT5KWpuGl+hZx0way1RAlSOGFT1AcvYVqBvj?=
 =?us-ascii?Q?HlrOxeu5L6TJgP/MDn4mC0XzuYZBg9aC4boiOjwXERtNJUvycCpOa/kmpeh/?=
 =?us-ascii?Q?uwZZclqTU4gc03LP5OlKGrKa0vpt5ZnbIn4yXELPUe7WHA8Sj1XJp4bzqibI?=
 =?us-ascii?Q?3nzTP5zHgkYubcNs1AGa+LkjYUGSPPmCZa0vW8R9Zg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0casw5B4vYX6731K0N3WzmS8Kfl6pl0+TIaoJmh7bbHFQGfDCKOpuqNvwhOI?=
 =?us-ascii?Q?QlR7A9NExZXC0xMDbm8GtAXvCTsLienEce7bU3ubFpBskswS7NJQ14CBIug8?=
 =?us-ascii?Q?c8J4WAV3dVIv6yjmVN+7F7ss42ZtfuUVYsNsbgiwlJQIlZ84f6G2rkk+17mA?=
 =?us-ascii?Q?Z136kPl2/fVk/6Hdsr3HHDvr9NnX7XYZBM36X065GEoPTb4rb15D8uBzAy5W?=
 =?us-ascii?Q?boS3lQzfAy719AuwLAtF6qhLOjzwRw8Szd3TnOJQ0AnR79keqPGv4FV25AEY?=
 =?us-ascii?Q?jaeDXU55Q8w2K2TCo8YvfIulGsYSoQ7LF0lTwmi9poS+3LEMpjluAsUf3kwi?=
 =?us-ascii?Q?QLSXB/orDugxSQZ38tZs512D2iELsmAXbrx2ZuWiLMQq1V4E8ZUQyC0T0LJW?=
 =?us-ascii?Q?HT+9knSDVdI1HGvx8WN7GLcsXgZaMNZHT2/aIBrRg6++t6/xR2hXwxStXLif?=
 =?us-ascii?Q?hdLhuxrvCgvCmW1hK8xfHSYE9lqLjMl0zDn6cMJa2J6daxQHCcjdGDwyrJWz?=
 =?us-ascii?Q?3I0hyh6H/K0m0epI/E3q/e1svqVa0kpxYDY90yqBcLNOxVoSCcaLk4H+CFyy?=
 =?us-ascii?Q?icV9sh68OaR0im0sRNw4Wo/vyK1MyXQ2gEjtzr228T2F9FGjsmIYBflbM0LZ?=
 =?us-ascii?Q?GLOYM5X7qLZy+4ZPhxY5gRl66NzSiqZ7sN4gmM2lN2emlIzVN9UT3ovBkQ2E?=
 =?us-ascii?Q?4l/Rn3CtiLDY+7gA2rESEHQJMK4VEmMj7BXPD9jgKPiDyUYUevU7jFbRE6ar?=
 =?us-ascii?Q?9dxzcqFGPu0cwyMXgEcvmVLExmzxsD9Z5XxYR8qTswYXR5kkHLa7u/jywYDN?=
 =?us-ascii?Q?8KqmSnA7ilAEADMtIlcgocu1403/yM/4Owa0URSdrbFMsDuLabLvPJrFSnkK?=
 =?us-ascii?Q?nZzpMxePydRhs0UGmjBVcTp9awlLoU2AW7Mp1TZSQ9/R4gKa5e4pplAf7Lrp?=
 =?us-ascii?Q?r2Sr3A4Iay7F+vv+G4acj6HDUtnS7Zrnc6EQxDdOKEkdr+qM8so4lakI4neM?=
 =?us-ascii?Q?kGotX8rssnt4/5JNF1uyrPPUphK7hqxtAOfZlgJ6VGsm6UknhiW3W3eaK4vs?=
 =?us-ascii?Q?37EasxCzblmJkYJYoVunTpYPPbzQ81ofenNFgl5a5XxN9yrjkt4Kr8mwPPea?=
 =?us-ascii?Q?gikwbUicQR/G+lVg6C6Kzr0TfR9MBObaxygxo+6DHS9pFoMG5wwl5cc/k2vw?=
 =?us-ascii?Q?3XkH8CJV3q//IP0PluOT7Q3RpTa+DTnT00Jo0t+YknbURYIrv8b6AWiA7ATx?=
 =?us-ascii?Q?ia16xgAwm7I3j+i9aYpsSsCGTTVH+0/7s7SXkyBIZusOU81x/+OoNDI6zyRl?=
 =?us-ascii?Q?0f5JhYpBN0ajwX+phoA+MZARyyY1DXWHQxukbffjV6MOQ4BuUe8WAIazoXpN?=
 =?us-ascii?Q?YoQDaU+r0rX1UUn2O86zDZGEKnIipcc6az1y+RNmdW+IKFDXVwYGq9zKaYTQ?=
 =?us-ascii?Q?htAXhYhYY3GPuTaUoSKaIl8uRTVxyPkJ+9mK7bB4Qu9RKa7HN6DeEJA5ziEM?=
 =?us-ascii?Q?/RyWkfd0L4XZqo3YtarqmaSg89m4tVxtESQ6qkaAqqsl5AuebdYHvzyKJFoR?=
 =?us-ascii?Q?zGjlo8jwE/z1Pks3Hq4+Q0+x2zdWHjr549537J4w6y6CLVd48/EZiXodU8ug?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 432b7d63-a7c4-4298-5c78-08dc6a1d4ce3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 20:28:45.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGsZeiHHAco0w4HjWulkP5NXx9nPnj+R7WYmvWtbCNAMkarF8FxB/x3e+w2s8a6gFICngSVlmg12h88PAm9Wyd22FSoOau02VsEXjuwyJ/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8664
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> New versions of Meson throw a warning around ndctl's use of
> 'str.format':
> 
>   WARNING: Broken features used:
>    * 1.3.0: {'str.format: Value other than strings, integers, bools, options, dictionaries and lists thereof.'}
> 
> Fix this by explicit string concatenation for building paths for the
> version script, whence the warnings originated.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Thanks for adding a changelog and sending this out!
