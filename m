Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E11026FD93
	for <nvdimm@lists.linux.dev>; Wed, 25 Mar 2026 01:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774403538; cv=fail; b=jbP+fhkaMCoYd/BN0NeSvTEtdHcF37Z2CtXygxy4kgwoJPH6hEeBPDMdGyFRkkQkgFqOZYewxEPP8OOQihsZd6hppW4WgRwg/kDucOLX+AoXqu8C9SxhkVSjEZM47znIcJdXsNAxvXx471Weafr+N4N/q/aNdNWv58IzFpVKenE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774403538; c=relaxed/simple;
	bh=TM1/ltSeMRcY5SmQQCunxUqr9wLUUBlkOT2Kj57Nefc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KKox2GR3RqFvPFtjlE0+qUYkds5j0fD4bHbgYUHJGGm8F19vC7BGBTPRtfctUnrSUT02kCjvPH8aLxHYxU0bpEYamxM3XsDZP0fbDZUleyuLNkrz2PIciGKDmdQJkqVf3+Aj4B8A0wvHL519eh1l+wQkqARE12vL91lQTV6UO8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i7A/GeoP; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i7A/GeoP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774403535; x=1805939535;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TM1/ltSeMRcY5SmQQCunxUqr9wLUUBlkOT2Kj57Nefc=;
  b=i7A/GeoPS6GdbGtH/WfVoO9h2cGSPA/1pzIstpkm0aQQZTbnScHVJYeE
   IfYr+84rt8zDwcF3gHexrbiQyFT3hp6R1umIbazI5tqQ/loGcREMTvu+1
   +9HonwxUlMEDKrkDCrJr6E7Y7TmhSEsp4hbzwCHmzR6cL4TzQMed0SeHY
   wH/Z2nDvFx4FkVJDlCXy52BMbTS7oi35mRXWUTt+JAspMo0x0cqkZtHVz
   nHk996Xp46REr8oSq7u2mUibtvr4qCZpBYUnTgEcD1eIp2UqqXNegu+oq
   SUUAY0GaOqxFl/3x0C7+Afridv7sEYFExn/eF9stprEQBuTurFLMtQNTM
   A==;
X-CSE-ConnectionGUID: LsZFBiGBSdaw13md2/GV9g==
X-CSE-MsgGUID: cd+waApORDqT1Wne7GUcHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="75320771"
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="75320771"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 18:52:14 -0700
X-CSE-ConnectionGUID: ntGExVjpQSi16+np/Y9KEQ==
X-CSE-MsgGUID: jQBcsWGiQvGVcHdwSQXI1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="223587839"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 18:52:14 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 18:52:12 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 24 Mar 2026 18:52:12 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.64) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 18:52:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eh3IVuaMJjGdg2bm3C8Q4c1ZO0egRWvMTEVBfDr8KktL0a8ZZwmc2S/YZm//zdEJBLJ2ZiVMyJizfVCsh/kG2ojhxB4CB5z5INJBjjfqG77Pw97zIQD20biI76Bhl8ruk90HfFWRHarz75yVautInB8kg5niklNdSge8vVKr7CsEXEVwdEnVxQOajI1kBptZP1fyUhcAjqQGje1ijvo10M5UuzIAqi7CxlzTtHoY4iL9NxEpBuqB8yQN0EvZxBolNGugGi5v1rGxyma24x59HiIo5VpWavLrAAP0eb5QMuPnPkcNQdRCkKr/rbGvtIKt3gwEUK+6dsYDTaAUPJAUNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bl1h2B+PqgyQ+Ba5v6Nx30JpCg1CGdlnkEHNp70m7sk=;
 b=kg1NI7NQbpHCXohlNK80zKkgU09rzV7TMF2GvN5BRUBiCmv44SMbwya0e1nUi9iaXJfOcR3b8EElczdb4U14sNyixNBCg+cdn+CH7QhoXrj/XQRxcMQqWsqOpe5CP//SMClXemxTJKiqX5vEGLddwgXYORteGr7QvO97c4LgSJuo5UO8SK/3thkhBD41dGQ6iiMozAzIpngm3xvsEjrXUNWsEuksvb7jRSXlucgYnqlZcnmI932Lccn91L4dROZRNyB+xAxJ6dXIDPgI9YO1LuMfwm3YTQaD3lj+LrrTTbbzTqTJ2z+fOMzPbAsY4hwZyFwpj9uI+XpZ4W1mKpgyVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB7001.namprd11.prod.outlook.com (2603:10b6:510:208::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.23; Wed, 25 Mar
 2026 01:52:10 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Wed, 25 Mar 2026
 01:52:10 +0000
