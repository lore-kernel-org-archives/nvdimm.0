Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330F9254AFF
	for <nvdimm@lists.linux.dev>; Tue, 28 Apr 2026 19:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777403423; cv=fail; b=UjAgtTFGZGP4RENWBXCOxIknylYmAkPbllqOrbtrB3cAphE2uHwAboa/vER2evYXp4D3p4z4yQPVc571W3JxHecPccByee66A3W7Nlg6Q5x+115xTLgoOCcndihK1HYfiGuQ9PlXfRT5c8+Y4+gdzeUobWNgx4n8alfhTyPjTVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777403423; c=relaxed/simple;
	bh=sTqFkM+j+3b96cCHkzfjSKzhrzzAAG+4sf6xYClKqTs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XZgHornfAWFaa/IWBiP1VtmAUkZHFvKwVhTVSp7OvO0OEGqW0/x9NQEBPzOfCsJFgttAzoYmgjeMasEaidCubhdEEPsnjtagZAPg71h1Fq3bSqFPSTynN+SOFWZDnjSdBB1djd8m9kZeBnmZW+yOByoX5n6kPGKgctZjNe5x0+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PBKcfy55; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PBKcfy55"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777403421; x=1808939421;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=sTqFkM+j+3b96cCHkzfjSKzhrzzAAG+4sf6xYClKqTs=;
  b=PBKcfy55F9l7PyjkUfsHI1hs4CdLcrxiTrYsOajAsUc+/eBNLturHYFR
   fp45sSBvQzxthyRS+DZCFxtiLlmcB8myGjAMMkml+QTIb8H6Vl8xtqW24
   BC1VTkLE/8FE0mfGCzbP6i3LsopkYAoRL4laMG+F/kDPxd5PfOMWFjZgk
   WNu+TBOCRSm8xa9zOJ18X6XM7AXCfMKcwAGcl0or0hYywx8ElzR5q1MKS
   lLGvyrz28QRHGb/qhTHdPJA8p7arPbanwOzq0lfOJYfGCycpjiWs6InHk
   PsisxYRJp7vdcw5d3jW0StWK7bE72Mllb8y3iAzlD6yhmrT+A98HSuTnx
   g==;
X-CSE-ConnectionGUID: nIj9yiPaSyyaUwauaJK6sA==
X-CSE-MsgGUID: JEtqQKvgScOqauperdas/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11770"; a="89021595"
X-IronPort-AV: E=Sophos;i="6.23,204,1770624000"; 
   d="scan'208";a="89021595"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2026 12:10:20 -0700
X-CSE-ConnectionGUID: A2LmArwbQgGft7VWl49esw==
X-CSE-MsgGUID: BX4EnaEFS7WEVhT/X7cG5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,204,1770624000"; 
   d="scan'208";a="238371478"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2026 12:10:19 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 28 Apr 2026 12:10:16 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 28 Apr 2026 12:10:16 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.38) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 28 Apr 2026 12:10:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JBy7nf+evwCBykyfQUI6CHw5Z6h7v+qJCiGfraesyiPUxIi4Ws8VpwgLy/258Ke0hf9C4l9qOOBPYvwoafK6vowOnBq+N3gMEb/i23hLXLHnatfuF4+5w3iBdtxjYTgdExotqouCVi7fxkp2nQfoD8F5h8ri/Q3tmY0kwDt+iKFpY1Zyfwt8GmyNv/+ctn0XMVHGe2pqllXuy6q2wxXXdkNymaMNQC+YYKLYNifM5iZqhcl9zDdBFgHWNmB0sMPbDf2Jf2TzffLpaBlQZabhBjv+pwzOL1GnsJ39HQTEQAZ12sIx08BkbV/EJWbktfaQPgjBF7zMgl88xbnJlfe0uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIiLSW9noGfFyeNs0/B/0Zru38ND6TEUw9eq7Xs0AXw=;
 b=TKStggyURxj1kDAXBoTqdbVEOqwNiZ3KsTt68lacF2czKzNDeVkGCAC22L81zhbFxuuOIrHTwRUJRqKWV++DQMkT1IpRZ/utpEq+kXaHo4C23OTulBYBzIyEazPw3rAZAa9W7HoC46yfVYIK+BMzzbIYXib5OmrTfw5SPoaL35Ct6ufHqbYAlxpx+av3oeiJ3Iyr0E7jXXEWMQRmgyQlcrgUyZQ+Pkw38QiknIx437zOG0Dp/CUfQ93UdHtcBcHqjsP/s4gg+8oy2PU/lTzWSoqFVPK2o50P1ke4C7yeG55Aa+aLkHWbUU0DuhqUtaEyBBwWY7vXJ7SUDbgJ9EODGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by LV3PR11MB8601.namprd11.prod.outlook.com
 (2603:10b6:408:1b8::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Tue, 28 Apr
 2026 19:10:04 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1%6]) with mapi id 15.20.9818.017; Tue, 28 Apr 2026
 19:10:04 +0000
