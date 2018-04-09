Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x241.google.com (mail-qk0-x241.google.com
 [IPv6:2607:f8b0:400d:c09::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7773C2267F0E0
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 09:05:24 -0700 (PDT)
Received: by mail-qk0-x241.google.com with SMTP id o64so9864703qkl.7
 for <linux-nvdimm@lists.01.org>; Mon, 09 Apr 2018 09:05:24 -0700 (PDT)
Date: Mon, 9 Apr 2018 12:05:20 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH v3 1/3] resource: Use list_head to link resource
 sibling
In-Reply-To: <CAL_Jsq+xxa9ep2LK3H6YWhwrZtc-T73Y84ry6Hs-JJ3XEXoGsw@mail.gmail.com>
Message-ID: <nycvar.YSQ.7.76.1804091133330.28462@knanqh.ubzr>
References: <20180408024724.16812-1-bhe@redhat.com>
 <20180408024724.16812-2-bhe@redhat.com>
 <20180409090853.GJ19345@localhost.localdomain>
 <CAL_Jsq+xxa9ep2LK3H6YWhwrZtc-T73Y84ry6Hs-JJ3XEXoGsw@mail.gmail.com>
MIME-Version: 1.0
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
To: Rob Herring <robh+dt@kernel.org>
Cc: Brijesh Singh <brijesh.singh@amd.com>, devicetree@vger.kernel.org, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>, Keith Busch <keith.busch@intel.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, Baoquan He <bhe@redhat.com>, linux-nvdimm@lists.01.org, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input@vger.kernel.org, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, =?ISO-8859-15?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 9 Apr 2018, Rob Herring wrote:

> +Nico who has been working on tinification of the kernel.
> 
> On Mon, Apr 9, 2018 at 4:08 AM, Baoquan He <bhe@redhat.com> wrote:
> > The struct resource uses singly linked list to link siblings. It's not
> > easy to do reverse iteration on sibling list. So replace it with list_head.
> 
> Why is reverse iteration needed?
> 
> > And code refactoring makes codes in kernel/resource.c more readable than
> > pointer operation.
> 
> resource_for_each_* helpers could solve that without the size increase.
> 
> > Besides, type of member variables of struct resource, sibling and child, are
> > changed from 'struct resource *' to 'struct list_head'. Kernel size will
> > increase because of those statically defined struct resource instances.
> 
> The DT struct device_node also has the same tree structure with
> parent, child, sibling pointers and converting to list_head had been
> on the todo list for a while. ACPI also has some tree walking
> functions (drivers/acpi/acpica/pstree.c). Perhaps there should be a
> common tree struct and helpers defined either on top of list_head or a
> new struct if that saves some size.
> 
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> > v2->v3:
> >   Make sibling() and first_child() global so that they can be called
> >   out of kernel/resource.c to simplify code.
> 
> These should probably be inline functions. Or exported if not.
> 
> >
> >   Fix several code bugs found by kbuild test robot.
> >
> >   Got report from lkp that kernel size increased. It's on purpose since
> >   the type change of sibling and child inside struct resource{}. For
> >   each struct resource variable, it will cost another 16 bytes on x86 64.
> 
> The size increase should be mentioned in the commit log. More
> generally, the size increase is 2 pointers.

Tiny kernels have much fewer resources anyway, and usually run on 
platforms with 32-bit pointers, so this probably won't matter much in 
the end.

This is if reverse iteration is actually needed as you say though.
Unless I'm mistaken, resource iteration doesn't happen that often, and 
not in critical paths either.

Making the code clearer while keeping the same structure size could be 
considered with the help of llist.h instead.


Nicolas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
