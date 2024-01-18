Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D653428E04
	for <nvdimm@lists.linux.dev>; Thu, 18 Jan 2024 23:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705622109; cv=fail; b=u1qf9SZCH/uDxn1y3+cOSZChWl8UNRkF/XEcnT6HcaJUQtqq0eMZROHqm7cWzFvNLvJp6E48DIvLwlfl6+ff7oiNe/J7hzp/OMR+A/FGUna6fgUwlQFK6qgydFvNqX8BpHmvM5IBMmWyZs5Vv9gGUrccVHbNEpellQ+OZUI43DQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705622109; c=relaxed/simple;
	bh=N+vMCBsRJTB1Df06ItyqCAGhiMn8ufGxQ2520s7woMc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mDaT56xyDgW9x49ttyAL6h+k7T/R8llVFX0glMGeBh7lAQM1XwJY/HnPtfBgthvPTqjkmdyqSIuSb6W+TE3hjuanK9bWlLS0MVezTS7Le/i6Eg9tvC9d6Twi/EtF+zdMQMVHQJOjo7jmOz8xA5nWvW9GpIwj2tLIbeS7uVS2xOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jt73CYzi; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jt73CYzi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705622107; x=1737158107;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=N+vMCBsRJTB1Df06ItyqCAGhiMn8ufGxQ2520s7woMc=;
  b=jt73CYzi51PAPvX1K7shNwE/1ib4AlRqTAtozLwh4+L/o4IGv8vYoRS6
   x0xM2EYb/hBG5rTskEOTELo7HOeKPuuEnzTALgHDuldx3lCBjYiWc3yG6
   xtP0gP6kiOvcXJnK8VWP9GFaEbfVLDBPu0AwtaUALMSe5dSdf7+w5f1BI
   ehIoh/8mjIgqcEEp+I7Abq14PrR0ryuPwV8Lp5KBVk8OaiEMDCmhNxhfd
   5lQq6RNuA4EH6r/n9ZLitOVbj5g6G5lM9ORezaenQ8VWdED4e6Dgfpf93
   CtB0iAp+DveDtVp7bG0xGAk7lMW4r5k5QmaFEeAjvwrMFX2IBgvvOnHz9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="508976"
X-IronPort-AV: E=Sophos;i="6.05,203,1701158400"; 
   d="scan'208";a="508976"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 15:55:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="1116097375"
X-IronPort-AV: E=Sophos;i="6.05,203,1701158400"; 
   d="scan'208";a="1116097375"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jan 2024 15:55:06 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Jan 2024 15:55:05 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Jan 2024 15:55:05 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Jan 2024 15:55:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaK96xC1Wun0Cf9h2YfVONJ4g9k78ApCoyNpe5DDXZGqydkFV280ciNvK8wUXEP3CdQDT7iSfz4vzvljv7ZScj64g7lNHt8AHfkTRD/bFc6oMdVWR1ZV6h+Uwwuah4f4IRkoY/71MpNSOHeauWiNh0xmSjVAASPYk5RQ9KLf231aqmCHXwgUPaMxsEiabHFmwC7hRJtmifn2edKH+7g4O/Ek5SUEVpWeOkRLvRIHYCoIshiBZDzfa8+oZ2UQRkTmA8dvOusCVeJSE3gt8La086/QcsjE91JeYSiw3CUjbSrdOZV40WS+FpSac0nZ2knR3sKZbAYajWAQgG7kQPUWSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xMS3SbzyvW/eS4kwWXy3VWWD/Uhq/JPr1rK0dLRwAE=;
 b=JQ2Gb1SlN9eq4uVVnFlD2kV28hb2q9SFvspqxyjvSabk91LoM4RRCNcQvXQM1SNAr2NhWmkhggdq7yNwL8scHctjO+plLlQnoSqxbmbqT1GHw6V38LnzMIXcqtdmKi3ZQyaWzSQYrQUaVe6TJoBB4mt/jOX6WmXspnUPExeoNfS1enmBjTMQB2tuBO5Z69j+5OdRRaX+Ra5wE+d/pkG0oRu2uWEB2dscZ/IZQphJ2kLa1AvRS8sRqF7+LLX8k1SU3ulLnuEtAQ+Y4B/ax3yh+EFQEfqKWhSHggMoXQm8CO+aEq9t6OiHUBjEej3GFs2AXV6XbnCnAQPD7sHAWAwGBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CO1PR11MB4964.namprd11.prod.outlook.com (2603:10b6:303:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Thu, 18 Jan
 2024 23:55:02 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7181.015; Thu, 18 Jan 2024
 23:55:02 +0000
Date: Thu, 18 Jan 2024 15:55:00 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v6 0/7] Support poison list retrieval
Message-ID: <65a9ba5469bc5_37ad29426@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1705534719.git.alison.schofield@intel.com>
 <65a99ea31393a_2d43c29454@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <Zam1iPjxXA9iiUOl@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zam1iPjxXA9iiUOl@aschofie-mobl2>
X-ClientProxiedBy: MW4PR03CA0195.namprd03.prod.outlook.com
 (2603:10b6:303:b8::20) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CO1PR11MB4964:EE_
