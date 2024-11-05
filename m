Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA862212F07
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 19:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730836418; cv=fail; b=F1DmHaG32sH2pmTWCo54UgqA/ZeEpdW2xEd1sGtj1KX240AVHWH1MwmMPYE23OVO588Oemd8BsbuW3spV1IolrDPEqAgYsbhFfthpZTJkuDouPSLuMebrMxbg3DvTMHPNcdGp/pK+gW73PK3HFBEtVgvQk/2vZh2IsHWEsGJcG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730836418; c=relaxed/simple;
	bh=b8VVYk5sVOmIoiiENgCUJTcgpRnHnpOcwfMFDUy/EMY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=blTwokhxs0SwDGHhwPRN5vN2pBKkTOJ0X2uFY+Im+AsC+XJXw2/jVzn2efZSP8aGXVZvJA0eSsRbl4pDrnIQD3durlgfzWB1z+PPy1EEsbE75HTeB37PU2MVHXM9kySCtcsCrI6u4tRrZoCv46waZgbTuGTCHKPnto4fLfpMDOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SUDzZGvX; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SUDzZGvX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730836416; x=1762372416;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=b8VVYk5sVOmIoiiENgCUJTcgpRnHnpOcwfMFDUy/EMY=;
  b=SUDzZGvX4UV6I5yFeQtZS2aP1pfXXu3a9aKSOQYk5ZOJ66GGul0ggV6N
   tgt2eMmNRcyFpNFDaCj8vKBeOyMYfqTR8a9hBA42LIWRpixpWtKOCVx0A
   ReFpmmCKNBMWcWQDJhKjfKUUrnwV1Zq2Qw4qQDqduO4yyB+FCiirmMhca
   zhmEGbWtm54Hpp+AxrPUAsH+juj1t2oC+TFflUkOWh4T5q+x7bwMbjEMg
   bjiq1EbKiBKeCA1ffMJ6XBjYvcsAauG6boKk+kiyJFnWU+F1H98P+YJ7B
   /lvopeLJpMklVKM4znAYHuZUPnSf5o/7OQNL/WmGDVBnk9hU/NWxYq8ZH
   Q==;
X-CSE-ConnectionGUID: W4fj0fR4SkCvPRc3Iv7XSw==
X-CSE-MsgGUID: 2YPwVZiHQAm6KMkqelgg2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="41984356"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="41984356"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 11:53:34 -0800
X-CSE-ConnectionGUID: XblB8QZEQqCZ4cgRVhCv9Q==
X-CSE-MsgGUID: +cVKfeLzSvaezTIHDfRhWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="114931993"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 11:53:34 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 11:53:33 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 11:53:33 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 11:53:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlqxwB6AkDGRCnMtkL0OBB/CXGTFcnjFi1PKkylcnQLjalrSdnHaZpy9GTrKGiD9uB8jx682iH0lHbyESXJop5WgfE+CgkSAzfhuNR5TvVLpp3atBfaZDbdGHi8DozwcWgim5gN3lKqipTXoBW9KGhaVTvl7d3Y+yJLQ0V8JcSl/nmWp9NEIE3/B5pXKEq+7FwJiopjMS3MdytdB16z7M9/unw871dcyVBrVa2ZWHY7GFTlOWQ7lHPHQtPBn23+0XctX748O9tx6H1IUz4O3VYljdEhOjIWxi4Vu0/2LDNTFUs+pcoPq0EsfoKpKDQ/us8yynKo+2dKIz2v2uf3ECA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlqIHaGAzv3OQAvVSZUmg8TvN9ECGQpwbH1e2KPtP30=;
 b=q2P/cI/G5X1iAeRiOtQoMHjw7ioYBRO24JXq8ZxQ94Y2iluM+KkgvyiDQCq56TrZikuf6h1Hk0qX9aWh5ru3m8JYzPjCxMzwdX0+7McIHLpvq+W5ySgBBCt+CR9Vr2iA3Idn8N1XD75UW3Wn/RrfmgmU5/oGl01XMXwDXE4L1Jt/l4aqul28DnJPRWvLOlZ2FYNac60/gjpcHZ4BaVgNV6y0L5SpO6FmkftojQh5Xe2WADHoYJhQ9+9xSkNYJldV2tz/cOEm5qu5pGaMgcMbAmHEUR+EzxB3aQDiWzKOpcXbHJ5jxPjIaOr8cFCtQn6Vl4vtGWQUrzE9zBsOE0NvGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB6191.namprd11.prod.outlook.com (2603:10b6:8:ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Tue, 5 Nov
 2024 19:53:30 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 19:53:30 +0000
Date: Tue, 5 Nov 2024 13:53:26 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Alison Schofield" <alison.schofield@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>, Navneet Singh
	<navneet.singh@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 6/6] ndctl/cxl/test: Add Dynamic Capacity tests
Message-ID: <672a77b678c04_166959294b2@iweiny-mobl.notmuch>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-6-be057b479eeb@intel.com>
 <8f7c852a-8ab3-4c7c-862f-215493ae2a87@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8f7c852a-8ab3-4c7c-862f-215493ae2a87@intel.com>
X-ClientProxiedBy: MW3PR06CA0014.namprd06.prod.outlook.com
 (2603:10b6:303:2a::19) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB6191:EE_
