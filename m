Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com
 [IPv6:2607:f8b0:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63929211CBD09
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 12:47:24 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id h11so10139198pgl.0
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 12:47:24 -0800 (PST)
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
 <72cd1c5b-6f68-73ad-c8fd-f3a3268a0529@gmail.com>
Message-ID: <af11bb26-6f7e-393a-5109-0c33cdab6b42@gmail.com>
Date: Wed, 20 Feb 2019 12:47:20 -0800
MIME-Version: 1.0
In-Reply-To: <72cd1c5b-6f68-73ad-c8fd-f3a3268a0529@gmail.com>
Content-Type: multipart/mixed; boundary="------------E517A228A219C58C15E0B9C4"
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Brendan Higgins <brendanhiggins@google.com>
Cc: brakmo@fb.com, dri-devel <dri-devel@lists.freedesktop.org>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, "Bird," Timothy" <Tim.Bird@sony.com>, Kees Cook <keescook@google.com>," linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

This is a multi-part message in MIME format.
--------------E517A228A219C58C15E0B9C4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2/20/19 12:44 PM, Frank Rowand wrote:
> On 2/18/19 2:25 PM, Frank Rowand wrote:
>> On 2/15/19 2:56 AM, Brendan Higgins wrote:
>>> On Thu, Feb 14, 2019 at 6:05 PM Frank Rowand <frowand.list@gmail.com> wrote:
>>>>
>>>> On 2/14/19 4:56 PM, Brendan Higgins wrote:
>>>>> On Thu, Feb 14, 2019 at 3:57 PM Frank Rowand <frowand.list@gmail.com> wrote:
>>>>>>
>>>>>> On 12/5/18 3:54 PM, Brendan Higgins wrote:
>>>>>>> On Tue, Dec 4, 2018 at 2:58 AM Frank Rowand <frowand.list@gmail.com> wrote:
>>>>>>>>
> 
> < snip >
> 
>>
>> It makes it harder for me to read the source of the tests and
>> understand the order they will execute.  It also makes it harder
>> for me to read through the actual tests (in this example the
>> tests that are currently grouped in of_unittest_find_node_by_name())
>> because of all the extra function headers injected into the
>> existing single function to break it apart into many smaller
>> functions.
> 
> < snip >
> 
>>>>> This is not something I feel particularly strongly about, it is just
>>>>> pretty atypical from my experience to have so many unrelated test
>>>>> cases in a single file.
>>>>>
>>>>> Maybe you would prefer that I break up the test cases first, and then
>>>>> we split up the file as appropriate?
>>>>
>>>> I prefer that the test cases not be broken up arbitrarily.  There _may_
> 
> I expect that I created confusion by putting this in a reply to patch 18/19.
> It is actually a comment about patch 19/19.  Sorry about that.
> 
> 
>>>
>>> I wasn't trying to break them up arbitrarily. I thought I was doing it
>>> according to a pattern (breaking up the file, that is), but maybe I
>>> just hadn't looked at enough examples.
>>
>> This goes back to the kunit model of putting each test into a separate
>> function that can be a KUNIT_CASE().  That is a model that I do not agree
>> with for devicetree.
> 
> So now that I am actually talking about patch 19/19, let me give a concrete
> example.  I will cut and paste (after my comments), the beginning portion
> of base-test.c, after applying patch 19/19 (the "base version".  Then I
> will cut and paste my alternative version which does not break the tests
> down into individual functions (the "frank version").
> 
> I will also reply to this email with the base version and the frank version
> as attachments, which will make it easier to save as separate versions
> for easier viewing.  I'm not sure if an email with attachments will make
> it through the list servers, but I am cautiously optimistic.

base_version and frank_version attached.

-Frank


> 
> I am using v4 of the patch series because I never got v3 to cleanly apply
> and it is not a constructive use of my time to do so since I have v4 applied.
> 
> One of the points I was trying to make is that readability suffers from the
> approach taken by patches 18/19 and 19/19.
> 
> The base version contains the extra text of a function header for each
> unit test.  This is visual noise and makes the file larger.  It is also
> one more possible location of an error (although not likely).
> 
> The frank version has converted each of the new function headers into
> a comment, using the function name with '_' converted to ' '.  The
> comments are more readable than the function headers.  Note that I added
> an extra blank line before each comment, which violates the kernel
> coding standards, but I feel this makes the code more readable.
> 
> The base version needs to declare each of the individual test functions
> in of_test_find_node_by_name_cases[]. It is possible that a test function
> could be left out of of_test_find_node_by_name_cases[], in error.  This
> will result in a compile warning (I think warning instead of error, but
> I have not verified that) so the error might be caught or it might be
> overlooked.
> 
> In the base version, the order of execution of the test code requires
> bouncing back and forth between the test functions and the coding of
> of_test_find_node_by_name_cases[].
> 
> In the frank version the order of execution of the test code is obvious.
> 
> It is possible that a test function could be left out of
> of_test_find_node_by_name_cases[], in error.  This will result in a compile
> warning (I think warning instead of error, but I have not verified that)
> so it might be caught or it might be overlooked.
> 
> The base version is 265 lines.  The frank version is 208 lines, 57 lines
> less.  Less is better.
> 
> 
> ## ==========  base version  ====================================
> 
> // SPDX-License-Identifier: GPL-2.0
> /*
>  * Unit tests for functions defined in base.c.
>  */
> #include <linux/of.h>
> 
> #include <kunit/test.h>
> 
> #include "test-common.h"
> 
> static void of_test_find_node_by_name_basic(struct kunit *test)
> {
> 	struct device_node *np;
> 	const char *name;
> 
> 	np = of_find_node_by_path("/testcase-data");
> 	name = kasprintf(GFP_KERNEL, "%pOF", np);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
> 			       "find /testcase-data failed\n");
> 	of_node_put(np);
> 	kfree(name);
> }
> 
> static void of_test_find_node_by_name_trailing_slash(struct kunit *test)
> {
> 	/* Test if trailing '/' works */
> 	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("/testcase-data/"), NULL,
> 			    "trailing '/' on /testcase-data/ should fail\n");
> 
> }
> 
> static void of_test_find_node_by_name_multiple_components(struct kunit *test)
> {
> 	struct device_node *np;
> 	const char *name;
> 
> 	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	name = kasprintf(GFP_KERNEL, "%pOF", np);
> 	KUNIT_EXPECT_STREQ_MSG(
> 		test, "/testcase-data/phandle-tests/consumer-a", name,
> 		"find /testcase-data/phandle-tests/consumer-a failed\n");
> 	of_node_put(np);
> 	kfree(name);
> }
> 
> static void of_test_find_node_by_name_with_alias(struct kunit *test)
> {
> 	struct device_node *np;
> 	const char *name;
> 
> 	np = of_find_node_by_path("testcase-alias");
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	name = kasprintf(GFP_KERNEL, "%pOF", np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
> 			       "find testcase-alias failed\n");
> 	of_node_put(np);
> 	kfree(name);
> }
> 
> static void of_test_find_node_by_name_with_alias_and_slash(struct kunit *test)
> {
> 	/* Test if trailing '/' works on aliases */
> 	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("testcase-alias/"), NULL,
> 			   "trailing '/' on testcase-alias/ should fail\n");
> }
> 
> /*
>  * TODO(brendanhiggins@google.com): This looks like a duplicate of
>  * of_test_find_node_by_name_multiple_components
>  */
> static void of_test_find_node_by_name_multiple_components_2(struct kunit *test)
> {
> 	struct device_node *np;
> 	const char *name;
> 
> 	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	name = kasprintf(GFP_KERNEL, "%pOF", np);
> 	KUNIT_EXPECT_STREQ_MSG(
> 		test, "/testcase-data/phandle-tests/consumer-a", name,
> 		"find testcase-alias/phandle-tests/consumer-a failed\n");
> 	of_node_put(np);
> 	kfree(name);
> }
> 
> static void of_test_find_node_by_name_missing_path(struct kunit *test)
> {
> 	struct device_node *np;
> 
> 	KUNIT_EXPECT_EQ_MSG(
> 		test,
> 		np = of_find_node_by_path("/testcase-data/missing-path"), NULL,
> 		"non-existent path returned node %pOF\n", np);
> 	of_node_put(np);
> }
> 
> static void of_test_find_node_by_name_missing_alias(struct kunit *test)
> {
> 	struct device_node *np;
> 
> 	KUNIT_EXPECT_EQ_MSG(
> 		test, np = of_find_node_by_path("missing-alias"), NULL,
> 		"non-existent alias returned node %pOF\n", np);
> 	of_node_put(np);
> }
> 
> static void of_test_find_node_by_name_missing_alias_with_relative_path(
> 		struct kunit *test)
> {
> 	struct device_node *np;
> 
> 	KUNIT_EXPECT_EQ_MSG(
> 		test,
> 		np = of_find_node_by_path("testcase-alias/missing-path"), NULL,
> 		"non-existent alias with relative path returned node %pOF\n",
> 		np);
> 	of_node_put(np);
> }
> 
> static void of_test_find_node_by_name_with_option(struct kunit *test)
> {
> 	struct device_node *np;
> 	const char *options;
> 
> 	np = of_find_node_opts_by_path("/testcase-data:testoption", &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "testoption", options,
> 			       "option path test failed\n");
> 	of_node_put(np);
> }
> 
> static void of_test_find_node_by_name_with_option_and_slash(struct kunit *test)
> {
> 	struct device_node *np;
> 	const char *options;
> 
> 	np = of_find_node_opts_by_path("/testcase-data:test/option", &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
> 			       "option path test, subcase #1 failed\n");
> 	of_node_put(np);
> 
> 	np = of_find_node_opts_by_path("/testcase-data/testcase-device1:test/option", &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
> 			       "option path test, subcase #2 failed\n");
> 	of_node_put(np);
> }
> 
> static void of_test_find_node_by_name_with_null_option(struct kunit *test)
> {
> 	struct device_node *np;
> 
> 	np = of_find_node_opts_by_path("/testcase-data:testoption", NULL);
> 	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
> 					 "NULL option path test failed\n");
> 	of_node_put(np);
> }
> 
> static void of_test_find_node_by_name_with_option_alias(struct kunit *test)
> {
> 	struct device_node *np;
> 	const char *options;
> 
> 	np = of_find_node_opts_by_path("testcase-alias:testaliasoption",
> 				       &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "testaliasoption", options,
> 			       "option alias path test failed\n");
> 	of_node_put(np);
> }
> 
> static void of_test_find_node_by_name_with_option_alias_and_slash(
> 		struct kunit *test)
> {
> 	struct device_node *np;
> 	const char *options;
> 
> 	np = of_find_node_opts_by_path("testcase-alias:test/alias/option",
> 				       &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "test/alias/option", options,
> 			       "option alias path test, subcase #1 failed\n");
> 	of_node_put(np);
> }
> 
> static void of_test_find_node_by_name_with_null_option_alias(struct kunit *test)
> {
> 	struct device_node *np;
> 
> 	np = of_find_node_opts_by_path("testcase-alias:testaliasoption", NULL);
> 	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(
> 			test, np, "NULL option alias path test failed\n");
> 	of_node_put(np);
> }
> 
> static void of_test_find_node_by_name_option_clearing(struct kunit *test)
> {
> 	struct device_node *np;
> 	const char *options;
> 
> 	options = "testoption";
> 	np = of_find_node_opts_by_path("testcase-alias", &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
> 			    "option clearing test failed\n");
> 	of_node_put(np);
> }
> 
> static void of_test_find_node_by_name_option_clearing_root(struct kunit *test)
> {
> 	struct device_node *np;
> 	const char *options;
> 
> 	options = "testoption";
> 	np = of_find_node_opts_by_path("/", &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
> 			    "option clearing root node test failed\n");
> 	of_node_put(np);
> }
> 
> static int of_test_find_node_by_name_init(struct kunit *test)
> {
> 	/* adding data for unittest */
> 	KUNIT_ASSERT_EQ(test, 0, unittest_data_add());
> 
> 	if (!of_aliases)
> 		of_aliases = of_find_node_by_path("/aliases");
> 
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_find_node_by_path(
> 			"/testcase-data/phandle-tests/consumer-a"));
> 
> 	return 0;
> }
> 
> static struct kunit_case of_test_find_node_by_name_cases[] = {
> 	KUNIT_CASE(of_test_find_node_by_name_basic),
> 	KUNIT_CASE(of_test_find_node_by_name_trailing_slash),
> 	KUNIT_CASE(of_test_find_node_by_name_multiple_components),
> 	KUNIT_CASE(of_test_find_node_by_name_with_alias),
> 	KUNIT_CASE(of_test_find_node_by_name_with_alias_and_slash),
> 	KUNIT_CASE(of_test_find_node_by_name_multiple_components_2),
> 	KUNIT_CASE(of_test_find_node_by_name_missing_path),
> 	KUNIT_CASE(of_test_find_node_by_name_missing_alias),
> 	KUNIT_CASE(of_test_find_node_by_name_missing_alias_with_relative_path),
> 	KUNIT_CASE(of_test_find_node_by_name_with_option),
> 	KUNIT_CASE(of_test_find_node_by_name_with_option_and_slash),
> 	KUNIT_CASE(of_test_find_node_by_name_with_null_option),
> 	KUNIT_CASE(of_test_find_node_by_name_with_option_alias),
> 	KUNIT_CASE(of_test_find_node_by_name_with_option_alias_and_slash),
> 	KUNIT_CASE(of_test_find_node_by_name_with_null_option_alias),
> 	KUNIT_CASE(of_test_find_node_by_name_option_clearing),
> 	KUNIT_CASE(of_test_find_node_by_name_option_clearing_root),
> 	{},
> };
> 
> static struct kunit_module of_test_find_node_by_name_module = {
> 	.name = "of-test-find-node-by-name",
> 	.init = of_test_find_node_by_name_init,
> 	.test_cases = of_test_find_node_by_name_cases,
> };
> module_test(of_test_find_node_by_name_module);
> 
> 
> ## ==========  frank version  ===================================
> 
> 	// SPDX-License-Identifier: GPL-2.0
> /*
>  * Unit tests for functions defined in base.c.
>  */
> #include <linux/of.h>
> 
> #include <kunit/test.h>
> 
> #include "test-common.h"
> 
> static void of_unittest_find_node_by_name(struct kunit *test)
> {
> 	struct device_node *np;
> 	const char *options, *name;
> 
> 
> 	// find node by name basic
> 
> 	np = of_find_node_by_path("/testcase-data");
> 	name = kasprintf(GFP_KERNEL, "%pOF", np);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
> 			       "find /testcase-data failed\n");
> 	of_node_put(np);
> 	kfree(name);
> 
> 
> 	// find node by name trailing slash
> 
> 	/* Test if trailing '/' works */
> 	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("/testcase-data/"), NULL,
> 			    "trailing '/' on /testcase-data/ should fail\n");
> 
> 
> 	// find node by name multiple components
> 
> 	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	name = kasprintf(GFP_KERNEL, "%pOF", np);
> 	KUNIT_EXPECT_STREQ_MSG(
> 		test, "/testcase-data/phandle-tests/consumer-a", name,
> 		"find /testcase-data/phandle-tests/consumer-a failed\n");
> 	of_node_put(np);
> 	kfree(name);
> 
> 
> 	// find node by name with alias
> 
> 	np = of_find_node_by_path("testcase-alias");
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	name = kasprintf(GFP_KERNEL, "%pOF", np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
> 			       "find testcase-alias failed\n");
> 	of_node_put(np);
> 	kfree(name);
> 
> 
> 	// find node by name with alias and slash
> 
> 	/* Test if trailing '/' works on aliases */
> 	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("testcase-alias/"), NULL,
> 			    "trailing '/' on testcase-alias/ should fail\n");
> 
> 
> 	// find node by name multiple components 2
> 
> 	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	name = kasprintf(GFP_KERNEL, "%pOF", np);
> 	KUNIT_EXPECT_STREQ_MSG(
> 		test, "/testcase-data/phandle-tests/consumer-a", name,
> 		"find testcase-alias/phandle-tests/consumer-a failed\n");
> 	of_node_put(np);
> 	kfree(name);
> 
> 
> 	// find node by name missing path
> 
> 	KUNIT_EXPECT_EQ_MSG(
> 		test,
> 		np = of_find_node_by_path("/testcase-data/missing-path"), NULL,
> 		"non-existent path returned node %pOF\n", np);
> 	of_node_put(np);
> 
> 
> 	// find node by name missing alias
> 
> 	KUNIT_EXPECT_EQ_MSG(
> 		test, np = of_find_node_by_path("missing-alias"), NULL,
> 		"non-existent alias returned node %pOF\n", np);
> 	of_node_put(np);
> 
> 
> 	//  find node by name missing alias with relative path
> 
> 	KUNIT_EXPECT_EQ_MSG(
> 		test,
> 		np = of_find_node_by_path("testcase-alias/missing-path"), NULL,
> 		"non-existent alias with relative path returned node %pOF\n",
> 		np);
> 	of_node_put(np);
> 
> 
> 	// find node by name with option
> 
> 	np = of_find_node_opts_by_path("/testcase-data:testoption", &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "testoption", options,
> 			       "option path test failed\n");
> 	of_node_put(np);
> 
> 
> 	// find node by name with option and slash
> 
> 	np = of_find_node_opts_by_path("/testcase-data:test/option", &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
> 			       "option path test, subcase #1 failed\n");
> 	of_node_put(np);
> 
> 	np = of_find_node_opts_by_path("/testcase-data/testcase-device1:test/option", &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
> 			       "option path test, subcase #2 failed\n");
> 	of_node_put(np);
> 
> 
> 	// find node by name with null option
> 
> 	np = of_find_node_opts_by_path("/testcase-data:testoption", NULL);
> 	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
> 					 "NULL option path test failed\n");
> 	of_node_put(np);
> 
> 
> 	// find node by name with option alias
> 
> 	np = of_find_node_opts_by_path("testcase-alias:testaliasoption",
> 				       &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "testaliasoption", options,
> 			       "option alias path test failed\n");
> 	of_node_put(np);
> 
> 
> 	// find node by name with option alias and slash
> 
> 	np = of_find_node_opts_by_path("testcase-alias:test/alias/option",
> 				       &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_STREQ_MSG(test, "test/alias/option", options,
> 			       "option alias path test, subcase #1 failed\n");
> 	of_node_put(np);
> 
> 
> 	// find node by name with null option alias
> 
> 	np = of_find_node_opts_by_path("testcase-alias:testaliasoption", NULL);
> 	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(
> 			test, np, "NULL option alias path test failed\n");
> 	of_node_put(np);
> 
> 
> 	// find node by name option clearing
> 
> 	options = "testoption";
> 	np = of_find_node_opts_by_path("testcase-alias", &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
> 			    "option clearing test failed\n");
> 	of_node_put(np);
> 
> 
> 	// find node by name option clearing root
> 
> 	options = "testoption";
> 	np = of_find_node_opts_by_path("/", &options);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
> 			    "option clearing root node test failed\n");
> 	of_node_put(np);
> }
> 
> static int of_test_init(struct kunit *test)
> {
> 	/* adding data for unittest */
> 	KUNIT_ASSERT_EQ(test, 0, unittest_data_add());
> 
> 	if (!of_aliases)
> 		of_aliases = of_find_node_by_path("/aliases");
> 
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_find_node_by_path(
> 			"/testcase-data/phandle-tests/consumer-a"));
> 
> 	return 0;
> }
> 
> static struct kunit_case of_test_cases[] = {
> 	KUNIT_CASE(of_unittest_find_node_by_name),
> 	{},
> };
> 
> static struct kunit_module of_test_module = {
> 	.name = "of-base-test",
> 	.init = of_test_init,
> 	.test_cases = of_test_cases,
> };
> module_test(of_test_module);
> 
> 
>>
>>
>>>> be cases where the devicetree unittests are currently not well grouped
>>>> and may benefit from change, but if so that should be handled independently
>>>> of any transformation into a KUnit framework.
>>>
>>> I agree. I did this because I wanted to illustrate what I thought real
>>> world KUnit unit tests should look like (I also wanted to be able to
>>> show off KUnit test features that help you write these kinds of
>>> tests); I was not necessarily intending that all the of: unittest
>>> patches would get merged in with the whole RFC. I was mostly trying to
>>> create cause for discussion (which it seems like I succeeded at ;-) ).
>>>
>>> So fair enough, I will propose these patches separately and later
>>> (except of course this one that splits up the file). Do you want the
>>> initial transformation to the KUnit framework in the main KUnit
>>> patchset, or do you want that to be done separately? If I recall, Rob
>>> suggested this as a good initial example that other people could refer
>>> to, and some people seemed to think that I needed one to help guide
>>> the discussion and provide direction for early users. I don't
>>> necessarily think that means the initial real world example needs to
>>> be a part of the initial patchset though.
>>>
>>> Cheers
>>>
>>
>>
> 
> 


