Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F374849C
	for <nvdimm@lists.linux.dev>; Thu, 25 Sep 2025 00:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758760038; cv=fail; b=QsqLcxvyCRih/Yd+S6981mF1bVINgqQeqNrReoKP1mI01v7ULpQFJ9+5yvACZo1DEYcW4ROfPygSMGLzXN8bHOrBx0AtBoeTR5Uwul8X/IeYsmbzdO0i7ef3WMFwtn2VFizmNivfB8Nqxbb0vF9IC0vNBrgYS4um2d2XOh7SU3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758760038; c=relaxed/simple;
	bh=aAwu7XB7wkF4Z5lRqYq3dajuuuekRBPQ8s/p/auCysY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=psVPp/TdVzhSsdXidCPXIvP+7nJR2XTFZs+mEa57pn5M2xvdqh5ePW7p/gbFxRcQ/8L2JnUK/6mzH6y/gpxjQ+T10Gpvew/roKHUNRR9PytzkuhkJTVFgVovAa/Xmgkj3rTxSMbqYWBxw8WM1nsd7nYsIjqgRQ5HFHpvaKVm1eA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nlo3/wxo; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nlo3/wxo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758760036; x=1790296036;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aAwu7XB7wkF4Z5lRqYq3dajuuuekRBPQ8s/p/auCysY=;
  b=nlo3/wxoIOw8/4c8ctAj5m5S+XDUFgckgMnPHO6rozLWRPXdx/JtGn1a
   LmfID17kusf7+kOB/TtVBS++96UKpDoFKXJeEf3nkiYbbt2H5/ov509JL
   7BfP0atfQ9V2IHnENSrlAxL1BGOeCrMmiAnId6hJPtjzY8SCbwYvntrpX
   mXvZLS5lvMTop2kKxr9suRR8+Mw+Qc0fzJ3GIBAsYA6tfwe7LQGvBbxjK
   rr26eFpdxERXtv0e5kqt089wCcXZU2UjIQS6k8lHhOQEspW2w+xrRxE+l
   gJakH5D/5Bf8wJ6cuXJ+twITAlkFMtrb0pXKmMawrXrdDZcyjjU8E4ivK
   w==;
