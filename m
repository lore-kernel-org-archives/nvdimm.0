Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B0603209589F4
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 20:55:18 -0700 (PDT)
Received: from mail-vk0-f42.google.com (mail-vk0-f42.google.com
 [209.85.213.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9E7A32392A
 for <linux-nvdimm@lists.01.org>; Sat, 12 Aug 2017 03:57:39 +0000 (UTC)
Received: by mail-vk0-f42.google.com with SMTP id g189so19022585vke.5
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 20:57:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
 <20170805095013.GC14930@lst.de>
 <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
 <20170811104429.GA13736@lst.de>
 <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 11 Aug 2017 20:57:18 -0700
Message-ID: <CALCETrVvMbaxobdydtsdQWHyP1VhL1fpq1qS4M3=SmR1y4x5kw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 11, 2017 at 3:26 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Aug 11, 2017 at 3:44 AM, Christoph Hellwig <hch@lst.de> wrote:
>> Please explain how this interface allows for any sort of safe userspace
>> DMA.
>
> So this is where I continue to see S_IOMAP_IMMUTABLE being able to
> support applications that MAP_SYNC does not. Dave mentioned userspace
> pNFS4 servers, but there's also Samba and other protocols that want to
> negotiate a direct path to pmem outside the kernel. Xen support has
> thus far not been able to follow in the footsteps of KVM enabling due
> to a dependence on static M2P tables that assume a static
> guest-physical to host-physical relationship [1]. Immutable files
> would allow Xen to follow the same "mmap a file" semantic as KVM.

One thing that makes me quite nervous about S_IOMAP_IMMUTABLE is the
degree to which things go badly if one program relies on it while
another program clears the flag: you risk corrupting unrelated
filesystem metadata.  I think a userspace interface to pin the extent
mapping of a file really wants a way to reliably keep it pinned (or to
reliably zap the userspace application if it gets unpinned).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
