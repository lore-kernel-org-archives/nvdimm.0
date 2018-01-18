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
From: David Hildenbrand <david@redhat.com>
Message-ID: <f1ca60cc-5506-a161-b473-f0de363b7e95@redhat.com>
Date: Thu, 18 Jan 2018 17:53:03 +0100
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
To: Pankaj Gupta <pagupta@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Rik van Riel <riel@redhat.com>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Christoph Hellwig <hch@infradead.org>
Cc: Kevin Wolf <kwolf@redhat.com>, Jan Kara <jack@suse.cz>, kvm-devel <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 24.11.2017 13:40, Pankaj Gupta wrote:
> 
> Hello,
> 
> Thank you all for all the useful suggestions.
> I want to summarize the discussions so far in the
> thread. Please see below:
> 
>>>>
>>>>> We can go with the "best" interface for what
>>>>> could be a relatively slow flush (fsync on a
>>>>> file on ssd/disk on the host), which requires
>>>>> that the flushing task wait on completion
>>>>> asynchronously.
>>>>
>>>>
>>>> I'd like to clarify the interface of "wait on completion
>>>> asynchronously" and KVM async page fault a bit more.
>>>>
>>>> Current design of async-page-fault only works on RAM rather
>>>> than MMIO, i.e, if the page fault caused by accessing the
>>>> device memory of a emulated device, it needs to go to
>>>> userspace (QEMU) which emulates the operation in vCPU's
>>>> thread.
>>>>
>>>> As i mentioned before the memory region used for vNVDIMM
>>>> flush interface should be MMIO and consider its support
>>>> on other hypervisors, so we do better push this async
>>>> mechanism into the flush interface design itself rather
>>>> than depends on kvm async-page-fault.
>>>
>>> I would expect this interface to be virtio-ring based to queue flush
>>> requests asynchronously to the host.
>>
>> Could we reuse the virtio-blk device, only with a different device id?
> 
> As per previous discussions, there were suggestions on main two parts of the project:
> 
> 1] Expose vNVDIMM memory range to KVM guest.
> 
>    - Add flag in ACPI NFIT table for this new memory type. Do we need NVDIMM spec 
>      changes for this? 
> 
>    - Guest should be able to add this memory in system memory map. Name of the added memory in
>      '/proc/iomem' should be different(shared memory?) than persistent memory as it 
>      does not satisfy exact definition of persistent memory (requires an explicit flush).
> 
>    - Guest should not allow 'device-dax' and other fancy features which are not 
>      virtualization friendly.
> 
> 2] Flushing interface to persist guest changes.
> 
>    - As per suggestion by ChristophH (CCed), we explored options other then virtio like MMIO etc.
>      Looks like most of these options are not use-case friendly. As we want to do fsync on a
>      file on ssd/disk on the host and we cannot make guest vCPU's wait for that time. 
> 
>    - Though adding new driver(virtio-pmem) looks like repeated work and not needed so we can 
>      go with the existing pmem driver and add flush specific to this new memory type.

I'd like to emphasize again, that I would prefer a virtio-pmem only
solution.

There are architectures out there (e.g. s390x) that don't support
NVDIMMs - there is no HW interface to expose any such stuff.

However, with virtio-pmem, we could make it work also on architectures
not having ACPI and friends.

> 
>    - Suggestion by Paolo & Stefan(previously) to use virtio-blk makes sense if just 
>      want a flush vehicle to send guest commands to host and get reply after asynchronous
>      execution. There was previous discussion [1] with Rik & Dan on this.
> 
>     [1] https://lists.gnu.org/archive/html/qemu-devel/2017-07/msg08373.html 
> 
> Is my understanding correct here?
> 
> Thanks,
> Pankaj  
>  
> 


-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
