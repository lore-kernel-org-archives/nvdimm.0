Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Fri, 21 Jul 2017 09:29:15 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <46101617.33460557.1500643755247.JavaMail.zimbra@redhat.com>
In-Reply-To: <20170721121241.GA18014@stefanha-x1.localdomain>
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <945864462.33340808.1500620194836.JavaMail.zimbra@redhat.com>
 <20170721121241.GA18014@stefanha-x1.localdomain>
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
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Rik van Riel <riel@redhat.com>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>


> > A] Problems to solve:
> > ------------------
> > 
> > 1] We are considering two approaches for 'fake DAX flushing interface'.
> >     
> >  1.1] fake dax with NVDIMM flush hints & KVM async page fault
> > 
> >      - Existing interface.
> > 
> >      - The approach to use flush hint address is already nacked upstream.
> >
> >      - Flush hint not queued interface for flushing. Applications might
> >        avoid to use it.
> 
> This doesn't contradicts the last point about async operation and vcpu
> control.  KVM async page faults turn the Address Flush Hints write into
> an async operation so the guest can get other work done while waiting
> for completion.
> 
> > 
> >      - Flush hint address traps from guest to host and do an entire fsync
> >        on backing file which itself is costly.
> > 
> >      - Can be used to flush specific pages on host backing disk. We can
> >        send data(pages information) equal to cache-line size(limitation)
> >        and tell host to sync corresponding pages instead of entire disk
> >        sync.
> 
> Are you sure?  Your previous point says only the entire device can be
> synced.  The NVDIMM Adress Flush Hints interface does not involve
> address range information.

Just syncing entire block device should be simple but costly. Using flush 
hint address to write data which contains list/info of dirty pages to 
flush requires more thought. This calls mmio write callback at Qemu side.
As per Intel (ACPI spec 6.1, Table 5-135) there is limit to max length 
of data guest can write and is equal to cache line size.
 
> 
> > 
> >      - This will be an asynchronous operation and vCPU control is returned
> >        quickly.
> > 
> > 
> >  1.2] Using additional para virt device in addition to pmem device(fake dax
> >  with device flush)
> 
> Perhaps this can be exposed via ACPI as part of the NVDIMM standards
> instead of a separate KVM-only paravirt device.

Same reason as above. If we decide on sending list of dirty pages there is
limit to send max size of data to host using flush hint address.  
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
