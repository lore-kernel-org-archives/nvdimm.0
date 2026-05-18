Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F47229D291
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 18:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779130360; cv=fail; b=raA1je5zHGqCAgAxs31xV6TpBPlXJxp7lEi5gj+6uRd4xSxOlD9mTBorhHq3NNAO65QBbh7DP2fZBf8vQMZFqKXTGQCY+RD8JXcLvn7C7uIdo3OYF/izaV/MnrdufGuj1/5RUXxlnsUbFhVkGxCDmWSgW1xef9SoiVBgSrzgJzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779130360; c=relaxed/simple;
	bh=dkznfxVQfPXuzwNE/oTvfki+ibYYPZFgSNfCmVfPADY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sErdZGfKAOY2dWA5oF+0fdzYet6I0qBzlBlFwixbf6hFY+bJqqNYy6VONZ1tBaC9pFyp0bY7Y1yqU6qeQPqPc7GUWUphwVushYnLr9Treb3yLGBAULIvUE9xZizE5pCDk6E6gbkb4M73p0lIrK4kelEG7onkkazg6mvjKkqUuL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j0cexbE8; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j0cexbE8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779130359; x=1810666359;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dkznfxVQfPXuzwNE/oTvfki+ibYYPZFgSNfCmVfPADY=;
  b=j0cexbE8WrFBpHb1+363NqJ6SPnphH06XBe5rXjr6p2DEudlKPL/gdhi
   sxSLoUadBZ1KlTdbEw/w2mC82bGUxjXsFT3Kfm8cwhlKVORM0ZKBtnwPH
   XC696gOg3fEwTo5NKHCF4MvO+kHMz6agRTjq2oBL/vYrFpaXztfXUwDqE
   50aUpDlxEeA/4qp1zuOp0oW2o5Elab7171bpKrBP4pPh8ZQdK2LvIC48d
   r9ZPiLLMSMbABmj89ZTyF+kNIyJi+oAfJ6/98BhI1JjjMnetV8mXntv16
   ADpqfGhpWSxB4lEbMiYHDMH7OEMEUVMoIHVNf+cAHSy/FnryLEG9EYZRB
   Q==;
X-CSE-ConnectionGUID: ZOcUj2kWRm6zB6iS3Z0zvw==
X-CSE-MsgGUID: I6sN5WAKShCk/t0Z37XwmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11790"; a="79845494"
X-IronPort-AV: E=Sophos;i="6.23,242,1770624000"; 
   d="scan'208";a="79845494"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2026 11:52:39 -0700
X-CSE-ConnectionGUID: dRi/N4gHSvKs9cjjrCJS8w==
X-CSE-MsgGUID: ompW+Xd9SCmsuLFsH8BpuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,242,1770624000"; 
   d="scan'208";a="263292718"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2026 11:52:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 18 May 2026 11:52:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 18 May 2026 11:52:37 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.31) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 18 May 2026 11:52:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TyJ5pmvAWAFLqUsn344pKO6PQSW2ph60UKip4JpVKn/s6zp4Prh10FkM7ugCulGdFL77JMSfEhASkLcO6YKTE1vXZr1C3Uy+ZYbx6le3moo2YtK5rvUBVi7ZarmcK5RKvgQOvF3mX1UrKeZwC7GuUOi0zFqDb2psPHW4Fk+eVkAsZueHhH1YVQDaf1mmEpLDMlpruBA3c3REr3LsMKNAbg6MbH27j47oOcMAHpUuZTD5YP4TSgTEyhhmx1qMxN33DRvKFSXEyL9jPnoGCBq2VDRUddeBenQe6g6KMxqpjIgFNXj+A21bgflSpzIhVflLq/YRrzvFCvnAUorpyhBFVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eK4TyttAJYpOW8rPHUAnsTu42vJwk79qmufNxEyg/VU=;
 b=eRCRSXAefFoleSshQrpxs8A5GXbmzNcExK9/1D7D3QcsHpGlTwkjcpeqXe5cXjKawLBJ0GJtGTbt9dvZldfROFYjQ1GUOiH3L7iEm6tSCn+jEheHTW0bY9MZdTdSU9jydFR5ZOuQq32LPhBEV8duDo3aYrid8W+qvBhs9G4s1ViDRkRnl3c06a3tV15IPMkL0cyoVA3NBwpbO/OfIzQVikYsdcyZq2k6w0ULjZrnVXc2nUxRDOMxvvkTMiVZ0dblV2h6Yc88g1iUV47T0JP2P/x8KXJ7hUt+sJx8rBhIMRm0E2CSbHsJIGNhj60MElxjdeaIt5X36mH35LzNkYXlgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Mon, 18 May
 2026 18:52:30 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9891.021; Mon, 18 May 2026
 18:52:30 +0000
