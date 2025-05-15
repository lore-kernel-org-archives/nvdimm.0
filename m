Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2C11E7660
	for <nvdimm@lists.linux.dev>; Thu, 15 May 2025 01:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747273476; cv=fail; b=lLNwyXrjsIH2xPvuu3zEDEwb6VvdxQIRuHnqE8q6RRgx9jfXH6mODKgCjvRDZmvrOxOehqtmcuF4RCZ5W1L1/dZQffVfYbk6xLHXE5FtWN3egtGF3MgXa0dolvwHfNlGoAbAEX4LxLKoZZMDyW1I/iL4sBZRN3x/PnTP1b5STTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747273476; c=relaxed/simple;
	bh=W8giiG9WZWaTHBDcA7S0vqRTIsKccxiDMboFlvQrCfw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DgaGAFnDR623esov4gKYZsM781LGuN3kD7uZLB5V0AS2fPgoICUDVJAteIY2JjlSbsUlK+kmKKrjuU8fPo/KORhCXS0vEEjzoJmNrmxvsn2yCKjyVPR4W8HWiEIW/ro/tmAQPEbvw0ylqfNYKYL3hU+uj64SOsrkQQ7s2CKu8RI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LE4BIryj; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LE4BIryj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747273473; x=1778809473;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=W8giiG9WZWaTHBDcA7S0vqRTIsKccxiDMboFlvQrCfw=;
  b=LE4BIryjZx69ZBYOI4SU1nbGritcmk3bbKn9fHhJYKgmAKnSvakb7WXo
   wrQXAsw9ycBDPyLPg1aUygnkDMU2Fp4khocUFIVr8DArWX1ukXkBsmdhR
   l0LhfNZsWX8rlu+mK8KkYa7MgyIzThgHpBsEqtXXJvfuohOdc+O9UW8iO
   Br3nf7WEzEatuqbLfK6BLL9DeO9lcqWm24m1e8rzDhNzXit6L5vR38wus
   YkdelPeGwf5j1ikIaXUgOUZM9PbjngynNktSBjg50vjmYjadGn5X7yzZf
   3k98CC4WYGzkB+nnWmmarXonXukmK2A0B0rbMEhpAVJPhgnh8EBpijMk0
   A==;
X-CSE-ConnectionGUID: 2yg+S9vgS8i7tliHpqzL1g==
X-CSE-MsgGUID: lxRtO8h1QMaJpKq1SkSi8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="49309840"
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="49309840"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 18:44:32 -0700
X-CSE-ConnectionGUID: /b0VXuUBRFC5hYL9jqTGmQ==
X-CSE-MsgGUID: bp4KLRZlQ76kss213S1WTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="138088827"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 18:44:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 14 May 2025 18:44:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 14 May 2025 18:44:31 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 14 May 2025 18:44:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CV2b5WDrKVwjm0JkhdHO1Yntn2fQ1xp5LqJbiugrZwsGW8puFdqQhqb3+fG8VRqvBKYXgocltOL0sve7ObAlSIx1qFgt1S/PMEENOMgZFCPuDL8xNX80D+jsDV5yY0Ar2iuebHKbHnHV27k4YmBex7X1pypJzCT9XbGgsNOpqXll6lb9FBz7TwrnLiwBLix5cSoT4adTp32wVdB+v5KEyUZP/5EAUZOSULot0KG5CfDkBamLze+xeZRwnnXy6WNTBnhIbt3RTjYRj7yLn7jM/vw1kvr+oKcsVycOoj40AcnBQ2Km0DELQvfNuwTR1f5kBeqjhCAWlCO60pJr6f+I7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTahcykZZz0pqZNP/5y8NPP0FIxe7WZeyD4+y+oYZ/I=;
 b=i2uNgk5YMsZWZ/MTtBdgrlVnuXFm3GjfKMOmjTxN4gJKwDUh1H7pTj0F7O/aRFQG1iPIXJoaGI4KFNWTHTKntkzDaiCG+8maktLHlk09rJt+W+OOuJ+Ol+m/fdu6Ir88iBdRi1fxEWTrm1+whV1uYkssOwyuZtja2ufg4WsRT1p37WnVWgJ7uy1NuPjpCB1gHdaRUZDZSdKLzpmh/40SwWMXz8qQVXkck8yjQ/+LvctVLaAhjfVFGujRIC8RtAzRHxplKHP7n9eOmwsfCGV4AB3yHCYv4yj1fEqPwADEcDOS7wr+4m++DC29JjiryHDm2ctC9/R5QfUEXyDM2CSEkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by BY1PR11MB8128.namprd11.prod.outlook.com (2603:10b6:a03:52c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Thu, 15 May
 2025 01:43:43 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8722.027; Thu, 15 May 2025
 01:43:43 +0000
Date: Wed, 14 May 2025 18:43:40 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <Marc.Herbert@linux.intel.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] test/monitor.sh: remove useless sleeps
Message-ID: <aCVGzLV54tAHWKOO@aschofie-mobl2.lan>
References: <20250514014133.1431846-1-alison.schofield@intel.com>
 <19c11b39-180d-4f91-8c27-5834f4af17e5@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <19c11b39-180d-4f91-8c27-5834f4af17e5@linux.intel.com>
