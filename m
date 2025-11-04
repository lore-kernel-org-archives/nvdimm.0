Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11DE70809
	for <nvdimm@lists.linux.dev>; Tue,  4 Nov 2025 20:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762286603; cv=fail; b=GO714gAR8CIPLWHttKkEXX53psX+z/om3QVGuV+2XyTIDZ/PsT8LrpZ42X7cTzK0YdwB8k6ytvvKQDPaJm8nYy6RUJqOswJxKnPzbgXnOQvyMRHx4Q+8EaCeLILef9fuREFrXsaH4vN/bsywkIl63/35NnCfGkCj3VKFI1p/fYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762286603; c=relaxed/simple;
	bh=bYtNBqztVQU8JBv7du2kv4hFmtVgd1pZmO9Y45rEsic=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dze9d6+/91iljKR/pYxMjqV+ocXgJvBOIB1TwHSrED3Xk+bwEjibSSX0yKDY/ibWjyxeBdbQPkB84DGzs3L2JfwLXxCUMKdZByE49WLvArS/PsYvM+Zoxc7rHrf1V9Cb2+mQQXpzb0j5Urz1oyEGa58M0un+yNjs57Offyg3Gas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yi4LFUec; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yi4LFUec"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762286601; x=1793822601;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bYtNBqztVQU8JBv7du2kv4hFmtVgd1pZmO9Y45rEsic=;
  b=Yi4LFUec5pWJWXI8Vp/CB9Kf9Yxc8rxkFsH+6aae8PHpz/2LOPMJ9Ctk
   kLYvywlMD0Nmp8+HUuBV2sked09N5Ary5f6M4uqKFMRZ+ElS+0Pq/I7au
   ikIR1JIfsk6CnqO/vzbjooMeGROoV0A2/bRRZG8itB3im7R4C6f057Uaa
   t+8GHbiYeTtaQFuERzlwpyz1YDoo4KFFpKgVi0xaAQtH4rgvaSlj5UfRu
   a719BRSvms0ggNFbyWh9l7ozsQUxoiUG2aleSQ5tb3dBosSMJJywdLMmH
   M2YgCKX9fUbKTjxLyLVD/oueVQ0jVnB2FwBzpPUMYJMsz3f2dqh9l61M8
   Q==;
X-CSE-ConnectionGUID: WII0kyeYRl2HYfVJkzeoBw==
X-CSE-MsgGUID: HTHtvbR3TQ+6iKBiplfzPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="64309080"
X-IronPort-AV: E=Sophos;i="6.19,279,1754982000"; 
   d="scan'208";a="64309080"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 12:03:20 -0800
