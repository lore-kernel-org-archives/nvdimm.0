Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F81D79D0
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 22:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675894076; x=1707430076;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=fnXNns+DB6ZyWrMz+1N0kiiMtB7MzEB89FTBokGqTL4=;
  b=DGQxOGv0NnLnufgw2vrhMs/F3sHodvL0WsaE5iMRMO9tNAwohxsdppdK
   2v2cIBC/QWiQAZBk1oyCxn2HR/V963IKgrYESzRuMvnQIKy/OY0Pl1dOT
   LvLRcMmcW9Ze4AyTE0STe0obHpN2CpWO6J2XRtsL4Sc+gz1HVNMqzcLIW
   z3W9IeuqKnCX4OWKb9DOia/p6y0Fl8eJVrAJsFZe6+6u60XyggK0vzsiL
   Uso6nxJPYQAHnAiXVeNu9MfU7PPJL+AOaB4o/i2biEdxikNjNTpkEM4hy
   nic7gG5pjxh87M3l8sCPAT1Yi2SWzhA8ft+cildfmvk96oEl0UZtYm4J9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="416159538"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="416159538"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 14:07:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="996305324"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="996305324"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 08 Feb 2023 14:07:47 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 14:07:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 14:07:47 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 14:07:47 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 14:07:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5VAqFLtoVeAmupJc09F+HA1wQaSK41/6s3/e8WVO/MSpbmJ3Cta61s8eSY6siejDHs72n6wYoE4R49mispogVCbBjo1Dx9qTUSqcOmJImsuloAfp13BEPaX5mBAyrCtHUSE6eCb5FHkEKD5GRG5X9lf5HVR+LYyCrlhBNisv7hcSdHXehAkijI5LL/b+5hoyB3eem2GHqpseVZd1zBHk2aRs/QXJnjo/gnh80RV5DaGv0OdRH00MuoMBoOAFHIXzG5WYdfIR8FyIjsGT5F7Y1MDoV0GvSziTifJzhWGppkFKVLILj7caZ4RbQ34wo9K4Pt4xeD1pl09yWVRmtE7CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=if6K4WIt+jtZ9UNHdA+T6QrRQh5RwbM9nytiHiJ9KXI=;
 b=hmlyvv/228FhbVi7QEyCHbq/NMbLyX+m2N84dJ5pr5tyzm53+AcQwL162GAtsKGGE1eu9bthvDYnDrPUkorelNMDoMq4Na8R/5CeFgTVlkGw5T4LCsyJ/a+iFtgcjOwgKAMDDS+nII+amzM0neIFwzPPyU2nD4cPgU27UatjcHwrqUQT/3a+/QFOCtTTHHtjDsAwWRiu1nNo1b4VpSWJBip6CuKCM8dvsLi5wRii925yWGF+lSU8lNQMgp1ANzvmqbhGEu1KyHgAc1qhsa6Zs3DXF0h0bxllDLkCfblgufw2aglJvtqfiBW53XVacqI7rh21UQfL6SKR8pHLy2h0NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SN7PR11MB8027.namprd11.prod.outlook.com (2603:10b6:806:2de::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Wed, 8 Feb
 2023 22:07:45 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6%9]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 22:07:45 +0000
Date: Wed, 8 Feb 2023 14:07:40 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "gregory.price@memverge.com"
	<gregory.price@memverge.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
 regions
Message-ID: <63e41d2c5512b_11f3dc2946d@iweiny-mobl.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-3-b42b21ee8d0b@intel.com>
 <63e31d2bc5178_107e3f294e2@iweiny-mobl.notmuch>
 <544c4a34207fe45195472451730881991f541ec4.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <544c4a34207fe45195472451730881991f541ec4.camel@intel.com>
