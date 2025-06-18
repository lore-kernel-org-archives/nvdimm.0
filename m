Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EBC27F014
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285303; cv=fail; b=bSmg+1yfmnBfLdqrx+cwrGfYWKCXtQkq05J9f/nQRGLBxf99aA4AQjKG0W/Jgxhapxzh8jhnA+kwpMII9TJ5Wg3vsT0F9+YOfjqWBJfbwoy/ADU70s9HdpuoPuKD6JjhauwA9TB/IRoKU3SzfGPGyTPi6INhh9rG9CuB0GU+kSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285303; c=relaxed/simple;
	bh=JQgc/u9GfoS3UlVT+7SwWbyj97KEhp359PkgDFvJSU0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JnJ8YiuQsL22BT1l2OjIuQgFokYbpD4grHBcNrbdlivWt7cHpAwhurK1g7hsv4yFbr97Vd/8vC7SlwoUA5RH2fD0mXtl0A+KI3ONBkBitf+TwwmJ7uL/Td5xgQL/mwf6IXvOrqEzyNVm/8c3ddLEbLzrXvFsG/4bIw4lOLNUIaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RukoJKsy; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RukoJKsy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750285303; x=1781821303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=JQgc/u9GfoS3UlVT+7SwWbyj97KEhp359PkgDFvJSU0=;
  b=RukoJKsyOipl9PomjGIfDaEMcXbeYI+YagJ3s7fCJej+2InTQU4FJHGy
   ssRZi3v5Ju3KYcd3LYkTeB39wYmz/5Kk/tzJkTAxP2BLGuN9UqQQZUlCS
   r3r6MdaiJIIDm3BTr0j5em3UnHP9yWNyDS3CPxPQsYjTpUYjWR/gJ8Jb6
   HiJN0Vmx4irTXd+sWlmzsPrW56uLmnXjM38HMbsxtZ/1qgrlgLqzSWX7l
   2TBvkPpxzmxcNlgCyYdvCM9GsbWxnMftbhbdsKq8iNIoV+bHHW1YxufxJ
   m4nTLsVFN85Il7sHgcrfaMeu5abqsjzIeNLjqDARlXShr1mrha0E1phcM
   g==;
