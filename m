Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x241.google.com (mail-vk0-x241.google.com
 [IPv6:2607:f8b0:400c:c05::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E5BD2097E25F
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 09:36:18 -0700 (PDT)
Received: by mail-vk0-x241.google.com with SMTP id h22-v6so2842757vke.4
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 09:36:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180718024944.577-2-bhe@redhat.com>
References: <20180718024944.577-1-bhe@redhat.com>
 <20180718024944.577-2-bhe@redhat.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 18 Jul 2018 19:36:17 +0300
Message-ID: <CAHp75VdO88ydJQ9GHdaDUmAmzL6QHR=US6JiXZ1R_EEA-xWR1Q@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] resource: Move reparent_resources() to
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
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, brijesh.singh@amd.com, devicetree <devicetree@vger.kernel.org>, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, Max Filippov <jcmvbkbc@gmail.com>, Paul Mackerras <paulus@samba.org>, baiyaowei@cmss.chinamobile.com, KY Srinivasan <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input <linux-input@vger.kernel.org>, Gustavo Padovan <gustavo@padovan.org>, Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Josh Triplett <josh@joshtriplett.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Rob Herring <robh+dt@kernel.org>, Sean Paul <seanpaul@chromium.org>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>, Jon Derrick <jonathan.derrick@intel.com>, Chris Zankel <chris@zankel.net>, Michal Simek <monstr@monstr.eu>, linux-parisc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Eric Biederman <ebiederm@xmission.com>, devel@linuxdriverproject.org, Andrew Morton <akpm@linux-foundation.org>, kbuild test robot <fengguang.wu@intel.com>, "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" <linuxppc-dev@lists.ozlabs.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 18, 2018 at 5:49 AM, Baoquan He <bhe@redhat.com> wrote:
> reparent_resources() is duplicated in arch/microblaze/pci/pci-common.c
> and arch/powerpc/kernel/pci-common.c, so move it to kernel/resource.c
> so that it's shared.

Some minor stuff.

> +/**
> + * reparent_resources - reparent resource children of parent that res covers
> + * @parent: parent resource descriptor
> + * @res: resource descriptor desired by caller
> + *
> + * Returns 0 on success, -ENOTSUPP if child resource is not completely
> + * contained by 'res', -ECANCELED if no any conflicting entry found.

'res' -> @res

> + *
> + * Reparent resource children of 'parent' that conflict with 'res'

Ditto + 'parent' -> @parent

> + * under 'res', and make 'res' replace those children.

Ditto.

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

Now, PCI is a bit confusing here.

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
