Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7761C1A1DF9
 for <linux-nvdimm@lists.01.org>; Mon, 28 Mar 2016 07:41:08 -0700 (PDT)
Received: from G2W6309.americas.hpqcorp.net (g2w6309.austin.hp.com
 [16.197.64.51]) (using TLSv1.2 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by g1t5424.austin.hp.com (Postfix) with ESMTPS id 72FB950
 for <linux-nvdimm@lists.01.org>; Mon, 28 Mar 2016 14:40:39 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] libnvdimm, blk: quiet i/o error reporting
Date: Mon, 28 Mar 2016 14:40:20 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295C389794@G9W0745.americas.hpqcorp.net>
References: <20160325215310.31923.81368.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160325215310.31923.81368.stgit@dwillia2-desk3.jf.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Dan Williams
> Sent: Friday, March 25, 2016 5:00 PM
> To: linux-nvdimm@lists.01.org
> Subject: [PATCH] libnvdimm, blk: quiet i/o error reporting
> 
> I/O errors events have the potential to be a high frequency and a log
> message for each event can swamp the system.  This message is also
> redundant with upper layer error reporting.
...
> diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
> index c8635b3d88a8..26d039879ba2 100644
> --- a/drivers/nvdimm/blk.c
> +++ b/drivers/nvdimm/blk.c
> @@ -189,7 +189,7 @@ static blk_qc_t nd_blk_make_request(struct
> request_queue *q, struct bio *bio)
>  		err = nd_blk_do_bvec(blk_dev, bip, bvec.bv_page, len,
>  					bvec.bv_offset, rw, iter.bi_sector);
>  		if (err) {
> -			dev_info(&blk_dev->nsblk->common.dev,
> +			dev_dbg(&blk_dev->nsblk->common.dev,
>  					"io error in %s sector %lld, len %d,\n",
>  					(rw == READ) ? "READ" : "WRITE",
>  					(unsigned long long) iter.bi_sector, len);
> 

The block layer's blk_update_request uses printk_ratelimited to
avoids swamping the output buffers.  Since this driver doesn't
call blk_update_request, it might be appropriate to do the same.

	printk_ratelimited(KERN_ERR "%s: %s error, dev %s, sector %llu\n",
		__func__, error_type, req->rq_disk ?
		req->rq_disk->disk_name : "?",
		(unsigned long long)blk_rq_pos(req));

---
Robert Elliott, HPE Persistent Memory

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