X-CSE-ConnectionGUID: T1NCF0uoRHKuxNnHnDDixg==
X-CSE-MsgGUID: rRuDUVfZTVaxqN9P828qwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52671149"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="52671149"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:21:41 -0700
X-CSE-ConnectionGUID: Fduumu8DRReFkOFXBCykcw==
X-CSE-MsgGUID: bbZ7TgUJQ8u5klJkfI1Okw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="156023369"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:21:40 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:40 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 15:21:40 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.61)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XOyif9BfrIxfiSwDbDxPsfRB5vJQwemPNBIhSqnmkZkXaZ73JFwSwVtAJTsjwFrOGbjvqzZydK+FgEOlCn1FqOi2yp9BV/YN4yIEVXmvJ6gD1VQolRHoMAeao+Xhg2ruoxdcfyNrYxrUYwVzmlSwk9IGUkIR1lN4LTn35ZyU7o0yVVgj77M5HuMDeN6uPc4xJQkRUMsvTm+gQmF99W6+yvX2Bm3hno6gZhBqxu8EBPI67c/4UMrYM+8OD7JqowKcJDzEZuyH0oC3ZKDUkZEj/okgGkybCIZ4X9dyg/GhdAxVbWUm55kFE4tTxIoq5IyuTmLjTbpwkr3g3CS1QUIBgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTqZclzG2jo4uh/FgbiBMqnuhOsry7LKLuIKqT+zOYs=;
 b=deoQiz7YL6rv79as9FjzzffjGupLQkvM7zDBBW+KbVpbvDzePNOUvCmYPWO01TT6MLhbAN7XNysXOt2+SXk291JvQNuLU3HIPEfi0AJoqDIkMXhd2IFfqDNXiK3/IQfM2G0UeRNr3RarKxxNOojl5HKQuvhUAI6UhCkFknxq5GimuTokkHmYE5LKS8giYlNHv9LJIcOFmw7T0F9R4Dyriq2FEDm5EZ/jfnb1lI5GqJjzHqkG6L7plaZTJvqHgqe4HCAuCji8c5A4EgIffWLyT3DYt2EsKqjD8dEmr6ychoVlYr0GNK/6ZuIefvCYP9FxN5ZhnYkMSJq5g7zrjb33AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB7668.namprd11.prod.outlook.com (2603:10b6:806:341::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Wed, 18 Jun
 2025 22:21:36 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 22:21:36 +0000
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: [ndctl PATCH 4/5] test: Update documentation with required packages to install
Date: Wed, 18 Jun 2025 15:21:29 -0700
Message-ID: <20250618222130.672621-5-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250618222130.672621-1-dan.j.williams@intel.com>
References: <20250618222130.672621-1-dan.j.williams@intel.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: c3720f66-be01-44df-3ec1-08ddaeb67d1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?M7Kll61htLBJyTL37sokHZXCRUxWoMzrwh99ej/KOUXrtVU/Oju+ewovpYXV?=
 =?us-ascii?Q?++13tHy0Cac1qXx2Zc9SN8itKoyqDvMYru1vssfq9kO0Syz615Qgi+HUFCIE?=
 =?us-ascii?Q?hxnUnOjULQAgniN2QEJ97HHh5N0Q12W1wEimoZ+XjGrxJNHXnCBc0YDlL/n8?=
 =?us-ascii?Q?O6qZt5uC1E5GnrzIHJiufaZ65d+shT3shMB9/2e4MYk0P3XhawATdNSw2TlY?=
 =?us-ascii?Q?/lVFw63DSqzERVUckxO8RMFdYPWAFEsLaOLNK2+FTLoO3o7PSS2tyDauIb5+?=
 =?us-ascii?Q?CKCJK07i2ohR8WMcwV3LZYPck3TCf+sXsqd6mFEgcLQzWuMc7XDSXfCIOo81?=
 =?us-ascii?Q?ggDOhpIrAEvGlT3+9OGg8ypmQ8RR/M+1X9ZBwTZ3aZ60YI/8pIt2sMH40ghC?=
 =?us-ascii?Q?eQRJz4ypETPdJa/cQHQwg9+wNUkX8pGsBS/9GL0gZLEVXmRh1comjQDLcKOm?=
 =?us-ascii?Q?xohQKCUOajcP+hnvndA77z/l9xQTkK8q7uI4kw2qrnGQouc+cFaigKZDRC1Q?=
 =?us-ascii?Q?aZtVaifIEfgELTVmLW3RhDn43T1yP2stHBgh1n9ZMrk0RgrfM9vhkVLjrC6Y?=
 =?us-ascii?Q?DX6HgxvkTIpY6uIxE+nypjnjr/UGUwxWY3wJ1lfzfsdPdv+yu0pipUs+5Q8u?=
 =?us-ascii?Q?CU9hvclX0qKi5Bpzo+JSIOOtTnHeGmK2u6Lpq0aXYFJpcH9A9vIvhjxp8KhC?=
 =?us-ascii?Q?JhagLO4WWjAXPb3VJ8MWeQPvJW6InCEMBP25CYN5LRCDCtsAJVVqxBwSZL2S?=
 =?us-ascii?Q?ybbMYxusl4JgULNXFxXRDs93Wd3D0omba0Ln8Czcx+PWqodlu4egpFyXpQiH?=
 =?us-ascii?Q?ldTDukFsauTHI1rpir+rDqDI1b8dDXRSSpRx/XRAXaS/mFZESH5Y7k0QNXRo?=
 =?us-ascii?Q?GGInUd8nsnot72AeU5LYNS5Xp4btV+kZ0ucFOxsNE8D+/pZVGDks4aS4HBcY?=
 =?us-ascii?Q?qfQMUkKSABF9kTes7eWVs1cn25maCHl+7vTVUf5jyzgzBdvFkFlANJXejce0?=
 =?us-ascii?Q?4KO8OHtsevsRixSUMpmJnpDMt3I/EQUtnnLFg+uNchzffR95ENR1rGj6TN6v?=
 =?us-ascii?Q?t7kvtprpcEEPsrKDgOD/YonqaD2h/I+KsLAvGIKBwu/dEeW8WuVi4WMpJhks?=
 =?us-ascii?Q?rCe75qaXWOL+v01vtWkem4eO3fneoCIQmExlGVObTQ9qqO9sPC2Cp/SnaNbU?=
 =?us-ascii?Q?1B0//D4Lm44z0HRjgs/IANFjfE+Rz2VOxt5nocqT1p0sDy2JMuN00IPLfUgI?=
 =?us-ascii?Q?2MoPOVWGZPrtGAABjWM6X4+FiTywjeGZkazvX5GbB9xr2Zfj6nXtJDpiUW76?=
 =?us-ascii?Q?cukqodT/8bYcvKKM5O3d9Szw1ewxLCjinRWP8oikulV43/Yb3CWKcZ9CoH7w?=
 =?us-ascii?Q?1e090I/bno2v27QxTQZaCnNe6K6iN7ob3j+6MIRu694QOsjoGlenbzNUBpUz?=
 =?us-ascii?Q?+CpzSOBN8O4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A3fioq1Odfv4gz+m+OUnSB0W6x2YOaL5wfMgX/MVg2O89EckDv6AhSbKJ7zr?=
 =?us-ascii?Q?HZiGOSMSt1EyQVD+NYz5SMQVBicmuZxgKOZtAUEVzz8nmT+Q3/XnXCS0fdxK?=
 =?us-ascii?Q?TmugplXNLiYvk89RV8cxDn2QWjUZLey4C4PhfDHf9RUleyCj33t2DiD/Ehpj?=
 =?us-ascii?Q?4coqXSEnbn3ZURcyHD0JCc5mYC3r3Jdp8vE25K5DL2WXlC1Fl/C+c3cv18uZ?=
 =?us-ascii?Q?6SXJKPsrcDiWSZeR4Z+AieN6cI1bMjx+3CFYqdxV1kN11n9MP/ClxGuMx9p6?=
 =?us-ascii?Q?IICOe6LU5mA79pyBJSuM7Hx0yLrvdgdqGnUPc1gX0uBGglsMMygVjtHZ4ZH/?=
 =?us-ascii?Q?ki/giswl52+aLzUEy2F0HM0zuEX2X2R04l4kTELSnGFvG+7tYwTaOIcV0Wru?=
 =?us-ascii?Q?YOwJvRZxIHKm7UGrH7Lj+lFsVdZCOqGIyAwQ0PSB0HRxam/Qy3g7RoZMofYG?=
 =?us-ascii?Q?urRVH2cwQvvN1KiODGvmK4FQ6cm41K1QRHEYv3bra+Crddxgg2/CFiPqdeag?=
 =?us-ascii?Q?63tJKHXVf93YQjrGw0bakUtVk54FcFnibuwXEqvt83J9Hg2sP6ZQmlIuJlZm?=
 =?us-ascii?Q?CmAKJns3L9ZzBY10VunJMCbxFZi/4yNuuRVmXzeHR8ik0kVrGHzKiez99NZ9?=
 =?us-ascii?Q?Dpc2ZGCDW9K17xgriVZbq1Qx+9a3XMAafunsh++S2Qctyzi/uHIA2ADwHTJf?=
 =?us-ascii?Q?sOX0RMLduFMA3S56YJjLheYiRbyjli9lLN36ELjs4F9rj+uGR5OGjUz+ZYmV?=
 =?us-ascii?Q?cmZSQp87Z0jXttNsEMy/kVfk0FvgnJmy0ZcD4RyJ6nLud002eW3LetTXKdMN?=
 =?us-ascii?Q?/8HXs66DHIGtizRXrbLeW7iATe5KA2pL1Svxpy38qChulKxoXEUhpaI7AP9w?=
 =?us-ascii?Q?PaPa06etLlLmNtevah0ILe41zRPQ9s66+GrItbAuSDhazeYXeRuIWBE30seo?=
 =?us-ascii?Q?5e7ghP6u0XC9091YnQAQzvNfoDypQICrF+8QOm7Nak2zykyeoS8O4olJxcr2?=
 =?us-ascii?Q?ct9a9jHkBKwfMDC3oRr3YdpYY+M5Is+Wdmmki/DttsI5HoqmUbdUor65KA1M?=
 =?us-ascii?Q?Pv8YllZjG38JsKnujzu3BSUmAMCGNYTfn9VbTNQx7H4t7+5Z5JBcBN1UdQjZ?=
 =?us-ascii?Q?BZGHmFa9Emm2DtDzaU/Y28uBDvmKJ4o0hqsVrnJ34AM9no98Vn4YdWuZZuB5?=
 =?us-ascii?Q?vm8sEgMS8X8jHIQCS0/1w3swxD0fnKBlNRQlk0QtEAqvd2/b/1H2TrmKAo8Z?=
 =?us-ascii?Q?RmzWduai3PqYfxP4LCFmc70x+5PWoqFIG5suiZKnLDcePKBq5YVerCFYQceB?=
 =?us-ascii?Q?HlOoZl1igL1EQ4FQOJnCbYY88UO4zrRxbm70xCAnSoog+Bi4AWVeEZMmxlx/?=
 =?us-ascii?Q?+p8n9Hq9pzLaF1aF6lufrqQXWXcm2hdX+GkGuuGBQUU8T7xnxdiGuYmCQdE0?=
 =?us-ascii?Q?9XfSptddqaY7730ke9abP3QQ36jMEciI9MFdzw4/YJxuLRNpGJ7cbSP/POYS?=
 =?us-ascii?Q?EbEAM/n0OILV3diEHbmr+420bQHhZ7Dfq5dGAN3yuSSYx5XWa7+yVZMol4Aj?=
 =?us-ascii?Q?O7bhpmLKtG7F9oXNygo6oVVCtQqtDLyjnoi0BAgGit9X1fQlN4xHNQXBIchS?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3720f66-be01-44df-3ec1-08ddaeb67d1a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 22:21:36.5277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ik1nh/ewnGRLy9jUVHQuaOZHz7mXdFpScbBwh5uLGTnSH32jsZIJH5FNoWy5riFA5FpChyF9HTe4SLA3ky2MNau3qs8zhHX5QfLXpGfIb/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7668
X-OriginatorOrg: intel.com

After recently needing to manually rebuild a test environment I discovered
the dependencies that need to be installed. Add a section to the README for
package dependencies.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 README.md | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/README.md b/README.md
index ac24eeb28b6b..1943fd66d432 100644
--- a/README.md
+++ b/README.md
@@ -85,6 +85,11 @@ loaded.  To build and install nfit_test.ko:
    CONFIG_TRANSPARENT_HUGEPAGE=y
    ```
 
+1. Install the following packages, (Fedora instructions):
+   ```
+   dnf install e2fsprogs xfsprogs parted jq trace-cmd hostname fio fio-engine-dev-dax
+   ```
+
 1. Build and install the unit test enabled libnvdimm modules in the
    following order.  The unit test modules need to be in place prior to
    the `depmod` that runs during the final `modules_install`  
-- 
2.49.0

