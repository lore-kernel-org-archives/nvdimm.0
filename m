Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35160136678
	for <nvdimm@lists.linux.dev>; Thu, 25 Jan 2024 21:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706217394; cv=fail; b=oV9OdPIWyw8suvbx5sxNu52ozv0TqlM80h6cq15U+B9JghXtVt9KEp6e5fEnTUTKtw8hTVfkx8YellMQh/dSKA25demExHwEtqFYnrxE8E7o9pRsYLe0EHHHmacufPfgmnHeJImZtfSn9ZWuaxCNjOX95986gq4PP3HLomvtFvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706217394; c=relaxed/simple;
	bh=XfHqe23xGX/GpsHjyp/ylwwRd21TBooxMUHdkls8Ujk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SJmd7uAXgTR3E2AD1rA3zY3NTyJXoVqllEmLF55tujzY3pRQi52kr6S1KFzs+QuDZ+D2cmoLDacMcwspYd25Ze+jNCoYSLMZteHbmyw8RqJz2SA6Wm1Y8vIh74wtO/q4Q4b2WP9xLBYNigejfXlJzoduC/936WYQbYa7+xOwlUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JslzicBs; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JslzicBs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706217393; x=1737753393;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XfHqe23xGX/GpsHjyp/ylwwRd21TBooxMUHdkls8Ujk=;
  b=JslzicBsdz3tgvnxHzzsY1LYAXD2dOgr2UEME8XjcHhBViYkRcLEUM2A
   UltiGvrokPUccKHiWcEH4wxSa1SwFkt2kjMvg67rtthH2FItwcAOQZDjf
   FjtWJrlMBsbpVqikwBHp5bK0Q6mTMo17REVFGhuWFdMb7UgTJ0LZYkTj1
   jt9jUJc1pedRuOPaVnvmEQ7KsMQYL3/w2TiTnpBQmelqAZilY96dWDJMq
   KTU02wS2np0KsHQav46LVEUnkwFpL92MsjrP4iZ5R7pp817G3Uv93ezc1
   nvK6rZQ+qiFlw8Jb6ty37b/wmWjm1Wm8ujdueRrR2rOo64vUAv67X7Ubv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="2190532"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2190532"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 13:16:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2385022"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 13:16:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 13:16:30 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 13:16:27 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 13:16:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enih2eccD8S7m0KKZW9FI4nJCPGxPyK97e/5kRUqCRRIqPK6rF6PFIKz62iO7Xlk+4XYQA5BmNdb4wHZo6LB7+fJpSSLTW0tZwinUEtSIu4WFVOvLS6x1SInzjS88Cksr1PiYsgaKJfbtbGpI+arWc+W20R3e261ET7kE2TAH8UaWDTSBaa6EabV1djOmND2v2k88fIu40Po7XWmrJSqE54e6ESkUcXluRS4KC071YaoXRTDO26LHMcnAu2RCU97xc2NalkJAj+kF5zA6yq3GMyiaMjTvFJ2aaw/UVIcWO9vqdWM7XhXUhC4eHaBzlzAubaeHYB5zvgVMONVebw/tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtpdzG3lhymLbXZ9sKD9b1pa9JYDjmD8SNsF0zFzsg4=;
 b=X64kqwnDsd7izKxlrPmayEriNaq6L2vxhKSRq8utTuAWkqr0ttJyeU8ddhJZd38px08J9ocg6hqJ4FOJDC8yrMImNCkkV5MmXCESUlb2pxtv82xN4j1Y+O0Unos1pVbCwuhcKY+0yVacKhiGNGYxCnP6PWBwr22Z8VR9P8B8zVBLW09b9Nr/Gp/3VgPg9orGniKqe25u8lPk48nrk+V1GKTJA5mvZ3QlEu8ScsGv7TxeYsYGhWyjwbDMTxhGxP9xnvAqW2T6dtgXPLFZmzMhdJp5Bo977c4pMHToyuGW/RpLke9VX8FtBBztaItlQvwnFQWc/byVNnMqjiYl73f5hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB6653.namprd11.prod.outlook.com (2603:10b6:806:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Thu, 25 Jan
 2024 21:16:24 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7202.035; Thu, 25 Jan 2024
 21:16:24 +0000
Date: Thu, 25 Jan 2024 13:16:21 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <vishal.l.verma@intel.com>
Subject: RE: [NDCTL PATCH v3 0/3] ndctl: Add support of qos_class for CXL CLI
Message-ID: <65b2cfa5d3541_37ad2947b@dwillia2-xfh.jf.intel.com.notmuch>
References: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
X-ClientProxiedBy: MW3PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:303:2a::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB6653:EE_
X-MS-Office365-Filtering-Correlation-Id: 90ddc620-36de-423d-16b9-08dc1deae270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BDIeq19e02lSCF+u2eQ0qHWi84Fugc2VLMI2O4FSMuLUjNScxX8uZqTwCBhXaw6ehCvHMMIeYbQI8Ay3qmiFKfrAcM3Nkosdh0KVfMthF3t4pKzrY+YrtC8nc2og6R84t1KBl2xynjMzG8HiKeN7Js+URL2jZrh4xeGDGwg31nhOkXksP+WVl7Us5vMyeKf8BX0ac92dx/Tx2XccMWPXssHgdTW8WSb//AH6RHvb1NQ1mzygjcHDLG3EhA94sDbDPAjBvN4U+H0jY0/tQmP0cNhQWkEdRrNv8D7er+slKpsZNSINezhm23bnOb2UhujBDyVT7XvvV1KWcz7GApJXcKJztzYf+XD66d+b5jC784aFOYr3OSVTxcGaGURScwJwUWHlRtyQ+zWwd39U/KANnsZY+Oomm/6rDTwJpo18LEI3wsQaRV98naGnAEmwq2tWXCA+joSqEElfD5ryEai0IkeFgM26oREKSs0vuNGG2JliI1iEKiAtQKRLYzRyEa+m66+OUFvXOciDJM4JFxII1C2BdDeuBOJyJxt5Tp13wLUHasQCfx58KOt1Wx6ItVp4QcrujinarwAWzdx3eiOdXVogTmAUZ6JuYkl6k4t32HKXx/IvW4ZwE8wh5kp1WOMp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(346002)(376002)(396003)(230273577357003)(230922051799003)(230173577357003)(186009)(64100799003)(451199024)(1800799012)(86362001)(6512007)(6666004)(107886003)(9686003)(26005)(5660300002)(6506007)(38100700002)(82960400001)(8936002)(83380400001)(4326008)(41300700001)(2906002)(316002)(66476007)(66556008)(6486002)(8676002)(478600001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8PxcJ+f2jESrNsxluo56H0nRlFOFhjxBsJpOHdLYpL6cBa/xLF4XFCXm7dSp?=
 =?us-ascii?Q?a/cjMrD2xPww7oRGx631BY+UUaDYMQ2SFiH8kqzIIqLmyxXXWOLSbyn4xON1?=
 =?us-ascii?Q?o6sQyuewlCwWsMLJob7zuWmx8qvWNmbXjkm1Mhk8IPNBCorr5tlooqyBKhda?=
 =?us-ascii?Q?oMuV++HO4sQhVIJvGiEFzHeI7GCjnZ1vpZmLQKcTD/VAjjRwt5U8xMcbMR9H?=
 =?us-ascii?Q?Aw84CO5IxBvrQhxpSSnf769vdgWQIYkQQD4IrENuhmHeQIS9pMisSvyidt7b?=
 =?us-ascii?Q?pM4FAZG+jil1kewlNldajsqkxQqWwvQbru/1ADMq4lZ47/wj6lZsWxP6WLQS?=
 =?us-ascii?Q?VZXFkpEApbp561N+ZLDa330nleuK8S4P3uQGZUfM0y9CcVPdSpixFh3M9KMl?=
 =?us-ascii?Q?2ZHj4gpc3W+dIij4wmLSUzsNUy2jjE0+KeYIfbbfA+AlmakhsxpmG7Kp3LFn?=
 =?us-ascii?Q?vtq3BEpgWSC2eBBnHSXe+4mPMHgBrLIWTrVGtUkfQyTwH6YgtRYGkIR+X6Bk?=
 =?us-ascii?Q?wV3BE9o+bfzR8heE1HHVFNmxwK52s1X3QNL7BCSz+tNi9gEo5kUwdBaIk4kf?=
 =?us-ascii?Q?6B8mASerfFunW6N/Iv32mI3jVIDz13kA3lkue/U/6MVH5O4RqqhMonOt7W1U?=
 =?us-ascii?Q?SR9pLbdBZHDnYgf3Ijam7xCODrzsSJD/IAR28bF02WCVRFR6DZt10qucp2aZ?=
 =?us-ascii?Q?Jv2cmWb9Y1Z7uInlyZs/PhoxF76qIlpeT6iHx6vLkpCjvhdognvgPQ9hDZhX?=
 =?us-ascii?Q?gA0HESLs95M7fc2wa7GoC1dgBE6Ig6EbK6VkTOooN1Gn3RuTZjC7L0xt5z/2?=
 =?us-ascii?Q?qOXxnNF4NVQeLKEOTIxWDHBKJ1EplGCDVOpsOpV53XOeET9azq3vtaFKIvMa?=
 =?us-ascii?Q?3kN9AibuPXt0F9YQNHioCWrx5zVLOAF1RWtjIxY6LJ+heFRaadHXyH9VWTFw?=
 =?us-ascii?Q?W+CUmtqWl9k+3ezKHY6CC90L5L9B5OpfJtH4Hx73t/jf2/fJP5KNzcQWvaDl?=
 =?us-ascii?Q?u/iKcutOqhqUFlUjRiHV8Fw4wi6tjTYMtSkdSAeo4y2lZZ9+MNIHhMNTAVNE?=
 =?us-ascii?Q?10p1j96W77DkHab+rZifn5REmqVSHxl+i7yr4FdDHggs587sjw6V9FToy+GT?=
 =?us-ascii?Q?nBJn2jxUX41KARaciUXGoja7OLk5+Fs7PhkDjoDOPJxUScZLyqU+LPAi1p+0?=
 =?us-ascii?Q?3gJiyNFi73pCpNwZ4bKtePr1Q1lGfxKtfB5dM9fncS/H93gUFQZXlAXFb4Oe?=
 =?us-ascii?Q?cr72DLxSi+qwW5fHgCXQo2KAOtEm7MIMymDT9DEC6zo4i3FPRv+sPhnyIRse?=
 =?us-ascii?Q?danGZWAqAy/zWHCFscFtPA5L2eCf6bdKG+2qHSjYvJTx0NMdx26MsvFr4kwP?=
 =?us-ascii?Q?GE2TPfPjRJxZvY/CWdqunK49ccsYcvBsaNkUSGmu91btme/rfXm5C7tbczuy?=
 =?us-ascii?Q?XCkp4LhmBKgAXds1ElC+rdhK8z8pnA8ETnyDVnvB58k5tnQAmZ2ezEoE5OrN?=
 =?us-ascii?Q?wHGYRWqhFd9hXe8ssTf/AepZ1AGydEjL78jBHmoQ7eaXVF+pSOE4PsI+Vn8e?=
 =?us-ascii?Q?1Ca+gW3d8Jb6Rr6mH/yKs5oTFEZjXVeEWVRLxfMG8pcR29gcPtY/BTtSV2X3?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ddc620-36de-423d-16b9-08dc1deae270
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 21:16:23.9808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDUhFnd7wUdL/4umkHt9s1p9Nhy4xrUmO1Yb80lv5YmOtCSeKvz3/EUMfyGT3h7WoY6j0ZIM0swVYFF1ycNR6AHBQc/yffYzIhL9AD048is=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6653
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Hi Vishal,
> With the QoS class series merged to the v6.8 kernel, can you please review and
> apply this series to ndctl if acceptable?
> 
> v3:
> - Rebase against latest ndctl/pending branch.
> 
> The series adds support for the kernel enabling of QoS class in the v6.8
> kernel. The kernel exports a qos_class token for the root decoders (CFMWS) and as
> well as for the CXL memory devices. The qos_class exported for a device is
> calculated by the driver during device probe. Currently a qos_class is exported
> for the volatile partition (ram) and another for the persistent partition (pmem).
> In the future qos_class will be exported for DCD regions. Display of qos_class is
> through the CXL CLI list command with -vvv for extra verbose.
> 
> A qos_class check as also been added for region creation. A warning is emitted
> when the qos_class of a memory range of a CXL memory device being included in
> the CXL region assembly does not match the qos_class of the root decoder. Options
> are available to suppress the warning or to fail the region creation. This
> enabling provides a guidance on flagging memory ranges being used is not
> optimal for performance for the CXL region to be formed.
> 
> ---
> 
> Dave Jiang (3):
>       ndctl: cxl: Add QoS class retrieval for the root decoder
>       ndctl: cxl: Add QoS class support for the memory device
>       ndctl: cxl: add QoS class check for CXL region creation
> 
> 
>  Documentation/cxl/cxl-create-region.txt |  9 ++++
>  cxl/filter.h                            |  4 ++
>  cxl/json.c                              | 46 ++++++++++++++++-
>  cxl/lib/libcxl.c                        | 62 +++++++++++++++++++++++
>  cxl/lib/libcxl.sym                      |  3 ++
>  cxl/lib/private.h                       |  3 ++
>  cxl/libcxl.h                            | 10 ++++
>  cxl/list.c                              |  1 +
>  cxl/region.c                            | 67 ++++++++++++++++++++++++-
>  util/json.h                             |  1 +
>  10 files changed, 204 insertions(+), 2 deletions(-)

This needs changes to test/cxl-topology.sh to validate that the
qos_class file pops in the right place per and has prepopulated values
per cxl_test expectation.
