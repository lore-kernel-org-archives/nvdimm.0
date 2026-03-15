Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975551A2392
	for <nvdimm@lists.linux.dev>; Sun, 15 Mar 2026 01:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773538422; cv=fail; b=b52SmjYYmghOfHNMNu3ff3+OPxqcvrxnAnAU/CuFA8k9Iv48q1D7XtwlMMyjdHQw6OZSffA/HO8eEekAHoyBsfJR9Qzx9wQEtoeSyhQSO0i/hFBU+9hW+tEqAFnZhS/n6Zy3OeNlihNhX3qthrHkYXFUokJ6nZr7vBrviS/I5Cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773538422; c=relaxed/simple;
	bh=19FEcQ0bde2/SWxmV0u9x67scpjiewj6e5TPKQUeHGM=;
	h=Date:From:To:Subject:Message-ID:Content-Type:Content-Disposition:
	 MIME-Version; b=CdxfYvbIXq7VoEU3Q+Tb9eLdKSGNrFLrMLac56w0kS5crKL/EUDQsEEwZ+SbLMmG+v32ao3wk6c5yp9I0MCFHkAocOB/9+U6EPe7rJ/0vuwh2Lpe/2VU0TRJHIPsaP7K4yiSwk6/JQfonIx5WdaBTcjDu/Rhraw5T7FII07RPuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ml7Fsqq3; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ml7Fsqq3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773538421; x=1805074421;
  h=date:from:to:subject:message-id:mime-version;
  bh=19FEcQ0bde2/SWxmV0u9x67scpjiewj6e5TPKQUeHGM=;
  b=ml7Fsqq3BP5Cmz9cLl21cWVdYvD/Rj2kb8U39gsoks49FYtZIJcRamL/
   KzzA2BDj7TtxX+nEKA0xbjWJRYTKTISWp/ofzZZFms4PlaAjtlcBxQGnC
   7M38ldLCLz9Wetow4Gej9CntGJvK7bICGSYMD9OY2Zxp/9IC3PKfC1H6C
   Yecwp1btEfqjVb/Xz3QYndxElIvrMR9sFGVZack9Grug1SgXJFrffLeze
   RDZLW4+Dw461m4O/j8F5LBxuRW6tsa5eZof/LXQVkpC5s5QPEPfBw6ljG
   kaCfkjBjc+frnQEsjR0PMgQNOYZWhTIHWs2VjsPHqt2rmQzmPl8cHEobJ
   g==;
X-CSE-ConnectionGUID: MYnObGzQRpWFPZMp+iepwA==
X-CSE-MsgGUID: 8L6ZUCWiQ/2nm3xNNcNkLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11729"; a="78200704"
X-IronPort-AV: E=Sophos;i="6.23,119,1770624000"; 
   d="scan'208";a="78200704"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2026 18:33:40 -0700
