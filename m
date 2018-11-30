Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com
 [209.85.210.194])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D385621197078
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:46:27 -0800 (PST)
Received: by mail-pf1-f194.google.com with SMTP id z9so2107706pfi.2
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:46:27 -0800 (PST)
Date: Thu, 29 Nov 2018 19:46:23 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC v3 16/19] arch: um: make UML unflatten device tree when
 testing
Message-ID: <20181130034623.GQ18410@garbanzo.do-not-panic.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-17-brendanhiggins@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181128193636.254378-17-brendanhiggins@google.com>
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
To: Brendan Higgins <brendanhiggins@google.com>
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, robh@kernel.org, frowand.list@gmail.com, linux-nvdimm@lists.01.org, richard@nod.at, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, joel@jms.id.au, jdike@addtoit.com, Tim.Bird@sony.com, keescook@google.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 28, 2018 at 11:36:33AM -0800, Brendan Higgins wrote:
> Make UML unflatten any present device trees when running KUnit tests.
> 
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> ---
>  arch/um/kernel/um_arch.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
> index a818ccef30ca2..bd58ae3bf4148 100644
> --- a/arch/um/kernel/um_arch.c
> +++ b/arch/um/kernel/um_arch.c
> @@ -13,6 +13,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/task.h>
>  #include <linux/kmsg_dump.h>
> +#include <linux/of_fdt.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/processor.h>
> @@ -347,6 +348,9 @@ void __init setup_arch(char **cmdline_p)
>  	read_initrd();
>  
>  	paging_init();
> +#if IS_ENABLED(CONFIG_OF_UNITTEST)
> +	unflatten_device_tree();
> +#endif

*Why?*

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
