Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB61514EC75;
	Fri,  7 Jun 2024 06:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717741770; cv=none; b=s14hOvOzbmI3Bm9JKA/P0qJdFpVmNCrH08CCGvTYH9xnHzZ8qT5soB9lnet19opAoIE54dEmah33ZBd/gH2egjM8Yc81rgeB0w7IRpMMbJKYqJEh97wjT3FcDF0V/RC6tNX9aDsFT3x9VSw/CnblI4Dpz5xyRWI0a59h64+papg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717741770; c=relaxed/simple;
	bh=ksK80M8J+mA9cIUZUvdJKpv1wy5O6QuC/ErsYkSoIzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kjt9o08sKTrcwIuTeoveWDEPgGv6DYLaGibX9FpAYbu9IztqG6ehg5gHMDsAMrtNsvSjaX+PyJfGNEkiXjKAk2iKCIBX4l4E8pZRewFMaBHMQT5vcPLBKhCwT5turGupS3xaAwx/XD3qAOIRP0GLS8nO2wuc7UPHQwn2DzVSP0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=i7ZkzcbU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=//rOFrOe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=i7ZkzcbU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=//rOFrOe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="i7ZkzcbU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="//rOFrOe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="i7ZkzcbU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="//rOFrOe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0F71521B49;
	Fri,  7 Jun 2024 06:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=njsiF1cvtzX+Po+bB48Q9O28IN395r4RpPgxcxFPLJo=;
	b=i7ZkzcbUsB8GhCp1kBE02VIEzFqaNYFhNRneqWq5j3cPHD8Pw2ND6yMlkbE9xR7VU44Uyf
	KUwyiyGLx52pZD8ACg6kWpbqslllbEsLIKIWEXf/RqTXCOtEIDqrsZYGgiqSu4AA0VNgqX
	qF7wO8PDmlgUswNTAXyY+B9N5TZAUs8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=njsiF1cvtzX+Po+bB48Q9O28IN395r4RpPgxcxFPLJo=;
	b=//rOFrOeKjTXfULPGWo8tKVPNJY9zDk4U7iAt5dM9UbstTWcDTGNoFtCR/NSmrlI0WRvKh
	Yn2QKQTLkw0/ccDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=njsiF1cvtzX+Po+bB48Q9O28IN395r4RpPgxcxFPLJo=;
	b=i7ZkzcbUsB8GhCp1kBE02VIEzFqaNYFhNRneqWq5j3cPHD8Pw2ND6yMlkbE9xR7VU44Uyf
	KUwyiyGLx52pZD8ACg6kWpbqslllbEsLIKIWEXf/RqTXCOtEIDqrsZYGgiqSu4AA0VNgqX
	qF7wO8PDmlgUswNTAXyY+B9N5TZAUs8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=njsiF1cvtzX+Po+bB48Q9O28IN395r4RpPgxcxFPLJo=;
	b=//rOFrOeKjTXfULPGWo8tKVPNJY9zDk4U7iAt5dM9UbstTWcDTGNoFtCR/NSmrlI0WRvKh
	Yn2QKQTLkw0/ccDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38F4E133F3;
	Fri,  7 Jun 2024 06:29:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id segjDMSoYmY7ZAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Jun 2024 06:29:24 +0000
Message-ID: <8cd46b95-bfdf-42a4-809f-36ff88062322@suse.de>
Date: Fri, 7 Jun 2024 08:29:23 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] block: move integrity information into queue_limits
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240607055912.3586772-1-hch@lst.de>
 <20240607055912.3586772-12-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240607055912.3586772-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,lst.de:email]

