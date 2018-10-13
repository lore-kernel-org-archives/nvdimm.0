Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 794C721173C7C
 for <linux-nvdimm@lists.01.org>; Sat, 13 Oct 2018 09:17:57 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id s69-v6so12093472oie.10
 for <linux-nvdimm@lists.01.org>; Sat, 13 Oct 2018 09:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <20181010060812.20068-1-oohall@gmail.com>
 <20181010060812.20068-3-oohall@gmail.com>
 <CAPcyv4jhs9f2DdOk30KU9___mWMtowQi0LP-OD1E+_5xFbxWgA@mail.gmail.com>
 <87h8hq122t.fsf@concordia.ellerman.id.au>
In-Reply-To: <87h8hq122t.fsf@concordia.ellerman.id.au>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 13 Oct 2018 09:17:44 -0700
Message-ID: <CAPcyv4h0b9jmrizygCEOU8GGMj-5yxz+vgEyVmVq+KNAozs+rA@mail.gmail.com>
Subject: Re: [PATCH 2/2] powerpc/pseries: Add driver for PAPR SCM regions
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
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Oct 13, 2018 at 5:08 AM Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
> > On Tue, Oct 9, 2018 at 11:21 PM Oliver O'Halloran <oohall@gmail.com> wrote:
> >>
> >> Adds a driver that implements support for enabling and accessing PAPR
> >> SCM regions. Unfortunately due to how the PAPR interface works we can't
> >> use the existing of_pmem driver (yet) because:
> >>
> ...
> >> +
> >> +static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
> >> +{
> >> +       struct device *dev = &p->pdev->dev;
> >> +       struct nd_mapping_desc mapping;
> >> +       struct nd_region_desc ndr_desc;
> >> +       unsigned long dimm_flags;
> >> +
> >> +       p->bus_desc.ndctl = papr_scm_ndctl;
> >> +       p->bus_desc.module = THIS_MODULE;
> >> +       p->bus_desc.of_node = p->pdev->dev.of_node;
> >> +       p->bus_desc.attr_groups = bus_attr_groups;
> >> +       p->bus_desc.provider_name = kstrdup(p->pdev->name, GFP_KERNEL);
> >> +
> >> +       if (!p->bus_desc.provider_name)
> >> +               return -ENOMEM;
> >> +
> >> +       p->bus = nvdimm_bus_register(NULL, &p->bus_desc);
> >> +       if (!p->bus) {
> >> +               dev_err(dev, "Error creating nvdimm bus %pOF\n", p->dn);
> >> +               return -ENXIO;
> >> +       }
> >> +
> >> +       dimm_flags = 0;
> >> +       set_bit(NDD_ALIASING, &dimm_flags);
> >> +
> >> +       p->nvdimm = nvdimm_create(p->bus, p, papr_scm_dimm_groups,
> >> +                               dimm_flags, PAPR_SCM_DIMM_CMD_MASK, 0, NULL);
> >
> > Looks good, although I'm just about to push out commits that change
> > this function signature to take a 'security_ops' pointer. If you need
> > a stable branch to base this on, let me know.
> ...
> >
> > Other than that looks ok to me:
> >
> > Acked-by: Dan Williams <dan.j.williams@intel.com>
> >
> > ...just the matter of what to do about function signature change.
>
> Yeah that's a bit of a bother.
>
> The ideal for me would be that you put the commit that changes the
> signature by itself in a branch based on 4.19-rc3 (or earlier), and then
> we could both just merge that.
>
> But not sure if that will work with whatever else you're trying to sync
> up with.

How about this, I'll move the new signature to an 'advanced':

    __nvdimm_create()

...and make the existing:

   nvdimm_create()

...a simple wrapper around the new functionality. That way no matter
what merge order we should be ok.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
