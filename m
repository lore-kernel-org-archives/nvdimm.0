Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0020779FE
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 04:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755144344; cv=fail; b=nowGZqg+yMtg57AsQev+hNbimMTMNbK9IAixksMAGGxDrj+insCjRK2hukamuJjdeg5wTd7FTfma4znx/NNwxKo1GE5otYz18tT3c1Oa4aey9xP1gzJLb+YurXgQBJxkXiBn/e/5u+LdBgfvObTbkqZxxsf1yI6JrN22y3ZchV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755144344; c=relaxed/simple;
	bh=5iUQ6rHmDePwK/ztHXFuirAKqjNjkNDu/yE6KvRMgCA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GsWIt5dM0jxB42vTaqzQZahJueL5vwEyiEMnJddES4il4rwFUVcTSQ/fA/+G4IsiJlvJJTGtz1AlAj3mz1Avf19iFcF8p3YTIRA6lRj7OAaFhyFM3VLAVrVrNED3p+LVZKzZRP+8653eQrMYzk6rFl9M1p3GS27W2i/Q1dJ9Oj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wr/kCguW; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wr/kCguW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755144343; x=1786680343;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5iUQ6rHmDePwK/ztHXFuirAKqjNjkNDu/yE6KvRMgCA=;
  b=Wr/kCguWkXOpQak4Oeem0neUXdZIU5vTnliR9dxNiln3IlOXYgWiUnVO
   UDLPb9VigA4EmxdBD+iCPC8wLTAbQEsGE/35MgixUxu2Y/+t8999Fg/Lw
   326eqYatCnnvP6c6zKVlXnmbFheTGP3djKS8d3QZBlu4VurM+PxgMVZer
   5j5wbl/4bO3CnAfBM0TRA0pJbf9PS20s6PKVlTQDY3ei5moR//cb1Ob0y
   L2NnVeXS7o0yLpZ08zXXV8NRXIwaDyNaF6CwXXLMbiIp/jEz3JjmJOJmY
   R3Juldzv6fx3n/C1JSS5NyudFttTOsp8x2suxa5Mh1n1oOTO61C4al6ah
   w==;
X-CSE-ConnectionGUID: Mgc+ElqURciwInlOkFD4nw==
X-CSE-MsgGUID: 4rwqPmPfRAi5dJFZSx1N1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57520641"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="57520641"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:05:40 -0700
X-CSE-ConnectionGUID: XAIIuFf2QaS66cbl6qW2Sg==
X-CSE-MsgGUID: 33DLhPn5TbGd/r+Ss46nKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="171113318"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:05:40 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 21:05:39 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 21:05:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.64)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 21:05:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bYVpdtoUj+CCjhlJFCJKLmFG8v09yr++RLwSZlDJnP6KcHFjfrtrg6nGALeDcQohLOUjeGyJtdkoL2rC7CJhbDA+9YiP+ItJvgZWPpkoitsp4I4iJltq/g9r8dwyz5UuaG1GYFHA5ZynJmoHf+xu71a+GdBRZS8JoiA8iTPpQnaJsHokXWkTRiPJ2XBUAxLn68VD3+FgMpYQ/2CsXzRinyhS9YKQ7XSd6PdM6td1f2gt5c2iWU9dTKZeSEieLWUT6msc7lXDN50FIOZ+S3t1OFd3afnC9JWJ8BeE5pddVCdy5H9cLWeiKTXtS0qLL7tQhNkS94FAfZBOEyDxILEbvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jb6CmAd+1SOCv+zBHLo1GQDlHs97mhzCBTQ01p9YzkA=;
 b=vM2+KcCEjvU6CpXevFFvssVSl/1R7GpL+5HE6ct6YOJzsHrhtU9bQz7PlS/uKyE+RCYeFUL5qfuxBTDMFK7X7cNeO1/YrEcOVpid32+IS0NNXwMbny2I9zkTOVvASSHMiYb32HfWiIEteJU+9RA6HBgJHe3wPzwGBNgU/hipZZnVAM++b0Q8DL/0xtt2mEC5P+NNaJuc+JJH8O0AChaDNHMLS5as1ptdB9CKca4dWWWoAVCCJ4U4+Ei6cOlkIIQ4LttxPuePMVk6swiG/ymjxUMOMg+4VfAN1rHrfwBXO2qQMN8l8s87H8gBpEzB2z/bktx7UaEdUtDhHpSZi6hPdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS7PR11MB6221.namprd11.prod.outlook.com (2603:10b6:8:9a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Thu, 14 Aug
 2025 04:05:37 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::4e89:bb6b:bb46:4808]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::4e89:bb6b:bb46:4808%5]) with mapi id 15.20.9009.018; Thu, 14 Aug 2025
 04:05:36 +0000
