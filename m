Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E683C81E1F
 for <linux-nvdimm@lists.01.org>; Tue, 22 Nov 2016 12:10:44 -0800 (PST)
Received: by mail-oi0-x242.google.com with SMTP id f201so4384859oib.0
 for <linux-nvdimm@lists.01.org>; Tue, 22 Nov 2016 12:10:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4htu4gayz_Dpe0pnfLN4v_Kcy-fTx3B-HEfadCHvzJnhA@mail.gmail.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <CAPcyv4htu4gayz_Dpe0pnfLN4v_Kcy-fTx3B-HEfadCHvzJnhA@mail.gmail.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Tue, 22 Nov 2016 21:10:43 +0100
Message-ID: <CAKMK7uGoXAYoazyGLbGU7svVD10WmaBtpko8BpHeNpRhST8F7g@mail.gmail.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "Blinzer, Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, Suravee, Alexander, "Christian  <Christian.Koenig@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 22, 2016 at 9:01 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Nov 22, 2016 at 10:59 AM, Serguei Sagalovitch
> <serguei.sagalovitch@amd.com> wrote:
>> I personally like "device-DAX" idea but my concerns are:
>>
>> -  How well it will co-exists with the  DRM infrastructure / implementations
>>    in part dealing with CPU pointers?
>
> Inside the kernel a device-DAX range is "just memory" in the sense
> that you can perform pfn_to_page() on it and issue I/O, but the vma is
> not migratable. To be honest I do not know how well that co-exists
> with drm infrastructure.
>
>> -  How well we will be able to handle case when we need to "move"/"evict"
>>    memory/data to the new location so CPU pointer should point to the new
>> physical location/address
>>     (and may be not in PCI device memory at all)?
>
> So, device-DAX deliberately avoids support for in-kernel migration or
> overcommit. Those cases are left to the core mm or drm. The device-dax
> interface is for cases where all that is needed is a direct-mapping to
> a statically-allocated physical-address range be it persistent memory
> or some other special reserved memory range.

For some of the fancy use-cases (e.g. to be comparable to what HMM can
pull off) I think we want all the magic in core mm, i.e. migration and
overcommit. At least that seems to be the very strong drive in all
general-purpose gpu abstractions and implementations, where memory is
allocated with malloc, and then mapped/moved into vram/gpu address
space through some magic, but still visible on both the cpu and gpu
side in some form. Special device to allocate memory, and not being
able to migrate stuff around sound like misfeatures from that pov.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