X-CSE-ConnectionGUID: ENdXLH3kQxCVdFTJk7je2A==
X-CSE-MsgGUID: C2VijjspQYGlaKYW5r1zxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,279,1754982000"; 
   d="scan'208";a="191605300"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 12:03:21 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 12:03:19 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 12:03:19 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.26) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 12:03:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UcZbl1jocjE9ZEndI0bvjCAjn+COKid0LoMJjwutaviJkRN0Sltvjwhgc5qYHRHtthP0YsKrygNuFydMPg3sSUDJf0hjmxfBROAzz92riXvypE1d92FxdVCcbwCQeyEf4ICMSXiYuiZpl/hOrWv3x8/dJhxfk9Dunv+taUzbxcJZqFKZRVeY3f1QsBk1Oq23gpV17Ic4ZEGy15L5zc5YiWXlbYfkuA35mjpxOUCSnfINVPXzx0NtH4CihaBniJi6IEFdnyItE1XurhVIW9rS2qW8M/upZKxJxtwmyFBQ/ntVzOYaF3ULalOqdrFSg9FtyxdgFdJNrCI2rw+LGIuQJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0e1hRBIGuGsXyUAu0U+mh1drgk2UFKfoE+dx1D5TXNI=;
 b=AxlalUe4rUHsv+DpaYeSeYIUjz6DTfd27yZka1JZApgaBC8dVE3yNyruSzp1fs04v6AphzX3XQnI/GRQbFISpLnIaYVTTkGcA70D2b9FtcFHf8odzLrCbonuHnCIucOH/tPCPzkCEfOY0/6NNAo6HbZSwln3beHp7lVLGxSYFbDj+A3uOg0fpT1wMlpOg9IYeNeqWMklPpqctGww5Y1fbsd8754N9pMVAkZ2zZpmV8iIS268IP8fakl1UObdV1ZBalRAckX1rPqT8QTITwhdh91w8GlJpezdi3aAfTCxk2Q8NnLJUAC5eAbd/uNEvPoTsSHMNfP+SWkASc92oE6Ggg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DM4PR11MB5328.namprd11.prod.outlook.com
 (2603:10b6:5:393::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Tue, 4 Nov
 2025 20:03:17 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 20:03:17 +0000
Date: Tue, 4 Nov 2025 14:05:45 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH v2] tools/testing/nvdimm: Use per-DIMM device handle
Message-ID: <690a5c98f1aff_26a77f10095@iweiny-mobl.notmuch>
References: <20251031234227.1303113-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251031234227.1303113-1-alison.schofield@intel.com>
X-ClientProxiedBy: SA1P222CA0049.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::26) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DM4PR11MB5328:EE_
X-MS-Office365-Filtering-Correlation-Id: c10f7014-71ef-42c9-b11b-08de1bdd31f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3Sty8V9fuVE6Tct5O2wAVpHNNDdpyO6UDuMgyBC7lgmmtnnvfsHDO2NGvPPi?=
 =?us-ascii?Q?t5lhKpVvCl/b7BJ6j6aErOnfjGMEwOjwbo6z95r/ry+uOkmXvK3KMfGS9BQj?=
 =?us-ascii?Q?4ENbcVGwD5v1tIuc9AGRL/6glJbVPxnhSX75IMwlexwRaPrRTnkhLkkJiE9W?=
 =?us-ascii?Q?QKwl9EEd6j1gUpGNfxv/aVPzWApcjEIjvo99cj/5E0SuK7F/nC6kS4NsC2x3?=
 =?us-ascii?Q?rupMyyMCJvTxxAwEJ15JsV5J/vBA+Tv+hQbBUUkxgDXl50mpXBY9V3Zvzk5E?=
 =?us-ascii?Q?oWA4lqDVM4UIWBZT1gtWFXHgsV9NSvQ59+E+fBjuSxgUxvyzG+H2Iw28r5P7?=
 =?us-ascii?Q?2G9qnq6vnTEEsSAvHZStGa8XWRX/cEOMzmyEzIGmjeC4+Q45nAeXr3+FTXSU?=
 =?us-ascii?Q?w9GNes53djgmqBxxvdgT9peCLGF+hay50h86MVikYLht5RpPKNMExxOBiMNg?=
 =?us-ascii?Q?A7JV6p0O4+xWOPg5akJkQ6WDzxHc+5dvgoeStUfX7UOAupDdA8bMwrzIAxwY?=
 =?us-ascii?Q?Hznh6aXDiquw/Ihe2a6W/aVeon/o1x5xIe6Nk+9z1zjZ6D7oMThasXothqJj?=
 =?us-ascii?Q?orEV6TrGa0/mFie3rPhb15LznFsLvIhJt3TDQXeJk3PDwSnxPxm8Ja4IzJQL?=
 =?us-ascii?Q?iFtA3M6AO8pmq7sbTWA/cbx+78kU61O4HFZmFOXU28q/GtTDgewAdK5iqQ66?=
 =?us-ascii?Q?hjfp1omk/zKf5CeQCnqk2r5uzmZMJDQum/jzeO4VCxa9hYTWGoPLXUNuFxi/?=
 =?us-ascii?Q?MZ+bKilMOFbbYDA4HVmEMn7NZqZY+u267oOirYywPI7rEB0nG7tu8BZZOYJH?=
 =?us-ascii?Q?sRHCI1IIoBu+nuPAyRSQV+LNQe+Ybvog6qyOXBIwQuHR9drhGaE1Ms2egPLj?=
 =?us-ascii?Q?YYVINJhPDjDCnNHu6ZT+B5BpKNxdZ6KWGb4WRneoDz03A0kYAmcYOZk+IViL?=
 =?us-ascii?Q?mFTJNJDdKSM96wWz90/Nnh2Hm2Chx8ryzjfZfvBo9N9vxUn2fn7zErr6kAwJ?=
 =?us-ascii?Q?sJoPPWodlajXc8qlkjliyXSUEzt4QjzHoMCkDqBNo2uEOcW1aiOXuYJtneXQ?=
 =?us-ascii?Q?L6L2aYl0QvACauh8zLVMTCtGw+EZ8rXAx3FpmI9qvDGx9RC55EKMLVK6UsdZ?=
 =?us-ascii?Q?CsSFP/2wCW9Seh6v4oZLu4koD+PyA1+eFYiBNTcfLgFWZ8vncVO2wdNZz874?=
 =?us-ascii?Q?91f2vuNEd8ZLxWpXI/G9SnqynuZsB7QHy3nbm9qSHr6s7jVdDvgONY3Ket9h?=
 =?us-ascii?Q?Nm4KsGIO/on3CMSa3KsvfYaFCGsh65jPz8JZY5noj4Z4rGZSh1v2NShD83oX?=
 =?us-ascii?Q?3HB2w3TdZxlHFgKczLnl1zIaFdvGtm8mpkjkouShfVB80elfBCAAw8yRKUMC?=
 =?us-ascii?Q?YCgL52S0T5hZ1pGR9kJrbxDcBNR560OWQT6VjsqvxjpG/uvfDV6Rfk6JHLOH?=
 =?us-ascii?Q?ZsCrpmta0mzUGa+EN+59sFygH4pU6Hxg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q7Uj83/HkB+/B/01oa2qf/jjcNTm5jPMfoS4BeNiL7ymEAGz/1U+a/8uyxuG?=
 =?us-ascii?Q?SUrqxzrWXyLC146lv5L2UUtVlcsDNOsq2XSsBZWSl5V2c20hbY61U81QUj5x?=
 =?us-ascii?Q?G2pb1qyoUDnyY8LhMcOYQnR8GD8q8JnBzyD+P0FyW/2/2YK/gK8FCS4iGLei?=
 =?us-ascii?Q?FDARfKdcs8hTj8UnKq0bYY2HCKTCuOKTgpHW6FsBYS/Fq0aWkHvWN1HFLFz0?=
 =?us-ascii?Q?8FZyMp62p+ffqIWF+IZgJkGbBAorMw7lQPKCUK//0z9IVLsFlHYM/rTTcnWC?=
 =?us-ascii?Q?4P/w/E51OO4DDUSToJXCfqZBaptwA7D7vgpx68J+qUVRU+5d4cmKUW46D3kE?=
 =?us-ascii?Q?xTJXek0geWigGgk3FNpsxspF3zCKBQXY3N2l0xDE3kBHadFBbSQLSqSYztmk?=
 =?us-ascii?Q?MDv8LoBi6C9L4+laWfnaBvwirg4FH7MWiOxv0UHYW2VU7kmqJj8QS6A85IKE?=
 =?us-ascii?Q?vLsUNCRsg7hTwwewXmTH+Bqh/UirSrtNYoZlKhY5l0yg/kxAt8lXgPae0X9v?=
 =?us-ascii?Q?bIowm29uu00qCJ2r+lkygIawTqC7IC/e/yZfqzkuuY2fcNRnjxJSB1by17zN?=
 =?us-ascii?Q?nHMexDKkNgxmhYnfVcf9tiUEP5z8P5hvuSjG3AsVHOWRW9QId4JwT+6egKEF?=
 =?us-ascii?Q?GJVbd7C7+n/9BAnBiAA4rGXwssG29QnuQVxcz8OEWIbtZOCRkKuyDPCssH/D?=
 =?us-ascii?Q?7jZq86Nr7cwA+2yKpClrx9m4SCowPfPxdhZM84qF7QchB4k5vKLnbMHfNunh?=
 =?us-ascii?Q?g/e5ofNeNZrRcr18RqR0a4H6OvWBW3lOH7alWbsDf4KpU8hSJfYdOpcJ4QUT?=
 =?us-ascii?Q?weWU3kB/mMqrorzRs6pZDHBntf61F/9AOHheiOGnlWgIyqzwAcRDEY/g5Qyx?=
 =?us-ascii?Q?VRawWU9KDI0Vg2CdTKTGQHvTMQftJLcrzSiG7Rq58/17aYbF4MJ2G6Yol1ZY?=
 =?us-ascii?Q?NNxd4cACjPaMMoSz6oH30lhXorqjqgDUIKf0xpVVVYrCaA+YclUGbuNPYxRv?=
 =?us-ascii?Q?bMfS7gOKQCVyr7yMBXOWxpY/Fp5sXqGEyglRf9vJ/eCx1dijtm3ZeTsK1gED?=
 =?us-ascii?Q?7Y26UVfoKbBXQfNmjSme3RIdJDHvxECOegrJRDFSsX347fpEFCsMUXpXcvUE?=
 =?us-ascii?Q?FXJ608Xpl6mSwB04qCjNISohw8AuDtK5/bNgXooqVwq/v7R7kXlxJGkcHl9E?=
 =?us-ascii?Q?2PbguMhJOtnBcQ4SbEq/zIsioJzaXdPngJEVV14mtg7KP3bV4yfZ4zuLYdhh?=
 =?us-ascii?Q?aETIJvsrBLpHl/D6eyTuItIhkjavQFZDO1o1tqfbTV+lwnzpr394UITBZi11?=
 =?us-ascii?Q?EKiNqGoAfs3pfyRYPfCiSlvCvWCYdmFmHjopLqGte7lVmcCPctg2CwvWxuXW?=
 =?us-ascii?Q?YLVHStPMUxAtE5TfilioGUR8RFVE+/9KHdufQTAra6ZavIl2tI1oIffLyJyH?=
 =?us-ascii?Q?oskpkVd+B9TG5zW7LKWIALjLSsvoS2b+o2YEHPv3UJnmieTskC2Q41zyh7ZO?=
 =?us-ascii?Q?VW69kL7MU8QiVu3KUyUzgpNjZWz//D43CG+fSEwDwdqLyafa+KKDLbdtfpkX?=
 =?us-ascii?Q?NYK4uCPhCWNIXAV9o33sdE9MrScfVvGfJNdEEWnQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c10f7014-71ef-42c9-b11b-08de1bdd31f1
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 20:03:17.5799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CK2Fyc0Tkt3H6inhjDkoxGEe3eYVq94sOyP769p8lx/fIvoN9KMwokFcMKHFqKmSYS3TEtN7vkJVhudY4dqYhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5328
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> KASAN reports a global-out-of-bounds access when running these nfit
> tests: clear.sh, pmem-errors.sh, pfn-meta-errors.sh, btt-errors.sh,
> daxdev-errors.sh, and inject-error.sh.
> 
> [] BUG: KASAN: global-out-of-bounds in nfit_test_ctl+0x769f/0x7840 [nfit_test]
> [] Read of size 4 at addr ffffffffc03ea01c by task ndctl/1215
> [] The buggy address belongs to the variable:
> [] handle+0x1c/0x1df4 [nfit_test]
> 
> nfit_test_search_spa() uses handle[nvdimm->id] to retrieve a device
> handle and triggers a KASAN error when it reads past the end of the
> handle array. It should not be indexing the handle array at all.
> 
> The correct device handle is stored in per-DIMM test data. Each DIMM
> has a struct nfit_mem that embeds a struct acpi_nfit_memdev that
> describes the NFIT device handle. Use that device handle here. 
> 
> Fixes: 10246dc84dfc ("acpi nfit: nfit_test supports translate SPA")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Picked up
https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/commit/?h=libnvdimm-for-next

