Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31D323B9
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 08:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670056905; x=1701592905;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U78DOE2ti9cubbKAMRoAUFKA3ty4CK0bVt5lgsZzppM=;
  b=OVGXN/iZaI2ioxaMXGNwVHubGfVcqaHloBcqqIJLvAjsrax/RErCIw0t
   73FOAHRo6exM+lOg4fvPEy2CK+1KgTMZYVjhyxF8nbbh8zwUF899YIWTW
   +pTmTtV+ah+ik9kxlIJFDrDK3APCdIzOnPsH0U1PkV7Mgqh4+6yov3ydG
   GoNRhu5YGjaniheI2/ldt0LbLXBzzg0uORBaG+eGK+/bs+DhdAE4CgQdE
   YBZ55Ri+2DCvdpB9vbeZ5euchI9Y9hrfMnE5QU98mUI1VANMfxp9htGY+
   c9PxCQOAk0z1iBCEUqjCeN6Qt8aRZrsVo3t6h/pO8o09IHQYJo9Ko35af
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="314814611"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="314814611"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2022 00:41:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="713882930"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="713882930"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 03 Dec 2022 00:41:44 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 3 Dec 2022 00:41:44 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 3 Dec 2022 00:41:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 3 Dec 2022 00:41:44 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 3 Dec 2022 00:41:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTN3ayXommFQfWI10f0flFZrUkV0M7XG1OgsS5ZnxktXKvvBlO1PRPJk4AzOI1iGqCfsAL+43V5Q7RqvzyAFgkc+xYR2FMxa9CRNSD03g5rXsbYT6WT5qDbztFORxcW9pEM+AkkRqixflQ6fTrTYcUnzjwYmFRkrWen87TekSCk4U5HVmmMD6Qd0pOBMLT+pZL3QLnWV4kD7J2O1Zmi9VZLBLWTr9KXOJpK0nSGzZqdrOBO0aIqfVNVMbhup0x7wqbNgrj1uawg15D4arffc202o0g/Ce1QupgWXmfB2DyqRTqN3i9fat4K2oh7bpEQbGFhmqK4ZoR3Us/B53NYY5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZH53YGuP8/edvqmwMmnlpHQeZMon0hnHbR8EDP0XHJs=;
 b=CgRM70VakRjVtv39dHcIoNuNCPcsorfJ1EZUubBdhDJRM8dWmgxgs5Fx4SyNmirrkzH4EuuOocDBV8idkYRY48tADoxfHzVsaEwaa6oGZs/8aT326tp71V2guEGzDoIHdBgwIZINahe3TyFdQflyPaAzQIzdRORcnxIinAjsMBwIUZ6/XLsn5k8h4vVZa+W61NMnKodqHshUvszHIU4JnV/D7kL1bvLPb8mfvfUZfLBPWDyT9JTNT5Q9xrZ6NZ+e/JHm+T3OGa3vcV2zVrn4xc3q3hjO3epF6P4n7InysrPxwcyXeGd4/zbFqq9+2xtIMorG+HNXZC465uW1RDCNKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CY8PR11MB7011.namprd11.prod.outlook.com
 (2603:10b6:930:55::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sat, 3 Dec
 2022 08:41:41 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 08:41:40 +0000
Date: Sat, 3 Dec 2022 00:41:36 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Robert Richter <rrichter@amd.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>,
	<alison.schofield@intel.com>, <bhelgaas@google.com>, <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <638b0bc074432_3cbe0294e7@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993044524.1882361.2539922887413208807.stgit@dwillia2-xfh.jf.intel.com>
 <Y4m0WbVSWjkeF+7x@rric.localdomain>
 <638af5119969_3cbe0294cb@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <638af5119969_3cbe0294cb@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: SJ0PR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::9) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|CY8PR11MB7011:EE_
