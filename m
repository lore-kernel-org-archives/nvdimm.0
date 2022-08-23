Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37D53202
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 17:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661275551; x=1692811551;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U1YsNeRgt9iQ3FPilR+Ki1vdLzFcFWWEmeP5DGTNPoE=;
  b=bL0j0Nuc8Zg1bJbXJcjZIk7TZpOT1soe9bJKtVc0kMuWSSx+4M/NMvKD
   2IFqytDWxZ2jaYTe6c9JbmzE4W6gJWZKI5ZgoOkJ6QVmG7DeadEJY6QSe
   lOTPJf1Cz6tSfY4p58n2TS9qujtgdK5IgAjsOme2x/hAQC6eTtILCMQpi
   NpBy7fJ9iNv6KltMaLA1PJywG9JUv06q7VDuWJIZbn+ySbevSFQNwRftz
   0BXkt2abMF/BCPovqTzPlWUNvrRmHfqHr24w3T51LlMmE5qlqQZLljbxr
   4o7YNNDcLaBafky2/BHzOSLdANPj6YnuU/GVvfjmjupYKMGOGn7WyJoKO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="273504056"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="273504056"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 10:25:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="638748060"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 23 Aug 2022 10:25:50 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 10:25:50 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 10:25:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 23 Aug 2022 10:25:49 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 23 Aug 2022 10:25:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNaSD+cWr6LmjMKWmNvOKQxbW8jDVDDyTw1/jrdGlOhIkKHmJqImw3D2ZKGXM+7zJn6WkTKzUtqDqJkyWw0xdGY64c239KtDnfMKRFNu7w+ptDfkJOhlnB3M2XchPxj6SU3Otk+lXtosaRAzgktbA+t1IzdT60j1kgL9frF4Vn5Q+ocIBwxebpmaszcC376GK+vTl6upYhrwITFb26btq680t1ZdRF+cXODE13Aji6GW+uj0Znq38nhtgsuytODr/FBZTW6FrHVBwjJWt4rtP0Z4DOXtXWedRBX+kKOO1yCCmc4RLaVuhbrz2+IAegigwfqhUqm0+sfogGCozAHvFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCom6PqvYzWg+1rFkPpzC3RbZeU4gUxPpGrKj/1RlNk=;
 b=bVUzT/RFb0lQ17Xl4ITkj8MjAuwFp5YZszkcBVeFp05ada75QGF1jcDFh5Q8LCBMqIxdjBzel3akM+7Y707WEPd1C/OuITGZquv0/wQhhjUpghwICfUmXV2q1oz4LyKM6xDHwJjgl+zW77u1+HVWYrZ3uhlVbSL/v/gcC+SHRM2GOD7k3GU/9EjxjuM+FYnMWheIRZjRmmUglM7Kbsj1iV13WCIQp5Q0i2P9gqDZu2xn6YIMqHoFWgmx0+rB6tMy9BnA2ElIPKYrtXFK4R17IIk7/PJZNujzch2gfoGLyLySR2bDadheg4+dKKsekYyjhoGjX5eQGIIPXyPjnqUNxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Tue, 23 Aug
 2022 17:25:47 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5546.024; Tue, 23 Aug 2022
 17:25:47 +0000
Date: Tue, 23 Aug 2022 10:25:44 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH v2 1/3] cxl/region: fix a dereferecnce after NULL
 check
Message-ID: <63050d98a4c1e_18ed7294cc@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220823074527.404435-1-vishal.l.verma@intel.com>
 <20220823074527.404435-2-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220823074527.404435-2-vishal.l.verma@intel.com>
