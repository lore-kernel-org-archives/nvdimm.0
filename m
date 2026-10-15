Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2754BD7BF
	for <nvdimm@lists.linux.dev>; Thu, 15 Oct 2026 23:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792108184; cv=fail; b=gzNe1YjXsKLrtOaNKoKeYwFqgUd4YZ5I1O+Ui4vR1W6t48WPib15sBU+Fr+8SyecgbdVdjCT0dP71bdPU3b9znKuyVQlACc6cMp8mfUYkMr12cngqbjdEQYaHfR3YAl/v0tOQOjTqCW5Iq3iHZ8k9HQIIMv94T01NozeJ7qmOp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792108184; c=relaxed/simple;
	bh=PF+GTaS8c+yspqSvHmuZbWKbn0+FKfyubDdTFGMRbc4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k0+gBDkj5V2jUyxDH4LRDcaK+F8iZmC7hiJPg2QPXjplB4buGgP3yI6dD1b+4iBIEoLxKLxquvq2uCVOIyz0wDkGH36xGvkYteiX0ffHvy5FobriObhtOrCkrguGDyak/ajkRtFmtO7G2S2XjQ+Ty9s3N0RpjhVBkz0vdajAfss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VKG9kf9Y; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VKG9kf9Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792108178; x=1823644178;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PF+GTaS8c+yspqSvHmuZbWKbn0+FKfyubDdTFGMRbc4=;
  b=VKG9kf9YkfEL/FnivBUMVyqaDUsYiym0hnJfPm7DZLnaO0fbKKm198gw
   rTyqdtWoQQTdWFfGaqBIjlleUJgUwpeEpqU+fcb1EIi70k0AIAQNIva43
   YjE4XdO+ChzuSodzTIgitvic18MJxM2jf5XB67oxd9r48+VozFvJ9fb57
   o6+kxLC4S2C4CHoHaBHxgY1mnDLjA9i0T/uKlc3P4wiqcCS7pl6fDaP8E
   6FuWMsZGjykW6Jvg8hq+Igx8eYkyM6W32Q6NxHXXmqFd+E26FaJTPhuSl
   tyQslK/X+NMQ4CAItaKVZ3ZfLhnGUXO77ZYPNYs555hQLUIW7ynr1gOqH
   g==;
