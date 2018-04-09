From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC] qemu: Add virtio pmem device
Date: Mon, 9 Apr 2018 08:42:35 +0200
Message-ID: <36218ea8-5fa8-e670-104d-616da790a333@redhat.com>
References: <20180405104834.10457-1-pagupta@redhat.com>
 <20180405104834.10457-4-pagupta@redhat.com>
 <ad08ca09-71ee-08d5-3479-8b3d06380a03@redhat.com>
 <416823501.16310251.1522930166070.JavaMail.zimbra@redhat.com>
 <20180409032601.GA1648@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180409032601.GA1648-lxVrvc10SDRcolVlb+j0YCZi+YwRKgec@public.gmane.org>
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
To: Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On 09.04.2018 05:26, Stefan Hajnoczi wrote:
> On Thu, Apr 05, 2018 at 08:09:26AM -0400, Pankaj Gupta wrote:
>>> Will this raw file already have the "disk information header" (no idea
>>> how that stuff is called) encoded? Are there any plans/possible ways to
>>>
>>> a) automatically create the headers? (if that's even possible)
>>
>> Its raw. Right now we are just supporting raw format.  
>>
>> As this is direct mapping of memory into guest address space, I don't
>> think we can have an abstraction of headers for block specific features.
>> Or may be we can get opinion of others(Qemu block people) it is at all possible?
> 
> memdev and the block layer are completely separate.  The block layer
> isn't designed for memory-mapped access.
> 

Not questioning if this is the right thing to do now. I was wondering if
we could expose any block device in the future as virtio-pmem. And I
think with quite some work it could be possible.

As you said, we will need some buffering. Maybe userfaultfd and friends
(WP) could allow to implement that.

> I think it makes sense to use memdev here.  If the user wants a block
> device, they should use an emulated block device, not virtio-pmem,
> because buffering is necessary anyway when an image file format is used.
> 
> Stefan
> 


-- 

Thanks,

David / dhildenb
