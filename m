Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E43F23F26B
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 21:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750973870; cv=fail; b=iDMIo6E2CnF78d1qXLAH65rWgHwU/RgM4aj4RPUDW8XwPgawSKB/Tdp5la1dMjvArIFCKz1FDNpU6UlOM7F9t6HnLgbKDWQXFAVoLPVg472En/WwopquVZasINJHOSe8RpxRrfeFLsjy0ATssMPu+Bw4HNanyWLy8ccXHalxMX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750973870; c=relaxed/simple;
	bh=S1zHWWRbP0aWxnbjFs2qIge66nxrqr4KkYI9D+R2688=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QQdAHNkrjM9/oadINObQSRi01w7/MshJ/lWu+pYrqCcoMEZIULUDGpVPD09p9sTOhtgOwZDsvWNbvzBe4TD2MbZonHMWhoB8Iwovn4r5SwRikU6+s/Kb80pD+DlBn9wsUa5rZVYeHUwtGLkx6g0u/1VWxuO1C3ditWlgefiQV6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ao18FKiI; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ao18FKiI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750973869; x=1782509869;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=S1zHWWRbP0aWxnbjFs2qIge66nxrqr4KkYI9D+R2688=;
  b=Ao18FKiIbdcvUvCrKJvaSVLPzaYhtmo53ZeUcltGYjiYSDHc25lAiYIF
   juTM9CneL/nCQrHVL5/dxF/sV4N03/dPD20C4bTDQBPdIGgbdWeIQaQ7r
   4SGLSu61tpxhG3ASk/aGMqAYXarURFRnVpuAJCN/GkXH88lvgmKH5orjv
   UZv/eq/iepsq3h4pOy1yM25Fo4/1e3Hlmrh45Do7W72eACz2saoTaTELB
   y9kQM4XS0My9rpUpgxEmSLan6ql6P1u2lmmJJuV7wugUTIhIhHnfJh39D
   MSjiHHaIhEz8jWbFUdSdKxegWft6qoGVyjdvfTLnOgS+Jt5OyA0qE70H3
   g==;
X-CSE-ConnectionGUID: 8Gncf34DSiWXkf650mvuug==
X-CSE-MsgGUID: HbXSuc4GRnC6UJGPu6XWDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="52515390"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="52515390"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 14:37:48 -0700
X-CSE-ConnectionGUID: Mo823fx6S9y+8tY3ghPtzQ==
X-CSE-MsgGUID: v+3rg0HtTVyqfM2VshOJdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="189824614"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 14:37:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 14:37:47 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 14:37:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.72)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 14:37:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JdJI13iuj8qDOmduXAo+qZf/Pg+CYBRklhhQuiL3iIT4MbCHoRYByse3+upaNhEi/UFTT4wVrPsYK47nx178ZXZjRrZY9fvxcZWvNyjHpkiHKVr3vp7SNNbbepQdG5m7IdqH1iskC1Prbq6qvQrHKNktx441TswmLzvPyWn3xcgYfzYY0zECSLawZUMDq8EfZOB8A/V/dfrJ7DioOz3prC6HxBPoo8Acja2CpLAsN7u836ll5l7FtEB1X0Yvn2KkvBx5SafT/kk7plzE/F6wrPi542epski9XeV2f/+Hc6/6em6drA6BQthvuivfu1GaIsLyz2lSlo6/774iEnTwKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qkm/TJXfDQaGKb095sdqlU/xvPAa54V+pwTQbVzsJw=;
 b=kE7uXuxJ+PWVL+EYYUuyTq+LUFV0OQELLYJUwMljd4Riod1lLez5oXbCAC/yhhZFbiAsaDWWnux/M5vIIgik98PIbrKU8gp9G9eCsurSD8JfFH3p3l+cNhIKnGjTgOojZ2SLg6eOc4GdZy9h6pTf6d8D51d90kJvTlLFVK3bPuYuqottqTfrvxL2R2IU8MlV7aNws/W7uXT65rB1lMp1+Dg9n7palA0EmaeO6JzSQ4kqPFlM0QC+lo9xPrgFMhwtndrzM5Zbe8+mc1mG7sMDCr+Af0bWgdVSqzxokqvj0PIR3zoq8WrH5FMx5OmmfF0FmdrpQetNydPOHAEqSEK+fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CO1PR11MB4819.namprd11.prod.outlook.com
 (2603:10b6:303:91::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Thu, 26 Jun
 2025 21:37:45 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%4]) with mapi id 15.20.8835.018; Thu, 26 Jun 2025
 21:37:45 +0000
