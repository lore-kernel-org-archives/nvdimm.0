Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751F718FDA5
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584722; cv=fail; b=MH0aWY833bAgyAA1FPAkiBsoGrKc+2k4jp4gPIaXPIJ/52yYDtdhwj/33aDv43DGbO8sICwVKhh654tvFiY6nlQq3i0ioiTwOpjFBKNUyYD3S+q/1RwvOB8nE8YxMMQspcIWHOTocTcTMBy5VRZn2ASUp425Dw4eJRHlu7g6TpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584722; c=relaxed/simple;
	bh=yKu5GzCSwhClZskfPSul/l1KNzhV4Imp85VjVWq1kVA=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=eAxEXTPb9UKKJUD/XqpdCW/mB0U2pMjTC5sFmQuk9GxoFsXE0jpNQT9lecm77p4Koa1/JHGj14ovu0Ip1n9L24nl7uV3pMQIgxSs2SkjCR4h+bdRuBz9ZyqbqZuEr6vW7BYe0+PIB/dtNfCq+zdzgj3WGTr2OJw76WcGtXoyr8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U0ADUzrF; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U0ADUzrF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584720; x=1776120720;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=yKu5GzCSwhClZskfPSul/l1KNzhV4Imp85VjVWq1kVA=;
  b=U0ADUzrFS6ljStSHzzHtt4NPQwvKbqrGR5/EOaS8WjmQp8dsMfhYbpA8
   eKStF8B4wZQuF+Uh6uRReX8R9dUD3MaUp06IBpFw23IDB2Io4iL5gTJOR
   vyiJh+wvkuPgRkiciohDRgs78W5+zblCYk0vIhmQ+A01rIIp8FiHYFtNE
   gf7P0uJfpbYzt6bkq562dmq1a7ZjhEnNxHDc0zTDMlJiPo26MFlGzJHZO
   75wUzcs8PT4UReU5v/tP3Dwlf52COh0ObzMZWtD+UOdHikec+X3Bl8j9W
   RTnnyHN29jIH/Z3oJko2CtoAm/0L3tQgW8UtP4j2MZ5TsaW1vK85Pvw8M
   A==;
X-CSE-ConnectionGUID: dBRovmfaR6agA5qfOZo7Iw==
X-CSE-MsgGUID: Rjim1ztnQuu6JIONr1X6Sw==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280885"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280885"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:51:59 -0700
X-CSE-ConnectionGUID: N4SWL+r6QBiYshQ4t4sEgA==
X-CSE-MsgGUID: inuCNsY4SvaZ4XrBUEuOMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657424"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:51:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:51:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:51:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:51:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=khs8704fxCoppVAEvlPzgBiMVxbxiTioxn5zLThlzDm+MSLTb1qftLut4Tk6kUGPhvyzKXjrT+NLNd8ZNtbo4QQVYEwpSACqMydCBdfU99lNYxSCn/WtwqwdETH/cZAkrWn6VikzeThsm7qYHAn2nFuOryVa15lAVTiXlVXM6/7sVgiMxYR61srmcVCOMk7gvkle8lWaV6iAoI/Db9V4t23EogJaBK1R+0Ur9h7RW2PpxVgpZf6mmoC6E0QQEu4OY6zeCCJ4r6pBBrkBJDY66bP1qu7Ocsmu+YinpiPgCZzQg2EdacE20+KBSOpGgJx0EtcFyjKoAYPQiZElSTpJQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QkoHo8DOZ66Z7EiSbnZBmZz8Tw+rUGijfRBcpfBpfYU=;
 b=iM/nXwdp649Tev/uEMXzMA1tnIEOkAeRNiOuvoqeKNK+03o+SR207AfdQ6p9kKcseJnYZKXeQrQOJuVS2aDTquUUlmderPcXk8upQKWI9Gp5oh4xgckFeiDw9KHjOrxchOj6bFwWil7Zx7YN+inQ1UdxIOsDhv5MY9PsG0oEI5KqsU0XHWtFI1MX0eTgQS/KgYwZv+fRlLLLymx2ROlRBE+dwPKSIXTki8Akjs4nsxW6rb2ox7p/ABQcqqqecoF0PlwArbOQoweHigHKtJAt59obg+IfXGjNFFv4z0UtsJ+rJeAnh9PQYIHduZ3pJpCw/P7dIAnjxnlddha1bssA7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:51:45 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:51:45 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:10 -0500
