Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ECB56B8C
	for <nvdimm@lists.linux.dev>; Mon, 18 Mar 2024 21:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710795706; cv=fail; b=b4ipK7zi3xlOpKZ0pEaoYvwK6HgFJjEJ9NmxeBRzAZqG2thwBBhOLyNXNMj8uh8G/U6eDB0K/9mQtO6JZkzHuvNbdZ+lMet8liFkkZyaHpyFCi0LqqTJDkVPSLsbxUegDVYd1+BG6Gp10f6ytgTCWN6ZGZC6GEDkCvNALGNxmHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710795706; c=relaxed/simple;
	bh=zkfSmmW6N9xArt+vbQtBmok5kzoHBi2Q+aB5mbFcbXM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kL8TrzE26QVIQYnkrWIDoDx2wqzYefcWO2f1YtTkeLo7Gympy93I/1fcVaWTH6iQVwJ7iusQkFcQlpy+cRA+g45iLZZxyKtTTly5B0vDvIqu+LmA2jb/9KrdUeCisf2TSQFS+/nfbDaYnWL/itnff25yDASMAggMp6NOjAhNDxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UiHIxgyN; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UiHIxgyN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710795705; x=1742331705;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zkfSmmW6N9xArt+vbQtBmok5kzoHBi2Q+aB5mbFcbXM=;
  b=UiHIxgyNGZvHFaBiJaTIPwsphvBe/Ptvw4Adc70SnERfBZ60DSFCQ7Ld
   0o/l8k81GmI6Mc1JhQdZrmJjb4Fh82KXXlE+rFK8ySbsdMMWJgtm49obB
   K8Gf8UCZUBoqxP4Vh/epyFn9vexHqOI6xyAEr6u1wMiz+G+wlbggpgtqq
   Dp/YdVtljzjt1HkThZOcU84YaIx3He8VpZrsjdPu8qE+zbzo3Ra32A4sH
   n9z2aE6MTOyPhYgu/jDprH/aIpddVk3yo9dzHTfpUvyo/ejJP1EMCdee7
   HfHwCx1DKwngvsBWdiCqWdi7xWQqKMPnDfmDVLA0mO+hVGDcvF9ifeU4L
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5474227"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="5474227"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 14:01:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="14054472"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Mar 2024 14:01:44 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 18 Mar 2024 14:01:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 18 Mar 2024 14:01:43 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 18 Mar 2024 14:01:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AiwkQy3dRi7ggL8P7zFStT2t4bGO1xyXNDaPZ/MeyRL0o3ZXJYyu1JF4ZDV8kVcap40SPapNCRKnsbqssCJWg2awf7vErdBe2uyF1MjMe68VWl/zUnIXh6Sn/MWqi7qzHCl1jav2zOPnSrfZ24weTUUIYGbDtmTEo5wx8bObd1+iSxV8SKI7ukIeetUtjyoOVuwbzZ2/cTjfpxR+JfPAZ4bodjWYMSEfj/JQkxsT8WvEDuTZ9UMmA1moGU4uOLAyOqX++5Ke0pYEYjK5KrfEUhdVOo0REQkR38j1i3EyBlmCUrkawh8XtO6KnTQVh14aXOgvNd1odsrtca1I6GGnDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qf9rnVt5Pl47PVzQ7eQgxCixHw/oeqXZi/UB3rgWLfQ=;
 b=KN3KXf7K7862M14aw27EB/JpnHdhcdDibqe/5gfV+EbwFMdf56+cxTB/9TRacfcH9GrKOJEb8M+OFBIxMan6xdmIDF6kq1+J0O7OlvZ6KNN+eNplHEeIDqKuTu/LQYFfqoHgdw5TiVArUhMeVdFZvKjjJ+k6B9GQPtCBKXXAKHjAh9Ufr2oYQ5MyecTrTBvetd0nVpLn7scci0yoaYmawssj9QSmFe9RsDQo9JKpekuMbNMZTJh2YhCxviza58ywTkUkukCHweUVtCh46O0qjgABG9wgwi+9D4emV4Tb/w6RGiWMPjdNCjFXvAhMiZSsTl5IhGKxo4rBfwZkBYjUVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB5174.namprd11.prod.outlook.com (2603:10b6:510:3b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Mon, 18 Mar
 2024 21:01:41 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7409.009; Mon, 18 Mar 2024
 21:01:41 +0000
Date: Mon, 18 Mar 2024 14:01:38 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, fan <nifan.cxl@gmail.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v11 1/7] libcxl: add interfaces for GET_POISON_LIST
 mailbox commands
Message-ID: <65f8abb2ee1ed_aa22294f5@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1710386468.git.alison.schofield@intel.com>
 <c43e12c5bafca30d3194ebb11d9817b9a05eaad0.1710386468.git.alison.schofield@intel.com>
 <Zfh_EYPNeRJl8Qio@debian>
 <Zfif+rGM+GbJmBvv@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zfif+rGM+GbJmBvv@aschofie-mobl2>
