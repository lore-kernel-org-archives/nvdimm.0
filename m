Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com
 [IPv6:2607:f8b0:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9021A208AE2BD
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 12:45:02 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id q206so12503653pgq.4
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 12:45:02 -0800 (PST)
Subject: Re: [RFC v3 18/19] of: unittest: split out a couple of test cases
 from unittest
From: Frank Rowand <frowand.list@gmail.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-19-brendanhiggins@google.com>
 <990bfc7d-dc5e-d8d3-c151-9b321ff2ac10@gmail.com>
 <CAFd5g45tOGgf_sKGYRC=fpnTBKGaG=8frbQdgZ3ZTkQFyTfP5A@mail.gmail.com>
 <88fe0546-7850-5bb4-9673-b1aef2dccb3e@gmail.com>
 <CAFd5g444f-FBq4x3U7BL-EY+bFxP0rsJhJ14=mjOi89PhMkURg@mail.gmail.com>
 <0e311e88-c4d4-e98d-1720-53a04bd526fc@gmail.com>
 <CAFd5g44NTZoSAJPMvXP2xvJgn7m5QoV-KJu2AMrr67+eL+CKrQ@mail.gmail.com>
 <d9f7e000-4cac-a35a-3ff9-60130e12ebea@gmail.com>
Message-ID: <72cd1c5b-6f68-73ad-c8fd-f3a3268a0529@gmail.com>
Date: Wed, 20 Feb 2019 12:44:58 -0800
MIME-Version: 1.0
In-Reply-To: <d9f7e000-4cac-a35a-3ff9-60130e12ebea@gmail.com>
Content-Language: en-US
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
Cc: brakmo@fb.com, dri-devel <dri-devel@lists.freedesktop.org>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, "Bird," Timothy" <Tim.Bird@sony.com>, Kees Cook <keescook@google.com>," linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On 2/18/19 2:25 PM, Frank Rowand wrote:
> On 2/15/19 2:56 AM, Brendan Higgins wrote:
>> On Thu, Feb 14, 2019 at 6:05 PM Frank Rowand <frowand.list@gmail.com> wrote:
>>>
>>> On 2/14/19 4:56 PM, Brendan Higgins wrote:
>>>> On Thu, Feb 14, 2019 at 3:57 PM Frank Rowand <frowand.list@gmail.com> wrote:
>>>>>
>>>>> On 12/5/18 3:54 PM, Brendan Higgins wrote:
>>>>>> On Tue, Dec 4, 2018 at 2:58 AM Frank Rowand <frowand.list@gmail.com> wrote:
>>>>>>>

< snip >

>
> It makes it harder for me to read the source of the tests and
> understand the order they will execute.  It also makes it harder
> for me to read through the actual tests (in this example the
> tests that are currently grouped in of_unittest_find_node_by_name())
> because of all the extra function headers injected into the
> existing single function to break it apart into many smaller
> functions.

< snip >

>>>> This is not something I feel particularly strongly about, it is just
>>>> pretty atypical from my experience to have so many unrelated test
>>>> cases in a single file.
>>>>
>>>> Maybe you would prefer that I break up the test cases first, and then
>>>> we split up the file as appropriate?
>>>
>>> I prefer that the test cases not be broken up arbitrarily.  There _may_

I expect that I created confusion by putting this in a reply to patch 18/19.
It is actually a comment about patch 19/19.  Sorry about that.


>>
>> I wasn't trying to break them up arbitrarily. I thought I was doing it
>> according to a pattern (breaking up the file, that is), but maybe I
>> just hadn't looked at enough examples.
> 
> This goes back to the kunit model of putting each test into a separate
> function that can be a KUNIT_CASE().  That is a model that I do not agree
> with for devicetree.

So now that I am actually talking about patch 19/19, let me give a concrete
example.  I will cut and paste (after my comments), the beginning portion
of base-test.c, after applying patch 19/19 (the "base version".  Then I
will cut and paste my alternative version which does not break the tests
down into individual functions (the "frank version").

I will also reply to this email with the base version and the frank version
as attachments, which will make it easier to save as separate versions
for easier viewing.  I'm not sure if an email with attachments will make
it through the list servers, but I am cautiously optimistic.

I am using v4 of the patch series because I never got v3 to cleanly apply
and it is not a constructive use of my time to do so since I have v4 applied.

One of the points I was trying to make is that readability suffers from the
approach taken by patches 18/19 and 19/19.

The base version contains the extra text of a function header for each
unit test.  This is visual noise and makes the file larger.  It is also
one more possible location of an error (although not likely).

The frank version has converted each of the new function headers into
a comment, using the function name with '_' converted to ' '.  The
comments are more readable than the function headers.  Note that I added
an extra blank line before each comment, which violates the kernel
coding standards, but I feel this makes the code more readable.

The base version needs to declare each of the individual test functions
in of_test_find_node_by_name_cases[]. It is possible that a test function
could be left out of of_test_find_node_by_name_cases[], in error.  This
will result in a compile warning (I think warning instead of error, but
I have not verified that) so the error might be caught or it might be
overlooked.

In the base version, the order of execution of the test code requires
bouncing back and forth between the test functions and the coding of
of_test_find_node_by_name_cases[].

In the frank version the order of execution of the test code is obvious.

It is possible that a test function could be left out of
of_test_find_node_by_name_cases[], in error.  This will result in a compile
warning (I think warning instead of error, but I have not verified that)
so it might be caught or it might be overlooked.

The base version is 265 lines.  The frank version is 208 lines, 57 lines
less.  Less is better.


## ==========  base version  ====================================

// SPDX-License-Identifier: GPL-2.0
/*
 * Unit tests for functions defined in base.c.
 */
#include <linux/of.h>

#include <kunit/test.h>

#include "test-common.h"

static void of_test_find_node_by_name_basic(struct kunit *test)
{
	struct device_node *np;
	const char *name;

	np = of_find_node_by_path("/testcase-data");
	name = kasprintf(GFP_KERNEL, "%pOF", np);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
			       "find /testcase-data failed\n");
	of_node_put(np);
	kfree(name);
}

static void of_test_find_node_by_name_trailing_slash(struct kunit *test)
{
	/* Test if trailing '/' works */
	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("/testcase-data/"), NULL,
			    "trailing '/' on /testcase-data/ should fail\n");

}

