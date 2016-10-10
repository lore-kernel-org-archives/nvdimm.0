Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 340A31A1E34
 for <linux-nvdimm@lists.01.org>; Sun,  9 Oct 2016 20:45:41 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id m72so114693490oik.3
 for <linux-nvdimm@lists.01.org>; Sun, 09 Oct 2016 20:45:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161010003523.4423-1-haozhong.zhang@intel.com>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 9 Oct 2016 20:45:39 -0700
Message-ID: <CAPcyv4hu6oTwHiwbXjMgHJC_uKpr=Aq5SDcg76W=rd0R3-b08w@mail.gmail.com>
Subject: Re: [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
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
To: Haozhong Zhang <haozhong.zhang@intel.com>
Cc: Juergen Gross <jgross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Oct 9, 2016 at 5:35 PM, Haozhong Zhang <haozhong.zhang@intel.com> wrote:
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

The KVM enabling for persistent memory does not need this support from
the kernel, and as far as I can see neither does Xen. If the
hypervisor needs to reserve some space it can simply trim the amount
that it hands to the guest.

The usage of fiemap and the sysfs resource for the pmem device, as
mentioned in the design document, does not seem to comprehend that
file block allocations may be discontiguous and may change over time
depending on the file.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
