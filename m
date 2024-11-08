Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D491A9B22
	for <nvdimm@lists.linux.dev>; Fri,  8 Nov 2024 20:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731097079; cv=fail; b=CLPWbOqVRKmDeL9q84yCB7ufSj4TytIa0a9o1W6XBa7NgrI0EPJAfFR3F77LXJywznXQBrjyfSQbi/ri29WyRHyCr5EKM6IPGjJXn3x2Je28Ku5sA94javzgy5+rCXlGcIjJxxD22CjC8vYyjLzC9AM5x9CsX2g9mg1nI5YBJHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731097079; c=relaxed/simple;
	bh=i7aFqdcOpJACdMC5CWnOWX76ADBF2RR8z0Y2CwEF4f4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GAuKvujO0tQWWs6x6Qk/ERx7Ae1uV2A6MKEXyyxkRRNJd7BZA93Mo3XS6J+TfZmhUXS+WfHlFRaCJVLW/vO/C4/3Ao6aYZWHnSFqq5xHpmyetY5du8nN09k7ixoXTSHr/UmuB5yDesLXG2MQsEfuwon9wEcKME6aeGKadTkYCpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=APuFdt6w; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="APuFdt6w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731097078; x=1762633078;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=i7aFqdcOpJACdMC5CWnOWX76ADBF2RR8z0Y2CwEF4f4=;
  b=APuFdt6wivEXVakPFyORa+G2SwscblvlQHUZLcQ1gzd2Ec1t3IdFj5ha
   ZqiUY5HDJRJB5GPBnPUEJJgj34E0bnJHwYO87uOICQVG8iW3MMXWhFpOI
   pCjgQod9+UCEs3ts8CXt9H68SK8DwceFLMY1bKq/M4+d/3JrURNZPSP3V
   maAwnfRjPTeocz8gpr8PA3kg2MnpOBOD72ioF+hH9dhr/d7V7LLMV6tdr
   JOQ7potvBpXXrwaR8tBg82x8X708MqynpcDWXII8U8VjhKejbqxTaJUHU
   9cLWOLNuqDHjdp7WhjoExSpQ62mctinxIyf34obX9YbOcx0Ax/z1/ao6+
   Q==;
X-CSE-ConnectionGUID: XqSaqGOJS5yYu2ZG8XngIw==
X-CSE-MsgGUID: pep3kLssTJCt9hwmTdkpZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11250"; a="30409360"
X-IronPort-AV: E=Sophos;i="6.12,138,1728975600"; 
   d="scan'208";a="30409360"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 12:17:57 -0800
X-CSE-ConnectionGUID: knyOHk1TTh6HdN/0PtyfLg==
X-CSE-MsgGUID: 2/0CQunBT/GYVBgIi+pJng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,138,1728975600"; 
   d="scan'208";a="116573004"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Nov 2024 12:17:57 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 8 Nov 2024 12:17:56 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 8 Nov 2024 12:17:56 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 8 Nov 2024 12:17:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wzh6RSN8Rlu5GBM0sOV6knCBWONCQtz9C2hxLIeQDhNtt+RfbhZjzdTjde57iNqLHWXJ/KLu35Cve84rvlwjtbvjKPHfJnw8WwFFqb/CTbbjNZfSl+ezv/rr1PZI+iZBiXThycLPKFFSajoHlf7B/QeWykiHhuVgzbjdSwCtiIPqki2JK8b1C67sLRu0OblkGh/sRkvwrJNOhLYaJzYgoz+byd+nExnnwEbyNb4TYHvjrT1kumjetTwr+EWevSauq44GaJnauWdGakmlJmEqnRqmJphslucvnuXk9cdPuxMI3EL17oO8fzorsQmRfFgLPrlDBZL4wGgx/NOp4jrRSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gk7O6CDLZEOKExEpfrEmX2MUgkQHqEcxI/c20R36tZU=;
 b=FyDcqHJbAUGkgFgV9V3ex02g/c0nlvXwiaX3IFpfr3u6ojshcjvRHjDer0iB+kpwVhGq8zpd1q2bhUYb+f8lAJd/X5G9iSQvvncC/c0qANSJe1aOe8HpfbUSRdVn5VCvYNaVg+6rNG5Kno9hfJMOCxkwjzkPiwJ2NJZUxlukHkoQGbeNDBSHxEpu41isuTaW0xYpdqKaEFAN4dB0PBlMURXyJhBdye4FvUqKezHQeVfwJZvqDBnKNnSOhaGZvrodrBeOHJNmc2f0FET7RVB3crbq+7DML+1uqZYELx4HHoXy/DseNVDAol2EiH7//hy/yUOEN1jvRHWkF2B5zFioxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by BL3PR11MB6316.namprd11.prod.outlook.com (2603:10b6:208:3b3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Fri, 8 Nov
 2024 20:17:53 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%2]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 20:17:53 +0000
