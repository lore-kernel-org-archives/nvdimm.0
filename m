From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [PATCH v3 0/5] kvm "virtio pmem" device
Date: Mon, 14 Jan 2019 05:16:55 -0500 (EST)
Message-ID: <2011860338.64100587.1547461015822.JavaMail.zimbra@redhat.com>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <20190110012617.GA4205@dastard> <20190110101757.GC15790@quack2.suse.cz>
 <1354249849.63357171.1547343519970.JavaMail.zimbra@redhat.com>
 <CAPcyv4hwcgTUpgNCefCGu4DvgkYBp5b=f+hJ+FC=s5APYKoycg@mail.gmail.com>
 <540171952.63371441.1547345866585.JavaMail.zimbra@redhat.com>
 <20190114095520.GC13316@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190114095520.GC13316-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Qemu Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, adilger kernel <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, darrick wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nitesh Narayan Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rafael J. Wysock
List-Id: linux-nvdimm@lists.01.org


> > > > > Right. Thinking about this I would be more concerned about the fact
> > > > > that
> > > > > guest can effectively pin amount of host's page cache upto size of
> > > > > the
> > > > > device/file passed to guest as PMEM, can't it Pankaj? Or is there
> > > > > some
> > > > > QEMU
> > > > > magic that avoids this?
> > > >
> > > > Yes, guest will pin these host page cache pages using 'get_user_pages'
> > > > by
> > > > elevating the page reference count. But these pages can be reclaimed by
> > > > host
> > > > at any time when there is memory pressure.
> > > 
> > > Wait, how can the guest pin the host pages? I would expect this to
> > > happen only when using vfio and device assignment. Otherwise, no the
> > > host can't reclaim a pinned page, that's the whole point of a pin to
> > > prevent the mm from reclaiming ownership.
> > 
> > yes. You are right I just used the pin word but it does not actually pin
> > pages
> > permanently. I had gone through the discussion on existing problems with
> > get_user_pages and DMA e.g [1] to understand Jan's POV. It does mention GUP
> > pin pages so I also used the word 'pin'. But guest does not permanently pin
> > these pages and these pages can be reclaimed by host.
> 
> OK, then I was just confused how virtio-pmem is going to work. Thanks for
> explanation! So can I imagine this as guest mmaping the host file and
> providing the mapped range as "NVDIMM pages" to the kernel inside the
> guest? Or is it more complex?

yes, that's correct. Host's Qemu process virtual address range is used as guest physical 
address and a direct mapping(EPT/NPT) is established. At guest side, this physical memory
range is plugged into guest system memory map and DAX mapping is setup using nvdimm calls.

Thanks,
Pankaj
