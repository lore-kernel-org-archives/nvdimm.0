From: Igor Mammedov <imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC v2 0/2] kvm "fake DAX" device flushing
Date: Fri, 1 Jun 2018 14:24:10 +0200
Message-ID: <20180601142410.5c986f13@redhat.com>
References: <20180425112415.12327-1-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180425112415.12327-1-pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, 25 Apr 2018 16:54:12 +0530
Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

[...]
> - Qemu virtio-pmem device
>   It exposes a persistent memory range to KVM guest which 
>   at host side is file backed memory and works as persistent 
>   memory device. In addition to this it provides virtio 
>   device handling of flushing interface. KVM guest performs
>   Qemu side asynchronous sync using this interface.
a random high level question,
Have you considered using a separate (from memory itself)
virtio device as controller for exposing some memory, async flushing.
And then just slaving pc-dimm devices to it with notification/ACPI
code suppressed so that guest won't touch them?

That way it might be more scale-able, you consume only 1 PCI slot
for controller vs multiple for virtio-pmem devices.


> Changes from previous RFC[1]:
> 
> - Reuse existing 'pmem' code for registering persistent 
>   memory and other operations instead of creating an entirely 
>   new block driver.
> - Use VIRTIO driver to register memory information with 
>   nvdimm_bus and create region_type accordingly. 
> - Call VIRTIO flush from existing pmem driver.
> 
> Details of project idea for 'fake DAX' flushing interface is 
> shared [2] & [3].
> 
> Pankaj Gupta (2):
>    Add virtio-pmem guest driver
>    pmem: device flush over VIRTIO
> 
> [1] https://marc.info/?l=linux-mm&m=150782346802290&w=2
> [2] https://www.spinics.net/lists/kvm/msg149761.html
> [3] https://www.spinics.net/lists/kvm/msg153095.html  
> 
>  drivers/nvdimm/region_devs.c     |    7 ++
>  drivers/virtio/Kconfig           |   12 +++
>  drivers/virtio/Makefile          |    1 
>  drivers/virtio/virtio_pmem.c     |  118 +++++++++++++++++++++++++++++++++++++++
>  include/linux/libnvdimm.h        |    4 +
>  include/uapi/linux/virtio_ids.h  |    1 
>  include/uapi/linux/virtio_pmem.h |   58 +++++++++++++++++++
>  7 files changed, 201 insertions(+)
> 
