From: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v4 08/17] kunit: test: add support for test abort
Date: Mon, 18 Feb 2019 11:52:37 -0800
Message-ID: <da1995fa-a362-dfe6-8184-7fcdf2b923e8@gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-9-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190214213729.21702-9-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, pmladek-IBi9RG/b67k@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On 2/14/19 1:37 PM, Brendan Higgins wrote:
> Add support for aborting/bailing out of test cases. Needed for
> implementing assertions.
> 
> Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> Changes Since Last Version
>  - This patch is new introducing a new cross-architecture way to abort
>    out of a test case (needed for KUNIT_ASSERT_*, see next patch for
>    details).
>  - On a side note, this is not a complete replacement for the UML abort
>    mechanism, but covers the majority of necessary functionality. UML
>    architecture specific featurs have been dropped from the initial
>    patchset.
> ---
>  include/kunit/test.h |  24 +++++
>  kunit/Makefile       |   3 +-
>  kunit/test-test.c    | 127 ++++++++++++++++++++++++++
>  kunit/test.c         | 208 +++++++++++++++++++++++++++++++++++++++++--
>  4 files changed, 353 insertions(+), 9 deletions(-)
>  create mode 100644 kunit/test-test.c

< snip >

> diff --git a/kunit/test.c b/kunit/test.c
> index d18c50d5ed671..6e5244642ab07 100644
> --- a/kunit/test.c
> +++ b/kunit/test.c
> @@ -6,9 +6,9 @@
>   * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>   */
>  
> -#include <linux/sched.h>
>  #include <linux/sched/debug.h>
> -#include <os.h>
> +#include <linux/completion.h>
> +#include <linux/kthread.h>
>  #include <kunit/test.h>
>  
>  static bool kunit_get_success(struct kunit *test)
> @@ -32,6 +32,27 @@ static void kunit_set_success(struct kunit *test, bool success)
>  	spin_unlock_irqrestore(&test->lock, flags);
>  }
>  
> +static bool kunit_get_death_test(struct kunit *test)
> +{
> +	unsigned long flags;
> +	bool death_test;
> +
> +	spin_lock_irqsave(&test->lock, flags);
> +	death_test = test->death_test;
> +	spin_unlock_irqrestore(&test->lock, flags);
> +
> +	return death_test;
> +}
> +
> +static void kunit_set_death_test(struct kunit *test, bool death_test)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&test->lock, flags);
> +	test->death_test = death_test;
> +	spin_unlock_irqrestore(&test->lock, flags);
> +}
> +
>  static int kunit_vprintk_emit(const struct kunit *test,
>  			      int level,
>  			      const char *fmt,
> @@ -70,13 +91,29 @@ static void kunit_fail(struct kunit *test, struct kunit_stream *stream)
>  	stream->commit(stream);
>  }
>  
> +static void __noreturn kunit_abort(struct kunit *test)
> +{
> +	kunit_set_death_test(test, true);
> +
> +	test->try_catch.throw(&test->try_catch);
> +
> +	/*
> +	 * Throw could not abort from test.
> +	 */
> +	kunit_err(test, "Throw could not abort from test!");
> +	show_stack(NULL, NULL);
> +	BUG();

kunit_abort() is what will be call as the result of an assert failure.

BUG(), which is a panic, which is crashing the system is not acceptable
in the Linux kernel.  You will just annoy Linus if you submit this.

-Frank

< snip >
