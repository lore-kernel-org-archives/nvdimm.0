Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com
 [213.167.242.64])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BB0AF21197073
 for <linux-nvdimm@lists.01.org>; Fri,  7 Dec 2018 03:30:38 -0800 (PST)
Subject: Re: [RFC v3 11/19] kunit: add Python libraries for handing KUnit
 config and kernel
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-12-brendanhiggins@google.com>
 <841cf4ae-501b-05ae-5863-a51010709b67@ideasonboard.com>
 <CAFd5g47x-UNja72k-CWPmWz9+LTn8pF8Wj5Poq+2FJ93E=vymA@mail.gmail.com>
 <20181204204701.GT28501@garbanzo.do-not-panic.com>
 <f8722f4a-44c8-24c2-c433-5178f9f40b82@ideasonboard.com>
 <20181206153718.GD24603@bombadil.infradead.org>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <f2a3d7fc-21f2-7bd0-94e2-4122f2073da5@ideasonboard.com>
Date: Fri, 7 Dec 2018 11:30:30 +0000
MIME-Version: 1.0
In-Reply-To: <20181206153718.GD24603@bombadil.infradead.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: kieran.bingham@ideasonboard.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: brakmo@fb.com, Knut Omang <knut.omang@oracle.com>, jeffm@suse.com, Brendan Higgins <brendanhiggins@google.com>, dri-devel@lists.freedesktop.org, Sasha Levin <Alexander.Levin@microsoft.com>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, Frank Rowand <frowand.list@gmail.com>, linux-nvdimm@lists.01.org, mpe@ellerman.id.au, Eric Sandeen <sandeen@sandeen.net>, Felix Guo <felixguoxiuping@gmail.com>, Joel Stanley <joel@jms.id.au>, Tim.Bird@sony.com, Petr Mladek <pmladek@suse.com>, jdike@addtoit.com, linux-um@lists.infradead.org, rostedt@goodmis.org, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, richard@nod.at, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>, Eryu Guan <guaneryu@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Kees Cook <keescook@google.com>, joe@perches.com, linux-fsdevel@vger.kernel.org, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

Hi Matthew,

On 06/12/2018 15:37, Matthew Wilcox wrote:
> On Thu, Dec 06, 2018 at 12:32:47PM +0000, Kieran Bingham wrote:
>> On 04/12/2018 20:47, Luis Chamberlain wrote:
>>> On Mon, Dec 03, 2018 at 03:48:15PM -0800, Brendan Higgins wrote:
>>>> On Thu, Nov 29, 2018 at 5:54 AM Kieran Bingham
>>>> <kieran.bingham@ideasonboard.com> wrote:
>>>>>
>>>>> Hi Brendan,
>>>>>
>>>>> Thanks again for this series!
>>>>>
>>>>> On 28/11/2018 19:36, Brendan Higgins wrote:
>>>>>> The ultimate goal is to create minimal isolated test binaries; in the
>>>>>> meantime we are using UML to provide the infrastructure to run tests, so
>>>>>> define an abstract way to configure and run tests that allow us to
>>>>>> change the context in which tests are built without affecting the user.
>>>>>> This also makes pretty and dynamic error reporting, and a lot of other
>>>>>> nice features easier.
>>>>>
>>>>>
>>>>> I wonder if we could somehow generate a shared library object
>>>>> 'libkernel' or 'libumlinux' from a UM configured set of headers and
>>>>> objects so that we could create binary targets directly ?
>>>>
>>>> That's an interesting idea. I think it would be difficult to figure
>>>> out exactly where to draw the line of what goes in there and what
>>>> needs to be built specific to a test a priori. Of course, that leads
>>>> into the biggest problem in general, needed to know what I need to
>>>> build to test the thing that I want to test.
>>>>
>>>> Nevertheless, I could definitely imagine that being useful in a lot of cases.
>>>
>>> Whether or not we can abstract away the kernel into such a mechanism
>>> with uml libraries is a good question worth exploring.
>>>
>>> Developers working upstream do modify their kernels a lot, so we'd have
>>> to update such libraries quite a bit, but I think that's fine too. The
>>> *real* value I think from the above suggestion would be enterprise /
>>> mobile distros or stable kernel maintainers which have a static kernel
>>> they need to support for a relatively *long time*, consider a 10 year
>>> time frame. Running unit tests without qemu with uml and libraries for
>>> respective kernels seems real worthy.
>>
>> I think any such library might be something generated by the kernel
>> build system, so if someone makes substantial changes to a core
>> component provided by the library - it can be up to them to build a
>> corresponding userspace library as well.
>>
>> We could also consider to only provide *static* libraries rather than
>> dynamic. So any one building some userspace tool / test with this would
>> be required to compile against (the version of) the kernel they expect
>> perhaps... - much like we expect modules to be compiled currently.
>>
>> And then the userspace binary would be sufficiently able to live it's
>> life on it's own :)
>>
>>> The overhead for testing a unit test for said targets, *ideally*, would
>>> just be to to reboot into the system with such libraries available, a
>>> unit test would just look for the respective uname -r library and mimic
>>> that kernel, much the same way enterprise distributions today rely on
>>> having debugging symbols available to run against crash / gdb. Having
>>> debug modules / kernel for crash requires such effort already, so this
>>> would just be an extra layer of other prospect tests.
>>
>> Oh - although, yes - there are some good concepts there - but I'm a bit
>> weary of how easy it would be to 'run' the said test against multiple
>> kernel version libraries... there would be a lot of possible ABI
>> conflicts perhaps.
>>
>> My main initial idea for a libumlinux is to provide infrastructure such
>> as our linked-lists and other kernel formatting so that we can take
>> kernel code directly to userspace for test and debug (assuming that
>> there are no hardware dependencies or things that we can't mock out)
>>
>> I think all of this could complement kunit of course - this isn't
>> suggesting an alternative implementation :-)
> 
> I suspect the reason Luis cc'd me on this is that we already have some
> artisinally-crafted userspace kernel-mocking interfaces under tools/.

Aha - excellent - I had hoped to grab you at Plumbers to talk about
this, after hearing you mention something at your Xarray talk - but
didn't seem to find a suitable time.

> The tools/testing/radix-tree directory is the source of some of this,
> but I've been moving pieces out into tools/ more generally where it
> makes sense to.

Sounds like we already have a starting point then.


> We have liburcu already, which is good.  The main sticking points are:
> 
>  - No emulation of kernel thread interfaces

Scheduling finesse aside, This shouldn't be too hard to emulate/wrap
with pthreads?


>  - The kernel does not provide the ability to aggressively fail memory
>    allocations (which is useful when trying to exercise the memory failure
>    paths).

Fault injection throughout would certainly be a valuable addition to any
unit-testing.

Wrapping tests into a single userspace binary could facilitate further
memory leak checking or other valgrind facilities too.



>  - printk has started adding a lot of %pX enhancements which printf
>    obviously doesn't know about.

Wrapping through User-mode linux essentially provides this already
though. In fact I guess that goes for the thread interfaces topic above too.


>  - No global pseudo-random number generator in the kernel.  Probably
>    we should steal the i915 one.
> 
> I know Dan Williams has also done a lot of working mocking kernel
> interfaces for libnvdimm.


Thanks for the references - more to investigate.

-- 
Regards
--
Kieran
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
