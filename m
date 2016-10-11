Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8AD4E1A1E6F
 for <linux-nvdimm@lists.01.org>; Tue, 11 Oct 2016 00:11:51 -0700 (PDT)
Date: Tue, 11 Oct 2016 15:11:47 +0800
From: Haozhong Zhang <haozhong.zhang@intel.com>
Subject: Re: [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
Message-ID: <20161011071147.wkwc6ktow3sf2mzk@hz-desktop>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <CAPcyv4hu6oTwHiwbXjMgHJC_uKpr=Aq5SDcg76W=rd0R3-b08w@mail.gmail.com>
 <20161010063215.24jukvont5ctansy@hz-desktop>
 <CAPcyv4hnjJmgThrTBo+6N-FbsFycEEjoXjXW+UmGd_9dhXnjNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hnjJmgThrTBo+6N-FbsFycEEjoXjXW+UmGd_9dhXnjNQ@mail.gmail.com>
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
Cc: Juergen Gross <jgross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Andrew Cooper <andrew.cooper3@citrix.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On 10/10/16 09:24, Dan Williams wrote:
> On Sun, Oct 9, 2016 at 11:32 PM, Haozhong Zhang
> <haozhong.zhang@intel.com> wrote:
> > On 10/09/16 20:45, Dan Williams wrote:
> >> On Sun, Oct 9, 2016 at 5:35 PM, Haozhong Zhang <haozhong.zhang@intel.com> wrote:
> >> > Overview
> >> > ========
> >> > This RFC kernel patch series along with corresponding patch series of
> >> > Xen, QEMU and ndctl implements Xen vNVDIMM, which can map the host
> >> > NVDIMM devices to Xen HVM domU as vNVDIMM devices.
> >> >
> >> > Xen hypervisor does not include an NVDIMM driver, so it needs the
> >> > assistance from the driver in Dom0 Linux kernel to manage NVDIMM
> >> > devices. We currently only supports NVDIMM devices in pmem mode.
> >> >
> >> > Design and Implementation
> >> > =========================
> >> > The complete design can be found at
> >> >   https://lists.xenproject.org/archives/html/xen-devel/2016-07/msg01921.html.
> >>
> >> The KVM enabling for persistent memory does not need this support from
> >> the kernel, and as far as I can see neither does Xen. If the
> >> hypervisor needs to reserve some space it can simply trim the amount
> >> that it hands to the guest.
> >>
> >
> > Xen does not have the NVDIMM driver, so it cannot operate on NVDIMM
> > devices by itself. Instead it relies on the driver in Dom0 Linux to
> > probe NVDIMM and make the reservation.
> 
> I'm missing something because the design document talks about mmap'ing
> files on a DAX filesystem.  So, I'm assuming it is similar to the KVM
> NVDIMM virtualization case where an mmap range in dom0 is translated
> into a guest physical range.  The suggestion is to reserve some memory
> out of that mapping rather than introduce a new info block /
> reservation type to the sub-system.

Just like struct page to linux, Xen hypervisor uses a struct page_info
for its memory management. We are facing the same problem as linux
kernel: where we store those structs for pmem, and decided to put them
on a reserved area on pmem, similar to what pfn device in kernel does.

Reserving at the moment of mmap and out of what is mapped does not
work. It's a bootstrap problem: Xen needs the information of those
pages, which are stored in struct page_info, at the moment of
mapping. That is, page_info structs for pmem pages should be prepared
before those pages are actually used.

However, as the ongoing discussion in another thread with Andrew
Cooper, if Xen hypervisor turns to treat pmem pages as MMIO, then the
reservation may not be needed. Let's see what conclusion will be
reached there.

Thanks,
Haozhong
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
