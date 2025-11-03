Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEA22C15B7
	for <nvdimm@lists.linux.dev>; Mon,  3 Nov 2025 21:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762204181; cv=fail; b=LYfot/bHEK1ZV6dClwF9DkBLaZLgVIIhf7t6PUENMAka+/wToyR3+3e/PBYZ7lSvwg/n3K2AN7iNdV3W9DC1foYqehJ8U6uASLH+3j4kLMcT680Ny6o31zFEbPMGp/gW0+MhH48CX3emga6fMYPinqJWZPQ3pJ1AoGPXXteOIuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762204181; c=relaxed/simple;
	bh=hau1SaDAXgsJMkjBXQtldlo1z+QmuO49z+wxcCNgXO0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ux6wJO7b5Q/YkMjr9Al2R1Ws78Y4kXKGk/J/kN5y6o8HrM6XA54cOMzCl0SQsdNd+TpHtsy4E6zihsmYnFnkvvFZmEjHPtPeh2LCIDdF36S2tXOcj+W8YFvOT161s6mAx/R0iSn5xkGFcTEavJamT7mPVyLXtCE3OewQue+OXwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DLxnVEwA; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DLxnVEwA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762204180; x=1793740180;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hau1SaDAXgsJMkjBXQtldlo1z+QmuO49z+wxcCNgXO0=;
  b=DLxnVEwAE91/tEkADweeC3Q3XNoc6+x0hcba2eBQQZ6R1RanyAcdfDTo
   tkTRfxbPAgYlG6LD0Qe8jyo2UadjnB9t0jubqpuzHAJuJDVSWj5AnUSjE
   3YJrj9XLhxKnTy+eIW2Pruu26z2+9JOH6QJ9jDPvAg9Xp72GNf/+2RGVS
   OBTH1LSn7NsfMgpBDXg6m/P0FQVqmC59srcjNWBN9wyKo9UkbfriA4D6r
   6rQokIb2YfMhma6w85Vd+/Wx1e5p3kIErgztgrl242jDudLWus4XL/b23
   +jjZ6q0k6J8GP6WhfBLNb6IKtzD5GblIbArocv/JsLePbbJpG50HYt1E9
   w==;
