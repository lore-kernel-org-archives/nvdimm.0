Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 54A3C211B1112
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 17:28:50 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id u18so462629oie.10
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 17:28:50 -0800 (PST)
MIME-Version: 1.0
References: <20190122024810.4448-1-richardw.yang@linux.intel.com>
In-Reply-To: <20190122024810.4448-1-richardw.yang@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Jan 2019 17:28:39 -0800
Message-ID: <CAPcyv4hn2JKAaH2YX0Ywc0Qa-_kHGk9QaqnO+odzHFzchbZVzA@mail.gmail.com>
Subject: Re: [PATCH 1/2] libnvdimm, pfn: use size is enough
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
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 21, 2019 at 6:49 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>
> When trying to see whether current nd_region intersects with others, we
> have already calculated the *size* to be expanded to SECTION size.
>
> So just pass size is enough.
>
> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
> ---
>  drivers/nvdimm/pfn_devs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index becf0bb481b3..5eca050b3660 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -686,7 +686,7 @@ static void trim_pfn_device(struct nd_pfn *nd_pfn, u32 *start_pad, u32 *end_trun
>         if (region_intersects(start, size, IORESOURCE_SYSTEM_RAM,
>                                 IORES_DESC_NONE) == REGION_MIXED
>                         || !IS_ALIGNED(end, nd_pfn->align)
> -                       || nd_region_conflict(nd_region, start, size + adjust))
> +                       || nd_region_conflict(nd_region, start, size))

Good catch, thanks. I fixed up the changelog a bit and applied this:

    libnvdimm, pfn: Fix over-trim in trim_pfn_device()

    When trying to see whether current nd_region intersects with others,
    trim_pfn_device() has already calculated the *size* to be expanded to
    SECTION size.

    Do not double append 'adjust' to 'size' when calculating whether the end
    of a region collides with the next pmem region.

    Fixes: ae86cbfef381 "libnvdimm, pfn: Pad pfn namespaces relative
to other regions"
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
