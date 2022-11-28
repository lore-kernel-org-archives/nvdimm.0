Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB48A498
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 21:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669672748; x=1701208748;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QWbH3X6nDI1eW6K/HOR76ZQk0k6ezpV1oYPhyoV2frE=;
  b=jabH7x7x0crye7HuCnmSQntrL97YhbmpbtePP56OnEFiBDik0mF7UXDF
   tLna/BgTGuDH6TvfJAGl93uO+D/l79xCHZYTIDaY2u3vGnT1HczreMcOP
   OKbk3AVm/r49PTybwfczJEpHvWlG8eHbigre5+9uxSAO0AmDPD+LKiNq7
   zKkByWcQmbPSeDeZsSoGd85zeclm1PsJYhpeW1YgjwdiiPp+GETTUnwej
   3SLohMSjJR2mcNPXbOoY0dbAN3Ja2k7M9VgtiaD2TMUcMCmR8aqv/rEhy
   V9YgZoGZLV2pvDCKcwARVxRy1dbwbmBYRBiif9W7UPGiz/gBeiM5j1y24
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="341871713"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="341871713"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 13:59:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="785799153"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="785799153"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 28 Nov 2022 13:59:07 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 13:59:07 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 13:59:07 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 13:59:07 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 13:59:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNOTW9PUf2H9fRukBFQowbs2lwT4Jlt5PNi2QYWnVwtuW1tt5YcSMDoaAXrZhv35ytDvPriKjT8TG4D0iN15IYHlizMTmKxwrBmlna9fyEed8b3jImj65KZHu8UWvI+7fj7IpQudgJJm93AI8rb73Y551svX/+p1xqYnhm5hj+wAGAY5oOtkfYRdzjXifNpisfuo5RcnsfcRQp7PFWIPWk8XsADqiSMt0qC7pPb8JfBtwpFFBFpcwmAnQhZivKEvraJ01G8DlCfgWCVVuXsaVmu1ijTgBDK+Z+RxcKIXfn5DohAIcM6ouawFLoCci8rKzNad7VSIR2sD6VN8Udn0wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyafPjjDoKi7RunCJqaQMMIn4XRR42rrAPk5AOCMXZ4=;
 b=kxJ54EzJjdzQdQKdqjaoHdMe7I5nvbomVB+EBF0XW6QrvbpvkdfDNkuhxj+rb5A7R8w/7eIyhaNRaYN74vlt+z4AYGKczVQeLbMMhaZZhn0QoCdNYbwIIqoglkf5kg479l9sSFNz1ik6sYuiaDGRC7AxgGXdzGChLYXdPBxZYNqPSathgNCfYnactgaB5/JWqm51DkOkKlJd/Q4l2MCpaAzrGlVl8rwio06kjhoY+RHsrjhxxJK/zKvoDDA2PG8GjQdS1+HuMKh7zLwXimDV8l+4UH8rWP+psYBUwTi8HQCEn2QF9zc06/CnhK5vJkZI/WhQ4H36nt1YluN4wVAWnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DS0PR11MB6398.namprd11.prod.outlook.com
 (2603:10b6:8:c9::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Mon, 28 Nov
 2022 21:58:59 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 21:58:58 +0000
Date: Mon, 28 Nov 2022 13:58:55 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <63852f1fdfadc_3cbe02947b@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931492162.2104015.17972281946627197765.stgit@dwillia2-xfh.jf.intel.com>
 <Y4TGabZ4iqtOyTf8@rric.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4TGabZ4iqtOyTf8@rric.localdomain>
X-ClientProxiedBy: BYAPR08CA0040.namprd08.prod.outlook.com
 (2603:10b6:a03:117::17) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DS0PR11MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: 0578dd38-5730-4824-8fa7-08dad18bc081
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UtdM1ueGlDF3mvyopitJqKXwixMiyGsdZQoXlWSO8jm3xPGuFxe+aWTt0xQ9CzddQ3qTaR5i9H/b4PXmlcVLfLF0oeJaDUR9RsiBBVuckbiAXD/6NaE6AiPvCOYKbUlJr+3KpKckvilSIZSObQEcVjUbbPg+DmrcjbCUPQMmUOsj5TmjKTqqAnZ61qahZc16aQLkbBWnhbPxTIxy7J2X4Dasfrh9N4ObnFZPdTjzcS2S3aVzSJrM7fxmuRttg6qFzdaBHFor/096+wjY9VhdUcu3fGR1yq6BoetkPnMFxCvfKMwdbHmKD3Pz3qEc4duesPBx/WtWUzHk4Fp+QPGXjhPmrV4iirp03Cm3h0Guf5E0kO/J1vg4Ih7k94G8+drijTQfZXEQ61y/u6J/0/T+g2wxEbdFx9cxH9jXHvLSWZifFgnR83BoGFtPZwcUlgxP3sSoTpH16bvjsvqYGGEgnQGV22KRBqUMc8zTdRmfAREtg6fHcr1X3wziYoQWDhZIDu/7TaIhl8kD5U7lWURoYPdMIx/usCUR0wYIy1Fr0JAWKpCUEDDk9T1bqYP2BH9+e7eCSTmANxlWtxD6WAyKUd+Rvd9ZdL8KRjUnA6uBAVDBr9sOn1Kd10RhwTTo2zGiWEsskfUS4Efcak9yw+NkuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199015)(2906002)(86362001)(82960400001)(38100700002)(83380400001)(6666004)(26005)(6506007)(9686003)(6512007)(478600001)(6486002)(316002)(53546011)(110136005)(8676002)(4326008)(66946007)(66476007)(30864003)(66556008)(5660300002)(41300700001)(186003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eaYY7HWnmdWo9kqgk0X1lZb4DW+JbY01VWlNebbfAWp86OtUISkQqdN1ton6?=
 =?us-ascii?Q?vrtejvSkHL5uUnSGIJQ+YaW0sQ1ymWjSvkwzEcRidu8mrT2k7O06zqRDx1Hz?=
 =?us-ascii?Q?BC5jkmkiL/xn7+5d/LHaIZ+NgsgxrUnlAtheMncvsFWsU4ws+LmjC1zWAo8S?=
 =?us-ascii?Q?59vJcADesMv+ST5mtz9B27rdtqRmUkFCBtulJgmcMusemIixfIT+IlnX0tRE?=
 =?us-ascii?Q?OdCYL9Zr3ibExauGmlPXrEETyXFNjTGNZk1Ukk2ISxWi1LTjPeY76CyzLMqX?=
 =?us-ascii?Q?B+sjN+IM6jJ5zo7121M0f7e+1CzG48KW+HOTS84YdhL99zGh4ZdU6RyWJQHi?=
 =?us-ascii?Q?aBrl06SMcRLxTssS24AxFefNj1PWxllUFQWp2S3MYXHWcYV9jL2cktLAn9yp?=
 =?us-ascii?Q?YVFaTTKlEntuDp0vtHeIHOJLScSB5Nq4maBFOzAiVI+WYXQboNiL4Z+PeicG?=
 =?us-ascii?Q?5gg0MaTn/SKU6QkutEX74dABw9LRkc+wsfsEr0dkwgIiasTIkGMVDw81HlIU?=
 =?us-ascii?Q?fAeUZnRHTFQRannFr9+vL5W6yUwSMchOk+Ka9oPCu10ZM68TL5fKei6gNZOS?=
 =?us-ascii?Q?YN35M87ZlznrBEcZN/D/dhTRjzvCkmwAOsmLCHUzc54hFuyOwmZw5hslHoE4?=
 =?us-ascii?Q?+1jlGJzB4UBCjTVpi9HgfNz3vC+4P1ufx601aw2RgE2fKge35mE3FKN10Jaq?=
 =?us-ascii?Q?HANToO8jV3oKiU9w713uqX3PsnrLNUsIc3AdhbU1dd3Mq7rXcAuYswTHL2dw?=
 =?us-ascii?Q?Kl6fZanjo1wIXiZCWdZ2BSxogtKXVsmDONzewkWxugCQfcjgEF/uZwJaMfyX?=
 =?us-ascii?Q?HhtaUYvE1CP6lhCM2WKXM9kxwLA002XWLos2kTUeCxzCA5pUXPGez/tiQ57T?=
 =?us-ascii?Q?GNJdO/jLi9hJXuiKY1TuUU7N/Iu42oy4sIjLfI5zEddC7wNB/7omQBbu4YJF?=
 =?us-ascii?Q?fg9LMfQtLG6MS6hgfv+b5u9j3li+wx31Axw3f0eKgA4nwyoqR72glghEuK2O?=
 =?us-ascii?Q?bbJtu8omldo+6iegXLoaRpCgyI/VKvzJe02Cj5o5XatZkYRcxCI7QizRGz7a?=
 =?us-ascii?Q?39gPmvNmfS6xqLE5FsiGepqFhH9gTZUq9eaoGRXjEO9xNHZ4lpNa3rZt9DgO?=
 =?us-ascii?Q?2WkgBHkBbq3DGpAap+2uYoGVclT9QxaU5Ms/+3FpRjMNBawDlSRsfPuQhhUZ?=
 =?us-ascii?Q?w2t/bR3w5SknqG5yzUL3WAv3gnkPt5g8He5rtLLEH4P0QNO8Rd6zmRWePL9p?=
 =?us-ascii?Q?kf18eZbMZCAs9z6UFibi71Zv239Cppm8xjbhgM/9S4ehIxNJTZXuupEa93iu?=
 =?us-ascii?Q?5Fgv/IWOTHX9dxPg4ugWXnq9viipCQAmQE5OgDCc8PXNX0PLXlodFkw+JLdM?=
 =?us-ascii?Q?4HCQedsFCgqkS4QD1DkNKCc8XtfbxRH7z71KdygVwoFfUmvMcmqoA6iAIrVA?=
 =?us-ascii?Q?WPyrDt9Ai7hsQ05JV2EudWOwoLq7Ba5jdySGZb+hLyjJgCCKp4UC+QPBGc6G?=
 =?us-ascii?Q?00pc7skpRFOsQsNrlGyLn/h1x9uKFH3iqKff7B+jJzJmzTU60lsZuQHFPeT1?=
 =?us-ascii?Q?AeUcBpC532pA/i6tiV6dmizeUChkYFJJUIHdbDqDZnSNQan3ip8CPH/cxt2w?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0578dd38-5730-4824-8fa7-08dad18bc081
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 21:58:58.8753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xt6t4JAG1e6my7YIwkoeNbUjieIIOvV3nTJPHj2Au7hTER2d3w7n/KOeqMgMN2j29hz1MfQQj4ARJY9iDnn6I2Pw04xMNgsnQpw4m4ca7E8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6398
X-OriginatorOrg: intel.com

Robert Richter wrote:
> On 24.11.22 10:35:21, Dan Williams wrote:
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
> > [djbw: introduce devm_cxl_add_rch_dport()]
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/cxl/acpi.c            |   54 ++++++++++++++++++++++++++++++++--------
> >  drivers/cxl/core/port.c       |   42 +++++++++++++++++++++++++++----
> >  drivers/cxl/core/regs.c       |   56 +++++++++++++++++++++++++++++++++++++++++
> >  drivers/cxl/cxl.h             |   16 ++++++++++++
> >  tools/testing/cxl/Kbuild      |    1 +
> >  tools/testing/cxl/test/cxl.c  |   10 +++++++
> >  tools/testing/cxl/test/mock.c |   19 ++++++++++++++
> >  tools/testing/cxl/test/mock.h |    3 ++
> >  8 files changed, 186 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > index 50d82376097c..1224add13529 100644
> > --- a/drivers/cxl/acpi.c
> > +++ b/drivers/cxl/acpi.c
> > @@ -9,6 +9,8 @@
> >  #include "cxlpci.h"
> >  #include "cxl.h"
> >  
> > +#define CXL_RCRB_SIZE	SZ_8K
> > +
> >  static unsigned long cfmws_to_decoder_flags(int restrictions)
> >  {
> >  	unsigned long flags = CXL_DECODER_F_ENABLE;
> > @@ -215,6 +217,11 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> >  	if (rc)
> >  		return rc;
> >  
> > +	if (dport->rch) {
> > +		dev_info(bridge, "host supports CXL (restricted)\n");
> > +		return 0;
> > +	}
> 
> This change comes after devm_cxl_register_pci_bus() to serve the
> cxl_port_to_pci_bus() in devm_cxl_port_enumerate_dports() in
> cxl_port_probe(). A root port is not probed and
> devm_cxl_port_enumerate_dports() will be never called, so we could
> jump out before devm_cxl_register_pci_bus().

Good point.

> On the other side we might want to be ready to use
> cxl_port_to_pci_bus() elsewhere in later changes. RCHs would not work
> then.

At least cxl_port_to_pci_bus() as is will work fine for the RCD
endpoint-cxl-port, so I think it is ok to leave this alone for now.

> 
> > +
> >  	port = devm_cxl_add_port(host, bridge, dport->component_reg_phys,
> >  				 dport);
> >  	if (IS_ERR(port))
> > @@ -228,27 +235,46 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> >  struct cxl_chbs_context {
> >  	struct device *dev;
> >  	unsigned long long uid;
> > -	resource_size_t chbcr;
> > +	struct acpi_cedt_chbs chbs;
> >  };
> >  
> > -static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,
> > -			 const unsigned long end)
> > +static int cxl_get_chbs(union acpi_subtable_headers *header, void *arg,
> > +			const unsigned long end)
> >  {
> >  	struct cxl_chbs_context *ctx = arg;
> >  	struct acpi_cedt_chbs *chbs;
> >  
> > -	if (ctx->chbcr)
> > +	if (ctx->chbs.base)
> >  		return 0;
> >  
> >  	chbs = (struct acpi_cedt_chbs *) header;
> >  
> >  	if (ctx->uid != chbs->uid)
> >  		return 0;
> > -	ctx->chbcr = chbs->base;
> > +	ctx->chbs = *chbs;
> >  
> >  	return 0;
> >  }
> >  
> > +static resource_size_t cxl_get_chbcr(struct cxl_chbs_context *ctx)
> > +{
> > +	struct acpi_cedt_chbs *chbs = &ctx->chbs;
> > +
> > +	if (!chbs->base)
> > +		return CXL_RESOURCE_NONE;
> > +
> > +	if (chbs->cxl_version != ACPI_CEDT_CHBS_VERSION_CXL11)
> > +		return chbs->base;
> > +
> > +	if (chbs->length != CXL_RCRB_SIZE)
> > +		return CXL_RESOURCE_NONE;
> > +
> > +	dev_dbg(ctx->dev, "RCRB found for UID %lld: %pa\n", ctx->uid,
> > +		&chbs->base);
> > +
> > +	return cxl_rcrb_to_component(ctx->dev, chbs->base, CXL_RCRB_DOWNSTREAM);
> > +}
> > +
> 
> I have an improved version of this code which squashes cxl_get_chbcr()
> into cxl_get_chbs() (basically extends the original cxl_get_chbcr()
> function).

Care to send it? If I see it before the next posting I can fold it in,
otherwise it can be a follow-on cleanup.

> 
> >  static int add_host_bridge_dport(struct device *match, void *arg)
> >  {
> >  	acpi_status status;
> > @@ -258,6 +284,7 @@ static int add_host_bridge_dport(struct device *match, void *arg)
> >  	struct cxl_chbs_context ctx;
> >  	struct acpi_pci_root *pci_root;
> >  	struct cxl_port *root_port = arg;
> > +	resource_size_t component_reg_phys;
> >  	struct device *host = root_port->dev.parent;
> >  	struct acpi_device *hb = to_cxl_host_bridge(host, match);
> >  
> > @@ -274,21 +301,28 @@ static int add_host_bridge_dport(struct device *match, void *arg)
> >  	dev_dbg(match, "UID found: %lld\n", uid);
> >  
> >  	ctx = (struct cxl_chbs_context) {
> > -		.dev = host,
> > +		.dev = match,
> >  		.uid = uid,
> >  	};
> > -	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbcr, &ctx);
> > +	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbs, &ctx);
> >  
> > -	if (ctx.chbcr == 0) {
> > +	component_reg_phys = cxl_get_chbcr(&ctx);
> > +	if (component_reg_phys == CXL_RESOURCE_NONE) {
> >  		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
> >  		return 0;
> >  	}
> >  
> > -	dev_dbg(match, "CHBCR found: 0x%08llx\n", (u64)ctx.chbcr);
> > +	dev_dbg(match, "CHBCR found: %pa\n", &component_reg_phys);
> >  
> >  	pci_root = acpi_pci_find_root(hb->handle);
> >  	bridge = pci_root->bus->bridge;
> > -	dport = devm_cxl_add_dport(root_port, bridge, uid, ctx.chbcr);
> > +	if (ctx.chbs.cxl_version == ACPI_CEDT_CHBS_VERSION_CXL11)
> > +		dport = devm_cxl_add_rch_dport(root_port, bridge, uid,
> > +					       component_reg_phys,
> > +					       ctx.chbs.base);
> 
> Yes, this new function makes the rcrb handling much more simpler.
> 
> > +	else
> > +		dport = devm_cxl_add_dport(root_port, bridge, uid,
> > +					   component_reg_phys);
> >  	if (IS_ERR(dport))
> >  		return PTR_ERR(dport);
> >  
> > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > index d225267c69bb..d9fe06e1462f 100644
> > --- a/drivers/cxl/core/port.c
> > +++ b/drivers/cxl/core/port.c
> > @@ -628,6 +628,8 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
> >  			iter = to_cxl_port(iter->dev.parent);
> >  		if (iter->host_bridge)
> >  			port->host_bridge = iter->host_bridge;
> > +		else if (parent_dport->rch)
> > +			port->host_bridge = parent_dport->dport;
> 
> Yes, looks good. This makes the endpoint a child of a CXL root port,
> not the ACPI0017 the root device.
> 
> >  		else
> >  			port->host_bridge = iter->uport;
> >  		dev_dbg(uport, "host-bridge: %s\n", dev_name(port->host_bridge));
> > @@ -899,10 +901,15 @@ static void cxl_dport_unlink(void *data)
> >  	sysfs_remove_link(&port->dev.kobj, link_name);
> >  }
> >  
> > -static struct cxl_dport *__devm_cxl_add_dport(struct cxl_port *port,
> > -					      struct device *dport_dev,
> > -					      int port_id,
> > -					      resource_size_t component_reg_phys)
> > +enum cxl_dport_mode {
> > +	CXL_DPORT_VH,
> > +	CXL_DPORT_RCH,
> > +};
> > +
> > +static struct cxl_dport *
> > +__devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
> > +		     int port_id, resource_size_t component_reg_phys,
> > +		     enum cxl_dport_mode mode, resource_size_t rcrb)
> >  {
> >  	char link_name[CXL_TARGET_STRLEN];
> >  	struct cxl_dport *dport;
> > @@ -932,6 +939,9 @@ static struct cxl_dport *__devm_cxl_add_dport(struct cxl_port *port,
> >  	dport->port_id = port_id;
> >  	dport->component_reg_phys = component_reg_phys;
> >  	dport->port = port;
> > +	if (mode == CXL_DPORT_RCH)
> > +		dport->rch = true;
> 
> Alternatively an inline function could be added which checks
> dport->rcrb for a valid address.

I like it. Especially because a valid RCRB is needed to register the
dport in the first instance. I think it looks ok without an inline
function:

@@ -901,15 +901,10 @@ static void cxl_dport_unlink(void *data)
        sysfs_remove_link(&port->dev.kobj, link_name);
 }
 
-enum cxl_dport_mode {
-       CXL_DPORT_VH,
-       CXL_DPORT_RCH,
-};
-
 static struct cxl_dport *
 __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
                     int port_id, resource_size_t component_reg_phys,
-                    enum cxl_dport_mode mode, resource_size_t rcrb)
+                    resource_size_t rcrb)
 {
        char link_name[CXL_TARGET_STRLEN];
        struct cxl_dport *dport;
@@ -939,7 +934,7 @@ __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
        dport->port_id = port_id;
        dport->component_reg_phys = component_reg_phys;
        dport->port = port;
-       if (mode == CXL_DPORT_RCH)
+       if (rcrb != CXL_RESOURCE_NONE)
                dport->rch = true;
        dport->rcrb = rcrb;
 

> 
> > +	dport->rcrb = rcrb;
> >  
> >  	cond_cxl_root_lock(port);
> >  	rc = add_dport(port, dport);
> > @@ -973,7 +983,8 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
> >  	struct cxl_dport *dport;
> >  
> >  	dport = __devm_cxl_add_dport(port, dport_dev, port_id,
> > -				     component_reg_phys);
> > +				     component_reg_phys, CXL_DPORT_VH,
> > +				     CXL_RESOURCE_NONE);
> >  	if (IS_ERR(dport)) {
> >  		dev_dbg(dport_dev, "failed to add dport to %s: %ld\n",
> >  			dev_name(&port->dev), PTR_ERR(dport));
> > @@ -986,6 +997,27 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
> >  }
> >  EXPORT_SYMBOL_NS_GPL(devm_cxl_add_dport, CXL);
> >  
> > +struct cxl_dport *devm_cxl_add_rch_dport(struct cxl_port *port,
> > +					 struct device *dport_dev, int port_id,
> > +					 resource_size_t component_reg_phys,
> > +					 resource_size_t rcrb)
> 
> The documentation header is missing for that.

