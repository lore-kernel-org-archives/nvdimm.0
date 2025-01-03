Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4931C1F19
	for <nvdimm@lists.linux.dev>; Fri,  3 Jan 2025 22:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735945104; cv=fail; b=CBJ+9RWYW+vc2F2UywqNWZfn7sPaEzQTR4nPpQiJqnnV0eNYolOOnVvLDXefw8tokGP8n+J6CSLD9kE2bVwZqZ6ZflNe06PTkMlamvreyXx1vTJqmnuy8XeTOzHCiFgE9CqGeDBV0m6BKLofMDas/RjQVd0eMOO/hKfNqT9CU5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735945104; c=relaxed/simple;
	bh=rqkb4gVd7gbUqb9BFfAHGdbJoM8g0fdndx3sBKOgzu4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iOaafUpdKd+1wLnD0zuejkVRMiqxfndc6/HI6pW2vQDbSwDUHDYf1HQcl0S3o0uC9c6jPA5ulpilPCok+93ObhGS9Er63Ppiio+6xHcy2M1Uw7WZ2R5Pybi4BM1lziSS1Dq/S23j1gBAVq7kHPc1Ly5rooufliHrhfQUVrfyvbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fvQGJ2Ue; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fvQGJ2Ue"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735945102; x=1767481102;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rqkb4gVd7gbUqb9BFfAHGdbJoM8g0fdndx3sBKOgzu4=;
  b=fvQGJ2Uef4IC6GIJP44FePf61gJPVKHbJ48qiaNzNGYDWJAxv2L9FIHT
   mQHdYcsmOKRz7FyK1nOTj86EoDi0rZZbrNG/XXC/guMYMe7LtbC8F4+wo
   dryNszqcFnGrm1O7vUY44OvxoDdzO5slSAzCcgzhhxxl1HCaPOFmdzpG9
   Qz559ZsiJH6yqE9pO1c1vaNDP2VHIbEESHhZfkSBz3Lq6nzk7SkncKV2c
   N4nzX3xCJZHUrfEQk4sjTW6l+AwcwI+5+16Jl/9qcA30EWqmCT+zl4OSu
   38JPMdp9aCzLLhdjGCLshxIZ6aZN6VBjdQ2++8FTErLF8kXIloMUwEpra
   A==;
X-CSE-ConnectionGUID: 2ild6wPvQGW+mpj9EjnJLg==
X-CSE-MsgGUID: WBPt3XIgRsq0A5vMPtZm1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11304"; a="36068024"
X-IronPort-AV: E=Sophos;i="6.12,287,1728975600"; 
   d="scan'208";a="36068024"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 14:58:22 -0800
X-CSE-ConnectionGUID: uaf2taNNSc+m85EP6VFCTw==
X-CSE-MsgGUID: gVRkNr00ShGtUZZiLUdbZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,287,1728975600"; 
   d="scan'208";a="106858851"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2025 14:58:22 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 3 Jan 2025 14:58:21 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 3 Jan 2025 14:58:21 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 3 Jan 2025 14:58:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KVbe1zAd/zhoToV/cMNENbtlwHDMKgI3dn0Vo/aJCUjwH/D0J9tCYszO29/oJMCPqddjGjuIBvpvcwxW95WC57RPGoZ5EIPhtvQT03g6JohHkAsxUTzYN1ZxJNoLRevKwzqbB8bHH3JdZs7XYYOtJ5nX8A5ccUETPZQMdKzIUScdH9GYu5OtQoOiPhUfy79rc2NJpWSLTC0xFuOJNt6rUyf5CDj+ax8cJaIu0lJB7lcb0z/C0a63zXTq615hpH6YFhA5xigi/ACgEQ1sDQ+qbv1i6z39rLpBuxml91nbTl5zA91MyJeRgQpvk/8VcyvCDeQumLAXAu0xyHt6XsWlhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgL9WQ8oyVHpKpzaY5EIlKgsjOdaVmlSHa4DfubegGE=;
 b=LKPTdIdp6XCZ7uL+XI3JZPMK7urILi3iLy6wfMmVgOCBU/KEDtSv1iylgTZJl0O8gHku9c5S8BgR5deWUGo810UK1GwQJgsM32XCzjR8164eKd82Lj2N1zwwC2gkdqfG43Zeb+TJg6j6NyakkE8vcvOPlBkW2Hdh59q/DC1KCKhzZK1oysfbLYs1cX9sA4lLGXfbTDs5sYOkFGgobf9VlVZFjts9A1QwEY8gs1wc3s7SMGUlffDug320P3fsxbxfjMrOpXdKkjNqprX33UWQCCNs7+DLOQTEz2dMWeLPulWfFHEb+qYchazpBWSe1L8DRvJH7A2QXajm1zgK2Fymng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM6PR11MB4626.namprd11.prod.outlook.com (2603:10b6:5:2a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Fri, 3 Jan
 2025 22:58:01 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8293.000; Fri, 3 Jan 2025
 22:58:01 +0000
Date: Fri, 3 Jan 2025 14:57:58 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, Fan Ni
	<fan.ni@samsung.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v8 01/21] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
