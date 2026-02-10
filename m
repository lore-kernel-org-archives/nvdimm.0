Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A83381709
	for <nvdimm@lists.linux.dev>; Tue, 10 Feb 2026 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770736609; cv=fail; b=DMKGOO0VaoM+/8tjhvKXSPX9xA7EvHMY7SNmfcS7HZQwUMPQ0PeeObliwHivPLG7AFXC1HIXeL+B2YDiKJNgkty+nrdqYmuL8QnSZaU+zJDvSnjg3XW7X5CmqAHGF/8D14IoQd/t7fLisLzXmKn2m0IFFQBGAgkgRbD/gY4fx8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770736609; c=relaxed/simple;
	bh=ZxvVA6YudM26paPicInQv4VGa4GAhIWbAURFIS6cbT0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VEQdWmL/fddRS6bHygBa1Ul8xi1dlzr2C3Oze1CCH9YcP7J8PH80Rhfy1zu2QWDvmmABFef4CiUfmtMibn8kQFqlRvwh0v5QNV9G6ODNLS8u/OTx/hgvNjaV4NrmKdesGYxBeQzZDLD/jZIo11WsUQaSOxVD5rD1PCEkIS/xZ5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IFSA9DSs; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IFSA9DSs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770736607; x=1802272607;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZxvVA6YudM26paPicInQv4VGa4GAhIWbAURFIS6cbT0=;
  b=IFSA9DSsTmzLPOLg5b0ebEJxUUno+wpOJm5/ZZDVqKkr8O7HljF7Ndds
   NnHeWZvK5ZSAydwsq8TGh+yXeXLGQDS9928y9BSdb1XfzwGsBcb53a4mQ
   4rHf4VdyhYHLl1KMSLQLEq2BHexvIxWCKMwwt7LKMTya14wU9w/n9RSWA
   ue1fqi2XYCecMxgq1B0Kq+CoELNtfh+yWeCXUS8rA8yyWLZTUJp/Q1zLh
   ROCZTsl7aBw4o7IPzb4wkmGrhKV+3oerZjlt6RgUixqs7dy8OJAjioBhP
   rgcYiCuGWNPnCNmWgM4e+hFf0QJq4/TC9A2MSDpsg/fksbTyMG6G7XfoD
   w==;
X-CSE-ConnectionGUID: 81BBosPdQ5S9ctT0xLa4WQ==
X-CSE-MsgGUID: Xt33FncDTgyoSFByHb+JSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71760523"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71760523"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 07:16:46 -0800
X-CSE-ConnectionGUID: doGcYXVTTXyAIaz0MfORWg==
X-CSE-MsgGUID: yJcs3LGbQgGZ8V53GWd4sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211587717"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 07:16:46 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 07:16:45 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 07:16:45 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.23)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 07:16:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hSDxg9FoQ5HwhGYdmHR1IkmD4blWbaoB8BE5Gwm47aTYWSGP0imH1ZpDryVDr9EiYPZBgM6Py2Y/yQtPnR+7hPMFdloVRLZSQxv/ubJ3nuvdsameSnMS9Cm2JaHFlDV1FaH2tmSW0PcxaNYJUilTvW6Jqlkz60MgEA5wEHVD/Isbdc8ZaPEO5nIEpb1fuvu2uz0IOnEoE4FxUm0UDaN8bQMOoxy7SlfSSJbXz0Evu/xofMPFo/nnjGDm8BiIl481pEVmyVpkbkBhyeQpSLO8TWUa+6/eDK7wmgNQPM8iuIWjawG1Ikq7+hbo/fJ8M9D1e16VIYPKvHURQ33AStc0HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcTrD1dMfe6mMGVbDNFQg2+SAiSSRiVnTMZJDVrXiWk=;
 b=Qn4u6WfPB2EjHIklrPDE4dWNuZZ//yBkub3KUIKpYUkB3xaK8f4A2GSp8UajsI4Gd3zCkhaxx69Hh8s0jBvznY7MtEzZ0byrVyD+zxxAQwDBRxt1XnGqEY7rq4kz90vm/u/A1UdviZQyQ1W1feKwg8SBuWoZPhJ3TbXrko5BqFAhZ8ZkijLM8aw+3tHTUF7jqyzaqbU7eTNsQlm8zl4hEtl3jol4otmwtLrfx9fGkpjIf33N6uVs2BUnleNGxgbOK6mu3YgVcP/ctC/As8u91Uy0yna9N3/hCZs9B2t96qWDeZrlWuiHkza8U4Ciu2x3dcKFeJooLuZwlFPEbVQmNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by LV2PR11MB6021.namprd11.prod.outlook.com
 (2603:10b6:408:17e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Tue, 10 Feb
 2026 15:16:42 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2%2]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 15:16:42 +0000