X-MS-Office365-Filtering-Correlation-Id: 1058f1ec-d12f-42e4-780b-08dad50a3207
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6KoL1iBfFs0TTuHz78ouJ8eWbzufmoDh+qKJmuaFXkBMbJMGjFS5mRIkc6qwmrLcxxWS//pf3yvcP5MC7YmZz1oKHwBhpWMIy64tf52Vm7MJKrX1JsCq4BnfS3JWKPpskhHkUWi4rOlAVHy1taeDsUqrhmGElA4n4QiWtcPPo2wiX/C73DbRv7YjL150jpIKyBZBVNsFegWLndiuhU2Ek1h+iBjq5vxfv9C4v684nJ1neQkMmEfyQ7xz/WJ+CGhAmRjT6sKMJKnk1C+AavvEUG8s2BHZj8YYRvrRbjHY/XJ5Q1xFa+BWhje8tVolZdyDgxIF2AsmCDpvGX14R8dW2HFvH/PcMT/6p6zTVU8otyHrDLmVkJ7vCaFY8M6ZDPrAXrHXOV+Nq//DnlYe+OGOxKju+0u3NHbgISaZnwnvaSQX8N2nM+qPz3WrUYZyOcyHtzZj8C3pE3FLZGCzh8/ku8o/TAo8PoleV9M7VCuRNj/W+ZiiiQSyAYEjky9/PLWGw3KgAUMQjTDb/GZewyu69Z7egjPjpS+3ZtJlqJXBGVI0TtlFexgpDmKPIZUKK/7/8nINgoMF6y8BUJzqaSCqRIASJli5pQ9DlfAGfTEpAQIS377Jh/zo9AN0sY+v9dRWHooYiq8J8ECpzCUUsAfZbICjBBZMnSPVC7EacbqyMdM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(316002)(2906002)(5660300002)(26005)(8936002)(110136005)(41300700001)(6506007)(83380400001)(53546011)(186003)(6512007)(9686003)(86362001)(66946007)(66476007)(66556008)(8676002)(478600001)(4326008)(966005)(82960400001)(6486002)(38100700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fHQdBix3TwLcvHIpmMzuPJe69n8v48rLqtKbPoxNQ1guCuq/Q4br0Aix0JBK?=
 =?us-ascii?Q?GerQqPqyu39x1XpdeT1bpwRDPF/uVJ9tLnoPPxPZ/gsoAW55lS86PIHagFkJ?=
 =?us-ascii?Q?EGC4vzvB48tIY4c10TGVrQfg8kvB1VRzw74yR7SfsPNOP/sNkiYjmdPe8e3J?=
 =?us-ascii?Q?ZnU1rfdfDliDoKhwSYQBb5JGll1m5ihg8yuw3n0m+FD/5Xexn273hAJkgqYX?=
 =?us-ascii?Q?9a6OiVv7sbfkM/lsA1jcpFABcl/hIOhVJVgVRzoRfutF4FTiG3CDB4to2l/E?=
 =?us-ascii?Q?GN/WOhAbfNx+sIS5yH1xqA4tkrZBsKGcF5azvi59IsEIjYOYDK4XqLu5LHVY?=
 =?us-ascii?Q?PJJ6vULUd+CxFWRBVpnZeHd1ihV3rCzjM21fbQLQseYa8KS3Iszn4oO2dQoO?=
 =?us-ascii?Q?h3ebaBnNcvYsCKE6bKE6u40qwILtBXRhyz1t5HOCKuIMIk6bOGEJvOhSkQOT?=
 =?us-ascii?Q?r+6Ff2WepQfRZhMHY2dWmrPHvCC5LUSSEAHf+IhPMSJFZMrSHnZf6Y4W915Y?=
 =?us-ascii?Q?w/BmY1pjcZecx9Yui63OikMh35cHYwdCAMPZJw3VoQDPGf2b8cb3cULuUjYq?=
 =?us-ascii?Q?5aCZj5vs2pAmZpmKKW/73rhidZDB5BlotlGKFikiHg1PO9KIJ3T0dFL8HQ63?=
 =?us-ascii?Q?v0+4Vpn0ylWrRJcHN2eG2rlLqZIQonCKGaQLqf3MhQCxAS0ny6QSvIdxKKas?=
 =?us-ascii?Q?DBRECej1sqrscSzVqPLrKnQtRnljg+hfrPymhheMcxb1v0KZr5AFvJCXMFnl?=
 =?us-ascii?Q?h3lDjDIpleq+97BJRJk8SVMYM687dSaH3Oi8fbIVPmF1X5nLx3VK2WAH6JKz?=
 =?us-ascii?Q?vStXrBmQXMLYoFdwCDuowtZFKk3IHV8l1CwaKb3JwKEgQ3nhenkllgPKJwrP?=
 =?us-ascii?Q?yGwGsQmTRCdOFFr1dg1Ysp0V/fhA2myaXjEuKY1Y4bt3kAJpd6EqWeMdeQhI?=
 =?us-ascii?Q?Mf+r/rvOfVVzp94gxcG+No/dx2RP+PFQ4Osy6BLJ8pXIq37DTQd/gED7OBe7?=
 =?us-ascii?Q?GP5m54/wDBF/FXHu3r88h7lsUT+bV7uyD3B9LTBdPSsf0uIrOCTNmNhqLo3s?=
 =?us-ascii?Q?om/Mbv9m0k92Ckh6S8JMkNTdNRV8LydJDo4tYnOyPDpf2xipZq0syn5Tmk6n?=
 =?us-ascii?Q?P8ZUrEgsujj4ClvknTgipdWZ0jNNML7amXtHxzfJ7lhLrl0LpHAqdIOa8UeN?=
 =?us-ascii?Q?a9DCtqe5wCi7sPXhEBKajgxsnj2yTCSO7W81XnoTQx8hYZCjuQgNxBXnlgHe?=
 =?us-ascii?Q?1+IRaoegC7UFihKtISfWYVHMKaqkGA0CFCZUKoZMSzdopiq00t68cj6YpdCd?=
 =?us-ascii?Q?jl/PWwjmSqIPnkpboO39Q9pSBI/kDVWCl/7gAcTUZclVTw/WUCLWLSflVKoS?=
 =?us-ascii?Q?6f89q04L23BWX2FLraJ9rh14NL497MnYu586waJK1XoeG/ii8c1DsKqJ03Mh?=
 =?us-ascii?Q?tFhmyR9+8i6bykczCj+KUMyL0Qfp6lGx9VL3odTZScfUp5qEnuOnsjAxaIJ8?=
 =?us-ascii?Q?Ym14e8pAjjDDSXTS5nfKWGxiiGLQXYoNwNKUK4wtGN8IaIKPI5Bh2JGr7H0y?=
 =?us-ascii?Q?K1u8hexs/r9kdPimSy4rMuwMkTzF++sDVyHzil4qHaMorRkOVJwYHDy+h27m?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1058f1ec-d12f-42e4-780b-08dad50a3207
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 08:41:40.5991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IgGpN56SMZfZUf97RCYpABL6b3QDp06Xu2vkM+wv6ogm16oeAGnWR9qS/cyUXxKpZ74Gc8K3WRQmdIy3+OY6En2lpvKzgmp85KvFX/zWFX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7011
X-OriginatorOrg: intel.com

