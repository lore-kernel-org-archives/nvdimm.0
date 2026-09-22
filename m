Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB1951C049
	for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 21:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790111745; cv=fail; b=jUPZguDQkqfE3UOgXotHUEMLD8YHz2Zg/ntnT01k2S6Vyu76nNIcseEQilfdxwmhuEoXBipD5gzWnIQdSr86NR19zh6Rk08KbTsJPb9vBHHErziUatKCyAIr3b3szuznPUTRmJylOXTuBZ+krPY+A183ZI+enpPmfbMox8oPmYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790111745; c=relaxed/simple;
	bh=G7U9JHJBQ0r8fs2kYZDlw1LQUX8TLO7wDJ5A7aF6m/8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bQEgsmsMemJ3ilyfRmJWHoboSgOPtTZDKq8ahbAAQV6YvI0TmuUAkEAwUj1bT8tZfMgBIsrfQgrrn5CdJ0Q0T5AGVk/YB9fY3lUcCideU+f5x1yYEcOmQF15sH20jCn2v9pLfLTEuvl7+bsOwqKDdcv++rDopkUPCkI/nC061oQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m7OYZvtx; arc=fail smtp.client-ip=192.198.163.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m7OYZvtx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790111722; x=1821647722;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=G7U9JHJBQ0r8fs2kYZDlw1LQUX8TLO7wDJ5A7aF6m/8=;
  b=m7OYZvtxzwYfxOu/WMqYxCHmI3uk+nZ3mlvb687fHPkdkKDMZdIzrKGR
   WXfvQMBSl/xAcaedJNBcrESDYusr3whU9qyVHRMHKf0dSD1+zCyyJGACD
   rbmNhPcOkAlwxXGV7n3NtcRnRdE6S5XvO6qjLI2jrG/nf4O9mN+egj4DF
   bMJeK/opX/fqR/Z3LLQccs94EO1AsukENJR1W2pTmbaxX4SBRxc7lDQWZ
   tARWkBPPs45h/gTaIRXWUZiRfYbU97K/Oo3z1J4z/k6gx2PK9OYww/d1j
   agbeRKrFHie3vGGqyeiHc23PzKux1LmCXEdqaDLp06T3aLcCUxxRF+ahg
   Q==;
