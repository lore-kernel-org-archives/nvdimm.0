From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: security implications of caching with virtio pmem (was Re:
 [PATCH v3 0/5] kvm "virtio pmem" device)
Date: Wed, 6 Feb 2019 13:01:36 -0500
Message-ID: <20190206125535-mutt-send-email-mst@kernel.org>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <20190204170515-mutt-send-email-mst@kernel.org>
 <5b8a06a7-be44-698f-f319-6b2cbcf1eb8a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5b8a06a7-be44-698f-f319-6b2cbcf1eb8a@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Hildenbrand <david@redhat.com>
Cc: Pankaj Gupta <pagupta@redhat.com>, jack@suse.cz, kvm@vger.kernel.org, linux-nvdimm@ml01.01.org, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger.kernel@dilger.ca, zwisler@kernel.org, eblake@redhat.com, Andrea Arcangeli <aarcange@redhat.com>, dave.jiang@intel.com, darrick.wong@oracle.com, vishal.l.verma@intel.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, imammedo@redhat.com, dan.j.williams@intel.com, lcapitulino@redhat.com, linux-ext4@vger.kernel.org, tytso@mit.edu, xiaoguangrong.eric@gmail.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, pbonzini@redhat.com
List-Id: linux-nvdimm@lists.01.org

On Wed, Feb 06, 2019 at 03:00:26PM +0100, David Hildenbrand wrote:
> On 04.02.19 23:56, Michael S. Tsirkin wrote:
> > 
> > On Wed, Jan 09, 2019 at 08:17:31PM +0530, Pankaj Gupta wrote:
> >>  This patch series has implementation for "virtio pmem". 
> >>  "virtio pmem" is fake persistent memory(nvdimm) in guest 
> >>  which allows to bypass the guest page cache. This also
> >>  implements a VIRTIO based asynchronous flush mechanism.  
> > 
> > 
> > At Pankaj's request I looked at information leak implications of virtio
> > pmem in light of the recent page cache side channels paper
> > (https://arxiv.org/pdf/1901.01161.pdf) - to see what
> > kind of side channels it might create if any.  TLDR - I think that
> > depending on the host side implementation there could be some, but this
> > might be addressable by better documentation in both code and spec.
> > The fake dax approach backing the guest memory by a host page cache
> > does seem to have potential issues.
> > 
> > For clarity: we are talking about leaking information either to a VM, or
> > within a VM (I did not look into leaks to hypervisor in configurations
> > such as SEV) through host page cache.
> > 
> > Leaks into a VM: It seems clear that while pmem allows memory accesses
> > versus read/write with e.g. a block device, from host page cache point
> > of view this doesn't matter much: reads populate cache in the same way
> > as memory faults.  Thus ignoring presence of information leaks (which is
> > an interesting question e.g. in light of recent discard support) pmem
> > doesn't seem to be any better or worse for leaking information into a
> > VM.
> 
> +1, just a different way to access that cache.
> 
> Conceptually a virtio-pmem devices is from the guest view a "device with
> a managed buffer". Some accesses might be faster than others. There are
> no guarantees on how fast a certain access is. And yes, actions on other
> guests can result in accesses being slower but not faster.
> 
> Also other storage devices have caches like that (well, the caches size
> depends on the device) - thinking especially about storage systems -
> which would in my opinion, also allow similar leaks. How are such
> security concerns handled there? Are they different (besides eventually
> access speed)?
> 
> > 
> > Leaks within VM: Right now pmem seems to bypass the guest page cache
> > completely.  Whether pmem memory is then resident in a page cache would
> > be up to the device/host. Assuming that it is, the "Preventing
> > Efficient Eviction while Increasing the System Performance"
> > countermeasure for the page cache side channel attack would appear to
> > become ineffective with pmem. What is suggested is a per-process
> > management of the page cache, and host does not have visibility of
> > processes within a VM. Another possible countermeasure - not discussed
> > in the paper - could be modify the applications to lock the security
> > relevant pages in memory.  Again this becomes impractical with pmem as
> > host does not have visibility into that. However note that as long
> > as the only countermeasure linux uses is "Privileged Access"
> > (i.e. blocking mincore) nothing can be done as guest page cache
> > remains as vulnerable as host page cache.
> 
> This sounds very use-case specific. If I run a VM only with a very
> specific workload (say, a container running one application), I usually
> don't care about leaks within the VM. At least not leaks between
> applications ;)
> 
> In contrast, to running different applications (e.g. containers from
> different customers) on one system, I really care about leaks within a VM.

Clearly, not everyone cares about closing off information leaks.

> > 
> > 
> > Countermeasures: which host-side countermeasures can be designed would
> > depend on which countermeasures are used guest-side - we would need to
> > make sure they are not broken by pmem.  For "Preventing Efficient
> > Eviction while Increasing the System Performance" modifying the host
> > implementation to ensure that pmem device bypasses the host page cache
> > would seem to address the security problem.Similarly, ensuring that a
> > real memory device (e.g. DAX, RAM such as hugetlbfs, pmem for nested
> > virt) is used for pmem would make the memory locking countermeasure
> > work.  Whether with such limitations the device is still useful
> > performance wise is an open question.  These questions probably should
> > be addressed in the documentation, spec and possible qemu code.
> > 
> I also want to note that using a disk/file as memory backend with
> NVDIMMs in QEMU essentially results in the exact same questions we have
> with virtio-pmem.
> 
> E.g. kata-containers use nvdimms for the rootfile system (read-only) as
> far as I am aware.
> 
> Conceptually, a virtio-pmem device is just an emulated nvdimm device
> with a flush interface. And the nice thing is, that it is designed to
> also work on architectures that don't speak "nvdimm".
> 
> > 
> > Severity of the security implications: some people argue that the
> > security implications of the page cache leaks are minor.  I do not have
> > an opinion on this: the severity would seem to depend on the specific
> > configuration.
> 
> I guess configuration and use case.

Good point.

> Nice summary, thanks for looking into this Michael!
> 
> 
> -- 
> 
> Thanks,
> 
> David / dhildenb
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
