Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
 [148.163.143.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1C82211FB8B9
 for <linux-nvdimm@lists.01.org>; Mon, 15 Apr 2019 11:29:31 -0700 (PDT)
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: [PATCH ndctl] ndctl, region: return the rc value in region_action
Date: Mon, 15 Apr 2019 18:29:28 +0000
Message-ID: <AT5PR8401MB1169A9F7AADEA04F521CBDD0AB2B0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190415082357.31127-1-yi.zhang@redhat.com>
 <CAPcyv4g5cp=5QZsTi02ouwqLPcoTFmos+146p9_jkgUofEhnzQ@mail.gmail.com>
In-Reply-To: <CAPcyv4g5cp=5QZsTi02ouwqLPcoTFmos+146p9_jkgUofEhnzQ@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, Yi Zhang <yi.zhang@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Dan Williams
> Sent: Monday, April 15, 2019 11:29 AM
> Subject: Re: [PATCH ndctl] ndctl, region: return the rc value in region_action
> 
> On Mon, Apr 15, 2019 at 1:24 AM Yi Zhang <yi.zhang@redhat.com> wrote:
> >
> > if region_action failed, return the rc valude instead of 0

valude s/b value

> >
> > Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
> > ---
> >  ndctl/region.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/ndctl/region.c b/ndctl/region.c
> > index 993b3f8..7945007 100644
> > --- a/ndctl/region.c
> > +++ b/ndctl/region.c
> > @@ -89,7 +89,7 @@ static int region_action(struct ndctl_region *region, enum device_action mode)
> >                 break;
> >         }
> >
> > -       return 0;
> > +       return rc;
> >  }
> 
> Looks good to me:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Perhaps a similar change should be made to ndctl_namespace_disable_safe(),
one of the functions called by region_action() whose rc is propagated, to 
propagate the rc from ndctl_namespace_disable_invalidate().




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
