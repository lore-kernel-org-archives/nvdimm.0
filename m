Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C817B
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 07:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670053838; x=1701589838;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=d4OGfg8C55i8quorQtjsjAVeoLk1y7pB1qdGBgkqpz0=;
  b=BlfbV1P0/vY0o8CXsRa+BMbz5ZgOph9t/cKIwu+hS7bEqz95gSMPbzit
   rLZZWfuIjb6gQNrRhyOcSAFq2P/O6KxHjt9xSY8pjUcZ/X/1QB4ZEVtGK
   GWZLFJUHv//1d2xL320Y4z+l+BmvEdBVqv1xZGSDcsLlDvO187SzHCVIm
   RsjC1x5JEx5xScv4B7q4BiD/awF8bBpfYoxR/7YdQXTA7Xb+0/1X/W04J
   b/5qGDjzbJbr2FHO2LE7q9cASqWdDsaWIi+q7sxr+VE81nm8QFs0MCqmj
   MSY5Lq1Yx91O6glWea/hM22ot/sr/57LA082Jfv+pFCUsLTpiqqR/nzFF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="316129110"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="316129110"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 23:50:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="676078235"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="676078235"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 02 Dec 2022 23:50:36 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:50:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:50:35 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 23:50:35 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 23:50:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUl/FcdORfZ/bLB2udDGBeQZ2rU32ov1iPPD3JG0nQKBh8uJY06MtVsot/RdmhBLxto2ZfTpP5dsXj6Vrm32zmI3uGb5EgKo5Pqis9VCHDgTUGaqCYNQoHRKnzswCOHn+YqOZJXoR/NYGBH9IRykmNeWx97CE26Co6eJuH+QJEfvUA9gaBno6zICXpo7Et4MhT0Fz8eLiK8j5N4InTKdOftZ3Xu8+68uefvZb7E0Nhn9Oya4ERx2o6feKLOFfxhA32/LvJmHbNF0CfKarko8okMEabXZ4RUCitJOwVz/F2+ovrcGePNjfcS2wi8kRvY+Swm8VtuCNMKKhhRklYHlBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=66AhwglDnesuzr5ON6daGgwx1NUZAFkGSqEeTt2Rhyk=;
 b=ORhROTwAjOZu59NywXR4HYaIvciXntcHIcP5K4S/hdICxiNk9NMS/Mpi/bVaS7OH+I7CobSD2UIKyGRy6Eqa8T5sx7OfrBVdNK0WvAX0z1tGYw0PSiqJKU1xqJrwq+DczuXI8N0SFl9Faj4/jwvKAnKnolqyeuUrCaswsE7RB4Jdvw4IhcDwEACaUDl+zbHZhv2CD63S5bOsEinRD6yuyf9hT6w6hl5dlImUcCUBt8EOkyER0+m6KNOsGXikBx3s+WnY1zPWPBzoRk8FTs3ry7xWjSfaH4yBMlvKm/QluAe7jv2PWKeP2hKujfJufenj5jKJAtHQYODi0lfbCTKUbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BL3PR11MB5698.namprd11.prod.outlook.com
 (2603:10b6:208:33d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Sat, 3 Dec
 2022 07:50:28 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 07:50:27 +0000
Date: Fri, 2 Dec 2022 23:50:22 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, <rrichter@amd.com>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 11/12] tools/testing/cxl: Add an RCH topology
Message-ID: <638affbee7b98_3cbe0294f7@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993046170.1882361.12460762475782283638.stgit@dwillia2-xfh.jf.intel.com>
 <20221202170407.0000030e@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221202170407.0000030e@Huawei.com>
