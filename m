Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8847F4
	for <nvdimm@lists.linux.dev>; Sat, 11 Feb 2023 01:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676080428; x=1707616428;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Y7p51euJPLppe1+bWbN0vFLOBTq5FJG3ZzxdAOopU90=;
  b=ZBadSGsgbu1LV+fZ/b/H6PpQG60H5OaE/4uG3dx6oP9BQY++S4uWJ4Im
   tLJ0qzYtS8a6TeejeidhP2HjorDxUklZBVDHxMzqQpMW3/jgqTeIt9ils
   rPPOM6ZoiAqITjpSm55wWK6raKhNHjAn4s3OluNHedCrkug5J9VkMWL+C
   kJdDxNDAkyGtSqRqOt+pVEmINfJFOKsp2VZSsfbxeCqCL8Feszda2XH2j
   +8EJMtsu+vJsPOCTc3teEYMYvlCz33HDzRM710S8K6pbqWjx9dVuqjRjn
   F5zWOsp5EJ8z9lzzmiHv/SHp5nqdK9D2Zb9GPnUr1cNucBWhG2fRsiT41
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="328265899"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="328265899"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 17:53:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="618072858"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="618072858"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 10 Feb 2023 17:53:47 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 17:53:46 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 17:53:46 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 17:53:46 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 17:53:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFkm04ihCtH4FvU12IfR09tMihob7M4O4xmIaVwSbG/3jm6TrOEryWFa+BtXKMZlbgJijqLd9s0FdI89xGAm1zKW2K0+wS+fnL3l0xFOuM6JTemwK423C8TKqcxLWt7NEsraRnPEz96dREvzPub+TWf27wJfbnLD2c1DnyrE2FSCbvgs4DlTDKXgPhK0s4WvIoYjFhV4dhSLq7mgSh8MsBPBOlwNP7vTpTfFRUj9V5g30bGvIoTDlxCs50JuFHojblcjaJF9HDwRfKoXNQkEcy90L/E9Due0h2hWOohvhU4BjlQ+cih7RS1iGEbm42rycz5CjrgYxhsc+7R5LbnU3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcBGeDd2j0jj78Xp+OB0NHhIndoWK+3aa4HxTPLZUE4=;
 b=FgdVDVho3QjyQdmCVBsn+mCt3Lbaz0XOjkWfBR8LQqd04rYwrk2VN6fboESnhDb5rfDrmBEHnqpsqy4+bgv+cG0N07zIv/Ps78t43diJ2X8EjNJmypOhpnWuAAMnTiHF44x/sowzRfhVKjlJpQqVIavVZOG7PSqz0wUIU/Ikt74v2yvuxPajEHcCCbNe9zDiz1vOJwVIfHMCV/Z1XzABViqX+lKk5QFsc3yfgG1xF6fJ1Ivm4ey48+wTsDmc20gN2J2bshps+x8Z6C6TjIBQ6r6I9HEUGmtPghn0yUjySX7JV7a1ohxj+jXWEBkuQrmTq3CUR/6BWH/gApzfElMnWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB6039.namprd11.prod.outlook.com (2603:10b6:8:76::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.21; Sat, 11 Feb 2023 01:53:38 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%5]) with mapi id 15.20.6086.020; Sat, 11 Feb 2023
 01:53:38 +0000
Date: Fri, 10 Feb 2023 17:53:36 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Brice Goglin <Brice.Goglin@inria.fr>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>
CC: "Verma, Vishal L" <vishal.l.verma@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"gregory.price@memverge.com" <gregory.price@memverge.com>,
	"dave@stgolabs.net" <dave@stgolabs.net>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH ndctl v2 0/7] cxl: add support for listing and creating
 volatile regions
Message-ID: <63e6f52057bc_36c729483@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
 <e885b2a7-0405-153c-a578-b863a4e00977@inria.fr>
 <a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.com>
 <34a03b27-923c-7bb0-d77a-b0fddc535160@inria.fr>
 <20230210124307.00003be0@Huawei.com>
 <7e2605a8-cd49-4d6f-9f62-07ff6edd50d8@inria.fr>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7e2605a8-cd49-4d6f-9f62-07ff6edd50d8@inria.fr>
