Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1AFDA2119682B
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:28:06 -0800 (PST)
Received: by mail-pg1-f177.google.com with SMTP id d72so1868800pga.9
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:28:06 -0800 (PST)
Date: Thu, 29 Nov 2018 19:28:02 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC v3 01/19] kunit: test: add KUnit test runner core
Message-ID: <20181130032802.GG18410@garbanzo.do-not-panic.com>
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
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, robh@kernel.org, frowand.list@gmail.com, linux-nvdimm@lists.01.org, richard@nod.at, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, joel@jms.id.au, jdike@addtoit.com, Tim.Bird@sony.com, keescook@google.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

> +static void kunit_run_case_internal(struct kunit *test,
> +				    struct kunit_module *module,
> +				    struct kunit_case *test_case)
> +{
> +	int ret;
> +
> +	if (module->init) {
> +		ret = module->init(test);
> +		if (ret) {
> +			kunit_err(test, "failed to initialize: %d", ret);
> +			kunit_set_success(test, false);
> +			return;
> +		}
> +	}
> +
> +	test_case->run_case(test);
> +}

<-- snip -->

> +static bool kunit_run_case(struct kunit *test,
> +			   struct kunit_module *module,
> +			   struct kunit_case *test_case)
> +{
> +	kunit_set_success(test, true);
> +
> +	kunit_run_case_internal(test, module, test_case);
> +	kunit_run_case_cleanup(test, module, test_case);
> +
> +	return kunit_get_success(test);
> +}

So we are running the module->init() for each test case... is that
correct? Shouldn't the init run once? Also, typically init calls are
pegged with __init so we free them later. You seem to have skipped the
init annotations. Why?

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
