Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17443783C3;
	Thu,  6 Aug 2026 00:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785977015; cv=fail; b=E7V0Ly3uEVxjBcWW0FWWP6rPw1N25dzzYlMkgouexEag2DBMHoyi5Mj/3EVaNQ8sRzMnaT+vsuUTEzdlRp3Q098J/Cu+SrejxKTeY7GHpE/IvypCeDC082cAjpoU8uyHVVcWyalfVt3XlsrArLABnZgTT5ue/fSOl/EYFyNJ99c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785977015; c=relaxed/simple;
	bh=PerQn3XyPDBdqita2t7H+z8cFE4yrk/Nk4WD8nMN9lw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qAWNpF3TWbjtSvQDnpw7O5EZg9smiBe4h74RoZhSVJni0hSec8K8ecKKoAqDKUfpzp5TtYjuil0fIcEdjzNEJYOFi0LM/XybjZ98cKtvNbT8BiX/R0oge3YvYO2ZfGf/0q18FBQ6sCUVMQfVrMlafuIcTVliwo4/Mt0/FDQpemc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hK1aUOkG; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hK1aUOkG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785977014; x=1817513014;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=PerQn3XyPDBdqita2t7H+z8cFE4yrk/Nk4WD8nMN9lw=;
  b=hK1aUOkG1Niy5U6pp7GBFqvtW9FAqXNijp2dHq5MNbz2QvKrUf1rtl6t
   lffpNMT7YygUiir0Bp1OGuPY1XNFt/7oIRekWQ51wEqiTb/U/g6mLq1qn
   eLaHNYMez9KJNSwrQDuN5nNmeZj1SMKcLahXZYhiJjPmGUNdIRXtzvd0s
   wTOd6uoP2eyay2ptm/ZEEJk/Bs1Hc7a0HgJac17/MJu3fpm68jNuhjJR/
   nEsQuwQjEhwsKWYVHMmLHA7NYRh0SDS9SJjNFnpF4bshfUladtaPIvFuE
   qam8hJIsiN5VgrfJ8waFpDLEgabX9yTzFY548zZC+X6fmoi1LrYkp2wKT
   g==;
X-CSE-ConnectionGUID: JCd2J2v0SWKFZVrZvQ3Qqw==
X-CSE-MsgGUID: c8v2Q+fKSjSTJ7kND63CSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="96914051"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="96914051"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 17:43:32 -0700
X-CSE-ConnectionGUID: zI7IRYkyS/G+KJj7jxrvxQ==
X-CSE-MsgGUID: a7Yn65rxTqe7EGXzQb0Bbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="291875171"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 17:43:29 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 17:43:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 5 Aug 2026 17:43:29 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.13) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 17:43:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MakQuZIu07npwNFLJ9PaAioy5sbIWXLxeoLh8tVoVlUmwF/lV6hfCX3XZg1SjpCwvol2KqwjUu1ijNq7dN1XdywO7eqKELpAYJZtKQnN9vSLQcB84fdQdVg/K+iJ+rMraX5oaA3VOWrMXsJhDZnvxAyyhd8vkqFSqH+u3CXSkVp5SclZL2uZ9KE5OWfd1jPC73rRPKxuBn9XWeNykfqYmH8k55D9Jm8wd4mhNSG9lgwZVM06+VIDqYbkP/pSXhrJpci+qZG5o8pvUtpC8qVHvIT3lGW0n1JGZk94OZ7P8zhNRALGl8SqA72fr+wpDg3U6v8Umb9Xfy628kx7VTxKtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9nWImMj1dZvlJhZ7lR0dhgkjZ0gRBsRAkUwC7IGaNzg=;
 b=FPXVyaxiSztT8EPmeb0wnjkLKZiDLM3rRiGSlo0LgqRu4Uq9s9W8EcXtczcDqH6822nhXGbLO8MYwtUlWGiYzni4Gs1ofojJhj5NnKT7F4DcSLA75gCUCVRPyIueYxAr8ww07BmC9IWUU1Gk+oBDS0stR3VitlvvNcYB7qqQGyxB2ffckt4FqM5LMnsBhURL9q2mLboqytHCBCQ7Mf136xR8UvZlC2nqvbn/5Z4dJ8hiXvWw8sK0n6ob/GHatbMSiWFEO+/QlLNcIZdcHmMEFUvOyIdpGwkKhHv72Ia+sFSKXnI892dmDmqx/8DdpgWG3mj9rpQS2UEPqO+w7QkWzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ5PPFBBB839A03.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::84d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Thu, 6 Aug
 2026 00:43:25 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0292.013; Thu, 6 Aug 2026
 00:43:25 +0000
