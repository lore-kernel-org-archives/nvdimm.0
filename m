Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4A31D7E57
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 04:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749702060; cv=fail; b=cN4/R0/nDQvceRIfbVKOd1F/gwjZxFQzUGiegCAh0HJEUKC35YCkXtWyczunsflcyzYrq9pHVgrFNwZQx9YBkf6G9U01w2hKCXmKynZoGOWgjqEn0wMbxtFvCle4kw98oK34gMJGoPcIYmSkSajT6QdTCY3f3aZL3sBnSFJEYlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749702060; c=relaxed/simple;
	bh=Qy22zZoTuN8ofKE4oJ9rZZ0K6IoQLqQtqThaqr6BQTQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HHXyqoYXZ/7HO84coBOPgOurnm/vlxmbd4cCkVGkhmXalSqOHTgNZVj/f5r0crGNicNnsblZ0a5obd9lCMNqTtJ8E/sKokRjeY1f6PohkgnIe4GOUNS3guO2Nc6xgKwCa7bPIwGrlLm8d1jdFo9wItIy8VJnTdRzOzwOQa0I1LA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fut46eBN; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fut46eBN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749702059; x=1781238059;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Qy22zZoTuN8ofKE4oJ9rZZ0K6IoQLqQtqThaqr6BQTQ=;
  b=fut46eBNHaQ1/ZSO0Xk45dKd5YKAFgz4Ty2/d4ZXuQ8B7rBz157PgUb1
   DSD+OMzmwR+hlfuMWAaNIbqFZxWamwutgW6MoweQG+wPfsi1XRWZ0JD8Q
   cLnRl1lKNKfdmfZiiV6ohwDZntNYrQBLPxZLhJoJ2wpM7mjOODW/ifzhE
   hyV2N5OP7IM/MQMR5ViqJJkcvaAiEhjLeJ05uFAX617IdXLOoWURaep1Z
   1zC67wLz310tmkU/m6BW1YOg7BmST14MetynD/P0wdCzYFPAg92a3343L
   mZeHp8bpRZcyRjSlGpOzbo1XatqatBI5w5WHJeGcXbL+VTgc7eDwn+rVe
   w==;
