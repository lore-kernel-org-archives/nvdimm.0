Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F8D2E7185;
	Tue,  4 Aug 2026 00:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785803118; cv=fail; b=koEFmz20GQ4CiItx3gjYqbX/90gN9JvKPukC+9DkJkPCFzXZgRuvuKMHRkG8o4EtPt016EmRe3ezfL2EibF0cEEBVNCEh0JcbgRzSW8ymmMnAz24XfuKaaY7vavxO+CJjvnXbUVaeXOwIFFHDQWAgUFG7iRXPDgm1L6yxmrh2s0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785803118; c=relaxed/simple;
	bh=Q336knBeqpYDdYYUsGPZ2WaJnZsUnUwLBNc8R7Sea60=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q0/M94tu6MHtr01KmAF4IH3gMeoDM6hdZMw7Cw7f1FslLv9TV6N1HTxIz71IASE4HYqbJQXygZUvPI/ANCmvB5ZYUWwRVCIlnvbDDjIvtVsqzOF42yLgMcar+HU7gvODgSS4bpL2+xRLSUjdcWLfH5yOtuNOyu6Q+0C/leVneb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ltLO4mgJ; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ltLO4mgJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785803117; x=1817339117;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Q336knBeqpYDdYYUsGPZ2WaJnZsUnUwLBNc8R7Sea60=;
  b=ltLO4mgJOfbJuiYP+ecbeJ/OiYrsAH+v7Wdc7xg8NsKIuPTtQB/eHbIt
   pQVxG7XogXMlnypvJvq8vSNB0V7TAIlM25MP4higdHEljT2HOfG15bp7k
   EtfSzmIRrSTeAdWwrahWGU47NSEM3cwq1FPaLTIhTtMEKJ2eMuxqI2Ibu
   dR5yQX6rWd2zE5T5egvF6RXpZx+Tf9ZjpPM07fnNrPUJ6Eo32KES5iknR
   EaIvYyhV3cx2GgBIsLLW8fbXfQfhxEq2XsSHFnZc/sWX8BvdlGRe13zT3
   w6KYi6dC4B7JiOzbSc64TbyNbHG4sfKaY25xDNy21UVFHqDM5TZvHVV9n
   Q==;
X-CSE-ConnectionGUID: Px9uxNjWQwOXiV2KuepUrQ==
X-CSE-MsgGUID: yxjKARrBRqe+Ijof2w/gHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="86546068"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="86546068"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 17:25:16 -0700
X-CSE-ConnectionGUID: Bjyv6ka/RyG253BqatnTNQ==
X-CSE-MsgGUID: 8LnSN4NqQD2sI9Ph1IgaDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="260758147"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 17:25:14 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 17:25:11 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 17:25:11 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.10) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 17:25:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P/Yz6fNWCx6ZrO0/gVFFIDs1QyFI/HFhw7ualkEMFNTs3977JY8StWtVQbKVEJfcHNoRisHsI1WHNy28EnqgZ1Fw06QQB5KselqyCs425f+XwKQ24M4SG4D4DmuXD/k6ahQdP2XaA9Cl+4pfLh7H9mTMi1Jtu+XWXgrd1pUf7O+VnmxfurF6Br8BMUzhciBA6PKKPms9ULqlYKT2OyoZvv9uGYyHjL0LlCvPoxPZpldveORnRlbjeA3gDOS/TxBqhj0fvwoKNOJSqWQoejPT5aPHnAtm/xHfLMDV31Pxx6aS2do2NTRLB7jf2JdzAdTnZD3+UixHLbl8UO+VL7jiaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/k5jMmPVcCP9tUGECmFQMorp42fny6RTzqqyr53V2fA=;
 b=YJxLF+my75pIj2egL0qPsKdXZzdrUwfq332uF2/SYqhpL/Jsq//fyNJ+yX/090U7KNZ6VXfd194i+SPLytAO05RXYjXoIrMIVMWJiAcLR/jnahTqP3bVDxaKEWbAQ4QmCpwoAkb9XVxq3RoiJTnni2hJh2IuF/I1oE0bowzkFTfpS0P/ox3JyuuBqXWGxz74GeX8J0S5PO9JmSumEnEeQv5tdoMkiQvNRDGQYPLS0xuY/mIzT2NmabuCEtoVK7l+3bWaqj8SGF7cMHi0ofIm/24pOLrxBnnuuCegb1T9SHPJ/J4ZEjnPpatVIL3bp1y2bEal76SC8E8GtoftSlbk7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CH3PR11MB8435.namprd11.prod.outlook.com (2603:10b6:610:169::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 00:25:08 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 00:25:08 +0000
Date: Mon, 3 Aug 2026 17:25:04 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <sashiko-reviews@lists.linux.dev>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v12 6/8] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <anExYCOu1n0RnYvh@aschofie-mobl2.lan>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-7-anisa.su@samsung.com>
 <20260731090444.558491F000E9@smtp.kernel.org>
 <am28sIX7a6Z7QaXr@AnisaLaptop.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <am28sIX7a6Z7QaXr@AnisaLaptop.localdomain>
