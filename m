Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F7EF21A1349E
 for <linux-nvdimm@lists.01.org>; Mon, 15 May 2017 12:38:19 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id w138so20495042oiw.3
 for <linux-nvdimm@lists.01.org>; Mon, 15 May 2017 12:38:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170515154308.26739-18-hch@lst.de>
References: <20170515154308.26739-1-hch@lst.de>
 <20170515154308.26739-18-hch@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 15 May 2017 22:38:18 +0300
Message-ID: <CAOQ4uxgyetFTbtuE3H2Msv9Zg1LEdoxr0YqZJ6yv0cFgiTAmAw@mail.gmail.com>
Subject: Re: [PATCH 17/17] fs: switch ->s_uuid to uuid_t
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 15, 2017 at 6:43 PM, Christoph Hellwig <hch@lst.de> wrote:
> For some file systems we still memcpy into it, but in various places this
> already allows us to use the proper uuid helpers.  More to come..
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -75,7 +75,7 @@ xfs_uuid_mount(
>
>         /* Publish UUID in struct super_block */
>         BUILD_BUG_ON(sizeof(mp->m_super->s_uuid) != sizeof(uuid_t));

BUILD_BUG_ON not needed anymore now that s_uuid is uuid_t

> -       memcpy(&mp->m_super->s_uuid, uuid, sizeof(uuid_t));
> +       uuid_copy(&mp->m_super->s_uuid, uuid);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
