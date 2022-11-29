Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0D0363
	for <nvdimm@lists.linux.dev>; Tue, 29 Nov 2022 00:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669681526; x=1701217526;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=z22RyWcuvGSPycgrliWH5mHE3DpU6DwOFR4g91UtbXM=;
  b=A6WrIe26DN5hsFKWWH/PcrDYa1m9R70oi3RiDAskR2zRy788DeB8/Ppa
   F2FZi+0KGhmt9/dAlBsPlEDUyy2w4kLj1DMh85TczpsNvcnbOiCLynF2c
   i41DOtJIOh8I7k+oeYtk5bPEvKvswLYR5pu+aS3tVzlukFU2wJ6DTBLGN
   3srm+3Layp2SmN7X5buEKih132Q1TggeNgFX0oZc+afgy9hXaLT/g3qA9
   0SAvhW/FaCIemj/9nU/1Uq0zLrxV3WuLdZzEBEHxkm51BJwITUh6e8HNu
   x66dz7ZQnOOBGh5Wlo115lP4dhbpZauwBkqkcmLtkga8EPZabkuKBhPnp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="312607035"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="312607035"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 16:25:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="785839957"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="785839957"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 28 Nov 2022 16:25:25 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:25:24 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:25:24 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 16:25:24 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 16:25:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZyZirZy0fQ5MEV+TrDry3oLroDr71f2fuRlem5iDsYNPC8CFPj/miF4sc+Cp8wW+ruwMhrSXD2U1FyX86WAIN8phL80z2gpd2I08PxCutZ2SUm/FqaCb7VRyeuHH+7VAu3VV7WQ8yskYsJuoybYK5cpyg905Tqzv87MIonNIz2lX1xO8XDIwnyu0gyErPkt428sdegyb9CB3juTVzIDR9HNDRLmp5dvK3IsI6O1ByfXqKH2l+IYg2bEawP7YxYcjkMg9ESijWg4DdmqcIxX7yq/0e01bSf4c3sbZF+iDOmUjvpuv/41uJ/oZtdvTT6B9N0H8Swiugq1bm18jUfoWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4hSIXV3FkydL4UKjd+doW1SVp3zKAGi8DzIZ7tw9AxY=;
 b=AfuRuiUVY3JW9gf/YZlpbWkxf2jyuaJElrM1md3eV/JX0Gfby5DGlq5uPTG8wQnVI+dBYSn5U4dlVKYlVwTPAbptrkD/w0+f0fzrNnEMd7cfdW5+ho10EaGrpfz83oYCoz+zLDdyeuxpG9D49aoQ3IdMgRTx0Xrj3tWUjkr5iLo6PuT+X5QfMBwbNlIJ5WNTM3uCu6vHw/QWHoChdZrEcbXh+upEUoUxl/FClRldhZDE40IyXxsdYLL/H+y5A++Dl7TJNMNzh1nRZ3qqvej5NQ1/AvdbFuudcimrFJwgGM8yGWT4R9oKbIFPWdcq31PaF+YfarN7H3pk91/A6W1bmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH7PR11MB6674.namprd11.prod.outlook.com
 (2603:10b6:510:1ac::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 00:25:21 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 00:25:21 +0000
Date: Mon, 28 Nov 2022 16:25:18 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration
Message-ID: <6385516eaa45a_3cbe02944d@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
 <Y4U+92BzA+O7fjNE@rric.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y4U+92BzA+O7fjNE@rric.localdomain>
X-ClientProxiedBy: SJ0PR13CA0128.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::13) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH7PR11MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: dd71f301-52a1-45e7-c24e-08dad1a03370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yXC9AIn9HsRkNe+mSIlLQe3NjbZ7E8RCC9FxVSFEQeE1E0Nc68S9Aody1x1PfZkFwA3j2o/0YNBLTtQZ4fMdpZ+u9LbuDEFXLtL9ZyxYf5mhTsvo09nTs0SD8z8E8kuzmHvdeKxJQJS8vgyUqj+UxueALE9d6WOmvaD9lEDlOxdVx3PLo5JkcjxopTcrrqeQjQ7SVJ9dPNuaLqRTAEBpiUxbSWytsNRGgzWsyVj5ljlvrmURwVILlbM/CoCDA7FIG/RESvJWyvHXzPC21/3wvVQKTXUsMUa3ybsOBTyF0Sw1jyNJI2UlKY2R+qpqJJsAd+LduL/96KfkhGLXeQUmp0zHMMkMJw6SPnBL6gNLYCh/wNTkXDvSnv4yJTGatp1BtDrz1/TOpk84tIOoQk//GfLyq3XV5vio7c+DCuzQqP/cifft9ugcrRVJc6FN3pemcGPDXT+iPdTsq5s7VypukMFrDSe7jexw+ErGMdPv7yCYLm6z73B7jpo5rCY5OZNqcHvZQVfnx5piufaMKyI9/FSLTVF3gGiXDlzbHL3B144x/tjJSGRMvbZ1skoLuricx3O167vcbQclJDYY1fDVwfnoYN/jK8fk4UVnTIza29Rq4Stgd2FKu0YPn3bAvaRz35HiFRgtKBtED0/47A2Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199015)(5660300002)(8936002)(110136005)(316002)(9686003)(41300700001)(186003)(66556008)(8676002)(66476007)(4326008)(66946007)(2906002)(38100700002)(6512007)(26005)(82960400001)(83380400001)(86362001)(6506007)(6486002)(53546011)(478600001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTFNMVFZeHN6amlidVdtbEl4SUROUG5rVjBIYy9tRHZraldTakhXWHBwSlN2?=
 =?utf-8?B?NWtjRTlqQ2liMjdoZU5iR3dIZjZZbUZnb1VNTWdUc3dtWFBMZDJKRTcyMzN2?=
 =?utf-8?B?T0RCd1o1ajZRVUp4dkZrdkMyelgyUENuQUlka1RrdUhpSUxyV092QUU3NzJa?=
 =?utf-8?B?a1VVZlpUNFd1UGttWUl2MUt1MlBMd0I4Tm53R1N0aTl6eDZmbWpmbTZHTEZP?=
 =?utf-8?B?akxPVGN4SFZObFlveEQzTHA5blRvTnU2bGZuYzkwWWl5ejZQb1hvYVBDU1JB?=
 =?utf-8?B?dU1uZUFWanc4YTdiSHZmUVYzR3NJMGx0S3NlRThackgydWJGRHJ5YVN6VnFB?=
 =?utf-8?B?Q1BRV0dQOEdJK3daWXJFRWhGVzNvc1haQ3VLUE41eDMydTdzd3J1YVI1UHVF?=
 =?utf-8?B?L2FWSVMvQlpWZ2ZEODhRaS9iYkVTMU9QVENyT3gvYUgvRm0zOVRxbHV2Q1pT?=
 =?utf-8?B?OUV1WXAwWWxCaEJFSU9jdWwzVHJhcXhuNEVUc0xRUTVrVG04bllqQW4xeHgw?=
 =?utf-8?B?S2VmemxLT0VMQ0MxUGFscVZER01OY2l1SkpONWtTUVJIcUl6OU91RnBSK3BF?=
 =?utf-8?B?SVdSbTRUSVVOMHh3b1F6QWczWGc3Q1o5SElvUW5DTzV6dUlodjl2MEl5Q05C?=
 =?utf-8?B?YXgrSnZQWkd3ZExhWWtybGtIUmhEUS83MlhLb3BxSm9tMTlNczROL3gwYmlS?=
 =?utf-8?B?OS94ZU1Pa2ZIaW1QNHEwdzJoVGxqZGlNdmkvMVBSeXdZTkNrdEhpQ3N2SVJs?=
 =?utf-8?B?cURhemxxVVp1N1ZtcXJFNHRHNHRZRHNaNG5sVWFWbG5XZGNVQVpzV3JOcWkr?=
 =?utf-8?B?NHI2TzJrYUVOWFVtdjk3MTNDNlpuMTltK3AwVjNtRHloLzRnNkdMbS8rRjNH?=
 =?utf-8?B?MUdnZ2p2TE1nUkRBZVRqOGlqWkF5WndtMUJld2hBa0dYa0hzQnhYUnphaUhy?=
 =?utf-8?B?aFVTZWYxMXNya054ejBSNS9mOFRtWForSWN6azhMVVgyMWlWQ0kxZnRxaCt6?=
 =?utf-8?B?Zmh6bFVDYm1qb1NFbGF2K1BkWUFVajBTc3JTcU1lYjJUUjMxRWh4TStFYXV0?=
 =?utf-8?B?bFhiQW1tSW42MFpiaURrV3BRTE5pclNzbGlMTnVscWt3aWd3RzFtZkF4ZEdi?=
 =?utf-8?B?SXdWSWFGdFFkSk5wSld4STExS05KMXc2KzFTMHliTjhDYTVEa1o2RnVGRWNp?=
 =?utf-8?B?bS9XSEhnbWJyL0IyTXhiVnVGZ0NoNGF3Yk5aT1FVRE9tZEorb2pMcXNVSVdT?=
 =?utf-8?B?b3pUdzhtRlhPSHZJNG1rc3g2RDcrVnE0Q3ZDVWFLNEdSbFh6VlJ1NGxxM01i?=
 =?utf-8?B?R0tjWWxGR0Z1cnZCRGpUVVh3dlY4ZHNWTkZ3SExlVnJCNWdidUlFckc5bi9G?=
 =?utf-8?B?WEJGTWVzOEt5VTNNa2h1SktQY0d4QUhHN1NHSWxoWWo1T2lkYUU5bDZQRjdp?=
 =?utf-8?B?SzYvT3hVZS9LUTd0TFY1dWdJaUxHU0g1b1JkWS9Gc1JLc3V0bTBqTSszNnlT?=
 =?utf-8?B?WEVDOGdldVowQzNveFlKQ3Zkcm1uMHJ5eXd2dGN5bmQrWjZId1JUZlN3L3hR?=
 =?utf-8?B?bXhLa2w1VER3VkFEeTRxbzBoQWNHSzcwcDR1VFFuWTA4Q0V5a25Cc3ArOW5X?=
 =?utf-8?B?OHFjTFdHazFYYlBmVTcyL0ZyeDBPdWpiZXgvSGlHblExMTRxKzJrV3prMVNH?=
 =?utf-8?B?anZ6a3k0WWMyV1FvVDVnS2p6TVlRaFpUbjlvR3pFTkcxZnA4MklWWEZ6aWw2?=
 =?utf-8?B?dE5LdG5Dd1prQWtxWVZKU3RaVHg5RHFKd1Z5VVJCdTN0T0tFN3NJV0xqbVVI?=
 =?utf-8?B?c3N0eVpSZ0VoWGpzNUphYUZJa1BuWXczOXZDeFVuN2pPYW5xcjltVFB5UDRz?=
 =?utf-8?B?bFRES2t2T3FWRmJZTDEzSnFKQ1BnemExbHRpMS92aE1oeXF2MzJJdGQ0b1g5?=
 =?utf-8?B?MitLTEdRTUpEV2N5L2tLQXNtcVpBYmVlcmVZU3ZzcnFobEV0a2I4S0pKNDRp?=
 =?utf-8?B?OGxhS3E2ZkJDckhmRUk1RGpwUWV5Rml1aDlrOVJ4emdUbDg0R3A5U25UTzFi?=
 =?utf-8?B?Y0lUdzYvVDU1WngrQ3hPdFBaRkNzbVAvVDZmWVdvYXBTWjExL1BSQzNTc29m?=
 =?utf-8?B?L3BFUEZtZHQvbzNJVThaSTVSaG9ZclplRVB3cU5jakJid2V3VEUxQi8xUzcw?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd71f301-52a1-45e7-c24e-08dad1a03370
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 00:25:21.6065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1pKoGxlacVQ/K+6rH4m4d196tIWEHj80zRTz6iSMPzCHzDegObR/Q8NERcsRsVSxOuMzRtu0YzSf67IVYD71GqujLzZVI7/BZE1UFIjbxjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6674
X-OriginatorOrg: intel.com

