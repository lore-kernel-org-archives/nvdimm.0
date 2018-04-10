Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 68CB5226516CD
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 19:10:51 -0700 (PDT)
Date: Tue, 10 Apr 2018 10:10:43 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v3 1/3] resource: Use list_head to link resource sibling
Message-ID: <20180410021043.GC25724@localhost.localdomain>
References: <20180408024724.16812-1-bhe@redhat.com>
 <20180408024724.16812-2-bhe@redhat.com>
 <20180409090853.GJ19345@localhost.localdomain>
 <CAPcyv4huU32+oMeoF8-HmmctafZ_uOZN-v85O5M8Ka8pBXP+Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4huU32+oMeoF8-HmmctafZ_uOZN-v85O5M8Ka8pBXP+Lg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>, Device Tree <devicetree@vger.kernel.org>, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>, Keith Busch <keith.busch@intel.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input@vger.kernel.org, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Jonathan Derrick <jonathan.derrick@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org
List-ID: <linux-nvdimm@lists.01.org>

On 04/09/18 at 08:38am, Dan Williams wrote:
> On Mon, Apr 9, 2018 at 2:08 AM, Baoquan He <bhe@redhat.com> wrote:
> > The struct resource uses singly linked list to link siblings. It's not
> > easy to do reverse iteration on sibling list. So replace it with list_head.
> >
> > And code refactoring makes codes in kernel/resource.c more readable than
> > pointer operation.
> >
> > Besides, type of member variables of struct resource, sibling and child, are
> > changed from 'struct resource *' to 'struct list_head'. Kernel size will
> > increase because of those statically defined struct resource instances.
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> [..]
> > diff --git a/kernel/resource.c b/kernel/resource.c
> > index e270b5048988..473c624606f9 100644
> > --- a/kernel/resource.c
> > +++ b/kernel/resource.c
> > @@ -31,6 +31,8 @@ struct resource ioport_resource = {
> >         .start  = 0,
> >         .end    = IO_SPACE_LIMIT,
> >         .flags  = IORESOURCE_IO,
> > +       .sibling = LIST_HEAD_INIT(ioport_resource.sibling),
> > +       .child  = LIST_HEAD_INIT(ioport_resource.child),
> >  };
> >  EXPORT_SYMBOL(ioport_resource);
> >
> > @@ -39,6 +41,8 @@ struct resource iomem_resource = {
> >         .start  = 0,
> >         .end    = -1,
> >         .flags  = IORESOURCE_MEM,
> > +       .sibling = LIST_HEAD_INIT(iomem_resource.sibling),
> > +       .child  = LIST_HEAD_INIT(iomem_resource.child),
> >  };
> >  EXPORT_SYMBOL(iomem_resource);
> >
> > @@ -57,20 +61,32 @@ static DEFINE_RWLOCK(resource_lock);
> >   * by boot mem after the system is up. So for reusing the resource entry
> >   * we need to remember the resource.
> >   */
> > -static struct resource *bootmem_resource_free;
> > +static struct list_head bootmem_resource_free = LIST_HEAD_INIT(bootmem_resource_free);
> >  static DEFINE_SPINLOCK(bootmem_resource_lock);
> >
> > +struct resource *sibling(struct resource *res)
> > +{
> > +       if (res->parent && !list_is_last(&res->sibling, &res->parent->child))
> > +               return list_next_entry(res, sibling);
> > +       return NULL;
> > +}
> > +
> > +struct resource *first_child(struct list_head *head)
> > +{
> > +       return list_first_entry_or_null(head, struct resource, sibling);
> > +}
> > +
> 
> These names are too generic for new global symbols. A "resource_"
> prefix is warranted.

Thanks, sounds reasonable, will change them as resource_sibling() and
resource_first_child(). Or res_sibling()/res_1st_child()?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
