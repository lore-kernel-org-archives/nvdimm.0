Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879791E492D
	for <nvdimm@lists.linux.dev>; Wed, 25 Mar 2026 16:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774454460; cv=fail; b=sfctcsHTEreWLjGghXNZkhPwjXpZr2TkIqE2unkEwi/IQlBQJ+H8fstrjbHvA0xAYz66ffZRbsxSPof6zg7+zgxHgShowM0AmST2WZwigx9cHKHLGph/bHWT+c8FWONxafSlMcy+PsxGj+eX0as0WfLKvVwGve68NSeS+LfzZhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774454460; c=relaxed/simple;
	bh=zm9ygH9qFniUJm17KkdY5/gbP/A7DIdac5s53f9/S1Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eJRcLNya26Nq/0lAXRqwCYdW+vta5aw946Ph3u3d2a34LFGLvJkgLykz0VcqEyokml20GNEuZN8GGTkZWmc4FK/uiM1uOS50DP5bnr2bTLBPUwm6zsLFgJD7AWmgKWX1JfXqXmuF9xQMxPwRB7pKNBeX5sf+4rkzBW4FE2oK0CI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BcPMMSCT; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BcPMMSCT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774454459; x=1805990459;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zm9ygH9qFniUJm17KkdY5/gbP/A7DIdac5s53f9/S1Y=;
  b=BcPMMSCTEgnP2nFk0l8cSAt82J70OeH7lVOI2N1Pde1S9boTHlyc0EYa
   T3m9ts3CMy01FfvPDrVEobaw+KjUkOH7nIf3DAKUekxGl89V4EUIz4wpY
   WIHIF9rcC6wErWwKxIU9isgTP36LNLKtGwQhjPW1jEaBRBVQ1/9Ix0UFH
   P2SFxSjTUmlu2JWfzTczyZT2+NwV40F42x420mO+aLS+pRPhYiOSIBSV1
   9sfL9G0mcPlZSOUBojcHu1IvKUqx53LfU2pXIyoQpRwYRyacHWPEKUIGI
   jtCHghKzKmXgLE6W57VkTjK7lwY5xWqLLMis8T1V7J63zHFvg6wGU77Ql
   A==;
X-CSE-ConnectionGUID: Zt+85DhdQJ+tcAiW8+Kt3w==
X-CSE-MsgGUID: vJFysgSqToqfhEKnd6TZqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="75383423"
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="75383423"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 09:00:57 -0700
X-CSE-ConnectionGUID: sXuPjBL6SMyGaEYgXX1Y5w==
X-CSE-MsgGUID: Gc9e5mFxSOCOcqUzWa4USw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="229178629"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 09:00:52 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 25 Mar 2026 09:00:51 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 25 Mar 2026 09:00:51 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.58) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 25 Mar 2026 09:00:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IEjdDK5tKShJ6CFTOD5KX8i0q9aH/N6n9O7+0fkKajYcKk8NbpbaY3YDNY0nnm8sim/V8HnfXyaURs5aX4SU82iEdC7KhrP5i5yjQsCjWca4fxSw0VpgHaXPncbhRl3BcoeVs5TTdvyvLNo0Lls4Qc18Vo6lh9TJRsVUGtqo5Xhd+YsUajDSXtYphRn89uZVACtV5LtnlOG14ALL/s7j4VCxdNZdqfVEmQa+ujuHcS1myklQn6+FdYfFysXorT0W3hRrkYpcLWZwH5OE/GklY8HFgm3nO1Ss8irkLbp1jRpFkcgvBRqqy3nIrg/0UcesLyU0uRMS7YncseAQcPhJIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S2jHGJt89Mp6CyVLBEtm86qLTc9s8wGYUln59SO3ymk=;
 b=ea/aDXM+aKmneLp0b5/XlnMQjsQuSpFA7vOeY6WaNI+dMUNyT2JqGQPeDJ/WOsOj6/+9+Hjf1ymigDueGoM8akEuSTyH0+mp9UzPKJIKDPUYVva3nYXzvAS0yPDDAVuJJwlPzakwTsMyePRaNsttUOvq9DOEd63pt01drwFmNY2l01xGjJwIIsJAP789ijXKr8nlwDsTmmP8j01yGAhTPYCdQAQGn62J1ISQB6I/kVYN0eU47JWnPYO41tajlQ0PJM7rP+gDbjPdXYbKSLoFihti/ad6aUAvQHya2gq6Rx67TdiPSNcyN1qrkrCbG4S8mfUNAcgzGv6i4nj1B0iSOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.7; Wed, 25 Mar
 2026 16:00:46 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Wed, 25 Mar 2026
 16:00:46 +0000
