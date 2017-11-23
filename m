Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: KVM "fake DAX" flushing interface - discussion
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <1501016375.26846.21.camel@redhat.com>
 <1063764405.34607875.1501076841865.JavaMail.zimbra@redhat.com>
 <1501104453.26846.45.camel@redhat.com>
 <CAPcyv4hsqrqBxoipUHPAbSctuzbVWCRnT-gN08i9uhXTWY6iPQ@mail.gmail.com>
 <1501112787.4073.49.camel@redhat.com>
 <CAPcyv4gbC6Hx_4YsCfOd2t=fn=wPGp5h__1QH=-p40TPFNbFzA@mail.gmail.com>
 <0a26793f-86f7-29e7-f61b-dc4c1ef08c8e@gmail.com>
 <CAPcyv4iw2cCpDmr+4kxsFvdy+iGZiz=ok-kLhsDKpqDy+szf-Q@mail.gmail.com>
 <378b10f3-b32f-84f5-2bbc-50c2ec5bcdd4@gmail.com>
 <CAPcyv4jR_LdbsX-rAsHC7++C6d-WYC084uWXzr+08PSYwoXFMw@mail.gmail.com>
 <ca6aaa77-cca0-441e-be49-73133d8581cf@gmail.com>
 <CAPcyv4gKzvd39WbnKjbs3Bn9+o1tt=vz90CYMFu0DF5PsfHUig@mail.gmail.com>
 <86754966-281f-c3ed-938c-f009440de563@gmail.com>
 <CAPcyv4iH==cqVAdd8i1y-8A6SuXU75OH1EZzgNMvtA21wfxPpQ@mail.gmail.com>
 <ec5ff7c2-864e-5020-0aaa-6663e78e3756@gmail.com>
 <1511288389.1080.14.camel@redhat.com>
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Message-ID: <d1df875c-5b64-67d9-2b3c-4ec14c03b85b@gmail.com>
Date: Thu, 23 Nov 2017 12:05:45 +0800
MIME-Version: 1.0
In-Reply-To: <1511288389.1080.14.camel@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Rik van Riel <riel@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Pankaj Gupta <pagupta@redhat.com>, Jan Kara <jack@suse.cz>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@gmail.com>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>



On 11/22/2017 02:19 AM, Rik van Riel wrote:

> We can go with the "best" interface for what
> could be a relatively slow flush (fsync on a
> file on ssd/disk on the host), which requires
> that the flushing task wait on completion
> asynchronously.

I'd like to clarify the interface of "wait on completion
asynchronously" and KVM async page fault a bit more.

Current design of async-page-fault only works on RAM rather
than MMIO, i.e, if the page fault caused by accessing the
device memory of a emulated device, it needs to go to
userspace (QEMU) which emulates the operation in vCPU's
thread.

As i mentioned before the memory region used for vNVDIMM
flush interface should be MMIO and consider its support
on other hypervisors, so we do better push this async
mechanism into the flush interface design itself rather
than depends on kvm async-page-fault.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
