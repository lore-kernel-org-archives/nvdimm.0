Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03317C2FF
	for <nvdimm@lists.linux.dev>; Thu,  5 Mar 2026 21:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772747842; cv=fail; b=iyqlRaqp5PtvRxSllQkSVyJWNsN8z3rqGtN1/OIyb7kgeK8t86rB2A4g7klSGZPtWS9B4cCnnVMM/Zif8+teQwea/y0AalbJBWow1MdCYNsEegfUOb2k9FTBda9ivLJgL7oy2JwDcMhxmu61VXX2yz1f1q10Gwja8ON10FvXNd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772747842; c=relaxed/simple;
	bh=e1OTBISZ7CBsASgrkX616eXw1MXWE49RXoIlySfDDUs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r3Tui9sZr/T2HD68+O5C6VCeAGLT2C+enSHZYKyHeWUC0GDfN8r03WTxPXfNQ2O/yuuRJ8RftiKeM5g2ecYgRDdX9r1lLCEDm+V5oHH7qUK+WRwtRh3wjY5gLtAaWZDnaxS50DMflsguzP4HNN0Qnfh+du5iJoQp2iuesIH6ipo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dxf3zO5G; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dxf3zO5G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772747841; x=1804283841;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=e1OTBISZ7CBsASgrkX616eXw1MXWE49RXoIlySfDDUs=;
  b=Dxf3zO5GVwJ1KtRlYMVAYrRCGqPOrVct5IMMxvizujekymO2iOXWx6hz
   huHvwDVTVnNvmQcUeW7yCdb3iwEG4TaxWo0BXLcx2sjMuDisa6Sdv5TRr
   +OAv+o76dcwvpI8xxYKc7v1l9v5FsT2giRSqRvHpTCudAPynVIGXaMR1/
   NaoBF2vaPQGmUtQf/JSxMV/PSGkdZB+PKOd3IIsz0u75+p3isV90QrS8O
   fa9Sv/J1zEkRQh8NMcb3VM+4o7lmVWsybNAuerkYfWZUObcyouYDn4QT0
   2uE/be9GpljRNNARFkcIMdAwJ9QsJ+Z+Fks7jROqw/U51TnvbHGIOjawa
   Q==;
X-CSE-ConnectionGUID: tlHwrLOxRge5ja8ypQVHtQ==
X-CSE-MsgGUID: zUgZ4OcBRVScUq7FojkMIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="91425405"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="91425405"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 13:57:20 -0800
X-CSE-ConnectionGUID: JbhhDLS8QEaXqOne5iLNxg==
X-CSE-MsgGUID: INbQfqTnTY2M2taBgtPmhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="218061462"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 13:57:19 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 13:57:18 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 5 Mar 2026 13:57:18 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.63) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 13:57:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zg/ap25bUM5COP3ELovxvtduwazm+yBJju7HDxb1IbKpAE4xouXU9YGddDyCF+b+8xAvIQaOdUfScrzezmv3tAIKSFFWE9SWNNohYJG95WY6ioJgvs+xABPWsvRwC5BgZjLMkcML9Fvjpf93ZwGGQHFRPNV6tfHABiIE4Geg8ngqvRQHPLkst4DSqmDA94tbmjWP1FSvW2YSLt2vtdt2GJ5QQbtTHBezvjViTGiy7g8gswhZ/PpZg5jF6u12nfsyvceELv22TCSmNFUBwSt9QcMjskpnTEX/fhkFq5KG2oPRrAEYCcYMh1YZVuLhXhv+TzQqJn60Mxp2jxIL6dvwng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKy3jA8UeW+ZQX639dAQ7IVghqwgke5cdt3dXkbvvuw=;
 b=WLP0UFgWkga1YX/U6fVwuQLpgOgjpM4+ue5LnQEvPPXDLWxB52GVIFJ6KKVQ7lA8Lio/mDRAYzcC7sUzZsOlBJaYY/NfA8rfY4ghwRHce9hQXeab7+Dt1xCnfn9Qs23W3C78bmNlllpsef9dJWO+5igXwZ2Alb8tmbp8QvO+GgJyowaXrivbrLW9HJ6RjIKiGylfTwO9KctDVR4jF9+3rz7zB0LpBz/s8v+AlfA1c8V0P9aFD6kmT1DPdivlNw6VF2FPtb8zrBk0Mpkt/eBtiBgs2X8MbhuTlE6kFl6erujx3bAyr+Jd8ZMQm8BKcTXdgS+FjGFX8q1J5WGDDKvJGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SA1PR11MB7086.namprd11.prod.outlook.com
 (2603:10b6:806:2b3::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 21:57:16 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::cedb:24cb:2175:4dcb]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::cedb:24cb:2175:4dcb%6]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 21:57:16 +0000