On 6/7/24 07:59, Christoph Hellwig wrote:
> Move the integrity information into the queue limits so that it can be
> set atomically with other queue limits, and that the sysfs changes to
> the read_verify and write_generate flags are properly synchronized.
> This also allows to provide a more useful helper to stack the integrity
> fields, although it still is separate from the main stacking function
> as not all stackable devices want to inherit the integrity settings.
> Even with that it greatly simplifies the code in md and dm.
> 
> Note that the integrity field is moved as-is into the queue limits.
> While there are good arguments for removing the separate blk_integrity
> structure, this would cause a lot of churn and might better be done at a
> later time if desired.  However the integrity field in the queue_limits
> structure is now unconditional so that various ifdefs can be avoided or
> replaced with IS_ENABLED().  Given that tiny size of it that seems like
> a worthwhile trade off.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   Documentation/block/data-integrity.rst |  49 +-------
>   block/blk-integrity.c                  | 124 ++-----------------
>   block/blk-settings.c                   | 118 +++++++++++++++++-
>   block/t10-pi.c                         |  12 +-
>   drivers/md/dm-core.h                   |   1 -
>   drivers/md/dm-integrity.c              |  27 ++---
>   drivers/md/dm-table.c                  | 161 +++++--------------------
>   drivers/md/md.c                        |  72 +++--------
>   drivers/md/md.h                        |   5 +-
>   drivers/md/raid0.c                     |   7 +-
>   drivers/md/raid1.c                     |  10 +-
>   drivers/md/raid10.c                    |  10 +-
>   drivers/md/raid5.c                     |   2 +-
>   drivers/nvdimm/btt.c                   |  13 +-
>   drivers/nvme/host/core.c               |  70 +++++------
>   drivers/scsi/sd.c                      |  10 +-
>   drivers/scsi/sd.h                      |  12 +-
>   drivers/scsi/sd_dif.c                  |  34 +++---
>   include/linux/blk-integrity.h          |  27 ++---
>   include/linux/blkdev.h                 |  11 +-
>   include/linux/t10-pi.h                 |  12 +-
>   21 files changed, 290 insertions(+), 497 deletions(-)
> 
> diff --git a/Documentation/block/data-integrity.rst b/Documentation/block/data-integrity.rst
> index 6a760c0eb1924e..99905e880a0e56 100644
> --- a/Documentation/block/data-integrity.rst
> +++ b/Documentation/block/data-integrity.rst
> @@ -153,18 +153,11 @@ bio_free() will automatically free the bip.
>   4.2 Block Device
>   ----------------
>   
> -Because the format of the protection data is tied to the physical
> -disk, each block device has been extended with a block integrity
> -profile (struct blk_integrity).  This optional profile is registered
> -with the block layer using blk_integrity_register().
> -
> -The profile contains callback functions for generating and verifying
> -the protection data, as well as getting and setting application tags.
> -The profile also contains a few constants to aid in completing,
> -merging and splitting the integrity metadata.
> +Block devices can set up the integrity information in the integrity
> +sub-struture of the queue_limits structure.
>   
>   Layered block devices will need to pick a profile that's appropriate
> -for all subdevices.  blk_integrity_compare() can help with that.  DM
> +for all subdevices.  queue_limits_stack_integrity() can help with that.  DM
>   and MD linear, RAID0 and RAID1 are currently supported.  RAID4/5/6
>   will require extra work due to the application tag.
>   
> @@ -250,42 +243,6 @@ will require extra work due to the application tag.
>         integrity upon completion.
>   
>   
> -5.4 Registering A Block Device As Capable Of Exchanging Integrity Metadata
> ---------------------------------------------------------------------------
> -
> -    To enable integrity exchange on a block device the gendisk must be
> -    registered as capable:
> -
> -    `int blk_integrity_register(gendisk, blk_integrity);`
> -
> -      The blk_integrity struct is a template and should contain the
> -      following::
> -
> -        static struct blk_integrity my_profile = {
> -            .name                   = "STANDARDSBODY-TYPE-VARIANT-CSUM",
> -            .generate_fn            = my_generate_fn,
> -	    .verify_fn              = my_verify_fn,
> -	    .tuple_size             = sizeof(struct my_tuple_size),
> -	    .tag_size               = <tag bytes per hw sector>,
> -        };
> -
> -      'name' is a text string which will be visible in sysfs.  This is
> -      part of the userland API so chose it carefully and never change
> -      it.  The format is standards body-type-variant.
> -      E.g. T10-DIF-TYPE1-IP or T13-EPP-0-CRC.
> -
> -      'generate_fn' generates appropriate integrity metadata (for WRITE).
> -
> -      'verify_fn' verifies that the data buffer matches the integrity
> -      metadata.
> -
> -      'tuple_size' must be set to match the size of the integrity
> -      metadata per sector.  I.e. 8 for DIF and EPP.
> -
> -      'tag_size' must be set to identify how many bytes of tag space
> -      are available per hardware sector.  For DIF this is either 2 or
> -      0 depending on the value of the Control Mode Page ATO bit.
> -
>   ----------------------------------------------------------------------
>   
>   2007-12-24 Martin K. Petersen <martin.petersen@oracle.com>
> diff --git a/block/blk-integrity.c b/block/blk-integrity.c
> index b37b8855eed147..05a48689a424b2 100644
> --- a/block/blk-integrity.c
> +++ b/block/blk-integrity.c
> @@ -107,63 +107,6 @@ int blk_rq_map_integrity_sg(struct request_queue *q, struct bio *bio,
>   }
>   EXPORT_SYMBOL(blk_rq_map_integrity_sg);
>   
> -/**
> - * blk_integrity_compare - Compare integrity profile of two disks
> - * @gd1:	Disk to compare
> - * @gd2:	Disk to compare
> - *
> - * Description: Meta-devices like DM and MD need to verify that all
> - * sub-devices use the same integrity format before advertising to
> - * upper layers that they can send/receive integrity metadata.  This
> - * function can be used to check whether two gendisk devices have
> - * compatible integrity formats.
> - */
> -int blk_integrity_compare(struct gendisk *gd1, struct gendisk *gd2)
> -{
> -	struct blk_integrity *b1 = &gd1->queue->integrity;
> -	struct blk_integrity *b2 = &gd2->queue->integrity;
> -
> -	if (!b1->tuple_size && !b2->tuple_size)
> -		return 0;
> -
> -	if (!b1->tuple_size || !b2->tuple_size)
> -		return -1;
> -
> -	if (b1->interval_exp != b2->interval_exp) {
> -		pr_err("%s: %s/%s protection interval %u != %u\n",
> -		       __func__, gd1->disk_name, gd2->disk_name,
> -		       1 << b1->interval_exp, 1 << b2->interval_exp);
> -		return -1;
> -	}
> -
> -	if (b1->tuple_size != b2->tuple_size) {
> -		pr_err("%s: %s/%s tuple sz %u != %u\n", __func__,
> -		       gd1->disk_name, gd2->disk_name,
> -		       b1->tuple_size, b2->tuple_size);
> -		return -1;
> -	}
> -
> -	if (b1->tag_size && b2->tag_size && (b1->tag_size != b2->tag_size)) {
> -		pr_err("%s: %s/%s tag sz %u != %u\n", __func__,
> -		       gd1->disk_name, gd2->disk_name,
> -		       b1->tag_size, b2->tag_size);
> -		return -1;
> -	}
> -
> -	if (b1->csum_type != b2->csum_type ||
> -	    (b1->flags & BLK_INTEGRITY_REF_TAG) !=
> -	    (b2->flags & BLK_INTEGRITY_REF_TAG)) {
> -		pr_err("%s: %s/%s type %s != %s\n", __func__,
> -		       gd1->disk_name, gd2->disk_name,
> -		       blk_integrity_profile_name(b1),
> -		       blk_integrity_profile_name(b2));
> -		return -1;
> -	}
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL(blk_integrity_compare);
> -
>   bool blk_integrity_merge_rq(struct request_queue *q, struct request *req,
>   			    struct request *next)
>   {
> @@ -217,7 +160,7 @@ bool blk_integrity_merge_bio(struct request_queue *q, struct request *req,
>   
>   static inline struct blk_integrity *dev_to_bi(struct device *dev)
>   {
> -	return &dev_to_disk(dev)->queue->integrity;
> +	return &dev_to_disk(dev)->queue->limits.integrity;
>   }
>   
>   const char *blk_integrity_profile_name(struct blk_integrity *bi)
> @@ -246,7 +189,8 @@ EXPORT_SYMBOL_GPL(blk_integrity_profile_name);
>   static ssize_t flag_store(struct device *dev, struct device_attribute *attr,
>   		const char *page, size_t count, unsigned char flag)
>   {
> -	struct blk_integrity *bi = dev_to_bi(dev);
> +	struct request_queue *q = dev_to_disk(dev)->queue;
> +	struct queue_limits lim;
>   	unsigned long val;
>   	int err;
>   
> @@ -254,11 +198,18 @@ static ssize_t flag_store(struct device *dev, struct device_attribute *attr,
>   	if (err)
>   		return err;
>   
> -	/* the flags are inverted vs the values in the sysfs files */
> +	/* note that the flags are inverted vs the values in the sysfs files */
> +	lim = queue_limits_start_update(q);
>   	if (val)
> -		bi->flags &= ~flag;
> +		lim.integrity.flags &= ~flag;
>   	else
> -		bi->flags |= flag;
> +		lim.integrity.flags |= flag;
> +
> +	blk_mq_freeze_queue(q);
> +	err = queue_limits_commit_update(q, &lim);
> +	blk_mq_unfreeze_queue(q);
> +	if (err)
> +		return err;
>   	return count;
>   }
>   
> @@ -355,52 +306,3 @@ const struct attribute_group blk_integrity_attr_group = {
>   	.name = "integrity",
>   	.attrs = integrity_attrs,
>   };
> -
> -/**
> - * blk_integrity_register - Register a gendisk as being integrity-capable
> - * @disk:	struct gendisk pointer to make integrity-aware
> - * @template:	block integrity profile to register
> - *
> - * Description: When a device needs to advertise itself as being able to
> - * send/receive integrity metadata it must use this function to register
> - * the capability with the block layer. The template is a blk_integrity
> - * struct with values appropriate for the underlying hardware. See
> - * Documentation/block/data-integrity.rst.
> - */
> -void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
> -{
> -	struct blk_integrity *bi = &disk->queue->integrity;
> -
> -	bi->csum_type = template->csum_type;
> -	bi->flags = template->flags;
> -	bi->interval_exp = template->interval_exp ? :
> -		ilog2(queue_logical_block_size(disk->queue));
> -	bi->tuple_size = template->tuple_size;
> -	bi->tag_size = template->tag_size;
> -	bi->pi_offset = template->pi_offset;
> -
> -#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> -	if (disk->queue->crypto_profile) {
> -		pr_warn("blk-integrity: Integrity and hardware inline encryption are not supported together. Disabling hardware inline encryption.\n");
> -		disk->queue->crypto_profile = NULL;
> -	}
> -#endif
> -}
> -EXPORT_SYMBOL(blk_integrity_register);
> -
> -/**
> - * blk_integrity_unregister - Unregister block integrity profile
> - * @disk:	disk whose integrity profile to unregister
> - *
> - * Description: This function unregisters the integrity capability from
> - * a block device.
> - */
> -void blk_integrity_unregister(struct gendisk *disk)
> -{
> -	struct blk_integrity *bi = &disk->queue->integrity;
> -
> -	if (!bi->tuple_size)
> -		return;
> -	memset(bi, 0, sizeof(*bi));
> -}
> -EXPORT_SYMBOL(blk_integrity_unregister);
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 996f247fc98e80..f11c8676eb4c67 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -6,7 +6,7 @@
>   #include <linux/module.h>
>   #include <linux/init.h>
>   #include <linux/bio.h>
> -#include <linux/blkdev.h>
> +#include <linux/blk-integrity.h>
>   #include <linux/pagemap.h>
>   #include <linux/backing-dev-defs.h>
>   #include <linux/gcd.h>
> @@ -97,6 +97,36 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
>   	return 0;
>   }
>   
> +static int blk_validate_integrity_limits(struct queue_limits *lim)
> +{
> +	struct blk_integrity *bi = &lim->integrity;
> +
> +	if (!bi->tuple_size) {
> +		if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE ||
> +		    bi->tag_size || ((bi->flags & BLK_INTEGRITY_REF_TAG))) {
> +			pr_warn("invalid PI settings.\n");
> +			return -EINVAL;
> +		}
> +		return 0;
> +	}
> +
> +	if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY)) {
> +		pr_warn("integrity support disabled.\n");
> +		return -EINVAL;
> +	}
> +
Why is that an error?
Surely 'validate' should not return an error if BLK_DEV_INTEGRITY is 
disabled and no limits are set?

