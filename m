Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A312116F1
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 21:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744234885; cv=fail; b=HFmKtZ6Naet/0O2VHs/w/QxPF1ycnb0ULmi8I1MW/6DbzIIk60rfNXhl8lHr2BpiCmu1ZVI44wx1vpLRG1pQ3vciqZ7oBwKKHuOP7AFETntZPXSdGv1Mil5zoLtN3hJL0H6JU4ucGTQ3tQqPl4zNJp1DxxuIVoKGlpOd9VhpRWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744234885; c=relaxed/simple;
	bh=tCXQVoT1U7W58O3KZoUSF7662tKwOH9aMZaFRTFlx+o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r4HGkuOpwS1mk/YkZjlz3lOTf47F6DQ/suT7ersYGtm8vj3wYbpG9m1yh6X56/RyJLI094m6EaDG6CDRptm9oy4TLquBDv7+NdOVjDxp5D3K6NQM1h+s3/HCz76YTtk6UEq0Ani7fgLckVqlSGqnQhUZm0m8q4ms0qS4nG5rBQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aC87obtl; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aC87obtl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744234882; x=1775770882;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tCXQVoT1U7W58O3KZoUSF7662tKwOH9aMZaFRTFlx+o=;
  b=aC87obtlgWnfTFQ5sleJx1l4/nGeIcVm8K3IMdoWEjnmTOmZK3Rt1mA2
   x9LVpUcV3pw8QHMVrLnEyQerRwVfnBlnqDfoCzI/Lh9WHhfj3EvdU6Gen
   FbNRBALCK9cHQ0hBMPwBbbT5PwjiFkkOCfmuHMro8sTQZY82nZbiYf4Hw
   4AgV+Mo5ckmIA32PwxWtnT+P9FdV14CzWMHExua4pSecfZwdSxqj1AzXY
   JIzO5j8FHM2YiYWbeMWg7ZMDCTO9vx/w+L2WWrWN1OxqdoldnT+1ci+KG
   MjnsyDZnvBGpzLBq3GGLIrM7WP7skz3GhOsqq3Et8Ldx9J/sdOTKGhkt3
   w==;
X-CSE-ConnectionGUID: vb6w9uptRgiiSc3Y6UTU7g==
X-CSE-MsgGUID: oudCHwAlQ5egbMA5L8oS9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45446434"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="45446434"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 14:41:21 -0700
X-CSE-ConnectionGUID: 2sSR2391Rfasj/eQhOo9VA==
X-CSE-MsgGUID: 7fV3O5wdQcGn49VHm0v5Og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="128671982"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 14:41:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 14:41:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 14:41:20 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 14:41:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VIOmBcfmeCmonjWaoogqbOTr59WsDbpEvE9512WIKmjVjA/ZVFIRp6JiWzDGURL3rqDqtZmYMGu0PrG5OcmiCux4eu0gUqh8rG426FMx0VbJ0TPd8qKtbq5b9KOP4u4OKWbSW54tqSuYqvFsn8myKDkI02I3kz1jL4NlCkBnvu6tCWVB7aO6cVN9VyLJKJ+eriqp49xLPDl3YH7pNiCOLfYvnSvHIiCfrbGgJKl8FQkwWchlzoK7boDHHpWHnMLoBSPwU/eV42Yoc86dcvqbisoG3UXKl6Dzw6sE5SO4Gp7txHq/BZv4q7GEnybMitZALZBJOUuEgsYAbWkr+c8IMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rKFawzuCAJmZfTU7CsKfU2kooYOMKii12NGZ6W8HHY8=;
 b=G7RsPkqjt1S9LZYqwhsgkbZsLBoqEJekh1TEo4hjjDOPQCwEiurj85Jp+7XKpeBgn132honkhKi9RUHUZ81li7SRpv0unph2tUh8YG4IR6q2p4qQeNiPJjBiTJRnys6yjMK7uBtLfyQn+3NlFs6KcJj1GZzaUi/qsRnL6HqryNCbp4ZBWy3nrtGbzQ0g5NUWEDeXuo5MxtMkQdJTT+xVrQ+JLDSRHnc/2n5ZjrWpv1yuSk5mqMGJDY5df3j3w1OwASwPUlkNTSfoWfm/PylO9zyBDhLt05DqConounS7iNFaVi9sB01pvNUMYbW78ZGQyRksjuSlpRRrCdp3zXuSFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB8093.namprd11.prod.outlook.com (2603:10b6:610:139::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 21:41:18 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%3]) with mapi id 15.20.8606.033; Wed, 9 Apr 2025
 21:41:17 +0000
