Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 9 Nov 2015 14:59:04 -0700
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH 3/4] nvdimm: Add IOCTL pass thru
Message-ID: <20151109215904.GB33245@tevye.fc.hp.com>
Reply-To: Jerry.Hoemann@hpe.com
References: <CAJN_NGaPbziX=OcyYpcn5TP76HwGQSTsUz-yOVGB2Sh8VxDQjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJN_NGaPbziX=OcyYpcn5TP76HwGQSTsUz-yOVGB2Sh8VxDQjA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Krivenok <krivenok.dmitry@gmail.com>
Cc: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


Dmitry,

thanks for you review.  Questions in-line.


On Sat, Nov 07, 2015 at 05:02:36PM +0300, Dmitry Krivenok wrote:
> > +       if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
> > +               dev_dbg(dev, "%s:%s cmd: %d input length: %d\n", __func__,
> > +                               dimm_name, cmd, in_buf.buffer.length);
> > +               print_hex_dump_debug("cmd: ", DUMP_PREFIX_OFFSET, 4,
> > +                               4, in_buf.buffer.pointer, min_t(u32, 128,
> > +                                       in_buf.buffer.length), true);
> > +       }
> 
> Maybe move this code to a helper function? There are 4 almost
> identical blocks now in acpi_nfit_ctl_passthru and
> acpi_nfit_ctl_intel.


Is your concern readibility or size of generated code (or both?)

I'll look to consolidating the debug printing in next version as additional patch.

> 
> > +       for (i = 0; i < ARRAY_SIZE(pkg.h.res); i++)
> > +               if (pkg.h.res[i])
> > +                       return -EINVAL;
> 
> I'd rename "res" to "reserved" for clarity.


Will do.



> 
> > +       /* This may be bigger that the fixed portion of the pakcage */
> 
> s/that/than/
> s/pakcage/package/


Will do.


> 
> > +               switch (type) {
> > +               case NVDIMM_TYPE_INTEL:
> > +                       rc = __nd_ioctl(nvdimm_bus, nvdimm, ro, cmd, arg);
> > +                       break;
> > +               case NVDIMM_TYPE_PASSTHRU:
> > +                       rc = __nd_ioctl_passthru(nvdimm_bus, nvdimm, ro, cmd, arg);
> > +                       break;
> > +               default:
> > +                       rc = -ENOTTY;
> > +               }
> 
> The same comment. Identical code in nd_ioctl and nvdimm_ioctl.
> Perhaps move to a helper function?


If we had a longer list, I would definitely say yes.  Not so sure with
just two types.  I'll take a look for the next version.


-- 

-----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer      Hewlett-Packard Enterprise

3404 E Harmony Rd. MS 36                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-0707
                                                email:  jerry.hoemann@hpe.com
-----------------------------------------------------------------------------
