Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDFD4690
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 04:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749702883; cv=fail; b=AExKMX4U8c8lz+LWZX6ZaxgObEvQmX+v/wRFhmA9X0yu6/L8hs8pwV/LKsLt5OHgRU5qrG9Ejf1SocqYYzheKMM7C/sxowib66J2zZWOaywR2qNuW1NXPcduuLN3x3Vvn0LtI7rQMy4lLOIaqjO9Qo/iz1mkfSMLGWNofJzX9QM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749702883; c=relaxed/simple;
	bh=yer+pBjMjWuyAgwQVqhch3cxKYxoFDcvS+HSUJZ8LjQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BzVQ6Mqz6vuFs/8xEEdF0KQN0qphXYNYF3zTEvhNui9en88gipqhagJfshUxkp7gDMOAp7Zg13dxfrevzv4La0p0W0dObTeL1gcVF0DYKjUtZbAVe2zt0iZT6bRk9vg7MlXxstbMUByw0+lf+G9OG7/vqEFY3dsK2pOhNMP7G8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fGf80ojc; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fGf80ojc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749702882; x=1781238882;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yer+pBjMjWuyAgwQVqhch3cxKYxoFDcvS+HSUJZ8LjQ=;
  b=fGf80ojcemamLV5jeXrRCwTMLFQkvrEdKgJezI93zQLhqK4xRiNOxp9w
   7HkgLgQc7qbqMV/1DemWbq2MWMudoWwW5RmlMC3eDigakBzLh4p0SkO5M
   hyF7xjgxxl1qVlZJxCO9bBzDgF10BWYlNEuyp5pTwjF9P2QTu69akYiih
   vffUQbfxAEaO42hlq6L6WElpSdY2hZa2zes0HRL4++9Ip/LF3XVLdVUoy
   Ke9etVb7ttNpZrCc93KeevKrCo2tyXKFS7dEUTfriOoUrT5iVzNfFAe+3
   Q2nv8Giyuw4Hrq2JkodjQtPPzEso2nfbDPxyRjTVZj+iJbrfaaHYFdPix
   A==;
X-CSE-ConnectionGUID: UZmbHO1xT26TOWTkaQjr/g==
X-CSE-MsgGUID: LNeqI4quSD+yGp7v8UsIGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="69434757"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="69434757"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 21:34:41 -0700
X-CSE-ConnectionGUID: 6C57iGCWQFa6QV8SElWJLA==
X-CSE-MsgGUID: yGO+NAETTr6uHERUSn63+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="148299143"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 21:34:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 21:34:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 21:34:39 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.44)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 21:34:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KDn+nLt+wkU9CNRARDT5i3wV2RwXbf2LxHGEokTy9CwlOhTRfE4n9QCkrDZDiGAOigx8qFN/91xO/TiHluL7YfT9e3Ese3+lcji+QH/cNjHXkUyd2LKf2yA4MiH1xXuKdsX1J0+xZ0eRGF70tnKkCcw8NliYcUaFfXdVf5KPvw1lqogYRaa/AY5LlMRxU1uG1HizLocGdn5L3TPuFP9z9spNjLP49HZ+RP3NHqxvqnSMi5JibcKn3MSxeaak3NpiU9boEy4QJIRIZu33zUndmNC6GIsHAdT9cnJN/RihL6tPpMfUbsC0uwoKbFZhZ2fFqN1yoWmPFMD+/1g5YFhJZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czL/Aie/8+UBG3Bcj9gHRA5n3dJxKqw2lpvYcFVJgY4=;
 b=qlyjQu+g0b2YaKo1sKUyPw/Gc8lt0LWxvLhhi0vCtTXnTXVZ+G4G+MmNia+yHNKy1ldVm6XgBJPZW003GrV6MHTtL/VE8XPzc+wwavdBIwSXRUKdxPNFla0W7cVcbJqcpMpmH/ii8eNTB5S7/QMCW9LT6eldnA1JYPap8IGkWHhIkrmuAFrYpYTByHp1ozCryNTyrWGbMfr8VeBnLqI8f5iVt0nXzPaCM8dK0zhvmomPhTJ1UtfzQ+yCwO0N+SnUjcxHqucrOjSxZWxTuSr/8RpSeZ7rNttI+NUSGp0ahtNBrP7Xd7VzHCndROQt2rLxmFB3bhnniVtkwtGEK5wWWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA0PR11MB8354.namprd11.prod.outlook.com (2603:10b6:208:48c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 04:34:09 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8813.021; Thu, 12 Jun 2025
 04:34:09 +0000
Date: Wed, 11 Jun 2025 21:34:07 -0700
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
	<dan.j.williams@intel.com>, Oscar Salvador <osalvador@suse.de>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] mm/huge_memory: don't ignore queried cachemode in
 vmf_insert_pfn_pud()
