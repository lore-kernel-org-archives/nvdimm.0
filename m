Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9106415AC
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 00:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657673592; x=1689209592;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=kCF3nGvhH4MmgeAj6a11Gpldr8K/0dmBvHvb79cc9bI=;
  b=JIHfvKFtjedcMdJ5PCnyOYVDt/7CoEO/3cB7QQAGfvPHolGgFuIJDO1x
   7k5CU6UfQtsQ+sF/HMtsJUh7XOywNpi8/dzWwrvHLqcagYIXRILYdp8YS
   gkoe/bBBFhZgf1kZSSTL7LpSkT1Ngsr1eGMV5u/PexJQm7M9BH6HeY++l
   3VDViek8qsbkQEHGKOlxEqVfY7Zk1910iOygjfbyu9p4DvyVGL0CPAc4M
   fiPSGPWeHgkm6D7nEZCAHKx4eo4u4PajlG1lKCgTjo2iNwLhzo80Xmp/f
   muTpe/POq5faP+YmLpCfBPt8i4ZNJ16IqhZZQrHeNjq4moObs8LIzt6xA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="346759050"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="346759050"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 17:53:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="545639548"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 12 Jul 2022 17:53:10 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 17:53:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 12 Jul 2022 17:53:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 12 Jul 2022 17:53:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEcpnJjVH8/Otg5pY6+YPrF3DdltEdhbleH0/HbZEfSLZQrKnh8iwUUwRWHjUF1bLKMIhoUR5GfKh9qEB+cfI0nmbKtwxZDCTs2oLSs8MPxLFt1qQJMipL7R8eEAE48eca33OwnMY0adZKXbdz+3yrxgv1KK3U7Da4G8NFUlhCO00WjsbZ0/QBMODBCiIHHvCdTDgvPDpd4+c9/8fW6oVGRwDrsATtptM4ITGhUVJvWtw/2dFkBizvTF+c3Omrn3fR2N24xLIuA+UgblDHnAzFl0B2sVQfAwnhidbjBNBYXNnmTBThTOIKDhjuE5HRzamUiE9rMvhdqpETQTxB2DxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9D+H3+EHoZuANzQAxdQeGEkVVlgE2Z7E4E1oc7C/Phs=;
 b=TXhbv/2IlTo0yTxClgG88gBcBabGMoP+TR+gJzBx7FryEXmsmoj80isnxF9tdas9ZYcdyIo6dnDTC/3yMNJLK7XtWWOYFRAjb1zX0unBaAD+yb8EFnTaxcX48EY3AACkEUZblVZHCQ7+X63eXvjxa3qfe2hDO1UtFXxt7QgqWetzqDdrOlkGNTGBrYAxwI7SLodpKNi7RU9EV3UKYQeMuSxjEAZZKhfdQUqqWf/RcpoLN00p7G255L1aA/qqtj3cHFzXtQetnIM/1gbJCwcpcXv2CI0CU+zUpgibm0d2VBTorZs76X8Tu4yZuVh5d3ka7sQyexgYGyb5zLUzVyCXxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CH2PR11MB4456.namprd11.prod.outlook.com
 (2603:10b6:610:48::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Wed, 13 Jul
 2022 00:53:08 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Wed, 13 Jul
 2022 00:53:08 +0000
Date: Tue, 12 Jul 2022 17:53:05 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jane Chu <jane.chu@oracle.com>, <dan.j.williams@intel.com>,
	<linux-kernel@vger.kernel.org>, <hch@lst.de>, <nvdimm@lists.linux.dev>
Subject: RE: [PATCH v2] pmem: fix a name collision
Message-ID: <62ce1771b331c_6070c294a6@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220630182802.3250449-1-jane.chu@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220630182802.3250449-1-jane.chu@oracle.com>
X-ClientProxiedBy: BYAPR06CA0009.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::22) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16ed41c2-779c-4073-c510-08da646a0d3a
X-MS-TrafficTypeDiagnostic: CH2PR11MB4456:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BIEYbHAhu9ZmtvJSqWIPlqnSYrsc4/FNW9wLsizlc9vXrxyHQTfKN/utkcvojQEqaKhCMxZXkpd5YfdaTMb9Wp84QRcP6Wa2nspmM1xfyq/gR3Cj/LljrGEHecqHHBmdsw53HbWP4xLOTc+fn6PB1xXWrj52vpjZhzxJuOGncka6avXjU3fzyoaJ0Azp2TigyGAXbJZJElG+DoyN6ohV8cSGYHhnKRxGyGQeNvv+W9d3hgIDN5BDWkyAlJOhhnxJCwXJNqxRcQmC63sdxMaizDgHKCShgafA30EHHt4YW/N7W0yxbzAFzzqyA33McFkg+hP27YmzhJbrKqlXTaZ1SBRcy8c+rLF1I4MIpqsPK53+KkX+zgQ2e3iYEv959Fzk4pZGlCnK4azrSwlEmng8pLwZY7G+V1/BPyO1WhPDHON4BY/jhCMnS6qWIi0s/hLguJ/j2EY7mNO6vg+hWd+rx7AdYn6T1o9X1VsPbJjdokwJrNwxwqVlqao3KdAzX8NTNRbiO6+MrRHMsXLZ6xylbCqN4Qjco62oQvu99Tjah3plYB5rfL2zW5KZRL4nbhhodXOk41IGiRzdnHDyIpZyoug9GH1yT0J8LO0x4ED3sSiKBM0z2RXGF6sniMQ1r9HO4pB0La9apziglDedw6/iVSkgDNQqqCdrE47zG7TUPiIrFpKf35ecQ84FtErENXSoXJCDBsjrtdMLDwuvQ2Mz/VO0xj8sxtP44uUIvV/yv1Gm9pm3DMggIWllAt/cnfiED5yi+q5mQZ68OQJun5qD3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(346002)(366004)(39860400002)(41300700001)(316002)(5660300002)(8936002)(83380400001)(38100700002)(2906002)(66476007)(26005)(6506007)(6512007)(86362001)(186003)(8676002)(66556008)(82960400001)(6486002)(478600001)(66946007)(6666004)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NXOosIDjmCBUNfkpzj9b90cclgyAkJrZi7C6pszw5KBtt2Qm8bKR47Wm/s/l?=
 =?us-ascii?Q?GHoAMHoN1ynxm1gA3fgzEaPGQYBaKKFtyGwVJmqU+S7kh1VFolbHuPVNKP6D?=
 =?us-ascii?Q?xnEd77g0HMMHIx4Q8X8SK9bDjfU2OyDtL9kMFhVwbz5PcSeQBCEnr5DbZD4J?=
 =?us-ascii?Q?cYXHr8O20IYDijr/xFwesUyh72LCICzQWQOwCPDPzpz36WxjfPm7zSPAy/k+?=
 =?us-ascii?Q?4XaHALRHMUwSPs3LcyY48ZgdA5BuVghyrsuxt7VU2iSLSm/IDgLmCiE0RW2f?=
 =?us-ascii?Q?oaWE7J516kxbRc3ZHkJOCYdIsWUamSQBNFAQMUYcIMMBaTovrKZASwsVcvGL?=
 =?us-ascii?Q?RTRqXtOhTTJdJ7ab9Ciwj/DKDzDt7P78JkRmPcsij68U2nIQzdtOUWK3pes/?=
 =?us-ascii?Q?F4p4O+J0qENPB+CKa43azw4l5gj/7GZpWFlxin164veO1AgfbkxLcKzwUGpN?=
 =?us-ascii?Q?0CdSnWrMoLr95sts1PDhPJaQib0BRd/UJIL8WUEj1Yzm1wyX3oBSDdMNe4D1?=
 =?us-ascii?Q?/EXbw4GH+l4dnuHeLXvCEapJ3M2HbET1OAz+kI01CL+unNX7k7zPSM42gcdW?=
 =?us-ascii?Q?e7LYYlvMLZA4IPkWXGQ0RC3emhUdqcNXMs1TAch/StWFzLjKPL+3O+HVn02q?=
 =?us-ascii?Q?xXkGcsFdNdeh1Cjr7Mb0qXperGat4EIJS09d+LmgFCNOFStT5+vUdAnOpkn9?=
 =?us-ascii?Q?d1LG4dh7WT6iWlxYDbrBF59PeXkDaF2r3fyl+zEODAERtObTIAsy0IKgn5SJ?=
 =?us-ascii?Q?WRVb74aURtflRhRanOZHdtQC4SnUQoueFoyTgorEPRHs9WODdxzU80yAMsdE?=
 =?us-ascii?Q?8f1HebObPxOSXpElV+1LEeSI66P3RVG2KvmrRymfbYt0xbhJX1pHs+kTwFN1?=
 =?us-ascii?Q?PhRxXvg9QCw8Hc499XXAZUw4G+2i8G73OBEYfJG6m0Z8n5saTPy7TzJqW6CS?=
 =?us-ascii?Q?E+yHTNAy2K5d+oT7rNmFPgygv3WtbL1Ck+502wgHlaVULGyElXq4D1eUtSfr?=
 =?us-ascii?Q?ErJkf4yZ/G9oBi49FvTxO1CLmzXjIW6wyn9QCz25wV5+rBpiGbOdQ/gaK1hs?=
 =?us-ascii?Q?0s7dlQKjR1DVhgeLeNciHKBUAowGgDcg0YLdOhmOEFqjNE02O6MnengLlPm1?=
 =?us-ascii?Q?Eku8RdIVNwcknbq+xbd33E7wUETiIkEAp4MFruJpsNka4nt1GARI3u0vUmo5?=
 =?us-ascii?Q?pA8+i38TIiaxqZiszasE2+VpUkaiq2s3ZsWohvxVQCqsBVu3lZ8NqhyFnHyz?=
 =?us-ascii?Q?usMstOLE0rpgrZD32BtU/f7IZnqvsAvi8PAE7Glp1Fd3+3Wb/u746KlSMa9w?=
 =?us-ascii?Q?SurzMBS9KO7ZIRzEn3c89V13FzezR84qyk5BP4Xcux2yFDAyHeGPOs3Hgh+i?=
 =?us-ascii?Q?6whpFXfWqQjeDpWPtKnvoxudV4j6gx5SUHoAAyQz+5L6xTGWeP+Ptzz0UHNS?=
 =?us-ascii?Q?01V/+Y+KpM/zSpwlu46AZ6psfhPZmLpjZWxLOkLNyUMc6Zut7kxYazWyBeux?=
 =?us-ascii?Q?saKzEbKwRJqyL2EhFbAHAesneoQ9NEn/Em+Q8Q5/iZOycVaDn7iGcF5lq2de?=
 =?us-ascii?Q?1vdpfGkWbV1E3keUfP3aG/HRzrw9fllj+cyAQIsnuxFiaWntCPikPPAapkCr?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ed41c2-779c-4073-c510-08da646a0d3a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 00:53:07.9331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csCB5nNWNyKjhXQWQaIRQDC9NEbWGr/vuFBleMqWoqrjs43daAQTfPYzjm/jJpd40Zi4WnzCUZarjzd9IXNotKtaIa9+lthu14FFEcf77wA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4456
