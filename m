Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8EE356A30
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768425429; cv=fail; b=ONYSoTFy0x/+cdjgRMeR32Ysb9uVN0Wj+DsH3fA25ZhPyxHDrSUs/cjJB54CbQdtTxMzCsJXNMLdswi5PDhszxhsNjEVNQzFztRa2obQ8tCH1rTjKCo1QqczVuB2YSnNvM3wrebNZNnyJKNj9wWqEFm7E+XnJCLop5UWipCgFDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768425429; c=relaxed/simple;
	bh=imEtja90HrGScyuVkqdZk85OHsNS1pNCS05sw+dn05I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PbTXhkbPFryyJMd2/awOFItOtvN6xbgeA9fp/tnM+yle6zucQt2Lo47M8tzsiMvWv71w5caHyw14BJA4+5NCjaXPSYWKvi3JqwjgAU1PIAONtzjbp6JVBEZVgC3J51rX5nMqo+VeiQCqI2jS7WbUAl7F/TlBOCBhMV9wZfJrAwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AOmC/a29; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AOmC/a29"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768425427; x=1799961427;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=imEtja90HrGScyuVkqdZk85OHsNS1pNCS05sw+dn05I=;
  b=AOmC/a29w48TnSeVOCEbilYU1BOxjLxSuVEuJKTiatK6U1nhz1NdZPh/
   uGHae8YwcKAnfoohIYcFElHW9acsd+mcL3UsW0/HunVwMDRN15jcT3AZN
   XtEuu27m7W2GdOYibgAq3fEoFz4kohdorpgmBwAFM99UHlab1+zUDQGXK
   RwtVmD920QkoZ7ciFA3kUkkX0RGcl12r1tONIkCl5hHk5p8aKVE99KdWl
   MJ/sEtGnl5L9j1fyGVgqyId78J92lzAf+M4lM7Ygr8KpqYXScxa/EGf1C
   QY0ec07FdDHZgqvU/JJRag7HmwElYQXNwH2NIdipEZZpojmRiBT8b8mQz
   w==;
X-CSE-ConnectionGUID: 1JTicGm4ToSMAtxBKolRew==
X-CSE-MsgGUID: 0J4RpG3sTkiCKREq53tZwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="72316447"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="72316447"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:17:06 -0800
X-CSE-ConnectionGUID: VHqh6+XJT2qrjTvYJBtrgg==
X-CSE-MsgGUID: yVjW8UUKT9C9NZI+xN87hg==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:17:06 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 13:17:05 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 13:17:05 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.67) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 13:17:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XZGacarzqWVyQNrQCD25sK5R2ddk2uYn62P5pLTjY9McEuRMNgJ/sWc8WnF81466eqUoFbjfz7mDTOrs/RFo6xXzob3LGfmJsceVmkxOLsztouvCK7AMPCWQHJ9+rdPS5dtjkzXigoH6zAFJMVIaoz3kuYrH/5pj5InIRO/dfTn9I0zLkZlf+ME1/y112GpL3kEIhDsXTqe1UfhTwdXopiWTUglzU4y5UFvF1fgkJUrY/a4RtzF276FrksDKtWB05PTdohmtHxX1Y72EMqrPghdi+H4Vti60qEsFMRqIlpQJi5HT6Sf2SsrVUpknZVDDWAKgDlII4HtPi57pZ33Y6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Alvy+RtJK417cQiPILuul0zncV+ObjMpk9eF/9bLovw=;
 b=jz0D+RJQkT9Vzo8nWXCYJW5Zkz7IpPesLuRoG40DbZA49NSNnAmcf7nSsIYlXsKwTM0VOlsdwdDHJ+wWWNrd8pYi5USXdCx1Q0+oUFgSFt/9wr1qKfmR+RcnNgnTsoQuh6xJKQrwQxUJjOiYOR2pmftnY6ffo/neYWlSw87Dflk5b+mJOEq6YAfEw5EEz4UaKDTz9g+40BD2LqUH27o8wydY1VMQ7tud8rAUJ5cw/58jAzMttB22LkgycG0J1vXn/VbI+qbNY1Ec6m5Z+W041i6ie4/ePbBySMGsTZZzf0btp84NXakfwx9NpOveX2zqn1N7ctrHzQk/BoTQGoba4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by DS7PR11MB9449.namprd11.prod.outlook.com (2603:10b6:8:266::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 21:17:04 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 21:17:04 +0000
Date: Wed, 14 Jan 2026 15:20:09 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V5 04/17] nvdimm/label: Include region label in slot
 validation
