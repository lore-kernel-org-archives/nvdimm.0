Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22f.google.com (mail-yw0-x22f.google.com
 [IPv6:2607:f8b0:4002:c05::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C44B2095E004
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 09:22:00 -0700 (PDT)
Received: by mail-yw0-x22f.google.com with SMTP id s143so7677497ywg.1
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 09:24:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170815122701.GF27505@quack2.suse.cz>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277753660.23945.11500026891611444016.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170815122701.GF27505@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Aug 2017 09:24:24 -0700
Message-ID: <CAPcyv4hJ3VaCzE0tOtcSJPfMPDimH-_oeoUAha8MVJ6ZOQU8fw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm: introduce MAP_VALIDATE a mechanism for adding
 new mmap flags
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
To: Jan Kara <jack@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 15, 2017 at 5:27 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 14-08-17 23:12:16, Dan Williams wrote:
>> The mmap syscall suffers from the ABI anti-pattern of not validating
>> unknown flags. However, proposals like MAP_SYNC and MAP_DIRECT need a
>> mechanism to define new behavior that is known to fail on older kernels
>> without the feature. Use the fact that specifying MAP_SHARED and
>> MAP_PRIVATE at the same time is invalid as a cute hack to allow a new
>> set of validated flags to be introduced.
>>
>> This also introduces the ->fmmap() file operation that is ->mmap() plus
>> flags. Each ->fmmap() implementation must fail requests when a locally
>> unsupported flag is specified.
> ...
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 1104e5df39ef..bbe755d0caee 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -1674,6 +1674,7 @@ struct file_operations {
>>       long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>>       long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
>>       int (*mmap) (struct file *, struct vm_area_struct *);
>> +     int (*fmmap) (struct file *, struct vm_area_struct *, unsigned long);
>>       int (*open) (struct inode *, struct file *);
>>       int (*flush) (struct file *, fl_owner_t id);
>>       int (*release) (struct inode *, struct file *);
>> @@ -1748,6 +1749,12 @@ static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
>>       return file->f_op->mmap(file, vma);
>>  }
>>
>> +static inline int call_fmmap(struct file *file, struct vm_area_struct *vma,
>> +             unsigned long flags)
>> +{
>> +     return file->f_op->fmmap(file, vma, flags);
>> +}
>> +
>
> Hum, I dislike a new file op for this when the only problem with ->mmap is
> that it misses 'flags' argument. I understand there are lots of ->mmap
> implementations out there and modifying prototype of them all is painful
> but is it so bad? Coccinelle patch for this should be rather easy...

Changing the prototype is relatively easy with Coccinelle, but we
still need the code in each ->mmap() implementation to validate a
local list of supported flags. How about adding a 'supported mmap
flags' field to 'struct file_operations' so that the validation code
can be made generic? I'll go with that since it's a bit less
surprising than a new operation type, and not as messy as teaching
every mmap implementation in the kernel to validate flags that they
will likely never care about.

> Also for MAP_SYNC I want the flag to be copied in VMA anyway so for that I
> don't need additional flags argument anyway. And I wonder how you want to
> make things work without VMA flag in case of MAP_DIRECT as well - VMAs can
> be split, partially unmapped etc. and so without VMA flag you are going to
> have hard time to detect whether there's any mapping left which blocks
> block mapping changes.

Outside of requiring a 64-bit arch, we're out of vm_flags. Also, the
core mm does not really care about MAP_DIRECT or MAP_SYNC so that's
why I added a new ->fs_flags field since these are more filesystem
properties than core mm.

The problem of tracking MAP_DIRECT over vma splits appears to already
be handled. __split_vma does:

        /* most fields are the same, copy all, and then fixup */
        *new = *vma;
...

        if (new->vm_ops && new->vm_ops->open)
                new->vm_ops->open(new);

In ->open() I'm checking if 'new' has MAP_DIRECT in ->fs_flags and
taking a reference against the S_IOMAP_SEALED flag.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
