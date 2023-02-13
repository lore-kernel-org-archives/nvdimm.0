Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BDDBA31
	for <nvdimm@lists.linux.dev>; Mon, 13 Feb 2023 23:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676330824; x=1707866824;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6VdHHph5p6EJskOPMhxNc3KqUZhHqLGx6qQHqVg9gCc=;
  b=OtMDpSoyt8U2qQ2hg2Kj6p3vLmQpbMvDey4uPQT2d63BToWqpoeOBk6f
   vAQijLsiYHeq3oEXosDaMlqFPqC6zOGHibtgtdxe9M3mZv/lwp8E2jwxK
   8gYfDHPOp1c2JLxhnygi0SN8zdpk4AeFhu7ZfWAhC1R9I/cEhizYyV2k+
   Evq9CJWtDcwsE2WRDOnyc/x/fYs0LHYV55EYXz+BxEB8lFgNwu5ftBjSY
   HhCYeJPbmHdvKL/e6j3+sLVlAyH9tyTMdyaQ9HieFj0dpOOoiAnyCiOr7
   g/BQ7XPA7cyIyQo4hcvBYIxRb3eccqzJVdx0Z4RmjvUrB6O/AtiXknoC6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="393426263"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="393426263"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 15:27:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="997862694"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="997862694"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 13 Feb 2023 15:27:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 15:27:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 15:27:03 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 15:27:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3fXXP7YPeK92+s/D45SbOM2guZtOS8m2aq6/kuqVcfPq18xpGw0KDhLVylFmxeJH55pYp/FNBz9kcvIgLnD5tupCua1tEKxeJDK1h1jiF//IQgL0RvI6/h/rdWu1d5JGdx/7+yRaZPcJt7jYLXVhw+AxTtO4fPHD+G+RGxHtbnA0v6jhuAcxLTd46CohQQjOJX33XhsnJXlEqFF1ADPN0k7uWDj887VE0MpFA4u9hy/Hjitya9kkNijmE/NOTpP3mSzPzGygTSMpeJ1OaL8eDqMn0cPE1jJ1UhijdR0tlhC1ytLsSwXoJudT797G7BpwBbsYEq8Qb96J1UfEaHN3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6VdHHph5p6EJskOPMhxNc3KqUZhHqLGx6qQHqVg9gCc=;
 b=lQogjZIy3n9xllD1Eoy+xdCTxuVUtFMlBh9UV+7IItooI44S5zF7QvGDRS3rijvKUA2Ld8h2T4c69Iu53w9Oj9yYp12FVGm+m7+ZhfO7hrWU51F7LIhStCVF6GAauYjOroIDZsvYC+nXv5YLkVLEl2D4wY0mi+Xy9sEyiVsd6h3HLoC1M8i457E9v4ybwDS8JEtEQDUTLTbQfI4Gqu9pKjtsYkoc8QiS+itv86tFJNMnr8j7kk/XF16bF1ovzkG6ahKTOTbiq7Rh+fCtCJTo3tCGyYdImT1NDN2rpNJu81wufYrUq1CkBRe9Dx9lkHZSIU85KjfV7IaNV6xIU6qiIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB6528.namprd11.prod.outlook.com (2603:10b6:8:8f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 23:27:01 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 23:27:01 +0000
Date: Mon, 13 Feb 2023 15:26:58 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Adam Manzanares <a.manzanares@samsung.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: Fan Ni <fan.ni@samsung.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, Adam Manzanares
	<a.manzanares@samsung.com>
Subject: RE: [ndctl PATCH] daxctl: Skip over memory failure node status
Message-ID: <63eac7427d994_27392429460@dwillia2-xfh.jf.intel.com.notmuch>
References: <CGME20230213213916uscas1p2ee91a53c14ec5ddcb31322212af6cdaa@uscas1p2.samsung.com>
 <20230213213853.436788-1-a.manzanares@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230213213853.436788-1-a.manzanares@samsung.com>
X-ClientProxiedBy: SJ0PR03CA0182.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e5cf59b-4339-4d43-9f52-08db0e19ce7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: niaUaTaJoOmjrlSMNOJdvmFwFO592SUuTkwChif9bn4wbfAAysKRi1d88I3dC5RFxZsbasc2rP22T5ryRuu0AHr2tkbzw3V6q7a9cNA0wStThdK7mpzm9ht0uKP/xdQQZ/8H7Qyg571WUnnCETV5frDEb1DEkUz8d9DIbBv5SZeALGVgpN847RHXKJaTTNoA1AE6M40nfA7SZy7dUKYjGenu6kj5R27GdvIJ4nr66hLJtH8imppP8aXTn7ztTETk4krudw238IwTFLZ2YW/gzGsXtpmbVy8K3mz08okHghpJ8OBBXH2AfBJF/h+jH++lF8fidY9rCtMSlE837fsM36s16VsIjahtdHwpGapxxrHn/aMabhJiZMEv7uUTEhoxbrS/W9qxpRGHIelRbaBgHLLqsCWKu/9RBZwL1jjPZQIdaQ61fEcgY7fpHs5OCaI0YgaMu0wEu/pPQopCw2U2fg5bbkIQtZBwAf6avHL1v7I4Xkuc0kYYJBtavvEgXubqlo9PCjwiPOAPRJrrGHmDZy2A7wls2dmqoPX/kF79fvC6k+rkikyUWRqYKYtVA9E94/sQbMucKV2byNXDa2qQZ4kQ42ad6X3t/vQUDAX3GNUgyewfhEbCL/gY5l1Zec1Wm7RdCA/hmj99h68L0BMxnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199018)(316002)(6506007)(110136005)(54906003)(41300700001)(38100700002)(82960400001)(8936002)(2906002)(4744005)(5660300002)(83380400001)(66556008)(66946007)(66476007)(8676002)(4326008)(6666004)(6486002)(478600001)(26005)(86362001)(9686003)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w3KqPLM/SZl/LhallIAGKKgKBQgqqSCoZyRJ5UPnyg0ajSYezjh8rKrNaK5m?=
 =?us-ascii?Q?1UCGS6jg0OxroG2CGiUear6WHAhYpa+j+WKPcxRzgzqxamYkdcyRx41NUKGQ?=
 =?us-ascii?Q?jSEDg7WwZcBCoxqGT3Jyw6D4OWFlqIym0iBSkvUWIVledmNGEOE+e9bGCQ0T?=
 =?us-ascii?Q?oNXnqXXGN/478R7Lus3OHxpwxa0/d+uILyuasc9U9IBJI2R88YLSfxkLejiK?=
 =?us-ascii?Q?vSt84hrX6Y/MF9gTht6wNpw6rjS4uJCZfgsudxUYbthB4LatYlFRALXJU8JG?=
 =?us-ascii?Q?PjIL+jJFlI5RBCZ8FDI8YVqQ4hn47R3/BSfq5hsIkdLuA4KNEVhLkvk+Vhf1?=
 =?us-ascii?Q?itaKl4rU5D8h+76n4AenQs42f1C6NL551deUDEDCjkAUyxUbV5DyTBtUv2CP?=
 =?us-ascii?Q?Ct1cUQRGNBbrEOdzZ43yDmAuLCb83EWtbI0ISEBERNEUQc7XzoWHHdgK0H43?=
 =?us-ascii?Q?M0PTJd476UbNZmfdqn3hlLz8wm9U8LbCY8ref0PZA8unpdksrFYEmxZVSlI+?=
 =?us-ascii?Q?TprRFxuXdlPoJtIgJgtITNZcKW9M85BO1G0m0yFeBOny2mrUCI5LBZv5uylj?=
 =?us-ascii?Q?RDjl54BrqE+lK7BW6UvecByf9DlDNUZ4q0MDa+a1ORz/aQCSpW3JPXlshA4A?=
 =?us-ascii?Q?BU08DwuWjlewVxT5T+Rn5Ih9L3QkyaI/xuEnWt+dLek5tm4wihGFjTb2plNo?=
 =?us-ascii?Q?08tmA9m0Arb9+GlPSaUXR95yO7J5HNCErEKvScR5ApCcmmq9F/lhfa9LiV/K?=
 =?us-ascii?Q?1W4TIqk4VRAEq0dwhX0m53Vv+U2zH266WHQCLobCG5fBLbYrOoA7q/K646/0?=
 =?us-ascii?Q?lpSGIA9JobQu+gbRq5s9xpEDHAxJd81qFPwM+B6wgpiklMM2VtdZig5nhlXV?=
 =?us-ascii?Q?gk7HcTsMr4X13uvL1SvH93KJNVQJ/S2r596mrk5V+c5ZL+emSirCMRUkjoxR?=
 =?us-ascii?Q?FmzGZPm8ZwpANrI+XreJ57UO0h1libybtTRJqB4uiE1CDlXOhWHVWVPrANV2?=
 =?us-ascii?Q?xH1lqrUzWpKrHKZNeoxnUM2YzCgWsem7LIbdSP+ZwZiBVWiZ0BZwcOYcEQRi?=
 =?us-ascii?Q?2YL/DkSgzaCh7GVdNcR5nrVG1aDYmjzxgPt3TXor098nrtYut8TdOpm0564M?=
 =?us-ascii?Q?l5+tsvi6WF8F3q6HADuKZzIXmYGSYNCkaP0YQ7TM9Yb1c0yr/L3E0PEU5gCP?=
 =?us-ascii?Q?ySI3YT1pMXNZB6/nUezNE2MvX3pS123YbRqyvLZ16nZwATy6FN7sanANai4i?=
 =?us-ascii?Q?DTHTGMnboZ/4ySrVYHpAlYY6rB3Tsj+pa3wz3xrl9AICf7PYrqRDUNqicOS9?=
 =?us-ascii?Q?OiWvMKfXyWT63VTFC3HsL91Uh/fIAMD6qw1lppyMyZkE+xKlhe9Bnp8fylmE?=
 =?us-ascii?Q?I1Ptt3fswbcNdWCnwSzCbyYKrqOUrq/0QMw8vMHCicukD6a38ilQnKqfqILd?=
 =?us-ascii?Q?5Ttz80BnTvOOjc8QjF5Uy5jUNC5sQ/k5wR4fOqOF3ez2UOVLqNfkD2XnCQPM?=
 =?us-ascii?Q?UjggBd+WkyMWpHXT6wx+HkhakFI38yRlnx0dGGS1+71uHzJqndkvUvvciIp0?=
 =?us-ascii?Q?BBy4eFZxNYqIoIx6OoQvyCFXpZCiwe/9A46ixhHFKItnoGV+xV3YClk0zqoh?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e5cf59b-4339-4d43-9f52-08db0e19ce7a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 23:27:00.6057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NDqE0JvIXWydCpulu0aV0KA77MMRwGzHshCW5YGBqVWwZ8JW6EhQ6qzkWC99lo//hTDO0wv8tfjvvhUEjZbdarw9OmaszG5vN5F1zk85Ut8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6528
X-OriginatorOrg: intel.com

Adam Manzanares wrote:
> When trying to match a dax device to a memblock physical address
> memblock_in_dev will fail if the the phys_index sysfs file does
> not exist in the memblock. Currently the memory failure directory
> associated with a node is currently interpreted as a memblock.
> Skip over the memory_failure directory within the node directory.

Oh, interesting, I did not know memory_failure() added entries to sysfs.
My grep-fu is failing me though... I only found node_init_cache_dev()
that creates a file named "memory_side_cache" under a node. This fix
will work for that as well, but I am still curious where the memory
failure file originates.
