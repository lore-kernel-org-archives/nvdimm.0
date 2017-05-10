Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B4DA21A134AE
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 11:09:45 -0700 (PDT)
Date: Wed, 10 May 2017 20:09:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/16] block: remove blk_part_pack_uuid
Message-ID: <20170510180942.GA5361@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
 <20170510180214.16852-15-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170510180214.16852-15-hch@lst.de>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 10, 2017 at 08:02:12PM +0200, Christoph Hellwig wrote:
> This helper was only used by IMA of all things, which would get spurious
> errors if CONFIG_BLOCK is disabled.  Just opencode the call there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [andy: correctly handle error returns from uuid_to_bin]
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  security/integrity/ima/ima_policy.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 4d1178610145..49fbc3e8f012 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -717,8 +717,9 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  				break;
>  			}
>  
> -			uuid_to_bin(args[0].from, (uuid_t *)entry->fsuuid);
> -			entry->flags |= IMA_FSUUID;
> +			result = uuid_to_bin(args[0].from, (uuid_t *)&entry->fsuuid);
> +			if (!result)
> +				entry->flags |= IMA_FSUUID;

This should have been folded into the previous patch..
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
