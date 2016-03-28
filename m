Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7CBE71A1E10
 for <linux-nvdimm@lists.01.org>; Mon, 28 Mar 2016 16:58:01 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id o62so78758428oig.1
 for <linux-nvdimm@lists.01.org>; Mon, 28 Mar 2016 16:57:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295C389794@G9W0745.americas.hpqcorp.net>
References: <20160325215310.31923.81368.stgit@dwillia2-desk3.jf.intel.com>
 <94D0CD8314A33A4D9D801C0FE68B40295C389794@G9W0745.americas.hpqcorp.net>
Date: Mon, 28 Mar 2016 16:57:31 -0700
Message-ID: <CAPcyv4iHCKySfjujkNsaxch8AQ_mnvR2a05tHSFV3eOuVEaqww@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, blk: quiet i/o error reporting
From: Dan Williams <dan.j.williams@intel.com>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 28, 2016 at 7:40 AM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
>> Dan Williams
>> Sent: Friday, March 25, 2016 5:00 PM
>> To: linux-nvdimm@lists.01.org
>> Subject: [PATCH] libnvdimm, blk: quiet i/o error reporting
>>
>> I/O errors events have the potential to be a high frequency and a log
>> message for each event can swamp the system.  This message is also
>> redundant with upper layer error reporting.
> ...
>> diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
>> index c8635b3d88a8..26d039879ba2 100644
>> --- a/drivers/nvdimm/blk.c
>> +++ b/drivers/nvdimm/blk.c
>> @@ -189,7 +189,7 @@ static blk_qc_t nd_blk_make_request(struct
>> request_queue *q, struct bio *bio)
>>               err = nd_blk_do_bvec(blk_dev, bip, bvec.bv_page, len,
>>                                       bvec.bv_offset, rw, iter.bi_sector);
>>               if (err) {
>> -                     dev_info(&blk_dev->nsblk->common.dev,
>> +                     dev_dbg(&blk_dev->nsblk->common.dev,
>>                                       "io error in %s sector %lld, len %d,\n",
>>                                       (rw == READ) ? "READ" : "WRITE",
>>                                       (unsigned long long) iter.bi_sector, len);
>>
>
> The block layer's blk_update_request uses printk_ratelimited to
> avoids swamping the output buffers.  Since this driver doesn't
> call blk_update_request, it might be appropriate to do the same.
>
>         printk_ratelimited(KERN_ERR "%s: %s error, dev %s, sector %llu\n",
>                 __func__, error_type, req->rq_disk ?
>                 req->rq_disk->disk_name : "?",
>                 (unsigned long long)blk_rq_pos(req));

I'm aware of printk_ratelimited, I just don't think bio-based drivers
like ndblk should implement their own error reporting for something
block-layer-generic like this.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