X-CSE-ConnectionGUID: jq3UwHirRVGxVahCC6J/2w==
X-CSE-MsgGUID: zsJc9NsES4qb6jjziVaErw==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="63987710"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="63987710"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 13:09:39 -0800
X-CSE-ConnectionGUID: vN86ntjpQny+ouZojCRw+g==
X-CSE-MsgGUID: Aui+CyJgSCuuqcfkmIZkrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="186211514"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 13:09:39 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 13:09:39 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 3 Nov 2025 13:09:39 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.62) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 13:09:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xmkABHQiXZ7Jp34yEGWF0MwNszVWdPmuu9GxUAzdvvfu9jCxX1tuJWIn7YENhPLV2BpwINKxHoYOfBEbVrCQ0fTo/oDje96TajNWKYyEdFpTuUxqx1iBhvUJOesE1xyT1OLGP2ZLw1hegpwLHYZT8+wne3F9F2LjtQd+8J3yQshEJNJnSxssfzsuyVKR0pSkeZyZlvm6wy2RVytMFUwbJjYlWTycSOZfcQkv24JBgGY6RVr1cbfj5yOPmNCVjKzuuPkzEBydtMEaxnhFrs6KioW3NvtEeexIjxhWw74MXE62YLf56la0qqjbmTDav5LV7NKmp8uGlbMMwaiy1w+PoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hau1SaDAXgsJMkjBXQtldlo1z+QmuO49z+wxcCNgXO0=;
 b=fCLRTLG6qn5KIvap8MeSsar0yJKMQj5uGIrWBDQCTvfbDe7Ucw7AyxSJi1tQvgc1H5Pf2YLWnb01iNbGhylIrapj0NIpjSH2v1rh28EN+6ftaVgc+ldRg5x05iec7AlJAKOg9zIYwQPTpe+mh9xWU8nRcGtmxofp1IG4tug0ZOlBDD0SDFnzuoevYYhbemI6mfn8wGQZSdmMzT+KUTk7EVpU29DuPet+jSyjVOsSDy4Tne7pm71qS1teoqg8nLn34Va0CWPQ6WrHEN6YalfSZSm32mdugCHbKTN+MW0j/C+skzLXzY2W5pzFVyoJIMhij1x7REOutbV2clP2KBKCbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SJ0PR11MB4864.namprd11.prod.outlook.com
 (2603:10b6:a03:2d4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Mon, 3 Nov
 2025 21:09:36 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 21:09:36 +0000
Date: Mon, 3 Nov 2025 15:12:03 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Mike Rapoport <rppt@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>
CC: <jane.chu@oracle.com>, =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?=
	<mclapinski@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, "Tyler
 Hicks" <code@tyhicks.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM
 DIMM devices
Message-ID: <69091aa37977_252852100e6@iweiny-mobl.notmuch>
References: <20251026153841.752061-1-rppt@kernel.org>
 <20251026153841.752061-2-rppt@kernel.org>
 <aQj0rV6R_KCgzr42@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQj0rV6R_KCgzr42@kernel.org>
X-ClientProxiedBy: SN6PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:805:f2::42) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SJ0PR11MB4864:EE_
X-MS-Office365-Filtering-Correlation-Id: 13730538-b9b0-4b72-f016-08de1b1d4b12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RyysLQ/gQRgpyf5ukx0sag4Bvr20syjbo5aZCxCWvsDU1nvkDGJEA58tnYSS?=
 =?us-ascii?Q?NoO+qqeMT8juCBm2WKr1FciUfYF/NytepCAsP5wXm90kmfcYxplbNNCQfwNT?=
 =?us-ascii?Q?SYVSu3gdQi6Wd/1xCgsYVzwffZtTfttAgbDTGfnJqxW2itRqfF9rH/WKlQhE?=
 =?us-ascii?Q?9a497EieJz+qNfHkyfluzs6D1J405pQKZ/tP7lzizIcW0SCzwlS5OjN1K6Tk?=
 =?us-ascii?Q?pf0/Jioe1pGVHAtH+985bAM6CRddQCzR49iRBtUQP1baXHCy6D2DnOcQFPlK?=
 =?us-ascii?Q?ODaq5TJZqHAqfvgtqIqyJhSS8Hkq7a3ZE6Xc6sB6xUILupfygV8D5Y0A50C6?=
 =?us-ascii?Q?Jt6yW8d780feJV+CGq4nh+osVPeyJ8vK8E49RIs265Vbgwqz7Lj2vpLyBZCS?=
 =?us-ascii?Q?pyPZV1U2IRoA4HqIiGHB6cry/M0rtjqU+2d2G/p/Egtfxqm0VrK/TMto8B4f?=
 =?us-ascii?Q?WXEd97ByWtW8LQEkgYUXI5buCO0WHCBczxpXoOIQQnqE8Xit5+UuuMZ5ndnu?=
 =?us-ascii?Q?RC+df7c/d4kKpIeZpqCyEYMJn20QQLBvV4u5GwY1iw2M+Fjo9pLGmLhLiY7p?=
 =?us-ascii?Q?hpwP+W2hzMsZMqUO96FZNLwVlkuDvhPq3j+LkfT1Z/qa3Ws0zBkLu5NylgCb?=
 =?us-ascii?Q?IHmN15RrkF/Yx4ijy68lu3uEFYfvA+fnV0iRt7elsManYjOueG/kgS2KS0Tb?=
 =?us-ascii?Q?xNnKwxowoWLQOqAI0Jqmdu6tcwTAEqy3MztkyiYKTVJnm3QzhEZEkr+yBAx1?=
 =?us-ascii?Q?6kz9EQJ9yT4xr0ItFeA4OjfE613Jj6FXdBhWJruoxyX/fA+jtfEf7iX2L/Pv?=
 =?us-ascii?Q?DzMt/E9tBFT0rH4UC0+8auNtSVQFdy/AW5wYtF+MiA7RaiTaR3WTlb4oYMfn?=
 =?us-ascii?Q?+FxWbq/ULVcviQNgFUDN8TnswAGQol2m3BtLEd8R8FrFl/lrNeV9wWtAmhuL?=
 =?us-ascii?Q?/iIP7wqBcYwO5GbGTVXvcoeeo8jwCTET9663FRjteBUrnmVZiRlo1oHpBJpE?=
 =?us-ascii?Q?pjMJ04AukO+YZ/5o4jzpJyNRsAs264q8Pk6e+uDqlpJz5yM62jgRTOBVZRlw?=
 =?us-ascii?Q?vT5mXouBBY/bIOAdyEDKf0j1bxjrd/fLnoEK/0qZiDUT0rsddZcZUHN4NVxe?=
 =?us-ascii?Q?cMG1QFM8mwAvJCgW7WoJ6MfPi5d/69EXpzPNnp9ewlfFVpi/zNZF+r2r3+l0?=
 =?us-ascii?Q?VWaX+mjw+9B0pC5/dX3nH+0KxdqZzQeY47w9+tc60tSS5yPKAZ0YuiLWLJsc?=
 =?us-ascii?Q?UmzXK1NocO5ImKHT/rOUcvVRV3FrWFV25f0M7DaXaATZcUZG62uT//xuXNXx?=
 =?us-ascii?Q?eCGnrqfgovPI2Sgcf943MnVmxB4RdpUlweLD3/z0KeGmXph5DNF2fyDmRKzg?=
 =?us-ascii?Q?a9wtDdNhrMuZ5AbiSLcfBWSaMg5pAcldUGulD+wdrm27pYN7esEZ6hrh97A+?=
 =?us-ascii?Q?xR+eBJ1+7qGlZRdms+3youSEudEAO/Pj3Va+2Tr1aSwkItHRGflItA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1ukZKN/Ufly3pTjg1DOre7g5yIKjRLC0YmWW61HTsPJSb4ZIGnqF+spoWbzT?=
 =?us-ascii?Q?fwLn5FzI3GYBu7mwxa+RnZ4wLnnWAaX9pM0BuLyqOFLQ34a+gCgoiWrBL6gH?=
 =?us-ascii?Q?dPugLoQ6oRFdrJ+LcGDMMQv+ywitV3t6zWL9sj/e1ss9JxBhYThv2NgWNJLo?=
 =?us-ascii?Q?AaPUeqBGI2LbgJfoar5ObFusPZxeOjaTB2EwRlo6f/85/9Pj+G/yUoCKsg1B?=
 =?us-ascii?Q?4BWP5Sm0vEtqVpPfMSujg7tuYIqXAL7hY9lEcxjZNFZqsp/x+S6Kl7paaRPI?=
 =?us-ascii?Q?pQNX40pqTmBwuzjhu6Zg7wEV/zudNS+v7IjS/nfVfQXLVk3cQ+YXW0rpSZeb?=
 =?us-ascii?Q?nqs6WOAyz96HQj5g/wEYAS8zQEh1ZhyBeTMbcvQPVC+r+vo1nNT+RawgMTp3?=
 =?us-ascii?Q?cwpEt9jufyq4hKs3NdiX9BB2hoUlS6coGvKchAulMUWR5gywhCKde7w+qNep?=
 =?us-ascii?Q?7hBl3LL0l6vpBv696MAfw73f34zBHTw6QgVQcYddHYOguCofMdsCQsHcmPP6?=
 =?us-ascii?Q?8VTNGTfQtKx8KjF126o09cJsieLHsC+zWyWoCS4zH3XJTKmCuJ0T4cY5JiTG?=
 =?us-ascii?Q?0hLQjLy014JMM5ms2cAF/sOmqDVvrKq5OXOn1m7CKhDAuiRuzJBHcI/+dx6k?=
 =?us-ascii?Q?m3oXvuURXa/wbsUengR9svprE0M1HiHkhnrYtxpH2BqHKcNvF7UVlvEc04Er?=
 =?us-ascii?Q?E5Auw3AqemHuaCQP9ciNm9na18rjwjAAyXade/BrMaSm9Qx4MaLmqSsaHU1I?=
 =?us-ascii?Q?Ele6Bzs+rUcvuQQkna+zpW6SVA7+zAXLXmbYQM9N8Em9XnWT5wEkXwvRz6uu?=
 =?us-ascii?Q?swZER5GqU48laXbOrfOUC67IxbPB0hDL0aM4/YcPC+GuDyWkfHsi/A6AAnfv?=
 =?us-ascii?Q?qZRun+MPrbhC/Dzj/8QobOyTsQCZ/u/D51LgibELDFYeFHHl2jrQbs0Pcoi7?=
 =?us-ascii?Q?NwrlcT6vXb8SK3mXQsYPQcV+msxRIXWD06UyvYyqzO95hr1yPM0AWg9ewYYZ?=
 =?us-ascii?Q?reAR+tyUDh5M247a9C7zm4B9Z4LFH8GmFb5Udt9CsBfYjoHEwD6O67Lee4Le?=
 =?us-ascii?Q?4dVoUdVchTEa4liLbJvUh0i/i/ARlx3t8g0cLji4tFkHcldcqqO1rIHQUYkE?=
 =?us-ascii?Q?SobJqigAq3O23NhkVQvOq3XTHevMHklEakm69IsrQXD/fV/X2es9suHhO1gb?=
 =?us-ascii?Q?RbgAyFIHOqVu5ZvTo3ijeeHXTfkrLuteKasWVxkveZNl4fhNlfr1it75LAnO?=
 =?us-ascii?Q?BSXHx+Nph7xsYBlH8RQdS52+nmIR5jphvPMtFhn9QMLh81JH1WGNNfSrpYh9?=
 =?us-ascii?Q?cp1Mu3Z39r5aOYEx3YURsFq5JMjIK2NYTWqINqEhUNn4hha7DW1LUesip51g?=
 =?us-ascii?Q?hiOHfXLL/BDIsXk0+Tvak8vWvXt2ObgmSO1nY4JTehnAc3QQ8uSBwZfRO+sD?=
 =?us-ascii?Q?a+LZKotYHeOD77r4erC9Xr3vWbaiFNZWtfAjUSdJ1z/87JEiAXqZwMXwBWD9?=
 =?us-ascii?Q?NVrIUpLKO7BKXig82LJr6qACT+B3U0jwzqNm2q/wu3rriWVn2SXKXlMP7ojh?=
 =?us-ascii?Q?y1LVxZL/wJknjvWj+UYAcXeY2ONtdEMcb55WKb7J?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13730538-b9b0-4b72-f016-08de1b1d4b12
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 21:09:36.3381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qp/Ncn4uke3in8D/xPeFpPKKKRmjijHRuoJgSZJbs0WkaeCQWMXStcDVWXee5V4RZ3VouUEPVS15iQBXAPLGhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4864
X-OriginatorOrg: intel.com

Mike Rapoport wrote:
> Gentle ping?

Was just waiting for rc4.

Soaking for next merge:

https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/log/?h=libnvdimm-for-next

Thanks,
Ira
