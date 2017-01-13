Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
References: <20170105201935.GC2166@redhat.com>
 <20170105224215.GA3855@obsidianresearch.com>
 <20170105232352.GB6426@redhat.com>
 <20170106003034.GB4670@obsidianresearch.com>
 <20170106015831.GA2226@gmail.com>
 <f07700d5-211f-d091-2b0b-fbaf03c4a959@amd.com>
 <20170106173722.GB3804@redhat.com>
 <20170106182625.GB5724@obsidianresearch.com>
 <2a148b6e-86bc-4c4d-2f22-d733e2cc94cc@deltatee.com>
 <d5a72e1e5f6d606697dc0027f073fd87.squirrel@webmail.raithlin.com>
 <20170112151129.GA10942@redhat.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <0733efde-1a6e-5237-0868-e9fb31f237c7@amd.com>
Date: Fri, 13 Jan 2017 14:04:30 +0100
MIME-Version: 1.0
In-Reply-To: <20170112151129.GA10942@redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jerome Glisse <jglisse@redhat.com>, Stephen Bates <sbates@raithlin.com>
Cc: david1.zhou@amd.com, hch@infradead.org, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <felix.kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>, "Blinzer, " Paul" <paul.blinzer@amd.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>," qiang.yu@amd.com, "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>, "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, "Deucher, Alexander  <alexander.deucher@amd.com>, Jerome Glisse <j.glisse@gmail.com>, Sander, Ben" <ben.sander@amd.com>, "'Linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Am 12.01.2017 um 16:11 schrieb Jerome Glisse:
> On Wed, Jan 11, 2017 at 10:54:39PM -0600, Stephen Bates wrote:
>> On Fri, January 6, 2017 4:10 pm, Logan Gunthorpe wrote:
>>>
>>> On 06/01/17 11:26 AM, Jason Gunthorpe wrote:
>>>
>>>
>>>> Make a generic API for all of this and you'd have my vote..
>>>>
>>>>
>>>> IMHO, you must support basic pinning semantics - that is necessary to
>>>> support generic short lived DMA (eg filesystem, etc). That hardware can
>>>> clearly do that if it can support ODP.
>>> I agree completely.
>>>
>>>
>>> What we want is for RDMA, O_DIRECT, etc to just work with special VMAs
>>> (ie. at least those backed with ZONE_DEVICE memory). Then
>>> GPU/NVME/DAX/whatever drivers can just hand these VMAs to userspace
>>> (using whatever interface is most appropriate) and userspace can do what
>>> it pleases with them. This makes _so_ much sense and actually largely
>>> already works today (as demonstrated by iopmem).
>> +1 for iopmem ;-)
>>
>> I feel like we are going around and around on this topic. I would like to
>> see something that is upstream that enables P2P even if it is only the
>> minimum viable useful functionality to begin. I think aiming for the moon
>> (which is what HMM and things like it are) are simply going to take more
>> time if they ever get there.
>>
>> There is a use case for in-kernel P2P PCIe transfers between two NVMe
>> devices and between an NVMe device and an RDMA NIC (using NVMe CMBs or
>> BARs on the NIC). I am even seeing users who now want to move data P2P
>> between FPGAs and NVMe SSDs and the upstream kernel should be able to
>> support these users or they will look elsewhere.
>>
>> The iopmem patchset addressed all the use cases above and while it is not
>> an in kernel API it could have been modified to be one reasonably easily.
>> As Logan states the driver can then choose to pass the VMAs to user-space
>> in a manner that makes sense.
>>
>> Earlier in the thread someone mentioned LSF/MM. There is already a
>> proposal to discuss this topic so if you are interested please respond to
>> the email letting the committee know this topic is of interest to you [1=
].
>>
>> Also earlier in the thread someone discussed the issues around the IOMMU.
>> Given the known issues around P2P transfers in certain CPU root complexes
>> [2] it might just be a case of only allowing P2P when a PCIe switch
>> connects the two EPs. Another option is just to use CONFIG_EXPERT and ma=
ke
>> sure people are aware of the pitfalls if they invoke the P2P option.
>
> iopmem is not applicable to GPU what i propose is to split the issue in 2
> so that everyone can reuse the part that needs to be common namely the DMA
> API part where you have to create IOMMU mapping for one device to point
> to the other device memory.
>
> We can have a DMA API that is agnostic to how the device memory is manage
> (so does not matter if device memory have struct page or not). This what
> i have been arguing in this thread. To make progress on this issue we need
> to stop conflicting different use case.
>
> So i say let solve the IOMMU issue first and let everyone use it in their
> own way with their device. I do not think we can share much more than
> that.

Yeah, exactly what I said from the very beginning as well. Just hacking =

together quick solutions doesn't really solve the problem in the long term.

What we need is proper adjusting of the DMA API towards handling of P2P =

and then build solutions for the different use cases on top of that.

We should also avoid falling into the trap of trying to just handle the =

existing get_user_pages and co interfaces so that the existing code =

doesn't need to change. P2P needs to be validated for each use case =

individually and not implemented in workarounds with fingers crossed and =

hoped for the best.

Regards,
Christian.

>
> Cheers,
> J=E9r=F4me


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
