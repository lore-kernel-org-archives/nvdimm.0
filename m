Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54370184E
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 04:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747888513; cv=fail; b=QG9MxsjyxoLHFLRpU0gKTVr7rvTsYpTinLkQ47jNTd4sXm0n/syGde1qThrz1Wy3dZzsr7f1a6bBkJ8zdDEN20V/fi5aEt0Wn4P7WUgzzSfjm2l7b3Y4BMT590voZvIFJcEjcXrv4JsMrvtv03QwRJwFc44NUQlBuhI9+0Dspn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747888513; c=relaxed/simple;
	bh=dHTcrBCwAnRUuAM7V4csF6SvlUoTa2Fn2WaEH41ve5A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k3u3yq7fnRsOQiTm7Iahx074JU/evIPZ5ITq0J2eCYBk2h2Oi6IGAmYK2L7u2srNQtI/+mbuJU+hcEwfzctUrQ3wZGkgjJnSc0dDiAFEAmInpvNaxBVe89l2XAsPW2bFAetlqI1tsnpcEWAfafG7iS6zCrDRCQa+5i2esKjRq1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cp4T9C+f; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cp4T9C+f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747888511; x=1779424511;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dHTcrBCwAnRUuAM7V4csF6SvlUoTa2Fn2WaEH41ve5A=;
  b=cp4T9C+fDjG7p4Vny952A8yCDT6IpXQqktdVmLSdaCd/+6Qm8O5cDSmx
   77GBSVqdJg1xaL/okN7he/+YPnS/z19832CtPq0J0sAb925wjyFzji2Bf
   8dVg05oZg0FyxmzBYKH7pXCm6d53ZJS8MApV0/WeoMOs/HGdB93lMbW/u
   rMBs6lVdKmHTa4YzHSUwNAkqBjfbUWgsd0NJdHiZML36fylxWj1M/HnjI
   6E2vYeRseP8RQc4oa0zQ7Ds9MJQ/swfUK6cf2kNLPluvBj4RXxQ23x0tl
   UQ2ddGyKw5wAphJnecPvsSSruhdrOo5XYvZ2Ei7fX7v1Ln3FL3GhSn93P
   Q==;
X-CSE-ConnectionGUID: LHiexuYZRVmP87ARJD1uSA==
X-CSE-MsgGUID: yemOdR4TS1yzlVfs7uAMqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53690879"
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="53690879"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 21:35:10 -0700
X-CSE-ConnectionGUID: fHwoTucPTjOA7YW2ApGb3Q==
X-CSE-MsgGUID: nzhBSD8RSryiP9iSqDOCSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="140925578"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 21:35:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 21:35:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 21:35:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 21:35:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hpNK8Y7h5atmUAzjXzdXrQJKfxHbDyUGQ112vM4nxYBXmUYfAe7V2RJmPrSNL3eP9UBobZbCv/8DFKEz/iAicFryEq7AG/ytVBCijQDmleVYc6ZcIceZX9l7MCafzFVL5+s2GYNyjWOaxwm+qMAx5WDOWu3eWgfvgWlpBKE6tV0AFjFC77pQUYDtkBCvX6VY9Cnjz8i0r4DfK8Jvpn5kpKdF+qq5SlpsqOBQDDxNzC09GEZxc0SZkW5w413cOCPGFCSz1Mx50VfjAtrLQlN5l94UiBXgpQb0224/bHiyT03Y7pYmaeFGYlODzto3KUk05FLgXFngs2PhXuhYSMRYUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2dhF+GwrRIuSK1qb40ldH9NbcV48Ewb/9HmGGd56rU=;
 b=IB8oKvIsugo+aYvqp8nBhdoIdTpiuwPyK2p/q576/nsLa9PhnBHMMI5qDhh8bC5mX1jtcOUGU7/tIk8vs5ZhdZZdWZ10viAvOxrLfEIUdeN8p5ad09jtKuKOyWunUESxTRnrHgfE/TljUiUoVoXEFnqWMCZkqycVy12/j1RcTgE42pnQuJr8yVN4z14y/K6y6kYxD2o6ijMZyBbUL0Q7L4plAFSdiXmUelUuMhJGE/EQVab9mkVGopAxJs8VsGtb6JhFkolvcZURi8BLjviU5ByBAGU+0tmGwGFLfM/+ASd0/zkDHOy0AFKvyqAt5I+ZLODcpQglSIJt6hwdomY5HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by SJ5PPFC15A51B16.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::851) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.20; Thu, 22 May
 2025 04:35:08 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 04:35:08 +0000
