Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5942C11D7
	for <nvdimm@lists.linux.dev>; Wed, 21 Jan 2026 00:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768956095; cv=fail; b=WbVJzgm5Wl9zpN5vpL695qThSB+nZ2ycqZB+Mq343Vp52fgkf+zG8DPppgmpjDDfB4JtB7PR1Y6B18mm00Te5Q2GGMNCZziEvVHn2okD8VfwlEaTUbod0XPkEYMUFOwGvXmkUjA62ziQp2f5JsvlgYpStzIbk6Njpk6POvuBAd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768956095; c=relaxed/simple;
	bh=ZmS/yHSDu6g9+06z4eZlnQt0XIkmm43DaK4WegjimqQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m+fxyv+zG1LUGx/vHs/qQvqYZnc7JzXXUua8DIbD3YjJIMivrjJoeWngO90+qTEDdzwRcH/5+IQFGM7fJXgJD0OAoSfoPih/+QT444YGreMRdTPcGRegeOkdouVrtFJ6midlBXw/dcZRihjKlWX17q48HxhUfR0RxQgo5XWkRQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N5JVrn8h; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N5JVrn8h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768956094; x=1800492094;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZmS/yHSDu6g9+06z4eZlnQt0XIkmm43DaK4WegjimqQ=;
  b=N5JVrn8hbWAC5mo9ChuP+mfeyu+BL4zakS4HVJ2K9PHBBJ9yOfHkBDng
   D18Lytvgr67495+FXJutgtPAoDk7iaLNOc3jzTuONsKq+DRWp5uPKPnVW
   1K/86XKE+dOKprdAi13j+gPBZoX1TiXukM90nXseYl4KsfL8POer89t4f
   gequCQnjRifkKwkV1xU06HOZkbcYDj2jnyANJxxeQKW/FHpXabM5Lyd14
   DNFJ2BbocCsybIdWXp13CVjVt0j9fYTx0LYIj8YmWWdl9LEWmlL92ECPI
   o0RqnCTncBp0Hf6NY928DuFyqpcpMnsR10R+ImrvxWosRiZvxRawtsAQ2
   w==;
X-CSE-ConnectionGUID: vSZr+uJ8QueRM86jpmVLyQ==
X-CSE-MsgGUID: foDI2UlFTXiBHwWySY7Bmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="80483915"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="80483915"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:41:34 -0800
X-CSE-ConnectionGUID: jQYlXYFRQlWdvJufkF4B6w==
X-CSE-MsgGUID: AqBBIL2QTFi8UEms3UYTJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206080059"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:41:34 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:41:33 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 16:41:33 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.54) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:41:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cVpBjIZZ5gstdfajDqG7XCUoshZUxcArHzHeH21+YVliPiaj5ksT/oEUEkjsraWc1EFk833L29ZNh5L4rB1caplMH16hkVA88mIMDGhy6esq7BnpsmoZPpi46z/K5+dYudVBMAEOe5XLpnK27IALH7a7izEsdDMDghzi08Uz+7kTazPFroBeudNEOQ4bS2sb80O+qnrpIyBlsCfOzwZMvy8KJ20x7NdhCfwFqdjh8mTtWAX48HORsEDVECzgyjU/iXpdqxhGT9p9BBRWQU7iKnLZKTH9uqAKCJgMBlJSaZlubVunwbo19xXgnydV1oCJ1lJCh9CveTAhDMfVGiVsew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQ9IGL5FfqA3Hhe4CBP1LL+k4U3dXI3j83uJFVYqeuk=;
 b=NmJYbwhDzugG3BI8obRoKYn3jgB9wRKg2n0QMmGU8vaciulILgIpqposOrKttdl3pj9hEYviSyi//tMhQqvl/5FcshpqFn+nLV8ZH10EDq8tKsu4lxpkAOEsx0k4ScKPwkmOfQDCMXTvLb58nAJfvAqoKpHEiiT5SLfn855N4/ofauG+qnpcz0p42V4iFyUe6AY2L6z32fz7pQ7hjMoN4F2BQFyIcBQy7/r1Jktg46nVB8XEdrOsw97quKga5QH+PHYJ+LpYCd82T1mXwqX/by8zhm+1q57AiHuq8F5F0c56qhMN4hz7ogKySjmVmSqwV8TjENsZNeiTZkddOHZPfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by DS0PR11MB8229.namprd11.prod.outlook.com (2603:10b6:8:15e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Wed, 21 Jan
 2026 00:41:30 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 00:41:30 +0000
