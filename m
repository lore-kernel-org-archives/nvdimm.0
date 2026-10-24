Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792808999;
	b=z0vM7qc0Rj6VhjYJbCFGSFQwWI5QvWCkzltxI5YZ77fes47XIhPk++93R5UyE0vMUYEh
	 JhwMemVupeJvzuV+MLu9RECO5fpGadkar8VNqi9xKJ5WjCBhpevg0XaRxVHvLWalEtw++
	 exFIFMMgTjJhhEI9GpP8WN+NWvdUlZEb16dNu64T5xRWy873esdG3vHMm28MP/UnGdOJo
	 bPIeo42eioF5QnyQTugJWensxqNDE5Q6r68R2NsrKuKVxZklyAujJoHmzW+NmKf+ZFYkX
	 AwKp6juQOV5+5Pzkk2vU3Wjbih6AShIN10jUDx+sAerXwuz7fzcBSH9TzTmH44ns8xA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792808999;
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
	bh=49q+hDoosD8QMnEvFS+6QQ1hXy9z2HsY5gcxjD2di5E=;
	b=b0gBwsfH5YSJihJ3IFO8MCSBicLMjc15aA8RE01yaZPLbmrL6Y9BYhGcUZc4koa4kapi
	 kwsl9ojXCbK77YTc2taxBbw0xzOrKgcEFyRiL8ThDbD5dhdsFdgl6jE9owfV8Dxd5Te5T
	 by44hTp+gKqR6TzYl0JU22JKzGScM5FkQJJJOZnYt9+hpVNFkI5gN60tWDzXueKASIjZ4
	 nzymNx40XffMuGXa3N23oAQ87U3LqP6f6k8zv7EdkoAL+4+xR8KpY3TbmXly6sB8nDUrm
	 MS8OiMubSwPnafOpMdnfkXBCW391wVnodIyCgsi6u9ZK9UcFZ7j12afPpJxkwLh/w9A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=i3ePBFQf;
	arc=fail smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D98E606A331
	for <nvdimm@lists.linux.dev>; Sat, 24 Oct 2026 02:29:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D98E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=i3ePBFQf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792808997; x=1824344997;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wyocE/YYJ16HtfIztC8Ul4gJJoZgey92jOCfKyypozY=;
  b=i3ePBFQfJe/J/OF8bNHuMjRBW1RgHJcTRYtYS5eYx7nwbSSlfKepj4p4
   CLnQDr8liGUxtiD89DJrpQrtsHHDd6+umbYFkNOF4diOixwCC9XfNpAaM
   I7OyQ+SIBR5noDEMkBxi4QKAZ6Tu7FXWUe2fHnlNaFrSf2u7wpJLTSLTU
   Zc8DC+ERgzSXvmPrsBXcESsuIb0ppQ779XDq4jNiIC3p/mCYTxLTACFgt
   2WJ+dqqVYTjMAnUV/P04j1mjIdjclpHn0c9qkoLoU/I2tRDDn/7SAON6e
   AvV4kNzuO3nB2rZ4kJ8mj9xemorG9ZKs6RTYyFRXOcsU45sVkOT+v5nac
   A==;
