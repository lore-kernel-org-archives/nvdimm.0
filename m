Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1446070176-14568-3-git-send-email-ross.zwisler@linux.intel.com>
References: <1446070176-14568-1-git-send-email-ross.zwisler@linux.intel.com>
	<1446070176-14568-3-git-send-email-ross.zwisler@linux.intel.com>
Date: Thu, 29 Oct 2015 08:02:17 +0900
Message-ID: <CAPcyv4hRFi9MjEsj0xhN7KqqOdbZ-CZHdk9NToAYEL5wv5BHpA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pmem: Add simple and slow fsync/msync support
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 29, 2015 at 7:09 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Make blkdev_issue_flush() behave correctly according to its required
> semantics - all volatile cached data is flushed to stable storage.
>
> Eventually this needs to be replaced with something much more precise by
> tracking dirty DAX entries via the radix tree in struct address_space, but
> for now this gives us correctness even if the performance is quite bad.
>
> Userspace applications looking to avoid the fsync/msync penalty should
> consider more fine-grained flushing via the NVML library:
>
> https://github.com/pmem/nvml
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  drivers/nvdimm/pmem.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 0ba6a97..eea7997 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -80,7 +80,14 @@ static void pmem_make_request(struct request_queue *q, struct bio *bio)
>         if (do_acct)
>                 nd_iostat_end(bio, start);
>
> -       if (bio_data_dir(bio))
> +       if (bio->bi_rw & REQ_FLUSH) {
> +               void __pmem *addr = pmem->virt_addr + pmem->data_offset;
> +               size_t size = pmem->size - pmem->data_offset;
> +
> +               wb_cache_pmem(addr, size);
> +       }
> +

So I think this will be too expensive to run synchronously in the
submission path for very large pmem ranges and should be farmed out to
an async thread. Then, as long as we're farming it out, might as well
farm it out to more than one cpu.  I'll take a stab at this on the
flight back from KS.

Another optimization is that we can make the flush a nop up until
pmem_direct_access() is first called, because we know there is nothing
to flush when all the i/o is coming through the driver.  That at least
helps the "pmem as a fast SSD" use case avoid the overhead.

Bikeshed alert... wb_cache_pmem() should probably become
mmio_wb_cache() and live next to mmio_flush_cache() since it is not
specific to persistent memory.
