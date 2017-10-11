From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC] KVM "fake DAX" device flushing
Date: Wed, 11 Oct 2017 12:22:41 -0700
Message-ID: <CAPcyv4iav2gjHR63UfZmzp5u6mZciszarqrn=QXnvf+zjjgEUg@mail.gmail.com>
References: <20171011185146.20295-1-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171011185146.20295-1-pagupta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pankaj Gupta <pagupta@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>, Stefan Hajnoczi <stefanha@redhat.com>, Rik van Riel <riel@redhat.com>, Haozhong Zhang <haozhong.zhang@intel.com>, Nitesh Narayan Lal <nilal@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Zwisler, Ross" <ross.zwisler@intel.com>, David Hildenbrand <david@redhat.com>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>
List-Id: linux-nvdimm@lists.01.org

On Wed, Oct 11, 2017 at 11:51 AM, Pankaj Gupta <pagupta@redhat.com> wrote:
> We are sharing the prototype version of 'fake DAX' flushing
> interface for the initial feedback. This is still work in progress
> and not yet ready for merging.
>
> Protoype right now just implements basic functionality without advanced
> features with two major parts:
>
> - Qemu virtio-pmem device
>   It exposes a persistent memory range to KVM guest which at host side is file
>   backed memory and works as persistent memory device. In addition to this it
>   provides a virtio flushing interface for KVM guest to do a Qemu side sync for
>   guest DAX persistent memory range.
>
> - Guest virtio-pmem driver
>   Reads persistent memory range from paravirt device and reserves system memory map.
>   It also allocates a block device corresponding to the pmem range which is accessed
>   by DAX capable file systems. (file system support is still pending).
>
> We shared the project idea for 'fake DAX' flushing interface here [1].
> Based on suggestions here [2], we implemented guest 'virtio-pmem'
> driver and Qemu paravirt device.
>
> [1] https://www.spinics.net/lists/kvm/msg149761.html
> [2] https://www.spinics.net/lists/kvm/msg153095.html
>
> Work yet to be done:
>
> - Separate out the common code used by ACPI pmem interface and
>   reuse it.
>
> - In pmem device memmap allocation and working. There is some parallel work
>   going on upstream related to 'memory_hotplug restructuring' [3] and also hitting
>   a memory section alignment issue [4].
>
>   [3] https://lwn.net/Articles/712099/
>   [4] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg02978.html
>
> - Provide DAX capable file-system(ext4 & XFS) support.
> - Qemu device flush functionality.
> - Qemu live migration work when host page cache is used.
> - Multiple virtio-pmem disks support.
>
> Prototype implementation for feedback:
>
> Kernel: https://github.com/pagupta/linux/commit/d15cf90074eae91aeed7a228da3faf319566dd40

Please send this as a patch so it can be reviewed over email.
