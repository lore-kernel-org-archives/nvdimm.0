Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB6F2D12EE
	for <nvdimm@lists.linux.dev>; Thu,  1 Oct 2026 23:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790898015; cv=fail; b=P0O8lTqmayO/0Ta+y7a7MIA0Rn5TFOVZX66ssNF5vaWX0Um3pLRrDzyLbZ2pOUkThNZQ5SHvFakFJiCY+FM8t3q8fioNqP3Sc+dKys14F+Yx2QwVwb5LNQgYy1jJyqv7uxN0ubSyYFXRgRtmjDwBhGG2g8cbn2LvVtUNyAEAL20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790898015; c=relaxed/simple;
	bh=EcqK2nMvBG/5yvmW8XOPgArbQ+vdZ9+h9nDheb6ej3Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=avFYH9mrKsWd7CUbQCRcWHvqmCFG+BPUuy5IIKnODqJZ5xp6KQ+uzGptpvXHOE8SszKK/D9FswZO6ASOBMNHnv8WWN6AoAocTUcVfxbhBApqaQa8XAK97NBxnunzWeGIYIfzG7RHM39mhQuJ/SNf4mZABlGrD9nezgy52DA7Uyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kbmmj+dB; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kbmmj+dB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790898013; x=1822434013;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EcqK2nMvBG/5yvmW8XOPgArbQ+vdZ9+h9nDheb6ej3Q=;
  b=Kbmmj+dBGnBykPewoqwQSendzbdvzLJrdavS6K5vmcNF29xIOEJurL66
   cmh9THemb7uw+ck6amXdolFktC0UCN1RfgUIJuGMJtYgNe1KcsBAEQs4v
   lICFhX9rTgg3bXk/Ur0PXo/5wrzu+yJ38tMiAgd7ogu04o9pBqQYOI/Mj
   ibFcIY4u4FAFdYh9LKbiM0NP55xPFgslCOk5hO8NC+od5Q2vBWlWXvCXB
   v3OZVqqcEMa0UU6oVuxMQRPgYlAxOagw/+1/kKHC0StK0TMlQOhbbYdA4
   SsZcvK/zlB51eY5CUKnF58uBikWMULzPv+TXpfZ+MiIziBJVPrg4c1bYD
   w==;
X-CSE-ConnectionGUID: fU9AJKgYQjuDizSpizFUpw==
X-CSE-MsgGUID: RRyqR36VQwuRcTlKPGPRLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="113453602"
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="113453602"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 16:40:13 -0700
X-CSE-ConnectionGUID: R4000jG0Qpeddf87Ek7okQ==
X-CSE-MsgGUID: hR4DyuBERiWKpBMa/qJedg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="279381825"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 16:40:13 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 1 Oct 2026 16:40:12 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 1 Oct 2026 16:40:12 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.43) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 1 Oct 2026 16:40:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SbyMQRxrPxt7hPtdrOrOioC7MPqTq974mHEtqEb1xs3/zkhwK5EiscpPSBBEgjYNh0ata6TbDjPr1dZv7oGqmwsOI1j5pxKHsbe4dLl2HY/5QuDRpiZrpOCLprnAqihAQxbhjghLcv7VwhLrkQyoer6KANfwRd2MVCkLNbKPRp/xXhr/KOqilUSlvislnB8wdWdVJrYDyPs94LMoTKUtyptUHxP2hynoZKxfenrPsWGXfEL6NdGy/OS8Lh3Vyys+aXiRSV9t3TWlvNlMkOXp912hABoqA8G3zYE5Q6eYLwXaif0sQjmozEiKgPE3jJofSN1/tLCmgdpXvUrKLWPpxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNxzqK24Yjj3Ryiw4xp7S1SreBu66fMxWFSvOuh5PX0=;
 b=fL9RilOxSsvpHdnFjffd8cbE661sSPgqolwu/kYwlZcrc5WT1rOCf1IK7Uk87DcEiVy3c7ZajvJiP6Rx3tO8bDRj6MHA3ZWCa68iD6VvR+1VNaDDvhDbBcv+ssS5JEsNIhSG5ICM/lZfBpH+Epd0knXon3sc25EjNTqR2QDGV9KYtKUWRRjT8LN9k0cR3kBOx7VIqQj2NWh6JDZepT/C6tUcjbxYkaemMg3fdiwGUfMmLRjgK2+KFzs+EB/RUAhLwTzwXFsiq2xWzrxvR5vPEwtA9F4IPhPwOWuMA68FfXNlvnF8NThmsLwhB7WukjVA8vK3Y/ago/9idWPc2gnQHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB7587.namprd11.prod.outlook.com (2603:10b6:510:26d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 1 Oct
 2026 23:40:01 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0472.016; Thu, 1 Oct 2026
 23:40:01 +0000
Date: Thu, 1 Oct 2026 16:39:57 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Kees Cook <kees@kernel.org>
CC: Bill Wendling <morbo@google.com>, <nvdimm@lists.linux.dev>, Dave Jiang
	<dave.jiang@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guangshuo Li <lgs201920130244@gmail.com>, Ira Weiny <iweiny@kernel.org>, Uwe
 =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>,
	<nikitash.mariiaw@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v3 10/11] nvdimm: ndtest: Return the string length from
 flags_show()
