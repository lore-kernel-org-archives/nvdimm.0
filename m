Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D95A8460
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 20:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669839875; x=1701375875;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=i/CyDuY7pP2d8LYGwdYfq2e+qPCBM6Xnmwty3gb4Q+A=;
  b=HRsDN6dJFB8fFiQKm88Q6b9ZprL8NJvhGxWrXj6UGXflGh9ueD/RWAwo
   OuHIH/TtbTlpPP/+d0ik8nRbBc1yTp43670KTwaCu0v+qqUYPxFrj5Xkx
   TSpkAI/EkxSESj6NaOcA5W2PziVWQq/CcGVtaZchM2o/NiwqIVZe6qYjr
   CxP9zqMF1dJ2YOFxFf/Qq+4rj+yjTa+rzIjj1kZXq0w6JCJXMPGFNPRRJ
   LurvJ2wDn29R7ad6JkM6enY2ZEq/fd6EOSn7KbLfnRyaX6fMRDZHyE3mC
   3an2547VFvrtrO/ugXJ9X8oV3tMwgWf/xMdaJYonGVJuYOMXHpyuy/jYs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="377669067"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="377669067"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 12:24:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="973245859"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="973245859"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 30 Nov 2022 12:24:34 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 12:24:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 12:24:33 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 12:24:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GV5lL6yZwmArv8XX4mhbgEuOUUeQdbaHoiGWeC14ZB7MRKpNxaxySAJEBNMjiRKqG0LtMVFAfN+JDouuWCnWcIA+3JM0j+nFw3NgIK0kNtX4WuFxjIN2yO92RHIY8bOPR2OZ0lXhvcBGKWVxjFK93JxQiL1zWg6Q0bHQTnyZpjMroZ30zy3tnF4NpTVReS2UFfxOeYTtNuNEptZkNisHXddFQcqER71DTaIG9npHLAUTItx22tuN2mIEBkjhgcL4vfXAGPv+uobgqiWZg63xwDRyDgo/3z8TOHc0JCG0sTvishx287N8nqOT8pe73W2GgmxYgacluF4z/SCN2aGEew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQuIX7eqLVYfWmim/jQrpMo6QkVAPIPN+WsoqLKxnrY=;
 b=fiAAxg6X6BEroTimHlmDQDMDY4qJYJscEHFFWikJ7DE6brznM6bJZow55Qo0jAKdbsM4BAqg0J+dKA4xBDp9GTl8S3+21j+WKc5vNbG6goYLIu45BxPKBqA6ckULhZWqWcm6yQYXszllge0tFqjbgk3JDXHGyoSBx2yCYmTfFM4z8Qt9dHzboZv/YDuD40FBBza0MawHmQjMpqCCz/IrKr6as7by1Nb4LBD70MOYjr/G/8oWPDta4dzmBqMElNHUL5NadC+hSqO1EDC7CECDjEyTEtJVON/KBMGc0EHUsDSqWyPlkMq4zH0LoOt5Zx0IEaVcMZN1mH53g17dBSTpiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB4863.namprd11.prod.outlook.com
 (2603:10b6:a03:2ae::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 20:24:31 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 20:24:31 +0000
Date: Wed, 30 Nov 2022 12:24:29 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 11/12] tools/testing/cxl: Add an RCH topology
Message-ID: <6387bbfd385db_3cbe02943@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493816.2104015.8749844490243672146.stgit@dwillia2-xfh.jf.intel.com>
 <Y4ZwXNpwt83puF4W@rric.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4ZwXNpwt83puF4W@rric.localdomain>
