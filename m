Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23011207E4DF6
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 09:39:05 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id h8-v6so25969119otb.2
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 09:39:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180523163442.GB29519@linux.intel.com>
References: <152539236455.31796.7516599166555186700.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152539240242.31796.4162676712193177396.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180523163442.GB29519@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 May 2018 09:39:04 -0700
Message-ID: <CAPcyv4gaM+vMLQKzfQ3J0LBhN2L6uNUzqwH_m39pFN-TeQHavA@mail.gmail.com>
Subject: Re: [PATCH v3 7/9] dax: report bytes remaining in dax_iomap_actor()
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Luck, Tony" <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 23, 2018 at 9:34 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Thu, May 03, 2018 at 05:06:42PM -0700, Dan Williams wrote:
>> In preparation for protecting the dax read(2) path from media errors
>> with copy_to_iter_mcsafe() (via dax_copy_to_iter()), convert the
>> implementation to report the bytes successfully transferred.
>>
>> Cc: <x86@kernel.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Andy Lutomirski <luto@amacapital.net>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  fs/dax.c |   20 +++++++++++---------
>>  1 file changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/dax.c b/fs/dax.c
>> index a64afdf7ec0d..34a2d435ae4b 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -991,6 +991,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>>       struct iov_iter *iter = data;
>>       loff_t end = pos + length, done = 0;
>>       ssize_t ret = 0;
>> +     size_t xfer;
>>       int id;
>>
>>       if (iov_iter_rw(iter) == READ) {
>> @@ -1054,19 +1055,20 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>>                * vfs_write(), depending on which operation we are doing.
>>                */
>>               if (iov_iter_rw(iter) == WRITE)
>> -                     map_len = dax_copy_from_iter(dax_dev, pgoff, kaddr,
>> +                     xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
>>                                       map_len, iter);
>>               else
>> -                     map_len = dax_copy_to_iter(dax_dev, pgoff, kaddr,
>> +                     xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
>>                                       map_len, iter);
>> -             if (map_len <= 0) {
>> -                     ret = map_len ? map_len : -EFAULT;
>> -                     break;
>> -             }
>>
>> -             pos += map_len;
>> -             length -= map_len;
>> -             done += map_len;
>> +             pos += xfer;
>> +             length -= xfer;
>> +             done += xfer;
>> +
>> +             if (xfer == 0)
>> +                     ret = -EFAULT;
>> +             if (xfer < map_len)
>> +                     break;
>
> I'm confused by this error handling.  So if we hit an error on a given iov and
> we don't transfer the expected number of bytes, we have two cases:
>
> 1) We transferred *something* on this iov but not everything - return success.
> 2) We didn't transfer anything on this iov - return -EFAULT.
>
> Both of these are true regardless of data transferred on previous iovs.
>
> Why the distinction?  If a given iov is interrupted, regardless of whether it
> transferred 0 bytes or 1, shouldn't the error path be the same?

This is is the semantics of read(2) / write(2). Quoting the pwrite man page:

       Note that is not an error for  a  successful  call  to
transfer  fewer  bytes  than
       requested (see read(2) and write(2)).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