Message-ID: <67786b76a0c5_f58f294b1@dwillia2-xfh.jf.intel.com.notmuch>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
 <20241210-dcd-type2-upstream-v8-1-812852504400@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241210-dcd-type2-upstream-v8-1-812852504400@intel.com>
X-ClientProxiedBy: MW4PR04CA0070.namprd04.prod.outlook.com
 (2603:10b6:303:6b::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM6PR11MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: 334c159f-5f32-4e65-413f-08dd2c4a12a7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PBw5O1M8dPXbVsSJBA/4aAOI0Uegc7r5pRBKXRQNro/OhvPoQuVbZ4+M4Wyi?=
 =?us-ascii?Q?D1KDbJRylRdwq8O6i6XmHTedVMEj0U8ZVTyZnnjyHxRZ9VqDOJOejZEHKmhS?=
 =?us-ascii?Q?UleejxCbJl4dHxjTqI4RW1YZEK4iDyDFCOtPgYg3gthv4QjNlYzg8TyUhlZg?=
 =?us-ascii?Q?iHfBbQO/RqbapfItuFROJMGyMRWG4oair13gPRJe7nOyLp26ZTB9cn9F2Niy?=
 =?us-ascii?Q?XtqefyxktPC1sW/JfF5DtnkXk7RTDKm/iWoOdP/US+9Fl24l33Uym4iIa9Oc?=
 =?us-ascii?Q?BXw7arEYgqquMLmBNxGcT0Nl8Tz3Yl0z2f3hBlXrVDeNMOBt3Ffqzsvluzb4?=
 =?us-ascii?Q?PS8tbxz8WegFm2ykRaCkZFFA60FZ1S60q4b0e0UY8bnzCmVzouhLObmThbA+?=
 =?us-ascii?Q?iA8U3ERqI4xWPIzYRIH0FKPjCUquB4CUhPzdAROB6SbI/+739FL12w0EE2y4?=
 =?us-ascii?Q?UumuH8dmX3tH45qL3pqH2oQk2Mr++2n1IrzcnWMjSd50AXs20D+k+Gwo/jNp?=
 =?us-ascii?Q?bxSQ+VuYQ34PiI77gOxY/yqqzAfC271tp7W1GmTLonL1b0PJ9Vzong4swZNd?=
 =?us-ascii?Q?FwUInFpOqvQ5+/5NclSjpC7zhaZ1g5dL6nHy6sTSGwLK4jQlzxLwDYJQ4hRR?=
 =?us-ascii?Q?uiIEFaACQxHnbf+p53V1mAnXkT6RxM/4+Vqe573SUMS6cUehBab5UllVM+hW?=
 =?us-ascii?Q?5SnMlUbAMjCtUeHyxWiE95Cx5rCI8ikAPLoMH9HLuVVco4qKAmKMChAAM2SZ?=
 =?us-ascii?Q?PXQDsyh7uicY6tBRBg/6dkULACn8dwmfGdXJ6a9uvrrZc/6f6RBpbfgfucNJ?=
 =?us-ascii?Q?QvwwPeR8YVLHm6eYWbm5kIcwP20G/4fo2cSasJzxGwRk8ZIc8pFfkxDuvuHU?=
 =?us-ascii?Q?pbQMTU0Xi/e6QApjs5h3lrfnbK0NPmwxKh2kPaVcUO7bbwL5rmOgXTTVgaYS?=
 =?us-ascii?Q?Empo7nAmIAS2oJ3UNr9+rJO4aQ5GfRwKuOcZMofU7vIzFwgSx6lcbCZH+rWL?=
 =?us-ascii?Q?RkQ3DKnT3yoW5/DfweUxqkzi5EI5t+j/Y2yJQTVsleCRZG8CbcIfEILlpl4L?=
 =?us-ascii?Q?RtpqtYjp3EP3GkPR6U2ST5lACg/Pp52SPy0TdLHxJLn0hB/4Oxvy1093DT2o?=
 =?us-ascii?Q?0u0o1tPZyiG8xvg8ereQ2hcfssveBR5LXuyz67E/y6VCMqU9xOUD5sDq7Yik?=
 =?us-ascii?Q?GTJLYylT8Ep0MrDNTMk34CiwQFDqx7YDvPBhsqP9NSHskUR3cPoWYPZ6G8Sh?=
 =?us-ascii?Q?ucnN7K8m9QO/tr2FuIpS/5NJoXhqbbuAFmEwm7lU6rWhhix6QsYxkmwbD3XX?=
 =?us-ascii?Q?Kzx2iiJCDFG2MBuRwV9JNmVoGBJVecd2yB1okj4xmfk85LVdi+kjNyZcQfyF?=
 =?us-ascii?Q?rF+wBRKhSxVmADtJCcCG7ITYv2t3?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6d0hdRXI1Hj8FyQQfdoyd6Qu5QOGbvmBge70JkEPYHU/lxhvhBFw8y5uPP08?=
 =?us-ascii?Q?/L9yAGQXp2Sups8o0tq/jFMqoVAvJOjAjpUBafaY30XdULSdc8TpDaoSRLG9?=
 =?us-ascii?Q?lZ022n/bbW6YqWK0AxQYD+xBVrx7WbtIQ3r96ghvcnpj6Y2JBTfrLGczMNkT?=
 =?us-ascii?Q?O2h/e7AKQQxbH3xkFqzINgQvpQWDvrV9UKsTbPvCflJOL+BsGxvabL7NSh75?=
 =?us-ascii?Q?R5O1hR5hklyI8nBi9wTiRIzkt9f1j/+xIdiAcDc6ZTKB2GvPT6/h7MsF+w2J?=
 =?us-ascii?Q?46lEpwlKKmODR61hcTUNA/F63x/F7aGcLl9OjBUiPKfldxpy4nf8ETFOX0YK?=
 =?us-ascii?Q?Z0hPwQQJ4BuTuyNKYiQx8LK5skRsdnOWYhP1YlR0dV28nhJNrMJAo32R6W/b?=
 =?us-ascii?Q?Op2yRlchbywvdtX+jCF0NQq3wdYKkodf+xLNbQu+snuSaLyU/ZBEp3+ljFkT?=
 =?us-ascii?Q?AxofjX2HqqNbJKLs6DujH/ox2RuXsVlsQbGBIXVCaVVKU0WK2h0WJOS6SHn1?=
 =?us-ascii?Q?InwHn49yMRNxdQpIk0CIrilzNjehCdb4lr84A7oy6NPLlEhXAgGgM+HNxePC?=
 =?us-ascii?Q?ToX2woNO5gIoPOLscAGo+FscJur88Bsn0Oc7ogAcoQi8b2DTKeGqJQIZPHDX?=
 =?us-ascii?Q?H0y1c150UHw6y7h3xAOkw2yk5AkajjW6uPamZty9VNZ9l6U8kFTctnaLmwye?=
 =?us-ascii?Q?Kz41gB9cl0p5VREVryDfWzZ88TRWHP4g7HfUDQNC7CPxNs/OyLnOaHD0cZoL?=
 =?us-ascii?Q?v7oHwRJ0hesOtb479WB5yIeFPpyf0UuDdVZ/nlN9MsDeWG4MA/Qc8HG854V+?=
 =?us-ascii?Q?wKx7GXUhgvnlfECwWB6P0X2GDJEIzCzmaml21QvG9shkKfSU/6rOty8/jOqs?=
 =?us-ascii?Q?osMikf0u+j6nwHgX296k+QqLpat+w/5zZn/WltVDirFFsf1Cp80A9uOzrZQo?=
 =?us-ascii?Q?oAYXsIin0by0YNKyLKq7XRdyxAZ19QGVQ2wj5fgFdExViW+peWsAiMfeqPu3?=
 =?us-ascii?Q?rHsk6JzZRpMWrRwtZF4/GlcBgjj1rFsI3vDDcIwJ5uRAkVKlLUFbCL4H6ZCK?=
 =?us-ascii?Q?vqrwx6lZCa/XsKDbb3OSYu9e+MoM47LpxmVjb0DuPHok2G5OMMgs8z5L7RVN?=
 =?us-ascii?Q?oMGzGy+5O+FztdoB4pxyNazXMHykmE5u0BlKQw9aJfFYWYvWtQGR58o9yqH2?=
 =?us-ascii?Q?22VUYZQtsMXpv1L070nwj/zZ07DtVU4mjkEH2BATVs9j+FjI3hrkTXKVJFXH?=
 =?us-ascii?Q?daXcAER1hYyZRsGKx1y1zeUhpStBY+C8unOoDrXO7rrY1MhWm3qwREgdsaB9?=
 =?us-ascii?Q?U2wt5a5gGeKWtZnf12uruI0po2uQF3N/4HAOKcvo3PvKlCIXARqP4DDs4Xfn?=
 =?us-ascii?Q?n24YGmCNa+yqcpcfg7B4nUS5PG3ZLVAsHFBFVF65OCbs6nMRpg9iwlNFmA7U?=
 =?us-ascii?Q?Qqb9cDxNqJ2KlporWs59K1vkYivbrpjTMhcQa06mLJik0xw6VoiXw6bAcIlk?=
 =?us-ascii?Q?8N7B9vpvDCU5mL1kp6XxFf771wh1IzJpTbBpC53OnRdioM/R30mk9OxUY00A?=
 =?us-ascii?Q?MnW3KZIjFDOQVAFjLZMrEgos9yK0jQbNHOKG6vVrsCwUfJDtZP+3pg9OorVi?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 334c159f-5f32-4e65-413f-08dd2c4a12a7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 22:58:01.0570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAkTTjS4ceZD1pNlOGYWAFciaUQAgm3TxPhK1BcJfeCZvwsIZcHi81jZxTy8PESg9x9IkhfVJocf1Gsiy6upJUJQP3LhiT8qBXPD+Yc5qfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4626
X-OriginatorOrg: intel.com

Ira Weiny wrote:
> Per the CXL 3.1 specification software must check the Command Effects
> Log (CEL) for dynamic capacity command support.
> 
> Detect support for the DCD commands while reading the CEL, including:
> 
> 	Get DC Config
> 	Get DC Extent List
> 	Add DC Response
> 	Release DC
> 
> Based on an original patch by Navneet Singh.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Fan Ni <fan.ni@samsung.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> Reviewed-by: Li Ming <ming.li@zohomail.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  drivers/cxl/core/mbox.c | 33 +++++++++++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h    | 15 +++++++++++++++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 548564c770c02c0a4571a00ae3f6de8f63183183..599934d066518341eb6ea9fc3319cd7098cbc2f3 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -164,6 +164,34 @@ static void cxl_set_security_cmd_enabled(struct cxl_security_state *security,
>  	}
>  }
>  
> +static bool cxl_is_dcd_command(u16 opcode)
> +{
> +#define CXL_MBOX_OP_DCD_CMDS 0x48
> +
> +	return (opcode >> 8) == CXL_MBOX_OP_DCD_CMDS;
> +}
> +
> +static void cxl_set_dcd_cmd_enabled(struct cxl_memdev_state *mds,
> +				    u16 opcode)
> +{
> +	switch (opcode) {
> +	case CXL_MBOX_OP_GET_DC_CONFIG:
> +		set_bit(CXL_DCD_ENABLED_GET_CONFIG, mds->dcd_cmds);
> +		break;
> +	case CXL_MBOX_OP_GET_DC_EXTENT_LIST:
> +		set_bit(CXL_DCD_ENABLED_GET_EXTENT_LIST, mds->dcd_cmds);
> +		break;
> +	case CXL_MBOX_OP_ADD_DC_RESPONSE:
> +		set_bit(CXL_DCD_ENABLED_ADD_RESPONSE, mds->dcd_cmds);
> +		break;
> +	case CXL_MBOX_OP_RELEASE_DC:
> +		set_bit(CXL_DCD_ENABLED_RELEASE, mds->dcd_cmds);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>  static bool cxl_is_poison_command(u16 opcode)
>  {
>  #define CXL_MBOX_OP_POISON_CMDS 0x43
> @@ -751,6 +779,11 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
>  			enabled++;
>  		}
>  
> +		if (cxl_is_dcd_command(opcode)) {
> +			cxl_set_dcd_cmd_enabled(mds, opcode);
> +			enabled++;
> +		}
> +
>  		dev_dbg(dev, "Opcode 0x%04x %s\n", opcode,
>  			enabled ? "enabled" : "unsupported by driver");
>  	}
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 2a25d1957ddb9772b8d4dca92534ba76a909f8b3..e8907c403edbd83c8a36b8d013c6bc3391207ee6 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -239,6 +239,15 @@ struct cxl_event_state {
>  	struct mutex log_lock;
>  };
>  
> +/* Device enabled DCD commands */
> +enum dcd_cmd_enabled_bits {
> +	CXL_DCD_ENABLED_GET_CONFIG,
> +	CXL_DCD_ENABLED_GET_EXTENT_LIST,
> +	CXL_DCD_ENABLED_ADD_RESPONSE,
> +	CXL_DCD_ENABLED_RELEASE,
> +	CXL_DCD_ENABLED_MAX
> +};
> +
>  /* Device enabled poison commands */
>  enum poison_cmd_enabled_bits {
>  	CXL_POISON_ENABLED_LIST,
> @@ -461,6 +470,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>   * @lsa_size: Size of Label Storage Area
>   *                (CXL 2.0 8.2.9.5.1.1 Identify Memory Device)
>   * @firmware_version: Firmware version for the memory device.
> + * @dcd_cmds: List of DCD commands implemented by memory device
>   * @enabled_cmds: Hardware commands found enabled in CEL.
>   * @exclusive_cmds: Commands that are kernel-internal only
>   * @total_bytes: sum of all possible capacities
> @@ -485,6 +495,7 @@ struct cxl_memdev_state {
>  	struct cxl_dev_state cxlds;
>  	size_t lsa_size;
>  	char firmware_version[0x10];
> +	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX);

Can you clarify why cxl_memdev_state needs this bitmap? In the case of
'security' and 'poison' functionality there is a subset of functionality
that can be enabled if some of the commands are missing. Like poison
listing is still possible even if poison injection is missing. In the
case of DCD it is all or nothing.

In short, I do not think the cxl_memdev_state object needs to track
anything more than a single "DCD capable" flag, and cxl_walk_cel() can
check for all commands locally without carrying that bitmap around
indefinitely.

Something simple like:

cxl_walk_cel()
    for (...) {
      if (cxl_is_dcd_command()
        set_bit(opcode & 0xf, &dcd_commands);
    }
    if (dcd_commands == 0xf)
        mds->dcd_enabled = true;
    else if (dcd_commands)
        dev_dbg(...)

...otherwise it begs the question why the driver would care about
anything other than "all" dcd commands?
