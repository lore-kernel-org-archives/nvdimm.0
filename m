Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA02D39E
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 06:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675836020; x=1707372020;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XPKnnDU7ZER5x4I0ux5Sn2mKfIArCdOxPizaQ903ow8=;
  b=kUDs8wLVHhvJEMLUWG1HQQLWDru1mo4Axcpsaxvd0fYnwWgouWdmKUed
   asHqsdBih005mGMtbGKdK8aPMrgvOGxBnmw9cP8/7A9yA7QJaMYCpI7qK
   w9tPNfAvWEWzAOISglyfbm6tN+IHRE+TmTaCNRQF7GyCx4IbOjUEWHuEa
   ep1wiZl5M37GV6MAwAJHx2uQN0woMSGKbXy3s/wSnXLJueXx922595IfT
   J48N5ok9hrHf9n2ZINKQr/J7fJhmZbTLPg/QXCuL9GHMb0tZm+tTikZlM
   7rAEeRqxOV5GaaebPxRXdaqn9qNQH1ujl8vCPUdLfA8o/OPBMeAQj0yD0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="415940685"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="415940685"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 22:00:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="775871075"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="775871075"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 07 Feb 2023 22:00:20 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 22:00:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 22:00:19 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 22:00:19 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 22:00:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cghflZyMSMBnGoBJPpU8rWJxAXkI25jHCjoWGqI8TGH3Ttu5yz+S46ZE1IW68HhzTRhBrc/HD8J7ooT1upqPUFZMFB28jxh4g8mO26+Ik573v7e9jnegm+G90JndqJHGML8MYuc6h5JTZxSSiadeI9l8yOM0HmZz6ohV91WkpWV2/3GsdK3wTGhmZ7dAuVAvl8DIZ9p1+wI+vcLWBsLuXVKXXZco6cGO6nGHR0hUNzdqhutibFrM+SkH9WM6FA7SvyKPshbeeL+9zwV6+5aRT1Xe5mAHb7MPAIbAzzYRqL6L8N0urRj5RXsrJ5y5odaIVpUiJsNjHZC4ftUOKxw5Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NerxD5JgmokoBjsldg6Ah+XPTzfauYk4iWi4pbyLhtM=;
 b=MhccrT7x9Eeaet5ixTbZYhw+gi4rCeCNZBrrQUNFMpynARm9iBQAyTZYTJyMnxrHeRiE0+vfiSmRVKX26BrXSP1tK35k+05TrMg1ZWBpEhOb6Q0No2kGYPAnUsD2WjYLVPP4+Iuj7CThoZnphvOWwYZuNpIZEmlY+kdCOG8uUaOoOVrVKDryoybV08vpQQ3VpcxJ18ns/YChngIrPUaojVDEeq9zkX35vrohfJYVs7uCisIlkQkZUDwoSQfv5KrQPF5t6GeQVPzBZvIQQOivTkDjy5xjHVVwW6gYzhoBpZPHjU4AN1ByTGG6a2nvq2REPcs2n6HIpU1Mt+AIbkkjSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB6971.namprd11.prod.outlook.com (2603:10b6:806:2ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 06:00:17 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 06:00:17 +0000
Date: Tue, 7 Feb 2023 22:00:09 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: RE: [PATCH ndctl 7/7] cxl/list: Enumerate device-dax properties for
 regions
Message-ID: <63e33a69e1369_e3dae294c8@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-7-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-7-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: SJ0PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB6971:EE_
X-MS-Office365-Filtering-Correlation-Id: f1f24ca0-a64f-482a-966e-08db0999c0bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LgE0w9VEQ1vPhIEUyJP9VLs8BYiMjEz52pjqKHWjvTUDIBemaEa4pgehI8WL219uJtGOY5fcEeNsvEE3Q2koqvJtlf4Ov1dvR+yByTexwNm5SWah0ESBIzz5/daadP/kSFnixgh59o6vzCpJv/GXnEcnh4Pu5AQekcQTz+ouxoEcnT0VXbkOpbtyYs/lNXk50BQ8Jybf33uo9HU08bEUgISjDuHSwO1iVN55jpSgS0BCCgb5nP585dSOgJhJHo1W6NM3sYw1LIRMZipxgHMW6+9RNyNwDsfIk4vvBI95W3iYW7MS+eVqsnK04prmo+MyD5/ZBKNw+r/AdP9K5RPJrQJGran0AU588aImgbxHLQOypmw03smrm6GaHQYgpWfIsk6p1c9eZkEFIHjRbh7wYumpe5hKrW5j3OIgnkIFVbQJBv4NbHZLWmsQXWtSqgRgjoL+fJ8B9lfIRvyusaRb95UbVe8Cje4yBmeSHZtDdniMOjDP0lNCtUiInKplRYUX1US2gfpF1xKzUTMV9E0JwM4VYgDdH1z7U9AYoVuzUWbh+W6K1V/c9AJhfprXJJsGQCqxoADJvpc1dGrI7TncFCOMrQhEFVDC8EwA+uBQGohQt1inlYHPKfPanc7/PlboPhvsn9lzb8dolRog3jR/GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199018)(41300700001)(38100700002)(6506007)(186003)(26005)(316002)(54906003)(6512007)(9686003)(86362001)(6486002)(478600001)(6666004)(4326008)(8676002)(66476007)(66556008)(66946007)(82960400001)(8936002)(5660300002)(4744005)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O0t7W9RH99MBtSBepVRR2/pmRagtu/mRiTBoZNtEvtU3szw8RZgYWignfVb4?=
 =?us-ascii?Q?b2RWKHPhHsJ/ByrPVWeBAiV5ZLD24rjqU3gPfcQco9WP0QY5IRsh4iJqqXgG?=
 =?us-ascii?Q?WnNxdiq5K9tQsVlXiB7N2RaEAzGXZw/F3pNnbb8HOC9uksIR2Mh0m+YWbUJ+?=
 =?us-ascii?Q?RZ5HQ5f3Nko93dvWFhGm86uG1uqVEVIrnw8Us099Nvyln4vKlCd4yysZCNJa?=
 =?us-ascii?Q?KP/O7b7uiUUQJ49cFc8mK9t6aAXHNlfXIyokTAk6pyJAL8Zjn4T9xbW70EeY?=
 =?us-ascii?Q?o2wO9efEQGhtM5I/4vkUvyXf1iWUgILflIUH5UjOgaY62TuxgpCpFy4dp4jl?=
 =?us-ascii?Q?8Yk/4i6ObAlNNEFZ3CbNwf2Ci1GJbszTJoc1I4H8ZfApA7yH1EJ2QFcBcuoX?=
 =?us-ascii?Q?Af81Srrc5xp8vh1M7JDV5ckAf8Xq16HvaLTtw2p/bvow/cQmPvPdmWJqMBQa?=
 =?us-ascii?Q?uUguvPFMyMF0QGMdGQKaqoEcRULytWqaa3eeP8SUD6x9e7+JmH5O7HNV8T6u?=
 =?us-ascii?Q?WlesBeFz10Y+ABm8dSdzNrrn/rz/Wrb2ETlMitRd9LYYKNLJlBlRl1gzdT0U?=
 =?us-ascii?Q?pYNUkZBCMRyZ/4B+mnnSm8gpFKDcROrAdbdfO+tuRs9kBl/1guDIhD2T4KrY?=
 =?us-ascii?Q?Mp8C0J49UwuCNh3AXcAWyOWuo9Q+gIWvyZYak/JZLMNk3wMxUzPxDZKTDdwZ?=
 =?us-ascii?Q?hTetMHkvnF/cxYh5/fgMxbZOoF+1PvMTlY8i4i0PWBvGAXArHDGwbv5PPL8Q?=
 =?us-ascii?Q?Bjpx6eDafGgSuQRHQrudS//Y0CvCvIk/JdAZG2BAkjZxq7IMS2R5PxXnQG/z?=
 =?us-ascii?Q?2OaZ6frR39yUc+IIl1talLPo1UL185D47OQm3sBQImWU8TFZ7F1CZG7PW6jp?=
 =?us-ascii?Q?WFoUh5g5G+t+usffuL5Ikk5J1b70D9fL+O7qyFdBytNk6i38/WMJ91pezwt2?=
 =?us-ascii?Q?0xsHqWo7etNVMrfWCn7Er35z8ZaSjAn5I2AiW4/akxfJD2iM+Z3rASWbnPdW?=
 =?us-ascii?Q?H6/tWwOse4xaBvhoTBb0H3STptScLU8IAHCA7+zVOdx852kgJPhK8vFwFszW?=
 =?us-ascii?Q?2Ed/ijogQhzaY6rGB1gK7a6yi2+86ImsHFFeunAfCjpTPldn6cy1Fc/pjVKJ?=
 =?us-ascii?Q?DIKRpQFzQXsPhZGBmDVjSDWDYe7OGpcZvjcp3UoP6Ops7cVj5ZJU5kFS+4Yb?=
 =?us-ascii?Q?FOlgfpXNmNa6/XevcIWHces3uphIJq2e1EPVuUusE0rBL0RskavlPAcf0cVp?=
 =?us-ascii?Q?fNtv9fUJ9B13J4pLU9ElD31dp5MQg0W33ikiPXnuQIL1hdEZ1irHG/G9sKQz?=
 =?us-ascii?Q?26Gw9sI0B+8qkUfdVZVpE+0aTjhQsJEZ5hJNi2m4YbllkPt7MPbZ5zlE2x0A?=
 =?us-ascii?Q?2Agrvl6Evtvc3I4vpvDZYzv/zvAmfQ+GtZNEFLqt1WyUOQg507AWtQAaJy+K?=
 =?us-ascii?Q?eVZfteZ5oZH8JTuYuj/glACKx+UMQyIP9QyHnWiU6P6ufLTljU9BJ3CNo3C7?=
 =?us-ascii?Q?fJqq6OhiwoH6zGSj+5yaZ8J6aFGK2yZDLHFkGEyeuL06UXgkg+1M2Wc2n9R4?=
 =?us-ascii?Q?LggfCKkMBqye7STpSpP21qAsnA1SJiW4rF+sd8dVvZVDbz+p7af9wsddQ3kP?=
 =?us-ascii?Q?Ww=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f24ca0-a64f-482a-966e-08db0999c0bb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 06:00:17.3253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NlTnvI/EuKfJe0nPSFV8GXIgREj1Nvg4BowQCvHJ/OHcPny0ooEBPV4y/AK6hprqQnNBC7iqDUrTSK/OzZTTjDuGns4DgDY2UTrKibU8hs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6971
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Recently the kernel added support for routing newly mapped CXL regions to
> device-dax. Include the json representation of a DAX region beneath its
> host CXL region.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> [vishal: fix missing dsxctl/json.h include in cxl/json.c]

s/dsxctl/daxctl/

...definitely needed, wonder why my build didn't fail?

Does cxl/filter.c need it? Looks like I added it there instead of where
it was needed.
