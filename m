From: Stephen Boyd <sboyd@kernel.org>
Subject: Re: [RFC v4 02/17] kunit: test: add test resource management API
Date: Fri, 15 Feb 2019 13:01:50 -0800
Message-ID: <155026451067.115909.17082794837098610153@swboyd.mtv.corp.google.com>
References: <20190214213729.21702-1-brendanhiggins@google.com> <20190214213729.21702-3-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190214213729.21702-3-brendanhiggins@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: frowand.list@gmail.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, shuah@kernel.org
Cc: gregkh@linuxfoundation.org, joel@jms.id.au, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, julia.lawall@lip6.fr, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, daniel@ffwll.ch, dri-devel@lists.freedesktop.org, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, knut.omang@oracle.com, devicetree@vger.kernel.org, pmladek@suse.com, Alexander.Levin@microsoft.com, amir73il@gmail.com, dan.carpenter@oracle.com, wfg@linux.intel.com, Brendan Higgins <brendanhiggins@google.com>
List-Id: linux-nvdimm@lists.01.org

Quoting Brendan Higgins (2019-02-14 13:37:14)
> @@ -104,6 +167,7 @@ struct kunit {
>         const char *name; /* Read only after initialization! */
>         spinlock_t lock; /* Gaurds all mutable test state. */
>         bool success; /* Protected by lock. */
> +       struct list_head resources; /* Protected by lock. */
>         void (*vprintk)(const struct kunit *test,
>                         const char *level,
>                         struct va_format *vaf);
> @@ -127,6 +191,51 @@ int kunit_run_tests(struct kunit_module *module);
>                 } \
>                 late_initcall(module_kunit_init##module)
> =20
> +/**
> + * kunit_alloc_resource() - Allocates a *test managed resource*.
> + * @test: The test context object.
> + * @init: a user supplied function to initialize the resource.
> + * @free: a user supplied function to free the resource.
> + * @context: for the user to pass in arbitrary data.

Nitpick: "pass in arbitrary data to the init function"? Maybe that
provides some more clarity.

> + *
> + * Allocates a *test managed resource*, a resource which will automatica=
lly be
> + * cleaned up at the end of a test case. See &struct kunit_resource for =
an
> + * example.
> + */