Dan Williams wrote:
> Robert Richter wrote:
> > On 01.12.22 13:34:05, Dan Williams wrote:
> > > From: Robert Richter <rrichter@amd.com>
> > > 
> > > A downstream port must be connected to a component register block.
> > > For restricted hosts the base address is determined from the RCRB. The
> > > RCRB is provided by the host's CEDT CHBS entry. Rework CEDT parser to
> > > get the RCRB and add code to extract the component register block from
> > > it.
> > > 
> > > RCRB's BAR[0..1] point to the component block containing CXL subsystem
> > > component registers. MEMBAR extraction follows the PCI base spec here,
> > > esp. 64 bit extraction and memory range alignment (6.0, 7.5.1.2.1). The
> > > RCRB base address is cached in the cxl_dport per-host bridge so that the
> > > upstream port component registers can be retrieved later by an RCD
> > > (RCIEP) associated with the host bridge.
> > > 
> > > Note: Right now the component register block is used for HDM decoder
> > > capability only which is optional for RCDs. If unsupported by the RCD,
> > > the HDM init will fail. It is future work to bypass it in this case.
> > > 
> > > Co-developed-by: Terry Bowman <terry.bowman@amd.com>
> > > Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> > > Signed-off-by: Robert Richter <rrichter@amd.com>
> > > Link: https://lore.kernel.org/r/Y4dsGZ24aJlxSfI1@rric.localdomain
> > > [djbw: introduce devm_cxl_add_rch_dport()]
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > 
> > Found an issue below. Patch looks good to me otherwise.
> > 
> > > ---
> > >  drivers/cxl/acpi.c            |   51 ++++++++++++++++++++++++++++-----
> > >  drivers/cxl/core/port.c       |   53 ++++++++++++++++++++++++++++++----
> > >  drivers/cxl/core/regs.c       |   64 +++++++++++++++++++++++++++++++++++++++++
> > >  drivers/cxl/cxl.h             |   16 ++++++++++
> > >  tools/testing/cxl/Kbuild      |    1 +
> > >  tools/testing/cxl/test/cxl.c  |   10 ++++++
> > >  tools/testing/cxl/test/mock.c |   19 ++++++++++++
> > >  tools/testing/cxl/test/mock.h |    3 ++
> > >  8 files changed, 203 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > 
> > > @@ -274,21 +301,29 @@ static int add_host_bridge_dport(struct device *match, void *arg)
> > >  	dev_dbg(match, "UID found: %lld\n", uid);
> > >  
> > >  	ctx = (struct cxl_chbs_context) {
> > > -		.dev = host,
> > > +		.dev = match,
> > >  		.uid = uid,
> > >  	};
> > >  	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbcr, &ctx);
> > >  
> > > -	if (ctx.chbcr == 0) {
> > > +	if (ctx.rcrb != CXL_RESOURCE_NONE)
> > > +		dev_dbg(match, "RCRB found for UID %lld: %pa\n", uid, &ctx.rcrb);
> > > +
> > > +	if (ctx.chbcr == CXL_RESOURCE_NONE) {
> > >  		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
> > >  		return 0;
> > >  	}
> > 
> > The logic must be changed to handle the case where the chbs entry is
> > missing:
> > 
> > 	if (!ctx.chbcr) {
> > 		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
> > 		return 0;
> > 	}
> 
> Noted, and folded into the patch.

Oh, this also means that the mock version needs to return non-zero.
Folded this change as well:

@@ -702,7 +702,7 @@ resource_size_t mock_cxl_rcrb_to_component(struct device *dev,
 {
        dev_dbg(dev, "rcrb: %pa which: %d\n", &rcrb, which);
 
-       return 0;
+       return (resource_size_t) which + 1;
 }
 
 static struct cxl_mock_ops cxl_mock_ops = {

The component registers are never used when talking to mock devices.