Message-ID: <684a58bf34666_2491100d7@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-2-david@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-2-david@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0377.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA0PR11MB8354:EE_
X-MS-Office365-Filtering-Correlation-Id: 9255c7b6-8c27-40f4-96d6-08dda96a5fd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?KwEsNKcv+F1BRbwZwz6rJbz5M0XJCcSCxU7ovxt5yHJZJOA12pte3EDtMF77?=
 =?us-ascii?Q?XmCv/FulYFpmpee6wlv8KqgDu7KU7qrU7rCNk0tEfapYNLkxImDQNO3BUt8j?=
 =?us-ascii?Q?6vyyqlsNO/ye/2lmH+dXgxhDwuxUnAxlvSFpXnJx39zmFrduKXgoZmjcKXAo?=
 =?us-ascii?Q?2DzRtuogbq81eyLNgDUoLVT56OBLlXLGorbOwhMfmVuUlPESZ4EaiWOv8KSf?=
 =?us-ascii?Q?0xxi11KmP4LUd46tghxfW47w/wP6lgs0CmrYQN3b0ugkCoh6qrDhgUQrR8AA?=
 =?us-ascii?Q?2klYFAWuHekfspNwyen9gjkspnrACWohQ4fLz3/OaovD9pLUWdWEoHN0CxzU?=
 =?us-ascii?Q?ZNaUq6zHtwf3Msxc/7EnRgPYlAPzh4qkiMWfslBZ7owHiPRFEq45ZOVf51TR?=
 =?us-ascii?Q?cWaD/FucK9JdPASEPymCFHqx35J9dOu0OdTxSyEYrhGcbSN6oxDRWQZaD8/f?=
 =?us-ascii?Q?fCisUTNcQZuTaYCvkJEfe0jFYFniw0x4sVELeyv5Sp6uAymzlsy2Lwt3kmdV?=
 =?us-ascii?Q?FTCWtvwNdCcUD9Hb1T4XwImEJdfQiJltCLhbTKDx4pAT/tGedrATMge6pahu?=
 =?us-ascii?Q?E2SOe9DUNDSI360M4QgkxU1TPorJTbGfILEZSVanDAsgIshSO5dB68Aw75Az?=
 =?us-ascii?Q?ZP9xJOJ74vhWEcdFFybHjO2rBxcNqL6I7gipj0xViHoq6DpjxYTBnE85z39U?=
 =?us-ascii?Q?LXMH6cRnTwzNBq5pc68mIgXg/HkuU22sgcuIWDdXuZ1sr5KqZN1SW9F3mppK?=
 =?us-ascii?Q?VcJrv15qQjlrLTPUzqlNBWG1aUbGbwktnP6al8LOMY/0nj2vwr9arRhhcemG?=
 =?us-ascii?Q?MWCf4XnMt7YozGP1j9s5eh0lH4KsboWB1ing+mmfR0mcKLSyV47fh+PtXRtM?=
 =?us-ascii?Q?kBRwPnTRJSN3TsTVklyoVEO++G7CzcsP3d1+jDRWw9K6psUEvGZr2UlHNPzS?=
 =?us-ascii?Q?wKNoHXGf8lFCJrtUQ0+vFFRuZqIVeVFAHEZ4nKZbq6MGoXNncL53CKOm0gix?=
 =?us-ascii?Q?56ZAmTDXPTjv+tDrmJzY9gTIvBjXKr6C/dOXlA346IrAgWwmaUTPzucUuPQN?=
 =?us-ascii?Q?9f3sKZvMrs6OLFnY0vUvBzqosI6UnIgS80sVHr356CNhds9UBnrAmDKJAiD8?=
 =?us-ascii?Q?wo88xlyd6RWX9fimfiG3W1BJR90QvebRvzTnKUeOhK0F9dZaeCsWPbSfHD5m?=
 =?us-ascii?Q?G7EQDoFhW6ZY5gL5w3uCIUYh2eVATG3tvDIxVIq0vnZiFoN7s3xUvMwJDBG2?=
 =?us-ascii?Q?8RqsXvnmQzZSAkihE0ZLSDUFVDxxM8geLwZPGpoJGDF0W6Z+OQMt+oUv9jMT?=
 =?us-ascii?Q?sqsf0ZpAfmrEvJbyGDjjkuRKyrk4WoMUeBbYMUxJQs6EV9kN2Z21tcmZYjcX?=
 =?us-ascii?Q?0TYx52okloNzL8H2uA8ABz13Qi87UoiOQpnT9K6jqcbSCIYQ1XVqPXKPGayz?=
 =?us-ascii?Q?a7lBzimNX/U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XeLbxKg8q+LTvdLDNzxJOiSIPYTglJpSc0eUL84ooXCv8l+qDqXn3Zh/104x?=
 =?us-ascii?Q?pqYR3Inf4dOwbM0kyb9dawo9eoUvnlGmYq+sV63Q5Zbfe1mOqHFcdJLAdUFS?=
 =?us-ascii?Q?F2K5jytZm9m8sCqnQcKYvaFgLos2J47VofJorPMhCuTzJh0bUn3L5qUZBogF?=
 =?us-ascii?Q?ui1Jrdar+FTg1YycIMBho8ovnyfMLXJYAWnp35Z9bE3HQuv7MFV/3SPmc8f0?=
 =?us-ascii?Q?MC+o9m7Eq2wOwsuemywKKyNmmity5ZKGRcTqk5woN8g3TxkytfCVT1psrYGL?=
 =?us-ascii?Q?VVDC2qV2JltQ52DWQaOoby1+MWFdPK7L6P1Qq+bmLm0tv38+L2mjGMTWCje/?=
 =?us-ascii?Q?haGoOxoUYtPwctnBOdzmzZ9KCB8Vt79ujoOTLRCSeojwUA1p7yW/KINharN9?=
 =?us-ascii?Q?7KDsDy/A3ek9qEj7cUbJLC5HsQYOxOSbxtdkSHjU/gbRyv1csz8VLyow8a/2?=
 =?us-ascii?Q?CZUswqyhXy+wUf2ofoqIBF8cd5Us3jPtubg1sAy18XTnVPo1tKqqZDxin7E1?=
 =?us-ascii?Q?1jHccJBSMlXXN60aSYW8iaNbxQUiEQavAnXUHWIMOJj3q19rlv7kalVUq3sv?=
 =?us-ascii?Q?tedRLSKWuVD4qaDJrQy+FIe2ekcQeEWqF9K9ocTD6UhBvU6H901HhyybTNoP?=
 =?us-ascii?Q?T8N55o+f3UVsJw2pY9ZYANw2ofqvg9m6RtgmV0fxs6/KSxLBw1KDzcGoDgrv?=
 =?us-ascii?Q?SPQkcQVwAADsB3kIfwp9P+IU7XQclJHNblGjiPm+e8zqwYGtBxHu22DJq9Op?=
 =?us-ascii?Q?qR7qGZrkvFEDDh8SRZVi/dzBFTkTp9h3wPeJIzleA+YnDcmP9qVMVxovwUs3?=
 =?us-ascii?Q?Wi0aq5ELF6LL+a9MZ7VGjaSJRROJ37RikYS2RDwCM1LdiiqsSlMPc0lP6z5O?=
 =?us-ascii?Q?g4aH4hbC4BTo/bxSDo1USDhHyATodg7ftHR2r7zpeQEFUjDKt/A0wbuw6CXS?=
 =?us-ascii?Q?k6xP4RdRZVARtCb+4f2rcE6EBlqv2757StwuH3sI6UB0YQ6H/dawjz1FsUQM?=
 =?us-ascii?Q?yWzHFe6KfhM912gsU/hMoIdLiubszTVCly/hTqWmJ5pfsdYNahBHY8h/z/pg?=
 =?us-ascii?Q?Bo9S3D2tEXxNvLj4jEu18mEXmaXqMhzcJv7HkWElTT7oHDWK6Px8NEK1Bwr6?=
 =?us-ascii?Q?a0qY+x2pWNXGDLp/8VbNubLshPOMcpNMeuNP6ApUONcRkSts4UKyMzHE/++a?=
 =?us-ascii?Q?lpjSB2sn8EIXjN7H4lneYrKXlhS0Krngbo+Ty1+XH0EplDAElcmbr6dFbknF?=
 =?us-ascii?Q?hU7H3Fqf/nPhCxn6XBbSrBmz8CfUrYUpkgNOBm9oImjXT3hA4/qWQvHBexwd?=
 =?us-ascii?Q?UIO9wIUObBeBM2k6tnLWh9fT4Eww82jS67QEM6lJ69jQdSg/MVZgC60Q5nGz?=
 =?us-ascii?Q?59mZ8QutftFZT8COIfZpzI+I8zVniVK7tZmTrShie9X8xMKktpPJ+zbLp7rv?=
 =?us-ascii?Q?kPIRrw63KkyxPbmUaLwm+OxffuQaD6/dcNzDIYbzR1aoOp2JRCjKwhISNzNS?=
 =?us-ascii?Q?59pBI45jvAgbostwrS27Dik0j8S2+jfVCyBqxVbz+6FC7FEHwA1otNHugvP+?=
 =?us-ascii?Q?7Vwfhq5QHjGGxUUM5mzGBYbEFIeubywsL9uQ/p/ScQ1M9YiOof+Gcm6teuan?=
 =?us-ascii?Q?Hg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9255c7b6-8c27-40f4-96d6-08dda96a5fd6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 04:34:09.7079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJxKu1hH/tnd7nMwNT0CmDtpawEPAB9+T6+kRRhGno6rZzJ/nXfiyiZQcGorrA1rAhYW2KhAAPnUwCsfvHQTOGLtDcxLkCoxCSDHLtJfXDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8354
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
> We setup the cache mode but ... don't forward the updated pgprot to
> insert_pfn_pud().
> 
> Only a problem on x86-64 PAT when mapping PFNs using PUDs that
> require a special cachemode.

This is only a problem if the kernel mapped the pud in advance of userspace
mapping it, right?

The change looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...but I am struggling with the scenario where this causes problems in
practice, where vm_page_prot is the wrong cachemode.