X-ClientProxiedBy: SJ0PR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:a03:331::30) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ0PR11MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: d240c98a-9349-4a91-8102-08dad310e354
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxkroGIAoN/y9ladg3O0v/rMY5eU1INxI5UmK1xyj5OdUvAi3kUIssASaZ+dhVjx+/KDIcLurhRzBBMOAFZvTG4/GT1uA+LYQPqgANk9E+czbn5+vZRYg8St+RsU6fBzDSs4JUfVu9Vwdad7HQ+4JVONFPnOmxMIj9wI6KTnKFQU1x2LIxu4OmA6enHa9X+XSpuFAPuM+hwCs9IyObYh+EDIpPpbHgC9M1o6nc6D6mh1z3TaB/RiMYm74km3l7ZKM4xiJcvDpLT7iqqu23EswlZewbpBFzvr49VaoojzSJohYfgJ5ntzEewwEMcTfRmH7a0SxzxBVZnZvHczoK3FPZkAUQ1jWmPsXqq7doy51BSO24ofWD17kmnzXZ3S3APw8BpNxIOqx0mEa2G1D3FDW7F1uTPKZMRii9P3uzwv6TTHVHnxM7MD4aK1+QF55nGXe91TUGbE4xby470WXVbWlYa4oQWESae2uGhqDw7bWs80EyPlXlSu6d1r5gxPz/3VgLJam9cL4ro37UAc6ls9US7shxEBOu418Kf+xxXmmQqXFKWYITTvxNay86tsLo54IK57Wbt1GfPMc69J6qzChEkndkiHI6kfl19uEZrepB9AqjjxCJiF9bWthFn1mHI1mXJOPIJW6o1iErntpO94tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(346002)(366004)(136003)(451199015)(41300700001)(8936002)(66556008)(26005)(53546011)(66476007)(8676002)(9686003)(6512007)(478600001)(66946007)(6486002)(6506007)(86362001)(83380400001)(4326008)(2906002)(186003)(110136005)(316002)(82960400001)(5660300002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EUQ3RaHi7nZakjXieBc1pRGr3t4wjySpTIU3fmB6kT++CS4WuqxNi4BqR8a8?=
 =?us-ascii?Q?V2yqF0Ntcxehp8czL7eqvALGyZK7FUfBsYbQDXYktWaFIxwRj9hzdzDnPlfL?=
 =?us-ascii?Q?WYk4svxSS/164WDLY2WLmPKtbxD3B3yBINLvisVOte2H8nH4+tuGZcpz9+be?=
 =?us-ascii?Q?t8jntgBkoD/y46UTeqLR2nRgCKsvOfA1N3VfuAv5R3t3YuJf2jmlQX3zO7jP?=
 =?us-ascii?Q?fGO/i5cJDv+pE1Zr2GQO4a7c0fjYhxswYemtc6c0yqTvY+0i/bM7tJiAUWsP?=
 =?us-ascii?Q?Qia5TlnvGw1Y6BY1GB6KED27Cknu157vp5F8fIHsC00K47UT2TBEMHzw2Xa0?=
 =?us-ascii?Q?pwtzXGCB94d6eW2GO0+x8xslmxDJ8MDI1DES7l9EWRslpV4IBhNTiFJQTlvM?=
 =?us-ascii?Q?eolfHjWg3RbsYlaIgm3JcSptd0dEBnZRFZ1NPEC1s7irfrPN0qpy5wQsZZ0D?=
 =?us-ascii?Q?9fE9s+x4DeWh5Xuz64DzCHUHAKOU0krNNV7NIQEn4uZBFJK+iiOXohYjr6r2?=
 =?us-ascii?Q?lM31Fm4z5RA+hY4T5HMx9a9Ds/IVLB7fKbDIEm2R+Wh6RzK2sb+TNNRiJmGD?=
 =?us-ascii?Q?g9j1vFKFcsoR4XjpJJH297MI9sopauW50uegwfspOCTy9eG4R4kVzh2yOFx4?=
 =?us-ascii?Q?COe6qiEPOOaI5FJBl2Bin16S8m4Ma7wVrGDR7qlApJrx5t2bC/KWlyiJgrOB?=
 =?us-ascii?Q?aJ27Om1wmfMJa0Q1zaGaZF2Uf1iFlA0mHZMp3+Xh3NZl+TlvNBdK6P6Qd1ET?=
 =?us-ascii?Q?Zf8Ilf5pM5H+bns009mpT8HvXGEPZp3Ed+Qm+IXKvD+y1aT3CnpEB23aVhpB?=
 =?us-ascii?Q?L5zspHY/0AQ3Db+ka3pZIb6fZpNo4udqTczke+jzt8rmbYYhx+WJge/GMrKz?=
 =?us-ascii?Q?iTQg05Njb+pEv/qseLC6+ZJSw/046DaWVgNR6DB/VcodToI2vXcc0PmdU/Aj?=
 =?us-ascii?Q?5+/09K4Mqw7HtJ93LBLs2jNhKf317R4staEcAdAwtmtY3dJVY3CPRal37CLq?=
 =?us-ascii?Q?rJCPz/c4/pjsPi16OFVsmSt83PEn/WbkAfkXZS/ocTIJv5MEW7EEziVwrtlI?=
 =?us-ascii?Q?tLDtwxhDziyoWhSob7SRM6rhxGGeDbIAiS3cvhRv3iYOHmYR/jUDI2+wYpnb?=
 =?us-ascii?Q?vekGZNsVznjpNOfHwGmVjJs76cPPUWjFB9+iqjbqk6LAMEsRH1sbptJ97dFj?=
 =?us-ascii?Q?ONjwNlqzjOh5cvQ0OeLlJC+IvnUuPtR+rPBIUBUt70LQQB2Ll03SPnYZQOTX?=
 =?us-ascii?Q?Dce7hSSZ+gfBf9Opntim1Hw9raTsAIZC7mPAlztPzyog3CB/mrm92Z5SGFF3?=
 =?us-ascii?Q?GOUj1WqfhhKIp87lplpQc+oPUxCT8Y/7CZqGK3yCTjFT35Mv+osRye5XdVXB?=
 =?us-ascii?Q?aBiVWzvlmVCLSRF8fsIQqa9jmOplvvLDJLlF6i2Txeg3LLYaNG8ztyuxH5wc?=
 =?us-ascii?Q?Vspdr0XMi8OEJdx0AOO+NL9LNmXptilZA7EwB1fdxaN2UwO2E+mkA/4A79kf?=
 =?us-ascii?Q?6s1RlXm8fm1R+ImbrAmVgKE2Y8CoeGAkQW63y1b3ZEho3U50D76uRP9uA6Ls?=
 =?us-ascii?Q?r0TNgQzsRM1Llr6p1HvX7A7Fs9gR8ZQS+vEFoQ7stLMivrLevEg2zHGj6fek?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d240c98a-9349-4a91-8102-08dad310e354
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 20:24:31.5437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBjjgiPQA4So07GjucJaZaZc3lXoNUIlu6YObkdpzUmbFsZcKteXn4ezjnQ6MA7xatu+dxSzeSao3GgvVgSXy57kFZ5h6ctnmxX7j9okWZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4863
X-OriginatorOrg: intel.com

Robert Richter wrote:
> On 24.11.22 10:35:38, Dan Williams wrote:
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
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  tools/testing/cxl/test/cxl.c |  151 +++++++++++++++++++++++++++++++++++++++---
> >  tools/testing/cxl/test/mem.c |   37 ++++++++++
> >  2 files changed, 176 insertions(+), 12 deletions(-)
> 
> One comment below.
> 
> > @@ -736,6 +779,87 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
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
> > +		mock_pci_bus[idx].bridge = &pdev->dev;
> > +		rc = sysfs_create_link(&pdev->dev.kobj, &pdev->dev.kobj,
> > +				       "firmware_node");
> > +		if (rc)
> > +			goto err_bridge;
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
> 
> platform_device_unregister() is safe to be used with NULL, so we can
> have a single entry of this unregister code ...
> 
> > +	for (i = ARRAY_SIZE(cxl_rch) - 1; i >= 0; i--) {
> > +		struct platform_device *pdev = cxl_rch[i];
> > +
> > +		if (!pdev)
> > +			continue;
> > +		sysfs_remove_link(&pdev->dev.kobj, "firmware_node");
> > +		platform_device_unregister(cxl_rch[i]);
> > +	}
> > +
> > +	return rc;
> > +}
> > +
> > +static void cxl_rch_exit(void)
> > +{
> > +	int i;
> > +
> > +	for (i = ARRAY_SIZE(cxl_rcd) - 1; i >= 0; i--)
> > +		platform_device_unregister(cxl_rcd[i]);
> > +	for (i = ARRAY_SIZE(cxl_rch) - 1; i >= 0; i--) {
> > +		struct platform_device *pdev = cxl_rch[i];
> > +
> > +		if (!pdev)
> > +			continue;
> > +		sysfs_remove_link(&pdev->dev.kobj, "firmware_node");
> > +		platform_device_unregister(cxl_rch[i]);
> > +	}
> > +}
> 
> ... and have a single function for both. This reduces code
> duplication here.
> 

That's true. This was cargo culted from the other parts of cxl_test, but
those can be cleaned up too. I will do this with a follow-on patch and
clean up both.

