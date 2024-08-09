Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98694168487
	for <nvdimm@lists.linux.dev>; Fri,  9 Aug 2024 22:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723244153; cv=fail; b=BTzn5Woa2eAvbA/adGEr93SqFoXXOvB6rwRHuseRhrarYgqH+9RMwpxPRG0eZ3KcgelGtKK9hQ3ZZRutW3CKYgEPVEyb66pbPAx6vWeszzrAj4cNIlhh7+mS9ljAqoFLOtRoiZWseeCFqEnjwK+YJejPAdmTpRLITU9HGOKG30A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723244153; c=relaxed/simple;
	bh=1K2uuZysGFRT7T+Oltg35z0ngtlfZynREP6K8eVboRw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Bk+Ou8LAd3ZxIBVBx+9l7t48MJhI9tRBd+hBEMz+rlTBfcRhsRHb34JuR91lb1hX1K4npwQM7FTcgJEBd6Wn89dtzpDyn3ezw5Hc1NVWGn1rYWYREPc9BUuHSYkdIwLtWqc9twJCuebxaIAp9z2HNeZt614X/rklxGqPwgMr5pU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VVBlvSe1; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VVBlvSe1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723244151; x=1754780151;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1K2uuZysGFRT7T+Oltg35z0ngtlfZynREP6K8eVboRw=;
  b=VVBlvSe1OjzvjYGZdW/KeyGdy6r5sf9vURvsVtx0Wacnr8SDvvDCWQIu
   4U57CbTTyWXEVXmfIH45/CD1Xqq2uGfUG3OhPy96ACyBxEOJQxg3nbPus
   Os80WgtJBAIM1yRShVF2tTHKU7RZ4YKgSPsc+HJqiWYF1UY0hbdW9qPxh
   s3zYrRIjJ77XhocVGE2iVYH0GxzD2pQI6N5dDHncCHBVyiHpDf08xFXqb
   6RL3ch71XHMsgllUBjGHUUZdJQpKsmwLvjJvnTWT8myFi0F+28LNjNUDG
   eDXEkZ7yyd4AR/d8kze2I7zFncq/RNHkmobbLCqtbX0HNCWNWDGi4w6iU
   Q==;
X-CSE-ConnectionGUID: mlOhWoxHTRCwCF+J4VHHFw==
X-CSE-MsgGUID: A3z75plFRc2oSmqT5sflQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11159"; a="32844621"
X-IronPort-AV: E=Sophos;i="6.09,277,1716274800"; 
   d="scan'208";a="32844621"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 15:55:51 -0700
X-CSE-ConnectionGUID: l2Q9GFN7TXiTiXeUNT/fJQ==
X-CSE-MsgGUID: 1rsnyZ7TRGe8jPjq9QkpVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,277,1716274800"; 
   d="scan'208";a="62103403"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Aug 2024 15:55:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 9 Aug 2024 15:55:50 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 9 Aug 2024 15:55:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 9 Aug 2024 15:55:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 9 Aug 2024 15:55:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZFRuj6ujVZGZ90AhuyMG5joNMWI29IZDuDL6mjScM/Y+VLFAwmzg/uuSVMyJkGuyUCua5Fc9ojQESyRN3lrmIlkPQH8+MofHDWB/m1YFI16HADhRUF/SWyAk1USetqTJEwFPalFRGufr0My51X1U7b/ItT3djjLOmY6bEbdYNhcal7lU5tk/DwMnvKTiL03Q0XI+VjKAXcfX/YD1LCnAA3PA3UTGGsv6U/temGklsS+3ScO1xnLww/Np1Eti7ISAOn+WFzjve0Ui+LyaRqAlQ/xwE+tK7E/G2D3PfHQlOLO0AxjQsIE0seSGN8U6gFdZ2h4asqGpmFtVpHwIxbdZvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FYFgJ2TEMusBiRpdgr9i3/7SQCygxAPEzo63ELCkcGg=;
 b=f5b728oHPoeLa9wQ12WOrwAIG6JSlhrSvLft8sqxwdanTLmgCYwqniE4JsrTbIohbihSxpDHqQ56Vb5Ajwn3cj/gXoS9hkQ6j94ukOWoFKZutYHx/FciVj/tJvCnS1uyq+YWPsk6pvo0jGxVe5sY+8Riy3tygUmVjuVDE4L0srvwXaKpayjN0dSqeL5xrS18VEt9FA0jZKkS0fODkcT+RZBFrwN3QWxdmsiU2PLd2z02SRislqq0wX/qlnhOPVW4E0t4ssOS2bUvngzHL8XEpmcCsn2cwCXJe9FZxAUFhUaTXpGxeht+1cApasMKVtGZ59zPJBWb44S7lU6DKR+EIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB5793.namprd11.prod.outlook.com (2603:10b6:510:13a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Fri, 9 Aug
 2024 22:55:42 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Fri, 9 Aug 2024
 22:55:39 +0000
Date: Fri, 9 Aug 2024 15:55:36 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Li Zhijian
	<lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<linux-kernel@vger.kernel.org>, Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH v2 1/2] nvdimm: Fix devs leaks in scan_labels()
