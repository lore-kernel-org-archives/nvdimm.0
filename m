Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F38540DFDB
	for <nvdimm@lists.linux.dev>; Sat,  2 May 2026 05:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777699130; cv=fail; b=tA5a6IPG+ZBpSCrwkB3lEPuiIBF24RejSZ7qdkyy6izM5weD+h3OMQ8bEkbuiQ2NkyYR3rCgu08gkkOz6iGRXjxPwuuNCPqSEu05YZClRhb5OLXrA6Xh4e+WVYSH3DEUilBaA16a49dnT3gZpip8RMzIbYZq54JcYv4thM8+WaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777699130; c=relaxed/simple;
	bh=a/vzxKa1+AYJ8UWUbHRvgKbSuuIKyhGybceGIwKdToM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SgA90XaiZdu+MBDYJsYicoA1JBvuWe7BDyS7+4Qe0MiQQCVe9VHMTq+2OF5n/Q4an8r8lzaLDBK9aFL/c/KN/Y5F+WSiCH3eZ+r2m6u6JBqo9jrCs3wuKewMPzfrUWNA7ZKB2Ap97UNFJBgfDdQKbMz0N7C9xKKPG4HofLomNko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aN/swAoH; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aN/swAoH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777699128; x=1809235128;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=a/vzxKa1+AYJ8UWUbHRvgKbSuuIKyhGybceGIwKdToM=;
  b=aN/swAoHspHmdokBaDGq3ZKRxAevpCylRQ59S+6n0tWKmY04ZwsmXzGC
   OrWKIo3kJF/Rf+ZcsIUlNWBTHp256Rkb/eq2o9sHXornCBcPnqE5ZBXdt
   7eZSD9IeoONKz7QDU0Tfm0n8SNLmoc4biu7gNMC9D8UDgQef4v1Mc+wz7
   d3fBF0c5M+ObaYnhUMZkOLw73WMByc6ZPgcItkqmQa/o70lJFZxRFoEIE
   FARf/+GHXJz+Pa/G68N21h7imiWO3CmIik+rDaRMExlyfW96lbJ0rsmw5
   o0e4/GUzoYKd3f2Yx2O0JXVg3BkZLJ2aONedq7/T6CWlQ6UMT7QeDuscm
   g==;
X-CSE-ConnectionGUID: amRpaMedS1GTgS0tkNoayw==
X-CSE-MsgGUID: hZZ1UcQ8Sd+wEvya9QoROQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11773"; a="78677618"
X-IronPort-AV: E=Sophos;i="6.23,211,1770624000"; 
   d="scan'208";a="78677618"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 22:18:47 -0700
