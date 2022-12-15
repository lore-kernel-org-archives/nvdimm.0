Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631696AB1
	for <nvdimm@lists.linux.dev>; Thu, 15 Dec 2022 22:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671143270; x=1702679270;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BzSXptmEVXFevgQT3QieCeVvD46LpN/SNgkGbh2LXbI=;
  b=I7B+Vjg0cG7rzBXR0aJ7r8mpUDfhknTnm5ywccOpAM0LxTzxR2+CZNcR
   kVx01QLMF3LAoYX0yCRz/PJVT7RtsDDFp+oJmToLg3pl7eDpQbo+aOkqN
   GiMc1nXAMKw5B60Pc9tSsQ3Cj1jML53ygULzLAML+w21FXQKhrRNXgonL
   W8G21F/nVzXYiScQ6TDMBwK4emTkLIZoKMxzva412chpeV5MXBp1+kDJZ
   Iv7apFKyntSKsJ202Z5WnYGZV9x2mfMD+75q+Ho16bI0AF/gmganT/Bsi
   662jxh1xtjeEd1Hs3kjVonz+0G3b4PNyuMOwQvJXQ75ks0vuvHbenjjdd
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="316458984"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="316458984"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 14:27:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="894967053"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="894967053"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 15 Dec 2022 14:27:49 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 14:27:49 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 14:27:49 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 14:27:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuykVkiRlGLRdbgLf+skJkKEI5ZsjOB7INVyOg6lJcIjOBk27hG5TpWjdrE/Sx9kBDYkKIO/0EquNpwUmz2BIls0wT8Hc/eQ82im3rz1pIt/BrL30NzzVKY2UZO8x1KdtDjyYgvR0LtoLUydBfYFKJjDTXdNcOSLwZ3NI3A1nc3xPtv2Xnlh9hv//Gf8SOokf12xursC4iYL+GgJCM60Xt202LU0bGtzJ2/7gGgI/wA7e2lVvr4IvEYXmNtw7vu6PN/fX4qpFVygM3qF7mUJCnAYFHIiieuBCL7OrZPKrlRAEWtZSCJj8AA1q/4GcYx2II5K3JVKVScW8pNavLYOHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8xa7wXHD2KPoILDoGt1qT2ChKIls+mW4HxXblblKf8=;
 b=A3a5G09uftdWoJDD7Quq3nf55t3lXJnQPXL2OsJjf1lxoun+g4aa3Tdnbp+X2yP2kIXZ+J5r2/txLrfWBzHv4jXHoAmDYmlePAOxoVqdByvc2UVyfM7i/Xtv4L7adTRNeWD2EbCJy0b7dnW9yudJF6gLezxAJLaFryExC3qORAwYbri7e+cY8ypqeuHLRVpCyAiBuTZdfYFmVBYWJ2EsibHUk8NULQyiHouVMORSI8no6xQCcsOo905Xs4xvo3PkVzApu5yYmBIZiVsOOjT9WZQzxQ30WZaFj11zy+HcgCU88cEbmJLambwPxTYOYoq2ttSbKkeYNQV1g8PH4j/GOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM4PR11MB7397.namprd11.prod.outlook.com
 (2603:10b6:8:103::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 22:27:47 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5924.011; Thu, 15 Dec 2022
 22:27:47 +0000
Date: Thu, 15 Dec 2022 14:27:44 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>, Dan Williams <dan.j.williams@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2 1/4] ndctl: add CXL bus detection
Message-ID: <639b9f6062c69_b05d12941f@dwillia2-xfh.jf.intel.com.notmuch>
References: <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
 <167105522584.3034751.8329537593759406601.stgit@djiang5-desk3.ch.intel.com>
 <639b85df2197a_b05d1294fb@dwillia2-xfh.jf.intel.com.notmuch>
 <x49r0x0xt5r.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <x49r0x0xt5r.fsf@segfault.boston.devel.redhat.com>
