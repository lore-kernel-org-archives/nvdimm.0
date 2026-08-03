Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4214D3939DE;
	Mon,  3 Aug 2026 19:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785784403; cv=fail; b=PWnx8Buv66W5MPXwRV8GTN44/+KzLTU3sWCNiErMgnAFHsl33YABC4Q895lsZ+JvWaqkjIxcPQ4TY0CsRwZnwomhmfuWcEoNk5y+o0+uEsSRcm6j8dLxOiChCGvqHkIA032CMg/1wj+RF/Ww6P8aZLJpeEYML7yuj21077lOEz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785784403; c=relaxed/simple;
	bh=SytbcfeZaHxoVaipC5rgpiLVpi8/WhRmoTXieS6ceH8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LuAITjPdstvh8wwC93szhyXWUJHvWN+36oi0jikVkM3K3lJ+udeBigOinDvpT4SnHtEVGNjnxyDtqS1jTeJUi9Q5wdSrHu4Wta2htjXZmAJxDQHKtPNMYnhCVQDOF9WZJ2iKyXvBxhPkcwwZjM8ddlLonMf38Bl6Om0ZFD0ghIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UKhfmf0+; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UKhfmf0+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785784400; x=1817320400;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SytbcfeZaHxoVaipC5rgpiLVpi8/WhRmoTXieS6ceH8=;
  b=UKhfmf0+OJl9+CyxAMG/1Xfq25hnmt9IlgxBiZBa/jsU0dOt2VC20RGo
   D5+AD7Rx4i/Xwxv64/p1pyUBqaIJLEDDPF44H8yj+JWfbO1Ei0Zrz42hb
   6DUI1zQnvfyEH5avHbo5TegiCah0td0fRToAT/WkKAcmmg6oIJhUngyld
   6aCYGM1lSS6dIyQQiZsLjt3KZGouS7rxt6Iz5Scr/TTtTiVUmGYQ/EmuR
   qABJxEkSHFzJG5gLNOmnOuNbv48cgZSbf6ukmELeLh4TwHtdEFx9Sy7wa
   hXqy4CUI8DjDSYso7Xgm6B0z/SetajoZzEUNZsbaBD9/DpYgjmKev6gPR
   g==;
