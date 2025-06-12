Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F381A0BC5
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 04:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749703232; cv=fail; b=Z/EjHXloo/IwXviTCHaRCCTz4iF55Zn/ECd4Y9VwiR7nYJA4mVpR75np7JAjMlADRpqY75/yMILdkDIJMQll6btyMD+OQaqWTI04KHkOT/bPobVDmOXjn4nUwQA8jlCqP7he0gokB3DLk2o9/LE6QHbcAHbxl1wAE4rdsNwQNTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749703232; c=relaxed/simple;
	bh=Z1SrkUzsMRJETIeekxQDQ1mrTj2TLEA6fkqpbZSu0iw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tzGLRBO27S+VeCGnf2djCFSYmUZjKAMzWNJYKSMo1O5yknN7LGQ3DB0b6PGCBzLN71pvbSR9x6EUGePALdcHi53DyohyMDnzpPZSfhuJT9Hnb3bJVYeFDxoniDo2ZE0XFV0ly98VwIs1E7jv1jQ5gwAMPOHFPWyLIcfWx5zTcag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K6aeefg8; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K6aeefg8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749703231; x=1781239231;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Z1SrkUzsMRJETIeekxQDQ1mrTj2TLEA6fkqpbZSu0iw=;
  b=K6aeefg84MgT+ue5NK8MwUipHtZtvO7b/7bI5+w0/jKmVTStzQsa4zEU
   /0VzMhkmWgCj81Lj8hcqpYJw4IW4TK62nwFCtNyPu9y7ptmocnDqWr7Ow
   JCnYUcnON9KZBLcR0hSb1sS2J3VGDQaFripGHTrJHniodbtcYKBTCdJbr
   4kllWlJdtgAeS4essyZe3I0OERMAqX1lkGdEZ0qqR7MB+btxRXTnClnQp
   wWeNKD0l39M5EwEWuS/v9dk3x+eY73KJZZcYfqMHgO2itMh+MkWqa2vzL
   sjEnjsMUz4QW1PwxKOLOlJLiJDYMH3BJByO2SxYvJyiCfJeGWzDMf/yVP
   Q==;
X-CSE-ConnectionGUID: u/sG+y+uR1ilsS+tcFY9kg==
X-CSE-MsgGUID: IwzYuNAxT+Kgco9bfZpt0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="55535408"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="55535408"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 21:40:30 -0700
X-CSE-ConnectionGUID: SK8Q1cglT3KRZtTbQ6J2RA==
X-CSE-MsgGUID: nWNpeGLyS6G5KmeJp3voLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="152682539"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 21:40:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 21:40:30 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 21:40:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.72)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 21:40:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mMSi3EirCWyaSs3kxcFCeRqwLEm9B3euIFtlGQVA/YmudGFn4uXARGhDXso0zerPFr7Xoo10egx33wn8ftDX8laaia4tmTIOSeX0bqoP/Bze4SoGQe1mS+0Cd5SgcLwX/RSp6sBwC4jDlILNWS7AfeqVhIq61RKwlaQAb6YAzxdPYPLgG2FCAV6GFxl5xvo6V9c407UlvYGQSu4tE/48CG4eB0eiJHUznzuBLtv9NzVcXB4BWif8ftxR/oP8y7UFQ9jm9LFZYXpDcp0Ij8tpUb3QAwY3Ir55OLAv/fWXU1caMiXLImxYEc3dOEZRD1d28UNXuyTlB8rKyNdi89W74w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFly3u8PdBtws8pkqduf5yrNd9To6si6LYrmPiMsrnY=;
 b=I3M2/RbVgR410EkzWbe9xGY0U+dg0fK6K6o1JNQQqSmQY590IpD1bogXvrXcC46SlkR14A9UcF+elsa+Qus1pKS7vhjtBAFQcQ/Nbf28mQTUX7eFb52H04qZYkuH/Bk57LGkIzdKL++RVrvpcBPcoLi7OqxqjY/jmUcZr/lL/xaBOYLRgqvYyWCLwxOwEO/77hUsfc+uyPqQI4VOyyJZfM5jZbRNEZ/14U3C1+pKY70dA78sVtIRNc8HjtEFpyZ73g0p8I5LrgP4SfLnXfI3eYktJNoNFa1uvh3B1KBkSjqwCIh+O++71Qt0/JagNmlZQMvCot5+e++jTBHz4YXu9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13)
 by DS7PR11MB7738.namprd11.prod.outlook.com (2603:10b6:8:e0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.30; Thu, 12 Jun 2025 04:40:22 +0000
Received: from SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec]) by SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec%3]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 04:40:22 +0000
Date: Wed, 11 Jun 2025 21:40:19 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: David Hildenbrand <david@redhat.com>, <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, David Hildenbrand <david@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Dan Williams
	<dan.j.williams@intel.com>, Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 3/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pud()