Date: Wed, 13 Aug 2025 21:05:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <marc.herbert@linux.intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] cxl: Add cxl-translate.sh unit test
Message-ID: <aJ1gidnZblX8EQTK@aschofie-mobl2.lan>
References: <20250804090137.2593137-1-alison.schofield@intel.com>
 <176191f6-3cf6-4d96-819d-28146f4646d1@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <176191f6-3cf6-4d96-819d-28146f4646d1@linux.intel.com>
X-ClientProxiedBy: BYAPR07CA0053.namprd07.prod.outlook.com
 (2603:10b6:a03:60::30) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS7PR11MB6221:EE_
X-MS-Office365-Filtering-Correlation-Id: d5b181b0-e8af-49c2-31d1-08dddae7d2dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eM5wuBs92jQcqtuVpR+X7fOwXbTKcTuyh/9uQkWhpgbYDhmDi33AmB3+/FGq?=
 =?us-ascii?Q?pX72CPe6ZR7Bnq7SNFFhjr73/HNZ2NjtJXhob/CXAUbF1dzNkrRqwkAyTHqx?=
 =?us-ascii?Q?SxPbldHj3W6NZKde7BswJk8Y0UpTGB9RspBct33bdqSIwBYq+hKZsNXguhLd?=
 =?us-ascii?Q?0o8CWxoLoBXFf9DiM6cVVtLBWgRHOW7XiH+DevdpsAd2WNS+VEoBZRgbJH5h?=
 =?us-ascii?Q?om3drTh0VcGVOf+zV0JQWoieIL8QmUmwHr86x5PWj1BLpOC4tJAj1QukePy+?=
 =?us-ascii?Q?mTBKFW8EHVBnBzCTk4o7Q+6s8hdKHRCLmSwid/GqWdNFjjX6Zb4Cg+V7Pt0O?=
 =?us-ascii?Q?NRnO++171Gf0ZlUFx+6+QVBqtKnkNkohY553tsiJftj55/UtDfWXnd3TipLk?=
 =?us-ascii?Q?G3SccTYlEk3nyjEYE/t75FsRSAFpJF1YmwrJgwlKhnEvVWcrGTeLr67fF+Bk?=
 =?us-ascii?Q?PX7jSM+ciheALnr7/V/3921iZnIlAbZLirr9k9oNGu9oOg+Da5dLvzLo3XFs?=
 =?us-ascii?Q?YWEwfRrPI1GPWZ2usFqju269HYwIMvYapBQeM5L1x/kfvjymQ6jY5reY03ag?=
 =?us-ascii?Q?Z5ucZcVtVJE2Cpk+Zw6M+P30Hk2Htzmd2RuE4YQ4bzC9t+4CPBkRRk6kyQaY?=
 =?us-ascii?Q?Mfgfs/eiToSGiVmMgM6+byUQcJSGIRLmuGzn5Q+uCLQJCO1sNEsI5TEzpqF1?=
 =?us-ascii?Q?VrAFbJdKnpV5rVcpyE0NeNAkWzJ7o5MplOwcvFSFIWACgfRIcq8FndwlyJ7Q?=
 =?us-ascii?Q?8lIxMAVqf2GM6MHAfe2sz242JmRX0ewcZH2ut7oMYB65XmJtafEL7uqSe+Zk?=
 =?us-ascii?Q?44sgjDyAc9qqgwJuPPC6hcRTbqf/YXfV07y0vIoEFSKYy++pAQk5QX+NQ82i?=
 =?us-ascii?Q?t2oq0u5w4GeI2x60D4dCBRg6YkXamkc1lXmZW76DiXdlpR8R5uRfWTWAuRvm?=
 =?us-ascii?Q?OmOcw89aMcP2VdlRfozposrXJMNmWRnLcORVXJsXKbV20iUfnVLVpo7Q63/b?=
 =?us-ascii?Q?2IcDTQfWxGSQX3L/7cGNRlNa7dAnrhr7mhl2FSo0JnYSVpIfshsLCAHg9rD/?=
 =?us-ascii?Q?aIgNgVujd4Utu+/5iEuGM/fZX/DO/yaCkmtzhAK63XyeYP57LmZJmvAMYxDj?=
 =?us-ascii?Q?o4gRfLMK7hH2/r2eSZIVbjR9SiCYG6NcKBN6izMDbxzuZh+PpobQlW6WV4xS?=
 =?us-ascii?Q?ZEy1puVgvh1UAs7JJdeAwJlR5qOwU7vLftRECfldo1Ev5coioYIX80DQ+A0C?=
 =?us-ascii?Q?iPxv6Z7kph3jlXJTTBtq0HQycbpFTVm9aN30msgYkrqbt/KZKkkGs3CcTRY8?=
 =?us-ascii?Q?JHrH9xGhT6cZh7W1OTVYY9saLV2ctGKf60bmdCdtBhEPQO9arBoxllYMhhXP?=
 =?us-ascii?Q?KWrvLnA3mupKsO6lRZEDTrbQ2bn9M9KwSFLfC7dqOgQxAaqGahW8B9XZhA8f?=
 =?us-ascii?Q?FUv95rahogI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o7bB+M4Vq43a3tc15/W2RyufJ06q0OUi3gUHhaMdKYBcIGHe6Q3hYXvG1Wwc?=
 =?us-ascii?Q?LJKiKegPDdfb76IBy/nfr4pkFYywdDBtsPwKKk3bp0zkYSS82QTyCkaI3NWr?=
 =?us-ascii?Q?nsz4yM0HbNQcn2lhwtTY9giz6YAYWZBZBNJs3sfmvjaBHB+I2BlyW0JJih6y?=
 =?us-ascii?Q?N8atJPKhmfNgSiDhFVrQvzDjJYmkKWjTvGgxzjZqTlEVJLMBX1cjYUoOKpVb?=
 =?us-ascii?Q?kInV2YkIjJKsrG3G21E3GqHmLz6Uld6XXHHC5gKl+yeUuUUp7H0CPhWy/rPx?=
 =?us-ascii?Q?y5aEujFLYsaYnR/bVEBzCYwrVMXxFecVT7JpcJ+Ru14J1zPGX2RJaDtEahsF?=
 =?us-ascii?Q?TGrPFXD8VUbRX08izIh+ENCrk0PZz/JTXq2bIiDgN4byafH8+dIF4ZzD8Msj?=
 =?us-ascii?Q?+eGRfSlYwDIR+VgzeKeUIS8C22pR+xoUfZ6TdwU2DBC4PdEI3P3BpwyZmwL0?=
 =?us-ascii?Q?13mL9ixg+4W0IqVIWwrsteRx6Nh28+jzhixb5JrrMMC0HZZWlKu7SX6mjAoW?=
 =?us-ascii?Q?qwOPSEp0uCpdkw2XAxQ5GCX5+PgyaqWVMul+rxbRmfIlqSH6RrO9uGVMUabF?=
 =?us-ascii?Q?TzQtswqB4puNMZiupRu48mHurg5G3xH9Z/+inTIUu/UMYy4hJ530T7XLwm7o?=
 =?us-ascii?Q?yfBQQjUd8AxtY8lZWNDK29RpCHLolGPoHLmJvIa6qwOaK2Q/ZlwAXSeSp9By?=
 =?us-ascii?Q?mB9hSmVF6uKzxWlOYWQ0pX2WumiKu7OC2rnqyuFmrgK3k00fXFC3LpsznFCg?=
 =?us-ascii?Q?TFBp6lNShcjncpCGqPN/f7kJbh3MYiecRYaF46MpcVav/mPyk6jW4PRCF1Rw?=
 =?us-ascii?Q?Xn75Dq63HVI3Q7sA9VgiuoMUWyfV2qr6WOtWcug/nOnFvllWcq6mIBJQNPXw?=
 =?us-ascii?Q?PYNUXAQhvMlykl8Ji+T7S5PHCIR+3i8mawvbdIERpc5I+UK0OA7CM4Gnnnhb?=
 =?us-ascii?Q?jl4q6ShlBwVe/+M6DMdgFSxFjogNg05wkrE+NHx8PhslalaG82zhioRmpLCV?=
 =?us-ascii?Q?YS5ujy/K9CiLRKPqzy+tD1N28xamulHCCGr6UROJIdF9mYEmJzZUHKpwVUZ2?=
 =?us-ascii?Q?pyh6/gENgdnsTRHqSUQPUgV/Gd18t2ImqHoyVc4zyxUDXglsO+cI6FVleLHG?=
 =?us-ascii?Q?UQxujIiuzgKXNN7We9uJlCxRIfoBPzS59QSarjGOAJHHrnIGKJM/J/pnzjoX?=
 =?us-ascii?Q?XZmU2gN436vOEc6jahdHtKP2AcKcoi74FWR3LlMGs7xoT77xvALOeTZyK+QI?=
 =?us-ascii?Q?ilC28IfRIUMQZUv1EqWMVNaur5Sxwv633HXXD+zNXuSrbTgJ1b3sg1lNshqG?=
 =?us-ascii?Q?VshGQiz+7L9i0/O1KMBgEjK4uVANC0wGb/vAn41umWbiZSjKh9Xm3m2gJrXC?=
 =?us-ascii?Q?6VDhD68FYjrqqzNX+Bl3wPrmcYEPudSTLm8FP5fRBIWpxfeZgXw7JCm9dOkm?=
 =?us-ascii?Q?4kdGNf44+V7UxQWM2r5cx8lRVO1XqkEUIb3RbW9AtJ0e5BzC8HrrR6Qfnmn+?=
 =?us-ascii?Q?uGfWYOv4uKN7q/dcCzanbQVcQ/UsQEWADKghUl4AgZ2oFit1uLIkZ8jPq0MG?=
 =?us-ascii?Q?eKMDWfaoaHV0B5NIle7sSiYj7UV9iS62zj9tQNy3b0bL778ORRpYNCo31LBz?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b181b0-e8af-49c2-31d1-08dddae7d2dc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 04:05:36.8592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iqe5mkGNcQvyao7ppnWW+EWzy8iCOUF1tizjNYGqY0QBSxn+vXJHNcKtHlnHqWTUzp+fpSwUvGl0lcbe1zoO3KppTjGvfrt7NiKNp4VlEzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6221