Date: Mon, 18 May 2026 11:52:22 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Chen Pei <cp0613@linux.alibaba.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <guoren@kernel.org>
Subject: Re: [ndctl PATCH 2/2] daxctl, util/sysfs: skip module probe-insert
 when driver is builtin or live
Message-ID: <agtf5uwBJOaCDR6l@aschofie-mobl2.lan>
References: <20260514063234.86439-1-cp0613@linux.alibaba.com>
 <20260514063234.86439-3-cp0613@linux.alibaba.com>
 <20260514193749.0f0750e2@jic23-huawei>
 <agZJACMViARKTp8W@aschofie-mobl2.lan>
 <20260518170141.215d1755@jic23-huawei>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260518170141.215d1755@jic23-huawei>
X-ClientProxiedBy: SJ0PR05CA0148.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::33) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB8718:EE_
X-MS-Office365-Filtering-Correlation-Id: 06abb04a-712f-470b-aa08-08deb50e9cfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|22082099003|56012099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info: kkRStHEs4ClXXZVj5ibhkORmUuCR4+QMRbcdL2sf6GMUnWQp7BkP5BW1L7ZQNLVycmFwEyFr2rZo0WN8eABkuriYRhar6Bmxdu5EE/wG67PuvL3mvZdWAf8ZQFaZ+IZmjNxjikEEFCHOA8xKRAemDdGvzZJAojRZexoI+/jZALlV3GyhLcFqDNWoB6+RpmmdJOnZBMC0Wnv4CkBUkLLxNEtkL9wMdW67QO/B4n9KY74Vjs43I9WrLi4MxQf4/OPhaHFR1HhpLgPbcpxZ/x742OrtmVcuc6qgMoTIaPZhK3lCDDPkTHvb4J0IWC7DrXI6Id0eiR3Vee6h1MS5YA6K5RHHMJa6+69SKfY6VShGyWpvAsHZPYfn499Vzk3XhQguE5po/8PRdf24YA/wp3LkQW1TCs+S8zQBSY7/hWukwehxuxEVe0jkqk6UKdjWvgFcU57niC5b8FHWNe0dnxcABW6OgFBHRc5gKmDhL/5xXPAsgroDq2cwt5nUhRJFAYSmQWIxWFU3nUsy9tz8WTDOuNgVzCUas0JiLa7OIJrIlQvZvPdXHc7ALTaf5mqDxbBWLx4mSRHzodYhBMwEDBcMK+CPz4NmxnqOKBmmPBz0P6nciZvm9mgXCqYVkrrDED2/9M0hlehnk1GzMXjGWrARulGMLOxV7UBVlpL2It9VjsYMyjJ2Ab6WKy8/kqB8ZQ1SZX3cIlnGT9VcV3AKASfAjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PrCdHwOBZ0UFsSngcMWAhHJnH9/psN9riAddl8Ht0t+m/9vdS4VMDVEEbETN?=
 =?us-ascii?Q?8+knqpKajipETldNcgNTOdCe1NJSgdViOwW5TZp/4qoGifb8w5y/6qzlHZpI?=
 =?us-ascii?Q?cZm3b08GSpliGDv/iDYFnckmZI11vLc7/hAdncZVqNg6STJ0mrI2BLonxMo+?=
 =?us-ascii?Q?BF7R5iazW2GY6RWpgBEdcqhO8V1rHKpctgrnXZBw1Y6M106ZudoH2tIWIfWM?=
 =?us-ascii?Q?44G139vx9PhB6McYhiwYbg3BVUFIDSdOlDhlFbArHuvAqOA1VKNHFsZTaBQt?=
 =?us-ascii?Q?SLzm5vMzuKcxgUOztJD4NH7vY08J7aLcLVtlwoe2ColMW5i2v/XSVeiqBZR6?=
 =?us-ascii?Q?yXWqInsBSROi5DjliEtRwP6zzgQ4HLYnQTKFgWsBl6ZZ9W/MOZEgIAVJG2et?=
 =?us-ascii?Q?lBzQcrxM2B62Q3PR76tHoHvnmIDHGeUt32uIyhzFKSVcne9RP+rglOxQeA6C?=
 =?us-ascii?Q?HJe2ouroI+fk2epeAKFL5ur2jcfVwwWYj0h3jTunpBvUcS35dP3MV4ckDqvw?=
 =?us-ascii?Q?9/ntT4T6X2aTfLYr/hHb80M/qN8JtvIcyA3EbniTod+q9vsm3jETNFNJfawH?=
 =?us-ascii?Q?GbZtei0ktzJYoYzGbgNtYjl0Ejb74flCTsyPVkW69nJSz3tel6C3De334RRY?=
 =?us-ascii?Q?1jQG+GIACwxTMAsRwW+41TSNb1g+w+UjS5snYaNLGaf1YA+82she4pR0j/dY?=
 =?us-ascii?Q?4wkslkYOovkmjItB3NY1VV9+HJgUYtUqF2uG+UzhqdkY3K8V4Sji+1ABG/NQ?=
 =?us-ascii?Q?q1EHGv+K2ryQYACWQCA6lkdyaQcim+jGGxugTbeWUOLHmkTkxjZC5vzYu3TB?=
 =?us-ascii?Q?jPhEduew3VBGPPtwJ8wtLdAY0E0Yiw1UZ4wuP6fw1yH8J57y+1x3d9HazJO9?=
 =?us-ascii?Q?Tfgp95PMGPXt6OlD487bAcJZHpy7TjiNhOEdnwMUei0lG0MGZvQkamRkeWkq?=
 =?us-ascii?Q?kbMvJVWzRbYGvQe+ok93IDD8rHMgG6En1GJrjd8tUKp/DlRn+EmJeF/K4h/Q?=
 =?us-ascii?Q?QUNtgS1l6vVpd6Hwvh9tGgIYiLhaSyR9wOKfOZsJy87eJhTzmS2TTBGU+aRj?=
 =?us-ascii?Q?2dsEc8Ca7ZIDwywtKha2lflXAHvwT6eqSmhqFUyZIuV/YLfHo8XLO2n1A/qS?=
 =?us-ascii?Q?Dszz2/GtMqXlQmZR5RKj2OZlQigmWUl+r+NF/joALMGX1jyABv1UKQxtcF28?=
 =?us-ascii?Q?SPfvO5lVWM8jHBBd8gi5dMDJsfDXq4GGxq0396M76nmvbjXvVpOGURzMnsV/?=
 =?us-ascii?Q?OdnlEiZbPhhf1RpeiCPS/tQGw5TYTJHG8ybTTggwYmXi5yf1qyx5JDH72Mh8?=
 =?us-ascii?Q?23rbFy6MyhDVELlmUSolY1PmRsqQmyTv8JoxMxTbTiRdqHloArdu/G6sdgDx?=
 =?us-ascii?Q?Fk9D9htYmP6T6LKVbz4w9OCB2eqjCfqjO0QIDqhokh44dSHnXz5GZq5kNVwK?=
 =?us-ascii?Q?pX4bYvI1j9gCqjhB/EcVGckXfnDjPAL/58FsGn1qiWlL0aLkT4xUpB/EFesV?=
 =?us-ascii?Q?KYpEqh2wF1oVXYNJY9W/CumSeyfaE5L4o/lPOVNuio0T7Tz2feBGxpRYUINT?=
 =?us-ascii?Q?KlItyQu7sibSKbRfeLG2ePLweKAwrgqiWD6rJwM1MXb/qEdNwsFbsxFSBBEo?=
 =?us-ascii?Q?RiuQOwh9jRrA7A0sDgXInidl0wcz0f5ruGpQdMQhEgi4DdKlpEB3K+w/Z7QA?=
 =?us-ascii?Q?EBmdY5eXqViejqYij9uW6JDhLoGXvUrq43kSEUwwB4+TrhlbDvvAzbsdz0rT?=
 =?us-ascii?Q?41gRR0tsS4f16q4+Av3IAZgXVuMsVPw=3D?=
