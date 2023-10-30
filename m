Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81A51A588
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 18:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CEU522Sy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698690702; x=1730226702;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=m0EiHnW/ye/kMoI3mdB+Yz8Hj36I6bm1jW98hOS94vU=;
  b=CEU522SyimJKUrBrAclyIy2HPalSOMbl7oIAiAn/xqFDyT6fVApbb09b
   5fVcixXbgNCTdufeKsjcu8XK/SREqTneW6+iAOT9CXeOGNvtlOi4z5eq/
   +WtYMNE6jdm3VTgVQG8XcWnv16ug47r8Grd0gG7e9rNiMPrBcdKBgSdfd
   8kzQzc5tDimCnFxtkghuD94D3AMPC1qfhd6v9ZQa6BMPHRQym1x2RGlW2
   yWay8FDj/15VZXyeaxCyCb+yfjz6c/ScCOoqz5A/daCBZovN9UFQMbyce
   F8F485i7WDSBYWnMJGcNYfL5DlHwwdkDva+x1MOAjLZcHv/7jALCEDGNs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="385328005"
X-IronPort-AV: E=Sophos;i="6.03,263,1694761200"; 
   d="scan'208";a="385328005"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 11:31:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="710177646"
X-IronPort-AV: E=Sophos;i="6.03,263,1694761200"; 
   d="scan'208";a="710177646"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2023 11:31:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 11:31:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 30 Oct 2023 11:31:39 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 30 Oct 2023 11:31:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ym7wydj756+QBpRPOmswXXOxo2VxYD3UufFD9QeNAfEFf1Q5KnhNLX2/Cn2EW6ZK0iqzKfTw9BqqOlp/IdvqA6O3kEZNkB5SBcMDF5lB5szH7m+NtwwX0bB036dB9rln/NRkWQO2r8U52+MCUH/RtXDW3HDl7QgSvVB4W+VqXd8ANVm1AKaaWjDba/G1ESao2FLXA/7RnbW399cmDatmTIQ8zneDx14jYnBQ2huJxqRNFB107VA7RzhL9d6kw1+YqB+TP7iQVPdMfMd9NAew7fKl8mIFHeWvOT+813NTJv7GZyj2MERxebxasjreFQlsKdR4+8jvpFaPOH4FAdU5iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukF/WrXtFUtDiINP5JNKHDQc0lcLHuRQpruqibrI6pk=;
 b=iX49+dEAeZQZ2pE4D+X7j0/Pv+JDb2jgyVAUD36HS86gzquAODFU6fObuqWU4V9mlfgsWpJA1MzLwW5TRwSxbyCOqtjOT1KzC3lNlipTjee67FH2BUt+cNNP04574U2a6jqW/LNjZcWHWQzfcP2vVu+8HHwaGcl64lcRwWazb9/FwQzqwQsGIOsIy5osEHwWe/RdBKdG54QmUCaAKQPmXR4018Hh9r4nnwEXSWxF3uDAXSWa+xBBqgLD0p5kb3oTkVT64pcRZVDGl5kUoEtp/qv41AVUdX9bh4ssZFpvZIzYtalUXLEA//BClAJcgQNQDzT5rjjX7ex+/1OLjOqvSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB8248.namprd11.prod.outlook.com (2603:10b6:208:447::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Mon, 30 Oct
 2023 18:31:36 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::e75f:ec47:9be1:e9e4]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::e75f:ec47:9be1:e9e4%4]) with mapi id 15.20.6933.026; Mon, 30 Oct 2023
 18:31:36 +0000
Date: Mon, 30 Oct 2023 11:31:34 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Xiao Yang <yangx.jy@fujitsu.com>,
	<vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	"lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, <caoqq@fujitsu.com>
Subject: Re: [NDCTL PATCH v2] cxl/region: Add -f option for disable-region
Message-ID: <653ff6862f08a_244c782945@dwillia2-xfh.jf.intel.com.notmuch>
References: <169525064907.3085225.2583864429793298106.stgit@djiang5-mobl3>
 <59e51baa-cd6f-7045-178f-c327a693f803@fujitsu.com>
 <7a01a5aa-678d-42ff-a877-8aaa8feb3fbd@intel.com>
 <c460ae5c-1685-9e41-5531-8b8016645f70@fujitsu.com>
 <cae3112a-3cd4-4aa8-8b8a-7ca60fa1fa3e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cae3112a-3cd4-4aa8-8b8a-7ca60fa1fa3e@intel.com>
