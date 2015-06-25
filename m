Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1435270287.11808.352.camel@misato.fc.hp.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
	<20150625093738.40066.88750.stgit@dwillia2-desk3.jf.intel.com>
	<1435254317.11808.327.camel@misato.fc.hp.com>
	<1435257283.13411.4.camel@intel.com>
	<CAPcyv4jhDc1+TGyo4J6vC7bRBaGbfAXyLP2qB9X5DAJRBhCRyQ@mail.gmail.com>
	<1435269103.11808.349.camel@misato.fc.hp.com>
	<CAPcyv4gqgbEVWDKR4e8=Uaz1As4FxY4-8VHWKZfQ-vtc2wOs3g@mail.gmail.com>
	<1435270287.11808.352.camel@misato.fc.hp.com>
Date: Thu, 25 Jun 2015 15:34:55 -0700
Message-ID: <CAPcyv4hzUA71G8bmUt7OLXx0GMX-36gqQ-WHOjA7sj9z4pudCA@mail.gmail.com>
Subject: Re: [PATCH v2 15/17] libnvdimm: Set numa_node to NVDIMM devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 25, 2015 at 3:11 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Thu, 2015-06-25 at 15:00 -0700, Dan Williams wrote:
> Yes, I see no problem with bound BTTs and their device files.  So, how
> do we bind BTT with this new version?
>

# cd /sys/bus/nd/devices
# uuidgen > btt6/uuid
# echo 4096 > btt6/sector_size
# echo namespace6.0 > btt6/namespace
# echo namespace6.0 > ../drivers/nd_pmem/unbind
# echo btt6 > ../drivers/nd_pmem/bind

After reboot, when the system sees namespace6.0 again it will notice
the btt instance and attach bttX instead.  The net effect is that now
you'll only ever have /dev/pmem6 or /dev/pmem6s, never both at the
same time that was a side effect of the stacking approach.

I'll post the patch that updates libndctl and the unit tests shortly
