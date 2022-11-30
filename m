Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D347E7E0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 01:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669771995; x=1701307995;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ja9Z+dShRCwX67qNj/RmeoMDs32wX9rWYN4A5v6bvVE=;
  b=RqETAVDJrmWA9nQWH4aww2FepbccSlpdv9jIhPUsEMcXQHMD6aB7Sh8/
   fqSkbrhjpuEEXx0WNPXIR4khy/3shrTA1ViiF9OMbLyGLKPi7HKNf8y6X
   Hf9Sju5+7xKXnJ6RPmgnfoqJpShm3QktLhacj8Gbnsyr/mXFupMFmweXW
   6T5dLt3x5P46lydu/RyaYk4yx0G5VbsYgx3PZ5+Ik7hSmFgtUc6Gvvw/s
   o+cwnE3Hfwd3Pf4nKSM5cvv8aH4+AaofxahOYI4Mki7EodWq3JYN9hL1e
   G4Cs1jgkZie+AkSypK92MzFng4IAFX0l1eFCFtYaCEZq3ML4HwxUVyK/N
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="315307000"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="315307000"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 17:33:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="676645490"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="676645490"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 29 Nov 2022 17:33:14 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 17:33:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 17:33:14 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 17:33:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 17:33:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKVGgVdmkW2u2z+Idyd4jQBf9kXiDtvfTjsb9WToAsMComiK55/I6QYzBS6CecKesxJ+jHLtuglPz7QRKJ8RdaCNhj42CcsEACeNrT3B/NaUSntefc63Cfs53pfefnva1C9R+/SvNs1d1dCUhFgy5pYkblbmrcMLmCV1QXQ40+3qPY9ZDvUJiqLJVq69TjWjKPHojsRjGwr9siJqQeqCyWw83TPhfALU9o6n3V5DmWuzO+PRVpYpCHUeibmHHwKSIuzk4fCjU4HEswU0OKQvOz1bepueGe/onk/aRMYf+iHh8Qpdq0+ARiqp4Yjov6wPUIOd9TYMFFvyl77gErfxfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrW95yk6pziQMBZps7oaSQZuZa1MutkO3DJXUXlgazg=;
 b=VAp0hHKBuSZofXxQSm56YmcSb3flsO39WmaxQUgcVUdUHbVI2oF7q7S/47AMxywOaGBTPLxRGkpaAzcxxWrBO6ha4+GUappF+RFWH/PFzzVMC0LXs2yqnyxNGl+v9lgchy2C5Hhf6lIX2BiMgCmDnHSMnOuqYulInZCbTM443ZfHqYfFd6S9mVjq66OPhAAz+eDAGzQgFQgj9RndpDUtcSjUqkoAY5UHieCkLEsHKYMNZsr8r+lVBISm/4TOwOFqXcwEbZBIu5F+VJ+swKWfvCCV02L/hvhNTYY946TrfOIVaNHlF3OdlHkd52N28cQid/PU0KWVm/tohfL2rvzUbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SA2PR11MB4780.namprd11.prod.outlook.com
 (2603:10b6:806:11d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 01:33:06 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 01:33:06 +0000
Date: Tue, 29 Nov 2022 17:33:03 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<benjamin.cheatham@amd.com>
Subject: RE: [PATCH v5 18/18] cxl: add dimm_id support for __nvdimm_create()
Message-ID: <6386b2cf426ee_3cbe02946f@dwillia2-xfh.jf.intel.com.notmuch>
References: <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
 <166863357043.80269.4337575149671383294.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166863357043.80269.4337575149671383294.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: BY5PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::23) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SA2PR11MB4780:EE_
