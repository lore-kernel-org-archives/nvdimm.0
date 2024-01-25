Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FE613A27D
	for <nvdimm@lists.linux.dev>; Thu, 25 Jan 2024 22:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706220441; cv=fail; b=WvlbcNV8X6SLL77VLoydsreMPqNT/H3jIcoagQrWSfe5x8AjaSujXAawgjTID69tQOjQn20XwpUDIIB8BrRN427d7XGo8QVcK3zMXO2piXK+9tAuX0aOqX0gOKl9p/t0KwIF5GOULsRnb4/R8K3W3Jx9z4b1hGfmshtgnwuZ5gQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706220441; c=relaxed/simple;
	bh=MdxTnrrZBh8kjtkIRaD8jOlKtMbQLQlso1V9h7DNmG0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WqmvNp+rlRCBoMb+uOaKbP5TfEWQPGLyqNqbB6UTz+zXJHPwjdirrsZJZ/ysSljcYGXj+sr5lZhC5+pjBhVe6BDQGqv2o5CqmivUvNZ7cFkgELm4Vgj2oxmsR9/D8CywXAmSxNVxF8idsxgyaTZLhNII6Sqb0yLduT5x1Fwrj2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h05M8wRQ; arc=fail smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h05M8wRQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706220439; x=1737756439;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=MdxTnrrZBh8kjtkIRaD8jOlKtMbQLQlso1V9h7DNmG0=;
  b=h05M8wRQ399UAa3wqJyJnBcU3BnxdnCpheN0ixKBf/PAhOOvZk/E3Tf7
   5+RwfxHmNKP/dQJzqxt/lqONa/1RonQ6+blR2Y9npvLAmv/nWGI69DGAG
   OSn+AEMbkxxQ5eGwnQRdGFClrWrrTKVl/lLjz4m8ZBRRTsv8FPTlvae4V
   hCRWnXQCfMxp8Hmr7c1eycXbSTIbxt6aCnhJGRkrIZZClIOg02vFfF4h3
   IWW2+RKFx9B0Z2T3eygiAPbj3x48qMoVdHZbZ9o6mCXduOT5Iqm0TJCqs
   7Mno5XIqArNwOIIjcoH6LpyTl41QIQ9YzX2XkozNYHYy953hJ0gHpGcX0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="401970625"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="401970625"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 14:07:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="820936290"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="820936290"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 14:07:17 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 14:07:17 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 14:07:16 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 14:07:16 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 14:07:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6gbFrd81DvRrjlAAW7Mjl/FaJ5fxdpk4q+FNk9Pj3q6Yu3V6IdPwsSw8anztx7pZ56g0dq24Mkpcaqpa/S4ZJVgJRcVWcYT7Pg+Aq5akVuqMPNuUYA4ukd3pu/GT5eEIO2+myK5UzCHNs0R2OrU8v+Dg/wVzcNxfOP4YxLKhCvviyfC5TxhZnUJD+5dCFuv0qwmrnZVOd1j9Bn5mgZZKU7T/ztLKojCWMz9kTT8EGQT2u0L82DpO1SNurImw5+ZcL6E5JhnHU0jxRc2qr0KCLf8f8rwDeanC3B1FxwO3w1Fsc1LRumLWkKahI9tCJtzm43FH2GolPTdZ6gMdtb+Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RsOFraOjgq9jjEPV8NWatu1AjJZ1AymThLBmiv4oFTs=;
 b=DfOUSR/N8N589o4uILTxeyuq3S39AK4fOYYEWk8RhGPKkBhiWZVR0Icz7M2a4Q6KyvffseG31qILPCm1qfRwZ2OBPTuJNWXlDwD3yweqXGy1E8sWEpNACxYLMcWJO0nH4XrCBPSiZPOty38RPhT4lNA1ftXjTBDjAFAQiaLGkAlZ8BsNdLemQjWwAnrOvnHDrpherTzYASmWPdJZ8F8L9LXxHDJOdMnm/Zy4zOoYHT8b69TXNEX53PaCQsyQ+ysyxLpWHkaujWTwjYBXAEhSzGql+gN3fIWy+MKXar6+UxUYL6c0pfl/EJlDRcw2LQwYY0dUz2iHWYYY+oPBxD8V4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA0PR11MB8380.namprd11.prod.outlook.com (2603:10b6:208:485::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.37; Thu, 25 Jan
 2024 22:07:13 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7202.035; Thu, 25 Jan 2024
 22:07:13 +0000
Date: Thu, 25 Jan 2024 14:07:11 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <vishal.l.verma@intel.com>
Subject: Re: [NDCTL PATCH v3 0/3] ndctl: Add support of qos_class for CXL CLI
Message-ID: <65b2db8fb7587_37ad29483@dwillia2-xfh.jf.intel.com.notmuch>
References: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
 <65b2cfa5d3541_37ad2947b@dwillia2-xfh.jf.intel.com.notmuch>
 <b1d5d419-7625-4c88-bf9b-50736662f330@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b1d5d419-7625-4c88-bf9b-50736662f330@intel.com>
X-ClientProxiedBy: MW4P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA0PR11MB8380:EE_
X-MS-Office365-Filtering-Correlation-Id: 53c0a3c4-66cb-4f5a-46fa-08dc1df1fc3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGdvrxG6DrmXyKKsdvBHer06/CdQlPsjK0DebOZAVenWq9rsQ/4g7n4DPJ/PmCNpYs6bUDVRuFxNzI9NgyUvvSyc5uD9B1FmTnQCLu0Uh/1rBSHmviBichfmPcsrdXNiRoUhSn75xy3d3r6/BxlTAZmmrgLBp52LjrjQBWwyyBT0c4CK6sl8BkxDZhBvTletQW2xtkRHiPx1EECXc3J9P9wHAAy85tgW4p7aj/SvrVl6Mtf+3wMZFuenC7du8lRX4KxlsIPdEc7z2GSZ0kvS5OCTNlyVFDxpDXZP8xBZeBk/f0vfJtbanr52rEd5mDKhvD9H9e/9Ec1eOXAkC6o44kzDDgSWbXh9VthyXOEZtrujlxMQthzsPIe3zf7O8Dh92KSZKUsGMlNvEPnrJXG2nfGkhHoY10wHPgTb3I/9CJwwvi4n+VjYvkj8xaf7PrVf+ibB3mildf/rBOnrcquBOULPIed12W0e5DF0+giiGLyxofVe5l+JxjpUKBk8AignFAF8dbAu6U3mbQUZMaIuOAnRjZ0DSB67My0hor4MXMCSnG5q22Z8CDgRn4NqzAnR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(376002)(366004)(396003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(38100700002)(86362001)(82960400001)(316002)(2906002)(66556008)(66946007)(66476007)(5660300002)(110136005)(8936002)(8676002)(4326008)(26005)(107886003)(83380400001)(478600001)(6512007)(9686003)(6506007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L2EDCuTvXC9hVBXhaZ20P0J0dtpbP4g5TbhYSnrUBwGQdUSAFuR5t6HRG2zS?=
 =?us-ascii?Q?6a5tjwjXir26XwRLqHofbmKSxZON9ul+QpRTLblO+7mQn/bdZ0XW5aDtfLbh?=
 =?us-ascii?Q?sIsmhFgtxhq3Kx8TsLscS6l1XWa/YKYRglinIcw+kOGzhfEbOmPLJ5XK60u3?=
 =?us-ascii?Q?LFokA3lxIoyRKsez3qXRyPkfm/GJl1z96vORsoQ48vMnIpQMpLCyARAcokck?=
 =?us-ascii?Q?5Ey4Vu3fCLD9TqmuaI1gdNAYyq+NkDjttydcvtnODJ6/n2qEJBYu7KVS5IsE?=
 =?us-ascii?Q?XXORr+0SiAUBTCD2YsVtPa9avuRKyYZVc5CpSbHf9YhPdnmCBt6lW4NVrVs9?=
 =?us-ascii?Q?00jeKf8MHRd30IAAoBJS4BW5LhmCh1hWWJKon9s7zVi7+vnEDOpPJnXXedW/?=
 =?us-ascii?Q?nBghqXNsOGSLWrLx/J0XTq19Gm2D/JIp92T9h3Prvj//JlIP+i+6VgD0szbn?=
 =?us-ascii?Q?Mmr44A46YNsNTlsZI8kCo+J+Z5r870dSOOo4PSxQ5XVyKnERGsuupBIlC3bG?=
 =?us-ascii?Q?7YcI4kVuxG0cHxuTyjyRE0V+PM22CrlbgckY2q0TypEo5shyu9UVzNj6N0st?=
 =?us-ascii?Q?ZhC8iUMJx0wLFw7iMsBV3XZVqja7CKWpuf6n0C/OqSmDcAFPduPi34M2yklZ?=
 =?us-ascii?Q?P+WmO4SS5g+PI4bdSPq/JSZxFpPdFZ/Mv63p2Smgci8bsVBI5hS/r3eQBy+d?=
 =?us-ascii?Q?dbFzMZxX2TcJ4V9H0g+b+tP3vl5djSSUhQ8EgG0bLoUcCfmKtBzqxw3N0z9f?=
 =?us-ascii?Q?PgUI7OUBF8881jKWJtncBIDil6LuWnZLo2WAZlBz0X2FwPjfU2vhgtMAk2Ce?=
 =?us-ascii?Q?aMaOClcJ0kpyWnNzpMaWISkY7NBTdQUTUo2tywLzlyzDJbiCXj7Pz+hbv3cL?=
 =?us-ascii?Q?t85pP3yij9kwimijWyUgjXZUYxwIMxt5FiJBGUhbo6aoh3yPIE1HeFZbHoGp?=
 =?us-ascii?Q?6b7rOPHmgtAy3LNGVrM+lpjoutHYKTB7SZZAzsKDLFh+F6GAnXTcsfdXcVxM?=
 =?us-ascii?Q?wnWyD+TpMlx9+MuXwsjfOvV1gvFvk4S5PRWHHEYYl7FryYlhpsTUW6AHtHKr?=
 =?us-ascii?Q?kyvGwC28VnrX43ajR/G7lMmfGT1i4Tqtou9/OxsMFfjTHeFxu2uiIjxXhYfB?=
 =?us-ascii?Q?HvxjtSwlQl/jcO2qnFUtkqS9eLWIWsukcAQsQyV+Myg5A2WVd3NsFgKzbNPC?=
 =?us-ascii?Q?t6yQezrHm5zIobXguf32Xt227hLZKwkR3O7PMYoXOzfvIybjU4+/bot0rgV7?=
 =?us-ascii?Q?h71hj6KTis7iG7r08Uq21C5wBc2+zenFDyNMJQPnLbCnOTZPabTd+TU22Fe3?=
 =?us-ascii?Q?K66/QPyzWIujojaioNX926XD5gt64KmoKJz9Ze4SoiCu5+TXtoJzB0YrA1ix?=
 =?us-ascii?Q?QH/rtu4CgL6UClI1MSQiqi1DZDcDtKtYUk3fFQDPZw/kDDUh8GSSREuI+PlW?=
 =?us-ascii?Q?6ZIUNCSZrBtZPUpD1wW06FBhKS4wtcO7M34N/tXWw8AyiEtNvcgwV7PHs6Wv?=
 =?us-ascii?Q?PmRMUb7JIn/alJBHSmvA1imU/1EFgbtBT1fS0DRj9UftfxovbQlho+B0yf4r?=
 =?us-ascii?Q?kZj3PaC2ZsKHGfD1tMXsIca/0mNzZj1PW+KkSqx9+CcQ9jGhusmIirhie+Id?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c0a3c4-66cb-4f5a-46fa-08dc1df1fc3e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 22:07:13.7201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u1QDifobPjUxjw1noCuxOUcsfkd9sXvLCZnNZpAqKe+l/RcCx1+Ss2ICWvmD6OycVo/HCwiZkdhU0FYzVsTmA+vHNcuvirXt42iyh+JPbnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8380
X-OriginatorOrg: intel.com

Dave Jiang wrote:
[..]
> > This needs changes to test/cxl-topology.sh to validate that the
> > qos_class file pops in the right place per and has prepopulated values
> > per cxl_test expectation.
> 
> Do we need to plumb cxl_test to support qos_class with mock functions?
> Currently cxl_test does not support qos_class under memdev due it not support
> CDAT, HMAT/SRAT, and any of the PCIe bandwidth/latency attributes. It only
> has root decoder qos_class exposed. 

Something is need to avoid basic failures like "attribute published at
wrong path", but it does not need to go through full CDAT emulation.

I would do something like the below where ops->cxl_endpoint_parse_cdat()
does not need to actually read any real HMAT or CDAT. All it needs to do
is fake a final cxl_dpa_perf result(s) into the right places to make the
sysfs attribute show up.

Then we can do driver shutdown and access testing with the attribute
code to get lockdep coverage and other basic checkout.

diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index caff3834671f..030b388800f0 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -13,6 +13,7 @@ ldflags-y += --wrap=cxl_hdm_decode_init
 ldflags-y += --wrap=cxl_dvsec_rr_decode
 ldflags-y += --wrap=devm_cxl_add_rch_dport
 ldflags-y += --wrap=cxl_rcd_component_reg_phys
+ldflags-y += --wrap=cxl_endpoint_parse_cdat
 
 DRIVERS := ../../../drivers
 CXL_SRC := $(DRIVERS)/cxl
diff --git a/tools/testing/cxl/test/mock.c b/tools/testing/cxl/test/mock.c
index 1a61e68e3095..9133cae1f5c1 100644
--- a/tools/testing/cxl/test/mock.c
+++ b/tools/testing/cxl/test/mock.c
@@ -285,6 +285,19 @@ resource_size_t __wrap_cxl_rcd_component_reg_phys(struct device *dev,
 }
 EXPORT_SYMBOL_NS_GPL(__wrap_cxl_rcd_component_reg_phys, CXL);
 
+void __wrap_cxl_endpoint_parse_cdat(struct cxl_port *port)
+{
+       int index;
+       struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
+       struct cxl_memdev *cxlmd = to_cxl_memdev(port->uport_dev);
+
+       if (ops && ops->is_mock_dev(cxlmd->dev.parent))
+               ops->cxl_endpoint_parse_cdat(port);
+       else
+               cxl_endpoint_parse_cdat(port);
+       put_cxl_mock_ops(index);
+}
+
 MODULE_LICENSE("GPL v2");
 MODULE_IMPORT_NS(ACPI);
 MODULE_IMPORT_NS(CXL);
