Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB1B79D0
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675894205; x=1707430205;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=FIOQfBuy5ArlR+S/0YsclsAyUeXscf4bBlEiLDKM5Jo=;
  b=QVkwieovREXwSfud8TVQsP4OxQW4w0jRUdVg3rugSTEGlXxr1EHyIqN9
   5FENWwaOeWbvoqQ0DQ+On5v9Id7oF2xcS589Dt9dgdmYBAR/yOpXgL0oe
   eny0iL9Kp91Fsv4EfK6BjGZgsMe4+PIb1xSy85nbppWfWcQ8YRy0vKky8
   jqDvjjlw0N6m8ThDK7zjxtZekNFjm7apd/ndLzggstzMtkMd5MYf1Yzs+
   I8hxwSTKOcIM208AthsI8swf/9GlLidYShaJ2DtTymTjFss8738dyhfBJ
   oF1e1SWWGglWRUZbeKYHUf5BZlbCqVaYU28qmfhh3k6K54t1Tz8auwzoZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="392332067"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="392332067"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 14:10:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="736070848"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="736070848"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 08 Feb 2023 14:10:04 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 14:10:03 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 14:10:03 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 14:10:03 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 14:10:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIAoQVSHrGHrl3FRXuelL2YpgDKEKk76HDRQ95K4ixKDJpsdOZInd9nHTjh87fqU1XYMphEnckF4XWQ9+0QAbMncAdNAR6jt1DKPTrYoiEIjRlezkavi0Wc/J/4CGHmj35A6+yhXNTwM+Per0SZa0uwDKWm3UBxSH20BDRcfiJpxtsA71fum3BJ5GO3G8FHDFp5Y2dIbXFSKxB7Y5I7dXTY5dJDCn4NcA6Y6hpXeG4Md4aci0/lzBRcuM/k1FucrrUpVqGx6dg3cb1RF5hwi6xBAgpth0n9l8AeLxxuMX/CrfpEucKcc2DHiUcfawEBtvuvCNVFzHkQwlUpIAZRvZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8nb5212QVtj3NqpC6wgB62Fj30u8NjPk4zI+0XccMo=;
 b=hmm67peaCj5nZs12akB2SIhlsvnlPft8PLRIKIlsUyZz/VhhGH2bmKQYAfJCihFBhHRJ4mRrREBhoPZEUakN9WbkoaB+tH2ZF+kT60N0RRxyCTXtyfTes1DJUsfauNgSQsegLR3z9bzxkz//YBFpIWOVKZgcrgbfHQLdtMUY4RLmMy6hHOsdl/04nYBWg5GdBaaG6pBOb3eUkAzEJXBxmC0za7FDq+fT22aglJ+DmU8yF6SqGt2bP3pj5Ru/9FSJWO1cU8yIs1psf6TeXs9arIdqIdzxPLrOp/S7z4k5M7I5eY1XczvgX5whvdX7X9pex8hQ0ZXfYoGwjRkXIoT57A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by BL1PR11MB5399.namprd11.prod.outlook.com (2603:10b6:208:318::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 22:10:01 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6%9]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 22:10:01 +0000
Date: Wed, 8 Feb 2023 14:09:58 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "gregory.price@memverge.com"
	<gregory.price@memverge.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 5/7] cxl/region: determine region type based on
 root decoder capability
Message-ID: <63e41db66b2ed_11f3dc2945b@iweiny-mobl.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-5-b42b21ee8d0b@intel.com>
 <63e3200218c32_107e3f294ea@iweiny-mobl.notmuch>
 <15becd4bfab3935be3fd1cbb2f97618a9870dbc4.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15becd4bfab3935be3fd1cbb2f97618a9870dbc4.camel@intel.com>
