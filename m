Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <1501112787.4073.49.camel@redhat.com>
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <CAPcyv4hpbk0jgp+mA=q05zVBV8ZSZvCvV68JJ4gjE3QhK70d1w@mail.gmail.com>
 <20170724102330.GE652@quack2.suse.cz>
 <1157879323.33809400.1500897967669.JavaMail.zimbra@redhat.com>
 <20170724123752.GN652@quack2.suse.cz>
 <1888117852.34216619.1500992835767.JavaMail.zimbra@redhat.com>
 <CAPcyv4in28F3FOVKp9abvrggxPuXdbGynF5=ZvBXCrywoa06JA@mail.gmail.com>
 <1501016375.26846.21.camel@redhat.com>
 <1063764405.34607875.1501076841865.JavaMail.zimbra@redhat.com>
 <1501104453.26846.45.camel@redhat.com>
 <CAPcyv4hsqrqBxoipUHPAbSctuzbVWCRnT-gN08i9uhXTWY6iPQ@mail.gmail.com>
 <1501112787.4073.49.camel@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 17:54:17 -0700
Message-ID: <CAPcyv4gbC6Hx_4YsCfOd2t=fn=wPGp5h__1QH=-p40TPFNbFzA@mail.gmail.com>
Subject: Re: KVM "fake DAX" flushing interface - discussion
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
To: Rik van Riel <riel@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Pankaj Gupta <pagupta@redhat.com>, Jan Kara <jack@suse.cz>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@gmail.com>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 26, 2017 at 4:46 PM, Rik van Riel <riel@redhat.com> wrote:
> On Wed, 2017-07-26 at 14:40 -0700, Dan Williams wrote:
>> On Wed, Jul 26, 2017 at 2:27 PM, Rik van Riel <riel@redhat.com>
>> wrote:
>> > On Wed, 2017-07-26 at 09:47 -0400, Pankaj Gupta wrote:
>> > > >
>> > >
>> > > Just want to summarize here(high level):
>> > >
>> > > This will require implementing new 'virtio-pmem' device which
>> > > presents
>> > > a DAX address range(like pmem) to guest with read/write(direct
>> > > access)
>> > > & device flush functionality. Also, qemu should implement
>> > > corresponding
>> > > support for flush using virtio.
>> > >
>> >
>> > Alternatively, the existing pmem code, with
>> > a flush-only block device on the side, which
>> > is somehow associated with the pmem device.
>> >
>> > I wonder which alternative leads to the least
>> > code duplication, and the least maintenance
>> > hassle going forward.
>>
>> I'd much prefer to have another driver. I.e. a driver that refactors
>> out some common pmem details into a shared object and can attach to
>> ND_DEVICE_NAMESPACE_{IO,PMEM}. A control device on the side seems
>> like
>> a recipe for confusion.
>
> At that point, would it make sense to expose these special
> virtio-pmem areas to the guest in a slightly different way,
> so the regions that need virtio flushing are not bound by
> the regular driver, and the regular driver can continue to
> work for memory regions that are backed by actual pmem in
> the host?

Hmm, yes that could be feasible especially if it uses the ACPI NFIT
mechanism. It would basically involve defining a new SPA (System
Phyiscal Address) range GUID type, and then teaching libnvdimm to
treat that as a new pmem device type.

See usage of UUID_PERSISTENT_MEMORY in drivers/acpi/nfit/ and the
eventual region description sent to nvdimm_pmem_region_create(). We
would then need to plumb a new flag so that nd_region_to_nstype() in
libnvdimm returns a different namespace type number for this virtio
use case, but otherwise the rest of libnvdimm should treat the region
as pmem.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
