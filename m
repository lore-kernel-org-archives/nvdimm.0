Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03320363
	for <nvdimm@lists.linux.dev>; Tue, 29 Nov 2022 00:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669680620; x=1701216620;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CDxCoLyyoMexiJ55gbiaBiVyonCHhSs1V4XWhyLGsWE=;
  b=CmU6FwsnOi00L9zDfJjyNJfGy7sdzOXiW1BdchShDqin1yFMlCJ+KA8L
   7SUlacPN5p5//3t7RPLtTm5FINyGYnBrU3WiTPlAK1sdKGDDwvSQWMZUv
   MFaCIB9IMYddbuyNMjgVcWCsinuWTvhuG9b6+9AwtOzFRN42hjRJqbNvZ
   D501SFKlKSSxLIHDcH1Z4l/ZaMxBQcbESXbT7lM00In9w3C0Q6mHGRdf+
   hRxFVYoXzJmhXDIlGZ0nc7/TvirPCMq/4XxPlf94YXS/74XIpCRKLvUn0
   aUoXLP0OkONw77ckLVzilcHWFtuYfG5NXYc07Mhr+ZXxVFOco92Ix8a3+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="295357604"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="295357604"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 16:10:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="674420054"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="674420054"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 28 Nov 2022 16:10:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:10:16 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:10:16 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 16:10:16 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 16:10:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mp1KnsXIYa69MN5tYEBa5vRBCaL+u3icmKnDEkDYWda5z3IkWGKjwu+yssNUpoFNiIVvks+TjMFb8ChgW5Z51PjeKZIy13n1kE3tHASc7VV8zdX4JCBdza0tLnIfoIMWsAmW4mZdejE6Xgg15C6icfXpdFZ+OYiBocfr4wVtvfDK8+493LlKPrDvoYjV8OkIAjgVbZ8cMYIYXdk335ag7Qo1aJgwnImuKm2bmdrnH1bXuPfgKM+ut5jKxlFevG0adBWoVgNMmMt2m9hdD8tRoZAjD9ODiVSVKZHbOM5OKhvXasc2A2n+caSBprXlsssxDzMELcfnRsmQ6QNC4WJkgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76POvpPI9ejmQaSX1Mw3v2nKIKXw4yKUT1bWAXfcGcw=;
 b=eWfNxgbgIcn2CmV4CXCBQ8z6Fitxa5kVoEmuRDuON7cOeob5KzYTLMT2c/XKeLJEk18IGXH+BoV0kDBHq3kObGw8IVGy/gpE1ilsuxzwlenTkA30QxzuWAl6Rfui9JtWkjJcP6KBV9rqV0NovDJxe5eubAZQyxI+IxY9T8m+a3txbhCRxDKiRXjdAW3IZ2yfq1PiCyX9RCtWLsZw9J9S4fo0EsDlZEeeHpK1HRw0WT61BOC5J5LIwaSpaGyIp7G0qYIldTDHTZLOVZdZzQ/tKxuLClKT21+7K0al+2a1Mu+BNSDaJcF3lN1l1yzlolihRioBfuqziF13V0BGz+Hrkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CO1PR11MB5124.namprd11.prod.outlook.com
 (2603:10b6:303:92::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 00:10:14 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 00:10:14 +0000
Date: Mon, 28 Nov 2022 16:10:12 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <63854de43080b_3cbe02944c@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931492162.2104015.17972281946627197765.stgit@dwillia2-xfh.jf.intel.com>
 <Y4TGabZ4iqtOyTf8@rric.localdomain>
 <63852f1fdfadc_3cbe02947b@dwillia2-xfh.jf.intel.com.notmuch>
 <Y4U8pqjNtjuaJLqU@rric.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4U8pqjNtjuaJLqU@rric.localdomain>
X-ClientProxiedBy: BY3PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:217::12) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|CO1PR11MB5124:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f63ad5d-6329-4380-96c5-08dad19e1694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cu/A7qHCOd5OZUyGtHvUPkgo4QE6IK+05ZW4jOQG0P/AhJBjpeV1uaujErlWz370Vwou2oqmLQpxqnmOMtB3NboJpdGK5tNSLSZAqlAZHdHGr9+OplNDmiuk+A2rjNozpPGzP9ha44CYWS1S4XnXMnWZ4B3OvBAK5yhdm/rMMPDjubmPK6F3aUEqR8FOmV+pwdZMzAE5Im/uNnjF4Oc8WMMSW7tah9oCQKSQe9/HwI2vAxNT1Wpm+zPbDBl5ZM2Ie7RZnJHaBhnSgGrSQrAAj5sDTq5nD7JmjUckX5kb5wXpmj4eSHDYQAArHTFZWxSNqRY2OqGPIrQL0ASLkni0LIeKtaaguqWZiyGVAMDxrJpSteNxqQ+tFl5WjWlltBZbnq0A1Une7GdtoWEWwlf6e7hG8g19uP1kypMPr7Fx1cKiouBOHlSbzorDWPHzN7nis3MA+2vn0MJWCffpvOI3DP0qZlpAd/yE9vMBCIOSzRLaLNLEaGyPbfuHMDhStYB3OvBizgB7KHBQLtr9+z1jCbtrBxl3vS7XG7AMZxa4MjQ+WFU12EEvgKhW61mJOqaa+A7KpqKhjy/s8KzBvAAZEIxFKSQ9NH7zjo9PUWdrbbLp724HcTleIVXAZikB3qtsfqUOdjlx1euEEFZEPZY0XA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199015)(316002)(478600001)(66946007)(2906002)(6486002)(110136005)(38100700002)(82960400001)(6506007)(53546011)(26005)(86362001)(9686003)(6512007)(186003)(4744005)(5660300002)(8936002)(41300700001)(8676002)(66556008)(66476007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j7/p1XoAZFhQnGq9VF1z5Js3lneCa57wgCBld+l/QebS7drL9Ke31jbMjb+o?=
 =?us-ascii?Q?6SwWSCzL3LY0k1hLcJ1wG9lL0DWjvlqHRNM1TleKfSvTljqdckoekWBXu6or?=
 =?us-ascii?Q?aWtNrUslL6ShicC0/xCasn9asA5ZTqN5ih6BHlI9CpHdrVQ+/i/eGbnJbtWB?=
 =?us-ascii?Q?S/O5gEFuFEI6j7T69YwCynb7jCF409HncsJQj45rfLpOxP70ytqVHT38F6vh?=
 =?us-ascii?Q?+L+EdTUPH6pHOJtifqGex5RpYycfSn2IThTVL8LqCbLJuk0xedB+ZqozonEK?=
 =?us-ascii?Q?tk9NucERmewSHmbEpyT4bmQ+nDoHzjW9Ubo0SODqlzoYnNR5+VzBapWCuVlo?=
 =?us-ascii?Q?p2CkzWeJmGKpYEOaP/QSsGmHebKR4aGWBtO2C+U/9S5v6qKZPLfwqzcOyJ2A?=
 =?us-ascii?Q?BNF56EizwNcpQzPeLvWIpy/LhyMnK+FRXDcD/vm2nLFPTyG3bOtaeZ5aFAQn?=
 =?us-ascii?Q?VBddOQiIsmd5jmvEHtTEeZQyQhaq2YUQo43Rb7Mb238Z9497sO2xg+/fw+cb?=
 =?us-ascii?Q?BAz1qHzacM2HtTPH2qt2Bj0NB2tlQb1Fw/VeVBINzJ9W3em6xKJfzlwHwgv/?=
 =?us-ascii?Q?259G8sm+6p8AJ8oU9ONBgi+u5yuc+kwHL/WDqmqJfnlAG8icHgYOUFJrUfdJ?=
 =?us-ascii?Q?RtBf19LmXrfe2llLhXtUQhXF4M4nr9W9uhU45GfJKTzHXi2KktorzuRvzNTF?=
 =?us-ascii?Q?bb+qmF4szcUTdo7iY/qaOJ+448Wm/47M/GXsJrfX+b8jPizpvDHwCvPc1m9L?=
 =?us-ascii?Q?iSMq5dHClIY2DngF7MEXrvBgt9sbg7DZue74LnDQRGfYz4xBVkuRXfVYBdrw?=
 =?us-ascii?Q?LJrGI0Evgk4V0uaXBKi++N8aVjHUetNB8wOfy09YIe5MBvK/EcJovmPqD32o?=
 =?us-ascii?Q?TTmS3ONyqALNAOTEJi/islBsS061XM+AsgToOP6GshJlIKuZLCeeeFfgaFxG?=
 =?us-ascii?Q?KyGMegkwbHWXPI7bb3qkhRgSapXyvDasFZoTIkzNi2Z1gk2X0Die/4lqN6Bs?=
 =?us-ascii?Q?n2pQ+h97DOcd3pARUNPqir7JTSJFquXUeRMzo7rYeRJfBqK//2upvKmbBXWw?=
 =?us-ascii?Q?ZapSg3zeeRMo4R6YGqTqru3zlC9cFkbsvFi8C0X1iMo+fkSVblIYJQ5dfD3G?=
 =?us-ascii?Q?YSU9iTm6PufeLpqPkgMOHbtQ8RjcFHYhXaNLHAyqcLny8OuyESFpPOnvuL1w?=
 =?us-ascii?Q?SyFDkkLP1wNFgmPtcDlHoHCs3Sp+r+74frQoRBCmXSji4R1/hpwlqhubyh1d?=
 =?us-ascii?Q?drRW3C17EgwAk6Mq4Lyq8aQ1BG2AswhmYm/Rhw38Rao3IF2wi1Hd8I387AZt?=
 =?us-ascii?Q?NRWCLBOFzFTwS1klR6bxHT66azerzb/TS6EymlOgOimO7tsDrAYtWnrXndFV?=
 =?us-ascii?Q?aHLugIkoqGeG9lnCg5P8SC/90jpT74gnYAqL3DwpNTIialfrFJNkhfcHs64p?=
 =?us-ascii?Q?HO5s68bnxGcu0YyN+UhjHbGtV9lP0mELoTgSPKJYvM1tCPU1YIdKfD0CLk0h?=
 =?us-ascii?Q?uQvAgRHYHihX4aayvl3C3gX3L4uZTcqP6VmFnTuJctFppPDNrFYSei+Wv1gQ?=
 =?us-ascii?Q?KyWDq23hJimotuT2Q4dDRTAGDEUev3rIy1ZSTQ+8NNn5wtfiPHvIP26LI7bm?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f63ad5d-6329-4380-96c5-08dad19e1694
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 00:10:14.1939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1jB/+nxbLLLMVvrfpv5fhVcuPP5SJ6BWoHI701w009zsu7cSr/49zS1VsNLYdi8ZkufXf4LfrTWu4AsY4SJ92kRBDwUZPl0HkW1bzylGB2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5124
X-OriginatorOrg: intel.com

Robert Richter wrote:
> On 28.11.22 13:58:55, Dan Williams wrote:
> > @@ -335,15 +336,22 @@ resource_size_t cxl_rcrb_to_component(struct device *dev,
> >                 return CXL_RESOURCE_NONE;
> >         }
> >  
> > +       id = readl(addr + PCI_VENDOR_ID);
> >         cmd = readw(addr + PCI_COMMAND);
> >         bar0 = readl(addr + PCI_BASE_ADDRESS_0);
> >         bar1 = readl(addr + PCI_BASE_ADDRESS_1);
> >         iounmap(addr);
> >         release_mem_region(rcrb, SZ_4K);
> >  
> > -       /* sanity check */
> > -       if (cmd == 0xffff)
> > +       /*
> > +        * Sanity check, see CXL 3.0 Figure 9-8 CXL Device that Does Not
> > +        * Remap Upstream Port and Component Registers
> > +        */
> > +       if (id == (u32) -1) {
> 
> U32_MAX? Or, cheating there: ((u32)~0U).
> 

U32_MAX looks good to me.
