Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1607443DB;
	Thu, 23 Jun 2022 05:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655962864; x=1687498864;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jXQESWL7EF/qfcWvf4mYsWdtG/3jakVYNaHeiuWcFMU=;
  b=Wse+2JGl3fB8ZJEKxuw+S5VBkxsFjn3p0JSUz++JJJ6W8pJvGZh7iX2V
   l7X2vQt/iV57mco1qq++pt6b9nRjiz6lcR71JR1hAiIwWx02Jr57STH+z
   +eC39KcwtyFRK2YgPmfLvAuMPaIeb34pUHkc+mbsYbWCMU1TUCuCJnC8J
   d7vIUvwBcLHMWDd5bZHOhTQo2InVPEtsjEldMWiBP1O10b3XIKKo704tY
   wpvYDnPDfgBmqw7FGAIwQM5FghmCe+J/+o2g1r26KNxMA6rMTJQcQa4w7
   TFm1xyL2hW/g352EvaEx/VxwT/S6cDvrQsVCZvEbqz63RvfP598Bk4olR
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="278180307"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="278180307"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 22:40:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="765170049"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 22 Jun 2022 22:40:53 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 22 Jun 2022 22:40:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 22 Jun 2022 22:40:53 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 22 Jun 2022 22:40:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1J4MlHWvYc8GY0fxoVoxwr+Ny2h6V0Lr8ym2CB0jnHZdHvdhfhdPYxn93R8/Dx2x/nzyP1khzDWIPEfw235WdrdRh8C2JqDgR5+AwPSx3vQG4sAjeX60BOx831CJNK1/2OYr/gAFh4yw9OprntScvTq22OUQRF1Liku4Wvc8nmOoEAOD8QLcr0SU+BORq3HFaq0WtTaeeY8+OyX4FCn8iFsFIoD8kox6VjO0X3hOe06+bO98St0mZps8yfmtIoYzFpISYR9EdIISpUxl6UZonnl34DwercyXnETIYGUenbhclpEeeOiB6WierECxTBQo8n/u2pabrxmrtnUA8phlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrvuyOXEf/KZWtGbdDRsL+pm01CwoU1XaX4/XoL15vk=;
 b=Uy41t5DTZMIEE/I39NcIaFLWiEABmKQ7CD6SUX17A+O/95g7BNBYW/cOgu+RJpSqulEhX628wIY4cF1pIkNNH1IXqIEB3Xeuy8pDz6Oo7ngtHM2GHvjtDum9CUmIw5lC8LEArzebdLKAlAiAtEp7TBH0wkgv6VdwZM/19gXDbUEAY6/Z7hxhd03rnpGoOsN7HSFse9bC6kMkRd2iw6Mdgwme1HLcRIH8yRACxScEkpB64yFapI7OEsL6/TET5CtL7z8svCd3KNn3945hDrsjLhDQPjNMM9mxQKBIVHXIJeiYzz6VsnxfspOhPLtU27EX/ztl9FOHR0bp4J2wuisneQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ1PR11MB6225.namprd11.prod.outlook.com
 (2603:10b6:a03:45c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 23 Jun
 2022 05:40:51 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 05:40:51 +0000
Date: Wed, 22 Jun 2022 22:40:48 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: Ben Widawsky <ben.widawsky@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <patches@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 00/15] Region driver
Message-ID: <62b3fce0bde02_3baed529440@dwillia2-xfh.notmuch>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220520172325.000043d8@huawei.com>
 <CAPcyv4hkP1iuBxCPTK_FeQ=+afmVOLAAfE6t0z2u2OGH+Crmag@mail.gmail.com>
 <20220531132157.000022c7@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220531132157.000022c7@huawei.com>
