Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [Linux-nvdimm] [PATCH v2 18/20] libnd: infrastructure for btt
 devices
Date: Fri, 15 May 2015 04:25:24 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A9068BF@G9W0745.americas.hpqcorp.net>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150428182551.35812.97856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1431448400.24419.99.camel@misato.fc.hp.com>
 <CAPcyv4hd2KP6pLEOaTBHkN0nnAcFRoCtPE0pmeJBqvpg3yGwhA@mail.gmail.com>
In-Reply-To: <CAPcyv4hd2KP6pLEOaTBHkN0nnAcFRoCtPE0pmeJBqvpg3yGwhA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>
Cc: Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf
> Of Dan Williams
> Sent: Thursday, May 14, 2015 7:42 PM
> To: Kani, Toshimitsu
> Cc: Neil Brown; Greg KH; linux-kernel@vger.kernel.org; linux-
> nvdimm@lists.01.org
> Subject: Re: [Linux-nvdimm] [PATCH v2 18/20] libnd: infrastructure for
> btt devices
> 
...
> So we can fix this to be at least as stable as the backing device
> names [1], but as far as I can see we would need to start using the
> backing device name in the btt device name.  A strawman proposal is to
> append 's' to indicated 'sectored'.  So /dev/pmem0s is the btt
> instance fronting /dev/pmem0.  Other examples:
> 
> /dev/pmem0p1s
> /dev/ndblk0.0s
> /dev/ndblk0.0p1s
> ...
> 
> Thoughts?
> 
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2015-April/000636.html

I like that; it also hints to the user that another driver has already
claimed /dev/pmem0, similar to how the presence of /dev/sda1, /dev/sda2,
etc. hints that a program has partitioned /dev/sda.