Date: Thu, 5 Mar 2026 16:00:55 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Anisa Su <anisa.su887@gmail.com>, Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Li Ming
	<ming.li@zohomail.com>
Subject: Re: [PATCH v9 12/19] cxl/extent: Process dynamic partition events
 and realize region extents
Message-ID: <69a9fd172cb8d_15c95d100a9@iweiny-mobl.notmuch>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-12-1d4911a0b365@intel.com>
 <aZz9qi1b1DsOETa_@4470NRD-ASU.ssi.samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aZz9qi1b1DsOETa_@4470NRD-ASU.ssi.samsung.com>
X-ClientProxiedBy: SJ0P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::13) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SA1PR11MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: aaeb46a5-9fcd-426d-bb30-08de7b022a15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: ougdNjZUfyuxzyYJXTKzTe+e3w4VUUsPVDLKihr5P7p5uW0zXZv4n5cZDvuckejGNXnzB2H6ZpwFZUV9YZn6hsB13dc3h4B9hEFk1iD/+Lbya7URNeL85mEg7mWPZe7UUUU9FOJxul5U4fNOvEULW7WEQv6QBq55YAcwbAuU8cGHvJZC4vfPx0ilaSlYrtoeBjx183rGAR9uDdUeRdPU0ykPCGlMjbR+FM2OmYhp4DBmKJKu4tdbLmKptOnjvD/2F5WVTV0OCxKX39w8e2VNWYpbGmsX1RBEGlZIKT35D+sTjQ8Yo6iwVE94Wo0HxrdsBvFSMPO1Ne9XSY+QgNoOXW5uStm8PVV1djB1r/CroPTWF5fdePsZNoLeomWz4ErgMZXKDQPBNTg75SrPwIw1B8GTjkuO1zyFswjRBb+pjHYon4tmOWfJaVacRnPn02VUMjznEfyDDpIbbgdAz+4bstw5CCgTVzEpT7DF9aFPZCBhEAram6P9bgf+xCTBrJMNZKbYepfRz2aXTOuFQhfaGmlYRQv6bQOI9paNuwN7ZDOlRlISyvrF9OTIxAAFui70eJhtp5gL185inckwqGNNjSigr2W1bbfLZ6tvwbZEv2aENsdYLCIvq1vbX3kyb4EriP2hHhFXPns7cbV7RiOyG6Egh4BAKHCrXn87Ta/DkAqp9ohibxmQd/2G+R77/WFsWWlsC+tF1ZWsdUEWa2Es6xiEeXOfudv56WxmCk4FnAA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2RfS1KP+oEZ7/1agpVhxxOU6TE9bikjpF+K1RiWuWL4a8+TUkObQxpS+JMiX?=
 =?us-ascii?Q?YQ9P3PQXHfcaE3MGtBrHpk/+pyecTYbX2cxz9MUJz/JzoIhGBanHpTLpI4O/?=
 =?us-ascii?Q?Cr24iEyub2cIhVtzVq29UUoM5hcjEiDrtsXRdQxLthWmr49Hydduu76Y6fVd?=
 =?us-ascii?Q?22hwVcxgoNLUpTPS/a9wD1yGYbsv5htalExBaq5BTyxMirvQTtsMGfa8Jlo3?=
 =?us-ascii?Q?RnfwcCBzj3UYckfJ4AGNKvxh002zSgPVyb0sOcbch9qXWU8AjkYX+dtMOJtq?=
 =?us-ascii?Q?8JvtBx2dqmdnB1zYH5whxZpLnEWFKMoGIb5mkCVspz1njBQjrcPyKAkkO2/M?=
 =?us-ascii?Q?Kldl53MGvVnXjA86hMIPlY7C4TNBs6gaiCcn3Ah5z7ljW6yipYaRApMt8u/t?=
 =?us-ascii?Q?zvvgXasUKPV/2+cej0KDxkWahHIEQViZvF9pyqNw/oQJleWx8WMrMGh1fqbm?=
 =?us-ascii?Q?hV2IblYHvFcmYz5xBPIgGkbVYx7/CvnGl1dElKnuNn0Ntz5KRbw8BAEdw9L5?=
 =?us-ascii?Q?nTtXn3x/Ve4zL9hT9DyYGL4n7yi/gDmm+SDbayDimklr7zd/RVwcvniaSBDv?=
 =?us-ascii?Q?jPvACIyN8YDkArY4OozS+a5eWcyVqb8Pfd9SH302VFrD5ufYWh7iGGrAZBPI?=
 =?us-ascii?Q?6n2T3L6nZtZ6a/vSeQ6gDRPq/2apqx8pIwOWGQ630TElZCKiKCcXIRl890UN?=
 =?us-ascii?Q?kxPiF06sYRwBJGfg24RicFF3UVGbisjrV8cu6mMQlnWShbdlokdtqLH6ZZcE?=
 =?us-ascii?Q?PcMApNaxr4E8g6ZPkAHkZJKBxgGO7B6hRg1k1EwsdhuEcAfhEgeMpi1IN9XJ?=
 =?us-ascii?Q?KSEeWKmataTOfgHbNR8y5gSVbG+2b57i4l719JXeOScYioRNe7I9dagN1kKF?=
 =?us-ascii?Q?5Mqyy6pPb1UFOhHZKScLxx7wWBFjvOTG6V2LQb0nvvkwEC7RSD84q/HevKsa?=
 =?us-ascii?Q?TsdZdN2TheLTutM4v7EfBTxX5qJW6fyAZMoqJcdZJ5mG0Npo/VpidIs7C+o4?=
 =?us-ascii?Q?p/XOmYW1opNb9JADI2N0Ir8rYaM5xTdVoiUmX++dikrtjhD83etIDZ/Dj6Ms?=
 =?us-ascii?Q?CXy3uI0Wz3RXNRJCv0xNAP+TiPqa9OKPyyccHLhdl7JZS53Uy/EBpVCBnvXe?=
 =?us-ascii?Q?WxjFLiBVOeXkPZVelQKl7Re5h5FFs7HvhbPxViyFcWvdgsAq6FLzuibiLQit?=
 =?us-ascii?Q?gUENGcWWYD2EoILWb6vfwnJIGNM4qf/KSoHKIFIZfMZCih0Wy6TUBqGxNxO1?=
 =?us-ascii?Q?XDXh6OQHQoTjsszebSKhiV8gnnEdJ1O28fEKaQG4hd9r5jp9iExsfbcEkNEi?=
 =?us-ascii?Q?Qp0TzwMId6YUK4lAUoXyUc0lWq1oYreSED7YRjFPRN2zfbjNBH1lm9A/P2ay?=
 =?us-ascii?Q?lzjCpIg+WFUWjqfwdapkw0qNJQfC6Jf7RqoVvc9/Y8Lex+bpb3C7Nub/I8E6?=
 =?us-ascii?Q?oAe9NGry3MXyWqxi7U+eQUxNoZPCPU3rLow6x4NeW5yU5p84JEBtMIUoXO+B?=
 =?us-ascii?Q?IbIk1BPsxiKfekgwSYVWmNKG3LEzYFQXcrWJeUU9vx+UaycXYa0WP4vaPox3?=
 =?us-ascii?Q?9kdc4b3zhvoHwQKG1KSQ9cvLz0+OlunSHhtJnEyaf94PDO+sREPZ5L3zkNNf?=
 =?us-ascii?Q?siPDw4PIqP4qX/Yv9+DFF/AXGKXdgW6fFfm9MBq8/b3JnGEwRj+cvwxZTL0u?=
 =?us-ascii?Q?umfimCN3MiEbicRNrMNhfh/6GkK8585S9Tv8INaMtNDfkJwQjSGzlGySt913?=
 =?us-ascii?Q?pCgwby7OtA=3D=3D?=