X-ClientProxiedBy: SJ0PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::11) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|BL3PR11MB5698:EE_
X-MS-Office365-Filtering-Correlation-Id: 517970dd-e722-41cc-3a6d-08dad5030a0d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Ony2PWjT0uSeZMUSXqOGDzVEDH6pid/hWrezxKf+aUJ+L+ztpmxPfmSgHx2yK6O4tYZezWupLg1UPjOKFMiuY2YGy93ueKZti6pNxwCDziFeT1jEKtScwxl/CPADKOArH8Gru4TYGTKgLwHA9tICg5eJZPYq3M3THEsoOzAzjpi046isMUjKmfU/ibkgUuydvuHLk0QtW1wHClToA8eBpB+kTDqWF5ggT40yGUFVUyjOCaGqlRqH6aqcEWwyt6YSVbqYQZGAmBlNrIo2ydPv9BkpeC0PioOT3IisuRSBWpCjtDK5mo+k9pkMotAVb7aMivGfhRr8vzNHoW/n9Y/mulT7xOrpByetLB/5IDZip8paDK94xzxXEVnOuVCq5Ik124mGMzmEDYbm0Q982uQYsPYW2fPvpVVIz+Q/ACwoZDIe5oH0ky4QfzCQDnnW2l6ey0sXjbpGS01EvyhsE7ILkxkpXQg+7o4UF1ERkRAJLnbULd2icBCHlPIVu/CZjaFUJghDTauXtOGUzsj40Bdmo4Mpbrn19mvV70zS4X1KcM1KCMZNAlSnSbBgM2Lt6j9+DcpszHxnA/0GbV++P8D9/lcMP5UasARVwNLuKEngwWOhXSZ+UObgmkp+EmnHIik7guC9yGEjOgToh/OZtXVIxsruVwCHAy5PuCeIdtXSpk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199015)(26005)(6506007)(6666004)(6512007)(478600001)(9686003)(966005)(6486002)(38100700002)(5660300002)(82960400001)(86362001)(186003)(83380400001)(4326008)(41300700001)(8676002)(66476007)(66556008)(66946007)(8936002)(2906002)(316002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vrkhycbGcJqFc2vrQ9Jy7Y6zpgCxYfHtCAH/UdCCxFONb5dv9EYqHmZK1t9A?=
 =?us-ascii?Q?eyk72MeKQwL/XN1/HUrtDk4+tx3vdNTLXSkNXEWzOXZGR/MOARZzBzQ5SDG/?=
 =?us-ascii?Q?l0a3+VbRn6Cwnq9AOWPit++Ayy1aeocVxcLjCPkGjK6jDxbhPm3TGFjSqeVD?=
 =?us-ascii?Q?+I/RWgX2JBRigO474j4KatW4oHynAgB5ZG4vDoFnFkFytmxKcrQgJ75uXQC/?=
 =?us-ascii?Q?2E6x9PDUhRK/r+PMVyAAb+zvh/EczNiBFJjTPVvHl2c0KFki/NjXCjUBiuAk?=
 =?us-ascii?Q?l0h4tziYv6JaXMs7JaZvqcXtdQla7AR9AFtl84mdZYomN7p1HFW7O/cfjM9i?=
 =?us-ascii?Q?gV/7tr6EX+hY0JapSyuufZONshP/2g+9veFRqsZQqS0TV76TOOBXjxYd24gI?=
 =?us-ascii?Q?xVTaPwxkAkSenCBIu1odaze1KjbukO/00AUPCazoK1bem2C5PeNPG5bnF/p1?=
 =?us-ascii?Q?zCg6ii34v8fXAxeukF6WqPcrmp7ioBKaJZNQ8nio+qLIYOauozNPFIKZJRjR?=
 =?us-ascii?Q?4JbCDgzIJNP82ifYjqnGXGkczkYTeisGL4URdC6i+4ISDpJL2igLoFnUUnf3?=
 =?us-ascii?Q?06sAFFyUWoIQxZaGzjHd9UTK6/6KJh8e2uJ6kqHdU6h9GMrjbdJ9NMTf2tfA?=
 =?us-ascii?Q?xZo7TSPiCTA/vSKWs+mfth8KF9RTz7ww+glFzkvSXIVd9Ou7XSCcuTy8pEzZ?=
 =?us-ascii?Q?SdlOM5xvPrQSxlVs1Ibz0vV4hdhV+FReKlj5m7NYIEwN10X4JWT3GneWtyEp?=
 =?us-ascii?Q?N0bTcD9W7Be7eEPb48rhKrozZTTBSEEHwVJPf8vRGhLCuViPSSqEpted7Pys?=
 =?us-ascii?Q?6/keJ+y6OI8yFkynDTxKFQz7pR7/cWB/OWx0pG7l+Xiy27tbVCPK6qq1Ggys?=
 =?us-ascii?Q?chrmRJkBNpIIWyQYDQQgVyX3BAYWKJCJzwwNVhqCz75m2KrmL4592+husGa2?=
 =?us-ascii?Q?MQaDOdbHaUcRp56mgTYPdmr3msvWysu8RCF5orXaMj6naZXZ2LQbDLcoXqFb?=
 =?us-ascii?Q?rojvjL+34/Y3PLhPdu01eX2Dy2DxdUQUtOoQwq9MQWSyUEt5xtinsLJHT+zL?=
 =?us-ascii?Q?R8U1tPs8Z0f/q9P16pk8BSo/20isx2hwuUVoZUvvGfBs00JQAjJjpdNRWTCC?=
 =?us-ascii?Q?jdCQhUmdKVkgHTMik9jU9PL3QE/jIvThl8PRoN9B32rnB+UuGIVZnGCm9ca3?=
 =?us-ascii?Q?AoAnKmTgLt/VlrelbVZcqB57/qLRqtiXVX5jzDlpVXEIlM7xXaQAvxSM0VWF?=
 =?us-ascii?Q?ukilVhNPLQZjJ1m0zS1mycA8ji/hybWwf2WOe2/D6QM2QspctqMsgjfZsKGA?=
 =?us-ascii?Q?Wqx8hXyFNv15I8jfpLuPUFSQPeVuPYmgXKbvB+vWrJ1/HH9Hxvnpjlh3aQL4?=
 =?us-ascii?Q?KQa2ST0M3DDbptYIuTJ3438NuDhylCrP/oB5VNNyCnCi4lVtUpnG07kvSOvp?=
 =?us-ascii?Q?E2e7s0LM3osQrS5z1nazVGLzkJqJF7ngilhbhC1gsdCgLNIG2eRpXsLiYe+5?=
 =?us-ascii?Q?UQwX0n+ytheUT1+N8oolUKDAgnQOQn7yOEyx/+cxwcEfpewfUY1XNCrkUiMH?=
 =?us-ascii?Q?4LQRBaUdkwOKozRjh7z6zjZeZH1bOUO6TSE2lJmXghkSNt4hwUdBGl7FWny7?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 517970dd-e722-41cc-3a6d-08dad5030a0d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 07:50:26.9883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: maB+qKuGPrhmt/skc7YwfxAE9LUsK6GfWy5dNWewWWO+jiwmgJrnHXz/HsH1oPBLeWB9TzZt2bQd5WJZ9KSZOJFcZcG1at7mwHcAp2TGC5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5698
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Thu, 01 Dec 2022 13:34:21 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > In an RCH topology a CXL host-bridge as Root Complex Integrated Endpoint
> > the represents the memory expander. Unlike a VH topology there is no
> > CXL/PCIE Root Port that host the endpoint. The CXL subsystem maps this
> > as the CXL root object (ACPI0017 on ACPI based systems) targeting the
> > host-bridge as a dport, per usual, but then that dport directly hosts
> > the endpoint port.
> > 
> > Mock up that configuration with a 4th host-bridge that has a 'cxl_rcd'
> > device instance as its immediate child.
> > 
> > Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> A few trivial things inline.  
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> 
> 
> > -static struct pci_bus mock_pci_bus[NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST];
> > +static struct pci_bus mock_pci_bus[NR_BRIDGES];
> >  static struct acpi_pci_root mock_pci_root[ARRAY_SIZE(mock_pci_bus)] = {
> >  	[0] = {
> >  		.bus = &mock_pci_bus[0],
> > @@ -452,7 +493,9 @@ static struct acpi_pci_root mock_pci_root[ARRAY_SIZE(mock_pci_bus)] = {
> >  	[2] = {
> >  		.bus = &mock_pci_bus[2],
> >  	},
> > -
> 
> I guess fixing this stray space here is fine to avoid a rebase to tidy it up
> in original patch which you have on your next branch.

In fact it's already upstream in v6.1-rc4 unfortunately, but it has no
business being in this patch.

So the hunk is now:

@@ -452,6 +493,9 @@ static struct acpi_pci_root mock_pci_root[ARRAY_SIZE(mock_pci_bus)] = {
        [2] = {
                .bus = &mock_pci_bus[2],
        },
+       [3] = {
+               .bus = &mock_pci_bus[3],
+       },
 
 };
 
> 
> > +	[3] = {
> > +		.bus = &mock_pci_bus[3],
> > +	},
> >  };
> >  
> >  static bool is_mock_bus(struct pci_bus *bus)
> > @@ -738,6 +781,87 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
> >  #define SZ_512G (SZ_64G * 8)
> >  #endif
> >  
> > +static __init int cxl_rch_init(void)
> > +{
> > +	int rc, i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(cxl_rch); i++) {
> > +		int idx = NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST + i;
> > +		struct acpi_device *adev = &host_bridge[idx];
> > +		struct platform_device *pdev;
> > +
> > +		pdev = platform_device_alloc("cxl_host_bridge", idx);
> > +		if (!pdev)
> > +			goto err_bridge;
> > +
> > +		mock_companion(adev, &pdev->dev);
> > +		rc = platform_device_add(pdev);
> > +		if (rc) {
> > +			platform_device_put(pdev);
> > +			goto err_bridge;
> > +		}
> > +
> > +		cxl_rch[i] = pdev;
> 
> Reason for this suggestion is below.
> Move down cxl_rch[i] = pdev;...
> 
> > +		mock_pci_bus[idx].bridge = &pdev->dev;
> > +		rc = sysfs_create_link(&pdev->dev.kobj, &pdev->dev.kobj,
> > +				       "firmware_node");
> > +		if (rc)
> > +			goto err_bridge;
> 
> to here, and clean up this single loop iteration by having a 
> platform_device_unregister in the error path above.

Ok, makes sense.

> 
> > +	}
> > +
> > +	for (i = 0; i < ARRAY_SIZE(cxl_rcd); i++) {
> > +		int idx = NR_MEM_MULTI + NR_MEM_SINGLE + i;
> > +		struct platform_device *rch = cxl_rch[i];
> > +		struct platform_device *pdev;
> > +
> > +		pdev = platform_device_alloc("cxl_rcd", idx);
> > +		if (!pdev)
> > +			goto err_mem;
> > +		pdev->dev.parent = &rch->dev;
> > +		set_dev_node(&pdev->dev, i % 2);
> > +
> > +		rc = platform_device_add(pdev);
> > +		if (rc) {
> > +			platform_device_put(pdev);
> > +			goto err_mem;
> > +		}
> > +		cxl_rcd[i] = pdev;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_mem:
> > +	for (i = ARRAY_SIZE(cxl_rcd) - 1; i >= 0; i--)
> > +		platform_device_unregister(cxl_rcd[i]);
> > +err_bridge:
> > +	for (i = ARRAY_SIZE(cxl_rch) - 1; i >= 0; i--) {
> > +		struct platform_device *pdev = cxl_rch[i];
> > +
> > +		if (!pdev)
> > +			continue;
> > +		sysfs_remove_link(&pdev->dev.kobj, "firmware_node");
> 
> Had to look up that this was safe if the file doesn't exist (it is)
> I'd rather not have to check, so maybe make the sysfs path
> above clean up the device in the loop iteration and only set
> cxl_rch[i] once the loop iteration can't fail?  See above.
> 
> To my mind doing it that way is more 'obviously correct'
> which is never a bad thing.

So this also dovetails with Robert's feedback to move this error exit
block to just call cxl_rch_exit() [1]. In turn both of these feedbacks
are applicable to the other setup loops in this file. So I am thinking
this calls for a follow-on patch to cleanup all the instances of these 2
patterns in this file.

[1]: https://lore.kernel.org/all/Y4ZwXNpwt83puF4W@rric.localdomain/
