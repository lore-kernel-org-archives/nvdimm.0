Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 573B320958BE4
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 15:40:09 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id n18so5335073oig.2
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 15:42:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1503522466-35486-1-git-send-email-meng.xu@gatech.edu>
References: <1503522466-35486-1-git-send-email-meng.xu@gatech.edu>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Aug 2017 15:42:52 -0700
Message-ID: <CAPcyv4jWuFjiY6-Ct4VRRjLwDMNQXBabQ0WkH+ZvpJmZbE3H1w@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: fix potential double-fetch bug
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
To: Meng Xu <meng.xu@gatech.edu>
Cc: taesoo@gatech.edu, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, sanidhya@gatech.edu, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Meng Xu <mengxu.gatech@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

[ adding Jerry ]

On Wed, Aug 23, 2017 at 2:07 PM, Meng Xu <meng.xu@gatech.edu> wrote:
> From: Meng Xu <mengxu.gatech@gmail.com>
>
> While examining the kernel source code, I found a dangerous operation that
> could turn into a double-fetch situation (a race condition bug) where
> the same userspace memory region are fetched twice into kernel with sanity
> checks after the first fetch while missing checks after the second fetch.
>
> In the case of _IOC_NR(ioctl_cmd) == ND_CMD_CALL:
>
> 1. The first fetch happens in line 935 copy_from_user(&pkg, p, sizeof(pkg)
>
> 2. subsequently `pkg.nd_reserved2` is asserted to be all zeroes
> (line 984 to 986).
>
> 3. The second fetch happens in line 1022 copy_from_user(buf, p, buf_len)
>
> 4. Given that `p` can be fully controlled in userspace, an attacker can
> race condition to override the header part of `p`, say,
> `((struct nd_cmd_pkg *)p)->nd_reserved2` to arbitrary value
> (say nine 0xFFFFFFFF for `nd_reserved2`) after the first fetch but before the
> second fetch. The changed value will be copied to `buf`.
>
> 5. There is no checks on the second fetches until the use of it in
> line 1034: nd_cmd_clear_to_send(nvdimm_bus, nvdimm, cmd, buf) and
> line 1038: nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len, &cmd_rc)
> which means that the assumed relation, `p->nd_reserved2` are all zeroes might
> not hold after the second fetch. And once the control goes to these functions
> we lose the context to assert the assumed relation.
>
> 6. Based on my manual analysis, `p->nd_reserved2` is not used in function
> `nd_cmd_clear_to_send` and potential implementations of `nd_desc->ndctl`
> so there is no working exploit against it right now. However, this could
> easily turns to an exploitable one if careless developers start to use
> `p->nd_reserved2` later and assume that they are all zeroes.
>
> Proposed patch:
>
> The patch explicitly overrides `buf->nd_reserved2` after the second fetch with
> the value `pkg.nd_reserved2` from the first fetch. In this way, it is assured
> that the relation, `buf->nd_reserved2` are all zeroes, holds after the second
> fetch.
>
> Signed-off-by: Meng Xu <mengxu.gatech@gmail.com>
> ---
>  drivers/nvdimm/bus.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 937fafa..20c4d0f 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -1024,6 +1024,12 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>                 goto out;
>         }
>
> +       if (cmd == ND_CMD_CALL) {
> +               struct nd_cmd_pkg *hdr = (struct nd_cmd_pkg *)buf;
> +               memcpy(hdr->nd_reserved2, pkg.nd_reserved2,
> +                               sizeof(pkg.nd_reserved2));
> +       }
> +

I think we're ok because the end point like acpi_nfit_ctl() is
responsible for re-validating the buffer. So what I would rather like
to see is deleting this loop:

                for (i = 0; i < ARRAY_SIZE(pkg.nd_reserved2); i++)
                        if (pkg.nd_reserved2[i])
                                return -EINVAL;

...from __nd_ioctl() and move it into acpi_nfit_ctl() directly where it belongs.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
