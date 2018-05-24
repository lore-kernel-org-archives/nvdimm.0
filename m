Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A8D12203B8CCD
 for <linux-nvdimm@lists.01.org>; Thu, 24 May 2018 00:20:24 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id F2805AC0149
 for <linux-nvdimm@lists.01.org>; Thu, 24 May 2018 16:20:17 +0900 (JST)
Date: Thu, 24 May 2018 16:19:27 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: Questions about vNVDIMM on qemu/KVM
In-Reply-To: <CAPcyv4g3pMV54bYwOOeMiFbi2swi5v9RTrBh8-_mtGpoOiw5XQ@mail.gmail.com>
References: <20180523140809.622F.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4g3pMV54bYwOOeMiFbi2swi5v9RTrBh8-_mtGpoOiw5XQ@mail.gmail.com>
Message-Id: <20180524161922.EC59.E1E9C6FF@jp.fujitsu.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Qemu Developers <qemu-devel@nongnu.org>, NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Tue, May 22, 2018 at 10:08 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> > Hello,
> >
> > I'm investigating status of vNVDIMM on qemu/KVM,
> > and I have some questions about it. I'm glad if anyone answer them.
> >
> > In my understanding, qemu/KVM has a feature to show NFIT for guest,
> > and it will be still updated about platform capability with this patch set.
> > https://lists.gnu.org/archive/html/qemu-devel/2018-05/msg04756.html
> >
> > And libvirt also supports this feature with <memory model='nvdimm'>
> > https://libvirt.org/formatdomain.html#elementsMemory
> >
> >
> > However, virtio-pmem is developing now, and it is better
> > for archtectures to detect regions of NVDIMM without ACPI (like s390x)
> 
> I think you are confusing virtio-pmem (patches from Pankaj) and
> virtio-mem (patches from David)? ...or I'm confused.

Probably, "I" am confusing.
So, your clarification is very helpful for me.


> 
> > In addition, It is also necessary to flush guest contents on vNVDIMM
> > who has a backend-file.
> 
> virtio-pmem is a mechanism to use host page cache as pmem in a guest.
> It does not support high performance memory applications because it
> requires fsync/msync. I.e. it is not DAX it is the traditional mmap
> I/O model, but moving page cache management to the host rather than
> duplicating it in guests.

Ah, ok.


> 
> > Q1) Does ACPI.NFIT bus of qemu/kvm remain with virtio-pmem?
> >     How do each roles become it if both NFIT and virtio-pmem will be available?
> >     If my understanding is correct, both NFIT and virtio-pmem is used to
> >     detect vNVDIMM regions, but only one seems to be necessary....
> 
> We need both because they are different. Guest DAX should not be using
> virtio-pmem.

Hmm. Ok.

But ,I would like understand one more thing.
In the following mail, it seems that e820 bus will be used for fake DAX.

https://lists.01.org/pipermail/linux-nvdimm/2018-January/013926.html

Could you tell me what is relationship between "fake DAX" in this mail
and Guest DAX? 
Why e820 is necessary for this case?

(Probably, it may be one of the reason why I'm confusing....)


> 
> >     Otherwize, is the NFIT bus just for keeping compatibility,
> >     and virtio-pmem is promising way?
> >
> >
> > Q2) What bus is(will be?) created for virtio-pmem?
> >     I could confirm the bus of NFIT is created with <memory model='nvdimm'>,
> >     and I heard other bus will be created for virtio-pmem, but I could not
> >     find what bus is created concretely.
> >     ---
> >       # ndctl list -B
> >       {
> >          "provider":"ACPI.NFIT",
> >          "dev":"ndbus0"
> >       }
> >     ---
> >
> >     I think it affects what operations user will be able to, and what
> >     notification is necessary for vNVDIMM.
> >     ACPI defines some operations like namespace controll, and notification
> >     for NVDIMM health status or others.
> >     (I suppose that other status notification might be necessary for vNVDIMM,
> >      but I'm not sure yet...)
> >
> > If my understanding is wrong, please correct me.
> 
> The current plan, per my understanding, is a virtio-pmem SPA UUID
> added to the virtual NFIT so that the guest driver can load the pmem
> driver but also hook up the virtio command ring for forwarding
> WRITE_{FUA,FLUSH} commands as host fsync operations.

Ok.

Thank you very much for your answer!

---
Yasunori Goto



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