Robert Richter wrote:
> On 24.11.22 10:35:32, Dan Williams wrote:
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
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/cxl/core/port.c |   11 +++++++++--
> >  drivers/cxl/cxlmem.h    |    2 ++
> >  drivers/cxl/mem.c       |   31 ++++++++++++++++++++++++-------
> >  drivers/cxl/pci.c       |   10 ++++++++++
> >  4 files changed, 45 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > index c7f58282b2c1..2385ee00eb9a 100644
> > --- a/drivers/cxl/core/port.c
> > +++ b/drivers/cxl/core/port.c
> > @@ -1358,8 +1358,17 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
> >  {
> >  	struct device *dev = &cxlmd->dev;
> >  	struct device *iter;
> > +	struct cxl_dport *dport;
> > +	struct cxl_port *port;
> 
> There is no direct need to move that code here.
> 
> If you want to clean that up in this patch too, then leave a comment
> in the change log?

Oh, good point, must have been left over from an earlier revision of the
patch, dropped it.

> 
> >  	int rc;
> >  
> > +	/*
> > +	 * Skip intermediate port enumeration in the RCH case, there
> > +	 * are no ports in between a host bridge and an endpoint.
> > +	 */
> > +	if (cxlmd->cxlds->rcd)
> > +		return 0;
> > +
> >  	rc = devm_add_action_or_reset(&cxlmd->dev, cxl_detach_ep, cxlmd);
> >  	if (rc)
> >  		return rc;
> > @@ -1373,8 +1382,6 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
> >  	for (iter = dev; iter; iter = grandparent(iter)) {
> >  		struct device *dport_dev = grandparent(iter);
> >  		struct device *uport_dev;
> > -		struct cxl_dport *dport;
> > -		struct cxl_port *port;
> >  
> >  		if (!dport_dev)
> >  			return 0;
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index e082991bc58c..35d485d041f0 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -201,6 +201,7 @@ struct cxl_endpoint_dvsec_info {
> >   * @dev: The device associated with this CXL state
> >   * @regs: Parsed register blocks
> >   * @cxl_dvsec: Offset to the PCIe device DVSEC
> > + * @rcd: operating in RCD mode (CXL 3.0 9.11.8 CXL Devices Attached to an RCH)
> >   * @payload_size: Size of space for payload
> >   *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
> >   * @lsa_size: Size of Label Storage Area
> > @@ -235,6 +236,7 @@ struct cxl_dev_state {
> >  	struct cxl_regs regs;
> >  	int cxl_dvsec;
> >  
> > +	bool rcd;
> >  	size_t payload_size;
> >  	size_t lsa_size;
> >  	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
> > diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> > index aa63ce8c7ca6..9a655b4b5e52 100644
> > --- a/drivers/cxl/mem.c
> > +++ b/drivers/cxl/mem.c
> > @@ -45,12 +45,13 @@ static int cxl_mem_dpa_show(struct seq_file *file, void *data)
> >  	return 0;
> >  }
> >  
> > -static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> > +static int devm_cxl_add_endpoint(struct device *host, struct cxl_memdev *cxlmd,
> >  				 struct cxl_dport *parent_dport)
> >  {
> >  	struct cxl_port *parent_port = parent_dport->port;
> >  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> >  	struct cxl_port *endpoint, *iter, *down;
> > +	resource_size_t component_reg_phys;
> >  	int rc;
> >  
> >  	/*
> > @@ -65,8 +66,18 @@ static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> >  		ep->next = down;
> >  	}
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
> As already commented: this must be the upstream RCRB here.
> 
> > +	else
> > +		component_reg_phys = cxlds->component_reg_phys;
> > +	endpoint = devm_cxl_add_port(host, &cxlmd->dev, component_reg_phys,
> > +				     parent_dport);
> 
> Looking at CXL 3.0 spec, table 8-22, there are the various sources of
> component registers listed. For RCD we need: D1, DP1, UP1 (optional
> R).
> 
> 	D1:	endpoint->component_reg_phys;
> 	UP1:	parent_port-component_reg_phys; (missing in RCH topology)
> 	DP1:	parent_dport->component_reg_phys;
> 
> I don't see how all of them could be stored in this data layout as the
> cxl host port is missing.

If I am understanding your concern correctly, that's handled here:

    if (parent_dport->rch && cxlds->component_reg_phys == CXL_RESOURCE_NONE)

In the D1 case cxlds->component_reg_phys will be valid since the
component registers were visible via the register locator DVSEC and
retrieved by cxl_pci. In the UP1 case cxlds->component_reg_phys is
invalid and the driver falls back to the RCRB. DP1 is handled in
cxl_acpi. I.e. the D1 and UP1 cases do not co-exist.
