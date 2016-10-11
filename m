Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4583C1A1E89
 for <linux-nvdimm@lists.01.org>; Tue, 11 Oct 2016 08:53:35 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id d132so28466487oib.2
 for <linux-nvdimm@lists.01.org>; Tue, 11 Oct 2016 08:53:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com>
 <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Oct 2016 08:53:33 -0700
Message-ID: <CAPcyv4gD3JTq93ET0SAYOxyPO9c0RTkPKSQKqZLo_8KPn53TiA@mail.gmail.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
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
To: Jan Beulich <jbeulich@suse.com>
Cc: Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, andrew.cooper3@citrix.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 11, 2016 at 6:08 AM, Jan Beulich <jbeulich@suse.com> wrote:
>>>> Andrew Cooper <andrew.cooper3@citrix.com> 10/10/16 6:44 PM >>>
>>On 10/10/16 01:35, Haozhong Zhang wrote:
>>> Xen hypervisor needs assistance from Dom0 Linux kernel for following tasks:
>>> 1) Reserve an area on NVDIMM devices for Xen hypervisor to place
>>>    memory management data structures, i.e. frame table and M2P table.
>>> 2) Report SPA ranges of NVDIMM devices and the reserved area to Xen
>>>    hypervisor.
>>
>>However, I can't see any justification for 1).  Dom0 should not be
>>involved in Xen's management of its own frame table and m2p.  The mfns
>>making up the pmem/pblk regions should be treated just like any other
>>MMIO regions, and be handed wholesale to dom0 by default.
>
> That precludes the use as RAM extension, and I thought earlier rounds of
> discussion had got everyone in agreement that at least for the pmem case
> we will need some control data in Xen.

The missing piece for me is why this reservation for control data
needs to be done in the libnvdimm core?  I would expect that any dax
capable file could be mapped and made available to a guest.  This
includes /dev/ramX devices that are dax capable, but are external to
the libnvdimm sub-system.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