Date: Wed, 5 Aug 2026 17:43:17 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <sashiko-reviews@lists.linux.dev>, Pengpeng Hou <pengpeng@iscas.ac.cn>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] ACPI: NFIT: validate subtable extents before parsing
Message-ID: <anPYpcB4yFqF7ox2@aschofie-mobl2.lan>
References: <20260722041701.21078-1-pengpeng@iscas.ac.cn>
 <20260722043102.AB53B1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260722043102.AB53B1F000E9@smtp.kernel.org>
X-ClientProxiedBy: BY5PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::11) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ5PPFBBB839A03:EE_
X-MS-Office365-Filtering-Correlation-Id: b77624a0-821d-43ec-48be-08def353b958
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|6133799003|56012099006|11063799006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: uZhphSeBb2KVuZ91MHNZjbmZPbSqfJixX/V+7cHknYH/o0VohXc7o5MtARI2cY4n7cZgPKOSujJaTTzahEUCV2ws8sQFM5ubnK6/NolfqAJ6wAkiuWfiGKr2fwheOzIDONQNMwM1L6AhkJwFUGRGwXDnd5Ec/rvqtXAjK9JBjtUqyCrAfJ84kaC587W511LmkhNCHjxbToPHOHzDeL7MrvKFZQpiaNLR0CmdxNZVU1xNdXxChSMtg4HD3kz2n1S6FF96hrcDKcjHtp+cw5bQE+wzgzSxdmAbdGTH5+Ha6SNN8eLIuOrXCZQhnmdDHVMaMjKnNqW6OnOCTWk/IhiC0Vsv26O7catEK7hlouZUEycYJu3EEc6ng5J6NAjh5SlJ8GAT4/gmT0GZAc37A8FTTkH0GJZXLXxZPF/G1jAXfIcjSEautm5x43PDQdtWATYqLTSBcg9cRaS7ZMZqObVQnB5NfdamUix2vpJxh0nWA521l0Xuc+Hi8osKVC5aiNPI1FyEEvqfXJnkNIz4bS3AY3+yb4evO7ccpmW8JP/wh70I0QSrIZjFkx35QlYiGNLb6vfJ1ZtaWtZ8Fq+H06jh+AFwu6HnLxai3acyzRphUe8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+cuAxgcsnxc/UWOKHlL5JJLea6NOipHCtT9ag4CaNDhl86c4k3viVnTfdL?=
 =?iso-8859-1?Q?X/JiZPETB6r1WzpuwRG2hfwaN3S0A2xuF93mlYwn9UJxuc0B3/1gs4lyFR?=
 =?iso-8859-1?Q?OD3uJ9DjvZVrLWCiZ67WkT42JsF49TA7EmH9ucTrnLL7q5lxvxHT6TIdQv?=
 =?iso-8859-1?Q?qL43wnFqyl3/qATCOiThcvTYBDCHRqPkw9vipnvA/Lg2TnGSrx/E+6okAe?=
 =?iso-8859-1?Q?nwTqixenAYDxBeaWBh+NIxdYW9LIqNSQY3bUi1ui0adHHSxjdIQYg0MBQe?=
 =?iso-8859-1?Q?duZA/xMFkzq/hVALZijbM6Jw69IDa7/0XQHlNCx54dlab7F/DyADmCq7Ug?=
 =?iso-8859-1?Q?roH3/PwTUbQgBMbaunsMwypcmcxUuFv5iJBYfSZS5Gynmm+OQlXq6Z9qFM?=
 =?iso-8859-1?Q?VWpup+1gxVUBzrIvWoB2LA6eWyxCoYRQsO7+Y6ZrEF2YgZ4aHQlxW8UfNb?=
 =?iso-8859-1?Q?+hpJPbHKukLvkmj2HMPGApn2lheVU5bCH1h/ZzBadbx+9gYTJfQwnshqRw?=
 =?iso-8859-1?Q?xLjo7YWia6a3288Wgw3sPeugOVxscmzw2tC32mgoDKSSHeIiKKxW+zhZnT?=
 =?iso-8859-1?Q?QUUReB2g/27M4UYgQjURCMvbUUQD1zTHVj9WyKh3IX0PDkfBttmanG4+SV?=
 =?iso-8859-1?Q?HXJwWAOpMfFoBvkwncrAP+ItXkbzZifJ/VRsd3qHe2Tghmon0BUWKuKCvy?=
 =?iso-8859-1?Q?DaK3J53niTGQMASaIRDuGjDjAOG5fMkgbPxVHiBln80HaEX460mt3J90Ev?=
 =?iso-8859-1?Q?ebGEqizm/hhFlJ1MSLPwMGGpsRO5uFl31J1Z501kKfc20KpR5MNjNW6Zpy?=
 =?iso-8859-1?Q?h1+jAsKbLJhlgBsVZKRN1GpVN6dRRQybMu1VmGq9gLwyzWP/5W8SbFvrTm?=
 =?iso-8859-1?Q?HPFmr0VjvIf1alpL4C/4rkU6gc31RZBDleadc7GBfzv7upamMV0AIvDfbv?=
 =?iso-8859-1?Q?RRqzKLfBAbRBKEgW7nMVXAubUa50aXxbQHGYgYTqkl3Oy3EmRGH7ClZRnY?=
 =?iso-8859-1?Q?Q2U8r0JvOUgHfjZSG9ohAJq1OQsGVwGseZbf+giTyp/ME9kxOvdr7MTN5Q?=
 =?iso-8859-1?Q?FF4K9EGmiURvOG9CV1iJSLp1OQX6/yGvoyl8DLgogiFNvLccauK2tVsl29?=
 =?iso-8859-1?Q?NdfMq51lSE/FmvJEuf9w2K3SPeV+kFYUKEr2xP22kJDFzHT7nLRQpgbiUc?=
 =?iso-8859-1?Q?4azdm63MyP5Cen6Ma0NFAgssRqIACcs+Rd81Nmk46eN7/JwJQCrffsPBp4?=
 =?iso-8859-1?Q?B/tu3VdcMzEkjb7niBP395rFg7kWoKPb9cWw8zXJiwk0wSZqz1H7KlMzZ0?=
 =?iso-8859-1?Q?PR61LE1rBYaJW7YpeLKXE8mFrKn26tlT5C+wfyZrg3cJEEbqXWiw/Nfa5A?=
 =?iso-8859-1?Q?kzHamEbkDN5Teew1vs7m+e1tY66UXtnb0smbBEudyBMPwwcUeUGkCm49re?=
 =?iso-8859-1?Q?otEjfsAWsyx4F4cxQrjgYbzDVwWKX0lckaYO9KxEC6WwQEisLbibOMxw+b?=
 =?iso-8859-1?Q?4m1wokZrLrOPxU2wZdzOH4B1rRrmW0UaInsthZPbVpw0pyioclQx9UUTcW?=
 =?iso-8859-1?Q?l56PGFdBfYID2sABStp88JLBhw0/ndeuUqRlekJrEjHitPnUDK7aYlVENg?=
 =?iso-8859-1?Q?utPoP75e1PG9x0HYJCzILkg/dU/VxtMf4xKFbD+L80zZlkm7KYNx65thLa?=
 =?iso-8859-1?Q?CSofX8Ay9+lX/YeUhVQI/tRkPJXRHWlFuu8oiED6Csl2MZUujqLIpponlg?=
 =?iso-8859-1?Q?ir9LMveetalVUFNHM0JnnnoFQ88zCxaHUGkaSbeh/qmvUP/KWTtXfZl78q?=
 =?iso-8859-1?Q?KrhdGmsP3rtF/rzjFtck4vP612lsTvM=3D?=
