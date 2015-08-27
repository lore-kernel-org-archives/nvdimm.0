Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1440702140.14237.92.camel@hp.com>
Subject: Re: [PATCH 1/2]: nfit: Clarify memory device state flags strings
From: Toshi Kani <toshi.kani@hp.com>
Date: Thu, 27 Aug 2015 13:02:20 -0600
In-Reply-To: <CAPcyv4hNdyDSirnbxw9uMWZXPVhzGSznEDT0GEMD8do2go6i7Q@mail.gmail.com>
References: <1440606024-29873-1-git-send-email-toshi.kani@hp.com>
	 <1440606024-29873-2-git-send-email-toshi.kani@hp.com>
	 <CAPcyv4hNdyDSirnbxw9uMWZXPVhzGSznEDT0GEMD8do2go6i7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Rafael J Wysocki <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Elliott, Robert (Server Storage)" <elliott@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-08-27 at 11:57 -0700, Dan Williams wrote:
> On Wed, Aug 26, 2015 at 9:20 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > ACPI 6.0 NFIT Memory Device State Flags in Table 5-129 defines
> > NVDIMM status as follows.  These bits indicate multiple info,
> > such as failures, pending event, and capability.
> > 
> >   Bit [0] set to 1 to indicate that the previous SAVE to the
> >   Memory Device failed.
> >   Bit [1] set to 1 to indicate that the last RESTORE from the
> >   Memory Device failed.
> >   Bit [2] set to 1 to indicate that platform flush of data to
> >   Memory Device failed. As a result, the restored data content
> >   may be inconsistent even if SAVE and RESTORE do not indicate
> >   failure.
> >   Bit [3] set to 1 to indicate that the Memory Device is observed
> >   to be not armed prior to OSPM hand off. A Memory Device is
> >   considered armed if it is able to accept persistent writes.
> >   Bit [4] set to 1 to indicate that the Memory Device observed
> >   SMART and health events prior to OSPM handoff.
> >   Bit [5] is set to 1 to indicate that platform firmware is
> >   enabled to notify OSPM on SMART and health events related to
> >   the memory device using Notify codes as specified in Section
> >   5.6.6.
> > 
> > /sys/bus/nd/devices/nmemX/nfit/flags shows this flags info.
> > The output strings associated with the bits are "save", "restore",
> > "smart", etc., which can be confusing as they may be interpreted
> > as positive status, i.e. save succeeded.
> > 
> > Change the strings to be more descriptive per the ACPI spec.
> > Also add a string to bit 5 for completeness.
> 
> Ok I'm going to push this upstream for 4.2 with the "not_armed" fixup
> that Ross suggested, but I'll defer adding bit5 since that is separate
> from the urgent fix to get the polarities properly reflected and we
> can add support for it later.

Great!!  Thanks Dan! (and sorry for making more work to you...)
-Toshi