Date: Fri, 8 Nov 2024 14:17:50 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, <ira.weiny@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>, Navneet Singh
	<navneet.singh@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Sushant1 Kumar <sushant1.kumar@intel.com>
Subject: Re: [ndctl PATCH v2 4/6] cxl/region: Add creation of Dynamic
 capacity regions
Message-ID: <672e71ee63f20_1b17eb29454@iweiny-mobl.notmuch>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-4-be057b479eeb@intel.com>
 <Zy0Mb13kB5fOiqio@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zy0Mb13kB5fOiqio@aschofie-mobl2.lan>
X-ClientProxiedBy: MW4PR04CA0241.namprd04.prod.outlook.com
 (2603:10b6:303:88::6) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|BL3PR11MB6316:EE_
X-MS-Office365-Filtering-Correlation-Id: d2121766-f701-4268-bfce-08dd00326d17
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ljH1h9wf+jPtjFVnby3hqXkRlU6UbrYPf4OOH3JGCZeVEDw4t8xR5nE7q4LF?=
 =?us-ascii?Q?AjGfy+JgNs0c+MkWRnBEDFMM9QdVHa7iP6HZsBUBC4YV5N3OjKw5qmKmm40J?=
 =?us-ascii?Q?22faU48bUbZLdukSk/UVUROpupDXb2r81MxG0xdYl9tiwWrjaLKa5XaO/dVn?=
 =?us-ascii?Q?ND8mDMeL5ATG4dnN8i/9pYvjYE7TJlMpswTRG6bY+gBFPaZa9hyRtXb2DwR5?=
 =?us-ascii?Q?VrBPaHS1LGl89zygzWfwjja8Rq1xZjbPVxNcTOCldEj7ZfRb4STFNrxL2HUx?=
 =?us-ascii?Q?g5pRUsszZjMdi8vaN3neS2UFpX1sSTSQGqVMG4EyALafjnhlc8j+93LhuA9Y?=
 =?us-ascii?Q?mwKeXuPZMUpaRTi1cQwvX08zd6nqLo085nyg98zv7otqjyB/C38bASw8hZhQ?=
 =?us-ascii?Q?Z4/yr31dfHCbNcoUJ8l8srDkxpH2XEb1duA9xONi2QIxdzhGZZbiSf1EPqeX?=
 =?us-ascii?Q?GnUQODQq8Ywf4SJ81s9F7I2SOzeDz6IYd3PfBZo0l5zcs1OpHpRGiTxP66x1?=
 =?us-ascii?Q?mws3SRUXBZXVu5l8GCn0PFR2eaL/YerXXdE1+0GTXCyd0qwV6x7v8CSbKBBJ?=
 =?us-ascii?Q?zyEffn958JZ2/Bwendc9QFjI9DyQuY7FC063THwx3yF4nglUcpAbO48qStjW?=
 =?us-ascii?Q?hW5LNVKpRMPzJ9+0o0x7kfn+pq4e2123UVF8T+JYUfGioC2j4Dy0+8YmJGaP?=
 =?us-ascii?Q?hrUMMnuDCVkpoc4JLECv0bFMCISyuYb6WU675kfffFtxSJn6CzfmKBsT5W5y?=
 =?us-ascii?Q?rbaYmsK14cGIKOAl/PVnzk6ZUP01C5EFDwYsABAfaHVLVGMSJ8qRrFygK1jy?=
 =?us-ascii?Q?FHUCg0b9Et2MfF05JKcfMcYdJQRnLJmo2EvRjTTVCcHkv23CTr7wIkLdxpjb?=
 =?us-ascii?Q?oI6VI9yHPm6jXwA03PY11oCp2MARQOsPTNsOz/LW0Da4QTx6i0oSSmj4hYc5?=
 =?us-ascii?Q?Pdlt6vSsOvf8a1lx2BvQy/lcZmqEmJWB8XDxmE4QQp1Bzs047vV0JNaGUzj1?=
 =?us-ascii?Q?MpfXKEOBZ1+6HXfnmlFMIMebFdl1rAcyHe0c3mtZNaKEfMTR7cjdMZa1c0az?=
 =?us-ascii?Q?lEzLwVymQSzvdxvtVYw2PK+w6JB7IL39Z5lE5oIBfBKtLF59sPi46GnVPYNL?=
 =?us-ascii?Q?kvziHF21ygiPiMKOfG7p0kJ1gRDxNeIZ15WIEsev6lfBk6Broaf7/XDfLOF0?=
 =?us-ascii?Q?adtjoDF9owmItx8R6EerI/vyjEVbsAhu4Lk+othwH0KN7Ade3bzwrtBTTdmf?=
 =?us-ascii?Q?cMQ35zuQNbrvEKlwfBISH56OW8gFkuqsTfVlAfCErne2F/tJPg2NAZx9McYZ?=
 =?us-ascii?Q?EGedzTXN+j6ave7ykBihxiDX?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G1JsuYVdCMPQm8fkAsPZt6HH+TE5tG/a3BcmQZopVVC3w8c9NlbF3eswUn+H?=
 =?us-ascii?Q?g4XbaX/QakLm9P6R7xvsfd3Myx0TOJdZVp/YAf1eH+kG+MAO7SIjFCleef1K?=
 =?us-ascii?Q?utOJo811Uufq5Ae+0CJU/UGK6nolbDZ+4oWRE7FkjpO8kobu+Z0SVO1/zpNW?=
 =?us-ascii?Q?eyg3sttjBlUYEZ5CzbO/ywRWEe6vIdqYHSepF7cj+RyI9jy9QhdGej6YBmIh?=
 =?us-ascii?Q?b4jegE4nCRonslxH8tZcUwW9JwDbIqw7MFR/+yY5iqCd941Fp7polOn7vPaO?=
 =?us-ascii?Q?xVS7u+apN1LxzkZKSM58I9UT/idFfDJD8rj9ok918Jk2xqKFoY45luajgITh?=
 =?us-ascii?Q?gOTWWmaqmRu1evWiJEzcHRVrqVpcMrhjGH2rPaUjqj+YTgB4ulocqclSObHr?=
 =?us-ascii?Q?H/hH/So15Kr5AnUO2KJmKfkbASXsQMSUPRwKOMh5i3jCFI7/n+DzW+iJHhPi?=
 =?us-ascii?Q?dmTKLekpWObkLud0PirLBKkU9HV31h0ogDL/gLDmCX9YlpWcuG1umJvQmCbN?=
 =?us-ascii?Q?ONz8S69YjSOxyw0R3oDPWrlK4jpu3L5+w0Wo0k0AKAhqQ+u2yOaLeAAX+WNK?=
 =?us-ascii?Q?o7F9yrGm7JZ4lTsX66+2WtAsSOfNJCz76RBsWevYbRXDPlgM1cOgJGgSEM5I?=
 =?us-ascii?Q?pQoXXZTSOIGVxF2G3fnGErOeXoSssnnjaIVRZjDh75zSf9Xm69wJNnyaW35s?=
 =?us-ascii?Q?4llvuJfrE8asDL2dgIwFA95aPe1scgYzY8a0GjTj137oLxu+6YTjjm2yJxBP?=
 =?us-ascii?Q?preP6qGiDCFJgBqIRWOkKJ/hSAQfAYWMqpxx7hBKRX8tMEcWQA1MNKAlXoL/?=
 =?us-ascii?Q?16mKSoQ+GaUCApJcx1piH7MsibPFMXulIb3Bp8VrS/dFcwZXAhWou9ttZs8A?=
 =?us-ascii?Q?KzadvWm9C0KD08VUmuq98kL9uWbXl5SJBt0u+87/ve6DimH1tYtx4b3WvkDH?=
 =?us-ascii?Q?7S+BoLNDzAXWFf01mSOuCN65bCfK1DqKgQMrj3jm9PhIojEkM+C/gAjVMPmL?=
 =?us-ascii?Q?M8WrGMjvmIh6kYsGaspeNLz+omD/c4iLcOfCRxWqkrOD+cg0VNmar09+BaQd?=
 =?us-ascii?Q?u19VRLtfEJwOzQ7s1HrR+8Oj9wVidMTRURO/WQecmTv4C6lTTDnRDWlufI1h?=
 =?us-ascii?Q?NLfFJsHxrWlbaV5UctF0eA63cszvdrMplKbhbRdMZiI155bxMUHOEKVioDBt?=
 =?us-ascii?Q?1+Pt3G7RAzg/KjQm5HKtZF8zuHUaDKBcnVkE0V4qxKl9ijszTaX1LVBcb7Ux?=
 =?us-ascii?Q?3z+Wu7THDLvA3JyAR2AvH/PgwuQ5qQIdVwzJQBIO3QuN9Bx9ZVGjstXxLVar?=
 =?us-ascii?Q?dGNVkRgt3Ti7hakz1XKcwJAYn2RVGbn3bnobjMG6nD73uvlEl7HD88AvVkbc?=
 =?us-ascii?Q?nPaSh72Qz1inFy/GH1LQ7nJPYB8XKKUuGui93QB8mMvR8VGXpFsyCSbph2OQ?=
 =?us-ascii?Q?CW22v1+fLz2buB/svpuyoA0fddGJP2FpstnSjBlHgd56E42UhH4mBENcAxtO?=
 =?us-ascii?Q?nk+nmf+Bb/NcuLpV79AoKYdDxpNaV/MjuDoOwb5szIzrkVdJJ7tUcySfbYxt?=
 =?us-ascii?Q?UmgCUSy6IPzvzjGeqgQWu8nxBMonY7UJ9dzcxu6b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2121766-f701-4268-bfce-08dd00326d17
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 20:17:53.7197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8bDkr1UM2QvfD+lm1iVjfE/CaO4Rjios4iFKVGHNzmpWtALLNHU7XHkQY53ZskmADP4UlIOqvCFnFLQ/NdKsVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6316
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Mon, Nov 04, 2024 at 08:10:48PM -0600, Ira Weiny wrote:
> > From: Navneet Singh <navneet.singh@intel.com>
> > 
> > CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
> > with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
> > spare and defined as dynamic capacity (dc).
> > 
> > Add support for DCD devices.  Query for DCD capabilities.  Add the
> > ability to add DC partitions to a CXL DC region.
> > 
> > Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> > Co-authored-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> > Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> > Co-authored-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>  
> Since you are submitting as a Co-developer, according to this:
> 
> https://docs.kernel.org/process/submitting-patches.html
> 
> it should look like this: 
> 
> Co-developed-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> I recognize the Co-authored-by Tag as commonly used w github,
> while ndctl follows the kernel customs 
> 

I've changed it.  And have carried that with the split of the patch

Ira
