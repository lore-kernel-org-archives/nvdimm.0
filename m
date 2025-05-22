Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7E21FC3
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 04:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747887795; cv=fail; b=UILh46FEKAhNzQ4E0RG0NNA5BjHvkXT6y2GpH4jrcC5i/hR9CuuzJ7FgnW+l9OjQe0/kjQ1mtfSRUxe6usodO/jZMdZS65cA+ON/N0cJwD2Be1bTm/vmmU64uvYEtG8QNqE/IiHedOQ26r15lkdB2MPqpXKHXmrEhWg8stlysPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747887795; c=relaxed/simple;
	bh=DR0DT4VBcvg7KqjXFQvU97KBfJv5Nj0S+n+BHLJXjVE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gZOg+B8Vbg9/i3qJYReUAT4GYzeEraITCPQTuD9YgUQ2n0a6kEjoVqewhbM8M5jg7zmwiCktxb63ZyzkYUTTf/YVDAvcS7tPGuVm88EngCixCaG4uwvLkyRKWfgZKXQlOMjJl0pfBH8+R5GZmqBAWBPQQpVaNWWYVSHlKj/ft+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G02uQkc6; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G02uQkc6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747887794; x=1779423794;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DR0DT4VBcvg7KqjXFQvU97KBfJv5Nj0S+n+BHLJXjVE=;
  b=G02uQkc6wOwjG2pNSK50wY823/SW/nAExrcRw/I7DYAF8Wo32G6vy0ec
   jlbtfyVn1vFXxfAQwOD8Z1XPSV0/YU0DKw0HZ0WuKLdpyWX+P2Tol3nhG
   qSjemmK/WGm/t+/a2JzZg5kVMkww/2AluA9ANsDOF+b8pAuItetsdcjNe
   KbJxRAE/APRhl32aBlUTnnILIDU3/IjLuIh12zACrpt7Jl2jN1q/Ney3e
   ZLBOa+/vITmGu/L03bdz8f8oLH2NsEWAbWJYkU2qb1h1iYXKfiLsAvBKf
   4srHfG6SBAlWH0qACzRqeOQB5uIPYG9YDy1o6vU6aqofPs1yp60YRQE3D
   Q==;