X-Exchange-RoutingPolicyChecked: hdTdZGmGnru6JcGMwOXbHUwQb07B0EzNwb13LCRmatc/MVHZZczsPoGLXc8I4te6VHxxlK9Naf89t+RUNfv7o71jOywH/Ndh/ZpuLoBO1zCtzC8292uNhcL7e5Pk2X+8Z3kWBzntekwf8pcx8GGq5yYxuakIJRi2pqKog6lNuGnfMvjta4Zxkork2Yj5mN28/QeoZ5xo6ixWFnp07fO6/A8F3996Ce+KUjdboZxPa3iNjnIcDKW6bOS8iyw2B7D4Xqu1BN53yI1V/suOf6IoicCO1ladX/P1R8ZFFOCrptcdW2kwafvhTfcI9zXDnGin8wvMp6h/J1IXwcauv70R4w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 06abb04a-712f-470b-aa08-08deb50e9cfc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 18:52:30.3412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gX/PDOLKxPJ17QlpLmVGqO0HoGSx9xu6GPKB50UE4WkUKXrf9xO7cSl6RoWXssAk/GqNTH+zyBmP4keFQdRK3/P+v21sVvnvcNBdBwQ/mc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8718
X-OriginatorOrg: intel.com

On Mon, May 18, 2026 at 05:01:41PM +0100, Jonathan Cameron wrote:
> On Thu, 14 May 2026 15:13:20 -0700
> Alison Schofield <alison.schofield@intel.com> wrote:
> 
> > On Thu, May 14, 2026 at 07:37:49PM +0100, Jonathan Cameron wrote:
> > > On Thu, 14 May 2026 14:32:34 +0800
> > > Chen Pei <cp0613@linux.alibaba.com> wrote:
> > >   
> > > > kmod_module_probe_insert_module() is supposed to return 0 for builtin
> > > > modules, but only when libkmod can locate the modules.builtin index. If
> > > > the index is missing or out of sync, libkmod falls through to the real
> > > > init_module() syscall and returns an error such as -ENOENT, producing a
> > > > spurious "insert failure" even though the driver is already part of the
> > > > running kernel.
> > > > 
> > > > Pre-check kmod_module_get_initstate() and short-circuit when the module
> > > > is KMOD_MODULE_BUILTIN or KMOD_MODULE_LIVE, matching the pattern used by
> > > > ndctl's own test/core.c.  
> > > 
> > > So I happened to run into exactly this print earlier today and was
> > > very happy to see this resolving it! I'm lazy so when developing in
> > > a VM tend to do everything I care about built in and not bother with
> > > installing the modules.
> > > 
> > > However - despite having CONFIG_DEV_DAX = y in the kernel, I'm getting
> > > a state of KMOD_MODULE_COMING which is curious as there is no
> > > initstate file to read that from.  
> > 
> > I think this patch is worth you trying. In libmkmod code I'm looking at:
> 
> It doesn't work - hence the reply!
> 
> > 
> > https://github.com/lucasdemarchi/kmod/blob/master/libkmod/libkmod-module.c
> > 
> > the "module directory exists but initstate cannot be opened" case returns
> > KMOD_MODULE_BUILTIN, not KMOD_MODULE_COMING.
> 
> I'm  not following... Also...
> https://github.com/kmod-project/kmod/tree/master/libkmod
> Is a lot more recent than that tree of Lucas and I'm guessing the current
> home given it has 2 week old commits from Lucas.
> 
> Can you give me a line number for the path you are talking about because even
> in that code of Lucas I'm failing to see it.  Note the kmod_module_is_buitin()
> fails for the reason this patch is trying to fix. The file to check that isn't
> there - hence we hit the path that tries to figure it out from sysfs.
> I can't see any other path to a KMOD_MODULE_BUILTIN.
> 
> Jonathan

