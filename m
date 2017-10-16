From: Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 2/2] KVM: add virtio-pmem driver
Date: Mon, 16 Oct 2017 15:47:53 +0100
Message-ID: <20171016144753.GB14135@stefanha-x1.localdomain>
References: <20171012155027.3277-1-pagupta@redhat.com>
 <20171012155027.3277-3-pagupta@redhat.com>
 <20171013094431.GA27308@stefanha-x1.localdomain>
 <24301306.20068579.1507891695416.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <24301306.20068579.1507891695416.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Oct 13, 2017 at 06:48:15AM -0400, Pankaj Gupta wrote:
> > On Thu, Oct 12, 2017 at 09:20:26PM +0530, Pankaj Gupta wrote:
> > > +static blk_qc_t virtio_pmem_make_request(struct request_queue *q,
> > > +			struct bio *bio)
> > > +{
> > > +	blk_status_t rc = 0;
> > > +	struct bio_vec bvec;
> > > +	struct bvec_iter iter;
> > > +	struct virtio_pmem *pmem = q->queuedata;
> > > +
> > > +	if (bio->bi_opf & REQ_FLUSH)
> > > +		//todo host flush command
> > 
> > This detail is critical to the device design.  What is the plan?
> 
> yes, this is good point.
> 
> was thinking of guest sending a flush command to Qemu which
> will do a fsync on file fd.

Previously there was discussion about fsyncing a specific file range
instead of the whole file.  This could perform better in cases where
only a subset of dirty pages need to be flushed.

One possibility is to design the virtio interface to communicate ranges
but the emulation code simply fsyncs the fd for the time being.  Later
on, if the necessary kernel and userspace interfaces are added, we can
make use of the interface.

> If we do a async flush and move the task to wait queue till we receive 
> flush complete reply from host we can allow other tasks to execute
> in current cpu.
> 
> Any suggestions you have or anything I am not foreseeing here?

My main thought about this patch series is whether pmem should be a
virtio-blk feature bit instead of a whole new device.  There is quite a
bit of overlap between the two.

Stefan
