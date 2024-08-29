Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DCC1AC8A9
	for <nvdimm@lists.linux.dev>; Thu, 29 Aug 2024 16:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724950568; cv=fail; b=CM7u3CDphzFCDn7+CrQUoY0qlLC/pY5A9VNH30E1jYuksnkf8EvMWUB5zqBydrFRNRVVtq19VMmalDx04cJYIhYWldpwv4m5HlXK0k7Pdu7aluExOlk4+fFs7Ex8et8wGU0nt0qms3Hpt11wNxI+CPHb+e0ppqzBjtiESO0FNJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724950568; c=relaxed/simple;
	bh=l3MZ8zIfO6xhLn7EL6mLwExZsTQvGiaZRS1ZFMrp/qA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IaAR85O2aaGroQLQN3MNROlywteg5V92qG5G7xSgwAy0sEsPpkwhjP5uvhfVdHEVu9V/Rw4S6z5nfPqRk8m/4Qp9zF5S1T+XwfLtCscnUmCu+wfM2hJNivAWyinrNaR+suqICD1nn7pDmaQduLakDO59VlJGovuZ0/uu/vcm0I4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WxS8z0SV; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WxS8z0SV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724950566; x=1756486566;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=l3MZ8zIfO6xhLn7EL6mLwExZsTQvGiaZRS1ZFMrp/qA=;
  b=WxS8z0SVxC31c4PUZuiCj7A/PiwipDgWdr6Lfiw5l5VOF0Id6+Ete5pK
   1DmpddyhiC01NbEA8k7QZfR8XkI2gM9a0zhXD6DXBM0kBKYu4WT2hc28L
   qVmke6JQTTDii2HDABD2HGgO42vvhf8ZrKRqgRgbdzYaFlVaBdD0a+11E
   Y7YOaYWCWRNw4en+ytuXBxq1R9IwxXFsZ/UmLSIpuebygfGaPQwtAY5Ke
   //8a1uKbElSvqPRzLNr0FQytD0iU7m1m0Zzk5BZJAcMOJM8ijRTlWdWm6
   Vdb+91PpIUXYvBrARy12hHS0yMA14ZZTyNGuRyQc7myk5TJRG/XA7IXoD
   Q==;
X-CSE-ConnectionGUID: wrloPAODQbmuc9JSr8YSGA==
X-CSE-MsgGUID: vRXKAL1yT5yFDKFvaLmTIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="41039218"
X-IronPort-AV: E=Sophos;i="6.10,186,1719903600"; 
   d="scan'208";a="41039218"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 09:56:06 -0700
X-CSE-ConnectionGUID: 6kTbVmz4RO+b3FdlPWqCVg==
X-CSE-MsgGUID: OT8zknXLTcyuj/uI5LRvjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,186,1719903600"; 
   d="scan'208";a="63626723"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 09:56:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 09:56:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 09:56:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 09:56:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jOtDE+uqo3HfV4zdHWo/HBdotLoj94Vkm3G8O5KqdKs70BvievFPn284xXchXvmmtKJ0UXLXW8okZwrioWjdmOEP/1XarAj6pwoXP5nKUsFSSyUezR29l42MMyd0G+4VpCYeTLZUW7ngzO4upjpVgJBTaHpXo7TWi7PkYzR/Eh5KZmNcsS4nEb6A4rR9FN9ZLYrQ34ufpOWm/ml7IvOAR/X2W0CtJUHMRhIhOT1w9VljRx/9+fDa1z2oxtXPdpCGUjZ7iZvKh9mNqj9ljfii00+h2+qHj0JQMGxMk8+gtboXSw1kNP+0mtY4Di1c3RJcKlsVKIXpaO/IG1t52VuzcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/zvrX8L4x0meU6bBzKHT9qweMHEDWOZ0d+XuGxHCto=;
 b=EUMq7eb4N986qCKGfqbe+zep8X+rBaTltB2WQbrtLryeRdGGSPv8kuNQ364OSazisWnU9wq8RpD6wS8qwAQ0lF0HNKvcIrs9gn6lvhNi6UkYS0Y7lAIF/mqh2PCzrrk7RO8OPCsn04z6QmTA96LzmNyx75y2J0fRuFefpJr1q1k+a/hn3+jxinJHtr7k/dILwMBgIVozgalqxRTeT5D6I4jPWQ3vBqxsT/Mb0xAxKDvfNW8M1GEPRNj2Q2gJPtaRXTPoy6O7WNaUtO81/XhcaRzOpvXz19NIdZ7rEYIn3CANq0nXiEw+cpmNntDm+5hzXjvXvmS0iVsCWicBP/Gowg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB5951.namprd11.prod.outlook.com (2603:10b6:510:145::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Thu, 29 Aug
 2024 16:56:01 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 16:56:01 +0000
Date: Thu, 29 Aug 2024 09:55:59 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>
CC: Alison Schofield <alison.schofield@intel.com>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 2/2] test/daxctl-create.sh: use CXL DAX regions
 instead of efi_fake_mem
