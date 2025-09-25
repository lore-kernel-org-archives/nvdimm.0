Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FA12FB975
	for <nvdimm@lists.linux.dev>; Thu, 25 Sep 2025 17:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758819882; cv=fail; b=Rh//nvTisk04Ln9qzSfZA0Yk49h0EibWmg0UBbMFP3L8XFQYT04zQSXH6pybsShkpxobZnoGxLk0gaudI2+ftrnstY/QZEeBvp0vre+2zV93s9OQ1y3B7mGa3bG+MfTBNwmjISdnIQ12V7Z4EfbgD0UD1xO/HCBFXQK5Nj4BrTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758819882; c=relaxed/simple;
	bh=LJHDMK3j1j/XGx1IUBlBiG1/ipFs1Ovrw0r2N8zMq8A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H44ekXAOCAYhWm2Y6zdQ+CCZeSEU9ImFv6t3DoUX92MeCHPMfMhMiXhuvZml2fxr7cY9TV/n/AiFeAjtKaLwOM3kb4Zr751U/3VhHfJBbZC0tssdlYRmzoECfMohrWAjpmNrKvGp0ndQhX5CFM8SEydeijz3jw6XADfkKcXp2sU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MPyevG1z; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MPyevG1z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758819881; x=1790355881;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LJHDMK3j1j/XGx1IUBlBiG1/ipFs1Ovrw0r2N8zMq8A=;
  b=MPyevG1zDsUVNR/7JF0wM4ZwV7EyZQAQkroDrJXX3v1hIxDHnZq/8oyE
   ONOSTiZKYu9KtPwq8wABi4j6OyLKf/OzdYySY2A/k6/YdWf2iVRHRxr/Y
   +N07HW519WDUGMSTY9l+fvNi34gQBwKI/uaZKyUuH6FW3DoCN+snsAQ56
   sbsbQINZBASNyuLgR/RTuQMWb9HUEWwBD9zJjCiA7fl2UuJZBfoH8Q1en
   EVd7lxIWUk67jsQaYi3EBHaA4/tLNH9zuA3cmm3OBYZWzitFFgOH/kebB
   Bkm+dX9/XsRKMzWCoWs5shk5yLOVP2zkin7NlqJpw1gx0yYf+by+/Phai
   Q==;
X-CSE-ConnectionGUID: QWRFv1rAQ8SWpD8I7+NICQ==
X-CSE-MsgGUID: bGq5ql9TQmG0H07c1OZ+4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="71395714"
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="71395714"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 10:04:40 -0700
X-CSE-ConnectionGUID: scT0uN8HSDmMfso29pzk0g==
X-CSE-MsgGUID: PUUfjSOKSNSUqXywyS2ieQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="177004528"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 10:04:40 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 10:04:39 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 10:04:39 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.65)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 10:04:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B/ZUF0cegQhKLkxMnjFLk4jG61GMRoeKGPPpka+RLQLXQ2VozQNEX+Mz72KFt+kmY759qGpntF573D4IE2SUVS9fBnF4/WGpOhfiKgas2aUTdT/s19CaTJyVOJ582V177snLLpQl48grxqG3a1HMQQO6cRvRwXBHtlk254BoJ9cI3Xh2z6Hf1uJIP4QCDwp7iwbXybQlNANqFaIz/24HuHeOjWwBLRYf9AxAy11UyMiG62eUY15sNehatzY77jZNOcXpeHewgblQy+C2zRp9oShE4nMuzlrvjWAsH4kakPnwCJm7lc4A+62v0i7qsjfktvB90rBXPbWIh83UBXytaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZStOYnymN0jgGoUrE842eJmk2/3nhyHk/bqWp9NzfQM=;
 b=ltMKwemDCum+UUkAs9BZWLVwrwOTZRcXpctwI+zXHJMa0SIcV0X7HxCTqEctrf4Ml2luyhSXsP7dKhg9nbvTJQjxUlTqNENwGXbXMrCdiXSRBtcWae5BkGKmmKuFreqPJNwS14wX1NLgWNg2fKEQrT+5xqO2eF9SRqEx7TbTSD+B1PlktywqAommdbUSOAfgt12pzIlS18pBZcK7pSA1yCvXmjdeIHdKtx+WlaAqhSJHnIlJyCv2V873ly2FcQ4OjWRZINRkeTWyU9DEw4c/d68QXchI+bDINEKlHvKRXZH7OC1WVuFXTqPJeLhdGkdgpfel48mdy7O4cl/xdG2ZVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by PH7PR11MB6882.namprd11.prod.outlook.com
 (2603:10b6:510:201::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Thu, 25 Sep
 2025 17:04:36 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 17:04:34 +0000
Date: Thu, 25 Sep 2025 10:04:31 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <dan.j.williams@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Andreas Hasenack
	<andreas.hasenack@canonical.com>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v3] cxl/list: remove libtracefs build dependency
 for --media-errors