Message-ID: <69680889b4a78_1183cf100e@iweiny-mobl.notmuch>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
 <CGME20260109124512epcas5p4a6d8c2b9c6cf7cf794d1a477eaee7865@epcas5p4.samsung.com>
 <20260109124437.4025893-5-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260109124437.4025893-5-s.neeraj@samsung.com>
X-ClientProxiedBy: SJ0PR05CA0154.namprd05.prod.outlook.com
 (2603:10b6:a03:339::9) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|DS7PR11MB9449:EE_
X-MS-Office365-Filtering-Correlation-Id: 4479a6d1-cfbe-41db-2ba7-08de53b243ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Q2vN5hgxTFV1VzkKK26h6Ye3VYKoxpDmIer3/5iOCZFBw5JcRKzzlmEX5e+C?=
 =?us-ascii?Q?XCk0DvTIgrn41mJfW5Jbje3JSqz7uwgWfrmsHjTl9dAn8kV9koZUoBmd0aRh?=
 =?us-ascii?Q?WimdVejbyCQDTgDGWErkt7W0SMryXAT6XJjMHaLjedy8HxWdQ+Pm7UIXMkgr?=
 =?us-ascii?Q?ZzkYy87Lz9rHOK61XrejlzCgoX4ck9u+LT064dFhJW3v3LJqrgbsrS//4A+w?=
 =?us-ascii?Q?JhE3smGUhxj7NiaDdqb/PEb6PLRL2jJn1dS1tFRyCZ6cEhLcx1cir2Ih/4ox?=
 =?us-ascii?Q?VZ7ITyB/mvhGKM70rrTlzl8ZX2P1d3kkCh/tKc8ebMIhH4f0xeIF5Zw1kFNu?=
 =?us-ascii?Q?Z+CadafQjSqJoPH1VYQDLIprgSIEAh5q74HkqG8Dy4FNLGXMAFtleI2JXdpx?=
 =?us-ascii?Q?GE+QwaxEin8eeqfisjn2At6OriBvS4g8s0An7n82sRSkt5vOyshh5MJ4DNpl?=
 =?us-ascii?Q?fqOf8YKeYrFJ4C9hCGTe/ROL3BjmtNL3RGPwKt0Xsq1A4XTYHcZnWjLOvl75?=
 =?us-ascii?Q?qwbJqPitSt6zsUQCKnrKhia2gqDYs69GBsSTO/QTnruNfZPY1bzU71fxFt2f?=
 =?us-ascii?Q?0f8Sn8H1qlJHQqg63aea+6NcUJJ74FOCQOpL0SfAuojPUTbmr5n+pFqOaY04?=
 =?us-ascii?Q?NYATnEN8oJuDY3vda1b+9MARpYiWjNAxCWT8m+cjq2UPvn3J8ZooqdFktPFL?=
 =?us-ascii?Q?cyh8rd3rXtGqH9sU2s7yoK4wchUah6KuOlUGO1ulUkmiyqWvJCCKCT1Quww5?=
 =?us-ascii?Q?Cn0BWx5/fej6nqOPvRd9NgDAwCWetwQdDvJC6AMTEUzZOxUYEaYffvryK/Sz?=
 =?us-ascii?Q?DvhuSx4m2Adwt1iecHyQsB0Olf8LD6wJgLrkExeckXkg7T2s9ZprkiUjFGmG?=
 =?us-ascii?Q?jYzSd468P1t7/y+yLLuCgOMDggFV4iEXZftG5P7pmneHA1PL0KSGpeFEurEO?=
 =?us-ascii?Q?9Ix04sFv3cf2kkDdQZOZONLD05fED3qVtnzpSNWgheEDzJBG3gfYrmbJJ/Ef?=
 =?us-ascii?Q?ZIU9QxY83qMVdKkuCxyib8VzyLv7TSgdd97ja1SuxcV4GfP3vK1EMDY8PdiU?=
 =?us-ascii?Q?U3hHeYRqKWl60l8/FNQv8GEHW1AdGa4ztuA24+IM2qEtK8ah7k8b0xpccOtc?=
 =?us-ascii?Q?zCYMrJq4Xd4zTlXc44g/ZFLepSysrC4ANIFuFZvogsgS266y0CPDsretX4g0?=
 =?us-ascii?Q?PqvJdfaUZpw0E3qW7yOwIubat4XBMzU2mSmu5gsiqwATbgt9FPcfmy9zDBHG?=
 =?us-ascii?Q?Bo+SQBaheAWvq6rbIJE0qsV6KssN95rO73d1K7hw5u2b4gEb7u0uxSsC6Mvl?=
 =?us-ascii?Q?M2vj5yr50pvJ5UUWKtLwwQXMmlWlr4Dct/UYGwk9S95Rg3aU6QAuT1U3nWtS?=
 =?us-ascii?Q?u7byRgqS8gtv8EGXtNHrcfHM2EjSLN5xhVtqaxXtU8luQiRHofJ+TqlrO6FE?=
 =?us-ascii?Q?FHWbYpiqVmZVrD/n1SFXzgnIu1ETWxycElUJ5jBWlkMVV1HnYW1GcAbhdYaC?=
 =?us-ascii?Q?ssumccXrPafcrAE4QzWr29HTYS/rrOjjB5CDJhbBRSnZzphAWYKH2SvXmHKz?=
 =?us-ascii?Q?wRM+vM3cb28UMhIzCKg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l02lvwtUmTKIt+k+WHbDEIWrV6Flq9b9mf5qOiJi4yu1Rof0NQ34x7+h3Vq/?=
 =?us-ascii?Q?kh4qXJQt6kdUByF2jM+ADm+yIjP2aLzc4o00Gc2Jdv3IsigtK8ZEExxHd0Sj?=
 =?us-ascii?Q?jxzdQKPg8s+0SfpvsDzRKcdRq6TSvcTW1wCUhMQHcbhQ3j7zctYy3Mq9B5lq?=
 =?us-ascii?Q?ZQ6PFux5zYggwIhS+8HrdvCVmRpURxg8Xg0MN9YxTkG0BKToBDLyMl8SBweE?=
 =?us-ascii?Q?W4bKALHISAgNU9s5Fvb24fqRwfRP/iuHXp6y69RRYMz7wy2GtweqBOayw1iM?=
 =?us-ascii?Q?MYNyEaTnmS+oWL6gg/Ivk3AogKOP699uiLI8h3iuxCuJtQST0Jmr/4692Jmp?=
 =?us-ascii?Q?y3WgGfBGIG13zJt5mgG93GtwTpRD+gUc+l1ibIdWK82ghOlaFerQBczmAHLd?=
 =?us-ascii?Q?lLcTD6WalLEXioc+QGbyxIooOgVxZoMhnLujIRPYqA+xMqfTsiLtfdKCelLn?=
 =?us-ascii?Q?tS/TnZQZGZA/hvCAbWewyVSdC1bOudNUhubU2v1vxAVwB8FxRuHaKiZcyP3L?=
 =?us-ascii?Q?hkxZTBwgvxbsW/HAsa6iBaCLWhmf1bKV1BpAMdX7ZB5H+WbA/yZonoDZKva+?=
 =?us-ascii?Q?QLmyiv8V4CMX+H3Ah0bxmyS2TCFa8WFTmJ7oiH8QLlpLJqLdEbjzEQgVEZNY?=
 =?us-ascii?Q?bscYeF53vHajTim1h5Id1Vg1lq0Tu8pgL6vMubq20vva4mgnjLUomZq8uZwD?=
 =?us-ascii?Q?ZBgh0jBQKz9kNRfgVLhngO/B+ta1CB91UPdAtUlpc7Lmy/amVLqDQlcMbYX2?=
 =?us-ascii?Q?FvptJQ+9FQysBqQQoS5sHdGjZA3gddVX1Qw5pEuHX47qJv5/4SFcGeQtPQxS?=
 =?us-ascii?Q?jefQApmtEaf83zB176xLdp1FVRcb6bxvaPoCHHjrxQKjmDUlyAiZXQMlL0i6?=
 =?us-ascii?Q?WsvDnuZ/YxRLTeWivRyMKijQ8MwG1HkEYuePNCqQu7raVCRhL2TcnDbbqFpQ?=
 =?us-ascii?Q?UBFEehXbEP4YiZYQ57B1wCo0Gb23jTJoCfLxU08kEY6jqhV1p04Xs5MUVyzu?=
 =?us-ascii?Q?kCacTnFT0I5jnEY51Y/qhuRf8ai6mh7HV44hvb3LjOoxc+zLWB0qj8PmrQ3F?=
 =?us-ascii?Q?oNyxXHsxXksFnrhBdJazn6TTcUtdZOXYklSHiEFm6812/ZW/R3Xe2D6OG1JR?=
 =?us-ascii?Q?PaGSWuQyGhCsSq/n71dqwS1wo4h6BdfLE60Et+u2rlBSthgUiBkXh0xLfE2X?=
 =?us-ascii?Q?3qfWrp0sehq9Xid8zqN7HCj1vXpWWD6JQh8QrNM9sfJ4WLeN/4K+Xgni+Bp/?=
 =?us-ascii?Q?WNbDLQhcBZ4Vpp2p+MpNl5KJFWVgkCPG2iYr3qbwgKe3o/TAvnIh5LcMvdCb?=
 =?us-ascii?Q?klZ1w2dksdsZEB63BPwNLxPYmULsoQAQBT6Q4TP8+pg++PjAUSQNEKd35Bsp?=
 =?us-ascii?Q?DR4EiLXwjLUUAup1CpJ6N/AwVgoVfaXHAq09PNIZsxX9W80lpvTjHWdbMDzQ?=
 =?us-ascii?Q?ZApMW855G2QpeSC+u7sceCy7+vxRcu/G5l4/Pw7foBWy33DSHDFndPkfyNdM?=
 =?us-ascii?Q?q1Wie3GNW6zNdEVag3y3sjTUDwKxuWo7WxvsawgPzLwEU1AXviJfwb5e6zHS?=
 =?us-ascii?Q?uxXjnzpgGHttYzxb2aW3Y/XhnFND6FGBPe/1+M0eAJUWnwmKLKv+mEwRwZ8m?=
 =?us-ascii?Q?amuGnBcS2QoN+yoU8gH5AQrgODXYIrjczq9Ow2fx32ow8TWyIO0ngCrSBjr1?=
 =?us-ascii?Q?gg5cxUQaIsuaqW6SqyIQ97J/1WNk93tVO5x1B4aEPYgsVQTTmo7FMNp4bU5P?=
 =?us-ascii?Q?oCOa1ZFGPg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4479a6d1-cfbe-41db-2ba7-08de53b243ab
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 21:17:03.9624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vi1jBEolBbqLnTlNXNKn8OJPmqWY/stUakk0dbS+Dc5ICRkq+5256gi9jnjDsP46zJUcSPdrWn8qQo0yu9P7lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9449
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> Prior to LSA 2.1 Support, label in slot means only namespace
> label. But with LSA 2.1 a label can be either namespace or
> region label.
> 
> Slot validation routine validates label slot by calculating
> label checksum. It was only validating namespace label.
> This changeset also validates region label if present.
> 
> In previous patch to_lsa_label() was introduced along with
> to_label(). to_label() returns only namespace label whereas
> to_lsa_label() returns union nd_lsa_label*
> 
> In this patch We have converted all usage of to_label()

