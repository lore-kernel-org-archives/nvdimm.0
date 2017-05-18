Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 325CA21A16ED8
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 16:17:23 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id
 v4IN8quj008906
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 19:17:22 -0400
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2ahjca6a02-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 19:17:22 -0400
Received: from localhost
 by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <zohar@linux.vnet.ibm.com>;
 Fri, 19 May 2017 09:17:19 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
 by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 v4INH97M1114538
 for <linux-nvdimm@lists.01.org>; Fri, 19 May 2017 09:17:17 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
 by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 v4INGbrD017950
 for <linux-nvdimm@lists.01.org>; Fri, 19 May 2017 09:16:38 +1000
Subject: Re: [PATCH 16/23] ima/policy: switch to use uuid_t
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Thu, 18 May 2017 19:16:14 -0400
In-Reply-To: <20170518062705.25902-17-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-17-hch@lst.de>
Mime-Version: 1.0
Message-Id: <1495149374.3404.3.camel@linux.vnet.ibm.com>
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
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks!
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

> ---
>  security/integrity/ima/ima_policy.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 49fbc3e8f012..da3e7d50e0d7 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -61,7 +61,7 @@ struct ima_rule_entry {
>  	enum ima_hooks func;
>  	int mask;
>  	unsigned long fsmagic;
> -	u8 fsuuid[16];
> +	uuid_t fsuuid;
>  	kuid_t uid;
>  	kuid_t fowner;
>  	bool (*uid_op)(kuid_t, kuid_t);    /* Handlers for operators       */
> @@ -244,7 +244,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
>  	    && rule->fsmagic != inode->i_sb->s_magic)
>  		return false;
>  	if ((rule->flags & IMA_FSUUID) &&
> -	    memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
> +	    memcmp(&rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
>  		return false;
>  	if ((rule->flags & IMA_UID) && !rule->uid_op(cred->uid, rule->uid))
>  		return false;
> @@ -711,13 +711,12 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  		case Opt_fsuuid:
>  			ima_log_string(ab, "fsuuid", args[0].from);
> 
> -			if (memchr_inv(entry->fsuuid, 0x00,
> -				       sizeof(entry->fsuuid))) {
> +			if (uuid_is_null(&entry->fsuuid)) {
>  				result = -EINVAL;
>  				break;
>  			}
> 
> -			result = uuid_to_bin(args[0].from, (uuid_t *)&entry->fsuuid);
> +			result = uuid_to_bin(args[0].from, &entry->fsuuid);
>  			if (!result)
>  				entry->flags |= IMA_FSUUID;
>  			break;
> @@ -1086,7 +1085,7 @@ int ima_policy_show(struct seq_file *m, void *v)
>  	}
> 
>  	if (entry->flags & IMA_FSUUID) {
> -		seq_printf(m, "fsuuid=%pU", entry->fsuuid);
> +		seq_printf(m, "fsuuid=%pU", &entry->fsuuid);
>  		seq_puts(m, " ");
>  	}
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