X-MS-Office365-Filtering-Correlation-Id: d389fc85-c1a5-4dc8-66d1-08dad272d465
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9lXrGrncXgYKK6JcdRucj/RZbBBAnIaXkEe1Q1Jiw0TWK/5U68dyFRxlOCuKUgGZOnigR5JwSaSKs+lLJsuvPgj4EIwaof7Jcjh5Xc4dTvNEpMONzLsjJvz9l3XNGyiHI0ivxHqLUy4xFi/2kAgxhyq1HmpUsS0sDQt8ZdIWmJm8XJdq/mUA3cdjUxB9NY3vzrSQ/OHb8na5TnldIg2sHlM4AoQ/606iadGmVtb49KbCS7dBT8k/eeBKDNbNpLPx36L11if39KMlkk90Jbhjt7X2zX5HcCwLoxLZJAtYw+w1fh1wfL0Id/msIEKClsq9618VOfVc/a1m6TGt7rHUHoHMeF6g5mU8zVvtg8YqPGZ/ze3GYgx5xSzWjWIihgMEx9d6FEalJGXUD65TmWzimdUpzlHjHJ9hc3zblobsUqIV9pr6yCjS9gBtnwA7zpg5u+bKjVj+5XKvUqufmWws4DauVPDOmTqwDqI1MdUSbq19Ca6u5lmFIFgYRRhM0M8OtUkmxYejObknmEoIGRbk/pWvpPkISpoCTALnWRzW1aqZGyDsDWVi/4K/8ZBKeToYyr/agd29+jmhAI6YqvKVO7mHmbHraDp5HKUBXG939nXR5tfp1st3+rorMMGcU+olMnFkIgb7TW0srVSfMqC25Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199015)(38100700002)(6506007)(82960400001)(83380400001)(26005)(6512007)(9686003)(86362001)(316002)(66946007)(5660300002)(8936002)(4326008)(66476007)(8676002)(66556008)(6666004)(2906002)(478600001)(6486002)(41300700001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/p8RLWrKttP68HBnDfGbjWKn5jeuJFvvmUmQxgt0qF3bUI6CfRgEoPMs6L6p?=
 =?us-ascii?Q?lP8hBuuH5MUtofkjpj8WbpnQ232FfHWOD9dDOzN/7v6k5MZwr9L1e/8fz5Z8?=
 =?us-ascii?Q?6hZXkzyA8JHBPieTuQhC6DxtnZscGFTEtMVhAsq1+vlgR8kK0ZgZM4PZeNsz?=
 =?us-ascii?Q?T5DaVPI2AmqPcD0abWL95UMblymGPvEkF1uF+ar2zNSdaPgxq3ZMlgPQm6Vp?=
 =?us-ascii?Q?3zn34GaTnAU/Nh0yc5K7GDDosQslckmtWYgYnrr+kvMnMPwsaTaKyb9XUzFi?=
 =?us-ascii?Q?xCv3NWg/rzXD2Ck5DK9vN/aLrLZV1gmI9Z+4yHpMXdpdptU0eFEkghVGioiN?=
 =?us-ascii?Q?yudiUtpfSLx1ISLq7hI5qwt7sXKKHivsYssCZml8qp3IQkB8sO2smKqEYqVx?=
 =?us-ascii?Q?sotI5JzxH1UoUNvdqYn/oUVdvc4F4UzmX4Y3vl1zN92vrCmeG0bpNgxAVLo4?=
 =?us-ascii?Q?xC29ZwSmfak+WF0fRdzDsUK2d+vGYL36xX13f7sDI3jd5cgZqlqA7R4otVEC?=
 =?us-ascii?Q?BHakEvUbprUnc8l+M/Zdtjp2whzYexh6gDkx+qv4dXekmFJoHz3WwjrkOWIz?=
 =?us-ascii?Q?XC5tDXbYvvR4j8mV90+kvCgsUxeHheMYcmOmal2amLAJfhso7IAvdVgsRwg9?=
 =?us-ascii?Q?ZwpBmjp1alZP0nB5cweeqzZfBVoQy0DY5KdOzV67E9AxXphjZxFR+qf24k7y?=
 =?us-ascii?Q?RnoxCOHD5ZB7plvs9Ad9A18nlU7vq4PWOmOa4elnLwQ3O+tpo7q8vZgG7WNb?=
 =?us-ascii?Q?POPeO1oAkaTYHMylTP2DoOrO5Ixo9vALk+3Qd8lm+PHbl25rSc/q2idso+KK?=
 =?us-ascii?Q?4df4G7lBPWiGotrhVemBxTGUgqZ0MgIIRsQQpn/bXGrn3VWdRgp9SbTI9tUn?=
 =?us-ascii?Q?UqLdY41J0BqewVARMQH1UcrN3/vd11AAGGkaCH7YFvRVLe0iaHZ+Scn4ILsk?=
 =?us-ascii?Q?k3jwGgv7CHE/9X1e3eFv22wTVKvukDimNU0vrei9+35JhiEOZ2L6Ivt0Jajf?=
 =?us-ascii?Q?AW6Cyefiu3gXnK2M7PjiKflFghWFqtFJz6BaUch5drAOlGqsXVjpYzuDMQ6v?=
 =?us-ascii?Q?GPOU7W77mMxmuPpGJ2IeYfFa/+7VuKF22RO3a9va2mpJlI9z78DIiK14BJWW?=
 =?us-ascii?Q?kWxXXPUYftfpK5+Tgo/EXk/Gu7IuSiu8w0lP3AK8GE9rHl9mFRVXOlVW/rBo?=
 =?us-ascii?Q?Yd9pAZZ7qI5STv4jqj2Z9Fum4Wplr4k6TNgI2f3oM83QdIiKG0h3U4FJyHPt?=
 =?us-ascii?Q?9UkoEvdfSe4D3cXCr4/hAr5RL91aqN4uMZtBqdqmn1623XliVqKuKgS0VY46?=
 =?us-ascii?Q?Vk8f63+78kjTWCKX5wxzF7DXjpUOYZtAHOaNqNd+pIsdVRnO03C0TO7VEFbg?=
 =?us-ascii?Q?sHdlOxfQ5+BFqA+Zh9wvpqHNkNVTp8lmV4piqLHhg/SnXlI4BDxWyjnZY2iN?=
 =?us-ascii?Q?0rjGn3s8/zh709WhOS2ohDYOsNurPuhvp3LGNpfqsNl3qoUVHusPJZJSAYr2?=
 =?us-ascii?Q?6Nqg9NsUG61BB3rIGl12z7mJvuMuR++uMTnVtzfUAdMvyuhAEDtw6zTibCdu?=
 =?us-ascii?Q?il+oZMFPh3aKiDyVejBhEem02bbX7r5bma5OORjV/iZk33mbBfBywg5++iU+?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d389fc85-c1a5-4dc8-66d1-08dad272d465
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 01:33:05.8960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5ZCTShTaeh1OMNntL6kk0wyGGhlZX5ArAmuug7ZFWJsy2ECbHdkjMcDVcIGFCLLzpyd0TJl9ej2lK4BGI2xcuI9Od+VE2Cv9YK9YGzZLA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4780
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Set the cxlds->serial as the dimm_id to be fed to __nvdimm_create(). The
> security code uses that as the key description for the security key of the
> memory device. The nvdimm unlock code cannot find the respective key
> without the dimm_id.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/cxl/cxlmem.h         |    3 +++
>  drivers/cxl/pci.c            |    4 ++++
>  drivers/cxl/pmem.c           |    4 +++-
>  tools/testing/cxl/test/mem.c |    4 ++++
>  4 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 75baeb0bbe57..76bdec873868 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -178,6 +178,8 @@ struct cxl_endpoint_dvsec_info {
>  	struct range dvsec_range[2];
>  };
>  
> +#define CXL_DEV_ID_LEN 32
> +
>  /**
>   * struct cxl_dev_state - The driver device state
>   *
> @@ -244,6 +246,7 @@ struct cxl_dev_state {
>  
>  	resource_size_t component_reg_phys;
>  	u64 serial;
> +	u8 dev_id[CXL_DEV_ID_LEN]; /* for nvdimm, string of 'serial' */
>  
>  	struct xarray doe_mbs;
>  
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 621a0522b554..c48fcd2a90ef 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -456,6 +456,10 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		return PTR_ERR(cxlds);
>  
>  	cxlds->serial = pci_get_dsn(pdev);
> +	rc = snprintf(cxlds->dev_id, CXL_DEV_ID_LEN, "%llu", cxlds->serial);
> +	if (rc <= 0)
> +		return -ENXIO;
> +

Per below, move this to cxl_nvd, but also if you change the format
string to %#llx then you know you can reduce CXL_DEV_ID_LEN to 19
because a 64-bit number will never take more than 18 characters to
print.

>  	cxlds->cxl_dvsec = pci_find_dvsec_capability(
>  		pdev, PCI_DVSEC_VENDOR_ID_CXL, CXL_DVSEC_PCIE_DEVICE);
>  	if (!cxlds->cxl_dvsec)
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 322f834cc27d..80556dc8d29c 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -112,9 +112,11 @@ static int cxl_nvdimm_probe(struct device *dev)
>  	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
>  	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
>  	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
> +
>  	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd,
>  				 cxl_dimm_attribute_groups, flags,
> -				 cmd_mask, 0, NULL, NULL, cxl_security_ops, NULL);
> +				 cmd_mask, 0, NULL, cxlds->dev_id,
> +				 cxl_security_ops, NULL);

I would hang this off of cxl_nvd->dev_id, not cxlds->dev_id, since the
former is associated with the nvdimm side of a cxl_memdev.

>  	if (!nvdimm) {
>  		rc = -ENOMEM;
>  		goto out;
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index 38f1cea0a353..94a3f42096c8 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -593,6 +593,10 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
>  		return PTR_ERR(cxlds);
>  
>  	cxlds->serial = pdev->id;
> +	rc = snprintf(cxlds->dev_id, CXL_DEV_ID_LEN, "%llu", cxlds->serial);
> +	if (rc <= 0)
> +		return -ENXIO;
> +
>  	cxlds->mbox_send = cxl_mock_mbox_send;
>  	cxlds->payload_size = SZ_4K;
>  
> 
> 


