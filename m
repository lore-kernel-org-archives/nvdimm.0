From: Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v2 0/2] kvm "fake DAX" device
Date: Sat, 13 Oct 2018 12:29:12 -0400 (EDT)
Message-ID: <2107404743.20781403.1539448152851.JavaMail.zimbra@redhat.com>
References: <20181013050021.11962-1-pagupta@redhat.com> <CAPcyv4gEVxoNFUmFctSR6nRku_Pcz2GfXB+-iHBARmc+Wa+dfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gEVxoNFUmFctSR6nRku_Pcz2GfXB+-iHBARmc+Wa+dfQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Jan Kara <jack@suse.cz>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, KVM list <kvm@vger.kernel.org>, Rik van Riel <riel@surriel.com>, linux-nvdimm <linux-nvdimm@ml01.01.org>, David Hildenbrand <david@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Christoph Hellwig <hch@infradead.org>, Vishal L Verma <vishal.l.verma@intel.com>, Igor Mammedov <imammedo@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, zwisler@kernel.org, lcapitulino@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-Id: linux-nvdimm@lists.01.org


> >
> >  This patch series has implementation for "fake DAX".
> >  "fake DAX" is fake persistent memory(nvdimm) in guest
> >  which allows to bypass the guest page cache. This also
> >  implements a VIRTIO based asynchronous flush mechanism.
> 
> Can we stop calling this 'fake DAX', because it isn't 'DAX' and it's
> starting to confuse people. This enabling is effectively a
> host-page-cache-passthrough mechanism not DAX. Let's call the whole
> approach virtio-pmem, and leave DAX out of the name to hopefully
> prevent people from wondering why some DAX features are disabled with
> this driver. For example MAP_SYNC is not compatible with this
> approach.

Sure. I got your point. I will use "virtio-pmem" in future.  

> 
> Additional enabling is need to disable MAP_SYNC in the presence of a
> virtio-pmem device. See the rough proposal here:
> 
>     https://lkml.org/lkml/2018/4/25/756

Yes, I will handle disabling of MAP_SYNC for this use-case.


Thanks,
Pankaj
