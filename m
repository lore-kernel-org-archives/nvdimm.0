Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: KVM "fake DAX" flushing interface - discussion
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <1888117852.34216619.1500992835767.JavaMail.zimbra@redhat.com>
 <CAPcyv4in28F3FOVKp9abvrggxPuXdbGynF5=ZvBXCrywoa06JA@mail.gmail.com>
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
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Message-ID: <ec5ff7c2-864e-5020-0aaa-6663e78e3756@gmail.com>
Date: Fri, 3 Nov 2017 14:21:28 +0800
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iH==cqVAdd8i1y-8A6SuXU75OH1EZzgNMvtA21wfxPpQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Pankaj Gupta <pagupta@redhat.com>, Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@gmail.com>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>



On 11/03/2017 12:30 AM, Dan Williams wrote:
> On Thu, Nov 2, 2017 at 1:50 AM, Xiao Guangrong
> <xiaoguangrong.eric@gmail.com> wrote:
> [..]
>>> Yes, the GUID will specifically identify this range as "Virtio Shared
>>> Memory" (or whatever name survives after a bikeshed debate). The
>>> libnvdimm core then needs to grow a new region type that mostly
>>> behaves the same as a "pmem" region, but drivers/nvdimm/pmem.c grows a
>>> new flush interface to perform the host communication. Device-dax
>>> would be disallowed from attaching to this region type, or we could
>>> grow a new device-dax type that does not allow the raw device to be
>>> mapped, but allows a filesystem mounted on top to manage the flush
>>> interface.
>>
>>
>> I am afraid it is not a good idea that a single SPA is used for multiple
>> purposes. For the region used as "pmem" is directly mapped to the VM so
>> that guest can freely access it without host's assistance, however, for
>> the region used as "host communication" is not mapped to VM, so that
>> it causes VM-exit and host gets the chance to do specific operations,
>> e.g, flush cache. So we'd better distinctly define these two regions to
>> avoid the unnecessary complexity in hypervisor.
> 
> Good point, I was assuming that the mmio flush interface would be
> discovered separately from the NFIT-defined memory range. Perhaps via
> PCI in the guest? This piece of the proposal  needs a bit more
> thought...
> 

Consider the case that the vNVDIMM device on normal storage and
vNVDIMM device on real nvdimm hardware can both exist in VM, the
flush interface should be able to associate with the SPA region
respectively. That's why I'd like to integrate the flush interface
into NFIT/ACPI by using a separate table. Is it possible to be a
part of ACPI specification? :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