X-CSE-ConnectionGUID: L++Gx+PET/qo9hcWXsLfwg==
X-CSE-MsgGUID: Azz9m9DnTxCFoqgC/UHQQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,119,1770624000"; 
   d="scan'208";a="221745205"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2026 18:33:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sat, 14 Mar 2026 18:33:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sat, 14 Mar 2026 18:33:39 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.41) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sat, 14 Mar 2026 18:33:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h8JDfvxLM/5UcQnk8G/SEJ8WK2XCpJceurss0vIfagExadgjJlkyikikJEAQDhv4KHQFNdMw0L7YO5uU5HAqf+BV+Jsz3Rb65JMxkth1C7bTf6myVpb1XYB7kLTYcSEqvU/W3qsiqBl54qAS7zFhH0Rp7YTmnJpw85l/RAS3SH94nPjug9qQf0KisiL2QcrnjfhmxGvQsdFVDhrpyG2MknKdqB+5F4+qKfAms9CE1uM0WdfXrMJaVL6gGNPwIhSV1sPonw8EAolAuiUQDxQNvwCJRKNckfHkR9D2AX0FD4vYJScnVHh2Kv0TyOlJIDwgYphFbYklZzI33SjcV6UzAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXRLe6IdizGDU45xWVLzW2A6s2eyN2mdyLEdNcqj26g=;
 b=RdPJC3VoSh1CuGuvE/TORNcpAWy4MNxJvFJisVN3xGN28qxwx30Gull2Ca/n7ejY5gRfq8nRssbJTZYEdw0KzrysZEKFIajmyJ5mp0qFyHwBxlKYsdngRvqEti+NSVO9rCRla0zoQlQsJXgQ9o+zKh8nGfzPZiqbo9xUjzZY6H23klrj+TwfeBH2u6mqPTIYW5Rc1H3gxHBgRJ19dKi2+FgvYSw12Fc4ZXHrgzR0cZu9zj4Cx6ZB6+XoRce0sNWKK0G3n/OCWfs5C03jNN41ABh2nd/5YRx2ZFfDwCkhWkUiDUTYzily2UFaS2YCNesq+4RoQuC55Orxn6CE+my4JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by DM4PR11MB7374.namprd11.prod.outlook.com
 (2603:10b6:8:102::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.13; Sun, 15 Mar
 2026 01:33:36 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::1879:7c61:49b4:b2b3]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::1879:7c61:49b4:b2b3%3]) with mapi id 15.20.9700.006; Sun, 15 Mar 2026
 01:33:36 +0000
