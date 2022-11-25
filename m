Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26782F41
	for <nvdimm@lists.linux.dev>; Fri, 25 Nov 2022 23:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669420712; x=1700956712;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=C72uvFVFXWcquhzxD22GQJz9qY2Qiv87SlwuYwUNy+c=;
  b=VuYGp3jkbR5kXHJlJX2xKNVI+EELfdFD+ZySTBgvPRWVlJbxSb2cQAR8
   PA1ivqFzOV4EbHNrekWpcffNrmpTSPjhzuijIBozBoASs7jae4FeZIJJP
   jsJ/hE+cIWGNq6POwu2bhXXBSXl2QlmiwyIEk2Sk5XgLGvqUMbXMI7kGS
   eTZLz4QcY5R/GVt52Hws4Us8BRpC5rphRuqDlZO2r0izbxDN5zKUhTLZI
   g9sTWmJB7VUub8/Zj7AA/mq4oPkTX9dhJWB/OYOBjop+fOOvuN70CkQXL
   Zyp2wmE1Fs++QWb93na5l6KivT5IayLO5sfQmxYe/nPE5hsm0TQM38LAo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="376694740"
X-IronPort-AV: E=Sophos;i="5.96,194,1665471600"; 
   d="scan'208";a="376694740"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 15:58:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="887810057"
X-IronPort-AV: E=Sophos;i="5.96,194,1665471600"; 
   d="scan'208";a="887810057"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 25 Nov 2022 15:58:31 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 15:58:31 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 15:58:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 15:58:30 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 15:58:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTUYWS+hzkVc73wtxhIv/Oi73gUg3Yd0UBRPRT/eM0nk/hRGbP4ZKP2TH8IXqA+ulD+lLrKY/SN1kqsXuddPP6xT+8vWCfGqWUHF7DBz+oybGYGCnsXyOF5OKFiHQhcFpZhgceWQoPGbm37piOL/ISf+go45SQB5ubrkS94tW5prtiVS5s0z/oVCfC7jzYj7tr5EX3a03KXbr8sYzBLiHLVkFIj1bi0ffzDHZQl/1ZO4h04dx0JMIN5GTk2H4vYHO/RjMzedfpQIjT7iUwY80mOLogypPAThubuBplO+Rl4fuF0dtNnlqsx1ENC8+oBQWcJvf6JeUNJWt2NKo2Q1Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zBX+aIPr9egGXwDoLj5a7Hrg9bQINfCMFtt5V/urdPk=;
 b=hdqcy4z2EXFz7d6yoShVGgm+X8u3PHOhI5w4WJYJv2YT1KUQ0qGOwKblPIR+O1AtK1nLW8/ne/WJw5LXH4wjrchc94+O9Hi9xLBUPG9O2fOHDx1CObapyVHn6AwPa5wBp9rb5eRsq50K8xF9h1mVYKGw9neyuu+e6HSvfRf/YidM51vK4I5X7p2GKni7Oq6PYsclzTnfqi+00VbR7nHQwl8odNY9gAJGdC+SvG944HkA301RcVtAWSHg13STlRYTYQpac7OBRUwqjhjNcJWm62nbYFoIz2h43B/R8F22UC47V7HBVifwEUTpPSfnfNWlNoSRhg8dfxZRrpoKtF0sxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH0PR11MB4918.namprd11.prod.outlook.com
 (2603:10b6:510:31::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Fri, 25 Nov
 2022 23:58:28 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.021; Fri, 25 Nov 2022
 23:58:28 +0000
Date: Fri, 25 Nov 2022 15:58:25 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <rrichter@amd.com>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 03/12] cxl/pmem: Refactor nvdimm device registration,
 delete the workqueue
Message-ID: <638156a19bebe_235424294ba@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931489283.2104015.7355891921648975475.stgit@dwillia2-xfh.jf.intel.com>
 <20221125150128.00001bf6@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221125150128.00001bf6@Huawei.com>
