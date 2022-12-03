Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94C67B
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 07:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670051146; x=1701587146;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=KX9w0qq+IQUzu46V2C26oMe4aEGsJ18sSO8JrMtpk1c=;
  b=ZZ7sCO11vDG1HcrmVOb7p0iV1SWbqE8tOj4aQxbf8uQAdb+UFCcKPjHI
   aVIGuL0gkb1EBD2c8KnRSiur1JPK7N4WW5Z0ySOAvomRC4+8IB8gbvk+e
   wDwNTApxTzkuOoMAtHExAV0mfakC9F/1mYDWIJK/NF4d2S9E8FwbejViK
   Kl3hRSvjYJ3C+USCBoyQYB3LRWRmjdY0ALLMK6cMGxO1LsDJPD0g8qKTb
   ZV+fvW5Fa/p+l9xmG40FHkxE6KN8BuiezXLJkv5JgkMDzsJr9KhxxqeG0
   F6uSwG3u+/1S0N3OfnipX2pGOHSGlVt4fU9tPoybC9uXVWH+6/pU2tuMw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="295796759"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="295796759"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 23:05:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="595680705"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="595680705"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 02 Dec 2022 23:05:45 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:05:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 23:05:45 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 23:05:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2LWtb5VmbS2AnmkDzhTucM8yR1Vvwr6weNZoWwgsJQfbf5bZ78B0ZJgI7RA915ok/9g3b4qjwN6Jbe3/Mf5/8y38f5HOhu+DE1M2cNCiT8r4cbPilLSy2WcLmeJY5Z/it6QPyDuRubWWeW/bCndwY/XaGqvjbVnsuWkmdacL6Cdo7ki1QWmelaWN8SmTAy6BnH7PoyZPSEfEQ8Ef3Z1QJkBL/xivIX0WOH9tBsLL90RHgRFmxBQm7ocuYhlMlENF3DvO8thXnyEDaZ5sqamwqrXcfDTSTy407a3PYQ4anVCID5qex9tfojzA/K0BZqrS5b7jBb5jlexY5Pr7nRh+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TwW78IrAjz3stc1kgbNoDayikGlo3IScW6Pm/+Emg4=;
 b=E904wa5NtnDp6Um8gF7YrnRIEK00nqZxvvU4ojm0QHikQF2GjBlLJckuVS5Hx+qhjs+CVwJVNaqeqdiGNNfY3oU0ue8Z7a3c8RY88oozeQ4rFUQiliaSFXkbbMmmvsun3Fnq7nOzgwIoSZ4k6SjYJQPPuASVoCe52HbQ0r9ZB4EzZnBaH7n8q2aSOCp4BVcrzn8WHRYsrPYBKdU+yC2sxnD42xRPTy+WDIK7BGizIGp/oogPwVI3PHcB1QlQtUsy/W8dW9wE47MI7NydNEOKnfjNktvpBVeQyq5sTDjf8kWVmpTkepYHU/rzHjfJLdnHvZ6KLalGK0ZVr4Ce3g6p5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DS7PR11MB7907.namprd11.prod.outlook.com
 (2603:10b6:8:ec::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.6; Sat, 3 Dec
 2022 07:05:43 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 07:05:43 +0000
Date: Fri, 2 Dec 2022 23:05:41 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<terry.bowman@amd.com>, <bhelgaas@google.com>, <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 10/12] cxl/port: Add RCD endpoint port enumeration
Message-ID: <638af545f924_3cbe029441@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993045621.1882361.1730100141527044744.stgit@dwillia2-xfh.jf.intel.com>
 <Y4m1bCugC/6e1LTQ@rric.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y4m1bCugC/6e1LTQ@rric.localdomain>
X-ClientProxiedBy: BYAPR07CA0050.namprd07.prod.outlook.com
 (2603:10b6:a03:60::27) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DS7PR11MB7907:EE_
