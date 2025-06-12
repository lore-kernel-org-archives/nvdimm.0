Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F15D10E5
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 04:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749703056; cv=fail; b=guMmpb50qojIo1Uc+wo+M2FNw7eFmMt7MCuBFHwGnbDwTNKZGWg3lYR2/fZJB8RYYlrDtUnvIeQ0a4aw7nvP2lTmWkYDQL8HHoFQ4XHwkqBvyywTImqoxyxq7ILtcH3XraZN6g4CFP3K4FuTbTwRBrrSfug2I8dlVgzmvj2xI4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749703056; c=relaxed/simple;
	bh=RRpFm/BLkkBQeUd5D4/wC5lSk7ZrESJW7MTw47t2odk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qAwDY95bvjg2IafITrcmMUeLyiCCdccdr9ZLWec0VLrRBNblxiuZt1PUXbpsNNApHwKSdIGaVPV8zhQZmR76+3xo2cO+NIWZ5fpj9R+V9QbSraAe1PYEPh/cZfVCrJ5m6D2+XIotkhwotHfhNi3IgVTJ3fHZvWBzql6BrKz1Gz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hGIC/5gN; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hGIC/5gN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749703055; x=1781239055;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RRpFm/BLkkBQeUd5D4/wC5lSk7ZrESJW7MTw47t2odk=;
  b=hGIC/5gNOJCaGGuMnOiTPJ9PoDYpLlS+r3azlcfJgF4c+Bko0pEkBjHX
   xa256LMUsa+VQ7dFmyB9QV+8zQumZaNG8zfT+pun8kZsdYQ9u7nk4oeKH
   j/1H1KY777p915PzHeIXbpZAz/mZ4OWQm6n6mNVUeSSSmiYwnvdR5vHc7
   EaqNltB4nDXp4XaxhB7RPybno8MH4eNn67RVU32cg8LmMqqZDbONlphX2
   TcW1rmRr1csq0neRS5yqEek8dcslqpxvfremk+pm2eSu8XT0vgfPG2mLd
   31VNwfQ9iWc/NAy70rmUKXCJ2AQ/ioPXsgJ9VQOJvvT7D/9bNdJQJgfKM
   A==;
X-CSE-ConnectionGUID: rGjsvZEoQvqoXeRndr19Dw==
X-CSE-MsgGUID: XI9N/d+wRLyxlpUDnAHbpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51950982"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="51950982"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 21:37:33 -0700
X-CSE-ConnectionGUID: ePEsvukESsa2FkGU/prH3Q==
X-CSE-MsgGUID: 74Qk0nIQQ6ej214Y5PmGNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="147890848"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 21:37:33 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 21:37:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 21:37:32 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.49)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 21:37:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OHvpvfYLNFhug/NAT0xN8HY28/g1cZtPqujEe9fK22632JfbrdorKT/Q8vCoHxBwnbRx41Lvu6K3C0PSrmkuC466/pOjVVmBnhYnAwIYOxrUraH6rXfHj2vi/Lxy9u18PWlL33mJ2XbBXKG2ZRqJJFYKs7MZKgPa8m/+HwX3WBjYm/iZKohp9Obyb1Hc63SXYUTyN94DHI5HbjjownABGXCzvGFT8K/4em0RqccI7/tO5P2EXy8W2FkcqHrGEwzJAsZYjIcAPSFH8uGAFcbIC0/ocx5lgXYj9YrIq2NhnvNyqnoZuQ1tGxa1uzQq3J2EVWvGbC+PB5tKVmdXH2j0MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+MQi07pNx4wjB1+cHPRljnDBNizKbfw0j8ovpGkWXao=;
 b=JLtyS0MPs0L9g7LLAEbrccSxbjjXJuruGUGtZGX6R09xl6/srIzZ8E03BeP+o3ojEvb0sFWK2hGp2ezye7adbbm+M7gT9uHDNAPFaIWwQd1kYWjWszl+oi6etXaFOuyyMM5DJtcmazr45YWWMmP6dqYj7bHuVroKwYdEEL6xOldxy8BWaRiag9iz0MUsUj04o7BHuR/i/lPa+70PFNuMA/BmNjqwufP8S76L/fjBdFQoJZtE3qrVtwd3KGKwa7OL780q4MOHET4QKhH240jXonEs+rZAdBNECY4TDo9mOQIY1/ASzu9sFBKH/Q3wy6trwvHO5maeJ9yLXhvZm9bHFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13)
 by DS7PR11MB7738.namprd11.prod.outlook.com (2603:10b6:8:e0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.30; Thu, 12 Jun 2025 04:37:22 +0000
Received: from SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec]) by SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec%3]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 04:37:21 +0000
Date: Wed, 11 Jun 2025 21:36:58 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: David Hildenbrand <david@redhat.com>, <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, David Hildenbrand <david@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Dan Williams
	<dan.j.williams@intel.com>, Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 2/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pmd()
