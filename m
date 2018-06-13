Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 655122117513A
 for <linux-nvdimm@lists.01.org>; Wed, 13 Jun 2018 09:30:46 -0700 (PDT)
Date: Wed, 13 Jun 2018 18:30:42 +0200
From: Igor Mammedov <imammedo@redhat.com>
Subject: Re: [Qemu-devel] [RFC PATCH 1/1] nvdimm: let qemu requiring section
 alignment of pmem resource.
Message-ID: <20180613183042.2ce134a6@redhat.com>
In-Reply-To: <20180612150425.hjydg5cbtlllzh67@HZ>
References: <e74aee54657de6f8d643a92ba21f467db149c2c8.1528714312.git.yi.z.zhang@linux.intel.com>
 <20180611162630.GH17756@stefanha-x1.localdomain>
 <CAPcyv4jJSYiCu_qNWgU8KR3sFQE032Uu6LCQq-CTxF0jpkooiA@mail.gmail.com>
 <20180612150425.hjydg5cbtlllzh67@HZ>
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
To: Haozhong Zhang <hzzhan9@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Zhang Yi <yi.z.zhang@linux.intel.com>, Stefan Hajnoczi <stefanha@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 12 Jun 2018 23:04:25 +0800
Haozhong Zhang <hzzhan9@gmail.com> wrote:

> On 06/11/18 19:55, Dan Williams wrote:
> > On Mon, Jun 11, 2018 at 9:26 AM, Stefan Hajnoczi <stefanha@redhat.com> wrote:  
> > > On Mon, Jun 11, 2018 at 06:54:25PM +0800, Zhang Yi wrote:  
> > >> Nvdimm driver use Memory hot-plug APIs to map it's pmem resource,
> > >> which at a section granularity.
> > >>
> > >> When QEMU emulated the vNVDIMM device, decrease the label-storage,
> > >> QEMU will put the vNVDIMMs directly next to one another in physical
> > >> address space, which means that the boundary between them won't
> > >> align to the 128 MB memory section size.  
> > >
> > > I'm having a hard time parsing this.
> > >
> > > Where does the "128 MB memory section size" come from?  ACPI?
> > > A chipset-specific value?
> > >  
> > 
> > The devm_memremap_pages() implementation use the memory hotplug core
> > to allocate the 'struct page' array/map for persistent memory. Memory
> > hotplug can only be performed in terms of sections, 128MB on x86_64.  
> 
> IIUC, it also affects the normal RAM hotplug to a Linux VM on QEMU. If
> that is the case, it will be helpful to lift this option to pc-dimm.

Default alignment on page size boundary is implemented for the reason
that QEMU has no idea about guest os alignments req. and these requirements
might vary greatly depending on guest os running.
With some guests it works just fine even with 2M alignments/dimm sizes.

So it's up to upper layers which know what guest os is running to pick
plugged dimm sizes. So if a particular linux version minimum block size
is 128, then mgmt needs to plug dimm with size which is multiple of that.
That should satisfy whatever alignment req guest os has.

In case of nvdimm we need to fix address allocation in QEMU to account
for label size which broke above rule leading to "overlap" over label
area of nvdimm which isn't mapped into guest address space, but that's
probably it.

PS:
not related to patch question.
Intel guys contributed most of the code to nvdimm and continue actively
to develop it. Can we have a designated maintainer for nvdimm part from
Intel in addition to authors who just code/merge feature and disappear
(not reachable) shortly after that?


> Thanks,
> Haozhong
> 
> > There is some limited support for allowing devm_memremap_pages() to
> > overlap 'System RAM' within a given section, but it does not currently
> > support multiple devm_memremap_pages() calls overlapping within the
> > same section. There is currently a kernel bug where we do not handle
> > this unsupported configuration gracefully. The fix will cause
> > configurations configurations that try to overlap 2 persistent memory
> > ranges in the same section to fail.
> > 
> > The proposed fix is trying to make sure that QEMU does not run afoul
> > of this constraint.
> > 
> > There is currently no line of sight to reduce the minimum memory
> > hotplug alignment size to less than 128M. Also, as other architectures
> > outside of x86_64 add devm_memremap_pages() support, the minimum
> > section alignment constraint might change and is a property of a guest
> > OS. My understanding is that some guest OSes might expect an even
> > larger persistent memory minimum alignment.
> >   

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
