Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E16FF21173C90
 for <linux-nvdimm@lists.01.org>; Sat, 13 Oct 2018 05:08:31 -0700 (PDT)
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 2/2] powerpc/pseries: Add driver for PAPR SCM regions
In-Reply-To: <CAPcyv4jhs9f2DdOk30KU9___mWMtowQi0LP-OD1E+_5xFbxWgA@mail.gmail.com>
References: <20181010060812.20068-1-oohall@gmail.com>
 <20181010060812.20068-3-oohall@gmail.com>
 <CAPcyv4jhs9f2DdOk30KU9___mWMtowQi0LP-OD1E+_5xFbxWgA@mail.gmail.com>
Date: Sat, 13 Oct 2018 23:08:26 +1100
Message-ID: <87h8hq122t.fsf@concordia.ellerman.id.au>
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
To: Dan Williams <dan.j.williams@intel.com>, Oliver O'Halloran <oohall@gmail.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:
> On Tue, Oct 9, 2018 at 11:21 PM Oliver O'Halloran <oohall@gmail.com> wrote:
>>
>> Adds a driver that implements support for enabling and accessing PAPR
>> SCM regions. Unfortunately due to how the PAPR interface works we can't
>> use the existing of_pmem driver (yet) because:
>>
...
>> +
>> +static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
>> +{
>> +       struct device *dev = &p->pdev->dev;
>> +       struct nd_mapping_desc mapping;
>> +       struct nd_region_desc ndr_desc;
>> +       unsigned long dimm_flags;
>> +
>> +       p->bus_desc.ndctl = papr_scm_ndctl;
>> +       p->bus_desc.module = THIS_MODULE;
>> +       p->bus_desc.of_node = p->pdev->dev.of_node;
>> +       p->bus_desc.attr_groups = bus_attr_groups;
>> +       p->bus_desc.provider_name = kstrdup(p->pdev->name, GFP_KERNEL);
>> +
>> +       if (!p->bus_desc.provider_name)
>> +               return -ENOMEM;
>> +
>> +       p->bus = nvdimm_bus_register(NULL, &p->bus_desc);
>> +       if (!p->bus) {
>> +               dev_err(dev, "Error creating nvdimm bus %pOF\n", p->dn);
>> +               return -ENXIO;
>> +       }
>> +
>> +       dimm_flags = 0;
>> +       set_bit(NDD_ALIASING, &dimm_flags);
>> +
>> +       p->nvdimm = nvdimm_create(p->bus, p, papr_scm_dimm_groups,
>> +                               dimm_flags, PAPR_SCM_DIMM_CMD_MASK, 0, NULL);
>
> Looks good, although I'm just about to push out commits that change
> this function signature to take a 'security_ops' pointer. If you need
> a stable branch to base this on, let me know.
...
>
> Other than that looks ok to me:
>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
>
> ...just the matter of what to do about function signature change.

Yeah that's a bit of a bother.

The ideal for me would be that you put the commit that changes the
signature by itself in a branch based on 4.19-rc3 (or earlier), and then
we could both just merge that.

But not sure if that will work with whatever else you're trying to sync
up with.

cheers
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
