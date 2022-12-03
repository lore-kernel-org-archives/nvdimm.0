Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAE97B
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 07:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670053194; x=1701589194;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qKIIxk8K5F28i+6cFUrfGtFXv6cp3pI3Od0HxrjdI5k=;
  b=aktEfBiGTkjLzMfNUqsCelcV/4Xzhezbyh1YjY5Ioy7I9L0g8RiIrs4J
   7X4kXhbqmwDxvcE7wEF018jxlb/NKSro8t3Sk39vHXXrPJ+xQLFTfwHdL
   e28k4UppQFOLTNMstDXf3igecBtPQjCWDzWQEf1SbWc0LXlB3k3GkRO77
   X0cB63XZMaZe7CQgpnBRzCnr88D4ICL3U5xI+H1iNk+JE7Dh6F5RaZ3jj
   rJjID1bH9bYExeGXYkt7gaaXMAVtJH6QIcPjzhSFmIyuJMsWjKiS0Eipm
   GNkTPrN8CZl8t5/pwnRQrzVlQNjywIHcaOhCsgEjsfSyFXmEqBpTOxXRb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="316128302"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="316128302"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 23:39:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="676076763"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="676076763"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 02 Dec 2022 23:39:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:39:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 23:39:49 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 23:39:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zl/fR2MjHTUuY/6lJ6WcjIC3j4jF6Emd099mK6JTF/7bN5VMLQFzTBH5hsCSPS45UdNi0NFwbdgQePl5cfG7B/F+ht/BvLslREug96gMOLAZTbhWs/jhGbSswHLj5bPqAKEcbMp5s2gZxv5Uhr26VcQz1Go5i2ZKvW9rHNTdvxoRgAXLBOL2xv9DHpl1qlOddNKZeC7ytIfmGEUDO11LRBJyC/ZXpG4Zxw4uxkqq4r8wy2ffyKjQdjdkpFe/YKgxmD5N6jxwuIiPmNvrEgM82FrOUmFVBk2/SJnGhLUIr6UYvf1Pop5JLGhX7g2FEYgJUxSIYVPOXhH0SP30H8/dgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1YYRey3e3vl9O223x7Lzuc4w0R6hdyo1PZv4/o1zb0=;
 b=f34cEVyyGDYcsLy+ADXqC8Nj9a6+ZNrpa1kBxxv3hq5xsv9b0O/zta4ElNetEWkehu8ugKjqJsSpbhVO+6EB5d+k4uuI+YSBExtnyJczbE6+cjCEDvF6VetyBp2VCvLjrbk2QEij1Fn4CF/S4mdnh2ZeyKTI1GLFAOcD27178OZOmdMSU2neOcJ1PfsXGdUJLKSggpAKSJTQWTEc0wTjOgEEkxCG1W22BM6kqxsy9umn5edg4gWeKOztHUpKVoMT3pu5qz5skBzdmVXZeG9FFPPKiBMCBBmlhImeqMldFqytXv7Ja9cZ0ncite5ozkzJp20CaI3+aYaZbnHfhn2BRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MW4PR11MB6716.namprd11.prod.outlook.com
 (2603:10b6:303:20d::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Sat, 3 Dec
 2022 07:39:41 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 07:39:41 +0000
Date: Fri, 2 Dec 2022 23:39:34 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, <alison.schofield@intel.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <638afd363739a_3cbe029436@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993044524.1882361.2539922887413208807.stgit@dwillia2-xfh.jf.intel.com>
 <20221202163818.00002c93@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221202163818.00002c93@Huawei.com>
X-ClientProxiedBy: SJ0PR03CA0373.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::18) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|MW4PR11MB6716:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e9e57a0-d794-4ee6-e566-08dad5018a13
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zxNga/CXy3jqk6s34IveU8U+X1AGRW4Gmn7w/P339i6FCSbjXS3a9E2XKpnwFAWzdAog1ksPEyNOTM12zzc7LHS5d4V1ZXdz9oDED6/d+iLgKqQQYROcQrZuCYthjGTCXz9GbjpRKUZuAbGCfrvGqLUoE+ivuSGQQFLZP7EdIxxYjZM6lgt845BQUnq5LIV5SFK31h/FC43C09s4gH+AZBJYlGAcx92jX89MWSHR7Z7mKy4jtkMGMe1SAh+ly2khxWXsuszvOwbardb+2IwvVBLeBgy4sujS+BHXwzd2I8T1RfLq6kCi/ncuqvtGtzmfpMKqZ5410c7fHLt9uvkXxvc7+mN8VZhh5daBz8Pq1UESR0NS0zNQSKUf42NGV6CPJtji17aW0QAHOqXWyZguG4GfM1ybYvoFUGW04uC8VPBivqUYxvwclUOrVpGQS9NgHBftVIUJaY8nrQVjdbw/zGPB8Jqwg2jlneN2MLxuSuApwR+/owk+2Md7c6SwU8rJ5xrNtOjkcpG8I374qI4hYuJqDrlkDGDES5VFsnvcFp0LEGx1FnXrEsWfC8ei3Dk3TeZkYPLFFJKSSmnJgQSjTQ0uMG5pyyeAt6vWpfA+YLYJakEsW6TiBIx+Byj/w2Ir3tM+Yzl8chqELs9PL05738MviG1jzaKEDHYPFn5PGC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(83380400001)(86362001)(9686003)(966005)(6486002)(6512007)(110136005)(6506007)(82960400001)(38100700002)(478600001)(186003)(26005)(8936002)(6666004)(41300700001)(5660300002)(4326008)(66556008)(54906003)(66476007)(66946007)(316002)(8676002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BHjJUN2i2yTX8OreueB3nGGcPHZf3svDocgJbD7Qdebvb3t7glecL/1vDJdJ?=
 =?us-ascii?Q?2kDRRJ8oEUxzTP1fz1ARdn0Iwo1495cBQzSL+ilRrvwh61HM7GIrOyVE4qtc?=
 =?us-ascii?Q?wvItlhptsFhp4OwO6pveS03i4JN3qtK+fCsA8DWhh6OBnbbZkduijBUpElTt?=
 =?us-ascii?Q?tQ4GXMLyAvgWudpxEptnVidsR/3f+wCWL7IY2ComGwPr/VQX/RPUou40BVRC?=
 =?us-ascii?Q?RLHds+wpCDIRN2jIGqM58HyHcuDn5YI1448qiBEsndqhCWG8jahVLmHyTW5t?=
 =?us-ascii?Q?74vSM+I2WIr8iN6kal3tJ2pM8miPwIhcckK7JiHhMAwQNs1YCMFIaNcx5U6C?=
 =?us-ascii?Q?582e5jOXLFsToM3hPJrH8v/qryr/Ai/8Aii+pHrlfRECF39yvjvD9RcpJk1o?=
 =?us-ascii?Q?0ZMO0sT/igCp6BKJsdTwhRMW53GcHx7JN/0tKtpJu6cf7pFvX/T2SrR4OX4h?=
 =?us-ascii?Q?70XMcL+3QVorFUO67Ubp1voIcVt2eP1wbjkvMol1Q863zkCrme8mxHk0ttwx?=
 =?us-ascii?Q?gFrwifC7AOmlXQfOGQ+avzbMTYFhwJ1kpcPKYnQKehQSn0eWeb5jAIQkJedf?=
 =?us-ascii?Q?NO2gfUVkoROSxvsH3QYL6CBp3SzIJvH+MYoOTk5xYKfizf62huTxbk9Hs75H?=
 =?us-ascii?Q?NWFp6X7zNDkGIGb8dRmowm6WQi7bDHhMmxFUPXgQHZw7P08gbn/Um3RiWvPP?=
 =?us-ascii?Q?0Hgx4kRhjskyu9dpDscZ4U9jxZ8jsqkGs8yx55tzsU7MMJF5VhYeIchvoMRC?=
 =?us-ascii?Q?1h2ik3nWwgM3xHgtZYeZwOw4GZmdlMowB5qCNiczVoID8B0QePHaQSdQk4Ip?=
 =?us-ascii?Q?FOduTieO4U1nVayWbRTtHHD6V6oK/BMspDnGrZo0v3abiciA39tHsSuqUjKx?=
 =?us-ascii?Q?HHpaq8QMTIldNuSMRSEnBPYF0/bjxvuTUNWT3+H0mMiY3hUP0jJj7LvwboH5?=
 =?us-ascii?Q?FrqNZMVRUxFNFr4eSOulfhCZTQ2WdC4DnKM/t3qqh28m8O9cKRMSNqD4cjMS?=
 =?us-ascii?Q?oLlw+ciCzuMVjPe0T58zIBZzQnL2fzNn2Wva7hlHxgBpi7uTajaXYULo7U7Z?=
 =?us-ascii?Q?lB9DVoYoANJNnqG0sOK2+aUznXEXk+GChtm0NpID24+5KLFNbHpJSSLKY+Hr?=
 =?us-ascii?Q?xoirCiVdarKRCerTWb0ZqTxobbB32E6HJhL7XDPI9HILgI4jFNW7DC1Xsr8K?=
 =?us-ascii?Q?Yy94dH6Cao3FZH1FhMfp+twPK82Ykdjyno6UlbrcSu1fhQk8+UnK0tnfltyz?=
 =?us-ascii?Q?py6vOO1BGlnlBLp1Lxfqi9n3jBH20Ao9m+xI3mVpl9tn2mdf3feiOyD50rXP?=
 =?us-ascii?Q?d0CGd0GOI1lbWnvwANWUQczNZ1wgXQH6nOxDxMeXAay9twdntHY8yrebN2XB?=
 =?us-ascii?Q?9BGIKkRoS6nHKJu3puwENBJ0QxfMxoTrvnYJ7/uOOCRnrbtpZX4v01Fv/IOc?=
 =?us-ascii?Q?Y4mkDi36FqLEoMkCx3sWXTIl51e6sFFIsyMjrsVzgcMK5wRbuXXxU2LklQBA?=
 =?us-ascii?Q?6ie03MicBSLgn8+0RCwLM2aBUkabPugvBO3D+7eGyE7E+8SglmeKdTgSs7PD?=
 =?us-ascii?Q?yFXFfxejpQx/XswtFYNupvwsEjxcWfPljNvvDvaixerDECssu+1oNTteNOJ+?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e9e57a0-d794-4ee6-e566-08dad5018a13
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 07:39:41.6620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W3AkXLjHvoiYZqErHjX4+RLNILkmIudQiBEM2VSx04vgtYjmUhVD84XfEe5a9UzUcF4NHBCfVfHgLbWPeqWz8eekTt65s5AxE4HgeqPu0uk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6716
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Thu, 01 Dec 2022 13:34:05 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > From: Robert Richter <rrichter@amd.com>
> > 
> > A downstream port must be connected to a component register block.
> > For restricted hosts the base address is determined from the RCRB. The
> > RCRB is provided by the host's CEDT CHBS entry. Rework CEDT parser to
> > get the RCRB and add code to extract the component register block from
> > it.
> > 
> > RCRB's BAR[0..1] point to the component block containing CXL subsystem
> > component registers. MEMBAR extraction follows the PCI base spec here,
> > esp. 64 bit extraction and memory range alignment (6.0, 7.5.1.2.1). The
> > RCRB base address is cached in the cxl_dport per-host bridge so that the
> > upstream port component registers can be retrieved later by an RCD
> > (RCIEP) associated with the host bridge.
> > 
> > Note: Right now the component register block is used for HDM decoder
> > capability only which is optional for RCDs. If unsupported by the RCD,
> > the HDM init will fail. It is future work to bypass it in this case.
> > 
> > Co-developed-by: Terry Bowman <terry.bowman@amd.com>
> > Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> > Signed-off-by: Robert Richter <rrichter@amd.com>
> > Link: https://lore.kernel.org/r/Y4dsGZ24aJlxSfI1@rric.localdomain
> > [djbw: introduce devm_cxl_add_rch_dport()]
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> Trivial moans that may have something to do with it being near going home time
> on a Friday.
> 
> Otherwise looks sensible though this was a fairly superficial look.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> 
> 
> > ---
> >  drivers/cxl/acpi.c            |   51 ++++++++++++++++++++++++++++-----
> >  drivers/cxl/core/port.c       |   53 ++++++++++++++++++++++++++++++----
> >  drivers/cxl/core/regs.c       |   64 +++++++++++++++++++++++++++++++++++++++++
> >  drivers/cxl/cxl.h             |   16 ++++++++++
> >  tools/testing/cxl/Kbuild      |    1 +
> >  tools/testing/cxl/test/cxl.c  |   10 ++++++
> >  tools/testing/cxl/test/mock.c |   19 ++++++++++++
> >  tools/testing/cxl/test/mock.h |    3 ++
> >  8 files changed, 203 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > index 50d82376097c..db8173f3ee10 100644
> > --- a/drivers/cxl/acpi.c
> > +++ b/drivers/cxl/acpi.c
> 
> >  struct cxl_chbs_context {
> > -	struct device *dev;
> > -	unsigned long long uid;
> > -	resource_size_t chbcr;
> > +	struct device		*dev;
> > +	unsigned long long	uid;
> > +	resource_size_t		rcrb;
> > +	resource_size_t		chbcr;
> > +	u32			cxl_version;
> >  };
> 
> I'm not keen on this style change because it slightly obscures the meaningful
> changes in this diff + I suspect it's not consistent with rest of the file.

Copy and pasted from Robert's update. Looks much better after hitting it
with clang-format:

@@ -232,7 +239,9 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 struct cxl_chbs_context {
        struct device *dev;
        unsigned long long uid;
+       resource_size_t rcrb;
        resource_size_t chbcr;
+       u32 cxl_version;
 };
 
 static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,

> 
> 
> 
> > diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
> > index ec178e69b18f..28ed0ec8ee3e 100644
> > --- a/drivers/cxl/core/regs.c
> > +++ b/drivers/cxl/core/regs.c
> > @@ -307,3 +307,67 @@ int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
> >  	return -ENODEV;
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_find_regblock, CXL);
> > +
> > +resource_size_t cxl_rcrb_to_component(struct device *dev,
> > +				      resource_size_t rcrb,
> > +				      enum cxl_rcrb which)
> > +{
> > +	resource_size_t component_reg_phys;
> > +	u32 bar0, bar1;
> > +	void *addr;
> > +	u16 cmd;
> > +	u32 id;
> > +
> > +	if (which == CXL_RCRB_UPSTREAM)
> > +		rcrb += SZ_4K;
> > +
> > +	/*
> > +	 * RCRB's BAR[0..1] point to component block containing CXL
> > +	 * subsystem component registers. MEMBAR extraction follows
> > +	 * the PCI Base spec here, esp. 64 bit extraction and memory
> > +	 * ranges alignment (6.0, 7.5.1.2.1).
> > +	 */
> > +	if (!request_mem_region(rcrb, SZ_4K, "CXL RCRB"))
> > +		return CXL_RESOURCE_NONE;
> > +	addr = ioremap(rcrb, SZ_4K);
> > +	if (!addr) {
> > +		dev_err(dev, "Failed to map region %pr\n", addr);
> > +		release_mem_region(rcrb, SZ_4K);
> > +		return CXL_RESOURCE_NONE;
> > +	}
> > +
> > +	id = readl(addr + PCI_VENDOR_ID);
> > +	cmd = readw(addr + PCI_COMMAND);
> > +	bar0 = readl(addr + PCI_BASE_ADDRESS_0);
> > +	bar1 = readl(addr + PCI_BASE_ADDRESS_1);
> > +	iounmap(addr);
> > +	release_mem_region(rcrb, SZ_4K);
> > +
> > +	/*
> > +	 * Sanity check, see CXL 3.0 Figure 9-8 CXL Device that Does Not
> > +	 * Remap Upstream Port and Component Registers
> > +	 */
> > +	if (id == U32_MAX) {
> > +		if (which == CXL_RCRB_DOWNSTREAM)
> > +			dev_err(dev, "Failed to access Downstream Port RCRB\n");
> > +		return CXL_RESOURCE_NONE;
> > +	}
> > +	if (!(cmd & PCI_COMMAND_MEMORY))
> > +		return CXL_RESOURCE_NONE;
> > +	if (bar0 & (PCI_BASE_ADDRESS_MEM_TYPE_1M | PCI_BASE_ADDRESS_SPACE_IO))
> 
> Trivial: A positive match on what we do want might be better...
> 
> I had to got look up MEM_TYPE_1M to find out what on earth it was (marked obsolete which
> I guess isn't surprising.... )
> 
> Up to you though...

The polarity switch is not any prettier, but a comment would save
someone searching what PCI_BASE_ADDRESS_MEM_TYPE_1M is though. I
actually looked that up myself when I first read it.

> 
> > +		return CXL_RESOURCE_NONE;
> > +
> > +	component_reg_phys = bar0 & PCI_BASE_ADDRESS_MEM_MASK;
> > +	if (bar0 & PCI_BASE_ADDRESS_MEM_TYPE_64)
> > +		component_reg_phys |= ((u64)bar1) << 32;
> > +
> > +	if (!component_reg_phys)
> > +		return CXL_RESOURCE_NONE;
> > +
> > +	/* MEMBAR is block size (64k) aligned. */
> > +	if (!IS_ALIGNED(component_reg_phys, CXL_COMPONENT_REG_BLOCK_SIZE))
> > +		return CXL_RESOURCE_NONE;
> > +
> > +	return component_reg_phys;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(cxl_rcrb_to_component, CXL);
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index 281b1db5a271..1342e4e61537 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> 
> 
> 
> >  #define CXL_RESOURCE_NONE ((resource_size_t) -1)
> >  #define CXL_TARGET_STRLEN 20
> >  
> > @@ -486,12 +494,16 @@ cxl_find_dport_by_dev(struct cxl_port *port, const struct device *dport_dev)
> >   * @dport: PCI bridge or firmware device representing the downstream link
> >   * @port_id: unique hardware identifier for dport in decoder target list
> >   * @component_reg_phys: downstream port component registers
> > + * @rcrb: base address for the Root Complex Register Block
> > + * @rch: Indicate whether this dport was enumerated in RCH or VH mode
> 
> Clarify this as
> 	Indicate this dport was enumerated in RCH rather than VH mode.
> 
> a boolean with an or in the comment is confusing!
> 
> >   * @port: reference to cxl_port that contains this downstream port
> >   */
> >  struct cxl_dport {
> >  	struct device *dport;
> >  	int port_id;
> >  	resource_size_t component_reg_phys;
> > +	resource_size_t rcrb;
> > +	bool rch;
> >  	struct cxl_port *port;
> >  };
> 



