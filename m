Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86FC4681
	for <nvdimm@lists.linux.dev>; Thu, 11 Aug 2022 18:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660243399; x=1691779399;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=b0q/gaUTxyunCehmGpYjJxOxVgjFtvt6llY/p0mkCjk=;
  b=AvRh84IyHCeQTsRZBfYcZhQ7UwqG4O4kq/DL/JjUu7U0Iszj7CZBfef/
   AcmeNNCyBhL3Oe/H7w+JYjfkHrlJfVNHign+cS7y442dGWi4zPa6VxVTo
   QhD/nebloCjLCmcO5oX8NXhFe+1TlYMzGOssAVpOfW+zLHXYtmYX4misq
   rQafIFNoC+EuoAA31Y6wghLSwhFd8wzgDw42mNOF3IF9qINFG6j0hn9ij
   2qKTKzev27xXpdg2T+Xr8dHE2KKdEbgbD7fDAgv4pfWvPC6ag7NfgWyEZ
   I3AX03uKEa4CMTfIC3W2N7XNPxtAzg2ES6wW7zOiANbiryyW/fvDp9w1y
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="278381890"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="278381890"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 11:42:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="605653508"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 11 Aug 2022 11:42:48 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 11:42:48 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 11:42:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 11:42:47 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 11:42:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOEzdE+IpFbR1TZHF8aKKIhnVEGk1WigxtPBUyPheGBxISz3JLr6MEKBaVnMHioQRTkCuh6g1FPRXD/Kt0obN/FXuB1Yekm+9cVFHqH7H8qCCb9NDIe+t2Ce1mJV/+mG/U2ZaVbFq25z0ueNuNjNCi7vmwlPgZowma43lxDIJh++y2hYyueetTjgn3JFXixu20NPZTKbiYNVSQw64ViqvaNrY6QitrDjnuAq3Ic360eesJsM3uQb/c1yJW7YBmiFRM5jCLhqCxpBuhsZbo7tRmxzd7xi1JJEW5q4XN3CwPrrGlS4DLjUzUdx5/38X+ZXJNUuJWFffvftkWxfvfoLkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/7RYDo/x3oPxzofOpuDptxHPhUQ4ekKjhSXeN9DX0g=;
 b=BoniFVFUN5eCAWIdgm1LdmDSAYxZeaEM4QyK6Rl5HMnRc9GdDjO1gY+eDm+EZbGNLPbX9qJUyq8cswB++IphM3KB5H5UDLczEB2vN6fEEwC5Kl3yz0VxEnwYFh+ZoB0sWBErRH1WjHyhBH20WdhaDvPFHE0cWKAMh/XPyXOBaa0plwkJGqDIH7sSC4wvUZCv2Ywt6gDiYD2eaxEt7gHNe1eMMnfI8pEkC5LjlK+Eg4l5AksN4ivRE//qmjBthqEdwSeoKbG+KZjG+/9O0AFzC6lKe87St06KpqyABINLGOYp16nO/FtXFHD/35ZcQHnam3wTie1MnRYvcOqTt4r5bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MW4PR11MB5911.namprd11.prod.outlook.com
 (2603:10b6:303:16b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Thu, 11 Aug
 2022 18:42:45 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 18:42:45 +0000
Date: Thu, 11 Aug 2022 11:42:43 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: "Schofield, Alison" <alison.schofield@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH v2 05/10] libcxl: add low level APIs for region
 creation
Message-ID: <62f54da3f6bd_3ce68294d9@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
 <20220810230914.549611-6-vishal.l.verma@intel.com>
 <62f471fbd22a2_7168c29410@dwillia2-xfh.jf.intel.com.notmuch>
 <417003cc6a7acf80c5dcf9c1d6d0321ebc636a21.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <417003cc6a7acf80c5dcf9c1d6d0321ebc636a21.camel@intel.com>
