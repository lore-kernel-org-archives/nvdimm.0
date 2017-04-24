Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CD4F21954066
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 10:27:46 -0700 (PDT)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id CAABD80475
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 17:27:45 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] daxctl: delete duplicate "-R,
 --regions" in "daxctl list --help"
References: <20170423111429.16275-1-yizhan@redhat.com>
Date: Mon, 24 Apr 2017 13:27:44 -0400
In-Reply-To: <20170423111429.16275-1-yizhan@redhat.com> (Yi Zhang's message of
 "Sun, 23 Apr 2017 19:14:29 +0800")
Message-ID: <x49wpa9d8bz.fsf@segfault.boston.devel.redhat.com>
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
To: Yi Zhang <yizhan@redhat.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

That's been bugging me.  ;-)  Thanks!

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Yi Zhang <yizhan@redhat.com> writes:

> Signed-off-by: Yi Zhang <yizhan@redhat.com>
> ---
>  Documentation/daxctl-list.txt | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/Documentation/daxctl-list.txt b/Documentation/daxctl-list.txt
> index 168d410..3e559e5 100644
> --- a/Documentation/daxctl-list.txt
> +++ b/Documentation/daxctl-list.txt
> @@ -69,10 +69,6 @@ OPTIONS
>  --regions::
>  	Include region info in the listing
>  
> --R::
> ---regions::
> -	Include region info in the listing
> -
>  -i::
>  --idle::
>  	Include idle (not enabled / zero-sized) devices in the listing
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