static void of_test_find_node_by_name_multiple_components(struct kunit *test)
{
	struct device_node *np;
	const char *name;

	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	name = kasprintf(GFP_KERNEL, "%pOF", np);
	KUNIT_EXPECT_STREQ_MSG(
		test, "/testcase-data/phandle-tests/consumer-a", name,
		"find /testcase-data/phandle-tests/consumer-a failed\n");
	of_node_put(np);
	kfree(name);
}

static void of_test_find_node_by_name_with_alias(struct kunit *test)
{
	struct device_node *np;
	const char *name;

	np = of_find_node_by_path("testcase-alias");
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	name = kasprintf(GFP_KERNEL, "%pOF", np);
	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
			       "find testcase-alias failed\n");
	of_node_put(np);
	kfree(name);
}

static void of_test_find_node_by_name_with_alias_and_slash(struct kunit *test)
{
	/* Test if trailing '/' works on aliases */
	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("testcase-alias/"), NULL,
			   "trailing '/' on testcase-alias/ should fail\n");
}

/*
 * TODO(brendanhiggins@google.com): This looks like a duplicate of
 * of_test_find_node_by_name_multiple_components
 */
static void of_test_find_node_by_name_multiple_components_2(struct kunit *test)
{
	struct device_node *np;
	const char *name;

	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	name = kasprintf(GFP_KERNEL, "%pOF", np);
	KUNIT_EXPECT_STREQ_MSG(
		test, "/testcase-data/phandle-tests/consumer-a", name,
		"find testcase-alias/phandle-tests/consumer-a failed\n");
	of_node_put(np);
	kfree(name);
}

