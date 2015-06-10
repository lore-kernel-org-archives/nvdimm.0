Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150610161157.GA14366@lst.de>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150605211912.20751.35406.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150610121202.GA9190@lst.de>
	<20150610150334.GK2729@linux.intel.com>
	<20150610151100.GA12757@lst.de>
	<CAPcyv4hnd1JRwLYapo_s=vXFYHUA6Cv-ZpJt+Y3_tTCxQsJUPg@mail.gmail.com>
	<20150610161157.GA14366@lst.de>
Date: Wed, 10 Jun 2015 09:17:40 -0700
Message-ID: <CAPcyv4hC1ud_xhZpqDALMbijrjU4GSBHscqTmPoimHn4hX8anQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/9] x86: support kmap_atomic_pfn_t() for persistent memory
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, david <david@fromorbit.com>, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 10, 2015 at 9:11 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Jun 10, 2015 at 08:36:48AM -0700, Dan Williams wrote:
>> On surprise removal my expectation is that the driver keeps the the
>> ioremap mapping alive for at least a synchronize_rcu() period.  With
>> that in place the rcu_read_lock() in kmap_atomic_pfn_t() should keep
>> the mapping alive for the short duration, or otherwise prevent new
>> mappings.  However, I missed converting the driver to order its
>> iounmap() with respect to the pfn range registration via devres, will
>> fix.
>
> Right.  I guess the best idea is to replace devm_register_kmap_pfn_range
> with an interface that does the ioremap, in which case the cleanup
> function can take care of the proper ordering behind the drivers back.

Even better than what I was thinking... will do.