Date: Wed, 9 Apr 2025 14:41:14 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: David Hildenbrand <david@redhat.com>, Dan Williams
	<dan.j.williams@intel.com>, Alison Schofield <alison.schofield@intel.com>,
	Alistair Popple <apopple@nvidia.com>
CC: <linux-mm@kvack.org>, <nvdimm@lists.linux.dev>
Subject: Re: [BUG Report] 6.15-rc1 RIP:
 0010:__lruvec_stat_mod_folio+0x7e/0x250
Message-ID: <67f6e97a4dc0b_72052944@dwillia2-xfh.jf.intel.com.notmuch>
References: <Z_W9Oeg-D9FhImf3@aschofie-mobl2.lan>
 <322e93d6-3fe2-48e9-84a9-c387cef41013@redhat.com>
 <89c869fe-6552-4c7b-ae32-f8179628cade@redhat.com>
 <67f6d3a52f77e_71fe294f0@dwillia2-xfh.jf.intel.com.notmuch>
 <edf48c4b-1652-4500-a2e0-1cb98a1f0477@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <edf48c4b-1652-4500-a2e0-1cb98a1f0477@redhat.com>
X-ClientProxiedBy: MW4PR04CA0366.namprd04.prod.outlook.com
 (2603:10b6:303:81::11) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB8093:EE_
