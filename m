Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9A51B95B
	for <nvdimm@lists.linux.dev>; Tue,  1 Jul 2025 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393339; cv=fail; b=Psm1jb0qpHQ+jDfXF4OayD2vjnnRUnisribE/r6QGZrF00Y4bq74ull9BVhjZqWmnf//bhfAZjkPJtKdGrl08ttZClOH9m6h+ypoPNGhG78nTzILgfZdNhPgHbWH/6L2kWRbZ/rugdFYtbCLMy08LSP9Fn+E261I11mH2KIjadY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393339; c=relaxed/simple;
	bh=4ZrZrt7P2zmwjQ5gqOVWOOPMj8c52SS7KxmcpPzPoZE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U+fNRqRPWS4o6ZaVc99VNSwZCSj8XWBojVCVv/xE3SPy3UOKgz2fTYbuDeqPvHtHLjid7oX6d0d961x3q+tECgJtmNd7xc4A5ucSkoshRuNcd6Q7dwjw61LijAL52ACWjMNRVYOfs5vKGENjNJRobZVqCj314Necog8YBgtUaog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I68u9W4P; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I68u9W4P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751393338; x=1782929338;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4ZrZrt7P2zmwjQ5gqOVWOOPMj8c52SS7KxmcpPzPoZE=;
  b=I68u9W4Ph1xqGIpMrtOQZZFtheNgOqVN49l/2KunK7PG+FLfCHcYCWAC
   SyLAMmNLzHePt4Blo1KiSE0QbCz4g0FnT80YHRjXUr+vhLbvrzL8EaztH
   Qcwm1IbK6w/jHLmOEpxNdqyXqdM0P7n3BTZBwvdcMAk23fJMqbX1nqWSR
   xqB0CTk/BnWLtgp+aE0V780agkc3+pAMqrztRFS7licN1z33tM3w6IAr6
   ByBWfUbTSqG2OHY5P/Pcz8ebXSdk6oBlcxYzUF0IpFPYonZUYi/Ikjm0b
   5h9ThykpJsqVDe0sQcMeJknYdNGizJuKihR0yQFoecxhERutDJynVMHkb
   A==;
X-CSE-ConnectionGUID: 7CdbeClDTqKcg+oahKYLdw==
X-CSE-MsgGUID: o9JVOOo9ThaJmUD4MujlKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="79113857"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="79113857"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 11:08:57 -0700
X-CSE-ConnectionGUID: x3sPLl3aTwqF5pnMhmVGnw==
X-CSE-MsgGUID: 6ZQJ+KE6Thei8l3ULRGOZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="154334223"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 11:08:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 11:08:56 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 11:08:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.89)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 11:08:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JHpKd6TpCd7nSUNV9h/DEYKtSyIBeJIyPDmOeTA7nhcZcus6I7iFhtRRv2iEgOi5XiMwX8qEGz/ty9VOfJb2UxSCSTuN4ds1wJ8Hc9ClkIoCQOFTruliXV7Ggn6dhgC3WKJBIj+rz36oMycFbdQ+LEN+DjnERPR1NBVFpu53aWBNUSCt0BgF6Sl3Gbrg1H+kvMweItP2uSShd9m5dkhQMOgAfwZvU0Ilgd/5zWoldQI/P4cEV4P0pBDM1p6978n6VgOj50jklhSr0+Arh+LNFXgZbA/2cJIfC+DAXpa2C8k2opmHEJPNncHRjiObKPkme2N9S5omUi1T1fySrcmENg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZrZrt7P2zmwjQ5gqOVWOOPMj8c52SS7KxmcpPzPoZE=;
 b=vmjB8+2vsQCyV29IH9cQ7B+yJYFX/vrJPMiETTTDr1YQ1Ylzd4s9Py3W2trKtjgQyc7p2Nm6wkcpCepgGGqtbX1kX7xrgU3DmIPsj3mkkRJXkUdQL09vKR6qvOqbZvP0LCAskq9Tey2Lbh6syKMD1zCWJZrMbw/yPWoqzEhCClae0tn6LN7QsrDlZ/NTwulU/FECG5em8Ji8/ixng4nmulELqz4lXb/2EVaGcvFcpt66ZmkpaboNE7uP76VTamss+A+e3sFE8ERSIxf8VlK8TtolmWryWSQL/EJBEGXQax5Ms60pjpG0v5e+G05xrSMRPewk2LPO7Ts1o8JDfCZ+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB7100.namprd11.prod.outlook.com (2603:10b6:510:20f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Tue, 1 Jul
 2025 18:08:12 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::8254:d7be:8a06:6efb%7]) with mapi id 15.20.8769.022; Tue, 1 Jul 2025
 18:08:12 +0000
