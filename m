Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145]) by ml01.01.org (Postfix) with ESMTP id 2B5F61A1E1F
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 17:19:13 -0700 (PDT)
Date: Wed, 28 Sep 2016 10:18:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] mm: Invalidate DAX radix tree entries only if
 appropriate
Message-ID: <20160928001839.GE9806@dastard>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <1474994615-29553-6-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1474994615-29553-6-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 27, 2016 at 06:43:34PM +0200, Jan Kara wrote:
> +/*
> + * Invalidate exceptional DAX entry if it is clean.
> + */
> +int dax_invalidate_mapping_entry2(struct address_space *mapping, pgoff_t index)
> +{
> +	return __dax_invalidate_mapping_entry(mapping, index, false);
>  }

dax_try_invalidate_mapping_entry()

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
