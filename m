Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9422F12B6
	for <nvdimm@lists.linux.dev>; Wed,  5 Nov 2025 22:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762381417; cv=fail; b=AoMUHE5CE1QLj0Riu6k77EftLwmKoDRk4CDuvYZ2lM0FhlFfKPx+IetQ/quz1wcMJWva2bnPL4DaxBD/0gGM0yfhEL2vi1cp29M10IUtGyzrwiPT7IljutWhyN8t+2O6hCBt/uHvHPJleLpCIovtdEe3GdrXh5lqVc/dxer8ajs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762381417; c=relaxed/simple;
	bh=41as8h0aBwzgUmhB9OcsbdIMn6bpV4DRwa3kBuvx1sU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FtI8zufWbC1HvBSOSMLDFRdmkzMbluhPdSlooE3QR8CiooeAp4fPP14AJONqeFlvJpL9+pxetC0Pl4xDhFgsKlQ26xpgldYURtZQMEp6hvNbJLHst47ccmCx1PHrbsXICPtQ6xTE2EbM/HgZaWRz/LEMfGy94VXg1RdVeMskNWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R9QDui8h; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R9QDui8h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762381416; x=1793917416;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=41as8h0aBwzgUmhB9OcsbdIMn6bpV4DRwa3kBuvx1sU=;
  b=R9QDui8hGv7wts/BHDWxWiUdtlDY6dwhFUV7XJRzLTkwNYKSj+y6pGiK
   sOIfIU4QwDH54mlnJLq8SpW5hNmF+vONGjxkL0AMxJalPtZPJI2/bQ5Qc
   ZjQyPH1r8ZdMaB61dKGZW9u8lhIp0JUoiIcPOP50AuhJaEPDkZrgRyFCx
   V4t2+aGZaRaRmbzvcsA2OWdSbb5rugqsbakgzxNUG+qeWf8xhBmh5D1gg
   9FrtcaQ/sb2f9V+b5DckFgiO2bvRzNJ4+gs5f/ZSLWfvit9qn7nw/f+Yk
   A5IHGxwAzEMyb+zicLVmhM1ZmS3vzGqXoXd9P/GIYY0Ha8oseyc+i2eYS
   A==;
X-CSE-ConnectionGUID: SvcohBSQRPSk9Gwzb95ZOg==
X-CSE-MsgGUID: dRdubH1aQmGz4ilHuVRt8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="75958306"
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="75958306"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 14:23:35 -0800
X-CSE-ConnectionGUID: Rnn/TPfdSfe/DG7qMIDeAA==
X-CSE-MsgGUID: oG8jAFVTS8y4Cv9PGrgPsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="188027817"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 14:23:34 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 14:23:34 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 14:23:34 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.25) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 14:23:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hayhvfoIsZxfzdOe2N/409Z+m80Wphylmnx+CWKimgTj2rF2e6Htzkx3gyL4KVkCTrrzvwuCbDc3iXlLHEVgjsMLtnMiIdPv8H8tC7Mt/MjxC5GGGVkVGdfwoiFVQhwLERZ8l6Ddk6GVnhsvuRJ+LbEGQ3z7a7vazmEoeyZNr/GizxQW91EfyQKudzrmpy4q1LeEM+Tinf+r6SaDPcItgwvjHniAKi/b8dqHRmQfdwZe/KQO6HaYsXldYPNQBRvIfEHz+OxnLRRqdzJXJlefrYk4GypVvSs13QZvlWEyeMxpnszThf7zjQ01m9kRLvLj5s0jKJcq9ZNeSA1hDw0sBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JU3YtXWOlevRz2O01EEG1cccZ4oX6myT+2k2kSe6FwE=;
 b=ZsAC5NcHXsW4pAn8vWDJy9XDYJFYe73MXq/T25ll2nbf46HxOuBXZhFrBwo9qcXChkjDDSgabvuR7GsyLWvxFUe/kn29gOVV7+75uHdbvOksQBk4ZU0w8BswMPjF5p8qa315HLgmAHj99Izwax4M+pbz4Njmn05BEv3BgQyVkj5nyIiEZjz6PTalDcKV0L2uIRkXDmY8QtupHhrxcJusQqfkLiIJ5QA7ERM7asPDtF9KmPCoAw+c9cQpmqdS8uq+grz+yjINianfVVkHVzYexbZeNI68a6XuWFqHwo8ZjH6H4nM/fJEmgpeK8A1xUmZgX/cBw7xj48ntv9S1mx1Eug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA0PR11MB8377.namprd11.prod.outlook.com (2603:10b6:208:487::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 22:23:32 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%7]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 22:23:31 +0000
