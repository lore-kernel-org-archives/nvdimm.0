Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D503221F93B3
 for <linux-nvdimm@lists.01.org>; Tue, 16 Jan 2018 08:35:20 -0800 (PST)
Date: Tue, 16 Jan 2018 09:40:38 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] NVDIMM: Reduced-the-ND_MIN_NAMESPACE_SIZE-from-4MB-to-4KB
Message-ID: <20180116164038.GA19956@linux.intel.com>
References: <MWHPR21MB074927A9495B1E121D7C8DF2A6160@MWHPR21MB0749.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <MWHPR21MB074927A9495B1E121D7C8DF2A6160@MWHPR21MB0749.namprd21.prod.outlook.com>
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
To: "Cheng-mean Liu (SOCCER)" <soccerl@microsoft.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Matthew Wilcox <willy@infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 11, 2018 at 06:49:17PM +0000, Cheng-mean Liu (SOCCER) wrote:
> In the case of emulated NVDIMM devices in the VM environment, there
> are scenarios that NVDIMM device with much smaller sizes are desired, for example, we might
> use a single enumerated NVDIMM DAX device for representing each container layer, which in some
> cases could be just a few KBs size.The current ND_MIN_NAMESPACE_SIZE is 4MB. To avoid wasting
> address and inefficient zero padding for meeting this 4MB min requirement, the proposed change is to
> reduce it to 4KB, a single page size, is a size good for all platforms.

A few comments:

- You need to trim the lines of your changelog just as you would in an email
  on-list.  No more than 80 characters per line, please.

- The above information needs to be in the changelogs for the individual
  patches so that it will live on if they are committed.  This allows
  developers to find this info later as well when they bisect the code, etc.

- It doesn't work to have multiple patches for multiple git repos appended
  together in the same email.  Developers need to be able to save off the text
  from your email and feed it into "git am" without having to edit it.  These
  two patches need to be sent separately (possibly with different CC lists),
  and each with it's own complete changelog.  It's fine if they reference one
  another, but they need to each stand on their own.

- Both of your patches have broken whitespace.  Here's what happens if I try
  and apply the kernel patch from your mail:

  $ git am ~/patch/kernel.patch
  Applying: reduced the ND_MIN_NAMESPACE_SIZE from 4MB to 4KB
  error: corrupt patch at line 10
  error: could not build fake ancestor
  Patch failed at 0001 reduced the ND_MIN_NAMESPACE_SIZE from 4MB to 4KB
  The copy of the patch that failed is found in:
  /home/rzwisler/project/linux/.git/worktrees/review/rebase-apply/patch
  When you have resolved this problem, run "git am --continue".
  If you prefer to skip this patch, run "git am --skip" instead.
  To restore the original branch and stop patching, run "git am --abort".

  You should be able to save off your mail and feed it into 'git am', because
  that's exactly what your reviewers and the maintainer will do.

I'd highly recommend just using git for creating the patches (git
format-patch) and sending them out (git send-email).  If you need help doing
this from within the Microsoft network I'm betting Matthew can probably help
you out.

- Ross

> Two patches are included in this request :
> 
> 1. A patch for Linux kernel changes
> 2. A patch for ndctl project to keep it in sync with the Linux kernel header file
> 
> 
> From 29e173c32661d976cda073438979991167ee13fc Mon Sep 17 00:00:00 2001
> From: Cheng-mean Liu <soccerl@microsoft.com>
> Date: Thu, 11 Jan 2018 10:06:13 -0800
> Subject: [PATCH] reduced the ND_MIN_NAMESPACE_SIZE from 4MB to 4KB
> 
> Signed-off-by: Cheng-mean Liu <soccerl@microsoft.com>
> ---
> include/uapi/linux/ndctl.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
> index 3f03567631cb..e63c201ed1ef 100644
> --- a/include/uapi/linux/ndctl.h
> +++ b/include/uapi/linux/ndctl.h
> @@ -263,7 +263,7 @@ enum nd_driver_flags {
> };
>  enum {
> -              ND_MIN_NAMESPACE_SIZE = 0x00400000,
> +             ND_MIN_NAMESPACE_SIZE = 0x00001000,
> };
>  enum ars_masks {
> --
> 2.11.0
> 
> 
> 
> From 2bf3e2bbfae81ab50d141571414c0e6556bc0e0c Mon Sep 17 00:00:00 2001
> From: Cheng-mean Liu <soccerl@microsoft.com>
> Date: Thu, 11 Jan 2018 10:02:52 -0800
> Subject: [PATCH] reduced the ND_MIN_NAMESPACE_SIZE from 4MB to 4KB
> 
> Signed-off-by: Cheng-mean Liu <soccerl@microsoft.com>
> ---
> ndctl/ndctl.h    | 2 +-
> test/dpa-alloc.c | 6 ++++++
> 2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
> index 5e6905c..8c14d90 100644
> --- a/ndctl/ndctl.h
> +++ b/ndctl/ndctl.h
> @@ -263,7 +263,7 @@ enum nd_driver_flags {
> };
>  enum {
> -              ND_MIN_NAMESPACE_SIZE = 0x00400000,
> +             ND_MIN_NAMESPACE_SIZE = 0x00001000,
> };
>  enum ars_masks {
> diff --git a/test/dpa-alloc.c b/test/dpa-alloc.c
> index d13cf5d..ba3deed 100644
> --- a/test/dpa-alloc.c
> +++ b/test/dpa-alloc.c
> @@ -237,6 +237,12 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
>                                 uuid_unparse(namespaces[i].uuid, uuid_str);
>                                size = ndctl_namespace_get_size(victim);
> +
> +                             rc = ndctl_namespace_disable_invalidate(victim);
> +                if (rc) {
> +                                             fprintf(stderr, "failed to disable %s\n", uuid_str);
> +                                             return rc;
> +                             }
>                                rc = ndctl_namespace_delete(victim);
>                                if (rc) {
>                                                fprintf(stderr, "failed to delete %s\n", uuid_str);
> --
> 2.11.0
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
