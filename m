Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A94F2129EB8F
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 09:30:22 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id i8so3306021oth.10
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 09:30:22 -0700 (PDT)
MIME-Version: 1.0
References: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
 <874l4kjv6o.fsf@linux.ibm.com>
In-Reply-To: <874l4kjv6o.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Jun 2019 09:30:10 -0700
Message-ID: <CAPcyv4ioWRhU9AbyTHhf9PavL0GSs=6h3dGyaQPb7vLJ2+z23g@mail.gmail.com>
Subject: Re: [PATCH v10 00/13] mm: Sub-section memory hotplug support
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, David Hildenbrand <david@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, stable <stable@vger.kernel.org>, Mike Rapoport <rppt@linux.ibm.com>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Qian Cai <cai@lca.pw>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Vlastimil Babka <vbabka@suse.cz>, Oscar Salvador <osalvador@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 20, 2019 at 5:31 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > Changes since v9 [1]:
> > - Fix multiple issues related to the fact that pfn_valid() has
> >   traditionally returned true for any pfn in an 'early' (onlined at
> >   boot) section regardless of whether that pfn represented 'System RAM'.
> >   Teach pfn_valid() to maintain its traditional behavior in the presence
> >   of subsections. Specifically, subsection precision for pfn_valid() is
> >   only considered for non-early / hot-plugged sections. (Qian)
> >
> > - Related to the first item introduce a SECTION_IS_EARLY
> >   (->section_mem_map flag) to remove the existing hacks for determining
> >   an early section by looking at whether the usemap was allocated from the
> >   slab.
> >
> > - Kill off the EEXIST hackery in __add_pages(). It breaks
> >   (arch_add_memory() false-positive) the detection of subsection
> >   collisions reported by section_activate(). It is also obviated by
> >   David's recent reworks to move the 'System RAM' request_region() earlier
> >   in the add_memory() sequence().
> >
> > - Switch to an arch-independent / static subsection-size of 2MB.
> >   Otherwise, a per-arch subsection-size is a roadblock on the path to
> >   persistent memory namespace compatibility across archs. (Jeff)
> >
> > - Update the changelog for "libnvdimm/pfn: Fix fsdax-mode namespace
> >   info-block zero-fields" to clarify that the "Cc: stable" is only there
> >   as safety measure for a distro that decides to backport "libnvdimm/pfn:
> >   Stop padding pmem namespaces to section alignment", otherwise there is
> >   no known bug exposure in older kernels. (Andrew)
> >
> > - Drop some redundant subsection checks (Oscar)
> >
> > - Collect some reviewed-bys
> >
> > [1]: https://lore.kernel.org/lkml/155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com/
>
>
> You can add Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> for ppc64.

Thank you!

> BTW even after this series we have the kernel crash mentioned in the
> below email on reconfigure.
>
> https://lore.kernel.org/linux-mm/20190514025354.9108-1-aneesh.kumar@linux.ibm.com
>
> I guess we need to conclude how the reserve space struct page should be
> initialized ?

Yes, that issue is independent of the subsection changes. I'll take a
closer look.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
