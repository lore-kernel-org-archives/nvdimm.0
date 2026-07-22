Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B45345EC1
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 20:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784752840; cv=fail; b=QUzCIqKSoM7Hs5o5i5o5ZTtE2ZOTXoQb3ztMYC5F+Aydi9zckcXf6MmdF92DRlNeYTtmZOsDHHZRfHGqe3QicT7H+S7OE8OYiGsl3ucs95Rn/mvIWlWV4wm9WXGi4EdWSzL5RQr/2hAi1qWl6lQN/oCc41HXN3gJZkXIRU2umgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784752840; c=relaxed/simple;
	bh=q0FkCD8He/3P8zMyie/+mCqtq6LB8eJ83iWQOUkJ2iU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Kg5Nxsuh0PAFqkX6LluSSarTH/21l+FxsDbx4lnlwdFS+hbRQzqZ9W7Yzaru2jmxPGE7xAgiZyBfb+WUCooxe/K9mzx4LcwXti4bu7bR/q8RI5kFHYXrCUcfjPUeG0Mh0oxH3Wp3S6sblNKR7Hm6BcTTrTSYepQ7ClBr6ZnzNkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bb/iytka; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bb/iytka"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784752838; x=1816288838;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=q0FkCD8He/3P8zMyie/+mCqtq6LB8eJ83iWQOUkJ2iU=;
  b=bb/iytkaslSXvAUJ0FI6ozlmNWQzBjBU3los5AGMq4wyMdrrMszHe3yI
   KFD+u1Ml8yhoOz0HTYBRBO+P1hCzh+uxkGoD1DIXugCVPq6Hz+nMD+Rel
   bo/jlUu4uu/ClQg9PqPhbHbSmDDdG/bgwS+8luTrN3iUYBU4stjO0VLiO
   ZVEy0jobPW8LmJGo3C/5hVtDL9Z4gvr3fGnH/xgqXJl19c1XWpJvPMZ1Q
   /UmZkzWd6GssHfyJtYLW7Wl+DGQW7hq2vefZmDHVReLYD+r1c4VwN+YU6
   fdXp2cYfVgbQgQ7QEBZj9heJ4Wqsrrlo4Z1VHDXyN81YP6bbEJTe51zVG
   A==;
X-CSE-ConnectionGUID: UUDZzjj5RvC+I9acuamYCw==
X-CSE-MsgGUID: KyW3vrPSSQ+wS2McQqmg6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="85254188"
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="85254188"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 13:40:35 -0700
X-CSE-ConnectionGUID: pWd+wbVERyiNGZMryImUlA==
X-CSE-MsgGUID: DlTmousxQtmYu4cwz+i2Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="257660091"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 13:40:34 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 13:40:33 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 22 Jul 2026 13:40:33 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.65) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 13:40:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kbBDnidcFtTrXPUOtWcoxGrtEw3+nHh2I6P4ZeAvAu0SAFcvX6xEessxi7a4h5VJncSg/V5DiH0npEy0BfjvWi6ai24GYsjvlFVS0ij6GHYMkxKUyxjn9yH/Er61KoE5SZE2PAnxiJeXQagalhjAl13CUp8XZOvknCeG0siF21bVU5chZiZupUoekUtbwoqIz6lsjekWc130WAv6cMiD7DE++q3t4B5zDTbP6fwvqAzPinGvByrHYPtiXljAAg0QTz+3ldi6iMAxfZZY8vZLFWtwtLA94hYC5FZlkIbq/wkI9mtlX8y1qfx3mkLTIDGeEEa2STp3shGKk2m4wtrHjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irZGYYcjUwE+pEx63xSD5HQoqrnk3Up7+1Nq/1osyVU=;
 b=tI5wHZuDsSTNZ3ZVIU//CTg0En1PXKIzR1G2xBdAk0DiUv+R8yE7SY54VWkaHo1CxlQEwtMlJGAogJTjObZwB4NxzJq9ghyhno6WYQnAykRp+1cHa5JL9tjYwnCgHZhinghLGgOrQ2jovXlJWcYSMhKpPwQGGxgq6LmzoRRjAvPiHCZ5UmT6FIndbasnKA855It18RreIEnPG16gpXwq/emsDr+R7UOxtFo+zdmkKAp1r30YOmlQTgfDtjZPA10yXaXv7EWmp0T5tlFz8js6hJurEdW3lpGysex3GNAN13Xr+SeQKUe4y/k7MJQBgrg59oXO5TQSwt6zwzqexTse9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by CH3PR11MB7818.namprd11.prod.outlook.com
 (2603:10b6:610:129::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 20:40:30 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::d1c4:2ff2:daa1:d1a3]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::d1c4:2ff2:daa1:d1a3%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 20:40:30 +0000
