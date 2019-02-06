Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com
 [IPv6:2607:f8b0:4864:20::334])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D92821962301
 for <linux-nvdimm@lists.01.org>; Wed,  6 Feb 2019 15:42:32 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id u16so15194373otk.8
 for <linux-nvdimm@lists.01.org>; Wed, 06 Feb 2019 15:42:32 -0800 (PST)
MIME-Version: 1.0
References: <20190206231706.GB23860@ubuette>
In-Reply-To: <20190206231706.GB23860@ubuette>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Feb 2019 15:42:17 -0800
Message-ID: <CAPcyv4jhkkUd_rZ9PhZhOZDYYgMj28siVBUjhMMT4c4HJiaAHw@mail.gmail.com>
Subject: Re: question about mmap MAP_PRIVATE on PMEM/DAX/fs files
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
To: Larry Bassel <larry.bassel@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 6, 2019 at 3:17 PM Larry Bassel <larry.bassel@oracle.com> wrote:
>
> Is mmaping a PMEM/DAX/fs file MAP_PRIVATE supported?

Yes.

> Is it something
> that people are likely to want to do?

MAP_PRIVATE for file backed mappings is useful for processes to read
common data as input, but hide their writes to that data.

> If it is supported, suppose I open a file in PMEM/DAX/fs, mmap it
> MAP_PRIVATE, read from the memory mapped file (with memory accesses,
> not the read syscall) and take a page fault which the kernel satisfies.
>
> At this time do my page tables for the private mmaped page(s) point to the
> PMEM corresponding to the file and the kernel will wait until
> the page(s) is/are altered (either by me or someone else) to
> copy on write and give me a different page/mapping?

For this example let's assume the filesystem already allocated
capacity for the file at the given offset, otherwise the kernel is
free to map in a zero page to cover holes in the file.

> Or does the kernel avoid this by always mapping a copy of the
> page(s) involved in the private mmap in the first place?
>

At read-fault time the page tables point to the direct PMEM page for
the file allocation, for a write fault a "System RAM" page is mapped
in place of PMEM.

> In either case, is my private copy going to come from PMEM or is it
> an "ordinary" page, or is this "random"? Does the program have
> any choice in this (i.e. suppose I want to make sure my copied
> page is persistent)?

No, the copied page will never be persisted. From the mmap() man page:

"Updates to the mapping are not visible to other processes mapping the
same file, and are not carried through to the underlying file."
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
