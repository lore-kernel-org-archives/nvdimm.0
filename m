Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD9C2036E8
	for <nvdimm@lists.linux.dev>; Wed, 12 Feb 2025 22:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739397848; cv=fail; b=CwTTBHJocXhPB37GTZvXlqi31dcI0Mj/GcOm6bDkhenVe7auc9UX5nI8Uz7Ac/HMLP7TSS6u4qC3D2kuVs9uoX8pIcDFCYYsAvX2Rfdh/kzRJHYq97BkC4GssyL4FdPRkU+nEDqanWF9QQ5HaNn7TBJz+BpXRIzMLtRInv/M2fg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739397848; c=relaxed/simple;
	bh=r2z+QO703UZm3zc8mZzFyUArXd1OfBhialLp5tmAakI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ji4giYiQOAFThkblMiAk50WBspfRu+xAF9r8+2SBenrIxgblfzSrQuTy4kh6KErWnrgBs3TVm9j1zDvJTSTouwSBWpaxmvyw8rRcyqH0AFgF6ehOruDG5PTUb7UwRf/KSwxWMkXR2ZrVMCJsTTCS2c++k+t80uIUSqGgwXDoo+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ez+PVxhP; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ez+PVxhP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739397847; x=1770933847;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=r2z+QO703UZm3zc8mZzFyUArXd1OfBhialLp5tmAakI=;
  b=ez+PVxhP+RPx4pl5EPtleAcAFG8nK/yiz/Uqa0kgrQWhrzcJCipsRU/v
   RQgTYjP53TuX4qPzJ3sthuMEIHlrQNt3NZC3ksw1jbZ0Zpxo64JXgNOp8
   eIj4bN71lMPcDU7T0Z4fW4O3uE4OvPvfK/qEJ2QnON4B5iUIsMZ0Uk/41
   6+4myFUrcOYB8sqRdYnI4fuoGmHJLVLK7zUsxsfGJcpv9DyuiWHeFke6F
   3JT+0HNtGrDdl2xZctgZALW0YdvJ5Ci5rDR0ZrrEO54GOXRmhlRiigoT0
   uuSb2WezPpimB4+fSn0Mi2/veAl6nCCaTr8wv0M7H7Eiiu3qRNKGrtrgr
   Q==;
X-CSE-ConnectionGUID: xYlCJ080T4GHWodxMr0Jtw==
X-CSE-MsgGUID: gHp9eNgOSF6bHJMkiuxxMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="39942087"
X-IronPort-AV: E=Sophos;i="6.13,281,1732608000"; 
   d="scan'208";a="39942087"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 14:04:06 -0800
X-CSE-ConnectionGUID: Tc5Lg1ziRE+eCJ026VHqCA==
X-CSE-MsgGUID: ZoODXPL1S4iiqqmJ07jppA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,281,1732608000"; 
   d="scan'208";a="112919909"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 14:04:06 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 12 Feb 2025 14:04:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 12 Feb 2025 14:04:05 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 12 Feb 2025 14:04:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S6fgI+g/vxgtBN43DCDT4oVa2JcTjwiiXfQhvkhlFW4ksBJ5zb/oyN7lK1/lseTveIH8tBVeMcg24Bi+a1dbLmR2IncsuXmbka2K5gXiDjtD6hpMbeYfrb4BhePGCaxawjqK6RsK0mKw+cj+/28CxPpQBCpjtoy2b1Dt2tCZfwKRy77tN8LxbloTaOoNUSWnPgMAJmo5GodRPObsVJSvV6/7jozOjmC8eRAN0hfFgUgUTS2lcbZKZCILdPJCWRH8clcl3TUmhgfxnvbtr7+h/GARObBPHweDAA6M0f6PFrwnHmxlzPG+ynKt4zuvfZLph3DQP7mQtzKpiZtvQ0nABw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkXaC4b4ASU+IaqmvR9NXgfQOwOJ1ipNT+TJUO/dfaA=;
 b=L3wbI24p3DQ2i2H4Ip0JyGssFSPZCjJOJd56BVX954Bc9upWvZO/sMHScBskmhEqxejGsMaKhbT9zfiPVwOw5uzVQE794q21Wc8F4bARsyYHuyvPh0Eqtv5p8mRIIQf/8qKb5LOdE8kZDMqlb6gCaTy9my9BvVN8lMEjMfr1bTa6odoQIb8OzXXThHYdddg0BUFls8+U/E8HmS0XdO2Z6cnb1ALaFBeRUX5qteqO5t0XJhPnGwEV50Jp6jPBo5atJSLEn577vEBAxqJbl2n5wAk18xlbLkeWAzbFU0hEIBkyqvHvYpgUXxPsDVztUbUwmnVKziZxq/2cMQSzqIa8Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MW3PR11MB4713.namprd11.prod.outlook.com (2603:10b6:303:2f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.16; Wed, 12 Feb
 2025 22:04:01 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8445.013; Wed, 12 Feb 2025
 22:04:01 +0000
Date: Wed, 12 Feb 2025 16:03:49 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>, Sushant1 Kumar
	<sushant1.kumar@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v4 8/9] cxl/region: Add extent output to region
 query
