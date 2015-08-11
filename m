Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150811125130.GB3402@lst.de>
References: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
	<20150811033823.4987.83902.stgit@otcpl-bsw-rvp-2.jf.intel.com>
	<20150811125130.GB3402@lst.de>
Date: Tue, 11 Aug 2015 09:20:57 -0700
Message-ID: <CAPcyv4iqc=7bML8ES-94PKcotnQ1ZNcLwjQ7-8wqvvsLN+OJkg@mail.gmail.com>
Subject: Re: [PATCH v4 06/10] libnvdimm, pmem: push call to ioremap_cache out
 of line
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Luis Rodriguez <mcgrof@suse.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 11, 2015 at 5:51 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Aug 10, 2015 at 11:38:23PM -0400, Dan Williams wrote:
>> In preparation for deprecating ioremap_cache() push its usage into arch
>> code where it deleted in a later globabl conversion of ioremap_cache()
>> to arch_memremap().
>
> I don't really see the point of this patch.  Two patches later
> we'll get rid arch_memremap_pmem anyway.
>
> I'd rather fold this and the next two patches into a single one,
> and keep the new arch_memremap_pmem_flags as a inline in io.h.

Yeah, it made more sense at its position in the old series, but now
that ioremap_cache() will be around for one last development cycle we
can squash this.
