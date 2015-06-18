Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1434668126.32433.33.camel@linux.intel.com>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
From: Vishal Verma <vishal.l.verma@linux.intel.com>
Date: Thu, 18 Jun 2015 16:55:26 -0600
In-Reply-To: <20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2015-06-17 at 19:56 -0400, Dan Williams wrote:
> Upon detection of a read-only backing device arrange for the btt to
> device to be read only.  Implement a catch for the BLKROSET ioctl and
> only allow a btt-instance to become read-write when the backing-device
> becomes read-write.  Conversely, if a backing-device becomes read-only
> arrange for its parent btt to be marked read-only.  Synchronize these
> changes under the bus lock.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/blk.c      |    4 +++
>  drivers/nvdimm/btt.c      |   34 ++++++++++++++++++++++++++--
>  drivers/nvdimm/btt_devs.c |   42 ++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/bus.c      |   55 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/nd-core.h  |   14 +++++++++++
>  drivers/nvdimm/nd.h       |    4 +++
>  drivers/nvdimm/pmem.c     |    4 +++
>  7 files changed, 154 insertions(+), 3 deletions(-)

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>


