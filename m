Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E04C390
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 04:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675829778; x=1707365778;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Hm7GsovViH+DOQlTReXM9j2EpIZAQKY2c3q/J8M+2Xs=;
  b=VwJ+Z07rVz4quD4zjw61H3cNHDKuIYnfmOorjrEQF8m8r96eYdUN6c6+
   XqWTJRN6poBEBrW7hPzxcgJxsEa4ANJ/KwWC+r10lLw60BY9AOBayfHwo
   MGg0WRdc2slzou8X5WQX8RPYHEALGODschIOPnGFOzfIxeMjy/kH5yvTY
   H18uq5+eeQt/s8/nO1yXbEp4TajFAWlYEsKHWwqebeferpU6BGLTRmn9O
   whqZg17XjyzfcYpmSjZvlaoUfwUWYdEe7QgSakr/rRQj8FL0qde8viD0h
   ZB4HEXyaJpxOpxQQKAPMrySUi/8TqG5oeh/F7KNPlpyKiTOm+sLBYmoFM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="357090827"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="357090827"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 20:16:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="697522614"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="697522614"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 07 Feb 2023 20:16:17 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 20:16:17 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 20:16:16 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 20:16:16 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 20:16:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhObw3xCMBtOvJTsZUaCxFYI1ls15UM6bSpZ/Im0TC29nbxTtoo0FRZOf+43f3ufvU69AzOQYB6W/AGgVCxw2S8clYYsTqdBauHR9EO+hh08pFhlZpBIvl1eVJN8c03S/rtowA3LYNvC5x8hh0MFAW3U4b93QPRfx8C0LLW66btM1NhI0/Ez94XvYXBdXzCA8qlrcM50XBioJOrPKDoTGq06sBiOHxwDfZbcoq996EmvghGJWjxoOQRnqziqFgiOGW/Cx0+pAR/KCEoxyjXHJV4j4krMwh6NlGIzIc8WYOpQLVFO2UU3CmpIp71yyoVY4jTf0c0uq4HKbgFBAoQXnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tcp6/m9zT947vZPR8avqcF9BseATA/t+vozIsyvfk8=;
 b=YxCBLXUisoKzdzXWwOX+G1dBny6ISpZVz0O7mZwjuHLrYvJb9CZHfTvax40OvRRoQVo0+M7oiD3mra497y06wh+ijX/jmO7qA2oeLLXMI42mweBBUgp60HNDm7db9UN8AWVsOKXZz1ubIZrkvP5NwUJFIRtdrKIUxC0/DTAJZim+6EhQ8VtD37i5OplloTkHlOmoL8JOoTfuRtpM1Hhp4aAD6bevwlxtdBl/3ptOa7UOct2omH8x26OhRXNbTp+DV7EUUE/2vZTAvm8z/jyZylXDNmr+r0VRKJcK2FNYjMIeZ5Fw0cp1gsosdV6oanEEw2wLoo9GMnFgw4qG6XpgJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SN7PR11MB6850.namprd11.prod.outlook.com (2603:10b6:806:2a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 04:16:01 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6%9]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 04:16:01 +0000
Date: Tue, 7 Feb 2023 20:15:57 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 7/7] cxl/list: Enumerate device-dax properties for
 regions