Date: Wed, 21 May 2025 21:35:00 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, Marc Herbert
	<marc.herbert@linux.intel.com>
Subject: Re: [ndctl PATCH v3] test/monitor.sh: replace sleep with event
 driven wait
Message-ID: <aC6pdLThSU_uudf8@aschofie-mobl2.lan>
References: <20250519192858.1611104-1-alison.schofield@intel.com>
 <f5174c3c-81c4-4e6b-8d3d-7fec1624e964@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f5174c3c-81c4-4e6b-8d3d-7fec1624e964@fujitsu.com>
X-ClientProxiedBy: SJ2PR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:a03:505::27) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|SJ5PPFC15A51B16:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d6abbad-9a2c-4b69-21f5-08dd98ea07fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nwOP+hwOwuf0BypryAFUTGN969+FF4R4drba9O9V42CoDC6+rnTTAvTu8bfB?=
 =?us-ascii?Q?Yzm4PoeZaiz0ME0qzfgjWmcK4RxajWX95ag1gdXuh+zDS7gOCV/0xXlrQiGp?=
 =?us-ascii?Q?XQwG5gT2tnBHwkO4rNnqlJoe7utX/3CFqtkTZWEAG4cKXey3CtS+ykWlDO7W?=
 =?us-ascii?Q?vqrX6I/KlhDSFHl8MzdAu8GnxOuhXRU4BM2T2UgAp1uj3g+MLjwdRxv0VrbV?=
 =?us-ascii?Q?L9xOx1Z5dnqWB1vjcdNWgEI+EWgWcJv3d2aiRDXnVNEGc7UI21Jpl7kk1gTg?=
 =?us-ascii?Q?saTGcsaUeIbcv5krwX8A+raosOj3D70/1lm+JcrpFrr67AtWGgV8io1EtwGa?=
 =?us-ascii?Q?fgo7guA/AD4GSPUstei2Upnmk7xJcNvvDTQq2L6b7IwzBa7zjC0HJgZHBsUf?=
 =?us-ascii?Q?I1mJa4fMOO9O0jvi2pfBWWQLpxdEgnW/Xbx122qz6dPhxzYDXnBpbHlEsu35?=
 =?us-ascii?Q?VzctWUom+pnM8ZAPcKuuO588bBM6D8vL3q5fEL/7rvXfiW6NBACvTozvzEKQ?=
 =?us-ascii?Q?2IgI1CbHpSeUUPmZ7jhGjVwQRqI7OQLpi5s5dsuXKOGMxLv8XNf7VMpRLR9L?=
 =?us-ascii?Q?Ymn+W9Tx/kiSpWrFBygt8X479/Fn2R+OI9CMLm18XZPqzaNC25c5X+P2s9aM?=
 =?us-ascii?Q?S6DChQnB28JahetN1IxvemURtHrGuieSSOZXTnK4THkGs83kzKed4rxOfy/i?=
 =?us-ascii?Q?12usnNDCxspbm000f0/Ng4VQ/F/ZRFozbFHsIvcg7ICSH2I5IHFy4Ia1x0xE?=
 =?us-ascii?Q?Zscf2EMPiURmgfBPO7diEB1i/QT9Qq0mBemu3Q24BPCOEdNVtsHruW6QBuDU?=
 =?us-ascii?Q?NRIiOECxX97XgPw8moJeIofr08BqArsosS6+UZjyC50j8CEapD4NPfO6bfkJ?=
 =?us-ascii?Q?Rd1JX4dy8zsivXzAi2lC0/RkcBO6n7hpIKbBUxU8BIxIpexcHGqbXbgAp62P?=
 =?us-ascii?Q?YsDl9TTdGeA7FpACFJDcZvTRrlQraWTOO30q+TayFbIgo3okEzgDoGAOI6fz?=
 =?us-ascii?Q?HRlWt4f2zyvUXa9fFF+ZAqIjwxNEBqACUkovMO7m3S0u6Fhp+0Z3sosIEtK9?=
 =?us-ascii?Q?gGGhLfkfwimPpriozSJGgZ/UbmZbHSAjClK+xSoRYzzT6zxWX8yDKEO0peha?=
 =?us-ascii?Q?NKyrQ4E0VnoJfcxaZRIqxFiLcJ7yp1dc2F7jXGVpvm2LiSElb9MmvrkM2bax?=
 =?us-ascii?Q?O2r3KlAKixotpmVexcGkq0/BJNydc7DgPxAySbWUkpx0iR5s5BEdZ6DleGcS?=
 =?us-ascii?Q?nIgFhJOhVJjVJJSr6S8RgB8QCysAHO1F6pjO+Ce3j3jKge2FIH+hiCwECHxF?=
 =?us-ascii?Q?nz+zX+JvxI0b90Dy2MpN1xUI10LOE3XjUuqlpIyxHBy2S3Yj9mkpurPRzrxY?=
 =?us-ascii?Q?k4YATMA8ARRhXlgZXWPFlJNy9qeOA3ZnNUkiJkdTYlK5VqwECSiQL343MOJl?=
 =?us-ascii?Q?ia/doC2i3Xw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?beM2cylKPKe0JBRzXvsBocZSCazw1HyQ05Fm2KBFygbTLlpFKfTohXOPDV+j?=
 =?us-ascii?Q?Q9aeapsURbSrRRNAZZfWT/8c70/UIOOgTJ5TamGN+klqpZ7uklai8fJaFmnV?=
 =?us-ascii?Q?NsUB0KlvX8eMqP9o2B+D6dK+yTROfGf2e4l5BeM0X1/74w/e3T60+saUKvst?=
 =?us-ascii?Q?Pgq7v4UkGqSmDts61yX6yN4GzgNvZIDSZjto1T4YOHSZUs4WTk2Mj9fmLvcA?=
 =?us-ascii?Q?4/bEPNoj5KjhQzlmUDqoG8QDaRq74jiENJQTPjcO5BIn5dVxzNaeKa5O5xom?=
 =?us-ascii?Q?I0ndSWigytCLKMV4WdKivfE6+L3dRQA73LuP+F+HfRRbbT+cDj8+XonkEmyW?=
 =?us-ascii?Q?qMDu1vhc27ZY++uyaf4kPhrDAZqDe2hRUUnzsl6GKaB3bDYFQigGi4ZGP7tL?=
 =?us-ascii?Q?syTr7cDSofaB5cA6dJgo4hBsa6a8omVEcBWsDL8Q3/pv25aObTx4BxzC4lAF?=
 =?us-ascii?Q?UwDEs8dKoJGdAp14JRrvJfjb+kevuDW0/+OEx2n2terbcDIoqYRWnNr5cnHy?=
 =?us-ascii?Q?LEiS8Ry/c/001sXpKjxxkUebb5tA9u66sOnw/huCO9WkS9i/M9c2We2kxUOz?=
 =?us-ascii?Q?5swlNtkNYqZH7PdYJpsTDf5Eu68zMAZvy/G+5qRg8KwLRjQ4oa81sc9BluBn?=
 =?us-ascii?Q?akPH4V8KSfLCrd+QqhbcxJbGMPb2IrselS7qKSRKJGOG0NJ+BXabvi5odY2J?=
 =?us-ascii?Q?SXC1pJAbBaLaYekvUCSfsYdzqY9Xd3V2HmJpESD3e7KARjgOlKb9GGxPbdrB?=
 =?us-ascii?Q?WKTsTsMaJRl5wr1gwnOU1rQWq6tC4iezMhfUByEE1Bj4CbJH5oyntNMcQ35V?=
 =?us-ascii?Q?y7pycCONw4ql0B8exTaP/2299oHOS8AUeN4GQ1TRtZ9YzP+CqzjAUA53QrLZ?=
 =?us-ascii?Q?mqTC9/eTEwYxkSRNAqyH7+d8Cf18WjTgmZPNeuOhl9O7D3sN65BjPH1mKkeD?=
 =?us-ascii?Q?ga7C/1AUJZJcaCZA5VbrVna2648CWhJPcuVEBx5+DwDv82fL4bqRunmgEhkT?=
 =?us-ascii?Q?PzThiJE3nlFp71vKjMOJIrSPwmFXE880dqbCWI4dOW2of9/fsgPO5XHsFX81?=
 =?us-ascii?Q?935/LcGzIEXDV1lWFeTvcqc+L7XCOm1psZhjsr/allBKwSM+fpNkeMP2ZPyT?=
 =?us-ascii?Q?8t+dCRH9sO2uYZiwd2YFIVYS3PwbcVT23PfnUHoRehOrP/7OffXZ41uH2mR7?=
 =?us-ascii?Q?KmWqKQEoWQJn8AxxRCaPvtKEkRCYhUNmwOKgpTqzlacbBdlM9O2qe/janwh7?=
 =?us-ascii?Q?kw2HsfUeJj3IWrk/1lVDeGw+2xXIxE7SE4a5WCcKA8nx/VyJQ45kweHSoIXv?=
 =?us-ascii?Q?hNIfGw1lIXZW4PIOXjv7tSkQeTtLMnMBchJnboehndbd9kw4PeJjlcDucaXs?=
 =?us-ascii?Q?An8UB7101z55n3RRDxX0VdcIoNkr6T+0yUHrHjWdZYwdqOHqXhR+HUSc6QAZ?=
 =?us-ascii?Q?gXwFj+5eX4aglF0SavP6ifVRjFIalsC3korvNiYo5bMRohcYv/Uh+thu6PLT?=
 =?us-ascii?Q?wC/dLWgXylfkOoNOdzczFRzZ4ARn8kIN/haPBDvTuEhxneG1+QbRBPtIwSPQ?=
 =?us-ascii?Q?rNCFbnYsNXxoZV6YndnARS0R6N6FFTs43pMYfzZ+7Pfs1UDlZLlsc9DEC21F?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6abbad-9a2c-4b69-21f5-08dd98ea07fc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 04:35:08.2114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 42FnjiMSOno+iTiB8zMXZkWDsNCRY6wIdiIwY5ITytNBDC51zyjHg9M4/lZzTzZRiYyN0vTboNvgsczwDPhR85JWuJYgi3jhhlG6zF6/JYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC15A51B16