Added the following and clarified that @rcrb is mandatory:

@@ -966,7 +961,7 @@ __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
 }
 
 /**
- * devm_cxl_add_dport - append downstream port data to a cxl_port
+ * devm_cxl_add_dport - append VH downstream port data to a cxl_port
  * @port: the cxl_port that references this dport
  * @dport_dev: firmware or PCI device representing the dport
  * @port_id: identifier for this dport in a decoder's target list
@@ -997,6 +991,16 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_add_dport, CXL);
 
+/**
+ * devm_cxl_add_rch_dport - append RCH downstream port data to a cxl_port
+ * @port: the cxl_port that references this dport
+ * @dport_dev: firmware or PCI device representing the dport
+ * @port_id: identifier for this dport in a decoder's target list
+ * @component_reg_phys: optional location of CXL component registers
+ * @rcrb: mandatory location of a Root Complex Register Block
+ *
+ * See CXL 3.0 9.11.8 CXL Devices Attached to an RCH
+ */
 struct cxl_dport *devm_cxl_add_rch_dport(struct cxl_port *port,
                                         struct device *dport_dev, int port_id,
                                         resource_size_t component_reg_phys,

> 
> > +{
> > +	struct cxl_dport *dport;
> > +
> > +	dport = __devm_cxl_add_dport(port, dport_dev, port_id,
> > +				     component_reg_phys, CXL_DPORT_RCH, rcrb);
> > +	if (IS_ERR(dport)) {
> > +		dev_dbg(dport_dev, "failed to add RCH dport to %s: %ld\n",
> > +			dev_name(&port->dev), PTR_ERR(dport));
> > +	} else {
> > +		dev_dbg(dport_dev, "RCH dport added to %s\n",
> > +			dev_name(&port->dev));
> > +	}
> > +
> > +	return dport;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(devm_cxl_add_rch_dport, CXL);
> > +
> >  static int add_ep(struct cxl_ep *new)
> >  {
> >  	struct cxl_port *port = new->dport->port;
> > diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
> > index ec178e69b18f..7c2a85dc4125 100644
> > --- a/drivers/cxl/core/regs.c
> > +++ b/drivers/cxl/core/regs.c
> > @@ -307,3 +307,59 @@ int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
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
> > +	cmd = readw(addr + PCI_COMMAND);
> > +	bar0 = readl(addr + PCI_BASE_ADDRESS_0);
> > +	bar1 = readl(addr + PCI_BASE_ADDRESS_1);
> > +	iounmap(addr);
> > +	release_mem_region(rcrb, SZ_4K);
> > +
> > +	/* sanity check */
> > +	if (cmd == 0xffff)
> > +		return CXL_RESOURCE_NONE;
> 
> The spec says offset 0 should be checked (32 bit) which is always
> non-FF if implemented. This requires another read.
> 
> cmd is most of the cases also non-zero, so probably checking cmd
> instead will have the same effect. Still worth changing that.
> 
> If the downstream port's rcrb is all FFs, it is a FW bug. Could be
> worth a message.

Ok, makes sense, added:

@@ -335,15 +336,22 @@ resource_size_t cxl_rcrb_to_component(struct device *dev,
                return CXL_RESOURCE_NONE;
        }
 
+       id = readl(addr + PCI_VENDOR_ID);
        cmd = readw(addr + PCI_COMMAND);
        bar0 = readl(addr + PCI_BASE_ADDRESS_0);
        bar1 = readl(addr + PCI_BASE_ADDRESS_1);
        iounmap(addr);
        release_mem_region(rcrb, SZ_4K);
 
-       /* sanity check */
-       if (cmd == 0xffff)
+       /*
+        * Sanity check, see CXL 3.0 Figure 9-8 CXL Device that Does Not
+        * Remap Upstream Port and Component Registers
+        */
+       if (id == (u32) -1) {
+               if (which == CXL_RCRB_DOWNSTREAM)
+                       dev_err(dev, "Failed to access Downstream Port RCRB\n");
                return CXL_RESOURCE_NONE;
+       }
        if ((cmd & PCI_COMMAND_MEMORY) == 0)
                return CXL_RESOURCE_NONE;
        if (bar0 & (PCI_BASE_ADDRESS_MEM_TYPE_1M | PCI_BASE_ADDRESS_SPACE_IO))

