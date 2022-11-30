Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0BB7C
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 04:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669782321; x=1701318321;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=7iDWJxAcr70rRzkwG9+xotc7WLpwxtuZ9ptZws5ZvY0=;
  b=cAvS1DOdXZml0O5nDKNReErOrMpZTAGf1OkMNBksDXGfppKlympt1l5L
   f2rp0fwiIyu6DTnv43fAeY80RtaL+J+YOjFUI63+Nf+r7LJyGroBCtKNU
   bLjfjXSLGZrEnN3z+x+4Si4c1eDSZrKQOMDj1PQ8rNU7v62KiZfBHl/6q
   FRPXKfmj+Kr2fGY3gPmxPr1L5MOEstKUPu6SSA4APZziMxQtaYBlnogJs
   CAvGVsM711eT3p/qiocBKKV/At5mhGYrfgo4qT5VJfHoxH+qFBAqfPXbF
   a+u/HAyijWg6BLRu+UhBnsuOej2Qfhv6xW37YfPO3jL5e8ylTA7asdGUV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="379582006"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="379582006"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 20:25:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="637854271"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="637854271"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 29 Nov 2022 20:25:21 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 20:25:21 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 20:25:21 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 20:25:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXZ50Zsxn2UUROT2T8EKuG88+D6hBhD4H0WNBYEp5iwjfrXhJ2zo5fVxJy8KWy0ODVgZTW285rGNhXGAC9/809A/KIfmxDkYQGLm/CnJ2N46x78ELSA5AWy9LZedhcjIxGHLqtl+S6YwRzDdTSwGFmq5mQeo4qkgIrTnn0AU7bszx0/x2FjY20B0sXyJyidXud/xEvIRtM+PAXBgHCEtNcbGjM+ke8otmAXJC7fstXpjT1cFRdyQxKv0AVgGAcQ9Pbz6udFWb5Kz4tJ43oeCA539+eFe3aXl2Vy+NcsdBMQQdE6gBe//Rkg+Vw9NDdgycEahTBLyNQ6CGEND/SCqAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zB8dcI3VtuZHwbJ1AUwGUXi+7caGhBRiD+SLxI2qqa4=;
 b=OGv3II+9HKLxUS/Yi+vZe1p3gQoIaEYzmiBonvPm/jqSi7pJvQt3mrK05FLycdu+IBzwbZeuOrKF2M9QZedUe2iMAfndk5CUL+iMc7AA2th70ZK5b9cJ7yWEbwn0rUCfeGF8tP7Z+yyTmwShrbYGpWgSck2nEaVLa8NqMkasxnL3uwmzJFwiuEC35GlP+DgJf7OgXQQmHDF8MeuYUX0tnQ74mG57VoIt91OSTSbbKI2K4tTv8rwhOCGZrk5G4YjsHl26OJnyDNaS3RZpHgW6vVuALIfazxYhslQi5UtPMl7Ukilj4/pkhUtJ0GsVu1MYYJfNoyX8gWoxR8pr1t58xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH0PR11MB7470.namprd11.prod.outlook.com
 (2603:10b6:510:288::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 04:25:14 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 04:25:14 +0000
Date: Tue, 29 Nov 2022 20:25:12 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Eliot Moss <moss@cs.umass.edu>, <nvdimm@lists.linux.dev>
Subject: Re: Detecting whether huge pages are working with fsdax - only
 partial success
Message-ID: <6386db2877ea9_c95729490@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <8635b40a-6e87-b5da-e63d-476309bbc80b@cs.umass.edu>
 <a8cf600d-ee03-d67b-fef2-b8ca3355a263@cs.umass.edu>
 <baca5cfb-9613-dd07-8d97-e76033b059a5@cs.umass.edu>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <baca5cfb-9613-dd07-8d97-e76033b059a5@cs.umass.edu>
X-ClientProxiedBy: BYAPR01CA0067.prod.exchangelabs.com (2603:10b6:a03:94::44)
 To MWHPR1101MB2126.namprd11.prod.outlook.com (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH0PR11MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: f0033981-c200-478e-70f3-08dad28ae09c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cl3E4+NUz0dDcYmU8tgJGwhh2va07dQe9kQpVB80yM4R14Om7GhFfhF+SQQQQRdzdzn9ro455U9AzBs2vjq0rlCKcV3x0dE+J1/2JX/p8jWSPkwIMbYBcFfwK1fFhUSH1KG2O3tJD1kEmx2dTLJrr6wCvLUsUK1akzYfuGm6oes1XTTcnDa8tlpzaAWmMKp0psRxEBMAvYqTY4Ne32BVJb314lXYCnvZzTmcqddJhahQnIh5sR9fFtg3eqbiicUwa9c/CRlN/63Z0Sx6c8tJZBLfIo8NorzBUMivfHSfrsJ04bF2VLSvzBSSyGDwx2VB5P5arc0rSE1bKQMlGkNl6n9bvNU6j0aNgbU62gvZ8h3O3YlF0Rt6/ZG8yZ2QZBCID8JBeLVy7madQxYg/fhaA3bBI/sUACnkTfak7i8Bsatx29to4YB+eHy2WmZ//F3SEhFYeLwNNd/QciqTPHJfn1j4n/Tk4zq32VYWBMKc2g9AYe36MVdOBHcOA4EWrj9JRZb/9ZQBKvNlMoCJ7evggi9jPJql5pB1x6QIoDcwpV1svWNQu76Gwdmru4nReP/bhOxIf8JKdayM1A8AtaPol9wt3vZ2L+aLI3LLHfarWeSJYW2MrSM1K7rltb73NcBOQzQ/uSGNZWUOOYPNSpmwgp65RGgsRFN5BlFIS43ZezOhGwyy73IXDqdp7fPYNbxIxwHJ651d1jiv3qMcRJVw3Y4jRff/aCMG9vYd2JaTla4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(346002)(396003)(366004)(451199015)(41300700001)(5660300002)(8936002)(2906002)(6486002)(66946007)(66556008)(8676002)(83380400001)(478600001)(316002)(86362001)(9686003)(966005)(26005)(186003)(66476007)(6506007)(6512007)(82960400001)(38100700002)(14583001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XxomR7V+qHE6Y/f+0HGL4B+tD5AUk8TOrQRGFbYOs6W4HechNB9X/ihT0nzB?=
 =?us-ascii?Q?AkWKrOzEYES+OgkomLlT7RijSatC58yHjBvXpuBWwVrhuGOIkiz5OEEky57E?=
 =?us-ascii?Q?zHMEwL8M1RynOl6N2MO2OB764BksxXARGKMnjGO1VwbCvqYLdoITDP/gEfQX?=
 =?us-ascii?Q?SfBZdoUhTM4JtOkhGX2KQOsPUvbt+ve9o8VAhHE5rtP309vvSubNJzUOgt8o?=
 =?us-ascii?Q?KF5Oq/IT6OOGEIJ8k1tjHg+eLFpSOzHFRGcJr9B50m1E3W3wNzD0gEiJEFd/?=
 =?us-ascii?Q?fZxxKqEuw3IHCOD7Vszy0YgzU644XDph7g5GESQKVio+8caxb/fF5zMUcmYc?=
 =?us-ascii?Q?kuEJhS/knGNCz1Ib/KPByq22uAox0mcrRuj2XzGSsi69TY3bdbZMQLL4XkGp?=
 =?us-ascii?Q?bj/2ENsOAHBFCeSdR/bLwh80JcOC/A+dslXtoPCW6J4YDI7XBjfTD0WB2Sx0?=
 =?us-ascii?Q?bKajIAm+j2GahShJSqEDDrPgyQvQsCPe3OlKHB1VI4CbWzkGPZSroUTUgTw2?=
 =?us-ascii?Q?tPiTa5EMb5AE3XaFEazUxeWv7hNpOwAbe+TbjCAxRPn0HRrTgFcc5mqUj+Oy?=
 =?us-ascii?Q?GPQlszBJSeDZ0HZc9S8SrqjP+tmZp6LSMAQrV9ZDuNynyj+E07PXHuuIMmnL?=
 =?us-ascii?Q?hJClJhxA/hPOPZ3oMd2C1roMDJhxYFRHIxtdcl2IYaH4JIY2jVvYsbbHG2os?=
 =?us-ascii?Q?ocO4hrFE4uEZKgPxpg0FR5Sryol2tqHlKAbi632TjqqIfiSk2NQbKpjPKD5S?=
 =?us-ascii?Q?UO+P5s2Tly7mcn/BGEbggQ/OhdbQmgaRSjGN6ZZDphmVUftnm6qrh1DhLEPl?=
 =?us-ascii?Q?e+MxnlrGw+vM5k6uBma9hVeRHeuGUZ/BS1eCjRd9QyRbs/R2L+dTVvZ7aKfR?=
 =?us-ascii?Q?uJ4Wszs3IqfDKuVzHqIPhVcxBLx1bCMU3UACTNFZUoQoP87DNrqFa0Ffo4Kt?=
 =?us-ascii?Q?ulfoSt/elFQBOH4DyhcX+75hPySBikKRORVLRWIHi+An7EFA16n9zkeurkI2?=
 =?us-ascii?Q?Wpe+v+c7aVIy1v4gMRNmDlkfjMVGrSQXbgTa8v8a+rr4rxCnILwQ/KbXC5Nj?=
 =?us-ascii?Q?VQeIXreeMwcqyFyTUk3s42ThWgh4XgOKiaZmZ/3BrriP0jqLb804BghknPLD?=
 =?us-ascii?Q?pgqFPoS3qznPSbP6ZbXAPz2IjZ4HBhCf6x1IpSlmOA9S3U2A54DSmndaGLfQ?=
 =?us-ascii?Q?/qZd3qUPiiabQz5oF1+3pw/q60tVEeeFNuc9zb6EH+SQxGlVyrCwqAc1IarB?=
 =?us-ascii?Q?otrWp/sYHmGK2umZSjehSzpzM5kWeo+ufNF/FdU9wI4JonDv1bCcjhbXtfio?=
 =?us-ascii?Q?WetNTAcLYY3SgKC9V4MorC945eRN5iMcwvuQxdObnLDrYV40uc5EZchOGOsU?=
 =?us-ascii?Q?An1lo1H9+t9Lj29EzkKxVkQfdl8E7Xx/fesVxbmrquYCSKb7yssjHCIq18ti?=
 =?us-ascii?Q?ea6yI21JLA/2vmt3YdeafE9Px39h/98iZBY+EUrPiCi4zz/pAPX1wD1XoCNf?=
 =?us-ascii?Q?DVtFl6iE9S5zoqoBr6+lY3s100as3jkJPC9ij3Ezm2ScIJ5W6KhaySeiAz4X?=
 =?us-ascii?Q?l2ROZTvF9i+4S3LBukcFm03RQ3vbAtVqMavqmXnJRvYZ1ZbPeU70Hyx+eymJ?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0033981-c200-478e-70f3-08dad28ae09c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 04:25:14.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NiitnB/0bF+wBLfTSl5E2N038VyPRmW0c6BFVL3sx0/xj/tmbZqHtmrELGTGGMTcWu7N5cp5wON4cqBOG3cJbEtIMK/0p5yzWSH7NVuU/GM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7470
X-OriginatorOrg: intel.com

Eliot Moss wrote:
> A quick followup, which may indicate a flaw in fs_dax page mapping code.
> 
> When doing that mapping of 32G, for each group of 8G, all but the last 2M
> resulted in a NOPAGE 2M fault.  The very last 2M chunk of each 8G region
> resulted in FALLBACK.
> 
> Then, a spawned thread accessed the same region sequentially,  This caused
> the upper 16G all to result in FALLBACK (except those two 2M regions that
> already had done FALLBACK).
> 
> The first case "smells" like some kind of range error in the code.
> 
> The second one is also curiously regular, but I have less of a theory
> about it.
> 
> Is this the right place for discussion of this behavior and possible patches?

This is a good place to reach people that can poke at this, but may need
to pull in fsdevel folks if this gets into a question about layout
behaviour of a specific fs.

Even the nvdimm unit tests have gone through changes where different
kernels result in different file block allocation behaviour. For example:

https://lkml.kernel.org/r/CAPcyv4g2U6YYj6BO_nMgUYPfE2d04pZvKP0JQwNAMy9HZ3UNvg@mail.gmail.com

So my hesitation to jump in on this stems from this usually being
something outside of what fs/dax.c can control.