X-Exchange-RoutingPolicyChecked: khfdMWkkfBYMmCLTd+oFSe8TEKIVP8gpVsl+xHP+4Cyyk4LndOW/CI12sXiYV7jbCjb5wr76D1DMhTCWQ6l1T2ovj1G3SOnUZ4ST8xd9bwsQOi6TlYHqKg03OJUkWc5TkBQVUSWmPz20oVIJqDw3Es9rvYgMinY3rx+JSQ3eKBmvd2DNRuVqme02o/MMQjYGCnE0AMpgdVP4+i25BLYXzbSIiaOVp/J3JaO/by5M6qpyjiqWQcnkAPRBWd56e21iYbVMguXcmAYFsxI7A457FC81fqn/qZ8tkAWXQPsEf9+1RTNM8F6TFPgbjQjdTQRYNUIr7ASUhH2U7evBTtIktA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b77624a0-821d-43ec-48be-08def353b958
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 00:43:25.2619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8zyi9UNibMc7MxRTWZRd3mvLkV3Qr8KB+2CeFU7QK0mGn2g82TzrcfRuveyJM2qbaBEk93dgoIn7JwGM9f8NG+8L6OKC0qltK0sr3Rsq+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFBBB839A03
X-OriginatorOrg: intel.com

On Wed, Jul 22, 2026 at 04:31:02AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> 
> New issues:
> - [High] Rejecting the capability table if `highest_capability > 31` fails the entire NFIT driver probe, breaking forward compatibility.

Agreed w this one. See my direct response.

> 
> Pre-existing issues:
> - [High] Missing bounds check in `sizeof_dcr` leads to potential out-of-bounds read when parsing the Control Region subtable.

I think this is true but not something that belongs in this patch.


