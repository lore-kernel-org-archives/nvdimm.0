Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C83B2EBBB9
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 22:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786661515; cv=fail; b=IrAX3bRMHwzomRZzJjebVGXjq3CwS8z0vgFYKmrZnqU+ZdNKKUq7KKnQPl813N0mLBRogRmRGnoU/PmcduApYG2yFC3IUKz+9y7jLWV6Cc6cUGsqhaNN+TwsUzPLY9WcsYUZPRca/jTD/LUxuaN5fHEXcOhkd5z907+Lpm6DLKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786661515; c=relaxed/simple;
	bh=C0hOzO0VpGzBAGI1PRfI1/J9ImE1ivrq7KW6O/PRuPw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=knobFtTuGgFH+k8+ntTlUU7lxGh17Lwhfap7d4z97vaGmnxSaIXXgnZdOrfJoKmjLO5IXdu+z0ybTjDDargHhuJVqynsiHafTQd6+l7VH+Ob1UGdBVnVeVDmc2/eoKStvPfRmR9YIh50mngee2sqrBiqXmUiu1/mOyarYtAEO0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B3d6ddp3; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B3d6ddp3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786661514; x=1818197514;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=C0hOzO0VpGzBAGI1PRfI1/J9ImE1ivrq7KW6O/PRuPw=;
  b=B3d6ddp3SXY86JMrGbCs3aefBz5ZvD3bcufDbVnqo5VAZzRCvm6Imjxg
   CDP8qNy/hhD5GVp2jzOXKgU3lzEEKkmxOTh3Cyw6xnvN1mgvC53aiYEBE
   /PGXVZCM+M1iZlTmjzCMQIuqRHGa8Gko0xX1i/NGiHxDGXkthZHJEPiuO
   ISSZRmmOeFhVvBI/9+ZRQqIfL0Z5z4UcHmI6JQ2SXBmJjQb0a/FA8Svws
   nYUBuradDiY4ZKu3Wj1Rhl3i5ytX7yNA5cLpz81eInJJn+5McVctwq1mB
   7oF+QWpHWGM99doEcNpHi5jDQHTn7iwvLKj2Ugb7a0P7EVozwdJovLI6i
   A==;
X-CSE-ConnectionGUID: Diog8UT8RgWnpCcFkKSmmg==
X-CSE-MsgGUID: cY3F9HOyQaujDrRklPi38A==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="87374331"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="87374331"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 15:51:53 -0700
X-CSE-ConnectionGUID: ll3KLogKQGabO5U8i2BWhA==
X-CSE-MsgGUID: 4w6m7oR/QGSgRbbXJ6BXVQ==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 15:51:53 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 15:51:52 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 13 Aug 2026 15:51:52 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.15) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 15:51:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e29sp9UffEuPc0UEGgY27lZUwp0neJZiG4JcC1lRkonAN0s08nf5EijO+BPo4gYOB3kA1UulabNj1dxJi82FdsX8vMd08M1KQLx6J2GWfcJRKV67WjN5yV2vkzWG/P8Rpw7zPO81ecjvmGnQuVapIgWLGo2KFrQ+xCVPuoWBqte+d5zqIlMGTxhY8vYGWAGdh71p1T6pjvONf6bSXHhZL7aWyA+sNTrZYG+u+ipeb9eyuAp/BuBJc7chTzG2j7NY2nD6EdCv6ygjXbAuLj7pFbWYSUj8RgXAhYQzx1W6Ov8H6wR/m+44EYeeT3bC9Pit4qMILjvT8wNISriBDVYxVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l45dI5KQgnjlGWwtwK5niUj2s3CNiaFDyulF0uD2BWc=;
 b=LhPEj9fIVg/zCaFIjPd+geSq5sX99QCbovXlZCUs9aZHT2YRsYA6361VS2cdZyOdUg/cUrIBKd+8eIaUicuGcWHxWv6jNn48Fe7Fkia4+BiTzB37W+KOM9pEfamjhvf9KyV/66UcvkJCv/JSbIJhoVQB04SApVgOLkey6sF2Dvn5pzP9e5oIch5m5+/7ULmwz2YfAnmWSxLZpUIACqxft1AuDy9FE43MdJ5JmOFQ0vl9C4LiZzA6FOwwZfh5HQliRWiQm5fAPw2WGAUHcQ+AN+msj+c2nvx5tyGoY3et05RzdszWghMILi77x8zxeZnR2mjXE0ARxPF4j1z7KyogYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS7PR11MB7835.namprd11.prod.outlook.com (2603:10b6:8:db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Thu, 13 Aug
 2026 22:51:49 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 22:51:49 +0000
Date: Thu, 13 Aug 2026 15:51:38 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, Jeff Moyer
	<jmoyer@redhat.com>, Ross Zwisler <zwisler@kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-acpi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] ACPI: NFIT: harden subtable extent validation