X-CSE-ConnectionGUID: r0OjpQYLQzau6TmE4kt8eQ==
X-CSE-MsgGUID: 2hBqF6wMRRWBhVTMDPNg0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1454078"
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="1454078"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 19:29:57 -0700
X-CSE-ConnectionGUID: wdCpWkxlT7uLjBm/H8+zLg==
X-CSE-MsgGUID: goCGvgoaSp+8i1d2ffLrYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="3803716"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 19:29:56 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 19:29:55 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 19:29:55 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.64) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 19:29:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=amK/rqzY2QFwtGgCvaQBo69QyarVVUMXhE5EV1XWuGEkrkgFmhObRydQ6zGmk5kqYW84YLK+FUnKwduIJjPggUVDwMVMldnO/XoqMe1d4GI2oOysOM7geJNoSrH1/S0wIijFcAFcMehISBtXw77JQZimtCKsr+ifjeHVCYrFarGleTK+1uCt5AF3U3K7f+YIkqQ84Q0Hy7B51NB+mDHGAovn8765/MHPiI8AWoHxI4wuTK8hSusEY/a1FEug62kLG4Nv6cLVh11r154FLgMyDPW5/mBgHHJ/Za+3XwGEnPENtCkW9UzsH6d/iOH9SMIdOF86Hz68gGaQygC4O9/RYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49q+hDoosD8QMnEvFS+6QQ1hXy9z2HsY5gcxjD2di5E=;
 b=UI8aENAf8rfkwQSotgPR4CMP+n5EPHDUEfpUhetW5NSc+6xBuEDMH2HLLqtCpo02hf3QLrk68erjSKpuzHSadt1FLP1EOU/iqzFAfvJ6TTPCmmuFb8WKTvNlBavMKgNaAI9r8W4AAbu7GBJCxUogiS+uNan4IORqZVLuMykC6AVnkdZNycuJ3Kna0g+G4ub+3OBWzRTs4cs6VV2bwVEYDE5ZAz6BpNmUuas/kyBnROilyBnuYfk/WlFnarGb9tePDEBrnvzlSn+SeDqzHgCSUdzXH+cUbQFzoZ20yrlRTqTCRUK12IfypKif2fk4u6iDApmTKfBxg8d/tFpXDnq9JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM4PR11MB8159.namprd11.prod.outlook.com (2603:10b6:8:17d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Sat, 24 Oct
 2026 02:29:50 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 02:29:50 +0000
Date: Fri, 23 Oct 2026 19:29:40 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Richard Cheng <icheng@nvidia.com>
CC: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 2/2] cxl/list: list locked zero-sized decoders
Message-ID: <atwYFBwFq5aiG20V@aschofie-mobl2.lan>
References: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
 <018112d2f7890f3a3f38cc96aee5cf98cf5f3a9d.1785462417.git.alison.schofield@intel.com>
 <af3d9c4b-749a-4146-be80-210e6a1c0643@intel.com>
 <anVoHcsukSEELpCi@MWDK4CY14F>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <anVoHcsukSEELpCi@MWDK4CY14F>
X-ClientProxiedBy: MW4PR03CA0254.namprd03.prod.outlook.com
 (2603:10b6:303:b4::19) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM4PR11MB8159:EE_
