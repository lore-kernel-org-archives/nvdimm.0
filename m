Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
References: <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <CAPcyv4jVDC=8AbVa9v6LcXm9n8QHgizv_+gQJC4RTd-wtTESWQ@mail.gmail.com>
 <20161123232503.GA13965@obsidianresearch.com>
 <a33ec1cd-051f-8a24-0587-68707459c25c@amd.com>
 <5e1de9ee-34f5-136d-a07e-f949d492864f@deltatee.com>
 <c60815a1-aaac-52eb-1714-66abb28bdc01@amd.com>
 <209107c7-3098-ca70-7d62-b55021d01faa@deltatee.com>
 <ea52d962-6c8e-92d9-eb1b-3ace4bf56126@amd.com>
From: Felix Kuehling <felix.kuehling@amd.com>
Message-ID: <fa44af1c-0c8a-7726-5100-a1f74f824a21@amd.com>
Date: Fri, 25 Nov 2016 15:26:45 -0500
MIME-Version: 1.0
In-Reply-To: <ea52d962-6c8e-92d9-eb1b-3ace4bf56126@amd.com>
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
To: Serguei Sagalovitch <serguei.sagalovitch@amd.com>, Logan Gunthorpe <logang@deltatee.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Blinzer,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Ben  <ben.sander@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 16-11-25 12:20 PM, Serguei Sagalovitch wrote:
>
>> A white list may end up being rather complicated if it has to cover
>> different CPU generations and system architectures. I feel this is a
>> decision user space could easily make.
>>
>> Logan
> I agreed that it is better to leave up to user space to check what is
> working
> and what is not. I found that write is practically always working but
> read very
> often not. Also sometimes system BIOS update could fix the issue.
>
But is user mode always aware that P2P is going on or even possible? For
example you may have a library reading a buffer from a file, but it
doesn't necessarily know where that buffer is located (system memory,
VRAM, ...) and it may not know what kind of the device the file is on
(SATA drive, NVMe SSD, ...). The library will never know if all it gets
is a pointer and a file descriptor.

The library ends up calling a read system call. Then it would be up to
the kernel to figure out the most efficient way to read the buffer from
the file. If supported, it could use P2P between a GPU and NVMe where
the NVMe device performs a DMA write to VRAM.

If you put the burden of figuring out the P2P details on user mode code,
I think it will severely limit the use cases that actually take
advantage of it. You also risk a bunch of different implementations that
get it wrong half the time on half the systems out there.

Regards,
  Felix


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
