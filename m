Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B96F2750E6
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 21:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755205341; cv=fail; b=jTuC/EQUsmdB1jjTjyaJgj6PVRVztbkYbJ/var1ef6529RWuYNwYRPRMmpaPQcKrJDLz3Gzrn/TqSSuH0pBFowk/8jrEkd8VsKqp8EWLttzdjX6LCRcAq8fIzJJtEbZviqg/VYgAtM+SaQGFBDvvQ8APHS0V6h+F+/WKyzcL68E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755205341; c=relaxed/simple;
	bh=/LtxSfzpJ1Hpnl60TP2NP9fAg4uvokjEJPSoVX0TUEg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ilessLkBrMndQOWsamBTJ06TPUsL+4yVBL+Cu4thrXO7/TBI+UNDFVJnMw6N1uueTRVi/zuthh1oEjrnwasrNIYVVLYctPBTcPOYcuPbIep7K/T3qNBHbfBv0WkV1T1hiCTTmQ6pNQufo6G9Sk9FJoW01KOkkQNHwp5PR3ceAUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A5qhBJhG; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A5qhBJhG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755205340; x=1786741340;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/LtxSfzpJ1Hpnl60TP2NP9fAg4uvokjEJPSoVX0TUEg=;
  b=A5qhBJhG9bMO1YRW4ZyXgC3Q/vWJsE4ruVIgKePANVc/S2uPrA5n/zOP
   0t+vmyRpUj4WsUmu2AldePuqa/FPZ7L1lqSZoqLwKbzmQIZt79OTR8tI7
   FHaqDPW+/RDS4/ar9ELH27n2kHzH8XBPuMXIIKssx6l2yox6FKdlpApZ3
   zf9aWzPNgUNuWm9Ja6w+0fxWG2dYm+1Bho0ppXqvCanp9dtzdLUPfyVAL
   +4oCb8OuAtElPZA5BJX8pBK+G17jU7ubncgHgZvibYNpmtKrL1Rr/QkNR
   oalsemaJkS6StTGIkLo4htGW8Vf5fcphU8OdCbxF9Z5dczCo5qojxdeg0
   Q==;
X-CSE-ConnectionGUID: 160VwTETQ3uH/1H2yPlVfA==
X-CSE-MsgGUID: 2yzbEcBvQNqQJC+KpNt28w==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="68234765"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="68234765"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:02:20 -0700
X-CSE-ConnectionGUID: A+KnDdm/QRim2sfEXe7Lnw==
X-CSE-MsgGUID: XCeMQYCeQwK8/7cOlsJzrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166353874"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:02:19 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:02:19 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:02:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.83)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:02:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aLPHAG9PdwShtmHab4R5Ggpvrq1Yu5R3RkuHLE3Ayvoh31SFqyjs5V8sHwshb5AUi8u72Nxg2og/gs5qJwAD4ENWSfc2pMrT5ZmPtGgKTIWvzEimDVq8To1+yMSLetSF2rL3M2PC5QWe1SQoGm41RJfc/xBB0XjXpYeSw4fJoCByHgCVv9pwyE7yRjEHn2m+PMdu0BBEgQhCOM7sWFkbxWMWf7pr3waBb0kPTHs7uX+SKBmACDW2aBxcr8yjXKgaaagmliXxdhOx9rJbvNDErDrYk0HP/7FX400bOC4hsZ5Qk7HvsiqnKLgFNRqv1e3AjcpAv01tWqZQUO/hnVdlJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqD8k9itMXliPQa2fN5s6nRpWicBU+3Q1dhsCA9/9DA=;
 b=TCVajEZcjwA2GaN5oEzvd2qnWblV2Kg0VTL+I5TFURk5EULcRcohxIhjn1VQh7oOlxFcI+RJOsfBfswiZLgU89uqbrn5I74AmrYCvE7XcQdH6Yw8eOmIqFM6hSwdcmTE2zPN3nFxMiqAeg3jeW9i0nBPJzXSE8Pi+I6Bf22ddi5T2tXGk0NLuONUOckrUxpf4ZeCnsP2jKrPGjQA2HBzHJsnw9xLEG7O5vOZC1hUOsfKLUzJ/6fp6UC+P5NtHDcnuuBlU0y/tCqMBo/rhrNTlMQxg+ypdtHTjobnD9NlyRazbAkK5XWCFmQZuNE/3Sb+rxAtahfDpkAR+T/3yfHGpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CH3PR11MB8211.namprd11.prod.outlook.com (2603:10b6:610:15f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 21:02:15 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::4e89:bb6b:bb46:4808]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::4e89:bb6b:bb46:4808%5]) with mapi id 15.20.9009.018; Thu, 14 Aug 2025
 21:02:15 +0000
