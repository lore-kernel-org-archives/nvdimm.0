Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150418063829.GA29931@lst.de>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150418013618.25237.99555.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150418063829.GA29931@lst.de>
Date: Sat, 18 Apr 2015 12:37:09 -0700
Message-ID: <CAPcyv4hXX-nYM7GZ6rUsZsOdgcwV1zkNv1ee8Ve-O=mzU+uf6A@mail.gmail.com>
Subject: Re: [PATCH 12/21] nd_pmem: add NFIT support to the pmem driver
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Boaz Harrosh <boaz@plexistor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 17, 2015 at 11:38 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Apr 17, 2015 at 09:36:18PM -0400, Dan Williams wrote:
>> nd_pmem attaches to persistent memory regions and namespaces emitted by
>> the nd subsystem, and, same as the original pmem driver, presents the
>> system-physical-address range as a block device.
>
> I don't think there is any need to move the driver around.

At this point in the patch series I agree, but in later patches we
take advantage of nd bus services.  "[PATCH 15/21] nd: pmem label sets
and namespace instantiation" adds support for labeled pmem namespaces,
and in "[PATCH 19/21] nd: infrastructure for btt devices" we make pmem
capable of hosting btt instances.