X-ClientProxiedBy: SJ0PR13CA0073.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::18) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8eda2eed-edd5-4fc4-3052-08da7bc947d5
X-MS-TrafficTypeDiagnostic: MW4PR11MB5911:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zxLE+B/H1PHd5KtMSzgUAhb2UJuoBCe56Ne/vxSx96gQ2+NFO4uaATiUH4dNuAKMu/3QEfmvexLKUhDF5hGtn0nrhN+2xtXHQRIRJ6ZAHgXKSwFkl+VPiut4d/rDIG71VaUpnsZo8lzfKzwg2CDrsBQpXvFjWR1LvK8TCiVpO1pVFSdlSpYQ4puBshrF/0hpHiOV8r/nmKqMm0WHo7bEKe4kT42k/zshEcnnhHX58G0hBxh929ihPNUG4OB2TgjEee03pFySord133oyoClZ9cbUPq3DVzBeP8iz4PzRyw97/yT6hPOgi6aLbTpjq/b4mOUs8grycTVEEvsMedtMwhcyWk4MIYpIR7HWSCzXehgoMSEIMGNiEMxHhYUsfMzP7PDoFGmWobaPjT6ngvlsgdst7OOJA74Z/7WYsC5oINrxhxKalTPxkTaYzMJ+tAEQauZADy23JFZhW71mIeu/YQLDnCs8pLIvJFXNNj6uZxrKHYjBbFSEDNU5H/HeAPdtI4MM6a6UCogXCM+SrgMo4joSm6E7rOlMBcMl+4hQznKPx7IVW8fj2s8w3/AwSBRRZrd6CjvNgO8a4s7t1HWCJr5nhixVTxvzF3hFQ2zZkBELMjG8ja9HB7vkyj7HavS9UoKZqYuCUZo21QexAuM+ZszXjNE13r7RBpdcyb/aNUzmq1OWLTmXivNBGHH0/n+MT/KuPDjWdUVrsMKX/AruOVjIUmd5vPWH0kMqPzFKFtpFb4wII7X+cEkS0FSHmoGX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(366004)(39860400002)(396003)(82960400001)(2906002)(9686003)(6506007)(83380400001)(26005)(6512007)(107886003)(38100700002)(41300700001)(186003)(5660300002)(8936002)(8676002)(66476007)(4326008)(110136005)(86362001)(478600001)(316002)(54906003)(66946007)(6486002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?1dME+qe6pkuNOHLwbq4HFuxcoTVQVxlme3UfkUaNlaPk2Dg+2Bg8CDp3UO?=
 =?iso-8859-1?Q?9kLnOTZx8o+xsbM7uOr+Vs6n8s/IMFDaKFzQpeqa2YvQoEaRAXefvwyUoX?=
 =?iso-8859-1?Q?1x7EoZQXq+fjGV3vaWf/8yRhJZyLb84HfaTxKxke7p4LpHN/U3QhL89eg3?=
 =?iso-8859-1?Q?0phJTiXpXMOKQiyXSscnUtGkTSL8m7yvObLAqvTG+gPExnao3PEAkqgjET?=
 =?iso-8859-1?Q?GE5YDKqLUl+XppEVXBgTF+a6fmTxwpYqjcnHuuQjOaGubPjl0ZCyAIpnJ3?=
 =?iso-8859-1?Q?A1Ypi/W1J2rz0YyfUBJQYpRzKqZqNhA6zHetaMJB38TV9LweH62ak9WzHv?=
 =?iso-8859-1?Q?r9KKjc2N2+o9Qh2Iu6IuvMssEUUlUjA+H23qDp9wIVnYxtZ5WUIuY5+xKg?=
 =?iso-8859-1?Q?c81lp2xSZT0CXaUnqCc0wGexilSvuHTY6T4eNPshfRpJpoJ5oWm3JAsqQj?=
 =?iso-8859-1?Q?Mk9qOuhT6mF+UQVdevCdTefaD8QgoKzZlujv0KhOCNfD/WNAceUnv9DWqQ?=
 =?iso-8859-1?Q?jox3C27B/nbOfi9CdeOLyWLyd43WC+O8YAww9aaJ+DRNHFhBXZxr7fx2bW?=
 =?iso-8859-1?Q?U2jN3s7O3kByT9I+bsgsB7D1DIqrMTFYMDxfof+MAsw3GvdHjuS9ulXIUk?=
 =?iso-8859-1?Q?pvzW0R9A71bm+RRlcd14HL06X9Aq1tfiyhVi/V0Ur/98QTtB/2V4ztxjkY?=
 =?iso-8859-1?Q?j0qzNMsdRnQDl0TQ9mCI0sZgwCLImPFpv0fZuEDKqK5XZeLIu4EhrgjHrq?=
 =?iso-8859-1?Q?35S465fjlgftB00gYm9qvjoWbcILQ/eJmrh8xlzV/DnxqOTDNJr+WJaFZW?=
 =?iso-8859-1?Q?9I03BU2Z5BXslNyeTsHMit1ISuDqvj4C99wLCcl4UevkzwHNkjP1zHigt5?=
 =?iso-8859-1?Q?hj8AZZu3MGHKJ9ZjtzpwMASnTu985Q0NCOTzznu0MDzsNY2xmrBYj0NiUW?=
 =?iso-8859-1?Q?kA29HkOUOE8biep5RopqOenJd3FjN45IBetTnLtznZHMOIbNIeSjJx0sCk?=
 =?iso-8859-1?Q?cncIc+lVZnIM9KcaEMm6Gnw3YWDwa/aPFbGslmGDxvrrq6nHsyhExMNcpw?=
 =?iso-8859-1?Q?HI7FtwklSDtKb1qteKr+doxu9ezoU9Vz2egd30bGH2ObQkEE4tzFzA7E78?=
 =?iso-8859-1?Q?I6s1GGzQnfMXPG9TUBnWo+IqvDCQmYueYr+pFIkdrgJFf9fnCkRPckKlr8?=
 =?iso-8859-1?Q?O292oEnbd2MhPDRaECoTLp4uD8u20Hm6l7ReKOyrGP/VuxSD4CIajAYQ5k?=
 =?iso-8859-1?Q?RsUDS7qpa1r5ywCO4hD0m3AcCUA9yjTjemAHkPn2ZC6A3Wu4h82zs7RIqO?=
 =?iso-8859-1?Q?bkkoWs4uWIM9pjQfDwGggn4G797hMotSQ7xnxcOsnyJbVmSMTpm9yj6xV/?=
 =?iso-8859-1?Q?LhSRnI75VgDdyOoqkeDAGfW6sl6Q7J/fcqutnizJqGVQfZH7XzM0Dr+eZE?=
 =?iso-8859-1?Q?kGYeH4qFYjgk+j1PisWJ8wSQMrknYGB8MRSNuVYfrIvNf80/HuDirLQFLj?=
 =?iso-8859-1?Q?PCd8WGSUZ0M1JReGzh/T7uet2GN2mAX7Qw6MDoNAL4lRFKBcaVCEA8jzIG?=
 =?iso-8859-1?Q?Sg8PGmg3liLJgd1K53Kx3FmgYLRc4NinhhTWKYB+JXu8FU11m053AKvn3A?=
 =?iso-8859-1?Q?xPvMUoE5NX2dAXEjqYtzDJyeVWte9FQDbl/2Z4PPZMMllgM9YEkW5p6A?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eda2eed-edd5-4fc4-3052-08da7bc947d5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 18:42:45.1705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AC/z9UachQWMDr3iZvZnT3OTUh/YtPqHhEIqdNfQvJ3Q+imsgMGST0kzq6np2B6zyr/6XkvY8s5tHxzySvH/FZjEflqp0k+6B+fiBTS6K00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5911
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Wed, 2022-08-10 at 20:05 -0700, Dan Williams wrote:
> > Vishal Verma wrote:
> > > Add libcxl APIs to create a region under a given root decoder, and to
> > > set different attributes for the new region. These allow setting the
> > > size, interleave_ways, interleave_granularity, uuid, and the target
> > > devices for the newly minted cxl_region object.
> > > 
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > >  Documentation/cxl/lib/libcxl.txt |  69 ++++++
> > >  cxl/lib/private.h                |   2 +
> > >  cxl/lib/libcxl.c                 | 377 ++++++++++++++++++++++++++++++-
> > >  cxl/libcxl.h                     |  23 +-
> > >  cxl/lib/libcxl.sym               |  16 ++
> > >  5 files changed, 484 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> > > index 7a38ce4..c3a8f36 100644
> > > --- a/Documentation/cxl/lib/libcxl.txt
> > > +++ b/Documentation/cxl/lib/libcxl.txt
> > > @@ -508,6 +508,75 @@ device to represent the root of a PCI device hierarchy. The
> > >  cxl_target_get_physical_node() helper returns the device name of that
> > >  companion object in the PCI hierarchy.
> > >  
> > > +==== REGIONS
> > > +A CXL region is composed of one or more slices of CXL memdevs, with configurable
> > > +interleave settings - both the number of interleave ways, and the interleave
> > > +granularity. In terms of hierarchy, it is the child of a CXL root decoder. A root
> > > +decoder (recall that this corresponds to an ACPI CEDT.CFMWS 'window'), may have
> > > +multiple chile regions, but a region is strictly tied to one root decoder.
> > 
> > Mmm, that's a spicy region.
> > 
> > s/chile/child/
> 
> Hah yep will fix.
> 
> > 
> > > +
> > > +A region also defines a set of mappings which are slices of capacity on a memdev,
> > 
> > Since the above already defined that a region is composed of one or more
> > slices of CXL memdevs, how about:
> > 
> > "The slices that compose a region are called mappings. A mapping is a
> > tuple of 'memdev', 'endpoint decoder', and the 'position'.
> 
> Yep sounds good.
> 
> [snip]
> 
> > 
> > > +CXL_EXPORT struct cxl_region *
> > > +cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
> > > +{
> > > +       struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
> > > +       char *path = decoder->dev_buf;
> > > +       char buf[SYSFS_ATTR_SIZE];
> > > +       struct cxl_region *region;
> > > +       int rc;
> > > +
> > > +       sprintf(path, "%s/create_pmem_region", decoder->dev_path);
> > > +       rc = sysfs_read_attr(ctx, path, buf);
> > > +       if (rc < 0) {
> > > +               err(ctx, "failed to read new region name: %s\n",
> > > +                   strerror(-rc));
> > > +               return NULL;
> > > +       }
> > > +
> > > +       rc = sysfs_write_attr(ctx, path, buf);
> > > +       if (rc < 0) {
> > > +               err(ctx, "failed to write new region name: %s\n",
> > > +                   strerror(-rc));
> > > +               return NULL;
> > > +       }
> > 
> > I think there either needs to be a "decoder->regions_init = 0" here, or
> > a direct call to "add_cxl_region(decoder...)" just in case this context
> > had already listed regions before creating a new one.
> > 
> > I like the precision of "add_cxl_region()", but that needs to open code
> > some of the internals of sysfs_device_parse(), so maybe
> > "decoder->regions_init = 0" is ok for now.
> 
> Yes, I found that out - and added this - in patch 10 (I can instead
> move it here - it makes sense).
> 
> Until patch 10, during region creation, nothing had done regions_init
> until this point, so this happens to work. Patch 10 where we do walk
> the regions before this point to calculate the max available space,
> necessitates the reset here.
> 
> That being said, potentially all of patch 10 is squash-able into
> different bits of the series - I left it at the end so the
> max_available_extent stuff can be reviewed on its own.
> 
> I'm happy to go either way on squashing it or keeping it standalone.

If this was the kernel I would say squash, since bisecting might be
impacted, but as long as the fix is there later in the series I think
that's ok.

Note, I was less worried about the cxl-cli tool tripping over this, and
more about 3rd party applications using libcxl, but those are even less
likely to use a mid-release commit.