X-MS-Office365-Filtering-Correlation-Id: 48cdb71f-8fd2-40be-b2ee-08dc1880e321
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NphTehmrhmHQ0WPWlHtbtjYA9iLdDTp8Zc2KcZpWyRJY20Y3tGhNi7xhTWnNxFxCnTC6/Psvm99OhGbx7n+SX2GV8fD5Ouo6LXrh9QxCqbC/C7uJuTp11/8mc2zh8NXH0fmu3wM9+xrb5eir8txbl2u/U9CpR/glRIKisjmifjYPKaKlenmp6vPAJzeBRoz3vVuoHDf4EHhOIjD4gbdIMiHnHMBNVqqOC5IN1qD1stEbW0kXmZY6dXtLIT2613MVQc00aPKRoMD7iRPWFuHgW2c7ZxDXzKgSSkrqqHzTX2aMeUB07iDGPPL2LwKNk4jCPThf+F8mNuhYZQd0NXjmwRvKrxJlPA+rsz7qsU/STfX3bCA2eIkXGgx4zgAPJ5UwZSzMC2JVsOzbGU+orGyq1abCYtbEBrCL9OaZBCKLSFMs6WptAGJNKKFxC0fOZrW80sstWzMJsxpe52lqhRNN4o8w+LVgZ/7yGjeWSyuZgTNLHWNufi/pDLow1zVxmLIUMIB6v5JXsJr+UHM4MhyV0HHdAlST8EwZTkCzH2ogBgBimvC5tmoVQwjfzr1Qug46Xn3nmSUoijuodZu5Bs9Ex0Ui1ZVusCFaDwtfghZQJ+iBN8pau2qRxSbcty+2QlG2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(376002)(136003)(39860400002)(230173577357003)(230273577357003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(66476007)(66899024)(66946007)(66556008)(41300700001)(2906002)(5660300002)(4326008)(8936002)(8676002)(316002)(110136005)(6486002)(478600001)(86362001)(38100700002)(82960400001)(26005)(83380400001)(9686003)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?otbd2HZStMBTZ+ULohWumIS6MicU0oqMnuJghMrsgFc2ioY9UNMOx6+SFQua?=
 =?us-ascii?Q?tTsaUfME9504v27BD9K74C5IcihxNqQOfdqSAOnR72hAEYQsncCf4auPRu8Y?=
 =?us-ascii?Q?tJF+z/iOxs0uff6pVCxpL0FOM9RNNAdZRW/jIDv3Hg09VogzxZ7gtzfDDs59?=
 =?us-ascii?Q?Vuwc6S9ercKfvCcp3HPmsimx0h/6fUL/YNS3sXj0zl8jDXz70lydrVxsx378?=
 =?us-ascii?Q?nhLa1a57TZV+99BXGkBRahWRQpbOH21cHRqvM1rY3KkJKZT7n0OSh6EUYKLc?=
 =?us-ascii?Q?MH416ovmnDY6TdaBdNkiR06TOxZkDp71kn3AJMtIqVXmeFQt/3zMau5Ms9ve?=
 =?us-ascii?Q?f57yYF3D2DbnVzbtKbK+JyTge1MeN0cJkcUHu5LUX0zNjLZ75u8fMdfiaPsG?=
 =?us-ascii?Q?wi1WrFDKyo3XRXwQJKqBJch8U2rY53p9fCCH9ZfjCHCGTZcFXhqDTzBo5swf?=
 =?us-ascii?Q?CGc1Aeb+84xUUazmnDt/7VAMne8RA2gnMZNz8fDnGBhxy39jUd3TPea1Y3MR?=
 =?us-ascii?Q?s+ie0YUUK0DwFAjxL5Sr2ZMJ/IFVSIkJMl7SYTh5Ig++lkPKf+WS3sUPD4E6?=
 =?us-ascii?Q?k6nY8pXjb8knSJuO6ScYXSFVNkKDmJ/EW83w8UgPtZ3hgPOhNfPeUi+lT5C2?=
 =?us-ascii?Q?+bDN2BB12Sn/6Y7Uiio+y/ncBFGxhms9z8sYXyzIROhkWKJ+2tZi4CtRYsgw?=
 =?us-ascii?Q?SX/6tCkEZaM/rNbf4blZW+vaDbpK2d/zcu6S9tUgv9yDulRmIpdUvvSG9Tq+?=
 =?us-ascii?Q?WJFEmL69SXrbY1yT8OIHvsA/LdSD1c4pq1zQ0vQSQzXRSPO8Iz53UnHl4M2p?=
 =?us-ascii?Q?XUHAC2ihg9ZgdGRKR+yxLziPedDyniU0HHK5OEGMCgFiqq+fRek2HMmkKF9V?=
 =?us-ascii?Q?T89C5/UJ/Io4Dt6pWNjtpLl0TkfDk9ClJfMI9KPM4DuCOuneIBB2lh3yF96U?=
 =?us-ascii?Q?bdU/LgJitsYBqvzAdlNjYX+nako33Ch4kB2Lu1clzG67hZYQ0/lQagnzNByG?=
 =?us-ascii?Q?xsbWIa4FZYmQQXetCI4S1cpJP6bW4YK3MugO/C0iahR7W/7BHsw2kSUlcqTb?=
 =?us-ascii?Q?YPjthhZc7fUO/Fan4xFFprvHX+mykyCjY8Sn+OA2muFGgz4oIos9hhnGq68z?=
 =?us-ascii?Q?dH6keLA11wyAzUBQv928mlIpOO23SpNSBs5/7Jbz5kgTpT2bO16G5+ftx+JM?=
 =?us-ascii?Q?cA0fA4QdgtdqtYxbqUVIfNqOvCZ2MgSjWgO2OdWe1CvfKB4spenNZvNakgsy?=
 =?us-ascii?Q?5otgq9b5fC1gGVJJ39zUtROVN5oD4AY13kZiDqzITiX5aqx18yKmnbAfi3wv?=
 =?us-ascii?Q?hk8DZlEwMwHePSs0P/eKsdd2h59QK2tQ9MecTUBDODigauAS2U4GoWDj2IFM?=
 =?us-ascii?Q?JX01+f5iW0Rtke1BI+RnFK6Txs/hQ0ZAdI4Rpmx9FZqDPVUo5zJZknOt2DFa?=
 =?us-ascii?Q?N3Iuuf/d3O2kYTG835UqrFuN0b15TsyTZNIzTFE3bX3mV3iX/N0eXoHsmK7u?=
 =?us-ascii?Q?gTtsyIYkOHo49IuvenVIkIB8sI7QH1kE7+1ZYjKFeNsusxlURy2NHoId4Q7J?=
 =?us-ascii?Q?KuQBVPIxRU4+PAxQTqNSZYPFUl392AVht3dFmiuCH3fHqZjiS7vbbktop45v?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 48cdb71f-8fd2-40be-b2ee-08dc1880e321
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2024 23:55:02.6378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fTP1u2Tq3b+l90/An+1j+PNCdxdpKK4m+iewERv/1/zhZyOgTWFx4DgpjHXgTzahvg+MWM3qClkdJCsktv4i4OPLqUpPGynMHrb9b6YFyNc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4964
X-OriginatorOrg: intel.com

Alison Schofield wrote:
[..]
> > >         "dpa":1073741824,
> > >         "dpa_length":64,
> > 
> > The dpa_length is also the hpa_length, right? So maybe just call the
> > field "length".
> > 
> 
> No, the length only refers to the device address space. I don't think
> the hpa is guaranteed to be contiguous, so only the starting hpa addr
> is offered.
> 
> hmm..should we call it 'size' because that seems to imply less
> contiguous-ness than length?

The only way the length could be discontiguous in HPA space is if the
error length is greater than the interleave granularity. Given poison is
tracked in cachelines and the smallest granularity is 4 cachelines it is
unlikely to hit the mutiple HPA case.

However, I think the kernel side should aim to preclude that from
happening. Given that this is relying on the kernel's translation I
would make it so that the kernel never leaves the impacted HPAs as
ambiguous. For example, if the interleave_granularity of the region is
256 and the DPA length is 512, it would be helpful if the *kernel* split
that into multiple trace events to communicate the multiple impacted
HPAs rather than leave it as an exercise to userspace.

> Which should it be 'dpa_length' or 'size' (or 'length')

I recall we used "length" for the number of badblocks in "ndctl list
--media-errors", might as well keep in consistent.

> > >         "hpa":1035355557888,
> > >         "source":"Injected"
> > >       },
> > >       {
> > >         "region":"region5",
> > >         "dpa":1073745920,
> > >         "dpa_length":64,
> > >         "hpa":1035355566080,
> > >         "source":"Injected"
> > 
> > This "source" field feels like debug data. In production nobody is going
> > to be doing poison injection, and if the administrator injected it then
> > its implied they know that status. Otherwise a media-error is a
> > media-error regardless of the source.
> 
> From CXL Spec Tabel 8-140 Sources can be: 
> 
> Unknown.
> External. Poison received from a source external to the device.
> Internal. The device generated poison from an internal source.
> Injected. The error was injected into the device for testing purposes.
> Vendor Specific.
> 
> On the v5 review, Erwin commented:
> >> This is how I would use source.
> >> "external" = don't expect to see a cxl media error, look elsewhere like a UCNA or a mem_data error in the RP's CXL.CM RAS.
> >> "internal" = expect to see a media error for more information.
> >> "injected" = somebody injected the error, no service action needed except to maybe tighten up your security.
> >> "vendor" = see vendor
> 
> If it's not presented here, user can look it up in the cxl_poison trace
> event directly.
> 
> I think we should keep this as is.

Ah, I had forgotten Erwin's comment, yeah, showing "external" vs
"internal" looks useful, "injected" gets to come along for the ride, and
if any vendor actually ships that "vendor" status that's a good
indication to the end user to go shopping for a device that plays better
with open standards.

Might be useful to capture Erwin's analysis of how to use that field in
the man page, if it's not there already.