Date: Tue, 28 Apr 2026 14:14:05 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, John Groves
	<John@groves.net>
CC: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>,
	"Dan Williams" <dan.j.williams@intel.com>, Bernd Schubert
	<bschubert@ddn.com>, "John Groves" <jgroves@micron.com>, John Groves
	<jgroves@fastmail.com>, "Jonathan Corbet" <corbet@lwn.net>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox
	<willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro
	<viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, Christian
 Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Randy
 Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, Amir
 Goldstein <amir73il@gmail.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, "Joanne
 Koong" <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, "Bagas
 Sanjaya" <bagasdotme@gmail.com>, James Morse <james.morse@arm.com>, Fuad
 Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank
 Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V4 1/2] daxctl: Add support for famfs mode
Message-ID: <69f106fd55840_12d928100ca@iweiny-mobl.notmuch>
References: <0100019bd34040d9-0b6e9e4c-ecd4-464d-ab9d-88a251215442-000000@email.amazonses.com>
 <20260118223629.92852-1-john@jagalactic.com>
 <0100019bd340cdd5-89036a70-3ef5-4c34-abf8-07a3ea4d9f92-000000@email.amazonses.com>
 <aaD6yQLiyZznfAxr@aschofie-mobl2.lan>
 <ae6e9wYqgLkWsS-e@groves.net>
 <afA51WpcRyIMVukX@aschofie-mobl2.lan>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afA51WpcRyIMVukX@aschofie-mobl2.lan>