X-ClientProxiedBy: BY5PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::11) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SN7PR11MB8027:EE_
X-MS-Office365-Filtering-Correlation-Id: 1da29ff8-a7df-4011-c834-08db0a20e7db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kJ+V94LLqrJgyV/JpIt2ylQqh0LoLrNJvzSWNtJaaVpcaGRydxe076JhSLdPEJwzTKGgWKlcm6QDSvLo4DRwARrnVhgtum3xezT79Iqub8W6xm5oJfqPgXcKHWZw2OtPYiGiXds2A1pp5v7LE84G+LKAifsnl4204u5yUIbgxTbJLg89tVYa2ahOyoqRQW38AWZBgLt98AxP0uHGKUNkBQhEbAdKyLNHCzljQBE0W39niwdNWHw2S5Xs/wPJyROmSjhoDLkOKm9X8rkybtfiGdz4++LPPlg3VpVsgN61pp9sGWCL2GArwVp+6J6kN3V9CmEo9tIqY3KXOS67rCEn75g4I6zgv6Z2Ur0Ay8D2NRgwmQ7jiiaSi86IVhuLCYDbm0EydvKc1as1iW5GtKIZCs1L3Hib9uvxbTjY24qFSldXFbP8gI1E3NDmqOLKyFt3T4/F1MiswXAREZKKrs3mbrEHgIHRGVtKefiylJRlMdmWPeIpFHlm6LxVgSzHYhiAAI2kb6M9tU6nQsJ0CflHq3iuYI59VUQ4Fzq5WKM2SXIkBvKZQ6ctUsd0wauogTrgqzLavaiRjBa8fwVAEn1yCqljuC1G1t5XwJ2GtDyaKVxasXjHLFzjGjLAMz36S+tg67UP0xmCmxLklhmqmXygeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199018)(6506007)(86362001)(6666004)(6486002)(478600001)(6512007)(9686003)(186003)(26005)(82960400001)(83380400001)(38100700002)(8936002)(8676002)(41300700001)(44832011)(316002)(54906003)(5660300002)(110136005)(66946007)(2906002)(4326008)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?4WG+7t9unZMlPCAmTujQ3WC5h3c5NANHj+XvhgBJlGpimHT2BbPu6vDdwR?=
 =?iso-8859-1?Q?csvH4LJW+av2/b73ekMMcrBSuncvUq6CqOKYyXf726BOvU8tNUueUtDr1R?=
 =?iso-8859-1?Q?41sQQhbQW3kqSNP1G65Xa0nbyIuoV4ptcuwYLEG5smRrCRHG8Becsmr0H7?=
 =?iso-8859-1?Q?bHYu6Fa8XxBYqEfwZ0KTl8H3AyurhEXJt3n3ZDRkZNY/g6gZh6Giv6fmlH?=
 =?iso-8859-1?Q?5Bevy6U60cNn1b55Q6il4m+ByTdW2zCYfwQXkFM23dhsVuxx8w2jypnSVH?=
 =?iso-8859-1?Q?VHCNLLnCRQKZIvkyml+Rv7b7awZgMPOrOQnrfcPqG50MBi/+TMmgDLyTbL?=
 =?iso-8859-1?Q?1zAlushSg95eOWZ7qB93PAHmpkWicrp88dnXNkwMTkVYm7yT9vF4KX5/hl?=
 =?iso-8859-1?Q?im6ypAgbDNAt7MUOrEmDJmyadSq26gTZQsNjAvy2zgACkTmIm65/QPyidG?=
 =?iso-8859-1?Q?9bBpKDyKSw4DUO7JK7EfBi/LUlm+lRMHMyTfoDujuadvKnEWitJMjDbb2F?=
 =?iso-8859-1?Q?C9CPrMErg6V6kqSDn5A9HWqs1CYQz9y6xnSkTQWVOLPCTS1CUhjWlG5hSo?=
 =?iso-8859-1?Q?8oTFMOjkx+AYtbBnndkWAEFW6iQZTtTzjSbFEhZA/8aP0fXUFp1+3RzOrC?=
 =?iso-8859-1?Q?S0Y0ngPM89ZcX5B3vnh5UeeuF7e9A0tmGWzOyyj2ofo95ypkperue/zSLb?=
 =?iso-8859-1?Q?udepMv6XSJyugJ+NSofI6resL2tiMiINKckfocTFLg1ub5sd61AUD5RdrD?=
 =?iso-8859-1?Q?Tx4ECfxgE4yFNOXA9EAC9P2ejiKvMIaINfN4gvU2inFOV6m0NoCpCb1SrC?=
 =?iso-8859-1?Q?LjAQfJYBb1WFyVOtYtrMhnHyivf1zSrrcoWY1lRRC6QotB9PsU33/yOp6c?=
 =?iso-8859-1?Q?C41Y7jsVmHLQcAqGdmFVfnkG9gbfZLrPYCNmAxGfMcANbBD6xrg4kVd3H5?=
 =?iso-8859-1?Q?7AFKB9vs71ubUdImzYnVD7OviWQ1adLBnr5ZyvMyMwS5yAgM6e5aLTyPxc?=
 =?iso-8859-1?Q?ZeKM2OQ9IWN2Qc4Rr+9RGFZbEvQsWXPwitu6Dz5+g3guO8le+FyQLV2Cw4?=
 =?iso-8859-1?Q?YbpaoP1yXPbyOabnmdz6AY1kL0x9QE4yJrnXu7/+jdiIkF/ZuIe49Av8X4?=
 =?iso-8859-1?Q?44+bwj3jTRzlI31QP11zs5eg30Fz7m59WVDjU3EYFZiGLINntWQUqLi/gf?=
 =?iso-8859-1?Q?gWMcksjSukW124jCPC82WiLqTUzb5QmusJbCIk+bM9UOsCUXJOqflxhMa9?=
 =?iso-8859-1?Q?2pPnb2w6xkmxcn0AWCKEMhYfmiUrQ0ovmRWbQLtM8DvScWwfwuQ8Rt+Vcf?=
 =?iso-8859-1?Q?sqTUlPknFWHB6mLMwxo67783/aIqFE7oqHYILnICqq3NkX8tyq3+ejgEx1?=
 =?iso-8859-1?Q?6zGBbFiyHtIk6zcaBWifyFGVVPDyphb0adp+xGS80DvBptyzHdjT9muk8T?=
 =?iso-8859-1?Q?JiO2EhyHGPpGY7y/N3x2b6EGO/wCCkyo8o4U/AEZp46GRkldctAy+c2QZA?=
 =?iso-8859-1?Q?CYHIsRnMOCmFAGElp3/5oMLcfVwENVaTuipGN09MKNjHaShvb6YAzbSN4h?=
 =?iso-8859-1?Q?FFT335TloFvuaGVCeTMrKaW7F4E2X+jw8YM6oRcRVLKvx2ZFoYbl/mGvVR?=
 =?iso-8859-1?Q?pYbK4qodzIoIk5RiZKJn6RtOuh2B/eu6GIhgKezbVkBXFqnJSH7DI2TQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da29ff8-a7df-4011-c834-08db0a20e7db
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 22:07:45.1509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Q+Boyr+DIysAPF32Y5f2/38W8SqwdfV9sePTTx2cST+Fo3LzGoBGDRULQE+zmFXbUKYooL5kff++0fcyTRC6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8027
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Tue, 2023-02-07 at 19:55 -0800, Ira Weiny wrote:
> > Vishal Verma wrote:
> <..>
> > > 
> > > diff --git a/cxl/region.c b/cxl/region.c
> > > index 38aa142..0945a14 100644
> > > --- a/cxl/region.c
> > > +++ b/cxl/region.c
> > > @@ -380,7 +380,22 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
> > >                 struct json_object *jobj =
> > >                         json_object_array_get_idx(p->memdevs, i);
> > >                 struct cxl_memdev *memdev = json_object_get_userdata(jobj);
> > > -               u64 size = cxl_memdev_get_pmem_size(memdev);
> > > +               u64 size;
> > > +
> > > +               switch(p->mode) {
> > > +               case CXL_DECODER_MODE_RAM:
> > > +                       size = cxl_memdev_get_ram_size(memdev);
> > > +                       break;
> > > +               case CXL_DECODER_MODE_PMEM:
> > > +                       size = cxl_memdev_get_pmem_size(memdev);
> > > +                       break;
> > > +               default:
> > > +                       /*
> > > +                        * This will 'poison' ep_min_size with a 0, and
> > > +                        * subsequently cause the region creation to fail.
> > > +                        */
> > > +                       size = 0;
> > 
> > Why not change collect_minsize() to return int and propagate the error up
> > through create_region_validate_config()?
> > 
> > It seems more confusing to hide a special value in size like this.
> > 
> Hm, true, though the default case should never get hit. In fact I was
> planning to leave it out entirely until gcc warned that I can't skip
> cases if switching for an enum. I think the comment is maybe misleading
> in that it makes one think that this is some special handling. It would
> probably be clearer to make size = 0 in the initial declaration, and
> make the default case a no-op (maybe with a comment that we would never
> get here). Does that sound better?
> > 

To me the question is whether size == 0 is an error or just a valid size
which something at the higher level determines is an error.  To me the
default case here is that mode is incorrectly set to get a valid size.
Your comment implied that as well.

Having size == 0 is ok generally as this is a 'min size'.  So I will not
argue the point too much.

Ira