X-ClientProxiedBy: BY3PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:a03:254::29) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DM4PR11MB7397:EE_
X-MS-Office365-Filtering-Correlation-Id: 128fb683-31f8-48d5-11d7-08dadeeb977b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /+B/zVzFuMrjty6JLgNpPELi04xH8z+2Z/S3DUM4fVJLxrlB35pb+mcG1mAq1+kQjq3kOpFS40G1a5g67yjpIo/17mmB+Z5S8DKdfYVF8+26K8pbBz/hGtN5o5mbswQObO/RaBJm+27Xq/wS4Vwp5LlfeoFdY0LCwkmExrqsyVkMcXml/VXHjPQ1f2Rkbqc8HqUe7OgnC2OErVEU70H5pIphKEpsg0QxfzItc1mxXLCc1/v2JouLJwfEQSl+TyvaiDoiGjSBzRX68gvB2DlBuY75ShgaZm+U8vJ0vq3hX5QtTWK0UZjdMDxuCWxOU+8ax629ObIyidChdbeMkq8WDVpjJRn9E8lok3yy/wDjjdLvYuCVLoziF0UMfBiV/6Zr2Xmn90DdICZs8axEmQtSkZHkxT/QWtyMS5BWZTlAPQnviWvbK6ZfcMQzosdWJxjorc6lT1J2gaNrH3Ft2ydUxu+XRPyFl0bzR15XFbHRqmkgQy2j+1+sFRXa5LtSq1UQ98KAwNqYNsEyFncCjW9hGGp4ZbHlpBCfD26FkLvEZXvupHuRpQId93fij2G1QNX5JjWxqbcibmIAF2SuQJ4HWUnZOuK98BIIvgF2wtsOx0j4aPZJReAGfAT6Uvnd2PO6sCLB7pyp3MInvmiFgkEMXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199015)(83380400001)(86362001)(8936002)(82960400001)(8676002)(38100700002)(5660300002)(66476007)(4326008)(2906002)(66556008)(66946007)(41300700001)(6512007)(6506007)(26005)(107886003)(9686003)(6666004)(186003)(110136005)(316002)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gW6QP/fjZCeFcAyoXxCW+qH/+Pt+D7cGyHMjGmHPwYAn7LU1EXSzKdShV1Ez?=
 =?us-ascii?Q?Y7K9fHBFcCPAT1GJVSOZZqNx8nR3YuZmpG1vc1c26HtdNDrcDho0uHsv/fHQ?=
 =?us-ascii?Q?aRz2LMsEHl+AoDJ3+rZxSUgsF5wRkKdye9/EphwzTqZqM5JqoM9watUMXSsg?=
 =?us-ascii?Q?dC0NfeE0E9gRC890+OJiCftz+UkTFuk1toxk/Vm1Thz1tf5R3bpyN19tUseP?=
 =?us-ascii?Q?Jlj4osQGj9yLi3cgcW4m/PfNr1oy5T/u8WvwJpv2WW2LCQdxpGHTu1jXGzby?=
 =?us-ascii?Q?64T4eeKgB/WD+GWFNWLoDvJPs8FPzCFzKZTNOb3qesLawl4gazqulsUS4bG6?=
 =?us-ascii?Q?/J2sfjEhKkb/HKfy/na2Ep8KztPKXhHjUwRF521dlNa11BNkYEibwJSMkSiL?=
 =?us-ascii?Q?l82mSCVBPOlRa9LHmQ+qtFv0DUwswcSSfzImPcAVkizaSCw568FI1yjM0kIQ?=
 =?us-ascii?Q?YNJXw6dZQvUme8jre1maN9TWTO7+WA0kEw7soM1O5yJzSoZysvqgAjekEojm?=
 =?us-ascii?Q?BU17KXCjgbTZIJ3O1ppPeERo5W+kYITJugl581GJH4yoNN5r+DKh837htfiQ?=
 =?us-ascii?Q?5l6l0xFhkLdQ6Sz/xdCpq5327KYSYPt9u1Byjf76II51QTgfmNyEuT3X0KZ+?=
 =?us-ascii?Q?SvxhalljaTLnLDnK14fS6Fa+iYTCMIKwD4xsbCsdTj5rDq7ft+/YysPp1VG7?=
 =?us-ascii?Q?CgynUMqvEBbvtYCSVXHDIjvZ5EhsuZbNBMZyBcVjBISYT+NoU5TE8DMW050b?=
 =?us-ascii?Q?a09toFwDwC8nq7rwhfKytviob+wKJ2AqoHbLLryVzZ89dBsz6MFjatsg9TI7?=
 =?us-ascii?Q?GuCbolJWNvB7QPp8HiY/KTYHgWWHexPKeI12xsQZ4F1fXkt42S4a3MR8VfxV?=
 =?us-ascii?Q?ht7rUlRo+VF8npcZcqQEmScAb/pYueJyBE5xL91Em697TrZ+lvhzd+7mFeRU?=
 =?us-ascii?Q?BWQXraOgw99YkV2y6VpWKWlM1WTweOBY1IeqzvfWLfjAT7uBtUqVsOpTStmF?=
 =?us-ascii?Q?BWnrNYdo3PQIhzJUotxXl1h6hijqp31q4qRkR3NLkdEBB7ZnNYD9FTt4JvCA?=
 =?us-ascii?Q?xvq55jKIAEUUhMw1J5XSszw0lA4i13i7UiMQbzveiOr9zMcQ5O7mDVaSDnf8?=
 =?us-ascii?Q?hwKNXeBe4utIcF0yh0LyzGb8SDw8bXKFpeFQifAxLhJWMtZaGazHVTvWFU2J?=
 =?us-ascii?Q?lX8K7dZnGxrTH4dZYD4cQCgDBtsBN+3WxCvNwQBpPniPgcwvG5JFdaLFbOP+?=
 =?us-ascii?Q?N1RNK+BAMvasYck07dhFNjqEkYcKO9nYAc8X16ob6XaOLK/x3GCuiN7E2C1s?=
 =?us-ascii?Q?+tgmlLKxFrkgT+tyUD4f+D934iL/Ti+D+XwJAYl4YA+88UK+7jIsSMTObDpQ?=
 =?us-ascii?Q?+RVO0jAYMydwz2entZDjMQXBMPDb2/bddAy6Ur8nMxpnNUTuOxTc/KwMUj7N?=
 =?us-ascii?Q?oUHu5zQZFkjdqXW5W1DCT2UJnFCaiUgMq2g6LbzE41FNNGDxeAgpwP5bujGF?=
 =?us-ascii?Q?qlPvwr5Vab6IxL/jmMBVz0FRdy2exbJi7/twR4AIxBM6/gcOFqE6Q7Ofp/uR?=
 =?us-ascii?Q?MVILeV/KKH4Z86hLTTtOYZacAq4y9pEofLdX+kBNeJf9FUpXeJryw3t4b2oV?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 128fb683-31f8-48d5-11d7-08dadeeb977b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 22:27:46.9733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RArKWj7lbtC+l+wL9CVTbTHWKo5NhaR/in5tLzE2crrWLsrjpXhgLD7N6w1cDDhj7Cx4t/FrHHJ/WoKa2OU/dxdQm+vu9vqVJv9IF/Nx1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7397
