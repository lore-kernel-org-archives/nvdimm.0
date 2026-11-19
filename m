Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795118283;
	b=DwwgovVnbUr9KfQ4zigDlArrAfgw7O9eI135jd3MgWd2Bommqgf7cdISf1ZSl8HAUXmX
	 cpivqK4n69CjroQV7VBiVcfvRX3Ih0qxRzvQ+CM+0emWiyW2fJQ6cSXgcxGjnMV7BYncm
	 dKIl8Y+eHru9zZSxbsZqMejo1hIZYU6ah3En4360GrlMcVldCwj1P81pItxMkbO+lo4kj
	 07TUjvro0dV6YPtr6vEceqUpN8nD8uvqbqGgt7RqVgybFGykYx4iQXGzfuVxsP/UsUTQM
	 AqSYssiEficL3fMie2UgHhKqB3DCZT9iQq0ENla7BV2Q53nw1uj3q1ZAUqaxJq8LWdA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118283;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=OxyhZiKrP2Nx+BLoP9hEXrzeWM4SeZbAWx9qKKvxs3U=;
	b=2FFreGBtJML3lnbEMn38zvieGn1ezqDw4IbowfY8Fmj6Fwweky6aW3MD8bBEB3JDoqpi
	 UVPp4eiG+VRxr7cF3j4qvEUtWVyzsgD0Pq6aPqy1F6f2ON4CPGBvoAW5MhWwighbgWSrN
	 3iRtaS1dbeomHmYlitk2WJsAk3bNtDI0dueRzKmImqHVuqF6m209sbSWk83cuZdKmKMhp
	 GtqMbvAM1IzqxmhoJTxfohECqIkA2Rftl/8NIo5J7yDdrz5CgxlzU1wmewIPKVaFYvLbB
	 SXOawSN+Lxwpv803sEqkat43LIoCXkS9zl1fQbQt2Yzcsy+qVCPJh7MpfSAegUO1uNQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ch3T0d+3;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=i3BxOLHu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEC5606A320
	for <nvdimm@lists.linux.dev>; Thu, 19 Nov 2026 19:58:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCEC5606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ch3T0d+3;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=i3BxOLHu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795118283; x=1826654283;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Sgdqr3SJt8vNGq/0xUVoG1AweqCjGoP/sKxAWeCAGU8=;
  b=Ch3T0d+3gSVIeseVrFC3FquwEIQ0nshWT/NZ2NQHRq908CJjae84PaLv
   AGOayF0gN4mFgRx3/hIZ1tJzCGYva5572GvoKPy6uxP1XuaY8YvJG7UK2
   U4tgITUhF4F8SgphuZB9xmW7PWeUbeivS9tyEQaLLFZqHHSKqwFk3XONB
   AO+BCA3HsSfcUj9Xd9Rs1Z1/9Lusfnbw8rVKu2P8sDx2ajJpRXsjIsska
   ksGPUzTrA0pHAgmgSH+0XEti6//qNxStZkFhLUkqpB6tFRQKUxLsKqPyH
   LuhglSIjbCkRiK6ZRHWcXzIyS6P5bkgVWENrTmUOwx7tPgxRHjZzTyJ1P
   A==;