X-ClientProxiedBy: SJ0PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CH3PR11MB8435:EE_
X-MS-Office365-Filtering-Correlation-Id: 69ca08cb-8616-4209-c41c-08def1bed68e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: rkhsWq+IXQ/wmoVl3GyUCLnHwhRUKFWYN83i1tfgeRegQ6iuso5BpUT2IBPIuPJprzGpWjZRWwxcaRsO2q4uQA1WR9Yfaj2qH/S5VacTcHpAUVOqMD2lFfrBBZvQyliRiKG6UWlbqU6LLmpNGZQiZ88mE4QcmG5T5W7Nn8kORA/o3D5EnSPyPuQXhoB+WF2vDUqF2y7b4XS+B7+09BzFnMmWyJnBm9GoLciRoG7XjtnlZscVongG71bkqJHomrP2ZBWa+lOx2Rhvof3oXyck+HEuwERyXLZawfbjt248EiLwAdQe+c0yVInq/df0i9qAleTTEP9ATD2eDSjA00qkCWjPQ4R6gJrWyCKCOCJV3NvdYRQaKCF5iCBLIFFWMauFoimFtdGqmeWfl5iBppye4yffGb71FG+wzX4TyIHT+aNusJjcSXijOgBbFZPV42vCkOeuWft5QOr3AHXcZ+h1IfPOZ54Zn75miUO317CUjR6J5FBxe5GjYxW2lN1gYXJhUeXoclBC63U+nYML6UKYawh/Vr0MnJOkfymFiGxPeVZq4uJTtru3R3mWZNXT5vyDVw7f6zbPXVvqrNWt/ddQ+KcYaVKhL3/r0BV1XrzjOM9R+6NWeUE2PZ4AtdQjL6dIk2cjo61StU47R5XLqZj+97jCYkBPHU9ZWoOYFjufpdI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WVPrDSx6fvCJYz1pDE3jb0H3PvPZleSBxvkvC5XbvPfEzEBd7iAKPFv2bo9/?=
 =?us-ascii?Q?ZjYB9CsPLWRUBX4TVflhwpE7tKOyzqzGZTrTk1mzGjamb0DYFzqGY5nX0Sqk?=
 =?us-ascii?Q?CpwJ6Zc8f3VH/wTWIlu5OXW30ha2JEAtDk4upBlfoyLZ/8pnCGNzNBhIrhCG?=
 =?us-ascii?Q?DXIGOO5BSzsFTylX7iUVIYcEfyD9OEUvZLP9E6yj5uBj3g3qR1YOwEUA67Sq?=
 =?us-ascii?Q?Ns39xR4Qr3miXmaoU3QQiKEnTt09RCQDsxktY5Y2tnMEcHE0y4ujoI8810+c?=
 =?us-ascii?Q?ygWJAFQ54+eqoNojfKExGvmhaLWJ0I0pB0E3QoT16gDF7pVUeS3U9BQgwZnL?=
 =?us-ascii?Q?ro+kabCSL2aGRxUWWtNVE59rgQGQkPj8xqdIbFJGRE6aPzOZQOzV5O6LKoXG?=
 =?us-ascii?Q?cSh7KXM9jUFLrSDgAUGDa8ynOqCm6zwzPNkeGV9yGkhslJT/ejNi9D6zvER6?=
 =?us-ascii?Q?K9v/X4JNvyaHyMwVSEHqfITroIzLd7yeD1No5CN3gC/JtMjVCUhMoVC74B1F?=
 =?us-ascii?Q?3U27Nri5gtmttMN2MBKVh43nmFIJuPA1pkpjvswzbsWtMHPakFIBUChfqJYG?=
 =?us-ascii?Q?7u8i9MxTtCuT3H+jIL1MAVUa1VomZM/6ru9sZ8DAmZgtXjzAJdkdqBkMSLGU?=
 =?us-ascii?Q?L4XxnFG5LsrYiGVqMg1F1kuj7qYZoc6XC2/JUPHqEzWFwq66CSwLgLkDf70U?=
 =?us-ascii?Q?ftupakxsevPE3qMOtFLilkZFEt8geDQiWxzkPo71erX65V01d/ccaxlP216L?=
 =?us-ascii?Q?/ubJ7sJYDDUS9iPxb55mEXQfapWpz308qrgcXb/RAlo1QF7eRnRuUzl0c0Br?=
 =?us-ascii?Q?yVG7LXuZArkJqHj2tFmtXQyEK1qXltz204I1Hk91UFSFrJoH6ts/C4H6BHKX?=
 =?us-ascii?Q?r4dj0taQDuEl64ZOm12UrpyxWqY4AjoM3jhSLZAOuBiI1G2Wu0JaIeRYUrIe?=
 =?us-ascii?Q?hhaoh5ESE6387tiYSV8wqev3N1g+ZtQMvzMZbypSavcilNyQXuKWcv4A+uq/?=
 =?us-ascii?Q?6xAllHn9U2or8HAdd1xXouAtXXWRN6nnpAf/DWCwuKcOzsm7lkSrzi0HRp57?=
 =?us-ascii?Q?nvtz2BbjLKi1Sp86xqoRSw1v0l1U2xQHuuJW/1SvOmcFrrXQ4r+0lUyMRkVG?=
 =?us-ascii?Q?JppUENuSNcnrgOev4FLgGkgkfuRnitTK5XHkTeRRWR9jF8NwA3viJPrent/n?=
 =?us-ascii?Q?7BkhQHTtftOWaB5SpDfRxc2vZVMJrY1X/FUJJxb+mLfKevEUwuAtfq+L+2zf?=
 =?us-ascii?Q?lkrlRZVpP2C6Mqapw2EQKdPmxay+koxFDOEJHPbnrjyKYrSciEOqruZcoE3+?=
 =?us-ascii?Q?8EISXTi27RL+u3hd2w86Y0cT9Eik8Ucx/qCnnB6w2tnly4NjRkHpkYQg+X8j?=
 =?us-ascii?Q?H7hgYwEyGYe6glzAso9oDSQTNmai6NnB7l1GklyWD196rPDnYGMiDHhWx/pL?=
 =?us-ascii?Q?optsrcZhGX7sJowjXET36BzjDxGh87H+2Tru4esTPsmzvUAfZR7Xr98ywOBH?=
 =?us-ascii?Q?241R6PcX7cLGDX47vdP7OzIcKQ3uXTG1mPtx7pmD3UilAsfed29LemOHi9DK?=
 =?us-ascii?Q?MhpU2xGB0yq6NlBGwYYeAxxwaJY/TxKmVaq/C1F8+5/3TjlyKXXCzvc3yjg+?=
 =?us-ascii?Q?DJRdnjhVXqd3wy+PgKlEFSBwI9L9l32d8DBc955fOLZQb+iIG/0D6gwx8PXN?=
 =?us-ascii?Q?PV0FAKsf6TJgVxwwjqJqrOpZaGGCGdJQMfS+A5ilGHXB4mC9CUKSMC5jOEcD?=
 =?us-ascii?Q?JIEvKYF/2VnnSwC8y87BayEOoiVJ+RM=3D?=
