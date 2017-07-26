Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <1501104453.26846.45.camel@redhat.com>
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
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 14:40:36 -0700
Message-ID: <CAPcyv4hsqrqBxoipUHPAbSctuzbVWCRnT-gN08i9uhXTWY6iPQ@mail.gmail.com>
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

On Wed, Jul 26, 2017 at 2:27 PM, Rik van Riel <riel@redhat.com> wrote:
> On Wed, 2017-07-26 at 09:47 -0400, Pankaj Gupta wrote:
>> >
>> Just want to summarize here(high level):
>>
>> This will require implementing new 'virtio-pmem' device which
>> presents
>> a DAX address range(like pmem) to guest with read/write(direct
>> access)
>> & device flush functionality. Also, qemu should implement
>> corresponding
>> support for flush using virtio.
>>
> Alternatively, the existing pmem code, with
> a flush-only block device on the side, which
> is somehow associated with the pmem device.
>
> I wonder which alternative leads to the least
> code duplication, and the least maintenance
> hassle going forward.

I'd much prefer to have another driver. I.e. a driver that refactors
out some common pmem details into a shared object and can attach to
ND_DEVICE_NAMESPACE_{IO,PMEM}. A control device on the side seems like
a recipe for confusion.

With a $new_driver in hand you can just do:

   modprobe $new_driver
   echo $namespace > /sys/bus/nd/drivers/nd_pmem/unbind
   echo $namespace > /sys/bus/nd/drivers/$new_driver/new_id
   echo $namespace > /sys/bus/nd/drivers/$new_driver/bind

...and the guest can arrange for $new_driver to be the default, so you
don't need to do those steps each boot of the VM, by doing:

    echo "blacklist nd_pmem" > /etc/modprobe.d/virt-dax-flush.conf
    echo "alias nd:t4* $new_driver" >> /etc/modprobe.d/virt-dax-flush.conf
    echo "alias nd:t5* $new_driver" >> /etc/modprobe.d/virt-dax-flush.conf
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