X-ClientProxiedBy: MW4PR04CA0110.namprd04.prod.outlook.com
 (2603:10b6:303:83::25) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB8248:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c5fabb8-96d7-4279-e3a7-08dbd97672ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E1elEbN28Yf0JE8NL19te1TKlwEwwLy8xReqoD8RJ55pBl/Lv+qfFy/mjMxx2FvrtGGLJlbYbF0pDqJTTjiO8hNmGf0Zy07IH62hr0KJlBSOzGHquQQxevnzFhlDjBLzBfVNxM1hCTO0+mfewxannJmZ00CUPXPoMqyfAvdjt8kmPwq2PIxqytjYOebXebPVPaU5GqxRYaBswSOuMkRdkPcU25jXz6H3oo9/HiWYUkSpdICSQTgLCqbyrcKtuufuQ9sh1nhzVYg4QJdmODLyKQPrNChYYs1M+t/RTOsJch0WzntSgx1tcX3V1vAYTfjskFwdmv+OMhremQh04Zq6tyE5kl8Nx6r4v6/aKNtjoshRXp33pXqy7zZvQFYFXlWoj9yzMyQH+pZsnbNN651lpmMjTiSYyQeTUtQM2AetdXuZRXvxdfm8FT8N7rmrHS8BviI1fB8/+rmuq7KimLG9fHsFI9nCcp+Lo/MIN1CLQcceoREYR8/552ZCXTDp+bs4TkE07hp/bjJdv++yBlBKzEihDafU2+hSkRk1uGOg8U/94VXhKuZhmO2ZjAdG0HTIhm2/9WIT5CD63rVCAbQh42DQVYAtWqaDe7xhi9SFA3AWue2LKCtmu3C1A3Owqolu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(39860400002)(136003)(230173577357003)(230922051799003)(230273577357003)(186009)(1800799009)(64100799003)(451199024)(9686003)(26005)(6512007)(38100700002)(86362001)(82960400001)(4744005)(2906002)(5660300002)(83380400001)(478600001)(6506007)(8676002)(8936002)(66476007)(6486002)(4326008)(6636002)(316002)(41300700001)(110136005)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SiFTpq4yHaC13nt8KcQgpuxR0QZoNdCJ8Ex5r4Zpb0drDYLspWwBRO1iDvhq?=
 =?us-ascii?Q?QTYsaG+uAsbZs3oTzMUu8jQMJxrGvFLah9C5BdexUhBkWYubgPoNmzJcrDKh?=
 =?us-ascii?Q?Es6OgJ0QtnBH5d2fKR50poqYCzXllWacezkJPGs2yvTvKLJw+VVULQqpecnC?=
 =?us-ascii?Q?wM5tscgq7DUgOJcDE7t5rtj1MpcelrPXXZE9mcqnh0NHc9TVdN8TiR/4SRI3?=
 =?us-ascii?Q?N9CvoP/7IER38Zlim94ayGxqysoDLpaD7/XeGEIDcbc+MZa1YfnTSL+MEWni?=
 =?us-ascii?Q?53xWcJ2HJRdGiQrCa/4eRCUB8xaqKu6KhNZl6L8umJfkG47KE5lMztw5zpsq?=
 =?us-ascii?Q?8PFwzLcGiDEwLUCr0xaWLk8IKpWzBA+7QPo4RKKDcn8BxEUJzdSgSFYTlxp8?=
 =?us-ascii?Q?wAMKyur5IlPRJELRRyROqC9FQ0kfQa6Af0ULCgylPnZTmShtWs1rMKXwbKzE?=
 =?us-ascii?Q?m689oCe5lB+Mc/CSc1dGXmM6tyseg95PjQQERo8fG6FuDxz7WHYF3ckp8vEk?=
 =?us-ascii?Q?5QL+PDTJ7y32FeJLzUcInZoOy/iRqfrSHXN386tsJyo4k2g/vd752jm2oKTB?=
 =?us-ascii?Q?LBNYaTjuAfUs+eL8KH93t9m30k1pClHROP+qnw60+V2XGZf0J7eI7XsN7Kec?=
 =?us-ascii?Q?GGVNIg7Wakw8GJPEeWeZbvBR3WSBlDlwZ85Mq6Wl3WXd1PUaG8ZxD5awy2+v?=
 =?us-ascii?Q?mjRYgDlDFTAg9Pi10MM20fghj6WSTawLunzyYm25hVUh9m/XiSSNS3spcJ1I?=
 =?us-ascii?Q?pbgnydyaRoXUTENEH+aUv2BBcrP0vcgo3w75qCz8hapt3OFlzVfvaO9XaBFR?=
 =?us-ascii?Q?P+iNtt6bWwTcITVYZxkZ/zkdcmYh2428ka/xrRi+BN/9/4S0wOUpfwuP9tQL?=
 =?us-ascii?Q?FduTWReY2xCOVfHuoNfc7tfEfo3dLorWBlBmHkCMN2uwFNO4002lzwIKC33N?=
 =?us-ascii?Q?QKgNBRiGRkz9kNt3REKDlfX/OPkNghKhYpAfHyZ7RJS/STlKMK5u0EupBWxB?=
 =?us-ascii?Q?tdGleCLiEl/mA8rVPK0NNASccvG2+MF1QyucYV9hUitP+iGpZUh2YjNDa9BH?=
 =?us-ascii?Q?V23KVogsrLxIlpYyDHipmDbFumu1dosGvqbekVPKzF0ociG47vPBT3azyiwD?=
 =?us-ascii?Q?jxxqvHHPJYrXdmx+JQU+uZyHSkGNW79O7020Eu6zDv55/9bg3dKbVtshK0nE?=
 =?us-ascii?Q?MWtUTPKMBUgAwcTrFyTNe/vwPLiM4DEOH9WybwXXJ4SghQ/vzj+aMQKdqnxG?=
 =?us-ascii?Q?Q79zAbhuP6obGP61BRour6cu49gyU8N4YizFnWNSlKiCvnQMjAUb+4eNpG4J?=
 =?us-ascii?Q?+NlwnQo9v/Dl61llsjMP80LwZYC3JWQzdDSLiTaDzELMnWhyF39HqRyk9qiN?=
 =?us-ascii?Q?BYe1psKgtYrt6HTJaw7An1/mWrZA2fw0EJ3aTCbVkKsQZdv1NUVNa2JlYPKx?=
 =?us-ascii?Q?LP0AfaL86jWqPbCjIilVcJ2jJSwBrfhOHDKFFhZZsPOwLY7MuMvcgw3547Om?=
 =?us-ascii?Q?ppKJcf18M4jSo/y/4KbjnQXk8i4y/Xs3CwS443pf+s1tQ4WVeZHxZeFjQqzk?=
 =?us-ascii?Q?pJiV18/rns6EWLVjcXXijFAtMlrfBfhBmIoSU0a94lE9fZ5gpC7UP2jS76Dj?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5fabb8-96d7-4279-e3a7-08dbd97672ea
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 18:31:36.1853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgjudSrNfmIrdWZBAWEMdgsYa1qH4G/0D30b88KECSwh/zZIkx6PW03qc6maFjeAxN2z4fBvdP7A86PqSWxLC4P1MnyQeVnLyzwcfp+7ib8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8248
X-OriginatorOrg: intel.com

Dave Jiang wrote:
[..]
> Ah that was a mistake. I meant to call the query function and not the
> online op function. Do you have any objections to
> 
> if (!daxctl_memory_is_movable(mem))

Wait, why check for movable? ZONE_NORMAL can be removed if you are
lucky, and ZONE_MOVABLE may still not be able to be removed if you are
unlucky. So I would expect that disable-region attempts to offline
all-memory blocks, and if that fails then fail the disable-region. That
would of course need to come with documentation that disable-region may
leave the memory in a partially offline state. Then the force can just
rip the device away with the warning message that physical address space
has now been permanently leaked and can not be recovered until a reboot.
