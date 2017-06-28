Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4913421CB74A7
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 16:13:48 -0700 (PDT)
Date: Wed, 28 Jun 2017 17:15:19 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v2 5/7] acpi, nfit: Show bus_dsm_mask
Message-ID: <20170628231519.GC26439@anatevka.americas.hpqcorp.net>
References: <cover.1497939166.git.jerry.hoemann@hpe.com>
 <658db8f8c7a5042a2049e5fe08c0c68b4586526e.1497939166.git.jerry.hoemann@hpe.com>
 <CAPcyv4ifdcdhmG3AuyJ0RwB=TSObp=Gg1qk9CnzJWmGs4etYGw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4ifdcdhmG3AuyJ0RwB=TSObp=Gg1qk9CnzJWmGs4etYGw@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 28, 2017 at 02:07:20PM -0700, Dan Williams wrote:
> On Tue, Jun 20, 2017 at 9:51 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > Add bus_dsm_mask to sysfs display under /sys/bus/nd/devices/ndbusX/nfit.
> >
> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> > ---
> >  drivers/acpi/nfit/core.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > index 9d281a4..f133b3e 100644
> > --- a/drivers/acpi/nfit/core.c
> > +++ b/drivers/acpi/nfit/core.c
> > @@ -928,6 +928,15 @@ static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
> >         return 0;
> >  }
> >
> > +static ssize_t bus_dsm_mask_show(struct device *dev,
> > +               struct device_attribute *attr, char *buf)
> > +{
> > +       struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
> > +       struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
> > +       return sprintf(buf, "%#lx\n", nd_desc->bus_dsm_mask);
> > +}
> > +static DEVICE_ATTR_RO(bus_dsm_mask);
> > +
> >  static ssize_t revision_show(struct device *dev,
> >                 struct device_attribute *attr, char *buf)
> >  {
> > @@ -1064,6 +1073,7 @@ static umode_t nfit_visible(struct kobject *kobj, struct attribute *a, int n)
> >         &dev_attr_revision.attr,
> >         &dev_attr_scrub.attr,
> >         &dev_attr_hw_error_scrub.attr,
> > +       &dev_attr_bus_dsm_mask.attr,
> >         NULL,
> >  };
> 
> I think it's redundant to keep 'bus_' in the name of the attribute
> since 'bus' is included in the sysfs path. You can use DEVICE_ATTR()
> instead of DEVICE_ATTR_RO() to specify the attribute name manually,
> and get around the collision with the existing dsm_mash_show()
> routine.

DEVICE_ATTR and DEVICE_ATTR_RO uses the same tokenization & stringification
schemes, so that doesn't disambiguate.  They need to be different
case sensitive names if they are to be in same source file.

Do you want me to change name to root_dsm_mask?  or change case: DSM_MASK?



-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
