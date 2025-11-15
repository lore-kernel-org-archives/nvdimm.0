Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFCA341AA
	for <nvdimm@lists.linux.dev>; Sat, 15 Nov 2025 01:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763169653; cv=fail; b=j0GGDqBjahArONtRL1Oxe3KfYHdYBtcj396lfTsZohBjPneArZs+yWBVRC2jbq+aeeTtaNZsdTYU/qO4zYX139LzCq12Am/pJvDlamPrJs/Z+zGGDVDZE96wzquOws8/5BvvTb6SSY7LyHzvZ2OUkEe0o4AexrtF6Li2IDZT8HQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763169653; c=relaxed/simple;
	bh=4rbbBZvq5qMoIZkYP2z5q5NGnNy5M7BLZdtYOsbI/Uc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HQaufB5El0J3Sg3NbPXxmlN0eE2u/8vtCWye4N8Ez7mW6lo5oekLHkAuUvjtXaTXCjIAXmyiCy3RzXcA0xuPoOzJ2ACiEWP3kWE2F7hrotQeLQWUSYju34ypURosGEid9cwp29NZ2Zs73fraMvhsDGRxd+4pnHyQUvZ5FrU/kMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g10ySCm/; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g10ySCm/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763169652; x=1794705652;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4rbbBZvq5qMoIZkYP2z5q5NGnNy5M7BLZdtYOsbI/Uc=;
  b=g10ySCm/12pM+ZVu58I9VkK8r/cVWOShDtPLUL0dvax0UHmXImLX7N/V
   OhMYl//2OPoOcCmdz6LL9wZgIidu9amt70GwoYjHM6UvJr7GlEuk+iYbI
   u8JH+tLxisXBu4zxYPy8pnj2oHfzrBlCwX+v+nZlBqW68yMSKR7I5rAPY
   bJPeWv5RTnqhA8GbGDswV4R9u1eR2i9BMxkiELVqu0eY3mhVt2yoctv5V
   MqinZ1gQYP0PEaIC6tb9nRdfIGYoG33BMcxj9KZ72iryi2pPWaQ45kA0M
   YpvQZOZPge2P8H6MrwGC3T9KeEswFQPWxDrWo5z6B7JsqY7hb2VOySobV
   A==;
X-CSE-ConnectionGUID: 1yiF8TRuQzKETgfeXB7ElQ==
X-CSE-MsgGUID: FZh7kx2KSZKdDOZpzSqESQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="67873728"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="67873728"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 17:20:51 -0800
X-CSE-ConnectionGUID: BKaXbEhAQCGeHt04SV3D+Q==
X-CSE-MsgGUID: R4JVrF3bTF2QCdP8+CBJxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="194896847"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 17:20:51 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 17:20:50 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 17:20:50 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.68) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 17:20:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xtDE85GDssTnop36P7TqmWxf8GFHOyH27iS10kTnKvHkObY30DkGUQjy7OwbNc4/NeniscEbeBC3cZMA1R57GrYGZWp9zokB8Db99y5dlMya5ybBIgKnp7Q990MTZ1FbIuIg6AB2mtkL3hy80VpPHyZfdXoE28y3GKAuQ82IOOKls+6sTdEzMMoWv6cKXTcp6WwctSl6Egur3Uqt0WDnr+AnEgZGkCGJD3GsfqCgdmcx9Lx2Dl+ddTWKGPwbYTaVy8CjZeMIFqgzmY7QxqJE/sbXL5JpiN21soQnL53UBkX5RfYY5xI+KebE2LrhVO8fJMNv9BgwNTmviQRhl6hWFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ui0GPi9yugFqRjJM+sob9VJgM0egPEUd6xGM7M1LRCc=;
 b=YOKn8TX/lgWfWu/ALh4J9E/+AsA7rKIiF0fcbetywRK08+gZEz0xTFhuHm8vDmegT9VnHo0JuEsFrMvdoJ+XtCiSgYwy4orCKGGC85nXpk318XmeXjq09e7tgiUl3voPSOEXDH5C38kdrAbfQ2cCUVMUauqjJfTaHmECcKrFLxGHsD+WvFj8NYzGpkCdBNWULSRXPd+WWEgNIDORyTGxLChNGyonbtBi7yz83rlKPyhUIUOo7Zn37gU4lizMmx5zPtVMRb12r+1qQ/UNWzTxQ5M+CyvtTXcgBRXBKJNhW0tsq8SvfTUEmC43i/M5yPDsp+aHqQu5jV4cDHiBJ2BJww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB8251.namprd11.prod.outlook.com (2603:10b6:510:1a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Sat, 15 Nov
 2025 01:20:34 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%6]) with mapi id 15.20.9320.018; Sat, 15 Nov 2025
 01:20:34 +0000
