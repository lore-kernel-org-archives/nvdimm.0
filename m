From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] nd: move nd_region to common header
Date: Mon, 24 Sep 2018 07:40:11 -0400 (EDT)
Message-ID: <247764824.15598220.1537789211903.JavaMail.zimbra@redhat.com>
References: <20180831133019.27579-1-pagupta@redhat.com>
 <20180831133019.27579-2-pagupta@redhat.com>
 <CAPcyv4jFimkVnVuzza5TCG=KvY88KZnXzH4GNEgUBbTouprzJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4jFimkVnVuzza5TCG=KvY88KZnXzH4GNEgUBbTouprzJA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Xiao Guangrong <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ross Zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Qemu Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Igor Mammedov <imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nitesh Narayan Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org


> Subject: Re: [PATCH 1/3] nd: move nd_region to common header
> 
> On Fri, Aug 31, 2018 at 6:31 AM Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > This patch moves nd_region definition to common header
> > include/linux/nd.h file. This is required for flush callback
> > support for both virtio-pmem & pmem driver.
> >
> > Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/nvdimm/nd.h | 39 ---------------------------------------
> >  include/linux/nd.h  | 40 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 40 insertions(+), 39 deletions(-)
> 
> No, we need to find a way to do this without dumping all of these
> internal details to a public / global header.

This is required when virtio_pmem driver accesses fields of nd_region struct. 
Instead if we pass device pointer in place of nd_region, we don't need to put
this in global header. Thoughts?

e.g virtio_pmem_flush(struct device *dev)

Thanks,
Pankaj 