X-OriginatorOrg: intel.com

Jeff Moyer wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
> 
> > Dave Jiang wrote:
> >> Add a CXL bus type, and detect whether a 'dimm' is backed by the CXL
> >> subsystem.
> >> 
> >> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> >> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >> 
> >> ---
> >> v2:
> >> - Improve commit log. (Vishal)
> >> ---
> >>  ndctl/lib/libndctl.c   |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>  ndctl/lib/libndctl.sym |    1 +
> >>  ndctl/lib/private.h    |    1 +
> >>  ndctl/libndctl.h       |    1 +
> >>  4 files changed, 56 insertions(+)
> >> 
> >> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> >> index ad54f0626510..10422e24d38b 100644
> >> --- a/ndctl/lib/libndctl.c
> >> +++ b/ndctl/lib/libndctl.c
> >> @@ -12,6 +12,7 @@
> >>  #include <ctype.h>
> >>  #include <fcntl.h>
> >>  #include <dirent.h>
> >> +#include <libgen.h>
> >
> > This new include had me looking for why below...
> 
> man 3 basename
> 
> >>  #include <sys/stat.h>
> >>  #include <sys/types.h>
> >>  #include <sys/ioctl.h>
> >> @@ -876,6 +877,48 @@ static enum ndctl_fwa_method fwa_method_to_method(const char *fwa_method)
> >>  	return NDCTL_FWA_METHOD_RESET;
> >>  }
> >>  
> >> +static int is_ndbus_cxl(const char *ctl_base)
> >> +{
> >> +	char *path, *ppath, *subsys;
> >> +	char tmp_path[PATH_MAX];
> >> +	int rc;
> >> +
> >> +	/* get the real path of ctl_base */
> >> +	path = realpath(ctl_base, NULL);
> >> +	if (!path)
> >> +		return -errno;
> >> +
> >> +	/* setup to get the nd bridge device backing the ctl */
> >> +	sprintf(tmp_path, "%s/device", path);
> >> +	free(path);
> >> +
> >> +	path = realpath(tmp_path, NULL);
> >> +	if (!path)
> >> +		return -errno;
> >> +
> >> +	/* get the parent dir of the ndbus, which should be the nvdimm-bridge */
> >> +	ppath = dirname(path);
> >> +
> >> +	/* setup to get the subsystem of the nvdimm-bridge */
> >> +	sprintf(tmp_path, "%s/%s", ppath, "subsystem");
> >> +	free(path);
> >> +
> >> +	path = realpath(tmp_path, NULL);
> >> +	if (!path)
> >> +		return -errno;
> >> +
> >> +	subsys = basename(path);
> >> +
> >> +	/* check if subsystem is cxl */
> >> +	if (!strcmp(subsys, "cxl"))
> >> +		rc = 1;
> >> +	else
> >> +		rc = 0;
> >> +
> >> +	free(path);
> >> +	return rc;
> >> +}
> >> +
> >>  static void *add_bus(void *parent, int id, const char *ctl_base)
> >>  {
> >>  	char buf[SYSFS_ATTR_SIZE];
> >> @@ -919,6 +962,11 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
> >>  	else
> >>  		bus->has_of_node = 1;
> >>  
> >> +	if (is_ndbus_cxl(ctl_base))
> >> +		bus->has_cxl = 1;
> >> +	else
> >> +		bus->has_cxl = 0;
> >> +
> >
> > I think you can drop is_ndbus_cxl() and just do this:
> >
> > @@ -981,6 +976,11 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
> >         if (!bus->provider)
> >                 goto err_read;
> >  
> > +       if (strcasestr("cxl", provider))
> > +               bus->has_cxl = 1;
> > +       else
> > +               bus->has_cxl = 0;
> > +
> 
> Can you explain why this is preferred?

Just less code to achieve a similar result. I do like the precision of
looking at the subsytem of bus device parent, just not the multiple
calls to realpath() with dirname() and basename() thrown in which struck
me as unnecessary. How about this:

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index c569178b9a3a..76bd7167bc70 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -877,40 +877,16 @@ static enum ndctl_fwa_method fwa_method_to_method(const char *fwa_method)
        return NDCTL_FWA_METHOD_RESET;
 }
 