X-MS-Office365-Filtering-Correlation-Id: e0d21344-3183-495b-ee4d-08dad4fccb1d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qbrlg8d2aZtlEYQrg0aEbF/KJlk4az7eaUZ5S4JbYzUDySfKwIUKkJvKt8Lh/nIyk/F1reM42y11A7BnPy909goQFDEjD1YJoN1k+7RqITUQujkAqbFylVJ8WWO8t7iMMMHHj6zIMh9qBVxjuSpwF2izatjHXOd5W8m+Tii643CIfYKSunkQsTALSTpU6Y9PDAiSHld99iMBt9npdKt6PhWDbxnE2aToYya7b/bo4POvszPrQmWWnJvqcVhcgd0Q5Cz+0zuqH+SGX4Pmb03aLoc3fajN2LOatHGa9K1d3JLTyIh0gaU31LYM77lDM11LHYfCd2R+PJEJQdIANqrugFPu/yDRAjC/QN4NHuy2P+CL//HXy0hgmcuuaa3KvbBe+46/z1rocNnTAV2djPWssQ8y3e6WDZxVIuhAPzJHoL+JPb10b/xSjxn7TF13ef7fqIRR/a3W7FpRPN0i5qLoWJ/0wF5I5S4sD0MmpgUzvcDNEfdWLHSELBQrWKhbAUcLs8PkwfVOeMJ552SAzJHrtgDm9iy61aH//OdbP56oUQQnqjbMzYz2zQ6byoc+VDvct/lBpJFHbIVSisd3q52kDAJFncjwPVrNgTeFNbpQfl/xkLycY3Dp19PTL4FRLwoWBKbW/RQC4m0L42H1lRousw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(9686003)(186003)(478600001)(6512007)(6486002)(26005)(53546011)(6506007)(82960400001)(86362001)(83380400001)(38100700002)(2906002)(110136005)(8676002)(66946007)(5660300002)(66476007)(66556008)(4326008)(316002)(41300700001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHF2THhQSGowK2JBSTlmcDlUVkdlSHNucFdqUDlkUFMrSE1GV3FqeCtZSEtq?=
 =?utf-8?B?MG56UzA3dDRUak1Qa1dXSzlvK3g2eHBUVCt4WHJUK2kvZFV0YlJqMVBOQlpO?=
 =?utf-8?B?K3NKbDZzc0dLMDUydXZSbUlPSEwxUGQ2cmhRTHozbnpUTnBhU3VIWUFLbXh4?=
 =?utf-8?B?Y3BqL24zSy9KQ09LZlhsdi8yRDJqWFZ5dUxpOHlQcitzU0VRUm1YYlN3NUo0?=
 =?utf-8?B?OEVicEJzYnh3aHFkOVJvdXg4UHk2NWxvazl5ejIzaVdFNWxQOVlrV3JhZVNH?=
 =?utf-8?B?amNCbzl5WHhZYXRETFBjeW0vSXVxcHJtLzA4Tk1ENkZLLzI4dzEyY01OUjdB?=
 =?utf-8?B?QlJLbGZheWZsNE9OMjNTOTJuSDQyQ2pPdGF6bmN1MWhnWjFxR05hSjRHWlFl?=
 =?utf-8?B?bjUwTzAveFM3U2cxSjBTNWZWOWpEUWJNNVFwQmsxKy91YWw2MlYvRmxTRjVr?=
 =?utf-8?B?aUdLSmxYeEd6R1hoekJDQlFpVUZjbytUc2pISkdOSURGQzRwNkVURTQzdjdI?=
 =?utf-8?B?bENuZzBIeXlIcFh5K3BxN0srS1dZemY0cUVtOVI5WlhhSGlBSzB3UTlOZklS?=
 =?utf-8?B?RjBjQW1CckdvTUtleDl5THFOWUZ1TlRiVDduNUtGMXlJeHBEdldieHRKc09V?=
 =?utf-8?B?MEFSRmtWbGI4WU9jRDlTUUtVMmI2UmtPd0hMVjNCZEp4MVkxR3BudE1tZUJx?=
 =?utf-8?B?MEoxWk9aYjQ1MUJkeStSZlJZN2FWMnlpTndKUFB4NCtFeWlkbzRkY3NCSFla?=
 =?utf-8?B?b3g0TDE0TE9UN1pEU0MxNEZ5Z1Qzd0hPV2hVdWZCSFhZUVN0aUZrRXBDUzFX?=
 =?utf-8?B?MHBkUU9uUm9VNUNuVlRCOXQ4UUNVME1NYVVHb2dOU0JtVWRzVHcwZWx0STlh?=
 =?utf-8?B?dTd1T3Jwd2dLZm8yWmVoYkxFNFBpZ2JtWUNKYm42WFZVMGJDRFZuUHBNdFg1?=
 =?utf-8?B?Q2V1dVBhaTRidXVQR1ZVZ3ZlWWdrMkdSVTI0aU9xemYrNXYyNEZQUmRFbWFD?=
 =?utf-8?B?a3h6QmdmbXJvNUk1WmpqeDBhbDNQeFBPZm9PR2VtQ0NxcnRTSjB1bHRPZ05Q?=
 =?utf-8?B?YmNwQ2NXWWpGR1hYUzFsMHoyZmNscGdHTVFhOTgyS3BsK2t5RnBiVTZMdnNa?=
 =?utf-8?B?cGdrMUwxek9HaUdacnkvRVE2RUY2OWJuTkNmbU9lTEtvendBMkZjNEJZOVBK?=
 =?utf-8?B?QjFoMEhtOXlUMjJ0bHRlNHJUelR4RnVxSHpyejFoc3hRWE9yZHFXTjR6ZE41?=
 =?utf-8?B?Y1duUm9iT3NTbDNtclVRSkdmVnVFb3Y4c3pWYk9TODQ0dWFsRFFhU1ZxY3JE?=
 =?utf-8?B?d3N1WExRYWl0amZUdEZVWVdyMFd2TkJTbWgzRU5vQ0hYSXhRRnRGdXRjbGtF?=
 =?utf-8?B?WGZTNVBvWFh3Q2luTXB4Sk5aUlpCS0N2RHlXb0JBd1k2S0EvQXNLVkpkTm4y?=
 =?utf-8?B?bzlsdUE4QldsVnVZMkdEQm9Lc2tYWWJISFRIYnBxUDBicEMrZXFVblBNUXpX?=
 =?utf-8?B?RHJBUGp6Z2xBMkMwV1B1dzVaR0RVY2tTbG9aMGF2UDhOMkJOU3RlYkQwZUN6?=
 =?utf-8?B?WjhyUDZJUkJQTWNNUEFmUU5SNWVYdEhqQWlZQ2tDVmtwaFk4aEs0N2xKUzlp?=
 =?utf-8?B?OFNwUnJHMEI3Q3FnOUxhdVBoQ1pRM3BROFAyRVRPQktJZTRTc0dRM2dKMi9Y?=
 =?utf-8?B?SE5mOUtpaThMcFJpRjR3TU4yaHR6OGdGOGJTM3dwalBkb1QxTm0vcERHN29v?=
 =?utf-8?B?bDN5VWQwVS9UcFZXRGdKMzBLT1ZnUjczV3VvckU1dHBncTF3ZGdDZU5pQ001?=
 =?utf-8?B?UVEzR0dQdTUxVGpBbDFXenBZVEdmVi9SbmxnNVhiK1U3RHo1NW93MzhuWjJn?=
 =?utf-8?B?cjVOQ0RES2VCa2s5b1pjQUhwMVg4dFVRS09rbWQvZGRmZnp2S0xRZ2pxaWs0?=
 =?utf-8?B?U3U0K1pXeW9GUUZqZTZFZFZIcXZNZTZ4T3RTR3doekoyL1plbjIwWWFTSmNK?=
 =?utf-8?B?R1QrM3M3bFd6OGw4RTdoaWt4aTBNV2tJZS9yNWFTYjZ2akgvOTRoeHhSdEph?=
 =?utf-8?B?dnBOZFUzR1A4WEJnQlo1YmVNMFFZNUE2aFloL1A0a3BHTW5jRFJsQ2xrNFFL?=
 =?utf-8?B?SExZL3hjNG1ubTVvMzJGbHVtN1pnWGNoZkhlb01RQjc3OTNYZUM0TEZZbFhI?=
 =?utf-8?B?Mmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0d21344-3183-495b-ee4d-08dad4fccb1d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 07:05:43.2648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IXsFWY6zs38OTHjidPQ6tNfQUbAoR3S6eiBne8TzvoK5gAZPh7x0U2K1599ir++ILo0g66pEEGnUO8rE5ULC+WclHUbd0lUZREMml1rZm2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7907
