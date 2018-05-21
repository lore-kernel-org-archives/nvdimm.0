Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 04680209603D0
 for <linux-nvdimm@lists.01.org>; Mon, 21 May 2018 09:41:40 -0700 (PDT)
Subject: Re: [Qemu-devel] [qemu PATCH v4 2/4] tests/.gitignore: add entry for
 generated file
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
 <20180521163203.26590-3-ross.zwisler@linux.intel.com>
From: Eric Blake <eblake@redhat.com>
Message-ID: <6332df7d-3588-9ecc-6220-2f40c1581fe6@redhat.com>
Date: Mon, 21 May 2018 11:41:33 -0500
MIME-Version: 1.0
In-Reply-To: <20180521163203.26590-3-ross.zwisler@linux.intel.com>
Content-Language: en-US
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Igor Mammedov <imammedo@redhat.com>, qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, qemu block <qemu-block@nongnu.org>, "Michael S . Tsirkin" <mst@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 05/21/2018 11:32 AM, Ross Zwisler wrote:
> After a "make check" we end up with the following:
> 
> $ git status
> On branch master
> Your branch is up-to-date with 'origin/master'.
> 
> Untracked files:
>    (use "git add <file>..." to include in what will be committed)
> 
> 	tests/test-block-backend
> 
> nothing added to commit but untracked files present (use "git add" to track)
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Fixes: commit ad0df3e0fdac ("block: test blk_aio_flush() with blk->root == NULL")
> Cc: Kevin Wolf <kwolf@redhat.com>
> ---
>   tests/.gitignore | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Eric Blake <eblake@redhat.com>

> 
> diff --git a/tests/.gitignore b/tests/.gitignore
> index fb62d2299b..2bc61a9a58 100644
> --- a/tests/.gitignore
> +++ b/tests/.gitignore
> @@ -21,6 +21,7 @@ test-base64
>   test-bdrv-drain
>   test-bitops
>   test-bitcnt
> +test-block-backend
>   test-blockjob
>   test-blockjob-txn
>   test-bufferiszero
> 

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