X-OriginatorOrg: intel.com

On Wed, May 21, 2025 at 09:00:19AM +0000, Zhijian Li (Fujitsu) wrote:
> 
> 
> On 20/05/2025 03:28, alison.schofield@intel.com wrote:
> > diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> > index bd8a74863476..925b37f4184b 100644
> > --- a/ndctl/monitor.c
> > +++ b/ndctl/monitor.c
> > @@ -658,7 +658,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
> >   			rc = -ENXIO;
> >   		goto out;
> >   	}
> > -
> > +	info(&monitor, "monitor ready\n");
> 
> 
> This brings to mind my initial contribution to ndctl, where it commented that monitor expects to
> output content in json format[1]? So this update could break it, does it matter now?
> 
> [1] https://lore.kernel.org/linux-cxl/4c2341c8a4e579e9643b7daa3eb412b0ac0da98a.camel@intel.com/

That is odd because right above where you wanted to add that info[] to 
cxl/monitor.c another info[] was added to the log for the daemon starting ?

ndctl/monitor.c has a few info[] going to the log.

In the ndctl/monitor.c the presence of a log does not mean the monitor
started. I'll poke around more about the need for json. I get that in
theory, but I'm doubtful in practice that a json parser would die on
those info entries. 

Thanks for trying this out. I'll be back with another flavor.

> 
> Thanks
> Zhijian
> 
> >   	rc = monitor_event(ctx, &mfa);
> >   out:
