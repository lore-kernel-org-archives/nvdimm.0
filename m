From: Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [Qemu-devel] security implications of caching with virtio pmem
 (was Re: [PATCH v3 0/5] kvm "virtio pmem" device)
Date: Tue, 5 Feb 2019 02:29:37 -0500 (EST)
Message-ID: <1689233487.69735950.1549351777236.JavaMail.zimbra@redhat.com>
References: <20190109144736.17452-1-pagupta@redhat.com> <20190204170515-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190204170515-mutt-send-email-mst@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: jack@suse.cz, kvm@vger.kernel.org, david@redhat.com, linux-nvdimm@ml01.01.org, jasowang@redhat.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, Andrea Arcangeli <aarcange@redhat.com>, dave jiang <dave.jiang@intel.com>, darrick wong <darrick.wong@oracle.com>, vishal l verma <vishal.l.verma@intel.com>, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, imammedo@redhat.com, dan j williams <dan.j.williams@intel.com>, lcapitulino@redhat.com, kwolf@redhat.com, linux-ext4@vger.kernel.org, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, rjw@rjwysocki.net, linux-kernel@vger.kernel.o
List-Id: linux-nvdimm@lists.01.org


+CC [Dave Chinner], to maintain updated CC list  

> >  This patch series has implementation for "virtio pmem".
> >  "virtio pmem" is fake persistent memory(nvdimm) in guest
> >  which allows to bypass the guest page cache. This also
> >  implements a VIRTIO based asynchronous flush mechanism.
> 
> 
> At Pankaj's request I looked at information leak implications of virtio
> pmem in light of the recent page cache side channels paper
> (https://arxiv.org/pdf/1901.01161.pdf) - to see what
> kind of side channels it might create if any.  TLDR - I think that
> depending on the host side implementation there could be some, but this
> might be addressable by better documentation in both code and spec.
> The fake dax approach backing the guest memory by a host page cache
> does seem to have potential issues.
> 
> For clarity: we are talking about leaking information either to a VM, or
> within a VM (I did not look into leaks to hypervisor in configurations
> such as SEV) through host page cache.
> 
> Leaks into a VM: It seems clear that while pmem allows memory accesses
> versus read/write with e.g. a block device, from host page cache point
> of view this doesn't matter much: reads populate cache in the same way
> as memory faults.  Thus ignoring presence of information leaks (which is
> an interesting question e.g. in light of recent discard support) pmem
> doesn't seem to be any better or worse for leaking information into a
> VM.
> 
> Leaks within VM: Right now pmem seems to bypass the guest page cache
> completely.  Whether pmem memory is then resident in a page cache would
> be up to the device/host. Assuming that it is, the "Preventing
> Efficient Eviction while Increasing the System Performance"
> countermeasure for the page cache side channel attack would appear to
> become ineffective with pmem. What is suggested is a per-process
> management of the page cache, and host does not have visibility of
> processes within a VM. Another possible countermeasure - not discussed
> in the paper - could be modify the applications to lock the security
> relevant pages in memory.  Again this becomes impractical with pmem as
> host does not have visibility into that. However note that as long
> as the only countermeasure linux uses is "Privileged Access"
> (i.e. blocking mincore) nothing can be done as guest page cache
> remains as vulnerable as host page cache.
> 
> 
> Countermeasures: which host-side countermeasures can be designed would
> depend on which countermeasures are used guest-side - we would need to
> make sure they are not broken by pmem.  For "Preventing Efficient
> Eviction while Increasing the System Performance" modifying the host
> implementation to ensure that pmem device bypasses the host page cache
> would seem to address the security problem.Similarly, ensuring that a
> real memory device (e.g. DAX, RAM such as hugetlbfs, pmem for nested
> virt) is used for pmem would make the memory locking countermeasure
> work.  Whether with such limitations the device is still useful
> performance wise is an open question.  These questions probably should
> be addressed in the documentation, spec and possible qemu code.
> 
> 
> 
> Severity of the security implications: some people argue that the
> security implications of the page cache leaks are minor.  I do not have
> an opinion on this: the severity would seem to depend on the specific
> configuration.
> 
> 
> Other security implications: recent discussion seems to suggest there
> are other concerns around e.g. resource management and thus DOS
> potential. If that's so, it's a matter for a separate discussion
> as I didn't look into that in depth.
> 
> Some or all of the above might be based on a misunderstanding of the
> current pmem code, the whitepaper and linux page cache in general.
> If so I apologise, do not hesitate to call out any mistakes.
> 
> Thanks!
> 
> --
> MST
> 
> 
