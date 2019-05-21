Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 792C021265793
 for <linux-nvdimm@lists.01.org>; Tue, 21 May 2019 08:01:34 -0700 (PDT)
Date: Tue, 21 May 2019 11:01:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 02/30] fuse: Clear setuid bit even in cache=never path
Message-ID: <20190521150131.GB29075@redhat.com>
References: <20190515192715.18000-1-vgoyal@redhat.com>
 <20190515192715.18000-3-vgoyal@redhat.com>
 <20190520144137.GA24093@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190520144137.GA24093@localhost.localdomain>
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
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: kvm@vger.kernel.org, linux-nvdimm@lists.01.org, dgilbert@redhat.com, linux-kernel@vger.kernel.org, stefanha@redhat.com, linux-fsdevel@vger.kernel.org, swhiteho@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 20, 2019 at 04:41:37PM +0200, Miklos Szeredi wrote:
> On Wed, May 15, 2019 at 03:26:47PM -0400, Vivek Goyal wrote:
> > If fuse daemon is started with cache=never, fuse falls back to direct IO.
> > In that write path we don't call file_remove_privs() and that means setuid
> > bit is not cleared if unpriviliged user writes to a file with setuid bit set.
> > 
> > pjdfstest chmod test 12.t tests this and fails.
> 
> I think better sulution is to tell the server if the suid bit needs to be
> removed, so it can do so in a race free way.
> 
> Here's the kernel patch, and I'll reply with the libfuse patch.

Hi Miklos,

I tested and it works for me.

Vivek

> 
> ---
>  fs/fuse2/file.c           |    2 ++
>  include/uapi/linux/fuse.h |    3 +++
>  2 files changed, 5 insertions(+)
> 
> --- a/fs/fuse2/file.c
> +++ b/fs/fuse2/file.c
> @@ -363,6 +363,8 @@ static ssize_t fuse_send_write(struct fu
>  		inarg->flags |= O_DSYNC;
>  	if (iocb->ki_flags & IOCB_SYNC)
>  		inarg->flags |= O_SYNC;
> +	if (!capable(CAP_FSETID))
> +		inarg->write_flags |= FUSE_WRITE_KILL_PRIV;
>  	req->inh.opcode = FUSE_WRITE;
>  	req->inh.nodeid = ff->nodeid;
>  	req->inh.len = req->inline_inlen + count;
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -125,6 +125,7 @@
>   *
>   *  7.29
>   *  - add FUSE_NO_OPENDIR_SUPPORT flag
> + *  - add FUSE_WRITE_KILL_PRIV flag
>   */
>  
>  #ifndef _LINUX_FUSE_H
> @@ -318,9 +319,11 @@ struct fuse_file_lock {
>   *
>   * FUSE_WRITE_CACHE: delayed write from page cache, file handle is guessed
>   * FUSE_WRITE_LOCKOWNER: lock_owner field is valid
> + * FUSE_WRITE_KILL_PRIV: kill suid and sgid bits
>   */
>  #define FUSE_WRITE_CACHE	(1 << 0)
>  #define FUSE_WRITE_LOCKOWNER	(1 << 1)
> +#define FUSE_WRITE_KILL_PRIV	(1 << 2)
>  
>  /**
>   * Read flags
> 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
