Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com
 [IPv6:2607:f8b0:4864:20::333])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC6EE201B041C
 for <linux-nvdimm@lists.01.org>; Tue, 19 Feb 2019 10:49:51 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id v62so27156248otb.3
 for <linux-nvdimm@lists.01.org>; Tue, 19 Feb 2019 10:49:51 -0800 (PST)
MIME-Version: 1.0
References: <729515484.1572396.1550250571940.ref@mail.yahoo.com>
 <729515484.1572396.1550250571940@mail.yahoo.com>
 <1924469947.1654149.1550596909762@mail.yahoo.com>
In-Reply-To: <1924469947.1654149.1550596909762@mail.yahoo.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Feb 2019 10:49:39 -0800
Message-ID: <CAPcyv4h+4aKQdfXpcF5H5=Zv653EjEFv5=J2Vzt9Qbp3DUaW4Q@mail.gmail.com>
Subject: Re: Fw: Why only devdax guarantees guest data persistence ?
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
To: "bipin.tomar@yahoo.com" <bipin.tomar@yahoo.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 19, 2019 at 9:22 AM bipin.tomar@yahoo.com
<bipin.tomar@yahoo.com> wrote:
>
>  I haven't heard from anyone on qemu-devel. There are a lot of vNVDIMM experts here and I'm hoping that someone here may throw some light.

Answers inline below:

>    ----- Forwarded Message ----- From: bipin.tomar@yahoo.com <bipin.tomar@yahoo.com>To: qemu-devel@nongnu.org <qemu-devel@nongnu.org>Sent: Friday, February 15, 2019, 12:09:31 PM ESTSubject: Why only devdax guarantees guest data persistence ?
>  Text from "docs/nvdimm.txt" says:
> Guest Data Persistence
> ----------------------
>
> Though QEMU supports multiple types of vNVDIMM backends on Linux,
> currently the only one that can guarantee the guest write persistence
> is the device DAX on the real NVDIMM device (e.g., /dev/dax0.0), to
> which all guest access do not involve any host-side kernel cache.
>
> I think here "host-side kernel cache" imply "page cache". Why does fsdax NOT have the same persistence guarantees as devdax for vNVDIMM?
> Both the modes avoid using page cache then why is devdax explicitly called out?

As long as the mapping is established with the MAP_SYNC facility then
the persistence guarantees are the same as the host. You may be
thinking of the pre-MAP_SYNC days where there was no facility to
coordinate the synchronization of host metadata.

I will note that device-passthrough is disabled for fsdax because
there is no facility to coordinate host truncation events vs
guest-device-initiated DMA, but that's a separate issue from
persistence guarantees. VFIO will simply fail to register devices in
this case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