X-CSE-ConnectionGUID: KyAxTVyQQEiGtaRdJdk0nA==
X-CSE-MsgGUID: 3TW2WqXlRgWXFqTlzriSHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="86515599"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="86515599"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 17:27:15 -0700
X-CSE-ConnectionGUID: Hm44DitIR8yIYuD6WpYLKA==
X-CSE-MsgGUID: oUw/La/JRQS5jrVHzW6AoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="176470047"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 17:27:15 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 24 Sep 2025 17:27:14 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 24 Sep 2025 17:27:14 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.2) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Sep 2025 17:27:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=En03E2RdAQyx0yF64SHIliDUiNgn7Yfc8Sy++IydK4cmk4h+b1sPgH8Y2hz6+8ECV6tYnDjssb21ou+kQOfAqNh7981IMB7CIuPQm7s4h6gkYTXtnLhIO3rTWKJdMR6Iy229ecv9sOX1MWLoswTskSh363Xop7uV99a2bStns5wLpWrDDzVQr92npeyFd5Z0Yt3qb7QROXBzAykt75yHeXPl8XRr1o0DcbuDxbwO82PMJTDbT7FBCnWakDc+A5bw5gGzNpkIYuSG2h6hiOjJpkhMt9aCAe5JUrOaoW1Jdy/yJlgtBOYoQrnnxFS4rGJxJX0W5iwHaO8YAj9ZyvgN8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRMFAPCQ2viTRBfes3WnfUqv7zTjJVAWUFKsplqTkNE=;
 b=WpW333OcZsR85boy+1xeIEegYOOue/InFpnKNaGSiirVQU+Werbhutcp9MelBA9hJU8jlE745TAvZHgSrMB0KfrOopDcOwmOJ1IWyPkQeP5lj550VWkdOlk3yjZmcVzWg25ddO33ayZr7WPeEJTwofasKxwwv73A32eCFqqw1MOBMeXlIVeYtI2p5ZuD9ZsTlX0GmuI5MmLFcFzs3CDZ/dWdmXnHX6HBH7wLkdcC4+BeOnBeiKFNP6r5PC2oGR60XM9HOH64SwxZ0V3EqLVVG8pNQUYWEBjpqeJi59hP0sOyFu7WxQj/hKj61Y1AGu7pRDEpMUtnd6bv5ZlOhMuHXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by IA0PR11MB7815.namprd11.prod.outlook.com
 (2603:10b6:208:404::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Thu, 25 Sep
 2025 00:27:11 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9137.012; Thu, 25 Sep 2025
 00:27:10 +0000
Date: Wed, 24 Sep 2025 17:27:08 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <dan.j.williams@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Andreas Hasenack
	<andreas.hasenack@canonical.com>
Subject: Re: [ndctl PATCH v2] cxl/list: remove libtracefs build dependency
 for --media-errors
Message-ID: <aNSMXEP2YD3-MK3l@aschofie-mobl2.lan>
References: <20250924045302.90074-1-alison.schofield@intel.com>
 <68d47a5d13605_1c791001d@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <68d47a5d13605_1c791001d@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: BYAPR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:a03:74::30) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|IA0PR11MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: f6ae0790-5de0-4066-cafa-08ddfbca4469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9FQHdcN/ff60I7lYEbBd9EBXCf8vUu3oOUZQXBhw7fCU3CjNYgSF33MDkDZ5?=
 =?us-ascii?Q?rk2nKIghF+MeA8fhDdI4HWejGEKb2zuSmI+2ivUGjpHPiOUW53tSz+4hWMCj?=
 =?us-ascii?Q?kqNiJuyXlANAPEIv8NMIJe1NLLte7pvLVy8K6remMrd9PsbtDzh+CytMYuX4?=
 =?us-ascii?Q?PsukESu3bhx3vbK9UPtaao2ikwNZ/UlWKpqonZgE1ddTb+8tzIhZwg6+xO8y?=
 =?us-ascii?Q?2dv79mab4bYep4Xybm9xioyX2z8SrlQLwmH6eIPfg4ShgjauYHHL+5ufzG6d?=
 =?us-ascii?Q?BUj2XHDo8iO2Kv3aKS+T/GoLL9CeZ2D4AThHEWol1lK+0XQdmIJyH1/Kc3q/?=
 =?us-ascii?Q?QEn8mrw3nlVvbU5cJcj+jlM6PC/E4tdjcIbMtVQObhI0D8HlE4obCQ5vIvrL?=
 =?us-ascii?Q?IvQ3InWL4kt4kKokHwWlqhs8fwCSz+s/VCQYkd13lSxMEKhkCur4DWQTQzGP?=
 =?us-ascii?Q?OTGjrt7SmWoaJIPkexnqvpHijuy7sqhMC1DpoFVU77KiotP/Fr+MWGAU1O4d?=
 =?us-ascii?Q?/jI89kwhCWDtjj/498+1Q5dVekMXnVI++e4AgsF/HcrEmYCBUnE2RiP7RpPF?=
 =?us-ascii?Q?hbgePhoJwHHD/bAPTpLMJMGk8LN7iLNly/i+Ghpg3w94rIhegqvPJOlmsVqZ?=
 =?us-ascii?Q?MENzLITE++zi/FrYBPlv212fFkrF8Fb+Lx0ICuCTGTScn1avuFmyjk5TEvo7?=
 =?us-ascii?Q?LTJTdhQb4XT3C2oNzNJpt7IMqll+4jf7HI8GwM3iMymEGXKic00gN85WFx7i?=
 =?us-ascii?Q?+wpJzEgax2cPeXT+KMdSqFerm0oF1ZaJnZcus0izMEuOPuSv+SSdQITzkWcL?=
 =?us-ascii?Q?vJf+SfegSxXFI9YGJuJ2caPkIinohP8SbV1PnDVwtHxaWnj4W+EHXh+fl7H0?=
 =?us-ascii?Q?gv6ke38+bRWGSJMZpQamhp1TlbfoNABrLp4s5vq+HzMHvCqG0Upp7OWwsiw0?=
 =?us-ascii?Q?/PoxUQAFPGkSeLSyal2QI6NqxEfYxmJ/DTyVarnx+CdgnkD4cAiJokZutPoL?=
 =?us-ascii?Q?odSFbtXwoiaDfTQopxgD/qVn7efKVqkraN8RkDfx0Eui5V2sVdVRlKrZ0Lbx?=
 =?us-ascii?Q?C1JyLHYZmqhkXZ7bFPPz3BA4mwrFpO1mdWzvaJZRveyY5ATZJmE3/wtSiiym?=
 =?us-ascii?Q?9ZMtRJ/XyjO8R5NMoI0LbqtvOP3s7Y5T3A+b4kEpubMXg9PeJp+LjuxADZLz?=
 =?us-ascii?Q?w4WGq+zuBKFYzO/NYlu4XNPxd3oZylwrPeK0dZDmMo+orZETnn91JK2Ya1ZO?=
 =?us-ascii?Q?tRnTMcAMsa6Fv5ThH5dVWLB5DuBnGva4f2olN75iJYRHPOL1sqWHb6taYdgN?=
 =?us-ascii?Q?i+cONLTkZaaKk/Jf/mDIJdXXY+BDyO13qOu5z/PXlI5eAD+yzbJ2AZ46VPL4?=
 =?us-ascii?Q?WGMZNazJRITj7s5kCehz5pt1ltbafHW+SBjGSO4m8maKFN4yNOJhM7A5GutF?=
 =?us-ascii?Q?cwWEGbyfEdI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Pbjw06oJLUMw0kdof3/iV9EaWNshtpdkZ/eoUGsPJKJ4A3SDie2IH+mHxG2?=
 =?us-ascii?Q?axajO8Vy+u/3x+M4aSHk3eK0kShAZOEwhoMMGXK0xSPvva2p3BM+RiqgaJTt?=
 =?us-ascii?Q?x4q0dRJYr2JIfkW3fy+695z+UNTrvlmSZ4Gin2zRr245+jyer6c31acI5UO4?=
 =?us-ascii?Q?AI86uhftcPrQVHlmTOfDLUj5VqElcNnV8F/Fg5ta5AL9pEZJ0sKKjxxPUSaI?=
 =?us-ascii?Q?YDm3Lp/BqrVtzqCqu2swP464/njqPg3ZHFFtrixo3tRw3BcZMa1BWwDTkLdw?=
 =?us-ascii?Q?BLFnTUDV9yL8a0nxLuaDUknUoto5FQb2tby/NDiJIrILz3yWKIpOIz94udLH?=
 =?us-ascii?Q?6jretChG7yt9ZnF7sCcAbF/68N2Tx1ZczkoDz7cx1Od1+JQQD2nnJvlJcdZ6?=
 =?us-ascii?Q?dsF9XCruGrSl2b/3l67JrrSvxaLdyaCL0jQs0XL2QLV9cAGM3jJqUXCh05HA?=
 =?us-ascii?Q?rkBPw1IULrMOMNIVY1ujViA7LZwrbySM5pQyNOmZY8rxROuuRy0VqAHH090J?=
 =?us-ascii?Q?hY16SqdoZJNuBqLjDcLkURl1fKX/tCsPORozoLpGhFhA5xbbZqdeeLyKQScO?=
 =?us-ascii?Q?x7FB8ACLLxU9/j77yro1Fuk+ANd/zku3qU0mPYGRv017BDcfr3PKjE0qpTgH?=
 =?us-ascii?Q?K0ui0miiouQgMe9h40LFll4n/rj79VZL1UJ0T4g0Ox7tSbhHHGJWfpZqcx1Q?=
 =?us-ascii?Q?ka0/OwVRXLPmPP2RTEJOsKbzPNDansh/H8NcdTNCg8j/Qc+Ylyfg1dMqXWb3?=
 =?us-ascii?Q?vHwu3jvhwzXB6GYyhElrL7pJr4blPWXr7hl+REvky50Lo2C+sTomozkh6WQ9?=
 =?us-ascii?Q?YMOW7el3RzSAyT/0kyEkipOByCatmaWhRYLA5g/Q7AVbjDnITsYlzyBQmszM?=
 =?us-ascii?Q?SZN6xZYC967XNz9IOuR5cf+SL68gG54nMB6X7fh5pzgWUZvN/T64M0Vt1VJ0?=
 =?us-ascii?Q?HmhNr/LwqgqJWYUwQI5LgCVCBOW43l6EUoEiZ1pZ4t6tRnYndyCrLy5XUNt+?=
 =?us-ascii?Q?8WdhOXpgwYd9I3LqM9d+NR6Wxfz7Ey2Cf56sMvneXJKxL6BAYdjcp8lXOxg5?=
 =?us-ascii?Q?IFTVp0LP6j0CYt/EMhOWliIZXtJo7EQvwe5y2eo74PKwGE5w+uSY2e3Q3Vfn?=
 =?us-ascii?Q?CDCsMQx0UjS7O2xGNKwD2qgONaKgBT1rcw0r2NOsbP075Ax1GPwvkL58T/3T?=
 =?us-ascii?Q?9PyzvugKVn/gpuwr7ymYjWju1/al+ylDPxNrikvroL5DibJdA9EQkLy8sg9i?=
 =?us-ascii?Q?nxjROTfYobJSgRdc4fuEbXjQkg4Zbc4/EhFjmLyMQG8OPDKfxrf0JZBIOrsU?=
 =?us-ascii?Q?qJhCO9xDOAD3WD9BrKBeJGFOeNMrlwC7O44Y6yYjyZ8nVyeblonrxMMbiMEU?=
 =?us-ascii?Q?XKgk3GPphWc0BYyTNsWh1cIbwIgIsM/LZGKBfRg7d4r+7F6KUwowSnu9kPO3?=
 =?us-ascii?Q?CAVWVn2u8Y5mGMRBceZgzuwd46vUbHoOE5T2CV/5GudAP2k5ng3kiqjYwJWK?=
 =?us-ascii?Q?wXusaxsp6NBM7pyh+vJF8UrvPSF0YED42G44LojH0t0+Af/aR5Pj5mXn+9CZ?=
 =?us-ascii?Q?OlPjnEQsfGSGZIqjBG6u3U6f8R+9PgeVtOaBlX1kDjZfjsPoT/rbsx3ZXf6T?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ae0790-5de0-4066-cafa-08ddfbca4469
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 00:27:10.9164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5IMpmfe64lKjM6XmhmSKDPqOQtoOsakjFpiLMmDoL/D9nMAcUfigAfA1hzcleUlstbPVQhFIEBO7dfpwOUJypWtjM9a8J9ODeAs9pi2btik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7815
X-OriginatorOrg: intel.com

