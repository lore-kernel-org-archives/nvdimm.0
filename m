From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC] KVM "fake DAX" device flushing
Date: Thu, 12 Oct 2017 00:21:46 +0530
Message-ID: <20171011185146.20295-1-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

We are sharing the prototype version of 'fake DAX' flushing
interface for the initial feedback. This is still work in progress
and not yet ready for merging.

Protoype right now just implements basic functionality without advanced
features with two major parts:

- Qemu virtio-pmem device
  It exposes a persistent memory range to KVM guest which at host side is file
  backed memory and works as persistent memory device. In addition to this it
  provides a virtio flushing interface for KVM guest to do a Qemu side sync for
  guest DAX persistent memory range.  

- Guest virtio-pmem driver
  Reads persistent memory range from paravirt device and reserves system memory map.
  It also allocates a block device corresponding to the pmem range which is accessed
  by DAX capable file systems. (file system support is still pending).  
  
We shared the project idea for 'fake DAX' flushing interface here [1].
Based on suggestions here [2], we implemented guest 'virtio-pmem'
driver and Qemu paravirt device.

[1] https://www.spinics.net/lists/kvm/msg149761.html
[2] https://www.spinics.net/lists/kvm/msg153095.html

Work yet to be done:

- Separate out the common code used by ACPI pmem interface and
  reuse it.

- In pmem device memmap allocation and working. There is some parallel work
  going on upstream related to 'memory_hotplug restructuring' [3] and also hitting
  a memory section alignment issue [4].
  
  [3] https://lwn.net/Articles/712099/
  [4] https://www.mail-archive.com/linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org/msg02978.html
  
- Provide DAX capable file-system(ext4 & XFS) support.
- Qemu device flush functionality.
- Qemu live migration work when host page cache is used.
- Multiple virtio-pmem disks support.

Prototype implementation for feedback:

Kernel: https://github.com/pagupta/linux/commit/d15cf90074eae91aeed7a228da3faf319566dd40
Qemu  : https://github.com/pagupta/qemu/commit/9c428db1e1076970e097e2b0ef8afe52509af823

Please provide feedback. Also, I would be attending KVM Forum in Prague from (25-27 Oct). 
If you are attending KVM forum/Linux conference, I would love to have a discussion on ideas 
and future work.

Thank you,
Pankaj Gupta