Subject: [PATCH v9 02/19] cxl/mem: Read dynamic capacity configuration from
 the device
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-2-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=12514;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=yKu5GzCSwhClZskfPSul/l1KNzhV4Imp85VjVWq1kVA=;
 b=bN1/2MH5VstkPjHZQa4RmCVO2wG0EP+Ci0FetDpq9W9nIkT5q8Ja/2+TnNzC5vVldDEtCfEqr
 XNP4trGWR3FBHv9R4V5auPkBSOwcxjZlGX9mAqPB3JEccOcGuNqXI/8
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW4PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:303:b9::22) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|DM4PR11MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: a10f9a32-c0d7-46cf-3d7f-08dd7addc41e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b3VkS2N6cUg0NUdpNFZGeGhIYXJ2eHhwOHVWWU52NGQ2MUk3UHorcmVIWVpy?=
 =?utf-8?B?d2puUGtPUFdqcnozS1V1K1M0NWtqd1lrWVg5VWk4YTlUdS9uc2RYa3MrTytH?=
 =?utf-8?B?VHRDalBBeStyaGx6TldDcnJVUVA3Z1VLdGl1SXBzOC94aDlPbEx6ZVlEejZn?=
 =?utf-8?B?eUxXU0oxWWFyMnVHQ01ldHg0UlRJZ1JLeDNTSEVBcHQ3U0V6cjFwVjdOWEhZ?=
 =?utf-8?B?TVlHcWtoNWN6b1YyR0ZrM1hIZDFrVEJFcGlKUEJTZU1oUGM3WVQzRldLU1Bl?=
 =?utf-8?B?T3BDQTdIL1d2QmFZa0YzbE1WdW8zeHEwRVIxL3RYVmV5K1VmT3cyeURidTUw?=
 =?utf-8?B?TE95N1AvVXhRWXZIVEM5WmVMVC9RbW1OM05WWmI1d001MUMzWkdZU0JyTmE3?=
 =?utf-8?B?cHJpNXNBREVxUXBEc05vUjNOeWtDUk5ic09jZFh0aWdKZDl4RTNNMnRIMHRi?=
 =?utf-8?B?SHBUUlZMd0ttajNhS01KcjJWNDdVS0U3WElQNW84QnVJbCtsekZtZzZxbVN3?=
 =?utf-8?B?UVpxZWhnVE5FdStTcmh0N3I4bmxvSUMyb1VLTzlMcVBlSElTbENuUEYyRVN6?=
 =?utf-8?B?cE1VRXVDbGFpVm9yZzBWZng5NzJPQmh0YlorNjlZd1RjZzJLVTg2VTJESTgz?=
 =?utf-8?B?RU5RMEFvQktzQWNCT3lDOTdOcEh5WW9HVlZ1bDlYQlMzalRRYTBqNkpEWkxB?=
 =?utf-8?B?OHBjU0RQOUpFVEtGSm0zenZlT2xTTGtVT0ZqNXRPR2FneWVRaHhYOHRCL2Fj?=
 =?utf-8?B?WDJKTWU2REJzY1BUZEQ0bzl2aHluNzZmbUNQSTBESi85ekEzY3BhWTBIWk82?=
 =?utf-8?B?U2wzVGN4MVRZQk1JdVJkdFBsZ1kxeFBFdDZmaGg2U0o4Q3JtQnY0SHJzOTln?=
 =?utf-8?B?RytSWnVSTGsya29BbFF2WFBVVnFhcDNONE1Nd1N1Z2hUT0IydHBEdWNyZTBF?=
 =?utf-8?B?OUtiK2djaXhCSTFoYmxVc1ZpWkZoOUlYVzhUK1BqOEgxVXY3cnBVZkhmaVFH?=
 =?utf-8?B?Smh1OG9mZzk5TUU5L2hOUDZPck0wNHBra1R4V2cxelNtVWVlY0ZvRnJ5Wmtj?=
 =?utf-8?B?Qi96eUlaNkhxZkNJQU5kT0hxV2dOM0c3N0gyOHdhWm9OeWphKzJGcXBqL01D?=
 =?utf-8?B?UVFuR1lzZThzbmFWTUl6ZFc0djE1OW9ESWhnWDNNOTg5QXgyNU9LUGk0SjZ5?=
 =?utf-8?B?SVVmR09rcUVhMHlXanZZRGFJQzVpTVlnYkZ5ek5aVjVEUlNsSHc0NXdaaHY2?=
 =?utf-8?B?K1ljVW9hSFFGeVNMUGVwYWlCcXRlV1hBMHZBNWtTR3hoZzhmYmx1SE5ySGU0?=
 =?utf-8?B?NTlDQzZVSERWYU5PamZIK2FaM0Zlc285TUs1M0dUUzVLZElZem5TVERqcmNv?=
 =?utf-8?B?ZU9vUW8rR1FMUmo0RFVlOFZKSzNDcTdGWUsyOW1JMHY1bmg4NnEwZ3Z4VUNE?=
 =?utf-8?B?MUpmT2t0MWU2Wm4xdytxVWdGK3dzRGk5akhnZG5Kc2Erd1p6MDlQWTJWSVlU?=
 =?utf-8?B?UjlsZHc2MFNwVmZjSFlNaWJtaGFtdG9CbnBpNVZ2UlBkTU8wT0lRVlIyTktk?=
 =?utf-8?B?ZDRvem5aVWZHN3N3N2ZGVzRVeWRpOWMyM3FKRDk0RlkxYVdoeVlVM2lvSDNw?=
 =?utf-8?B?eW5zY2I2T0o2QjFyZ1R5T2FLYXc4UXFWWi9xSDhlbnR3dlVtcDYrZTNzZ05R?=
 =?utf-8?B?NnY1dXdrUkl1SDZNYkVzVCtoOERwaVQxbWJmVWFMY01qdHE0VDNXM0dIZE9T?=
 =?utf-8?B?R0N6TTFYWlkyMmxZWnR4aXV3UXRvTmptK1VGbUtJR3FZYjRhYmYxODhjYit0?=
 =?utf-8?B?ZjZpVlpsU2Vzd1ZWUCs4Q1FTY0dpQ3B3Mk1KdVY4R0xtclZOZFBWY1Z3TjJt?=
 =?utf-8?B?UDhTYWt3YkxnYzJUNXVJQmY4NXYzZ0kxOW5VaVZRNVFUdExvZkNKVHJacXpZ?=
 =?utf-8?Q?kgUwHC8vnto=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2pXQUd3M3ZqRVA1cWoxdnI0M2VCY0luaDlFMU5BaGg4Wmdhc0RQbE5YM244?=
 =?utf-8?B?aFBTbE54OXlhZk5ZSGsyUkY1RlNpc0tNYnBqUzNIbXVvZUN5ZXBRUzIySk1M?=
 =?utf-8?B?VlFJWjBBczZDWmE4TjlReTlpQlBOMUJCMU5YZ0wybFpUVHlXOEJ1TzRjOXl0?=
 =?utf-8?B?OXc4RWpvRUxiWVYrZi9QS0w1WVVxejBkanc2aTFRQWpHQlNiN3hUWFFEb0Nn?=
 =?utf-8?B?SEFlcVFpNHI1aUN4RFFYa3FMeDJtQUU2T2Y1RWQvMDVmOWR5VXp3VndiYzZ4?=
 =?utf-8?B?alZMeUUyNTVWUG1qS3FxUkFqMUNhMWltbVEybjJEVUJGOGJJRXM0T2t1MTJo?=
 =?utf-8?B?STdqUWJlNlkvdUZ0am1xcG9rcFFGeWpFVHI3RUY0cFRWVlpVVG1XY2hHSGU1?=
 =?utf-8?B?cVNYVGVhQnpic3FsSVE1VnBSMmlab1RYd0FRWEgydi96Y00vMFlVSmRNZTYw?=
 =?utf-8?B?UzZlOURzd0J5Qy9QWC9va1NtTXdCNVRsb0xFWFlEdjAwTG1RRGRDc2RDbFYw?=
 =?utf-8?B?RFJXVjNWNXJXb2VOM2R6TitzTlNFeDVlem1vamlHWnZVMzlOK3JkMWlxQWMz?=
 =?utf-8?B?bDk0QXZ0bTdMZlVaVzBwTVNaV3Nna2hIL2hhbHREYzI1ZUhFRlQwemY5TDJa?=
 =?utf-8?B?OGMrTVo5VXZraW5OREl5SmJoRU5KeFFoRjRlQTJtOEYxSDltMlZPcnJPYTJh?=
 =?utf-8?B?SG4zSXBQaVNRRjJNOWdaY1kyUHNwUUdpemJsWjVrd1FENlNnWE9qQmlnSHE5?=
 =?utf-8?B?dnJFZXJaaXpVVWdYNjlSUmlPNi9sV1dFSGFkZnViZlJ5THh5ZXl0aU8vZk53?=
 =?utf-8?B?bjNtb1JHRGY4WXppeFhMam1vUGtBZGZlK2xnUk03V05FaVRxeERXY2NIQmlM?=
 =?utf-8?B?dFdOWFZiMjZFZkpWQkM0OXhBZzBESkxwbnoybndXVmRaTUFWVkt1S0xORXM5?=
 =?utf-8?B?c0ZzTEMrZVp1Z0xkUHZXNnhUTVVGUjVEeFR3TVpxNlljZzJYbTg2aDFHZ1J6?=
 =?utf-8?B?bEpycCs2V25Ocno2MndpNVM1dFNaVVlzb3JhcTR4SkNkc1FGbFJYVG9iYWQz?=
 =?utf-8?B?N3hGOGxBYU5GV0VZYnJBTHVLQnNGWUVZSTdPd0F6aTFkbUQzeFkxRUlycGs4?=
 =?utf-8?B?eUwzMzhoY1lmZkxEcVEwSElRTElkUisyQm5KUW9pNW5DZ2VlVWZWZTB6U0cr?=
 =?utf-8?B?SlRVOXl4SFluSlBMTmZ2L1JHQ2F6TE54UlVLMzlXaGoyV3BTTkN6MXVPbSs0?=
 =?utf-8?B?NDFscjduUWRJeDcwUDBrVGUrTzFGQzRrczN4QjQ2NU1PNjFBWXFlZS9POEZs?=
 =?utf-8?B?OWVCZi94Wk04UWtOeHFWZks1V1RMNGp1OWNDUHhub3NHUzFaWFZObnVBZjFp?=
 =?utf-8?B?bHZMZlI3VFUxaUhqbmF1NHVsNnhhYnVOMHluaEwvem9yai9tTFN0eVBmUFN1?=
 =?utf-8?B?TWRuZjY5VkEyYnJ0U09nZjJGRnNyK3ZMUHRwUGtjSVhSYzlRbFFxUzl2TFNy?=
 =?utf-8?B?YjlGdENFM0xnK3kwRlV0eGpvUkZjYmtNdDZKUEkveEFMU2VPcjV0WFF1bUdI?=
 =?utf-8?B?ck5hbEZDU202ZFo2cjZDa0tsV2J5VDN6cStQZXNwYWl6blMxb3d5U0JGdDVr?=
 =?utf-8?B?OWNVczliMytVKzdFcERFSllmUnE2VHRKTGNPZ1A2ZnBxUmRNcEVSNUdKN3Rx?=
 =?utf-8?B?MHdtcXMrMk1aVzI0TTliRTFIK1EreWlIUzJNNDFSZVFqTVZySnJBYUpSTHg3?=
 =?utf-8?B?aWYxNFJ2c2R4ZXIra0JVWC9CNWt4WmFsamRCVjhmbUdkazdzeHlHVGZuMFhN?=
 =?utf-8?B?cU9YUm4rb0ZYUEp3THJKZ0NXSE5ibXFmZ25zbHJVb0tCbW9hMEp1cjhPZmNC?=
 =?utf-8?B?YTZ1blNxYXFnSWdSVVRTenh5ZWdGaDBINHNwMFZnL1pMNDEyUk1zMXVQODEx?=
 =?utf-8?B?MHdEUnRaTVZaRC9nZk1UTXdoclBYWXc0K1ZRRUJRWUhEVjErN0poU2hveCsx?=
 =?utf-8?B?Qzg1QVFXZ2tWVWpNWjl3VGpVWm9Hbzc0TW9jNE9oMk9aMlQ4WUlWRUFHUzJV?=
 =?utf-8?B?S3dtZXdJdFAwMjNybmhLczUxTGxOOHZ0dmtFdkl3ZEs1MnRkaWx1OVJVaEtK?=
 =?utf-8?Q?FYVw7/t+V3mP1NwwRqHp48llZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a10f9a32-c0d7-46cf-3d7f-08dd7addc41e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:51:45.5504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4NCX1kzs+mwobyjZI19BQIhbLzxVpPV55BVg8UeiW1OK5bzASyyrDaEpFXh09tpObOy4Fx3vP8DFJKjHfNf/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