X-Exchange-RoutingPolicyChecked: HvfT/f0QTwbMlj3FPgZbTrtnNil384MGsORrxA9kSFJtS/SFlSRZqsl92sSrXnuI4vew6GpCjH5xpEhuRbK+LHVSBG4NAjdcW+Vh/EiAgvmK+sUHEHlNLsoxvaCguRIOA7AF9JxmPJHqhum1o2QSZa1lmaFUkPAuWG674mlHZbt+wWIR6UkTnPmBld0Ser7YmFSojTQ1ETIW3cJFq64vtjNZDdYPpmQMKhDvn0j8Gv90Itnoe2Cele9TwFk7Zw4hY1YDrqF8z7OpOcVp/x1Nt3/+OagAXkPxJtE0XZp4NNdZf6vR3kr6u6lq58OSu4OEvt+jyQu93+0Mekni2xK53g==
X-MS-Exchange-CrossTenant-Network-Message-Id: aaeb46a5-9fcd-426d-bb30-08de7b022a15
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 21:57:16.1851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5e6+IKH2FkRemkfdAewxzZZQpChs/wCjIa3cviauifjVCZUqnNQ0s53NpX2389vXCPfUk9FD1jpRnGL+znFHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7086
X-OriginatorOrg: intel.com

Anisa Su wrote:
> On Sun, Apr 13, 2025 at 05:52:20PM -0500, Ira Weiny wrote:i
> A few notes while going through and removing sparse dax semantics and plumbing
> for fs-dax mode:
> > A dynamic capacity device (DCD) sends events to signal the host for
> > changes in the availability of Dynamic Capacity (DC) memory.  These
> > events contain extents describing a DPA range and meta data for memory
> > to be added or removed.  Events may be sent from the device at any time.
> > 
> > Three types of events can be signaled, Add, Release, and Force Release.
> > 
> > On add, the host may accept or reject the memory being offered.  If no
> > region exists, or the extent is invalid, the extent should be rejected.
> > Add extent events may be grouped by a 'more' bit which indicates those
> > extents should be processed as a group.
> > 
> > On remove, the host can delay the response until the host is safely not
> > using the memory.  If no region exists the release can be sent
> > immediately.  The host may also release extents (or partial extents) at
> > any time.
> Partial release is no longer valid for tagged release iirc from the calls