X-ClientProxiedBy: BYAPR11CA0094.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::35) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|BY1PR11MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: fdb3bd24-74fa-4f30-11c5-08dd9351ecb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mhCrieKTiHyVoITpEMYF5NxUUGb2eGKIeyVsSxbN/c1EByL76VDR8du758vy?=
 =?us-ascii?Q?cTMtRQMP/CZ0Xa1dy6iWRqz/CAFCbCOnTzfo+Xy+N5JstYM/XQFkrZ7lOho9?=
 =?us-ascii?Q?nuZGQ0bIOvpcani+SslvX7wPOHY+8/+Qqe7F0qMPKJIbHKWGHtaX907EWtSo?=
 =?us-ascii?Q?eeg4GusFQIXk4uec/7u/FxXpE8S53Xmhn7JDADv0swk0vGIJrs7TLkGqmU0e?=
 =?us-ascii?Q?q6PkPbx3FVUJoMowVIBUz3HvrDQOwKWJP9yD97kZunKkD1erz0oVQLaktRTn?=
 =?us-ascii?Q?VW2Fa44uvr/h9uU58Xbv42u+/EUqG91oBzNkDRkalEwMFOB+4LQtV6HIY+Pq?=
 =?us-ascii?Q?xJqTkdfAYmgP1bW0XNs84/2Bi76CkE0iJRWIwzVdDcC+1Ci7eNt/PoL3pxaI?=
 =?us-ascii?Q?kV3+z9z9NWkNTaz5ffasao9rN+TTl/WgFLYU5QP+9CL9qdsDTlQjave/ntuZ?=
 =?us-ascii?Q?8HYxFETdjQ/DXM75fjGLXjdzBPkvRtYiaqCqc3hSrdBf9LojQmKxyDHEEtK7?=
 =?us-ascii?Q?1Siu3haWEnoxSAWBbWwbaZRZaPjuOXerR1RhsI0YBH0f+ZEhKy/6tG0eznNt?=
 =?us-ascii?Q?L2kXWs2azV8jGx+JTHSHnKdFN8VO3o3DauuIYztVSGS0jyhbE2u3/IwcJ78D?=
 =?us-ascii?Q?60mrcc/NCmCO5XmSxEcH0oJSPZfUu2gayxC+mvqp6CUdB5+qFst8sRw6uB4Q?=
 =?us-ascii?Q?AlVWYXfbixcuS+WZKbTDkpEJqN9pDkJBzNmbKUPsoo2KbBpQcf7xTiKPRe2g?=
 =?us-ascii?Q?+qI1fjXP1g633YNdkOJXmalAEIYGIO/rHd7HF3JIHwBtEuwUB8AL+Z/nd69A?=
 =?us-ascii?Q?GfdbrxPlCvy93N3o5c+veWha+4VQOx6uzNsmoJA087BLfmUx23RrDih/4LR9?=
 =?us-ascii?Q?3s8u2fzqsEfn7ZqEPuZXmjcxN/iWpKNkT8DvdNEopoFXET4FTiDaWBYfKKfN?=
 =?us-ascii?Q?OKMTVRzxtO0UefRaz4HpUiOMMvKX8MWVGSR+ax6LVbOENvKgL5N+NH4D3jW5?=
 =?us-ascii?Q?tl4os2zg79+3or87lOgl1wJeELXTAxEkHevI6UkH+JI/3qh3K9k1/LVFuP0h?=
 =?us-ascii?Q?nyQ6Pp7FjERTEL9yTjaUKtupXLkR+7k4C2zh8POnI5zsq9Yvyj0i7UeE1QQs?=
 =?us-ascii?Q?ud+fG5Zv3SVl/A5T7nTB0bDRU40vlmpRA6tZ5C4pOTdqWso2kEvGlpiHxsUQ?=
 =?us-ascii?Q?B9ePFUJe2egtP4wNvLJUFCXadlDC53+PiKzXg8PDLJV2RK5e9IRtJ/unijMJ?=
 =?us-ascii?Q?pg8MQWUlSOIspnsdIhDQxqJQcVgHcmHyJzzpdxSdzbcV0B+3AOq0GXvcf65v?=
 =?us-ascii?Q?sHhO/WU2MrpOj93jqgKKePuiFc3/FeBNVWd9v3jGfv6dRqRIbqtsWdp+0Uwz?=
 =?us-ascii?Q?DWgGGao053vbGCKaiOqztjeXkdH6GDfDvW6QsrYbN3/azVzgZg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FGNuVsh8o1Vbv5DV9uSMVWm0+OkXB3qzqjtl4uaDvcXNPYOHPP5dwKtjWDf7?=
 =?us-ascii?Q?3XPXARlvDaGxIxVuI8ZC87EDNdHVDrcXzUu5/3/hZ21dzGzBgqyPuBREnID4?=
 =?us-ascii?Q?JA8C/tP34xQ9JMGGnuSglm801n91aA17T4lyFCIb4azfLg+EgBL2W1zKPycS?=
 =?us-ascii?Q?TBXO+KhxW8AzsaqAA7G8jmiRXejZgoVwJIE8pWOeHECEmEvSLv7F74jXY9SR?=
 =?us-ascii?Q?DHwj5TGr/WKNv+/NQsfnU6eMVgcxVxX8LqHS9VdvleXljy4nHwKR/lkaUTqo?=
 =?us-ascii?Q?swmj3L8W+GN8iwv57Vu+QKSXd0XhsghqBG9/RRljgpjBZuN1xI+j7tMf3dhe?=
 =?us-ascii?Q?bo/7LEz/92HA7bUnf60ybv71q0MV/C/wpUiczNXzki5nv9TxlcydpaGcdcXG?=
 =?us-ascii?Q?Pgly395xxjTJkw1yrNVF34suu7SU1sCDdr5hvD+L2DSRvzse4Pt9XwUau1oA?=
 =?us-ascii?Q?95Kv9xc7mCv6thi60ARdVTqkJUosKDxJRpXdcZkIGlUkkSlhLqZv/I0w1SFy?=
 =?us-ascii?Q?aTfxzejjBZ9QhwFXZDi3e1uVojnhEq1NkC/cV4VjuplQjcqmYmKd+4MnPSBT?=
 =?us-ascii?Q?/mmGsEEiFBCDO3jE2slATO1hDbpV+kbrERPDYxlDdqMTvhh1Mg2rm+p4LQst?=
 =?us-ascii?Q?DldeZnJjO6JZuCagEQlvRpSrp2EQ9Xv2hvisUP2bhajltplRj6fkySCNd+i8?=
 =?us-ascii?Q?lf3QammSWdNm33v0Os0QFx0lIOZbH+81AlC/EZJ2o875i/HNIq67qpsF/3QE?=
 =?us-ascii?Q?ANsr85BiXBlIo/Mr45cIU9vc6rpG/HdEXMAqcGQp5wY50TuYXqsNBDtkFcnn?=
 =?us-ascii?Q?AjZ8ofR39tvBdA5Gh8Nl+Yfx3imkKFDcdvpFxzFwdZ/C0vaJ3bG4N8qudQiS?=
 =?us-ascii?Q?zAopc2ioaf08U/vs2FgFdpPlsFA/ceroGj3mKeXGLgQPPMmBMN5RHzC3umoT?=
 =?us-ascii?Q?rboCjYlyl0Q4vZnOAA/5YBhjX8jou49K8lTzcefOo2M60jyzHaMZwUJWSot4?=
 =?us-ascii?Q?/jvqnrZeAcCca9FCViCIkFc+DWW+Bu8YLdDPQx9WW+lceXdyXXr9ewzyOUDK?=
 =?us-ascii?Q?mMAGRZJ/Li8XRgiQhbrj+kLCEhz2LoELt/l6+CJF1mZkrK29HfJQOJRpKwgl?=
 =?us-ascii?Q?8MNIepEikZmV5mIPHXArmBjRygswXgLgWVxImF8VMtCl6T1sjLo+2U7rnUK8?=
 =?us-ascii?Q?Zph8y1LUBhRh09+QDqEMCkiEYtDc8If7Rp3vhACc2WpqXpN2HI9cqg8Y2+rM?=
 =?us-ascii?Q?bazwMlf4AOxUvOBBp8ZbqLxeQ5KHxOd9RSwL8KuYnegD6KujdmyXCN06vWiC?=
 =?us-ascii?Q?aewmpkIAOojd60QlsKMVHB91D2kiGTPSvZxrnrXXYISspxLonLJnbHVz+BG0?=
 =?us-ascii?Q?lnVeaAGJii/G/b1OvA1YEsiVixlKne6co5KigCAeRxyPgG1l27BKQYFzAa7R?=
 =?us-ascii?Q?1nCgJYMD8DkChs/ZjvnCNmG6kVMbECtN7EQ9W7TL/E/W2FUG7cXCxQk+94z2?=
 =?us-ascii?Q?N6i2RZesnHxEd3lkty7FjVT5bpmJKc8+KlKgpH1QuKH7ulLP+x/6pkywQx1m?=
 =?us-ascii?Q?6pWhqH6rEqPtO+c33D7yWHCui8hqHke1cmUsRZaa1mH7IaFBEj+wcAncOgP3?=
 =?us-ascii?Q?UQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb3bd24-74fa-4f30-11c5-08dd9351ecb1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 01:43:43.1616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CYHJWlyBO7oro6415shFn+DFFqi1FrEn/aNQgHRSgBbtqFFPeMQ6jRJmlZkx/ruFHQM5YwyJxipCGBdSSrlhNhcjP58bH6onZlIsD88W2W8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8128
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 03:14:07PM -0700, Marc Herbert wrote:
> On 2025-05-13 18:41, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > monitor.sh runs for 50 seconds and spends 48 of those seconds sleeping.
> > Removing the sleeps entirely has no effect on the test in this users
> > environment. It passes and produces the same test log.
> > 
> > Experiments replacing sleeps with polling for monitor ready and log file
> > updates proved that both are always available following the sync so there
> > is no need to replace the sleeps with a more precise or reliable polling
> > method. Simply remove the sleeps. Run time is now < 3s.
> > 
> > I'd especially like to get Tested-by tags on this one to confirm that my
> > environment isn't special and that this succeeds elsewhere.
> 
> In my configuration, this patch makes the test fail 100% of the time.
> It passes 100% of the time without this patch.