> +	if (bi->csum_type == BLK_INTEGRITY_CSUM_NONE &&
> +	    (bi->flags & BLK_INTEGRITY_REF_TAG)) {
> +		pr_warn("ref tag not support without checksum.\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!bi->interval_exp)
> +		bi->interval_exp = ilog2(lim->logical_block_size);
> +
> +	return 0;
> +}
> +
>   /*
>    * Check that the limits in lim are valid, initialize defaults for unset
>    * values, and cap values based on others where needed.
> @@ -105,6 +135,7 @@ static int blk_validate_limits(struct queue_limits *lim)
>   {
>   	unsigned int max_hw_sectors;
>   	unsigned int logical_block_sectors;
> +	int err;
>   
>   	/*
>   	 * Unless otherwise specified, default to 512 byte logical blocks and a
> @@ -230,6 +261,9 @@ static int blk_validate_limits(struct queue_limits *lim)
>   		lim->misaligned = 0;
>   	}
>   
> +	err = blk_validate_integrity_limits(lim);
> +	if (err)
> +		return err;
Wouldn't we always fail to validate the limits if BLK_DEV_INTEGRITY is 
disabled, given the check above?

>   	return blk_validate_zoned_limits(lim);
>   }
>   
> @@ -263,13 +297,24 @@ int queue_limits_commit_update(struct request_queue *q,
>   		struct queue_limits *lim)
>   	__releases(q->limits_lock)
>   {
> -	int error = blk_validate_limits(lim);
> +	int error;
>   
> -	if (!error) {
> -		q->limits = *lim;
> -		if (q->disk)
> -			blk_apply_bdi_limits(q->disk->bdi, lim);
> +	error = blk_validate_limits(lim);
> +	if (error)
> +		goto out_unlock;
> +
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +	if (q->crypto_profile && lim->integrity.tag_size) {
> +		pr_warn("blk-integrity: Integrity and hardware inline encryption are not supported together.\n");
> +		error = -EINVAL;
> +		goto out_unlock;
>   	}
> +#endif
> +
> +	q->limits = *lim;
> +	if (q->disk)
> +		blk_apply_bdi_limits(q->disk->bdi, lim);
> +out_unlock:
>   	mutex_unlock(&q->limits_lock);
>   	return error;
>   }
> @@ -575,6 +620,67 @@ void queue_limits_stack_bdev(struct queue_limits *t, struct block_device *bdev,
>   }
>   EXPORT_SYMBOL_GPL(queue_limits_stack_bdev);
>   
> +/**
> + * queue_limits_stack_integrity - stack integrity profile
> + * @t: target queue limits
> + * @b: base queue limits
> + *
> + * Check if the integrity profile in the @b can be stacked into the
> + * target @t.  Stacking is possible if either:
> + *
> + *   a) does not have any integrity information stacked into it yet
> + *   b) the integrity profile in @b is identical to the one in @t
> + *
> + * If @b can be stacked into @t, return %true.  Else return %false and clear the
> + * integrity information in @t.
> + */
> +bool queue_limits_stack_integrity(struct queue_limits *t,
> +		struct queue_limits *b)
> +{
> +	struct blk_integrity *ti = &t->integrity;
> +	struct blk_integrity *bi = &b->integrity;
> +
> +	if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY))
> +		return true;
> +
> +	if (!ti->tuple_size) {
> +		/* inherit the settings from the first underlying device */
> +		if (!(ti->flags & BLK_INTEGRITY_STACKED)) {
> +			ti->flags = BLK_INTEGRITY_DEVICE_CAPABLE |
> +				(bi->flags & BLK_INTEGRITY_REF_TAG);
> +			ti->csum_type = bi->csum_type;
> +			ti->tuple_size = bi->tuple_size;
> +			ti->pi_offset = bi->pi_offset;
> +			ti->interval_exp = bi->interval_exp;
> +			ti->tag_size = bi->tag_size;
> +			goto done;
> +		}
> +		if (!bi->tuple_size)
> +			goto done;
> +	}
> +
> +	if (ti->tuple_size != bi->tuple_size)
> +		goto incompatible;
> +	if (ti->interval_exp != bi->interval_exp)
> +		goto incompatible;
> +	if (ti->tag_size != bi->tag_size)
> +		goto incompatible;
> +	if (ti->csum_type != bi->csum_type)
> +		goto incompatible;
> +	if ((ti->flags & BLK_INTEGRITY_REF_TAG) !=
> +	    (bi->flags & BLK_INTEGRITY_REF_TAG))
> +		goto incompatible;
> +
> +done:
> +	ti->flags |= BLK_INTEGRITY_STACKED;
> +	return true;
> +
> +incompatible:
> +	memset(ti, 0, sizeof(*ti));
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(queue_limits_stack_integrity);
> +
>   /**
>    * blk_queue_update_dma_pad - update pad mask
>    * @q:     the request queue for the device
> diff --git a/block/t10-pi.c b/block/t10-pi.c
> index dadecf621497bb..cd7fa60d63ff21 100644
> --- a/block/t10-pi.c
> +++ b/block/t10-pi.c
> @@ -116,7 +116,7 @@ static blk_status_t t10_pi_verify(struct blk_integrity_iter *iter,
>    */
>   static void t10_pi_type1_prepare(struct request *rq)
>   {
> -	struct blk_integrity *bi = &rq->q->integrity;
> +	struct blk_integrity *bi = &rq->q->limits.integrity;
>   	const int tuple_sz = bi->tuple_size;
>   	u32 ref_tag = t10_pi_ref_tag(rq);
>   	u8 offset = bi->pi_offset;
> @@ -167,7 +167,7 @@ static void t10_pi_type1_prepare(struct request *rq)
>    */
>   static void t10_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
>   {
> -	struct blk_integrity *bi = &rq->q->integrity;
> +	struct blk_integrity *bi = &rq->q->limits.integrity;
>   	unsigned intervals = nr_bytes >> bi->interval_exp;
>   	const int tuple_sz = bi->tuple_size;
>   	u32 ref_tag = t10_pi_ref_tag(rq);
> @@ -290,7 +290,7 @@ static blk_status_t ext_pi_crc64_verify(struct blk_integrity_iter *iter,
>   
>   static void ext_pi_type1_prepare(struct request *rq)
>   {
> -	struct blk_integrity *bi = &rq->q->integrity;
> +	struct blk_integrity *bi = &rq->q->limits.integrity;
>   	const int tuple_sz = bi->tuple_size;
>   	u64 ref_tag = ext_pi_ref_tag(rq);
>   	u8 offset = bi->pi_offset;
> @@ -330,7 +330,7 @@ static void ext_pi_type1_prepare(struct request *rq)
>   
>   static void ext_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
>   {
> -	struct blk_integrity *bi = &rq->q->integrity;
> +	struct blk_integrity *bi = &rq->q->limits.integrity;
>   	unsigned intervals = nr_bytes >> bi->interval_exp;
>   	const int tuple_sz = bi->tuple_size;
>   	u64 ref_tag = ext_pi_ref_tag(rq);
> @@ -396,7 +396,7 @@ blk_status_t blk_integrity_verify(struct blk_integrity_iter *iter,
>   
>   void blk_integrity_prepare(struct request *rq)
>   {
> -	struct blk_integrity *bi = &rq->q->integrity;
> +	struct blk_integrity *bi = &rq->q->limits.integrity;
>   
>   	if (!(bi->flags & BLK_INTEGRITY_REF_TAG))
>   		return;
> @@ -409,7 +409,7 @@ void blk_integrity_prepare(struct request *rq)
>   
>   void blk_integrity_complete(struct request *rq, unsigned int nr_bytes)
>   {
> -	struct blk_integrity *bi = &rq->q->integrity;
> +	struct blk_integrity *bi = &rq->q->limits.integrity;
>   
>   	if (!(bi->flags & BLK_INTEGRITY_REF_TAG))
>   		return;
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 08700bfc3e2343..14a44c0f82868b 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -206,7 +206,6 @@ struct dm_table {
>   
>   	bool integrity_supported:1;
>   	bool singleton:1;
> -	unsigned integrity_added:1;
>   
>   	/*
>   	 * Indicates the rw permissions for the new logical device.  This
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index c1cc27541673c7..2a89f8eb4713c9 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -3475,6 +3475,17 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
>   		limits->dma_alignment = limits->logical_block_size - 1;
>   		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
>   	}
> +
> +	if (!ic->internal_hash) {
> +		struct blk_integrity *bi = &limits->integrity;
> +
> +		memset(bi, 0, sizeof(*bi));
> +		bi->tuple_size = ic->tag_size;
> +		bi->tag_size = bi->tuple_size;
> +		bi->interval_exp =
> +			ic->sb->log2_sectors_per_block + SECTOR_SHIFT;
> +	}
> +
>   	limits->max_integrity_segments = USHRT_MAX;
>   }
>   
> @@ -3631,19 +3642,6 @@ static int initialize_superblock(struct dm_integrity_c *ic,
>   	return 0;
>   }
>   
> -static void dm_integrity_set(struct dm_target *ti, struct dm_integrity_c *ic)
> -{
> -	struct gendisk *disk = dm_disk(dm_table_get_md(ti->table));
> -	struct blk_integrity bi;
> -
> -	memset(&bi, 0, sizeof(bi));
> -	bi.tuple_size = ic->tag_size;
> -	bi.tag_size = bi.tuple_size;
> -	bi.interval_exp = ic->sb->log2_sectors_per_block + SECTOR_SHIFT;
> -
> -	blk_integrity_register(disk, &bi);
> -}
> -
>   static void dm_integrity_free_page_list(struct page_list *pl)
>   {
>   	unsigned int i;
> @@ -4629,9 +4627,6 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
>   		}
>   	}
>   
> -	if (!ic->internal_hash)
> -		dm_integrity_set(ti, ic);
> -
>   	ti->num_flush_bios = 1;
>   	ti->flush_supported = true;
>   	if (ic->discard)
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index b2d5246cff2102..fd789eeb62d943 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -425,6 +425,13 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>   		       q->limits.logical_block_size,
>   		       q->limits.alignment_offset,
>   		       (unsigned long long) start << SECTOR_SHIFT);
> +
> +	/*
> +	 * Only stack the integrity profile if the target doesn't have native
> +	 * integrity support.
> +	 */
> +	if (!dm_target_has_integrity(ti->type))
> +		queue_limits_stack_integrity_bdev(limits, bdev);
>   	return 0;
>   }
>   
> @@ -702,9 +709,6 @@ int dm_table_add_target(struct dm_table *t, const char *type,
>   		t->immutable_target_type = ti->type;
>   	}
>   
> -	if (dm_target_has_integrity(ti->type))
> -		t->integrity_added = 1;
> -
>   	ti->table = t;
>   	ti->begin = start;
>   	ti->len = len;
> @@ -1119,99 +1123,6 @@ static int dm_table_build_index(struct dm_table *t)
>   	return r;
>   }
>   
> -static bool integrity_profile_exists(struct gendisk *disk)
> -{
> -	return !!blk_get_integrity(disk);
> -}
> -
> -/*
> - * Get a disk whose integrity profile reflects the table's profile.
> - * Returns NULL if integrity support was inconsistent or unavailable.
> - */
> -static struct gendisk *dm_table_get_integrity_disk(struct dm_table *t)
> -{
> -	struct list_head *devices = dm_table_get_devices(t);
> -	struct dm_dev_internal *dd = NULL;
> -	struct gendisk *prev_disk = NULL, *template_disk = NULL;
> -
> -	for (unsigned int i = 0; i < t->num_targets; i++) {
> -		struct dm_target *ti = dm_table_get_target(t, i);
> -
> -		if (!dm_target_passes_integrity(ti->type))
> -			goto no_integrity;
> -	}
> -
> -	list_for_each_entry(dd, devices, list) {
> -		template_disk = dd->dm_dev->bdev->bd_disk;
> -		if (!integrity_profile_exists(template_disk))
> -			goto no_integrity;
> -		else if (prev_disk &&
> -			 blk_integrity_compare(prev_disk, template_disk) < 0)
> -			goto no_integrity;
> -		prev_disk = template_disk;
> -	}
> -
> -	return template_disk;
> -
> -no_integrity:
> -	if (prev_disk)
> -		DMWARN("%s: integrity not set: %s and %s profile mismatch",
> -		       dm_device_name(t->md),
> -		       prev_disk->disk_name,
> -		       template_disk->disk_name);
> -	return NULL;
> -}
> -
> -/*
> - * Register the mapped device for blk_integrity support if the
> - * underlying devices have an integrity profile.  But all devices may
> - * not have matching profiles (checking all devices isn't reliable
> - * during table load because this table may use other DM device(s) which
> - * must be resumed before they will have an initialized integity
> - * profile).  Consequently, stacked DM devices force a 2 stage integrity
> - * profile validation: First pass during table load, final pass during
> - * resume.
> - */
> -static int dm_table_register_integrity(struct dm_table *t)
> -{
> -	struct mapped_device *md = t->md;
> -	struct gendisk *template_disk = NULL;
> -
> -	/* If target handles integrity itself do not register it here. */
> -	if (t->integrity_added)
> -		return 0;
> -
> -	template_disk = dm_table_get_integrity_disk(t);
> -	if (!template_disk)
> -		return 0;
> -
> -	if (!integrity_profile_exists(dm_disk(md))) {
> -		t->integrity_supported = true;
> -		/*
> -		 * Register integrity profile during table load; we can do
> -		 * this because the final profile must match during resume.
> -		 */
> -		blk_integrity_register(dm_disk(md),
> -				       blk_get_integrity(template_disk));
> -		return 0;
> -	}
> -
> -	/*
> -	 * If DM device already has an initialized integrity
> -	 * profile the new profile should not conflict.
> -	 */
> -	if (blk_integrity_compare(dm_disk(md), template_disk) < 0) {
> -		DMERR("%s: conflict with existing integrity profile: %s profile mismatch",
> -		      dm_device_name(t->md),
> -		      template_disk->disk_name);
> -		return 1;
> -	}
> -
> -	/* Preserve existing integrity profile */
> -	t->integrity_supported = true;
> -	return 0;
> -}
> -
>   #ifdef CONFIG_BLK_INLINE_ENCRYPTION
>   
>   struct dm_crypto_profile {
> @@ -1423,12 +1334,6 @@ int dm_table_complete(struct dm_table *t)
>   		return r;
>   	}
>   
> -	r = dm_table_register_integrity(t);
> -	if (r) {
> -		DMERR("could not register integrity profile.");
> -		return r;
> -	}
> -
>   	r = dm_table_construct_crypto_profile(t);
>   	if (r) {
>   		DMERR("could not construct crypto profile.");
> @@ -1688,6 +1593,14 @@ int dm_calculate_queue_limits(struct dm_table *t,
>   
>   	blk_set_stacking_limits(limits);
>   
> +	t->integrity_supported = true;
> +	for (unsigned int i = 0; i < t->num_targets; i++) {
> +		struct dm_target *ti = dm_table_get_target(t, i);
> +
> +		if (!dm_target_passes_integrity(ti->type))
> +			t->integrity_supported = false;
> +	}
> +
>   	for (unsigned int i = 0; i < t->num_targets; i++) {
>   		struct dm_target *ti = dm_table_get_target(t, i);
>   
> @@ -1738,6 +1651,18 @@ int dm_calculate_queue_limits(struct dm_table *t,
>   			       dm_device_name(t->md),
>   			       (unsigned long long) ti->begin,
>   			       (unsigned long long) ti->len);
> +
> +		if (t->integrity_supported ||
> +		    dm_target_has_integrity(ti->type)) {
> +			if (!queue_limits_stack_integrity(limits, &ti_limits)) {
> +				DMWARN("%s: adding target device (start sect %llu len %llu) "
> +				       "disabled integrity support due to incompatibility",
> +				       dm_device_name(t->md),
> +				       (unsigned long long) ti->begin,
> +				       (unsigned long long) ti->len);
> +				t->integrity_supported = false;
> +			}
> +		}
>   	}
>   
>   	/*
> @@ -1761,36 +1686,6 @@ int dm_calculate_queue_limits(struct dm_table *t,
>   	return validate_hardware_logical_block_alignment(t, limits);
>   }
>   
> -/*
> - * Verify that all devices have an integrity profile that matches the
> - * DM device's registered integrity profile.  If the profiles don't
> - * match then unregister the DM device's integrity profile.
> - */
> -static void dm_table_verify_integrity(struct dm_table *t)
> -{
> -	struct gendisk *template_disk = NULL;
> -
> -	if (t->integrity_added)
> -		return;
> -
> -	if (t->integrity_supported) {
> -		/*
> -		 * Verify that the original integrity profile
> -		 * matches all the devices in this table.
> -		 */
> -		template_disk = dm_table_get_integrity_disk(t);
> -		if (template_disk &&
> -		    blk_integrity_compare(dm_disk(t->md), template_disk) >= 0)
> -			return;
> -	}
> -
> -	if (integrity_profile_exists(dm_disk(t->md))) {
> -		DMWARN("%s: unable to establish an integrity profile",
> -		       dm_device_name(t->md));
> -		blk_integrity_unregister(dm_disk(t->md));
> -	}
> -}
> -
>   static int device_flush_capable(struct dm_target *ti, struct dm_dev *dev,
>   				sector_t start, sector_t len, void *data)
>   {
> @@ -2004,8 +1899,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>   	else
>   		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
>   
> -	dm_table_verify_integrity(t);
> -
>   	/*
>   	 * Some devices don't use blk_integrity but still want stable pages
>   	 * because they do their own checksumming.
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aff9118ff69750..67ece2cd725f50 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2410,36 +2410,10 @@ static LIST_HEAD(pending_raid_disks);
>    */
>   int md_integrity_register(struct mddev *mddev)
>   {
> -	struct md_rdev *rdev, *reference = NULL;
> -
>   	if (list_empty(&mddev->disks))
>   		return 0; /* nothing to do */
> -	if (mddev_is_dm(mddev) || blk_get_integrity(mddev->gendisk))
> -		return 0; /* shouldn't register, or already is */
> -	rdev_for_each(rdev, mddev) {
> -		/* skip spares and non-functional disks */
> -		if (test_bit(Faulty, &rdev->flags))
> -			continue;
> -		if (rdev->raid_disk < 0)
> -			continue;
> -		if (!reference) {
> -			/* Use the first rdev as the reference */
> -			reference = rdev;
> -			continue;
> -		}
> -		/* does this rdev's profile match the reference profile? */
> -		if (blk_integrity_compare(reference->bdev->bd_disk,
> -				rdev->bdev->bd_disk) < 0)
> -			return -EINVAL;
> -	}
> -	if (!reference || !bdev_get_integrity(reference->bdev))
> -		return 0;
> -	/*
> -	 * All component devices are integrity capable and have matching
> -	 * profiles, register the common profile for the md device.
> -	 */
> -	blk_integrity_register(mddev->gendisk,
> -			       bdev_get_integrity(reference->bdev));
> +	if (mddev_is_dm(mddev) || !blk_get_integrity(mddev->gendisk))
> +		return 0; /* shouldn't register */
>   
>   	pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
>   	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
> @@ -2459,32 +2433,6 @@ int md_integrity_register(struct mddev *mddev)
>   }
>   EXPORT_SYMBOL(md_integrity_register);
>   
> -/*
> - * Attempt to add an rdev, but only if it is consistent with the current
> - * integrity profile
> - */
> -int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
> -{
> -	struct blk_integrity *bi_mddev;
> -
> -	if (mddev_is_dm(mddev))
> -		return 0;
> -
> -	bi_mddev = blk_get_integrity(mddev->gendisk);
> -
> -	if (!bi_mddev) /* nothing to do */
> -		return 0;
> -
> -	if (blk_integrity_compare(mddev->gendisk, rdev->bdev->bd_disk) != 0) {
> -		pr_err("%s: incompatible integrity profile for %pg\n",
> -		       mdname(mddev), rdev->bdev);
> -		return -ENXIO;
> -	}
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL(md_integrity_add_rdev);
> -
>   static bool rdev_read_only(struct md_rdev *rdev)
>   {
>   	return bdev_read_only(rdev->bdev) ||
> @@ -5755,14 +5703,20 @@ static const struct kobj_type md_ktype = {
>   int mdp_major = 0;
>   
>   /* stack the limit for all rdevs into lim */
> -void mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim)
> +int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
> +		unsigned int flags)
>   {
>   	struct md_rdev *rdev;
>   
>   	rdev_for_each(rdev, mddev) {
>   		queue_limits_stack_bdev(lim, rdev->bdev, rdev->data_offset,
>   					mddev->gendisk->disk_name);
> +		if ((flags & MDDEV_STACK_INTEGRITY) &&
> +		    !queue_limits_stack_integrity_bdev(lim, rdev->bdev))
> +			return -EINVAL;
>   	}
> +
> +	return 0;
>   }
>   EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
>   
> @@ -5777,6 +5731,14 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
>   	lim = queue_limits_start_update(mddev->gendisk->queue);
>   	queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
>   				mddev->gendisk->disk_name);
> +
> +	if (!queue_limits_stack_integrity_bdev(&lim, rdev->bdev)) {
> +		pr_err("%s: incompatible integrity profile for %pg\n",
> +		       mdname(mddev), rdev->bdev);
> +		queue_limits_cancel_update(mddev->gendisk->queue);
> +		return -ENXIO;
> +	}
> +
>   	return queue_limits_commit_update(mddev->gendisk->queue, &lim);
>   }
>   EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ca085ecad50449..6733b0b0abf999 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -809,7 +809,6 @@ extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
>   extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
>   extern int md_check_no_bitmap(struct mddev *mddev);
>   extern int md_integrity_register(struct mddev *mddev);
> -extern int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev);
>   extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
>   
>   extern int mddev_init(struct mddev *mddev);
> @@ -908,7 +907,9 @@ void md_autostart_arrays(int part);
>   int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
>   int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
>   int do_md_run(struct mddev *mddev);
> -void mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim);
> +#define MDDEV_STACK_INTEGRITY	(1u << 0)
> +int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
> +		unsigned int flags);
>   int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev);
>   void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
>   
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 81c01347cd24e6..62634e2a33bd0f 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -377,13 +377,18 @@ static void raid0_free(struct mddev *mddev, void *priv)
>   static int raid0_set_limits(struct mddev *mddev)
>   {
>   	struct queue_limits lim;
> +	int err;
>   
>   	blk_set_stacking_limits(&lim);
>   	lim.max_hw_sectors = mddev->chunk_sectors;
>   	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
>   	lim.io_min = mddev->chunk_sectors << 9;
>   	lim.io_opt = lim.io_min * mddev->raid_disks;
> -	mddev_stack_rdev_limits(mddev, &lim);
> +	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
> +	if (err) {
> +		queue_limits_cancel_update(mddev->gendisk->queue);
> +		return err;
> +	}
>   	return queue_limits_set(mddev->gendisk->queue, &lim);
>   }
>   
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 1f321826ef02ba..779cad62f6f8c0 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1907,9 +1907,6 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>   	if (mddev->recovery_disabled == conf->recovery_disabled)
>   		return -EBUSY;
>   
> -	if (md_integrity_add_rdev(rdev, mddev))
> -		return -ENXIO;
> -
>   	if (rdev->raid_disk >= 0)
>   		first = last = rdev->raid_disk;
>   
> @@ -3197,10 +3194,15 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>   static int raid1_set_limits(struct mddev *mddev)
>   {
>   	struct queue_limits lim;
> +	int err;
>   
>   	blk_set_stacking_limits(&lim);
>   	lim.max_write_zeroes_sectors = 0;
> -	mddev_stack_rdev_limits(mddev, &lim);
> +	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
> +	if (err) {
> +		queue_limits_cancel_update(mddev->gendisk->queue);
> +		return err;
> +	}
>   	return queue_limits_set(mddev->gendisk->queue, &lim);
>   }
>   
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index a4556d2e46bf95..5f6885b53b691a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2083,9 +2083,6 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>   	if (rdev->saved_raid_disk < 0 && !_enough(conf, 1, -1))
>   		return -EINVAL;
>   
> -	if (md_integrity_add_rdev(rdev, mddev))
> -		return -ENXIO;
> -
>   	if (rdev->raid_disk >= 0)
>   		first = last = rdev->raid_disk;
>   
> @@ -3980,12 +3977,17 @@ static int raid10_set_queue_limits(struct mddev *mddev)
>   {
>   	struct r10conf *conf = mddev->private;
>   	struct queue_limits lim;
> +	int err;
>   
>   	blk_set_stacking_limits(&lim);
>   	lim.max_write_zeroes_sectors = 0;
>   	lim.io_min = mddev->chunk_sectors << 9;
>   	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
> -	mddev_stack_rdev_limits(mddev, &lim);
> +	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
> +	if (err) {
> +		queue_limits_cancel_update(mddev->gendisk->queue);
> +		return err;
> +	}
>   	return queue_limits_set(mddev->gendisk->queue, &lim);
>   }
>   
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2bd1ce9b39226a..675c68fa6c6403 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7708,7 +7708,7 @@ static int raid5_set_limits(struct mddev *mddev)
>   	lim.raid_partial_stripes_expensive = 1;
>   	lim.discard_granularity = stripe;
>   	lim.max_write_zeroes_sectors = 0;
> -	mddev_stack_rdev_limits(mddev, &lim);
> +	mddev_stack_rdev_limits(mddev, &lim, 0);
>   	rdev_for_each(rdev, mddev)
>   		queue_limits_stack_bdev(&lim, rdev->bdev, rdev->new_data_offset,
>   				mddev->gendisk->disk_name);
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 1e5aedaf8c7bd9..c5f8451b494d6c 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1504,6 +1504,11 @@ static int btt_blk_init(struct btt *btt)
>   	};
>   	int rc;
>   
> +	if (btt_meta_size(btt) && IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY)) {
> +		lim.integrity.tuple_size = btt_meta_size(btt);
> +		lim.integrity.tag_size = btt_meta_size(btt);
> +	}
> +
>   	btt->btt_disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
>   	if (IS_ERR(btt->btt_disk))
>   		return PTR_ERR(btt->btt_disk);
> @@ -1516,14 +1521,6 @@ static int btt_blk_init(struct btt *btt)
>   	blk_queue_flag_set(QUEUE_FLAG_NONROT, btt->btt_disk->queue);
>   	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, btt->btt_disk->queue);
>   
> -	if (btt_meta_size(btt) && IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY)) {
> -		struct blk_integrity bi = {
> -			.tuple_size	= btt_meta_size(btt),
> -			.tag_size	= btt_meta_size(btt),
> -		};
> -		blk_integrity_register(btt->btt_disk, &bi);
> -	}
> -
>   	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
>   	rc = device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
>   	if (rc)
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 14bac248cde4ca..5a673fa5cb2612 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -1723,11 +1723,12 @@ int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo)
>   	return 0;
>   }
>   
> -static bool nvme_init_integrity(struct gendisk *disk, struct nvme_ns_head *head)
> +static bool nvme_init_integrity(struct gendisk *disk, struct nvme_ns_head *head,
> +		struct queue_limits *lim)
>   {
> -	struct blk_integrity integrity = { };
> +	struct blk_integrity *bi = &lim->integrity;
>   
> -	blk_integrity_unregister(disk);
> +	memset(bi, 0, sizeof(*bi));
>   
>   	if (!head->ms)
>   		return true;
> @@ -1744,14 +1745,14 @@ static bool nvme_init_integrity(struct gendisk *disk, struct nvme_ns_head *head)
>   	case NVME_NS_DPS_PI_TYPE3:
>   		switch (head->guard_type) {
>   		case NVME_NVM_NS_16B_GUARD:
> -			integrity.csum_type = BLK_INTEGRITY_CSUM_CRC;
> -			integrity.tag_size = sizeof(u16) + sizeof(u32);
> -			integrity.flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
> +			bi->csum_type = BLK_INTEGRITY_CSUM_CRC;
> +			bi->tag_size = sizeof(u16) + sizeof(u32);
> +			bi->flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
>   			break;
>   		case NVME_NVM_NS_64B_GUARD:
> -			integrity.csum_type = BLK_INTEGRITY_CSUM_CRC64;
> -			integrity.tag_size = sizeof(u16) + 6;
> -			integrity.flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
> +			bi->csum_type = BLK_INTEGRITY_CSUM_CRC64;
> +			bi->tag_size = sizeof(u16) + 6;
> +			bi->flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
>   			break;
>   		default:
>   			break;
> @@ -1761,16 +1762,16 @@ static bool nvme_init_integrity(struct gendisk *disk, struct nvme_ns_head *head)
>   	case NVME_NS_DPS_PI_TYPE2:
>   		switch (head->guard_type) {
>   		case NVME_NVM_NS_16B_GUARD:
> -			integrity.csum_type = BLK_INTEGRITY_CSUM_CRC;
> -			integrity.tag_size = sizeof(u16);
> -			integrity.flags |= BLK_INTEGRITY_DEVICE_CAPABLE |
> -					   BLK_INTEGRITY_REF_TAG;
> +			bi->csum_type = BLK_INTEGRITY_CSUM_CRC;
> +			bi->tag_size = sizeof(u16);
> +			bi->flags |= BLK_INTEGRITY_DEVICE_CAPABLE |
> +				     BLK_INTEGRITY_REF_TAG;
>   			break;
>   		case NVME_NVM_NS_64B_GUARD:
> -			integrity.csum_type = BLK_INTEGRITY_CSUM_CRC64;
> -			integrity.tag_size = sizeof(u16);
> -			integrity.flags |= BLK_INTEGRITY_DEVICE_CAPABLE |
> -					   BLK_INTEGRITY_REF_TAG;
> +			bi->csum_type = BLK_INTEGRITY_CSUM_CRC64;
> +			bi->tag_size = sizeof(u16);
> +			bi->flags |= BLK_INTEGRITY_DEVICE_CAPABLE |
> +				     BLK_INTEGRITY_REF_TAG;
>   			break;
>   		default:
>   			break;
> @@ -1780,9 +1781,8 @@ static bool nvme_init_integrity(struct gendisk *disk, struct nvme_ns_head *head)
>   		break;
>   	}
>   
> -	integrity.tuple_size = head->ms;
> -	integrity.pi_offset = head->pi_offset;
> -	blk_integrity_register(disk, &integrity);
> +	bi->tuple_size = head->ms;
> +	bi->pi_offset = head->pi_offset;
>   	return true;
>   }
>   
> @@ -2105,11 +2105,6 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
>   	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
>   	    ns->head->ids.csi == NVME_CSI_ZNS)
>   		nvme_update_zone_info(ns, &lim, &zi);
> -	ret = queue_limits_commit_update(ns->disk->queue, &lim);
> -	if (ret) {
> -		blk_mq_unfreeze_queue(ns->disk->queue);
> -		goto out;
> -	}
>   
>   	/*
>   	 * Register a metadata profile for PI, or the plain non-integrity NVMe
> @@ -2117,9 +2112,15 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
>   	 * I/O to namespaces with metadata except when the namespace supports
>   	 * PI, as it can strip/insert in that case.
>   	 */
> -	if (!nvme_init_integrity(ns->disk, ns->head))
> +	if (!nvme_init_integrity(ns->disk, ns->head, &lim))
>   		capacity = 0;
>   
> +	ret = queue_limits_commit_update(ns->disk->queue, &lim);
> +	if (ret) {
> +		blk_mq_unfreeze_queue(ns->disk->queue);
> +		goto out;
> +	}
> +
>   	set_capacity_and_notify(ns->disk, capacity);
>   
>   	/*
> @@ -2191,14 +2192,6 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
>   		struct queue_limits lim;
>   
>   		blk_mq_freeze_queue(ns->head->disk->queue);
> -		if (unsupported)
> -			ns->head->disk->flags |= GENHD_FL_HIDDEN;
> -		else
> -			nvme_init_integrity(ns->head->disk, ns->head);
> -		set_capacity_and_notify(ns->head->disk, get_capacity(ns->disk));
> -		set_disk_ro(ns->head->disk, nvme_ns_is_readonly(ns, info));
> -		nvme_mpath_revalidate_paths(ns);
> -
>   		/*
>   		 * queue_limits mixes values that are the hardware limitations
>   		 * for bio splitting with what is the device configuration.
> @@ -2221,7 +2214,16 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
>   		lim.io_opt = ns_lim->io_opt;
>   		queue_limits_stack_bdev(&lim, ns->disk->part0, 0,
>   					ns->head->disk->disk_name);
> +		if (unsupported)
> +			ns->head->disk->flags |= GENHD_FL_HIDDEN;
> +		else
> +			nvme_init_integrity(ns->head->disk, ns->head, &lim);
>   		ret = queue_limits_commit_update(ns->head->disk->queue, &lim);
> +
> +		set_capacity_and_notify(ns->head->disk, get_capacity(ns->disk));
> +		set_disk_ro(ns->head->disk, nvme_ns_is_readonly(ns, info));
> +		nvme_mpath_revalidate_paths(ns);
> +
>   		blk_mq_unfreeze_queue(ns->head->disk->queue);
>   	}
>   
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 67f24607b862a3..85b45345a27739 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -799,7 +799,7 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
>   					   unsigned int dix, unsigned int dif)
>   {
>   	struct request *rq = scsi_cmd_to_rq(scmd);
> -	struct blk_integrity *bi = &rq->q->integrity;
> +	struct blk_integrity *bi = &rq->q->limits.integrity;
>   	unsigned int prot_op = sd_prot_op(rq_data_dir(rq), dix, dif);
>   	unsigned int protect = 0;
>   
> @@ -2474,11 +2474,13 @@ static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer
>   	return 0;
>   }
>   
> -static void sd_config_protection(struct scsi_disk *sdkp)
> +static void sd_config_protection(struct scsi_disk *sdkp,
> +		struct queue_limits *lim)
>   {
>   	struct scsi_device *sdp = sdkp->device;
>   
> -	sd_dif_config_host(sdkp);
> +	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY))
> +		sd_dif_config_host(sdkp, lim);
>   
>   	if (!sdkp->protection_type)
>   		return;
> @@ -3669,7 +3671,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>   		sd_read_app_tag_own(sdkp, buffer);
>   		sd_read_write_same(sdkp, buffer);
>   		sd_read_security(sdkp, buffer);
> -		sd_config_protection(sdkp);
> +		sd_config_protection(sdkp, &lim);
>   	}
>   
>   	/*
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index b4170b17bad47a..726f1613f6cb56 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -220,17 +220,7 @@ static inline sector_t sectors_to_logical(struct scsi_device *sdev, sector_t sec
>   	return sector >> (ilog2(sdev->sector_size) - 9);
>   }
>   
> -#ifdef CONFIG_BLK_DEV_INTEGRITY
> -
> -extern void sd_dif_config_host(struct scsi_disk *);
> -
> -#else /* CONFIG_BLK_DEV_INTEGRITY */
> -
> -static inline void sd_dif_config_host(struct scsi_disk *disk)
> -{
> -}
> -
> -#endif /* CONFIG_BLK_DEV_INTEGRITY */
> +void sd_dif_config_host(struct scsi_disk *sdkp, struct queue_limits *lim);
>   
>   static inline int sd_is_zoned(struct scsi_disk *sdkp)
>   {
> diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
> index 6f0921c7db787b..ae6ce6f5d622d9 100644
> --- a/drivers/scsi/sd_dif.c
> +++ b/drivers/scsi/sd_dif.c
> @@ -24,14 +24,15 @@
>   /*
>    * Configure exchange of protection information between OS and HBA.
>    */
> -void sd_dif_config_host(struct scsi_disk *sdkp)
> +void sd_dif_config_host(struct scsi_disk *sdkp, struct queue_limits *lim)
>   {
>   	struct scsi_device *sdp = sdkp->device;
> -	struct gendisk *disk = sdkp->disk;
>   	u8 type = sdkp->protection_type;
> -	struct blk_integrity bi;
> +	struct blk_integrity *bi = &lim->integrity;
>   	int dif, dix;
>   
> +	memset(bi, 0, sizeof(*bi));
> +
>   	dif = scsi_host_dif_capable(sdp->host, type);
>   	dix = scsi_host_dix_capable(sdp->host, type);
>   
> @@ -39,40 +40,33 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
>   		dif = 0; dix = 1;
>   	}
>   
> -	if (!dix) {
> -		blk_integrity_unregister(disk);
> +	if (!dix)
>   		return;
> -	}
> -
> -	memset(&bi, 0, sizeof(bi));
>   
>   	/* Enable DMA of protection information */
>   	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP)
> -		bi.csum_type = BLK_INTEGRITY_CSUM_IP;
> +		bi->csum_type = BLK_INTEGRITY_CSUM_IP;
>   	else
> -		bi.csum_type = BLK_INTEGRITY_CSUM_CRC;
> +		bi->csum_type = BLK_INTEGRITY_CSUM_CRC;
>   
>   	if (type != T10_PI_TYPE3_PROTECTION)
> -		bi.flags |= BLK_INTEGRITY_REF_TAG;
> +		bi->flags |= BLK_INTEGRITY_REF_TAG;
>   
> -	bi.tuple_size = sizeof(struct t10_pi_tuple);
> +	bi->tuple_size = sizeof(struct t10_pi_tuple);
>   
>   	if (dif && type) {
> -		bi.flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
> +		bi->flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
>   
>   		if (!sdkp->ATO)
> -			goto out;
> +			return;
>   
>   		if (type == T10_PI_TYPE3_PROTECTION)
> -			bi.tag_size = sizeof(u16) + sizeof(u32);
> +			bi->tag_size = sizeof(u16) + sizeof(u32);
>   		else
> -			bi.tag_size = sizeof(u16);
> +			bi->tag_size = sizeof(u16);
>   	}
>   
>   	sd_first_printk(KERN_NOTICE, sdkp,
>   			"Enabling DIX %s, application tag size %u bytes\n",
> -			blk_integrity_profile_name(&bi), bi.tag_size);
> -out:
> -	blk_integrity_register(disk, &bi);
> +			blk_integrity_profile_name(bi), bi->tag_size);
>   }
> -
> diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
> index bafa01d4e7f95b..d201140d77a336 100644
> --- a/include/linux/blk-integrity.h
> +++ b/include/linux/blk-integrity.h
> @@ -11,6 +11,7 @@ enum blk_integrity_flags {
>   	BLK_INTEGRITY_NOGENERATE	= 1 << 1,
>   	BLK_INTEGRITY_DEVICE_CAPABLE	= 1 << 2,
>   	BLK_INTEGRITY_REF_TAG		= 1 << 3,
> +	BLK_INTEGRITY_STACKED		= 1 << 4,
>   };
>   
>   struct blk_integrity_iter {
> @@ -23,11 +24,15 @@ struct blk_integrity_iter {
>   };
>   
>   const char *blk_integrity_profile_name(struct blk_integrity *bi);
> +bool queue_limits_stack_integrity(struct queue_limits *t,
> +		struct queue_limits *b);
> +static inline bool queue_limits_stack_integrity_bdev(struct queue_limits *t,
> +		struct block_device *bdev)
> +{
> +	return queue_limits_stack_integrity(t, &bdev->bd_disk->queue->limits);
> +}
>   
>   #ifdef CONFIG_BLK_DEV_INTEGRITY
> -void blk_integrity_register(struct gendisk *, struct blk_integrity *);
> -void blk_integrity_unregister(struct gendisk *);
> -int blk_integrity_compare(struct gendisk *, struct gendisk *);
>   int blk_rq_map_integrity_sg(struct request_queue *, struct bio *,
>   				   struct scatterlist *);
>   int blk_rq_count_integrity_sg(struct request_queue *, struct bio *);
> @@ -35,14 +40,14 @@ int blk_rq_count_integrity_sg(struct request_queue *, struct bio *);
>   static inline bool
>   blk_integrity_queue_supports_integrity(struct request_queue *q)
>   {
> -	return q->integrity.tuple_size;
> +	return q->limits.integrity.tuple_size;
>   }
>   
>   static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
>   {
>   	if (!blk_integrity_queue_supports_integrity(disk->queue))
>   		return NULL;
> -	return &disk->queue->integrity;
> +	return &disk->queue->limits.integrity;
>   }
>   
>   static inline struct blk_integrity *
> @@ -119,17 +124,6 @@ blk_integrity_queue_supports_integrity(struct request_queue *q)
>   {
>   	return false;
>   }
> -static inline int blk_integrity_compare(struct gendisk *a, struct gendisk *b)
> -{
> -	return 0;
> -}
> -static inline void blk_integrity_register(struct gendisk *d,
> -					 struct blk_integrity *b)
> -{
> -}
> -static inline void blk_integrity_unregister(struct gendisk *d)
> -{
> -}
>   static inline unsigned short
>   queue_max_integrity_segments(const struct request_queue *q)
>   {
> @@ -157,4 +151,5 @@ static inline struct bio_vec *rq_integrity_vec(struct request *rq)
>   	return NULL;
>   }
>   #endif /* CONFIG_BLK_DEV_INTEGRITY */
> +
>   #endif /* _LINUX_BLK_INTEGRITY_H */
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f9089750919c6b..c792d4d81e5fcc 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -334,6 +334,8 @@ struct queue_limits {
>   	 * due to possible offsets.
>   	 */
>   	unsigned int		dma_alignment;
> +
> +	struct blk_integrity	integrity;
>   };
>   
>   typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
> @@ -419,10 +421,6 @@ struct request_queue {
>   
>   	struct queue_limits	limits;
>   
> -#ifdef  CONFIG_BLK_DEV_INTEGRITY
> -	struct blk_integrity integrity;
> -#endif	/* CONFIG_BLK_DEV_INTEGRITY */
> -
>   #ifdef CONFIG_PM
>   	struct device		*dev;
>   	enum rpm_status		rpm_status;
> @@ -1300,11 +1298,10 @@ static inline bool bdev_stable_writes(struct block_device *bdev)
>   {
>   	struct request_queue *q = bdev_get_queue(bdev);
>   
> -#ifdef CONFIG_BLK_DEV_INTEGRITY
>   	/* BLK_INTEGRITY_CSUM_NONE is not available in blkdev.h */
> -	if (q->integrity.csum_type != 0)
> +	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
> +	    q->limits.integrity.csum_type != 0)
>   		return true;
> -#endif
>   	return test_bit(QUEUE_FLAG_STABLE_WRITES, &q->queue_flags);
>   }
>   
> diff --git a/include/linux/t10-pi.h b/include/linux/t10-pi.h
> index d2bafb76badfb9..1773610010ebaf 100644
> --- a/include/linux/t10-pi.h
> +++ b/include/linux/t10-pi.h
> @@ -39,12 +39,8 @@ struct t10_pi_tuple {
>   
>   static inline u32 t10_pi_ref_tag(struct request *rq)
>   {
> -	unsigned int shift = ilog2(queue_logical_block_size(rq->q));
> +	unsigned int shift = rq->q->limits.integrity.interval_exp;
>   
> -#ifdef CONFIG_BLK_DEV_INTEGRITY
> -	if (rq->q->integrity.interval_exp)
> -		shift = rq->q->integrity.interval_exp;
> -#endif
>   	return blk_rq_pos(rq) >> (shift - SECTOR_SHIFT) & 0xffffffff;
>   }
>   
> @@ -65,12 +61,8 @@ static inline u64 lower_48_bits(u64 n)
>   
>   static inline u64 ext_pi_ref_tag(struct request *rq)
>   {
> -	unsigned int shift = ilog2(queue_logical_block_size(rq->q));
> +	unsigned int shift = rq->q->limits.integrity.interval_exp;
>   
> -#ifdef CONFIG_BLK_DEV_INTEGRITY
> -	if (rq->q->integrity.interval_exp)
> -		shift = rq->q->integrity.interval_exp;
> -#endif
>   	return lower_48_bits(blk_rq_pos(rq) >> (shift - SECTOR_SHIFT));
>   }
>   
Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