X-MS-Office365-Filtering-Correlation-Id: 660fe6b5-5b11-4b15-4631-08dd77af4261
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/sTeXr4evPgHxE9sjp6ZcL6R3E5KF2q2CTGRfwQRvA2dHxhkODpEONrdHnJl?=
 =?us-ascii?Q?vkW/ItDNLWw0l9Cr4rqnoEjJ58Ytjq5ms6SuDEufWq/93lNhXDUetLhdCIva?=
 =?us-ascii?Q?kvewiSFiYtBEDXjg8px+OkUigYZoVBq1WhLKCT+ckDOZf+yuaSA/BMOpjRfk?=
 =?us-ascii?Q?8kaPATWuiAOhfasZ+Q1i3s6SiLWidUBX5nBbWOTx8UatV0jbeMtgG0LDsHDt?=
 =?us-ascii?Q?umPVDMrbTYbht/6vpfqC89jzFRnav6H5y4qC7tghc41iRn8AEtOxne8FdkzP?=
 =?us-ascii?Q?d9Z1uRe9ZaITs531+tgrNOi09q8D1+DfjteumQL3wZH7HhJ/vKF9u9wiqsmz?=
 =?us-ascii?Q?kwJaaEKksCPUiONjyWBGAgz79Nqz4ms0dY+AfSiIGp/LELT+zJ27b2gJauIF?=
 =?us-ascii?Q?cp/P/1Rx1W0QYFOTeBOMEFKayAFMHIfaee3H8Z79nDSH9GA771hU7me0LUQj?=
 =?us-ascii?Q?dLzHl7yc5xuRUnonBXMeysY6se04jBgm7qnQAKHgcn/Uttcxk72UwjDt9Yx1?=
 =?us-ascii?Q?qGMobZCppnqMs+63W4MEQwxYjuseC5gVk1XJMNBJFdltwlVrOFeB+SpK0yD2?=
 =?us-ascii?Q?Zvkjsx0+dcxuEeKu8FszqhRS2ui+joUY0OLeuT4+vcS9+BR42Q1wYvlZJr9/?=
 =?us-ascii?Q?lxUxfgKscovsNxaEO7IbDvADHCB16HUvh/xZeBqYYAbm/InZAhFtAc1hmd+T?=
 =?us-ascii?Q?JR7aix9PgTngzlQvn/pNRJS/62ioCcPFRWMK2N6obu5PLFhqwYoA+YTEKTyH?=
 =?us-ascii?Q?tcyU8IjT8WOR69CSumg8oVQ2Gm2GnCgCY9WQvIv1aBhl0EYEBkwhd9BoufE/?=
 =?us-ascii?Q?OMuel4CMXQnxAg4IX/v+gLJPIqlTc4N0dn2pYykCxL0xVGITZ2WoURGjBUqW?=
 =?us-ascii?Q?z7XTrck8HAvI1bXggoRIt/ucpOCJW4ijlQ7nBeXI5JpXaOG9PH1tosm4l5Do?=
 =?us-ascii?Q?N3554vGX/9Gn1kKs7kH0wp7zftfDCg335FsLjKM81u+tZYJtHO2k14AJlIvC?=
 =?us-ascii?Q?pYj+JfckKzRQdHVaQr0PMXhuYKIATIkw4kjfFbATtM5E0OLbhGAdvj60QwLV?=
 =?us-ascii?Q?oHQyPKcpl9asTWNdEJ4PsLQPMHQ36QyH2HYnSMHn2BJqgjslRcDe3yQ27ldY?=
 =?us-ascii?Q?XLdRUp8UWkF72KzC2uZrbGQwjlSGZCll0GNERJ2AnWrLDJGzbJfJsvD1SoXU?=
 =?us-ascii?Q?kVs5ItQyP1rvVaCYBD4ZBoOVTSaOFbfpIJMEXJ6gej6s3JbasdGOELg3M7sb?=
 =?us-ascii?Q?C+tC+Nrh/LQUo+naZTAUYUDQ1AtlhLWFGLPe34/56RqEaAZ0TcQ9I23WVUqD?=
 =?us-ascii?Q?mBCQjg3gOm9lge8alkbXCZEGup6p6qeK5BYoHvr3h1c3lIXNbryuq839stHE?=
 =?us-ascii?Q?XiyN0Ef1lFcBMboKGyhGWAmUED/h?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pr7zd1yx6UbVq5kXqubvOrCCZOFbI/uVeLMqdsBfkEQ3iSyoiUrPL2gsoCnb?=
 =?us-ascii?Q?gp6pnwy1C8HNXfanYBL11U4pfPdVdvYynZZjBKTO1k12YjpZ+UgMI9gqkF0u?=
 =?us-ascii?Q?QqmLktyhsfztGbTyQWjTsIU7y8Ajv3SSrpZir7+l/8rctX1V8XRJTRtqmZh7?=
 =?us-ascii?Q?/LKi0DAcAR6YAfcT10aT2IlOEFG0y2XhuyyMBtzE0QQlIxQpesmTdCQoh8+O?=
 =?us-ascii?Q?ejRDRQ+cnYnUMvV9CDyspQdhxqeYUtTSvcDGNviaUT7t967pEL+SObK/4vz5?=
 =?us-ascii?Q?7smq6F8n9nlbjGz5Jrk7iwRfhi9GW8RjHbhmcXAlIljca4rssAvnhRpzkcHh?=
 =?us-ascii?Q?GigYeqyRm/9ZZ/p/xxKC3DOz7aM7RRK8JeAxvkNh8ADiHw0YG1lWw5wmzjII?=
 =?us-ascii?Q?fW/Xow0mK8BUx9QWrtaAUlDyvFAd7r0Fp78GaNsJnwqzRAf29YZks1zuVtoz?=
 =?us-ascii?Q?ZwSa2em5J+cdps1eBoi3ZTv6VooyV58At18Dc0uxzXnHXRAAeXTeVbWqYVlt?=
 =?us-ascii?Q?tsH+O73VD5SSaksi0iuWnygCiti4Y7M3T9MvzFEuOmZBxipcMZOpUr6kMkSn?=
 =?us-ascii?Q?1Xw6AuOopt0VP6GfEuGdXGtsJDqv8Dc8YAP3gmnZc4NP0pC0onE31hZMy77D?=
 =?us-ascii?Q?B666uRVKrLuLQ+0Pz88m0cN9NRI2aSH1Mfes4oI0Sxx6D6PFuy5yDJk+SdjN?=
 =?us-ascii?Q?iUSL+bBlpIsQCNydijYRfDmr29RGFRRYWWGZbFm1KhsAvKzz0L0s10MmopiQ?=
 =?us-ascii?Q?Vg3aGpaHysleTYgzd6h/bvBVcMeWqKmqDpvHva1/KsdwnHgexfPNMOcGPjYT?=
 =?us-ascii?Q?Gbw5TkXIseMSjpNQ8IOdr9GavVudaR/L3mg/85EIYRETgpt2H8Os9k7pBkl7?=
 =?us-ascii?Q?VueL9XApYohWLNgJ/wZFgf7ZdHEn/xWFd67QcYQV89xdnLMt2ZU82egdFuaN?=
 =?us-ascii?Q?N7EExrnQI8P9MaqHNOXuv6MaRLitelh73Jo9B0NN9C7aBwYNZANnkUp8ZAiF?=
 =?us-ascii?Q?XoDNAV23fEAWucHSQl+0Up9TDumehcEJs3pKi6j7Tn2fuKJK+6mRTo7ZDUqF?=
 =?us-ascii?Q?FlkTc44Pw0MV1urn5509KQVghf1lVETkU05aJM92mZT0LqACUaej11jWUyGh?=
 =?us-ascii?Q?Ezw2jFAb7K7ahKVp7MfsZ48wthT+/lAJekyIw4yPJXlqcsJDcsFdqRi7imli?=
 =?us-ascii?Q?5zxWHuRchXRXQZweoptosvgUoA9NBGIj/TQ2aTPvLLb227/TbkyGqyAR2jb+?=
 =?us-ascii?Q?MKKnnvr3oOnTWKHnYwenE+42aR7cCPrJwVaeFr+061ZZSePrOWmW8d8tTeyV?=
 =?us-ascii?Q?omqADr4IL+hJYB+GYrn0XaNXOuuc8Pzca0QAPieCgLOxTeCaE49MIX/wtfbe?=
 =?us-ascii?Q?Gltdz1tbKH+RutxFU0rvLxgfHqzZQRw+RxtliPVBiy5lVqFYRYr9tUc7QD+E?=
 =?us-ascii?Q?2E9rP5issuoko5k+Qb9XDuX+4ZEkK4mXWj7OY4yg5lvVQkhnzcQrW2v7EbCt?=
 =?us-ascii?Q?KaKEX2bylVej7MqBUbbO7TpPXODT42L2Nc4XyCXA5DoUXHkcgLI0P3wgn99n?=
 =?us-ascii?Q?x7c2Yi8mxASfa/62pmnKuU08hzvvsNu1YfY30WEyCCz1NDYfLZE3mwtM7715?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 660fe6b5-5b11-4b15-4631-08dd77af4261
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 21:41:17.5177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HdlEcTpLJm2pEfwg3vOyMc6yLmeb0QnG7O0DoLpjPAS7B1ojHJrjOI0vDIBnrX8k0jY3UzsQPmxEY0GpBrKvpiOQmb819vi5OVsR+EBs+Fk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8093
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
[..]
> > However, raises the question if fixing it here is sufficient for other
> > ZONE_DEVICE folio cases. I did not immediately find a place where other
> > ZONE_DEVICE users might be calling prep_compound_page() and leaving
> > stale tail page metadata lying around. Alistair?
> 
> We only have to consider this when splitting folios (putting buddy 
> freeing aside). clear_compound_head() is what to search for.

So I do not think there is a problem for the DEVICE_PRIVATE case since
that hits this comment in free_zone_device_folio()

        /*
         * Note: we don't expect anonymous compound pages yet. Once supported
         * and we could PTE-map them similar to THP, we'd have to clear
         * PG_anon_exclusive on all tail pages.
         */                       

The p2p-dma use case does not map into userspace, and the device-dax
case has static folio order for all potential folios. So I think this
fix is only needed for fsdax.

> We don't need it in mm/hugetlb.c because we'll only demote large folios 
> to smaller-large folios and effectively reset the order/nr_pages for all 
> involved folios.

I also now feel better about a local fs/dax.c fix because clearing
_nr_pages in free_zone_device_folio() would require static folio
metadata cases like device-dax to start re-inializing that field.

I.e. this seems to be the only ZONE_DEVICE case doing this demote to
order-0.
