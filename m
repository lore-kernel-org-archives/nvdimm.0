Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C35E1A1DFB
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 20:08:11 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id w18so130170621oiw.3
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 20:08:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160729220252.32641-1-ross.zwisler@linux.intel.com>
References: <20160729220252.32641-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Jul 2016 20:08:10 -0700
Message-ID: <CAPcyv4iinDJSipaCU5+HW7DDq167E=uBzbgCKYViMdP6ZgN-jA@mail.gmail.com>
Subject: Re: [PATCH] ndctl: fix --enable-destructive build failure
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 29, 2016 at 3:02 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> This commit:
>
> commit 0d119368385a ("ndctl: reorganize file structure, use per sub-directory makefiles")
>
> reorganized the file structure & makefiles in ndctl, but broke builds that
> used the --enable-destructive option.  Here are some of the failure
> messages:
>
>   ../test/blk_namespaces.o: In function `test_blk_namespaces':
>   /root/project/ndctl/ndctl/../test/blk_namespaces.c:222: undefined reference to `__ndctl_test_attempt'
>   /root/project/ndctl/ndctl/../test/blk_namespaces.c:250: undefined reference to `__ndctl_test_skip'
>
> The root cause of this build failure was that when --enable-destructive was
> being set, test/core.c wasn't being compiled and included in the build,
> hence the undefined references.
>
> Fix the makefile to include test/core.c.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---

Hmm, are you perhaps trying to build with --enable-destructive without
--enable-test?  I'll see if I can fix this up to warn about the
misconfiguration, the intent is that --enable-destructive is
incremental.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
