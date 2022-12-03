Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C481FDE
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 07:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670051098; x=1701587098;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AIZHtushJFoOIneg4t9fs7sjEDkVzGnrPVnWUNvUv3E=;
  b=kDhIwVjTfUsa+ZnqXEf2PgFMZDPVrf0fzeyik2Zh4rj1zLL6H9wxFfAg
   WMvNxk39x2JZlLCVFC112Tc41NimggzJpF5k7opb3J622mrTVgrfz3TGy
   FgYRmrXAIAU8MiyS7OShcTVo0VDSeO1uzRV+b+W4cjOwjVTf/+GknYt2b
   MeO/oTsOce7jgcDuDNfu6cOAERHyDRB10tRQz7oylbjjLFhtVsPMg5TbW
   gVcJmbabxndFy3zAJeI5Oa4uaHAe4LKaR1SiurgVJJm9azBIP2EQr1jNE
   yrWntpe5nu8+PxyQ76nKKRwEWymDbC6zUUjKRbpbGWORhOt560cDAFmLl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="295796718"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="295796718"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 23:04:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="595680573"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="595680573"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 02 Dec 2022 23:04:56 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:04:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:04:55 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 23:04:55 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 23:04:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBKo1AAHajg638yp11qFzteN4AbNJ/1vJLhQZgId4ySiaROH4tzxMSZWUNwTMMwYwqcH1YD7Gz14QMQW2pAhC1pGKnGwghPdMiqLVCFHLZcV9JcOPQj6uYI4509GGlCs+7Z0vydb5FKKIRNzqMf0Wm4Y1J6u9dhw4lGBHI0uL1rAw3MqqOtTKBWRGsgJQNkyl7oucoMsUSs2qkH+tAyFqAPhCkYV4FeosUrHJekEnMwQqX8cj4GfnWUgQa7LJ4J4xvBZianLcMSzxXv0/zO2f4OjILwFwQkyMXdZ46TSbAJt62CDTm4f52zY/1Lssk59WDLpmgONM8V1veBQnPyBNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDwxue+idBMyZ/FjVnrRddzOfM0mHed8hs9sV91CIoc=;
 b=koZNYGE16JNy3lbzNl5Zfxn/2ZVQv+UHzeRoCsFfYWgNrGRfydChSBNJTx0+hjsmnXRGjHkGccHzetPrWLlEH528Bj8s1UPCoPMmpAEhV8RgaaRNXpd/brjeAQ8F+DHpoXbwrBlUJ4l6wd25uKlavZAvdc1ft+8IsImEUcwJbIgMygG7LZLK3mET16PI35Ld2tuo2NFT6Pm/wB1VzxKVbaDeDcvENieA5/1jHLJYJyIVrU5aJV5nION7YxYh6CjMBYyzNANz3QlaRPwHWR/MyhN5WPzR/do1NC2pIR6gQVRwSDmJpoe6vc14XqqwKQCEoYH1Gx5EHJD2AByk4pbYtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DS7PR11MB7907.namprd11.prod.outlook.com
 (2603:10b6:8:ec::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.6; Sat, 3 Dec
 2022 07:04:53 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 07:04:52 +0000
Date: Fri, 2 Dec 2022 23:04:49 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>,
	<alison.schofield@intel.com>, <bhelgaas@google.com>, <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <638af5119969_3cbe0294cb@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993044524.1882361.2539922887413208807.stgit@dwillia2-xfh.jf.intel.com>
 <Y4m0WbVSWjkeF+7x@rric.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4m0WbVSWjkeF+7x@rric.localdomain>
X-ClientProxiedBy: SJ0PR03CA0080.namprd03.prod.outlook.com
 (2603:10b6:a03:331::25) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DS7PR11MB7907:EE_
X-MS-Office365-Filtering-Correlation-Id: 08a53e54-1958-4d36-909f-08dad4fcac48
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G/7Ueyj/qVrXSz4/EDxiJZEWSaYzxFYlz2UcmXWKMxoz3JpkXiozoK2xSaVFuZHWSRDQK7fnPeR/zQXrBvnWVFVYoilLUgMbGGiZ42O04PdC0+8mzz2h5K2zSt24SqBmHJImKEZVPawXLRGX62cg+8fRipZbkLdOGnXwe/U60M8lRifJ5XTOrQVnmsityAz/Ze5QCKS8iQB9qzCyk/yX3fM/BinUkiT/SbP1lNJ6WR2KdVN1IZXQQ6lS8DWkdh5ZxCVc3xA9zCnOwei+PeUfWSvr37S1hyVIwjqH56nnzmIJb8dJlHzkZDZ5eM9vbQLPKAnM/zYenfR4VNENZImpQQF9yMceU+AQ5/E9WUWMkGmeI1Ekp8aahA4WIvwDuljkhkxhM7egRY02NheShtKFfGSqIz4TBfuvzLF1WhuzTe0MThl4IeLpielEHl/IARgSd25TH1TCxVzYQtk9B3ViUc6RSty94G6bEKHKM0w4+ZxoMVK0lzdPl8Vk0meW5m7hHzyGbqEdqLiOuYp+rGG0wSH2sARPT/9Qj8v+Kucbb5C8CRWtMktUVP5xeMkaAGu0QdPidV4ELh+1EKAexLl7C/O5d3/2OcwJpU+f6p/rLjXiC+wMYOIDFX6KiHud01KIRW3UO0x1XXBbpudBszHLVkRCjwl2A8Y1MvREs2lbGS0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(9686003)(186003)(966005)(478600001)(6512007)(6486002)(26005)(53546011)(6666004)(6506007)(82960400001)(86362001)(83380400001)(38100700002)(2906002)(110136005)(8676002)(66946007)(5660300002)(66476007)(66556008)(4326008)(316002)(41300700001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qtZPwPn84r9GWogjjhipxr2aabGipwazI5MXW9X/Z0NiVjsDoHMz4KCvufxr?=
 =?us-ascii?Q?E8uMLAYlKV0+gHrCkmgLcyiR311uNQItaHgcmYA92HK1GJ/LHVCwJy7JB+dD?=
 =?us-ascii?Q?HDSPrdmcnG35H/VTe6zzBfAYgruJkOW4dxDjRGCa8FmcmSZB3IV9Q1aSoXbe?=
 =?us-ascii?Q?lmPKVZi+vW0vrS/w2b6/4gYYvCLHOw2+Ku/+Z0VFfIlSgg/xurZuxLHxLbsv?=
 =?us-ascii?Q?0AhVePteQUeXAMjiofjCehRE4dIr9LGrqsWpfa0Fh4kWBpTB0XwsuNOAJlll?=
 =?us-ascii?Q?L+Cpxv2inwDKpDTy144o1pggcSBq4l+o2FC8Mj6sFrhNiO87RbhvzdqU54O7?=
 =?us-ascii?Q?nxWkbo3H/zC92pJvz1D9joCP437bsJKSZs8Gkd+o0YmYWhxwu3EcbDHyePam?=
 =?us-ascii?Q?vDIntwQJA2jmJMywauwO0OCZ/NK7uiyG/93RCFcpgmZ3woYsYVmV2KdsGW1T?=
 =?us-ascii?Q?1M0bzS2gecKsKE4q/stg3hQeDrAG/jy/EvTIfsVMMVZwtstCSnr+YV8zKi1y?=
 =?us-ascii?Q?7N/bg4CFOWFvOf4TnkVHE/yPRQpNLbh7kb/bvS8YqeAye6cW6Rsitxqw6UJE?=
 =?us-ascii?Q?T/lsTjHWZi0ttWZfi1SVwwrawBT1B8Xt5t6mr+RBdg7rP4ukKsPumx8pyHJe?=
 =?us-ascii?Q?dZronCFxPuShuxM6EFfjC/E7DQoGhlIp7yM1dJG45WgHLp8T5kNoi17fnDcF?=
 =?us-ascii?Q?FCyQM7fCX+pkQCRRlLnIfty5lQq9UWXpAtTD28oczr85sLvasFtMUNxiB3SQ?=
 =?us-ascii?Q?R/vWkwE0ZhxTEKamWy2M7XWuqCoktOpaPlg9FED1qIBYvCZ8rndJpQQiu47C?=
 =?us-ascii?Q?zugwKI1OeCFus+7hCtBtJWGUr7CQATAwoMGgyECm6QyLLh84DaxkRRGY2iH+?=
 =?us-ascii?Q?sEzPOjKDTJXNWoYUYZTkqU/f3VM5JF3yaW0RU80KeAcAPSPuTx5yb9SRHmjF?=
 =?us-ascii?Q?sFudtKoYaDQ56wzTcePo8mfsNMcbWdSQdX7oa28IIbCeiE3HTLe6t/eV40wT?=
 =?us-ascii?Q?5G6NV1xftYEn0KwK7CqbmN/S8IVNMBWK/QMnHrEcoVgsoZev+L+4YTPIfBSD?=
 =?us-ascii?Q?KUddFgcIpIXnGL5htaGZ1e2CZQziPsalWPH4gBx1bK0KuBIEXWUd/52Y/rNH?=
 =?us-ascii?Q?rnFJNR7nNRYxeulOyOvCEZNbzrWaGEQeyzKvmdXln6ascbWWzOxsvOniAqcd?=
 =?us-ascii?Q?3f7MdXOGiXamGnS+7NbzDUlakcmybpCZEmN66L6Sr2nBJIiVyzBXToSzG0Ax?=
 =?us-ascii?Q?ft3wxomS475PYv+tSCLnLDb6cQo8bFLNBZPKFg+AMAAkulKvWJS+B8JnGzN2?=
 =?us-ascii?Q?OIm4lSXk+cJgOFNemOsQr3FtpXqHefgXIG2AoEnmx6g4Ll05d3aCocpl6LL4?=
 =?us-ascii?Q?3fhCTeOUAF4pPWGo0DX2ZvrRaZRk1x4U1qQOhynclAy6N9sKOtyAptdyziOW?=
 =?us-ascii?Q?t6fVEz9CqXAycaV7LuRiAZTpqUR+xbTnxq2yXVnuOhuRmZ7TuS+y+xioPOWw?=
 =?us-ascii?Q?MD942TNgjCR0jsJqGo++l60LRMiGft0Cs8Dy1AcdkB+YKOHV77JFNd7fe8fw?=
 =?us-ascii?Q?QdE5cxks/oTHmdFNOUEmwUmor+nk9yfUfQZY4kcOvAWWlaXLFXdk3qUJawYX?=
 =?us-ascii?Q?5w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a53e54-1958-4d36-909f-08dad4fcac48
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 07:04:52.7535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkrqPreC5zrwB2oAdASvP4AWHLPQ80PlCg/6sQhAbH3Ekb4YO5K4VxJXJFBSZEpdj1shjZ/FTCI0CKEVUE5h3hDgJvUQl9h4l+okwLSmx1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7907
X-OriginatorOrg: intel.com

Robert Richter wrote:
> On 01.12.22 13:34:05, Dan Williams wrote:
> > From: Robert Richter <rrichter@amd.com>
> > 
> > A downstream port must be connected to a component register block.
> > For restricted hosts the base address is determined from the RCRB. The
> > RCRB is provided by the host's CEDT CHBS entry. Rework CEDT parser to
> > get the RCRB and add code to extract the component register block from
> > it.
> > 
> > RCRB's BAR[0..1] point to the component block containing CXL subsystem
> > component registers. MEMBAR extraction follows the PCI base spec here,
> > esp. 64 bit extraction and memory range alignment (6.0, 7.5.1.2.1). The
> > RCRB base address is cached in the cxl_dport per-host bridge so that the
> > upstream port component registers can be retrieved later by an RCD
> > (RCIEP) associated with the host bridge.
> > 
> > Note: Right now the component register block is used for HDM decoder
> > capability only which is optional for RCDs. If unsupported by the RCD,
> > the HDM init will fail. It is future work to bypass it in this case.
> > 
> > Co-developed-by: Terry Bowman <terry.bowman@amd.com>
> > Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> > Signed-off-by: Robert Richter <rrichter@amd.com>
> > Link: https://lore.kernel.org/r/Y4dsGZ24aJlxSfI1@rric.localdomain
> > [djbw: introduce devm_cxl_add_rch_dport()]
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> Found an issue below. Patch looks good to me otherwise.
> 
> > ---
> >  drivers/cxl/acpi.c            |   51 ++++++++++++++++++++++++++++-----
> >  drivers/cxl/core/port.c       |   53 ++++++++++++++++++++++++++++++----
> >  drivers/cxl/core/regs.c       |   64 +++++++++++++++++++++++++++++++++++++++++
> >  drivers/cxl/cxl.h             |   16 ++++++++++
> >  tools/testing/cxl/Kbuild      |    1 +
> >  tools/testing/cxl/test/cxl.c  |   10 ++++++
> >  tools/testing/cxl/test/mock.c |   19 ++++++++++++
> >  tools/testing/cxl/test/mock.h |    3 ++
> >  8 files changed, 203 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> 
> > @@ -274,21 +301,29 @@ static int add_host_bridge_dport(struct device *match, void *arg)
> >  	dev_dbg(match, "UID found: %lld\n", uid);
> >  
> >  	ctx = (struct cxl_chbs_context) {
> > -		.dev = host,
> > +		.dev = match,
> >  		.uid = uid,
> >  	};
> >  	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbcr, &ctx);
> >  
> > -	if (ctx.chbcr == 0) {
> > +	if (ctx.rcrb != CXL_RESOURCE_NONE)
> > +		dev_dbg(match, "RCRB found for UID %lld: %pa\n", uid, &ctx.rcrb);
> > +
> > +	if (ctx.chbcr == CXL_RESOURCE_NONE) {
> >  		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
> >  		return 0;
> >  	}
> 
> The logic must be changed to handle the case where the chbs entry is
> missing:
> 
> 	if (!ctx.chbcr) {
> 		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
> 		return 0;
> 	}

Noted, and folded into the patch.