--------------E517A228A219C58C15E0B9C4
Content-Type: text/plain; charset=UTF-8;
 name="base_version"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="base_version"

Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKLyoKICogVW5pdCB0ZXN0cyBm
b3IgZnVuY3Rpb25zIGRlZmluZWQgaW4gYmFzZS5jLgogKi8KI2luY2x1ZGUgPGxpbnV4L29m
Lmg+CgojaW5jbHVkZSA8a3VuaXQvdGVzdC5oPgoKI2luY2x1ZGUgInRlc3QtY29tbW9uLmgi
CgpzdGF0aWMgdm9pZCBvZl90ZXN0X2ZpbmRfbm9kZV9ieV9uYW1lX2Jhc2ljKHN0cnVjdCBr
dW5pdCAqdGVzdCkKewoJc3RydWN0IGRldmljZV9ub2RlICpucDsKCWNvbnN0IGNoYXIgKm5h
bWU7CgoJbnAgPSBvZl9maW5kX25vZGVfYnlfcGF0aCgiL3Rlc3RjYXNlLWRhdGEiKTsKCW5h
bWUgPSBrYXNwcmludGYoR0ZQX0tFUk5FTCwgIiVwT0YiLCBucCk7CglLVU5JVF9BU1NFUlRf
Tk9UX0VSUl9PUl9OVUxMKHRlc3QsIG5wKTsKCUtVTklUX0VYUEVDVF9TVFJFUV9NU0codGVz
dCwgIi90ZXN0Y2FzZS1kYXRhIiwgbmFtZSwKCQkJICAgICAgICJmaW5kIC90ZXN0Y2FzZS1k
YXRhIGZhaWxlZFxuIik7CglvZl9ub2RlX3B1dChucCk7CglrZnJlZShuYW1lKTsKfQoKc3Rh
dGljIHZvaWQgb2ZfdGVzdF9maW5kX25vZGVfYnlfbmFtZV90cmFpbGluZ19zbGFzaChzdHJ1
Y3Qga3VuaXQgKnRlc3QpCnsKCS8qIFRlc3QgaWYgdHJhaWxpbmcgJy8nIHdvcmtzICovCglL
VU5JVF9FWFBFQ1RfRVFfTVNHKHRlc3QsIG9mX2ZpbmRfbm9kZV9ieV9wYXRoKCIvdGVzdGNh
c2UtZGF0YS8iKSwgTlVMTCwKCQkJICAgICJ0cmFpbGluZyAnLycgb24gL3Rlc3RjYXNlLWRh
dGEvIHNob3VsZCBmYWlsXG4iKTsKCn0KCnN0YXRpYyB2b2lkIG9mX3Rlc3RfZmluZF9ub2Rl
X2J5X25hbWVfbXVsdGlwbGVfY29tcG9uZW50cyhzdHJ1Y3Qga3VuaXQgKnRlc3QpCnsKCXN0
cnVjdCBkZXZpY2Vfbm9kZSAqbnA7Cgljb25zdCBjaGFyICpuYW1lOwoKCW5wID0gb2ZfZmlu
ZF9ub2RlX2J5X3BhdGgoIi90ZXN0Y2FzZS1kYXRhL3BoYW5kbGUtdGVzdHMvY29uc3VtZXIt
YSIpOwoJS1VOSVRfQVNTRVJUX05PVF9FUlJfT1JfTlVMTCh0ZXN0LCBucCk7CgluYW1lID0g
a2FzcHJpbnRmKEdGUF9LRVJORUwsICIlcE9GIiwgbnApOwoJS1VOSVRfRVhQRUNUX1NUUkVR
X01TRygKCQl0ZXN0LCAiL3Rlc3RjYXNlLWRhdGEvcGhhbmRsZS10ZXN0cy9jb25zdW1lci1h
IiwgbmFtZSwKCQkiZmluZCAvdGVzdGNhc2UtZGF0YS9waGFuZGxlLXRlc3RzL2NvbnN1bWVy
LWEgZmFpbGVkXG4iKTsKCW9mX25vZGVfcHV0KG5wKTsKCWtmcmVlKG5hbWUpOwp9CgpzdGF0
aWMgdm9pZCBvZl90ZXN0X2ZpbmRfbm9kZV9ieV9uYW1lX3dpdGhfYWxpYXMoc3RydWN0IGt1
bml0ICp0ZXN0KQp7CglzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wOwoJY29uc3QgY2hhciAqbmFt
ZTsKCglucCA9IG9mX2ZpbmRfbm9kZV9ieV9wYXRoKCJ0ZXN0Y2FzZS1hbGlhcyIpOwoJS1VO
SVRfQVNTRVJUX05PVF9FUlJfT1JfTlVMTCh0ZXN0LCBucCk7CgluYW1lID0ga2FzcHJpbnRm
KEdGUF9LRVJORUwsICIlcE9GIiwgbnApOwoJS1VOSVRfRVhQRUNUX1NUUkVRX01TRyh0ZXN0
LCAiL3Rlc3RjYXNlLWRhdGEiLCBuYW1lLAoJCQkgICAgICAgImZpbmQgdGVzdGNhc2UtYWxp
YXMgZmFpbGVkXG4iKTsKCW9mX25vZGVfcHV0KG5wKTsKCWtmcmVlKG5hbWUpOwp9CgpzdGF0
aWMgdm9pZCBvZl90ZXN0X2ZpbmRfbm9kZV9ieV9uYW1lX3dpdGhfYWxpYXNfYW5kX3NsYXNo
KHN0cnVjdCBrdW5pdCAqdGVzdCkKewoJLyogVGVzdCBpZiB0cmFpbGluZyAnLycgd29ya3Mg
b24gYWxpYXNlcyAqLwoJS1VOSVRfRVhQRUNUX0VRX01TRyh0ZXN0LCBvZl9maW5kX25vZGVf
YnlfcGF0aCgidGVzdGNhc2UtYWxpYXMvIiksIE5VTEwsCgkJCSAgICJ0cmFpbGluZyAnLycg
b24gdGVzdGNhc2UtYWxpYXMvIHNob3VsZCBmYWlsXG4iKTsKfQoKLyoKICogVE9ETyhicmVu
ZGFuaGlnZ2luc0Bnb29nbGUuY29tKTogVGhpcyBsb29rcyBsaWtlIGEgZHVwbGljYXRlIG9m
CiAqIG9mX3Rlc3RfZmluZF9ub2RlX2J5X25hbWVfbXVsdGlwbGVfY29tcG9uZW50cwogKi8K
c3RhdGljIHZvaWQgb2ZfdGVzdF9maW5kX25vZGVfYnlfbmFtZV9tdWx0aXBsZV9jb21wb25l
bnRzXzIoc3RydWN0IGt1bml0ICp0ZXN0KQp7CglzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wOwoJ
Y29uc3QgY2hhciAqbmFtZTsKCglucCA9IG9mX2ZpbmRfbm9kZV9ieV9wYXRoKCJ0ZXN0Y2Fz
ZS1hbGlhcy9waGFuZGxlLXRlc3RzL2NvbnN1bWVyLWEiKTsKCUtVTklUX0FTU0VSVF9OT1Rf
RVJSX09SX05VTEwodGVzdCwgbnApOwoJbmFtZSA9IGthc3ByaW50ZihHRlBfS0VSTkVMLCAi
JXBPRiIsIG5wKTsKCUtVTklUX0VYUEVDVF9TVFJFUV9NU0coCgkJdGVzdCwgIi90ZXN0Y2Fz
ZS1kYXRhL3BoYW5kbGUtdGVzdHMvY29uc3VtZXItYSIsIG5hbWUsCgkJImZpbmQgdGVzdGNh
c2UtYWxpYXMvcGhhbmRsZS10ZXN0cy9jb25zdW1lci1hIGZhaWxlZFxuIik7CglvZl9ub2Rl
X3B1dChucCk7CglrZnJlZShuYW1lKTsKfQoKc3RhdGljIHZvaWQgb2ZfdGVzdF9maW5kX25v
ZGVfYnlfbmFtZV9taXNzaW5nX3BhdGgoc3RydWN0IGt1bml0ICp0ZXN0KQp7CglzdHJ1Y3Qg
ZGV2aWNlX25vZGUgKm5wOwoKCUtVTklUX0VYUEVDVF9FUV9NU0coCgkJdGVzdCwKCQlucCA9
IG9mX2ZpbmRfbm9kZV9ieV9wYXRoKCIvdGVzdGNhc2UtZGF0YS9taXNzaW5nLXBhdGgiKSwg
TlVMTCwKCQkibm9uLWV4aXN0ZW50IHBhdGggcmV0dXJuZWQgbm9kZSAlcE9GXG4iLCBucCk7
CglvZl9ub2RlX3B1dChucCk7Cn0KCnN0YXRpYyB2b2lkIG9mX3Rlc3RfZmluZF9ub2RlX2J5
X25hbWVfbWlzc2luZ19hbGlhcyhzdHJ1Y3Qga3VuaXQgKnRlc3QpCnsKCXN0cnVjdCBkZXZp
Y2Vfbm9kZSAqbnA7CgoJS1VOSVRfRVhQRUNUX0VRX01TRygKCQl0ZXN0LCBucCA9IG9mX2Zp
bmRfbm9kZV9ieV9wYXRoKCJtaXNzaW5nLWFsaWFzIiksIE5VTEwsCgkJIm5vbi1leGlzdGVu
dCBhbGlhcyByZXR1cm5lZCBub2RlICVwT0ZcbiIsIG5wKTsKCW9mX25vZGVfcHV0KG5wKTsK
fQoKc3RhdGljIHZvaWQgb2ZfdGVzdF9maW5kX25vZGVfYnlfbmFtZV9taXNzaW5nX2FsaWFz
X3dpdGhfcmVsYXRpdmVfcGF0aCgKCQlzdHJ1Y3Qga3VuaXQgKnRlc3QpCnsKCXN0cnVjdCBk
ZXZpY2Vfbm9kZSAqbnA7CgoJS1VOSVRfRVhQRUNUX0VRX01TRygKCQl0ZXN0LAoJCW5wID0g
b2ZfZmluZF9ub2RlX2J5X3BhdGgoInRlc3RjYXNlLWFsaWFzL21pc3NpbmctcGF0aCIpLCBO
VUxMLAoJCSJub24tZXhpc3RlbnQgYWxpYXMgd2l0aCByZWxhdGl2ZSBwYXRoIHJldHVybmVk
IG5vZGUgJXBPRlxuIiwKCQlucCk7CglvZl9ub2RlX3B1dChucCk7Cn0KCnN0YXRpYyB2b2lk
IG9mX3Rlc3RfZmluZF9ub2RlX2J5X25hbWVfd2l0aF9vcHRpb24oc3RydWN0IGt1bml0ICp0
ZXN0KQp7CglzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wOwoJY29uc3QgY2hhciAqb3B0aW9uczsK
CglucCA9IG9mX2ZpbmRfbm9kZV9vcHRzX2J5X3BhdGgoIi90ZXN0Y2FzZS1kYXRhOnRlc3Rv
cHRpb24iLCAmb3B0aW9ucyk7CglLVU5JVF9BU1NFUlRfTk9UX0VSUl9PUl9OVUxMKHRlc3Qs
IG5wKTsKCUtVTklUX0VYUEVDVF9TVFJFUV9NU0codGVzdCwgInRlc3RvcHRpb24iLCBvcHRp
b25zLAoJCQkgICAgICAgIm9wdGlvbiBwYXRoIHRlc3QgZmFpbGVkXG4iKTsKCW9mX25vZGVf
cHV0KG5wKTsKfQoKc3RhdGljIHZvaWQgb2ZfdGVzdF9maW5kX25vZGVfYnlfbmFtZV93aXRo
X29wdGlvbl9hbmRfc2xhc2goc3RydWN0IGt1bml0ICp0ZXN0KQp7CglzdHJ1Y3QgZGV2aWNl
X25vZGUgKm5wOwoJY29uc3QgY2hhciAqb3B0aW9uczsKCglucCA9IG9mX2ZpbmRfbm9kZV9v
cHRzX2J5X3BhdGgoIi90ZXN0Y2FzZS1kYXRhOnRlc3Qvb3B0aW9uIiwgJm9wdGlvbnMpOwoJ
S1VOSVRfQVNTRVJUX05PVF9FUlJfT1JfTlVMTCh0ZXN0LCBucCk7CglLVU5JVF9FWFBFQ1Rf
U1RSRVFfTVNHKHRlc3QsICJ0ZXN0L29wdGlvbiIsIG9wdGlvbnMsCgkJCSAgICAgICAib3B0
aW9uIHBhdGggdGVzdCwgc3ViY2FzZSAjMSBmYWlsZWRcbiIpOwoJb2Zfbm9kZV9wdXQobnAp
OwoKCW5wID0gb2ZfZmluZF9ub2RlX29wdHNfYnlfcGF0aCgiL3Rlc3RjYXNlLWRhdGEvdGVz
dGNhc2UtZGV2aWNlMTp0ZXN0L29wdGlvbiIsICZvcHRpb25zKTsKCUtVTklUX0FTU0VSVF9O
T1RfRVJSX09SX05VTEwodGVzdCwgbnApOwoJS1VOSVRfRVhQRUNUX1NUUkVRX01TRyh0ZXN0
LCAidGVzdC9vcHRpb24iLCBvcHRpb25zLAoJCQkgICAgICAgIm9wdGlvbiBwYXRoIHRlc3Qs
IHN1YmNhc2UgIzIgZmFpbGVkXG4iKTsKCW9mX25vZGVfcHV0KG5wKTsKfQoKc3RhdGljIHZv
aWQgb2ZfdGVzdF9maW5kX25vZGVfYnlfbmFtZV93aXRoX251bGxfb3B0aW9uKHN0cnVjdCBr
dW5pdCAqdGVzdCkKewoJc3RydWN0IGRldmljZV9ub2RlICpucDsKCglucCA9IG9mX2ZpbmRf
bm9kZV9vcHRzX2J5X3BhdGgoIi90ZXN0Y2FzZS1kYXRhOnRlc3RvcHRpb24iLCBOVUxMKTsK
CUtVTklUX0VYUEVDVF9OT1RfRVJSX09SX05VTExfTVNHKHRlc3QsIG5wLAoJCQkJCSAiTlVM
TCBvcHRpb24gcGF0aCB0ZXN0IGZhaWxlZFxuIik7CglvZl9ub2RlX3B1dChucCk7Cn0KCnN0
YXRpYyB2b2lkIG9mX3Rlc3RfZmluZF9ub2RlX2J5X25hbWVfd2l0aF9vcHRpb25fYWxpYXMo
c3RydWN0IGt1bml0ICp0ZXN0KQp7CglzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wOwoJY29uc3Qg
Y2hhciAqb3B0aW9uczsKCglucCA9IG9mX2ZpbmRfbm9kZV9vcHRzX2J5X3BhdGgoInRlc3Rj
YXNlLWFsaWFzOnRlc3RhbGlhc29wdGlvbiIsCgkJCQkgICAgICAgJm9wdGlvbnMpOwoJS1VO
SVRfQVNTRVJUX05PVF9FUlJfT1JfTlVMTCh0ZXN0LCBucCk7CglLVU5JVF9FWFBFQ1RfU1RS
RVFfTVNHKHRlc3QsICJ0ZXN0YWxpYXNvcHRpb24iLCBvcHRpb25zLAoJCQkgICAgICAgIm9w
dGlvbiBhbGlhcyBwYXRoIHRlc3QgZmFpbGVkXG4iKTsKCW9mX25vZGVfcHV0KG5wKTsKfQoK
c3RhdGljIHZvaWQgb2ZfdGVzdF9maW5kX25vZGVfYnlfbmFtZV93aXRoX29wdGlvbl9hbGlh
c19hbmRfc2xhc2goCgkJc3RydWN0IGt1bml0ICp0ZXN0KQp7CglzdHJ1Y3QgZGV2aWNlX25v
ZGUgKm5wOwoJY29uc3QgY2hhciAqb3B0aW9uczsKCglucCA9IG9mX2ZpbmRfbm9kZV9vcHRz
X2J5X3BhdGgoInRlc3RjYXNlLWFsaWFzOnRlc3QvYWxpYXMvb3B0aW9uIiwKCQkJCSAgICAg
ICAmb3B0aW9ucyk7CglLVU5JVF9BU1NFUlRfTk9UX0VSUl9PUl9OVUxMKHRlc3QsIG5wKTsK
CUtVTklUX0VYUEVDVF9TVFJFUV9NU0codGVzdCwgInRlc3QvYWxpYXMvb3B0aW9uIiwgb3B0
aW9ucywKCQkJICAgICAgICJvcHRpb24gYWxpYXMgcGF0aCB0ZXN0LCBzdWJjYXNlICMxIGZh
aWxlZFxuIik7CglvZl9ub2RlX3B1dChucCk7Cn0KCnN0YXRpYyB2b2lkIG9mX3Rlc3RfZmlu
ZF9ub2RlX2J5X25hbWVfd2l0aF9udWxsX29wdGlvbl9hbGlhcyhzdHJ1Y3Qga3VuaXQgKnRl
c3QpCnsKCXN0cnVjdCBkZXZpY2Vfbm9kZSAqbnA7CgoJbnAgPSBvZl9maW5kX25vZGVfb3B0
c19ieV9wYXRoKCJ0ZXN0Y2FzZS1hbGlhczp0ZXN0YWxpYXNvcHRpb24iLCBOVUxMKTsKCUtV
TklUX0VYUEVDVF9OT1RfRVJSX09SX05VTExfTVNHKAoJCQl0ZXN0LCBucCwgIk5VTEwgb3B0
aW9uIGFsaWFzIHBhdGggdGVzdCBmYWlsZWRcbiIpOwoJb2Zfbm9kZV9wdXQobnApOwp9Cgpz
dGF0aWMgdm9pZCBvZl90ZXN0X2ZpbmRfbm9kZV9ieV9uYW1lX29wdGlvbl9jbGVhcmluZyhz
dHJ1Y3Qga3VuaXQgKnRlc3QpCnsKCXN0cnVjdCBkZXZpY2Vfbm9kZSAqbnA7Cgljb25zdCBj
aGFyICpvcHRpb25zOwoKCW9wdGlvbnMgPSAidGVzdG9wdGlvbiI7CglucCA9IG9mX2ZpbmRf
bm9kZV9vcHRzX2J5X3BhdGgoInRlc3RjYXNlLWFsaWFzIiwgJm9wdGlvbnMpOwoJS1VOSVRf
QVNTRVJUX05PVF9FUlJfT1JfTlVMTCh0ZXN0LCBucCk7CglLVU5JVF9FWFBFQ1RfRVFfTVNH
KHRlc3QsIG9wdGlvbnMsIE5VTEwsCgkJCSAgICAib3B0aW9uIGNsZWFyaW5nIHRlc3QgZmFp
bGVkXG4iKTsKCW9mX25vZGVfcHV0KG5wKTsKfQoKc3RhdGljIHZvaWQgb2ZfdGVzdF9maW5k
X25vZGVfYnlfbmFtZV9vcHRpb25fY2xlYXJpbmdfcm9vdChzdHJ1Y3Qga3VuaXQgKnRlc3Qp
CnsKCXN0cnVjdCBkZXZpY2Vfbm9kZSAqbnA7Cgljb25zdCBjaGFyICpvcHRpb25zOwoKCW9w
dGlvbnMgPSAidGVzdG9wdGlvbiI7CglucCA9IG9mX2ZpbmRfbm9kZV9vcHRzX2J5X3BhdGgo
Ii8iLCAmb3B0aW9ucyk7CglLVU5JVF9BU1NFUlRfTk9UX0VSUl9PUl9OVUxMKHRlc3QsIG5w
KTsKCUtVTklUX0VYUEVDVF9FUV9NU0codGVzdCwgb3B0aW9ucywgTlVMTCwKCQkJICAgICJv
cHRpb24gY2xlYXJpbmcgcm9vdCBub2RlIHRlc3QgZmFpbGVkXG4iKTsKCW9mX25vZGVfcHV0
KG5wKTsKfQoKc3RhdGljIGludCBvZl90ZXN0X2ZpbmRfbm9kZV9ieV9uYW1lX2luaXQoc3Ry
dWN0IGt1bml0ICp0ZXN0KQp7CgkvKiBhZGRpbmcgZGF0YSBmb3IgdW5pdHRlc3QgKi8KCUtV
TklUX0FTU0VSVF9FUSh0ZXN0LCAwLCB1bml0dGVzdF9kYXRhX2FkZCgpKTsKCglpZiAoIW9m
X2FsaWFzZXMpCgkJb2ZfYWxpYXNlcyA9IG9mX2ZpbmRfbm9kZV9ieV9wYXRoKCIvYWxpYXNl
cyIpOwoKCUtVTklUX0FTU0VSVF9OT1RfRVJSX09SX05VTEwodGVzdCwgb2ZfZmluZF9ub2Rl
X2J5X3BhdGgoCgkJCSIvdGVzdGNhc2UtZGF0YS9waGFuZGxlLXRlc3RzL2NvbnN1bWVyLWEi
KSk7CgoJcmV0dXJuIDA7Cn0KCnN0YXRpYyBzdHJ1Y3Qga3VuaXRfY2FzZSBvZl90ZXN0X2Zp
bmRfbm9kZV9ieV9uYW1lX2Nhc2VzW10gPSB7CglLVU5JVF9DQVNFKG9mX3Rlc3RfZmluZF9u
b2RlX2J5X25hbWVfYmFzaWMpLAoJS1VOSVRfQ0FTRShvZl90ZXN0X2ZpbmRfbm9kZV9ieV9u
YW1lX3RyYWlsaW5nX3NsYXNoKSwKCUtVTklUX0NBU0Uob2ZfdGVzdF9maW5kX25vZGVfYnlf
bmFtZV9tdWx0aXBsZV9jb21wb25lbnRzKSwKCUtVTklUX0NBU0Uob2ZfdGVzdF9maW5kX25v
ZGVfYnlfbmFtZV93aXRoX2FsaWFzKSwKCUtVTklUX0NBU0Uob2ZfdGVzdF9maW5kX25vZGVf
YnlfbmFtZV93aXRoX2FsaWFzX2FuZF9zbGFzaCksCglLVU5JVF9DQVNFKG9mX3Rlc3RfZmlu
ZF9ub2RlX2J5X25hbWVfbXVsdGlwbGVfY29tcG9uZW50c18yKSwKCUtVTklUX0NBU0Uob2Zf
dGVzdF9maW5kX25vZGVfYnlfbmFtZV9taXNzaW5nX3BhdGgpLAoJS1VOSVRfQ0FTRShvZl90
ZXN0X2ZpbmRfbm9kZV9ieV9uYW1lX21pc3NpbmdfYWxpYXMpLAoJS1VOSVRfQ0FTRShvZl90
ZXN0X2ZpbmRfbm9kZV9ieV9uYW1lX21pc3NpbmdfYWxpYXNfd2l0aF9yZWxhdGl2ZV9wYXRo
KSwKCUtVTklUX0NBU0Uob2ZfdGVzdF9maW5kX25vZGVfYnlfbmFtZV93aXRoX29wdGlvbiks
CglLVU5JVF9DQVNFKG9mX3Rlc3RfZmluZF9ub2RlX2J5X25hbWVfd2l0aF9vcHRpb25fYW5k
X3NsYXNoKSwKCUtVTklUX0NBU0Uob2ZfdGVzdF9maW5kX25vZGVfYnlfbmFtZV93aXRoX251
bGxfb3B0aW9uKSwKCUtVTklUX0NBU0Uob2ZfdGVzdF9maW5kX25vZGVfYnlfbmFtZV93aXRo
X29wdGlvbl9hbGlhcyksCglLVU5JVF9DQVNFKG9mX3Rlc3RfZmluZF9ub2RlX2J5X25hbWVf
d2l0aF9vcHRpb25fYWxpYXNfYW5kX3NsYXNoKSwKCUtVTklUX0NBU0Uob2ZfdGVzdF9maW5k
X25vZGVfYnlfbmFtZV93aXRoX251bGxfb3B0aW9uX2FsaWFzKSwKCUtVTklUX0NBU0Uob2Zf
dGVzdF9maW5kX25vZGVfYnlfbmFtZV9vcHRpb25fY2xlYXJpbmcpLAoJS1VOSVRfQ0FTRShv
Zl90ZXN0X2ZpbmRfbm9kZV9ieV9uYW1lX29wdGlvbl9jbGVhcmluZ19yb290KSwKCXt9LAp9
OwoKc3RhdGljIHN0cnVjdCBrdW5pdF9tb2R1bGUgb2ZfdGVzdF9maW5kX25vZGVfYnlfbmFt
ZV9tb2R1bGUgPSB7CgkubmFtZSA9ICJvZi10ZXN0LWZpbmQtbm9kZS1ieS1uYW1lIiwKCS5p
bml0ID0gb2ZfdGVzdF9maW5kX25vZGVfYnlfbmFtZV9pbml0LAoJLnRlc3RfY2FzZXMgPSBv
Zl90ZXN0X2ZpbmRfbm9kZV9ieV9uYW1lX2Nhc2VzLAp9Owptb2R1bGVfdGVzdChvZl90ZXN0
X2ZpbmRfbm9kZV9ieV9uYW1lX21vZHVsZSk7Cg==
--------------E517A228A219C58C15E0B9C4
Content-Type: text/plain; charset=UTF-8;
 name="frank_version"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="frank_version"

