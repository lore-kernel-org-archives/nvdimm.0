Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8917121EB5283
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 07:18:13 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id w10so6684085oie.1
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 07:20:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170831082253.GD7897@quack2.suse.cz>
References: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150412224334.10177.12994820445044936627.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170831082253.GD7897@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Aug 2017 07:20:55 -0700
Message-ID: <CAPcyv4jo=_++oEMnep-H+=fJSKT9PKhJWrqj-3UrDCy5bPjBnA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ext2: perform dax_device lookup at mount
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
To: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 31, 2017 at 1:22 AM, Jan Kara <jack@suse.cz> wrote:
> On Wed 30-08-17 12:44:03, Dan Williams wrote:
>> The ->iomap_begin() operation is a hot path, so cache the
>> fs_dax_get_by_host() result at mount time to avoid the incurring the
>> hash lookup overhead on a per-i/o basis.
>>
>> Cc: "Theodore Ts'o" <tytso@mit.edu>
>> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
>> Cc: Jan Kara <jack@suse.cz>
>> Reported-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Looks good to me (and it looks even cleaner than your previous approach).
> Just one nit below. You can add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
>> index 7b1bc9059863..d9dd999568c2 100644
>> --- a/fs/ext2/super.c
>> +++ b/fs/ext2/super.c
>> @@ -144,6 +144,7 @@ static void ext2_put_super (struct super_block * sb)
>>       int db_count;
>>       int i;
>>       struct ext2_sb_info *sbi = EXT2_SB(sb);
>> +     struct dax_device *dax_dev = sbi->s_daxdev;
>>
>>       ext2_quota_off_umount(sb);
>>
>> @@ -172,6 +173,7 @@ static void ext2_put_super (struct super_block * sb)
>>       sb->s_fs_info = NULL;
>>       kfree(sbi->s_blockgroup_lock);
>>       kfree(sbi);
>> +     fs_put_dax(dax_dev);
>
> The local variable looks superfluous here. I'd just do
>         fs_put_dax(sbi->s_daxdev);

Ok... and move that before the kfree(sbi).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
