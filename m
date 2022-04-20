Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A144A10E8;
	Wed, 20 Apr 2022 14:34:26 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRz+KGDXRbragro5ElucOVBUjW0v4RA6iR+M1IQbwXCDwQcXYVbj/q13/Wc2+eFNp+VHoo1OKn7e8Vm/2Y8bmXu5n/2kbw9Ub53wqTGYhfZLB9GkKhwjvC1HmzqNhJgJc9OBPamuYme9ZbWZHylDgWMWr+au2YP+7ZbTnXVD9Mx1A8mqieslKDjdn7QA+GKSJbpe5gh4/5GIagtl065bGE4E6I6qoUCAjtNiZqEWZ/zGkeqevYHaaWl7CDrcxlDnEQbwFPmac57FMRtA24wPNlZKBvtA/KjSb8ODZCpRxlVrQeP6i2DCcmgj2KTXjZbXe1Wx12DZPS0b/QOZascHRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNJcTqlXV299aHX6vXiCM+wgQ3i3TDj/D8IHXcMplyU=;
 b=LPu8j4djaaK9hyqBU9JEvZ7w+cSif3POz3PfcltWIASI8WkrlmmIbad6Se/AstTug+ln1Do6V2O3tFSPSHNkEpJGru+7w0doasV1D+Dr2vH7oXdBj040TysSUGip376/fFeLWQIBk2yT4jmGpaCJjErTIMRKXuoI3BYiPvSE6neznrIMMw0NzvcdlBYzBK8HtJcvgRX+pmwuaylRNdCe89FaXKiP8B6hzxG1QuN+olTkMMDGd88x36SHB24QfcQX5G/XsOLLApQAuX68rlT9/GiT5uYkuSAUvPvKVEwZPxtWRTm7XjRiQeXuB1ehMIg1H3VWjOKhkHUh2qr0jaafqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNJcTqlXV299aHX6vXiCM+wgQ3i3TDj/D8IHXcMplyU=;
 b=k54YuWqXGKzLhA1cSXZLwVDlCgPw/9FUk07xYtUEJaM3OfNp6ZAm922BGjRYyB04qS9feDzhT6i9OlrwnSBqDmX/Qa8Jix6vEPEraM6FS4tX5fEa9+boTMSX0RCYbuVxM8geuoOYjffHt+OiDdl6ScibybEl8lM2oqCVMBwOGgs2/HGCAcCfEBs+tc9v+/n1rWIBaOivgUTJf5Vy4iq4ftJOniuJbCZ4ju6BhfiGbWZhMOinvvowo/mPt2nH1jRQGDvynipneIwrg1Z9xtLmvPREMCPSh16rWD4mq3JAMmPhrnNGK68y8moZsdI9LxpPgnpSDpFhzUWO2XqCgk1GsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SN6PR12MB2846.namprd12.prod.outlook.com (2603:10b6:805:70::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 14:34:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 14:34:07 +0000
Date: Wed, 20 Apr 2022 11:34:06 -0300
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
Message-ID: <20220420143406.GY2120790@nvidia.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-6-ben.widawsky@intel.com>
 <CAPcyv4iM13nzCpnF5S4oHSWF769t4Av96gQM_3n4E=RAPSnSig@mail.gmail.com>
 <20220419164313.GT2120790@nvidia.com>
 <CAPcyv4hPBw0yJmu7qzSZ_gsbVuj+_R7-_r3+_W9-JsLTD6Uscw@mail.gmail.com>
 <CAPcyv4hyTRm7K8gu4wdL_gaMm2C+Agg1V2-BbnmJ8Kf0OH4sng@mail.gmail.com>
 <20220419230412.GU2120790@nvidia.com>
 <CAPcyv4i5MZcMcCq8V7sZQjqup6MPOoOj2Zuu8HEECADfFi2Tcg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i5MZcMcCq8V7sZQjqup6MPOoOj2Zuu8HEECADfFi2Tcg@mail.gmail.com>
X-ClientProxiedBy: MN2PR01CA0002.prod.exchangelabs.com (2603:10b6:208:10c::15)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 450fdc48-e043-4e6a-b87e-08da22dad354
X-MS-TrafficTypeDiagnostic: SN6PR12MB2846:EE_
X-Microsoft-Antispam-PRVS:
	<SN6PR12MB28466E4F711AB463C2906E42C2F59@SN6PR12MB2846.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XVYspCYy0FO7iYHb67xWSn2c72mRvF62FurlEHo/Lc67gt1OFKICz2oA+qSZYs7jBGbvW9108Od0b7uLTzSOERrHBR+ZP5G6fMNz1MqUMdZCennSj+Oz/JjV364iueXdBIrbZdwNp7G8aYLa2z7/oxGoYM0iu9+i10F0/ZriKIO+T5k1oH+OidOKUcPbg7axGgH9cqEQE+G0sUi1cYdD3hj1FuSHIT5Hh5d9L+g16tENe8a4hcEn94OiSk3Wus2qXjVaFSKp5ONhkEan41s5BaQNNJUlglOMwwThwLcSmdRDbXtg6mKqRe1rVZJ4ajglHPIPVLvHcktdhj3Z8n6+71UlGs+re26HKL9ezseqL/oqM6XTfmj5vQGFWQTpJ/lwJW5inxDuYUUzbG3Q8pQ72qooi0CuMO/19MWGiJA2fIsgC1GH7BBU5Ku77b2DEbQsLmfMOj0Etbtsjd+Bo6jhkzjAuFzQEObHbf2cxf5OJeYownGNYT6j44E03kc715iUK5Ag9V2h2BPvC/miULhmGcySM1j20MtDHpFn2YDl0z1MNlDt6cH5MAh/QM6mG+2gB4THGT2MKzAYuJQ2hixSFI7bUUUM3NK3Cq8E9zLODtOgTLJVzGI5lilsBoxPbbWkqgwD57f7Qb6POgCb7vl59Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(54906003)(7416002)(6916009)(107886003)(2616005)(8676002)(66476007)(4326008)(38100700002)(66556008)(316002)(33656002)(66946007)(6486002)(86362001)(26005)(186003)(1076003)(5660300002)(53546011)(36756003)(6512007)(6506007)(2906002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lUM/DGmECwcHEmI0ndwd/hdphTDDz2Woc7lQ9+dQ2Pblzoy86N0rQ66DQ79X?=
 =?us-ascii?Q?GugwDVWg6unb/90d3bGKJYLNah3TDoqz3GnxpnVQthFQb8C8W7ifUiMQBVhx?=
 =?us-ascii?Q?e0o2XLUN46Oiz0b00t53GLRKiqS6XHfz+LgsgOBxB/xRJ2Ij0SlFzRnjAw9+?=
 =?us-ascii?Q?eOl/Z1v/H0lvWug9tE45iCu1G57l6CSsEplPWFk6GZzJ2QrqL4/okJd+CIBw?=
 =?us-ascii?Q?hQLM07NyDIDZQaooNKBdeFkqlIQUfkgfXH+grMr2KpBN4wdftFzVJYdccVWk?=
 =?us-ascii?Q?VwKPST1MYFNqbn4d4UVoF9I5dfU05KmphIViEaxaVeg0dGo9VetakyKLrwl8?=
 =?us-ascii?Q?/Ckoqe70PL+EvzvwhFE4A0Q5txfpcpqPGjSBUtgfUkD5HLQGJhSjXEK7c/1D?=
 =?us-ascii?Q?Vo13sUkJLJ+hw463zumx6e0ywsV99VxTozUbNyJgflg5ixNZfKc7BoqaMJkU?=
 =?us-ascii?Q?t9pO6OyFaGQ7609thAqpJ1jetctOcdwa0vXSuAinsWru8yNdP3INp0wYmx+p?=
 =?us-ascii?Q?jjLuym0PNafVpb86LyBfMVSSt5TCS9N97s1VpHtqeyfy9TM2On4BnX18wC9d?=
 =?us-ascii?Q?4eiEL6Rh55ihAtQ+vOwTewGabPBV5fPyNsVb+1k10EEr9gsETdeYioh0BasW?=
 =?us-ascii?Q?1W5TMZ3ndDH9lxCSCqGwPsulD+rSMkawE+KkzTd0cMmPQ5ZDjmWaUaufSlGL?=
 =?us-ascii?Q?Yassti1+J+w5U6m3foSi4tpBtbbLdNgAqDk2fvSZOqrV4DXJQBKzfDvSiU5T?=
 =?us-ascii?Q?06Jb3FBQWuCudSCmWQ2lmsBOB0U6Uai+d/C0vIo40QLssYE2vJLDMMGMPgLK?=
 =?us-ascii?Q?6rjvihyYrBk22lOyCCBqTwE1VWd7UlCuiTtaY60muiT4bf7ZpVCxSwxizrdb?=
 =?us-ascii?Q?s+Q0+Q3jA2RiOX/vSLdxYQfeBTDIqb+klOLdRPml7w8Qvoum27aYUoEiybnP?=
 =?us-ascii?Q?1mrnZyDN6Ahrzn17kEpRFtcAvwp2DPlyL3o81y9GVsNgrD5mplAlKjW+AVmQ?=
 =?us-ascii?Q?GT+fM0ZG4wSaMBle/H5UfAIgWBeAHiGHQ6c6YLSLV+Pzl5n+XOeKftwSbzg9?=
 =?us-ascii?Q?0Tj3nA7y5t1KUZ1FyhtmNZXTIGoLJuFe/h1+cMzzHhns2PD5iHROl0YIhPct?=
 =?us-ascii?Q?uaElBch56ep5lkeK9ZMjEctvxKUJ8mcuFiTbc3fWTD4ksFscvOP2MFhEMn9u?=
 =?us-ascii?Q?dfsxPY6iR8v7EY0N+qhkqs1VIPfs7RR9F/dn7b0YPRg14upliFrHrm/Cx8YB?=
 =?us-ascii?Q?lkiXPyVlvrO0zDF6i6rWgaOEMCaKjscuoH1SbUa4RVw2H/2vrefbr1T4gbFO?=
 =?us-ascii?Q?4X504S5/WDdLxnJ8M1sW/oI1B66cYLKpiTwB6e+fSPgdjEKA1wtPrQsDh3CF?=
 =?us-ascii?Q?Ouajc8QeS/trZoh5Hn4pMmW0GjNbbvekROUB3OzV8m7b3BQ7CgTzVGNSyDRD?=
 =?us-ascii?Q?pzfrrt98lWwPpr4504DrvmyNhFoqf3+sO0Rq9b9499R/5OH91eJBQvLHq3Bj?=
 =?us-ascii?Q?x4vQRiL7/xBiDS5cVh/ouHQYsZVwQ9boGB050nHb30HKStN0HPoUB2eZGzli?=
 =?us-ascii?Q?t/GSO5eiPgy++Tk1OVf9mNqVBqXEdDK4wc4FBcX9hj5NVRS9ec7pgcPP1O7v?=
 =?us-ascii?Q?uWb0CNjkWY6qS55Yo8Cpt3e2uUueysqwc3l+i4ly0wRCqn/+DV/OyCs6VYm5?=
 =?us-ascii?Q?saWUnsmfP7p6SvRFloAtpeOXXAC0hHOX4GapVr0+xNeh7AQdIua+n2aCt2XF?=
 =?us-ascii?Q?FpG0akNcXw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 450fdc48-e043-4e6a-b87e-08da22dad354
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 14:34:07.1980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TsJi5DbBv/dm6AWUwTaEgpafsKt41b0xOizJEEiZDBC+ywJ5jb7JX+/J9ef/tkrM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2846

On Tue, Apr 19, 2022 at 05:47:56PM -0700, Dan Williams wrote:
> On Tue, Apr 19, 2022 at 4:04 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Tue, Apr 19, 2022 at 02:59:46PM -0700, Dan Williams wrote:
> >
> > > ...or are you suggesting to represent CXL free memory capacity in
> > > iomem_resource and augment the FW list early with CXL ranges. That
> > > seems doable, but it would only represent the free CXL ranges in
> > > iomem_resource as the populated CXL ranges cannot have their resources
> > > reparented after the fact, and there is plenty of code that expects
> > > "System RAM" to be a top-level resource.
> >
> > Yes, something more like this. iomem_resource should represent stuff
> > actually in use and CXL shouldn't leave behind an 'IOW' for address
> > space it isn't actually able to currently use.
> 
> So that's the problem, these gigantic windows need to support someone
> showing up unannounced with a stack of multi-terabyte devices to add
> to the system.

In my experience PCIe hotplug is already extremely rare, you may need
to do this reservation on systems with hotplug slots, but not
generally. In PCIe world the BIOS often figures this out and bridge
windows are not significantly over allocated on non-hotplug HW.

(though even PCIe has the resizable bar extension and other things
that are quite like hotplug and do trigger huge resource requirements)

> > Your whole description sounds like the same problems PCI hotplug has
> > adjusting the bridge windows.
> 
> ...but even there the base bounds (AFAICS) are coming from FW (_CRS
> entries for ACPI described PCIe host bridges). So if CXL follows that
> model then the entire unmapped portion of the CXL ranges should be
> marked as an idle resource in iomem_resource.

And possibly yes, because part of the point of this stuff is to
declare where HW is actually using the address space. So if FW has
left a host bridge decoder setup to actually consume this space then
it really has to be set aside to prevent hotplug of other bus types
from trying to claim the same address space for their own usages.

If no actual decoder is setup then it maybe it shouldn't be left as an
IOW in the resource tree. In this case it might be better to teach the
io resource allocator to leave gaps for future hotplug.

> The improvement that offers over this current proposal is that it
> allows for global visibility of CXL hotplug resources, but it does set
> up a discontinuity between FW mapped and OS mapped CXL. FW mapped will
> have top-level "System RAM" resources indistinguishable from typical
> DRAM while OS mapped CXL will look like this:

Maybe this can be reotractively fixed up in the resource tree?

Jason