CS8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCi8qCiAqIFVuaXQgdGVzdHMg
Zm9yIGZ1bmN0aW9ucyBkZWZpbmVkIGluIGJhc2UuYy4KICovCiNpbmNsdWRlIDxsaW51eC9v
Zi5oPgoKI2luY2x1ZGUgPGt1bml0L3Rlc3QuaD4KCiNpbmNsdWRlICJ0ZXN0LWNvbW1vbi5o
IgoKc3RhdGljIHZvaWQgb2ZfdW5pdHRlc3RfZmluZF9ub2RlX2J5X25hbWUoc3RydWN0IGt1
bml0ICp0ZXN0KQp7CglzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wOwoJY29uc3QgY2hhciAqb3B0
aW9ucywgKm5hbWU7CgoKCS8vIGZpbmQgbm9kZSBieSBuYW1lIGJhc2ljCgoJbnAgPSBvZl9m
aW5kX25vZGVfYnlfcGF0aCgiL3Rlc3RjYXNlLWRhdGEiKTsKCW5hbWUgPSBrYXNwcmludGYo
R0ZQX0tFUk5FTCwgIiVwT0YiLCBucCk7CglLVU5JVF9BU1NFUlRfTk9UX0VSUl9PUl9OVUxM
KHRlc3QsIG5wKTsKCUtVTklUX0VYUEVDVF9TVFJFUV9NU0codGVzdCwgIi90ZXN0Y2FzZS1k
YXRhIiwgbmFtZSwKCQkJICAgICAgICJmaW5kIC90ZXN0Y2FzZS1kYXRhIGZhaWxlZFxuIik7
CglvZl9ub2RlX3B1dChucCk7CglrZnJlZShuYW1lKTsKCgoJLy8gZmluZCBub2RlIGJ5IG5h
bWUgdHJhaWxpbmcgc2xhc2gKCgkvKiBUZXN0IGlmIHRyYWlsaW5nICcvJyB3b3JrcyAqLwoJ
S1VOSVRfRVhQRUNUX0VRX01TRyh0ZXN0LCBvZl9maW5kX25vZGVfYnlfcGF0aCgiL3Rlc3Rj
YXNlLWRhdGEvIiksIE5VTEwsCgkJCSAgICAidHJhaWxpbmcgJy8nIG9uIC90ZXN0Y2FzZS1k
YXRhLyBzaG91bGQgZmFpbFxuIik7CgoKCS8vIGZpbmQgbm9kZSBieSBuYW1lIG11bHRpcGxl
IGNvbXBvbmVudHMKCglucCA9IG9mX2ZpbmRfbm9kZV9ieV9wYXRoKCIvdGVzdGNhc2UtZGF0
YS9waGFuZGxlLXRlc3RzL2NvbnN1bWVyLWEiKTsKCUtVTklUX0FTU0VSVF9OT1RfRVJSX09S
X05VTEwodGVzdCwgbnApOwoJbmFtZSA9IGthc3ByaW50ZihHRlBfS0VSTkVMLCAiJXBPRiIs
IG5wKTsKCUtVTklUX0VYUEVDVF9TVFJFUV9NU0coCgkJdGVzdCwgIi90ZXN0Y2FzZS1kYXRh
L3BoYW5kbGUtdGVzdHMvY29uc3VtZXItYSIsIG5hbWUsCgkJImZpbmQgL3Rlc3RjYXNlLWRh
dGEvcGhhbmRsZS10ZXN0cy9jb25zdW1lci1hIGZhaWxlZFxuIik7CglvZl9ub2RlX3B1dChu
cCk7CglrZnJlZShuYW1lKTsKCgoJLy8gZmluZCBub2RlIGJ5IG5hbWUgd2l0aCBhbGlhcwoK
CW5wID0gb2ZfZmluZF9ub2RlX2J5X3BhdGgoInRlc3RjYXNlLWFsaWFzIik7CglLVU5JVF9B
U1NFUlRfTk9UX0VSUl9PUl9OVUxMKHRlc3QsIG5wKTsKCW5hbWUgPSBrYXNwcmludGYoR0ZQ
X0tFUk5FTCwgIiVwT0YiLCBucCk7CglLVU5JVF9FWFBFQ1RfU1RSRVFfTVNHKHRlc3QsICIv
dGVzdGNhc2UtZGF0YSIsIG5hbWUsCgkJCSAgICAgICAiZmluZCB0ZXN0Y2FzZS1hbGlhcyBm
YWlsZWRcbiIpOwoJb2Zfbm9kZV9wdXQobnApOwoJa2ZyZWUobmFtZSk7CgoKCS8vIGZpbmQg
bm9kZSBieSBuYW1lIHdpdGggYWxpYXMgYW5kIHNsYXNoCgoJLyogVGVzdCBpZiB0cmFpbGlu
ZyAnLycgd29ya3Mgb24gYWxpYXNlcyAqLwoJS1VOSVRfRVhQRUNUX0VRX01TRyh0ZXN0LCBv
Zl9maW5kX25vZGVfYnlfcGF0aCgidGVzdGNhc2UtYWxpYXMvIiksIE5VTEwsCgkJCSAgICAi
dHJhaWxpbmcgJy8nIG9uIHRlc3RjYXNlLWFsaWFzLyBzaG91bGQgZmFpbFxuIik7CgoKCS8v
IGZpbmQgbm9kZSBieSBuYW1lIG11bHRpcGxlIGNvbXBvbmVudHMgMgoKCW5wID0gb2ZfZmlu
ZF9ub2RlX2J5X3BhdGgoInRlc3RjYXNlLWFsaWFzL3BoYW5kbGUtdGVzdHMvY29uc3VtZXIt
YSIpOwoJS1VOSVRfQVNTRVJUX05PVF9FUlJfT1JfTlVMTCh0ZXN0LCBucCk7CgluYW1lID0g
a2FzcHJpbnRmKEdGUF9LRVJORUwsICIlcE9GIiwgbnApOwoJS1VOSVRfRVhQRUNUX1NUUkVR
X01TRygKCQl0ZXN0LCAiL3Rlc3RjYXNlLWRhdGEvcGhhbmRsZS10ZXN0cy9jb25zdW1lci1h
IiwgbmFtZSwKCQkiZmluZCB0ZXN0Y2FzZS1hbGlhcy9waGFuZGxlLXRlc3RzL2NvbnN1bWVy
LWEgZmFpbGVkXG4iKTsKCW9mX25vZGVfcHV0KG5wKTsKCWtmcmVlKG5hbWUpOwoKCgkvLyBm
aW5kIG5vZGUgYnkgbmFtZSBtaXNzaW5nIHBhdGgKCglLVU5JVF9FWFBFQ1RfRVFfTVNHKAoJ
CXRlc3QsCgkJbnAgPSBvZl9maW5kX25vZGVfYnlfcGF0aCgiL3Rlc3RjYXNlLWRhdGEvbWlz
c2luZy1wYXRoIiksIE5VTEwsCgkJIm5vbi1leGlzdGVudCBwYXRoIHJldHVybmVkIG5vZGUg
JXBPRlxuIiwgbnApOwoJb2Zfbm9kZV9wdXQobnApOwoKCgkvLyBmaW5kIG5vZGUgYnkgbmFt
ZSBtaXNzaW5nIGFsaWFzCgoJS1VOSVRfRVhQRUNUX0VRX01TRygKCQl0ZXN0LCBucCA9IG9m
X2ZpbmRfbm9kZV9ieV9wYXRoKCJtaXNzaW5nLWFsaWFzIiksIE5VTEwsCgkJIm5vbi1leGlz
dGVudCBhbGlhcyByZXR1cm5lZCBub2RlICVwT0ZcbiIsIG5wKTsKCW9mX25vZGVfcHV0KG5w
KTsKCgoJLy8gIGZpbmQgbm9kZSBieSBuYW1lIG1pc3NpbmcgYWxpYXMgd2l0aCByZWxhdGl2
ZSBwYXRoCgoJS1VOSVRfRVhQRUNUX0VRX01TRygKCQl0ZXN0LAoJCW5wID0gb2ZfZmluZF9u
b2RlX2J5X3BhdGgoInRlc3RjYXNlLWFsaWFzL21pc3NpbmctcGF0aCIpLCBOVUxMLAoJCSJu
b24tZXhpc3RlbnQgYWxpYXMgd2l0aCByZWxhdGl2ZSBwYXRoIHJldHVybmVkIG5vZGUgJXBP
RlxuIiwKCQlucCk7CglvZl9ub2RlX3B1dChucCk7CgoKCS8vIGZpbmQgbm9kZSBieSBuYW1l
IHdpdGggb3B0aW9uCgoJbnAgPSBvZl9maW5kX25vZGVfb3B0c19ieV9wYXRoKCIvdGVzdGNh
c2UtZGF0YTp0ZXN0b3B0aW9uIiwgJm9wdGlvbnMpOwoJS1VOSVRfQVNTRVJUX05PVF9FUlJf
T1JfTlVMTCh0ZXN0LCBucCk7CglLVU5JVF9FWFBFQ1RfU1RSRVFfTVNHKHRlc3QsICJ0ZXN0
b3B0aW9uIiwgb3B0aW9ucywKCQkJICAgICAgICJvcHRpb24gcGF0aCB0ZXN0IGZhaWxlZFxu
Iik7CglvZl9ub2RlX3B1dChucCk7CgoKCS8vIGZpbmQgbm9kZSBieSBuYW1lIHdpdGggb3B0
aW9uIGFuZCBzbGFzaAoKCW5wID0gb2ZfZmluZF9ub2RlX29wdHNfYnlfcGF0aCgiL3Rlc3Rj
YXNlLWRhdGE6dGVzdC9vcHRpb24iLCAmb3B0aW9ucyk7CglLVU5JVF9BU1NFUlRfTk9UX0VS
Ul9PUl9OVUxMKHRlc3QsIG5wKTsKCUtVTklUX0VYUEVDVF9TVFJFUV9NU0codGVzdCwgInRl
c3Qvb3B0aW9uIiwgb3B0aW9ucywKCQkJICAgICAgICJvcHRpb24gcGF0aCB0ZXN0LCBzdWJj
YXNlICMxIGZhaWxlZFxuIik7CglvZl9ub2RlX3B1dChucCk7CgoJbnAgPSBvZl9maW5kX25v
ZGVfb3B0c19ieV9wYXRoKCIvdGVzdGNhc2UtZGF0YS90ZXN0Y2FzZS1kZXZpY2UxOnRlc3Qv
b3B0aW9uIiwgJm9wdGlvbnMpOwoJS1VOSVRfQVNTRVJUX05PVF9FUlJfT1JfTlVMTCh0ZXN0
LCBucCk7CglLVU5JVF9FWFBFQ1RfU1RSRVFfTVNHKHRlc3QsICJ0ZXN0L29wdGlvbiIsIG9w
dGlvbnMsCgkJCSAgICAgICAib3B0aW9uIHBhdGggdGVzdCwgc3ViY2FzZSAjMiBmYWlsZWRc
biIpOwoJb2Zfbm9kZV9wdXQobnApOwoKCgkvLyBmaW5kIG5vZGUgYnkgbmFtZSB3aXRoIG51
bGwgb3B0aW9uCgoJbnAgPSBvZl9maW5kX25vZGVfb3B0c19ieV9wYXRoKCIvdGVzdGNhc2Ut
ZGF0YTp0ZXN0b3B0aW9uIiwgTlVMTCk7CglLVU5JVF9FWFBFQ1RfTk9UX0VSUl9PUl9OVUxM
X01TRyh0ZXN0LCBucCwKCQkJCQkgIk5VTEwgb3B0aW9uIHBhdGggdGVzdCBmYWlsZWRcbiIp
OwoJb2Zfbm9kZV9wdXQobnApOwoKCgkvLyBmaW5kIG5vZGUgYnkgbmFtZSB3aXRoIG9wdGlv
biBhbGlhcwoKCW5wID0gb2ZfZmluZF9ub2RlX29wdHNfYnlfcGF0aCgidGVzdGNhc2UtYWxp
YXM6dGVzdGFsaWFzb3B0aW9uIiwKCQkJCSAgICAgICAmb3B0aW9ucyk7CglLVU5JVF9BU1NF
UlRfTk9UX0VSUl9PUl9OVUxMKHRlc3QsIG5wKTsKCUtVTklUX0VYUEVDVF9TVFJFUV9NU0co
dGVzdCwgInRlc3RhbGlhc29wdGlvbiIsIG9wdGlvbnMsCgkJCSAgICAgICAib3B0aW9uIGFs
aWFzIHBhdGggdGVzdCBmYWlsZWRcbiIpOwoJb2Zfbm9kZV9wdXQobnApOwoKCgkvLyBmaW5k
IG5vZGUgYnkgbmFtZSB3aXRoIG9wdGlvbiBhbGlhcyBhbmQgc2xhc2gKCglucCA9IG9mX2Zp
bmRfbm9kZV9vcHRzX2J5X3BhdGgoInRlc3RjYXNlLWFsaWFzOnRlc3QvYWxpYXMvb3B0aW9u
IiwKCQkJCSAgICAgICAmb3B0aW9ucyk7CglLVU5JVF9BU1NFUlRfTk9UX0VSUl9PUl9OVUxM
KHRlc3QsIG5wKTsKCUtVTklUX0VYUEVDVF9TVFJFUV9NU0codGVzdCwgInRlc3QvYWxpYXMv
b3B0aW9uIiwgb3B0aW9ucywKCQkJICAgICAgICJvcHRpb24gYWxpYXMgcGF0aCB0ZXN0LCBz
dWJjYXNlICMxIGZhaWxlZFxuIik7CglvZl9ub2RlX3B1dChucCk7CgoKCS8vIGZpbmQgbm9k
ZSBieSBuYW1lIHdpdGggbnVsbCBvcHRpb24gYWxpYXMKCglucCA9IG9mX2ZpbmRfbm9kZV9v
cHRzX2J5X3BhdGgoInRlc3RjYXNlLWFsaWFzOnRlc3RhbGlhc29wdGlvbiIsIE5VTEwpOwoJ
S1VOSVRfRVhQRUNUX05PVF9FUlJfT1JfTlVMTF9NU0coCgkJCXRlc3QsIG5wLCAiTlVMTCBv
cHRpb24gYWxpYXMgcGF0aCB0ZXN0IGZhaWxlZFxuIik7CglvZl9ub2RlX3B1dChucCk7CgoK
CS8vIGZpbmQgbm9kZSBieSBuYW1lIG9wdGlvbiBjbGVhcmluZwoKCW9wdGlvbnMgPSAidGVz
dG9wdGlvbiI7CglucCA9IG9mX2ZpbmRfbm9kZV9vcHRzX2J5X3BhdGgoInRlc3RjYXNlLWFs
aWFzIiwgJm9wdGlvbnMpOwoJS1VOSVRfQVNTRVJUX05PVF9FUlJfT1JfTlVMTCh0ZXN0LCBu
cCk7CglLVU5JVF9FWFBFQ1RfRVFfTVNHKHRlc3QsIG9wdGlvbnMsIE5VTEwsCgkJCSAgICAi
b3B0aW9uIGNsZWFyaW5nIHRlc3QgZmFpbGVkXG4iKTsKCW9mX25vZGVfcHV0KG5wKTsKCgoJ
Ly8gZmluZCBub2RlIGJ5IG5hbWUgb3B0aW9uIGNsZWFyaW5nIHJvb3QKCglvcHRpb25zID0g
InRlc3RvcHRpb24iOwoJbnAgPSBvZl9maW5kX25vZGVfb3B0c19ieV9wYXRoKCIvIiwgJm9w
dGlvbnMpOwoJS1VOSVRfQVNTRVJUX05PVF9FUlJfT1JfTlVMTCh0ZXN0LCBucCk7CglLVU5J
VF9FWFBFQ1RfRVFfTVNHKHRlc3QsIG9wdGlvbnMsIE5VTEwsCgkJCSAgICAib3B0aW9uIGNs
ZWFyaW5nIHJvb3Qgbm9kZSB0ZXN0IGZhaWxlZFxuIik7CglvZl9ub2RlX3B1dChucCk7Cn0K
CnN0YXRpYyBpbnQgb2ZfdGVzdF9pbml0KHN0cnVjdCBrdW5pdCAqdGVzdCkKewoJLyogYWRk
aW5nIGRhdGEgZm9yIHVuaXR0ZXN0ICovCglLVU5JVF9BU1NFUlRfRVEodGVzdCwgMCwgdW5p
dHRlc3RfZGF0YV9hZGQoKSk7CgoJaWYgKCFvZl9hbGlhc2VzKQoJCW9mX2FsaWFzZXMgPSBv
Zl9maW5kX25vZGVfYnlfcGF0aCgiL2FsaWFzZXMiKTsKCglLVU5JVF9BU1NFUlRfTk9UX0VS
Ul9PUl9OVUxMKHRlc3QsIG9mX2ZpbmRfbm9kZV9ieV9wYXRoKAoJCQkiL3Rlc3RjYXNlLWRh
dGEvcGhhbmRsZS10ZXN0cy9jb25zdW1lci1hIikpOwoKCXJldHVybiAwOwp9CgpzdGF0aWMg
c3RydWN0IGt1bml0X2Nhc2Ugb2ZfdGVzdF9jYXNlc1tdID0gewoJS1VOSVRfQ0FTRShvZl91
bml0dGVzdF9maW5kX25vZGVfYnlfbmFtZSksCgl7fSwKfTsKCnN0YXRpYyBzdHJ1Y3Qga3Vu
aXRfbW9kdWxlIG9mX3Rlc3RfbW9kdWxlID0gewoJLm5hbWUgPSAib2YtYmFzZS10ZXN0IiwK
CS5pbml0ID0gb2ZfdGVzdF9pbml0LAoJLnRlc3RfY2FzZXMgPSBvZl90ZXN0X2Nhc2VzLAp9
Owptb2R1bGVfdGVzdChvZl90ZXN0X21vZHVsZSk7Cg==
--------------E517A228A219C58C15E0B9C4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--------------E517A228A219C58C15E0B9C4--