Thanks for testing!
Let me resurrect the polling version and I'll pass it by you to try out.

--Alison
> 
> Also, it leaves a "ndctl monitor" behind which makes meson hang
> forever, believing the test is never done.
> 
> Tested on top of current "origin/pending" 1850ddcbcbf9
> 
> Marc
> 
> nmem6: supported alarms: 0x7
> nmem6: set spare threshold: 99
> libndctl: do_cmd: bus: 2 dimm: 0x100 cmd: cmd_call:smart_set_thresh status: 0 fw: 0 (success)
> nmem6: set mtemp threshold: 11.50
> libndctl: do_cmd: bus: 2 dimm: 0x100 cmd: cmd_call:smart_set_thresh status: 0 fw: 0 (success)
> nmem6: set ctemp threshold: 12.50
> libndctl: do_cmd: bus: 2 dimm: 0x100 cmd: cmd_call:smart_set_thresh status: 0 fw: 0 (success)
> nmem6: set thresholds back to defaults
> libndctl: do_cmd: bus: 2 dimm: 0x100 cmd: cmd_call:smart_set_thresh status: 0 fw: 0 (success)
> libdaxctl: daxctl_unref: context 0x56469566a9d0 released
> libndctl: ndctl_unref: context 0x56469566b050 released
> + sync
> + check_result 'nmem4 nmem5 nmem6 nmem7'
> ++ cat /tmp/tmp.mYY263Hk3f
> + jlog=
> ++ jq .dimm.dev
> ++ sort
> ++ uniq
> ++ xargs
> + notify_dimms=
> + [[ nmem4 nmem5 nmem6 nmem7 == '' ]]
> ++ err 65
> +++ basename /root/CXL/ndctl/test/monitor.sh
> ++ echo test/monitor.sh: failed at line 65
> test/monitor.sh: failed at line 65
> ++ '[' -n '' ']'
> ++ exit 1
> 
> 
> 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  test/monitor.sh | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/test/monitor.sh b/test/monitor.sh
> > index be8e24d6f3aa..88e253e5df00 100755
> > --- a/test/monitor.sh
> > +++ b/test/monitor.sh
> > @@ -26,7 +26,7 @@ start_monitor()
> >  	logfile=$(mktemp)
> >  	$NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &
> >  	monitor_pid=$!
> > -	sync; sleep 3
> > +	sync
> >  	truncate --size 0 "$logfile" #remove startup log
> >  }
> >  
> > @@ -49,13 +49,13 @@ get_monitor_dimm()
> >  call_notify()
> >  {
> >  	"$TEST_PATH"/smart-notify "$smart_supported_bus"
> > -	sync; sleep 3
> > +	sync
> >  }
> >  
> >  inject_smart()
> >  {
> >  	$NDCTL inject-smart "$monitor_dimms" $1
> > -	sync; sleep 3
> > +	sync
> >  }
> >  
> >  check_result()
> 
