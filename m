Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2598F209603C7
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 16:03:54 -0700 (PDT)
Date: Tue, 15 May 2018 17:03:51 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [Qemu-devel] [PATCH 3/3] nvdimm: platform capabilities command
 line option
Message-ID: <20180515230351.GA741@linux.intel.com>
References: <20180427215314.23168-1-ross.zwisler@linux.intel.com>
 <20180427215314.23168-3-ross.zwisler@linux.intel.com>
 <20180510152848.0f99ea07@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180510152848.0f99ea07@redhat.com>
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
To: Igor Mammedov <imammedo@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 10, 2018 at 03:28:48PM +0200, Igor Mammedov wrote:
> On Fri, 27 Apr 2018 15:53:14 -0600
> Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> 
> > Add a device command line option to allow the user to control the Platform
> > Capabilities Structure in the virtualized NFIT.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > ---
> >  docs/nvdimm.txt         | 22 ++++++++++++++++++++++
> >  hw/acpi/nvdimm.c        | 29 +++++++++++++++++++++++++----
> >  hw/mem/nvdimm.c         | 28 ++++++++++++++++++++++++++++
> >  include/hw/mem/nvdimm.h |  6 ++++++
> >  4 files changed, 81 insertions(+), 4 deletions(-)
> > 
> > diff --git a/docs/nvdimm.txt b/docs/nvdimm.txt
> > index e903d8bb09..13a2c15b70 100644
> > --- a/docs/nvdimm.txt
> > +++ b/docs/nvdimm.txt
> > @@ -153,3 +153,25 @@ guest NVDIMM region mapping structure.  This unarmed flag indicates
> >  guest software that this vNVDIMM device contains a region that cannot
> >  accept persistent writes. In result, for example, the guest Linux
> >  NVDIMM driver, marks such vNVDIMM device as read-only.
> > +
> > +Platform Capabilities
> > +---------------------
> > +
> > +ACPI 6.2 Errata A added support for a new Platform Capabilities Structure
> > +which allows the platform to communicate what features it supports related to
> > +NVDIMM data durability.  Users can provide a capabilities value to a guest via
> > +the optional "cap" device command line option:
> > +
> > + -device nvdimm,id=nvdimm1,memdev=mem1,cap=3
> > +
> > +As of ACPI 6.2 Errata A, the following values are valid for the bottom two
> > +bits:
> > +
> > +2 - Memory Controller Flush to NVDIMM Durability on Power Loss Capable.
> > +3 - CPU Cache Flush to NVDIMM Durability on Power Loss Capable.
> > +
> > +For a complete list of the flags available please consult the ACPI spec.
> > +
> > +These platform capabilities apply to the entire virtual platform, so it is
> > +recommended that only one "cap" device command option be given per virtual
> > +machine.  This value will apply to all NVDIMMs in the virtual platform.
> This looks like it should be machine property instead of per device one,
> you can get rid of static variable and mismatch check and a weird nvdimm CLI
> option that implies that the option is per device.

Yep, that's much better.  I have this implemented and ready to go.

> Also an extra patch to for make check that will test setting 'cap'
> would be nice (an extra testcase in tests/bios-tables-test.c)

Hmm...I've been looking at this, and it doesn't look like there is any
verification around a lot of the ACPI tables (NFIT, SRAT, etc).

I've verified my patch by interacting with a guest with various settings - is
this good enough, or do you really want me to test the value (which I think
would just be "do I get out what I put in at the command line") via the unit
test infrastructure?

Thank you for the review.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