X-MS-Office365-Filtering-Correlation-Id: ab6a8862-eb03-4245-da34-08dcfdd3859d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eufiIDOtD4KPYUtBoHD9eIt2xaH2lBspf3LTHRnfNTL5sSSW7fmFKL8c5IO8?=
 =?us-ascii?Q?ksoeVFwZ4ZK++b8qlocF5DJJjyXurrMaX1SaejrqBncEe6lMFDJuu1P3zuCZ?=
 =?us-ascii?Q?Y16Zxm+z3QNx4iTe2k8r51XqNcT7YGbE9w3sl6FQO1ZaEeqcQewA1i9ETvyk?=
 =?us-ascii?Q?oSgDK94g/D9Kp594X1ZYNO3g26A6uKlRbniTfL2qKVxnGpA1ljUMPhl76ZPG?=
 =?us-ascii?Q?AWfwtsXfmfORVXv+JNliLt09lZ0juMYHDNqsh9HHRNkodvhIa1ZVRedmzqmr?=
 =?us-ascii?Q?8uYMEPjJwiIXxlBMgLUKUqejfHVr5zpUUanXJQTUtg4iU6Gtq316sbd33uy6?=
 =?us-ascii?Q?R4ls52z3ETQLGlh4f4PN1HsQRaOVPfSKPRCAplLxh9YGo2H5NYs7GjSJ58Lb?=
 =?us-ascii?Q?U/3hb7srHulJcCcpk9lEGTnw2FViJ60SP2HVH7lftrsQJ00wdGuEqt+OpYIh?=
 =?us-ascii?Q?Sz0INpcl/RowFCIYep2WcpB+3w+ixM2UOLwp9aoHr03Ki8k2/hxmMqtfqByZ?=
 =?us-ascii?Q?fISnI83Eq5WXNlegWJTcUDgTxtSvihjg1gORkVvhwpAMwNNtkdfmiPIA1IdA?=
 =?us-ascii?Q?eFkaCzUfzjH55iLKDeYSQhazArNTdeEkuW1lxAsQVF/1wP4RDDbMoaoQ5QJo?=
 =?us-ascii?Q?fxNqx2JQXxLkE8rXtfW9rXs4gFoEyk67saR5lK/yhsJmeeYvAUPKTYPYkmgW?=
 =?us-ascii?Q?/aivQ0EFZJovuRdqlvZLlEiaCo365TBaJh5gTkZbBpj8P+v2HdyPubaFuNe+?=
 =?us-ascii?Q?GwR39Cy/1Vh1QOOdrAImt8eY++4iG2Bm0wfZe55shcfL5kfLF4iBzVQDyzrn?=
 =?us-ascii?Q?hJ+6QMJSVjDo8IsMilJ29DNaurcxqmHKrksBeEfnCwVKa1tfb8aveLDT3JNa?=
 =?us-ascii?Q?Ktvi5yI7VeX0dZ+TxUUhARmg39X7RW3sxb279dFxKmWBJ82HuLJ/yT/WVK2f?=
 =?us-ascii?Q?5315ftvye7vzQb8Fp+glpEQlA9rbAjrPdf4yAJzazQt0GQ26N617PHTOXSfD?=
 =?us-ascii?Q?I0PyYDn5W7jRdZWzTOo2KD5tUBdOfDtzTwulGwCIeM4AnmhPOgFFl9dRrgC7?=
 =?us-ascii?Q?rIjCPt9rUyxBk8SrlCbfEgTydrmsz9hbDlZFTTiASIb/QIed6H7lqQZk5jk+?=
 =?us-ascii?Q?XyfdXHsuYF8PA8oFa6jhtoalhwIS4R189EvPpiLKX8JxPnveZHpDQbC2TlOD?=
 =?us-ascii?Q?lVjeqVSkSbrZUHZ4xuKKWo2F6tAFodR1UPAqXLtpjTqyTbqqo06tPq1j2GLb?=
 =?us-ascii?Q?0g0104vd+jbQRnZBF4wvP8r5pSOyrqcjcDWdYfyZqFRbrME07vRaQO68V8k3?=
 =?us-ascii?Q?NqYhZjs+ZiiM36sSe/A5qKDL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?geSgOeAyVV1Ew4QHu8ySAWr31ysgO0xolPnWw5dSlJ5vO0SU4nz48RVgNQEu?=
 =?us-ascii?Q?Ndj/lRpfmx7xB6MzyWXQ/aeCMWEkTmnJxanZRYubutUL2VS/TYY1aj3wYC5U?=
 =?us-ascii?Q?mWYafjLU0eVh+LLnuG7cwZ9dlM1INIM8uLgFs7MCGik3O3VRNGh5eZw+vVME?=
 =?us-ascii?Q?Q8VKBq/psP9/x6Fh5Wb5ic3T+V6mbHC9nPKat0gPAjnCoyjj63dOE7vP1CMg?=
 =?us-ascii?Q?RxnYn+Y5UWuahoThJ2YfW7dtWDuhi+8PihU1QV6UxdttmfKPN0j4zgCgeN6F?=
 =?us-ascii?Q?IxS5TlG5oLm8SDQjS8tUB1aaXd0Gk7DPVPaiPov2N+eE6pyB+LtODhwSOiAQ?=
 =?us-ascii?Q?IiCyMLuh/IYYPsrN22PZ6w5J1ihWQZT5rmvZUpXbP6Hw5e6zseetDhQWvTLi?=
 =?us-ascii?Q?+ES3DYk+ZMawQUC2hE7ILCKEv9Fo4KYC9CLqnoPJoL21f91353SE6sa7SgNM?=
 =?us-ascii?Q?WJ79qY369e6hP9bNxIAdLCXlMsGHOgl1/chi9Hw5glQoQxYMvkVvvPgopPFH?=
 =?us-ascii?Q?YybgRJMXtHG0C0hKr3dujOau7lSbXxTeHUWurRrJt8U6J/a0Hm1issaGCmp9?=
 =?us-ascii?Q?xuwvPx7bjOAqAgV9Z56p/hPM8SZf2x5x5sXp8hKzgrnzl1poxP8eCXQLGOyo?=
 =?us-ascii?Q?XWSguduQi2+uGsyZCiDD5LgOasEGIPrJKtkMGAyc65D/Ew01q20SeFaQFzza?=
 =?us-ascii?Q?nm4ijC3qz7zcMyQSHH/3UwNPzjda9LsO6SKm53D42TKXBMI3Qib7liFatnVr?=
 =?us-ascii?Q?r0+lMKyVtEp7YumYYyJyyvvndz2RMHvJCxKZJrDjW0wBAMyBNKHaj9bViYP3?=
 =?us-ascii?Q?/hiJc68deRs0erEVvwsjNjxdI4FpuTz65qlHEhYf7hgxNDubPOZ9FtD0S2Hw?=
 =?us-ascii?Q?/tuvevw7zdSMTEYSWQBEwTs9VQHIeWynWIwjsWD35sB5l8EFIQ5LxgzhskjM?=
 =?us-ascii?Q?QuLVO0jafcVJ7cupSssSG2egpeL+gXjs3H6LuH8R+PdtS7UYKLFkKz4CJXqO?=
 =?us-ascii?Q?pmwntCGvapS4hV7ehVdVUuesicaKntU56FX53g8SatazzBD8H9A029DiWZfl?=
 =?us-ascii?Q?y0oX9Uo4G6ePWgKs1YJCr+FZCz1HeXq1Aspw0SAmv2WcmoMFHi/SEgCgYMgG?=
 =?us-ascii?Q?VmfgwugQemPKwvMYYpVpxcYDewwt9ZJs4zhsb1umt8dVryzbceIXID4iu2cU?=
 =?us-ascii?Q?AiFhVAtSMLGAKQjAvXF6qPEMRrMCjtcYXRCFHyTIO6FyPOqMXtUq8AKT5zln?=
 =?us-ascii?Q?uL2prZYDSaQoSjkQG8YPVwk7mw0foawBlfwsA/XspuYVxMY7TGUn/eI8yPax?=
 =?us-ascii?Q?qaT4bajDwqL731RwkI6ZIHd6u/0cROCL4FuVfndeJqIUMFpI37OG6EAGbReG?=
 =?us-ascii?Q?RzTbOFcLLkDG7XQfnJoc5768wWlH4sT5BERZBB10ha1mn6Q3SSLf0IIBY5cB?=
 =?us-ascii?Q?0jveSVCg2rsnmrRvK2HKW/xT59DCNpUoFs0bIB1eTLFrssKx6HmVGStTOII2?=
 =?us-ascii?Q?c/qcoJJYMl/3btHBITkioRN01+qElRgXGNVYlVWW0HsERTJLUTPLzoARqiVD?=
 =?us-ascii?Q?yAKxahWpDzgyB3G85a59D8TBLZBBNupp+WvKzula?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6a8862-eb03-4245-da34-08dcfdd3859d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 19:53:30.4847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNDoqTj20roLEXnA79YSRYAd6uP0yhUxGE5ddkOIQRejQEfz8DMHCAO8mjtMXdGQFEIZNe2/j18CnPNezYBaxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6191
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> 
> 
> On 11/4/24 7:10 PM, Ira Weiny wrote:
> > cxl_test provides a good way to ensure quick smoke and regression
> > testing.  The complexity of DCD and the new sparse DAX regions required
> > to use them benefits greatly with a series of smoke tests.
> > 
> > The only part of the kernel stack which must be bypassed is the actual
> > irq of DCD events.  However, the event processing itself can be tested
> > via cxl_test calling directly the event processing function directly.
> > 
> > In this way the rest of the stack; management of sparse regions, the
> > extent device lifetimes, and the dax device operations can be tested.
> > 
> > Add Dynamic Capacity Device tests for kernels which have DCD support in
> > cxl_test.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> Would things look cleaner if the multiple test cases are organized into individual bash functions?