Thanks,
Ira

> ---
> 
> Changes in v2:
> - Use the correct handle in per-DIMM test data (Dan)
> - Update commit message and log
> - Update Fixes Tag
> 
> 
>  tools/testing/nvdimm/test/nfit.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index cfd4378e2129..f87e9f251d13 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -670,6 +670,7 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
>  		.addr = spa->spa,
>  		.region = NULL,
>  	};
> +	struct nfit_mem *nfit_mem;
>  	u64 dpa;
>  
>  	ret = device_for_each_child(&bus->dev, &ctx,
> @@ -687,8 +688,12 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
>  	 */
>  	nd_mapping = &nd_region->mapping[nd_region->ndr_mappings - 1];
>  	nvdimm = nd_mapping->nvdimm;
> +	nfit_mem = nvdimm_provider_data(nvdimm);
> +	if (!nfit_mem)
> +		return -EINVAL;
>  
> -	spa->devices[0].nfit_device_handle = handle[nvdimm->id];
> +	spa->devices[0].nfit_device_handle =
> +		__to_nfit_memdev(nfit_mem)->device_handle;
>  	spa->num_nvdimms = 1;
>  	spa->devices[0].dpa = dpa;
>  
> 
> base-commit: 211ddde0823f1442e4ad052a2f30f050145ccada
> -- 
> 2.37.3
> 


