Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80D2D21A16ECF
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 16:16:23 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id
 v4IN8qXl055446
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 19:16:22 -0400
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2ahgvwj13a-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 19:16:22 -0400
Received: from localhost
 by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <zohar@linux.vnet.ibm.com>;
 Fri, 19 May 2017 09:16:19 +1000
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
 by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 v4INGAXT28115106
 for <linux-nvdimm@lists.01.org>; Fri, 19 May 2017 09:16:18 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
 by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 v4INFjnN010235
 for <linux-nvdimm@lists.01.org>; Fri, 19 May 2017 09:15:45 +1000
Subject: Re: [PATCH 15/23] block: remove blk_part_pack_uuid
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Thu, 18 May 2017 19:15:15 -0400
In-Reply-To: <20170518062705.25902-16-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-16-hch@lst.de>
Mime-Version: 1.0
Message-Id: <1495149315.3404.2.camel@linux.vnet.ibm.com>
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
To: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> This helper was only used by IMA of all things, which would get spurious
> errors if CONFIG_BLOCK is disabled.  Just opencode the call there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

> ---
>  include/linux/genhd.h               | 11 -----------
>  security/integrity/ima/ima_policy.c |  3 +--
>  2 files changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index acff9437e5c3..e619fae2f037 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -219,12 +219,6 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
>  	return NULL;
>  }
> 
> -static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
> -{
> -	uuid_be_to_bin(uuid_str, (uuid_be *)to);
> -	return 0;
> -}
> -
>  static inline int disk_max_parts(struct gendisk *disk)
>  {
>  	if (disk->flags & GENHD_FL_EXT_DEVT)
> @@ -736,11 +730,6 @@ static inline dev_t blk_lookup_devt(const char *name, int partno)
>  	dev_t devt = MKDEV(0, 0);
>  	return devt;
>  }
> -
> -static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
> -{
> -	return -EINVAL;
> -}
>  #endif /* CONFIG_BLOCK */
> 
>  #endif /* _LINUX_GENHD_H */
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 3ab1067db624..49fbc3e8f012 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -717,8 +717,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  				break;
>  			}
> 
> -			result = blk_part_pack_uuid(args[0].from,
> -						    entry->fsuuid);
> +			result = uuid_to_bin(args[0].from, (uuid_t *)&entry->fsuuid);
>  			if (!result)
>  				entry->flags |= IMA_FSUUID;
>  			break;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