Message-ID: <aNV2H4F61_FaUrAb@aschofie-mobl2.lan>
References: <20250925075438.148935-1-alison.schofield@intel.com>
 <68d56606e8dd2_10520100b5@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <68d56606e8dd2_10520100b5@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: SJ0PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::33) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|PH7PR11MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: ec05e39a-cfdc-4cd5-0ce6-08ddfc559a2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Jgexr4oJmUR4XTvXLQD+IV+0gCAkfrNgDEaE/lkJYgk1HYbN429rT+tIAvco?=
 =?us-ascii?Q?zFZWmayvd+6oluVp7PqgIoeDS0+POQ5qK610cr6qbHWNcNJ3jj7cazQ3pHQZ?=
 =?us-ascii?Q?XcFgdppwBiTuLiIS1Z26CJAj7IciW0jlDd7WMskOPJsIg8dmwpwLndnVYiHF?=
 =?us-ascii?Q?o19m1gY0vsBkaWxMGDKfpKZ+81idO8Yx7ZHeBQmaQlhoNN2khi9Y8WWKdTRK?=
 =?us-ascii?Q?5hkxzuLPRAgwxJsly53E1/fYfCQOVS8Y5gvLslWYFaBKzzUJYacRjF8R8tGN?=
 =?us-ascii?Q?amkDAKuaRaqEnrhxbrpmTZGb/CpV1b9DxikprlhoxBWOWKyPzfLAivJ4+Mip?=
 =?us-ascii?Q?RMSWfvbKBSZOzB0mVnX9lhbdSTsCPWkjP4aB3rVw3YLv72mHOHE7u8zMihd/?=
 =?us-ascii?Q?DamoZayZkPqpMob4p+cXJVsYu61yy0r2956s8SwUAd0RBZX2IW5JTV1dAulb?=
 =?us-ascii?Q?C9m283ZSnqugAXTZE4wvbk+qAXGYSlgPy7iB49th/Jiiu83VnDoX5e9iV4i0?=
 =?us-ascii?Q?Xu8DS3AldptqujTCjJJ8cMlTpHDKqRvkv7F5ASyXSl1n11IXlVAtvJ7PEERK?=
 =?us-ascii?Q?oUzkimDwdAaSTPDdONXW0raNGqjq1WIpXZyjEEHSIsSQwx5hM2/7dIgKxuNs?=
 =?us-ascii?Q?Qdzml+9MgiUBWtnjuKkhowg7VRT+1G3hus4X+KuoHbJ7R6X1qfkpKnT8jeIj?=
 =?us-ascii?Q?b5f5VtZfIagjOqVulmYm36U7Cd9m/pYDEjCmpQGNJQF8usP/59GOL2La+9QG?=
 =?us-ascii?Q?Y3KoOUxKMZoqeMmBY/wVPLX0OzwkV0N5nBuR6hcD7jAAe1eb+plt8O9CxArj?=
 =?us-ascii?Q?7Xd3R4kwk+TDu36Q6shkXJv3dpjPZYNPScXoANYDfzUr/m/Pyji4ygxOcRE5?=
 =?us-ascii?Q?+yhQ7Nwil45+wK75rHQH5vQK4JfZkyTfOILMb7DjXCuP1LQ/MBMqcLvAgTNf?=
 =?us-ascii?Q?NrKRM6v/olvoAfX4nj1jxPCWJprLSojSr3N/dgw8eOWBGtRzZoCTwQtP8dJR?=
 =?us-ascii?Q?EcdsY5Bmnp5dHecLQW3IhjCUhGv6pBg8AwsI/1en5Kb5/oQQ+rSg7VYzu4oZ?=
 =?us-ascii?Q?WkCf6oukQxL1A7uXv36HNiWNv4PbuO5NCnuTr/5qyyIcVnUPPFq5x0zEBzQu?=
 =?us-ascii?Q?SU0VMFBtzg/vtP3IFKYdS5lDb38vjMUqIIy2QV776iDuwjBCSihKf3EcI69j?=
 =?us-ascii?Q?8SfJwfJSRRY+XUmYECXPAEH1YXfykGwhV7usiCMSYZi2Pe7STQIBRTO7IrAl?=
 =?us-ascii?Q?WgFvVtgcx35a3LMTT3j9MiP1L35Jkl2aGlZjB71hvTTMr9LunIwRhwCy8kU5?=
 =?us-ascii?Q?UIJrgx576YMEj6Zx8EURqF8qNRjmgdqE8VIAU00Da2WHKILSHuAPwDzlJ8Fb?=
 =?us-ascii?Q?fWWcxu12uSfk9KatfiEh5ueg6FFV4o0GNGNEZlDoYiqELJ11M2+TLFE3B8tQ?=
 =?us-ascii?Q?Xu/A5lhvBQk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XYwurvK4e//8XIqVp0yQkBfCgHDTkdT/yIK3dZk9u2K66I3K4TNjjsOOJ8PF?=
 =?us-ascii?Q?xNyK2tq1kT4CAPkyyKUFIOmfGcLYETOPByNb9Mzsx+hyQoKdhISIj7E9sy/c?=
 =?us-ascii?Q?8jdFYeUDyXdrzIhg62lpPn+zRu+RGHor93oXNWJ/PgxZhUCSef0HoVqym1CF?=
 =?us-ascii?Q?VTzuuyENLRMGcvUpvOAv62quT1IhGBjHdOWEW/2O7Vpt4sUbfQxUzKvgVEWD?=
 =?us-ascii?Q?ekuiBCHUnBtzV3syNQTz+aeOnaVLdGeASMtPJhTE3TjqMTNOu93dQoqY48He?=
 =?us-ascii?Q?eIiPNbA1s4Yy5i9T6mYxpwhBFHikfGj9eVni44UB5GPWphYur/oTShy64jUU?=
 =?us-ascii?Q?GoXLdS+CFclk5e+MrG9NuC+e4jytj4AMeK9yc1dZXZqkLByPtYSqlrEcvxJw?=
 =?us-ascii?Q?19jGziiKP3AmRYLqWmNci4BjJehRlVHdyncDwSOTNO2gWqBEyXcx3KwFSZcw?=
 =?us-ascii?Q?KICQ+hxdPREZul5VKvcfdsGq40yDwVol398Vvp+/lYkUYLyLd+rOBNVpMF6k?=
 =?us-ascii?Q?cldnfA6A2IJTnLz51NVz7R1oAIUHsOfuhaRBtxMMwX3EBlu7h5dI3BFgcBoV?=
 =?us-ascii?Q?ZalVP7V8FWurBlPEQSrBFQqbpl7znBefpnibesn/zX1ikULhp+sszDhzUWgM?=
 =?us-ascii?Q?Bhe3bq1X2//O87tlQZESUfL+vDe6vH2Th3q/oT79h32NArhRPMESl/gZWJ/Z?=
 =?us-ascii?Q?geZ9Dm1URSj6ElGdI+GRVdmvQHDAI7eERAYIaywxp0PySWtCgW+FKfEEPQie?=
 =?us-ascii?Q?8WscmMwsP9QhtNxrysvCKt+9zsp8S1azyhkIHgDonxp76zy6+4hvm+Nrwa6R?=
 =?us-ascii?Q?rwaT+BHroLEyP9Q8XKtclCsuLiFxRoSm80S0h0eJd8TFsDM6n2h1IXfB9LDn?=
 =?us-ascii?Q?UyBszeC6a/FCytFSd56P31o7d3UNt1fFR6cl15n5a29GvFzNjQF6HGjphssW?=
 =?us-ascii?Q?B8EwvJllssYtBlw3D2nSmKZVIP172ww2BP2QlMBfl1cdKlnhPghUN1Q4oNiB?=
 =?us-ascii?Q?G8Sguv0/081uaRfH3AlDOs5xh79sWWcrtfw8pI5g8UZrBCGrzqzz9fXLHMNh?=
 =?us-ascii?Q?rScurAPirXoStemiMKV2SrWuZtxiGWpnctpqPEM3+a2HmbBMvUNnYokTRe9n?=
 =?us-ascii?Q?932NdptW+aIenBC0ByA8d599QgpSwrHvgDd0gwhc4mgv1RPVkxvJcgpBIQnf?=
 =?us-ascii?Q?zQ7q56qPpUSEEuHnOzmBiNeAbJLtnAE+IlJWOhNqUQbGDJK8mIuVdXTCIlA0?=
 =?us-ascii?Q?sJWNlPQzfvm2lFN8ndJW/mBfe7nushKDm0cNRMHVMxwgta1vev31SvvGrMSr?=
 =?us-ascii?Q?IaewAWiiL5zocF16d7gpIi5DGNvZ//Qufo2bCfzCLimQhpdAx2TDp0Yv6oJr?=
 =?us-ascii?Q?gsOqm1a1bZ04obf+UvcewIlU5dnS3DoafW9HCRJzFFO75fDmNBNabIb6vBWg?=
 =?us-ascii?Q?KvqcrvlQCRnYER4eyi2eXMUaNZkX/WOqGUSieiV9IIT7O8ggRWMHoOKokx6W?=
 =?us-ascii?Q?o4MJYzVm9VVHjv4Y1oqSfnXYmyc8t9EuzzzvPrA2FUE11Y1BZgbqxifiNya5?=
 =?us-ascii?Q?jDEBeLns7lPK3DnryD2318CnHUkss2R/awUGAJ8+chRZnMQDSvJLIFA7Oh9y?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec05e39a-cfdc-4cd5-0ce6-08ddfc559a2f
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 17:04:34.7152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ktsVjkHjpmZaF0N5qbl7blyCC/Qiye0/dYwcYneAgGzjnKj5o/lKSz5JEcNDN6AHQe0kGx3soHCMUNI375ndjv3p27ec90F9q+TfktVixWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6882
X-OriginatorOrg: intel.com