X-CSE-ConnectionGUID: MaRHe+9MROKNALqeumZI5g==
X-CSE-MsgGUID: BKSF9DtRSEKXOTWavysaXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="75291111"
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="75291111"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 21:22:56 -0700
X-CSE-ConnectionGUID: wmQ99I/7QZWPDblkfmqM0w==
X-CSE-MsgGUID: yxaWVov3QfuLnMpP8xJaGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="145643146"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 21:22:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 21:22:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 21:22:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 21:22:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ttLDAuxyGspW7yXuXt/mSWQUG/aC/fF59Jm0fQKprSNBy8H+yCfGJcLE0SsTUkKgURCuFrDApjpnbEmlrpSjOWEun5eYmOChsSrr8jAGH/MpgruYFRL98ZBGtpGZSR1xX8uUpFZPdAHD44PsBaII1tX1qqTzdMzeKfL6ZTeyuDh28oIki5KQeSUh/rBeisjhlBm6BcykYsXzExshEFV+eC/aocovJJ8fG48GFz0c3skyi7jgs39o2zG7SwdpWviD8hBj/7JiXv+b+XCN3qDYJ7DTnuomTt97zcwocpEhEq5S/BUzIEsd4+SYUUE+aLCf+TJw5aQxboVsEZ7QuamMCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wU8x+r/wqBQn2j0QxZ2dP3oAOhwIz4ITNS6von/UNWI=;
 b=eFnXNQwTb6y+VBk9H4o6Ea+mxvHnu2bJ6UVmPj2qCp0HJmHjxF9xj9gK02Xkg2d6vUVYya7dqTqWprZdR6LY8ijF8v7y9z4AgUTGfzMHaenQS6fuwURLSoWF58Jl+HATuGZ8AoJgrlChOhF79xpMnxN/GHGT5xl6kLj21fxt9/SUieeY/IDT6a8Yy4HMdUaUb0zKwVq2GqP7N9lXtb56N4hAJLqFvRo/JqDmcFHyeyfXuPGznzVQPVIIVO8fAW0cVRup4SA83phZJ460OnSg7IL7O4tTaP09SpOU694d5FYwefV/HPfGcJHS2MtbmS0/twnNB0lsOdb1H3Ok1/9SRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DS0PR11MB6495.namprd11.prod.outlook.com (2603:10b6:8:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Thu, 22 May
 2025 04:22:39 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 04:22:39 +0000
Date: Wed, 21 May 2025 21:22:35 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
CC: "marc.herbert@linux.intel.com" <marc.herbert@linux.intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "lizhijian@fujitsu.com"
	<lizhijian@fujitsu.com>
Subject: Re: [ndctl PATCH v3] test/monitor.sh: replace sleep with event
 driven wait
Message-ID: <aC6mi4TQPdAt3UyH@aschofie-mobl2.lan>
References: <20250519192858.1611104-1-alison.schofield@intel.com>
 <f09a9e5b40838036e2355f44eadf00b9fb4168e5.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f09a9e5b40838036e2355f44eadf00b9fb4168e5.camel@intel.com>
X-ClientProxiedBy: BYAPR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::35) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DS0PR11MB6495:EE_
X-MS-Office365-Filtering-Correlation-Id: 447cfbfb-555c-451d-b72c-08dd98e84988
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jDjh2ALfgGQlS9xuKa5GVZFYb8j7OW81Ri8AkMbwYLsTHQavtWrojHsn+wJm?=
 =?us-ascii?Q?yHE7adRVkrT0hG5QWDqsrmSWZDP51+U1QPxw/ywYzcVTd4N6oCcXCVH530BP?=
 =?us-ascii?Q?HUBFhUOJXmSLmc5nhDmfpYko8qL6CN+fyPF/MMrH/NWwwPn5otXisF1Cwz8T?=
 =?us-ascii?Q?Z2j2P0wGI4axe/FEjCXTuQqFFfTAsE5lp2LETVcezBZgTwxHlCptxeFweqL3?=
 =?us-ascii?Q?K9tq+TpX3XAAQyP8gCrgbpDnFxdC6x5e/RbE+KcJcNPYWXxE6LQOXdTluMxT?=
 =?us-ascii?Q?G2Mr+hnYfbA35S8NYGDLngr33gX1kn3tshZvPJP+/nOnrKvRh99W+MT/6A+F?=
 =?us-ascii?Q?FVYJMuDnZZJ6l1dma9Yzuo59yskfwT6NPHJK2KKrIXe7dg9eLkbqTtUQUagm?=
 =?us-ascii?Q?vyJuO47YuEK/5Px/DESJMeLxolvM4Y/ZNBTy3A+cYP4xonWJqxYqAqbdLyUx?=
 =?us-ascii?Q?pd+py0fvpOn+EPZaF8XRFsRtDoxptUG+iUEBvZqAhK/Hzk5sbkJSk7WBX6sU?=
 =?us-ascii?Q?pZ/V1vJCgP2xIPhzUuUPA5VDFoYmvhBnuZ7b6UFpx0TCr/Tx6mt9mhwORgvy?=
 =?us-ascii?Q?RXrRXGVaveg8S0btJNHTEEydnTNjYVmGq2C3M0FeVu/uSYfacJ1s22ToE0eN?=
 =?us-ascii?Q?u34EgKLF0FeuXe1IttJGyFIhR0zPWjdwgojC0rPFsJD0P9NPgQsoM4CpgPcP?=
 =?us-ascii?Q?2S/vclPdGFOpBq3c1GX3CrpLrBhDBwH5n/FZXXj76cTjqL8d7qICeX4LhSYp?=
 =?us-ascii?Q?LJPLaEG6iUlOBoA7k0v8GS4BjxJAf/zweJoHU4t3lECsh8Y5S295+VIXlFB3?=
 =?us-ascii?Q?pQQQxbUEoDvQvEUwfp8FFB440WBu6GQPKosfLE1VXkWUBT4gLgptam4LeZMq?=
 =?us-ascii?Q?BDLd6jSbcLd3UVaM6Z1T6zn7ueHCjIZh56/MDZII49xJMAQL0k7z/vwE3UOZ?=
 =?us-ascii?Q?j/PGUp98JYsF6GnhLoalyDie5wUvj2Al9CxyCkPltz3jbSvj2MNnvbnEH+pr?=
 =?us-ascii?Q?NblnJUpKy5Mz1qdfXzBgxRqLxKMd2zoDZJHpVRrMtNe2pYOqMoQ2frQwnqIM?=
 =?us-ascii?Q?Xnyg2b+7nBP1JsUGXHEAG+rlGAPk+92v6878GAxm4TaYfB+IVMOFG90zMSl9?=
 =?us-ascii?Q?j6s1rzvhcmyksdMfZI+1tF0YADyaE4x12AmDhvV2XKyeWjSoZaBoklm1BIXH?=
 =?us-ascii?Q?XHZBz9JPm0aLg4/kgLX7bnBJa0/fZ0YvJnVaYD637U0gViFp1ojLdB81cb19?=
 =?us-ascii?Q?iRq7dD0H0laCoKzz9CvZgrR+6DUoK5mjhpvrxIuMwTskG992zRigARbpz2L+?=
 =?us-ascii?Q?/9nMsqXwXUPZei55fhwtQfjcJ8vghDaQuSqRI3p7brO7hKpairvUsOqO1tJv?=
 =?us-ascii?Q?vlMT33sAF5IevKHq/so5ajvf5JIMZwRS4HbljZaUYNJvFxwZfZG8B87uCd1T?=
 =?us-ascii?Q?SlzFafvPIRg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g64e5nQrZ4zME1m35PU/HclvbMMbXscatDEwFrDeWVlDgUHsaW0SW28Z2I5Y?=
 =?us-ascii?Q?Dl3POx2Np6zQZkAlJW28VER0GhFoBIKRJ2N0q454JdwaVC79dcSzN4dj5v63?=
 =?us-ascii?Q?hVgzP6QpHPGBdXK/H0nzlcLmNrV1PCHsS0FE0RdiyI917JQuEYuqkuo5QOMV?=
 =?us-ascii?Q?mnaeZb+owphldSMVQsg3eH4SuIt94fttf6/2pwFORhWwjX/xpMNKeoKicGvg?=
 =?us-ascii?Q?8FBWKd8u6CTdbg9W66XFTViaMNyvleB9J7D0Ho+W1OoimKYkXvyD8d8ctP7Z?=
 =?us-ascii?Q?AwXbv8OmJSTWk9n/DyMJwBxnZaWOakW5/m1soqkZhEMq+ZrOGoYknTNc161h?=
 =?us-ascii?Q?ZePtvnfNx4J1ByFLa0UVwzWK3zbjzyNWB4c1YpFFmV0ASMgP9awAf/HhMLTW?=
 =?us-ascii?Q?BdjpqhtOLmpiHUCM6YYURiasCR7R8JOM+5VMQDxZ520g00YZV4X7LiOEE+tD?=
 =?us-ascii?Q?oFHR7G2p2QMvYHKBDjXSP+Eq0aBlAUU3YWWFLHSy30JfD1DH/ggOs2ppoWp7?=
 =?us-ascii?Q?4mdgJlCag5Jql8b1JLpWz4X80XSDmHhJJuutVqkRwz7buf3VDxQRQHmhmpbL?=
 =?us-ascii?Q?oiweLPDRLEyUnNPDJ6CDbvJoeJM4MMPWKS/+2Ogv6tRQUsatR1Dozw45mLJq?=
 =?us-ascii?Q?hM/XeBZFiNlC9ExSF1XesH1LBFn7kEZQxXWlVg0XUBqyBrdgNbsI1d9yr/QZ?=
 =?us-ascii?Q?dO/iaZmHs7YdkCfka/8sQucNw4DGYfOR/2+m6Z5vtvhPPGXDv0V/nh7I+Ejn?=
 =?us-ascii?Q?NbClsNB/M13Xk58byVojajagQ3eHlhWMMRgDA6JnEGSQ9UP46h9CB1GhiiyT?=
 =?us-ascii?Q?Zxldamrx3ynCrVhjUCY6QSRTgYFplNKyHD4uw+VK3GL+6ADkI4syvzejcup3?=
 =?us-ascii?Q?SpT3wvlEPEOZlK3WH6saauCGrpiBbEo1gHZ+FUHnDKpx58B0ClJSNYCzeZxs?=
 =?us-ascii?Q?Ol5PiDo+aBzSu1dHCzdL/3Nd1OAPPqW74MZy235csYRE1eTrSk4R2mIZ9hVF?=
 =?us-ascii?Q?/R7v20tVx+pM4xHwsUyL0YIfmzSTCH1GKawe1iu6eVsnH94ErvVVDSIkyKEu?=
 =?us-ascii?Q?4sLZKBMss4m28W1hQs+CqMLhLygwrh8RiSpenlOqKEQMYfFB9ubPF85d8uDT?=
 =?us-ascii?Q?uyxhOqKJwXAhpXGlPboY6/lwMGnRg1AW+nTMmBkHIV1qcQH98wZa1vCIVhyl?=
 =?us-ascii?Q?c3MJfm40DN3GikdYQG6I/Zc1TezwWsPO7Z5mA3q6J9VmSxuDm9NGKf3XkStS?=
 =?us-ascii?Q?eg+ZDWDZi2rEgNByQHHbwn82LJl8pGVBmdwCVUS8Y88YCLTByFy3L50SYTCB?=
 =?us-ascii?Q?s5g8WkGw63hpXwD15xxRydw6OczVzfYrZRZOivyJ60T2NISjwMRSVBXb0z2A?=
 =?us-ascii?Q?wjRQraeL7vXfmucQ2RcDDMCcAjdN/XQJOod0nh0plB8CmZvBUuob3jP5S51a?=
 =?us-ascii?Q?oXr5tZPUJbifgMZn6NqFTNvM4hh8XIe6Yv/sK+Sqkoz22xJaMnPpDSbIluES?=
 =?us-ascii?Q?1qeASqlBxi9yRZeMUVm12+CnSV6g4mEHECLrHrTUL6bBA9iwG0sI9HY9Iwx9?=
 =?us-ascii?Q?FxEiZ9Hllo3ixBXqBPngY8vvYoPa63lO36zcvAqIjPnaP3bw+xQgfYrLcgTV?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 447cfbfb-555c-451d-b72c-08dd98e84988
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 04:22:39.2197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bgRNgrH088VBF/ZoD8oOaeBhSud4wb44p0PA+89RqrA9kPoDmkmpvaoF26iRyFZ3d0+7O5jlugrfiinqoD8Fxevkrp4zIGcuQ64Q+vcbcTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6495
X-OriginatorOrg: intel.com

