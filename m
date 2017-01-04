From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: nvdimm read EFAULT vs EIO
Date: Wed, 4 Jan 2017 09:26:17 -0800
Message-ID: <CAPcyv4ijhcsZUKH9i7RyvaaM1WrkBWdGf6bea1d3SdxwnpwyaA@mail.gmail.com>
References: <20170104164530.GA10372@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170104164530.GA10372-lxVrvc10SDRcolVlb+j0YCZi+YwRKgec@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Jan 4, 2017 at 8:45 AM, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> In drivers/nvdimm/pmem.c:pmem_do_bvec() reads are handled as follows:
>
>   if (unlikely(bad_pmem))
>           rc = -EIO;
>   else {
>           rc = read_pmem(page, off, pmem_addr, len);
>           flush_dcache_page(page);
>   }
>
> read_pmem() returns -EFAULT on error so the error return value of
> pmem_do_bvec() is either -EIO or -EFAULT.  EFAULT strikes me as unusual for a
> function used in the block I/O code path.
>
> Is the distinction between EIO and EFAULT significant for pmem_do_bvec() callers?

It looks like all users except btrfs just check if bi_error is non-zero

> If not, should the function return -EIO in both cases?

I'm leaning toward fixing up btrfs to handle all errors as I/O errors.
Otherwise, it's not clear to me why
fs/btrfs/volumes.c::btrfs_end_bio() would need to parse error codes,
but drivers/md/raid5.c::raid5_end_read_request() does not.

Should probably address it both ways, make btrfs more tolerant in what
it accepts and make pmem more consistent / conservative in what it
sends.
