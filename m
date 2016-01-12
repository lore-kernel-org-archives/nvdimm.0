Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 11 Jan 2016 18:32:59 -0700
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v5 0/6] nvdimm: Add an IOCTL pass thru for DSM calls
Message-ID: <20160112013259.GC79247@tevye.fc.hp.com>
Reply-To: Jerry.Hoemann@hpe.com
References: <cover.1452121277.git.jerry.hoemann@hpe.com>
 <CAPcyv4h_Oc3VVwtjp=+onSVq-Kuidd1r+9fbR-uo+DF_=e+jhg@mail.gmail.com>
 <CAPcyv4h+R4Aa7Zu3qWfmWwk6SWt22wuOowJvtpFhVUCdamTWDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h+R4Aa7Zu3qWfmWwk6SWt22wuOowJvtpFhVUCdamTWDA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, jmoyer <jmoyer@redhat.com>, Dmitry Krivenok <krivenok.dmitry@gmail.com>, Linda Knippers <linda.knippers@hpe.com>, Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jan 10, 2016 at 04:03:18PM -0800, Dan Williams wrote:
> On Wed, Jan 6, 2016 at 3:58 PM, Dan Williams <dan.j.williams@intel.com>wrote:
> > On Wed, Jan 6, 2016 at 3:03 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> [..]
> >> Jerry Hoemann (6):
> >>   ACPI / util: Fix acpi_evaluate_dsm() argument type
> >>   nvdimm: Clean-up access mode check.
> >>   nvdimm: Add wrapper for IOCTL pass thru
> >>   nvdimm: Fix security issue with DSM IOCTL.
> >>   nvdimm: Increase max envelope size for IOCTL
> >>   nvdimm: Add IOCTL pass thru functions
> >
> > These look good to me.
> >
> > I'll tag "nvdimm: Fix security issue with DSM IOCTL." for -stable.
> >
> > Thanks Jerry!
> 
> I went to go write a test / support in ndctl for these and noticed a
> few things I want to address before merging.
> 
> 1/ Advertise 'call_dsm' as a supported command alongside the others.


  In sysfs?  okay that makes sense.


> 
> 2/ Disallow potentially invalid calls to reach firmware.  At a minimum
> the kernel needs to know the uuid in advance for any dsm it wants to
> send.  I.e. check the 'dsm_fun_idx' against the dsm_mask.  This is
> also important for making sure the kernel can manage exclusive access
> to the configuration data area if present
> (ND_CMD_{GET|SET}_CONFIG_DATA).

  Technically, the kernel doesn't need to know the uuid in advance
  as that is part of the bundle passed into the passthru.

  Are you concerned about firmware mis-behaving when presented
  with a (UUID, Function_Index) that is not supported?
  (and really we should add Revision ID to that tuple.)

  In a prior version of the patch not sent upstream, I did "discover" the
  uuid and set up the dsm_mask.  However, this created a need to modify
  kernel each time uuid changes.  Also, i don't think this is necessary
  as FW should be gracefully validating its input arguments.  By
  not setting up/using dsm_mask in pass thru case, this can be tested.

  I don't understand the exclusive access concern w/ config data.
  Could you please elaborate?


> 
> 3/ This is minor, but it follows from 1/ that there may be some nvdimm
> bus implementations that do not implement 'call_dsm' support.
> 'nfit_test' is currently one of those buses and we need to check for
> that explicitly in nd_ioctl.
> 
> I have some patches in progress to address these.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