-static int is_ndbus_cxl(const char *ctl_base)
+static int is_subsys_cxl(const char *subsys)
 {
-       char *path, *ppath, *subsys;
-       char tmp_path[PATH_MAX];
+       char *path;
        int rc;
 
-       /* get the real path of ctl_base */
-       path = realpath(ctl_base, NULL);
+       path = realpath(subsys, NULL);
        if (!path)
                return -errno;
 
-       /* setup to get the nd bridge device backing the ctl */
-       sprintf(tmp_path, "%s/device", path);
-       free(path);
-
-       path = realpath(tmp_path, NULL);
-       if (!path)
-               return -errno;
-
-       /* get the parent dir of the ndbus, which should be the nvdimm-bridge */
-       ppath = dirname(path);
-
-       /* setup to get the subsystem of the nvdimm-bridge */
-       sprintf(tmp_path, "%s/%s", ppath, "subsystem");
-       free(path);
-
-       path = realpath(tmp_path, NULL);
-       if (!path)
-               return -errno;
-
-       subsys = basename(path);
-
-       /* check if subsystem is cxl */
-       if (!strcmp(subsys, "cxl"))
+       if (!strcmp(subsys, "/sys/bus/cxl"))
                rc = 1;
        else
                rc = 0;
@@ -962,7 +938,8 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
        else
                bus->has_of_node = 1;
 
-       if (is_ndbus_cxl(ctl_base))
+       sprintf(path, "%s/device/../subsys", ctl_base);
+       if (is_subsys_cxl(path))
                bus->has_cxl = 1;
        else
                bus->has_cxl = 0;


