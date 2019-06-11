Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 567D22194EB70
 for <linux-nvdimm@lists.01.org>; Tue, 11 Jun 2019 06:11:35 -0700 (PDT)
Date: Tue, 11 Jun 2019 09:10:58 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1206355816.34396746.1560258658768.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190610192803.GA29002@redhat.com>
References: <20190610090730.8589-1-pagupta@redhat.com>
 <20190610090730.8589-5-pagupta@redhat.com>
 <20190610192803.GA29002@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v11 4/7] dm: enable synchronous dax
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: rdunlap@infradead.org, jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, jstaron@google.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com, imammedo@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, pbonzini@redhat.com, darrick wong <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Mike,

Thanks for the review Please find my reply inline.

> 
> dm_table_supports_dax() is called multiple times (from
> dm_table_set_restrictions and dm_table_determine_type).  It is strange
> to have a getter have a side-effect of being a setter too.  Overloading
> like this could get you in trouble in the future.
> 
> Are you certain this is what you want?

I agree with you.

> 
> Or would it be better to refactor dm_table_supports_dax() to take an
> iterate_devices_fn arg and have callers pass the appropriate function?
> Then have dm_table_set_restrictions() caller do:
> 
>      if (dm_table_supports_dax(t, device_synchronous, NULL))
>                set_dax_synchronous(t->md->dax_dev);
> 
> (NULL arg implies dm_table_supports_dax() refactoring would take a int
> *data pointer rather than int type).
> 
> Mike
> 

I am sending below patch as per your suggestion. Does it look
near to what you have in mind?

Thank you,
Pankaj

===============

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 350cf0451456..8d89acc8b8c2 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -881,7 +881,7 @@ void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type)
 EXPORT_SYMBOL_GPL(dm_table_set_type);

 /* validate the dax capability of the target device span */
-static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
+int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
                                       sector_t start, sector_t len, void *data)
 {
        int blocksize = *(int *) data;
@@ -890,7 +890,15 @@ static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
                        start, len);
 }

-bool dm_table_supports_dax(struct dm_table *t, int blocksize)
+/* Check devices support synchronous DAX */
+static int device_synchronous(struct dm_target *ti, struct dm_dev *dev,
+                                      sector_t start, sector_t len, void *data)
+{
+       return dax_synchronous(dev->dax_dev);
+}
+
+bool dm_table_supports_dax(struct dm_table *t,
+                         iterate_devices_callout_fn iterate_fn, int *blocksize)
 {
        struct dm_target *ti;
        unsigned i;
@@ -903,8 +911,7 @@ bool dm_table_supports_dax(struct dm_table *t, int blocksize)
                        return false;

                if (!ti->type->iterate_devices ||
-                   !ti->type->iterate_devices(ti, device_supports_dax,
-                           &blocksize))
+                       !ti->type->iterate_devices(ti, iterate_fn, blocksize))
                        return false;
        }

@@ -940,6 +947,7 @@ static int dm_table_determine_type(struct dm_table *t)
        struct dm_target *tgt;
        struct list_head *devices = dm_table_get_devices(t);
        enum dm_queue_mode live_md_type = dm_get_md_type(t->md);
+       int page_size = PAGE_SIZE;

        if (t->type != DM_TYPE_NONE) {
                /* target already set the table's type */
@@ -984,7 +992,7 @@ static int dm_table_determine_type(struct dm_table *t)
 verify_bio_based:
                /* We must use this table as bio-based */
                t->type = DM_TYPE_BIO_BASED;
-               if (dm_table_supports_dax(t, PAGE_SIZE) ||
+               if (dm_table_supports_dax(t, device_supports_dax, &page_size) ||
                    (list_empty(devices) && live_md_type == DM_TYPE_DAX_BIO_BASED)) {
                        t->type = DM_TYPE_DAX_BIO_BASED;
                } else {
@@ -1883,6 +1891,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
                               struct queue_limits *limits)
 {
        bool wc = false, fua = false;
+       int page_size = PAGE_SIZE;

        /*
         * Copy table's limits to the DM device's request_queue
@@ -1910,8 +1919,13 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
        }
        blk_queue_write_cache(q, wc, fua);

-       if (dm_table_supports_dax(t, PAGE_SIZE))
+       if (dm_table_supports_dax(t, device_supports_dax, &page_size)) {
+
                blk_queue_flag_set(QUEUE_FLAG_DAX, q);
+               if (dm_table_supports_dax(t, device_synchronous, NULL))
+                       set_dax_synchronous(t->md->dax_dev);
+       }
        else
                blk_queue_flag_clear(QUEUE_FLAG_DAX, q);

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b1caa7188209..b92c42a72ad4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1119,7 +1119,7 @@ static bool dm_dax_supported(struct dax_device *dax_dev, struct block_device *bd
        if (!map)
                return false;

-       ret = dm_table_supports_dax(map, blocksize);
+       ret = dm_table_supports_dax(map, device_supports_dax, &blocksize);

        dm_put_live_table(md, srcu_idx);

diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 17e3db54404c..0475673337f3 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -72,7 +72,10 @@ bool dm_table_bio_based(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
-bool dm_table_supports_dax(struct dm_table *t, int blocksize);
+bool dm_table_supports_dax(struct dm_table *t, iterate_devices_callout_fn fn,
+                          int *blocksize);
+int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
+                          sector_t start, sector_t len, void *data);

 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
--
2.20.1
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
