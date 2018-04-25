From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC v2] qemu: Add virtio pmem device
Date: Wed, 25 Apr 2018 10:55:57 -0400 (EDT)
Message-ID: <634642140.22649359.1524668157371.JavaMail.zimbra@redhat.com>
References: <20180425112415.12327-1-pagupta@redhat.com>
 <20180425112415.12327-4-pagupta@redhat.com>
 <25f3e433-cfa6-4a62-ba7f-47aef1119dfc@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <25f3e433-cfa6-4a62-ba7f-47aef1119dfc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


> 
> On 04/25/2018 06:24 AM, Pankaj Gupta wrote:
> > This patch adds virtio-pmem Qemu device.
> > 
> > This device presents memory address range
> > information to guest which is backed by file
> > backend type. It acts like persistent memory
> > device for KVM guest. Guest can perform read
> > and persistent write operations on this memory
> > range with the help of DAX capable filesystem.
> > 
> > Persistent guest writes are assured with the
> > help of virtio based flushing interface. When
> > guest userspace space performs fsync on file
> > fd on pmem device, a flush command is send to
> > Qemu over VIRTIO and host side flush/sync is
> > done on backing image file.
> > 
> > This PV device code is dependent and tested
> > with 'David Hildenbrand's ' patchset[1] to
> > map non-PCDIMM devices to guest address space.
> 
> This sentence doesn't belong in git history.  It is better to put
> information like this...
> 
> > There is still upstream discussion on using
> > among PCI bar vs memory device, will update
> > as per concensus.
> 
> s/concensus/consensus/
> 
> > 
> > [1] https://marc.info/?l=qemu-devel&m=152450249319168&w=2
> > 
> > Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> 
> ...here, where it is part of the email, but not picked up by 'git am'.

I see.

Thanks!
> 
> 
> > +++ b/qapi/misc.json
> > @@ -2871,6 +2871,29 @@
> >            }
> >  }
> >  
> > +##
> > +# @VirtioPMemDeviceInfo:
> > +#
> > +# VirtioPMem state information
> > +#
> > +# @id: device's ID
> > +#
> > +# @start: physical address, where device is mapped
> > +#
> > +# @size: size of memory that the device provides
> > +#
> > +# @memdev: memory backend linked with device
> > +#
> > +# Since: 2.13
> > +##
> > +{ 'struct': 'VirtioPMemDeviceInfo',
> > +    'data': { '*id': 'str',
> > +	      'start': 'size',
> > +	      'size': 'size',
> 
> TAB damage.

o.k

> 
> > +              'memdev': 'str'
> > +	    }
> > +}
> > +
> >  ##
> >  # @MemoryDeviceInfo:
> >  #
> > @@ -2880,7 +2903,8 @@
> >  ##
> >  { 'union': 'MemoryDeviceInfo',
> >    'data': { 'dimm': 'PCDIMMDeviceInfo',
> > -            'nvdimm': 'PCDIMMDeviceInfo'
> > +            'nvdimm': 'PCDIMMDeviceInfo',
> > +	    'virtio-pmem': 'VirtioPMemDeviceInfo'
> >            }
> >  }
> >  
> > 
> 
> --
> Eric Blake, Principal Software Engineer
> Red Hat, Inc.           +1-919-301-3266
> Virtualization:  qemu.org | libvirt.org
> 
> 
