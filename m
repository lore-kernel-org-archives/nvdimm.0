Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22e.google.com (mail-ot0-x22e.google.com
 [IPv6:2607:f8b0:4003:c0f::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 767BC21A07A85
 for <linux-nvdimm@lists.01.org>; Sat, 17 Jun 2017 14:51:20 -0700 (PDT)
Received: by mail-ot0-x22e.google.com with SMTP id r67so49100658ota.1
 for <linux-nvdimm@lists.01.org>; Sat, 17 Jun 2017 14:52:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALCETrU1Hg=q4cdQDex--3nVBfwRC1o=9pC6Ss77Z8Lxg7ZJLg@mail.gmail.com>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrU1Hg=q4cdQDex--3nVBfwRC1o=9pC6Ss77Z8Lxg7ZJLg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 17 Jun 2017 14:52:38 -0700
Message-ID: <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
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
To: Andy Lutomirski <luto@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 17, 2017 at 9:25 AM, Andy Lutomirski <luto@kernel.org> wrote:
> On Fri, Jun 16, 2017 at 6:15 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> To date, the full promise of byte-addressable access to persistent
>> memory has only been half realized via the filesystem-dax interface. The
>> current filesystem-dax mechanism allows an application to consume (read)
>> data from persistent storage at byte-size granularity, bypassing the
>> full page reads required by traditional storage devices.
>>
>> Now, for writes, applications still need to contend with
>> page-granularity dirtying and flushing semantics as well as filesystem
>> coordination for metadata updates after any mmap write. The current
>> situation precludes use cases that leverage byte-granularity / in-place
>> updates to persistent media.
>>
>> To get around this limitation there are some specialized applications
>> that are using the device-dax interface to bypass the overhead and
>> data-safety problems of the current filesystem-dax mmap-write path.
>> QEMU-KVM is forced to use device-dax to safely pass through persistent
>> memory to a guest [1]. Some specialized databases are using device-dax
>> for byte-granularity writes. Outside of those cases, device-dax is
>> difficult for general purpose persistent memory applications to consume.
>> There is demand for access to pmem without needing to contend with
>> special device configuration and other device-dax limitations.
>>
>> The 'daxfile' interface satisfies this demand and realizes one of Dave
>> Chinner's ideas for allowing pmem applications to safely bypass
>> fsync/msync requirements. The idea is to make the file immutable with
>> respect to the offset-to-block mappings for every extent in the file
>> [2]. It turns out that filesystems already need to make this guarantee
>> today. This property is needed for files marked as swap files.
>>
>> The new daxctl() syscall manages setting a file into 'static-dax' mode
>> whereby it arranges for the file to be treated as a swapfile as far as
>> the filesystem is concerned, but not registered with the core-mm as
>> swapfile space. A file in this mode is then safe to be mapped and
>> written without the requirement to fsync/msync the writes.  The cpu
>> cache management for flushing data to persistence can be handled
>> completely in userspace.
>
> Can you remind those of us who haven't played with DAX in a while what
> the problem is with mmapping a DAX file without this patchset?  If
> there's some bookkkeeping needed to make sure that the filesystem will
> invalidate all the mappings if it decides to move the file, maybe that
> should be the default rather than needing a new syscall.

The bookkeeping to invalidate mappings when the filesystem moves a
block is already there.

Without this patchset an application needs to call fsync/msync after
any write to a DAX mapping otherwise there is no guarantee the
filesystem has written the metadata to find the updated block after a
crash or power loss event. Even if the sync operation is reduced to a
minimal cmpxchg in userspace to check if the filesystem-metadata is
dirty, that mechanism doesn't translate to a virtualized environment,
as requiring guests to trigger host fsync()s is not feasible. It's a
half-step solution when you can instead just ask the filesystem to
never move blocks, as Dave proposed many months back.

We stepped back from that proposal when it looked like a significant
amount of per-filesystem work to introduce the capability and it was
not clear that application developers would tolerate the side effects
of this 'immutable' semantic. However, the implementation is dead
simple since ext4 and xfs already need to make
block-allocation-immutable semantics available for swapfiles. We also
have application developers telling us they are ok with the semantics,
especially because it catches Linux up to other operating environments
that are already on board with allowing this type of access to pmem
through a filesystem. This patchset gives pmem application developers
what they want without any additional burden on filesystem
implementations.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
