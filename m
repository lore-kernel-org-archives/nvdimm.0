From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC v3] qemu: Add virtio pmem device
Date: Fri, 20 Jul 2018 09:04:15 -0400 (EDT)
Message-ID: <1832644023.52851886.1532091855557.JavaMail.zimbra@redhat.com>
References: <20180713075232.9575-1-pagupta@redhat.com>
 <20180713075232.9575-4-pagupta@redhat.com> <20180718085529.133a0a22@doriath>
 <367397176.52317488.1531979293251.JavaMail.zimbra@redhat.com>
 <20180719121635.GA28107@stefanha-x1.localdomain>
 <20180719084819.730b7971@doriath>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180719084819.730b7971@doriath>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


> > > > > +
> > > > > +typedef struct VirtIOPMEMresp {
> > > > > +    int ret;
> > > > > +} VirtIOPMEMResp;
> > > > > +
> > > > > +typedef struct VirtIODeviceRequest {
> > > > > +    VirtQueueElement elem;
> > > > > +    int fd;
> > > > > +    VirtIOPMEM *pmem;
> > > > > +    VirtIOPMEMResp resp;
> > > > > +} VirtIODeviceRequest;
> > > > > +
> > > > > +static int worker_cb(void *opaque)
> > > > > +{
> > > > > +    VirtIODeviceRequest *req = opaque;
> > > > > +    int err = 0;
> > > > > +
> > > > > +    /* flush raw backing image */
> > > > > +    err = fsync(req->fd);
> > > > > +    if (err != 0) {
> > > > > +        err = errno;
> > > > > +    }
> > > > > +    req->resp.ret = err;
> > > > 
> > > > Host question: are you returning the guest errno code to the host?
> > > 
> > > No. I am returning error code from the host in-case of host fsync
> > > failure, otherwise returning zero.
> > 
> > I think that's what Luiz meant.  errno constants are not portable
> > between operating systems and architectures.  Therefore they cannot be
> > used in external interfaces in software that expects to communicate with
> > other systems.
> 
> Oh, thanks. Only saw this email now.
> 
> > It will be necessary to define specific constants for virtio-pmem
> > instead of passing errno from the host to guest.
> 
> Yes, defining your own constants work. But I think the only fsync()
> error that will make sense for the guest is EIO. The other errors
> only make sense for the host.

Agree.

Thanks,
Pankaj
