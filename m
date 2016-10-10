Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from SMTP.EU.CITRIX.COM (smtp.eu.citrix.com [185.25.65.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 183241A1E29
 for <linux-nvdimm@lists.01.org>; Mon, 10 Oct 2016 09:43:30 -0700 (PDT)
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
From: Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com>
Date: Mon, 10 Oct 2016 17:43:10 +0100
MIME-Version: 1.0
In-Reply-To: <20161010003523.4423-1-haozhong.zhang@intel.com>
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
To: Haozhong Zhang <haozhong.zhang@intel.com>, linux-nvdimm@lists.01.org, xen-devel@lists.xenproject.org
Cc: Juergen Gross <jgross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-kernel@vger.kernel.org, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 10/10/16 01:35, Haozhong Zhang wrote:
> Overview
> ========
> This RFC kernel patch series along with corresponding patch series of
> Xen, QEMU and ndctl implements Xen vNVDIMM, which can map the host
> NVDIMM devices to Xen HVM domU as vNVDIMM devices.
>
> Xen hypervisor does not include an NVDIMM driver, so it needs the
> assistance from the driver in Dom0 Linux kernel to manage NVDIMM
> devices. We currently only supports NVDIMM devices in pmem mode.
>
> Design and Implementation
> =========================
> The complete design can be found at
>   https://lists.xenproject.org/archives/html/xen-devel/2016-07/msg01921.html.
>
> All patch series can be found at
>   Xen:          https://github.com/hzzhan9/xen.git nvdimm-rfc-v1
>   QEMU:         https://github.com/hzzhan9/qemu.git xen-nvdimm-rfc-v1
>   Linux kernel: https://github.com/hzzhan9/nvdimm.git xen-nvdimm-rfc-v1
>   ndctl:        https://github.com/hzzhan9/ndctl.git pfn-xen-rfc-v1
>
> Xen hypervisor needs assistance from Dom0 Linux kernel for following tasks:
> 1) Reserve an area on NVDIMM devices for Xen hypervisor to place
>    memory management data structures, i.e. frame table and M2P table.
> 2) Report SPA ranges of NVDIMM devices and the reserved area to Xen
>    hypervisor.

Please can we take a step back here before diving down a rabbit hole.


How do pblk/pmem regions appear in the E820 map at boot?  At the very
least, I would expect at least a large reserved region.

Is the MFN information (SPA in your terminology, so far as I can tell)
available in any static APCI tables, or are they only available as a
result of executing AML methods?


If the MFN information is only available via AML, then point 2) is
needed, although the reporting back to Xen should be restricted to a xen
component, rather than polluting the main device driver.

However, I can't see any justification for 1).  Dom0 should not be
involved in Xen's management of its own frame table and m2p.  The mfns
making up the pmem/pblk regions should be treated just like any other
MMIO regions, and be handed wholesale to dom0 by default.

~Andrew
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
