Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x236.google.com (mail-ot0-x236.google.com
 [IPv6:2607:f8b0:4003:c0f::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 233AB21E25685
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jan 2018 15:45:37 -0800 (PST)
Received: by mail-ot0-x236.google.com with SMTP id v5so8699421oth.5
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jan 2018 15:51:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180125232638.6585-1-ross.zwisler@linux.intel.com>
References: <20180125232638.6585-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jan 2018 15:51:06 -0800
Message-ID: <CAPcyv4gxa51XQjBxndaD4bgrkmvMhoH9jgnmZWBXFNMBGuytYA@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/2] ndctl: update .gitignore
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 25, 2018 at 3:26 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> I noticed that my 'git status' output was quite noisy.  Here's what I get
> with a full build using the suggested
> ./configure CFLAGS='-g -O0' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib64
> command and with some cscope files built:
>
>   $ git status
>   On branch pending
>   Your branch is up-to-date with 'github/pending'.
>
>   Untracked files:
>     (use "git add <file>..." to include in what will be committed)
>
>         Documentation/daxctl/asciidoc.conf
>         Documentation/daxctl/daxctl-io.1
>         Documentation/daxctl/daxctl-list.1
>         Documentation/daxctl/daxctl.1
>         Documentation/ndctl/asciidoc.conf
>         Documentation/ndctl/ndctl-check-labels.1
>         Documentation/ndctl/ndctl-check-namespace.1
>         Documentation/ndctl/ndctl-create-namespace.1
>         Documentation/ndctl/ndctl-destroy-namespace.1
>         Documentation/ndctl/ndctl-disable-dimm.1
>         Documentation/ndctl/ndctl-disable-namespace.1
>         Documentation/ndctl/ndctl-disable-region.1
>         Documentation/ndctl/ndctl-enable-dimm.1
>         Documentation/ndctl/ndctl-enable-namespace.1
>         Documentation/ndctl/ndctl-enable-region.1
>         Documentation/ndctl/ndctl-init-labels.1
>         Documentation/ndctl/ndctl-inject-error.1
>         Documentation/ndctl/ndctl-list.1
>         Documentation/ndctl/ndctl-read-labels.1
>         Documentation/ndctl/ndctl-write-labels.1
>         Documentation/ndctl/ndctl-zero-labels.1
>         Documentation/ndctl/ndctl.1
>         ccan/list/.dirstamp
>         ccan/str/.dirstamp
>         cscope.files
>         cscope.out
>         daxctl/daxctl
>         daxctl/lib/libdaxctl.la
>         daxctl/lib/libdaxctl.lo
>         daxctl/lib/libdaxctl.pc
>         libccan.a
>         libutil.a
>         ndctl/lib/libndctl.pc
>         ndctl/ndctl
>         ndctl/util/.dirstamp
>         rhel/
>         sles/ndctl.spec
>         util/.dirstamp
>         util/log.lo
>         util/sysfs.lo
>         version.m4
>
>   nothing added to commit but untracked files present (use "git add" to track)

Looks good to me, you can tell I don't use 'git status' in my workflow.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
