Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id D40651A1EC9
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jul 2016 01:13:01 -0700 (PDT)
Date: Fri, 15 Jul 2016 16:12:12 +0800
From: Haozhong Zhang <haozhong.zhang@intel.com>
Subject: Re: [PATCH 1/2] nfit: fix _FIT evaluation memory leak
Message-ID: <20160715081212.l3rfkk2wvh7bjdo5@hz-desktop>
References: <146855333714.573.13934675433503265133.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160715075515.ufwwvwngteqyovsk@hz-desktop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160715075515.ufwwvwngteqyovsk@hz-desktop>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, linux-acpi@vger.kernel.org, stable@vger.kernel.org, Xiao Guangrong <guangrong.xiao@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 07/15/16 15:55, Haozhong Zhang wrote:
> On 07/14/16 20:28, Dan Williams wrote:
> > acpi_evaluate_object() allocates memory. Free the buffer allocated
> > during acpi_nfit_add().
> > 
> > Cc: <stable@vger.kernel.org>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Reported-by: Xiao Guangrong <guangrong.xiao@intel.com>
> > Reported-by: Haozhong Zhang <haozhong.zhang@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/acpi/nfit.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> > index 0497175ee6cb..008dbaaa2b75 100644
> > --- a/drivers/acpi/nfit.c
> > +++ b/drivers/acpi/nfit.c
> > @@ -2414,12 +2414,15 @@ static int acpi_nfit_add(struct acpi_device *adev)
> >  			acpi_desc->nfit =
> >  				(struct acpi_nfit_header *)obj->buffer.pointer;
> >  			sz = obj->buffer.length;
> > +			rc = acpi_nfit_init(acpi_desc, sz);
> >  		} else
> >  			dev_dbg(dev, "%s invalid type %d, ignoring _FIT\n",
> >  				 __func__, (int) obj->type);
> 
> 'rc' is not set in this path, so it maybe used uninitialized by 'if (rc)' below.
> Should we set it to a non-zero value in this path?

'rc' should be set to 0 here, as what patch 2 does. Sorry for my mistake.

Haozhong
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