Date: Fri, 14 Nov 2025 17:20:26 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH 0/5] cxl: Add tests for extended linear cache
 support
Message-ID: <aRfVWuVMb3LDr7S3@aschofie-mobl2.lan>
References: <20251031174003.3547740-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251031174003.3547740-1-dave.jiang@intel.com>
X-ClientProxiedBy: SJ0PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::11) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB8251:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c9bdc93-c5ba-4a1e-f81c-08de23e52d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WzLtk2vhNZ05z0fng8RMBXqY752HMBewQirQ5KAgYd4HKK57sWI5xAtB430c?=
 =?us-ascii?Q?3vf5DHz5c+gdfxXLNDSn2F6w0zS5PY5Lv9uiZWfD1K0wDIYKPdVKxdlsgyAY?=
 =?us-ascii?Q?bEYcfMjJ5o8xNAWr1Qwmp4sX1gVN9L4jBtluY6dCsEKbtDhj8caVRfhLlW2w?=
 =?us-ascii?Q?+xoBYRCS0xTZku/zySBrF8ARCcWCgqjG6nBY2wpIRcfFeBLZXjsELZbokQWd?=
 =?us-ascii?Q?rrMTmzcyXXGn/dQsVl2WQBUMytMEvomb3t0OHCFT1l5hNZQNDsOJcotwLxLL?=
 =?us-ascii?Q?uuQURfUyNyyDAZJkn+tywOpJEh9SQkGtzQZmWeVkwIPMrqTz9PZApTBKbyu2?=
 =?us-ascii?Q?Fq7cDdW+/enpfjk5zAfspmtVpcxXo8M9vH/VyifELEjHdBqK/AMgiTb7hd2Z?=
 =?us-ascii?Q?Ra1pXPpw8STLvom+pNsfpa4dOV4RFytPuKUI33sa9QSG2rDIjowvfP/TJJy2?=
 =?us-ascii?Q?XWqwsU52ALCByCejE59feGaYzVCSJ0hUfwkPNN/38xk0s1hWkQJ4SW6BrILX?=
 =?us-ascii?Q?hCXTRh+ZUmbnrkAJ49r+mWT4ihe3dthZFZ3CmlZxjmApU0lAttRKwsp/6Fn9?=
 =?us-ascii?Q?5aNbKpXvJzb4GoQBCpH/3soPrbodIWmey6R7Ey/LL8cTdnzLC9niWfHAAkyH?=
 =?us-ascii?Q?FDxDk9UGYaYxOmgGPeXy/enJBNH+NuvSxlDhMBC1i/gggVOqOz7WwGgGMBlx?=
 =?us-ascii?Q?1P5easN1wn4bCLtMkwMq2wKuirBaWTnWu8B1yp3v3F8BpBhVf3MDgZyH/7fs?=
 =?us-ascii?Q?87grbf12FFIMYyFYefOfqPYEmKvhcVO48s0AnjgL4TgmoORcphzmzdCfhX3A?=
 =?us-ascii?Q?DcWGeJEOJqKCdF/LIiciXDVbZ8eldKUbC1KQEL8E0i2IeKAStp0bBqCFRpHI?=
 =?us-ascii?Q?bP9UnZ6fnXKqTpnX0fJBV3MacihXfqMaz3D4TyXjMyUaIsdZd/1MAFs60buL?=
 =?us-ascii?Q?hrXPUOcJeoDM8QzD+kI5XsGJ2j4bJXvD+l2aqJSatfQUs2/F9oxW9SRSD/M0?=
 =?us-ascii?Q?bgUCthHvtnQpWjWxpD3csSFssGj6H0umjzh51L+S7hdiizvHt8LD4qtVH0+X?=
 =?us-ascii?Q?AwrshDAhZGtBnGN7/oUvrRaAh3L0YWNil3FCXZdN+65V5NPmYol0RD3rmzMA?=
 =?us-ascii?Q?a4AjChpzvqlf6GOHpzd3Iey2OmrBTrfxZuckIpeL4p/gBLa9hg693R64GjE0?=
 =?us-ascii?Q?9Sj1ZFB1rdjIRCM17TGTbPJrI7doV6uphrZ8mJ63ZlGOcYtWAg9NqKBd/FeQ?=
 =?us-ascii?Q?HU+h6gyIXT+GvbTQWk1tSlHPyY/qfnG0N7IsqdK3gQVjaHwujUlJsReSlYOB?=
 =?us-ascii?Q?yU+L66YqvW0B87H7sc8yj2y2G2BgSqc05obdqJGjdUZcmzTOtx2NWM0J64Yd?=
 =?us-ascii?Q?7l55TIGb+8cpexSGFWdntv5i1iQdNhicxi1F+bJfK+e6yjbnG15CxvMFjV9S?=
 =?us-ascii?Q?YZn2clCxOXzmh99xDBY+5p/iv1CYlwfK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gYU+zquRozYvF8Gi0zjaQn0hFh4ASrAm6P86fOZFik+YYQk+peiZ/kY1HEhS?=
 =?us-ascii?Q?e7/bTEH3i06b39o2SEttqQeudhzgw1HxDilLnmbZUqqRmPYtlZ+g9H81wfz6?=
 =?us-ascii?Q?7U5clw8dtykAn86aw9EfYjdBUHYhKk5i/PE5EExikXBHKzC/5yWF7e0cLdEo?=
 =?us-ascii?Q?dlBr2If6PDgBp4AY/U031araSBKh/hhfg2bnHp5kDOt9QSC+ak3hjZ6d+G38?=
 =?us-ascii?Q?au4en/h9FAw5K5naVAQsqfIqQ56zCd2uSQTTdaQ1Z8/jnp+32+s8p2TpFVxU?=
 =?us-ascii?Q?jIFcZi7GcR9Ii54pG9FGTXusv/rMxijCaksad2J3buuPUwYulaw6CZ9uqmlV?=
 =?us-ascii?Q?QxVk/qIoK5aTiq7tQbBEJjzC6kI8JAcPxilIB7W4ORokXkCiCWNVnvLTQQho?=
 =?us-ascii?Q?xYt2rSQAKyOk6riNX34+W53EdHR6Unh+3k2mL6aonxGaLWVs6HgYqj90RW9y?=
 =?us-ascii?Q?8zNgEZ5d53ZgD/EyPZ8T0BtmF2QSe6yT8txvo15tpzBlLJ7yK0ZUc9mifL5g?=
 =?us-ascii?Q?BHO/G6Wccc3mAbMuG32JqFhDXUEOBriCJ9wAMfLogRklZh5SekWZt2u5HupA?=
 =?us-ascii?Q?Ou60b1rTPr5UAdhs9SSXhcO5xUQpvXbViKlySjkByQg3zsdLTX5dvXNbWCPd?=
 =?us-ascii?Q?m8nZfScYMwXW7Q+lyO97c3XOE/PhI1TjMCJw2ClICQRF9inL8/1IDOQcxl9a?=
 =?us-ascii?Q?jWyqORHKtzv56+ivZlkeUGzd+MjpE2W8ishhBWa2J/z0XucpKMDFcTiRygs+?=
 =?us-ascii?Q?tZCA/xyvk3bQuuP4hJvVpKoyF7g6MAuMdq5/0In1wHBpylKM6U0J8xh4STx7?=
 =?us-ascii?Q?LL7vlDlfqsu3aeqYfo0zX1pV7NlQOibSSZwWjy19nWqn3RqEy1gPfEjGFpjn?=
 =?us-ascii?Q?L2umqE9k2oTQ+bNKjJzUI3eQXZGNEIWx5XHs3zfz7/BL0K5NIPVKqy2EOw2e?=
 =?us-ascii?Q?dwN1pt7Q/PugwsukHv6dr+hDjoGxZYKipOTP7c5tkbqZajmxHb2jDduusLXk?=
 =?us-ascii?Q?riJLF4aGx9fFTwBjZFDHZaHRC1NrhQ4e1nc33ClAro4bceN9HIn7yOQvGI6z?=
 =?us-ascii?Q?liSgxAdGJJ3f71P13BEUR7LuFkTst7y02MaES1NnOug9EAjo8cRqmgDq6jF8?=
 =?us-ascii?Q?MXzCfS3nSZSt9Iq5hDyPTlskGpRjOOskILf/+KUYBokLSiEwgtqxugBxMuI6?=
 =?us-ascii?Q?Hnua9gwjhJpozwGrm9surJJ0E9sy89iPReUW9c6MmQ5EG1Sczr73Iq/PyJPz?=
 =?us-ascii?Q?+ZoVphrhJ6qcxoV1dh+/eF/aNoNG7krrdkUDBsmhx3SkOb30kWrTVITaOfAV?=
 =?us-ascii?Q?SAdT0AiSQ/CHY+67QmGnehH4uVOlWyUPUCx5ix6EPX9MBTg/vJQb+DOnrG29?=
 =?us-ascii?Q?DXGajWfs2a3j1AqKJT0rvhxqzw47I0WNwWmrFuO4YoIzXaHrVMRf4fCCXMp/?=
 =?us-ascii?Q?J9OD33LaaqSZximDyE1kCOINfA4iUMRNk7j/7yT0L2wdyJwmPdAPyWElK8AC?=
 =?us-ascii?Q?XOVfexixOUP469wgehjLZy3eOhMzb29icRERNULnu537PCMc1s9yGQiZyAHW?=
 =?us-ascii?Q?d5NfI6Zur0lWvxx6zFJF+mn9ulErsETxx/nfLKn+Osc13pGZqkbw9pT+i08M?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9bdc93-c5ba-4a1e-f81c-08de23e52d12
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2025 01:20:34.6749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TI09+NoEItolXORFE6eTPsm639MIITFR/b1if4Hei6Y+wiJwGXaovrj0Vr+QU6UjSmw3H9zDkm8JSI9g+lvsKIHGNbmT4IYhl1B2tldVubQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8251
X-OriginatorOrg: intel.com