X-ClientProxiedBy: SJ0PR03CA0208.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::33) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd231133-55e5-4c71-744e-08da852c8412
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TZyQAC0siHMtRaQeftQI9myEk5g56S+SfXU0SduGqGj2W07PDdFqY534sXCiaXvA/wTsp23wZX0OvgWEU/4LyVjkPuvmHKgYAXy4SI3eR2sFaowRM5hV9yU+3FqzSooOBlyWsJ5aIa6JHnZt4TahmoD16V/DNa+4DrD+vxNX6b+xQpwfwSAaIJLOCKe2oZhXLWvTL3OnVEU7cPjCB57+mebBOp4mY9w7z0Rec25qy4ms8fYZYNQrjQfv0m642yar0Phc/t6qpXWSrvl/YfRK/VbIOSvUooqFQwQKsnyFXk6R82JLhMskDCgA+60TPzW580fJcz5FxkvbXBFSLmWbAC4YQtytV81Kipw+gBND/RCe59HymAFgDJ72zJsSweTDew5a2vyS78jmJ1ldK7tbfG0qzkaJd0i7ZatV10RNFAzl/dTbLiVQkps+0Wy6SbYPG0xLTbLHbP/e3I0Op3n3sMczMVwtJ7j3DZOy6MGZ1ZJKMW7gsyDYiMrHp17aaCUXSE5bGtBCI3A1ojB5/c6jJVa4khOw8YCVcwqj/vXu0LhzFaW8wa/g6vsTbg4jE/GbF3IPt2u62/XULe4KYiIhYS9GvOOXy8/TQq3yGhR1ihrBDd6Jm6PPaZR79O1VnYda90Df/4Y+bDRhZLZgSsfcsgNJUjawYq9JtfDPNWKwb5YIed6v5+CmO5Ie4lK57oNC9gwlftyxUeztv6WIqBK/JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(39860400002)(376002)(346002)(6486002)(316002)(5660300002)(478600001)(8936002)(82960400001)(41300700001)(66556008)(66476007)(4326008)(8676002)(6666004)(66946007)(54906003)(107886003)(6506007)(2906002)(6512007)(9686003)(26005)(38100700002)(86362001)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EsuZf/zViiQ3x5YVPUJCm5045K2YVGcc/9uMqCOlMK183gQcf/ZC6trqHYT/?=
 =?us-ascii?Q?NWAHu/yzxSYdvVYQLPdivuQvOLjRktq2/VyICSucd7wIVDk1Ohe40xgF85AI?=
 =?us-ascii?Q?jSAp6EM04SDR1sy9GP4sC5nCIZUwoWSpjKPOwdPmaIO5/59ha3cWKnE+wGjO?=
 =?us-ascii?Q?3sVGl+jLt47jGVT8lusPE3LmGnPabadtw7in93SqkaDbegfdOY4JbxPyZW/L?=
 =?us-ascii?Q?xJmVeUkKembpRUkzqEs+h+IWilQjK3i/XAHhfWKfS/bRNk6MxpNkRTLyOizC?=
 =?us-ascii?Q?7M/FeloveXkHxg3gk4I4RNfrCY60nnThz0Ejwi+C6NtK5J0k7IrcDdlYsIaV?=
 =?us-ascii?Q?NJNg/Q6irsQNOvHd/wcqsWVIP9o3pdJmobkZSH6if4Ha3vPHjgP1qrh4QwOT?=
 =?us-ascii?Q?CRiOoLkg3qiKzT5nKEp4FN+BL5WziUEg7sIJlEqOEbDLbHExems0UCj6WNYp?=
 =?us-ascii?Q?KBqhoim/QB6669tLXg4QWYizzFrlux8AzQIkXPH8l/amwt1DHOYcQAz9sGkA?=
 =?us-ascii?Q?RUStlxPmvbzPTXI1tx1TG+yVp6CjHb+1qZZxmllxoRTJR1/recr2Qk9OeOF+?=
 =?us-ascii?Q?S33iNm9jufEQqKWe9rXyvlI8mx3tLACekPfW9FH5oKvmNV/8Y6KKXxWJKlt5?=
 =?us-ascii?Q?jDHuxCAqnxen95Pwt0xoPfrV73lF3m2FulL/ji5ly2z12+hYOwbH1wUE6SMf?=
 =?us-ascii?Q?Cez7vFjLj8i8KtW3ivdDH9zPP4dU205LLUJyzCQcLCa0hgqluAq4y4B8XmTB?=
 =?us-ascii?Q?Q8+UT/ZXChaVSEHMws59v/G+ge2AHgHQfAgPiq0XjopnP98CYA9CNvoesRjn?=
 =?us-ascii?Q?223vfp4IuaNzSjifZ4WE3oyolbXsXATWQqywsqUS4S5xBhr7FHY1lWwNHFQG?=
 =?us-ascii?Q?oPvS8W8NW+Fx53PKvNSozqsys2bX2mBwxxLaTpdx0kGgkHjwgjEjOV2dLNR6?=
 =?us-ascii?Q?Bi4wv5uaG/C/v5M0WjP5zSPfFBklNHC2SEBe/hIM+Z53kk6Y/VurvktiLQVa?=
 =?us-ascii?Q?35D3lYxC6ECXwXWMX3Y4Mr1I/P3G5ceCgs9Cd/Gc7BYnfwIRH4rrp3KVCmgl?=
 =?us-ascii?Q?pFZo0rDSDWDUeCVd3LONaZqFUEFMpkTxhJUXs4+GliSc6yezLX9gF/+hRPBp?=
 =?us-ascii?Q?mK5it3E7uwvXY5DYDef7OXkU+yXmk0xtHicSu5oaybTdSmuNy+vcQZXHHF86?=
 =?us-ascii?Q?6Xyi4YiVm3DHgDOR59A6Bjjg3VBCbDkDQp8YNHF6HNuRW53/Ahgw9Ds2V+fD?=
 =?us-ascii?Q?OsXmKPaw2H9g1EhWfjbJtjVG9i/XztXcZtEqowa1hpfvrTwGDW9LyS0k0z1R?=
 =?us-ascii?Q?BqibszprlhdhcZ3fpSkW6+Z5xdrtElu6SS2aALZPwNTZsx6SoxKce5GBsk4a?=
 =?us-ascii?Q?stNMPYuhcaD9/nwC5YeUxnTbEPtIa2Nt3cDarS2v7xLXg+u+3pl/576NxGEB?=
 =?us-ascii?Q?4J4Ug8BCvo29ZBscrKFTDWmHBbELSj//cCMAtRvL+5Ys05n0R3ZI6oOsS+rK?=
 =?us-ascii?Q?p/gaCrIxVqlzXmZnlNgsF3l0Z/3pk8LT7bOclKHgVLkHe0vVVzhIczc51Jx/?=
 =?us-ascii?Q?NjDExiMy6IMouiFBAI9+466UbChFY36wCByBUztluGEiUjgHBIpYXTv0qMPt?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd231133-55e5-4c71-744e-08da852c8412
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 17:25:46.9390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSei4EP+NZQDYTghXeT2OtBgDB9LD95aTqd69RLpgnK1njwftmRTqsrfUhzP9LVWiTVd8kYli6I+2HZfrHxwGdmXNFwsKW/V8R7/3fJLdRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5332
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> A NULL check in region_action() implies that 'decoder' might be NULL, but
> later we dereference it during cxl_decoder_foreach(). The NULL check is
> valid because it was the filter result being checked, however, while
> doing this, the original 'decoder' variable was being clobbered.
> 
> Check the filter results independently of the original decoder variable.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/region.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index a30313c..334fcc2 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -686,9 +686,8 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
>  			continue;
>  
>  		cxl_decoder_foreach (port, decoder) {
> -			decoder = util_cxl_decoder_filter(decoder,
> -							  param.root_decoder);
> -			if (!decoder)
> +			if (!util_cxl_decoder_filter(decoder,
> +						     param.root_decoder))
>  				continue;

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
