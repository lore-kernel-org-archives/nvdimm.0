Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCD127EFF4
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285302; cv=fail; b=BwUjXCnI8eG7dWe190a2oL/SqHd+U6pJWN+x9zGm9je0C3SPWIu6MsSP/fGcLhfwGx2N9jdlKoMqBlAYwzwiRD8Ql0UItuE9lb0K42PzdhJfgoHgWirqv5YiSP8+7Ph4RL7pkNh4E+Jpl4S+WKbo9rRoVbi1rVWrDcNP3pLQYNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285302; c=relaxed/simple;
	bh=SjKoIjX+SegzTc0nAOAVuUNhk/UU5QCf5FhxaRuTTbA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DoJnWYylM+ZDdV4B33CJwbpYta+kEAO30MK3nqFxcS24VELjDn4UPQPg1bTOglvA7OoMMx/DySiHGd+7h5aacoid9/a0Ht3Fdbhb6jivsVVGAn+r5dN6uYrBTfyZ/HWGomzr78Br/5Q0fcXm72nH/ZDiHArn97rPufDeBTERFP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YMLCWxfN; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YMLCWxfN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750285301; x=1781821301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=SjKoIjX+SegzTc0nAOAVuUNhk/UU5QCf5FhxaRuTTbA=;
  b=YMLCWxfNxs4eV46SoxEO1s1FVUdO3/gg4cJj++5NKOI//8FpSLh0Ieze
   5syjhTAKPc2No+KUmNASdWIeT1FZFa8BrNKYqw92PMbU5T8iIf/IgDMH8
   0NBcISudqZu8W0O/+Nobzv5TynVo8KMn3Re8I5AY7mQmzIrYGnY30dgq7
   gRCgzwKyy1B+/Ok08tJe4IANiUx1gzdpNtYCFIpmCZjIGVp9VcAwEsZgA
   HcARyHJqgSdNG6whfjH5McYqJW5FfuVsvy9tpB2IZa3KrZvZHy+Il/stg
   IywrLmFRc8wjx+laqY/auPBlGUsNHr8BAfyIzMjTXlsTShfAywaLkSYQg
   w==;
