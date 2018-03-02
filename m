Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5450D2250EDC4
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 08:16:19 -0800 (PST)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Fri, 2 Mar 2018 16:22:24 +0000
Message-ID: <1520010446.2693.19.camel@hpe.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <CAPcyv4h7mcFphv3j_vW-CGxXa2pjQgLqpBOLzHuTzAFzygai-Q@mail.gmail.com>
 <1519936477.4592.23.camel@au1.ibm.com>
 <1519936815.4592.25.camel@au1.ibm.com> <20180301205315.GJ19007@ziepe.ca>
 <1519942012.4592.31.camel@au1.ibm.com>
 <CA+55aFy-oAiFJ3WDx4giR1enj65y-YJnZZhY6geFw0ygFyKXfQ@mail.gmail.com>
 <1519943658.4592.34.camel@kernel.crashing.org>
In-Reply-To: <1519943658.4592.34.camel@kernel.crashing.org>
Content-Language: en-US
Content-ID: <A740CC14662A0948A822E31824F31125@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "keith.busch@intel.com" <keith.busch@intel.com>, "oliveroh@au1.ibm.com" <oliveroh@au1.ibm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jglisse@redhat.com" <jglisse@redhat.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "maxg@mellanox.com" <maxg@mellanox.com>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2018-03-02 at 09:34 +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2018-03-01 at 14:31 -0800, Linus Torvalds wrote:
> > On Thu, Mar 1, 2018 at 2:06 PM, Benjamin Herrenschmidt <benh@au1.ibm.com> wrote:
> > > 
> > > Could be that x86 has the smarts to do the right thing, still trying to
> > > untangle the code :-)
> > 
> > Afaik, x86 will not cache PCI unless the system is misconfigured, and
> > even then it's more likely to just raise a machine check exception
> > than cache things.
> > 
> > The last-level cache is going to do fills and spills directly to the
> > memory controller, not to the PCIe side of things.
> > 
> > (I guess you *can* do things differently, and I wouldn't be surprised
> > if some people inside Intel did try to do things differently with
> > trying nvram over PCIe, but in general I think the above is true)
> > 
> > You won't find it in the kernel code either. It's in hardware with
> > firmware configuration of what addresses are mapped to the memory
> > controllers (and _how_ they are mapped) and which are not.
> 
> Ah thanks ! Thanks explains. We can fix that on ppc64 in our linear
> mapping code by checking the address vs. memblocks to chose the right
> page table attributes.

FWIW, this thing is called MTRRs on x86, which are initialized by BIOS.
These registers effectively overwrite page table setups.  Intel SDM
defines the effect as follows.  'PAT Entry Value' is the page table
setup.

MTRR Memory Type  PAT Entry Value  Effective Memory Type
--------------------------------------------------------
UC                UC               UC
UC                WC               WC
UC                WT               UC
UC                WB               UC
UC                WP               UC 

On my system, BIOS sets MTRRs to cover the entire MMIO ranges with UC.
Other BIOSes may simply set the MTRR default type to UC, i.e. uncovered
ranges become UC.

# cat /proc/mtrr
 :
reg01: base=0xc0000000000 (12582912MB), size=2097152MB, count=1:
uncachable
 :

# cat /proc/iomem | grep 'PCI Bus'
 :
c0000000000-c3fffffffff : PCI Bus 0000:00
c4000000000-c7fffffffff : PCI Bus 0000:11
c8000000000-cbfffffffff : PCI Bus 0000:36
cc000000000-cffffffffff : PCI Bus 0000:5b
d0000000000-d3fffffffff : PCI Bus 0000:80
d4000000000-d7fffffffff : PCI Bus 0000:85
d8000000000-dbfffffffff : PCI Bus 0000:ae
dc000000000-dffffffffff : PCI Bus 0000:d7

-Toshi


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