Message-ID: <66d0a81f531b8_47390294c7@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1724813664.git.alison.schofield@intel.com>
 <519161e23a43e530dbcffac203ecbbb897aa5342.1724813664.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <519161e23a43e530dbcffac203ecbbb897aa5342.1724813664.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0061.namprd04.prod.outlook.com
 (2603:10b6:303:6b::6) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: 04f8baa6-0eb8-49a9-f3e3-08dcc84b7675
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?IzWvFTQSpOSYrO+7h40P2w6QkBf8fXQrhQPbnaIZxo1TWEwx6iwHfqncSnLM?=
 =?us-ascii?Q?+8r/1ip7I9hPHIxnhmpLWNIATbV6Wp0lP7PK31VPLIpiMN7RoWvmyoq+ZvIy?=
 =?us-ascii?Q?XdHGU1u3RydMBgHj5tFy3iuNkWb0FHWswoXLYtgc1oRbEf6HDz865Ga+JjG2?=
 =?us-ascii?Q?+EoGZ2vPaCP0qlHJdJZi7Bvp2McpCmLHfDptf1yRSvA3yJtASDIV90nNoXhW?=
 =?us-ascii?Q?umzVDajsuO/P/2dADMnlKkZ1YHjigfrGeGF6Xn6Xe4ZaGrDCP4qvDJSAkWnZ?=
 =?us-ascii?Q?uZXgfXmWn/RxFWIk1qf0et4g7ONOq7FUUgRTFU/Z0C3SuF9HQ5yA/35porK2?=
 =?us-ascii?Q?U+MoqHWA3ij+/8DGRe/yWXRah46LczcyvryVDKWujM+Ff0bad67OO5S9C0cL?=
 =?us-ascii?Q?SpW9XAunxQlU1EzgRMDnhl+DW+4Gd3x0De6qTW10/DsRTg7DHnpxVjmBojTu?=
 =?us-ascii?Q?WzZh9kYxUQ55Q5gDe9pDSrni12OU17tisBlMyY4sIrocTTDH7HH0y/S2G0+i?=
 =?us-ascii?Q?NxckEaglzcwFTM2XDTgNXgWwrWDT/gQp2NO+b1rfWhen0V23G5B4tuDExW+9?=
 =?us-ascii?Q?leWsf12AIFe7/lxGX+EdbV6SZUHrd+EFA3MqIyyTkX/L46co+lhHwJMJVqiz?=
 =?us-ascii?Q?cNMQif+pwmyjklHKo012H3nO60U/56kSADzra8VjfC5ux3aQ4IKED7EE8epR?=
 =?us-ascii?Q?nCDpnWcyEUZlC2gUtjqmgyFTMQAOKZpX1BLtdijIjAs7neriv/zfjqJvUFne?=
 =?us-ascii?Q?ZDKdP25nyuzveC/HFTxRQnSjPC0vY1lrWG4BvgOSKbFczmoX6+zyIPjezdfF?=
 =?us-ascii?Q?xRoh+N0utk+t3Lc0tEZDauMFEPrRCwuU4TiFSxQSsgtgQoCKQSjYJJV/kCsE?=
 =?us-ascii?Q?UNqRZMo7D21f4OD+4z8uQcb2O335U5l4ugQzjYzmolv05Sk5fE/OUym4DN5v?=
 =?us-ascii?Q?HXqnr5S06Ok9LQ9fk5vQotKbyvtoZlM3MoV1Fh672DSR5r/+tdoqBxRA+l5y?=
 =?us-ascii?Q?rdHBiK1aduAH4gS30VFqAWVAHDSwWvQlu2YmMGEW7kbhRObrP8cvtGoB70us?=
 =?us-ascii?Q?gjH0L1S7e9AabySuRYumcSes+ncGocz2mMn2yAvVmaSa4FEGZEx3R3P1q5Va?=
 =?us-ascii?Q?GHkWALOsaYvLI3jtMGpEhmto1aBNcGEzsKELTeGK22odrTiFuHh9B6gjq4Fq?=
 =?us-ascii?Q?oMrIAYVuuU3zu3XQiv3f6wVAZ4OT37tBsH6vJBFsfZKwDufnhNLJZ89Q7dl2?=
 =?us-ascii?Q?gbSS209ynGjdGSqBJA8bfO9cMS3ThQ3Mvx8PSjK8HcUtcO6QBmD+56hAPQB+?=
 =?us-ascii?Q?ms3ubE1TTLidf8W2l44ULGuUoI79zie2dafi1E+80Ee15w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zXYntnNb3PlpHsypbaVnopf+vF1tf+yMbjHVe5tknEH3fErnG3Vjw0IQJooR?=
 =?us-ascii?Q?AN2KGv+Nm+C7iWWgz05xeT5kuO/a7Mooqq5xDfVT/E+6RkrAt6ZdMhyQrVpp?=
 =?us-ascii?Q?O6vZGM0dAuhGKVW3SXmWJOiRUDsBpK0k7Wo3q4trtagr5TaJ/3sYsxAJVMmM?=
 =?us-ascii?Q?RPZSgkMB7xtgCX3GSWrEi/hq5V0H+b2cXnY9FK31q0ZAIK9VWfPRdnGsafyC?=
 =?us-ascii?Q?nyarkoh86GaeBjbDskucw1shRwg8kWQfFJuAyunxxUYSI9+U5OFhM38XDR+0?=
 =?us-ascii?Q?+kcaS7Lp6Ke2uWZX8YBzw6KJd43EwLAt794DSbXKobKHPR+sn8ZRtF75HkeS?=
 =?us-ascii?Q?jTve0Fipf9v182x25vvvKxa459HibDvEl/BADO2HWTG96geoTy8VTQ9N6tRs?=
 =?us-ascii?Q?sKi61cMqXzr0Tc8ZJ29T2etADhlZzuVzJ+pHjDF4xisvFxNrvl4JxcI5GQeQ?=
 =?us-ascii?Q?znv+nWeL7ef/qHVg3CFvPl60Cxv40kREDBOTeoqhnWSYdMnm2de1xMiQ2fI2?=
 =?us-ascii?Q?9DN1P/ryKQ6XiFUc8lHAt4T27doRfK4RrwacJ0kcR2N0yUkkxPnq2jLBEloF?=
 =?us-ascii?Q?fWGDEmJup+UlbBeZzaUYdiPnAnustTUtiyBpk9Wrb1algGgGmtfgXIFeQMA+?=
 =?us-ascii?Q?tXNNv8aymaKlvRt4Uerl9z5+1UKoykym6dFNrKwID0uIowL5D6Iv9NYxN4Su?=
 =?us-ascii?Q?pahJ+SG5+v6RrmJCRSqQKPqHmNrvZ4UEPpGt7tDJrY/pu8e4ISzAY1FKzoh+?=
 =?us-ascii?Q?vSC0yfTJVgeEzvjkmnxQoXi0wcd1Q16fp22z+nkb14H9Yt4Xo0SWrwKVsHpv?=
 =?us-ascii?Q?KQLpSgljPWJuQ9PZiqikWB4gAqD4W7CtVRKZayzj2TPedKxYeWsJO5gJ8M0t?=
 =?us-ascii?Q?9NnZ+vNzEb/vmwNVTzLoCkIh3MuU2Bf79+dx+iBXjAZfL2PhJfCHA/ak89gU?=
 =?us-ascii?Q?T0TMf0+Yw+nrtAjCO776kYWjxYt6VrTzfC/CPDQ2nCxcFQgCdM5+8VnKk6UD?=
 =?us-ascii?Q?Kmfxn+rodizcvRJC8WGNTh1DhUP6b2UodNgqhE7enfA4WdEoA9FAN5lEN3+x?=
 =?us-ascii?Q?+bUij9CacGMQR/wZseqD9ZLJ4Ran0M8mrOJIc8WLqjnkT/zIwq6uaN03beKY?=
 =?us-ascii?Q?vlDST/g7jDPWoCAbtG4yEi4yW7U+T7AQvZcbqIvTfsll3Ps7M9zAl2mOq2hb?=
 =?us-ascii?Q?LRIukkXopMFwAYhG3dCTpPMFNiBEBVVSyvgCex+yCEhSeEEZfgitnM+i3Tkf?=
 =?us-ascii?Q?clzbMwJA2hvg3d1Qy+DNrM/Yp/eDCIYoBkX7HeeXaiOZxTRPWE/9sO14z52o?=
 =?us-ascii?Q?5YRLmUs6Nl9rPFeFkd/jg1WJmCbgcooEk2h9gX68oDQmREX/6LZF9k/F3l9t?=
 =?us-ascii?Q?8Rt5A0zRjlWM5k81Tx6+o1y3jr4ojLqu784QQW/xw28lL6HFC7kx2eOKhWkC?=
 =?us-ascii?Q?nk61w5bKoSBoE6hxzus8l+h1P7qDsqPdV9sR4tnTS8WlHUcEdkcKxwwXhO/P?=
 =?us-ascii?Q?oqBSLAnaE9NU85xrJ6EIc7eEY5MuILJ/puHEFNrC1JaoPzxb64G+teLYiey0?=
 =?us-ascii?Q?BPGvGYs1dneqys4aQck3S+wWUXStkErcSoHPMMH6avuvsVJU+XC/aF2abEys?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f8baa6-0eb8-49a9-f3e3-08dcc84b7675
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 16:56:01.6616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fPgAUDwY33ZuAVYD5YvCMdCDdsTb+oL6q5CPBHZeNkAOHXr8B19io6LIOLw1vMQxoGZiISeUGtbngnufs+eVeKEqFh7M9+i9FXy32tLeaI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5951
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> This test tries to use DAX regions created from efi_fake_mem devices.
> A recent kernel change removed efi_fake_mem support causing this test
> to SKIP because no DAX regions can be found.
> 
> Alas, a new source of DAX regions is available: CXL. Use that now.
> Other than selecting a different region provider, the functionality
> of the test remains the same.

