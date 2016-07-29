Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x22d.google.com (mail-pf0-x22d.google.com
 [IPv6:2607:f8b0:400e:c00::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE8EB1A1DEE
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 14:19:33 -0700 (PDT)
Received: by mail-pf0-x22d.google.com with SMTP id p64so36053265pfb.1
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 14:19:33 -0700 (PDT)
Subject: Re: [PATCH] block: remove BLK_DEV_DAX config option
References: <20160729182314.6368-1-ross.zwisler@linux.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <990cc01e-12c3-5967-dd28-4a54574828ee@kernel.dk>
Date: Fri, 29 Jul 2016 15:19:28 -0600
MIME-Version: 1.0
In-Reply-To: <20160729182314.6368-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/29/2016 12:23 PM, Ross Zwisler wrote:
> The functionality for block device DAX was already removed with this
> commit:
>
> commit acc93d30d7d4 ("Revert "block: enable dax for raw block devices"")
>
> However, we still had a config option hanging around that was always
> disabled because it depended on CONFIG_BROKEN.  This config option was
> introduced in this commit:
>
> commit 03cdadb04077 ("block: disable block device DAX by default")
>
> This change reverts that commit, removing the dead config option.

This doesn't apply to master, nor for-linus. I hand applied it.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