X-CSE-ConnectionGUID: ILo90rN/Q3KICaBvhXO1Mg==
X-CSE-MsgGUID: 8arJ4N6LStWXCG1kwmKX5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="55533874"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="55533874"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 21:20:58 -0700
X-CSE-ConnectionGUID: 2RRSf8qVQ+WZh4Fg3dRU7Q==
X-CSE-MsgGUID: 6a4zTtikTGW+4qkNtVgnkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="152679277"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 21:20:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 21:20:56 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 21:20:56 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 21:20:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TFqE7oy1Wsv1zQdI7Yh5pAMMP4K7r+m2Kg4Kfgi1JQzh2hNcECWqV9rPDUoamlgCAj4xb34F/Y+8kGtQnh2OdnEkL7UEJVLgR66lh3tnjUf3/9ZmGB/4ln2oflZFQ0rggdgjvdVE2jUVPvnnNSL6eWmMGPujJ1tWyLep6cw822IkMv5bMMOqMDlaa+htKOUsP4u0IQaQvoGjshssL7Out1Gp9aK/yw2rBU+JOavAWIG6e/KlNjV3lJnY1LHvBn4+2dsfetN6a1kTtjJLFN/4bDSd8YnraCTE3w33DWa+8Ffp4y8UKi8R9R7NMdqMCh+N6BL5tNPhqYlh4ffHwd6QUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDW7dH4y21caWibAdMDvTCSumatm9bLbKxK/L85Mn9w=;
 b=mYvKziI3DQLreNniiDP/TnBbq7vY+/xIrjPxCkI3VbGrjNqeyXUDwl8TcRJlYlKlp8EkUgsyi7jxY19iS7GHWCMqBKEbL5nYe48UPqSHPpx7NllGmZpwSoEEGkcwbB0AL7KJPSI8kKHCYQW2soSxd8m7m639xUi1Yr8tY31iuBzUjTShHujor8K4P4QvN5jh18+TzdxVj8b5PtiE1ARFQ9X3vdf+9JSR4rOu+h3gB7oPbh0OHn1l9CQKhRGVaJ9NrWOzuURhfbuzRD5Te54ygvUMOXFUMItFkGMGU6XmxHdIez6o2v43JYPYouEfhg3bbCPFvhgkPUo2iKZy/y8tYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB7766.namprd11.prod.outlook.com (2603:10b6:8:138::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.32; Thu, 12 Jun
 2025 04:20:41 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8813.021; Thu, 12 Jun 2025
 04:20:41 +0000
Date: Wed, 11 Jun 2025 21:20:36 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alistair Popple <apopple@nvidia.com>, David Hildenbrand <david@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, "Dan
 Williams" <dan.j.williams@intel.com>, Oscar Salvador <osalvador@suse.de>,
	<marc.herbert@linux.intel.com>
Subject: Re: [PATCH v2 0/3] mm/huge_memory: vmf_insert_folio_*() and
 vmf_insert_pfn_pud() fixes
Message-ID: <684a5594eb21d_2491100de@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250611120654.545963-1-david@redhat.com>
 <lpfprux2x34qjgpuk6ufvuq4akzolt3gwn5t4hmfakxcqakgqy@ciiwnsoqsl6j>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <lpfprux2x34qjgpuk6ufvuq4akzolt3gwn5t4hmfakxcqakgqy@ciiwnsoqsl6j>
X-ClientProxiedBy: SJ0PR13CA0080.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::25) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d32fec7-ba04-41d7-0a9f-08dda9687de7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HX1Fakd9HObILSdGXUXjWK+DTtovts3QDAYXGz12bareOUBTZh73roTArthX?=
 =?us-ascii?Q?zHKEdVU5aGZQRYfLE9dG19HMd37XINBNkmcx/132ZXb1RfrsTvs9XEfDgaL3?=
 =?us-ascii?Q?VMNBeGi6wYmGUYK7WuCN6wHPDDyVK5aAirgGgJM/BY2Sww0RDcL6BwbcA3Nb?=
 =?us-ascii?Q?VCkRk1Ga30Ry5j+U24rLI3No0eKY5NKEieCRKdBJdUxHyxBtFML/neg5Mp/p?=
 =?us-ascii?Q?0D8VCTFOeswvUYOnFRyEPVhhD3lqrCmXImwg1WuraB5bsExGFAzoLCoIt3oG?=
 =?us-ascii?Q?OCISGvwZBkM4mWnM8ACtHEFuZizcKf+WHi3l9B0EkPs87X21vqgx6W7hRU7u?=
 =?us-ascii?Q?0IUoOzoTkwYjkrWzEnBw0d7GyJZ2jS+cwytNpU88XtdlKzS0xychS3za8r+J?=
 =?us-ascii?Q?waYd6qRlLO1AlZHql/7MwEDZaGcjfd233L2pR0avCqTinnCxVgztP0QRC0vM?=
 =?us-ascii?Q?qU5d7hTi6sc8hKzK8NuipspHdAvg8nxuFTVstewDyXqWKI2zIrk3JbbEpzrK?=
 =?us-ascii?Q?0aF9pZv621otVLk+Nuo/lb3IfFedXj8ge0c674ZaHvZp73XfAoNcayN9m/Z+?=
 =?us-ascii?Q?cqY2JRMDFFFr5iOBHMzwBtnzzpbYUVNzWYB/L7mFs0yuuwp2YI3FaarJI0Vr?=
 =?us-ascii?Q?6VvYx9DEFAtKKM+gUF/1eDABN+cP939IzBzuX80o8HX481eS61drMJBS4+KQ?=
 =?us-ascii?Q?oBc9+bP4JGIz2k18aTaJaq4/XTDOEviuVCe7BX3cK9eLKq76EYV8xyDK7SoC?=
 =?us-ascii?Q?RgIhtKjJVTOlrzUOaJsoU/nEWlPHaknekiKVB1kYgPFhEJ7zg1II69t3h0zY?=
 =?us-ascii?Q?q34fhCX6tZOdEZQwBUtJaF+dzQbTCm+Smgy5XidBIpuNeyKGThU4CDj0IFcZ?=
 =?us-ascii?Q?1Xjt6HqFHvDudaOtYP7cbXigo0nbm0W1oBaOdft9vx0SU5pF5VUbcQN6aqGs?=
 =?us-ascii?Q?ODo46CFKptOkVZsWCjIfDojOe5lZ4Dxzjdfy7fKkXN01WKgEooQUI4ZSNtLx?=
 =?us-ascii?Q?UqwMePjRL05bBGYElxWWDzFdv8AstHkTJBJiXvpJ/pUEdCQ0+EHXZTtZ1XTc?=
 =?us-ascii?Q?oqTCtNVEX7rLKi3ZnN4/ADyk7DDI5jorSX15qBdQ3qST6LA9yPxMy+VtlF+x?=
 =?us-ascii?Q?xAUvgA6M37UYVNsor4QFRg1X8Y8xN95vln1CO12MTUdPEtyo+hbiqBj2UaMX?=
 =?us-ascii?Q?nQKHBPt5kSalJrjKv10lvQepRqM5rBQckcf4KDiwWLwtjueNPYomFKF7IEV0?=
 =?us-ascii?Q?bJHjr8YHgoCxPR4ZFtT573K7iqlTVQu/DrqfFctvc+rzv+3JqVzFKYfhwOY3?=
 =?us-ascii?Q?z+RTAyKvl8ZqvMCuq5yRXF0ZT9ApPIUhKCm/iR38vCEyejcFs4IEMqWnSus6?=
 =?us-ascii?Q?kfJJ6bZm4BW9TWSoeYV+jD4fwd5VN7QOcI+nDJ3D6V0CPUtl6pw1OFue+sHu?=
 =?us-ascii?Q?yeUETpzqfiQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4V38w9RCKFRMVsQSIjzQOFcSl0wuW/zRTvP8iKlna3EyqKNPiWQxWlWsTwF4?=
 =?us-ascii?Q?uL8L2lFCT7JMwm4m8o50pX2Hl2bD3nXhgg/1E/PqJWkz/MnnHRViJeYC3ZJm?=
 =?us-ascii?Q?xudtHpNitxKUO1EZHSqPQ267c46pUiKgHUeMxRs/W4GMQFBKxVR9z2tDMXXm?=
 =?us-ascii?Q?9uI3NRzQ4EX8tbib0Lx0I1RlbBCeJXcz6w0l/F0NG91QpfubjBaiteE7KGkA?=
 =?us-ascii?Q?XBSGZFD/EuwnhZZs3m/z1n+SBEhIw4eBqmfvKFSiFCcRAYWA+2OqtGZFOpwY?=
 =?us-ascii?Q?Qxsz1CBLW1tNt034onOG0zVGuzdwk+TOPKkmxUWohG7SGWIgDKp1Z5aSaXi6?=
 =?us-ascii?Q?OqZxKGLmF+/0poszunr59tzuubfb3fQtY/Sri6FM+QFSZEViMuiKKRX9idVh?=
 =?us-ascii?Q?1Qdi9v9l9+0/JLwCNJIucOArdMCHyJPAUGQp3Qxeaf5GTFWa66xp0Ya/I9M/?=
 =?us-ascii?Q?hV3ceB19BagqaZf1PsnP7yGL1zIrkzhxcbb3/sBbdS+n09DyOeGOW5tk0xDZ?=
 =?us-ascii?Q?DlKJ86exU1x0YBUOPJJYcuhbJtWvsTShRYZxmi1cmxfdMFyjzM3UbEbQH6xq?=
 =?us-ascii?Q?Uspxjx1AH+ar8f3ZSc6PWT7bgIG+wzRGSni2sGyBrrKIRuxA/MquHrTwOB78?=
 =?us-ascii?Q?ksgighS3WnwR0avMbzRdArlc1wM7HkM+kg4rhhOzqJ1mUAb8sEaBbn525fR1?=
 =?us-ascii?Q?miC/439acpMNVgubOWnJXiff5SJ+XJFdihh8PdjZtFycXFDyR8Xynio9Vasq?=
 =?us-ascii?Q?dKw3vLEP8edFkM8WbFFPFh1SgbLfM13FSTX42yD97m33Ku6ltfoK9UNRPsNK?=
 =?us-ascii?Q?/9sfhFT6hiqcKOPTVg18gI/mSKVRpvaatUB2Efoz16jVT8GwkJKlQaPjSJnz?=
 =?us-ascii?Q?bMfCVSPi3G+bq7ZEKrvCl7af3F9b1+IsxaKBOagU+HguGS+JNqaibM90nUH9?=
 =?us-ascii?Q?fgdJKSncxE4Ww3ZJ76rrDbpyvpgIyifv4NVdFfCgx4HoGMTt3gqlgZolMcyc?=
 =?us-ascii?Q?JfHvnjK6d4AR6bRPpJfz+uT0KEJmaW04Gporvl9AZQoxVPIZbfb6l2Lx+3P6?=
 =?us-ascii?Q?7QtAV+ZQmBlUCCkai0+kZ34ArGkvWMas6VHKtvTwU4lV5324Ms4OGa/ii/c4?=
 =?us-ascii?Q?2odX49wfXe8q/2FJ4i6pFeE9jFsxBsaLxfIEXdr7SD6Qxqow12T6fd6xRl6Y?=
 =?us-ascii?Q?S2EF89q9WI/Dux7VCozgcwEv6New2ffYtCvT3o9fNqN8szkiG3HyKu7Tqra+?=
 =?us-ascii?Q?5xxV70eIXD57ufC4s3MxhfUQY/Cf11ahfNXAOfQ/uahzWha0VdWvTiZKAjCY?=
 =?us-ascii?Q?Qr8/svEcLTV0SyYLxjenX6/ImfDmANjXiYZh1LO6VTqMrHmVB07rVpERwh6y?=
 =?us-ascii?Q?Y0wN+3FmVSuedkIqX0zPN3LicOpL4mfah9cEqmukn37/wYJedYu1JCteeP31?=
 =?us-ascii?Q?xbC2sfOMdXJuznHoGkXoMH4vjgzQf9WRHL9wjdPtU7THkxeNIOY1RnPSlaQ7?=
 =?us-ascii?Q?J/l2OPsiCAXFLC2lZQ+1mlgJ/3y7mWNWjZDqj0kw+vB//fKMVCVVyiLI7JW7?=
 =?us-ascii?Q?ai3uo+GBWZ911cx9J/pW1GyN2DYpwRewS4ZWYPl+g0R/cpPIIqCIpiHF1En2?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d32fec7-ba04-41d7-0a9f-08dda9687de7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 04:20:41.1791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSP3E5rYArNY/PKpl3ZkzKfXJDNitRDJfWNMKvH2mPF9utIZX8ZPaIx5zQJ6r0bNhOYIlSTgkG7x3NnDGT0noVDt/48jnZw2Lq2JfRrppMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7766