X-ClientProxiedBy: MW4P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::11) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|LV3PR11MB8601:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f206237-88c8-4396-1668-08dea559c0f2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: gkhrW2ogwz7Jy6PyCEPL6juTa5yGDnw+kiGi/KLpMJeRWNXjatxIY0ToR8pq7zGY5i7kUeCA9JqdOpt0MsMZcjQuf5+V4qM1vzh8BH+t2TdxrPDGnyz+8npvcnb6i7r1RC27w7CsE8N8D+vmvvZX9ro2zCkWrSCCkCLYsidhHPtywYGW8Dlpt4UbtCf55fJfcSJ4yD6HoDEMvkFvuIf6Zfuli5/8/CSW1Rf7hOmE0qAc/gxKkOwLIoQ27A+F58nLyMnKdTJzsTCoRXudJhmVJgFvuDiu0Eqbyoj4O1BZPqyoJh6xV9dmGzBzQZUdo/ca6lw4GR7Ll3iaEjATCM1gfUN1Wdm07j/AWAC9jSD0VmVnIbt+JMZCwWmLr/NbEmTfAImvYIvMXZGFpbZv5ZTV+TzJ2GgqsFD/wEXez5wQV/6xjozeedGJo7RBh3XhAguvD0KPpZ2NfmG5KvmwhexywZd9BJG2LV0eh29Qnxz2Gz03f+1KT7IxKJqyVhmjCmyL5IhTIKwdgp4l8tdJSRXo8Ox3NPx6naWDo4TsraJLMfK0l0Mg2/tl4wB5J5nQ3ifTJ/DdunIfkjUa9PgkDVXZc7RjBgbPm421gkBUi9LCY2prna8pTCzxELex0vERH3hNObzt11KPjse5Uy3qsGfLjsq4x2P05Z0bEPxQ2mqK9GkOIK6WqxrKbqqdEpXFlu7ZoYsmFiCloFdI8vouMPeUBfV7kDzcPplGC75EqfeMuIU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1o3cVliUmQ2cSttblIrd0phK1pteEFiZkU0ZEt1RnVWbXBzbG0xN0RsSFow?=
 =?utf-8?B?dktwc3NUYU4vSmhTQjBnMms1aGFLNm84OWRaZy9tNm5VQ29NNHI3WE92clRn?=
 =?utf-8?B?M0pFd2kySmhnSGpoWlhKN1U5ajErNXhuU3BiZUFyU0VuS3c0dnV5MXNlOXhD?=
 =?utf-8?B?aERtaW5wblM3WjNqVmQ0NWJTUEZ4am83VTdtTmJYTy9tMXZYdiswTExlNUhO?=
 =?utf-8?B?Mi9uWS9OKzZ0MFVkSVgvVHhkUi9OcUNtWHJDc0RMUDBRQzNyeU9IR3BlTG5q?=
 =?utf-8?B?eW9GVmxpU3lEK1BoRDBvbm5CSVU0cERTTzdUbEorbVBFTE5uc01LdytiWjFm?=
 =?utf-8?B?L0NPbk5GMnFXVEJEV3VmSGxwb2pvYmFlaU5tQzlmMFZjRFRMcGJXSHAzZ2dm?=
 =?utf-8?B?RzNkdTVreG1nVmV6T3dxRmpTbjQ2Tk12YzNWWVFHR01zcFgvOUp1cTJZeHJt?=
 =?utf-8?B?UU1wWGJqMmZ2c3pFZDRoVUJsb3pGR2FjbFErdVdEMy9CY050bWlmckUxcjVQ?=
 =?utf-8?B?WmwvQWlPdlIrUGtQK0kwbDRwZUpxMk90VGxKYmcydmo0OXJPenVhYnBTcXpL?=
 =?utf-8?B?eUs4TGtIRys3OXVQSlFuN0kxZmxjd0QwNjE2aHF3cFJQMTBVVTBQSVQwVVpj?=
 =?utf-8?B?NFdlUzlVK1dNSHlvMk1GaExEd2d6OEtRUldMc25xQ3Z1dkZmSW00cHIrYU81?=
 =?utf-8?B?YUpqTXpOZ1lqU0c3eklKMUxHeURpaW02eWRnN3hMTjdrTDMrV0YwODdmZStQ?=
 =?utf-8?B?cVdPNFl3SDhjY3RyZVFsZ3FxY1k4ODQ1S1RMU0xMeXg1TU1lY1BEWVhHa0Ux?=
 =?utf-8?B?QWEybU5ZdVM5S0pyZEc2dlNmdmFhdG1mN256N0c1NTdLSnZsMDBkdk5EbUpX?=
 =?utf-8?B?YkZwYXFOTU5NMVZiZE9vQUkxK2dNQ29BQ3JsRFB6WGRHOXlQQkJYUUx5RXlt?=
 =?utf-8?B?dDFGQWhiZkdOMUU0WGxsOHh6WkVrZzlJMTQzaEFQSkp4bjBtU1RjcEFScm5v?=
 =?utf-8?B?YXh0TXZVZ3J5Wmx1WmVYZFVDTHR4bnJNV2U0UXdNLzJjM203dnZYdXA2MWFP?=
 =?utf-8?B?aTdkclcwSkh5cFRyOHdNT3Z0YS8vd0xvZXRXaC94NEhVMmVKcGRNRTNOSFZC?=
 =?utf-8?B?blJMMDRzWVpQRE1ieEhmWWNaZkVTN1hMUVpvbWIreGcweHBtOG90Nng5aDZZ?=
 =?utf-8?B?cVZNN2ZBZC9uUkNzUjdxbEZBc3NuYy96MVJFZlZhemxFUUhRQ2hKN0xXa29D?=
 =?utf-8?B?SWh4amg0Zi9zeThKVzNxV0dvaHl3aU9MWHhZamtXZkxOc3hIUlB0TW1qcFhU?=
 =?utf-8?B?SjBnUzVZcVFHZHV5akRLRDQ3dk0zRDZqbjh2bzFXb1VNdGt3dEJ4ZzloNlFh?=
 =?utf-8?B?elhWd1JTVjR4aFBEbG1DSjRlTUN5cVpELzNNZUVUcm16N3NmQzFIeU1OSldu?=
 =?utf-8?B?elkrazBaRDFoMlgrWDNCTmp5Y0gyR3ZRaGRGOTd4MkVQb21oMVpmcTAzWGxM?=
 =?utf-8?B?R1pSUGNsdS83UnhobitISk4yUllCSlkwbXhkblFMdEE3WnVmWWVkV29lazlE?=
 =?utf-8?B?MU5JRklkZmlvcjBWcjQ4RzA5UTRJODVmUXA2WmJxN29VbE8xc0VsYTlIQkpN?=
 =?utf-8?B?ZG1QOTlMcGV3RmJ0c1RuOVpnK1diMlJ1b1d0bS9MWlJkemd0THVWVkRUaXFU?=
 =?utf-8?B?d0JiUGlNUmdGb21HeE9CdTd0ZUVjV2V2SitnVEhxYlFjVjM2ZE93ZW9WUHRQ?=
 =?utf-8?B?YWk2REViOVE1MjdzY1lnQVhoME9aTlBDUUEvTDFvVmpuck81ZjlTVlRZaWtp?=
 =?utf-8?B?cUlhWXhrYjVWR1pBNkx2dlF2blo4T29FYnI2WmtkcXNpZGhsUHJjRlRic3RT?=
 =?utf-8?B?aXkxL0tqajFyeSs1a1VQZC9SSldkYVZPeXlMMnBLeHlzbEoxUW1vZGhVeWU3?=
 =?utf-8?B?V0dFQWFDdzhyZWFpOTJSVTlpNVJsT2FuQVdid0ZySEJrTUQ2Y1lLa2oxSlRk?=
 =?utf-8?B?RmFsV3dxb0lsTFc0bDkxR3FqK3gwbVZXTG12bFZNS05yN3NVdlUyTldHVjZK?=
 =?utf-8?B?YWEzRHFjMHJ6ZVVJbTl4TXFoQ1ZJbG1lc1BNcWNjS2hZRXlxbFFkWkduREtE?=
 =?utf-8?B?T25oVVpWY254U3FDUUJjL3NuTXNQT041KzRrRVk1MnpyQXRjOEJPQ2R6b2Q1?=
 =?utf-8?B?eUc5QVdTWnFQdTBNc3ljU1FOQzJQM3lXMlJGbi9Bc01CKzFkcWFjL3ZRR3lq?=
 =?utf-8?B?VHB3VkJZZEVFL21neWNJMnJWZ2RNZ1FkNVlrOU54cm5hbyszMXUxeS8wNXI3?=
 =?utf-8?B?RUoyRHBBcjhkb2U2YTNUTFRIMThrMzFFKzF0VkhnS0x1M0NpVlFCUT09?=