> - [High] `sizeof_spa` incorrectly assumes that the SPA length is determined by the `LOCATION_COOKIE_VALID` flag, rejecting valid ACPI 6.4+ System Physical Address tables.

This one is not obviously true. I think the question is should sizeof_spa()
take structure size from header.length rather than LOCATION_COOKIE_VALID?
I wonder if ACPI 6.4 permits a 64-byte SPA with LOCATION_COOKIE_VALID clear,
in which case the current logic would reject an otherwise valid table.
I didn't look into this, but I think you need to figure that out in
case this patch needs to change.

-- Alison


> --
> 
> --- Patch [1]: [PATCH] ACPI: NFIT: validate subtable extents before parsing ---
> commit d7436f5d72f81006ac23c35fc1e7248c7a9fe254
> Author: Pengpeng Hou <pengpeng@iscas.ac.cn>
> 
> ACPI: NFIT: validate subtable extents before parsing
> 
> add_table() reads an NFIT subtable header after checking only that the
> cursor is before the end of the table. It then advances by the advertised
> subtable length without proving that either the header or the full
> subtable is present. This patch validates the fixed header and advertised
> length before dispatch, and ensures variable arrays fit their subtables.
> 
> > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > index cb771d9cadb2a..711ab639cb147 100644
> > --- a/drivers/acpi/nfit/core.c
> > +++ b/drivers/acpi/nfit/core.c
> > @@ -705,6 +705,10 @@ int nfit_spa_type(struct acpi_nfit_system_address *spa)
> >  
> >  static size_t sizeof_spa(struct acpi_nfit_system_address *spa)
> >  {
> > +	if (spa->header.length <
> > +	    offsetof(struct acpi_nfit_system_address, reserved))
> > +		return 0;
> > +
> >  	if (spa->flags & ACPI_NFIT_LOCATION_COOKIE_VALID)
> >  		return sizeof(*spa);
> >  	return sizeof(*spa) - 8;
> >  }
> 
> [Severity: High]
> This is a pre-existing issue, but does this logic risk rejecting valid
> ACPI 6.4+ System Physical Address tables?
> 
> If a compliant ACPI 6.4 firmware presents a 64-byte SPA table with the
> LOCATION_COOKIE_VALID flag unset, sizeof_spa() will assume the length
> should be 56.
> 
> In add_spa() in drivers/acpi/nfit/core.c, the exact length equality check
> will then fail:
> 
> add_spa() {
>     ...
>     if (spa->header.length != sizeof_spa(spa))
>         return false;
>     ...
> }
> 
> Will this bubble up as ERR_PTR(-ENOMEM) and abort the entire driver probe
> on compliant platforms?
> 
> [Severity: High]
> This is also a pre-existing issue, but while we're adding bounds checks,
> does sizeof_dcr() in drivers/acpi/nfit/core.c have a similar missing check
> that could lead to an out-of-bounds read?
> 
> When an ACPI table provides a DCR subtable with header.length exactly enough
> to include the windows field (e.g., 32) and windows > 0, sizeof_dcr() calculates
> the required size as 80 bytes:
> 
> sizeof_dcr() {
>     ...
>     if (dcr->windows)
>         return sizeof(*dcr);
>     ...
> }
> 
> add_table() only verifies that 32 bytes remain in the mapped ACPI table. The
> memcpy() in add_dcr() then reads 80 bytes:
> 
> add_dcr() {
>     ...
>     memcpy(nfit_dcr->dcr, dcr, sizeof_dcr(dcr));
>     ...
> }
> 
> Could this extend 48 bytes past the end of the subtable, potentially reading
> unmapped memory and causing a kernel panic?
> 
> [ ... ]
> 
> > @@ -951,7 +969,16 @@ static bool add_platform_cap(struct acpi_nfit_desc *acpi_desc,
> >  	struct device *dev = acpi_desc->dev;
> >  	u32 mask;
> >  
> > -	mask = (1 << (pcap->highest_capability + 1)) - 1;
> > +	if (pcap->header.length < sizeof(*pcap))
> > +		return false;
> > +	if (pcap->highest_capability > 31)
> > +		return false;
> 
> [Severity: High]
> Does returning false here break forward compatibility with future ACPI
> firmware?
> 
> If a future firmware revision sets highest_capability > 31 to indicate support
> for new features, this check will return false.
> 
> Since add_table() handles this by returning ERR_PTR(-ENOMEM):
> 
> add_table() {
>     ...
>     case ACPI_NFIT_TYPE_CAPABILITIES:
>         if (!add_platform_cap(acpi_desc, table))
>             return err;
>     ...
> }
> 
> Would this cause the entire NFIT driver probe to fail, rather than just
> gracefully capping or ignoring the unknown capability bits?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260722041701.21078-1-pengpeng@iscas.ac.cn?part=1
> 
