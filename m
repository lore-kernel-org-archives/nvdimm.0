From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC v3] qemu: Add virtio pmem device
Date: Wed, 25 Jul 2018 01:01:39 -0400 (EDT)
Message-ID: <399916154.53931292.1532494899706.JavaMail.zimbra@redhat.com>
References: <20180713075232.9575-1-pagupta@redhat.com>
 <20180713075232.9575-4-pagupta@redhat.com>
 <783786ae-2e85-2376-448c-1e362c3d4d48@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <783786ae-2e85-2376-448c-1e362c3d4d48-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


Hi Eric,

> 
> On 07/13/2018 02:52 AM, Pankaj Gupta wrote:
> >   This patch adds virtio-pmem Qemu device.
> > 
> >   This device presents memory address range information to guest
> >   which is backed by file backend type. It acts like persistent
> >   memory device for KVM guest. Guest can perform read and persistent
> >   write operations on this memory range with the help of DAX capable
> >   filesystem.
> > 
> >   Persistent guest writes are assured with the help of virtio based
> >   flushing interface. When guest userspace space performs fsync on
> >   file fd on pmem device, a flush command is send to Qemu over VIRTIO
> >   and host side flush/sync is done on backing image file.
> > 
> > Changes from RFC v2:
> 
> This patch has no n/M in the subject line; but is included in a thread
> that also has a 0/2 cover letter, as well as 1/2 and 2/2 patches in
> separate mails.  Is that intentional?

Yes, kernel series has 0-2 patches and Qemu has this one. I thought its
good to keep separate numbering for both the sets.  
> 
> When sending revision notes on a specific patch, it's best to place them...

Sure.
> 
> > - Use aio_worker() to avoid Qemu from hanging with blocking fsync
> >    call - Stefan
> > - Use virtio_st*_p() for endianess - Stefan
> > - Correct indentation in qapi/misc.json - Eric
> > 
> > Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> 
> ...here, after the --- separator. They are useful to reviewers on the
> list, but are stripped by 'git am' as they don't need to be part of the
> git history (a year from now, we won't care how many iterations the
> patch went through during review, only what actually landed).
> 
> 
> > +++ b/qapi/misc.json
> > @@ -2907,6 +2907,29 @@
> >             }
> >   }
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
> 
> There is no 2.13 release, and you've missed the 3.0 window.  Please
> update this and any other version reference to 3.1.

okay.

Thanks,
Pankaj