On Tue, May 20, 2025 at 01:47:22PM -0700, Vishal Verma wrote:
> On Mon, 2025-05-19 at 12:28 -0700, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > monitor.sh runs for 50 seconds and spends 48 of those seconds sleeping
> > after sync. It sleeps for 3 seconds each time it restarts the monitor,
> > and 3 seconds before checking for expected log entries.
> > 
> > Add a wait_for_logfile_update() helper that waits a max of 3 seconds
> > for an expected string to appear N times in the logfile using tail -F.
> > 
> > Add a "monitor ready" log message to the monitor executable and wait
> > for that message once after monitor start. Note that if no DIMM has an
> > event flag set, there will be no log entry at startup. Always look for
> > the "monitor ready" message.
> > 
> > Expand the check_result() function to handle both the sync and wait
> > that were previously duplicated in inject_smart() and call_notify().
> > It now waits for the expected N of new log entries.
> > 
> > Again, looking for Tested-by Tags. Thanks!
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> Tested-by: Vishal Verma <vishal.l.verma@intel.com>
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> > 
> <snip>
> > +
> > +	if ! timeout 3s tail -n +1 -F "$logfile" | grep -m "$expect_count" -q "$expect_string"; then
> > +		echo "logfile not updated in 3 secs"
> > +		err "$LINENO"
> > +	fi
> 
> I was tempted to say something about a `set -o pipefail` before this,
> and it might be nice to add one?
> 
> It's not needed here since the grep will fail if the first part of the
> pipeline fails, and there's no chance of the pipeline eating your error
> in this case.
> 
> But it might be good practice to do it for scenarios like
> if ! cmd1 | cmd2 ... etc.

I looked at pipeline and it seems like it's be
1: grep no match
124: timeout expired
125+: anything else

I'll experiment with it.

> 
> 
> 
