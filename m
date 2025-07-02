Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30BF30AAD2
	for <nvdimm@lists.linux.dev>; Wed,  2 Jul 2025 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751478890; cv=fail; b=t+eFiomLhu2bhY4kNyn/wS66jCkbqRgLXr2JOt+ek0WHtdFgdra2bK8TbjPxoU2JrKpCDHv5YrOH1Equzi3SkhfzvLryPKPIxnOYdYFMElKeCP/WFPDV+mF89+K9MtfP9P01x9iYofrCplJoGYwjw7X0/m3Y+y1RDNPH4PykEeU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751478890; c=relaxed/simple;
	bh=1r4DVIqG99D3aGyjIaYDRtCHOnZtipTlYE2ZLGbTSqA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JU4AcQInEs2MlclTFmCLoRHE1zFRYLCaQeaEGZdMSBA55uykRg+6BVw5yljRzgRjwoKujwAMCVbAcx2tkUP5cIObzznRxw8fv6JK+IcWlkdeAPq+0d9K5z4XF2Q6lHKPVgnzujpDKC22nFyemXWK+/k6BQyujOHPyO34ol9oFSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NgCaIMMj; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NgCaIMMj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751478887; x=1783014887;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1r4DVIqG99D3aGyjIaYDRtCHOnZtipTlYE2ZLGbTSqA=;
  b=NgCaIMMjmvwu4dtc1liZwm0dYg1m6Q520o3Om8Y9ibg8wwCi/DVqJnEs
   LSL+dFRXjRnLAM7o6KSBcLKsMdakMrGl6rMZ0A4W5KQWV885lpgTO0y55
   SARTPVg32N9/2eBAzmdbspoIBfsvdGTf2OWMBlBGEQFvr2RWUk7v5YMyM
   co67Nb7FgK3FSXNUjBQMwsJN5/aFjV9XdZ2+Lf4P8K6Aij3Zq4TPOZ/1Q
   N6gj5SsqWC6VDVvBfUcFnpuKEimaL+n8a1DyNXamR7ZDzbKGRQgNgMZp2
   lv0T7WHlQQPP5CwtMQ7xuYrybSOruhQphXjh51qBEFDlK+zI1ltdPaOPO
   A==;
X-CSE-ConnectionGUID: cEA+SKwpRI2k5hAxj+SpIw==
X-CSE-MsgGUID: V+NiBFHBQTmE/jRqGVKKoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="76336379"
X-IronPort-AV: E=Sophos;i="6.16,282,1744095600"; 
   d="scan'208";a="76336379"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 10:54:47 -0700
X-CSE-ConnectionGUID: LE8CSnK3Q3qrsuAizUD5ZA==
X-CSE-MsgGUID: kwR2MUcjQrmoSbuD0P0mkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,282,1744095600"; 
   d="scan'208";a="154706731"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 10:54:47 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 10:54:46 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 10:54:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.54) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 10:54:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FbGuZOLHAp/VBHN3QIneekHfH4R99ejGADNjDmKgPKfeHyR1R63UuuJdVBNVAAAfLZAj/zzkdqkphUGjOclH07lHZritV5MRhzpEWP3vTiiJf9oTuLJXJAyrWJ28d5odsX7d9JS6jBPL87aL5urTedUpZDpiPceuIrD+t4fZl25XyI1qvSUwsrbH3ZWsRBzLPdQfzP+Nv0kGmv3iIqRkc9HwDjwtFRmddWJayRyObz2jS0kTTIvaeHxezuZNF7Wsy/jfSNkvmAZe4iZm2YN92HjQnhuv+o08nwxrSPOQ06oBiITsaLDIQRyX2mzsf2cA9Jqm56YaYIHWxJ28mX+JTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tk1SMIYEA4qHiyR753ZK0CvH4gpz9it7Hz5q+UAUnMM=;
 b=SKlazOtWKe4EuQzrbe66biEXMpvCqF4qFHf6sdaJLvcqFoq1uufFkyhFgeTB1XBYhZ+57M20590Lv6I++NuGIP9mhYPaU6BCWATmYTGvsxV9fHZSNxfk2ADBxet70rGKlk2m4egHrUXdlm/LM6F3XmoFIth9or4ENwQgMOnina2SDJgCbBjBx7fnz5VFwDQIzgc+UfoJNfkMazNN+8fmx0BAOzD2iv5vzl6RfhcfB8O+Pf2Fet5b9x1kafKIsWDNNsd6QZYNGzVAyQWZlJhEjDcS2YSxxv5+5koor6bU7EYXvo7Wb4fta/WdlO1O86NHl1PtF27ZMx4OV5rTWzgpEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CH3PR11MB7913.namprd11.prod.outlook.com
 (2603:10b6:610:12e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Wed, 2 Jul
 2025 17:53:58 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%4]) with mapi id 15.20.8835.018; Wed, 2 Jul 2025
 17:53:58 +0000
Date: Wed, 2 Jul 2025 12:55:23 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <dan.j.williams@intel.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>
CC: <a.manzanares@samsung.com>, <nifan.cxl@gmail.com>, <anisa.su@samsung.com>,
	<vishak.g@samsung.com>, <krish.reddy@samsung.com>, <arun.george@samsung.com>,
	<alok.rathore@samsung.com>, <s.neeraj@samsung.com>,
	<neeraj.kernel@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<gost.dev@samsung.com>, <cpgs@samsung.com>
Subject: Re: [RFC PATCH 02/20] nvdimm/label: Prep patch to accommodate cxl
 lsa 2.1 support
Message-ID: <6865728b489a7_30f2b72947b@iweiny-mobl.notmuch>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
 <CGME20250617124011epcas5p2264e30ec58977907f80d311083265641@epcas5p2.samsung.com>
 <700072760.81750165203833.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <700072760.81750165203833.JavaMail.epsvc@epcpadp1new>
X-ClientProxiedBy: MW4P223CA0002.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::7) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CH3PR11MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: 6672eb5e-28ee-4310-27b3-08ddb9916b4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lntsNjvtkw8MqT9NvCX++wSK1TJ2xeZ1wfdlpviNwLn42wtLUSFvGrRmDTT+?=
 =?us-ascii?Q?5jOAuep9ftWYDGF2a0zfc68hNMAcHmPn5L3BBHjU+d1VrysKAnCnfppyXR8Q?=
 =?us-ascii?Q?sQCgVoF8AlvIqXDoGixS8sWTdN0jS1l6frOXQBslAbVGDzwUwNoAk4/Yi9VH?=
 =?us-ascii?Q?ZzcavYFaQ5Ntf87l7icTpLycCl+r6Sq7eTUYi9aTgL0tOrE4fm9TpYXef2P3?=
 =?us-ascii?Q?6Mj8Oqk9cmUc0WQSoLr521fuJ1hR1yeKfChE4Dcrfp6JcNItYxSeLbCzvKkl?=
 =?us-ascii?Q?kWwHVuFxo4JvekLIIJC1NAz/tYIs+gnlWd7H6Qzi7TTixpofc8RtK0gX9yCe?=
 =?us-ascii?Q?UUdvQrH6zhm1Brzi9pBrDJZKm/Y4JqmzorC3JQyHgbStf4Y+b6/HT8GJKvqu?=
 =?us-ascii?Q?4uPBEa3iulbw/IEkibXFKTMceXXIgsbSPobe8fgj8rVaqLe6EoLjnkKt95uI?=
 =?us-ascii?Q?2rDzyyrVoivD+5Oh6U/yD+wOcFuWDDQF7SA1KvVkhkOj2hYhm9AyoHdXvEBD?=
 =?us-ascii?Q?FHMvTwSknE+hZ9wUGR4nbrbw0Xi2zyecrkpN4JIv4trkwMjn1OtzSu6tgwHq?=
 =?us-ascii?Q?YDDsWKCFqxotqrlsWRyXF/fkD2PTMW/bIyUTLCGlLt74LnvmuvToHfpDvmWX?=
 =?us-ascii?Q?gs5osQ1JenR/Q/MUG6+iCEI/VIcbRL/giJNQftq4BzhoqurV06HV5lLkxjoy?=
 =?us-ascii?Q?KMteU7VH9JnogXKA0MbT9LAhAFj6kGVnkWnodN7PVcMG8SBNwvB/oA5734Wa?=
 =?us-ascii?Q?NgwMjl9cp/CCkVd2mDeP5XZxMHFUFs+QvF2GhLAv1sG3aPrmdTIpKDZpnTDc?=
 =?us-ascii?Q?CRr1HPLHMYBTCWfgH69Tahkf6A0BBIX/hnqr4I+FLmdpmXuNYITk+fVCDqYj?=
 =?us-ascii?Q?Pvt7vuic/B98Lc0RZaX4aDCPytSEUQCulcZZ0NSAqnbcpjUnGkQGhma66RK7?=
 =?us-ascii?Q?FVUSOkf2W3m2CSbIYUCWOQkjlQMLPmRAMSnd6c4X4TEaogoJqEazUH+R1u/r?=
 =?us-ascii?Q?ztYWX2cYeslGpRynt2aM5DXZhZuPRonLiwCaYD+0f08azIYWc0zfTATA8AA8?=
 =?us-ascii?Q?2B7WNBn5170xi+T6sQDNXaZtN7KnR3QvjHq4bWsD4QRPHa+zxfk3Em5eHAPb?=
 =?us-ascii?Q?MfUhhgk7GV7GmiQAAMyMKegHZ0vGhbz4Em+ngxZr5a5oYtAHVKeOW32zRufE?=
 =?us-ascii?Q?MmhBobSM6/Qu/srImJyUD2xKqsJQKJdlCHHe+De3xPx9vIWkKPuOeUNPmWnc?=
 =?us-ascii?Q?6ibAPIerxFrR3pgFnPnC4E0dEWV1TguyyVKLgcPOYdET021DWNO0yVz/QJ1s?=
 =?us-ascii?Q?gc/N/oXymK5n5GXsIEfDsKI/n/Pccjd4ISz+UVAceKE9hqxohMBFeSixzoOG?=
 =?us-ascii?Q?BkqESHxTEXdNx2njqfnwxg5ljkUK4wovhLO26HkGp1e0tGkB47rUshc2SXje?=
 =?us-ascii?Q?LrmOSfVuAwc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0/l0PABsLRPZubXqRmgdnbwRx7HCi4wWcRHr/g4Rf/JhpKh1mb9Q2YgktQVP?=
 =?us-ascii?Q?IcYP/iX0cA5S3WumNvRiEapNduquh3VZOu+11f2UQCoY3j+teAj9aQtm9sM3?=
 =?us-ascii?Q?MWh6dvZxzkLPCO98Q5+79q/onFkRIxiaQkXyaLto3eo+yWjHQHdpCEJNz03a?=
 =?us-ascii?Q?ETW44ywci2VDlWQwNpxiU+nVRE63RPWjgyqoHk5LVNz/phaAYrQzQdTNRpnK?=
 =?us-ascii?Q?WXVSvpCU0uX+AtYGTCjBvGORsoGgrOiboS2QorYh9nwp8h63QvcGMP2BlAwP?=
 =?us-ascii?Q?SSdczL65BT/KcV4xIPKrDOJaB54WAO87pjHsNH1bvyoYwCRLmqADLOCUf+qB?=
 =?us-ascii?Q?S4LewhiKmgpgdjOIcefH/NAS75GUJN0nCBSjDd/x2a8xSvXzgTJXoCqXOE+A?=
 =?us-ascii?Q?nzNmls0K7cPBRSw2LVbtMm6zi3HdJbmb5qkIsKdUAYHefU0zHsJD0IUHt7CH?=
 =?us-ascii?Q?AQ5IaaLMQ1kT0V2MITfj+IxHpKT4lrcEc/yMl+JtLd0COcH6T0SKmjSrzu9j?=
 =?us-ascii?Q?5vx0bjdgTSn+eXy6qppb1v2jg36gmcz3QR5N/HKuo/7tlr8fZY2NauGxj3Yb?=
 =?us-ascii?Q?pmONAT/X040rh/4BN5Mh2g6hQljtEMi9Mw52aZoq/SP2rpN+VnvI+/jv/3r6?=
 =?us-ascii?Q?O/ChpS7gp4bEgVCu1OfiBGRd1znO6IDZzVpHF9i1DQ/QCf4oI0FEH6rey28l?=
 =?us-ascii?Q?FLJh/h5Wxocq5iXxQGyvoUOUgqugna9kQ/SpM9JwtLakoPxItospd3wmOZwk?=
 =?us-ascii?Q?6i/pWo8V0cqJA60GB8KJk65aTDi0mmCh4H6XCuGwefvkTGgjSIgQD0nebVBX?=
 =?us-ascii?Q?66qOZldQiaVy6muSJkBBMZbvzE8owgljN07FTa4lBdbJowFa851/IKIhJ9ni?=
 =?us-ascii?Q?Vx2rv7f/kyCVnzwyOpHc5VQt8flHpQqH4GOUDbk7/rSD20uglz8p1ltENsf2?=
 =?us-ascii?Q?7sdPjp0pMeVvwnMMsk8tipfREs7XA/rAW15VrFfhYVmZsoBPGbCW9pwZaOOt?=
 =?us-ascii?Q?nNPHVevFiKoSOdZdsBCX5FiTWh5/FvNbrZKOS9rXWLpOPAvG4z01o8dF/Ooi?=
 =?us-ascii?Q?JVeOshdheg1hBPVtt3jtP46ox/2DC4lxjxUcj+xYajGhfF5qbFsZLCZMNFLX?=
 =?us-ascii?Q?5Q9QWbg050gPErJtEyMLZJAc82xNAh0eNobdNsbOoWWqpQWF59TK+/D33g8y?=
 =?us-ascii?Q?B7Wgb4rwwN5y8XarTGxbMyA8E5vHPefXgUFIA/TUSVQy18COisR1BHB86190?=
 =?us-ascii?Q?FkYVyY6boK/RZO36mYSecvWCm/FgjowUwJlLf4RSN9jhpAppaRZfZYHdX/h3?=
 =?us-ascii?Q?byBsQDUeitw4dNvKDnPDNxzhKsvfalIvcsjMywqjMIa1yzYm2ft1vKumy7aP?=
 =?us-ascii?Q?PF59eiRyt+V+XdU3i40eJVKlcpNbZOdgBVyQw4v4XgSKvpuwv6RJ5FdANRdX?=
 =?us-ascii?Q?rfs+Sm4EkMhDVzQOyp7k1UCT65TjQCO+cQPacc4+mLKivW3VMp/IIZeDHtXU?=
 =?us-ascii?Q?TwRIbnU9DnFGwe78h/twbz3snW+jvcyr76FjIqG0vkrH9UIARnaR6aDfrv7f?=
 =?us-ascii?Q?X6kFBs7wnu4+Evh/55amM8Smgu62zQKBCqWpZ3jy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6672eb5e-28ee-4310-27b3-08ddb9916b4f
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 17:53:58.0191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/28zAUc8wtNURwZ1e4PfNYnkNFXyPUkfJZoGNpBiMax9fVLadS3HuW8f7raldBuH+HzHoS2+izbNtzQ3IFhdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7913
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> In order to accommodate cxl lsa 2.1 format region label, renamed
> nd_namespace_label to nd_lsa_label.

This does not really make it clear why a name change is required.

Could you elaborate here?
Ira

> 
> No functional change introduced.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c          | 79 ++++++++++++++++++---------------
>  drivers/nvdimm/label.h          | 12 ++++-
>  drivers/nvdimm/namespace_devs.c | 74 +++++++++++++++---------------
>  drivers/nvdimm/nd.h             |  2 +-
>  4 files changed, 92 insertions(+), 75 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 48b5ba90216d..30bccad98939 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -271,7 +271,7 @@ static void nd_label_copy(struct nvdimm_drvdata *ndd,
>  	memcpy(dst, src, sizeof_namespace_index(ndd));
>  }
>  
> -static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
> +static struct nd_lsa_label *nd_label_base(struct nvdimm_drvdata *ndd)
>  {
>  	void *base = to_namespace_index(ndd, 0);
>  
> @@ -279,7 +279,7 @@ static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
>  }
>  
>  static int to_slot(struct nvdimm_drvdata *ndd,
> -		struct nd_namespace_label *nd_label)
> +		struct nd_lsa_label *nd_label)
>  {
>  	unsigned long label, base;
>  
> @@ -289,14 +289,14 @@ static int to_slot(struct nvdimm_drvdata *ndd,
>  	return (label - base) / sizeof_namespace_label(ndd);
>  }
>  
> -static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
> +static struct nd_lsa_label *to_label(struct nvdimm_drvdata *ndd, int slot)
>  {
>  	unsigned long label, base;
>  
>  	base = (unsigned long) nd_label_base(ndd);
>  	label = base + sizeof_namespace_label(ndd) * slot;
>  
> -	return (struct nd_namespace_label *) label;
> +	return (struct nd_lsa_label *) label;
>  }
>  
>  #define for_each_clear_bit_le(bit, addr, size) \
> @@ -382,14 +382,14 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
>  }
>  
>  static bool slot_valid(struct nvdimm_drvdata *ndd,
> -		struct nd_namespace_label *nd_label, u32 slot)
> +		struct nd_lsa_label *nd_label, u32 slot)
>  {
>  	bool valid;
>  
>  	/* check that we are written where we expect to be written */
> -	if (slot != nsl_get_slot(ndd, nd_label))
> +	if (slot != nsl_get_slot(ndd, &nd_label->ns_label))
>  		return false;
> -	valid = nsl_validate_checksum(ndd, nd_label);
> +	valid = nsl_validate_checksum(ndd, &nd_label->ns_label);
>  	if (!valid)
>  		dev_dbg(ndd->dev, "fail checksum. slot: %d\n", slot);
>  	return valid;
> @@ -405,7 +405,8 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  		return 0; /* no label, nothing to reserve */
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> -		struct nd_namespace_label *nd_label;
> +		struct nd_lsa_label *nd_label;
> +		struct nd_namespace_label *ns_label;
>  		struct nd_region *nd_region = NULL;
>  		struct nd_label_id label_id;
>  		struct resource *res;
> @@ -413,16 +414,17 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  		u32 flags;
>  
>  		nd_label = to_label(ndd, slot);
> +		ns_label = &nd_label->ns_label;
>  
>  		if (!slot_valid(ndd, nd_label, slot))
>  			continue;
>  
> -		nsl_get_uuid(ndd, nd_label, &label_uuid);
> -		flags = nsl_get_flags(ndd, nd_label);
> +		nsl_get_uuid(ndd, ns_label, &label_uuid);
> +		flags = nsl_get_flags(ndd, ns_label);
>  		nd_label_gen_id(&label_id, &label_uuid, flags);
>  		res = nvdimm_allocate_dpa(ndd, &label_id,
> -					  nsl_get_dpa(ndd, nd_label),
> -					  nsl_get_rawsize(ndd, nd_label));
> +					  nsl_get_dpa(ndd, ns_label),
> +					  nsl_get_rawsize(ndd, ns_label));
>  		nd_dbg_dpa(nd_region, ndd, res, "reserve\n");
>  		if (!res)
>  			return -EBUSY;
> @@ -564,14 +566,14 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
>  		return 0;
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> -		struct nd_namespace_label *nd_label;
> +		struct nd_lsa_label *nd_label;
>  
>  		nd_label = to_label(ndd, slot);
>  
>  		if (!slot_valid(ndd, nd_label, slot)) {
> -			u32 label_slot = nsl_get_slot(ndd, nd_label);
> -			u64 size = nsl_get_rawsize(ndd, nd_label);
> -			u64 dpa = nsl_get_dpa(ndd, nd_label);
> +			u32 label_slot = nsl_get_slot(ndd, &nd_label->ns_label);
> +			u64 size = nsl_get_rawsize(ndd, &nd_label->ns_label);
> +			u64 dpa = nsl_get_dpa(ndd, &nd_label->ns_label);
>  
>  			dev_dbg(ndd->dev,
>  				"slot%d invalid slot: %d dpa: %llx size: %llx\n",
> @@ -583,7 +585,7 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
>  	return count;
>  }
>  
> -struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
> +struct nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
>  {
>  	struct nd_namespace_index *nsindex;
>  	unsigned long *free;
> @@ -593,7 +595,7 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
>  		return NULL;
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> -		struct nd_namespace_label *nd_label;
> +		struct nd_lsa_label *nd_label;
>  
>  		nd_label = to_label(ndd, slot);
>  		if (!slot_valid(ndd, nd_label, slot))
> @@ -731,7 +733,7 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>  }
>  
>  static unsigned long nd_label_offset(struct nvdimm_drvdata *ndd,
> -		struct nd_namespace_label *nd_label)
> +		struct nd_lsa_label *nd_label)
>  {
>  	return (unsigned long) nd_label
>  		- (unsigned long) to_namespace_index(ndd, 0);
> @@ -885,7 +887,8 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	struct nd_namespace_common *ndns = &nspm->nsio.common;
>  	struct nd_interleave_set *nd_set = nd_region->nd_set;
>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> -	struct nd_namespace_label *nd_label;
> +	struct nd_lsa_label *nd_label;
> +	struct nd_namespace_label *ns_label;
>  	struct nd_namespace_index *nsindex;
>  	struct nd_label_ent *label_ent;
>  	struct nd_label_id label_id;
> @@ -918,20 +921,22 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  
>  	nd_label = to_label(ndd, slot);
>  	memset(nd_label, 0, sizeof_namespace_label(ndd));
> -	nsl_set_uuid(ndd, nd_label, nspm->uuid);
> -	nsl_set_name(ndd, nd_label, nspm->alt_name);
> -	nsl_set_flags(ndd, nd_label, flags);
> -	nsl_set_nlabel(ndd, nd_label, nd_region->ndr_mappings);
> -	nsl_set_nrange(ndd, nd_label, 1);
> -	nsl_set_position(ndd, nd_label, pos);
> -	nsl_set_isetcookie(ndd, nd_label, cookie);
> -	nsl_set_rawsize(ndd, nd_label, resource_size(res));
> -	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
> -	nsl_set_dpa(ndd, nd_label, res->start);
> -	nsl_set_slot(ndd, nd_label, slot);
> -	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
> -	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
> -	nsl_calculate_checksum(ndd, nd_label);
> +
> +	ns_label = &nd_label->ns_label;
> +	nsl_set_uuid(ndd, ns_label, nspm->uuid);
> +	nsl_set_name(ndd, ns_label, nspm->alt_name);
> +	nsl_set_flags(ndd, ns_label, flags);
> +	nsl_set_nlabel(ndd, ns_label, nd_region->ndr_mappings);
> +	nsl_set_nrange(ndd, ns_label, 1);
> +	nsl_set_position(ndd, ns_label, pos);
> +	nsl_set_isetcookie(ndd, ns_label, cookie);
> +	nsl_set_rawsize(ndd, ns_label, resource_size(res));
> +	nsl_set_lbasize(ndd, ns_label, nspm->lbasize);
> +	nsl_set_dpa(ndd, ns_label, res->start);
> +	nsl_set_slot(ndd, ns_label, slot);
> +	nsl_set_type_guid(ndd, ns_label, &nd_set->type_guid);
> +	nsl_set_claim_class(ndd, ns_label, ndns->claim_class);
> +	nsl_calculate_checksum(ndd, ns_label);
>  	nd_dbg_dpa(nd_region, ndd, res, "\n");
>  
>  	/* update label */
> @@ -947,7 +952,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  		if (!label_ent->label)
>  			continue;
>  		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags) ||
> -		    nsl_uuid_equal(ndd, label_ent->label, nspm->uuid))
> +		    nsl_uuid_equal(ndd, &label_ent->label->ns_label, nspm->uuid))
>  			reap_victim(nd_mapping, label_ent);
>  	}
>  
> @@ -1035,12 +1040,12 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  
>  	mutex_lock(&nd_mapping->lock);
>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
> -		struct nd_namespace_label *nd_label = label_ent->label;
> +		struct nd_lsa_label *nd_label = label_ent->label;
>  
>  		if (!nd_label)
>  			continue;
>  		active++;
> -		if (!nsl_uuid_equal(ndd, nd_label, uuid))
> +		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>  			continue;
>  		active--;
>  		slot = to_slot(ndd, nd_label);
> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
> index 0650fb4b9821..4883b3a1320f 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -183,6 +183,16 @@ struct nd_namespace_label {
>  	};
>  };
>  
> +/*
> + * LSA 2.1 format introduces region label, which can also reside
> + * into LSA along with only namespace label as per v1.1 and v1.2
> + */
> +struct nd_lsa_label {
> +	union {
> +		struct nd_namespace_label ns_label;
> +	};
> +};
> +
>  #define NVDIMM_BTT_GUID "8aed63a2-29a2-4c66-8b12-f05d15d3922a"
>  #define NVDIMM_BTT2_GUID "18633bfc-1735-4217-8ac9-17239282d3f8"
>  #define NVDIMM_PFN_GUID "266400ba-fb9f-4677-bcb0-968f11d0d225"
> @@ -215,7 +225,7 @@ struct nvdimm_drvdata;
>  int nd_label_data_init(struct nvdimm_drvdata *ndd);
>  size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd);
>  int nd_label_active_count(struct nvdimm_drvdata *ndd);
> -struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
> +struct nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
>  u32 nd_label_alloc_slot(struct nvdimm_drvdata *ndd);
>  bool nd_label_free_slot(struct nvdimm_drvdata *ndd, u32 slot);
>  u32 nd_label_nfree(struct nvdimm_drvdata *ndd);
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 55cfbf1e0a95..f180f0068c15 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1009,15 +1009,15 @@ static int namespace_update_uuid(struct nd_region *nd_region,
>  
>  		mutex_lock(&nd_mapping->lock);
>  		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> -			struct nd_namespace_label *nd_label = label_ent->label;
> +			struct nd_lsa_label *nd_label = label_ent->label;
>  			struct nd_label_id label_id;
>  			uuid_t uuid;
>  
>  			if (!nd_label)
>  				continue;
> -			nsl_get_uuid(ndd, nd_label, &uuid);
> +			nsl_get_uuid(ndd, &nd_label->ns_label, &uuid);
>  			nd_label_gen_id(&label_id, &uuid,
> -					nsl_get_flags(ndd, nd_label));
> +					nsl_get_flags(ndd, &nd_label->ns_label));
>  			if (strcmp(old_label_id.id, label_id.id) == 0)
>  				set_bit(ND_LABEL_REAP, &label_ent->flags);
>  		}
> @@ -1562,7 +1562,7 @@ static struct device **create_namespace_io(struct nd_region *nd_region)
>  static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
>  			    u64 cookie, u16 pos)
>  {
> -	struct nd_namespace_label *found = NULL;
> +	struct nd_lsa_label *found = NULL;
>  	int i;
>  
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
> @@ -1573,20 +1573,21 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
>  		bool found_uuid = false;
>  
>  		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> -			struct nd_namespace_label *nd_label = label_ent->label;
> +			struct nd_lsa_label *nd_label = label_ent->label;
>  			u16 position;
>  
>  			if (!nd_label)
>  				continue;
> -			position = nsl_get_position(ndd, nd_label);
> +			position = nsl_get_position(ndd, &nd_label->ns_label);
>  
> -			if (!nsl_validate_isetcookie(ndd, nd_label, cookie))
> +			if (!nsl_validate_isetcookie(ndd, &nd_label->ns_label,
> +						     cookie))
>  				continue;
>  
> -			if (!nsl_uuid_equal(ndd, nd_label, uuid))
> +			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>  				continue;
>  
> -			if (!nsl_validate_type_guid(ndd, nd_label,
> +			if (!nsl_validate_type_guid(ndd, &nd_label->ns_label,
>  						    &nd_set->type_guid))
>  				continue;
>  
> @@ -1595,7 +1596,8 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
>  				return false;
>  			}
>  			found_uuid = true;
> -			if (!nsl_validate_nlabel(nd_region, ndd, nd_label))
> +			if (!nsl_validate_nlabel(nd_region,
> +						 ndd, &nd_label->ns_label))
>  				continue;
>  			if (position != pos)
>  				continue;
> @@ -1615,7 +1617,7 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>  		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> -		struct nd_namespace_label *nd_label = NULL;
> +		struct nd_lsa_label *nd_label = NULL;
>  		u64 hw_start, hw_end, pmem_start, pmem_end;
>  		struct nd_label_ent *label_ent;
>  
> @@ -1624,7 +1626,7 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
>  			nd_label = label_ent->label;
>  			if (!nd_label)
>  				continue;
> -			if (nsl_uuid_equal(ndd, nd_label, pmem_id))
> +			if (nsl_uuid_equal(ndd, &nd_label->ns_label, pmem_id))
>  				break;
>  			nd_label = NULL;
>  		}
> @@ -1640,15 +1642,15 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
>  		 */
>  		hw_start = nd_mapping->start;
>  		hw_end = hw_start + nd_mapping->size;
> -		pmem_start = nsl_get_dpa(ndd, nd_label);
> -		pmem_end = pmem_start + nsl_get_rawsize(ndd, nd_label);
> +		pmem_start = nsl_get_dpa(ndd, &nd_label->ns_label);
> +		pmem_end = pmem_start + nsl_get_rawsize(ndd, &nd_label->ns_label);
>  		if (pmem_start >= hw_start && pmem_start < hw_end
>  				&& pmem_end <= hw_end && pmem_end > hw_start)
>  			/* pass */;
>  		else {
>  			dev_dbg(&nd_region->dev, "%s invalid label for %pUb\n",
>  				dev_name(ndd->dev),
> -				nsl_uuid_raw(ndd, nd_label));
> +				nsl_uuid_raw(ndd, &nd_label->ns_label));
>  			return -EINVAL;
>  		}
>  
> @@ -1668,7 +1670,7 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
>   */
>  static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  					    struct nd_mapping *nd_mapping,
> -					    struct nd_namespace_label *nd_label)
> +					    struct nd_lsa_label *nd_label)
>  {
>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>  	struct nd_namespace_index *nsindex =
> @@ -1689,14 +1691,14 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  		return ERR_PTR(-ENXIO);
>  	}
>  
> -	if (!nsl_validate_isetcookie(ndd, nd_label, cookie)) {
> +	if (!nsl_validate_isetcookie(ndd, &nd_label->ns_label, cookie)) {
>  		dev_dbg(&nd_region->dev, "invalid cookie in label: %pUb\n",
> -			nsl_uuid_raw(ndd, nd_label));
> -		if (!nsl_validate_isetcookie(ndd, nd_label, altcookie))
> +			nsl_uuid_raw(ndd, &nd_label->ns_label));
> +		if (!nsl_validate_isetcookie(ndd, &nd_label->ns_label, altcookie))
>  			return ERR_PTR(-EAGAIN);
>  
>  		dev_dbg(&nd_region->dev, "valid altcookie in label: %pUb\n",
> -			nsl_uuid_raw(ndd, nd_label));
> +			nsl_uuid_raw(ndd, &nd_label->ns_label));
>  	}
>  
>  	nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
> @@ -1712,7 +1714,7 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  	res->flags = IORESOURCE_MEM;
>  
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
> -		nsl_get_uuid(ndd, nd_label, &uuid);
> +		nsl_get_uuid(ndd, &nd_label->ns_label, &uuid);
>  		if (has_uuid_at_pos(nd_region, &uuid, cookie, i))
>  			continue;
>  		if (has_uuid_at_pos(nd_region, &uuid, altcookie, i))
> @@ -1729,7 +1731,7 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  		 * find a dimm with two instances of the same uuid.
>  		 */
>  		dev_err(&nd_region->dev, "%s missing label for %pUb\n",
> -			nvdimm_name(nvdimm), nsl_uuid_raw(ndd, nd_label));
> +			nvdimm_name(nvdimm), nsl_uuid_raw(ndd, &nd_label->ns_label));
>  		rc = -EINVAL;
>  		goto err;
>  	}
> @@ -1739,14 +1741,14 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  	 * that position at labels[0], and NULL at labels[1].  In the process,
>  	 * check that the namespace aligns with interleave-set.
>  	 */
> -	nsl_get_uuid(ndd, nd_label, &uuid);
> +	nsl_get_uuid(ndd, &nd_label->ns_label, &uuid);
>  	rc = select_pmem_id(nd_region, &uuid);
>  	if (rc)
>  		goto err;
>  
>  	/* Calculate total size and populate namespace properties from label0 */
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
> -		struct nd_namespace_label *label0;
> +		struct nd_lsa_label *label0;
>  		struct nvdimm_drvdata *ndd;
>  
>  		nd_mapping = &nd_region->mapping[i];
> @@ -1760,17 +1762,17 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  		}
>  
>  		ndd = to_ndd(nd_mapping);
> -		size += nsl_get_rawsize(ndd, label0);
> -		if (nsl_get_position(ndd, label0) != 0)
> +		size += nsl_get_rawsize(ndd, &label0->ns_label);
> +		if (nsl_get_position(ndd, &label0->ns_label) != 0)
>  			continue;
>  		WARN_ON(nspm->alt_name || nspm->uuid);
> -		nspm->alt_name = kmemdup(nsl_ref_name(ndd, label0),
> +		nspm->alt_name = kmemdup(nsl_ref_name(ndd, &label0->ns_label),
>  					 NSLABEL_NAME_LEN, GFP_KERNEL);
> -		nsl_get_uuid(ndd, label0, &uuid);
> +		nsl_get_uuid(ndd, &label0->ns_label, &uuid);
>  		nspm->uuid = kmemdup(&uuid, sizeof(uuid_t), GFP_KERNEL);
> -		nspm->lbasize = nsl_get_lbasize(ndd, label0);
> +		nspm->lbasize = nsl_get_lbasize(ndd, &label0->ns_label);
>  		nspm->nsio.common.claim_class =
> -			nsl_get_claim_class(ndd, label0);
> +			nsl_get_claim_class(ndd, &label0->ns_label);
>  	}
>  
>  	if (!nspm->alt_name || !nspm->uuid) {
> @@ -1887,7 +1889,7 @@ void nd_region_create_btt_seed(struct nd_region *nd_region)
>  }
>  
>  static int add_namespace_resource(struct nd_region *nd_region,
> -		struct nd_namespace_label *nd_label, struct device **devs,
> +		struct nd_lsa_label *nd_label, struct device **devs,
>  		int count)
>  {
>  	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
> @@ -1902,7 +1904,7 @@ static int add_namespace_resource(struct nd_region *nd_region,
>  			continue;
>  		}
>  
> -		if (!nsl_uuid_equal(ndd, nd_label, uuid))
> +		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>  			continue;
>  		dev_err(&nd_region->dev,
>  			"error: conflicting extents for uuid: %pUb\n", uuid);
> @@ -1943,15 +1945,15 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  
>  	/* "safe" because create_namespace_pmem() might list_move() label_ent */
>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
> -		struct nd_namespace_label *nd_label = label_ent->label;
> +		struct nd_lsa_label *nd_label = label_ent->label;
>  		struct device **__devs;
>  
>  		if (!nd_label)
>  			continue;
>  
>  		/* skip labels that describe extents outside of the region */
> -		if (nsl_get_dpa(ndd, nd_label) < nd_mapping->start ||
> -		    nsl_get_dpa(ndd, nd_label) > map_end)
> +		if (nsl_get_dpa(ndd, &nd_label->ns_label) < nd_mapping->start ||
> +		    nsl_get_dpa(ndd, &nd_label->ns_label) > map_end)
>  			continue;
>  
>  		i = add_namespace_resource(nd_region, nd_label, devs, count);
> @@ -2122,7 +2124,7 @@ static int init_active_labels(struct nd_region *nd_region)
>  		if (!count)
>  			continue;
>  		for (j = 0; j < count; j++) {
> -			struct nd_namespace_label *label;
> +			struct nd_lsa_label *label;
>  
>  			label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
>  			if (!label_ent)
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 304f0e9904f1..2ead96ac598b 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -376,7 +376,7 @@ enum nd_label_flags {
>  struct nd_label_ent {
>  	struct list_head list;
>  	unsigned long flags;
> -	struct nd_namespace_label *label;
> +	struct nd_lsa_label *label;
>  };
>  
>  enum nd_mapping_lock_class {
> -- 
> 2.34.1
> 
> 


