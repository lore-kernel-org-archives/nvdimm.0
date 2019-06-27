Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190627141953.GC3624@swarm07>
In-Reply-To: <20190627141953.GC3624@swarm07>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Jun 2019 14:22:42 -0700
Message-ID: <CAPcyv4h=MoP4GSF8xRULy54K7Rt9g2pnF3Xw0BNPRyYf5fKs0A@mail.gmail.com>
Subject: Re: A write error on converting dax0.0 to kmem
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: heysid@ajou.ac.kr
Cc: Dave Hansen <dave.hansen@intel.com>, Linux MM <linux-mm@kvack.org>, jsahn@ajou.ac.kr, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

[ this is on-topic for linux-nvdimm, but likely off-topic for
linux-mm. I leave it cc'd for now ]

On Thu, Jun 27, 2019 at 7:20 AM Won-Kyo Choe <heysid@ajou.ac.kr> wrote:
>
> Hi, Dave. I hope this message is sent appropriately in this time.
>
> We've recently got a new machine which contains Optane DC memory and
> tried to use your patch set[1] in a recent kernel version(5.1.15).
> Unfortunately, we've failed on the last step[2] that describes
> converting device-dax driver as kmem. The main error is "echo: write error: No such device".
> We are certain that there must be a device and it should be recognized
> since we can see it in a path "/dev/dax0.0", however, somehow it keeps saying that error.
>
> We've followed all your steps in the first patch[1] except a step about qemu configuration
> since we already have a persistent memory. We even checked that there is a region
> mapped with persistent memory from a command, `dmesg | grep e820` described in below.
>
> BIOS-e820: [mem 0x0000000880000000-0x00000027ffffffff] persistent (type 7)
>
> As the address is shown above, the thing is that in the qemu, the region is set as
> persistent (type 12) but in the native machine, it says persistent (type 7).
> We've still tried to find what type means and we simply guess that this is one
> of the reasons why we are not able to set the device as kmem.
>
> We'd like to know why this error comes up and how can we handle this problem.
> We would really appreciate it if you are able to little bit help us.

Before digging deeper let's first verify that you have switched
device-dax from using "class" devices to using "bus" devices. Yes,
that step is not included in the changelog instructions. Here is a man
page for a tool that can automate some of the steps for you:

http://pmem.io/ndctl/daxctl-migrate-device-model.html

You can validate that you're in "bus" mode by making sure a "dax0.0"
link appears under "/sys/bus/dax/devices".