X-OriginatorOrg: intel.com

On Wed, Aug 13, 2025 at 06:28:14PM -0700, Marc Herbert wrote:
> Reviewing only the shell language part, not the CXL logic.
> 
> On 2025-08-04 02:01, alison.schofield@intel.com wrote:
> 
> > +# Allow what shellcheck suspects are unused - the arrays
> > +# shellcheck disable=SC2034
> 
> That's very indiscriminate and shellcheck -x is usually pretty good
> there... did you use -x?

Yes. Shellcheck -x doesn't ignore SC2034.

> 
> Alternatively, could you place this only before the arrays that
> shellcheck gets wrong for some reason? (which reason?)

I considered and chose the global disable for the arrays and commented
same. The syntax is valid bash syntax that shellcheck has not caught up
to understanding yet.

There is always this option to see what may be masked by shellcheck
disables:

grep -v -E '^\s*#\s*shellcheck\s+disable=' cxl-translate.sh | shellcheck -x -

> 
> 
> > +
> > +check_dmesg_results() {
> > +        local nr_entries=$1
> > +        local expect_failures=${2:-false}  # Optional param
> > +        local log nr_pass nr_fail
> > +
> > +        log=$(journalctl -r -k --since "$log_start_time")
> 
> -r is IMHO not a very common option:

I'll expand both -r and -k options.

> 
>         log=$(journalctl --reverse -k --since "$NDTEST_START")
> 
> 
> > +	nr_pass=$(echo "$log" | grep -c "CXL Translate Test.*PASS") || nr_pass=0
> > +        nr_fail=$(echo "$log" | grep -c "CXL Translate Test.*FAIL") || nr_fail=0
> 
> Not sure about reading the entire log in memory. Also not sure about
> size limit with variables... How about something like this instead:

This is reading the dmesg log per test_table or test_sample_set.
There are currently 6 data sets that are run thru the test and results
checked per data set. Each set has an expected number of PASS or FAIL.
I'm pretty sure any one log is much smaller than any log we typically
generate just by loading the cxl-test module in other cxl-tests.

I don't expect to use the general check_dmesg() here because anything
this test wants to evaluate is in the logs it reads after each data
set.

> 
>     local jnl_cmd='journalctl --reverse -k --grep="CXL Translate Test" --since '"$NDTEST_START"
>     local nr_pass; nr_pass=$($jnl_cmd | grep 'PASS' | wc -l)
>     local nr_fail; nr_pass=$($jnl_cmd | grep 'FAIL' | wc -l)
> 
> 
> > +        if [ "$expect_failures" = "false" ]; then
> 
>        if "$expect_failures"; then

Is the existing pattern wrong or is that an ask for brevity?

Thanks for the review!

> 
