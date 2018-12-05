Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from www.kot-begemot.co.uk (ivanoab6.miniserver.com [5.153.251.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E9C721193786
 for <linux-nvdimm@lists.01.org>; Wed,  5 Dec 2018 05:16:20 -0800 (PST)
Subject: Re: [RFC v3 01/19] kunit: test: add KUnit test runner core
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-2-brendanhiggins@google.com>
 <20181130031438.GQ4922@garbanzo.do-not-panic.com>
From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Message-ID: <e2ed9df2-c06b-f0d3-d50a-d03166f586df@cambridgegreys.com>
Date: Wed, 5 Dec 2018 13:15:28 +0000
MIME-Version: 1.0
In-Reply-To: <20181130031438.GQ4922@garbanzo.do-not-panic.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Luis Chamberlain <mcgrof@kernel.org>, Brendan Higgins <brendanhiggins@google.com>
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, mpe@ellerman.id.au, linux-kselftest@vger.kernel.org, frowand.list@gmail.com, robh@kernel.org, linux-nvdimm@lists.01.org, richard@nod.at, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, joel@jms.id.au, Tim.Bird@sony.com, shuah@kernel.org, jdike@addtoit.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, levinsasha928@gmail.com, kunit-dev@googlegroups.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, daniel@ffwll.ch, keescook@google.com, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On 30/11/2018 03:14, Luis Chamberlain wrote:
> On Wed, Nov 28, 2018 at 11:36:18AM -0800, Brendan Higgins wrote:
>> +#define module_test(module) \
>> +		static int module_kunit_init##module(void) \
>> +		{ \
>> +			return kunit_run_tests(&module); \
>> +		} \
>> +		late_initcall(module_kunit_init##module)
> Here in lies an assumption that suffices. I'm inclined to believe we
> need new initcall level here so to ensure we *do* run after all the
> respective kernels iniut calls. Otherwise we're left at the whims of
> link order for kunit. For instance if a kunit test relies on frameworks
> which are also late_initcall() we'd have complete incompatibility with
> anything linked *after* kunit.
>
>> diff --git a/kunit/Kconfig b/kunit/Kconfig
>> new file mode 100644
>> index 0000000000000..49b44c4f6630a
>> --- /dev/null
>> +++ b/kunit/Kconfig
>> @@ -0,0 +1,17 @@
>> +#
>> +# KUnit base configuration
>> +#
>> +
>> +menu "KUnit support"
>> +
>> +config KUNIT
>> +	bool "Enable support for unit tests (KUnit)"
>> +	depends on UML
> Consider using:
>
> if UML
>     ...
> endif
>
> That allows the depends to be done once.
>
>> +	help
>> +	  Enables support for kernel unit tests (KUnit), a lightweight unit
>> +	  testing and mocking framework for the Linux kernel. These tests are
>> +	  able to be run locally on a developer's workstation without a VM or
>> +	  special hardware.
>
> Some mention of UML may be good here?
>
>> For more information, please see
>> +	  Documentation/kunit/
>> +
>> +endmenu
> I'm a bit conflicted here. This currently depends on UML but yet you
> noted on RFC v2 that your intention is to liberate kunit from UML and
> ideally allow unit tests to depend only on userspace. I've addressed
> tests using both selftests kernels drivers and also re-written kernel
> APIs to userspace to test there. I think we may need to live with both.
>
> Then for the UML stuff, I think if we *really* accept that UML will
> always be a viable option we should probably consider now throwing these
> things under drivers/platform/uml/. This follows the pattern of arch
> specific drivers. Whether or not we end up with a complete userspace

UML platform drivers predate that and are under arch/um/drivers/

We should either keep to current convention or consider relocating the 
existing ones - having things spread in different places around the tree 
is not good in the long run (UML already has a few of those under the 
x86 tree, let's not increase the number).

> component independent of UML may implicate having a shared component
> somewhere else.
>
> Likewise, I realize the goal is to *avoid* using a virtual machine for
> these tests, but would it in any way make sense to share kunit to be
> supported for other architectures to allow easier-to-write tests as
> well?
>
>    Luis
>
> _______________________________________________
> linux-um mailing list
> linux-um@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-um
>

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
