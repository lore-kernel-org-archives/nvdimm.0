Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2BFAD3C
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 21:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669842163; x=1701378163;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rspaHfjVxehPepr5IvBAx/k94OUZYxzoLAGEpOd84Fo=;
  b=BkXVtrKl5iImjfurVlI0Da2Y+95EPBAsYDf2jIFU5Dt3XW/KG49vkBzp
   YOvMR/cgWcEqv8u3sYlsvAZvVFs2Qu+NJOaxOpP+2C1c3QHZNQmc7PBYI
   CGgGyGOiuP3INOF+TG2h+MyAMketWFLtXjokYN6vBIBngxKFFO3lSc7FO
   JhSZdxqlHhpvnv55TV8yPhzGTKMcqpVhP3M8tXZKB+qK4Ts/azcVG9gr3
   Up91ZpesmwEEvnUg8MexSnbl1fJtbkfJPFOvPqrYdXV4I8hxbn21D/QLL
   2JfXg+wEeg2zhlrcTURHaIpX57BW5C8UUF38oSYHx9wFF9ZeYRO+NVEYE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="316665077"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="316665077"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 13:02:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="768974981"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="768974981"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 30 Nov 2022 13:02:42 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 13:02:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 13:02:42 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 13:02:42 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 13:02:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYgWb4xyoh7QQwuF7ygRCwfE1yNBxdZFz6+5T3rwLe3WhtarEBFwu1DN3femAJ1Au2H7y8YX0D8kqEmnLLhTdIkTRYy0XD1KEcbvvxGGn2LSK0H9Zxtzx8U3nGiHwSknDJLjE4g4lNdT25Fw7bUBgS9pUhv90ckAKm94aB6iiHoZXywgncy/jPd8u3IIEiRldkE1lB8unNG9kJfAw9jn0bVQm/i2EoCZIhdiy4k6fxlZLSN98O50hVr6clfRVhuGH03zHC88kPpzjAx5yfC5ThUEVbrxi1HGFOxQYufsprlJ1jkGR/zwekpOz1NHpA4PgHfoUNgcqUWMGUxFEECIDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=764Yw/Iv2F5fg//dZMdSpMDort/JHJefsHW5sPVHU0k=;
 b=g7Vo/GqM+ZuiPK9wPoo+44fxbAZR1QfNwYRzcddFr2ZVwyl0vdPFblm6RdX6FRInechodIBSHI4OiOpHdCR/bPaqCcn5BF5atuJkW5A0q8k5LZrlDi6B/EmtR4yzsgpUd0uV7HF0evJJHDcsoBRct8ZOu4OvMSidHpYxy+jginRS60F9ElvBdLDsh09m19mI41Fi+WYBaGjaw5Gf1RSFnSkZrzDzYz3gsMWjajSB/LyM2w7FOh0Lx3KluLfY48An46V7vhhnXz5nA0m/XT6x0SP+BgO2x/PMvSbHMdnnDdBlfZFsYjp14vPWlrU1vXySD2BZ/peMdbkmADIcaEc9pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB5199.namprd11.prod.outlook.com
 (2603:10b6:a03:2dd::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 21:02:40 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 21:02:40 +0000
Date: Wed, 30 Nov 2022 13:02:38 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>, "Rafael
 J. Wysocki" <rafael.j.wysocki@intel.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 12/12] cxl/acpi: Set ACPI's CXL _OSC to indicate
 CXL1.1 support
Message-ID: <6387c4ee43ebd_3cbe0294ca@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931494367.2104015.9411254827419714457.stgit@dwillia2-xfh.jf.intel.com>
 <Y4cRV/Sj0epVW7bE@rric.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4cRV/Sj0epVW7bE@rric.localdomain>
X-ClientProxiedBy: SJ0PR03CA0252.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::17) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ0PR11MB5199:EE_
X-MS-Office365-Filtering-Correlation-Id: d2309a87-762c-4839-23ba-08dad31637a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pdCQweDMx8ylrqKKwDJE8DVRHiCSdHaAEKMvqa43dJxr5KR4FGQw9RY7f63OfA5H9p4v3i1483YxMHLc59whjc/GyxE3hr1k50pSryLXDrPuxI2P+KIa6FxT+eOdBpRzV+vqbc2m0FtUatI+2TlCsoh1iJXbMV9zCKNtoJaWaIbsazocOlDRieY0IOpYl8NAmHh0w1mvpFc2U2YjfDiha8T5YVxO6OMulpyFBvqVHDJg238RNkf00gkTqOjDpAemTNoEM/o5Vm8QzXBwZUd5W4upqFrK7VZGeIDs1dkXhDTbzGWfNhczaIF8CQTO/FMew8IFt91+uxLGqeSc4yzvEMXopctE5dJLJUSnYv9Z8tUOeizdEtYYS8EuEGXtY0q3vaUp6cMxhn1XazXgo0gGmVp24ysWlnW4zoV17M59/TNOc1OAW67cY2AcVCzHm1rNNYpAYLP+/hLe2E4eze4sOZxvlICtyzistzbJp9ykJuXU++WiT/iSFRztHjCkS9Od2FFwMmjWRU1m3OI4Kzc5BzzhOxWa69f8NMI/q2HEoGltWUd4FJ01sSOAUXRPriFp2sZ6THNyNSY1KcwhLHc0GIm+8OFdsTfo3cbXi818/3pio7saTHgstr34U8prkQQ34rtz6Od5SqcvCpQG/LYlwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(5660300002)(4744005)(54906003)(41300700001)(9686003)(6512007)(316002)(110136005)(82960400001)(66556008)(8676002)(66946007)(4326008)(66476007)(38100700002)(186003)(8936002)(26005)(2906002)(86362001)(6506007)(6486002)(478600001)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?clQAsD2jSlotrUfCMCLR7xEraQm5WNK0B8qihVBsy0XsY9vex/0c8kHJN8Bt?=
 =?us-ascii?Q?x8gWaL2cWO5XGJRSsbSEwIcNj5xr6Wue8WVd8VVnqqgR9Wd3KShL/lWbzrzs?=
 =?us-ascii?Q?3Itn4UP4+7v96/jMvS9mj5AtPRDrdFwKcAe6l+ubyi01IhhUBfiz/9sTz2P0?=
 =?us-ascii?Q?SKKD7MMf+Y5xo9bt0m5rpifUXNewsVNqyE7jD/uwx4bYzh0SA192IKu2elRA?=
 =?us-ascii?Q?a3BhYpAEnGDf1RG6/+WEoJFEaSU1paGEesWlCNj58Z7Jt+kRqeeGcV7ROKPu?=
 =?us-ascii?Q?JKVWRVU6ic3XnOd54pwkJuWNgZUr1BrIUMuONobkRvg7kaiEuNug+2YkJfRm?=
 =?us-ascii?Q?koDtSJEKwylfjcBMHKSobyr005a077xJQY1+atZBs3P/F7m9+Ri3b25E9EYe?=
 =?us-ascii?Q?7lOwpEzGfQJmM3YFB6cfZq0tEzFRSFrZmJKKV51vSKt0Mue7y4/qQUvd1EzI?=
 =?us-ascii?Q?TF7hEjFH9bmAkNjuA8m2LfuaTJhbgOCpKjDNTgtNCHoNnPAjWLMx05JimZ8b?=
 =?us-ascii?Q?NsWA2ECfMDbVxCjqmJWR9r8a86C+li//5YbbXZz6u1dLPz8WGgydWWtLVoV0?=
 =?us-ascii?Q?oQlNscQyLgxYTMqsKPPNNk6zxEoSHoCzRjnGO35+9hrO36LEIPXyb9wpzVIQ?=
 =?us-ascii?Q?uoK9kTo3D4ZJutNzxTtobmMWl+i63I9LhOWY2xjIop2txLZk7GnnYb5kE1o/?=
 =?us-ascii?Q?FTIX7FXfv1DywbEoQKXy6p2JdWre7xLTtlwxA9ZCc/GKnR2rdbylRIALISEZ?=
 =?us-ascii?Q?WP41fgDqTSDlDh7J0R0bNgo7eAfaiQu30iXbu3MpQ97G39g7F9CP3tT7yaeh?=
 =?us-ascii?Q?Yl/ttXAlEMU7s4d08r+bYTw1uIlXfbIUW75eOMSNdvy/Dx4h+TjI0gDye/dO?=
 =?us-ascii?Q?Jaccn/o3mpYymaN66GxfBa5J8ZybqTkBemH51zprgGQcZChjQfGgllSgIFAo?=
 =?us-ascii?Q?dg63F4DGUM0c2mlJ6k70WYz1BTsXReyFsxa8hkw/y3/pRDvp60Ek1p62GvpH?=
 =?us-ascii?Q?HGhMit7JbjZv0jlyVKlQ6/8mwkXnnQzd1dsw187hCk0Z3bxh5ewE/Jx6cWer?=
 =?us-ascii?Q?XcBiiam1TYVVSkkWdMeMK1XEYX7MOS6083e61HbLmlt8GCB0X25J1hmRWNnn?=
 =?us-ascii?Q?N4kDxFZSpTqJqTkKxo153MBdxrXcBtOdTrYWxSX5DpVN7rXjcXOQFL4DWMTj?=
 =?us-ascii?Q?og6DtSyO26eR484JboEm8Mlm6hTipy/dOw1v5WmUcBAs3evLc080edQZO8+m?=
 =?us-ascii?Q?kyBU/9duC5sXExnWTtV/39WM7zQZo2AiXDjVXSiIolydtSSu+prbt9cHwUXi?=
 =?us-ascii?Q?UtvCts6M5KmpitUsY/TysNzT7Ws/n9ronVF+Si2JmV7rXt15u4WbboJF8Xbe?=
 =?us-ascii?Q?8M20EM91shfwPqC84B29oxHnNUg8eXIrLe9PS5Iosejbb93Q2b276Cr6XhlC?=
 =?us-ascii?Q?hMvEfeD+DtamYmJY8A7SxzA1HM5W/Y3nPQwARR54/cZBQhdAfgXeGRE5ZKgq?=
 =?us-ascii?Q?hGFTr/gyTG/oLYetMXJGFSkJvcd3ddfkfPFU+NAQRkeoZcUnZ9gJM8eS7xbr?=
 =?us-ascii?Q?BDjmVpKw3c7vfELhzbt+lPijOw1ylBvjwaJ8XHeXFoatQ0Um81ie8zhqeqbp?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2309a87-762c-4839-23ba-08dad31637a9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 21:02:40.4637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xt0HJ9IdRZGeUkYkTqCf7irvY0/Ej96o678oIcl/UhjKsyqPTkh2x6/oruG+Sd4oH7aWyBxDLQ6++diQ/ZkbT+qTFxPmIax5yqG/PcdrG+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5199
X-OriginatorOrg: intel.com

Robert Richter wrote:
> On 24.11.22 10:35:43, Dan Williams wrote:
> > From: Terry Bowman <terry.bowman@amd.com>
> > 
> > ACPI includes a CXL _OSC for the OS to communicate what it knows of CXL
> > device topologies. To date Linux has added support for CXL 2.0 (VH) port
> > topologies, hotplug, and error handling. Now that the driver also know
> > how to enumerate CXL 1.1 (RCH) port topologies, indicate that capability
> > via CXL _OSC. See CXL3.0 Table 9-26 'Interpretation of CXL _OSC Support
> > Field'
> > 
> > Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> > Signed-off-by: Robert Richter <rrichter@amd.com>
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > [djbw: wordsmith changelog]
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> I have had a reworded version of this in the pipe too, esp. version
> strings were dropped in favor of VH and RCD mode. You might want to
> consider that one:

Sure, looks good to me.