Date: Wed, 25 Mar 2026 11:04:32 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: John Groves <John@groves.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
CC: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>,
	"Dan Williams" <dan.j.williams@intel.com>, Bernd Schubert
	<bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, John
 Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand
	<david@kernel.org>, Christian Brauner <brauner@kernel.org>, "Darrick J .
 Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Jeff Layton
	<jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi
	<shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef Bacik
	<josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <69c407903b54c_130d6e1007a@iweiny-mobl.notmuch>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003818.5009-1-john@jagalactic.com>
 <0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
 <20260324143927.000024c3@huawei.com>
 <acPX9T2ZF7xTCHtZ@groves.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <acPX9T2ZF7xTCHtZ@groves.net>
X-ClientProxiedBy: MW4PR04CA0299.namprd04.prod.outlook.com
 (2603:10b6:303:89::34) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|BL1PR11MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: bc633a7f-384e-4950-a0a2-08de8a87ad1b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: JUEd3PYXJIXouiv5h19q4fhbVycRjLSZxNhn7qcigxMJAqH6lEcYhRN+7H7hGEDgQxImhwgLcT5DNuXwGgRDIWu/GzaxVZORGajHYFTUc/ExnaVMIeOdxhkiYOIYFuoIA00hUysMCq21Um43wzwNjhmnKNT/bgyecD49e6SqQ9wKyYClSO84IaeP9iWwP9LAiy2NFJz4Dmc2OFBgwi9eo0gj/QCapOPVLIKqgx7A667gJ97VDLti5zO+UQ0xyM0nHu9PojihNTJYHh7hQbYOYauH3kXblFiUnrdTTLGE6zq8bf1OVKb9DyUfvTyXGvh1BYKJyYYhX6WmUAQzQivivQOgRHTRtROCGKvliXp3OntcvAZoCr2v1e2ueoBC2LNJfEJbyMs4BI6ijLiBd0qI37hvogiPl/RFmOdNCYql5beo1Bnw0CLTGMWO9lf6hYdNjP5iEVL/FadeXLHfDHMb9n2/5cWOC60+GNNSFWrSPhRg+mg2gdQsPclNxwXsH71Y3jbDfGTEsEn9wkVeo4Cp8L1AzcjVsvSdgQ8ggTz3c2wr4G8JaBkPJ2/wZTZoaUIehMOmZvYVqBi8x71ssADRnqLjhuL3wowGQ4VIg6eP80cOaECvzvSAH38G0TN7rhOCsvix1ldoLwjQOoPb2Ktr/ebOnKOs3bkqdN0POFG3q/wcCtdWtvaIVNPLEQuwM4bD3cSC47u4AUpUskK4+hjtAp6FTMaK1VMZGzvRno3u05Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UCw8irnTZnnoE2+CjIP/unxsJhf4lxOEiwLNKbg5qJbxLEt1TmrLOUm9/8ke?=
 =?us-ascii?Q?PXsU1lNnkod3C4dZcV0osQ4m5m5+krVIEM52xHwwMbZOngCBdEBoIZVeJXlN?=
 =?us-ascii?Q?/mOMfOvo8bYp32EnPZYGDTSkqk2wXPK/qRf0Cqq1mQQxJNL4VJtqSkpDLayt?=
 =?us-ascii?Q?T3NGw1gIa+bSCl/+Dw6rOpVu/3vwSRmIrGJpSE108HFd+TOnZnaPPPRK0vpE?=
 =?us-ascii?Q?Mnu+ohqBB/IDWZhL09cRL1DCkK1LtK+XoSFDbHmNh5hJgSh+YgJmtrxE3Zcz?=
 =?us-ascii?Q?bGGM9Vpzlkd+8r98fzuBJcDzCBSQaF49JBtoolQwWjRzslZNWMEY5Zw+Xfdz?=
 =?us-ascii?Q?chfY1UJoH1qCTwYsYtUpFqgl3NQoZv5ogXqMf0KNs/MxTQECpm1RI2lDZYg+?=
 =?us-ascii?Q?ttPOiu4gs5rLL//vZrDTFBKyHoP+ILNEVFQr9SXrqW8pUHDVZQYM6wPgmhKt?=
 =?us-ascii?Q?fTriyzGSsFnPBtYET9cXOd7drDazvqwpvMnXTJ+Dxm6jFSUKaV4mTC01gc6Q?=
 =?us-ascii?Q?6FXF1rktCt7n05DDmJsbiMMo5CIYNrsopxDHfAGGFAsfctOpuZx28ELUv/nb?=
 =?us-ascii?Q?erF4kKUde6CQn3qZ4WAT32WvSTGiGY5Ir76FabZd0H6Aq8Y+GQXBiVEcLTxs?=
 =?us-ascii?Q?5BCm25jhHUNwRtr9O2wf5k/HX/6Uc256jgvuT91JjPEWWS6Ikp3l8XvIeek0?=
 =?us-ascii?Q?BIQfsNajKfIbJr0Vl2p0D8PKtKCO9WpB0ykQFCMyj2W3oYmf0Gh6c+nnDZfN?=
 =?us-ascii?Q?2iGl/3G7SWWNrKDBTijjJLjzQD/+yDY8DF+yfB9hWIZi0teF/rYz0yOq9OUT?=
 =?us-ascii?Q?V4LY2YKj2lyuhBG9gW9h5oLrsdIRreJc87KKw7jahOdLGAxAvaB2PnX3TPgN?=
 =?us-ascii?Q?zZgPtu8vFU+DJKG2/8j/NC1FkL7ytvYnT3qDY6iwVzV/BNxo6hOOjmhS2JsL?=
 =?us-ascii?Q?TmRBW5qfDB89g365wlw63VnswhdFvG7wynS1a+kAw301pXy3Zd6+xl2ML/hJ?=
 =?us-ascii?Q?VFYlyD5KH89UbleuP5TdWWzOmCX1s6ZQHhMZnViT6rrM7gVCYVBnCrFw+bYf?=
 =?us-ascii?Q?OonFBRf2AuVC9wFO5qDySWY0jv5puAXD/khA9P2xRPZKcy8pQ8SfESOfLH5l?=
 =?us-ascii?Q?zyy9guHMeIV/gdEJ48fgdXecGfAhng02nmbdtJkmVGrw3qgFjR/YbCAhD21d?=
 =?us-ascii?Q?pFONnSAtOP4eCDUg29HenZtLjoUf3mbb77Meu20p1Nr5mMDN8xzk79zSPaqg?=
 =?us-ascii?Q?LOCgN4+NPObVM3S866O78A52W2B9VHULBBaaUKbXh6grQFqAWJejngGvow5R?=
 =?us-ascii?Q?Pu4ABCso4L/jeROMLY9lQJh/ycqX6Gd/48n0yB8k4uxgIP2sADBk0kDa7YCV?=
 =?us-ascii?Q?BVixqgz3gFy8MmbuO/OV+kGYCM/TwrjkwMd4vxKZTtGulXF1aHY6JXGJYpvB?=
 =?us-ascii?Q?XWDtGriuQwfrdYPCC2LjSUXw/ztek1cwnEDYUNcVGSNdB5GcgSlDbxvwBHuM?=
 =?us-ascii?Q?OQiT1ZbL6EDC3qkn7xEIq59D3ZxQQikq4H3+hs4wUUseffMGXtiCvj3vpZhW?=
 =?us-ascii?Q?bWIKB5l4uF8JaTl6TVKrdoBEv2OPbNLOGxcvHi6fQTkS+18lXbyxmxkquvlw?=
 =?us-ascii?Q?iDvwFxzOy2XnjAO3ypbO5tXNGkcZ/r4zXGjVeYr5sCKOPYx/6Ulzqu/QRlIk?=
 =?us-ascii?Q?V/7Rseb3TQUATb61HUWWT2lYdP7ct+L1+DSGgRNC6ucUBHAmWvKS3GsPcYh5?=
 =?us-ascii?Q?f3yI8uHIyA=3D=3D?=