X-Exchange-RoutingPolicyChecked: H1eEtPqixPntTOM7l4o0ZonqwgTXMnSApjj1+Ccn1EZ6wNXCBxQoReVJmxqGVHzZnjFUXgmP5X2WlsXxuV8apxAv9OSB5yoJ9JZn3t2cT3N07PYeRkOiHMId6/PxOkeBv1swvHyVH/Kz5H4xP+nPMO9O1DMv6gio4uUd3XQ2J8ktLWJzdd6ZolwlNjV3xOQPNZrPlj7jySyQawMmk/O7KdjLpcmw+ggnJfzkNUl8jvl8uR3tKmMXQqTXy2ZKj867KAVDxUQSbdd4pFb8+WE74VFoehgDIe3mJTuMOX7tTr+WCkFZdc0YWR2tyO9zPhgJO1DoUgbHngj7+ijJzBgZ7Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f206237-88c8-4396-1668-08dea559c0f2
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 19:10:04.4778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlFk9L9V1WYvnXHwqVBvuxLWQ8oQfAfK0y0twyxQ9HIvnUSsZu615pTF6wyVdBJyv4qrzUHeKQcLfmTI8huNQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8601
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Sun, Apr 26, 2026 at 06:56:46PM -0500, John Groves wrote:
> > Maybe I'm overcomplicating things (it's one of the things I do), 
> > but I'm still struggling through how to address all these issues. 
> > Some comments inline.
> 
> 
> Jumping to the part you commented on, which I think was the biggie:
> 
> > 
> > On 26/02/26 06:00PM, Alison Schofield wrote:
> > > On Sun, Jan 18, 2026 at 10:36:38PM +0000, John Groves wrote:
> > > > From: John Groves <John@Groves.net>
> > > > 
> > > > Putting a daxdev in famfs mode means binding it to fsdev_dax.ko
> > > > (drivers/dax/fsdev.c). Finding a daxdev bound to fsdev_dax means
> > > > it is in famfs mode.
> > > > 
> > > > The test is added to the destructive test suite since it
> > > > modifies device modes.
> > > 
> > > Make it clear that it is added in a separate patch. (and assume you
> > > can drop the destructive part too.)
> > > 
> > > > 
> > > > With devdax, famfs, and system-ram modes, the previous logic that assumed
> > > > 'not in mode X means in mode Y' needed to get slightly more complicated
> > > > 
> > > > Add explicit mode detection functions:
> > > > - daxctl_dev_is_famfs_mode(): check if bound to fsdev_dax driver
> > > > - daxctl_dev_is_devdax_mode(): check if bound to device_dax driver
> > > 
> > > 
> > > The precedence check (ram->famfs->devdax->unknown) now happens in multiple
> > > places. How about adding a daxctl_dev_get_mode() helper to centralize that.
> > > It could be private for now, unless you expect external users to need it.
> > > 
> > > daxctl_dev_is_famfs_mode() and _is_devdax_mode() are nearly identical aside
> > > from the module name. Refactoring the shared part into a single helper will
> > > also make it easier to add a daxctl_dev_get_mode() without duplicating the
> > > precedence logic.
> > > 
> > > > 
> > > > Fix mode transition logic in device.c:
> > > > - disable_devdax_device(): verify device is actually in devdax mode
> > > > - disable_famfs_device(): verify device is actually in famfs mode
> > > > - All reconfig_mode_*() functions now explicitly check each mode
> > > > - Handle unknown mode with error instead of wrong assumption
> > > 
> > > Wondering about 'Fix' mode transition logic. Was prior logic broken and
> > > should any of these changes be in a precursor patch that is a 'fix'.
> > > 
> > > 
> > > > 
> > > > Modify json.c to show 'unknown' if device is not in a recognized mode.
> > > 
> > > I think this means disabled devices will always look unknown even when
> > > the intended mode is devdax or famfs, but disabled. This seems to
> > > change the meaning of mode from 'configured' to 'active' personality.
> > > Can you detect the configured mode even when disabled?
> > > Perhaps a man page change about this new behavior?
> > 
> > Good point; before famfs mode there were just 2 modes, and 
> > not-system-ram == devdax mode is the current standard, even if no driver 
> > is bound. At some level that's a conflation, but I'll revise and stick 
> > with that unless you have a better idea.
> > 
> > Is that how you want it? No driver == devdax mode?
> > 
> > Any thoughts?
> > 
> 
> I do think we need to introduce "unknown" rather than keep reporting
> devdax for all non-system-ram devices. With famfs added, that old
> "not system-ram == devdax" shortcut just isn’t true anymore, and in the
> unbound case we really don’t know if it’s devdax or famfs. I’d rather say
> "unknown" than guess wrong.

