Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 9 Jun 2015 08:50:01 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 2/9] x86: support kmap_atomic_pfn_t() for persistent
	memory
Message-ID: <20150609065001.GA10167@lst.de>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com> <20150605211912.20751.35406.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150605211912.20751.35406.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, arnd@arndb.de, ross.zwisler@linux.intel.com, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, hch@lst.de, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, willy@linux.intel.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The code is mostly generic, so the x86 in the subject is a little misleading.
What keeps the Kconfig symbol in x86 anyway?  Is there a reason why
it can't be made entirely generic?
