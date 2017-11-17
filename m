Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 88B1520349D92
 for <linux-nvdimm@lists.01.org>; Thu, 16 Nov 2017 16:31:05 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [ndctl PATCH] ndctl,
 rpmspec: use %{version} for the git version override
References: <151087814337.28320.4937088593350611062.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Thu, 16 Nov 2017 19:35:13 -0500
In-Reply-To: <151087814337.28320.4937088593350611062.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Thu, 16 Nov 2017 16:22:23 -0800")
Message-ID: <x49vai9u4hq.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> When we generate the spec file we're already teaching it the version
> number so we don't need to create custom echo line each time.
>
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

LGTM

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

> ---
>  ndctl.spec.in |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index 4aa133dd70aa..fa60518e43a9 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -91,7 +91,7 @@ control API for these devices.
>  %setup -q ndctl-%{version}
>  
>  %build
> -echo "VERSION" > version
> +echo %{version} > version
>  ./autogen.sh
>  %ifarch x86_64
>  %configure --disable-static --enable-local --disable-silent-rules --with-libpmem
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
