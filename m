Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792635718;
	b=bfaptMxXtwIpQCt51PQ7WvCnZh6kwslD7V6rkpz9XBrMlHr8xJSuS9PuE7rvKlfQJpJy
	 Upy2gdFUrkLgOTFLzi72KCf5IdwM1x2EYvKrGDKsV2oJlyZnvVXxsvVAAJU4MxnIzTXy9
	 lP6x1l7wlFUx668X+cKG2J7tbH6AHFka2Af89WFbn7B0jt3um66vqwkDwBojbnjtUjLbS
	 kB6/V3Ltek5hIulW0BQD253WrsqS+M0TGx5oortcQHDhUx9x98xDCOGDhgDGfNpVbOorc
	 kEFkQ78rRociao57CaO+P9dspQEIsbxUVENjAcLSlAUGyK0hxF4lj5Ra+GJ0RoRn5Dg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792635718;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
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
	bh=ptooO9lURB2KjocwvOVv7JZJI8Hej0lX1pFCDF8R9Lc=;
	b=bYJN6lGOa9B2/z8fgH0pjsxHjD7zdVOFsbJtM/bU1rnBGOmSro8LxmLLByl8/+XEUIrF
	 2WFXAB9L0coDP81el3kV+3mj2Jk56KgCZb7PtF2ejPfO9183fmwhijR1b1v3Y2rWRCXNR
	 Da595SjLxaq+fQLKsLO5sgI7elNXTPkJmkBEKJbrKCx7w9Ii18RywF/8SzjZlUwozLQui
	 dZ8XAIMH3W47eXXfvScU/GbrO6Vi1ScrsWtcBzDxsJ2LPzOVFDSt1SfGVrG5QUw50U5S8
	 s+dWqMZKW8bluctfaVIXxh3Ntcp5NmTCPoOERhW0EHGW0COVA5ml0F2joK4Yxr/J6Bw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RhBCfg+h;
	arc=fail smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5616606A321
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 02:21:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5616606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RhBCfg+h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792635716; x=1824171716;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VM+i4XLMHF+otGrmsNmnDz0FqZCj8Iuqf9jSqCn9RGo=;
  b=RhBCfg+hV/RYyYA+Tr5yC77W5IWv1K7/rRLEBxU4uAo3Y2h7AewlwgFA
   fcT+ZnGUD2qjVo++roIeutwr2Z55RH7c8n6LbBsDznCz7odv+VY9e6ZJf
   VbT3qPBCQoIE5vFyD+qW1sp7aMnY3hQYuvrbjcgJfooVlNW0hJ11/5Tty
   1dcBUcHhb7O5oLYvPxWgZG7pqcXmSoJ2ibD58nPNmhT0JZ0Unk2xxRThO
   BjytKgCgxYLoasSHHpQHYemGIZZeYxLjCjP701kV/NdKEpuqNReG4UiNk
   hkhWlwU49Kei84fRF3Mrvx/yZCbhP/WeALnSovyI2HbonGrpDa56J/vLT
   g==;
X-CSE-ConnectionGUID: IDS7UtyqTWSwHC1cwSVh8g==
X-CSE-MsgGUID: XUgMK+VmRHSwWeciUMiocg==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1361054"
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="1361054"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:21:56 -0700
X-CSE-ConnectionGUID: W3IVne8UQm246pTcoNR0FQ==
X-CSE-MsgGUID: AyzWX4n6QiWsU2plsmLWzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="3238359"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:21:56 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:21:55 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 21 Oct 2026 19:21:55 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.25) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:21:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U7rHAbSOBZFtR1ltGh80Sv4Cr9NFCUDNBbGb0y66riC4umoSfw1zR297pJRdQ4J+QRpQJ59mk//Vu1HKva3aWeh4HIwKAnrH1pUeQTSuFSx2puIXeLK8IW4oTRFCA9P131xAK3fX9/IeyWZVBCji6WKxD1qxupaifKQKjEs56MgM/EPcHrbRQc4R0G/2UwLPnkuF2J2MpkGmN2AO5cKfHdoLnx8Mwk6xbxEw+Mms/0vNoQWNdAF2Yib31e/hlH+rSAbsP+k2yyaudbXYCjyCIgZzJLwVdAmcf3j40XlTyXxD8Lsu3/sboorPxulxtfJmX/8An6jEzwbgcsjF/4t24Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptooO9lURB2KjocwvOVv7JZJI8Hej0lX1pFCDF8R9Lc=;
 b=Zq+eR0QhAgxmRmAUyvKHw6NSQYTvJQL4zOz2CawuMd3kkeHqgmWTLiQpjLTZ3inXrntUC4z57Jt5Gm+NZOdTNiMgXjQa8/P0jvMJY+dkWW2YhBd4T98iY/Eve5KmlpkpsCDsVo386xKQ3o4L74eDAU/2LMSvH1AA2kxkSzySMBD6bTG2cZ2VFa91STIY4M7Nta0FSs+H7m8L/UPHmm85sz9K/Q7OKkrDdDNZyqcMZaC3fEkCAXCU+Gn8aDyPsAE+H0c44t41SjfeV4X7RNlHUVJ1JDvgQHMf7NlKcvZVCJfc8w8wrqjtGihe1RAx0TnwkR0GaY4g69/4FFHqOXDrvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA3PR11MB155912.namprd11.prod.outlook.com (2603:10b6:208:549::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 02:21:53 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 02:21:53 +0000
Date: Wed, 21 Oct 2026 19:21:50 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 4/6] daxctl: report whole-device hotplug state in 'daxctl
 list'
