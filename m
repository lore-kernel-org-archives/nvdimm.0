Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F5C1211E743C
 for <linux-nvdimm@lists.01.org>; Fri, 12 Apr 2019 09:32:30 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id d24so8885710otl.11
 for <linux-nvdimm@lists.01.org>; Fri, 12 Apr 2019 09:32:30 -0700 (PDT)
MIME-Version: 1.0
References: <1555051638-32354-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1555051638-32354-1-git-send-email-lirongqing@baidu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Apr 2019 09:32:18 -0700
Message-ID: <CAPcyv4hD9rwFHyEh=5gAWe0JPwzUJqUTi4FaUkyLtyovE==U1w@mail.gmail.com>
Subject: Re: [PATCH][RFC] nvdimm: pmem: always flush nvdimm for write request
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
To: Li RongQing <lirongqing@baidu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 11, 2019 at 11:47 PM Li RongQing <lirongqing@baidu.com> wrote:
>
> flush nvdimm for write request can speed the random write, give
> about 20% performance
>
> The below is result of fio 4k random write nvdimm as /dev/pmem0
>
> Before:
> Jobs: 32 (f=32): [W(32)][14.2%][w=1884MiB/s][w=482k IOPS][eta 01m:43s]
> After:
> Jobs: 32 (f=32): [W(32)][8.3%][w=2378MiB/s][w=609k IOPS][eta 01m:50s]

Interesting result. Another experiment proposed below...

> This makes sure that the newly written data is durable too

It's overkill for durability because ADR already handles the necessary
write-queue flush at power-loss.

> Co-developed-by: Liang ZhiCheng <liangzhicheng@baidu.com>
> Signed-off-by: Liang ZhiCheng <liangzhicheng@baidu.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> This test is done on intel AEP
>
>  drivers/nvdimm/pmem.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 1d432c5ed..9f8f25880 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -197,6 +197,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
>         unsigned long start;
>         struct bio_vec bvec;
>         struct bvec_iter iter;
> +       unsigned int op = bio_op(bio);
>         struct pmem_device *pmem = q->queuedata;
>         struct nd_region *nd_region = to_region(pmem);
>
> @@ -206,7 +207,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
>         do_acct = nd_iostat_start(bio, &start);
>         bio_for_each_segment(bvec, bio, iter) {
>                 rc = pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len,
> -                               bvec.bv_offset, bio_op(bio), iter.bi_sector);
> +                               bvec.bv_offset, op, iter.bi_sector);
>                 if (rc) {
>                         bio->bi_status = rc;
>                         break;
> @@ -215,7 +216,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
>         if (do_acct)
>                 nd_iostat_end(bio, start);
>
> -       if (bio->bi_opf & REQ_FUA)
> +       if (bio->bi_opf & REQ_FUA || op_is_write(op))
>                 nvdimm_flush(nd_region);

One question is whether this benefit is coming from just the write
ordering from the barrier, or the WPQ flush itself. Can you try the
following and see if you get the same result?

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index bc2f700feef8..10c24de52395 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -217,6 +217,8 @@ static blk_qc_t pmem_make_request(struct
request_queue *q, struct bio *bio)

        if (bio->bi_opf & REQ_FUA)
                nvdimm_flush(nd_region);
+       else if (op_is_write(bio_op(bio)))
+               wmb();

        bio_endio(bio);
        return BLK_QC_T_NONE;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
