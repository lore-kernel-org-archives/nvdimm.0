Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F32F921E11D0F
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 13:21:55 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id r203so4124787oih.0
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 13:24:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4de21e8d-5e10-ec40-c731-0c079953cf48@gmx.de>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353213097.5039.6729469069608762658.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824165546.GA3121@infradead.org>
 <CAPcyv4iN0QpUSgOUvisnNQsiV1Pp=4dh7CwAV8FFj=_rFU=aug@mail.gmail.com>
 <20170825130011.GA30072@infradead.org>
 <20170825155803.4km7wttzadfqw2vb@node.shutemov.name>
 <20170825160236.GA2561@infradead.org>
 <20170825161607.6v6beg4zjktllt2z@node.shutemov.name>
 <4de21e8d-5e10-ec40-c731-0c079953cf48@gmx.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Aug 2017 13:24:31 -0700
Message-ID: <CAPcyv4jeZc8P+E0aHNChzy-wfNpOx3GehKck1nXqJ1b9JdydFA@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] mm: introduce mmap3 for safely defining new mmap
 flags
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
To: Helge Deller <deller@gmx.de>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-parisc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 25, 2017 at 9:19 AM, Helge Deller <deller@gmx.de> wrote:
> On 25.08.2017 18:16, Kirill A. Shutemov wrote:
>> On Fri, Aug 25, 2017 at 09:02:36AM -0700, Christoph Hellwig wrote:
>>> On Fri, Aug 25, 2017 at 06:58:03PM +0300, Kirill A. Shutemov wrote:
>>>> Not all archs are ready for this:
>>>>
>>>> arch/parisc/include/uapi/asm/mman.h:#define MAP_TYPE    0x03            /* Mask for type of mapping */
>>>> arch/parisc/include/uapi/asm/mman.h:#define MAP_FIXED   0x04            /* Interpret addr exactly */
>>>
>>> I'd be happy to say that we should not care about parisc for
>>> persistent memory.  We'll just have to find a way to exclude
>>> parisc without making life too ugly.
>>
>> I don't think creapling mmap() interface for one arch is the right way to
>> go. I think the interface should be universal.
>>
>> I may imagine MAP_DIRECT can be useful not only for persistent memory.
>> For tmpfs instead of mlock()?
>
> On parisc we have
> #define MAP_SHARED      0x01            /* Share changes */
> #define MAP_PRIVATE     0x02            /* Changes are private */
> #define MAP_TYPE        0x03            /* Mask for type of mapping */
> #define MAP_FIXED       0x04            /* Interpret addr exactly */
> #define MAP_ANONYMOUS   0x10            /* don't use a file */
>
> So, if you need a MAP_DIRECT, wouldn't e.g.
> #define MAP_DIRECT      0x08
> be possible (for parisc, and others 0x04).
> And if MAP_TYPE needs to include this flag on parisc:
> #define MAP_TYPE        (0x03 | 0x08)  /* Mask for type of mapping */

The problem here is that to support new the mmap flags the arch needs
to find a flag that is guaranteed to fail on older kernels. Defining
MAP_DIRECT to 0x8 on parisc doesn't work because it will simply be
ignored on older parisc kernels.

However, it's already the case that several archs have their own
sys_mmap entry points. Those archs that can't follow the common scheme
(only parsic it seems) will need to add a new mmap syscall. I think
that's a reasonable tradeoff to allow every other architecture to add
this support with their existing mmap syscall paths.

That means MAP_DIRECT should be defined to MAP_TYPE on parisc until it
later defines an opt-in mechanism to a new syscall that honors
MAP_DIRECT as a valid flag.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