Message-ID: <66b69e681ea7a_25752943c@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240719015836.1060677-1-lizhijian@fujitsu.com>
 <66b69a6fc5710_257529458@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <66b69a6fc5710_257529458@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: MW4PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:303:16d::35) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB5793:EE_
X-MS-Office365-Filtering-Correlation-Id: 98389cf7-8401-4e80-a6c1-08dcb8c66356
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?H5s7F4ege13gtVBiK1eE48Stt5zXIXZQEMbL5mRUhUc8fSAHK/EGneuyCWPU?=
 =?us-ascii?Q?puXuCBUGCEJD9oekfahZ6jj/q6bn2Q706Q8sJtWcziwV8hOiFjX7uaTHod93?=
 =?us-ascii?Q?p/kugPDaqwz5QeiToEG0zqA5bHSm/YgzVyp9Twwzv1P8d64ohpZ5PcY7N6W/?=
 =?us-ascii?Q?E4g3GdeP+uj+FbvDfmA9MO7jkpEip0SqHajo61z8cuZVXF5zNhPhnwHkYjA8?=
 =?us-ascii?Q?0oU+84/n5Dt92iidZuIUl9W0oxYqnY7AhU8qsupoFiJzmep7Aa89bbBmW2JK?=
 =?us-ascii?Q?PCzb0ZGkxtkefjh0IKtK3SRl52DELEd3ECeBjUbcXPwgWcVL+zUhRqsxoM8A?=
 =?us-ascii?Q?i0a6Rqj0JuJpUcWpUbS/0Yfewnhvti5/7thSFMbbqMgEeE2fHLORKtTOZKlj?=
 =?us-ascii?Q?tCQIAjpV7mcOaYxtWKD8Dpp0YVUsiWF9c30Il2xJm9vkngtCrWaT6iu8SpT8?=
 =?us-ascii?Q?HX5DD0Od6O7C3LG1uybPz/lxobgNT4StLGG54QyptXhznPpZbucbHzGSBBb8?=
 =?us-ascii?Q?mz02XiWIS9Oe51FNCcSd9wevh4h4gxmkptQVf4Ixs0m3g+l/Vy8GlLQrZ+3V?=
 =?us-ascii?Q?qjR2hgtoOkZVBAxhhmMkpgaO0KvtMRueoNlXcFctcDqqt9/n0A/jWamDNem3?=
 =?us-ascii?Q?68cTE1SEqw8PqwhuUQaxZjjYYVo1IcE1ABXIOzI2P9yFiPiqhs+rh2ivnmBk?=
 =?us-ascii?Q?8Yh5pFPWp4vvsapb3REQJ7ykatj8hOjgMHWQGvNaMP4KtQ2eIdSqbpsX5DhD?=
 =?us-ascii?Q?JlWiLP9jQ9fGrixQTgPj4bU8qN2YpohuFjmWj7Ytyyn0hRsl14FVtmS8MMIB?=
 =?us-ascii?Q?2rfGsi8jczUDBdhF2h+6rJ4d+Fkww7KTIMh85tXI+K0y6rUB0kiV0XaUocUe?=
 =?us-ascii?Q?KV9U6+UhyfFHFO18YHg/ToI0OXP7PbEbNctBfnbY8jKHMZvil5REvUHGOjNC?=
 =?us-ascii?Q?/3qmM7sRu0RZ2Dcq0FMRkAEmw2CuXsuDHOkXtuspzUuhDmq6yIJRowCkFn1G?=
 =?us-ascii?Q?9/Km0GKy6Mw4nVwtrzCoTdBpu60F64TwhKsHIOQlqU6KXBZq11GNE0QHzTol?=
 =?us-ascii?Q?P9M92z0RvDS87tl1o1kcADNG9fUMXZw7UM1VDpEhpkRrW5xWBEOAZywjfzqJ?=
 =?us-ascii?Q?b41e3LgrjTIPlkW0Jiyct11LNQvJAKisc4lxPU5jo2RP+CInIXWEdrgGonMO?=
 =?us-ascii?Q?K+2Tbkd20bneyWHYdZG91pjvGE+AQ6AiaTFWdgTyxvc6cyUhKOaI7rcD7dTW?=
 =?us-ascii?Q?JbSXrOj04XE50giYTe8olDPl6O3SqEA7N77aC/aT7uuymynooNSVm/r70+Qi?=
 =?us-ascii?Q?9ldamp3StskU8Y10WhY8hAAqmSH6r+fFBQ9D9JUlUo2bZA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TrZ5nwC2XxSpN+q/0abNumN4AjRYzkaqjbJ5+RiHcaZzrp1k4adnfcilA/Fc?=
 =?us-ascii?Q?oOfcvss7FjpbHHMvCDrQetSMeaQg1P5N/7WnLfS9Tqqz11U4Z6qs0KjdCOVu?=
 =?us-ascii?Q?TcUtwBfcAuo9E43h0EV1Y6dnLu1ORITLeP0lKKECngK/j2hJlphByJo0ohLe?=
 =?us-ascii?Q?vXSEvGNJlP8jOXyouo/2DCBsBezZaSdbbafKbR5ka1QmdrRCczu0QrpAO0FM?=
 =?us-ascii?Q?GMgBHIhSS8ZFOvZuOoLCCUxA/3IdhBTKC+Ffw45yAwlW3WT7sLdK84rKY2SK?=
 =?us-ascii?Q?gcnG3nvR+sisK1O8345qsc4pJPnW2dYYfKgmxeUBWrF0hvNm3Me0eIpycs7d?=
 =?us-ascii?Q?eNKgZS8U0dkH6u23jhvJF1QyB5lBwa53Inl3CPvJmGDe5+rknOO+uKF1mPcd?=
 =?us-ascii?Q?3ENP5zM8MwCXX6hF6tgYPg+QG4fk4sQWbsh+sDEjJG4ZFVGGNDvalEDP7/jW?=
 =?us-ascii?Q?ut/tWZQAwFRiN3MjDo4yUmSLrNyGBtqGu0XyALAZqsGcopqAhClSkNaczewq?=
 =?us-ascii?Q?z1jVk5eT4YwoxiZ+pJYMoWuBCqOjRDaafJRnYJNZV86mHEAr7bHHXdJMUTly?=
 =?us-ascii?Q?D7TrMR/JNecevpEpIxPHd9O7eHkaxKAPI5EfwkvimY+YyZj+uK6/UKArhZR6?=
 =?us-ascii?Q?7hGxqu4k80SReAlU3tOiBzokY6qQeYbz+dyy8LICfb9ANyYMhqK3crOwElCv?=
 =?us-ascii?Q?RMwL/W2zOebBpr28F9q99UnKVvro5Jc2KLVkNf18ACpjMPngYtQDqOBBgr9B?=
 =?us-ascii?Q?GmsNCtMBYww/bqaTZCJDMsUIDP+bY2eVb+xzYPON4cK6hnbJqurPGPnWVpOv?=
 =?us-ascii?Q?/MLi+M+JEDuQVTl49h3PV11bvQgPVVrY02w+tbOzCnJAFvcgPDxpUQ5ydlev?=
 =?us-ascii?Q?Z/Uv/b2jXIH9/9Wo6TCl0GK0bJTNOjJjth1nfwDTfU5cLmO5mncB4j9VaFX8?=
 =?us-ascii?Q?Ly88euNKcO/U2xxarTJ/qVZYLUsCtSYkq5Ls9yz0PkGiU2lFLL/6XrbMyBFK?=
 =?us-ascii?Q?6Ez0HNT474Ajkvjz+OQ3H4l2yrYcjy7Fg5T8jjDuKSXqlw+6Gowt8EL4woUr?=
 =?us-ascii?Q?dqRF8mRmDQYeN+P1SvM/nBzJ2nv3es/4BiUQVh73HsP3ZWLPp9dRVEJ8/kYK?=
 =?us-ascii?Q?fS4Tl07TuC26a0Q+8YDdrK5wGFH6AfHbalFRBsLYi6wCJEdQOEb2YcWdjUMe?=
 =?us-ascii?Q?yRW7pxLUCTbqp8Ybcc7RAqaRb8yJ/O6zb5aoFwZ4QS/uc1m8Ov5JaPX8OISL?=
 =?us-ascii?Q?Ak8Z+xuWlIp8dn8FgZOAN3nZaUYqN6757Dp/XuIYCydef7lHG5+AVxWJC881?=
 =?us-ascii?Q?LDhgpcpGWOpu3B70jCMmg0d9D70g8lSJCGtInaXQ0ifOUjJS7tVwryT0BCr0?=
 =?us-ascii?Q?NE0dPk5TBSCKCKHhFIQv63JAGlaiZ2MYgmbh/FMN2NgIdbmS+m7y0FfRqly3?=
 =?us-ascii?Q?yxJm1P20QZlXCdiG30kwDXG+gwYroGvYEqRiKhTYbgkgVgYukiyMqsoV0a1P?=
 =?us-ascii?Q?xonmFBh3NxwWhiBqXQVNoGqRbaXakb7JfBz9aaEhUFkW6UflnRTbelx+eZer?=
 =?us-ascii?Q?3UVy3n5nUlkI6aHC0IR9/rqGFhu/vxqb7yixd1aZXHugLNRNkZxVLwdP1b/S?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98389cf7-8401-4e80-a6c1-08dcb8c66356
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 22:55:39.0433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UPOOXiooWUBSaWPNhfRM+Ublu/O2vYBukeaVr1a/ZTncHD53xkBDNTXru/wIenMU3YKVmYZtWNzAAu4khn/5YrFQR2oTJWmg1jjpeQpClkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5793
X-OriginatorOrg: intel.com

Dan Williams wrote:
[..]
> @@ -2036,12 +2038,10 @@ static struct device **scan_labels(struct nd_region *nd_region)

...of course you would also need something like:

if (!count) {
	kfree(devs);
	return NULL;
}

...here, I'll leave that to you to fix up and test.

>         return devs;
>  
>   err:
> -       if (devs) {
> -               for (i = 0; devs[i]; i++)
> -                       namespace_pmem_release(devs[i]);
> -               kfree(devs);
> -       }
> -       return NULL;
> +        for (i = 0; devs[i]; i++)
> +                namespace_pmem_release(devs[i]);
> +        kfree(devs);
> +        return NULL;
>  }
>  
