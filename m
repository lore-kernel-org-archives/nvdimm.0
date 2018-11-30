Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: Re: [RFC v3 17/19] of: unittest: migrate tests to run on KUnit
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-18-brendanhiggins@google.com>
 <CAL_Jsq+09Kx7yMBC_Jw45QGmk6U_fp4N6HOZDwYrM4tWw+_dOA@mail.gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <18814973-8f0a-4647-a097-fcc3dc0b3cd3@infradead.org>
Date: Thu, 29 Nov 2018 16:39:57 -0800
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+09Kx7yMBC_Jw45QGmk6U_fp4N6HOZDwYrM4tWw+_dOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>, Brendan Higgins <brendanhiggins@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, shuah@kernel.org, Joel Stanley <joel@jms.id.au>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, brakmo@fb.com, Steven Rostedt <rostedt@goodmis.org>, "Bird, Timothy" <Tim.Bird@sony.com>, Kevin Hilman <khilman@baylibre.com>, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>, dri-devel <dri-devel@lists.freedesktop.org>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Frank Rowand <frowand.list@gmail.com>, knut.omang@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

On 11/28/18 12:56 PM, Rob Herring wrote:
>> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
>> index ad3fcad4d75b8..f309399deac20 100644
>> --- a/drivers/of/Kconfig
>> +++ b/drivers/of/Kconfig
>> @@ -15,6 +15,7 @@ if OF
>>  config OF_UNITTEST
>>         bool "Device Tree runtime unit tests"
>>         depends on !SPARC
>> +       depends on KUNIT
> Unless KUNIT has depends, better to be a select here.

That's just style or taste.  I would prefer to use depends
instead of select, but that's also just my preference.

-- 
~Randy