Message-ID: <atlzPhFgQp8Sa-uJ@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-5-gourry@gourry.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261016214248.443247-5-gourry@gourry.net>
X-ClientProxiedBy: MW3PR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:303:2a::30) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA3PR11MB155912:EE_
X-MS-Office365-Filtering-Correlation-Id: a647b4a7-450b-4aab-d3e8-08df2fe33c9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|10067099003|18002099003|22082099003|3023799007|4143699003|11063799006|261021121427099003|56012099006;
X-Microsoft-Antispam-Message-Info: mOviK0PMkTWjJGZNTmBmMQn/CKVcAMOgxKnRDzto9NUFqikqI3LNbkIfwMOz13FsMSoeq9+6EAdtF3UJ59qLsFsItAOSmebAdVZlz4keZ5a8ppQJuFK8+vvRQIqZMYGOXDrqLghX5GeUMoAknLPMlBk1gntlXhSVmoEpeBx6q3ckaFLXgTVjQ0OTNaV+MeXnLcnG14tshR7yc0ZyJjSJc4toH+BWs6SOOvq+uXKlI+suGet9/P0XMQTLPh11GzW4VCXMBTdBX04QDHON9tLuzHFIqXrrjQyQPrQ13hvff+NVE1vcIoocRDTT8D3nkkL5nuUmhr8Jjv0820QLYLhP7h3OHaMSwL4NdBiNKS/qu15AJkTQXkfe3hezfMVRTjZ19kzCqBZmmPozMq3Msc0SIQspQsWSlY7J4xkrZSFjqk+zHaDOWmgFTpmnDQrcdznUCqnycfxjUl0uVxnqhcZGxGFNXJp3CIzyeWXKAN0WHwDFWyhF+WiDeZTdzl850VKpYpYnBsrCcsIpqsMcFHoiovDL7WmjF431sjg2hozRn/AwRKLodj6wn65D5A74JKcIzMBkVuMT7fWGGsQR7mhmhZw0amZdPIUdWdg1q4MUOqIHGefMh/L+/zzT9Wt8+1+cq+WqdPDY1QqIcNxfmCRaJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(10067099003)(18002099003)(22082099003)(3023799007)(4143699003)(11063799006)(261021121427099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/dtUeBImFExVOAktKA+K1B2ak3w8UoJRtiqJucH9n55zUoZAyWmTX08rQ5HK?=
 =?us-ascii?Q?sktnXONkXXf2bVvvS5q5KFpgc7HTV9L30s3oMMKTVpAaxPJxN8QpBsFvwB+L?=
 =?us-ascii?Q?6hpXJqiVR2bGMgpn1+LocdiTrAIJYCffc6c12KhNigjPWp+/WfTYT1oG5WRW?=
 =?us-ascii?Q?N5MbLZaafOKIk8eafo7trT79gKWzb8wGNnPn1EjwJBi3oMmPlh38zS64/1I0?=
 =?us-ascii?Q?kMgmo+vU6BJbx5k6+l7XkqClvll2FpAixQ3TGJxo2JzHS/zy/9ekeWKCYqNj?=
 =?us-ascii?Q?rSWNJzDlWNYUsgfnnEyNxYJvWpsBNwrfvU/bjBmDBDpZrYAEwA7ps1Kn3ZW5?=
 =?us-ascii?Q?dqQU+FOd0lxqZ/Laj5UeWBegAFpnlk6fZgB8J/mshsll1P8glUYd+diZom8L?=
 =?us-ascii?Q?15u6H+HhNau+X99cE7LN1GA5VculcRd43mec2ADLNLE1gSdKcqF7zI9L3fuW?=
 =?us-ascii?Q?WP+s1mMcvVRgEyVoBaKxpkMkIosnigBnaBwA5s6Bapqdfe9Aib0Xr+hqMLhW?=
 =?us-ascii?Q?sxL8hrbURa9yAFW5VhGNs11BQEj4T3pGMRToY0bSZC0UWwzdtIqGZWCaX4YY?=
 =?us-ascii?Q?ZYZZRVDd4gMTiybOdwvvt+opm2bxmjUjW+r4aFht9jrcIqHNA18VGLLaKqRB?=
 =?us-ascii?Q?xjwKGfaGs5Sv8sLPW1WH/rE1YdxTG6Py5B9N5Q1M7S84ny/mRPZ7rrzWtWR/?=
 =?us-ascii?Q?fB1SG7F2PJTkYmApc40ZCrYmLOMgz/6xXgUTOOsb46vM9so5Csb63UF+wL2C?=
 =?us-ascii?Q?akMxH9hhzgEKq0Veje/9lbeW1npAGMbO6b8Y95tSmDi3WXwxnrDD6MsgIIn1?=
 =?us-ascii?Q?QKJeV3N1cV184zvTnW/8yinbO/aD1Y6VaFF/CUaJ/bMFb9US8TnRo83JSE0e?=
 =?us-ascii?Q?jQbPgPxYVgxYOoaWOIUttBxck6Caq/zhRY0SaVuiVJmh5vlbcJ5XXqKulfN8?=
 =?us-ascii?Q?Ca/Gf7ydnrFsc48X09pe9zrUfWNnYPCysBWmXeOh6fjea/vreicyF+i+A10p?=
 =?us-ascii?Q?6ozDWGVU6JZmRxgOOwMOT/wrl7ZaE/IGxkkDM6bMUmOpt1ReKrFBpkwza6R2?=
 =?us-ascii?Q?qEKQaMdrnkaSdVovFtLBcsy6fFDaOQToI8w6L76wgiCbeCxQtdsqx9nTJi6P?=
 =?us-ascii?Q?mzpBvIHWshJvexiMaaE4525XUWsOnC42929O4IMpyYJdwx2/PIPwxCVeKtgl?=
 =?us-ascii?Q?2Clk+F1JzFsgXXo0naTSQqUOzKwsE5nsEppHJFb9knvyKJNW/3SeMgpReuWJ?=
 =?us-ascii?Q?AHD1jBpS4slzVVE8FoWAe+3zLMwzygmP+x9aRRRhq0cWqFK+c8tOl0z0Sfnn?=
 =?us-ascii?Q?HV1VAWSvcIQ2eEpeV5ayQjwVoX48Gj6v+bG3AykXm0TgFstI3ra8w0LzHuoH?=
 =?us-ascii?Q?6YrO9c8aKfNmxJ+eEmKch49I9Lo03vwo3UR796lpBgyWhvd0vpwrs9NxDXPR?=
 =?us-ascii?Q?lVib0Nt036rfabq1KpBNihFFlKCEyQ/1akHRoXhsbImzlcEdzVqKutMA8Jt1?=
 =?us-ascii?Q?kgL3JQlKhs1E4+NF5zASoRhwFyfXL3oOgXT2NjllLiZozL7cc2Qv7gQB7AN2?=
 =?us-ascii?Q?TnwSU7BKgYmeBRQ+wpb/0bqF0yXyU5oUbTSESs6/J33rsMVBrIekNDoUhQqf?=
 =?us-ascii?Q?vDw1VXrGuqRJxX4n7YUPXkA/ks4fsgt8W6M8SlE2XwJKfATuemXteN2cCSZ7?=
 =?us-ascii?Q?e+3inOHrcaE6DeMyigJlyWH8CpGoG4RKs+EymXpsssz0zRp6I/PQHzSxM7JC?=
 =?us-ascii?Q?cpn5VO5qdp6ioIgJMTrN5/zobOfkRRo=3D?=
X-Exchange-RoutingPolicyChecked: 3o+2j4YVJPUrnr+4m4ExZ9R/imE/8MqBgS65Legm+lOepQcaGdctrXvdLqfXyn1zupr6fFDBpjK9rL/miNExCjz3EOqnUvFe1NIlwcBURgAFz504+aw1uZhNIk8+vg1MlyKTCppA918jth11Zp183LgyHwk/Isbyh3WHqGv+MhTNp6ZzpJDbma69r3aQUwQNLg4Ki39ejoCyBg9917Z4SBgIv3cdbEjODEVrYtfi38QxjRgefzzHfUFSb3HKuuU7EI5pxj3EQccJIKpc6W9b7RmV2op0R2HxY0SobOqVaa+4E8X539XqhAkMZOST6RgXPw1i1BfjMmUxFpZMsHoKsg==
X-MS-Exchange-CrossTenant-Network-Message-Id: a647b4a7-450b-4aab-d3e8-08df2fe33c9f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 02:21:53.3423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: za+SxQX5XIiwrpajk3XTpuhooIY5NogbtNelkfeH/vlVeF/TDGpuuxu7KDubsy2aMro+LxZBmb7vfixFc7WX5ODcsPLu3w1NZwWZUJmCQ/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB155912
X-OriginatorOrg: intel.com

On Fri, Oct 16, 2026 at 05:42:46PM -0400, Gregory Price (Meta) wrote:
> From: Gregory Price <gourry@gourry.net>
> 
> Report daxX.Y/state as 'hotplug_state' in 'daxctl list'. The kernel
> only updates it when written, so it goes stale if blocks are toggled
> individually. Report 'inconsistent' when the blocks' online state or
> zone disagrees with it; online_memblocks, total_memblocks and movable
> show the actual state.
> 
> The attribute only appears when daxX.Y/state exists, so output on
> older kernels is unchanged. ('state' already reports 'disabled'.)


Reviewed-by: Alison Schofield <alison.schofield@intel.com>
