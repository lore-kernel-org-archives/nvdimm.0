Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C8178F26
	for <nvdimm@lists.linux.dev>; Fri, 16 May 2025 04:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747369049; cv=fail; b=nOcP29ZtrsLLtmbXJrG/H7IxLtCBjgvCq0P9sa8ZfeiL6iFTvUp7E57pn8RpXG8+bp81FGcB3q2aBWX+sV2LQQoKquU5yDBgQJTn/kpDCXsqmVmTqIe0PV4PMUS3J5Jg7geb0ejvEnDKI6hNFf3vw4t2sT/qLAEMFXyTj9qYYqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747369049; c=relaxed/simple;
	bh=9rdJmh+v/dO23ZrAn1R9EtEnw9EbKrKV1/xRyaxH8Pg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N2GNgZSPQazkYx2SmGIUrgA+zYPOkcHdptbzzvafQEQyudEdZY88xTscP9fav0akN0dwGEjfeRdZ2MHLoz9MSZ+TpljBAzz/6Ox9EZGrKleoiK8sjtB7z0kWtVCxnxCfVK0e4JoXxkD0LdJ5YLZkV2r1mcBVBkIDcE+1H4RvtGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rh/sEIVT; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rh/sEIVT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747369046; x=1778905046;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9rdJmh+v/dO23ZrAn1R9EtEnw9EbKrKV1/xRyaxH8Pg=;
  b=Rh/sEIVTV21Ksjb5oKKfqlqsyJZ5BF2NDxe74zwr4DYZluJ0CQ053syi
   XLje1XHBE6GkAzFz1l+0YFMhE5PDeLdOjZIIplx4N+YlvoXKvbbwMHHme
   OQiTEk7h0sDLOpBZi01/8h4/2LUsYqT9+Y6ALy6Auvf4xTaiodZNvkqi+
   MhocpsLPydxvW+TWKQIiIOQzlKhwPYqxyiWWvtKin6kI6rd7DrxxnbVap
   25Dk2MQX+WMwWNcKatK1hFir9LEIpjXYoQSFEauHXZiUCQt1XOGQaT5e6
   3Ah/DBCOlspBpsStl9TsfLxLSM48p77FXLFRAnDRTEa2sjUdUCNIqjGYw
   A==;
