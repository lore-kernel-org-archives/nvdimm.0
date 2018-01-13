Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Sat, 13 Jan 2018 01:23:05 -0500 (EST)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <326660076.6160176.1515824585284.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAPcyv4j6nk1cJFuG4DDA9JoNJe2d3rSskdFSUPu4aWzWX+JQeQ@mail.gmail.com>
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <ec5ff7c2-864e-5020-0aaa-6663e78e3756@gmail.com>
 <1511288389.1080.14.camel@redhat.com>
 <d1df875c-5b64-67d9-2b3c-4ec14c03b85b@gmail.com>
 <CAPcyv4ip6m6e9Bh7weJNB3m3kpDpRkhHDZf0JYyr5UbkD41oLg@mail.gmail.com>
 <654f8935-258e-22ef-fae4-3e14e91e8fae@redhat.com>
 <336152896.34452750.1511527207457.JavaMail.zimbra@redhat.com>
 <CAPcyv4j6nk1cJFuG4DDA9JoNJe2d3rSskdFSUPu4aWzWX+JQeQ@mail.gmail.com>
Subject: Re: KVM "fake DAX" flushing interface - discussion
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@gmail.com>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Christoph Hellwig <hch@infradead.org>, Stefan Hajnoczi <stefanha@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>


Hello Dan,

> Not a flag, but a new "Address Range Type GUID". See section "5.2.25.2
> System Physical Address (SPA) Range Structure" in the ACPI 6.2A
> specification. Since it is a GUID we could define a Linux specific
> type for this case, but spec changes would allow non-Linux hypervisors
> to advertise a standard interface to guests.
> 

I have added new SPA with a GUUID for this memory type and I could add 
this new memory type in System memory map. I need help with the namespace
handling for this new type As mentioned in [1] discussion:

- Create a new namespace for this new memory type
- Teach libnvdimm how to handle this new namespace 

I have some queries on this:

1] How namespace handling of this new memory type would be?
  
2] There are existing namespace types: 
  ND_DEVICE_NAMESPACE_IO, ND_DEVICE_NAMESPACE_PMEM, ND_DEVICE_NAMESPACE_BLK

  How libnvdimm will handle this new name-space type in conjuction with existing
  memory type, region & namespaces?  

3] For sending guest to host flush commands we still have to think about some 
   async way?
    
[1] https://lists.gnu.org/archive/html/qemu-devel/2017-07/msg08404.html 

Thanks,
Pankaj
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