X-OriginatorOrg: intel.com

Alistair Popple wrote:
> On Wed, Jun 11, 2025 at 02:06:51PM +0200, David Hildenbrand wrote:
> > This is v2 of
> > 	"[PATCH v1 0/2] mm/huge_memory: don't mark refcounted pages special
> > 	 in vmf_insert_folio_*()"
> > Now with one additional fix, based on mm/mm-unstable.
> > 
> > While working on improving vm_normal_page() and friends, I stumbled
> > over this issues: refcounted "normal" pages must not be marked
> > using pmd_special() / pud_special().
> > 
> > Fortunately, so far there doesn't seem to be serious damage.
> > 
> > I spent too much time trying to get the ndctl tests mentioned by Dan
> > running (.config tweaks, memmap= setup, ... ), without getting them to
> > pass even without these patches. Some SKIP, some FAIL, some sometimes
> > suddenly SKIP on first invocation, ... instructions unclear or the tests
> > are shaky. This is how far I got:
> 
> FWIW I had a similar experience, although I eventually got the FAIL cases below
> to pass. I forget exactly what I needed to tweak for that though :-/

Add Marc who has been working to clean the documentation up to solve the
reproducibility problem with standing up new environments to run these
tests.

http://lore.kernel.org/20250521002640.1700283-1-marc.herbert@linux.intel.com