Message-ID: <ar7vTd282UEZS7XV@aschofie-mobl2.lan>
References: <20260930235231.out.387-kees@kernel.org>
 <20260930235247.157921-10-kees@kernel.org>
 <ar3yXzo-0k0_BuCD@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ar3yXzo-0k0_BuCD@aschofie-mobl2.lan>
X-ClientProxiedBy: SJ0PR13CA0167.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::22) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: ecf7568a-2dc3-4ed5-c0f4-08df20154fd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|23010399003|6133799003|56012099006|10067099003|11063799006|4143699003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: NEQ+siF3tKHHAD/6+fLxHUSiXph1eOghCAPMiZX7SJ/y/OChOxSxci99hXa90gK0tIG+rPjWZ0D4b3W26siPL3G4F+3JRECQD+bdsLnX9PPw2/r90x9tA+jggkt57KgGFd2YjqAVNebSsPHZqSSE86GY9Ob7ihUoL9ex0MbkcdoPRYfgaCboyV6yZWC6G1tAv+wUs0CFr05lKqYUu/q99JrreLsH/K7k4kqwQ9cuHKz6B/MND18MC8aaTvoZsop8YWIb4WRy/kO6o5y95QHdFdvWjn4ahg8FvGvBVaJjpmG1lOEo+9D5q060yUyAO+jwd5GcqvAhDMg+KaObf8YpEix2fvNXEoinEU6c6NFT+EnseCn5glu8obGKqt+b1bPIejEsiiezwLZQCuqiXtXe+27UZwsXQXmbFus0K7UWcjOPQwIoygCy8k/VgcHtcgiq/8br+//9cIqiUXuGDFHQ8xEkfpVJcf6vXqh+A7nUvzXq0GBFbw3VKguILKAPaAeQ9l41koaZJS6gfdc27on/6da5Ta8g2Xrf8JjaYGbjOBLvLne9qIL4JJf76xT9zEn0h79sLuPTOAYP7+1RIOXj2IovxI2PrM8cVyWEz5I9/gOk+krHHcLkeYJ4mBMiKxr6EXlRd9Or/lltsb7z0ul/6Kf38sI5BZ7M7DxkpeiEqJQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(23010399003)(6133799003)(56012099006)(10067099003)(11063799006)(4143699003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+nF5bj0nsr4Isx++ylDRKanEt8cqbTSgtgxNQfyprwIv5XAZ28bv6/DHXIHo?=
 =?us-ascii?Q?A1skKwRVzewd4z01pViYxejqbgcEp92ece2Vads7IvXVm5jwAHQHCiAJD8Zr?=
 =?us-ascii?Q?oJwB0VtyXB0g9l1Rx7SbrKQN1ANNU0ar+O6KahD0+cGB5/iUJcU+i6JGJ2LG?=
 =?us-ascii?Q?KzyHH8YR6A3Drhdvw5UQyQDJLDJ5t3CRsDpzQ1fCqV8Jia2Q9+Ycc6jA8PMn?=
 =?us-ascii?Q?CmRYoLXXG754rlCURutIZ7UHMe+WsI7SDRQtnY6s5o9/gaVn8wjWdaVG0Mx8?=
 =?us-ascii?Q?t5+i5rQBfJ6iPD51gWKhTheNVMmRfaU8MPUQjckpM58G80JBjux6uJXVCwpp?=
 =?us-ascii?Q?LJfgO90IOYzmKHUWhVPEiVh+6amsRELWpXo/jrmDX5z5mJJBm6NX5H/dWQqv?=
 =?us-ascii?Q?yFshJ0fKYF4uNoteS9bGmbKyrGCpgrjj/cDwt5WhhvICgRx3zE422CldL1zY?=
 =?us-ascii?Q?UHgLqoWJhhVw+6/CChQ89UyWnx3OKDVwq/6FBQCRfM9isxe2Iyk5WmUNeaLu?=
 =?us-ascii?Q?KSOHQGgia0q4kBZ3uJCyRPSiUXwdYPxM5aUYW7JQIzTmeWBxeGremEPu00vX?=
 =?us-ascii?Q?fKr6zkJNLgCvrjqY7nTI2byQ6sJSwA9Aj+A27heKN+dnRG62TcpKWPgKHWyy?=
 =?us-ascii?Q?G7BGqvhZK3n/ZobPrLhngD9d0rUzA9z2RXOxEB2ayg33aEbO8VVwBgonNiFO?=
 =?us-ascii?Q?0NTgDp/APqQmiwniah/xV0F0yPq5Y9ov1kTMyLFbLFL1MqJxEK9hXL+g8Wfm?=
 =?us-ascii?Q?yf4NACvbCRhpm6y+d7G+87VR8kcRr3ndvlQ8Mp9JeFUobW+2MSYnEYtpT+rm?=
 =?us-ascii?Q?YHu+4An3oTP/bmb0kfYOxpUlP4c0PIxr8GVFQhedzhQZR7BGQwSGBttDSrRS?=
 =?us-ascii?Q?1wWhUMIptPZ7hbaqYFRqmoR6H+3wf3LXFhqez0A0Mk4GJ2n7XQiIiIygQz8T?=
 =?us-ascii?Q?+oRMi6Cm1gXoWrB5t4VWJVf5wZ07f6rvclzWeYU6R19+LS0kZERZFj+IkyFO?=
 =?us-ascii?Q?fqZ49CvC20AjGPEDGL2pjjKObKIIE05Hy3fztlMEO/iM9zLzNTaAPHg/ll2p?=
 =?us-ascii?Q?XKhAMOcaJCu7IUbR9uGOm1F3jJEXO6pe55aaZQ46NpjfnGyDIc7o6WOOv0Di?=
 =?us-ascii?Q?PgiXgO3HWknpkCjXOYgMYVfBlC45fi4KNBHAGWScT16XW42Z0CwV8yW4eEV9?=
 =?us-ascii?Q?pdTOO4z7lBUVjtt94Dn/1txAzTICjvFS2hNfJBIMew3gzc2iWwY48tzhUX+B?=
 =?us-ascii?Q?Yzp015fOROebjfxhzTgS/Wn3bCepzhydoJXFRECDV3Y68J315CHpzqWfwWDw?=
 =?us-ascii?Q?psZlRlbthcKVzQJVCDTRwFnAqGDJK6WVd9hPq7GZ7EfwOzMb69IyeIHmQMka?=
 =?us-ascii?Q?f4eafm6lHD0nHHbH+CCm+SmhTAzv4uq7+1nM5QP9KuFb0ckymd0I7C4oesa+?=
 =?us-ascii?Q?/IZ9BuqAkeY3r+jATAEQFuKtjYDv7bCSy7GRToVWfBlmFtDU8WMvJ49IZvi+?=
 =?us-ascii?Q?oab4ZuF5tA/akX6HmBgVAQqoh0aNRWzm2WgvoDETMzJeEiunUft5GBmeug8T?=
 =?us-ascii?Q?6TCmxkM0NHvLED9y7QG0KWJJQmqNMfp3HOAUb22qq7Kljl5q1r9y1hOFqVDe?=
 =?us-ascii?Q?VBzDeUV3LkDL54ll/Ex/Htn8CTWPwvoxTTFbOMaSIKqg2MKvDtmytJPRbOMZ?=
 =?us-ascii?Q?s3cfGIx0ErclN2IQZMlMHXrclckqBeerWqMpbLh64h8HFyhsazEdhaHVmWFu?=
 =?us-ascii?Q?RBbjgfLmZRY84CAYO/wac3GIaNMfj3I=3D?=