Date: Tue, 24 Mar 2026 18:51:55 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Yazen Ghannam <yazen.ghannam@amd.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Matthew
 Wilcox" <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek
	<pavel@kernel.org>, Li Ming <ming.li@zohomail.com>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nathan Fontenot
	<nathan.fontenot@amd.com>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, "Tomasz
 Wolski" <tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v6 3/9] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
Message-ID: <acM_u9aYMtKUXGH3@aschofie-mobl2.lan>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-4-Smita.KoralahalliChannabasappa@amd.com>
 <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
 <absY10LzUqb3vK7A@aschofie-mobl2.lan>
 <69c2ea1ea24e1_51621100a1@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <69c2ea1ea24e1_51621100a1@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: SJ0PR13CA0181.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::6) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB7001:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dd47685-cccc-460a-784c-08de8a112085
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003|7053199007;
X-Microsoft-Antispam-Message-Info: v4Ue0jAs4Gvq7MADx43Jfq0MmpCHcfYE5p9zEzKb9xbv3+KehDjA6ZDYAe4Htu4Zzi6sw3TxTMxCuRSHxljOBRc2zOSZGpPMlLDhe6kVfwdh2LLkMw4M1vTu8ybzeogxFR2RwIHa4rYzEV7G6cSR82h2G5hURsIk2jZRLMvwhzvv6X6ozxIVMeHzkTnFm85MHkAEvrfpB5zB6GcdBIeCMqZdbx4NWnFi6847gZUqbXj4filGnEMRj4vkpkdZb2nGKgqAvZe+/e+HZvIrkU2aD4K8CuLJ5QngA1NwUBXLncRByz4WA2DXrKEvcmw1PQRrWpD9FngpO9C3wsYw4e431cS64C1QmGDqnMbQLA5NJCz6UZtMWcbHClDy7hxyzYYsqc6Ae5U59bmX/ohn/Gvnz87+CUs5gq6lH3wNl0f507R6TLQETyi32bs5biuR4bJTi84S+2BIOKYh1iGGqLm8ssLCcvLgtycE8KENIpd4OjfdWDSxgs/hdxtgmNpT95lGah0V89+Q0qP0zTLNqbgFII1vtlzdqIGuGtCYBVoVYShYMiBPJfwh6sAclU8zjFNmtZBHHLysMPapBfFRm3uFtwAWllrA6rxdMwQFY/9MRhLof0E6A5G8CE/ZVzoHjluc5AQMqeLHOSeveqdIlI77iTSel5aVkP9UCRRN5d6DpGSluzaMb9HWhoAxBtrTVKOMbozTaRDgLcqkU59wRUzzYBu285EBANWJzUjil6GWels=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BWAFO5R8odkh6vCsD11b9Z+odDUzIJUwkFZwY8s4xsN2fBx3QtyW2k9XPuEC?=
 =?us-ascii?Q?B71ToT6UiXo+yn8axyXSgq5dXtDsL5yCx0ITReRiWZt322fXhTxPQm3ZOJ3m?=
 =?us-ascii?Q?0mWObOK2+P7N4MlHTrkLGY8bdYCBtJpLBW12bQ8/2TSb+IvwtxhdSXK0R290?=
 =?us-ascii?Q?yOu9mAmFr1uyKpTVVrTjvOcEcWjctCErx1FYYEJCKSRXQfD7R34yHjKi0pzL?=
 =?us-ascii?Q?f75H/N9Oo54S4jI962Fbni3gnH1u9TOreE+S9LqMkDxjYjqR40zOHK4HPJrI?=
 =?us-ascii?Q?ajUZ2U+S9GXiN27DqW/KGvrg/SWZrceDWZwTchHhml+GyLT13JY5QTi5dT2M?=
 =?us-ascii?Q?ip6CLhJXbiL4AsnTr/zh7uvq5hBl68cybg/M24/3YefmLaMtB1S7uN/QSnqS?=
 =?us-ascii?Q?x0eo55pcgdQoWeYb3uDC81TWeZdBCE7zR4652zxrjCL+qlJQ98MF2XaX3Zl2?=
 =?us-ascii?Q?B7B0FcYXiUeoJqm19obiJ6stqLirCM2cQ4KF9Xh5/DIV3SHJltXWRBkTeFIA?=
 =?us-ascii?Q?0mEnHFc1DOFba7jS6hZdh7CYDfmRudq49oabv0rortQK1CEvS9mof7WAVvtf?=
 =?us-ascii?Q?4GBq49oYT7cVn+GBbyla1XaLMcJUaaY0FYu9pxhlR/gnizD5bd+AqgBC4kvl?=
 =?us-ascii?Q?UT6wPfODixHJ+UtU/4yYFm1LccOxhC7EhHf4dYod7hrYBUlsbqxVTS/943mq?=
 =?us-ascii?Q?slP+P+vifzQbmQChQDQTbniTFy/1Hbz97ZyZifxFFJjNxR7RtkBqH9SDJGFA?=
 =?us-ascii?Q?XZHbGR5xHIC7oN2tcMBjsffWrmSjveQ+I0DQ8ohq3jO16QfZvvIkmMY5RQoo?=
 =?us-ascii?Q?AssTTYq61f3pW8GFxou/XCcJV/ImY1IUjr+ml04UXpCtfwqGQIuc7ltpUMwN?=
 =?us-ascii?Q?HitJmzgONAy+keBSI2XGRfDoozhwbDPCHGJ9Mkf/u+bsRNvYZO1bj0nqcuk1?=
 =?us-ascii?Q?j65P2cwLGlWjbic805pIAcgOxNZWbSe4DeKW0qZO9LY2o4BFNDr6PzHmb9vy?=
 =?us-ascii?Q?PcMH97ex0AbrJvwAsAr24eGFJGGBLJL8LWldlNrEOZg30UjrnhfzRIW7ISzD?=
 =?us-ascii?Q?/cQKsxMXFcNIp6JG0nSQ8S46W2y3Omdx3x2hUhUavDB7LM5WtdjuztXuYW3P?=
 =?us-ascii?Q?5G94Uwxq3wEIYjTexiGF1rzDdOEyNPjAgKgZrgW28jo7lyACJaQAVUhfidvX?=
 =?us-ascii?Q?SV4uh6vUJR51PnkFSjWpNOhz3aBtGjCEzgQtudPMvod+t4vVPQ3Mb5RkQ1hR?=
 =?us-ascii?Q?4NfsTkRkmjQG4+k8/CzgzUAFKFVxJHrABfgqGU1pBOkpvs6wL2XjQDaHOv9b?=
 =?us-ascii?Q?+u6sdnQ/L9jSyFYe/xXYD8zvmJdo+CoKXQboS2Jvx+NxGEB2ZkaDZYz+2LVK?=
 =?us-ascii?Q?MLgUZeH6J3366d+15xVTzM+P92/+eHujmnjp75yLXmNb/2NwHMgbEyDfxmzJ?=
 =?us-ascii?Q?15HjSsaqufyQTJ3yP7FhNYHdCPnWRcpbQKvEfXkP/wk3kEuazNQEkJfZfKe9?=
 =?us-ascii?Q?NgSgmTdaaB2ALMWtEuzTh1m6wDcZBM4VrUrg7hAda2BpR76PvIlKd5A+TOrJ?=
 =?us-ascii?Q?7vz8aVFB2rlz8w5OTJ3freOe0u/tAm1NczXDegQVuRMZEhdLohHhq3A9+v4/?=
 =?us-ascii?Q?0VcZ5GUSZ9G9+eZpIsScTZUsLwt8GPacFExaHqSeLRItAhAZL02vUTEchGnF?=
 =?us-ascii?Q?YDANiugOXXrVswSHrwqHPZTnno3R7cvxTrN1GZhPPo+ylPmSiQFoBbgbyn1s?=
 =?us-ascii?Q?a//i9uD3zMGXwAahQZbcx0pzLEdExF8=3D?=
