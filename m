Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from www.kot-begemot.co.uk (ivanoab6.miniserver.com [5.153.251.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43B2D21BADAB2
 for <linux-nvdimm@lists.01.org>; Wed,  5 Dec 2018 06:49:35 -0800 (PST)
Subject: Re: [RFC v3 01/19] kunit: test: add KUnit test runner core
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-2-brendanhiggins@google.com>
 <20181130031438.GQ4922@garbanzo.do-not-panic.com>
 <e2ed9df2-c06b-f0d3-d50a-d03166f586df@cambridgegreys.com>
 <CAK8P3a2HrOTYv7qCJH1XGVxZ2HDqwkHqRWaAJ93nWc5p8LnCig@mail.gmail.com>
From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Message-ID: <5bd5581f-f192-4ed0-6f5f-9e1bf9f443e2@cambridgegreys.com>
Date: Wed, 5 Dec 2018 14:49:10 +0000
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2HrOTYv7qCJH1XGVxZ2HDqwkHqRWaAJ93nWc5p8LnCig@mail.gmail.com>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lawrence Brakmo <brakmo@fb.com>, Brendan Higgins <brendanhiggins@google.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Michael Ellerman <mpe@ellerman.id.au>, linux-kselftest@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>, Rob Herring <robh@kernel.org>, linux-nvdimm@lists.01.org, Richard Weinberger <richard@nod.at>, knut.omang@oracle.com, Kieran Bingham <kieran.bingham@ideasonboard.com>, Joel Stanley <joel@jms.id.au>, "Bird, Timothy" <Tim.Bird@sony.com>, Shuah Khan <shuah@kernel.org>, Jeff Dike <jdike@addtoit.com>, linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, levinsasha928@gmail.com, kunit-dev@googlegroups.com, gregkh <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Kees Cook <keescook@google.com>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On 05/12/2018 14:45, Arnd Bergmann wrote:
> On Wed, Dec 5, 2018 at 2:42 PM Anton Ivanov
> <anton.ivanov@cambridgegreys.com> wrote:
>> On 30/11/2018 03:14, Luis Chamberlain wrote:
>>> On Wed, Nov 28, 2018 at 11:36:18AM -0800, Brendan Higgins wrote:
>>> Then for the UML stuff, I think if we *really* accept that UML will
>>> always be a viable option we should probably consider now throwing these
>>> things under drivers/platform/uml/. This follows the pattern of arch
>>> specific drivers. Whether or not we end up with a complete userspace
>> UML platform drivers predate that and are under arch/um/drivers/
>>
>> We should either keep to current convention or consider relocating the
>> existing ones - having things spread in different places around the tree
>> is not good in the long run (UML already has a few of those under the
>> x86 tree, let's not increase the number).
> I don't mind the current location much, but if we move drivers, we should
> move the into the appropriate subsystems based on what they do, rather
> than having a new place with a mix of things.
>
> E.g. the tty drivers should all be in drivers/tty/ and the network drivers in
> drivers/net. To paraphrase what you said above: having tty drivers spread in
> different places around the tree is not good in the long run. We have long
> ago moved from organizing drivers by bus interface to organizing drivers
> by class, uml and drivers/platform are just exceptions to this rule.

There are some issues with that because uml drivers have bits of what is 
effectively host side of the hypervisor as a part of them. IMHO, having 
that in driver/X is not very appropriate. So at least the *_user.c and 
*_user.h bits have to go (or stay) somewhere else

Brgds,

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
