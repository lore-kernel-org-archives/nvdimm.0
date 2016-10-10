Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 391211A1E05
 for <linux-nvdimm@lists.01.org>; Mon, 10 Oct 2016 09:24:28 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id d132so133060439oib.2
 for <linux-nvdimm@lists.01.org>; Mon, 10 Oct 2016 09:24:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161010063215.24jukvont5ctansy@hz-desktop>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <CAPcyv4hu6oTwHiwbXjMgHJC_uKpr=Aq5SDcg76W=rd0R3-b08w@mail.gmail.com>
 <20161010063215.24jukvont5ctansy@hz-desktop>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Oct 2016 09:24:26 -0700
Message-ID: <CAPcyv4hnjJmgThrTBo+6N-FbsFycEEjoXjXW+UmGd_9dhXnjNQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, xen-devel@lists.xenproject.org, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>, Juergen Gross <jgross@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Thumshirn <jthumshirn@suse.de>, Arnd Bergmann <arnd@arndb.de>, Stefano Stabellini <stefano@aporeto.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Oct 9, 2016 at 11:32 PM, Haozhong Zhang
<haozhong.zhang@intel.com> wrote:
> On 10/09/16 20:45, Dan Williams wrote:
>> On Sun, Oct 9, 2016 at 5:35 PM, Haozhong Zhang <haozhong.zhang@intel.com> wrote:
>> > Overview
>> > ========
>> > This RFC kernel patch series along with corresponding patch series of
>> > Xen, QEMU and ndctl implements Xen vNVDIMM, which can map the host
>> > NVDIMM devices to Xen HVM domU as vNVDIMM devices.
>> >
>> > Xen hypervisor does not include an NVDIMM driver, so it needs the
>> > assistance from the driver in Dom0 Linux kernel to manage NVDIMM
>> > devices. We currently only supports NVDIMM devices in pmem mode.
>> >
>> > Design and Implementation
>> > =========================
>> > The complete design can be found at
>> >   https://lists.xenproject.org/archives/html/xen-devel/2016-07/msg01921.html.
>>
>> The KVM enabling for persistent memory does not need this support from
>> the kernel, and as far as I can see neither does Xen. If the
>> hypervisor needs to reserve some space it can simply trim the amount
>> that it hands to the guest.
>>
>
> Xen does not have the NVDIMM driver, so it cannot operate on NVDIMM
> devices by itself. Instead it relies on the driver in Dom0 Linux to
> probe NVDIMM and make the reservation.

I'm missing something because the design document talks about mmap'ing
files on a DAX filesystem.  So, I'm assuming it is similar to the KVM
NVDIMM virtualization case where an mmap range in dom0 is translated
into a guest physical range.  The suggestion is to reserve some memory
out of that mapping rather than introduce a new info block /
reservation type to the sub-system.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
