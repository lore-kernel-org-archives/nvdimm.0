Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631B420F098
	for <nvdimm@lists.linux.dev>; Wed, 25 Jun 2025 21:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750886176; cv=fail; b=QWR0dJrdfD8NvkCAOAq6Zp/OP9dxFn3iFYhwRpf/B8DRaikaYS3qNargRqnJDFhWz+ZCL7jnpPLlQWsblQ/l98orvkB3ku0Yb+YZ0lrgSO5ts0cJeMr/uXlr7xhXIscDJPY0VpKUeDOuUndziHjQ3VzTbLnuto1gViynQt02yHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750886176; c=relaxed/simple;
	bh=LaomHZIRzENE+rRs5z9MleDqiY1ciIZGX1+WkNp3N74=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qeU1n2cqCjPcU3CtbuHpg6+iPT6kc84hDxm2yZQ0eC8aCWV+LW09ajGeuFtR6qSfWBtVh81PuyveJ2KdFsFd9N9y33zvHXYzX5K34i2rdW/uYAIczxnOyEQifMGe57hX4NKqImhfJyhxD4WRei4068K8rC+ELIVBVs5By5FuAII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cnB1cKJO; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cnB1cKJO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750886174; x=1782422174;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LaomHZIRzENE+rRs5z9MleDqiY1ciIZGX1+WkNp3N74=;
  b=cnB1cKJOtAr5un9OOD8J7J1IHiiz647sy0bh2h1o/Sa6qR5y/ysY7Dzr
   +pW/vRTB/e/KWHzAso5YbpwBQPxRaw1UTo3jt++aeRDLsagK5ZvN6Nwh5
   FgST+LENUrYyMVPwnVeB4w9n7pjs8fUyck2yMQq+pCG5RjHnUAumbkKrL
   msANPWuAxWREtd9y9ON570wwawn8ZXY/Kqlrz7hlH8moROoRxgmhxhnfl
   vN8ywaLPb1GBvOllZmXD6CC9Qn5NM9aRYN6vgZ2Ci+SZB7vpw5mQBOCvh
   DvDRQaIW75Eb6O1IVxHqtw/CXuisOCGjNvDQ5v7ZKw5g4Ki9oWFDy1Bgu
   A==;
X-CSE-ConnectionGUID: e2czwAkdQomz1JPA7aNxaw==
X-CSE-MsgGUID: ExmKReH9QYumMWm+hevC8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="78605169"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="78605169"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 14:16:14 -0700
X-CSE-ConnectionGUID: HlFDLAAmT1uQWxRBD21FxA==
X-CSE-MsgGUID: 4MQAEQA3TT6c83QKfLxTrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="157825456"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 14:16:09 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 14:16:06 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 14:16:06 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.78) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 14:16:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NOYY65EuTB014B9gvEPYA53m5ZRihuNvKzFyz13K6X+GdHmJYU79xGTqsUCXX1js5HZ14NNod3zTrwSQlU/IsqDgF+nhz8Lx3a/K0C0NwUrmosL557OrS/htAPM5xd1Y1TnPtmTHbiCTDCcUmW/pzu3eA+48xglGVLR43p1yamrk/eYADWnybJuv9sxNS1Y+GDXyJFim11ooPXIedlzJzMzHcC7rfWAH7v0jJFlCUBF6UP/SuCnuXiSbxWJ409fI4vA5QOoTP+jVe3krYLsrJA25YlJioMDJLbJuZI2JqlcbGx4gaDGWf3Jwt5Ymxk2ZCERt2MuH3hfRHd03DlVEJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5UgbHN8kyYecKv7XSnfVY4S3wAlLbC8oX6rB3BN4QU=;
 b=viNPC4jJhfPxIY96zo6EcQL//h9r1lxsfUq9qu8j4mvKkuYT8jSaa13uKfD2AM4RZW5IgTGsaITzePn/CjtRWYxTbQ9YC8SMoLhNhZmkthMmVSYS70XlCcmtBce5SiCP7ApFnSfgVhZvL8AE2Ff59QlTcYRu1EIypc9r0Z3GMeC4NFe1Ahn34FtOK+3IkOPGaNwy2AxhZHvXKtbLUPaYkgpUv9rW1QZc5RHbfzHwxy7cUD+LXomTcAbSDDdyIL5sD4LESwbI/7DwMEKS3JtEg+Twx8n0NPxb1Y/NmT2AfzNiuFZwSTZ1hLKA7xFXG4KY358COZ0w/xZtFY/Z9pneHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DM6PR11MB4708.namprd11.prod.outlook.com
 (2603:10b6:5:28f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 25 Jun
 2025 21:15:48 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%4]) with mapi id 15.20.8835.018; Wed, 25 Jun 2025
 21:15:48 +0000
