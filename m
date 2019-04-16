Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com
 [148.163.147.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B38C211E95A1
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 16:45:50 -0700 (PDT)
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: [PATCH 02/18] btrfs: Carve out btrfs_get_extent_map_write() out
 of btrfs_get_blocks_write()
Date: Tue, 16 Apr 2019 23:45:00 +0000
Message-ID: <AT5PR8401MB116964C9F08E4378BDE415F3AB240@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
 <20190416164154.30390-3-rgoldwyn@suse.de>
In-Reply-To: <20190416164154.30390-3-rgoldwyn@suse.de>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: "kilobyte@angband.pl" <kilobyte@angband.pl>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "nborisov@suse.com" <nborisov@suse.com>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "david@fromorbit.com" <david@fromorbit.com>, "dsterba@suse.cz" <dsterba@suse.cz>, "willy@infradead.org" <willy@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Goldwyn Rodrigues
> Sent: Tuesday, April 16, 2019 11:42 AM
> Subject: [PATCH 02/18] btrfs: Carve out btrfs_get_extent_map_write() out of btrfs_get_blocks_write()
...
> +static int btrfs_get_blocks_direct_write(struct extent_map **map,
> +					 struct buffer_head *bh_result,
> +					 struct inode *inode,
> +					 struct btrfs_dio_data *dio_data,
> +					 u64 start, u64 len)
> +{
> +	int ret = 0;

That initialization value is not needed, since ret is always overwritten
two lines later.

> +	struct extent_map *em;
> +
> +	ret = btrfs_get_extent_map_write(map, bh_result, inode,
> +			start, len);
> +	if (ret < 0)
> +		return ret;
> +	em = *map;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
