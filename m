Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 30 Jan 2017 13:26:58 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 13/17] fs: update mount_bdev() to lookup dax
        infrastructure
Message-ID: <20170130122658.GB9043@lst.de>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com> <148559263442.11180.2158046423959539211.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148559263442.11180.2158046423959539211.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, snitzer@redhat.com, toshi.kani@hpe.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, jmoyer@redhat.com, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jan 28, 2017 at 12:37:14AM -0800, Dan Williams wrote:
> This is in preparation for removing the ->direct_access() method from
> block_device_operations.

I don't think mount_bdev has any business knowing about DAX. 
Just call dax_get_by_host manually from the affected file systems for
now, and in the future we can have a pure-DAX mount_dax helper.
