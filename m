From: Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [Qemu-devel] [RFC 2/2] KVM: add virtio-pmem driver
Date: Tue, 17 Oct 2017 03:40:56 -0400 (EDT)
Message-ID: <1441791227.21027037.1508226056893.JavaMail.zimbra@redhat.com>
References: <20171012155027.3277-1-pagupta@redhat.com> <20171012155027.3277-3-pagupta@redhat.com> <20171017071633.GA9207@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171017071633.GA9207@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: kwolf@redhat.com, haozhong zhang <haozhong.zhang@intel.com>, jack@suse.cz, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, kvm@vger.kernel.org, david@redhat.com, linux-nvdimm@ml01.01.org, ross zwisler <ross.zwisler@intel.com>, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, linux-mm@kvack.org, stefanha@redhat.com, pbonzini@redhat.com, dan j williams <dan.j.williams@intel.com>, nilal@redhat.com
List-Id: linux-nvdimm@lists.01.org


> 
> I think this driver is at entirely the wrong level.
> 
> If you want to expose pmem to a guest with flushing assist do it
> as pmem, and not a block driver.

Are you saying do it as existing i.e ACPI pmem like interface?
The reason we have created this new driver is exiting pmem driver
does not define proper semantics for guest flushing requests.

Regarding block support of driver, we want to achieve DAX support
to bypass guest page cache. Also, we want to utilize existing DAX
capable file-system interfaces(e.g fsync) from userspace file API's
to trigger the host side flush request.

Below link has details of previous discussion:
https://marc.info/?l=kvm&m=150091133700361&w=2

Thanks,
Pankaj  
