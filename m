Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E3E802007E818
 for <linux-nvdimm@lists.01.org>; Thu, 24 May 2018 07:08:12 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id l22-v6so2084463otj.0
 for <linux-nvdimm@lists.01.org>; Thu, 24 May 2018 07:08:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180524161922.EC59.E1E9C6FF@jp.fujitsu.com>
References: <20180523140809.622F.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4g3pMV54bYwOOeMiFbi2swi5v9RTrBh8-_mtGpoOiw5XQ@mail.gmail.com>
 <20180524161922.EC59.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 May 2018 07:08:10 -0700
Message-ID: <CAPcyv4h3RHymfKXxebBf+4DJs7vyJyhOVOuhDUJtchBnGOFrDw@mail.gmail.com>
Subject: Re: Questions about vNVDIMM on qemu/KVM
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Qemu Developers <qemu-devel@nongnu.org>, NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 24, 2018 at 12:19 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> On Tue, May 22, 2018 at 10:08 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> > Hello,
>> >
>> > I'm investigating status of vNVDIMM on qemu/KVM,
>> > and I have some questions about it. I'm glad if anyone answer them.
>> >
>> > In my understanding, qemu/KVM has a feature to show NFIT for guest,
>> > and it will be still updated about platform capability with this patch set.
>> > https://lists.gnu.org/archive/html/qemu-devel/2018-05/msg04756.html
>> >
>> > And libvirt also supports this feature with <memory model='nvdimm'>
>> > https://libvirt.org/formatdomain.html#elementsMemory
>> >
>> >
>> > However, virtio-pmem is developing now, and it is better
>> > for archtectures to detect regions of NVDIMM without ACPI (like s390x)
>>
>> I think you are confusing virtio-pmem (patches from Pankaj) and
>> virtio-mem (patches from David)? ...or I'm confused.
>
> Probably, "I" am confusing.
> So, your clarification is very helpful for me.
>
>
>>
>> > In addition, It is also necessary to flush guest contents on vNVDIMM
>> > who has a backend-file.
>>
>> virtio-pmem is a mechanism to use host page cache as pmem in a guest.
>> It does not support high performance memory applications because it
>> requires fsync/msync. I.e. it is not DAX it is the traditional mmap
>> I/O model, but moving page cache management to the host rather than
>> duplicating it in guests.
>
> Ah, ok.
>
>
>>
>> > Q1) Does ACPI.NFIT bus of qemu/kvm remain with virtio-pmem?
>> >     How do each roles become it if both NFIT and virtio-pmem will be available?
>> >     If my understanding is correct, both NFIT and virtio-pmem is used to
>> >     detect vNVDIMM regions, but only one seems to be necessary....
>>
>> We need both because they are different. Guest DAX should not be using
>> virtio-pmem.
>
> Hmm. Ok.
>
> But ,I would like understand one more thing.
> In the following mail, it seems that e820 bus will be used for fake DAX.
>
> https://lists.01.org/pipermail/linux-nvdimm/2018-January/013926.html
>
> Could you tell me what is relationship between "fake DAX" in this mail
> and Guest DAX?
> Why e820 is necessary for this case?
>

It was proposed as a starting template for writing a new nvdimm bus
driver. All we need is a way to communicate both the address range and
the flush interface. This could be done with a new SPA Range GUID with
the NFIT, or a custom virtio-pci device that registers a special
nvdimm region with this property. My preference is whichever approach
minimizes the code duplication, because the pmem driver should be
re-used as much as possible.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