Perhaps.  But many of the initial tests borrow state from the previous
test.  For example the cxl-test pre-existing extents are used to test
extent removal.  Later on those dependencies lessoned.

Let me see if I can clean up the testing now that things are settling out.

Ira

> 
> > ---
> >  test/cxl-dcd.sh  | 656 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  test/meson.build |   2 +
> >  2 files changed, 658 insertions(+)
> > 
> > diff --git a/test/cxl-dcd.sh b/test/cxl-dcd.sh
> > new file mode 100644
> > index 0000000000000000000000000000000000000000..f5248fce4f3899acdf646ace4f0eb531ea2286d3
> > --- /dev/null
> > +++ b/test/cxl-dcd.sh
> > @@ -0,0 +1,656 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2024 Intel Corporation. All rights reserved.
> > +
> > +. "$(dirname "$0")/common"
> > +
> > +rc=77
> > +set -ex
> > +
> > +trap 'err $LINENO' ERR
> > +
> > +check_prereq "jq"
> > +
> > +modprobe -r cxl_test
> > +modprobe cxl_test
> > +rc=1
> > +
> > +dev_path="/sys/bus/platform/devices"
> > +cxl_path="/sys/bus/cxl/devices"
> > +
> > +# a test extent tag
> > +test_tag=dc-test-tag
> > +
> > +#
> > +# The test devices have 2G of non DC capacity.  A single DC reagion of 1G is
> > +# added beyond that.
> > +#
> > +# The testing centers around 3 extents.  Two are pre-existing on test load
> > +# called pre-existing.  The other is created within this script alone called
> > +# base.
> > +
> > +#
> > +# | 2G non- |      DC region (1G)                                   |
> > +# |  DC cap |                                                       |
> > +# |  ...    |-------------------------------------------------------|
> > +# |         |--------|       |----------|      |----------|         |
> > +# |         | (base) |       | (pre)-   |      | (pre2)-  |         |
> > +# |         |        |       | existing |      | existing |         |
> > +
> > +dcsize=""
> > +
> > +base_dpa=0x80000000
> > +
> > +# base extent at dpa 2G - 64M long
> > +base_ext_offset=0x0
> > +base_ext_dpa=$(($base_dpa + $base_ext_offset))
> > +base_ext_length=0x4000000
> > +
> > +# pre existing extent base + 128M, 64M length
> > +# 0x00000088000000-0x0000008bffffff
> > +pre_ext_offset=0x8000000
> > +pre_ext_dpa=$(($base_dpa + $pre_ext_offset))
> > +pre_ext_length=0x4000000
> > +
> > +# pre2 existing extent base + 256M, 64M length
> > +# 0x00000090000000-0x00000093ffffff
> > +pre2_ext_offset=0x10000000
> > +pre2_ext_dpa=$(($base_dpa + $pre2_ext_offset))
> > +pre2_ext_length=0x4000000
> > +
> > +mem=""
> > +bus=""
> > +device=""
> > +decoder=""
> > +
> > +create_dcd_region()
> > +{
> > +	mem="$1"
> > +	decoder="$2"
> > +	reg_size_string=""
> > +	if [ "$3" != "" ]; then
> > +		reg_size_string="-s $3"
> > +	fi
> > +	dcd_partition="dc0"
> > +	if [ "$4" != "" ]; then
> > +		dcd_partition="$4"
> > +	fi
> > +
> > +	# create region
> > +	rc=$($CXL create-region -t ${dcd_partition} -d "$decoder" -m "$mem" ${reg_size_string} | jq -r ".region")
> > +
> > +	if [[ ! $rc ]]; then
> > +		echo "create-region failed for $decoder / $mem"
> > +		err "$LINENO"
> > +	fi
> > +
> > +	echo ${rc}
> > +}
> > +
> > +check_region()
> > +{
> > +	search=$1
> > +	region_size=$2
> > +
> > +	result=$($CXL list -r "$search" | jq -r ".[].region")
> > +	if [ "$result" != "$search" ]; then
> > +		echo "check region failed to find $search"
> > +		err "$LINENO"
> > +	fi
> > +
> > +	result=$($CXL list -r "$search" | jq -r ".[].size")
> > +	if [ "$result" != "$region_size" ]; then
> > +		echo "check region failed invalid size $result != $region_size"
> > +		err "$LINENO"
> > +	fi
> > +}
> > +
> > +check_not_region()
> > +{
> > +	search=$1
> > +
> > +	result=$($CXL list -r "$search" | jq -r ".[].region")
> > +	if [ "$result" == "$search" ]; then
> > +		echo "check not region failed; $search found"
> > +		err "$LINENO"
> > +	fi
> > +}
> > +
> > +destroy_region()
> > +{
> > +	local region=$1
> > +	$CXL disable-region $region
> > +	$CXL destroy-region $region
> > +}
> > +
> > +inject_extent()
> > +{
> > +	device="$1"
> > +	dpa="$2"
> > +	length="$3"
> > +	tag="$4"
> > +
> > +	more="0"
> > +	if [ "$5" != "" ]; then
> > +		more="1"
> > +	fi
> > +
> > +	echo ${dpa}:${length}:${tag}:${more} > "${dev_path}/${device}/dc_inject_extent"
> > +}
> > +
> > +remove_extent()
> > +{
> > +	device="$1"
> > +	dpa="$2"
> > +	length="$3"
> > +
> > +	echo ${dpa}:${length} > "${dev_path}/${device}/dc_del_extent"
> > +}
> > +
> > +create_dax_dev()
> > +{
> > +	reg="$1"
> > +
> > +	dax_dev=$($DAXCTL create-device -r $reg | jq -er '.[].chardev')
> > +
> > +	echo ${dax_dev}
> > +}
> > +
> > +fail_create_dax_dev()
> > +{
> > +	reg="$1"
> > +
> > +	set +e
> > +	result=$($DAXCTL create-device -r $reg)
> > +	set -e
> > +	if [ "$result" == "0" ]; then
> > +		echo "FAIL device created"
> > +		err "$LINENO"
> > +	fi
> > +}
> > +
> > +shrink_dax_dev()
> > +{
> > +	dev="$1"
> > +	new_size="$2"
> > +
> > +	$DAXCTL disable-device $dev
> > +	$DAXCTL reconfigure-device $dev -s $new_size
> > +	$DAXCTL enable-device $dev
> > +}
> > +
> > +destroy_dax_dev()
> > +{
> > +	dev="$1"
> > +
> > +	$DAXCTL disable-device $dev
> > +	$DAXCTL destroy-device $dev
> > +}
> > +
> > +check_dax_dev()
> > +{
> > +	search="$1"
> > +	size="$2"
> > +
> > +	result=$($DAXCTL list -d $search | jq -er '.[].chardev')
> > +	if [ "$result" != "$search" ]; then
> > +		echo "check dax device failed to find $search"
> > +		err "$LINENO"
> > +	fi
> > +	result=$($DAXCTL list -d $search | jq -er '.[].size')
> > +	if [ "$result" -ne "$size" ]; then
> > +		echo "check dax device failed incorrect size $result; exp $size"
> > +		err "$LINENO"
> > +	fi
> > +}
> > +
> > +# check that the dax device is not there.
> > +check_not_dax_dev()
> > +{
> > +	reg="$1"
> > +	search="$2"
> > +	result=$($DAXCTL list -r $reg -D | jq -er '.[].chardev')
> > +	if [ "$result" == "$search" ]; then
> > +		echo "FAIL found $search"
> > +		err "$LINENO"
> > +	fi
> > +}
> > +
> > +check_extent()
> > +{
> > +	region=$1
> > +	offset=$(($2))
> > +	length=$(($3))
> > +
> > +	result=$($CXL list -r "$region" -N | jq -r ".[].extents[] | select(.offset == ${offset}) | .length")
> > +	if [[ $result != $length ]]; then
> > +		echo "FAIL region $1 could not find extent @ $offset ($length)"
> > +		err "$LINENO"
> > +	fi
> > +}
> > +
> > +check_extent_cnt()
> > +{
> > +	region=$1
> > +	count=$(($2))
> > +
> > +	result=$($CXL list -r $region -N | jq -r '.[].extents[].offset' | wc -l)
> > +	if [[ $result != $count ]]; then
> > +		echo "FAIL region $1: found wrong number of extents $result; expect $count"
> > +		err "$LINENO"
> > +	fi
> > +}
> > +
> > +readarray -t memdevs < <("$CXL" list -b cxl_test -Mi | jq -r '.[].memdev')
> > +
> > +for mem in ${memdevs[@]}; do
> > +	dcsize=$($CXL list -m $mem | jq -r '.[].dc0_size')
> > +	if [ "$dcsize" == "null" ]; then
> > +		continue
> > +	fi
> > +	decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
> > +		  jq -r ".[] |
> > +		  select(.dc0_capable == true) |
> > +		  select(.nr_targets == 1) |
> > +		  select(.max_available_extent >= ${dcsize}) |
> > +		  .decoder")
> > +	if [[ $decoder ]]; then
> > +		bus=`"$CXL" list -b cxl_test -m ${mem} | jq -r '.[].bus'`
> > +		device=$($CXL list -m $mem | jq -r '.[].host')
> > +		break
> > +	fi
> > +done
> > +
> > +echo "TEST: DCD test device bus:${bus} decoder:${decoder} mem:${mem} device:${device} size:${dcsize}"
> > +
> > +if [ "$decoder" == "" ] || [ "$device" == "" ] || [ "$dcsize" == "" ]; then
> > +	echo "No mem device/decoder found with DCD support"
> > +	exit 77
> > +fi
> > +
> > +echo ""
> > +echo "Test: pre-existing extent"
> > +echo ""
> > +region=$(create_dcd_region ${mem} ${decoder})
> > +check_region ${region} ${dcsize}
> > +# should contain pre-created extents
> > +check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
> > +check_extent ${region} ${pre2_ext_offset} ${pre2_ext_length}
> > +
> > +
> > +# | 2G non- |      DC region                                        |
> > +# |  DC cap |                                                       |
> > +# |  ...    |-------------------------------------------------------|
> > +# |         |                   |----------|         |----------|   |
> > +# |         |                   | (pre)-   |         | (pre2)-  |   |
> > +# |         |                   | existing |         | existing |   |
> > +
> > +# Remove the pre-created test extent out from under dax device
> > +# stack should hold ref until dax device deleted
> > +echo ""
> > +echo "Test: Remove extent from under DAX dev"
> > +echo ""
> > +dax_dev=$(create_dax_dev ${region})
> > +check_extent_cnt ${region} 2
> > +remove_extent ${device} $pre_ext_dpa $pre_ext_length
> > +length="$(($pre_ext_length + $pre2_ext_length))"
> > +check_dax_dev ${dax_dev} $length
> > +check_extent_cnt ${region} 2
> > +destroy_dax_dev ${dax_dev}
> > +check_not_dax_dev ${region} ${dax_dev}
> > +
> > +# In-use extents are not released.  Remove after use.
> > +check_extent_cnt ${region} 2
> > +remove_extent ${device} $pre_ext_dpa $pre_ext_length
> > +remove_extent ${device} $pre2_ext_dpa $pre2_ext_length
> > +check_extent_cnt ${region} 0
> > +
> > +echo ""
> > +echo "Test: Create dax device spanning 2 extents"
> > +echo ""
> > +inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
> > +check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
> > +inject_extent ${device} $base_ext_dpa $base_ext_length ""
> > +check_extent ${region} ${base_ext_offset} ${base_ext_length}
> > +
> > +# | 2G non- |      DC region                                        |
> > +# |  DC cap |                                                       |
> > +# |  ...    |-------------------------------------------------------|
> > +# |         |--------|          |----------|                        |
> > +# |         | (base) |          | (pre)-   |                        |
> > +# |         |        |          | existing |                        |
> > +
> > +check_extent_cnt ${region} 2
> > +dax_dev=$(create_dax_dev ${region})
> > +
> > +echo ""
> > +echo "Test: dev dax is spanning sparse extents"
> > +echo ""
> > +ext_sum_length="$(($base_ext_length + $pre_ext_length))"
> > +check_dax_dev ${dax_dev} $ext_sum_length
> > +
> > +
> > +echo ""
> > +echo "Test: Remove extents under sparse dax device"
> > +echo ""
> > +remove_extent ${device} $base_ext_dpa $base_ext_length
> > +check_extent_cnt ${region} 2
> > +remove_extent ${device} $pre_ext_dpa $pre_ext_length
> > +check_extent_cnt ${region} 2
> > +destroy_dax_dev ${dax_dev}
> > +check_not_dax_dev ${region} ${dax_dev}
> > +
> > +# In-use extents are not released.  Remove after use.
> > +check_extent_cnt ${region} 2
> > +remove_extent ${device} $base_ext_dpa $base_ext_length
> > +remove_extent ${device} $pre_ext_dpa $pre_ext_length
> > +check_extent_cnt ${region} 0
> > +
> > +echo ""
> > +echo "Test: inject without/with tag"
> > +echo ""
> > +inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
> > +check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
> > +inject_extent ${device} $base_ext_dpa $base_ext_length ""
> > +check_extent ${region} ${base_ext_offset} ${base_ext_length}
> > +remove_extent ${device} $base_ext_dpa $base_ext_length
> > +remove_extent ${device} $pre_ext_dpa $pre_ext_length
> > +check_extent_cnt ${region} 0
> > +
> > +
> > +echo ""
> > +echo "Test: partial extent remove"
> > +echo ""
> > +inject_extent ${device} $base_ext_dpa $base_ext_length ""
> > +dax_dev=$(create_dax_dev ${region})
> > +
> > +# | 2G non- |      DC region                                        |
> > +# |  DC cap |                                                       |
> > +# |  ...    |-------------------------------------------------------|
> > +# |         |--------|                                              |
> > +# |         | (base) |                                              |
> > +# |         |    |---|                                              |
> > +#                  Partial
> > +
> > +partial_ext_dpa="$(($base_ext_dpa + ($base_ext_length / 2)))"
> > +partial_ext_length="$(($base_ext_length / 2))"
> > +echo "Removing Partial : $partial_ext_dpa $partial_ext_length"
> > +remove_extent ${device} $partial_ext_dpa $partial_ext_length
> > +check_extent_cnt ${region} 1
> > +destroy_dax_dev ${dax_dev}
> > +check_not_dax_dev ${region} ${dax_dev}
> > +
> > +# In-use extents are not released.  Remove after use.
> > +check_extent_cnt ${region} 1
> > +remove_extent ${device} $partial_ext_dpa $partial_ext_length
> > +check_extent_cnt ${region} 0
> > +
> > +# Test multiple extent remove
> > +echo ""
> > +echo "Test: multiple extent remove with single extent remove command"
> > +echo ""
> > +inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
> > +inject_extent ${device} $base_ext_dpa $base_ext_length ""
> > +check_extent_cnt ${region} 2
> > +dax_dev=$(create_dax_dev ${region})
> > +
> > +# | 2G non- |      DC region                                        |
> > +# |  DC cap |                                                       |
> > +# |  ...    |-------------------------------------------------------|
> > +# |         |--------|          |-------------------|               |
> > +# |         | (base) |          | (pre)-existing    |               |
> > +#                |------------------|
> > +#                  Partial
> > +
> > +partial_ext_dpa="$(($base_ext_dpa + ($base_ext_length / 2)))"
> > +partial_ext_length="$(($pre_ext_dpa - $base_ext_dpa))"
> > +echo "Removing multiple in span : $partial_ext_dpa $partial_ext_length"
> > +remove_extent ${device} $partial_ext_dpa $partial_ext_length
> > +check_extent_cnt ${region} 2
> > +destroy_dax_dev ${dax_dev}
> > +check_not_dax_dev ${region} ${dax_dev}
> > +
> > +
> > +echo ""
> > +echo "Test: Destroy region without extent removal"
> > +echo ""
> > +
> > +# In-use extents are not released.
> > +check_extent_cnt ${region} 2
> > +destroy_region ${region}
> > +check_not_region ${region}
> > +
> > +
> > +echo ""
> > +echo "Test: Destroy region with extents and dax devices"
> > +echo ""
> > +region=$(create_dcd_region ${mem} ${decoder})
> > +check_region ${region} ${dcsize}
> > +check_extent_cnt ${region} 0
> > +inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
> > +
> > +# | 2G non- |      DC region                                        |
> > +# |  DC cap |                                                       |
> > +# |  ...    |-------------------------------------------------------|
> > +# |         |                   |----------|                        |
> > +# |         |                   | (pre)-   |                        |
> > +# |         |                   | existing |                        |
> > +
> > +check_extent_cnt ${region} 1
> > +dax_dev=$(create_dax_dev ${region})
> > +destroy_region ${region}
> > +check_not_region ${region}
> > +
> > +echo ""
> > +echo "Test: Fail sparse dax dev creation without space"
> > +echo ""
> > +region=$(create_dcd_region ${mem} ${decoder})
> > +check_region ${region} ${dcsize}
> > +inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
> > +
> > +# | 2G non- |      DC region                                        |
> > +# |  DC cap |                                                       |
> > +# |  ...    |-------------------------------------------------------|
> > +# |         |                   |-------------------|               |
> > +# |         |                   | (pre)-existing    |               |
> > +
> > +check_extent_cnt ${region} 1
> > +
> > +# |         |                   | dax0.1            |               |
> > +
> > +dax_dev=$(create_dax_dev ${region})
> > +check_dax_dev ${dax_dev} $pre_ext_length
> > +fail_create_dax_dev ${region}
> > +
> > +echo ""
> > +echo "Test: Resize sparse dax device"
> > +echo ""
> > +
> > +# Shrink
> > +# |         |                   | dax0.1  |                         |
> > +resize_ext_length=$(($pre_ext_length / 2))
> > +shrink_dax_dev ${dax_dev} $resize_ext_length
> > +check_dax_dev ${dax_dev} $resize_ext_length
> > +
> > +# Fill
> > +# |         |                   | dax0.1  | dax0.2  |               |
> > +dax_dev=$(create_dax_dev ${region})
> > +check_dax_dev ${dax_dev} $resize_ext_length
> > +destroy_region ${region}
> > +check_not_region ${region}
> > +
> > +
> > +# 2 extent
> > +# create dax dev
> > +# resize into 1st extent
> > +# create dev on rest of 1st and all of second
> > +# Ensure both devices are correct
> > +
> > +echo ""
> > +echo "Test: Resize sparse dax device across extents"
> > +echo ""
> > +region=$(create_dcd_region ${mem} ${decoder})
> > +check_region ${region} ${dcsize}
> > +inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
> > +inject_extent ${device} $base_ext_dpa $base_ext_length ""
> > +
> > +# | 2G non- |      DC region                                        |
> > +# |  DC cap |                                                       |
> > +# |  ...    |-------------------------------------------------------|
> > +# |         |--------|          |-------------------|               |
> > +# |         | (base) |          | (pre)-existing    |               |
> > +
> > +check_extent_cnt ${region} 2
> > +dax_dev=$(create_dax_dev ${region})
> > +ext_sum_length="$(($base_ext_length + $pre_ext_length))"
> > +
> > +# |         | dax0.1 |          |  dax0.1           |               |
> > +
> > +check_dax_dev ${dax_dev} $ext_sum_length
> > +resize_ext_length=33554432 # 32MB
> > +
> > +# |         | D1 |                                                  |
> > +
> > +shrink_dax_dev ${dax_dev} $resize_ext_length
> > +check_dax_dev ${dax_dev} $resize_ext_length
> > +
> > +# |         | D1 | D2|          | dax0.2            |               |
> > +
> > +dax_dev=$(create_dax_dev ${region})
> > +remainder_length=$((ext_sum_length - $resize_ext_length))
> > +check_dax_dev ${dax_dev} $remainder_length
> > +
> > +# |         | D1 | D2|          | dax0.2 |                          |
> > +
> > +remainder_length=$((remainder_length / 2))
> > +shrink_dax_dev ${dax_dev} $remainder_length
> > +check_dax_dev ${dax_dev} $remainder_length
> > +
> > +# |         | D1 | D2|          | dax0.2 |  dax0.3  |               |
> > +
> > +dax_dev=$(create_dax_dev ${region})
> > +check_dax_dev ${dax_dev} $remainder_length
> > +destroy_region ${region}
> > +check_not_region ${region}
> > +
> > +
> > +echo ""
> > +echo "Test: Rejecting overlapping extents"
> > +echo ""
> > +
> > +region=$(create_dcd_region ${mem} ${decoder})
> > +check_region ${region} ${dcsize}
> > +inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
> > +
> > +# | 2G non- |      DC region                                        |
> > +# |  DC cap |                                                       |
> > +# |  ...    |-------------------------------------------------------|
> > +# |         |                   |-------------------|               |
> > +# |         |                   | (pre)-existing    |               |
> > +
> > +check_extent_cnt ${region} 1
> > +
> > +# Attempt overlapping extent
> > +#
> > +# |         |          |-----------------|                          |
> > +# |         |          | overlapping     |                          |
> > +
> > +partial_ext_dpa="$(($base_ext_dpa + ($pre_ext_dpa / 2)))"
> > +partial_ext_length=$pre_ext_length
> > +inject_extent ${device} $partial_ext_dpa $partial_ext_length ""
> > +
> > +# Should only see the original ext
> > +check_extent_cnt ${region} 1
> > +destroy_region ${region}
> > +check_not_region ${region}
> > +
> > +
> > +echo ""
> > +echo "Test: create 2 regions in the same DC partition"
> > +echo ""
> > +region_size=$(($dcsize / 2))
> > +region=$(create_dcd_region ${mem} ${decoder} ${region_size} dc1)
> > +check_region ${region} ${region_size}
> > +
> > +region_two=$(create_dcd_region ${mem} ${decoder} ${region_size} dc1)
> > +check_region ${region_two} ${region_size}
> > +
> > +destroy_region ${region_two}
> > +check_not_region ${region_two}
> > +destroy_region ${region}
> > +check_not_region ${region}
> > +
> > +
> > +echo ""
> > +echo "Test: More bit"
> > +echo ""
> > +region=$(create_dcd_region ${mem} ${decoder})
> > +check_region ${region} ${dcsize}
> > +inject_extent ${device} $pre_ext_dpa $pre_ext_length "" 1
> > +# More bit should hold off surfacing extent until the more bit is 0
> > +check_extent_cnt ${region} 0
> > +inject_extent ${device} $base_ext_dpa $base_ext_length ""
> > +check_extent_cnt ${region} 2
> > +destroy_region ${region}
> > +check_not_region ${region}
> > +
> > +
> > +# Create a new region for driver tests
> > +region=$(create_dcd_region ${mem} ${decoder})
> > +
> > +echo ""
> > +echo "Test: driver remove tear down"
> > +echo ""
> > +check_region ${region} ${dcsize}
> > +inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
> > +check_extent ${region} ${pre_ext_offset} ${pre_ext_length}
> > +dax_dev=$(create_dax_dev ${region})
> > +# remove driver releases extents
> > +modprobe -r dax_cxl
> > +check_extent_cnt ${region} 0
> > +
> > +# leave region up, driver removed.
> > +echo ""
> > +echo "Test: no driver inject ok"
> > +echo ""
> > +check_region ${region} ${dcsize}
> > +inject_extent ${device} $pre_ext_dpa $pre_ext_length ""
> > +check_extent_cnt ${region} 1
> > +modprobe dax_cxl
> > +check_extent_cnt ${region} 1
> > +
> > +destroy_region ${region}
> > +check_not_region ${region}
> > +
> > +
> > +# Test event reporting
> > +# results expected
> > +num_dcd_events_expected=2
> > +
> > +echo "Test: Prep event trace"
> > +echo "" > /sys/kernel/tracing/trace
> > +echo 1 > /sys/kernel/tracing/events/cxl/enable
> > +echo 1 > /sys/kernel/tracing/tracing_on
> > +
> > +inject_extent ${device} $base_ext_dpa $base_ext_length ""
> > +remove_extent ${device} $base_ext_dpa $base_ext_length
> > +
> > +echo 0 > /sys/kernel/tracing/tracing_on
> > +
> > +echo "Test: Events seen"
> > +trace_out=$(cat /sys/kernel/tracing/trace)
> > +
> > +# Look for DCD events
> > +num_dcd_events=$(grep -c "cxl_dynamic_capacity" <<< "${trace_out}")
> > +echo "     LOG     (Expected) : (Found)"
> > +echo "     DCD events    ($num_dcd_events_expected) : $num_dcd_events"
> > +
> > +if [ "$num_dcd_events" -ne $num_dcd_events_expected ]; then
> > +	err "$LINENO"
> > +fi
> > +
> > +modprobe -r cxl_test
> > +
> > +check_dmesg "$LINENO"
> > +
> > +exit 0
> > diff --git a/test/meson.build b/test/meson.build
> > index d871e28e17ce512cd1e7b43f3ec081729fe5e03a..1cfcb60d16e05272893ae1c67820aa8614281505 100644
> > --- a/test/meson.build
> > +++ b/test/meson.build
> > @@ -161,6 +161,7 @@ cxl_sanitize = find_program('cxl-sanitize.sh')
> >  cxl_destroy_region = find_program('cxl-destroy-region.sh')
> >  cxl_qos_class = find_program('cxl-qos-class.sh')
> >  cxl_poison = find_program('cxl-poison.sh')
> > +cxl_dcd = find_program('cxl-dcd.sh')
> >  
> >  tests = [
> >    [ 'libndctl',               libndctl,		  'ndctl' ],
> > @@ -194,6 +195,7 @@ tests = [
> >    [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
> >    [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
> >    [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
> > +  [ 'cxl-dcd.sh',             cxl_dcd,            'cxl'   ],
> >  ]
> >  
> >  if get_option('destructive').enabled()
> > 
> 