X-CSE-ConnectionGUID: gwh9N73ET6m6bB0/L8HHnQ==
X-CSE-MsgGUID: Z4PgqcpwQwu4FYi8+sHd7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49439721"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="49439721"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 21:17:25 -0700
X-CSE-ConnectionGUID: enHhb0mpQOKY684wx/LHuw==
X-CSE-MsgGUID: FPCDDbRUTDGoBX9Te32swA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="138474715"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 21:17:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 21:17:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 21:17:24 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 21:17:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N+Kjl+7uja8eab9ozrzDxYgZVFHGgLrbLjgC25P3nkDi6ldWKpbBLhFOTxzuBaPXsvh8eKEXpVGy6ZYZoMOkOkdtof2VS7cKUokrp8aQR1fvdwv42Wfunr/SL/y4TLl1nzZFU4m+7FHA6p5obRwrwOYiq6glcildND4hRYJhxEKaCXpQmLmLAx0esAGQStQbS9FmdzoYpZ9kyf+jQ3f0xWb/zaCvbPBqg78NE7f4aoquXE2f+oa323u3nyJhjehk593LwAsPh8M685fytEyk/Y2AuS5VDoJieQZRkVcXFQlwat8b9CPxIpqlLEuCBQOn0kkFu7x+2UdHhpn/h/uR3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSZvSfceABj2tr3ON18N7/h0XQWKus5xN92r87eT5Qg=;
 b=ahnwXPhvjRO3pm117o1mvulOG+PXrXHWPZoFHt4C5NXB338owYig4aPYEho+2Qtov/31SejpwMzoKz/WfR1m5L00uEnnXmdhHra/6HbO6M+rYLtSJBRhE8lEThesxAWrYtXdz7LKFquVcycxRpurK8E4fc3Smg6LK74D4MWjlUkShdPzCJ1zH436UyxvOMoKjYgvdnCSKaEixZz4S7bFEVNLMg12HA6IacHSjIuT5KNzzqb7/o9lkVGiqP3HwstoTkZajloZtaRJdCEpV6bAORRq4hr9lP1TVL2SIk++lgGnb77HXCfUG5l+6Fy+oboKN93+mSPJk/VcNxVpISmURg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA0PR11MB7956.namprd11.prod.outlook.com (2603:10b6:208:40b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Fri, 16 May
 2025 04:17:08 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 04:17:07 +0000
Date: Thu, 15 May 2025 21:17:04 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Marc Herbert <Marc.Herbert@linux.intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Itaru Kitayama <itaru.kitayama@linux.dev>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: List of CONFIG_s currently missing in ndctl.git/README.md
Message-ID: <6826bc4094a68_28f6294a9@dwillia2-xfh.jf.intel.com.notmuch>
References: <aed71134-1029-4b88-ab20-8dfa527a7438@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aed71134-1029-4b88-ab20-8dfa527a7438@linux.intel.com>
X-ClientProxiedBy: SJ0PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA0PR11MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: e3822167-0647-4df8-f325-08dd94308578
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EidRqll/bW7JbqDAYUdLA0LbKnhUJkBzl1P69pIif0+ahU/DWlRLcL7yDciE?=
 =?us-ascii?Q?kcdJvbRzyIsbztk4x3QwIUkoRZNbyd32OFXcUgccliXR9onf/EB1wKym0EH2?=
 =?us-ascii?Q?FUjqkZYUlZrlYgRcA9CBaeWHRX6PIAzgEXUuFNkFOtR/BK0c8Y50wPCnBl/v?=
 =?us-ascii?Q?NbkHOzIXVoqZS6TwDov4RonGaZANOsX+t46X0EsccqbB0245wytPPvLiJXcm?=
 =?us-ascii?Q?1HnD5/Azd/CJ+Yjuk9sdvbW36g5OEqxuZy6uNmcmxgM+8NI0qC+IQaulLjyI?=
 =?us-ascii?Q?CkEW9DKJSEH0pIo/gCeBp8RA5yDY/Sq9EYYpd4lRblsxGVEMWU8zPlZkLV9C?=
 =?us-ascii?Q?oxHXXkTB6Fif7aUBClbQiiDX7yoz8/jm++OQYZWdJVzD3zrRTCu9R9f++PV2?=
 =?us-ascii?Q?RZozWk3oGl3Fj7fVmCbBryPSiMMCsXIQMOYmxn3UQ66uSBuXHpYKokmoCrQd?=
 =?us-ascii?Q?NwmNkx9d1z/BVlNVTE3wprc6Pbo3RGGalha3sen1sGHTpw811Kv3Lr6ylpVC?=
 =?us-ascii?Q?IZ5krdfVttuJ/BpnuiJr63QVfmZej2BjMLSd34vmQrjT/DTSvBpMr9VNVeii?=
 =?us-ascii?Q?1ETue5YEqLYOHorJdRjhjAuJLFf3YRl06tNM+McqEYAXdzFPxmMDMCyC9AaD?=
 =?us-ascii?Q?wIN8Gq+x6j5WTJMzpklYa9gaPw6WqFoYsduTqy7XpFjLMzRXPNEV8nYFLH8e?=
 =?us-ascii?Q?lx8yLmcAn2FoO3CfFqH7TpmyjlreNP5W/Py1NZn6jCBJgTXsKVPbpRIX8L48?=
 =?us-ascii?Q?ZRWqOfCR5vBpGm9ntMeMmYqAsO2Ag6s0bLNGJ38/FSh9Brq3sBQIO8twbxV6?=
 =?us-ascii?Q?63GvpNrdzSSzY8bdScCJfRgl41usaYF6zfh07nK4Sux/ilT3h9RjkphtLulU?=
 =?us-ascii?Q?P9kgZtggYYqhPkjXSc8V+D9iySnRqnJSK58w4bjd+W61IMlVwU3fwdBoTUnG?=
 =?us-ascii?Q?7CM+f4/1rGGJSp/pmla3wOeyv71DabryB9LRwkTaULtAjIh4osYjh1HBgk5z?=
 =?us-ascii?Q?aUaaiWQlM7PxatsKW8zRhNcqARWDZUP+6jvNcvwnSl/4Tr08SgYsnkj/UwCI?=
 =?us-ascii?Q?KX3KgQXJFvaU86M4YO7XGUQ3g9a64jTlCIseGeHUn29vx2xtJUF7oVc7d9Ta?=
 =?us-ascii?Q?7J0KX6tvIzejqGYrKGMkSLlhHRFTrkKAmTXDf7IcGnCYJ93NNXMLk9jLwtjw?=
 =?us-ascii?Q?B5LiDIX6WjU+M/5b8MRsMaIy5X2P4F1AafY+f2GrgFIydTHerpMukjtghXYp?=
 =?us-ascii?Q?JwulC8XQimZTcvRpvSKXSXi+U7B55aZIdRTfaEdt8qFZCFco3IFf1CeeXION?=
 =?us-ascii?Q?p0rUziJxntYbAHlDDTBhtalRyfOkIZvl0WbAwdVQoaUiKyxr2qvBpk2OJweZ?=
 =?us-ascii?Q?8GF7AUOlV7//wE1PrfxQXNdrCPEL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8SDl5fOHwpuohZwSeVWeW+KzGLJM9dPHD5f69sSiK/ceTSzqFaGXT1POf2r0?=
 =?us-ascii?Q?V92l8Q5QetpamRqmEQVJ46eOqNf+SAU+NTDyY80AzI/9mT8+rQFrHk+b8wYn?=
 =?us-ascii?Q?WxkTwagbtGvmHeL2ob11l6xja37cVsrnMNhIZWr4Xdi8nhQ/2os09YNvVBN5?=
 =?us-ascii?Q?ptf1+gLmLV15mEhpikoVdbz9NgvgwZea9slO62W8VX8klqA/YwufW9sy+vEB?=
 =?us-ascii?Q?QtAbhTzDvYReWQiyijQ7YIFIESQsot5Sglp2Nx3ckkk0wTVTwdFePugsrW+3?=
 =?us-ascii?Q?DQY8JDzFArrSfhHvk4gcsgdPzotUhROFMnMwCNyIxVhQsDjoTD9+gArmMGiI?=
 =?us-ascii?Q?/f0FJokLlVuDObF/ZsQXkcsJpfYHk66qa81wJAjw/aP6UC66HxKWmQhKbE/j?=
 =?us-ascii?Q?ibQ4vNqtdtYKS/XuClk9sAyAoOOLMcXEM2mNtwvXb7tomb3PGK6Wqcb8uBg6?=
 =?us-ascii?Q?yKVhPJqq9PKltqQ33GO7upcnJ92SkY7/IDSv6G3Va2YR4z4qDuTb6IHh+MA9?=
 =?us-ascii?Q?Nu+IAyWUAIXMvOOhZ8Bw5U3RHSELZ2btfP7tXur1jfZ8SLx2EyOb1Xr0Gec9?=
 =?us-ascii?Q?KAdb7xYZssSZAK5dLxNc0dfG4JD5jSI31G4NixtTAgRsVQza1Y8bJUYJxLvR?=
 =?us-ascii?Q?izcNAzTYYJI6BLN18CaRuOvxNgadU3hKtKe6RAR+54TdP3P6ajNnEL2OD/9N?=
 =?us-ascii?Q?LJBgVKHc58rEeqgrf5KYN6nMoYpr05PvP8ipIn6/nfm6D+7c7YIp4mGWs7Pl?=
 =?us-ascii?Q?uIWqdbBlJvpVa03QfxcsJsNWY9F5zFc9V+q5UpA/zgisaruWrlpm2vabU8Lu?=
 =?us-ascii?Q?e/LWuSTuN5b3EO+2AzoM5aBR/os0m5xvX14No0MxfF0CLd5G5hGsdFO7y5gZ?=
 =?us-ascii?Q?kuvCf2QoWnbMuWkr565UjBIrwHiAKW/tyfilBxJR3fzLXH7uu2GigH9s31+Z?=
 =?us-ascii?Q?P2RWyB0GG5z3YpBtljIguqGmgIxBicOU7gd4nFGnzzS54o1QZ2EghJ5ciZu4?=
 =?us-ascii?Q?rMu7nv+YOiWNijv5EIPPzXuiVQw0nrbUmkSAId1DvMSmLvu0WhfxqLsYiCdT?=
 =?us-ascii?Q?t+AdKp+LOwC6PKd/ZjojailmttXMt6uZzl3lHITR/yTWjTsiSWS1KrxH8elC?=
 =?us-ascii?Q?0BT03FsbDoAh9BImxUOfZIV7H3GRxJAuZisKQ6KUP8ihHcjsBord+f6zNsvA?=
 =?us-ascii?Q?FF+tOF+CkM9oF3v96rdrJ9FKMR4EjwTV0oJd7/4JcrxFlN3L7uxb1ke9Ml8D?=
 =?us-ascii?Q?lGpg5Qsi8PesowiymFcxEqvKAEM4kBpQcID2olaM95oRGjS3LEHhCXQpFePW?=
 =?us-ascii?Q?euy37630UmZq6Z3hLAjEdlZ/r+J8oFmEeWg8uYq5/1ae4lI/EHRLbf9eqN84?=
 =?us-ascii?Q?ux07jZPc0XNqlEeRMKG12OdtyeWANUka61a54rIrU2EyjrABAfB87s0BYiZc?=
 =?us-ascii?Q?2MAv1oTbL7/vkv+uBAZSLiecY1L9SDnZ8Wu9IGGFhSeiHQQEhbt0YAs8mOth?=
 =?us-ascii?Q?xocVmyUAmON3IXYBHx8Q+ustWCOoO+2UZsdWGTUBEOmW2BY3xFL2i0OWH0Et?=
 =?us-ascii?Q?VGPFRZsH1FM8NdtKyAHlkBjzM5ttgHeQxvM+qn2HtHB5HUR8IEmRxVl/A+tA?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e3822167-0647-4df8-f325-08dd94308578
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 04:17:07.7359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dld71aQjaKz5cJEIO2UZHL1VZRqwvwS0Pl/Iq/O8Erj86fWLEjW1yytWiyDBhSacokW7msGaOQJg4o82/EjVmQqXp4EBhj1iw1Vinh2g7i8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7956
X-OriginatorOrg: intel.com

Marc Herbert wrote:
> 
> Thanks to the patience and help from the Intel people on these lists, I
> think I finally found all the CONFIG_* missing in ndctl.git/README.md
> 
> I tested, fixed and published two CONFIG_ fragments here:
> 
> https://github.com/pmem/run_qemu/tree/main/.github/workflows/
> 
> - cxl-test.cfg:  CONFIG_ fragment enough for: meson test --suite=cxl
> - nfit-test.cfg: CONFIG_ fragment enough for:
>     meson test --suite=ndctl:ndctl and --suite=ndctl:dax
> 
> In my ideal world, these fragments would live in ndctl.git/ directly
> (instead of run_qemu.git/) and ndctl.git/README.md would point at
> them. This would make them _testable_ by any automation. Like this
> automation: https://github.com/pmem/run_qemu/actions
> 
> As a second best and much quicker fix, "someone" could simply add to
> ndctl.git/README.md the missing CONFIG_ found in these new .cfg files
> of mine.

Send that patch and I will ack it. The linked configs look good to me.

> Unfortunately, that "someone" cannot be me because I don't know or don't
> understand precisely what many of these CONFIG_s mean: the files in
> https://github.com/pmem/run_qemu/tree/5723a592/.github/workflows/ come
> from "educated" guesses and a lot of trial and error. But these fragments
> pass the tests, so they're already much better than what is in the
> current README.md!
> 
> I can already tell that some of these are tricky. For instance,
> CONFIG_MEMORY_FAILURE=y is required for dax-ext4.sh and dax-xfs.sh to
> trigger the error message "Sending SIGBUS due to hardware memory
> corruption" (more context in
> https://lore.kernel.org/nvdimm/20250515021730.1201996-3-marc.herbert@linux.intel.com/T/#u)
> 
> BUT, these tests can also pass without CONFIG_MEMORY_FAILURE=y and
> without triggering that error message! So... CONFIG_MEMORY_FAILURE=y is
> not required? Or, it is required but there a bug in that test? Or,
> either choice is fine but CONFIG_MEMORY_FAILURE=y is better because
> it provides more coverage? I don't have that sort of validation expertise
> and it would take me a long time to learn it for every missing CONFIG_

The goal is to excercise memory_failure(). The fact that the test passes
with memory_failure() disabled is not that interesting. Could the test
be improved to fail when memory_failure() is disabled? Probably. Is that
useful? Probably not.

Those build time checks are just a more forceful way of ensuring the
expected test environment. I think config fragments in the README are
sufficient.
