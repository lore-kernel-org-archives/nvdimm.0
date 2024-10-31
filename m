Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DF31CDFC1
	for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 22:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412983; cv=fail; b=r8aCMp/M+4NsLwbr4B3t6g74f/jXDDx0IAD3LqQPxNVJtaJ1dE4Vzkgq/Bu3TECfoT2SbFPAwWaP0hc6W3zLqUQ5YcMq6dNJIfZNkIm307ApSBICTGrXBJZBetVUcjIgb6l5RsrA5jfG8/Ivvg4pZgDAnCWUbRSt1qynswaObOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412983; c=relaxed/simple;
	bh=pLTzKIOmUsY44Z2+v6madnk1WFF64LMmrW83fe8m7+0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QNeejjlXwprOSzPY5YqwUIutYX+Acm2W1vkCdKsQBUUS6DKFxABYNc4Eq36NaLOLUYNbKtfKPTLOeOk065LctPlk7I0KX/jttRcyyUx0yKQRkij/nxfOaHosvDggLZWCWmfR6NSfAkIe2++9XlbBCQrw3ha0r7T42WK84DzPHFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=biDyVuWT; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="biDyVuWT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730412978; x=1761948978;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pLTzKIOmUsY44Z2+v6madnk1WFF64LMmrW83fe8m7+0=;
  b=biDyVuWTGFfnK9FtpYiMgF8KkyjMJIHZZAUtV4a2qhaOTIm8vDeyIs6e
   D5eQxCUJSTvQJ4qzHYA1f2M18dsRK8Mh72PYaJZewK61F45bYGTy+K39w
   P6mI+z/LQCVPM6oRoc8yYDQtkhR2AduCbhKzkTO2jtShwtsMs0She8RO7
   gSMOiYCWo2y1kN94Om/yPN0WdB7sor5gjC5lELbE94Z3rlXk+tgsVL7Pb
   yDk36NGF+lcE+gH1YqCgOtbBkX1ZbN93ZvrFlIEqg4y/QYI052LoJfsve
   ymGEb3I5Soie7jaoa6IkiWFJtYOV+klrdF/9ncHsddJFqJR1jVj03dH46
   w==;
X-CSE-ConnectionGUID: 1uoXfMzRQz64qq1QwRQYug==
X-CSE-MsgGUID: VRxZNzcZRxK81Z6v/82+BQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="33010596"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="33010596"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 15:16:17 -0700
X-CSE-ConnectionGUID: pBRE+vd7SlW85JHkDLBnVA==
X-CSE-MsgGUID: DH62cweFQ4WLaXU6mHAeTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="113558658"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2024 15:16:16 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 31 Oct 2024 15:16:16 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 31 Oct 2024 15:16:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 31 Oct 2024 15:16:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LWXxnIRiklO7fdsuMRF3ngzNYRqglzsEW921i46aGLOvTy3J2t/DeOfr9B0T3jE7q81VHraTJG7E8RR7vdiMRrWFCLgINtQjuc14ctCee3MG3Sua8+IyL8cuJNbOzF4NaX38iTMBXiaU3TWB5FVNucI5shHwvylvSbK1rYz9Qt9zL9bLqMh4YthG6xolnArfRrFEUo+Pb4Ja3TEhisMioH/9wJSLvxb+7y3t2Q382iHloCubXH1odLzXM7exjGqZLswflPa5nM1iKGP5EMa65Zm/a464vXY939DIcJ0Uj0iFAEqHVcAoKqkTIcehAnsVk7CAB7KlNHqprcAgt3kldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wVztJBQM1aizBh8Q6zR58PO09M9PdtkBfCS01rwnSr4=;
 b=Oc7fYdV3dwquZky64lrFkhH7oG/Mux/H1BXCkKvtJ/FGrwIxOKuGA1d6QB1mS4coTGbCPwG11CvZ+KUIiC8Njy3fopfhgbSCkF6H8dkIHU92MWt6KAT+hm53UpODSRq+pgVTqOod1kziw9O8jQw7ALJhudmt5mTAKwySh1U79OZJ06MMi8YKjZlU3zJsQDbjptWyf2pylZTNlNskB6YJ3yZa2VEZczKEZ/WzK5CMX46F9ZMp57RDwCwLlSr8vl5CdnkxL/+fFZakLlasJ+viT2VO/uICb/4u2HRNUbT0WbTUGiWESGv9xVe1fapf+Gd7dIPLwJc6FBtesflL3qGvcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by PH0PR11MB5031.namprd11.prod.outlook.com (2603:10b6:510:33::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.29; Thu, 31 Oct
 2024 22:16:11 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 22:16:11 +0000
Date: Thu, 31 Oct 2024 17:16:05 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fan Ni <nifan.cxl@gmail.com>, Davidlohr Bueso <dave@stgolabs.net>
CC: <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Kees Cook
	<kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
	<linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v5 08/27] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <672401a5ab2de_8a670294ae@iweiny-mobl.notmuch>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-8-8739cb67c374@intel.com>
 <20241031013441.tsuqkrbqbhwsv2ui@offworld>
 <ZyOplknEK6XkqE1Y@fan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZyOplknEK6XkqE1Y@fan>