Tags were not supported in this version:

        if (!uuid_is_null((const uuid_t *)extent->uuid)) {
                dev_err_ratelimited(dev,
                                    "DC extent DPA %pra (%pU); tags not supported\n",
                                    &ext_range, extent->uuid);
                return -ENXIO;
        }

> 
> > Thus the 'more' bit grouping of release events is of less
> > value and can be ignored in favor of sending multiple release capacity
> > responses for groups of release events.
> > 
> [snip]
> > +
> > +static int cxl_send_dc_response(struct cxl_memdev_state *mds, int opcode,
> > +				struct xarray *extent_array, int cnt)
> > +{
> > +	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> > +	struct cxl_mbox_dc_response *p;
> > +	struct cxl_extent *extent;
> > +	unsigned long index;
> > +	u32 pl_index;
> > +
> > +	size_t pl_size = struct_size(p, extent_list, cnt);
> > +	u32 max_extents = cnt;
> > +
> > +	/* May have to use more bit on response. */
> > +	if (pl_size > cxl_mbox->payload_size) {
> > +		max_extents = (cxl_mbox->payload_size - sizeof(*p)) /
> > +			      sizeof(struct updated_extent_list);
> > +		pl_size = struct_size(p, extent_list, max_extents);
> > +	}
> > +
> > +	struct cxl_mbox_dc_response *response __free(kfree) =
> > +						kzalloc(pl_size, GFP_KERNEL);
> > +	if (!response)
> > +		return -ENOMEM;
> > +
> > +	if (cnt == 0)
> > +		return send_one_response(cxl_mbox, response, opcode, 0, 0);
> > +
> > +	pl_index = 0;
> I was wondering why xarray is used here instead of a list? I didn't see anywhere
> that we need to look up a specific index to benefit from the log complexity and
> afaict, simply used to iterate over all elements.

xarray was just easier than a list.

> 
> > +	xa_for_each(extent_array, index, extent) {
> > +		response->extent_list[pl_index].dpa_start = extent->start_dpa;
> > +		response->extent_list[pl_index].length = extent->length;
> > +		pl_index++;
> > +
> > +		if (pl_index == max_extents) {
> > +			u8 flags = 0;
> > +			int rc;
> > +
> > +			if (pl_index < cnt)
> > +				flags |= CXL_DCD_EVENT_MORE;
> > +			rc = send_one_response(cxl_mbox, response, opcode,
> > +					       pl_index, flags);
> > +			if (rc)
> > +				return rc;
> > +			cnt -= pl_index;
> > +			pl_index = 0;
> > +		}
> > +	}
> > +
> > +	if (!pl_index) /* nothing more to do */
> > +		return 0;
> > +	return send_one_response(cxl_mbox, response, opcode, pl_index, 0);
> > +}
> > +

[snip]

> > +static int validate_add_extent(struct cxl_memdev_state *mds,
> > +			       struct cxl_extent *extent)
> > +{
> > +	int rc;
> > +
> > +	rc = cxl_validate_extent(mds, extent);
> > +	if (rc)
> > +		return rc;
> > +
> > +	return cxl_add_extent(mds, extent);
> > +}
> > +
> > +static int cxl_add_pending(struct cxl_memdev_state *mds)
> > +{
> > +	struct device *dev = mds->cxlds.dev;
> > +	struct cxl_extent *extent;
> > +	unsigned long cnt = 0;
> > +	unsigned long index;
> > +	int rc;
> > +
> Also according to the spec:
> "In response to an Add Capacity Event Record, or multiple Add Capacity Event 
> records grouped via the More flag (see Table 8-229), the host is expected to 
> respond with exactly one Add Dynamic Capacity Response acknowledgment, 
> corresponding to the order of the Add Capacity Events received. If the order 
> does not match, the device shall return Invalid Input. The Add Dynamic Capacity
> Response acknowledgment must be sent in the same order as the Add Capacity 
> Event Records."

hmmm...  yea that might be wrong, I don't recall.

> 
> Using xarray does not preserve the order of the extents, which requires a fifo
> queue.

It could if the index was the order.

But in the end I'm not opposed to using a list.

Ira

[snip]