Message-ID: <an5KepVGGITAfr2M@aschofie-mobl2.lan>
References: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
X-ClientProxiedBy: SJ0PR13CA0099.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::14) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS7PR11MB7835:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aa9fad9-213f-497c-0c76-08def98d7588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|56012099006|10067099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info: hxH+9n5xxBunKj8EACmSv+kxrEHClalRPzTFyMBcL9qqrgCWnAdSzz+g0oufXzPDSd8gA9ZLC8XLpTMnJx95fj0BuorJYzD9EvQZczoFv+MT4bBb7DquiOpT5t6U3O/Eu9RyBuiTBgEaS9uGfV57MNjsN8SUAkVvxbGrQmFlHha9/XV57HdpcAvu6VTdx5zNU3d6Kwx3W6HYQjayWr8pSSaAmxvbJ3FZuj3FzIuk9KkP2EqCiXqtPDEBiBAqB/mrIeomTas8a9ICSzSsQ41gNSWEza+jNM5oR4vD8QWExd2yJyKzV/jTN96Gax4ElInvlT56TNk9QWONss0iywVsUwq7cMT2ItOs56sd4MM/05AXJKmUy7DTAlDK+7FpNju8j5uwCaIMbJcFM5lw2V/60BxIonyMGsmh6PDJ5uR0BSToqVl5aAw2TMOcV+8Ii07uVVKVuQvo83m7n/xT09V07FHeyWqbXqQRF0Z9e5DFV+dF48pOCahjQxLvscQEQOyZTl59ijePEO7kPSQykCvAr/ljvCEeZ2QWW27rGC2LcCtFRp497BCKgGfdgzsRByWtpA4YTu1N0s9zNKZhuAMOSlzgtqgndBDcCG+rlOgF8s2/QTN/42tLT/Xgwau2x7fkLPuTgghIJGy1geN2C/Clbv/fO8joZQ28l7Yw3vFF8TA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(56012099006)(10067099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C2JG4g7jeC98P45tnbNaDGcL5uLx/syEv9h3oOK6UYPCNeRS06UvIiQaoilV?=
 =?us-ascii?Q?hbztD92epO8fH4mc+IzuDVVv7l0QkQdborHa0OzYsEc+XDvEAj6fbfNfsEGv?=
 =?us-ascii?Q?kRUZAxfDNmLgjgdEGkLRh6fcYj1evrHjHiAtDyjLGgz78u15EFKbUi2/EaMm?=
 =?us-ascii?Q?R0vZQldoKS9yf4oDMOnUbPNCq0gie/2Hxzg93HFRvyMPkXDsvgpW1HqWJdgu?=
 =?us-ascii?Q?0A+1a25NsaSwyJ+dbBcDKKlDOgw6BbdOh7Em8aAUDz2z+Vk0NbpPk2SJaf3X?=
 =?us-ascii?Q?7JwUyJbjErq2Wmm8plFc33OIG2QbLrhYpiFfVCo+BEUn/26Zli/4jrIMVnU3?=
 =?us-ascii?Q?w11Iwo9b/QQ+2Xyal12tGVq5Aq166RUP0aWJkX1149Uvaa3dIYiBG/ljcrUu?=
 =?us-ascii?Q?oZI9fB7dPXgJsS8CouoKcUdTCrc9Y/wEaJELeTu199VZma+pKMHN0r54Il49?=
 =?us-ascii?Q?cpqsPrWy33wx4rJxQAot46E8+bkpyygvFnShYbdT647ZfSn5T4W7ijDQu3VA?=
 =?us-ascii?Q?3LlgmpYAZQrmyS4troVq9qVEZWFSXfT+cWukhqd2MefG4OvBeyDOzF1gzcZk?=
 =?us-ascii?Q?cC3oKZ8JwgMuRX2s1Sy0kIiwiU+ZQ3rDO0pYjxC4OSs4NNv3naIfZ3p+5Xuk?=
 =?us-ascii?Q?4mTQPm0neA1jjCXbzMx2DEsr+FX0Mg/VipD8KnBaHkR5tdB91IXfJSzlGlz1?=
 =?us-ascii?Q?DRZSz+6A/7FPkxj3JHsKAaT8BWe08OCNXcejvEjDiT8KJ3PbCOr8YpyAedG3?=
 =?us-ascii?Q?TUcIxgux4oqm540KLXrb5ifUgUq5d2d9ClHAkVF52YNKrnBQxHdzXkzW2r56?=
 =?us-ascii?Q?j9YtrR4FfqWdLWCj1VGTnZddHR8oHY3g8bvx/6oqNxT9/3YUaBNscDTjCQr4?=
 =?us-ascii?Q?WB/2cTsoIUO3CFOgWS4IgD8BaWsvmfA002yB8+JKceCUuhdsvLFgFPCXKXN6?=
 =?us-ascii?Q?50yGXz/u0VENljqS0pBOnMJzS/3cJs6vdVkKbDM3HXDB2fsK9Bce9s7qRtjz?=
 =?us-ascii?Q?63uBKGjzRvAkEdwYPiGQF03tC/V5qL58oPZvfdwEFRpjHi8AicO6nanUkV6i?=
 =?us-ascii?Q?xPhoUjpF0XQZ1VWNXs/tGU1EHoPI2COD1P/+XQvPyE3EQfx+yoYcwZyQMi3L?=
 =?us-ascii?Q?zjVcwqKDkjZSiC3VaC+MjBctDeFCWJq5Y/M9ySlxjR2vidPrnz7VYiq1KVVv?=
 =?us-ascii?Q?xnaUX8ASZU/jCw87j7jZrjZSIwg5AoLGtACxfFAvmZhMNooZ+XWzqGQwYPk2?=
 =?us-ascii?Q?SKUL/ht7Mi0Qg+1UnpwwtunoofTOIu3L+DcWpKDE6lbvw7xbyH5Zn0nW/WbJ?=
 =?us-ascii?Q?xtrMXuTqiRRahEPtpgZgFyVttvu142XBKMiZ8GQBzsx5x8FKQOD9lpHZRLEI?=
 =?us-ascii?Q?VyY1JF7xc5othnwnRsvUxT2RD628Uu+1OpQO2Z+oYhVSQm6TqFPsZAcMWvEw?=
 =?us-ascii?Q?nmJn/eCZyCmtYYM6vER4zjH9gh8vZYFBWQY7H6I5TecRimNQVDiTfB7hA1F4?=
 =?us-ascii?Q?Qd3gTrdCVWARI8CTbGjvonC7xuxmsW35LNeY8UdxcgfgZKDeHwG/VsPmlP0m?=
 =?us-ascii?Q?4YXbeDBrunDsH8McbvzafqoUJWoEU0y/3fdGcTnurdO6M53ePMB8YLB6oVPq?=
 =?us-ascii?Q?cVDD+TxLL7y3U4Tf47sMRAL82d7xaSC8zHTYvAS8K+/xzw7hzmUO7mpK5pKt?=
 =?us-ascii?Q?wXiyb1N9GsNDCpmNJ11teSdD3/ivZe2dimQcq/bHYOJncoWJJcc3BJ7oaVor?=
 =?us-ascii?Q?dcVk6w3It3LszOqq8jzEN04j97V6Ttk=3D?=
X-Exchange-RoutingPolicyChecked: EfpnR1xjDrYSaTsYEzF8kYuI5IuSbssGD8Rfdm/DEcmWbmzvHFDWqvZbMDfpAk5xKZbCx+vCGr6Ir9uLVaAbDWdY/n1u6zvxywbeO38PXbC9zDGROY/aF1oNyo7+o1KzvXPWhuSyN3SDhbRdD0TK8zO5aLDF/fwok9Q9uCrE6ET+kI7Yc+ufFy9gA0/Mm3s0k2R7JzueNJ0P0IQ2fqLIj0/m9Dol1ZKkqSQ0YPE6PU5i5wK7oW/Uwe1MSAkXkAoWbaJo24r9MC+YIxTTJRxx2z2L0kq4WF0HeGS6/JBGzJKZFCwxFaQwWqwPOcjWFY5gJl38CUETzVkm+BrXVMc0yQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa9fad9-213f-497c-0c76-08def98d7588
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 22:51:49.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KuBE5n8ywpRaITGFLTZTyIxdHG/EcN4YBVL3on9CKu/pjHPWELiNuoM/e8MT4Jp9jouTwZ8nhCNcdGsd10b218sj1DHlTsXIqEO1VdICtDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7835
X-OriginatorOrg: intel.com

On Thu, Aug 13, 2026 at 11:09:48PM +0800, Pengpeng Hou wrote:
> NFIT parsing has several independent extent contracts: the outer table
> must contain each advertised subtable, and variable or versioned records
> must fit inside that subtable.  The original patch mixed those contracts
> and also derived the SPA structure length from the location-cookie-valid
> flag.
> 
> Split the checks by record type.  Patch 1 validates the generic subtable
> header and outer extent.  Patch 2 accepts both defined SPA layouts while
> treating the cookie flag as a validity bit, not a size selector.  Patches
> 3 and 4 validate the variable arrays and the control-region extent.
> Patch 5 bounds the 32-bit capability mask without rejecting future
> firmware that advertises a higher capability index.
> 
> Changes since v1:
> https://lore.kernel.org/all/20260722041701.21078-1-pengpeng@iscas.ac.cn/

NAK
See: Documentation/process/submitting-patches.rst 
Section "Respond to review comments"


> - split the generic and type-specific contracts into separate patches
> - handle both 56-byte and 64-byte SPA structures
> - add the control-region extent check identified during review
> - clamp the implemented capability mask instead of rejecting future bits
> - describe the exact fields protected by each check
> 
> The series was reviewed statically against the current tree. I did not
> run an NFIT firmware fault-injection test.
> 
> Pengpeng Hou (5):
>   ACPI: NFIT: validate subtable extents before dispatch
>   ACPI: NFIT: accept SPA structures with an unused location cookie
>   ACPI: NFIT: validate interleave and flush array extents
>   ACPI: NFIT: validate control region extent
>   ACPI: NFIT: bound the platform capability mask
> 
>  drivers/acpi/nfit/core.c | 77 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 62 insertions(+), 15 deletions(-)
> 
> base-commit: f5bbbfec59b4e2fb7520a91de3df8a6174325d6a
> 
> -- 
> 2.50.1 (Apple Git-155)
> 
