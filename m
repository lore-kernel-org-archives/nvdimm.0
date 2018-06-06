Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F041210F154B
 for <linux-nvdimm@lists.01.org>; Tue,  5 Jun 2018 18:45:19 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id B3D49AC00A2
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 10:45:13 +0900 (JST)
Date: Wed, 06 Jun 2018 10:44:45 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [Qemu-devel] Questions about vNVDIMM on qemu/KVM
In-Reply-To: <120916025.39666078.1528099386072.JavaMail.zimbra@redhat.com>
References: <20180601115429.GL8687@stefanha-x1.localdomain>
 <120916025.39666078.1528099386072.JavaMail.zimbra@redhat.com>
Message-Id: <20180606104437.40CE.E1E9C6FF@jp.fujitsu.com>
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
To: Pankaj Gupta <pagupta@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, NVDIMM-ML <linux-nvdimm@lists.01.org>, qemu-devel@nongnu.org, Luiz Capitulino <lcapitulino@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

> Hi,
>  
> > 
> > > I'm investigating status of vNVDIMM on qemu/KVM,
> > > and I have some questions about it. I'm glad if anyone answer them.
> > > 
> > > In my understanding, qemu/KVM has a feature to show NFIT for guest,
> > > and it will be still updated about platform capability with this patch set.
> > > https://lists.gnu.org/archive/html/qemu-devel/2018-05/msg04756.html
> > > 
> > > And libvirt also supports this feature with <memory model='nvdimm'>
> > > https://libvirt.org/formatdomain.html#elementsMemory
> > > 
> > > 
> > > However, virtio-pmem is developing now, and it is better
> > > for archtectures to detect regions of NVDIMM without ACPI (like s390x)
> > > In addition, It is also necessary to flush guest contents on vNVDIMM
> > > who has a backend-file.
> > > 
> > > 
> > > Q1) Does ACPI.NFIT bus of qemu/kvm remain with virtio-pmem?
>         No.
> 
> > >     How do each roles become it if both NFIT and virtio-pmem will be
> > >     available?
> 
>         There are two main use cases:
> 
>         1] DAX memory region pass-through to guest:
>         -------------------------------------------
>         As this region is present in actual physical NVDIMM device and exposed to guest,
>         ACPI/NFIT way is used. If all the persistent memory is used by only this way we 
>         don't need 'virtio-pmem'.
> 
>         2] Emulated DAX memory region in host passed to guest:
>         --------------------------------------------------------
>         If this type of region is exposed to guest, it will be preferable to use
>         'virtio-pmem'. 
> 
>         This is regular host memory which is mmaped in guest address space for emulating 
>         persistent memory. Guest writes are present in host page cache and not assured to be 
>         written on backing disk without an explicit flush/sync call.
>  
>         'virtio-pmem' will solve the problem of flushing guest writes present in host page cache.
>         With filesystems at host which use journal-ling like (ext4, xfs), they automatically call 
>         'fsync' at regular intervals. but still there is not 100% assurance of all write persistence until
>         an explicit flush is done from guest. So, we need an additional fsync to flush guest writes to 
>         backing disk. We are using this approach to avoid using guest page cache and keep page cache management 
>         of all the guests at host side.
>         
>         If both ACPI NFIT and virtio-pmem are present, both will have their corresponding memory regions and 
>         defined by memory type "Persistent shared Memory" in case of virtio-pmem and "Persistent Memory" for 
>         ACPI NVDIMM. This is to differentiate both the memory types.

Ok.

> 
> > >     If my understanding is correct, both NFIT and virtio-pmem is used to
> > >     detect vNVDIMM regions, but only one seems to be necessary....
> > > 
> > >     Otherwize, is the NFIT bus just for keeping compatibility,
> > >     and virtio-pmem is promising way?
> > > 
> > >     
> > > Q2) What bus is(will be?) created for virtio-pmem?
> > >     I could confirm the bus of NFIT is created with <memory
> > >     model='nvdimm'>,
> 
>         For virtio-pmem also its nvdimm bus.
> 
> > >     and I heard other bus will be created for virtio-pmem, but I could not
> > >     find what bus is created concretely.
> > >     ---
> > >       # ndctl list -B
> > >       {
> > >          "provider":"ACPI.NFIT",
> > >          "dev":"ndbus0"
> > >       }
> > >     ---
> > >    
> > >     I think it affects what operations user will be able to, and what
> > >     notification is necessary for vNVDIMM.
> > >     ACPI defines some operations like namespace controll, and notification
> > >     for NVDIMM health status or others.
> > >     (I suppose that other status notification might be necessary for
> > >     vNVDIMM,
> > >      but I'm not sure yet...)
> 
>          For virtio-pmem, we are not providing advance features like namespace and various
>          other features which ACPI/NVDIMM hardware provides. This is just to keep paravirt
>          device simple.

Hmm, I see.
Thank you for your explanation.

Bye.
---
Yasunori Goto


> 
>          Moreover I have not yet looked at ndctl side of things. I am not 100% sure how
>          ndctl will handle 'virtio-pmem'.
> 
>         Adding 'Dan' in loop, he can add his thoughts.
> 
> Thanks,
> Pankaj
> 


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
