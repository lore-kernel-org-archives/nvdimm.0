Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C464764AA4
	for <nvdimm@lists.linux.dev>; Mon,  3 Aug 2026 23:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785801313; cv=fail; b=H/wUbosNeHIuuDcvYZhWs9Q5ojR+YZ1bEhDwuyy55QWPVh/kstaxevNzBfKz74GDVUmpl6LtcOnPcTYXlQfoyagHFtKu7cxPQhZNibLpmNKJwLamVz6fYzdg/g/IhquGm/yyljyjZSFJJzKUr7XuUYbOZod8cnoErLOEwm0F3LI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785801313; c=relaxed/simple;
	bh=aWRTiR+i3XjJOoO15KtP+XOmBD/JzHleL1gm/GLhAh8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=riso5r7IxWSWx6eMwnnnrAqorK30JTLf2H0jJcgb5BRrlK9t8xC+o+R/7mZHwlIvzlMeFAprERpK48dWcLoI0SGeJjnqjYGEQMRWvJS+oWj9V55EA0j5f1pmLakbHid9ktKFDqJu/s8g34F1bb80mA7db3lcAeO2km+WlBWcIKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fj/ufAGT; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fj/ufAGT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785801312; x=1817337312;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aWRTiR+i3XjJOoO15KtP+XOmBD/JzHleL1gm/GLhAh8=;
  b=fj/ufAGTvwDtjnoLh1yUmSQxlrJMAXK+Q3Lca+UbITb4Y9S4kqiWD7NM
   hm7Bh7RXA6Or8T7WaNErKuKMrxC6ZyLdSQ2MbqKIUa0wWrb4yS0H5myhB
   8kEE6XFFB7ijTfB28z2XbylPoyb/HMmpdqmj+Fk0GHsKr1TrnnufFI0Bz
   WMD+WDtUXdiDW6pUVq77puqM3TUkm9xb0zksUM80jyo1n3eSs94OQzXr9
   zxsrq42kLiSQpa33B7MPPaTOwy1e2J3HniGTdbcs9jXLevwzriWSWyoLp
   cPLihO8LmUC73Qt2dl7CBBfEvpbB+gw5/zljy8k84sRR1jFdQL09CPSbJ
   g==;
X-CSE-ConnectionGUID: Co9q3TsaTZWmVEGU6By7cA==
X-CSE-MsgGUID: jwXh+iaVQE6jrxL2N41iww==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="85324237"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="85324237"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 16:55:11 -0700
X-CSE-ConnectionGUID: McngfElwQcmBiLNolPgOqQ==
X-CSE-MsgGUID: 6xRA5OqoTGiqMUg7NivNiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="257030789"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 16:55:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 16:55:09 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 16:55:09 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.54) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 16:55:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KjL+1dFzhR/vnEBtBJQvvm4ok5zB0S+D2uWxi6n09jvXfsAACHLU28fs+/LW0qjmocNvTeWn2+6CyE1ZqAeqPYTYf5/ixIn3hQzcaVHSMJ27LGvNg180EU+TxOJMTQO01bGT9m2dgCcFQY+ce/+xLP12y6XtjtuU+UiJrbAwW/AT7RYJwBd70n+kgtW2tDs8d4GgUGbSe3N8YJpfAW76OC5tLzdqyW3ov2Py2vhJtgoxmJy2pNRSFlcbZLc2IMDqxgno62vr/AUV1q5tnncs58YbwC+doROGhkvF8WM3mZsmC0FzcEalYmu3BAg4EBHGEn8MdILz25l0SCDspHWqOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ub2i1KOdGonm1eTKIUlKvfetGcdDIv94pHOCFvvbFrA=;
 b=v3WRb6J3CU6Jp8LNAJTjZiHFzo7PlIwZK7it9tv9ol1AD6qZIuZ+/XBtyE+cvbJiPvCWVX8u3srwV8f1hoQsBJ9L4un3BpbCRORzglv+6FE3nsZeMVuQohbpjxRowJUEojuPkLFXc52SdY1NmihCP42eTKhTmvnxGStwxVFIg3TUwy+gL9qGYUv2ii/nsLeJF5K6qmLDCmDiG4wV+DOFUgJRO2EgTRJ1TrQhG/VYUJYZS2JsygH4adJB+ABHMwjIqyK6PeRo5+IogijsaWrwjKIVQnRnsjpSKiLop85P6PwcTSbLMUA2z7aLbRf2zSeGOPZzzDydS4MQoCgEljNM6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CO1PR11MB5107.namprd11.prod.outlook.com (2603:10b6:303:97::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 23:55:06 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 23:55:06 +0000
Date: Mon, 3 Aug 2026 16:55:01 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
	<ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Wonjae Lee <wj28.lee@samsung.com>, Junhee Park
	<jh9934.park@samsung.com>, Heesoo Kim <habil.kim@samsung.com>, Dan Williams
	<djbw@kernel.org>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v12 5/8] cxl/pci: Factor out interrupt policy check
