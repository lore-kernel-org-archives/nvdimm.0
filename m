From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC] qemu: Add virtio pmem device
Date: Thu, 5 Apr 2018 14:19:25 +0200
Message-ID: <782ac7e2-b8d9-139d-6182-cb4e2d082458@redhat.com>
References: <20180405104834.10457-1-pagupta@redhat.com>
 <20180405104834.10457-4-pagupta@redhat.com>
 <ad08ca09-71ee-08d5-3479-8b3d06380a03@redhat.com>
 <416823501.16310251.1522930166070.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <416823501.16310251.1522930166070.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


>>
>> So right now you're just using some memdev for testing.
> 
> yes.
> 
>>
>> I assume that the memory region we will provide to the guest will be a
>> simple memory mapped raw file. Dirty tracking (using the kvm slot) will
>> be used to detect which blocks actually changed and have to be flushed
>> to disk.
> 
> Not really, we will perform fsync on raw file. As this file is created
> on regular storage and not nvdimm, so host page cache radix tree would have 
> the dirty pages information which will be used for fsync.

Ah right. That makes things a lot easier!

>    
>>
>> Will this raw file already have the "disk information header" (no idea
>> how that stuff is called) encoded? Are there any plans/possible ways to
>>
>> a) automatically create the headers? (if that's even possible)
> 
> Its raw. Right now we are just supporting raw format.  
> 
> As this is direct mapping of memory into guest address space, I don't
> think we can have an abstraction of headers for block specific features.
> Or may be we can get opinion of others(Qemu block people) it is at all possible?
> 
>> b) support anything but raw files?
>>
>> Please note that under x86, a KVM memory slot still has a (in my
>> opinion) fairly big overhead depending on the size of the slot (rmap,
>> page_track). We might have to optimize that.
> 
> I have not tried/observed this. Right now I just used single memory slot and cold add
> few MB's of memory in Qemu. Can you please provide more details on this?
> 

You can have a look at kvm_arch_create_memslot() in arch/x86/kvm/x86.c.

"npages" is used to allocate certain arrays (rmap for shadow page
tables). Also kvm_page_track_create_memslot() allocates data for page_track.

Having a big disk involves a lot of memory overhead due to the big kvm
memory slot. This is already the case for NVDIMMs as of now.

Other architectures (e.g. s390x) don't have this "problem". They don't
allocate any such data depending on the size of a memory slot.

This is certainly something to work on in the future.

-- 

Thanks,

David / dhildenb
