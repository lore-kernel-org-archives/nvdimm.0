From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] block_dev: remove DAX leftovers
Date: Wed, 14 Sep 2016 12:57:43 +0200
Message-ID: <20160914105743.tzwckeaqtl3zr3th@linux-x5ow.site>
References: <1473846973-18798-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473846973-18798-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, ross.zwisler@linux.intel.com, linux-block@vger.kernel.org, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 14, 2016 at 11:56:13AM +0200, Christoph Hellwig wrote:
> DAX support for block devices was removed in commits 03cdad
> ("block: disable block device DAX by default") and 99a01cd
> ("block: remove BLK_DEV_DAX config option"), but we still kept a call to
> dax_do_io and some uneeded i_flags manipulations introduced in commit
> bbab37 ("block: Add support for DAX reads/writes to block devices").
> 
> Remove those leftovers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
