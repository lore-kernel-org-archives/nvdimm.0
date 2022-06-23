Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE832567
	for <nvdimm@lists.linux.dev>; Thu, 23 Jun 2022 20:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656014556; x=1687550556;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=8h3moSri7Dqc+eEln1PRVwLFmUSq0kaCeqGSEGmSNrI=;
  b=njyq1j/+kS0aRf6FQT4Gun4L2nOQ6OtR+QEkV0zJO9JiYmprrfcU6rTt
   BzfJs7akN0J50wtD5lD8LLRj7Up/HzBY4c6uYrILTAik+YYSKCg8cMFc+
   A7gtNqj1X6vY7FoLNc2cvqy3oLVau0l6qMqKFExhRIElEf5L3cB+MjDnK
   LZj1TFtGfRBJBY7iHLqcSQ2x4/yGHZ983KWQjOzR8hx6qdrlOtUYcVH5J
   XrLYxRL/QCNPG4bRPJEjtrTT9ZWhac5GKqauZ7atm4IcU+iM/FRVa4Kri
   wmcbG+vmGcuBz53Eg8+h43u24ziGxBZir+zyewfhsipx/2WO6nL5pPBYm
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344817543"
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="344817543"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 13:02:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="834795169"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jun 2022 13:02:36 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 13:02:35 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 13:02:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 23 Jun 2022 13:02:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 23 Jun 2022 13:02:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbGj9BlbtU3604m/k6i3JjPaMUYtjfwh7kmxZh+GnfXDlzRG5kI5jbSKITvQJaQXG0U16NRUGv4k6gUOmp7hh6M+eqVzxsqLbQdwc4SAhlesllQBgkbe9lzlX6Eon9mFAfK3UeBtqUIXfQFyOS4+nQ1OS3wYIa5A6wbH7Ozmbmv9/WJIdDYn/L+/dom5rm+Y8Ep3tDbak+eG9xZnGhrxrQE63dDbDkRSkvTHkznyNKBO8OkRcgEvUwk96+KcMhAS2tafgU8gMPwSt+XpI0Iz4RKgbk1jaZlo6Hl3ZBRRmGiyJkRy0uk8gKjs7Z8BOhpN95WiRo2J67PjUHE7tupFhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vfW8d+uWtFeqz11LAxcowjuZ0GMe9tbsoeWLvvFLWY=;
 b=ORVw1b2fsqaM9uvQBexCaq9gG1693Zb+GSw3HNHysfVYwPXJVjFBsp2snNsOPEjaDW5kERvgCC+wzzxCp1PdgKEHekSGy4D9Xe+Mao3EBf6iAZhAJd+zNwev8O5qm6VbigdFyhVJIEqGcx7BPzpFG9F5sNmrFLDL0tiNbaLShfM8Fk2P7BfGdtKjOAaQGAUulmBuyimNDFqIYJ1b8M16KyuG5PsjE0Kq7gKm0UMvZaARhaikkMLZ4mYvY6mn4KcAkoljtszYxu+ca7lMEQt0Ez+VQMBktKwnwWxqOSOSqNhtjp23oHHh8gJ/0dGE+8rEVwTRlJlnRDMClqJ2qFbmVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BN7PR11MB2785.namprd11.prod.outlook.com
 (2603:10b6:406:ac::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 20:02:33 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 20:02:33 +0000
Date: Thu, 23 Jun 2022 13:02:31 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: <linux-cxl@vger.kernel.org>
CC: kernel test robot <lkp@intel.com>, <nvdimm@lists.linux.dev>
Subject: [PATCH] memregion: Fix memregion_free() fallback definition
Message-ID: <165601455171.4042645.3350844271068713515.stgit@dwillia2-xfh>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: StGit/0.18-3-g996c
X-ClientProxiedBy: MW4PR04CA0089.namprd04.prod.outlook.com
 (2603:10b6:303:6b::34) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1a67394-e982-4d82-fad6-08da55534f74
X-MS-TrafficTypeDiagnostic: BN7PR11MB2785:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WBKdAL/08BRPu4Zw7PEQ3cyZZh8zjX/m1ll5QkMXodg1JLHWUUUS97dETlOUY0qKEGwMkVWZ95C8BTcSBaxQvKtXFu/DNFCPvyZGv9bq8wbUImzfs1y1/hZEmUD1HWOVkmnhcI/+2gtY/RUnmh6y1l1PlLFLToo5Q85pLjHSfgHpQ5aB0OvLriJSkdb1GMVmoj+uw3tpvrsd9va+K094wJEHRUwnAspdPSqMfsQ2USPupI1fGlbpJ79UbrWnMbvM1V3MLXd6L7zWvwSR8exu30OKDHVSHL6TYez9vwYrt4dY9SpayChCC3R0neQ1TDbukeif6O0PfDPEucIRMB9k9Gg0Tkii6H8FqpsWKx7dj9ELck7YkEU7Iya/r6towRVURAIwH5YbeQBM1wp/wWyUiFBzYmI0DBwq1n+FzJViDBImbPgLABw1KwbwbFuwDJDMZKpx0LQJQKQEbOMRReuU6bTtOCctqg9+2EPMW4vxFGb1uAE2uBSVVkGv6R0ID8H1DwPJ5rROUGD8dgSCFrA9jKrwmKXrFPWc8VbnkFp9dDht4/MGzGnQS7Q/YCYtRIcvUstDTX0uEazKBXQb4EES0m14dYJNB9zGB/nK/n53kvuwK48fh6ZRel7v3jYtqJWMmQfLahwtEQcHfzGWdFPujy+xPZ6dhdVJVmrapl71xKTiuZWZ+qPzmbn5c9NwL+iEkhE1Q6NU8WPnQYVd9OxTV7Ci/XHlhSYdUf/DddyasJJZkBi55wJr1pBKdsWAArG5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(346002)(136003)(376002)(39860400002)(396003)(5660300002)(83380400001)(186003)(38100700002)(8936002)(4744005)(4326008)(82960400001)(9686003)(478600001)(66946007)(41300700001)(6486002)(86362001)(8676002)(33716001)(2906002)(6916009)(26005)(6512007)(6506007)(316002)(66556008)(66476007)(103116003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XexiAXRfiI6bEV+Op/SEcGCPGIEM6bu9GvV9MziDExhfPuQY9cdfPluDVL9g?=
 =?us-ascii?Q?KsnmqJk1FxdstX2Gwo757W0PeKACAdGcT/OzJebgRZ3D7pR37xNVIqKIp3Mj?=
 =?us-ascii?Q?VOvoICUdQ6MJcc9zafXfV2dRshRKXZOMM9B7d9Pw+jfnfXKgJA4jBhsO5onO?=
 =?us-ascii?Q?Jk/xoTZchxHZDrdIgKyHaNqntA1lD7b4CpQWDyXA6nq8HQFFSjzAPqi5bojp?=
 =?us-ascii?Q?dL8iK4KabIV0XLUwQyqADpG/nQOKguwpwF/Jm8VhWRbNVmWBmKj8uil621nl?=
 =?us-ascii?Q?txlc1gt9hdmxeCX1mNGA8b3Vqr+JL/tEsHEplwFbUUa0U10Tviymg7nLKta6?=
 =?us-ascii?Q?sHfM8Y/Zq6YWDsYbn6LXdZB6zcKu1CcuClDXlDM8aMdzMmQk13Icuq3bP8id?=
 =?us-ascii?Q?TG0dwK2ac4Ybsy+DhSoQ0IFofK9WGEU/qIB2Cx+VWsYPKW7eXfucUM48N6DK?=
 =?us-ascii?Q?M4mNSDns2XY6wG9nJJ8NY1uThuw08l9DmtDdkKzLcqx28TIX0XI47frQEztG?=
 =?us-ascii?Q?Mu45pnHRffII1XI6A+WEXImCGTbLAbjWeFKhoka90Ze+d45zOyKKEW4Wezhi?=
 =?us-ascii?Q?FDAIUu27+az3CHz24LrITLvLfPcteeKhUGYaN4HcjKl5wSyQLOWbYD4P4yct?=
 =?us-ascii?Q?nvRsZAbGsb6onPyqBm8SqOy3h4p7Ye9JDZeuXA99w+0/zIooD3TGFLD2610b?=
 =?us-ascii?Q?fuPFPmLUhcRluuVT0D9+SOwm9lxC/rcnebAS1OMNDdmcbtM98bOLgbZaQ2zR?=
 =?us-ascii?Q?+lUMVo/5Nef9LWlMT6h6i0CRGdFdKTROeAkokhFlDm18O+89eoKFQDGe8KKe?=
 =?us-ascii?Q?3u1sTurwwjCIfsNNTbmuYiRMgfpu1ZufTMvA9Q2IALmlQqtrGFYuaHaxrWpe?=
 =?us-ascii?Q?Q+3o3spH2PDsQWSs/OLqVrlnzbSZY7pnwpQfZDCnxRpqO7oQKPxUc5qhyfrT?=
 =?us-ascii?Q?1zHnwJ64xL+3IjbwpUp3gDBwwUgwOYfuCk2SgIVmDa+TaDPwOI+idXfXbu28?=
 =?us-ascii?Q?/xLyVWvtFLSqlBNwp10bNdvG0kxgR6Nx2NKZcH4Npj8cGL9EuCKid42yiNXQ?=
 =?us-ascii?Q?4hHrTPZijdPHfztUBm3KpMWL6ASLEJVoZFG1U+ABp5ItLLMbJmEtzl8IaIJ7?=
 =?us-ascii?Q?pt6eIJjQbpyUCOmciU9TucZNbzQjT476AoEptekTZrdF608/50vMeTIqhp0J?=
 =?us-ascii?Q?anlQ+P8FutUsWXAsHfbC6R7d1ACmqU4H5JbIxZM1wi4W/MP+4plLUne9st9o?=
 =?us-ascii?Q?d/seCCq6nLuFXFbXLevDlDA1HY140BeE55ARTb9iF73AJhoPJXtJv9TiT22j?=
 =?us-ascii?Q?9lwtJhrtVVAJytaf2NKdyzcse8cy/SVI4ZlFcstTiLJYCBPe6I5WtOqkEVW+?=
 =?us-ascii?Q?k9Xo1vttmSQFdyU9qcb80Cu0n84nn2smiUfNKdKhd4wELM18Riy4fYXav4c/?=
 =?us-ascii?Q?8q6dJiqas1ARAhazt/ypo1epq5/xiZpxeoH2ZURuD8B8M6kDDSYiZ7c5LMlY?=
 =?us-ascii?Q?bO+6u/IeInaumORwOSEUSoPIymsld33+dd4Va5lG8IKMtlEHM6PzllDloAyY?=
 =?us-ascii?Q?PT1JqPKMzjOAvXnjsvbQqcsE9UqKNFzcZnECqH0kUEe6cIzeN/iclWbIKMZG?=
 =?us-ascii?Q?OKkK9aMf5zw0lbiiUDSzFUKTJeznSkO10Z73LBV0qLw2cHBWuZWIOceT+sNe?=
 =?us-ascii?Q?IgaovOtaK3OK++iwBD1i13VAwBqvgFf9Bhn/L3MpwX/p0DNRclPIvzHF6Q9n?=
 =?us-ascii?Q?U8HRIalWgtg7rQqjYpq7QFThxKne56o=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a67394-e982-4d82-fad6-08da55534f74
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 20:02:33.1465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOeDrYd8H8umpilNGGNYd0rLu5gRf/QxZNXj62rO3WYtAuKNxiF/yNL2atCJhNq+nfFqgVZzXTBg91lPFPpw0lTaxQmZ/O6lUqj8X0pMsjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2785
X-OriginatorOrg: intel.com

In the CONFIG_MEMREGION=n case, memregion_free() is meant to be a static
inline. 0day reports:

    In file included from drivers/cxl/core/port.c:4:
    include/linux/memregion.h:19:6: warning: no previous prototype for
    function 'memregion_free' [-Wmissing-prototypes]

Mark memregion_free() static.

Fixes: 33dd70752cd7 ("lib: Uplevel the pmem "region" ida to a global allocator")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/memregion.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memregion.h b/include/linux/memregion.h
index e11595256cac..c04c4fd2e209 100644
--- a/include/linux/memregion.h
+++ b/include/linux/memregion.h
@@ -16,7 +16,7 @@ static inline int memregion_alloc(gfp_t gfp)
 {
 	return -ENOMEM;
 }
-void memregion_free(int id)
+static inline void memregion_free(int id)
 {
 }
 #endif

