Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ECE654
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 01:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669770507; x=1701306507;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mjstm1E/otgIy5bsI8NH+50/+Ghw/LI9MWqjaPtcebw=;
  b=Te0xgveR8ItMyuyw63oGGtUeVRd2RF2SCRi1DYVsSCWB45sZySY89OQm
   VRwEF558TC16XtxD2nikqJPN8wsOzt+fy1EdSdoKnTCaRwWgY0HwWX3mt
   /+8XE+9Bi3tjLys+kXJys++AcuTJtZyVWe0hstS3zTYz2ytMPgjjkNEds
   R8t+0fxd9D4i+BDa7ClA4xYsrUaXxZ4ryg9EM6Ufn6y6XO/VtdgducjjT
   HVG3xjS1Z+BRGjn5xTYYI/1hOp8TZ7zuC2su7UbWtnLS4y4N413fXNnSy
   IsZb1zZXQo6TfvhrTYqsH23DusWHMH1PURWxomEmZqXJo/UvF4uF19A2T
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="302877121"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="302877121"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 17:08:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="768640776"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="768640776"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 29 Nov 2022 17:08:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 17:08:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 17:08:16 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 17:07:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRqL29aFj0qUhRuu1V5pOquHrs+33ChWsyLqSt0hUGOOAEf4sw/sANRiVgqsX9Ud59cfij66CdBaRAcKrhpN2BCsI8C9vLKbB/lwezdaHf5wJnmu0etDOaZ/+vLSAwsX/nnlsFbCqiCG8SMRD2tvIekXxWkqeLu1id5JtKpI4QJOjzybZTixdrWdxONa1Iq4TfmTjbm0bQZICozXqqSsT8yoURg/Qih+1eRQvQFHlt8VI7jrEeIMFcmyfJ++ShRVP840Pleq9hjRHzNchkj1l5+K4JIngawPijTLtUC4nZqpBXjPMAvAvAbv9xUGIAzj0i0lsrXfdga7s8Cueo0HqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hi7WROwbAaxzoxjdutAly3FzRE7a2xoV602fzNwzxjM=;
 b=gAvGAS4+NoaHUZ5n+RGo3LSgNJDQNvre7ZYHr2CYaAAxYLdPIKTmFgo+8vHw6eMkGwTiXez5VfiOa7EoMsiNfYhu/CYbVOxNx9Xj8TXGcnQIvPHQBkbdBqYW/9cqo+vQ4K9vW7pgu3TvUmaNU8XEnLvHRsGt/ZVlN/8V82eyHykqpsGQFklrHusbfAkhhq3XBqU+gi14q6dqqqaGxQrsXHZald/OTnnN3e5Dhrnum2YaadT9w5dxN1HC6G5kbgXJVP4Ln+3dyIp7HFZHYt4MtNcUVYRGMzjD7W97HB81TIwAar6Lt5P/AaFh2k2xUO0pW9KNKAHI7wqYGkjJKQZ1fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM6PR11MB4561.namprd11.prod.outlook.com
 (2603:10b6:5:2ae::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 01:07:28 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 01:07:28 +0000
Date: Tue, 29 Nov 2022 17:07:25 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<benjamin.cheatham@amd.com>
Subject: RE: [PATCH v5 14/18] cxl/pmem: add id attribute to CXL based nvdimm
Message-ID: <6386accda6bbd_3cbe02947@dwillia2-xfh.jf.intel.com.notmuch>
References: <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
 <166863354669.80269.13034158320684797571.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166863354669.80269.13034158320684797571.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: SJ0PR13CA0157.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::12) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DM6PR11MB4561:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e42427e-665e-4fc3-f519-08dad26f3fbe
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qal1CYjpHFv1RjRKBqPW1NQSRdxE/9MeQxdUMTJ8duJuyrcWYLYOoR52bRLtjCNbOLMTplxc0snHeqJGJJ6mvoOKObcoifGXA3Lf3LsmLSP5lnenQibjyRP7jlDssj23olnqACAQphlnIVd6BvSFbc7ACfkLbPOvRFnQCEcE8hfJVDxIH5DAeRfbg4cPK5XisCCNCSRVUS0cGWeb4WfK2qKhhEtzkzibWaLnTe3Nqhw0KwCyNLIe9Oiq+kDCiu3Qt50TY6iMq868PH5ivJkzdA3kYLA3ZiGnomEih2faOcy8epAYrmSxDqeudUr8salV/Qwqm9LT7eCAgAOV8kZu1aydPDKR9nXLDFy0W6larOycy3ijRD6u+AajsobrEEMt8GMf5J/e9/MtM5NG976ZuCbs2SwN0K7DH3nMtw7DvFJVt6R9NKxUIocqh6X971VLHL3JSzdUTe58tZ0ul4B62QxfGWQx4iTMnSvonDUVz1c9DE5lEPZyw7niQlJhbpi/Bh+YCFb6QFXvz1KJO6eUcB50mvep5Mni2ZRHki4czpz8dlsecdL7TDlxJkLNPmCQG1V2VxSyKKc9ia8qElYzgMvKMWb5ThMCyOrAfvBGNJHc6iZRP/0u95hwZU6lN4DYP5or4fqQTHmzaBPXgWuZUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199015)(26005)(5660300002)(9686003)(41300700001)(8936002)(82960400001)(186003)(66556008)(4326008)(8676002)(66946007)(66476007)(38100700002)(2906002)(6512007)(83380400001)(478600001)(6666004)(316002)(6506007)(86362001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iNkUILrYq+/uggCDa/44hAetexo3jaEQqitgKFMaUfleqfq5p0/Tp4Yle2g6?=
 =?us-ascii?Q?GaaqDNA6tQJAngZPnPJj0lyNjCdH7PgFb+t/TS0R/Foj8qH4YYUy19ifSA5l?=
 =?us-ascii?Q?2h7T+ta+7vbpmWWqEpnXoXyRczOLWweHHfQe9GLzalCkIiMXgE2y5JWSwJbR?=
 =?us-ascii?Q?hcraUv7S4CpA4hu5Ml2LNYNlaZ0mfPBMVY/fyLuvdLFOlwinwXpPqzgCTHMT?=
 =?us-ascii?Q?AuoM59izvYJB4CJJP2v7dnYynsgfr8CQomZQOHI1ZAdljAjCmr3iS2JW924a?=
 =?us-ascii?Q?3vodNbO0wEHpreBNFlx4KF6FM1TqRHNwViQ2wgjFWnj9mzHG5KhUfsEZQn5T?=
 =?us-ascii?Q?hlzfQtg9LRqmpM1e99CnTRUdhQUDcidCCyRPt52sFnrwwTtSNdGgzdK6sXFU?=
 =?us-ascii?Q?rWpAEhswkYfv+DSicyjbwKkeW8NKSoKkcoNdTOiHkGFC/EzGdtpu58AAzGK+?=
 =?us-ascii?Q?HUPIuhO0tBX8IKAkYvtirPXFTczVKWTqig7BGugbZCpP0N1uMOci1w5jfimR?=
 =?us-ascii?Q?vg33tItxAytu4ClTJWOVrG1MxEYfPjAZ0PvhjAWV+Q13dawC17mzB6uQBzam?=
 =?us-ascii?Q?gMZPhUEeb99pepR11EbvtSCzIU5bumwOS2mS8PIdYSDfXKxSAuTaS3eRd0o5?=
 =?us-ascii?Q?wX4t7+oczsMTg3e/BC4d/8zjYDHCGs0CqnbXydudFi5BRxNpF8JD4njKtgOn?=
 =?us-ascii?Q?KCwLkTugr16QgY+AyzTYW29k8HdTeo56KDuqGf9x1dgEMOSkyfiXj/Cp+3ny?=
 =?us-ascii?Q?3ke4vSOQMamQXPN9WRu8HXgm9kWA04oEem04eyaOZPWfRZ4y6lVIqeNlw1qG?=
 =?us-ascii?Q?R9EpwZef1VB00RbwO1d7fyK+iDP1rxZHtxeQ7+wEAvbf9srnGH/aRSmXe2AT?=
 =?us-ascii?Q?5wPsczIuU/SSssG3S8e5iuQmEzUpZmnMZfz7L1klyX/jMvDGD4sXshEk3v2X?=
 =?us-ascii?Q?yiZ6sfINfrlXGesCN+hdEkpI++7zSgBANzwnexx+/b8V9uSybyY6MEZ9HHYq?=
 =?us-ascii?Q?wZ26gWi90fnseunFRGj5iS6VuNhf09pkQc7cSDPA9KmxuUcO5uPMawEBIeEn?=
 =?us-ascii?Q?N2KKxw9CxcDBOhIhAq4eql6O59R9hRvIaZj9MsBC0+1ryoi6WxbmYzjaSq9j?=
 =?us-ascii?Q?mb1qPGF1L0376+tr0JI71s/ECEe0oB33rOygL8ZJMKte9OR3zNZ9Zz+/63JQ?=
 =?us-ascii?Q?4ttDREHkTaddOJctc4vhENwLECe7e54pRyaj+vJgBhOGDR68OUQJNjJ7YTO9?=
 =?us-ascii?Q?Bn+axouvcz2eyopH3fi5P+r3HKuNJi2vHrcrxEd5pmP9fS76OJdK4q5qFy8c?=
 =?us-ascii?Q?r8LQmkIzMZLZIBQKgSI8vE8ra4gukFd4wod1cc3Re1jOFrhCtJk8z1iggQS/?=
 =?us-ascii?Q?QkNwAOvm1ns3APt5qee79mZj3C2F3Vt9hDnQKGQMgYGSty1vLqIYa6zGVsDo?=
 =?us-ascii?Q?4B+Ua4ydAadX7f40T6tYGhT8Crfok0eqJhaEkgFIzL91zownbDlmJ+DHnJFF?=
 =?us-ascii?Q?yMM1SwrAwugw0/IofhEI7BI+QYU4QaOqD4hsA1pdmIZENPng+8L252QdTF84?=
 =?us-ascii?Q?LbyLK8jk2F6qtFWigdVg/s2tPFJ6HGCsekGbcrfWOWgwegALANdS6F/hQiUG?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e42427e-665e-4fc3-f519-08dad26f3fbe
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 01:07:28.1059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MRg7LwzkDobJO/iq4EbxhpwpKeQStuC9kXWgBFKNo607EGqeE4Hpzx2dxlONom2RTyZGthln9S2EFPpcgRE7wHwY6M/ovBn6APwW+k3grkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4561
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Add an id group attribute for CXL based nvdimm object. The addition allows
> ndctl to display the "unique id" for the nvdimm. The serial number for the
> CXL memory device will be used for this id.
> 
> [
>   {
>       "dev":"nmem10",
>       "id":"0x4",
>       "security":"disabled"
>   },
> ]
> 
> The id attribute is needed by the ndctl security key management to setup a
> keyblob with a unique file name tied to the mem device.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-nvdimm |    6 ++++++
>  drivers/cxl/pmem.c                         |   28 +++++++++++++++++++++++++++-
>  2 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-nvdimm b/Documentation/ABI/testing/sysfs-bus-nvdimm
> index 1c1f5acbf53d..91945211e53b 100644
> --- a/Documentation/ABI/testing/sysfs-bus-nvdimm
> +++ b/Documentation/ABI/testing/sysfs-bus-nvdimm
> @@ -41,3 +41,9 @@ KernelVersion:  5.18
>  Contact:        Kajol Jain <kjain@linux.ibm.com>
>  Description:	(RO) This sysfs file exposes the cpumask which is designated to
>  		to retrieve nvdimm pmu event counter data.
> +
> +What:		/sys/bus/nd/devices/nmemX/id

This should be:

/sys/bus/nd/devices/nmemX/cxl/id

...because cxl_dimm_attribute_group.name is set.

> +Date:		November 2022
> +KernelVersion:	6.2
> +Contact:	Dave Jiang <dave.jiang@intel.com>
> +Description:	(RO) Show the id (serial) of the device.

...and Description should also mention that this is CXL specific too.

> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 24bec4ca3866..9209c7dd72d0 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -48,6 +48,31 @@ static void unregister_nvdimm(void *nvdimm)
>  	cxl_nvd->bridge = NULL;
>  }
>  
> +static ssize_t id_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct nvdimm *nvdimm = to_nvdimm(dev);
> +	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
> +	struct cxl_dev_state *cxlds = cxl_nvd->cxlmd->cxlds;
> +
> +	return sysfs_emit(buf, "%lld\n", cxlds->serial);
> +}
> +static DEVICE_ATTR_RO(id);
> +
> +static struct attribute *cxl_dimm_attributes[] = {
> +	&dev_attr_id.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group cxl_dimm_attribute_group = {
> +	.name = "cxl",
> +	.attrs = cxl_dimm_attributes,
> +};
> +
> +static const struct attribute_group *cxl_dimm_attribute_groups[] = {
> +	&cxl_dimm_attribute_group,
> +	NULL
> +};
> +
>  static int cxl_nvdimm_probe(struct device *dev)
>  {
>  	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> @@ -77,7 +102,8 @@ static int cxl_nvdimm_probe(struct device *dev)
>  	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
>  	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
>  	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
> -	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags,
> +	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd,
> +				 cxl_dimm_attribute_groups, flags,
>  				 cmd_mask, 0, NULL, NULL, cxl_security_ops, NULL);
>  	if (!nvdimm) {
>  		rc = -ENOMEM;
> 
> 


