Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443B64EC65C
	for <nvdimm@lists.linux.dev>; Tue, 29 Sep 2026 21:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717995; cv=fail; b=FpNZl6hCxwRhiFsyBO4qlNPnVctQw18oRks4Gw32Nfw7rBoF8s64tqTv8orGqwPgGw+Qe6BD4t+H4T6T/FMh8xF+yzZ0ryIxv/tmjDHK9QWb8vNXK2bPY1lsUiaj9vonknYtnKUerT5Kqvu8vSYE5cJvIc8Oxcbk1zi2+uSZ0MY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717995; c=relaxed/simple;
	bh=9h3AAoN2cHt6yXGcXxdzuDc9Qco5BrcRu/tqzo5o8/o=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b4TcQvBHDtTCkCr4O7QYkjmZuY/7kMru8b+9ot4MPwRuxZO45XL+JWgFl4641O0bf8aCkwkMeK3cr6B8S1jcmgjDyUGBMw/yLWeQQgOSYqol9daLr9HJblYsnodxuWpRYJy3Dpo1Shp2frLBeMYHzV3fiCubn4yLK3f0wx+KrfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fByWgUjH; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fByWgUjH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790717993; x=1822253993;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=9h3AAoN2cHt6yXGcXxdzuDc9Qco5BrcRu/tqzo5o8/o=;
  b=fByWgUjHJbfj5/xWgod9oFKCv5v7c5FaOa5i9fivBLMr3VKHwUkPapWK
   pqLfWAP5NNwIsWzbtg0YgDU7EgnmqAroS67W45XEmxUvXIWhW36ndC6I/
   Z4WqqKsxXRsfj0Ks1y3wZK0kcrhsbI9VpUv+uYT7OU0mbADF3HE4uYtoI
   3BkPLROYSLFEOFQy9KNbDci2s7ZfAVCE0fE95z6qi7i9ncDO66sjc2cy7
   oW3S1VXZWjim+Rwhxt6tWirbOYL4TKmM37Ni8BPWLZR8XvjI8NrMMk4aG
   HunNCAx8dFSeIPl9n4G2yynL3apxdiBxQBFVJStqmZI1hotvj2q9IJ7Bf
   w==;
