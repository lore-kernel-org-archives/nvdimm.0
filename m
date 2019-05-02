From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 07/17] kunit: test: add initial tests
Date: Thu, 2 May 2019 12:58:49 +0200
Message-ID: <20190502105849.GB12416@kroah.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-8-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190501230126.229218-8-brendanhiggins@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: frowand.list@gmail.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, dan.j.williams@intel.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, mpe@ellerman.id.au, pmladek@suse.com, richard@nod.at, rientjes@google.com
List-Id: linux-nvdimm@lists.01.org

On Wed, May 01, 2019 at 04:01:16PM -0700, Brendan Higgins wrote:
> Add a test for string stream along with a simpler example.
> 
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> ---
>  kunit/Kconfig              | 12 ++++++
>  kunit/Makefile             |  4 ++
>  kunit/example-test.c       | 88 ++++++++++++++++++++++++++++++++++++++
>  kunit/string-stream-test.c | 61 ++++++++++++++++++++++++++
>  4 files changed, 165 insertions(+)
>  create mode 100644 kunit/example-test.c
>  create mode 100644 kunit/string-stream-test.c
> 
> diff --git a/kunit/Kconfig b/kunit/Kconfig
> index 64480092b2c24..5cb500355c873 100644
> --- a/kunit/Kconfig
> +++ b/kunit/Kconfig
> @@ -13,4 +13,16 @@ config KUNIT
>  	  special hardware. For more information, please see
>  	  Documentation/kunit/
>  
> +config KUNIT_TEST
> +	bool "KUnit test for KUnit"
> +	depends on KUNIT
> +	help
> +	  Enables KUnit test to test KUnit.
> +
> +config KUNIT_EXAMPLE_TEST
> +	bool "Example test for KUnit"
> +	depends on KUNIT
> +	help
> +	  Enables example KUnit test to demo features of KUnit.

Can't these tests be module?

Or am I mis-reading the previous logic?

Anyway, just a question, nothing objecting to this as-is for now.

thanks,

greg k-h