X-CSE-ConnectionGUID: y1K8q4WzTT+u2DetTkaaoA==
X-CSE-MsgGUID: 5HxLQ2nWQsON9goayRP5nQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="86450883"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="86450883"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 12:13:19 -0700
X-CSE-ConnectionGUID: JkSYJ321TsCswX8t/h7CQw==
X-CSE-MsgGUID: GWsQiLEZRZuJU3VQmtvoFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="265562869"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 12:13:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 12:13:18 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 12:13:18 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.18)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 12:13:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LywHQ6SB2nQHi9uFdJtXHlSySk4tDtFVIKUZ0Ip2GBg6ptep7iZR9h1mqKRaDT6jAnTCc+nku9wIMzCUz8SyYnRoGQDo6JgTMkz6crmR58Uhz7SYJJn6qKuXWVaYicw49PmCXvnWi5PBUXwgmtd8ECG3D9f9J0MotCZvhck2pKRC4Lb1jE4s5oWwJZ4gxCmVE97QEb+E8y11IiTojsLU7aa5z9/Ldeq/poHUbL7TV2muxK+6uUX59600nOtWYjkaDJgodCi1+ulNtTxN/8ZsCkk+hwW54X6klsF8RcOcE08Fi1p3oiTJmdKH747PXYIHd07aMuLOP/8dhshuTHXhAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=046wWEXFMPQxW7g0j3SNslQrjij1fHSQ90cqA2riIb8=;
 b=vD18FoAaBv+jnBYieu+ASUtMcAlf5ZUa1Qs0MK/ZPjInpaOHr05BuY+cvASYf3sE7c8w9NIf+6VynpsumXtbIHE7303O6hGT6WRtcUY8S/pe35P82IWX6pjEVRkuhTxFVjEIeLYKHjrqWTzgxQY2sCQ53d/z1N44jU6K4OymyQCj8UkFI2NX0+nK3EbIiCyKCJBgH4R5MiFBQVKyHHICWOL5vxnZoDbECr5hRKgmV1xoM3KNilEOIr7PYzpyB8gd4utNDRJ+Yg76hJDNRESDTZNL/29+0/nt3tWxlsZsYyBhI62K3HUoqstwpHVo/aqPWM3/OSgyGUiSJ7l2aStmXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB5094.namprd11.prod.outlook.com (2603:10b6:510:3f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 19:13:13 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 19:13:13 +0000
Date: Mon, 3 Aug 2026 12:13:01 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, John Groves
	<jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Jake Edge
	<jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox
	<willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro
	<viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, "Christian
 Brauner" <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, "Amir
 Goldstein" <amir73il@gmail.com>, Jonathan Cameron <jic23@kernel.org>, "Stefan
 Hajnoczi" <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>,
	"Josef Bacik" <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>,
	"Chen Linxuan" <chenlinxuan@uniontech.com>, James Morse
	<james.morse@arm.com>, "Fuad Tabba" <tabba@google.com>, Sean Christopherson
	<seanjc@google.com>, "Shivank Garg" <shivankg@amd.com>, Ackerley Tng
	<ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, Andrew Morton
	<akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Haren Myneni <haren@linux.ibm.com>, "Pratyush Yadav" <pratyush@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Jiri Slaby
	<jirislaby@kernel.org>, Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel
 Whigham <gabewhigham@gmail.com>, "Aravind Ramesh" <arramesh@micron.com>, Ajay
 Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com"
	<venkataravis@micron.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "fuse-devel@lists.linux.dev"
	<fuse-devel@lists.linux.dev>
Subject: Re: [PATCH V12 01/12] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
Message-ID: <anDoPTHjlOPhnnR-@aschofie-mobl2.lan>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022817.75759-1-john@jagalactic.com>
 <0100019fc5737596-636bde4f-7fc7-46a4-b011-63870098df09-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019fc5737596-636bde4f-7fc7-46a4-b011-63870098df09-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0PR03CA0099.namprd03.prod.outlook.com
 (2603:10b6:a03:333::14) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB5094:EE_
X-MS-Office365-Filtering-Correlation-Id: ea898f98-ae83-4756-6979-08def19343ab
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|56012099006|10067099003|11063799006|5023799004|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 97GVJFa+68zloqTplDikveh8ny7ychBLCx4Dw0HruIdmMsRb5ex7GE0KKeaRjW5FCcpWP+sJbualQNPk2Yd5al20MI/d04tLupP10TNglXfTirHfrvS+AG4ZtjjFY7eCmRjqlhD0DlKmyaNV5jFfLP38VjNsmTDl8IJdtcSZkN+jWKcZkOf8+ERXBLtuFg5vwnjTHsvybg16hcZdQmpLPMzFclGOivAlV0gURNT1nwV1vLlRUIdi7AT5jG+bxOCnb0x790NFqLIwSeWHtiQCLo6RkGpw0+hAcxpEv5ytrJ1H/iYUSjcNr/vVd7kVLgAQkMoOIXRKGEQTPD3pr7618X0toAn0izYHVyrpyqPy6oJ3rFuHhD9eZZNj10yOyfjXEpeFCALCzHHzD4YhQdGyQUMBuYWOfIDYbqanbEjCgIX07cpPl5S21ZFeCXFTw3CRdJ0Z2rENJbAkJR3H+ssJPveqX+Y7NLNTJDxFiDJVlmwqGVAf7vnJxJvOA13w9rNxYYedb50RM8jN0JUDmo3FmW4YLcyt3N5YnuwuP1ixz/EqbBeyVIUNrFRrY22dW458VzbXLZJVJhmoXiKV3mX3/5K5n61G4xIj/IF9rSeA+RGs3MeMtH5s2YojJpGwrLWKAjTy1J6m8lcQL/h9u8hfhjWAMNf+ipc573BEtAvQWjM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(56012099006)(10067099003)(11063799006)(5023799004)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i15FoE2iJVKTjhNM3AC0uIqwbeQ7FKI4Ei++m/48lS0jbyzb5Jm6ALA7VJv4?=
 =?us-ascii?Q?NE3QnRuLfb2Cp4HFCjuA96GMxpbNBDxqjvduKC4NCdSuQJKAc+NzMLuAX22Z?=
 =?us-ascii?Q?EzCSthoC0UU4RwNQOWixv1+5JW3qhIFJ5icv+Ll1MHyNhci1rHViHw13QsV4?=
 =?us-ascii?Q?7WMZsweJnykUxg0mEWNPE9Loi5xNjBIXUY0Nzds3AZtWxr/50FG7VXW1Iz0x?=
 =?us-ascii?Q?WP+9r//6nX09bpyHG5Wwzm080chSQLI8+3GBCrIl78jBfCJzunYl/brb7kvG?=
 =?us-ascii?Q?jHAqMgjMWoa7GkwsQ3+29BS0HnKek1YYP/I36vwlb/+UFpqGnRBZt3VxGZrt?=
 =?us-ascii?Q?j+87gn7a+gYk+tFgtUquFbjG2BT7S70PR5dHJqCFJaKB4lOMbK0EPQ/ofJST?=
 =?us-ascii?Q?ldsGwEReNiJbFj5p0x0nXniDe/d6y2ygLEe9fQ4s3sI5PLAfTOMnH/Fc+5Rw?=
 =?us-ascii?Q?EFPAhiuWXqW9GqUN3YVyDYdgQfnSMfqHHG3jNGj9mfY0JcDhQbPjybDI+9lN?=
 =?us-ascii?Q?+ym3ZEYA3aUc7hCRD00K6XtvuGWct/vGQo7TwdqOo8+S+SAX5GkczOejtZrV?=
 =?us-ascii?Q?a2Hq19TC1Jfus+444bAnY+3BwMJ7Kchb6NauKiJvYPGqeUnWEfXP0wNvsJOq?=
 =?us-ascii?Q?ane+64suuHpekZaRrfJWTdkaFGhvImVfwHaD58pi3wyP+QEEx+s8uA/TsOGo?=
 =?us-ascii?Q?JP/NEX5DkE7X+4Uin7DulpNVhGd172x8G7SOjpXYPUFQQE6IpVy8l20hniOQ?=
 =?us-ascii?Q?0CzbmzYDYwX7SFeFQzloCWw47LW9NwiOg06euc0eITWunOpWr3pZgMkXFZLP?=
 =?us-ascii?Q?RWQTfNjiQAnnBOkfyT39iXBT7a9t5jlbBfJXOX7FZo6TPJ65spCP2kCD5Xnd?=
 =?us-ascii?Q?W+01B8KsAPjZq/Isfn+NDpMA1dTBwG9mvbED3CMMDoIviIMohzNO5mYWvy4W?=
 =?us-ascii?Q?c34QW8modv8JecjgItMbgeEBesNERp0OidMfSABwDpyLmjkWtIfUyVNeuCCY?=
 =?us-ascii?Q?dUolEczX/RWdnRTWgKB+xgbbIDiJOw9Xc2w5blOCTs5uDSfsfNyb5w7CZk+O?=
 =?us-ascii?Q?v3HrgSJ5i5Bxjck4q/qUGCy8ilEkK1KZdTVxXNlRmLC2uHqDukFZ79oHORS6?=
 =?us-ascii?Q?5uLHaHDSjvSdwjtvES5oG1wZbobpo62k6neTBcxrjxCf515Qf/q8NdpjBH9T?=
 =?us-ascii?Q?KRB+QfdugxhhblSntafOEI7TMFIoRcVsmOdXqXg/3agwuR3q9hOIhRi7KT5+?=
 =?us-ascii?Q?9nlVPF/fdjzW52ZtMzlGfrya2l3LSW5ydd6ZW/5cn+zJZlpKKTsFzq1Rk25x?=
 =?us-ascii?Q?pf2P6uoc4mR/MW3ip+DowPnXZ54vlZmIF7A7R4Rl5FMYu6v/m8Kek27X7dY7?=
 =?us-ascii?Q?bQQXxs6EqhxYbaXudxOHNyLl/TVqn5iZLIb2z0WNSww8r9lIp8TogmVCE8cZ?=
 =?us-ascii?Q?Htf1wxLeh3hpZqP9CKH8ndVkYuI+W0XRNs6H/tBwOXi7dT0ry7JTi0x5HxlK?=
 =?us-ascii?Q?kytMBv9bQLvR01EkCEd0ur8xDD4mAe6SbT9aEZ9qrl7aeqhF8zwxm+q8TDyq?=
 =?us-ascii?Q?kw/NGVmfvSyTvty0L/SqBg3uS43+CIZ2KhMI30PJOgDZuxeU5nU9QecwcKPY?=
 =?us-ascii?Q?8nG6LBDu4yOkjlInoMTqUV5lJVKOC35kcKdGe5NYPXS67ddSXiL/Oxqts7mO?=
 =?us-ascii?Q?e3gUT4jgIX6IWYp22wrmh/y30l+Qy8JrUIk5vCGpBqJN37VALpLNiL24iIPb?=
 =?us-ascii?Q?54QFEOpxqLGhCy2ZiLbh2dF9DRBMeqc=3D?=
X-Exchange-RoutingPolicyChecked: ENbcCG56YAdGikIprBSdNqmULGZLjLWKanBR55NuHZSbakmEX9lB/Sw1x3l0rIOmywtlzour22KFA5+RbobGKKoC+rVaQOJezars4jz2YWubQJNnKQknP7Fa099GOJ60FNwipjM+030Ozxb6ybs75cF2OsfrdecXZ9jnGJuaC2omvzm/rBwdgo99C1Ee9nI0TpCAsL0VBsAGyTgfjM2IU/j+yex6Bfv2qSEWxf9Bw/4gPKPBxMDhqoZBcO/CBYcYUSJKcXefVRkBUAzJ8oX+2txLHGqCvdJAvgFzGuOK7w16gfyN6Vz1wOdikUS2eI/bqBjQrmtObXrM8u9XY6p58w==
X-MS-Exchange-CrossTenant-Network-Message-Id: ea898f98-ae83-4756-6979-08def19343ab
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 19:13:13.2814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5IhgEM62f+Ff2vuzKdIeTvcXMIuXgKt84XO9kf1ygnQhiQtziiqH8cwakhmF0pD5tpwt05Z5ccNd9spgdDKlOa0111GstBmCeQ0uGi6jog0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5094
X-OriginatorOrg: intel.com

On Mon, Aug 03, 2026 at 02:28:26AM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> This fix is in response to a Sashiko review, and some subsequent
> analysis.
> 
> dax_dev_get() uses iget5_locked() which creates a new inode if no
> matching one exists. This is correct for the internal caller
> (alloc_dax), but dangerous for external callers that look up devices
> from user-supplied or metadata-supplied dev_t values:
> 
> 1. A new inode is created with DAXDEV_ALIVE set but no backing driver,
>    no ops, and no IDA-allocated minor number.
> 
> 2. On teardown, dax_destroy_inode() warns because kill_dax() was never
>    called, and dax_free_inode() calls ida_free() for a minor that was
>    never ida_alloc'd -- potentially freeing the minor of a real device.
> 
> Add dax_dev_find() which uses ilookup5() for lookup-only semantics:
> it returns an existing dax_device with an elevated inode reference, or
> NULL if no device with the given dev_t exists. It never creates inodes.
> A dax_alive() check under dax_read_lock() guards against returning a
> device that is concurrently being torn down by kill_dax().
> 
> Make dax_dev_get() static again (internal to super.c for alloc_dax),
> export dax_dev_find() instead, and update the two external callers
> (famfs_inode.c, famfs.c). Also add the missing CONFIG_DAX=n stub.

There are no external callers yet as those arrive in subsequent
famfs patches.


> 
> About the 'fixes' tag: this removes the export of dax_dev_get(),
> which was flawed, and replaces is with dax_dev_find(). It feels like
> the fixes tag makes sense for correcting an ABI error.
> 
> Fixes: 2ae624d5a555d ("dax: export dax_dev_get()")

Hi John,

I think this should be split.

Please send a standalone DAX patch that only removes the dax_dev_get()
export (make it static again, drop the header declaration). It's unused
in-tree and unsafe for its intended use, so it stands on its own with
no FAMFS dependency. I'll take it through the DAX tree for 7.3.

Please drop the Fixes: tag on the removal. IIUC the stable team uses
it to pick backports, and this shouldn't land in 7.2.y. Removing this
fixes nothing since no in-tree code calls the symbol. Name the commit
in prose instead, something like:

  Commit 2ae624d5a555 ("dax: export dax_dev_get()") exported
  dax_dev_get() in v7.2 for famfs, which has not merged. The export
  has never had an in-tree caller, so make dax_dev_get() static again.

Keep the dax_dev_find() addition in this famfs series, so the new export
lands with famfs.

-- Alison

> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>

I think you can carry the tags for both patches because the code
should end up byte identical.

snip