X-Exchange-RoutingPolicyChecked: KnOSpIDwQNBSpzyQenfpru5LKJYH8MN21rr5sfMc8N38Z5UrNAas4JZe3xYxB+xcw5fK4g3wpipFQ5GNH0SQpqkaWBCW36PecM23tVLOEXWflzSEpERHw20fsoeJgDa5r0YBOMadkz4lil3bzpyNZ5xybZdDnfbjEPjBryGnoNPIRw3chv/9tpQgiKM4zs0F+tEIzi1zzvRGGVtevxEvKk17Ekz01dI5x80zn9fND67VLJUL0bTSUWUnEzUZGVMe+4i7NK0W86ne3qJVHZ1bkfOF2PqTt1hbOijw+6z5TWLQXPqV38N/IUb16MlXa82048ftVBHzmsG9F7wLIyqHng==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd47685-cccc-460a-784c-08de8a112085
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 01:52:09.9303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DzaF/hJjqt9dt0R68blo08oCZbXMxiGoqiKl2pRItpmL8h+iMbTLy9JgvIEW1sp8EAgRftQHz3Dzto+sL/70Lqk18ZnZUXEU8vEg9froqQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7001
X-OriginatorOrg: intel.com

On Tue, Mar 24, 2026 at 12:46:38PM -0700, Dan Williams wrote:
> Alison Schofield wrote:

I didn't snip, but lucky for someone, I only appended. Goto EOF.


> > On Wed, Mar 11, 2026 at 02:37:46PM -0700, Dan Williams wrote:
> > > Smita Koralahalli wrote:
> > > > __cxl_decoder_detach() currently resets decoder programming whenever a
> > > > region is detached if cxl_config_state is beyond CXL_CONFIG_ACTIVE. For
> > > > autodiscovered regions, this can incorrectly tear down decoder state
> > > > that may be relied upon by other consumers or by subsequent ownership
> > > > decisions.
> > > > 
> > > > Skip cxl_region_decode_reset() during detach when CXL_REGION_F_AUTO is
> > > > set.
> > > > 
> > > > Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> > > > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > > > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > > > Reviewed-by: Alejandro Lucero <alucerop@amd.com>
> > > > ---
> > > >  drivers/cxl/core/region.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> > > > index ae899f68551f..45ee598daf95 100644
> > > > --- a/drivers/cxl/core/region.c
> > > > +++ b/drivers/cxl/core/region.c
> > > > @@ -2178,7 +2178,9 @@ __cxl_decoder_detach(struct cxl_region *cxlr,
> > > >  		cxled->part = -1;
> > > >  
> > > >  	if (p->state > CXL_CONFIG_ACTIVE) {
> > > > -		cxl_region_decode_reset(cxlr, p->interleave_ways);
> > > > +		if (!test_bit(CXL_REGION_F_AUTO, &cxlr->flags))
> > > > +			cxl_region_decode_reset(cxlr, p->interleave_ways);
> > > > +
> > > >  		p->state = CXL_CONFIG_ACTIVE;
> > > 
> > 
> > Hi Dan,
> > 
> > > tl;dr: I do not think we need this, I do think we need to clarify to
> > > users what enable/disable and/or hot remove violence is handled and not
> > > handled by the CXL core.
> > 
> > I'm chiming in here because although this patch is no longer needed for
> > this series, it has become a dependency for the Type 2 series.
> 
> Like I replied to Alejandro it is not a dependency for the type-2 series
> [1]. It *is* a fix for the issue reported by PJ, but it can go in
> independent of the base type-2 work as a standalone capability.
> 
> [1]: http://lore.kernel.org/69b8b9181bafd_452b100cb@dwillia2-mobl4.notmuch
> 
> > So this
> > follow-up focuses on the hot-remove, endpoint-detach case where
> > preserving decoders across detach is still needed for later recovery.
> > 
> > Some inline responses to you, and then a diff is appended for a
> > direction check.
> > 
> > > So this looks deceptively simple, but I think it is incomplete or at
> > > least adds to the current confusion. A couple points to consider:
> > > 
> > > 1/ There is no corresponding clear_bit(CXL_REGION_F_AUTO, ...) anywhere in
> > > the driver. Yes, admin can still force cxl_region_decode_reset() via
> > > commit_store() path, but admin can not force
> > > cxl_region_teardown_targets() in the __cxl_decoder_detach() path. I do
> > > not like that this causes us to end up with 2 separate considerations
> > > for when __cxl_decoder_detach() skips cleanup actions
> > > (cxl_region_teardown_targets() and cxl_region_decode_reset()). See
> > > below, I think the cxl_region_teardown_targets() check is probably
> > > bogus.
> > 
> > Rather than repurposing CXL_REGION_F_AUTO, this splits decode-reset policy
> > from AUTO. A new region-scoped CXL_REGION_F_PRESERVE_DECODE flag is introduced
> > and cleared on explicit decommit in commit_store(). AUTO remains origin/assembly
> > state.
> 
> Just like the decoder LOCK bit the preservation setting is a decoder
> property, not a region property. Region auto-assembly is then just an
> automatic way to set that decoder policy.
> 
> So, no, I would not expect a new region flag for this policy.
> 
> > This does still leave two cleanup decisions:
> > 1) decode reset (now keyed off PRESERVE_DECODE)
> > 2) target teardown (still using existing AUTO behavior)
> > 
> > No change to cxl_region_teardown_targets() in this step.
> 
> Turns out that cxl_region_teardown_targets() never needed to consider
> the CXL_F_REGION_AUTO flag.
> 
> > > At a minimum I think commit_store() should clear CXL_REGION_F_AUTO on
> > > decommit such that cleaning up decoders and targets later proceeds as
> > > expected.
> > 
> > This point is addressed by clearing CXL_REGION_F_PRESERVE_DECODE instead.
> > Explicit decommit is treated as destructive and disables decode preservation
> > before unbind/reset.
> > 
> > > 
> > > 2/ The hard part about CXL region cleanup is that it needs to be prepared
> > > for:
> > > 
> > >  a/ user manually removes the region via sysfs
> > > 
> > >  b/ user manually disables cxl_port, cxl_mem, or cxl_acpi causing the
> > >     endpoint port to be removed
> > > 
> > >  c/ user physically removes the memdev causing the endpoint port to be
> > >     removed (CXL core can not tell the difference with 2b/ it just sees
> > >     cxl_mem_driver::remove() operation invocation)
> > > 
> > >  d/ setup action fails and region setup is unwound
> > 
> > Agreed. This change targets 2b, 2c.
> > 
> > >  
> > > The cxl_region_decode_reset() is in __cxl_decoder_detach() because of
> > > 2b/ and 2c/. No other chance to cleanup the decode topology once the
> > > endpoint decoders are on their way out of the system.
> > 
> > Agreed. The reset remains. Proposed change only makes it conditional on
> > explicit region policy rather than AUTO.
> > 
> > > 
> > > In this case though the patch was generated back when we were committed
> > > to cleaning up failed to assemble regions, a new 2d/ case, right?
> > > However, in that case the decoder is not leaving the system. The
> > > questions that arrive from that analysis are:
> > > 
> > > * Is this patch still needed now that there is no auto-cleanup?
> > 
> > Not for this Soft Reserved series, but yes for Type2 hotplug.
> 
> Type-2 hotplug is not the issue, it is boot-time configuration
> preservation over device reset which is a different challenge.
> 
> > > * If this patch is still needed is it better to skip
> > >   cxl_region_decode_reset() based on the 'enum cxl_detach_mode' rather
> > >   than the CXL_REGION_F_AUTO flag? I.e. skip reset in the 2d/ case, or
> > >   some other new general flag that says "please preserve hardware
> > >   configuration".
> > 
> > I looked at using and expanding the cxl_detach_mode enum and rejected as
> > not the right scope. The current detach mode is attached to an individual
> > detach operation, whereas preserve vs reset decision applies to the region
> > decode topology as a whole. If we expand detach mode for this region
> > wide policy, then may risk inconsistent handling across endpoint of the
> > same region. Just seemed wrong place. I could be missing another reason
> > why you looked at it.
> 
> Regions are an emergent property from decoder settings. Decoder settings
> come from firmware, user actions, and with the type-2 series driver
> actions. Firmware, user and driver actions are per-decoder especially
> because the behavior needed here is similar to the decoder LOCK bit.
> 
> Region assembly can set a default decoder policy, but the management of
> that decoder policy need not go through the region.
> 
> Either way, settling this question can be post type-2 base series event,
> not a lead-in dependency.
> 
> [..]
> > > It is helpful that violence has been the default so far. So it allows to
> > > introduce a decoder shutdown policy toggle where CXL_REGION_F_AUTO flags
> > > decoders as "preserve" by default. Region decommit clears that flag,
> > > and/or userspace can toggle that per endpoint decoder flag to determine
> > > what happens when decoders leave the system. That probably also wants
> > > some lockdown interaction such that root can not force unplug memory by
> > > unbinding a driver.
> > 
> > As a step in the direction you suggest, AND  aiming to address Type2
> > need, here is what I'd like a direction check on:
> > 
> > Start separating decode-reset policy rom CXL_REGION_F_AUTO:
> > - keep CXL_REGION_F_AUTO as origin / assembly semantics
> > - introduce CXL_REGION_F_PRESERVE_DECODE as a region-scoped policy
> 
> Not yet convinced about this.
> 
> > - initialize that policy from auto-assembly
> > - clear it on explicit decommit in commit_store()
> 
> My expectation is still clear it on decoder configuration change, add an
> attribute to toggle it independent of changing the decoder
> configuration.
> 
> > - use it to gate cxl_region_decode_reset() in __cxl_decoder_detach()
> 
> cxl_region_decode_reset() just automates asking each decoder to carry
> out reset if the decoder policy allows.
> 
> > The decode-reset decision is factored through a small helper,
> > cxl_region_preserve_decode(), so the policy can be extended independent
> > of the detach mechanics. Maybe overkill in this simple case, but I
> > wanted to acknowledge the 'policy' direction.
> 
> Appreciate you pulling this together. I want to land type-2 with the
> existing expectation that unload is always destructive then circle back
> to address this additional detail because it is more than just decoder
> policy that needs to be managed. The type-2 driver may need help finding
> its platform firmware configured address range if a device reset
> destroyed the decoder settings.

I did go first for decoder policy, but switched to region thinking
that this has to be managed at region level because region decode topology
is programmed as a unit so mixed preserve/reset policy across decoders
partitipating in a single active region seems scary.

I can switch to a decoder policy where region auto assembly still inits
a uniform preserve policy across participating programmed decoders and
teardown paths would clear the policy.

The other angle was future userspace access. It seems user intent would
likely be at region scope, with the kernel applying the policy across
the decoders that make up the region. So, sort of a control surface
that is region oriented, but implementation that lives on decoders.

I'll let the dust settle and see if there is anything I can pick up.


