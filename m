From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/12] ext2: use iomap to implement DAX
Date: Thu, 15 Sep 2016 07:14:55 +0200
Message-ID: <20160915051455.GG6188@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de> <1473847291-18913-13-git-send-email-hch@lst.de> <20160914225105.GB29323@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160914225105.GB29323@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 14, 2016 at 04:51:05PM -0600, Ross Zwisler wrote:
> diff --git a/fs/ext2/Kconfig b/fs/ext2/Kconfig
> index c634874e..3391f48 100644
> --- a/fs/ext2/Kconfig
> +++ b/fs/ext2/Kconfig
> @@ -1,5 +1,6 @@
>  config EXT2_FS
>  	tristate "Second extended fs support"
> +	select FS_IOMAP

This should probably grow and ... if FS_DAX

so that we only pull it in when needed.