X-ClientProxiedBy: SJ0PR03CA0147.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::32) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH0PR11MB4918:EE_
X-MS-Office365-Filtering-Correlation-Id: 49209f98-e83b-42fc-cc80-08dacf40f262
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 29Gz8bLZaiefAPTh8hXE1s4kaJJW/y5EFPROOGMMykrnqDr7fvD0RK04o4/B0+9VKVVZoACWhLUF3BLNwY/M9UjKU/OoOqPH/t0WyHEx6BDl9sykbUkQRngxKWWOac7RCwzMBZoZIk7c14RS1UWusA+4vAoJDmDDmwh/se0v2rqCt+MjFG8HoqyzgdRErgZfXb568TzswRW1zDhJoUrr9EgUUp50E2HaGsSAgd2qLJNknmB/FfoWN5RJQPwBlp3fZCzW1KYB674nPK2js28MCqxjqdUQtzaJ+UBOgW7UzQilWyZXUf1t9rc50p6OaZhY/7QhxOPedrvHBbdHrowUMsWLnw4pPkZkmO0u+7ENGcWbwQfGA1EdaPt8kHqb8wbiJxN53mkRA9Bz+s9LWR4sChfk2q3DIymwH5w+QzYvIvhTqslSc1vB3Pdoe0WReYe314Ards2OZ9UZPf/hnhEsMI7I9O809f5i50akmVQGTDINltkg/O1CuTs3I4VADcrXGva5/A13Bx5NDqqT6gzGLK34OK3E6cPkDYJLZKulPnZcveivRveYT6aaAQqiIkL/6RfmVaP8RFVW3A4SughXMLMuqpsBAlIchyzgmkH8/7L9lJ5uOxNQy/munmnJYPQ5VFYRxt0WkztHBUU/dPILRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199015)(2906002)(8936002)(41300700001)(8676002)(30864003)(66946007)(6486002)(5660300002)(316002)(66556008)(4326008)(66476007)(110136005)(186003)(9686003)(26005)(6512007)(6506007)(38100700002)(82960400001)(83380400001)(6666004)(86362001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mVwZDeEkJ7F2fj5XGaT0wnhAebSql69zf5RNUTHaokbxSu6Zs7NQQHoO7fPt?=
 =?us-ascii?Q?EEzFHiW3QBOyRZIEpjNQCFW4SjT/8qlrrsrJ7HZDkjCNOqPqVMZIQpO9edZn?=
 =?us-ascii?Q?fiJA5ghX5QclPwOdN/m0xhbIhWy8BEvaS5ZhqRVjL+akBOGnKQhm6a5ZBDzv?=
 =?us-ascii?Q?vFpEQnrZ1lgM9vWkxFA/aDzovsZNizwL3eN4OOiOL7nztKjptgZrdohPE4dt?=
 =?us-ascii?Q?A4DKcU7iMdmXiIv5f305/0um5Ix6stmCQ5ZpNI94VtdbmIYco3J0FvNYDpWK?=
 =?us-ascii?Q?reu7XfcWHN29ZZbllqDwf344cmRawAKZA8pqBK9ZWk3FLIE2KmY9wFZstoeC?=
 =?us-ascii?Q?4M+Al7qWhVxdnMzyTLPxAZ+JBGt+4Mslls8E6i1oHkwvSKr1jwzRzyN1p+lW?=
 =?us-ascii?Q?tN6Xf23U8nRXbDpBXGYY38RD7x68ahBn0sjV6Q6RwzTkeYuzyvTsYyMtqf/Q?=
 =?us-ascii?Q?uNjhUIh+LbWZzDd5O4bb8iw+LlGbPHDy0jHJbKRxXaZAjCkRzUBUpd1Jx7hc?=
 =?us-ascii?Q?ZTO5Sj7vb62+LtYctYnoqlzotpX+9lwL3eY+oZpuMIIbEh7YCAijKTJkT+aA?=
 =?us-ascii?Q?H6al4XYioBEN1Ca4qaiiHa2X6HqJoQmnd0F3icFGnz9mJI5ANnCgyvUoSFoI?=
 =?us-ascii?Q?YR8C1qEGx0YxC6dbbJEwfWhf2I43Yc1i+dcwPV+3ygCeGu+51VDW5K6lowUz?=
 =?us-ascii?Q?a4ScoJJA44oUQtV0xRNzO1W7eCjfAnZdsM/B8ZMJRpcUpXQfFbchbQ4Edago?=
 =?us-ascii?Q?QmPa9OB+Hl1c31h5EPS2S4WuGCSgROO71ydvcG2Tw8lsfoYW6GLckWWbB1eL?=
 =?us-ascii?Q?GY7P7wOy6SCxhOvoueMpAbLoQeupSy77PldcpF6FT/DQNhatG70tljYzObn+?=
 =?us-ascii?Q?pvCfyBhkIkWKmSYXW4gxq8uLzebhApyfXxmer8d3fgmh++FcOVXTGZEo1kUR?=
 =?us-ascii?Q?aNrQc3y8vsx3eyKG1r5dcFCdbOBU20evCPPyKMF2frgB0gfpCEP9LOoqlkNU?=
 =?us-ascii?Q?YHWJZDN0f8YLvkzw/BDI82uppwk8T/z/9orzMh4ucffOwTFoo8lQmb3dpvxN?=
 =?us-ascii?Q?hHFsolpJcrf+mBM+WkYkMuGsy1a9gO04zY1i826vt+WM2CPzDldAT0o6FxsB?=
 =?us-ascii?Q?bXReIaiS1T7PJuADY6cW5cPn9up+XVZdri01tV7Laclumpy34OVUTFtmunQk?=
 =?us-ascii?Q?Lz53Ai7H+A4nfaTvHd7J6qLqlVgy2NsQqLWigp/jighGOYqMDVHeAaHszZFY?=
 =?us-ascii?Q?NB9bjYu3DZx2oINtNRz7SPj9c3H7BGwp7idld5h/o2rV1O79BD7vmclfJJdd?=
 =?us-ascii?Q?1zRfIcglYuesfP+FXXMmBh5AisZIzXB5kAW5h3dwDad38WHB1m8A/1BNI0B+?=
 =?us-ascii?Q?OQ6CUE9IJjky9r6Vr8LNAOny3pPH85e5QIFiZxecDfSrjIypIaToe832vlHH?=
 =?us-ascii?Q?ACegpX5hOMP7nsGD1mF0GVcz1pHyamSxRcU+WDaqSsezJ9t2sjPMrtswGzOa?=
 =?us-ascii?Q?oxH8txAp+X9Tc1BNn90gEjdQfzFFoG86uETzW/nDJRv8fGe3qsXILAeG9uzc?=
 =?us-ascii?Q?lLbiZqOquUMRgd3M1OtNSeGGPONkTN4twaXdrptnT0iZeVLvn7kXqYoiPwQt?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49209f98-e83b-42fc-cc80-08dacf40f262
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 23:58:28.0107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mlnc4ckz8Cg8Z2BrZXT1PFVnUoMAb91nYWo3c0mJ1DBxxJ7bmIdPqKKwfbra9hgvL/L9ZhcGL2hPXwB2tiwXZwROY8lbnwb95o94ag6bl7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4918
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Thu, 24 Nov 2022 10:34:52 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > The three objects 'struct cxl_nvdimm_bridge', 'struct cxl_nvdimm', and
> > 'struct cxl_pmem_region' manage CXL persistent memory resources. The
> > bridge represents base platform resources, the nvdimm represents one or
> > more endpoints, and the region is a collection of nvdimms that
> > contribute to an assembled address range.
> > 
> > Their relationship is such that a region is torn down if any component
> > endpoints are removed. All regions and endpoints are torn down if the
> > foundational bridge device goes down.
> > 
> > A workqueue was deployed to manage these interdependencies, but it is
> > difficult to reason about, and fragile. A recent attempt to take the CXL
> > root device lock in the cxl_mem driver was reported by lockdep as
> > colliding with the flush_work() in the cxl_pmem flows.
> > 
> > Instead of the workqueue, arrange for all pmem/nvdimm devices to be torn
> > down immediately and hierarchically. A similar change is made to both
> > the 'cxl_nvdimm' and 'cxl_pmem_region' objects. For bisect-ability both
> > changes are made in the same patch which unfortunately makes the patch
> > bigger than desired.
> > 
> > Arrange for cxl_memdev and cxl_region to register a cxl_nvdimm and
> > cxl_pmem_region as a devres release action of the bridge device.
> > Additionally, include a devres release action of the cxl_memdev or
> > cxl_region device that triggers the bridge's release action if an endpoint
> > exits before the bridge. I.e. this allows either unplugging the bridge,
> > or unplugging and endpoint to result in the same cleanup actions.
> > 
> > To keep the patch smaller the cleanup of the now defunct workqueue
> > infrastructure is saved for a follow-on patch.
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> Hi Dan,
> 
> This is fiddly to follow, but then so was the original.

Fiddly is a charitable comment for the original. This patch is larger
than I would have liked, but I did not see a way to unwind the
complexity without causing a bisect break.

> A few minor comments inline.

Thanks for taking a look.

> 
> Jonathan
> 
> > ---
> >  drivers/cxl/core/pmem.c      |   70 ++++++++++++++++++++----
> >  drivers/cxl/core/region.c    |   54 ++++++++++++++++++-
> >  drivers/cxl/cxl.h            |    7 ++
> >  drivers/cxl/cxlmem.h         |    4 +
> >  drivers/cxl/mem.c            |    9 +++
> >  drivers/cxl/pci.c            |    3 -
> >  drivers/cxl/pmem.c           |  122 ++++++++++++------------------------------
> >  tools/testing/cxl/test/mem.c |    3 -
> >  8 files changed, 164 insertions(+), 108 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
> > index 1d12a8206444..647b3a30638e 100644
> > --- a/drivers/cxl/core/pmem.c
> > +++ b/drivers/cxl/core/pmem.c
> > @@ -219,7 +219,8 @@ EXPORT_SYMBOL_NS_GPL(to_cxl_nvdimm, CXL);
> >  
> >  static struct lock_class_key cxl_nvdimm_key;
> >  
> > -static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
> > +static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_nvdimm_bridge *cxl_nvb,
> > +					   struct cxl_memdev *cxlmd)
> >  {
> >  	struct cxl_nvdimm *cxl_nvd;
> >  	struct device *dev;
> > @@ -230,6 +231,7 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
> >  
> >  	dev = &cxl_nvd->dev;
> >  	cxl_nvd->cxlmd = cxlmd;
> > +	cxlmd->cxl_nvd = cxl_nvd;
> >  	device_initialize(dev);
> >  	lockdep_set_class(&dev->mutex, &cxl_nvdimm_key);
> >  	device_set_pm_not_required(dev);
> > @@ -240,27 +242,52 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
> >  	return cxl_nvd;
> >  }
> >  
> > -static void cxl_nvd_unregister(void *dev)
> > +static void cxl_nvd_unregister(void *_cxl_nvd)
> >  {
> > -	device_unregister(dev);
> > +	struct cxl_nvdimm *cxl_nvd = _cxl_nvd;
> > +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> > +
> > +	device_lock_assert(&cxlmd->cxl_nvb->dev);
> 
> Locally it's not immediately obvious if that is always the same
> as 
> 	device_lock_assert(&cxl_nvb->dev);
> If not, a comment, if it is maybe just change to that.

Sure, yes, it is always the latter.

> 
> > +	cxl_nvd->cxlmd = NULL;
> > +	cxlmd->cxl_nvd = NULL;
> > +	device_unregister(&cxl_nvd->dev);
> > +}
> > +
> > +static void cxlmd_release_nvdimm(void *_cxlmd)
> > +{
> > +	struct cxl_memdev *cxlmd = _cxlmd;
> > +	struct cxl_nvdimm_bridge *cxl_nvb = cxlmd->cxl_nvb;
> > +
> > +	device_lock(&cxl_nvb->dev);
> > +	if (cxlmd->cxl_nvd)
> > +		devm_release_action(&cxl_nvb->dev, cxl_nvd_unregister,
> > +				    cxlmd->cxl_nvd);
> > +	device_unlock(&cxl_nvb->dev);
> > +	put_device(&cxl_nvb->dev);
> >  }
> >  
> >  /**
> >   * devm_cxl_add_nvdimm() - add a bridge between a cxl_memdev and an nvdimm
> > - * @host: same host as @cxlmd
> >   * @cxlmd: cxl_memdev instance that will perform LIBNVDIMM operations
> >   *
> >   * Return: 0 on success negative error code on failure.
> >   */
> > -int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
> > +int devm_cxl_add_nvdimm(struct cxl_memdev *cxlmd)
> >  {
> > +	struct cxl_nvdimm_bridge *cxl_nvb = cxl_find_nvdimm_bridge(&cxlmd->dev);
> 
> Another cosmetic change, but I'd prefer the actual
> 	cxl_nvb = cxl_find_nvdimm_bridge();
> 
> to be just above the error check rather than up here.

ok.

> 
> >  	struct cxl_nvdimm *cxl_nvd;
> >  	struct device *dev;
> >  	int rc;
> >  
> > -	cxl_nvd = cxl_nvdimm_alloc(cxlmd);
> > -	if (IS_ERR(cxl_nvd))
> > -		return PTR_ERR(cxl_nvd);
> > +	if (!cxl_nvb)
> > +		return -ENODEV;
> > +
> > +	cxl_nvd = cxl_nvdimm_alloc(cxl_nvb, cxlmd);
> > +	if (IS_ERR(cxl_nvd)) {
> > +		rc = PTR_ERR(cxl_nvd);
> > +		goto err_alloc;
> > +	}
> > +	cxlmd->cxl_nvb = cxl_nvb;
> >  
> >  	dev = &cxl_nvd->dev;
> >  	rc = dev_set_name(dev, "pmem%d", cxlmd->id);
> > @@ -271,13 +298,34 @@ int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
> >  	if (rc)
> >  		goto err;
> >  
> > -	dev_dbg(host, "%s: register %s\n", dev_name(dev->parent),
> > -		dev_name(dev));
> > +	dev_dbg(&cxlmd->dev, "register %s\n", dev_name(dev));
> >  
> > -	return devm_add_action_or_reset(host, cxl_nvd_unregister, dev);
> > +	/*
> > +	 * Remove this nvdimm connection if either the top-level PMEM
> > +	 * bridge goes down, or the endpoint device goes through
> > +	 * ->remove().
> > +	 */
> 
> Perhaps move this comment down to inside the if (cxl_nvb->dev.driver)
> block as it only refers (I think) to the devm_add_action_or_reset(),
> not the surrounding driver binding checks.

It refers to the whole rest of this function because this action:

    devm_add_action_or_reset(&cxl_nvb->dev, cxl_nvd_unregister, cxl_nvd)

...deletes the cxl_nvdimm when the bridge is removed, and this action:

    devm_add_action_or_reset(&cxlmd->dev, cxlmd_release_nvdimm, cxlmd)

...removes the nvdimm, and the above release action, if the endpoint is
removed *before* the bridge.

At a minimum the comment needs strengthening if that detail was not
conveyed.

> 
> > +	device_lock(&cxl_nvb->dev);
> > +	if (cxl_nvb->dev.driver)
> > +		rc = devm_add_action_or_reset(&cxl_nvb->dev, cxl_nvd_unregister,
> > +					      cxl_nvd);
> > +	else
> > +		rc = -ENXIO;
> > +	device_unlock(&cxl_nvb->dev);
> > +
> > +	if (rc)
> > +		goto err_alloc;
> > +
> > +	/* @cxlmd carries a reference on @cxl_nvb until cxlmd_release_nvdimm */
> > +	return devm_add_action_or_reset(&cxlmd->dev, cxlmd_release_nvdimm, cxlmd);
> >  
> >  err:
> >  	put_device(dev);
> > +err_alloc:
> > +	put_device(&cxl_nvb->dev);
> 
> Is this ordering necessary? It's not reverse of the setup above, so if we can reordering
> to be so, that is probably a good thing. (move these NULL setting above the put_device(&cxl_nvb->dev)).

Sure, they can move above.

> 
> > +	cxlmd->cxl_nvb = NULL;
> > +	cxlmd->cxl_nvd = NULL;
> > +
> >  	return rc;
> >  }
> >  EXPORT_SYMBOL_NS_GPL(devm_cxl_add_nvdimm, CXL);
> > diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> > index f9ae5ad284ff..e73bec828032 100644
> > --- a/drivers/cxl/core/region.c
> > +++ b/drivers/cxl/core/region.c
> > @@ -1812,6 +1812,7 @@ static struct lock_class_key cxl_pmem_region_key;
> >  static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
> >  {
> >  	struct cxl_region_params *p = &cxlr->params;
> > +	struct cxl_nvdimm_bridge *cxl_nvb;
> >  	struct cxl_pmem_region *cxlr_pmem;
> >  	struct device *dev;
> >  	int i;
> > @@ -1839,6 +1840,14 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
> >  		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> >  		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
> >  
> > +		if (i == 0) {
> 
> Whilst kind of obvious, maybe a comment in here that for end points in the region the
> cxl_nvb will be the same hence we just look it up for the first one?

ok.

> 
> > +			cxl_nvb = cxl_find_nvdimm_bridge(&cxlmd->dev);
> > +			if (!cxl_nvb) {
> > +				cxlr_pmem = ERR_PTR(-ENODEV);
> > +				goto out;
> > +			}
> > +			cxlr->cxl_nvb = cxl_nvb;
> > +		}
> >  		m->cxlmd = cxlmd;
> >  		get_device(&cxlmd->dev);
> >  		m->start = cxled->dpa_res->start;
> > @@ -1848,6 +1857,7 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
> >  
> >  	dev = &cxlr_pmem->dev;
> >  	cxlr_pmem->cxlr = cxlr;
> > +	cxlr->cxlr_pmem = cxlr_pmem;
> >  	device_initialize(dev);
> >  	lockdep_set_class(&dev->mutex, &cxl_pmem_region_key);
> >  	device_set_pm_not_required(dev);
> > @@ -1860,9 +1870,30 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
> >  	return cxlr_pmem;
> >  }
> >  
> > -static void cxlr_pmem_unregister(void *dev)
> > +static void cxlr_pmem_unregister(void *_cxlr_pmem)
> > +{
> > +	struct cxl_pmem_region *cxlr_pmem = _cxlr_pmem;
> > +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
> > +	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
> > +
> > +	device_lock_assert(&cxl_nvb->dev);
> 
> This scheme is obvious in this patch, but probably less so when just
> looking at the resulting code. Perhaps worth a comment
> here on why we care about that particular lock?

ok, and I'll make a similar comment in cxl_nvd_unregister.

> 
> > +	cxlr->cxlr_pmem = NULL;
> > +	cxlr_pmem->cxlr = NULL;
> > +	device_unregister(&cxlr_pmem->dev);
> > +}
> > +
> > +static void cxlr_release_nvdimm(void *_cxlr)
> >  {
> > -	device_unregister(dev);
> > +	struct cxl_region *cxlr = _cxlr;
> > +	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
> > +
> > +	device_lock(&cxl_nvb->dev);
> > +	if (cxlr->cxlr_pmem)
> > +		devm_release_action(&cxl_nvb->dev, cxlr_pmem_unregister,
> > +				    cxlr->cxlr_pmem);
> > +	device_unlock(&cxl_nvb->dev);
> > +	cxlr->cxl_nvb = NULL;
> > +	put_device(&cxl_nvb->dev);
> >  }
> >  
> >  /**
> > @@ -1874,12 +1905,14 @@ static void cxlr_pmem_unregister(void *dev)
> >  static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> >  {
> >  	struct cxl_pmem_region *cxlr_pmem;
> > +	struct cxl_nvdimm_bridge *cxl_nvb;
> >  	struct device *dev;
> >  	int rc;
> >  
> >  	cxlr_pmem = cxl_pmem_region_alloc(cxlr);
> >  	if (IS_ERR(cxlr_pmem))
> >  		return PTR_ERR(cxlr_pmem);
> > +	cxl_nvb = cxlr->cxl_nvb;
> >  
> >  	dev = &cxlr_pmem->dev;
> >  	rc = dev_set_name(dev, "pmem_region%d", cxlr->id);
> > @@ -1893,10 +1926,25 @@ static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> >  	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
> >  		dev_name(dev));
> >  
> > -	return devm_add_action_or_reset(&cxlr->dev, cxlr_pmem_unregister, dev);
> > +	device_lock(&cxl_nvb->dev);
> > +	if (cxl_nvb->dev.driver)
> > +		rc = devm_add_action_or_reset(&cxl_nvb->dev,
> > +					      cxlr_pmem_unregister, cxlr_pmem);
> > +	else
> > +		rc = -ENXIO;
> > +	device_unlock(&cxl_nvb->dev);
> > +
> > +	if (rc)
> > +		goto err_bridge;
> > +
> > +	/* @cxlr carries a reference on @cxl_nvb until cxlr_release_nvdimm */
> > +	return devm_add_action_or_reset(&cxlr->dev, cxlr_release_nvdimm, cxlr);
> >  
> >  err:
> >  	put_device(dev);
> > +err_bridge:
> > +	put_device(&cxl_nvb->dev);
> > +	cxlr->cxl_nvb = NULL;
> >  	return rc;
> >  }
> >  
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index 4ac7938eaf6c..9b5ba9626636 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -386,6 +386,8 @@ struct cxl_region_params {
> >   * @id: This region's id. Id is globally unique across all regions
> >   * @mode: Endpoint decoder allocation / access mode
> >   * @type: Endpoint decoder target type
> > + * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem shutdown
> 
> I was going to suggest just carrying the struct device around, but this
> comment isn't quite true.  I think cxl_region->cxl_nvb is also used in
> cxl_pmem_region_probe() to get the nvdimm_buss for nvdimm_pmem_region_create()

Perhaps just make the comment less specific and say "nvdimm bridge for
coordinating @cxlr_pmem setup and shutdown".

> 
> 
> > + * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
> >   * @params: active + config params for the region
> >   */
> >  struct cxl_region {
> > @@ -393,6 +395,8 @@ struct cxl_region {
> >  	int id;
> >  	enum cxl_decoder_mode mode;
> >  	enum cxl_decoder_type type;
> > +	struct cxl_nvdimm_bridge *cxl_nvb;
> > +	struct cxl_pmem_region *cxlr_pmem;
> >  	struct cxl_region_params params;
> >  };
> >  
> > @@ -438,7 +442,6 @@ struct cxl_pmem_region {
> >  	struct device dev;
> >  	struct cxl_region *cxlr;
> >  	struct nd_region *nd_region;
> > -	struct cxl_nvdimm_bridge *bridge;
> >  	struct range hpa_range;
> >  	int nr_mappings;
> >  	struct cxl_pmem_region_mapping mapping[];
> > @@ -637,7 +640,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
> >  struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
> >  bool is_cxl_nvdimm(struct device *dev);
> >  bool is_cxl_nvdimm_bridge(struct device *dev);
> > -int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
> > +int devm_cxl_add_nvdimm(struct cxl_memdev *cxlmd);
> >  struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct device *dev);
> >  
> >  #ifdef CONFIG_CXL_REGION
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 88e3a8e54b6a..c1c9960ab05f 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -35,6 +35,8 @@
> >   * @cdev: char dev core object for ioctl operations
> >   * @cxlds: The device state backing this device
> >   * @detach_work: active memdev lost a port in its ancestry
> > + * @cxl_nvb: coordinate removal of @cxl_nvd if present
> > + * @cxl_nvd: optional bridge to an nvdimm if the device supports pmem
> >   * @id: id number of this memdev instance.
> >   */
> >  struct cxl_memdev {
> > @@ -42,6 +44,8 @@ struct cxl_memdev {
> >  	struct cdev cdev;
> >  	struct cxl_dev_state *cxlds;
> >  	struct work_struct detach_work;
> > +	struct cxl_nvdimm_bridge *cxl_nvb;
> > +	struct cxl_nvdimm *cxl_nvd;
> >  	int id;
> >  };
> >  
> 
> > diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> > index 652f00fc68ca..73357d0c3f25 100644
> > --- a/drivers/cxl/pmem.c
> > +++ b/drivers/cxl/pmem.c
> 
> 
> >  static struct cxl_driver cxl_nvdimm_driver = {
> > @@ -200,6 +182,16 @@ static int cxl_pmem_ctl(struct nvdimm_bus_descriptor *nd_desc,
> >  	return cxl_pmem_nvdimm_ctl(nvdimm, cmd, buf, buf_len);
> >  }
> >  
> > +static void unregister_nvdimm_bus(void *_cxl_nvb)
> > +{
> > +	struct cxl_nvdimm_bridge *cxl_nvb = _cxl_nvb;
> > +	struct nvdimm_bus *nvdimm_bus = cxl_nvb->nvdimm_bus;
> > +
> > +	cxl_nvb->nvdimm_bus = NULL;
> > +	nvdimm_bus_unregister(nvdimm_bus);
> > +}
> > +
> 
> Single blank line.
> 
> > +
> >  static bool online_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb)
> >  {
> >  	if (cxl_nvb->nvdimm_bus)
> > @@ -303,23 +295,21 @@ static int cxl_nvdimm_bridge_probe(struct device *dev)
> >  {
> >  	struct cxl_nvdimm_bridge *cxl_nvb = to_cxl_nvdimm_bridge(dev);
> >  
> > -	if (cxl_nvb->state == CXL_NVB_DEAD)
> > -		return -ENXIO;
> > +	cxl_nvb->nd_desc = (struct nvdimm_bus_descriptor){
> ) {
> matches existing style in this file.

clang-format removes that space, will add it back.

> 
> > +		.provider_name = "CXL",
> > +		.module = THIS_MODULE,
> > +		.ndctl = cxl_pmem_ctl,
> > +	};
> >  
> > -	if (cxl_nvb->state == CXL_NVB_NEW) {
> > -		cxl_nvb->nd_desc = (struct nvdimm_bus_descriptor) {
> > -			.provider_name = "CXL",
> > -			.module = THIS_MODULE,
> > -			.ndctl = cxl_pmem_ctl,
> > -		};
> > +	cxl_nvb->nvdimm_bus =
> > +		nvdimm_bus_register(&cxl_nvb->dev, &cxl_nvb->nd_desc);
> >  
> > -		INIT_WORK(&cxl_nvb->state_work, cxl_nvb_update_state);
> > -	}
> > +	if (!cxl_nvb->nvdimm_bus)
> > +		return -ENOMEM;
> >  
> > -	cxl_nvb->state = CXL_NVB_ONLINE;
> > -	cxl_nvdimm_bridge_state_work(cxl_nvb);
> > +	INIT_WORK(&cxl_nvb->state_work, cxl_nvb_update_state);
> >  
> > -	return 0;
> > +	return devm_add_action_or_reset(dev, unregister_nvdimm_bus, cxl_nvb);


