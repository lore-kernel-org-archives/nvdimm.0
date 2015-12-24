Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 24 Dec 2015 02:11:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: A blocksize problem about dax and ext4
Message-ID: <20151224101111.GA6438@infradead.org>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
 <CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
 <94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
 <20151224000021.GU19802@dastard>
 <CAM=YXF9Dt-BuY9yM7d023a16gp=edGHeCDVTCwV-AEotj6sbFg@mail.gmail.com>
 <CAPcyv4g1eHgm8oUvxFaJkRD-T7jAyw95FQ-q3_GC2JU_kkU-Kg@mail.gmail.com>
 <CAM=YXF-wZEhodxVRN8nqyH9Vg7t85ut2-0PnEn9OvhpG_jX3mA@mail.gmail.com>
 <94D0CD8314A33A4D9D801C0FE68B40295BEC9CDD@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BEC9CDD@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Cholerae Hu <choleraehyq@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Ted Tso <tytso@mit.edu>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 24, 2015 at 02:47:07AM +0000, Elliott, Robert (Persistent Memory) wrote:
> > Did you mean that I should make the blocksize bigger until the mount
> > command tell me that dax is enabled?
> 
> To really use DAX, the filesystem block size must match the
> system CPU's page size, which is probably 4096 bytes.

No, it doesn't.  File you use for DAX must be aligne at page size
granularity.  For XFS you could do this with the per-inode extent size
hint for example even if the overall block size is smaller.