X-Exchange-RoutingPolicyChecked: Y7kqY+4W7cOFTR+7gge/40SqPf7xamrEOJLAJ11vdUuVGddbTNENzxHSEbGfKhVCxvxMO8+g1WD8zS2IiaZPCMneuuNPhR29ObFh58NIspHw/tMlZbyGcmod1fzel8Hcc4ynI+zhBjBL/oNeQIvnJv4U8Vl2fAOU1yrt31k19Z60FBH/su+MlUez8MgYkJA8W++ovGaPotmAuL6C+kNZQw5qxzAluUy9S7pg/NXWlA3uQMy09b9oOZdzmLcl+SiZ+0WzGZaL/fBkCYYBk6BjxXzWU6rwCNeuk158kZnc0OvDTbYir+TQCDphY0sp85ux7D9zt+BZZ13nBrrXbvR5ng==
X-MS-Exchange-CrossTenant-Network-Message-Id: bc633a7f-384e-4950-a0a2-08de8a87ad1b
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 16:00:46.4782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xp7PoC09q0ylEnn8CTeV9cDSqpofSU7U0xUzW+wE+U3nrAwY+VNpCxPWRVaMkeWmVlKFD2DwDwIwWkOgDQPUVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5978
X-OriginatorOrg: intel.com

John Groves wrote:
> On 26/03/24 02:39PM, Jonathan Cameron wrote:
> > On Tue, 24 Mar 2026 00:38:31 +0000
> > John Groves <john@jagalactic.com> wrote:
> > 
> > > From: John Groves <john@groves.net>
> > > 
> > > The new fsdev driver provides pages/folios initialized compatibly with
> > > fsdax - normal rather than devdax-style refcounting, and starting out
> > > with order-0 folios.
> > > 
> > > When fsdev binds to a daxdev, it is usually (always?) switching from the
> > > devdax mode (device.c), which pre-initializes compound folios according
> > > to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> > > folios into a fsdax-compatible state.
> > > 
> > > A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> > > dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> > > devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> > > mmap capability.
> > > 
> > > In this commit is just the framework, which remaps pages/folios compatibly
> > > with fsdax.
> > > 
> > > Enabling dax changes:
> > > 
> > > - bus.h: add DAXDRV_FSDEV_TYPE driver type
> > > - bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> > > - dax.h: prototype inode_dax(), which fsdev needs
> > > 
> > > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > > Suggested-by: Gregory Price <gourry@gourry.net>
> > > Signed-off-by: John Groves <john@groves.net>
> > 
> > I was kind of thinking you'd go with a hidden KCONFIG option with default
> > magic to do the same build condition to you had in the Makefil, but one the
> > user can opt in or out for is also fine.
> > 
> > Comments on that below. Meh, I think this is better anyway :)
> > 
> > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > 
> > 
> > 
> > > diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> > > index d656e4c0eb84..7051b70980d5 100644
> > > --- a/drivers/dax/Kconfig
> > > +++ b/drivers/dax/Kconfig
> > > @@ -61,6 +61,17 @@ config DEV_DAX_HMEM_DEVICES
> > >  	depends on DEV_DAX_HMEM && DAX
> > >  	def_bool y
> > >  
> > > +config DEV_DAX_FSDEV
> > > +	tristate "FSDEV DAX: fs-dax compatible devdax driver"
> > > +	depends on DEV_DAX && FS_DAX
> > > +	help
> > > +	  Support fs-dax access to DAX devices via a character device
> > > +	  interface. Unlike device_dax (which pre-initializes compound folios
> > > +	  based on device alignment), this driver leaves folios at order-0 so
> > > +	  that fs-dax filesystems can manage folio order dynamically.
> > > +
> > > +	  Say M if unsure.
> > Fine like this, but if you wanted to hide it in interests of not
> > confusing users...
> > 
> > config DEV_DAX_FSDEV
> > 	tristate
> > 	depends on DEV_DAX && FS_DAX
> > 	default DEV_DAX
> 
> I like this better. I see no reason not to default to including fsdev.
> It does nothing other than frustrating famfs users if it's off - since
> building it still has no effect unless you put a daxdev in famfs mode.
> 
> Ira, it's kinda in your hands at the moment. Do you feel like making this
> change?

I don't mind making this change.  But we have to deal with the breakage to
current device dax users.

https://lore.kernel.org/all/69c36921255b6_e9d8d1009b@iweiny-mobl.notmuch/

What am I missing?

Ira
