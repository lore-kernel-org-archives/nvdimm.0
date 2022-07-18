Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BED3C0A
	for <nvdimm@lists.linux.dev>; Mon, 18 Jul 2022 19:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658172074; x=1689708074;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=C+iZG15onvbFs2lacgTM//e5BMf+pHb7mC51jmIATlU=;
  b=Hy2hhxG+oqsWKchxnUXoiUn6JF4rmvVE9w0T7E0BWiSXPljUtLAlrLVJ
   GgTAEJqlamhVhYkN2rNGzDhtGmQWQq2WpoXzuru1A1xJrd96NAaE9J3er
   6TbqPw1RoTdfgQDgTt7tlUNjKtUsmxhf1XZ8FwTyUTMOGCKooZFKD2LeQ
   8zrA/nfJIpJYfFnYBILHy6nJ2Zi5gBfQBRkxIdFKGBeUI2IviuyjyyvL/
   YjXdGaXHAcbP8SgKlZ/tPPFMk99GEvHcCck8xsjJ/+SrM2prBIn1vEHcj
   U/Ok5jcW+kMpW4HhWebc9VKb0R4vYjDPGVbBPZ5Hw1WYbemBMMQ5vIQje
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="285059912"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="285059912"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 12:21:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="594572864"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2022 12:21:13 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Jul 2022 12:21:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 18 Jul 2022 12:21:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Jul 2022 12:21:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJM2qtf9/76jIZr8AqiTPF5FCDmvbPzbImOvXLKOCzEwLGaVQA9/KyCHtrYoGDhV2/XjrTIug1DVaUIR/7ByJfxy3lWqWUlceEeEyVdSU1Ys7fSXD+3t7n6xZJD+ucdTfYQOvCrjF6gt8ReIT8aJvmxq84VV6NTz5Z/bTENxcuoZGWeHIwyVzhNH0gpVfoVuDs5KfsDy4jlGGJdTjB6LdWPRSfp8Fle9rTqvh+++oeiTV6gB8UlS5V+rwm7PFnGItKLSSZj5VIhm4M6Ig5goyjTFTdDbJXUkztEORJqJ4aTwuKb254QpQOpJRFv2DkuNiEnHFrvVWS6zrALxrR0OfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+iZG15onvbFs2lacgTM//e5BMf+pHb7mC51jmIATlU=;
 b=SBMsX5Ajp2arssqN65UPTxp13kKV0nHbWtl7O5AluMVzpe5+7fJbdcfjnswfuFccnBl27fXjmSXp8+CW7xfn6piPKkKjNhkyh4LqfCpkhDaZw9jBUymYoYg+4NSZCXz9vJ09ebAOsn0BhiARO2wqcdTqnihyOJHqJtF7ZVC/m0e1gMdSc+QWL/s6KD3sCTpKM1C33LjIDZT7j3KoibcVN2QchfT5Os0X/1eLuYXGkbrUCKUHtQrW3Hf25tcoJASAwVPEXhYq/58S+Od36hfeof5Bz2EKRypxLIm4GjzXsKR8yTK1/dChUpwLzqRyxDBQedtOq5nqV7BqWSGKCyUZBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MWHPR11MB1936.namprd11.prod.outlook.com
 (2603:10b6:300:111::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Mon, 18 Jul
 2022 19:21:11 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.023; Mon, 18 Jul
 2022 19:21:11 +0000
Date: Mon, 18 Jul 2022 12:21:08 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, <nvdimm@lists.linux.dev>,
	<vishal.l.verma@intel.com>
CC: <dan.j.williams@intel.com>, <vaibhav@linux.ibm.com>,
	<sbhat@linux.ibm.com>, <aneesh.kumar@linux.ibm.com>
Subject: RE: [PATCH] libcxl: Fix memory leakage in cxl_port_init()
Message-ID: <62d5b2a4965e0_929192942a@dwillia2-xfh.jf.intel.com.notmuch>
References: <165813258358.95191.6678871197554236554.stgit@LAPTOP-TBQTPII8>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <165813258358.95191.6678871197554236554.stgit@LAPTOP-TBQTPII8>
X-ClientProxiedBy: SJ0PR13CA0126.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::11) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b886797-2241-4feb-bdf2-08da68f2ac6e
X-MS-TrafficTypeDiagnostic: MWHPR11MB1936:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XnRsc7y4AYypRhznPWMsVj2CxvnDXMumPRnoF/3FA3ZO4j7rtbzUHY440U2yDZp24woNL1gyualy7wF1uVa5mqnCb5YNlQZJtJP5vN3ao0/LVwn5kmB54AmP5lOVDV6Y/tu70VeBJ2DbNB4goxBSBhiEJNCZtyw/GXGX0H3c+KklFjhfh50v51vgJnn6NHMdGC1epONrIdrHFkkmCvTJ6lyYu8/8NNI2+Xs5/9TGO5/LRuRgr3k8Ze3OsgxuZO0+v92/mvklhfdeLvsAT55sf9zCifLvhyTcq5mSEzwsx2P5sdAmJuRp1c5cYi8DL1RkL0kgNdzsSo8jl74Ac98M/aYwkd5PLiQBc8KssYfw8hfEUktIjAh6ZNBXcZIsto+H3vBChKh10esHYkR9lV8xTh/UaTCSmGzGVZbW8mKwrSTXruqIUVWMoloLSJQjuVjBA9jous7W7Q1bb9EKSRsU01LtWJVt+K9Lx8vCEszbVK5dhsIrxbqFF38CIZL69g4Bc8RyzzqE9iMoGt9OWDO75QKVJo4EtnfdWFGYR6lM32HYJfpMcNH0GSBOzeFb96TH94TdFcuRw3eNL+Q/obYy7EmC+6daa+vNOG4oBZYnw7HS2uXl0Xrcm97sMUcVVuR5xKNCv2t2y7c7anDdDtpyfffBuEZgBAnUyTeWkbJ/3gHkusDTE8Z4yrSIXog/Bs1rWzwbXmEZyAHViPa66/KQsOvRG+rZLV8Xx+4dggrd/OtZ/G3GogA7yrdrHlYjcKoZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(366004)(346002)(136003)(396003)(9686003)(6666004)(6512007)(186003)(41300700001)(6486002)(26005)(5660300002)(2906002)(478600001)(4326008)(8676002)(66476007)(66946007)(558084003)(66556008)(38100700002)(8936002)(86362001)(6636002)(6506007)(316002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dvS9uLMx9q/zGgv2jLRo9DOKiRjpGCaWUww7X7gnfvsk1RRvLE6MhXug7l1h?=
 =?us-ascii?Q?ovTH5lv8SOUAid/QYlXCc47biG1Yi+dBMd45cXzMADTuiQlEaXGbSsVXAvbt?=
 =?us-ascii?Q?XOPR/53Wyhzs1Lm0f5g0eiJo6IYOn5idxyDNZm1JAKVWAeT82AOPsvy14c2Z?=
 =?us-ascii?Q?+/0QDbwJVlLSumvMXp2UZa6Pftv7gW5AJYfri9bgrtHUlNL51lp3TbTtAYGm?=
 =?us-ascii?Q?s0tuRzUROB2Y0ROhzxYxWsHi8Gt8aPQVcuuq1m/3v5GvkfOHi+43/7LdUUAE?=
 =?us-ascii?Q?bQxYvGd6CHQ43GMxKbiBoRayTFj+47SO6S9R8/nkW7OROCW2fQVoXzvsRUUt?=
 =?us-ascii?Q?6N1Qf+TaFGcfzctTcdmtquN9/kqLfYe+/ihih8Q2Fbqyx+arthH7asOrHjvQ?=
 =?us-ascii?Q?a7OSIpaaB0KG65cva3IXntAO7vf/FwNobRK23r1eDs27833LkCxnkh2z2Qd4?=
 =?us-ascii?Q?rhimcWGd6Hxia2p0DcN2ltTytRtg+juQRm0zek9fnidszatAgAjGaR4NfSe3?=
 =?us-ascii?Q?ZDaeklBwDdTDJSsJeaLoxiWsdptzg/XJZ2bQkAthpkCm0OcI8StAb1an9hfq?=
 =?us-ascii?Q?9l87P/zzehTtcATNpgvXpADU5TcecpVmkc8MNcVOX0LmGHmPZLTchySKwojj?=
 =?us-ascii?Q?zV8sxgBXNoSfibwdmJ1M5o/PaKT1ytfsBKm9sB0CNn0uyyT7mfM4yPhYThpo?=
 =?us-ascii?Q?R/iwm9f0lzHd/MlWcfIEFz30ckgQcoyXxp+n84Cy+gvK48zNxy/22CfJz1rN?=
 =?us-ascii?Q?716H1EOoC3pvHkfrrPhCzo7G2UHxaikZx5K0/KSDSClO9OA0wLvFIqdlPCrH?=
 =?us-ascii?Q?OzSloB3QU9SprC8yjsL3Od9mUhkLA5mol1jva9rBSZ/tOvHWNfHEagy13fZ2?=
 =?us-ascii?Q?UsclE88cjnFUbMf1+nUf78ROpNrQywQrN1r7qDuZzQpECzJTDapqgAu0tKmS?=
 =?us-ascii?Q?FXR10JsSfqJgUHIAv7Zdzv/52tKgsUn/3VPsv7GZCJoSiwpzdBwEQy/vawsZ?=
 =?us-ascii?Q?kXb3s08NDAe8gNWp6pzSWXehgga6+j9a9jTk1QSj+ZIXJVQoraCR8h8k1AgY?=
 =?us-ascii?Q?L85zKoOhJ1lXL7738C1Fw3ibgMpsK+Y1TJU+lkMdGouxdt1Q9qlx4bUT152c?=
 =?us-ascii?Q?zpOEldHRLe/GQsfskW4EPfZmSiAT4E0bF8WLGt/34UnfmyJuF5kpJPYotMKc?=
 =?us-ascii?Q?L8EHc27Zyf11/qyLOTXeV1RJZ7S8bfqdP8bpBw7iukYNiUUKJsyrYaPQ99Ia?=
 =?us-ascii?Q?Oy1swjRD8xr48fNhCyBm/sGhQ4JD+hBztLu5RXe1tSCEBwl7dVkhRX6YVlbC?=
 =?us-ascii?Q?weRhM0ibrqKkZtP+uoDKnjNqNybdIntxfInfW3Hd325skjM6S0fFoGZ6JNu/?=
 =?us-ascii?Q?bpbZRzxNioUzeoKq8Fi5GEMJFRcsUgt1gt65Tq4N9YiQOW3t7kWAtv2+MOTb?=
 =?us-ascii?Q?10mftZDtf7+Xn6jgdmIFsehseog+NWLoQno+EQ0qhbtojK0RxTkZQJBhg4Ud?=
 =?us-ascii?Q?BfNTRrvDK0qgWMIh2P2uNTlaeNKHVKtbUXUuFgoQmDJXQSCYonAiCkMb+5Ty?=
 =?us-ascii?Q?4GQSW4U8NKTtuICVJrizEueu/i30gPheFJd5DqR1fA5sHnfz9sDNkpqhVcbO?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b886797-2241-4feb-bdf2-08da68f2ac6e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 19:21:11.2378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNGHaCMzNvSg8EuhbSmp7xgYWzM+1CTxxBccaLnn2zAeSu5J3ig4mVyFy4hVTA7JRTlR00W77XSgiHFNM76kmfXZsTtBpknh5lL7EeWvedA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1936
X-OriginatorOrg: intel.com

Shivaprasad G Bhat wrote:
> The local variable 'path' is not freed in cxl_port_init() for success case.
> The patch fixes that.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
