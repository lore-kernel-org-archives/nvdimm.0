Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 15C132126CF94
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 13:46:20 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id n14so1368883otk.2
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 13:46:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190514145422.16923-1-pagupta@redhat.com>
 <20190514145422.16923-3-pagupta@redhat.com>
 <c22d42f6-ef94-0310-36f2-e9085d3464c2@infradead.org>
 <1112624345.28705248.1557847520326.JavaMail.zimbra@redhat.com>
In-Reply-To: <1112624345.28705248.1557847520326.JavaMail.zimbra@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 May 2019 13:46:08 -0700
Message-ID: <CAPcyv4iK1ivHkdw3JQV1wVLeLi0TA++VgKDZvYjPGo_i1j_pbA@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH v9 2/7] virtio-pmem: Add virtio pmem driver
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
Cc: cohuck@redhat.com, Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, jstaron@google.com, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Len Brown <lenb@kernel.org>, Adam Borowski <kilobyte@angband.pl>, Rik van Riel <riel@surriel.com>, yuval shaia <yuval.shaia@oracle.com>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, darrick wong <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 14, 2019 at 8:25 AM Pankaj Gupta <pagupta@redhat.com> wrote:
>
>
> > On 5/14/19 7:54 AM, Pankaj Gupta wrote:
> > > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > > index 35897649c24f..94bad084ebab 100644
> > > --- a/drivers/virtio/Kconfig
> > > +++ b/drivers/virtio/Kconfig
> > > @@ -42,6 +42,17 @@ config VIRTIO_PCI_LEGACY
> > >
> > >       If unsure, say Y.
> > >
> > > +config VIRTIO_PMEM
> > > +   tristate "Support for virtio pmem driver"
> > > +   depends on VIRTIO
> > > +   depends on LIBNVDIMM
> > > +   help
> > > +   This driver provides access to virtio-pmem devices, storage devices
> > > +   that are mapped into the physical address space - similar to NVDIMMs
> > > +    - with a virtio-based flushing interface.
> > > +
> > > +   If unsure, say M.
> >
> > <beep>
> > from Documentation/process/coding-style.rst:
> > "Lines under a ``config`` definition
> > are indented with one tab, while help text is indented an additional two
> > spaces."
>
> ah... I changed help text and 'checkpatch' did not say anything :( .
>
> Will wait for Dan, If its possible to add two spaces to help text while applying
> the series.

I'm inclined to handle this with a fixup appended to the end of the
series just so the patchwork-bot does not get confused by the content
changing from what was sent to the list.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
