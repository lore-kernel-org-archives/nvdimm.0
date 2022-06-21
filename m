Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBFEEC5
	for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 22:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655850867; x=1687386867;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=154toP9I4tFgdJFNgxGbK1v+HOikAZHQlZQmTt7Db+w=;
  b=RRxuFlDx6bN+BVP0v4BG17AXqLNJNVLlujEQYyi1vTVuA5KlR0SilP8d
   IX59O+P7yKtlhfSVsizo56WwbsHUuvvehwvCMWWms19fZ17usAFnhnHRX
   bWao4EMzUaSEFimkuo2WNdaxImXugzHQRxYTDNjfZ34pGjBVRGubXEqmX
   37YW2JLBsf2vF2XB9mBFL8Lt2wPOrvec9q0ft+bGhgOTLM8RmlAXr7N0g
   7ChM9ADm+fOs3Ibyt216wsIL30hCf63mwYq9T0MnZDmBPIqYwUSZZegw/
   QcbkaIwb/xbDvEE1rSF2dRNNSrbRYnU/w4eSNb8iPb3F42E//iS5LN4c0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="366577429"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="366577429"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 15:34:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="690166087"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 21 Jun 2022 15:34:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 15:34:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 21 Jun 2022 15:34:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 21 Jun 2022 15:34:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HR803/ur7hCQvLWI5V/S1Pa873+BM5zL2bk6N6I4+T8Fvij2luntSTz6uTGU1CvxZVJaMRFU95oNtEXbRKw2lK89ta2p4+ve24vDTwKk0U+2+fjuNNb6UBttKj4CixVpHed7dpFpTuC+n72ITqIPR9E5F1ONdIBxOGEpvsT6rQTR16dU9buesm5LOG7mzh1lVK9DhBB6M9fxHDoL5khIuX9RErsjsKOZWtS3wfTCrV67PpIu0FQVyn/zPjUroS5Ozl0OWY6LBcWAjt+JxYmItDK9e3szV6gkfW4YZoeKWjYKyaw3D8ey7p/byHfUUCoqw1QWxbdEesz+IFkGxcWikQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTZXyiZsqnfZNh52zpIf6+ivtZbQv3z9hm037d/7FVg=;
 b=X6x9ZOS4tFcDBUiEiFjzXUk77gKYa7CaYBCLnOOkB6HbcraecXFrFWyuc+itGrUN/4DbJQ71heNPI5oWiHmP5xiaB+JEns65uxyIGe7RNkYOj5E2ZIqdyUH4Z7IGOXU/KsDL1AKffAJjwsljFVk751ZaepLB9XtGV6HGGr1/qRKAqfZuVhAt+9IIws0+GKlM4hPp9OBygNmutYbdSGBr0b3Bej9RMl/WTyTEmE13P8bPrqPv45IruPd2cgG0VHNhN0h/A29KOPxsSMnm9grGYFkpp959YFNbIo5ygi59z1LAyPzg7u2SAc3eResdn4dFoEQG9Kgb6K0EKQDabamD6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BYAPR11MB2757.namprd11.prod.outlook.com
 (2603:10b6:a02:cb::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Tue, 21 Jun
 2022 22:34:23 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 22:34:22 +0000
Date: Tue, 21 Jun 2022 15:34:20 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jason Wang <jasowang@redhat.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<nvdimm@lists.linux.dev>, <mst@redhat.com>
Subject: RE: [PATCH 1/2] virtio_pmem: initialize provider_data through
 nd_region_desc
Message-ID: <62b2476ca8c21_892072947a@dwillia2-xfh.notmuch>
References: <20220620081519.1494-1-jasowang@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220620081519.1494-1-jasowang@redhat.com>
X-ClientProxiedBy: MW4PR04CA0054.namprd04.prod.outlook.com
 (2603:10b6:303:6a::29) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a834898-6e85-4de9-c284-08da53d63049
X-MS-TrafficTypeDiagnostic: BYAPR11MB2757:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB27574C37A8ADD1A0866C85EBC6B39@BYAPR11MB2757.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GUTTC9SO+AoSQAFJrhBNqwVbDMAqNABkfqyfi8eevFT5exjXdRF5JXn5+FLGjGULyLbhcakQo4yMxuWfgXvgT3DRuOss2CAAco+CNYSjBOPqlOG5TGxtBXmpRv/VVeg0erkZkqNhdwn4QqYNBlXQ7Y26b77mckYcy42oIolakoHF6pQXOQ7+2yXs7TW9wzu/fVXd/sxVBOkAIeh585dERvOvVfqvI7ThX5DgUnjwR3WjDQxXlEu/2AEJSw9UhP4EYqP2bxqBJJ8Vq65nB8wIhVEhEw7MWDdOZzeQYikMueF7h1VCGmXtLEyUGr1LBFLWCKPP86ReodOw6aHNgTcegMcwFA2XiHoAZfdtu78twfOxr1jgWGyAltnqwes6xxGxKxqyX+ZQ+zlxTo/Ba7F34hhl40lUKz232nQmZrODjfvZ+fJErIzucBb7TZYuMqvx5Gr6dhqUr/4rJSg91QD9wlqEKkgzJu1OM0iv2PQCzj0Q/iKZ/LSFL0UaCODHXjD5JfKhVoVsd1C7K79tjrXEuOPoTHhmmv88RWcsAECZ6XOm5OSPwtFfQlswONXfA0uGaAqO+mlPzifDcDXOvo/KvB+r0ZHiF3++tluuiz9/hvRm0CeIbPP13jhNkwAnM93z6LmKIf3+Bga3ICmx9bYIlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(366004)(136003)(376002)(396003)(86362001)(8936002)(2906002)(478600001)(41300700001)(38100700002)(6512007)(9686003)(186003)(26005)(6506007)(5660300002)(8676002)(82960400001)(6486002)(83380400001)(66556008)(66476007)(316002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g4lWxH2yWvlm9+IKQ0p+ivvLy9zGRsUPLfHMVogDBEsTlRe1d3cSHRBawaFF?=
 =?us-ascii?Q?Snj3pznGT2m9x6gPT78N/Hvhns8xLIGh1Cth6F+yQYKliegz1lVzR8Sq+DQq?=
 =?us-ascii?Q?ie+kjnO3qhrUsKYaHXaiOVEJST3QVH+XURjFw3NP/aMTg61n4rGjldC8XXe8?=
 =?us-ascii?Q?h5IpWUGtyEe1+cmJtcvZrT8XwSaNFeM7X44OhYDsyl2xFOnIjwoe3VekP2W5?=
 =?us-ascii?Q?ZDGC5S0IF2BYtHwS1qusghYlO6ZVrKrSBW+n1ScFaVLU40KY7uayDUOH1ZVI?=
 =?us-ascii?Q?HzzTrX6p7LGBKxKv9VoKxXaK//SAAuJn5VTKt0B7C8vZuAL29+eYJ01Qqz2o?=
 =?us-ascii?Q?jmAf6on6N8pVx8XlfJpc0pLfZ1iuPIQHwiAhp1j/tsy5ZbOdsY0M2lh7hNDb?=
 =?us-ascii?Q?dVlc8jUZvKsMKynOIv22wM27dpvDssE5q2C7KyAvmIXJ/SKbDrED1YJOSH3V?=
 =?us-ascii?Q?GeoCLD+ulwiZ3w22tLvqm2UHnqSzYbUIBRjve6qm96VDAyiZZiKzf/cRwGYu?=
 =?us-ascii?Q?oNlD+BNoaODPHdGUDZSwaWN8N72KqJAnDSz2fZ+Lre6/bDtYGY9it4cW0aQ3?=
 =?us-ascii?Q?jnInGHQL8AZwB+WG+HoFlo+SwKF/J0h4OvwfTCmvZAOh0kSms5V8okLn953N?=
 =?us-ascii?Q?ziv6iiDhaKK/MhlbRqBPAj/0rjTJMwnE8tipTjRt4xnmprDDWYkfaPfl7+t3?=
 =?us-ascii?Q?D92JLoIZGR0w3wJSI6RDa5xVlb4M/zCMIjNpG+fEvdd2lAF12mKDxSjq5cqn?=
 =?us-ascii?Q?PkYBb0P5Gu0yIZV8jMS2KkkBHz2fN24vA605bQCE5slII6d+2YeJwkTPMAvb?=
 =?us-ascii?Q?m21kQeQUs89gG41bMFG9n3cjM955lUfAg3qL46duHCHyeXQFerP7fpwwzelX?=
 =?us-ascii?Q?bMmbeIa3L2wI8W7Luyvp5T5n3GTp30Vd0L5upsheMRkqhK+CuyqB10jnYwIv?=
 =?us-ascii?Q?Etbx6j+rRV4ifzXsmVnAaWF2kSzcZR4W3KO9+FgENthvt58djQv/BUH87ieU?=
 =?us-ascii?Q?/VNCkKLu4tLk525DRK8F+6ZbQzODKiRBv/ZoeGykcRK7hNWlLiMoENdtIt1s?=
 =?us-ascii?Q?PLHQJVe8kIG762V5/Zxmxv2ArIQ+u7VbYjQjPZtRIpRIUEgIjLeSfM/6RW5/?=
 =?us-ascii?Q?AKZwzgrEXZ3TxVCErZRhgy1mkVQ1xQfahL15eFH3AstDqcU+UG6HtaqWSW+C?=
 =?us-ascii?Q?sVGJtK/daSWuPzhd+6wi+t1SKVmzGXCKNocNGBlIWBcGEs1fZYAGt8PHNG9O?=
 =?us-ascii?Q?Vqlnbbzv9D+9splgz3WxsriCbeXKVbuaVJnyKkiBPUvLuzbDc5NtUOjhhSgH?=
 =?us-ascii?Q?QmSKntayHCoptoB9xie8QYpZ8J8lh97cWUjw+ZSmo3mAP024SxihPQw/36ad?=
 =?us-ascii?Q?HNrcyDbeQC6fXfd27xxjosi5IGr+EEmQ7m+GaoYtUpRHAYBAAq3kDVMTVN0r?=
 =?us-ascii?Q?VwzRd7COEf3X5522hqMJAsynNxcNfjxKL84QDvRBEXbaBP/iMeGvUZocBl5f?=
 =?us-ascii?Q?DTv2yYuxOL0jN0+OgJKYsUbZQPtU5g+iVGcLJYKb7bvXoVH0iMa6Jj8DGn++?=
 =?us-ascii?Q?M9kNlNhmkuqlRG+BdQrGuKoMs/QjxIf6QyCVXwxj6kswaf0rRf9sqvPf9WhV?=
 =?us-ascii?Q?XI1cDgHbcazsieUHudWHQAXVE4vWuiE1+qP+jVbFV2zd1w+wkWN+1n14cxUX?=
 =?us-ascii?Q?iPZXZ54j8BhutmuHeg5RuLnUS+7Dqv58ukDqXMGTYO99Vz4X9B4iiGzTcpQ4?=
 =?us-ascii?Q?OiuKSdr+zTKEsxvPfdVSV9hq/wjXen4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a834898-6e85-4de9-c284-08da53d63049
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 22:34:22.6937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cxtzi/BCIxrbCf+OvONG2nAmgdW41w9MpDFk4pviFyYQQBO0+fD79MsjIxTFoJ53r3j3UYzSMJNbTSe6qdgUn7L2JQls4u0+1rf3MWQ4Wzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2757
X-OriginatorOrg: intel.com

Jason Wang wrote:
> We used to initialize the provider_data manually after
> nvdimm_pemm_region_create(). This seems to be racy if the flush is

It would be nice to include the actual backtrace / bug signature that
this fixes if it is available.

> issued before the initialization of provider_data. Fixing this by
> initialize the provider_data through nd_region_desc to make sure the
> provider_data is ready after the pmem is created.
> 
> Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/nvdimm/virtio_pmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index 995b6cdc67ed..48f8327d0431 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -81,6 +81,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  	ndr_desc.res = &res;
>  	ndr_desc.numa_node = nid;
>  	ndr_desc.flush = async_pmem_flush;
> +	ndr_desc.provider_data = vdev;

For my untrained eye, why not
"dev_to_virtio(nd_region->dev.parent->parent)"? If that is indeed
equivalent "vdev" then you can do a follow-on cleanup patch to reduce
that syntax. Otherwise, if by chance they are not equivalent, then this
conversion is introducing a new problem.

Outside of that you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