X-Exchange-RoutingPolicyChecked: ia/XoK5JKp02vdAZQoQwG7QGmrAeKWQdVbdceEK23eTyGatGjYExTqLv5tIN7M+S+D6kQk1RLWxa4Efua6C/QvSln70UHy7w8cVupGSCsmW9jaocaRnrs6lY3iVBLozyOsFjq+a1PPF+r2oFCbwXZRpvhWhcPjllJs9jgS7CwwYOE/GJqayq5PgdYRoB2fmW0MRcfVWCY4jqYX8h/Ch7UIRnmiNwSfbAeJUPWK2rX+bkg7QUFpKGpN1pivBpZ/sGYJiqmeF26kEgfGHbLAkLjHQwXZ9jO6afFyNv6oXskmoXS9M23dDcWgJKbY5KGS5ahV8sA5TPv5lo7TRt+8h+fg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ca08cb-8616-4209-c41c-08def1bed68e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 00:25:08.0826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bA4LmVvUOJ1darbWUM4QZYt9ZSTlcutwn5s4Ku3fOh8Z5oKS5RJEXwmeFqsA9cy79K3RDikkl1ZhWdF8fTpGmFOeLX8SlXrRYl2H2me1eeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8435
X-OriginatorOrg: intel.com

On Sat, Aug 01, 2026 at 02:30:24AM -0700, Anisa Su wrote:
> On Fri, Jul 31, 2026 at 09:04:43AM +0000, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> > 
> > New issues:
> > - [High] Infinite IRQ Thread Loop / CPU Spin when handling DCD events
> > 
> False Positive. DCD events are ignored because DCD is turned off
> (mds->dcd_supported = false).

Hi Anisa,

I have related review feedback -


snip

> > 
> > [Severity: High]
> > Since mask now includes CXLDEV_EVENT_STATUS_DCD, status can have this bit set.
> > However, cxl_mem_get_event_records() does not appear to handle the DCD event:
> > 
> The mask never includes CXLDEV_EVENT_STATUS_DCD.
> Above in cxl_event_drain_mask:
> 
> if (cxl_dcd_supported(mds))
>               mask |= CXLDEV_EVENT_STATUS_DCD;
> 
> mds->dcd_supported is set to false in Patch 1 so the DCD bit is never
> set.
> 
> So status &= mask becomes zero and we break from the loop.
> 
> - Anisa

I understand that dcd_supported being forced false makes this unreachable
today. My concern is that this patch adds the DCD bit to the drain path
before there is code to consume and clear that log.

As soon as a later patch enables dcd_supported, the bit can enter status
and the handler can loop without clearing it. Could the DCD bit be added
to the mask in the same patch that adds the DCD drain handling?

-- Alison