Devices which optionally support Dynamic Capacity (DC) are configured
via mailbox commands.  CXL 3.2 section 9.13.3 requires the host to issue
the Get DC Configuration command in order to properly configure DCDs.
Without the Get DC Configuration command DCD can't be supported.

Implement the DC mailbox commands as specified in CXL 3.2 section
8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
information.  Disable DCD if an invalid configuration is found.

Linux has no support for more than one dynamic capacity partition.  Read
and validate all the partitions but configure only the first partition
as 'dynamic ram A'.  Additional partitions can be added in the future if
such a device ever materializes.  Additionally is it anticipated that no
skips will be present from the end of the pmem partition.  Check for an
disallow this configuration as well.

Linux has no use for the trailing fields of the Get Dynamic Capacity
Configuration Output Payload (Total number of supported extents, number
of available extents, total number of supported tags, and number of
available tags).  Avoid defining those fields to use the more useful
dynamic C array.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: rebase]
[iweiny: Update spec references to 3.2]
[djbw: Limit to 1 partition]
[djbw: Avoid inter-partition skipping]
[djbw: s/region/partition/]
[djbw: remove cxl_dc_region[partition]_info->name]
[iweiny: adjust to lack of dcd_cmds in mds]
[iweiny: remove extra 'region' from names]
[iweiny: remove unused CXL_DYNAMIC_CAPACITY_SANITIZE_ON_RELEASE_FLAG]
---
 drivers/cxl/core/hdm.c  |   2 +
 drivers/cxl/core/mbox.c | 179 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h       |   1 +
 drivers/cxl/cxlmem.h    |  54 ++++++++++++++-
 drivers/cxl/pci.c       |   3 +
 5 files changed, 238 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 70cae4ebf8a4..c5f8a17d00f1 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -459,6 +459,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
 		return "ram";
 	case CXL_PARTMODE_PMEM:
 		return "pmem";
