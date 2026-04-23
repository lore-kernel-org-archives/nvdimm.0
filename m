Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EBA36DA0A
	for <nvdimm@lists.linux.dev>; Thu, 23 Apr 2026 15:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957197; cv=fail; b=sgpO26bLERaZjy2v/U+V7lbJCvrvPMEYbRanVZC7KQ6T90nLL39/DuxiSuJsmnseOuRCCq9OSenToNmmGkoCYoTZlCk+/FHorVO5ZCj+QEB0Q/S+JVpkkQvp3R8C1BbFSjbj7Terad+iXifBeZZg93VarW0UXJmcKxbJzG+iBh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957197; c=relaxed/simple;
	bh=kyAjplxm5dSSJKMR5EYDkN5nHei63w01mwQ8QsvC3mQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dEn5JiL/5KlEEEq5Q6gU5Ys7RKdZw+vXVgmPEZHSgx7mS6qp5GIdK6QdZG41xhP9072AxlJ/M8oDPsWGhyFueOWun6hVB673Yt3pZU8EB74gHtL22YWUF7/1n8KOMd0IN1MatlD25gS0MVYXzua9XDuGk6yTttp7fB52hLKfJ0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C3ajSZJG; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C3ajSZJG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776957190; x=1808493190;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kyAjplxm5dSSJKMR5EYDkN5nHei63w01mwQ8QsvC3mQ=;
  b=C3ajSZJG189f3+aPUixqGYH9I8Kt85shNF8w7P8MXZo5furCKYCcDkJ7
   nYucwYLgzYC/uxk5T8Da+zkb8qO02oUjZtpSq4Wf8nHE6FubQzpw7so0m
   +NnRm4vg26L0DYDQko0+aYCVh0qZO9w8FMgNvYtQ3MkHo1GVcJUrVchoz
   LSmptWJm0UepCLRdqq3bWJjCWpgmABTb/xGtdzvwuKU3JIAHJpaEIbg+I
   RytNVdGcHmfxl3NyomVUlSf3bEWoeE8gTmZJArP8+zozoko4sQSwBlaR+
   WwbDrGU2Z1qPpQuV7+EZIfFDKN9u0ZWho1aQFgs+MxZPOVjje2yDdptSD
   Q==;
X-CSE-ConnectionGUID: b5ShQQa1Qy+3DeMoivnvBA==
X-CSE-MsgGUID: R0jtJCTSR8iSx+FVTPHYvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="77631261"
X-IronPort-AV: E=Sophos;i="6.23,194,1770624000"; 
   d="scan'208";a="77631261"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 08:13:08 -0700
X-CSE-ConnectionGUID: CInfx5CNQtOF/LTgqNv5Zg==
X-CSE-MsgGUID: r5NZfNewR5y2FKKuagyFMw==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 08:13:08 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 23 Apr 2026 08:13:07 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 23 Apr 2026 08:13:07 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.9) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 23 Apr 2026 08:13:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZbP+rlT6NCctC2WWd5TM9wNhQzcoQLDZIffFJlnWYQlUQesIOp7SFmeBwTeawXKVbXqOjWVlrzub1XG4/eZPE8jpaT7erH9VONAd7szz8trCWY9XyyQskHafhwUEEF+Ybc1n0jG0UifrwwvVMpgfDbiTsmyc8mV/gbK2uhekrQ24l4aFTxaTtit7QdAQ5GEYLOViTtgfaZLvD2g6Rx91mxNtewqIS+2c7AbvAKMKaLkoqDLL7kGR1pl6Jd31QRWY5J8MElJh8kTO3hZexaztDOCpid2CdtW56HdBZSr00V7QbC9nuWUFv+UAKPhElZh428fWV2armcY5pwcRehi0HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TMFBLCQj9bibP5BGwW97XcfDOYgWsvKXPcTQLdPh2E=;
 b=V8VmH9VFRqMUq652xaaLECZ8HRmQGFJ5x7fLwnPyVTPkwmalI8lDwsQkkCzvXk2/71oajQN51UCEXUVAOXnUIYk8dyrueohQZf77Ok3RQPzFiQdcLkRtCUbP7nbz6KKLCjHztuvrjVOQkKJD9F+REl6kHG5l8KjolVnj6Av/DJ1u9njloAW+yxBmF5xeWhj61eEMX46xvFztBSHeWP6W1su9IHWxLK4IbSIhLDbw18yk69YvXJQ3X8a2sTaqKzeo0/smL2Ye7BO1TB//yWJi5DoHpMAikOVejSnfzNmuSej9PMUmzzPZln+JajKPEBOeY0y5GJH5aSGjwFDSTkDLuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DM3PPFE9989E69E.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f5a) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.20; Thu, 23 Apr
 2026 15:13:03 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1%6]) with mapi id 15.20.9818.017; Thu, 23 Apr 2026
 15:13:03 +0000
