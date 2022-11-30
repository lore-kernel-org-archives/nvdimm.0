Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CF1363
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 00:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669769797; x=1701305797;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CQIrBgzygehI2Lk6DB1BOO/ItK/pZe5I0Gfq8O0xP6Q=;
  b=cQ02THdT9YnYkGAsWXqQpxmny8KSPlRUyRszDxnrSsn70MQMUNx3T7eG
   Q2WM62RpBtDKfIHdGMP/ViM5g9nsZBXlvZxBDC5ZLpYjyKfVkdIPSJ8av
   XqYNcOilc1aMp4a8eENw+d10AQ/cdEB+lR1Tvom4lwKGROu0lANTl4v7P
   GJvQcHR2ecD0n/WTPVDv8e6d5FJJY2CGoh+LdI02EmL+A/DwX2SgbiEiY
   56Iob5Q0RtHCN3FRe1OMyPwQfuWg5jzIxtFLuDyM/Yu+D7Sotn17BviRM
   M8HmyRPE02qXYs26KmnUOKB+t2GEDCk07l7tvfG6MXjsdyVwIcu8+pyDn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="302874944"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="302874944"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 16:56:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="768638170"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="768638170"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 29 Nov 2022 16:56:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 16:56:31 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 16:56:31 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 16:56:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2KMoLezV8reJNRRdjlbui4hUWAmO2YDTGZL/e9iMinWhkqoVvUuJU2KPRfAWTTbhO8djmpjltRxGfvPartEbcu+J5GJYARoXWMYuX44vNJRZ2gvW83giE7Hp+ajPCbd2uWDoCtLtgkN+HvcTA5rEpIbFx/P3QIxYuTj8LwazPdZr9Kx1e4lpMDILHDDgi3hIi5lVD7gI2DyzkULliGE7dWS5JRjUUXXxip4c6UCcHpEbbX2jX8iGniYKDw1f/ej+PvDy0uq/INNc7/6zmA2Nr6GNyWQM1aGzUl7b5hjwgNn90NZiFnAIhSsfzn5iQm26vtMzl+ShdYWg41MduV+zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r8hxQdthGM6Ftd09b1fAkORxmHp6IbcloZQgiRJM3m8=;
 b=XSECTP3E4O1jWYOSSiq4o/3FwOCTTAwxrij2XkMX2imLrM4Ahozj4PRuChCVyhuuxmU4g94jKMpKUUeZ5IfdUTKdwBXjQi6RN8puzcXezBnbfAKdqIUaRqGcGnJg2h+GggJJiAUJs+UMktRL4MODhThcXH2YIsE5uNnvwbO8DcLW8zw5UPyT3wCsGQBD2POCatksOB6pgOzBJKrEBY6EPIU9t3USAFNYnOrQoYyv67eppVkEyo6xwHpNI3xlYChL+RFXHEX6JAWVir9VA16Ic5XXDVcycD1BaJXwCKVEY4te3Ce7V/9RoZlkROOQABTsXvCtNsOVb7f/uslHveuU0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM4PR11MB7205.namprd11.prod.outlook.com
 (2603:10b6:8:113::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 00:56:28 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 00:56:27 +0000
Date: Tue, 29 Nov 2022 16:56:25 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<benjamin.cheatham@amd.com>
Subject: RE: [PATCH v5 05/18] cxl/pmem: Add Disable Passphrase security
 command support
Message-ID: <6386aa398cfc6_3cbe02949d@dwillia2-xfh.jf.intel.com.notmuch>
References: <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
 <166863349311.80269.236166040458200044.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166863349311.80269.236166040458200044.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: SJ0PR05CA0154.namprd05.prod.outlook.com
 (2603:10b6:a03:339::9) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DM4PR11MB7205:EE_
X-MS-Office365-Filtering-Correlation-Id: 2142a7fb-56e8-42c1-f32d-08dad26db634
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: scI55dWSjqXGhIM/CYRnwZi3RV/8KkavWMwe5Lg9moxqTTyMNskilSvWVW1wJpNdfMNNnJDx16Ek1yOnjxsCyiONBvT/99sfAaBKoUjWHQEklMBKtbGSPCUK6p4g0PjQdZFIFMW2p6TRY2+mxZKmjAdCDyGLCf7E3AuA1XcOaEGl48qQcAJdaSYYcFu+jE2+JeyjphCuhOMSiSE3tiGEcAuyBs48zk/gFvFKIj9lOHPe9/cwjApRmbRxy9V7VMRS2fazoIecY0rDghPUpua4G+7VjlkAjR1kDesl7dQj5FsqRlHkaStvkS5k3/m5+F/bHnTk6tQEKwUQ2HdGju+vzuwGt3mySB1cVqaXQS0kE7qJvUgpumy/Xkrtau9+5EMBrwt2IR10NI8f5h701Vq5CVgN9/Cf+GZQkMdZOO4+2AHOwg17arX6gSEoK+VsjAZOft8Sz10mfWKJGwP4XCaxAdDFGwRzPN2fwy41RafYZwslTAOCVSrKbRoRJK+6Efui7pMHKcXyjcpaI7tqYp2VP7ZvTBK0vkg6v7TFNatkML3X7wQO0HhwqgnbaKwg/rNrVytaUqz2npfSLc9qBgsq2Qwu2qrQ4NqdD9F4uaMKXEdGUmPMRWFc8G/vbYbTpBkkHnUSnqvUjJHeqIRNIlSDNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199015)(8936002)(6512007)(26005)(66556008)(9686003)(66476007)(4326008)(6506007)(478600001)(8676002)(6486002)(186003)(86362001)(15650500001)(2906002)(83380400001)(41300700001)(66946007)(82960400001)(316002)(38100700002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RGHbtltVW2pghQ8yylujiCDb++SmChPUrrGVax7e7xuf7dp3uUkhpwpQnugu?=
 =?us-ascii?Q?Jbf6TP585e1jw228pamu++rB5xUes+pdRn7zVY4XwKAulSwfV+KcT9yoGtLq?=
 =?us-ascii?Q?YZZHK2a4IqK+ypiC9iGWdafHXZCtoccgfACcyatvM7T4DuGawrkZXs2F1LQK?=
 =?us-ascii?Q?a9rJPapdK/UqRR7foI7bf7ZRyR5YuKgjFsN1Cbp4iKMrc7ExdS3TgYwvYnoP?=
 =?us-ascii?Q?F0YdnbB/S2qEmQAN4Ur//AV7tJGLFzLZQ490AbiT5FyZNf9N3y9c2G3JevpJ?=
 =?us-ascii?Q?hwIHu7usbJTe+xcbs8WTDtu0EqBdCipcg+mJEOV22g2utR6YO/2y2Eo11ym9?=
 =?us-ascii?Q?FMPx5vPEjy6b5hin7y5V2qbUaf/2GpADkcIo6vkCQukp5Js08Hr7GXpRRWRp?=
 =?us-ascii?Q?TNyVg8YtB55ZISv6EmgNQrrldYIrWbokyht/9twOg0zaXIb9etqTweY54X9L?=
 =?us-ascii?Q?3tXH1aNvH23aKfY+qBvLFnWwI4MPtVOGW8CF5cHRDodMtZfLwP/3J8sldiZ8?=
 =?us-ascii?Q?4seazrI++hTDilM7H+S12/Efuh5ZvXsWfCi2bFIrEkwaviQS5bIZ3Q9i5Vk3?=
 =?us-ascii?Q?Y4J+RzRO+jiIoSsoWr1+hB8I/kgGj4mkrDXVqT4dUybzqnSs3ABmz1MdLvJH?=
 =?us-ascii?Q?5TjoSOG6HUw6FmYoLJf6PpMjaThlER9ayRr1YyPolpZJOtiWbZ6j0oqK5SdL?=
 =?us-ascii?Q?aNt9SU698k/g28SALKwjgyshETNCcRUMPWJCpp9MSWsxSiGsZNfYo15zdw4h?=
 =?us-ascii?Q?ri0Ea+65Q1CWs/CtxZxqdQjndoy+lKtZwsPMglvnYCpy1z7gF8HpuN3C+YXl?=
 =?us-ascii?Q?oNcDVN5/FnjtPch0m5wpRlwvHj/H8ZD42o1jJczIgmX9QY2eox8Y8JRLsK7L?=
 =?us-ascii?Q?VOjIBoQAz2DPozRbKa9TQ6r+5+lFokenxLX8MQXh5l1K5y/Ft3fhrd4pu5Xr?=
 =?us-ascii?Q?2aDYfXRuoH1Id6Oyg/g2+ikGfOqGMgabJ6e6rLOBfG/PM4yX1eFaRYYAb8pC?=
 =?us-ascii?Q?qUtR5NQT1NyuaeRlPVi8UvpdFmRqTnss66fu5feg3ApUMTIU6LF9t+CduUsS?=
 =?us-ascii?Q?cx1oMNTSZzKqsRpqLnVx1VVnMBWWj7OBOQDZkYJ45gRCl4kbzTToWQQLPLGN?=
 =?us-ascii?Q?E8IICZKcAI1zF8VXGIcS7RnDrik6PGW2y4ZccJkxg8ObzAwBV1QCBYehptgu?=
 =?us-ascii?Q?Yz5YUBt9qzdiRh+OsyUT1q1HJLUO7WS2OyE/6OFBixmu5sz+Y53Wa++QrHlb?=
 =?us-ascii?Q?qWgTIr6dceQzRY1l1OLHFTBrSs6ezfJEVZuOUhbiOjmmCH675d6J/uFmlJDF?=
 =?us-ascii?Q?DHDpRcKxn8uBvE0CykZ0aKZb8sJyXH2ey22cUmRUl4cXmP8pCcCg15ZW/cJT?=
 =?us-ascii?Q?ZNRuxZAadJvmRUiDb/ELzNDq94Ir0TUvyobWWTLv0iXX/eWm9lS+XGvqWhZe?=
 =?us-ascii?Q?HARCk9Rxq5JTZCd5XqaaQ4OdNxKLubhbRTadW9HIKIOJDdjySU7CpbsnPQHb?=
 =?us-ascii?Q?m6dIItaywdgQn1RMSxFbT2l4RDsoiKJeYxFwsqDcy/z7UkstPBU8sGKEeTL+?=
 =?us-ascii?Q?cLquoVikpSdsL2H2lXX6PxgQ/FVJYOYPdDu06inVMECak53nabiALBDdfAtU?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2142a7fb-56e8-42c1-f32d-08dad26db634
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 00:56:27.8412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OmDNeREXbC/FRPpOr6R28iY4zEBS9kZBIkMngwi3zU04J9SruiJHFi3ErXY1Qn9t734OdtQYA0Njt/RXcpQQFdF9q9XUnRqhdmIqnjLnL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7205
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Create callback function to support the nvdimm_security_ops ->disable()
> callback. Translate the operation to send "Disable Passphrase" security
> command for CXL memory device. The operation supports disabling a
> passphrase for the CXL persistent memory device. In the original
> implementation of nvdimm_security_ops, this operation only supports
> disabling of the user passphrase. This is due to the NFIT version of
> disable passphrase only supported disabling of user passphrase. The CXL
> spec allows disabling of the master passphrase as well which
> nvidmm_security_ops does not support yet. In this commit, the callback
> function will only support user passphrase.
> 
> See CXL rev3.0 spec section 8.2.9.8.6.3 for reference.
> 
> Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/cxl/core/mbox.c      |    1 +
>  drivers/cxl/cxlmem.h         |    8 ++++++++
>  drivers/cxl/security.c       |   26 ++++++++++++++++++++++++++
>  include/uapi/linux/cxl_mem.h |    1 +
>  4 files changed, 36 insertions(+)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index cc08383499e6..2563325db0f6 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -67,6 +67,7 @@ static struct cxl_mem_command cxl_mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
>  	CXL_CMD(GET_SCAN_MEDIA, 0, CXL_VARIABLE_PAYLOAD, 0),
>  	CXL_CMD(GET_SECURITY_STATE, 0, 0x4, 0),
>  	CXL_CMD(SET_PASSPHRASE, 0x60, 0, 0),
> +	CXL_CMD(DISABLE_PASSPHRASE, 0x40, 0, 0),
>  };
>  
>  /*
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 725b08148524..9ad92f975b78 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -275,6 +275,7 @@ enum cxl_opcode {
>  	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
>  	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
>  	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
> +	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
>  	CXL_MBOX_OP_MAX			= 0x10000
>  };
>  
> @@ -390,6 +391,13 @@ struct cxl_set_pass {
>  	u8 new_pass[NVDIMM_PASSPHRASE_LEN];
>  } __packed;
>  
> +/* disable passphrase input payload */
> +struct cxl_disable_pass {
> +	u8 type;
> +	u8 reserved[31];
> +	u8 pass[NVDIMM_PASSPHRASE_LEN];
> +} __packed;
> +
>  enum {
>  	CXL_PMEM_SEC_PASS_MASTER = 0,
>  	CXL_PMEM_SEC_PASS_USER,
> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
> index 5365646230c3..85b4c1f86881 100644
> --- a/drivers/cxl/security.c
> +++ b/drivers/cxl/security.c
> @@ -70,9 +70,35 @@ static int cxl_pmem_security_change_key(struct nvdimm *nvdimm,
>  	return rc;
>  }
>  
> +static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
> +				     const struct nvdimm_key_data *key_data)
> +{
> +	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	struct cxl_disable_pass dis_pass;
> +	int rc;
> +
> +	/*
> +	 * While the CXL spec defines the ability to erase the master passphrase,
> +	 * the original nvdimm security ops does not provide that capability.
> +	 * The sysfs attribute exposed to user space assumes disable is for user
> +	 * passphrase only. In order to preserve the user interface, this callback
> +	 * will only support disable of user passphrase. The disable master passphrase
> +	 * ability will need to be added as a new callback.
> +	 */

The changelog already covered this. You can just delete this because a
follow on patch fixes this by adding a new op so this comment would just
confuse a future reader.