X-ClientProxiedBy: MW2PR16CA0048.namprd16.prod.outlook.com
 (2603:10b6:907:1::25) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|PH0PR11MB5031:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cafc2e6-2ff3-43fe-7a09-08dcf9f9a02d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?653GF/EU4P2QGIr+3qN6gneFyqGNFh557OhAE3T/oA5tr3yV05/vikrgUL/E?=
 =?us-ascii?Q?l/czK0j1aE6Y1TmDlp+SBzBIdwIJsNvSni/HvznPMjdZbVDqXU6ILcsf45FP?=
 =?us-ascii?Q?DdJGWc9prBLaI3Vkg+IrnOZfvHAxTubX5vkgLKE8hiWB8/aqKJr4B48XPPZg?=
 =?us-ascii?Q?88tg3qzxcfMg9AVYArXaeiVPNA2PNcwMofPdMF7OMUqekc+b8jXrQlfyoTOG?=
 =?us-ascii?Q?WvL2vAs4PFB+8fIv2HfETMXcaFnB6QCEHXWfPaMi8oORGrTCiJHtkH726GHe?=
 =?us-ascii?Q?dhq3DfqjV+qyeFDSZrcR/FLgYHFjCNLTrBZQtv7EYF8nZbFNvHyUIwEW/PfL?=
 =?us-ascii?Q?N1qIPXpjBPpSsxko6x1qUKrIqw+0P0MLffiqAQKRT/VHC6W4PrCwkcDlZe4a?=
 =?us-ascii?Q?MoNhEARvemXP22h4quBhpG4U2ij/eSlCEcF1S3NJuBvTV3W3ddBD71mT29QL?=
 =?us-ascii?Q?EJJgVLrHr43IIZ12erZCdX+GP6BqUorKlWCMdao/kmH7ueFsT4rsnYtk2lXd?=
 =?us-ascii?Q?6RRsCFcF/h4CSzOEU9K7PpeyoRoavs/Dr/hNGrNeRorY2JxVjER9UYJBeTO+?=
 =?us-ascii?Q?vHzY7kWH4ZfhWkkBYiRVlXjmny8snW9kLITtMPZGnZZvdE7rsS6+DxfZhWvc?=
 =?us-ascii?Q?ELzowRMZSdOHixrgBLo9pzRQvZm8qitgH4AOUgYd9lJmRmcETJMlEygWnSLH?=
 =?us-ascii?Q?0FRFpUYtiVvaOZIT9oajz6ViAukH8lsj/XJrXFcbIrUkDoAuZdjlauDcbSMe?=
 =?us-ascii?Q?GTb41slp+UVedZnXWG4OavsakmEiRbP6T6M9o365W1CJTJCoJq9Sr1NsKN3U?=
 =?us-ascii?Q?7zOK59+JceAi+Tvd92PJRcR85Q1bZ2Vo2eeEYowZtqi2GSxkQKpYqZWK8SZB?=
 =?us-ascii?Q?LtWJ9/VYvdjr779F3n1T+pVArY50/UrZTj4GBfzeUX4fBfsqGe1EfZv9Qfx3?=
 =?us-ascii?Q?B2lmSexGXy6sm7ne7tJTwb/gCzvGdMmtGOK+P696jXqDf96dS2XH0fFGTY1l?=
 =?us-ascii?Q?D2eqI4xD7BsG046vC/zW998ZjrNDM+DfXZngnJPzYqPFI7EVxBE4ISW0woJM?=
 =?us-ascii?Q?quppm9n0+1oY7FZV4nvJx3t+x3UnAcwfIaKauZ1o4xdnNv+2lecea/HJ176/?=
 =?us-ascii?Q?jskh+yNcrnsS4gnI7VltoccjAQfxgqJRfxZhXXmc+gbqExp7yQkm80xZzSiK?=
 =?us-ascii?Q?xQapkSSDv50aSPqjG/B6kE8oXRPjkTq5XwGjO1blwVIujzx52UW2bDd7JxiS?=
 =?us-ascii?Q?AREQhXYjc8uAo9hhnFw/bN1kXjOVhMdAaXJzROU4Tm6fY+P9T8VW0X0ofhS9?=
 =?us-ascii?Q?dYU20Jt7EPP4JVHbeNRVWdPS?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZZ221qpPSENwpNkJnKhTCESBDz/aYLHClOXhKUTKF+khoahEh5cmvmr4q8Y/?=
 =?us-ascii?Q?MQYG/YA8VAoE8zJnr0P5nMp6J9VMz7xs30OedB/1HCwwlfTamRnl/w2IhE73?=
 =?us-ascii?Q?4+rMZn/4eNeaWkMSmMfF6adUJxO2gKv0Tfej1zkJvxPG5LHHOrOgOJmREg/n?=
 =?us-ascii?Q?OjbxX+4NsWz7lX3rRALs1bhd3n+0F+pyOxCPuhHghfX86YHxYKM+oE2NL4X2?=
 =?us-ascii?Q?taB0BnksgDRojzjbtjcHqT08GRkY2gi9ZzZzrcjkINQhV8Ftak1oOQniW14O?=
 =?us-ascii?Q?+UNgRxysAQiVPtocLRrMXQYUywSR8zMXzh3ynu5rithK5Gjd2nCUsQr97jzP?=
 =?us-ascii?Q?nJj3SGAZ1HVhciwJ97Rralbhqrid3M6Ov4F1GWaQsNjEaK//Vo3gXVCwqkIY?=
 =?us-ascii?Q?jvltdE03HYaVc3AqkGpeXWUYm3iwtm5dEfFDBBEVyUDzUQh+NnVG731Ct3Cz?=
 =?us-ascii?Q?fKtPqP7r1denGDrLgke7Vg9loRYTlUxMGTrW4J7zRptzyYocdODEXzPC6wM7?=
 =?us-ascii?Q?dUbD7L6S0sH4JQ0fwq5cTY7Oe2nQcx76O2v0+6KhCZVcf73GgdWb1szM/m1j?=
 =?us-ascii?Q?YYC85FWE1MMA1uuBAqcOert3Vb6UMbpQseIJmOGFs7MGTSlJqxfryLbIL99M?=
 =?us-ascii?Q?Hyi4y/o5tRx+jYqVczcfLljr+BUbjdH96RD1VFA5uRTU5MQMa5mGCc1KgGTJ?=
 =?us-ascii?Q?jgjfs9MfjosMNGcVTxrfwNxAihPKofa5ctEYZm1moik11Y4KdCfrSVLff+G7?=
 =?us-ascii?Q?KsqiBX8lrtbCQwZV3t7jqqf73FW2upJCI73tMNSpGelqrxB4GqVrdUw5V13V?=
 =?us-ascii?Q?bV9J5BvWgEz+dILVL5ZfC+kuMbFoyFuNYYGer7SXtL3AQlMtWrg6UHLui9pW?=
 =?us-ascii?Q?JTiKBywgq12JbhCXR4sENDI81FXS5oSriraRvL/NkPyIghIevMgqVkedYHKM?=
 =?us-ascii?Q?vKmxVRZYhcgXGrJz/pZmRMZxt46R/7siFk1EE2VBYnvrf5gt4K75A/fdTv1r?=
 =?us-ascii?Q?fP89i4I3142iyt4S4vUaJDEFYNzKufp0Zvkz2sHBrGS5I6tHgDDZ791khHxe?=
 =?us-ascii?Q?V3QC65JcITlhjVtviP3DD8m1+KCIA+HCNiAuw2S1tpm7uU9hmW8CmebFdCPS?=
 =?us-ascii?Q?p4NaRuoDJ65mMpQJaWUYyTtJanGEcsdci0Y3AhOKXWcsFK3wwM5Alz8rDU1w?=
 =?us-ascii?Q?uKD9qI/iXmhTHIa37IC7AofZMHGADZCXtpCdXeIfSZrp32FzMNuYUExMzJXI?=
 =?us-ascii?Q?2saWpwzPEc7B8tDt5TDl+jCrc3VUDSXKaxwZ16/k0KJ3YaOpTkkD2rT8Tt1D?=
 =?us-ascii?Q?w1vqq4p8xf9pj17lJcpcWJlq+hsyMlV5inWjoqb8/lNHY3QGrjxF/o9EaMVn?=
 =?us-ascii?Q?Ldy/JQF2pW1nX2fQvXhVxDiRDZoEGbA09mRlL3Y4tazDUqDzZ6v+c36QqEbQ?=
 =?us-ascii?Q?t+ko8/fUnIkP2MrxDUXFftGDHe67O5qvEUYL0yMq3yG/kpIcmhplWP7zYhFm?=
 =?us-ascii?Q?eiZ/QwxMDh4PUMLI5LnD9YiPom/k21XCwfMROl0/ZQeym+1U5TZAfqIPnKgy?=
 =?us-ascii?Q?dGIKE8Gn7JNXiGKQWH/QO9VHvUM8zv3Go3Xchk6f?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cafc2e6-2ff3-43fe-7a09-08dcf9f9a02d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 22:16:11.2135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sZ/1sjDWPw1VUU2hoVvEsVK//jUTEMpf9G8jUhhpJ5Hnss6ru38PfPxbi7ozU+D3NA11GwJJr3fLqosFY4Nd/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5031
