Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E263220C1C47
 for <linux-nvdimm@lists.01.org>; Thu, 23 Nov 2017 09:19:05 -0800 (PST)
From: "Czurylo, Krzysztof" <krzysztof.czurylo@intel.com>
Subject: RE: [PATCH] daxctl: remove libpmem dependency
Date: Thu, 23 Nov 2017 17:23:20 +0000
Message-ID: <91626014A8500F418F35F9EB590D2531AA96A9A8@IRSMSX106.ger.corp.intel.com>
References: <1510238453-7713-1-git-send-email-lukasz.plewa@intel.com>
 <CAOSf1CFMsPwFcO6Mp4fV+faEBdG5wwi3d1nGK+n-MDGF4v0oLw@mail.gmail.com>
 <x498tfe8820.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jJ0J4EkD95OXRWOogyV0tbY_WaO9WyQULL3bs+rShQBA@mail.gmail.com>
 <x49375m5blz.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4ieVYyrLgL4khMkqW-Rf36Ptzmnj0nAvoog0+zd_G3shg@mail.gmail.com>
In-Reply-To: <CAPcyv4ieVYyrLgL4khMkqW-Rf36Ptzmnj0nAvoog0+zd_G3shg@mail.gmail.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Fri, Nov 10, 2017 at 8:42 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> > Dan Williams <dan.j.williams@intel.com> writes:
> >
> >>> I don't know, is it impossible to make this work w/o yanking out -
> lpmem?
> >>
> >> My preference would be that allthe  pmem_memcpy* routines move to
> >> libndctl since it is the lower level library. Arrange for nvml to
> >> depend on libdnctl for this in addition to the other libndctl
> >> dependencies that seem to be in the works.
> >
> > That's fine by me.  Can you convince the nvml developers to do that?
> >
> 
> The other concern is that libpmem supports other OSes, but libndctl is
> just Linux. That seems to suggest we need the memcpy routines to be
> their own standalone library that both ndctl and libpmem can import.

Folks,

I understand your concerns, but to be honest, I don't like the idea of
moving pmem_memcpy* routines to libndctl or yet another library.
The libpmem *is* the library.
In practice, if we move pmem_memcpy*/pmem_memset* to ndctl, it means
that almost the _entire_ libpmem code would need to be moved to ndctl
(maybe without the APIs like pmem_map_file/pmem_unmap). So, looks like
it's all about moving libpmem from nvml repo to ndctl repo, isn't it?
It leads us to another question - perhaps we should simply merge those
two projects into one? It would solve all the problems with
cross-dependencies between ndctl and nvml, once and for all.
However, besides some technical issues, one of the problems is
the license - GPL vs. BSD - and I'm not sure how to deal with it.

For me, there are a few options:
1) Integrate the patch proposed by Lukasz (maybe slightly modified).
This looks like the easiest and simplest, thus preferred solution.
Of course, we can detect the cache line size and the availability
of CLFLUSHOPT/CLWB, if necessary.
Correct me if I'm wrong, but I don't expect "daxctl io" to be used
frequently, so even if it's not optimal (does not use MOVNT) and we
need to flush the cache, the performance shouldn't be a big issue.
BTW, this code is only compiled for x86, so maybe we don't even need
to care about other architectures?

2) Clone the pmem_memcpy/pmem_memset/pmem_persist routines into ndctl
(for internal use only). The libpmem would still provide those
interfaces.
It duplicates the code (is it a big deal?), but eliminates dependency
on libpmem.

3) Remove "daxctl io" command from ndctl and integrate it with
NVML's "pmempool" utility (or a dedicated tool/subpkg).
There's not much we need to do, as in practice we already have a similar
tool in the nvml repo (src/test/tools/ddmap). So far, it's only used
for testing, but could become a standalone "ddmap" or "daxio" utility.


Keep in mind that most of the problems with library dependencies are
because of Device DAX support. Device DAX was intended to be a temporary
workaround until the Linux kernel/filesystems provide full support for
PM programming model, but in practice it cluttered NVML with
DevDAX-specific code, triggered some deep modifications of NVML internals,
and now you're proposing yet another significant change.
Once the MAP_SYNC flag is available, Device DAX becomes less important,
I believe, and might get eliminated eventually. Shall we change the
architecture of NVML or how the code is organized just because of it?

I opt for the simplest solution, as proposed by Lukasz.

Regards,
Krzysztof

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