Date: Sat, 14 Mar 2026 18:33:34 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: [ANNOUNCE] ndctl v84
Message-ID: <abYMbjGetB44Nqbg@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|DM4PR11MB7374:EE_
X-MS-Office365-Filtering-Correlation-Id: 638c0fab-57b9-4cd7-994b-08de8232e09f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: CqV8enfyLsK8SdyVPb9xP6PC41Mp9hAKVbDB7oExfwmnKLbWK2ivr2hlJvUwZyZ7jUaV5C5hes5Bun9BlQj5qq3z8tiL+Txgk2H30o2fUQxWdX1hUHOmkBdcfDXDsXzQFicXaqwqdqEwNLGTqrV1RrAuhxygrOD8zCsj58tFT45I2bVrbMaaeSglG/C7XHnY+3Ymk6Y3jQ5CmU0sXWIjZkzf+1xjp6T0KVuXPF4rUbIIKunVRgg2amztFg/VqzGMuNJPtdQKstkXa49/leDPn8ynEF3Jtd1uontiLiAkQ908veXoK0JrPdwIsUNY2b4VwzeRtSxC+YXZvjtwmzwBVgMMqD5YKcebL1w5TRbz/KgEN3+RESFugdAbxk0DFm+wC/sabr5hL33yt0VeDZ2lyR4A5POAxky81JwvOFMfU+kpBtHYC8ndptagBw9MF8KYpDb1t3NHufkhY0Wzmz0KfTOQwXM5+s559//2XwbIb5qkwXI8fIlw1fsKcnxhd5iee1HF/PZqVdZoToJqXliuvp5r9bEKjchaGDvxIV4tk44IFA9uw6LspRGiuR9ZCEfIpA24EVi5jMaeRbieQjI/DIv3z2CcC2gd4X92oOTNcudaDSNpJjjSWyMMZNdcG15qaK4bM8IruCkXn2hYnuw2Cm2Tmo9tmZZDl2bshUsNR4dzKQ8YZv2Uolo6i9pXARrG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9JvXYunLE0mQjFDfXHXjQvPVB8ZCembhOdT3pr6BU8WgjnPqEBoKP+yct2c1?=
 =?us-ascii?Q?+x3+CUrvJdnruAUR0pdFEQ7Phllpkm3C3LKw9TXXY5z5wEC0wKzCk/OCBMwp?=
 =?us-ascii?Q?HZ9L1KuoxYpdG+mXrNjJwzXx5P3Qqipne2C1/ISVA572jgZtgH6cbLI0hMCA?=
 =?us-ascii?Q?I11o4mRIjY86iVzBX8D7B5kXqLrDogcy2dWqUaGHKg6F02WDMYuqTqHsHzY8?=
 =?us-ascii?Q?+u11/m661aGuIZ6Ax0Pf678+7h5WjlSMV6H82nMvjWhRNT1HYXyKrNM0L9rC?=
 =?us-ascii?Q?Urvqbgz6t0n0W0zJqNlIQl1cB+Z7z1GK26JRiX426pX67wJ16JpAle0vaYiJ?=
 =?us-ascii?Q?3zNzvizW8p30vqPQ9+1v9Er49PGdwlIWR9ly8NO+WM7e1ZoGDKLx/aRu3QGf?=
 =?us-ascii?Q?cYE5TsKE0tGFNxb39DGKlnZB6e9/eQwuepgxmmMMc1lP+XHBemVO+a+sN/HJ?=
 =?us-ascii?Q?+52lOjjnL+4Ri2lFYj8WPJ0RCDcfX2Z1kYaLThPHPF0YkioOOPpXJptiskSr?=
 =?us-ascii?Q?JhGP09xlfMmJOuTY/YZuaUp+iomG9TEdBZrK7SyjQYWHZBaJ8LZKyrXW293T?=
 =?us-ascii?Q?xDOF+wb1St3RPBhR8VChuck2W4g2tspKjQhH4z+prjMQbMMahHX33A92T0ni?=
 =?us-ascii?Q?dOxWT05hp4VdamcsxkjlPtH+2qvsga18Uy9MEg3Pb0mByVrK0zPZOtKqyvFA?=
 =?us-ascii?Q?jubSQLEdzkyUvQtr5KgqAJsZuTkSVk9KkKCxVrBJteUNQTRUZ7D1K2t47Z9h?=
 =?us-ascii?Q?/X4pQPUe9w5IiT+Vp+BuXRzHillGegRZsUgq+DkTVcIHoN6b3ZfKG7tZoBlg?=
 =?us-ascii?Q?H2nNGrJdn5KwCRfjm5aOWltu2FQjQTxV+36Q9vz+yaOV/zjw6qn+xTjiFsMW?=
 =?us-ascii?Q?7QiJkyYjctLV5Bejf03XYXOZJeBRSVwPdPQYsCdlf4aAfdkmOQE21XNur5Qd?=
 =?us-ascii?Q?3R8VOaQTWpRMKGSU8ehaPb0n39udLO3U7OvP9U+yAT2Dg0YBCzfdmnVB/Mtx?=
 =?us-ascii?Q?tOUpaL/c37LAGTSweSwVey54vWBahXB+GczcaDHPJW5kEZyVm77AaFn8z9P5?=
 =?us-ascii?Q?RiSAMdacfZPaiEKjOHWlm+bjt8Zy8gPVwFWoy7TS5PrediylyrKYNTHU8Bf5?=
 =?us-ascii?Q?EnsOYvGJWa6R2A0fl4LNMo8EmZxPKWyjs7+HwFnfLoccQ8PfCLkFmAEn5dan?=
 =?us-ascii?Q?QjhZcDZCZndVpSevgDGsP0l39Z10XFADDeOwWY2pURu80tanRrW4V0ydoFKK?=
 =?us-ascii?Q?bx9h375Yv3c0rQnRO+u+y9GDL4kKllMpAoNW8e9ww9Sh4HeekaQLAoFIGDnd?=
 =?us-ascii?Q?DdYNYLfQeg3oK2LVfE5YmPZWA3Aa950OIYY3rlSkDoCFEtmqr7WmdGR0nM2/?=
 =?us-ascii?Q?kjgkNPezcXIqg7VNdEkyeQ8MxWvdbCphZMa2RAJ09COXhTUyGzmR8hTrmDbv?=
 =?us-ascii?Q?XabZRp++hOEL0MvJ7VybpwMfC/aOG5lS3ozt1S1lft4MpPsDN8r/c0Pen0b4?=
 =?us-ascii?Q?bG6jryT37dI2jokCk2SNgbxgyDjkOulrvLKQKwGp+W3i8PctBCU4MXr5XaDj?=
 =?us-ascii?Q?mbktnsXrCl3tGIJ3YypLdTMHqHDua0d2a64WL0PVD+3IEqYUd5xmaabuyQjg?=
 =?us-ascii?Q?W3x3pB3yHo9eumQvbVMlv07mihDbdYyyls+PyXCdGaFXXGTb0ZXF0zEutoeS?=
 =?us-ascii?Q?W/kiNQQC9DxopYODHbfFowqCDeTrIdMwEDgRhKZo9UkT9xXhnuU0Zq27mbDe?=
 =?us-ascii?Q?0BHaNENYu9LrMYNqXS1zL4BNIZsQJfE=3D?=
