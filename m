Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F830D4.7030205@plexistor.com>
Date: Thu, 05 Mar 2015 12:32:52 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [RFC 0/8] pmem: Submission of the Persistent memory block device
References: <54F82CE0.4040502@plexistor.com>
In-Reply-To: <54F82CE0.4040502@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>


There are already NvDIMMs and other Persistent-memory devices in the market, and
lots more of them will be coming in near future.

Current stack is coming along very nice, and filesystems support for leveraging this
technologies has been submitted to Linus in the DAX series by Matthew Wilcox.

The general stack does not change:
	block-device
	partition
	file-system
	application file

The only extra care, see Matthew's DAX patches, Is the ->direct_access() API from
block devices that enables a direct mapping from Persistent-memory to user application
and/or Kernel for direct store/load of data.

The only missing piece is the actual block device that enables support
for such NvDIMM chips. This is the driver we submit here.

The driver is very simple, in fact it is the 2nd smallest driver inside drivers/block
What the driver does is support a physical contiguous iomem range as a single block
device. The driver has support for as many as needed iomem ranges each as its own device.
(See patch-1 for more details)

We are using this driver over a year now, In a lab with combination of VMs and real
hardware, with a variety of hardware and vendors, and it is very stable. Actually why
not it is so simple it does nothing almost.

The driver is not only good for NvDIMMs, It is good for any flat memory mapped
device. We've used it with NvDIMMs, Kernel reserved DRAM (memmap= on command line),
PCIE Battery backed memory cards, VM shared memory, and so on.

Together with this driver also submitted support for page-struct with
Persistent-memory, so Persistent-memory can be used with RDMA, DMA, block-devices
and so on, just as regular memory, in a copy-less manner.
With the use of these two simple patches, we were able to set up an RDMA target
machine which exports NvDIMMs and enables direct remote storage. The only
"complicated" thing was the remote flush of caches because most RDMA nicks in
Kernel will RDMA directly to L3 cache, so we needed to establish a message that
involves the remote CPU for this. But otherwise the mapping of pmem pointer
to an RDMA key was trivial, directly from user-mode, with no extra Kernel code.
[The target is simple with no extra code, the RDMA client on the other hand needs
 a special driver]

I maintain these patches on latest Kernels here:
	git://git.open-osd.org/pmem.git branch pmem

Thanks for reviewing
Boaz

