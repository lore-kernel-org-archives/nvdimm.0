Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97291C6A4
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 23:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709766722; cv=fail; b=Oq+JS0BrCk89gLJuOH3EaQGA8lVDccOYkiE0AzJ05au5lRq+aRqJ1syjKx0pTIetszrf/pTvnC3e2XtyCSzR9CXyMw75XRql6hnGBPPPPmHiYCS1+f7zEKjotPcPUl93IztDv1l3HHhNm2KFn9VKj2PQG/mn3iNaOb7jFqD1Xlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709766722; c=relaxed/simple;
	bh=Y9exI4bTBLF24aX1ZfadZHsj6BQS5yaPYkah1JqN4j0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hjNvjdsdSF+rJCgz67quieHwF33YAO0OIhYp899KZOk8eMNdnYTtIHHl/lgRCKc7u43/gstwXEEzLpYwxOy7BwByvVeX1uPjV3JtqMypAKiT1926Cz+EeTRbrWGMswLnB60A8uIMo9v5POLY3DTo2j/jF0/LXuP8FL5pPRPssxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CpEIblYW; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CpEIblYW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709766721; x=1741302721;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Y9exI4bTBLF24aX1ZfadZHsj6BQS5yaPYkah1JqN4j0=;
  b=CpEIblYWn0KndPju/khNZGHl/+PesTuZh/X+b/utH9O79qrYq+9MaD1N
   3vzht3kX8YUb1cda2JWPFFR2ruTW5Je7RE9R3Fl2GhtBmF6BzkRSWoTWV
   UWgojoPwucjjA0lAXFZoSeEusYqGh5tt55iK2OuC0iAL5mClafHmEVnw9
   Lv85ZoD+bqDvJi8aynBzepXXeRyl4kkteazBx9p11Dd0+t1tWdxqvA2tf
   B/8ADQNH3Ox3l7zpwwgVFGRs66NZzawwJJm7aFGm7cvawQUU3dU5Y/oi2
   iJ5G78DRyrDT0fKJOgDsmDBwd5W/5J6qi6HXTGon/snQVGlBwQoNJqcLz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4278159"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="4278159"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 15:12:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9808945"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 15:12:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 15:11:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 15:11:59 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 15:11:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OtO98IJ+T1Zb0wlCdYRJBBMCL2bJcDADiMLwHm25BgJ+/MEqq1fCv0KaUdw/t9YLWA4RyK6FF30nNOZke0PHwxwutQqqihFtzNyAoDn6lBhUMECuI49W/WUWopMSyS7omYuyjFmvuDhZRgjDSBQf3xejlUUoQsZ1OSxit5XAOuxAZI49ltlMnMcica9gHZIxwqknIhPhYSLlszBvNQne6naEsg5rrE7AFXAxAU9/DB+CYRmqv7/ndjmz4/o1JrJljPXxbTe60t3bnB1y09ruZHuza6wCYMnE8eHUDqGvuhaYS4ttIJ0XRV85bDSfUPx0aWAx/y5qTfEMO01KVk9qtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOIjUZWl6axV1/WZxLhY9auO6Z5HSa+F1LKFUUTAzVA=;
 b=QXWraGTCZ44hlzn4SnqDzxS7x2K7uoFuRFvpg+slwH/cGGVdoPMZBRhD3i2rBieUI7VivKFoqJ3v45l9u+zZd3l4a+Ot0s5n/LEm9Wb7mp0GzVG+JnXrJ4x8HPORNeDiFvfzogkk8aPHJjwKShAaPAsFa6HsZddrY9aewHGW39GT4upZRCPsY8ls5WY6lF+XG7+iEV09lkNwoXAZxmgPMkpMJHJhyrvYVLur+uSRD2mxp/MYiZOYgdU6lD1iGDpCQrRRwHLYeWNxCbuyVFU3FllsxWvx5Pwqb0fubCgvQL7sWq5aVHMXyzMHOh6swf8paBbZgq8uDpHt7R8M7BD4JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB7491.namprd11.prod.outlook.com (2603:10b6:806:349::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Wed, 6 Mar
 2024 23:11:56 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 23:11:56 +0000
Date: Wed, 6 Mar 2024 15:11:54 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v10 2/7] cxl: add an optional pid check to event
 parsing