static void of_test_find_node_by_name_missing_path(struct kunit *test)
{
	struct device_node *np;

	KUNIT_EXPECT_EQ_MSG(
		test,
		np = of_find_node_by_path("/testcase-data/missing-path"), NULL,
		"non-existent path returned node %pOF\n", np);
	of_node_put(np);
}

static void of_test_find_node_by_name_missing_alias(struct kunit *test)
{
	struct device_node *np;

	KUNIT_EXPECT_EQ_MSG(
		test, np = of_find_node_by_path("missing-alias"), NULL,
		"non-existent alias returned node %pOF\n", np);
	of_node_put(np);
}

static void of_test_find_node_by_name_missing_alias_with_relative_path(
		struct kunit *test)
{
	struct device_node *np;

	KUNIT_EXPECT_EQ_MSG(
		test,
		np = of_find_node_by_path("testcase-alias/missing-path"), NULL,
		"non-existent alias with relative path returned node %pOF\n",
		np);
	of_node_put(np);
}

static void of_test_find_node_by_name_with_option(struct kunit *test)
{
	struct device_node *np;
	const char *options;

	np = of_find_node_opts_by_path("/testcase-data:testoption", &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "testoption", options,
			       "option path test failed\n");
	of_node_put(np);
}

static void of_test_find_node_by_name_with_option_and_slash(struct kunit *test)
{
	struct device_node *np;
	const char *options;

	np = of_find_node_opts_by_path("/testcase-data:test/option", &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
			       "option path test, subcase #1 failed\n");
	of_node_put(np);

	np = of_find_node_opts_by_path("/testcase-data/testcase-device1:test/option", &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
			       "option path test, subcase #2 failed\n");
	of_node_put(np);
}

static void of_test_find_node_by_name_with_null_option(struct kunit *test)
{
	struct device_node *np;

	np = of_find_node_opts_by_path("/testcase-data:testoption", NULL);
	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
					 "NULL option path test failed\n");
	of_node_put(np);
}

static void of_test_find_node_by_name_with_option_alias(struct kunit *test)
{
	struct device_node *np;
	const char *options;

	np = of_find_node_opts_by_path("testcase-alias:testaliasoption",
				       &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "testaliasoption", options,
			       "option alias path test failed\n");
	of_node_put(np);
}

static void of_test_find_node_by_name_with_option_alias_and_slash(
		struct kunit *test)
{
	struct device_node *np;
	const char *options;

	np = of_find_node_opts_by_path("testcase-alias:test/alias/option",
				       &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "test/alias/option", options,
			       "option alias path test, subcase #1 failed\n");
	of_node_put(np);
}

static void of_test_find_node_by_name_with_null_option_alias(struct kunit *test)
{
	struct device_node *np;

	np = of_find_node_opts_by_path("testcase-alias:testaliasoption", NULL);
	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(
			test, np, "NULL option alias path test failed\n");
	of_node_put(np);
}

static void of_test_find_node_by_name_option_clearing(struct kunit *test)
{
	struct device_node *np;
	const char *options;

	options = "testoption";
	np = of_find_node_opts_by_path("testcase-alias", &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
			    "option clearing test failed\n");
	of_node_put(np);
}

static void of_test_find_node_by_name_option_clearing_root(struct kunit *test)
{
	struct device_node *np;
	const char *options;

	options = "testoption";
	np = of_find_node_opts_by_path("/", &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
			    "option clearing root node test failed\n");
	of_node_put(np);
}

static int of_test_find_node_by_name_init(struct kunit *test)
{
	/* adding data for unittest */
	KUNIT_ASSERT_EQ(test, 0, unittest_data_add());

	if (!of_aliases)
		of_aliases = of_find_node_by_path("/aliases");

	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_find_node_by_path(
			"/testcase-data/phandle-tests/consumer-a"));

	return 0;
}

