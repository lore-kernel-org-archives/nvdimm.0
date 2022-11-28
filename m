Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B98AA461
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 18:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669659670; x=1701195670;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=FI4+ZRap1rhV1z4co+rASXGxDJWLDg5PRY3WVc/o6Dk=;
  b=QyKbK8lylPdMESvgQGY0tkyVvDBIDBpxuwAJgAWS2gOPuPY+Dxp2n9ol
   GdaNfcsqgOXXvwGOtSZQ0ptJ5Tx9Y508Sj+FRGNwFE9SmM8Ua4XVYWON+
   +tv4brbK72i9/B9V2OnsDK4wHFNBmcc+jsWGyjxFjJQhkYd+ePqR/pWA0
   DhWBxAKcrBp6ESzhog+/TFRBua7qe/7nIcdMrs9KS9n63R1/1Tgcu/HqW
   sa19Qp2ux2+a/KQKeNrFbw62q+ZGpKu+1e/qoE/43YJy0Mlc508LQ90d+
   OsalJocrEnhCPhIDvPN0t1Sm6KShbk0jj8rdvjDwMgg4xCxpb1T7rPa2e
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="313617319"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="313617319"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 10:21:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="674322797"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="674322797"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 28 Nov 2022 10:21:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 10:21:04 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 10:21:04 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 10:21:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTowa4+tJEukxwrgvWQPynEzA1PtfHc5sWpTwXKXQOz/6C9rjKoruldHJIvG59p794d1eFEldheQfLsiOoGEJ3gz9nRQcpVjJFBD2olgntUJcJY96bKKCpHnM48k+LcdHfX0VPXCJ2BvmbpaoCjTxbpn0aU2rKLlm0rUQyeBX1pOfDFVShmgZ17S3KaXQxolbKKCx/4A0gRLP6EHDCgixBcxSvRbcG/9to27Ql8UPeeGckkxhGQ91UA2plmHoyrZB4W7chiasjKP0dw8j72ajVfcPv3A921VRa/t/rvCJ7KbufJpuR3STImnKbdqqkAD7Z8wL2Hkp/XXFnh6IqUYvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AkxKhEHSyfpALTEOa/eodq6Nkc616MT1mMIcX1pdXSk=;
 b=n8zOqCCLtCAvKH2hvR+q96bwvlhG3mEU9XEDxZsOU7pvUpecu0z6dNGR78aI5qsNAexmOfHXelIjzjnsOOeasogQB8AZk3az6kgkR49Mvg9yB7NyZURuXlGC2OJWmJvFi4KChgfVYAWgVuI8RW2ESy10PTI+ZtGmGcNBuC5r8JG5QxxxNUJZr2qynl5Mue7n4k+9nQ/1pMZZPGTX0BhHMx2PCDWRUvhL/OZ9AwMbMNTJtr7a0ce23uQO855XP8EjPvtQcGdObgQmjFmKX5wYytCNDTeUWDNO5OT75IeU6gryYgJjOPici3ylqcUuTROEfx9WxOEWJLZgbufWxftzyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM4PR11MB6480.namprd11.prod.outlook.com
 (2603:10b6:8:8d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 18:21:00 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 18:21:00 +0000
Date: Mon, 28 Nov 2022 10:20:54 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>
CC: <rrichter@amd.com>, <terry.bowman@amd.com>, <bhelgaas@google.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration
Message-ID: <6384fc05e8479_14b329491@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
 <9f5f2990-3b6a-1d8a-a3f9-0f5d184b85f9@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9f5f2990-3b6a-1d8a-a3f9-0f5d184b85f9@intel.com>
X-ClientProxiedBy: SJ0PR13CA0037.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::12) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DM4PR11MB6480:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dc45e0f-000e-45a4-960a-08dad16d4ab6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5iSAxAQ9NrRtk9g+D9rOJpeg1aUxYEJL3kX7DlnTpVrgogWO9wE5tKKqrM6LFq0uFA2K1FSqPua0eegVdB6ZcLJBeRTqrSRIwbn8ZOBuz//ggVW6+LpUTYQeBgjNVda6mn1bpr0QeE+KlQ1rujzfQdZTlpu9DSCKQzzj1XqWWTIxH76J6ko6oLeRPUR6KLpTBRG6CLWDfTj2B+ejaJ7SGfVCDWSW50NEWC4zWyJZ4XUNxjZS1fu2I91AW15YxV2ogP02sC3mI8SMZuvrCpyGJHLlzF3Z0PIaSfzOnKFoks8y/cFnxzm0RsfLWhDMtQyaioMLiNxdsmA4kchfNBkArg1ux0315DpgUFGJQ/C0xhDVybzlRX++bd2L9i1M1vG5XRAgPHFqPPwxB7xZKZIpvNvh/k8KtzIdfbdHW8X2YWlyI+OoMi5/sgYH8R58+knaPR/mJ7P4YCiF3J+GvdYstugkAo/Id4IOiryQmNhJCvDGeTH9yaNl6pU4eeF+1t/I9R2sJEzL6xd11nh+2qXHKdgd6LuVuwy4ulsJm2KrIPCrQ8O/1F3PAu1JmDYqH6ECCAi7UQg6TQchQJPSrhRJ9qj295KyeeUchJPO1fKnG6vmntguib1qbL6ES1IIJ34CgyhPOsJuvtBek2g0YfTc+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(396003)(376002)(366004)(451199015)(83380400001)(2906002)(9686003)(6486002)(38100700002)(478600001)(6666004)(41300700001)(66556008)(66476007)(66946007)(8676002)(53546011)(82960400001)(26005)(6512007)(6506007)(186003)(5660300002)(8936002)(4326008)(86362001)(316002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckZzcU05ZUxrODRQR29ydUlUUE51Z3BvajlvWWczYTYrM01QMy9mazA2RkZO?=
 =?utf-8?B?c1lYTUpSMXpNTTBjWUNMTldrbU5zZlIrek9jMkd1dHkyNU5HT2lTR2I3VC9a?=
 =?utf-8?B?ZTZsOEIwWVIxZEFJMDVkUUVXMCtBY3VCWFZuM1BIaVkwNmNLelAyMmgzdGdF?=
 =?utf-8?B?TzJRWGdhSW8velNqNWR1MTdNVnJWK214RlRHaUdrN0NTTDEvNzE5bzY0UENG?=
 =?utf-8?B?cE5FeWlPRWplVFFQRERZUktxZUZlOERJcGluS1VwOEhacnVpS0EzaWZiRGtG?=
 =?utf-8?B?UkVuWnlpTll1Tk1lUnRJQm15ejdrWmRoKzB1dFlUQU1xMko5TVpRK3d6end3?=
 =?utf-8?B?KyszMlh5M29LM0QyLzVmc3ZXZis5cnMwVUE2SFluL2JMWnJ0TE9xSEVzOGQ4?=
 =?utf-8?B?bFJaK1J3V2JpR0o1VGVZOXZnNUFwbHVsdVljK3JhREVRd0c1akMxejZDSTlC?=
 =?utf-8?B?V3pMN2pOdjF5RmpDLzh3UXhtOGx1SXNiN2NQK3phNk1FTEk5dDZ1N1ZnSjZr?=
 =?utf-8?B?aWhPUkJlWG96OWtBcVpEcTcxSFQyNndtZWJkWDRabS9TanVSa3ppbGgyMk90?=
 =?utf-8?B?dGxZTStDVUxzSkZzOVF4eTZDS1AyZkJsQ3lReURuM29VbGlkbml1cVZQVWM5?=
 =?utf-8?B?eGlJb0lRWFZpZVNHdk80OW5wNUFZQXZ6alExc2JMMm1DQ1hadGowRzlhZmpl?=
 =?utf-8?B?azR3K0FSZER4V2hqMldsUUNJanl5cENFMnlNUk1EcUhoWi9xMDJIREp6SkZW?=
 =?utf-8?B?VzR2anZkd1dWODAvdFdRRFA0dC9jbTJhYzkwR0VuVmR5Q0Z6UFhJd2FJK2tP?=
 =?utf-8?B?MjJYM0RUb1ZtRXR3dnU3U043WXVNZ054R25iVFBmbFVxbmZHMjBEbE5LRGVO?=
 =?utf-8?B?TnV1NzdOOTIzWFhjd2taTnU0eEh5V0xMSUFENmNmZ3o1eEY3N2RZRkNUUkFt?=
 =?utf-8?B?eExTeWVWbkdGWEpHTXB3NE1PVUROTmJaRUNvd2xSNEJITmVMS2U3bGt2amxS?=
 =?utf-8?B?djRWb0o5N1EvTGdnZHNZY0pLS3JHOCsvTmJ1RUtJRWJtYjV4eVljVFh1dmFz?=
 =?utf-8?B?VmswcWFCMVVzcE1jZmJnN3liQmY4ZzJkckphOThHVW5yOERlYnUrTDRmQ3Vm?=
 =?utf-8?B?U01uYk0yTTF6Z2xjdlk0bk1kSzQ5Qk52NE1PLzNMTGpYejBYSDdFZmhFUTRE?=
 =?utf-8?B?WkVhd1JLU3NJSkhtS05haGdDUWRhek45dGVxdENUdSs3UU8xcDZtOWhaY1k2?=
 =?utf-8?B?dnI5azJlTGZzMkdUMjVWNEVQS1R3bnR2dVEwdlZIQzg3Y0FnaE5ZSkFZSlg4?=
 =?utf-8?B?OUJFUzM5T2V4T0QxTTVrM0lEY1YrUVJUMk5oQVJuc0VFT0s5L3EyQXJidXNj?=
 =?utf-8?B?NWtLaUpXL0dTUFhBMEIyR3oyRCtiOUc5dm5HVERsQkJ3YXd1MTNnalhOZ3NN?=
 =?utf-8?B?dXZLNHBuL29PQ1JYOVl2Um1KYjJOV3hhWGhGNmY1NDVsVjRqSUFGS3J0Ymlw?=
 =?utf-8?B?WHUxT0ZrZFVXTmxHWFZPZ2VERGhNWEd0eS9abW5FTVNNTWFFcDhnVVhwMVFo?=
 =?utf-8?B?M1kvY0xBcnlQRVJqSklQb085d1J5UzVLQmdXNDhFRkN1MFA5ZXp5YTlRVHRa?=
 =?utf-8?B?eW9qUVJXTFpNM0FWL1phMXdKbW9ncGdLZ2c1OC9HM01pb2JIamhQSU9NZXcx?=
 =?utf-8?B?Nm1IRlhGMzVGQ3hVTkNURUt5cHphWEV3RlFIRWM2RHM3WTE2OHZSUkN5MHVW?=
 =?utf-8?B?cjRHS3dFMGxtdDVvcnJZdi9WM2o5T2I3NS8rVTdjdjB2eTZTeXpXRGhPSU02?=
 =?utf-8?B?OVRnS2poVTZKOTUraFpCQVNJdlA0SG1HTTVXV2Z6THJvb0Rtd1pJWW52VDgv?=
 =?utf-8?B?SFhQUnJMWU5odk5FdXZKdXJPaXQrYTBBdWVKSDNuRGxreW9DM21EVmhRSjBF?=
 =?utf-8?B?ZnRORlBMS0tiSDlNblpZOC9WUm1ta3dtVlovbWFJcFhpZ0ExWEozK0Y3dnp2?=
 =?utf-8?B?T0VxamIxTEZkdHNoMCtDZjcvRkVoY09naThRNXkzTFJzdndYQmg1c1hxRS9l?=
 =?utf-8?B?Y1pWc2lYME91YnVLdTl3WWNna0Z1Z0QyTVBxbmVhQk1LVzZrc3RHZHpmMnVX?=
 =?utf-8?B?UnVkWlg3UVZ2U2RwQ0FoSGlBRHFBeEl3T2haOVVVdExjWkcyeXpBdzJUKzlW?=
 =?utf-8?B?RGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc45e0f-000e-45a4-960a-08dad16d4ab6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 18:20:59.9744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWhOn1OSm/h5EjxHqdFYtfrs+XcE5sZw3gqLt4atFvBLd/4AedJmFt0W2tb2VP+WcxV0px8pBftxU0Sf9sXaWyZDRkcYGplgslVkhTU2xoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6480
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> 
> 
> On 11/24/2022 11:35 AM, Dan Williams wrote:
> > Unlike a CXL memory expander in a VH topology that has at least one
> > intervening 'struct cxl_port' instance between itself and the CXL root
> > device, an RCD attaches one-level higher. For example:
> > 
> >                 VH
> >            ┌──────────┐
> >            │ ACPI0017 │
> >            │  root0   │
> >            └─────┬────┘
> >                  │
> >            ┌─────┴────┐
> >            │  dport0  │
> >      ┌─────┤ ACPI0016 ├─────┐
> >      │     │  port1   │     │
> >      │     └────┬─────┘     │
> >      │          │           │
> >   ┌──┴───┐   ┌──┴───┐   ┌───┴──┐
> >   │dport0│   │dport1│   │dport2│
> >   │ RP0  │   │ RP1  │   │ RP2  │
> >   └──────┘   └──┬───┘   └──────┘
> >                 │
> >             ┌───┴─────┐
> >             │endpoint0│
> >             │  port2  │
> >             └─────────┘
> > 
> > ...vs:
> > 
> >                RCH
> >            ┌──────────┐
> >            │ ACPI0017 │
> >            │  root0   │
> >            └────┬─────┘
> >                 │
> >             ┌───┴────┐
> >             │ dport0 │
> >             │ACPI0016│
> >             └───┬────┘
> >                 │
> >            ┌────┴─────┐
> >            │endpoint0 │
> >            │  port1   │
> >            └──────────┘
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
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >   drivers/cxl/core/port.c |   11 +++++++++--
> >   drivers/cxl/cxlmem.h    |    2 ++
> >   drivers/cxl/mem.c       |   31 ++++++++++++++++++++++++-------
> >   drivers/cxl/pci.c       |   10 ++++++++++
> >   4 files changed, 45 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > index c7f58282b2c1..2385ee00eb9a 100644
> > --- a/drivers/cxl/core/port.c
> > +++ b/drivers/cxl/core/port.c
> > @@ -1358,8 +1358,17 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
> >   {
> >   	struct device *dev = &cxlmd->dev;
> >   	struct device *iter;
> > +	struct cxl_dport *dport;
> > +	struct cxl_port *port;
> >   	int rc;
> >   
> > +	/*
> > +	 * Skip intermediate port enumeration in the RCH case, there
> > +	 * are no ports in between a host bridge and an endpoint.
> > +	 */
> > +	if (cxlmd->cxlds->rcd)
> > +		return 0;
> > +
> >   	rc = devm_add_action_or_reset(&cxlmd->dev, cxl_detach_ep, cxlmd);
> >   	if (rc)
> >   		return rc;
> > @@ -1373,8 +1382,6 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
> >   	for (iter = dev; iter; iter = grandparent(iter)) {
> >   		struct device *dport_dev = grandparent(iter);
> >   		struct device *uport_dev;
> > -		struct cxl_dport *dport;
> > -		struct cxl_port *port;
> >   
> >   		if (!dport_dev)
> >   			return 0;
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index e082991bc58c..35d485d041f0 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -201,6 +201,7 @@ struct cxl_endpoint_dvsec_info {
> >    * @dev: The device associated with this CXL state
> >    * @regs: Parsed register blocks
> >    * @cxl_dvsec: Offset to the PCIe device DVSEC
> > + * @rcd: operating in RCD mode (CXL 3.0 9.11.8 CXL Devices Attached to an RCH)
> >    * @payload_size: Size of space for payload
> >    *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
> >    * @lsa_size: Size of Label Storage Area
> > @@ -235,6 +236,7 @@ struct cxl_dev_state {
> >   	struct cxl_regs regs;
> >   	int cxl_dvsec;
> >   
> > +	bool rcd;
> >   	size_t payload_size;
> >   	size_t lsa_size;
> >   	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
> > diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> > index aa63ce8c7ca6..9a655b4b5e52 100644
> > --- a/drivers/cxl/mem.c
> > +++ b/drivers/cxl/mem.c
> > @@ -45,12 +45,13 @@ static int cxl_mem_dpa_show(struct seq_file *file, void *data)
> >   	return 0;
> >   }
> >   
> > -static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> > +static int devm_cxl_add_endpoint(struct device *host, struct cxl_memdev *cxlmd,
> >   				 struct cxl_dport *parent_dport)
> >   {
> >   	struct cxl_port *parent_port = parent_dport->port;
> >   	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> >   	struct cxl_port *endpoint, *iter, *down;
> > +	resource_size_t component_reg_phys;
> >   	int rc;
> >   
> >   	/*
> > @@ -65,8 +66,18 @@ static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> >   		ep->next = down;
> >   	}
> >   
> > -	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
> > -				     cxlds->component_reg_phys, parent_dport);
> > +	/*
> > +	 * The component registers for an RCD might come from the
> > +	 * host-bridge RCRB if they are not already mapped via the
> > +	 * typical register locator mechanism.
> > +	 */
> > +	if (parent_dport->rch && cxlds->component_reg_phys == CXL_RESOURCE_NONE)
> > +		component_reg_phys = cxl_rcrb_to_component(
> > +			&cxlmd->dev, parent_dport->rcrb, CXL_RCRB_DOWNSTREAM);
> 
> Should this be CXL_RCRB_UPSTREAM?

Indeed it should, good catch.
