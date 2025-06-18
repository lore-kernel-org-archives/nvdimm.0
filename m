Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821B727E062
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285300; cv=fail; b=GmIaVWUedi9ZzSm2/xJ/z8geg6lM4cbaGjxpMrubyPS1N0VTqLKvHrN1AI7pvxYjItV2SVF9N92paG6FxEyoxEMzQaRPlZ4cQVlO4Gxx1LoIl7pFqnj+mCI7DfG9ztO/aoFN58c5Lz50aEOH//mFu4LaHhQWGgjDgOZ0mJA4HZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285300; c=relaxed/simple;
	bh=5cJxY9sxQHNgKILh4pSYlhS6m6+9L6WNcCWKbBRCv9c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sofc/l6w+OVJhn/fdKIOWxmXG2n0Cblf/WQwvlbNKT/8gZU0tbd+0qj0UEJO7kGfCBAAiOApvioAuQSdyBcGqpirNeGLe7zsBYtvvtWWLrtwatKu8Zl8NiBD3Yk7/xf/fD7gMdmiY6cL846XaqzRgJb4i33bn4BeIRfDIlJNnjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SvqFEcin; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SvqFEcin"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750285299; x=1781821299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=5cJxY9sxQHNgKILh4pSYlhS6m6+9L6WNcCWKbBRCv9c=;
  b=SvqFEcin5C4eojhZjvRlsCInCHHpldZTP7HomXhjxpNVDIdrFGpIlVfz
   llIqJ0vYx58nzcfAbG4HpNsU+7HowYKFKYfLqa7e3vBC/Qvzl9iCTjepS
   rYChsGESLtZCMMxpI6q7OIRtMNXFqTxR9ZRYnuBtMjZCHO5NXxIHKe5XZ
   y47hlfuhhJhtNQnRqiN8sbPsP889VqSw/0vzAKEuEtZwgq2v7q5Jgas0Y
   +3QB3wJoXnBOqOSMGhSkOijYlEE68hNVvlD4kibdoxtjuGeG4jWu5ljA7
   k66gGYUlF4QsNcxrTLTZu5lNWe3QjOzhK1OR/m3UmBIgZ6n7uFReINiFq
   Q==;