X-OriginatorOrg: intel.com

Fan Ni wrote:
> On Wed, Oct 30, 2024 at 06:34:41PM -0700, Davidlohr Bueso wrote:
> > On Tue, 29 Oct 2024, ira.weiny@intel.com wrote:
> > 
> > > +/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
> > > +struct cxl_mbox_get_dc_config_out {
> > > +	u8 avail_region_count;
> > > +	u8 regions_returned;
> > > +	u8 rsvd[6];
> > > +	/* See CXL 3.1 Table 8-165 */
> > > +	struct cxl_dc_region_config {
> > > +		__le64 region_base;
> > > +		__le64 region_decode_length;
> > > +		__le64 region_length;
> > > +		__le64 region_block_size;
> > > +		__le32 region_dsmad_handle;
> > > +		u8 flags;
> > > +		u8 rsvd[3];
> > > +	} __packed region[] __counted_by(regions_retunred);
> > > +	/* Trailing fields unused */
> > > +} __packed;
> > > +#define CXL_DYNAMIC_CAPACITY_SANITIZE_ON_RELEASE_FLAG BIT(0)
> > 
> > Fan, is this something qemu wants to support?
> Currently in Qemu the flag is not used, from emulation perspective, I do
> not see a good reaon to support it for now. Maybe we will need to support it
> later when we consider security?

FWIW I see those fields being more applicable to an FM or orchestrator who is
looking for the devices capabilities.  But I'm unsure how those fields are used
in those connections or if they may need to bubble up on a host implementation.
Regardless I think those fields should be added when a real use for them
arises.  But I wanted to make the comment here so that future implementers know
they were omitted on purpose.

Ira