NIT: don't use 'We'

> to to_lsa_label()
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c | 94 ++++++++++++++++++++++++++++--------------
>  1 file changed, 64 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 17e2a1f5a6da..9854cb45fb62 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -312,16 +312,6 @@ static union nd_lsa_label *to_lsa_label(struct nvdimm_drvdata *ndd, int slot)
>  	return (union nd_lsa_label *) label;
>  }
>  
> -static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
> -{
> -	unsigned long label, base;
> -
> -	base = (unsigned long) nd_label_base(ndd);
> -	label = base + sizeof_namespace_label(ndd) * slot;
> -
> -	return (struct nd_namespace_label *) label;
> -}
> -
>  #define for_each_clear_bit_le(bit, addr, size) \
>  	for ((bit) = find_next_zero_bit_le((addr), (size), 0);  \
>  	     (bit) < (size);                                    \
> @@ -382,7 +372,7 @@ static bool nsl_validate_checksum(struct nvdimm_drvdata *ndd,
>  {
>  	u64 sum, sum_save;
>  
> -	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
> +	if (!efi_namespace_label_has(ndd, checksum))

What does this change have to do with region label validation during slot
validation?

>  		return true;
>  
>  	sum_save = nsl_get_checksum(ndd, nd_label);
> @@ -397,13 +387,25 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
>  {
>  	u64 sum;
>  
> -	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
> +	if (!efi_namespace_label_has(ndd, checksum))

This and the above seem like cleanups because efi_namespace_label_has()
already checks !ndd->cxl?  Was that the intent?  Perhaps as a separate
cleanup?

Rest of the patch looks reasonable,
Ira

>  		return;
>  	nsl_set_checksum(ndd, nd_label, 0);
>  	sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
>  	nsl_set_checksum(ndd, nd_label, sum);
>  }
>  
> +static bool region_label_validate_checksum(struct nvdimm_drvdata *ndd,
> +				struct cxl_region_label *region_label)
> +{
> +	u64 sum, sum_save;
> +
> +	sum_save = __le64_to_cpu(region_label->checksum);
> +	region_label->checksum = __cpu_to_le64(0);
> +	sum = nd_fletcher64(region_label, sizeof_namespace_label(ndd), 1);
> +	region_label->checksum = __cpu_to_le64(sum_save);
> +	return sum == sum_save;
> +}
> +
>  static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
>  				   struct cxl_region_label *region_label)
>  {
> @@ -415,16 +417,34 @@ static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
>  }
>  
>  static bool slot_valid(struct nvdimm_drvdata *ndd,
> -		struct nd_namespace_label *nd_label, u32 slot)
> +		       union nd_lsa_label *lsa_label, u32 slot)
>  {
> +	struct cxl_region_label *region_label = &lsa_label->region_label;
> +	struct nd_namespace_label *nd_label = &lsa_label->ns_label;
> +	enum label_type type;
>  	bool valid;
> +	static const char * const label_name[] = {
> +		[RG_LABEL_TYPE] = "region",
> +		[NS_LABEL_TYPE] = "namespace",
> +	};
>  
>  	/* check that we are written where we expect to be written */
> -	if (slot != nsl_get_slot(ndd, nd_label))
> -		return false;
> -	valid = nsl_validate_checksum(ndd, nd_label);
> +	if (is_region_label(ndd, lsa_label)) {
> +		type = RG_LABEL_TYPE;
> +		if (slot != __le32_to_cpu(region_label->slot))
> +			return false;
> +		valid = region_label_validate_checksum(ndd, region_label);
> +	} else {
> +		type = NS_LABEL_TYPE;
> +		if (slot != nsl_get_slot(ndd, nd_label))
> +			return false;
> +		valid = nsl_validate_checksum(ndd, nd_label);
> +	}
> +
>  	if (!valid)
> -		dev_dbg(ndd->dev, "fail checksum. slot: %d\n", slot);
> +		dev_dbg(ndd->dev, "%s label checksum fail. slot: %d\n",
> +			label_name[type], slot);
> +
>  	return valid;
>  }
>  
> @@ -440,14 +460,16 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  	for_each_clear_bit_le(slot, free, nslot) {
>  		struct nd_namespace_label *nd_label;
>  		struct nd_region *nd_region = NULL;
> +		union nd_lsa_label *lsa_label;
>  		struct nd_label_id label_id;
>  		struct resource *res;
>  		uuid_t label_uuid;
>  		u32 flags;
>  
> -		nd_label = to_label(ndd, slot);
> +		lsa_label = to_lsa_label(ndd, slot);
> +		nd_label = &lsa_label->ns_label;
>  
> -		if (!slot_valid(ndd, nd_label, slot))
> +		if (!slot_valid(ndd, lsa_label, slot))
>  			continue;
>  
>  		nsl_get_uuid(ndd, nd_label, &label_uuid);
> @@ -598,18 +620,30 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
>  		return 0;
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> +		struct cxl_region_label *region_label;
>  		struct nd_namespace_label *nd_label;
> -
> -		nd_label = to_label(ndd, slot);
> -
> -		if (!slot_valid(ndd, nd_label, slot)) {
> -			u32 label_slot = nsl_get_slot(ndd, nd_label);
> -			u64 size = nsl_get_rawsize(ndd, nd_label);
> -			u64 dpa = nsl_get_dpa(ndd, nd_label);
> +		union nd_lsa_label *lsa_label;
> +		u32 lslot;
> +		u64 size, dpa;
> +
> +		lsa_label = to_lsa_label(ndd, slot);
> +		nd_label = &lsa_label->ns_label;
> +		region_label = &lsa_label->region_label;
> +
> +		if (!slot_valid(ndd, lsa_label, slot)) {
> +			if (is_region_label(ndd, lsa_label)) {
> +				lslot = __le32_to_cpu(region_label->slot);
> +				size = __le64_to_cpu(region_label->rawsize);
> +				dpa = __le64_to_cpu(region_label->dpa);
> +			} else {
> +				lslot = nsl_get_slot(ndd, nd_label);
> +				size = nsl_get_rawsize(ndd, nd_label);
> +				dpa = nsl_get_dpa(ndd, nd_label);
> +			}
>  
>  			dev_dbg(ndd->dev,
>  				"slot%d invalid slot: %d dpa: %llx size: %llx\n",
> -					slot, label_slot, dpa, size);
> +					slot, lslot, dpa, size);
>  			continue;
>  		}
>  		count++;
> @@ -627,10 +661,10 @@ union nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
>  		return NULL;
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> -		struct nd_namespace_label *nd_label;
> +		union nd_lsa_label *lsa_label;
>  
> -		nd_label = to_label(ndd, slot);
> -		if (!slot_valid(ndd, nd_label, slot))
> +		lsa_label = to_lsa_label(ndd, slot);
> +		if (!slot_valid(ndd, lsa_label, slot))
>  			continue;
>  
>  		if (n-- == 0)
> -- 
> 2.34.1
> 
> 