X-OriginatorOrg: intel.com

Robert Richter wrote:
> On 01.12.22 13:34:16, Dan Williams wrote:
> > Unlike a CXL memory expander in a VH topology that has at least one
> > intervening 'struct cxl_port' instance between itself and the CXL root
> > device, an RCD attaches one-level higher. For example:
> > 
> >                VH
> >           ┌──────────┐
> >           │ ACPI0017 │
> >           │  root0   │
> >           └─────┬────┘
> >                 │
> >           ┌─────┴────┐
> >           │  dport0  │
> >     ┌─────┤ ACPI0016 ├─────┐
> >     │     │  port1   │     │
> >     │     └────┬─────┘     │
> >     │          │           │
> >  ┌──┴───┐   ┌──┴───┐   ┌───┴──┐
> >  │dport0│   │dport1│   │dport2│
> >  │ RP0  │   │ RP1  │   │ RP2  │
> >  └──────┘   └──┬───┘   └──────┘
> >                │
> >            ┌───┴─────┐
> >            │endpoint0│
> >            │  port2  │
> >            └─────────┘
> > 
> > ...vs:
> > 
> >               RCH
> >           ┌──────────┐
> >           │ ACPI0017 │
> >           │  root0   │
> >           └────┬─────┘
> >                │
> >            ┌───┴────┐
> >            │ dport0 │
> >            │ACPI0016│
> >            └───┬────┘
> >                │
> >           ┌────┴─────┐
> >           │endpoint0 │
> >           │  port1   │
> >           └──────────┘
> > 
> > So arrange for endpoint port in the RCH/RCD case to appear directly
> > connected to the host-bridge in its singular role as a dport. Compare
> > that to the VH case where the host-bridge serves a dual role as a
> > 'cxl_dport' for the CXL root device *and* a 'cxl_port' upstream port for
> > the Root Ports in the Root Complex that are modeled as 'cxl_dport'
> > instances in the CXL topology.
> > 
> > Another deviation from the VH case is that RCDs may need to look up
> > their component registers from the Root Complex Register Block (RCRB).
> > That platform firmware specified RCRB area is cached by the cxl_acpi
> > driver and conveyed via the host-bridge dport to the cxl_mem driver to
> > perform the cxl_rcrb_to_component() lookup for the endpoint port
> > (See 9.11.8 CXL Devices Attached to an RCH for the lookup of the
> > upstream port component registers).
> > 
> > Tested-by: Robert Richter <rrichter@amd.com>
> 
> With the one comment below addressed you can also add my:
> 
> Reviewed-by: Robert Richter <rrichter@amd.com>
> 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/cxl/core/port.c |    7 +++++++
> >  drivers/cxl/cxlmem.h    |    2 ++
> >  drivers/cxl/mem.c       |   31 ++++++++++++++++++++++++-------
> >  drivers/cxl/pci.c       |   10 ++++++++++
> >  4 files changed, 43 insertions(+), 7 deletions(-)
> 
> > diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> 
> > @@ -119,17 +131,22 @@ static int cxl_mem_probe(struct device *dev)
> >  		return -ENXIO;
> >  	}
> >  
> > -	device_lock(&parent_port->dev);
> > -	if (!parent_port->dev.driver) {
> > +	if (dport->rch)
> > +		endpoint_parent = parent_port->uport;
> > +	else
> > +		endpoint_parent = &parent_port->dev;
> > +
> > +	device_lock(endpoint_parent);
> > +	if (!endpoint_parent->driver) {
> >  		dev_err(dev, "CXL port topology %s not enabled\n",
> >  			dev_name(&parent_port->dev));
> 
> Already reported: dev_name(endpoint_parent)

Yup, got it, thanks.