Message-ID: <67ad1ac5819c_4ddb62942a@iweiny-mobl.notmuch>
References: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
 <20241214-dcd-region2-v4-8-36550a97f8e2@intel.com>
 <Z6rDC2QtGgVh-jrU@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z6rDC2QtGgVh-jrU@aschofie-mobl2.lan>
X-ClientProxiedBy: MW4PR03CA0314.namprd03.prod.outlook.com
 (2603:10b6:303:dd::19) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MW3PR11MB4713:EE_
X-MS-Office365-Filtering-Correlation-Id: 127beff2-f538-496c-9bcb-08dd4bb1280e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+QZrIZtIn8jNTkq1qNVcqsFzjnvn3kkiqEDpTGvFp3qmSZeaGDyetqLJVO32?=
 =?us-ascii?Q?vM699xo5OjCaZfxHnHD0L+h8QCwCbFXtdkHUiOLMj1l7pGm/V5PfcLNdVbWi?=
 =?us-ascii?Q?IvifRvhMN0n9i+FOKdVT+VRhdcNb9JJx1hTtUYBokWosurGI57akKmEmdU3H?=
 =?us-ascii?Q?pwjnebJ8ABDBcA6ZDB2EuVetTuXAmvFrmOtIohpaEw6RUU+Ngg/R4BN6t0Su?=
 =?us-ascii?Q?nogHnx/tt8YpaGHEFnYXUoj+r1jlGVWxzQXsFtIAueNxupPzUXFv03EOFEzM?=
 =?us-ascii?Q?0Y/1EKfOkvmljJi5BMgcSX3VGpWd2gMHjvVyLWKQBN1pyeUAL47Fz/mohNsU?=
 =?us-ascii?Q?NNWo0OS6LuUQZh0/UvuzxMcS6czkulqZWQudc7Su+A/D8ocJE8wVFY4tfU1e?=
 =?us-ascii?Q?qg4nmprH3fRRFoplsHveUWyZACW8TFnCE25hNn/1iGePO708ZR4Eq7CbZ2me?=
 =?us-ascii?Q?tzA9KaK8HkjkCfFRWE/nEpTgnmXYABMUugayA/WMGdBY4jcBRKdoofY04BNx?=
 =?us-ascii?Q?rJE7ZqNevfevNIWepWe7bSbSyjGLu3KHQlUypmDvEpU9AV8eqjfVK/6cxKh6?=
 =?us-ascii?Q?zQOsnIUd7TfX4iyRDWyHozJcTGb9BcW35sooaMpcVLfSZv9XSWWkFiM/g43D?=
 =?us-ascii?Q?GHAf0yOnK/TQ7I/yNfbvBIG/OxU8WlFmO2LBQ0NJ4rtaKZ/43I+R5XSa4gUp?=
 =?us-ascii?Q?R3FqY3yJffjWqJYKLEuoJKw+NmsW8KpwWMcWhioxZrOy8os1z7ZnNgDqZ8kA?=
 =?us-ascii?Q?0wrw+EWm2dWjWEObLtQBoeYpxrmnnTFfA/b+3cRo98xTQJOUdstvN9YVjPYC?=
 =?us-ascii?Q?aBfjPMnKd+7FzxXLWzaAZQVHoGymSyDRKx8Vsex9vft2yL4wcjNYQ5lxrJBe?=
 =?us-ascii?Q?KHBSef8v7ly6hs2muGCPPRUsQHIEmJ17QmfgC56DKDISMnFKW32FtsEbsWrh?=
 =?us-ascii?Q?ufzceYn5+9b21liKq8qAugrJ2JYsMsLBf5zKb6xR+DUM9zsZbfrO/6ag8Ewd?=
 =?us-ascii?Q?hVtRDayvDgSb4YcDRM1xCRpLf3aPSVr7dihzII7NHNSoTFHKMYfqltZ0fr0e?=
 =?us-ascii?Q?yEIJOsUMilQwSRDRthUIHuhNMFeEbCa4ucBnGsxJyTS6UG3LzFimvOkf1pVE?=
 =?us-ascii?Q?pg231jLGoGUHqZn1y4SDb4m+0qjqhQw2iFXyiPjACuInx6SoOM4rhCPr4hIw?=
 =?us-ascii?Q?+ZdMj53Vu70D2KSypOkPM6PIW0N9cvsDfKNXJ5JGjl2eNobocIzd9hr6dcjl?=
 =?us-ascii?Q?mMHHHehvfGPXPRbOTi/KHYuwXHrFGnaShDDpzcNIgEjxVEksGdhaXgGcdADE?=
 =?us-ascii?Q?X0DFuWI6goYTz1poJdxGM0ExzNFNQ7icxhYyqJ/KbFQA7qc40WWZvIjga4Q8?=
 =?us-ascii?Q?OrwQOoCIr+L+a/C8Atdssr02ku8X?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ftHK9zZ7rV6HJjD1BY8aAmaCR/j9y7yj9t/8EFsob5j2oCXZsL4cNyz8dq8A?=
 =?us-ascii?Q?yAfANOYd9oIXEcEcn4EyeKTC5neZyv6alAxEhrtuiAl2tBuswPOH3jkw86n1?=
 =?us-ascii?Q?c1nvGkfGHAh1vi9pn+N7mBH09THSHTO0dgScSTYtzW+jMRw1jowK1yEeBZLR?=
 =?us-ascii?Q?abvn/dXKls+Ip/6TLRjFIX90ONd7dd4RoDNQD5cY4zu0bklrbAnfxZOvT3hY?=
 =?us-ascii?Q?PSf0rOxHT0kua41pytS1rwdM6CqQXlCDEAYp82G2uGiAERSY+LAqemeFBHqv?=
 =?us-ascii?Q?jVm2kn7q949gK/xh8nJz1LUbyc69UU/Dks6ohZvK5Qua/byg+rIfqJMrCS/L?=
 =?us-ascii?Q?SWqISIHwtW0zIgUcGVhrby2dv19N1YftvD5I/2ok7ZVRpEwcfSJZ45iFH7i7?=
 =?us-ascii?Q?5H+ryqL6aqS1aCXMURTRjiTCRvd54YQHTc+9QMZXBCwbQO8fCPvQJexJTzJy?=
 =?us-ascii?Q?G1VYcVAJ2d17G8rX0d0f1krWU9cyWAKyZeauAqFF1XzKjvXHnxBVDxwMYJzX?=
 =?us-ascii?Q?/gHKLPhYBSeDLdBwngzjDmDxWKWBmjdt1KPbLcc1fhex+K0zmnrRG+xxvKTk?=
 =?us-ascii?Q?gMLypUd+sBRmRxInybXLCC1OsFipLdu0Blkn0DpYBtsGNu+SOdp0UJhLlCoF?=
 =?us-ascii?Q?sshAbRinBVzrNp8Q1XxDQvE0miNCtudgnExROFsSZECjz18Ds3dCdULR4u/7?=
 =?us-ascii?Q?GrIPN4dlqpWrVjHBMzi2mUJsYoVEr701WoetR5qobAlY/Vz0berF36slxObi?=
 =?us-ascii?Q?DNq5oIB+qBfla0TIG+QEdrwqed5bNgWdqEZBMgk0WKursBaGEFUYW2sYhKUt?=
 =?us-ascii?Q?bYGEnWQHHXfV3kSNTQu9n/6EiV/s2OEriexwuH8IcEiQgawHaqWWwuJg9Rqu?=
 =?us-ascii?Q?wUEAivYwKP+yRBcm+Ypb2eRJg4q/Q+Z6FLM50yKgVrPsYVAsKGfwIv2t2ME8?=
 =?us-ascii?Q?NJDgudjCUtTutm13/+Qt8eIiAJvGP3zev3ALY8HX15lYI47xlxWrak2p+zqh?=
 =?us-ascii?Q?qjnMOvbaqhdYKBY4VE/VWJDadDMHqvPaLesyWxLuyP15BEIBrwcOdTdtZsJp?=
 =?us-ascii?Q?lnp1vJmssl3Q/S/PX9wg4+FATRY7SLHk0eCzeq8YCvlgkB5dTeKjEtmWZqXn?=
 =?us-ascii?Q?bvGBzDhzyS4l/F56tPeZoksSyif8hfCPWeZY982UuxNRPPXr/ZmePp+SnpIQ?=
 =?us-ascii?Q?RwWDp0VvgdFeq+zpPQ048D0oC8K6UOd6FhKyQ9y24mhQhlbyLlCV9lAicxIV?=
 =?us-ascii?Q?0dMMYARa/35+Sex9QN/MzyAbto349DBttdq5ftIoLoTsYfhU6qHt3PFEgWrk?=
 =?us-ascii?Q?CJvqsfYFv19VOtjHZ6DSEERJc2wnvd2QLeXuFHEp+8qWSiONOtU/bC5E0xWa?=
 =?us-ascii?Q?4rWwn+Nflf8JqtAl7uoP65ayhCgpzjXhikXhKL5uqBl1S6SfzYYauLVSShn+?=
 =?us-ascii?Q?CY7r/H7HPkXzw9wS10cCTpqhIOGJ/9hWE8utNoNMOGcNWSQLIUJUjYKY5ibz?=
 =?us-ascii?Q?T0WwX+C43xPnjHTIY8OJF8PAyvTGVNyVnWl0r+Ylc84xZnglA+XuJicynQj2?=
 =?us-ascii?Q?uScaM1Nz1DqsGnlLUPyJZx2Rds3NJ/MM5EOQ3F9C?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 127beff2-f538-496c-9bcb-08dd4bb1280e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 22:04:01.2650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m3bnnO0SytISSS7UBrHIHNWijPBJes04Vdu3hOlTK3ZZDaAgFE3r8CVZ0EpFBEPygLLDvOQ7oPzxgqkOc3LmGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4713
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Sat, Dec 14, 2024 at 08:58:35PM -0600, Ira Weiny wrote:
> > DCD regions have 0 or more extents.  The ability to list those and their
> > properties is useful to end users.
> > 
> > Add an option for extent output to region queries.  An example of this
> > is:
> > 
> > 	$ ./build/cxl/cxl list -r 8 -Nu
> > 	{
> > 	  "region":"region8",
> > 	  ...
> > 	  "type":"dc",
> > 	  ...
> > 	  "extents":[
> > 	    {
> > 	      "offset":"0x10000000",
> > 	      "length":"64.00 MiB (67.11 MB)",
> > 	      "tag":"00000000-0000-0000-0000-000000000000"
> 
> Why do we call these 'tag' and not uid?

Because that is what they were called in the spec.  But Linux has decided
they will all be uuids so.  yea this should change.

> We use the uid helpers on them so I know they share the format.

Yep.  I just omitted changing the label on the output.

Beyond this I think if we are going this way it is best to purge the
kernel of such language as well.  So I went and did that too.

Ira

[snip]
