Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sat, 18 Apr 2015 08:38:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/21] nd_pmem: add NFIT support to the pmem driver
Message-ID: <20150418063829.GA29931@lst.de>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com> <20150418013618.25237.99555.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150418013618.25237.99555.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Ingo Molnar <mingo@kernel.org>, Boaz Harrosh <boaz@plexistor.com>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 17, 2015 at 09:36:18PM -0400, Dan Williams wrote:
> nd_pmem attaches to persistent memory regions and namespaces emitted by
> the nd subsystem, and, same as the original pmem driver, presents the
> system-physical-address range as a block device.

I don't think there is any need to move the driver around.  Also please split
the addition of the ida allocation from adding the new probe methods.
