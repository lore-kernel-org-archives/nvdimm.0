Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <1435272910.11808.356.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 15/17] libnvdimm: Set numa_node to NVDIMM devices
From: Toshi Kani <toshi.kani@hp.com>
Date: Thu, 25 Jun 2015 16:55:10 -0600
In-Reply-To: <CAPcyv4hzUA71G8bmUt7OLXx0GMX-36gqQ-WHOjA7sj9z4pudCA@mail.gmail.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
	 <20150625093738.40066.88750.stgit@dwillia2-desk3.jf.intel.com>
	 <1435254317.11808.327.camel@misato.fc.hp.com>
	 <1435257283.13411.4.camel@intel.com>
	 <CAPcyv4jhDc1+TGyo4J6vC7bRBaGbfAXyLP2qB9X5DAJRBhCRyQ@mail.gmail.com>
	 <1435269103.11808.349.camel@misato.fc.hp.com>
	 <CAPcyv4gqgbEVWDKR4e8=Uaz1As4FxY4-8VHWKZfQ-vtc2wOs3g@mail.gmail.com>
	 <1435270287.11808.352.camel@misato.fc.hp.com>
	 <CAPcyv4hzUA71G8bmUt7OLXx0GMX-36gqQ-WHOjA7sj9z4pudCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-06-25 at 15:34 -0700, Dan Williams wrote:
> On Thu, Jun 25, 2015 at 3:11 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Thu, 2015-06-25 at 15:00 -0700, Dan Williams wrote:
> > Yes, I see no problem with bound BTTs and their device files.  So, how
> > do we bind BTT with this new version?
> >
> 
> # cd /sys/bus/nd/devices
> # uuidgen > btt6/uuid
> # echo 4096 > btt6/sector_size
> # echo namespace6.0 > btt6/namespace
> # echo namespace6.0 > ../drivers/nd_pmem/unbind
> # echo btt6 > ../drivers/nd_pmem/bind
> 
> After reboot, when the system sees namespace6.0 again it will notice
> the btt instance and attach bttX instead.  The net effect is that now
> you'll only ever have /dev/pmem6 or /dev/pmem6s, never both at the
> same time that was a side effect of the stacking approach.
> 
> I'll post the patch that updates libndctl and the unit tests shortly

Maybe I am missing something, but I am getting errors on my system.  (I
used btt0 since there is no btt6.)

# cat bind.sh
set -x
cd /sys/bus/nd/devices
uuidgen > btt0/uuid
echo 4096 > btt0/sector_size
echo namespace0.0 > btt0/namespace
echo namespace0.0 > ../drivers/nd_pmem/unbind
echo btt0 > ../drivers/nd_pmem/bind

# sh bind.sh
+ cd /sys/bus/nd/devices
+ uuidgen
+ echo 4096
+ echo namespace0.0
bind.sh: line 6: echo: write error: Device or resource busy
+ echo namespace0.0
bind.sh: line 7: echo: write error: No such device
+ echo btt0
bind.sh: line 8: echo: write error: No such device

# dmesg
 :
[12513.839162] nd btt0: uuid_store: result: 0 wrote:
b32cd195-9aae-4c54-a5ac-49adb50a8a98
[12513.880286] nd btt0: sector_size_store: result: 0 wrote: 4096
[12513.909494] nd btt0: namespace0.0 already claimed
[12513.933364] nd btt0: namespace_store: result: -16 wrote: namespace0.0
[12513.966808]  ndbus0: nd_pmem.probe(btt0) = -19

Thanks,
-Toshi