X-Exchange-RoutingPolicyChecked: PrThTuH9dhTEAuMk08c0luqEzkPi28o7E0DTBWKbRyfaqYs+nI1fr3E/AOO0IOC3hBSXcBLNjhgIAPQ32dDYiGliviT2pXhj4qUHMoS2uFHsueEDCsTeJRjZtiPS9EYiWx1NtrndcYi1W7DonMFRamZv+CiHN34dJiV+l6gj2MDhO+IqL8OOsJ3t6zBNZ+UioaYVn0NodJsi5Rk9y/zzZzg5xt78G1zPhJRFxmbDzVgc1516YcIHkgVlwMLwndDtnsVsCf3UFZqyUMDI4UcG/+Z7LRWh4Tm8OhWWJIK6tvWQB3z6fO8S/+pecpqrQdehTHAXIgErUHVb6ciQ5+kZhQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 638c0fab-57b9-4cd7-994b-08de8232e09f
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2026 01:33:36.3185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KI7dyl17PeG+BQabaXf6tFDX/Ao80rBMhgRAFuu+vr+PtAClOc04bnmM439B/q30huhr3Flc6k5t6a5xb5G2cq4O8Dm58HHjnYuu5UJtuf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7374
X-OriginatorOrg: intel.com

A new NDCTL release is available[1].
 
This release incorporates functionality up through the 7.0 kernel.
    
Highlights include new cxl-cli commands for media and protocol error
injection, visibility of Extended Linear Cache (ELC) in cxl-list along
with a new ELC unit test, and a unit test for address translation. It
also includes additional unit test and infrastructure improvements that
improve test coverage and overall quality.
   
Thanks to Ben, Dave and all the users, reviewers, and reporters!

A shortlog is appended below.
 
[1] https://github.com/pmem/ndctl/releases/tag/v84

Alison Schofield (9):
      README.md: exclude unsupported distros from Repology badge
      test/pmem-ns: fully reset nfit_test in pmem-ns unit test
      test/cxl-translate.sh: add new cxl-translate.sh unit test
      daxctl: replace basename() usage with new path_basename()
      test/cxl-poison.sh: add test case for unaligned address translations
      test/cxl-topology.sh: test switch port target enumeration
      util/sysfs: save and use errno properly in read and write paths
      util/sysfs: add hint for missing root privileges on sysfs access
      test/cxl-poison.sh: replace sysfs usage with cxl-cli cmds

Ben Cheatham (7):
      libcxl: add debugfs path to CXL context
      libcxl: add CXL protocol errors
      libcxl: add poison injection support
      cxl: add inject-protocol-error command
      cxl: add poison injection/clear commands
      cxl/list: add injectable errors in output
      Documentation: add docs for protocol and poison injection commands

Dave Jiang (6):
      cxl: add support for extended linear cache
      test/cxl-poison.sh: detect the correct elc sysfs attribute
      test/cxl-poison.sh: use the cxl_test auto region
      test/cxl-elc.sh: add a new test for extended linear cache support
      test/cxl-poison.sh: add support for ELC in poison test
      ndctl: add key cleanup after overwrite operation