X-Exchange-RoutingPolicyChecked: YBzq3+5RWnsFwZ8iKtDNwnaYWToyurWMGC/QXMunfePBDJ/9p4Vv49lrb58sDRUFu2z1+HwcpH2FL/CH6/668AvOXscJk4k4YHQmtwEN4jGhwD7Cl5PdVRHHAgvYvs6CiRW3Qvc3aGMR5bn1nf2+qx41VRXl0GL2FjpRNZOxu9+IOXxqy926StcQXmg101YPcEcYmT5BDTDZiJUcgCk3aRIDoR/OZDvdlYHEwuIcNgnusMDiCQuEOaI1Zyi2mQ02EmOoN0IkzbFX4nc/ocJtBm7ARf81CtJXitF0IjL8SaEtBrcWsu8Z2Vbrm8hUFJ59PpVR03YpDpCwZj1sohij8A==
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf7568a-2dc3-4ed5-c0f4-08df20154fd4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 23:40:01.7132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B2JI4ZwMNzfMyhLfZHYacBci/9Ilyr51op4xST7DH5pNHjG2q6v+12cUNLNEUQM7Q9CaRXGFqMGc8ZzMjIEoetQTOzX4wU8vPEjl18KbbVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7587
X-OriginatorOrg: intel.com

On Wed, Sep 30, 2026 at 10:40:47PM -0700, Alison Schofield wrote:
> On Wed, Sep 30, 2026 at 04:52:38PM -0700, Kees Cook wrote:
> > flags_show() build their output with a seq_buf and return seq_buf_used(),
> > which may include the trailing NUL byte when the seq_buf has
> > overflowed. Use seq_buf_strlen() instead.
> > 
> > The flag names are far shorter than the PAGE_SIZE buffer sysfs
> > provides, so this cannot overflow today.
> > 
> > Build tested ARCH=x86_64 with GCC 16.2.0, built out of tree with
> > make M=tools/testing/nvdimm:
> > tools/testing/nvdimm/test/ndtest.o
> > 
> > Assisted-by: LLM
> > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Signed-off-by: Kees Cook <kees@kernel.org>
> 
> 
> Hi Kees,
> 
> Should I include this one in a 7.4 PR for nvdimm or is someone else
> merging the entire series?

NVM, found my answer when trying to build without the entire series.
Tagging but won't try to merge - 

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> -- Alison
> 
> 
> 
> > ---
> >  tools/testing/nvdimm/test/ndtest.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> > index 2051ad5d4882..f097f2992966 100644
> > --- a/tools/testing/nvdimm/test/ndtest.c
> > +++ b/tools/testing/nvdimm/test/ndtest.c
> > @@ -693,7 +693,7 @@ static ssize_t flags_show(struct device *dev,
> >  	if (seq_buf_used(&s))
> >  		seq_buf_printf(&s, "\n");
> >  
> > -	return seq_buf_used(&s);
> > +	return seq_buf_strlen(&s);
> >  }
> >  static DEVICE_ATTR_RO(flags);
> >  
> > -- 
> > 2.34.1
> > 
> 