X-MS-Office365-Filtering-Correlation-Id: 65711bdc-bda1-4535-829a-08df3176adb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|261009223027099003|4143699003|56012099006|11063799006|5023799004|261021123027099003|261022105027099003|261021121427099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 4yu+Yikbfs0btr0gTm53YKcL/tNPzR72UHFvgOh1DVFx/jhEDORdSiNb93n81eODBurhgCP/8NJ12Yvbvy6uNTrv60gKklnSFx/b+WYUidBFGtTaOCWA1Ul0dt+jo5ImadKo6SIM35yPiP+vLXBSLJfRt93+eOx7/wtHee14qpuJ57AU1eZa3zCyff18/CqQEOzDpYsdyU6Rp8exHEn4KSVw/SFBjwlo+ZweyBTxamjxMjblCy5Fv1bqZgqWjsXXRpxpPR1CLqnv5lVKEkwgGk2douF3smWFp6na/JiyubYQ303ADQVVrLrHWzSk6Qo3vh/Pw4gESrk075pX9WTp1NLaBS0VM4Bsupg/XvHqslnwfiX2w+L9z/y10cyBTqq0vawf/lY8GH9tUpiA+vPTosgnDsorH7lY4pOzCXOvx67IZKzlmkV4g7dTiOczzzEFwU2xkHiYJpBgEChqeto3ufxNjUXE65StbOcXsdMZsFSBV9v/F5+cX/GdbWGgZtj2HH2ctxZjWDLbvS2p230B9CVxy2wK6yag4aBwqg+D6Q8jlkn+KgS/ZnkLnggvSYe+b3U1pb2sUdzNDcOzpUdCHVK/Wvv4X9UskANvXbAMcJ+i+czC4FEN0CyvCiZua0iovYiVtXfWH7+QvaozW9P9IEaLtOST8I5hM3nur77amwA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(261009223027099003)(4143699003)(56012099006)(11063799006)(5023799004)(261021123027099003)(261022105027099003)(261021121427099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HPYq2UAAktWfSg6z7KPKdHoU5WXPD+j+130XkVYhd69wpzCKJ66eiFAfzv/B?=
 =?us-ascii?Q?ngvvpKQ93tZ81zzTsmvl5tYRS3QQ2kCYqG8Xk9dY6wV1NAl+mJacERCKW2wC?=
 =?us-ascii?Q?hd4PX9cGCCVx269pAp/rM/swN1RaJIMOhaxS/EkYAvUKcDnJxQEkI/eOJPS8?=
 =?us-ascii?Q?2aiFskaOyv5SfJO/3uNlRYLzvXGyD5HMGFzQWMwxZEcewgKo+DoGomr/MXLa?=
 =?us-ascii?Q?MMHLLLt8Fv7E8ZoTiDlpMrPj9aYwTSg3r0X7rkjysMV1Q1Iyb2q0aGiSIz8T?=
 =?us-ascii?Q?bfu/QM7uvjJc3Nh4CWSCzftx5fkhSPZtGfz9vrq514/CY8Sl6EKfHeJg/MO6?=
 =?us-ascii?Q?QHJguG4jXLdOxmtQoV0tJ3ri9xOzTsiWoUGBwNnVieQ3KPZyJf8tZihzx2vi?=
 =?us-ascii?Q?Ck0h/2rBqFVZfx9N8Yo5WwCrXgoVWDXjEWtRvYG6cv9fDS3gq5KhuE8gDdzY?=
 =?us-ascii?Q?cqTY+JvmLtIN8rFaV7pajeowPi7juAS2plP6xa9ur2Ms4kUvR4vG9BQr29fe?=
 =?us-ascii?Q?GBC2ZS1NazFLh+tUeaNxeuFPmjMpbZ/kvu2CFJThJCJpIDCOQ5TaEyUryufm?=
 =?us-ascii?Q?jXVlTzLAmZ/WNVNJhbONF89mRgZabX5CWIfHeJ0JkheHueAZynX7lh0l1fjK?=
 =?us-ascii?Q?iWzNToD3viltLjjUdNP891QXAApqtif4N1AM56m0Jh6D0/l2hNIAUmx9DKSl?=
 =?us-ascii?Q?MzI3UJBFLDmer1mwOxnrbcO/OWBeSPcbz5IVdXWae0J2qIHXpDUU0gVkWQkv?=
 =?us-ascii?Q?j4MVfeMlCIUmE7ury3p49i6Q2R4sXNDj8/TyuEBqruErZmh14Edz6jYO+7cz?=
 =?us-ascii?Q?TPy8OwKJTULzAul0Bp2uB1WUkPisIeqIBGL0EhWvjNp95ryBb22oi6GsPSHV?=
 =?us-ascii?Q?PK5Mt0FRwc/lyv9rcSY4f/RXl/I9SNIJDUf38sSCgK7OF/QRPrM35KZ9TiWc?=
 =?us-ascii?Q?BZCnN1ttlK589vc5YfTIi8tm747d1TlVTRRkpnOM5anZaavBFxhgA2mR98FM?=
 =?us-ascii?Q?4ay2wwYGqA8JRVBKKohRRgbPU62sGdEwazLsSHJPvCkMNmb7TEZ5rtpzk64B?=
 =?us-ascii?Q?p8ULXDkNELDxHDKwU7bE9DAEXKd9tbT5ufYqSNJffiFJfROcExQBafWMNQiT?=
 =?us-ascii?Q?ffHKGHKhZ7Bjx0NnPpqva1AViajsg0F23I3YXPHgPhCyBdRfh2iduRFxJ7e2?=
 =?us-ascii?Q?H1Uw702XcttmkfT5Rsk8LWr68YlKli2HDDSqulDbqLRr6wJmq60e1Y96oGMA?=
 =?us-ascii?Q?BM5KuZpxCGMDSVuwEbuyk+iNLA6TD0bpZVWQF666rEmwcHLtuX21VXoxQw2Q?=
 =?us-ascii?Q?EBnUMvc+M3qonOU7dNUno+56Q1ZHz6U3iW0dIMRUJAibikmOwZb2DvLNqUom?=
 =?us-ascii?Q?IKpsiKingbFAlXY/0k8ia0ZcOUlEDgHnbTHvUuWyUpqTuEUj43XSv1o3aV8Q?=
 =?us-ascii?Q?R5uBkJtG0uAZFAU3L+ozrk0ERmPKn1q4BeFIxOhrX18LwkrWqGSzRFRAawRk?=
 =?us-ascii?Q?fi+dclFZUgHNlWjWAoJFqhlo6T6oIzPtoX85weSIvR7y9feGX1vMx7pRXihM?=
 =?us-ascii?Q?bO2jngOmhhxJf4WgiKYpBGZaR6f8VaRh0GD7u5eERgrQsWHhWONkvKIziCjp?=
 =?us-ascii?Q?SimNIx3M63T88WvsRTl0oLbSy+9vNd5zoFP/uTPGA3ZwnxONWnzo1Ypow1Lw?=
 =?us-ascii?Q?WF9p9OpjBaUWdF77JYsti31iGZighJrjAneAjdkFzBVYJMWmSzWR+4TeH9XL?=
 =?us-ascii?Q?CTFZwZzDHPjg14r3L+XWqkg1w4TvXgA=3D?=
X-Exchange-RoutingPolicyChecked: vaFB0iveaeXsQFExPmCAo/DqC6DfwnRLht4ATY6vpRO8UFumP0KM6jvMfU0OAxMyYKJNSk1L5VeyqqTTQb0/qV/yAgqIeLQNpsSThe8QYyHtz1SV5Cg+BPPxSDTTGkx/WnhXsedJnH6AE1pmFvyMMbdLLAQIfEovO64ChTYLu3Jm0+WcMB/kyyxo6aNB5ggSPGh3dDIW1azb1XtSKcgpT/IcJE7Wyqbw2PwZctC0VPu11KuR7p8oNUKezvxQ7zc/S010sUOq5zWr5RSo72u2P3Ai2KqvepvCiwUPVhQuZ2nnAw4Y0igpIevpIHe567GTGISPgF9FxZRNAHtVprSDcg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 65711bdc-bda1-4535-829a-08df3176adb5
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 02:29:50.3431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPH/j/z2rc9EtM8BmWu2lC1uYuZyW2+Ao6EMIjoomW99Nh3FbS03TnBXCud5QXbIKTHeu4HyYt2Lin69XRHg+916Hb4vHxXt3JuFngPBrJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8159
X-OriginatorOrg: intel.com

On Fri, Aug 07, 2026 at 01:10:47PM +0800, Richard Cheng wrote:
> On Fri, Jul 31, 2026 at 08:40:24AM +0800, Dave Jiang wrote:
> > 
> > 
> > On 7/30/26 6:55 PM, Alison Schofield wrote:
> > > 'cxl list' hides zero-sized decoders unless --idle is given, assuming
> > > they are unconfigured idle slots. That assumption does not hold for
> > > locked HDM decoders, which may legitimately report size 0 while being
> > > committed by firmware.
> > > 
> > > Do not suppress locked zero-sized decoders from the default listing.
> > > Combined with the "locked" field in the decoder JSON, they are visible
> > > and distinguishable from idle, unlocked slots that remain hidden
> > > without --idle.
> > >
> 
> Hi Alison,
> 
> patch looks good to me, just one small question,
> what if the zero size decoder is programmed by userspace, not from FW.

I don't see a path to that happening. Userspace can't commit a zero-size decoder.
Writing 0 to dpa_size just frees the allocation, and region attach rejects empty
decoders, so a committed zero-size decoder can only come from firmware.

> 
> in which case cxl_decoder_is_locked() won't return true, can we handle that situation ?
> 

More generally, an unlocked committed zero-size decoder looks identical to an idle slot
in sysfs, so telling them apart would need a new kernel attribute.

I'm going to merge these patches as is, and as we discover new flavors and ways to list
them we can add on.

Thanks for the reviews!

-- Alison


> Reviewed-by: Richard Cheng <icheng@nvidia.com>
>  
> Best regards,
> Richard Cheng.
> 
> > > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > 
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > 
> > > ---
> > >  cxl/filter.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/cxl/filter.c b/cxl/filter.c
> > > index 5d634d3b2512..e6d45ac7b9e6 100644
> > > --- a/cxl/filter.c
> > > +++ b/cxl/filter.c
> > > @@ -847,7 +847,8 @@ static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
> > >  		if (!util_cxl_decoder_filter_by_region(decoder,
> > >  						       p->region_filter))
> > >  			goto walk_children;
> > > -		if (!p->idle && cxl_decoder_get_size(decoder) == 0)
> > > +		if (!p->idle && cxl_decoder_get_size(decoder) == 0 &&
> > > +		    !cxl_decoder_is_locked(decoder))
> > >  			continue;
> > >  		jdecoder = util_cxl_decoder_to_json(decoder, flags);
> > >  		if (!decoder) {
> > 
