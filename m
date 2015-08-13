Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1439484671-15718-7-git-send-email-ross.zwisler@linux.intel.com>
References: <1439484671-15718-1-git-send-email-ross.zwisler@linux.intel.com>
	<1439484671-15718-7-git-send-email-ross.zwisler@linux.intel.com>
Date: Thu, 13 Aug 2015 14:11:12 -0700
Message-ID: <CAPcyv4gPHTczq6HjK3dPmL0oSjkJmSnAX_gx7x04XtgtrzYZ+A@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] dax: update I/O path to do proper PMEM flushing
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matthew Wilcox <willy@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 13, 2015 at 9:51 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Update the DAX I/O path so that all operations that store data (I/O
> writes, zeroing blocks, punching holes, etc.) properly synchronize the
> stores to media using the PMEM API.  This ensures that the data DAX is
> writing is durable on media before the operation completes.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
[..]
> @@ -145,18 +147,27 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
>                                 retval = dax_get_addr(bh, &addr, blkbits);
>                                 if (retval < 0)
>                                         break;
> -                               if (buffer_unwritten(bh) || buffer_new(bh))
> +                               if (buffer_unwritten(bh) || buffer_new(bh)) {
>                                         dax_new_buf(addr, retval, first, pos,
>                                                                         end);
> +                                       need_wmb = true;
> +                               }
>                                 addr += first;
>                                 size = retval - first;
>                         }
>                         max = min(pos + size, end);
>                 }
>
> -               if (iov_iter_rw(iter) == WRITE)
> +               if (iov_iter_rw(iter) == WRITE) {
>                         len = copy_from_iter_nocache(addr, max - pos, iter);
> -               else if (!hole)
> +                       /*
> +                        * copy_from_iter_nocache() uses non-temporal stores
> +                        * for iovec iterators so we can skip the write back.
> +                        */
> +                       if (!iter_is_iovec(iter))
> +                               wb_cache_pmem((void __pmem *)addr, max - pos);
> +                       need_wmb = true;

I think this should become copy_from_iter_pmem() and hide the
wb_cache_pmem() as an internal arch detail.  I.e. wb_cache_pmem()
should not be a global api when its usage is architecture specific.
Otherwise are you asserting that all architecture implementations of
copy_from_iter_nocache() are pmem safe?