Date: Thu, 14 Aug 2025 14:02:11 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Yi Zhang <yi.zhang@redhat.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Dave Jiang
	<dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v3] ndctl: fix user visible spelling errors
Message-ID: <aJ5O062g5KX-vVDL@aschofie-mobl2.lan>
References: <20250814100701.2056883-1-yi.zhang@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250814100701.2056883-1-yi.zhang@redhat.com>
X-ClientProxiedBy: SJ0PR13CA0095.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::10) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CH3PR11MB8211:EE_
X-MS-Office365-Filtering-Correlation-Id: e757fda1-f812-47b4-b91e-08dddb75d88f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+ltOGO/WaK+eie1xDx0oYkTt89OHJMux3fIuoy2JfF2A8eGqioPVjM5xeKYf?=
 =?us-ascii?Q?zsYfe9r6a2Cb5Bh0WawE77rqnvb9RrNa7SZB8Wallsj/hqLSAK0DKjrqrWSD?=
 =?us-ascii?Q?iL0vyuKBUpmKtwWx6eWmzL/KPj8lXCS+zs/yfjc37UKui2xmXjYnrIOGSpbq?=
 =?us-ascii?Q?PhZgaEGuUFmJNeiHkrBxHQTjGRIa9g3eANWE2Xy8YYhfSbz7hrI3fskIdZ8c?=
 =?us-ascii?Q?K6d83Rnc/NE6HSRe8mjuxdLsXVgsf0qqJdGTBe8sMPBDEdlC+73mSTipeAhZ?=
 =?us-ascii?Q?9VJLxANP0iFAKKrVPaIUCpHhQ/7v7eG+vO6CEfBnGdw80EtvJICfFI6Xx+q+?=
 =?us-ascii?Q?FSC16Ey3D4NWchgns57auyuGiQ0Q4Ra+bOlEjNwjV/bGT56ep6E9Sg6virQI?=
 =?us-ascii?Q?6LND/OcmtKZV/3Zd88enukRg0OCe2ijjsvEYj091IAqnUFCY26XxWFfciRB5?=
 =?us-ascii?Q?7MA+a9vaoBqCcnPYfEuRDZf0WT/97R9Nit08WDOumlV6rJBXqXjiokQtWfHc?=
 =?us-ascii?Q?ALS2mcHZE/1uegs1g933XrOisRe11TgPZK8Eqre7EMuquN7dwC0E9anJfn12?=
 =?us-ascii?Q?ifflQczcZal67Vrky5XrgKVl4XDOJoViu/p4294yveknXN40/GqGkOkjPrBY?=
 =?us-ascii?Q?bdEYOwLvIgozgwSCVW1tOSGr4ynd2YNLJW8E/oU61nZeqQapgCX2EvcSS2R1?=
 =?us-ascii?Q?xuR5hfK532SQ/3CuxQea0Cfrf/bcpyG5fIGM44Kuv7XpY3WaiVC+OzreJJit?=
 =?us-ascii?Q?g+hwFb14ZrU8dwkN6JJ5y1YO3LygpgyaUXKTj8MYjPJHZF6GITsn3vLTmnA/?=
 =?us-ascii?Q?YBonHXfmPn78Z4hqMRPWbOGq71p79wNVL9R639JR+C4Z61W/ewCKvM42CuCG?=
 =?us-ascii?Q?pS/4KptFEKr9zKbo2UHudt+0ExYce9wz1L1mt+0n/1GW20hU0Qupj3n8ktrz?=
 =?us-ascii?Q?zuTwlmAudW6SPe7ee8BPLm2unJUye2Dghxz9d6a6tii+vpl+fsPP2O5f/8F/?=
 =?us-ascii?Q?DqG012NrRwf9nsDVQICqekTRnCqlcCZkEJlu4iqzTAxjhs+PNrGQGYA8fmcK?=
 =?us-ascii?Q?RtsliyaXRLhOTDfCaKXd6tdktGWJPtq+lsaOC4bL0ilni7MusRhwiELuHeDu?=
 =?us-ascii?Q?6Nq+zcQe3299ACQcvV5ycLD38hafcGT0lLcVelVCi2AgycyU5J5Ftx80Ptol?=
 =?us-ascii?Q?XYe7sAr3i8wZTqMBRSvzIyIPQ/jpusFGqViFxbi6P8hP5Jeq6rM6/r1ap+AG?=
 =?us-ascii?Q?bPWV+/p0zDf47mlEHuXtDm7pkGQS0hEYojJiTtYsOqlq4PAcprJHNne9LeYJ?=
 =?us-ascii?Q?OOrr1gxUzIminXeOPwqccnwkmpEZdx1iBE7PdWxHBRMJyt/zUIQxyB5f6YQn?=
 =?us-ascii?Q?RQoJXhHFXOxldt0itJrfs9GcmSjh1mdy8HU6M5qdYiPPgzVx41rmU1g97N3H?=
 =?us-ascii?Q?rByKwfejhT8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/oyUAxZQdhXhb1g5w88HYB5ykHt8bxjnPMTMmMP/oPEGSaYcYDHV9Zninz49?=
 =?us-ascii?Q?RWSXHrysZKrKJi22/N4yxlM3If0JUIMWYNBFW3oeBqrtuUJOdU5EytR1ys9a?=
 =?us-ascii?Q?1vqnHhIQOumr7glugifa4+hX+5/TK4qpht+r8OLV/QEodvkF+9IkkA2E21xh?=
 =?us-ascii?Q?I1414gGIocCCAVet2lxFvLXD+1xyY/XbEuZmtxOUFzlaur501KWlJzLyShHR?=
 =?us-ascii?Q?uhTXlnOtrW0G/zjzrTKajK4NdOE51fR8L9hXqB6peDIazMeTeu4fGyDmZbxI?=
 =?us-ascii?Q?k67n2GLe8i1CoordW92fwfcB0T3x+W7Y3S0EIgyD3EMeWYMAaS/81euEyrQS?=
 =?us-ascii?Q?yCKMKteeIoDpS9IMxt0rs0D7+1RZ/xYRIwuIY418rtlZvjKbxZcLae+N8rSe?=
 =?us-ascii?Q?EfxUFy622nvctEUq19kT863qWUnUegWMptu0yfpnI900x0WkuYQomrV/zELk?=
 =?us-ascii?Q?Vn00yRz6AVfummVsv3a9VfHW+Ai/SDT/kmZ559ptg9Cva9Z1G2m+lKzMqD+Y?=
 =?us-ascii?Q?nX3ZhAZ6wBrXn5iquBnClqB+cfDHrWof9sber82z3OtYXUKfHzeVzzQlKr3u?=
 =?us-ascii?Q?YhU7WtEcJHJLj9HFcQwMSyFs7YChUM3OGa58IuIBJQQfRa5NfNhvG54Fy/1R?=
 =?us-ascii?Q?n1NLksy7S43r8obqCCY7wSRNxPXo7eyTpk62iZeth+gLK2pLP6lGYwTFT24p?=
 =?us-ascii?Q?PZH1h/wricdArP/gU5YwmemdAn9seDPkPDxOo/XS8Bj7DaNbPqyur2v6p1N6?=
 =?us-ascii?Q?yVx0026kJCUjfqevUd0RmXCrbejZ1BJsM0Ztp1wMmt4HyL5IyEpijr/wwlBE?=
 =?us-ascii?Q?2bYjivdzvIdW/F2IJdKisbA4tRQ+9VLTCkxRZUFQXJ9n3nUQHCC57iwCbpfg?=
 =?us-ascii?Q?UF/1ip/AG1poAFWnuQkAjLmSUPwSQX5sTPkuiniMTCXh81PaLwvUP7KI9KFU?=
 =?us-ascii?Q?G9EXd455xJATWh+hMkhMjYqsqONldGL9V1m3PobJt99o+oPtgEwRUits4Ns4?=
 =?us-ascii?Q?0OEplGdMOWhXBaBMZsbo5EyRRK2B0w28VrA0ByPqqoUBbB9CoX5J+/GsBKJj?=
 =?us-ascii?Q?FLnDnyka0RvEjesJtQ8u5AJQx0Xr8oAWHFDsa4joH4YpJuPVGt//HCFaw/Uw?=
 =?us-ascii?Q?XtUygzlcKVzEqdNLOK38zbNqLwPZm0LaaDMwanpQC7UxWMaOgcgHYJ9HqvOR?=
 =?us-ascii?Q?+4iDE183dhkskbCrAZfehrQSqMrpVNaGEE4rIIN28LDjQurDQ7+WDFkASBK7?=
 =?us-ascii?Q?5VpfhbUzuDwoqgJDI7E3vQ+G0f89KWbhxUbMANhUHUmmX+KB1X8fEJMfGh1b?=
 =?us-ascii?Q?BwDmREnIIwwAPt2G4S5Gjt0ISyRJpXkI0cCtqyRGbzN0d/IPR1oM74sw/55V?=
 =?us-ascii?Q?vhQOqItM1xE99fxf+1rU3DA5JNrQr58JMb5KgUdXzpJhZ2it86T06cz/2llx?=
 =?us-ascii?Q?dhjpaqf2/mU0C9CGkJ/61ijEJ41ipvmcWHwKZfrFERANjOZ7kLEmVX57xcWI?=
 =?us-ascii?Q?jkHhJkuVImFj7/iWSunCk3uvqRTA4DKQssMLkNAxERYd1BIIOkCmxKhYhgxV?=
 =?us-ascii?Q?VSBOVU1gFNYmIEhSid78Bw5q600sNGzQ3DxJJrdjK/q7ZoMvERsIa+jl5J/2?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e757fda1-f812-47b4-b91e-08dddb75d88f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:02:15.0888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nw8hcCn41dQK33Qq+neG53hLiu2CVEQS83IHjDd2g6vVvpZXt1yqXzImIzmfuqr5mWf1wFK3CEhgzlYQie5VdBwn32OWB6vAdOJaGrAFWRU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8211
X-OriginatorOrg: intel.com

On Thu, Aug 14, 2025 at 06:07:01AM -0400, Yi Zhang wrote:
> The spelling errors are from
> - log_err(), fprintf(), dbg() output messages
> - echo statemetns in test scripts
> - Documentation/*.txt files
> 
> Corrected user-visible spelling errors include:
> - identifer -> identifier (log_err in cxl/bus.c)
> - santize -> sanitize (fprintf in ndctl/dimm.c)
> - sucessfully -> successfully (dbg in ndctl/lib/ars.c, ndctl/lib/libndctl.c)
> - succeded -> succeeded (echo in test/daxctl-devices.sh)
> - Documentation fixes in 4 .txt files
> 
> All the spelling errors were identified by the codespell project:
> https://github.com/codespell-project/codespell
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Yi Zhang <yi.zhang@redhat.com>

Thanks!
Applied to https://github.com/pmem/ndctl/tree/pending