X-CSE-ConnectionGUID: /ZoM/7VQTdmaqrfG9ipuXQ==
X-CSE-MsgGUID: 7OdJA44NS+WyEDzOCyPO1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="910972"
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="910972"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 16:49:37 -0700
X-CSE-ConnectionGUID: WYrPtWRfRGuJjD2xBxUUhg==
X-CSE-MsgGUID: 4C8u+DzeS4ytWA4rxW8k/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="1776915"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 16:49:37 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 16:49:36 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 15 Oct 2026 16:49:36 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.55) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 16:49:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HKKBnmOP3iQQdGRwvVs3DlPBsKC3BhA52HoCjRyHgmesSNqRVcLtO351/K2D9uVA5brNnLPTNhkMf91/SbHgRk0aG3h7D/D/dJ5NoKx2/o9V66CTUsRwMlCLtcQOr9XO+tovMb1eePwS8FfnxFeQXawr5/VuCyWbmYo7hXlXWLT2oAAnKTL5Z28Tf5UvmthqLu/sqdc5CgTkrLY2U4H73K2YBdtaD8QLR5tvj6K9L+vqWCjpMHHunS6axH1NOZEndIQlzruO+XK6Hw3OZjX+ZO/4oSIm4dESJ59ZDxChvYfkTtpo1/GRJxjlKCIcp9xiqrrE/M91a+QabulWoT1t7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awb5LMphF7edAS9trsRU6aGJM06UXa55cDF2dxjywhA=;
 b=bsdi4bDrkz5G2avlVmEKruXCPNqOphNSuV9kQmmq08AN1jc2PlmXQYnWFuGuLn61Tdos6DeLGpzJJSl3tBi8FElz+l+y89oH4xLUgwEZARLbmbmM6KD4/teB0DtIN+wYTV+pxONtalzgCGeUXSrxz6NE7uU7Pw2zNUiTMZvf5QLslqIU3tmGRe+wTtTrpa6CDHGTUCJ62WUwi10jnJPrwcJdq0hdXSVfwC3GslpCAHKqf3TT7qZ30cTnxbMBRIa+J5wtQ0sPH95eJBS2aP6YIpiGOQ3WCfGKt4djf6QqHzruDYZh99zde6aMh4uEkLPCVCM0+B4A+B70GVquPAmZwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB8891.namprd11.prod.outlook.com (2603:10b6:208:56d::20)
 by PH9PR11MB126636.namprd11.prod.outlook.com (2603:10b6:510:3e9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 23:49:34 +0000
Received: from IA4PR11MB8891.namprd11.prod.outlook.com
 ([fe80::1128:c90e:54:e8f1]) by IA4PR11MB8891.namprd11.prod.outlook.com
 ([fe80::1128:c90e:54:e8f1%4]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 23:49:34 +0000
Date: Thu, 15 Oct 2026 16:49:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Serhat Kumral <serhatkumral1@gmail.com>
CC: <djbw@kernel.org>, <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
	<iweiny@kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <error27@gmail.com>
Subject: Re: [PATCH] libnvdimm: Handle negative return from
 nvdimm_clear_poison() in nsio_rw_bytes()
Message-ID: <atFmiVHz4mkgwO8J@aschofie-mobl2.lan>
References: <20261002165641.14479-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261002165641.14479-1-serhatkumral1@gmail.com>
X-ClientProxiedBy: MW4PR04CA0237.namprd04.prod.outlook.com
 (2603:10b6:303:87::32) To IA4PR11MB8891.namprd11.prod.outlook.com
 (2603:10b6:208:56d::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB8891:EE_|PH9PR11MB126636:EE_
X-MS-Office365-Filtering-Correlation-Id: 4954a25c-e2fe-4509-d960-08df2b16f68b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|18002099003|22082099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info: b5IWUA24m79t067bYDSPaG995/xJxY6YKf4OGhw/w/DVd5ruoW6m03yVz7xlwpfnr1YhYOKG8ngh7Rkbp69MXh9YapqVPBf1XMfyth06S7WIKrdsBgTycmKOwi0i1qVRkENfUVk+ODyaEYwfqJQyL8Bl2MkC5l2uA5iOCSh1HjCdd/ELhvQ3kihMug9P+PrJEv6JcOX1tOSJbLdopmJp5CP/xirdcyWVIAaXDwsinDqUwwuDBOpgWpfa7W95Nit0dxicDyOqsOfNUhTJrmqTf7QQ1DXzK5gpTI80FkUoyiFv3jMqAsMjK+SMBHW1Kvin7RCa2NCpdzmLtr8t/ERqrWi+q74x5tXmZIEPwi+OVd2f46SN8fVs9kA/RyP8CvTE3ANQR16v4ia3+MSZOGdnuiT7kDuwFWPZrZxfChZXMofVMwgpedpE5nR01ToX4r+2ZI/aaeKgI9NP6Kk50TJW7hnxxFuyEgEbUQtxJCmjSYM/rOOkY6rgGhaTK99xRS7JH7I8Yj6VHlcuIupluelaKoPT2Y90RouYJZn+buqG2fCEf1x2uVldfRgRC8vjLNr98+ETGBaQ5mo/h2SctyTY6EX6hqadH6BHHcHNVqdTng9sKm+gQqjx27HrzMTtq5Xw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB8891.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4ij+14AHWsVtamAJL9GMbE5N25r7okpH57zoTeDt9dAgZNQp03IwFcmk+QWr?=
 =?us-ascii?Q?TPC3N65IRmj3jboBaSgv1H7pT0BpWosbJFmObPAUl5GLawL13+auWU4/ObPe?=
 =?us-ascii?Q?8KnhRHJbiFUDiYB3BCHA2Dgk+ANz+UGAS9+pvbAOoI1K1wtmkWJAUuci8Q3j?=
 =?us-ascii?Q?zXru6I9+jmpOlvoSPMfLw8a1a308bnLgx+IhLWitrOZ2pZmJ9I9ysBz8k5kg?=
 =?us-ascii?Q?a/LbT5bpIhJMRATWhhHL3IjY1s5jo6ea17govfscIJafFxc4omCbcl+LKWz3?=
 =?us-ascii?Q?TEfxbyLxhE/NBomVcQliqSyK0Ttj8ohwEMffkPEeKKIs+jeTeGxVjskiK7wp?=
 =?us-ascii?Q?Dqmy7fLca/SPyZhj2OiCdq5FHdBaiTUhh/OeI7l9bow+L4zTXtkrc7Wo7Du7?=
 =?us-ascii?Q?0bYVxU5e8OqJZBNB7OgIoj/dpRvROmuihfs7/G2R6zFhrbX8EgPJ6PL5H6bF?=
 =?us-ascii?Q?/TRQjRV7vJ5XiBquLh0Ydal/w+pWf4iDLzOXuQiQ4OJg5M7PvJU63L6WSYXT?=
 =?us-ascii?Q?wqiAJiwCGvo+VVuvFOPwDvdd6WdEIqYounBH0cxwcUhcTa5DxA7lD4MylC5X?=
 =?us-ascii?Q?GS4ir4OuVFNa0HbeOu6jDNohQfVsdVtY3t+ESkkyMNe0l/cb2aj9AfO2I0W1?=
 =?us-ascii?Q?A6vkKooPJDd198t9qFvtEjfyls1AdSY11YglHypAFLfxkp18MfvVUzkBkUZJ?=
 =?us-ascii?Q?3Ni6/zlj3iNeTPABxa8l0mour3/ZZhyTW/G+o42s5Y2C3Cof9a0HnuR42oWu?=
 =?us-ascii?Q?Jgcepo7mzEBP+Jdu26U752ddJpbk8IcgqKNwdqRwOKu+Qh2DU4ypbRrJ3RX+?=
 =?us-ascii?Q?4Tx4mBB2+F7btMtNtk6xrtOpAw9reCtU0jxT+6/qUerFy58Mh4u8lwy2YK9h?=
 =?us-ascii?Q?RF/un3WUQsWf33Hs8ht9t9C9x/38stYmc3gZEUe09IlxmYTvXG4qj9oPmP0i?=
 =?us-ascii?Q?s+3iMkiVdu7vyK4UvgyfAgNsDFn2s4AvG2bppXCOLpZoyWGQuQOHVw1q286d?=
 =?us-ascii?Q?oJTpjgyC3abvb0Mc7HD0OQFkkq0hZz1tlhE5kUlS0PS+a/daEUB6PLIU6bVQ?=
 =?us-ascii?Q?JxIREpBkz8TYu4pwnRW4+QzVCNi5WCi8+MZC9kCQtzrw+vQ1Ph8MBJ7tcKGv?=
 =?us-ascii?Q?F4bKZ/aJXogyyx0unrlGslbzuFM/d9pmWCZdzeD4V/EO1zO2cd2qkq9noKAY?=
 =?us-ascii?Q?Ns0h/BPhdb5GwbbOEcMk9qUeyWcxbwaYH0MQifLW+VZnGmJMJaRN4sjXo1b1?=
 =?us-ascii?Q?E0ZyrGS987778+XcoI2rnldlcYeeXF5Y6OD3EMIa/Jhu5/4k+JdzP/ZPpY28?=
 =?us-ascii?Q?T5ftJjwYoSFmIy+U6ma14EtM2b2bUvG///IcjD27N9Yspk0Q+iUuZJKe92NV?=
 =?us-ascii?Q?vEtCbh6GZ7kdn7KWVsOQY+7XwBvLClaEThgNErGXP1f48OPY4UIis7Yu1os/?=
 =?us-ascii?Q?GwYwpXIhYKPF5ANB4qOAv9IEWn1ZM0a2cfHTRBn0kRXJAu87HDNXQggOOsuT?=
 =?us-ascii?Q?o9BJF1HH85xM3OAh6uxVl9W5n2r4ZAjyP3OKpzresKYJMKZprQl33gJnhh6e?=
 =?us-ascii?Q?5FwczXM2Qnw8/i6Tn+LSOxrMcv6EfRBpV9eKcUSiW0Yr+pTJ6KaL7CAfDeoI?=
 =?us-ascii?Q?We2Qs7r7INCf6a3mVgxE9DmV3UriorxIV2F2JtzZuwKkSdN2G/irr4GkVk66?=
 =?us-ascii?Q?Uc6gtawKsIgIcaWd+aUnkPcB5doIkTOb9cR8KJS4+A2XJI83EgGdOLqiD94M?=
 =?us-ascii?Q?koWZFzE/A26WfBw6wVhna2XBu1IqbDY=3D?=
X-Exchange-RoutingPolicyChecked: A5mPbqs/lhLI1mseqB10WEKCHA7nOEqz9mEaEm9xPT2RX5V0Q9/GfWr+dcuFK3S+AyQk3On4t2BJHfgy5X6MK/mchsxnXxaGU/gzBw/FnA5MD/Qa2EwcQMjhhzCU83/ihIhHeLUzbGs/vOa69MfoRhAs/bQFjtLav50wYYWSkg5GgikOsbBFkFfhAa6mdZahKPTCPi9BpTjKj9UqYNBSRmZrCKJanUDpFnqFwxSOXUme/eDeeFD3TfrjLofNpbw+SACQ27iLrNOx/A4FQbow9ONkDQMtkkUsZph1nJj+u08XY465/QImlMlV3wyx+Hc+mk3gW5SMssgH4WkLhbwgjg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4954a25c-e2fe-4509-d960-08df2b16f68b
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB8891.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 23:49:33.9933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TlKA1PgSn0P1SKeiodMVL9rcjPJ43QAbdGZCN7bFPTipZnB2irulJGcJqqs6PYBKFIZciryZ3xEatAIuS6EADKzSr1i+AdRL01dXhj5dQZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH9PR11MB126636
X-OriginatorOrg: intel.com

On Fri, Oct 02, 2026 at 07:56:41PM +0300, Serhat Kumral wrote:
> When nvdimm_clear_poison() fails, it returns a negative error code.
> However, 'cleared' is a signed long while 'size' is size_t.
> The comparison 'cleared < size' promotes 'cleared' to an unsigned long.
> So the error condition can be bypassed and the function can
> incorrectly return success if the subsequent flush succeeds.
> 
> Explicitly check for negative error codes before comparing with 'size'.


Applied to libnvdimm-for-next:
https://git.kernel.org/nvdimm/nvdimm/c/c0962f508e80