Message-ID: <63e321fd1363f_110c81294c7@iweiny-mobl.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-7-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-7-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: BY3PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:a03:255::16) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SN7PR11MB6850:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d93afda-7c54-4dc1-fc65-08db098b2f8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qVvNlWxh0TgLUuiB1nwbke525+m7QYcaZYzPCfkBk2onvwhOQppY7lvRhY0xTQFtDYlWgKwqw4SfEP8WW7YWoszQi0vrWhXdUHUu38Cy+KSW2Dzv1UDYRzDDWEUMlezhCPWGZAhTXOqtvbXGSAfMsZfXKLnate28+yGs0eDT4sms6Jp1wJfMcgqsUhTVjb4V2qaJXqaUg8fKKmJnYmGc9Kd6OIRCtQxPS0DLuhPtmwyr0J2DGvGKRQ3FPrlXpU7AaPvi4dfNycAiUchUshc3ucZxpN2NOWJjSbGbLIbpRpD64qlwinhwQ2NaHOXulaF2fZHQYl41zRWZN2avNJfICbtOEtoxbQx0P+3tBQ73FFfbZUm+Wmcz+0CZODnFQxo5M+mgtntjTZ7Eik8ZExvrY/F9FbbKH4OooUQ+bWret/RJxKes3f2qjF8/Cht/XTzuxK6uP/R5Aog8fenjH1w1W8lF2+uAsjc9NX62tVp0nyGsYaAO+UOqT8PmmgapwMt3r22vA9WpGjrbBUrjg4AeAQuUx4Obp72OIIqIPWEy1JciS455Q1tDlWfJZPuaX5fKhghjAgoGnRDGwzuJ5Ta3pyjTMr/IP3L9//4R45Ibv6fl5PMcxf38wk4DfphJeNsrFX5PzwM2l+XNJYlxYZD3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199018)(6486002)(6506007)(478600001)(316002)(186003)(6512007)(26005)(9686003)(6666004)(54906003)(4744005)(4326008)(66946007)(66476007)(66556008)(8676002)(83380400001)(82960400001)(38100700002)(8936002)(86362001)(44832011)(41300700001)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HS8TLUUuLGuCyoW+VK3xGxa6CGss6RNUFtI6bDFW1HoxPNstb/mEF0yCSzEp?=
 =?us-ascii?Q?vOLFVazsmoRi0ns0huEgszwUH2aMZQmmWdYHhIO95bRJ88hlAvArJ39kza7y?=
 =?us-ascii?Q?AN4vQ9Tg0G3V+Pp52LUPTOzdwBQi8r96XQHSv7b+cJAHh7I0Ijr/S3FN0r+s?=
 =?us-ascii?Q?dQRZC0U8Bijhpi5mkqThhWNKvph2uj0/rV1e7/kiPr1rMzFITzj4RPo6kEeq?=
 =?us-ascii?Q?b8v8wzQb71gPQ1M/+mNirhD/G3cmgYDnXdPaPrxoACmy5sKIdaHca9JkXQCM?=
 =?us-ascii?Q?QrjVou9yDuGvMp5gpqgvXqFsUFOpGccMVJuju/cW1SNL9liF+1tSrAhZdnVX?=
 =?us-ascii?Q?Zct7YHCu2LOtJy87JCuZk+79/uNxFNGDUpDgSqib6gCi6IyWw1P9fblJrClb?=
 =?us-ascii?Q?f5ooB5RMM7AuofNavFNTd7GGkVBBJQxvwAqDc7LWRIMca5PWt4UMX8W68Vmj?=
 =?us-ascii?Q?D9O/qPKMhjkHOCG1hL8Z9IAjPrCIl2k5wpw9FjQGIqoa3ZKETjDlAWwXzl0y?=
 =?us-ascii?Q?pPYMZ/u3l7PPlxijqTaBl4ieU+FOb95bGiXPUiRel+bypjMChQmIcsmlHHZq?=
 =?us-ascii?Q?dKWN14Gr660Pcdou5tssNUVr+yV+CXPfjJRIK4Vx0WKj6k1JA/7EQQ+o+iOo?=
 =?us-ascii?Q?kNvRr8YDDagVIWC+hLtJQVoBjCRh4iOAUd4AKtaLOD3fn68rZiBpMA2uEYz7?=
 =?us-ascii?Q?oRcl5apVdXbrZgmr4KZfkwQ1fr/WN/7yt4JTkC0Frf1DQr6wHb0brDY9djWf?=
 =?us-ascii?Q?iWY8qnDJsr0auoltCl1SgKXxc9tDiLrcBxnpYEwrDHfn2a8y1+s9usr2hRX3?=
 =?us-ascii?Q?erDGIiQHUv1u0UG33fZlPKOtsxlTCZHvq3GockAyJIENd25uGE8C2Rj8Vz8d?=
 =?us-ascii?Q?UmBqPLBJyv7PC+k5xIvIMPW2xllriaVn7jNXj3fXyQtWFuhZwZiMLvedCS7C?=
 =?us-ascii?Q?wbNWL4Dj97Yx9fF7jjpeQGGj8aemVXyVvdFf2/u4uLFxxLrUcmv27qWzZ5JD?=
 =?us-ascii?Q?dmmcmWje4TzXrTWOApp+vC39spTYuHFJTWnRhwqDT0zE96n3vWmgAM7LZF0Q?=
 =?us-ascii?Q?V43+Kb3946sWDVKY7E5K1BGDQiRdJKiPoXl+08xlV8qTFmQwGf7CFx5XeWOq?=
 =?us-ascii?Q?3yBIaNfc+uZpJH3mvSaRs72Cw2WbWl2ZqNnKWz2NoIoKXVjIhDBUcQrQj+vw?=
 =?us-ascii?Q?IqjbguE0lZpDBQMmj2oSURugpWYLf1yetogPe1A//GQmtv9zFTMWONV4R1A1?=
 =?us-ascii?Q?KMfcMuIsRcVNcqhChYUSsfqebydBqOSbXTLBcHkeHBDw+VbZnXhfoqJwIS4t?=
 =?us-ascii?Q?yk16YXWO2fo3LV4KYwIvZfAF7HqUp/fnbImS0C/HAatZO01Kj5wg4M/rNicj?=
 =?us-ascii?Q?+ak1y+5dr6L04wsy9rpTDMflILv/MRuUARqkjRuZBnO//+l8Cg/frTjAwyuD?=
 =?us-ascii?Q?WMJB/dzDRQopx+n6+nJ2EkL9/Qr+nwC9VxMBkIivpcwJy7ZbOaYZMVUt+foI?=
 =?us-ascii?Q?XCO2vZwDEMas2V0ProZMzI7pcjoefxC5qd6acy1W+dZsK1HRIqT2Wzf+ON42?=
 =?us-ascii?Q?lL3egwRzshEPpt1ycc7elsD6yuRM+w29KFMN7j8QpXkJUp/sRcvxkfkG8l8A?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d93afda-7c54-4dc1-fc65-08db098b2f8c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 04:16:00.7648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3JSVV7jVF8XFORPiwe9p9Z4d6wpff9tD6mH3MfgDPMJkw2UVhjFLn4Psc7bSDzH7b3NUxJZZb4qdjZPtGLdag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6850
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Recently the kernel added support for routing newly mapped CXL regions to
> device-dax. Include the json representation of a DAX region beneath its
> host CXL region.
> 

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> [vishal: fix missing dsxctl/json.h include in cxl/json.c]
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt   | 31 +++++++++++++++++++++++++++++++
>  Documentation/cxl/lib/libcxl.txt |  7 +++++++
>  cxl/lib/private.h                |  1 +
>  cxl/lib/libcxl.c                 | 39 +++++++++++++++++++++++++++++++++++++++
>  cxl/filter.h                     |  3 +++
>  cxl/libcxl.h                     |  1 +
>  cxl/filter.c                     |  1 +
>  cxl/json.c                       | 16 ++++++++++++++++
>  cxl/list.c                       |  2 ++
>  cxl/lib/libcxl.sym               |  1 +
>  cxl/lib/meson.build              |  1 +
>  cxl/meson.build                  |  3 +++
>  12 files changed, 106 insertions(+)
> 
