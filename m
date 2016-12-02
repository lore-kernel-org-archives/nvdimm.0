Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CFFC81EAB
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:52:19 -0800 (PST)
Received: by mail-oi0-x22c.google.com with SMTP id v84so277320915oie.3
 for <linux-nvdimm@lists.01.org>; Fri, 02 Dec 2016 11:52:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480706527-21274-1-git-send-email-fabf@skynet.be>
References: <1480706527-21274-1-git-send-email-fabf@skynet.be>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Dec 2016 11:52:18 -0800
Message-ID: <CAPcyv4i1MjDC2xkVkzf0m_LcoaGwmQThEBcETi6pJ9pkG5cAvA@mail.gmail.com>
Subject: Re: [PATCH 7/8 linux-next] mm: warn about possible alignment problem
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
To: Fabian Frederick <fabf@skynet.be>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 2, 2016 at 11:22 AM, Fabian Frederick <fabf@skynet.be> wrote:
> Commit 5f29a77cd957
> ("mm: fix mixed zone detection in devm_memremap_pages")
> Aligned resource limits before region_intersects() which breaks
> the following with false assertions on kernel command line: memmap=4M!700M
>
> "devm_memremap_pages attempted on mixed region [ mem 0x2bc00000-0x2bfffff
> flags 0x200]"
>
> Memory regions
> 0x100000-0x2bbfffff: usable
> 0x2bc000000-0x2bbfffff: persistent
> 0x2c0000000-0x2bffffff: usable
>
> resource start: 0x2bc00000
> align start:    0x28000000
> resource size:  0x3fffffff
> align size:     0x80000000
> SECTION_SIZE:    0x8000000
>
> Now we need aligned memmap declarations based on 128M in this case
> eg memmap=128!640M
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  kernel/memremap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index b501e39..1bb5eec 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -296,8 +296,8 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
>                 IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE);
>
>         if (is_ram == REGION_MIXED) {
> -               WARN_ONCE(1, "%s attempted on mixed region %pr\n",
> -                               __func__, res);
> +               WARN_ONCE(1, "%s attempted on mixed region %pr or arguments not aligned to section size: %#lx\n",
> +                               __func__, res, SECTION_SIZE);
>                 return ERR_PTR(-ENXIO);
>         }

This should be addressed by the sub-section hotplug patches:

"[PATCH 00/11] mm: sub-section memory hotplug support"
https://lkml.org/lkml/2016/12/1/740
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