X-ClientProxiedBy: BY3PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: c24a2d51-ee24-4949-6d50-08db0bd2cb0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CY6e2jO00CRmyMNnEKXuPKUqnL8VnP2AWEVVSbY1WzxYifT5YaOzJSk68jIgMpRNyqGduJMF8CylNKxGHnqPLcTasNCPlwuKEJdUtLpKvyNy/+od6sttKcAa+WnqGHQ2g82FvNG86e97h2L7Kic77aaiHPz546DQlOoe5qkZzg9gw9aKXji0dVutpRSjcI+eCUtdIhjhk3216DtLFOk65cvhO/RDIF+6YaL8D3eicTGFDE+9MAUlvdnPDo/HVUWOe6G5jJc/CVlXwmUzbH0B2qzmEnwhOjmFeL1T9BwEwrXGHxDFc3BnuRfosCg7J+ib2yYXcPW6Hf8yPbNjomukm3u9xiukiMw7idORB6eUIAMpLsuXhbG5w/aMBZRosp3hnVSt001muAqKOICJKBxaEYKEVyQh016YyYCFXFoXGe4i2AWqwSGXIV2ry3j/hD+E1ggPP5eBtxRd/wikLGC3zWucORKdd4C2LHZQfJM9zHyNv6LlDI8jILKMhRvZiFhqckHACDLvkqtGnUrLG/DO6DhLyrOQMiCqe3sc/H6CbNu90FyKeSxOmgfHAuh3t/jQKPenoW3y5528MmWcqF9wY3rTsEtQ84iJtXdSQAoP+WJDzV5+USEheOIF680F0O5a5ZwJaG82gLj+4IdaOxPxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199018)(86362001)(4326008)(9686003)(82960400001)(38100700002)(186003)(66946007)(8676002)(66556008)(6512007)(6506007)(8936002)(66476007)(5660300002)(41300700001)(478600001)(6486002)(54906003)(83380400001)(110136005)(316002)(26005)(2906002)(107886003)(66899018);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?76KGCFzi7J/y4yjp1vNYsTQ524+8PDgo/AiPuENrvq8y7laBQnQAreldMYfT?=
 =?us-ascii?Q?2AurmoWR6RMkLoPWmxLaoZdt/y5g+E8ibxYB5N8Evfl+xJ4QD4FE//0fX/S+?=
 =?us-ascii?Q?GFEdzx5O3HKOZe1IBwPzC2TCKVtN5GfJ2OLo2sOQkFtvoJJndAj20qoQr4wJ?=
 =?us-ascii?Q?HLOiLDtOqejTmBhMt31HRKZEzFr4W8dsQYIa0cGkgDfQ+Bc74238WPk/pzM6?=
 =?us-ascii?Q?wAEEHAgvy9KG0xe9GMjbITA6z8Ry5TOuU7Z9ibMOZjto3R7ks4GT54kR1tqG?=
 =?us-ascii?Q?h9lLnlXVGWKXaSiUfzQI7gT9eI++Dp2QIfxqVp6CxgtbgrRnjjE34Dvo4Tqb?=
 =?us-ascii?Q?s+GFsKwiMey+2p+7W/gfQMDYxHj0EtXTuydmTSuPTQ7dzYC9mgO5y+tF3FNT?=
 =?us-ascii?Q?8vwv77Otnfk+SF9IBxMSpwUJwcXMPTa99nXaJYw85K4I0AUgBps7zU4bN3YY?=
 =?us-ascii?Q?XSlGVUjaSHWepR9bKQxyYOrR5yk9viBA0+jP25UWqOmz/Bnkrqa3AyWJTpIV?=
 =?us-ascii?Q?2N15zPo7fVgAF7OfJZZtQRa9qSpOJN2UzBO14NCOCJBrKftF1lkgnLFzt+Zu?=
 =?us-ascii?Q?3+jerOhQI28XygStwNJh0Vdhct0/p1V/Ho1c0yl6VP9uLCqFBftBabm5/jED?=
 =?us-ascii?Q?DvVR/XivvhlZdqmHlwHZrmJfTSbLPd7ZOwGP/7vmOs58s9pcmtHKUo1tRrkA?=
 =?us-ascii?Q?TSRyehitGofNddpuf8aHLgxCgxOHmnaHKSsU1sCMZgUiHf7qSiDhnLP40jSH?=
 =?us-ascii?Q?Uh6pFFRNyyVSpbID0ixpFrWUqPf7gWUGkxyCkVazl9gU7/kQgKtZjuA9YyFS?=
 =?us-ascii?Q?HVllUyPVUPesCMbtrgkeYp7Yl7UafHK8VmBuVIZmqNS50EKheFJL/BaXGK1+?=
 =?us-ascii?Q?ouWBsWXZoCYHwaBEFeXIvFSgi2n58PF/Ue05Wbkr1VgOUyfaJ4o+dom7kQCj?=
 =?us-ascii?Q?UX3vl+u93RKNNG/sZbHuXX9pDvGItTZXfTANpK5QRXKNz4ojZPwYfqdzAQNy?=
 =?us-ascii?Q?K2sMsS1ChVcaE/Q3/+vFR0RbwNl5uMsG/2SWc01w2fzemaFxdP4cqYzjEae1?=
 =?us-ascii?Q?+6/bGdjXMDwooOdMtb/vED+lU2NUxLF6rxz4pgd4mWtXh1G2uRWz7YuyR6K5?=
 =?us-ascii?Q?G1sOzw+ASPvoqwZ/advNdPrrEnzDb2OSGueJXAiJn0Hk7w4kCKw4dqHIAw8I?=
 =?us-ascii?Q?yTmtnoHKS2LDCuakplpkX0mcoE0RrkwG0ayJqSgkBPiy0/Uu46u0nZjApSYC?=
 =?us-ascii?Q?1/z7t9+bSXFxoxaBiIJR+C294MJ6KkSBZP+rO4P00+R4PguixBxm1mh95vX9?=
 =?us-ascii?Q?CRMX4wGy+psvzyH9yJ7v2dXplVvbwbL4tqs58bnr0AB9g1T2vkyAC+HdUY3S?=
 =?us-ascii?Q?l0wdQqttSK4jjdFOfmYsCZ3/PPStcMkD/d2Efa7Aej2KUVGBxZg5/l8m7MHW?=
 =?us-ascii?Q?Ufg67kMwtAeinPQf3tGd03txSJTVE1kbkfhinThozuFiiDzRVVTe+K1nHRE4?=
 =?us-ascii?Q?ipiaS7aQOPKKYfOXDh233jEtRdgzsi+YiLJQSIfcSQgfVZMOP3gTJPJbm/hU?=
 =?us-ascii?Q?kakGbOraLTCTwqqy9O8D7XJ/D1IOEmv90rNxVblCqYxVDMhrWy05HJ4ww4Tl?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c24a2d51-ee24-4949-6d50-08db0bd2cb0a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 01:53:38.2271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0WDcPbJ6bHpU6jitTFHp3ibBgGT2e/LKi0WurGALMaknFdzP/5z1PVYKL9Hl1WLfLrO8fxENZwxrXXzIQua4XwJ/ZQoZNxtFP+AMLPuX1mM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6039
X-OriginatorOrg: intel.com

Brice Goglin wrote:
[..]
> >> By the way, once configured in system ram, my CXL ram is merged into an
> >> existing "normal" NUMA node. How do I tell Qemu that a CXL region should
> >> be part of a new NUMA node? I assume that's what's going to happen on
> >> real hardware?
> > We don't yet have kernel code to deal with assigning a new NUMA node.
> > Was on the todo list in last sync call I think.
> 
> 
> Good to known, thanks again.

In fact, there is no plan to support "new" NUMA node creation. A node
can only be onlined / populated from set of static nodes defined by
platform-firmware. The set of static nodes is defined by the union of
all the proximity domain numbers in the SRAT as well as a node per
CFMWS / QTG id. See:

    fd49f99c1809 ACPI: NUMA: Add a node and memblk for each CFMWS not in SRAT

...for the CXL node enumeration scheme.

Once you have a node per CFMWS then it is up to CDAT and the QTG DSM to
group devices by window. This scheme attempts to be as simple as
possible, but no simpler. If more granularity is necessary in practice,
that would be a good discussion to have soonish.. LSF/MM comes to mind.
