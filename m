Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0871210D43AB
 for <linux-nvdimm@lists.01.org>; Wed,  1 Aug 2018 14:24:24 -0700 (PDT)
From: "Moore, Robert" <robert.moore@intel.com>
Subject: RE: [PATCH 1/1] x86, pmem, acpi: Remove excessive ACPI Large
 Reference Count warnings
Date: Wed, 1 Aug 2018 21:24:19 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E3B94DEDFF@ORSMSX108.amr.corp.intel.com>
References: <20180730195545.795802877@stormcage.americas.sgi.com>
 <20180730195548.580717146@stormcage.americas.sgi.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E3B94DED8F@ORSMSX108.amr.corp.intel.com>
 <20180801203827.ozkvldizkpsatmg5@hpe.com>
In-Reply-To: <20180801203827.ozkvldizkpsatmg5@hpe.com>
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
To: Russ Anderson <rja@hpe.com>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>, Russ Anderson <russ.anderson@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mike Travis <mike.travis@hpe.com>, "Wysocki, Rafael J  <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "devel@acpica.org" <devel@acpica.org>, Schmauss,
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Russ Anderson [mailto:rja@hpe.com]
> Sent: Wednesday, August 1, 2018 1:38 PM
> To: Moore, Robert <robert.moore@intel.com>
> Cc: Mike Travis <mike.travis@hpe.com>; Schmauss, Erik
> <erik.schmauss@intel.com>; Wysocki, Rafael J
> <rafael.j.wysocki@intel.com>; Len Brown <lenb@kernel.org>; Russ Anderson
> <russ.anderson@hpe.com>; Dimitri Sivanich <dimitri.sivanich@hpe.com>;
> Ross Zwisler <ross.zwisler@linux.intel.com>; Williams, Dan J
> <dan.j.williams@intel.com>; Verma, Vishal L <vishal.l.verma@intel.com>;
> Jiang, Dave <dave.jiang@intel.com>; linux-acpi@vger.kernel.org;
> devel@acpica.org; linux-nvdimm@lists.01.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] x86, pmem, acpi: Remove excessive ACPI Large
> Reference Count warnings
> 
> On Wed, Aug 01, 2018 at 07:49:14PM +0000, Moore, Robert wrote:
> > Are there any actual memory leaks, or this a consequence of the number
> of sockets?
> 
> It is a consequence of the number of sockets.
> It is not an actual memory leak.
> 
> Thanks.
> 
[Moore, Robert] 

It does bother me a bit that there are over 4096 references to a single object, however. Could you send us the ACPI dump for the machine?

This issue sounds vaguely familiar though. Perhaps Dan remembers, it was something about large reference counts and the NFIT/NVDIMM stuff. If so, this has been fixed for some time now.

Bob


> > > -----Original Message-----
> > > From: Mike Travis [mailto:mike.travis@hpe.com]
> > > Sent: Monday, July 30, 2018 12:56 PM
> > > To: Moore, Robert <robert.moore@intel.com>; Schmauss, Erik
> > > <erik.schmauss@intel.com>; Wysocki, Rafael J
> > > <rafael.j.wysocki@intel.com>; Len Brown <lenb@kernel.org>
> > > Cc: Russ Anderson <russ.anderson@hpe.com>; Dimitri Sivanich
> > > <dimitri.sivanich@hpe.com>; Ross Zwisler
> > > <ross.zwisler@linux.intel.com>; Williams, Dan J
> > > <dan.j.williams@intel.com>; Verma, Vishal L
> > > <vishal.l.verma@intel.com>; Jiang, Dave <dave.jiang@intel.com>;
> > > linux- acpi@vger.kernel.org; devel@acpica.org;
> > > linux-nvdimm@lists.01.org; linux-kernel@vger.kernel.org
> > > Subject: [PATCH 1/1] x86, pmem, acpi: Remove excessive ACPI Large
> > > Reference Count warnings
> > >
> > > With the Intel BIOS support for 8 processor sockets with a full
> > > complement of NVDIMMS potentially installable, and there are empty
> > > sockets without NVDIMMS, there is an extremely large amount of the
> > > following warnings:
> > >
> > > ACPI Warning: Large Reference Count (0x1001) in object
> ffff99453fc71750,
> > > 	Type=0x0A
> > >
> > > On a 4 socket system with 4 NVDIMMs there were over 6000 of these
> > > warning messages and it has been seem on systems from 4 to 32
> sockets.
> > >
> > > Through some guidance from the BIOS developers and testing, it
> > > appears that simply bumping up the threshold for warnings from
> > > 0x1000 to 0x2000 eliminates these messages.  Changing them to be
> > > ACPI DEBUG messages, or even removing them are other options, but it
> > > would then defeat the purpose of the warnings as the problem would
> effectively be hidden.
> > >
> > > Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
> > > Tested-by: Russ Anderson <russ.anderson@hpe.com>
> > > Signed-off-by: Mike Travis <mike.travis@hpe.com>
> > > ---
> > >  include/acpi/acconfig.h |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > --- linux-4.12.orig/include/acpi/acconfig.h
> > > +++ linux-4.12/include/acpi/acconfig.h
> > > @@ -123,7 +123,7 @@
> > >
> > >  /* Maximum object reference count (detects object deletion issues)
> > > */
> > >
> > > -#define ACPI_MAX_REFERENCE_COUNT        0x1000
> > > +#define ACPI_MAX_REFERENCE_COUNT        0x2000
> > >
> > >  /* Default page size for use in mapping memory for operation
> > > regions */
> > >
> > >
> > > --
> >
> 
> --
> Russ Anderson,  SuperDome Flex Linux Kernel Group Manager HPE - Hewlett
> Packard Enterprise (formerly SGI)  rja@hpe.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
