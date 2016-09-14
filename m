From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] block_dev: remove DAX leftovers
Date: Wed, 14 Sep 2016 07:12:39 -0700
Message-ID: <CAPcyv4gKLtkiJe-J7amrRTL8FhL==3nk3h3kto6tMHqTC2dZXw@mail.gmail.com>
References: <1473846973-18798-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473846973-18798-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-block@vger.kernel.org, linux-nvdimm <linux-nvdimm@ml01.01.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 14, 2016 at 2:56 AM, Christoph Hellwig <hch@lst.de> wrote:
> DAX support for block devices was removed in commits 03cdad
> ("block: disable block device DAX by default") and 99a01cd
> ("block: remove BLK_DEV_DAX config option"), but we still kept a call to
> dax_do_io and some uneeded i_flags manipulations introduced in commit
> bbab37 ("block: Add support for DAX reads/writes to block devices").
>
> Remove those leftovers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Dan Williams <dan.j.williams@intel.com>
