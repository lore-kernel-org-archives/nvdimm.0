Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: KVM "fake DAX" flushing interface - discussion
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <d1df875c-5b64-67d9-2b3c-4ec14c03b85b@gmail.com>
 <CAPcyv4ip6m6e9Bh7weJNB3m3kpDpRkhHDZf0JYyr5UbkD41oLg@mail.gmail.com>
 <654f8935-258e-22ef-fae4-3e14e91e8fae@redhat.com>
 <336152896.34452750.1511527207457.JavaMail.zimbra@redhat.com>
 <f1ca60cc-5506-a161-b473-f0de363b7e95@redhat.com>
 <CAPcyv4j9b6ARvKcJkE25eNHatWACscMJTN_kCLSM6D+bfu_msA@mail.gmail.com>
 <72839100-7fdf-693c-e9c2-348a5add8a56@redhat.com>
 <1419599412.1747020.1516301689815.JavaMail.zimbra@redhat.com>
 <CAPcyv4hso5FYCyxYBHRhHvsU+M_wrkQBwVKurK-i6BQYzQduPw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <7b0c4b68-2b37-b20c-b20d-7de35e50ad2a@redhat.com>
Date: Thu, 18 Jan 2018 20:51:25 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hso5FYCyxYBHRhHvsU+M_wrkQBwVKurK-i6BQYzQduPw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Pankaj Gupta <pagupta@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, Rik van Riel <riel@surriel.com>, Stefan Hajnoczi <stefanha@gmail.com>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Christoph Hellwig <hch@infradead.org>, Stefan Hajnoczi <stefanha@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>


>> 1] Existing pmem driver & virtio for region discovery:
>>   -----------------------------------------------------
>>   Use existing pmem driver which is tightly coupled with concepts of namespaces, labels etc
>>   from ACPI region discovery and re-implement these concepts with virtio so that existing
>>   pmem driver can understand it. In addition to this, task of pmem driver to send flush command
>>   using virtio.
> 
> It's not tightly coupled. The whole point of libnvdimm is to be
> agnostic to ACPI, e820 or any other range discovery. The only work to
> do beyond identifying the address range is teaching libnvdimm to pass
> along a flush control interface to the pmem driver.
> 
>>
>> 2] Existing pmem driver & ACPI NFIT for region discovery:
>>   ----------------------------------------------------------------
>> - If we use NFIT ACPI, we need to teach existing ACPI driver to add this new memory
>>   type and teach existing pmem driver to handle this new memory type. Still we need
>>   an asynchronous(virtio) way to send flush commands. We need virtio device/driver
>>   or arbitrary key/value like pair just to send commands from guest to host using virtio.
>>
>> 3] New Virtio pmem driver & paravirt device:
>>  ----------------------------------------
>>   Third way is new virtio pmem driver with less work to support existing features of different protocols,
>>   and with asynchronous way of sending flush commands.
>>
>>   But this needs to duplicate some of the work which existing pmem driver does but as discussed
>>   previously we can separate common code from existing pmem driver and reuse it.
>>
>> Among these approaches I also prefer 3].
> 
> I disagree, the reason we went down this ACPI path was to limit the
> needless duplication of most of the pmem driver.
> 

I have way to little insight to make qualified statements to different
approaches here. :)

All I am interesting in is making this as independent of architecture
specific technologies (e.g. ACPI) as possible. We will want this e.g.
for s390x too. Rather sooner than later. So trying to couple this
(somehow) to ACPI just for the sake of less code to copy will not pay of
in the long run.

Better have a clean virtio interface / design right from the start.

So I hope my words will be heard :)

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