X-CSE-ConnectionGUID: DZNzD8rGQhasiqv1vvrbPg==
X-CSE-MsgGUID: R9BoOvdJTxKXzfULZ/BmZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,211,1770624000"; 
   d="scan'208";a="240038279"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 22:18:47 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 22:18:47 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 1 May 2026 22:18:47 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.57) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 22:18:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gXnjtul670bkQDWT7yjemyu4Zt0z17HTJ2Jp9daZVXXBL4QwzGPGDo0MGn4jQX6A21CQ19hyfYS7TXpSqsMWD/dCuKjyIKOVTl1vr1Z88E+CBFLfvbv6snYJ2XyiUXzUYYwR30ZmzthY5PndRKXTljrUULHS/f0CvuV5qR5INH3PCbD3Y/GYaTodbM9t2HA9lwkYqKN8TXsmmdHFyNKKC65ulri8uMzIcgG3S9ZdZFAMXyzZQaCJkEWaf8q2ksnPWFpu61NDaFRZAE85Izt9MQKlz5xbAjGFRT8eXJjrxYKMuS/K/CvixpvrcypWOzZVHxctStThDWZZEOPxZCkKAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0WXhPH85yxFzW9pk8FedF23t70E4hUvN3HphHheIJs=;
 b=ezV1f78m/Bn5PGQWpme0pbOWQ73VfeeFuXhDyBPDzjh+xZ3lM7HvYTzHtzZWUha+jWacF8MMJbPxZCLlRlNg7zaC1o5h8OsmOGQsbFN8xCljL9oeOMrcD807wvXnj4S4bVnX9CGPL922O8K5q1iGyXBwKBV7UCwP2ZEq4UkiAOvALRg9c7zHjHpwpo6mcWryqYAu/jtPUJ9DlGklufHteQmSf1PJZ0QTxOaVY6NEpyGRosNZONGoOdygR1t5RJE3Tv139OknlZNZn8PFy7p+8iO/4daWfCTtXwjROALwwxFFOggJ0G5xxvMY/gE1tUyon3vdqvGeLA3cGKWtAclPRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA3PR11MB8940.namprd11.prod.outlook.com (2603:10b6:208:57e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.28; Sat, 2 May
 2026 05:18:44 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9870.022; Sat, 2 May 2026
 05:18:44 +0000
Date: Fri, 1 May 2026 22:18:40 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
CC: <nvdimm@lists.linux.dev>, Dan Williams <djbw@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
Subject: Re: [PATCH v2] nvdimm/btt: Handle preemption in BTT lane acquisition
Message-ID: <afWJMDmiLiimIqUV@aschofie-mobl2.lan>
References: <20260430024652.3920875-1-alison.schofield@intel.com>
 <7342d64f2905fe7479d255b301a94274f694e4dd.camel@linux.ibm.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7342d64f2905fe7479d255b301a94274f694e4dd.camel@linux.ibm.com>
X-ClientProxiedBy: BY1P220CA0043.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59e::11) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA3PR11MB8940:EE_
X-MS-Office365-Filtering-Correlation-Id: 49256146-5742-48b3-de0c-08dea80a47c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: /GTSPHqEZYA7j6KG/BqUnYVVTOoq+RKcHOFIZItk8sWaOw2REGXqW4fo530lPrB1I+/D2X1BMOwhUhSISrOKHqlnD7qsR3O1KE5EPpgKDKDBuoK/vI/9Kri9grqScWx9mG7jfu574ZfxQP3O54WJ0nlDxIbrQ2oRlZVCYrU1Epae0NLw5Xl3VFY32tBnxWxkKTg3m2eVv4rhtI1wAwEZHvR+m0rfYQ12TsSJ4ILNceNndiTF+2tWrQsNj40IupjaAXrREFzM6uojFfZ1BY2FiKm7IzSTKNo25QgY8wKSZ+0XuPeVmIDr0Q+GPBztJEvD1iLZc0KfxpH5C6JmMqUrHvHra23zYeGxeQCcCDmabgmkKr0JcYhsmwKLz0SrX2tX6P3UdaxgBJSDm/kKtomi5xiLVZLXcCEqEMhNlANuiWnJYIU0xAUh2zeAoiqjFLLWs0QlZgiui5FMV7leQ8DYUHba10slO8zrWgsi0r2sR2pk7m2a3ct7Q8kblbUiwkDkGiboWvUaS+W5zVlu+IIEg6mML0LxZGBGhq0jVOneWHbbbeaoITMeFmKDS11h0WnFIGsA8THfA7qO9TQPSJqxNRKN0AOP3zA2n0/IFcvHTbeVgn9bgqVvJ8aUFmCtpkMYG8ra6i9bnon5pnOoBkwPoN/+kCe/ANS8OL0TXouiyUqe0VEo7dzssSFtezg/OidhZ6oLN6ac+5sHOupHkXBEMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?4HDONHAAeA6FYyG8zuYJgp/9IuiDgvNQ918HK/h7SALd1xVS5c/LqehcLI?=
 =?iso-8859-1?Q?K/+Hl+ctwQGccT9hHZFyDUPaTmJJriDi0gbb7uPMs2Hpm03XYUHX4TmABN?=
 =?iso-8859-1?Q?v0OancCXE8jJwZCjBKI/QHVeaOMRF/5GbTZkMUe+xOJSIrnNH+nYgAoIAK?=
 =?iso-8859-1?Q?HkG5JdyLWrYWsIIwDP76+ynspnpDBGPQ5R/Rp+9WRACw2O4yBEb5JlBk2C?=
 =?iso-8859-1?Q?AgCCnk8W1ZJgzgPViJE7zlNJou8iESV5hfGDGPAMfLOF9x8W+u9ZTOTBIV?=
 =?iso-8859-1?Q?M0dg+9XQIrwa4SyVsDEW25qCwaDf8Rb7TMarMHvBK1+zKKoDM0FI6k2tws?=
 =?iso-8859-1?Q?CY2cx3G2bANDfVXPeCnzEHfoMr8wiefbY77xOkHTzcBSeyBjKFRkH8/bTY?=
 =?iso-8859-1?Q?Ao3znozlj8Y62GVyozF59khw0FHnzwWqKePqveYH140SLKfDh8HR4F96eq?=
 =?iso-8859-1?Q?JzAkXSFAWfeTqWYIKAbstxim1eYNMxHBpIR40a7PKtv2foJFJoSOsDH2Nw?=
 =?iso-8859-1?Q?Th1ow7HSlg4SKDMVyYkyChWfs9hiGW4o1UXiA1LzsrTf1WMyv4vjuvlh8V?=
 =?iso-8859-1?Q?SdKGoQYVJ3GTpDKihnyhvSnb3Y5lDsw72LvVUlFQVFhbIlGh2BLnWznjjO?=
 =?iso-8859-1?Q?v7psoyKfQp86wKPS4qAV6JzjjRXO2NUL5NGx5dzhrWo58WyzH4rH1S415N?=
 =?iso-8859-1?Q?noobGQUpgeS1VyapnkqAv4YSLR6Wz8IqyyjNKsBWhdZganFFymNB9IMh7t?=
 =?iso-8859-1?Q?hU1kZrV8S7JSkXH7NY4sGQrlwOW+Hw4mfNVpTJvNkwlC8SgqNZE+5qSbXz?=
 =?iso-8859-1?Q?ER44p1pjNVjoZbSe86nyfszxjd1kKqOiyV5ee7dwjmcy+M3MbY2QtmYkXI?=
 =?iso-8859-1?Q?dqdkcfaqzyByzRmC5eCp0kaLE9nyyd1BO5G+jcclzRCTgS5GfqErmMqPyn?=
 =?iso-8859-1?Q?5sUcWQTsF3UVPOGTiayW7k53xvpr8Nre/lwKi3GU1uuMoava3mNdeth07V?=
 =?iso-8859-1?Q?WI9xnL9YPt8FWnpEQtRvUA2jbWOd3f4gRmRuGzfyZ23u/ilK3SVhDdqkaT?=
 =?iso-8859-1?Q?bzwi4IDScxugWoHp++c3bwmhZ+8+rzT1npCSgvlocaHie1ZJAElSSFsRpI?=
 =?iso-8859-1?Q?AnwkbuFRx4qTrI0itmhuUJZdIHYz9WbuuFZ1vHmPmIN9TuqIpC0FBmK72H?=
 =?iso-8859-1?Q?pHJHaJCCIoSL+y8sAtW5fraqPkOlkc4nN1mQKCBvr9y4ryKMizQzDDLjFX?=
 =?iso-8859-1?Q?AQUKA81EkKiTYd7mMsvkYV+41sEVfB/3OOzxsz6kG86s8l6ArouCvQA3MA?=
 =?iso-8859-1?Q?K5enAjuzS5BqAsFfXBOeWww4maStZI1QuvwZCtM5Yy8k7NocChE/uTVoK6?=
 =?iso-8859-1?Q?mi+qrVDUx4C06+yidUC90ghF5/s7/G+bAHglsxUZyN/o7I/pgWrYU3d+9n?=
 =?iso-8859-1?Q?5ROHIodP38rRBvLbytGNqBYqhUFSYQwU1ilWOlxtBG1tNcx6iDwrBYUGkN?=
 =?iso-8859-1?Q?h5FWS0Zz7vUleO8/iPdKWzRr0PNCPJCmq/N0uMP1+qZYgE1MS0LTWFQn7Z?=
 =?iso-8859-1?Q?ZRen62eTu5qnaeOa92vG9vLW/azp6gZzitjiTJF4RGb+xt7sLyGKBDIs34?=
 =?iso-8859-1?Q?uaUsxd47ExAZvV0mjRhev3H2CzqMwFdBVhYC5qMoG5bWWuo83lGX62j348?=
 =?iso-8859-1?Q?v8c+nS5J08W2LDsrlANBbxOw961GQvnmPVSqFjfIdH0YEnViAA6yNfY8Ib?=
 =?iso-8859-1?Q?k/Dr9qi7Zyb8CEHxB/rvR1MM6q3cj0GZRHtcAm04HBTxH0ZqYD25Jp3iGj?=
 =?iso-8859-1?Q?vj6gFRETipKtQ3syDTTiSVnyIL4Jurs=3D?=