X-CSE-ConnectionGUID: SRQiW83CSQ+D/r2EAd3aVw==
X-CSE-MsgGUID: o0NVv5XDSBeCzognD8kDDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3870292"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3870292"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:57:59 -0800
X-CSE-ConnectionGUID: X3lhF+VfS7SgAIhMGtfLCg==
X-CSE-MsgGUID: fsLWUWZERyixvgDzSIFZmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10775339"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:57:59 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:57:58 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 19 Nov 2026 11:57:58 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.30) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:57:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gsh9lvKDl3QG/ZCKQBIjjUPk5EqKDsixuSwjX+Jzq9gfUyMDX7U/X8UgYn5CbjaOEvBKbEhuDHOaGbEeYKqGfkZ4ArI2r27YusLjCWXfVg2na6Wao4fca39I0Nkb0O+fAJ733bCmiGoDOYmDZ6quF+noXA33uxE4Zi5yoKa7+fNecHHM1b0X4RkyJaky08YJ09lyVNj2SiJrtQH3MCzLr9EQnXYhlM8GHfNdR3v65h7R3NY8mtTlUcSlJckP99y/ucNV48+aEEthrElvCFOGpQiSi0xKmz4sjGersD8dR16TEMzK+QMXnxJGQ+7QLoEecIZ/6ubQ41ra9vtaotq/Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxyhZiKrP2Nx+BLoP9hEXrzeWM4SeZbAWx9qKKvxs3U=;
 b=MOfp5qw5Q3Y8OF8v2s9WXiH/8uJFX9Ssi3WSm2Cl0YxAoFsXbSWswE7XsausWG8OOYn7JyDm3y5QWNdNRh6ICtWnG6z1n9rrLUsPmKGOOjSHLTrmJ0fq+DEDuccJM+mFCf9Im54ZPLoSbRZKWZQUXFR0EkBb8Hcb6gqBl9xX5YZF5qhIaoq1tR94BsZKRHasAjtDC8+0uyMVFbicE+ea0CKSQgywUjnuanKb8OIVWqsKVi4wHgPGjdCPLtaBSn8BhU1Z3gaTzuwVBqyLAvP2KZZy5A600BVk53FXQebPLUQe9LuL2ajDaCl3F3ksCDuZ+I35YHmX0hy6n5xC22uJIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OxyhZiKrP2Nx+BLoP9hEXrzeWM4SeZbAWx9qKKvxs3U=;
 b=i3BxOLHuBoArBOxysBxOngDOWzPSHvLIzZGnrH+nGDkf3wuAJ3ZrBeN4qv0zMCsZ3sWNTInvDU/QktpL5q53Pst7gkQVwirYrdWuj+0juJ+CKGcP7mr6Jtl0TjucU8zAgzkK/Y7YipiHaxhcq/qsVrjAV7sVY248pJGKBBzRI2A=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB6899.namprd11.prod.outlook.com (2603:10b6:806:2a7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Thu, 19 Nov
 2026 19:57:53 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 19:57:53 +0000
Date: Thu, 19 Nov 2026 11:57:50 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
CC: Cristian Rodriguez <yo@cristianrodriguez.net>
Subject: Re: [ndctl PATCH] ndctl/lib: embed a fixed-size nd_cmd_pkg header in
 command packages
Message-ID: <av9UvjV6mNyOkG3g@aschofie-mobl2.lan>
References: <20261024043521.560745-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261024043521.560745-1-alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0213.namprd04.prod.outlook.com
 (2603:10b6:303:87::8) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB6899:EE_
X-MS-Office365-Filtering-Correlation-Id: 29ee4ba1-b712-4d62-4832-08df467765b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|261009223027099003|18002099003|22082099003|3023799007|261026140227099003|261026121527099003|261028144727099003|261102123227099003|261022105027099003|261021121427099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info: lfkSNFkhBGi5t+I+ZQvBNwNO8z8RRD9r5fBDHd7QYQki8QQEVki8Gx0Vp26hzkTVbI8+WEryH9hUoHBjC1yxfDONOKcLTCJvIBBJ6yKWGODIRsDO5y+FeMR0zwwHuZoXeklH0eWKSF+E/+kNe0TwgaKwcB+rVeMEtmvklsxhs0WUqPIZ1fJ32iL3uNTPJT9RPC8aa46XROOKNu1T8aidM/gPIc16r6fBZYA1BP/NXFsip2rtIDPra3NPcCwlYd85U5guvhkcGDIskO0s6WXC9wGh5w4jZQnmx7jF5F3mdS7nVxLhwzoKA9867EP1m++D08A3sGj8cJK7Wc5/YScx+nT8jnh52S4eIsrYGWmu524j7v/hspvQ/jigFFOsOf6ZcjeU0jKMZdQlFV5a5z3Kw+TN1k+b26r/Dc/LD4fNC9d04KgZno71bYDFEPBpLAG4oq0esKmHBPaFKpOSbkRMZ5k5h3nqub17E+1zhviE2wO5mp+4MMfH1Uj619+T1ff7O/Ee3nvHYpILdUCMEFbcbXMeg2/xLVgryzy0HZmld6USvERj8mHGe7euPH0U4DK4niek20pqo0tpcJZR5juMVQwMq0AH+NuyyOVCiuRWi5vLZ7HY1xmEE4+ZFTaaVUNjgbW29Cp3vERqcrK82d98lyg0yLiEDSZn9IGufJmx/t4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(261009223027099003)(18002099003)(22082099003)(3023799007)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(261022105027099003)(261021121427099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?usjGFdPzMwYvRoD9JsJAh2GL2yI/HYwZmjO3TuMVy2lzQl78k65OuT6fCys5?=
 =?us-ascii?Q?RY40zENGZw9O6cVld+A2Hz2k1KOKltM572qTz735umQ5wIolMrf+FwfIiMcu?=
 =?us-ascii?Q?9s2NGzKDX0CMm3Tagh53N1i1UgqaVlh/k8vOf/1B7QmGQSB61Dp2OO/VFBEV?=
 =?us-ascii?Q?5b/qld+29OLFrRFAXE/PvxKTQMb/gsDhMFjJF9ld88AfaFjhISFZckSI0Hh6?=
 =?us-ascii?Q?naUozwt98MsYMOJNCFaBRLmK5V+/JfspeaYEty2v+BES+o7w8pUHTXddes+P?=
 =?us-ascii?Q?caIRMS7tW+ODQWIDdGsQlN0ck6nOit/wmlBRK88OZ9UiQd96fjLaEdFxdIiF?=
 =?us-ascii?Q?+z4tYT/VYh+/7v71n37wf4bFTH3PyAFpW4araBqYhiKTmv78T//FrdoZ4XkJ?=
 =?us-ascii?Q?q8fYUX8sY6/7PtH3cLr6F3FBlV3hfbu2f2Gj3YjawLUo1nkWn1WXQOocnik0?=
 =?us-ascii?Q?uU76VALIzsa0yHtrqLBh80wpDeC61rSruDPgAfyHfNXp0/ZieuDZvqzbKGvZ?=
 =?us-ascii?Q?8EIkSpHVBxdbBr7HJM0zN+aGz5W4cRTysdVWLgzqQ0dK6TKeZl8UNVVPIEaT?=
 =?us-ascii?Q?oKwRPkp4lE1boNmc23IIFiyj0n/+M9LPDAPGUQjvVhrmJFaFbplONCsS8VW5?=
 =?us-ascii?Q?ihv1J6dStx40Yz8PweUgLBuYEUDDGYP8TCuNTKIIU2jY/xG6EGUZnTn1N7KK?=
 =?us-ascii?Q?LmNhl9X7eorYluvkaIq0VRT1C9l59B1KpYJXr338Kpd8VQs0V62lsW72F258?=
 =?us-ascii?Q?XS2B5DcW0wO07H+Vfay4UILm5qp59X3BkeiDZnu7oQGWRHWF/fEli52F036H?=
 =?us-ascii?Q?6nRMDOD8dciKIwqiLIF148Le8CCQCgoyRrcHSi+iLV6EpFe/Z0SNuwboU2/e?=
 =?us-ascii?Q?Xx0p7UQMpmlTpJS782ARMX6DoiyplQ+dT8IRrgihOrcoIMWS/zdfZQn9hEnB?=
 =?us-ascii?Q?ZQQObT68ZileFeDRm9dmOjmJbO+c1Cw1YGFf0rmG+XRjrAkhNpRNiefngjmK?=
 =?us-ascii?Q?S9HvDD6RHb2nZFemZ8qX5P8XP4I8Eki7mLCLJsqNUCEfp7TBT9iEaw0noKM9?=
 =?us-ascii?Q?zCJc72ObL1w71cDEjPWMXXJvY7RrLp51HddGBonbciVOD+EYWwF9bmhEkvq8?=
 =?us-ascii?Q?+uxzuhLYleKffMoJmkAqm7zTIMalccdUlrxuH1IP42BC/P8POj6ywJFSPw0p?=
 =?us-ascii?Q?+DHPCYyA1mVSkRmmvcnn4MkyqoPa4g+VXnMz5WR6mIYp7Oq/2jXT/uhxNr64?=
 =?us-ascii?Q?kcXeo7rMrB0SakyHZWR43rR+tIywxlqGxkTaFTc3SwWDrDiipOjH9HH3JWSw?=
 =?us-ascii?Q?8Uu5a3SthvZyBupQ+siJPJDSuWTGcehhebLYnaBm7PKZplH0pwHOGmtJ5ilz?=
 =?us-ascii?Q?32HTQsP+97+NTgC46CnogaTfvKpssiWSqfq41K1bW8xdH0U/RtMExHsQFt+6?=
 =?us-ascii?Q?R7Wrt3m+BxMRXmURUl9BIOHE/MEQeyQjw4ki39oi75wjx2xfgpsheU41d2Nn?=
 =?us-ascii?Q?Hei8Q/RFxlIOVhA/guh8gN0v2lZ75p/ajiXme+6UGlmPvAdSEgkqrPxfAMEJ?=
 =?us-ascii?Q?JROvFOOydpHylj43RGZf+7BofeQJEEF4Z3P7lscP2YmPuoSkHOEYj49CUMke?=
 =?us-ascii?Q?2RZP4oHow/V413zp2WK4E3qxSXRv0qyuadWzDgAB+bNxu/mcsFV7vkdBQA73?=
 =?us-ascii?Q?VoFtZ0oCYuGCFNPkgW3S3r67lZcVsN24POO9ORkB4cs219L9Q9iu4F3dA4NT?=
 =?us-ascii?Q?fPFXRWnvidKWn6ZmA6YG62bps/fftBM=3D?=
X-Exchange-RoutingPolicyChecked: OlBLRZHKkuZ3hQ5fNyMG2zMuVDVoUm/3EpsKVUDBVbrOOpWpf80dEr/FcVAVNSTvQEuPYqXD/KhJWo4VZ+48c98JtwOoUC8RMbeoquz7c0lezQw3BPnGgR1uTZ8gmKaLSe2IFrWyrbpk2jPmRXsIH0WqFRBS7fNk/JsiqXabkwz9hp303NLGAMS7571WQ2rQy2TbllDPAO9Ux+CaMOxcI3bGVJBWKOMb9GW2OnCNnwc3GS+KqN3bASGWi7SsmViUrO27DYsfB9DNIWVOZtBgU+qkvMRib+s/88KXIa3brQ3CiHg0qfgB3lhDresDrjMozoMU28N3R1HhyPJXk2yO6w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ee4ba1-b712-4d62-4832-08df467765b9
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 19:57:53.3359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWpIBVvyxCkzn8bZPonbhCHmPLwRmh8wZ8BcGEVdvgIY3+bxYkKrv7ZjKB6M421fcr0lmIuOatZfuzEfbQAUHfTVnsHY6QIY+gsfI7IX2vM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6899
X-OriginatorOrg: intel.com

On Fri, Oct 23, 2026 at 09:35:19PM -0700, Alison Schofield wrote:
> The vendor and NFIT bus command packages embed struct nd_cmd_pkg before
> their payloads. Since struct nd_cmd_pkg ends in a flexible array member,
> Clang reports -Wgnu-variable-sized-type-not-at-end for these definitions.
> 
> A flexible array member is expected to be at the end of a structure.
> Placing it before another member may cause problems with stricter
> compiler bounds checking or future compiler optimizations. Incorrect
> payload accesses could result in ndctl reporting bad device data or
> sending malformed commands to a device.
> 
> Add struct nd_cmd_pkg_hdr containing only the fixed fields of
> struct nd_cmd_pkg. Use it in the vendor and NFIT bus command packages
> in place of the flexible-array structure, keeping the header at offset
> zero and the existing payload definitions unchanged. Update the few
> call sites that explicitly reference struct nd_cmd_pkg to use the new
> type. Build-time assertions ensure the header's size, alignment, and
> field offsets match the kernel UAPI definition.
> 
> Validation confirmed that the package layouts are unchanged, including
> sizes, alignment, payload offsets, variable-length tails, and the
> ndctl_cmd union layout. With the version string held constant, all 153
> compiled objects were byte-identical to the originals under GCC and
> Clang at both -O0 and -O2.
> 
> Both GCC and Clang builds pass, with all 72 Clang flexible-array warnings
> eliminated. The ndctl unit test suite also passes.
> 
> Reported-by: Cristian Rodriguez <yo@cristianrodriguez.net>
> Closes: https://github.com/pmem/ndctl/issues/296
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>


Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/