Date: Thu, 23 Apr 2026 10:17:05 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: <alison.schofield@intel.com>, <ira.weiny@intel.com>, <djbw@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Add maintainer info for libnvdimm and DAX
Message-ID: <69ea37f1d2381_a30cb10042@iweiny-mobl.notmuch>
References: <20260423001003.2887295-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260423001003.2887295-1-dave.jiang@intel.com>
X-ClientProxiedBy: MW4PR04CA0146.namprd04.prod.outlook.com
 (2603:10b6:303:84::31) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DM3PPFE9989E69E:EE_
X-MS-Office365-Filtering-Correlation-Id: 91e1c745-82d5-46e8-9dc1-08dea14ad036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: qdTcR77GOr93ijQNAvhpb0qzDMS7H+XBFhDjPJISb0j91/enYou4wMog0t4aqojqXE0WrAGJQ8vH66o61geqZpFou7v+/+ncF0Bw3ROZZZo03Nfq6R5kwjB1E8SAg8kWMlCZe5K3yilIhYRu2t3eusPfWDcmtux7bl4srA73froVOPdwx85sH3DuXCYB5AliBbBE0KxpZ2ydE2MLP4djF9La42qykxEolzsJz+bAlvWbEs8IX7Hi2JAl6GiUAkGk0iFrQVQ8FD9aUzj3s05R6RE1ajpYVSzuYYd+Yr5P1ru1ukr5f1xzK+iHqArRMfdQHeklPAucX5+v6t0qwv9Vo4shzI8Ylb0lKN2w7KOKQhQfbAscJiaEeenzkZyp3xy9TJ97VsjUM3DkCsrZCT0q0C+1Dqk8OglYzPrYrUMx1NFFDAPB9CJ7TIc0m74t8RuwJRxhiFbadwEwdkNqnFOUvTPtEJ0Wj++83CDyuzA0ogfg7gtmPate3+KnWYfwll4TNPoIVqAf1T7hiJFIXZPh5krCE324wPCva6D4g6cseaAgl1KBzW8nfxOk6EZ5gCjY0+Vlb80cPXocoiT2yYKwpRmmiEdZmIufXUwQ7rBGPn9f4kTOK6iNNF0Yj2y9aW1Bzib16sULJ2vJIOu5EgTgNGtzy1d56PqNoWcY9lZAzjq/I8hJjQRluLWgAZW01cAS4qTCk09Cr3zBNByGn+pKUMUy0o1DhZDqkAPXQoz+Joo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ceO60H/CdeI2lE9appz3zSbFRDGNqVXbmgkTjXd6Z6Z9A+4i7ykm9hvPaUUz?=
 =?us-ascii?Q?3aj3o1ya85IYmS9T6xhhqPub5yA5DaQncoS1IBkfnX6tpPZC5n7gA2BTeRL5?=
 =?us-ascii?Q?B2ANKbVA2w3fbHt5fMC5dLWzqw0n66QAHuVNnO3Pkf7IMLsYMQwbG30cuzjL?=
 =?us-ascii?Q?LO9VIm7fIkpU/V0Pn4NWbUlajST5srErYuiqiHJB1F/pBmG1froWdt2keo33?=
 =?us-ascii?Q?MPVvdn4q2R+ifcJ7SwFnZOgn7GqRoaEx/ETgCz0zMm+1PtSMRWCiHfisqaLY?=
 =?us-ascii?Q?NsFZvodGAMI1YAxvkRBqVTuhboYuU++8ViD6WqEuJr/6vN2Fc1twxFf9x2NQ?=
 =?us-ascii?Q?vgVIfbpWz7I3+WlkQf5A/+elo8eD5nVTH/soAMsMyHB8x652/7B2jpPxVvoU?=
 =?us-ascii?Q?QUL6baV8OL/BYWBCOAGAM7en2smj+tpZGRACoMOSWYN0w40XlzVcYu9bgOqS?=
 =?us-ascii?Q?XfK0ESDSvTdQRrKQp4uXawyga43OGxjioZQvdSDCs9CPABy9zj4ItaAiQ3a9?=
 =?us-ascii?Q?giBukRh5dK5/9yQQbHsVjg90+qjiZk4VHzBdeS3kELYrtKs6Thvm90Hax1I4?=
 =?us-ascii?Q?0eQXtyv/lRGMv+r7NQBofSST3OpxTLa1VClIrvBbo+HT3ZPX85OC7QM7wFZD?=
 =?us-ascii?Q?7rWw0HhTazteCpCU6GO2pYjXsHSlfJMmi7r6PrlggW5waAcLXdVV+hdWYHeE?=
 =?us-ascii?Q?VdxckqnvHsn+lWpBLjGMe3QokQUHR+inPN9oifRHkzAn8zw42kClCZrQkywf?=
 =?us-ascii?Q?Jo7LRy5HjK1wS662oXXhel5FfToL9IDJTaUJ5kB7dst9ftjxYcVcJS099NK6?=
 =?us-ascii?Q?q0faANOhLJrkHTrUwZFZNm/eC+eCrF5dG7aqEWL4JKWfMOHiWBwRSBehX52r?=
 =?us-ascii?Q?qOT08vkJBYed+9/SKaLyweVckuUzSvB/MH2clGI9cZmJeSh1emPCCDyxwU/a?=
 =?us-ascii?Q?ivlmaQ9wVB65BbznW2EMOilYBr4JXiJf+hlcpITv0ua1D4fFgwShyXWmn7+T?=
 =?us-ascii?Q?Gut2+J7Ysmb969Fjvxvvyfr5MTMxbLnY3OFDIHtKGcq8Q2T9JVzDd1y0efPq?=
 =?us-ascii?Q?wVsS2Eput0nOuYPzYUvXkyJApGaYgZqNUw9LfkH66ctQk+L2powYXZ/LAzw1?=
 =?us-ascii?Q?+Nym/FILXgZkqQ+0coNCYtHXkT/kcEXNm+4yjIICktVAdD/85Er+aQfdCvFK?=
 =?us-ascii?Q?2z6FvcJSaF0FZRv+gKXorsehp3nmJvrq5+a83Us0rJO8un4csX4B9d2O9eow?=
 =?us-ascii?Q?JvtPORf2Wzd2NcR+1SVkW+OovKYbyXH0AgNQX/HfbGfbDUqDZxmfuyAWflqR?=
 =?us-ascii?Q?Ep9S3pBTpUkyL5hmvs/lo3F/VhAOhjuD3Gw/gC7H+cAn8/WAKX6kfMfM0CY3?=
 =?us-ascii?Q?lFHe031/Vg30Nur8Y7BB9gEc7XVv0QBjk9uUqRycM1vM7SrUf2f8f5jWaIah?=
 =?us-ascii?Q?DHNQpLRQZHjDNJz6avfeeqUH+kXmmRWIdVcZkpBt4kFgZVxCNEgaqNB59nOY?=
 =?us-ascii?Q?bQFMN8ExffUbcqZyn2jol7jOkPu0JNPCzXKoAKp7YQUCMQJTo5prLgsy0Q9P?=
 =?us-ascii?Q?pmsQ/fyexDXCODmqNcrFH7TF4wgxp5erG44bnHETj+f8W8cljhdohj7L2A4g?=
 =?us-ascii?Q?GQ6e2HNRxmbmVVfp66w//aG7RWV94m/VG7dbJcIj6imp13DX/980++zO8+0C?=
 =?us-ascii?Q?dF9ezI4jWS6KjEVbGs24sM8yQmo8zV0PDGcPL8DzeCOaOqJjbABdkuNPPN7a?=
 =?us-ascii?Q?pTSPIFqjGg=3D=3D?=
