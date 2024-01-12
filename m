Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB0062A
	for <nvdimm@lists.linux.dev>; Fri, 12 Jan 2024 00:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IZTllXUn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705018562; x=1736554562;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GyYNfeysuM5tyYQTLrnvP0V0ckzLHYU/ZjclVvguVso=;
  b=IZTllXUnl6mCyWkSAtbHT+TLhyeQQvUfGl/Sdx8SYyeM32VJl/iAwZvU
   e07eLf1ivm1f2HGj3d41iNGYHTc/SjLMEtnOXEVgu701QOYm96iLDJltK
   c6t58DLBaF8V6bT3TrgstZXm1dOdv4Bwht5IyzlrrzJV2y8AJnYgW+OdD
   4jvyZUBf8jot+HF5HBxUpOArjqxLHnG7Bjfj0/dtDFoZB2kyvy6DjDhGI
   ok0frTIKA1gAHHOqMcWjg6w8gPQr8oTMt0zX+DvtTvusv/j/4WfQs5Cn6
   lTGwRudiQ/RYtUJDLOmNF59sFMLhyq0qCNRv28SnuRIFdZIVaqGhDST4E
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="6403808"
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="6403808"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 16:16:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="1114030994"
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="1114030994"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jan 2024 16:15:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jan 2024 16:15:46 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Jan 2024 16:15:46 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Jan 2024 16:15:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqJ7A0YCd1lPTMb5YhKoRo4ETlttmTlUBTDY0+VK0kLS1Q/e7o7txwxXX3s9foJsCfIjJeD4FjCbmnmAYqWWwRu1Fmw4bGjXrmVd8wgJE3GBuHT20zNQAjVHWjvtqTzTcSe+Iid6iWDNVTsUgQ0b52Ic24+JR/gG7a+4sYzrwrDNn8MMdMYps3VGoPX3PXEyKMGxjHiG09+L/p8r2YxjRwkmfKTXi/QMCDGQF1uKCa0NnYoXytTmzqlJBcs8fE41pMj+hvzR06bZB04k4Prh4q74eWFFpvYiy98FPggkEts0JoBnO1sRjz2jUE0KrVz3iBbOzSYnbwKOTLjNPkKJTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2XuncVVNoKbpkck0t599tnkzj5kHw30pRlqdyVXonJs=;
 b=Zog2ZbEsiaG8Boz05M9QoVDX7Cq56WFJkOCcVsOf2rB2n4IOpTSJuGjdQ2psmJejhTpuqnABm8WhVIP42ynj9PiPk2CS6JidDa7I0H4gm2+8c06nyJpxKLqjURqBhuzl1z5oO1+bBkUWXldsEommd271D/lUO7rQpc84v3lWCeUk6qFAI4SqAa2swoKU9Av8T5DDG+REPQzgk5v3Sy/kGhwpRabOndokqXGPeqT8el/xl06XWTRw+K1M3CT+EuQ54mudyBu4J1BWBW7kdULQLwnyvSoZyxPjym4NA1wupMxkBCliwIzK6RFWXt/zJJ/wWkQ0VIeTh7oxIwGCo+IrAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB8175.namprd11.prod.outlook.com (2603:10b6:208:44f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.17; Fri, 12 Jan
 2024 00:15:44 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7181.015; Fri, 12 Jan 2024
 00:15:44 +0000
Date: Thu, 11 Jan 2024 16:15:41 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>, Joao Martins
	<joao.m.martins@oracle.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [PATCH ndctl v2] test/daxctl-create.sh: remove region and dax
 device assumptions
Message-ID: <65a084ade3b42_1eb42946b@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240111-vv-daxctl-create-v2-1-1052c8390c5d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240111-vv-daxctl-create-v2-1-1052c8390c5d@intel.com>
X-ClientProxiedBy: MW4P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB8175:EE_
X-MS-Office365-Filtering-Correlation-Id: 73a46b8d-bf6d-498e-fc03-08dc13039e4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x4rpSnrzZ6NdH72fPEu89vRZRovQqegDOzUyzdiFVCP/49BQccnY8v8n7O4H2IvjLYxStqHwCcsZBKHCProN0U6PnSi8jJtngWnaZOfmUuBwNtXhCPmI3bORqj+EWCm+drltn/Ng2igLa78dnc7yN2P0aDEXisHzZ64f2cb8TgmSWJM02HGPR764axO77sInhbu258eSrhIZzuIPsob7Sbp6xUZivLhEb5yU0hPneakdKdlWsWBdQWkw2j00nBUEeW9+EEscQQuBtmElEq17e/9kmDH/afq/jN/4K8zWkS9RQWXOA6YDPaY/FUioHDGiruAovwP41460sS+UHiEA1ESLNdUdWrBMowo48EZVtuByEDNKXz8akRcMPiFG0h4NqSYC752jrWwXDW9tDP4D/8bkbx6cg1yQJ6pAhLdIwWw0o2tG28vB/tJbFwAWLwPcOKKVtiuONnAVNksH2K4xnGe0lU1+7sFyZRcEdLApvmxfgmBaK+GNtSAcxUWvRCwdtG/KYwf4rOEvmBEnPgt0LmuUUr1tI4ItosCGUVNpkfc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(376002)(136003)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(82960400001)(38100700002)(86362001)(107886003)(6506007)(26005)(6512007)(9686003)(83380400001)(6666004)(316002)(8936002)(8676002)(66476007)(966005)(478600001)(54906003)(66946007)(66556008)(6486002)(2906002)(41300700001)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xCigdt/OH2pkkePcW20ILydewBFJEm2TRg1DYSoKagRxufzZgM2P2Kh2xBNC?=
 =?us-ascii?Q?5BuAyj0MUdyKJ9edYpbwVk/eFF4eVxAN14R4o9zzJHaqWDHFAIjbNu1iPGGs?=
 =?us-ascii?Q?CgsXd1KtYzJuZHaCpXIfYY2FGeWZyGTdpfueeDBfTQGek8IInib+k0XfqpSl?=
 =?us-ascii?Q?YThe8oRWVpp2+E7U8ZejLkpSym4g5HHRaxZE6C/a9MhMqj2IiSq3d9GYH8wy?=
 =?us-ascii?Q?7fKtPvCcCn6C1BsDK3JeanH89FiKrKL+bpzyKzELcdj/vGMbQ3sUabKuWLlH?=
 =?us-ascii?Q?FxuX3iOvbzFWNwMNI+94qFXVSjr9gSF52RMzbtn5cKCJWGiz2P3nYspOS52k?=
 =?us-ascii?Q?EmtMv5xmxeYYtTLMHQusL1bmiI+yfHeiRbnNbekDSTCPUM4opvi5+F6enbMp?=
 =?us-ascii?Q?icJ2MTb1A4TKUms6cEG1lOMXJ55Bj9844N9vGTgDmF8pmkztvrunHyop3lVn?=
 =?us-ascii?Q?13vMehHz6h2w0oAuOEoFC0aDXjLJERnawWnLwrer7+c+2jVfOgu+MsScEhlj?=
 =?us-ascii?Q?zrKhoXE33cPFla79U+qalYcIcgrOzwctUJGV+2Nqja46g8bD/D8e0sa4/fR7?=
 =?us-ascii?Q?5wJYc34eV/pwS/Le/ZyUtjedLw4lvL7P6MiVY4cKfSPWpbYflThU2QFVhAyR?=
 =?us-ascii?Q?AeHIGIdffHzBr3EdsuF3LY0FpngN0Dn4hQCdcsFQydg6JWlCMCj/nyQCCD3T?=
 =?us-ascii?Q?m3TwfAOcqb35wWoXji7GLbZ2ZpS2yTo/kjRBSoWhPUV/+Fu4bIjWRd89og36?=
 =?us-ascii?Q?yp5jduc9iWe9g7Bipo/QpfyXPsD5KtBPyRmtHibSZPv0VLPCP0ZZhKKMFs9u?=
 =?us-ascii?Q?iLi+q9zFypF+WoH2TZe2jLa5xcbVjHomjVAdo8+CFHcvtOm3WYDtnYLoE7c1?=
 =?us-ascii?Q?pT9N3DPBLShmbVPgHdcJKjsgplBxXvxqouCqnfpL6bAP7al+AV/7thUrOn2A?=
 =?us-ascii?Q?Ue5boTxvUX9kMKRoin+FRKYZE19u1VKCuVTnPFs0q1T2HjgqLfTXL1HEsBZR?=
 =?us-ascii?Q?cZ/mH5cgkn9XGy86/P5adZqttG6fU9NZzX6biBtaJFhrfPR1UrtkL4MmMxzR?=
 =?us-ascii?Q?96Qos+fVYr7S8HWIkOOSZ9hpdqmzElfWlt9tMW1xG43neKrFnc3XPDLcqlVF?=
 =?us-ascii?Q?OXZRoB3bdn61g1i2dsiZ4mzeLOz8CWwPJJhE07nhX4nGWnBcY1SWU/qylwcw?=
 =?us-ascii?Q?5YZt7VP45fEg4paGFU7F8slBzKoD389HTn3r73PQh1ihEmJ29iE69dZ6glyH?=
 =?us-ascii?Q?LS5KHlDX/V9Gq4HgxTjgLy7FRQtpRgSWPy4+Mr3bnWUX2BWAQ6VxDvFIhmem?=
 =?us-ascii?Q?jhhNvgj5GhtVjkfZM6tboj0AYWshkw7WUEGSou/P3IPH97MODq2balCGUQIy?=
 =?us-ascii?Q?hPxkUa7l9mNqTt4uv1KmMNIj57IjGpb04LrI2ZQVZgsaLqcsyWdRdaukds8m?=
 =?us-ascii?Q?SFRSdgmbyPJ+aRuMbjcqJHJNwAGA8CnUko2lAblODyXVWsvlrFJAZVbgvOdw?=
 =?us-ascii?Q?DUIZebwyMrWGDjMsBtmP7eGq/23bPm6mZTLlE/pHslhxGvvSjLEJiBTT61Wk?=
 =?us-ascii?Q?91oFQsuU2Ak9er+imoshEK5c/AkEIsaf3zqJVO2ySFFt/csOoXcf3s0Rehtt?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a46b8d-bf6d-498e-fc03-08dc13039e4c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2024 00:15:44.3609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XepEeK3ro7FOeDSGoPzILEsFnjwnKm9zZSViZ8fM7I12vGyV+8G7jwNWiDa3j/dGICa9YA6TPvipv3NrgRdVsVM6NBhREQVR+hKCF6HtTKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8175
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> The daxctl-create.sh test had some hard-coded assumptions about what dax
> device it expects to find, and what region number it will be under. This
> usually worked when the unit test environment only had efi_fake_mem
> devices as the sources of hmem memory. With CXL however, the region
> numbering namespace is shared with CXL regions, often pushing the
> efi_fake_mem region to something other than 'region0'.
> 
> Remove any region and device number assumptions from this test so it
> works regardless of how regions get enumerated.
> 
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
> Changes in v2:
> - Fix hmem region selection in case the first dax region is not an hmem
>   one (Dan)
> - Link to v1: https://lore.kernel.org/r/20240110-vv-daxctl-create-v1-1-01f5d58afcd8@intel.com
> ---
>  test/daxctl-create.sh | 58 ++++++++++++++++++++++++++-------------------------
>  1 file changed, 30 insertions(+), 28 deletions(-)
> 
> diff --git a/test/daxctl-create.sh b/test/daxctl-create.sh
> index d319a39..c093cb9 100755
> --- a/test/daxctl-create.sh
> +++ b/test/daxctl-create.sh
> @@ -29,14 +29,14 @@ find_testdev()
>  	fi
>  
>  	# find a victim region provided by dax_hmem
> -	testpath=$("$DAXCTL" list -r 0 | jq -er '.[0].path | .//""')
> -	if [[ ! "$testpath" == *"hmem"* ]]; then
> +	region_id="$("$DAXCTL" list -R | jq -r '.[] | select(.path | contains("hmem")) | .id')"
> +	if [[ ! "$region_id" ]]; then

/me learned a new bash'ism for testing empty variables, I like that
better than [ -z $region_id ]

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
