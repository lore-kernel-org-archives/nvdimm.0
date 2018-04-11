Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 527A422618154
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 20:22:28 -0700 (PDT)
Received: by mail-pf0-x242.google.com with SMTP id p15so258684pff.11
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 20:22:28 -0700 (PDT)
Date: Wed, 11 Apr 2018 11:22:20 +0800
From: Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH v3 1/3] resource: Use list_head to link resource sibling
Message-ID: <20180411032220.GA49071@WeideMacBook-Pro.local>
References: <20180408024724.16812-1-bhe@redhat.com>
 <20180408024724.16812-2-bhe@redhat.com>
 <20180409090853.GJ19345@localhost.localdomain>
 <CAL_Jsq+xxa9ep2LK3H6YWhwrZtc-T73Y84ry6Hs-JJ3XEXoGsw@mail.gmail.com>
 <20180410134416.GM19345@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180410134416.GM19345@localhost.localdomain>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Baoquan He <bhe@redhat.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>, devicetree@vger.kernel.org, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>, Keith Busch <keith.busch@intel.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, Nicolas Pitre <nico@linaro.org>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input@vger.kernel.org, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, linux-nvdimm@lists.01.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 10, 2018 at 09:44:16PM +0800, Baoquan He wrote:
>Hi Rob,
>
>Thanks a lot for looking into this and involve Nico to this thread!
>
>On 04/09/18 at 09:49am, Rob Herring wrote:
>> +Nico who has been working on tinification of the kernel.
>> 
>> On Mon, Apr 9, 2018 at 4:08 AM, Baoquan He <bhe@redhat.com> wrote:
>> > The struct resource uses singly linked list to link siblings. It's not
>> > easy to do reverse iteration on sibling list. So replace it with list_head.
>> 
>> Why is reverse iteration needed?
>
>This is the explanation I made when Andrew helped to review the v1 post:
>https://lkml.org/lkml/2018/3/23/78
>
>Because we have been using kexec-tools utility to search available
>System RAM space for loading kernel/initrd/purgatory from top to down.
>That is done in user space by searching /proc/iomem. While later added
>kexec_file interface, the searching code happened in kernel, and it
>only search System RAM region bottom up, then take an area in that found
>RAM region from top to down. We need unify these two interfaces on
>behaviour since they are the same on essense from the users' point of
>view, though implementation is different. As you know, the singly linked
>list implementation of the current resource's sibling linking, makes the
>searching from top to down very hard to satisfy people. 
>
>Below is the v1 post, we make an temporary array to copy iomem_resource's
>first level of children, then iterate the array reversedly. Andrew
>suggested me to try list_head after reviewing. In fact we can optimize
>that patch to only copy resource pointer into array, still the way is
>ugly.
>https://lkml.org/lkml/2018/3/21/952
>
>Then Wei pasted a patch he had made as below. He didn't mention if he
>also has requirement on reversed iteration of resource. That is an O(n*n)
>way, from personal feelings, hard to say if it's bettern than v1 post.
>https://lkml.org/lkml/2018/3/24/157

I don't have requirement on reverse iteration of resource structure.

My approach is almost the same as current walk_system_ram_res(). Since each
resource keeps parent, we could get previous resource by search on
res->parent->child.

The complexity of a whole iteration is O(N * W / 2), where N is the number of
resources in the tree and W is the average number of siblings of each
resource.

And this approach doesn't need to change current structure.

>
>That's why I would like to have a try of the list_head linking.
>

-- 
Wei Yang
Help you, Help me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
