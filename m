Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAAEB220C1C44
 for <linux-nvdimm@lists.01.org>; Thu, 23 Nov 2017 10:04:46 -0800 (PST)
Received: by mail-oi0-x22a.google.com with SMTP id f135so13657380oib.0
 for <linux-nvdimm@lists.01.org>; Thu, 23 Nov 2017 10:09:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <91626014A8500F418F35F9EB590D2531AA96A9A8@IRSMSX106.ger.corp.intel.com>
References: <1510238453-7713-1-git-send-email-lukasz.plewa@intel.com>
 <CAOSf1CFMsPwFcO6Mp4fV+faEBdG5wwi3d1nGK+n-MDGF4v0oLw@mail.gmail.com>
 <x498tfe8820.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jJ0J4EkD95OXRWOogyV0tbY_WaO9WyQULL3bs+rShQBA@mail.gmail.com>
 <x49375m5blz.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4ieVYyrLgL4khMkqW-Rf36Ptzmnj0nAvoog0+zd_G3shg@mail.gmail.com>
 <91626014A8500F418F35F9EB590D2531AA96A9A8@IRSMSX106.ger.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 23 Nov 2017 10:09:02 -0800
Message-ID: <CAPcyv4jmTfMw-UZxa6Fhoy7bZXqbTZc84CLby440pq72NtSGCA@mail.gmail.com>
Subject: Re: [PATCH] daxctl: remove libpmem dependency
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
To: "Czurylo, Krzysztof" <krzysztof.czurylo@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 23, 2017 at 9:23 AM, Czurylo, Krzysztof
<krzysztof.czurylo@intel.com> wrote:
>> On Fri, Nov 10, 2017 at 8:42 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> > Dan Williams <dan.j.williams@intel.com> writes:
>> >
>> >>> I don't know, is it impossible to make this work w/o yanking out -
>> lpmem?
>> >>
>> >> My preference would be that allthe  pmem_memcpy* routines move to
>> >> libndctl since it is the lower level library. Arrange for nvml to
>> >> depend on libdnctl for this in addition to the other libndctl
>> >> dependencies that seem to be in the works.
>> >
>> > That's fine by me.  Can you convince the nvml developers to do that?
>> >
>>
>> The other concern is that libpmem supports other OSes, but libndctl is
>> just Linux. That seems to suggest we need the memcpy routines to be
>> their own standalone library that both ndctl and libpmem can import.
>
> Folks,
>
> I understand your concerns, but to be honest, I don't like the idea of
> moving pmem_memcpy* routines to libndctl or yet another library.
> The libpmem *is* the library.
> In practice, if we move pmem_memcpy*/pmem_memset* to ndctl, it means
> that almost the _entire_ libpmem code would need to be moved to ndctl
> (maybe without the APIs like pmem_map_file/pmem_unmap). So, looks like
> it's all about moving libpmem from nvml repo to ndctl repo, isn't it?
> It leads us to another question - perhaps we should simply merge those
> two projects into one? It would solve all the problems with
> cross-dependencies between ndctl and nvml, once and for all.
> However, besides some technical issues, one of the problems is
> the license - GPL vs. BSD - and I'm not sure how to deal with it.
>
> For me, there are a few options:
> 1) Integrate the patch proposed by Lukasz (maybe slightly modified).
> This looks like the easiest and simplest, thus preferred solution.
> Of course, we can detect the cache line size and the availability
> of CLFLUSHOPT/CLWB, if necessary.
> Correct me if I'm wrong, but I don't expect "daxctl io" to be used
> frequently, so even if it's not optimal (does not use MOVNT) and we
> need to flush the cache, the performance shouldn't be a big issue.
> BTW, this code is only compiled for x86, so maybe we don't even need
> to care about other architectures?
>
> 2) Clone the pmem_memcpy/pmem_memset/pmem_persist routines into ndctl
> (for internal use only). The libpmem would still provide those
> interfaces.
> It duplicates the code (is it a big deal?), but eliminates dependency
> on libpmem.
>
> 3) Remove "daxctl io" command from ndctl and integrate it with
> NVML's "pmempool" utility (or a dedicated tool/subpkg).
> There's not much we need to do, as in practice we already have a similar
> tool in the nvml repo (src/test/tools/ddmap). So far, it's only used
> for testing, but could become a standalone "ddmap" or "daxio" utility.

I'd like to investigate this option. We need a utility to manage
(provision, re-provision, backup) device-dax capacity, and I don't
much care if it comes from the daxctl package, or elsewhere.

> Keep in mind that most of the problems with library dependencies are
> because of Device DAX support. Device DAX was intended to be a temporary
> workaround until the Linux kernel/filesystems provide full support for
> PM programming model, but in practice it cluttered NVML with
> DevDAX-specific code, triggered some deep modifications of NVML internals,
> and now you're proposing yet another significant change.
> Once the MAP_SYNC flag is available, Device DAX becomes less important,
> I believe, and might get eliminated eventually. Shall we change the
> architecture of NVML or how the code is organized just because of it?

I disagree with this assessment. We continue to find uses for
device-dax as a hugetlbfs alternative, and it remains the only
interface that is safe for RDMA and virtualization with dax. MAP_SYNC
is not a device-dax replacement.

> I opt for the simplest solution, as proposed by Lukasz.

Let's take a look at shipping 'daxctl io' alongside pmempool. I do not
want multiple pmem_memcpy() implementations to start proliferating
around various userspace packages.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
