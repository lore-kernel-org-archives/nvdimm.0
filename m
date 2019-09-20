Return-Path: <SRS0=zI/O=XQ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336A5C3A5A2
	for <linux-nvdimm@archiver.kernel.org>; Sat, 21 Sep 2019 02:40:56 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0036D21835
	for <linux-nvdimm@archiver.kernel.org>; Sat, 21 Sep 2019 02:40:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QoMrsX25"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0036D21835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B95EF202ECFCE;
	Fri, 20 Sep 2019 19:43:45 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=sboyd@kernel.org;
 receiver=linux-nvdimm@lists.01.org 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F87F202ECFC9
 for <linux-nvdimm@lists.01.org>; Fri, 20 Sep 2019 19:43:44 -0700 (PDT)
Received: from kernel.org (unknown [104.132.0.74])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 48BBA20644;
 Fri, 20 Sep 2019 23:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1569022560;
 bh=5sglSv+9hSOJc0b2FWY8nQeYj0FpLkqsXtS/3eUTZSE=;
 h=In-Reply-To:References:Cc:To:From:Subject:Date:From;
 b=QoMrsX259uVvKBLBgqFjYCWW1WAj3R7P2E6eLBj5gAyIaMIeiTZjnJfb1ejgaJusJ
 UkwBwgUAjsyBgNEGV13XM9dZr3pmhCUgchYJf34niV3DUvIrN8ruCbCxuAbZoqAL58
 4PWBzZepSAwldwciLUi98T3R3UO3RBc/aPRrzFTw=
MIME-Version: 1.0
In-Reply-To: <20190920231923.141900-7-brendanhiggins@google.com>
References: <20190920231923.141900-1-brendanhiggins@google.com>
 <20190920231923.141900-7-brendanhiggins@google.com>
To: Brendan Higgins <brendanhiggins@google.com>, frowand.list@gmail.com,
 gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com,
 kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org,
 robh@kernel.org, shuah@kernel.org, tytso@mit.edu,
 yamada.masahiro@socionext.com
From: Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH v16 06/19] lib: enable building KUnit in lib/
User-Agent: alot/0.8.1
Date: Fri, 20 Sep 2019 16:35:59 -0700
Message-Id: <20190920233600.48BBA20644@mail.kernel.org>
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, amir73il@gmail.com,
 Brendan Higgins <brendanhiggins@google.com>, dri-devel@lists.freedesktop.org,
 Alexander.Levin@microsoft.com, linux-kselftest@vger.kernel.org,
 linux-nvdimm@lists.01.org, khilman@baylibre.com, knut.omang@oracle.com,
 wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, jdike@addtoit.com,
 dan.carpenter@oracle.com, devicetree@vger.kernel.org,
 Kees Cook <keescook@chromium.org>, linux-kbuild@vger.kernel.org,
 Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org,
 julia.lawall@lip6.fr, kunit-dev@googlegroups.com, richard@nod.at,
 torvalds@linux-foundation.org, rdunlap@infradead.org,
 linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

Quoting Brendan Higgins (2019-09-20 16:19:10)
> KUnit is a new unit testing framework for the kernel and when used is
> built into the kernel as a part of it. Add KUnit to the lib Kconfig and
> Makefile to allow it to be actually built.
> 
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Kees Cook <keescook@chromium.org>
> ---
>  lib/Kconfig.debug | 2 ++
>  lib/Makefile      | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 5960e2980a8a..5870fbe11e9b 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2144,4 +2144,6 @@ config IO_STRICT_DEVMEM
>  
>  source "arch/$(SRCARCH)/Kconfig.debug"
>  
> +source "lib/kunit/Kconfig"
> +

Perhaps this should go by the "Runtime Testing" part? Before or after.

>  endmenu # Kernel hacking
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
