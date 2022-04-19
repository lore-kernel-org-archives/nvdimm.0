Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B320D1374;
	Tue, 19 Apr 2022 16:43:16 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7idjfAA6NTiooZvpf2Y+5HZeNJR0Vq8OI/ey2qsRxtMoGkeVA9nxx/nPX+8OAo4NuroM2r5dnoEtmrFVPHGqZBH6U5kS69OJGPw9LlwTPO6JmrZc1UFe7+rDn1HZ4aGGy1cqih6wWuDmkN/VhWjGP+DaKOBxHTicRJqTTRecfVwbha8YOcXTLnowKntP2LjKSDneLGG50a0alHm/eingo/pcMqH0V1lyV5IhBsattX0e1NyNIgPQDKwHlZTDAXXLT33SPy5KwCDd5bf7LL8nLWErzekx64w8Li96yKrvqBUu9+3B3Zjyp8CilYqxEtNCurWVa21Iltd0XxVGD/2Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bNyPG8pEkRImKI4zqxNU+PAxLBlcQzX1T5ktOg+bT10=;
 b=P/fZnqvyPZF3l36wWUSzy9HYxDpxNFmJfGOfNc4Y+n/qPJxfJN8qvCokhVM5bjxlEKkTeXtzde1ZrHVJEpVkJn3biRKY8Azp+cZ9drZHNDGdXp6DNO11hqvKoReoE2OEvgvV/IbK7sPk5afBMeMl0Ka+FRL5xufQAaPz16jnYCYpSRkRkAHDycUXANxDMk5LbFXxOKX+BrLRmGqz5hYxD6IQe0rMB+tMNKIQCR/yOZsIsR+ZQ7mmaF1AWi6ACEgdi9k7kTFwSPsq9XQxCCDCq0kzxgE3yZFsZc/gTqB8hYgaIZxalTS+NXlSAJC6495Zf7OWKNOa/XA2QH2hvWI/pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNyPG8pEkRImKI4zqxNU+PAxLBlcQzX1T5ktOg+bT10=;
 b=KiS0WsVBTP6nnJUfgRufINj3pKTLstygm8kqwYAAR8ezZA6noLRhE7wO890naKk8NMtY/UsNtMkfxdj/FZaObUKKZ22iSg28peYj/xQWenhrJyJuDUHBnA9N1sZ8VAkRiwiENqXKQ4oWUKoUf/XZG0988SjMdxDFfmYFejPUxpQavJRgHILOnsp5x43AdZz1CTOFeNXZTe7VLbNF/ZXhi+YIXGLEzBmplJMIt0uJ3iJXJzmLOk7V/m7007/cG/1ABzfiuyD/fdL/ww5lSoZPNsqWukMCOIB+ZlqgR1zpW71O+VXzsjl8g7vTPrsqp04K783WOSRqZkEjtjrNyhCNGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB5003.namprd12.prod.outlook.com (2603:10b6:610:68::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 16:43:14 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 16:43:14 +0000
Date: Tue, 19 Apr 2022 13:43:13 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-cxl@vger.kernel.org,
	Linux NVDIMM <nvdimm@lists.linux.dev>, patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>
Subject: Re: [RFC PATCH 05/15] cxl/acpi: Reserve CXL resources from
 request_free_mem_region
Message-ID: <20220419164313.GT2120790@nvidia.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-6-ben.widawsky@intel.com>
 <CAPcyv4iM13nzCpnF5S4oHSWF769t4Av96gQM_3n4E=RAPSnSig@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iM13nzCpnF5S4oHSWF769t4Av96gQM_3n4E=RAPSnSig@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0445.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b8cb10d-de50-4f90-163c-08da2223b2b6
X-MS-TrafficTypeDiagnostic: CH2PR12MB5003:EE_
X-Microsoft-Antispam-PRVS:
	<CH2PR12MB50032ADC3E177245DDF6F146C2F29@CH2PR12MB5003.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VnEwKGpP+O87eLItNqWhFXcNg6z7UiSY4pHZDq4VFKphnuUDvBsskaC3Jzq8Sz3otSKTbBBZhoTZcWsDCMr+mRlE+M1PteJmDG6AQIefw2EsWmw+X9kMr9HflBsvLuFdiHc/LzlqXY+QXa+oyE2jpPfjITzMx2GPg6HHwphcy2ChSk7cmGVP+YXDcUeTLqts+UavtQUTfycP7I8pkFOFFcjBSA5e83UqjL5KzM+4HPtrf/045bKITBT4d80Qk3ZWSVqKhKDD0o4m7y/CcfhEgngvQgHscnCGob2rrt9op+pY/sZMdNtguDgxBnMlY696yuJ/cuPTNj+QRmrU2R19NxavO1bKQ1PmzCZ5HZ0WcFTaXSSHWmTe/ZaAROOm8yisN/cuCR0X7gnBtrxma/gYsQ8+88pf4wfqCVbK/bU1VA4UR2G7HyLxSpBpL0ZW10JD7ozTzvOXKZCLli6O/ZVwji96qqqSOAn8sPnCA9C9Tu84LMq7LCWLwCt6P3fvBbqZkksthdiFi1UJzD6ywPLeaX33cu2SRk+u1uIXY6yY9X7dM2OUSNZ7iUyzKF50rqYpzSKT2vFgAA0/GFEMeaUfCB0/foBLBU3kkfwi73B+9pR0ODeg84O90hdVDhwa8pfmFfgrdJvblgjV5oBXD49r3w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(6512007)(66476007)(38100700002)(66556008)(66946007)(1076003)(508600001)(36756003)(86362001)(53546011)(6916009)(54906003)(6506007)(107886003)(4326008)(2616005)(5660300002)(2906002)(316002)(6486002)(186003)(33656002)(83380400001)(7416002)(8936002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ikAEknIMUxHGVSikuUSyfOtaaCiwyIO//XyBemtqxT9aaLkRwyhSMNfUOCGZ?=
 =?us-ascii?Q?T4M7CZI7dvPMQ43G54JOl2OJnL4SA9KANbcqYYjYzUGJU4cZzFneeOs/rObu?=
 =?us-ascii?Q?/Ahw+Xvy6M/0G71diCzCwwrsyhHbJnN80jIllwNRQTRX18kE41KjSVSG0U7S?=
 =?us-ascii?Q?87HJnZ+bCESpOu8BSyGf9ISn394f1GCs4PHHEfKSFBuqUg9RkqSaL5oQ4dLY?=
 =?us-ascii?Q?VYHn6cSOcSccPDxFtFfjIrCuUQXePRQfi/Po6U/aJ53d5dsxlTqhLyZ6vwEz?=
 =?us-ascii?Q?egSl7S8MKlmrwv65BBSGwYPOhCJ5cKPnYGhzBIhm7bmkwG10kvuRYcj+uu1U?=
 =?us-ascii?Q?Y8HLYmy7OeKIzFr0qUxIIvAv+VJJR0J6HyTGkGWAohTcfhW/oZyaUiXAk3Tn?=
 =?us-ascii?Q?zKKd3yXEkQpXcw6eJoVlNCCctiX9WApHeHGydwMepiWw+UdXRZYQdVQq60jA?=
 =?us-ascii?Q?W98SlSmWJ18Bdk+Bb2BhJZFGoDDrp5ZNRWABAFFT7UmK8bsrVCRNVy1xRMCP?=
 =?us-ascii?Q?5QcZmHknsqX+DiGOdVdmbf6Jiie5UU+iA/H4AMLuZwhEIc/3cFfMuL273jWm?=
 =?us-ascii?Q?0mIVaXwV9uobEilLiCeKWpKkKLY4vqokXNYfEepuqz8ftbpOh3yhuxtS5NP3?=
 =?us-ascii?Q?sMJ3x+ZnVrZYA2Esgr+W9XNVb+aPBndlFa4L8Z0QgVD/4aSLX1vkJzRK4x4b?=
 =?us-ascii?Q?NATEmJ9NIJZm4smSXyEFlTTFEMpb+mdGCD45hg5jv1EylSOhDAGk0iLPgs1B?=
 =?us-ascii?Q?zWec0rYjGlddIxPrLsUEI+Edppa1/xQZ3pISKIpHWhcIFUZqMD+KxEe3RN3q?=
 =?us-ascii?Q?CqtrWYvizdfOjGmSQd3EG+817LfO/2ImDSn3pgchICOknvbWcn/k9qCoRvSu?=
 =?us-ascii?Q?3sRDPFsEXrxwhWs0K7rQrbikUTv0ij5sZ/OaMbtzsXIHeI1HCDYpj+h68jfB?=
 =?us-ascii?Q?936GARDX2T5P6DJ4QhhofCLHFcdvUOFZdR7JpDZsOUoDc7lIRKSkPJfN4EZ2?=
 =?us-ascii?Q?EJxaD6rXZqmf+zWJfcm/2yOxx5xfhJoUTv109xxBaXA2EzJYdCkDNLhtkIQT?=
 =?us-ascii?Q?MFarixmh45JyV6dnzKflPnIBFQbBtt0C2ycXqNasPNh/dFQh7eM0pNalwJoD?=
 =?us-ascii?Q?w6JxN2r+WvE/SMU11jS7PZkPxigHa4l5b1AxnrYBI42Xd2Y39VtCQwpyNsRt?=
 =?us-ascii?Q?xCYtKPKvHoMqdswNMMxX2NAUcd+cixRQQPkaqvEg7OWOn1CawdWF3rnHeRum?=
 =?us-ascii?Q?AcZIWVNacMW3Q7Y3joYL+ScINYF1JJyLCBIgJ+Ew/VS4z9rqjl8BBZJYtiC6?=
 =?us-ascii?Q?m4lDtNYKLJUDTigfBZtliT9OnQhU+LeNh1rZ2A3gQmIboDqGrbQTLI8YOLx4?=
 =?us-ascii?Q?0hKXv6VqheS7n3mGLNH1w6lzoCWwrI40srGuoX3E/3Hw8jnA7Y0f3suFOScK?=
 =?us-ascii?Q?9meRJh6nikCmr34GZsFIEQ/9ysd68aN/zoQ3uD7sqbWIpHV8JTYIex7kB+Pq?=
 =?us-ascii?Q?ptSq7lZgdOV9Fqg6I082YdhPfSTHfzCxF2rnx/Ux3AmKgdJSPD3d3tW7o8bo?=
 =?us-ascii?Q?EEbLsBSt/Rokf867qzWmv96WW855dOf7a8QecteNsigsVL++9o5JkPEWot3H?=
 =?us-ascii?Q?Rxo9BT0Hk1579haCyBEAvOmBzvomp3IFlO5xoohLpouHmF6nLCXwTGG+PQyW?=
 =?us-ascii?Q?B+WnjnY/aApchDeDHTSF+0vr6cTLZx88pqUFDwrwLqlhOeeQmVEo/05T4bk9?=
 =?us-ascii?Q?9G1R/cM0hQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8cb10d-de50-4f90-163c-08da2223b2b6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 16:43:14.5556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9uMlAXvlmgriXZk0ytb3KHM4bPYQpDuk4iZptxPxBQ2sH5XJ970rRhr6tvIVuxg5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5003

On Mon, Apr 18, 2022 at 09:42:00AM -0700, Dan Williams wrote:
> [ add the usual HMM suspects Christoph, Jason, and John ]
> 
> On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> >
> > Define an API which allows CXL drivers to manage CXL address space.
> > CXL is unique in that the address space and various properties are only
> > known after CXL drivers come up, and therefore cannot be part of core
> > memory enumeration.
> 
> I think this buries the lead on the problem introduced by
> MEMORY_DEVICE_PRIVATE in the first place. Let's revisit that history
> before diving into what CXL needs.
> 
> 
> Commit 4ef589dc9b10 ("mm/hmm/devmem: device memory hotplug using
> ZONE_DEVICE") introduced the concept of MEMORY_DEVICE_PRIVATE. At its
> core MEMORY_DEVICE_PRIVATE uses the ZONE_DEVICE capability to annotate
> an "unused" physical address range with 'struct page' for the purpose
> of coordinating migration of buffers onto and off of a GPU /
> accelerator. The determination of "unused" was based on a heuristic,
> not a guarantee, that any address range not expressly conveyed in the
> platform firmware map of the system can be repurposed for software
> use. The CXL Fixed Memory Windows Structure  (CFMWS) definition
> explicitly breaks the assumptions of that heuristic.

So CXL defines an address map that is not part of the FW list?

> > It would be desirable to simply insert this address space into
> > iomem_resource with a new flag to denote this is CXL memory. This would
> > permit request_free_mem_region() to be reused for CXL memory provided it
> > learned some new tricks. For that, it is tempting to simply use
> > insert_resource(). The API was designed specifically for cases where new
> > devices may offer new address space. This cannot work in the general
> > case. Boot firmware can pass, some, none, or all of the CFMWS range as
> > various types of memory to the kernel, and this may be left alone,
> > merged, or even expanded.

And then we understand that on CXL the FW is might pass stuff that
intersects with the actual CXL ranges?

> > As a result iomem_resource may intersect CFMWS
> > regions in ways insert_resource cannot handle [2]. Similar reasoning
> > applies to allocate_resource().
> >
> > With the insert_resource option out, the only reasonable approach left
> > is to let the CXL driver manage the address space independently of
> > iomem_resource and attempt to prevent users of device private memory

And finally due to all these FW problems we are going to make a 2nd
allocator for physical address space and just disable the normal one?

Then since DEVICE_PRIVATE is a notable user of this allocator we now
understand it becomes broken?

Sounds horrible. IMHO you should fix the normal allocator somehow to
understand that the ranges from FW have been reprogrammed by Linux and
not try to build a whole different allocator in CXL code.

Jason
