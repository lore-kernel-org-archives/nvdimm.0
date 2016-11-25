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
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <c60815a1-aaac-52eb-1714-66abb28bdc01@amd.com>
Date: Fri, 25 Nov 2016 14:06:21 +0100
MIME-Version: 1.0
In-Reply-To: <5e1de9ee-34f5-136d-a07e-f949d492864f@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Blinzer,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Ben  <ben.sander@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Am 24.11.2016 um 18:55 schrieb Logan Gunthorpe:
> Hey,
>
> On 24/11/16 02:45 AM, Christian K=F6nig wrote:
>> E.g. it can happen that PCI device A exports it's BAR using ZONE_DEVICE.
>> Not PCI device B (a SATA device) can directly read/write to it because
>> it is on the same bus segment, but PCI device C (a network card for
>> example) can't because it is on a different bus segment and the bridge
>> can't handle P2P transactions.
> Yeah, that could be an issue but in our experience we have yet to see
> it. We've tested with two separate PCI buses on different CPUs connected
> through QPI links and it works fine. (It is rather slow but I understand
> Intel has improved the bottleneck in newer CPUs than the ones we tested.)

Well Serguei send me a couple of documents about QPI when we started to =

discuss this internally as well and that's exactly one of the cases I =

had in mind when writing this.

If I understood it correctly for such systems P2P is technical possible, =

but not necessary a good idea. Usually it is faster to just use a =

bouncing buffer when the peers are a bit "father" apart.

That this problem is solved on newer hardware is good, but doesn't helps =

us at all if we at want to support at least systems from the last five =

years or so.

> It may just be older hardware that has this issue. I expect that as long
> as a failed transfer can be handled gracefully by the initiator I don't
> see a need to predetermine whether a device can see another devices memor=
y.

I don't want to predetermine whether a device can see another devices =

memory at get_user_pages() time.

My thinking was more going into the direction of a whitelist to figure =

out during dma_map_single()/dma_map_sg() time if we should use a =

bouncing buffer or not.

Christian.

>
>
> Logan


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