Ah, thanks, I see where I went off track. Aside from looking at old
tree, I conflated kmod_module_is_builtin() w kmod_module_get_initstate()
path that this patch is actually using.

So, I think I get it now and agree w you that once the builtin lookup
path fails, we end up in sysfs probe path instead,  which returns
KMOD_MODULE_COMING when both these are true:

	/sys/module/name/ exists 
	/sys/module/name/initstate does not exist

Seems like patch needs one more case. In addition to LIVE || BUILTIN,
like:
	|| (COMING && sysfs-dir-exists-without-initstate)
rather than reling on kmod_module_getinitstate() alone.

-- Alison

> 
> 
> > 
> > So if device_dax is builtin and /sys/module/device_dax exists without
> > initstate, this patch should short-circuit before attempting insert. If
> > you still see COMING with this patch applied, then we need to figure out
> > where that state is coming from (before thinking about special casing
> > it in ndctl).
> > 
> > > 
> > > Looking at the code in libkmod it seems to first check if it can open
> > > /sys/modules/device_dax/initstate and if it can't checks if
> > > the directory /sys/modules/device_dax/ exists. If it finds that it returns
> > > KMOD_MODULE_COMING which seems odd given in a fully initialized built in driver
> > > that particular set of circumstances is normal.
> > > 
> > > Any ideas?
> > > 
> > > To me the description above is misleading if we need to have something else
> > > for the builtin case to work.
> > > 
> > > I'm out of time to today but may get time to look at this tomorrow and chase
> > > down if there is a way to get it to work.
> > > 
> > > Jonathan
> > > 
> > >   
> > > > 
> > > > For builtin modules the local kmod reference is dropped because builtin
> > > > drivers cannot be unloaded; for live modules the reference is retained
> > > > in dev->module, matching the post-probe-success behavior.
> > > > 
> > > > Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
> > > > ---
> > > >  daxctl/lib/libdaxctl.c | 18 ++++++++++++++++--
> > > >  util/sysfs.c           | 17 +++++++++++------
> > > >  2 files changed, 27 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> > > > index ffc81eb..42bfc39 100644
> > > > --- a/daxctl/lib/libdaxctl.c
> > > > +++ b/daxctl/lib/libdaxctl.c
> > > > @@ -910,7 +910,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
> > > >  	const char *devname = daxctl_dev_get_devname(dev);
> > > >  	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> > > >  	struct kmod_module *kmod;
> > > > -	int rc;
> > > > +	int state, rc;
> > > >  
> > > >  	rc = kmod_module_new_from_name(ctx->kmod_ctx, mod_name, &kmod);
> > > >  	if (rc < 0) {
> > > > @@ -919,7 +919,21 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
> > > >  		return rc;
> > > >  	}
> > > >  
> > > > -	/* if the driver is builtin, this Just Works */
> > > > +	/* If the driver is builtin or already live, skip probe-insert. */
> > > > +	state = kmod_module_get_initstate(kmod);
> > > > +	if (state == KMOD_MODULE_BUILTIN) {
> > > > +		dbg(ctx, "%s: module %s is builtin\n", devname,
> > > > +			kmod_module_get_name(kmod));
> > > > +		kmod_module_unref(kmod);
> > > > +		return 0;
> > > > +	}
> > > > +	if (state == KMOD_MODULE_LIVE) {
> > > > +		dbg(ctx, "%s: module %s already loaded\n", devname,
> > > > +			kmod_module_get_name(kmod));
> > > > +		dev->module = kmod;
> > > > +		return 0;
> > > > +	}
> > > > +
> > > >  	dbg(ctx, "%s inserting module: %s\n", devname,
> > > >  		kmod_module_get_name(kmod));
> > > >  	rc = kmod_module_probe_insert_module(kmod,
> > > > diff --git a/util/sysfs.c b/util/sysfs.c
> > > > index e027e38..641b86d 100644
> > > > --- a/util/sysfs.c
> > > > +++ b/util/sysfs.c
> > > > @@ -183,12 +183,17 @@ int __util_bind(const char *devname, struct kmod_module *module,
> > > >  	}
> > > >  
> > > >  	if (module) {
> > > > -		rc = kmod_module_probe_insert_module(module,
> > > > -						     KMOD_PROBE_APPLY_BLACKLIST,
> > > > -						     NULL, NULL, NULL, NULL);
> > > > -		if (rc < 0) {
> > > > -			log_err(ctx, "%s: insert failure: %d\n", __func__, rc);
> > > > -			return rc;
> > > > +		/* Skip probe-insert when the module is already builtin or live. */
> > > > +		int state = kmod_module_get_initstate(module);
> > > > +
> > > > +		if (state != KMOD_MODULE_BUILTIN && state != KMOD_MODULE_LIVE) {
> > > > +			rc = kmod_module_probe_insert_module(module,
> > > > +							     KMOD_PROBE_APPLY_BLACKLIST,
> > > > +							     NULL, NULL, NULL, NULL);
> > > > +			if (rc < 0) {
> > > > +				log_err(ctx, "%s: insert failure: %d\n", __func__, rc);
> > > > +				return rc;
> > > > +			}
> > > >  		}
> > > >  	}
> > > >    
> > >   
> 