X-Exchange-RoutingPolicyChecked: uLBobLSYl1NqeRhHRMdaiI+LaeVPygGNA2mP4hcaq1WsC78g3ahc1BcR5wojdL4CPMXdRAwBAd7yW1U0cYnlpQbUk/Y5X8fMqIbZrRokhSnVB3WE6d0jRBm9zVZKDbxK5wpXmT/xdLrnEfhRtLv/7Jzm/GAIHroUPwOS/fijdKXEXeiigFl+OwqBHH72c+4WOisVqrQwFz426TaU62FJf6NE7X//2UFJmlzYrbg0kMX9txwCexlXAH0WfQcFAX3rZkazZjo8P4cX3BOyFmlZEjJR2/ppdIOxxWDBGzUGVEgLmo2TWvwPTB7SQQLgoorB6a1XSwu9IRGikwsRTz+WGg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 49256146-5742-48b3-de0c-08dea80a47c4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2026 05:18:44.2221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WDATdG0seN7vcmgjmhSMVwh8h2ShAciTw46eGScC1zsLzkpF7fb7nlNCLnmRoqNQFvcgVXe/IDtxEkBj07lgnH6g7nI2J/Tp043Ky8X6Tmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8940
X-OriginatorOrg: intel.com

On Fri, May 01, 2026 at 05:01:15PM +0530, Aboorva Devarajan wrote:
> On Wed, 2026-04-29 at 19:46 -0700, Alison Schofield wrote:
> > BTT (Block Translation Table) makes persistent memory safe for block
> > I/O by guaranteeing atomic sector updates. It uses reserved lanes
> > for in-flight BTT operations, which must be used exclusively.
> > 
> > The btt-check unit test reports data mismatches during BTT I/O due
> > to a race in lane acquisition, leading to silent data corruption.
> > 
> > BTT lane acquisition uses per-CPU recursion tracking with
> > migrate_disable(). However, migrate_disable() does not prevent
> > preemption, so another task can run on the same CPU and share the
> > recursion state. That task can observe a non-zero recursion count,
> > bypass locking, and use the same lane at the same time.
> > 
> > Track lane ownership per task and only allow lockless recursion for
> > the owning task. Otherwise, serialize access with the lane spinlock.
> > Use spin_(un)lock_bh() so softirq re-entry on the same CPU cannot
> > bypass ownership checks or deadlock on the lane lock.
> > 
> > Found with the NDCTL unit test btt-check.sh
> > 
> > Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
> > Assisted-by: Claude Sonnet 4.5
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> > 
> > Changes in v2:
> > Use spin_(un)lock_bh() (Sashiko AI)
> > Update commit log per softirq re-enty and spinlock change
> > 
> > A new unit test to stress this is under review here:
> > https://lore.kernel.org/nvdimm/20260424233633.3762217-1-alison.schofield@intel.com/
> > 
> > 
> >  drivers/nvdimm/nd.h          |  1 +
> >  drivers/nvdimm/region_devs.c | 48 +++++++++++++++++++++---------------
> >  2 files changed, 29 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> > index b199eea3260e..424c38ca4960 100644
> > --- a/drivers/nvdimm/nd.h
> > +++ b/drivers/nvdimm/nd.h
> > @@ -368,6 +368,7 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd);
> >  struct nd_percpu_lane {
> >  	int count;
> >  	spinlock_t lock;
> > +	struct task_struct *owner;
> >  };
> >  
> >  enum nd_label_flags {
> > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> > index e35c2e18518f..f1c6dcd95b5a 100644
> > --- a/drivers/nvdimm/region_devs.c
> > +++ b/drivers/nvdimm/region_devs.c
> > @@ -905,11 +905,10 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
> >   * @nd_region: region id and number of lanes possible
> >   *
> >   * A lane correlates to a BLK-data-window and/or a log slot in the BTT.
> > - * We optimize for the common case where there are 256 lanes, one
> > - * per-cpu.  For larger systems we need to lock to share lanes.  For now
> > - * this implementation assumes the cost of maintaining an allocator for
> > - * free lanes is on the order of the lock hold time, so it implements a
> > - * static lane = cpu % num_lanes mapping.
> > + * Lanes are shared across CPUs using a static lane = cpu % num_lanes
> > + * mapping, with a per-lane spinlock to serialize access when multiple
> > + * tasks share a lane (including when preemption causes multiple tasks
> > + * to run on the same CPU).
> >   *
> >   * In the case of a BTT instance on top of a BLK namespace a lane may be
> >   * acquired recursively.  We lock on the first instance.
> > @@ -920,35 +919,44 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
> >  unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
> >  {
> >  	unsigned int cpu, lane;
> > +	struct nd_percpu_lane *ndl;
> >  
> >  	migrate_disable();
> >  	cpu = smp_processor_id();
> > -	if (nd_region->num_lanes < nr_cpu_ids) {
> > -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> > -
> > +	if (nd_region->num_lanes < nr_cpu_ids)
> >  		lane = cpu % nd_region->num_lanes;
> > -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> > -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> > -		if (ndl_count->count++ == 0)
> > -			spin_lock(&ndl_lock->lock);
> > -	} else
> > +	else
> >  		lane = cpu;
> >  
> > +	/*
> > +	 * migrate_disable() keeps the lane stable, but does not prevent
> > +	 * preemption. Only the owning task may recurse without taking the
> > +	 * lock.
> > +	 */
> > +	ndl = per_cpu_ptr(nd_region->lane, lane);
> > +	if (READ_ONCE(ndl->owner) != current) {
> > +		spin_lock_bh(&ndl->lock);
> > +		WRITE_ONCE(ndl->owner, current);
> > +	}
> > +	ndl->count++;
> > +
> >  	return lane;
> >  }
> >  EXPORT_SYMBOL(nd_region_acquire_lane);
> >  
> >  void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
> >  {
> > -	if (nd_region->num_lanes < nr_cpu_ids) {
> > -		unsigned int cpu = smp_processor_id();
> > -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> > +	struct nd_percpu_lane *ndl = per_cpu_ptr(nd_region->lane, lane);
> >  
> > -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> > -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> > -		if (--ndl_count->count == 0)
> > -			spin_unlock(&ndl_lock->lock);
> > +	if (WARN_ON_ONCE(READ_ONCE(ndl->owner) != current))
> > +		goto out;
> > +
> > +	if (--ndl->count == 0) {
> > +		WRITE_ONCE(ndl->owner, NULL);
> > +		spin_unlock_bh(&ndl->lock);
> >  	}
> > +
> > +out:
> >  	migrate_enable();
> >  }
> >  EXPORT_SYMBOL(nd_region_release_lane);
> > 
> > base-commit: 028ef9c96e96197026887c0f092424679298aae8
> 
> Hi Alison,
> 
> Just a follow-up question.
> 
> I haven't reproduced this, just noticed it while reading the code.
> 
> After this patch, nd_region_acquire_lane() / nd_region_release_lane() always
> hold a spinlock, IIUC, anything that sleeps/blocks in this critical section will
> hit:
> 
>     BUG: scheduling while atomic: ...
> 
> BTT metadata writes go arena_write_bytes() -> nvdimm_write_bytes() ->
> nsio_rw_bytes(), which always calls nvdimm_flush() on write. That can call
> nd_region->flush():
> 
>   - virtio_pmem_flush() uses a wait_event(), so it can block on
>     every flush.
> 
>   - papr_scm_pmem_flush() only msleep() when the flush hcall
>     comes back busy; the fast path does not sleep, though this is rare case.
> 
> So BTT on virtio_pmem looks like it could trip the BUG on metadata
> writes, papr_scm only if the busy path is taken? Pre-patch, the same behaviour
> already existed on > 256-CPU boxes where the lane spinlock was taken.
> 
> Is this an actual concern, so are we essentially saying that no sleep /
> blocking wait is allowed anywhere reachable from the lane critical section?
> 
> Please correct me if I'm missing something here.

Thanks for the review. You found a real issue.

The BTT lane lock is held across BTT write paths that can reach
nvdimm_flush(), and provider flush callbacks (e.g. virtio_pmem and
papr_scm) can sleep. So the current design incorrectly assumes that
the lane critical section is fully atomic.

As you pointed out, this predates this patch. The shared-lane path
has held a spinlock across this same call chain since the original
BTT merge. This patch probably widens the exposure by taking the lock
unconditionally.

I'm reworking this as a small series. The first patch converts the
per-lane lock to a mutex so the lane critical section can safely
sleep.

I appreciate your testing and will probaly need to rely on it more
in the next version.

Thanks,
Alison

> 
> Thanks,
> Aboorva