On Thu, Sep 25, 2025 at 08:55:50AM -0700, Dan Williams wrote:
> Alison Schofield wrote:
> > When the --media-errors option was added to cxl list it inadvertently
> > changed the optional libtracefs requirement into a mandatory one.
> > Ndctl versions 80,81,82 no longer build without libtracefs.
> > 
> > Remove that dependency.
> > 
> > When libtracefs is disabled the user will see a this message logged
> > to stderr:
> > 	$ cxl list -r region0 --media-errors --targets
> > 	cxl list: --media-errors support disabled at build time
> > 
> > ...followed by the region listing including the output for any other
> > valid command line options, like --targets in the example above.
> > 
> > When libtracefs is disabled the cxl-poison.sh unit test is omitted.
> > 
> > The man page gets a note:
> > 	The media-error option is only available with -Dlibtracefs=enabled.
> > 
> > Reported-by: Andreas Hasenack <andreas.hasenack@canonical.com>
> > Fixes: d7532bb049e0 ("cxl/list: add --media-errors option to cxl list")
> > Closes: https://github.com/pmem/ndctl/issues/289
> > Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Link: https://lore.kernel.org/r/20250924045302.90074-1-alison.schofield@intel.com
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> > 
> > Changes in v3:
> > - Remove ifdef's from .c files (Dan)
> >   Move ifdef chunk in json.c to a new conditionally compiled json_poison.c.
> >   Move ifdef notice message to !ENABLE_LIBTRACEFS stub in event_trace.h.
> 
> Looks great, I appreciate the ifdef reorganization effort.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Thanks for the review!
Pending rebased with this v3 version:
https://github.com/pmem/ndctl/commit/b26e9ae