Date: Thu, 26 Jun 2025 16:39:07 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
Subject: Re: [PATCH v1 1/1] libnvdimm: Don't use "proxy" headers
Message-ID: <685dbdfb80651_2ce8302947e@iweiny-mobl.notmuch>
References: <20250626153523.323447-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250626153523.323447-1-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: MW4PR04CA0259.namprd04.prod.outlook.com
 (2603:10b6:303:88::24) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CO1PR11MB4819:EE_
X-MS-Office365-Filtering-Correlation-Id: 002ef800-f1ad-409b-fd20-08ddb4f9b009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?521Hzqe7ler91NhRUsYjH5G7Ky2x6+hB33MHPYnwh6qEQ8gHLBkZ/uQ370P8?=
 =?us-ascii?Q?WPSdwn3dsxVsThvEAMswvYr8NFST0d7289uNVY4reSiWSD4iFAfF9L0yM5K+?=
 =?us-ascii?Q?FmHoFE+0JkhHuX1M0LVROGSkp7+MhTkLEyz1xrxVqqi16Ah6//S6Cr8m7NWt?=
 =?us-ascii?Q?T/kIm7N7QBSb5dZoLMUMlqd7A2XPOVGljVhxA04gNUDK5ZUtK7o1sOAEprHp?=
 =?us-ascii?Q?VeAomRLI5SDbUDOESXoXDGgwE7NRneHt5knLzkhA4eRhbAN9QZRxWYF8yXvF?=
 =?us-ascii?Q?a4/S7aYdjstWQcN6QmZyy447iTBAUYeX1jLoURlpIsm1hnEgtOwVUB/wZpOX?=
 =?us-ascii?Q?K1LgvO4BYSe2pMLTFolsKP/7TJnRVtuRFZDY/NxEZdxaKS+EqR3T8sayLEMT?=
 =?us-ascii?Q?3UD4bfsN7P3nmMw5BADUKf8j0hLu0ION+GOuJC5CEyfkVxmWcMXMwU/cgI96?=
 =?us-ascii?Q?ivDeBY6bMENurtz5lxfKqmwLj1z71czReJxzZgLt1F+LWBSGrLVjkvNFnlh9?=
 =?us-ascii?Q?aS2EnlEgX2NMpXG3OVdQgAeBYKBNc/6eMqylTg/6s2fHBH61jC8+QG2zXqpX?=
 =?us-ascii?Q?WO5bDN9a8Jomy07czLDGSmFp5eUwJMw+Ad3iI6HGsKoB+AlHKUS/zUpjPW1V?=
 =?us-ascii?Q?3NN87RpK0MVVix52RwVOaXYDN7Ugotu3qtK7Z4FdME3ZRzmPwqn+1+0+gHQu?=
 =?us-ascii?Q?Zh9u9Pb3zRFiPpVW0D3ip8gTZLrpZ5uaIpDaMFRm8sRCV67mmBT6OCYLLQ2z?=
 =?us-ascii?Q?GvJjvTHBqzhUNjIp+0pwmZxbCcjJDGH+EptZNWwEBflP1rp40c1g5vyC7hH6?=
 =?us-ascii?Q?HZO3DStXeoGd6GtJ23FZ/5gMF6ur0X5gE+aslMxS9UP9safeEycC2IKcb4XU?=
 =?us-ascii?Q?49s2IO8vXd59Ibu5N7uXKYd1hvrji+C9edKrxw63buhOsEzHCeWXTr59xqkj?=
 =?us-ascii?Q?l/HxJHLaCQ2BhuQdMjgSFyKRaWy6Po80QVj8Kt9rCSoMURWzn1yCkM9xx+hZ?=
 =?us-ascii?Q?VM2029KenSyLeIQSMi8FSYkqskBwntZCElU/epfAzX/pJ8b0DAelNokCEgjD?=
 =?us-ascii?Q?atGeBFa0WVnoL7hW8/RCsCmGKkraynvMRasQ0ZJAsHv2XM2WPnUeoImwW5c2?=
 =?us-ascii?Q?7vyiYqRptdG4/rwbKUywWyy3Z2B6PIhsP6D258K8H14FjF9j/hqjhxx7KcXi?=
 =?us-ascii?Q?LIxJTsLEltYLcxZqpr8YWeJHZP06Ry022bGgg1JCmDo2DSfXiZvR8uIwtGfT?=
 =?us-ascii?Q?UgT5EiFMkYYKrVuVaXEXbkYWod+UNJsUr4r/Wl+e5xiR+9704axr0P0Rq6LV?=
 =?us-ascii?Q?YDOqVejLDAvYUtMH2sfJFuTqI2VeZelSapcIuPrKP/a6YMsS6KulrdKx7tyq?=
 =?us-ascii?Q?he7UzzOboHuyoi/RXt+NrvkMAqolwGj8ijavCA/t689ryhYQWY9QC646jY2f?=
 =?us-ascii?Q?eZmhjUJMtR8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5j9xFky8GgEUf45VhNa2GR1+wJsaxLoetT8n0gDJG+3Ww7RW/XgnMIOA1lOn?=
 =?us-ascii?Q?l5ksXF7BFperZxZFORp+jGPyuUoUniLAmxsFqCJ+n4YhmEsVAWsHgFVZy7bt?=
 =?us-ascii?Q?f9o49ditLaj99vXWe5msM/CKYUknwx0ED7vMksX9I1QrrOMArdAxhmNSEvo0?=
 =?us-ascii?Q?xK9SEDvvzCUUIJBnZktc5tUVpwuRnvSzWkjBHatbyUmx6I7ysZ1ijNyCTQ7Q?=
 =?us-ascii?Q?R8jYQ2XFMrm8ubVnvLQSAUTGE7TjtNQxLR4SSFZ9ucXrS9Ua0jptpFQS8IsH?=
 =?us-ascii?Q?EdLa6CHy2sEqKMM2eE5IQ4n/e/3olQDOl+IuxkGx9CmNUDvU5WPMcEJ3ZTi/?=
 =?us-ascii?Q?cXdat+2FXX/qtEX2Dnn0fXDy/JFDBx8WXBHGhwyfc6nBC4k0Y4+XzrqW6EQu?=
 =?us-ascii?Q?F4RMGECodz60+6Q0QMYvPYbmNWMxl93BueUuFAtx5siqR5L4/hkNYaRVUa4u?=
 =?us-ascii?Q?6hjWbhY3Be5Hg58JRADmkPueFv6uZWDyq69PzEyJFHuyNRDl3ySutyd4AcFs?=
 =?us-ascii?Q?9fSqs4oUiqEpq1EwLJeTxcIO0B+fQz6lzAX7Cad6iEBCi/FVXFqFopqqiGnS?=
 =?us-ascii?Q?mPO1iMm4cKaRKz0YIiHhnXa6XD/oxN4B9avBXP1L4DfnxMA2d3vJJv7JKzpV?=
 =?us-ascii?Q?JWNkGL2hKVtAU8vP2qBhDtyktVnZASnecAijt1UqhYpjlD6JE5srYsvg+0Jq?=
 =?us-ascii?Q?J38VBxePeoSP0690RnWZoxVwZPasmYqJdq7JKuma/WwfEtwOqHpqiz6JPQj6?=
 =?us-ascii?Q?Pqs02UR3KH+rbe4SpK7ZzlJoyWszlIcIpNAF66ZTD02GWv0QY/Hlq6eHvTjh?=
 =?us-ascii?Q?7NIfq6GtzK/IpDCfXQpJ80eP4T5/LU9l0iCJYnb+lJ/X/xpVPz4jPe5yqPTV?=
 =?us-ascii?Q?JS5qFAGw/GR7oRGYziOBSbNzm7/VoIkLYA7gFRj13aznEKeTHH/PlA8KyGOB?=
 =?us-ascii?Q?8X4l28V0RnE6cjaWd37YSaT7vyIZhukFAaZN6YFdHuDVVw/HfSGjG2vz+PnP?=
 =?us-ascii?Q?oxiht+z8Yl4yf8F4k6nChjAbyFSrhRCyy9KN0krzC2q20e/Zk8bh3nlCjhpN?=
 =?us-ascii?Q?gTBwrMIYYBmseRq3yXwgSPsGpSiZDMosUQGM+up9cgbKbWhc3M9ghKShzcir?=
 =?us-ascii?Q?OS39kYpc+dG0KTVGAgji0zoWqha41vmIwveDH6sPs/s/7JtdV/U23zos2a9V?=
 =?us-ascii?Q?jZ0/GABtV5Bepvo0K72xcYT7hvXcLnQN6Ob9YLsdAf+rgIBie26fOKc4op1s?=
 =?us-ascii?Q?eLJVCwoaVqzdwt5DDQ5qCwkJsmzP1v6OU+Fn42ZVsDblkxVz7tmH+WF2BWy5?=
 =?us-ascii?Q?MWgqhe5mS9ezvSkld5wxqsG0GVLikzfHCC4z0F32U7CsXlXY5IMBm3QmZtzk?=
 =?us-ascii?Q?6EyHZuBrqoZUNqVeDpS9zpCuZrox6AwMssJ2SqOWtLflU5nSaCPmrQxXgw8q?=
 =?us-ascii?Q?mj1ujZ+UzKv3jRINVshiEldPaGv5ciYPWl0Q+uWDItFw+cOL+zcAWCGF+OjM?=
 =?us-ascii?Q?a4Y3zg+mpZnSj/nTVehRO+msidKrL2TqL7syy7ztEcgnnJsEx78uKT1CW1fL?=
 =?us-ascii?Q?eF6Qof1oKL5BNkxYAYw9rR0b3gzSG6YUsjiBIxo6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 002ef800-f1ad-409b-fd20-08ddb4f9b009
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 21:37:45.1333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uTysn5Xgz3DUcH8UFCLswP6taV52gjPbFknRBK57ujTjMh9Rqa22GoaC1GwVgO8AdnT+9wPv44DzALKSu0skbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4819
X-OriginatorOrg: intel.com