Message-ID: <684a5a32ee1dd_249110080@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-4-david@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-4-david@redhat.com>
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To SA3PR11MB8118.namprd11.prod.outlook.com
 (2603:10b6:806:2f1::13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB8118:EE_|DS7PR11MB7738:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d316b1-fe49-4f41-6f84-08dda96b3ddb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CdEKRiSSmeIYUpRqBdakiCJ68Z6Wj4/n5cT0hjKI1t2xGVAbR4skjfBRVqg1?=
 =?us-ascii?Q?TwaoQhy44Tt7lBQFQTazAN4AyIYaClG3SgvfhyYVuSpyjzKJnd1ogiAINur3?=
 =?us-ascii?Q?XbtHqLjxTR/rgUj2jZMLfrJqUY6FNVDGq0FwC5miYXfwZ0G0BSWF6+qr2MVW?=
 =?us-ascii?Q?4RZIXk3OsFjCEugOqrCWCjfHv6xKYWxIAag/ACTFgqSwM6TknT5IDZLK/Tcp?=
 =?us-ascii?Q?fxJegM7YkISWdiu6A/3vIjgc8pSwAA/YOAzp52mqeWFeJgtQ3mbFkbqX8Iqy?=
 =?us-ascii?Q?mKtJAmtyor9FvHurOUnN+pNVK13iR3HJLZJQJ1Q+EzFrwL/vq3aa+/EdMe9c?=
 =?us-ascii?Q?CC26kYsxC0nGBJAQdPxn/rJW4o6/XB8GnWlQeZ+tpzTWw2SUkjnIVa63wIjX?=
 =?us-ascii?Q?Dn/KpXMz9AgkM4wcuJ41ueoaugUdCuDFF3N7WbuPGEuGbEA+HR3nRNkcK4v1?=
 =?us-ascii?Q?CZS30i0RAvhPL3/3R6ehoLmD3SPsNwxn94E1J03qmr4TxD7UAaq7EvMY7ST2?=
 =?us-ascii?Q?k9c5a7NvpAl1J+63SrQjp7JJ/TKnurokEuUsxobj1tXx3U9WVIGe9EQEPhGS?=
 =?us-ascii?Q?K/9N5GVIJ/AU42CE5os7JmRL/bYZQvE6/HCl9ZGpwlT0LF26k/358PN1rVtq?=
 =?us-ascii?Q?w7A75GJ48B4oMr1et7Kpxsa6pODnHTHXVf1nAdW+At5ru7Uyi5N5ySU0479d?=
 =?us-ascii?Q?RSEC1B6WWMMG/IybXpN3xAoyQWE28sOV5dOoMvAnA9gs5xq3r3/68z1pfWHn?=
 =?us-ascii?Q?XOBWUlfakP1kL3Tw8Ot5RUtf8DzlSFxt6LkOfqXcngUm5JhUEuwJI/gNLazG?=
 =?us-ascii?Q?1UE65ZkIJltmV7tSw7oIc/gtJjIcmyAL0Dt9TePQNoLOsGAGCr41KrL5iUqm?=
 =?us-ascii?Q?iF5X7QeIGRfMKqcXhh/pUrof9g4ksLDrvLex95g6HsE8K8Etlr3DrFzv6NEL?=
 =?us-ascii?Q?RasqMOdi4QEhQVrn4S6UGieHZXrNDwzIleL3djwBjak6iuKPZ2lx7Ezmstkn?=
 =?us-ascii?Q?gq90k8mN4VF5fdyx+JHQXGLF6yVFDcWfS/2Bh/SV8Bzgz+LnH0ypBa6XzjQx?=
 =?us-ascii?Q?8OjbJQJ2Q/M7VFMhHIWmT5DE3iRm19bUTXEWT7Mg/HpVsyPg/NQYrP3turPc?=
 =?us-ascii?Q?Pn/ybDRiF1shPSwhXSjxWMcJvZHY5aYjpWID/EkHRkeZIOcask8upfy85JJ+?=
 =?us-ascii?Q?2vTEMj6yX5g2o5Hv2SzPcLEC6cKX6YuPeHYqEvtAVcdNw/5C9wMU+z9zVu2A?=
 =?us-ascii?Q?dDfHZWQbXKg2IGQASQh8fbHoo/DNWQuBQeM9mII6gZb/+bjppphjNo3xDy5J?=
 =?us-ascii?Q?e9v6ukU1CstS6kWJpxnTKEUU3e2okBGNNZJTbxKA9aVHv1begrX7CVkRk6m+?=
 =?us-ascii?Q?R+lcXWIZBMbxKUmu+5UrVuxM3VMAE/WWigoyt4Te2nzA1ywLX6CdtPO2Vrl5?=
 =?us-ascii?Q?O+QcK9xrRvM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8118.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z9U4svh+B+9FYsD/jybP4EYLWL23CYng0O4l5bvQF7cbJ8EOVME70M3v7FLt?=
 =?us-ascii?Q?O0/fCVGIHeAz0c7KUMi9t4Xn1xu5z1T6gU4hDgP/qkm3p20BGd5g46cuVl90?=
 =?us-ascii?Q?+nYvyuGIKXhQ8qxJE93G/7NORmo7cqT/+mnplifGSy7mkL5RjJCox/kIZwMJ?=
 =?us-ascii?Q?EKTgihmnnnbcmOpvdSxLf9XbgNv7Wyjh25kzZd8pBuyNusdXHaAIra9wKrXP?=
 =?us-ascii?Q?UWI5CAZgSnqSkSgt6LboLdeJk/ZIVP0AZMsUxf0jUiuGbaHgFgt+4x+c2wKd?=
 =?us-ascii?Q?PF2qnQkeCDQKEBMAMizZ98ovZ7ZCehENhepDtW/5Hc2Vgch0SnF2baCNEU0O?=
 =?us-ascii?Q?y978bqLnJPXmKi7pwDCDDJV+gXH3b6RETgSGwB/OtFJ/Iri62EmFXXJC1mBS?=
 =?us-ascii?Q?0d40YAZ7Fm0lbRl504saKiuc9IPXWdt5fZwcQOY/h2II5oCZfWXqElaVl2Qe?=
 =?us-ascii?Q?hz7o+gdxA/gna0Bs0SPYcetZ6jlW3RHYwQmGvJcngdrgw/+nS+9C5X57U6aG?=
 =?us-ascii?Q?CUSVehC72SptOB8QtiLmutmGNK/0sCDaeMzaeLyN7qF3dq3ZTz55U5xMwdco?=
 =?us-ascii?Q?ge4GIvkz8KeoNSpYkXAcjeqOO/wcjDJt7j7A5Yk0h/r69nz7cSoPlXlihngN?=
 =?us-ascii?Q?aqzgx/b8wmti1FiShzgsFCQ/Vug9oR1Y0S5pWsWI2rAz/ffYClTnqVeErEK1?=
 =?us-ascii?Q?P1GCbfDxxyp6Gh/av1IkBC1EDuBRO1u9uTi3PTx8vNW/kqKBq6d4rBFnOphq?=
 =?us-ascii?Q?XSSjHZdlm+ys3peLfjfBmD9IVmXTsGKf/EjveEJynQZwN7nxDQf7RE4Lt/ks?=
 =?us-ascii?Q?fQ7ECaUUdmi96FnBhhogshzWzVaTr+7fdXQFbyu2rej7G97FY7sybKaOBNyS?=
 =?us-ascii?Q?tfpiTwVNQyrpNpBBTqd9s0yL8xVoIbYTen2lK0voHAk5Dur0LuBcxc/0Iq5t?=
 =?us-ascii?Q?ZQu3Tb6wc1VDRJ9xH+CCpUQL/mIdDM4oWmS0H1gtfWFx3j4s3RZKbM8ej+U9?=
 =?us-ascii?Q?haomIILFubVUx61mWStYtHS6duMCICRouGZc6DE/CCXPJPsqzDpyxC8EpRcx?=
 =?us-ascii?Q?s2rg3IHVwda4qbnfg6tsRaulk/F9spqhgBx3g8GxlMTV1ylliLpa1W4jyBfw?=
 =?us-ascii?Q?QcHV0jx9DFCrN4UDRHAGSuTjzeVkilfolNSCq3XTMqH7l2FZWMjLv8V2SWii?=
 =?us-ascii?Q?bDM11BsSHAEsQ9pVFcXrkRhJ2ghxNqzo9NVIQXQANfV4elvtclLTr/yNrdea?=
 =?us-ascii?Q?+k4rJqCF9G0wFw+CUSz4CChp+VMssrGRf9kZQ+G4jnoBegvF/q4RVBARRAno?=
 =?us-ascii?Q?CKvF/Xz1DkASr1bhFHkX4H21o6YP//wBDwuC07XG9n1QbZTkSrnsST1n+wHk?=
 =?us-ascii?Q?pfxh2zfWHuHJNio2hUJnAZFgExi83xdPgVUfOCOF2RVAUowqb22igvXeBjwX?=
 =?us-ascii?Q?It+KHPYRUPVHHOTAz0VA3goCHs+HjIa5+DgGFhylyXaTpdha+rNFQhfh3ip8?=
 =?us-ascii?Q?9EEYrpAI3feGJ5JMiTbAL259x8eogfB5WHID+SMngVPIYjltIzfRm+ollCZM?=
 =?us-ascii?Q?UNCdZwxry7uiGZcVPjLeKqUp8ZJNdkaUBUoeh8ubcUbd/utjs79HSyGSL2IE?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d316b1-fe49-4f41-6f84-08dda96b3ddb
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8118.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 04:40:22.3838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnR6VNuZ2RYN0K0uZz/93+im0KHekeaA8iwpgEnNrCD6KZudFV2E68zmVhN+fmJHYbKtUDsQJtsKuTpDUX2DclLizwKmYAuHGkdw2veITbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7738
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
> Marking PUDs that map a "normal" refcounted folios as special is
> against our rules documented for vm_normal_page().
> 
> Fortunately, there are not that many pud_special() check that can be
> mislead and are right now rather harmless: e.g., none so far
> bases decisions whether to grab a folio reference on that decision.
> 
> Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
> implications as it seems.
> 
> Getting this right will get more important as we introduce
> folio_normal_page_pud() and start using it in more place where we
> currently special-case based on other VMA flags.
> 
> Fix it just like we fixed vmf_insert_folio_pmd().
> 
> Add folio_mk_pud() to mimic what we do with folio_mk_pmd().
> 
> Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