Date: Wed, 25 Jun 2025 16:17:06 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Michal Clapinski <mclapinski@google.com>, Jonathan Corbet
	<corbet@lwn.net>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, <nvdimm@lists.linux.dev>
CC: "Paul E. McKenney" <paulmck@kernel.org>, Thomas Huth <thuth@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt
	<rostedt@goodmis.org>, "Borislav Petkov (AMD)" <bp@alien8.de>, Ard Biesheuvel
	<ardb@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, Michal Clapinski <mclapinski@google.com>
Subject: Re: [PATCH v3 0/2] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
Message-ID: <685c67525ba79_2c35442945@iweiny-mobl.notmuch>
References: <20250612114210.2786075-1-mclapinski@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250612114210.2786075-1-mclapinski@google.com>
X-ClientProxiedBy: MW4PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:303:8c::23) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DM6PR11MB4708:EE_
X-MS-Office365-Filtering-Correlation-Id: a1d5e0e8-6f6b-4be7-51bd-08ddb42d74ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?efxYgff+xwZqrONqdN/lz4ZvFg6Or//ECbIeg91IuNII0mAiOYYmyJNQRUA0?=
 =?us-ascii?Q?659URtL+odtlps8DVXymRLfQQkZAh3dTE5n5TPKfGi2MUBwjgFUP+q3LTKgt?=
 =?us-ascii?Q?owI6pi73rLCHFBlGgzhGhyGLc0bufyKRPCbG/mCb+yMYAWjZmJbH1cG9kKJ+?=
 =?us-ascii?Q?/NtDcSm8bVYPkZlPfppz72v8yDP7lsSEqQ52Z/BQqnZe5C97waEEDPOBoMX1?=
 =?us-ascii?Q?D/xhjcQVji9pp6kbN1b/ZN1SpMfaP5qdI6FX0zeFzXRs+ZRGc3BEx4am/JmS?=
 =?us-ascii?Q?xQ0TWJreUiJltEZvsp3nME36BWn3V2U9jH7qQ5LbWXERf0ZX3gm/vYro+MYl?=
 =?us-ascii?Q?GDkZ3rPOLTyaPslmgP/aSoxaex0u9ZRo2sIcYHJo8LjeLkCUGgG1KKX8NFC6?=
 =?us-ascii?Q?DgrRuxilWxhi6/YF5zfEY8cSoHA3ueqUUV1wWa+Xv8mdHET3P4BCuWFyeKix?=
 =?us-ascii?Q?NzBl2gP6fDdlM0UEe86q0as85cJ9x5enkoWccy3xsQJ9Z12nJDB8p2rP6FUV?=
 =?us-ascii?Q?cwVGNItTdGMgNAhAadRl9fiGOKR6muQJrpQ439rNbHWZjtsyRkg4K2UbV1Dd?=
 =?us-ascii?Q?DcYoWvP08eVFc6L/QaDqO+Zx0vL2vs7nRmmoyNPohTY39+HLl1MjpTitr7zu?=
 =?us-ascii?Q?1zQa2lbno9EPw8ucM7mEPTRR8PH0g6rqZ4IMT+UsH5VVcypvpU9hX85l+Aa6?=
 =?us-ascii?Q?5sznrF8OiUza/LIWkRyTEZholYNz45//cCNhi1lDJ4/KebxoQhnKWKKt1WRq?=
 =?us-ascii?Q?kL3Cg1N2EUdEblnEEr7d60KfhNPrzhAKJ/ue2O+Goej8DSl312o4O/oFAwEh?=
 =?us-ascii?Q?1QBSIBllPPt+tkn2oKWHaMFmGDeeaG06kMrwDj3WycSbb3oyDWlsbGgC+1/7?=
 =?us-ascii?Q?Vzfc3dW+7Y2ZeQgIfDGuoPpSUk5rmZT9zWgHAjlER51c3hFy0+Dcys/UgZFd?=
 =?us-ascii?Q?gs9OerH6zAjc697W2ATOyUkVyraZ2+9Sm0bvF2avyrMXXA7MGXP98ABw4vzO?=
 =?us-ascii?Q?Wos53OvZZa+ovt0U6aILBrLxwiGWtFLAe7Y5W9OVLkcDygsJfjmimElz6cTj?=
 =?us-ascii?Q?qUhHHR1QN7NL/ulnRUHdql3wvmI4csEldGknwArEqxM4yRidKKLy8Vc+zlSo?=
 =?us-ascii?Q?4ATCH19NAJI+C3Nc/OjxLFXplP0OJhozkgzKOf2/qDwTxq7iacj8gpmg5bPx?=
 =?us-ascii?Q?v+pWXX2ydZG/FylhO9UeVATXsNX1ylAr6vxcJD3npRaLi5zKI4RhoKrT+viE?=
 =?us-ascii?Q?Knxwnki/C/dfY5bxObJAoyhkfQJdQ2r30blinW298OJu7a0iKrjGyzx1VDq4?=
 =?us-ascii?Q?0lgPMGrdYrLhnduU9ScEph6W6kF7IiOBXhr7Vnox22ryY89Up2BMIZK/1Yp1?=
 =?us-ascii?Q?hKGYYQTbq7PDDi2zpLoZMY9j57AGTCnNI2mSA4e2qRENXb8CgZ761HwaQ1Zm?=
 =?us-ascii?Q?28r0CLL6IaM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xRCeFQviTPSkDF64cGn3ezDMmeKW8viprwaVtxQiv/js2Mvlyyf+8BABuIBV?=
 =?us-ascii?Q?4/2j+2tUbCuHPsqeHobi3CanJSwXQH7rHfRB6mCfBPYOvU8CLOF4w3nMY6I5?=
 =?us-ascii?Q?MeD53kJY8AsOswOZ4ZwSmom8hHgjxLmJ+QnVWDkIbXt96pjnQnTtJfPTL/j/?=
 =?us-ascii?Q?3a3AdIhEBlVQTcMBNvQhCuEWghSv+e0gohCCN9bqIZ4WAY+nOEAg2d5jVPyi?=
 =?us-ascii?Q?VPRLne37YgG0ki60hM4A+eZjJ/Bf1NAPvLYg5scYNehG4IvQQJifzKCNUH2t?=
 =?us-ascii?Q?FIiQs7uMYw2Nj3nl6Uiq/zE1IileHLCceEdWuj8h2j7E68hbqBRmu5hsjdtc?=
 =?us-ascii?Q?rEDpCYlrq3/i1qel6RcMSD8UIfLsmTtFJmq2z9zOn7sxUHMv2nbdiLcRV6xT?=
 =?us-ascii?Q?b+58fx7fB6ip/IK7wDyeHAY2x8zrSl/Bb2D+vX9WJjZyoRsqVGELc42Q+d9N?=
 =?us-ascii?Q?aHp/9jfc4US/HzwJoAgvNTeixPBshrcnSS5oHcoou96P9CtNdlxlh0pSaQip?=
 =?us-ascii?Q?cpHwo5+8q/sfeqJ/Zxur0H9ihuDr8gLJRgxamFw1BE1X6Y6VDXBsCVjRkDfX?=
 =?us-ascii?Q?AcRtOsFEJBqLqMVd8N8VAxKSqDdWif7KC8o+I8WYfYUkxiEN2QmH7oZ1tymS?=
 =?us-ascii?Q?GkOXuqz9T6DmQNUzPCWb6ehGn/FfYbXtbgPb3U3ci00MDzyFFboDH1uAgmMJ?=
 =?us-ascii?Q?SbxxTVVBpWRVO/ZL7BlELbJoh7wpMW/miSxMZnsHxBtCOpj+jorgYhAPR1VU?=
 =?us-ascii?Q?dJuhQoKdi1aShqoP2nDRCzw3qHol8gDNeBslL7irF1zaZoZ/i7LTGb4zxLnk?=
 =?us-ascii?Q?4roWtUO8Md0V8GNLtYzmmrDcmhv+TqEZC8utOrZqq/n3T9HDv7+rRKklsxS+?=
 =?us-ascii?Q?HaZz8ozIAKnalJxe6cvzYpoqfDG6w+JWGfxtztElHarJ19EPlEO3Ctrr4Z38?=
 =?us-ascii?Q?2uSQoOlcLENHhy1vm47QhOz/N6UNjBriSvY+2LC84jdZUQh0fDdfyfCreI5k?=
 =?us-ascii?Q?cK22YWMYqfDFsUfkcKC8SeC3m8RPJUtQvQ3yuy1fWHDWLzXOZtvtdo0j3lGr?=
 =?us-ascii?Q?ImTMWDSdCRS9g+QGivvCeP2fPDBmSlzqsIcPTaiNkadrBVZK+o5zmx+Ul12l?=
 =?us-ascii?Q?/cY1MiO+n0reNdehM9E64srOD8DmZhqmMdw0bTT+k4/N00LESIdGv4sId953?=
 =?us-ascii?Q?rgzFzuzm2EThMV2DnKS8zeItwfIQ2uARtTlHxNf1FfmLtobOZIcO4lktddzR?=
 =?us-ascii?Q?LfqBjtX3qbG/5KbB4BcuDCUPZx9y0wr5KzwdMC2al0o6SqmiQB83BRUHib+W?=
 =?us-ascii?Q?oypz0YyM2OfEHnLbnf2Rvah/YmGjy/tNjoS191VJtOr3gS9q0hrDdfedLH/f?=
 =?us-ascii?Q?b6gSTelivzc83Fz6nlr939EJAnS5Ne7FagYyONVM6YeDuvNm2/aCDr3mgarr?=
 =?us-ascii?Q?XRSUijgvIsZaeExU9Rk4EbQyGBPoK9ZUnelZz+geQDcReoCNcCoxbyQMdAgQ?=
 =?us-ascii?Q?i7jNPkqQzo5Kv+SJSO1E62VLVUxoW8nIJYAs0zRUwYyD3ySIDwFBELpM7gwJ?=
 =?us-ascii?Q?Vskw3nTmrsCjDKSJOAISluIbtiP7BizuLs+Dax3e?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d5e0e8-6f6b-4be7-51bd-08ddb42d74ba
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 21:15:48.2950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O8n7NRhUIeywgqo2VdU72LXH8jz4w1QumtyxDzrqyAZNl+toukUIPULJ5AQzrCgxwEbV19LNV+3xnBxftPYD4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4708
X-OriginatorOrg: intel.com

Michal Clapinski wrote:
> This includes:
> 1. Splitting one e820 entry into many regions.
> 2. Conversion to devdax during boot.
> 
> This change is needed for the hypervisor live update. VMs' memory will
> be backed by those emulated pmem devices. To support various VM shapes
> I want to create devdax devices at 1GB granularity similar to hugetlb.
> Also detecting those devices as devdax during boot speeds up the whole
> process. Conversion in userspace would be much slower which is
> unacceptable while trying to minimize

Did you explore the NFIT injection strategy which Dan suggested?[1]

[1] https://lore.kernel.org/all/6807f0bfbe589_71fe2944d@dwillia2-xfh.jf.intel.com.notmuch/

If so why did it not work?

Ira

[snip]
