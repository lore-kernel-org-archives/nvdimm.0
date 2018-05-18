Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F17420969666
 for <linux-nvdimm@lists.01.org>; Fri, 18 May 2018 08:23:07 -0700 (PDT)
Date: Fri, 18 May 2018 09:23:06 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [qemu PATCH v2 3/4] nvdimm, acpi: support NFIT platform
 capabilities
Message-ID: <20180518152306.GA3413@linux.intel.com>
References: <20180517050024.20101-1-ross.zwisler@linux.intel.com>
 <20180517050024.20101-4-ross.zwisler@linux.intel.com>
 <AT5PR8401MB11697DD6A19AA3F499ACDDBAAB910@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AT5PR8401MB11697DD6A19AA3F499ACDDBAAB910@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S . Tsirkin" <mst@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 17, 2018 at 10:06:37PM +0000, Elliott, Robert (Persistent Memory) wrote:
> 
> 
> > -----Original Message-----
> > From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> > Ross Zwisler
> > Sent: Thursday, May 17, 2018 12:00 AM
> > Subject: [qemu PATCH v2 3/4] nvdimm, acpi: support NFIT platform
> > capabilities
> > 
> > Add a machine command line option to allow the user to control the
> > Platform
> > Capabilities Structure in the virtualized NFIT.  This Platform
> > Capabilities
> > Structure was added in ACPI 6.2 Errata A.
> > 
> ...
> > +Platform Capabilities
> > +---------------------
> > +
> > +ACPI 6.2 Errata A added support for a new Platform Capabilities Structure
> > +which allows the platform to communicate what features it supports
> > related to
> > +NVDIMM data durability.  Users can provide a capabilities value to a
> > guest via
> > +the optional "nvdimm-cap" machine command line option:
> > +
> > +    -machine pc,accel=kvm,nvdimm,nvdimm-cap=2
> > +
> > +As of ACPI 6.2 Errata A, the following values are valid for the bottom
> > two
> > +bits:
> > +
> > +2 - Memory Controller Flush to NVDIMM Durability on Power Loss Capable.
> > +3 - CPU Cache Flush to NVDIMM Durability on Power Loss Capable.
> 
> It's a bit unclear that those are decimal values for the field, not 
> bit numbers.

Hmm..I was trying to be clear by saying "the following values are valid for
the bottom two bits", and having 2 and 3 as the possible values.

Would it help to show them in hex?

  As of ACPI 6.2 Errata A, the following values are valid for the bottom two
  bits:
  
  0x2 - Memory Controller Flush to NVDIMM Durability on Power Loss Capable.
  0x3 - CPU Cache Flush to NVDIMM Durability on Power Loss Capable.

More clearly showing that they are values created by combining bitfields?

> > -static GArray *nvdimm_build_device_structure(void)
> > +/*
> > + * ACPI 6.2 Errata A: 5.2.25.9 NVDIMM Platform Capabilities Structure
> > + */
> > +static void
> > +nvdimm_build_structure_caps(GArray *structures, uint32_t capabilities)
> > +{
> > +    NvdimmNfitPlatformCaps *nfit_caps;
> > +
> > +    nfit_caps = acpi_data_push(structures, sizeof(*nfit_caps));
> > +
> > +    nfit_caps->type = cpu_to_le16(7 /* NVDIMM Platform Capabilities */);
> > +    nfit_caps->length = cpu_to_le16(sizeof(*nfit_caps));
> > +    nfit_caps->highest_cap = 2;
> > +    nfit_caps->capabilities = cpu_to_le32(capabilities);
> 
> highest_cap needs to be set to a value that at least covers the highest 
> bit set to 1 used in capabilities.
> 
> As capabilities bits are added, there are three different meanings:
> * 1: bit within highest_cap range, platform is claiming the 1 meaning
> * 0: bit within highest_cap range, platform is claiming the 0 meaning
> * not reported: bit not within highest_cap range, so the platform's
>   implementation of this feature is unknown. Not necessarily the same 
>   as the 0 meaning.
> 
> So, there should be a way to specify a highest_cap value to convey that
> some of the upper capabilities bits are valid and contain 0.

Right, I'll make this dynamic based on the capabilities value passed in by the
user.  That's a much better solution, thanks.  This should cover all the same
cases as you have outlined above, without burdening the user with yet another
input value.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