X-CSE-ConnectionGUID: OZGgZvkAR7OFbD4ACbuy3w==
X-CSE-MsgGUID: 661zZSaqR4ioJSk/Vk55Lw==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52609636"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="52609636"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:21:37 -0700
X-CSE-ConnectionGUID: L7YqhLPCQQ6qbduW/FC3Vw==
X-CSE-MsgGUID: vt14rZriSG2ysnZpEz+9qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="154806019"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:21:37 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 15:21:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.40)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FJJbzTYMeYXwdEqWZNj9hNAAJjiPTJ1mmSt0Co0i6IZ+WXyMm9/LwWd+EwKtd5GiMo/3106pbk5hC8ifUg06uMuosF+aJPPceYbwtofTahZpP1ujS8GCe7WqnrklnWzRmU5p4tktcJ805+S5Ok2Iy3JaRLm37G8qLeJaaxiPM9lK+52GTpkA3bf1Ycy79VTD36kOlQkukge8r4ce67BRB+t4VgzeW9aL7p2oAhRfKnLdcXFg9wDmluufz1g4nsXKu1J2CXsS+QIxtt/5MuMxti89JJ9TBeLXtzRrlfMzQAMjQKDoCr5LaRdRuzpdPbStcv/wwJet4rRnDstJxvszKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxpXDY9KxceAG9wgyGmcMtfmPsrIqwdSXxGGhDTlJcc=;
 b=NWG7R3KTDInIqn657x+ReZnNx1TiD14STJVDaLxpRiH/00djWFsOpr5D3cAA8rsuAxS+F2gLxjs4CK7E6y3lb/9ZttXT8oEAPYPLIBIqb5nRvCEjQEXXyGPgYgPjcOPhAPze7nspkCtyaQ8rKFZCz218LQUleUXIgmo3WzLMeICSt6pD3M0UgE0CE+46iDUfQnxClfhtvdE/Y8tAgfuezUFG5YkgVtWGr+WwqYolTPl1lsKrMJoH9rh7LVCfSb0+VYB/MnUWsIB8XXo56ht5BGNCWC9l6SqRzFY3Ne0UrVFzVRv4X3zKOT4IiJYXAP6CPAvul/Pp+ncUL0pAAfxeKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB7668.namprd11.prod.outlook.com (2603:10b6:806:341::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Wed, 18 Jun
 2025 22:21:34 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 22:21:34 +0000
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: [ndctl PATCH 1/5] build: Fix meson feature deprecation warnings
Date: Wed, 18 Jun 2025 15:21:26 -0700
Message-ID: <20250618222130.672621-2-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250618222130.672621-1-dan.j.williams@intel.com>
References: <20250618222130.672621-1-dan.j.williams@intel.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: c2da306a-d029-43a3-b57e-08ddaeb67baf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rdEdV+C87ev8OEVoo+L6M7t9SpXqLvHdzWVWSNu1MUH2eULQS9wHxiawjSPz?=
 =?us-ascii?Q?GSptb+0q04ZECzMcTQs1t9I74mDIaevX8DRpiAgVYg/Z0S5E1K0H9ylZNRbu?=
 =?us-ascii?Q?1lMc7nIz412GBP/+Xj6uMa8XnvB8rgf8nJ0riAigPKw2blgSH60ySlea4nHn?=
 =?us-ascii?Q?Z1UiSeVvMCzeLQQetMuv63qJ1U1W15BxeVvYVh8dMzSN2LNRnX3e1koO+pbs?=
 =?us-ascii?Q?Y8TSF8R/OjUiRQdhElP7GR68y/hhsGsG9QtH+E9FgVhMH85ViGGAdgoA8j+Y?=
 =?us-ascii?Q?eyFh3RsH2GWcF3udgiY33FZuqs0TpYmFnlpY2xxnc7S9Yl3D5aSB5K8o/ZYv?=
 =?us-ascii?Q?tGyppElMKnD7zUaO2vozhz/LrOEZ10x0vT1/1fk6h6OIiVsAn2V2pqxAQ+YY?=
 =?us-ascii?Q?uKWnw6gXMPHCwwXumZ8NQ7TGYKbDIFFQhkgCurHMtXj9tpQKjiUlm2IvSCAn?=
 =?us-ascii?Q?H5774A/qsrCcv3DBXv80lX5CsXJyR/363iIo0EVKUhNmGRo4HbZVwjlfIrR+?=
 =?us-ascii?Q?Yha4Eusa+/nG1JhJDMm/gxXA9t2o8+WcGfPTVTXj+V+CETck1PKURmnTw9P8?=
 =?us-ascii?Q?9H9lBb5rrXSRWcd9vcnJYJc9TLv8/NDSwYfgt3vlb3Sm4Qql533NUOU5F4ea?=
 =?us-ascii?Q?axSvqZWJ1AsUsrLvebjNzyrS/Pw7PSxn5nKSetYY024FnEHnGypDP8vpIy8s?=
 =?us-ascii?Q?92Vfl8FX4E95W9Rkbeeys1mcyDcDNr+vFdo4QCfMSAjhZA+2nsRJlxpue4tG?=
 =?us-ascii?Q?fX6TKsRno3zFkdbhdFvusJULLM66is5Y8lpNAYYGG+HhckpVYvt5T4Vy/tct?=
 =?us-ascii?Q?TWdrz+qKHSdBuYjXRciX9NT9Iypc4zfX5Rk3Sh0y8d6UXdsRxuGe5A9qRk2G?=
 =?us-ascii?Q?ItyQ1IQ4FGqLp8kWv/qBd09e5d5ywI38DN+xBC7I+VW2KGjk1kHw1oglHlJk?=
 =?us-ascii?Q?XJkMIHkN+QhnyrtTCiL7nlMeHbmoI+CPVMZkULOKRTW9rTtSmdrpswIAvuj4?=
 =?us-ascii?Q?nOCDrkxFhRhAsgjfIuk7NMlvcSgGw8o1WfpFyzkDfYrcABg5mDFj/s6Wybj+?=
 =?us-ascii?Q?JBoJ7g4Su64zzKeJo+Mnr2MLOzv2Iva3EtWzryPEjORkTrD8CxY5x03kBfuv?=
 =?us-ascii?Q?UIFtlDI7X7BOZaYSBr4FY/g4tGKzkr1hJ0pLCxm7QaBNx/2YVmLbGUHxT+hI?=
 =?us-ascii?Q?1DFF2fbPJHrhECoOt0gKcUJijNqTv3/P3FlWJDnBBom608wQtODdJK+IqJtx?=
 =?us-ascii?Q?Y8jwzk6dJlVUFKCGMiuMJ2bs84XFJ7JY2iBqCOZfw4241MuA4JvIGz6Odd83?=
 =?us-ascii?Q?6OGuSQr3SchDsp9RJZnZwrt4h9vOrDx7hDoArZ+3Z/P2WMY5yOxiV2mXEpl2?=
 =?us-ascii?Q?BGZPtju4bGtnUSR/jXp28NpdIzIBCxzaJ6sib4WIvHGlEtG30VaQ+YmW42ry?=
 =?us-ascii?Q?C176mpduBwA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Iyv0k3xSbw3mfpxY/wJtcUFZns36V/5mMzC0iJFI5xJci6zzZbbFLmScABZo?=
 =?us-ascii?Q?Fr0GkONvByqRS/Y7e5wemxpdrfHfHTrr5WhLMSTCbpXVVJoyV4ahh7bY0Y+E?=
 =?us-ascii?Q?xO5amK5bV+nnUIbBTDpnm4qUfLJYZzauj6XvMNeqqLvW6ewGzo7fj4YSeOwB?=
 =?us-ascii?Q?HM/Bdada41Znqk9HIOZONHItrf5tRDzZR/YEwUcEu7PpyJryrjJQC5kdmxqp?=
 =?us-ascii?Q?LXKVkMSKtVKwpp3/IqNCF2YmqOr5/GUvZqEUeK5JpTf/q2CMEQPjzsNGh4We?=
 =?us-ascii?Q?AVr2Xh9Tdftm0xXKGUN23J9qdAg8XdX+mq43sNevDUDxb9y4+T0Ec54T50tV?=
 =?us-ascii?Q?MZhNgX5v2IpGnWUKoy2VNNPvpQ8SDtAyCe9UX7h+5uYraAxzN/4WFPuRqLyg?=
 =?us-ascii?Q?HlL7TzO0V2U3X4Y3+fJVwO+miIJoQ8iE7pIMzVjLQooNYHQ8W9Mn4FtDTPAn?=
 =?us-ascii?Q?9qcCSpGA5JKYyHtseLW0VG3bPw1+lGUGrUHS7B8U6kFjVzJi8VzxWQFFyura?=
 =?us-ascii?Q?ACSU12Ov4CDd6qpOZUdVV1VEs2sUY0jZnygFtSPlRy2SX8wtniwwIaO2phu9?=
 =?us-ascii?Q?pFTm4Awv2zyWuFs2XqRn6TDICMEAZsZkwU7nlGC7f71Em2CqmpC5p8blp6R2?=
 =?us-ascii?Q?O9+jWnM/Zmeyd3jHTGHmAONbBl+YWCqphvBuocDALToxjNavHSUlx1B2tnCv?=
 =?us-ascii?Q?AIdOwSda/sXGnWHOjNqvvFfxd3cFKG1aAXafxzxD/RkImQHxGlpx96noEZDX?=
 =?us-ascii?Q?YTJ8WZbqZX0wBTfpFtbumZj7kMnvYfrsrE8cBgZfchhvNeilAcXxoeT4aw7W?=
 =?us-ascii?Q?LlhH9XvdaCsSHJsUcxGq8pUpxu5r4dUlx9gyM4q8JK7Cu8VshOKU5P0OkfrM?=
 =?us-ascii?Q?qP+xAo2CO8d4uDDov/QJUnmL2s4m727R09/UsA8YuITAQUf/3wumw7Kpe/2D?=
 =?us-ascii?Q?h+QZjiXsVpc6kgGgfETUYbza1/d2a+OGtyE52LJA4A/lcx3q7SprxJtdOSR0?=
 =?us-ascii?Q?kSRCXROCEptBrsCWMG6mobZNCO9jcSkUkEewt1lFWFDOtq6Rwni0/OWu89nY?=
 =?us-ascii?Q?w6sBft8nVhn5h7q4/XgidVd2DhtedPBOMKTZTEWnneA6wp8DPlI9FXN02DnK?=
 =?us-ascii?Q?ykHwotDh95rTy1TpFZ4mfeVNF3W7F7Z2EEc6OZU7Y4YQoDkWYy2HqQwCa1CN?=
 =?us-ascii?Q?0nQlddW5EVu6ye5K1Nx8i4wDTQzaeVvoFicl/aTAx5JgqrGgoSXtJ07Qzo8q?=
 =?us-ascii?Q?DkQ0XUD6qKXPmfxlGDXq5JKw2yT3FzFObZXQfUHIjcrHTfgxikD++aoOV+xN?=
 =?us-ascii?Q?0Hdr9yvxVvHBqGce6Gf7wPDXHjDzccaNQrSnj3iyF6zmaxW/oNOo10ttD8DL?=
 =?us-ascii?Q?RAU9HjPu4QC5UR0Pj8s4m81v6aEyTid/G5p33LLISxilPJXeC6uosaGGu8RA?=
 =?us-ascii?Q?WMISgPab07dgXBECyBaMnrgqFx/qilrcCxQH3ooerG/zgyldQWJA6AddAfXA?=
 =?us-ascii?Q?l9VyNFvY7fJCw9cnP9PIgm2ge+C7m5ZDRekkWTtloLoqYSGFOYkBK6o+zyHY?=
 =?us-ascii?Q?xjK8L+X0Y6fnznIM1A1bS0qyDsJL6xyzEQddKC2vcB2XvpRY/GfzBwBTqjOb?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2da306a-d029-43a3-b57e-08ddaeb67baf
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 22:21:34.1481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z23kHHC6nVhJipP0YqWszmbFUwxeAq1x1ggr510kuJqd4FY2I3w+CFkovFPnr/rtthOAS1Ll1dwC2FEwABPRmeEfszPwN3sI+N8W19Tw4a4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7668
X-OriginatorOrg: intel.com

There are a few instances of the warning:

"meson.build: WARNING: Project does not target a minimum version but
uses feature deprecated since '0.56.0': dependency.get_pkgconfig_variable.
use dependency.get_variable(pkgconfig : ...) instead"

Move to the new style and mark the project as needing at least that minimum
version.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 contrib/meson.build | 2 +-
 meson.build         | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/contrib/meson.build b/contrib/meson.build
index 48aa7c071f92..33a409a2d7d0 100644
--- a/contrib/meson.build
+++ b/contrib/meson.build
@@ -2,7 +2,7 @@ bashcompletiondir = get_option('bashcompletiondir')
 if bashcompletiondir == ''
   bash_completion = dependency('bash-completion', required : false)
   if bash_completion.found()
-      bashcompletiondir = bash_completion.get_pkgconfig_variable('completionsdir')
+      bashcompletiondir = bash_completion.get_variable(pkgconfig : 'completionsdir')
   else
     bashcompletiondir = datadir / 'bash-completion/completions'
   endif
diff --git a/meson.build b/meson.build
index 19808bb21db8..300eddb99235 100644
--- a/meson.build
+++ b/meson.build
@@ -1,5 +1,6 @@
 project('ndctl', 'c',
   version : '82',
+  meson_version: '>= 0.56.0',
   license : [
     'GPL-2.0',
     'LGPL-2.1',
@@ -159,9 +160,9 @@ endif
 
 if get_option('systemd').enabled()
   systemd = dependency('systemd', required : true)
-  systemdunitdir = systemd.get_pkgconfig_variable('systemdsystemunitdir')
+  systemdunitdir = systemd.get_variable(pkgconfig : 'systemdsystemunitdir')
   udev = dependency('udev', required : true)
-  udevdir = udev.get_pkgconfig_variable('udevdir')
+  udevdir = udev.get_variable(pkgconfig : 'udevdir')
   udevrulesdir = udevdir / 'rules.d'
 endif
 
-- 
2.49.0