CXL looks like a useful replacement.

> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  test/daxctl-create.sh | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/test/daxctl-create.sh b/test/daxctl-create.sh
> index d968e7bedd82..1ef70f2ff186 100755
> --- a/test/daxctl-create.sh
> +++ b/test/daxctl-create.sh
> @@ -7,6 +7,9 @@ rc=77
>  
>  trap 'cleanup $LINENO' ERR
>  
> +modprobe -r cxl_test
> +modprobe cxl_test
> +
>  cleanup()
>  {
>  	printf "Error at line %d\n" "$1"
> @@ -18,18 +21,10 @@ find_testdev()
>  {
>  	local rc=77
>  
> -	# The hmem driver is needed to change the device mode, only
> -	# kernels >= v5.6 might have it available. Skip if not.
> -	if ! modinfo dax_hmem; then
> -		# check if dax_hmem is builtin
> -		if [ ! -d "/sys/module/device_hmem" ]; then
> -			printf "Unable to find hmem module\n"
> -			exit $rc
> -		fi
> -	fi
> +	# find a victim region provided by cxl_test
> +	bus="$("$CXL" list -b "$CXL_TEST_BUS" | jq -r '.[] | .bus')"
> +	region_id="$("$DAXCTL" list -R | jq -r ".[] | select(.path | contains(\"$bus\")) | .id")"

Might as well skip using cxl-list and instead use the known
platform device hosting the cxl_test CXL topology: "cxl_acpi.0"

    region_id="$("$DAXCTL" list -R | jq -r ".[] | select(.path | contains(\"cxl_acpi.0\")) | .id")"

...other than that you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
