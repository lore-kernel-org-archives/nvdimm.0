From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] pmem: return EIO on read_pmem() failure
Date: Thu, 05 Jan 2017 10:11:32 -0500
Message-ID: <x491swh35jv.fsf@segfault.boston.devel.redhat.com>
References: <20170105100546.11379-1-stefanha@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170105100546.11379-1-stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Stefan Hajnoczi's
 message of "Thu, 5 Jan 2017 10:05:46 +0000")
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

Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> The read_pmem() function uses memcpy_mcsafe() on x86 where an EFAULT
> error code indicates a failed read.  Block I/O should use EIO to
> indicate failure.  Other pmem code paths (like bad blocks) already use
> EIO so let's be consistent.

I agree that it's the right thing to return, though right now it
probably doesn't matter.  As Dan said, all paths leading back to
userspace interpret any non-zero value as EIO.

Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/nvdimm/pmem.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 7282d74..5b536be 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -90,7 +90,9 @@ static int read_pmem(struct page *page, unsigned int off,
>  
>  	rc = memcpy_from_pmem(mem + off, pmem_addr, len);
>  	kunmap_atomic(mem);
> -	return rc;
> +	if (rc)
> +		return -EIO;
> +	return 0;
>  }
>  
>  static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