On Wed, Sep 24, 2025 at 04:10:21PM -0700, Dan Williams wrote:
> Alison Schofield wrote:
> > When the --media-errors option was added to cxl list it inadvertently
> > changed the optional libtracefs requirement into a mandatory one.
> > Ndctl versions 80,81,82 no longer build without libtracefs.
> > 
> > Remove that dependency.
> > 
> > When libtracefs is disabled the user will see a 'Notice' level
> > message, like this:
> > 	$ cxl list -r region0 --media-errors --targets
> > 	cxl list: cmd_list: --media-errors support disabled at build time
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
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> > 
> > Changes in v2:
> > - Notify and continue when --media-error info is unavailable (Dan)
> > 
> > 
> >  Documentation/cxl/cxl-list.txt |  2 ++
> >  config.h.meson                 |  2 +-
> >  cxl/json.c                     | 15 ++++++++++++++-
> >  cxl/list.c                     |  6 ++++++
> >  test/meson.build               |  9 +++++++--
> >  5 files changed, 30 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > index 9a9911e7dd9b..0595638ee054 100644
> > --- a/Documentation/cxl/cxl-list.txt
> > +++ b/Documentation/cxl/cxl-list.txt
> > @@ -425,6 +425,8 @@ OPTIONS
> >  	"source:" is one of: External, Internal, Injected, Vendor Specific,
> >  	or Unknown, as defined in CXL Specification v3.1 Table 8-140.
> >  
> > +The media-errors option is only available with '-Dlibtracefs=enabled'.
> > +
> >  ----
> >  # cxl list -m mem9 --media-errors -u
> >  {
> > diff --git a/config.h.meson b/config.h.meson
> > index f75db3e6360f..e8539f8d04df 100644
> > --- a/config.h.meson
> > +++ b/config.h.meson
> > @@ -19,7 +19,7 @@
> >  /* ndctl test support */
> >  #mesondefine ENABLE_TEST
> >  
> > -/* cxl monitor support */
> > +/* cxl monitor and cxl list --media-errors support */
> >  #mesondefine ENABLE_LIBTRACEFS
> >  
> >  /* Define to 1 if big-endian-arch */
> > diff --git a/cxl/json.c b/cxl/json.c
> > index e65bd803b706..a75928bf43ed 100644
> > --- a/cxl/json.c
> > +++ b/cxl/json.c
> > @@ -9,12 +9,15 @@
> >  #include <json-c/json.h>
> >  #include <json-c/printbuf.h>
> >  #include <ccan/short_types/short_types.h>
> > +
> > +#ifdef ENABLE_LIBTRACEFS
> >  #include <tracefs.h>
> > +#include "../util/event_trace.h"
> > +#endif
> 
> Maybe this is my kernel taste leaking through, but I am allergic to
> ifdef in ".c" files. In this case you could move the include of
> tracefs.h into event_trace.h and then ifdef guard all the parts of
> event_trace.h that need tracefs.h.
> 
> >  
> >  #include "filter.h"
> >  #include "json.h"
> >  #include "../daxctl/json.h"
> > -#include "../util/event_trace.h"
> >  
> >  #define CXL_FW_VERSION_STR_LEN	16
> >  #define CXL_FW_MAX_SLOTS	4
> > @@ -575,6 +578,7 @@ err_jobj:
> >  	return NULL;
> >  }
> >  
> > +#ifdef ENABLE_LIBTRACEFS
> >  /* CXL Spec 3.1 Table 8-140 Media Error Record */
> >  #define CXL_POISON_SOURCE_MAX 7
> >  static const char *const poison_source[] = { "Unknown", "External", "Internal",
> > @@ -753,6 +757,15 @@ err_free:
> >  	tracefs_instance_free(inst);
> >  	return jpoison;
> >  }
> > +#else
> > +static struct json_object *
> > +util_cxl_poison_list_to_json(struct cxl_region *region,
> > +			     struct cxl_memdev *memdev,
> > +			     unsigned long flags)
> > +{
> > +	return NULL;
> > +}
> > +#endif
> 
> This would move a new conditionally compiled ".c" file for just these
> trace helpers.
> 
> >  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
> >  		unsigned long flags)
> > diff --git a/cxl/list.c b/cxl/list.c
> > index 0b25d78248d5..48bd1ebc3c0e 100644
> > --- a/cxl/list.c
> > +++ b/cxl/list.c
> > @@ -146,6 +146,12 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
> >  		param.ctx.log_priority = LOG_DEBUG;
> >  	}
> >  
> > +#ifndef ENABLE_LIBTRACEFS
> > +	if (param.media_errors) {
> > +		notice(&param, "--media-errors support disabled at build time\n");
> > +		param.media_errors = false;
> > +	}
> > +#endif
> 
> This would be a static inline helper in a header file that optionally
> reports the problem.
> 
> All that said, I am not the maintainer so go with what you want, but
> leaking ifdef in ".c" is, in my opinion, a slow walk into an
> increasingly unreadable code base.

I can do what you suggest, with bells on!
See you in v3 :)