Date: Tue, 1 Jul 2025 11:08:08 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Yi Zhang <yi.zhang@redhat.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] ndctl: spelling fixes
Message-ID: <aGQkCB8ZhbVuOz6c@aschofie-mobl2.lan>
References: <20250701141545.2631700-1-yi.zhang@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250701141545.2631700-1-yi.zhang@redhat.com>
X-ClientProxiedBy: BYAPR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::38) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB7100:EE_
X-MS-Office365-Filtering-Correlation-Id: e869f551-1e5e-4bbe-2a40-08ddb8ca3df4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?aTTQ07FekzRJmrFPkmHxPFW0FhOFGkVysrUmot4jfbxoor2rCgO1WYFko3DI?=
 =?us-ascii?Q?IDqk65Ql19Qe7JGuwGp9fEPks70Ew6EjGVmuOHtQtBicROhl/gcyloVfhEnI?=
 =?us-ascii?Q?neaXjyiULfahdcQmaA/SnPCkBpiEVGwcYVtFOaVG4JX2OYrn1ZCgYefn3GyQ?=
 =?us-ascii?Q?DyPCsPWdp6OiKe88HWogS5F6CYyW64Vt3IPGk4vnSHum7c0GA8SNvZ1Zy0CM?=
 =?us-ascii?Q?6GOgjjKB9MQSuYWEVVt/UTGsj4TQeIgm8Wn4DCPIFtmDi22E6DpcrsZu28Xe?=
 =?us-ascii?Q?GgoMA/4/hd4NZQrC0arVlvW9SznB9vqEqkf9/HWWFBTfK4e76TurUBeg6UmJ?=
 =?us-ascii?Q?8EH9dWzrZlh/IpIvc+IOi+hx5t/CZwNdP2/Zk1BvHVRnuqKUDv9tTCcDQU+9?=
 =?us-ascii?Q?rLO1G5tq7+Ovodxau4sgVbEjMQo0pSTDlK2X1khPHlZQZCijVL1crW3ihiK5?=
 =?us-ascii?Q?imhzI6WyA8AdnTK665zZgWJ13dFEAMegIBjNtua7YU+uUQ8+AGDaM8CAJL4R?=
 =?us-ascii?Q?5mjJ3YO1w+qvlgNNSuICz9/eNauDaOtUUNyFSxeXb6BOD2o0etvrFMvyw9wR?=
 =?us-ascii?Q?xd5iZP8XaatdHOGtnrO7uWI9gDuBIEtQrLxDU2XPqEvJxUAYopW0e0+Q22X3?=
 =?us-ascii?Q?bmMc1m6PTzM5Veaz2/hn/jiiNzFR7TX7n8EpMQzvxTVyj1A7S7jwR+zT0x07?=
 =?us-ascii?Q?/oXY3ksSkruMmm+0GYeoqLrfi2EQNaZCg1p1HyDwWhV6+TuFS/yb6mHYEiOG?=
 =?us-ascii?Q?4B4/si3YaRe7ul9DmuyjyO+fUsjsNomAzWJmCFfQFYenbNVlhFXGGHlxggzU?=
 =?us-ascii?Q?JUo6A79cHK7F6B0e0qmC1PxRYwiid1GMTYcGZ1D81AmZljvOgVc+ORmuCifA?=
 =?us-ascii?Q?k5bRLD6P1CZ86N+jRwO+ji7HDOwxheX5GAXHximUdgx8Ya2YwLy8N5Pjchau?=
 =?us-ascii?Q?CVJ2CJe30hka/Z/tK0x7VZdId1OhNq2ampxtt1YfI305QSvWqtYAZ63S/f7Z?=
 =?us-ascii?Q?0vMWu2ufme+Zkcjhiegyx8i3MvcrqqMJ8Sbp6ePmqfPd57h1DE+GwCFbm8Q3?=
 =?us-ascii?Q?4XU/BskIF0lUpckAiO27IVCl/uQ4Wy1ylej+Y+TKL1DGIksTKn+YVvip2ltW?=
 =?us-ascii?Q?P0i0RFfjRovPs9IKGyLfOk+3R//4iGXGXX/rWKSST0eaSURdGQWFLefPwg7C?=
 =?us-ascii?Q?ZPtURlcgcMjQFAsdIe6jus/6pkyu5lKOiZrYCUgbsEAO7ItJIWH4TUKRSM1h?=
 =?us-ascii?Q?OSqgOCzsV2Ny9fkUPopnpBsN60hhFXTRVkgp0pBtq0CjaebVWckOhXBrrnJa?=
 =?us-ascii?Q?KzRF+RhpBgPVtedZ7JkLSnis518DB4WzGWs5H2stlpzDWQBqdtZ1vqrotSp9?=
 =?us-ascii?Q?dHe01uMa8ACy0EDkJtoHabqzb4b5APt3+HHeCo3aT15QkRYlvKtwjLUEI1y0?=
 =?us-ascii?Q?+sFKw2ZC4fw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xPauiI0PWEv0mOVzdLise4T9lzbyrQ2sOdOi3Eylf0C7EG+gwqGxeNtplF19?=
 =?us-ascii?Q?RgZO9rLju9PliYx5VxopW/cojMzjk7E6hxEzGX3uBsEYqkpuMUsIWi2Kd17I?=
 =?us-ascii?Q?GPTRttV3ylVhtm1HMBU+8O+7t49/NJR1FpZDa8Zk6Sif+6OjCKV4/RxTMY+O?=
 =?us-ascii?Q?w1adUyRadYOYRai/rVMpTNsKbq4k+8HdTJNZ4TfSMFNAxo18KicqH1ZsqUCK?=
 =?us-ascii?Q?NPnqMji2LiTohzfSnCYTF5//g0C9aYkTXSGNsLY7lZYRMr87VREpkj48FsUh?=
 =?us-ascii?Q?mr+lANNd+3JwjbcAZAImiyMKynLO1s1tvioPNwJq7lYg//b8xC3HtIG50RMH?=
 =?us-ascii?Q?TguyiX8dbSpWpDJVhigES2SwA80SgRCQRW5k5gCPwo7DWXp8B9FSFhTYnI+8?=
 =?us-ascii?Q?3zvnWYZevMLmkgwHo3zxrAbklQOQtWzuOVAqiewuf/TN7ezBtUQu/7Pyjdqv?=
 =?us-ascii?Q?gmOF2xJnB4LTMOk8f7Z+2CCzmFcrHK4KcuW0NAOYAmpAp5UzXCYusL7ERI//?=
 =?us-ascii?Q?m82GlRq9mbdjjJQRvjA64IGMAcuaAijGef84Me3ygHJ656mkX1rDXQD3L1MA?=
 =?us-ascii?Q?zl81vMYxaNGWqeDVnFxNQYp1ndysXvQ0u9zbnapl3wH+kEVEhms8ZiJi2CT4?=
 =?us-ascii?Q?sgO5ZzImAW9+IBQz3kQJ2JgcPHWRAmBUm7UH6zt202as2+zcJGBz25uRYmti?=
 =?us-ascii?Q?cJRAbcZY31pPvviZXqyRQdchJcXFPHHU2yAjOOK2m5CGDEF8KzNe2/Y8DCdO?=
 =?us-ascii?Q?IyG1TehHohNo1Z/DP+2wHqrMkoKiOoK9afGkPlvJoX6gZPJQXfouc72wftrv?=
 =?us-ascii?Q?obRWoaq2Hv9jK/AaQsyiU6Gpdn0hJgRjgJYO7KZEMdAPON9BZWEWcvhs29AS?=
 =?us-ascii?Q?UGgjLdV6RLdvcBrWj9P1scWCXCh5z8S5qoZ00f/x63YQc11knFWavs6bkQZ1?=
 =?us-ascii?Q?tRk7qpxRGWyJMM8TOBXCKrgpV5DVzCa6o8LvqP62b2fL1xsCcbH1WTikixsQ?=
 =?us-ascii?Q?QvvXMQhUIx1D2bnKejbKcYPWtK8lNPwUkS/ashW9kAgiiOS9dqCPmpX6RlGE?=
 =?us-ascii?Q?1HhmPJ/Ex1eV68cVf4+BFTX/VvKN69xkrOsSu9FOMCsV9uHyWEw8MC88c7WO?=
 =?us-ascii?Q?Up6DKcHvKNdymEEQFLefvQHH279ZZKLvclotMuvJ6OkHNaPgweAyW4d6+t9u?=
 =?us-ascii?Q?zMOMXxnvQN4wEhMkpAw8K14Xf9QwiGyt6ECkIK2bjoNn3BDJxeHNbowAwiAJ?=
 =?us-ascii?Q?LQnhKcpZDIqDnfszf6OyYxgZACwoOkIdlKps6dIgkpsn7npGkhqLv8gaNF6F?=
 =?us-ascii?Q?ZjFG86e/tioy32BwENAee6yFALk8XP/fLuoW6k7a56p3BTt6jAmJ5/bjZfwi?=
 =?us-ascii?Q?+HPvXE3ofhipBIcQZdVeObvpoQUg/Q0iNeylXQ2UvBxbZHLHLNtQfS/lE1vo?=
 =?us-ascii?Q?E0XWTkkTre2uvC7Iov3U6mEtkcYC5lMZDpcqMT/xxs6S4Li9xcT66KDlZvzR?=
 =?us-ascii?Q?Gv5wqGSlSKquMVnENTGpEym2oiAlFcNNIusuR6ABnQD6sbjLNTjTemWbXhO9?=
 =?us-ascii?Q?ae8QmCFwuF7ihp9wSz9AnTNR+gNLkfRrmdTvFnl6fHrcvYU2vBcb1WHLbH4n?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e869f551-1e5e-4bbe-2a40-08ddb8ca3df4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 18:08:12.1093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIDhL4JeWQMzMPFTqpX1UixuJT7t4zERTb6hM3f2FNHXkFhsk/Gjoet3woISpAnukv8WtUg0T0RutTlMC7yf86nM5k+ZAtSHPyJX0Nk6Ytc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7100
X-OriginatorOrg: intel.com

On Tue, Jul 01, 2025 at 10:15:45AM -0400, Yi Zhang wrote:
> Fix various spelling errors in ndctl.

Please limit this to user visible spelling errors, like
echo, dbg() fprintf() log_err(), and Documentation/*.txt

Did you catch them all? How do you know? Please mention
that in commit log.

Rather than the churn for non user visible messaging,
let's catch spelling mistake before they get merged by
reviewing ndctl patches on the list.

Please update with a proper commit message and log.

-- snip