Date: Tue, 10 Feb 2026 09:20:07 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, "Joel C. Chang" <joelcchangg@gmail.com>
Subject: Re: [ndctl PATCH 2/2] util/sysfs: add hint for missing root
 privileges on sysfs access
Message-ID: <698b4ca7339e3_c5536100de@iweiny-mobl.notmuch>
References: <b74bfd8623fcfc4cf1078991b22b8c899147f5fb.1768530600.git.alison.schofield@intel.com>
 <4e4ba50b1130c2a76bd2f903aa00644e43faf047.1768530600.git.alison.schofield@intel.com>
 <698a389e5411c_c11ee100d7@iweiny-mobl.notmuch>
 <aYo8eqw73RNN5i9r@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYo8eqw73RNN5i9r@aschofie-mobl2.lan>
X-ClientProxiedBy: SJ0P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::22) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|LV2PR11MB6021:EE_
X-MS-Office365-Filtering-Correlation-Id: e9e1205b-de42-46b4-2a1a-08de68b76574
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Qq/w68GQNRqUE5fwuA9e3EPZzDnzbO5IbWbHlBERAzQGVkdASqS/dj1SFCgz?=
 =?us-ascii?Q?A1cTY5JPgRzp+DlMrtr9aJCY686Jn7GEfvgmmbxDo9xIqdwSOqyEbA1Hfb8h?=
 =?us-ascii?Q?FdipTZZ/3L8lPXk/Mn76mDoPy6CUdHsuiObLOW3ak+mToT1A7Gh42uATiuPj?=
 =?us-ascii?Q?N2uKUJRL7kbuDeh+8le4saBsDP7kSNdIpCy4HiH+Hr/CGK8RZtimIkAVRVNq?=
 =?us-ascii?Q?db2W2c0uRCLaY1haWcplzgz8helwPWwtdaO2Z4HZctnU1E7H7ytGFbss8+Os?=
 =?us-ascii?Q?M6liJtgR7zdWhaEPuL30gFbtbCei6B2YIltccEohxRDbvGU1x8YO5zXrF+m7?=
 =?us-ascii?Q?lp4g+mR14gFw8jlo3t4mb1xsS+qf3T7PvS3yFnfYx+gi74Q2B6p2tGrc7qlB?=
 =?us-ascii?Q?HVsZM9cSLaV5p9uTXxEdi1t3ZeJgBiCaK9vU2aheKxlCeBPjk5bbhvl/UUFb?=
 =?us-ascii?Q?5Tb0LmQTMP6rd/NFu44FWd0DgMJxC270Wc+te+2JMfJz4jZUByJGy/7l5k6W?=
 =?us-ascii?Q?7P+GxV2DKjP8jUZG/wExC35g76N3Pr0aOSqSGOLkIo6ZjRL562AhBgnxbkps?=
 =?us-ascii?Q?Zjlq3Amx+rIEfyfm89mhElVGLr1mop9Q6tz16+B62OrbxDIGa4Zamwekcvz4?=
 =?us-ascii?Q?eT5Wb1g5Io3+Fb9WG4jLOwKah2zC7zNLyvuhhFesa08twGdYGUlM7gRIu6Vn?=
 =?us-ascii?Q?W8UVuzIKMuuwPTyeXwR3L/KBP1D/9qeSNs1Jv7DxX3fkv2baj0vTorLKWKlp?=
 =?us-ascii?Q?et1qo6svUpA7QJ7AfXxfBuiSDYEGvy/YTYffHa/L0N0+aPmuIFQzfsOVT28b?=
 =?us-ascii?Q?6sDmRP3Gzq3B8ipEktAv3R2nlVtICEuLCcMCyQ6pcu4+rQoKhEIue+5nqSnd?=
 =?us-ascii?Q?B9UUnv+ytTw5r8VE80zCPZ1UUlf797MnvBMFg7LSnyUHS1Isq5/+0UKIB3LG?=
 =?us-ascii?Q?KP2NkSPTxtCGiBxpqdPEMDiyRCI+NhozKFZ91Ys5VEmmNbblxvVQJbecf/l/?=
 =?us-ascii?Q?uuW+IHIURJCdJhcKvMq0j5M+irRSAM508Un/lqWCmAAWfNpdvgRE75HseUmm?=
 =?us-ascii?Q?VQV+zJX+wioe1RMGvSV17JKxTmEU2B+n/omyBEGaTgU6Q5PLnBfdAvNksJvj?=
 =?us-ascii?Q?OsqS/I1rJYVbXLjBJeowITSjguUdS6BF9FmpgzJoXnY2rcp+H8GQmejK0n48?=
 =?us-ascii?Q?eAwyGROYWbZSZsFK65fjMibuZpL5qRY8syRfwprHKLCUcBf2nlz/mwhfVMNr?=
 =?us-ascii?Q?0KdAOOWuZiRsIkBdyLAgsunT9kfoOETnNp2KhcqW4I5ayJOpS+ObZ4fiJSD3?=
 =?us-ascii?Q?hlVTX8BLgkaGAZgDOCfHZSwWXd35hkSi7LneLmQOH4bFlZUu+OfgFcD8+y3O?=
 =?us-ascii?Q?nOpYPSY0bIj0YCrI0baBxlNZowTOYN4o0EtRd4Bw0gNMcJf6tlguLTK4T5eZ?=
 =?us-ascii?Q?AvfyfEy57qAR9bgZ1NsGYO1ZSFkeBHZr6CLL2QENGhUezuhWZHBJ/B52S52S?=
 =?us-ascii?Q?LkCRmpyGHuuU688Z904qIg6dDDtCcY68h2zW7lVj4y8y7nQgLQPDQ4Dr73dm?=
 =?us-ascii?Q?snUDvStsB4f+HXiw50E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wUiSyIVe/DfJiHMF2kW49CnjcbQwTNdxW2cSD8R6CwmhjuCnagNwYcnwGP00?=
 =?us-ascii?Q?7kPfM3LgHYZAEhDi4kHXQ70Y9Hp3gOtC6ll5/I5jwtxTkJsaRfszUXfoWkJ+?=
 =?us-ascii?Q?YkhFNB9CP48GJh2aQSV+BA5bEVvN4yyVWQGBWXNPuTiVcrzJvwPBHjTVrGd3?=
 =?us-ascii?Q?u/TAm3Uvjpm1SAg5A4JcqkUIQmWKo41Lzv186uAdnfW/pYAf5p1tfMs0QXmq?=
 =?us-ascii?Q?E5XwHMDTMq+igDSoDjmrzCAJ/oq1YX9xSSO8SkRkDfGKa7fj3z8ab6uHsw8W?=
 =?us-ascii?Q?WZg95/gk9RCJOZTPvN1UOxBKYtrJdNxLjJULJ4rpw1aVcAXS3Fzr65ClpIQZ?=
 =?us-ascii?Q?qHJ5IBuiuY/OCbdjQNggSBzuTJfJsDnsU2t398l5er6F5rjyLnilNMVho2zr?=
 =?us-ascii?Q?NjPnZuvbYTlnaJ/mbRKOQZL5bG0WtubI+jeieIvLKJ4XXLXahH2Sfr1/VoB4?=
 =?us-ascii?Q?iHyAeJ/URNzH/6AGko7gKSSxLG7X+W0cY2NEXyfxrVAYv6Cadiwh3PgAiSBb?=
 =?us-ascii?Q?VZouEy8lEUvA5+aTz34XbTtPzNeDYwGNpl289SkCy2ueXkND5tTX/lL3WTJT?=
 =?us-ascii?Q?8UkYJBTPi4YU3PdhoMJr0uztviTXJ0wQatHnGU8HDYarFsKoqQjSNXjcc48O?=
 =?us-ascii?Q?haVYQr3iu+/ESKm6RnDNWKQuFnhSekJ1hEQVKPZvNwYXGsFERIyVjVoDb4J5?=
 =?us-ascii?Q?43ojEQr+zCzbo3ZnL3URWcs1JBPSzTR+jBuq2p8Te/TO1T3cja4g2Fwdo2A5?=
 =?us-ascii?Q?EAM18BcScVt1QO7xF1wZhcpAuYDHZN9HYsr+q37I4rsZ5gk/1R60nngwgm1m?=
 =?us-ascii?Q?Pv0FYvgNo2NlmGGPoBbi3p7W3lLjYZXKKfT1csmHsb82+OhWCpRs/Agn8gSD?=
 =?us-ascii?Q?qCeosnS0sM9zDuZbKOaHsHVKOlnSphx4FpeGu74CRu7h0PVZ3jnpiD/D6Zd0?=
 =?us-ascii?Q?ku1gLa9riF2g50qAN3fPkm4jSpwb6Sh8GeVDpFI21XbPUvrR/r77sT6DZb+p?=
 =?us-ascii?Q?rWmauRgYH7EqZuRvEqCsAjBse66FuODx5KT0N3t9syFUpxLsyqrDd8Bd4Cuk?=
 =?us-ascii?Q?uONSjqRfgpfcoKPJYRSBYJZ2QH8RHaSl4YCLEOZP8OaAqdxVoTdbjYNaLW/0?=
 =?us-ascii?Q?Z6vtXA5S7a/R0Nt6ljJNN4RWyED7NdfPXh4nYq//2A00VrA+hhkcNOegT/9i?=
 =?us-ascii?Q?/6LocYFL2ZxHOKzT3XH9Gs095EeKpWR4GJsYpclhiZHuO8zzdrFUsOrgw1RG?=
 =?us-ascii?Q?Tb2JdJ1fjmOxo7sBEgC2RK2kMpfUZ1RJESeoxmcIbrYn6HXzq8nL4Mj1WpIG?=
 =?us-ascii?Q?o+wQJ0rMdsofT6ZvSLl3yZMkvs8DkZ3nWn+GoVRRzsbPJxg8qF+NRVFvjScf?=
 =?us-ascii?Q?fLPdAkSyj6f8P0bIQcPqm1vZvkeOVZdN9ijMDRFrFr//q7Y5bABLcHr1wZm7?=
 =?us-ascii?Q?P2kznYjw0P5xVLCPRjA+JgwWMeha9MnBvCiyCuBItMxBkFMPMUPnGboOZhav?=
 =?us-ascii?Q?i0Gg6xHX70FlvwSz/sJND7/2hrYfswD649Qwpk1nXar34DhAG7TfPZRlf2AI?=
 =?us-ascii?Q?m93qSqln6VWAwzhp+wJ4UpwZwm7PxQIjB+O9bV8xfoC+pFG5RLFc0ijNgfKP?=
 =?us-ascii?Q?wRi8E8OIBxxfWGlS9/NIcl4TbbjDUDRZxxWjkwjjZfKEy/DxETpsfkWSh3o2?=
 =?us-ascii?Q?U5C7SI0uZiVhSlhu1fvW7VLclzM+XVm/cYpXQtMW6ilYfJxtAGuLsDkQ0wym?=
 =?us-ascii?Q?k1XWeoXuCA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9e1205b-de42-46b4-2a1a-08de68b76574
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 15:16:42.5350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KcpFC6j0QSj6JcbrE2lDKFLTCZal1qDB78Y4IlPU+tWFNezngGZVd5C+LyUUwUpOCXHG2+w8NdnJ5k5QAuAR+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6021
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Mon, Feb 09, 2026 at 01:42:22PM -0600, Ira Weiny wrote:
> > Alison Schofield wrote:
> > > A user reports that when running daxctl they do not get a hint to
> > > use sudo or root when an action fails. They provided this example:
> > > 
> > > 	libdaxctl: daxctl_dev_disable: dax0.0: failed to disable
> > > 	dax0.0: disable failed: Device or resource busy
> > > 	error reconfiguring devices: Device or resource busy
> > 
> > If the error returned is EACCES or EPERM why is strerror() printing the
> > string for EBUSY?
> > 
> > This does not make sense.
> 
> That's what patch 1/2 is fixing.
> 
> Before patch 1/2, errno was used after close() which could modify errno.
> The EACCES/EPERM was overwritten and the return error appears as EBUSY.  
> 
> Now, patch 1/2 preserves the errno so the real failure is reported, and
> patch 2/2 adds a helpful hint when that preserved errno is a privilege
> issue.
> 
> Better?

Ah, yes much better.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
