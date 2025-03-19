Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B0B2144CE
	for <nvdimm@lists.linux.dev>; Wed, 19 Mar 2025 19:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742412864; cv=fail; b=mpqN0sK/+2nHyQlLpMtdZV0HQLiB2ZBAPc6BlZch6wDg8yV//yXAncwfhsvKxz54kMR+R5Ah+Q+Esq29o+XRRqPAgMUPN3A2aqTsogDR4dEKEpy8lz2Mr4vPUOujQyZrTAafPCLzGtP5AxL5pBXneQo9X1UWUJ/5VMbzROz/IoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742412864; c=relaxed/simple;
	bh=BOuHu+tY8pjXxAna91VxWcAlrHKzNQpabG3UkpWIJIo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X4g9DCSLGM1ZO2RW2pQ3qkXh9X5MUmth2ZyAJF6gH+3yPDZn1rwj84x+hncCBne3qpTdrpWM7weB6y/NFH4AE0vqjWHq6Uczww5YeBVwxCFl2W0KKfEbemywe2bRflPcwpHjXCxGhWS4U8qVYN7hzKLotTrQsHXrClLGwNGDCuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RTAomd1i; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RTAomd1i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742412863; x=1773948863;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BOuHu+tY8pjXxAna91VxWcAlrHKzNQpabG3UkpWIJIo=;
  b=RTAomd1iKxIPG8RHeXl8t2WcR9oHxytbY3WGEJ1sq5X71jec8siazsKx
   j53X1UvkwaYemq5K6qKDJaMT9ZpW++83hjKYSTNqVPvAUDJTRpWl9j8Hb
   4mMQmXGRIWh0Fxu3Je1BAOQG8QY4gUZNwnW+QD5/N6YM7mUCkh0i4w9Vk
   c+/YjCvO38VElSMecZXShYFCdORzQlarB93KlfuwTYYY+sCAP82NvurV1
   lj6iS2MfkN8nPKGj5V/4okzPfTKoXjhsSRTbT/OIduMmtQQuohWlndIfi
   E9BZ6tb8Dymz7R38sCTC3//JLmUbqwluM/i4jlXz4uFz9gy/udvKacvCN
   w==;
X-CSE-ConnectionGUID: hs3dBuw3QGCtnxNUUZwBQw==
X-CSE-MsgGUID: 5ibdhnaJRdupPE2V+MQaWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11378"; a="46380287"
X-IronPort-AV: E=Sophos;i="6.14,259,1736841600"; 
   d="scan'208";a="46380287"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2025 12:34:22 -0700
