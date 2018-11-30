Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D4CDF21A00AE6
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:14:43 -0800 (PST)
Received: by mail-pf1-f182.google.com with SMTP id b7so2054365pfi.8
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:14:43 -0800 (PST)
Date: Thu, 29 Nov 2018 19:14:38 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC v3 01/19] kunit: test: add KUnit test runner core
Message-ID: <20181130031438.GQ4922@garbanzo.do-not-panic.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-2-brendanhiggins@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181128193636.254378-2-brendanhiggins@google.com>
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
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, linux-kselftest@vger.kernel.org, shuah@kernel.org, robh@kernel.org, frowand.list@gmail.com, linux-nvdimm@lists.01.org, richard@nod.at, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, joel@jms.id.au, jdike@addtoit.com, Tim.Bird@sony.com, keescook@google.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, levinsasha928@gmail.com, kunit-dev@googlegroups.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 28, 2018 at 11:36:18AM -0800, Brendan Higgins wrote:
> +#define module_test(module) \
> +		static int module_kunit_init##module(void) \
> +		{ \
> +			return kunit_run_tests(&module); \
> +		} \
> +		late_initcall(module_kunit_init##module)

Here in lies an assumption that suffices. I'm inclined to believe we
need new initcall level here so to ensure we *do* run after all the
respective kernels iniut calls. Otherwise we're left at the whims of
link order for kunit. For instance if a kunit test relies on frameworks
which are also late_initcall() we'd have complete incompatibility with
anything linked *after* kunit.

> diff --git a/kunit/Kconfig b/kunit/Kconfig
> new file mode 100644
> index 0000000000000..49b44c4f6630a
> --- /dev/null
> +++ b/kunit/Kconfig
> @@ -0,0 +1,17 @@
> +#
> +# KUnit base configuration
> +#
> +
> +menu "KUnit support"
> +
> +config KUNIT
> +	bool "Enable support for unit tests (KUnit)"
> +	depends on UML

Consider using:

if UML
   ...
endif

That allows the depends to be done once.

> +	help
> +	  Enables support for kernel unit tests (KUnit), a lightweight unit
> +	  testing and mocking framework for the Linux kernel. These tests are
> +	  able to be run locally on a developer's workstation without a VM or
> +	  special hardware.


Some mention of UML may be good here?

> For more information, please see
> +	  Documentation/kunit/
> +
> +endmenu

I'm a bit conflicted here. This currently depends on UML but yet you
noted on RFC v2 that your intention is to liberate kunit from UML and
ideally allow unit tests to depend only on userspace. I've addressed
tests using both selftests kernels drivers and also re-written kernel
APIs to userspace to test there. I think we may need to live with both.

Then for the UML stuff, I think if we *really* accept that UML will
always be a viable option we should probably consider now throwing these
things under drivers/platform/uml/. This follows the pattern of arch
specific drivers. Whether or not we end up with a complete userspace
component independent of UML may implicate having a shared component
somewhere else.

Likewise, I realize the goal is to *avoid* using a virtual machine for
these tests, but would it in any way make sense to share kunit to be
supported for other architectures to allow easier-to-write tests as
well?

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