Date: Wed, 22 Jul 2026 13:40:28 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
CC: Michal Schorm <mschorm@redhat.com>, Claude AI <noreply@anthropic.com>
Subject: Re: [ndctl PATCH] ndctl.spec.in: make xmlto BuildRequires depend on
 rhel < 9
Message-ID: <amEqvJxOmqT3iM2p@aschofie-mobl2.lan>
References: <20260722202859.2021117-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260722202859.2021117-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR03CA0183.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::8) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|CH3PR11MB7818:EE_
X-MS-Office365-Filtering-Correlation-Id: f9054eb4-8ff4-4a3b-9b83-08dee8317888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|22082099003|18002099003|56012099006|6123799006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info: B9RjTW/C/RkvwBEJhGe9DcTRWBpvHtc51kHkTpHzCTShGGgp3uS+Hke5kglaN+7ve+WpTsGaqhVwwXwj2/x54LpjWQ1nvm254vTOzwT0afOIsMDxK5V/WvvUDMDAaYh/WoWPOgn7dM/uJONRzUv+0nVIX0HJ0fblK6X9TvYZ6MZ8x09QR3IzYgI+olHC0rYz0NPl9ABZsd8VIT2l4CujguJ8nc+kx8xqZREh91pRjZVJJtS73ji4JOIb60EaLzR1axwvAlcydAxH3R+CNdr8ox73Dz911KoPTRMHnqm7DJxCbt+T80CVZ/4bMjYh4CAO1TVbWy8oTZn3oOPH8+hkAEZW0EUhDtu6wECfP2hkonGG+mKvzleofIdIyymP489d0UFW1QlQN17TCZSw4l8TkQHM+MdZmHI/EnWdlsLkoDFXA0bgRpGLLjVsyHzQYN3xXmGRdhl8MbQ5vrvJNvNLHuNleFStjtUz41WHgEy6fSQH+tA8w2ms2jiB1IfUm8Ue4KKjVLmZLt96GzNe3FbvK2iDJAUmHdNXm/mmPej/qVS8hRer6/ZNp/cHm5qlJQY84g38/tNc7OsKe/czcO5QEuxgFabgrg9vbleHKbQwha+v+QNzAavmePTEqu6hF+EOYzfMaDGTJ55Jrw9XqjK0t6vbY87BlK7PlLLPbmByIzM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(6123799006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ApL7wZWzBxURlgl0eU60ABAYPeU9YWqexSgkueUfrAaRLbI3giilh1s6Ic0d?=
 =?us-ascii?Q?Z+LtyGM1b75ONlFLKW3+Fk5FGeFEkSoEm0YueIkcbFW2srWnz70Qv17SJMbT?=
 =?us-ascii?Q?I276feL/+y/bjitujfPL4vBsjWdvZKySzloJ0fFhFmSwtRsJbBLOXNvrO+Dc?=
 =?us-ascii?Q?ni2RQ5LONUN0uQhLH3xfovp2xxXq3TvvH8IgcygWmH9tIcTphr8WxQ80OOXy?=
 =?us-ascii?Q?MlE6dnugImeUQv/XLoWkTgRKaV8iPD/txaXf1CaQQRe45NaG+dqdE+1LoFOG?=
 =?us-ascii?Q?iN39y9zopN1ycALfTDWy7HmYa/jFWX4jsao1vsb0/pOCU986ZF3w+mRvQNoB?=
 =?us-ascii?Q?Ejj9bKAzbfvDzYLMgWlBEmWDn23oMAXGcp04SwaA5RPjsSn2ktooIgVtLszJ?=
 =?us-ascii?Q?NBdjHtQwWxENR3ggk6zaIr0TRHThKPs/UenjdhoiNrPm06RXF5IYKmGC5QDE?=
 =?us-ascii?Q?aAHdQeAXyC81pCH9SQM/6lAebwKc9khp9rRNo4/mdi+3P1b+rv6hBar9Hdkz?=
 =?us-ascii?Q?7kBNKpY0RKRK4Q7KK/nSXR/oedc/ReIWrYi4BBw8RFhr/Z/3yX67agv9ovcM?=
 =?us-ascii?Q?yCBdQNaAHg2Sb1CJ2ddtbAft5pLYTcNaD/rpf7JITVuGWOyCQ5F7tmor0Ome?=
 =?us-ascii?Q?nrUbMrNa8NeLXpRg63xIwU4N1bGnFkDIFTsvLVImAWkgp0AAieh+EnuZ2/RD?=
 =?us-ascii?Q?stggLIILoLUpNE177qxhOle0azR74ObJL5meCo0xayA+Zom+KlO9P8wXnipc?=
 =?us-ascii?Q?9F1NMb+jAgsD6BAmAlLxAuUIoY83BnwJo6wiQNFYD0x8+Qrjo5q5EVy5eOrE?=
 =?us-ascii?Q?CbZnOviVeyaoizCSfk3nRztwqPGoAJJc7b/YYNYQ08Bc51lPdNHZTTOw2/cp?=
 =?us-ascii?Q?AK8QGBQRcxEGtLNrw4sq1tV6cbEZ24aqTnfPUW+CAIOhamEZzQ4Nv+dzOREk?=
 =?us-ascii?Q?6WQMkZ4eWzDW/QnNerwwbpGb/U6gr5figQUzPN3gSakPKxZMJ0sJXU0E1zy8?=
 =?us-ascii?Q?ax1v0FFCkCEl0LYsYbDsAhorShuv95ZJE9QS6rbu+JH5v1pcx05gFAY+1ENI?=
 =?us-ascii?Q?8J6lP0BcGGkbWDmW9UbznTiZGziuYepNiC86lAK2VKjhW7l7VzzhvF2/mDK/?=
 =?us-ascii?Q?V86XcXU0A9KUX6HcneDJZGpK8uMIhAEZJ4aLugXLb2L87f2RUtzI1CqQWMPF?=
 =?us-ascii?Q?tHHW4Jmq04yZezzRrHhlVqlQdf6+2vFaC0GqXtzjwjFTUY6yx3HCp7yZ9++3?=
 =?us-ascii?Q?H/21VfsNpSU1fw5JBtJMmQKIpaCVZMtHZj74yIVImQ3KBDuYjzKQco26eGDU?=
 =?us-ascii?Q?owjs7pcECmrf/FXw8iHRnSnjaB4yl0HMejsLlOjDetabhtKQyGsARE039QXJ?=
 =?us-ascii?Q?Tc++Oiu2RRChZnNEG0vzLlvXdklD+Avqk3REskajzQGA+YR9FSjW99s2LGMs?=
 =?us-ascii?Q?3sm4fGIGU+F5uLY+QK+WNQW+0EFHqnJ5wm1O8uyVAr5+/+uYGTmYzdoLhNxS?=
 =?us-ascii?Q?okB7VF32pKOSkM2Ip5KAlAg5sUSccCo4F8EPwu/FXFn+055Jc7yY26FQ62BO?=
 =?us-ascii?Q?48X3Pb1yJngQPkHn8sO3NdigXCeDWELAZYL+Q/il2UFH9ZUhY5QYkbn8UJ1g?=
 =?us-ascii?Q?BPYpdO3uoKAnTtIlN8KZMJJ1xzcpsY5crIgxkvgiMwDnL67WxDbmWzQz5ONo?=
 =?us-ascii?Q?n+tA0n32egXy+w8OhlYR5MedXax+MP6pVvjdYuqkZSSnXjXqQpBMf/5+uCTt?=
 =?us-ascii?Q?y4VaCIk2yWJmfRCWN8ut1PCqF/1taUo=3D?=
X-Exchange-RoutingPolicyChecked: FSYPOdGproZ4A4IBWl1kvA0TTxGrJyjKyTfaQH1qTJpS6WcnIli948lkGl6I6uunt+0/b5fEScENMx+9Dw0yFMag3jGH0CaLoCK1WELXAriAvfYFLZbqeqQGHBYCHOOjVvlROQXwQKzDlMuj1zHaZMrtr8oiMZYe87angMD7agQsM2FwhOUxzassPZyd3ZNeOY7tEC86iEpcIxqXkUs+oXvHRQdr9oMmwTtknjNDmDgyhZ+RVLpGInHRQuXbN5SXJRVQAu/JTAgyHFF7PPqZBCmrxQnCclPv16BDcHekaMBmDozR82yk5jTEXrh1SyUNi7iWMWN4Kt5pSjNAP8jpIw==
X-MS-Exchange-CrossTenant-Network-Message-Id: f9054eb4-8ff4-4a3b-9b83-08dee8317888
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 20:40:30.7817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DST/iGtEEoSOTZdud+iR4R0o3c6sQ7iYP8jdBISVatfBSXokKEc2/iIRCYnWea8bZnO8Waf2V59sWVHUIYpiKf6HWdUBw4GCPyYXcxnvabk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7818
X-OriginatorOrg: intel.com

On Wed, Jul 22, 2026 at 01:28:58PM -0700, Alison Schofield wrote:
> From: Michal Schorm <mshorm@redhat.com>

Mailer caught my mistake above, missing a c in Schorm.
I'll fix that up.

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/

> 
> 'xmlto' is only needed alongside 'asciidoc' on RHEL < 9. On Fedora
> and RHEL >= 9, documentation is built with 'rubygem-asciidoctor'
> via '-Dasciidoctor=enabled', which does not require 'xmlto'. Move
> the dependency inside the existing RHEL < 9 conditional.
> 
> Related: rhbz#2503124
> 
> Reposted from:
> https://src.fedoraproject.org/rpms/ndctl/pull-request/4#
> 
> Assisted-by: Claude AI <noreply@anthropic.com>
> Signed-off-by: Michal Schorm <mschorm@redhat.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> ---
> 
> Michal, ndctl tool operates via mailing list, not PRs, so reposted
> your fixup here.
> 
> 
>  ndctl.spec.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index ae9466c45192..f6c0f6992249 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -12,6 +12,7 @@ Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
>  BuildRequires:	autoconf
>  %if 0%{?rhel} && 0%{?rhel} < 9
>  BuildRequires:	asciidoc
> +BuildRequires:	xmlto
>  %define asciidoctor -Dasciidoctor=disabled
>  %define libtracefs -Dlibtracefs=disabled
>  %else
> @@ -21,7 +22,6 @@ BuildRequires:	libtracefs-devel
>  %define asciidoctor -Dasciidoctor=enabled
>  %define libtracefs -Dlibtracefs=enabled
>  %endif
> -BuildRequires:	xmlto
>  BuildRequires:	automake
>  BuildRequires:	libtool
>  BuildRequires:	pkgconfig
> -- 
> 2.37.3
> 