static struct kunit_case of_test_find_node_by_name_cases[] = {
	KUNIT_CASE(of_test_find_node_by_name_basic),
	KUNIT_CASE(of_test_find_node_by_name_trailing_slash),
	KUNIT_CASE(of_test_find_node_by_name_multiple_components),
	KUNIT_CASE(of_test_find_node_by_name_with_alias),
	KUNIT_CASE(of_test_find_node_by_name_with_alias_and_slash),
	KUNIT_CASE(of_test_find_node_by_name_multiple_components_2),
	KUNIT_CASE(of_test_find_node_by_name_missing_path),
	KUNIT_CASE(of_test_find_node_by_name_missing_alias),
	KUNIT_CASE(of_test_find_node_by_name_missing_alias_with_relative_path),
	KUNIT_CASE(of_test_find_node_by_name_with_option),
	KUNIT_CASE(of_test_find_node_by_name_with_option_and_slash),
	KUNIT_CASE(of_test_find_node_by_name_with_null_option),
	KUNIT_CASE(of_test_find_node_by_name_with_option_alias),
	KUNIT_CASE(of_test_find_node_by_name_with_option_alias_and_slash),
	KUNIT_CASE(of_test_find_node_by_name_with_null_option_alias),
	KUNIT_CASE(of_test_find_node_by_name_option_clearing),
	KUNIT_CASE(of_test_find_node_by_name_option_clearing_root),
	{},
};

static struct kunit_module of_test_find_node_by_name_module = {
	.name = "of-test-find-node-by-name",
	.init = of_test_find_node_by_name_init,
	.test_cases = of_test_find_node_by_name_cases,
};
module_test(of_test_find_node_by_name_module);


## ==========  frank version  ===================================

	// SPDX-License-Identifier: GPL-2.0
/*
 * Unit tests for functions defined in base.c.
 */
#include <linux/of.h>

#include <kunit/test.h>

#include "test-common.h"