X-ClientProxiedBy: BYAPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::33) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|BL1PR11MB5399:EE_
X-MS-Office365-Filtering-Correlation-Id: 9df31f4a-a211-4c6e-ee5a-08db0a21392f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MGdDvZpMq3i/vEIO5GF0r3Ia5HK0YzpOr5pISYLFhBROHAIuJ3EiZjpAGE+tYj8TG/U66Y2fik9uMeJuw0QSAjgPSodtnM02SN08I/QpEEzx6MI8tEWHWQ8FEfQtUwzOqgzV+lqpEqVIcVW3POPeuwnZwv1VTQczDTs+XOixSbm5l0X8R5ItjXKLpfxFRf1JPo/F3ivj4WG5Qxbnt05bXsREtxNcGvGGBMIXlAHKYsTK0epTLvi7B87S4smofTOsVXyckoh0j7ObvjwhV3wmMuUI5dIFDMGse8S64ilFKydryJIZeKXI5sqo6jjVkZH1J4hzpD5zc5b8m1WLD9Bk3cE7jL/goLvoiF8vjyL2+CM87fGRytgpH6zhK5cl/NDUOpIrhK4zUN5XT4U8YKtVoqwvbKn1HxnW8u0n0lNYcag9q2aBMiaCYCqItuUBimgKVhGSKD/JlJ7t8tvUTqN2Abh1zJ+ng9MNfb1r9AzA9gggNt1KhE3WbQFMwhLD0aC0spkMcCEdNZv+UFBRnsP2z1A3+iX4WCZIvNANrf5k9rlXrorMGV9dYPkic9F/Mws3+sI2U+J+XbuoTCuLNxhQ6v9sRpSOeE5/vWnnFaO3zUI3Z4PmSYbimjF29tXkZnQqaybEWNdx6J0lIzIsU5mhkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199018)(6506007)(6666004)(6512007)(9686003)(26005)(186003)(316002)(2906002)(8936002)(83380400001)(54906003)(110136005)(5660300002)(44832011)(478600001)(86362001)(6486002)(66476007)(66556008)(66946007)(41300700001)(4326008)(8676002)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?9OaU/s9Hwla0hfPwEyfOdsp+NGLmOp5r7UBZxUO9uCUG87ux6aRzQOkms6?=
 =?iso-8859-1?Q?k8i7t7Zi2VmG2ZTajMqSVEfF89X/iFsna1805CM4p06JSY5pyGVK0hrPYX?=
 =?iso-8859-1?Q?qq+K8wC6/KG87mlek7Wye51nIf2q0LkScDC+ieNJu3KcW2kEHZGEl9BQBo?=
 =?iso-8859-1?Q?188Ya55VR4CKrlTj/uvlAwz3gi0iwIROPQ9Tmjrd98hb0juufx1fwDC5Ru?=
 =?iso-8859-1?Q?SNcptA4eE+6bzzGELESAAdMywzOR17Ptr+ehkkOmvRzpC5Yw66DsCJTsEu?=
 =?iso-8859-1?Q?xtKVrEFNrqIde9N2Xc0e3cAXo/xpZjeTYwIgJCE3znd9xQwsUQ4OOEvvcY?=
 =?iso-8859-1?Q?CW8rE/wSk4IbM9SNhFAb4ax/5EwgBjVNmoaUI+ssNQxkWQuU9iIwKqN/Ac?=
 =?iso-8859-1?Q?Zg9RB9XbQ/UGLQIZzr89SKyJwE0wW+bjrTp4zaURGfHVBquuq4fmIS9OOD?=
 =?iso-8859-1?Q?y9ow5Xq982T+X1peF4wRUxAUZbgfO6WulCJHl0iV0Eec3BaBk2A2IntClu?=
 =?iso-8859-1?Q?mP2sZrozHkhsxH5hq5fRuxDOIhgQ6CR7tv9w0cQb7DopGwke5uWkFkXtr4?=
 =?iso-8859-1?Q?zLkhHb/U/x7imI5KUpLfBWQnmnVeESyuTLFIRxCeAcEw2FtDAUEYtttFMz?=
 =?iso-8859-1?Q?DTW0/cd/1TgCUYoukocSUd1RNEpkjNPV9Tq5/j6sm8R/RVv02jk1B2gZmU?=
 =?iso-8859-1?Q?zki4Ui7Y8WoFQApZuwKH9GZeWkRbsrJPhDOFLvTBvjC2O9dtfsM0dxrvYZ?=
 =?iso-8859-1?Q?RfivwpfDn2peG0rBZ+l/EXKmjrVaWo/rxB5EII75eIgSrCKbIwZz1teSLW?=
 =?iso-8859-1?Q?M26Vky2EhUECeeCuB1Et17IMR0sXjzQ9WWbaseMHqXeqOzgFHu8lK8C3eR?=
 =?iso-8859-1?Q?bQ7LJ8OAhThc9IGab2sn8xfLvTMhUDIEHzxPmFmtm+OT7qImU/VqLBD6ng?=
 =?iso-8859-1?Q?X/kadTrVX8z/6NHTDKLY+atRuxcI2uiTeMhVLTDYDCsqtjC/pjf1LvuII/?=
 =?iso-8859-1?Q?Pf3VRcSaeiHRwNynRv0PD54Z86BKsS1yeUeUqhT/mgIjdxmeF2MAohf7t0?=
 =?iso-8859-1?Q?0V+sIxwCAyoJT1ackPKZtYW+MqSxhxX3mqZuZ7s2wc6OrP1SJlWOhsGLkU?=
 =?iso-8859-1?Q?1j0UcXwHyGlI5Ee/vmPW61s8XDNmKbJWdr5eeHMxBlHpp2lJ+nguDPg0Uk?=
 =?iso-8859-1?Q?MIBf4gYKM8LWVgj3NbHG4x5qOTCohDRQGLHfmpGJokNRBorodRfC1r1+4I?=
 =?iso-8859-1?Q?JSJoTk4Z2R7Gn3C3nIQWQzAn68RIB7WuSIRtqiQ9/8HmkoLFa+HcEiyekK?=
 =?iso-8859-1?Q?arWawDioPVhHvtbGLI5aFflkkXnT52dqT6URaxsUFIQRTazmgxCwIrXYZa?=
 =?iso-8859-1?Q?P8w4S2yyMv0CAvvvk85HHCh1HjrIrVuRdI2JaRquaJuuHa0XU2NIiD7KQ5?=
 =?iso-8859-1?Q?c08RcM5nikPtj4zLHHGWoHHiObtbHX+c42b9ilwVVfOofunD53mbMWCbZT?=
 =?iso-8859-1?Q?i+gjLWaj/+WT9LCMhSgD27QMbt2eZgbrDuv4ObpZQG1bw9kIWR5PGAIrXh?=
 =?iso-8859-1?Q?hHmpOguTwvpZVY2SpDTBTb3BzhsGNjNYjJyalQhdOHGJkAXJXEYsk9UzPo?=
 =?iso-8859-1?Q?kbwX/u/zyNZlZJA+qi6vHBAkV78eaOJDl5O252PE0vfoPRVygCGMlQCw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df31f4a-a211-4c6e-ee5a-08db0a21392f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 22:10:01.4885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lXEL7N6EH6Y52JwsIsCYZWBiCbxQbOF2c8IhS5aBmj+9kN61nfVq0E/B6uYxHDdN6WKb+8SkwVaFEq7PEWqt5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5399
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Tue, 2023-02-07 at 20:07 -0800, Ira Weiny wrote:
> > Vishal Verma wrote:
> > > 
> > > diff --git a/cxl/region.c b/cxl/region.c
> > > index 9079b2d..1c8ccc7 100644
> > > --- a/cxl/region.c
> > > +++ b/cxl/region.c
> > > @@ -448,6 +448,31 @@ static int validate_decoder(struct cxl_decoder *decoder,
> > >         return 0;
> > >  }
> > >  
> > > +static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
> > > +{
> > > +       int num_cap = 0;
> > > +
> > > +       /* if param.type was explicitly specified, nothing to do here */
> > > +       if (param.type)
> > > +               return;
> > > +
> > > +       /*
> > > +        * if the root decoder only has one type of capability, default
> > > +        * to that mode for the region.
> > > +        */
> > > +       if (cxl_decoder_is_pmem_capable(p->root_decoder))
> > > +               num_cap++;
> > > +       if (cxl_decoder_is_volatile_capable(p->root_decoder))
> > > +               num_cap++;
> > > +
> > > +       if (num_cap == 1) {
> > > +               if (cxl_decoder_is_volatile_capable(p->root_decoder))
> > > +                       p->mode = CXL_DECODER_MODE_RAM;
> > > +               else if (cxl_decoder_is_pmem_capable(p->root_decoder))
> > > +                       p->mode = CXL_DECODER_MODE_PMEM;
> > > +       }
> > 
> > I feel like the default for p->mode should be moved here from
> > parse_create_options().  But I'm not sure what the flows might be like in
> > that case.  That means p->mode would default to NONE until here.
> > 
> > That would make the man page behavior and this function match up nicely
> > for future maintenance.
> 
> Hm, do they not match now?

As I said it is correct.

> I can see the appeal in collecting the
> default mode setup in one place, but in my mind the early checks /
> defaults in parse_create_options() are a simple, initial pass for
> canned defaults, and conflicting option checks. Things like
> set_type_from_decoder() are more of a 'second pass' thing where we may
> do more involved porcelain type decision making based on the full
> topology.

Yea I can see it that way too.

> 
> > 
> > But I don't think this is wrong.  So:
> > 
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
 
My tag stands.
Ira
