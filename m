From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Fri, 10 May 2019 10:17:56 -0600
Message-ID: <3faa022b-0b70-0375-aa6d-12ea83a2671f@deltatee.com>
References: <a09a7e0e-9894-8c1a-34eb-fc482b1759d0@gmail.com>
 <20190509015856.GB7031@mit.edu>
 <580e092f-fa4e-eedc-9e9a-a57dd085f0a6@gmail.com>
 <20190509032017.GA29703@mit.edu>
 <7fd35df81c06f6eb319223a22e7b93f29926edb9.camel@oracle.com>
 <20190509133551.GD29703@mit.edu>
 <ECADFF3FD767C149AD96A924E7EA6EAF9770D591@USCULXMSG01.am.sony.com>
 <875c546d-9713-bb59-47e4-77a1d2c69a6d@gmail.com>
 <20190509214233.GA20877@mit.edu>
 <b09ba170-229b-fde4-3e9a-e50d6ab4c1b5@deltatee.com>
 <20190509233043.GC20877@mit.edu>
 <8914afef-1e66-e6e3-f891-5855768d3018@deltatee.com>
 <6d6e91ec-33d3-830b-4895-4d7a20ba7d45@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6d6e91ec-33d3-830b-4895-4d7a20ba7d45@gmail.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Frank Rowand <frowand.list@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Tim.Bird@sony.com, knut.omang@oracle.com, gregkh@linuxfoundation.org, brendanhiggins@google.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, amir73il@gmail.com, dan.carpenter@oracle.com, dan.j.williams@intel.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.
List-Id: linux-nvdimm@lists.01.org



On 2019-05-09 11:18 p.m., Frank Rowand wrote:

> YES, kselftest has in-kernel tests.  (Excuse the shouting...)

Cool. From my cursory look, in my opinion, these would be greatly
improved by converting them to the framework Brendan is proposing for Kunit.

>> If they do exists, it seems like it would make sense to
>> convert those to kunit and have Kunit tests run-able in a VM or
>> baremetal instance.
> 
> They already run in a VM.
> 
> They already run on bare metal.
> 
> They already run in UML.

Simply being able to run in UML is not the only thing here. Kunit
provides the infrastructure to quickly build, run and report results for
all the tests from userspace without needing to worry about the details
of building and running a UML kernel, then parsing dmesg to figure out
what tests were run or not.

> This is not to say that KUnit does not make sense.  But I'm still trying
> to get a better description of the KUnit features (and there are
> some).

So read the patches, or the documentation[1] or the LWN article[2]. It's
pretty well described in a lot of places -- that's one of the big
advantages of it. In contrast, few people seems to have any concept of
what kselftests are or where they are or how to run them (I was
surprised to find the in-kernel tests in the lib tree).

Logan

[1] https://google.github.io/kunit-docs/third_party/kernel/docs/
[2] https://lwn.net/Articles/780985/