On Fri, Oct 31, 2025 at 10:39:58AM -0700, Dave Jiang wrote:
> The series adds unit tests to verify the kernel support for extended
> linear cache (ELC). Added a test to check if the ELC region is setup
> correctly, and another test to go through the poison handling flow
> via the poison injection testing.
> 
> 
> Dave Jiang (5):
>   cxl/test: Add test for extended linear cache support
>   cxl/test: Fix cxl-poison.sh to detect the correct elc sysfs attrib
>   cxl/test: Move cxl-poison.sh to use cxl_test auto region

The next 2 patches may add more complexity than is needed by splitting
the work among a common file and 2 test scripts. Consider keeping the
work in one file and wrapping the test execution in a 'run_poison_tests'
function. Then call it that after each load of the module, like -

run_poison_tests
.
.
.
modprobe -r cxl_test
modprobe cxl_test
run_poison_tests
modprobe -r cxl_test

modprobe cxl_test extended_linear_cache=1
run_poison_tests
modprobe -r cxl_test

>   cxl/test: Move common part of poison unit test to common file
>   cxl/test: Add support for poison test for ELC
> 
>  test/common-poison     | 202 ++++++++++++++++++++++++++++++++++++++++
>  test/cxl-elc.sh        |  89 ++++++++++++++++++
>  test/cxl-poison-elc.sh |  41 +++++++++
>  test/cxl-poison.sh     | 203 +----------------------------------------
>  test/meson.build       |   4 +
>  5 files changed, 338 insertions(+), 201 deletions(-)
>  create mode 100644 test/common-poison
>  create mode 100755 test/cxl-elc.sh
>  create mode 100755 test/cxl-poison-elc.sh
> 
> 
> base-commit: 01c90830d65b6b331986f5996dcf6ad73c1579f4
> -- 
> 2.51.0
> 