There is also the run_qemu project that automates build an environment for this.

https://github.com/pmem/run_qemu

...but comes with its own set of quirks.

I have the following fixups applied to my environment to get his going on
Fedora 42 with v6.16-rc1:

diff --git a/README.md b/README.md
index 37314db7a155..8e06908d5921 100644
--- a/README.md
+++ b/README.md
@@ -84,6 +84,11 @@ loaded.  To build and install nfit_test.ko:
    CONFIG_TRANSPARENT_HUGEPAGE=y
    ```
 
+1. Install the following packages, (Fedora instructions):
+   ```
+   dnf install e2fsprogs xfsprogs parted jq trace-cmd hostname fio fio-engine-dev-dax
+   ```
+
 1. Build and install the unit test enabled libnvdimm modules in the
    following order.  The unit test modules need to be in place prior to
    the `depmod` that runs during the final `modules_install`  
diff --git a/test/dax.sh b/test/dax.sh
index 3ffbc8079eba..98faaf0eb9b2 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -37,13 +37,14 @@ run_test() {
 	rc=1
 	while read -r p; do
 		[[ $p ]] || continue
+		[[ $p == cpus=* ]] && continue
 		if [ "$count" -lt 10 ]; then
 			if [ "$p" != "0x100" ] && [ "$p" != "NOPAGE" ]; then
 				cleanup "$1"
 			fi
 		fi
 		count=$((count + 1))
-	done < <(trace-cmd report | awk '{ print $21 }')
+	done < <(trace-cmd report | awk '{ print $NF }')
 
 	if [ $count -lt 10 ]; then
 		cleanup "$1"

In the meantime, do not hesitate to ask me to run these tests.

FWIW with these patches on top of -rc1 I get:

---

[root@host ndctl]# meson test -C build --suite ndctl:dax
ninja: Entering directory `/root/git/ndctl/build'
[168/168] Linking target ndctl/ndctl
 1/13 ndctl:dax / daxdev-errors.sh          OK              12.60s
 2/13 ndctl:dax / multi-dax.sh              OK               2.47s
 3/13 ndctl:dax / sub-section.sh            OK               6.30s
 4/13 ndctl:dax / dax-dev                   OK               0.04s
 5/13 ndctl:dax / dax-ext4.sh               OK               3.04s
 6/13 ndctl:dax / dax-xfs.sh                OK               3.10s
 7/13 ndctl:dax / device-dax                OK               9.66s
 8/13 ndctl:dax / revoke-devmem             OK               0.22s
 9/13 ndctl:dax / device-dax-fio.sh         OK              32.32s
10/13 ndctl:dax / daxctl-devices.sh         OK               2.31s
11/13 ndctl:dax / daxctl-create.sh          SKIP             0.25s   exit status 77
12/13 ndctl:dax / dm.sh                     OK               1.00s
13/13 ndctl:dax / mmap.sh                   OK              62.27s

Ok:                12  
Fail:              0   
Skipped:           1   

Full log written to /root/git/ndctl/build/meson-logs/testlog.txt

---

Note that the daxctl-create.sh skip is a known unrelated v6.16-rc1 regression
fixed with this set:

http://lore.kernel.org/20250607033228.1475625-1-dan.j.williams@intel.com

You can add:

Tested-by: Dan Williams <dan.j.williams@intel.com>