X-Exchange-RoutingPolicyChecked: E9al+E6SIBWgSXi17vg1C+R3rwqVc/45P4LBrnI5t2takyZaScpoEuRnWfeY/9Unccj39YwEUa+xrxbZz5zPNxrjqbxdgHJwWtjoKwzH1kBWLZZWHmqjCvggH/EjB2QqEB7JCkYjR5PIHQAR3ZxIFIkkSztxL+dQlbkiWJ5A3VCka3qOHa7FSfHGe4iiNd5m6RRK+i52nU5yMpzn2It6luBiMcsnbO03OHil5KFAKrfAgw9ZVLyw4+4AGluRj7+9z+zo3ODW+7FlJr4klYFC5dt6IJQC/rL7w344VXRatn0+yKfOfAaWOBxRo4ty4/R/cMLStmmC9nwhHooHcvc8yA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e1c745-82d5-46e8-9dc1-08dea14ad036
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 15:13:02.9562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wu5llN24a1+72sxIM+lsk44z9NC/8Ef2lqBNLCLW93OnnXjtVYr8QdNjwg1C4hMFTxdmHtjtdWUJrghsD0Q9mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFE9989E69E
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Add Alison Schofield to libnvdimm and DAX maintainer.
> 
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Ira Ira Weiny <ira.weiny@intel.com>
> Cc: Dan Williams <djbw@kernel.org>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Acked-by: Ira Weiny <ira.weiny@intel.com>