X-ClientProxiedBy: MW2PR16CA0029.namprd16.prod.outlook.com (2603:10b6:907::42)
 To PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB5174:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qXrWtgSDvmIMwJjnN7zuvIynZT5UP+JLnYtw0rkJHi+K9sRrrcox1LjvP3tU6/xSIICu40LLlj3o1Qh+5O0KWvnc4GKDKUHwKNbNUl6f0JJYgzv5k4bxPZPhU/mqUXCuQXUYUlDKUwg4bWOcuF+QGO5unBcLgOvIl5qQ5kZ8p34o7trz3Rf07o+qgswOVsXv0pHq6F2XFMBXRE7ByiOsXGq3p9kfPAvBNTkrs1/0TG8zZjFi9MwoFoGd77hqCBMxwf4XC7XRvY0jvr2nTe+O7XgcUQGSt2j7xdCxVrR7xhAHK4ALmXFZc1dBBSlI/ORqttOldAJ9iw7MgsoWIC5xZzwBDGxiS4wT0iDCiln8MPHnBuQA7kW4I/tCsrbspCUVOiv+FxAkJGTWLfzbdno1J4pdXHjQqv6kvHDE/yk31YBPrqxutxZsu6MdjfeOAPAZnAlabA+wf4KaUjQhHt2uk2wuFHX3iFOqWQHW7+VJVaznoJ8CyoV32ZuQEAJfPi/DdNSYsAethPLqbqfwFOB7vZckTnvahj6KCKrUf9Y/f1CyAlQ0Grxn7dvAtuTlDZ6e1SYLf2h3MCExBPSt5whz8l1jLv+qEe8tcfbC127HMASp5ujDf+ilwIDuBaMW0L8rf7K48xqHQLvdhmlxtp9AG0PqnIxq6I5Wt2fJgM2tNGg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3p3PN9TStbx9QfjsG7fp4R38JRyBA+7+Tuoy6uhoj9cFHC9wdD9vvLuh/rGh?=
 =?us-ascii?Q?jZP9G9pn1cBG021hbl+riV37a3XI7Fm0Qf/6jx+pMQdpXOBew875Mkl9+hWX?=
 =?us-ascii?Q?eESONMGXoCQeVbZDhl7v4WuQ18s3y4Eu1fxVi4cOKQYGrBPh/eggoGy+untu?=
 =?us-ascii?Q?VwCSe2elawQlzGVvnlvja3j7DA3kXmSPVbSR05ImWhQXHcyfiq+AQ/uAavNE?=
 =?us-ascii?Q?gpf2vW6eXhthvLEEYc9yG6o3M08QeYVfY1XW8VCIj/XU24kZCY8b9vSZMAGU?=
 =?us-ascii?Q?rvM1Pj+OYlLWIw0YncqZKqWogoiRo9Wlii/sQOgOFQoQ2S0VGra59P4UtmCV?=
 =?us-ascii?Q?B12fbZz90xavPUADt9ZomKOlWtnwxd1jeb3Kytvc6UGGEY7j/Yjc8YldJv8k?=
 =?us-ascii?Q?kt0xWwwDP1P+2UdllBgB8oG7wqllMQBQ7zqjbDQHF7JZpyDVYcqdsgIXkYAo?=
 =?us-ascii?Q?Km5WI/1xfOmcmTZAkCd8OvsvGZ5N6WOWCL7zXGIpweel1rnNvO/UVuV/8D2c?=
 =?us-ascii?Q?diEYI1czhfOmk01SHQIqblANGgtqR23igSSGaoVdY4VJJD53sdNN9Z3u2oqM?=
 =?us-ascii?Q?mgkPDephjmhC/Fpdbgm7Efbcam/DEUTGufUP0pBSDlZP9Em1YL9QGKjBGAqZ?=
 =?us-ascii?Q?uIeW4A4oap7k/XPCdIfVYd1gI9hbCSvp++THNxDStBQEyorKZXvAM4LAVOL0?=
 =?us-ascii?Q?bo4FE+cyffcR97BF1OjHbC5fSOyMNW+EmrUofjIctZkRon9f3HHtA2zPuR+R?=
 =?us-ascii?Q?Z80W2Zcns4lofsuNaI+5pxBLxFBvE6tKXY/sUvtLO2tyZeiWUOYP2v0vqoOQ?=
 =?us-ascii?Q?I6e8T8BY1ZT+xB1tklyhmmZHxbBMnx8xII0492am5uSyVEUxR/55CL69SOO7?=
 =?us-ascii?Q?qe7CORDBfltVv2aEVegY9YdxTpPqZIrGKMpQLRLbQ8ySqN3ivc4B0Bd4T2wj?=
 =?us-ascii?Q?sb/h3fvYuXGgkn/iTxKTs0bZdJPSNmSvrCgdwEB2cTLyT0Gw10mr1/ZmTmXo?=
 =?us-ascii?Q?0KF2U+U77xRIUGeTqFbPLzvl8CTv8kbt5eoJqTsLSahaH0vKnOBad4GyVvmx?=
 =?us-ascii?Q?OpQJN0hFmdb2nuKZva7mZbpuZKu6DAUbzLku1m+7PoLlOEPq/Sty48tFXzqi?=
 =?us-ascii?Q?o0IOG1Lt9ImWGO0Ym3+DjbW4EGVtwOw3AqF7amxGkQpr8VQMAVfequGFrIKt?=
 =?us-ascii?Q?yRdwZ2bHYn+o6ww0uBj5yWWJikQmlhTScusAetJfrXlgBIpC9qeNJ1+7n/la?=
 =?us-ascii?Q?Zt2dyg8Od2v3L0QoSLRqVAKZhS4ceBP2hD56WuIzAzpsTaRd2/7mnUj/8fgv?=
 =?us-ascii?Q?wy72RfQ6BLek4+8utPVdE/aK7BFawYgxJJsr/55KZMH3kNiYAVN9tMoHzMV/?=
 =?us-ascii?Q?Bd1qvzt/ezFqcv1Ob6GzZdZwhJ5rOVa6xGmdC15azsoEwrPNRYFsSsmwjkwr?=
 =?us-ascii?Q?02QRSqEkh+IuSlvZrQ1fDLWfdnlNsaaTPOr++sgzerhDS3W5bDgoU/89npro?=
 =?us-ascii?Q?Zp3OQf1WC109ryL+wKGltEaRLz08z4yzF84pTZR5x9CAdW63nqFDO7EOOUM2?=
 =?us-ascii?Q?WmYVevVRv4n3Yl6y1M+GTcxeCyQ3o5Doz3YFhs8ihLohALUSsq3xcbVlAK+S?=
 =?us-ascii?Q?sQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f29089-4b7e-4053-4b6a-08dc478e9c36
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 21:01:41.2722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LZOCezIkjfUavnMJY9ql5MqPcFYR+WbtFnsLx7RQ3QxVdYnTRTCZRHCWfCHneq0kup0I8z7Z1Oh2+ByltjS7kRHnuy15CxSJfYLaAFsGMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5174
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Mon, Mar 18, 2024 at 10:51:13AM -0700, fan wrote:
> > On Wed, Mar 13, 2024 at 09:05:17PM -0700, alison.schofield@intel.com wrote:
> > > From: Alison Schofield <alison.schofield@intel.com>
> > > 
> > > CXL devices maintain a list of locations that are poisoned or result
> > > in poison if the addresses are accessed by the host.
> > > 
> > > Per the spec (CXL 3.1 8.2.9.9.4.1), the device returns the Poison
> > > List as a set of  Media Error Records that include the source of the
> > > error, the starting device physical address and length.
> > > 
> > > Trigger the retrieval of the poison list by writing to the memory
> > > device sysfs attribute: trigger_poison_list. The CXL driver only
> > > offers triggering per memdev, so the trigger by region interface
> > > offered here is a convenience API that triggers a poison list
> > > retrieval for each memdev contributing to a region.
> > > 
> > > int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> > > int cxl_region_trigger_poison_list(struct cxl_region *region);
> > > 
> > > The resulting poison records are logged as kernel trace events
> > > named 'cxl_poison'.
> > > 
> > > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > > ---
> > >  cxl/lib/libcxl.c   | 47 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  cxl/lib/libcxl.sym |  2 ++
> > >  cxl/libcxl.h       |  2 ++
> > >  3 files changed, 51 insertions(+)
> > > 
> > > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > > index ff27cdf7c44a..73db8f15c704 100644
> > > --- a/cxl/lib/libcxl.c
> > > +++ b/cxl/lib/libcxl.c
> > > @@ -1761,6 +1761,53 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
> > >  	return 0;
> > >  }
> > >  
> > > +CXL_EXPORT int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev)
> > > +{
> > > +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> > > +	char *path = memdev->dev_buf;
> > > +	int len = memdev->buf_len, rc;
> > > +
> > > +	if (snprintf(path, len, "%s/trigger_poison_list",
> > > +		     memdev->dev_path) >= len) {
> > > +		err(ctx, "%s: buffer too small\n",
> > > +		    cxl_memdev_get_devname(memdev));
> > > +		return -ENXIO;
> > > +	}
> > > +	rc = sysfs_write_attr(ctx, path, "1\n");
> > > +	if (rc < 0) {
> > > +		fprintf(stderr,
> > > +			"%s: Failed write sysfs attr trigger_poison_list\n",
> > > +			cxl_memdev_get_devname(memdev));
> > 
> > Should we use err() instead of fprintf here? 
> 
> Thanks Fan,
> 
> How about this?
> 
> - use fprintf if access() fails, ie device doesn't support poison list,
> - use err() for failure to actually read the poison list on a device with
>   support

Why? There is no raw usage of fprintf in any of the libraries (ndctl,
daxctl, cxl) to date. If someone builds the library without logging then
it should not chat on stderr at all, and if someone redirects logging to
syslog then it also should emit messages only there and not stderr.