X-ClientProxiedBy: CO2PR04CA0176.namprd04.prod.outlook.com
 (2603:10b6:104:4::30) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 238fcfdc-51a1-4e8c-73d1-08da54daeecd
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6225:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <SJ1PR11MB62255CBCF43BDC2169F421E8C6B59@SJ1PR11MB6225.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n+14tr7BYa81MTKlYXFXwXtpRmIfqqfscTJuC9SHl6Z7R5+opJVqE36yBvhWUnAntyf3pkCcCiS9Wz03kDtyXfLL/bZZDzYNjOseXnfeacy0OzfCvD7QcB1q3sS69FwoQH56C7lwfz0zQPbeKOyMo/MgmJm42W1EeJOdinYsazTTkDfIExdtPhTOshtv5jmF327urbDoE+yEAoPDKKE5qMPD3Di84rRI5LzZx/KSEdy4u228HttUtqMbQ2ZjVLnMhup2Mcn+2ejK2YgnH/7nzTkP8AJDrWKTNGTXOSm5L/tbO/sDIFNg+FCVNYiPSLUVj1tddVnJOYR1xh0torVoXp8mT4xwXjGNpreEXmUQ7KNTORZulTHqFBdIyIEfKOslSuj8s0ly4qcRUy9q0RYo4OsRNawR3fSqdPl+p917l7Gc5fTXxXjRpMSOWmb+1KU1TpuYFCepNjC2FolPBJiMTUQPiiwGuoCKYd2SiJ4PaZAxG9W6MApuiWUMUjs46s1jgsbfgDxU2Ev5zJ0OxrY1tk3K7O8P4Y4auWjUhz4sDRspNEU3UV2eBwa3KDN2x6EroNrJWAQFjy8Mh7Jln0XpaVNzjUkQkJWmm2CBpDp8phieI8xdv9+gyLGVaDVrfk8P8R4X2DTWK+owVzSmYs+bz5Oisy9LlFkR8du46Q89eFozagz1KHpxyhlrNKNAU42slRKfS6Ms8POlx5LnJNr3ytFc7yxyUxhfwRNBiq2T9cI6aexR0I6J3N/XR+DPC8rn84U4iduPsoYjq28K6sXHWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(39860400002)(396003)(376002)(366004)(54906003)(107886003)(86362001)(66946007)(9686003)(2906002)(6512007)(26005)(8936002)(38100700002)(41300700001)(8676002)(6486002)(5660300002)(6506007)(478600001)(4326008)(82960400001)(966005)(66476007)(186003)(66556008)(110136005)(316002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?62qTUiGH75GLEBBxtFpGdlb8Bqnmkx5jp6F3CbDkUPqJcBIrZwJJCLFAMf4I?=
 =?us-ascii?Q?3Z87tHs1je5EuYSyIbUnBxodbFAVYnis9D5UcWY2l7uJufkHDPDCWB6OmIrc?=
 =?us-ascii?Q?UiepBeo2qFRYqfeNp9RlGLLmT1IyjhYbE1D0sVZkvfiEJ1I82AUJYuIm4qzo?=
 =?us-ascii?Q?KgLqed0x/ViPAddtMhlAIbEG0T3t7uyuRViS6nSR+xggWXo+gZFNkCnAGSva?=
 =?us-ascii?Q?wrzHjULB6xWKQrtxKv3WaGpQjEoe0EyyQk4Kb/VmXYXvG4cigBPN3QA0pOgu?=
 =?us-ascii?Q?vnvB9hHU6gxZClJ4AT9i5SqOd937QNHeDHtNBc3hNT/V3iD3gNfr4F9OSq+6?=
 =?us-ascii?Q?9G0X31x4iCOsT2l7eXzQUeMstMs20tYBEL5hiFJno95Y5GEEkh8N9ZTg3PEW?=
 =?us-ascii?Q?4tGEYKnuJ6I+S+JD+K16cTas+QCOUPKQFWD43BeMdVjDzrABcIizhca+CG2g?=
 =?us-ascii?Q?2hN8KVt5tk84rGPuntNIruIWOBa1JY94QOnN7itZRazhjJK2MRDTqAe/sbY1?=
 =?us-ascii?Q?RvYaklCGCb5PRDLSUVCO+fJoEkmuN6ofd1AF5Cs2Q/yIa6rbyY25gmHuisS4?=
 =?us-ascii?Q?pA/gJDQjTU1bYXBudJd0HSG5bejKhKLdkK3onZ4sMfjpis98yTcyfuguwViz?=
 =?us-ascii?Q?l6+jN+biV2fWalTsTmpAVLeXKn4XBsWuWNlUzlSHPdt2DWUPe32AyGq1GZ8y?=
 =?us-ascii?Q?hKTNoypUCitZiseCtmdq7QBKofb5JXtnvvPWyv1Hi5BXjrnPhm+SukFE8eHe?=
 =?us-ascii?Q?BRqp8jpHOK15R7/ernGltlHuEVJWooLzfeCupTg6QOKO7yvstMEK6bQ9rrEK?=
 =?us-ascii?Q?Vt0Se+H/9WwGHvRXrg6lPsBH23ukdO14AC8VjWh5NTf/kNHSfXe4fPhdKu+F?=
 =?us-ascii?Q?1eTtckh7FpD2qXe1jNFzaeLjv5TptFZcN1OThwIkxuvw83Bjr7W6U+Xj4xuE?=
 =?us-ascii?Q?UKXm4XURHe3Z2HUtfaD1aABzNU+2rO+uooacyR+Vrl52XkmRcaLWq23ZtQQs?=
 =?us-ascii?Q?7a59EPttUH5a74VDTdFLpu8i1ZjRJClq7xRobd9yCpuG4AwqhRcB9drS59m7?=
 =?us-ascii?Q?fBArrkRHdxVKRjuzKWUxMxMJZYis5Xt0CocoGcMTdk5/ITTebaFLH95dGg/Y?=
 =?us-ascii?Q?YVU+Ltvww8qA37VIVVpGJ1pupbDw9psmXlRk7/oGbQ1L3zQnxF40Wf4T0meT?=
 =?us-ascii?Q?9kb9XxwYSH1DpVtoVND8+TqHnAeSabegqF2/00MziJjYnhefM0QwtR46tpVI?=
 =?us-ascii?Q?Vki6bIOFMaE8jXepQljH4ABL17g3jQU0fNy30w1RZrXo5DoY7cc0g+f7Ivfc?=
 =?us-ascii?Q?gFyXv6CRDo/bnfyQ1xIiqD9WkoZPWxhU618Yi0Rcq6eFACT0bVnUWNEEpMLU?=
 =?us-ascii?Q?iY5ORAsIXv5RazShcHMEoMVvo+ATkEN1caC33p8HI4gm/E5uMfBBcJT5kkVo?=
 =?us-ascii?Q?r8Yd4LkEBK9KolaZ+iEBVn1aLg6Uq9RBA255kMpvSfmmFcwCeFTttMi8i5D1?=
 =?us-ascii?Q?JD7uiHwVX4ge2hmkU32I7uxwM3wk1SBR56GLZxufN1z9ZCyNmgMCguxtizL/?=
 =?us-ascii?Q?ukVGxt+7yb2TTcU+mYL2nNHJKszMSg1mO+tng9rTD/4TU451BSE4/D2QZofr?=
 =?us-ascii?Q?Y4NiyKa9w7dVg8l9MeVElOjdUMGEXIE8Z+ikMw11E35rtQ8pCzdPflSqb4ww?=
 =?us-ascii?Q?HatrzGZgqqX3TFN25pbdFhwrsohyGMJHkMEFWKnXbSNZxF+046O9Xw31Pqhs?=
 =?us-ascii?Q?9HGZ774snvthOVqTgs1BOYRqXY47Aa8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 238fcfdc-51a1-4e8c-73d1-08da54daeecd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 05:40:51.4579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JXm7p+mOdViEB1LfIwOMMC674s5yapF+J06wXk7HxoLaazVpPeWo7BOeGTFKESY/XRn17rdoIgR5s/cGY+k1oNdc5caGfnR1nzkTOOJpxz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6225
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> ....
> 
> > > Hi Ben,
> > >
> > > I finally got around to actually trying this out on top of Dan's recent fix set
> > > (I rebased it from the cxl/preview branch on kernel.org).
> > >
> > > I'm not having much luck actually bring up a region.
> > >
> > > The patch set refers to configuring the end point decoders, but all their
> > > sysfs attributes are read only.  Am I missing a dependency somewhere or
> > > is the intent that this series is part of the solution only?
> > >
> > > I'm confused!  
> > 
> > There's a new series that's being reviewed internally before going to the list:
> > 
> > https://gitlab.com/bwidawsk/linux/-/tree/cxl_region-redux3
> > 
> > Given the proximity to the merge window opening and the need to get
> > the "mem_enabled" series staged, I asked Ben to hold it back from the
> > list for now.
> > 
> > There are some changes I am folding into it, but I hope to send it out
> > in the next few days after "mem_enabled" is finalized.
> 
> Hi Dan,
> 
> I switched from an earlier version of the region code over to a rebase of the tree.
> Two issues below you may already have fixed.
> 
> The second is a carry over from an earlier set so I haven't tested
> without it but looks like it's still valid.
> 
> Anyhow, thought it might save some cycles to preempt you sending
> out the series if these issues are still present.
> 
> Minimal testing so far on these with 2 hb, 2 rp, 4 directly connected
> devices, but once you post I'll test more extensively.  I've not
> really thought about the below much, so might not be best way to fix.
> 
> Found a bug in QEMU code as well (missing write masks for the
> target list registers) - will post fix for that shortly.

Hi Jonathan,

Tomorrow I'll post the tranche to the list, but wanted to let you and
others watching that that the 'preview' branch [1] now has the proposed
initial region support. Once the bots give the thumbs up I'll send it
along.

To date I've only tested it with cxl_test and an internal test vehicle.
The cxl_test script I used to setup and teardown a x8 interleave across
x2 host bridges and x4 switches is:

---

#!/bin/bash
modprobe cxl_test
udevadm settle
decoder=$(cxl list -b cxl_test -D -d root | jq -r ".[] |
          select(.pmem_capable == true) | 
          select(.nr_targets == 2) |
          .decoder")

readarray -t mem < <(cxl list -M -d $decoder | jq -r ".[].memdev")
readarray -t endpoint < <(cxl reserve-dpa -t pmem ${mem[*]} -s $((256<<20)) |
                          jq -r ".[] | .decoder.decoder")
region=$(cat /sys/bus/cxl/devices/$decoder/create_pmem_region)
echo $region > /sys/bus/cxl/devices/$decoder/create_pmem_region
uuidgen > /sys/bus/cxl/devices/$region/uuid
nr_targets=${#endpoint[@]}
echo $nr_targets > /sys/bus/cxl/devices/$region/interleave_ways
g=$(cat /sys/bus/cxl/devices/$decoder/interleave_granularity)
echo $g > /sys/bus/cxl/devices/$region/interleave_granularity
echo $((nr_targets * (256<<20))) > /sys/bus/cxl/devices/$region/size
port_dev0=$(cxl list -T -d $decoder | jq -r ".[] |
            .targets | .[] | select(.position == 0) | .target")
port_dev1=$(cxl list -T -d $decoder | jq -r ".[] |
            .targets | .[] | select(.position == 1) | .target")
readarray -t mem_sort0 < <(cxl list -M -p $port_dev0 | jq -r ".[] | .memdev")
readarray -t mem_sort1 < <(cxl list -M -p $port_dev1 | jq -r ".[] | .memdev")
mem_sort=()
mem_sort[0]=${mem_sort0[0]}
mem_sort[1]=${mem_sort1[0]}
mem_sort[2]=${mem_sort0[2]}
mem_sort[3]=${mem_sort1[2]}
mem_sort[4]=${mem_sort0[1]}
mem_sort[5]=${mem_sort1[1]}
mem_sort[6]=${mem_sort0[3]}
mem_sort[7]=${mem_sort1[3]}

#mem_sort[2]=${mem_sort0[0]}
#mem_sort[1]=${mem_sort1[0]}
#mem_sort[0]=${mem_sort0[2]}
#mem_sort[3]=${mem_sort1[2]}
#mem_sort[4]=${mem_sort0[1]}
#mem_sort[5]=${mem_sort1[1]}
#mem_sort[6]=${mem_sort0[3]}
#mem_sort[7]=${mem_sort1[3]}

endpoint=()
for i in ${mem_sort[@]}
do
        readarray -O ${#endpoint[@]} -t endpoint < <(cxl list -Di -d endpoint -m $i | jq -r ".[] |
                                                     select(.mode == \"pmem\") | .decoder")
done
pos=0
for i in ${endpoint[@]}
do
        echo $i > /sys/bus/cxl/devices/$region/target$pos
        pos=$((pos+1))
done
echo "$region added ${#endpoint[@]} targets: ${endpoint[@]}"

echo 1 > /sys/bus/cxl/devices/$region/commit
echo 0 > /sys/bus/cxl/devices/$region/commit

pos=0
for i in ${endpoint[@]}
do
        echo "" > /sys/bus/cxl/devices/$region/target$pos
        pos=$((pos+1))
done
readarray -t endpoint < <(cxl free-dpa -t pmem ${mem[*]} |
                          jq -r ".[] | .decoder.decoder")
echo "$region released ${#endpoint[@]} targets: ${endpoint[@]}"

---

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=preview
