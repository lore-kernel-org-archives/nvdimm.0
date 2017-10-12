From: Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [Qemu-devel] [RFC 1/2] pmem: Move reusable code to base header
 files
Date: Thu, 12 Oct 2017 17:27:28 -0400 (EDT)
Message-ID: <1893461099.19940340.1507843648978.JavaMail.zimbra@redhat.com>
References: <20171012155027.3277-1-pagupta@redhat.com> <20171012155027.3277-2-pagupta@redhat.com> <CAPcyv4jdWUeoF1PxWhXx3vciLmOL9AyW_yPq0W6DRFe3RP2fkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CAPcyv4jdWUeoF1PxWhXx3vciLmOL9AyW_yPq0W6DRFe3RP2fkA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Haozhong Zhang <haozhong.zhang@intel.com>, Jan Kara <jack@suse.cz>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, KVM list <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Ross Zwisler <ross.zwisler@intel.com>, linux-kernel@vger.kernel.org, Qemu Developers <qemu-devel@nongnu.org>, Linux MM <linux-mm@kvack.org>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-Id: linux-nvdimm@lists.01.org


> 
> On Thu, Oct 12, 2017 at 8:50 AM, Pankaj Gupta <pagupta@redhat.com> wrote:
> >  This patch moves common code to base header files
> >  so that it can be used for both ACPI pmem and VIRTIO pmem
> >  drivers. More common code needs to be moved out in future
> >  based on functionality required for virtio_pmem driver and
> >  coupling of code with existing ACPI pmem driver.
> >
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> [..]
> > diff --git a/include/linux/pmem_common.h b/include/linux/pmem_common.h
> > new file mode 100644
> > index 000000000000..e2e718c74b3f
> > --- /dev/null
> > +++ b/include/linux/pmem_common.h
> 
> This should be a common C file, not a header.

Sure! will create a common C file to put all the common code there.

> 
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
