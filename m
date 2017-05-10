Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 356D721A6F107
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 12:08:28 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id m17so760802oik.2
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 12:08:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170510180214.16852-17-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
 <20170510180214.16852-17-hch@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 10 May 2017 22:08:25 +0300
Message-ID: <CAOQ4uxga2U6OS8N5MnBoytyWP8Fbf8qQCS1cnsPqjoby=Mxc1w@mail.gmail.com>
Subject: Re: [PATCH 16/16] fs: switch ->s_uuid to uuid_t
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

On Wed, May 10, 2017 at 9:02 PM, Christoph Hellwig <hch@lst.de> wrote:
> For some file systems we still memcpy into it, but in various places this
> already allows us to use the proper uuid helpers.  More to come..
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Series looks good!

My main concern is that filesystems with char uuid[16] are here to stay,
or maybe, will be converted slowly.

Considering this, perhaps we should have a helper/macro to copy from
char[16] to *uuid_t and maybe  BUILD_BUG_ON the size comparison?
#define bytes_to_uuid(dst, src) ...


> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 682b336a7a6a..93a420160964 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -75,7 +75,7 @@ xfs_uuid_mount(
>
>         /* Publish UUID in struct super_block */
>         BUILD_BUG_ON(sizeof(mp->m_super->s_uuid) != sizeof(uuid_t));

This BUILD_BUG is no longer needed.

> -       memcpy(&mp->m_super->s_uuid, uuid, sizeof(uuid_t));
> +       uuid_copy(&mp->m_super->s_uuid, uuid);
>
>         if (mp->m_flags & XFS_MOUNT_NOUUID)
>                 return 0;
[...]

> diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
> index d7f282d75cc1..1d32cd20009a 100644
> --- a/security/integrity/evm/evm_crypto.c
> +++ b/security/integrity/evm/evm_crypto.c
> @@ -164,7 +164,7 @@ static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
>         hmac_misc.mode = inode->i_mode;
>         crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof(hmac_misc));
>         if (evm_hmac_attrs & EVM_ATTR_FSUUID)
> -               crypto_shash_update(desc, inode->i_sb->s_uuid,
> +               crypto_shash_update(desc, &inode->i_sb->s_uuid.b[0],

I wonder if 'inode->i_sb->s_uuid.b' would have been better here

Cheers,
Amir.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
