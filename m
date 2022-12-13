Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1613E15AC
	for <nvdimm@lists.linux.dev>; Tue, 13 Dec 2022 03:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670903199; x=1702439199;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Fqm6E8yxfDnyx+f34U4S6nz0bSsaZTXAQkV48ok+RtQ=;
  b=JPpxeckssSMKKol4VtpnN4kXyPK2B43g3YJnJUhOw6Eef3EVbemC8IQc
   I8nUughUieOfIcasppQlZEHZz4XZvhW/ltyANQ/CFWhm1TwT7Khp6riuY
   aLCrsqmSmiGR1REdraxqWR7CkbNDxjUf7F6mz94Ei0SOxi1/v3ebF9pqm
   EugASM65KtNEb809Z6Z8v3UaxKqtZPpOfmEX9aX7a9Te9V8AYo2+t9Cuv
   QBjooKqVMy6MTo4TILnTEO3yZeGnZ9G87KmwF32vAiP7aurANPL1gWJ1S
   2szVxE2B/X2ev7/fRw8SUjUxSvMB9hzw62OeoSt8xPmsioqN/cKsl7Jxu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="297711512"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="297711512"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 19:46:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="626147076"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="626147076"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 12 Dec 2022 19:46:26 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 19:46:26 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 19:46:26 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 19:46:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVx39xVU72pru1zn1yqVuQSuwEKSeW26IPQZKA8/5VJGZ8E7sPSKdND7A6n0Njm7v7xkDnNKBkxv5AK/YKWXDFAvkvzsB1hctW5xlq4MW/s/M5/AYp4DPOpUs3X1PTlC4VLUkQ/z1czOZqfg1nRNrZaDV6xcM9/uTSz1k+/1WgaLI5YRasuB9BX8ky/QWCJ7GZnxsptyJtkKZTv9IlELsavuBaWCG4AZTbJk3YZEtWEHmpVPdYMl7KZJk1L7UI8qCoqPfpTBCfCIfVxNgsxcqrgZWsLGKchZGfADaGsKRL44X9IMVY0A9GR4MV71S4+9UAemXbcsRJ0/qmAtHkiCmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoHfy+eKMV8yBn/luTm7F9EB6sCgoDVPp3AH2FQnivI=;
 b=jQGgfhVcvuuGjehrMN7yjDA16sKhbovxE58PqIsYD6zPcwYfaGMhwUSytjoqHTSj2bVqbQT44xQfXn0DLTsOFoBm5MENl3R/m3QR6ruPiYzvig/fw0rqkh1xbf9oZOlrhV1GArp3YYuhOix6xjXPXQJar0i883SMHj9SCedzLlgW3y6io1BT9zR9f6UeVp6cz6sKLUKKH8ObNjUNwtw77m4xSTwcyBrujStuQQiQyMMTNtykO/gt7EkR5GWkNKPFK6lqfAM/kmCvQkzbObYKGKnNNmkxQCz5uohwroCvB0J3OSSi6w8iDF4xQziHpY+1BdKKbHCq+mCmIKtZ5Hvo+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DS7PR11MB7907.namprd11.prod.outlook.com
 (2603:10b6:8:ec::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 03:46:18 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 03:46:18 +0000
Date: Mon, 12 Dec 2022 19:46:14 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <kernel@pengutronix.de>
Subject: RE: [PATCH] dax/hmem: Drop empty platform remove function
Message-ID: <6397f58686d6d_b05d1294dc@dwillia2-xfh.jf.intel.com.notmuch>
References: <20221212220725.3778201-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221212220725.3778201-1-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: SJ0PR03CA0358.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::33) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DS7PR11MB7907:EE_
X-MS-Office365-Filtering-Correlation-Id: f96a7f10-f37c-4321-a92e-08dadcbc969e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rvrW9sVM7m+zl9Fx8GVfwIP6u03Js+e/hKyXc16wra5oA2D3Iw6GEoyGcS/KZx8iwTvla6jdEIp0DLv35S0az2QFvpdMQpJmJ9WeAIviSocfRy/68Ndx12KiSB0w/iirM3EEIsTYwXIpIk1BAbg2spZ6HXukb+9BXmOpm3DDvhEqTAH5MsEVpFyHeVQS4vlh02gFpl56t0I+mGoKR/Hq8u1XeDyDsxg9UdZG7a9uALP/LrrLaPZKldhYzcXEULNf1ALSAi6lhBTiDcjSunvsL/ThYnVCVjOFKasQxBUud3BlmFGP9KKKuRbw19jyLAtf221kRHqEQBWFXMZbeodx72t7ZG5K2/JdpQWsZHCThGQLTqmkuf7+BBZPzV+ib1yIS+H99YacFBhTj8yC0AEydAUFSpsqmu+82yQZpPy/ML/kxrxLlOGXvOfP3leZBBBmA/a22CKKDT9cY8uRvQW/0D3WxI9ISBZiBaZVAdp+cqmolBDXq43oXePgMWpd2T0r6aVlgjDiHG1KXvtuxXbhhsO03B+ia8rjfNEwSpDeTIvV0iU/y0XRSFyUMCjMb9LAlCCS32MUVup192AmzwpMf1nL/g30WZJ2ycCup73kgDMnsLJBkeALx5YsGypCzX7PqntXbHCl5jFdsPLNmqkU9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199015)(41300700001)(110136005)(26005)(9686003)(38100700002)(6636002)(2906002)(6512007)(5660300002)(82960400001)(8936002)(4326008)(66946007)(66476007)(558084003)(316002)(86362001)(8676002)(66556008)(6506007)(186003)(6486002)(478600001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?RHc6RldzaPlvIUwanQIM6W0puk3xOZ8v3f0YXLIEP5OrxFmHHQihs/xa9G?=
 =?iso-8859-1?Q?gDR3O83lH33YkpMP66EVEAwRSNR9rHV/MD6M6fzORiiyHB435ruqCwsbuu?=
 =?iso-8859-1?Q?eu1OR5ih3vwk68oLaUqNAyRulwu6LA2Vk+iYQTLuUyMDye5fbmIe7HjUB6?=
 =?iso-8859-1?Q?aTrfVuCouFYxlWoWDIJuUlO2ANLqD6P95pTl/iBcUk0mK5XDeQo4IoC/i+?=
 =?iso-8859-1?Q?m/dmcWNPCb2NsYvCEzFqM2vuyUDnFmNowqv/Yi5gRIM2KtIaE45IKHnUUR?=
 =?iso-8859-1?Q?ZQyfIFIUHZwVXqEdgsMinwnKhuTbNvn8PlSeOM+BdW6gdSuCummEPInCLs?=
 =?iso-8859-1?Q?nMdcAYw3j9C9snf2WanmSfasIBNBsPdQOH+/vViF6wcLv2Dwk7dhEmZQp1?=
 =?iso-8859-1?Q?XPdNTXMPiOsr7hIzbRDgRcAZw44NPTOgbGiQsn2CcQTHzwnlH9HG03GvlK?=
 =?iso-8859-1?Q?G7LrmoXCwfgZcRIXAtG3z1bhLkw+ITeZEc1g3egcRLqp6o+pdh+5fhzUKy?=
 =?iso-8859-1?Q?TV2BoqZYvGxi8BhnUNX1mMK0WYbtOD/wDroC2rFJ6wgXwps91/MpYmhvCQ?=
 =?iso-8859-1?Q?uzUoCbvUBPX+vU0FY0cArRYwEip5jy/c4DSftipqqI7peVHXVAt3gFuftf?=
 =?iso-8859-1?Q?8w/mZ4R4M3xiqvlOPZUG2K3DIOS7ioR8/gPPDYdwhENcUvYSOsb45NowOC?=
 =?iso-8859-1?Q?yy/YY7uhAyMfzRIIxtdnjzu9wcwDuzU+VB6GsbBfsxqQMrwb2tdcl9MFut?=
 =?iso-8859-1?Q?xglcZGM7uTTN10q4qepKMcIMe3Uu3UXgFLRsQo1cLMTR7zUXXSAfL5xgjJ?=
 =?iso-8859-1?Q?FaEpgu08vH5mlqpJSpm5F6r3xtkxpxngnqfyvVKphN/uq63z1ewiBEcdHf?=
 =?iso-8859-1?Q?Si0yBj1tVz8gyWgrmmvcS4wN8onhrkwNB+84flTLIexnMTFkhkLNcliceA?=
 =?iso-8859-1?Q?YCza9X24khykjeJrQoFrP4Eq0gGTCdVyKpvop5xKS5HSdrpSBg7OfeQGQs?=
 =?iso-8859-1?Q?+x4JWTaM+N20PzT+TaOOj6ydY3ry637uFqwkVakp+oCdjfmwjpg/KZZl2o?=
 =?iso-8859-1?Q?VQ1toIkm6utb7j1cyDJmaXHTPxOblYFq4IrdJjuRK+2voWQoctFTgU5qqa?=
 =?iso-8859-1?Q?x6sckTGXHjB2PgWZdnrEbsnFP7qHnMVYNx+O1mzxsezz1adEqXmiaDOYpw?=
 =?iso-8859-1?Q?p6VrFvNq4Wqp5JQ15jzmlAvHq938WDon/ccHAG607IiJjvq0zCV1DjL2Wg?=
 =?iso-8859-1?Q?kfv5qWuiowMfOPjhQKQTcKlbV6dPN8xHjtr3oojz5fkpOxu42lUZwtHULR?=
 =?iso-8859-1?Q?O3p0abDlA2niBl6Tl5g2oZ6NxTjK/zTW0xf8gdzQFwwAd6Zo31m0gAPKBG?=
 =?iso-8859-1?Q?0a4dwz79xDqIRLl/htORKgJMxh4fhuiOmHPSjNvPknPeYuEmJ5w+lW1aE9?=
 =?iso-8859-1?Q?oKibT01XvxsY3hH04zQpyNQoTL48h5sXrCe61sIt5R+l9G3+WQSXbalVAg?=
 =?iso-8859-1?Q?8+1Sg2z92yv0H1MT+XdyCRa74N8OC1A9KuaJDIPZfYwwbB0GKuoSVXpgXK?=
 =?iso-8859-1?Q?MdjaOOYB1dAwZ3vC/Kc3cdBo6R5H7/QQhQ90DXqzsUsrMK0YgPTUt+rpvs?=
 =?iso-8859-1?Q?DeCFjeg3l9sSjSBm2q3HWoPWUQM6pwK6l+4jL5q+Cjlj7lnXCHFGj33g?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f96a7f10-f37c-4321-a92e-08dadcbc969e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 03:46:18.4662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUIksDOFgy0uqnhxFGtdNyaXVdmsZkjwLfiWIWqnDUmgGdPivuzX6hY5QohTLx93nv+wX1uZHtrdvgFd/BMm44pfQRdMTQeu4fPdLEGMIrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7907
X-OriginatorOrg: intel.com

Uwe Kleine-König wrote:
> A remove callback just returning 0 is equivalent to no remove callback
> at all. So drop the useless function.

Looks good, applied.