Message-ID: <684a5969ed654_24911000@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-3-david@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-3-david@redhat.com>
X-ClientProxiedBy: SJ0PR13CA0207.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::32) To SA3PR11MB8118.namprd11.prod.outlook.com
 (2603:10b6:806:2f1::13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB8118:EE_|DS7PR11MB7738:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e5944a5-b9ed-48b9-dabb-08dda96ac604
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GBWA0t0NQEJer++Ctf7isF9eOdHFbS95eD+UjRNN17IiYjHwgl2V8OBLD5oA?=
 =?us-ascii?Q?h+ZSt1XzN48IXzXrHe60dTC7b4t2o93ql3PCXZkfyV2HAjoRy8L40OKO6XLM?=
 =?us-ascii?Q?59dtg4vCyhOnlVxPbxeVy8GBHOVAiLvpmp9EOVPMxbRI2dUxQu2L6m3aCrrJ?=
 =?us-ascii?Q?7A6cIh6R4h5jv6FB/6PU1TwllPYmbrZoEechHal6EmDIcuvVuqhyZc5oIhcg?=
 =?us-ascii?Q?qDxOx8f48pnG6miPEcSrBJcZhhGrqsfowT50yCW9vmvcGiuVFzbeJQEvmBYh?=
 =?us-ascii?Q?eoDucJitTowchPAVDGt2Ot7KbDWdLz5NODiMqW4pKugkP1C/VPtzHwKRHJmj?=
 =?us-ascii?Q?VME4hecmMYrQjaP7aRAUH0WB2OK7DnW2KwpQqL0OFGu+s3F0SSNMvCrlJgx4?=
 =?us-ascii?Q?7BFNB8LZR67N0fN8KCzGpCNbyj7gEf0xzqC1/Ort4XD5t0k8smIkvFguBu4m?=
 =?us-ascii?Q?A0gKs2XG5KyvZEnsD7moHTv7Adm3DVHRPuUtYBrlDQTNxD8fBEnfgi0rfICF?=
 =?us-ascii?Q?20K4lwubzWzF8hYfx99rHGewccJw31T/5HJb2aaHqgbyYImmsCG3T/80mXA4?=
 =?us-ascii?Q?42AaAmS40DKpslaLb4hcNm6W7MSH/edqz0wY8xj+9kpSQ+TPUD7mRB9JYLw7?=
 =?us-ascii?Q?ALTE8dhg0x5qj2MGhH+XYKXW9oiRIunXO/3RO/AtHpEBcm/ltt+0DpW9DgX5?=
 =?us-ascii?Q?KutIyA1mI12zTz7M9lEdJ11iWtNehkREAgpfgVKbZYt8u2i05UI6O/GiODzC?=
 =?us-ascii?Q?50OFevUeWXRBBDMRVoYmcfOffNQ/PIfcFAYc78L06qPSXhG674v7vD+DuRNB?=
 =?us-ascii?Q?hciFhXXMslsgl+D01aHDt5CQcs3kNCz5bubXSRvXQm5V1WoFMj+XzXliXeNC?=
 =?us-ascii?Q?/VrF4OeG0Tb4mmaD2XBqZL7kewydcXMrQbgv0YxQJGZ/L1BSEQFWRPFKugaE?=
 =?us-ascii?Q?WExy8rvAW1lvgGl/nH2+L0JikynyDwMmya6GhdRXCmIJeE9iMednlpUcWOu1?=
 =?us-ascii?Q?dvZOFsjbJptNdZAPD3yqjq9kfYHQ0jrJz4KTzYn582PIR2P+KTU+6mHZCSMZ?=
 =?us-ascii?Q?aTo+YzgcphKDzkvDLTWg2HVN3YyglSqFgfdQaq7DN9BEPmPJ2I97+kxIuI53?=
 =?us-ascii?Q?C1aQbtXbQQnTehTDzESxtMvK2yprql+wLFYL0dGNIHVoJg8ka82to53yI1TZ?=
 =?us-ascii?Q?IdcagQDmZQTd4+5vWcVqYaQdeGcpkzXOCuJA4NHEyWZWXiaLhEjlkkm1C7x0?=
 =?us-ascii?Q?7kCidv28v+1ddFecepVG7Elw+ZZsvrZKICivz1UBXpqBU9KS87BuPrwSD2pU?=
 =?us-ascii?Q?oqHVsACoOiu6i/o/9KjNw/mN0Cd76ooxuQLLi1MkYLRn6dDtY0ycaILybRKO?=
 =?us-ascii?Q?Io5Pxp31Nsq9opbbeUhvSwRgaCkhKIYNXeN3u59Ev2zd20iGDznz5RxKV99X?=
 =?us-ascii?Q?bjFaErTDkZM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8118.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3r58RdXufQTxURFl18Xk4ltQN3jIm5rEs/hNGFOJpv1V9nRFrHoh4SvIQVWg?=
 =?us-ascii?Q?HAWBFFOcOv6QKWEeCat91ffxIjepynzjeOPEf10+cog6pO4c6AWlLwpZY18h?=
 =?us-ascii?Q?UV+SHPWgM6DR8FHPu5dsHznkG+BBQVLmSlFbE6pqsLox0T3XBR48DTya8wFm?=
 =?us-ascii?Q?yV+EZzgkUknAoz5GGJgLHXhHURRXYG1B0CGCGzYy0AdHtjzRxOAePNynADBK?=
 =?us-ascii?Q?CwJuAvmJqAkujUWjyoYo6voQhwC9LLNGCHMyOf3P5J0xGpcmIGxkyqJx7O13?=
 =?us-ascii?Q?PxgYplb83riUu/cDcB228hdbLX1lag9Qah7bkAVv0MC5o5qS2Jx897mEDGuR?=
 =?us-ascii?Q?jctE/ofydpESptrVLU592bmW1ERS0lBAn7UVpkqXllaIJKiuYcSjyRrEeF2A?=
 =?us-ascii?Q?pvVSQ9Rz0Y/YshXOC82M4L3enwmInWKB3fyIQbvKlxgeAmHqE1JzhspxeDMJ?=
 =?us-ascii?Q?Nxb0Cv9W/02/Nv0hKAqAtrw04+ZZ6D+HV/N67H9SOt1hM/3bFbotZAglHAj7?=
 =?us-ascii?Q?mbxymPJCcaPkgNvfNEcMoIPM+MX5WshHmfvOY7RED3SaLnerMax0XMmVenAe?=
 =?us-ascii?Q?pP37dcMAolJZuq4tbCvOdrjTtkAVlJOh46kZJLP6+vvBV5X3HFaY4xdLtdtO?=
 =?us-ascii?Q?IGdNzu3s2dwozPtIOiacqLC6TkHaGiwZJttmMC75DbUWYk8yaqe3sxTOC/13?=
 =?us-ascii?Q?LUnbmD4B0GZiR0xYloKW12//87ueKPy4zFujjcs1qpc3y4Le0E73p48spRtl?=
 =?us-ascii?Q?VqmIbDM5A1bmbMsW3fSxmj7shcOQOxhc5wOW/fZzXW4hpIEchXUXyMviuRCD?=
 =?us-ascii?Q?HBn2EhKb0HSc4iONEWlxT2WlmLxCC/oB1fa34XmGXr5oTPxvb1fKA/NFUd0H?=
 =?us-ascii?Q?pv0ElwdRNSUXlVxhOvBJ4dtU4c1El8B7b0apQJscXaGjieyHkL6B28Dp+a3P?=
 =?us-ascii?Q?b5v/RcxfARPuC/k9pK2MeREjqzMa0RO284rwF/jzFoVGGj3B8QFN4bpFd2Sr?=
 =?us-ascii?Q?uRrRYODRDM+ZDR5QYcKkBPeonMr8f9c6ZGELVOQUhWY23qbwji57RdY0+XR0?=
 =?us-ascii?Q?diGkJbKdF9gtQYBX6PgZ5EIlnL6mxBXBqvFRyV36kmtLTurS9s2GEBqDzdco?=
 =?us-ascii?Q?DDFshX0so6Cxbt4ediAIwFtTJJv78bRhjZ/2dFnjlXrunoch2SDdf9oL9onE?=
 =?us-ascii?Q?YJwpgcOvvwXvwiShyRmS12lk93MUsKi9Ixbs/y4k1SDol+4dCOU2JmbH/RuY?=
 =?us-ascii?Q?MRgEnZqQQEuMTG4HeMpcVAcpVJCLU7o9x0B+Qga/76WbcijM6nFVFZ5D83KP?=
 =?us-ascii?Q?ZBbgq8k48WrOdRCJdahAcP3sbr+Ab9d4HzvOa01jvEXu7OCUgZfePrw251N5?=
 =?us-ascii?Q?DJBXZ6Uav+vv8XEgVmQc41uf9R13EOhyGLEzhr0wBWVRI4fcL7l8EcaXp/CO?=
 =?us-ascii?Q?DQY7PAk99/bt/zm3/TPIEzrA/zIZh0OVJDU4yFAsuqOfOVkQCUmFELTfPpWN?=
 =?us-ascii?Q?XHmEOP9SREKthbBIMqzmB94keeEQ4vPs9UCtAhM2gsOd3R8pkaF05g3SLT15?=
 =?us-ascii?Q?DeC4ZgHxi+pMk3va9kkMR9tZgaBkdrqOqtu0ppDV+e/FjAvyOvmGUc9TsOyA?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e5944a5-b9ed-48b9-dabb-08dda96ac604
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8118.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 04:37:21.3833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xXuWGBZYqraY388lhzaEZ/vnwaXVqYDRtyh1+ZUlC77lkOXtBpJ2NjrbiGrSCMyMVsjMCctOiyFgRq7ojUoSPMhD3tp9BafdLhHA242B9Vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7738
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
> Marking PMDs that map a "normal" refcounted folios as special is
> against our rules documented for vm_normal_page().
> 
> Fortunately, there are not that many pmd_special() check that can be
> mislead, and most vm_normal_page_pmd()/vm_normal_folio_pmd() users that
> would get this wrong right now are rather harmless: e.g., none so far
> bases decisions whether to grab a folio reference on that decision.
> 
> Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
> implications as it seems.
> 
> Getting this right will get more important as we use
> folio_normal_page_pmd() in more places.
> 
> Fix it by teaching insert_pfn_pmd() to properly handle folios and
> pfns -- moving refcount/mapcount/etc handling in there, renaming it to
> insert_pmd(), and distinguishing between both cases using a new simple
> "struct folio_or_pfn" structure.
> 
> Use folio_mk_pmd() to create a pmd for a folio cleanly.

Looks good, I like copying the sockptr_t approach for this, and agree that this
seems to not cause any problems in practice today, but definitely will be a
trip hazard going forward.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