X-OriginatorOrg: intel.com

Jane Chu wrote:
> Kernel test robot detected name collision when compiled on 'um'
> architecture.  Rename "to_phys()"  to "pmem_to_phys()".
> 
> >> drivers/nvdimm/pmem.c:48:20: error: conflicting types for 'to_phys'; have 'phys_addr_t(struct pmem_device *, phys_addr_t)' {aka 'long long unsigned int(struct pmem_device *, long long unsigned int)'}
>       48 | static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
>          |                    ^~~~~~~
>    In file included from arch/um/include/asm/page.h:98,
>                     from arch/um/include/asm/thread_info.h:15,
>                     from include/linux/thread_info.h:60,
>                     from include/asm-generic/preempt.h:5,
>                     from ./arch/um/include/generated/asm/preempt.h:1,
> 
>    arch/um/include/shared/mem.h:12:29: note: previous definition of 'to_phys' with type 'long unsigned int(void *)'
>       12 | static inline unsigned long to_phys(void *virt)
>          |                             ^~~~~~~
> 
> vim +48 drivers/nvdimm/pmem.c
>     47
>   > 48	static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
>     49	{
>     50		return pmem->phys_addr + offset;
>     51	}
>     52
> 
> Fixes: 9409c9b6709e (pmem: refactor pmem_clear_poison())
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

Applied. Sorry for the delay, catching up after vacation.
