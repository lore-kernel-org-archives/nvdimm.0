Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <1435281699.11808.377.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 15/17] libnvdimm: Set numa_node to NVDIMM devices
From: Toshi Kani <toshi.kani@hp.com>
Date: Thu, 25 Jun 2015 19:21:39 -0600
In-Reply-To: <CAA9_cmf84L1JE_4Om36TzJR6DTU_OiTWGsNF+u+pb5TRTCj5NA@mail.gmail.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
	 <20150625093738.40066.88750.stgit@dwillia2-desk3.jf.intel.com>
	 <1435254317.11808.327.camel@misato.fc.hp.com>
	 <1435257283.13411.4.camel@intel.com>
	 <CAPcyv4jhDc1+TGyo4J6vC7bRBaGbfAXyLP2qB9X5DAJRBhCRyQ@mail.gmail.com>
	 <1435269103.11808.349.camel@misato.fc.hp.com>
	 <CAPcyv4gqgbEVWDKR4e8=Uaz1As4FxY4-8VHWKZfQ-vtc2wOs3g@mail.gmail.com>
	 <1435270287.11808.352.camel@misato.fc.hp.com>
	 <CAPcyv4hzUA71G8bmUt7OLXx0GMX-36gqQ-WHOjA7sj9z4pudCA@mail.gmail.com>
	 <1435272910.11808.356.camel@misato.fc.hp.com>
	 <1435275750.18090.5.camel@intel.com>
	 <1435280115.11808.374.camel@misato.fc.hp.com>
	 <CAA9_cmf84L1JE_4Om36TzJR6DTU_OiTWGsNF+u+pb5TRTCj5NA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-06-25 at 18:08 -0700, Dan Williams wrote:
> On Thu, Jun 25, 2015 at 5:55 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Thu, 2015-06-25 at 23:42 +0000, Williams, Dan J wrote:
> >> On Thu, 2015-06-25 at 16:55 -0600, Toshi Kani wrote:
 :
> >
> > Now, how do I unbind BTT?  I did the following as a guess, but BTT got
> > reattached again before I have a chance to delete the metadata, which I
> > need /dev/pmemN.
> >
> > NUM=1
> > cd /sys/bus/nd/devices
> > echo ""  > btt${NUM}.1/namespace
> > echo btt${NUM}.1 > ../drivers/nd_pmem/unbind
> 
> echo 1 > namespace${NUM}.0/force_raw
> 
> > echo namespace${NUM}.0 > ../drivers/nd_pmem/bind
> >

Cool!  Yes, it works with the force_raw.  (I changed the ordering a
bit).

NUM=1
cd /sys/bus/nd/devices
echo btt${NUM}.1 > ../drivers/nd_pmem/unbind
echo "" > btt${NUM}.1/namespace
echo 1 > namespace${NUM}.0/force_raw
echo namespace${NUM}.0 > ../drivers/nd_pmem/bind

Thanks,
-Toshi


