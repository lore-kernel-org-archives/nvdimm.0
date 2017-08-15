Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22e.google.com (mail-yw0-x22e.google.com
 [IPv6:2607:f8b0:4002:c05::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C478821DFC86C
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 10:09:03 -0700 (PDT)
Received: by mail-yw0-x22e.google.com with SMTP id s143so8430833ywg.1
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 10:11:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170815091836.c3xpsfgfwz7w35od@node.shutemov.name>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277754211.23945.458876600578531019.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170815091836.c3xpsfgfwz7w35od@node.shutemov.name>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Aug 2017 10:11:27 -0700
Message-ID: <CAPcyv4gmyFugKwMJCVwC9wFmQ8TL4TbHsa0p2Pqg2a6LziRHVw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] fs, xfs: introduce MAP_DIRECT for creating
 block-map-sealed file ranges
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
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 15, 2017 at 2:18 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Mon, Aug 14, 2017 at 11:12:22PM -0700, Dan Williams wrote:
>> MAP_DIRECT is an mmap(2) flag with the following semantics:
>>
>>   MAP_DIRECT
>>   In addition to this mapping having MAP_SHARED semantics, successful
>>   faults in this range may assume that the block map (logical-file-offset
>>   to physical memory address) is pinned for the lifetime of the mapping.
>>   Successful MAP_DIRECT faults establish mappings that bypass any kernel
>>   indirections like the page-cache. All updates are carried directly
>>   through to the underlying file physical blocks (modulo cpu cache
>>   effects).
>>
>>   ETXTBSY is returned on attempts to change the block map (allocate blocks
>>   / convert unwritten extents / break shared extents) in the mapped range.
>>   Some filesystems may extend these same restrictions outside the mapped
>>   range and return ETXTBSY to any file operations that might mutate the
>>   block map. MAP_DIRECT faults may fail with a SIGSEGV if the filesystem
>>   needs to write the block map to satisfy the fault. For example, if the
>>   mapping was established over a hole in a sparse file.
>
> We had issues before with user-imposed ETXTBSY. See MAP_DENYWRITE.
>
> Are we sure it won't a source of denial-of-service attacks?

I believe MAP_DENYWRITE allowed any application with read access to be
able to deny writes which is obviously problematic. MAP_DIRECT is
different. You need write access to the file so you can already
destroy data that another application might depend on, and this only
blocks allocation and reflink.

However, I'm not opposed to adding more safety around this. I think we
can address this concern with an fcntl seal as Dave suggests, but the
seal only applies to the 'struct file' instance and only gates whether
MAP_DIRECT is allowed on that file. The act of setting
F_MAY_SEAL_IOMAP requires CAP_IMMUTABLE, but MAP_DIRECT does not. This
allows the 'permission to mmap(MAP_DIRECT)' to be passed around with
an open file descriptor.

>
>>   The kernel ignores attempts to mark a MAP_DIRECT mapping MAP_PRIVATE and
>>   will silently fall back to MAP_SHARED semantics.
>
> Hm.. Any reason for this strage behaviour? Looks just broken to me.
>
>>
>>   ERRORS
>>   EACCES A MAP_DIRECT mapping was requested and PROT_WRITE was not set.
>>
>>   EINVAL MAP_ANONYMOUS was specified with MAP_DIRECT.
>>
>>   EOPNOTSUPP The filesystem explicitly does not support the flag
>>
>>   SIGSEGV Attempted to write a MAP_DIRECT mapping at a file offset that
>>           might require block-map updates.
>
> I think it should be SIGBUS.

Ok, that does seem to fit this definition from the mmap(2) man page:

SIGBUS Attempted access to a portion of the buffer that does not
correspond to the file  (for example, beyond the end of the file,
including the case where another process has truncated the file).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