+	case CXL_PARTMODE_DYNAMIC_RAM_A:
+		return "dynamic_ram_a";
 	default:
 		return "";
 	};
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 58d378400a4b..866a423d6125 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1313,6 +1313,153 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
 	return -EBUSY;
 }
 
+static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
+			u8 index, struct cxl_dc_partition *dev_part)
+{
+	size_t blk_size, len;
+
+	part_array[index].start = le64_to_cpu(dev_part->base);
+	part_array[index].size = le64_to_cpu(dev_part->decode_length);
+	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
+	len = le64_to_cpu(dev_part->length);
+	blk_size = le64_to_cpu(dev_part->block_size);
+
+	/* Check partitions are in increasing DPA order */
+	if (index > 0) {
+		struct cxl_dc_partition_info *prev_part = &part_array[index - 1];
+
+		if ((prev_part->start + prev_part->size) >
+		     part_array[index].start) {
+			dev_err(dev,
+				"DPA ordering violation for DC partition %d and %d\n",
+				index - 1, index);
+			return -EINVAL;
+		}
+	}
+
+	if (!IS_ALIGNED(part_array[index].start, SZ_256M) ||
+	    !IS_ALIGNED(part_array[index].start, blk_size)) {
+		dev_err(dev, "DC partition %d invalid start %zu blk size %zu\n",
+			index, part_array[index].start, blk_size);
+		return -EINVAL;
+	}
+
+	if (part_array[index].size == 0 || len == 0 ||
+	    part_array[index].size < len || !IS_ALIGNED(len, blk_size)) {
+		dev_err(dev, "DC partition %d invalid length; size %zu len %zu blk size %zu\n",
+			index, part_array[index].size, len, blk_size);
+		return -EINVAL;
+	}
+
+	if (blk_size == 0 || blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
+	    !is_power_of_2(blk_size)) {
+		dev_err(dev, "DC partition %d invalid block size; %zu\n",
+			index, blk_size);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "DC partition %d start %zu start %zu size %zu\n",
+		index, part_array[index].start, part_array[index].size,
+		blk_size);
+
+	return 0;
+}
+
+/* Returns the number of partitions in dc_resp or -ERRNO */
+static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
+			     struct cxl_mbox_get_dc_config_out *dc_resp,
+			     size_t dc_resp_size)
+{
+	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
+		.partition_count = CXL_MAX_DC_PARTITIONS,
+		.start_partition_index = start_partition,
+	};
+	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
+		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
+		.payload_in = &get_dc,
+		.size_in = sizeof(get_dc),
+		.size_out = dc_resp_size,
+		.payload_out = dc_resp,
+		.min_out = 1,
+	};
+	int rc;
+
+	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
+	if (rc < 0)
+		return rc;
+
+	dev_dbg(mbox->host, "Read %d/%d DC partitions\n",
+		dc_resp->partitions_returned, dc_resp->avail_partition_count);
+	return dc_resp->partitions_returned;
+}
+
+/**
+ * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
+ *                         device.
+ * @mbox: Mailbox to query
+ * @dc_info: The dynamic partition information to return
+ *
+ * Read Dynamic Capacity information from the device and return the partition
+ * information.
+ *
+ * Return: 0 if identify was executed successfully, -ERRNO on error.
+ *         on error only dynamic_bytes is left unchanged.
+ */
+int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
+			struct cxl_dc_partition_info *dc_info)
+{
+	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
+	size_t dc_resp_size = mbox->payload_size;
+	struct device *dev = mbox->host;
+	u8 start_partition;
+	u8 num_partitions;
+
+	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) =
+					kvmalloc(dc_resp_size, GFP_KERNEL);
+	if (!dc_resp)
+		return -ENOMEM;
+
+	/* Read and check all partition information for validity and potential
+	 * debugging; see debug output in cxl_dc_check() */
+	start_partition = 0;
+	do {
+		int rc, i, j;
+
+		rc = cxl_get_dc_config(mbox, start_partition, dc_resp, dc_resp_size);
+		if (rc < 0) {
+			dev_err(dev, "Failed to get DC config: %d\n", rc);
+			return rc;
+		}
+
+		num_partitions += rc;
+
+		if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {
+			dev_err(dev, "Invalid num of dynamic capacity partitions %d\n",
+				num_partitions);
+			return -EINVAL;
+		}
+
+		for (i = start_partition, j = 0; i < num_partitions; i++, j++) {
+			rc = cxl_dc_check(dev, partitions, i,
+					  &dc_resp->partition[j]);
+			if (rc)
+				return rc;
+		}
+
+		start_partition = num_partitions;
+
+	} while (num_partitions < dc_resp->avail_partition_count);
+
+	/* Return 1st partition */
+	dc_info->start = partitions[0].start;
+	dc_info->size = partitions[0].size;
+	dev_dbg(dev, "Returning partition 0 %zu size %zu\n",
+		dc_info->start, dc_info->size);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
+
 static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
 {
 	int i = info->nr_partitions;
@@ -1383,6 +1530,38 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
 
+void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
+{
+	struct cxl_dc_partition_info dc_info = { 0 };
+	struct device *dev = mds->cxlds.dev;
+	size_t skip;
+	int rc;
+
+	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
+	if (rc) {
+		dev_warn(dev,
+			 "Failed to read Dynamic Capacity config: %d\n", rc);
+		cxl_disable_dcd(mds);
+		return;
+	}
+
+	/* Skips between pmem and the dynamic partition are not supported */
+	skip = dc_info.start - info->size;
+	if (skip) {
+		dev_warn(dev,
+			 "Dynamic Capacity skip from pmem not supported: %zu\n",
+			 skip);
+		cxl_disable_dcd(mds);
+		return;
+	}
+
+	info->size += dc_info.size;
+	dev_dbg(dev, "Adding dynamic ram partition A; %zu size %zu\n",
+		dc_info.start, dc_info.size);
+	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_A);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
+
 int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds)
 {
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index be8a7dc77719..a9d42210e8a3 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -485,6 +485,7 @@ struct cxl_region_params {
 enum cxl_partition_mode {
 	CXL_PARTMODE_RAM,
 	CXL_PARTMODE_PMEM,
+	CXL_PARTMODE_DYNAMIC_RAM_A,
 };
 
 /*
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 394a776954f4..057933128d2c 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -97,7 +97,7 @@ int devm_cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 			 resource_size_t base, resource_size_t len,
 			 resource_size_t skipped);
 
-#define CXL_NR_PARTITIONS_MAX 2
+#define CXL_NR_PARTITIONS_MAX 3
 
 struct cxl_dpa_info {
 	u64 size;
@@ -380,6 +380,7 @@ enum cxl_devtype {
 	CXL_DEVTYPE_CLASSMEM,
 };
 
+#define CXL_MAX_DC_PARTITIONS 8
 /**
  * struct cxl_dpa_perf - DPA performance property entry
  * @dpa_range: range for DPA address
@@ -722,6 +723,31 @@ struct cxl_mbox_set_shutdown_state_in {
 	u8 state;
 } __packed;
 
+/* See CXL 3.2 Table 8-178 get dynamic capacity config Input Payload */
+struct cxl_mbox_get_dc_config_in {
+	u8 partition_count;
+	u8 start_partition_index;
+} __packed;
+
+/* See CXL 3.2 Table 8-179 get dynamic capacity config Output Payload */
+struct cxl_mbox_get_dc_config_out {
+	u8 avail_partition_count;
+	u8 partitions_returned;
+	u8 rsvd[6];
+	/* See CXL 3.2 Table 8-180 */
+	struct cxl_dc_partition {
+		__le64 base;
+		__le64 decode_length;
+		__le64 length;
+		__le64 block_size;
+		__le32 dsmad_handle;
+		u8 flags;
+		u8 rsvd[3];
+	} __packed partition[] __counted_by(partitions_returned);
+	/* Trailing fields unused */
+} __packed;
+#define CXL_DCD_BLOCK_LINE_SIZE 0x40
+
 /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
 struct cxl_mbox_set_timestamp_in {
 	__le64 timestamp;
@@ -845,9 +871,24 @@ enum {
 int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
 			  struct cxl_mbox_cmd *cmd);
 int cxl_dev_state_identify(struct cxl_memdev_state *mds);
+
+struct cxl_mem_dev_info {
+	u64 total_bytes;
+	u64 volatile_bytes;
+	u64 persistent_bytes;
+};
+
+struct cxl_dc_partition_info {
+	size_t start;
+	size_t size;
+};
+
+int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
+			struct cxl_dc_partition_info *dc_info);
 int cxl_await_media_ready(struct cxl_dev_state *cxlds);
 int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
 int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
+void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
 struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev);
 void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
 				unsigned long *cmds);
@@ -860,6 +901,17 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 			    const uuid_t *uuid, union cxl_event *evt);
 int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count);
 int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);
+
+static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
+{
+	return mds->dcd_supported;
+}
+
+static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
+{
+	mds->dcd_supported = false;
+}
+
 int cxl_set_timestamp(struct cxl_memdev_state *mds);
 int cxl_poison_state_init(struct cxl_memdev_state *mds);
 int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 7b14a154463c..bc40cf6e2fe9 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -998,6 +998,9 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
+	if (cxl_dcd_supported(mds))
+		cxl_configure_dcd(mds, &range_info);
+
 	rc = cxl_dpa_setup(cxlds, &range_info);
 	if (rc)
 		return rc;

-- 
2.49.0

