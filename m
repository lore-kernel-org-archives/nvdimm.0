Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x243.google.com (mail-ua0-x243.google.com
 [IPv6:2607:f8b0:400c:c08::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 656BE209605D6
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 09:46:43 -0700 (PDT)
Received: by mail-ua0-x243.google.com with SMTP id x24-v6so3791992ual.10
 for <linux-nvdimm@lists.01.org>; Wed, 04 Jul 2018 09:46:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180704041038.8190-2-bhe@redhat.com>
References: <20180704041038.8190-1-bhe@redhat.com>
 <20180704041038.8190-2-bhe@redhat.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 4 Jul 2018 19:46:41 +0300
Message-ID: <CAHp75VfWLcQq4XGM3RyfO_ENx=3=WrCEhtOw+a0Sfwz_OpQ0UQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] resource: Move reparent_resources() to
 kernel/resource.c and make it public
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
To: Baoquan He <bhe@redhat.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, brijesh.singh@amd.com, devicetree <devicetree@vger.kernel.org>, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, Max Filippov <jcmvbkbc@gmail.com>, baiyaowei@cmss.chinamobile.com, KY Srinivasan <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm@lists.01.org, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input <linux-input@vger.kernel.org>, Gustavo Padovan <gustavo@padovan.org>, Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Josh Triplett <josh@joshtriplett.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Rob Herring <robh+dt@kernel.org>, Sean Paul <seanpaul@chromium.org>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>, Jon Derrick <jonathan.derrick@intel.com>, Chris Zankel <chris@zankel.net>, Michal Simek <monstr@monstr.eu>, linux-parisc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, kexec@lists.infradead.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Eric Biederman <ebiederm@xmission.com>, devel@linuxdriverproject.org, Andrew Morton <akpm@linux-foundation.org>, kbuild test robot <fengguang.wu@intel.com>, "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" <linuxppc-dev@lists.ozlabs.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 4, 2018 at 7:10 AM, Baoquan He <bhe@redhat.com> wrote:
> reparent_resources() is duplicated in arch/microblaze/pci/pci-common.c
> and arch/powerpc/kernel/pci-common.c, so move it to kernel/resource.c
> so that it's shared.

With couple of comments below,

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

P.S. In some commit message in this series you used 'likt' instead of 'like'.

>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  arch/microblaze/pci/pci-common.c | 37 -------------------------------------
>  arch/powerpc/kernel/pci-common.c | 35 -----------------------------------
>  include/linux/ioport.h           |  1 +
>  kernel/resource.c                | 39 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 40 insertions(+), 72 deletions(-)
>
> diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
> index f34346d56095..7899bafab064 100644
> --- a/arch/microblaze/pci/pci-common.c
> +++ b/arch/microblaze/pci/pci-common.c
> @@ -619,43 +619,6 @@ int pcibios_add_device(struct pci_dev *dev)
>  EXPORT_SYMBOL(pcibios_add_device);
>
>  /*
> - * Reparent resource children of pr that conflict with res
> - * under res, and make res replace those children.
> - */
> -static int __init reparent_resources(struct resource *parent,
> -                                    struct resource *res)
> -{
> -       struct resource *p, **pp;
> -       struct resource **firstpp = NULL;
> -
> -       for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
> -               if (p->end < res->start)
> -                       continue;
> -               if (res->end < p->start)
> -                       break;
> -               if (p->start < res->start || p->end > res->end)
> -                       return -1;      /* not completely contained */
> -               if (firstpp == NULL)
> -                       firstpp = pp;
> -       }
> -       if (firstpp == NULL)
> -               return -1;      /* didn't find any conflicting entries? */
> -       res->parent = parent;
> -       res->child = *firstpp;
> -       res->sibling = *pp;
> -       *firstpp = res;
> -       *pp = NULL;
> -       for (p = res->child; p != NULL; p = p->sibling) {
> -               p->parent = res;
> -               pr_debug("PCI: Reparented %s [%llx..%llx] under %s\n",
> -                        p->name,
> -                        (unsigned long long)p->start,
> -                        (unsigned long long)p->end, res->name);
> -       }
> -       return 0;
> -}
> -
> -/*
>   *  Handle resources of PCI devices.  If the world were perfect, we could
>   *  just allocate all the resource regions and do nothing more.  It isn't.
>   *  On the other hand, we cannot just re-allocate all devices, as it would
> diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> index fe9733ffffaa..926035bb378d 100644
> --- a/arch/powerpc/kernel/pci-common.c
> +++ b/arch/powerpc/kernel/pci-common.c
> @@ -1088,41 +1088,6 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
>  EXPORT_SYMBOL(pcibios_align_resource);
>
>  /*
> - * Reparent resource children of pr that conflict with res
> - * under res, and make res replace those children.
> - */
> -static int reparent_resources(struct resource *parent,
> -                                    struct resource *res)
> -{
> -       struct resource *p, **pp;
> -       struct resource **firstpp = NULL;
> -
> -       for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
> -               if (p->end < res->start)
> -                       continue;
> -               if (res->end < p->start)
> -                       break;
> -               if (p->start < res->start || p->end > res->end)
> -                       return -1;      /* not completely contained */
> -               if (firstpp == NULL)
> -                       firstpp = pp;
> -       }
> -       if (firstpp == NULL)
> -               return -1;      /* didn't find any conflicting entries? */
> -       res->parent = parent;
> -       res->child = *firstpp;
> -       res->sibling = *pp;
> -       *firstpp = res;
> -       *pp = NULL;
> -       for (p = res->child; p != NULL; p = p->sibling) {
> -               p->parent = res;
> -               pr_debug("PCI: Reparented %s %pR under %s\n",
> -                        p->name, p, res->name);
> -       }
> -       return 0;
> -}
> -
> -/*
>   *  Handle resources of PCI devices.  If the world were perfect, we could
>   *  just allocate all the resource regions and do nothing more.  It isn't.
>   *  On the other hand, we cannot just re-allocate all devices, as it would
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index da0ebaec25f0..dfdcd0bfe54e 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -192,6 +192,7 @@ extern int allocate_resource(struct resource *root, struct resource *new,
>  struct resource *lookup_resource(struct resource *root, resource_size_t start);
>  int adjust_resource(struct resource *res, resource_size_t start,
>                     resource_size_t size);
> +int reparent_resources(struct resource *parent, struct resource *res);
>  resource_size_t resource_alignment(struct resource *res);
>  static inline resource_size_t resource_size(const struct resource *res)
>  {
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 30e1bc68503b..d1cbf4b50e17 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -983,6 +983,45 @@ int adjust_resource(struct resource *res, resource_size_t start,
>  }
>  EXPORT_SYMBOL(adjust_resource);
>
> +/*

/** ?

> + * reparent_resources - reparent resource children of parent that res covers
> + * @parent: parent resource descriptor
> + * @res: resource descriptor desired by caller
> + *
> + * Reparent resource children of 'parent' that conflict with 'res'
> + * under 'res', and make 'res' replace those children.

Describe error codes, please.

> + */
> +int reparent_resources(struct resource *parent, struct resource *res)
> +{
> +       struct resource *p, **pp;
> +       struct resource **firstpp = NULL;
> +
> +       for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
> +               if (p->end < res->start)
> +                       continue;
> +               if (res->end < p->start)
> +                       break;
> +               if (p->start < res->start || p->end > res->end)
> +                       return -ENOTSUPP;       /* not completely contained */
> +               if (firstpp == NULL)
> +                       firstpp = pp;
> +       }
> +       if (firstpp == NULL)
> +               return -ECANCELED; /* didn't find any conflicting entries? */
> +       res->parent = parent;
> +       res->child = *firstpp;
> +       res->sibling = *pp;
> +       *firstpp = res;
> +       *pp = NULL;
> +       for (p = res->child; p != NULL; p = p->sibling) {
> +               p->parent = res;
> +               pr_debug("PCI: Reparented %s %pR under %s\n",
> +                        p->name, p, res->name);
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL(reparent_resources);
> +
>  static void __init __reserve_region_with_split(struct resource *root,
>                 resource_size_t start, resource_size_t end,
>                 const char *name)
> --
> 2.13.6
>



-- 
With Best Regards,
Andy Shevchenko
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