Message-ID: <65e8f83a18bb4_127132949@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1709748564.git.alison.schofield@intel.com>
 <abe5627e115a94054914030f3aee2aaf5c7c47ca.1709748564.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <abe5627e115a94054914030f3aee2aaf5c7c47ca.1709748564.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::35) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB7491:EE_
X-MS-Office365-Filtering-Correlation-Id: 56eb7532-404d-491b-47a4-08dc3e32d14c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gWbuuChSl2dA1grigiYZM+8hP3Mbtlave9C+0GV4i/tfze0B7g9mBS2igVPvcGihkCRj7WdAV1Dzn4w0VpEUfPLna2A518UA5iD+cjg3VDcginJXa0SvNorJmpEZkF1XRu3BlfCIyl2r7vRw2D+UxSYkusqlp5p1bqbxurIR8qd5bfEZRYoT1TXz+HAEVpqEalOEhOW9XGoYLb47tWq/ZB+ABD7xKE1T3hT051yDdCWItvJ7xQtStEfF83AScviOzTxA/md1mWqF8efGUkq8X0c4Wl3UDllOQ1whs3oe4Tw24GOrHm6chRiBNdbGsHGWCaf5I+iHg4Kc+0CqJDCEjXaZN8+mEmv6XVrnN/ETGsQPXZN5rYtN5E2YpTKymSrPwxrg8TNxCg78nJyovc12eqbqiVUCOxefP0CcBORKY6eHxbUkf9fTSf9YfcJ35BCEAlsTzwSnnScWmQJTw8JAtJISzlawMadHVfETAa3I309ncuwee1uwfiqUJ/6/BK2UtgaP0YpTnfFvpt6YV5tsNBrlnBP3zZBC6sxzCiVRx6xuMuQma/0Hk0wWbu3O0A+IYbMp75yqcU07m+GgAwkXWqyrSv9jJsvrMmWSa3dnUZYx4cCxZ9oj9qqGYwLvE2WiipRbb2PevnLz925/PPdd6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U7C8Gzvyta/mvRp8nxM6bVzVH8RAjQLKsZsFBx5PV6GM20ExAYOCy6fOPP0g?=
 =?us-ascii?Q?ixtuMPE9qL8JfOmshz3HtcGa/KemdQhifQiRxbJKIN5r4UXvONqrxitxnioY?=
 =?us-ascii?Q?WEy+e4GKCaM1L1X4clmPOMemeaIDYt+53vD+Q6JW36cfvRh9fVCDDOVXfcva?=
 =?us-ascii?Q?OnZ3HFhx5IjT3KOlwYNlF8SxCy5seqx9XYVwBFWupqTdyyf9dJx26qRuGnz0?=
 =?us-ascii?Q?xHcDpy4dPEhRAY8y5gRClPzr+xF65OxYXca9Q9tqhaVFYqFmKa13bzSNRzbT?=
 =?us-ascii?Q?VOfGWwBoQLsRTmgERaQmnlA1nlcwXRTtWInwxXdzx8ZynHM3rw20QIYbujs6?=
 =?us-ascii?Q?UWuChFv66diLV9dtsSjX1verObrkjt+kigafg1gT7/SnFczWbDbg7HDQJPj2?=
 =?us-ascii?Q?H0Os5ecyS6ZrOgK6g2KDtzEF15IXbW1u4sysZRkCLytS+Rj4JtToad+bhBlP?=
 =?us-ascii?Q?aGXD43CvrOkSHiY1WcI3RDDXpM5ZItOr/bJl9zerGsUFs/gNhwj8nh6HjIlC?=
 =?us-ascii?Q?SZ075stJUfxnptijHj7ZrMqRqM1zA7YCt3ONouiNGE0KQDVZOir0yOfM3XF3?=
 =?us-ascii?Q?7cIrkYhccWf7gRVTtNg5k6WMdbc44E22Ztr5J7A4dCRdD9c3qKsLSOKjQWQ+?=
 =?us-ascii?Q?M4pGyC4kL0M26EjhjGyT5xGgoVYtomi2e96lmwmyDkOK50qGiwyTKrolY2hT?=
 =?us-ascii?Q?4RKGieJocBW0/yLwD0ve6KpRsGfZBxrmlHLsJ1DcFxM74AJ0s9MiMqqTjY+N?=
 =?us-ascii?Q?EFPmoZEodMljWpS5lUCVHld1/jP2sfLsaAWAZC7AijiLPtlYjjRT4PY7Y3sf?=
 =?us-ascii?Q?lkb/gO4ash1BwLT5I586mZcCaQecRXZDb9Pc8S9P6jbhu2g8xNhdZRfOclEe?=
 =?us-ascii?Q?nRCI4Sw4KSwKvUEmn17FykuWUqiT65QY5waqvX9GglTp6tIA37im6KKMCu9O?=
 =?us-ascii?Q?HUFxYx4sq0j1s07532fdhY8RySe0xy4FSXA51Wbq2gNbGxNSmAtZmqR51zF0?=
 =?us-ascii?Q?D5sazpY5Wm3Je2swPqny2bYsHpRp2UcJzcyQs7RjCtzLtpolnexjNzo1BOPm?=
 =?us-ascii?Q?D+WGrF9aejfs0gsytNg1f/FLjIq//gQt35fE1DsSbcaE1vVUXBJeJaBY0ASF?=
 =?us-ascii?Q?zL/mPVdZobIHTrfRJSZ78pNKYCRYESbDIpzqQZcPqGN9UYZ+jQ2GgNW1q7Ag?=
 =?us-ascii?Q?HWSdd8U7O4OJEW2ATN/vR6D7uimz4ETnzZXFOnf4hkTFS5QA/s97r21MPkPU?=
 =?us-ascii?Q?YKTM2l5OpcuZv0j7f434dnikTe5dNLE0XnQQaix5F79XBgy+lacEC5IA2JIR?=
 =?us-ascii?Q?5y1FGmMBGj2+vLHo9qr5btnpaICXgwq1prk0sb78UrKxYmx60rOAarZtONaY?=
 =?us-ascii?Q?3GooKWt8i+uXj5EQbAbzWuPU2xeg+XXtwHjOWjONqKJ7n1+6DIOmZ/IyQm2v?=
 =?us-ascii?Q?jHU8Oe6jSKVspP5EaJrA+7l2Xcfa21smORysKwjR9uWPE/EXv28se8Etk93L?=
 =?us-ascii?Q?IBVaut4+M4BOeSlAqZRSAxM/31CNmllzwljlmd9eg2xJRB08+hLpWiV4MNDq?=
 =?us-ascii?Q?AJSKGelFb2hT6tupTYq7STJcQX4VG58EyNxTrrTw0GYhjR4kp+ldWjuD0Msk?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56eb7532-404d-491b-47a4-08dc3e32d14c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 23:11:56.1800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3DdTSHThc/EZZbu4GSGH7fvS2V6uTwd0Y6IRfu8BuEFCxXjyIgEtBz5z4d8K93KUaaNPP0ZbuYZOmFdOwVflE8GWayoWqzcDWWgDKmSSz3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7491
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> When parsing CXL events, callers may only be interested in events
> that originate from the current process. Introduce an optional
> argument to the event trace context: event_pid. When event_pid is
> present, simply skip the parsing of events without a matching pid.
> It is not a failure to see other, non matching events.
> 
> The initial use case for this is device poison listings where
> only the media-error records requested by this process are wanted.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
