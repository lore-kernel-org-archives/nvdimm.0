Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D32E92034C5FE
 for <linux-nvdimm@lists.01.org>; Wed, 22 Nov 2017 14:08:48 -0800 (PST)
Received: by mail-ot0-x243.google.com with SMTP id j29so14818573oth.13
 for <linux-nvdimm@lists.01.org>; Wed, 22 Nov 2017 14:13:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171122220019.16041-1-vishal.l.verma@intel.com>
References: <20171122220019.16041-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 22 Nov 2017 14:13:03 -0800
Message-ID: <CAPcyv4hzDj5gZxafo8a+fowsB1Rh_1w2p_deYiDDx=zdYwpfcw@mail.gmail.com>
Subject: Re: [ndctl PATCH] rpmbuild: ensure the rpmbuild working directories
 are present
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 22, 2017 at 2:00 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The rpmbuild and make-git-snapshot assume that the various ~/rpmbuild/*
> directories are present. In case they weren't, git-archive would fail
> with something like:
>
>   /root/rpmbuild/SOURCES/ndctl-58.2.38.g8ad8f4c.tar.gz: No such file or directory
>
> Add a 'mkdir -p' to make sure these directories are present.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  rpmbuild.sh | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/rpmbuild.sh b/rpmbuild.sh
> index 4535b46..1dd1709 100755
> --- a/rpmbuild.sh
> +++ b/rpmbuild.sh
> @@ -1,5 +1,6 @@
>  #!/bin/bash
>  pushd $(dirname $0) >/dev/null
> +mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

Hmm, I'd rather run rpmdev-setuptree than create this directories
manually, and going further I'd rather just keep the assumption that
rpmdev-setuptree has already been run before this script is run.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