Date: Tue, 20 Jan 2026 18:44:40 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V5 07/17] nvdimm/label: Add region label delete support
Message-ID: <69702178e2942_1a50d410011@iweiny-mobl.notmuch>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
 <CGME20260109124519epcas5p44c534dd371d670f569277bd2eaa825a7@epcas5p4.samsung.com>
 <20260109124437.4025893-8-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260109124437.4025893-8-s.neeraj@samsung.com>
X-ClientProxiedBy: SJ0PR13CA0222.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::17) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|DS0PR11MB8229:EE_
X-MS-Office365-Filtering-Correlation-Id: 96ac8a66-2b1e-43f0-6391-08de5885d1a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2vvxN1ltJabXaaG8BlFat4VuhVo2FukpJu1LEH1K3qLvSX2t0PzzGOZRebiD?=
 =?us-ascii?Q?BJ2YKBix/iL0u6wJj/Qfe1iLBPVQTx7SodFBcFUFoNk0pFoYSpyLCzXXXXNd?=
 =?us-ascii?Q?5JGakrYlNXUbL+qLe2HQRjg5cSzb+SRdfZohnrkJFZpXLW5S2aHawLcxVxuH?=
 =?us-ascii?Q?Zab09AmlQjnJW8z2guWjN04X7GjweMec23CAFaqKwSXn62q4WGMmxSLpaGtW?=
 =?us-ascii?Q?Yuafqu4Ml6X2a0GnsPwI8afSH/TdBb+aAb7ezxcvac+ywug/8hgcocNvih20?=
 =?us-ascii?Q?WRRD3a9jnTRHrzBIKHGEnCO7n1nkEestkKxBf8CxSpUkEpmj583Wf7CE1lxs?=
 =?us-ascii?Q?jgVq3cxbtFoyK0E7Rh1JUQxSlMNBt52Tgcd70rHL0NE7134rAwRGdOGOcjdP?=
 =?us-ascii?Q?C6IgzmnSoxXObiobTon2wBEKFktL+h2wM9KrFPmelgFQJQ71nBDWpDcQDj41?=
 =?us-ascii?Q?9RjNiXEcJRwcl9eChaRGv+1WLmylYwT5kRcLyrUB4kHAUnY4aMWfMDxyl9JD?=
 =?us-ascii?Q?AkLupKQqz19p4TQA8DP9gvchILvRFMdsiynj3Ls/OcZn2qGbDhwKMsLadQ7F?=
 =?us-ascii?Q?/+VBR825svQtB366VfN5iHELN6ZI6qmaiG61749sRXT52MyVBc5klerQ0EuV?=
 =?us-ascii?Q?LjZIJtj9ocTEQmRJng+0k4c+GzcEEnm8Ial6+pcGNWNdwNctHjmt+SDSxh9X?=
 =?us-ascii?Q?rSvaFC+SRcTjw6Jxq5e2vmd7mp32ZKtnqdy1M1uhu4g5zqCP6Om1eCFv4O5a?=
 =?us-ascii?Q?3NbpUK4gsTHdvlevQ6XFBa93u+XggLTwrGcPnPcqCM7IC0n1mVM98+0Wfq7o?=
 =?us-ascii?Q?jygfJorzazMVNlvEZGxhbLwn4zDuxPf+NdxpAO6WJjJPR26TOdL/imUuhD7B?=
 =?us-ascii?Q?GH4OPqT2aiiXiidsATNq8QseLrxStUwiZmByAxAQwaptztAKAtGJit2C22Ly?=
 =?us-ascii?Q?SXHBPceawFWiMGL2Yh0rqfWn3v1ZBtAn6A2Y0nkCEmXWGE0hnEVIVzsYI1Kk?=
 =?us-ascii?Q?hbSyRZGXLFezYliMsLus0cZk+fx2SAqrYQ0dRBr4rAlqqbICyb9O396ETMoq?=
 =?us-ascii?Q?IPh6GxtH7a3L0MVncgF7HcLOtdqhevPpvlezktSLW3+4JNtv9BWXOXJGB1Mm?=
 =?us-ascii?Q?yMCn8KnDUHaKVQZAOAUpK38zKm66fi2xrlECx5gpvgGhS5KXw7HX9GzTPvmb?=
 =?us-ascii?Q?X9xnDM8J/mwXodFeFGDH6zMDG32OgC8zGf5GfwDCHrm0n/EYXrihwOj8oOZk?=
 =?us-ascii?Q?BAaAt/MKSVO5Wq/WaH9ALiliLTIKD70NAjPb12kuheCwqTsQOXBHqlQBh6Dj?=
 =?us-ascii?Q?GUijL8GF219O3/22B4Nu8zubOaUgV12QyFMzB3JxHx6mgMiqImRKQ9xusTzN?=
 =?us-ascii?Q?ec6TmMGZJdbcwZKy60D3K5kc7Ihkqp1iz2cw+NnryWVBahoM+GIXJd8Lv8vb?=
 =?us-ascii?Q?ndttVEE/r/5oOEHWvL2UrxJA30EEUiaBEMQGc0Hjqb2zUohjnffSjbF+LEew?=
 =?us-ascii?Q?d5Lo65OKRAX7HD9pLpZzO1XY6eYlfS5cqjDGUgGX940iPjllXl1vuT2nP6TI?=
 =?us-ascii?Q?YykGAtrm5QGJ7+sIlW0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cTWpNVg7AheoiNwwysBCdmg04sLrJLiFs1AfT5o/6Rt/x1PqKGlxX8/KAwDR?=
 =?us-ascii?Q?ptoWIzykOzId6nzMCvdj3RxwKFfDRvdLwMnEEU5xOfQFvtn5PDEENFQsavQ2?=
 =?us-ascii?Q?zYDJAd5PsCJuugGTiSvlaIihKbX9Njou2GbVhTUwEMWFl2bopaX2yx1lgxuN?=
 =?us-ascii?Q?ChcQuBHNXXF1RSAn0x3r7H7FpIG5pYq78J+uR1j4BuiNkDXo+SToOTnOHngc?=
 =?us-ascii?Q?YUrOXGE1jK5e1Mr3I9YGu1GoCdzX84lAVUf2oZMioxvmiwtwqwMwUV9at18R?=
 =?us-ascii?Q?AAwxQwRwIKAHKfl23otbpCI3MbEBG73ka1V+DbsXip1S+WAm998Cg1qLSk8y?=
 =?us-ascii?Q?G/NpOR7XeLtGzZOG83jMPaVpeGeuCjwkzRHm8zFRo75Cj7bzxrDqbCU+JDLz?=
 =?us-ascii?Q?/sm3TbJESrYWT9qPoJ1spHxXbhlzkZV4UGtm87/gKzgRYmk47SNAXMr3nlY0?=
 =?us-ascii?Q?1aD3apYyPJtTkSPO6WwmvsTI0q4ESYfMC5BjtApBJ1qZTq6fdD++RXiQfj0o?=
 =?us-ascii?Q?IH7H3v3pnicyAwXyZEB5UtU72Hflv43kXakyw+RRKkUjw6KfbdeAD/CO04TB?=
 =?us-ascii?Q?o7IH/cPkci9uALoTezK8makLzuy0Uhu5wlX06l7kXsjHehcEVKzaV0zBfXCu?=
 =?us-ascii?Q?AevsDacNRLUnLtLEH6Byh5VF3fLgXeP6JE/qBtAy++fG9U6pRsgdnXOJmVWH?=
 =?us-ascii?Q?xw0bZw/XSrB9ZODQ2ymtzzwuEczHRr/2X3afrgCpilWVIQ12/2x5tgrHKBzA?=
 =?us-ascii?Q?YTNu7S9OsQlON/pj7vbbLqthQT4OPeOuZeL97pwZ1ppSkYCyM2RZEE8zQXgP?=
 =?us-ascii?Q?z1NWCadCntquzzy5oebOVZ8uNMp7INoGeeN8EGESKgFp7kALOIcDeFGTE7fG?=
 =?us-ascii?Q?K2tOCPKaaaA/HTXLp4G/nD+tGNHWf7PPm24txWB89FB2zaoClsec4iY5EGsC?=
 =?us-ascii?Q?QcWWXtLxJY/M6Uiw2ylUVu7TM9QO3xfHdVmo1RRJGnM11OwWl+SaAMIPB1Q1?=
 =?us-ascii?Q?7GmXwCoTIhFkai5VamOY+Z3t/1mgfXMZFvbul1dNFVrmcs7DsezS4JB1peS/?=
 =?us-ascii?Q?ERxAxY3yFsnXjXFbyRJeX4rbatQPM8OAh8c/m7AfC/OB1tIcTcKc5MMiR1it?=
 =?us-ascii?Q?f5u+xKS96wAjHa4M6nWn2cBIzfdUWFdf58lsPBxGhrPy37WCeXEh4BGPCj53?=
 =?us-ascii?Q?dm83UEmu1VzdMLcCJq2erG+kFGX67nW/uN/BoqhONgR2nIzgA8MgxljNNHoB?=
 =?us-ascii?Q?l4yzu1yKl1SDDGSCzIRLznMO6wNgEKTNyLA0KUEmZc2rGWE+aGLT7UU7VLXs?=
 =?us-ascii?Q?0WxmbCzfS7pLbS1UzExSbVbL0HKDR4WX6qC/MXxKNXbdBWQlBm2dijmah6B9?=
 =?us-ascii?Q?rXdY5tBhGf0VdETJsfZZBTwkd0dpJIgo+Kd/v05EdMKsAZISf6Rh72ZPSoUm?=
 =?us-ascii?Q?O5TX9YiriFDCBSUjo+nZ1S4iz/RzbPUn1zzd4CYJbhVOO7fqx/9+Siw9rdhU?=
 =?us-ascii?Q?Nze1zc8dMGUaK+54EoFVEZ69rF8JDldPvvaCnr4npcN/ThE1wnUAascdiGlZ?=
 =?us-ascii?Q?oEKEvEO7cqC0xopNxqI5F9U/5iyeX3FmWJyEKEyaTLwWm36P7HRkG+7cj0ID?=
 =?us-ascii?Q?W9ot4EUpPLfDMU5wfmD6vj0hO7mGyqPYo19W6s6y/LeR9Itk4guSwUmg4gNr?=
 =?us-ascii?Q?L87dpqpxubwWsSf1uF/elBYFEkWq8G16nIWkKRomdJNiXtskJ5vixEgJymJb?=
 =?us-ascii?Q?U83DgBiu3Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ac8a66-2b1e-43f0-6391-08de5885d1a8
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 00:41:30.6163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B78DNc67nO24zsxDEeTJLE8EP6hOmOTbPC6m0PBFqXMp45yBpg1K+bJEhi36Zd+aoBMkkAOE5DbhkXl+N25FmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8229
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> Create export routine nd_region_label_delete() used for deleting
> region label from LSA. It will be used later from CXL subsystem
> 

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