Message-ID: <anEqVU3-B3ab53eE@aschofie-mobl2.lan>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-6-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260731084901.1512819-6-anisa.su@samsung.com>
X-ClientProxiedBy: BY1P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CO1PR11MB5107:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a9a0f06-761e-4360-6128-08def1baa493
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|56012099006|4143699003|11063799006|6133799003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: YXLOnhSqgjtQRZPwxrPGdx0rt42elj1Xcjh49zwka17h6NVD6EuicWS+m7SfrFrig2DVdGy38KW8r3zO+0siWNtlGnNv7Q4UMR9ByN+Gqe1T5NprBUt4+3c2u+kr5tkf4mdzVg8F2uxNIx6TxAXo9szToVJPRxAnOvemSUlqElsPlwJbJi8BhkgJ33k+rVWJ4izKKzJwCCs7jt9FNqp3auYEZAejoFcsCPCxyKTMnPj8uEKUKNOBnFRutoldk75VDHeYXBqe2aTYtoz3KlOsJ8EZ1tbJKaei6T2h9R38XsPne/7IkJBU9sc4UD60vmePkIpgeuMvDJ6A7ubrfAeA1rFG8QZJwrSssGOAcSKiogt9LUNWioxR10KKZPlzgMMd7K9FZiVO5o9tvchumhs4CKeqyvuN320bLuyeZDE8Ng2a98Lq4Hd0H4KmByDvKLRgUmt4yfz/pqb5Z2HBQj0ZCzCw8NAFFQyH6GKvqb2pFFiG8r6Vxjr2Cl5cuoUZQ4VzkBHk6FrxHMDsTHfv2tJZuK44hlYvVGIasHT2iIFpgacCM1CoX8NnnBHXIM764jdkqE87x8H17Y7fi9kR+gDcSqGGe+Q0Wi6JfK/GJ8NCo8R+moCZlcJRATDq9Bc9yfODdKtItgKJqmsbfhrkw406AaschyAOuQV57MTq0wnbFj4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(56012099006)(4143699003)(11063799006)(6133799003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DsQoMvnBsWRKDzvUnfT8/+Z70i4iXFKkYYBOSDJYGo5wRYe0Fr8C3qcPIveL?=
 =?us-ascii?Q?h8/bF20pdpHnogrXpuG6kxDtW4Fa8Eot6FPuXrrCFR9svEP3AJvqDUkkaNgo?=
 =?us-ascii?Q?JlER6CTtjKLO5vB1n/cPsdiGyNK7nFGkUOAwcGAs/ZO7NMHrj3JcLr070iEs?=
 =?us-ascii?Q?aqELzffysM3JmyswjQxzY33va2Yspjl7+a++fkdx12dg7bz5nWbQWd4Bdjo9?=
 =?us-ascii?Q?hLepk8MCHX6WhL1n1q/bxJpxXF8I7W4kn8CaDyHZ8Vrtp25wTYALIm9YgoQD?=
 =?us-ascii?Q?ZA5o2xNWhajxbC+D3EZhU+MlHZkSUABlvvv5zBQrp6051e/i/b28YBFyY+zy?=
 =?us-ascii?Q?8JvqfaqXcsiIPU2ArWnIjOJeob4NPe7F26mIFsZXPNb3BClWxBWPD44gVLLs?=
 =?us-ascii?Q?Y64Yf0oNNQqPrvqmyTc7Kv8ZExVvuMOkPriXwfYCV6jLmhaRSZR9Wp9fYU2M?=
 =?us-ascii?Q?dOAPidllr5VV8/UINYIXTfR7kXqq0CB5/uUgYWRclsdlLiPAWIS6vuz0y6h2?=
 =?us-ascii?Q?UBiZ3X1PEwomkE+v5UQHEqFE8EvfSA3pUyjqRH0ZNxKVSGtg7k1tQtkedYuk?=
 =?us-ascii?Q?vgGr6YSo7lTI7aEgqgOXOxtzo4e6ptgZIRun25Ad8t5g51HqUicz97YyKoTo?=
 =?us-ascii?Q?8RyKDBML6heISuCWiD7IB+bKIuoHwAzr97BkyX10WKOeD+aJCYmQBLjod9Rr?=
 =?us-ascii?Q?X+5dULx8ypZfHCLGlqPYNpCv7thPXv9BOvCBXuKHkPgJmO3MURxvbzGmukMl?=
 =?us-ascii?Q?r06fRCJVgizx1xUaBoiFiSSkHJL2qs8DF9Csp1Vm/sIqJ9SKMWLJHpKfKouG?=
 =?us-ascii?Q?8QYbLg4nmXR0tQZTOVv0A6NoVz99ZYoTqcExm/3c8u0l/YXsQCxJHdEV4EOQ?=
 =?us-ascii?Q?+yOvcqWYZkQ+Svm1OtFh2mJz94EapIzI5XNuV/juw19x5PTVhcbK4wYVOYMR?=
 =?us-ascii?Q?6adwrm1Jkx85Q4R3fFej5bhbkLfE44f9np2Td5+b9be4TbNMg5J+2zLzfqTp?=
 =?us-ascii?Q?XyRfXX9WsvuYFdjdmQvXMFey4IUmhEk2RLq54KCNj00K2TcNGu89YPoGxain?=
 =?us-ascii?Q?eEo9eW8cKOSpihIB5nC06XwsOrgU2h6u+E3l6+ch2+qOKyPDYIytTp3NTpbZ?=
 =?us-ascii?Q?7OaqiGyDbz98DfBv0KSjOAq9sCDAPVfBxyADn1x6q8SSA/1avJkhxQfKUG6f?=
 =?us-ascii?Q?amEmm7s2eemm5uPeNLcTVut1vK0o9ASGem9I8oSEpCMXfh7s+CqLdPMuO05t?=
 =?us-ascii?Q?3sTPfYEEHzComjB69ph/NMhI2MKZtFfhNgA0l95gfEVgMQyskNedudj5ho1X?=
 =?us-ascii?Q?zoLh8GYjimE14KVpsRziJKmQyHqD+Kc58F5vkFG4H2NTokJc9HLxZR1K7NYc?=
 =?us-ascii?Q?I9YW6A8hkvMGQEW//a5jVVi39xdSrfXmiwWwhs7ICW+oFt1CBOvp9AcOlmmX?=
 =?us-ascii?Q?EQsQCLRZTRqw5yxY+EYm3d3OD869QZ/F2Rvps767x4KU1N6hPPRTUyCrzFTa?=
 =?us-ascii?Q?XUSFTDdvWRpmWmZh0NlM5VM0RKcUWYsUggLvbBPe6r0HapRMkJIz0MGxfdsR?=
 =?us-ascii?Q?LhMyCvhrE6yWIth8Q0wxXoiH55e5fZAxwKxSsE2wNLpt3Rgqduiqi5XM0aMf?=
 =?us-ascii?Q?egDKXiKkUtMt3gA/NMp47ZV7HIVmSCzCA8WbFMUz11cRgp36l49OnOD4za3y?=
 =?us-ascii?Q?9O10YQ+3tjMgzKNC86Ot8fwf726rBgjsD9Nn5qPUj8j6xb/Ea1lcQA2mojOO?=
 =?us-ascii?Q?eIpr2CT+IdWRowJV7adss2VeXXRp0tg=3D?=
X-Exchange-RoutingPolicyChecked: nnkC3lozquOCzctc3INKnGXm+N/Z/TjIy/OZB3c84ejPJm5CPQ6nWPxFvHecUt/o5ZfgMHNvJUl4P3Yw3edIjKhzQzuQoetrUn8mdtdciYu2h/zMjLmzj9Aie7gVvzOZgwBCY2chjh86QXZjNXC/WTNfBMuBycNdcDJ41eRUdA0HgO3SDdHb/sqxEc2Lu04sIsq5dRkfWLzn0RZp9eguGQgfaq27seV+3lajmPXdXA9Ne4LAIxDBrAC96468gxtVxHvTsiL1edG3VQXZrotmqz82bEPsPI4C7LTFVqCconmTOO85+ayg1hQff3Y4qw3m7131BzAmeDhUdYCotonTNw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a9a0f06-761e-4360-6128-08def1baa493
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 23:55:06.2334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6UPIlooeRoedmH7r9DvqKvSPXQINP8nHNBvds+6Kylqqwi4ZKk6EZHuguDu3kyZdl4O81dSncxd8uo3dt/KGG/gcawyreCWWRV5TLptBQSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5107
X-OriginatorOrg: intel.com

On Fri, Jul 31, 2026 at 01:48:10AM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Dynamic Capacity Devices (DCD) require event interrupts to process
> memory addition or removal.  BIOS may have control over non-DCD event
> processing.  DCD interrupt configuration needs to be separate from
> memory event interrupt configuration.
> 
> Factor out event interrupt setting validation.

Hi Anisa,

"Validation" seems like the wrong term here. The helper checks for
firmware ownership of the memory event logs. It is not validating
the event interrupt settings.

Which leads to my next comment -

snip
> 
>  
> +static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
> +					  struct cxl_event_interrupt_policy *policy)
> +{
> +	if (cxl_event_int_is_fw(policy->info_settings) ||
> +	    cxl_event_int_is_fw(policy->warn_settings) ||
> +	    cxl_event_int_is_fw(policy->failure_settings) ||
> +	    cxl_event_int_is_fw(policy->fatal_settings)) {
> +		dev_err(mds->cxlds.dev,
> +			"FW still in control of Event Logs despite _OSC settings\n");
> +		return false;
> +	}
> +
> +	return true;
> +}

Why such a general name here? This helper seems to have one very specific purpose.

cxl_event_validate_mem_policy() doesn't validate the policy. It checks whether
firmware still owns the standard memory event logs despite _OSC granting OS
control. I'd prefer naming it after that condition rather than "validate".
Something like cxl_event_fw_owns_mem_logs() reads much closer to what the
code actually does.

--Alison


> +
>  static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  			    struct cxl_memdev_state *mds, bool irq_avail)
>  {
> @@ -661,14 +676,8 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  	if (rc)
>  		return rc;
>  
> -	if (cxl_event_int_is_fw(policy.info_settings) ||
> -	    cxl_event_int_is_fw(policy.warn_settings) ||
> -	    cxl_event_int_is_fw(policy.failure_settings) ||
> -	    cxl_event_int_is_fw(policy.fatal_settings)) {
> -		dev_err(mds->cxlds.dev,
> -			"FW still in control of Event Logs despite _OSC settings\n");
> +	if (!cxl_event_validate_mem_policy(mds, &policy))
>  		return -EBUSY;
> -	}
>  
>  	rc = cxl_event_config_msgnums(mds, &policy);
>  	if (rc)
> -- 
> 2.43.0
> 