Date: Wed, 5 Nov 2025 14:23:22 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Linux
 Documentation" <linux-doc@vger.kernel.org>, Linux NVDIMM
	<nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: btt: Unwrap bit 31-30 nested table
Message-ID: <aQvOWuf5Wj7UTKKh@aschofie-mobl2.lan>
References: <20251105124707.44736-2-bagasdotme@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251105124707.44736-2-bagasdotme@gmail.com>
X-ClientProxiedBy: SJ0PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::30) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA0PR11MB8377:EE_
X-MS-Office365-Filtering-Correlation-Id: e9e63180-5fc0-4c33-3e3d-08de1cb9f3bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pOQET85nD02C1NE5zHaaxNtlBF/VD67gbIWxZtV/0N/O7cruDVf/Vspq6rL4?=
 =?us-ascii?Q?Ia8X+wapMywtWgClm3Sw0gFHhzxbb8odFeqFI+pOTSNtx/klZBD78ehyBDQE?=
 =?us-ascii?Q?MUL3ExfVSrTCVyMYlr3dNg+jnp7n968jilNGp2QLks2VeiaD9jWaGgYTPUU8?=
 =?us-ascii?Q?Lnv2xCUjoX9w2HTo0HEaOt/a2RZEMvYMS/sKo0/aJvlItuji2tG4W/QzPoOd?=
 =?us-ascii?Q?NC6PE+T2Fz/KkTqBAjaTVydcCYCb2vmiCDadjimow6/SoTt80p6LU/f2aO9G?=
 =?us-ascii?Q?EZiBuzEExYX2wJd4XmuYUCV4Yiu5G6WXvTnQ/WEmQERIu1l+9n8dnjIRJVjz?=
 =?us-ascii?Q?dHLQSu4roUcQzDxcK0roLveg2vqNUOWUY5Qd7fMM+mkkXiuMPA5OwssdqHBf?=
 =?us-ascii?Q?UhvL8GFHbvmf2c+zlzPMTAPwWtbZCSXI3rjyxviNPNMbvnhgzBtKEKlGKYyW?=
 =?us-ascii?Q?OIvtF/aTCmgK/CWAOXpaSm7fCV9XT846mXhlFq1KMvMGyuHL0npVQ/6erNGd?=
 =?us-ascii?Q?J2xhOXI0GwovOTH1xPQFYGdvFJfGwbpH9rt8QFGa5a2TxrxrndUs+CBWe42e?=
 =?us-ascii?Q?cgyw4NxxPiF9SP0+x685OGB4fL7S9vfrYwx3gW9sFB11Se7Gw6SME/dHznyS?=
 =?us-ascii?Q?WFu8n9WlnhLeCtOz+YArA59fcm7xjMYtoiJxv59sSKuQxj3CQJmQMoNrkCpK?=
 =?us-ascii?Q?t+YRN1CgeaYPttpvijQvsaOspAJNphKKPncJ1Vcy2x+fSLdE+aonbJhMAT2q?=
 =?us-ascii?Q?rC8Xukw117zZWrIkXf4QpCD4uGfVIqXfn88atxwacNDyAOT3dQeI9+lS5Roe?=
 =?us-ascii?Q?WH1HYTfovfWLLzWHlP8DvKda561HeXHgCEavehA53xYthwpIafxWYxU8wvQr?=
 =?us-ascii?Q?9vS0mDjbj+gQD1m9zN81e8g8Qel/AdnyuCPMGcsmgSlX41QbitwfXzJXksjn?=
 =?us-ascii?Q?2YqLWd9aK8zygZKNSfhXolH50LzldbXUs7DZjcjlsk40C1lm0O4E7k6YfvCS?=
 =?us-ascii?Q?JRGFHjEpdH8yvzsFbJFYwwT0seA0qVOR50DOQBA6zuQkLAYp7NGVdkwEvgb8?=
 =?us-ascii?Q?zqnEvAFqAPb2CXEstI4krq+46fJIL3oztc7qdPHcwIVjnPDRRFiwhqSlphue?=
 =?us-ascii?Q?2wHJsL1kVgh45PqAPqO3p/BhldjgbVa++A4ij2t+7Jr9q8n2H3wcWtDxvS3p?=
 =?us-ascii?Q?VRs1GWMTzuZ1fpdN5yC9rs3aj8w0hVovIZLq6ROE6SuqJ3nNBsjNzlVOX8TT?=
 =?us-ascii?Q?S0BgcojnnqAcG47kj6Fn7qdjCPTsqnoircIcSm4El/I0uppXFdG5rBPQFipT?=
 =?us-ascii?Q?URQuYzjUbpIGCVOJaJmIAnLh2q7CDVgLFGpmX6y1j1/f+H2Z7n9vnqdNyhlX?=
 =?us-ascii?Q?EaBZoXg5ebvpHw4qix6KposfT1j3zXI/fHIBnrlQoEuoU4He6etGszs/St6D?=
 =?us-ascii?Q?5CTAJ8KtGxqv61E1XEO/EeE5RGNC3fT7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xjEED8Uch4s6xRQLz9IBDw9Wz35232mKNgUGbmtRGWGeQzH/NRUWfFjOeOdu?=
 =?us-ascii?Q?aeb1mvEHvjB1u5z50GV/wHHR9axlRXgCXActHJRvpDByYQBQzsp/Ff/Jcdq7?=
 =?us-ascii?Q?4OdOG8I/rYGaTdHJv3u02NBxO8xbYbcS11JIofkRBtRiP2aDqHNpOS4UvWBf?=
 =?us-ascii?Q?AHUR8nJRhiSkge7lwDp40/KxyYOknrZ419bmvdsvfeJUOlO/uSbIvSbXxoFv?=
 =?us-ascii?Q?AHPtDOhycdeNMWEmPppHS9voj5oeH0dtuvPuAq+e0F7Kbarj5BOOAsN+FMdp?=
 =?us-ascii?Q?mWtvh0W7x0GRL+a8BCupGHDaB6lJCedbQK77/6N//AX5CtxWFiN10ETsUeYb?=
 =?us-ascii?Q?BdiScbaCMu6tNyofFP4/0jr8OWKSIsT3GgY4y6ka0b8Wbdxb4cWzsGuIZ5HH?=
 =?us-ascii?Q?w457Jvk+c265tagaKUEKKYv9+/MMrNWXVbhjDA3XXkiwf3z/MtfgKWEuG1/c?=
 =?us-ascii?Q?+IEpPbPFVh+Sv073JAQoCzOZY0mqu63GzoCjAl+uiXpY0Ie1D5sPAitjqokU?=
 =?us-ascii?Q?ASBYTbJ5F57JHXrOKjAFvCS0rQf0NrjfnLndVMwLTe9x3ha/MIJK/dIWY443?=
 =?us-ascii?Q?RrZryfJnGU9l2w1Mwcie4H06yfL8AaYsxD+XSuBjy6JjEnSO3Srdv9BlvlTU?=
 =?us-ascii?Q?8GoRIiQvmD+crEbX7PQ18VZkf1n7zoHTtMTep1TKj2er3T2e29EW2xCY8PgW?=
 =?us-ascii?Q?uKFQC2iv5nv7+KuFa41Bi5JILvCN+qZKWihNg9IPQCJokDIFQMgM5XirnuRy?=
 =?us-ascii?Q?5QAw1LGN797SHjEa4QRal9EdmV4GB76nzhGpSBd74jrZuuxhKl/MJ9KEND/l?=
 =?us-ascii?Q?QWCek1kWqi17nlsX3hFCmQBxfdWY5HfSgUQ/VRDho6KmbieXrsfIJLspSM9y?=
 =?us-ascii?Q?Vlvj0ZIyucLrPA0eTApcZKRQ9cFHKZhrVT+LftghfqUa4S7KJhEynfjlIhHl?=
 =?us-ascii?Q?DcUkFJRexMm51LtQgQ3viEwRRCT1ikbGemMNEgsTlwjOi0uaVj2If2uOYN1e?=
 =?us-ascii?Q?IxGGDivmCcy9hboOJ91mAFGMtlK3cMJqrtT7+AQZEipKWWilb6F5odmRFwUN?=
 =?us-ascii?Q?w3LreHe2cquR+MOTIdzltvOWRgHMpjd1ydgLw3UA6p49QJcDPPvt6JFTliuj?=
 =?us-ascii?Q?zAaMd+V05E932NvKeNl/Jr9jZaRyvFy1nOMjP1wP99iU7pq8loPrmPAJ0lcG?=
 =?us-ascii?Q?PtUJbZ0Ahg9mxHI2vOSzpdH7P9v5g5ow874mP/Ez5rzSxDC8mDo2OMOO20HK?=
 =?us-ascii?Q?+2oJgr1RCphrXCkv/jrZrRyH5c95QeNtnC6qu4JmfQxH6rWIgtQ4x4p5OcDz?=
 =?us-ascii?Q?CIFbKDM5TconvUzV2p4hdbMo/IJ8nrHAgHl26660bKr1ycgMr3fndgIfwchG?=
 =?us-ascii?Q?MGibExIRyMPS2RxqXrvvsgQVemEDF9tvvKIMj913QUY9PhUIaT1eJ2HLxiGl?=
 =?us-ascii?Q?vwSw2RdEdgZvRl2xa8SutSl7MTcttVXP3fB8Co3uQgiLNo+aizO1mSFk3Qq8?=
 =?us-ascii?Q?OjdI3COgo10glmIwClyxeZC76FpLt8PpA8gkA917nrCHg503+aXBUl95zl1T?=
 =?us-ascii?Q?xtOAv2qOwb4fVNl/ajQtT07WwKqA++r7PPu6nh5eDDl8l9Y78rODvbkuaFiW?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9e63180-5fc0-4c33-3e3d-08de1cb9f3bf
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 22:23:31.8991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQhDmPwqYr0fpsj4GnBFFk00arOqI7DQ4NGaHVAceC1OAPMWV4yHpS1QXo5GhrLFN6DTgA3bwlPHtY+tUYhY75bO3A0KHAtDoP5Hlyh++lk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8377
X-OriginatorOrg: intel.com

On Wed, Nov 05, 2025 at 07:47:08PM +0700, Bagas Sanjaya wrote:
> Bit 31-30 usage table is already formatted as reST simple table, but it
> is wrapped in literal code block instead. Unwrap it.
> 

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/driver-api/nvdimm/btt.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/driver-api/nvdimm/btt.rst b/Documentation/driver-api/nvdimm/btt.rst
> index 107395c042ae07..2d8269f834bd60 100644
> --- a/Documentation/driver-api/nvdimm/btt.rst
> +++ b/Documentation/driver-api/nvdimm/btt.rst
> @@ -83,7 +83,7 @@ flags, and the remaining form the internal block number.
>  ======== =============================================================
>  Bit      Description
>  ======== =============================================================
> -31 - 30	 Error and Zero flags - Used in the following way::
> +31 - 30	 Error and Zero flags - Used in the following way:
>  
>  	   == ==  ====================================================
>  	   31 30  Description
> 
> base-commit: 27600b51fbc8b9a4eba18c8d88d7edb146605f3f
> -- 
> An old man doll... just what I always wanted! - Clara
> 
> 
