From: shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v14 01/18] kunit: test: add KUnit test runner core
Date: Fri, 23 Aug 2019 11:05:35 -0600
Message-ID: <4513d9f3-a69b-a9a4-768b-86c2962b62e0@kernel.org>
References: <20190820232046.50175-1-brendanhiggins@google.com>
 <20190820232046.50175-2-brendanhiggins@google.com>
 <7f2c8908-75f6-b793-7113-ad57c51777ce@kernel.org>
 <CAFd5g44mRK9t4f58i_YMEt=e9RTxwrrhFY_V2LW_E7bUwR3cdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAFd5g44mRK9t4f58i_YMEt=e9RTxwrrhFY_V2LW_E7bUwR3cdg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kbuild <linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On 8/23/19 10:48 AM, Brendan Higgins wrote:
> On Fri, Aug 23, 2019 at 8:33 AM shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>
>> Hi Brendan,
>>
>> On 8/20/19 5:20 PM, Brendan Higgins wrote:
>>> Add core facilities for defining unit tests; this provides a common way
>>> to define test cases, functions that execute code which is under test
>>> and determine whether the code under test behaves as expected; this also
>>> provides a way to group together related test cases in test suites (here
>>> we call them test_modules).
>>>
>>> Just define test cases and how to execute them for now; setting
>>> expectations on code will be defined later.
>>>
>>> Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> Reviewed-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>>> Reviewed-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
>>> Reviewed-by: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> Reviewed-by: Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> ---
>>>    include/kunit/test.h | 179 ++++++++++++++++++++++++++++++++++++++++
>>>    kunit/Kconfig        |  17 ++++
>>>    kunit/Makefile       |   1 +
>>>    kunit/test.c         | 191 +++++++++++++++++++++++++++++++++++++++++++
>>>    4 files changed, 388 insertions(+)
>>>    create mode 100644 include/kunit/test.h
>>>    create mode 100644 kunit/Kconfig
>>>    create mode 100644 kunit/Makefile
>>>    create mode 100644 kunit/test.c
>>>
>>> diff --git a/include/kunit/test.h b/include/kunit/test.h
>>> new file mode 100644
>>> index 0000000000000..e0b34acb9ee4e
>>> --- /dev/null
>>> +++ b/include/kunit/test.h
>>> @@ -0,0 +1,179 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +/*
>>> + * Base unit test (KUnit) API.
>>> + *
>>> + * Copyright (C) 2019, Google LLC.
>>> + * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> + */
>>> +
>>> +#ifndef _KUNIT_TEST_H
>>> +#define _KUNIT_TEST_H
>>> +
>>> +#include <linux/types.h>
>>> +
>>> +struct kunit;
>>> +
>>> +/**
>>> + * struct kunit_case - represents an individual test case.
>>> + * @run_case: the function representing the actual test case.
>>> + * @name: the name of the test case.
>>> + *
>>> + * A test case is a function with the signature, ``void (*)(struct kunit *)``
>>> + * that makes expectations (see KUNIT_EXPECT_TRUE()) about code under test. Each
>>> + * test case is associated with a &struct kunit_suite and will be run after the
>>> + * suite's init function and followed by the suite's exit function.
>>> + *
>>> + * A test case should be static and should only be created with the KUNIT_CASE()
>>> + * macro; additionally, every array of test cases should be terminated with an
>>> + * empty test case.
>>> + *
>>> + * Example:
>>
>> Can you fix these line continuations. It makes it very hard to read.
>> Sorry for this late comment. These comments lines are longer than 80
>> and wrap.
> 
> None of the lines in this commit are over 80 characters in column
> width. Some are exactly 80 characters (like above).
> 
> My guess is that you are seeing the diff added text (+ ), which when
> you add that to a line which is exactly 80 char in length ends up
> being over 80 char in email. If you apply the patch you will see that
> they are only 80 chars.
> 
>>
>> There are several comment lines in the file that are way too long.
> 
> Note that checkpatch also does not complain about any over 80 char
> lines in this file.
> 
> Sorry if I am misunderstanding what you are trying to tell me. Please
> confirm either way.
> 

WARNING: Avoid unnecessary line continuations
#258: FILE: include/kunit/test.h:137:
+		 */							       \

total: 0 errors, 2 warnings, 388 lines checked

Go ahead fix these. It appears there are few lines that either longer
than 80. In general, I keep them around 75, so it is easier read.

thanks,
-- Shuah