static void of_unittest_find_node_by_name(struct kunit *test)
{
	struct device_node *np;
	const char *options, *name;


	// find node by name basic

	np = of_find_node_by_path("/testcase-data");
	name = kasprintf(GFP_KERNEL, "%pOF", np);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
			       "find /testcase-data failed\n");
	of_node_put(np);
	kfree(name);


	// find node by name trailing slash

	/* Test if trailing '/' works */
	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("/testcase-data/"), NULL,
			    "trailing '/' on /testcase-data/ should fail\n");


	// find node by name multiple components

	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	name = kasprintf(GFP_KERNEL, "%pOF", np);
	KUNIT_EXPECT_STREQ_MSG(
		test, "/testcase-data/phandle-tests/consumer-a", name,
		"find /testcase-data/phandle-tests/consumer-a failed\n");
	of_node_put(np);
	kfree(name);


	// find node by name with alias

	np = of_find_node_by_path("testcase-alias");
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	name = kasprintf(GFP_KERNEL, "%pOF", np);
	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
			       "find testcase-alias failed\n");
	of_node_put(np);
	kfree(name);


	// find node by name with alias and slash

	/* Test if trailing '/' works on aliases */
	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("testcase-alias/"), NULL,
			    "trailing '/' on testcase-alias/ should fail\n");


	// find node by name multiple components 2

	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	name = kasprintf(GFP_KERNEL, "%pOF", np);
	KUNIT_EXPECT_STREQ_MSG(
		test, "/testcase-data/phandle-tests/consumer-a", name,
		"find testcase-alias/phandle-tests/consumer-a failed\n");
	of_node_put(np);
	kfree(name);


	// find node by name missing path

	KUNIT_EXPECT_EQ_MSG(
		test,
		np = of_find_node_by_path("/testcase-data/missing-path"), NULL,
		"non-existent path returned node %pOF\n", np);
	of_node_put(np);


	// find node by name missing alias

	KUNIT_EXPECT_EQ_MSG(
		test, np = of_find_node_by_path("missing-alias"), NULL,
		"non-existent alias returned node %pOF\n", np);
	of_node_put(np);


	//  find node by name missing alias with relative path

	KUNIT_EXPECT_EQ_MSG(
		test,
		np = of_find_node_by_path("testcase-alias/missing-path"), NULL,
		"non-existent alias with relative path returned node %pOF\n",
		np);
	of_node_put(np);


	// find node by name with option

	np = of_find_node_opts_by_path("/testcase-data:testoption", &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "testoption", options,
			       "option path test failed\n");
	of_node_put(np);


	// find node by name with option and slash

	np = of_find_node_opts_by_path("/testcase-data:test/option", &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
			       "option path test, subcase #1 failed\n");
	of_node_put(np);

	np = of_find_node_opts_by_path("/testcase-data/testcase-device1:test/option", &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
			       "option path test, subcase #2 failed\n");
	of_node_put(np);


	// find node by name with null option

	np = of_find_node_opts_by_path("/testcase-data:testoption", NULL);
	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
					 "NULL option path test failed\n");
	of_node_put(np);


	// find node by name with option alias

	np = of_find_node_opts_by_path("testcase-alias:testaliasoption",
				       &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "testaliasoption", options,
			       "option alias path test failed\n");
	of_node_put(np);


	// find node by name with option alias and slash

	np = of_find_node_opts_by_path("testcase-alias:test/alias/option",
				       &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_STREQ_MSG(test, "test/alias/option", options,
			       "option alias path test, subcase #1 failed\n");
	of_node_put(np);


	// find node by name with null option alias

	np = of_find_node_opts_by_path("testcase-alias:testaliasoption", NULL);
	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(
			test, np, "NULL option alias path test failed\n");
	of_node_put(np);


	// find node by name option clearing

	options = "testoption";
	np = of_find_node_opts_by_path("testcase-alias", &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
			    "option clearing test failed\n");
	of_node_put(np);


	// find node by name option clearing root

	options = "testoption";
	np = of_find_node_opts_by_path("/", &options);
	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
			    "option clearing root node test failed\n");
	of_node_put(np);
}

static int of_test_init(struct kunit *test)
{
	/* adding data for unittest */
	KUNIT_ASSERT_EQ(test, 0, unittest_data_add());

	if (!of_aliases)
		of_aliases = of_find_node_by_path("/aliases");

	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_find_node_by_path(
			"/testcase-data/phandle-tests/consumer-a"));

	return 0;
}

static struct kunit_case of_test_cases[] = {
	KUNIT_CASE(of_unittest_find_node_by_name),
	{},
};

static struct kunit_module of_test_module = {
	.name = "of-base-test",
	.init = of_test_init,
	.test_cases = of_test_cases,
};
module_test(of_test_module);


> 
> 
>>> be cases where the devicetree unittests are currently not well grouped
>>> and may benefit from change, but if so that should be handled independently
>>> of any transformation into a KUnit framework.
>>
>> I agree. I did this because I wanted to illustrate what I thought real
>> world KUnit unit tests should look like (I also wanted to be able to
>> show off KUnit test features that help you write these kinds of
>> tests); I was not necessarily intending that all the of: unittest
>> patches would get merged in with the whole RFC. I was mostly trying to
>> create cause for discussion (which it seems like I succeeded at ;-) ).
>>
>> So fair enough, I will propose these patches separately and later
>> (except of course this one that splits up the file). Do you want the
>> initial transformation to the KUnit framework in the main KUnit
>> patchset, or do you want that to be done separately? If I recall, Rob
>> suggested this as a good initial example that other people could refer
>> to, and some people seemed to think that I needed one to help guide
>> the discussion and provide direction for early users. I don't
>> necessarily think that means the initial real world example needs to
>> be a part of the initial patchset though.
>>
>> Cheers
>>
> 
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
