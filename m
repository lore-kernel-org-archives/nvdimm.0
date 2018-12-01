Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 11D63211935B9
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 19:02:19 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id q1so3709096pfi.5
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 19:02:19 -0800 (PST)
Date: Fri, 30 Nov 2018 19:02:15 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC v3 01/19] kunit: test: add KUnit test runner core
Message-ID: <20181201030215.GJ28501@garbanzo.do-not-panic.com>
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
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, alexander.h.duyck@linux.intel.com, shuah@kernel.org, robh@kernel.org, frowand.list@gmail.com, linux-nvdimm@lists.01.org, richard@nod.at, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, joel@jms.id.au, jdike@addtoit.com, Petr Mladek <pmladek@suse.com>, Tim.Bird@sony.com, keescook@google.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 28, 2018 at 11:36:18AM -0800, Brendan Higgins wrote:
> +int kunit_run_tests(struct kunit_module *module)
> +{
> +	bool all_passed = true, success;
> +	struct kunit_case *test_case;
> +	struct kunit test;
> +	int ret;
> +
> +	ret = kunit_init_test(&test, module->name);
> +	if (ret)
> +		return ret;
> +
> +	for (test_case = module->test_cases; test_case->run_case; test_case++) {
> +		success = kunit_run_case(&test, module, test_case);

We are running test cases serially, why not address testing
asynchronously, this way tests can also be paralellized when possible,
therefore decreasing test time even further.

Would that mess up the printing/log stuff somehow?

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