Andy Shevchenko wrote:
> Update header inclusions to follow IWYU (Include What You Use)
> principle.
> 
> Note that kernel.h is discouraged to be included as it's written
> at the top of that file.
> 
> While doing that, sort headers alphabetically.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  include/linux/libnvdimm.h | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index e772aae71843..dce8787fba53 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -6,12 +6,12 @@
>   */
>  #ifndef __LIBNVDIMM_H__
>  #define __LIBNVDIMM_H__
> -#include <linux/kernel.h>
> +
> +#include <linux/ioport.h>

If we are going in this direction why include ioport vs forward declaring
struct resource?

>  #include <linux/sizes.h>
> +#include <linux/spinlock.h>
>  #include <linux/types.h>
>  #include <linux/uuid.h>
> -#include <linux/spinlock.h>
> -#include <linux/bio.h>

I'm leaning toward including bio, module, and sysfs rather than do the
forward declarations.

Are forward declarations preferred these days?

Ira

>  
>  struct badrange_entry {
>  	u64 start;
> @@ -80,7 +80,9 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
>  		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
>  		unsigned int buf_len, int *cmd_rc);
>  
> +struct attribute_group;
>  struct device_node;
> +struct module;
>  struct nvdimm_bus_descriptor {
>  	const struct attribute_group **attr_groups;
>  	unsigned long cmd_mask;
> @@ -121,6 +123,7 @@ struct nd_mapping_desc {
>  	int position;
>  };
>  
> +struct bio;
>  struct nd_region;
>  struct nd_region_desc {
>  	struct resource *res;
> @@ -147,8 +150,6 @@ static inline void __iomem *devm_nvdimm_ioremap(struct device *dev,
>  	return (void __iomem *) devm_nvdimm_memremap(dev, offset, size, 0);
>  }
>  
> -struct nvdimm_bus;
> -
>  /*
>   * Note that separate bits for locked + unlocked are defined so that
>   * 'flags == 0' corresponds to an error / not-supported state.
> @@ -238,6 +239,8 @@ struct nvdimm_fw_ops {
>  	int (*arm)(struct nvdimm *nvdimm, enum nvdimm_fwa_trigger arg);
>  };
>  
> +struct nvdimm_bus;
> +
>  void badrange_init(struct badrange *badrange);
>  int badrange_add(struct badrange *badrange, u64 addr, u64 length);
>  void badrange_forget(struct badrange *badrange, phys_addr_t start,
> -- 
> 2.47.2
> 