X-CSE-ConnectionGUID: UQeRlUPLTBmkoQqdjZ/wlA==
X-CSE-MsgGUID: 1QXLuwXTRZeB/UYD8XjHoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="1267586"
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="1267586"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa114.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 14:15:16 -0700
X-CSE-ConnectionGUID: wI/+EXJwT1yUvFxUZEvlHg==
X-CSE-MsgGUID: VLCV0IgPT56otMfZ1anIfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="269810309"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 14:15:17 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 14:15:16 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 22 Sep 2026 14:15:16 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.35)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 14:15:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H1lCC/6NfoFusrc3f27v57LjaoelQteptza3OIECCMIg3Zvv0StCn7GRctUejd0MJsZGQBM0RF3OC+79AyF0jMBi0CpIibzRkgljl4bI/qC0bXqjwVS8VSRUOlq8ZBuZcmAn2Ncz4gr32yJgmLWeZQL4VML0lXxUe8Rioc/MMA/tYYrz+Xiv93ovIF239rM8kZWzaPwFsOtSMcZT6bcm7qAAYxqT29lrXJe6kFHUAaGSwXfSm++7GRzA1NPv0Q6EVbrVrVss5xpyLCR/f0IJh/ptH16a5W2kimwCNwLcB0CFBeNoOuEUTyWrjDVeiR1aDk2hAE7QGXW9eQ/U39NEvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAYsZvXdxoHTfFw5Vl7JlNPZ/q4eFo9X308Y8jf0J5M=;
 b=CyRjeWzFkEbnt0Xgwj7OgHkQsPce2byumxSmM6Pdxyah3PaVLADCMZqH8puI3h7g4vVJXAFJr574+Bo4UB3yghcucnQlKM3k0zslsqL7nIQhUw/YdcmyYfvgnXt9YksrzUWod5ZALLNCgY65XngMpCrddopgAufbEIACBw/ETlO8OrZJ42fXOYaqnEBcgNPFA6szMAY1V8CCNPQUcdhIs97GU8hRFF5yCIkoeQHHjBY5eclAaxndZXxHjJkLhOv5rJdtSm9KpoIOp5lRNUqNtcjPDr5PTGN5xXop/owQrmATI/ckv62dRwEIPyy/raw4y9Xj0QGYo3ZWrGhZGARvRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY8PR11MB7289.namprd11.prod.outlook.com (2603:10b6:930:99::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Tue, 22 Sep
 2026 21:15:12 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 21:15:12 +0000
Date: Tue, 22 Sep 2026 14:15:02 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <benjamin.cheatham@amd.com>
Subject: Re: [ndctl PATCH] cxl/test: Add ELC MCE alias retirement tests
Message-ID: <arLv1oHxpiNCrgnw@aschofie-mobl2.lan>
References: <20260906041844.13891-1-shaikhkamal2012@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260906041844.13891-1-shaikhkamal2012@gmail.com>
X-ClientProxiedBy: CY8PR12CA0022.namprd12.prod.outlook.com
 (2603:10b6:930:4e::17) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY8PR11MB7289:EE_
X-MS-Office365-Filtering-Correlation-Id: 112197c4-3a7a-40d0-c259-08df18ee969f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|56012099006|11063799006|5023799004|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info: J/cgMJOsiQGOt0jSGyNpYDhNQDY90gr8hdAJdmQjyB6th9Vd/ZDTJCNpN4C8ocjOi3GuVhY2izoInUyBMiEmWBwpw8AJ3JOwHM7rll91zBVTaPHZSNOh54thL4JdwpinDMRLEOdblf7cdgA8kgkwzeLAVE2t3g1BCeCtfMah/pZcvHw/eIWMMefQ3UrtUkjEem/zjHC/d+qh4t7bcq6u8+2fc5d2BRKaFyDKLNAr73CgwWpLuIoQBura6lL7+MtqtZqy0LCH2inQsrpKU3SmL27ch4hf2UAgHsDcLh0rgJxNDYXMyboMYSs/QGTNyAHiRb2ZXu3Apk6P+hOn4nxGerFEQuYoM0LOQCcoltzg5edm2bbjcFDvj8ZBKYEVlE5gnpUs90O5VCklifm/Opbu8A10sGm7hGV4ZpaJgLXj6gGGmPMbUSU/QWU0wnF0JMpoJtvaX29fauioFbPzCDFpNmazyPZ8JzBqSTYsGY7PQ+BXrLAlWM1GClvwJ7FIe2ap8jlshv7R0rYF/aco+Z2TY4FGuoeuruQz53m4Oq0u09tNwjH98veaXMeedSaXb2bjPyQb17ZbULw+PtV1bpZIirT/KzrePU9v3PJ8YxDNTCAgtfMduu49SRqqRWQ02Hor8KPZkPPiu55B03l9LwjJYnLXJUSVryp1ZrcKMBpozQA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(5023799004)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZCvpW8u3xNmBpqtYi0oXeh5rkxAynwO0+LRJ3kU1r8BSb3cFnKA3b9kHXMKH?=
 =?us-ascii?Q?fySCG8R+cV2gYSsxP6daRq3R0h5mkeok786P65wFfnbj1BkMpiU1AGkWkFtW?=
 =?us-ascii?Q?kobB8eFzi68OnPe4Y28t/3l4iPnV6SCRsKO7nb76pcHxz1rZKfCb5GPOt84m?=
 =?us-ascii?Q?v5t0t+DIc7aem3obLfdxWwBwHgqJjMu9fz1d0TDTAEdwVypoOQ2wWKMQ+2/z?=
 =?us-ascii?Q?t3qv38G/IT1nwwYSx8dyiIRNWLUdMEriUK/8Lgyxhft6SI3LqB8Lc2JZg7/V?=
 =?us-ascii?Q?RGffKXLLvAPJzUtbbI35ppLWFABDCHsh4JmyDSzpGAweqU8KECr0PqQVxGKk?=
 =?us-ascii?Q?/pckR+6s+mZgoJ8VNfPAooWnfi5gtGs2DQMPrJZDePN17QcSYneMFAIAlAO5?=
 =?us-ascii?Q?ZMviRT9UAsxU27DkzYUzM1M8Hi6gU6bytklZ5O1Q+roCdeOHV1akcscXq9Pj?=
 =?us-ascii?Q?9ajfNF1IzgPF5iQuAcbIcMM7sVoDAal/VsBpgS2O/VjyotKfWTBZ+9R1RY9t?=
 =?us-ascii?Q?C7yAuEUJ+kXx+ywNjBZL4R7jmNgFQVziK+zgwrwqrnyMItZYZCZkn5gaGTKI?=
 =?us-ascii?Q?u5JK3Q0UD2heEsJsM923vDrtEb8Nf6KO5xaVZub6gE6ldRJDg2hgtQ2an8Tb?=
 =?us-ascii?Q?ZUFSQo88NNHmhEJqr3NvD26oEi+a+/EFKf8ccdwHs3yjWpKRtBh6QrqLlNkq?=
 =?us-ascii?Q?oQ0E9k2Y6N+ERqkvBR+8DfHmj3MIhDZCeJTeXJzr9E0XMFsjvEgZ2uevBJXz?=
 =?us-ascii?Q?RT9w3r0otafsfJvA+d2DKYLDfGKpd/Dv982yTgEnFea662ZKiPvNo9ANXjQr?=
 =?us-ascii?Q?6jJBSXwNImUNLvE3ZPwo5HyZ3zlGkS34Pt7tdMyEUteCTCwqrIocyRbzF5Cu?=
 =?us-ascii?Q?rCIK9NRvCb0VU7f4Jsw1KhdpG4H+dkGMMGluIIwEsm4AJohTpxiYQD2138Rv?=
 =?us-ascii?Q?Hd6tdb0Krh53uyswADIg2ZzuGJRwcFNXjsN6cAclAIrA0dyoywmGeJggYTqa?=
 =?us-ascii?Q?SbDw+kG+Aa4C6j48A3M8F7pkDL+7KalduCEPGA2OkTNkYZUgYQU5iPlLWUH4?=
 =?us-ascii?Q?2biEEuMCJzRfOliDBmRBjvIdGIU/OQowHJSDZ1GPBsFRDLzBVQXUhup0GnG+?=
 =?us-ascii?Q?DO3p0fjKtbIgnq+WAuT20uHmpGtmh1+MYZQ/89iknh3kOFn6cdPLd12fmpmX?=
 =?us-ascii?Q?NiIYNgHHmn/KA2WRQWjLc+Clp+Y/F9PdolQhWmgP/0Xv6hT4dVZM58LXEB3F?=
 =?us-ascii?Q?6tIgbMfDThFCTKHJ0KBs84xF0TF7niG5V5K8Oc219yO88a5R1uhOzc1RsPp/?=
 =?us-ascii?Q?B+YjuINQX1UQwJR+ILvYNhzkN1sSwyBrVqqZbZ0wJlUnm1prMI7FEotfcvNf?=
 =?us-ascii?Q?NLmdnONbOG9LnXCSCAaQqccqx5ZZsyACNANBVGyAsvO5Smo+uUqrwdqGTf8r?=
 =?us-ascii?Q?IYOi0WK2OLp+YUIXoljeXFHOJVXAsy58TRVORf/rG/uk0IA5fPwlyfVHO4fR?=
 =?us-ascii?Q?BZoiGdOQ2NFVuY+m61pBL8/osPn/HCtzyCBDzU5m+r++/RPsP4aeRRIzR+w1?=
 =?us-ascii?Q?CtYaM+Uku5TRCVzKPBxujbVEpMCnHGfq6JWg7vN3rLzHwRmuliwr1oY9kpxR?=
 =?us-ascii?Q?44n4N4ZlIgZyUqJS2nrErZEXrr8YQvhToQ+2NiF/kQ5rn/ZeZHK9GEZHSQDA?=
 =?us-ascii?Q?mPFy1EwiCt8HOtiVf6JUtq7VJzHeHbOUKWV3Cn6LZ4dJKvb8lEidWASOIhHO?=
 =?us-ascii?Q?wUN4Uv48ed4ltzC54dE3/MvE+uTWKTM=3D?=
X-Exchange-RoutingPolicyChecked: 3n/snJ2I9jWiI0eE37vXg2ZcDzjdvPrpobol922mnx4uYhxuBRnd3pA/umrcopLjyZtpYnsfv0XTOKfSOlDRkkrJDev/QnnEG+1m2uDk3pFIEwlVl6ThX309IGLS4uYbrbff34d8AuLdQ1XsiV9u/OYojJIlBhFPWFeLs9Mf7VoS/pd01LhtquQqypjTYLnFNiRo9KIUR/pKdFRDq5ZGIhkHYc69o2lxzobp+9NMIPuWFKeiv7Bp3vBYg22mcrpBTTdsgOlZ5xQoFzwNmS5d8Z3QzOZ7zrf5jGE8N7tIsjtFTj3BkdAWyyxs3aGZDWbnv+VHgJYC/19vqIiG4ts9Ag==
X-MS-Exchange-CrossTenant-Network-Message-Id: 112197c4-3a7a-40d0-c259-08df18ee969f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 21:15:12.2146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXPP0Hfzz4y0Q6k7VIgJkX5x0QAoFVulRaSj2mkDsXBZKzZ/CbD3for3H+k3r1St81YtP2ubILp3HpwiR4osdhV/5ll0ub2Bamk9fLsKCbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7289
X-OriginatorOrg: intel.com

On Sun, Sep 06, 2026 at 09:48:44AM +0530, Shaikh Kamaluddin wrote:
> ELC alias retirement depends on the error severity and on whether
> vendor-specific MCE rules consider the reported address usable. Add
> regression coverage for these decisions to cxl-elc.sh.
> 
> Inject MCE records through the mce-inject debugfs interface and verify
> the resulting bank status and alias-offlining messages in dmesg. Test
> corrected and uncorrected errors on Intel, and exercise the poison,
> deferred, and legacy bank-4 cases required by AMD address validation.

Hi Shaikh,

Thanks for taking this on. I ran it both ways: on a pre-fix kernel it
fails on the corrected case, and with 6e7ab3c8107c ("cxl/mce: Avoid
alias page retirement for corrected errors") applied the Intel cases
pass. So it does detect the regression it was written for.

I do have a scope question about the vendor-specific coverage.

The cxl tests in this repo exercise behavior controlled by the cxl_test
mock topology. CPU vendor, MCA bank layout, and SMCA capability aren't
properties cxl_test controls. Should the test matrix depend on them?

Looking at cxl_handle_mce(), I see these decision points:

if (mce_is_correctable(mce))			/* 1 */
	return NOTIFY_DONE;
if (!mce_usable_address(mce))			/* 2 */
	return NOTIFY_DONE;
spa = mce->addr & MCI_ADDR_PHYSADDR;
if (!cxl_resource_contains_addr(p->res, spa))	/* 3 */
	return NOTIFY_DONE;
if (spa >= p->res->start + p->cache_size)	/* 4 */
	spa_alias = spa - p->cache_size;
else
	spa_alias = spa + p->cache_size;
pfn = spa_alias >> PAGE_SHIFT;
if (!pfn_valid(pfn))				/* 5 */
	return NOTIFY_DONE;
...
if (!memory_failure(pfn, 0))			/* 6 */
	set_mce_nospec(pfn);

This patch mostly exercises 1 and 2. Point 2 is where the arch-specific
MCE policy lives. Points 3 through 6 are driven by the cxl_test topology.

Could we keep this test focused on the behavior cxl_test controls and go
deeper on those cases instead? Can we test both alias directions, the
boundary between them, and an SPA outside the ELC region.

That would mean dropping the vendor dispatch, bank discovery, has_bank(),
non_b4_bank, and the AMD matrix from this patch.

I don't think that analysis should be thrown away. It looks like useful
coverage of the arch-specific MCE handling. Could we treat that as separate
follow-on work and discuss the appropriate test mechanism and home with the
x86 MCE maintainers rather than making it part of v2?

More feedback on the cxl test appropriate pieces inline -

> 
> Derive the ELC SPA and its alias from cxl-list output, select offline
> test addresses from lsmem, and discover available MCA banks dynamically.
> Use a distinct SPA for each case and clean up modules loaded by the test.
> 
> Suggested-by: Ben Cheatham <benjamin.cheatham@amd.com>
> Suggested-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> ---
> Testing:
> The test was run under virtme-ng with cxl_test configured for Extended
> Linear Cache operation:
> 
> Intel, GenuineIntel:
> --------------------
> 
> 1. vng -v -r ./arch/x86/boot/bzImage --disable-kvm --qemu-opts='-cpu Skylake-Server-v4,+mce,+mca -m 4G -machine q35,cxl=on -object memory-backend-ram,id=cxl-mem0,size=512M -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.0 -device cxl-rp,port=0,bus=cxl.0,id=root_port0,chassis=0,slot=0 -device cxl-type3,bus=root_port0,volatile-memdev=cxl-mem0,id=cxl-mem-device0 -M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=512M'
> 
> 2 . Go to ndctl-main directoy with this patches 
> 
> env NDCTL="$PWD/build/ndctl/ndctl" 
> DAXCTL="$PWD/build/daxctl/daxctl" 
> CXL="$PWD/build/cxl/cxl" 
> ./test/cxl-elc.sh
> 
> RESULT:
> --------
> 
> PASS Intel corrected: alias no
> PASS Intel uncorrected: alias yes
> CXL ELC MCE validation passed for GenuineIntel: 2 cases
> -----------------------------------------------------------------
> 
> AMD, AuthenticAMD legacy MCA: 
> -----------------------------
> 
> 1. vng -v -r ./arch/x86/boot/bzImage --disable-kvm --qemu-opts='-cpu EPYC-Milan -m 4G -machine q35,cxl=on -object memory-backend-ram,id=cxl-mem0,size=512M -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.0 -device cxl-rp,port=0,bus=cxl.0,id=root_port0,chassis=0,slot=0 -device cxl-type3,bus=root_port0,volatile-memdev=cxl-mem0,id=cxl-mem-device0 -M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=512M'
> 
> 2. Go to ndctl-main directoy with this patches  
> env NDCTL="$PWD/build/ndctl/ndctl" 
> DAXCTL="$PWD/build/daxctl/daxctl" 
> CXL="$PWD/build/cxl/cxl" 
> ./test/cxl-elc.sh
> 
> RESULT:
> ---------
> PASS AMD plain corrected: alias no
> PASS AMD plain uncorrected: alias no
> PASS AMD poison-only (invalid encoding): alias no
> PASS AMD deferred without poison: alias no
> PASS AMD deferred with poison: alias yes
> PASS AMD uncorrected with poison: alias yes
> PASS AMD bank-4 non-memory poison (invalid encoding): alias no
> PASS AMD legacy bank-4 corrected DRAM ECC: alias no
> CXL ELC MCE validation passed for AuthenticAMD: 8 cases
> 
>  test/cxl-elc.sh | 313 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 312 insertions(+), 1 deletion(-)
> 
> diff --git a/test/cxl-elc.sh b/test/cxl-elc.sh
> index cfa09cb..bd600b4 100755
> --- a/test/cxl-elc.sh
> +++ b/test/cxl-elc.sh
> @@ -8,6 +8,30 @@ rc=77
>  
>  set -ex
>  
> +mce_inject_loaded=0
> +
> +cleanup()
> +{
> +	local status=$?
> +	local cleanup_status=0
> +
> +	trap - EXIT ERR
> +	set +e
> +
> +	if ((mce_inject_loaded)); then
> +		modprobe -r mce-inject || cleanup_status=1
> +	fi
> +
> +	modprobe -r cxl_test || cleanup_status=1
> +
> +	if ((status == 0 && cleanup_status != 0)); then
> +		status=1
> +	fi
> +
> +	exit "$status"
> +}
> +
> +trap cleanup EXIT
>  trap 'err $LINENO' ERR


Don't need EXIT trap and status rewrite here.
The cxl tests generally use the ERR trap and unload explicitly. For a
multi-module example, cxl-dax-hmem.sh has an unload() helper using:
modprobe -r ... 2>/dev/null || true

Could we follow that pattern here and leave the test result coming from
err()/do_skip()?


>  
>  check_prereq "jq"
> @@ -85,10 +109,297 @@ compare_bases()
>  	((cxlrd_hpa == ep1_hpa - ep1_size)) || err "$LINENO"
>  }
>  
> +mce_skip()
> +{
> +	echo "SKIP CXL ELC MCE subtest: $*"
> +	return 0
> +}
> +


Please use do_skip() here.

As written, a prerequisite failure returns 0, so meson reports PASS even
if none of the MCE coverage ran. I think this test needs to be
all-or-nothing: if its prerequisites aren't available, the test should
SKIP rather than PASS with cases omitted.


> +dmesg_count()
> +{
> +	dmesg | grep -F -c -- "$1" || true
> +}
> +
> +wait_for_dmesg()
> +{
> +	local pattern="$1"
> +	local previous="$2"
> +	local count
> +
> +	for _ in {1..50}; do
> +		count="$(dmesg_count "$pattern")"
> +		((count > previous)) && return 0
> +		sleep 0.1
> +	done
> +
> +	return 1
> +}


Do we want to count matches across the whole ring buffer?

What happens if the ring buffer wraps between the before and after
samples? Also, are messages left by an earlier run something the
negative checks need to account for?

cxl-translate.sh has the pattern of recording a start time and looking
at messages since that point. Could a scoped log window work here?


> +
> +address_is_offline()
> +{
> +	local address="$1"
> +	local range start end
> +
> +	while read -r range; do
> +		[[ "$range" == *-* ]] || continue
> +		start=$(( ${range%%-*} ))
> +		end=$(( ${range##*-} ))
> +		((address >= start && address <= end)) && return 0
> +	done < <(echo "$lsmem_json" | jq -r \
> +		'.memory[] | select((.state | ascii_downcase) == "offline") |
> +		 .range')


With set -x, doesn't this expand the JSON into the trace each time this
is evaluated?

Could the offline ranges be parsed once and then iterated?


> +
> +	return 1
> +}
> +
> +find_offline_spas()
> +{
> +	local nr_spas="$1"
> +	local range start end low high candidate alias spa_string alias_string
> +	local page_size region_end cache_end i
> +	local stride=0x10000
> +
> +	lsmem_json="$(lsmem --json --bytes --output RANGE,STATE)"
> +	page_size="$(getconf PAGESIZE)"
> +	region_end=$((region_hpa + region_size))
> +	cache_end=$((region_hpa + elc_size))
> +	inject_spas=()
> +	alias_spas=()
> +
> +	while read -r range; do
> +		[[ "$range" == *-* ]] || continue
> +		start=$(( ${range%%-*} ))
> +		end=$(( ${range##*-} ))
> +
> +		low=$start
> +		((low < region_hpa)) && low=$region_hpa
> +		high=$((end + 1))
> +		((high > cache_end)) && high=$cache_end


Doesn't limiting high to cache_end mean every injected SPA comes from
the first half of the ELC region?

If so, aren't we only exercising:

spa_alias = spa + p->cache_size;

and never:

spa_alias = spa - p->cache_size;

Could we select addresses from both halves? Are there other useful
boundary cases?


> +		((low < high)) || continue
> +
> +		# Stay away from the first pages of the hotplugged range.
> +		candidate=$((low + stride))
> +		candidate=$((
> +			(candidate + page_size - 1) / page_size * page_size
> +		))
> +		inject_spas=()
> +		alias_spas=()
> +		for ((i = 0; i < nr_spas; i++)); do
> +			candidate=$((candidate + (i > 0 ? stride : 0)))
> +			alias=$((candidate + elc_size))
> +			((candidate < high && alias < region_end)) || break
> +			address_is_offline "$alias" || break
> +			printf -v spa_string '0x%x' "$candidate"
> +			printf -v alias_string '0x%x' "$alias"
> +			inject_spas+=("$spa_string")
> +			alias_spas+=("$alias_string")
> +		done
> +		((${#inject_spas[@]} == nr_spas)) || continue
> +		return 0
> +	done < <(echo "$lsmem_json" | jq -r \
> +		'.memory[] | select((.state | ascii_downcase) == "offline") |
> +		 .range')
> +
> +	return 1
> +}
> +
> +discover_mca_banks()
> +{
> +	local path name
> +
> +	for path in \
> +		/sys/devices/system/machinecheck/machinecheck0/bank[0-9]*; do
> +		[[ -e "$path" ]] || continue
> +		name="${path##*/}"
> +		printf '%s\n' "${name#bank}"
> +	done | sort -n -u
> +}
> +
> +has_bank()
> +{
> +	local wanted="$1"
> +	local bank
> +
> +	for bank in "${mca_banks[@]}"; do
> +		[[ "$bank" == "$wanted" ]] && return 0
> +	done
> +
> +	return 1
> +}
> +
> +select_mce_parameters()
> +{
> +	local bank
> +
> +	vendor="$(awk '/^vendor_id/{ print $3; exit }' /proc/cpuinfo)"
> +	readarray -t mca_banks < <(discover_mca_banks)
> +	((${#mca_banks[@]})) || return 1
> +
> +	case "$vendor" in
> +	GenuineIntel)
> +		test_bank="${mca_banks[-1]}"
> +		test_case_count=2
> +		;;
> +	AuthenticAMD)
> +		# The usable-address corrected-error case is the legacy bank-4 DRAM
> +		# ECC encoding (XEC 8). It is not valid for an SMCA bank.
> +		grep -qw smca /proc/cpuinfo && return 1
> +		has_bank 4 || return 1
> +		non_b4_bank=
> +		for bank in "${mca_banks[@]}"; do
> +			[[ "$bank" == 4 ]] || non_b4_bank="$bank"
> +		done
> +		[[ -n "$non_b4_bank" ]] || return 1
> +		test_case_count=8
> +		;;
> +	*)
> +		return 1
> +		;;
> +	esac
> +}


The above host specfic funcs should move out of this test.


> +
> +inject_mce()
> +{
> +	local status="$1"
> +	local bank="$2"
> +	local mce_inject=/sys/kernel/debug/mce-inject
> +
> +	echo sw > "$mce_inject/flags"
> +	echo "$status" > "$mce_inject/status"
> +	echo 0x80 > "$mce_inject/misc"


That 0x80 needs a comment.



> +	echo "$inject_spa" > "$mce_inject/addr"
> +	echo "$bank" > "$mce_inject/bank"

Also isn't the write to "bank" what triggers the injection? If so,
could that ordering get a comment too, since it needs to remain last?



> +}
> +
> +run_mce_case()
> +{
> +	local name="$1"
> +	local status="$2"
> +	local bank="$3"
> +	local expect_alias="$4"
> +	local index="$5"
> +	local alias_msg bank_msg status_tag
> +	local alias_before bank_before
> +
> +	inject_spa="${inject_spas[$index]}"
> +	alias_spa="${alias_spas[$index]}"
> +	alias_msg="Offlining aliased SPA address0: $alias_spa"
> +	status_tag="${status#0x}"
> +	bank_msg="Bank $bank: $status_tag"


Does this depend on status already being written as exactly 16 hex
digits to match __print_mce()?

Would formatting it explicitly be safer? like -

printf -v status_tag '%016x' "$status"



> +	alias_before="$(dmesg_count "$alias_msg")"
> +	bank_before="$(dmesg_count "$bank_msg")"
> +
> +	inject_mce "$status" "$bank"
> +	wait_for_dmesg "$bank_msg" "$bank_before" || err "$LINENO"
> +
> +	if [[ "$expect_alias" == "yes" ]]; then
> +		wait_for_dmesg "$alias_msg" "$alias_before" || err "$LINENO"
> +	else
> +		(($(dmesg_count "$alias_msg") == alias_before)) || \
> +			err "$LINENO"
> +	fi

Wondering about checking dmesg at all. Would an mce_record tracepoint give
us a more reliable indication that the injection occurred? cxl-poison.sh
and cxl-events.sh already have examples of using tracefs. (Which would 
make irrelevant my comments about dmesg log checking earlier.)

Stopping here for now. Will pick up again in a v2 that's been trimmed.

-- Alison




> +
> +	echo "PASS $name: SPA $inject_spa, alias $alias_spa, bank $bank, alias $expect_alias"
> +}
> +
> +run_intel_mce_cases()
> +{
> +	run_mce_case "Intel corrected" 0x9c00000000000080 \
> +		"$test_bank" no 0
> +	run_mce_case "Intel uncorrected" 0xbc00000000000080 \
> +		"$test_bank" yes 1
> +}
> +
> +run_amd_mce_cases()
> +{
> +	# Mirror the full AMD matrix documented with the kernel fix. The two
> +	# poison-only records have UC=0 and Deferred=0, so they are not valid
> +	# architectural records. Keep them as software-injection robustness
> +	# coverage and expect the corrected-error filter to reject them.
> +	run_mce_case "AMD plain corrected" 0x9c00000000000080 \
> +		"$non_b4_bank" no 0
> +	run_mce_case "AMD plain uncorrected" 0xbc00000000000080 \
> +		"$non_b4_bank" no 1
> +	run_mce_case "AMD poison-only (invalid encoding)" \
> +		0x9c00080000000080 "$non_b4_bank" no 2
> +	run_mce_case "AMD deferred without poison" 0x9c00100000000080 \
> +		"$non_b4_bank" no 3
> +	run_mce_case "AMD deferred with poison" 0x9c00180000000080 \
> +		"$non_b4_bank" yes 4
> +	run_mce_case "AMD uncorrected with poison" 0xbc00080000000080 \
> +		"$non_b4_bank" yes 5
> +	run_mce_case "AMD bank-4 non-memory poison (invalid encoding)" \
> +		0x9c00080000000080 4 no 6
> +	run_mce_case "AMD legacy bank-4 corrected DRAM ECC" \
> +		0x9c00000000080000 4 no 7
> +}
> +
> +test_mce_alias()
> +{
> +	local region_json
> +
> +	[[ "$(uname -m)" == "x86_64" ]] || {
> +		mce_skip "x86_64 is required"
> +		return 0
> +	}
> +	command -v lsmem >/dev/null 2>&1 || {
> +		mce_skip "lsmem is unavailable"
> +		return 0
> +	}
> +
> +	region_json="$(echo "$json" | jq -c --arg region "$region" \
> +		'.[] | select(.region == $region)')"
> +	region_hpa="$(echo "$region_json" | jq -r '.resource // empty')"
> +	region_size="$(echo "$region_json" | jq -r '.size // empty')"
> +	elc_size="$(echo "$region_json" | jq -r \
> +		'.extended_linear_cache_size // empty')"
> +
> +	[[ "$region_hpa" =~ ^[0-9]+$ ]] || err "$LINENO"
> +	[[ "$region_size" =~ ^[0-9]+$ ]] || err "$LINENO"
> +	[[ "$elc_size" =~ ^[0-9]+$ ]] || err "$LINENO"
> +	((elc_size > 0x10000 && region_size >= elc_size * 2)) || \
> +		err "$LINENO"
> +
> +	select_mce_parameters || {
> +		mce_skip "no supported MCA bank configuration for $vendor"
> +		return 0
> +	}
> +
> +	if [[ ! -d /sys/module/mce_inject ]]; then
> +		modprobe mce-inject || {
> +			mce_skip "mce-inject module is unavailable"
> +			return 0
> +		}
> +		mce_inject_loaded=1
> +	fi
> +	[[ -d /sys/kernel/debug/mce-inject ]] || {
> +		mce_skip "mce-inject debugfs interface is unavailable"
> +		return 0
> +	}
> +
> +	find_offline_spas "$test_case_count" || {
> +		mce_skip "offline lsmem range lacks enough ELC test addresses"
> +		return 0
> +	}
> +
> +	case "$vendor" in
> +	GenuineIntel)
> +		run_intel_mce_cases
> +		;;
> +	AuthenticAMD)
> +		run_amd_mce_cases
> +		;;
> +	esac
> +
> +	echo "CXL ELC MCE validation passed for $vendor: $test_case_count cases"
> +}
> +
>  find_region
>  retrieve_info
>  compare_sizes
>  compare_bases
>  
> +# Check before injecting the expected machine-check messages.
> +check_dmesg "$LINENO"
> +test_mce_alias
>  check_dmesg "$LINENO"
> -modprobe -r cxl_test
> 
> base-commit: 15e932c4e1318a9608ad9b799ad83a32a8b5970d
> -- 
> 2.43.0
> 
