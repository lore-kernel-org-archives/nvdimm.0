Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com
 [IPv6:2a00:1450:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C9E43211EC667
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 13:43:47 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d46so17172509eda.7
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 13:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190417150331.90219ca42a1c0db8632d0fd5@linux-foundation.org>
 <CAPcyv4hB47NJrVi1sm+7msL+6dJNhBD10BJbtLPZRcK2JK6+pg@mail.gmail.com>
 <1556025416.2956.0.camel@suse.de>
In-Reply-To: <1556025416.2956.0.camel@suse.de>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 24 Apr 2019 16:43:35 -0400
Message-ID: <CA+CK2bBS_cWJCWDCQAXKU6t=r=nAC908jz8uQ90DjKT5XcuNtw@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] mm: Sub-section memory hotplug support
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
To: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, stable <stable@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

I am also taking a look at this work now. I will review and test it in
the next couple of days.

Pasha

On Tue, Apr 23, 2019 at 9:17 AM Oscar Salvador <osalvador@suse.de> wrote:
>
> On Wed, 2019-04-17 at 15:59 -0700, Dan Williams wrote:
> > On Wed, Apr 17, 2019 at 3:04 PM Andrew Morton <akpm@linux-foundation.
> > org> wrote:
> > >
> > > On Wed, 17 Apr 2019 11:38:55 -0700 Dan Williams <dan.j.williams@int
> > > el.com> wrote:
> > >
> > > > The memory hotplug section is an arbitrary / convenient unit for
> > > > memory
> > > > hotplug. 'Section-size' units have bled into the user interface
> > > > ('memblock' sysfs) and can not be changed without breaking
> > > > existing
> > > > userspace. The section-size constraint, while mostly benign for
> > > > typical
> > > > memory hotplug, has and continues to wreak havoc with 'device-
> > > > memory'
> > > > use cases, persistent memory (pmem) in particular. Recall that
> > > > pmem uses
> > > > devm_memremap_pages(), and subsequently arch_add_memory(), to
> > > > allocate a
> > > > 'struct page' memmap for pmem. However, it does not use the
> > > > 'bottom
> > > > half' of memory hotplug, i.e. never marks pmem pages online and
> > > > never
> > > > exposes the userspace memblock interface for pmem. This leaves an
> > > > opening to redress the section-size constraint.
> > >
> > > v6 and we're not showing any review activity.  Who would be
> > > suitable
> > > people to help out here?
> >
> > There was quite a bit of review of the cover letter from Michal and
> > David, but you're right the details not so much as of yet. I'd like
> > to
> > call out other people where I can reciprocate with some review of my
> > own. Oscar's altmap work looks like a good candidate for that.
>
> Thanks Dan for ccing me.
> I will take a look at the patches soon.
>
> --
> Oscar Salvador
> SUSE L3
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