X-CSE-ConnectionGUID: b80JAOPbRlGBfdSClQ5TCw==
X-CSE-MsgGUID: dLumzZONSEiVHUfFmXamQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52671139"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="52671139"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:21:38 -0700
X-CSE-ConnectionGUID: lOOO0HQiSL6Nv6FvIWMFGQ==
X-CSE-MsgGUID: g2tiZuGgQtO6WhkJHIckNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="156023330"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:21:38 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:37 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 15:21:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.40)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=unLdDIlWLGK2cwTeevPVAe6QGVREA37+srvEb2s3SVpjv4gHOv47GEh4IoS0CxMxxikmzqkmHrXrrgzAESlK6WzngqvOihZQDmrY9F7OvjeJ7dBDFGdXh4rD5hVugiO++e4vfIpkY1Q2+I8fts0apMjnL3Uc7R1qHsnj0tghlQI1FE7tQTiM5U7iQISU30GrNQ5j6cGLrL7CqFTAtvu0fW62g1WtnqlB+Q7IEeorHIspI9n5VPK8AyWtV2MtB77pPlaSNJhiXzAdxJPmmd+R56KeKVXgfGGd0zoOhKXS53o6pQcPjsuIak4dzxg87pm5tsPkzABhTXF8AlFM7KlccA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WH0Ofjm4JwVesLi7ZU+yR5Rwqd2G4xsNbnQH+fssblA=;
 b=deMXNw1Qzk+pcWSon/Xr7UXznJtZHJAdRNoMN0s0GKml+Nb9Yw9FjQbkeH7osvvWeBaIS7mI5Dt2qHA8s6l2ckpmGEoR7ItondedpFaEyNFHwxAxp06v63wdIMPJO/o9aivxtatk28r+c0qqMLTI1RtYQ8cRhLBmoHBhdexvCk0+4eGcwcrI4z0HulhUDEC+rJwwwd7gZpop5VZfE7ht+Pxqwh4seRELO+09bxVAowmJdwy895IPzG8qZ7xizYT8xhntZ6Cm9asnKxs0OuE6tAHPvOLlO2KjDCM9amX8145mnFeh+3KnPZ3t9Ff/KVUSQKUcwA3iiiaCgHmuuS6Zxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB7668.namprd11.prod.outlook.com (2603:10b6:806:341::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Wed, 18 Jun
 2025 22:21:35 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 22:21:34 +0000
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: [ndctl PATCH 2/5] test: Fix 'ndctl' dependency in test/sub-section.sh
Date: Wed, 18 Jun 2025 15:21:27 -0700
Message-ID: <20250618222130.672621-3-dan.j.williams@intel.com>
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
X-MS-Office365-Filtering-Correlation-Id: 29d0ad89-4b04-4a28-d040-08ddaeb67c24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0qi/Q7M4UgxUfkrhpQ8j9x38aSTX8bK4RvxbLfTI5raT6dWwpNIO+82aSXlD?=
 =?us-ascii?Q?q4wRTCGb5PatEuqrUK+E3zXuz7UD04oJDW8WFfeGEBluUiRlpCAm0k6x4/KS?=
 =?us-ascii?Q?EFWY/Xvu1mLkMpWnuq/Q3zJBYgB0EwYE0VEIwUCQN2x/+mb+WUybdv6Bt0Ax?=
 =?us-ascii?Q?Ln601P0Q6d6649CPzgH67dzaC4oM0bGtKLHr+/P0mPgtugAgs+QrV2t0/2LI?=
 =?us-ascii?Q?3XTxHrYBHDIMG1GUUdj3vp0/uKgICf7X+qxt6Ni0yXkXs3pkmKUp/zYDpDUJ?=
 =?us-ascii?Q?LTCt7NdelgWfadfSIna48TQVihavsV8mCZnbLa+RZqY1+li9i1HbU9XAcOjC?=
 =?us-ascii?Q?2sHBbdzy3nt7c88nbAR/jt1Pt38CnwMWXLoIGN8mg5sz9UsXsUdhy4fvLI3r?=
 =?us-ascii?Q?rrb/aqiIAxbG5V4VkzxYjkBM10s3x3JEfbijJa+jKM3K9L+zUx2CBm8lM554?=
 =?us-ascii?Q?s7KpaSjPuCGBas3WntTNbbd98urfDK6BKTMgeppcWXWbauBaIl4FkTV6JsGF?=
 =?us-ascii?Q?4hFcuLQYb66sj0LZS8MFkiGP7mCkEA/O8iEvG2ev3b2h4v5gAezhB2QmlXNz?=
 =?us-ascii?Q?U1SkiDxfimPyyHgQwV8HcDcDwaj8UynvQSU1v/Rb4nJM3JrnZi2tIkEqr2wZ?=
 =?us-ascii?Q?mhOToP+OEwksvZVhdnSYrtjZ5tumobRAtNfFcE8jq4XskkdGzp5b4B32Nqgh?=
 =?us-ascii?Q?hmQ3bcYsAqZUkk9k8Qmqg73f52ihpNNNYe/aDSajMl7wPJC1V4qxZbzmlbBF?=
 =?us-ascii?Q?LxSpfbFTfTgXQHvvjCt34p/oZgEMsllDSGDLPrCP5wT5ZVH1dJNMYRjGUT3F?=
 =?us-ascii?Q?3eeDvCq4ANW0ye7xSj4gdlLnhN5FW5485rq1UbDyE8gfL7B/O2YAShG420U7?=
 =?us-ascii?Q?s/UKNtjddDxRRXxhCfbRvBaG986Pi7xiZoLuYCwsqcObKUEoBEFB4wZjwcwx?=
 =?us-ascii?Q?OF3gr33nW+1XgFJ2aYA5NSpuCC7ePNHlv6ChbMVkme/h6QyWT4pg2hpIrJHP?=
 =?us-ascii?Q?YOT5gl7+tGRtyupzBJ3jNvkP4pScHRLwBMg+BJqPYqAP3zyOM90JZhgrt3zO?=
 =?us-ascii?Q?OYLluGXsxPQ8vX1WNy+8hfi7ROLalCMlSggqhSD/0gb77oZWALPbGT3Fijww?=
 =?us-ascii?Q?MV3niWiw2BQKKCA2nBewEJ6L7fH/Hn7O+3vwql2Za9EQas45nf6tCxWU4T9r?=
 =?us-ascii?Q?EJRF4o44p1aq3NltLIt7FkIo/+uCxYavzfY/GCwNhmoIPS/5ttHs+1ddEtmY?=
 =?us-ascii?Q?G4dgEfR2I3CJQL9E40SCgJSLq+zeNSySdJ37TFTgoICEHPkGuBIoKp8Tc76p?=
 =?us-ascii?Q?yrpubiUVwqvZYuPRmwLXB5/rBkdXlIl/30IV8nVM1OSGePXidXBT9bEgA/4c?=
 =?us-ascii?Q?EeyD8YbV/pJ8vSpAp86LqtGk6Cm27mFTI7jXVTNxjvDnQZwWQa42r6drlBdX?=
 =?us-ascii?Q?N5SqGSGIVV4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k8S9LbeDJUGzK1vBnU7CM3xV7N3GveqJ0xt5qxm+eOlcO+f2PAdbWOnSdLeI?=
 =?us-ascii?Q?c/Wol6Hmc59PSWjd5eQwRD3qxqdq8CF/ZYnpoq/LZVUxCGWAEYiDa9H0viPM?=
 =?us-ascii?Q?BJvpvCmCebRHKXbdDhnEVPdpaAvMJaVsbvuJBoppWPdNhtkfY4x1EWr9ILfs?=
 =?us-ascii?Q?c382P7CW/KZrVDB5prwhPBQyU3+fVU8zjw/vmzssixPCMLoMKTYx7EJ+24Ap?=
 =?us-ascii?Q?7oxrAH6r9Nsr2zgfiNjeT/dkiNQrnIO4G8eE8GFuygQ0CfNn31WaBK+pECJg?=
 =?us-ascii?Q?VALgFk5GhxaNu5fl+W2AmevkkScoORoqHJ9JjFOGK01z/V7WHthQBKjdo61Z?=
 =?us-ascii?Q?+aQSvVVNVZvKTJEWzFtXWkmikJG6gFOBybWvMKT210okFP9az8C7YaWb9lbI?=
 =?us-ascii?Q?xgC1p4UVeMq3GuSnMV+Sy/tcQyzIw5CQXuN4H0n03djl+9l689jhTJFzkUuU?=
 =?us-ascii?Q?NvNi9xPcwZoTSjDTE3QNrBHIQC+4RmPzCA7B+ssW14DhHzcH8IVNWc9qef0g?=
 =?us-ascii?Q?IcOzzXKMtYyW8yoD9j3CUzVOr3Z4gRDw3MVDnmPRqkbuOAyVGXSYQoK4U5om?=
 =?us-ascii?Q?QCJU471QCcdaLp6gbmEPCR2ZqtyvDrgPqpBlDA/5kFsRhbWsFJQDw0gzZN+j?=
 =?us-ascii?Q?BGMP/1TVJ7LuDkKgE1ldwvUDqPYE9eiqJ0jHSXqT/qo+ya865rU3sEtuQVAl?=
 =?us-ascii?Q?mSlS1YvUZMJMcIm90o9IvT6hsBD0xaDSmG+f8k8b7W8H8eogTww1h4stuXDL?=
 =?us-ascii?Q?V4hSOl9nmIsFzFqmirv4oXgUw4HGUxVotpHBYSbt3RK5gGELRCNq2AzcjMWm?=
 =?us-ascii?Q?LzEJHd19Ba31cg+PQqiS4Hp/IkOo9L50htrRE/sIseHyyVa2GELS6J2oNo/r?=
 =?us-ascii?Q?MD7/wDoq3eg9b7fBqnPF9Gl9+lLIie+XopkbR36mGHgwlDFdUaVo36dH43AD?=
 =?us-ascii?Q?ZhCUpj1LaHZhx8xZcuTUzEih5q7iyex0d0v+yYDlVrRQ5dG8usHLPWAINm9w?=
 =?us-ascii?Q?UmsHJO4Vsbu7xWl3rCrsZEWJ0KmYbvxqnr7I1L9ZnTrDMtAQucShKs4fl7cg?=
 =?us-ascii?Q?Xi9kyJPnwCBZyg170jGrbY4ZsoGn5E9DJ4sRGCSDvI3X8TvcEyjROfjSdjbY?=
 =?us-ascii?Q?h50LeeQg/2/wLebR1piNhKPPrfEA99iwBFRrsvSGvAcz4RamJn1h73PK8Hz8?=
 =?us-ascii?Q?gvuCl1FeOoFMIUFw1gOPCwTP2+y5/4RuSBx5avIHEJ/bE2ADf+LyJ+pA9h2u?=
 =?us-ascii?Q?GSBOz5QPjTbvx3YAReAs0kAVqZ+RBpwZJk2Rb3dctG/+3Rg6wFBjbwn3Ul3L?=
 =?us-ascii?Q?UvXUc9SkEeGIuxRVa0krahTq0+KD5OpDT2z230uSrvJwML2wRYSLeP1w6hdR?=
 =?us-ascii?Q?sjCLh1kvlRku4Iw1jXn1VsxqeTdBj1Qudxc1xP+Pdqpl2TXAk1sbBjv8CQn2?=
 =?us-ascii?Q?QriwWukjdLtSKJPl4MQlQikIADEqKpov/YdVK4tflOWARMgIj4HahZhJqanJ?=
 =?us-ascii?Q?/1sZWfypPhnIAD+VbWmdjqdoBatGb8Zr/XTXmJg06XpTvOItUm22zwj8lQmq?=
 =?us-ascii?Q?qraG1H2nmgkaTQOpdWZaiOFNbMbTCQp5kp+nfg1ivHK9TQO8Ch4+dAY4fgo+?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29d0ad89-4b04-4a28-d040-08ddaeb67c24
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 22:21:34.9306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: McVsR3il5WyAE+T84T5Cx/rc3m2lIvXZ9S6pboDCnDrFjQZt9cVDhTAon+gfbJ8RyA1Rfpb4qpYpKqxpioxwNyROFpR7wrlD6qa9uzLcfoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7668
X-OriginatorOrg: intel.com

The test fails with:

"sub-section.sh: line 23: ndctl: command not found"

...it should be using the built ndctl program, not the one installed in the
filesystem.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/sub-section.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/sub-section.sh b/test/sub-section.sh
index 77b963355c8f..5acc25eefe87 100755
--- a/test/sub-section.sh
+++ b/test/sub-section.sh
@@ -20,7 +20,7 @@ MIN_AVAIL=$((TEST_SIZE*4))
 MAX_NS=10
 NAME="subsection-test"
 
-ndctl list -N | jq -r ".[] | select(.name==\"subsection-test\") | .dev"
+$NDCTL list -N | jq -r ".[] | select(.name==\"subsection-test\") | .dev"
 
 rc=$FAIL
 cleanup() {
-- 
2.49.0

