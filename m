Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA042F21
	for <nvdimm@lists.linux.dev>; Mon, 13 Feb 2023 23:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676329837; x=1707865837;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=eo79m/QB0L/UD9nbfsS1kZrA8KJUgQ/mwa4C94AL+QE=;
  b=OG/tN0iB4fmroXolx99R9cj5T73m4/OK55kJuycUnQOB2V7bj0VD6fuO
   lukl86HB1c26MwOWUU56YaL34+55jJzOKv595xsF2CFyUAVsjH6n3RoI+
   qI8MyTPs8w8fX53W2si7Ny4X1710feXkSsflycduGKBmEaz7uH/HoqFFi
   vmxLnsdASLJejgkbVBL7CVg1YSjWLGlViyJlFEctPnWvqMwDeZal8elpa
   v4nnp52HkGyLYgfyB1u2RnKGbp5kDAdmjanChxsXPJdmqrTr44GDk4uOS
   JDbRUeLD1IjWiWr9y7kcmFgtm5aFbWoHnB1qNIgBIXJFy+/Dpnq3D3qNA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314667433"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="314667433"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 15:10:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="811783986"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="811783986"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 13 Feb 2023 15:10:35 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 15:10:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 15:10:34 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 15:10:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVMJLC8/lU9Shlz3nA8XYmm8CBg4DkS9r85zVQgCGZhi9M0ihJ+MWIQrtX0CI9iCiUuEoyETys5D1koBjdjSSTxl/sRFlCYjqWn9mZtVYnweXMAz0P9Bw/IwV/lVBh1roPIAucfsJu+wuu3Gro+SE3gaDHshBNNHawKQigTQAnzYNr1m/6BsG0t0WWN+7o2AsyFzGNr68xvGH6FCZYH6X9jSnepkmdAVgf3sjUrVTCTKZ8pjUNNVWo5VwwQ7xVQokpjtRp35gqrbi56XwCMb6c6WkKlHIQymIBPORKxc2cdnID9ZQRFGf8PdGhElJg1//RPa2RjMNFiaGYd8q7m+nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfPZZ2DIPcsDz0fN9ZrvpHv1Y/572ZDvMtrhmUIbJEw=;
 b=VnOcjtW12jb+IeFyWXHinhy0X67k2USJVo1yaHBzmS2wws7IKbDjZcQ+7GrWShTVOqf7ao3f0mNHusK3DIXkJM1JOpDtHTuXCPIhqaeoF4Y9JYHH+IT+Tpb0Z6twFUJl3299qTcJ4Absga6v8mIrlVFYWjM7UV4mw9pJ0YenfJmuNTdrKSjEfm+5b0uEYLIx9zcHDMDj8qXtHpgs6ZyHZdHWi1wM8PTFlL5xKuXGBmx+CTVGc3217bT1LgM2NuYo3I1zGEP3PA/DRL8zVdSsibYddXgzQzvjoN8JAviiCsOEybp4bHm+w4Lp4TMHppYfWGTplHRMxuxw0YEtn3CXsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB6148.namprd11.prod.outlook.com (2603:10b6:208:3ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 23:10:32 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 23:10:32 +0000
Date: Mon, 13 Feb 2023 15:10:29 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Brice Goglin <Brice.Goglin@inria.fr>, Dan Williams
	<dan.j.williams@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
CC: "Verma, Vishal L" <vishal.l.verma@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "gregory.price@memverge.com"
	<gregory.price@memverge.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [PATCH ndctl v2 0/7] cxl: add support for listing and creating
 volatile regions
Message-ID: <63eac36548e93_2739242943d@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
 <e885b2a7-0405-153c-a578-b863a4e00977@inria.fr>
 <a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.com>
 <34a03b27-923c-7bb0-d77a-b0fddc535160@inria.fr>
 <20230210124307.00003be0@Huawei.com>
 <7e2605a8-cd49-4d6f-9f62-07ff6edd50d8@inria.fr>
 <63e6f52057bc_36c729483@dwillia2-xfh.jf.intel.com.notmuch>
 <b7a4b785-10c5-53d9-0f6b-eadd80b94d31@inria.fr>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b7a4b785-10c5-53d9-0f6b-eadd80b94d31@inria.fr>
X-ClientProxiedBy: BYAPR08CA0004.namprd08.prod.outlook.com
 (2603:10b6:a03:100::17) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB6148:EE_
X-MS-Office365-Filtering-Correlation-Id: aeec71e9-2e88-4f67-8bef-08db0e178104
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Px9eR83MgVKNd7z3VSAM83c/hsSPXaGBx/UuqkK37o7egjItNQMfxa1Bp3dJT/d5pVEzAWxxAAJgGi+MFvsV3Ur6Zh7oWoYo+3FNmkM2G92NvujngvrazUiTUj57MkIqwf5WPDeIIwFQBJ/uttMrnerg0GQfUiTKILy5Acdjice2HABjc8WJlxNHzcxaXpQxAFb/HxX5suITu+vlWle4KjA1Ndiv2ABVoQ9DkrzWNX1Vdqt/IsOoy7Cc5vUn/+RKR3NzqVTFWupj+FZULb7eKhcivEBsPTQQDQrdiezU1f2EBcilVUXqIowoaa3GABLQhaAp/TH0sOUUWrTqszGrxxD7dvxopha2w+1XrWV9d1yGCNJ+60OZjiUkoOWvEk093s2lFXX8WucmiSFO1rsral9q7Wr3ghq4rRW+wBy8OgCbkJOHZHRhXZJjWbghpfHdzarNAoi0aSGwozsB1Fct1kHnfocA2XH9MkwoX3dzBMpWuiV1lJ2yjX8sGh9zsDXl1MD5zeXVgx+oipvVne+dEh2KGifslkqmWlD7JmKPefYYTNltDba0WT7HTaZe5w+AMwt8/z+bHbL+q2nVyIFItDTeenvN1c9X+E46lycl9A25gjsUn4Y1efnfTqXEd7yuCnYcFsM+YFVRvHZN7gsBXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(346002)(396003)(451199018)(66556008)(66476007)(82960400001)(41300700001)(6486002)(4326008)(8676002)(5660300002)(8936002)(66946007)(86362001)(66899018)(38100700002)(107886003)(83380400001)(26005)(6666004)(6506007)(9686003)(6512007)(186003)(478600001)(66574015)(54906003)(110136005)(316002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?/krjrGXkOErqJzYIxmpmYC7wg0Zc/Uq2C/VhbLXAJS4mOKRlyzy00iq2uO?=
 =?iso-8859-1?Q?YLnfJ2Gtx0raMQWp4c6/hv+KtKegrGtxWVTLyH6uVGG/aPBYQ/8G/EsSI5?=
 =?iso-8859-1?Q?VK1kEdpDwPKGMxXPMm2Z01rzoD65XZSUIrFFOjdJG8Ec1LW54J1PGp3+VV?=
 =?iso-8859-1?Q?Jt6nw5Mc+hwqdhGzskyuqJgR3B3vvMC2Ol+qWOx3/nJOY8tYvnKqUZPC23?=
 =?iso-8859-1?Q?4GBMCpdHUMm2zL1ygA15saKtiMsXBRMPsY75YLYtno1gANiPor8DaAa6KL?=
 =?iso-8859-1?Q?uPiwiXuZhdDxTMECQpc13QuWzN1zbnIEGu+V4nFGAdjSbRXqsQpWblKLP3?=
 =?iso-8859-1?Q?VBhkvz/8BEUSW5nIzIqcMzJaes7cT/jqDu40A6Ovvx5kBycK/ux8LrGAs6?=
 =?iso-8859-1?Q?GyJRXfO9PXZzaxwRABMcrHWy+GNQR39ZovzadAIBarnAtRfamDHVdFuZMN?=
 =?iso-8859-1?Q?e7EbTPHLCSA6h7D9Xy3S5btMBqvSlQJQml2UG2M3QAa7dK0X+TkScBTVO5?=
 =?iso-8859-1?Q?uaawvqIbPMmcI8eG6NXvHqxwszdYDJtfFeD0kMqVvumdu9tzu/yT5X2tYe?=
 =?iso-8859-1?Q?r/3bpJev0k4hLJ/NtXqR4nEtfjJmHuVgH4O1FhSZo0bxGKI6JgS0n/W0Em?=
 =?iso-8859-1?Q?FKoWHgLcSns6FcL4GKYExEBCI0aX2LisuRpUGXMrquakDFvfVM+phy3TEW?=
 =?iso-8859-1?Q?I80cPJRL/5prIOJwL4A8SU8efjfBm3OhqjGmMqyAbyc9efMZuXpNRjbXXg?=
 =?iso-8859-1?Q?noxn+3mX4Bh9Eo5H/4spQikAbwJYa4YTay2NNQY8mwR+HtqTq09dkoeD3x?=
 =?iso-8859-1?Q?bvOtRR+seFKvMzfchGWuilN8X61XqgVvRCEDe9FBptRX1lgEOlMJJivL5h?=
 =?iso-8859-1?Q?H028gCl8bdELHjvv4y/eaCHSq9wjm8UfIOpmMx3fXe2Ml4YE9gCm36BNDX?=
 =?iso-8859-1?Q?NpUpuqT5OLspIwQgLFfLEJybwYoCM0sHHlM5K0qeMfhs3e2AX52zRVsUCh?=
 =?iso-8859-1?Q?q+KgxZaxYi34pENDXrlnXjZIPmUkipdkpskI2MwuIgjzM4ToikfrmR7+0p?=
 =?iso-8859-1?Q?fo/LYCdrWUzzaI5FysZJrVpUb/7rGEM58rng9sLqo744x74NnzDGN/r5od?=
 =?iso-8859-1?Q?GDcj9TXYr0zagMaqILrzfZYfZqKZ80pSnRkOn7Ue5h0OjCR+US2NkXQcfM?=
 =?iso-8859-1?Q?W5gbbWBiwP+3zzieFDryBLpSelqmCxRVcVDDLJSIKR2E8iMKfEB7NU8wik?=
 =?iso-8859-1?Q?d8EbFHh7ZUwcKWlAn8D7OVRLFA1tjSo7GU2whNU/CGplMHu6S3DHMR5W/w?=
 =?iso-8859-1?Q?CNugl3LPFx1DsFU5/wnWRuYz8LljHIXx6nEAyiaxbL2nrzHDpNn6R5leDb?=
 =?iso-8859-1?Q?vWeHqlEkEkfEQYvpc7r4OaGDe3Njir2+xpJvqWN7URgfiPMM9xIoRXRcuk?=
 =?iso-8859-1?Q?TcNANB7QrZ40kfHpBVzeptHlFh3nS7Ho5rpzBwVG6Y+nTnriPWMwmWOgc9?=
 =?iso-8859-1?Q?Z/TfYvxlTd3Xiangejgf4C6dmJ8AtOrxb7F/XvK3lYCAM+tgDmxNDg9gzJ?=
 =?iso-8859-1?Q?2AR/79iARF5TYLqFBGjR5a5IVQ7DsEfpRn2+7bCLc3k9/3CfztaiKGMxR+?=
 =?iso-8859-1?Q?/cvm9xZkueSnlCwoF/XAHX1BuBQ6RZjHZBQkiXTybzCF+I72jI/WbVrQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aeec71e9-2e88-4f67-8bef-08db0e178104
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 23:10:31.7164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yIj5slwsuLYkhkWbMeWOGZJTAVhQz4XMN6ryEIwaneKv0SldyJN2VyisDdOobaxRRr67DT+5ELwBG70mZ568Z6chcRwrJWyWz+3zV/40ybw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6148
X-OriginatorOrg: intel.com

Brice Goglin wrote:
> Le 11/02/2023 à 02:53, Dan Williams a écrit :
> 
> > Brice Goglin wrote:
> > [..]
> >>>> By the way, once configured in system ram, my CXL ram is merged into an
> >>>> existing "normal" NUMA node. How do I tell Qemu that a CXL region should
> >>>> be part of a new NUMA node? I assume that's what's going to happen on
> >>>> real hardware?
> >>> We don't yet have kernel code to deal with assigning a new NUMA node.
> >>> Was on the todo list in last sync call I think.
> >>
> > In fact, there is no plan to support "new" NUMA node creation. A node
> > can only be onlined / populated from set of static nodes defined by
> > platform-firmware. The set of static nodes is defined by the union of
> > all the proximity domain numbers in the SRAT as well as a node per
> > CFMWS / QTG id. See:
> >
> >      fd49f99c1809 ACPI: NUMA: Add a node and memblk for each CFMWS not in SRAT
> >
> > ...for the CXL node enumeration scheme.
> >
> > Once you have a node per CFMWS then it is up to CDAT and the QTG DSM to
> > group devices by window. This scheme attempts to be as simple as
> > possible, but no simpler. If more granularity is necessary in practice,
> > that would be a good discussion to have soonish.. LSF/MM comes to mind.
> 
> Actually I was mistaken, there's already a new NUMA node when creating
> a region under Qemu, but my tools ignored it because it's empty.
> After daxctl online-memory, things look good.
> 
> Can you clarify your above sentences on a real node? If I connect two
> memory expanders on two slots of the same CPU, do I get a single CFMWS or two?
> What if I connect two devices to a single slot across a CXL switch?

Ultimately the answer is "ask your platform vendor", because this is a
firmware decision. However, my expectation is that since the ACPI HMAT
requires a proximity domain per distinct performance class, and because
the ACPI HMAT needs to distinguish the memory that is "attached" to a
CPU initiator domain, that CXL will at a minimum be described in a
proximity domain distinct from "local DRAM".

The number of CFMWS windows published is gated by the degrees of freedom
platform-firmware wants to give the OS relative to the number of CXL
host-bridges in the system. One scheme that seems plausible is one CFMWS
window for each host-bridge / x1 interleave (to maximize RAS) and one
CFMWS with all host-bridges interleaved together (to maximize
performance).

The above is just my personal opinion as a Linux kernel developer, a
platform implementation is free to be as restrictive or generous as it
wants with CFMWS resources.
