Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: Re: [RFC v2 01/14] kunit: test: add KUnit test runner core
References: <20181023235750.103146-1-brendanhiggins@google.com>
 <20181023235750.103146-2-brendanhiggins@google.com>
 <017b111f-d960-c1ef-46ae-eb0eb639fe5b@kernel.org>
 <CAFd5g45KNNGPVh4EBm8vKGdVhqajZZA0TU=CFbceJziYufb0Ug@mail.gmail.com>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <0149d343-937c-1a99-10ff-d2bcb546e49b@kernel.org>
Date: Wed, 7 Nov 2018 13:02:29 -0700
MIME-Version: 1.0
In-Reply-To: <CAFd5g45KNNGPVh4EBm8vKGdVhqajZZA0TU=CFbceJziYufb0Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, mcgrof@kernel.org, Joel Stanley <joel@jms.id.au>, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org, Rob Herring <robh@kernel.org>, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, kieran.bingham@ideasonboard.com, Shuah Khan <shuah@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 11/06/2018 06:28 PM, Brendan Higgins wrote:
> On Fri, Nov 2, 2018 at 11:44 AM Shuah Khan <shuah@kernel.org> wrote:
>>
>> On 10/23/2018 05:57 PM, Brendan Higgins wrote:
> <snip>
>>> + * Example:
>>> + *
>>> + * .. code-block:: c
>>> + *
>>> + *   void add_test_basic(struct test *test)
>>> + *   {
>>> + *           TEST_EXPECT_EQ(test, 1, add(1, 0));
>>> + *           TEST_EXPECT_EQ(test, 2, add(1, 1));
>>> + *           TEST_EXPECT_EQ(test, 0, add(-1, 1));
>>> + *           TEST_EXPECT_EQ(test, INT_MAX, add(0, INT_MAX));
>>> + *           TEST_EXPECT_EQ(test, -1, add(INT_MAX, INT_MIN));
>>> + *   }
>>> + *
>>> + *   static struct test_case example_test_cases[] = {
>>> + *           TEST_CASE(add_test_basic),
>>> + *           {},
>>> + *   };
>>> + *
>>> + */
>>> +struct test_case {
>>> +     void (*run_case)(struct test *test);
>>> +     const char name[256];
>>> +
>>> +     /* private: internal use only. */
>>> +     bool success;
>>> +};
>>> +
>>
>> Introducing a prefix kunit_* might be a good idea for the API.
>> This comment applies to the rest of patches as well.
> 
> What about kunit_* instead of test_* and kmock_* instead of mock_*?
> Does that seem reasonable?
> 

kunit_* would work well.

thanks,
-- Shuah