X-CSE-ConnectionGUID: 4npvg+zuRba/CVFUXWf9Ww==
X-CSE-MsgGUID: cOL8g005R7mJjZmRB3LuBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90399460"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="90399460"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 14:39:52 -0700
X-CSE-ConnectionGUID: MUqqt3S9Sau0lB03Nj7HNg==
X-CSE-MsgGUID: TltsKwQbRSirjxOg98Pusw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="275043965"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 14:39:52 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 14:39:52 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 29 Sep 2026 14:39:52 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.48) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 14:39:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aJxRHCbil/ssJhaNQ7oQE7gZ2BBJxwjaGwYXEiArLOpj544OpU1c7SUBo+CL5X/WQWdO7nDMnFir7Y/zdD2dg8DlymHe7xkc8/rjwcqa2buo9ZRD9Ix93IhKbYV4iDCMVn5WGn3vRpsWx9+VOJvaMO0xCrq8pRilatFXFzgEMm2bYbdBA8JcMk+1aXvdi6lxmcF98qskhs9l3je2Y+5uHxvFu7vcr8c/OkBALeQVEXOYdcsqVYepgQyGGHa2SS1D4HjN9q8ZRfUH7EQBXu4V201kz4J2tN8yrVRsfW/dUOGfSp0pLs7D/3mJUF+scuucj7X5EMjiHHd6Q6x2RtX4Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IW4+MFU+JJIElxHf2GemhIZhspLCcRyG+/CBlKZQLFo=;
 b=guZUsxZqWyp9bhAwvf+iJRRk3O2JL/BFA4wUzNq8wogcMMkhmbOmft6iQUvXVI/frgNc8vlVmWLzmd6fx2OMdEAYE2udiAf/LFv9fTTOGnf4NQRCRxGvsEN1hu0whwmo2aUGS1XprATSfpUBPunFHoQlEy4/Pj8DvNFa+M12seygqHovSumz/9nDcZ0gT8MY0dP8UXm1w3Dx/GWKQOkBZeEeC3kLf6WB7ZcHAV6iBwgk59cfQiXMDBUhmghu0IScd7SH8gTsEPryx4gCiKfJVH8twdbpvYGrEhy+LgzfK4z4CFgTN2KNHSz+0dJFK0alnMEBL3buoXjZ42WtRoMV5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS6PR11MB798475.namprd11.prod.outlook.com (2603:10b6:8:528::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Tue, 29 Sep
 2026 21:39:50 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0451.026; Tue, 29 Sep 2026
 21:39:50 +0000
Date: Tue, 29 Sep 2026 14:39:47 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 0/7] cxl/region: create-region command and unit
Message-ID: <arwwI14bQpVEf-nk@aschofie-mobl2.lan>
References: <cover.1790658549.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1790658549.git.alison.schofield@intel.com>
X-ClientProxiedBy: BY1P220CA0041.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59e::13) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS6PR11MB798475:EE_
X-MS-Office365-Filtering-Correlation-Id: 30afe4e9-0ab5-4bc4-aee8-08df1e7230d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|56012099006|11063799006|260925021911599003|260925021311599003|260925022911599003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: q0fBOO6EYmvd/j4EtNb/S455EqYXaDXwFAC2gZz9RANU2I0aoGpXjfbOIhhpMIkJAJQLVzQmEGXjHl4mIaVDHC7tFzCJ/ej4CDpjJPkvgBb4CJBM7a/lTLv684VBUC2cjLBFoOsL3YZIW91fYJEGLRFls3cCPqbmvwqoqV4v3qZbDhtVnDWiq5KROHfwTZjJqt/byjj26xdmyrrRbwSo9fG3CgXbh5ewadsP7Hn34FrOqnVKoDnI0+2VRq5E9bIhhm4rOf3SF/mggiDNrKjBGoIVwfxTK2lhRVxSdGV5cU+Wlu2hBAy1qEzjdywdOzQyry0jAuRQQxIyks6+7rSh8NmWLA6K0bidiMRxvDsXsH8L48srrCUBJJsdB/ctd0ow60fCbvPPJEGz68Gdm/CEpDQaEfw3bt0ZYtgnj0uGEqTtmimFoCUAwqzLVW0dJUo8kqMbrqHeG2uaImBqojAywYycRlgScMzescLJSeDMsJoaJPv98z4EuB/H0B9Jql5WqePFiXNVkBUGRkAW9z0mngqaOnZzh+IHekueJIUKI4/fKaIW9vVQaFwP4KZSOiEmt869AEsJHPOS7KGse6f67Sg3uYvTJgA9rsJ65A0wvpt56EsgRJrhPunRutw/L34q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(56012099006)(11063799006)(260925021911599003)(260925021311599003)(260925022911599003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hISDeKYhaRfANFU0U3+tJaIIFFDreKwkyQSiEhlNZyh2o4SGE32a6HekxvUz?=
 =?us-ascii?Q?XZCBJNitiRdnBe5teKkyTAzGTL8vug40w+VutzkkDFz4SE5GuWrNBane6j/F?=
 =?us-ascii?Q?UehavFH6oTzbuHOsBeifoZXroCmZcnneS53GOzvJFeQ2811WHp5vNZY87OKl?=
 =?us-ascii?Q?zLbbesZPTUWzc256ZtWvQFiThNlZW4aSb4Z9Stv/04ye/SN6iNi4dYWCGUj5?=
 =?us-ascii?Q?YpS3Eu5H7iy+zgA2mRKCPUkvysoRa8laxYx1ueRR6fUeAc/K37f8SvSM4kUl?=
 =?us-ascii?Q?yRMTVab+Jq/qYq35VTNLSj3Fxn0oAJE/ulLtGKhbgamnkqcTsvg2WyXH9i2S?=
 =?us-ascii?Q?uHbvPzM4kr5qyCXs3HHggtg4BW74xy6OONtUFAm5WTlz6C5qoOKw+Cun8jvd?=
 =?us-ascii?Q?Qhn6Cut0yNqimieACe7k3l6KdVCjZVZEFrM2GM6fq/s65qEb3h9XKbafSj1R?=
 =?us-ascii?Q?fh4iBFqpOvLu4narftaHencLlH9ooDI8/lzGkSiHT4znn9eRJt64hbs/Sr4W?=
 =?us-ascii?Q?UA1qt/AvrEGZZFJ7UTyg9HN6BNUIEx2Jw3h3o8f/Er/gS7NXyZ0YAVkGYsSs?=
 =?us-ascii?Q?61/U9XzTJgH5websGsDLOlxJllAvkSQaKlpnQ7kX0ueR2Hbc8M6Se8oJzlr2?=
 =?us-ascii?Q?jteObzlGei+L8nJT0JdZYVu0i7RtJyEfBgTVROXLg/nzo5HJObz8OUpL2Q3M?=
 =?us-ascii?Q?Tbff7X8IUUcUVrs6PP1YgLeTmSifsdrP3o4FDHHRJaN1K5oXyGB64mn2/RRn?=
 =?us-ascii?Q?pxSJAoyMJsl9V4ISSjPWtjjAZMPM46kGCKnRbX0ve3Mk8nvMwOVgCIzyk43Z?=
 =?us-ascii?Q?1g9Mz517zq2O7cJAJf/fxfbnX6q7cz/W/Uk1SrTqlix0mrADRyrgYqo+aksV?=
 =?us-ascii?Q?rF17GR2pZB/WcPoCf1hKGSy3MrP2F0mVinnOCStY5iHVM7iIeMkG6gl9mFwr?=
 =?us-ascii?Q?We0D4ssHlGYNNHTO05Kc+ii6dyjncYUW/yCpD54cAqSpVYHU0fyYZjBifZ3x?=
 =?us-ascii?Q?EENOflde42rjV8P4UW2PP7M6FKXwtwqSOuNpdJkqMGz18ulpFuSANA0Rl8QR?=
 =?us-ascii?Q?NhSgti7v5hoST2cE+yGiMUwWJ9yJY9fH7KUJ41sg98TMq3vurfKTJGz3L4+y?=
 =?us-ascii?Q?KTIPZLiEI0j+pCjyAU19kZuGmpyu4wYr3zsP2JxhrC3YKpy+/B0g+jeXSZE2?=
 =?us-ascii?Q?AgaZ1DLktfCVgjP94jE88zvYjMD1GekNxIiQ22WKaa5aIO0qoFCguYH3UxBi?=
 =?us-ascii?Q?YgHICVOvHuk/jwkNqjJ2vUZPmte/xAZzMdmJM19h4dCzFwYy9vb/qVu2SfDE?=
 =?us-ascii?Q?agyNCspjgLD9/P7xhZsimBn+/UD6N2Z0Ie0S0j0LfwP1w4NhWurAusp6x7XF?=
 =?us-ascii?Q?E8kfTtCaYjSutoTprvN8i/tJ1R6Sar2Dgxb6Jej4fo0xEywt/JbWpA7Rs3X/?=
 =?us-ascii?Q?pOm4B7evzl62yhSussZ9XmlX3xavVhnt4bYMFrgumyHrn/eh0gHF+IXz3T5p?=
 =?us-ascii?Q?6uAbB+AdncOKP1K9WqJ2cDT4YK/jcfnBN4Em/W34YjVPj4jovPqsaKlmaHi/?=
 =?us-ascii?Q?Iu52TJHO2nFKV4NFYOYDWXQj6+S9s4+zBI4c7kp0LGthWwmYMjcqbxD8ZnX3?=
 =?us-ascii?Q?gmj4k/rzAlLdST4no5LdPGZiSPoarh0ZJxmX1a7Cy9eVEbLM/GGC9fJ5D58v?=
 =?us-ascii?Q?yQlj16DloQgxZcADUP8FS/oQn3p3912l0+CzBcntLwMLeIHROmNOoijaJ0ct?=
 =?us-ascii?Q?1DbfyaMOaBD+KVbay2Es/VTjwB9fABI=3D?=
X-Exchange-RoutingPolicyChecked: s7tudwyYxC7XLzKW5eRuKhO1hyvVdv0JFNHBOruXZptrUZrL2ynNUIluDi/tihgx1+6x5KibiW7zrEuP+J12I4T2AWH5m2s5HOxVOgdiyw5qL9cPVtlOc+1WELso11oCy9RxjXa9Wvpj/V7hBgszKSgZsHvXQ3X4YIKns4vsg8Jevz1o9rBvr6PFVNmnoaXsMQENRFAG/A2OdghLISnHZnGYFSy/5Yyi/SeUfQXNWo53j0KlDu8CXaQEhs8PpAMfGbhdA3wBuMUrSbgIIAGfHwAk5kbn6leWVM0+QTA0I92WbMR3zdcUZ4IM0vMzDdnwoxa/QCW8372I92eRSorGEQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 30afe4e9-0ab5-4bc4-aee8-08df1e7230d6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 21:39:50.5848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKtK8tieLuzj+/jeUNggMUVyAJeDYKXjJsZ05IUr9gV7TjhUh5Fw9LPsabOX48Jnog0ZEGV9/rujPIRFePDIeYlYOtWCisH6/oJSGp5WAfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR11MB798475
X-OriginatorOrg: intel.com


That Subject: got truncated, is:
	cxl/region: create-region command and unit test fixups

On Mon, Sep 28, 2026 at 10:36:52PM -0700, Alison Schofield wrote:
> While working to enhance the cxl-cli cxl-create-region command to handle
> out-of-order target lists or no user-supplied target list, I ran into some
> basic issues in the existing command that need to be addressed first.
> 
> Patches 1-2 consolidate and clean up the existing create-region tests.
> 
> Patches 3-6 fix target-list parsing and validation, release DPA after a
> failed create, and move granularity validation ahead of region creation.
> Each fix adds a test case for the problem it addresses.
> 
> Patch 7 corrects the documentation to reflect that --decoder is currently
> required. Automatic root decoder selection will be considered separately
> with the upcoming create-region usability work.
> 
> Developing tests for these fixes exposed two bugs and a topology gap in
> the cxl_test mock module. A companion cxl_test series is here [1].
> 
> 
> [1] https://lore.kernel.org/linux-cxl/cover.1790641236.git.alison.schofield@intel.com/
> 
> Alison Schofield (7):
>   test/cxl-create-region.sh: fold in XOR coverage
>   test/cxl-create-region.sh: deduplicate topology lookups
>   cxl/region: parse comma-separated target lists
>   cxl/region: reject duplicate or unknown target memdevs
>   cxl/region: release reserved DPA when region creation fails
>   cxl/region: validate granularity before region creation
>   cxl/region: document --decoder as required
> 
>  Documentation/cxl/cxl-create-region.txt |   7 +-
>  cxl/region.c                            | 139 ++++++++--
>  test/cxl-create-region.sh               | 338 ++++++++++++++++++++++--
>  test/cxl-xor-region.sh                  | 129 ---------
>  test/meson.build                        |   2 -
>  5 files changed, 442 insertions(+), 173 deletions(-)
>  delete mode 100644 test/cxl-xor-region.sh
> 
> -- 
> 2.37.3
> 
