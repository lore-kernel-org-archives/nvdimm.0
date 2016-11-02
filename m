From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/11] ext4: Convert DAX faults to iomap infrastructure
Date: Wed, 2 Nov 2016 07:30:06 -0700
Message-ID: <20161102143006.GB18387@infradead.org>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
 <1478034381-19037-9-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478034381-19037-9-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ted Tso <tytso@mit.edu>, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Nov 01, 2016 at 10:06:18PM +0100, Jan Kara wrote:
> Convert DAX faults to use iomap infrastructure. We would not have to start
> transaction in ext4_dax_fault() anymore since ext4_iomap_begin takes
> care of that but so far we do that to avoid lock inversion of
> transaction start with DAX entry lock which gets acquired in
> dax_iomap_fault() before calling ->iomap_begin handler.

So far I've tried to avoid the need to avoid having multiple iomap_ops
for the same fs.  Would you be fine with a new IOMAP_FAULT flag for write
faults?
