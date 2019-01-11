From: Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [PATCH v3 0/5] kvm "virtio pmem" device
Date: Fri, 11 Jan 2019 02:45:04 -0500 (EST)
Message-ID: <1326478078.61913951.1547192704870.JavaMail.zimbra@redhat.com>
References: <20190109144736.17452-1-pagupta@redhat.com> <20190110012617.GA4205@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190110012617.GA4205@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jack@suse.cz, stefanha@redhat.com, dan j williams <dan.j.williams@intel.com>, riel@surriel.com, nilal@redhat.com, kwolf@redhat.com, pbonzini@redhat.com, zwisler@kernel.org, vishal l verma <vishal.l.verma@intel.com>, dave jiang <dave.jiang@intel.com>, david@redhat.com, jmoyer@redhat.com, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, hch@infradead.org, mst@redhat.com, jasowang@redhat.com, lcapitulino@redhat.com, imammedo@redhat.com, eblake@redhat.com, willy@infradead.org, tytso@mit.edu, adilger kernel <adilger.>
List-Id: linux-nvdimm@lists.01.org


> 
> On Wed, Jan 09, 2019 at 08:17:31PM +0530, Pankaj Gupta wrote:
> >  This patch series has implementation for "virtio pmem".
> >  "virtio pmem" is fake persistent memory(nvdimm) in guest
> >  which allows to bypass the guest page cache. This also
> >  implements a VIRTIO based asynchronous flush mechanism.
> 
> Hmmmm. Sharing the host page cache direct into the guest VM. Sounds
> like a good idea, but.....
> 
> This means the guest VM can now run timing attacks to observe host
> side page cache residency, and depending on the implementation I'm
> guessing that the guest will be able to control host side page
> cache eviction, too (e.g. via discard or hole punch operations).

Not sure how? this is similar to mmapping virtual memory by any userspace 
process. Any host userspace process can do such attack on host page cache
using mincore & mmap shared file. 

But i don't think guest can do this alone. For virtio-pmem usecase guest 
won't be using page cache so timing attack from only guest side is not 
possible unless host userspace can run checks on page cache eviction state
using mincore etc. 

As rightly described by Rik, guest will only access its own page cache pages 
and if guest page cache is managed directly by host, this saves alot of 
effort for guest in transferring guest state of page cache.  

> 
> Which means this functionality looks to me like a new vector for
> information leakage into and out of the guest VM via guest
> controlled host page cache manipulation.
> 
> https://arxiv.org/pdf/1901.01161
> 
> I might be wrong, but if I'm not we're going to have to be very
> careful about how guest VMs can access and manipulate host side
> resources like the page cache.....

If I am following correctly the discussions in MM thread. 
Important steps to mitigate this:

* Avoid running mincore in privilege mode: to safeguard page evict state of any 
  page cache page.
* tweaking RWF_NOWAIT 

I think if we secure ways to find current state(cached/evicted) of a page in host, 
we should be able to mitigate the impact for any page cache page access attack 
including virtio-pmem.

Thanks,
Pankaj