X-CSE-ConnectionGUID: uO3UZ5dkRoqeDQMpya+fRQ==
X-CSE-MsgGUID: /nTByT8wRGaHymjhNF5CUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,259,1736841600"; 
   d="scan'208";a="122946753"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Mar 2025 12:34:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 19 Mar 2025 12:34:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 19 Mar 2025 12:34:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 19 Mar 2025 12:34:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DnE+Hhr0dkJHjnoXDrT7kX38yfWWNZ+rAxPhl3TUNAiGMWam57R3FAWzX9zY+SWh2QN9XoVGN+1FkV7mU81evx/J3uktWitvgIBSFWqgn9RcmDfyRzxlA9awY4pmt5fLBx6srZ1PlS9yEGP1rDeLuLdXf+yNf1wkwtkKCapZnNF8VKssYglNayI9w5fBdNMnXnrdSXu/0PygqqBsMldXYZaBil3QXpCGn9XnhXImGoo00U69JH68zGpAYvn3PgqQlUF90k7BAlCFyJX2+K5W8LAw0IH7LQs/+DnCtO4/aUvNkdvdx+rhRiQSrCAVnmrPJ581/EIs0IhnPZWsVKGz7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/O9cTsBS0mWDWDUjfXMDjEkcTYlPGwqE3L0rsj3kTjU=;
 b=RRuH7vawnXVURstBjpggVqloFurdB3YDlZwCTu6pNMfpLwOc6T93NA2GqLCK5Cegbp75DIE6aRjnAhT+6PnchkWse5E/ujMsDGmNeEi8PJxojjzHe/DqP7rD80pOcPUB94pEoadLeAHNFPVERmNl1iNJDHhqmKu4CzjMmxHxy9Cog/tAhv51u9+KW/NkuGqY97ID5eNI61McrgqUwUoNxs/gAjyE3O9QSKoNGv9FSZFlKmFSi4PfIN+Eg4fyzFtbQXZxednN6RJE4/Xm6wQzfUFjA+qEamGJ0jGfyXx4BBgvAuiWwZw+e8nelWQXYhoEd+8Ne98VgkO1bIuxk85b7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA3PR11MB8075.namprd11.prod.outlook.com (2603:10b6:806:303::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Wed, 19 Mar
 2025 19:33:38 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8534.034; Wed, 19 Mar 2025
 19:33:38 +0000
Date: Wed, 19 Mar 2025 14:33:54 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Robert Richter <rrichter@amd.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, "Gregory
 Price" <gourry@gourry.net>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] libnvdimm/labels: Fix divide error in
 nd_label_data_init()
Message-ID: <67db1c22365_551042948@iweiny-mobl.notmuch>
References: <20250319113215.520902-1-rrichter@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250319113215.520902-1-rrichter@amd.com>
X-ClientProxiedBy: MW4PR04CA0289.namprd04.prod.outlook.com
 (2603:10b6:303:89::24) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA3PR11MB8075:EE_
X-MS-Office365-Filtering-Correlation-Id: 71a04c8d-04c3-40db-ec5f-08dd671cf296
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qPewl1XiFHvnQuHlD+WkTYJ6TAeeU0z3p/+wHDc1lZOmaF0I1eNXZbh9d0B3?=
 =?us-ascii?Q?gHigRmOQT0aVKRUkEHZ6xSA/yUnufLEeFOSEUMSGbo0zXVlWZhlk1M1no5lt?=
 =?us-ascii?Q?ARo280Px5ExbIdQ6gaLvAlz7Ndo7PMcSIlynhtaeNAxuIpro75D3DXuoUGwK?=
 =?us-ascii?Q?v3DNG5W9m4lZlkBWvOEdq6hKDoKZ4TC8IVSdUcudk+2MFaEbiitmtywXn+QB?=
 =?us-ascii?Q?lTyKZ/2jSz3SXKV0ttsas+6Ut/1FenzzxpH44+4FJnVJD0BjWSvuC0cACMrq?=
 =?us-ascii?Q?EhtyZ3GlOOhxg+14bK2IC6vdoCeTxhGzHZ8N8hpxHrVnYiSC/y02icma7Wna?=
 =?us-ascii?Q?tAGNUV+P/+KGduZyS6MwVBE+5n5Gfc/ns0JDa2bvXJVnzuKrvGy/suSglTEk?=
 =?us-ascii?Q?WlYUY3uNGIAQnPTMseZFDifuC9UzpRirWVnSEfn85KxLUxsQV6qOgY7wYjCZ?=
 =?us-ascii?Q?kuBZv+4aJYJUOkeFBl60ATOC2CyMJnViLcJMlOpFo46Si5iPfwXiIMjVTQI1?=
 =?us-ascii?Q?YUK9/8AMUDSfwdIqjlw25VAU+EEsiNYjggkLVORPnCEcNYFgKeVmJ/GF5a9b?=
 =?us-ascii?Q?1BRjYkiM54Wdgj/P7ggIFMQOUPFU/oUi2m4aV1CBfXHytrS/JxVfar21u00Q?=
 =?us-ascii?Q?PgrjDU45613TNk4i9v62zjhbqr1fnFjzzmzbOMEv32ugbSA4+uBRA0FstBc3?=
 =?us-ascii?Q?B2C69i/L8VqTxjVja4YzIgfTw0rJP9Cfs5JFn9wHgnXvIFCHmVKvVvjCjWcW?=
 =?us-ascii?Q?oJ+ul2Y5TKkPIufBY6YyZYHPzAJT9Q2sgErktkiyQ2RMRJHwbKiAfHQnRpUz?=
 =?us-ascii?Q?HRqUbFTqndrnUxOJgcPyAuoNqYFuhs7IseeSQ5W7iQHHj+Ii+Xz7oO/TTw0F?=
 =?us-ascii?Q?ishu98x9Mv60d3nQq72hd6ke9PXgenk/KaA8U3Wyrg1FGB1BOBQ/vnAH7UoQ?=
 =?us-ascii?Q?S9hPdPDOESyfcmDqHrv/MoBF7S/1fgMvMYfiryDQUcjTJhSMrY/ESV9wJU/7?=
 =?us-ascii?Q?xcMtO+1dt5NmJlVjtNn1BQmkF9RrWIq5fKM4PtAs15aIjVL56p0px+BCcj7D?=
 =?us-ascii?Q?ia19DVXYJfp6pf9uEniTSfzgg0Jxf9vkWgG8wYlf6dE/zCmC5CNpvV8TtfmS?=
 =?us-ascii?Q?UfzxTjJ41125UDE/QbRWSF3D/v9OnUQ2ZcIqzwzY7rI2VwQ2PfWLbRWfny2D?=
 =?us-ascii?Q?l2nxvAVLHxzvbI/s7TUHUDyP1U35wH937MHhgk//O2sTC1OJql30jGr9khEm?=
 =?us-ascii?Q?5q8c7Hbeg5TBSshwdK7353X24NLgkLkLfFkR4oBuHIDBaKkLhtVaK3TP3yC7?=
 =?us-ascii?Q?fQmUSV6KMBWai28iOp2hV2YRHuG2trQV229irBgR+wf1k/AP3N7Yxe9C7r/6?=
 =?us-ascii?Q?tdr4nJ1EnxqCzfBzE8858VR+5N3P?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gv1Y23ls7H5d4L0XmCkt/i3i/0n2n+LbObwWnbgw09YT0o4iqJ/YLpIGnzCb?=
 =?us-ascii?Q?H6hKpQTLwZ/1W/H7pAnKnZLxiPYvmTvOYigsknd6kMW1lhUQ7tVxDprmtrcz?=
 =?us-ascii?Q?hxxm6w9qOoG+cz4xaz0m+xog9Zu0Ae+oQbK0JUC1IXZGAZbHikBqiJj12o/U?=
 =?us-ascii?Q?MYRg34B+6xqfA7lQ2akeQFJlsJ3M365fsbBPrTc8CcbRj6lr9DuvKOhiNXZ2?=
 =?us-ascii?Q?0aDr7HBUw6wvt4IbeYQJknNNzPnTKroSajynodZOUA+yvoudAh7ffSPCjmsW?=
 =?us-ascii?Q?lyokhaqPDMYXlgUh/OgrbxvAt0m2jzEd9l3v6FGcyA/YgRzVhqZWrBjOYy5d?=
 =?us-ascii?Q?Sx3Dn8ZnbK4Fm3M0R9TFmT5dewn4fdozmLh+bbU2WKyxgg28rwPRMOIvWHOv?=
 =?us-ascii?Q?dz6QxdPJHaHezoepO37ERMDv5JulTw8S9c1BpvXRvfvQGhH62hdwR594m3gD?=
 =?us-ascii?Q?35AIluVrAp39BHadaNKzeOPWKN5VOG/EPisAukYKo2UdeazhMXVxUK14qFNs?=
 =?us-ascii?Q?XejBt6sFoo80eAXiRSCBp5f4bP/ocMJURcUmi/e9LRaQ5YGriFjLnK8kmMKJ?=
 =?us-ascii?Q?PenZ9LK1nO/aVynzFXhMwGq87n6FHg5FXIYveZd2SeqP8V6+VwTvYeKVYRd2?=
 =?us-ascii?Q?XaY35XURH88IABKIV8JvHLJuTcYiySAJQz8QFR+NTCSXvhNpfoG4qkfdJHjS?=
 =?us-ascii?Q?vU0aS5CIjKUvAS0J5UoTvWdIDC4Vxx5XBnPV92/YY+flqf+gW+dNYt3T5RhF?=
 =?us-ascii?Q?8fPcBA2EsBOHAtvrqwcGCWNufg1t+hXT2XZkFypmtdJ03N6YZ0thWyNWuykq?=
 =?us-ascii?Q?p+ArY96Mp4Es3+ZsREk6eeKA6B8KOmZdXhUfSuWg05g/lmk+1WMfiuOC6iMC?=
 =?us-ascii?Q?Gx8hWX3M8pZjZ7RfGIm3x6sUh+lWAI/wtWLoDRP1HIpRuatXX7EslLyxnXHu?=
 =?us-ascii?Q?XWZ6n04OFudTSMdlMWwMDm2PYFUD4Lk3k9RdOZZjI/SrYrZFcKUDUCgJEhQe?=
 =?us-ascii?Q?wDwkhNm/JS5P88TZb1hBtoebemWwq0U2CE8MNrtxDBdPRpQUuHHbbo/to+K8?=
 =?us-ascii?Q?qa27tDMoUqeKTMIkAkWHstLCg84pvibMViHYSf2HSDq/Wly6JSkZwB5ac0vJ?=
 =?us-ascii?Q?/Ew9QpHU+MDAtGyLUNUptd0kTdwtm5WBFHvVeMmlQMct1Rpj9ty3pgNbSoh5?=
 =?us-ascii?Q?gJeQaCVJYka8tsB5DcIhAtxu10EVmn++SOqGt2+8nFqjJ/0VnDb3ZRWxrUAw?=
 =?us-ascii?Q?NguMhLTVkL5ETv+RQWiNWifpTzPKmTU8JfhaPE9Oswie2TlOyiHZl9FB/vU2?=
 =?us-ascii?Q?FbPaxyPVlng13hDBK7p+z8zGCKdNCZIpiJmCMdfaT01nMjYp12uHUTnUOyIX?=
 =?us-ascii?Q?y4zNQ1z7nqTQ21qlTvW/Cb7Dt3RHSc3ky0ls06Uy2yXhaBmHsV6PpbZx3a0c?=
 =?us-ascii?Q?dTBAU1zbEZh5nvcfLDV1giCR9iP0IhsJRuZYbteebYvmPg61uoFSbHy2CCAZ?=
 =?us-ascii?Q?4UEESAA2CuwFLPHd/AYz3foj+U+n5ZtfHCvilyH4a/NvBZvQZ5tWvyVxGev9?=
 =?us-ascii?Q?Jzz6CL9JvuyMA1vjYs7Cew8jR/n+H3FcOJwi9TGg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a04c8d-04c3-40db-ec5f-08dd671cf296
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 19:33:38.4516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/rtd+QDBJNNKQkQmKhh/YqwhLmh6BJObwxGchSw8Iz6MKv/LhJvMIv+131JE81JASW7P2/K4z2BCQP7y8Ab9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8075
X-OriginatorOrg: intel.com

Robert Richter wrote:
> If a CXL memory device returns a broken zero LSA size in its memory
> device information (Identify Memory Device (Opcode 4000h), CXL
> spec. 3.1, 8.2.9.9.1.1), a divide error occurs in the libnvdimm
> driver:
> 
>  Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
>  RIP: 0010:nd_label_data_init+0x10e/0x800 [libnvdimm]
> 
> Code and flow:
> 
> 1) CXL Command 4000h returns LSA size = 0,
> 2) config_size is assigned to zero LSA size (CXL pmem driver):
> 
> drivers/cxl/pmem.c:             .config_size = mds->lsa_size,
> 
> 3) max_xfer is set to zero (nvdimm driver):
> 
> drivers/nvdimm/label.c: max_xfer = min_t(size_t, ndd->nsarea.max_xfer, config_size);
> drivers/nvdimm/label.c: if (read_size < max_xfer) {
> drivers/nvdimm/label.c-         /* trim waste */
> 
> 4) DIV_ROUND_UP() causes division by zero:
> 
> drivers/nvdimm/label.c:         max_xfer -= ((max_xfer - 1) - (config_size - 1) % max_xfer) /
> drivers/nvdimm/label.c:                     DIV_ROUND_UP(config_size, max_xfer);

I think this is the wrong DIV_ROUND_UP which is failing because read_size is
never less than max_xfer is it?

I believe the failing DIV_ROUND_UP is after if statement here:

 489         /* Make our initial read size a multiple of max_xfer size */
 490         read_size = min(DIV_ROUND_UP(read_size, max_xfer) * max_xfer,
 491                         config_size);

Apparently nvdimm_get_config_data() was intended to check for this implicitly
but it is too late.

Anyway all this side tracked me a bit.

I assume this is a broken device which is in the real world?  The fix looks
fine.  But could you re-spin with a clean up of the commit message and I'll
queue it up.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
