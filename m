Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: KVM "fake DAX" flushing interface - discussion
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <86754966-281f-c3ed-938c-f009440de563@gmail.com>
 <CAPcyv4iH==cqVAdd8i1y-8A6SuXU75OH1EZzgNMvtA21wfxPpQ@mail.gmail.com>
 <ec5ff7c2-864e-5020-0aaa-6663e78e3756@gmail.com>
 <1511288389.1080.14.camel@redhat.com>
 <d1df875c-5b64-67d9-2b3c-4ec14c03b85b@gmail.com>
 <CAPcyv4ip6m6e9Bh7weJNB3m3kpDpRkhHDZf0JYyr5UbkD41oLg@mail.gmail.com>
 <654f8935-258e-22ef-fae4-3e14e91e8fae@redhat.com>
 <336152896.34452750.1511527207457.JavaMail.zimbra@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d5bcb61c-1f7c-faa7-f19b-a8f02f505b4a@redhat.com>
Date: Fri, 24 Nov 2017 13:44:23 +0100
MIME-Version: 1.0
In-Reply-To: <336152896.34452750.1511527207457.JavaMail.zimbra@redhat.com>
Content-Language: en-US
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
To: Pankaj Gupta <pagupta@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Rik van Riel <riel@redhat.com>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Christoph Hellwig <hch@infradead.org>
Cc: Kevin Wolf <kwolf@redhat.com>, Jan Kara <jack@suse.cz>, kvm-devel <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 24/11/2017 13:40, Pankaj Gupta wrote:
>    - Suggestion by Paolo & Stefan(previously) to use virtio-blk makes sense if just 
>      want a flush vehicle to send guest commands to host and get reply after asynchronous
>      execution. There was previous discussion [1] with Rik & Dan on this.
> 
>     [1] https://lists.gnu.org/archive/html/qemu-devel/2017-07/msg08373.html 

... in fact, the virtio-blk device _could_ actually accept regular I/O
too.  That would make it easier to boot from pmem.  Is there anything
similar in regular hardware?

Paolo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