While I like the explicit nature of 'unknown' we are unfortunately past
that point now.

Current users expect a new device to come up as devdax.  I think a new
specifier needs to be added to bring a device up as famfs.  Because this
is the new way of doing things it may be that famfs needs to be specified
explicitly somewhere.  I'm not quite sure where right off.

But the current behavior needs to be maintained despite it being 'wrong'
or a 'lie'...  It is just the way it was.

Ira

> 
> That said, I don’t think we should drop to "unknown" when we actually do
> know the mode. In particular, disable shouldn’t cause us to lose it. We
> already report state separately, so I’d expect something like this:
> 	mode=devdax,  state=disabled
> and not like this:
> 	mode=unknown, state=disabled
> for a device that we knew was devdax (same idea for famfs).
> 
> Also wondering about behavior here: if a device ends up in mode="unknown",
> what does enable-device do? It doesn’t take a mode, so if we’ve lost that
> info across disable it’s not obvious how we pick which driver to bind.
> Before famfs we kind of got away with defaulting to devdax, but that
> doesn’t really work anymore.
> 
> So I think the rule should be: report a real mode when we can, and only
> use "unknown" when it’s actually ambiguous. That keeps disable/enable
> workflows predictable.
> 
> And if we do introduce "unknown", we need to document when it shows up,
> since this is a change from the old behavior.
> 
> -- Alison
> 
> snipping here, I didn't see any questions or comments below here
> expect for the done on the PATH_MAX usage.
> 
> 


