Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F00E21CF25AD
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jul 2017 09:30:33 -0700 (PDT)
Date: Fri, 7 Jul 2017 10:32:13 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFC v2 3/5] hmem: add heterogeneous memory sysfs support
Message-ID: <20170707163213.GC22856@linux.intel.com>
References: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
 <20170706215233.11329-4-ross.zwisler@linux.intel.com>
 <9ea40a37-3549-2294-8605-036b37aec023@nvidia.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9ea40a37-3549-2294-8605-036b37aec023@nvidia.com>
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
To: John Hubbard <jhubbard@nvidia.com>
Cc: "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, Robert, Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, "Lahtinen, Joonas" <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 06, 2017 at 10:53:39PM -0700, John Hubbard wrote:
> On 07/06/2017 02:52 PM, Ross Zwisler wrote:
> [...]
> > diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> > index b1aacfc..31e3f20 100644
> > --- a/drivers/acpi/Makefile
> > +++ b/drivers/acpi/Makefile
> > @@ -72,6 +72,7 @@ obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
> >  obj-$(CONFIG_ACPI)		+= container.o
> >  obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
> >  obj-$(CONFIG_ACPI_NFIT)		+= nfit/
> > +obj-$(CONFIG_ACPI_HMEM)		+= hmem/
> >  obj-$(CONFIG_ACPI)		+= acpi_memhotplug.o
> >  obj-$(CONFIG_ACPI_HOTPLUG_IOAPIC) += ioapic.o
> >  obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
> 
> Hi Ross,
> 
> Following are a series of suggestions, intended to clarify naming just
> enough so that, when Jerome's HMM patchset lands, we'll be able to
> tell the difference between the two types of Heterogeneous Memory.

Sure, these all seem sane to me, thanks.  I'll fix this up in v3.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
