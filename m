Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1DD79DB
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 20:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669838872; x=1701374872;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+B2UQu4PIwCHelemupAmNZVGIIWjgQ1q2YBkVYh9dSw=;
  b=c6vKc46qPePuBNXPCIUjPW6GlNvACaZeFzHbLHc9AN6YGUd/KOrZjGGf
   kdkfr0an9msNBSh2Ye69qJWecw5uWWNZ5rgzEJJUO3nAByFhgqTQSV/7V
   IZHvLtvtu5JkTYiASYHJy0I0og/pFWA+A5B43AJmUxz3OVEGXhRCUuDu2
   zaana2pn49NBClmWyPCuGk7C55FqzqINAJImpPx3+xsrN359X6Z4aMyeL
   hWddFfD1SWbB8MRLmmUNK33fIMmO1OXQ6l3EBDgRrkKn7jwRxb8JYKMT3
   4twLfUwoh/shUKLHJOPxJWwwT4SK4fWTjigcSBFirc5riss7KkUlLkMFp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="317356433"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="317356433"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 12:05:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="594791268"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="594791268"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 30 Nov 2022 12:05:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 12:05:32 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 12:05:32 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 12:05:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlfdJpfTZOKMhrIlZw1psP0w2mKiODC6bn4R47j4SqvMtW5sM4NKzvZW8NsSo9xq0cCNI4JGcn+/sguO1mnKxHTO2w28x/buTXsWrKSkAEO/dGq1uNAyYDaLnJTEqOiOCT4ABu+09YMTEDPpty3Xs1GvT7UT9bLGkm0pICH4S/V+RvJiQoB45ko83c5YLR2JtVh88P5lq0dpQ5hyalW8kEgyjxIW27fsPPsogS1rSP/njxQtYqsizd8KzdiyUy5LR+LTpkzqNKEHv+0a+KvSr0h0IE3Mk1jGJtXAO2GGl3hmIE8UL33TECxS4r/XZ/lF+/yAn7/swc39fV6G6L8b8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIqhyZ9f5z1ErZktcxkXlK9H6YV7+GVqeR0+yNAGZPg=;
 b=QEuFYtG/L9miVnrWOtWtPucKhuhx14cpiI07wS3TDpFWOubOQeOaw3AgoFARQmzmxbip4ZesacjK4OM2PjA4lECPSeTSvao7fhGTOIu7Ti7zk629RThwOmbvxPf9r4ufO9H6RL6g6njGTufSj+V0iAb3QFcuLW0E+YmBsNl87MhGiaAO9HZBDYyBNjvJqzmitbLx74VqI9O76zPnENdmWaN4WVaB3tx7N8j+WVey9cHUhIp4oKafh+Eq6rBujf+hFh8p4ltzKp+kgpd4F8DXKdypLNuupOQdzxNJzowQz8P/IFlSc6PFFVJ9mObTM0+CGZM0pmXXHqhWydvn7PDR8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ1PR11MB6251.namprd11.prod.outlook.com
 (2603:10b6:a03:458::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 20:05:30 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 20:05:30 +0000
Date: Wed, 30 Nov 2022 12:05:27 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: RE: nvdimm,pmem: makedumpfile: __vtop4_x86_64: Can't get a valid pte.
Message-ID: <6387b787364f9_3cbe02947b@dwillia2-xfh.jf.intel.com.notmuch>
References: <ac8d815b-b5ca-4c4f-4955-ba9adbce8678@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ac8d815b-b5ca-4c4f-4955-ba9adbce8678@fujitsu.com>
X-ClientProxiedBy: SJ0PR03CA0123.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::8) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ1PR11MB6251:EE_
X-MS-Office365-Filtering-Correlation-Id: e33bd7ba-d98a-4375-d3c9-08dad30e3a64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: glJuCkgKPMVLbJxU80B9mRk21Lv8oJcRp+EAQzi+6c4a/ofTgXkrrH1UobbjwtMntRdBHtCzHxvCzQ9wSKtykVpwOhkmQJQxMx1IIqasrDfgN1Fhzc5/Rb6J9MYdZvg8kyd4IdC30F8bm1F7vtD7cjv9IBK7K0MD0N21Nu55h06xBhqa0UXH5VmThJx1Z7YP4ZAaT1J8yqzcu2s7UxokEtVOoNsTxe0M5UeZqqCCMgqxg2CKXSYZ2FOInL+zaVpXKxX2CZmZZ9dMTnOh3leb1hVMF/S7fEvOIh1Ana8gUZW9iD/q0YxKpwu188fnv00Hwwd8Eg5KYunW/zLxrLQoDeOeb8RjTssp2DBirLRw9CA17nORUDF6apU5woxj/aIiq9GDTPXVgSTqOVjE3xUiVsFfa74V8VN0WZIA/XONG2RDOikb9oVrMKGlUsYgkhxF1wh0aLNraZT9YipFQNeMKm1++izMw3VWB2E8y9n/MG0JAJpQcDdwvI2Io4tdhTHCJyxUErkpu7USPWsHJuUHjrvxwCo+L85VhMLw4lVZQn1tVoICc31r/ns0YJIAFw13FWHikWtRZsm+44UnarMN/44e0TDxLCs7Wxm/t99y/HtsKrD9r2l1uLhl2nfOGsFf75ptkMUURD+rY4PeQl6p0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199015)(107886003)(6512007)(26005)(478600001)(66899015)(9686003)(6666004)(6486002)(186003)(86362001)(110136005)(316002)(4326008)(66946007)(8676002)(82960400001)(66476007)(8936002)(66556008)(6506007)(2906002)(41300700001)(5660300002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y946Qx+VM0auJvt5UUI0KOZfyOxARwt2/XEoD8t5cBZJQQf7PP8PRgML6/Ft?=
 =?us-ascii?Q?IpoGn/TljFOL97YzpIjxygoSM96T2EYTSurex/zytDou+F1Rqh9Ex8GTfbQX?=
 =?us-ascii?Q?vd6B5mQLz43NTkOQJ6WVGjV/FnIdqzX1yPy0nbkpv1gJvOS2elwp4nB7jZzC?=
 =?us-ascii?Q?xD4P89mDQrfBhD2YO4ez50fqwUG9+Y0o6NlTLPeg4xpJP8yJ+B9btqg8pb1S?=
 =?us-ascii?Q?CHikcFMjimoUTa81puAEpiOpGtyjLIP+T83i/ZR6lND51kQIB0XiKav+v417?=
 =?us-ascii?Q?RcDbiI/OK4GRWzIVjywQv48VvZL5dBAclXU8/u1a40Mc3wvxAiV3FmBbeI15?=
 =?us-ascii?Q?0IPfTLh77+Fj39iqDLTpFBL3ZdsddRky2LEc9jFWeQ/RR1FtmQbVgf2FYiE1?=
 =?us-ascii?Q?jIIhhXuwVfh+qZuwuUE/KOFeNi6J+J2Ll7VLFdOjf/t/wyeIUhzWCPK1vM5G?=
 =?us-ascii?Q?6wEEfamKlHYZsjv26M7NDBnXVKdb9wSSdljf/1VPGmZDa/ySRVkHhUh8IFHT?=
 =?us-ascii?Q?eFB70u7f+9CdAS+Ma8g4pTcL8E9UPxfx2feIwB4I+9JfBzKun8LZYaw9xR/e?=
 =?us-ascii?Q?aur9Cj1qQdNS57h/crKUai0uoLyzxB9QtWypjYWUZQgfaP0oMMnIiQhIOt3w?=
 =?us-ascii?Q?FPSeRkzhlwRhgfrpvSOmvOcPOvrwy7AKS4RNeMZcaMtjkb2J4/i1HsU3oSOJ?=
 =?us-ascii?Q?wl8eG/BOzRS9PAszl+pXWQrCB2gFoH9SJmoyguVNb2ClycfVzhwcR344OR9j?=
 =?us-ascii?Q?yQ3rY7WAvq4szPqmiKa84FZP/ml3rN6uut/8I1Q0SlQaeas5wYct0b4Rh8Ai?=
 =?us-ascii?Q?ucwAt/uOgIvuNUvaG6FsBF0fQb5aIG5Ec7TyIchzRWZNfUwYIH7XqI9+Oe1/?=
 =?us-ascii?Q?FPrrc38koby85/54w0iBPg5N0pYjKerIhFyb42UcsJwvXtG7kDyw+kDOUhex?=
 =?us-ascii?Q?l+XjhH7aC2u2DK+gpoRaOfViTEs0D6mT09u4G55REzuD25zaTGhxO0LRRm8k?=
 =?us-ascii?Q?2gc4ObHBxGqmKarC34Vxl/jaQ7I3v26iJsuG8W6DMJnp4Lwq+ttIV5CnirVD?=
 =?us-ascii?Q?nH9ZdBoGZn89kPJdzYSIFalKuTARkSjWf2d7LESKlES6TUacBaO1Gv92XqUS?=
 =?us-ascii?Q?/JkDDjI+sQE6dmlojBc4Iur8l/MPk73g8enoEfP/ucgbSiXMZ0h8QwZMWeI9?=
 =?us-ascii?Q?rM/9dDaSstXiWD/BKpPfNIzcqDSWByU3KdNISrQ5O20+ZcrNG/3WlWgRJABp?=
 =?us-ascii?Q?2JrhDWlxAwNPlHjW0uYHnOYdLbcqCNacaVw6IjICS2vLWPJ7jr5u2qP9vLmN?=
 =?us-ascii?Q?pxzWU/xmr426gl6BVzUTdO8bCG6RO0dqizPdANKAM1n/RwEFab+XnA8WqJAe?=
 =?us-ascii?Q?w0Tf/CvXSNAId7WozuvBXOfUvvG5NotCL/VdXPIV+wQZnFQZNBjnIc2l4UqO?=
 =?us-ascii?Q?b3Vd8VdKjdPfSyoA3kBZYq69rYBXrSaZXH3lFqGM19AwiwG9D9/e9IYObWxz?=
 =?us-ascii?Q?tm3IqYqMkTr9TV9H9QCajblFmJ7vYb8R+W1YJGXeeTnbYG7Z60AHX+0JbSgN?=
 =?us-ascii?Q?dd/4o5u9DwxjOslZN801/6PSuJqljgAKtChB/7d11Y5kQUl9vDeFmel9J0Wr?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e33bd7ba-d98a-4375-d3c9-08dad30e3a64
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 20:05:30.5909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPV5qpT4XabKSz67j0gVQ2fFyIcim/NjE2wpXmyGewNwUT+VAeXJsj3eNRltH+3ldU/ngpxQeYrrKCRrgG3d+r1yNxvGmk7sBIAM3vnnioo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6251
X-OriginatorOrg: intel.com

lizhijian@fujitsu.com wrote:
> Hi folks,
> 
> I'm going to make crash coredump support pmem region. So
> I have modified kexec-tools to add pmem region to PT_LOAD of vmcore.
> 
> But it failed at makedumpfile, log are as following:
> 
> In my environment, i found the last 512 pages in pmem region will cause the error.
> 
> qemu commandline:
>   -object memory-backend-file,id=memnvdimm0,prealloc=yes,mem-path=/root/qemu-dax.img,share=yes,size=4267704320,align=2097152
> -device nvdimm,node=0,label-size=4194304,memdev=memnvdimm0,id=nvdimm0,slot=0
> 
> ndctl info:
> [root@rdma-server ~]# ndctl list
> [
>    {
>      "dev":"namespace0.0",
>      "mode":"devdax",
>      "map":"dev",
>      "size":4127195136,
>      "uuid":"f6fc1e86-ac5b-48d8-9cda-4888a33158f9",
>      "chardev":"dax0.0",
>      "align":4096
>    }
> ]
> [root@rdma-server ~]# ndctl list -iRD
> {
>    "dimms":[
>      {
>        "dev":"nmem0",
>        "id":"8680-56341200",
>        "handle":1,
>        "phys_id":0
>      }
>    ],
>    "regions":[
>      {
>        "dev":"region0",
>        "size":4263510016,
>        "align":16777216,
>        "available_size":0,
>        "max_available_extent":0,
>        "type":"pmem",
>        "iset_id":10248187106440278,
>        "mappings":[
>          {
>            "dimm":"nmem0",
>            "offset":0,
>            "length":4263510016,
>            "position":0
>          }
>        ],
>        "persistence_domain":"unknown"
>      }
>    ]
> }
> 
> iomem info:
> [root@rdma-server ~]# cat /proc/iomem  | grep Persi
> 140000000-23e1fffff : Persistent Memory
> 
> makedumpfile info:
> [   57.229110] kdump.sh[240]: mem_map[  71] ffffea0008e00000           238000           23e200
> 
> 
> Firstly, i wonder that
> 1) makedumpfile read the whole range of iomem(same with the PT_LOAD of pmem)
> 2) 1st kernel side only setup mem_map(vmemmap) for this namespace, which size is 512 pages smaller than iomem for some reasons.
> 3) Since there is an align in nvdimm region(16MiB in above), i also guess the maximum size of the pmem can used by user should
> be ALIGN(iomem, 10MiB), after this alignment, the last 512 pages will be dropped. then kernel only setups vmemmap for this
> range. but i didn't see any code doing such things in kernel side.
> 
> So if you guy know the reasons, please let me know :), any hint/feedback is very welcome.

This is due to the region alignment.

2522afb86a8c libnvdimm/region: Introduce an 'align' attribute

If you want to use the full capacity it would be something like this
(untested, and may destroy any data currently on the namespace):

ndctl destroy-namespace namespace0.0
echo $((2<<20)) > /sys/bus/nd/devices/region0/align
ndctl create-namespace -m dax -a 4k -M mem
